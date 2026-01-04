Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBE66C2A06C
	for <linux-mm@archiver.kernel.org>; Sun,  4 Jan 2026 05:42:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50B596B00A3; Sun,  4 Jan 2026 00:42:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F5666B00A4; Sun,  4 Jan 2026 00:42:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CE906B00A5; Sun,  4 Jan 2026 00:42:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2C6466B00A3
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 00:42:12 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D68C5CD494
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 05:42:11 +0000 (UTC)
X-FDA: 84293185662.02.B85DFDA
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf23.hostedemail.com (Postfix) with ESMTP id E5662140002
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 05:42:09 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dGUXWX52;
	spf=pass (imf23.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767505330; a=rsa-sha256;
	cv=none;
	b=g7amk3r8YrWHUF3TSWG+lUbeqY8Ga174YxrNNBEjUSpXbGHByzrgcNhFUD1FwvKMZ/4Y9c
	fGlAMuuD4A5MjAHRThEah1nZn5/N/1Q4DAlLJVBl1/eulb30b16QB42azy5wb0Zw1KZcKP
	5744DVM75iTs3WiuHkDd+zhuce4iaX4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dGUXWX52;
	spf=pass (imf23.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767505330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F44pzaXhOPAiorm8Jky5wxgt9AYKY8ytZVulzCsdHj0=;
	b=irtMql0B1BK/dDX8+9TrmQu1g0vmKmvIj3LieJPGCvF/JHZvR7eZF8yxwxGORcBMZEDl3+
	n9glhmFqvx+wZMbj5f0jyerMwfX9GCldBiDd4S5bFLYwX6j/dBIHOPuXhyQ43US3K/YJrv
	kxMwD39gbijhs0peGKZlAzR3iOADPoI=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7b9387df58cso21116593b3a.3
        for <linux-mm@kvack.org>; Sat, 03 Jan 2026 21:42:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767505329; x=1768110129; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F44pzaXhOPAiorm8Jky5wxgt9AYKY8ytZVulzCsdHj0=;
        b=dGUXWX52FFQpi9Fc0IxRRFjCLRWBT27zvC1bEBKOxMdoYzfizd3j4rPTbyuX5SzYk2
         96B+ftDA+06JBRQaGTYvRw3yvSV1+J81Mjmkqs9oWaO+h8/0LVukM1ueUw2NkSkzWkLV
         Sph+Qcb8w2jUn81lDJTal7z/sRoMnPNb9J6/ijg2a7/MQyKNCyttzFNwx2S5sZgf9LjU
         p1ffCIZoQohV/oHA6EYPCvW0xBaizXUyHAJzTdEUNkFBOYTHGyYCikvsTt2MaPhP8m8l
         QDEXAjwvk8Qv+oBlgpAQKPC0QH+jIg7AWsnaWH1fYFzJqOVCpvgF/hBIZmzKsILvSyEH
         /OXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767505329; x=1768110129;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=F44pzaXhOPAiorm8Jky5wxgt9AYKY8ytZVulzCsdHj0=;
        b=UAVTbH7+iAGOpHVNGtXT7LOsXK4Angl7jtka7rX6d9HbNdi5SvOp92h+lp8qrJO+jj
         xupXCcHTHFeerZHpmlD+ucAF9pWEUYWNwx+99DkM1JLz/VO46FQfbIJ+qS5Y5enWIImB
         egHl8xfBZn7gNElyW5Q5CXX/3SRPqtsoK0L8F6j65nxKkfIVF07xYV3Rug6KCdLpzDEP
         2gbEOEoXEqpnlyYL/T4GH3G6GCrfrN2dzXguGyO6qWJ+qYCeF6V255QZyRWvGmPZaEBD
         6IaAtVVuqQqp58kW5rVWcj/+h9eIg5O9JBQNBgUZxz/OUGg6uCGze9xGIzLZPruPXgfN
         a6lQ==
X-Forwarded-Encrypted: i=1; AJvYcCV7AHV0ZnfBr4mj8DFRpDKGSGajohP7QO5mQ9eE9tKIgcmD72EWtx64rSgs0DwRx/yrLPDGGDshqA==@kvack.org
X-Gm-Message-State: AOJu0Ywx0OpzJy0SYDZAsR864bWicRrewDnY+0sXtQYXtxtC7ueOBNwb
	NqR5Dm5OPyjmOVMncA7eN4cem9dSecd+IxrqxDN8WJFwdp36FFPN0reC
X-Gm-Gg: AY/fxX4Cad8iQWNihwMLsxEQ2AIQB84ZZ75ljU/O8Imz2rKLE6sSB82IlDcixCZSsnh
	jNc3agzmxCV8jkfjRHhykfUaQTszAqXqIAxgGeKCgkxJEf1rUD5CI3/2PJHmb9F939z0xD1vJFI
	BOQJdAWbyqujEzykGby0Jpy9IqRVmM2rj85iaHJKYg13IX95Wv+iQTJIid4oUyVy66wC93KqFGs
	6PxQ/Z8kacg038Kk1VIwDHqEueRLHi/TOmyi7udYREjT+NtpHU3izCSFlEz1nW1PvF++5oQYJqu
	gEQyONOJOKOq+v3DKaW3Xz/2nWc/MSI6auwdLKhI0q+I7SxYmeHXUVx5d0D8eZ/JYsCYGXf7zls
	PTCLmJ+vGwgFZaW3da0Ky+rJn5eteE/qgl33CNRjqCgGCvMx7eE53hbPbLuQsWGkuqzycd518Bh
	z0z8GPmWB/wzD/sFO1BldwykWnjMTO
X-Google-Smtp-Source: AGHT+IHQdG3bTbRK9bIIj2RXdTLOpt0yuYf8P9QBrnIfSlCobBa6x5vT+EOIMVWV1mueCxVPAE89wQ==
X-Received: by 2002:a05:6a00:e8b:b0:7e8:450c:61a9 with SMTP id d2e1a72fcca58-7ff6705d2damr42086059b3a.64.1767505328876;
        Sat, 03 Jan 2026 21:42:08 -0800 (PST)
Received: from localhost.localdomain ([121.232.80.251])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7b31c479sm44378305b3a.24.2026.01.03.21.42.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Jan 2026 21:42:08 -0800 (PST)
From: Vernon Yang <vernon2gm@gmail.com>
X-Google-Original-From: Vernon Yang <yanglincheng@kylinos.cn>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	richard.weiyang@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: [PATCH v3 5/6] mm: khugepaged: skip lazy-free folios at scanning
Date: Sun,  4 Jan 2026 13:41:11 +0800
Message-ID: <20260104054112.4541-6-yanglincheng@kylinos.cn>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260104054112.4541-1-yanglincheng@kylinos.cn>
References: <20260104054112.4541-1-yanglincheng@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E5662140002
X-Rspamd-Server: rspam04
X-Stat-Signature: 9yn7ncjsxczngouec7id8qqyo46sd1ry
X-HE-Tag: 1767505329-778435
X-HE-Meta: U2FsdGVkX18PjtH1RKzTkDBmQKn970IuGq7bAtiAtZckSwT/XPy77BqEyGMkgS+E2PGMkF7oipMqnPqpxOqRhjgPtM49lkdxppj/q5K7iWKfBmtOP2TaU15n7l0+QOYqmAiY2zRhimHu0v8qz7KBAzy2zAH5FT2eJ1WC/fgeZ6UMJYndMhzRPvNCGJzZkj+3OASGWzCY7zLdwa+JYRe+BL9+192v+ANXY6ssqcDoUfscHMkZXGi0nIWUOUBqhRKOIAFNy/SIt1C2GU3o3DB1dy3K9YtJr4QKwdPNGgrm+ZkrKkKl1Z2798T7+iAHTJge17qddNfAOQoYfeCZ0xwyVmECXByjH5LWhwp2AKeGKwmZ+61Fdwvj7LfSK7SF9y0dNR9qVQW/l5BDMlhbfSMaPud96zHdbg/wp02pvSb3NXbXOMdVCq18lQ5HB/Wbx3fD2WfhjMuaNQ9+T3CQToA3rA5XEjRPcf/hcPSKHDsTV19IhRHFQ+7YqOCXUvhr4UDIlgNa7+U7vOVSO6NK4BWhHbwF3VWa+rcKbrbx0QAELZpxZGg0FPKBkcYGIjCQx0Op2aQY4AzA7cEWIiFzjD1qvD1Voa5TpxLvgNeNPyPSm9OGFscpElK/Z6pG8MyT8IGVSGgJJbXt3tkWXKYuS9bPp80Y8st4kOVYbkDdpdTja5p5LFj94up5pq57CDxrhAUAq9LLq19gEBG6Q6N0N15mI1yy50+OuBX2rxVz652bDot/Db7Rt9YYemnEMC6QxTXC93HF461Ea0bS372VbvFeSfYvc8UbJIcwbAdG06FEzbBvP05iYDaLPaCsDPfopXkueWPz3FkDCi1S5WLaKAcURKt5v/k6tSbjCA7bXaUI7L6WDENJZAh6gnia+69KqJlZnRoegXDprQXugTzEsyWYJtBHWwXKA8oAhH/EpLSEhgIIzBaAeycVWab6iCp4zT36uxLmHfzzWSbYYjyqF1M
 phqsCcHg
 OhQac+OPaNFBHWDqN1+8pn2KYXt4nXd/J4jdilV/FYcjicS3eSjL/0fHpZC7N7ezUjtdJfrt9K3x9aDJrnDcDPFmyi43uwO6PByHdYxkmyIAOn3JIPjdR9Dn3ja43M/CIoCyKDiDpDW7Zm8+eT5tJDzNaEtyiUsDI69jf4+I1RIRQLVML/Od3CUAax9nVZJVDASi+teEp3rUBzbL/DOHoQMexdy7raAfYx0PnjhOQzaAT9TbkGK9oKL4Urcyrpv1yTPeGe7n17bTOvoDtYGHUImTCUiswdSFVYnGLy/ECozzLSW3MdZ7lGvaDoWgi3e48YQ+Md3z0ev3ZzE1/Pb2hEOnMcIvP8o/YGbnO6A3150MfQVAwrPTVJjeAI4Tv1crW3QY16QVAgeXZyBwSXyb3cB5qLfg5ZUq4h9Q77IIV++bp9jc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For example, create three task: hot1 -> cold -> hot2. After all three
task are created, each allocate memory 128MB. the hot1/hot2 task
continuously access 128 MB memory, while the cold task only accesses
its memory briefly andthen call madvise(MADV_FREE). However, khugepaged
still prioritizes scanning the cold task and only scans the hot2 task
after completing the scan of the cold task.

So if the user has explicitly informed us via MADV_FREE that this memory
will be freed, it is appropriate for khugepaged to skip it only, thereby
avoiding unnecessary scan and collapse operations to reducing CPU
wastage.

Here are the performance test results:
(Throughput bigger is better, other smaller is better)

Testing on x86_64 machine:

| task hot2           | without patch | with patch    |  delta  |
|---------------------|---------------|---------------|---------|
| total accesses time |  3.14 sec     |  2.93 sec     | -6.69%  |
| cycles per access   |  4.96         |  2.21         | -55.44% |
| Throughput          |  104.38 M/sec |  111.89 M/sec | +7.19%  |
| dTLB-load-misses    |  284814532    |  69597236     | -75.56% |

Testing on qemu-system-x86_64 -enable-kvm:

| task hot2           | without patch | with patch    |  delta  |
|---------------------|---------------|---------------|---------|
| total accesses time |  3.35 sec     |  2.96 sec     | -11.64% |
| cycles per access   |  7.29         |  2.07         | -71.60% |
| Throughput          |  97.67 M/sec  |  110.77 M/sec | +13.41% |
| dTLB-load-misses    |  241600871    |  3216108      | -98.67% |

Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
---
 include/trace/events/huge_memory.h | 1 +
 mm/khugepaged.c                    | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
index 01225dd27ad5..e99d5f71f2a4 100644
--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -25,6 +25,7 @@
 	EM( SCAN_PAGE_LRU,		"page_not_in_lru")		\
 	EM( SCAN_PAGE_LOCK,		"page_locked")			\
 	EM( SCAN_PAGE_ANON,		"page_not_anon")		\
+	EM( SCAN_PAGE_LAZYFREE,		"page_lazyfree")		\
 	EM( SCAN_PAGE_COMPOUND,		"page_compound")		\
 	EM( SCAN_ANY_PROCESS,		"no_process_for_page")		\
 	EM( SCAN_VMA_NULL,		"vma_null")			\
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 30786c706c4a..1ca034a5f653 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -45,6 +45,7 @@ enum scan_result {
 	SCAN_PAGE_LRU,
 	SCAN_PAGE_LOCK,
 	SCAN_PAGE_ANON,
+	SCAN_PAGE_LAZYFREE,
 	SCAN_PAGE_COMPOUND,
 	SCAN_ANY_PROCESS,
 	SCAN_VMA_NULL,
@@ -1337,6 +1338,11 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 		}
 		folio = page_folio(page);
 
+		if (folio_is_lazyfree(folio)) {
+			result = SCAN_PAGE_LAZYFREE;
+			goto out_unmap;
+		}
+
 		if (!folio_test_anon(folio)) {
 			result = SCAN_PAGE_ANON;
 			goto out_unmap;
-- 
2.51.0


