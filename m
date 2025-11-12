Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 806ADCD4845
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 20:39:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A813C8E000A; Wed, 12 Nov 2025 15:39:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A58DF8E0006; Wed, 12 Nov 2025 15:39:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 995B78E000A; Wed, 12 Nov 2025 15:39:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 82FE68E0006
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:39:28 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 11B2A1A05ED
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:39:28 +0000 (UTC)
X-FDA: 84103120416.02.4B5E330
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 589DE2000C
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:39:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kW9YbLhr;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762979966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YSnF+lzHk0yeP5yB4XFlEDgQKzpBdPREx3VMhVKyRJU=;
	b=W2qIASuZhzgXPu5q2lu0psIVsXe30cVCUpCSRba2AfXlG2V06bsObYKm9jA5TGEgWeJEU7
	PbbVBlydnYFhX0EfOcZmisuTbEvDIzpjgqogHSPBRWwaaBmE2sQTuSd5ibSp9XhnASJOwy
	K1F9w7Omiv3W8PEyZ6q4czqJxbQcL1E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762979966; a=rsa-sha256;
	cv=none;
	b=Rmi44QmPfLwkd14toGs9BZFMZbJMltB7b3EyekhirzA68DsyDb+ZSBOgevxYHB9woP8dPL
	t6XyAF8AS6JQLnxop5MTTc5LGcbK5dgDdFmC1Jyy6+SolnTnnMYaSV1CG3OxCt093/kRMs
	1R3EtLarp4gk10N/Ok/z01oNlv80jnw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kW9YbLhr;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6022840831;
	Wed, 12 Nov 2025 20:39:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14BFBC4CEF1;
	Wed, 12 Nov 2025 20:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762979965;
	bh=OxUaOMJTFxWjdG6kL/CBz/1/5fyiG64oUzuOScdyhFU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kW9YbLhrr+3qw/niJQupZPlXdIbDjOQ+zg42uQ/qSVCuE5BBw8o68+t4AYVjo0MMU
	 4HdNLuNuHPxg98rjv5h+Rkzelkj7XGGas5FtTYS4Mf75HIboXJOoOs/7JgFRj0O/CL
	 QCBsyuYoNRyAGNSsj/6W1a2Fy8YEdCa1T23w73DVN2IBUSMSVb2lVLr72QdkT06DX5
	 osBB13IJSUKI/kecG4aMG0gNW8fb55KQJ3kpXNLDUHZ68q6junN1CDcxZg4f8LtYVf
	 +oYz4K/X8Gtn3oTOmRzdU4qbjKswNSsMNnJzK84ynxT42vrU5YjQxvS/8iR/zg5Lb8
	 cUkwPcqYI/WNQ==
Date: Wed, 12 Nov 2025 22:39:00 +0200
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
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com,
	skhawaja@google.com, chrisl@kernel.org
Subject: Re: [PATCH v5 06/22] liveupdate: luo_session: add sessions support
Message-ID: <aRTwZNKFvDqb1NG5@kernel.org>
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
 <20251107210526.257742-7-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251107210526.257742-7-pasha.tatashin@soleen.com>
