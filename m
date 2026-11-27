Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AE5A606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 22:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Lpvdy0fJ
Received: by kanga.kvack.org (Postfix)
	id E4C7A6B05BD; Fri, 27 Nov 2026 17:27:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD5B26B05BE; Fri, 27 Nov 2026 17:27:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC5996B05BF; Fri, 27 Nov 2026 17:27:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9A9766B05BD
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 17:27:36 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3902EA0559
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:27:31 +0000 (UTC)
X-FDA: 85482336702.28.5863BBC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id A96E3140004
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:27:29 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lpvdy0fJ;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795818449;
	b=bpltAGfZ26FnfYjj28wPVV7KDk+uM3jrq5RRt6fs1WbGb2kfpf0T7D74/YFTa6H7EIAtx4
	KGly9lYLpBXHnAHtRI2jLO+4CzdUtqRe5TweG7L8w3Q0PaloeBY+nVuQxYSRCCkPhO7vv4
	R1QOhsW7pXcEFF2oe5EM0hMjF1JGqcI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795818449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qUZ1Sh0+x+PxUSd04DpLnU3Boe55h78UdXb2EcapTys=;
	b=U4IH581iBVPxr/PRhvnq/YfwnoiwQP67kLui8g0ML4ROs0BJDP6RSlFIYuONTuJb7EbYFO
	BXT8VWuUTrLfcb2/1PxDvfCvH44/hdGXer04Kh+WNQYvRlg9fpLzHOpioOJ+9FaA1SxJtE
	2fszMLZJDYLCvpDQdMLNgXLj9NhcMww=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lpvdy0fJ;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E166B4111E
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:27:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D6041F00897;
	Fri, 27 Nov 2026 22:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795818448;
	bh=qUZ1Sh0+x+PxUSd04DpLnU3Boe55h78UdXb2EcapTys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lpvdy0fJY4bL3qswTGbOzBsYWQIL80Hboe+LmS4j9jTVew41uBNeqVNIusViDV1Ci
	 y9qL768zlu1ivGlqnidw6e2PEQvsY79vsyWSsASr9QT0PftBUnaAAVrTY9Ismcx7FB
	 Fny7zGQPKM2T8CUdWCdv8lA/vfyEceMUKHgsCQdbNZnaEzB/jVyzESlQzEyUFjjoFo
	 uq3kezWDbZMQQ+5BNj/aYtAaI8vafItDlVkUH3n/3NdtAGE024AAPJBY0/pYnT7YCr
	 i1pumvL6m98xFz5+1gghrCajt1CyZI/58O+Mqi6dVaFlI5aMRMZA7zal0lwZcgcUTi
	 4oAypdeBhG9ug==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 5/7] selftests/damon/damos_apply_interval: remove unused variables
