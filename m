Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75BDACD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 23:56:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A32306B0005; Fri, 12 Jun 2026 19:56:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E3D46B008A; Fri, 12 Jun 2026 19:56:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D26E6B008C; Fri, 12 Jun 2026 19:56:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 78CD26B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 19:56:07 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1647AC0B51
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 23:56:07 +0000 (UTC)
X-FDA: 84872921574.18.0C82319
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	by imf06.hostedemail.com (Postfix) with ESMTP id E0E3F180002
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 23:56:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SprIoFlL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.208.178 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781308565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RzjtD3LD4W01V6J1ufZ/QeYqAhBT5lkH1ypK0s9+1Ug=;
	b=xy02sEasqLFbCW9lmuIQBKuAmQi7NykAYajZoDKGTW9jBCJXoeeJm0pHdC7j+97aVGYJJl
	nhYnnODCpdD37XmHPgG4tYEiiWogSXxEPuK2j4wsKqR/5z4K9wlBmXtF8SLpYou5mnkp9l
	wnogH+KQVKHB9YRZw8qEckN8mX/WNwQ=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SprIoFlL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.208.178 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781308565;
	b=42ZyPSeTG+oek/mhzyh9UQ9xxgOQ6AWCKeVwtg1juaoS3t3XtqaKLdrGcDeXksLsMPabXS
	f0nsTmIWlgSD251t9xqP1RJTizQGs+5pXPq7GgRteXU0HQ6q5c2wJpypZzCWOnY/X+kS8B
	weELbwZgLO5hhwoJSYCqqKknOJYx5Wc=
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-396709ba436so2250961fa.2
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 16:56:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781308563; cv=none;
        d=google.com; s=arc-20240605;
        b=KJ/MUlgirF4xhHUh64Z7SJsxbFsWNHpJ9+3Le7VAT2CAS36CQqN/86FeejhBJMInRW
         gCKEwAsv9qYBSPe4M8XNT/Id148t+vv3HhskumSAsQfi0xBz5b2WIhvboATdWX5bmoHT
         /bpWzZc+EHxKYhxYZgW6YmrGHIT3m9D/QJDHp1IFZ6bnFJEtPZs9YnnaXb5HBenjs/r6
         bijYCY7aLJ6ZzzvydEH7X6xkCvp0CeCWv57rnyj8AT3TMg5IX0NTAU01cfkq93TEPnBA
         MTTPMrF+AG62unPqJ7ssZs1G5nH4VyuB8sks1FNTfpNDx2WHkmze5F6bfePIgExT5mgs
         ELyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=RzjtD3LD4W01V6J1ufZ/QeYqAhBT5lkH1ypK0s9+1Ug=;
        fh=8/hb2eS3mcwO2gcAjcQjZnS+H4lPcBWx30bByCsfbiM=;
        b=dfPOv/lRPVzvr5uaiElYWpd+u8FblrjuVnZGMNOgJWFdBOuEdeqfRsBCTe6EM/7Ipj
         6ennaZGZuU0ITLf0uKt5epQj9tZWs59f6ChXBCR+IqSDj0U+LPqc7jTmC2kHTu14IShN
         FewxBqf1mhUWmETLhuM1EjNA4plglcQ68t2YAP/KRdLWQeerqJTSCOtqg7vJvAkizeOz
         gy8fDR1Z01wfydQsDSAHQBgBZ2VlBqjOZYKwKFEcWnaabLxobiuTLx98XXc6s8L8rm6g
         nvqM6ZWTXeDvLCT9g8I8xa4ySCPcZlCoXZ+dVV510fi83f5K68joa6c2py+GnKfuC5Z0
         HYHA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781308563; x=1781913363; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RzjtD3LD4W01V6J1ufZ/QeYqAhBT5lkH1ypK0s9+1Ug=;
        b=SprIoFlLVGSvMOzCgDAE0Mid/cnpRvzPlBayRv+NbsaoGy8Ef6l2ZWlIcny1KVh+Qc
         yyIBaVJj52hFHODTOhyKCHFoTf7Io7KxBUyJZLEfDpNPrnoM3C7CtxTYYVXeS00mXWc4
         FlSoZynBka+RrjqnzCXuLnHoE6sh9wQ/ek44ig4SVx1/+Nj9Oi+zV4LxqeqZ8AM6vrcC
         vsgw6pGKM92Et9bdCNBC2KQsAnC84HSgtOnEThXyakgkblM2yjAkDuP52x4GVM+jh84f
         ij3NCM8mAEPR8Ujzg6rxbeNcDC2GtB1QZi7gWHc/igVryhtlaQSTptcAUGa6WKMu/THB
         DS0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781308563; x=1781913363;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RzjtD3LD4W01V6J1ufZ/QeYqAhBT5lkH1ypK0s9+1Ug=;
        b=h7FontgmPjpbn3xZtEn8BpQ3oBWz0uinJ1F28XJkdMeRTjSLPsOD6CjzhTfMrjglVg
         frbi3d8nx0R6WBdNtsJs+luQL+4ziThcmuDXP2tSYp8X87AyEiueyOtObJ05ZFukz83m
         drEKjq2WI7lEzLLhIjxkhs3pWVrCcSRfR2MTf9CZ3js38xBrb4Tn7rMYl6O1kHE81wtn
         3M83H2VLONqYYMWZgCSeXmIpG64e1TfZDJF6ALQF9d8Jfu/ugQzf9ZNmdJaBjoW0OAQG
         nBhJHE1qdtZo/q6yfWcnlsRcvfYxcz4IDH7PV62ZtY0CxM5Wc0N1vJDAicPjdwu8eLA2
         4/JA==
