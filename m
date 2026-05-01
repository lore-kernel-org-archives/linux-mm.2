Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DC6EFF8864
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 05:56:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6E6E6B0092; Fri,  1 May 2026 01:56:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B45636B0093; Fri,  1 May 2026 01:56:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A83086B0095; Fri,  1 May 2026 01:56:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9D6A36B0092
	for <linux-mm@kvack.org>; Fri,  1 May 2026 01:56:20 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2BE361A0280
	for <linux-mm@kvack.org>; Fri,  1 May 2026 05:56:20 +0000 (UTC)
X-FDA: 84717790920.18.0EA79F1
Received: from outbound.ms.icloud.com (p-west3-cluster6-host3-snip4-9.eps.apple.com [57.103.75.12])
	by imf02.hostedemail.com (Postfix) with ESMTP id 13A9980003
	for <linux-mm@kvack.org>; Fri,  1 May 2026 05:56:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=EwI+l9V3;
	spf=pass (imf02.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.75.12 as permitted sender) smtp.mailfrom=lukafocus@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777614978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i/MDV/SdEyba8CAl8JXsfJJlaWhqdQgOiCYK9KUK3R4=;
	b=yLJUNs+3kmdG11jP+RdtwpoQUID41yl6C2Q59Hgaqy0HoHrkrnLdyYxMoneBhHAfjqUrOw
	rKP3kmypWFUTotzi8jZgIzEhnH7uieSJa1Ax/BiVeG907LUdAVkukP5iz3WLnRAbTIh2uG
	34eoiu9moO/ktaL0HeRF46s7nctbS7o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777614978; a=rsa-sha256;
	cv=none;
	b=knwLtxq7LhqPHs3ltfFxoUQa5I7WJa+7MeOHnBhm+NNynDUZy7BEaq2j8fyzvzUZlxrR/u
	dKPSgaMr726bkvInsTwbHWnLdpty2BbSkfleP1mHzVsbPDJ9EbG9jOxAVS4Nm7+oBz9/nz
	eqs/7QovdAQSW4b7nj1APTBrwqgBtbs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=EwI+l9V3;
	spf=pass (imf02.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.75.12 as permitted sender) smtp.mailfrom=lukafocus@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
Received: from outbound.ms.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-3a-60-percent-8 (Postfix) with ESMTPS id B115A180013D;
	Fri, 01 May 2026 05:56:13 +0000 (UTC)
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhAA0MFWgFeAUEdXwFLVxQEFEYGVg1dE0wLcwRUB10FXVZQAlpLVBQEFEYGVg1dE0wLcwRUB10FXVZQAlpLQBMESgZNXw5eHwQXRhlVBEceXVZeHhkCURxWDVdDVARfUEkMQVBsWgBHF0gdXRlZb1BdHA4EVAddBV1WUAJaS18ZXUUPXwdZBEAMSAJAQwNCL1oXREBBWh9DFEgDWARcBUQBSwReDytGFVcbVgNDRVEfVEYTGU4bV01QG18CQg8=
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1777614977; x=1780206977; bh=i/MDV/SdEyba8CAl8JXsfJJlaWhqdQgOiCYK9KUK3R4=; h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:x-icloud-hme; b=EwI+l9V3Eq8DZJruLYfJo2dpxYir0zhLiB6TNlieOp7ifXH23lRVEDJC2EU/hq2wz3FO6ybNlfeB5udpXES9bVb4DDPjRx5qGhQeG0RGpS4aeYJlQVqt9gMmBBN+OMqNrOjOHmlA5zrDnza9xoLCQ3Zt37WtiivxOz+wlzcSE/lQsBRuRKtpOJa8Xve9bT7AyzxRExricclw1cf7QwdUFqYSbxqL27mRqA+uuLwh4JFiZvxAMyxdRzSXF29n50bgq85Gcp07zwj4wGta2LzNMkxiF8wkih1e//DMnTvkPyfovmUaHWPCPe6x3NrUb6QI6aD2R4Dxb0NFmsnDNoTkXQ==
Received: from [127.0.0.1] (unknown [17.57.154.37])
	by p00-icloudmta-asmtp-us-west-3a-60-percent-8 (Postfix) with ESMTPSA id DB5BF1800108;
	Fri, 01 May 2026 05:56:07 +0000 (UTC)
