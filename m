Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31A59C83F1A
	for <linux-mm@archiver.kernel.org>; Mon, 21 Jul 2025 20:33:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F4A76B008A; Mon, 21 Jul 2025 16:33:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CC2D6B008C; Mon, 21 Jul 2025 16:33:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BAF56B0092; Mon, 21 Jul 2025 16:33:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D4876B008A
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 16:33:27 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EB4FD1A012F
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 20:33:26 +0000 (UTC)
X-FDA: 83689422012.17.2CF4D7E
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf17.hostedemail.com (Postfix) with ESMTP id 056B040004
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 20:33:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Ws53Efg3;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of vannapurve@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=vannapurve@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753130005; a=rsa-sha256;
	cv=none;
	b=6DqRZEiY5TlxFg4ubEluTb5PKWGhi9ADw5piSetcAdlQ8vNUbfrSulQvNsa9cbALGKJ1j6
	/Fe6dOz6MgkSKe7tW5lBxu2+VhzguPdC8pLkrZx9VEp3AOo5k/R+XfKbflKciU1ghJ4AVy
	z+yMgCx/gRL5xGKyX6vVZjyZa1L0EqA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Ws53Efg3;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of vannapurve@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=vannapurve@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753130005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tsRkrVSZ79KFOrHUZnkYB8zyV0FovPAw/7nSbgdf9SA=;
	b=1HqRwnrsvoCl571V+DeoPKQmrttkfbT6lwkM6E/p7wlP5wSHmiW7MFq1X8LvZRkdJLIraX
	YU9XHv4VMQEHSsCSOoZAvdrudmSbT0Yn6/euRplHhecKD+itEK5REErjHXSwOcFrCFvk+0
	H8T3+uEztm5lcYNsWOG0Y2txjLkmluk=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-23dd9ae5aacso14185ad.1
        for <linux-mm@kvack.org>; Mon, 21 Jul 2025 13:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753130004; x=1753734804; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tsRkrVSZ79KFOrHUZnkYB8zyV0FovPAw/7nSbgdf9SA=;
        b=Ws53Efg3SaQl7sXkCwWBwg9eidPxRiGYPNjpEj3Gf2/ZIxxMW3gdb2gYi8+4dD35ju
         dY6nxWgDOIfH2iwc2FKMXa9LtS12bXtSKR3wnXllxGB/yAdvTDAiHE/1fhiDPnumX462
         T4t/IudFK+/zMvN9CcpLtxRhxblMw27b+QxWwXyPNGZTINMRa2hIPPHPdsZRWfZSF0MB
         OBaByNvH3Y+NeQ416pp4sCqCYcLoUTHOXPHa4lTU8Pehmn2DlBTSHOQKBoAomtXMd5eL
         z66oyic/BGTQdWlz45sqcLSdXRUjPJdcsZl7Sp/7YrRnlCuABWMk7E0/EhCanO2MKTqC
         JIXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753130004; x=1753734804;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tsRkrVSZ79KFOrHUZnkYB8zyV0FovPAw/7nSbgdf9SA=;
        b=BVZlcjgAXBkY1kl0vtZNAFOFmBbOMttjsv2/upRa2U7gxNsUav+5za/mw02rMOYNCh
         1lOHOtvkrjDsL+cPftDB01zcDY48TxHhj/7otayi7y8rNGzi8ZS5vWLkd3YVkVPz4cdi
         GkaLoAuxmMWI5NwalNJAJEwggenNvMqvQ7M/s7Qz2Iewc6Ifv3/t14qDUl8c03ObfTRr
         FC/tBQ5A/j2tbTMRPHA4Mn2FDS/pS/rFB0QWsX+CwoChlslylP135OEluRF3RE+WWwTZ
         NzYVL7KDwSMENCzJfACCzPx7jnghSdiUTYliAY+Or7ZI7xQaci7yH5EGtulk5OSaVqks
         aKEw==