X-Forwarded-Encrypted: i=1; AFNElJ/DpSjtoG9lKSqfFfuVubtRoeBXvkEPOoFQttlNJ3FlEBeGap3BrQoYi66SydUPSulyiPmnw39dwA==@kvack.org
X-Gm-Message-State: AOJu0Yz15tMSeqhLiIATqzwohEr9K0bx4Nz4MvTjuSj+n3FTE8PVEFmb
	97XOsn+ZXfNhDM4WjAaDYT9Uzk6hiQgY1Yjzua9KboTx2e9YIeqI45gK/8p3gzJGwmETAhdf3Pm
	Q8fQxLtzClLfAnTBqIdQu+oiSBMv1qKE=
X-Gm-Gg: Acq92OFmAdC4lM7v8gESPK+Mu4OnM/7PlBEZROpqGh6g99HrWB27jA/D7je37n/RvVf
	VCJIh/hRY1zKVFf2Icg6e9h3EXQBqFqFd1FkXA1VE10OQqcjeYdXaU9Gu9quMvuFAR2aM7GwRlT
	OR1dTJRsgZlJpUOvuVupU0rMEfBd5kRdZqwea+ffe20OiTPR1mztFawWjvqB18INFL5wJ36q/Pl
	98jRZ5+FTN+Vbet47/zGoVUT8goD2IrKp0LdxmXi4Cf0+caZfHSzhHxq3hHzGywLnluzLsjO9wW
	e4P1/hIe
X-Received: by 2002:a2e:a543:0:b0:397:e391:c0bc with SMTP id
 38308e7fff4ca-3992b04b0d7mr5257201fa.4.1781308562953; Fri, 12 Jun 2026
 16:56:02 -0700 (PDT)
MIME-Version: 1.0
References: <20260612023456.2424044-1-zhaoyang.huang@unisoc.com>
 <5718685A-8469-48F2-8FFC-10C4BE054F10@nvidia.com> <CAGWkznFJO5Y9+nicnY=ViuUbWzg5F0Gq3+RYFe9AF2j26k_UeQ@mail.gmail.com>
 <E8DC5ED1-AC9E-4362-91B3-21D49A9311CA@nvidia.com>
In-Reply-To: <E8DC5ED1-AC9E-4362-91B3-21D49A9311CA@nvidia.com>
From: Zhaoyang Huang <huangzhaoyang@gmail.com>
Date: Sat, 13 Jun 2026 07:55:51 +0800
X-Gm-Features: AVVi8CcAeBFCzXubqH1cd0nzYrtOBaSP_BXpnV9N3EYLngt-TLW9xV1_VRL-qjo
Message-ID: <CAGWkznFay-m4uc8XjQ0L7SasWpfcbujX5GmkavLvSSar2+AnUw@mail.gmail.com>
Subject: Re: [PATCHv2] mm/huge_memory: do not add dropped split tail folios to LRU
To: Zi Yan <ziy@nvidia.com>
Cc: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Lance Yang <lance.yang@linux.dev>, 
	"Liam R . Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, steve.kang@unisoc.com, xiuhong.wang@unisoc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E0E3F180002
