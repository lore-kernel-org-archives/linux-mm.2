Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5499C87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 13:39:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60E038E0141; Tue, 12 Aug 2025 09:39:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BE448E00E5; Tue, 12 Aug 2025 09:39:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AD2F8E0141; Tue, 12 Aug 2025 09:39:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 34FA38E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 09:39:30 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E3E25B85F4
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:39:29 +0000 (UTC)
X-FDA: 83768212458.25.B332A00
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0343714000C
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:39:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CSbN2h0f;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755005968; a=rsa-sha256;
	cv=none;
	b=kvy7Qagfwds9omeS9fUnNNL4x6PqxqbtRE8fDlMXyLrpMgVKvEozf64cVB4aHpLO+gn9GP
	XyMQO/+CIJ1ZJnP576101+bjo4hgOKmY1AZMH3r/AavxkkVqcMJmVwpdu++0BjtlTHZBC4
	+CntWkAAJWtm33Hy56EvUmaFelRg8K0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CSbN2h0f;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755005968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DxjcecEI7phcRYjWyLkZSnGEJwCBjNTRZZccT/msDU8=;
	b=B1xJ8sCHlB2aqIRp3zN/63Rf6hBf3qslBysm9rYuoVpIZPLSvklHwRaZZ563paZScZmJXb
	L/ADqi6oE9FgMAmkpYAsgvs3Apa6iuS+rKTHSG+ZeYi7e7/rdWNdTTbWaUzxfIeK4iV7wb
	OTK9F/bHkNm/PBUS6h0NOrQAKTLmJpM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755005967;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DxjcecEI7phcRYjWyLkZSnGEJwCBjNTRZZccT/msDU8=;
	b=CSbN2h0fI9Kos09cBO41J8Qz4DVKdz+JQ27gZuMLeGKKbJ/JNzqUj+WpZe5rNGKohK52yi
	owFJFj61YYDKUJncYXm8+z3YYOAwAsSqTAHlJ9q7035Pw+LgwW99CKA3/63or1wRs2kzdM
	8fv4iOhMbIdQQ/9I34TY/NVOC3idF88=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-553-FY5fxrhNOyqPzbOI5L33kw-1; Tue,
 12 Aug 2025 09:39:22 -0400
X-MC-Unique: FY5fxrhNOyqPzbOI5L33kw-1
X-Mimecast-MFC-AGG-ID: FY5fxrhNOyqPzbOI5L33kw_1755005958
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5149919560B3;
	Tue, 12 Aug 2025 13:39:17 +0000 (UTC)
Received: from localhost (unknown [10.72.112.156])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7F8A819560AB;
	Tue, 12 Aug 2025 13:39:15 +0000 (UTC)
Date: Tue, 12 Aug 2025 21:39:11 +0800
From: Baoquan He <bhe@redhat.com>
To: linux-mm@kvack.org, alexghiti@rivosinc.com, agordeev@linux.ibm.com,
	linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org,
	loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org, christophe.leroy@csgroup.eu,
	x86@kernel.org, chris@zankel.net, jcmvbkbc@gmail.com,
	linux-um@lists.infradead.org
Cc: ryabinin.a.a@gmail.com, glider@google.com, andreyknvl@gmail.com,
	dvyukov@google.com, vincenzo.frascino@arm.com,
	akpm@linux-foundation.org, kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	sj@kernel.org, lorenzo.stoakes@oracle.com, elver@google.com,
	snovitoll@gmail.com
Subject: Re: [PATCH v2 00/12] mm/kasan: make kasan=on|off work for all three
 modes
