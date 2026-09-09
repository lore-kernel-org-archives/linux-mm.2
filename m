Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89F3CC79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 21:30:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2E126B0092; Wed,  9 Sep 2026 17:30:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A04BC6B0093; Wed,  9 Sep 2026 17:30:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91AB66B0095; Wed,  9 Sep 2026 17:30:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 622756B0092
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:30:02 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 654B0A46A1
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 21:30:01 +0000 (UTC)
X-FDA: 85195516602.03.39D54A4
Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	by imf26.hostedemail.com (Postfix) with ESMTP id A3709140002
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 21:29:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ELEKxtVn;
	spf=pass (imf26.hostedemail.com: domain of trintaeoitogc@gmail.com designates 209.85.221.180 as permitted sender) smtp.mailfrom=trintaeoitogc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788989399;
	b=UJ1bh+YETmT9k7xKFv3PGIWm//Zhh4eRxpK9+LBFDPt8tw//5j3lk8U8yftViWYi0npRlR
	0YueLLBkOoWVTpsrGzvLwWqHxD7sreS/wZZ16pwmYZAuhzaMomWtoFoFa5RHienrG8fjU6
	Rvc3FURSwL0Z2dlNZzFcXAg/rYJRgAQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ELEKxtVn;
	spf=pass (imf26.hostedemail.com: domain of trintaeoitogc@gmail.com designates 209.85.221.180 as permitted sender) smtp.mailfrom=trintaeoitogc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788989399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=an1Tj5cri+dCWS5ANKI36kXHxQ7EkrCefVmdgblz/to=;
	b=eIObQP58Pvh77YOzvC1f259bQV2iQTKEBN8B+I6PpbxZqFK2SygoPRDLgcB7G5GRhDHi9R
	ZBo/VoctbVx5ZNTh+WVjtqsjcIZKNZrzxGbydODX6M8mVMh24kisfZCl1XKhkMILJSLMMa
	DE+WtMPZpSg125jkRJK7goJiIF2AS9I=
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-5c8386a01b0so159302e0c.0
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 14:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788989399; x=1789594199; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=an1Tj5cri+dCWS5ANKI36kXHxQ7EkrCefVmdgblz/to=;
        b=ELEKxtVnAV44AEVI6zJr80YY4S8AYWAbuMjdCpPTHsnMMDaCicqgq5Rjf/MNuPlhgK
         4Cf4P6WrkL1a8vLYj4zDcE2HSbtOUDxl05fdjQpJQhWeOBUUzym3iDmJdBidVLbp40R3
         a1czMgsI8wqP2AfAzX0ELdceW2SA9jTvDY3PQ43URKn+4QHnYU8rk3G3y3iWHy/DEvct
         8WVx5G4cGH3/nsrJdKC+sVLABrMu9INyIPPehdsc3Qob7k0/f8NJD0PflPuCWOSmEIsU
         MJTUqpXsiV75W/anoOVdbXw3ZnrTafHrq0zblPGN558VV91JWQSWD4urNQwp88s7OTjv
         NyFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788989399; x=1789594199;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=an1Tj5cri+dCWS5ANKI36kXHxQ7EkrCefVmdgblz/to=;
        b=UAo7M5rga+fc4a3H1ZVAw53yjvqwABgbvEIdNiaWIteUeSoL6C61NU0D6oPzbu2L5R
         ne23EFF2s2CbaPBC7Sg4VRK/0WaQNS3dxEHUM6jpTZwszHHyLLJ6OJ31KkZg6x07wW79
         BzBNiGlRf5Sl7u3xXe9ElchejCw1yFWRtmXEfkSVc8iJQXx+kzDfByrYGQ5UfKDkQcri
         JA6itADGuVv3XN6IlWbtjh1mJvH8TTmFW8kVTCSxiXfO3ezb1VpQvBgBxSUmBPEOCu1O
         gjPUGJYkCZr/IhNpRkjhUUn5V1YWLDbZYocXQm+vg8DWCjJAtBprE0GlLTebcUvQV5SM
         vMsw==
X-Forwarded-Encrypted: i=1; AKwUvBzcrZHPPGvdnojeLvsrPC/aDOFN2wkvsbm5Eo41Q8PF50dgY3dUQCp75p9o3LB1fozYzDvsK0WXYA==@kvack.org
X-Gm-Message-State: AFuF++nTUntPo0eZAJBphW3/r8XaJDA3JJg5wRlpdBcLjy1YUVzK8YIv
	MORaduCDZhwhDQ02NkDiIQ2tHhqhBQ9Yux1KbZirCUEIIuK/hasOJGuH