X-Stat-Signature: m7uyh9bs3j9d6fr3xzuunetoidfuzba3
X-Rspam-User: 
X-HE-Tag: 1781308564-808834
X-HE-Meta: U2FsdGVkX18MzMXHlS+9kfHyTll3P9actfHEws9BJ6N8CSQoC6L50TcSkxbqbxdwJ9mIn2Edyb4nDBNmwD61Gf7xENlXic3/lVGWxH0c2yqb4hafVBYCforEaPrit83N7OWINYG9XY5v3uTAGUpKryuqURzg4UOwNeCL3Ymw23/ltMjf0kriWm6jsLhPMXm2rYWLwLSqoSGxBAsjSvBC6xJA31WMCdEZXSedjrcpG2EzvjlFoaeirs0S3xL9buYD4mFHXDc7PnS39Tfztq5EgQ+f/p+3gEUTZm8LkUZOYs/hntEoLKqeJqn2dfEYORm61mh+4o97F0x26miJaGV+U4qORNLHPq+E/qtY9jz95dwKYc3GyAH3V512RWRJwwoXJIJvQPBr9N1AjTvsWkgrvTJjo6LD2cpY0sXaHXTngR8PTcqvO4pgSEvL9pwwOUm9OpCxMFVZerzfb4Fpwj/Kiea5x8SY/1Tck6wQUW2FjE+Yauwrnkd9Gr8gVCjHW0rb9nO83lkxJoRMSq4TtszPQ2jS8/y4IoY8va7kVstbKJG8WELfAG5Hbl6RIBbrN7a9XLaiEyR7Z3XGqX8gr99AHuDWc06hpko5NfoZEnrxYN0yGLFyPh926GcryNeY7HAeKrkGuSllduq+u+fG5lO+tvG2F4ClXkxH1CfCr0RtUUktYGzOge02N1zdnQjo0AmB3Hj/gTG1LgpH+FqUmTBqArVRjWft9IoiO89hs68GkfqHHYD75yynk0nVp+vsVzWvS1K9RN/Iz8H5IaS5Dhj/cd7HFTxc1MjoAdsfVyWueuNLxXiGv5f4af3hQEBifoPFnGUG3NR5OBjgppdWGtZ40/7cl96X7i7SK/x6lr25d/oVULXa9nPCHvJILAWnSBSQO/S80VUlpYPbCKxM7fkIV0P4abYN1Aul3QIQNtEb4K5yhtS+OE9QKqt6UWsyYLvKWfYrk/a8YlKulxDexQP
 vYHC+ho6
 /+VinTrVgp/bK3yNFsjJBKts9RwZmmu1F+lM4V3ODFFvTHL85lr8i7jdoXd/ZzRYQIxAilIXNC1ibZ8j3Yyn1dZVfSN/O/fAxMZ4Q75dnG5dv0nzxIS4HyGFKBzImWfE+xhfnVfg1j0aNycA/2iOCRHXDqwABKmQFYVdVbMpj+YHKoSkCRXhweiKYFZXlJQxprvE7uVCPP1mOdjV5pxbwS3LAYPB1e5Ldnuog1ZtrAZbZIvqSltSwwf/PhswCTE+cPBJvBMTNojo2dMFN+oK1IhV2oVZKLOR6myK6R4CY1rYhwbnc2Q9BqURzOJ0eGs5NYlXTzPoUfpTGJap0fdZkX5ovP34y24zwmNXu1IhIk9EHK5SzBC5tpbKU7vKf8gjxyZmFOxQgtu8rEf7uQPQrRCiAzHc+KvxRXZOnZl4PsQRNZc47xdiOj3zILhnxyHL2fTImqw8HOkcrqrTlKgKD8uvElHq4ZuAB98KuU+M016CiPn592hO0usUpE9dMphDkbrYHPmnJR30mGS0lA3E8EL/zMNQHquROYoXZYE58QhSboXtx7TBNBt3iBU2CyHeyATcYR/z9WGc/rtp8yWS7a3R1dqLEA+sXppUm5Cx4rQ85sVMw7iPzYBwygIL3R+2LXzMyzWREbUwYQEvF97xUqrFdCcywqfSz3T1R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jun 13, 2026 at 7:46=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
