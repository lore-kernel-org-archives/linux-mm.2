Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01F96104951C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 09:38:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 098E76B0005; Wed, 11 Mar 2026 05:38:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 038CB6B0089; Wed, 11 Mar 2026 05:38:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E912D6B008A; Wed, 11 Mar 2026 05:38:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C299B6B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 05:38:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5988816076D
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 09:38:52 +0000 (UTC)
X-FDA: 84533282904.24.3AEC2A3
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9C07940007
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 09:38:50 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=18zdUd9k;
	spf=pass (imf01.hostedemail.com: domain of 3KDixaQkKCLERcZTVipYcXffXcV.TfdcZelo-ddbmRTb.fiX@flex--aliceryhl.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3KDixaQkKCLERcZTVipYcXffXcV.TfdcZelo-ddbmRTb.fiX@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773221930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RQubQpcCCRw5LR5oprIFTZzoSHmrBMbhMG4Ewb+bDNM=;
	b=neaEeMZNzymNQwFIQk+/CyfDMFhY6gKj3AZow/DKkTyxaOVE4z1ZCnEbvnjduvgyNYPWDh
	0G0XY0q51+VyZk2ld/J2PFPiIFtWQFyUY2Z3WUpJhEtrUAiE7iAYafdD06apFEI6LDm0mZ
	6UCn4AEfw9n9bje5vfGXYQQREWGpTyk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=18zdUd9k;
	spf=pass (imf01.hostedemail.com: domain of 3KDixaQkKCLERcZTVipYcXffXcV.TfdcZelo-ddbmRTb.fiX@flex--aliceryhl.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3KDixaQkKCLERcZTVipYcXffXcV.TfdcZelo-ddbmRTb.fiX@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773221930; a=rsa-sha256;
	cv=none;
	b=ds837kEAdqzJtse0tsPjDyaliyph+hX6myGMtBaESO37s5sTqo9ctuA5ZxCx7uH/HEODQ7
	02HRLP6oW6EgT3Y/Bcl4y2mYAjs8W9sr+VZ60Nk9U6CNRHczLPhWxiNa4L2Re3TJVVGyBE
	U5gE0gtm6tl39IDR9G+ciHtVz6JO1BQ=
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b940da8ec09so666434966b.1
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 02:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773221929; x=1773826729; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RQubQpcCCRw5LR5oprIFTZzoSHmrBMbhMG4Ewb+bDNM=;
        b=18zdUd9kvXYgZxR+ZpUc/FiSizMZOXXAtb3phRv7gSOqAMF5hArpXYnlj9Dv8O3hDG
         yw9vFG+3nLjEjX3N4H7eFwqPrTm53yhBQ/UQabZd+WW/O0w4q9qla+EwaGwIj0/FOJQB
         W8+dqHHWisM/cKdHxH0B69IydrzXV3A9MO8ZCvkvLG3tIlGgCvS67r5fOdnHdXGd8Spa
         PJ5QrduNhELRMXWSIbkye4usIqgpB+EZKY0pQtuO0zUod+KNCcgeX2GKHmjaOOsofvTj
         eI7OV+RqJUE+NSRacHwZift4isRuGEvo4bWtYgrvFZGyzaRryFHSa8FbEOM00fJvEj90
         kG3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773221929; x=1773826729;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RQubQpcCCRw5LR5oprIFTZzoSHmrBMbhMG4Ewb+bDNM=;
        b=feOrfdoisOLDNS75xTQuj+QqtSEpf3PmI/nn/A3O1pBm/DUa9w9O6pOMFrilyqvyLB
         4qyI4m86VsUWD9+6KKeb1S/Cvsa3/VpFcqj3jzycm3UjhZ+AjHVUrHKw6BlkPLuw4s4K
         Qi9Y5kHjvP/WTtAkHa5ccjIdMXBIOnFZCLIb8CS732j+5SRN9Ve6q8qf18fiG+MdEPSn
         r+geTm5BoiznMvSlxwu+uukqqbORJPu3vorGFFnKH1VfSoSoeOkh45M9O0g69Bpv7nmq
         2nFrDBG7o8m3md4L4sz/Pkt5dwVPXaVE4mxK+oTBYqdi3GN2qkb6NktvAbiBDRY3LOjC
         Zhqw==
X-Forwarded-Encrypted: i=1; AJvYcCVpPv1AwIjwol6ynBBP8xVhvuxD+sZ1fHwFx+7T1JiUe5UtPSEVzyOTmlC/C3TpEXSjNc4P752Xeg==@kvack.org
X-Gm-Message-State: AOJu0YyBwIOfv5lJGZPL2KMoIB60XrOWQoOHzGeoVvNzEfX92TFaeNAB
	idC8l04p5s1xtFfR3CwNnCxhMXDOUDUY1ErVoUfZyO8p8bmzrwPXYcm6VNsG1YsIiVts6Y3jctV
	jeHnrXlWKldkSeq5Ffg==
X-Received: from ejja22.prod.google.com ([2002:a17:906:3e96:b0:b8e:ad99:be59])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:f592:b0:b87:2abc:4a32 with SMTP id a640c23a62f3a-b972e1d254cmr101140266b.18.1773221928398;
 Wed, 11 Mar 2026 02:38:48 -0700 (PDT)
Date: Wed, 11 Mar 2026 09:38:45 +0000
In-Reply-To: <61df6369-333c-430a-bd18-c5b1acae68ea@kernel.org>
Mime-Version: 1.0
References: <20260227200848.114019-1-david@kernel.org> <20260227200848.114019-17-david@kernel.org>
 <20260309142954.GM1687929@ziepe.ca> <61df6369-333c-430a-bd18-c5b1acae68ea@kernel.org>
Message-ID: <abE4JYo223OxWCBQ@google.com>
Subject: Re: [PATCH v1 16/16] mm/memory: support VM_MIXEDMAP in zap_special_vma_range()
From: Alice Ryhl <aliceryhl@google.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org, 
	"linux-mm @ kvack . org" <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, David Rientjes <rientjes@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Jarkko Sakkinen <jarkko@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Arve =?utf-8?B?SGrDuG5uZXbDpWc=?=" <arve@android.com>, Todd Kjos <tkjos@android.com>, 
	Christian Brauner <brauner@kernel.org>, Carlos Llamas <cmllamas@google.com>, Ian Abbott <abbotti@mev.co.uk>, 
	H Hartley Sweeten <hsweeten@visionengravers.com>, Jani Nikula <jani.nikula@linux.intel.com>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Tvrtko Ursulin <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Leon Romanovsky <leon@kernel.org>, 
	Dimitri Sivanich <dimitri.sivanich@hpe.com>, Arnd Bergmann <arnd@arndb.de>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, Andy Lutomirski <luto@kernel.org>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Eric Dumazet <edumazet@google.com>, 
	Neal Cardwell <ncardwell@google.com>, "David S. Miller" <davem@davemloft.net>, 
	David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Miguel Ojeda <ojeda@kernel.org>, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-sgx@vger.kernel.org, 
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	linux-rdma@vger.kernel.org, bpf@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	netdev@vger.kernel.org, rust-for-linux@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 9C07940007
X-Rspamd-Server: rspam07
X-Stat-Signature: ry1hnq6r1npocrm33ktqr3xdi8rtobmb
X-Rspam-User: 
X-HE-Tag: 1773221930-950871
X-HE-Meta: U2FsdGVkX1/QtTpnHcK61EM4mw4jP9hKVhWxSmm+/NOJ1Ep8n/cz+AVHYggUyGkdlMdPN9jGEvQDGqmQiTALVlwMzoTEUFW4w00s5XMddCwwV+z5bH1n04Gy3nAo5GLxd6d1LH0sHRBzbihXhHlSleiCeyfMpR7ac000XBJl92mjIn8uA2kQcnhWKdVCpHjL4TGSpXF/uNIlHSuJFtfrofbaJYmAGNkkZgUfc+MSxx0ae6Sa9DWY4cpadcgGmGZglSUryCgDDq1IfIkUZAXEM3zgryUkepFYPh6c74hSvS0EZFnUiDIZceLgPK0NyXIdUZ7HNjI2lRMkTXGHbuDuKUE21sO9YRtvnsgn+9HgW0gze5LwAq3rL7iN64sOwfpQeVA0rWIJgWbxxxjN8JvyZJ6w26wzz6/jPllwoelDSAyHVqhLx61BYqZ+NAMl4I2ZeJ+is80BqUiaLZrgO9Ocfh1zzP+ovFmVmpYeJ4T9YTGtMnXiRsZxfBNOUFXRoYNj7QtC7nIJMH0qV2c6l+J+5fT1Fsu4C62X21l3f+Io63FAgN/rSoxt3T+w4M5BUbql64LxN82c1peO30Snknt3BW2tgoT4qN6DVTBMgBX0G28Hfrt9xbcaJOlfxaapg3lLK9yFlYSRb0E7U5+MtnHkTal5/zt+QeAZT351caC8t1leqzo4lz4SBMhuREu00p1a4yjH55vEPpxJuYrDMoHx6cQn6HS6+00xLgU9ACSVorhv911NDDBijS4qJDQWp2SsVw1jUkKekOykgv1SVrWahgdp2JNlGRJRIPCNWsTfKZj2spH63wmXjg7zKjO+MQBkCqICdCtr+rn6v5cW9zSAtaiKszovdIqzeSvdaSAW0NzfJxKRDYy8VprqXiSMWVFnvNzECWJG7XP14tsTqIXSKc6/wdoCLsfdXfok8pNXfPrA+KIAe3IYbQ+v0HNxc+gqUc1SNr+MwE1BPXlRtlD
 1R9xMWpm
 y/gJhibcu7UtvqBnK/w66wJr5bDBQQxWKx33iIDHyXR4N3NnhvzF/slKFw0/z7/owDLvcHhzSUlAoK99SXaMxlTupwmMwXzCRGTfHarV5LMq2V2mynbJ3mCvl7EEeCpwyyNFJamAm4wuehowQroFIdGY2falvkciaHjVq5f0r7Hk/i7poOj8LVlxIdbKSy1g4OSMo2Hk8EcNKRnd3qPZGybF2HKZW/+8PEvjrvuAb3RQYC28FebXLKZG/tB+QsnPvBDOAC0JSkh1kFsMSeCUsms/cLYpoX4IQJ5cLW4r+mflcxndVcOR20ez9gJ7GYTlqzRmmkwIlabrmDHCN4OLQuI8CdlNVPY9cN1dr40tHxM658477//DSOqbvCuFB2r4Wv6HxgFo5gA6SOR2pxy5siDFCVJwnEAtgG2ycdGcfYRHSKU7usAJh70PNN/7gSJBbS2H8yfQ8ksa5JrjTzSWT3LO8bX0kmKip5C9jAfs23PU37nZHZ7DWXnC5DEWVregbKQCKPnIh5rxtNXxQ4nNmjbW7Ke+03J84yqqaGatlyGodIK6+airPI3/i/fMVgpo/qYdSF/7UUj9TAC4t0r7KeGPtAD4k33L05Nx30/bIf4LUxOZaeZsEBtjXjijHzQPPedOz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 10:15:12AM +0100, David Hildenbrand (Arm) wrote:
> On 3/9/26 15:29, Jason Gunthorpe wrote:
> > On Fri, Feb 27, 2026 at 09:08:47PM +0100, David Hildenbrand (Arm) wrote:
> >> There is demand for also zapping page table entries by drivers in
> >> VM_MIXEDMAP VMAs[1].
> >>
> >> Nothing really speaks against supporting VM_MIXEDMAP for driver use. We
> >> just don't want arbitrary drivers to zap in ordinary (non-special) VMAs.
> >>
> >> [1] https://lore.kernel.org/r/aYSKyr7StGpGKNqW@google.com
> > 
> > Are we sure about this?
> 
> Yes, I don't think relaxing this for drivers to use it on VM_MIXEDMAP is
> a problem.
> 
> > 
> > This whole function seems like a hack to support drivers that are not
> > using an address_space.
> 
> I assume, then using
> unmap_mapping_folio()/unmap_mapping_pages()/unmap_mapping_range() instead.
> 
> > 
> > I say that as one of the five driver authors who have made this
> > mistake.
> > 
> > The locking to safely use this function is really hard to do properly,
> > IDK if binder can shift to use address_space ??
> I cannot really tell.
> 
> Skimming over the code, it looks like it really always handles "single
> VMA" stuff ("Since a binder_alloc can only be mapped once, we ensure the
> vma corresponds to this mapping by checking whether the binder_alloc is
> still mapped"), which makes the locking rather trivial.
> 
> It does seem to mostly allocate/free pages in a single VMA, where I
> think the existing usage of zap_vma_range() makes sense.
> 
> So I'm not sure if using address_space would really be an improvement there.
> 
> Having that said, maybe binder folks can be motivated to look into that.
> But I would consider that future work.

It doesn't really make sense to have multiple binder VMAs. What happens
with Rust Binder is that process A is receiving transactions and has the
VMA mapped once.

* Process B sends a transaction to process A, and the ioctl (running in
  process B) will memcpy the message to A directly into the pages of A's
  VMA.
* Then, B wakes up A, which causes A to return from the receive ioctl.
* The return value of the receive ioctl is a pointer, which points
  somewhere inside A's VMA to the location containing the message from
  B.
* Process A will deref the pointer to read the message from B.
* Once Process A is done handling the transaction, it invokes another
  ioctl to tell the kernel that it is done with this transaction, that
  is, it is not safe for the kernel to reuse that subset of the VMA for
  new incoming transactions.

When Binder returns from its ioctl and gives you a pointer, it needs to
know where the VMA is mapped, because otherwise it can't really give you
a pointer into the VMA.

It's generally not safe for userspace to touch its Binder VMA unless it
has been told that there is a message there. Pages that do not contain
any messages may be entirely missing, and trying to read them leads to
segfault. (Though such pages may also be present if there was previously
a message in the page. The unused pages are kept around to reuse them
for future messages, unless there is memory pressure.)

Alice

