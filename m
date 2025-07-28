Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE878C87FC9
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 10:15:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E1926B0099; Mon, 28 Jul 2025 06:15:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4929E6B009A; Mon, 28 Jul 2025 06:15:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 381896B009B; Mon, 28 Jul 2025 06:15:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1F86D6B0099
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 06:15:01 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4CA3B1D8D6E
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 10:15:00 +0000 (UTC)
X-FDA: 83713265160.14.D83CA76
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8700F120004
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 10:14:58 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mWPJg6TU;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753697698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5mSl4IgZXqb1kR85wgS9E3HNg++J1cDMaQlcJtY6LSU=;
	b=HxVZznuLcwBAIX17lnJVaDHJ508qUuN0N2eIXQiZ36Ai7mh6Og8+ChCNc80p8gPVmSPill
	nab7sib0V5nBTQrImmjMiL8vCLdRJgs6/Nyz7GesDzizK/RsWdPR5CY6CjVMy/V6j14rye
	n+i02vvreOg54X/wGGKnRwBC4l465g0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mWPJg6TU;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753697698; a=rsa-sha256;
	cv=none;
	b=TmNEH1TQd8f6MC7ALtCUnOgLo4yA6RHxeASP7zYMvHaC3Krgf1DtzfklwLiHuRja/gwXGv
	Ns9idXvQ7TfFB5GQrwwmVUq3tQztiKri7E7opQWHNlsbTtW4Fam6A6qZSO4X5D72BA/zIx
	8wQId5B/q0v1YO0uUxN7QNj/Kh7NC4Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 725EA45C75;
	Mon, 28 Jul 2025 10:14:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B98B9C4CEE7;
	Mon, 28 Jul 2025 10:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753697697;
	bh=Qmfdssha0pQC/Q7+oh1hSuVB4LZ1IZAFEMrXqsQ8Udg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mWPJg6TUX4DvdY/7ZlZ5rFSxlzfkXMLo6Y+4tJzAIpixUbN/1b3g/3LhJwM+QGT9V
	 uJpNPDJxKzps8hBfVhIw+Ar253PhuhPH9XqK2iBOH8H/iE3BNaN7/eYIvJHTaNXjQa
	 hdOnEU/6eYupi4bro/sil1dpHZNrjqHO8dowC+2pGzJfK08C+xlUFj5fKXMjTle5HQ
	 OorQ9lNK64e0YUvB+ZA3x6Nm9sGSfI7n4gnFt1wkTrlRxQn1+aJb/DV1lHvsH7vOI/
	 2HOKB28YAvJ+GbNzrz7lc2ML3PQpAjmBievnS9vJgT7vMaSMHRWuBoWtZYeBVnw0NN
	 l3svxY9hF4UHg==
Date: Mon, 28 Jul 2025 13:14:31 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
	changyuanl@google.com, dmatlack@google.com, rientjes@google.com,
	corbet@lwn.net, rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com,
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org,
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr,
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com,
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com,
	vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn,
	linux@weissschuh.net, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-mm@kvack.org,
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
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
	leonro@nvidia.com, witu@nvidia.com
Subject: Re: [PATCH v2 02/32] kho: mm: Don't allow deferred struct page with
 KHO
Message-ID: <aIdNh-qqSqSUIr2V@kernel.org>
References: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
 <20250723144649.1696299-3-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250723144649.1696299-3-pasha.tatashin@soleen.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 8700F120004