X-Gm-Gg: AYBFou06cyZQi/oCQgTCmPV1iPLbakQn5kA7BQDbpCmmCHox/La42ol1A1s8sAVycIJ
	fX+RyGqIFL3XT59aVs8OlEODKXOtlO4c5YZKxPn+SUjrhAAHIJ0IE1+yrKHD/2xX/L6FTWFThJJ
	4RE7h4IEJ+/+eyWi+7c+njGDN69EDuy5ypM3cVo0FrpkatVCXsAS1rDWWQ7jV70KMVMCpwdK79O
	KR30Tezp/Oj1YCHVcNF6xDdRkOVszMRBn4nuVNMswMneNiacFIZTNjQyaPQiLlXYPudG+2eiKGi
	5veVdth3ViguCANQ+3nkbmRhuRyefPbrK9F13oq20Hk7u+lQ0cduQNHeFCrhjojBE2BuxlmfTHk
	GvmwAU5VaG1zQ3AMVvrE7LZY5aSHW4x9SjMe/DuOxFiApKh2quTcYnse898671ih13OAAKoLtp9
	TdXnP64VN36ks9NBBU6uq3kcrSw5tUQMihGdpmM7tXFdQiIIO2c8y/TNF0c+BgeIaJMIuBZLW9l
	OB9a19YTQ21E5grcFrwEgd4QODRHK99Qb6FwaxtaimuazbsQg+3wA==
X-Received: by 2002:a05:6122:f18:b0:5c7:a814:b987 with SMTP id 71dfb90a1353d-5c7ed298f6bmr21767535e0c.2.1788989398659;
        Wed, 09 Sep 2026 14:29:58 -0700 (PDT)
Received: from fedora ([177.21.143.191])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c7ec35d85fsm13861007e0c.12.2026.09.09.14.29.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 14:29:58 -0700 (PDT)
From: Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
To: ljs@kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	lance.yang@linux.dev,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mhocko@suse.com,
	pfalcato@suse.de,
	rppt@kernel.org,
	surenb@google.com,
	trintaeoitogc@gmail.com,
	vbabka@kernel.org,
	willy@infradead.org
Subject: Re: [PATCH] mm: bypass datarace check
Date: Wed,  9 Sep 2026 18:29:43 -0300
Message-ID: <20260909212943.539665-1-trintaeoitogc@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <aqFWqqvUEiie8cYq@gremlin>
References: <aqFWqqvUEiie8cYq@gremlin>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A3709140002
X-Stat-Signature: sctg94kja14zpifzshfxftmnrkemuytr
X-HE-Tag: 1788989399-662254
X-HE-Meta: U2FsdGVkX1+QEvu9igXHKgWgPbbpW55Zk0KCEy9vKSo/k9WO7ROJR2Zb5srockH57xKRCEF+aXY9/GzEpdenq+5k1pVHkrRa8kDg+j7irCH0WWBnHO1rBPNXEEclUUjS/8jIe0uM4RWvdpfLyj1nlsZns8WEe+sg6RCcoqZYmcrefrJgT8Qjvjj3JDXGvwk8hftMbc8D2PPwpbzaqAqNtDkPBaGYlk1HJZSsA1AIhQTZJ8M38GmPuTQ3dFHw+lEv3ysD02vID4MSPWZd9PZOWVFrTOJnnmunEuuK99JG08xYrA8j1OF8kcTnIScalra0pt7PEk53Fp5pKIpSU46L6EMWPWwJKOly9byb2p+F+qBScH6z7IW9GKZ2cwkAgwMRIFPMlYfXkF2JdfteUxkF2O0lI99dw+OQJYAz3edHzg8wCtJO022YEYxUUSOaCe34xSNrk1AtVP2nF+M0kHH5E6Iz5Or+lWElGDHeE82eChtETkr1yMZvQ1TRf2+AjlzuOFbWyle4X/ebGOYE76idzZotdLBTSJpzBNwXqMNZIsWvdqrkzA0bM6ISTlI2GwMTdOBCa75Jpk80g6zTTjYpX4rwTPARUKImclrHMcMHocZ/ITacuHVLzCRoONms5HZH3qao+/Q87kNY3FdFSDDMrIRcJYCu1+2M6y+Eg5OtaZwqDsD3qYRi//N8ovo13ofG+gnBrErBIJRO/r8hUclFLu+ttdIJJSb92RHCJ8cYXCCO0CbfRsSn4GK+1TfdEbancqFf7qGc/WXAukD8klDVmJnvCmq7+RkEXMexXr6GPan5GaLAisjKmp8zpF+o291YSPD9dPQZeB+t7x2CIE4zzKfsrBlRBY+/r6lR/xYAI+vP/E01TWuUPJfOaW57oEzUacGnvpLRKhiGT4XJSwsV6yAT196pYELrChelFgRXal/3wlUT83i1wY9/q1WKepfejaW6NOt7VYSRlgKph+e
 A8+ELJbg
 fDV8TmINNH/IyQHrqbSQgvAz9bNRAptR5AehZKE1K/ZngZaeZROz63PELX0KSIdkptSQEp8dou1DSeiZfoJUcCznfL8J51UFUetD0X4u8bn2urSK5UsZLPzVVt1X/uoCjF47iOhVeRVmqgBdx8ShjuxUFYHdz/p+u3JJ9JVWjeaJf3L3zzSOHGkLmHIpApcNnOR74Uzko0JlfvJIAP5w3QDodOweaKUxV4VN6eQuZJUrdNme6mYMzpSufFlzMjDUalCxkBe4gHZBYtDMyJMldzP/miZullVPYcX3J8+relSi3puNFKxvO29LmLYthocLNA9nyRcHlkJe73VxC3wejWkAL8kWkn3C40b48G/gIQHYrYfO0mQ3Rpj2Rdio2ac9p1rF5d7nyofjmxJFVdrdt87CSEqoiaQYreCeE0mZvSC3T2FH1aD/1Fm6Wmg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:
