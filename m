Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5F8DCD98F8
	for <linux-mm@archiver.kernel.org>; Sat, 20 Jun 2026 02:11:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63E6F6B0005; Fri, 19 Jun 2026 22:11:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 615B86B008A; Fri, 19 Jun 2026 22:11:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52E556B008C; Fri, 19 Jun 2026 22:11:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 206B66B0005
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 22:11:13 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 90D1CC2BDC
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 02:11:12 +0000 (UTC)
X-FDA: 84898663584.19.130D40F
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf01.hostedemail.com (Postfix) with ESMTP id 841C440002
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 02:11:10 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HstMK3ow;
	spf=pass (imf01.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781921470;
	b=ZxSZBAzQfuA7cN0wa39ULLvnVxY33mqhYewZ4cNU+tyPvlbJAhkCAIFcNviKFwdQROA2Pp
	eQzQIGx/O+dUrHOT8V/v29xrm6H5wD/9sr9YQDzBSCQ6e3z1ypAxnaQVOQr5ggGmhLLVpT
	fyyxmGSJaLOkcZyGlVSs43y63X+Xi60=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HstMK3ow;
	spf=pass (imf01.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781921470;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+g6texoIe/Wti2e0fTI/Tf7IkHkYNk4fMe8DtPT8ks4=;
	b=GVTm2mHXYaD66GXd9FcIdWu17lvOpso064Dk/7kGjqc8AR6um6hrQ/jkfP5OMg9TAwxOoU
	2sR9yBXvu9cziBVZeFvJkbrpR7QIiteWBe2+HKm8kmuHD4u/zjJA/EYWHXqJ7vfFz/QUaR
	HolJXs4pmbNb6a5Tx+/6MvHZYJ2DACQ=
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-bed2195323cso396346966b.1
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 19:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781921469; x=1782526269; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+g6texoIe/Wti2e0fTI/Tf7IkHkYNk4fMe8DtPT8ks4=;
        b=HstMK3owhWAUFYxLj2fk5ZuGSLh/Z9wLURku4YydTbNL5GulUOkR69oxSFf58Y9AZI
         39MMyIwtcasq8b/WyI6y2+Tia3KPhLCUTRT40tjmdqKEp1alGCTK5D7mcV8SG8gGOeyJ
         6pDZRtc5pw9kV8Vtvp5f0SUD+dZjN52c89M7io/FBbO07BvqGGgfVwwT6kdcn0NAJSjU
         ayg/wX3mvX1/zBxdvhbvATyB/pXKlz8de6EFtEaR+9ZXdDc6lfdvg0TLfRVL9ONMZUgY
         9EFZkElzcSAEGLPDwjomQU1OfXlVMeYNuRngxh+s9MYovAD4fFowsFjyTBjJ5PpT3T0n
         JN/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781921469; x=1782526269;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+g6texoIe/Wti2e0fTI/Tf7IkHkYNk4fMe8DtPT8ks4=;
        b=GxNhwW4HgCLnFqUpjJIEs6hBRxVo0q3w3Q2NgVFQV0UopwXH1xe6TTTd1R0yRowMCT
         Bj17QuyCQ6hYHIHkf7gCmyPJVUU6U230+vGnASTgMT/WyHdhJd/UYT0yofPcYTkl0Pye
         FHFqvqVVa5um5fU9LT9M6VyUKeAMPL0eJ38dGJb96Ad2TtPgAa+LDAl/gfoFMLBV8cyT
         EQo6eJ3uIa+EY83f1YPG0VW0mXhbjsf9Mtp3AKPapZ71R0lHf+nMDCoDmZJA0lnlnPn3
         0fSj+vehq0/FT5MdZDFOuTulmm9OCKNUPIc9xwT0TmIRSalIqaL7LwgDssvbg8zudf7l
         37nQ==
X-Forwarded-Encrypted: i=1; AFNElJ9ld5sG0YxABagrHrJQjGYORZN+O6wm6p8T0MNpME80Qdf4cuY3F92Zs5v4cTk/joJkmqdk+1DP1Q==@kvack.org
X-Gm-Message-State: AOJu0YyEIQkc7kOTXyvR7vSibp8hpCgc2kwhYfBLJ++t2ZcVRTJkCwb0
	/Ep2U/ScIDTzecdaP+9RVkyHfFozhJpQ1ZM+YDR1NGsWyDQ4xsdZHwn6
X-Gm-Gg: AfdE7ckDWz+8Q4BdEF1PVPD7XTKLe4pFM74e4CO83jpWjD4WNNngO1ILAj02hjIxVAi
	BrRSTvNi0Y5dOdT7GgKopsM48PI8PctkhJ5NvDIohYYZyrSU8bMvvdMCgRygHHB7xBoqLwVWnmU
	XGQwRmChMspvlIdBr0fb8TFqVQsXnfXw2iwkmQwVHB045v8qMNcEorCmE7T0EvE7er3ga50CGBf
	B7oGhogpDTr8pDAozpMY9xxkomGpsfzahZ/maDZmPH+hPkY8Ex9lB4e+m3x7UtzqSjrTwKG+cY6
	P5TixYymfMER6CD1S3LPhZRfG/q0MkaQ9a9YQERYGj+WsbPWg+5j3EhM06P1sbdtOLVnjxTmYhT
	M5Xcpjla0u7BO1kJYBikPKei0gJoB6+PYgBuje/SO8iOrU3dcJiDwnOEXaZ/Tsgh7PDT0IKC3G6
	Qy6yu5vxjXRJc=
X-Received: by 2002:a17:907:3ea6:b0:bfe:ed06:565e with SMTP id a640c23a62f3a-c0b75a8f179mr251081266b.51.1781921468894;
        Fri, 19 Jun 2026 19:11:08 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c0c5e497e88sm48240866b.11.2026.06.19.19.11.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 19 Jun 2026 19:11:07 -0700 (PDT)
Date: Sat, 20 Jun 2026 02:11:06 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@kernel.org, riel@surriel.com, liam@infradead.org,
	vbabka@kernel.org, harry@kernel.org, jannh@google.com,
	balbirs@nvidia.com, ziy@nvidia.com, sj@kernel.org,
	linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [Patch v2] mm/page_vma_mapped: revalidate and do proper check
 before return device-private pmd
Message-ID: <20260620021106.u7gebygzqrp4ghg5@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260616063436.20455-1-richard.weiyang@gmail.com>
 <ajUXNjRMraKb6k2n@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajUXNjRMraKb6k2n@lucifer>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: cxn3m98oroi64dt3m7h3p5ink1e5w5yu
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 841C440002
X-HE-Tag: 1781921470-594770
X-HE-Meta: U2FsdGVkX18VOGQSJFxB8Wsn7U/UZ9CB/RvPxd0XqEvuY+J5cmF5SwgQ42qV6gcjCqCxWdv+6DzfDnkElSfsqjt2g61ys0iUW8Olm+Ph8YA5U2zYsQmePRvZBNAGHaQS4V7p9QkM2Z0z2jGCqN/kC9iIeoT+Bnvkg818zbmKZRjAWl+4FihDVq93pZtyEAUr0Y7q+8pbpEavmdwZ6yxsAJSE4Y+LwKhmglkI7noPtODAwgyr5V+jcgKK5psOGA5tNHMDJsQIkt3YFJGZhHmIldGfmGfOfvg5u7OEARkUgwlX3E2TzHbD/rEnzZPGekizPXVveZt2vr5nfKq/aFQ9cwr4b6KyRNQUkuO5vyjQUGg5ND3cySEB3vzmni4hN8jr30iOL3NlEKcMZsC+JShEzjt9ChGifdX0sMK4/2LvKJdBRAYtz5uK9zEmi4Eo4d6ZhkkUJZYQephAG4VK++so3Oa3cYhwbO9Nk7+Tau2rEMr1uxM0Zr2wg9m5JKHxTqLcLVDQx7MF887t7MiyKy1JnnfHa6xOqjh2qItAXBsidfqG1XAe5WBxUgqzCgbmgjoCD5FJvtYj501WOby+uBcn7w1wbOI+yF/ghOISjB+ZmJJMZ71ebWPWOa5FY27tb5HJyJYab3YB4nAUwtzGEsP7tCf8A1tGa4yh3Wg1gj3eUnT70FcTCXdGbyNPSk8VxsgIS415ElWZ1uluJWr9YSjaYcrtkhXiYEnY2UEU842WBg6QdglrmSlV7Hxk25+Kf/1BPuyWXXYJjsl6R0K7N9w3vwIq/HfCg3KaXBFr1opg/dKe0EqJTZNKIzfq0wQm6PkTpnbPovejDEMFup0phk1KbDlaJqRFRvmzoj13GKf09MhKZAnHWmthnfyz/BTeu+B9zGJvXcg0xbzJ4MM0IKKT2XZtMzDTikcNKxd1xZy9Tk9PkMkOUiWaftZ0peskjnBJGqYk0qC3zjHb+xZhuYo
 ji+qgGWZ
 8/66HuvvwdkN9XXw4Ak9+xqDzIOMNcZ38FgE1iY89m55WuEdSf+Czqz9aUeue2FcTd8crFjOLCw8egxOw65o/3Rf3Ht5krjGMckY8Dqqz1Va9bWrKS2Do0NOGmWVXEjUAmbBSEBSMWhUp8nzdMawOex0u/5Qhd241l1aCEhQq7SpCGg+BF/SI9LATIoUSah03eFJhgxv87S/bjPk/Nq+8XacUjhx5EV88UHbY55s9LocPjCwns82gkN+SFKOdjhNwWZyB14NPJygWck8AIwk754iC6/3ZF4RmoDMJA/n/taks2MJ3MzpeRDJ7WlJXZtTVsPreBGcfKaQHCFGaaAlTi2dXns5Wh64KvNceGWmbyA5fuSqCh70w0BAhBX1+Bkp2JmRtc1k2LUjaC/XffAAoFZRp/FzlPUNyrnv0CKiMrsyIuwGd6R6jbTP3ZRuBzuAHfHqjOLczDUBF5rWnGKTGDAPagAa1N/eeQUkCNBlFbOR2UR0ALF+NioT2ae5r8WbFwNHdp5DzddhnAhZPKcSEIDcu/OhR2qa2azg25Z729gYGd/OZEz4hCE+9He0SB4bP4zBogeWDDhnEj099ALrUQyYNfPd9fmLpl+xVIxWFofcX+UWNwsoz5IAmVtecnPYKvaL0A28t/5N1Ralo//WF3WXJAm3b7gcFiu3sReKqrwlVp/uq2nPcq/gsXaDWKV8C0kaTl5s2v7+ddqmdSDDDl159218hgde4JlflTzbGtLLgGyLm7dFIx5AUodn2VguVIBeZEmzzCbpicZJCsLEXuL09r/JS57XDETGDgjCQVQ3GnSCTVLjRs1ibNA4j3eLgOOwr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 19, 2026 at 11:44:13AM +0100, Lorenzo Stoakes wrote:
>-cc wrong email
>
>On Tue, Jun 16, 2026 at 06:34:36AM +0000, Wei Yang wrote:
>> For pmd_trans_huge() and pmd_is_migration_entry(), we does following
>> before return the pmd entry:
>>
>>   * re-validate pmd entry after PTL
>>   * check PVMW_MIGRATION
>>   * check_pmd()
>>   * handle on pte level if split under us
>>
>> But for device-private pmd, we just return after pmd_lock().
>>
>> This may return improper entry, e.g. if we are looking for a migration
>> entry, device-private entry could still be returned, which leads to data
>> corruption.
>
>I don't thik this is quite clear?
>
>How about:
>
>	If a softleaf entry is present, the existing code simply acquires the

How about: If a softleaf entry is present, e.g. device-private pmd, 

>	PMD lock and returns success even if PVMW_MIGRATION is set (indicating a
>	migration entry is sought), meaning that the caller can incorrectly
>	interpret the entry as something it is not, causing data corruption.
>

Looks better, thanks.

>>
>> This patch fixes commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration
>> support device-private entries") by following the same pattern as
>> pmd_trans_huge() and pmd_is_migration_entry() for device private entry.
>>
>> While at it, it cleanups the pmd entry handling in page_vma_mapped_walk().
>>
>>   * Instead of handling trans huge/migration entry/device private entry
>>     in a mixed manner, we put each case into its own if condition and
>>     handle with the same pattern.
>>   * Also we grab PTL and make sure pmd is not changed under us after
>>     above check instead of do the check with PTL hold.
>>   * restart the process if pmd is changed under us
>
>You're doing quite a bit for a fix and you're putting it all in one place.
>
>How about do the fix as 1 patch, and then cleanups as other ones? It helps with
>review too :)
>

Got it.

>It's a general rule of thumb that if you do more than one of moving, refactoring
>or changing code, to do them as separate patches so a reviewer/somebody
>bisecting can clearly separate each.
>
>Also PLEASE do not add new functionality (this lock recheck) in a fixes
>patch. We'll end up backporting new logic that way.
>
>Make the fixes bit _minimal_.
>
>I think in general Andrew prefers separate fixes patches so I'd just make the
>_minimal_ change that fixes this for the backport, and the cleanup stuff as a
>separate series.
>
>>
>> Fixes: 65edfda6f3f2 ("mm/rmap: extend rmap and migration support device-private entries")
>
>Hmm seems the device private stuff has had a rocky road of late!
>
>I wonder if we need some more test coverage on this?
>
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Suggested-by: David Hildenbrand <david@kernel.org>
>> Cc: David Hildenbrand <david@kernel.org>
>> Cc: Balbir Singh <balbirs@nvidia.com>
>> Cc: SeongJae Park <sj@kernel.org>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>
>Annoying nag: You sent to my correct email ljs@kernel.org (thanks!) but also
>cc'd the incorrect one, please only send to ljs@kernel.org thanks :)
>

Yeah, I pasted it from commit log of the fix commit. But get your kernel.org
email from get_maintainer.pl...

Will pay attention

>> Cc: <stable@vger.kernel.org>
>
>Be better to just have this with the Fixes tag, Andrew adds the Cc's from the
>actual cc- list anyway.
>

OK, will move it close to Fixes tag.


-- 
Wei Yang
Help you, Help me

