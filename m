Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E8FDCD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 06:16:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 551DD6B00F7; Fri, 26 Jun 2026 02:16:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DD506B00F8; Fri, 26 Jun 2026 02:16:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F16F6B00F9; Fri, 26 Jun 2026 02:16:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1000D6B00F7
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 02:16:14 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9382B1C5E71
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 06:16:13 +0000 (UTC)
X-FDA: 84921053826.25.A673361
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id A5D0F140003
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 06:16:11 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=drEE8C7U;
	spf=pass (imf23.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782454571;
	b=RWZqOsmdB2dS6KSd26cWCRZrjAY8CdRyAKL9SEqx/Z3AKqAOueF3O3fLqeIL202fwuI/ei
	pJOypTuoJgUdWKA/WgUrW3yrzxH7cFExMDAc6QDBzL08mn3/nLDdbe6NSR3GEbZSJ0nfvu
	6+B5tdLlMAipOybXRhUPAMNiFJaSnBs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782454571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=39Ip/zVhtPkFdmRO7pBIaLhwOvx8hHtdJuMNqc5FDrQ=;
	b=BwA971nZHojdvsJYgFXQEQnEl3ZbmdRhtfuWfLGKxGMO9ItfQZFgjnWxiArHr89ypqFZcI
	ifZUvSUL29UlHdOtpP6RWWWwyNRFbpRVvBsqgO+KCYw0DRK+yTyUyQWAIxl5tKe0h1yMvL
	tI2YPT3jjN4G3NwRp34aOwY1ZPeBgFw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=drEE8C7U;
	spf=pass (imf23.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BA80D44401
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 06:16:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A25BA1F01559
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 06:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782454570;
	bh=39Ip/zVhtPkFdmRO7pBIaLhwOvx8hHtdJuMNqc5FDrQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=drEE8C7UKW+cBN1rT6jgmB7+7bZUo+Anjm8WY6XXS5kpPQ1n+IAOjJfRO1QecIbrP
	 mFFK+Nc2jd0fVBCA1/iYNzj4XeH5V436rxzrcOnwPAfm16M9qLgnV4KfvazAv41sBJ
	 6saKwdwhhYq/vZu6XtYHjyJ910+qxD1aBd7fbDNFd739EGHz5WouFa4Q4dswwOAUJE
	 HSWEf7n2ZOAi1q0M9SOmuN/WvhNX6/APhg4ptwjS/zfrDmGSug+JTsWmGMPdbXDGHX
	 Nh1Ysg/FfwEHt5D/80/tokXZJuMmy8ngzqSUa8XzcUH/cx5poW9kZIUqguD0rGsQRH
	 TSjE93V53nr5A==
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-8db4b249ebfso6972016d6.2
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 23:16:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrUk2awldyK4sn7L34p6gyFAX6tRPQcEmLWAG8E1kalrQRuV93/sACIKVkmwGt1KnSRLbQUCeGiwQ==@kvack.org
X-Gm-Message-State: AOJu0YzBvZbAf0J38UR1PE8BVCFJYfuFrzI3uO5fKqEqamz2VfZbPW24
	0ZH1I0RpNbcMKRiIbpfYjHYp/YvG/yZj31DD7mEBiivm4yteH3QtK3XZkQZVACIuvY30bD1EV5q
	iPAVIKt+5bLzTM8TtqYaPEggYRi2cB4U=
X-Received: by 2002:a05:6214:84c2:b0:8e8:56c5:e99c with SMTP id
 6a1803df08f44-8e856c5f391mr11340586d6.24.1782454569863; Thu, 25 Jun 2026
 23:16:09 -0700 (PDT)
MIME-Version: 1.0
References: <5790c4a4-d502-4180-82f5-47de5809a4fe@kernel.org>
 <20260620081017.89085-1-baohua@kernel.org> <4aa8350e-712f-4380-b3bf-2ff06cf2a35d@kernel.org>
 <CAGsJ_4xR0Ge707s8JAfd5Fw10+U+25_nuBGuVayx9qnxR+NnGQ@mail.gmail.com>
 <c29f90c6-2075-43e8-8f0d-0d6718a0f124@kernel.org> <aj0u12N_GzGtQT6K@cmpxchg.org>
 <3af41c23-2365-4ac1-b1b9-076b6ef7ae9e@kernel.org>
In-Reply-To: <3af41c23-2365-4ac1-b1b9-076b6ef7ae9e@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Fri, 26 Jun 2026 14:15:58 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wXTpTS4RF=qPs0wvF3UosrOQ7s9-zdXpx4OKGEysf=VA@mail.gmail.com>
X-Gm-Features: AVVi8Cd9mKQ6r0AguAFE-bU33rDp4kHnI2OraVLk1ndxGQfHmWhSdnEjK-hQYa4
Message-ID: <CAGsJ_4wXTpTS4RF=qPs0wvF3UosrOQ7s9-zdXpx4OKGEysf=VA@mail.gmail.com>
Subject: Re: [RFC PATCH] mm: Avoiding split large folios if swap has no space
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, akpm@linux-foundation.org, axelrasmussen@google.com, 
	baolin.wang@linux.alibaba.com, dev.jain@arm.com, kasong@tencent.com, 
	lance.yang@linux.dev, liam@infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, ljs@kernel.org, npache@redhat.com, qi.zheng@linux.dev, 
	ryan.roberts@arm.com, shakeel.butt@linux.dev, weixugc@google.com, 
	yuanchu@google.com, zhaonanzhe@xiaomi.com, ziy@nvidia.com, 
	Michal Hocko <mhocko@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A5D0F140003
X-Stat-Signature: x3syffbqe73kf5c98y1b6azp4broo4mp
X-HE-Tag: 1782454571-503783
X-HE-Meta: U2FsdGVkX195paMegwDdvKTgJzb59s2RkIu6IGmey/q0/VjwuYBeK98W5DnKDN6OKl9i3lqP1YlLllCv2YFNHMFxFej5R4U0f1+40Hy4G1IsVk4bJN7CrUvAdxXRWNwlF6WbFHWJ3LydwObrCkAyFvVhBsg2+Kmoz0FxEfUH5PONAFgdosGkcF5cSwH+0zDhozPLd0EU/CwPPSTtxB3u2wlgsWAngPBDp3qLd25yplXyp++LpEvZNOpBK5/HTPltAoruU7egrc0SKIJsgWKMheGiKrNnbK6j+6ag2LbfC1Q5SV6u4znLgdpfbO7GmWhDte3RNYXiPqwHQSkaoTy52P8mt2CUmNTKg9sy6ftMyH+tPpvFv+JfEELeyefIIU+l1XhvBFcRTXUjm/SyRXhnbMBP9PEA1Fu+xpTFmEvaW5VRhbQzZ4eohsR8JdISnXh7MmFBwn28BPggv6pPUkXkfAuFdBIvRlVN8n4HCdR18p6onBrg9QFoUc5xj0QXVQZM9d3b8kN/blTMvJurGFItGkqdMiHKEzDj8GeySZ7td/x4PeHUZDzjchpxiFYlqkNc7RXBxVFjzKOVcWWzIuXokiEOoJDdank3QbG1NNBr08DBkuhMQ/t8q4oRpKMZrKz/Wuo2W3mQeI+JPiNi+E1dWBTxUW1U9x5zxtNNlVPp0rcBIkScA6fpz1DICfDT+BgSrUEEtjejDr+82zTCrls3GipBG8WkcFHpWZiUzC2kFicaW5OCBpo2htEjxql9thXMxbvLRf+ECzEmjCK92XX/5H/TwqavBQhZl/b7Ew+6l6kIxMecAsudjnxhEPndriSQ+bpn+pN52KXRc27UUKwFWv4Y9TcXSPV/FYnEwGCNlqF4bPztOAWZY+kyboqRIwEGS++/QkxaTesw3pOU8uWQAO8bK1otSTMgjKsSE5oUxWOF6LFjJLle78CfhltpT92HolFh6Hed+vzzTkoHgkW
 3sRl1MUg
 Daa8a3S0EZYMcYP/NutZjBXeF3Yo1EaeSPr/g9Qk7B2ulah3TGcbXfR2gCn8uCSd+Z91HOAY/ucfP94edOyw4ZlNRmbuwmdgtZtiut6Tdi5FYVMTSp1YEVVn2KwJAsS9QHvZ69JLd5B16lJk+h1g0hhXOiqXI+YmtSpl+k47zD56nZRcaZqOVfi1WT2QMgp5UZX6yhbyUe+9+TvP3XsKoLLLd3z4s+EleneFQOnQEJ5A4n41XYy/HInVIS4HT+uDRfrlfydeeJ691mzQHTaoDlQuTGtrMrUlp2gOkDR7sjzVCYRc3wC2U8FCoTsCBeh0TcEIdXTd0U22iATK1BdahQnEvJg9rK72TkCJB6fAgPdY4P6M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 25, 2026 at 9:46=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 6/25/26 15:36, Johannes Weiner wrote:
> > On Thu, Jun 25, 2026 at 09:49:56AM +0200, David Hildenbrand (Arm) wrote=
:
> >>>
> >>> I don't quite understand you. get_nr_swap_pages() returns
> >>> nr_swap_pages, which increases or decreases as swap is allocated or
> >>> freed. I guess it just reflects how many swaps we currently have
> >>> available?
> >>
> >> Indeed, I was confused by the function name it's "free swap pages". So=
 all goof :)
> >>
> >>>
> >>>
> >>> Yep. The tricky part is that mem_cgroup_try_charge_swap() cannot
> >>> return how much swap quota is available in the memcg. Do you prefer t=
o
> >>> add an output argument to mem_cgroup_try_charge_swap() to expose
> >>> that
> >> That would probably be cleanest, if that is easily possible. We would =
want to
> >> get memcg maintainer feedback on that.
> >>
> >> @memcg folks: we'd like to know whether splitting a large folio would =
make
> >> mem_cgroup_try_charge_swap() succeed on a split (smaller) part, to dis=
tinguish
> >> "there is no way we can swap out anything, don't split" vs. "we could =
swap out,
> >> split".
> >
> > It's technically doable, but is this worth the bother? The remaining
> > headroom is less than a large folio. You can split this one, but you
> > cannot even swap out all of its subpages anymore?
>
> I was asking myself the same, but when we think in terms of THPs on arm64=
 64k
> we're in the range of double-digit MiBs.

Yep. But we haven't enabled thp_swp for 64KB base pages yet; there
is an ongoing attempt[1].

The current concern is that such large folios may incur significant
latency for I/O or compression, and reclaim could end up waiting
for a long time.
For huge folios, maybe we should split them into 2MB folios
instead of splitting all the way down to base pages when swapping
out.
That way, we could allow architectures with "huge" large folios to swap
out using THP_SWAP?

BTW, PowerPC is enabling THP_SWPOUT for up to 16MB THP[2].

[1] https://lore.kernel.org/linux-mm/20251226063759.4020782-2-tongweilin@li=
nux.alibaba.com/
[2] https://lore.kernel.org/linux-mm/cover.1781843449.git.ritesh.list@gmail=
.com/

>
> > From the cgroup
> > side, we don't need the limit to be obeyed this rigidly. We overcharge
> > temporarily in other places if it's convenient to do so. A fuzz factor
> > around the limit is acceptable.
>
> Thanks for that information.
>
> >
> > But if you still want to do it, here is how:
> >
> > The page_counter_try_charge() in __mem_cgroup_try_charge_swap() walks
> > the hierarchy upwards. If it fails, it will store the first level that
> > failed against its limit. You can do the mem_cgroup_margin() math
> > against this counter to determine headroom. An ancestor *could* be
> > more restrictive, so you need to finish the hierarchy walk to the root
> > and use the min() of all the swap.max - page_counter_read(swap). Then
> > return that in a return argument from __mem_cgroup_try_charge_swap().
>

It seems it is exactly what mem_cgroup_get_nr_swap_pages() is doing:

long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
{
        long nr_swap_pages =3D get_nr_swap_pages();

        if (mem_cgroup_disabled() || do_memsw_account())
                return nr_swap_pages;
        for (; !mem_cgroup_is_root(memcg); memcg =3D parent_mem_cgroup(memc=
g))
                nr_swap_pages =3D min_t(long, nr_swap_pages,
                                      READ_ONCE(memcg->swap.max) -
                                      page_counter_read(&memcg->swap));
        return nr_swap_pages;
}

> Thanks! @Barry, up to you if we want to implement that right away or if w=
e're
> simply going to assume that if charging fails, not worth splitting (chang=
ing the
> existing handling IIUC).

Thanks very much to Johannes and David for the help.

Hi Johannes, I wonder if you're comfortable with something like
the code below (just as a concept):

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 8f0f68e245ba..be4f86271c0d 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -573,12 +573,12 @@ static inline void
folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 #endif

 #if defined(CONFIG_MEMCG) && defined(CONFIG_SWAP)
-int __mem_cgroup_try_charge_swap(struct folio *folio);
-static inline int mem_cgroup_try_charge_swap(struct folio *folio)
+int __mem_cgroup_try_charge_swap(struct folio *folio, long *left_space);
+static inline int mem_cgroup_try_charge_swap(struct folio *folio,
long *left_space)
 {
        if (mem_cgroup_disabled())
                return 0;
-       return __mem_cgroup_try_charge_swap(folio);
+       return __mem_cgroup_try_charge_swap(folio, left_space);
 }

 extern void __mem_cgroup_uncharge_swap(unsigned short id, unsigned
int nr_pages);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 56cd4af08232..c8c9a10befad 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5578,7 +5578,7 @@ int __init mem_cgroup_init(void)
  *
  * Returns 0 on success, -ENOMEM on failure.
  */
-int __mem_cgroup_try_charge_swap(struct folio *folio)
+int __mem_cgroup_try_charge_swap(struct folio *folio, long *left_space)
 {
        unsigned int nr_pages =3D folio_nr_pages(folio);
        struct swap_cluster_info *ci;
@@ -5611,6 +5611,10 @@ int __mem_cgroup_try_charge_swap(struct folio *folio=
)
                memcg_memory_event(memcg, MEMCG_SWAP_MAX);
                memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
                mem_cgroup_private_id_put(memcg, nr_pages);
+               if (folio_test_large(folio))
+                       *left_space =3D mem_cgroup_get_nr_swap_pages(memcg)=
;
+               else
+                       *left_space =3D 0;
                return -ENOMEM;
        }
        mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);

Thanks
Barry

