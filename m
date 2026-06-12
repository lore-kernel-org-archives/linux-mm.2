Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69C63CD98CF
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 23:47:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 913DB6B0005; Fri, 12 Jun 2026 19:47:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C4BB6B008A; Fri, 12 Jun 2026 19:47:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D9226B008C; Fri, 12 Jun 2026 19:47:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6CFDE6B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 19:47:13 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 03240C14E2
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 23:47:12 +0000 (UTC)
X-FDA: 84872899146.03.6CE6A0D
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	by imf07.hostedemail.com (Postfix) with ESMTP id E525640005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 23:47:10 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mmWbK+3b;
	spf=pass (imf07.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781308031;
	b=6U+UxH3FAVPjwJWnhNsw2Rq0NoorQeU026bXuNiN6dmZZf36VINvY/TAFr7cSG5RGICQiI
	TcGuYWtfcA4MZcfcSMPz1XcBHlkzkqyYbRALlFfDCtdZWKerjdeFAPJdcNfBkoy7a9IZyc
	ZCGW6LGJE21y5NO0nsafpx1wbuVJG6E=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mmWbK+3b;
	spf=pass (imf07.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781308031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C4uEUrgi75fUjIh/uquFUk+cG/T0UuVccb7XQciUOVA=;
	b=V1pZgE69OLIEAw/01wTFOmQEnxy845+4a3btRWpORUoVdvGeopDRhSCbc6B1rkhmYi8aY2
	eku15Bp+9r38KKK7D+aH97zidYK8j2V+DiaVjKdoQMMWGPBjdDJwHP741gj621ISsWqnup
	8i9rugAIXJJpdmu5MnDtmsTXap6yiws=
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5aa68cf8643so192575e87.0
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 16:47:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781308029; cv=none;
        d=google.com; s=arc-20240605;
        b=d+Ekkce2TXrrjixps6KeoDU5hhYJjzjQkLKquEPGnpbCd0uio/LFPQ0Dohfmu32TrT
         erQZ01xpJ4urcyiimTV/9x53BiUVFTKtC/2sjsh0w/zhn2N6x15aoEAnbrwXVY9iw7IU
         cKuZ7tXF9ypci57O/qkEL71H8t70B0O6+ie1SjfsfBIl91uMKqbZLSWifgBv8upI+F9x
         JwXbnzdmnMfgG8/aVm8I6JhIYRRqdGfA92aGtNugMO8AB0XJp5Xr9gavjSAs1aHxHpju
         JTdOHFf7rfOBAaq4I6L4LI5WmW9wbxQlH5BmGDQtV5zL2ynjLiVm+/KdcvhcW1AWKdnl
         usiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=C4uEUrgi75fUjIh/uquFUk+cG/T0UuVccb7XQciUOVA=;
        fh=XSmQGAn4Sy86BOT/bLEbGnKvIKcTTbbKoF1Gkf/+DbI=;
        b=GQi/K6Imb3rsGdCxiUy1pGNc2v6e4YtVr/oDeFYPjOkGL7NQdq6OWVbWpIGykGri8F
         sXaSjWTE6vkYXR9cM59W2dUpUAzG6yhMipDF0aqtQS0rXIRvRn+QgvOXSTZwDFVCdpZA
         40Q4tq2GrqVtqefjfA0QjL2ZVKYPYAoA7JZcYUTLIUsU7vAMpZIRa4gni2dIwkBcyoHT
         CEum8eRDO6/Kfi0LoYYefXFQotQBgB2mH9fbeZlXq2rpziFFgn6U28nm9Di82rNlYPJw
         3EpVwukS7D/oyspd4SXsw5e9R483wKJm0wBNP1v4q+aYrEcQyK0+pY18URVAo8mxzQ7v
         BXCQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781308029; x=1781912829; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C4uEUrgi75fUjIh/uquFUk+cG/T0UuVccb7XQciUOVA=;
        b=mmWbK+3bnOVdEPgwT2JNQM3NNLXwe38c/oTu2wQt46OfNPe31Mwy9+prGMl7r8jcUY
         7Jj+RcZt6aSKg6CFxIwSEdhUzXlsvMPyDF+w+obXQXrhoZfXWh919b5a5GwQ1h8aOCan
         iBtj0FddElcdg4Wo5UrWfMXuvt0cOtDBmEl/4TEOQX7Z5DvXqn8rq/4PYRWNSp/5v/Oc
         c9e5DEpp4Kby43pcsXGVpgNOJGCcGbF0Kc/py0IHKA9ZNx+6+yTpa8AMFUVD0BEzGoA8
         AFvVZ6bWFNVs/F5DCNQRj/V+FimP6LOEnaDj48VfxxMeq61eeTostcWlWIZtDVJr1/AW
         ltZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781308029; x=1781912829;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=C4uEUrgi75fUjIh/uquFUk+cG/T0UuVccb7XQciUOVA=;
        b=h8gVhk9auCPNgs7tl8n2T5yNWR9Ui5nGmCnvSHHxTle8eXZev6pqgPCiMziSTeNx7z
         8EL6a4E5jxUq/4mDub0/mU8yxkPRr4rYQZjn5TiEBNTDG3vqm4Y/5bGZaDeoMGYYzSTD
         0WL56Kql0o2Xt1bwUfd6KXFzu1tx2rzNNL2ETSdTc+d+bHYUlwxDmJ//M4YhDYwBg8PN
         T1fySFIsBmBhS/DbMjitTPT53xLld3+Dgh0KS2kIhM7LSM8DvX5KPMFJC4n5W3sXj6fa
         DrQJ6BcPsjytbK22U6j5eE+HwE1RfBXuPDvagIIL7qK0f/l3+WJMXIoLYdS4d55OjBB5
         O5XA==
X-Forwarded-Encrypted: i=1; AFNElJ8iZpw6tvjEpSYN+IUlFgj/HqDxcFuWW/MSnbhmtotZp39cMCh9k3NwRGhsUjl0lN73DyWuAB0r/Q==@kvack.org
X-Gm-Message-State: AOJu0Yy5FIrDQhMkn1M0NhJmStD+BgCn+tnFUyEPNfWoSmrUN+ijNYVD
	pBjpJLPZf64+1SNISLzNhm3KIhsdcAkt+oiy2jONbbPFwnFGPcB52KwAUqFBwPIFGFh+Pzx8TaO
	vnHoTwFBDjXnHHVqh2aEiP2h+ZeYnomo=
X-Gm-Gg: Acq92OEpPaLm5H2rcjFLvttKZxa+rODfrF1Mz3pijFIuvmUDXukv/77ZkfuPgTaea4j
	9CQ4VZucqOtR4XMJDWWKxslkb8dxgKDI/K7hV1/p0PUXbCBrKz8gqSZJoofsEkLzFhymt4YF4mK
	FTe+tcT9qupDRCtdbPcxE2k9sqrqdi9O6YiCHiI0wXqAkEpxAse7IG7a3FP7ARM+i8usK/h1LvH
	/0rEVpcGjwhjuti2X+4w0LUakvrz74qmnFAWW4qfQK9Va9Q9yTMRSGhx2OflOdUNteTSdFgJeYa
	mK7G+/gu
X-Received: by 2002:a05:651c:b0e:b0:396:8d4f:573d with SMTP id
 38308e7fff4ca-3992b06b5f7mr5435321fa.4.1781308028633; Fri, 12 Jun 2026
 16:47:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260612023456.2424044-1-zhaoyang.huang@unisoc.com> <76d8bbab-ee8f-4f58-b008-ebc9b6da7ef6@kernel.org>
In-Reply-To: <76d8bbab-ee8f-4f58-b008-ebc9b6da7ef6@kernel.org>
From: Zhaoyang Huang <huangzhaoyang@gmail.com>
Date: Sat, 13 Jun 2026 07:46:56 +0800
X-Gm-Features: AVVi8Ce0WF79d4FT5TXidcW6FfMnW6Bp2G8zKfcyK4yA11UFNL_dLvQg1cd6jYM
Message-ID: <CAGWkznEor9bC6hYBkj6k_wH+m=wwuOCbUJdfBR8wgJS_5BXG8A@mail.gmail.com>
Subject: Re: [PATCHv2] mm/huge_memory: do not add dropped split tail folios to LRU
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Lance Yang <lance.yang@linux.dev>, 
	"Liam R . Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, steve.kang@unisoc.com, xiuhong.wang@unisoc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E525640005
X-Rspam-User: 
X-Stat-Signature: mtkhomiry97du1wjc8nfx89ynkygiejh
X-HE-Tag: 1781308030-841178
X-HE-Meta: U2FsdGVkX1/oay69eMPBxhzLMRZjZDq/Uz5uttxLzu4v3AbFoBjXZcGE6SLO27vAXXl1nOULiExmPp7J/GLnczmhWamRMZTsjuLlwsxdHvdIz+y8+zQis+tobBDSCrcQajRK6W/uPWi6mj31hzeaIEuiESKYpi1qreBz3AO407x/gzkrrK3NgoBB5qxmH2aWnl1wGNSKV4c7dS/XTyGWRLwVboU5Un6+nA4NuyINEAZXToOkMsFCu5g6gdRS36UolMneCYTMjgIWyr5qbeFw1ZU9uLXHmVFYbgHSN+H5x+R9j9NpFe3tm7UOgunFzJ9nVx35p0KyPYloHZr5tDmpoqhSxsSeQEQsxGVeT6HzW12un1+OnsU0FkMHYHVO10R+KeuQX8ZTfa8se1xCboW+Mux8jJeT7rXtfibA3VC2vs98qhwjRog6eZymJx++0JTBgoLvUREV4xEQc8G9qCzQQIqXQPBa03c0kTLRth7mFaSe055geRKZLZ/e1xT1hWdqF0MSiY/wronQBhqxHuXNg3NpQiGWBhrjyYDEmMMxIVCVeZQtfMMthKDH4W4Ok6lbLBE0AVjpLJDXfQi9W0UJTLFdBw0dnuxCtVlOfSDNC4hoFhcKCpLKrrAkqgj97ZjqEAnSzrY2rhWhdm7lDsiOlTB7YTUNdw2Z5zPyP5W9aI7jHKeD0kEzLJ3CV4vJVA1cor0KJ5qXKdLBX4fzbK1cA4FNsKRE8fsmMu7CASR8QvEZnXwOxh9Ekc4xIRnU5Mgsgi/VhOwXhUEslnbFAYnp01ldssVcyvTLIqeso1UeV8EjXQvbG5Q58Y+HkCJG6zevimfF/xkS9mL05YQylso9zo2xgGVPa5jccP6SOtbk5qvmZ+zpuvnS8nc7+klD8x85IuBlMpFB+kS0JLllCdPJlfmFFTQuQYH/3L7eg9eCEWBtLsWMPOIrR/4D5JpKcMh1Y5hVnQBVJbNhMRRNvFw
 tfQp+XvB
 4JytfzuiLUNnR/2a4u7W3sDISMPYuuOlFivTvcxNvY5sAsJ9GCe/VniA4HbW7Pfl60ygvosUfebWxYGa4bS7d9hF7obU73hgS0/2cm0dcpqvXx4Jic8rRUDXSsTw28Fu2EiYV1r2+nOJLbMZNDx/4NBbtDlf7yGSnhUJSm9UbDlYVDyaMreLQ/cv3Q5aknqHPMCvXFnT6CIZwBSi2ZX0Uwsv9ecK4Lx23hXt5dYuY6H2Jf9t/8CsbXhw/M30IwcWzYjpK4BL2eXE4UcAcgk4sfYFIETh+3cZNpdnfvDxTFzBoV0LgibhX0xHtTwIPRAdqPND3+it483Zys7bvexXI49rMCfmK5Uz/x+cONftwz9A4hTuJ+wHpLNeR+eXlKzpy9P30fLK11Ti32VEymApeEl2r183Xb3psEssrOoQs6HDT6Mt02j1yCGPhKo6a2y3zY509yXjTGr1xSnuU2IXtrtSevMVPD5vTBR/QG+/nd2iIjZHUJO+61aGNRn3Hj9nvxTy/HCOp3m4+BZAPaAz+UWk8tg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jun 13, 2026 at 12:34=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 6/12/26 04:34, zhaoyang.huang wrote:
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
>
> What I am still struggling with:
>
> folio_isolate_lru() is documented to:
>
> "Must be called with an elevated refcount on the folio.".
>
> That is, there must be *something* keeping the folio alive before the
> folio_get(). It could be a page table mapping with the PTL held (which do=
es not
> apply here).
According to my understanding, the folio_end_dropbehind could have all
these things gone such as page table mappings, right?
>
> Or it could be another prior folio_try_get() (e.g., do_migrate_range()).
>
> But essentially, folio_isolate_lru() cannot race with __folio_put(). It w=
ould be
> fundamentally broken.
Yes, I agree. so If below sequence possible which could be deemed as
folio_isolate_lru race with folio_put?

                             free_folio_and_swap_cache(T)
                               folio_put_testzero(T)
                                 /* refcount: 1 -> 0 */

 *T: pagecache refs =3D 0
 *T: extra refs =3D isolate
 *T: PG_lru set, mapping =3D=3D NULL

folio_isolate_lru(T)

folio_test_clear_lru(T)
                                 __folio_put(T)
>
> --
> Cheers,
>
> David

