Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45CC7CD98CF
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 23:39:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CE316B0005; Fri, 12 Jun 2026 19:39:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A69B6B008A; Fri, 12 Jun 2026 19:39:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BC026B008C; Fri, 12 Jun 2026 19:39:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5BE4F6B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 19:39:11 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D9A651202B8
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 23:39:10 +0000 (UTC)
X-FDA: 84872878860.05.63C7A36
Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	by imf18.hostedemail.com (Postfix) with ESMTP id D56CE1C0002
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 23:39:08 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cGnbF8Np;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf18.hostedemail.com: domain of huangzhaoyang@gmail.com designates 74.125.82.180 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781307548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5UAkX77cYSGLrdoTHRhvJUGUpQkmsq8EJ9taICAPwuM=;
	b=P/SVVxs/vIIXhT/zPtBiEEHdEc1TMHC8FMhtl+1Dikse0n+9kfS5reJPQJaxNnPqgDHiUc
	XS7ss3qdLRFhzDOwN6PtMnNzIaDHO5Nsz5LPVNcG+swJs+YzWrpyBuP6vlVC/Pi/j+frV6
	ucl11nfuXPpmi5lTZJYEoHS02w0mxZU=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cGnbF8Np;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf18.hostedemail.com: domain of huangzhaoyang@gmail.com designates 74.125.82.180 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781307548;
	b=cd9Ejqd8kHCh07afjgl0W/YOVs9ECLLjJn/nh6eyxIZg6327VCmZGwAi1JpTR/h8uA8k6q
	DRYCxTYDCWlRL0KiDwOZGUIowSewt/seO3za1W3lC8qN4WjtIeQTYb9TtyxSGYXwtFSEWQ
	oSHEFOW3eMZjnZYoJHXHjzx9o1mc9Ns=
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-304dc707bfbso93988eec.2
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 16:39:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781307547; cv=none;
        d=google.com; s=arc-20240605;
        b=e6e/nV9vHqmk+nH8Tbsyal0PifWTHLzxMrQKel58DERls6GRmKiFJObUUSU+pmupLJ
         fqLV9SnXfNPWUgyBWKcS2wmYA6A0widJTC3lW9uaPPvxliMblERqPaS7P3UiPUIopH4f
         5pvkWTux/mw/XFHzPP06tHdFm9gBKrj9/jbrj5cCoesrJWV0EdHAKTZT/a6DhKSXP27s
         I5H6zgF4vdXNsuLj0lg4YWqwb+H2R94NMCwM7hDHX/rd63FwHUJu8uUQRVCGBQ7F1xav
         J6eD5J7qv2SMTfnXVF5AZxEisbLEmTSM7qmcEUHg5Cs7/tfAR7joqZqH91L/hqyQQ844
         6Ynw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5UAkX77cYSGLrdoTHRhvJUGUpQkmsq8EJ9taICAPwuM=;
        fh=gfTHXXJfKLxVqzPSIuf3iaixaNIlnuocZQmyC7cfjIU=;
        b=YtbcWiVppgMI51TaL2Iwc2ISi1GWO9Pm6ksYWZxoLXpeiu/IM8himq4PePKujNQ92A
         6DWYSarh51u8o0dZKWHYGjcw92qQ/HFlw+ZxkL0MjyGQJivTBx/a8/ceA5vwtaoh7qOK
         jIPpIjJnmJjQWqGL29FH45FmWuGcbJ9bqRIiPYEc3oeLl+aht4GuA0qdS+vwueRH9SRb
         hks3+4X121jGOtI6JvlkqS0YaoqWLYTfHNgWT1U6tU0iU9GWBM44AtEt8njIM4eZZNHF
         /yGVlprwTwbAOUcx7FqkWoRCxi8JhHnC61tRO6kJXS0JcL8HbyNIM/xk/zeVu0t82T7D
         9GPg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781307547; x=1781912347; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5UAkX77cYSGLrdoTHRhvJUGUpQkmsq8EJ9taICAPwuM=;
        b=cGnbF8NpXoyukShqpcaFXqUVC/+dXoz/itmBQFDVuCyqgJ8wl0NClFQUxUDvKDeCuf
         wLnQ/Mil7VriCt6myorYtJeXeK/FypIFoRaETWIw/vde5Y827158gF3Yhng4PvSYjU/Y
         SO47niDsBPkPK2Rg4f666aEXCBVf6UUocTuoHVhZUgsI9iungrDYJ10V+P62Td9VoM9v
         ybBqgdt8CYIrXgjUzFRDAQQYS7Njxbmg0mPVeI78aPqWt2LliZ3gtgm/0mKjXrvQvcVP
         2YHyx++AcL9bkZQLZDO0ZQfk59Dvs41u7gaSquwogtQqqtxJ1Q0iYFYY5SsEBsX9NHmq
         IGzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781307547; x=1781912347;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5UAkX77cYSGLrdoTHRhvJUGUpQkmsq8EJ9taICAPwuM=;
        b=MKVffBGlRj2M6DAPbr4fsadejkQ1G58nzGOLxURZkQoZ6J1fq9uVbn452ClGbggy3/
         S26Lirx9JtYMX0GQOoeSVBf3fmc7ZEJwZb+VmP64/+ecEz4UBc0+pXzapjPrBFU8zAsm
         UVjTXldEcxhK06RVgxpr4UmXQifeU9Z1ZG+0t+HvBYFBmWnMBay378V2n38XjAkHDZ43
         Cj+/IjfAAgOWwSMojLCYHOBLEW5DDTocQ6GbQFHNRYSa6ZxeQbXZQLxOE3QZ7NvNhHt1
         CWGu3nPUf2OyXXs8Ty/+/3NSFBUY6wzp4Fj+88763L5S4zkfgkzsb2zzMV8OmKzsRv+/
         LSFQ==
