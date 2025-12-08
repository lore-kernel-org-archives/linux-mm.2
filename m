Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 088A1D3ABEF
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 09:41:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 759026B0008; Mon,  8 Dec 2025 04:41:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7309C6B000A; Mon,  8 Dec 2025 04:41:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66E0F6B000C; Mon,  8 Dec 2025 04:41:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 591EE6B0008
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 04:41:32 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 20461160A23
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 09:41:32 +0000 (UTC)
X-FDA: 84195811224.26.AECBFCF
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3F571140011
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 09:41:30 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GGyfj+4W;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765186890; a=rsa-sha256;
	cv=none;
	b=JrMvGnd6L1LY72DfNjW7dfUhxCyBhtrg+T7/DlQtAY+/virESAcDIPF+co1a1rfUaF1y8C
	Ca6nIUo+hiz7eHvcEKhNC54geHEZGrulgOz9zMZ5xhqpI1KFRlDAsLzW3FAy9/SyxVNMFd
	1ZpFBwODMprwGZasva9zRFTCgm4bKbs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GGyfj+4W;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765186890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bExisJd2rawtEUNYxhwuMVIv9x+cEHj6grigFw1J+tY=;
	b=svS5S+ZGjfkt9McrsIoeHdqLmWPF/gotG3JsT0D9PwizD13LcefAqUQzyvcL9sHJ9R1+PL
	OUEAUOzcabsjDLx8EdezPpS3fMPOozyYkOsETN+1OKhL8vxzh38b5nZ4sl1LOPo0Pc+WyU
	iWXfmkyoGJXVVbl9vRfXgzLGbtmlPP4=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7b9215e55e6so2832911b3a.2
        for <linux-mm@kvack.org>; Mon, 08 Dec 2025 01:41:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765186889; x=1765791689; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bExisJd2rawtEUNYxhwuMVIv9x+cEHj6grigFw1J+tY=;
        b=GGyfj+4WD0sd1oyZNw/CfNeq7nWEpliVFujzYCBb9iO8ziIS+sMQLFBOkYgAmyw0Sc
         3u8v0Fhac/DlTfLRSkv/79Hwk/1Svvan8xQ86nFG/b5c51P9tF/QQSW25r4kU9EK67X8
         65REPHV9TvSgpkNOa2c36u+53C9JigAwvSNCqRt2SdBKKvgSS3MlDXXGWBWStPObnwOT
         xZpEdlnWQk6fO05d3+uuohI01zMVLHppOQ+sGjNVS8ePNzg0tFWAlmqG7xH427jeMerx
         BU9rLZgmmUXsFSJTpThmH7yjzn5GJbUL+9bISX9Zs6XnJ2jFDHMKovqpF7uY84UsLTNM
         /wIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765186889; x=1765791689;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bExisJd2rawtEUNYxhwuMVIv9x+cEHj6grigFw1J+tY=;
        b=c/hJqU0qo9YeNeRZ0CBd3d5zQHK3r0els2OUqC45tvoLpRFTzrg6GnUNPtOegb+3ii
         KqFE4AvanteZhtP/s/J1A/qevgFxidQIycNsROnKx37xvwpJ4b7RWEmJwVHQNNqUOGx+
         qMBQPNEGnyQVBp0eDH21pEoFDe/LH356NdK1LtCXhyRgQ0pEb0Q6byxau2WjV2JDXKjb
         D4QGflTWCnXxwiT612O+1/u7likZn1rOU+RztJw1LT/TiShJXVDR6qVX2jjPW5xCbBZe
         rOfKMwAOIUcJAgnG+RZcQcIgCiwxLtsfD/eccIsqCV80+Cthks60BCpXbsF5snyLakvL
         BIsw==
X-Forwarded-Encrypted: i=1; AJvYcCVKEHV7ke1VyBIZT1F30ws9fZszcSF6H9/vJmUpFMVFoHcV4vSCw7k6IYtxLRIPCysDRCnbIvmNfw==@kvack.org
X-Gm-Message-State: AOJu0YzUVOL70mhKS4puXaNSWUtNLKo+HDco697SUPNVhW1gto6YMVt4
	ztkFg1H0fXidBYGdgV1blmv7vDxf1K5FT2eWiR2PrpIK4QX/xzw8yOzj
