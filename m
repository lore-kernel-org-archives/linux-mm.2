Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E5EEF34C49
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 13:52:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A4816B0089; Mon, 13 Apr 2026 09:52:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3555D6B008A; Mon, 13 Apr 2026 09:52:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26AE66B0092; Mon, 13 Apr 2026 09:52:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 17B166B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 09:52:47 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C29831B6F3D
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 13:52:46 +0000 (UTC)
X-FDA: 84653673132.04.521336F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 37ED440006
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 13:52:45 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C7PENIbd;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C7PENIbd;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776088365; a=rsa-sha256;
	cv=none;
	b=PIeasb7oLOb8Z6Q7tCmEZUz7Fh+ILtmYLpoQLuCNVmTWDjiU5lB2wyaY+JTWXV4vi7iokb
	uJ+rLy81FR5I6uAbrE4IB3dEUzz5jDxRgDhheweN7bVVBecbol8Ld22n6qogMULyuzlTuH
	gmiPFdAKIYkz/GbUhTzW5lS9VCT5lUc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776088365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YH5qQfX70rEHFoofc9LsX2b9k0VOhQQFbPgsvMZwChk=;
	b=wzMI4stgopDIxR3nU7ObF+RyUZlyqrCb6wj2MHRUtSo4FBtELgOuqAqC3gLVxFYzkd/R1D
	4pEsKRkVscUnn/RC/BOftyVsN5S9OMzr+RiVcI5k0O7P2BqZ0p2qcp0mR7EQlt9auZT77Y
	nrhFu1ZS9LU6zvvBxpGUIdXqJOsvE0g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 90E6360172;
	Mon, 13 Apr 2026 13:52:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADBA4C2BCAF;
	Mon, 13 Apr 2026 13:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776088364;
	bh=bFM8U1JUGcAtq+1deURslVyXJrp61glVzYsdgs2qj18=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=C7PENIbdL4MpkTgYARHVc5PRILUsKE02jNt5oWRDv8mPElXZvqAiLf723F5uLpd2I
	 8gw3DlLR4V+F09XGvDlcofho8IAyc70tF7s4UdIIUssRCGlzAxLgwafjkbJ0aKIq8z
	 BXxvmY8aZ2i1tIAgeBXSKenif7TJimEybUTMSJ1LdT46Qxe+DW2u1Q5CBlxy+2FCkH
	 jBhsVpz7XPeLpOb6cUEiAmFLTrDctBmnTyAhUmEBvoSssFtq9vgLpnLvKHrMvn7P6z
	 phOJOeebLrH5fk8vV9tmRzkIyvBkM7YIt3ILyY+eOt5nYOBGqNYbIXEDwq/drQPBu0
	 YsG+skO2IO2WQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Evangelos Petrongonas <epetron@amazon.de>
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,  Alexander Graf
 <graf@amazon.com>,  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush
 Yadav <pratyush@kernel.org>,  "Rob Herring" <robh@kernel.org>,  Saravana
 Kannan <saravanak@google.com>,  Changyuan Lyu <changyuanl@google.com>,
  Andrew Morton <akpm@linux-foundation.org>,  <kexec@lists.infradead.org>,
  <linux-mm@kvack.org>,  <linux-kernel@vger.kernel.org>,
  <nh-open-source@amazon.com>
