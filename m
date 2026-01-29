Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4F98D3569F
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 04:45:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEB366B0088; Wed, 28 Jan 2026 23:45:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A98DB6B0089; Wed, 28 Jan 2026 23:45:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97AFD6B008A; Wed, 28 Jan 2026 23:45:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8347D6B0088
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 23:45:07 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CC84013BA4A
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 04:45:06 +0000 (UTC)
X-FDA: 84383761812.07.AFFA1D2
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf26.hostedemail.com (Postfix) with ESMTP id C8D09140008
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 04:45:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=OBj2NDkt;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf26.hostedemail.com: domain of arjunroy@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=arjunroy@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769661904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/NMPEwmaQiE6lDwFEKeJjWlQC63FHQkMxZqwCKeJ15Q=;
	b=BtPJhx92s1Rqg2B9C3ynTQrDDDa09JPO58YfMZbZhyYG7vN9JbJUJFJB+XK6ka4ah73VuB
	cCZ+HFseUIfO97zXUqN8L4hqRNm8kRvs9Z+kkQYAH/LMgWgpc6XDmBG3tiScZIwXWIsXzU
	DDb3pkYNNZDvugZM8FAfwTHVUjCVphI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769661904; a=rsa-sha256;
	cv=pass;
	b=TXF7MyH+r9vxjEwnMUyZBy2IxFchgCRWst4KV3gBxB9nsL5LvVZkzokk6IyNmEqjJD802l
	jmtKL6ukN3WImuTtzV3B4Fjb44wsUU2Bb3ZguNuMOVu7GkvfVJdt+3DmxHKLdhaGsNqboN
	yuJkdBfz6dv1jq9utBqVmsG2hWNRhX0=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=OBj2NDkt;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf26.hostedemail.com: domain of arjunroy@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=arjunroy@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-5033b0b6eabso214121cf.1
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 20:45:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769661904; cv=none;
        d=google.com; s=arc-20240605;
        b=jP4O3GtPN8psgzzYYjgy5YxW7/zlNSXQ0SWeNC/rSHuptzMHf8Yak8rSxDnpgtt+4Q
         Vm4CmLuI5/LsP4qWlM0xX6e8/6MUBp+g6M0pwioYCnmI8zbj5CSaeruHdTGDrWz99gg8
         4E2F6Z+ufXm1/CQ7wCllrnLnv+J5fYKpy9s/xlFndy6h+o653xxIKpRrHZte64aOe7/Y
         vzLtRfgR1BAJOke0TyD6XXqLcjcOypOOZDvxRRbQbqDWdqLfm0rIvTwQqqhmpkrWSuAN
         97iBfcAwM4XLEszriVgR7pvHUIb6jqpklKhDN+xkLAwb6aRoQscViwa6xXI7cgUIwyLG
         LfVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/NMPEwmaQiE6lDwFEKeJjWlQC63FHQkMxZqwCKeJ15Q=;
        fh=5ZRl3+JZhQE1TXys3uRtgXxk6AncAo6PFTeh1JNvYXY=;
        b=Oo0yA8zH3yl+SkUQWRZ9ysuTH6MmBtqgzvfPhXkSI0XeqVhJNCmp3C8I6MvKeuYS+f
         XCdlA0NmSBXwzKOnGBd+BMYyikYvCeJKucpNXZWru0d9T1CAbZGXxZVN6hFoUlvRRN+V
         +GmeQPdqN+mUM7SUE3tbaDbV5+/EMbbkU6/JdYuQ02HBPBtEALDRglcn1+tqzmF8byrX
         SvPN7VMkJmJSBYxbr5PO9+SkNTY96Q7FySPFWZ+k1gAVtIeE6BDvV0RsfnRRO3+2/Rzm
         J3F9+3v8cYyUdJwB4hQV0ULumgrfc5QZNqdCwg11Nzs/+V9NBaQw17dUDpJd0oZgf/uT
         YFOg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769661904; x=1770266704; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/NMPEwmaQiE6lDwFEKeJjWlQC63FHQkMxZqwCKeJ15Q=;
        b=OBj2NDkt1Nl6liZ2IyrwQybh8mG8SyQWnW8Fj8ObcKqCSgCsAiDZxY5V0/om+NMJQk
         xvvNE6VeWQl3dX0N12jsJU5zMT4c1VBFcbokAxUKJSXtyJnsjS5Kk6dFwKqjgrdAarUA
         iMCuzh0HxqlXWvdGZAceuxD3BEWsbMjjruAROPn6VQ6oQSqdm10eQHBFIqbzehz+5zPs
         I7NG0NhnsfpMZPEZGi9JkZCLV6NeQVI1dK4GbnTq9mwidDwZhNEkG7LFEj3hLQIWkITb
         I4t3now/ceOfCataf4F+e6rEBtC6qr6gO6IpDHLhxRbV1lflXnRjbNthh6e+tPNTxN/J
         iJJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769661904; x=1770266704;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/NMPEwmaQiE6lDwFEKeJjWlQC63FHQkMxZqwCKeJ15Q=;
        b=piIkbHt92gjhfHmB3ATSD2ekoXaj2HNVDCLJijgBQTJegNcdLuMTQ4dLPhv7vK/ySc
         7nc9pjVp5NzJZOeWKWQpZhQPDxwAoPacVO4bXlB54Hw6lJntpSrw/1r1Iew3fXODTvjm
         H73xL5fixZV1k8wsjd/3cfLny2lyIy2NDBXZ2+giIDNT1pvHzldgP8c/PkSUQNcuhtMb
         n0Z63jpVgZ2xo4nTZpLHuWkRvQc7J4CIkdH2lplDmrqaBjQOsiNpuik+DD4IoBywlXBC
         6bZsEgkf1F3xldkW1qMWPAozjRAYpeERSdMIDzZCOpboMGnkHggY+IsI60SoCp56AFL6
         g+2w==
