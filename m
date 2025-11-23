Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01B7FCFC518
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 11:27:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2015A6B0092; Sun, 23 Nov 2025 06:27:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B22B6B009D; Sun, 23 Nov 2025 06:27:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 079E86B00AA; Sun, 23 Nov 2025 06:27:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E71296B00A5
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 06:27:56 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5F1AE130B52
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 11:27:56 +0000 (UTC)
X-FDA: 84141647352.05.112EB7B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id D3F7240008
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 11:27:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jZfhzArV;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763897274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i1ZFE3HUBX+e3MwLhoGDnF+w9zhyW17NQY5/2GOCYQE=;
	b=Qt4ldDAh/wLqIDT/q/t2XNqyuFIzU13OKVRqOwV1elnQr0M7+itjD0IJrPFfikJLrbVhJz
	wEUbich7C0zTdlryZOPT0gVnCeD2RTanR6A2Ipd1iDeF1aWaNQRxiLyvoGcp7Zos1WzwhZ
	JQlsR1AZBNFiOdpjweMg/xOw1Cytn94=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jZfhzArV;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763897274; a=rsa-sha256;
	cv=none;
	b=SY6fKtuasJIeFc5T2YiI5AE6VMc4IIk8tQwB1hCTtcpD3C1YfY/vF5TF6bv9CQfvOu7+P8
	UMJxUVPxcZayyC75nRaqTI8hlW3PImINrm4lWWcZXoMk3YTPvJd1tQEXFWt3hU5j7FjCh1
	SIq6cRcFdPkSOEFezxQNbJa6P4e74FQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CE8F86015B;
	Sun, 23 Nov 2025 11:27:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E13C113D0;
	Sun, 23 Nov 2025 11:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763897273;
	bh=RJWIVQsLtFDoyAvibb81H4g0e9OZxXyGb1K+TZ25eXY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jZfhzArVLsHjBLAt4XfmVUPyRn0SeJFdACvw4DklTg6IwoSkyvWAxaTwaUzX5RovI
	 8Ro3Rybx/tN/ig+tzrDpbhvhKWQs91mVGH3w1TMmmJM8GuFTmx7TRTsvjR4gzEP3Wa
	 FEDrs+JFT5Z5zVtyXtQ9gR2ileWiTGLSzoPSJMN6/ENL3Wo6C2Z8ZfNVbGgWThRiPv
	 ACYYicPxsYIB9jNmgOh5MjWjbHIHPmz5Wa1wJtO4VeYlWidpQ4Gh4m9ob80amNlYY7
	 CSHDsdJdaPIjLqr94IsAAz4Wy+fSieoJq2C2kUgoLQEWd5QCFEGKZRJZFGH7YDR9ja
	 8Q5Wl2RANnndg==
Date: Sun, 23 Nov 2025 13:27:31 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net,
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
	masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org,
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev,
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com,
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, linux@weissschuh.net,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com,
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com,
	skhawaja@google.com, chrisl@kernel.org
Subject: Re: [PATCH v7 02/22] liveupdate: luo_core: integrate with KHO
Message-ID: <aSLvo0uXLOaE2JW6@kernel.org>
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
 <20251122222351.1059049-3-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251122222351.1059049-3-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D3F7240008
