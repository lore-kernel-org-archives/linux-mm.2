Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54FAFC5DF94
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 17:40:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D34E6B00A0; Fri, 21 Aug 2026 13:40:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AAE36B00A1; Fri, 21 Aug 2026 13:40:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39ACB6B00A2; Fri, 21 Aug 2026 13:40:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 11C2F6B00A0
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 13:40:16 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A4419A0215
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 17:40:08 +0000 (UTC)
X-FDA: 85125990096.19.86327C0
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf23.hostedemail.com (Postfix) with ESMTP id C9DE414000E
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 17:40:06 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=KttZ4WGw;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787334006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g/LOIEO2zvXm+1il73lApOnhY9ShiLcmm1S4Hmc7OsA=;
	b=69UwSWAmET2nx5CpVJmoYMmyXqVIhIVzrBtVkYmOstw1j0Zq+VEPzBsacfm6NyLGzqQjkL
	2vpvUzcAce/zdj9tP8si0BU7EQtASt5ZpzKbOj4/Ao77dhGPBA/KV6K8ARPPP74DCfKkUA
	hgqnTuhY8KYXRLdKR7nWbjauhuz+l8Q=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=KttZ4WGw;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787334006;
	b=ZxXl44GGfc7qClOoTEsNohOWbQwwf7JeVzFEc8yiU+Xpn691URMPAFmNZahqlvitrgIxs3
	4kTMV/k2mczptEIoY79E0DPoXVYlP1iLd4KLofWCfAw9BdUjeIuiFb0JnJqYA5pRmGWwcS
	A6kxKqZzQw66a8XWu+Dj/S2LYsXFE0s=
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-93695893ac1so83755985a.0
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:40:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1787334006; x=1787938806; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=g/LOIEO2zvXm+1il73lApOnhY9ShiLcmm1S4Hmc7OsA=;
        b=KttZ4WGw9+fvR7aoOx6w5P6dT/54lYX4cPHSOmg6IKqcEbAXAoRYpnpgIlDiiR3qie
         WpfamcPXxJQE948VhSg1vQnRigDXT72zbDdGhawlLvX8rfKmLTjzNZ9/sDwCQfitv983
         5aPKR5QTNXIHnwbV5kRS243qYm7ILVRz8FvehmVuhTxbUuqNVMM5biKLU0HzsnP0F4k0
         AL3b8Yg2FLT40/KfTbcSEtExI//n7XWwfizwFu6PyNsUYe9/Yax/ODy0Ba2LcwQveKUS
         b/P0uEgffQBmulAJ5XGHdV7NwW47ujeqTGRUSS4DaQjPsYmu5p++lk0NWLOB8Ga3hsdd
         V44Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787334006; x=1787938806;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=g/LOIEO2zvXm+1il73lApOnhY9ShiLcmm1S4Hmc7OsA=;
        b=oZ7xNG8jG0+EdfTwKoyeJnJwrSIDKMGQI2DmOHwshWGMoB7G2hLA0ePKV/cbuOdA0a
         JgPc3lMHZF3waOPkhW3e+nOkCZa4UaIlluDdJfgyGT1IKTFGlrtcyM+wdvJV7raZ3CH7
         4R+dzdDFxgvRlxLYxdqyQs2NGKdzIwAfssWpT6lf+HVQlIwEhVNw/FN1Em38ky1fszIv
         YktUOO5YHrXObmoIt9G/s0XNk30s5Mzf4+3xOi+H85aRYw3qSQyXbIirhbDLi5a7lEfi
         bo5lE5KCFXVLonIu6EVoxyHLWk7MoWT84pY7OPiGZtM6L1KuFb9fygB7eveU2Mr9xJN4
         vnBQ==
X-Forwarded-Encrypted: i=1; AHgh+RpynJyRAdBUbh70reRkezXeev72sfqjjYGcE+2JjnXeZI9ky+OqJC9OpovP5hU3ewRNrRWooqOceQ==@kvack.org
X-Gm-Message-State: AFuF++nI0Lp97KXSyxpeuJDuDMZFvko+QMFHfe2nXJv0pPx1ToEz7c+A
	QwaY3K0GqF22TTWRTrv2YFp+dKF3sIklVNMiXJzzzRMlPDZdxGbq17d91iaBscx9wd8=
