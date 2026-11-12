Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 887CE606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 10:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HtBMKKln
Received: by kanga.kvack.org (Postfix)
	id AD9E36B05B6; Thu, 12 Nov 2026 05:39:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A63816B05B7; Thu, 12 Nov 2026 05:39:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 953A86B05B8; Thu, 12 Nov 2026 05:39:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 761A66B05B6
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:39:10 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 030CB140540
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:39:10 +0000 (UTC)
X-FDA: 85426119660.12.F87F7DC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 457C440002
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:39:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HtBMKKln;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794479948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1TqLW6TCU0MTFWVnCW5idaNhXosc69J5rCdUkKs0dx8=;
	b=SVDLYjBR2hmKuOyAZi+mYg3I22Pm9ndlLZnl+COpwVtnbwNl/AdYumnVol/3ez05dcv3VK
	isON/e+bPOjDQ/PfM8ejbAUu89rIoTAPfJ2KghHDB6FYXVhmMWIJ6FIwVSNT45wt/1Lgvl
	hCpbMAfHAeLiMtq3ntlBsXy641d/i50=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HtBMKKln;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794479948;
	b=dDZzziqpilwuwlmds4TDfYq3IeUsQd0bjM7IhPyhZ0dqijKFhC7bXJHZg1Evrugkjp+3Yh
	QpXJf0bbnzA/XbWCmNbqVvm6mZzBNraPreAmSNKgQ3k3KiZPggkWE8tXBdWODxcIGmiXfy
	SR+keN00jqcp2m2cBpfNdohXPldnnIg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C8DC963A5A;
	Thu, 12 Nov 2026 10:39:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CFBB1F00A06;
	Thu, 12 Nov 2026 10:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794479947;
	bh=1TqLW6TCU0MTFWVnCW5idaNhXosc69J5rCdUkKs0dx8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HtBMKKln5m3G2gtNfK/0flI7AP2EvZjQQh5hYJWKwraxNla1MVmVeuJ5Ztyg+zBIZ
	 khUBJZFQXoNuH48GrC/IEX1y076qqsHUPLnW/4knD6ieVh5yD6Ep1U7Xdc+iaqh/G2
	 96RcYCSwBiEKJorecpKBit1DYHC0PUEhaO/VrmvZNvW2Qus0kmmqzCBhxRN3n+4N9V
	 Bha5BKr6vn4GeUGZh6id+YDhH7F8tw8N3nnYso2wo6OayCdV0jehXEereNvQyUXxsm
	 HzOywLMLoNMgZ92M0qDbBL2f1kzB9Z28hN8Y2EKGpXe2m+9zlY3iORBTSvFSdA0iH2
	 0LQsFC3wGTBhw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 12 Nov 2026 12:38:53 +0200
