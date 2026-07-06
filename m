Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B1BBC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 13:06:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F46F6B00A2; Mon,  6 Jul 2026 09:06:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CB7F6B00A3; Mon,  6 Jul 2026 09:06:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6966D6B00A4; Mon,  6 Jul 2026 09:06:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EB8046B00A2
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:06:56 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 63AB21C2ACC
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:06:56 +0000 (UTC)
X-FDA: 84958376832.13.BEF4F28
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9B647180012
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:06:54 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="cH/GyL+k";
	spf=pass (imf24.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783343214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NBmtETjCgtkgN/SlhhkioTbX83ctXCjZLTUQUxP3DRw=;
	b=N7pDdeCMl9T1S+LoUMDx6A5KuhsvtL/b1rxzBN6QYmsATkL/AoI4hFqj6g+wwFoswOKIi3
	DQdB6xnp/m+yPn5qtITX/8xybSwQAXmfMGs56/wiYCoqWn2Y4DfI2BbdF9u/WTbhD+dn/c
	U2rrJONXd7spwfhz6inTIuZyNhRhCAg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="cH/GyL+k";
	spf=pass (imf24.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783343214;
	b=UgNyD6/Z31dFIiIK7qLwYZa2f/2Dk219EQuDzpYaQPcAo9vHGOxGUYog43TEgVwnrpjePN
	L0UO0hjslowDw+IW7Q5x5b1AvJPjuQvLZnnZOCEUtJH6/PfHGi9QVsIxK6AqXyAtXUGJXq
	/fMHp1QqMniPiUN1BHNqNiAdN3Dhq8o=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-493adc4ff7eso3028005e9.0
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 06:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783343213; x=1783948013; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NBmtETjCgtkgN/SlhhkioTbX83ctXCjZLTUQUxP3DRw=;
        b=cH/GyL+kwZb3VmceEn5k0AV+46qr8ZB8GrCdkvzksxxL25xVr6RFHsHbltWvqj4zjz
         ZSsy+rqkiATpf8lKcDueAwRavAYckL069YhLgCzN8ciSY1vto1yypfl62/BL2FK0WOvW
         PLF1ji69nanRSgzCm5BSFZLGdwfQtfBicDpyyDOy6zxqBDDn2SmE6xYqCm88Dc8c2WPq
         fSiY9/f48zSGdA+RoXWYxm/ZKhToyiXMeJY2vTMkK0M9f1Rz4jye2lTKS6Z1GbpC2oMU
         xtIkzdahf3W1b/SX8P3+7KyHAm5j247vyCzhFpNwfXjoYgO0U8BifteOAySp/Uz+X4/Y
         2/HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783343213; x=1783948013;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NBmtETjCgtkgN/SlhhkioTbX83ctXCjZLTUQUxP3DRw=;
        b=RDm9P4jKjyIjrY/n/AzS1ijn1bpBWjPf7U52XsKgG5/tuENr/j9daem7dtLyioDSKj
         CBgtTIIKI1PLGN/wiYzye1yGrbpLJL7tvL0b3+m6w7uP08Z8T6dc6FI2D4r35higsbmd
         xnvVnON4S9sPqD95JDX3jlmkYj+zYyjQeeVSLnx9m6rp2ZHnGBejFkpYWq1l/nzCdW+8
         KVtciKwyxGlG+3vWYDu9RcpY6d2uYQCy4IhzF4AJEGKaTIJIOOWE1rURrmETqY/QuVRv
         6N+SLOyReSqt8r8d3aGA6hyb/jEps7xSJwZ06rmFzmOEu0ZF1w3w3fS1LRs+IHCcKD50
         doIQ==
X-Forwarded-Encrypted: i=1; AHgh+Rrx9wDvAwmPqOc1fmknb6o2RVEIBccRJvwhIqTpK7TE0gXh7uO4d8DxnMPgGDbXrG0G5kn3xJ1eHw==@kvack.org
X-Gm-Message-State: AOJu0Yy5/VueeT5eIJkjT9yaII012v5D0rRrpQvbZYvFNnk7/cErrnh2
	O0+OxKi8lxvPPhljrS1YwLcRQ6n1xc7c3/068vgkXjqbPulexZv6qsEUDVXAHF0GgaqPYw==
X-Gm-Gg: AfdE7cm0Jh2lCFWOQtEL9Kbyqxyoqd9e6x9GUVdmq6ZcAE4Ap+J7Wn7sX3sgn2lpzlI
	jO6/eZ48ygeoUr7kGLFqEAsCN2AdKJjbv9QCbQBGAIniIi4I+2OGh10Eo0K/ACC8bV/I/7M/BjY
	4HpVWlJRVVpIKW8X3MOCiAmi4n74Jo042jlgEQbMUgZj8F0slvF1iWC5GYI6ZRcCpj9fYUwKloS
	ElbJUy0XWKxQzXlhJfpgh/J3L0z3JtGRncZdCkpY8rM/wF8/YRSWv1X/0LVI3Hf86Cefn4ZCpFE
	hfOz7dwPuvCvFYI5JOoLrrWakLowXgQ1740K4SMP/s1XxOVv9AisRk5XZZkk5g9nyRVl2hBI4d+
	0s59CS2xXtbZ4+krIct1ZepJJ+Md5k8l4dzkD90Agj7YG7eg4jTjQdixS0DgOpjimWUevGxrDhb
	eVUWAPOaHgwqw3hxQm6tcJggPoVlVL9CFDluXTlmdfv1cB2ztc4FPPXSTq95SWXVbpqHnOoaYnS
	7das4lr1OJpAa34nLRQ0duaQbF5Td+7TGg=
X-Received: by 2002:a05:600c:a203:b0:490:b2f9:d9a4 with SMTP id 5b1f17b1804b1-493d0f09261mr45185535e9.1.1783343213043;
        Mon, 06 Jul 2026 06:06:53 -0700 (PDT)
Received: from debian.lan (vmi1894487.contaboserver.net. [154.26.158.71])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47a9de1d8f1sm24515956f8f.3.2026.07.06.06.06.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 06:06:52 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Lance Yang <lance.yang@linux.dev>,
	Jann Horn <jannh@google.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [RFC PATCH v3 2/3] arm64/mm: add set_direct_map_ro_noflush()
Date: Mon,  6 Jul 2026 21:04:39 +0800
Message-ID: <20260706130440.9295-3-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260706130440.9295-1-xueyuan.chen21@gmail.com>
References: <20260706130440.9295-1-xueyuan.chen21@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9B647180012
X-Stat-Signature: 5umn4rk1jgu5ty9p1p11874xdqrwegmn
X-HE-Tag: 1783343214-954024
X-HE-Meta: U2FsdGVkX18jAaQzGTNfHVFr9YNsQrv8SlZeuyR9T0a0Qlh0oOnlKD86fZN2GiT0Q3ibG3erL7JqkP96a1+W9W7L8Vkku+PePoJUrXmJV3eJPGExdpkefdmTuUJmcndrIyf3aPaTkJHIHR+fjRC0DN/kQy0xU/IMR9kBU6sx1GprpHJtcALOM6EqO7HTRCV7EBIVLsOYOOgMaflEt2lJqSLW6uvGxVAV8h+pG0X3vtBk3ZDaYVUVpI2cWuPDTVDrifQfw1Hg65FpIxhYtJaEjETphsZWMevwSPmMI5pcKCuVtkENLUFt6rklWQglKyV0gIhY7FARUqkVabkevG6jK4mZXPXgRbbxSL5+WfDmD30oGEcUyJEHcqrid6t1T0TSDuuErLgcJDFsccyiOOnsua6n6O0E7h2Eh78Mn6UH/zaeafeaCx3iwouB1Xk1HQ/mt65T0SZrhodWFe6iCN8kLROw632AFdWavJUJheU/ZPWZkDo9QhYMGZnwXGULHsehBuacJeInoqbjUVEFfXQBImGCuO+NRKyejzhNJol72+4BPNivztmBYbDv+nGi0qfIwTDUN8TQF2hNO4gH2Tiu4zMCYhyZb3TO+diKBFUfCd4eWK5eevxzZnt0RLlzuM6DJUMxJQpT8vFGAm8e+HYQlaonsx4jiD7L7v5jZaV/b6Mahl6c04bnnXBvqFc+n2HzgUk8ZPObq++SlskgzKQNzlmb3pA2HWQQvoYCtp2rUR8AJQVIs2ZQe0EJOJldOx8V9bUOoucIK65Ac/HApf1J3QhSV+Na6s26XCM1RYUhqrNO+0RMy8BT1e2MZeSZDEdSuigmfd9SFBk2kDl6CQAlYKLpWIhrxtqmyKcBU7W+NKbQVWi9PlbrXj+iBuQD1AKI71bkmrtcPP3HxHGPDko00yBhOu3M2BujAABLyL1N8dtLaVlZB1V6zzsD2n58Vub733hdqsIFANKL56rX6Ww
 4DNuSMHB
 D4NI7f49OX7Pjzf7J8g15zO3W/SSY/gtQhe0LdApesdBZO0MbCw6LNCTM/gBRkOHX6EwQtr3LBS5ma9yi8wmH+lJ4ZuocYAo5rzXxfayKOkDqOv7ZfM9ezVgRXNWEOBpRmDNXaiATWuh1aXJprA2uo8LdUAbnOHnD2AeQGfWA/54xWP3EpfugOMB6G4IAwvMSTDtE47jRiJgpEiwmModcxN2N402JbbhQr3/Lh1mYfhVtuFjVBgVNn5q+zYC+6jVNxjIMd9Etf8wLj6SonZmpjJHcDi7BpE55Jj8zWdbxw6sM7zRK6O2mwcLo59RjyK2cgpxrYu6DtUXCEWNlM4mF+QMUyqAaxxpAwmE1p/N241l5W5HTLCbt99pnMKQ/pHrfekqqHw936XqZUL2YzMsjKxrue67lFx0ZUgMe0xjCgZ04+uffVEnJh9DMG9l2+spwmt8eI4LPy8uzhn6aHRnTMiChI0u5Kei/hBC6bZ6/ZZkKGrNXvqcyPkqRTDIcs4f7f1QgwAdUT6FG/bHbqgyV9BWPyWlHunkgfV/uhUfDL+VOch8Oso2jJO1y1/AC7KVTOyiA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Xueyuan Chen <xueyuan.chen21@gmail.com>

Implement set_direct_map_ro_noflush() for arm64 with update_range_prot() on
the linear map, setting PTE_RDONLY and clearing PTE_WRITE. Keep the
existing can_set_direct_map() guard and leave TLB invalidation to the
caller.

Co-developed-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 arch/arm64/include/asm/set_memory.h |  2 ++
 arch/arm64/mm/pageattr.c            | 10 ++++++++++
 2 files changed, 12 insertions(+)

diff --git a/arch/arm64/include/asm/set_memory.h b/arch/arm64/include/asm/set_memory.h
index 90f61b17275e..7083260303c3 100644
--- a/arch/arm64/include/asm/set_memory.h
+++ b/arch/arm64/include/asm/set_memory.h
@@ -14,6 +14,8 @@ int set_memory_valid(unsigned long addr, int numpages, int enable);
 int set_direct_map_invalid_noflush(struct page *page);
 int set_direct_map_default_noflush(struct page *page);
 int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
+int set_direct_map_ro_noflush(const void *addr, unsigned long nr_pages);
+#define set_direct_map_ro_noflush set_direct_map_ro_noflush
 bool kernel_page_present(struct page *page);
 
 int set_memory_encrypted(unsigned long addr, int numpages);
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index bbe98ac9ad8c..1a6769073558 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -365,6 +365,16 @@ int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
 	return set_memory_valid(addr, nr, valid);
 }
 
+int set_direct_map_ro_noflush(const void *addr, unsigned long nr_pages)
+{
+	if (!can_set_direct_map())
+		return 0;
+
+	return update_range_prot((unsigned long)addr, PAGE_SIZE * nr_pages,
+				 __pgprot(PTE_RDONLY),
+				 __pgprot(PTE_WRITE));
+}
+
 #ifdef CONFIG_DEBUG_PAGEALLOC
 /*
  * This is - apart from the return value - doing the same
-- 
2.49.0


