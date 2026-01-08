Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDB33CF6AB9
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 10:16:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54C456B0096; Thu,  8 Jan 2026 05:16:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CCD26B0098; Thu,  8 Jan 2026 05:16:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CF966B0099; Thu,  8 Jan 2026 05:16:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2ED056B0096
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 05:16:27 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E3DBFC2476
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 10:16:26 +0000 (UTC)
X-FDA: 84308391972.30.AFDE0FA
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf20.hostedemail.com (Postfix) with ESMTP id 015201C0005
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 10:16:24 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iuXmFiKK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767867385; a=rsa-sha256;
	cv=none;
	b=gz4R8mdyx9uVkaM7vI05bW0XlPcrJfYIKHuB8JI+uQkppawonrfSPaV2s0R5LUgLv9nSxO
	G+p5j4I4KcnI794l1lXE8ECgFNFrui5bfNex73xO++AJVrLBIfaSrfmxcelWCSMVIIfroG
	UsVB4owpZnFVjAr1GZSLuafTgo9Fd0o=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iuXmFiKK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767867385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=10vzVgMW/SIAVZiREFQWpaxB2zwT+8w8TEXAc8bNZjs=;
	b=szVT7mTUvGdcboOsfsvDooKnIGnZo/KD6zEk6CAkWhR9GDk7Ao1w4fHMvJnd5nbrqeah2V
	N51aG+uCnPSMr7G8+WjcBIeW0ao4qEN7WSN8u+bp0moLUo77RVLRa3UDq6jJDMpThPrdxc
	Ts/CSuZ8I2i7etGVIwgXjY99dCdNVTA=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7f0db5700b2so1710884b3a.0
        for <linux-mm@kvack.org>; Thu, 08 Jan 2026 02:16:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767867384; x=1768472184; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=10vzVgMW/SIAVZiREFQWpaxB2zwT+8w8TEXAc8bNZjs=;
        b=iuXmFiKKH8pA7S9QvXA2531lMPTDUrDzcJ/lC/J2ON3jTmfR6B9sooQP4UEdEeIDhi
         A7mIaiZFyZFcKvuoKlX5QSgiwAJJOrIftopuj72oNyJwNEFxKPUIW9Ld2E7+ec44vL5c
         DbfGvqGimPQ+wER3s6vOklzSsxu/oNRq/C0t+p0tJ/nUruprQrfIw0gILUgnbVxTQEI7
         qbhJultu8QGsWlsoMMR76lmf3AlHZVJJZOf4XetyECye6i10r4YZqRCg9dYjBPiTG+I9
         D0oVRZ2qyPNES8qHx+2MlNK1YjfV7Q/HBTvtRNt90NJHOCOwkRCB+dgq5U+AcjOIuU5o
         wgsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767867384; x=1768472184;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=10vzVgMW/SIAVZiREFQWpaxB2zwT+8w8TEXAc8bNZjs=;
        b=RERxskc3y18YZGYOq4YVEAW9OXe93S6X6DdrpMBXN3Zff0IfOeGkSoSWMJ3GCR2A75
         h+DwUPw2Rf7JgWpvmmRrLzJX6+jUVzCyJ//I6hBKgnRIqQdJN+EvsemXpJubB0mJ0/Wh
         ZqwSr63+OjKiK/s6atfN1nDFcuEgkZDFJq4Vo6ZlRoPRm7DniBUXdVVXUn78nZ46gZnY
         ol3wpvaEwqmMBpSLCPo8jewIMAIP7c8yZ3EU9qf1qG6GIru/AhyOjpvo98M345KJ/P/1
         23VK7JKzg2UPZEMTtJrNrwtKx7yAQHRDAbzpsISRan3tkOXOaSTwJz/sejcFqXSxhthU
         S7xw==
X-Forwarded-Encrypted: i=1; AJvYcCUsptpXTLhzR9KUNpimOYsUgEZMzgf3ae1n16dX5z7ThMICoXqJuzaMFXBz9XyRVOL1xWR4oYfJHg==@kvack.org
X-Gm-Message-State: AOJu0YyzV7UdBZ6HR1go7mj3AOnCX9QAFeybtovB/jOzv3XJ2NaORXwH
	spPe9KXiUrWBf1acScfbftG2fKecBKMVFDn//yBRCM7EoP/PNFwFmqvc
