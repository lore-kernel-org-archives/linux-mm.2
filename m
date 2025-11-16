Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF9D0CD4F3E
	for <linux-mm@archiver.kernel.org>; Sun, 16 Nov 2025 12:45:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C10A8E0015; Sun, 16 Nov 2025 07:45:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 471798E0005; Sun, 16 Nov 2025 07:45:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 361358E0015; Sun, 16 Nov 2025 07:45:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 202DF8E0005
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 07:45:09 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B35441409B9
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 12:45:08 +0000 (UTC)
X-FDA: 84116440296.04.15A02C1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id F39B21C000C
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 12:45:06 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mVUG98NP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763297107; a=rsa-sha256;
	cv=none;
	b=MwbybRgSWn+2XRBubPTeyPYAzMbE6MBN0HQDeM7Np1WxhEMkhxr3MN0nWcGtn2RA6YOMFZ
	cBthqp7b+0GfwhoafgTl/eShrsi9HcQqGkwRdSyN5NfEYLXzzgEm8akT010rmsVbPIeyhs
	55q5jY5Wcj613H5jA8QSvgk2H6K0wnc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mVUG98NP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763297107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oFQ6FUygXlY1WAq5qYQ8CDd3XlTo/iHW8M507uWs1Ug=;
	b=2XDR3MTF5J0CbOjd8kZVYw9lx2wVTx42om3iIstFLQ/jTY8rsyikh4uRiDlGp2nJdD6y9b
	WxgqafYm9y8TMQiwJclFAHT+k6WLBVnNHevjv5KaMh41p/ufYI86cTgo39Li3I4ib+sNAa
	XPaDG85PjN8QmJjMGKuYJBVl3CKIgPw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BF34243226;
	Sun, 16 Nov 2025 12:45:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5D04C4CEFB;
	Sun, 16 Nov 2025 12:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763297105;
	bh=FQsIjcze7ny/ihNObILffVz/RZYjdBBVaFrGEHeRaGo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mVUG98NPrWa2ycrlOR5G9KSRrMXg0exikuWmvqW0pl+wMf5e6gUAXY2/KvUstqKbO
	 wtvi6wt5qqNulwDxLfUPo4BMaCUGq+z2zIwgVh+TRMdnydwcON8f6GBmTRx0l/zAAg
	 UFDQbW14bn1sS9UftJi+0NltKYWS1bKPrnq9qoOJTMZ0Z3VswFK+5dDsP3cbs6/If3
	 8KPX2wVrR9h7PlZ0VaxG1ow8eQ7qydDhweuVniORdwFwo4ZGBBVTuQ9zdf9U7kqGhc
	 yuxWfZY4ycdPogoX/C/ajzJCOuv/BCJBlXjgiUQuQz9ZAps4c3lpYndqioxuKypmq7
	 mnOM8YWPrG9ag==
