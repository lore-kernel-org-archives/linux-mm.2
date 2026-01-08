Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBA2DD1D483
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 17:56:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C2CF6B0089; Thu,  8 Jan 2026 12:56:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 379B66B0095; Thu,  8 Jan 2026 12:56:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B0576B0099; Thu,  8 Jan 2026 12:56:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 172736B0089
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 12:56:50 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B959B1AA7B9
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:56:49 +0000 (UTC)
X-FDA: 84309552138.17.89ED53B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 568D340007
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:56:48 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a+78jq3R;
	spf=pass (imf27.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767895008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OODmGsMJR8KkWVIwL3oduI42mZW6JkdE7mQV95TGWGk=;
	b=MMxvSCymGoD2IGTJVIhPiZM7dAoB9HDbNNp/oWUcbVwzsq3bLMA6NrWlE1ma7zQwZtS1se
	H73Ubcy+y9kZAPAfAJlj3uTcqU7usldp7zY4rbrGXf8n+NYH1LpP8+FIGSAhqfCcIRjxID
	kpyVIlNGnDLvfWRUSXConnyk7v39b9w=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a+78jq3R;
	spf=pass (imf27.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767895008; a=rsa-sha256;
	cv=none;
	b=CWWybYdnJkmTBn8N87Ti7brkFJqtNoLSZsiQTtL5V2coSsPwSROLnB1fUOY97x2HR4KxoJ
	HGXcE9peOv0Z05zJcOulXtLyDkqBrWmZj5YhUp4mTp87LLSaFCovAMChU5zOz7TmCvuLZY
	zfZaKE01B+WUYrxZp5Ub4zzS5w9Scas=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 82EAF60132;
	Thu,  8 Jan 2026 17:56:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BEA0C116C6;
	Thu,  8 Jan 2026 17:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767895007;
	bh=w/QLun24lbtHii2xsaLuuKpk/iaodRrWwMtJGRI8v2Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a+78jq3RqBJgK4cIrQuLNVR/+PIoAzqHbdf1iJY5WrJNo1abFBr86lp4LW7IGujGf
	 7NqmWKUeZDNHD5CG29NJ8TnXtEDD/YyH6zzywPW+6zBaBftYsQuaXGDGXtkKEk7sWO
	 9o4sWunISQpCrz9w2ezuPrfH2AePhh/IrwnTiO9mcmYROnjVcOiGQI7YOyAvL7ajlt
	 YLw5m6RuGa388VqebBzQgZYooFD7zqe7IlVWUTG5oCyQVlrF+HhJGN4xunCJpJfXgT
	 EYED+MQWHyIxG79yg9HHk7Xg/Nlv3hD2u+6bmmAqHVmdKA07TfrmlQkHUOW0HbWio4
	 IK2OvPsjiBVmA==
Date: Thu, 8 Jan 2026 17:56:39 +0000
From: Will Deacon <will@kernel.org>
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH v7 02/15] kasan: arm64: x86: Make special tags arch
 specific
Message-ID: <aV_v18YWCHXMETVK@willie-the-truck>
References: <cover.1765386422.git.m.wieczorretman@pm.me>
 <0db7ec3b1a813b4d9e3aa8648b3c212166a248b7.1765386422.git.m.wieczorretman@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0db7ec3b1a813b4d9e3aa8648b3c212166a248b7.1765386422.git.m.wieczorretman@pm.me>
X-Rspam-User: 
X-Stat-Signature: 61d7fnfo87artr9sd14dff1urijumjpx
X-Rspamd-Queue-Id: 568D340007
X-Rspamd-Server: rspam04
X-HE-Tag: 1767895008-728754
X-HE-Meta: U2FsdGVkX19giGgCasLr5pR6t5lPmomJ7SGoTkEppPaRWu5JWWcjbXZ4ZLwMozNqGwIiXv6KwBo9kqsIuwrDaCnaO+uVbU2Quk538CAz154UE0Z2bhHni8VeBwdEI13bKUupOw3rQfZHpKdGWIEFJiwKUcg9Uo+iFj7IdxKwLPTiSXPsUcCPsW4fIjG9PvVtH3RRXvfn7ux/R29//pua+Llhrwtf201kzqou1uHRZotgZlb06h/MXK6KsKsWyNUv1HA2oOngLerBKjtzMxSViEvbgGXiYWOt6Ua010YiPmYravznPDu6A8ZdgxKMMckn5fYjnMSgPoW1KW8K7rHcdJNRy0X0J6AIIZ1RLPEwuQOTzGSUIVZ5CKxyNsAJ3GF2Y5895ccWGJ0RcAtibsG2FgpCAg0eWqKHalxkIBTeF4oZj/6U31p+fwM83iEVnPG+iUeG8SCMeauN3bINg4QjoIip/lHZ/kAdxGTgEvM2KL4z1RyEWIkJxrB5ZzIPTOTw2BOQKtobxJ09swgOOWsxF1/G2q1QYIYuOKT71XKncKfmxDGq2OAlGk10cID7fidpPqSfhvp1NEhohVENw+mESW5EjbblU/z78CS7lPFm/m3Q1CmACP9EL9I5jIKVdtAQYnDcp5EJ/+ucHUyzSpcRl0pnnxeFHx+q8ak3tHU+F+GvqGezkI4YTh6gVvQLq1xEJ3+06MBq3qOQEhmKLAHUA7nNyLnrupZELkVg7s05GQ2TXCPly9g0UDfDuq+8jjlYRbm3ujDDx5Buea00CeW/9ERTogAHf0vOedvgN5TIb9yNWCe9V/Q+YIoKCQlcjG/6XK+naqvAJlTsFaLpg3JZ+i9Ps3mWQE1z/ti0LKmq8mW94OB5oruzMaA6TQTcN/S+gcxu8YvkaJ/+fMbM/kQOvahDDzR6KuSTbXIfzCWO4P5Jwnx+IX+43VsMXSMpWiho10Yhz0kgUSa4NxxQg6z
 9aegouJs
 WQ9xZtTCp9OCiRutP22k1wq88vw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 10, 2025 at 05:28:43PM +0000, Maciej Wieczor-Retman wrote:
> From: Samuel Holland <samuel.holland@sifive.com>
> 
> KASAN's tag-based mode defines multiple special tag values. They're
> reserved for:
> - Native kernel value. On arm64 it's 0xFF and it causes an early return
>   in the tag checking function.
> - Invalid value. 0xFE marks an area as freed / unallocated. It's also
>   the value that is used to initialize regions of shadow memory.
> - Min and max values. 0xFD is the highest value that can be randomly
>   generated for a new tag. 0 is the minimal value with the exception of
>   arm64's hardware mode where it is equal to 0xF0.
> 
> Metadata macro is also defined:
> - Tag width equal to 8.
> 
> Tag-based mode on x86 is going to use 4 bit wide tags so all the above
> values need to be changed accordingly.
> 
> Make tag width and native kernel tag arch specific for x86 and arm64.
> 
> Base the invalid tag value and the max value on the native kernel tag
> since they follow the same pattern on both mentioned architectures.
> 
> Also generalize KASAN_SHADOW_INIT and 0xff used in various
> page_kasan_tag* helpers.
> 
> Give KASAN_TAG_MIN the default value of zero, and move the special value
> for hw_tags arm64 to its arch specific kasan-tags.h.
> 
> Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
> Co-developed-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
> Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
> ---
> Changelog v7:
> - Reorder defines of arm64 tag width to prevent redefinition warnings.
> - Remove KASAN_TAG_MASK so it's only defined in mmzone.h (Andrey
>   Konovalov)
> - Merge the 'support tag widths less than 8 bits' with this patch since
>   they do similar things and overwrite each other. (Alexander)
> 
> Changelog v6:
> - Add hardware tags KASAN_TAG_WIDTH value to the arm64 arch file.
> - Keep KASAN_TAG_MASK in the mmzone.h.
> - Remove ifndef from KASAN_SHADOW_INIT.
> 
> Changelog v5:
> - Move KASAN_TAG_MIN to the arm64 kasan-tags.h for the hardware KASAN
>   mode case.
> 
> Changelog v4:
> - Move KASAN_TAG_MASK to kasan-tags.h.
> 
> Changelog v2:
> - Remove risc-v from the patch.
> 
>  MAINTAINERS                         |  2 +-
>  arch/arm64/include/asm/kasan-tags.h | 14 ++++++++++++++
>  arch/arm64/include/asm/kasan.h      |  2 --
>  arch/arm64/include/asm/uaccess.h    |  1 +
>  arch/x86/include/asm/kasan-tags.h   |  9 +++++++++
>  include/linux/kasan-tags.h          | 19 ++++++++++++++-----
>  include/linux/kasan.h               |  3 +--
>  include/linux/mm.h                  |  6 +++---
>  include/linux/page-flags-layout.h   |  9 +--------
>  9 files changed, 44 insertions(+), 21 deletions(-)
>  create mode 100644 arch/arm64/include/asm/kasan-tags.h
>  create mode 100644 arch/x86/include/asm/kasan-tags.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7bf6385efe04..a591598cc4b5 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -13420,7 +13420,7 @@ L:	kasan-dev@googlegroups.com
>  S:	Maintained
>  B:	https://bugzilla.kernel.org/buglist.cgi?component=Sanitizers&product=Memory%20Management
>  F:	Documentation/dev-tools/kasan.rst
> -F:	arch/*/include/asm/*kasan.h
> +F:	arch/*/include/asm/*kasan*.h
>  F:	arch/*/mm/kasan_init*
>  F:	include/linux/kasan*.h
>  F:	lib/Kconfig.kasan
> diff --git a/arch/arm64/include/asm/kasan-tags.h b/arch/arm64/include/asm/kasan-tags.h
> new file mode 100644
> index 000000000000..259952677443
> --- /dev/null
> +++ b/arch/arm64/include/asm/kasan-tags.h
> @@ -0,0 +1,14 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef __ASM_KASAN_TAGS_H
> +#define __ASM_KASAN_TAGS_H
> +
> +#define KASAN_TAG_KERNEL	0xFF /* native kernel pointers tag */
> +
> +#ifdef CONFIG_KASAN_HW_TAGS
> +#define KASAN_TAG_MIN		0xF0 /* minimum value for random tags */
> +#define KASAN_TAG_WIDTH		4
> +#else
> +#define KASAN_TAG_WIDTH		8
> +#endif

Shouldn't this be 0 when KASAN is not in use at all?

Will

