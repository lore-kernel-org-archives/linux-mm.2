Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAE0FCC6B34
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 13:39:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FB2A6B008A; Thu, 15 Oct 2026 09:39:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AB5E6B0096; Thu, 15 Oct 2026 09:39:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49A096B0098; Thu, 15 Oct 2026 09:39:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1F0336B008A
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 09:39:00 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A99DB140968
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 13:38:59 +0000 (UTC)
X-FDA: 85324966398.14.7A63CDA
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf23.hostedemail.com (Postfix) with ESMTP id DC31E140003
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 13:38:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=R6moKTlb;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792071537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QFn7sojbGXNFhqbogZOUxB7sxcSHF2Ksqnd8lPmDfO4=;
	b=mJnyE8iTnOk/YQ90jRUa3BFDab5THwH1W2cs0UtsZm6o/a4wNb+0Pud5qmw8ATTx/irD3M
	LmrXw4OK3Lyme8g+1RPVodpVt4Kyp6cL2utyvQBKt/dqOPmGGU9smlJ06LLOwhCMlksGN8
	+5dL3t9lj/lu0eb2SztzO5oRy+fMVTg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=R6moKTlb;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792071537;
	b=lKm4BTzbCZxJ4NZtzIAVpGXAvB5lUGlYxnX3fXHtl9CUn/5VGG14fQpXLERmDZlRqPLHKv
	VG+PU3iOVetGHsAPoY8emiMJLRWJS+WgSj00f4NMiuBohU0Hjz1An/bCAn1fCmo44yI3ea
	ggc6owTPHik4gkFL6ALGSYtBwaiky6g=
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-93e6fb35f91so503348385a.2
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 06:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792071537; x=1792676337; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QFn7sojbGXNFhqbogZOUxB7sxcSHF2Ksqnd8lPmDfO4=;
        b=R6moKTlb2ZuoCLOJqhI2yOmO5yDbG8hJojzy847GiYlFZkmXyo6uAwK+01MYLP1lb6
         EPfKnPJJsoPV60ewRUS7MLImjjgeCWxWoiuiEat4/UgegKnqnXpYtgyPzY96Xa2mN86I
         kB1LXphvoo2QhKRX0xlRwmHiptXpib77EgAEbte2eq0EIoYOc+34+zoGzZVHs95uquVe
         I8ayb0wh2USOCduDPVpRGs3sSK7u1OJX5VC0Tu6ku35QOMFoqp5tGFyEJKTD0aGGloeH
         c0jRItIry3xwQuu5TbeNO9hgaApwSqO6xrHeKzj3G4YpIQdFmG8bOF32v5i5+XzWJ6qF
         K11w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792071537; x=1792676337;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QFn7sojbGXNFhqbogZOUxB7sxcSHF2Ksqnd8lPmDfO4=;
        b=xbyuGSjNwS53KfTUwa6/gpcu4m3H0SkcUjswQMJERNZ7ed+ChcCUJO0RQ3c5bMTlo0
         VzTqGvQHMEfRu5toz3BrPxAQZlEr79zDbn8CgEJPhP1orP0v5HvCONJ2RknC+SSn21m0
         eySWwEm8MlU5485/SBagVyarUOImeQO+BdlHLbTi8P/gPIiRo+o0BLr/i+ahgZ3IijEy
         tN/c7tn8OvZd/PcZpMh5gzrjTrmhXmXPShd5hVX9rvejs/TF30DME5K37PdC2bnwSBUG
         EEUSlc3e18ooypg3M6xaytmLJMiSlT2e/FVDDZdiQQmMkqu2l/0MjdOoQ/r3Hf42dK6s
         7hQQ==
X-Gm-Message-State: AFq9FYLIX385DgcV9qaSZm/Fm1f5xZMRqqi9zkr7+22XOkOjQ730VjG0
	eHIDoy5+xM2yXwPUcPKyWJMNycukzMThycPI1K44ng1VBh/9Ppv76dAqpBldg/k1TYo=