>
> On 12 Jun 2026, at 19:38, Zhaoyang Huang wrote:
>
> > On Fri, Jun 12, 2026 at 10:12=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
> >>
> >> On 11 Jun 2026, at 22:34, zhaoyang.huang wrote:
> >>
> >>> From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> >>>
> >>> The kernel panics are keeping to be reported especially when the f2fs
> >>> partition get almost full. By investigation, we find that the reason =
is
> >>> one f2fs page got freed to buddy without being deleted from LRU and t=
he
> >>> root cause is the race happened in [2] which is enrolled by this comm=
it.
> >>> We solve this issue by reverting a f2fs commit 9609dd704725 ("f2fs: r=
emove
> >>> non-uptodate folio from the page cache in move_data_block").
> >>>
> >>> There are 3 race processes in this scenario, please find below for th=
eir
> >>> main activities. However, by further investigation over the code, I
> >>> think there is a common race window for the truncated folios between
> >>> split_folio_to_order and folio_isolate_lru, where the folios lost the
> >>> refcount on page cache and remains the transient one of the split
> >>> caller, under which the folio could enter free path and compete with =
the
> >>> isolation process. This commit would like to suggest to have the foli=
os
> >>> beyond EOF stay out of LRU.
> >>>
> >>> Split:
> >>> split_folio_to_order() can split the big folio into individual pages =
and
> >>> put the resulting subpages back on the LRU.  For tail pages beyond EO=
F,
> >>> split removes them from the page cache and drops their page-cache
> >>> references.  A tail page can then remain on the LRU with PG_lru set w=
hile
> >>> holding only the split caller's temporary reference.  When
> >>> free_folio_and_swap_cache() drops that final reference, the page ente=
rs
> >>> the final folio_put() release path.
> >>>
> >>> Truncate:
> >>> The changed code in move_data_block() lets the GC path evict the tail=
-end
> >>> folio from the page cache through folio_end_dropbehind().  Once
> >>> folio_unmap_invalidate() removes the folio from mapping->i_pages, the
> >>> page-cache references for all pages in the folio are dropped.  The fo=
lio
> >>> is then kept alive only by temporary external references, which allow=
s a
> >>> later split to operate on a folio whose subpages are no longer protec=
ted
> >>> by page-cache references.
> >>>
> >>> Isolate:
> >>> In parallel, folio_isolate_lru() can observe the same tail page with =
a
> >>> non-zero refcount and PG_lru set.  It clears PG_lru before taking its=
 own
> >>> reference.  If this races with the final folio_put() from the split p=
ath,
> >>> __folio_put() sees PG_lru already cleared and skips lruvec_del_folio(=
).
> >>> The page is then freed back to the allocator while its lru links are
> >>> still present in the LRU list.  A later LRU operation on a neighborin=
g
> >>> page detects the stale link and reports list corruption.
> >>>
> >>> [1]
> >>> [   22.486082] list_del corruption. next->prev should be fffffffec10e=
0ac8, but was dead000000000122. (next=3Dfffffffec10e0a88)
> >>> [   22.486130] ------------[ cut here ]------------
> >>> [   22.486134] kernel BUG at lib/list_debug.c:67!
> >>> [   22.486141] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
> >>> [   22.488502] Tainted: [W]=3DWARN, [O]=3DOOT_MODULE
> >>> [   22.488506] Hardware name: Spreadtrum UMS9230 1H10 SoC (DT)
> >>> [   22.488511] pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS =
BTYPE=3D--)
> >>> [   22.488517] pc : __list_del_entry_valid_or_report+0x14c/0x154
> >>> [   22.488531] lr : __list_del_entry_valid_or_report+0x14c/0x154
> >>> [   22.488539] sp : ffffffc08006b830
> >>> [   22.488542] x29: ffffffc08006b868 x28: 0000000000003020 x27: 00000=
00000000000
> >>> [   22.488553] x26: 0000000000000000 x25: 0000000000000004 x24: fffff=
ffec10e0ac0
> >>> [   22.488564] x23: 00000000000000e8 x22: 0000000000000024 x21: dead0=
00000000122
> >>> [   22.488574] x20: fffffffec10e0a88 x19: fffffffec10e0ac8 x18: fffff=
fc080061060
> >>> [   22.488585] x17: 20747562202c3863 x16: 6130653031636566 x15: 00000=
00000000058
> >>> [   22.488595] x14: 0000000000000004 x13: ffffff80f91e0000 x12: 00000=
00000000003
> >>> [   22.488605] x11: 0000000000000003 x10: 0000000000000001 x9 : ffe85=
721f0e25f00
> >>> [   22.488615] x8 : ffe85721f0e25f00 x7 : 0000000000000000 x6 : 6c656=
45f7473696c
> >>> [   22.488625] x5 : ffffffed39b23026 x4 : 0000000000000000 x3 : 00000=
00000000010
> >>> [   22.488636] x2 : 0000000000000000 x1 : 0000000000000000 x0 : 00000=
0000000006d
> >>> [   22.488647] Call trace:
> >>> [   22.488651]  __list_del_entry_valid_or_report+0x14c/0x154 (P)
> >>> [   22.488661]  __folio_put+0x2bc/0x434
> >>> [   22.488670]  folio_put+0x28/0x58
> >>> [   22.488678]  do_garbage_collect+0x1a34/0x2584
> >>> [   22.488689]  f2fs_gc+0x230/0x9b4
> >>> [   22.488697]  f2fs_fallocate+0xb90/0xdf4
> >>> [   22.488706]  vfs_fallocate+0x1b4/0x2bc
> >>> [   22.488716]  __arm64_sys_fallocate+0x44/0x78
> >>> [   22.488725]  invoke_syscall+0x58/0xe4
> >>> [   22.488732]  do_el0_svc+0x48/0xdc
> >>> [   22.488739]  el0_svc+0x3c/0x98
> >>> [   22.488747]  el0t_64_sync_handler+0x20/0x130
> >>> [   22.488754]  el0t_64_sync+0x1c4/0x1c8
> >>>
> >>> [2]
> >>> *F: big folio before split
> >>> *T: tail folio after split
> >>> CPU0 (f2fs GC)              CPU1 (split_folio_to_order)          CPU2=
 (folio_isolate_lru)