X-Forwarded-Encrypted: i=1; AJvYcCXhGjpOYbuwsYfmc0x1mFVUVZM7KOGoeeBrKNgXcdh2+iw+UcUtf9sViTqMJfON0BqP5egn6ihFxw==@kvack.org
X-Gm-Message-State: AOJu0YyuUSvW0zq3+y5E9ZnWr86pkX4P5/OBrMW0A4QFYkmoFrx5xfoY
	hZU8A3BPq5grf9aebVtojNyWqkbSlnzZWe6nrQFtTikp9gEN2NDoJpazWqreh/EAmdokV7Bjb5X
	xOQ1QyvY9m7fQaB11W/BLKL/Utob7nE9LzcyI3yHU
X-Gm-Gg: ASbGncsULgtSmkRclJSMQh5s8OmgvDTP824Lk4vonjz8rCny0Hv5QtoUOS3IUeB2sMz
	a81mqmf0X1aF0BWDDh9ZHQBoY8CzY3h8XrCkj073FHHVkIJfYfeHgjAO+W5tuBKhnB6L9SAXgWX
	qmtdWPciomtJ7fvpW8x2ehNr8xLjCZKkQMrVRFRevNJLYSnkOoez1+So3vh+kisVhZoV1RQFKOq
	2CroKcCSzuQ6gtFcnAB1FpzajQS35OFvjUtKgm3oqcS3s7d
X-Google-Smtp-Source: AGHT+IFkWHBx/fnOdJ0fH9ksHzfcdY6F8RTAu24ALLaPBJXK759V2xcE3RRWajNRHJ7uflgEVtUatOGBWMqwE9pCFGw=
X-Received: by 2002:a17:902:fc47:b0:235:e1d6:5343 with SMTP id
 d9443c01a7336-23f8b60e3e9mr699005ad.20.1753130002979; Mon, 21 Jul 2025
 13:33:22 -0700 (PDT)
MIME-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-15-tabba@google.com>
 <505a30a3-4c55-434c-86a5-f86d2e9dc78a@intel.com> <CAGtprH8swz6GjM57DBryDRD2c6VP=Ayg+dUh5MBK9cg1-YKCDg@mail.gmail.com>
 <aH5RxqcTXRnQbP5R@google.com> <1fe0f46a-152a-4b5b-99e2-2a74873dafdc@intel.com>
 <aH55BLkx7UkdeBfT@google.com>
In-Reply-To: <aH55BLkx7UkdeBfT@google.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Mon, 21 Jul 2025 13:33:10 -0700
X-Gm-Features: Ac12FXygamzg8jas5GHmqT107kji5KSuvRb10tflFD6TWTFWMXuoj12Xx7V3ojk
Message-ID: <CAGtprH8H2c=bK-7rA1wC1-9f=g8mK3PNXja54bucZ8DnWF7z3g@mail.gmail.com>
Subject: Re: [PATCH v15 14/21] KVM: x86: Enable guest_memfd mmap for default
 VM type
