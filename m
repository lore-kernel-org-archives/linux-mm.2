Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6140FCD343F
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 03:37:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 902C06B0005; Tue, 12 May 2026 23:37:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B35E6B008A; Tue, 12 May 2026 23:37:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C94D6B008C; Tue, 12 May 2026 23:37:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6E92F6B0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 23:37:10 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B9922406DE
	for <linux-mm@kvack.org>; Wed, 13 May 2026 03:37:09 +0000 (UTC)
X-FDA: 84760985778.16.172BD7D
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7EE231C0008
	for <linux-mm@kvack.org>; Wed, 13 May 2026 03:37:07 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Bey+WXoR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=k7DSOWI8;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=R5oHLi57;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="HM3JV/qX";
	spf=pass (imf20.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778643427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xIrVUliI2fByjlT/hi1CcJy977vyveqaasEj+ougrrQ=;
	b=Ksz6e/9n+qRVpPds3MXsz5C0SgyssQ8uc2Kch1TDJYCEEtD2owNu2uDB2OAD8YBt7NbxlB
	nPzgjLj8dDyt2O/5X4qT1qpAGSV674UnUbBsK26qagm5jhvKElH2qlCenY9m84Gv2ge7kG
	YADDBqDiPFHt+HNyUd5O+3K/NFI/ZsM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778643427; a=rsa-sha256;
	cv=none;
	b=Rors0Woh3nPFz8n5qWCtHaBRZFeEfm7SOk03X5oZ8FoR6UhXZuHxh8RlGh40kxg06HVe3k
	bbrWWTORoGeeEwQoMIkl3wmGxzqDVDWQnTjFzlH4pV/M43d8ldEQJkeOsNQqkEtjAKAAyn
	vCIXywx7Ak8J0KmE1rG7EaWChGerW6A=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Bey+WXoR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=k7DSOWI8;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=R5oHLi57;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="HM3JV/qX";
	spf=pass (imf20.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CBC186C257;
	Wed, 13 May 2026 03:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778643426; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xIrVUliI2fByjlT/hi1CcJy977vyveqaasEj+ougrrQ=;
	b=Bey+WXoR75ytbq4WDmuqqZwTbov7wbnYhidmHQ1sFOwNfr61TKpDJhafReVfvAPao1Mhtd
	JDKpSBYAC4LSm+7BcgaL7/baXRjbrojGVMWjazze/95BztPdZOFHbDz2Wv8kxVKZ5ivSKu
	dBAAwcmUhu4qqng8qlUX9oqYSsYEe5c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778643426;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xIrVUliI2fByjlT/hi1CcJy977vyveqaasEj+ougrrQ=;
	b=k7DSOWI85LtgFbX9un5fXvsL0BKYh0yAvP5HWWpKduH46JKvl9LIJmGrQPikbTKSCfJdtn
	lsWBs22Kd+BuZ3BA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778643425; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xIrVUliI2fByjlT/hi1CcJy977vyveqaasEj+ougrrQ=;
	b=R5oHLi57OEqSKzmWqbFL4uXHH9CUuE5OO8vNMy/T684MMDf30t9qZZVWHPr2n5cWoVDe48
	ZizFpVZ89+tOIugmcnPglWxYB0wJOtc3zpgqoloROGapNliQwZNOHxDXNktP09L70JFfws
	Ely9NJla9ZptslIySKAjuECcqg46ejQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778643425;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xIrVUliI2fByjlT/hi1CcJy977vyveqaasEj+ougrrQ=;
	b=HM3JV/qXOgA257YPyr6vc106fkbXeUTfXGoYuNB4CN1O9iFI1wtSychQ1I4UNscxM8AEOD
	LS85o9BWuFL+WxDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5CA54593A9;
	Wed, 13 May 2026 03:37:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mrfLE+HxA2r1EQAAD6G6ig
	(envelope-from <osalvador@suse.de>); Wed, 13 May 2026 03:37:05 +0000
Date: Wed, 13 May 2026 05:36:59 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Ye Liu <ye.liu@linux.dev>
Cc: Miaohe Lin <linmiaohe@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ye Liu <liuye@kylinos.cn>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH] mm/memory_failure: use bool for hugetlb indicator
 in try_memory_failure_hugetlb
Message-ID: <agPx2woN458Co5Us@localhost.localdomain>
References: <20260513024853.65566-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513024853.65566-1-ye.liu@linux.dev>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7EE231C0008
X-Stat-Signature: ci5z8e9so4y6mqpke8d64h545883yps6
X-Rspam-User: 
X-HE-Tag: 1778643427-415935
X-HE-Meta: U2FsdGVkX18vh/Dcl3WhjkiOt7PeVy/29abJbe6DI3+YdQW2lzdPcXinzSenzsG87odvuEIY+1Xwgi/cS9kRf7mF/vzS4wtwDReXPE+T90m3h3c16Zq7o6+/Ipvfv/i6YAM/S9Aq5pYtB0W2cuCaobPux/2LrnKMgGyzQYoJY6VUR2iCqhwZIvrAKsGmqgJ0N+N116f1MXg5JxmUZhqM9tH89qAeXHVBSNd8PYnfSeb5FXqgJQRLAePRVRUTsA/IYqyeD0vlmU4Z4XWkQqNHJXOcTT2AzukgwNoEtzKH9bRDvzQo9WUZl/ZRrSbqRoMuU/alpvXANtZnSr3uG9U4+gs7ilDngoIqy8l/4D9HHBOhAKhtimNmYy70SyK3Q+xQ+ys2m5Z4A5nAbnHe9rcsfVc/8h3gCY5iimVXcmBey4UMBVgkDHKHLaaiH7NBY5gJNlbAxNwvjfx7WVI6c7SSFXSU48mTXkDfbXtYXmFYFsYystd7/UmSOTysuVLWD9cA23bT9E1ZhYNPkIKr3DzvbNe8VipWrrCYEFnabTPbQjWz95ROCavRLJvo1YdWGP130RxO4ggyDwyur0oUoIiEws0ZAft942vN0w/D0xVwOt4Bf8EDE+oJiYOBaCPKYkT7+i75H8vLBio5sZi2pfsYc/rmGQnLZVVLIq65q4BPkN0nhCHSecB5eRQ4x+qPRFRewCztiP8abO05m0+RBycKGr/LPWIeusVDqkoW+2L1wz7LtYfiE2wVWJDEbTdtCgb/IWYXkHsg3BtiMwNznRar8yV4b+jIL0tS1yLVleshUmwWFtcsgXC7oo8XiHV0SfAqiAaoor0FatBd5ttYvUwn+fqYJ5QO2jOJlqJdZOIJOZkfrVz+bCpijufO2Wb+sUBXw7k7F9pv3lbp5mfoJ1dMACJZwoSkqnSe4ebJQe1i2/NCn8/mJ6wEwy1M2DczluCaSuhq666F5i8I2sN8bcL
 aPxjeLIh
 toHcVUrQ1e9vyuPn0Le6Ao4C9i8scSdPhL+MgdAAvrTi+2QGeayFpPGW2/grojy6Ozj2+hNWmQlQ6MvZ16TvlUzXC/VtQ5WgvazgR9VDKPwI7OSOPjEfQH6aFzXGmEyRc/V4u3rVB553x339387FUVBqT6f8Xs8M4l+NiF+7i/O53Xma0pw6McME6D6cLmksvINgY7oHmpcDjJnlQ8s8CQToXWecze4NpYz8tVPUhX9FFqE9B4qAG982213E5TKIA7CZmaTu6z+f+RGIkjV76CvS6c+noylnv2/n7NfnyNKYtfFabl0JRfth0rCqU5BPeWwKTVleP+NTFpfeC5oPq1YODwJQGhC5XtF8TT2/1jgsG3sN7+PjH2Vbc358P6GpaMlQKMdVNk7b8+c5l+ynkwkj2oQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 10:48:52AM +0800, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> The hugetlb indicator in try_memory_failure_hugetlb is a Boolean
> flag, but was declared and assigned as int/0/1. Convert to `bool`
> and `true`/`false` for clarity and type safety.
> 
> - try_memory_failure_hugetlb(unsigned long pfn, int flags, bool *hugetlb)
> - testcase path in memory_failure(): bool hugetlb = false
> - clear semantic conversion in MF_HUGETLB_NON_HUGEPAGE
> - preserve behavior (no functional change)
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> Acked-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  mm/memory-failure.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 866c4428ac7e..f164fc5959f0 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -2032,7 +2032,7 @@ int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
>   *	-EHWPOISON	- folio or exact page already poisoned
>   *	-EFAULT		- kill_accessing_process finds current->mm null
>   */
> -static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb)
> +static int try_memory_failure_hugetlb(unsigned long pfn, int flags, bool *hugetlb)
>  {
>  	int res, rv;
>  	struct page *p = pfn_to_page(pfn);
> @@ -2040,12 +2040,12 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb
>  	unsigned long page_flags;
>  	bool migratable_cleared = false;
>  
> -	*hugetlb = 1;
> +	*hugetlb = true;
>  retry:
>  	res = get_huge_page_for_hwpoison(pfn, flags, &migratable_cleared);
>  	switch (res) {
>  	case MF_HUGETLB_NON_HUGEPAGE:	/* fallback to normal page handling */
> -		*hugetlb = 0;
> +		*hugetlb = false;

Do we really need this boolean though?
Why do not simply return ENOENT when we find a non-hugetlb page, and then the caller
knows that if we get ENOENT, it can proceed with normal page handling?

I might be missing something, but is not the following more cleaer?

 diff --git a/mm/memory-failure.c b/mm/memory-failure.c
 index ee42d4361309..44f388df5731 100644
 --- a/mm/memory-failure.c
 +++ b/mm/memory-failure.c
 @@ -2026,13 +2026,14 @@ int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
   * So some of prechecks for hwpoison (pinning, and testing/setting
   * PageHWPoison) should be done in single hugetlb_lock range.
   * Returns:
 - *     0               - not hugetlb, or recovered
 + *     0               - recovered
 + *     -ENOENT         - no hugetlb page
   *     -EBUSY          - not recovered
   *     -EOPNOTSUPP     - hwpoison_filter'ed
   *     -EHWPOISON      - folio or exact page already poisoned
   *     -EFAULT         - kill_accessing_process finds current->mm null
   */
 -static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb)
 +static int try_memory_failure_hugetlb(unsigned long pfn, int flags)
  {
         int res, rv;
         struct page *p = pfn_to_page(pfn);
 @@ -2040,13 +2041,11 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb
         unsigned long page_flags;
         bool migratable_cleared = false;
 
 -       *hugetlb = 1;
  retry:
         res = get_huge_page_for_hwpoison(pfn, flags, &migratable_cleared);
         switch (res) {
         case MF_HUGETLB_NON_HUGEPAGE:   /* fallback to normal page handling */
 -               *hugetlb = 0;
 -               return 0;
 +               return -ENOENT;
         case MF_HUGETLB_RETRY:
                 if (!(flags & MF_NO_RETRY)) {
                         flags |= MF_NO_RETRY;
 @@ -2107,7 +2106,7 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb
  }
 
  #else
 -static inline int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb)
 +static inline int try_memory_failure_hugetlb(unsigned long pfn, int flags)
  {
         return 0;
  }
 @@ -2386,8 +2385,11 @@ int memory_failure(unsigned long pfn, int flags)
         }
 
  try_again:
 -       res = try_memory_failure_hugetlb(pfn, flags, &hugetlb);
 -       if (hugetlb)
 +       res = try_memory_failure_hugetlb(pfn, flags);
 +       /*
 +        * -ENOENT means the page we found is not hugetlb, so proceed with normal page handling
 +        */
 +       if (res != -ENOENT)
                 goto unlock_mutex;
 
         if (TestSetPageHWPoison(p)) {


-- 
Oscar Salvador
SUSE Labs

