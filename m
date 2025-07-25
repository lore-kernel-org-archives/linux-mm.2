Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F05B2C83F26
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 06:26:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76C8A6B0089; Fri, 25 Jul 2025 02:26:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 744CE6B008A; Fri, 25 Jul 2025 02:26:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65AE76B008C; Fri, 25 Jul 2025 02:26:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 55DDB6B0089
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 02:26:48 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 287FC1A05E5
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 06:26:48 +0000 (UTC)
X-FDA: 83701803696.14.347B599
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	by imf18.hostedemail.com (Postfix) with ESMTP id 12A341C000E
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 06:26:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=canonical.com header.s=20210705 header.b=IWugx4X+;
	spf=pass (imf18.hostedemail.com: domain of heinrich.schuchardt@canonical.com designates 185.125.188.122 as permitted sender) smtp.mailfrom=heinrich.schuchardt@canonical.com;
	dmarc=pass (policy=none) header.from=canonical.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753424806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i7Z45Di1DKvPrIvb2/CHdBXTyeDYviINQxq/IZOTBeg=;
	b=iFmXgvoEXH6iVnZTrv6kjR1F2Br47u8raMACKXGplLtYI/gwfOKkljsBwKv/pM34GKh+WW
	pnPYT+4xn1jTU9It9YCS7a2G39g+JSRmV2ZXsSbLAMVyCp1FcxWZmVa7HtkySg5XVdF7jU
	vpdbjkX87WRQ0wNnqynr9JIMHwHtEAw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753424806; a=rsa-sha256;
	cv=none;
	b=JurleKmxfIZuoKT4EqXEBmtj6UszPNHJWsSNDpbeMH7ukYSZqx7hR913JsfYNu9ra1JGZG
	cWOlqAItE17wRtdnAko8WuI1KfYK5O0YaUzVDfUTDhK4ceqPOcHvMC9LuSILWAp7lPEj8S
	/iUEv0/WNt/3acYR3rIoeKlUrs+4VzU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=canonical.com header.s=20210705 header.b=IWugx4X+;
	spf=pass (imf18.hostedemail.com: domain of heinrich.schuchardt@canonical.com designates 185.125.188.122 as permitted sender) smtp.mailfrom=heinrich.schuchardt@canonical.com;
	dmarc=pass (policy=none) header.from=canonical.com
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 5E2FC3FFEC
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 06:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1753424804;
	bh=i7Z45Di1DKvPrIvb2/CHdBXTyeDYviINQxq/IZOTBeg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type;
	b=IWugx4X+bTsW+tLBhJVw7GOYeoC59am65WCy0KgCsDi+PYktPZHpiLqCthurKR+rA
	 ghChtgIetvXu0gOUcL9NRsVZamJpZNA70B2aQYGDnKH6g38ZG0eWlbICoGXJ2l2v3i
	 GHd0j4MDN29cWl4TDaXgQ2PNp/vmRR4BTHtzmcEp77tK2jxWIZJwdlfG+UpIYekDdk
	 LXXNbPUjzYcg3QXOjopn6EEbaXCQ6rNcY/k4kRrXQfUe8jg6oWT40Qgcsl8TApLtdR
	 kyv29YdXWv6cOxv5wlkdOgnWg2uHvPTAJKTdq8Gk/H5Vriz8HrT4crIQMj/wNfBgna
	 sYReZIYQB34lQ==
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3a4eb6fcd88so1146824f8f.1
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 23:26:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753424803; x=1754029603;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i7Z45Di1DKvPrIvb2/CHdBXTyeDYviINQxq/IZOTBeg=;
        b=GRn0CByfhRKFp9MKDgqLrpiw1+eDFv/kZBTUm1l1wE/k5XzQDx4G2ZKD/BTjLDyKai
         mBklCrJnUh97LSjFvSwdmg1uWyPI45dN9sei8jbNAYH7Ssy8BEzFxtG1sXZkhv6s53ds
         Cvx1sVQZCWbcYzxfMEnxCN090kNsmjsJrXx9lm2kvDqn6bmoEdaPWkiPJ9K0pj+l0kr4
         dpBoHnHrcWlpZw/1WNmVdusZBl7w9r3aZDwAkztWSByL1GBFKnJzEP/Vvmg6afxptJQV
         e11zsd38xFQkW6pDNJG5IkUnssHTWveII56GYg6RxsVOQ7wnLzMFnmVPYGUOeC98unNX
         D/bA==
