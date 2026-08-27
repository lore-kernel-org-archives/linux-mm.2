Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 873DFC61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 23:47:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D8136B00A0; Thu, 27 Aug 2026 19:47:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AEF86B00A1; Thu, 27 Aug 2026 19:47:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 378526B00A2; Thu, 27 Aug 2026 19:47:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 12C506B00A0
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 19:47:36 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 75A34C0223
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:47:34 +0000 (UTC)
X-FDA: 85148688828.30.BF188B3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id EB40B4000C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:47:32 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fQ476tXi;
	spf=pass (imf27.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787874453;
	b=nuOMYaEzVujMR9OmWmHotUf4Rj+Ggxeqj5qvbdPwagzrqCCFx7C3k4kpvgIpNZ8OZpLdFZ
	Sh/fwNnLA1QFwUmDfFxPE6AYoYzK8dyypAUh4+dFpXVp9QHcmrbrPKFlq07w1ForI9E0ho
	NRk4HnsjyN6iN1fVgKrUYTbXkaH85Kk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787874453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r2jDlzFvOsWktkoLH2gzIr7hlSlT/K6vhqtCTnrj+Wo=;
	b=dcDYH9FX9hYdAuV7lYoQ5WThAhjpJc6BazJ7qFsO6XNVUzHJD6cK+VoZO0yxXfsmlxuWPt
	vHd1U0uGUFf89ESMSRVJhCP/7gmscyfmzu8w2fSoqFfDfxFBjSJtt+iAva6J0NgAvGijgY
	+XH9dCj5Y0XZm4BaCAlXlj6+UXVefvg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fQ476tXi;
	spf=pass (imf27.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 440CD43FD3;
	Thu, 27 Aug 2026 23:47:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A7321F00A3A;
	Thu, 27 Aug 2026 23:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787874452;
	bh=r2jDlzFvOsWktkoLH2gzIr7hlSlT/K6vhqtCTnrj+Wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fQ476tXii4CioaYamLqQ/awsDE6PQpgfETtgAKJTmpSICmIKTCgdvm//WaUr3jg35
	 r+F1JgTYduERgjwWe0TRzqGHloyHBpL62wvTcBogYzWxiqm55kGsSFisQa6/ZcIHKT
	 EP0/3uMS6bVS2tMqssEZA/uYXO3Xor6TFds1WvJNEWzn6H7iSjKlvhvuWsCLV+EA3I
	 N45O+WAqd9CvsWDYujs5XJg4Qm9GiayzuUvglk2euF3DKtZMQuxWzHA0o6S2jdb71H
	 Ru7Nh53BHtTGJ+NSToSLHu6Agf5fHHH/uY+QoddJMFVGnUA+4IYfy5Z4SYBA2lWwUP
	 gxU7MUtAEbKVg==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	lianux.mm@gmail.com
Cc: axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	chenridong@xiaomi.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	stevensd@chromium.org,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [PATCH v2 5/7] mm/mglru: make LRU folio prefetch helper an inline function
Date: Fri, 28 Aug 2026 07:47:02 +0800
Message-Id: <20260827234704.63163-6-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260827234704.63163-1-baohua@kernel.org>
References: <20260827234704.63163-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EB40B4000C
X-Stat-Signature: ffdpzg56mqhrptjq34j1hwrd3dg46zbn
X-HE-Tag: 1787874452-885962
X-HE-Meta: U2FsdGVkX19B78laVSSm6XwhIAIcmA0ZQ5M2HEEjX3U314c4HwPfzD3Y/GgLaYuBgaqlwqf7PXHRVpCN4DSMT4q258y9gQ2f3oIgAnBuDI4mfQfcaLeT8a5fpRtKXzkj/PHVR9ibWqc7MI3EGiNfo3IRpz2Fx1RTyin7+KHZ3JNuzFHT5oXzo2VJ0YbOLubUg2TW9D9sP5j7pc7MZ4PCQkIFvTcH70fKafvPWFAiJ/pIK2MIVhVdMK9Z7G8TKIxQztkW4mnQ5RwfujMmS+Y+tk3JC8pDvlFUwuFz1MQrFgDaKqnj/U+X2YZjw1wGNuFIaar10FaU9gzvxiJalZNGOtebVytIZVbooMRRuw3MIhMJd12WfMeFdmHJMggdCS+aBWA+eI6Ljtl/nd+0kq+gEkgspbY7BlUi6DzxFT4ukceLhjYdEDnrxzB/aPjLRO5UtmlHW8Oko9FuCslx1XYXQnBdp5Le7wQyREHyFfidk5ZUD9/Y7KjM7iQqSXRFmXAw+IVAW8NM/9MMYJrWFf4sLinMqu9K15sMfMRiHy9Gw3mIu9hny7sRlBgiI0jZEgkkWG0qfWccU7O2P39fHgXB5JEZzeEmeahDvtx39BJd7TVF4Yco23dw4ZPmVXIIE+Q15xkXe9vLoh37VB4b9tNSClvNU14f/Cg3HXvlSwcEp0cgWkO+/H4CMhm/JcJvUMB49YtZLeVYIZJTHDPpwfjN1FZEb5yWylj4NUrKvFHcYQ2aFNJbQ2jvOM5oxzGPltpJ1c65eWgrk+r8RwDfguToh+W72PmxlZxe0Frs/ShS3UNe+D8vLF5F/KqbPUyS4lTl8yJzC4BU4m3jIAjiI4vfzzjXA7+W1HzSDAjpJspNcGePKio8xy8gA/YBRQubYKcpLRQab23VhlryFC0v2xlpmg/1qW99nIsYrjnmgolelhh47qoYb5BsvL6I3OT/7MU81DYAcc7w0KbV7J/89g0
 eN3GAqn/
 Zl+IyUZvbu53p48DngkvHXM2jSDUkCzOS3tr1MQHDTpD/+QpuUeivvQk7NM8zAeBKRBqSIrK5ft4/5EPLtuCh26+9S5DuMo5eY3Ejh6ipyWvNfX54StRbkRA+mE7NfMDHOAgDqEpqvk35/7Nmrvmz7dMbd4ibxxhLTx05zYgxMGO/V284t5QjEIGQG8fwNJ3kyKGAnFGNLNJOkh7SB5XqGPj6o/JBSeJRyDZ28PZtv/YMGtuK+BHeobrCKVkCiEAUWJJhgmLd5sKk1KAnHWv3LOtGakvBuEBkZaxy7oJhNFcO33YatVvJ4Xjk/WBFW1zpEFmxdd8AxW5waAkNNbxSeN6k0Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

`prefetchw_prev_lru_folio()` is currently implemented as a macro with a
potentially unused argument. This makes the helper harder to read and can
also trigger checkpatch warnings about unused macro arguments.

Make it a `static inline` function and remove the unnecessary `_field`
argument. The helper always prefetches the previous folio's `flags`, so
there is no need to make the field configurable.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 mm/vmscan.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 2b33d3f44682..81f95a968447 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -182,17 +182,21 @@ struct scan_control {
 };
 
 #ifdef ARCH_HAS_PREFETCHW
-#define prefetchw_prev_lru_folio(_folio, _base, _field)			\
-	do {								\
-		if ((_folio)->lru.prev != _base) {			\
-			struct folio *prev;				\
-									\
-			prev = lru_to_folio(&(_folio->lru));		\
-			prefetchw(&prev->_field);			\
-		}							\
-	} while (0)
+static inline void prefetchw_prev_lru_folio(struct folio *folio,
+		struct list_head *base)
+{
+	if (folio->lru.prev != base) {
+		struct folio *prev;
+
+		prev = lru_to_folio(&folio->lru);
+		prefetchw(&prev->flags);
+	}
+}
 #else
-#define prefetchw_prev_lru_folio(_folio, _base, _field) do { } while (0)
+static inline void prefetchw_prev_lru_folio(struct folio *folio,
+		struct list_head *base)
+{
+}
 #endif
 
 /*
@@ -1695,7 +1699,7 @@ static unsigned long isolate_lru_folios(unsigned long nr_to_scan,
 		struct folio *folio;
 
 		folio = lru_to_folio(src);
-		prefetchw_prev_lru_folio(folio, src, flags);
+		prefetchw_prev_lru_folio(folio, src);
 
 		nr_pages = folio_nr_pages(folio);
 		total_scan += nr_pages;
-- 
2.34.1


