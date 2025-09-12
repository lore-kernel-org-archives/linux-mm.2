Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D07DDCA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 21:29:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 185C98E000C; Fri, 12 Sep 2025 17:29:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 135C48E0002; Fri, 12 Sep 2025 17:29:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04B588E000C; Fri, 12 Sep 2025 17:29:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E57B58E0002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 17:29:55 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9486E160853
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 21:29:55 +0000 (UTC)
X-FDA: 83881890750.16.DE0500A
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9FA874000D
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 21:29:53 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=InhDAFfv;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757712594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QRRg+naQxqNIqyjfph05OIHuyRCyHgm4Y++j4EuMPmw=;
	b=Jgqwc4e8uij0pC1kLbMsA4j4UhC4wVR8nO8JbW5nHWu6wZZQh5cMel+UbXnvg/uqapr2Gh
	VZmjFMSeCaKyXfwLAe6S4oiByHp++PmotWpR/zTxZUbzw0c4/9+p0X3ciU75xiJlUdN/f4
	R5LhojZ4KhEkMHb+h4j1mN1MlHMjqMU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757712594; a=rsa-sha256;
	cv=none;
	b=lWnE1LTMoS4BRWTpJhBAlQSnHvJs6kuFdD6lOfRvLrv1dZjRjvWz/Zo+dT4GFfWJLTH4jl
	Syaq/NZ9M6oNzVjGjd4Kb+iDcNBYNSs0JZdsSOH8qlNKfr3YimqvGlPKFYKHDzYd7I/FCk
	3oHqP4KttkYgYeFVunv6pmu7nWUx3ao=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=InhDAFfv;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Fri, 12 Sep 2025 14:29:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757712591;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QRRg+naQxqNIqyjfph05OIHuyRCyHgm4Y++j4EuMPmw=;
	b=InhDAFfvQTGp/RNmVgG9Z50+TpVRMZ6febZsdz8N0RnpFLrzrqHinEtD6XVXmsxwrk1xNV
	01KA3ojSOmggoXkI3NCbsLOMVR9EP19lKTGmY5BQGFqbg/NMplL7vxJs3e5Intu7jON4Td
	dPGgQjbSZ3R/RGwHt1hCjs4GM1W2HjI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>, bpf <bpf@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Harry Yoo <harry.yoo@oracle.com>, Michal Hocko <mhocko@suse.com>, 
	Sebastian Sewior <bigeasy@linutronix.de>, Andrii Nakryiko <andrii@kernel.org>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH slab v5 5/6] slab: Reuse first bit for OBJEXTS_ALLOC_FAIL
Message-ID: <shfysi62hb5g7lo44mw4htwxdsdljcp3usu2wvsjpd2a57vvid@tuhj63dixxpn>
References: <20250909010007.1660-1-alexei.starovoitov@gmail.com>
 <20250909010007.1660-6-alexei.starovoitov@gmail.com>
 <jftidhymri2af5u3xtcqry3cfu6aqzte3uzlznhlaylgrdztsi@5vpjnzpsemf5>
 <CAJuCfpGUjaZcs1r9ADKck_Ni7f41kHaiejR01Z0bE8pG0K1uXA@mail.gmail.com>
 <CAADnVQJu-mU-Px0FvHqZdTTP+x8ROTXaqHKSXdeS7Gc4LV9zsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAADnVQJu-mU-Px0FvHqZdTTP+x8ROTXaqHKSXdeS7Gc4LV9zsQ@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 9FA874000D
