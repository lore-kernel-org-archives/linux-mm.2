Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00D351090240
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 15:24:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D13B6B0506; Thu, 19 Mar 2026 11:24:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 388ED6B0508; Thu, 19 Mar 2026 11:24:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 249DF6B0509; Thu, 19 Mar 2026 11:24:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 099386B0506
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:24:34 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9A71F1D349
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:24:33 +0000 (UTC)
X-FDA: 84563184426.12.B1CE3B0
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf09.hostedemail.com (Postfix) with ESMTP id C9293140010
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:24:31 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=UQrtNpgs;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773933871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CAHdFeNRl4yy2sR/1LOHb2d72hyJTySGsjAok8mzB+g=;
	b=SKfU1x7DQd26imGDubwV3xYHwXr/zofTArVgraIZ8GvfyHmFvKRmqOPhbQpjphIgRaASkn
	rxp7oudkq16qTu1B2/TBb34+jHMg+HaMfv3W9FuBXlYEOnUMPXATJ33nzKJQnAndIRSpqY
	Pd7PNoJNB8mIkA4P5z3FmkJF8wxXffo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=UQrtNpgs;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773933871; a=rsa-sha256;
	cv=none;
	b=g9jsh1gU/25yMzC8Q4ucqj/fmYvdMpLSESgqBha8Rmokn2ZH7aOUmOMtbit+VvwcmXN2qx
	+g6I82mwRa2fHwUmLPf67vJy5dgoJB6qQPHpPAipiCD+oaZ8FEhIX5feI4JCCMckRB+6VV
	FDskq+I1cxaIsec8TKqjg22VA8jd36I=
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-89c6a711ce9so19225676d6.0
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 08:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1773933871; x=1774538671; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CAHdFeNRl4yy2sR/1LOHb2d72hyJTySGsjAok8mzB+g=;
        b=UQrtNpgshUF2/b8BDCrnRShyJ4YjP/wFldhqNeIEaSEZtNKOeENsWl+Qo9yi74Xk+1
         YgM5iUNsOwjZaQxTLh1/UtVG5xO+l7KBHYbUTQyw8bJZ4azKg8RYBQsiJn8BECur0m83
         8v7eXe1P/WFpIdN+1tN+Axx5T/VY4v8KAulolWYtdKlHyw2nbtZQGt1Bj5ax9FvSKnhe
         ONRYKgN7rQMeKGfXr6yf7IrtlpGnoxQWy8fdpbpHIUZ2Ca3+6+Fv2HcuBcZPWKsr85rF
         aFQi2EvnWdymA2KvGWkIsxy5+cv0xkIkfqJEom4f53fz3QtV9wcQHMeVkCyGOVvZCQaO
         UWaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773933871; x=1774538671;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CAHdFeNRl4yy2sR/1LOHb2d72hyJTySGsjAok8mzB+g=;
        b=We59QB3XOaDzIhqmXeuD1api0tw5gOgnZX2J4atGENLwDD+BlBRyWfcyjBPK7pIRmX
         tyD4Lb3+jCjzEF+xqceqmg8gsgRo/PYJYFiu68iDGrHY2X+2m319hSoO5OXPspgId8md
         vCBU5Q5gs1QpOjBbwC2j47y25T7cFNyGTYpA4n7o7qB6CU505L3H3HIiXg0GA315PbtX
         2HtjCLHbIzphM3IkDnOz+8o1+imAWGRu/Y1ZyJccF8r+ifNp0WTpD2MumNG8whQ7lYD3
         mG+MUW/fOlI8nJwog0fSQmgCcVtYl7G8kndwjyeqUoVfPrTbiWnJPBMpvDyFnxygTYkj
         ffIA==
X-Forwarded-Encrypted: i=1; AJvYcCWMvSuC5mVPNJBWjw73VcTCGNx/x/R1UmUflWAkNw7rw73k8KMhiZ48FAPXdS1IWQTjDCb7AIsKAw==@kvack.org
X-Gm-Message-State: AOJu0YweqVw1TuYRxt+oznf6jb+1tuL5+/v1g6XtUhrxVbkTeIvjL0c/
	CIL2RPsYtkgswdh/gOjTVNYzXwcrlrqwVORRmmOc+MCJ7Pqngp3jvtxEtKs+pQxwYR0=
X-Gm-Gg: ATEYQzzOLSNDvh+JBHJy44fTJca12UuxMdK247GtmaP25i2ime6kIjEMeRNSLMsLqSx
	X6ztO5MHUZnQADaD9DcKjpbZTWcsR7+yiQ+JZjS4WVCHdLsBtK8Mf1f8wokYTIYM3GWidAF/HY7
	NQPw/VHSGpzoXN3bab1IqM1BBIzztnxD8Kxa8Ok+zxq6CiDbiqx34nmdSk8G+z8xJIHvl2Ca6st
	A49n1b1q+wDLAg367uQ0Wvsi1nKLkppkIC+Shj01uyFPDdPb5noXA2pP8BjBN2GyrZWT+uH5nFf
	czQ3UTD6Je1ACF9XDd05WcD9ISBOubralCb+3VxFIaHPaNVOvIBM11IoCjQxRG2y38KuT+nFtNc
	3hmq60ZshUOd8CqY6n3Cn2uwnfQ5xVBbIhfDrjLI5canb16ltn2iRBC3aCAWgShOSY3ACj0+cfC
	Nhg2qnwedLal1eWA0xFsn9Dwf/cc5UL5cY5VP59CLKF2NtE1dpzL6cLW9Sc1A8N5vbgUq43xFCD
	FqLvOnhCQ==