X-Stat-Signature: 9qrbd67ftek6kkohbwxuz86g7fdf6adc
X-Rspam-User: 
X-HE-Tag: 1763897274-459617
X-HE-Meta: U2FsdGVkX1+ET5bKD5AuK73g2ROf/3yPujM45jOJm21UiFklH98mOtdwpj+dwbCDgUCcRRe2fmiAHbrZrkJGAdKT6vUti1sbHo1NbX1ABYsIAioGhpTRSXD/VRi1tYi/nQCYak6Mc8543OlnOna3NdSki+b5I7mYgiFFrkLVCopVWAFpXJXtdwD3IcVTggfbLEeTniSE042zvVYZv8yBNkEdTTdKxBIFaH/gnnvfQ7CpOaJ+31wDzgmRVxFwVoeBq3N5s+Rtk2kj2OBc6hF85y8g+H0app4TYGQK11ZnTe4n/BE4u8xYsQQOFSuiDt3ucpMpxYsKHnkGL9LcHigYs6s9x3v+N3vSPnAEdJ5R0cnws6334x2a1yrxlLemPecC8fFqGYw6kMuw7xCMqm+4BMmEV3W6D9IwgrUnnym83fD2hMg+V91wB2LXTq9jeaCSv4HOpTUVeBmGynRfXZ79oIzS80k8eL83yam2D4d2lRbjTwqjlmjsLA8wRT/C2EjwrM+EbUzUxITK2UOCO2ny//3uepVtXfNNEtI5MDv/fK/t/8/cEuAbMNtk6QmB0NhzCVwsxZcF+ktMfB85x8G5gMtdqmEtlqRu4KpUB2mk9qY7HXDaz46yF9MhTFejNNSSyMxQL+1v4vnYVkqr7ueaLksLO74uriBHs6ob1ZcpwmIIV9x3Aq2ohWsWt9EhxqGpe6KQmkf0+YytV2UVyrhhIizNWnaAK4OVPl6k8+DGs8RtYaDEXJU5lB/0BGQaBzysTZBOOxxXj1PvOmzkSmyL1zROrMXle8SClwAkaANymaNwoPNyPu24CUxWeqXVnW1h2/rcP5/T8/CDwuf3U55V9opE7+ysZ3GgTyCrScrAF0YrXYpQuZJbR0kQ5srxrRGVJQe+Rl/kEQ/EgSn+uAEKeQOFGCeI0lCxbLvUIeVJpsiEbdOFPlztDVB/wKBDVx73PDICMg7eNe013jMz/ag
 wiwZwxUm
 E9RRnzKdgO/y4g2Ktjx29792IYgNeE6LBkjRq64teO4SjBPk4HMWE9Fr0nWvBHpGgqLJWysr9Z8/KaPVvv05UhFdCLy5iBloF1lb49gtPZVKBb2S9Em7UgyQH771I6nj5yCuoroiBPMp/aIf36D99zclXTj78x9qRZisJMjaimd0b+AzrkXbMdXmWljHiYnbdTKX1fEGIZBqfUIWPt+q8MuuOeQJ1FfPvCDWpZwrmQddjguqvHYVKyGTkBT1hlL58usxQZ1bmHoZDxwlP1Q8umeMObL18k4AhjUozDckpdBASBL+pqwLEPiyYHoiQwjbLqbATy/91pJMaG369jr08obSJrHNYzyppajqUTlsZKtuBvYaO8dem1SqsXujAJiJMKO6PbMuILL588dW3cAVs5ab5wcNizDuWrCdlz9Pd11tpL5/X80mndcQAZ98WyydnWGPlhGaiBFkwFJhPStLJaAi1w7dsytWT44MZI2pNkndvIME4aeFM8lEVIQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 22, 2025 at 05:23:29PM -0500, Pasha Tatashin wrote:
