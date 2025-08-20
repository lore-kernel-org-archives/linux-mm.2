Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C146CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 08:24:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41E818E003A; Wed, 20 Aug 2025 04:24:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F5FF8E0037; Wed, 20 Aug 2025 04:24:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3329A8E003A; Wed, 20 Aug 2025 04:24:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 228068E0037
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 04:24:28 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E89D813850D
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 08:24:27 +0000 (UTC)
X-FDA: 83796448974.07.6755986
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5138B40006
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 08:24:26 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sbnMh56e;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755678266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dx/UlKEArBGyUs882+KWiBNpdfeER6qBdFtmV4pAR/A=;
	b=BoQpL+ZWyxadzeU1cNqNR/WIiGjTp4waG2pbI8I3Bb33/1XBJQq/ghc2ZWiXNj6bCUtgaP
	s3ReS6reegmaMvPNdROuyfimiG9ompzSH4PYhNh8OxTzIzEyJJuNZe2jB0LTC3AtfpZ6T7
	UGnwJHaD7V8rsMH5FR0yeRIbmi7HYjw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sbnMh56e;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755678266; a=rsa-sha256;
	cv=none;
	b=CbR1pJnLAi1yz2KcQKv4xDMxVZaIkaZtLCQThc7kAXkoyX4K13lv6noTIgecYEALO/3rfP
	Ev9ausWTk9Luq0DYcgbG/GbgecbZ40s0qAHeRNLgdPiYKE+hcgrHg28Pd2LIo/sA9UrUsG
	bI201dWi1qa78xAeueAu3QiH/KoMaAs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D885D460DE;
	Wed, 20 Aug 2025 08:24:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F1EC4CEEB;
	Wed, 20 Aug 2025 08:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755678264;
	bh=/UL8r/IY6NvhVlFJ56nhpLYKbxUYOgISlF8+SOKUMgE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sbnMh56e8KeY51vJlnHAVZISzBdTJN0LpMnDGP01/N6PsJeiRuOBNdJEqqYBftNed
	 20t8gDewYmYyxKTsvLyzMfsjnofAq089lYNh6nQ3CR2ft1qPJ8g50tWqP1VlSpFaN8
	 hv208x2hK9MsoaUUDNxpuFCOtTSxBEZpRDl9IVRq6pqYaurwMixBNn2Dap3BCak86G
	 vpEYt8K90dH4mn3ZqO2q+XO3FMm5rrL3hNEPk5m6utPgeCIDPZJAVSSSHH/h38EM+M
	 FHsjOO+A9NXCwMNea9+PBpOZpICrX0MeAfBs9XeemKoTu+mXQefKikv7CjZW5vKpIZ
	 xiWbnB6p6lCCQ==
Date: Wed, 20 Aug 2025 11:24:17 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Evangelos Petrongonas <epetron@amazon.de>
Cc: Ard Biesheuvel <ardb@kernel.org>, Alexander Graf <graf@amazon.com>,
	Changyuan Lyu <changyuanl@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org, nh-open-source@amazon.com
Subject: Re: [PATCH v2 1/2] kexec: introduce is_kho_boot()
Message-ID: <aKWGMbueQBaB5Wsi@kernel.org>
References: <cover.1755643201.git.epetron@amazon.de>
 <7043f4da31390c58bb7721a3774c30998997df44.1755643201.git.epetron@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7043f4da31390c58bb7721a3774c30998997df44.1755643201.git.epetron@amazon.de>
