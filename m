Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79888606A329
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 16:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ffoYcMjI
Received: by kanga.kvack.org (Postfix)
	id 865E86B05BD; Thu,  5 Nov 2026 11:56:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 816A96B05BE; Thu,  5 Nov 2026 11:56:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72DC66B05BF; Thu,  5 Nov 2026 11:56:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 46E8C6B05BD
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:56:53 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C8D6E140B3A
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:56:52 +0000 (UTC)
X-FDA: 85401669864.19.B74BD54
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id D0F0D180005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:56:50 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ffoYcMjI;
	spf=pass (imf24.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793897810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dElCrkpNpn3idD/utf+3yWjM7tzCk4S+t97MHfG6DCk=;
	b=i2X/2nBN8scBp9B76bhvLL/dVteQkPovINFTYiTdps4QmcA2j9TIF9awHL+U70lsmXpGCv
	u2xfplyL5kQhJWuuMeJOpXsW2nUMk+3/rkBQhUlBTCTpX8t1Ufn7VV2C4x1cdAS737Afj8
	n36udE9KQFnthdlJ7xZum05QV7J8dvw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793897810;
	b=D5hEliInMHGvB/mzHiV1VUrUoEl1Cw9S4dJvIEYbXN4NDYOLpmjX3quGdAnqill62Nt3YX
	CpZKK7gSf1OmtyBYg8kP+WpkVaF4JS9m7RFZhgJpHs8NDlZuQJZhlHUnmvJ0bzITaHu89x
	6Qepdx74eD+4TexftsJ7WN74P5GPvwc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ffoYcMjI;
	spf=pass (imf24.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EA3BA43EE1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:56:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A639D1F00A1E
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793897809;
	bh=dElCrkpNpn3idD/utf+3yWjM7tzCk4S+t97MHfG6DCk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ffoYcMjIz8nFhQ3D68Am23XMjbjcmXRcfCVzrzp9tfsMQl1LG8P3K1E23uU5ocP9H
	 O+jo1ShDI5yS1S53e9Pb0L+njmpe3Ryq1uDtHiZXAOeY0tNAvKYgXEX4HhMeP9dNG2
	 0Z+MPWhfPUzGwkHiUNacn1xPXoq1xeAF0Pg8OdxVnWSG6fwiouhMs0r9dC0259rbCc
	 MWnUMuQ6xrGTrN+YvLZya5H9jp4nkEQ0MhUPwgWw9Wo9smYHf83TU7a95kqLeqaRcs
	 EhZq5pigq+yENSewsLdvM8N4L8DTNps3I1oLPSiTRnJ9laHA4Z97/XgSJRRQtDYmVK
	 NMRfvqOSm2aFQ==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c445c95d553so303313666b.1
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 08:56:49 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvByZmBPjXC+YM7UA1pZZ7hgvKGt5OBYKCdKAf3wqdet6F9PTcnaW8sW/zTB8W0fbq8a+5ZMONwMMGg==@kvack.org
X-Gm-Message-State: APuU4Z8KNoprrFnbPK773D9llOyYewC3MJEEt6bjIIVSIiYyqW4cmzWB
	5m2ADqTczRJeg2+IXlG7abz0aU/t4DVdzRC2k5DZXJtYxNWLpjM/PwxQakByk0IZxfC8z294Q9H
	1MJZHTusYpW/lPQd+rajO/1Ce3lokbXo=
X-Received: by 2002:a17:907:1611:b0:c4d:28ba:f221 with SMTP id
 a640c23a62f3a-c4d34c9fe33mr14539466b.42.1793897808473; Thu, 05 Nov 2026
 08:56:48 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <47ed45b5-de67-41aa-aa21-a3ba3479a7cc@vivo.com>
 <anXJ-5_vO7-toSe1@google.com> <CAKEwX=Mm2tXcen-quRXHf1Y2qSHYvpEUe4xiw-mHYaJnRUR-EA@mail.gmail.com>
 <auKqt6b4AxCLziIH@google.com> <aufPMirl4cD7tz0X@google.com>
 <18e4542967ebdd10.3137322e32332e3235332e313736.1dfc41.0000sendgmr@google.com>
 <CAKEwX=MV_xEUvz91pz6uc4qXWnWOUDtXZ2zASdNVOBHBLeA60w@mail.gmail.com>
 <18e4ebf806e937ec.3137322e32332e3235332e313736.1bf52a.0000sendgmr@google.com>
 <CAKEwX=PFdgEbba+H3fEnJFDnfkxCTsvuHEb4numVwJRaiMgwKQ@mail.gmail.com>
 <179384102494.19062.12740032892044628762.b4-reply@b4> <auwOBaRtM9p_Wxfx@google.com>
 <18e529a5ab0738f7.3137322e32332e3235332e313736.873cb.0000sendgmr@google.com>
 <CAKEwX=OUt4=wqDLiPvYuiTnkpuZYnszkuNQScNR93hHhVPRRGA@mail.gmail.com>
 <CAO9r8zMMGem-LTJQseT5xSSBjfr3UX2gzG_ftpw6+KF8m9v5yw@mail.gmail.com>
 <CAO9r8zOY1E7gCYnJZAfKvyHcbj8e2WVuXMqsaPGPsKR4-9itsg@mail.gmail.com> <18e53459a8013078.3137322e32332e3235332e313736.12c7b6.0000sendgmr@google.com>
In-Reply-To: <18e53459a8013078.3137322e32332e3235332e313736.12c7b6.0000sendgmr@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 5 Nov 2026 08:56:35 -0800
X-Gmail-Original-Message-ID: <CAO9r8zPZg9OEA4wMBV=DHb-ok4L7V7LiSiCGaqSFh9FNqtQuWg@mail.gmail.com>
X-Gm-Features: AclHuK-u8ElA5_v51jIjDMgeHMQfaqUeU1gcTtrT823lK1r7ODS0ZMi-drUW4gk
Message-ID: <CAO9r8zPZg9OEA4wMBV=DHb-ok4L7V7LiSiCGaqSFh9FNqtQuWg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] mm: zsmalloc: make shrinker compaction budget-aware
To: Chris Wiseman <chriswiseman@google.com>
Cc: Nhat Pham <nphamcs@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Xueyuan Chen <xueyuan.chen21@gmail.com>, Xueyuan Chen <xueyuan.chen@vivo.com>, 
	Barry Song <baohua@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, 
	Minchan Kim <minchan@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Stat-Signature: xrjjajc3m5e8brs7edjun6hzytrtzufy
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: D0F0D180005
X-Rspam-User: 
X-HE-Tag: 1793897810-713793
X-HE-Meta: U2FsdGVkX1/Ln7BZrK+y1K/youW0pu1cWW/YkmxG6Gv3VefLgtT76YEAuIWjL5nfmAnH03KgFU31BhOMoyS3dUUEioqNlW36JatXpmsafcttBlL+Qv8fZKGQp6GNRju4xFRIwOF0CV7slfeTee/TRMrdlUDMYeqsZ4ah5A8kBLITIauEiBLK96dE+82AA+NgnL9AlA6F9m5dPZqr/I/RhfVvEM6UJipfUclEovH+k1/I1PI54drhKtDLlGW6PZ0jsuyZ9wDqroOtWE7FaICS2RpXhWWq9u3Fw6G94skaezwyT+p8ST4BmtTRleaowsb4SjhoyTumcCDKWOL9C7UNEJNxmCFqJO/XjmCBejbnbh6eOF6AtEcsgpKN+e+ixoUucD3O0J1xXaho8iyzmWcMzCI2QcgLH2w6dCkHKwRecaDYYV24kmVwIvqNqX42/HbECP7KagDbjk9o6H3Cm564koW8dkDGrXBN3GvQ/vD1bBoGWqlg2a7BFR8XjEcijouY4VS9h3Ad+SM2tLFUk8dAeGFq1ezE2Yen6WmRRbh4QyYTCb2Xq9KKv7oKzQmz2mGAWf//wiLUM2Sci8YleICTx4pOOpstLwJePdQC6e8RqYiAhMUmlDGD+anjXV0GUZiDy6+gRVwMJ69aWM+nRN5Iixbp7b1x+aYBhW25+tgDouILXOvOe1jhBMrRBE+7SG1NuaJAIFqjxKUKuoqAE4vFBXT/zz3qEvjFjYN/He1Ia6iJaILd5xrqY/dcdEhynFqZ79QfoL9xeY0pz5KHDgHcBweOwA+wiSUqzEKRGQRg6YT89N7SpJ00zOCRx2yllqqtq7cY0uXfjBm12t/yF2snfqUclz1CcZfdOGuzm9XjSx8iHyL3aBNIEwvwZIA/stGtB98SGDfLcWVslw+ZuE9sG5Ypdq/DO6V6+WxMmEBaWlHvi9GnlJ68QG9ClUtvhejGl37/zQhP5wSowiUbPDa
 lkI4iZ3j
 ctTP24V7WuAkgICwjOKSKzHGQYxEBn9KfZ8nyOcatuh5xbBT8n4YpcJq6rQ0ar0X3WbYL6U+Pi7K8azBWpn/UUcNs7hanbqnbA8fefjf9QSFdcvd4ZSEJaD+mX/X9GMPLxtxL8jKEsTICEDaTvZvuQeOxR0tJ4qUlehLVbvsY2K5GE3WAAphilR5ZHrPeXKZbhjpfygk6c77Ors74zGWey7GL4Wg9RO3txUKJ9AJMYFQcRvzLoQbUTUdLutQYkm8POh/ZLC+ssFn4IaoT4wqnxrtqf/iSVQs9VN9xdzDk/IxqHPXPEW2pie5qJRgphcqL6yev/tOrJ0L66BQal617Eb+fSvKfrqY8T1CiXHQtIqctJ7K7gVS714nZgtFuM6kKI5XFUyvqQxHM1bm2iOjSD0dDBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 5, 2026 at 8:53=E2=80=AFAM Chris Wiseman <chriswiseman@google.c=
om> wrote:
>
> On Thu, Nov 5, 2026 at 7:40 AM Yosry Ahmed <yosry@kernel.org> wrote:
> >
> > Never mind the compaction argument, this is just to move zsmalloc
> > pages around, it doesn't help with internal fragmentation. -ENOCOFFEE.
> >
> > I still think we should check if the zsmalloc shrinker actually helps
> > zswap or not tho!
>
> I ran a quick test with zswap turned on to check.
>
> Yosry is right - as long as new pages are swapping out, zswap naturally
> refills the freed slots on its own.  Both runs ended up at the exact
> same 95 MB pool size, and turning the zsmalloc shrinker off cut page
> fault latency by 26% because reclaim isn't fighting itself for the same
> locks.
>
> The only time the shrinker actually saved memory in zswap (~20.8 MB) was
> when I blocked new swap-outs completely after punching holes, since
> zswap doesn't have a manual sysfs compact knob like zram.
>
> ARM64 QEMU (Linux 7.3.0+, 4 vCPUs, zswap lz4):
>                              Shrinker ON    Shrinker OFF
> Active swap-out pool size:      95.9 MB         95.1 MB
> Active swap-out p50 fault:     3,262 us        2,414 us  (-26%)
> Idle pool (swap-out blocked):   44.2 MB         65.1 MB  (+20.8 MB)
>
> Maybe we go with Nhat's idea (CONFIG_ZSMALLOC_SHRINKER defaulting to
> ZSWAP_DEFAULT_ON) for now, and if zswap adds a proactive compact knob
> later we can just kill the shrinker?

Unless we lose something by dropping the shrinker that we can only get
back through proactive compaction, I would argue that adding the
proactive compaction knob (in zswap or zsmalloc) is orthogonal. If we
can establish that zsmalloc compaction during reclaim (via the
shrinker) is useless/harmful, that should be enough to drop it. Adding
a way to invoke proactive compaction should be a separate feature
judged based on its merits.

