Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B85B606A329
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=gdoP8LND
Received: by kanga.kvack.org (Postfix)
	id AAA3D6B05E7; Tue,  3 Nov 2026 03:12:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A81A76B05E8; Tue,  3 Nov 2026 03:12:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 998A26B05E9; Tue,  3 Nov 2026 03:12:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7691C6B05E7
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:12:44 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 057A94035D
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:12:44 +0000 (UTC)
X-FDA: 85393091448.13.9AC1580
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf04.hostedemail.com (Postfix) with ESMTP id 68E5740003
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:12:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=gdoP8LND;
	spf=pass (imf04.hostedemail.com: domain of xiqi5703@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=xiqi5703@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793693561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=vJHelf8yRuovwrqUmX6IiAQ6WiqwwkheFHbp4XKwlVQ=;
	b=iQB9jIM4kObTc4drTS4aHfToVHhItUeO2rZSeV21d5OP7ipAwiwUKEvMumWrs2cgIFXdAN
	Uup3bIPehyLvqmt+iUX0pdLEst9OlcEXA1rBVrg5dQc4msCpTEcgnH3rip44FmrNLQ7SR5
	R68k3NGOeij/r2TYLEiuGsdNZOAARXE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793693561;
	b=SP3rN9JdvP2KNAxnN9smls6+UcB+kKb4SjTLOMA7hOvaM/4dPJyPhbckDs82BrmyLQv0c9
	GfGk3D6nqiifclDZzIs2vB/4NmaxwFqZGqGQqyNlB68IuhHFH+fA7Qb66PYuawd/xOVPUJ
	J8eVkHVOtTtBm+riHVG9nRvUyXeotws=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=gdoP8LND;
	spf=pass (imf04.hostedemail.com: domain of xiqi5703@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=xiqi5703@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=vJ
	Helf8yRuovwrqUmX6IiAQ6WiqwwkheFHbp4XKwlVQ=; b=gdoP8LNDIyPJ5KMpBt
	R5Bg1FkLSV+Wwf2FEWxVn+kfIz3YnItvgY62xltuIVNhab6zYtFBvfgIHaSFe7wd
	/8D+VtqZhTSLLg+hTiBxEUaO7PRs3G2tUew7zc8AX+JNrX/pUUiaN4mVdMF82fL/
	/BT/OasCbj0Rdaw3IfD1+n63A=
Received: from mm (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wDn93dYl+lqnSU_Eg--.1168S2;
	Tue, 03 Nov 2026 16:12:10 +0800 (CST)
From: Qi Xi <xiqi5703@163.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: linux-mm@kvack.org,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Qiliang Yuan <odys.yuan@gmail.com>,
	linux-kernel@vger.kernel.org,
	wangkefeng.wang@huawei.com,
	sunnanyong@huawei.com,
	xiqi2@huawei.com,
	stable@vger.kernel.org
Subject: [PATCH v2] mm/migrate: fix softlockup in do_pages_stat() with huge page arrays
Date: Tue,  3 Nov 2026 16:05:57 +0800
Message-ID: <20261103080557.1632382-1-xiqi5703@163.com>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDn93dYl+lqnSU_Eg--.1168S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7uw1UZw1DCrWDtFy3tw4fKrg_yoW8Gry5pF
	Z3X3y8KFyrKrWxC3WavFyvkFy7Z3sxGF4SyF1kJ34Sy3ZxJF4ak34fZ34agrW5tFySyF4S
	qr4qk34vy3yY9aUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jcXo7UUUUU=
X-CM-SenderInfo: 50ltxkqxqtqiywtou0bp/xtbC7RsRR2rpl1t1BAAA3e
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 68E5740003
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: jrkwauscy3jmwdddpbszpxcs4ggwzw4j
X-Rspam-User: 
X-HE-Tag: 1793693559-788032
X-HE-Meta: U2FsdGVkX1+FRcE5cxW/rCI+nY0vD9xbdc6WLPbc/7jM79/wffmKqypKTHwbZFu60WoQjMlQzE+9GJtOkyMyjhCnHJxYClZfoofns2Vz8jCci/o3kKHOroatsIMtuHVQpfbzuSYOgimHomaqWqhL7XMPIHvUN/2YUyjcYKIvtytk4rUSlfQ9wBeCwIObq4Ft2mF40fPnJacWMBhNcLLvYrACRuybTZNQ5YYlK6UUuU8g7YIqasIpWNkLriXw9OdT58ZkaINDGxenwCbdCnFNtTST86PosR/+BLYon2asKzztXZa0m9c0EsPS2+qhqpcTplN4peYwz8wX3TfpXONvnDBU1TctF6ybIMJjSM7N0gF9zFdO+YiOJPhzxw8+VYqMadG9d7GUbNe+Ow4KTeOJdz9MCckSUwCfTKBUnOCqMYE/yAcknMqZJgR2sANMik5GwugPUGWSQqgA4cCsH4IeYn9VQEIVbpBcWMcKWjrB64Fwj/PLTzJ8X2HV3bEP44xP95gX1ofSeOyOgXyJvunHZ1N9QgH3VZjARJTlkSC3zk/0naK5Hrqkn2ZSKInPUNy7HnoJnaaqyJ1rk5VE3vlxI9CiR2jVdB1gxQphdfug9I3Zr6vVVsajor1sNFmVcbZycM9tteAtXrLRaQhRr1KiOuCRfzQEeB5ABN4WoVsm9T1Zxj8Gc74hS2KZKAnw4gC9ODKCzjp3K+DBvhZ36Xhdz22B0/1Xp4Ge2Oj7A7aspJF0B1J3mY4YW5GbXh3JTL9KR9hKCaanw+9NXZYCWlJjsLxDwsjL4Sjpf9e/xBZuZhEJbWhNYoaqOeD7LeU3d70gYVNqsHeQ6GAegCj/lfgzZkkvjD8Z9jswshwU4pProkzsagcBMiGb+6Ig1q73XcwYAC7N1g4hcb+TNPbceJjC6jnpxCx2SUS/4ViYWzYmevycWlHB29lmx+1YQMv5f19HpX+8PG7SfatMlj7/s0T
 zi+yOvmH
 MtHY4ZrlEbbVW23tcwPWMDyy3TBCUwtBNOc50BuGm7DDmjrYnqzTRUtwIAxDvp1TSmEQdjk0pVIiYDJd+JnI5r5GRTq7G7is/ibqIKd+EzXG4XUUz5evPEat/XMpnxdu3wRs+1G2ei1J6MalG0oDLqqhybIxzZLW3Z2F6NLHHglSmV7PU9OAlMqbVLkdr78gDS07ZN7Kiz7t/Kvkt4I0wiv5e3PZsS8rYPqity2HIht4yYvp9j+ra4xWuqccC0/GGmWdxOy0LJ5BvkapASYSIBlkXYt00ZKm/OMrnKIy99/HpGKSoGAHBXHKVlQMx5nuFxWeDxazT5Wy7Xn8f06lu73rxFyPbGHFwfbtgEgkf6/AypgI9mAEBriSzKtfftzXqsR/KhpUNxmeznbaT+uETxd6ye1xR3bggohJq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Qi Xi <xiqi2@huawei.com>

do_pages_stat() walks the user page array in 16-page chunks but never
reschedules, so a huge nr_pages can hold a CPU past the watchdog
threshold on non-preemptible kernels.  Add cond_resched() to the loop so
long move_pages() node-query calls yield periodically.

With KASAN and function tracing enabled, a move_pages() node query
(nodes == NULL) over 10 million page entries (~40GB of mapped memory)
reproduces the softlockup on a 6.6-based arm64 kernel with
CONFIG_PREEMPT_NONE=y.

In current mainline, only alpha, hexagon and classic m68k can still
select PREEMPT_NONE; stable kernels older than v7.0 still allow it, so
the fix mainly targets pre-v7.0 stable users.

Fixes: 80bba1290ab5 ("mm: no get_user/put_user while holding mmap_sem in do_pages_stat?")
Cc: <stable@vger.kernel.org>
Signed-off-by: Qi Xi <xiqi2@huawei.com>
---
v1 -> v2: describe the repro environment; add Cc stable; no code change.

 mm/migrate.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/migrate.c b/mm/migrate.c
index 7bdcdb57652f..6c2371020cc5 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2545,6 +2545,7 @@ static int do_pages_stat(struct mm_struct *mm, unsigned long nr_pages,
 
 		chunk_offset += chunk_nr;
 		nr_pages -= chunk_nr;
+		cond_resched();
 	}
 	return nr_pages ? -EFAULT : 0;
 }
-- 
2.53.0


