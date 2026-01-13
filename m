Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55D14D29DE2
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 08:15:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEC4D6B008A; Tue, 13 Jan 2026 03:15:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B96756B008C; Tue, 13 Jan 2026 03:15:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC3436B0092; Tue, 13 Jan 2026 03:15:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 990286B008A
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 03:15:39 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 448FFB6FAD
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 08:15:39 +0000 (UTC)
X-FDA: 84326231598.16.1BEE7CB
Received: from mail-pj1-f67.google.com (mail-pj1-f67.google.com [209.85.216.67])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5A35CA000F
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 08:15:37 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="BnjIQ/2T";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.216.67 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768292137; a=rsa-sha256;
	cv=none;
	b=NDmyIQiKTh/gbt8xz1004a61T0C9aurkxqTbkqyakCBhFIIOzsbzC0aKasz94zdJIUM+BP
	tfAB1EjeenLXOrGP+W3okj/uYqc16FeI1adDSx9b3X9a0j3msCRhSTCU/FD+JwrjJ7NSzk
	gell1OUssbfcD+1oycoDO/dNRKR7bWM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="BnjIQ/2T";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.216.67 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768292137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UoxKrGhyaE4VBNdB4C6I31y/frdPcxDPShYvaQtOSlE=;
	b=aiVs+o7RQGkc1NmYh4qN0QujdDmOzzCR4iqMW6hu2YXL8xig12a3GrHVqIARd1tkzMTdNA
	2eX8W7zITz2+UwGgyolAWjODg2z7jboM9Fh7uhlggXID1RqUD7Nk5FDhWCuDg0V6j5fF8K
	n7ROgVMoifP3entgtVTJio4UDaNxIrw=
Received: by mail-pj1-f67.google.com with SMTP id 98e67ed59e1d1-34f634dbfd6so5255054a91.2
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 00:15:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768292136; x=1768896936; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UoxKrGhyaE4VBNdB4C6I31y/frdPcxDPShYvaQtOSlE=;
        b=BnjIQ/2Te2tKQmJHaNsB6oox2bBKAj7iSk6qOOnD3JxBye7z6jtfBvrgsz2SUBoaQw
         HCbjuxQAsZlElXvMGhz2hiaH0DUbBASHBtIl87Z8QGQTP25h8C1mQXUXnztZjP0j+G3l
         qdx1tdvev9Wzi2gvjGX4etkamHK6tGeDtu/5+JV3B9IGIFPqCUDAnm+Lu+dQG9w8OPRj
         spP+DNb7WKA9NVDFgzLtnmt1gmu9Tkig68Kjf+tKn3LAeMbpmxzC8w4MlaiVmTepK2YR
         HX9b34uKbxTQW6pal2IiJX4tH/fpo6oPG8hgPUJsYSkg+GenElIsQK8h+zn5j2T/KFla
         roMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768292136; x=1768896936;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UoxKrGhyaE4VBNdB4C6I31y/frdPcxDPShYvaQtOSlE=;
        b=JFVW/4koER/ulJwVXm5A2Bv++ci+LFIZHleoZCit8OLwrwU5s3DofLvA+ykSytN3cb
         joX6xqgkJsmBGdsSR55xGVKZRRipqTbDzNJoMoZfBsQuZMpnfp0ds37v1PLXTnq8+w/1
         yBJ+uMqcm4as223+cdJbhw2Z9TU6wO3mhaBzdEpv6Ju2zobEqjZS5YmyT0et4YV5plmP
         a2Be4ygnfR6CWIm4ghRoZ75uaEGaGEWxMxeIwA9g0z3GgegRL5iuV3RfHcyo0LtFA7gP
         6DAIuKfcB9qNthny9sSo7ExZr58QftYd/dj2ExCirGolwJKLrNIEFdVjbKh+8Fi2tINB
         Tcnw==
X-Forwarded-Encrypted: i=1; AJvYcCVwZxSQr70tIj/+r7rjwF30sqbPTbUHPkzqRzrCJQjCW2KFbk0qzu9XbGvrhHpJGDiByugJP695IQ==@kvack.org
X-Gm-Message-State: AOJu0YwK6M8Ic8Z1fg5+3mN3NukdG+qykoxQm4HZ8S1yU2uH/azjLdNT
	OXYIEhidLFBaLtja8fvR6U7MWeUXU1TD4KM6qecwtizYnaXvjDnEycsV
