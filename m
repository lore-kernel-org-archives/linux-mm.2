Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C222FCDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 03:46:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C0706B0088; Wed, 24 Jun 2026 23:46:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54A8F6B008A; Wed, 24 Jun 2026 23:46:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3ECCD6B0092; Wed, 24 Jun 2026 23:46:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 12B9B6B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 23:46:36 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7AF9BC248C
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 03:46:35 +0000 (UTC)
X-FDA: 84917047950.30.2502FDF
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf18.hostedemail.com (Postfix) with ESMTP id 96A681C0008
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 03:46:33 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YeuckZMN;
	spf=pass (imf18.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782359193;
	b=YDtyQBK4JtHX/SLv5cfgon5odLWDo5eLf1mVke772MRk+HXFaoGwLg6kPsK/fK4HG618lH
	FKL4O9rrNJ/lh/Hsw+WfVjw1E0Sb3YSqnqHB8/IvoG6bLXNNqAkZFmsADn6p6a2Et5S4IW
	Zfe5poxPPqjSBdWkLqKDQHk0R8yXZ8g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782359193;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fdSm9PR81lhsu8o5UUFEaL/HA7IWicBe0MyvL3qf01Q=;
	b=zAzMU6pQjN6ATomt5w5zvtkMDV3Kpxz5WDFvNvN5c2i1/Fcl7CUmHvAi7eByBfQU+UF2zz
	nrLXAqB+rAsiUWR1mHoCcxeltcfTYWyPsTk9VJzr/lJN65Sfl2uBZxggEjhpuXmLlE7Z6E
	DB43mvA4b018r0hs1x0A0BWIvkvD77g=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YeuckZMN;
	spf=pass (imf18.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-bec3ffb95dbso307842166b.0
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 20:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782359192; x=1782963992; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fdSm9PR81lhsu8o5UUFEaL/HA7IWicBe0MyvL3qf01Q=;
        b=YeuckZMN+yDnp7KZP/bMMpz290w9PxX0SWMfgTkiKo4l4LUbifXLHfxHZni9rXBmcq
         EaQuTqdbwfPuFL3LCXSuOMFoJm+k78QHj8LurVy/51cNKDUTFlSOdJuY152UiH/KdR5O
         1KNxKNsZ2ClXk/yx8nmlguO7uf++bVaCUdTp/TBJfSbKKim4wRdHac2WigwAA2HJrlI0
         LNSau3EG+lxIc7ECK56ZlCgi6am0TlYgvEKtFHwdtUBBWZfmB3ouO5G+Y+cH0hET9rMr
         YrTf4DoVOuT7MLTD2CZhc0O04jwhHaCLhSUGw2385wODFbAEWCV4Jj0f45ThoOILB1A9
         KJ6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782359192; x=1782963992;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fdSm9PR81lhsu8o5UUFEaL/HA7IWicBe0MyvL3qf01Q=;
        b=TE61fYvc59YdtzwYLXyJo5LAlcC+gzuEsR2m7BGeycPuPviE6399xZQf9tCw8DX+Pi
         rN0/0UGW2sNQ+jwctG+W0dJVBSnl1VCdGPpObi+g1FAlVWoSJ+qbAvOHz4RDMq8KCB8M
         2R1i3sXu9MAXBcLtKQfJPyGlTDTGc5Q6Kbatx8C7MHAvZ3dHAr0YyR712FMxCCgxdRdd
         pX3l49gSTGg6KfuGuCuP1d4GKbBP03kKSazczi5NwIXOMJyjZ+RjTdqM+0T1j5g8WXIf
         7FzdZO194Qvn3NPzP7AiSsjQYtfov75Yj53oMOSTOHD1vc1LxmjFdU9iSpQqeJXXY0hs
         yQmQ==
X-Forwarded-Encrypted: i=1; AHgh+Rrl42tWmLXATKFW74ypHUxFnRs8/7+4BOGxlyz4IM+bEJQNdR9wLrfur5JhAS6d0or7sleoRuQycA==@kvack.org
X-Gm-Message-State: AOJu0YyWJyLVRpa8In7U+NGZdx/WTBuMrGeGX6TEulMOClKEuRU3y2tt
	PkxDn7qBy5DsR75M02E2ztRT5ZoohQLoIYvcedwUbRrVU/0p2fahV5XW
X-Gm-Gg: AfdE7cmFzqP+TNNjy3+YNFZhOTMAhZPQRxxvv7oUSYf4VLnR210GHI5Q8YOewJN+5aR
	2T/OwsaSo+/P+mjvrmtl5/8TGhh1yQFWyHbnjSlbVk+8C0L4J4fl/zN9PsA/OEs3+kx6Oet5Gex
	mN0fmO1i4FJtqQvrR0bfqLLqy/+JR1b0yQBPmk37e/QTg2a5hkG4kZX4NPNFmxjZX5v7EotEdTx
	zdHXDLV9LEQ0zsB/o70N0CrIKJAZNsNV6JvWo7JOWAl52oeZQuD5kSMAEAsglxh6zahET3SX1M8
	IVhOlgvetetNLA3u+IrBGt5mYEjcNZ/ILnjpkgTO+Aw1pQ4WSn3BcpTPu1aHkF+q4yvLV/JRTnT
	47P+lUwRzA9cJ1MsZGZMM8IdgGFDfrK8H8rQwVJ/ZVb9+cWBxjh7xnM9jNEAuM33HeiQv7XWCLy
	pCVNVvm9gfyFk=
X-Received: by 2002:a17:907:c8c4:b0:bef:90af:6ff1 with SMTP id a640c23a62f3a-c1205f67271mr25397366b.31.1782359191956;
        Wed, 24 Jun 2026 20:46:31 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c11fbbe8125sm87909966b.19.2026.06.24.20.46.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 24 Jun 2026 20:46:30 -0700 (PDT)
Date: Thu, 25 Jun 2026 03:46:29 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, david@kernel.org, ljs@kernel.org,
	riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
	harry@kernel.org, jannh@google.com, willy@infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	lance.yang@linux.dev
Subject: Re: [PATCH] mm/page_vma_mapped: guard check_pmd() with
 CONFIG_TRANSPARENT_HUGEPAGE
Message-ID: <20260625034629.nmgdwl2c4luwod77@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260624082359.2869-1-richard.weiyang@gmail.com>
 <20260624131457.ac81fbac373f78aa80a516e3@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260624131457.ac81fbac373f78aa80a516e3@linux-foundation.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: bymgt1ujf7e7ypcc48fi4gtxyu3gixkn
X-Rspam-User: 
X-Rspamd-Queue-Id: 96A681C0008
X-Rspamd-Server: rspam02
X-HE-Tag: 1782359193-407807
X-HE-Meta: U2FsdGVkX1+tI4qXe4f7ZwdKX8aeYfyeVbhKI/4OxO/a9BKdUAg/tmywhbqO6NmmkVywNeWkvtQlw/GJUJgvenvOAQtUqu1ZSvW4yfD6fgLIrw9v8vAj5RL3a0lnADwqdEf5qV4K73mPex1nFKxOq+zq8bYNenlTbmNICcO1x80h1ryuyhn58wGTY/bUJjtgrtqK14+mbRxyC+HdXgErQDAGkknIrVUNbiPP+HoN8BbEYIeLvA8teVjaDukE8n8cog05AoR0UoXmMyBQJmk9yYA7XwFbZoq0/jzCbhE7hXUBn5GYmrUN5dbr41NAZMj6pHmkY/plJWxSvW8uWwIc094dXmNG0IElZxdQvFrJfKWSLNVPEflSzY55sIkjpn/ov+qXFbKy7wI7W5mJd/oJJRxaHyuJy74OSdnnAeJa4LL8a4i8/cR1pQ01Q8bbZOT1/HEcVyrcXVQ0nYFwbBzR3IvGBCyUus6oLBF25eRxyyUSVMdm8a+UweIArQnV+zXPr71ctfB+UProHw0H0TfJYN0Ja0z/IXwneujqEduFXXSd9wkBPdFUatSQBaNMXidK/Nygcm+CAKM87SjoJZ6v021+a4fHLnwbaeBBwz+v3m0KQkvuDuB3dRFju0ZKi85kNQYaA07LQ+OzmylhCmZ/sPgIqmeJwi56pOH0GuptZhtaySlaN3ZIPVQnip4GYkDX7fGz+vttPgDtiW7Kn3F13TZW/AF9MDKYYe2aEsHGT52wDv7reR6Av6JqCVTXE7PId3kbG6BW4xwMbNoRd4SX+++7mVxxvtnDuzuA0VGak96FmRSvwesmf11ZQ1oxM/+X2MCM76efZBLK29BLDoFDlq5cbHKasyf8/U18xwhpLs2oHmal621TO7t9t/juXFfwTCpianeZqepV4gr3qvEkD8IkGLFiFkZDCMKekyz7Zfd13UxumJOKyut8Eov3AAPm3O4jXiqYpuiKD/1LAF0
 qyrt8jsF
 k7vItbRkZPTz/HOkkBjOCmJaf1S5Rx1+16aX2VcAW9J377oni0Fq+joxug0bsHRJdvXwmMEuAMgs6HZmvkTJmj9v2NsfisMYO8JIyfivemoBwYCLURrbh6JXeZL2LRdceSzJxULL5tiqIg2TNLLY1BUt0Ef5wdIOuJbfmSPDKezPRokDtbGHhnaexP+TnEAnUaDj2MYk7nw1doSh0Eil00Yq8HHk3DjsMcCg2LWnELcuumcA9Hxn9uk0IJVnr+PL+gQiRI3PB4k8WY7Hka2wtWjEeOJ/yBAkGs6mNEoEDISk2rO1fz593DDPLbt1ztKrbmnhVxtxX08CTaakhE/9oiBNfbnf3WfxrnT6ps2rM6ygNEFqfwQv43XUR0+qu/s5/kIuegdk4mEUrOz0y2IhNhkMi72ftrA/bjS9hnD3u05i6d2ReGbCbwxtuSz3644h0Qa5qCQgekojul3rHA8N0mrDQBQ1QxwfUf/+aQCZsd0gv9fzy7XiGoKWDiw8BiCVQ9gIeHFyE9rPU6sGukfH6GFuiicpG5Ba/U5tLbhWow40HLzcw/kTwiV+HEpzZ7dV38hIdHlMN9rqKFzccTxVYFwj1BUdMbD7a4LVwHjAf9m8DG5p0HXDm8TIWd5pIU0/IHoQmVVcISUqOG6WxlJhIU/eCjcC2dAD5NUt+lKzP62ElxDfUv4I1GmSWd58dyesNsTPTNMsBKGXBtRB3nJS5dtpGw1dQDERM5nxACSL9Rm4ofMPL13IRDYhDxbOJ3ughaTw+WlEBrlI+zi8WqHBqgw4gfvsF86kgEDVwo0sxTbB5bug=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 24, 2026 at 01:14:57PM -0700, Andrew Morton wrote:
>On Wed, 24 Jun 2026 08:23:59 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:
>
>> The kernel test robot reported a build failure on the parisc architecture
>> when expanding HPAGE_PMD_NR in check_pmd().
>> 
>>    mm/page_vma_mapped.c:142:13: note: in expansion of macro 'HPAGE_PMD_NR'
>>      if ((pfn + HPAGE_PMD_NR - 1) < pvmw->pfn)
>>                 ^~~~~~~~~~~~
>> 
>> The config [1] in report link shows neither TRANSPARENT_HUGEPAGE nor
>> HUGETLB_PAGE is defined. Then trigger the BUILD_BUG.
>> 
>> Fix it by define check_pmd() under CONFIG_TRANSPARENT_HUGEPAGE.
>
>hm,
>
>#ifdef CONFIG_PGTABLE_HAS_HUGE_LEAVES
>#define HPAGE_PMD_SHIFT PMD_SHIFT
>#define HPAGE_PUD_SHIFT PUD_SHIFT
>#else
>#define HPAGE_PMD_SHIFT ({ BUILD_BUG(); 0; })
>#define HPAGE_PUD_SHIFT ({ BUILD_BUG(); 0; })
>#endif
>
>> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>  /* Returns true if the two ranges overlap.  Careful to not overflow. */
>>  static bool check_pmd(unsigned long pfn, struct page_vma_mapped_walk *pvmw)
>>  {
>> @@ -145,6 +146,12 @@ static bool check_pmd(unsigned long pfn, struct page_vma_mapped_walk *pvmw)
>>  		return false;
>>  	return true;
>>  }
>> +#else
>> +static bool check_pmd(unsigned long pfn, struct page_vma_mapped_walk *pvmw)
>> +{
>> +	return false;
>> +}
>> +#endif
>
>I'll leave it to others to decide if this is the most appropriate fix.
>
>Sashiko had an off-topic complaint about the surrounding code:
>	https://lore.kernel.org/oe-kbuild-all/202606240042.ffPsEXVc-lkp@intel.com/

I see this robot reply, but not see the Sashiko comment.

How can I view Sashiko's commnet?

-- 
Wei Yang
Help you, Help me

