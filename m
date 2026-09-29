Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E867FCA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 07:54:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6C756B0096; Tue, 29 Sep 2026 03:54:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1E116B0098; Tue, 29 Sep 2026 03:54:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5A566B0099; Tue, 29 Sep 2026 03:54:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A3BCB6B0096
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 03:54:47 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9C4684040B
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:54:46 +0000 (UTC)
X-FDA: 85266038172.02.DD52EDE
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf12.hostedemail.com (Postfix) with ESMTP id EFFE240003
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:54:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=bmQLzw4r;
	spf=pass (imf12.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790668485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zT6GlfQft/QJeAy0pckXvrIl9KIiBoLg2QYNryNymLU=;
	b=NEfn29wFIIIXU3YxoQH1DjwGhCM2mHMR4KSrN49RbSNCyLx74SCz/iVbHNH1xtJHi+Iqzp
	iktsqkB/R2nJpzYY5A3/4ziS4obie94hHJiuI3TU0xUYf3t3/7iCcdZtmFBzkiI6x9HECt
	WNOtDfGEHveU/2GABNZLsPtv8GJMWVA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=bmQLzw4r;
	spf=pass (imf12.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790668485;
	b=emrXUaLQQp5wn8geUVKGSMuh1Sgnr1ekJJ6y45oKSqIi28DvRqpPa7vD0/gAT+dV168HKJ
	OvlwyBJ1sUMBsZsX3cucBw+yeyxa+k+sWNrnq+kGBMHLUI/rfeTU6hlZmfGkhtkU/c2JYI
	2RAa77PVL9x1t7Qk/N65vI4zUqPjJmo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=zT6GlfQft/QJeAy0pckXvrIl9KIiBoLg2QYNryNymLU=; b=bmQLzw4rqkY4fV8qO1gp2+zRk4
	nhnwFpj7IgIbEV0UNBL0AOnauwbzBlCrL0ajhvhUVi+pNnh8SIZRzeefsOeh2Kr+NSn2B/sAIj7Vh
	Cx4AjbKvt+mRby1KlKqiNENB9NvJZhwvbf7gm1HC3bSiE/zr2kOf2x6WRKTNv+D2/KJS9G+aCQfJy
	toxyW81SwYmF7/bHp3ab0R0jpaRE1WptNnL1lIFsaUvgJvNpq1mWDNvoRc/z4pdNqCh2Tcmi+TgDy
	hVZUhCFgMIoSgF2tN4jnyl9609fBdFBT+W9F9gzKS5Fe2LmAP+mdiNLql6o3NqdHV3RMF1f+4q+yR
	ZPnsshtw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1xBSfV-00000002Jcc-0zm7;
	Tue, 29 Sep 2026 07:54:30 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id F1E06300446; Tue, 29 Sep 2026 09:54:26 +0200 (CEST)
Date: Tue, 29 Sep 2026 09:54:26 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Zack Rusin <zack.rusin@broadcom.com>
Cc: Kiryl Shutsemau <kas@kernel.org>, Borislav Petkov <bp@alien8.de>,
	x86@kernel.org, Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, virtualization@lists.linux.dev,
	bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org,
	Christoph Lameter <cl@gentwo.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bo Gan <bo.gan@broadcom.com>, linux-mm@kvack.org,
	linux-arch@vger.kernel.org, linux-coco@lists.linux.dev,
	kvm@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Long Li <longli@microsoft.com>, Andy Lutomirski <luto@kernel.org>,
	linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
	Nathan Chancellor <nathan@kernel.org>, Kees Cook <kees@kernel.org>,
	Ashish Kalra <ashish.kalra@amd.com>
Subject: Re: [PATCH v2 2/6] percpu: Bound decrypted storage for all x86
 encrypted guests
Message-ID: <20260929075426.GQ4120091@noisy.programming.kicks-ass.net>
References: <20260929040256.543767-1-zack.rusin@broadcom.com>
 <20260929040256.543767-3-zack.rusin@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260929040256.543767-3-zack.rusin@broadcom.com>
X-Stat-Signature: 4iireyiz47bmz74xg1me4igk3fsnx6t5
X-Rspamd-Queue-Id: EFFE240003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790668483-393433
X-HE-Meta: U2FsdGVkX18+E2M7jbH4dBrYOmJrUzm4zuN9X49/dNueURsoTHn56qDjfS0rHX4sGjtnSH+oaBhPHBGvYYABcfvvrfdMFm0vLowrHGkAjLadiIV5hj3CshoadcdVgz73ldRGiM7odZEv79KUzrV9j7vyO8jrylCch5MvkTiw1+gOnEf6o7X2Mr6KitJPlHLa0v3GShVTn9PGORPtuY1O7ioujyFLeiJJB+h3VT2iW0ZR6HADaCZO6Tw12FNPTkxFvZiExIN4F9rWFw3QhKJu39AjB5jVuh4nuNjX1E5Xq4tMUd4W6aJWeu7UXg4Ezqj8mVckghpJKm4nh3wGpcHvYyAYkUdyXyeN6Dc0Okb2gOpi0guMB9yedm98kUWh8ybXWyl6yeM2YyAPApwxSCH1ScayUxa4TJiB/2zMaUxbYsId64wb8b+HtCEdMrkRwyvqJsGAPswyKH3S1yV55Xs7LPGRvRCXhbPdqUl/2sbu2Tda0BbHeQ9TwFWQ/nhN+Dj7QSfMTZIt2ASRQHgsobM8lYo54DdE5JXtFXurvKNO0H569iFOOk6IlPPfboIkBuARo2EqVGyNoa+Z0Bf6syaw3/fFyRuZ1PZOtZTrVqLSfQrisOpn8VBZrGjDY2R47LhE9rnrkSkZwuHhZhM/8VXdor5/e5pYsaFcRvTHONShgKHXd6cFpdkxNauQZPj9qhEkAeVIsXVEVHLYmMRTpiubO9dmfje0E4R5Fq422DcWpljd+hBtsDfKhwc+S5PWxaCSyl4TAyfOzKkWA916wgPQIu28TRn62JspAHyDAr6YQLseqYQqC1jVtVtp86EpRgjdZAL/skItwQDVxx2GxZP9elIOesvjzWVLId4qIjeYFNVMZNVK0RKcSE5S3xzLL1OdFQIpKDIS5WEZwT0wqlk4EFIg7LMVS79rVH3cnywP6L6+Dz6kUN0a4z3iSwTwIAU3h5rpgvswfIEMOQI1AQd
 uV5gbE3w
 uqS6BjXfdVVx3WDW8j6GncdEXmFTuZ0AXSyDTFStP7bEqaocfzt/ejlbbSFvj8gm3h8Omgtfh39RPJYXXgl+tkc9iGG+nOV+wxn0gDIVe4utcMsjczsq/LsB/tjEzJ9GYq1YLFuHW1Y5DtvXZhX5JjSRiAxWcA+DGmPNH/hb3NXZDC/feViiUfPIzWcoTP5m6DaQaNTtulgg3XgNmVGIR67fWIRWQQfpGoR6M0AMOLO7Lno6eioaPe6UEakr23OcZd8lu+veQtH7ijFrfNZOynvHjcg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 29, 2026 at 12:02:51AM -0400, Zack Rusin wrote:
> TDX also needs shared per-CPU buffers. Use X86_MEM_ENCRYPT for their
> definition and placement, and provide page-aligned boundaries so the
> architecture can convert each CPU's whole section before registration.
> 
> Define the boundaries in the SMP template or UP data as appropriate.
> Drop the unused DECLARE_PER_CPU_DECRYPTED() macro.
> 
> Suggested-by: Kiryl Shutsemau <kas@kernel.org>
> Link: https://lore.kernel.org/r/aqqGUAX65s4LdJkr@thinkstation
> Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
> ---
>  include/asm-generic/vmlinux.lds.h | 12 ++++++++----
>  include/linux/percpu-defs.h       |  7 ++-----
>  2 files changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index 64bc2bfdd2ec..145fcdbbe9db 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h

> @@ -1022,11 +1024,13 @@
>   * Note: We use a separate section so that only this section gets
>   * decrypted to avoid exposing more than we wish.
>   */
> -#ifdef CONFIG_AMD_MEM_ENCRYPT
> +#if defined(CONFIG_X86_MEM_ENCRYPT) && defined(CONFIG_SMP)
>  #define PERCPU_DECRYPTED_SECTION					\
>  	. = ALIGN(PAGE_SIZE);						\
> +	__start_percpu_decrypted = .;					\
>  	*(.data..percpu..decrypted)					\
> -	. = ALIGN(PAGE_SIZE);
> +	. = ALIGN(PAGE_SIZE);						\
> +	__end_percpu_decrypted = .;
>  #else
>  #define PERCPU_DECRYPTED_SECTION
>  #endif

So you're page aligning something that will get different protection and
will thus shatter large pages?

That is somewhat uncool. We like large pages, large pages are good.