Subject: Re: [PATCH v2] kho: skip KHO for crash kernel
In-Reply-To: <20260410011609.1103-1-epetron@amazon.de> (Evangelos
	Petrongonas's message of "Fri, 10 Apr 2026 01:16:05 +0000")
References: <20260410011609.1103-1-epetron@amazon.de>
Date: Mon, 13 Apr 2026 13:52:40 +0000
Message-ID: <2vxztstf7ys7.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 37ED440006
X-Stat-Signature: z98wnwcz7rszgtyko8fqtf84r336zntb
X-Rspam-User: 
X-HE-Tag: 1776088365-940964
X-HE-Meta: U2FsdGVkX1/f6qRRyflx9WHo7z335QqRtbOGBAIXWkgWwcRIkTKdZ6Db0udYA38IR3obuZj222ciHSI+sEqMkkXTvCxZxaYFsS9+luNUUd4Ea7gQghIc1Ptkw/J/4aWQo/W2S3ygo92uMKboLisrXbfc6hhyebh7a0hIE+v1uM4iKpAO5nip9Q0rzhafss45FiN6MXSZlufjVux2u1UGLBLLqeXr44Fi6NAlTdV1XHdrC/8mnM4xVKMGoLgWZstC+UTMSvBCkgWtBi0Im2aNOgKqjKB51RPHhVZ3UQQO5D5ZK8d2FMWuOOGIJGLgpUlK3l88Q/T5aCXkirOv0O7oPKFnHNb7oaA9yLKY2jOAATu8FbqXFrmOZwZ5vb6kPhFDbwa8MC/73mo1/iOTxBipJANW7v9KRiRnuTPZUtCA5mbodhP6oSfMcpKtmgUz1StuF4YEA57OYqYbE6WU8uv0Sp+f7nK2BkvHYzZsCk46T136lcZrLUVmmHInX+eMWuWrPzV8ZDaKmoCTCb7HHf+qsZYC6VzG3nFpXZCHF3eaxx7TCptl0imdlBuwpTtHbUQnsAFvffOYyhUylSviW8OR8gu4W4RWwnRHWjplIh5KJ6MicGXAWOgwD2EateWQqB2CotRIeHwEVxm5NGqVeeAh8YJZgZbzKM+mGT00S+6O+L9Zpn5waiajzC39ZkMJEGb4aQpBJr3tE6aTNcb1LjWoktx1xKkW1WjiV9dZ0bIq9brCKTMOBiY5CeMlbDgsA65powPOhJlvqX8KM2hR13NkN3AJxrV83WVYrduCuykxDQoq6P3i4QFlILIpYyohxldaYHwcC2iqZOWaP7qGF8MDI76davLDRZx9YDamr8Ars4TnREgLTCEI9HaD2QvIfNbUMg6H91aPGpk5tdgxecBgpWTttRE++v37fR7PAs0eLAeLfmyKPaREK5ifjvQziWhygMZ8lESU/v2XnN8OhPd
 QGPvDLsq
 3KqxZ4NrfftGfacGYK1v4dnZZClpxOla+6OBLpjpO8y6XgH5rHsewIX+RFYcJ3NW2fDlgvcYu7bDWhrXT9M2+Jot617996ZFvVoykmJw8PSPUdNyXvLZnItxcqEyIXdJ3Awih0SU6MCQiY5Bbhxv0ewnB5NJjAjQZqTBd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Evangelos,

On Fri, Apr 10 2026, Evangelos Petrongonas wrote:

> kho_fill_kimage() unconditionally populates the kimage with KHO
> metadata for every kexec image type. When the image is a crash kernel,
> this can be problematic as the crash kernel can run in a small reserved
> region and the KHO scratch areas can sit outside it.
> The crash kernel then faults during kho_memory_init() when it
> tries phys_to_virt() on the KHO FDT address:
>
>   Unable to handle kernel paging request at virtual address xxxxxxxx
>   ...
>     fdt_offset_ptr+...
>     fdt_check_node_offset_+...
>     fdt_first_property_offset+...
>     fdt_get_property_namelen_+...
>     fdt_getprop+...
>     kho_memory_init+...
>     mm_core_init+...
>     start_kernel+...
>
> kho_locate_mem_hole() already skips KHO logic for KEXEC_TYPE_CRASH
> images, but kho_fill_kimage() was missing the same guard. As
> kho_fill_kimage() is the single point that populates image->kho.fdt
> and image->kho.scratch, fixing it here is sufficient for both arm64
> and x86 as the FDT and boot_params path are bailing out when these
> fields are unset.
>
> Fixes: d7255959b69a ("kho: allow kexec load before KHO finalization")
> Signed-off-by: Evangelos Petrongonas <epetron@amazon.de>
> ---
>
> v2: Per Mike's review [1], move the guard into kho_fill_kimage() instead
>     of patching the arch-level producers and consumers. This fixes
>     both arm64 and x86 in one place and avoids redundant checks. Tested again.
>
> Note regarding backporting
> The offending commit was deployed with 6.19. The only other supported
> kernel version with 6.18, unless I miss someting uses
> ```
> if (!kho_out.finalized)
> ```
> which in the case of crash kernel it shouldn't be finalised.

While normally you should load the crash kernel early in boot and at
that point KHO should not be finalized, I don't see anything that
prevents crash kernel from being loaded after finalize. In which case,
you can trigger this bug before d7255959b69a ("kho: allow kexec load
before KHO finalization") as well. Also, before f322a97aeb2a ("kho: only
fill kimage if KHO is finalized") (landed in v6.18) kho_fill_kimage()
was also guarded by if (!kho_enable). So you'd hit this bug in all
kernels before that point in the very same way as today.

So should we update Fixes to 3bdecc3c93f9 ("kexec: add KHO support to
kexec file loads") and Cc stable?

>
> [1] https://lore.kernel.org/all/ade2ExpM8ROXV-vy@kernel.org/
>
>  kernel/liveupdate/kexec_handover.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index cc68a3692905..1029fe8778f2 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -1551,7 +1551,7 @@ int kho_fill_kimage(struct kimage *image)
>  	int err = 0;
>  	struct kexec_buf scratch;
>  
> -	if (!kho_enable)
> +	if (!kho_enable || image->type == KEXEC_TYPE_CRASH)
>  		return 0;
>  
>  	image->kho.fdt = virt_to_phys(kho_out.fdt);

-- 
Regards,
Pratyush Yadav