X-Gm-Gg: AY/fxX54sEmED7CR3VccJPESloyHDZ4ePX9taZeADIXDPnNGavOQa5DvXKCak0bUP/Z
	7ehbUNXGQTvmJowJ9P5D3q7sZi483BJljIEM9iNC5lM/wlaFG9nLzgGpJltCBxSpnyunpl+j8II
	VC3CrbQRRlUVW6saNf5rX+XIYr0+nxuovFFHgIs00Vxx5gjdJpz06LdgLQAVSV55H+wGMq/ownj
	vfzTQSifuSzzTwSRTQWJnCEHMUOFbFChHdlyPRfvCi+ciglbVDb36QTiNixuUKqg8f/w3cXLjnY
	kSKe9uM4Aofpke1MRQ5kXSY/vhSUJFjZDSK8McqA2vVvMJ4fwJe8IjO0ewszWbOs6Ddy+007BQy
	T9P6mZOE6EaZEzdqnxkgW4NC4Ampp3J78QBOW/B08oy/QwoHEuMv1spDCs3l7DF4ksPGzG6ZCRI
	Fcx0IUKv4YK6DYqNG0OEM91m26
X-Google-Smtp-Source: AGHT+IEZ/zQHkmzZD5tH7EULcvT2Rbbyog8IW+xRrH5RFccnrCaoGMPZL2CJNEUsgMOip+rJXNFPnQ==
X-Received: by 2002:a05:6a21:33a7:b0:366:1953:1d30 with SMTP id adf61e73a8af0-3898f8f54d1mr5334164637.5.1767867383759;
        Thu, 08 Jan 2026 02:16:23 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:8352:dfa:3b18:eb4e])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3c49299sm73785245ad.42.2026.01.08.02.16.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 02:16:23 -0800 (PST)
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
	bingjiao@google.com
