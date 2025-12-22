Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C6F7E66886
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 00:49:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08AB46B0089; Sun, 21 Dec 2025 19:49:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 037B06B008A; Sun, 21 Dec 2025 19:49:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E79096B008C; Sun, 21 Dec 2025 19:49:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D56B66B0089
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 19:49:23 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 62593138022
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 00:49:23 +0000 (UTC)
X-FDA: 84245273406.04.CEA7E57
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7F20B20011
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 00:49:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="M2YV9/F3";
	spf=pass (imf13.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766364561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=10vzVgMW/SIAVZiREFQWpaxB2zwT+8w8TEXAc8bNZjs=;
	b=PKhuUU7yVUygZ5A3OLvHELI15yVoIuPalWqDV5de2v7UzPHlVKci2Gt3HTYXHkK4IPDKKl
	wYk0OdXLJ+XxqzEzDSXYRYxTM+HWtk7MrrSbHEPWvybUAEgZXujhdS2QBOGZDf0WsBTHVb
	fOjxWbjwc9DPKHLmumWjEcwhNoFnkk0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="M2YV9/F3";
	spf=pass (imf13.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766364561; a=rsa-sha256;
	cv=none;
	b=ruV5smCZm6AO7AS6JrgJGOOZif1vFTwqNXnPxveZNTx3nOlssS2KwJS1Q/J5i0NU2VUzQg
	AutkYPiCWcdBnwt0z3VU4EOLvG1/3y0pxH3LlB2DkQa34RLm2AeU1xHSculRNLSJU2f0Z1
	k8M9cfTYPVDFfvpUKvzUvpaQuJWDxPk=
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-bfb84c2fe5eso1520558a12.1
        for <linux-mm@kvack.org>; Sun, 21 Dec 2025 16:49:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766364560; x=1766969360; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=10vzVgMW/SIAVZiREFQWpaxB2zwT+8w8TEXAc8bNZjs=;
        b=M2YV9/F372Qtled7YHunuhTAUak/8XNAlx7pqOhyfVot6ao7IqaUGb57++Q68F17Uv
         uROL8tf7l5xdWrYDjFOb4h9G1jNP7Nk+IK4X9vBUEyVB/QieQL8XOpdKbUWgHmKcajh4
         l8Lbc9LlK2P9dT3okuvYMhTjkZm1lpQxQn5daCyA72x88lGwvD8aKQleHObk3mPahGRr
         R8v2OLgL+ajjgVIGeYTU7fwPk0cWEymBEKacnlxYtyj4G1gEqKvLg39NyWfNrub7v+Uq
         NKsdO36PanFLZIy42ICIj+0iQfoIDVgf3tw/Q8HK1Da5VRmZyX3WFFvoyGdUMn8ptvSB
         ep1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766364560; x=1766969360;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=10vzVgMW/SIAVZiREFQWpaxB2zwT+8w8TEXAc8bNZjs=;
        b=uJGQpvIMC+AErG4iRTjUbzLFMH1VHw/XmDEh2FjwlxAloBgE88KOieRbprS2BvBUco
         G9fCwjcVa5nnlCX4w0WqFEwSStjhQY+yhjVavSsW0IK3sLGa0FBURQs7DH8IYZchjPDt
         nWXs/ZIbAdgNTyKyU3sKErl5pdP5IWjGdDxiaWDWK/Ha7HK31pfmRogdFKn39Gf6dtfz
         Z5gsx4J0K2sMOIZKMPfUG5kFMVKGc8FsOu4DTIrVrlp/g68kvgCA9vG28IRBc2+vH1PK
         P2+hZNyk48EyFSbI7a49firtvOU7oWvVk2et98Y4j16MHSvcPTNwcywKrsJKRZ7DQAmE
         /XUg==
X-Forwarded-Encrypted: i=1; AJvYcCU4ktZ+c4WA6s8jjvvXFXdiUq2CBruzZWXycqJdRljiGrh32HcM2DnQX4l0V5afNqoYGdzURwk+oA==@kvack.org
X-Gm-Message-State: AOJu0Yz17x9oayXYoQ/GZrKbnAgm4eXm5zjUNyoMjUP+wcNAWFEot4Xv
	92ul7hORoGUgsuj7RxyvmXNpi29PpcNqTq/y+V7TJmFwZcMI2rxDqf+x
X-Gm-Gg: AY/fxX6yjZ8PxcZxDhR21OnAhThPUloShjCheHIRaPchaaPB0IF3WD4LHCZLxabQD0m
	3FnrSmhQJe+LW1+fGS9FwtvJzUQlk6GAskAvyZEDNGpYMMEe9/W41UzwLnR6Jw0o03tPLPchaIL
	dW30E1fYjNysa6jfwQL2/DnODA5jTWg21ItNfJ3f2CWFBPEJXc1wgOMGTPTnLWqLHpDeh0uZhXB
	emsudFQinDXjtQ+ite9i4f3gJPrU/+ft24Rh2Q4KQ0kmD8o++sNrJeqHX1VBKXy7HOO60PAOzFH
	tqjwuM8aeoyjvFKrqDAY/FhKmP7K4TMlD7RleehuLiFw+3cAYjawoR0lNO0qwDHFzWX33jxftWW
	vFkNKWvJlQY9VAVd9AgYgd1eyLZp7m7KABfx8jknz1zk1a8Wr7v7Qk2QunO63XzsDqBIiKCLwmk
	JU58KdEghhgKujZfKv0B2pfR0soQ==
X-Google-Smtp-Source: AGHT+IGJcxUPthsfQvfgIvDDUW9++z5bU5TtJMiOACtXv5gVSZp4E6tKXbai45W4KorvPXSKizQXDQ==
X-Received: by 2002:a17:90b:3c4d:b0:340:6b6f:4bbf with SMTP id 98e67ed59e1d1-34e71e6a525mr11996986a91.18.1766364560272;
        Sun, 21 Dec 2025 16:49:20 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:df7d:b611:ffaf:6d45])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c1e79620bd3sm7461832a12.4.2025.12.21.16.49.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Dec 2025 16:49:19 -0800 (PST)
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
	surenb@google.com
