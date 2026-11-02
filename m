Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CD4C606A32C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 11:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=nbJ29IH6
Received: by kanga.kvack.org (Postfix)
	id 54AA36B05B7; Mon,  2 Nov 2026 06:21:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FA4F6B05B8; Mon,  2 Nov 2026 06:21:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EA0E6B05B9; Mon,  2 Nov 2026 06:21:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1A4316B05B7
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:21:46 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A9F28A87D9
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:21:45 +0000 (UTC)
X-FDA: 85389938970.04.D2447A6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9093E1A000B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:21:43 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=nbJ29IH6;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793618504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kp/z3MU7YGBqtXkYJdrZFPtXjtQiMfjPy6zAGRI75f8=;
	b=J/hOzmKILB1/vTtMzfA/x/ZvATMbsxOrNXYgnak4m6ul/epbYcZhcQfEw6aXTKTBp//xoa
	aKQKfSi7cUoUIRd+Wlk3V3rLLUBYPnk07Pe/h3P1eH2LxxHC18AzFscvArJrJ0VE83tmoq
	qZy36fa6WW1TpotGlPyudeLxbIgQPyY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=nbJ29IH6;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793618504;
	b=Ve7RU/YNrHItBskCOrdatZBbeACZ4knKBI2l3UzvIb/FiPuEhCJyOmAQK2EqJWiONiZA30
	sjb+t0xWZ7LNCXUFr0/OQRPLvhgECgHtaJSsXAYVVKO+GusUU3LivmFciI72OBCJuGSbnX
	DtxWVCZ6IFAyZ2FM9Jaf0wtulZ3Xmig=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 505DE2A31;
	Mon,  2 Nov 2026 03:21:39 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 638CC3F632;
	Mon,  2 Nov 2026 03:21:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793618502; bh=vEzrqCWaH6sVkcTMp6OI/QOpWZT9yXWBiNbXxiv6lmA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=nbJ29IH6dzX4ajlSXZsYxUhN1Lgz7qI7Kf5XaxQjBx/xo9v7XPDH8Ju+9BXJRBPse
	 e8oLA7buAWAo7aZl1xI9J9NpPa0gvVM1iZGlL9vD4OwU9kc5aWCdjj4sVHMsz5gOdC
	 kzyj1pP43iYB3WNlRCyithRJP5str24lHrOCdHmc=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 02 Nov 2026 11:21:14 +0000
Subject: [PATCH RESEND v2 01/21] ARM: mm: make nommu pgd_t a scalar
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-dummy_ptxp3-v2-1-78840b2ec73c@arm.com>
References: <20261102-dummy_ptxp3-v2-0-78840b2ec73c@arm.com>
In-Reply-To: <20261102-dummy_ptxp3-v2-0-78840b2ec73c@arm.com>
To: Russell King <linux@armlinux.org.uk>, 
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
 Bibo Mao <maobibo@loongson.cn>, Anup Patel <anup@brainfault.org>, 
 Atish Patra <atish.patra@linux.dev>, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonas Bonn <jonas@southpole.se>, 
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, 
 Stafford Horne <shorne@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
 linux-openrisc@vger.kernel.org
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1081; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=ODmKgHrv0SlU2okc3grPddikJ1BO4DLAINSWVDYQruI=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBq6HIvGLS699hx7hG7O/gmI78xbHdrhwDkf+7I9
 DWzP3L/JCaJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCauhyLwAKCRBt1cPRWsUx
 M3LaDACfxss2j2NeE3BbTwwhokaDiCVaW/H2/Mn+uUenKG2jgF/kgodnvVS74EsJjBiO+N61g8k
 jWQPIwa3DH8V2Bt7Ff/0DyErPtKYiTAgNkr0bTxKT8vl3v5bJYwh2f8oMpNlskDhO5YF9ajXEFZ
 4ER8DxM8Y0Bot9aN/p+GNwx5V7S7M+ZxGwyoFmLXbIMo8frKb97sxPDAfsQWhXc/21AGoZR07PA
 INOCEo64nIFS15biXbqjKkhz6Cg9u4ZiO2+9vVuGSmKykqv/EuGUfHOmt969sV+myhOj6IOf9Y7
 Pm5ViXArvK4RfqS7EjpzDiY+Ijjv+sJGjYyXgNxNfnVM57alioKTkUndEkuHX0dCDAOx2+PcrCg
 3E0y/PCa4svejSAe9h8r+1ip3k9DsHNUK382M6HKF32gPu7Wr7WsSAR4RGYgAKC+6k2G0Iy/yKt
 3AY/4iUvtbWQKzfONYzBUemon4pM3LwvK4VOQ4z77hFiMuT2j+pbqBBod0/uxLBwdhzPQ=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9093E1A000B
