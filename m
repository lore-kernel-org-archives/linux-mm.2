Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09481CAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 21:57:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50E358E0003; Tue, 16 Sep 2025 17:57:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E60C8E0001; Tue, 16 Sep 2025 17:57:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4230E8E0003; Tue, 16 Sep 2025 17:57:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 335A18E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 17:57:37 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BEAF111926C
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 21:57:36 +0000 (UTC)
X-FDA: 83896475712.11.3D333FE
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf11.hostedemail.com (Postfix) with ESMTP id 13AC34000D
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 21:57:34 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=ZrKD8frK;
	spf=pass (imf11.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758059855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fSsNsg94xTPxgo7mtr0vhLneaLnV1NurRaDsg6aVKxA=;
	b=nV/fgBh1taqnlOI0qNmxNTo0S1w4mMI/yxidp91+7SuqffZmMTJWCNx0LsTCrsomQfC/vj
	1EYcoqwpXt9fvixSIsea3tMMy8Nc3T8fLZQX4QKWYJvLo7Yqi8k7h58GKsXrJcAGbacpHp
	JS1xLMfyJcOmMs84v4Fs3crwXF9IfWg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=ZrKD8frK;
	spf=pass (imf11.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758059855; a=rsa-sha256;
	cv=none;
	b=lIkVIyHEb+5kvqRvE34CQ8zHaftn133sTCK3K9pvf7MYB3HskGLul3gvf4bhXOhNfo6W8x
	MvZ2KbojLuaKodC5M8llqlIXUNalNsv69gycdBu2l24NMctICV71fHfCMwiUVAI+nQ+dc4
	EC/gi24UYPgc1gHHe/ioCm2/C4WO/4Q=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-26763bb9a92so22645165ad.2
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 14:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1758059854; x=1758664654; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fSsNsg94xTPxgo7mtr0vhLneaLnV1NurRaDsg6aVKxA=;
        b=ZrKD8frK8y5zkRTHVr3c9cosse+NW7ZbFGhC/7zvK7gvNJvcZ7ccrh51aC3AMs28OO
         RX/I4TPPTGUZ8XYC+1kC1LEwOYPA0xKFxAA6PcnZE/TL9JS/5vJj68lpawdB6W0dcG+k
         UyQNqA9ZJfrXy8y1WiGfLPB2K8TG7ydqX6bdKYzKYFz9zRLHSAsCs4k+iMLecEhbojCZ
         nc/zTgCG86ZBbiM99uZhUlgwPvBi4QiqogiNybkEnYBJTDUyE4X3gietTTAVLGx/KmWB
         9RW76VBa6/6zar97R8NinPe6jodWK1VUeQ1n97eRx5PSuvJF+xoeJMUK8ZgwCRcCCx1t
         5BwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758059854; x=1758664654;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fSsNsg94xTPxgo7mtr0vhLneaLnV1NurRaDsg6aVKxA=;
        b=XF7zB5K2cxp3neroZPAPNff8j8MlIwYARCLm3jPl17jfOoMPK/i2oURQUKXPmrsyza
         6y5rWfU1+ruMOuJCNXsAA2Z1plNu4zqTy7Z0EHIPHpHJnEsWpTQVqGENRJQ4TnhkkfcU
         JhcziOP/XItvUNgICron0ezdpuuOKfbHRA+rck0202M2QkQveA49hjSveEhp5JIVDbJl
         kGS80d0Mz9jXqdLafig+ilOFB0Ov/mcTe3Mw9kXD2fZzmI3VXh5C3W8qbyPOfNHbr15M
         r4n5XKMxxUs0Yfs6LCLaw+AGOhBEcc+dU6KMGlOQzq/Q2cbiB934tuvXmBYjLEX7C75K
         7iTg==
X-Forwarded-Encrypted: i=1; AJvYcCXKyrNmVC2N7zqL42JuV47eYydkE0DQzVyCcd5R9+p91aaHwKjM/ZpfDvvrIqn6qd1H1mAoozsV8g==@kvack.org
X-Gm-Message-State: AOJu0YztD4qKIo5ng7AFTclIwi9Ajsq3uPTLDgi76OpUOWV+UBQTF+qF
	Gv+vU1ISSVfJx6GSAuKymyoaChI5OemLJnb2J0O/BkGxHxequxqJA1yy6tFb231CfeM=
X-Gm-Gg: ASbGncv1kJEbYrxY3/PjurgXQPffaguCUEK8JSbVujJgTDKjAmfgMi/EX5FLOGrUTy7
	wP75y8TPmDVDqJFxuneocFFykFivjkotZvsudPBxq/pgsXu6EN6NA50xF0BrCKeeC0Tv5c/szcK
	IpTS8KnKqD071kNAospnaAk04ZaulaO/LG1Udqn7IJL6r0YIF/NWNaardHLk4r9dlE1c7pGHiwU
	rFxT9pnC3i6A7coBuPbU6Ypyl04q7CycwevNIqyEmaQYye5V0AMTc3MryrGrfS6osByRdxLMJVF
	9DHecs/8mO70z4remUi25dlKhhWu593W2X2WFhmxX3PPRjRo9OPlqmxZ/N0HsXw1+oAIpId8LbA
	fE1sz0E9GDwpXfZsr6deTH5mKGbcGSILP
X-Google-Smtp-Source: AGHT+IHdEe5K+YDWPhJLhlZn7IU67ePHwIpfI8vI3XiMDhr12ZwDMD7hxV3qH6hUc2/5B/bKZQSVwg==
X-Received: by 2002:a17:902:ebc9:b0:24b:4a9a:703a with SMTP id d9443c01a7336-25d24da7536mr278813885ad.17.1758059853851;
        Tue, 16 Sep 2025 14:57:33 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32ea3c72dacsm1636848a91.4.2025.09.16.14.57.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 14:57:33 -0700 (PDT)
Date: Tue, 16 Sep 2025 14:57:31 -0700
From: Deepak Gupta <debug@rivosinc.com>
To: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
Cc: linux-riscv@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Ved Shanbhogue <ved@rivosinc.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Xu <peterx@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Chunyan Zhang <zhang.lyra@gmail.com>
Subject: Re: [PATCH V12 3/5] riscv: Add RISC-V Svrsw60t59b extension support
Message-ID: <aMndS8F6tr1ZvILt@debug.ba.rivosinc.com>
References: <20250915101343.1449546-1-zhangchunyan@iscas.ac.cn>
 <20250915101343.1449546-4-zhangchunyan@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250915101343.1449546-4-zhangchunyan@iscas.ac.cn>
X-Rspamd-Queue-Id: 13AC34000D
X-Rspamd-Server: rspam05
X-Stat-Signature: jy71ifojygw9arexmxbw935hdaqg5r64
X-Rspam-User: 
X-HE-Tag: 1758059854-472318
X-HE-Meta: U2FsdGVkX1+YJy38d1+z36XHETaK+NbaJpOPj8pPEIxwdApKYjVzb1lUm0bRhaIFu8C9XPQZ4Yx6GaYUvGIvQZmSEgQ9OIL9lh+NdE6Kk8MldUbOjLiAWdeIiU4fOSVJSvZVlrh1Y2WpYFSs/y+g8V5cs5D9YMSuOM7+Kmj696ryWN46/PQQr65NO135xSLo/dNnv4mi14Rkbt04e8kgOODwSLh1rNxFMaRh+COvnckfVeQR5gYkbknfsW4IqZrQGSfQMsjpsWHyANCsjB0kMECIYvrUs2xUcmQfAgts2qDDO/1wh9eo2arPqgt7DRBaq1xSOp421Hn/KVQTqaUsjp6Dq1rX87Dozf53KePndwkUO30jjQ+/C/Q3QWi/qFTClvXQ/08TPFxcWiCNT733aL8MjbDjszO2Yta7SZDrOSx7X3cx7JZLuvwh0DNFlXbAHEqHiNBiyWqDpLNuheyteXTnPzfkdBVo3+MubfI7CdT7x1KP4skY6QD5vVsw/7/L8kBeiegur35/0OxQghMi54FjipMjRlkL/EQjPiFKzUTIdzA+7WZLznqZbBHzsn+5cb+P3sLhitZKtoBJXs2fkAwbJPhYUoKBck0qQwCmdxixt4rdw0oaj0PcKRHN7j9L+Ckv9OR9AWO0t3zoo2cZ/QKiwNk9wERog+rUHr6NX92eHW+lTcDpvhGaah60EeTUUr2ld8XLlXe3OzRqKwiK3lR/XFrqWO1n34jugt8VY3pVscvpItm+BeOom9WWQu2++rGngODcS2LD9rSrHHiO8nLMMehmHq6AtFaHNtEfqBPUAIayvDMELKlkb2geKdtf4z+OF0zS5irpve+XdPhJnNUgzQY6579BzlJAyaNer8tf4qehAFGtRSDOD8aeoS7yCGxYzXTmyXqSFJWMO4VorR/Rl3tYihQ+wApK4IN7YhBzEOKCZ99hllsk2vv61SCmIkHelG2TU0DhwiT0YYm
 aZIQ2xl0
 LDVjCE++nPWTZDFxTjbTQ0OnbWc1U3EzVoYkCMSz+iRGMioDEgHaA4eGvE3N5rwTz4sfZs/tbfffLFzPpaD4XPf8ak+uMjaZB+hvZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 06:13:41PM +0800, Chunyan Zhang wrote:
>The Svrsw60t59b extension allows to free the PTE reserved bits 60
>and 59 for software to use.
>
>Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
>Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
>Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>

Same comment as Conor for dt-bindings.
Other than that

Reviewed-by: Deepak Gupta <debug@rivosinc.com>
>---
> arch/riscv/Kconfig             | 14 ++++++++++++++
> arch/riscv/include/asm/hwcap.h |  1 +
> arch/riscv/kernel/cpufeature.c |  1 +
> 3 files changed, 16 insertions(+)
>
>diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
>index 51dcd8eaa243..e1b6a95952c4 100644
>--- a/arch/riscv/Kconfig
>+++ b/arch/riscv/Kconfig
>@@ -862,6 +862,20 @@ config RISCV_ISA_ZICBOP
>
> 	  If you don't know what to do here, say Y.
>
>+config RISCV_ISA_SVRSW60T59B
>+	bool "Svrsw60t59b extension support for using PTE bits 60 and 59"
>+	depends on MMU && 64BIT
>+	depends on RISCV_ALTERNATIVE
>+	default y
>+	help
>+	  Adds support to dynamically detect the presence of the Svrsw60t59b
>+	  extension and enable its usage.
>+
>+	  The Svrsw60t59b extension allows to free the PTE reserved bits 60
>+	  and 59 for software to use.
>+
>+	  If you don't know what to do here, say Y.
>+
> config TOOLCHAIN_NEEDS_EXPLICIT_ZICSR_ZIFENCEI
> 	def_bool y
> 	# https://sourceware.org/git/?p=binutils-gdb.git;a=commit;h=aed44286efa8ae8717a77d94b51ac3614e2ca6dc
>diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
>index affd63e11b0a..f98fcb5c17d5 100644
>--- a/arch/riscv/include/asm/hwcap.h
>+++ b/arch/riscv/include/asm/hwcap.h
>@@ -106,6 +106,7 @@
> #define RISCV_ISA_EXT_ZAAMO		97
> #define RISCV_ISA_EXT_ZALRSC		98
> #define RISCV_ISA_EXT_ZICBOP		99
>+#define RISCV_ISA_EXT_SVRSW60T59B	100
>
> #define RISCV_ISA_EXT_XLINUXENVCFG	127
>
>diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
>index 743d53415572..2ba71d2d3fa3 100644
>--- a/arch/riscv/kernel/cpufeature.c
>+++ b/arch/riscv/kernel/cpufeature.c
>@@ -539,6 +539,7 @@ const struct riscv_isa_ext_data riscv_isa_ext[] = {
> 	__RISCV_ISA_EXT_DATA(svinval, RISCV_ISA_EXT_SVINVAL),
> 	__RISCV_ISA_EXT_DATA(svnapot, RISCV_ISA_EXT_SVNAPOT),
> 	__RISCV_ISA_EXT_DATA(svpbmt, RISCV_ISA_EXT_SVPBMT),
>+	__RISCV_ISA_EXT_DATA(svrsw60t59b, RISCV_ISA_EXT_SVRSW60T59B),
> 	__RISCV_ISA_EXT_DATA(svvptc, RISCV_ISA_EXT_SVVPTC),
> };
>
>-- 
>2.34.1
>