> >>> *F: pagecache refs =3D n
> >>> *F: extra refs =3D split
> >>> *F: PG_lru set, mapping !=3D NULL
> >>>                             split_folio_to_order(F)
> >>>                               folio_ref_freeze(F, 1)
> >>>                               ...
> >>>                               lru_add_split_folio(T)
> >>>                                 list_add_tail(&T->lru, &F->lru)
> >>>                                 folio_set_lru(T)
> >>>                                 folio_unlock(T)
> >>>                               /* T PageLRU set */
> >>>
> >>> *T: pagecache refs =3D 1
> >>> *T: extra refs =3D GC + split
> >>> *T: PG_lru set, mapping !=3D NULL
> >>>
> >>> move_data_block()
> >>> folio =3D f2fs_grab_cache_folio(T)
> >>
> >> Getting T from f2fs_grab_cache_folio() via __filemap_get_folio() shoul=
d
> >> be impossible, since the xarray should either have the original folio =
F
> >> or folios are not EOF. But it reminds me a bug I fixed recently.
> > The folio be out of EOF is caused by the coming folio_end_dropbehind, r=
ight?
>
> To be specific, __filemap_get_folio() can only see:
> 1. the original folio before the split, because only the original folio
> is present in the xarray as a multi-index entry;
>
> 2. after-split folios that are not EOF, because EOF folios are not added
> to the xarray[1] for __filemap_get_folio() to get.
>
> That is why I said getting EOF tail folios from __filemap_get_folio()
> is impossible.
>
> [1] https://elixir.bootlin.com/linux/v7.0.12/source/mm/huge_memory.c#L388=
4
understood. Could the truncate of the file happen after the split
since the callstack is launched by vfs_fallocate.