X-Stat-Signature: 9z9pn8fowicx6hu9f8ysg3g8a3y3gd1o
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793618503-395796
X-HE-Meta: U2FsdGVkX18u9Y8bjBeDQj87X6e15RsuFOw2Z2TUP6W4/zeG6N8AXNRSe7FOX+31/UEmX8vqjq3A5FZSAnd7XqAkZsts+Cz3RJLiKak4nyikl79olgCY33P6+4tR1QdVC+lu0GQdoxe2zxDN6DE5RLyVMKJ9YaMbRe4XUcADvVM+3DkkgJteZ7GI3tbrIzzl8kFIufb0CuUV0TvSC/Sa0YtyXZFOIF/R4DizGbVEdkG0eEaJKdkD3GbG2MOP8hDAIG16rB7G1DpmA1RkWJcpI4vTrVywAbGIJKQS/I4iAr7ag+yf7LPh2WN/sCWHfSi3Mxq0iBa4k6TL/56ucXDTyKjgsi2O5xD3YbMRKX+U4ssJBbMm0+VkjxM22jgOV08sz/K5v0YcPqYe9NtKVwJGiJz2psYHyawYQaGtft0MLUsKU4d00Nk4I8/gXW4eFR5K9whwfhAHJ/XysEEqZOVxmR8u45KWEnAxBYDNGfLb0zmGc7N3YmyJd7WcHQPv+TNzCXwEC08mPGUAr/G4GZNE7NXiWI2fp7xkxJcCvCPVRYgTUMV8h0mQSTBkvEoMST4oS1qvhmD5FYAf5qkLv6jv5GYQvTlTRVVeWK35iWenYzUfu82LSEoNbMj1REfDHXn6iIj7CEsXFWaXmSdqZl2uopbI6oapInIRYZIge3w9/n2I+AAWH1UnWs4+55FhjwxbVYs7S9D61TKYdMBxhEHIkqmfTapm422WwkVLE5aMmXmJFpQ2CEPTITOXjoXlPcACuV23Mq8v95Xt7NB+0IF44OYjxz3vjh7E4mSrcPqv6E+9JX5GnG4E4Fyh0q+QDyPob9mUDF5u2gY8oC3zmAAzm4mPuaFjnioG4Cd4M6y2Bns9Vn2PJEAf+Sco5wE/4dCIJgnLXf8DwUpG8MVjVw6NiB4spUhxTxCZH1qqz/hEhsHrxRdXM19a19Irm1kA/vKF2NFyzwFpjSu/TOarQhM
 RWdtjXyL
 NINNpiJYl2M0l1KkrmZjeXyosv5CI4tc3GBNbkB70bqb+5FDwhEp685sIJF3wt0HVGghVEf/174A+IQjycBa1dMe5zBUZsJXqVbNoKYJkICA2T0m4PHlF36h4THuLHwpiqadTQ4G6slH998/Cpz9FRuMYciO3YIe3Fno73184Vbz4gPY/uxV2z5zphO2Hk/KV5n3J+HzHN4SacYx6iFAALzxEhC7IW+L7aKmMXlaFQoyWy7zYFBRG/m3PfKhmJo4WVvOb8zqVU5H92Xg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "David Hildenbrand (Arm)" <david@kernel.org>

As pgd_t is returned  from a function, like pgdp_get(). pgd_t shouldn't be
an array.

There is no need to match the actual arm page tables, because with nommu
there are no page tables. It's all just in place to make the compiler
happy. Making it a scalar will make the compiler happy.

So let's just use an u32.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/arm/include/asm/page-nommu.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/page-nommu.h b/arch/arm/include/asm/page-nommu.h
index e74415c959bea..88659b38e2364 100644
--- a/arch/arm/include/asm/page-nommu.h
+++ b/arch/arm/include/asm/page-nommu.h
@@ -18,12 +18,12 @@
  */
 typedef unsigned long pte_t;
 typedef unsigned long pmd_t;
-typedef unsigned long pgd_t[2];
+typedef unsigned long pgd_t;
 typedef unsigned long pgprot_t;
 
 #define pte_val(x)      (x)
 #define pmd_val(x)      (x)
-#define pgd_val(x)	((x)[0])
+#define pgd_val(x)      (x)
 #define pgprot_val(x)   (x)
 
 #define __pte(x)        (x)

-- 
2.43.0


