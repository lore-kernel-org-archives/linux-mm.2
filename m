Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35443C87FCE
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 14:20:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A48326B008C; Fri, 25 Jul 2025 10:20:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1F596B0093; Fri, 25 Jul 2025 10:20:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95C386B0096; Fri, 25 Jul 2025 10:20:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 884046B008C
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 10:20:33 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 185E4113BF3
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 14:20:33 +0000 (UTC)
X-FDA: 83702997546.03.2FDAE36
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf20.hostedemail.com (Postfix) with ESMTP id 375BF1C000C
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 14:20:31 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=cTcvuxHp;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753453231; a=rsa-sha256;
	cv=none;
	b=zAH7Y/L3KFzk5veh+jgBSU6BK0ClPaf5UsK1h5ruYlzNChBBdW6Xo/Jx4dhKpuiZkRV3L0
	ZgYuFwX5AaedFoUBN3TtRxeI5AhQUeyIfjRZEpl/imHivOxfKyqexy7fB1+7Tmr60e3rs5
	J5fOIBtoU5NJoELLdNXdLUqDgO23jfs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=cTcvuxHp;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753453231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jOelqn4iY/rsR6MxnRwx481vFltvLJp6wfVOt5IOJQo=;
	b=0EzzMKT/8ncAFeG3rjaDsB8vrWRIep0Z6T5CCgP43HKRt8aYIiuH66a7uXim6/L4B8bGcg
	C1/VwaHERe5FZXI4MSiT1/1tESnhBwPoDIHDF3QtEjt1JvS+dIESDSxH+JvXwXPB41g+C2
	GZKPS0ApR/oq/8G/f6LXWymJrHv8EtU=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-312e747d2d8so2317412a91.0
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 07:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1753453230; x=1754058030; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jOelqn4iY/rsR6MxnRwx481vFltvLJp6wfVOt5IOJQo=;
        b=cTcvuxHpyElL/a1ic04a2g/G4flYRJEYolzF36zce1f5y/pxhxbnKl9Xfu8bhG4dtp
         d/1fktrjOwZJ5EoSt39gGk0cqC8Ozee2zf62GPdDMKf2pQo2LZUxu0PulevhRFphR7nt
         GtM9JntvOF4i0nAx+pYrHwWP2To6+le8KGZVAyWrnVxXZ6897OaH5g1tTQ2bx9yCfdF4
         gdw7NWNV1XrPIqtdC7FWLftLrdOWsdI387sRyXHrXM5Q2w4LtraKoTiatIo4dSDUsFkX
         Xk5VMOb6XDvYZqTvlnpK5BOKq0zZyaEF7XZdIhao8hMx9f69OH+R77zcDvml8OM4P1Q+
         bOZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753453230; x=1754058030;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jOelqn4iY/rsR6MxnRwx481vFltvLJp6wfVOt5IOJQo=;
        b=SVab9f6mbM1T4a5FalmTjtQkeZZygH5vMwFKI+ybnvwcr4OBbsu1HBz3/nJa+7Mrnj
         /BQW6ywZSxGihmAChYjUdpPqCQ7e/NW/9aonOAFLULe+dBQHCLEYFIj9rdlXM4LLSdvR
         pK3Iy7B7MtLzftQgYdCTRYj3SRtUGrpVEBogGS6nJc0VA6QQiH6/DKr1Rf8gOP8+P+wj
         O5VF/OAQp8u0r8eJ1rWBHZTZe9fyGVe/r4/LtzyMAwt6MFEGwdQTM5vPKB55UgxluKTq
         axiQy157pgJMjcSnVLMfSAN87gJ/AFcmHB/BC4CK8K7vUREBb/G2tx7svTRKAI2jNbw4
         xsRg==
X-Forwarded-Encrypted: i=1; AJvYcCX3PCkFHn6YoLijlWWlb/+3nmgslBlowu2dqvd8L5lua0YWYs3a51DWcAQZcO12L6EW5xl6MmCxyA==@kvack.org
X-Gm-Message-State: AOJu0YwSbKbBpEtbNY+9Zt6uYwUBRNArSAs6vv40qEFYl7x0xONeX3nS
	PB/yCaHZXBIB5oSLvql8/N2Po0KltmCpr8n8Nt9KY60DOn9PEcuvqFo3A/NNqpKUtfc=
X-Gm-Gg: ASbGncvctDyuXwBxIyiEDluQyJrtTUaRGaqqsiSex4NGhTrizK+HSIO1GU9Q9/rU7kk
	XFBOJIS8Chy3AHeTRzQJhhHqNf6MvXwYLO1Ea8Bwauza3sN5J1D0C6rSoYtX8KgLlV+VhDHruMl
	UleECPqo+koy/3zRKtFiSWXweFAB/lyLEKulQQaLAF7FvWRj7rMKfZx5Z+tuQvgr4jz2qUj//jB
	bisKF3iRzpx+mgmCDKz8ONotxc8FQM97XsF77wK4ePjWSli8F8wEvy57BYa6SBNrg1piNpFvhsZ
	iJw14pAY9lNhj9blWW0cFFewiWM2A8FRKc42SDoVK1BUUxEkAVlfFa3QVnzIZr41uUxAqFuC6L5
	JkqhPQsTtDTJwxrrBrQ0Y2xCwlcOKsJjBeYuL4ltacYE=