X-Forwarded-Encrypted: i=1; AFNElJ9ni6fMxG24mdaV41rngeyhBPi9/qKYa06ScbrPNCpCdubzQrh0N7KAytLyw7oIkhSTsxQi0tWw4g==@kvack.org
X-Gm-Message-State: AOJu0Yzm08lnCml6oMlXZukXvNF7U5YNEBvrUBd4+UXQKJ9J4sf9PWWn
	SfLNDNWTw1HH8fzqw4tETSd43cAuuUwxUh2udh6RmkA7oj9aQrzlNdVEOJIso90f8XxUxwUYzC1
	TKCtk/R80rpc8JO/a1xvKU7lprV/IeH4=
X-Gm-Gg: Acq92OHGdGckUP5Mz1DYMQ2MdT4s+MdG+P4OWGtl9/USMvEMc1lXqQ+T+D3PXCATlpQ
	MWVCHDZVabjG3HddTaaYpl2tNcruiiwlGV6dxAEjHjZARzBq+LNH0tPrMPN70SA6+YTwksRJTx2
	I+7qn/uqICUs2MRbvssnftTsp4vAacu/aYHlyLd8NQ5cCNqBeCQAbZ6st16a4tdw4PogAH7F4FB
	RQYQIy8mt+p6Hke2NvkVE2csj9/xV9xdSeDUGPCumb/9279nojq42aNzRM5fYx07ayvhgIJQizo
	t4nYSgIhSdBzzgoMRh0=
X-Received: by 2002:a05:7300:80cb:b0:304:d700:1e90 with SMTP id
 5a478bee46e88-30820084c95mr1300605eec.3.1781307547333; Fri, 12 Jun 2026
 16:39:07 -0700 (PDT)