Date: Sun, 16 Nov 2025 14:44:41 +0200
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
Subject: Re: [PATCH v6 03/20] kexec: call liveupdate_reboot() before kexec
Message-ID: <aRnHOeL8Es3-9dQ6@kernel.org>
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-4-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251115233409.768044-4-pasha.tatashin@soleen.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F39B21C000C
X-Stat-Signature: m94yo8cu86qcyafkdk9uen1af6wx6hef
X-HE-Tag: 1763297106-952969
X-HE-Meta: U2FsdGVkX1+LikAF2npk5SYTWZkFbRp51m1AMp2avN1huPfrxqrEEmEory2cIZYmBVFSe/JE6+HpH/TolsrzMKWU6vXgUBuASXlTQYeExIXSYe46oo6wkjSEBUQs8QRKAgGNwd1I40RZocfBOFXHEukWBuE6pINfikmzLUtbmTVw+9Ww/DTIQ7Kz0IL9v9NqCH0Xe2kpd9R7QrfIh74PYNtmHNMZlUUtvOgu6/ZtWz2wvBPjSesSWBYRo1o2Vg5cacxGFhZLcUoDAgB5Ew8nZ+RWpqe0gLJoKok69ew+7+g9wi/375/zeGCLjYOlG58zL7nneOX1uVX46A3pqlBAZtzTVhVBrlQdt9Cf7FhvZzvevcvqR+9GtjPwAlQkAbLDZTdqQGM5H0uYldgZZ1tEksN3xCfapUuRXfCjNgkrS6viEpQkT7A1jDcujsbqdI9iEpYoEGIVSa1UiDDIh+Y0TFUywkx/jRtrNxthFXIT2KOoIlV9MfpEPq8qkrijDfcqj8xWtwRXCZVMPPTN92+wBq7sbpdZCr0s60hAZ/Bi4GD0xh/31jfOcO3nbbcDVPuOvQF5CVpBuFH5moxt4fLviLOiEgEhtnGKrYrIUCdUZVXopR7EAjBdkxb/OM1ZPxwJ0/FNPFSxLvfw2SXqamZEk4lH19BEDwdK3DorI2FlKoxhJ1LjtvUhqNrNWHiF0pXtRDiYE65zAD4vvHxjeUAyWLjrty+iCELhHcJSwoQXcGFVxWTHme9FpBv+aKGr6mYQ3TOXVkAxQJMbv89kbx/f/dvw3XKiJ40BqXJ4NfqRb2jzPomAajqkx7lzTyEeub3bOUF9bxqpac+Ye0K0S36rEvX5orOf5XLv7MDJOtpG9nd4NW+ouwGBuVVDjKKFH008Bx78wiQ9w5Osou6HLqpjpzMdFDrW12GaqbhRKx3sTHevl3kWKit44Xj+Xdz1haRf212W1hLd+z4bTUUemg3
 Omafoiwy
 u14eLKgEF7ynZ3yKnbLkxdTVmuV8nt2IO/K5PTOlfOITQDtq2FxoC/QmTYvcKNU0S1uk12zqjVXy72HD4oP+1Zh3bb3bQnn/9KLXL88SaLioRdOg1WnThFelx91KtohAIb+VOdQNddwigkyXtynsX4pLGB9FKy574Ul1uW1QVwrLhXg2RXQ33mAEYl1hHFW5nu6UeZhn1Vzqa5jJ1KEbfZh134qJRTDKcvSpbd4pnvxLb/EZMjviY5qr8Gg6u1+YYfrlcf5J3aS/cFGCeLDS0+M+I6GrTrhaeYNEUUw/4b2x99Vv8KCc7rrt9kVoEaiuW4d5duHNIBOOZDxyNBJY4aJqdpwgY6TdMfqic0/J/0EJvYqD61GGrWabam3M9zFmw3tD+62LtUijK9KvWTOe3b5oImOBd/0cPDD2P7qZlyxRW3J04ScD5wwxFSpsZvTU29p+d6SoGz+duEqk8u/8cqvFi/cW4TgVpxS+g3cB/QVrDM0U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 15, 2025 at 06:33:49PM -0500, Pasha Tatashin wrote:
> Modify the kernel_kexec() to call liveupdate_reboot().
> 
> This ensures that the Live Update Orchestrator is notified just
> before the kernel executes the kexec jump. The liveupdate_reboot()
> function triggers the final freeze event, allowing participating
> FDs perform last-minute check or state saving within the blackout
> window.
> 
> If liveupdate_reboot() returns an error (indicating a failure during
> LUO finalization), the kexec operation is aborted to prevent proceeding
> with an inconsistent state. An error is returned to user.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  kernel/kexec_core.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
> index a8890dd03a1d..3122235c225b 100644
> --- a/kernel/kexec_core.c
> +++ b/kernel/kexec_core.c
> @@ -15,6 +15,7 @@
>  #include <linux/kexec.h>
>  #include <linux/mutex.h>
>  #include <linux/list.h>
> +#include <linux/liveupdate.h>
>  #include <linux/highmem.h>
>  #include <linux/syscalls.h>
>  #include <linux/reboot.h>
> @@ -1145,6 +1146,10 @@ int kernel_kexec(void)
>  		goto Unlock;
>  	}
>  
> +	error = liveupdate_reboot();
> +	if (error)
> +		goto Unlock;
> +
>  #ifdef CONFIG_KEXEC_JUMP
>  	if (kexec_image->preserve_context) {
>  		/*
> -- 
> 2.52.0.rc1.455.g30608eb744-goog
> 

-- 
Sincerely yours,
Mike.

