Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17BE2C982C1
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 21:26:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 031CE6B0088; Wed, 16 Sep 2026 17:26:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F24556B008C; Wed, 16 Sep 2026 17:25:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3B586B0092; Wed, 16 Sep 2026 17:25:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B997D6B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 17:25:59 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3ECEC80183
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 21:25:59 +0000 (UTC)
X-FDA: 85220908038.16.B5257AC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3512C40008
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 21:25:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hpQZ9RnR;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789593957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RyG32OZnVLifyoGGiBLZCyOUSDArzniLs4zWt9IbzBQ=;
	b=Uq6gA/U/ZvI9IsnaIjmWJvXe8Ts/WG9qc9GCZp8/ovhFx4FNNZc+0rjOR4YKtgNhODZJmG
	UnLFzw523JWkYkQfvhTnTdjdBGRsvyUMYxbA97IUP1EIypSC23a65pOKvHWENXNMbrn/1l
	xL3qluO5F6DR/iT7DRIB1jgrQT19+ds=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hpQZ9RnR;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789593957;
	b=aPrzDrJXPm2PA73m83tBzrxcqzAQJPg+emOnKqDiDo7z9AQ35cXm25h4jE9llzQb5j5hbH
	d1R91JLyN82hBcQKb5ygVDEA1bU1xmTJJlA2+6We0c/WP8xwBs1tlz95j9fgN51vEngiD3
	UN3825/+5De6XnX8xlV+69XXsVqbleg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 37C7E43FA0
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 21:25:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C6B31F00898
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 21:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789593956;
	bh=RyG32OZnVLifyoGGiBLZCyOUSDArzniLs4zWt9IbzBQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=hpQZ9RnR17VFJCBnpSLHQHArHgNl3RepT1nR4bYzIWUS3N+/wO6LLkfLtkfJU3ON8
	 fb5dxeAr1t/wewGL3ITr25JUiGPIvLFRvqhw6iVzgH6ufDyRsU66NL2xu2bYEtBqrq
	 u+OLu4mK1eSSMR4R5Tlop4WHh7x87DG5ubTBipOLHy2D3uM7ZS4SOALJK+d1cv/HOt
	 J0JUM5LfOeE13+EZ5rVs4ce3BhkjDFQ+JnUMRD3St2+XWoEMPo8wam861oyrNu2o+X
	 aecNIteDvDbQu2s9nkG+MNpC4qvy9QGGMQICuUt5D2WFUzVdna76djGh9m52iHybys
	 AXb1CQLg80dfQ==
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-93a0fb2f9efso6830285a.1
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 14:25:56 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzNShpaD88Gzv65f7yFBxZde/f54SXfws1Zd6SIM16yaCVCaY7UDvK73wWJfnuicU1/IIrtArsBzQ==@kvack.org
X-Gm-Message-State: AFuF++l7w/lQ2Ig4/2z2MbW8inXzN3MZk33hwFqoCBQ5DSzgoXhwUH7n
	/E2N/hbXt+nZKsI+tz1dvCz55LYsum3v2I7WRTODEfGtTiYDeYfXE9dalL632G5IT5iz4409qjK
	HnQs2AYFTEpejAWjvnNzdLSr6XXbAn6Q=
X-Received: by 2002:a05:620a:254a:b0:939:72cb:bae5 with SMTP id
 af79cd13be357-93bc63aeecbmr185449585a.28.1789593955456; Wed, 16 Sep 2026
 14:25:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260916123846.1242548-1-ridong.chen@linux.dev>
In-Reply-To: <20260916123846.1242548-1-ridong.chen@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Thu, 17 Sep 2026 05:25:44 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zwP3_+EYY5Ug9EJ+yD1UdxsBSGr25u8s1K3u_i7LH3Zg@mail.gmail.com>
X-Gm-Features: AcwNN1U_Oahmjpys6FCeJ4MwOMSgsqJzEXz6vLLi31aVqCJij5jE5L1tdt5ofZY
Message-ID: <CAGsJ_4zwP3_+EYY5Ug9EJ+yD1UdxsBSGr25u8s1K3u_i7LH3Zg@mail.gmail.com>
Subject: Re: [PATCH mm-new v9] mm: vmscan: retry folios written back while
 isolated for traditional LRU
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"open list:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)" <linux-mm@kvack.org>, linux-kernel@vger.kernel.org, 
	Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3512C40008
