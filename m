Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBEFAFB5E87
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 23:23:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8A956B03BB; Mon, 16 Mar 2026 19:23:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E38416B03BC; Mon, 16 Mar 2026 19:23:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE60E6B03BD; Mon, 16 Mar 2026 19:23:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BBA256B03BB
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:23:20 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AAFB6B8621
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 23:23:19 +0000 (UTC)
X-FDA: 84553504518.29.7AF413E
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf30.hostedemail.com (Postfix) with ESMTP id AEF8C8000F
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 23:23:17 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b="IJtlU/lV";
	spf=pass (imf30.hostedemail.com: domain of paul@paul-moore.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773703397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OjoL/xI+JfK24mJlLYQ/qQdhvwGI+GcsV2kW/9vszrY=;
	b=s1WMOotNajM1SOvoq6oc2xan+IqdEYruT1DD/jUwePQ0Vy+OEps8kCvDssrlQmTjg8lkJK
	IqYS95dt8mV3600yYGs3NzhGV9Qg271NzRhUCwcw8/iu5YM8JCUHSbfZZmmx2UqUKqZl7J
	72S+XMvoTrTmuHqrGCUmdtm0PAFEISA=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b="IJtlU/lV";
	spf=pass (imf30.hostedemail.com: domain of paul@paul-moore.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773703397; a=rsa-sha256;
	cv=pass;
	b=fUwDsGKh/887zSBCBHAoOr4ynPo3n5v9EN/0nxPQZRiUaKhAFsF5oprLS3GR63jQWS+zN6
	pla/lHLbsr2vrArXPnrQssuoSKpqotjcwLJLXmfq2LavB2RaHI+Kjpz0+1PjmhOkL1hyMU
	iYTpFLlXSvAhzCfwZiwGfNptKfSOq88=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2ae3a2f6007so41327585ad.2
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:23:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773703396; cv=none;
        d=google.com; s=arc-20240605;
        b=k5my8t84arQwSCO9w0hf+pbZbRmyNiGiR9Jq7L1uhpq8W/KaYRHm+BUvlvF/x65Sen
         COomrWdJ8ukPD2wP77J38EyKf6avh2ti79gDXaU9o2jq86+tS+m4pZmpK18BjytOe+wd
         H94vqxpajJqid64EyKYyOuATsBJNbyCKnWxcmLT3FfsLTfWBoaxzFsfiC03EI7lRX64R
         dggmiSctKWeh5mhVvcKqVMCzw1thto3AUBmqoUzymDppV7xwxuSEQ0PH7nVCwPA3TSta
         +WsXAay7lJDA94CUDy7way93aZbEhibG8Qc5HENlTu2Y2iVKyr3BRgSbWA4VPFN1Daqw
         E2Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OjoL/xI+JfK24mJlLYQ/qQdhvwGI+GcsV2kW/9vszrY=;
        fh=fOa1eP3d5ihz3wkIMouft2oWXVzsXn9oi6Cbgr6u5uA=;
        b=HZOfyvhdqreyeIF2Y38RRSaXMWY4jsgqZD4Zyx0+SEsPEvRt0y2sXkiLKNr4ubPGPH
         pHSPJ1z29WVjPfpWGurKeoOOVUEmBD06qTDIp8wY7w0On/A5+EDFxLngNiwAX88sX7pa
         aDANVYSgahOhaxqAiBmwQHhZWerSD02+HaCaxeUqiSv27baw5xJigj9Hl8ch4VNSXFOH
         nBc0xY3W5fFROPCODAFXLvgzozBKqfdFU0N6cySZ2stqj0MrzNb2zNvLeQlNE8NOl2OI
         TIsa5YipxdSO7BcwutJgK4DGuAumNgaf0w6F1pMc0qGd2Qgq7j4eKRaw8FIm4p4U9dRT
         SU4g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1773703396; x=1774308196; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OjoL/xI+JfK24mJlLYQ/qQdhvwGI+GcsV2kW/9vszrY=;
        b=IJtlU/lVSrW0ENkZedWKFVx/nbw7sDgq4OvQNtbqWsjhsXNYr4ROVNnkyszI3ooO6F
         Xj+isk8ZGDqfit3glaVlOvY7oNn+CRckyEzSJHLX/Mbxyve4MV0h6gLvUXOPjCMmIDAc
         etdH1Xb4HSqQqRQMIQ0Tez/LYhVlh006Q60HhqdDJKEEIVzJQyyjXT+XKyf5CwbewQZl
         SboaHKRZNdsLyiPOwzSbPUh/gxTBcdDGIL6OVNoyDq/b+Xam/7eG3H9AgxNtS1q7jKiZ
         aj+fJ4t7E4BayMf1MbcqDXB7jAIlTjy9Q1qHEOQh5QBPK+eg/Wh41rP60G65z+rf3EnK
         ftdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773703396; x=1774308196;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OjoL/xI+JfK24mJlLYQ/qQdhvwGI+GcsV2kW/9vszrY=;
        b=gZnhdvXvsEeU87FJsm+jd9E5nu5HgNcALwS20hBaDl1rudh9W/CmBGyqBgeH+SrVNQ
         BZV8ghvXiaaAmQjtmVD41cl+jviDAPXQXA5sIgC/qPsNiOF47yJyIyZFw52Kz3Ni3LnO
         Bq4cOY+uLfkMdOBfdiotwEYa4bTJ+04/b3obLJSpZGmuDMGkp5FBuNCzrankDfPDrvBJ
         eHm8dngVQLGvXNXp8ujnRsXc5PhQSTYAxBrYCbu7bNoNC7AT/OXGKseoiIPo2I0LQ9xQ
         6+LT2+o9v6GP9ZvwwOCR9JcHikhAQBYXxDxPA45AXMolKgJ2g7EL3GlWvfes5insJOpH
         tgWQ==
X-Forwarded-Encrypted: i=1; AJvYcCV/74jIrFtJS+YrAA/8YVOsZU4j48sJqvAUtNIFcVjOh4AQ/sOFZa5zQw8wRPentDus4B3WvFWc/Q==@kvack.org
X-Gm-Message-State: AOJu0YxAj4qnni05ze1MPSCq8+mLz2AIj+w3cxyTMXl0YX7yASpKBeXM
	+32Qinj534B9LkvBoULw4JdB/sO1UR44MUgzEcq5UjY5d9/6MLYuTWpHLPm0ENbP84JYcgEWdO+
	nZ/E/JuTKKrQp++viF9NEYn/CgwaMrvnvghII2Wot
X-Gm-Gg: ATEYQzxleFHQBn5w/wlNyTU3UAVliSgtoDdPIwXtfV08RQIQsvrsyzlGbzZ1EAUczgm
	+ehX8Z4qj5qsyTY2eVhhD0otBaKy6QEKMcbtOfUsNuZffKEyW2cSnrZPx3p9jcOPYgYBoeZeCsi
	0SEJnAIz5hfJjmxn+Y2ASLHU8w/AH4aLKNDOp5hqxhH/WV2fn52yeawyM1pgrsY9J+WIo805meW
	Qa+xcon74oh+b9pYWdQFGqrlVNdKQ6JAa0manR0riChWbk0Z0sVMj+m9HpQzqaPZuEXY6Q4rCcA
	Brpc4aMEx+Xspgxz/w==
X-Received: by 2002:a17:902:ea06:b0:2b0:5c3f:c0d8 with SMTP id
 d9443c01a7336-2b05c3fc4damr40223235ad.47.1773703396327; Mon, 16 Mar 2026
 16:23:16 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1773665966.git.ljs@kernel.org> <063af0422d99bee0195589aa63f8f44edaf409fa.1773665966.git.ljs@kernel.org>
In-Reply-To: <063af0422d99bee0195589aa63f8f44edaf409fa.1773665966.git.ljs@kernel.org>
From: Paul Moore <paul@paul-moore.com>
Date: Mon, 16 Mar 2026 19:23:04 -0400
X-Gm-Features: AaiRm50DdYFqfixz3H6HRwMmLfdf5osoLUZfr0b1blDqz3IzGNPvd_xOI_ajOas
Message-ID: <CAHC9VhR2T8ujtfvz-HgkgSFByptTLmhbCYS+scY53aYg=sgfqw@mail.gmail.com>
Subject: Re: [PATCH v2 17/23] mm: convert do_brk_flags() to use vma_flags_t
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Kees Cook <kees@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vineet Gupta <vgupta@kernel.org>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Brian Cain <bcain@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
	WANG Xuerui <kernel@xen0n.name>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
	Dinh Nguyen <dinguyen@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	Christophe Leroy <chleroy@kernel.org>, Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Michal Hocko <mhocko@suse.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Ondrej Mosnacek <omosnace@redhat.com>, linux-snps-arc@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, linux-hexagon@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, linux-um@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, selinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: b1ugpfibbae7ngaq8eujxihtpap4p8xq
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: AEF8C8000F
X-HE-Tag: 1773703397-39737
X-HE-Meta: U2FsdGVkX19UXrw15GpESnIm9Xs2JkR9tHueu9VuNW2H1eqjMzk3HpOz/DvUE9FBB5L+aP0C+v1pn96IhgHZ+l/aZ40wr6ifuz5RBzDkz5JSbQg+CLEXGL3gT8ng8GyyyiNK2DEfiTsHk0EE5i9pF2A3RHuQk6HFiG0NT7x2wlf4Zs3YPsVCY6sIc2uzbKYjYpo5dgOCi4YPlVrgC42pwxQbiZw8p53Lj7Qkh43PaIN1bgQmySTUjKW1b95VOpewzhf5CXVSAotKFcnK+MyBI0XVAQ2GJSH9MHb4lpCpuGjv5AC6jIvVDnzj6XtQLwXmUZTSSFfH8cIweJW7A1GZIKJGwknsr0MiO7TR9d1/0NuM01YRQEA7uzUy89GYqA1YErCeAKdlCtwtAOuGvF69OLbUzpjSutx6Z4Jo0AJd5GXfzuiyOiYmV8QjzqDldnkFFjxzGtGk0BLZjVWnxqUjxLYU8mcbbsQWvZ3qpPwdujrzhaGBNmbZWW3JtTgxYupW6TvzAjINUohK5yKysuEam17G0qr5SaRHnXRJ8MGj+MAK3uRYY6APdmjKZNV3+oveGaMFeumC4XQSgULYk9Dt2NWEyJS/k1/vDOwpxhb5DoKe2RdaJVyVvZ+6C6nQd7hEQUpBfFVNrUaZwMNy07RvEmTmaFvfpn5MTu0sTB9xq5fAWrKrOxqAbJdrov/QKnssUnvabzuPf1MHZa6zqZ6sgWSKK0sYf7AmEfQ1zfczkZMhkYF9PwDcHQmr5Ep17OZwL0xFey/idLe6TB3IWq0Hhx50q8KyLwSFW2tNmETgscWE/v7ENwMvkCRO13VSusonAnRr6nxmbYDCqGLzvvi/syf9tOl5C6qfuTruhiWWv9vx3FjBumIkORRMP4darYoo02NJBRRzm4rZJHM06GEr/XgCrWgssnqfih6UeSLGci+9f1jCNCgz8w4rkGe6UI7aqLpgT8rcqYouTABV7As
 LE9Jjlqk
 pmfttJB2SLCbT22o7k296LMz/1qGZSDzhcdD80vuTj4eHzTXKHkm9mRRyeqOM/G9ozK5YIHQpoZlD5KthAKdVM5tkj8hEgviudK4saahlbDuC/O3HKY/QjYbTwZHFiaZepfq9loZQ+6qJFtKdh+H1n+aQbY0zFDncPSfAYkxZwXSv3gey8pe6bs8NX3ETN58FKs4gZVYrHgJs5L3BYLr4p3/qJPtJNU8sggMDcNEyAs5KCrH2/GglLE1EEmCk1rBZcEtJkeLf9Z+UdwIPFoLSZRIbmf1Wuy/cc8DMEeYzJ83Eouy9fuec9JTcItrVMsF/1mvp3W5cTcX7aaIV/KhelescvGhALH+NO0AXTkJNfrg6qsbmxjjSetUBHWhXIXVenqAwbUeFMtjm21sxuoiVLeBZ/rCthxETupB2JMQNs+T5GLznmUJTH9aFUbRxU9ddLzrS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 9:09=E2=80=AFAM Lorenzo Stoakes (Oracle) <ljs@kerne=
l.org> wrote:
>
> In order to be able to do this, we need to change VM_DATA_DEFAULT_FLAGS a=
nd
> friends and update the architecture-specific definitions also.
>
> We then have to update some KSM logic to handle VMA flags, and introduce
> VMA_STACK_FLAGS to define the vma_flags_t equivalent of VM_STACK_FLAGS.
>
> We also introduce two helper functions for use during the time we are
> converting legacy flags to vma_flags_t values - vma_flags_to_legacy() and
> legacy_to_vma_flags().
>
> This enables us to iteratively make changes to break these changes up int=
o
> separate parts.
>
> We use these explicitly here to keep VM_STACK_FLAGS around for certain
> users which need to maintain the legacy vm_flags_t values for the time
> being.
>
> We are no longer able to rely on the simple VM_xxx being set to zero if t=
he
> feature is not enabled, so in the case of VM_DROPPABLE we introduce
> VMA_DROPPABLE as the vma_flags_t equivalent, which is set to
> EMPTY_VMA_FLAGS if the droppable flag is not available.
>
> While we're here, we make the description of do_brk_flags() into a kdoc
> comment, as it almost was already.
>
> We use vma_flags_to_legacy() to not need to update the vm_get_page_prot()
> logic as this time.
>
> Note that in create_init_stack_vma() we have to replace the BUILD_BUG_ON(=
)
> with a VM_WARN_ON_ONCE() as the tested values are no longer build time
> available.
>
> We also update mprotect_fixup() to use VMA flags where possible, though w=
e
> have to live with a little duplication between vm_flags_t and vma_flags_t
> values for the time being until further conversions are made.
>
> Finally, we update the VMA tests to reflect these changes.
>
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ---
>  arch/arc/include/asm/page.h        |  2 +-
>  arch/arm/include/asm/page.h        |  2 +-
>  arch/arm64/include/asm/page.h      |  3 +-
>  arch/hexagon/include/asm/page.h    |  2 +-
>  arch/loongarch/include/asm/page.h  |  2 +-
>  arch/mips/include/asm/page.h       |  2 +-
>  arch/nios2/include/asm/page.h      |  2 +-
>  arch/powerpc/include/asm/page.h    |  4 +--
>  arch/powerpc/include/asm/page_32.h |  2 +-
>  arch/powerpc/include/asm/page_64.h | 12 ++++----
>  arch/riscv/include/asm/page.h      |  2 +-
>  arch/s390/include/asm/page.h       |  2 +-
>  arch/x86/include/asm/page_types.h  |  2 +-
>  arch/x86/um/asm/vm-flags.h         |  4 +--
>  include/linux/ksm.h                | 10 +++----
>  include/linux/mm.h                 | 47 ++++++++++++++++++------------
>  mm/internal.h                      |  3 ++
>  mm/ksm.c                           | 43 ++++++++++++++-------------
>  mm/mmap.c                          | 13 +++++----
>  mm/mprotect.c                      | 46 +++++++++++++++++------------
>  mm/mremap.c                        |  6 ++--
>  mm/vma.c                           | 34 +++++++++++----------
>  mm/vma.h                           | 14 +++++++--
>  mm/vma_exec.c                      |  5 ++--
>  security/selinux/hooks.c           |  4 ++-
>  tools/testing/vma/include/custom.h |  3 --
>  tools/testing/vma/include/dup.h    | 42 ++++++++++++++------------
>  tools/testing/vma/include/stubs.h  |  9 +++---
>  tools/testing/vma/tests/merge.c    |  3 +-
>  29 files changed, 186 insertions(+), 139 deletions(-)

Not that the SELinux changes are really all that significant, but they
look fine to me.

Acked-by: Paul Moore <paul@paul-moore.com> (SELinux)

--=20
paul-moore.com

