Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DA88CD4F5B
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 05:32:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E60636B0099; Fri, 22 May 2026 01:32:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E38496B009B; Fri, 22 May 2026 01:32:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D279A6B009D; Fri, 22 May 2026 01:32:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C02EC6B0099
	for <linux-mm@kvack.org>; Fri, 22 May 2026 01:32:05 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5E647402A4
	for <linux-mm@kvack.org>; Fri, 22 May 2026 05:32:05 +0000 (UTC)
X-FDA: 84793934610.23.57EBAD6
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf07.hostedemail.com (Postfix) with ESMTP id 84BB940009
	for <linux-mm@kvack.org>; Fri, 22 May 2026 05:32:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IExiR2uF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779427923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C6VthUqcKepKjJupP2u4sKeVYf/HcaCpW/hf4AjZgMk=;
	b=mXd38aT4EtRchS7wAO8DkILl/sttgIAnyyciBhhDfvpcnaahlqrt+ivRU5xZZfJz6HzH4S
	C0mzgmU8iX0Ku8ed9C0MnoEYz9r/fqMzxY42OlVlZHbPeunkWAR8c2Q9e02e/8yQVCt4Oq
	u6e3ej/n/mSIEtrP1ePCcDrfHnYKMhY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IExiR2uF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779427923; a=rsa-sha256;
	cv=none;
	b=5JHvAaBrXiBtlGQaXFQbtyLhhfjFEzDhIM341aCjvtXydov8hVmNMj2xqg1pUiLHQ53gGc
	4ssNC6WTFNPQLfvarKlWcv9ps9rAS353ZQpRwA8R8oh17DEvpNvyrrEzlgnJ1jRWC4A5om
	RVTd8Bs/jS2oVFn/7c6V8Qd0rqEFCYk=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2b4650d5f5cso27932445ad.0
        for <linux-mm@kvack.org>; Thu, 21 May 2026 22:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779427922; x=1780032722; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C6VthUqcKepKjJupP2u4sKeVYf/HcaCpW/hf4AjZgMk=;
        b=IExiR2uFhPDpSgyGw0uZcVJAmuEethc0nI7uFSD5wBuhSZLEkZNzKqHMfQ58ekvb7/
         Q7Mvg/rgv9RMxzQDjiXrZRjdcPbkcm55jhvuMKhsCsnYji9baVjXHCmLWxonO7Vo2D0P
         TP91kczhqGAAXljBgL0eLj/E/mxsZN6koIxczSabczLHPksMJbnep0SKM1vntlpB0hMN
         xcAizIdQWkwMRDxKtOV3RpR0Zg8qEeZ3OVNvOI9FWyif6CTlFQaR70H4VolcIN73k44H
         OPhDTuADjsxlj5HiTo0IZFk0X7y2+Za4+A8Bp5ve0Q5xlbGQXweXfH1XOyxT537UxVZZ
         YxbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779427922; x=1780032722;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=C6VthUqcKepKjJupP2u4sKeVYf/HcaCpW/hf4AjZgMk=;
        b=axFX8Wkwv2kO9Lzvqnimx4uB6p2lwKvpKasdslHz/frWglWGeJk4n9hJ8Su0TuFZ33
         5B5QGhxsbvlGvfmrNxEX3Mn17sjXhafK9IZhCal20BK/8ixSuGMJibKvUnidcSghRnkE
         P5GfANo+CPPoBtr5qAIsmQwj8jgO45tBK6CxPCKAjC6GAWoOvPs7sAzQTh2aYFfvt3zH
         9uDXRngzLsrkyPOOtjhQVH5S4CHvmr1BzoI6MRbrka4NbkUSKVmRqSpsVAKVvn3LqmpC
         vP993BYuvXIN/tmBhKJudeC9dzp7bHsPJn5PDBb95sac5lpFPJWxKe+vgZW7xPzDvTkj
         q7/A==
