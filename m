Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 488BDCCA470
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 18:57:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 795FB8E0012; Mon,  6 Oct 2025 14:57:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76D648E0002; Mon,  6 Oct 2025 14:57:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AAC38E0012; Mon,  6 Oct 2025 14:57:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4FF138E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 14:57:08 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E9F87BA94A
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 18:57:07 +0000 (UTC)
X-FDA: 83968596894.12.DEDB4F1
Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6BE9A180003
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 18:57:06 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="c/lcP7Vp";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of usamaarif642@gmail.com designates 74.125.224.54 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759777026; a=rsa-sha256;
	cv=none;
	b=mAP+5LhrPFvcwV8KsNjstw2vGpa3lXflrB0mxHnAv9ifT+h2t16ZztM8j4DsjSD4LdLuOB
	RVwNXjfo/Uvov4OJZxxtS+mODNd08GC0BoGWi5rfNxKUKq8QB8QNfv8k6MCS0Pvp7T9nDm
	kCKwFsyQKoMUgGQARyKR18N5YWujWFE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="c/lcP7Vp";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of usamaarif642@gmail.com designates 74.125.224.54 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759777026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=OcLivXiTrUYp9+AjADWgBClrEl5ra49lH5R16p1feLA=;
	b=35HJdWF/iARSbl6YZMeLgJS9cPN9ruh7jXbvmr1PLqP5ilPoOpjmyCYzLTckA7CwQlMi41
	aJ3iQh9pv2bcymLBqM+AU2W1YKNKyXDmuSqPd0EHFdz/w4fjoHmsz1ROiILV9EmhU1SHVE
	x80paEvny2hc0P35UZVdue9taHq7N8M=
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-635401a8f5aso5799616d50.1
        for <linux-mm@kvack.org>; Mon, 06 Oct 2025 11:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759777025; x=1760381825; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OcLivXiTrUYp9+AjADWgBClrEl5ra49lH5R16p1feLA=;
        b=c/lcP7Vpni3K5HmC28X4ts08mP8eovsPnPTz3D1pShctLBc53SVjGp998ZDK0Hjyey
         /D/kZXHhVqlGk3nOllEnjR+jkQSVIj13xfF5f7Ono3r9u6HV2XECq0rX4MEZA0sqRV12
         vEbAu1MAcM6ObvZpfz+5V3qvXiN9yxo2exO6vHCoIDg4sYggWjSZ4aU8R1ByR+TSJRSU
         HmMuR/nAnGM4C0pTm0nzrSfjkc/l0OGEenuuXf/KFIcXx8YeE8z4sk/BpnlTjyD9LcmA
         FzcMiZx5Dri9B/ohwmMU4B7ML3qvyc5xjSjTyChU+F6sY6n1XwtHFps6PkyKMlKGUyWl
         GspA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759777025; x=1760381825;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OcLivXiTrUYp9+AjADWgBClrEl5ra49lH5R16p1feLA=;
        b=nXLLFbdwWvHd/I+ly1bqkxPVWvjy5cCa6ES8CfD869UrCZzh+wwkT5+x8Bd2Wy2rGn
         31OcpBIGhlWsmfjehie1HaJ6jaXXSI8jR7n019uui6+cDiOc/uRewBHKcoLWcpcVXl60
         iPiR7P66SXW1/eUWVAIbke6SdOvMT2QFH2v3CXwr6EPH7cb2KIGLtA7ZRPaqBo1m60af
         yo1yVspHZrRWjfHQTZoLr7bRNnMCtrRe4ZFU/e3Gwtg2QNU5qarQ+Bhj6AhdPnf8C54G
         EqC95lzDMWDDp3H1T9I1k7kaNjdgbof5LkaVfij7vMkMQpIg/ou5XnpIC6NisLVBtrB8
         q7tw==
X-Gm-Message-State: AOJu0YxUMp5+zNPKvupb7nArKdKEAmVC02q0EfUUkB/pTPGAsqGuvpK4
	8tBG+Pk3iQt8C3DQ2h8bcdgMCVopkqa3iNerm9lE8ABm+TRSBMzhtDBK
X-Gm-Gg: ASbGncsQUij8LRgxYWwmUmKjdWWZhRawK/sfOghlLYjkXq5xi8lc+HQYUkJvlQI5mrs
	h4Lt/Ploz2NSSBzPB8dFvZkS8bR6gRUQDEJX72WVMF9CPGkWWFeX7NXZ9sEr7HzABonYLB1Suot
	UK1kWw51o45eNvN9o20UCtUCtD9pYG0CMZEcGex2un/LLmLkqZkpB/Zm5G8DBob9Xl6Qj+V0FXI
	d+4ATlmp0nsjdNo+BLHqkPGAOqGahU47BdV0F9z8E/m2QYpSBxOkX3keVhzvlg8JXXXYl7KuFQW
	GgPsKnAzgD14wmuDUde3M1ILEquNEzdKtpPeZzmZ1uOeG9mCUHALWdj6r0AMp79aBPtzVVUfH0F
	1k3wmuZfxx6psOQBccV73bZJwTxYDcVanyx63q2Ud9EBuIQixrsfecaHHNzQxuarWyr4=
X-Google-Smtp-Source: AGHT+IG+sY5JofC0Ui9LDv+QJsiTCRyPBvfpZ8unr5Xkd/b4u7EaRyLhAZpr/ER4/vF15YDg589auw==
X-Received: by 2002:a53:ca41:0:b0:633:a7cf:bb4a with SMTP id 956f58d0204a3-63b9a089028mr10682175d50.23.1759777025398;
        Mon, 06 Oct 2025 11:57:05 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:45::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-63b84690b4csm4663064d50.21.2025.10.06.11.57.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Oct 2025 11:57:04 -0700 (PDT)