> >>
> >> Does your v6.18 kernel have this commit[1], which fixes an xarray issu=
e
> >> in folio_split()? If not, can you give it a try and see if the issue
> >> goes away?
> > Yes, this patch is on the tree.
> >>
> >>
> >> [1] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/c=
ommit/?h=3Dv6.18.35&id=3D08b2b65c63bb26dbb2a4e2adc2ce96e2929b8b60
> >>
> >>> ...
> >>> __folio_set_dropbehind(T)
> >>> folio_unlock(T)
> >>> folio_end_dropbehind(T)
> >>>   folio_unmap_invalidate(T)
> >>>     __filemap_remove_folio(T)
> >>>     folio_put_refs(T, 1)
> >>> folio_put(T)
> >>>
> >>> *T: pagecache refs =3D 0
> >>> *T: extra refs =3D split
> >>> *T: PG_lru set, mapping =3D=3D NULL
> >>>                             free_folio_and_swap_cache(T)
> >>>                               folio_put_testzero(T)
> >>>                                 /* refcount: 1 -> 0 */
> >>>
> >>> *T: pagecache refs =3D 0
> >>> *T: extra refs =3D isolate
> >>> *T: PG_lru set, mapping =3D=3D NULL
> >>>                                                                   fol=
io_isolate_lru(T)
> >>>                                                                     f=
olio_test_clear_lru(T)
> >>>                                 __folio_put(T)
> >>>                                   __page_cache_release(T)
> >>>                                     folio_test_lru(T) =3D=3D false
> >>>                                     /* skip lruvec_del_folio(T) */
> >>>                                   free_frozen_pages(T)
> >>>                                                                   fol=
io_get(T)
> >>>                                                                   lru=
vec_del_folio(T)
> >>> later:
> >>>   list_del(adjacent->lru)
> >>>     next =3D=3D &T->lru
> >>>     next->prev =3D=3D LIST_POISON / PCP freelist
> >>>     BUG
> >>>
> >>> Assisted-by: Cursor:claude-opus-4-8
> >>> Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> >>> ---
> >>> patchv2: update codes to eliminate bad page status
> >>> ---
> >>> ---
> >>>  mm/huge_memory.c | 22 +++++++++++++++++++++-
> >>>  1 file changed, 21 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> >>> index 970e077019b7..c24c12f71157 100644
> >>> --- a/mm/huge_memory.c
> >>> +++ b/mm/huge_memory.c
> >>> @@ -3878,6 +3878,23 @@ static unsigned int folio_cache_ref_count(cons=
t struct folio *folio)
> >>>       return folio_nr_pages(folio);
> >>>  }
> >>>
> >>> +static void clear_dropped_split_folio_lru_flags(struct folio *folio)
> >>> +{
> >>> +     /*
> >>> +      * __split_folio_to_order() clones these LRU state bits from th=
e
> >>> +      * original folio.  A folio that is dropped instead of being ad=
ded to
> >>> +      * the LRU will not pass through lruvec_del_folio() and
> >>> +      * __folio_clear_lru_flags(), so clear the cloned state before =
it is
> >>> +      * freed back to the page allocator.
> >>> +      */
> >>> +     set_mask_bits(&folio->flags.f,
> >>> +                   (1UL << PG_referenced) | (1UL << PG_active) |
> >>> +                           (1UL << PG_workingset) |
> >>> +                           (1UL << PG_unevictable) | __PG_MLOCKED |
> >>> +                           LRU_GEN_MASK | LRU_REFS_MASK,
> >>> +                   0);
> >>> +}
> >>> +
> >>>  static int __folio_freeze_and_split_unmapped(struct folio *folio, un=
signed int new_order,
> >>>                                            struct page *split_at, str=
uct xa_state *xas,
> >>>                                            struct address_space *mapp=
ing, bool do_lru,
> >>> @@ -3958,6 +3975,7 @@ static int __folio_freeze_and_split_unmapped(st=
ruct folio *folio, unsigned int n
> >>>               for (new_folio =3D folio_next(folio); new_folio !=3D en=
d_folio;
> >>>                    new_folio =3D next) {
> >>>                       unsigned long nr_pages =3D folio_nr_pages(new_f=
olio);
> >>> +                     bool drop =3D mapping && new_folio->index >=3D =
end;
> >>>
> >>>                       next =3D folio_next(new_folio);
> >>>
> >>> @@ -3966,7 +3984,9 @@ static int __folio_freeze_and_split_unmapped(st=
ruct folio *folio, unsigned int n
> >>>                       folio_ref_unfreeze(new_folio,
> >>>                                          folio_cache_ref_count(new_fo=
lio) + 1);
> >>>
> >>> -                     if (do_lru)
> >>> +                     if (drop)
> >>> +                             clear_dropped_split_folio_lru_flags(new=
_folio);
> >>> +                     else if (do_lru)
> >>>                               lru_add_split_folio(folio, new_folio, l=
ruvec, list);
> >>>
> >>>                       /*
> >>> --
> >>> 2.25.1
> >>
> >>
> >> Best Regards,
> >> Yan, Zi
>
>
> --
> Best Regards,
> Yan, Zi

