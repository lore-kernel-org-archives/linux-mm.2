Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ABC5CD4F3C
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 07:05:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D39F6B009D; Thu, 21 May 2026 03:05:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AB376B009E; Thu, 21 May 2026 03:05:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2A7D6B00A0; Thu, 21 May 2026 03:05:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E25726B009D
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:05:31 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 97CEE1610B4
	for <linux-mm@kvack.org>; Thu, 21 May 2026 07:05:31 +0000 (UTC)
X-FDA: 84790541262.02.308ABD4
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf07.hostedemail.com (Postfix) with ESMTP id C473840015
	for <linux-mm@kvack.org>; Thu, 21 May 2026 07:05:27 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Q8n3MEge;
	spf=pass (imf07.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779347129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xH7qKoIs4z2pm0gBGG10i9tuQP6jlkYOOctvFgABV28=;
	b=kZLx0Djlg0yPzh01b9TVL8tbERZjBo/38LXketjBsKncryIhXB2cGHGZi18ZGjmAAB3vjM
	CsyzSgE6vgG+kXdOlCEsEVlhNq00R8c/S6Q7pfcv4EbPpKHahFCeMaj2QeaQuXWC4jYqGU
	8FAgiTPJ+vFGMEZyXt8kLvfckwmf7D4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Q8n3MEge;
	spf=pass (imf07.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779347129; a=rsa-sha256;
	cv=none;
	b=BWdpxK97Au4b1mC+hyxjzUfmfO7ip2Cf6bTGGyBUpDh2cj1mi18URfYA03AjANMb+i4KvS
	geplRU6ubyd1bLF8EbdJWt70wZkdlBlZkETeY4fx19/FrhBIbgJgkNaf8+YZegTKaeioKD
	RKD6AuFShUo8jdh1GWf6F8s8HYq1Lw0=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779347124; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=xH7qKoIs4z2pm0gBGG10i9tuQP6jlkYOOctvFgABV28=;
	b=Q8n3MEgeuii92IO//S07G850KOoiDn6DjkxJPX0CLFq43OmBgw7YnQtip9O1XUti9T0xJq5Cgl2BcQLmJFQWPB7+R++mKbKCNlVO+rvgDA4+IdzkybBAZ2ukTdXYWytcuwl8TzFZZ4TjBF2jrQA4FquMGPzYwsBYbUB2Ni1onDk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0X3L5YXe_1779347122;
Received: from 30.74.144.124(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X3L5YXe_1779347122 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 21 May 2026 15:05:22 +0800
Message-ID: <aa244c61-b936-4c53-af7c-2f5190867a7f@linux.alibaba.com>
Date: Thu, 21 May 2026 15:05:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2] mm/shmem: set __GFP_SKIP_KASAN for
 swap_cluster_readahead
To: Chia-I Wu <olvaffe@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
 Kairui Song <kasong@tencent.com>, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Boris Brezillon <boris.brezillon@collabora.com>
References: <20260519-panthor-kasan-v2-1-b7384458f076@gmail.com>
 <72bec63c-09f2-4a97-908d-3e6af8e3e0ae@linux.alibaba.com>
 <CAPaKu7S4JCRiTyYvTgXHKP9osH8yh8YVzXiPQuNVAV9pBZtmuQ@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAPaKu7S4JCRiTyYvTgXHKP9osH8yh8YVzXiPQuNVAV9pBZtmuQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C473840015
X-Stat-Signature: mqudtofauhbdz18isnwii74xh96jxn7w
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779347127-479746
X-HE-Meta: U2FsdGVkX18QZZPJ+g48ojpLUxEbqrp4qxdeurLUEle+ZYvGVVacUr/E3+nLZ4huzeLdQ0ZauhEslOoWOSx+pma2hRUnX8GEX475BF6HqTRCQzAaTDMn5kjyUT+I5GV9j9cGtTMXIut+JEG0dB+okOxUd8G5FXVrZDwsLdWfF5LYPSwh/pXunxhA5qb7/IB5nHFH0a6wNWWB37m0IdsILIlHTqfi11vnT8fa1Ki+3En5UxQ3BchXSlEM3NE8dV30hXLTxjpqSwMxJCk3OPhk2O1a0U+bBlNNXl8IbFyBhxwJ6eGTCz3SWLoll9owAHC0SOOq+sCvnjyO1UYy6rn/KX7qkiPjrjVD5WV989QAEBqrV+MicCzaKTk7Nx0TjLRIXJodxy413oxhDtCKoM/OZhavDJVpxkfZoxEftGrBewe0NCimPiPkqDwgtGJOW9mPmS9bYc8E4ehbJ3D40qyM7697Zuk+eCthiN4YKG1yUMm/z889nfZRyJZYDar4iT1tQbVsslbCawByVS++9nxci9zIdIVDsN3OWsaL8Jt7GeSOCDQJUnkx0oMRVQE2GVBOXOt6nhscBeuT4iP6JSVg5ikIPvf7ChdJopG0lq6iz1wqxIz/0kEecqIqsqnUbqfhcoUmJIp5BpMmougbKsOd3Xxj4kg0Pl0M3IKcZaEC1l264XJ2Vv0xt4uuo70iAoUE3pkbQuqEz9QumG38Daj0ESJH4Y//kOu+NzoFbFqgw9z38ZKA6f6iPRNYKO2C7+LjYMAj3NMg3nFUSdKcS1N3h2wfgpswGLsoNZni0v2wCb8jLq2HB0m7lmnIPMJ8EbHM8Ya6VVugAfayhf56LFmwu5JpvZq1wzmq88FBJntJXHI33OGf2yiwsSZZmeZFvrMFwexIT+1bdfFBmANAUFjuPPoeVZN+QfAmT59fnXNMnO5bxXuq9HJtCs4YjFDejrHttEISVI1fqXyW1eidnJ6
 a+02lhu5
 RnLyN43S7IuAOROR+On62hatspKNKbkw4zMvaDxJvcp+bv/2wpVS/WdS0mMKS2KaZF/3DK3VGNO79n48v8VKWdr0mH4JzTHs021H1NoH7j1qKysCeObP7Wl3nIpBSj0GE4GLQ/M0fy62+nsHiwh6OMh7GSeOql1MDEAzuhzIQhRG5sQK4KRY48wswoiX3nqSJse6ACTLdeNaAQz/GPk+pRgmohT/QenKqgJtpz0bpXznFwWocOLPmWz51B32JFcqxzz0xnuKUebQL8KTQoPTtvZsEnR3KgFZuLcGl9+ZyrXfXgGgBN54KpzfjuRBVm6jonxq8mzm6GDsM/7/AvUHpEdKonYxDGPa/C2Ozu2mAIkvGNkRYepfQQvsqWNNb6xwYxQnFH/roXw+X9RbctMGJzoifU9qWYNYxT5baTanJvFvrc+vkxcTd7ry1xOQWE++BFbwObR9r7apJjK/ONy/rphf2NYgy5RhQ8TJkSCZN8ERYkuv9BnwAxLm3JXYqiLAlC8cklZP+3LQjCtNDti6eM8cBFgZth9XIYIRGXQ7GdlGIT0Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/21/26 1:06 AM, Chia-I Wu wrote:
> On Wed, May 20, 2026 at 3:04 AM Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
>>
>> CC Kairui,
>>
>> On 5/20/26 12:31 PM, Chia-I Wu via B4 Relay wrote:
>>> From: Chia-I Wu <olvaffe@gmail.com>
>>>
>>> swap_cluster_readahead can allocate folios for other mappings. If the
>>> gfp flags do not have __GFP_SKIP_KASAN, but the other mappings have
>>> PROT_MTE, we can end up with false KASAN errors such as
>>>
>>>     BUG: KASAN: invalid-access in swap_writepage+0xb0/0x21c
>>>     Read at addr f5ffff81aa71dff8 by task WM.task-4/6956
>>>     Pointer tag: [f5], memory tag: [f9]
>>>
>>> In the above example, because __GFP_SKIP_KASAN was missing, KASAN set
>>> both pointer tag and memory tag to 0xf5 when swap_cluster_readahead
>>> allocated the folio. But the userspace had already set the memory tag to
>>> 0xf9 before swapped out. arch_swap_restore restored the memory tag back
>>> to 0xf9, leading to the mismatch.
>>>
>>> Signed-off-by: Chia-I Wu <olvaffe@gmail.com>
>>> ---
>>> Changes in v2:
>>> - set __GFP_SKIP_KASAN for shmem instead of drm/panthor
>>> - Link to v1: https://patch.msgid.link/20260512-panthor-kasan-v1-1-d8d3e275d71b@gmail.com
>>> ---
>>>    mm/shmem.c | 5 +++++
>>>    1 file changed, 5 insertions(+)
>>>
>>> diff --git a/mm/shmem.c b/mm/shmem.c
>>> index 3b5dc21b323c2..db9130a8c5b76 100644
>>> --- a/mm/shmem.c
>>> +++ b/mm/shmem.c
>>> @@ -1784,6 +1784,11 @@ static struct folio *shmem_swapin_cluster(swp_entry_t swap, gfp_t gfp,
>>>        pgoff_t ilx;
>>>        struct folio *folio;
>>>
>>> +     /* swap_cluster_readahead might cross the mapping boundary and
>>> +      * allocate pages for other mappings. We have to skip KASAN.
>>> +      */
>>> +     gfp |= __GFP_SKIP_KASAN;
>>> +
>>>        mpol = shmem_get_pgoff_policy(info, index, 0, &ilx);
>>>        folio = swap_cluster_readahead(swap, gfp, mpol, ilx);
>>>        mpol_cond_put(mpol);
>>
>> If we force __GFP_SKIP_KASAN, would this cause issues for mappings that
>> explicitly should NOT have the flag? and your v1 link already mentions
>> this scenario.
> We lose the benefits of kasan hw tags (other modes are not affected)
> by forcing the flag.
> 
> The other mappings swap_cluster_readahead can affect are anon
> mappings, regular shmem mappings, or gpu shmem mappings. I think only
> gpu shmem mappings miss __GFP_SKIP_KASAN. That might not even be
> intentional, because gpu shmem mappings pick GFP_HIGHUSER over
> GFP_HIGHUSER_MOVABLE to avoid __GFP_MOVABLE. That was before
> __GFP_SKIP_KASAN was added to GFP_HIGHUSER_MOVABLE.

It sounds like the right approach would be to explicitly set 
__GFP_SKIP_KASAN for GPU shmem mappings, no? I think having users 
explicitly set __GFP_SKIP_KASAN makes the implications clearer than 
having shmem core set it implicitly.

We could also consider adding a VM_WARN in shmem_swapin_cluster() to 
detect any mappings missing the __GFP_SKIP_KASAN flag.

> I guess what I am trying to say is these are all user pages. We have
> to skip kasan when user pages can be mapped PROT_MTE. The

Yes, regular shmem mappings typically default to GFP_HIGHUSER_MOVABLE, 
while GPU shmem mappings are a special case.

> justification for gpu shmem mappings is that they cannot be mapped
> PROT_MTE. But if readahead can affect non-gpu shmem mappings, it seems
> we have to either force __GFP_SKIP_KASAN or to cap/disable readahead.

