Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0E68CFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 04:30:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFD2A6B0006; Wed, 26 Nov 2025 23:30:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAE426B0008; Wed, 26 Nov 2025 23:30:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99C2D6B000A; Wed, 26 Nov 2025 23:30:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 83AE16B0006
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 23:30:38 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 29D21140891
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 04:30:38 +0000 (UTC)
X-FDA: 84155110956.29.991E281
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4184420002
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 04:30:36 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZM+I49Fv;
	spf=pass (imf13.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764217836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WBY2hGlp5xDNa7Ek85Hj92aNDRHVnR99QGNyQtFdIz8=;
	b=pnCf/CcDXHjkk1GuBToMeyCoZbFBTlAjNU0+hsUPLudNAiPGF70um9ecI6KqS8SQVl2Igc
	M4MYHvtU/IaMqSUHQNRorl0oEiTNADAk7irUrqy4da7pMMaKijz/pWDiWkKFNLggnu3EDJ
	LK7IQ/PCvJu3Y06BSApY2Qe49AEEyUM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764217836; a=rsa-sha256;
	cv=none;
	b=TfznImW4MmcKWNGkiLbiiUQ4JgfzkWYAk8k5tSt+EXhQAVd5lorYRFbRN+mQLCwW28raHP
	pgHcJJhMkuhCKcjzIeaHVW/QcagCbiSGjtKTD3hgjdTfazms94PfHH0tuQqoV4Qy8uN0EN
	9afv/e0BJ5nEkep75xO8sE7C0GP3bWU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZM+I49Fv;
	spf=pass (imf13.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4edaf8773c4so6690821cf.1
        for <linux-mm@kvack.org>; Wed, 26 Nov 2025 20:30:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764217835; x=1764822635; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WBY2hGlp5xDNa7Ek85Hj92aNDRHVnR99QGNyQtFdIz8=;
        b=ZM+I49FvQC9TkSjmMsxmsPMklIekjpmYAdwaVocWji0YaZp8zotXljPAvHCc6sdR55
         Uh54vCqFUj+5Y45YWOOAGho1cts6wXpGmi2G7CdKnmiM5kM3Zpgpx/mcfJxgfeMw9tMz
         a1ho9AMi71r/sIwRUm7GIk5lkvpWO1vPL3GVrht5euyKUIExGEsuQB0OPMQyQacttAXJ
         wl0yIEgrmxtLgaAIqZA31ZUpAwsEFsgMuHGVCFApZBmAptzol8f78R6pHg7ovaVVeDxr
         DDA+hVLaDuHB6fP5EyzlY+Dp674OnBlCk4RV0azNNJvOc7rHMQGk7yKk1TyUyxiciK3P
         XDHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764217835; x=1764822635;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WBY2hGlp5xDNa7Ek85Hj92aNDRHVnR99QGNyQtFdIz8=;
        b=tZleKJnt75jH95/1+SAVKuVIKNZecu4EnJVP64fUBUFkpfgy6fQOeCMCWkF0MM6bRr
         PvRLNSDZTCLzmE92oUj71xrIhze0HvN8W47VJZfx0RjPbtPWpM4pRh0BydfyXMDlJVPc
         OSmtGF5iUXW8K5qyEcHhpodsfSrvt4MSpmkARbVoCqnIO5oBWQaiTozZDuW/uEFXBOgk
         9FdeY1wD9RhdUnm31iHmAlqkv3vv09l5VrBMSX4T8OYdmaf8M5fObW9xHQJDEVwd1XHq
         uWqXg6HXIUslki9AMBF4uw/klVjqExI5gtdwAN+LbImELi+mBuNcXmWqt4wxR1m85i6c
         Zbaw==
X-Forwarded-Encrypted: i=1; AJvYcCVStG7q4HXFB/0c5/9o++Bc5+Bk95/wcOL5ybOOlsh7mvsMo80Br4idD8lAYxtiqp0ZUAqgf3KXjg==@kvack.org
X-Gm-Message-State: AOJu0YxuYLV0kC6u+X+QKMUt4FmFeS4BbrAUgdSYvqE2CKrp1/S0laWs
	Px4r/3vuf27DAPu+VsrhzIFOEYwmDstJQLWkGYk9ql9B/BNTkMwgE0HQZ1YgMWvFMKM4ie9xjlV
	EMNdhSBHkX08sdEpJoIrkoiCRsqyaOwirsaOwCFi26A==
X-Gm-Gg: ASbGncsi3Vd0771g8LEFSaMdt+qoJsetzCK7ukyUbzT3bv/CmZ1gaErJN9NY17DAx7G
	wUV9i39zlpDx8oe3Apn5rEMEVsg4QNMc0cGM/Aqakjxy2sprCEtHvanHhvG6G3w/2l100lQXFMO
	t2+1XV1O6fMFhthSBzXWBj0YvjvPYlCOftPrJIIY3c6UC0PmxkhKjGwE/Mn2/SNRtQzYKHXPZ1G
	e0Uc7kKGR+XFuvQuIb7unHuSdyNRsz3O9KuxAv5vzM0yMJisBxVMH4k0ViBJIatEMotq2jIJ35J
	FCYn
X-Google-Smtp-Source: AGHT+IF/2OHEG3LUgPMXOJw4DDaFf/N1kDbkxj4PlQ+jOCs1AfpUOxHzVBEY8oHxETzeiPPKmtGSMi/k9qIz1abldeY=
X-Received: by 2002:a05:620a:44d4:b0:8b2:f9ac:a893 with SMTP id
 af79cd13be357-8b33d49a4c6mr3106281485a.66.1764217348492; Wed, 26 Nov 2025
 20:22:28 -0800 (PST)
MIME-Version: 1.0
References: <20251127011438.6918-1-21cnbao@gmail.com> <aSfO7fA-04SBtTug@casper.infradead.org>
In-Reply-To: <aSfO7fA-04SBtTug@casper.infradead.org>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 27 Nov 2025 12:22:16 +0800
X-Gm-Features: AWmQ_bnJyCR-GwS1_fTaB2mJ8nbB2MiVvoC0dBi_6l0nwDIR-Nl2i2LJsMX4LWo
Message-ID: <CAGsJ_4zyZeLtxVe56OSYQx0OcjETw2ru1FjZjBOnTszMe_MW2g@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] mm: continue using per-VMA lock when retrying
 page faults after I/O
To: Matthew Wilcox <willy@infradead.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	Barry Song <v-songbaohua@oppo.com>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Pedro Falcato <pfalcato@suse.de>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Oscar Salvador <osalvador@suse.de>, Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>, 
	Oven Liyang <liyangouwen1@oppo.com>, Mark Rutland <mark.rutland@arm.com>, 
	Ada Couprie Diaz <ada.coupriediaz@arm.com>, Robin Murphy <robin.murphy@arm.com>, 
	=?UTF-8?Q?Kristina_Mart=C5=A1enko?= <kristina.martsenko@arm.com>, 
	Kevin Brodsky <kevin.brodsky@arm.com>, Yeoreum Yun <yeoreum.yun@arm.com>, 
	Wentao Guan <guanwentao@uniontech.com>, Thorsten Blum <thorsten.blum@linux.dev>, 
	Steven Rostedt <rostedt@goodmis.org>, Yunhui Cui <cuiyunhui@bytedance.com>, 
	Nam Cao <namcao@linutronix.de>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 9zjdzmpprrqx8ntawd99k7fy9r48uu46
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4184420002
X-HE-Tag: 1764217836-613140
X-HE-Meta: U2FsdGVkX18e2kGDzKc1BWPHcZxs29WlYpI1H8L8gjS4sTL/EDDJWUemCNn0xlI6VSUxNDi6aXL6gP1DNb5/aIXtVi+FRpcE8sh7arRgBttl4FGIy5G/y+Xz2wGvmlviAaMl58bEGwj98gDGeUj7CgEeuHm3LBJWAPDCqaZPMAvd33MuQzN8q3R/oXeXm9hU2dxEztN+qJ+FItZcctOCKfueV6KI3A0bx1jb8yyoCNaxwiQTG07axGFnouJ+fO87TdH//vrQU6nZpjlnFm9VqIIAjKIGS8RFDSZGPFTlAeqVsGhuliMtd9t3SVxnTK656cCZiZy4pmbhVidnt40Zjdttga3HyB9o3nF7YQmUt6amkBL4gr1kV+pVAUvCHHQEQps/8f/hRw2hkBZcqZUKyGjh2kau4kmSNIf779AaoUoBe+TMN+n/RYTxa7U/znnh205UcehdewhfnAqyf90PqEYAcyZxU0+Zi+1xrHmqeb5Xt075/sTciklFMc0o4WdNu+G0Dn0js+cZb05Ust2BzRzEYormc/oOtxcOdP6Dpyj7URoE8FUyvgKiE39Wan0/x+dWiyc0O/WDKBdeWclEvuODCwsVeAoLfjSsN7Z6txHQ4EBVkh3hxgGFQgj7vdcyKgmInbfuoOoAuajK+cj/8kyiNlAJ5Z7zDCF1csFzGKtT0HhhgTFo0T3N/jCSHhUggj88uyzPyKCn77co2WhQGpfqNXw2yVcQRrrTwk7J+MwThM2LvFQ2fvIvo5DhYwg8JhFHrhKunWiL0LGA5s0C1ONLXDVVtJvt27A39OaKuuDB0k8DZXmkozmCG9VWRR8L8BqjS8Pvz/UJpO7soZM7UL6W7p4zcSMHMc8TtuLsKdzFw5pvvq0HcMlxrof8IkICr/QjqBhyJMX3XGTqmVUPDwNOM7X95cpZgF8oia6W1Wgz9FgUwl92VEWwVCzJ7ainjW6QC9ZxwpKwEbSbkld
 5Szim8BA
 aMxNZxJieVUMOdkA1rOeVbhsCqqwANqG0a32yRW3As85HjXj0AAab64td8hGM84JEFKbHQ6a1l8WpvIvOlko1xI7HtAHwXsGpm5cQPQdXgw6nW0is4aeMl/d6l67Vz+avqYqVj8LqdaylHVC8hPJBGiaKQ2HDaoWLU19O9hZkHXdu34pBWqNIDYXDlr5y6MHmSAtuRmjg/qxUlZTU995PmVbMipwN72zDx9d8cjN6kcZkpE0/7Zd5Z2Ybaju6Bckb3hV/20PNNpUf51BHAoY83gtvvgHbRja5Isgwjcm+Yl8oulg+Wf5Dtg+YslKjtKgXRKVup4r5RZNbkTxwrDWfQoVxziLSbvdbf1mtLzcen4hKSEIXZQj8SrauWYRy4V4lLUxYhlaNXIVjha5tEnW/I3Ue2pdlEtrFOhzt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 27, 2025 at 12:09=E2=80=AFPM Matthew Wilcox <willy@infradead.or=
g> wrote:
>
> On Thu, Nov 27, 2025 at 09:14:36AM +0800, Barry Song wrote:
> > There is no need to always fall back to mmap_lock if the per-VMA
> > lock was released only to wait for pagecache or swapcache to
> > become ready.
>
> Something I've been wondering about is removing all the "drop the MM
> locks while we wait for I/O" gunk.  It's a nice amount of code removed:

I think the point is that page fault handlers should avoid holding the VMA
lock or mmap_lock for too long while waiting for I/O. Otherwise, those
writers and readers will be stuck for a while.

>
>  include/linux/pagemap.h |  8 +---
>  mm/filemap.c            | 98 ++++++++++++-------------------------------=
------
>  mm/internal.h           | 21 -----------
>  mm/memory.c             | 13 +------
>  mm/shmem.c              |  6 ---
>  5 files changed, 27 insertions(+), 119 deletions(-)
>
> and I'm not sure we still need to do it with per-VMA locks.  What I
> have here doesn't boot and I ran out of time to debug it.

I agree there=E2=80=99s room for improvement, but merely removing the "drop=
 the MM
locks while waiting for I/O" code is unlikely to improve performance.

For example, we could change the flow to:
1. Release the VMA lock or mmap_lock
2. Lock the folio
3. Re-acquire the VMA lock or mmap_lock
4. Re-check whether we can still map the PTE
5. Map the PTE

Currently, the flow is always:

1. Release the VMA lock or mmap_lock
2. Lock the folio
3. Unlock the folio
4. Re-enter the page fault handling from the beginning

The change would be much more complex, so I=E2=80=99d prefer to land the cu=
rrent
patchset first. At least this way, we avoid falling back to mmap_lock and
causing contention or priority inversion, with minimal changes.

Thanks
Barry