Message-ID: <aJtD/8beAEHtm2/6@MiWiFi-R3L-srv>
References: <20250812124941.69508-1-bhe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250812124941.69508-1-bhe@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0343714000C
X-Stat-Signature: bb5q9itho6pnfqyd8us5fbb81quts93u
X-Rspam-User: 
X-HE-Tag: 1755005967-190226
X-HE-Meta: U2FsdGVkX1/rKoVt0lBVJtJxMRqsg0TFQSxGqxxpIZ7AEi0uljZqVE1WxHmBhBzeeYuVwB2KPXRWtTKrssiXUDG+rOuhtmiANXBx0JHs8z9E1rh+3hMTsAqkjkzU3Z35q4f4mlzWy576TnFW1GAys1CY8AEzBDBRJgjZL0fNjBWtrE9WZM4fo1jWS1tlZ5okZ0NxlqeXUOvkyVPRF2/deYer95OTUEgYcYFRZpsbNWQ/5JGKs3EWm5hCEVADKzaINGE08QPT6foQb2UG1366althO208k3RL6FmiKy2OvJ90mh39lloKjotd6FI7Krg1/CM9fEgr1iV5kZ+7obLcm+LQlg8Yjoo32SXbRcISdWSJ0S9yYPwxYhxxn1TSq2IJQTyHYxcL73dTLm5MvsEUSZUUpOO25WQnv8YpNICDFyTPJILw2Z3b9B/rInehXBDUz3UK7kMxVp7yYAMeNTyaVhHNpdoH6ymd1etnL+EbKfibJfsrs47UIWjQ63USZaX2cSXhBK3tL4OCRQol9UMIMkQrUl1Ehw2i+8qn7C/2MIcouLtEqUZi+VGgDTP2AzB96jDriUNtQNi+JXRwa+hKTJ1ry1aSxg70dbj8+CBkopw17Ayb4XMPmiKySUcyd+NFHooYq1gyEz1rJmVB2DyXaQcKVBHyY9Kbbu7biA4vQbQvya3sy6QwIz0r1umD+9r9Z367abUMJq8/DLsar/BjgkJcMhZjedW5QBGpzTmxwRv8FSLdUI4DqAKhNjlYEj7+4NmXfaN5JB8KEwuFbIndw41UzzOK7GLdwgKPUt7oUHjlsVA2PHZiqt0TO1FClxD8YcpMt4heSpdROH3Ci8wqAyzLB1u0E26uA9pieqg6ISPDtqSuzSe/t9+ol20pKIUxDoMIfiXidQ+WC4Sgptcu/iEgYc7sCCysWHX+IqhxhfXtXxuIZE1W+BIq6NmcOp3rptLK4WiaOePuTxOX08M
 oJJmDtS7
 tjDOkRtzDuVWVXBn9q58CK+vIQa1PF1uR7JXZOX9JcO3n0XGCahYH7DXNvKG1Z+mrxksDpRrDNdtcSOvqV0dN1/XnETBgGmzi/sQX/WLbzvfU6vTAHLBjfkURBKsSqI0XQadL7oSI7WTK1EGsxj7pswg911hzpxZzg11LLhi/Caad/PDDN45fl+F58s7ANzGNZsUcM73YqVj+IZyza1GTqyHixqltE+SuFx1rC0odH72gMRsfLdhaOMBvhgr8HE4R+A9AsVpZWkmYkHXJxaeBrNWOiCJkERZKBVTe413SwUXxhqC6GO/ZX7ZcDvqsmGU2yFCtxFHYsfVlKWMPXnHra3ZdxWwgeqTnpwN3LTtPadPMuQNL12Bo3uDcDYco5m2oarTNHoCaCxFsLexih7sxMFS3kzq9lT/+9j5tU3jzNW105B2+C66knAcOUvgU+AkEtASt2lOrCVsod4F6KOjHCIGHSByaa1yLG/sI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forgot adding related ARCH mailing list or people to CC, add them.