From: Luka Bai <lukafocus@icloud.com>
Date: Fri, 01 May 2026 13:55:44 +0800
Subject: [PATCH 3/5] mm: add pmd level THP COW judgement helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260501-thp_cow-v1-3-005377483738@tencent.com>
References: <20260501-thp_cow-v1-0-005377483738@tencent.com>
In-Reply-To: <20260501-thp_cow-v1-0-005377483738@tencent.com>
To: linux-mm@kvack.org
Cc: Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jann Horn <jannh@google.com>, Arnd Bergmann <arnd@arndb.de>, 
 Kairui Song <kasong@tencent.com>, linux-kernel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, 
 Luka Bai <lukabai@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777614950; l=1685;
 i=lukabai@tencent.com; s=20260501; h=from:subject:message-id;
 bh=l3c8ZOwbATo+2PT4NYOAUghe4sk42dQjWN37S7JdcBg=;
 b=TSo2qM8r3KPPphClijLCEpGTnjI/pFC9+a8AQTQmdnuguNqhfa6BphAbJgkEVtcBJUMnH5Yi1
 ukFPpvM8SE3DKy0cbu0hqLnkQgMtbzyqiZoO3sLbQG5tG9zz+vGRHPR
X-Developer-Key: i=lukabai@tencent.com; a=ed25519;
 pk=KeaVteSWd00GIAjFyWZnuFsKAKixjga1ZkLMcI66nPM=
X-Authority-Info-Out: v=2.4 cv=No3cssdJ c=1 sm=1 tr=0 ts=69f4407f
 cx=c_apl:c_pps:t_out a=qkKslKyYc0ctBTeLUVfTFg==:117 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10 a=UaoJkeuwEpQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=GvQkQWPkAAAA:8 a=JogxrxylMUJFqwMgd1oA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: hB3IhlfY35IDEelkOKd30xeVKZ4dDTn9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTAxMDA1MyBTYWx0ZWRfX//GBnMBXJ+C+
 gHIiUEpz5ykqv7rnL7hYpfRWgqfJ+r3gKMPEjydZWch8zDPRgnyic8lbsqmz7W3j9NORpehDbpm
 HKuQctCjN/YpeWJWQpUmbYiEkaC5JrIxyy1VYLmK2OeCTZUFp/ZJTLlnSzwEPF9GWO0BvAqBwZH
 92Ej9piDwed/XU5gqf3lLyK9lyoPcVTUFAwXQRhq6IyviOvKDCRzX5nIdOLVel7x3tE0paAqprv
 knKjDu7zC5UVTLsD/eKxfTzl6wKAa+LQOLDzaRlo39GVGxC/5cSWeEIKnzNoLLM02pYqJyPLP3f
 NLHOvfOkNVMRy2QeQMYWg8GVvr1m0kohvEJxV0b1t4BN80PB9t1gM0vd7O3QsI=