Subject: [PATCH v3 1/5] kho: reject zero bootmem scale
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261112-kho-bootmem-sizing-v3-1-f0c8d00295d5@kernel.org>
References: <20261112-kho-bootmem-sizing-v3-0-f0c8d00295d5@kernel.org>
In-Reply-To: <20261112-kho-bootmem-sizing-v3-0-f0c8d00295d5@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>, Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Chen Pei <cp0613@linux.alibaba.com>, George Guo <guodongtai@kylinos.cn>, 
 Kexin Liu <liukexin@kylinos.cn>, Randy Dunlap <rdunlap@infradead.org>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Sourabh Jain <sourabhjain@linux.ibm.com>, kexec@lists.infradead.org, 
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.16.1-dev
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 457C440002
X-Stat-Signature: c8zd96f1p395x75ukpp7nb6ea5czsmc6
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794479948-658170
X-HE-Meta: U2FsdGVkX1/Dh9Vn8oLK/x4lwaWV9i8A6I27Iv/RSXRsoCVTr/7ijS2ZpKifFKd0razSZu8le2K01o6Q9z0EN+eOSbOENZ7HcwBXYqFAND3POBJoCGTuUB2D9E1lx3FJcypul0UpHL8YgVa1sDawgEvKuTd3GultL8IstQ38tNAhIKuxcv5ACM4nEL7+vLtT2MRnBzgPBgsCmHJvyEIPq2ZZENSu2DpqlTNVl30qutkqPaSW3aHgkPFNQiHJJyCknHIGQKlbhFtWKY97kIqT3eO20/xlTgfFGOJWHEjnJuW099YCgAXa9OJtMOmXyWlOWa+iVLY9aZUjuvBQPqMn9d7dN58xroFMSXvlp76A592vtmSHmsjqegcL76ovimbslX6ueyz9DBFp0g8c6ds5R7p+VqBwu+uRj2FBdEhqXkl/fX9+/vJxBJZJ9aoRD0Pq5woxbXgpNUotM3h4VGV84j20qA/dsPEbwSxmx0KXQeId7L63Mc6+bc6qoM5a/oviQtRfZEl49Wlxysv1HG+xG6BVG9xnSYE9ctaWxxyrmeLpJdzp+H0bF5sY1SnMm3xYVDOmTqIVFbbqmrBVyid9Hs0vwJH4riXP60KjfvkMmsuqCLkm1uTvJ1gNmntW37uBmbsUnrYzv5BWuN3SxO7Ct/WcdB9cP5Qf98HJW5f4bF3xbVzH2Itap1cjqctakqTi6lrhyvIoz5PRs06Q4N7HuUAyYoyXfHao9psp9NUpRKxxVVwuSaUBStpaEgPGzmBs4LS6aG/rrS0bPSWrFy+JlOzy7TrSQupEWroMs+CGkc5ucZK+P6NfUKsccHMvWoeSi06TEpYdBcOhHCMndlrOnFWcGLCkiIi7NUlMUEi5jWFKW2Q+hSbJFHusq15huHOelVzXztWcB6UMXVCuN6Ji7x6qFYzyWfs4jeo5nPxySr/0w1fauGrkHG3lRlqHsggAFnfzIe0kyyweP/AJatQ
 0wgwYmFE
 U9C3YLf4ZvvKFlaNJoGxdA94pO9W0q3mMt4hFr53JYLMVZlbmlJeW1ZUuyFUO2pvg2lAQ8K/F+hoxrdEaXEpz+RJ+ZrkqA4Z7sku7PEiq0XWUmRrY2R8G01s/8yyIYY9M5BPTh3ayXPNwlWw8B4PXLKDAnwhDNriI97UX7ywt9E41UmTaG/hFk20rTa9Bwz6pZ7xNYpbLxtNhwGUzfMu/N8td0/6bMBsPHLou5ywiK5kFvKHZUVb0OSK3cQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

kho_bootmem=0% sets bootmem_scale to 0, and then the bootmem areas are
sized using the explicit sizes that default to 0. KHO remains enabled,
but there is no usable bootmem to load the next kernel.

Reject zero scale the same way zero explicit sizes are rejected.

Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 6f1f55fe31819..b30ba686cb301 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -703,16 +703,22 @@ static int __init kho_parse_bootmem_size(char *p)
 	if (p[len - 1] == '%') {
 		/* unsigned int max is 4,294,967,295, 10 chars */
 		char s_scale[11] = {};
+		unsigned int scale;
 		int ret = 0;
 
 		if (len > ARRAY_SIZE(s_scale))
 			return -EINVAL;
 
 		memcpy(s_scale, p, len - 1);
-		ret = kstrtouint(s_scale, 10, &bootmem_scale);
-		if (!ret)
-			pr_notice("bootmem scale is %d%%\n", bootmem_scale);
-		return ret;
+		ret = kstrtouint(s_scale, 10, &scale);
+		if (ret)
+			return ret;
+		if (!scale)
+			return -EINVAL;
+
+		bootmem_scale = scale;
+		pr_notice("bootmem scale is %d%%\n", bootmem_scale);
+		return 0;
 	}
 
 	/* parse ll[KMG],mm[KMG],nn[KMG] */

-- 
2.53.0