X-Gm-Gg: ASbGncuOiwZQVsXsN4mxdUFYLqtOLQ4orXTmFR+cgan/V1HKwQUNpJ7HRu2ugVSczhx
	6S4lCK1QWPB9YxCikbIznLS7jIuWFutwbKLfYnLgLD2wgf56zqGj3BASlLan7Kqwp3aHwHpOjXC
	Qi6+g8OBDWOGIghD48lDyeDq/wyYkJ1VGTpJkDThGuaZXflFYp/CyYzn5kKALn+gwZN0bPBMpMF
	yW4IriBviFAba485ZRLeMFZCtWoUS83+7oBaDrkLMSJaCW2sMVVHVUTRKLInS8n+67IWnZHaqHV
	geG5iPTRJJLfulBD9N69gsHhgU6CbItGC4r2Og/DdoZS4iCNPvs6w7RTo+O/Hek0pVLp2IjygAn
	p6SFa50oj69+EFWNGXKXYtwPn12/3bjaS8WTAgi8KNNKzyh7Td5C44iI56ODLT8v0QUQsCLEzTj
	Xe21ZBtDaopdmdo2UyOBx20WZe
X-Google-Smtp-Source: AGHT+IFqvRUGIwFEaNgQfl/NTg1cwY2IZM60Uy8TIHC22S07N4FVSlZj92GMWE1sIDQ0qozblkpCYw==
X-Received: by 2002:a05:6a20:ed0f:20b0:366:1e42:630 with SMTP id adf61e73a8af0-3661e420638mr4892693637.1.1765186889147;
        Mon, 08 Dec 2025 01:41:29 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:e251:d9f:c2ef:caf4])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bf6a36bbc60sm11675279a12.36.2025.12.08.01.41.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Dec 2025 01:41:28 -0800 (PST)
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
Subject: [PATCH 2/2] mm/vmscan: don't demote if there is not enough free memory in the lower memory tier
Date: Mon,  8 Dec 2025 18:40:28 +0900
Message-ID: <20251208094028.214949-3-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251208094028.214949-1-akinobu.mita@gmail.com>
References: <20251208094028.214949-1-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3F571140011
X-Stat-Signature: 9d6juhabnw84o6jiw8sj3mrkhhuqkgp6
X-Rspam-User: 
X-HE-Tag: 1765186890-766652
X-HE-Meta: U2FsdGVkX1+SYBpwFyx4qI3KKBKVbrUeTrjy+61ffyZLZyD6Rx6hjycgSMwRYXWq5y2RanZsMOR3jL/Aw+gOWTxezc78YMuAjMWd7VYPBppeoplyHh5xovPAGsZvu0RaGX8WpTVxFGW9UIZ2/7M9gFb5qGV6BO8aIILHRRDXOVq3fOgQEwEqT6CGQsOS44Jg10A0PX8pZqv++VJdUek+hFvTr93vq9yU90dY1YfJ31O5LNV8tyTe0sqJ6OK44hW9XuXYN1OmBOwYaelPDp0hhquu5OcnhRJOl61HJPXVneQL/6U9aqdogAbGaLAxKAsCyCttxOftwDbXkueHuXjxKzaJyrV3/4teVEMB0d8/W5SOqVP8pW1qsCfxfHQMV5vvwSEiQt/Yx3S3h8wuuquNHuXOxoeiV0Zb8Aizaznedt18gEeY7cVFAKCqG14VRSMQeGJNvjJAMMK7o/LCwf00NIkTAdrYSzsDTV/9vD6l4+8HmjT33smTB0a7E2Tfx5amigPb5WL01AOLmFmNfxOfSS++pCQLheJ6SaemHg3fzgGoCnhA+KgDRP23OEgdeFSFeJxABgxgBSmUYkqXfrOuqrlvdMtKWpIsE4qIDUeLdgpL7frKtj+SiVReEs4TF75OHhyOGq1qnxDFv5eVNfEcaj75yoEqbdtNNTXEbEEkNL3Kt77wZD3wPS7/FlzAyXla5ScRos+jsozqPbyVGA0tSW4O0zV7WatkUGvpgmnRigcWtqc8Ch8ZVxHddsI5gXdbliR8K5TOqvIlhnDqW4MQQ2+x82vsuLk8ht3voeoiv/vf0qfZGtoKx/qRmjtSy/ATUXyqtyWktO3vA4H0Id46Io1I8e2cKQDb6jEBQ6MTjmOgK6R47Cr53Pu12xvbbkHJ6ihwhkJTFz81oJAm2AS+VqqGPbXcxQZ9q3JYYa0Mm9k2BTXsrLQm0lrajm0mzXuGghl8ofD2uqOVZ9PQjgu
 jRwQ6uqc
 wYhua5J9BjTCvjROcEzvy5j1eigx5GTi+V3AYywYiWtwRTMO7Frnxr+ngEbP4brJtFh63oLZAAxZb/aA/oqygbYBzJeIM/xTbKTKfu+n9uSx2RehvnRtLZJJZSQvoh7Nrv8izCkK7MlK9008IAN1mO4TCkkGjXPnnkkmw4lh3HVoLr271Ga6FuSNbaTvA1ZIRqspjdmW7PwHad9tIBhL6tiL6H/3oeW4zua99ikP/iREvJOM+7YelyFR9DMHOOGJ1OBu4kZ8UTGj7oFchfLIsrcFYE1IS3frC8b+7anAQZ8vZXEQ6IUYFxNQktJp0HptkOEt5u9BcOOfl5c0Mv29XD+LU8K+aBVCegfM0IU9KZMjToNkjDSI8rd9VAwU0zCAtze2Xj2N4g6vZL8bUzSGrec7uqgysGPDHepXH69sQtq8kBT1S+8hurDT+qKQw/Vy/OfhfjBnFADoAfZMWB7SV+43mnPfYHJbyWgYUofIeE3sby1BLs+GYsHv1DulwAoeVIy9AIo8A5Yf7SPeLG6YEusgpVqmd+IrhYuCN7iqFB72OkGkz0hkYVzNStA==
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

