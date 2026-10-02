Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B474DCA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 11:38:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F7886B0088; Fri,  2 Oct 2026 07:38:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7816F6B008A; Fri,  2 Oct 2026 07:38:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D37C6B008C; Fri,  2 Oct 2026 07:38:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 23A436B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 07:38:48 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A18401C3905
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 11:38:47 +0000 (UTC)
X-FDA: 85277489094.30.E8A3823
Received: from mail-ua2-f41.google.com (mail-ua2-f41.google.com [74.125.226.233])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9C691C0006
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 11:38:45 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 74.125.226.233 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790941125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=20l5MGKYIkk3dxTQvp40s490//vZekkNtR3rks2T+EI=;
	b=MhrTOYkpy81CSDrw9pDXXE27+Ru6DHV2n5WdQQSpxFn2GCK+8JIp0JPBETz28l3op3jUhL
	8Or8lvuBob+K74glJYG9EPOal6mr35aeaLoLde/R+bWxpXinp1FLJ36CtX90YZuX+R/ULh
	/YfcA+mvaVaA3jd2JJUVAT4xc7XGAFo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 74.125.226.233 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790941125;
	b=5Ss2VlQeSYPOcXAsIBDWSrap1s/LBmRGhHrMuqIfJmc2aGohz2ItbXc1RML3PSX2FMgpsG
	FyaFAXK6IVC9GwDFKJSbwm2eU8I5Dtz2TYp3BlHOHpIRznA6+6mzUo8d2JMirv2Oi6uFYN
	4syknfZ8CoLQPnQPljVPLW8xUEU3Ulw=
Received: by mail-ua2-f41.google.com with SMTP id a1e0cc1a2514c-98a92bfba4dso358061241.3
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 04:38:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790941125; x=1791545925;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=20l5MGKYIkk3dxTQvp40s490//vZekkNtR3rks2T+EI=;
        b=kuuEfCpWU7Z4xN7Br70dt0vEt4eoFePHLBw7y14IpALDsxQk7X5KD16IcJu74qsCCE
         l//Iqju85CEtWwx4vbvWzPQqgNP4BVsjYJfDOmj9P7cwCmPMFcGykOfdEHdoW64S1w34
         +558fykPps21Woe8mwGwL8PoPs8nEhYleZuc5eyH2DbZrrPdYY6pEQ/Ah84AOLRvwJIE
         XVL8tBV97giPLQDKXreabYfXPc/A3ylmlPCEwMuvT5FJDtRIiCptiux8Y9dmgVzEIAaT
         fNUvRrgyppsj1YTao6B39Y0KmXr2ZFE5I8lWrRSwibeBJaEl0s92Bsgzax5ktNM3snAp
         +j3A==
X-Forwarded-Encrypted: i=1; AKwUvBz2MWnGKkDBPPIKOFtBjq0Hoe4f9fNt9FMlelmOCSwvRLr9BWfrLdZFt4HrYYPwOAWyRyHCOleJfw==@kvack.org
X-Gm-Message-State: AFq9FYJhtEkf5EqwGG3wcqhoPd609W23jEOWHlSsfFjH7m+uamOEHmRl
	Wc0t5LAKuxbJLOAF455xb5uZ1wDDhvEVfdXcymv7YRwoV2HrGAaKaFXl6ro8EXS8
X-Gm-Gg: AYBFou1E3NA77NAz9cSKrucHg8zqLDKIKqcBLUONzeFWobL4a6qHxh6MnXxHbus0/MV
	2njPoTxdURS+mjsdq5aJISMx0OZH2htt1ioQakWKmuJO6k0jv+zM97DNGjxHE2hoPVTiPskazan
	TBC9BJTiR5agkd52GpatUzUfOEyw/NNUUIj8QCH+1WU3XyUB0SGoij3ikVbSTwlIDwfM1w8Ybre
	8Bs5baQn/567F0bF7GW1VBnmavQ70Ca03rywDU+t/NmKPYrw7MNsxfIKJMeDh9bowjzwBU3KxTC
	aicqFVjBRqFxMZyIpPzi0QURlizP0kBls7SnsO0r1QJxDUEPiS+m2WSl+XuSJWjAnlE+hvCwp0A
	lBiwFmPrScEEkuVPgIuMa/SYHFsQzFcerdIzP8iZa/qOY5l6asrw3+BA7WkRIZxvnHxr2KcOdKu
	zT2m6Z510FKuOGdpSXbPZfNg74+VKMqpHvnIhOSX3aKI9x6Qzydk8+zijgGsUJfXG2ARsYtwsl0
	rwvJuy9UN+jrne45mXNBQjZgkzqczy23RWI
