Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 304C1C88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 11:14:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17E656B008C; Wed, 16 Sep 2026 07:14:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 156AD6B0092; Wed, 16 Sep 2026 07:14:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 044E26B0093; Wed, 16 Sep 2026 07:14:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E0E9C6B008C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 07:14:40 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 34A8FA4F91
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:14:40 +0000 (UTC)
X-FDA: 85219367520.03.76532EB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 372D210000C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:14:38 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XJVBTuuY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789557278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JmNMzbrEv6yrDdkqLEFNGkwZbyvBDG+2DCzdYiaiGec=;
	b=54Gm6BhCNqk4s7xKL4wDWb0A77o/mRkx5PSs1L+o8aaCJAvOF+d7krlu0KjDs/+A9AGBe+
	pedtL+FUI6JSCbV2qTuZRNyftuSjxN6YPnGMZw03mKagbtOiZFoWTMdKbAQdSJKupo/30k
	VxLw2NrbLnAMwm1IwjI9wjXOrM2TmBA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789557278;
	b=CRGoG6S+fOky+jytbiOZzBErGlk6wj6I7WE4PlSgBQ8sngekwSbSiSERnFx3pNspU8AOgW
	uP1PxUJjzXIg+olqIM91hhS69O+EZdJZELcTRdzxhUH9kkdf/3qOxHookKq6cJlslOSZD1
	os7wR5N4sVMUDShfdGc3dd9AH13jva0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XJVBTuuY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B32A760234;
	Wed, 16 Sep 2026 11:14:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B9C01F00899;
	Wed, 16 Sep 2026 11:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789557277;
	bh=JmNMzbrEv6yrDdkqLEFNGkwZbyvBDG+2DCzdYiaiGec=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XJVBTuuY5fxQgaNMqwXdW/8lMVnaanRpKX/ufNaN3rAml3SeqsA7gNP2Cte1203MW
	 1ifeIXo7/j4lidlX0ZIQGq8k7L9cOxeK9CuwH9j2b2BuEO6tMjccM1jt6Tr18u/QrY
	 hMWXD7FhhAKT4v23M7EQ51T0VzbNJpBAE2Teu3SqAKtwY28edU9Veq5nj0E/qarTsk
	 Y5MLlcGK2SgsAp44DSYDLgETx4QPJ72bYzom+6LNN9GvCCkJPDNgC6cb9Sp/IjmdZ1
	 G11bIHkhIvvp4phXYlQMyh0vsVmyIKKT0lcBst2yRskYsPJ27WW1UDuAZVqWw4KzGE
	 e+wnUSn+HPR6A==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.ams.internal (Postfix) with ESMTP id 0CBB9198006E;
	Wed, 16 Sep 2026 07:14:30 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Wed, 16 Sep 2026 07:14:34 -0400
X-ME-Sender: <xms:FnqqamPaDD8QL2vYJf5rPY1guVD00XIkXlvtUp2kyTOR0mI5zavK8Q>
    <xme:FnqqaprVgAB0AbVW80dCO0gfst6mh3Q8bsTcIXNRVqeFmUcPdoQoq2P6wkUApTYgm
    9B-SJ7IRgbaoAy2gOP_hfTX6Lx0XAPM7EaxjvA--dUsKia2zykZz-vE>
X-ME-Received: <xmr:FnqqalIxLKjX1ys8z_hH0D0sbTbkXRBGQSo8vb8ioRKY7qOi1WQrN_P7kE8>
X-ME-Proxy-Cause: dmFkZTEHTPffs6tQZam3XMf5jo2JovVPU0EEMKVfKe73Lr74zoVZQHJyA8b0O/Fo6fSSgj
    xUKdMfiJbhpGK7MzbpLZ4vi1COv9k9i7YAq2TZMwFP23/ASP2WUMk4lChOX6I50KMKC6wT
    kMdp6iZDkSDR0NTSFIsVzIaBvzYEAhBfX6Vm03NOb64oYcKjhiFiVSbzNblFnd0RnuqjMv
    xLV9OVuRbiJ92LHLQj/Y7FEjUIFd43z4c+ENu1F36bTtNYO5pEza9N/P3dzK5PWtYJF5P9
    8J1lyhwhCU00lRtsdLhPl+viOUkwTU4PNcGtVVeqfBeJDGiiFqRC019XiGpsZdJHdjiyXq
    o0iCd1wtzdVEbX7S+cmcnjdn1ZweHEEmR/LlP+mMdVT+ApO+3GGyevETMKEToeDPaKYBnc
    x2SSwqjb7EpUPpfBe3HvtRCHf3MHx9rL5ePCYwci90styEDO14TzgdT0Eo1MVjRsLYRMbV
    bpFduV0xbXgPXoCE50cksswXfyYtgmC/Qz2FhyoDkRMb59z47vcMUe4nK/U+eJsOyjsltT
    GMeja+BaPdoCnmk7f9bLUEipmZtZp3LuiAesFXPF+Xk2+Y4c7HiHAQslOdqBahhqh0ggf1
    gvrZP5p41Mp8yGtSPmYtruSmi8La1nNE1GaMkkffF4ticgnB49i6liQcLNHQ