X-Rspamd-Server: rspam06
X-Stat-Signature: 8mrupdwtns5fhi39f7bzcuprqb3ruyc8
X-HE-Tag: 1753697698-70018
X-HE-Meta: U2FsdGVkX1+W84UejXViVc8jBfxawQJQMzoY3KELil3iaKR7ZiQTpACZwywZJHTI6xQOrQPVLziAwhQBhlgUdxJpfl043WtD5wH+YNnrSvRbuCHVzcdNtFkC6x6PfutVJyA9ECSrBIzrTW4jxbN52rdFKBHpkLMfll0vxim9WqrS/nhaR81VVwtUp9m200mAlxC1X6D2Q49ZmrG1tAqvf0WDZCrXzEVIAUR4qByi9LT5we8TFER8WjM3kamJUH1nTMWDZtkxaQLYabGfKbmkPMcns9IZLu2lMoWQxib1+R+g+eWppLMo6fGbHuqY5u+8aiCHGmIEWcqoGlrUneuulrWE0R3v0qJdXH0kNhUGbhhJY3QwHJD5/74zU4vRRO8nAPGy7Ow5OuSjHTZ3ig0dQn/eQGewzhlPCXNg9jp8bEYVEws3EubdtL0fqtvjEaAaEAHig3i9kpRYfP2tUIoAWr/wLoZckoi7GURsZe5TdNeH0kYD17Ca6XQtK0Pi6BtxpNVlYbVSXdsPfiuIEpAufTLEqcXSHdeGFPf+nqIvJcP4WXIVf5jgrkX/ZPpTOeESg0mtKoCfdTzLorF/gnVHhVgFhsMEI3SGxDnHPVn55x1zbgfpaYOApPsEdpDDF86yRtqiQZr8KP4UWySa1qR/fGFu7qp2U2WSDygJ2oUdNBrcWkR9EfTxjHtVHMI8zRrl2iYwg2Tb64XMSLDlw56aHata6dW0FGuO/sfvtHdTpN+Ow451Uky+pEoHZ5tW2nm+05bY/GI9HOkdcavLDVKFDTPSUxiATmemWn8lTCmIeGmBuggU1I05M81kfG+1doipUEwdJaFuWJdiuF/vYfan/2Ww147Ws4cK1V4oYP1k+KHxUk18bIHxlZ4vlkQQqvuHeGSbflPXCzffTIv4dnvA8Lck2m0ySnYCVrvXy2i8QjKKis7VEz2ZXM716n1ehT0qxXltYakAt3bS9KAm4bT
 Mhj+QoV/
 tp2nn0hqP4PV6KdDdjRYdN94sO8oAGvZpllYBu3zZafHUUNrTIurzRDiCkL01/g/fAVGriOj0BGp2foWfpQ8z5HfsvzWGXGG4vb7DRM9Pv/iy4GUI8eNrIi9EXyfIXoQ/qxXC9OS3pmP/JXYOFyU4vN/pmZ+AaFzh+Uifvpq5WfM7dwuf+I52tpIMN8ZSs+eXX5ZKQIvA8PnIDkFUn55Y1mdw1dTGbbBGu6l3f00lYbGiYwdIjAMEfGj4yvnclnoAVKqrrOADgTnuFzdOwNIwICs5LhwGnAyjxCfPt8fvvwOVzSrhNxqk+7Ssm73HuIDGpyjMxPVc8/uBpnCF6D4LzUDbP7PaPxL7R29emGwNvmna+HxusYTf4JD56uGRgVBHJG0kw5/Ffk5kuxKyUIvoERdNmg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 02:46:15PM +0000, Pasha Tatashin wrote:
> KHO uses struct pages for the preserved memory early in boot, however,
> with deferred struct page initialization, only a small portion of
> memory has properly initialized struct pages.
> 
> This problem was detected where vmemmap is poisoned, and illegal flag
> combinations are detected.
> 
> Don't allow them to be enabled together, and later we will have to
> teach KHO to work properly with deferred struct page init kernel
> feature.
> 
> Fixes: 990a950fe8fd ("kexec: add config option for KHO")
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  kernel/Kconfig.kexec | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/kernel/Kconfig.kexec b/kernel/Kconfig.kexec
> index 2ee603a98813..1224dd937df0 100644
> --- a/kernel/Kconfig.kexec
> +++ b/kernel/Kconfig.kexec
> @@ -97,6 +97,7 @@ config KEXEC_JUMP
>  config KEXEC_HANDOVER
>  	bool "kexec handover"
>  	depends on ARCH_SUPPORTS_KEXEC_HANDOVER && ARCH_SUPPORTS_KEXEC_FILE
> +	depends on !DEFERRED_STRUCT_PAGE_INIT
>  	select MEMBLOCK_KHO_SCRATCH
>  	select KEXEC_FILE
>  	select DEBUG_FS
> -- 
> 2.50.0.727.gbf7dc18ff4-goog
> 

-- 
Sincerely yours,
Mike.