Subject: [PATCH v2 1/3] mm: memory-tiers, numa_emu: enable to create memory tiers using fake numa nodes
Date: Mon, 22 Dec 2025 09:48:32 +0900
Message-ID: <20251222004834.10539-2-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251222004834.10539-1-akinobu.mita@gmail.com>
References: <20251222004834.10539-1-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3ud4gig9gdpk1fgyqmkcijhay9eykqzg
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7F20B20011
X-HE-Tag: 1766364561-421009
X-HE-Meta: U2FsdGVkX1+7tbOO9VZ8FDhHNDy27qAxkr5RuOjQXQgBshbCgT7Zk+ae3nR8N3LC3N/YN/k2tq2FyPb0HOTGFILmNNwh7tHd5/xzUt8jkwGXmQGqy8zGHhwE+fkX00Ct32X4h8le5y/G/UbawnHUQaN/4qNcWr7zIcZq6ER1PEd4BjH74QEY/Sx4VD3ce10JQJYBeDcvPFIKAV7HLm5Vx8sIa7XsFWjII8gEFLJdTJXeFMDPcaRVhtG7jipwSN3WMvzTd5U7KIorvF1ffxqbxw0Ulu4ol0htVRdZRzLiQ0Z2OAH5z9hjDnMVK4icfkGElbwA4evE4tq7hbGTgtNCbeDlnD5iPiX8uhylYWzklBj9r2SPQnC2GsHaqzrZ+hWGOAza5/uadJhB/DtyCgBXMFjz21KHNFj2s8PZPOXCz/wM+sLtH+ov+GsjWbdg9QlDlcwOYT3wQtH+1Jq5OEtH31M7Eyd7SNXO0GWI539eu29+WRpEw9ZgsJW7t6otuka/9aQaMLU6aX5AXtqF4xSYbXbCV3IE+D0kMQ7eJ9SgWpxaQxp/RIMwGRNhBwv6V9aFx0yHwEa8FRa0CNBAF/4TozexFWvATUiBIkttcarg/E5QOjAGEtgrqemVGPVwh4Dfdn4zyUctDQAOsYQ7WUQrkf45e9VUdFzo95FPyyI1nrJ3DR1MKEY9HFSKHQr+lUag/WUrThGOmw0u0g26ZUGT3Zd1CvLVNMFA5WYuzT9NIP3wG6fr0IJLuVnA/4TpsQCO6CXqdqjwRyTsUcyWmuKFouYAy6zLQ9S5zTPOq1ayTjEg2FNNAT7CEfoRm6TTSlGb/jGLXFhSkIKBWMcRfNCii+dMqfbeLmYMLPBSe3VqnvQ96sw7WpD2kagOEwdPsLRqvc95/JgF6CFKGdYdK+I/agcKamhee2jMhKNKf9UFExq2KCN184mXw36y4EGvTg415R8ovg79L5HvehI40fy
 PU2AHOcp
 3RUs5/Ha4IEMvqY9ioGXl8srUn57tIM4FwURtwswhXMnjBzCU3Bg3iq8ukny/sK5IeMdDc3sW7Mboos2RXUAYm5akeY5Exj6g7M7Pltk6pusewoQU8M2/d1dNKMUcmj7ce1a9YW/gPJrbeclrRCoTtPo9de/4zdIzWI7obYTz8kJiuGlv+BQlM/juwRlM6saEzjTp4Lt2n95NFcCXOPTqSJ0WuRW+nl7rtTjt/PuECK4VoDWx13Ig8IriPGYdIF/no6wYEJhCiU6aQ7Sgv9EXHE/wvFcc1fDkb9K55RJAfXwIVkNPhQXJ6p1hwGQblwAJcmBDg0VAYbXrZfvC/xsf097zC/sUj2QbKvbVvEsO2Y2jlPh7h0OF7DlFi1vy8J4tb8J7OuY3ajWjXqqQTFk5Fw+yhPJD6X80XD/fZVBi1d+BgjIA1LBEylSudv7pj2yUMaz90hvk7kGzKvnmFG5I01g1mFDe26udsUdtjHcb9cx9fgIc8pEib57Fv/SyGPHqaDBEr0u7Ue/lG7S67/1MIaqUr4//gVCiIaovYDobDNr63BZXufQ1k02APq4b74DAFk/D9w8g3BK2lHTZDHoRc50a8NFSgYOv0GMWQQ2q0Wab0LAJX0TUPX9Z9om07AoNt2XjxZs815EuRCA=
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