X-Received: by 2002:a05:6102:5808:b0:7a7:19aa:f0cf with SMTP id ada2fe7eead31-7c0f5db6d20mr520223137.28.1790941124618;
        Fri, 02 Oct 2026 04:38:44 -0700 (PDT)
Received: from mail-vs2-f43.google.com (mail-vs2-f43.google.com. [74.125.227.43])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-98b19af6040sm2550713241.2.2026.10.02.04.38.44
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Oct 2026 04:38:44 -0700 (PDT)
Received: by mail-vs2-f43.google.com with SMTP id ada2fe7eead31-7bf3079e099so690456137.1
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 04:38:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzqbbifhAVebVwQtZJFWbRn5vbSaZ9dWEEJYTNSG736PaoudH/vbFasqFMR6O16MWlV1K7WzNbdRw==@kvack.org
X-Received: by 2002:a05:6102:14aa:b0:7bd:b263:14c8 with SMTP id
 ada2fe7eead31-7c0f60ae056mr564893137.30.1790941124266; Fri, 02 Oct 2026
 04:38:44 -0700 (PDT)
MIME-Version: 1.0
References: <20260929235711.2287931-1-thehajime@gmail.com> <20260929235711.2287931-2-thehajime@gmail.com>
 <bda5eeaa-7868-4d4a-9026-9e99347afd7c@kernel.org> <ar4br2vW7yZGd3gt@gremlin>
 <94759bed23f00d2044005e36be6f72f297e092f0.camel@sipsolutions.net>
 <m2se2o3jyc.wl-thehajime@gmail.com> <a65f4431-d225-4535-b921-00319ceeb2a2@kernel.org>
 <ar9ldn036SgT-bq1@gremlin>
In-Reply-To: <ar9ldn036SgT-bq1@gremlin>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Fri, 2 Oct 2026 13:38:31 +0200
X-Gmail-Original-Message-ID: <CAMuHMdUKcUxHZKhTEF1gwWrU1o8O6jt6N3r90V5hynrLFdwY0A@mail.gmail.com>
X-Gm-Features: AclHuK8oY5W9edeNeZu9OdjhmLKHIkhJXkjnhYM2yOIrkiFEQlBpS9n1EzHgsaE
Message-ID: <CAMuHMdUKcUxHZKhTEF1gwWrU1o8O6jt6N3r90V5hynrLFdwY0A@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] selftests: run tests on nommu architecture
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Hajime Tazaki <thehajime@gmail.com>, johannes@sipsolutions.net, 
	linux-mm@kvack.org, liam@infradead.org, rbm@suse.com, 
	akpm@linux-foundation.org, luto@amacapital.net, brendan.jackman@linux.dev, 
	liuhangbin@gmail.com, corbet@lwn.net, kees@kernel.org, broonie@kernel.org, 
	mhocko@suse.com, rppt@kernel.org, shuah@kernel.org, surenb@google.com, 
	vbabka@kernel.org, wad@chromium.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-um@lists.infradead.org, 
	daniel@thingy.jp
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: ruga51phaw9co7ntakrkfdkmsbgzcjj1
X-Rspamd-Queue-Id: 9C691C0006
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790941125-882473
X-HE-Meta: U2FsdGVkX1/kqmG/gF85OXGZ7Dx86Tinzwojw0dTBYB1uBk4L2njmqO7CItU59yr8Ev/qEsTA8uhepudyBTeMfSpGX8gaYGeJqaZ90gPukQFf1u/e7VCawyA2el5IsCkf59p9Sh2EPH8YUKFpfhdWKMEdxbPfHfIpnCDXUrzydAICaDC5l7WT/oMRQlUfMruzCIirw9vqNJKhYVotMujp7x+KezsGB++lkbMUMZTmr/qmwYhiX6PZZEv/InOhZN5nLr9meBYwEt25fPpc/VHreS7XqKTXkDeolkugqbsApcqNvkwAFmPLw5pEiA3WB90FlotbRMQkYMmNxckpnqwaYuUFmqZoAfYm3VBiFaahkFEbms6KVMdyJbXl+Kw6PgkO11P0A3zGzkLr7mTWP2uF03zNsLLAt0swcMq2nWr7r7GIUk2qV7eVhTi66Kw0T/RscfX1Wz13qwp2M3sYblmQyYK1O04bwaTXSeGfDwjOi7hKaefFnRTOlbSu1c4SW5rtGxnXe8XLXt9mMYMemR+EF9LHNcadgE63BEk0ntXt3gND+O2oWZ2AUdCD/jvmRW2EY/f/+j2TsDpDCE1hOUyi0/frSDpjtbfOoyGCWqLg0wGvXtJzlvytPyu+0hV9xmB9LShR2ASpS8mywGFR6c11WCXOLJhBBVJqZbQN7qLdeXD5NJXhvEWohpB7srjm7ZUJoaBrbtj1dV3CQciZcYcCju0Et7aoMPfHDh+V13Aot4VcCDXnt2iXiS5h/RtjUOTNMJJ4twvBbhskfOuCOnD3XKplV1C0Rvn64TaD90Ue2ErFkSaI/HaF7mF83vgxv94fL+gdaRaLojf5bFwsqZ5R+TmTdibmnqZnG1IgDhQlpex4zDSRuRj1j2ZCG+0jJWk2M8Igm0eioCWlDD6MFvETVRuU6tfJQfPf9Y16nFs3go4d0kHsC8wtqI0UsI2ESZT0aF7NApQCMk1Cy00ICS
 N4ttLBOs
 mkK4VrFcsDnr8ZoKR5Sud0fvH9Ye7NqDgQjFm2fLU0UdUN978qms4rbkSlkiYGpCNIIAbedvgJdhT3P1NboVrmAW+Ffv2bk+TJAH0+riDKOa5f0CNLFjWIGE6PjLchhyo9TVSRbOxXCR/H9lPElkmSdeUKuTFXVK2FSU4eJkAMF++Iu13hNj8rxr9A7xVfowERjmxKfhapmpm0tVgINBNppoNy0xF8z6WkUMO2ZdmViboqDpcHQ/cRcvasE/IwJOJ1vKlPbee7dkUu1LX/ZW8P5oV+hqCr4JXu+dfWr0qNOHzflibd6fx8iXjZRAn18Vb6jncp8mHMd5B0T4qlnH9113UhsG9onFhrcqHPITJBaVeuGiZ/FFjAU/DY7037rtugiLUOCmzQNoaDPkG0vDoeVMlQFdGkrPzXj7qMV1fRuzd9IsglcnGETbACP/YobuhM9qUCvYvcriZpMERls7ZOi3qcqCQ7AnnW+OA+vgs174cgx8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo,