X-Forwarded-Encrypted: i=1; AJvYcCW+WQsKsGVKumTsImWnp380VH4j9cptHNzZ4loyDgzEOfYO9zjCXIWGagyFHWQQ2d2TtYx7MmBPVA==@kvack.org
X-Gm-Message-State: AOJu0YxG5EomYrJTGh0sVWfpkyM9/TKtXpcMKfluWKlMXbaiyiFEiT/e
	Kf+h4bT9u/fOleruWE24a4m5HSyS+oYv4LqL1IoytNJhLBx0fNDXNfSUGU0hR9cWtc3cwlcW5jN
	nj5K94K1hMcovfJ6zNe0ghbY2jyxFq76jlLuhZiGV
X-Gm-Gg: AZuq6aKN5pESChGNC1RthKym7Xzblhv50B3QWxTpwbzktkOOQtOC+B8WkWLUa2BhNSD
	Idt0FsEdrI6xFAH8vkrhd+7x7WggFbKvXceeu1NPFOJ3fvIoJHTEHIxdxZZKe96TIlqN4woy9to
	9vWmFCuDaC7usLQcfzkseYwJbbJUzWdy7NRPlCHvKc/kBRCA4IFzz/NbIKhgBP1263UesV5lrm8
	d0bNhEmyhzRU7IvLgH08ggCyOYRrQ/IQhAt7nH0VGiynIS2jnW2OS+bbzUdcDokkJeExd36MTpT
	4MAnFprfc5Gd5sJfDQ==
X-Received: by 2002:a05:622a:28a:b0:4ff:bf96:db86 with SMTP id
 d75a77b69052e-503b672a580mr7286361cf.16.1769661903501; Wed, 28 Jan 2026
 20:45:03 -0800 (PST)
MIME-Version: 1.0
References: <20260128225648.2938636-1-greenjustin@chromium.org>
 <CADyq12wpDTjHVGs7CTQ3SPNMO_ovmMk-rN7L4i_AGvdoLYQLnA@mail.gmail.com> <aXqu-pe6kR4VDOnT@casper.infradead.org>