X-Stat-Signature: qtfgbo7ucb3u9mhcxjd78cu964rdd397
X-Rspam-User: 
X-HE-Tag: 1789593957-796780
X-HE-Meta: U2FsdGVkX1+unlS+8T0Fbh9iPVjaR9lx+t/hDNK8A93tR1/x1nw3E0vAHtpiO9zTdZI8CS9Mlvt7g0kl0QqJfPBQfcVC5WYi8DH4263uEU2AfiyEEnl/eJFvflUevOdl7ht3Qn75ivfWv7jGcDaZObLVjBs9oSC210zvP/3jrbdoUrCz/Qnb+JRxpILQWxskvTwE+/XK0rPdhqTs1D9oyLC6L1bLJ9LDQ4KPOGco5tauttry1URk4zuOeYAvQjPt6mkg28e2ggkL4W/xu4I/RwzobEQH6x1PuYQLZEx44lQUxCBr3T/yvtSsTcF6DE+UE8HE/fT/7CByAXr9uriYg5beSWdyHe8EPA2/r8ZM8b1V7De96AwTy5/Jy5RmzYRrdZWdEGkgTVeSZV6H9B3Nf/Ale/qf+f7D+NeggH49rtOoiW1T0xbWAzy2FXwV1vFMSkD/sK+CcDioC1DrcGutODD4MlvJcYXIAL4OMus0iq//CiLGCW2feal+2grP02MKNExk4dMzXCFSS5lmGtP6OlMxLXX+8y6k3+zZapaiR6QLDaKNyjPWMUkXBsmKsivSe/FBXAqt7MZPicRqCUS54Gf8n7ZoOto6q4SQJCKjFE0TunI+UfmnzYECnPi0/p3KJS949dPGIsKwb1lpZCwGWtQ+a1nZSeMRJpb/7aBelQpSFhmbsb0SVeL+v8LiTerP6bekWkInRSDLlDulhdM+sYfFSqKd/Lmed+XVehaGMQx91eQf9PrNxr8BUGrlBYkhqfWlBLpDYjrPA28CYTNWmKy5hCjhhOy3TMohVyKvw3Z06GS0+trwgx0jVqt5FllnyeuLGQQdHc0GYv6kH9ghjOvufMIwefi8sROUaH5Qjcf2Zzlch62PuRT3twtRAopEbVjH2fRGaDIV2new2Lw0yDTl4sDcG/I7kTee7ZpwQCZUHP5pxwufd6LfENRX5sFUd3S/XMQPAuoWDHkNZV0
 Gn2ivCBQ
 0q91onp25XRhlahTQqfy/dDhNsoxbSpwCD7AyC7gg0X+v1+bwkVMf77drDq7wRi/OXPd/DJjxiQfYfaGbD8zY/QRPzcIXc/53e+ACMB6K1IqBxEgnEZBAWee2soEKgUd2ywp8TPa8jE89ByxlDjBKbvxBld5mORyeOGLYJWKCAscCCoVgs0MSiJBxA3bhSvP8CIiYKv60/+mMIVASbvUTqwQ4pf2qkEJs/d4LWkIHIcfeoPod8AFX2huOFPjCbZg4OJKAIG284AUtLfdjyCIXAU8e8DsbdFIXMwokJ5hm/xlaHU3a8bnyJTFtYu+gSdTvm6Th6/eIExGieSjR/vGXiFidiMh9niUjRxGjrcS//O3cxBN//SyK1X4mwyshC4JG9xC/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 8:39=E2=80=AFPM Ridong Chen <ridong.chen@linux.dev>=
 wrote:
