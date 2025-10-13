Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3DB9CCD185
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 08:03:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC3548E0014; Mon, 13 Oct 2025 04:03:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E72708E0002; Mon, 13 Oct 2025 04:03:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7A9C8E0014; Mon, 13 Oct 2025 04:03:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 567938E0002
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 04:02:58 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0700486BDA
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:02:58 +0000 (UTC)
X-FDA: 83992350036.23.708D61D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 54228C0009
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:02:56 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uEaoIvCz;
	spf=pass (imf28.hostedemail.com: domain of dlemoal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760342576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aJ3AGYAZpwp+EfAJMfA5wPfaTGW+vNoP7zI3wmy2x28=;
	b=kTqeC5U9YNJPmfgMFEtjLb/dKCcap0Z+fQaakgszfiX7KXaBj4RBRIlm98jWWhJTnua4LV
	nuOZRwfbOI1hrvrQrLnlCtAk2rbGoOARRTCYSwXM13HF5FmH/fCqiX3FzK9/xPunxjpqJ/
	qT4j84uTb3V6tNALEDFUO9x3taQhjKA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uEaoIvCz;
	spf=pass (imf28.hostedemail.com: domain of dlemoal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760342576; a=rsa-sha256;
	cv=none;
	b=iklY87sNt3Dr/VTpAfJvxCfBL+7FAlu8bH4qpNwcToln2/N6Riv/NL32CG0GUNfnX8vlpx
	aSrqTuBkgkklCyfieyp8e3lObDlxJaccdQnuGSEB1DMVpSeJAL6UN4IRGfo0sGVNeDGUkG
	MBBR3rp4aGvauOMIzwYrkrAciW/3CRk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 99FEB61109;
	Mon, 13 Oct 2025 08:02:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA8AAC4CEE7;
	Mon, 13 Oct 2025 08:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760342575;
	bh=JmTNokf/Y0BVZcHoL0mzR2f+X5eoue5G/y7OJfo9XEY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uEaoIvCz69w/jGeDcmPCeRev/Gwhggq2w1BemWI2FV+vIIHgCZfedXZbDbxig3nz5
	 YEEvDrPMNVBhGkDcdL4D7+afM7BS+U46TjfzCfmMUbUq8wdnxVxu/rWwNSUsmNBrC0
	 7q4NDle476VCpxVswTJQZFdwb4gtB8qjIWs0OWDqhvqSyu+sejmM4W+nqXYX6OWB+w
	 3YX9DQddSWJp1CG+4QkrvP2HQBNffvVwG/IsXhshs81RHld94oUMNzNcn1Jpka4F1G
	 jioX/6pXoqtfgFVvtKO1hNkmKs4EOzqrcSvW3e8KZS4/9HC3na9qgqxYjI90ASKhh5
	 o2Hqr/Il6R4Mw==
Message-ID: <4e508d42-9cd4-481a-904f-535b1de0b765@kernel.org>
Date: Mon, 13 Oct 2025 17:02:50 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/10] mm: remove __filemap_fdatawrite
To: Christoph Hellwig <hch@lst.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov
 <lucho@ionkov.net>, Dominique Martinet <asmadeus@codewreck.org>,
 Christian Schoenebeck <linux_oss@crudebyte.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
 Jan Kara <jack@suse.cz>, linux-block@vger.kernel.org, v9fs@lists.linux.dev,
 linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
 ocfs2-devel@lists.linux.dev, linux-xfs@vger.kernel.org, linux-mm@kvack.org
References: <20251013025808.4111128-1-hch@lst.de>
 <20251013025808.4111128-8-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20251013025808.4111128-8-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 54228C0009
X-Stat-Signature: qhowxh4f5c61et9h9tf9z8s5585u43of
X-Rspam-User: 
X-HE-Tag: 1760342576-438997
X-HE-Meta: U2FsdGVkX1+0hse8h0ZITqLXJasEhDO7YH9W4cJ3OpSv05wmwTVbrUSnF2pm683IKOcg0m3DBuE7XIqfgXWWy9E7KIrVQkE0JBr9gPm8OsiI+ksiAq/mKtevh+P9kN8n8E97LSCnWFvleONozsi/KZFdaP+07WvDhWMDhqHMh+ckT/WYoH86MRgwMbQADRud2rtwmbGS9LLWLqmg+/6Y4lcXSBzWXSXriugieDQ/Yo3EwcVRyYnRE6Q19ZgZAo3TnDjG2jXuEykSgKEWBDZGcT+9iUI9rDRfX4Kl3Bfw1ROpNMPwkYgw5q53Q3T152Ko2taKLE6JOk1+C4BGbJkcnrmqNs3OKUO9YY5fI3vm3vQbDsU+Uu2YbHDmHObNlpUuir9X6pyYmcudXHtkNpGxibjkuIEsIiVvIY4fQ+I+r905g4GaxSNk1lJ1hzr8xkcJeW8RVspBPUFW81WuwHNgMm3nHtKVWq+GYrmZbgEek5Jrlot9rHTUJzUoUTXUwl6UjCvS5GrPMtm0lakDBkDtAE4frZ1KoHDli503qfVOZJbIAFG0Seov+NcGE1DYMaYvrPkkbJxPN360XRwrRKOBirGNVVrOL1xSUmqPuks69DB1u5ZmU47FoEwjarUGufzsjOn7J+kFjXkhc1AgBYN8tOwnaEoLo6Lscb9AKEhYtpkZyE95YWB0YMuXV6cLvAfajO1AwoPnpu1Aq24H5KYx6EWoqAQdaShvomRUAaBYrPljNXM+6avViC+I5/ZnPQvRM4Qkmm2YCyNJ9CtsR6QOxw1c4MkYD7hd04tYxQNmNIZint3g4L4XWjKYVoE9507xufFIFnKk6u70wEki5+SOaPJMqAdb2OO3W4Pol3+T9DXEwMwVzS/tlwO/MAlkpEbvesE9bVhORjHTfMwQhD/v+EZEk3NWznx41M99UJJ/npClTjbDiWlTV/XfXr0zltDXRqAiCCyKoRS980bqDI6
 JONwZ+m2
 HCzhd5tAG02GV1Hs/CLCEK9/3DCFMPi8507BbfeNJdIeGfDnwORIacCcdeHpabDGKLrsISmA30lHhnzXjkdNORoYc3Q9sUhDnRCTb28SHt/m+cvEyTKvimjuMQ7d4KQ+UaykfoF2XRZRZ7z0dVdRa0sH4gyW+jf5tU/qnZSxczCDHgnanFfIrjOprcwl2HLOhOHtKxfHhcrRTfnO6zwjKady+HYIm630XJCh9zxPm5qqG+jSfHlgU7/t6+euqRIzGZaHMUrxhhDIN+K45lI1Y165siJqUYLh2saFKEye5qxTdOQMARRTB5Iuil1X2uB9t57d0ubuiGzDa85fdVlzoS9uPJ6iv2HBLQWuKx1rjynseVfWm8n0QgzeV0g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/10/13 11:58, Christoph Hellwig wrote:
> And rewrite filemap_fdatawrite to use filemap_fdatawrite_range instead
> to have a simpler call chain.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  mm/filemap.c | 18 ++++++------------
>  1 file changed, 6 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index b95e71774131..bbd5d5eaa661 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -422,25 +422,19 @@ int __filemap_fdatawrite_range(struct address_space *mapping, loff_t start,
>  	return filemap_fdatawrite_wbc(mapping, &wbc);
>  }
>  
> -static inline int __filemap_fdatawrite(struct address_space *mapping,
> -	int sync_mode)
> +int filemap_fdatawrite_range(struct address_space *mapping, loff_t start,
> +		loff_t end)
>  {
> -	return __filemap_fdatawrite_range(mapping, 0, LLONG_MAX, sync_mode);
> +	return __filemap_fdatawrite_range(mapping, start, end, WB_SYNC_ALL);
>  }
> +EXPORT_SYMBOL(filemap_fdatawrite_range);
>  
>  int filemap_fdatawrite(struct address_space *mapping)
>  {
> -	return __filemap_fdatawrite(mapping, WB_SYNC_ALL);
> +	return filemap_fdatawrite_range(mapping, 0, LONG_MAX);

This should be LLONG_MAX, no ?

>  }
>  EXPORT_SYMBOL(filemap_fdatawrite);
>  
> -int filemap_fdatawrite_range(struct address_space *mapping, loff_t start,
> -				loff_t end)
> -{
> -	return __filemap_fdatawrite_range(mapping, start, end, WB_SYNC_ALL);
> -}
> -EXPORT_SYMBOL(filemap_fdatawrite_range);
> -
>  /**
>   * filemap_fdatawrite_range_kick - start writeback on a range
>   * @mapping:	target address_space
> @@ -470,7 +464,7 @@ EXPORT_SYMBOL_GPL(filemap_fdatawrite_range_kick);
>   */
>  int filemap_flush(struct address_space *mapping)
>  {
> -	return __filemap_fdatawrite(mapping, WB_SYNC_NONE);
> +	return filemap_fdatawrite_range_kick(mapping, 0, LLONG_MAX);
>  }
>  EXPORT_SYMBOL(filemap_flush);
>  


-- 
Damien Le Moal
Western Digital Research

