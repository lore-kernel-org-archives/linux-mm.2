Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E09F960A2636
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 23:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hqp0ILCS
Received: by kanga.kvack.org (Postfix)
	id 0B1446B05F2; Wed, 11 Nov 2026 18:27:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0898E6B05F3; Wed, 11 Nov 2026 18:27:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F07A36B05F4; Wed, 11 Nov 2026 18:27:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D32C06B05F2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:27:31 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 52FF0120464
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:27:31 +0000 (UTC)
X-FDA: 85424427102.01.0A14ACD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id A200F1C0006
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:27:29 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hqp0ILCS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794439649;
	b=dm3AtP4Tj3WB+PHapJ34a5FjLVG5/FIWeOT8ZKtzQfyphIW5Gmk+Miy9GYTq3H3gaq//Hi
	MWm7Oot/FlSxm8E0xf153CTCLXYY2u9N46w55/b3EoSJvh2UwdEHmuANI4Vtt3uW2gVHe+
	gVl4ln0AsAbNia8g/4/iB7uBcK03f6A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794439649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JZBM3NrWmK4G15j5a9/krNPcLaE3+tRd4nj2PVM6AVE=;
	b=EDHLZ13MgLWmntWGa3cDIbjVBczA3sp9YSQ1CMaYiXHgt8zC5+Y3eMH6WZHzFU5BWGcI58
	9HD7mZOXatLde2Lml5c0EPlvUKk5aNolHnT+P+oMHpJ3JhWIP9HT60Kwn5ECQk9SAY6nSC
	CggS4MUMEzAcsquVcleCCqldY/X9418=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hqp0ILCS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4ECED655CD;
	Wed, 11 Nov 2026 23:27:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43BB31F00A05;
	Wed, 11 Nov 2026 23:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794439649;
	bh=JZBM3NrWmK4G15j5a9/krNPcLaE3+tRd4nj2PVM6AVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hqp0ILCSkA7e2MjVT0OZ12JkedO+01e//c3P/ZYTuS0g33GKczArv2nJjPHtod4Ze
	 WgHQMch5y21GKkJYaNuX+1v23u3KHmwD8R9sGQjBTQXl26M3XGvi2x+apqKGt+KV1V
	 wusgMtJM8sy/tAhu4u+ec+vBai2TY7K8sfoSUBbbF+KFzJ85G/PDSYry2L8Bo2x5pm
	 /v5hOzXCtgMfpkY/r8MRYaW1SWQQhcCgFQwaprGP4RWM/E6bcYqUPhP3c95hlv06Le
	 wW1ESXSeyvuAhYgbZKLK5EuHMf35ZpAPB6iO439oxFxpvoijKSDeH9rSzuIIYafap6
	 REL55T8E3jBvQ==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org
Cc: axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	hannes@cmpxchg.org,
	hui.zhu@linux.dev,
	kasong@tencent.com,
	kunwu.chan@gmail.com,
	liam@infradead.org,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	liuxiang.277@bytedance.com,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	mhocko@suse.com,
	qi.zheng@linux.dev,
	ridong.chen@linux.dev,
	rppt@kernel.org,
	ryncsn@gmail.com,
	shakeel.butt@linux.dev,
	surenb@google.com,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	zhuhui@kylinos.cn,
	sidchintamaneni@gmail.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [PATCH v7 15/16] mm/mglru: Make swappiness=1 file reclaim more aggressive