In-Reply-To: <aXqu-pe6kR4VDOnT@casper.infradead.org>
From: Arjun Roy <arjunroy@google.com>
Date: Wed, 28 Jan 2026 20:44:52 -0800
X-Gm-Features: AZwV_QjAbJkkQHwHrEr3D9jthPjbfPNMN8oX-3O0cJ2iI8x4OxtVeO-g9n7NlYA
Message-ID: <CAOFY-A3Z92AeGVCGFPe=8i6NJVoksPojuHO4hC+tOzpKiNBtUA@mail.gmail.com>
Subject: Re: [PATCH] mm: Refactor vma_map_pages to use vm_insert_pages
To: Matthew Wilcox <willy@infradead.org>
Cc: Brian Geffon <bgeffon@google.com>, Justin Green <greenjustin@chromium.org>, 
	akpm@linux-foundation.org, linux-mm@kvack.org, david@kernel.org, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	linux-kernel@vger.kernel.org, greenjustin@google.com, rientjes@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C8D09140008
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 78rnd94jttc591ozxa9etggxdt679cfz
X-HE-Tag: 1769661904-821430
X-HE-Meta: U2FsdGVkX18kvZZua5NymcPr+fbD2pI/GMvLwbBED776e2Rn2vZTpuyOp2JJmDA3FIey6zsZY4cDKYU/f7GnkeWQHu/CST2dYFwINYXpywOaE4nVIqNFk5CTx6C/E1h2LkT0SFVnoS8Mp8N6bHBVirSQoYArj4Sd+w4Eh05jKpbui70t2wzM6Cil8/TxT8kPuDjy4n4mjw8yX1ODHv+O1UHOoRqR0Yw2vnHrDdKEKYDi9xISHuBQGpbjfyFJjuLB57ulfvMbqtOQ0KkG5wWLQk27aj87DmPrhkGs4NtKz5rkaSo+MPL+Hndq/2X8tLAZLQlD4LPrIe6c634MheozR2MJmHEvJvumZxNmZRoKQyZ+wlR9XwG8XDZOOo43FE61ThzgroPgteZ3WD5IRCfHcwFri9QXfK5nozw0KDC9+muck2aPh3wNa1+DgTMvJwgLHfRXJ2g1cNNl/aXfFRflMkDMQGePJPun3bXTIH7t/Ui7n6pg8MXZSH+s30L9UwrXXvxzEaH89wD7Ku+6oU1Eqld3Bseund0kArJrSnuSANcDgE/wL1Zd1YoVzCEI9c/sjYSk7ZuO+LqZYeCk/W/FxODYmXZtAkrvVt8PYZL5Ru74wbDPXxc+zkChyTjqqKa6AF4toAp81+EXfO1ZZIbKKPKRaBG5EpeZoJyTm8IhYEHwPznoXn/c2lELTYjYM3JoXspr3osc5EynPP+iVb0o8u+gwXTtkYGzhEqMo7EF7/Mky2A8GqXCGdlJ5hkT+9xN3Fy++ZpDtGI8aaVqARBEkj827jd4kM6J2mw5kPpb1e0b+QEv+SOKlpf96WZGDaRfc/dVf+FqbhnRQvc55p3BsoYtUZPi54KZyFrn0p5HVWfQJ92WWzRrxKR4NoEYVoCyHMO/fXocwZvYIGAHo6IHt+Ko0HTkGHPNUGaV9ItKbCJS3zC9P29lAyf6KvGZg25Hzgove5OQNdmSzk0EvFe
 AY3mcy2i
 jfWvxwZcx9jPrRoPNYaDSntA84hoOgHb637QYs2pV8U4EngAGxQ9VYnPykpUxG4DJ3IxwQ3+hgYQK1LR+0OryE5XD9whzuJx/aOq5skO5f97k3W/vHl0XTvCm180GW92CDrvKh3vOOSOLSCHSe7xXHgD3Aeip7yISwjCwLTUyZTsmnOuF6ztmKqeU6EnhS8GajjQ6bYBqzIxXhJi/5LavH05MVE5/0gvtSibiw5Bajau9nbWuXu1fD63OoFIO9Z3OcITNjsK0Pr5mpM7H9SOFqZlWBDHOgEEYUe83d+bs6Vi/GtR4/Qf68/ZgGkRIp5Kk+ZBRebU53I/Cit7XnNgRzEMY6mZyMZhpCTzK+wTv39Bt0u7GbHox3GlJOf8qQquD+YZPSdFQRzlB8Pg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 28, 2026 at 4:51=E2=80=AFPM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Wed, Jan 28, 2026 at 05:59:12PM -0500, Brian Geffon wrote:
> > On Wed, Jan 28, 2026 at 5:57=E2=80=AFPM Justin Green <greenjustin@chrom=
ium.org> wrote:
> > >
> > > vma_map_pages currently calls vm_insert_page on each individual page =
in
> > > the mapping, which creates significant overhead because we are
> > > repeatedly spinlocking. Instead, we should batch insert pages using
> > > vm_insert_pages, which amortizes the cost of the spinlock.
> >
> > This makes sense, I wonder why this wasn't done previously?
>
> That's always a good question, because it might reveal why this patch is
> a bad idea ...
>
> However in this case, it simply seems to be an oversight.
> __vm_map_pages() was introduced in May 2019 and then vm_insert_pages()
> was added in April 2020.
>

Yes, it was an oversight. I had originally cooked up vm_insert_pages()
to amortize
that spinlock for TCP zerocopy receive, and had not noticed __vm_map_pages(=
)
sitting right there.

Reviewed-by: Arjun Roy <arjunroy@google.com>

-Arjun

> Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