X-ME-Proxy: <xmx:FnqqaqfYaxX9AvJDNNWWTgMwm0YglJiWAA3ucUcH874sEbQpWmnE2w>
    <xmx:FnqqaseTAv4mVrFWWUTkENbjGMK2MZNABt-4yS-FhUGwildSpd4rcg>
    <xmx:FnqqahYGL0Pdm8P54UOoK7OTY6TInkKNP5WRtOs26wZwzpgM1808Zw>
    <xmx:Fnqqapp3HwaAb32SNLyBOPsLrtssDa0FAESEy5cuiOkrTdlqjNQ6rg>
    <xmx:FnqqasZMmjEJ6shM5jBiOxXn-Sz5yqPhqBen--r0kTpweTj6AIZlBiJD>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 16 Sep 2026 07:14:29 -0400 (EDT)
Date: Wed, 16 Sep 2026 12:14:28 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Zack Rusin <zack.rusin@broadcom.com>
Cc: Borislav Petkov <bp@alien8.de>, Ajay Kaher <ajay.kaher@broadcom.com>, 
	Alexey Makhalov <alexey.makhalov@broadcom.com>, x86@kernel.org, Dennis Zhou <dennis@kernel.org>, 
	Tejun Heo <tj@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H . Peter Anvin" <hpa@zytor.com>, virtualization@lists.linux.dev, 
	bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org, Christoph Lameter <cl@gentwo.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Bo Gan <bo.gan@broadcom.com>, linux-mm@kvack.org, linux-arch@vger.kernel.org, 
	linux-coco@lists.linux.dev, kvm@vger.kernel.org
Subject: Re: [PATCH v1 1/2] percpu: Use X86_MEM_ENCRYPT for decrypted per-CPU
 data
Message-ID: <aqp5yxa2qcsv-dvt@thinkstation>
References: <cover.1789488039.git.zack.rusin@broadcom.com>
 <07cdda86e2c60b27a18023e2e5fae339b78db0ab.1789488039.git.zack.rusin@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <07cdda86e2c60b27a18023e2e5fae339b78db0ab.1789488039.git.zack.rusin@broadcom.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 372D210000C
