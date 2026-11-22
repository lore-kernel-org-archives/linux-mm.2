Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C7FC606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 17:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=inZN7/p+
Received: by kanga.kvack.org (Postfix)
	id E48846B05B9; Sun, 22 Nov 2026 12:59:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD27E6B05BA; Sun, 22 Nov 2026 12:59:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C74906B05BB; Sun, 22 Nov 2026 12:59:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 797EE6B05B9
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:59:01 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D883114071D
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 17:59:00 +0000 (UTC)
X-FDA: 85463516040.20.1AFB23B
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0FFF180002
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 17:58:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="inZN7/p+";
	spf=pass (imf02.hostedemail.com: domain of lylin1023@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=lylin1023@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795370339;
	b=cdYViE/qoCj3GY5qzsYOS9XorGzJJSLYvivXF6HmX77VQyyyGfvBPI6CPnyoK+D4mDw+TO
	yAZjqAVRkXZYIDCiRtLgvQRX9/ByzHYqfgSUyazDXGiW/oxHTgXuzKpgsVMJnpE0UPHN3k
	2nIwa4dp9GZ5VDYHZI+mxLqkjKyu0Z8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795370339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=zZK6D2/szOXdu8ofxhUwHdxgVM+nnJRbws9cN9agyJ8=;
	b=bWHn29z+kleta7LcBq7Ntl9WvzR8dg3npOHCLi0Ti5pQLPYwJGfyxmvrD+R/kn6Em3cS0t
	CCk34Vs0CJFecjxo1CWJWgFYi7RvRL7D77CHL1GyM5OuMvqfDMl/HFK/CuCipiBQ9r8URp
	/hpk2oo1j+I6ttqWlx4yh3qgxSd1cgg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="inZN7/p+";
	spf=pass (imf02.hostedemail.com: domain of lylin1023@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=lylin1023@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-8b66d1a08ccso1895615b3a.1
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 09:58:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795370337; x=1795975137; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=zZK6D2/szOXdu8ofxhUwHdxgVM+nnJRbws9cN9agyJ8=;
        b=inZN7/p+By9CgOc41B2HUq0yoQREPl+HWHzV+PNLLY6/tP9WLJwJAqle6Ah2vB/w81
         lSaxp/gV66t6pB/QFI6wkmMthWgbGft89J5fvqxW55peWXl5//UHmJGJSQDez9kwdKAu
         cG5nbZXyBZLYw8lSWUvEtjfb1wkBCoHBia0VuJiSrUOevI8Fks3iKfbrHJ+cyeQjYb2r
         Lk5jWVipr1WY04BAIykGp14RANHTdA4VeVDuyv/TcEILRGW+rC7KRKln+/9Dkc/PB+ss
         H7+R4VOi2gaQ2ekBcm9Ed9PC0zKuIvW02bIqk/+bQkdoOFFZTz8si1od9mvM/bgPDOqZ
         ZHYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795370338; x=1795975138;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=zZK6D2/szOXdu8ofxhUwHdxgVM+nnJRbws9cN9agyJ8=;
        b=ipA+2+RryvCDnCgWmuWevDqHCmUXQ9yKWRvS4iiVCLpfgk5nf9/gUS/JF+rp9q8yb0
         J4Ks6VmyyNTT5BwdqsifqAcAecTzZYLupJBpXhZKaRMkVGKprL2iVjSSNDmKtpctspFU
         XtqD+5IrEmlvUkdEMETi5GPEd9lTmyUumpyybJhRbqbM1lFDnkaPbTVF9phM2rKPjSKv
         tGln9Tk1eI0mtPkSEtPXuVuRwMkorDpOuBundoy/CJSJDx5nF4jzIcr5O6dCxCmgQDac
         FrjnHDpUI5tuaZC/76SenEikDREHelc3k9R93ogJKkAyytRfQvwRhbw7NOA4TWjHxEfu
         kWQQ==
X-Gm-Message-State: APuU4Z+0ft0ktjY/ipEOmFp1dew2lS7v2QH+4x8u63WhrNUuc+rxdUL/
	XmAYBQ22tgyVpJ1mouGW6Pon6zkR/bc8jN9yRpAFj2uPQlAe3o2cb3J4
X-Gm-Gg: AZFdTZd9SzAUKucnjTX7T/eOnkppqsizVQDJFHGR+HoDVR0NilocDnWTGfI2Wda9Yhr
	ToYgI/4EWRzYlxcCgsQIJjRF+zKH2eAvvpaIF/sIVrw+nkkfTAjov8b2VFOBcdwCs7fuuN2890p
	6+74yBGgwmveMHplkPcP7re16yeUXuBas64leto7aab5jfUG0VckwcCoTLAcbSrN3zy06rwYG+R
	aeTXqn05VaHa04ALmHXFKIWYBHSgqkMcFiLS9jy7DsTmXVVcEGQGKy8qA+Jq/L48qJPjU2v8BMo
	ybMSFD2IVFTnMRHnxM3mc9ivmnscRHOHoQaRrhQrpkIJauf3zu5wIAJTl0UyEVwtdh8W4BSnE4f
	j3SiUDTYQy5dw3wuzzZWiqS7QCs1LOC70JVJRDakn/DM7auLyrlnXYYhEzvQQBxIPGVPKQ3AfpU
	hUjh3C89DvAgpAXyiBDIM8EJObu2AO8eQ0O7No9/+VG+zoDDhNAYcH5mwP7/MSIvRTa/KsReyuy
	11Dtu733rtgBg3NJ3w2vjGwpM7lUcmOzPOxupNyqCSGH5AJ940/rWlqalAQgdmV6rbGM0h9WLYF
	NlcBZ4XMtsDioAiOpIpTe8nQBOQ/tg1IkS5ZO0lRAg19YejFBlwgU5Jl4DGCqz92PqvBpuVMGvK
	RohA=
X-Received: by 2002:a05:6a21:6b0d:b0:3fb:6e73:ce42 with SMTP id adf61e73a8af0-4014d56b3f9mr9114765637.74.1795370337572;
        Sun, 22 Nov 2026 09:58:57 -0800 (PST)
Received: from [192.168.18.15] (218-35-178-218.cm.dynamic.apol.com.tw. [218.35.178.218])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c87285c89dsm4160040b3a.13.2026.11.22.09.58.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 09:58:56 -0800 (PST)
From: Kurt Lin <lylin1023@gmail.com>
Date: Mon, 23 Nov 2026 01:58:43 +0800
Subject: [PATCH] selftests/mm: skip hard dirty page-cache test on FUSE
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261123-memory-failure-fuse-skip-v1-1-19dcbda6e2e8@gmail.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAA/x3MWwrCMBAF0K0M97sDTaoVsxXpR6ITHbQPZqgop
 XsXPAs4G1xMxZFog8lbXecJiUJDuD7ydBfWGxIhtrEPIXY8yjjbl2vW12rCdXVhf+rC5Xzqy0F
 y2x0LGsJiUvXzry/Dvv8AXhvuA2oAAAA=
X-Change-ID: 20261123-memory-failure-fuse-skip-b976b4ea035b
To: Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 Muhammad Usama Anjum <usama.anjum@arm.com>, Kurt Lin <lylin1023@gmail.com>
X-Mailer: b4 0.14.3
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 0FFF180002
X-Stat-Signature: tkcwxxp8udo1g7dqtc65drgxuo11bwgs
X-Rspam-User:
X-HE-Tag: 1795370338-559890
X-HE-Meta: U2FsdGVkX1/hRoMGRRDCT8Us3s03G1+x3jiuiGfDILGRk0In7BZfNrWC/MZxTBVy/wN6jb7mOW2CjfY2nuwEdWH3KMobK1lJ1WaSnowAkj2q8ABRNljv6FNXJqL3+X/gwRnM3cFvbgsBJx92NT641YR918zsYqqk4Q1L1OfgXCU/jWcnIc1392vm8mQQPvQ8QpPhY4+zGEv3kUaZqKwPNGEcFQRGYPiF46OPIKZKU8N5nqVBOyxtY32eL1VH67ZNNzXPDivj8Pb6mvchec4u124+wEjV7uCYU9SSlGa5qO6t8umv8OGkvmF66cKwRBcvfqliG07DJS3Tm/VwsAWpxeXj9JSHI2NHfA5z0owq5kL/TTsNzy7GRZpkI3qu0hDotVvmuc35QbyJ/NVujU4CGrTfsFK/2//imYRVl/hAWwDtSe4O6ItU2DegA/GwtAzXI1Rp4iR5atxyE25w4DF+MULFwtZ9UoXktmCy8I5bJerX0O5HT8L/tGWTE382dp7cumabrLwMs1yXfxoOEdlHd3Dkb2ZjHRCt/Kmu/Yn1bPDIJT3NRYmGrO7yhNljw0g8SG9ZQZh0pUmXj6UAPQuBWEbOOAMUwDnsHgwBXYd9kaO2reRokyt0nbUDy1LnFjus9lwxsc4RJWuYC3ZMXd9iyq9+4XznaEsRLUHzJIL1EAdYKyZc34BNUBkanoZ373wXYlVmfmsvHGV1rZvYa2tJ8VvNrGJWQsP1+mIaeuUY0XTfM0nfSuwbqMh6XDTDoyASFTxLDyp4OgeHE63by/PBG0pLbm5OQKyCaNJGnD7fk95HFmcoIXFM1EkJvKglchX/Bu7bcQAx+vyCH6P8mZUYIpZJu72dBGPQOm7N+WwFtwPNF7rqHau2wkl1XQIDhKcsGQal/3mxE3bm0M9LWM3tPxHBMSxA7r8yx1S3eEqw8A3zZViPOe3gNv/F0oQ5fpS3OM45HSjpw8r3Bt6QAfC
 0/FeqVp4
 KXyqzhgIo03m39aB7JKallxGRXVUcVSA5YkePzALSJaiQjlOFGdI64+8ZuaJ4+HDglQuZDdsa/zUxa8Lfux9/ujpIq0mHLm3ztigonR+pSdIyEnyq/zDueXYvMdSAIT1sqGvzecIhrmqAKpkutwxrB9N9NT8IT0ZNX+0WBCPhVLYVSgxGNL2EEAgeTHU0lDwPyNZePruWK87FNaGavxksD0i62qklAFO1JF6JtVGHX/30XkfexEqX1GNDncim+ds8RWzh0Iv2G2TkHSZtViLkifSClVsww8wXtQwUxOXQ7okukAfHDMoC5oi3PM7OfNgLBMQvFSafiJWNU71aUUnyWV7q8fUHI9nZIddA/bgk9jBn7fLUaYw2tgZ5IUS4ig5CpCx+u+KlX1r68whBQvQTPVx7ULzCxdNkKtOoLdHFzdJT/BtHvEEkqzJTN3ngv5wy92vnoSKCRotHVU3bgI1mRMySpZhSbWMf/k53fpJPZuonnTAIweyT0CvzECH0RAAdQoBE3IwQ6FYLvo0fPH/+uvB7ZEbpoVKkQhIa7w2OH8FOtuXTeS6dmZxb/mJyfsyXqyVZwp9yQzL3jmK9zzucpgy+ISdj4WJqwLsoBvhJrnLjh+c0NSQ6LLZ9TEV6C4mxgJrLvQdGOjHqa8D9YGg6AyV59FaWbD3Xv4B7REyZuJrTWStMCAOFTGHMUzT+ZLXZFeVV2TjFc+QDQYOnZS8lJinubg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Like NFS, FUSE reports on close() the -EIO that MADV_HWPOISON records
in the mapping of a dirty page-cache page, as fuse_flush() calls
filemap_check_errors(). Run from a virtiofs directory, e.g. in a
virtme-ng guest, the hard dirty_pagecache variant fails on its final
close():

  memory-failure.c:389:dirty_pagecache:Expected close(fd) (-1) == 0 (0)

Skip it on FUSE, as commit e14e52a7ce02 ("selftests/mm: skip hard dirty
page-cache test on NFS") does for NFS.

An AI coding assistant (Claude) was used to find the failure, write the
fix and draft this changelog.

Fixes: d51b5076c746 ("selftests/mm: add memory failure dirty pagecache test")
Signed-off-by: Kurt Lin <lylin1023@gmail.com>
---
Tested in a virtme-ng guest, memory-failure built from mm-new with and
without this patch, hwpoison_inject loaded:

  cwd on       before                  after
  virtiofs     9 pass, 1 fail          9 pass, 1 skip
  ext4 (loop)  10 pass                 10 pass

run_vmtests.sh -t memory-failure from the virtiofs directory passes
with the patch. The soft dirty_pagecache variant keeps running on
FUSE and passes.

FUSE servers that open files with FOPEN_NOFLUSH do not report the error
on close(), so the variant could run there; it is skipped with the rest.
---
 tools/testing/selftests/mm/memory-failure.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/memory-failure.c b/tools/testing/selftests/mm/memory-failure.c
index 135a2e8069ba..72a29ec19692 100644
--- a/tools/testing/selftests/mm/memory-failure.c
+++ b/tools/testing/selftests/mm/memory-failure.c
@@ -355,11 +355,12 @@ TEST_F(memory_failure, dirty_pagecache)
 	fs_type = get_fs_type(fd);
 	/*
 	 * MADV_HARD poisoning of dirty page-cache data records an expected
-	 * -EIO in the file mapping. NFS reports this error on close(), so
-	 * skip this variant.
+	 * -EIO in the file mapping. NFS and FUSE report this error on
+	 * close(), so skip this variant.
 	 */
 	if (!fs_type || fs_type == TMPFS_MAGIC ||
-	    (fs_type == NFS_SUPER_MAGIC && variant->type == MADV_HARD)) {
+	    ((fs_type == NFS_SUPER_MAGIC || fs_type == FUSE_SUPER_MAGIC) &&
+	     variant->type == MADV_HARD)) {
 		close(fd);
 		SKIP(return, "unsupported filesystem :%x\n", fs_type);
 	}

---
base-commit: 7d1a16abe4cc5dccd21e3d6262e44433a5885d27
change-id: 20261123-memory-failure-fuse-skip-b976b4ea035b

Best regards,
-- 
Kurt Lin <lylin1023@gmail.com>


