Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6442DCE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 11:14:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4E6A8E001C; Mon, 17 Nov 2025 06:14:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFF318E0002; Mon, 17 Nov 2025 06:14:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA04F8E001C; Mon, 17 Nov 2025 06:14:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 960768E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 06:14:18 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 37C2D140D1C
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:14:18 +0000 (UTC)
X-FDA: 84119840196.29.8987BEE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8826640013
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:14:16 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d+36XpUk;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763378056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8ADh2GmhPPGw+Ea0z3RTa2FOenTP7OfVYPnpGcbHoe4=;
	b=FRzwT4+BD8TJqNVuI0zN3fJ9ugaKRJit0knF76e1GKwiC1eg5KqwMBdhXXe+bNZXeTALMf
	XyteM25tSnHRuBem/F0ZVpIS3hTBSSHW1knN2BOyhyW9huJeybYjPU62E7JlSJUdClPtyL
	fdgRGCUK6BnK2Qe52pIB633xmsKuwSg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d+36XpUk;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763378056; a=rsa-sha256;
	cv=none;
	b=b1K/NJJhGEaGdphSnGPe9t4Z3fdsIYGVn25X+00qh0FeeLxZLr4kcdrG7mKaRXxeQQ6y15
	+5LSCyTF6Cc8g7M2dqaIO5kBYP2FEa7rA5k+Kfjx+3vTIxWx0vZb6yhEY4NenIyOmad1dX
	YlT6oYEh49DEVqHRpuO8kpQeh+8Cwdo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7EAA6601ED;
	Mon, 17 Nov 2025 11:14:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A25C4CEF5;
	Mon, 17 Nov 2025 11:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763378055;
	bh=a+Glbj+KjklqVqK02cJKv38+Iv5JmdqR17E30pDPyGg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d+36XpUkgooOOplYjFcXSlkiRz9QJ9mw3TH5MHjiR6eSeLeykbimRz9eODBPmYD4f
	 Ej5+lc/S0OkUv84FBV83fgl+AKDrJNl+kGSPHK549sQ8fWypqZkB4JnN2UYUeJDApu
	 7qry8j+l66Ji7mT8iOgQWAU2FD9W+xkoybuLpEhH/qyA0gfSxOzw7azcWlz9JWNXTP
	 64UKmeUlQIpxjTIydSTLHMsFBE8EQUgngt5ecZ0+6dOCpxMKxShHCRMDZ3UQICc2Vb
	 xy5Os9Jr0mPExUf8Ubchkkc3k4+8GbI0RUjVMScWeibdxclYKM23yJpGreGXsCilWw
	 XrlAzdRBdVg7w==
