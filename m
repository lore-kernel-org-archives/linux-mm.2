Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 928C8D58CA1
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 19:47:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF77B6B0005; Sun, 22 Mar 2026 15:46:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C81076B0088; Sun, 22 Mar 2026 15:46:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B49126B0089; Sun, 22 Mar 2026 15:46:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9F6206B0005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 15:46:59 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4B59613BB6C
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 19:46:59 +0000 (UTC)
X-FDA: 84574732158.11.69C415B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id B9898A0002
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 19:46:57 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vIa1NAg6;
	spf=pass (imf15.hostedemail.com: domain of ojeda@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ojeda@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774208817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bTmPP8OnLqeiExMy5beFcuohfgWt4dpRZ1DWTpf3YZQ=;
	b=gMa1H00gIOGqsYYXfp2qFWftaCBJ3B0qStyKy5IWCsR/dVnjqkVMRHtEiudYEboWkZJ5HL
	Tf/rD2ej4RWvaMhZVtqGoTU4nOxsjV6UgcsytiDtXTisbevmtqnp+BGERAZR2F0bD2RN2U
	bdwewROw6iDKrvIUd3DFmDzuCwXurUw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774208817; a=rsa-sha256;
	cv=none;
	b=dokvDyp7O1VQu7NseALT/SXbUz6pZCVZRV3lWBnhtprub4RZTZ3lDqpneZZ4rcmMLbMVj6
	q7tE4M9PzQnWwZDsxS+M4GyjqiLFqED44tCpwPWUHJqSdRuLBzuIzqJPn7oGMwPFIAQBKO
	eRi85yhtp+MtthUBqx/1tqBg7pTL1/M=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vIa1NAg6;
	spf=pass (imf15.hostedemail.com: domain of ojeda@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ojeda@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0257A60008;
	Sun, 22 Mar 2026 19:46:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5E6EC19424;
	Sun, 22 Mar 2026 19:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774208816;
	bh=1o+jeVIgTmIEnNI1PbynIhcC+gTd7dWDUEQ66WQ3SEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vIa1NAg67V4CbhaU/2J0neghThBo4k7QPXUkypKgNLrBdUC1+6bKq11fPhBcCBQKr
	 6POM42bjrnwCLw9SComR95paL974H2Hte8463o2aLUAyXHR4mPRLjhWooIWAfANSk3
	 EmLbZAQ6wZgDom/KBs3EOE6zqYx4M9UNAOHEs4w2qOz6rBm+gyBAu4aQFjyg9lglLP
	 wLJPP1a5I13OknAV72tZzyK+X4adG5wMzHDq77K0vmouUahPu1g8IavcKcFp/wVaHx
	 5CntxUA0nUHEEM/KLptxAsewn+VEchWkcF5OforQ4OI0xzTI9du+HyNP1VvV79DNwC
	 Ejo0iFDdhtrRg==
From: Miguel Ojeda <ojeda@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Abdiel Janulgue <abdiel.janulgue@gmail.com>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	ojeda@kernel.org
Cc: iommu@lists.linux.dev,
	driver-core@lists.linux.dev,
	acourbot@nvidia.com,
	akpm@linux-foundation.org,
	aliceryhl@google.com,
	anton.ivanov@cambridgegreys.com,
	bjorn3_gh@protonmail.com,
	boqun.feng@gmail.com,
	david@davidgow.net,
	gary@garyguo.net,
	johannes@sipsolutions.net,
	justinstitt@google.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-um@lists.infradead.org,
	linux@armlinux.org.uk,
	llvm@lists.linux.dev,
	lossin@kernel.org,
	mark.rutland@arm.com,
	mmaurer@google.com,
	morbo@google.com,
	nathan@kernel.org,
	nick.desaulniers+lkml@gmail.com,
	nicolas.schier@linux.dev,
	nsc@kernel.org,
	peterz@infradead.org,
	richard@nod.at,
	rust-for-linux@vger.kernel.org,
	tmgross@umich.edu,
	urezki@gmail.com,
	will@kernel.org
Subject: Re: Re: [PATCH v2 0/3] Inline helpers into Rust without full LTO
Date: Sun, 22 Mar 2026 20:46:16 +0100
Message-ID: <20260322194616.89847-1-ojeda@kernel.org>
In-Reply-To: <20260322192159.88138-1-ojeda@kernel.org>
References: <20260322192159.88138-1-ojeda@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: eh7hxrnggmq4hkj6x3ekduwpg3s744sq
X-Rspamd-Queue-Id: B9898A0002
X-Rspamd-Server: rspam03
X-HE-Tag: 1774208817-828978
X-HE-Meta: U2FsdGVkX1+T1cVIBjrdCz3XuHGq5FTeobz8gmVXkSN88U9z2dHqisx3bhaZyRe2SOOqeI2s+u9IViMzyhLdEOaWLWEn288WF5edBUVarShSIwzJ9ehflfiqGDux5+1dOW3T5MFXq8YC351Afqh4lcCQiljwwvvywGbqZttf8QqSk9JUieMc/oV5rv/48nZAzSwM4YgUPN3iSYScibfS0HV1gCy6rFNIDRZDIjO8G9UZLKncN8eDJc6DRhxbiCGTie0DclZx0zGNw4Zu1UYSCPMHKVyTOppvh6RvcZGM3HrSHps+f3JhAjMP+yHITFtFY/V1mhnvEsfPo/qojZGsYMnVtzPj8BBTSm9/Vo99+wCQQ4YY4eBBcU+3Q1jY7WLpzw6Ggs9kMieh/RDSwWzSKQbwVrm9Znb3gi7/l2a/o6TIs2iLqcfTZJeVlLIEda6UoM4QLDNKSZuTA92dbF2LQCKdKIgQxQRWivmuG8atPkoe1tzQ/gcDqbeRHETa26thzfJ46sDPIO/dPgnqOe34X/BJZZNo6NA9EBh4y2UFUxmIiZGeo7unbTp+mR5u0yb0RlLRUAEuxY9e34Q+qeZwV2IUJaj7wiL71edRPKPrlWozYzo2xmLwstJaEO9TfPdgb088MqM2/4xmUL18sImG8GhwNrCV4myjk4Dt0pU5TPUqX1mHVcVrVoTEPjq/USDb64Yg/UCxv6uaWhG6wpH990XGmfjSfHSWMkJA5W8wg7kQo9qWhqJ/zOHh4eEdxF1eI33SJhVKmpZp1dri1MIXghUiE0vqVEe1FKmJXlbJIFU7kDrEoz0sQCzyDlfYHofAg0ZLj/d5ikHCodp/MnkFVfTCeAsD/n4WK+sE+GK6nGsXdm4c+eo/cXEXQaXff7rWdPtUWDdPFjhENke0YGQ7x9ruZBNi8jb2127icOrC1WUccPU+aL8FZgipWBiQVhDVpMoon6g9EEQ3kMdwApc
 J9ZxvQi9
 VGj1x1nua6hAqW6kAgVqYGchyTkQaHRzmIqdOnIrWZpX1k9mil8LA6JXE0GGGYqxi61cdspcR47y6pRGHpupN6jhz9owUmZgdOZp7gCfx/UkX3jvV6zQ5wZkdbCDu7ODxR8S82o3xR9/PI8BXbPvcbGKTJkk37pfjSFQzTg1taLTo50SqmBuLahYD6Tp4eFxOLkrJtQTirhulox53yPChTq5GXGChp7h22zV7qzOo97aU/XsLuGZ/v5BjzBJYREKcrrSKi7Lu0q9zCkjkrp3jTCwyTvhj6BzXMVfGPuWfspFA3CyCW/94bQUkjNFFZZaLxi1PLakTOfe2wE0fTik46juojg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 22 Mar 2026 20:21:59 +0100 Miguel Ojeda <ojeda@kernel.org> wrote:
>
> I will reply to a couple other bindings in separate emails to avoid
> spamming people too much.

Under UML, I got `-Wstatic-in-inline` for `dma_free_attrs`:

      BINDGEN rust/bindings/bindings_generated.rs - due to target missing
    In file included from rust/helpers/helpers.c:59:
    rust/helpers/dma.c:17:2: warning: static function 'dma_free_attrs' is used in an inline function with external linkage [-Wstatic-in-inline]
       17 |         dma_free_attrs(dev, size, cpu_addr, dma_handle, attrs);
          |         ^
    rust/helpers/dma.c:12:1: note: use 'static' to give inline function 'rust_helper_dma_free_attrs' internal linkage
       12 | __rust_helper void rust_helper_dma_free_attrs(struct device *dev, size_t size,
          | ^
          | static

For some reason, `dma_free_attrs` is not marked `inline` in
`include/linux/dma-mapping.h` to begin with, unlike the rest.

Unless I am missing something and there is a reason for that, it looks
like it has just been missing since it was added in commit ed6ccf10f24b
("dma-mapping: properly stub out the DMA API for !CONFIG_HAS_DMA").

Do you want a patch?

Cc'ing Marek, Robin, Danilo, Abdiel, Daniel, Andreas, Christoph.

I hope that helps!

Cheers,
Miguel