X-Gm-Gg: AY/fxX75/vMKCtxMmsEBin8GP45jNq6ysKIj28OHa246oBTqrSCHa9JU1enzfKTknXm
	FrZzUSOPeylD6BHGPL4/vsRi0Eoj9sxoQRWDPgdnJTX5UObWu4E6jGMfPilVzhLeC0SdcXQohiA
	7IqpLvjNOKK1D8hQj7A6sp38+P7+sNGSnhMNRIZJ70CYPZDFzzWCanUCf6iZvz2vD0IpoCdt1K+
	kPOCXTPKiecQgaM63mKIC5Nal1tVeUDG2LVuKFku/9m1Aj3+J4TnOTCQL98bGC+eUY/KleA73af
	KOvemfX7GNrlc2NXmzLmyqrb1eqLvLmm2d80Gj3xW28S6yUvc0PftKam02VFrFbDWyotDTQd1sO
	ZCiqacOHC5CXub6XIIVrzu9qnGUD+6V8S8NfzTJGXWA5SzQLe77QnBuCG/HjqV9qdKHWVnKij8f
	11Q3zXGxWD+pQGnnq3Y/Tjgfy7Bg==
X-Google-Smtp-Source: AGHT+IFI8tZbu3gKqGSLHJvoaf0AjOxH+SKwPXLRujBsbcbN09R1JhQxlQ2NzJCr7k+pKN2Pqi467w==
X-Received: by 2002:a17:90b:3c06:b0:34a:b1ea:664e with SMTP id 98e67ed59e1d1-34f68c4d4famr19778021a91.15.1768292135720;
        Tue, 13 Jan 2026 00:15:35 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:180a:3788:c683:2f64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-350ff05492dsm657199a91.3.2026.01.13.00.15.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 00:15:35 -0800 (PST)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: akinobu.mita@gmail.com
Cc: linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	hannes@cmpxchg.org,
	david@kernel.org,
	mhocko@kernel.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	bingjiao@google.com,
	jonathan.cameron@huawei.com,
	pratyush.brahma@oss.qualcomm.com
Subject: [PATCH v4 2/3] mm: numa_emu: add document for NUMA emulation
Date: Tue, 13 Jan 2026 17:14:52 +0900
Message-ID: <20260113081453.8293-3-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260113081453.8293-1-akinobu.mita@gmail.com>
References: <20260113081453.8293-1-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: xq1js86huw497o9g4bued6aeiwm5yomp
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5A35CA000F
X-HE-Tag: 1768292137-369784
X-HE-Meta: U2FsdGVkX1/73bWEkjo9j0rARBnHkrC+VE88wuwCbhcjLkHRK0lYfEGTLBoFOTf27glvNV33/ljhBbNIa302xlN3qUlGznME8gZp8zjFFUDlIxQqPYFyXlgf5zAML8ET8G9dCFEyyYqocBhNgI1oDkGfFSoYHHQfnbk9CiGSzHLGvTrFRnvODKdReYYGbYU+MIhTYEkOvrQMazuDGRcuHRiqYZca5zcWu9tgTtIWa73WR0OKGBnc3n8deuj/dhZFLna+b7kC627gTFRaeNdbyXI4ex3LRxce9bfWl/PCCn6hIB0WsOmaKR9SWGEK2bnUqYmhvCgfUgKhCBFqJg3xiFOy0kNjNMfVJElMfW3Wvfv8zX0JdSMt02wDPcu4hTIje59jVlUNLSzInYCncWW5sUprAeQ/ZSHXYYLhThdsU1qb4t7+CgAuj1uS1ClaL1lBL7ZvodtnhJq7Uja47nongo37GL/3EJR+oteWvwOfcmgOBNO7FWfZDb/x5FWOytF9jjnwlTs0UFLS/Sy0CKnH6qfkxdTsimFY9veF/srMmk6X2t1o+5mE57aX28kYi7WL/b3ppAjgjPxR5eIZpBShUtFopOb1+d/lTm3KkGI4BXc0PpbzgCPh4rbV0uosseKL0xtOlFpMGNv61Wsck7pIj1oPBb+z55tak7RyrRnyr0QVG+kXW4qHTlu5rctSJk1sN8j1X8kJe2OI5obReBdBoH9ASg7nbKwOlG6uGPwSTrWBcl0lS2DOvisi8D19IOuHDmUlntsE8TSlWQDFiL17EH5cG553YEznDc0GBE4p6KeEw+d/YWgkok6MUX5TDhhgYx8P9vrvn96schKWowLAp4XHuR30FLEyfi6CXbQkNVrl4QSWy1NwcrMQyR9yqiMwjhKmWXrftePQkTuLp4/haXwvOAzkTZe75TEikrbGfV0tntEp/oI5SwY3IdK+t2rCc+WjYRgI42MyVdMiBUr
 JuDggxw7
 eM5X+Jr7WhA/1iUxBBgqEW9Zvw0bKMpArXd0zEfSlbtM9rEcYMiqu54Y7IGRBPDpXusDTQNpitbBYLsLvI+szIkhU02kD7EPrw+BTb2Y4SpRDNevrIEJA7e0nyn9NydHl5biie9lK60PwGlfnqQQCuirhTemOMbDi7Aw7h9yr9qE4n8VYziip4kB3Di90L2VRW88vKnLYOUAEyzNOxgF0fsaNag+/izujButRTn1rKc3Aci4wmJsnqkiuLLXbLh7X3JxTM7uUL93X8RWR1LXG3jWTvy9qA6auldQ1KwUFbMrHhblUNCE+cplzzAALnEOPhFK2iX8ONN3lxshjm+Rvc+jiinBTMJ/dokuYOXqc28zTDcunI+mZOJiSQI03tYOidZ9s9IQ9W5bOB8griI8KObxt77L6RBPn643hPddL3o8h/2WanWXOJJX409vGIJAf2BekfMdmg6XSUL8GNc4HMuFMJ9hPDBq1CjqRrWwgh2dtyScB5Odr+dXHNQgo37O3F4oatu3DUSJiuzMTQYOOzfMtgEY2oRvQvBZYR2jOrVpITip79T+PK0ZPdn9FEIIZPJLu+Wdxmhhqm8v68oh2h3foWIENDCtei6i5/AuV3HZEAtPkUAwbAIeZa0twvOEwTOaRZYXsy0qz/F5vdahcEhvq4gAgwgSiTDFOomdpzsUMCVcqJqptIZB6PA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a document with a brief explanation of numa emulation and how to use