On Fri, 2 Oct 2026 at 10:10, Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> On Fri, Oct 02, 2026 at 08:08:44AM +0200, David Hildenbrand (Arm) wrote:
> > On 10/2/26 04:38, Hajime Tazaki wrote:
> > > On Thu, 01 Oct 2026 19:01:45 +0900,
> > > Johannes Berg wrote:
> > >>>
> > >>> I thought maybe uname could help but our LLM overlords tell me no.
> > >>
> > >> Hajime originally wanted uname to indicate it, but that caused
> > >> regressions elsewhere, so we dropped that commit. I guess we could put
> > >> _something_ back?
> > >
> > > systemd uses uname information and our (old) patch changing the format
> > > triggered the regression.  thus, we dropped it.
> > >
> > >>> It pointed at something though.
> > >>>
> > >>> In fs/proc/meminfo.c:
> > >>>
> > >>> #ifndef CONFIG_MMU
> > >>>   show_val_kb(m, "MmapCopy:       ",
> > >>>               (unsigned long)atomic_long_read(&mmap_pages_allocated));
> > >>> #endif
> > >>>
> > >>> So MmapCopy in /proc/meminfo tells us definitively, weirdly enough.
> > >>
> > >> Hyrum's law and all that, but I guess it's not highly likely to (want
> > >> to) change :)
> > >
> > > a runtime detection is nice.
> > >
> > > scanning /proc/meminfo might be useful. although it requires to mount
> > > procfs (we can actually skip procfs mount as it is optional) so, this
> > > is not 100% portable.
> > >
> > > checking ENOSYS like syscall(SYS_mprotect) might be useful but I
> > > wasn't sure if this is always the case of NOMMU or not.
> > >
> >
> > I assume there are plenty of other mechanisms. Like testing if fork isn't allowed.
>
> Yup that's an obvious candidate!
>
> You actually need to check for both -EINVAL and -ENOSYS since, of course, we are
> inconsistent with this.
>
> Some nommu arches specify __ARCH_WANT_SYS_FORK unconditionally for both
> mmu/nommu variants meaning you get -EINVAL in that case:
>
> https://elixir.bootlin.com/linux/v7.2.8/source/kernel/fork.c#L2830
>
> Otherwise you get -ENOSYS because it's not defined.
>
> But fork() -> -EINVAL or -ENOSYS = nommu, then just have the child quit and
> etc. should do it.

fork() is not strictly an MMU-feature (you can implement fork on nommu
if all memory accesses are done relative to a base address register),
while I think mprotect() is an MMU-feature. Unless it can also be used
to change the protection using the one or two BARs most MCU haves?
Anything else that is a real MMU-feature? Non-identity mmap()?

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

