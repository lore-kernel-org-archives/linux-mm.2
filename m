Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A42B8C79FAD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 13:06:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36CFD6B009E; Wed,  9 Sep 2026 09:06:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AECE6B009F; Wed,  9 Sep 2026 09:06:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 196F56B00A0; Wed,  9 Sep 2026 09:06:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E4B2B6B009E
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:06:05 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 311CC801D7
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:06:05 +0000 (UTC)
X-FDA: 85194246690.21.5FD9BDB
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf05.hostedemail.com (Postfix) with ESMTP id 66E9D100010
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:06:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=tHwGSDg5;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf05.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788959163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1pT0yQbwDkGLyzj6/qFjpw66FqU9lPeWqHePe181JIU=;
	b=NJ6K9sSPs0ZGJ1fYR2VguIOb2xiEPcHoXGErLH/wl/OstteZOs67po7bMnrlSbwqqw/WtR
	WkBgaCMl57Szj+K+phI09D+UhRlgLBpOw+4kM18TLhrqzxFbC27C0c+A06Ww/SnTGsOfF2
	A9fgCHekvF4pKJZ1ITouLTIB88Bf5OE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788959163;
	b=Ames9jB0NAINi32ohS8bfrpjctbWFXQuxzg2ZZalgu3V67F4IgA1qhCOPxpIysfT8kz3xr
	TKe6VTaDwCgDSi3PyNnKC0lCHB36GH4CvYKO/2HuR609lGbY4esnCPR/uo/D3nfV9l55yU
	8cgmowlG+i7WY7qMu9TSUm9VA7JCPvI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=tHwGSDg5;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf05.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=1pT0yQbwDkGLyzj6/qFjpw66FqU9lPeWqHePe181JIU=; b=tHwGSDg54ByEfThjAj+t4YPGlr
	oZmW25qQh71QWoYRoNFnzPGiZ7q1hBwUaG+br9xCsqnjXZgWt9jDLMbCznjOdgY/aUJtWObxG19tc
	57pIOs3bOeCLjdjYp7mt1vGNJqYKLnTr4bvNjJ4qSI5cOHCjAfJV0TTzXw0QuSuwhvUEanuY/EO0Z
	gIty+yaHouxyyAAef0FkMQqQmyrgMIkV3J150bH8PsLwLDqD69gBr5kcANXmYdvuoq3/calpWgVbg
	Ph5CZerJW2HE44JYcZe/99Zq3hCIIn98LrF0r23FwAoWI90mngX1Sw0jW3dyS/h+irw0xsHwRE3eu
	Yuvt+Xuw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x4I01-0034e0-0s;
	Wed, 09 Sep 2026 13:06:01 +0000
From: Breno Leitao <leitao@debian.org>
Date: Wed, 09 Sep 2026 06:05:23 -0700
Subject: [PATCH v4 4/5] mm/memory-failure: efi: answer whether a range is
 poisoned
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260909-hwpoison-kho-v4-4-359313564495@debian.org>
References: <20260909-hwpoison-kho-v4-0-359313564495@debian.org>
In-Reply-To: <20260909-hwpoison-kho-v4-0-359313564495@debian.org>
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, kas@kernel.org, 
 kexec@lists.infradead.org, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, rmikey@meta.com, riel@surriel.com, 
 Breno Leitao <leitao@debian.org>, harry@kernel.org, kernel-team@meta.com
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=2349; i=leitao@debian.org;
 h=from:subject:message-id; bh=MZnll+uvZ+yY/oMfw6DSCIEir7AmYXLDgRkRphbIGv4=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqoVmYSlBarC3RkQk9eIxE1kitJWwdSYMD89hTK
 8h7doIqSa+JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaqFZmAAKCRA1o5Of/Hh3
 bY5bD/9F7YKH2OjzTN+a/S5ygVJPXHtamJZIQ+TnnkmEvwQmdlVoyS4CRJSxclq4Js03mxJyva0
 qhkZaMKfbHM0I5I9MER8lgxRzomsl+gzHs4/0WCQuJNH0izWGCn3nSFQsfguePpLlyMnXCzwHdj
 OE4IIsvyIgy0jn0aqNW4FzYrHy/zw27sAi7SQoMkQT/4sVSucXjhAHgY1vDHrFiKcruHugMDjx1
 o2ai+946IwYpayMnLy82CHJqnOuvKU9mJNF1jgscp5PMnlWGFe5xaQ8Ctf2RoBsmmc75qEDTqVp
 shQ9UHRely46WbP95/46g2Nqtjb4rO0KudGUsNOnHJLefz5wXo8yHfC1dWjWpfhxa67AWwzQCG7
 Poy+diIt1+VZgMuAsYIu35h0o1YFdJmebQ4ve2XTHtMZlpHNvk7PiTcLrtXMBA8mQ7QLQTz8rdo
 3PE8mA5cpqkbWm9Ue7ItkSJVgVDhZEVuKOvZ3+kx6l78/rJ6mRE3DTJRx4lAEc6d9OtS1P4XwgG
 X6E0a07eLOzD7PipCfzttdg7aeJtDOsiG5PuhdRrO1f+bCZYKtHMjvWEeQKg2v4zaJ6G8v26V1U
 ruxQhN7Zw+LCBdD6EcL9Ch73V4T8fMVuDXXBpIfncOP01zdbAtYOkWCs1H9GyH6crGJgAlKAl+H
 GVLmgr7mIpZIA0w==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 66E9D100010