X-Received: by 2002:a05:6214:3314:b0:899:e702:b852 with SMTP id 6a1803df08f44-89c6b5fbac4mr107205736d6.57.1773933870639;
        Thu, 19 Mar 2026 08:24:30 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89c6b8dfdf6sm49250646d6.5.2026.03.19.08.24.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2026 08:24:30 -0700 (PDT)
Date: Thu, 19 Mar 2026 11:24:27 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org, linux-mm@kvack.org,
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH 1/2] mm: remove CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE
Message-ID: <abwVK8nLpSLVcT5G@gourry-fedora-PF4VCD3F>
References: <20260319-config_migration-v1-0-42270124966f@kernel.org>
 <20260319-config_migration-v1-1-42270124966f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319-config_migration-v1-1-42270124966f@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C9293140010
X-Stat-Signature: a5ngp58ykw63cp6gftodqp8kwhz347df
X-Rspam-User: 
X-HE-Tag: 1773933871-538494
X-HE-Meta: U2FsdGVkX18Unm0kFm2oCW6gLm+bebgA5D0XWGGJIAlFEhkGOky45OmHj/N+uz/APsEEJ6ETbgQFOzzhSXDSBPUq0pRaLsWQWtQQbEDVYNGk8D8Y+OuQwA8pijS19ZeTaAHw6KXY+aPbsWFotI9B1p5gG0zvPKo2Yjoa4MWXYm9x9fgJzbWHMxqjakhVE7gqYKnOPC12GUCmI/0L63tEKDOTMCYlmAo5u61rQ3M5UL5BI/uKH+CXOYPoNoYHDgefVgAqwQb5w38FeyBwVOaYOY5bMialpmI4DlxPj1MveOf57Kl7n9bG7YXHrMMKdAfAGPdTtFqHNZq4alKDeFDqq+LPkMdaMTZoxpvaMPfHp19rEA86WbaKpBb86ZuxXWrRO8Oi+a6uA01yOFFPnB2pcQoNjsPO4/drMalT+vXXuHJONjHRzeK2njqcmdiyJTJmCnmCz9aDONziKMIzPSMwChk5WdFbJ8SWwxPj2UxWsoE5yalAtXt0ltIXxkUqhzmK9KElPrvqmnwTbFz500me0e7KYrQCXgQy1/RkKjJi85c13RQPrifsypMRUeOfr9f1T3VLAIxPc9QQL8z9WuGQ2G03cBwzQ+lOOpwBRbY2xUnyopAqRuRz72njQeytuAcEa5eUjfodjLtq7l/QN0c9WbnyeAmuutIYPTKAOWfAbud7HqO8UNy140qd4JZfLS7z0JpGJyCSir6CkrnRHoLhkrHrMisIcghruifVTH394hoR2hChbclv3m61noGmNdvdBdYWsxVWPhP2V32nr75UfCOswQxryOT5e2l6+fRfHY14UJmVl64ShfLJ+p+JkoicsUjZDbz+ufzM3JWHDmaxViEEQiIEHWqFLF/Zn5XM1h2WVWIa7VAkiRJFSczCyiotdyVgPO7RCQuPlS0O7mQRqWMtfqmONnzt5lz7QcXlIIbvuvq7Agw3R4ccQYxVr2R5AzfGYor6WEjS3L5PpZi
 fMaPs9Xf
 9+gFn8szv9Jv67eLPgt/ao39jX2FgBa2SjU7SZmMu7RahVSpYxSoYIh7qnunbT9m3PZYv6QmGqrH5N/yd38aHW3pPFum2piJPPCcx4AU1Aso5KrSjoHgAzeBtYmDcr7YsP32m4PatJe9QkBMYrIdUyLeF7OBst94++/G39g8dUllUGbcf062q77F/n/Sdw6SS4FQ0BmLvlogICFOer/4/rI//oIBKL/etx731slU1HgACPL8BS95EO7qbmOFzxNffuuo1DLJRiAPYbfIgwK766pETgtrAa/GJWZL+fcIryDAtOtoH20ltWDuJNry94m33gdexNVcBj45DWZ281+mq7IHMOlRGV3fHFVeHQEaeE1yUxMivW1cuqiyI7LlyBy4uBvxzxtxS9eTJAcnpqXRo4YEvvArKDdqOpDnE9MOqvnBaG3fJalOl8V6cbCQVilW+jQHviyb1dmttEN4ZdaHeV4ZSJ6sRzW5Qp9SRywaIfCwB9fL/ZR1w0674HcwlrugP3jAXHyMAr1f2gq6p/bL8e6FhEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 09:19:40AM +0100, David Hildenbrand (Arm) wrote:
> All architectures that select CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE also
> select CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG. So we can just remove
> CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE.
> 
> For CONFIG_MIGRATION, make it depend on CONFIG_MEMORY_HOTREMOVE instead,
> and make CONFIG_MEMORY_HOTREMOVE select CONFIG_MIGRATION (just like
> CONFIG_CMA and CONFIG_COMPACTION already do).
> 
> We'll clean up CONFIG_MIGRATION next.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

HOTREMOVE has long been a thorn in my side, I appreciate you cleaning
this up.

Reviewed-by: Gregory Price <gourry@gourry.net>

~Gregory