X-Rspamd-Queue-Id: 5138B40006
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: n9tpij4hrid5k3ruujrk13fdgs7n5mg8
X-HE-Tag: 1755678266-369836
X-HE-Meta: U2FsdGVkX1+JXIYUebGZ8kLXyXs8vYhvTC3c/kX5bZ2UZiy7FqsE9niUsyg52P7SU9g5Rk1bh7OtUMU1zeozfWd6vFTypj0KD60klLnKNfn+ZECaQO0OXALKtleo0yz4KXOSLv86xiOE8/elaxKPpiZTwqYkMHFCCVAT1F/6bqZGg/fsoKTa5P1mLZuM2rXH7m8SDxrEG9iUzyd51BZykSqdw9t+vbUWGO0X24BhasZK+SnFHFn/b8IQN34B5jFwLWa6HbluXFPBQ2SiR41OmpasycrgMpOhoM+jmYtQKmEaES4kIzTmm0RRxIT6YeXXpclsWH9VAKzGuIMj/AUcNBrvBao4JTL5MrGhEKGwx6milHvPftdx/Zv+1QLBeDJI1g9QlLmKWNsj58P3Py+5tOjXx+rp5CcjYIxMRvcLeCoRrnUzsU1Gp+lnrgVC+9Wd9Hz/65NfAfkR+GhMUOp3b7QEP6JV+BfB30OsRNVKEdNu5057o1pNTbyjqhujJu02tAq1SECEJKVHpDZ1ZpvFahXhEqOzuSV2cRBgGf+UuWYS25nm494pHgTLIdBCiua8E0VgcqDLViNkDjO1Kv7HCkMBxeuJjyl0rHfIGIlp+Ap1HmoUQTv5TOMOckDMwh1m99pDzmwVxVw/1oOLz7n+oAs2RYfrkOjfM3HMXrCyEH0uBXJKKUBhjq1Aszq988bWkCWZA9WVR8qk8XZo1Kl9msEK1jFUh1Fq/ITx3+l1QvYYzMY6RMnHKwsYp7dyA3g6znIDoCI6uoF1NPeyKD3bYEJfkhDMmfb9ovW48hvnOUhiU8RsjfbZXOpiRyO91SBk6HSTNpJiN7XUap47HY1in071dvvm2OURs6kOKvV4LSGaOHogJkLFii5r2eqwLlQywFB4sOdLw0HpT5jAA3kfyhUh5pj2Y4+fSL3+p2hOZ4qqQ0K6RJERSZ/U2QYZmXQKI0Ug92C9z2TDgEibFoy
 Ip80tzl9
 urfv2cE1bmWGIUiGyGB2sIdlvYONQEYgJ5zdi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 11:22:45PM +0000, Evangelos Petrongonas wrote:
> During early initialisation, after a kexec, other components, like EFI
> need to know if a KHO enabled kexec is performed. The `kho_is_enabled`
> function is not enough as in the early stages, it only reflects
> whether the cmdline has KHO enabled, not if an actual KHO FDT exists.
> 
> Extend the KHO API with `is_kho_boot()` to provide a way for components
> to check if a KHO enabled kexec is performed.
> 
> Signed-off-by: Evangelos Petrongonas <epetron@amazon.de>
> ---
>  include/linux/kexec_handover.h |  6 ++++++
>  kernel/kexec_handover.c        | 20 ++++++++++++++++++++
>  2 files changed, 26 insertions(+)
> 
> diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
> index 348844cffb13..559d13a3bc44 100644
> --- a/include/linux/kexec_handover.h
> +++ b/include/linux/kexec_handover.h
> @@ -40,6 +40,7 @@ struct kho_serialization;
>  
>  #ifdef CONFIG_KEXEC_HANDOVER
>  bool kho_is_enabled(void);
> +bool is_kho_boot(void);
>  
>  int kho_preserve_folio(struct folio *folio);
>  int kho_preserve_phys(phys_addr_t phys, size_t size);
> @@ -60,6 +61,11 @@ static inline bool kho_is_enabled(void)
>  	return false;
>  }
>  
> +static inline bool is_kho_boot(void)
> +{
> +	return false;
> +}
> +
>  static inline int kho_preserve_folio(struct folio *folio)
>  {
>  	return -EOPNOTSUPP;
> diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
> index 69b953551677..a1a4e76e0ff1 100644
> --- a/kernel/kexec_handover.c
> +++ b/kernel/kexec_handover.c
> @@ -925,6 +925,26 @@ static const void *kho_get_fdt(void)
>  	return kho_in.fdt_phys ? phys_to_virt(kho_in.fdt_phys) : NULL;
>  }
>  
> +/**
> + * is_kho_boot - check if current kernel was booted via KHO-enabled
> + * kexec
> + *
> + * This function checks if the current kernel was loaded through a kexec
> + * operation with KHO enabled, by verifying both that KHO is enabled via
> + * cmdline AND that a valid KHO FDT was passed.
> + *
> + * Note: This function returns reliable results only after
> + * kho_populate() has been called during early boot. Before that,
> + * it may return false even if KHO data is present.
> + *
> + * Return: true if booted via KHO-enabled kexec, false otherwise
> + */
> +bool is_kho_boot(void)
> +{
> +	return !!kho_get_fdt() && kho_enable;

Let's drop '&& kho_enable' and presume that a kernel that booted with KHO
FDT goes through KHO revival.

With that change feel free to add

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> +}
> +EXPORT_SYMBOL_GPL(is_kho_boot);
> +
>  /**
>   * kho_retrieve_subtree - retrieve a preserved sub FDT by its name.
>   * @name: the name of the sub FDT passed to kho_add_subtree().
> -- 
> 2.47.3

-- 
Sincerely yours,
Mike.

