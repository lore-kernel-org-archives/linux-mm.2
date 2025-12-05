Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36DD0D2E012
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 07:15:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A9926B00C6; Fri,  5 Dec 2025 02:14:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 581C86B00C8; Fri,  5 Dec 2025 02:14:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BE4F6B00CA; Fri,  5 Dec 2025 02:14:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 363BA6B00C6
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 02:14:59 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D88891A04F9
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:14:58 +0000 (UTC)
X-FDA: 84184555476.22.B55780B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id C9D49C0007
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:14:56 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="QhdAI/v5";
	spf=pass (imf10.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764918897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NQFFwyyrbmSQDwjSydErzLovNjSAb4Pxxp/akbzvISk=;
	b=gRcYQS+CE/koaBZzXZD+W0263VG5xQUBNbp2glzUof2eURtL1yNHGMtH7E0i3AXCRFsDAy
	HqGF2F53tCXY8eD0bkEGHH9BxN206vT5c02i2rnjrZIdSIgTQeTY71YnhShBGPqp/hs/gw
	4qzMq38wSA3n57hNZwari3lYXl6o7CY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764918897; a=rsa-sha256;
	cv=none;
	b=CH4T1KiyUEpNMX88jz0MjGRfnWhXzAwEvyGR9QtO79vrnBAhs7gaL+Ht3G2j7lb7ds90nL
	hsB6HIu7vs/Cs2wKwGCfbpyV+1JG7hPvn4pHrhQWGDt/6AV87g8CMAaYR92vQcoG6GZy7q
	vWeFuWkTMPldDakNIe1B8oroWwzfLpw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="QhdAI/v5";
	spf=pass (imf10.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764918896;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NQFFwyyrbmSQDwjSydErzLovNjSAb4Pxxp/akbzvISk=;
	b=QhdAI/v5DL29B27aKkKW17njt2NXDUaj5zLRgQ9PnYjbelepEL9uBAOMeRl0+QZBCLqO0i
	FBWGA9Y4KtVNcC5PeCSA3psM+JAGkUXUKnNnIohtVJcTYPYZtJalja+6zf0d7N9IxRHvP0
	ky8s31nm1M/3dL1aEhtPlsD+DQeBIDM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-159-U-7T_gsNNiuj00amjV2_Jg-1; Fri,
 05 Dec 2025 02:14:52 -0500
X-MC-Unique: U-7T_gsNNiuj00amjV2_Jg-1
X-Mimecast-MFC-AGG-ID: U-7T_gsNNiuj00amjV2_Jg_1764918890
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C2D2F1956095;
	Fri,  5 Dec 2025 07:14:49 +0000 (UTC)
Received: from localhost (unknown [10.72.112.128])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 988881800577;
	Fri,  5 Dec 2025 07:14:47 +0000 (UTC)
Date: Fri, 5 Dec 2025 15:14:43 +0800
From: Baoquan He <bhe@redhat.com>
To: Andrey Konovalov <andreyknvl@gmail.com>
Cc: linux-mm@kvack.org, ryabinin.a.a@gmail.com, glider@google.com,
	dvyukov@google.com, vincenzo.frascino@arm.com,
	akpm@linux-foundation.org, kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	elver@google.com, sj@kernel.org, lorenzo.stoakes@oracle.com,
	snovitoll@gmail.com, christophe.leroy@csgroup.eu
Subject: Re: [PATCH v4 00/12] mm/kasan: make kasan=on|off work for all three
 modes
Message-ID: <aTKGYzREbj/6Hwz6@fedora>
References: <20251128033320.1349620-1-bhe@redhat.com>
 <CA+fCnZcVV5=AJUNfy6G2T-UZCbAL=7NivmWkBr6LMSnzzTZ8Kg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+fCnZcVV5=AJUNfy6G2T-UZCbAL=7NivmWkBr6LMSnzzTZ8Kg@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Queue-Id: C9D49C0007
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: dayyzkqhd5kiu4igu35powozxo56ow4o
X-HE-Tag: 1764918896-341970
X-HE-Meta: U2FsdGVkX18vM0JMabpQJg9z9yLn3U6oK0nhkzl6XrKbSIDxGemUX6anaeOeBtjJwXP+8xtjdvcVKvBw8XQ4d24insHpvIuQDW6rbENNBcKJLpItkFL9ZdT1g5Zk2XTsW5USMUAB5T9zFJHd8aOQjqhR0dYvLkJEZ8ayY3OfcQZAFY8/tnqpNs8NHl2RZctKWB3qBjei6h3V3CoT4QGOzgOfDdNWzNRZt9Zxw5n9HMSjh4pwJVvp4N5hoTdBFc33M9+uL6otUvDvauB/Ajlcfvy+DU0CmlxrgoJJwNUhEkO/rnbubzxUZ/pP0kZcjwIF1cBOlItauTp/wUV4DCDwBC11FpErRCyWXT+6dGUqKLLyznga66DpFy7lGkrYnbo8BRSjCxA+cRn2BHiC2nL8N4UEOr9BLrefi2g+urUJ0GiCGppKXGkoFrIH1wGUJ96Cn76qO8su8tcZ0Y3u2tVx0yCe5Of0G0kxK1vLlFIj4yFKdhUJ3n2gxc2q85BZbgezSqHFazhilze0IBwk3Lf755KUG633wGco/y8v8Mh6OwfQyMWe3y3IofYoDk08m2qPX8I5mieFOWaFGMLQgEVGzFHLdSfmrLYy83K9+a+Uhqfmm38Gvw8r3dPQqpzxuDw3I57f5TGlpOdtEHsjIzyOmUidrLQHN5OXLrafNNIYAc6MeozeNuIpsWTD4+AoRnIozbiJ1SBXldxyTxq8XS2cclJq+ONnPyVCmjUHAeKa5H0zt/jfekVarNKdx435g2fZYzkOlUDlGB0i+ochbt2t0egjMaspr73I4UOjv8O4jO0DV+vLOEoD8dROsu1khzN25U8n7UMVbyK6c/yooXp6zQQ/DDY3iMVrkZS9BJEqSWhqZn2EWbMr8i5AxueQuPsAHrZ3Ofsgd+jdBtrL66YoXJ7gn45HFbImDwGb5vbTumzSckfIIwFakvXHJh4fFUL3N5b0DEnC4X3m2Mi5QrP
 IX/KwzdA
 fJ65siR+JB9/y9pFa4SkE+nBaaQGt7ADrZBdrDiRWiF6ByoNkmh5hC/oQAGHslPjiExdv4wP2Vf3EWDJ/i9051Q3wzdx7n27PyGrmFspQs+kAwI9Jcryfv5RxA7e45OlN+mo02MnWRSE4Yxx2LH6S7ztt+vfDaH37kuNSl3+n3WnkLuDe/lmX/haROCMeP5jSca+Fbv/3dsd9yZk0VrV7OmbmseAZHE9YrLLw08AGLjjSmJBCn9HmPulGtMetT7otySZCHxGdzl6LdReCrxIkO2OBZoSDJpMZmWSL3wndCFZwXmb/7kLm69/GvHqPRasDdxaZRmcxdyEjxVK+59RXmm5izlI9jnDqIf4Tg1pZY/622CZJJRJ0aM/Gyls1HPjisLtXY0/f1/rQQt5gSWzZ8GyOpwgFeYfKg2Vk0RvIb12hdk1UA8nHlMbdxPSuPN8/S7GE5QjpfyuOEcqjBJLhlWKms3OT1omkUGKmtycZyc3W/7APqeWaOBhzelR4TNCtFWN2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/04/25 at 05:38pm, Andrey Konovalov wrote:
> On Fri, Nov 28, 2025 at 4:33 AM Baoquan He <bhe@redhat.com> wrote:
> >
> > Currently only hw_tags mode of kasan can be enabled or disabled with
> > kernel parameter kasan=on|off for built kernel. For kasan generic and
> > sw_tags mode, there's no way to disable them once kernel is built.
> >
> > This is not convenient sometime, e.g in system kdump is configured.
> > When the 1st kernel has KASAN enabled and crash triggered to switch to
> > kdump kernel, the generic or sw_tags mode will cost much extra memory
> > while in fact it's meaningless to have kasan in kdump kernel
> >
> > There are two parts of big amount of memory requiring for kasan enabed
> > kernel. One is the direct memory mapping shadow of kasan, which is 1/8
> > of system RAM in generic mode and 1/16 of system RAM in sw_tags mode;
> > the other is the shadow meomry for vmalloc which causes big meomry
> > usage in kdump kernel because of lazy vmap freeing. By introducing
> > "kasan=off|on", if we specify 'kasan=off', the former is avoided by skipping
> > the kasan_init(), and the latter is avoided by not building the vmalloc
> > shadow for vmalloc.
> >
> > So this patchset moves the kasan=on|off out of hw_tags scope and into
> > common code to make it visible in generic and sw_tags mode too. Then we
> > can add kasan=off in kdump kernel to reduce the unneeded meomry cost for
> > kasan.
> >
> > Testing:
> > ========
> > - Testing on x86_64 and arm64 for generic mode passed when kasan=on or
> >   kasan=off.
> >
> > - Testing on arm64 with sw_tags mode passed when kasan=off is set. But
> >   when I tried to test sw_tags on arm64, the system bootup failed. It's
> >   not introduced by my patchset, the original code has the bug. I have
> >   reported it to upstream.
> >   - System is broken in KASAN sw_tags mode during bootup
> >     - https://lore.kernel.org/all/aSXKqJTkZPNskFop@MiWiFi-R3L-srv/T/#u
> 
> This will hopefully be fixed soon, so you'll be able to test.

Great news, thanks for telling. And thanks a lot for careful reviewing.

> 
> >
> > - Haven't found hardware to test hw_tags. If anybody has the system,
> >   please help take a test.
> 
> You don't need hardware to run the HW_TAGS mode, just pass -machine
> virt,mte=on to QEMU.

That's great, I will manage to test it in this way.

> 
> I also wonder if we should keep this kasan=off functionality
> conservative and limit it to x86 and arm64 (since these are the only
> two tested architectures).

We may not need to do that. I tested on arm64 because it has sw_tags and
hw_tags. And if x86_64 and arm64 works well with kasan=off in generic
mode, it should be fine on other architectures. I am a little more
familiar with operations on x86/arm64 than others.  I can manage to get
power system to test kasan=off in generic mode, if that is required.
From my side, I would like to see x86_64/arm64/s390/power to have
kasan=off because RHEL support these architectures. I need consult people
to make clear how to change in s390. Will post patch later or ask other
people to help do that.

While there seems to be no reason we don't let other arch-es have this
benefit if the underlying code has paved the way, the arch side only needs
two lines of judgement code. Personal opinion.

> >
> > Changelog:
> > ====
> > v3->v4:
> > - Rebase code to the latest linux-next/master to make the whole patchset
> >   set on top of
> >   [PATCH 0/2] kasan: cleanups for kasan_enabled() checks
> >   [PATCH v6 0/2] kasan: unify kasan_enabled() and remove arch-specific implementations
> 
> Note that are also:
> 
> [PATCH 1/2] kasan: remove __kasan_save_free_info wrapper
> [PATCH 2/2] kasan: cleanup of kasan_enabled() checks

Right, I saw these two patches, and have rebased code to sit on top of
them. There are some conflicts, I have handled them manually. I only
mentioned the cover-letter one to state the whole patchset.

Sabyrzhan Tasbola [PATCH 0/2] kasan: cleanups for kasan_enabled() checks
Sabyrzhan Tasbola ├─>[PATCH 2/2] kasan: cleanup of kasan_enabled() checks
Sabyrzhan Tasbola └─>[PATCH 1/2] kasan: remove __kasan_save_free_info wrapper

Thanks
Baoquan

> 
> But I don't know if there will be any conflicts with these.
> 
> >
> > v2->v3:
> > - Fix a building error on UML ARCH when CONFIG_KASAN is not set. The
> >   change of fixing is appended into patch patch 11. This is reported
> >   by LKP, thanks to them.
> >
> > v1->v2:
> > - Add __ro_after_init for kasan_arg_disabled, and remove redundant blank
> >   lines in mm/kasan/common.c. Thanks to Marco.
> > - Fix a code bug in <linux/kasan-enabled.h> when CONFIG_KASAN is unset,
> >   this is found out by SeongJae and Lorenzo, and also reported by LKP
> >   report, thanks to them.
> > - Add a missing kasan_enabled() checking in kasan_report(). This will
> >   cause below KASAN report info even though kasan=off is set:
> >      ==================================================================
> >      BUG: KASAN: stack-out-of-bounds in tick_program_event+0x130/0x150
> >      Read of size 4 at addr ffff00005f747778 by task swapper/0/1
> >
> >      CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.16.0+ #8 PREEMPT(voluntary)
> >      Hardware name: GIGABYTE R272-P30-JG/MP32-AR0-JG, BIOS F31n (SCP: 2.10.20220810) 09/30/2022
> >      Call trace:
> >       show_stack+0x30/0x90 (C)
> >       dump_stack_lvl+0x7c/0xa0
> >       print_address_description.constprop.0+0x90/0x310
> >       print_report+0x104/0x1f0
> >       kasan_report+0xc8/0x110
> >       __asan_report_load4_noabort+0x20/0x30
> >       tick_program_event+0x130/0x150
> >       ......snip...
> >      ==================================================================
> >
> > - Add jump_label_init() calling before kasan_init() in setup_arch() in these
> >   architectures: xtensa, arm. Because they currenly rely on
> >   jump_label_init() in main() which is a little late. Then the early static
> >   key kasan_flag_enabled in kasan_init() won't work.
> >
> > - In UML architecture, change to enable kasan_flag_enabled in arch_mm_preinit()
> >   because kasan_init() is enabled before main(), there's no chance to operate
> >   on static key in kasan_init().
> >
> > Baoquan He (12):
> >   mm/kasan: add conditional checks in functions to return directly if
> >     kasan is disabled
> >   mm/kasan: move kasan= code to common place
> >   mm/kasan/sw_tags: don't initialize kasan if it's disabled
> >   arch/arm: don't initialize kasan if it's disabled
> >   arch/arm64: don't initialize kasan if it's disabled
> >   arch/loongarch: don't initialize kasan if it's disabled
> >   arch/powerpc: don't initialize kasan if it's disabled
> >   arch/riscv: don't initialize kasan if it's disabled
> >   arch/x86: don't initialize kasan if it's disabled
> >   arch/xtensa: don't initialize kasan if it's disabled
> >   arch/um: don't initialize kasan if it's disabled
> >   mm/kasan: make kasan=on|off take effect for all three modes
> >
> >  arch/arm/kernel/setup.c                |  6 ++++++
> >  arch/arm/mm/kasan_init.c               |  2 ++
> >  arch/arm64/mm/kasan_init.c             |  6 ++++++
> >  arch/loongarch/mm/kasan_init.c         |  2 ++
> >  arch/powerpc/mm/kasan/init_32.c        |  5 ++++-
> >  arch/powerpc/mm/kasan/init_book3e_64.c |  3 +++
> >  arch/powerpc/mm/kasan/init_book3s_64.c |  3 +++
> >  arch/riscv/mm/kasan_init.c             |  3 +++
> >  arch/um/kernel/mem.c                   |  5 ++++-
> >  arch/x86/mm/kasan_init_64.c            |  3 +++
> >  arch/xtensa/kernel/setup.c             |  1 +
> >  arch/xtensa/mm/kasan_init.c            |  3 +++
> >  include/linux/kasan-enabled.h          |  6 ++++--
> >  mm/kasan/common.c                      | 20 ++++++++++++++++--
> >  mm/kasan/generic.c                     | 17 ++++++++++++++--
> >  mm/kasan/hw_tags.c                     | 28 ++------------------------
> >  mm/kasan/init.c                        |  6 ++++++
> >  mm/kasan/quarantine.c                  |  3 +++
> >  mm/kasan/report.c                      |  4 +++-
> >  mm/kasan/shadow.c                      | 11 +++++++++-
> >  mm/kasan/sw_tags.c                     |  6 ++++++
> >  21 files changed, 107 insertions(+), 36 deletions(-)
> 
> One part that's still missing is a Documentation change.
> 
> 
> >
> > --
> > 2.41.0
> >
> 