MIME-Version: 1.0
References: <20260612023456.2424044-1-zhaoyang.huang@unisoc.com> <5718685A-8469-48F2-8FFC-10C4BE054F10@nvidia.com>
In-Reply-To: <5718685A-8469-48F2-8FFC-10C4BE054F10@nvidia.com>
From: Zhaoyang Huang <huangzhaoyang@gmail.com>
Date: Sat, 13 Jun 2026 07:38:53 +0800
X-Gm-Features: AVVi8Cf8HdA66B88BTqRz3n866nT_tmiwT0ZU0Z-1EkoeDADZsedYlmsdnOC9ok
Message-ID: <CAGWkznFJO5Y9+nicnY=ViuUbWzg5F0Gq3+RYFe9AF2j26k_UeQ@mail.gmail.com>
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
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D56CE1C0002
X-Stat-Signature: i6nir3z9d7xkju5w7dmcqtx3d3bdjcu5
X-Rspam-User: 
X-HE-Tag: 1781307548-953881
X-HE-Meta: U2FsdGVkX1/cCxofGmPmmGjIztvvuwcViIdZLL57SSTjcSlRMaiWPU6Qxl6//1AGnyihymjwh0wTNujrLu7FkjHA5FkZqcheHg344UMb+eg4bpXNex7xABWVmrs0jUhiPGYtnnfEN6iMkVuA1StESYJKi/TIjstFaapG7YKT1mJkMZY3ynTohs+Yx9zgF2lgcVCNWZ0RVy89EVOwt6pwDsOt6BLDw+N6w5520nvL4tCV6tqk0Wn8cbwWPT+6X2vdwwObK7a+bx6PTtmYOoFLADcXsonT7OVVu8Tb0KEdtzB/GylJj//U2SJwI7q8irUIf9ZYv8TS0+sk01AiSlz49/uyIASsDPxwqBBBcItKKF+AiwkfiuutW9SVwjtXTWBRsqdMpa7y09xU/coiQ5O70WWnmj7vVgYApzFUVLZz53qGoQUG/Ejoa89+j4JaPs6ivVt4lk3PYkvUwYtcKy974ClL8e4IhWv0EJINdnWA5Q9xuMFthZbsH642rRJFyq3S7rQFFeG4GxCEJtXfY3Q4b9UkzAbq4Lkz2pBY0BrfdAiswRwNRQi1HupNviT5FtB0TxZ8xMvR14Kc1xcQzDUB0tOv/cW9qTNPLl5tef4djLu4cxYzTMl1p/q0yE/mroBoSZWQKdzHKGB7qKGTl8DUNdA56eBUIaORkuj0ivj6hZughOhEsNj+SetRKg8DW7yb0uYzBRbSFNCtrKKRA4ikj1ZDJARnLtQDezYk7ani/syhL9FrGf8gXNh69Y8KvIVZQrnRytgCLnTWZ3DJzQDheZGC1qHUzw92C54alkQyReu6RRC+xrxyuMjHnjJesI2Q/9fqX2K0g86adUMi3Bj+/HhHQVNxym68o6TlzFlpvTzfRZxRyAAz65Ry1xYbuIk8GNz/nir4LJ4pRvmXkS+iFe/55lxlXvISVq3qfWtKH1X8Xr3rJjzYIOidZbEppDuxz85xf80y8BrrCQ/zTca
 j7KDx83k
 Rup5/E71Ag0CVogrcsZwdr0LJkqh6Gma+v8IX77Eiw3tlcVlR4kg7mrncp0vsFn9iTtleEbS+yepDFgsYGbzkFbLTLZqk0DMv8ko92QADfZmbFIy1fh+eV5JrDstvBqbafIgYzfenapWTpbwLdx8em9G8JiyWz0z2y1LEjJPKjqboa+qaGGAB6i+YopXmyDhSTkMkfmVFfUS6RtnZXtPEqIi8CPREEDNDq0IKqgz5bGnuKe4AbmfS1PVg20XqmWOSJegOaVpZlo9YJt1PCPTIQ/VuvSUk31YcsiSOvR3cJGgn/vy9yEszpl4gKuGrRO9bb/v7z9GqvWYACQ7EIDt2O1Rx/XfzIAcDrrEYtG/6+FBbm8CH1JwvdI280P/Y7mbnEPm1ctGiY2m6AB01kNxCUAAcMfBzy4nLziNu0Tx6IWsIaC4QxI7K34NG+1Sm9Vhu9hP9xnJDM19XvGkl342rQo7D7yaEZ711V1vwh9JJXArX+2PJkeW0+35VJnqovOWneH9RSau3a2eTfHeBq63PR5sCFQqkGlxVHthhgW0fxMPr+0jynWxbb+5RB/ul/xZXj0VvwQkyzrrMs89MbMcnSORTI8wRsTba+B4mP6WnsdXepK+YmGgKeC5xfFcOT/sRKadM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 12, 2026 at 10:12=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