X-Stat-Signature: i884fbez6qsa1qpd6ccf134kj1monnds
X-Rspam-User: 
X-Rspamd-Queue-Id: 589DE2000C
X-Rspamd-Server: rspam01
X-HE-Tag: 1762979966-419251
X-HE-Meta: U2FsdGVkX19qOLZyQNd98wc/zxioTmX1EfCzvQiw9zFbEGsC88ZNpwOOiKlpqSMSUZl7GArmAcWweZzBk0zh5qTbmN/+MvXUr32K1VMCH7/0/IaP9N857uj6tpICSk2GyYdKlMOlI+wjQlUX/9v4sobaFLENsTHbq/RKI0LnJYXR2bMB5o17i+W+N9daRxuUk00l+vMYde3vyedsbnxM2cuRvbwAgm+7QThN3ySqkGmX9xfIUyrGkRYxxl98anl/+MmEz/QGBPpFnIlEmBWzesR1c3ZQ8kGHs2BegjrOIMBIpbtCDbD8FLJ1yZbLgoPqyuI8tGNU27THcNBmpkOm2J5lh+TT00Q3o3TRZKOyrKPxQdOJscSKjizbX+cy2VHhpuSPZoYJcqLxlfpPMw+lKEbFJE3h+VTuLnCN7ePQ/ZalLChzjm8ARc0i2c50BTLFZk1BwU+30kHzizVVxQoIZDCEOcdV/UZkHOdAfGULYDHgyAhP/CsGaH2pPhtaHKSUJWoimMxIbnPH4d18xC3IenEN6nA5hP66yPXH1xQ1x+dyppL6ahsL+4RRmHEMXjzsc/saps6bLeeIO5qgqsvCrJbZDMsMasDXqkFlqrMveFIkxzjMaCzJv2XjdKt6ajRe5H9cCYLtwDLBV9S9op8vOGuaX8TS02uEXUi0nASTKbDNCfdhNga8Yz941+FQ5cm+g1y+AUIeKtqJ8Df+VgJjquFrYC4bSDlNpzL0N959vK3bXLtuN4Js/tvqbtexNwGsTfV9Y7udHpnao8DJhEDkMwALGIlFG9x+ppZ0mbk6a7nM4USz/UEGWcS/e7GIn2qWX4XBZVYVnOCCUjRZJb7XTw4C98DnT6M3eylSMztXw8R4+gQJUD4k2y3/bhNLuHt2alt+oDnz46I/msn5pOyHxq7IF8wJAIx6pzNnkXnhDe2zV+N6mAc4JClbgoUMRUqAaTcK0MxC1GNF+j30uLZ
 F6NzGa3a
 FhggOJnv1e4kcz3DfAqivGTMXiOX6drSzbLO5wmX0D5mGPb+VCfMoAHwRQTLucDfigagfu1mjYR3RH5D4QaSxs4u3Ezt3K8cp1EY5xWKgpGyMDhEauTF5HVL+d+lu9RYbLFovM4I7n8ndu0l/CmhHpZCqhwIOzuFrbqdrpwBn5TKTu/PzZlejwsCoukheUGFkyccxanut3js3PMffHLbL3iVUZ6LdfO+ovWo9d7kQMtTduWi4LsGFWoIoNVBtY83fFmRdqGluzyeYPP8Y5W9k14T+TsJ/il+j+3xOaqILJfw2fEcfFRTCFVgF89bDXmzautsZcnzegxQg9rSc2O65g8fKK56xgiQE/Q/LBDBcwbcG0BvtBWH5IJ8kNcy6yMOClR0JJxTXV7qWycs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 07, 2025 at 04:03:04PM -0500, Pasha Tatashin wrote:
> Introduce concept of "Live Update Sessions" within the LUO framework.
> LUO sessions provide a mechanism to group and manage `struct file *`
> instances (representing file descriptors) that need to be preserved
> across a kexec-based live update.
> 
> Each session is identified by a unique name and acts as a container
> for file objects whose state is critical to a userspace workload, such
> as a virtual machine or a high-performance database, aiming to maintain
> their functionality across a kernel transition.
> 
> This groundwork establishes the framework for preserving file-backed
> state across kernel updates, with the actual file data preservation
> mechanisms to be implemented in subsequent patches.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  include/linux/liveupdate/abi/luo.h |  81 ++++++
>  include/uapi/linux/liveupdate.h    |   3 +
>  kernel/liveupdate/Makefile         |   3 +-
>  kernel/liveupdate/luo_core.c       |   9 +
>  kernel/liveupdate/luo_internal.h   |  39 +++
>  kernel/liveupdate/luo_session.c    | 405 +++++++++++++++++++++++++++++
>  6 files changed, 539 insertions(+), 1 deletion(-)
>  create mode 100644 kernel/liveupdate/luo_session.c
> 
> diff --git a/include/linux/liveupdate/abi/luo.h b/include/linux/liveupdate/abi/luo.h
> index 9483a294287f..37b9fecef3f7 100644
> --- a/include/linux/liveupdate/abi/luo.h
> +++ b/include/linux/liveupdate/abi/luo.h
> @@ -28,6 +28,11 @@
>   *     / {
>   *         compatible = "luo-v1";
>   *         liveupdate-number = <...>;
> + *
> + *         luo-session {
> + *             compatible = "luo-session-v1";
> + *             luo-session-head = <phys_addr_of_session_head_ser>;

'head' reads to me as list head rather than a header. I'd use 'hdr' for the
latter.

-- 
Sincerely yours,
Mike.

