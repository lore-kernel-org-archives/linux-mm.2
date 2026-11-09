Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86D8A6070B0C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 01:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=P8BymIR9
Received: by kanga.kvack.org (Postfix)
	id A14646B05B8; Sun,  8 Nov 2026 20:23:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EBEA6B05B9; Sun,  8 Nov 2026 20:23:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B3C76B05BA; Sun,  8 Nov 2026 20:23:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 483916B05B8
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 20:23:22 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BDD62C0525
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 01:23:21 +0000 (UTC)
X-FDA: 85413832602.22.3D3040E
Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	by imf06.hostedemail.com (Postfix) with ESMTP id DB38F180004
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 01:23:19 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=P8BymIR9;
	spf=pass (imf06.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794187400;
	b=d/FiCi0eCwNbR6rLz6Y16P+M8Weyk+aGEwUFsdRj0rSDUnMEZJ7yy6qcyoddJd57erlKTf
	jp3pvXcQfnQ9h48IIwLK1PhY9pKGi3Tj6Egd9ePwtz7Th3RH9iCrQhayEpcawsOQoekKZR
	X3RMbHJWbjcWBNBGS1cSxr+9lM9HOWc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=P8BymIR9;
	spf=pass (imf06.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794187400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fjbxQ6n0Zk6Jx+X1WZAh0zL0QQQS32bSK2pYlfdDiyw=;
	b=WpImo+NFfVVhm3aVt+td2yosGGkNCr5LjEwiUNDOuCJ/6biPrfHPlWK+vZlN7736CvmF58
	LfdH1vdMoAP65hio9vy/ftUqnLLaMlMwnptyXGlnBGHEN4MyVla9vXOvlOf2fmr1GopGL+
	5i0LtB6eKL+7AuIY2f8V1b67POwfA5k=
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-170135e43c7so469738c88.0
        for <linux-mm@kvack.org>; Sun, 08 Nov 2026 17:23:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794187399; x=1794792199; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fjbxQ6n0Zk6Jx+X1WZAh0zL0QQQS32bSK2pYlfdDiyw=;
        b=P8BymIR9o0v+reDcuPTHl0spg8SyK+2RpZmTxE3o5/xw/c1SL6KP4D8oXK8x7mAinW
         JuLWK1Rm6EIGfOm+tqqpXcatZseir83O8azKx8zyr6lnQlsSKu2/b810hzhkkYV1YL2l
         rKaQOrIPpx/rmh9u5yt4DfSSMf6t1/RYd3fMx7wT//XV2RSBV7ehVgiIapyV0mLG7xV9
         /G6n3pCyRXQhZ+GtG1lfbcLiKfKJFol9T8qVGEglffJyC6cNqNmcANDpjUm2xdq38tpv
         bmwYpHmopE7v7//hXtC40ru+Qupr8pEx+mh54g+kyYwsKvy7keXyJigcs+1SLRzYmRp0
         oijg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794187399; x=1794792199;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fjbxQ6n0Zk6Jx+X1WZAh0zL0QQQS32bSK2pYlfdDiyw=;
        b=kMTvG5jdZpelvkJSEnaohphzPjhVOY1r051DmS+vc8vKlKDES3P5zmb0FkA3qAhKba
         Xi1LDo0Qexe0f83eX/++5vAJHC8K0QItG1Lyew1NDhzZeGpOUIA5ywr6Im5MheTnTpe6
         U2Q0OYI/W8Dp9ZwqLch7rA2SgEn1sX3wKW0oDZDJWTmBl2e7KQHbc2/rlE1ySEVe5wER
         pSX9By7/FCNHeboQN0XSWlu72OzjJiQQayNgPrxzewovevzjmk/wl3QOWGsAySI2tmv3
         qO/NZ5q0D+Z/FDETQwUPpDO944cN38tyUaRaY1rf3Kyu1UYdzmNn9YhPNfQ12gRS0Cgd
         tOiQ==
X-Gm-Message-State: APuU4Z+k3SiOZcLbR1wH6ZhhvbIHhhIwa8ZdzOuYMDiZeWL2Lsp3VDMV
	w4sCQdx0VhYQYU8rFH4l7c6J6ThGoorW7b0Hf7z/bxasnlcivM4B3DFZ
X-Gm-Gg: AYBFou1wcoybLI/3jpW//g3CvpFFLx9igtprNNBx4UyTusTope2QcGcbDPA0+3JKFeF
	ZgmQ4JqoVpDu4X/aQGtn/xb+/R+efwq1lmpuPW0og1HYNXoOI2ZXFngxaWzw+CbBZUjf5JRSsxX
	EwAGP2HMAlSU/n5o2yvyLJopfL+O+7uhVCMm+0ou6y8VsnL+Dk3foj0UPRR5bBJZAGgxh8tlXaW
	XS/6h8gyTpvPhKhgLN6vD/hOTmcNQA1df2S4BuJPyr/J30a9r7+fYswkYKMGASGdOM/myahT/Jz
	4WQDyNGhl9iLAvVWBnmGKRlb0KnCz71TnRozXHkVIxfKJPZYUD1qxqv3vL368IVpw8y7lBY/NAP
	Ad9rbDb/wm25qNOxqZDs0gvInwzJPpHQIyGPXDwq5Glp9L1o5vH07Igv1Y5Zw8HXPG8CS2xrpzu
	h+s5TYGP6wGQERnks/Q7Y5nDZUdSLQRQ8YNtcFZQeeOm14nY6uOppes8v+WoLiGCN30ppnY0LV9
	qG5VmdiNQ20O7I/W2fok1luyr+ot0JOKc5LqA3Sp5HQHnLRy4RikwCIdh0y/jueGDuLkJxs7jxr
	HvkFqW1RCrpWn2cCULWOB7iR17/yHcAOr52E32CDkB1kcA==
X-Received: by 2002:a05:7022:1701:b0:1ac:1343:fa54 with SMTP id a92af1059eb24-1b39fec8a94mr3868482c88.14.1794187398555;
        Sun, 08 Nov 2026 17:23:18 -0800 (PST)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3771ea85bsm9428226c88.18.2026.11.08.17.23.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 17:23:18 -0800 (PST)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Sun, 08 Nov 2026 20:22:53 -0500
Subject: [PATCH v4 4/5] selftests/mm: move waiting for KSM full scans into
 a helper
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261108-bug-mm-ksm-smart-scan-align-skips-v4-4-86be8fe77e7a@gmail.com>
References: <20261108-bug-mm-ksm-smart-scan-align-skips-v4-0-86be8fe77e7a@gmail.com>
In-Reply-To: <20261108-bug-mm-ksm-smart-scan-align-skips-v4-0-86be8fe77e7a@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Xu Xin <xu.xin@linux.dev>, 
 Chengming Zhou <chengming.zhou@linux.dev>, Stefan Roesch <shr@devkernel.io>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
 Qiliang Yuan <odys.yuan@gmail.com>
X-Mailer: b4 0.13.0
X-Stat-Signature: dkxy9xikd38ye3zi3mnx1qknog6tt9w3
X-Rspamd-Queue-Id: DB38F180004
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794187399-276077
X-HE-Meta: U2FsdGVkX188tlFjsscmu5OqRxiwJEQE+y2u9+ujN5Z1JJIzyoZHWDhkcy2huWk+NTXtt/cCIfl7GD6q5Dh93Dzm3Uje0TXUzXTm13paeCJqiTNPOWPCSsQQaNo8Xp/Bl5CiyrFhVB4zMi7NALWX3oed33UlF5QOfTdlqPoaTxaeUu4z3xOfvx5GrRtbcYaIY9e2K8LHdCY226ez5j6tKbNxNSjosdGua9XZWmBZnfCftTCwAYMAWBSmdAudFgsB+QHZy3Pg1o4UVK8jM92828GclrkPv5DUlxCqxKVCQAXqxQFmoZqNeIMb7NyCY3m4TwyeoZn3Jmj0RGR7lfUBvtbiAK4aF4wONG+gdcOQYxaP/5WK9eYFl4vsssbz/Z00eG18cXge66ukIwWk7biQLwX+1/0Pqd/i2skYeW5eo1+KVyCAV7EHvmIWHLSNx+9roE8X6OTL4VxAd/zGYZUzCEOruKK/a+hzyrGx/xHUX77PR0+WxiIDc5dRaVVIyea/PeHik+yS6sBQZEbyTosNAQmsDLsYG3BYZC+0bOUxo5zK5JVHj5r3EIiWgN9HHeMGUL+XN1PgWH2PcYhA83foUoaVtkjuRGUmEuOj7bCfZPVJ/g+WFoDB4p16IqSr41MIHcy2OAD4fR348vU+5vyBMX4j0AbWuT69THebmbEprMIBy6t5siFBc8D/EPUKzzuDUbX2mtA5J3927CwXSYoU31WQcAsDbwuV5qE1YWLhSZm9wEzMKyFUbmQbMaMgxdnQbWP7NPfTFfULEmDHIDFpXvIcutCOS/1B1+GrdTrO1goGViI/lMSJPA887ul4/cYRb81oui6LHf4uCyU1HPycMgqT6CkkIYfcf3mTFMB8TZFF4xfUzQWKpRTo8dfT8mMhpM65GEwsxIEDZLdsv1CImj4gWHrrONBMgyDWrqmA6m1k0ACG0uBJFadPOQ51ujglqaoYxksGet+uQeDuSsS
 WJutkI/5
 sPJVnE1Y5GKbIv8GCJvg030XgX3oaFOHPv27uLYKAUSIwY+89a/0fRRcctBIXq2cb1MjQyzDU6rxnbzZ/28SWvMn/La8CgvhSQQdiMxn0nadeHtmNXdYCm9rJK5PlbE4ymM1Pgtz9hGnUmRSFA/XTXYR3TSj8B+vd6X9fjyj8ltmk8TdOh+jd5PBq8IdSU2wuVfn/FdRg3bWygEgdR5rTqLRqGjSZA5jdbDTV1UqjdLlWaV8zVSQt537ISpBuywKsE1bnhhfchUDOFSczLM6WaE5tQBKc5lZCR+dbM3c6h2u8PzFWhhMRaktjbxjxdFTE9q2p3XBWAoSBNB6iQD4eAYvkQQAmaUfUnRDGwoXQZojJTdNglhqxx+lj+rz0Gov8kYBlnanpC0BdBiMNyOjm6bt/u6HpQQSQ6kzrlY4vlqUtD58RFoZEJaimLN0rdJRZMSXaBYgPodg0HGvTogKuUufPgX+MLHZtS5OPBxwlqwutqhkU8JB2x1ztbDqB8BV12FOAScQGPYSz40dxVcPppDwnZzlhO1FhtKrIcRZFscrUOrLAqO8XAo/GQsssKTX5YiQ5Lq1ID/fddUE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

ksm_start() enables ksmd and then polls full_scans until two more full
scans have completed, so that any merging that can happen has happened.

There is no helper to wait for a number of full scans while ksmd is
already running, so a test that needs one has to copy that loop.

Move the loop into ksm_wait_full_scans() and make ksm_start() call it
after enabling ksmd. The count is now read after ksmd starts rather than
before, which can only make ksm_start() wait longer.

Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
---
 tools/testing/selftests/mm/vm_util.c | 31 ++++++++++++++++++-------------
 tools/testing/selftests/mm/vm_util.h |  1 +
 2 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index caea045fa7d46..8184691211acc 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -992,35 +992,40 @@ int ksm_use_zero_pages(void)
 	return ret == 1 ? 0 : -EIO;
 }
 
+int ksm_wait_full_scans(long nr)
+{
+	long start_scans, end_scans;
+
+	start_scans = ksm_get_full_scans();
+	if (start_scans < 0)
+		return start_scans;
+	do {
+		end_scans = ksm_get_full_scans();
+		if (end_scans < 0)
+			return end_scans;
+	} while (end_scans < start_scans + nr);
+
+	return 0;
+}
+
 int ksm_start(void)
 {
 	int ksm_fd;
 	ssize_t ret;
-	long start_scans, end_scans;
 
 	ksm_fd = open("/sys/kernel/mm/ksm/run", O_RDWR);
 	if (ksm_fd < 0)
 		return -errno;
 
-	/* Wait for two full scans such that any possible merging happened. */
-	start_scans = ksm_get_full_scans();
-	if (start_scans < 0) {
-		close(ksm_fd);
-		return start_scans;
-	}
 	ret = write(ksm_fd, "1", 1);
 	close(ksm_fd);
 	if (ret < 0)
 		return -errno;
 	if (ret != 1)
 		return -EIO;
-	do {
-		end_scans = ksm_get_full_scans();
-		if (end_scans < 0)
-			return end_scans;
-	} while (end_scans < start_scans + 2);
 
-	return 0;
+	/* Wait for two full scans such that any possible merging happened. */
+	return ksm_wait_full_scans(2);
 }
 
 int ksm_stop(void)
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index b5d59729d4327..7e00030077d2f 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -162,6 +162,7 @@ void *sys_mremap(void *old_address, unsigned long old_size,
 long ksm_get_self_zero_pages(void);
 long ksm_get_self_merging_pages(void);
 long ksm_get_full_scans(void);
+int ksm_wait_full_scans(long nr);
 int ksm_use_zero_pages(void);
 int ksm_start(void);
 int ksm_stop(void);

-- 
2.43.0


