Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C6C9C79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 13:06:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF8F16B00A1; Wed,  9 Sep 2026 09:06:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD0A06B00A2; Wed,  9 Sep 2026 09:06:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE5F06B00A3; Wed,  9 Sep 2026 09:06:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 83DF56B00A1
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:06:12 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B4CD21201F8
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:06:11 +0000 (UTC)
X-FDA: 85194246942.21.EFFAEEA
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf17.hostedemail.com (Postfix) with ESMTP id D82DC4000D
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:06:09 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Emhkd0c+;
	spf=pass (imf17.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788959169;
	b=Q7x+oCSQLuwLvDv/8OJGXRxTHseHIxWd7e6uJzGy/BPO/L8SC1areGYJd0jsNGtCLIg1DB
	kSBE2CN3GOMQGwaUHyp+5mMRSkMOQJYrMzyKj5mycRtIgOYil2Hc0AiYHHLO/qNPG9zoJP
	S5xja6sOj4bsJl6WWKrDP+fiuvUXFnk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Emhkd0c+;
	spf=pass (imf17.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788959169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S6tS1Yb/K4/AvrXAKqpEiR5JcZF8qOSHzE/V/IVZb4Y=;
	b=DCm1seyXwz+79c5X5sCzy0FEbvTxSpUrAnIUd8Q6Lvpg8o5e746UXqXNhMbMrF6l9NfaCl
	TH0bL5gBZ+FWUkNUYbHxVICxBaP0Db1E5B9Wo4E3+F1CG6Z1kucfdbHgdKVA8wQ9TB4UfH
	g2UfRzzkyhveFpKngzeMcm0E6/gdmzQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=S6tS1Yb/K4/AvrXAKqpEiR5JcZF8qOSHzE/V/IVZb4Y=; b=Emhkd0c+jSvCqWB2hHCtjCVesP
	UhfV/ilBH7u6HeVo0QjEBjWeAvWtB/am1I2Jjzvp5kmD0JgYOiuty/biWlGwPK3JjqvNwcBieI1gA
	cMWauvnYu0O6U0YiCAm0GrwtzfVJpG7CL4YlS8GaCBmvb3XLbL0W8jufZc6w0mOOFioSmPHk6K2KL
	51FnXQUStPA2WHw044vrjr5Be+QO6o+eDCsadF8z0qyZuZLDBZzdTfDR9VgA/uzeibE+bgEoTbj5U
	+PGhdfjNDrKihMdF6WQdc5wMDt+gvq47Mhi+Jwl+/N5IoQWOASSemJ6jJ7sp3IU5365R+yW0Mxvx4
	plHr9DKw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x4I07-0034eB-1Y;
	Wed, 09 Sep 2026 13:06:07 +0000
From: Breno Leitao <leitao@debian.org>
Date: Wed, 09 Sep 2026 06:05:24 -0700
Subject: [PATCH v4 5/5] mm/memory-failure: keep inherited poisoned frames
 out of the buddy allocator
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260909-hwpoison-kho-v4-5-359313564495@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4020; i=leitao@debian.org;
 h=from:subject:message-id; bh=drOYIVpoY7AQaUepXy25YegitABVihsyPIT5xNKQkkg=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqoVmYmVxCxsLeTjYv3u9z+EL2a6qkRIZ1SrEGK
 HBAjZjn6WSJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaqFZmAAKCRA1o5Of/Hh3
 bRI/D/91oPLXxFDp9Rr/sQrlT/YiQl/S/8FOn4S2vYWZTtNRBuE6K3TFP9w3UvAoN+cWuKRQDda
 XWJAC9s+Z8+75ZltnjS7OgNk33KsMJ0svQnxXhH7BTbLvwFaQxY2+FAOdrKdvJCBfmJqhuF6afv
 mOhJAzwB/G2S7STW7sOEWTGbF5x4oHQOMZfYR4LJ1BuDtIBRopdYsVmdAbdqaHQqMJrycH6hUo8
 rLuI4EY9jtzNm/iLF8pjAa6nQTud8KwEpVgCWFHJyJeBCVYUEXeXpOXhWvIQOwIpP2qIDiWKvTo
 1orI/+xNunPwlAZoZBYFk7HUOvb8grxKRsqiI/yxrgLE8O8CoHwXYtRweyJYszYoBC0Kq7FV7+X
 8gDlNuvn+sfnUV/MkvQUyHFGULb35erkJr3A0GWPAMlfBZKrXajCasv6QugF96KhusrEHAVNXTn
 Ev+TQ3mv+U10TiZC0p1wGD65m6Qj04HciA1gXgcOOYq4Rt7g3MV6p25u5xAFkNQadTcVdZQWnpe
 KGz3bVI3BbSxBn5F0ApC92q6tOsBUy3h9zGcv13nEFo/L+BZ77T7rMbmuiXkFO1h3ssVgaJWpw+
 eoFti/Uk+3h3UnYR1x13WahcQzdkvtfrcb+mLQPSkI6up7nKhavfmYRZYN4eehwnv4YW+3leRYd
 pfRrIgOdOLAQ4YQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D82DC4000D
X-Stat-Signature: nr9595enbqcmsp9ahx933gjhjhcz5xfh
X-HE-Tag: 1788959169-97129
X-HE-Meta: U2FsdGVkX1+GHE1PsIQ3cRVXFmxCWnjphUNTYotztqTmsztzH+cK0G29KyXEvdYWB0Is3mWJwxvjfq3hYu0RrFtnjMR3sHNCQxmcuCk7A3GGWvnePMHBS6+ksbXbwN36HphrrmHgk4x/X4LDgnFcpWZGgOjIJ5HyXwYOLpluyR73cVl2uhCWOku4qin6kqw9vQLwYzFFfQuqdLUUvgZR4o3FukmMavhOEHWBTbqyoyum/C+LBDGQ4dG6WHzsfM4SgyfruVipN0OXZZdLDcWOL6TKlbNV+/A5l+QanR9AjehHKfnDlAE5Zilidg6ce/C9xnkKQXkShYN2/UR39oyo7eSsPswJ21pKPtMKk5ShcnpdhT8iyobnywYlbt8GuukXF6zefUeiYsgqc3zbDs/RtNoXS9T4EgiLr8zNuyhz1i/kV45OOkbcow/QSOaKr/IE+J9G5SkzIpSrmV38HLok30gfaQ7fAWgHH5Ep1KUg1btwloPJIbFsXql93GDPkwlbpaml19NJt68Ke7+pqI96jdhkOK6J2TJQS+WfDh8NVoIOX8uQQt+nV5etJRLaWkKUDf1P34o5SSBzxkeZMX0obokasnIhhxdrW0bOxBxaxyhT8Xk6/ieCilVeW9pAB4QMwWJLr7Ay4lX57lTt4TQAZMiDz2bjItbL64g319XSJ+fSGIzNrVQWBwYT3E8m1ziTSXRLSNhMItHIbZkKhS6ASuEHN7HIdc2kbeYNPwvqBZJG1oCvfMWqM9qXMr24XyScli6847x22BF2n/ZBWfLGZ31RPTSbFF1VtVWWhkS9arre+TAvUNdaTxN6IJV/nbSb1szkGr6MVVngrUnwmfyQE2DakMk20lXJZIxpWS970Y7TcELEBXfEfEWgo4rr+Oj1/QlBE3uMr8lec0KvWiug77apSkYczSVyhD5dRtMnKMGbA9xgf0P/0PFeu0b1uRgGjHmZlvqsMnLD3ZPBviN
 CKoUpvVG
 GuhvAi5cLxpOK9qtAeZV3s0A3oMRIBK7FbcwIKLxZoZgRqBAWoKGnKdmiNo4MMDQ5lLL3x7Iy659Q4rdaidRGlYl4rL26X5VbBMnUSqtQURu6UPI7I55T8Zsg0mgngNRVi6oFe/IMJrUBG6Tht/JsT3T3nP3dB+5UcRtf6gqM3v/gdkU5XeN22iwoMOnXJRdhZ4to2io0X3xRHC7d/clNsxatY5Adc+tivXg7VFQ8mjS2VMp1658KWAhki5qCu/VrJI/giVx36p4Jk6oO6VSIeAXkJ8QvQr/oY0m8657lge9yAhErewma0W5CEk18V28hdqbCOofY3vZKeULTnzzF+qnYAaeuGSJxvWV0tth1yt2nJdxEEXeF5KQFaj4NBGK2V9rH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the pages are being given to the allocator, check if they are
poisoned, and mark them as such.

Similar to unaccepted memory, hook it in __free_pages_core(), and thus
the frames never enter the allocator, rather than being taken back out
of it.

hwpoison_boot_page() leaves a frame in the state a frame poisoned by this
kernel would be in, so everything that already understands PG_hwpoison
covers it, the kexec segment placement check included.

Suggested-by: Kiryl Shutsemau <kas@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/linux/mm.h  |  5 +++++
 mm/memory-failure.c | 15 +++++++++++++++
 mm/page_alloc.c     | 25 +++++++++++++++++++++++++
 3 files changed, 45 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index b68824fcfbef1..9d9f2e8fdc136 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5225,6 +5225,7 @@ extern const struct attribute_group memory_failure_attr_group;
 extern void memory_failure_queue(unsigned long pfn, int flags);
 void num_poisoned_pages_inc(unsigned long pfn);
 void num_poisoned_pages_sub(unsigned long pfn, long i);
+void __meminit hwpoison_boot_page(struct page *page);
 phys_addr_t range_first_hwpoison(phys_addr_t start, unsigned long size);
 phys_addr_t range_last_hwpoison(phys_addr_t start, unsigned long size);
 #else
@@ -5232,6 +5233,10 @@ static inline void memory_failure_queue(unsigned long pfn, int flags)
 {
 }
 
+static inline void hwpoison_boot_page(struct page *page)
+{
+}
+
 static inline void num_poisoned_pages_inc(unsigned long pfn)
 {
 }
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index d9b8be696aac3..f6afdb2a89a94 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -137,6 +137,21 @@ phys_addr_t range_last_hwpoison(phys_addr_t start, unsigned long size)
 	return range_hwpoison(start, size, false);
 }
 
+static void update_per_node_mf_stats(unsigned long pfn, enum mf_result result);
+
+/* Not num_poisoned_pages_inc(): its per block half divides by zero this early. */
+void __meminit hwpoison_boot_page(struct page *page)
+{
+	if (PageHWPoison(page))
+		return;
+
+	SetPageHWPoison(page);
+	set_page_count(page, 1);
+	/* The page has been completely isolated == MF_RECOVERED */
+	update_per_node_mf_stats(page_to_pfn(page), MF_RECOVERED);
+	atomic_long_inc(&num_poisoned_pages);
+}
+
 /**
  * MF_ATTR_RO - Create sysfs entry for each memory failure statistics.
  * @_name: name of the file in the per NUMA sysfs directory.
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 404896b53003e..9e2ce833fd409 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1579,6 +1579,19 @@ static void __free_pages_ok(struct page *page, unsigned int order,
 		free_one_page(zone, page, pfn, order, fpi_flags);
 }
 
+/* Flag the frames an earlier kernel recorded as bad. */
+static void __meminit poison_block(struct page *page, unsigned int order)
+{
+	unsigned long i, nr_pages = 1UL << order;
+
+	for (i = 0; i < nr_pages; i++) {
+		struct page *p = page + i;
+
+		if (range_contains_poisoned_memory(page_to_phys(p), PAGE_SIZE))
+			hwpoison_boot_page(p);
+	}
+}
+
 void __meminit __free_pages_core(struct page *page, unsigned int order,
 		enum meminit_context context)
 {
@@ -1613,6 +1626,18 @@ void __meminit __free_pages_core(struct page *page, unsigned int order,
 		atomic_long_add(nr_pages, &page_zone(page)->managed_pages);
 	}
 
+	/* First: a block parked by __free_unaccepted() never returns here. */
+	if (range_contains_poisoned_memory(page_to_phys(page),
+					   PAGE_SIZE << order)) {
+		poison_block(page, order);
+		/*
+		 * TODO: free the frames in the block that are not poisoned.
+		 * They stay out of the allocator and still count in
+		 * managed_pages, so a unit costs up to a block.
+		 */
+		return;
+	}
+
 	if (page_contains_unaccepted(page, order)) {
 		if (order == MAX_PAGE_ORDER && __free_unaccepted(page))
 			return;

-- 
2.53.0-Meta