X-Proofpoint-GUID: hB3IhlfY35IDEelkOKd30xeVKZ4dDTn9
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 13A9980003
X-Stat-Signature: 1jf4wocd5mpoenign7y8ujryqqmyoxcb
X-Rspam-User: 
X-HE-Tag: 1777614977-182467
X-HE-Meta: U2FsdGVkX1/t2CDlpwzmizOfERe0aJ5A26TQM101h/6p7lf82zlU61SjDlpLjRuMZ1J2/8EPBgKhWfhuBKFa4C7mqpv41FOZTmYCc1tcS9zAeJmCPy6BqGns4ykNZjmeol+0N6WGjuc1DLZHvLnhj0hr8G0Gqoe6oTEiMxnnLGQnA2nXHkxSvgPkArDXN02VeK0TkDmciWGAlvxWo4NMNC6p5J35qqzptuuf19h2e8isFO40K8Li3PFbqlrWeWDWfuscwL0WLWt4r9MJgKaijyjw4nUZgN0d9QHM2HB63g6yILl0iCPW0Yk8pTIrYjB3SUiD6prZAQFWYUfm9yCbsHUF7Q31RceXP8xtmXgpRymxa4Q6PVubyK38Yae/zanSnfGEZQSzMi2mJFHf3LJOxPPgWKrz9DeBy9k97/jgk5DDq6bsDgY2021MfwoCWtit4eoFUAIMkxaibZzby5+w4wEcmcESpGcXJz7gyPLsXf4/7xkD1ubrUmr8/9ureuq5bRa1MrqUqyqS0U0/LrB2VfTrvzEIvVMNifJQDAkmJt+Szm7UzSuAJGxz40Tp/hIYtW7txWSj+Pl4x7hJhVMZ/z0VPCj5I2ZglKiQjGONnixaOcmQ0xx7uB2GKUiYQnXP05eo56MsQ8zL0XqYmHRHAqShwRrDzX4IV5JVRd8g3iqv/HU6qkLHUUwzmGGqzw4FDirgcYtZ4LKaQz8NhJCZpwHpTgpkAVT7l2KMmocnu87U/LkYsHkPSlZa9KVUQownwobVPNzdHuDh7W2QK+ju8ozCm1+p23q4FXvYfA1AvgL5i+0vbjreARKmHvwp/SWbu+ZrCzVmPkCz3liy4vJkV1fzuP/BwgHN9/c6etaRThPdMzM+h3fAKK2u2eEejRkaq0qEF472QISI2JQHbXz60CX0Akzx9YbfKnBF5tV6VN2q85tIRBinK3WB0kOj6DZIRd/XREccgCDkts8Asik
 DdFiqjyc
 boyQg1Oyml0Nh6D2pX9C44ZGUtsWfR20kXE1R8wvMX+AZa+r4OKul++qqAYugQvJvjo/dd+vwok/xj3+K2dPu9M8/xGycXHe7rHCzfkzRLYTOOlzdaqbEnSlDmdChTcf/DMEsI1F+K8zFa0ykOz1hlKTBbGtXaA+ooTkUsq7sNzu4jNdk9kv2s27DOHTVLwD3QvqCp+7vg+6NwUpb/wbL6fI+nOjO9sSBYJhgFdJNsAeRPyaHiGh1++PCl9LJiySoadUmxa4UoYZCl9KgFCPSjHNOh2oae8z/n+wesrj+5AYJqa8ezHdcHnJknHr13cbFUNvKNLZ4fxOGgjE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Luka Bai <lukabai@tencent.com>

We add hugepage_cow_always and hugepage_cow_madvise as two convenient
helpers to decide whether we want to do THP COW under each specific
circumstance.

Also, we add a helper hugepage_cow_enabled to help us know the setup
more easily. THP COW is only opened when hugepage is globally enabled
or madvise enabled.

Signed-off-by: Luka Bai <lukabai@tencent.com>
---
 include/linux/huge_mm.h | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 2a62f0f92f68..3e5c6da3905b 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -203,6 +203,38 @@ static inline bool hugepage_global_always(void)
 			(1<<TRANSPARENT_HUGEPAGE_FLAG);
 }
 
+static inline bool hugepage_cow_always(void)
+{
+	return transparent_hugepage_flags &
+			(1<<TRANSPARENT_HUGEPAGE_COW_FLAG);
+}
+
+static inline bool hugepage_cow_madvise(void)
+{
+	return transparent_hugepage_flags &
+			(1<<TRANSPARENT_HUGEPAGE_REQ_MADV_COW_FLAG);
+}
+
+static inline bool hugepage_cow_enabled(struct vm_area_struct *vma)
+{
+	vm_flags_t vm_flags = vma->vm_flags;
+
+	/* anonymous THP need to be enabled first */
+	if (!hugepage_global_always() &&
+		(!hugepage_global_enabled() || !(vm_flags & VM_HUGEPAGE)))
+		return false;
+
+	/* always enables all the THP COW */
+	if (hugepage_cow_always())
+		return true;
+
+	/* madvise enables THP cow only when vm_flags says so */
+	if (hugepage_cow_madvise() && (vm_flags & VM_THP_COW))
+		return true;
+
+	return false;
+}
+
 static inline int highest_order(unsigned long orders)
 {
 	return fls_long(orders) - 1;

-- 
2.52.0


