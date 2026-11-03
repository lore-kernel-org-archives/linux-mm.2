Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FF2D606B10C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 10:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=h6fhqmLg
Received: by kanga.kvack.org (Postfix)
	id 3138A6B05BF; Tue,  3 Nov 2026 05:17:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EAB06B05C0; Tue,  3 Nov 2026 05:17:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2011D6B05C1; Tue,  3 Nov 2026 05:17:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DC3176B05BF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 05:17:48 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7EE25C037B
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:17:48 +0000 (UTC)
X-FDA: 85393406616.27.FC617F7
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	by imf18.hostedemail.com (Postfix) with ESMTP id AE6B31C0004
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:17:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=h6fhqmLg;
	spf=pass (imf18.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793701066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SEyHpuH65RtgAfPnavKG94t3MsEPEX7xZ6UjOz6FFS4=;
	b=iBJErvaIZbjVc4LLA0sfwL5v7DQZae0vrjr19Oqx6ylFSIJ0et4mhXBWqPw5m5p36j0Ol6
	nwKUKF7PY+qe4rXj7disfRmM/ZmCxZLJigiuJIW77edtZdEH8AymrrFBifRMej3zZRy3DM
	I+gKrvRr7LglijDJVkNH0Uo/KMnyCuw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793701066;
	b=XcHZAGmPJ52nERIKXAS85NagrufqNrBGdJ11ql5A37ugMgN8eigHYquzVEEA4KZH2CzsuS
	Go8n7qcGzKjS8+4mLMvU1lEh9F49kPeqHXDPMPxtAbJn7BR1cNzPjTpHR2CmvIIAEJr8Ki
	APiZNyGvxlFKfxxY/Dfdbblwzcv27Bs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=h6fhqmLg;
	spf=pass (imf18.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-1adbf62dd31so4336809c88.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 02:17:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793701065; x=1794305865; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SEyHpuH65RtgAfPnavKG94t3MsEPEX7xZ6UjOz6FFS4=;
        b=h6fhqmLg4V+JpWzYDn7C6/1fQ51wdifhczXuKVNUwmQYM3vZFxyea9h7QU2aPk/SEe
         nLbf4u06LYkN2MzVhDh6NPht4qxium1bcDqbQ7FYzp2LAdDnghYbsIHiz/SKlXntdIAx
         lDNgCuzJn52qSlNtsZ2xVKs6WBCXpn7z4O1egg3BSB4UivaLW1SHvlPtupOIGGC3BRDr
         wHpnbaYwt/QbU5ZlQJ/SI6bjbDgiENSboA8zWVWGaN83GV3+Uj2rXcX/ranUMInPRtTQ
         j2y01FbnrAH8Ol+WQW4gt2iPios2r/9PSoVr8CD2TIKp1IoLoKREWAfIUV7Y3kg8ktGJ
         5GLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793701065; x=1794305865;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SEyHpuH65RtgAfPnavKG94t3MsEPEX7xZ6UjOz6FFS4=;
        b=1dHXAMPlqbYwXS/YvbX9DrtKC0SqdKIPBHDuJaHEfT9U8JI312Pfk1idL0G412Z8FE
         TsjfInxSq0uOJcwsIVMzuN3Pp/YW0wBqI9xKsRib47EpQbpYOURfQSknLsnhCAmEgNWw
         IEVLi0Ob6+pq0QmaHdqdldc5SC3RY/xWxKdL5vdAun28FEUPxXJe9Wlla+j3/WedjSF6
         9aa72Ph3VifwnJZ2HYkJPqGsoOULeT4bW1aBs53ZJqbnPSkuyiRhgwNNqkmLlAI7o/de
         y1xxgvcbGKcV1ZsC9vAeOvtVHJimLYdcQRbfmXNxWlFNmWukcsTARSl/TxNPHLwf8v9z
         40tg==
X-Forwarded-Encrypted: i=1; AKwUvBwN2pnvfR9mQKq3zTJFVwpovcTtC34Na+fOMdiNt7glhkBuWlPrlmQVwOoYQC1Irwdnjr4FEv7BJw==@kvack.org
X-Gm-Message-State: APuU4Z9lHG/uYJzEVKzj3T/6fYr01EeiwZ4cHjSzbL2oZWZ49233m/zV
	7YxfwpNUNagD6tIuUcgV3bZpkGQFzRs4ceY8Ax99MRRg6QN4iPpyyzNr
X-Gm-Gg: AYBFou1CiD2oDE0+ZwY7E8jM5ud4cqkzFG2iPPQDqvmYq9eXHV1r1LvrFPIhnCgJ5kP
	ITXeBoNn5k2WIxVz7H7icATW45KgH51GmeEmLu2PFgARnzxwaxix/m6lnfbqZ68GEcobFM+xLVX
	4fEyi3T6Ssg1/VYx1MLXABzO77o6gSkuyx5IgJca2wJxdiSpR4MGFqTp2oqSNzjYFCCESDXG5Ok
	Soxed3BstPiEDNhOdkfzc5oZo4cnwE10XI4EYIZE4bnOFnHREqQjRIXYUX7J7//MrVH7gCK89dD
	vVkavr2qj9GytCrDbYHzTHnDi06wLPN/F6RVwUo6M/KcU0Ikt4LecQzcRNLFLs1BM5ile3Ss1cJ
	HqgrdCsJexUk/JuUJ+0OExcBAX0ZnTvjwWWA7EHMNTm2kKGRLEbAAScpYtNoa01/SKBY2/WoWox
	P0HcVemI1Rc39d2Z6Kv+oXFZIPhlRYPcGSQ2pwwQLIaA7KrP/dW2K4jCphbGX37YBFPVzrZJufj
	6NtTOPvAeb1b6CE3PSlS0DcOm2o4+LJazp9lqqVs4gzPHzxp9PxrqS7vWKPIj/VF/I3yL6TbioZ
	jOPFup5NLgZJPEh31VfOg3rqmrdywA==
X-Received: by 2002:a05:7022:7f13:b0:18d:5988:8d3 with SMTP id a92af1059eb24-1ad106817d8mr18115510c88.3.1793701065267;
        Tue, 03 Nov 2026 02:17:45 -0800 (PST)
Received: from 027.. ([2409:8a20:4a5:7150:84fc:ce3c:7b09:dbca])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a4291e38fsm53145387eec.15.2026.11.03.02.17.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 02:17:44 -0800 (PST)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
To: akpm@linux-foundation.org,
	catalin.marinas@arm.com,
	linux-mm@kvack.org,
	urezki@gmail.com,
	will@kernel.org
Cc: Xueyuan.chen21@gmail.com,
	ajd@linux.ibm.com,
	anshuman.khandual@arm.com,
	baohua@kernel.org,
	chleroy@kernel.org,
	david@kernel.org,
	dev.jain@arm.com,
	jiangwen6@xiaomi.com,
	leo.yan@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [PATCH v11 05/10] arm64/vmalloc: allow arch_vmap_pte_range_map_size() to batch multiple CONT_PTE
Date: Tue,  3 Nov 2026 18:16:53 +0800
Message-Id: <20261103101658.766905-6-jiangwenxiaomi@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261103101658.766905-1-jiangwenxiaomi@gmail.com>
References: <20261103101658.766905-1-jiangwenxiaomi@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zh7dad93ag8u6h5marhsc5xbfwcgx9au
X-Rspamd-Queue-Id: AE6B31C0004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793701066-400041
X-HE-Meta: U2FsdGVkX1+iUW1q6+bgyqUsVMuJud4WcZXihzl4KGMRGnCVoj44TX5ry0AP4rEGq9RcM0c6iB1a4WAxTuyQaWZtw7yOuBk0KoJVcGo3LNMAdgu5h1n8RLBpYguc3S1q3g8xT4HVTXqtj7o+6/mnGqp7quMsL1kyKBc/8MWoQRRuTuLD2nEqAdPs6S9qmzfUzKpTDo8bdRUuMaBKHDM2ZMmahx/em3PEAC2PCOa7VVH5aMjR0V0iSCvWD0voBnN2gAoZNNXtLYCRnYGXWEHnQuf+Kc05CNi0G8DV74hTAGc1FZq0x8hdeFvKvJcS4JbGKU8yim1KjxSRdTAQxGRSpnfTaxZgINO+MNJziXlMclgt7i68W0+9e7n+8uo9UI0G9FZY+huRUSHAfwY94ZUCXmSo0IQ2PUKS4uxZHyc4m90cklihKhogQu0sz47dQMlVpBulLKyU3fXy1E63ibzjaXMAlAPMYmH0/kMIHtuVd9oHLlkqnBZXLl8tXPyRbkTrTO+s+Emde5aET5OwzKIyfOJK3nMtdQ0+3lqBsyc9+vhnaKZFNQdxXTMpi9Bkp4VEgujkhIlcdJU1oZ8k/JzFon2dkfGNGbAhkGei+c3G6Wk8zNcUrgJ8+YE5O0ni/k6A6lTGi3jfk/I7vMZef+CZH9sTROxfey46IRuF1ahdTfWf3zeZI8eYZLaqKgeYJppXugbbD/NyQCjCDq6NOJgn4gGiSv5j982AyVw5/clvWg8pXGDgF5qXFw9ATjVVBzZigJ69qHjJu3KKbs2rJD6ekPFK2R3RO+hZr4R3Z3GvXtdV/vEJQKNt8CQbL0GwSOv9XDUUj+LqhRbhB18qelhUV74AJvJYFjDCM5LV/i4vz8qcxSOpBKhjMOg0X879W/6Xwt1i3CTTdHzko/Ri6WIpWfQzGXWWw8Pmp+9zq8q01fTyUxNxENS36jgNZ+jxAeTzVbtmM/OtkB+6bcL507q
 FrafDoW6
 EB5y4lVpzRIET5DHPFOwGs1kLDFMdeXAsErpQIaicELCwJ4yx0uquDHWjhhFbEsw+FUSwuYB6l55Pc9vfhys2xusfIVu46KZtlm9e0iCP5U4P+OSYRA2CyG0PZ045AMiLGPUWTKWBU4KgTSJ35LLcekOxwR7ZuZu+YwHGkKhrXMDFdWRoQ0y+9PIUpbEw3vwRexRl+DoXvZoeV50xvN8E/k7VsFy/wipMfn/9pA90Q8Sl0pF+jRX9MzOA0RCVKCaDEFTLpxrGx9/A7pnGFVCBEXlfJPISw/Nyp/LkbBSjFk9MhKBgtVeJPDqBkDSfpU2Gy4AQ9c03hFO+MvW7wP/79gB7HBfZ2KCaqorxUOR3wZdYCplOIsKtE9StoKVR4JpsNDNcGMNtzo8B5Fj94PizjNZ5VBqX7d+JayNqLX5z0JTbYqFqyomYJdfZVZhJICppKm2w0sXYmRBrxK/XRBV1OUztRFBcEKWIxtT2yncSgsQi9Bik6aBPwPyO6oY7LfkEUHtQpB1nk8kqDGmGgELD8hD0NFkUwOKyddmaQdhoI5xA6q3J2PxURdJX+ys3StBvM7CtdRXOfBp0K0i8QWGQwm8xxFmjVtLzg0/0WDubdhgx9pQPU3mgFUThzi6pWOjXcBfkMjGJQmEtbeQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Barry Song (Xiaomi)" <baohua@kernel.org>

Allow arch_vmap_pte_range_map_size to batch across multiple CONT_PTE
blocks, reducing both PTE setup and TLB flush iterations.

Previously the function returned a single CONT_PTE_SIZE for an aligned
range, so the caller mapped one CONT_PTE block per iteration. Now, for a
CONT_PTE_SIZE-aligned range, it returns the largest CONT_PTE-aligned size
that fits within both the remaining range and the caller's max_page_shift,
so a single vmap_pte_set_huge() call installs several CONT_PTE blocks at
once.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Tested-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
---
 arch/arm64/include/asm/vmalloc.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/vmalloc.h b/arch/arm64/include/asm/vmalloc.h
index 4ec1acd3c1b3..c29704a19e27 100644
--- a/arch/arm64/include/asm/vmalloc.h
+++ b/arch/arm64/include/asm/vmalloc.h
@@ -23,10 +23,12 @@ static inline unsigned long arch_vmap_pte_range_map_size(unsigned long addr,
 						unsigned long end, u64 pfn,
 						unsigned int max_page_shift)
 {
+	unsigned long size;
+
 	/*
-	 * If the block is at least CONT_PTE_SIZE in size, and is naturally
-	 * aligned in both virtual and physical space, then we can pte-map the
-	 * block using the PTE_CONT bit for more efficient use of the TLB.
+	 * If the range is at least CONT_PTE_SIZE and naturally aligned in both
+	 * virtual and physical space, return the largest CONT_PTE-aligned size
+	 * that fits, for more efficient use of the TLB.
 	 */
 	if (max_page_shift < CONT_PTE_SHIFT)
 		return PAGE_SIZE;
@@ -40,7 +42,9 @@ static inline unsigned long arch_vmap_pte_range_map_size(unsigned long addr,
 	if (!IS_ALIGNED(PFN_PHYS(pfn), CONT_PTE_SIZE))
 		return PAGE_SIZE;
 
-	return CONT_PTE_SIZE;
+	size = min(end - addr, 1UL << max_page_shift);
+	size = round_down(size, CONT_PTE_SIZE);
+	return size;
 }
 
 #define arch_vmap_pte_range_unmap_size arch_vmap_pte_range_unmap_size
-- 
2.34.1


