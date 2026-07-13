Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5935EC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 09:43:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B3FC6B0088; Mon, 13 Jul 2026 05:43:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58BBF6B0093; Mon, 13 Jul 2026 05:43:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C9456B0095; Mon, 13 Jul 2026 05:43:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E2496B0088
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 05:43:35 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C6DDD140A85
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 09:43:34 +0000 (UTC)
X-FDA: 84983265948.28.16A5A32
Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	by imf09.hostedemail.com (Postfix) with ESMTP id AAA88140008
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 09:43:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=Vpd08eG5;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf09.hostedemail.com: domain of wangyijia.yeah@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=wangyijia.yeah@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783935813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=YVmVbtBX3HCj9Ijd0ts5x4Wm1TJDsoimgyijvblmLxM=;
	b=J1cB4TCtpYDNsP1Pf/GsQj5DXv1CEFVVVbLDLkmaKqfRfrfGYoEd8XNnM2LJ03l/HK2nQ3
	6hVfNSTEwXEm2hTiNxrxwg9tN8kS5nOTmiL7exXd+QnWzlBky8UJCQZwL7UME9cNtp635z
	ynb+LfmpIoRitRdMyMyG8/VFSsK7gZk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=Vpd08eG5;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf09.hostedemail.com: domain of wangyijia.yeah@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=wangyijia.yeah@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783935813;
	b=k1ACQpf6pj26BTlL7HB3BxmZnOYBobFbWDOHfedLxtw9GfENfIZnY22Dm3Z40i+IdX6HSK
	DDwW9UU4nkzmAcU2IU6qLvGyWI+jpF8vQtfacaP6L7uHOWksUUe2xT0J59ox+LeOUh11Zi
	C9q0qimolHvwbTdwpO8a+vWOoczXcFQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1783935807; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=YVmVbtBX3HCj9Ijd0ts5x4Wm1TJDsoimgyijvblmLxM=;
 b=Vpd08eG5mYOeAXAMCR/jYa2ZDQrFEU4NmYK1Ty0KaLkUctzIVecmT1z/WSJGRLfqaJ5tFb
 EwV+5ft8pE8RJ+MbKuDzg9lkJZbHhkYOAv1P+t4KTcGJSG3ORTj1twt710VwuWnqWkSngL
 42TKTCFo1BSyyuXzn3Uk9BEk13sIgBePePJhUVx1Ba45Q6opSKX90tFuv5CUOPjisaeweN
 tZfB3BSSskoneXw7nkthA0vZfychvTObwC2t4QA82eRjfNFTG5nEhsi0KNrNIBB/TUxFaE
 JJgMpvBPQsuT8+vP59Tsr/NbML+3/V4T25MvXes76ku6rHdOzFL4ceGUBsCBoQ==
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0
To: <akpm@linux-foundation.org>, <shuah@kernel.org>
Date: Mon, 13 Jul 2026 17:43:19 +0800
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH RESEND v4] selftests: mincore: count file-mmap readahead on both sides
X-Lms-Return-Path: <lba+26a54b33d+7b1c30+kvack.org+wangyijia.yeah@bytedance.com>
Cc: <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, <muchun.song@linux.dev>, 
	"Yijia Wang" <wangyijia.yeah@bytedance.com>
