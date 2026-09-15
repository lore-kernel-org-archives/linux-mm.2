Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0141FC88E7B
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 12:55:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F14C26B00A4; Tue, 15 Sep 2026 08:55:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEC096B00A5; Tue, 15 Sep 2026 08:55:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDB9C6B00A6; Tue, 15 Sep 2026 08:55:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9EFCD6B00A4
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:55:06 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 25E4E1603C5
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:55:06 +0000 (UTC)
X-FDA: 85215991812.12.0167B9B
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf29.hostedemail.com (Postfix) with ESMTP id 71283120008
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:55:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=peho1MiS;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf29.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789476904;
	b=ibnHggEcLIXirvngzgf/mgFPIrZaQ9GtIBoBoQNgy6QFtHAxnhSYrtQjAYhaabVRbrJ9PD
	oLvSDlvsmECY2UbdqanRrixV6L0DbA3FITQv7PskOgSRXn5RCpRizchQy554DVGEaYv3Zf
	OoeCtdH7YznGpfyJWJ9qlL6qxmbszVw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=peho1MiS;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf29.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789476904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nJQHvGBJYwJr3F/aktnOoCOR2Bfx83QmvxSaOEex9rc=;
	b=XzdDbgORvfm38iVwk8RE2u5janrwHv97cJXrX/boLHeIN2bfv623/4KlPk2Q5aCgOr9q1s
	UunGVfcI4/TBV8i+zDtqWXEXa3kUdNBlYpCsal3WhLm7MTRkErBv1E9Mq6WdkGUQMUXy0h
	nnBE1wf8pq9UNohyoFjnI3qiVWwe2qI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=nJQHvGBJYwJr3F/aktnOoCOR2Bfx83QmvxSaOEex9rc=; b=peho1MiSPxeM5E9y6ZkJnHD3Ac
	ENhbZZIxpw7yPwYcbEI1X27MJfJtisrsN896BxohWU9hGrJtHupzLBnfbm4DthteXHHreNWnt9Y5C
	8QS67ouHGUb8vn4m7JblIDmUdx8G8Tbq1ljQQFyC5VZJH4+0zEoMry+Cg+W+fLVO3JLBqhXxHMz21
	G8aYg3DxyZ+70H3BZqt2ucu+76cl8M0D5evcCm2m7AbyGfDpkKcp0ON6jHuIPa1JO41TWuoiDOdJs
	wCJ2/NXYJ3k2TrxgelPLDMwcY8BwBtdD41XbfHfuA5/SgPYSwl3p+LEVrAnV1biPV8+pa8risBmSL
	ZygLzG/A==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x6Sgc-004P9J-34;
	Tue, 15 Sep 2026 12:54:59 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 15 Sep 2026 05:53:42 -0700