X-Google-Smtp-Source: AGHT+IFnToE7Y9m/LQB1LHyZJTXUY15A+gO23FToLy9nHc/JxiCSxR6k0MWES+brycAIrDFP11y4GQ==
X-Received: by 2002:a17:90b:5407:b0:310:c8ec:4192 with SMTP id 98e67ed59e1d1-31e662e8312mr8688402a91.10.1753453230029;
        Fri, 25 Jul 2025 07:20:30 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31e60a61628sm2176473a91.1.2025.07.25.07.20.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jul 2025 07:20:29 -0700 (PDT)
Date: Fri, 25 Jul 2025 07:20:26 -0700
From: Deepak Gupta <debug@rivosinc.com>
To: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org, linux-mm@kvack.org,
	llvm@lists.linux.dev, rick.p.edgecombe@intel.com,
	broonie@kernel.org, cleger@rivosinc.com, samitolvanen@google.com,
	apatel@ventanamicro.com, ajones@ventanamicro.com,
	conor.dooley@microchip.com, charlie@rivosinc.com,
	samuel.holland@sifive.com, bjorn@rivosinc.com, fweimer@redhat.com,
	jeffreyalaw@gmail.com, andrew@sifive.com, ved@rivosinc.com,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nicolas.schier@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Monk Chiang <monk.chiang@sifive.com>,
	Kito Cheng <kito.cheng@sifive.com>,
	Justin Stitt <justinstitt@google.com>
Subject: Re: [PATCH 05/11] riscv: enable landing pad enforcement
Message-ID: <aIOSqskb_hBAqjIt@debug.ba.rivosinc.com>
References: <20250724-riscv_kcfi-v1-0-04b8fa44c98c@rivosinc.com>
 <20250724-riscv_kcfi-v1-5-04b8fa44c98c@rivosinc.com>
 <1149732f-bc8d-4339-90c3-e34aeac9f1be@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1149732f-bc8d-4339-90c3-e34aeac9f1be@canonical.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 375BF1C000C
X-Stat-Signature: xioa9gcj7d4inadkrjjgpb1wfcwsp3u5
X-Rspam-User: 
X-HE-Tag: 1753453231-599648
X-HE-Meta: U2FsdGVkX18LNAJM2LsNGXR+tZ8vp7v2/ebSndS6CIlCVnx8PMY2lEQSg50bcArJihRB0ZO+HGVTUHpEK0DhG0oUpp96AObKQqQ/LbYZRoGtnz2Ro//zM9YGTU2CRsNfTCGjSE+YNPkLkFSPaNJxhimfzB0iIDcg7nR0thoRY+tHILDwaKESsikSvA0HEsOXJ4re3OnGrQYpaAckAmtLRKNs5a348d5FMOSLZHS612GeCMqwa4/c1sXrWIAuXxh7d6CBx9xiMF/07jnxjhikUggy/Ixm55zXD+mopE1bBflaslFXg5wZxVSi/4wxzgt+QEHPwuP36jAuhJXjFKZIi2tfnx10INpMTm4B09mVP83oDPZ6OYzuWxa0O+mg2TM23rNP/c9OO/1qiSl4w8mELiUKE8eLKlZLbH8EmYWZWYZ0qkwgRUeCkIJ98tDrveEwfp6qIb8OLoUEoIoF4+qzW4YhUK6Q+hMrBouqwKuAe3Ct60BOhF/qdmcUmJ1sg6mWpI1/2kP8io864qSIL2NgLzboegHMclmqsT0ZIfB48QUizsloDsjUNkFkXC2n4qFWfHDofNDoANfhpUqjBJf+fDcEjZdmLqOSoi7djGGvbw6gqVccHgqitmyP2Q8JhyFDPxGgDVG6R8yo7/ovm/kVwK4ixA/tVFOEsTLv1c8Uom8q65NQiSe+xDVY+mh5p07gQQre0QMyTNFhcUER2XUv6D4IDS6ozrwXEnsjDVA6X+I6t4bcC1FsPhQKELiadQBIk75s3LF4uFG5qZHrcyINoiE7x8V7d7cAeQQ8Xn/GRvqp+hFA86CzEZAGyc4+qqEHpKaxhMabwEep8ui0nJf4RES5afFHd+3bXTpfA8LWogW08GMvJp/A3uRTqnvOoEZtTlxWPDmGfrFeU64xi49sD/bvkkn4y+6bayvluHEo5dmR16B24UvSWudaf4vDks1pWi6hAm9NltWR3xk8Sjw
 QnL7sQkZ
 vpkr/yMah3dGuk7AKn7iacxOKEw6xBFVieLLJCk/bc9LMkWJp2NyjQLmfWK/DB6orkkUkEukpKzFO5vE23iUAC8YdC/wlI5u+AVdznY4J/9xKq8mAHrthWsEAZA0RlDwDs7RKm+8fEUp35a746f7MDr8v7GXUQhxV0ieSxrrDiQsCnli01flVw7kJA/wFOw/8DYCRx8Q0l04GDwXIN/+V+XIJN7BIfUJ2iXGOjUSQNNlVLDXIRKlQJ1vIglKUerIZtPwen+RtFXsuaRv23xArDqm9A9beVFGhrVyuModbmauegpIpTdMS7rWsSRyORE1AVD8LJRLKlHfmsvqkwDv4hBA7l7ikIaevBZP46v3XNH43TBHQbaWW8LLufLEmZ1jTNqSDJULYG+5C8geOsQTXKrANXoPmrfihkCDQ2GM9iwcY3ackEAm02eu6UqDnyX+fuTnw99dhreKSCzb+f92kLY8FROVl9OGUCtTMN1keduu2fr4Z4mluKWkmabwRgNuxamxt7wvBiVyhCyC/YHrTtLF2I2LrpwwqTNRK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025 at 08:33:46AM +0200, Heinrich Schuchardt wrote:
>On 25.07.25 01:36, Deepak Gupta wrote:
>>Enables landing pad enforcement by invoking a SBI FWFT call.
>>
>>Signed-off-by: Deepak Gupta <debug@rivosinc.com>
>>---
>>  arch/riscv/kernel/asm-offsets.c |  1 +
>>  arch/riscv/kernel/head.S        | 19 +++++++++++++++++++
>>  2 files changed, 20 insertions(+)
>>
>>diff --git a/arch/riscv/kernel/asm-offsets.c b/arch/riscv/kernel/asm-offsets.c
>>index e4d55126dc3e..e6a9fad86fae 100644
>>--- a/arch/riscv/kernel/asm-offsets.c
>>+++ b/arch/riscv/kernel/asm-offsets.c
>>@@ -536,6 +536,7 @@ void asm_offsets(void)
>>  	DEFINE(SBI_EXT_FWFT, SBI_EXT_FWFT);
>>  	DEFINE(SBI_EXT_FWFT_SET, SBI_EXT_FWFT_SET);
>>  	DEFINE(SBI_FWFT_SHADOW_STACK, SBI_FWFT_SHADOW_STACK);
>>+	DEFINE(SBI_FWFT_LANDING_PAD, SBI_FWFT_LANDING_PAD);
>>  	DEFINE(SBI_FWFT_SET_FLAG_LOCK, SBI_FWFT_SET_FLAG_LOCK);
>>  #endif
>>  }
>>diff --git a/arch/riscv/kernel/head.S b/arch/riscv/kernel/head.S
>>index 9c99c5ad6fe8..59af044bf85c 100644
>>--- a/arch/riscv/kernel/head.S
>>+++ b/arch/riscv/kernel/head.S
>>@@ -185,6 +185,16 @@ secondary_start_sbi:
>>  1:
>>  #endif
>>  	scs_load_current
>>+
>>+#if defined(CONFIG_RISCV_SBI) && defined(CONFIG_RISCV_KERNEL_CFI)
>>+	li a7, SBI_EXT_FWFT
>>+	li a6, SBI_EXT_FWFT_SET
>>+	li a0, SBI_FWFT_LANDING_PAD
>>+	li a1, 1 /* enable landing pad for supervisor */
>>+	li a2, SBI_FWFT_SET_FLAG_LOCK
>>+	ecall	/* check for error condition and take appropriate action */
>>+#endif
>>+
>>  	call smp_callin
>>  #endif /* CONFIG_SMP */
>>@@ -359,6 +369,15 @@ SYM_CODE_START(_start_kernel)
>>  #endif
>>  	scs_load_current
>>+#if defined(CONFIG_RISCV_SBI) && defined(CONFIG_RISCV_KERNEL_CFI)
>>+	li a7, SBI_EXT_FWFT
>>+	li a6, SBI_EXT_FWFT_SET
>>+	li a0, SBI_FWFT_LANDING_PAD
>>+	li a1, 1 /* enable landing pad for supervisor */
>
>The SBI specification calls BIT(0) "LOCK".
>Shouldn't we define a constant for the lock bit instead of using a 
>magic value?

See below `li a2, SBI_FWFT_SET_FLAG_LOCK`.

"li a1, 1 /* enable landing pad for supervisor */>" --> this is enabling.
Had we done "li a1, 0 /* enable landing pad for supervisor */" --> this is
asking firmware to disable the feature (turn off the bit in menvcfg CSR)

>Best regards
>
>Heinrich
>
>>+	li a2, SBI_FWFT_SET_FLAG_LOCK
>>+	ecall	/* check for error condition and take appropriate action */
>>+#endif
>>+
>>  #ifdef CONFIG_KASAN
>>  	call kasan_early_init
>>  #endif
>>
>