Date: Mon, 17 Nov 2025 13:13:51 +0200
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
Subject: Re: [PATCH v6 20/20] tests/liveupdate: Add in-kernel liveupdate test
Message-ID: <aRsDb-4bXFQ9Zmtu@kernel.org>
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-21-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251115233409.768044-21-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8826640013
X-Stat-Signature: pxqo4wppqx11ztki9457kwsc68pjm961
X-Rspam-User: 
X-HE-Tag: 1763378056-514541
X-HE-Meta: U2FsdGVkX1+n+BEmcHRmltr1Qul4xxxTQjVZbFGeQJZIkdwaav6gigxMxLkG0p9SFEOOMSxH9ggmPJuUQLnIJa6AWFRCK/ZslvXZqJpFxz+4PexA1MXuNqo2BY8abJ2V0PZ+fLsTovYj6ewaZVq7MPA1YT51AGo6pJY3QK7CZ/HeZ+V2Ayg9Txa/qmc97yzmmgrITv0A0Nxln86yR9xL91ctyPXKlj752+/LcudQ6YEqibkNecxmS5lUEyF/PxWs3OgaGwiMIaqHeFWU0cF2hMpXIaikykkHNxvwzdFCs3CxY1gq15LkJ0yTD+vsh5T1R+nK4/YUTxrGpfKWq43oOTExVkLlT+bB711UzFy/hI+UTeHijkFuGYJfTzpeKU1TXK5+dpNl3ITt+9gkwcIDPJ2/KvHANJkhpXFuIZn/Q9t2EF6x+ReOjvMaB/F+0gme56BS8PoSx7+8CYRgB8RSkA9qglOXjPqygW8ns1d2XakRYImL+c1U3SV05mvSoLYiJDWRcebApVypBPPMkcOpspA0rqkNACVfwp4RE2yAmah8HLhMMFr35h2hkXFQmiIjX+Jni0j7zs/Zq9VDiP8eztX4zcYV1gngzl/vXpgbtpzgAVtzMK/LdEiOhS1e/aWUUv4tuSF1f/M7X3S4MCf2D7kPywSpSpCZu/BX0jLZfCkUOwCLoAtBYwt24llqYA8W5FIPcb3fEGElh2eG0rvhP7lv2CnOPYVe7BYaTdltJgHidY44PIE30MxTAjH3jySYLC7hVRPEVxELMON2oqUlY5iBN1A78S4SiIyni7a4RJNC3XJW3PT/kjNyESiIo37K9yhk9ruBmeIXZWky1Zn3dAJd17cyI0cyJCOA8JzRGOfkiqlu9/AUfwzWVIeKH5+npugLRCu0RzHHGALtIO8HS66Lct9bWMp3aDbURgufOitaVu3Hg9ziC/27BEv4gOYz+Hz3tjKzXUVjphpjkDq
 lNnzBcDF
 ULP64iFUHjQAxproCcL0cJiIC7CzG765bTKaS1GN1PdUX4zXu0SP20cepyzzScgtijejqqo5v3XHZtbFyMVqXePuLNNyntaSV/Rn/m4IBuY54x/Q7KFMoGxotSsr8mBmdo6Ym2xKRvkeHumQMgo0MCOadTzqcywkHCyrB7uqkc+cMmgr82J90iEOyFzkzJ4m2RDInSZgmjdPl5SPbXj+/1XidC1DiGnThZq9cosewo+l2TVQuuUjd/6uomkZ949ETFShpl1JHreVi/sHJHeroUeQSWpnyGt93KQ5BrlRXMdU/isADIXtz7ycq9HSypd2gedvRsEz7f9Gkjb/7RyAlV1BqB6XUY/vFDrMCO3gPqCAEsfQkTZHIpiPHDcyKWChOTsn1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 15, 2025 at 06:34:06PM -0500, Pasha Tatashin wrote:
> Introduce an in-kernel test module to validate the core logic of the
> Live Update Orchestrator's File-Lifecycle-Bound feature. This
> provides a low-level, controlled environment to test FLB registration
> and callback invocation without requiring userspace interaction or
> actual kexec reboots.
> 
> The test is enabled by the CONFIG_LIVEUPDATE_TEST Kconfig option.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  include/linux/liveupdate/abi/luo.h |   5 +
>  kernel/liveupdate/luo_file.c       |   2 +
>  kernel/liveupdate/luo_internal.h   |   6 ++
>  lib/Kconfig.debug                  |  23 +++++
>  lib/tests/Makefile                 |   1 +
>  lib/tests/liveupdate.c             | 143 +++++++++++++++++++++++++++++
>  6 files changed, 180 insertions(+)
>  create mode 100644 lib/tests/liveupdate.c
> 
> diff --git a/include/linux/liveupdate/abi/luo.h b/include/linux/liveupdate/abi/luo.h
> index 85596ce68c16..cdcace9b48f5 100644
> --- a/include/linux/liveupdate/abi/luo.h
> +++ b/include/linux/liveupdate/abi/luo.h
> @@ -230,4 +230,9 @@ struct luo_flb_ser {
>  	u64 count;
>  } __packed;
>  
> +/* Kernel Live Update Test ABI */
> +#ifdef CONFIG_LIVEUPDATE_TEST
> +#define LIVEUPDATE_TEST_FLB_COMPATIBLE(i)	"liveupdate-test-flb-v" #i
> +#endif
> +
>  #endif /* _LINUX_LIVEUPDATE_ABI_LUO_H */
> diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
> index df337c9c4f21..9a531096bdb5 100644
> --- a/kernel/liveupdate/luo_file.c
> +++ b/kernel/liveupdate/luo_file.c
> @@ -834,6 +834,8 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
>  	INIT_LIST_HEAD(&fh->flb_list);
>  	list_add_tail(&fh->list, &luo_file_handler_list);
>  
> +	liveupdate_test_register(fh);
> +

Why this cannot be called from the test?

>  	return 0;
>  }
>  

-- 
Sincerely yours,
Mike.

