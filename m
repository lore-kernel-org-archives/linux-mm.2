Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C86FCC87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 13:34:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62A688E013F; Tue, 12 Aug 2025 09:34:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58C0A8E00E5; Tue, 12 Aug 2025 09:34:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47ADC8E013F; Tue, 12 Aug 2025 09:34:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 33C418E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 09:34:16 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D7E221167D9
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:34:15 +0000 (UTC)
X-FDA: 83768199270.01.A3B4082
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id EB87216000C
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:34:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SiWpAanX;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755005654; a=rsa-sha256;
	cv=none;
	b=S7Wl+Er5MLgMIUUALNj8G1F3P9NDQyFxElRBXH9B5L3peFnXe3AS3h0Vdi+fbiahWKOuSG
	riIy1aQeAGg8bCB4TMwT6Cjl0+sL5iC36svSY0ks06UuR7Et0NvhshyJKYIVg+QCOEX1Kb
	Ioh2H9utZk+6u3IRPZRplg85XSDV4Cw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SiWpAanX;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755005654;
	h=from:from:sender:reply-to:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=SyGio/OeA3YMlzqg5t7NCMACn4NnFGBQQvjFkUaqSpQ=;
	b=2Xd0WEvZyxRd02J4OsbokYQF9W4o0liNBAzPHcpgPiiKakQufbtTqWkbOx5v8wkyOdFKyM
	AIEWqvZO0y3XWg9YFkmEMFJnuJ5MQomAwxe96DicC8GKydD5s8rHVNwX7CcTalurqEdmSn
	QD/LZo2Fz+P4fuc2a7p1IIBLUWuGh5s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755005653;
	h=from:from:reply-to:subject:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type;
	bh=SyGio/OeA3YMlzqg5t7NCMACn4NnFGBQQvjFkUaqSpQ=;
	b=SiWpAanXLIVG4uaTEtZopD9pgHuFfxLt6FbVrJ9UHyAH6tV/hVnveNtE/P+Z6LD/3bdIki
	NfLYOIcUYkBoLuEUaO1auE+6nkUfKv0s9XQLlirG7u/WSgZz9omrpXRaFRvcgY+B+QUXDa
	lGw6xt1rggv4D7DQQbDpPNc0bLtBwn4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-619-1XAP1QBxMDm8VyzuVDE8yw-1; Tue,
 12 Aug 2025 09:34:10 -0400
X-MC-Unique: 1XAP1QBxMDm8VyzuVDE8yw-1
X-Mimecast-MFC-AGG-ID: 1XAP1QBxMDm8VyzuVDE8yw_1755005649
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2828E19560B7;
	Tue, 12 Aug 2025 13:34:09 +0000 (UTC)
Received: from localhost (unknown [10.72.112.156])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F0839180028A;
	Tue, 12 Aug 2025 13:34:07 +0000 (UTC)