the newly added "numa_emulation.adistance=" kernel cmdline parameter.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
v4:
- typo in abstruct distance value
- add information about supported architectures in numa_emulation.rst

v2:
- added in v2

 Documentation/mm/index.rst          |  1 +
 Documentation/mm/numa_emulation.rst | 31 +++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)
 create mode 100644 Documentation/mm/numa_emulation.rst

diff --git a/Documentation/mm/index.rst b/Documentation/mm/index.rst
index 7aa2a8886908..7d628edd6a17 100644
--- a/Documentation/mm/index.rst
+++ b/Documentation/mm/index.rst
@@ -24,6 +24,7 @@ see the :doc:`admin guide <../admin-guide/mm/index>`.
    page_cache
    shmfs
    oom
+   numa_emulation
 
 Unsorted Documentation
 ======================
diff --git a/Documentation/mm/numa_emulation.rst b/Documentation/mm/numa_emulation.rst
new file mode 100644
index 000000000000..81f15ea68022
--- /dev/null
+++ b/Documentation/mm/numa_emulation.rst
@@ -0,0 +1,31 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==============
+NUMA emulation
+==============
+
+NUMA emulation is currently supported on x86, arm64, and risc-v architectures.
+If CONFIG_NUMA_EMU is enabled, you can create fake NUMA nodes with
+``numa=fake=`` kernel cmdline option.
+See Documentation/admin-guide/kernel-parameters.txt and
+Documentation/arch/x86/x86_64/fake-numa-for-cpusets.rst for more information.
+
+
+Multiple Memory Tiers Creation
+==============================
+
+The "numa_emulation.adistance=" kernel cmdline option allows you to set
+the abstract distance for each NUMA node.
+
+For example, you can create two fake nodes, each in a different memory
+tier by booting with "numa=fake=2 numa_emulation.adistance=576,704".
+Here, the abstract distances of node0 and node1 are set to 576 and 704,
+respectively.
+
+Each memory tier covers an abstract distance chunk size of 128.  Thus,
+nodes with abstract distances between 512 and 639 are classified into the
+same memory tier, and nodes with abstract distances between 640 and 767
+are classified into the next slower memory tier.
+
+The abstract distance of fake nodes not specified in the parameter will be
+the default DRAM abstract distance of 576.
-- 
2.43.0