From: Usama Arif <usamaarif642@gmail.com>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@redhat.com,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	hannes@cmpxchg.org,
	riel@surriel.com,
	kas@kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Usama Arif <usamaarif642@gmail.com>
Subject: [PATCH] mm/hugetlb: allow overcommitting gigantic hugepages
Date: Mon,  6 Oct 2025 19:56:07 +0100
Message-ID: <20251006185607.3257340-1-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5srkbp7jydt4d5wawtm73w48u5kbm3br
X-Rspamd-Queue-Id: 6BE9A180003
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1759777026-681619
X-HE-Meta: U2FsdGVkX1+NGlfXKu6A/jgpt+j/f/4up8jF/hW4KdUCQXZEaN4eqL/LwsxFA23GrbOY/4IL+1swtDlQC5CZKT2O695wyiNoc0Q1SWg0vav/nxu6aY32aIY5viysfO8/g0zsBe4dgIB5B0tO643bUqq94VjYo/4QEfP9JfyQvnBLkxUKULDQYBo4ZvBm/kuXkaBJI5btuxIyUtMWWTC2vKF9a16RV71A6bodFK9kEc4dIKdxtTnb5VXeL35GQpopUqDjJhSzNziEL4TzrqYHNZwLd8tp+5GvbQ3Du80BfW/OMv9v13F6xOG1tMYGILLFl3EnrbExzoD87FfNzdYy5EYDJvBxSyPwoVAfaeN1lbnv8KN2TnbCaXGbm4j6RSxozibx7CeolPi0q1zRUnszXVCjkvUoqHTbOkPP1rYj8vI7PN+FLz5ymKOGYJgSSPdpBmAWKbpL8+INny1uQAWzBMgr0po9fytaCDibuBA4ppr2daE5VrlrDjULPT3ZLb1Cb6NmLUS29cevnnk0BbcSUGxSvumnhzfwhcip7+UHd/ouerDxsZp33Uqgf2+qafIumIs96DkTCSg8pkzoc2PGaTAhhtzQgQRM4jfebULH2oyKaQqmcvIRzFbxXqeY71Pkv+iAvxHFzZzgiAPdFwpAYalybGnqZTQN4DU3rHCDZSFw2e7WN13QxuK2WRiZShXRh7DNIBoBjnzXhwSkrlrNOeE/YY2vpp93r+A6lvwR2cPwTCAMwFpe8JwajyqS4uQQ69FBKRuVvvv4mrqG8OdSPSK4Kp5XVfSWT+tD1H4aY8R0igIrhxUuJzZHMKn+V0bLPzgqb7l9NMqoIXfw+/jv9hwadrJByLEf3vmA4xA3aoOo/R1uPGBHv97qyzq9CyOT72UCyipkwHwLr17qy1cV2+yi751utE474EXnpLyPQ1eDMZrqW2MQ6Mijy5IbajBvF0ImgaOcr6/ioY2u7iM
 sdPYJt76
 /lAMkiBh5W52xb4HiDPEu0C7yRmijayTod2O9YqgW1BkcG6jPP06SnNI5Zdvi5p2dcYbyn5JxjsV7PQNbu7yP1Ln5XbfdR38ZGEBd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, gigantic hugepages cannot use the overcommit mechanism
(nr_overcommit_hugepages), forcing users to permanently reserve memory via
nr_hugepages even when pages might not be actively used.

Remove this blanket restriction on gigantic hugepage overcommit.
This will bring the same benefits to gigantic pages as hugepages:

- Memory is only taken out of regular use when actually needed
- Unused surplus pages can be returned to the system
- Better memory utilization, especially with CMA backing which can
  significantly increase the changes of hugepage allocation

Without this patch:
echo 3 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_overcommit_hugepages
bash: echo: write error: Invalid argument

With this patch:
echo 3 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_overcommit_hugepages
./mmap_hugetlb_test
Successfully allocated huge pages at address: 0x7f9d40000000

cat mmap_hugetlb_test.c
...
    unsigned long ALLOC_SIZE = 3 * (unsigned long) HUGE_PAGE_SIZE;
    addr = mmap(NULL,
                ALLOC_SIZE, // 3GB
                PROT_READ | PROT_WRITE,
                MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB | MAP_HUGE_1GB,
                -1,
                0);

    if (addr == MAP_FAILED) {
        fprintf(stderr, "mmap failed: %s\n", strerror(errno));
        return 1;
    }
    printf("Successfully allocated huge pages at address: %p\n", addr);
...

Signed-off-by: Usama Arif <usamaarif642@gmail.com>
---
 mm/hugetlb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index c07b7192aff26..93d0f8ae1fe84 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2232,7 +2232,7 @@ static struct folio *alloc_surplus_hugetlb_folio(struct hstate *h,
 {
 	struct folio *folio = NULL;
 
-	if (hstate_is_gigantic(h))
+	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
 		return NULL;
 
 	spin_lock_irq(&hugetlb_lock);
@@ -4294,7 +4294,7 @@ static ssize_t nr_overcommit_hugepages_store(struct kobject *kobj,
 	unsigned long input;
 	struct hstate *h = kobj_to_hstate(kobj, NULL);
 
-	if (hstate_is_gigantic(h))
+	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
 		return -EINVAL;
 
 	err = kstrtoul(buf, 10, &input);
@@ -5181,7 +5181,7 @@ static int hugetlb_overcommit_handler(const struct ctl_table *table, int write,
 
 	tmp = h->nr_overcommit_huge_pages;
 
-	if (write && hstate_is_gigantic(h))
+	if (write && hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
 		return -EINVAL;
 
 	ret = proc_hugetlb_doulongvec_minmax(table, write, buffer, length, ppos,
-- 
2.47.3


