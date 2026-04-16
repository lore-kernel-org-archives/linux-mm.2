Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2DE8F8A146
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 10:11:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D51476B008A; Thu, 16 Apr 2026 06:11:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D020F6B008C; Thu, 16 Apr 2026 06:11:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C17B56B0092; Thu, 16 Apr 2026 06:11:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AE8136B008A
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 06:11:47 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6EDEB160806
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 10:11:47 +0000 (UTC)
X-FDA: 84664002654.25.8684230
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id C4C1D180015
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 10:11:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RJ7INZmY;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776334305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YTTJWk+K+Aq1uzwgUGeMzRVATuOoI5XxEhWTOnqCf0s=;
	b=Y1mzAFsLizJnYnldtkJZ2XZH2hn4oMtt5RudqwGRTborekDP29vzshFa2rv0boQ091CYCK
	7+VMZoCnJu2hSaSam/uTda2MzPDLw7P0reVC8BbPxjm1URYZ9rFI4FpIxNrCzpWVGTe43v
	9/Hoig5TsodJGDsJBO6fij5sNmf6LcI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776334305; a=rsa-sha256;
	cv=none;
	b=4fQ5HVhALsl01fQxY+FddbcXoonw/AoE5QqlsRRIuiVWxWbqNhsmzf0536UXE+x9lXr3S4
	NUiSWrYQlOKEZz+dzYjaY43p0JLrehD5mshZG3n+png7DZ6wpzEGHrw0m+XewhPBlidRW6
	/UIQPPzAqR2o/1KrhT4Xez6Ix6BJmbk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RJ7INZmY;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AF6FA44302;
	Thu, 16 Apr 2026 10:11:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03396C2BCAF;
	Thu, 16 Apr 2026 10:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776334304;
	bh=tDQlNqp33Vv3vbRl/wGsiYL5pAAeYqoFYT8dHtrotQI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RJ7INZmYB/NJv4FMsE3K52Izvn2Pb+r2FDROBZaX9ovGiSLbyxYBAW9TVz7GTvwWf
	 wMsa0F3zm/lM6ZpuvLu5U/OThSBn6cjmbglh88oSzH8dX5ttQaHFoZaJ7ObBc314na
	 QkSb88/FK31AfHHqN+JorU/gPDLGOVaM7iWV3G127ENdi22L1hOl3jMqnN3fGTNHJu
	 04YZd5Om0YqcXfj6fpPHM3+47yzVdAM8BdVBTUOLNx5/Ee2iHHV+3jzaxxsbiEk6f7
	 6H8dic+nx27av8+0SXXoyPMRMhhuQONSvAPG+IRswibzN1LlPxwysU4wNQEank3KjE
	 pHcbJL22oPIJA==
Date: Thu, 16 Apr 2026 11:11:42 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org
Subject: Re: [PATCH] MAINTAINERS: Add page cache reviewer
Message-ID: <aeC1zO_a0dL_OLtB@lucifer>
References: <20260415174039.13016-2-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260415174039.13016-2-jack@suse.cz>
X-Rspamd-Queue-Id: C4C1D180015
X-Rspamd-Server: rspam07
X-Stat-Signature: naocn4kagmt4zn16rqkobcfixas796ie
X-Rspam-User: 
X-HE-Tag: 1776334305-485470
X-HE-Meta: U2FsdGVkX19O9sUgPVmDuiLLFRfCwBUS5Sza6aB15ek05TDwesb/pgk6Q7F/cbf+sTKD19dAPtYjvQHCuCnVay3VmNS4GcasaZIJjzPqw8hxq7wisw/7U09/iBZoweozcYowbpahJJ/Att9RMLhBmtW3M0Yj8Z/tbQvoVmj/FYORIcIo68ceNeZy5WPI4xnRmWCOSQsxtBp2Vw1sj1XJTM7jnEZvxExU+c8QAYy/dbFBg1htUUEQ8A+oxgn7SmRkBn7dx1DtuEmgvMVO1pGJosfGo6kVq3g6HYjQ9sieT6XwpxqHANmxNkJmN5dEz5QQhWOVRD63031CeizW7RujIsg00stT/selIf9rMBGpMoRSZIqFzgCNQBe44vC2Vm3vrMN1I2eqQeBrhY2j23qfrgssvPnOlfmRO6dCWYIy7MqFwupPST9dXExR16zFSsjccHuXOAcbU3pGNzU0TuIO0yXQFOZbSxC/zSd05h2nP7nhqMY/RbUJC4BW/keJKRHK7Gh9JawMTCdKbiOkiJdlYx5jjX0CGQ5E775KE1oBa+yoBpT4FoLF0yMgJOg2rQ/NCUEQ94cXOUPivekc1bs3e2B05+aKR71nHQxNSjdszsmyumhpTMwR9LjwRr0ymJHRwLcSqUWdhttWcXB++N/g0OmP+1fy5TiAQHhDIBbbvJmghLfTBChhmrKFMMi0RITCQw6E7REbZSwlvQ3lZPw00tczA+w0I6LqIv9TqBhu9XT3s8x2o0Ns7LviIaLFb8YHzJyZqpUg2vIwcyUHImA/xOFEVzzyXbrKWaBhrl0UMbu33ry3aOoPIv0hsdxSw2As7HMs1djC/59YvGw0Ms9WxuZnGNLLMwz2yFNcD4Mwq3ziqmYEp0cnq96E3YWOLV5JifvsRkK+3oqOVHoP37kIVewps6iORhVNxvh8JT+LSZtA0dbQS76yChkqs0d5mchz3h5dXiK0MIU/gtZn2/P
 XZhACPuc
 haJWKRNxe0tC/dCvgJvSPDFhmYK13E3w33hELfysBmtxUZLaxKRlcNVBn/hPjel5ehHIbUzzgCHaHAF74fbkuPUGXvtRGgScMaqFJd+eHP573qU1V1mX3I05S8+fRm1SI+UfzbcIVPlLLyw3KRpHldw3uqAJ/Olggi394RgBpLiPQh4wyFh7eE1im6Wl97RKZurT0XNkGBNOot050blcwZULAxOcQKe5ZPyY1yT8xeVFcFMd31SQxHYCoZzfmDpEyRbRxqRZUs3M0BEG73rdfsRjJHrY4VoYyTCjTmqZsRg+cR+lGTZn+yoKUgzpeYg/kXnQUVbxW1xl70SM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 15, 2026 at 07:40:40PM +0200, Jan Kara wrote:
> Add myself as a page cache reviewer since I tend to review changes in
> these areas anyway.
>
> Signed-off-by: Jan Kara <jack@suse.cz>

FWIW:

Acked-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index d1cc0e12fe1f..2af750f5f06d 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -19961,6 +19961,7 @@ F:	kernel/padata.c
>
>  PAGE CACHE
>  M:	Matthew Wilcox (Oracle) <willy@infradead.org>
> +R:	Jan Kara <jack@suse.cz>
>  L:	linux-fsdevel@vger.kernel.org
>  S:	Supported
>  T:	git git://git.infradead.org/users/willy/pagecache.git
> --
> 2.51.0
>
>
>