> Integrate the LUO with the KHO framework to enable passing LUO state
> across a kexec reboot.
> 
> This patch implements the lifecycle integration with KHO:
> 
> 1. Incoming State: During early boot (`early_initcall`), LUO checks if
>    KHO is active. If so, it retrieves the "LUO" subtree, verifies the
>    "luo-v1" compatibility string, and reads the `liveupdate-number` to
>    track the update count.
> 
> 2. Outgoing State: During late initialization (`late_initcall`), LUO
>    allocates a new FDT for the next kernel, populates it with the basic
>    header (compatible string and incremented update number), and
>    registers it with KHO (`kho_add_subtree`).
> 
> 3. Finalization: The `liveupdate_reboot()` notifier is updated to invoke
>    `kho_finalize()`. This ensures that all memory segments marked for
>    preservation are properly serialized before the kexec jump.
> 
> LUO now depends on `CONFIG_KEXEC_HANDOVER`.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  include/linux/kho/abi/luo.h      |  54 +++++++++++
>  kernel/liveupdate/luo_core.c     | 154 ++++++++++++++++++++++++++++++-
>  kernel/liveupdate/luo_internal.h |  22 +++++
>  3 files changed, 229 insertions(+), 1 deletion(-)
>  create mode 100644 include/linux/kho/abi/luo.h
>  create mode 100644 kernel/liveupdate/luo_internal.h
> 
> diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
> new file mode 100644
> index 000000000000..8523b3ff82d1
> --- /dev/null
> +++ b/include/linux/kho/abi/luo.h
> @@ -0,0 +1,54 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +/*
> + * Copyright (c) 2025, Google LLC.
> + * Pasha Tatashin <pasha.tatashin@soleen.com>
> + */
> +
> +/**
> + * DOC: Live Update Orchestrator ABI
> + *
> + * This header defines the stable Application Binary Interface used by the
> + * Live Update Orchestrator to pass state from a pre-update kernel to a
> + * post-update kernel. The ABI is built upon the Kexec HandOver framework
> + * and uses a Flattened Device Tree to describe the preserved data.
> + *
> + * This interface is a contract. Any modification to the FDT structure, node
> + * properties, compatible strings, or the layout of the `__packed` serialization
> + * structures defined here constitutes a breaking change. Such changes require
> + * incrementing the version number in the relevant `_COMPATIBLE` string to
> + * prevent a new kernel from misinterpreting data from an old kernel.

From v6 thread:

> > I'd add a sentence that stresses that ABI changes are possible as long they
> > include changes to the FDT version.
> > This is indeed implied by the last paragraph, but I think it's worth
> > spelling it explicitly.
> >
> > Another thing that I think this should mention is that compatibility is
> > only guaranteed for the kernels that use the same ABI version.
> 
> Sure, I will add both.

Looks like it fell between the cracks :/

> +static int __init liveupdate_early_init(void)
> +{
> +	int err;
> +
> +	err = luo_early_startup();
> +	if (err) {
> +		luo_global.enabled = false;
> +		luo_restore_fail("The incoming tree failed to initialize properly [%pe], disabling live update\n",
> +				 ERR_PTR(err));

What's wrong with a plain panic()?

> +	}
> +
> +	return err;
> +}
> +early_initcall(liveupdate_early_init);
> +

...

>  int liveupdate_reboot(void)
>  {
> -	return 0;
> +	int err;
> +
> +	if (!liveupdate_enabled())
> +		return 0;
> +
> +	err = kho_finalize();
> +	if (err) {
> +		pr_err("kho_finalize failed %d\n", err);

Nit: why not %pe?

> +		/*
> +		 * kho_finalize() may return libfdt errors, to aboid passing to
> +		 * userspace unknown errors, change this to EAGAIN.
> +		 */
> +		err = -EAGAIN;
> +	}
> +
> +	return err;
>  }
>  
>  /**
> diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
> new file mode 100644
> index 000000000000..8612687b2000
> --- /dev/null
> +++ b/kernel/liveupdate/luo_internal.h
> @@ -0,0 +1,22 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +/*
> + * Copyright (c) 2025, Google LLC.
> + * Pasha Tatashin <pasha.tatashin@soleen.com>
> + */
> +
> +#ifndef _LINUX_LUO_INTERNAL_H
> +#define _LINUX_LUO_INTERNAL_H
> +
> +#include <linux/liveupdate.h>
> +
> +/*
> + * Handles a deserialization failure: devices and memory is in unpredictable
> + * state.
> + *
> + * Continuing the boot process after a failure is dangerous because it could
> + * lead to leaks of private data.
> + */
> +#define luo_restore_fail(__fmt, ...) panic(__fmt, ##__VA_ARGS__)

Let's add this when we have more than a single callsite.
Just use panic() in liveupdate_early_init() and add the comment there.

> +
> +#endif /* _LINUX_LUO_INTERNAL_H */
> -- 
> 2.52.0.rc2.455.g230fcf2819-goog
> 

-- 
Sincerely yours,
Mike.

