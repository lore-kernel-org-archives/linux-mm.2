Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DA53C87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 13:50:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 319548E0143; Tue, 12 Aug 2025 09:50:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F0F98E00E5; Tue, 12 Aug 2025 09:50:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22D518E0143; Tue, 12 Aug 2025 09:50:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 13D318E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 09:50:09 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D5EE3B8724
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:50:08 +0000 (UTC)
X-FDA: 83768239296.04.5764D88
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 02B59120016
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:50:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZtPtF1h2;
	spf=pass (imf29.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755006607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7pWBagC7Ig/tlciZiJQpRGrExscBjDccFXj5IsrHvfE=;
	b=e/vQCPFZjEqONC3WlqayTa+N90zGtClMa32KGImvS8/OCP5VXiUo9vyl4EVZMdoxVJS/ua
	zle8EDBnCTcPB/JWMqNPgO0hmMPmhRXLdE5SPovFkB0d4MQvwAedmR0wvRoeJl/py37eJX
	ifceYOgEJ/wP6ASQin/fTwCsEkeF91U=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZtPtF1h2;
	spf=pass (imf29.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755006607; a=rsa-sha256;
	cv=none;
	b=aZWiNAf3g9fjR6swUeFW0wdoabP05DRG5iHQ0dJJ+Rjqi9OUeWR6Igs5jhIrCb24X+OUiT
	omC5z7eLIeuV4u4P7QhhFR22wE4y5jNxXy+yRCapYaBwmYj8Q2B4fGR8WBnpOkbG1JUVvQ
	lSbEB0NqRGnzk8CP4AZSYrBC3Sd+ukE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755006606;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7pWBagC7Ig/tlciZiJQpRGrExscBjDccFXj5IsrHvfE=;
	b=ZtPtF1h2kBTkuOt3uK+x/2piTs/llvtobpc6L6HlQihu3rqnOaGPxQOSImjuaZI5cpkHoi
	f2b67dklMrNcL/f++AOXwXWAkaKSpJs5nNE5A7SJtljfihLBQVIHTRvNFZL1UAHCEcZUwk
	j/qIAPIYeNvTksJ8IYzoiIwSV4h6VQY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-283-WdrmRywjMxKaed8Arjedpw-1; Tue,
 12 Aug 2025 09:50:04 -0400
X-MC-Unique: WdrmRywjMxKaed8Arjedpw-1
X-Mimecast-MFC-AGG-ID: WdrmRywjMxKaed8Arjedpw_1755006604
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0EAE81956061;
	Tue, 12 Aug 2025 13:50:04 +0000 (UTC)
Received: from localhost (unknown [10.72.112.156])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D57EC19560B5;
	Tue, 12 Aug 2025 13:50:02 +0000 (UTC)
Date: Tue, 12 Aug 2025 21:49:58 +0800
From: Baoquan He <bhe@redhat.com>
To: linux-mm@kvack.org, christophe.leroy@csgroup.eu
Subject: Re:
Message-ID: <aJtGhuNap6Q+JjF9@MiWiFi-R3L-srv>
References: <aJtCy5dUInygEaTm@MiWiFi-R3L-srv>
MIME-Version: 1.0
In-Reply-To: <aJtCy5dUInygEaTm@MiWiFi-R3L-srv>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: R0DYngiBqESBqCT37OTed0HP-dD6OP2ggf-hhG8KDJM_1755006604
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 02B59120016
X-Rspam-User: 
X-Stat-Signature: d9ujiet1x883gi7349ihub87sgbz6xze
X-Rspamd-Server: rspam09
X-HE-Tag: 1755006606-734502
X-HE-Meta: U2FsdGVkX19H81krf4lnOu9wqSEwNvBNmla9NIrOGnsb3vEI1c20SXghR/D9K0HOT/Alo8e6xplxLOkd268ill47fNLSJprQXciC6KMMoQWULidSLGvNnr8QYKGmpk55+k+eXfxnYxvlgUDbGVjQswBFb4g4CRTICqnuwrw8SucVGlI4GItQPy/jA0fNjUUzdvYZykxgQfpXuXfKmVTgCWBqCU3y6rhEViCN5qIceyitNkuvECBaOaGBSU5i0ytHHctV6N9RPtAGAw+AgDaR5qnb+a/Lp+PTIMFIMn8XC1S+vw6KN7MJtqZAoNqOW/zVaRw4+zbBmgBe9k6AfHzb3LzAUqPEcRMj2yUwQiwdUbibh6LzwLV8ThI9JZpvdnZiTTiwuw8ybtTl5ZUuNtbAErEOdHb197Ck09hdfFut0/WqVOKylZal06Y1Ky2GPo0/3bfVvhb+MhR4OhGmlzzINe3LRIIqnyBzsh9fQUHWKpF2An0XlFyxbC+L2b5bEypCGPbHthmX3cn8VWK9zZ7P+i8wvL7oRh8wMOQaIG9YvXad105K2b1cgRZZ5fQaLsBHHd/lxWmVWyb6rsaPTF7smuyh/CYwmxMjovzRx8i031sWhhF7i8X70S8gAxwqYYBLNCTDcZhaps4Ihr42g8uhrC/0wo7S4P9TjcdvFU54l1rUYWuEt0dZqElJjSWkn3u8wg57EVJoBTR2rsezDvMd/k2rMda1SU1/lm5YNagwnGBHzZwTXtNcLyNPtTzpE/0zqQsOJobsNwT5ySIJTBLiZauHi7WBuUeG+GzyU1eATNvML+ZKtRr9FXMd+ctdGbMlNTSjKFjEvgKc6K8YUCdPGQ1vARQXxxZJ5AQHy9xFHdI6CxlqaBTHMoRLhJGvXmt/vhGAjUYvWgkY4NksoxN+WHk34t+InabeoCCLwwT+uGTf+Y7ZQRkyk0k/7h1njpFCrpdz8MRkl/v9huCvnqJ
 njddGC78
 ZM/rZ/yeHt9iKX/E82VLDoY7gIR02Xta4O/IrQl/p8fBfB5QJSXbg85J0YaPFPSYuTOFfL8lsrD5E/6rr8iok7ied5CH5+RKavGRO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/12/25 at 09:34pm, Baoquan He wrote:
> alexghiti@rivosinc.com, agordeev@linux.ibm.com, linux@armlinux.org.uk,
> linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
> linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
> x86@kernel.org, chris@zankel.net, jcmvbkbc@gmail.com, linux-um@lists.infradead.org
> Cc: ryabinin.a.a@gmail.com, glider@google.com, andreyknvl@gmail.com,
> 	dvyukov@google.com, vincenzo.frascino@arm.com,
> 	akpm@linux-foundation.org, kasan-dev@googlegroups.com,
> 	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
> 	sj@kernel.org, lorenzo.stoakes@oracle.com, elver@google.com,
> 	snovitoll@gmail.com
> Bcc: bhe@redhat.com
> Subject: Re: [PATCH v2 00/12] mm/kasan: make kasan=on|off work for all three
>  modes
> Reply-To: 
> In-Reply-To: <20250812124941.69508-1-bhe@redhat.com>
> 
> Forgot adding related ARCH mailing list or people to CC, add them.

Sorry for the noise, I made mistake on mail format when adding people to
CC.

> 
> On 08/12/25 at 08:49pm, Baoquan He wrote:
> > Currently only hw_tags mode of kasan can be enabled or disabled with
> > kernel parameter kasan=on|off for built kernel. For kasan generic and
> > sw_tags mode, there's no way to disable them once kernel is built.
> > This is not convenient sometime, e.g in system kdump is configured.
> > When the 1st kernel has KASAN enabled and crash triggered to switch to
> > kdump kernel, the generic or sw_tags mode will cost much extra memory
> > for kasan shadow while in fact it's meaningless to have kasan in kdump
> > kernel.
> > 
> > So this patchset moves the kasan=on|off out of hw_tags scope and into
> > common code to make it visible in generic and sw_tags mode too. Then we
> > can add kasan=off in kdump kernel to reduce the unneeded meomry cost for
> > kasan.
> > 
> > Changelog:
> > ====
> > v1->v2:
> > - Add __ro_after_init for __ro_after_init, and remove redundant blank
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
> > Test:
> > =====
> > In v1, I took test on x86_64 for generic mode, and on arm64 for
> > generic, sw_tags and hw_tags mode. All of them works well.
> > 
> > In v2, I only tested on arm64 for generic, sw_tags and hw_tags mode, it
> > works. For powerpc, I got a BOOK3S/64 machine, while it says
> > 'KASAN not enabled as it requires radix' and KASAN is disabled. Will
> > look for other POWER machine to test this.
> > ====
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
> >  arch/arm/kernel/setup.c                |  6 +++++
> >  arch/arm/mm/kasan_init.c               |  6 +++++
> >  arch/arm64/mm/kasan_init.c             |  7 ++++++
> >  arch/loongarch/mm/kasan_init.c         |  5 ++++
> >  arch/powerpc/mm/kasan/init_32.c        |  8 +++++-
> >  arch/powerpc/mm/kasan/init_book3e_64.c |  6 +++++
> >  arch/powerpc/mm/kasan/init_book3s_64.c |  6 +++++
> >  arch/riscv/mm/kasan_init.c             |  6 +++++
> >  arch/um/kernel/mem.c                   |  6 +++++
> >  arch/x86/mm/kasan_init_64.c            |  6 +++++
> >  arch/xtensa/kernel/setup.c             |  1 +
> >  arch/xtensa/mm/kasan_init.c            |  6 +++++
> >  include/linux/kasan-enabled.h          | 18 ++++++-------
> >  mm/kasan/common.c                      | 25 ++++++++++++++++++
> >  mm/kasan/generic.c                     | 20 +++++++++++++--
> >  mm/kasan/hw_tags.c                     | 35 ++------------------------
> >  mm/kasan/init.c                        |  6 +++++
> >  mm/kasan/quarantine.c                  |  3 +++
> >  mm/kasan/report.c                      |  4 ++-
> >  mm/kasan/shadow.c                      | 23 ++++++++++++++++-
> >  mm/kasan/sw_tags.c                     |  9 +++++++
> >  21 files changed, 165 insertions(+), 47 deletions(-)
> > 
> > -- 
> > 2.41.0
> > 
> 
> 


