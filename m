Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19AF1C61DC7
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 12:05:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF60F6B009D; Wed, 26 Aug 2026 08:05:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCD536B009E; Wed, 26 Aug 2026 08:05:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBC6B6B009F; Wed, 26 Aug 2026 08:05:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 986C06B009D
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:05:00 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 19537160354
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:05:00 +0000 (UTC)
X-FDA: 85143289560.25.347190C
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4A99D4000B
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:04:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=eJhsOs+d;
	spf=pass (imf17.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787745898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ua19ttiw+1gS6VkqPomk+aSAT0oJIssRXjVFuOoXcyQ=;
	b=afeMu652OE3KPL1/02Ss0kzLHyHLyNfEWlDciEBeEOpu825EL19uKjkeZFMLQQhN19rW9H
	7QHqkyNOarffiwqTPZhiq1txqMgtFvMrsntdv3Z4aXce02YQ6aNGUCqkvJMEF/soeXY2gN
	cMMvi/faZh4ESoV8vtit9zRM2ExEb/8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=eJhsOs+d;
	spf=pass (imf17.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787745898;
	b=pB0Rt/OxIJ1Q/xKrUb6j5xZXW9r1JMp0pB1sKmDTVABEVAJqzRFwu+GIi1LZcHAjPs//7P
	gvA8l5wKs9wGr9SbyjF1CdsaccqICJRd3P9E0fDQhCj8w4PV+ABILhrgUGt3qqcRmMj+PE
	RvALmdjvx8Nu+EWC3Q7HL7jCII2KRXE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=ua19ttiw+1gS6VkqPomk+aSAT0oJIssRXjVFuOoXcyQ=; b=eJhsOs+dcKxgZEjIawHbnCfoxR
	FJoj2CNhOb1rCtnrqH2Mm5aAlhy0LOqunuNfO1EA6x/ZK3OFyOSYpP6kp+gLpH6XoL4OQaK/xRKki
	pX7HzuixQR6+8AEy8YUjtcuSATq+wSmUzpUfLNfUkezzAAEiqfNVvC25+hWJu6NrfQoh1pvKkmP/N
	S8kFISupRIKNuvwk6E/mgWW/iuLDuynkVUMay1aPs8ymGFi/WIIcM1BMzocl5KnGPAp5rnMI7P4ez
	q0++WLO/Ya8vMFeuh9tmFVPZxYYtnFmnHOuFHmoFEGgXFvwMymeTAEoCAOg6C8UyC23eHL7dzUmir
	7B44HBnA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wzCNC-00FCXg-3C;
	Wed, 26 Aug 2026 12:04:55 +0000
From: Breno Leitao <leitao@debian.org>
Date: Wed, 26 Aug 2026 05:03:55 -0700
Subject: [PATCH v3 4/5] mm/memory-failure: add a helper to poison a frame
 at boot
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260826-hwpoison-kho-v3-4-6f79c4b605bc@debian.org>
References: <20260826-hwpoison-kho-v3-0-6f79c4b605bc@debian.org>
In-Reply-To: <20260826-hwpoison-kho-v3-0-6f79c4b605bc@debian.org>
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, kas@kernel.org, 
 kexec@lists.infradead.org, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, rmikey@meta.com, riel@surriel.com, 
 Breno Leitao <leitao@debian.org>, kernel-team@meta.com
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=2675; i=leitao@debian.org;
 h=from:subject:message-id; bh=o7M5nleNUlNmnqMGyVTK9Qj2BeNxjWI0gsdkMd+ovbg=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqjtZLFACyJ88fYHvmvDeKqRvOsw5p9Y+n1bm5D
 Mzx8D61g3WJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCao7WSwAKCRA1o5Of/Hh3
 bVB+D/sH01X0pquQmQeP/oQwRNdbzSLw8hrBthdZ+iuZnJ7EHMihKbidDfHRr21dB7Wah97UeXu
 5tqMyBCwmEUKMGWLphOO2rTVM3srwtYk/XGmp0yy635/DwcN0HvOEeWmabJFg699vfaZ/SCP2Vb
 JE8vJL2/GfuL5GwtRZmgsQUQ+S4phKctRMge8sk0Ggg+eOHf6QDZQafMOlZjP0kZYppluUTE5pE
 /bBRllA6j0Gh6MiXOpnapCz9b0ERKstaO8YWOUWlmMLXJEuBbsRx+HdUGUp4LPV7toFT+RiGjz6
 ttsLGOS3n85dg9Q60645l3tsJOGdGMAhF5JiMLTw3PQ6wexEEpzwO5syX4+NOLlfeSFDW1/c1nX
 iiUBw1tymNwiDEUXh0GhvQq2CJukvcp8a+OuzWmIcg0IX9hw9M20qqY3ypRVJc2LvzvZFaP2Fa8
 I3alDzhhkiphuwoMnicMqCg7cGjJqba2vNPmWin7iPqk96K/Mk1k/8jRDpE/QgJcziewYWRd8/2
 0bRqDeDM2P3Q3PBpCzGU279PckPuqgGZ8duiElywmz1Q9Muik3O8uh54+r4e4zj958/GSrKZ++p
 qlVPg+pTp0I8JwfifiUB37YCoihHpNHZAr73OSS96JxHJMOE6kJ8jRYaWV0j1ge15pLYu2wRD5C
 CnO+jWKzf1QGruA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Stat-Signature: g8nfnfzjt38kdhn3nsu66s5gkskexhi8
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4A99D4000B
X-Rspam-User: 
X-HE-Tag: 1787745898-228831
X-HE-Meta: U2FsdGVkX1811gejLyt1mvUd+LPa6rZ6ZHwGzOf8Yd5SpBypQwC5g9F1wT+30qWjB0z9IhORYSQQO8Qd0yTVnz/EK4YGG3ArwvvoM7j2zArd9uwjdsB82eGRYHlmOVuTiP0W3jQMQC28Y13Bu6lFyfD1SQSVzFgAxkBZLoVYTpkSYkfvHaNk6aEVkv7j4D5MpFZo5FVRcARR6ga7Oal5lazZoymWk/+AP5OEY04ZMCGiVofriQdbPIPQF2xjDbPdz69ofcBEAuflnFPeGz302z7VC3q2qQ3fulhLy7R4LRb4P2uLY6tjnb3sAYCcXy1G17SZ+76VQ1367/gugQULrZuNNttZKmoaPNuRaYTkeXqYqOI8qYpkncIy+qvq8F+SGMCc2Jg+ZudiwKUS4wjxOomrhxEeOEAdcRozHPJ48eJXMhpyzyHPYluT39Uf/oJX2VGg7pKD9PN4CmFA26LzY0xaxlCJaplACS6AjOdhNe6stMDSBzU4u3qIrxIHfm4jT0fFAuukiv8qKRkv23+IxjMMSclllb5XEiFndg72rJUkxO92rLdJDR9DImp2JQMv1EP+In+pDuJlBpIypq3fVTBOlOlHHGWUxPPoPOccxMAmU1ytqKjZsSVWqv5Icb252yjgonuNeVbj6BSg5OhMbdNMTH+iYSJNegpiI57/pcvndEaJYEr9XhASN9AZ7kNgczWtMfj8DmOlVRuXuCySlvCmQPS2hTC0GauwNHMnyDjMm56WS1zmSAuvdCqu0syoEuM1VauR3A087EufslMXwR7dqydivuHdWvs0Q0251gqE1GdN4U9IWK++JQdu528AQTOMCbV6nKy2ja/tGZ4AQBc5Xn+yJBLy8xn+7vtgZGnsOl0RcPjEaLXrZBUsFsYiHpjecOEFA+D9mIomaCWGBJGigXuQOOi7fBSkDdMh1Aom8bwdBWTsC3FjDhKWtndz+Sgz3cTNDu02ty5v93Y
 JKNYQhJK
 OwKgt9IY3t6/KDhvbyJseIezYSorhFBcSO5IfPmnrngm6zjKfe0hOVzfhFM8O4Uy31aqWnhdmUW9lyjGMoGUCvzCfyxpATl0a9Z4Ibf/8EryRWQ7HPBMEuJ0OlzeiGT47PBDPm9Cmt7x1Mat4y0XJ+ijhOo7K2Jmt1kQZfD1jArEQ6VOwc/dMfrLmOVgmUXEza9vi2CVpVZLHSCa2wXjlUEFXiPXE/UPTrFapN3BqS5nOHpf72eSXC0EQ5qY+yuWF0fyk7uPcRsrs6hsrQ8WN3wDB/pmnD7T+BMgidQBOSgtifhP2iLs+lagyPyx5iXVZ3FrN1zdoZsA4xaA/Er3O7kkJCQ9oEMi9DXxJoaE2ulIeSKw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A kernel that inherits a record of hardware-poisoned frames from an
earlier kernel needs a way to apply it. memory_failure() does not fit: it
takes mf_mutex, prints a line per frame, and a 2M unit is 512 of them.

Add hwpoison_boot_pfn(). A frame that is free takes the same route
memory_failure() takes for a free page: take_page_off_buddy(), the flag,
the refcount and the counter. A frame the kernel is already sitting on is
only flagged, since it cannot be taken away from whoever reserved it.
free_pages_prepare() drops such a frame if it is ever handed back, so it
does not reach the allocator either way.

The accounting cannot go through num_poisoned_pages_inc(). Its per memory
block half divides by sections_per_block, which memory_dev_init() only
sets up from driver_init(), so where this runs it is still zero and the
boot dies on a divide by zero. Bump the global counter directly; the block
counters stay short by these frames.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/linux/mm.h  |  1 +
 mm/memory-failure.c | 24 ++++++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 32bb723ffbb92..52a00a0e090c7 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5104,6 +5104,7 @@ extern const struct attribute_group memory_failure_attr_group;
 extern void memory_failure_queue(unsigned long pfn, int flags);
 void num_poisoned_pages_inc(unsigned long pfn);
 void num_poisoned_pages_sub(unsigned long pfn, long i);
+bool __init hwpoison_boot_pfn(unsigned long pfn);
 #else
 static inline void memory_failure_queue(unsigned long pfn, int flags)
 {
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 357a72ffda625..713fb2f8e0332 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -97,6 +97,30 @@ void num_poisoned_pages_sub(unsigned long pfn, long i)
 		memblk_nr_poison_sub(pfn, i);
 }
 
+static void update_per_node_mf_stats(unsigned long pfn, enum mf_result result);
+
+bool __init hwpoison_boot_pfn(unsigned long pfn)
+{
+	struct page *page = pfn_to_online_page(pfn);
+
+	if (!page || PageHWPoison(page))
+		return false;
+
+	if (is_free_buddy_page(page)) {
+		if (!take_page_off_buddy(page))
+			return false;
+		page_ref_inc(page);
+	} else if (!PageReserved(page)) {
+		return false;
+	}
+
+	SetPageHWPoison(page);
+	update_per_node_mf_stats(pfn, MF_RECOVERED);
+	atomic_long_inc(&num_poisoned_pages);
+
+	return true;
+}
+
 /**
  * MF_ATTR_RO - Create sysfs entry for each memory failure statistics.
  * @_name: name of the file in the per NUMA sysfs directory.

-- 
2.53.0-Meta