Subject: [PATCH v3 1/3] mm: memory-tiers, numa_emu: enable to create memory tiers using fake numa nodes
Date: Thu,  8 Jan 2026 19:15:33 +0900
Message-ID: <20260108101535.50696-2-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260108101535.50696-1-akinobu.mita@gmail.com>
References: <20260108101535.50696-1-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 015201C0005
X-Rspamd-Server: rspam10
X-Stat-Signature: ssksnxb99baommo84ced8kojweg38933
X-HE-Tag: 1767867384-170503
X-HE-Meta: U2FsdGVkX186xUET86tDN5vAMp6HSPygzWcp8NdRjbNVI5bbzUqcXKOL7ydPbhrG9QSEI+W+gzD3kjZNVWueAZq5gcX7EN+kPhAxoUUT7f9VoU7cB122wMl6tQFhFhpVYevEe+KU+eOtRl4Me24RhY5fHTcvUfaB4jE1AO3mFXC56oE6+X7kg7CFWZmTgL4PkP+Mb50MzfVRmlJpepPLiw+vifodp1nbKU+HQa8uYeHWxkF92ATvZ8LoG68sfJqkr6JWOvCnpnIhro1q34fy1MWnvcd+uQwxmdGYsZSUwl/Xjz07tz/jjqEJ+ZDGgYyJisp8xOi+5adPcxqqs4flPzxYprEwKF37QexrPCuoB1yQYG7zMMrcQnyuyqfwc5rostWA1s4tZGqSMo7OJpxVzWJhefN2P9UeoUa9FOgRguFn2tJABAJK57paEXhusm+znpGOp2dcRbp2Q68oBi/cA423pFgvcLJIo2a1A/muuJxYJQTEdCi7ZTj0KnxlH3pRdyZmM3YY4Q7RRIkrW1azL1omvKkDif7xY4MDJ9++53xB52P8+eq/6qbRqByYoM77qmgD6ZUDQ3u0NSVrQ/jfZXMUfj9XM/YSDrI2eljmnN0jWTzNysk2pQcabQNf+7dZbB+xG54oEHfnp5EJlalpevDb51JrKAbnc8R6CKXFtsZKnZKFT9ukWdn0KsLex12AEnx9TwCiguvgsnlyZBzhvK/4LUcBQ1KEctk6HkCsZVjxpwWbm/Wuh/Md4iAkuoySk2yHVD9efotc1fn7Y/cMd7M8x6oIHY6Okm/oDc6qlTE65ifsP6++ctiMDpJTKOE+iBxU5EhFG+oHVqkz09lg8k6JIEGI5nLpiMpvIjTbdboa4bO1RkODAnd8X0+z9l7C93VglwxzF3C88tJnYFJ6VNTm0FKqy02udBlyQ7ytoCbz0MGdHNFUhlMejSJX7hhLnrK3nB598SIa/2hu3fv
 Rknqg6+A
 915+XkOADzFnUhRK9t1TdkoU3g2XLeDwybkSkkKCvyK4BD/seBcL8WvWw+CmafyTlvJ2N2LAZxcd6t37n5/QgDJJUxwadRkLvleDub1GKvbOVv4JTAe1rU4IB+Helf4EffHr7Q438Wl9MWezYH6Inb7wWl+TC2x3zMb055FD9WyRWLr301g4fupMEJ15JPoxja+/U+4wXg7mxB/Yj+kZNO2dFEsQrmviaJFs1hPjxXK8HTqlhDVO0Nhbohj+HykUg/l7htqNiwTX1PxuFU4Zm8sD7CQGufcGtpymwD9WFqOGBW3MpQXZoyaTyCeFUOsQJJgJWlDtzwTEx/pi1t61qQWZAxJxmlVcDIq0c1Lo4sSS4U+UFSQzPhBD1Nr1C3zpN4g3CzDhKSrBTeTmdrBPAvyMUuER9cJX1SbPArlEbvZ1M75XttUcDP3TrcbIRJu03gXoL1htz4wsnQvmSzNE1o4GcRwB9ukm7Y3Jiur8o3rxs0ATCNfU2MFCmBzemVek/nA08fZOaU98Se4uBHyXANZVJnGLdTBQSHH2oCA97n1ZSFom3FzTwNVyS0Bp9Hhy5E9PDPWkXTZiaN4j5P2uHNb0jflIG70vJIYXiVTI0+xRBSCs+sufkTO2AAILwm2yYAcv+28hwfCt4xDk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This makes it possible to create memory tiers using fake numa nodes
generated by numa emulation.

The "numa_emulation.adistance=" kernel cmdline option allows you to set
the abstract distance for each NUMA node.

For example, you can create two fake nodes, each in a different memory
tier by booting with "numa=fake=2 numa_emulation.adistance=576,704".
Here, the abstract distances of node0 and node1 are set to 576 and 706,
respectively.

Each memory tier covers an abstract distance chunk size of 128. Thus,
nodes with abstract distances between 512 and 639 are classified into the
same memory tier, and nodes with abstract distances between 640 and 767
are classified into the next slower memory tier.

The abstract distance of fake nodes not specified in the parameter will
be the default DRAM abstract distance of 576.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
v2:
- fix the explanation about cmdline parameter in the commit log

 mm/numa_emulation.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/mm/numa_emulation.c b/mm/numa_emulation.c
index 703c8fa05048..a4266da21344 100644
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
@@ -344,6 +347,27 @@ static int __init setup_emu2phys_nid(int *dfl_phys_nid)
 	return max_emu_nid;
 }
 
+static int adistance[MAX_NUMNODES];
+module_param_array(adistance, int, NULL, 0400);
+MODULE_PARM_DESC(adistance, "Abstract distance values for each NUMA node");
+
+static int emu_calculate_adistance(struct notifier_block *self,
+				unsigned long nid, void *data)
+{
+	if (adistance[nid]) {
+		int *adist = data;
+
+		*adist = adistance[nid];
+		return NOTIFY_STOP;
+	}
+	return NOTIFY_OK;
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
@@ -532,6 +556,8 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
 		}
 	}
 
+	register_mt_adistance_algorithm(&emu_adist_nb);
+
 	/* free the copied physical distance table */
 	memblock_free(phys_dist, phys_size);
 	return;
-- 
2.43.0