Date: Fri, 27 Nov 2026 14:27:16 -0800
Message-ID: <20261127222719.105510-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261127222719.105510-1-sj@kernel.org>
References: <20261127222719.105510-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Queue-Id: A96E3140004
X-Stat-Signature: au4yhoc4ygootn5nsw3rj8ojcya9mbzo
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795818449-23089
X-HE-Meta: U2FsdGVkX189yAHPwcWndee9wrOAoQZTWnAlGaGt4UjXxvlb+QDcdL2VjOXhClepOkrg3kVKd7CqmgBjc9YhA0RajUOjnn8ovMdMkGbb/8Fzx2m7QTydm+ProvtN9rJsfR3OQPnD4qCWACnsDrc/3zl6Cw+VRQPmSc8DjXA7HnbAFAXK9gzjagXvFbYiDXZ8tr1n00boGjEBBld3uJV4gmPpjxHyOGVtRUT3ujlstJUmFn1CL8u+Mer4HL++874OakqN0FWHDZNyKQbE+I442NXuKvGByahd3naA35vHdTrA3KerKfz0UoSS4iIc4lMKzFZNNvScax96CY1HJU72dN6/JrB1ofMASnEgXSmD/0RG1CGLYmxfcwQUPICQL+YaVMPtLcduJKizGLLy41u1mqj2saI5r0W23aBG3qc2Jlx86gwruY75MsaRAIeCyVmFcN+qAdFuDWs9IHxAk3TDKzng9CY9xASDWy6LIc11ZB8N/X+QBjR/jTbFYKv/gXtrQvXO9PyUCVGTI/Ck0aAjuy428OChmJSApx1U7qZjLRM2Upsb2N2wYXJaQ3YI9gjSUiKsVuYaolknS2E/HMcMYVV1jwU5Vb21iCwcNREZlY7xBxC++M1vfSnkhii9tRcdVP4RqPtsoEUoq1C6xKQ8tvK7Rbummo0ZnpRxx1e3vCV7ag6/FWziniQDsmgXj5mbt4Q93G99pqeA/O0FO2ThSJ+biwVeB5U0My4s9eL8cMxCXFQI6GQri9FLAy+lrrlLlF7vSQA6ZVnKLOLba8TONcTgMsjP6YtKEWYBnXsKexDsjFYCeF30HiV6SLEKgaG1AzLta0h/6fUo1/5YUCA79cB1jjEjZojlCAkMiYXFwBYMVlZ/h5frNnfl8e676yCNxPcz5UVoj9a58YwueX8M2sIRtvfpXDV2Ma86Fc/v3n0EwsnvOlvhIwLX1MrF7w9B+bbUu5M4v0y9meULgHJ
 LdkUph1r
 MJqoNB3zLMsvNF67ne936GUrg/kAyL24ksU9LWgKSCo6admgi5c6vnl/f7i+Axi1HbtmI8ImxXXWWiKl+M1utYzcmeAlG64wEZ1GdeMQiRj/XHS9TDE2NvQ71bqlSupuXWI/do0jO5MIJFH3ocxu3r8GbLn+p4EeW4qWfXB6JZFVTABPI5XMFwKtfbk7VFYpUx1zyXDrXXYqk+Ss/o5/plf/7Xze57eeizcFY710yjFvpWzmdKFTlb6CKCFtTG1lBH9YezkrHelhHw+85aOOcXjDpyT2CLmlvWkfoq52SpkwMrBP5kH3J17Q3XHwTyfrF4459HXfViaFip2eL1OuATDxNADxt5jXAWJMqM+mhXI6XeydPpmNagVNdo014bu8u9kRX39NS5xps4mJYjcokcrYxqC8FjC8kGJ1IVrWmt6SsdrUsFVZq5hemFHzY4tLedMgwIsVRcwYyEh9ANjY/fSmVkM9mT2/ZNIAYkwc3anjXgPx4IE5aaEVeitpJTfJw2vOR14a5pe6SarQz9/+4aPXauLgB126GCMF48IulO8k1WHMz8xsx6EQSR+ZvYKQ/t+Nq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

wss_collected and nr_quota_exceeds in damos_apply_interval.py are
assigned to but never used.  Remove.

The issue is found using flake8.

Signed-off-by: SJ Park <sj@kernel.org>
---
 tools/testing/selftests/damon/damos_apply_interval.py | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/testing/selftests/damon/damos_apply_interval.py b/tools/testing/selftests/damon/damos_apply_interval.py
index 0bf7768b2006..0ad110be0fb9 100755
--- a/tools/testing/selftests/damon/damos_apply_interval.py
+++ b/tools/testing/selftests/damon/damos_apply_interval.py
@@ -42,8 +42,6 @@ def main():
         print('kdamond start failed: %s' % err)
         exit(1)
 
-    wss_collected = []
-    nr_quota_exceeds = 0
     while proc.poll() == None:
         time.sleep(0.1)
         err = kdamonds.kdamonds[0].update_schemes_stats()
-- 
2.47.3

