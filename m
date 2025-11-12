Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EA31CD342F
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 17:40:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89C7C8E0005; Wed, 12 Nov 2025 12:40:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 874518E0002; Wed, 12 Nov 2025 12:40:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78A1C8E0005; Wed, 12 Nov 2025 12:40:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 652888E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 12:40:09 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D74204CF01
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 17:40:08 +0000 (UTC)
X-FDA: 84102668496.16.CE3870E
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf15.hostedemail.com (Postfix) with ESMTP id C3A2CA0011
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 17:40:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=aiDPCQOM;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762969207; a=rsa-sha256;
	cv=none;
	b=Aq48D8dhXtOzgxDy1Rk+0SB8b0Xx9+1Z8Xy8IEl3s6GGG8tBZk0oPmexauhBNrY2e9rEkM
	GyqvVdK+geIbH815VfAUvo0ov+9rxS+7G7awKuv5irWF7TudIeIL++LDEb0dZ0FOmfXZUm
	YGdlb5/IzFz8N5t1PQV0VOH7pc5Hr0E=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=aiDPCQOM;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762969207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RE2eA7P/7Vz7M8h0H7B1pE8WkmHGrQTJe78R5r6TM8g=;
	b=ERbeDkRwGYE1xOBK6Xa/AEvjPwdh4EnGiy+1JgoioXULjtd6b9EGJRmhSCjHJ6vN5a8siT
	xR1zPd78nWdGDyfJpaz4A7R6P3zvHeVHZmwUOthcFnn+3Go8W2blAUVjlt3q5Bhz4orGsC
	FaVF0PiMIEKCY/sidFbJoIS37bDcrHQ=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6419e6dab7fso46547a12.2
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 09:40:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762969205; x=1763574005; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RE2eA7P/7Vz7M8h0H7B1pE8WkmHGrQTJe78R5r6TM8g=;
        b=aiDPCQOMOTYK2iKyFYU8aqZZy0HsNNt+t7qmKVy3Z+teb+kR3hjJyDzVBRfftMNTZa
         elIH3b6PaKfti1bLceyDMSPRt/jDQcnqbuZZ/0DwoX6bV74rEky+GfKqELtz0Xxqlctx
         /7OAvyetqzUsxrfWnbS6M2i1kr2NsX3h12ADuu6pqsfbx7RsZoBoacLvomOib+JnQNWI
         O13vpWHdOUEeO6hry35+TuMmc/bpl6bbIiTyNM7kcPAcMXiE0lx2hAZD+/rU/Bk1gHjO
         TxKPBfRVgbspChgj5eqBn/8q1uPc1MrCjvizFu1oQsGUNqJL7OsA4dKP3KXN848DpBMa
         ebxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762969205; x=1763574005;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RE2eA7P/7Vz7M8h0H7B1pE8WkmHGrQTJe78R5r6TM8g=;
        b=PMl0Rnmg1vdwUPa9vVc+jYC+ipMygitgiaTEF+WummAQpa6Jie4LQP0Ry4va/3Jvc8
         gZ5R3KCAV///0KWMXjJvAbQHgT9JmW0ncS9TapBWIzS6+j4oGFMh7V7l0pVDO66eWTBd
         BOhI4wW9H03D2xi+B48KvHuKqhfiGRJ+xmu1X/g8SaNyrHwFhhE5c08NpKpSs3rF8g7L
         2kaClMZbW8Tv3v3VcCM0OgnVSnz1x5jXzECD5kLCbdeLjNjntbDpeOGq0LXlM65ezCSC
         vlZaHUfm10qYt6vGSh0mcJHSm80Gjl1qBTzUOi7EJToIOSwrLyYXImyfkaEf7D1m1w+6
         sSDQ==
X-Forwarded-Encrypted: i=1; AJvYcCUVknoI++7gbUCmhhCCXg3djwRhEovOAOBTXv3oTCOoGrAySqAFlyscU1P34MXofi+p/NkIxYNawg==@kvack.org
X-Gm-Message-State: AOJu0Yz+zJMyYe8XU/14lKxGzZQW/HEkuMAOQi+JGsqZUPcW3sHrlBV+
	tsPqGovfB3X7dBoKI3UhqKs167JVip/vRIONt7SPduxmIVm8pD7gLa8R9eCi5p90ZJfA9WhbDbR
	HefCz2EU4J1SBAdtZuKV/XPlAfsQzC+fYf2Vfc+XnhA==
