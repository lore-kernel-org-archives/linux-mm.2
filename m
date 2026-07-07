Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06A84C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 19:19:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8486B6B009D; Tue,  7 Jul 2026 15:19:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F9986B009E; Tue,  7 Jul 2026 15:19:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E7436B009F; Tue,  7 Jul 2026 15:19:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 347D26B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:19:23 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 83620404C7
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:19:22 +0000 (UTC)
X-FDA: 84962944164.29.B0E338B
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	by imf30.hostedemail.com (Postfix) with ESMTP id ADA9580002
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:19:20 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=a5uILtWU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.46 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783451960;
	b=iKX1etZCPVLAlZo+DGKttfDFkxJd8KckWV6GDkFYLnh2CROKI8wUaXBJd8TsJidxT7Xys7
	0WzrG3F8d0dchD00GUOLnYTZmdoWrKd9Bd2HOM8dNmDzrcWXW3rkGHkbwUVcqDw6+cS9mo
	c4OTCg8166rFdFTdrOdBIYzWuSrNxTE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=a5uILtWU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.46 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783451960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QiqGU7OY98G2ViD6DEKb5QXbzFW9qlDntwYnyycFfIQ=;
	b=JiF1QZ1wkWWV3diKXDQYtfzXF4HklUdqLuSHBnOE2BwNiHOfxBtUmUrLmxJdBgYpRJIaAQ
	/N+WGTMAtupHo4OqHypPnSzg1r92YiSGH9I06PFMhNB8AzcN4855Ga9hrEoJq+zxrHYkfY
	kTfYuh1v6k6s6zOWI1jx2Oq+dwNLw/k=
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-6a347ec19a5so1072718eaf.2
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 12:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783451960; x=1784056760; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QiqGU7OY98G2ViD6DEKb5QXbzFW9qlDntwYnyycFfIQ=;
        b=a5uILtWUuL4WqUPxUCljwzgc65d0LnfEQ/k5YuYjrzWLvlb4P1hy9aLUWY7Lnx6ocC
         6MXessXNv8QHsCbZhxG6XExWN/9bRd9fMdpuRNPOti7R4qj7WZvxBBlH0oQwYnsXgW+i
         98UxJoNcCM5/mNw6fmywiXrYQgsm8EuDsg25jP/v8zaDeT6K9mGWDFCKkgF4PSaaOUka
         W8C2wKfii1a/drbm9L9JG7qN0HP406KAKlDKFeu/y4rEjbt4i1lx19wbEVOSBcoM8tqO
         Inr/cRUAR3PInnExp4f0/pnFkkMfhoyckHhotrI+rHB4Rw7WP7Xt5X9y/yvVUEXgXm5M
         j+WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783451960; x=1784056760;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QiqGU7OY98G2ViD6DEKb5QXbzFW9qlDntwYnyycFfIQ=;
        b=QKCHsUkdrhx6XlBgNtCcd4TB/dEJygaTBIkU+SbgIi9x9+PwCYCvEeqCPSpXbEhoSD
         G5+hRnHygwRi3WTkCJEu+Rqi+iypT3eyptCoQaFSBrtnww1OzpdmNZWUeSE8y0u/Xplz
         /rAr5LCjakqz9S8e6XIquQnOXCaIl2jM1SmvaQW/d5m732nlR2BRZ6WfSqIoCqsaNL3t
         KFiFgmNletuHW+CqtaZCNerpqD9EFSikh8ii4AoOrw4NkXQ5twL221WcNBj9ZZmi0E/N
         waQFkQ/o9cVkX43LxlI+NpeV++3yISXBXqSBiVmIB05AughD1rZDgX1dqscY5afOogf/
         VD8A==
X-Forwarded-Encrypted: i=1; AFNElJ9DAe52GC4rsTMxi8lwqjRgc5dKX1mSXN9U0uC/e4ELht/d10wXGKi+8+yv5oLFI+DVjG5vfO5nyQ==@kvack.org
X-Gm-Message-State: AOJu0YxHBTQG79tbbYklRF1Hz0RGsYKEOyNqX9DJsz6uN6Zgz1Tvrh5P
	Bf2YMc8O+VTT9W2Q8nDbAY0tcZ9BTiDGS505PDR8VWBZJR0ToHoR55Xl