From: =?utf-8?q?=E7=8E=8B=E7=BF=8A=E5=98=89?= <wangyijia.yeah@bytedance.com>
Message-Id: <20260713094319.771550-1-wangyijia.yeah@bytedance.com>
Content-Transfer-Encoding: 7bit
X-Original-From: wangyijia.yeah@bytedance.com
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AAA88140008
X-Stat-Signature: z8xh9odmageoix7bdxdtk3s81w8hkdxx
X-Rspam-User: 
X-HE-Tag: 1783935812-195597
X-HE-Meta: U2FsdGVkX18NvppfmQ3FeXHbFrzl2upwZtYYxsB67ZprjlG9VjKVMeIuuUd9O78W7+gG9T/fYj9bXiIZHFVq7cZjknmF0EBToq7+VXo4Ibs+wGobrzUJT1b0FCyAMRTq0EmohFetlpSXwgHwbimldv7lH/4QEM1HLT9py9e99qA/WlDGz5o4L84VRAwz+WlH/ionFsaFhu0rZkBtEjw6wWDnjC4B+D3vc+lEByqpMLgyK4Dbyj5wz7rYxZZsXqWCJZ7dzMink6xPh3X7LZeovYaKVyhKg9b8e4eF7PpOeHs/evIqmE7YKaIwVqlffOLhqQexPKpAraHw44J5ylhn9f+GNDz7W9BxekDQPAFFBFN7V8trB1+9PXbfjCJ5H9Rfixa0T5OFyxfURYkmamEt7SKN2kWcpaJbpn5QbVgzQhKuK0UXtztVPPQkhOj53s77nfLVHZ8VoJ1IfPxsRYuC1C1DmMEfIKmFTqmh4jgBwAL7zdcdr1dnBx7vXuv9J39SnYsmhS6EVLiunis+r7zyYPzgxWVgP++D75M8GO1/CWtUliye5eOcqmcwggD+DB0tJwagl44o6vzB8aMpB5bgOt5o/QRPR3Kj9Z/I3PZWXaXlBJZ1//+70R2De78Iq/MYmmOEiBHh/gkVT7+/a0sVjIJDhndrnQeiB1zmC7PWgqx66W2ndo58L4JUIrBy+AH/IkY/FoeWdPGFR+c6gTOAmNf3wBBKyiZ3lQZCY+rt5M4333+SB8kmGhRD+SOrSesdhiVTy+gf2dBle0HhSC05xqSvkR3fmmCx3+jQMiU2bhuI7679Bc2fo1Fst4Fxf1njfnrfb+mz4+IzaRrgjH7Hexo+Wp9TK59aO1LS5l5o6fQoc9pbxO/duk6Y7KmiTgY90rK75YfQYFxyC3j1pY7PCfnTDRHGBMcxs7MMixpTlMsFtoRtLfSZK3BlJf0pQx4M9J3MsvpcEqEX60oQV6d
 SVnfkmPd
 EreBEZ/Jj8hLVJCVTIfa462yfju540k7VtYnSVgWSWuPPMoRVhTl9RsSaXKmsXYqMYz6kdx5xsYU8bUptQmpDvsL4RWt2gQvpZEilZ7JPTgTXiBI+dnWI5KAp5a4UyoOoKJtH0IVJqRzS9+aJ5y1l4L5ojjZdcmbmVzFl+HCn1v/B2NL2OkL/65dbhtXIFDugBvogYFdeOTvS8XLBCOzND54+ijrkZIvuWRHsK6vfamwRLlIR0PSXj3gWVZNJlAEISH18P81W//ibO5tiXF9MtStFaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yijia Wang <wangyijia.yeah@bytedance.com>

check_file_mmap() faults a page in the middle of a file mapping and
expects the mmap read-around path to make neighbouring pages resident.
The test currently counts only pages after the faulted page.

That misses valid read-around on systems with large base page sizes. On
arm64 with 64K pages and the default 128K readahead setting, the
read-around window is two pages wide and centred on the faulting page.
Faulting page 32 makes pages 31 and 32 resident, so the forward-only
scan from page 33 reports ra_pages == 0 even though a neighbouring page
was brought in.

Keep the existing readahead assertion, but count resident neighbouring
pages on both sides of the faulted page. This fixes the 64K-page false
failure without teaching the selftest to compute the expected readahead
window from sysfs or other implementation details.

Signed-off-by: Yijia Wang <wangyijia.yeah@bytedance.com>
---
Changes in v4:
- Drop the sysfs read_ahead_kb helper and skip logic from v3.
- Keep the existing ra_pages assertion and count resident readahead
  pages on both sides of the faulted page.

 tools/testing/selftests/mincore/mincore_selftest.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mincore/mincore_selftest.c b/tools/testing/selftests/mincore/mincore_selftest.c
index 3182043..ebf2b06 100644
--- a/tools/testing/selftests/mincore/mincore_selftest.c
+++ b/tools/testing/selftests/mincore/mincore_selftest.c
@@ -243,8 +243,10 @@ TEST(check_file_mmap)
 	}
 
 	/*
-	 * Touch a page in the middle of the mapping. We expect the next
-	 * few pages (the readahead window) to be populated too.
+	 * Touch a page in the middle of the mapping. We expect some
+	 * surrounding pages (the readahead window) to be populated too.
+	 * Depending on the page size and readahead setting, the pages may
+	 * land before the faulted page rather than after it.
 	 */
 	addr[FILE_SIZE / 2] = 1;
 	retval = mincore(addr, FILE_SIZE, vec);
@@ -253,6 +255,12 @@ TEST(check_file_mmap)
 		TH_LOG("Page not found in memory after use");
 	}
 
+	i = FILE_SIZE / 2 / page_size - 1;
+	while (i >= 0 && vec[i]) {
+		ra_pages++;
+		i--;
+	}
+
 	i = FILE_SIZE / 2 / page_size + 1;
 	while (i < vec_size && vec[i]) {
 		ra_pages++;
-- 
2.43.0

