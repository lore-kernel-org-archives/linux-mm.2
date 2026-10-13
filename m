Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0AA7CC6B12
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 16:09:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C11436B008A; Tue, 13 Oct 2026 12:09:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC3226B008C; Tue, 13 Oct 2026 12:09:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD9386B0092; Tue, 13 Oct 2026 12:09:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 877E76B008A
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 12:09:39 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 22F3F120D3F
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 16:09:39 +0000 (UTC)
X-FDA: 85318088478.04.6204AA7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 275CC40007
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 16:09:36 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=clQMuYyC;
	spf=pass (imf07.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791907777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I68o5gYKqjJpVpdOoELHe4gv1tpEBm64YlxoXNgYMNg=;
	b=qzx3fIYQ86JkcKUAKPV+J6KgV4nZ7Kctx8p4fPPD8Nf4DHrtS8nSWVmi3R5FBbGrpTrOyL
	0G2jxnhCGbSNUaWX+rOjzzGYVNyX0T5Q7SdibR/lXojarwy3MvsEIkB2Jo9T3zoBtk4BjS
	R0X87ZwCKXDMYcswQ7Kwu5II/Z4vIWQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791907777;
	b=RlyaUAkCmjFLcWqRKOHJI/f8hmh/E67irH6ghhhArv9yyfCtyDmmKqadJZ+aujDP7IQRLl
	P6HS8lWHwSubB9h1WlFCPcCcaf8NKt9i/3SnV4OHkPv+i/4LdddgcL8s7O+5ZSXUB3FRFE
	9/mOSKJ3cJ1cKw6XPxw1cuJNLSHPCZo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=clQMuYyC;
	spf=pass (imf07.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5308E43F97
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 16:09:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 320E11F0089A
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 16:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791907776;
	bh=I68o5gYKqjJpVpdOoELHe4gv1tpEBm64YlxoXNgYMNg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=clQMuYyChATPUv0Ba5ud7nNEnbaMLyii6+fbiLgbmEdsmozHDx1FKcArNXd/lgY/0
	 oMPxmen/5yHBir4rVc+4gwBfaEhg1cf47I3di4q3eO+kSHDxI2hhF3Hc9xvQ3L0W40
	 nO8el0241VpmNMrKBcSpAinRbOS7ZD4X4W5Bs5e4ayUjM2R5kiwvojzfmE+Mu6BFMZ
	 WTNqygghaWeqf2LDt+N4TUSE+ct6fvqzS6tJy8TvaUcfP1s/T8yPOptWLUZ+5t700u
	 sIgiKTcGswHwPIdr8StEWzfIJQh8d8+t9INZMXDcdE+oGBY6SVYBYXFl4xsma0V6cV
	 wXRSDqZiD3/LA==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c169ae1cb26so931316166b.1
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:09:36 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBx5ycZvslvi8scXQPxygBKwUdQhk8gieqrpQmrbXxk+CXDzbTGeMjNmsadH4f2q/5W0FTGZZXthxQ==@kvack.org
X-Gm-Message-State: AFq9FYKk8qdokKVU8xRxLRJJpXzkO5S5Q57PnwwoIILhivZ2gHDbxosf
	0lwSMCmH3UONc6dGjgdU3biA+z7q8IQAzpzUCYpXzedyI9VxtJPj27/S01CAVaSpk6PO+z4kktN
	vjdHKH9tlarozrF0tb0o0j22TSbeyvnA=
X-Received: by 2002:a17:907:3f8e:b0:c31:6c9b:5069 with SMTP id
 a640c23a62f3a-c31a9d6f597mr1316896466b.13.1791907775104; Tue, 13 Oct 2026
 09:09:35 -0700 (PDT)
MIME-Version: 1.0
References: <CAO9r8zPOkuRGv0X=nBbAzTUjUyaB7zAJLUigetSXEVPxWpyGxw@mail.gmail.com>
 <20261013160557.54828-2-itazur@amazon.com>
In-Reply-To: <20261013160557.54828-2-itazur@amazon.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 13 Oct 2026 09:09:21 -0700
X-Gmail-Original-Message-ID: <CAO9r8zN5bDJLvQiyfNZX2Z2W+sL_txT8c6WhfwyXci19rHsJeA@mail.gmail.com>
X-Gm-Features: AclHuK9_C_4IWAq2FQn6XicUwnHvllAJw9Hr13X655JabnYqdZ6oL3GbW7fxP2M
Message-ID: <CAO9r8zN5bDJLvQiyfNZX2Z2W+sL_txT8c6WhfwyXci19rHsJeA@mail.gmail.com>
Subject: Re: [PATCH v3 03/26] mm: introduce AS_NO_DIRECT_MAP
To: Takahiro Itazuri <itazur@amazon.com>
Cc: Sean Christopherson <seanjc@google.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, Will Deacon <will@kernel.org>, 
	rientjes@google.com, Roy Patrick <patrick.roy@linux.dev>, 
	Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>, 
	Thomas Gleixner <tglx@kernel.org>, Patrick Bellasi <derkling@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Nikita Kalyazin <nikita.kalyazin@linux.dev>, 
	Ackerley Tng <ackerleytng@google.com>, Takahiro Itazuri <zulinx86@gmail.com>, cc-open-source@amazon.com, 
	Kevin Brodsky <kevin.brodsky@arm.com>, Gregory Price <gourry@gourry.net>, kvm@vger.kernel.org, 
	Derek Manwaring <derekmn@amazon.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 275CC40007
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: efgmbkwhsfsfw5ne6eduscwiwq4eg6em
X-HE-Tag: 1791907776-113394
X-HE-Meta: U2FsdGVkX18uX/ncgbaIptcB8xmgQC2N1hVduseoBErnsnIOAjH5HtFeS9NUR/3Vlr0jELDN82rnaZExwAKA9H9aK0AQ7X4eYbxds36GWiWmh0f0NOa/aiqFfHlHFqysGECqDw86+vkX/5j1yIWq26meQR1yaqIMVZiQJasoThQgs14G37AnxIBLGbjlxfaXzm9lY2/Z/xicY3doWos6iBvn29e/WSUFlb30B85p5ntFN3cLCTL3wBmYQhSvZJBj5169/OfiDdSYgKAsRUdriKv3bVXD3XuzRWbuhEReCsrDO+oO0D0E9sumeO+t5Cahs5EugFg92HX5wk3mvlpIjl305gb4mKbHC7lsDYNa/mYzJvmFfj12b5YEZgs4G6i4QKcFLrI2pICWri+kFCc6FEeYGIGVdcxTdBadthka8pjhopTxBRrSEoeMDJA+QN/Ln0MXgSC1HCroXTq/xjSexQRZCvoRHwxQCvbxtcMYHoDGYfR5yzsV9KAwR19gJHtS53MlpQ56SUfUswYubL4aP8lQa1ZXOOtBWVab641s5sesz1aPAmVhOenCeWU+0+xo44vohll920uevpwuS9PKw1eF3I0P4AVDWSqAzUtlh+45lb7B+3oDzddTLZAynfN/g1VYi5aP8Z9JFHfupMJ/hS2SDw13blXT7kfYSrXSRwlRjJFNGnPnRV2GU2ZZu3R66x3w8dC00wUby67Pdxehc2u8/LOyHp0jVK7O4Y271JeOexWizrtB7iqdEBUTPStiSqm4rScnSWJLb1AILbNhi6cVwQKZiiw9YmV2a64hxlUeb+FLl3icWa/ZR523U/FZyDEb90jzj03X8u1+20ITki1HLIhkA8R49cfr9FEiqXLveZ41/OfKdFtC3wALVhtxEM//dvDvAQSJROxCm0bT1dj3TwFaPDy/gAea5kK/uCx/E6nIqqI6QWAovy//xuoTx3yW0anjHthJyF15vow
 AOmgXku7
 wCxg1nNBur4AZKGU1+bHysY/bjWWt5xP/d8dcNGkkfBQ51Y73KtUZOfrf7CVtgsNpONFohxDIV0HTX9HwxZ3hJsKFLnG3VdYGjzZjU2Sj04FYvYYqvhAbJRqgtrWJAY9K4+79K97cFJGNe/2BJnbX8hcGLGHN7dRD2c9vxZFDVFxZJTMEfR9C8d3QaFIg6cWazkRDvR65eFiinhPKfkuohzp6SVNByW1SLxfbgKxMRPmJVnWvkJDyEuyZhHqb/GgNp8Z+QN21U8P4mglgkTa6RkSETxSmgUqNqBtf7zCsK9/faISD5yIGdVT3c5qeeqzQkm7ifqa7hOhVevDO0ARxgNMB/2GyagWqK8GaG1qjMAepH6mKuewT+tXiKc2VA9o3jNJ/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 13, 2026 at 9:06=E2=80=AFAM Takahiro Itazuri <itazur@amazon.com=
> wrote:
>
> On Tue, 13 Oct 2026 08:36:54 -0700, Yosry Ahmed <yosry@kernel.org> wrote:
> > > 3. ALLOC_UNMAPPED and the mermap
> > >
> > > AS_NO_DIRECT_MAP itself works without them, by zapping the direct map
> > > of each folio. However, guest_memfd will eventually need a temporary
> > > kernel mapping to populate guest memory via write() [2], because
> > > folios are already unmapped once they are added to the page cache.
> [...]
> >
> > FWIW, I think the mermap can still be used without ALLOC_UNMAPPED, and
> > I did have a newer version of the x86 patches repurposing the LDT area
> > for the mermap, and simplifying the mermap implementation a bit. I can
> > share them privately if you want to take a look.
>
> Yes please, that would be very helpful. Thanks!
>
> Agreed that the mermap can be used without ALLOC_UNMAPPED. To give a
> bit more context from the guest_memfd side: I can't say anything
> definite until I've gone through the use cases, but as far as I can
> see now, guest_memfd needs the mermap only for write() support.
> write() is an optimization for populating guest memory (e.g. when
> restoring a snapshot) and isn't functionally required, because
> userspace can also populate guest memory through its own mapping of
> guest_memfd. So I currently plan to keep write() support, and with it
> the mermap, out of the guest_memfd direct map removal series itself.
> Since ALLOC_UNMAPPED is the main user of the mermap, it may make more
> sense for the two to land together later.
>
> One thing I'd like to look into is arm64. Firecracker also runs on
> arm64, so write() needs to work there too, but the mermap currently
> relies on the x86 mm-local region, and it sounds like your newer
> version relies on the LDT area. Kevin, do you happen to have any
> ideas on how something similar could be done on arm64?

Small correction: Brendan's version already reworked the LDT area, I
just reshuffled things and simplified the implementation.

>
> Thanks,
> Takahiro