X-Gm-Gg: AfdE7cmn3KtweA8VUVx06yu1TqJ3eSVG4+ZTs6DGrg4sd2xAU2QNUqMV4IHetI6o/FX
	Uhi1x06uscf4Gqd6dTw9SLKNTsCIeXZO47ahJeXRYkAvBC+9IIVfK+b64gANUUH0Q3cFIYzwCKF
	tiMbnCPAKVEaDrnTZMW1OausjgT+qVGwdrjIgzuqiJz/UIJF8Ro0V7mnPFygk9s8HfHJ1BUz1nB
	IuCGQYsUg9QIVmR9RfSTQArraCzNB3bW7K+lKqijaBrMzozn3KnBPXw1N6XOTd56makUPT86AWG
	hf0dg2Jo2xXDHizXelpQQpKtEt4R9KGw6xR2u1+gzweA4gOSB9bS9mYk651QykcptsWbgaCH/Yh
	JAq8C3Tf07lEpCdGANLTsCbl60clhqBsj1kMnHWVVE7W2ai/zwZ3eIhOjzU+j/tCQm/l4oAzuSn
	BfkWhev5dPPRFOG25bpy9iUdv7xlmKaC8Z9b/UHqlnTPIhmmEirVdf
X-Received: by 2002:a05:6820:1525:b0:6a1:7d5d:d55b with SMTP id 006d021491bc7-6a355767d61mr4135973eaf.63.1783451959711;
        Tue, 07 Jul 2026 12:19:19 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:a::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6a36a5ef513sm220102eaf.6.2026.07.07.12.19.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 12:19:19 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	byungchul@sk.com,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	jannh@google.com,
	joshua.hahnjy@gmail.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	matthew.brost@intel.com,
	npache@redhat.com,
	rakie.kim@sk.com,
	ryan.roberts@arm.com,
	vbabka@kernel.org,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	shakeel.butt@linux.dev,
	hannes@cmpxchg.org
Subject: Re: [PATCH 0/3] mm: handle device-private PMDs in walk callbacks
Date: Tue,  7 Jul 2026 12:19:16 -0700
Message-ID: <20260707191917.3213033-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260707135255.292870-1-usama.arif@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: ADA9580002
X-Rspam-User: 
X-Stat-Signature: 97iriuakyegthxouknopu5wnf5aknww7
X-Rspamd-Server: rspam03
X-HE-Tag: 1783451960-496292
X-HE-Meta: U2FsdGVkX18KnTc7aSazLWiYRUH5EBwSdtdEhZ7622QgNDpsgLvkBCUGy6G0pEJwPfVroyCWhDp8G5ZMPisEwzhxIw4ZNvta37ofatBXVFedJmk3ALm0ZgE5TYP2VRXz9Al26ZvzlBudtWRJZgSTk04mTcNse7w49dJUHgrFZLQksa3rUsRkb4hNLLhGMZQDWnwi5Z6BHiy6SorEhE/KiG1JqwTJHGy4T7BHwNt2671M6f9XHPxJ/MRS6bVW1HQ3pIc8SxhySrDDlhRNesjOHytY9F0Pbyfx8VybQBX4I8v9rj18ozu7jrEaVyA3/CF/8MZ/MB1Jh1GW6i5jR+/L7KqbR8pHHy/z19Z5VGRsFuJRwbtozQ+J93FVr5yPm63Mw4wpLjxiSGBbv2iV/dYXtrP9vvvgDNrPhFzmPn0Nb1/HY/JbuByV1L+xkuRT6IR74ODFUiQDLaMZgKp/jKE2ibpKORZcVDD4wCUriQYIlSrLp6SeDdewx9PsNHrShJUv7NvqsUrVHqTNWMv8eqbd2YI7F0nSFfxnhHSezJqolAb2Fig7Ilw4VkWP0IF95CfovYhdw+d4qQGWAbnTp/waqZWK07TUsWAoOBdviFBRtKEpymvctB6oztaFSY1mNYKv2KVHGhr/qG1l2NxSfGQKwxgvaglNDgFd3Vrnbs8FaAzrd9MvJAvzQ4bnlg2XQAfj8xV5MZpdmh74sY/6sQlojCCRru19j9XLNuGe/bADp4mHOpwZSCbiwRzpW0j8S2WphzkBJovPZEbsz46Pd1bT6B1IIe2V8E0roGoWkJb0pWcvmvb0SsQIzBYfns3oLlHDmAR1UvU4lL731AfZ2HuORHudzZ79H+oS7AWWxcLVP3Z55GBhw1Fu13bJu1KVtdFNu3OuqEMUGlZL9F6t7aTz8XNzBUIRDH67b4RbRkK4ORpkCLxQZber6ftO7aaHVfWJLdFzksz6BCffelZIO14
 5Bw052/L
 KTl+l8eQ/5bn5P4yejt5g8ZY68vAPHHYuBFOsyTOccaV2/voJwMW7EPyzWL483bxCJPR6YhoZOO9zvDh40hFtVEJqQfny1CcFXGbmIb4m00sIEZj/FGerTtBmKpILDipa94XqC5BXiR1LrhnYkHA3re2AsgpcfFhLtpCZeOXcDpM1+/Ddzp9Gv6n1+HeAeIOmuQGyaYTem62d75lSqNxKEdUMLrWQkbFO4oXznKZ0BiwnPkMRbX8X/pUJfcWfC3+o9pktZ/WCF5tkW6IU2DlVJCLN4LrWzOKDBtJUfFvAeoORNp9W1pCj8zRshURMDk1MNVbenstP0MBa10AmlcgivCLlQpQXkWnZqfpoVCx4YN3AQNVk43N50YHVm1f/WDb2aT4BtNZ2o4DtWYzs5VxedIuuPTPMLr6G1N0FlaBY1cXPPolINQ+XHmpEC4BtHYdTcPMIwRBT1m8dPjHk1lyLxxSpdi+E7BK2T8FFJDssQAPmWfunafU/LUApep9ep44eX+dJs/EaXUCM0204bf2vE4EpzovF7VIKovIF7uNqHMbAgNEWKiZ/cJ/7hjhfMW8nuSE20mWcxkpaLWo+7m/puskLUTVNlfFtAdOz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  7 Jul 2026 06:45:06 -0700 Usama Arif <usama.arif@linux.dev> wrote:

