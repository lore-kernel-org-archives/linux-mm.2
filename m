Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13058CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 08:09:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D1AA8E000C; Wed,  5 Nov 2025 03:09:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 682C78E0002; Wed,  5 Nov 2025 03:09:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54AB48E000C; Wed,  5 Nov 2025 03:09:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3EE7C8E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 03:09:28 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DFDA416021A
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 08:09:27 +0000 (UTC)
X-FDA: 84075828774.05.CFD37C8
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8ADB4C000F
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 08:09:25 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EX+6Jch1;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JyyxKulT;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EX+6Jch1;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JyyxKulT;
	spf=pass (imf28.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762330166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fbqylo7WUnHUa1a/J/cN4xDOUpa0GCrOWk49qqeOji8=;
	b=ey/K7V4qiHK60hpWFzF7HdRpUNgEXEN1FuNwM9+a253pZZDkXrUk1e9SbuAzD1HIYaQ43I
	fsnCaHz7DBa9zQeFcLo6gRB1N6BDx+LWAAGFtFSXD56/P0Yja5xrTutzruBUYMunozjaNH
	TXpLVe8r95Ff6ERJESXMeVHUQ1dRbhA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EX+6Jch1;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JyyxKulT;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EX+6Jch1;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JyyxKulT;
	spf=pass (imf28.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762330166; a=rsa-sha256;
	cv=none;
	b=P6u5G0lBLvo+EINDr3QfcJV+he/F93pZ4Fe7pcsPlO+GDNDBV4LJDd78mg9CC//3m+sWZc
	xTgCJn4pEoxdW6nQJaPCQv/SG7b57kXGxwgI5tfxOfpGlKngzhcvoXit0uNgyMlkvAm2MJ
	AkMYRqfiFIaZfIq31RnZlqaGe5VF02E=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B57991F394;
	Wed,  5 Nov 2025 08:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762330163; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Fbqylo7WUnHUa1a/J/cN4xDOUpa0GCrOWk49qqeOji8=;
	b=EX+6Jch1+2dAAy5u9xZ0Bfqs+fwRp7/rwEBuUsxhwVlThVUUGv3xuf9n2NerCCDedJNfDi
	9odvQ09zFZVUc/VTCix5vMfV09udkpBfVezDk3tjVvvX6fzHZipgiEr+5LI77R6jDvORZD
	HV/faMEq4VPyxj5z6mJHz9UCK+0AS9w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762330163;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Fbqylo7WUnHUa1a/J/cN4xDOUpa0GCrOWk49qqeOji8=;
	b=JyyxKulT/wRdYNVGZ/7/epytwlS9HSJDP7huC4whRYMWoxn+w6qEYYGl2YtR/dTvhmOlpP
	Aq0m1urLx1hWQhCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762330163; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Fbqylo7WUnHUa1a/J/cN4xDOUpa0GCrOWk49qqeOji8=;
	b=EX+6Jch1+2dAAy5u9xZ0Bfqs+fwRp7/rwEBuUsxhwVlThVUUGv3xuf9n2NerCCDedJNfDi
	9odvQ09zFZVUc/VTCix5vMfV09udkpBfVezDk3tjVvvX6fzHZipgiEr+5LI77R6jDvORZD
	HV/faMEq4VPyxj5z6mJHz9UCK+0AS9w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762330163;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Fbqylo7WUnHUa1a/J/cN4xDOUpa0GCrOWk49qqeOji8=;
	b=JyyxKulT/wRdYNVGZ/7/epytwlS9HSJDP7huC4whRYMWoxn+w6qEYYGl2YtR/dTvhmOlpP
	Aq0m1urLx1hWQhCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7467313699;
	Wed,  5 Nov 2025 08:09:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fDUHHDMGC2mPSwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 05 Nov 2025 08:09:23 +0000
Message-ID: <190f06d4-022c-45f2-abd8-66dfc20223e5@suse.cz>
Date: Wed, 5 Nov 2025 09:09:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: don't warn about large allocations with
 __GFP_NOFAIL
To: libaokun@huaweicloud.com, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 willy@infradead.org, shakeel.butt@linux.dev, jack@suse.cz,
 yi.zhang@huawei.com, yangerkun@huawei.com, libaokun1@huawei.com
References: <20251105074106.3508870-1-libaokun@huaweicloud.com>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251105074106.3508870-1-libaokun@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8ADB4C000F
X-Stat-Signature: ttztybj8swq9q6aik41z5sm37kgbe18g
X-Rspam-User: 
X-HE-Tag: 1762330165-92710
X-HE-Meta: U2FsdGVkX1/61OoyT0os3pv4odqhrEqnxEVQAI+dldhYc16cbyXtGejbCJjxElZ/ASE4LR4pBWktJ01XWzjfKwLXa8vlBxV3Us8Gl3uflBiqm0AvtdJkUGfyF9q2zqpgWpFnG8P65AJQYTqmXliNJ2bKjEcRsm02lp6/oe2nOuzk/2oCP0/Fs9+utvCuwIPljGLBhN5j3XvPYIXxVdpLt6+p8dC1RvCDgoPnkztfL96oVWVeCH523Zohxgh+NvJie7k2XvoOW4zWRBSOffJUuEXtbkPF9yoH9a38ZyxrrGoTrY6HcUo9/uLybGLOtxBNkkzWMyPBuFz1JOG5nMX6MXdYG6lSuH7e4uPWkyFZPE/2jlf8aQBwyQK2duL5DuRy8l2gRZ6oOrfTCd81eryzsXxgsOzZSngziS9cbDJcI+ZmXgApg7NvrVfnrA686cmEExnhJkKBhG3+2z5z1x3vloJzA5SoqEOz7Q1YtWLLAnT2I19L4EQiGs3WzoTmIlAKmfippWbmRGVXSGpPbE2ceVsZQHV7zg9OQABmVxD4ebWUwsUbBXp6SiwW/y83XTxM6B4ATmdmsKzRARwnhnFFBM9Mac4FJrNVVj69e+ts8phps7IueR70cI0iJwkH5bm/GNvjsQe5J5jwLmWJWAkylciKLkhum5npHm7VbeTfA07tSfY5zb6K81bgKEy1WGnKo/LX/5BHUpVPs7Xvsnsu3U7WbsDKstvJkzaQWtExUQcMF5ySc2knUfyEAKCMOUAdras0lp21zOP2ZW0EBx89Qq0DnHYpxTY4Shwc5ed1iUJj14XUN9McYweM6V/0eocyOAfwn71+AnRMS/eUrWqvSImY6iS88GT0r8EBSMI/+JTXin2TXuaOB/nVXLAPMziqm3FbRyflKVun+A7Zn76Aw5GfzG97nCRa6sGM8CEfYHt8Dv18qrCEZfSybyztpIbLfcGF5RRNFEHr1+nB637
 fQio+hT8
 OVZJmoQH75xxueAhVYdpDaihaW5cWndkw19MFe5ZPLgE4r1SjIZ87aK85JRmyJERjbS84xrp7OU8OIaWvi0Sb54rfEAb3lSC7qr+5wHuN5Aiu1G4taR0dSHhyrl+zHROrXijkCcoGwGcwF/HDXbN/kK2nlTxmSKFRFdi/geks1FinWP2489tQlWK2BZ60g9Zy1pZTOjpUDQDFqLwKprw1NuADMstzmY29ldQSWKvDdQvXBfmQcM8QMpR8PCHsbOtPwmTNBQMVVN+iM03B0hCxXJjawKT0mvU0YVPvt4GHHD5yLXt6RYks6mCi7uaWHK+BY12bi1Dx/nFOiD0iL/iKYa5cXEdn12PS/0GdkOM65/0bOzcFMqjzUWO65h9wRiunt+kpK7mw1VDwePeI0JZj9LWAWnChB3wMQmNYi/H/pk6kHAHTGZNhGpSC1x7JT6Hi4wVD7RZMBAsyW+ZWy7lXqCyx0xYND/LBoBc9QJEqZ01VA+MXY9HXLMXIcHgsMDCWMdLuAjzIHQp1qHc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/5/25 08:41, libaokun@huaweicloud.com wrote:
> From: Baokun Li <libaokun1@huawei.com>
> 
> Filesystems use __GFP_NOFAIL to allocate block-sized folios for metadata
> reads at critical points, since they cannot afford to go read-only,
> shut down, or enter an inconsistent state due to memory pressure.
> 
> Currently, attempting to allocate page units greater than order-1 with
> the __GFP_NOFAIL flag triggers a WARN_ON() in __alloc_pages_slowpath().
> However, filesystems supporting large block sizes (blocksize > PAGE_SIZE)
> can easily require allocations larger than order-1.
> 
> As Matthew Wilcox noted, if we have a filesystem with 64KiB sectors, there
> will be many clean folios in the page cache that are 64KiB or larger.
> 
> With gfp flags and order already included in the OOM report, both
> Vlastimil Babka and Michal Hocko suggested that we can take the risk of
> removing this warning first and then observe whether a large number of
> related OOM reports appear.
> 
> If that happens, we can consider adding special handling in other places.
> 
> Suggested-by: Matthew Wilcox <willy@infradead.org>
> Link: https://lore.kernel.org/all/aQPX1-XWQjKaMTZB@casper.infradead.org
> Suggested-by: Vlastimil Babka <vbabka@suse.cz>
> Link: https://lore.kernel.org/all/188a95ba-6384-4319-bb74-c0d9ec6c4079@suse.cz
> Suggested-by: Michal Hocko <mhocko@suse.com>
> Link: https://lore.kernel.org/all/aQotQBjnDDeL_wHx@tiehlicka
> Signed-off-by: Baokun Li <libaokun1@huawei.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> ---
> 
> RFC: https://lore.kernel.org/all/20251031061350.2052509-1-libaokun@huaweicloud.com
> 
>  mm/page_alloc.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index fb91c566327c..e4efda1158b2 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4683,11 +4683,6 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  	int reserve_flags;
>  
>  	if (unlikely(nofail)) {
> -		/*
> -		 * We most definitely don't want callers attempting to
> -		 * allocate greater than order-1 page units with __GFP_NOFAIL.
> -		 */
> -		WARN_ON_ONCE(order > 1);
>  		/*
>  		 * Also we don't support __GFP_NOFAIL without __GFP_DIRECT_RECLAIM,
>  		 * otherwise, we may result in lockup.


