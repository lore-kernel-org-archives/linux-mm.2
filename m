Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16948CCD194
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 15:48:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62AC48E0024; Wed, 15 Oct 2025 11:48:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DAEF8E0005; Wed, 15 Oct 2025 11:48:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C98A8E0024; Wed, 15 Oct 2025 11:48:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 35E6E8E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:48:32 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C0E2C16021A
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:48:31 +0000 (UTC)
X-FDA: 84000780822.07.B4CC6BA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 319614000A
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:48:30 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="dGT/6glt";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760543310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KZauNHgmA9RtayqW1tVmsC/E8k1/C+Tkz9WYs9KMIgw=;
	b=2ogUjXQ7/zhK8XV/XPQZU/cGrqt0TpPPnqMdbcvjDo+3BiL3Tw0P/ywTX+8xG1jGBUxW8a
	PMybntH6aWtplEkbVrB1kBt6obD5VtbV+SQkIPdz6WkpuYma2DRjhB7q+MMtdOuBHLP4f+
	w0pQQ2WDCtncTubx0+GTM69u01S4qFc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="dGT/6glt";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760543310; a=rsa-sha256;
	cv=none;
	b=auTNQoj54W2nq3Eenj/RDatUV7iC4YPrd2Vaqhdvs+0XtnB5hpPP+9XDr4YzLMyd2nQcjd
	y1B/GFH+Wfy/3NIEUOEs3ZGeBPCr8n5YQcUiWVSxDRS1irXHAiaylpCp9NtH3m+PjWrBRV
	tn66tyrxzO1Yr6WWV+4wPnSVESzITWA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5FC3262690;
	Wed, 15 Oct 2025 15:48:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03EA4C4CEF9;
	Wed, 15 Oct 2025 15:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760543309;
	bh=PcbD53IFifY51gjnE3lF1GZ9oomY08lolU7XOa7R1yY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dGT/6gltZPJO/FyYdlzCYW8E53mSDMc15Fbkhf2G1qeh1fzUiO8x41AQQ2cKyY21c
	 J1xg5b+79/nGS295RKo7cSJ2MicE20a9wDH3GrJGN875lLkXSX23X5E8+3uaep2oKU
	 sANESm35StR8asw4Iwjz5YJqWSLfRnmww36hIH9jjmSlrwAOKUZ79v1IB2uNo3rYN6
	 ofMJIeLd0HfjBZyMTuBcuJgirXGj6fqZktdoYDhb0NWsnbzSwi93u5oqpQ7ejKb77u
	 5NyRQ22RrCf7NsILcn1I0mSqX4ibvgDilMcr6kxwME3Eb4v0WlnQyt3VWNW13T3IKD
	 X/K5vvyFlLAWA==
Date: Wed, 15 Oct 2025 08:48:28 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Carlos Maiolino <cem@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org,
	dlemoal@kernel.org, hans.holmberg@wdc.com, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] writeback: cleanup writeback_chunk_size
Message-ID: <20251015154828.GZ6188@frogsfrogsfrogs>
References: <20251015062728.60104-1-hch@lst.de>
 <20251015062728.60104-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251015062728.60104-2-hch@lst.de>
