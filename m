Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF5E4CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 13:58:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06A288E0003; Wed, 22 Oct 2025 09:58:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01AD78E0002; Wed, 22 Oct 2025 09:58:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E72F28E0003; Wed, 22 Oct 2025 09:58:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D1AF88E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 09:58:08 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6F6225B92C
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 13:58:08 +0000 (UTC)
X-FDA: 84025904256.01.81A805C
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf19.hostedemail.com (Postfix) with ESMTP id 91EA21A001A
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 13:58:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=W6cVu4fm;
	spf=pass (imf19.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761141486; a=rsa-sha256;
	cv=none;
	b=kMRot8KRdkPjPGJWL1S+YpEK5LemyTU4tINl0cy9uX3eIFqxpMGhetrKnk4+IPPDFEp33z
	Iv+MtGSugfgsA/VP+gfh8lv39JsFzyXqt0pLiA6M5DYjZ7de8Zj1npYylgXhq/WcmLEiZ4
	T7ZYwAGQ/RijIaPymhpvlY4SrKcWhXI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=W6cVu4fm;
	spf=pass (imf19.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761141486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Kp0mM9JFdY1qcqdgJXC1k4Ghi8aDtWlI8grf4712vk4=;
	b=6gTqy1tthJgvw324r31EWtXNKojHmfQ3/8EnlRfCuT808AaipWIPo+9dY/7jwSMbpkeNX/
	lIqwgi1ZaymuVuv2DyBnBZfcipi4GnRAh4qfxCqsXcsx/5YSZRm11+hEHQG3W2VfxiYaR4
	F7ZebQH6JnpL+9cVgGiLrmrlYtqoa50=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7a23208a0c2so3327014b3a.0
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 06:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761141485; x=1761746285; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Kp0mM9JFdY1qcqdgJXC1k4Ghi8aDtWlI8grf4712vk4=;
        b=W6cVu4fmVYTjE7dneN6LjR55jU8jf+OHFu8ZwmRnvPbFxrAGkpcoHFZHhoM8WxUmwm
         /nvvc94J/exODBGh1lMR5ogMyW2jtRoKpS2VLuKZfI0eFSVnbbdZVpqGf5jLNvY5bWWv
         Yn36imNpxL7TV9U9CqH74ouqwOa2LCDxn6fQo383oxWp7+9JIB5awTDs1CbV1ZHwk+rG
         uJqF+OrOyttFHjn41erPRdnqb91qXkRZaQY0HiwyCbTLEjk6tPpUbsEdrw9PhxcuFmNc
         pOPheBBgaL1pvBldcpujeLhfTMUnu80mdtuphwWjycw5TjuPmpLzlwGhedqiGn1yEykw
         wcHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761141485; x=1761746285;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Kp0mM9JFdY1qcqdgJXC1k4Ghi8aDtWlI8grf4712vk4=;
        b=cRB8incGshqBy+RX138yCGUxl6JiicF3jXVCO6prgnNFOsJwHUw2dXXcR+Q07jdNnf
         VUXTgzReMcZ9WRSI57g7akUIQsGnfUuwUTrwFoGd3F0ZgvEe03lCc8IbDVUaa3/MpkzH
         OJr2ReM9LcpP6IZuUSxF0RKSTwYsuTYk1xVvUs/eyk1etCd/Wgl7RaJpmNz9bE/B1Gq/
         fDBwZlmeIPuSC/xRVwTo+UJd4pkeWEJt1gBi4g3pbn8DM8bGlYPFz25FS86D629Wh8Cz
         4h6J0Hi4FSsrlKIrrXsGQIwROdGb59rDWxECYuFVri5eW46VZXKNH5RorRcA/Y7M/jqH
         p0hg==
X-Forwarded-Encrypted: i=1; AJvYcCWH/JXnsS2Ae9vf3QNlmnQ2FL/fpmrpro1e0hqr6x0cObJdCX6JyVeHxB+8o6lfVYwbE7OSRUcLcQ==@kvack.org
X-Gm-Message-State: AOJu0YzThV38WA2VrW4PqheGTW3IEVb9d5OkYZrjpMdLEj5vPo21MHqA
	0L7DujZz3DmLeJfRxf1MG2HMKIxQ4slTHgu3QhquDzckep31h3Ozpytd4sChuA==
X-Gm-Gg: ASbGncuv/XclrBkbnP4mhLnFhywjyw/8n27fwf/PgYBc9Q370izOl8JOO/RG1hriy+e
	4A3Rpgo95UR/ZJJRlHfeyJMZGYxKfkdnkZFhYtC3+sPC/0ntwiNwvVdKJ0L9fait6MckWmdXDNr
	fOXxTJEvBc+o8BgQAEOSj6SEgD5R7lc7ex4TKnl7TxPA8e+Tuq+G0J15gAgW9eRMrjhk0gliSc1
	cBZOfh5NZ/7S9gHUbPwsgo+kaB1Aafs7rdzqC223n2BURKF6brOgA76LcXKBlpM8fBe4wtsSNp+
	3A1LOTXoda6CUGfbwCtUF/1WoHoBDqBRLbCLeZoBwpa2Krx7hDHqMdVhktS2rE6lPFblJTivDqW
	ZYQilThl2caZYowdMbJd7L+Ai4i2UGiv9bFxlstn2T9SlgQskIXikimFA8aCTiwuFwT2C3QrJVn
	U/jNApeWPra6+Aucs=
X-Google-Smtp-Source: AGHT+IGjLidG7JODwnkAIkbP1GeDN8MYzPHhkFYBEqm9cXg1a5wgXqHHcQ6Qv3vY8mGO1EtlTtwdtQ==
X-Received: by 2002:aa7:888e:0:b0:77f:4f3f:bfda with SMTP id d2e1a72fcca58-7a220b25969mr24268270b3a.31.1761141485168;
        Wed, 22 Oct 2025 06:58:05 -0700 (PDT)
Received: from localhost.localdomain ([240f:34:212d:1:671f:870c:96dd:31d0])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a22ff15985sm15047365b3a.5.2025.10.22.06.58.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Oct 2025 06:58:04 -0700 (PDT)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-cxl@vger.kernel.org,
	linux-mm@kvack.org,
	akinobu.mita@gmail.com
Subject: oom-killer not invoked on systems with multiple memory-tiers
Date: Wed, 22 Oct 2025 22:57:35 +0900
Message-ID: <20251022135735.246203-1-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: niww3cjcc3731y9b7gey9tnh15i1fsab
X-Rspamd-Queue-Id: 91EA21A001A
X-Rspamd-Server: rspam09
X-HE-Tag: 1761141486-576932
X-HE-Meta: U2FsdGVkX1/82PBwyLi2EyOtZ2Uvtdpc2GOY3ZkjrdXPK4+Ivl8QuS1GodUJhy1qgtOoicp5zhsHPIXJeqOubgKm9ROAAYWRCMz8ugzVIiQB1BZzftlCNtUZPA24F16/Mc/MNNtcyEipkZOJ4Kuuu91j2jYrkCAnEtEFyyVV1YiYLvVQeQ+W2vIYqmv4Ql/aWsmHnL/gS3tz+UOuJ6/sEjxzWO+otZY9kRnTOMstf4ieJVFkNbCAKX7ZOl32Zv0zqBphMd///l68elRkoHw75LrnMtWbxHiiLkceee2U7sygENHjtlGrDMHEjN4ZL5ty2Qvm7VyiGq/s8IKD2MmK5Rw+tKXJ5fifitK3R5nuVo6y8ekajmycqbkN9cTjAk8sgJ97NBFJD7/DiCc/N0JQGQAUmAGVudjPLCCsFW+1mY4lflpQp8daDAesZWzT6fUhP+lWMeGYgELcl1xm59AlqBaMlnIAWK2vGys4pDObPs0m9kNu1GYfnhHzQNs4zqGk8TtVu0zw+RM4k+8K0CvwgWSyoYQ3CujsvcvtMy7JHg6wTdBgSQE/k2pa2d81ZTfQnf87NXFJULnvYYRzWupfasLewIC6FlExGbuNRsPTXH60pgMVAlp1mvzdJqZDPnvpRlpXrJzNJDkLSQWrv05dEIDixKDspE2NjyB9PQPFoQH1umB/ZadpFSTmXrQPah08iFLW0rqP/lwj2EPpD9WDXhRU5nZilhwj9IIWvaaFH1cLE0k1Jx7qemj0SaAOTvDFUkEgnCjg1eFhtgzVckf87HJPGNlNvCyozg43B5rP9PFYDU84Q3fQgjg7aM8S9Olgq4U4rsvXvDSFSMpyRCARzqo7E7ELM+Bu0RVE+b7mlAYLR1kMLcPOQQNNjk3feGuQmSYuIcgYaHcHu4R7EsHtdmNdYYFILvi2qgEYA6oMuNohucrpj8fR3pZRRP4FGqZUVfK78lHa7uvcoRk4bSE
 DaK//Ltc
 jFbprUPHmssgXfHze6Gdv+kjt/ye69vHkC4yhbTUW7czGExXVUXRXEI+DBv4yEshcb+f1U6I0bbdn4vppL7aEJbWfdbzWtimsJFVS7c+uyJ+vOSJ89RQO/XdQoc/KLvC0v+FmIqsD7y7Xjj+qKNNsYEuF/wongwV3cr9SHMbxe/1RWcmU4si7mC8vgGUuMVvQSGbLQiiBkSYvZxBO/Afx0MOhf1aoQcA5YcO0hJRSmUPMO0rnNMpFVlT1Y8Aog20tN9YOzcmL126ZMesjSQjcASUZI7B9JdQQ0TmbxNxZCx5faqOhZoXv/cQPGUMiJQLOLGkKExyhctRHhAaS39BLIcfxkKLOReHxu2zEI58nS1UClGSf959FcfL5JeigfLZu7db4hoegeCAO2f4Hlnv0sFuo8mXibkZyF+72ziRoQh47m8cqdkhVw+kijaPhfjCc85KEtHllpTiFmgk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On systems with multiple memory-tiers consisting of DRAM and CXL memory,
the OOM killer is not invoked properly.

Here's the command to reproduce:

$ stress-ng --oomable -v --memrate 20 --memrate-bytes 10G \
    --memrate-rd-mbs 1 --memrate-wr-mbs 1

The memory usage is the number of workers specified with the --memrate
option multiplied by the buffer size specified with the --memrate-bytes
option, so please adjust it so that it exceeds the total size of the
installed DRAM and CXL memory.

If swap is disabled, you can usually expect the OOM killer to terminate
the stress-ng process when memory usage approaches the installed memory size.

However, if multiple memory-tiers exist (multiple
/sys/devices/virtual/memory_tiering/memory_tier<N> directories exist),
and /sys/kernel/mm/numa/demotion_enabled is true and
/sys/kernel/mm/lru_gen/min_ttl_ms is 0, the OOM killer will not be invoked
and the system will become inoperable.

If /sys/kernel/mm/numa/demotion_enabled is false, or if demotion_enabled
is true but /sys/kernel/mm/lru_gen/min_ttl_ms is set to a non-zero value
such as 1000, the OOM killer will be invoked properly.

This issue can be reproduced using NUMA emulation even on systems with
only DRAM. However, to configure multiple memory-tiers using fake nodes,
you must apply the attached patch.

You can create two-fake memory-tiers by booting a single-node system with
the following boot options:

numa=fake=2
numa_emulation.default_dram=1,0
numa_emulation.read_latency=100,1000
numa_emulation.write_latency=100,1000
numa_emulation.read_bandwidth=100000,10000
numa_emulation.write_bandwidth=100000,10000

---
 mm/numa_emulation.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/mm/numa_emulation.c b/mm/numa_emulation.c
index 703c8fa05048..b1c283b99038 100644
--- a/mm/numa_emulation.c
+++ b/mm/numa_emulation.c
@@ -6,6 +6,9 @@
 #include <linux/errno.h>
 #include <linux/topology.h>
 #include <linux/memblock.h>
+#include <linux/memory-tiers.h>
+#include <linux/module.h>
+#include <linux/node.h>
 #include <linux/numa_memblks.h>
 #include <asm/numa.h>
 #include <acpi/acpi_numa.h>
@@ -344,6 +347,46 @@ static int __init setup_emu2phys_nid(int *dfl_phys_nid)
 	return max_emu_nid;
 }
 
+static bool default_dram[MAX_NUMNODES];
+module_param_array(default_dram, bool, NULL, 0400);
+
+static unsigned int read_latency[MAX_NUMNODES];
+module_param_array(read_latency, uint, NULL, 0400);
+
+static unsigned int write_latency[MAX_NUMNODES];
+module_param_array(write_latency, uint, NULL, 0400);
+
+static unsigned int read_bandwidth[MAX_NUMNODES];
+module_param_array(read_bandwidth, uint, NULL, 0400);
+
+static unsigned int write_bandwidth[MAX_NUMNODES];
+module_param_array(write_bandwidth, uint, NULL, 0400);
+
+static int emu_calculate_adistance(struct notifier_block *self,
+				unsigned long nid, void *data)
+{
+	struct access_coordinate perf = {
+		.read_bandwidth = read_bandwidth[nid],
+		.write_bandwidth = write_bandwidth[nid],
+		.read_latency = read_latency[nid],
+		.write_latency = write_latency[nid],
+	};
+	int *adist = data;
+
+	if (default_dram[nid])
+		mt_set_default_dram_perf(nid, &perf, "numa_emu");
+
+	if (mt_perf_to_adistance(&perf, adist))
+		return NOTIFY_OK;
+
+	return NOTIFY_STOP;
+}
+
+static struct notifier_block emu_adist_nb = {
+	.notifier_call = emu_calculate_adistance,
+	.priority = INT_MIN,
+};
+
 /**
  * numa_emulation - Emulate NUMA nodes
  * @numa_meminfo: NUMA configuration to massage
@@ -532,6 +575,8 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
 		}
 	}
 
+	register_mt_adistance_algorithm(&emu_adist_nb);
+
 	/* free the copied physical distance table */
 	memblock_free(phys_dist, phys_size);
 	return;
-- 
2.43.0


