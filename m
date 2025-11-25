Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E3A5CFD315
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 09:33:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67D116B002E; Tue, 25 Nov 2025 04:33:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 654756B002F; Tue, 25 Nov 2025 04:33:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5915B6B0030; Tue, 25 Nov 2025 04:33:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 488736B002E
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 04:33:43 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E0BBE13AFC3
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 09:33:42 +0000 (UTC)
X-FDA: 84148617084.29.7962DF2
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf14.hostedemail.com (Postfix) with ESMTP id 86831100012
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 09:33:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=N6sYr7+S;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=KoLINEIS;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=lWYCjnHI;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=MHc3FMVj;
	spf=pass (imf14.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764063221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=voGsWdT/TADa/XNKkRB7q0zQKzAVaHz4j72C+7TpNOk=;
	b=V65e/cEE7i7/w1jxMR/ZMVhbOiMf2lIYr9CTpkdtmnbrULoomlpdWvqky/ya3MRlmH8KfG
	gVk2RAVbgSPffDOd3Glm49sHBE1hieptoM5jJS1XhjfFyZZPuUaKh4Qxc68hPH6HywOqix
	fNCg3BoblzMl2X33HlJGMZG3r6Co7T4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=N6sYr7+S;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=KoLINEIS;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=lWYCjnHI;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=MHc3FMVj;
	spf=pass (imf14.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764063221; a=rsa-sha256;
	cv=none;
	b=mWs2W/RwcVkADl4KIFUfTg9s/m3Pr+yuReSwFxsVJlmMcn25LpFpFM1VslDLNMg4U4YvYk
	qS++OIoolu/Ke9cwfuAgu6w9oFbcU8SDMZ90nr4hlsvVNOwq3Qs/6CEjPDFViWL+KvtIgA
	06WVqc+3Z5eW+XkEE6GU6PN+e7et3DM=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5FDE822550;
	Tue, 25 Nov 2025 09:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764063218; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=voGsWdT/TADa/XNKkRB7q0zQKzAVaHz4j72C+7TpNOk=;
	b=N6sYr7+S35XIvWbY9Dw3p2lG08suPP6KvOvmsNdce3b4Mqu/AbUJcLNeu62Xk4bu5a9tAg
	SEJoFMAO9Y+veerePRpfEVd8udxIbTGaz54lmw6DFeZoFhEcGkN2IBRWPhdXrTFF1M1UJM
	RLYt0QqPvzq9P/ZXwY6peaEnRz9xkio=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764063218;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=voGsWdT/TADa/XNKkRB7q0zQKzAVaHz4j72C+7TpNOk=;
	b=KoLINEISLY9Jec+kwZYoCDJGkwwP5YAe+3K9l4ZDa8KuuK9Y/zdbFUnbfHbUvEh99eRxQ2
	BPHVOdjs7MeEbtBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764063217; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=voGsWdT/TADa/XNKkRB7q0zQKzAVaHz4j72C+7TpNOk=;
	b=lWYCjnHIWZBMsS6UKx6RETYfnvd0jCOI3K2OEl6yJjnNfHtKU3U1kDPcV4Y9VBICs4aKit
	T1cihKATN7Pl+DzNu7Mzoa/wAChodfi8kt6gxKUsLYwlOrThjec0Hqno88OjGcN9nzZ9/j
	NU2HEinGB+H9+xkTBviEJ2D9Z5aJSjY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764063217;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=voGsWdT/TADa/XNKkRB7q0zQKzAVaHz4j72C+7TpNOk=;
	b=MHc3FMVjNF2+NlJv5Q8a3wNlzaJTV+3SCFptkiTEfDvOR4sPJgSjwkeIkqskkNeHDjQ4hC
	fdAlK83ISqSK8bBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BEA5F3EA63;
	Tue, 25 Nov 2025 09:33:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id U63GK/B3JWlMRQAAD6G6ig
	(envelope-from <osalvador@suse.de>); Tue, 25 Nov 2025 09:33:36 +0000
Date: Tue, 25 Nov 2025 10:33:35 +0100
From: Oscar Salvador <osalvador@suse.de>
To: Shameer Kolothum <skolothumtho@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, muchun.song@linux.dev,
	vivek.kasireddy@intel.com, jgg@nvidia.com, nicolinc@nvidia.com,
	nathanc@nvidia.com, mochs@nvidia.com
Subject: Re: [PATCH] mm/hugetlb: Fix incorrect error return from
 hugetlb_reserve_pages()
Message-ID: <aSV371RAc5mrR84c@localhost.localdomain>
References: <20251022102956.245736-1-skolothumtho@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251022102956.245736-1-skolothumtho@nvidia.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 86831100012
X-Stat-Signature: yybag1b4pa5meqpg56699dpr1wmujkbz
X-Rspam-User: 
X-HE-Tag: 1764063220-994
X-HE-Meta: U2FsdGVkX19R5Z5LqkKTQcmYSeEeyhQM0JfGTgz/V0/BU9HSATMuE9DJ0FbPxRcz3QxizGuqyahW1/xrLTUyDOdRxiJ/iVJlqgoDjVAnLW6nIFC+T80sZ8asCsl/Wpa/qBz27nTPJkzKAxVGjpFnzAlHo3mo2LhfsmFH133Gq1HypIvX+5zhGYpaeaQrajWJ/bgUw3u6zTWVqjfPirbhKNxPL91XyYFS/pjSwSDDILLZ3k/YQ/dwEoZAtuKFgckaIA1Qe78f6IoHTEnMWoWI9bQ7ZGdpADrUPFUNUCLr37o/NXtcOhKU9j+FTTgyyIoohDLmBscp+Q3wlA1b2z+yYbw+IFBcr1sMZs3OPBQI6HdqMgvmRswMfjZJkGtRJ/QcoSP+RaJD6ZbLoK7Il2PvG6mOEbQXrh9JEBTkoh0gvxOwKWOLk8WcH8Ofsrlq5fn0A7EJVMixU0k4Toc1NwnWjHRKSgy6xm43OuRJPoDd6K05vy3UruHbHWJ0JLMIcCvpoXlM0xVfrZB1U+JRS0J2M1hPo452oPmMKmpyjFTs7H3hmYSj16UR4Z25ARTxZ92sIMA1OnwO5rUoyEIrNjAZOXrYU/ErLdoBWEXf2dMISZ5KSDwBi5ie0l9Tx5WhaysGdqi6WQjjOeGfBT5oD0e2pFqdzFTAgsD9pRwP3b0DAUnhb4gFY+0YHsNgj69YCIU9O3fDaMrLB+W/eJiQAqazasY6mfSo/JJ7En0TmzxYH0Ix0MlfoL1f2IE+htIDZrDjpLOxW5QJ/7am/s56cI4gofo2RxXCMf2gi5Q8prpoFTQy2FrgghN+6t7CHXFAw62RBif2iY4gt9xrAb9plQpEba+PuIn1ab4SmSyvnVXYKR5YfqLhHcy5gn6FTFFxtaGwLTXL1v3Y7TyPjum/5vr1NGAAXCXpIbPb1555p4DswOth6zXtpWRUqWDRUHsSc1lyLbElRAxgGuBjbmaEkvm
 ydUk/DAD
 Cp/ndGJPc6w5unQM17TP8PLs67LKsN7ZkKpaOKF5MGv5/FstQ6i0UKJ/ASTh9CaWJSfKSUGpYNCwB7XhFIUa8wVBzaTIFNooWIT4ZfASX7FdZZbQCSQoO9RzaU3jaRICyNiJ/CP3nBIIKfDxRfFA9Iyi7jJ4I1EO9mctdLToqm7aRb062CY21FBF+22MJ99dJYx0qhHugjobJ/Cr549+jXaSPpV0mI5o3hjR14h3Rokkfn/pLLtuysrQkZWkq3xL71ptWjaUnL4cVeVWLSyQnSgWas17WDIoZvnxQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 22, 2025 at 11:29:56AM +0100, Shameer Kolothum wrote:
> The function hugetlb_reserve_pages() returns the number of pages added
> to the reservation map on success and a negative error code on failure
> (e.g. -EINVAL, -ENOMEM). However, in some error paths, it may return -1
> directly.
> 
> For example, a failure at:
> 
>     if (hugetlb_acct_memory(h, gbl_reserve) < 0)
>         goto out_put_pages;
> 
> results in returning -1 (since add = -1), which may be misinterpreted
> in userspace as -EPERM.
> 
> Fix this by explicitly capturing and propagating the return values from
> helper functions, and using -EINVAL for all other failure cases.
> 
> Fixes: 986f5f2b4be3 ("mm/hugetlb: make hugetlb_reserve_pages() return nr of entries updated")
> Signed-off-by: Shameer Kolothum <skolothumtho@nvidia.com>
> ---
>  mm/hugetlb.c | 25 ++++++++++++++++++-------
>  1 file changed, 18 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 795ee393eac0..1767f7599f91 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -7269,6 +7269,7 @@ long hugetlb_reserve_pages(struct inode *inode,
>  	struct resv_map *resv_map;
>  	struct hugetlb_cgroup *h_cg = NULL;
>  	long gbl_reserve, regions_needed = 0;
> +	int ret;
>  
>  	/* This should never happen */
>  	if (from > to) {
> @@ -7308,8 +7309,10 @@ long hugetlb_reserve_pages(struct inode *inode,
>  	} else {
>  		/* Private mapping. */
>  		resv_map = resv_map_alloc();
> -		if (!resv_map)
> +		if (!resv_map) {
> +			ret = -EINVAL;

Why is this one EINVAL? Should not this be ENOMEM?


-- 
Oscar Salvador
SUSE Labs

