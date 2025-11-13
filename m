Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 148B2CD4F3B
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 01:47:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C21728E0033; Wed, 12 Nov 2025 20:47:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B82838E002F; Wed, 12 Nov 2025 20:47:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AFE88E0033; Wed, 12 Nov 2025 20:47:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 850428E002F
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:47:29 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 526D989972
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:47:29 +0000 (UTC)
X-FDA: 84103896618.11.DAE7CFD
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf02.hostedemail.com (Postfix) with ESMTP id 79A8B8000B
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:47:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=ZDovSwbI;
	spf=pass (imf02.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762998447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tJUQdwbie0o7hgZvF0fBCgnf1I3C+S9yUEzkmCq2LO8=;
	b=PAEVhvgiAhcS3V6XsRZuODIf6whm8egnUV4werJ9xxHxI/uqoExW7I/nOvMIl43Yt3/OU0
	RyEVRspdoAJES8RBKU+7wnCTUpB8tmvZ7iMJhLatC27LB7KvIcw++9LVhd6mnoKha1Sv6j
	DiyUXuYeKSGrtFWNx0XUCXkN5hUX/rM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762998447; a=rsa-sha256;
	cv=none;
	b=FQKphYUmybp7d6iTxn+1D3Pe+CdH+gydhzevfoRiPkA1IznVZrmhWWNb3ACj54RyV2qRJ3
	cT5itXcLIMtrjsW8su9xd8H8RlObWBG4RZzEypsyPwlgo7m0+jBuL6jZ9uozlRnTf104Xw
	YYA9SALY50ODras27aeuXnquyZ+7b64=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=ZDovSwbI;
	spf=pass (imf02.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7a9fb6fccabso209628b3a.0
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 17:47:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1762998446; x=1763603246; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tJUQdwbie0o7hgZvF0fBCgnf1I3C+S9yUEzkmCq2LO8=;
        b=ZDovSwbIpr42CTWHwuG3pPVN694aMzK2DeSmWKDDI2+aIqACBhmXWTgvvw4bZ9egBp
         K6QwuBG5nd5Hwyp2iTVlMo5BsAu/3GZIajxzEl44+9/rdyxxJGIhym5+m1Lih8eiBnAu
         qTwloqd5atMHJTSBAn4HQyFsV2VRnJUwZ5kgQRciq2MdWWOlAvBFqdLqZlefduSR448N
         8Az+WE1JRCRzszrhHvl9HOiz/F1CFNCObKVTprRTCdwxTKVU2ihnz9bjgalhOQCKVvt8
         Nhzy5O3gSA1qcSbgdSQhMkQrm8QqezCdZAF4Cvvk+trMv8k9iXJq/9vT8CHvVRJdBUH9
         0hxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762998446; x=1763603246;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tJUQdwbie0o7hgZvF0fBCgnf1I3C+S9yUEzkmCq2LO8=;
        b=GquM5vXriK4pPAsNlekd0vwmfZmnOHalNg1oH/AXWGz3vMLJTNkZmKPkKwEGAN5Md8
         G5rKq6R9DyPJBifuezzy0lXdQqr6jgXaaPv68TpBod29rQSDDZO0ZfuZ6j8dSbzq/Js3
         ytJJNNg88HarTKIKfWySA5JpspyTrgmehP98EtrQ+lEkTqc5/wYWM/f2Bmx0YD69uR+u
         jQrcrLeJMJRmbXtwLWxMQEiMTW9foYLI3lL28TBZpjTvPL99nzl6yd9MDsjZxOVJWl++
         n/OK1Gqof+oZ0d+zeKVwXMzCReTkeZ0QzdKv3qcCDLdHbfzjwF6IXZrUl6I/v3i6JfS5
         bj6g==
X-Forwarded-Encrypted: i=1; AJvYcCXIoM/rvbW8mcGRIal6gbazC7KaKavIduSMTPwrdCozxExZCPsCerIgXX1rfw8+gdrsIzcHt7luwQ==@kvack.org
X-Gm-Message-State: AOJu0YyT4d7oZP1UYKHmFTT+VzzS1fIn6nqEpSVsnbcp71ePge+Fslkc
	y1JlYg7Muxbss6mlQbEGXh2NlR3cVdkJiIFXGerOgcB9vDiVtGVFL5KjSspiJct3QQw=
X-Gm-Gg: ASbGncu4GLSPudNL+pZ/ZV72auaYMLIHPGvvZ9Ovptp/rdiVfUU3AkwGxSfu6WsY/OP
	y7fihHKUbQNTPHTLqFDt0c/SO5AO9j30XGdPnLHtalUhRMTZxSwwQGBzEsg8lPrQ+NrkMP+bzL+
	veXDP+u9FJ8ny54iS3tCVyEuqBVaPrETbHpUJy3XJbNl+S3PRcRgYzQwNQbJ0JzSFpF4Df9tOM7
	KGxsiB5KyJj6QuDUr6AvNKX626FqQEjsIoePJWjk2NYEZlyJEZ9jHSUkUUimraJsb0RFwGEXwdl
	rXtSfktsBGfw0qjbJsyUHxoyczj48dO9QvetvJr1Kzd04ekg7ggW6D/Kwcbtoki5qTX/3y12O07
	/uLTPxlDxh6G42M6V5EZiAS8bWAQIHY7Pr1zeXCEXPaNACA6eDsMlSXpMLtiDsSgmXQgjoKFbjU
	svbuEVMWPnED7rS9tMB1aOdQ==
X-Google-Smtp-Source: AGHT+IHaQsvIpnkLWjWR0rawHh2zoCdjthdQ4AoC5mETU8kGh9msFPBhPFlU6AScOiEA10G8iQrBZw==
X-Received: by 2002:a17:903:3c64:b0:295:3e80:9aa4 with SMTP id d9443c01a7336-2984ed46fcamr62454685ad.22.1762998446285;
        Wed, 12 Nov 2025 17:47:26 -0800 (PST)
Received: from sw06.internal.sifive.com ([4.53.31.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2ccae8sm4986485ad.98.2025.11.12.17.47.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 17:47:26 -0800 (PST)
From: Samuel Holland <samuel.holland@sifive.com>
To: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	linux-riscv@lists.infradead.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	linux-mm@kvack.org
Cc: devicetree@vger.kernel.org,
	Suren Baghdasaryan <surenb@google.com>,
	linux-kernel@vger.kernel.org,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Conor Dooley <conor@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Emil Renner Berthing <kernel@esmil.dk>,
	Rob Herring <robh+dt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Samuel Holland <samuel.holland@sifive.com>
Subject: [PATCH v3 18/22] riscv: Fix logic for selecting DMA_DIRECT_REMAP
Date: Wed, 12 Nov 2025 17:45:31 -0800
Message-ID: <20251113014656.2605447-19-samuel.holland@sifive.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20251113014656.2605447-1-samuel.holland@sifive.com>
References: <20251113014656.2605447-1-samuel.holland@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 79A8B8000B
X-Stat-Signature: b7z3jsbuhqwaptxbpb3euguq47t8h4u3
X-Rspam-User: 
X-HE-Tag: 1762998447-559480
X-HE-Meta: U2FsdGVkX1/FZAqpsOGxmN7x7HRcAn2J7QbKudrbW36/x/GG54uMrXnUTwcQVcE4BShfn/+UsJ1sYwm05CUq7+qzjua12T4NOZ5iaSQHb5jACmXOh6b/0oM1b3envb+aGgrNoZJP9pQkFDv6GqFoWi0ERrbifHncMV7kpG8DLcvKlwneE0wy4CrFBhLlBGUVYNtKEeou00QEtURs1KRF4TUFnG3F4dwexF3Y9wGNN5089KCU0WRyQeKy5gaBu0xzvzwa4Q/1nMfUB3C4DRrUbhP+deJwx5hd6aZQPXA/VjI6btS0BzPHsiSJH2RqgN0+WkOOqvR3G0fGzp8sJa9Rl+Wr8b9HEb4nVS/VFMHOlNMpwIm5MnrQWWjtK6LBgUcpIh5lP/YB5LLuP6QQUfQ9vF9TM0aDt1b8HhWAWh+b2sk328zxPQaJuk64ruQuTMYo38UO8oCKJ3gJo6sepOl7jzlNji1qf2IF4NGq0Fh+rlizj5/DgZ/p6kKPhxDT6HS6sujkq6Q6uMutPJNsW4tgwovlYf5HYJWEkWGszTHBbd/o9ugeLak0PPv3CdObmAkDuxlc4FMhBQraMbjFYIBI+cXz5ZBP82q4RReesruFnxMxZ1+LIvu79/VsL5UYF+aV4b2Q+W+kzG8wlaULR2wEduMqJ94nEnKGnzC8885Fupvj8H+MKwEn3hsyk5BOir6APJo4ug3qSHeoaMNsx1Ru+BjKRWN6FZg389VrVL6FYR4ceTxA/n4KIxsgHFuzsTiylRWBLKmUlv4nCI2F496oWH5R1vOaY46htWIgYDGOyQRmnutBRnazbwaOPwjtcSoNq79ItYZm70WurBtlqnQY92WzmAZMaOXNUXGNU05tgKqhNoEdopUGppHxhtsanzSmf/goIliMXgql7C9ux+2o3bHqPhTK1zFgq6r2XLDW9iadxwV2WWCsC5Rh3ffaffj9KsAoU7sOou9B0lk1Sg7
 qjK+YUZn
 3tKLL12guROlJpghbQPJ6Nzvio+EiZ8DqdV40vAfdQZXOV061eEihhy4hihHgYpHEzSilUdCBQqcMsnunZTeV+NsHOKKt3qF/NogHfErVd8K8G+qRVQaZQ1i9AypuRF0Z8tfeBeSS0ZT6QmmcIehjFxSZn9VyxzTWQSLjZF2/vPi9btXpJck/RmIwoK2aE5k8gv4lF5kmGWPoAjsl3q7PQzFeSNVPW7+UzMVYbp9Piakz8tutga6w1Hee6y5yLH20hzcVfJuL7hlldtz5MF3yHTe0J7AX1nizQrH+rPDrkTHG4XGXUB04gPkkBoJv2CIAvlJ5qbrF0WuTcMweqqpDKUlg6KmEK+B05sXZWAE3sRV7/+UDk/y8o1Gu6PSRcyH8BMCRVCdHOoVbAsXqMmRyZoW0n2AVCjU0p8edf0zomi5N52amr4ur07IhqhaV+i5lpkZ7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DMA_DIRECT_REMAP allows the kernel to make pages coherent for DMA by
remapping them in the page tables with a different pgprot_t value. On
RISC-V, this is supported by the page-based memory type extensions
(Svpbmt and Xtheadmae). It is independent from the software cache
maintenance extensions (Zicbom and Xtheadcmo).

Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
---

Changes in v3:
 - New patch for v3

 arch/riscv/Kconfig        | 2 +-
 arch/riscv/Kconfig.errata | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index fadec20b87a8..cf5a4b5cdcd4 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -598,6 +598,7 @@ config RISCV_ISA_SVPBMT
 	depends on 64BIT && MMU
 	depends on RISCV_ALTERNATIVE
 	default y
+	select DMA_DIRECT_REMAP
 	help
 	   Add support for the Svpbmt ISA-extension (Supervisor-mode:
 	   page-based memory types) in the kernel when it is detected at boot.
@@ -811,7 +812,6 @@ config RISCV_ISA_ZICBOM
 	depends on RISCV_ALTERNATIVE
 	default y
 	select RISCV_DMA_NONCOHERENT
-	select DMA_DIRECT_REMAP
 	help
 	   Add support for the Zicbom extension (Cache Block Management
 	   Operations) and enable its use in the kernel when it is detected
diff --git a/arch/riscv/Kconfig.errata b/arch/riscv/Kconfig.errata
index aca9b0cfcfec..46a353a266e5 100644
--- a/arch/riscv/Kconfig.errata
+++ b/arch/riscv/Kconfig.errata
@@ -108,6 +108,7 @@ config ERRATA_THEAD
 config ERRATA_THEAD_MAE
 	bool "Apply T-Head's memory attribute extension (XTheadMae) errata"
 	depends on ERRATA_THEAD && 64BIT && MMU
+	select DMA_DIRECT_REMAP
 	select RISCV_ALTERNATIVE_EARLY
 	default y
 	help
@@ -119,7 +120,6 @@ config ERRATA_THEAD_MAE
 config ERRATA_THEAD_CMO
 	bool "Apply T-Head cache management errata"
 	depends on ERRATA_THEAD && MMU
-	select DMA_DIRECT_REMAP
 	select RISCV_DMA_NONCOHERENT
 	select RISCV_NONSTANDARD_CACHE_OPS
 	default y
-- 
2.47.2