X-Gm-Gg: AR+sD12Ahy0bltp93yBcdNwN46/zb/6tjJkzgR4tlR6cmOde2y9cewmma9sUkek7P/X
	xLfzqUYBtR6HkGIGoIiEzNWdVjXUfwBfSJQnc517b/x4d0UYseggd0aSy5oTJxCpNTz5nSJ/oDu
	L7/NwhN/XBoh1FO7ylVb0ZJ7Gt1gwOiy+WhHhUh5SCl7iG/dS1M1bGzqhavRDkp8+Zsyxnqrqpu
	igFYzq4hBPRTvzWOxLzWJ8oo/g6N4HF6p4xsK2iXWFAaqTWuulyuhYxgPjBWOZlTk1KPXtelSL+
	8EyXIInqFzt3s0Q+Q5kM0OAQrxKfJkE4RBP5ODOaRHSgALZopM9o0NgpBEJAbo4NPmVYyQvSp2c
	N4jRxJ+1na/pGaD4gTKz4sqQcUPzxzj9GgLCIN8lUiWMQ0R3ltO24sXO6kanlK28BJTPXSOLi4D
	EUKvNNfZta9/hwUSqbvFZyOcGgeH9nvlpNR39K3ndDuLohfuQ5Uu282a84ZnyKEtXBziarpTZpu
	lZFLuwPoGVlMPVoSj00x4WchKzXlVKsCZqmGXNxDqGF
X-Received: by 2002:a05:620a:400c:b0:934:b07f:aebd with SMTP id af79cd13be357-937395d0cccmr654779385a.46.1787334005582;
        Fri, 21 Aug 2026 10:40:05 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9372ea69aa0sm392753685a.4.2026.08.21.10.40.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 10:40:05 -0700 (PDT)
Date: Fri, 21 Aug 2026 13:40:03 -0400
From: Gregory Price <gourry@gourry.net>
To: Eric Dumazet <edumazet@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>, syzbot+0dbf6d295b3350944f0b@syzkaller.appspotmail.com, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org
Subject: Re: [PATCH] mm/mempolicy: Fix sleeping allocation in
 alloc_pages_bulk_weighted_interleave()