X-Gm-Message-State: AOJu0YwWUdaUeexTY5tIygdwi8xOEeEv+qf3bFcAbMDJnDihrkSOxac6
	XM2qnFUkk7+A+pmHBAj10Na34sYNNOuATLPT1/n7I+gzE+sMBBJMfFWhOD84YZE1
X-Gm-Gg: Acq92OGn5//ZyB3h9smhNJPi4CyczdWAi3p3J/6LJ6F2mAEZfuWlkhldX9w7XObKbff
	AdvYSv6bPskjWBAimYKvZW1ZMWm5ZTAgeQwTs736obWckiQ8T79rg8OTpnWMz5V9ioNJfIsYVmW
	qHv8k0tzsq9sZ5uqVNUUhHqnvsReF2K3evStZM3b7+e8GWZ7TJohCnLaprJZmc0vvmAvCIHevWL
	ELQs6a2r5SSxrgY/zOwHEaK4q+mv5Qg6/Da9cXXsriD0qIkciqf0gytp/NUF3Jas77R7X2FfPQy
	GAb3BgfhMMxDSDMPELF2ZlOqh02Zct7+qhYBVAiTphGf6uUT7DtQsNiDbiB45f4X0zpSQ+MbqTQ
	XKdfabzX/oOXjofk9crmnzLhZJEU00WmGc4NGxsFRk4hKhqtQhXoed6mgMOEZJXHQ7p03yfh+UA
	g//G+NIMko80bcdQtePzg/9AGih0VVo9YI4jRWWL8+cegndeCLVj4=
X-Received: by 2002:a17:902:f705:b0:2be:3dbc:eee5 with SMTP id d9443c01a7336-2beb0365bbcmr23143495ad.2.1779427922345;
        Thu, 21 May 2026 22:32:02 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb56d68adsm4782665ad.32.2026.05.21.22.31.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 22:32:02 -0700 (PDT)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
To: linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	akpm@linux-foundation.org,
	urezki@gmail.com
Cc: baohua@kernel.org,
	Xueyuan.chen21@gmail.com,
	dev.jain@arm.com,
	rppt@kernel.org,
	david@kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	ajd@linux.ibm.com,
	linux-kernel@vger.kernel.org,
	jiangwen6@xiaomi.com