Subject: [PATCH v5 8/9] mm/memory-failure: add hwpoison_boot_page() to flag
 an inherited frame
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-hwpoison-kho-v5-8-3bc7a57bd503@debian.org>
References: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
In-Reply-To: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
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
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Oscar Salvador <osalvador@suse.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 hannes@cmpxchg.or, shakeel.butt@linux.dev
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, rmikey@meta.com, riel@surriel.com, 
 Breno Leitao <leitao@debian.org>, harry@kernel.org, 
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, 
 kernel-team@meta.com
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=3014; i=leitao@debian.org;
 h=from:subject:message-id; bh=pkvLVOtl/wJxWCab4MZWos3IO2QmqKMvCWQXOQFBXcc=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqqT/ejMXIQjF5HQn3VxXq+6Zy/+n0FqXVKhxTp
 P11aWC3wMmJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaqk/3gAKCRA1o5Of/Hh3
 bY+/EACFlIZZKCGkeF1D4pH+3gCLk17ltEVj4rCRVqtzUt3BEHbKX02a5iBOQC/tfTUtE95ecVK
 lOWKniPGfAbmnAp2TL4aXXUneo8dI4f/STXSJo9qHWYK/Ry9cDgT1xPzvPYj0YDbdp+okn4MT8e
 Tuti3cA3W+IdRnIsAuJMv1FoGqcEMrsOKnyyODshHbHg29gADtUKTLc5J7ccFlVbejrCjPHu1lG
 SboVxR+tnbt3la37O7iBxy8VmdO9Tf69BtvNUmkPuXB452agmhtTAt7EwdfBwIQfmyyrM2yThfP
 rmqSmnXOL/D9MQFjSABsdm/5MrDZOJ8sBY7xpVhGrpBjiFD9Dp6jWC3wFCfuGlSjhONjnYUb3xT
 5J/EuMM2Jg4CJpW9GDxeomC6qbiJXOVuMVdzQfDKMwn7aPdPL2JArr6UkKKVAL7J2eina1oP7Iz
 Og5kFNxhLig6XpPc//LGzKXEXdCESf6B39F/UKPWabHLHJz9Od9S7Q8eNl5KmGoUrANCyGOQvzE
 cKokqpD7Cz/cXHDBief0J6Y3wE/JnD7y0D6fpIYHs/K5GKXf4j+oyf+LEhf0EsjKhRm8GMFXP88
 Nk20+jo7Z/87cujzF69coCuRzBORUnpsor0dJA+DFLKUabKCfDz/ikqi6sCv6YCO1fAnwSKgakI
 RD8ZDEpMLOGVIkQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 71283120008
X-Stat-Signature: cygxhry4wgmudjfcgdiuukt5zinkyi5h
X-HE-Tag: 1789476904-589031
X-HE-Meta: U2FsdGVkX18FLuCXYuG5n7JF2FSokLjyV9FFB0wK64Ca5bs2VuQ5w/XW9IX/On3cOKMBscqz6Gw85LIt8F+x4wVNSJYiY2o7Bi6Ya7mWKJm1IR6nz1gxVGnuXJNbeH1n2RgXE8hHPLL89dsltJpU9lc0cFqN15+nfXFlFWtnRwAPn8/ls0orrNlCV94RlaZeLcG+8H3rso0pZxzHoDLLyEtI0NjujTlgWfZIm6YKZ21qjsIkLQhDleX3e/HhjmsmFkJ0lBiyzVPuc6T0SATKzlqgxnNnUFJx1Lzk2UTpz3Nr/V1PLzNcUaKi9ySysSfs5ZbYTK4nVoTssTP+QE4Mcf83WHSt9sXyabIk2Di/RI7xsL85kpRPJd70igYK4cu8j8Dssyj9YsAzHsDn130e7KiGf+73y3yGS9AI0mWThpINTvfxyOFghdLZfYKycSpwAZ2Bj6KYfmOtJS3/Uo5F4Vk6Zi6HsB6ZLkOSCBHbZT+q/bJ1wqX+cKQ6C0HSkBZKb/07feFBWmLo7NA9cHveDZnWpNXdkh31sTyisBY25BdQABKVfFZfgSO6bHOxMs/pfGhqfgx/4jK3GSwHwD3KeeDtnQDmB1EiL6VBFWu6VblwbLB1ORM29tBUPn1WALubM/Agn7mwkb8iQiY7uUE0E7utd0Jnx+ScmFzISnmGwPWsy4TFnLatrHzWQA6Iwf6aIQm8rHOm0FlDzP8IfJDUcoQcBgCeRkOreh74/zx8Seh9kCT7MyvaZm4m3E2YpsD3FSxIG4QvkZzPdDWeGdif2XBrwv4SXvMNKJbl15ejPCOhQiz+Gq/m6eLOIaexOQ6fug5OtR8jrmmtU82RZ/1UBOo6Iygrape6FJOuyZZ+kc/6z+MlOMTLnB0ASV2euFEbFPbVvGycZSO/CvL7BbAqmrTAKjeY/3W9eXgY2PrG0bOfn6Tfa1gjPkDktzGjRNcCBz+aYb4+kb4/OFR6B1U
 lSOgARVL
 FYlUKUgwQ55sdZrJXGr85SbmZqoiQqpNEBTzY0CtVq/6gRWvvs03Z78ZKNoF0+M0KkJwWsZyz+7YUsCtxF2+Bp8Fs/QgJ5xhrm09Jb2HxlTyPlX6q2xAZdDVzSYlSr+pi3JR2QAYbKhyv9oJu3RagYXiKRLb+it0VP1dFl9MsiNBf++RCsp+V4L2fsMQFVnG1cFFuhdmm28wdY3V+94TyVVdT4XQJNWQS8Nc7kXo4LmsrQ4hrm7pbqbUef3Mv/RUCg9rGjIAF2sINwoiSDWSiv9kCHvxXKolz7Hww/lKq8LPgot6HBreGGikvGIwmAnAj4gn/VRr2qHYpdQyz4Bb0AA/H4p7Zc/gttlU5Mu1eVkP0TrLD6KbSXe0mdxK9dX/sGi2iZGQKBm44+b1x7NvM+SGtBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A frame the previous kernel recorded as poisoned has to be flagged before
