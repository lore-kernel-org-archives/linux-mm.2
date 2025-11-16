Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFAB1CD4F3E
	for <linux-mm@archiver.kernel.org>; Sun, 16 Nov 2025 12:43:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E83788E0009; Sun, 16 Nov 2025 07:43:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E33798E0005; Sun, 16 Nov 2025 07:43:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFB728E0009; Sun, 16 Nov 2025 07:43:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AD7548E0005
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 07:43:58 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 38684C093D
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 12:43:58 +0000 (UTC)
X-FDA: 84116437356.21.2882B3A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9D6FC10000B
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 12:43:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ieh1SlTX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763297036; a=rsa-sha256;
	cv=none;
	b=kuTELM/N3w3MbiSAha7psQoYzdMySb9jcziwoZlNLamClxfZpq3r1r/imDc161r/VdzOm9
	9Svhn5YUTUDZ9Lj4oSttIyOGCPtfV7gP+La9kaBNAmAR3qIaSouoln+yWkjhpgF9YjLAvV
	8T7gbQr0kVkgWT9an4v17EXJgG2J8BU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ieh1SlTX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763297036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fI614ZEx3jvWeHNeVx6boNFaVRfGcX6oh8FysF0hCGc=;
	b=wHZy0TK//xrJ0tQqn4s1d0jfwLAj4E/dvSjGtzZdmw7eoQytwQy/9xe2inGukiFxT41oMN
	D1/A2/8cP29lA1tbOj4k3HynIBwYenX7ecTQOSVn47dY+TxrKeivOsV1ZF2nYyo8phfEo5
	1xKVMHFh4FljsuOxqGkDNVRp0AImZIE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DA43860147;
	Sun, 16 Nov 2025 12:43:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C659C4CEF1;
	Sun, 16 Nov 2025 12:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763297035;
	bh=wWgCpDj9fkSDw4SXrRucTxci3O9QnA85j+Vg+gKkTZQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ieh1SlTXRyDrT+ZZELMQ4or1AmZFhWxyj0uZvf0u87CtZbeGdiEpozUfnNNr1l+mb
	 sMrREnOzqiH3M4E0YXtb4+WG+/Tn8ZbGqeMJxNZK2uu4C0EPHlmGSBtACovs10gEaR
	 dbIJvUIgAOALfJHE7yK/czgKIPoIma6GCIhWXV74j+3uM3Z8UY8R/EqXgcGrEQl/GG
	 dl9EUPpRD6FQMFDPDUEhCxjwC4KPkRq+y98WArsZWKSjf7/AuHH9IF4TVYL3qbB+5C
	 Pf262w+HheFYjusQSjF7Z5PIClenH85cNiEddYc2DBJxABYjoDYbtHZbpgH7fvHatP
	 vzplMQ3ly0JNw==
Date: Sun, 16 Nov 2025 14:43:31 +0200
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
Subject: Re: [PATCH v6 02/20] liveupdate: luo_core: integrate with KHO
Message-ID: <aRnG8wDSSAtkEI_z@kernel.org>
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-3-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251115233409.768044-3-pasha.tatashin@soleen.com>
X-Rspamd-Queue-Id: 9D6FC10000B
X-Rspamd-Server: rspam07
X-Stat-Signature: xrnu4rhac7dj9kyrhp974wp6qgxnx5uc
X-Rspam-User: 
X-HE-Tag: 1763297036-102656
X-HE-Meta: U2FsdGVkX18MmvuZl92oQ0+hS1Dr/8TFgpol4xj52o6mz73sZvn8aG1LXHlUw0e/3+LcdeLAwdhsQG+gZoENZ8/q1VTOCxZF8rxoxvPga9SrB6MciA+fP4o0rImaE6+c+rQ6wS8x2/O6/gbezPeaH78cp1GmF7BN5D5/1JJxKwWA8/azJgjcijwYjQGRV1vjgnUNOYVIEpjf3PXxPalI7B2eqRFfu/ejCFTOF8N83+f8MvoL2N/RzWjC7mvNekRBPQ5/XUNufzW3HgW7XqnFUSwvsniNSyV2a8Xm2o++jo2NoVG8mcn9cXws6IrjsBSuxFCxgUAS52ZOQnNtzlQHzmnQ1us2rPBff/SOR83YUPyCZtJLq9UzdY+39oGiohO/82L96nX6/PG2Lsh5RIjkwb46GyWXuE7YQKbHpEP7oCx2l80Jcogx97LbpQRHFHUfNorKngjSxLLtXU5ksPtqov2lpUqpiAEJ7SyD5HcC+EPjBCEKBz/PRdILlvhE465IFOY5ySPb5abF2Hy4mDBAQcmVfEMJguwqYqbqT6oJ0NIyqllBeCI7+JnHt2HeLM8dvjKgX1TLK1wzyks6D8c2Ih8+jeJwB+Ay0lZjMxnPIDSL7uqSlTbAHWF0W/3ACHg/9rPFXgf0AUEEMecx+n76iPjaT7PtQPlY9FV28C3Truyi5bMgE+5OZFsK7N76Ya9qeo0HQNRIbxtziCp/PQlkHQZNuylS3Px73OXLtR0AnCAZjKpplL+hzS/glK/K7YHO3xK8SoN78Z8Sle4AZIlt5YLdrWPaiF9KfdbuZoYvXDm2BChO1YRPFgPkCFmjeFk9tSXML7od2OlxOND2CC1zp0gU9KzRtyWLSCoxMFQS1COS82BZ6LPe9wKIMTBkndeVhysRzWPx1tnG+xGm0to5++c1VFu2a14bRsBYZ0BuQ48GE3NJ+hz9MGN/tlrfvEgCpJW772rHbtY41qUSYTv
 VDDX8awA
 HavtrKRQNnJYQKRxpqbPEW3coXMIyWNn9XWCL7gkKpWgf5Ybl4YvAkra/cjDaj1t4onxn8XqnB261MFjsXkiwsOwB7k9rKNnlvcBE8habhv9AlFTqyLALioODQjPVWsBY1Qg3vHurEBAU2SYIRGMhDt0dfm53K4u7Flx9SXhEg7MXmg7lQxqX6QgtsvuJmJtbFONrHzy4ohqDvg9F8xQnW5hcR8jX+mfb9gKg9pOiV0AjBK4EC9aiTU+4NykeUVrlGSOkE38yPa4O0hmtJkoToBRrdDSQsP0GM82IZbr2X+Hd5h5Ip/T7v5UyouUuHB5YGUSZk9EUNrkkn6W0nEMqcOKbyzphc5DAK/cpZVnlE0bROuxVAQFyEKaB2aF2C2bkWm6tssnznWJudFo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 15, 2025 at 06:33:48PM -0500, Pasha Tatashin wrote:
> Integrate the LUO with the KHO framework to enable passing LUO state
> across a kexec reboot.
> 
> When LUO is transitioned to a "prepared" state, it tells KHO to
> finalize, so all memory segments that were added to KHO preservation
> list are getting preserved. After "Prepared" state no new segments
> can be preserved. If LUO is canceled, it also tells KHO to cancel the
> serialization, and therefore, later LUO can go back into the prepared
> state.
> 
> This patch introduces the following changes:
> - During the KHO finalization phase allocate FDT blob.

This happens much earlier, isn't it?

> - Populate this FDT with a LUO compatibility string ("luo-v1").
> 
> LUO now depends on `CONFIG_KEXEC_HANDOVER`. The core state transition
> logic (`luo_do_*_calls`) remains unimplemented in this patch.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  include/linux/liveupdate/abi/luo.h |  54 ++++++++++
>  kernel/liveupdate/luo_core.c       | 153 ++++++++++++++++++++++++++++-
>  2 files changed, 206 insertions(+), 1 deletion(-)
>  create mode 100644 include/linux/liveupdate/abi/luo.h
> 
> diff --git a/include/linux/liveupdate/abi/luo.h b/include/linux/liveupdate/abi/luo.h
> new file mode 100644
> index 000000000000..9483a294287f
> --- /dev/null
> +++ b/include/linux/liveupdate/abi/luo.h
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

I'd add a sentence that stresses that ABI changes are possible as long they
include changes to the FDT version.
This is indeed implied by the last paragraph, but I think it's worth
spelling it explicitly.

Another thing that I think this should mention is that compatibility is
only guaranteed for the kernels that use the same ABI version.

> + *
> + * FDT Structure Overview:
> + *   The entire LUO state is encapsulated within a single KHO entry named "LUO".
> + *   This entry contains an FDT with the following layout:
> + *
> + *   .. code-block:: none
> + *
> + *     / {
> + *         compatible = "luo-v1";
> + *         liveupdate-number = <...>;
> + *     };
> + *
> + * Main LUO Node (/):
> + *
> + *   - compatible: "luo-v1"
> + *     Identifies the overall LUO ABI version.
> + *   - liveupdate-number: u64
> + *     A counter tracking the number of successful live updates performed.
> + */
...

> +static int __init liveupdate_early_init(void)
> +{
> +	int err;
> +
> +	err = luo_early_startup();
> +	if (err) {
> +		pr_err("The incoming tree failed to initialize properly [%pe], disabling live update\n",
> +		       ERR_PTR(err));

How do we report this to the userspace?
I think the decision what to do in this case belongs there. Even if it's
down to choosing between plain kexec and full reboot, it's still a policy
that should be implemented in userspace.

> +		luo_global.enabled = false;
> +	}
> +
> +	return err;
> +}
> +early_initcall(liveupdate_early_init);

-- 
Sincerely yours,
Mike.