X-Forwarded-Encrypted: i=1; AJvYcCUgjux7vImY7pb62TP2MH2rRWqfeubc0OpZcXr0BjZzWVxiJ7ojLpOCmH1/fUabzC7VxueAjp1z5A==@kvack.org
X-Gm-Message-State: AOJu0YyhZcyeSYiooKO2aMz0AYIMX6K4QsVHfLcUVDKTSLi/On765yj6
	fU3KQoUOcsBy0K1xYetczMDekhd9uTac49xN62G0ap2hQGLEBd/1hWeG7Ftm7EpjPI36+3c8OUt
	hxpJanTRXhx+apmd7ZGM2a+ljHKXh09kdaqJHj9fMjIYkOjijBi/7PPsv//WYdYvFshVQ
X-Gm-Gg: ASbGnctQFQLPPzeXVoAwiPopRKbBFeYCF+TSM0cdlJ65e9gfpb5RRLTZL52xfuTdPNk
	iQSlNK+MTVqKDmijRacuoOWmnDMYb2VcbhQR2Vwubwy9u92B0EruQJvhsuOCd292/5wgEqspxWj
	AG04bL4+hOXRvFHqaqYd/HladTK58IBgZFjVJK3gV/14Vfe58MOcthSrPBMEo+cyEuujU1aFVhN
	hQ5ykgOHv/Rf4pMKkmMp+ngaGb1PGG3fl33+rMWYICPy/MkV08ML7sHEJRTByzkWA6fdbJq4d3h
	DX2dqB1gIQcVDHOMMwaufz7EgQcxQ549MBGHayM103kwyszBHC5UVKlMysUj2RYfn9mrD/C4WLY
	eS2GxbUYAcA1x/EsAwVPcksXZU8KSwi8mM04A
X-Received: by 2002:a05:6000:1a88:b0:3a4:fb7e:5fa6 with SMTP id ffacd0b85a97d-3b77671592amr538368f8f.1.1753424802562;
        Thu, 24 Jul 2025 23:26:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFTcbhP+qpBUFcpUqfk2Wp/N8FXB7Xsc01E0wuMcV6UBfsne+SnFue51uathOre6C5p/D/OcQ==
X-Received: by 2002:a05:6000:1a88:b0:3a4:fb7e:5fa6 with SMTP id ffacd0b85a97d-3b77671592amr538323f8f.1.1753424802160;
        Thu, 24 Jul 2025 23:26:42 -0700 (PDT)