X-Stat-Signature: sz3ys93np79kwqwfuazfh6y7m4hmbd66
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757712593-476930
X-HE-Meta: U2FsdGVkX19MfWCx8YIoY5nuuVPrPRlZ4c/H8dnMg59Udzl8tbcMKJTcuKJigukrsOB8rSvBR3rKGbu/TGlW4+kw7IRRy/s5JDnJ176eZvESOHnPpIUrkPSiUV22j5zMDcsRW1g4zxdIZcek2+WMhejlSmjV6Bd0B0dLJ+PPlD6z5NnmFVB4EEoogewyxgzXES4vEzVK/LkHa6vwPDrBZZIru12gKS2+2/3Akbj4X4bhVaUN5DFOrZZivWTJ24xiBTFtPHb5SOIV46Qkyzvvn+CR0aCChaN+kE02cafthY4svJb8PROVpmtdM4/5ja9YQM2z8Hdd7aMPSsqZoCrML5WUk1WDx6XlEVsvr01eDP3ohcLMc0+zAgis73EmRX1NkWGcqTc87mFf1tVyQMcfB5FSwQTZbKyCrNgvcQSnOHYL53IYOU3os3Ix9ULdFq0hvPinno0P6A/J/7UqH4SfMpRCV5vMD+Jap4z5jCZ/qCpFaA0AfSoMkdRN4NJ9NLFwyy3w7KciS1M7YpL8fmluaG2k57HWEmHBEo8m4FaL/tfOg0ZNRh7NiVOvHud/pTQUmsE4DHUcVnYWqXSXcNchcpGItpXFr/NperU4mKGVxQAkAE7uXB4rLLZ9suanJMBlFNJvQy9u7P4ndDGlDpzWw1VuizfQ9j0t+UazxtTYxUoJycjAFQrleUcjUfCyRI2jyue2lwOZCFkA8nKglYS6HWJJplnEUBxzn+vGdtbwUCNcA3XatZYgLM+zp8ZLxcxjSm1hRySy3xzrJkeCmsBqb4KH6JAD/Js4bvHDkF/zCrvPr3BjFzjgPEVgLgTaRFxgsmceVo55L2giZbqHTg/xsP7wp0pkb+wuweiZP6MdwR5RfuVdJz+Jh/1WdgnkbxH80oSZbC4ImgpiOJrvkfcMcCmaBVSL2rgFZ209UYLw0/HwGVyi+qjOC4YubHSoAegNjgHrLBhaLFn7wNLPiL1
 utqyiFFj
 WWryJ/8SOAEUHIvlNNouNV6yz2xskucJ5dztFo7gVcj4s8uVK0KRKNIAu3/1nmwIE7b6KLDYXgoMSvTA7HsEjwo4369CAkfOFAksMdVJGffNEpU1t8VRx6aFXsdSbm/vxjVsRw3c4AryIbHZZdBP6zEpTbSKK7O3Jegza3wIShRNDHVICoqX0vgswTMizConZnx7dOux+yjc4ybQj7ET82AQBRIFtHFD6ZqXF/LvH4EGbx2HJar6hOlR9qaUxL5jflsHebZwuICR32eINzk102TTLz6Royt+FWhV5fcGVz40Q1Jo16L5vFrj3UaS+IJyRGcStqTIUI41OzuilUXH1BrbETXFMIWJ8ET5rZ/GcoF5y0CDzmWChmcZewiqYCOF/uE4KVYqx46OiZhE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 02:24:26PM -0700, Alexei Starovoitov wrote:
> On Fri, Sep 12, 2025 at 2:03 PM Suren Baghdasaryan <surenb@google.com> wrote:
> >
> > On Fri, Sep 12, 2025 at 12:27 PM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> > >
> > > +Suren, Roman
> > >
> > > On Mon, Sep 08, 2025 at 06:00:06PM -0700, Alexei Starovoitov wrote:
> > > > From: Alexei Starovoitov <ast@kernel.org>
> > > >
> > > > Since the combination of valid upper bits in slab->obj_exts with
> > > > OBJEXTS_ALLOC_FAIL bit can never happen,
> > > > use OBJEXTS_ALLOC_FAIL == (1ull << 0) as a magic sentinel
> > > > instead of (1ull << 2) to free up bit 2.
> > > >
> > > > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > >
> > > Are we low on bits that we need to do this or is this good to have
> > > optimization but not required?
> >
> > That's a good question. After this change MEMCG_DATA_OBJEXTS and
> > OBJEXTS_ALLOC_FAIL will have the same value and they are used with the
> > same field (page->memcg_data and slab->obj_exts are aliases). Even if
> > page_memcg_data_flags can never be used for slab pages I think
> > overlapping these bits is not a good idea and creates additional
> > risks. Unless there is a good reason to do this I would advise against
> > it.
> 
> Completely disagree. You both missed the long discussion
> during v4. The other alternative was to increase alignment
> and waste memory. Saving the bit is obviously cleaner.
> The next patch is using the saved bit.

I will check out that discussion and it would be good to summarize that
in the commit message.