> Since commit 368076f52ebe ("mm/huge_memory: add device-private THP support
> to PMD operations") a PMD may hold a device-private swap entry whenever
> an HMM-based GPU driver migrates an anonymous THP folio to device memory
> via migrate_vma_pages().
> 
> pmd_trans_huge_lock() succeeds for such PMDs (pmd_is_huge() returns true
> for any non-present, non-none huge PMD), so several MM walk callbacks
> that used to assume present THP or migration entry are now reachable with
> a device-private PMD. The results range from a VM_BUG_ON() firing on debug
> kernels, to an oops on a bogus vmemmap dereference, to silently isolating
> an unrelated live folio from LRU in the aliasing case.
> 
> The first 2 fixes were reported as pre-existing issues by sashiko in my
> PMD swap entry series [1]. Hopefully sashiko won't point these out
> in the next PMD swap entry series :)

Hello Usama,

Thank you for the fixes! I think all of them look good and they are fixes
so please feel free to add my

Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

One thing I wanted to maybe consider is for 1/3, whether it could be
good to gate by !pmd_present() like the sites in 2/3 and 3/3, maybe
that will be more robust in the future if there are other cases we
should protect against (and the same as queue_folios_pte_range, which
uses the !pte_present() check too).

For 2/3 and 3/3 we already have the !pmd_present() check, would it be
worth considering just changing the VM_BUG_ON condition to include
!pmd_is_device_private_entry()?

Just wanted to toss my 2c. Thanks again for the fixes Usama!
Joshua

> [1] https://sashiko.dev/#/patchset/20260703173903.3789516-1-usama.arif%40linux.dev?part=6
>  
> Usama Arif (3):
>   mm/mempolicy: skip device-private PMDs when queueing folios
>   mm/madvise: skip device-private PMDs in cold and pageout walks
>   mm/huge_memory: skip device-private PMDs in madvise_free_huge_pmd
> 
>  mm/huge_memory.c | 3 +++
>  mm/madvise.c     | 3 +++
>  mm/mempolicy.c   | 2 ++
>  3 files changed, 8 insertions(+)
> 
> -- 
> 2.53.0-Meta

