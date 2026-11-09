Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8B23606EE82
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 16:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=d4mirWSg
Received: by kanga.kvack.org (Postfix)
	id B72626B05BB; Mon,  9 Nov 2026 11:01:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B228D6B05BC; Mon,  9 Nov 2026 11:01:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99C426B05BD; Mon,  9 Nov 2026 11:01:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 78E176B05BB
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:01:09 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0EA1DA072E
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:01:09 +0000 (UTC)
X-FDA: 85416044658.29.4F080AF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 20BC71C0005
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:01:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=d4mirWSg;
	spf=pass (imf20.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794240067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ySuENrGpUqjNOnPLgMFrEVBetZNZ5PFApDQ/o4nKV7Q=;
	b=pmVvRBTyiO6ZDPF4+QOsAJbv4OOK5WU4As4eyTHrPsrWp1hpZ/zF0zs6eTxCOZruqNn0K/
	qdAD4whmL3zzd0VroM2ZU2ckaHoAKYjehBPv6WmNageKWSVlmqYlgQQV6N74+zZI5liBOE
	GUDkDuxGnOQVVY6/f6Vmpnv1Jh+d5e4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794240067;
	b=z3ZHB1XraZd1aeyqCs9+LqdR80cHdhej5Y3ZkNE7tkakqumji8Ijt4a3IqTMba9/5Ydqof
	omsHOuLnOWN0daFMyJf/ifeWuxygh6Rb8SfXcuyZ4EzOSJX211N/PDsGhoxvx3l1BrpF/C
	zhjoMkZauh4bEAED0gCChzsc5tB4KfE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=d4mirWSg;
	spf=pass (imf20.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2D08314BF;
	Mon,  9 Nov 2026 08:01:03 -0800 (PST)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4E7A73F632;
	Mon,  9 Nov 2026 08:01:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794240066; bh=ME8w8wWVjC6kFFTloB33po9XzJ2RJqfmLmS2WG/lKf8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=d4mirWSgxEi/JKu2hm3pp69pzDfwTMhGF+FxTJjtWYJGttTFyyMTaLtQF/oOiyJn9
	 h57+SBa9UM84EVZ5zS3Ap4mgf+iwD0lxSqxx1XC/tvqYGFdzzGa5mf+CX3SaCBrFAs
	 nuOU8SkMYKk5YSjml0jU4OLWE+u4Rf23ebx0aWdw=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Mon, 09 Nov 2026 15:58:31 +0000
Subject: [PATCH RFC v10 06/22] arm64: Disable EL2 trapping of POR_EL1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261109-kpkeys-v10-6-aa6c4d9603bc@arm.com>
References: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
In-Reply-To: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Ard Biesheuvel <ardb+git@google.com>, Andy Lutomirski <luto@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
 Kees Cook <kees@kernel.org>, Linu Cherian <linu.cherian@arm.com>, 
 Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Maxwell Bland <mbland@motorola.com>, 
 "Mike Rapoport (IBM)" <rppt@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Pierre Langlois <pierre.langlois@arm.com>, 
 =?utf-8?q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>, 
 Quentin Perret <qperret@google.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org, 
 Ira Weiny <iweiny@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794240029; l=759;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=ME8w8wWVjC6kFFTloB33po9XzJ2RJqfmLmS2WG/lKf8=;
 b=rL512vL81TftsgVlNw/YWtwNuWTlsI6Cej/ghKNCNj73xPNjGm4Cg71LdhCcqnj1mhqyTW3HF
 I/KR6KaqUYRBomiLeE6iHzlv6Nr+WcGKvkmbY0SilOz0QDq5L3+GWlM
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 20BC71C0005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: y98wo3rwck9x5inqy18twicyzzcxqz7i
X-Rspam-User: 
X-HE-Tag: 1794240066-415458
X-HE-Meta: U2FsdGVkX19oAqxUYE/JdfmUIgKpNmPj/xlBAQdtVi5PlErENiJ/moOmgdeQ9HuBImlqoepR2xovGMar9/rIgRtjSZ+tzmle6MXrR29mL4dyVZTx3X6BJl1s5tJSWXDBD7KW7rgvfWLRXio7RZ/x7vmK6l7lqCk5e8SKFxAWfdv4xMYHbSpQ7yIGaNM+eDdLLd7gnOMoIxg65ZZeHmdFqBvgtw24AMJaLOPhhnFz5/3iRY7gqwESMlgn9q+hJlpf5N0oVQOG6494akjNUGU3gasCRo/wUHArdTjAWIToZsqVTx4cHQlEUHPZADAsaATJGCXe1mGR6gXicn/vmUPArO3q58TTaGJpkNCOlmiOROaB5EmYvcIxnFCsKYQQZAKVxwUzDRmx4mnUC2XeMU1INny/NW8LMgAKyckNGpe22vJm112DmcJLJuXZw4YeMkTAyeON1gXn/cMqYbp9ufa0ZgOr28sqHSBsjeUxixRP7ktggMBz23rTN99dKj4CA7pb83fT3DUZVsBKzhAETBbGYyNmzHvSDLPTQv6Dxac994tt8+4PRsjNCfaLehMJZVdTg4LJQzg2Av3ezab62uwju6EOXa3LThHkaKGNO80fsoyKokLe/qrFzp3gHYP6fmdWXEQ4iYsbJ04r1C5xKsGm4KPRh0AUOghJNZ4hDkqmDwTHiLyJMz03eVmwhwnqFLzBFnxKKxGhL6eEOMqUkRDwhhMLkpO4RMsZgtfQhryyGc5dhbyKQnFKuKQfwkrgsvqEMYEBM4795GifFSrYcjxZkPDWWhWKYAh6Pm9/Jw+Jq8IbpBGSjFFJoNr6tKlNnFNXq2aqlpLiC+J14tGs2wemNrsxLN8yUUpqFaC/LpAClrBFqO1TkBGPemlEIsYzBErHxeQ61qOrun9XsqhPcS7hG96ZsHKLlWOzSh8pJr3C77Bn+c4lc2+dz668rj4gXxI77J3qjaPyEz/+7edF43l
 aqPpofQW
 3dvveinkc9u5d+TIT9NcozkUNAmnTIzn+GWAswvo6utxdpljSHki/q29/29kCxh6zY3yu/ry+vT6uG26kd5KywR7L5wvyP7m1QKbEKNKwjdBeNRMWzfTNwnis/DM5XGOf7JCNa3vfjovPnnAwfWKUv6WOnAXRVatau0TjdL78J+seLNnJ9LldFmhNH/ebEH10IhQ3o9yWlFufyzhAuy7xtB9QsBvFJz0OpkmsCVCUhiZ+nB58NW1oU47kYI9E0+wsfpWKpVDx8CBdi9BtwgsPVvgxaN3mYJd/vmo4/nV7Xr7Cv5IwyUhg7zw+GZEMyKPQ3QPE2pGEIMaOoEOUOFLyA6BjfHYYDniKOp5KB0+Ndn4x+OPTbVggHASEwfjtES1aDUHD/z+AkoxrGDcBQcfjdmUx29J4EptmtLma
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Make sure EL2 doesn't trap kernel accesses to POR_EL1 by setting the
nPOR_EL1 bit in HFGRT{R,W}_EL2.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/el2_setup.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index 12a500181291..a55e8d5f1eb8 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -380,7 +380,8 @@
 	ubfx	x1, x1, #ID_AA64MMFR3_EL1_S1POE_SHIFT, #4
 	cbz	x1, .Lskip_poe_fgt_\@
 
-	/* Disable trapping of POR_EL0 */
+	/* Disable trapping of POR_ELx */
+	orr	x0, x0, #HFGRTR_EL2_nPOR_EL1
 	orr	x0, x0, #HFGRTR_EL2_nPOR_EL0
 
 .Lskip_poe_fgt_\@:

-- 
2.56.0