X-Gm-Gg: ASbGncshmcr0g4I6YunhTC+QMAM5qga1PneXPeoJIcqdn7Jxif6TjPkKAmz/xiWvpLW
	63qd3cvbLq086J4Qf87auTcof30ZbeX026KFED6mAVLRThQnLWZEhZGOI5pntGzhLG4wrWOPc3t
	+B1BC10ef+H/C1wl270HeaPXD+PRzCc6yaFLoAx1VYMyjmwTGqC5pf2xVneLeBL+oCg/XpFN0IH
	+SLCswsGCcg6QVIYlZo6Q6FVzggQK5W42CUR9Cb3foCXL73GlKtm+S3vA==
X-Google-Smtp-Source: AGHT+IHi5sZulNxTcGLT0vratWdEhRElVLK7EUhU9NgVJAmPvI9YHKYMUBo34Ck91lnZ5X8prgSv1FiptNF2v5kod6c=
X-Received: by 2002:a17:907:7f22:b0:b72:a899:169f with SMTP id
 a640c23a62f3a-b733195fe84mr372213066b.4.1762969204362; Wed, 12 Nov 2025
 09:40:04 -0800 (PST)
MIME-Version: 1.0
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
 <20251107210526.257742-3-pasha.tatashin@soleen.com> <aRObz4bQzRHH5hJb@kernel.org>
 <CA+CK2bDnaLJS9GdO_7Anhwah2uQrYYk_RhQMSiRL-YB=8ZZZWQ@mail.gmail.com>
 <CA+CK2bD3hps+atqUZ2LKyuoOSRRUWpTPE+frd5g13js4EAFK8g@mail.gmail.com>
 <aRRflLTejNQXWa1Z@kernel.org> <CA+CK2bB8731z-EKv2K8-x5SH8rjOTTuWkfkrc4Qj6skW+Kr7-g@mail.gmail.com>
 <aRSMsz4zy8QBbsIH@kernel.org> <CA+CK2bA6vCH=RkiZjAOsh5iR52BY567bJB3HNAGqDb307YxVdw@mail.gmail.com>
In-Reply-To: <CA+CK2bA6vCH=RkiZjAOsh5iR52BY567bJB3HNAGqDb307YxVdw@mail.gmail.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 12 Nov 2025 12:39:26 -0500
X-Gm-Features: AWmQ_blg_-YBJXBsWxA1u_AvYtpevCDE34qeWleg00Ut4TD4d0UoYoLFZzxduk8
Message-ID: <CA+CK2bBvVW0XbsQaFjB0SzsTuqLNLhM7ak8S+yORH=_6W3iPqw@mail.gmail.com>
Subject: Re: [PATCH v5 02/22] liveupdate: luo_core: integrate with KHO
To: Mike Rapoport <rppt@kernel.org>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com, 
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net, 
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, 
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org, 
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr, 
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com, 
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com, 
	vincent.guittot@linaro.org, hannes@cmpxchg.org, dan.j.williams@intel.com, 
	david@redhat.com, joel.granados@kernel.org, rostedt@goodmis.org, 
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn, 
	linux@weissschuh.net, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org, 
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com, 
	myungjoo.ham@samsung.com, yesanishhere@gmail.com, Jonathan.Cameron@huawei.com, 
	quic_zijuhu@quicinc.com, aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	saeedm@nvidia.com, ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com, skhawaja@google.com, 
	chrisl@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C3A2CA0011