To: Sean Christopherson <seanjc@google.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	willy@infradead.org, akpm@linux-foundation.org, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: g5btcmh963joqh7r6f4hbuxdei61hxyy
X-Rspam-User: 
X-Rspamd-Queue-Id: 056B040004
X-Rspamd-Server: rspam02
X-HE-Tag: 1753130004-628374
X-HE-Meta: U2FsdGVkX1/GdpaPz+/I7F/b2sDDR0LbAHae3+85KiZZeWIkbR/r/ceRPSIDUfiFPP6msXTdR5I3xwAWDoh7CFNSftVZ9EbM63WMykOkDo/kNT8TtdRN2hX8mw/4Lq8kwr1pVy029MWzC+XsFhSQ+AzVZvh5l4DDzxU3Zs/bWf36BSgw4zgclK77+4Ogi9Xdfv9JfFY+j5e207KGNSk2Jpy7Vq5SNbX/aguwk6CEtRLER2LB8fk1B1tZW0oj15UtyOZQwRDLuMXjqNyvoEA+viHvcwy2ZQEhYLpoWBnkVR6qRl83NtVjewDcqmlVcJGQw6SArn/Fs4FD0lGCUZ9qJ794LWYH3xrVa0ig5Mu2D0Ad8VEnlULGao41T22z0Oh1gxVQ1GI8FK3qbEybJSKBRMWtWgCMYuCMQ2ajuY4SdsqikCjp8lruCRFmgTvJ6JhF+/MPUVn81wCXDvH2vXGi8Bc9l/xGO27v8MElMyARTWjVqwMyR0q2fF/ozOrNV1cJ2XoqeovduhotKh1u6mhNFgO8nPms20Hh06PADfqv0d2oC6wwj2fMGskKTX8dIaKO0eK/EJzJLQMFhKHSKz2QTSfrOFjVxKgU+Wdg3VeFAv27qv73nZqZeZY2+IzvPgGesVf2eQ0FzBVnemIvOvf0prFDmQw3wBmKp2d9RCjiVeytkFSf4q6FgUmGP2MvzpgORscXDFrSykVl3WyfamNJxGviwofeC/2iUzJuNDeAUWj3ZfnV5TcQgfhSwhmPnvK7yrEE4BOKpuLL9vMXD/PB2Un1zy/3N3+TctjCGEsoHSLbDRzd8BLBEy5LakgWnlWJfHcDIRh+s/U8WDm4oeolFg8WGlKTfXxkMRSVVcFMbOZq2lNVVlUbUbdcqb57xNc5wRUlnF4nswKp1O5vLKhrZTnDt2HWPQtEyZZFQh0uWEIyyZ+Xx3XZbQZnKE40ip48OdCuQvKLIhrjhNBr0I7
 i6goa5YJ
 zXP1GQyy/Z3/ppyV3YGP7v9R6aM6ItSu3ME5XtjRsRqObJ+MlfDxvQvx9OzYXdGFDDfPpcuMDQKyKgGEFANHVUhRjQUk6aq0pHZZF1PdmDeBAt1MszkyPQA7U1Yp2m2JNr5yUJhvVskbU1X9sIRsc5LKQZjzfXOdIFzXw4QMCFkgVsA/lUyZy+hBttqwHuW3dB50qRqqIfliBT5PzniJtDYs9PpR/+qhBkkWuaDOJiiwsnoLK+TTHmQaqmOmw7aXo4xyNv3nBOPqzIm2CBvVJ/d7i5jfEXomK+dL+TNks3C1QbN3v5eGKbrpqWKslLqv8BTzn+FnVe4emkiwyy7s2jSgPsl8udB7H/ELSgLDqxupem1E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 21, 2025 at 10:29=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> >
> > > > 2) KVM fetches shared faults through userspace page tables and not
> > > > guest_memfd directly.
> > >
> > > This is also irrelevant.  KVM _already_ supports resolving shared fau=
lts through
> > > userspace page tables.  That support won't go away as KVM will always=
 need/want
> > > to support mapping VM_IO and/or VM_PFNMAP memory into the guest (even=
 for TDX).

As a combination of [1] and [2], I believe we are saying that for
memslots backed by mappable guest_memfd files, KVM will always serve
both shared/private faults using kvm_gmem_get_pfn(). And I think the
same story will be carried over when we get the stage2 i.e.
mmap+conversion support.

[1] https://lore.kernel.org/kvm/20250717162731.446579-10-tabba@google.com/
[2] https://lore.kernel.org/kvm/20250717162731.446579-14-tabba@google.com/

> > >
> > > > I don't see value in trying to go out of way to support such a usec=
ase.
> > >
> > > But if/when KVM gains support for tracking shared vs. private in gues=
t_memfd
> > > itself, i.e. when TDX _does_ support mmap() on guest_memfd, KVM won't=
 have to go
> > > out of its to support using guest_memfd for the @userspace_addr backi=
ng store.
> > > Unless I'm missing something, the only thing needed to "support" this=
 scenario is:
> >
> > As above, we need 1) mentioned by Vishal as well, to prevent userspace =
from
> > passing mmapable guest_memfd to serve as private memory.
>
> Ya, I'm talking specifically about what the world will look like once KVM=
 tracks
> private vs. shared in guest_memfd.  I'm not in any way advocating we do t=
his
> right now.

I think we should generally strive to go towards single memory backing
for all the scenarios, unless there is a real world usecase that can't
do without dual memory backing (We should think hard before committing
to supporting it).

Dual memory backing was just a stopgap we needed until the *right*
solution came along.