Subject: [PATCH v3 2/6] arm64/vmalloc: Allow arch_vmap_pte_range_map_size to batch multiple CONT_PTE
Date: Fri, 22 May 2026 13:31:42 +0800
Message-Id: <20260522053146.83209-3-jiangwenxiaomi@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260522053146.83209-1-jiangwenxiaomi@gmail.com>
References: <20260522053146.83209-1-jiangwenxiaomi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: k7381ksikk5feuy3p511zy7ingnp5znc
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 84BB940009
X-Rspam-User: 
X-HE-Tag: 1779427923-572758
X-HE-Meta: U2FsdGVkX18baIEjAdtilTM4AEuWNLN1OtXd1O7ZjspMrwY9RnjGylbQYFRjwk6o81Qs79q1ixGy8cUivKHV0tZHO3iurAf3fUZoJqfLBWikP4Q/dEviArUy3TVF8owxoH/ztm6ltXJiweLQCbHS9e9nAF7xsKaJQ5nxImHjibq5J+bmsMzb99NUDmPLrI6q3VDxoWEdHt/+qCMnUuevV8uEgXooIZ3TcLC1c6Hwg/7ukB/ZiyQcXp8iV93E7WT+WUJMUUrCga3yzVqGmvXXojG220Fb8l3G/+ZglsHE8z9iH9GJTYv0MI0+92SQ3fvdBjwF+rhoGALur9xPdrcbi0pTcOieaEPk3hUGUcnnRZW/dlnP5sEPzOrkidSEed8tJO3Ju5ooQYTyedTLOu+1SlsRHTZVAvVs+zkOsPhpzz6BH2+ibfDObZRlN9E4KN1809AKbPwB/7LwDJhSWJgT5AiMURf/WEOZQAp7jQYx8th5vThCXSGoWAd/+6VVm5dJfHurICnVOoBYcZETdi4+HgwbrMQQ8GBWG7gsgxvBSt7K1YtkHsM7pmL4hhHVR0J5u1c2PwxJiBRDoh/0/T41du/qirSrnA48x+cpcj7EPrrYyHty3hmXiwrxV148+zeWtGhcHBWIwtxucooGoThkTYIw/ibizmFxm2isIxqMXiSlrAERVnvzOEQVQSQyK9ZNBrHaLKx9aVc/SBX5YjwHMmDZanYFBlIkRyLOAzMsTupHsdY6Ir8bNr9xqynEx0pxfpeK7iilJ1/qjtHuhO+vYkwXmZklVaUl4Gs0aYnWGXzvHMm5Kim+/WR3vaO4j+FRktX3j6ek84AGe4uULE9DwgQPW2p/suv32gIgAbXUpKAEDxPaQDuM9McRodtHnXGCYgKtZVg/9G4et4A/Q/cF4NnQidc8XvQgCs8xZ4vAHkbQg4kQQospzM+ebb1fYMCrNKNS1eQBUZN9/MS6T1A
 AI7cpNfD
 +VcecLAr/6cv3uY3AqabMCywzfOjm5zSTuUPQ7Xw6510WLShKOQb2PvuQdJILEnN/R0R164IjtbkFAnvOuu/kTB4cc0LzWY8/4wxPNY+XEwLd+8dhFeMSVCaoHP/kqhLvFalvUSitxMcAHMhfjimKo/X8HdUGTrgkQY+iU7G+iMz8OdGQdmil6KLoF6B9OBj7QqIPsng9ss7DfC2qH9/luv4VcWjei5dmBggPom2a2RbFge1qfcLGYjBC2IlRiTTHaq3n90elWUUHqhsuaCgHIAhRy+BvjvmlI25+pUTPFRDEknWSL1p3Aor1G1QBAinn1ygQvMsiJ+0GnusMuxWCZ8VCMk1CRnY4ESzlTV7baEj83nY0lzncMPyz0px4mXSLGYzOedBYwvehpfC7NV9QvDOnyqw1j684wj6IEgiwr03Xh6igyBbg9jromjrLny3LfOQkPKCDuuXgLmVWofGeRtGF5OzRkG6QSOriQPU66A5iGZ/FR5n+ucJcDAl4k0EuQQQjx5TPNrzeEkD67Sf1WPMChZqcrk30B023pAsfRqi9xtqZ+EqsvH1xqDR+mnyc9SQj073nSnbhKAY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Barry Song (Xiaomi)" <baohua@kernel.org>

Allow arch_vmap_pte_range_map_size to batch multiple CONT_PTE hugepages,
reducing both PTE setup and TLB flush iterations.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 arch/arm64/include/asm/vmalloc.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/vmalloc.h b/arch/arm64/include/asm/vmalloc.h
index 4ec1acd3c1b34..787fd17b48e2c 100644
--- a/arch/arm64/include/asm/vmalloc.h
+++ b/arch/arm64/include/asm/vmalloc.h
@@ -23,6 +23,8 @@ static inline unsigned long arch_vmap_pte_range_map_size(unsigned long addr,
 						unsigned long end, u64 pfn,
 						unsigned int max_page_shift)
 {
+	unsigned long size;
+
 	/*
 	 * If the block is at least CONT_PTE_SIZE in size, and is naturally
 	 * aligned in both virtual and physical space, then we can pte-map the
@@ -40,7 +42,9 @@ static inline unsigned long arch_vmap_pte_range_map_size(unsigned long addr,
 	if (!IS_ALIGNED(PFN_PHYS(pfn), CONT_PTE_SIZE))
 		return PAGE_SIZE;
 
-	return CONT_PTE_SIZE;
+	size = min3(end - addr, 1UL << max_page_shift, PMD_SIZE >> 1);
+	size = 1UL << __fls(size);
+	return size;
 }
 
 #define arch_vmap_pte_range_unmap_size arch_vmap_pte_range_unmap_size
-- 
2.34.1


