Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CCAFC4450A
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 01:16:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00D446B00A2; Thu, 16 Jul 2026 21:16:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F272B6B00A3; Thu, 16 Jul 2026 21:16:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E64186B00A4; Thu, 16 Jul 2026 21:16:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BEBE86B00A2
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 21:16:56 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4CD8AA0398
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 01:16:56 +0000 (UTC)
X-FDA: 84996504432.21.76AAD36
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5946240002
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 01:16:54 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="R/x3Ix+H";
	spf=pass (imf27.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784251014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SIDjRquBy4YJKkzONeBnIvIFlWxts+jE0CMwzUMcbKc=;
	b=rz0ueMiEhZPaaLHBCJVtnGsXNnUZiiVb+HseYe3tHMnpQm6838tNPqyDxV+JpmaXAf4+P6
	VLQLt6jCIqFYwGhohqgcy2R7iZewS4GHVxE0mt2hhgcqx5FzvHeruUwIWmJeli+8mkn7rw
	tbrtBzzswo03sVlyEN8pHGJCq0ICNoM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="R/x3Ix+H";
	spf=pass (imf27.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784251014;
	b=SwpOdTF6dz6fkdymDr3LnxsvWs+vdeaq8JInBYIIRFrgYx3j3z882S6WlyMMBJVtY05VoO
	i1VbIi9VRwxzsFjm50Bt56i1BhqhEPpcKsAfxdotPH15HNVm/2pfRey+SlmdqGgupxkraQ
	RpGu6fkm/QRYbV4q1yX+DyiXH9d9a+o=
Message-ID: <c993627d-9071-4fb4-b5fe-e0a49ed26abb@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784251012;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SIDjRquBy4YJKkzONeBnIvIFlWxts+jE0CMwzUMcbKc=;
	b=R/x3Ix+HPE5GedYZWQsjBQy4X9l9tXKZ6io/MGnznvuPOzxBS23Qq8XuWUb0D/ZBYkSpwL
	u4DJojxrnGHpnwWCBZj66YWuSXG5e79ObwmYJZ3A+btzc11gQ21bKAqZ8wLPRaW+Csh4GI
	FXrGc/t7wOT0O2BTNZkyFwcApcr+CtU=
Date: Fri, 17 Jul 2026 09:16:19 +0800
MIME-Version: 1.0
Subject: Re: [PATCH slab/for-next-fixes v3 0/4] mm/slab: fix unbounded
 recursion in free path with memalloc profiling
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 "Liam R. Howlett" <liam@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>, Kees Cook <kees@kernel.org>,
 Pedro Falcato <pfalcato@suse.de>, Danielle Constantino
 <dcostantino@meta.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 "Harry Yoo (Oracle)" <harry@kernel.org>
References: <20260713-kmalloc-no-objext-v3-0-47c7bd138de7@kernel.org>
 <alkypcRUZa_r6uGV@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <alkypcRUZa_r6uGV@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: khdcg4iqdretmwuu5ig8cnz6cffzgb37
X-Rspamd-Queue-Id: 5946240002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784251014-315987
X-HE-Meta: U2FsdGVkX19XA6QG/UkNMzvV/Aa8efyVhKUFA+Iq4UKlBN5+lIMDM/qcO2h6rGS+CuhYvOqIAmpKDXSx/iKm1wkxkEQALk7cEAwyq5vKm8/TmmYTyo2gBlhxgH+cYWbtVKKfx0ZmsPswg6JpEZpGQy3SmJdvf2UZxVI7bZXXsLuWyiRuIzrCpxhrJEsA1HvxM612fvvjoRRy0Lc4xSLZCgUbuu1i03QhXCMBN69713dLhRpbOaPO1HLo3CCFKF6VVav4wTRm1BN5G0de/R1mMkgKstfyhrpmAhlFP1+GKRF+LAOqs2d/A8SsH+MT8H/RJsTHL0hlCLkvtDZ5HYQzJG+aIhWeOJCBp4Zv0qAcFvgk7zpAozuhZ6SLj/76dVvG1QQPOnwk1cLYfwopO9/5670pe1a/l/xCO8phiPk/WHdTiltKUinsftxq2RBIvHP5FDmMpvqynkEdROW3ZzbtO7xelYhtdUwbgOEDBZoF6Vx1HaWYwu2qDuPFFfmYEVHfjH/G3FcwGAK8P0emETxun6i8TrKCFYNfDXL42JYGFrtfEL6iuyPKRwyqyHlJfZ78cBYU+Yo9LqR9CvKFbRORvLFythVzIYZT6ORfnJofBv/dBmi37fxtr8DHDsb6eY6wJuAcvtepnFondHzXPJcKAwmLXrMymeWGlJ6JaoEB43qM9tOrybucGiPmz7ZvBjWkk7L3cjJEVCJKY4VCxHBr91YwjX1ZpbXA781gPvQRDVOwoWMt3HdrlXVSA3Hj5jhAl2QFLmZwAL/wcx/laf9iT8aig6aEO1T6F5XdkNV8wBlQG1zI7xjWF9sxapii1tHSLxDvezW9PZcqsoptn5o1j1YIxPE23cw87L1ltE8BZ9Sq3fV4L1EmMXCN4TNYSoCFYgg1EhqcNTWE8pB/zcYV988pWWLFkxNoSiSHSJh8La3aNI+EXYJ/njUCdIo8uDwLMO0tTW0QZb+LHavxjMD
 AzrYoDYA
 I8IfdAfEuE3EVd9w+1sleuulbO+po/YrFDL6fnKBpPu/4l5RYSYsRK3By+dWx44vQ5Pm1R5un8CuW/27vM+9TntTwfwVxefnm7rA5OMqjpel+4FXmFcY7RwadpmLnhIZ4zEQehoPsgtnkeOtCci2kL0IOVBZtw8dJeuseWOaaynS+MS6TXxnkJ0vn/r5ilyp9GpVG+RAlbnZT+lKdSDCCBU5EUKRKBkBKn/xMDODH27UWcGfnUw9B2ldYZM9ycUeHGfR36ssBrDstXo1I1b9iC+KnlJ4EL5boWe2CtJbWTXL0WdHX1Q6P7WhzZEWdqgAxMcYk23rcC8Vw4YBvRsLneOoG412CNJ/CLVhKaTG01D/tQ1FHw2LSUy+Orr2W9JWqEHb+wLyMZDqI2BteBsxEOEnqNewAlXtwEhN0zDKfDkTqzUcRIkQvUERBQadjRhmljkLCT5/FqiDM4v7B9zll/Q4O/ACj6oiIRxtJA66HGNLNzVvYim3VuNm5n247Gxj22ttgbP2XFrdG5eko97N6vfImnSo/RWwT9MnfsJbieATZFxdfWFXMNgJ28x8hXjQtmZysWOFDcukGOlQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/7/17 03:37, Shakeel Butt wrote:
> On Mon, Jul 13, 2026 at 11:28:48PM +0900, Harry Yoo (Oracle) wrote:
>> This is a follow-up fix after the recent discussion [1].
>> See patch 4 for the detailed description on the bug.
>>
>> Based on slab/for-next-fixes (af9ea231c0b45) and is available at
>> git.kernel.org [2].
>>
>> Instead preventing cycles by bumping up the allocation size of obj_exts
>> arrays, it introduces a new kmalloc type called KMALLOC_NO_OBJ_EXT and
>> disallow formation of cycles between kmalloc types when allocating
>> obj_exts arrays. obj_exts arrays of normal kmalloc caches are served
>> from KMALLOC_NO_OBJ_EXT caches (that don't have obj_exts), and all other
>> obj_exts arrays are served from normal kmalloc caches.
>>
>> I tried to reuse SLAB_ALLOC_NO_RECURSE to make kmalloc_slab() select
>> KMALLOC_NO_OBJ_EXT, but it was not great because it does not allow
>> sheaves for those caches. So I introduced a new slab alloc flag
>> SLAB_ALLOC_NO_OBJ_EXT.
>>
>> To avoid huge confusion, I had to decouple "disallowing sheaves"
>> semantics from SLAB_NO_OBJ_EXT and introduced SLAB_NO_SHEAVES.
>>
>> While this cannot be directly backported to v6.18 and v6.12 due to lack
>> of SLAB_ALLOC_* flags and kmalloc_flags(), I don't this will be
>> particularily challenging to backport it. Instead of a new slab alloc
>> flag, we can use __GFP_NO_OBJ_EXT to select KMALLOC_NO_OBJ_EXT as
>> kmalloc caches don't have sheaves in v6.18 anyway.
>>
>> [1] https://lore.kernel.org/linux-mm/9a139365-28e6-4f1e-b35b-7f6091e9aa14@kernel.org
>>
>> [2] https://git.kernel.org/pub/scm/linux/kernel/git/harry/linux.git/log/?h=kmalloc-no-objext-v3r1
>>
>> To: Vlastimil Babka <vbabka@kernel.org>
>> To: Andrew Morton <akpm@linux-foundation.org>
>> To: Hao Li <hao.li@linux.dev>
>> To: Christoph Lameter <cl@gentwo.org>
>> To: David Rientjes <rientjes@google.com>
>> To: Roman Gushchin <roman.gushchin@linux.dev>
>> To: Suren Baghdasaryan <surenb@google.com>
>> To: Hao Ge <hao.ge@linux.dev>
>> To: Kees Cook <kees@kernel.org>
>> To: Pedro Falcato <pfalcato@suse.de>
>> To: Shakeel Butt <shakeel.butt@linux.dev>
>> To: Danielle Constantino <dcostantino@meta.com>
>> To: Liam R. Howlett <liam@infradead.org>
>> Cc: linux-mm@kvack.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
> I tested next-20260716 which has this series against next-20260707 which does
> not have the fix. The reproducer were able to trigger the leak/recursion on
> next-20260707 but not on next-20260716. So, you can add:


Hi Shakeel


It seems you have a consistent stable reproduction method or test script.

Would you mind sharing it if possible?  I'm sorry if this was provided 
earlier and I overlooked it.

I'd like to thoroughly investigate and learn about this problem.

Thank you very much.


Thanks

Best Regards

Hao


>
> Tested-by: Shakeel Butt <shakeel.butt@linux.dev>
>