Received: from [192.168.123.154] (ip-005-147-080-091.um06.pools.vodafone-ip.de. [5.147.80.91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b76fcacf0bsm4109538f8f.38.2025.07.24.23.26.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jul 2025 23:26:41 -0700 (PDT)
Message-ID: <0532c555-1876-449b-89cb-36ce5394433f@canonical.com>
Date: Fri, 25 Jul 2025 08:26:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/11] riscv: indirect jmp in asm that's static in nature
 to use sw guarded jump
To: Deepak Gupta <debug@rivosinc.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, Masahiro Yamada <masahiroy@kernel.org>,
 Nathan Chancellor <nathan@kernel.org>,
 Nicolas Schier <nicolas.schier@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Bill Wendling <morbo@google.com>, Monk Chiang <monk.chiang@sifive.com>,
 Kito Cheng <kito.cheng@sifive.com>, Justin Stitt <justinstitt@google.com>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-kbuild@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev,
 rick.p.edgecombe@intel.com, broonie@kernel.org, cleger@rivosinc.com,
 samitolvanen@google.com, apatel@ventanamicro.com, ajones@ventanamicro.com,
 conor.dooley@microchip.com, charlie@rivosinc.com, samuel.holland@sifive.com,
 bjorn@rivosinc.com, fweimer@redhat.com, jeffreyalaw@gmail.com,
 andrew@sifive.com, ved@rivosinc.com
References: <20250724-riscv_kcfi-v1-0-04b8fa44c98c@rivosinc.com>
 <20250724-riscv_kcfi-v1-3-04b8fa44c98c@rivosinc.com>
Content-Language: en-US
From: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
In-Reply-To: <20250724-riscv_kcfi-v1-3-04b8fa44c98c@rivosinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 12A341C000E
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: wg1u7wxgq8zypw69rg343hmzctnaasgj
X-HE-Tag: 1753424805-296110
X-HE-Meta: U2FsdGVkX1926nUNi06V9EgU88lsrkVjmmWu9g8Kae+A0JDSmxLLL2Upf41mm4vX1icA91Eeww4ZH2lk1Hnvglzz9COUanmbsohmUjLBc9HzFtCj1xXGCbB6ZeK88QQgh+KSOIrTyG3z2woljMIn/tCpy9ZOuV22eyt4QfODs0JK2FV79V6MozthieET0B5RV94VcePLSlgBdf9KSFvW3lFNA48au6FxwtZ8Rmqra5H1GelJIK/k1Gm8mtwI1fcU7lX0NlOkUcl6BB8GeT8dCAnyFhg/s27ON5pPgP05SM9/VypBuoRWOdGu6rXeiI/nh7GXuih/YGfJ0yD3yxUEGKROB9pVa58veR7Uer8MMLGA3JnrpqfszcKBR37H4N+D3zj7wIDdEzVFCUkgJCihES8cHHTTbf4GZkivtDnyBYsKvoNAwNLCw3R6qJSK56Fw7sYjSEOkV39xWYzlrd0Iwk9rUWp0h2rwv6E2aT4KIYr6lKCW4ZaueIVrxiBVt0satB+HVoK7dYIlxAakaSDcLR/vgMyRiZqIQe3evubiLXx7vNN3b5f6GmIqs7as+0Y9WBBqnghTiUO+k4nyM4Idq1aon/EYgil1B+s01hYwSeSJtvqP8sueh1Aj7mbwajlExtENJSfWU4RdHIi31/PnsdIoYRKv0Kinrgwj503WLHJrok1pmkcsrh/HnS+R2zIrEUFV5dFZiWoaBkLyAVIarD0to8srkqmYl8DGUsTj11jYIiA8Au+88BuUARZMgqEgJ9wf6a3s2pyRFttsS/iUnkxqRV/8KVksc6mGuie8tEbjMI8VR05uTDHqBFvOSyKE8Nwe3fmBIe9gWN2FlM/fr7MmPNre3UM3csYSliAcACKfmKsqiyAeRVaNJEih4h37D99leIqXgYyRKogYjYtsvZ/YxgDePCCPEsh6gG6Nxg32h8F7t14Rvd7SwZ82SyD6GD1QHI5q+6W2Q+FP1rL
 bJkNyWAY
 ISwjJYLfXgVUd82Ban96BXI6ri/ImtLOiddQdFXSSqHS712sapxJyDZfPo9ciHaLtj58E+NCumyz0t7+nGJaWIWipFEHp1pxciLwhSUrAjMH7L2Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25.07.25 01:36, Deepak Gupta wrote:
> Handwritten `__memset` asm routine perform static jumps within
> function and uses `a5` to do that. This would require a landing pad
> instruction at the target. Since its static jump and no memory load is
> involved, use `t2` instead which is exempt from requiring a landing pad.
> 
> Signed-off-by: Deepak Gupta <debug@rivosinc.com>

Acked-by: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>

> ---
>   arch/riscv/lib/memset.S | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/riscv/lib/memset.S b/arch/riscv/lib/memset.S
> index da23b8347e2d..c4a318d8eef3 100644
> --- a/arch/riscv/lib/memset.S
> +++ b/arch/riscv/lib/memset.S
> @@ -56,12 +56,12 @@ SYM_FUNC_START(__memset)
>   
>   	/* Jump into loop body */
>   	/* Assumes 32-bit instruction lengths */
> -	la a5, 3f
> +	la t2, 3f
>   #ifdef CONFIG_64BIT
>   	srli a4, a4, 1
>   #endif
> -	add a5, a5, a4
> -	jr a5
> +	add t2, t2, a4
> +	jr t2
>   3:
>   	REG_S a1,        0(t0)
>   	REG_S a1,    SZREG(t0)
> 