X-Stat-Signature: ecj7k4rrae5ymwwbip9j5b1payiyn5jw
X-HE-Tag: 1789557278-510229
X-HE-Meta: U2FsdGVkX19lCJsgskY9mZgJu1Kh5X/V+8woFEt3KhTfMo++H14BC6YeEiyNMM4brJQy6y8qgGtD2W6aKpiYMPLNtfLlOSOQeOcqGDXlGnK6zh+dw5sI7mCmGXdEBMewX9vWs3sD2btWr7rPtTNx3jEYDX17Kh7Rtw8NkV+Itb1KisLQsJ7HqE/Yv892JIVGAbJs57SbmtnlN7/syUrXhlzcHhEICYPSbR9ccazLhUaVCQlMU9p8htfcQ6qIAsBfXq+OoqUu2p0SZAka6c6b2Jvr7HtLkoudu6ED9OQl/31jriWUYYv72qNxneEnocPFVhH78nLfXnX4v9mvKMfhlUVUOwwtsPT774dKk/CUd/H0z/mab1uxVepnzw/Lo9CvP/0WSjguMmQy7TZmU7/k1aZeY7naKuMIg7+tf7FpQyyvQ3cZFapkbMDtxUKc86wZj5rKMbm4fl12LmVf610zdNIvKBWduAvCPdPlDYvcyTncIUyptDLPTSuW5spylQBUJHexLFkenVXedabGPDhTFA81l2I3/vG/AsIUAUB/aiLPVkqeLnjxhX0qGkJF2T3tNqvvFRwLCvgSXGX4qvIjzPh5sQ26KtilQSC6w0zsm46m62VBzGVo5Ie0V9G4OaaXOdiyn0kzhuLAzJB7bdrWqAloq3fLN9PudaA3zFuV9AU5DTuEx76vz2iZgTQdvNCd+7AzVcVAAujzqE2TlsEyXeL6fDGFEohlVp2iECUYePq8yvftBapuf7dt7ji6kePeD0slaPFn9rZrF5ChEmMvcY+v+U9j68Zg+KKj/PtECgTf18ipLGv2Io58BuxqmzsKVTxtmkG3PnbrjrtNInEJOFhnka9BfnVUM/46l8Io3vnu9iQf/bJ9Bl3agjfwrE6DBz5a/GsGx1kXVc20H/C0Ap867s5tDPtGT759hOxh+ek/UhahsMZQx3FRD+TpR7NhpWqvl7VUrfUZDvfGSWL
 A15nY5l8
 idrG0ylbdtJ6mPp82efYtVndPlyVZ1KOoBn2e102d+q4G4dS6cvN+p4pzOf+MW/4z3a5TEnsOrXrRRzWW7zMDDw7wDQ5TKDbHRjpekXB3ENWhDCsWgWEZcheJnf2zrXeSeOwaksIrFPUpaocIWOwPJO+/dav+799Y2vBPS7pKR4T4v7+uBalKAWY//zi2XHsrU4ifDr/vIfpuWm55abgRFdOOor0v68zBX9ZE74OSwTYaptBjm8wN8r0HVkqOdEQ6z4yelij2lDQv4Wy/7m5HlWFu2NpwfxpwgysMHw3I6ggCwDU2a/QbJicjl5LdRLBolmyyBx4En1ddwALmwtJiTMfcXwaUmpAO31zPbG5ky8WcHQ5ZyDTXi06SFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 01:05:39AM -0400, Zack Rusin wrote:
> Decrypted per-CPU data is gated by AMD_MEM_ENCRYPT. With
> INTEL_TDX_GUEST=y and AMD_MEM_ENCRYPT=n it falls back to ordinary
> per-CPU storage, so converting a variable to shared memory can expose
> unrelated data on the same page.
> 
> Gate the declarations and linker section on X86_MEM_ENCRYPT, which both
> AMD_MEM_ENCRYPT and INTEL_TDX_GUEST select. Existing AMD configurations
> are unchanged.
> 
> Keep the decrypted subsection page-aligned at both ends. The per-CPU
> template and each allocated per-CPU unit are also page-aligned, so page
> conversion cannot expose ordinary per-CPU data. TDX-only configurations
> may need additional space for this alignment and isolation.
> 
> Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
> ---
>  include/asm-generic/vmlinux.lds.h | 2 +-
>  include/linux/percpu-defs.h       | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index b2988aa12f66..1448e791773e 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -1013,7 +1013,7 @@
>   * Note: We use a separate section so that only this section gets
>   * decrypted to avoid exposing more than we wish.
>   */
> -#ifdef CONFIG_AMD_MEM_ENCRYPT
> +#ifdef CONFIG_X86_MEM_ENCRYPT
>  #define PERCPU_DECRYPTED_SECTION					\
>  	. = ALIGN(PAGE_SIZE);						\
>  	*(.data..percpu..decrypted)					\
> diff --git a/include/linux/percpu-defs.h b/include/linux/percpu-defs.h
> index dbe3267a0a13..54ce1442d918 100644
> --- a/include/linux/percpu-defs.h
> +++ b/include/linux/percpu-defs.h
> @@ -172,7 +172,7 @@
>   * Declaration/definition used for per-CPU variables that should be accessed
>   * as decrypted when memory encryption is enabled in the guest.
>   */
> -#ifdef CONFIG_AMD_MEM_ENCRYPT
> +#ifdef CONFIG_X86_MEM_ENCRYPT
>  #define DECLARE_PER_CPU_DECRYPTED(type, name)				\
>  	DECLARE_PER_CPU_SECTION(type, name, "..decrypted")

DECLARE_PER_CPU_DECRYPTED() is not used anywhere. Do we want to drop it?

Otherwise:

Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