Date: Thu, 12 Nov 2026 07:26:02 +0800
Message-Id: <20261111232603.9934-16-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261111232603.9934-1-baohua@kernel.org>
References: <20261111232603.9934-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A200F1C0006
X-Rspamd-Server: rspam12
X-Stat-Signature: gwym1bcy3b443faxfw1jg9foc76yta3a
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794439649-611725
X-HE-Meta: U2FsdGVkX1/CSM/nOgN8yC5kCU65niM2IAB7MHbdU94L5wIKWd3u0RPmh6Fy8FVOsHLSRIe+mxO+VpTQUb576gq8en4yI7oYWxWAJN0qXyxnV5qKhysyotbV37apAqZFqMh7XeEZxQTtJPSGFglH43TsvBY/6Myr222MkgfAqQ3Si39mf4PPENbm3Qb6av1mOpxjuuI1GlHBMZC8ccWdcMlCCDaJ7XXT9j4OfykJRw542zJhVZoGeLaaOiO0r1OElIf0o/NZaWD0Jhd3zdvRuE8uZ84nDf7xGPteJ9ye3vjsjLNQZSiKLEK5pZSsgbwIFqiZNrq75sHl/0G4wwk6og7ivm2GfaZkmqXfJAgDEqww9z8Ll9CyvOXE39P6U/FXmO10iGxom2F/OE6UCfCh6sAF0Eu8lyZIVnbPjuWqHXE/6+QYWgTqbT//DRZ8LdAWsVDwyIkNuk+B2RLWqk/U+wR4vChV95mWzP9kdyX2i+Z5H4hrdikzDjjhU+mt9tfRyspqwGSXUtzghbo0on4e3zUtrIYjBUPvCI/0XaORwrINOzNlEiEkkvmNYWh8yBdmzORk4ewE+5GAaLNe4yXPZlAg/+qdEuc8lpGW3DfQSMm3yNUxNfK6gFdtRSZlVeYv1QZLZige+ECbVJSRR6cdMvbmSaGZnRVjdFsz7kNelyZ8Hvh+uqpy2Ylr5GxMr6xdFv61jGM8QB0Dvg2cy3omRrjg+yJWdZQLlFwneIHNbFudZqZLDkI1V7xC9WkhflSIFJPrB4qIMbBcUZPNmu1+yWhXvGAxkzWtTDandL3D0+BOGiFJG6f2ajfP1KE/iFtA2Lb2qC1xTNzSFlXhda6kBHypuP3uZEeBUO7nhAZOobp5uPzoVrzOG0+aFEGHgVOEOY8usyUjkLD1H3ly9FasaB87QO+1TUct0EGMEGVQsr/+92Pd2blyqAZ9zkABg9sogFMr+J3rxzRXVrzlcwj
 qFwU5VIH
 0B9P8XkwxnzlFF1Zy/BZ3JscdrfZjJRCMsebqc/yvHfLWjUwaUyUBmRbRw0v59yodsiS4GeeKlulLIvMKS4KqQ+xchO9AO7AhOOwd66iOmYhFsTnceMFAdakoHiASrH/PLx4geXpdgqLJ9xF3ImCO2CC0xRJW04Ew53QRpLERJq5Bkj/tdqNPIlWVL1Fh8b8lXnvmMijgvA9BklMk4SMoY/z7fK2JZM+7E8EX6H1cMJzoVxapShV5I/5HO85eUvUg1DqgVCg32tYo25bpTC+VW4WH+7qWj70jFm8SEXalptMyr5WPXHkCSz25FyjhuTyMJvx5wG3bsAE1PEqhfnvvhmTCEOeRJLOL+O65ZKBOSW6p0yf9z0HGoBZkLZQUPAsU+0YOcQUyvkOj/t08XkYg5NZtXPV2+S5jgT/WYsgx4PJ3Z7vktdDpPu367jJh+6X/q7w/HOcEz41P7VL9yBHpK+kdiA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

In MGLRU, swappiness=200 favors anon reclaim, while swappiness=1
favors file reclaim. Swappiness=0 allows only file reclaim, while
swappiness=201 allows only anon reclaim. Thus, swappiness=1 and
swappiness=200 are counterparts for file and anon reclaim,
respectively.

Before this patchset, get_type_to_scan() always returned
LRU_GEN_ANON for swappiness=200 and LRU_GEN_FILE for swappiness=1.

For swappiness=200, file_factor is set to 0 at higher reclaim
priorities. Similarly, anon_factor is set to 0 for swappiness=1
at higher reclaim priorities, making the two settings behave
similarly, although the thresholds are slightly different.

This allows file pages to be reclaimed more aggressively and
benefits workloads that prioritize file reclaim by using
swappiness=1.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 3872305bac2a..d51303a5cb67 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4945,7 +4945,11 @@ static void lru_gen_balance_scan(struct lruvec *lruvec, struct scan_control *sc,
 	anon_weight = nr[LRU_GEN_ANON] + nr[LRU_GEN_FILE] / size_bias;
 	file_weight = nr[LRU_GEN_FILE] + nr[LRU_GEN_ANON] / size_bias;
 
-	anon_factor = (u64)swappiness * refault_rate[LRU_GEN_FILE] * anon_weight;
+	if (swappiness == MIN_SWAPPINESS + 1)
+		anon_factor = sc->priority <= DEF_PRIORITY / 2 ?
+			      refault_rate[LRU_GEN_FILE] * anon_weight : 0;
+	else
+		anon_factor = (u64)swappiness * refault_rate[LRU_GEN_FILE] * anon_weight;
 	if (swappiness == MAX_SWAPPINESS)
 		file_factor = sc->priority < DEF_PRIORITY / 2 ?
 			      refault_rate[LRU_GEN_ANON] * file_weight : 0;
-- 
2.34.1