$ sudo swapoff -a
$ stress-ng --oomable -v --memrate 20 --memrate-bytes 10G \
    --memrate-rd-mbs 1 --memrate-wr-mbs 1

The memory usage is the number of workers specified with the --memrate
option multiplied by the buffer size specified with the --memrate-bytes
option, so please adjust it so that it exceeds the total size of the
installed DRAM and CXL memory.

If swap is disabled, you can usually expect the OOM killer to terminate
the stress-ng process when memory usage approaches the installed memory
size.

However, if multiple memory-tiers exist (multiple
/sys/devices/virtual/memory_tiering/memory_tier<N> directories exist),
and /sys/kernel/mm/numa/demotion_enabled is true and
/sys/kernel/mm/lru_gen/min_ttl_ms is 0, the OOM killer will not be invoked
and the system will become inoperable.

This issue can be reproduced using NUMA emulation even on systems with
only DRAM.  You can create two-fake memory-tiers by booting a single-node
system with "numa=fake=2 numa_emulation.adistance=576,704" kernel
parameters.

The reason for this issue is that if the target node for allocation has
an underlying memory tier, it is always assumed that it can be reclaimed
via demotion.

So this change avoids this issue by not attempting to demote if the
demoting node has less free memory than the minimum watermark.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 mm/vmscan.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index fddd168a9737..f4748f258294 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -356,7 +356,20 @@ static bool can_demote(int nid, struct scan_control *sc,
 		return false;
 
 	/* If demotion node isn't in the cgroup's mems_allowed, fall back */
-	return mem_cgroup_node_allowed(memcg, demotion_nid);
+	if (mem_cgroup_node_allowed(memcg, demotion_nid)) {
+		int z;
+		struct zone *zone;
+		struct pglist_data *pgdat = NODE_DATA(demotion_nid);
+		unsigned int highest_zoneidx = sc ? sc->reclaim_idx : MAX_NR_ZONES - 1;
+		int order = sc ? sc->order : 0;
+
+		for_each_managed_zone_pgdat(zone, pgdat, z, highest_zoneidx) {
+			if (zone_watermark_ok(zone, order, min_wmark_pages(zone),
+						highest_zoneidx, 0))
+				return true;
+		}
+	}
+	return false;
 }
 
 static inline bool can_reclaim_anon_pages(struct mem_cgroup *memcg,
-- 
2.43.0