X-Gm-Gg: AYBFou2rhpx+T+LOgqdWZvq5y7aDt2YJzwQZ1gBKhXM1euUcRoS7JjRHfXb7vjzLJ1i
	Ms4Aq1BzBUyBYIdGNY8NAg3fCwCZlP6oSWkgfM+51e9voPTw5LDtsIy8da7rMLsFG7ABp5xkWNz
	psx4vbKSoxRqdYd1kgRVo4UTmlozQxrCv9oRYDM7+WLDwuNDKdHXHUXC4CjJK5xUyQXi1SUzna+
	sDTg4N8ESM/rVSpUbbPzRoavUp4BJ1EBq/cRVtxnfjaOS4OKH+JVI+NJ3ia0rBeuRHa4+P3BNm1
	53YDmIvsn4bcL1mBSyKFUNm+vJKDcFtriMXvhKbwXPuBAnV085kkbkjy8WhgDc0LPent3VE7Dvn
	0R2OcbOVJsLAB4vLyxY/QHHZCgOTGtxy0PJnwm60nO8f8qxw4uROjIkt5tS47wIJ5om54cHYllQ
	Oy6F+U/pEU+u3tKq5HuaZc8EHc9/4JJm9FIxzjzclBqNFtuZ6oNuv+HoChMC0gTCq1iW+69Zosn
	t5S4tMXfFehh8B79EKwPfULKzno8GfFINwIot4Fz8jHuyQ9uefqsm/UtjTHjD4Xyg==
X-Received: by 2002:a05:620a:1786:b0:939:6de6:9518 with SMTP id af79cd13be357-93ebd2607damr3020594185a.47.1792071536816;
        Thu, 15 Oct 2026 06:38:56 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93ef4f4986dsm774993585a.2.2026.10.15.06.38.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 06:38:56 -0700 (PDT)
Date: Thu, 15 Oct 2026 09:38:54 -0400
From: Gregory Price <gourry@gourry.net>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, longman@redhat.com, ridong.chen@linux.dev, 
	tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, akpm@linux-foundation.org, 
	surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev, ziy@nvidia.com, 
	david@kernel.org, mgorman@techsingularity.net
Subject: Re: [PATCH 2/2] cgroup/cpuset: use mems_allowed_seq when checking a
 policy nodemask
Message-ID: <atDUMtlM9Z8CPlRo@gourry-fedora-PF4VCD3F>
References: <20261014222456.2318284-1-gourry@gourry.net>
 <20261014222456.2318284-3-gourry@gourry.net>
 <8d611a0a-4ada-4536-875d-061492773e05@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d611a0a-4ada-4536-875d-061492773e05@kernel.org>