>
> On 11 Jun 2026, at 22:34, zhaoyang.huang wrote:
>
> > From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> >
> > The kernel panics are keeping to be reported especially when the f2fs
> > partition get almost full. By investigation, we find that the reason is
> > one f2fs page got freed to buddy without being deleted from LRU and the
> > root cause is the race happened in [2] which is enrolled by this commit=
.
> > We solve this issue by reverting a f2fs commit 9609dd704725 ("f2fs: rem=
ove
> > non-uptodate folio from the page cache in move_data_block").
> >
> > There are 3 race processes in this scenario, please find below for thei=
r
> > main activities. However, by further investigation over the code, I
> > think there is a common race window for the truncated folios between
> > split_folio_to_order and folio_isolate_lru, where the folios lost the
> > refcount on page cache and remains the transient one of the split
> > caller, under which the folio could enter free path and compete with th=
e
> > isolation process. This commit would like to suggest to have the folios
> > beyond EOF stay out of LRU.
> >
> > Split:
> > split_folio_to_order() can split the big folio into individual pages an=
d
> > put the resulting subpages back on the LRU.  For tail pages beyond EOF,
> > split removes them from the page cache and drops their page-cache
> > references.  A tail page can then remain on the LRU with PG_lru set whi=
le
> > holding only the split caller's temporary reference.  When
> > free_folio_and_swap_cache() drops that final reference, the page enters
> > the final folio_put() release path.
> >
> > Truncate:
> > The changed code in move_data_block() lets the GC path evict the tail-e=
nd
> > folio from the page cache through folio_end_dropbehind().  Once
> > folio_unmap_invalidate() removes the folio from mapping->i_pages, the
> > page-cache references for all pages in the folio are dropped.  The foli=
o
> > is then kept alive only by temporary external references, which allows =
a
> > later split to operate on a folio whose subpages are no longer protecte=
d
> > by page-cache references.
> >
> > Isolate:
> > In parallel, folio_isolate_lru() can observe the same tail page with a
> > non-zero refcount and PG_lru set.  It clears PG_lru before taking its o=
wn
> > reference.  If this races with the final folio_put() from the split pat=
h,
> > __folio_put() sees PG_lru already cleared and skips lruvec_del_folio().
> > The page is then freed back to the allocator while its lru links are
> > still present in the LRU list.  A later LRU operation on a neighboring
> > page detects the stale link and reports list corruption.
> >
> > [1]
> > [   22.486082] list_del corruption. next->prev should be fffffffec10e0a=
c8, but was dead000000000122. (next=3Dfffffffec10e0a88)
> > [   22.486130] ------------[ cut here ]------------
> > [   22.486134] kernel BUG at lib/list_debug.c:67!
> > [   22.486141] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
> > [   22.488502] Tainted: [W]=3DWARN, [O]=3DOOT_MODULE
> > [   22.488506] Hardware name: Spreadtrum UMS9230 1H10 SoC (DT)
> > [   22.488511] pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BT=
YPE=3D--)
> > [   22.488517] pc : __list_del_entry_valid_or_report+0x14c/0x154
> > [   22.488531] lr : __list_del_entry_valid_or_report+0x14c/0x154
> > [   22.488539] sp : ffffffc08006b830
> > [   22.488542] x29: ffffffc08006b868 x28: 0000000000003020 x27: 0000000=
000000000
> > [   22.488553] x26: 0000000000000000 x25: 0000000000000004 x24: fffffff=
ec10e0ac0
> > [   22.488564] x23: 00000000000000e8 x22: 0000000000000024 x21: dead000=
000000122
> > [   22.488574] x20: fffffffec10e0a88 x19: fffffffec10e0ac8 x18: ffffffc=
080061060
> > [   22.488585] x17: 20747562202c3863 x16: 6130653031636566 x15: 0000000=
000000058
> > [   22.488595] x14: 0000000000000004 x13: ffffff80f91e0000 x12: 0000000=
000000003
> > [   22.488605] x11: 0000000000000003 x10: 0000000000000001 x9 : ffe8572=
1f0e25f00
> > [   22.488615] x8 : ffe85721f0e25f00 x7 : 0000000000000000 x6 : 6c65645=
f7473696c
> > [   22.488625] x5 : ffffffed39b23026 x4 : 0000000000000000 x3 : 0000000=
000000010
> > [   22.488636] x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000=
00000006d
> > [   22.488647] Call trace:
> > [   22.488651]  __list_del_entry_valid_or_report+0x14c/0x154 (P)
> > [   22.488661]  __folio_put+0x2bc/0x434
> > [   22.488670]  folio_put+0x28/0x58
> > [   22.488678]  do_garbage_collect+0x1a34/0x2584
> > [   22.488689]  f2fs_gc+0x230/0x9b4
> > [   22.488697]  f2fs_fallocate+0xb90/0xdf4
> > [   22.488706]  vfs_fallocate+0x1b4/0x2bc
> > [   22.488716]  __arm64_sys_fallocate+0x44/0x78
> > [   22.488725]  invoke_syscall+0x58/0xe4
> > [   22.488732]  do_el0_svc+0x48/0xdc
> > [   22.488739]  el0_svc+0x3c/0x98
> > [   22.488747]  el0t_64_sync_handler+0x20/0x130
> > [   22.488754]  el0t_64_sync+0x1c4/0x1c8
> >
> > [2]
> > *F: big folio before split
> > *T: tail folio after split
> > CPU0 (f2fs GC)              CPU1 (split_folio_to_order)          CPU2 (=
folio_isolate_lru)
> > *F: pagecache refs =3D n
> > *F: extra refs =3D split
> > *F: PG_lru set, mapping !=3D NULL
> >                             split_folio_to_order(F)
> >                               folio_ref_freeze(F, 1)
> >                               ...
> >                               lru_add_split_folio(T)
> >                                 list_add_tail(&T->lru, &F->lru)
> >                                 folio_set_lru(T)
> >                                 folio_unlock(T)
> >                               /* T PageLRU set */
> >
> > *T: pagecache refs =3D 1
> > *T: extra refs =3D GC + split
> > *T: PG_lru set, mapping !=3D NULL
> >
> > move_data_block()
> > folio =3D f2fs_grab_cache_folio(T)
>
> Getting T from f2fs_grab_cache_folio() via __filemap_get_folio() should
> be impossible, since the xarray should either have the original folio F
> or folios are not EOF. But it reminds me a bug I fixed recently.
The folio be out of EOF is caused by the coming folio_end_dropbehind, right=
?
>
> Does your v6.18 kernel have this commit[1], which fixes an xarray issue
> in folio_split()? If not, can you give it a try and see if the issue
> goes away?
Yes, this patch is on the tree.
>
>
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/comm=
it/?h=3Dv6.18.35&id=3D08b2b65c63bb26dbb2a4e2adc2ce96e2929b8b60
>
> > ...
> > __folio_set_dropbehind(T)
> > folio_unlock(T)
> > folio_end_dropbehind(T)
> >   folio_unmap_invalidate(T)
> >     __filemap_remove_folio(T)
> >     folio_put_refs(T, 1)
> > folio_put(T)
> >
> > *T: pagecache refs =3D 0
> > *T: extra refs =3D split
> > *T: PG_lru set, mapping =3D=3D NULL
> >                             free_folio_and_swap_cache(T)
> >                               folio_put_testzero(T)
> >                                 /* refcount: 1 -> 0 */
> >
> > *T: pagecache refs =3D 0
> > *T: extra refs =3D isolate
> > *T: PG_lru set, mapping =3D=3D NULL
> >                                                                   folio=
_isolate_lru(T)
> >                                                                     fol=
io_test_clear_lru(T)
> >                                 __folio_put(T)
> >                                   __page_cache_release(T)
> >                                     folio_test_lru(T) =3D=3D false
> >                                     /* skip lruvec_del_folio(T) */
> >                                   free_frozen_pages(T)
> >                                                                   folio=
_get(T)
> >                                                                   lruve=
c_del_folio(T)
> > later:
> >   list_del(adjacent->lru)
> >     next =3D=3D &T->lru
> >     next->prev =3D=3D LIST_POISON / PCP freelist
> >     BUG
> >
> > Assisted-by: Cursor:claude-opus-4-8
> > Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> > ---
> > patchv2: update codes to eliminate bad page status
> > ---
> > ---
> >  mm/huge_memory.c | 22 +++++++++++++++++++++-
> >  1 file changed, 21 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 970e077019b7..c24c12f71157 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -3878,6 +3878,23 @@ static unsigned int folio_cache_ref_count(const =
struct folio *folio)
> >       return folio_nr_pages(folio);
> >  }
> >
> > +static void clear_dropped_split_folio_lru_flags(struct folio *folio)
> > +{
> > +     /*
> > +      * __split_folio_to_order() clones these LRU state bits from the
> > +      * original folio.  A folio that is dropped instead of being adde=
d to
> > +      * the LRU will not pass through lruvec_del_folio() and
> > +      * __folio_clear_lru_flags(), so clear the cloned state before it=
 is
> > +      * freed back to the page allocator.
> > +      */
> > +     set_mask_bits(&folio->flags.f,
> > +                   (1UL << PG_referenced) | (1UL << PG_active) |
> > +                           (1UL << PG_workingset) |
> > +                           (1UL << PG_unevictable) | __PG_MLOCKED |
> > +                           LRU_GEN_MASK | LRU_REFS_MASK,
> > +                   0);
> > +}
> > +
> >  static int __folio_freeze_and_split_unmapped(struct folio *folio, unsi=
gned int new_order,
> >                                            struct page *split_at, struc=
t xa_state *xas,
> >                                            struct address_space *mappin=
g, bool do_lru,
> > @@ -3958,6 +3975,7 @@ static int __folio_freeze_and_split_unmapped(stru=
ct folio *folio, unsigned int n
> >               for (new_folio =3D folio_next(folio); new_folio !=3D end_=
folio;
> >                    new_folio =3D next) {
> >                       unsigned long nr_pages =3D folio_nr_pages(new_fol=
io);
> > +                     bool drop =3D mapping && new_folio->index >=3D en=
d;
> >
> >                       next =3D folio_next(new_folio);
> >
> > @@ -3966,7 +3984,9 @@ static int __folio_freeze_and_split_unmapped(stru=
ct folio *folio, unsigned int n
> >                       folio_ref_unfreeze(new_folio,
> >                                          folio_cache_ref_count(new_foli=
o) + 1);
> >
> > -                     if (do_lru)
> > +                     if (drop)
> > +                             clear_dropped_split_folio_lru_flags(new_f=
olio);
> > +                     else if (do_lru)
> >                               lru_add_split_folio(folio, new_folio, lru=
vec, list);
> >
> >                       /*
> > --
> > 2.25.1
>
>
> Best Regards,
> Yan, Zi