Message-ID: <aoiNNC2fPdQz0f9S@gourry-fedora-PF4VCD3F>
References: <20260821170407.3721004-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821170407.3721004-1-edumazet@google.com>
X-Stat-Signature: e78woenqo3ef1nz6m1xjyo9tuwcr9t4s
X-Rspamd-Queue-Id: C9DE414000E
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787334006-826088
X-HE-Meta: U2FsdGVkX19hpD4dS2WAJIVtEJ3TXZCjMYhfrUc6nwz3vptNO+rmXTI8puvYqFIpCsA5181Fw5xoo2zYl5G6dIcvL2hXAb9fx0UU0iYdtyWhmLg8p0eLMChH2gKKqZA/9z03PrSL09QWMFJxDXWEQHSmCWw1U7t9krOBeyZFWyW5NvdD1MMevhQTeq/Z678u4ZorKShX/o8FfsWOTpdOgBRdZBBgD86gP0oS+m1AbskCw4cDPPp8f5xHaQXVSZGMUw9GosZhqPW8kJCaZMqewcwlpexXphOtIWx5D+fEFa0Tn8XAaml2OtenKgI6avQ13zLKsVpne781MDTu9YXKQrU4Ryk/Y2Acp2Fi8dcQCtkNdZ9jJNKauxyKDAbF+NJpxKTPKc+Ee1VptCfiIzhA5abMB35jayUKPQ3Pi9lIxahYEWtG960Bb6DXoy2p/f3HN3CVabW1bExcOT17U0Ld1s63j2QhGRepht1+0amRIqEa68APUjkM2mo70GaCXEjkPGVbi62b5T/ORBz02xS43AOmfKZG7ly4i71S1aQJs92e5jrHjjdfnyK6RTMaL21E5o2qZItkn6GB6sxyz/Ryp7cfGJ11r6op+U9tE4HHXOP82I4eFCTCfqguWgkCIzQgC97rR5L8fmCB6J4vh+JPW6y+1JDjATuEm9fbJ9TF+e30lpiHpNIvx1CpwcbIJQGzxGJ6hPoJucKsTcwtIw07kVWFOX0c9QTWw241aRJSEP2TP0Fjix9AHjKo9PnIXbwdakFsHMdrNIwSY7SYwgOhnHLeuXXmN2kokm3wofspIO0FpXYms+JW4saIS+KeOYnWqKmWPQepkn9MZC9Jw+HQedEIz39vcscG5G0pW344sMg9Sh50naS2hcuoMS2phkOLfTpTO2CF5Ld2FBrQ3coExHwZ+YaOg+dIWMM9V+i2u6a2QJKNnfAAvNTnFiKE6u8YXvLmJguAVCQAQOV9U0D
 50MnUmNP
 tg9h6sMm91BJyhpKs478eeuSy1c1LClAfF4UZ/rt7QnuJ2F/BhSsjgJHt0M0JKKu+CHRffbZ+CEmqvTT0MImFlG8+4+ma3heHRnl8kEhrbQesig/z5dEljNGdCcFEUdslW/sM/Suw5NvJhBTZdskzYTKf3QxsMDuV3mGmlnibcHw42CAt4r04OSD03SfFylP9rZexQhK/A2PEKCHmQJnaeIQVYjyzn4lo++oCyqHKpKdVULURFVtckfB6bN6pCG8PfBH7aw48++RLmhVJB2QF3LfmuuBEoSdngNOotYi+zVMtUn6hDu8jULa7qqIG9tFMwQQNJxiixOQrLiCBnsGU5z3Zc/AetlrgdbSQuJq2490dv+9G+mmvZQIfsc6sZ40YpqsATvuF/224N4OIjD1AI0HqfN8GMMaWU0HZFru/tq2C1sfyrEuuuEwxTZJa42yRB5l0QM9m2ZchPoPVaAbV6R6WHHBdLASaH68k5PrycU+xi1H2zftg7kimnAMQ5iglZRUmZCbhlA82s8XvltSuqXHlhmhT6CioGTrDEH4S53NnTJTmA7b+JhMlTiSZ59MiH3HsQ3S2moc4fiwADjeMVUhDDUrPpsnHi+XiTJtSVXkgKH9Dp1rdgbWUk9DmfMn9qg6TreQ58zoNiT6AfqsZX19MA98gricAnpeEEeTkRq/wD6Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 05:04:07PM +0000, Eric Dumazet wrote:
> syzbot reported a sleeping function called from invalid context splat
> in bucket_table_alloc().
> 
> When rhashtable_insert_slow() rehashes the table under rcu_read_lock(),
> it calls bucket_table_alloc(..., GFP_ATOMIC | __GFP_NOWARN).
> If the bucket table allocation uses vmalloc, __vmalloc_node_range_noprof()
> invokes vm_area_alloc_pages() -> alloc_pages_bulk_mempolicy_noprof() with
> the passed GFP_ATOMIC flags.
> 
> If the current task has an MPOL_WEIGHTED_INTERLEAVE mempolicy,
> alloc_pages_bulk_weighted_interleave() is called and currently hardcodes
> GFP_KERNEL when allocating the temporary weights array, triggering
> a might_alloc() splat in atomic/RCU contexts.
> 
> Pass the gfp flags (masked with GFP_RECLAIM_MASK to strip page-allocator
> zone modifiers like __GFP_HIGHMEM) received by
> alloc_pages_bulk_weighted_interleave() to kmalloc() instead of
> hardcoding GFP_KERNEL. Since the weights buffer is immediately
> initialized in full, kmalloc() is sufficient.
> 
> Fixes: fa3bea4e1f82 ("mm/mempolicy: introduce MPOL_WEIGHTED_INTERLEAVE for weighted interleaving")
> Reported-by: syzbot+0dbf6d295b3350944f0b@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/lkml/6a88837e.ae6ddae5.3da009.0040.GAE@google.com/T/#u
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Yup, seems a solid oversight on my part.

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

~Gregory