On 08/12/25 at 08:49pm, Baoquan He wrote:
> Currently only hw_tags mode of kasan can be enabled or disabled with
> kernel parameter kasan=on|off for built kernel. For kasan generic and
> sw_tags mode, there's no way to disable them once kernel is built.
> This is not convenient sometime, e.g in system kdump is configured.
> When the 1st kernel has KASAN enabled and crash triggered to switch to
> kdump kernel, the generic or sw_tags mode will cost much extra memory
> for kasan shadow while in fact it's meaningless to have kasan in kdump
> kernel.
> 
> So this patchset moves the kasan=on|off out of hw_tags scope and into
> common code to make it visible in generic and sw_tags mode too. Then we
> can add kasan=off in kdump kernel to reduce the unneeded meomry cost for
> kasan.
> 
> Changelog:
> ====
> v1->v2:
> - Add __ro_after_init for __ro_after_init, and remove redundant blank
>   lines in mm/kasan/common.c. Thanks to Marco.
> - Fix a code bug in <linux/kasan-enabled.h> when CONFIG_KASAN is unset,
>   this is found out by SeongJae and Lorenzo, and also reported by LKP
>   report, thanks to them.
> - Add a missing kasan_enabled() checking in kasan_report(). This will
>   cause below KASAN report info even though kasan=off is set:
>      ==================================================================
>      BUG: KASAN: stack-out-of-bounds in tick_program_event+0x130/0x150
>      Read of size 4 at addr ffff00005f747778 by task swapper/0/1
>      
>      CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.16.0+ #8 PREEMPT(voluntary) 
>      Hardware name: GIGABYTE R272-P30-JG/MP32-AR0-JG, BIOS F31n (SCP: 2.10.20220810) 09/30/2022
>      Call trace:
>       show_stack+0x30/0x90 (C)
>       dump_stack_lvl+0x7c/0xa0
>       print_address_description.constprop.0+0x90/0x310
>       print_report+0x104/0x1f0
>       kasan_report+0xc8/0x110
>       __asan_report_load4_noabort+0x20/0x30
>       tick_program_event+0x130/0x150
>       ......snip...
>      ==================================================================
> 
> - Add jump_label_init() calling before kasan_init() in setup_arch() in these
>   architectures: xtensa, arm. Because they currenly rely on
>   jump_label_init() in main() which is a little late. Then the early static
>   key kasan_flag_enabled in kasan_init() won't work.
> 
> - In UML architecture, change to enable kasan_flag_enabled in arch_mm_preinit()
>   because kasan_init() is enabled before main(), there's no chance to operate
>   on static key in kasan_init().
> 
> Test:
> =====
> In v1, I took test on x86_64 for generic mode, and on arm64 for
> generic, sw_tags and hw_tags mode. All of them works well.
> 
> In v2, I only tested on arm64 for generic, sw_tags and hw_tags mode, it
> works. For powerpc, I got a BOOK3S/64 machine, while it says
> 'KASAN not enabled as it requires radix' and KASAN is disabled. Will
> look for other POWER machine to test this.
> ====
> 
> Baoquan He (12):
>   mm/kasan: add conditional checks in functions to return directly if
>     kasan is disabled
>   mm/kasan: move kasan= code to common place
>   mm/kasan/sw_tags: don't initialize kasan if it's disabled
>   arch/arm: don't initialize kasan if it's disabled
>   arch/arm64: don't initialize kasan if it's disabled
>   arch/loongarch: don't initialize kasan if it's disabled
>   arch/powerpc: don't initialize kasan if it's disabled
>   arch/riscv: don't initialize kasan if it's disabled
>   arch/x86: don't initialize kasan if it's disabled
>   arch/xtensa: don't initialize kasan if it's disabled
>   arch/um: don't initialize kasan if it's disabled
>   mm/kasan: make kasan=on|off take effect for all three modes
> 
>  arch/arm/kernel/setup.c                |  6 +++++
>  arch/arm/mm/kasan_init.c               |  6 +++++
>  arch/arm64/mm/kasan_init.c             |  7 ++++++
>  arch/loongarch/mm/kasan_init.c         |  5 ++++
>  arch/powerpc/mm/kasan/init_32.c        |  8 +++++-
>  arch/powerpc/mm/kasan/init_book3e_64.c |  6 +++++
>  arch/powerpc/mm/kasan/init_book3s_64.c |  6 +++++
>  arch/riscv/mm/kasan_init.c             |  6 +++++
>  arch/um/kernel/mem.c                   |  6 +++++
>  arch/x86/mm/kasan_init_64.c            |  6 +++++
>  arch/xtensa/kernel/setup.c             |  1 +
>  arch/xtensa/mm/kasan_init.c            |  6 +++++
>  include/linux/kasan-enabled.h          | 18 ++++++-------
>  mm/kasan/common.c                      | 25 ++++++++++++++++++
>  mm/kasan/generic.c                     | 20 +++++++++++++--
>  mm/kasan/hw_tags.c                     | 35 ++------------------------
>  mm/kasan/init.c                        |  6 +++++
>  mm/kasan/quarantine.c                  |  3 +++
>  mm/kasan/report.c                      |  4 ++-
>  mm/kasan/shadow.c                      | 23 ++++++++++++++++-
>  mm/kasan/sw_tags.c                     |  9 +++++++
>  21 files changed, 165 insertions(+), 47 deletions(-)
> 
> -- 
> 2.41.0
> 