Date: Tue, 12 Aug 2025 21:34:03 +0800
From: Baoquan He <bhe@redhat.com>
To: linux-mm@kvack.org, christophe.leroy@csgroup.eu
Message-ID: <aJtCy5dUInygEaTm@MiWiFi-R3L-srv>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: potuXXmNnr1ds7C8tmjxgKwVC9AE5Zll_7OkSDfAO10_1755005649
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EB87216000C
X-Stat-Signature: nctu7hd1ggectdbmiudq7s8mzst164g1
X-Rspam-User: 
X-HE-Tag: 1755005653-286492
X-HE-Meta: U2FsdGVkX1+s3fd9MvFWs19gHw+OKlm55DVAvzCaK5s59vowGsSlhIDA1UVVCgGmiTijHDcKPrHysERZ16jHpM3USBHigvyeoVK7XcdSAjcyqNCNH3zvhH0EfMrMQorHkb7vPvMO4iaD12P2k13N5z0iWZwAbckgaK5N1YKwkYHGPUlV/KTcpR7hHdmwk78EXpl8rN/J3zPp2yvd0iVjhkM03lJFCV8KDUAuk8em9dUnhvXcJYlnvFasYepO10Y7IVyK5NUXw72fJdGWsW2qM95jNaRkS/1Vw+FJknE3vTdicNYhKhng3US8KOQ2VLGwi/4/nSyrA46rSwsvoMM1WpqSK1vql0f0/PNN5j1HboPwnXgjMfNy+kdWFosaEJxx1m08652eGSiml8N2VU2gr8ZB4Q2xq+Okap5leKQ3jlLrdfO1XUg7kw1w244a2Vb8Xrw7CrRpjj9OXwRH/3D7dyYv5bz8sIt3s5Dd6zPhap0B1/yAazSV+jJLblfsbO/pDcLf8bfhiVosRCR8Re8+ebOzIqUDWCuCV8FAqbv6TTh3IqAf+4GnGSiteP9wBNv0DV0Zw8gq1rGtClgrspOPdaE+qncsS9luI19ypSNKgHowGbZvzLw72X1nSR1RuAZfumwFsKBZyaRjmVhRZzg2FeSme2l1HGibdSm1XwNGPhgjsCDLfrVqTBB1X4K2W6vZT9iS86Usf7HNc1udZcy4/APDxDvIaiUHKCZvsfZ4IB3rc6VWgL2VmfAsjdHoQYUIA1SG7ICwbiwskxPtiPdZjsLLPNLHpFfXjCql1pDwT/yzIgTy+mL/QtPXWers2/xFD7qlIJJCGk7AUVYWkIRzsO3jBpzclUQVUa4lhuFoZVFwgZLGQHkg9BFdhM+oJ2zyxjJNu4zc64CAsU3+rsAy0Kb/FdEjMV/yVkOiHxhMvLnLD/NTLjPxd6yx2H9FR4VRHycrSsEPncKR2QbzHUz
 3TQ49LGg
 pRANhL5XAH3f+FsS6yXrxYUFRznv9PtwnK5iQgXYUhptNAiaOeSSbMixujhu2vNUZ6IkgTzisLPO3X6JnrIuOU13XDFtXUqIsvrGYkRJjNYycutc2rzkZlejEtptnHSg733nGn2F5Vb8xF8D1AQnDatbcsljE24RTqC1/gdmzj83VHaY3fOs4ke8bqwIZaYGpFQxFDLFkhbjAFDyYUnPAFA7nq1JA6vKXmVtwDjzswUMQsl6HKrxG1Jfb/hmsOdggWWWf9Zi9b2lAL8LBE5rp68YhVc2p2X8/788gIY07y/my1yF/e697Kw6nXu3+PIPZLS88N2OEZ7kW/NvWFbsMyqsiW9D1NkjlGbUViSJLV9NPPZlTOCj731fqh2xWMhIwAMGEAo8cL9PXrCfW2+kwSobx+UHDL+p/zfF4BhnWWTRdN6pnXVlTY99pL1fHgzBufq6di6IHZGKe+Em2EYZDPvgwiY3Ugaufc4o5+wdfgzmskRH/qvDo66wFtbL6yuS/qiOq8yOe3tuIJrUNYZbmQAATVpe4blBWH0un6WrM+f4z+E65j9xonXwMrw77QckM+VCCKOwazb+sEAl4MWRtuejQ9IvjC2tcV8UZs8svCSpwF2IIcnmlPH8xvHXhHEqBMdO2JvKsSU5V+XEzcTu98IMCrkp8drNqv6grPPYrU8/bevT3PT0pyEvL6NJm++Au9/cf76ZVOyhiStf3pOvyFCrahGwuuUgkBec1doscBMl1d7Edcs32mLVi3+4Oa0Us+nmHkmqLMSuIrRcWnxm16YA/CKcmgPF5yNWQAUdjagT4iApG0ldp2Oi2Q0QtCi3lI0PPIvqXR0atUQoooFFQ0haP/cBhWRyQawZoZkZ9If1M/HxBk8Q7lsjpgE29YL7hbWmVWQloG+plqro3Y02hwbPbPW0YTpu/wclt53WmPjdpOZbuSt4S7sMigsec8FI/HsBV5LqtQ7i9yaY4eIb8bOIN5Fo2
 eQfJdmFh
 4Zs+YX2ceoaTCB5hPnj/vF4JHe9uKASYjiVsl2BGcbtFwVpH/wjQkw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

alexghiti@rivosinc.com, agordeev@linux.ibm.com, linux@armlinux.org.uk,
linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
x86@kernel.org, chris@zankel.net, jcmvbkbc@gmail.com, linux-um@lists.infradead.org
Cc: ryabinin.a.a@gmail.com, glider@google.com, andreyknvl@gmail.com,
	dvyukov@google.com, vincenzo.frascino@arm.com,
	akpm@linux-foundation.org, kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	sj@kernel.org, lorenzo.stoakes@oracle.com, elver@google.com,
	snovitoll@gmail.com
Bcc: bhe@redhat.com
Subject: Re: [PATCH v2 00/12] mm/kasan: make kasan=on|off work for all three
 modes
Reply-To: 
In-Reply-To: <20250812124941.69508-1-bhe@redhat.com>

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


