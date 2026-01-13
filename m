Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16AEFD29DE0
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 08:15:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71A0C6B0005; Tue, 13 Jan 2026 03:15:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C7986B0089; Tue, 13 Jan 2026 03:15:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 572B56B008A; Tue, 13 Jan 2026 03:15:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 459566B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 03:15:33 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D9C881601E1
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 08:15:32 +0000 (UTC)
X-FDA: 84326231304.29.EA436F2
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0D9AA18000A
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 08:15:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PAn2v1uM;
	spf=pass (imf24.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768292131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PwTnQsuEWMmzKeRtMHdsKcZZ3Am1ZXUylBtZW2knjDQ=;
	b=4QuEEjDIf+l6nNmjZfAAewF7AoKaLO/+wKuz4XAP5md262LskeNyB0x5y7LEFJZPuDl6lo
	mzxyCtHjhnI5lWqmhnZkJQhcCM6hH45UXVdNvLSc48a8kGu4Xyd1LnHXBrbb7PD8Os0zmj
	HWIgUif7IysuLGIefEbC70d++KHb/lU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PAn2v1uM;
	spf=pass (imf24.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768292131; a=rsa-sha256;
	cv=none;
	b=WRDvO5/XgpfRxhD1ZLtI2tha7OxbSNakFM68PvTxVLsgtJnfdVTczhDdfqAk3cK9uAmQLS
	c+AR+xz8+tpq6g9H7fWIw6/S8tCyoUdlZDrijU3FAZ3YDohMGDCmImsR0zjXEBQSQ36sjv
	M/uq71h+wznk6Fv+xvo2X37XI2ahcpk=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-34c84ec3b6eso6629142a91.3
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 00:15:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768292130; x=1768896930; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PwTnQsuEWMmzKeRtMHdsKcZZ3Am1ZXUylBtZW2knjDQ=;
        b=PAn2v1uMC28q+7Wy0jvIebNpsUAQvVIl/NFypcF0jmjSjz+uonQ+KhUZ7ryhmyodhg
         0943/UgA7SoPRwd81odaTeyZ63Op7WG2chav8ZcBIAODIQwAKOIcGug2ut4kUGPH+SMg
         UjYPZP49ixAR0YeGAFZdkpnSBFkYA9J5ngGZ4c6uTjdd+0J7tqDiNTBCwo28rKXotIZ6
         shwNffkgvxPXdEjY7xEAFXCsyM5VLlWYBLc07yLt4BKqrVjEDq1ZX9fCaEx5FfGtNRBd
         rNQcS6yvYBDt00/goEbOy7veG5TvkgLfhFkWSEN3L6rpPSEvGxMNuY8gJXzIsubjp1di
         SyDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768292130; x=1768896930;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PwTnQsuEWMmzKeRtMHdsKcZZ3Am1ZXUylBtZW2knjDQ=;
        b=Q0NLeV1RltWSHFsQ8tHHJMcCL4VoKeitddpITFyNrSuH/EcfbTLhf3dfxDWREFDPBe
         JLijLJL3daIB6uwQ16xlKuhPctLHxKAEuksuIDcxG0MymcJ6kcbbrdEXO486IjlLhDoo
         emTf39v/EEuDwumLWE4ycnLq6fV9tAVxI6pQV6iT65Ze5bW6+ez0q/YcG4Z7PMiArNDA
         t+17MrZJeyE+ACSjYVL9OHblW8OLkrAKTjwhHaqQcgQ1owMEBUlcDj6op80FTOV2kIaT
         4juvXlQkMmMKhBYSV2BXhsGeXpFWcnTC8JQAjMSmueIbj9jFnPjx3AX9nmb1OmenC2tF
         Bb8A==
X-Forwarded-Encrypted: i=1; AJvYcCU63hM6SFJ2h/HKouvVpppoJE9B2UmcI6B3wS1Mq4572hIi1kr2y+hbj5s1OIigQ/tOMj6CwQdo5w==@kvack.org
X-Gm-Message-State: AOJu0Yw8ksQI5ljhSfjN8Xi3ajhcwNJVzWCFzDAgPvOMEQhwHU4QYyHU
	EKxr5edZiMBEFoBYnn9fWkFWrzkadnVa/A1zbSVNBRVr+7CzDgpkK8tA
X-Gm-Gg: AY/fxX5XkkvwJla3OOVlfOtsakZ/VZamIezeiz30Y0yOwPqPwTipf9O+0xfnfzTmdXq
	QvInEoQtAU7zbdTLEbpCeGfMqhk+H6ALh16JnqEa+kg8uTMgOfzBodVpkoizxNyC4idkkONIJbu
	Kcdqqz0Bz7MnV3NoayNd/t/LbRHotOURPNyqsuqB7Ri5dBLMD45SE/HsdzcwjsVMjen4SeC8xqL
	jCD8Po/iu9q0DgsYPS/cWP00GxOeOX55ca/UirxXDIru71ifWXoM7gDjTlyQ9nTa2blYOkxDO9x
	zVVCSyX4VV242JKdkwbgrVuRfmzt83hK5pXOZykfVwgKjfLeG9OZTiXqvZrvWdNqyNhYW9zWlrM
	CUQwXiTHZVNYhbLQP2lyQOg9KWQ1XoKT95xEGNiVHsFDBkr3vov6XW3Xhm6pa8xf9E83xPAVndd
	0n0Am9IsT29XhkOLUS7XSaOUt9fA==
X-Google-Smtp-Source: AGHT+IGyoLWqkhk6HNGdCwYOoM3jG2DoR/KQRVZcJr9YqWUTu1tHClglXbICbAvlyxhP0k0QSxD03g==
X-Received: by 2002:a17:90b:3941:b0:34c:253d:581d with SMTP id 98e67ed59e1d1-34f68c4cc61mr17622637a91.9.1768292129845;
        Tue, 13 Jan 2026 00:15:29 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:180a:3788:c683:2f64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-350ff05492dsm657199a91.3.2026.01.13.00.15.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 00:15:29 -0800 (PST)
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
Subject: [PATCH v4 1/3] mm: memory-tiers, numa_emu: enable to create memory tiers using fake numa nodes
Date: Tue, 13 Jan 2026 17:14:51 +0900
Message-ID: <20260113081453.8293-2-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260113081453.8293-1-akinobu.mita@gmail.com>
References: <20260113081453.8293-1-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0D9AA18000A
X-Stat-Signature: uo4kahqcwe5du4mtfyr93ghz3uuybsuk
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768292130-870153
X-HE-Meta: U2FsdGVkX1/aoOuEP8Z9sEzQwXuyENFYX8ruNY0ZcvNBec12rZ5ldod1gK8HcOkdGeTu0PbWeX8SERj21p5kBiQjfn8ifC29m8APF6F61Qeuxc9gj9Dc3VD5UpuaT2bMWxCGdcKIXxIDOPq1EgQb9QrAOCwJ5JMKXbGQry9NmvQxWLvswx4YTmngzrps7MzHAvLPP8jcw9gpYxI3DvH06CsQcSvkpfhJXWjQpXg0uZ2M19ZH5Z5QAbQ0g6XUAnD667KjlQfOXw6OaQVSuAbE2KCInNkI+7b2HhCa2uvEubl2aHABeZQrDAYG7W9b+sBi6xW4VcngNws0Xn1zZSjiE5mFdt4tr2v5HQLSyPC4gqkLzFB20wryr2vUHZeWQoKxH+6NB9DnqxsQ1qjLQex0bTa/HEYPDQlRlAPBUkYIoCxgvcXSIGANuXR001x/rYDRUPNGby+44k61uLvt60QfDdum8iM1myOeCGBAIACdCJxYZwdOIcmjPGKbiYo8NdmY25Ly37iRETHwm/ENe10wIPII7mfh/dusEcxwVLtgqQN7HBXtYdbK8M0tiW3j/rUduQ+wMF8NGmfj6z1XLhtDvJ8GM7xMn8kQ1tss8/3s/MZVfKMvsW/Z9I2SsMVNaQ6iOMqRUy2HHunednP2855xO09vcydPYZ6LNhG2+uiFGKBmq0Qi1bpgahZL1u6OaT2T4wHQioFVkM+Vl82aasT8Kxwo7kvBOfLiLL59MdFhGw5wtA0zx1dGxkPiz7jOfN268l7vyaIIIeNnnmcBJfv/kuG00fiMSNXruJ4z0WL1OCNO79aYzuJDP/vdQSw5hfOD522l63/AJXKENEZd+42pZOUCKdxXCzLsl6XVetTiijvlHahWhCghfRACUlnVILz2hon3S4jpDIEuiKvo4cwUKWNq4ruM02Ffd9+USoPpRYnpFZzoEZNKdwwqlM5VaFsuBeLjCyEZAsHAyfM7xED
 Z9QCt/gA
 32e86vatpQhXi9eGP6xZugyH/XgJXZ0f3b6NHr+S1KHBAhJi1LlLUCaGf7lbF5AlfXz5qj3wt1XRQ+S1UymX4uQix9LXbkV5PIe/giVu476GwvuHjgiorxngdif0Ent1wEjpcn+F/z96Xydk8kA60rAVUoY2OZ8OeaLemSOLIKafZIl9kiu7eFN4xku66JRpRZqkQXfti2sg/9urhktjZIA6fx2D3a2+Fvd3IOJGY0KRK1T+HKN7OP3Mq0hh9hGL54tkKqn2iiMfh+OAMBsu3B8ifHQKcpsBIItzmUPB8P25vXpeGaRDH/gCx7Hnrn82HL7Jtl3b+OQSwHnB8FQtmzWBYtxU1504lOGaotDkouB+g8IPDcbWwbiiB6MfLwEkmkHVnJiduwVPByTigK+VcUI2n9ewdO5L9eHyeOkOHmUf9xeVmuunb2W2NgdD98qKFjh/5LDTOnWTUCcPBuN+OEzMV8gsZn81ZL0d0OOUxtsxe4xawPlDZJ63Fe3L5bWBi7DcLbynbbpN23hlxB7jPXp6ax8S44LPYYtQ0q8ZiJZJta1u+YFOG/M6kqfJI7veuoGTZSBqu4r0/B6ya+WvjqbQl1Vp7JAaXsFmjoXNU+vTc/XE5Z75+QVsBWz1B8fOE4hPW
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
Here, the abstract distances of node0 and node1 are set to 576 and 704,
respectively.

Each memory tier covers an abstract distance chunk size of 128.  Thus,
nodes with abstract distances between 512 and 639 are classified into the
same memory tier, and nodes with abstract distances between 640 and 767
are classified into the next slower memory tier.

The abstract distance of fake nodes not specified in the parameter will be
the default DRAM abstract distance of 576.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
v4:
- remove unnecessary include of linux/node.h, suggested by Jonathan Cameron
- include linux/notifier.h for the notifier_block, suggested by Jonathan Cameron
- typo in abstruct distance value in the commit log

v2:
- fix the explanation about cmdline parameter in the commit log

 mm/numa_emulation.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/mm/numa_emulation.c b/mm/numa_emulation.c
index 703c8fa05048..2d05e61570cc 100644
--- a/mm/numa_emulation.c
+++ b/mm/numa_emulation.c
@@ -6,6 +6,9 @@
 #include <linux/errno.h>
 #include <linux/topology.h>
 #include <linux/memblock.h>
+#include <linux/memory-tiers.h>
+#include <linux/module.h>
+#include <linux/notifier.h>
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


