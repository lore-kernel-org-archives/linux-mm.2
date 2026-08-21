Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E73F1C5DF87
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 13:26:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9AA06B0095; Fri, 21 Aug 2026 09:26:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4C3B6B009B; Fri, 21 Aug 2026 09:26:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93AF86B009D; Fri, 21 Aug 2026 09:26:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7627E6B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 09:26:13 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E72BF12013F
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 13:26:12 +0000 (UTC)
X-FDA: 85125350184.18.7B5A885
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 67CF9180009
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 13:26:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A4NIcyYP;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787318771;
	b=5FA/NVpcIXHXwa7Gyagxm39hj/9dxN+1BJm+497eRqiVpQ7b5iBKCkmBG9cObccXD7iRHS
	HQpDaXZEAGyNyVAfnsUlj6reUyZfwyjSV+vOPR1Igm1IsW6ar89yEoexAoBvwChEb39noV
	gNNtQqlL2E3IE3U2yEKdNMa7KFdpLYw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A4NIcyYP;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787318771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=kSraTdJQfhSROQGKPTKlaCRCnheuQcpL/HYfQMp9wqg=;
	b=ocV49a1NoL+w8ka40IaizvMdg6Fazr7M7XcoVGcymI30zWuOytopiDE/OZM539LzdEeDOC
	tkpRYiN91CT4UKqTQ/AG92Tt3A2aJl7t5s/b/yfhOJ7bsiGYdS68XAcYaVm823Vw7DlKz7
	tK7OKeacXrQ6MHTtLskTlsrxFd5Gamc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9F2FF60008;
	Fri, 21 Aug 2026 13:26:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27E811F000E9;
	Fri, 21 Aug 2026 13:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787318770;
	bh=kSraTdJQfhSROQGKPTKlaCRCnheuQcpL/HYfQMp9wqg=;
	h=From:To:Cc:Subject:Date;
	b=A4NIcyYPhy9VDZ6dwBjDwsoaNoH3Y485jqcSyk841fXXs/1q/qiI75LceEFZtIwDV
	 5n6V9HEOSNkQ2/g+qFCBcHpBTti/S9NbXONTa+fLSpQRJj9qdRv81FzVgAqP7oLX3G
	 U15OICaS9D9jmsjq8C1+tWDl9DatOlgdMHV24eXk5ctZf7ViCQZzyS7BthB6FIgf+x
	 7GJwMk4o+6mIdFJdGqhO3uaD9T9jBEKTDfxW9/0BDLY2Z6I1ZMznrXuklynsEGcfXm
	 bD7HOdb/OwGFztBkuVes9uDuUSVL4cFPHT+eoHCwc9GRmAADF9jdmrZSpUibIIdxcd
	 veA0336x5ezxA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Bryan Lim <foxieflakey@gmail.com>,
	linux-mm@kvack.org,
	Suren Baghdasaryan <surenb@google.com>,
	Mike Rapoport <rppt@kernel.org>
Subject: [PATCH 25-new] patches: fix a typo
Date: Fri, 21 Aug 2026 06:26:01 -0700
Message-ID: <20260821132602.34133-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 67CF9180009
X-Stat-Signature: rbi53zyo5djo8xm6ab7wswsaiur4u6oc
X-HE-Tag: 1787318771-843588
X-HE-Meta: U2FsdGVkX18mIJdJ1rmFDE1+MW6NxfF3qf1Xt+CXaH36TAdYk43L1C4JHoiY9CKpaIULQfzvCks28zgPj0ju0evbay2P8PMNF2dikuifFgLRtV070TrFpCR9E9Z6jm4f5q/AHSdYRHfC8YwWVpSFF7lUGYV7kuAIq3yUz9CbSqv3FrLyIWAoht57F+ur9+5mr/m5t/sG3CVNVkCUI2Tgtu50auvdTBn7Qrq2Iu9ubgB1VPMGp06/cjoocNsD1Rx2ODaw24soBf/eA8/Aj6fYpwc2e8qZOqmVFjbFgTSiI7TD0jyNTKqOahnxeV909lH+QUMwbBzqT76fyv4hPMBW5HbDPPOetiSZDS4f/ZYyptToOeZNVtyFUA/dXVairU2JeucX+p+PFd33q0mwXnPm27frwYLqfy9Ltl47uRRULhk9hEeYmt2AfpIrWTI1MiD0Bw36+t7h8odltqWFIxctCQHTyLHu+pdVVkMH19IP8hXrPvDdWh2GmxWWGghTsQrpVyoqAHEotMjpwztu0X1DcGzBXDE+bNHlyJaJ9Qe4DHDbArl3cOZeEU+SoNcDouTHHgPNoog4/LeeSqLrt4GlO2g2jNCnq8w8gARxE/Iehooapw8rclSgXnglxvBCqSQIeYhgja89+3iaAIfI2XJQ1qeb2qGya3Ty3QAO0yBKQLrmMJKTbeJql0SHhVCcJnrfd43LCZ1eQR+r6dEgdcfgMBwP1wi1X9p5uCHGTkdsIMFYQa/vUVXVWqgoI3uTxbtx6D+mA0ml9XlEQkhE8uteoe+SAOw9TyGFUXApDSLqjPZBtDggmycuWRN0uZDcVB1Ya/ygVJzKynurxYCjtpUKObBV0ltFm7lA9jyVdBbZ5Nmy39vGKQ2eJ2yUhsTNJ7Fs8yyIgK6/YYbA/kBmDbonhqCHAoXUNVC3AMx8yAWs0+FM0fjLNOold+OPPP6bCRN2gKsfUjcC2J2T7EFRNgP
 jAF5uvM3
 Y4cGGv+ztpt7RYrp0KIfMqQuMbTqNsaMS/6jIcGH0DYYZkFYZfSCnEFNIkIyBhJnSCwp34QUq2GT+51CKinoYCtAj/PjiJAiNmmE2MVyf32xeZe+IOPIQvOCuKHBoQaUHfChJk4YEAoHmdMFSG4D3Ts/tudjNBjvHPIGbnwVbaNyV1Wojbt38/x4DhEIWcRcm25Y+5uF5PDiaYdMMYrC1Rp6Lfe5rFGTT8PttOtvdiGeq5m4a2cxZkArt3jjBMM+WWQP9i/O1eW9I1HWWFzHbc3i5b+SXDfUgIyuy3TfU8fo8oGL71Pj5ktVU20+IFsM7HNJuZLlere75HrDe7v210c5qW+JgBKWvG8w4pHkNbJ8AmaQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix an apparent typo after 'Cc: stable' line.

Fixes: 5343652151da ("foo")
Signed-off-by: SJ Park <sj@kernel.org>
---
 ...ultfd-reset-err-to-be-0-when-move_pages_ptes-succeeded.patch | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/patches/userfaultfd-reset-err-to-be-0-when-move_pages_ptes-succeeded.patch b/patches/userfaultfd-reset-err-to-be-0-when-move_pages_ptes-succeeded.patch
index c203e8486..741efcbd5 100644
--- a/patches/userfaultfd-reset-err-to-be-0-when-move_pages_ptes-succeeded.patch
+++ b/patches/userfaultfd-reset-err-to-be-0-when-move_pages_ptes-succeeded.patch
@@ -16,7 +16,7 @@ Signed-off-by: Bryan Lim <foxieflakey@gmail.com>
 Reviewed-by: Suren Baghdasaryan <surenb@google.com>
 Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
 Cc: Peter Xu <peterx@redhat.com>
-Cc: <stable@vger.kernel.org>nx
+Cc: <stable@vger.kernel.org>
 Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
 ---
 
-- 
2.47.3