X-Rspam-User: 
X-Rspamd-Queue-Id: 319614000A
X-Rspamd-Server: rspam03
X-Stat-Signature: iiukfamcda4sqesrn835541hzu5n19wi
X-HE-Tag: 1760543310-858812
X-HE-Meta: U2FsdGVkX19fptcYBKDpTBqjJc2LcoPqx9fU/SWmOM7LAf5SR4krELMVbv7OE60OCwCmX44NAM0+h/RMefcGCx3+LaNWJAmPBfSA24bujcvAw7+r6ucfgnU68kXUL+ay5lpl2K4eeJdG1J+s/8/zTUDWbrg0DoIw+9XwTF8PK6cIjkVCe3c85SvnOUMStJAIrnkouli8BnaFRQnIWVRqNEGzsoHwejsvzqbP7trfnQXFalMJQEcFVaRsvm+ZP7EX9+0FKzj1A7ywmdjIz9+RlzjR97CnI+QJFVqZgpJe9sXqg3yv7MorjvzRYdaCPplp+OQrI+cfuglirAvzFVngNEj5/KqUyxq9LSL4OWLEl9feH7KKIcNhK4xmdtjLglwdina2iU7KL89JyzCMrHEG536xH3lW5OGv/81xDRRXRbAz7GGhNnvCxBhuel4zH+imZ35r/A6H82xdwDrSZQjLhxovGsXl3mHg8asqTMj/lMK2cO735L4YGFyMpcGP3cRHCvbeYbJ4OqG6UfMYtYXjh7ioh5CW8jG16PjzfiLOOvVfhjhwzCWcqzV5K47s0R6D+mV6fTRIr+RdIxhWI7M47lMQin/MfbjtnyC6lS6ipQqSf+lliIGOQ1noPjrdAG1gyKqUuPoXbRu9+Ozls/41ojAAC8DW39Qgw1PlpbDpXvLs3iivMI4jidYnaGEURVqHqfj9vBgv8minqCDlFhxNtTisr4ZdL730kdhGQ1w9y07gjVFAJ6L64mvt5jhQearNOuB6VPEM5nJ4ZfuVUAuK1xgo0GRk/NUcedf+Ke5W4Xc4jv4+mi8nbE63JhDzrclQWLbAxD2adbObBkKYVD0YZ9z7jwmBHIGBxvIEyHcAelIOPzd1cYxsV/k9ssTgV/le1M+5+nM02IJDsDz8wHxFBbvfgxWTUB2cM85WvAc+H7LlXQ0XRlmnGKYV8iWfEm4bayq4Mng3hfFcCVPJP64
 jABpRC5X
 AeecYwowzwg9jOL38UIfAdnXhPUX2zNtXdVcRx+0G6BoLARrnkUQX3bhVhe4mhNmkZ36yA/e7OYIJTE/EUml4Onkq2CIHU/rJdP/D6w11dDTfhTbWwQxnNwQ0Ts6NVFSXc3lXKJ80V3lRXp/Uw0LNuNcZjtQBdJMOHgnpd9eoQH3a6Kyck03a+/oKDnDcGuQZoatDymqQlHitNOgDFLb8yoC4C/ueNDN9ebbthIUf38bDrv3UB2wfeRrTUbzY1zYEj560JsOH9cCcfsFjwAWvIMyBWkoyFfDF8JVnF1KMsLFq4VJrps4t7g3NydgYhID6Pfsu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 03:27:14PM +0900, Christoph Hellwig wrote:
> Return the pages directly when calculated instead of first assigning
> them back to a variable, and directly return for the data integrity /
> tagged case instead of going through an else clause.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks pretty simple to me,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/fs-writeback.c | 14 +++++---------
>  1 file changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 2b35e80037fe..11fd08a0efb8 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -1893,16 +1893,12 @@ static long writeback_chunk_size(struct bdi_writeback *wb,
>  	 *                   (maybe slowly) sync all tagged pages
>  	 */
>  	if (work->sync_mode == WB_SYNC_ALL || work->tagged_writepages)
> -		pages = LONG_MAX;
> -	else {
> -		pages = min(wb->avg_write_bandwidth / 2,
> -			    global_wb_domain.dirty_limit / DIRTY_SCOPE);
> -		pages = min(pages, work->nr_pages);
> -		pages = round_down(pages + MIN_WRITEBACK_PAGES,
> -				   MIN_WRITEBACK_PAGES);
> -	}
> +		return LONG_MAX;
>  
> -	return pages;
> +	pages = min(wb->avg_write_bandwidth / 2,
> +		    global_wb_domain.dirty_limit / DIRTY_SCOPE);
> +	pages = min(pages, work->nr_pages);
> +	return round_down(pages + MIN_WRITEBACK_PAGES, MIN_WRITEBACK_PAGES);
>  }
>  
>  /*
> -- 
> 2.47.3
> 
> 