X-Rspamd-Queue-Id: DC31E140003
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: ctigdorbnfx86hkpn5jyz537htujom36
X-HE-Tag: 1792071537-328639
X-HE-Meta: U2FsdGVkX1+KBoih35z3M4ottKNELuiypAwMNzzd9Kv+1GQaBbB2D005txnl2eCWcXGpRhva9Gyu4rpir5rN5w1Pv76GG7LN1eb1Q1YwiJWQY95/2jaJkSpss5yGQ+5Qg1UDVHXtJLAFc4jrzfc2TyZaIFaSJPbynchc/tDYI2wCVWPiakW2U+4p7R5054kp7124xiLbaXMqowsl7qGkBI737Ff7PB1HonT1I2ID3OV0GjEZhBbh0bzEIayQnHCqk4BG4h6tJZLqTdUJQyTVB2MAgdrUdTpT1BsbjX+x/bLuofnN9GHLLcPNyydqOYlBSSfINjhtKQ2Z8R1ERvmuXPsAr3Q4GImzFF2yJHxOUK/zVutLDdRIWspWDhGO/Kqg4EKUiZ/6eUj9p4YbMpTMBg5xzRTBb2tIzcA+huKrHCsPloPEYDcCSutvWVFHUHyEZ4JIWfjDUvYRo/syvIN599fkyvtq4eOoIA3uq6xF+oZ+p6HRxMasMHzHm8lxylzkZnvr87v5dAjl+kKTpCt1hXNVHqfenyoWPyY/1063dpkwWykVciG1fFrah2liooOma7rqp/v8Ssr0Iv4ObMEKji79AWv+IkW6gQKHKtx9t3TBzrH/vgSELSgku62e53NXFVqFq/nRtohOonXa4e718DmIt7Or7HnXuS5c6BotRDd5DeIoY03iHqFLOo3GmtU5tvsmEJ5YIiiGtt56OPPN+pF1WotTIh8r13klubtU7LsudhgemRU0OgU2OZux8iguBTbl3cH4ZQdmVQZnafWuDjX7rDceTLajEmjc1ql1JqQ/xM61RbUrIO4m04fkYF9c+aEajb8NBwwYzjL7PVWIRZB2yOJUE6atE5mDJgC9ftxCsx+vFPypbPkBMsFTTzf1gu++plBC1fdI03l1n47S0WR65Li0UK/qyBGzLGD/aI4soScyB6jtolzjnZ7h/ZuDaz6w80HJcGppWnLIM/x
 TI9tbrhl
 rPwGsi+HwI9Dnn+I44E99W+jqvA8FfbjFbMyI2S1DKPB1Li8pG9g2IweZJHOiO/wtvWJA+ElFSNjj270t1jXR4RZj4eCUtEu6+MZ8kHKp5+ekZT1d98R5ah9S9eRuHTPowmxgjb2SabFF0567fY9WG3qmyap6meLJ/a1rm5kVvhyUUgHxGaApKadr3OEkCUKsGut7Dgebm+iSPXOReNerojNuqkSgzIo1lDH+J281uea9Zz1StZHOOKwakvg+YMHXuovyFwaQT5K4VfMvvCZjSvuDUia96ldRuYqco9BH2eFgzU1Xa241DqBjc1XNIgqzLq/g1+adXS914EFlNI1DJymWPVe8LSS3ZhjPlbbjCHDkm1nhP3LezhGuzS7q3Hf2zoEOQOjTO2VkHOj6/X6hTvcnQsPI83HfVeEuIP/PWOXS/r2QQnisGN3QoQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 15, 2026 at 09:59:31AM +0200, Vlastimil Babka (SUSE) wrote:
> On 10/15/26 00:24, Gregory Price (Meta) wrote:
> > A cpuset update changes the task's mems_allowed and rebinds its
> > mempolicy in separate steps under mems_allowed_seq, but the check
> > reads both without it.  This can cause a spurious numa placement
> > miss under some cpuset/mempolicy combinations.
> > 
> > A reader that loads one mask before the update and the other after
> > it can see a spurious empty intersection and drop the nodemask.
> > 
> > For example, a task with cpuset.mems={0} and MPOL_BIND={0}.  If the 
> > cpuset moves to mems={1,2}, the policy is rebound to {1}.
> > 
> > The allocator can race and compare the old mems_allowed {0} against
> > the new policy {1} - which will result in a dropped nodemask and a
> > misplaced allocation on node 2.
> 
> > Simply retry the intersection until mems_allowed_seq is stable.
> > 
> > This covers the task policy, which is rebound under mems_allowed_seq.
> > VMA policies are rebound afterwards by mpol_rebind_mm(), outside
> > mems_allowed_seq, and are not covered by this change.
> > 
> > Fixes: cc9a6c877661 ("cpuset: mm: reduce large amounts of memory barrier related damage v3")
> > Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> 
> Should the comment and/or code in check_retry_cpuset() be updated as well?
> 

No I don't think so. We're checking different things.

The loop here makes sure nodemask and mems_allowed are stable when
compared so we don't erroneously drop the nodemask on a race.

The cookie-check in check_retry_cpuset() determines whether the entire
allocation should restart.  It runs after the nodemask would already
have been dropped, so it can't catch this race.

~Gregory