X-Stat-Signature: g63chqzaji5a5wap7yn5ihpiog9ptmay
X-HE-Tag: 1762969206-730941
X-HE-Meta: U2FsdGVkX199+B/Ajsexsx5FZRHcHHM0KNqfcARrcuQ3e7ihrkmqvKOhXJY2i9Iakqu0+160ARc5dJeeOnBQc6TApk8BkWCpestwukzBAT2R09RTcP0t03u5UJpgH0NVLLSZWWK0Zw3MjZdsHmdZLYcLg3Qn9lwOSxT5N33HBnvsgHtOWyXa/lEbkSGqPVSH8vmO6/X4oN6yokK3TbAYsPDrBzTnDpVTzxYCfGj3LCzXYs5Lwae6fw8MGjXGs4y+ZeW24/ufoQOmlGJkAVhJPShHCGzeTLJM4ICG3E+Prh7CqePO0IOBaERR4Gucryrf/8ZnlyYJS3YE1CStI9CqKN4ss94yPIUmMCPHk0xvWHC4dBwdvrsKR7L16ZF5E3v3e7OBOK0uZyQhMu/glZZxYA5NeBRwhwMn6DSXDJcvD21TN44HH0bqxzjnZ9TCMjZ1gzIP7CCj3YWYRbUw3pVixDhNGa7+WbPO4QtEDxY1ylKtFPJ0fm4XwE5Co23Bc5GyeDLVOLWnvpFucqpIg9O24vc9tVKPY1zY8K+ARVs66IA5xxpgMxS8/t/6mfYdqfk7Td9NR69ixIUKvMkqzgkP4R6KooJ/BqxoroMdyv8j1P/5qgBk+UTgDeSOmpE7lds0CyQYronj+TE4bZAgRdwmGmZyFtyYV5BOE+lpe0zA5/9PmHsdCLyyLdBWyXGYe6yJJJwDszHTKTYrRQCCyZu+MBW3j4j3BdXvMpfYcisLuJL/6ca/HKzFrUaWp0RzAdR8LfeCdsUrMBTGo9M3w8I1owT0e/b3F7sgA8b2nKRATPOjTfTWyjK9pUKtwPdQWb9zb2NJohW4IxTIAhnsw8e4Qgt+BqjjlkWn/bzN2H9CxkDNhsJXv3Nn30gBwZomAMZoGfpCUL7XL2SMnZ4cd6QUwY/1DWsBgJmdjLvAUe80mxwTEGDn0FIC1PemadFvayc0d3aCzaO8RfWEHdfQugJ
 HcvYesjo
 MKUG3kCLRIehJ0V4HjL3MA8AwLuA4NZpSPnZk4lJ48qIoCndAG4sUNdJtG+Za5q34aaAFaoi+KwU248Lz4wxs+QQK1oZoosStoUMF/6JVHEiSVR7GltyKxhpAlk2SnuwW04YvHw6OLrHQVYarlxhXeH6CuTVOgAQAx+dleJctsbGR+bjDCUJwnOBUJCGKY9Qdv78f1MbGXWJQ98ReBjAD8KdGXBJuni7Efi7STECQHQM+11PnYOYwLumDbCgt/LCPoTR+Enwo0paWdodHRf3+rQ7k8IjOkZ8pEXhuAL5pwzyMAhGfxBEbxsAUHvvkQLO9meWusnzxYx/PbzjE1gNeyEWXvAH9rSpql6h4Z8NBE2AV1Xx2sWHLHE7lbQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 12, 2025 at 10:14=E2=80=AFAM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:
>
> > > FLB global objects act similarly to subsystem-wide data, except their
> > > data has a clear creation and destruction time tied to preserved
> > > files. When the first file of a particular type is added to LUO, this
> > > global data is created; when the last file of that type is removed
> > > (unpreserved or finished), this global data is destroyed, this is why
> > > its life is bound to file lifecycle. Crucially, this global data is
> > > accessible at any time while LUO owns the associated files spanning
> > > the early boot update boundary.
> >
> > But there are no files at mm_core_init(). I'm really confused here.
>
> This isn't about the files themselves, but about the subsystem global
> data. The files are only used to describe the lifetime of this global
> data.
>
> I think mm_core_init() is too late, and the call would need to be
> moved earlier to work correctly with subsystems. At the very least, we
> will have to add some early FDT parsing to retrieve data during early
> boot, but that would be part of the HugeTLB preservation work.
>
> I can move liveupdate_init() inside kho_memory_init(), so we don't
> need to modify mm_core_init(). Or, rename kho_memory_init to
> kho_and_liveupdate_memory_init() and combine the two calls into a
> single function in kexec_handover.c.
>
> > > > So I think for now we can move liveupdate_init() later in boot and =
we will
> > > > solve the problem of hugetlb reservations when we add support for h=
ugetlb.
> > >
> > > HugeTLB reserves memory early in boot. If we already have preserved
> > > HugeTLB pages via LUO/KHO, we must ensure they are counted against th=
e
> > > boot-time reservation. For example, if hugetlb_cma_reserve() needs to
> > > reserve ten 1G pages, but LUO has already preserved seven, we only
> > > need to reserve three new pages and the rest are going to be restored
> > > with the files.
> > >
> > > Since this count is contained in the FLB global object, that data
> > > needs to be available during the early reservation phase. (Pratyush i=
s
> > > working on HugeTLB preservation and can explain further).
> >
> > Not sure I really follow the design here, but in my understanding the g=
ist
> > here is that hugetlb reservations need to be aware of the preserved sta=
te.
> > If that's the case, we definitely can move liveupdate_init() to an init=
call
> > and revisit this when hugetlb support for luo comes along.
>
> This will break the in-kernel tests that ensure FLB data is accessible
> and works correctly during early boot, as they use
> early_initcall(liveupdate_test_early_init);.

We had a chat, so we agreed to move liveupdate_init() into
early_initcall() and liveupdate_test_early_init into somewhere later
initcall. And when HugeTLB support is added we will introduce a
variant for read-only access to do it early in boot from setup_arch().

> We cannot rely on early_initcall() for liveupdate_init() because it
> would compete with the test. We also can't move the test to a later
> initcall, as that would break the verification of what FLB is
> promising: early access to global data by subsystems that need it
> (PCI, IOMMU Core, HugeTLB, etc.).
>
> Thanks,
> Pasha