>
> From: Ridong Chen <chenridong@xiaomi.com>
>
> As commit 359a5e1416ca ("mm: multi-gen LRU: retry folios written back
> while isolated") mentioned:
>
>   The page reclaim isolates a batch of folios from the tail of one of the
>   LRU lists and works on those folios one by one.  For a suitable
>   swap-backed folio, if the swap device is async, it queues that folio fo=
r
>   writeback.  After the page reclaim finishes an entire batch, it puts ba=
ck
>   the folios it queued for writeback to the head of the original LRU list=
.
>
>   In the meantime, the page writeback flushes the queued folios also by
>   batches.  Its batching logic is independent from that of the page
>   reclaim. For each of the folios it writes back, the page writeback call=
s
>   folio_rotate_reclaimable() which tries to rotate a folio to the tail.
>
>   folio_rotate_reclaimable() only works for a folio after the page reclai=
m
>   has put it back.  If an async swap device is fast enough, the page
>   writeback can finish with that folio while the page reclaim is still
>   working on the rest of the batch containing it.  In this case, that fol=
io
>   will remain at the head and the page reclaim will not retry it before
>   reaching there".
>
> The commit 359a5e1416ca ("mm: multi-gen LRU: retry folios written back
> while isolated") only fixed the issue for mglru. However, this issue
> also exists in the traditional active/inactive LRU and was found at [1].
>
> It can be reproduced with below steps [3]:
>
> 1. Compile with CONFIG_TRANSPARENT_HUGEPAGE=3Dy
> 2. Mount memcg v1, and create memcg named test_memcg and set
>    limit_in_bytes=3D1G, memsw.limit_in_bytes=3D2G.
> 3. Create a 1G swap file, and allocate 1.35G anon memory in test_memcg.
>
> It was found that:
>
>   cat memory.usage_in_bytes
>   1073700864
>   cat memory.memsw.usage_in_bytes
>   1413124096
>
>   free -h
>                 total        used        free
>   Mem:           1.6Gi       1.2Gi       299Mi
>   Swap:          1.0Gi       678Mi       346Mi
>
> As shown above, the test_memcg charged about 324M swap (memsw.usage minus
> usage), but almost 678M swap memory was used, which means that 350M+ may
> be wasted because other memcgs can not use these swap memory.

I don't like the way you describe the problem as "wasted" swap.

The real problem is that those folios skipped
`folio_rotate_reclaimable()`, so they were added back to the head
instead of the tail, where rotation could have moved them to the tail.
This resulted in a cold/hot inversion.

The swap entries they are using now will eventually be released when
we scan those folios again and reach the head of the list, so this is
not actually wasted swap space. You are probably right, on the other
hand, that if those head folios hold swap entries and the swap is
full, this could prevent the reclamation of folios at the tail, making
it even harder for us to reach the head.

>
> This issue should be fixed in the same way as mglru. Therefore, the commo=
n
> logic was extracted to the 'find_folios_written_back' function firstly,
> which is then reused in the 'shrink_inactive_list' function. Finally,
> retry reclaiming those folios that may have missed the rotation for
> traditional LRU.

I wouldn't necessarily call it a fix, as keeping the swap cache for
those folios can sometimes help with future hits. For example, we may
hit those folios again before they are reclaimed. So it's a
double-edged sword.

That said, the cold/hot inversion is a real problem that we should
fix. Ideally, we should find a way to restore the missed
`folio_rotate_reclaimable()` behavior, conceptually something like:

diff --git a/mm/vmscan.c b/mm/vmscan.c
index fde28d0a647d..5ee296474b48 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -891,7 +891,10 @@ long remove_mapping(struct address_space
*mapping, struct folio *folio)
  */
 void folio_putback_lru(struct folio *folio)
 {
-       folio_add_lru(folio);
+       if (folio_has_been_writtenback_due_reclaim(folio))
+               folio_add_lru_tail(folio);
+       else
+               folio_add_lru(folio);
        folio_put(folio);               /* drop ref from isolate */
 }

But if that turns out to be impossible or practically infeasible,
leveraging MGLRU's approach could still be a possible workaround, as
it would at least be better than the current behavior.

On the other hand, the fast swap-out cases should be similar to zram
and zswap, as Yu Zhao mentioned in his previous commit:

"This problem affects relatively slow async swap devices like
Samsung 980 Pro much less and does not affect sync swap devices like
zram or zswap at all."

>
> After change, the same test case only wasted about 2M swap. The swap
> device usage matches what the memcg actually charged.
>
>   cat memory.usage_in_bytes
>   1070301184
>   cat memory.memsw.usage_in_bytes
>   1412448256
>
>   free -h
>                 total        used        free
>   Mem:           1.6Gi       1.2Gi       299Mi
>   Swap:          1.0Gi       327Mi       696Mi
>
> [1] https://lore.kernel.org/linux-kernel/20241010081802.290893-1-chenrido=
ng@huaweicloud.com/
> [2] https://lore.kernel.org/linux-kernel/CAGsJ_4zqL8ZHNRZ44o_CC69kE7DBVXv=
bZfvmQxMGiFqRxqHQdA@mail.gmail.com/
> [3] https://lore.kernel.org/lkml/46037a37-4cf6-448e-a94b-30a4d16e8814@lin=
ux.dev/
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---

Thanks
Barry