> I started review below but honestly this patch is confused in multiple ways
> and it's not entirely clear you really understand what's going on here.
I can be wrong, but was understand that due the order that the code was write
probably the data race problem will not happen.

The reader (__vmf_anon_prepare()):
```
if (likely(vma->anon_vma)) // lockless check
	return 0;              // OK

// if the check above fail

if (!__anon_vma_prepare(vma)) // called the __anon_vma_prepare
    return 0;

```

inside __anon_vma_prepare()
```
spin_lock(&mm->page_table_lock); //ACQUIRE semantics

if (likely(!vma->anon_vma)) // re-check under lock
    // ... alloc all

spin_unlock(&mm->page_table_lock);
```

This is safe because, if `if (likely(vma->anon_vma))` return NULL, we will got
the mmap_lock and then page_table_lock.

The critical re-check inside __anon_vma_prepare() happens under spin_lock(...)
with has ACQUIRE semantics.
With ACQUIRE semantics , the cpu (or compiler, I don't know) cannot reorder the
memory access acress the lock boundary.

I'm right?

> 
> It's also basically implementing what we suggested.
> 
> So at this point I think it's easier if I send the patch with a:
> 
> Reported-by:
> Closes:
> 
> tag -> you, this patch.
> 
> Thanks!
ok, no problem

> On Wed, Sep 09, 2026 at 08:57:23AM -0300, Guilherme Giacomo Simoes wrote:
> > Despiste kcsan point to a possible race condition problem, this is a
> 
> Typos  -> Despite, point -> points
Hmm, is not the first time that any person points my english mistakes... I will
improve this point, thank you for yout jints

> > safe race condition due the access memory ordering, since
> > spin_lock(&mm->page_table_lock) have ACQUIRE semantics and ensure the
> > ordering mapping.
> 
> This sentence is a bit confused. Acquire semantics mean absolutely nothing
> unless paired with another operation and etc. etc.
missing full stop, my bad.

> Needs a:
> 
> Suggested-by: Pedro Falcato <pfalcato@suse.de>
Yeah, I forget

> 
> Also:
> 
> Assisted-by: LLM?
> The list below reads very LLM-ish so I have to ask did you use one etc. etc.
> 
> https://docs.kernel.org/process/coding-assistants.html
> 
> Perhaps given I am suggesting a lot here a:
I don't have installed any llm (not even cursor), I just use a deepseek,
chatgpt, etc.. to clear up a few questions. (maybe I should start use this to
help me with english too)

> There are other places where this check is done and etc.
I would should checked this, sorry. Anxiety.

Thanks Lorenzo for your review, help and patience 