X-Stat-Signature: eku9nm41qd9qmsw4uxp93qahgwzchc9t
X-HE-Tag: 1788959163-122077
X-HE-Meta: U2FsdGVkX19EI0dQbZ/JoVLK4pNZbUAenUPGc0X7iT3ZMFO/RI2IZD1ACed79X4G7qxXapgPCnOZwxmYOywY0jRGwwwlLZwJ12e+m3PwTUBigB0rkhPrFnQBbFSGrmEk1tm67VsT3gzoj21HMse2SNcmrEewke/hb92LOqXq3H3KoBWZ59jJXYOLfKcuQlePhU66tPMhmYalZ3ahfoRKCepfYUS9vfQ1gHmv+6y4cUIwcF+6SQ0O88vZ1gUwvH83oAMlAQw12hlm7tkME4cplMjKJuuNiiuQEyjaJA3doXV8sSl13X5xktwmVuRg4q9QfxBBLPyGbq/AFIja984BUgmlmdcZLDfST/tI4jQIHWFUO5DykaAbuLXkpms/68i7rFfRh1FK3Uj2IQkJZsVXpH/H6yCAusNskVI+Oaj74e6MZzjmDxAW4CqzrvvkVYjsJyWhLcCk29bWQpX/6BZX7XSXHuqPlONtDLsrZFOOA58uG9Xfn291LjIuFoFtCjZLm2UxRAJ/mn81cE+fX8srR/yiLmsq81DGXxrqYAFIH659pcwxPL9hJ8ew0FrubnMd4T+ccdvnKxZaDmce/8R5933gSrWlpU4UZir5C23KxKqdOdnXVjYNEssN/5U3IzRQwMvXsF+CR88YSIM8UZcKdGKwZhczbzcqhXR/aHA3kqyU/zC0zw3T/zb+PWXnuxPHUkfMEU4TPKowaGfAYAE6UQHYsHVV4HndLIShJnQlGwWbvvTc8hgCMHoXDduBhgYNRxtrHg8fRmN/lUi1qQ2o0ivmIDz1NGBN5VXEuHEUEc0HbkgA8SZD1UuQUDSHZDnvWmgI5uGlXYVU/8he8Kbfjwa5tRity/PzSLlNcyve/LmGffX4gi2fpYZF9z+3fUo3Zu1OAPRkVOeMxB7lTO/8UsVYP+AUC5ITlEDE/mBqXVUCCyuP8c51g7sS51vwIBx4i5yCPcT3dWqhQ3Hwv80
 ba0bemaj
 i7SRIw4ffWOatVe/c8+LEym9AARM8GY9mQIaZuAFFoVwR7z7RNQhvLkTnLGXjzIDB4JEmfWmcx3czav84q3IyCtJsQEQYtewml+xVBnrwDDHphSLbfmz6794kdh80ZUIBcJV5yIdLMqpJrNt4X6iEpmQP3A8YeO42+DIhBjv70J2XLHzzB31kQ8gl9xyfq1DisziNYIQa1wG5Absvq+pPWVem13EJJpgw8JikgfqvYL262tPlafZEWmDFervL2HO+0I7laLMqdJUpNcFY69v/+TIoadejfi6hi/nwji9fEr0cS+ABrwJv7ZCDR+w0Gqj0njKVmj8MCPlwo0GD7DbHGeAmCTHnG6V7KiT7L/dLVP+RVdM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The bitmap an earlier kernel filled in gets in this one through EFI,
but nothing reads it back yet.

Introduce range_contains_poisoned_memory(), which the page allocator
will use to ask about a block before handing it out.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 drivers/firmware/efi/poison.c | 26 ++++++++++++++++++++++++++
 include/linux/mm.h            | 14 ++++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/drivers/firmware/efi/poison.c b/drivers/firmware/efi/poison.c
index c18edf111c710..e16d43f4438ee 100644
--- a/drivers/firmware/efi/poison.c
+++ b/drivers/firmware/efi/poison.c
@@ -96,6 +96,32 @@ static struct linux_efi_poisoned_memory *efi_poisoned_memory(void)
 	return phys_to_virt(efi.poisoned_memory);
 }
 
+/* Does the range cover a unit an earlier kernel recorded as bad? */
+bool range_contains_poisoned_memory(phys_addr_t start, unsigned long size)
+{
+	struct linux_efi_poisoned_memory *pm = efi_poisoned_memory();
+	u64 first, last, nbits;
+
+	if (!pm)
+		return false;
+
+	nbits = pm->size * BITS_PER_BYTE;
+
+	if (start + size <= pm->phys_base)
+		return false;
+	if (start < pm->phys_base)
+		start = pm->phys_base;
+
+	first = (start - pm->phys_base) / pm->unit_size;
+	if (first >= nbits)
+		return false;
+
+	last = (start + size - 1 - pm->phys_base) / pm->unit_size;
+	last = min(last, nbits - 1);
+
+	return find_next_bit(pm->bitmap, last + 1, first) <= last;
+}
+
 /*
  * A bit is never cleared: it stands for a whole EFI_POISON_UNIT_SIZE, so an
  * unpoison cannot tell whether the unit as a whole is good again.
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 274fa880077c5..b68824fcfbef1 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5387,6 +5387,20 @@ static inline bool pfn_is_unaccepted_memory(unsigned long pfn)
 	return range_contains_unaccepted_memory(pfn << PAGE_SHIFT, PAGE_SIZE);
 }
 
+#ifdef CONFIG_EFI_POISONED_MEMORY
+
+bool range_contains_poisoned_memory(phys_addr_t start, unsigned long size);
+
+#else
+
+static inline bool range_contains_poisoned_memory(phys_addr_t start,
+						  unsigned long size)
+{
+	return false;
+}
+
+#endif
+
 void vma_pgtable_walk_begin(struct vm_area_struct *vma);
 void vma_pgtable_walk_end(struct vm_area_struct *vma);
 

-- 
2.53.0-Meta