it reaches the allocator, which is long before memory_failure() can run.
Add a helper that leaves it in the state a frame poisoned by this kernel
would be in, so everything that already understands PG_hwpoison covers it,
the kexec segment placement check included.

num_poisoned_pages_inc() does not work at boot: its per memory block half
looks the block up by pfn, and memory_dev_init() has not run, so it
divides by zero. Take only the global counter there. A hotplugged block is
already there, so that path takes both counters as usual.

The caller comes later in this series.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/linux/mm.h  |  7 +++++++
 mm/memory-failure.c | 26 ++++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index b68824fcfbef19..8039830998dd4b 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5225,6 +5225,8 @@ extern const struct attribute_group memory_failure_attr_group;
 extern void memory_failure_queue(unsigned long pfn, int flags);
 void num_poisoned_pages_inc(unsigned long pfn);
 void num_poisoned_pages_sub(unsigned long pfn, long i);
+void __meminit hwpoison_boot_page(struct page *page,
+				  enum meminit_context context);
 phys_addr_t range_first_hwpoison(phys_addr_t start, unsigned long size);
 phys_addr_t range_last_hwpoison(phys_addr_t start, unsigned long size);
 #else
@@ -5232,6 +5234,11 @@ static inline void memory_failure_queue(unsigned long pfn, int flags)
 {
 }
 
+static inline void hwpoison_boot_page(struct page *page,
+				      enum meminit_context context)
+{
+}
+
 static inline void num_poisoned_pages_inc(unsigned long pfn)
 {
 }
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index d9b8be696aac38..60e9682434700b 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -137,6 +137,32 @@ phys_addr_t range_last_hwpoison(phys_addr_t start, unsigned long size)
 	return range_hwpoison(start, size, false);
 }
 
+static void update_per_node_mf_stats(unsigned long pfn, enum mf_result result);
+
+void __meminit hwpoison_boot_page(struct page *page,
+				  enum meminit_context context)
+{
+	unsigned long pfn = page_to_pfn(page);
+
+	if (PageHWPoison(page))
+		return;
+
+	SetPageHWPoison(page);
+	set_page_count(page, 1);
+	/* The page has been completely isolated == MF_RECOVERED */
+	update_per_node_mf_stats(pfn, MF_RECOVERED);
+
+	/*
+	 * The per memory block half of num_poisoned_pages_inc() has no block to
+	 * find at boot, and divides by zero looking for one. A hotplugged block
+	 * is already there.
+	 */
+	if (context == MEMINIT_HOTPLUG)
+		num_poisoned_pages_inc(pfn);
+	else
+		atomic_long_inc(&num_poisoned_pages);
+}
+
 /**
  * MF_ATTR_RO - Create sysfs entry for each memory failure statistics.
  * @_name: name of the file in the per NUMA sysfs directory.

-- 
2.53.0-Meta


