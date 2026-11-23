Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18D79606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 05:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=eSpaTiOJ
Received: by kanga.kvack.org (Postfix)
	id 2CBF56B05B7; Mon, 23 Nov 2026 00:51:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A51D6B05B8; Mon, 23 Nov 2026 00:51:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BAA46B05B9; Mon, 23 Nov 2026 00:51:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F1B666B05B7
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 00:51:18 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 859A380787
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:51:18 +0000 (UTC)
X-FDA: 85465311036.13.4A544C5
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	by imf02.hostedemail.com (Postfix) with ESMTP id 070498000A
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:51:15 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=eSpaTiOJ;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf02.hostedemail.com: domain of wangxuewen_ky@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=wangxuewen_ky@163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795413076;
	b=VMdpmkIzDQY4eNEAgPRXorK82gK2PyYu2KFQR9G7/ch6WotW+ted7hLD4JgpffLfQaKRG3
	+OkDDMvwgjRSDvBx/1KRobaHPu/rd239S+5/QftdIuTBzqnjPQThcDFWAvsn4koLBeYwMF
	lAPUA8W8/ocgmpkj0l0X1caKZj39sQM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795413076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DsK0EuNffUEDXOYmo8ofwWgoqNSo1CY+qYxqNoTzfBo=;
	b=n2IoZwzwltNCZu/V1Ax7GuwS1jHLFjhLEo8rg/7yvg355BQBSmejId/KiZQ7LXMk+WM6gF
	1dPkA2KxZk5ZWwHSummTpcj42nu1gWbyQoMGhy3RFqO4eyacup/LIcdbDu7k7ilBH+snlH
	BLSAizVBudLOVlkcemlew9f8dh9pUsk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=eSpaTiOJ;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf02.hostedemail.com: domain of wangxuewen_ky@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=wangxuewen_ky@163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Ds
	K0EuNffUEDXOYmo8ofwWgoqNSo1CY+qYxqNoTzfBo=; b=eSpaTiOJmVNVKg0pex
	5mBDcWIRF3hpakeOqSExSvV0XllNfZfg72n7/bWhD5E5B0jW7kR6fFFUp54mwRNH
	8Nck5HJfdq57wJbG1Ty5ggAx1G0/cP91spBDP36lwc/OhWtWy0w5hfbtfIUi1QCz
	8qYHRa1U/fk8cBbZ/rq3bPuMc=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wDnL+Ix1ANrvVl9JA--.60204S2;
	Mon, 23 Nov 2026 13:50:41 +0800 (CST)
From: Xuewen Wang <wangxuewen_ky@163.com>
To: akpm@linux-foundation.org,
	david@fromorbit.com,
	qi.zheng@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Xuewen Wang <wangxuewen@kylinos.cn>
Subject: [PATCH v2] mm: shrinker: stop counting when the seq buffer overflows
Date: Mon, 23 Nov 2026 13:50:20 +0800
Message-Id: <20261123055020.287151-1-wangxuewen_ky@163.com>
X-Mailer: git-send-email 2.25.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnL+Ix1ANrvVl9JA--.60204S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7CFWrCFWxZFyUKF48Zr43Jrb_yoW8uF47pF
	Z8Ga9rta1kZw15Wwsaya1fXa4fZFWFy3y5WFnYv3y5JFWfX3WSqryfGa4YgF48C395J342
	vr45Ka4Uua4UZFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jJxhdUUUUU=
X-CM-SenderInfo: pzdqw5pxhzv0xbn1qiywtou0bp/xtbC7xLcxWsD1DLClQAA39
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 070498000A
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: q95xa8zri31r91jehpei51o6j4gf3zyd
X-HE-Tag: 1795413075-683760
X-HE-Meta: U2FsdGVkX1/9bgrjI6MbV/hLrd4dWSz3zied7e0mmpbuWi/vuQdaQzuYL2Gvf8fklx0mez9xLASx2PgWIFfguYrxxz1F7VBL1ZL1KbDpnSXiRWoJitbBO9ginMjzfyzaUdVM9tn7CgWYC5aJ88FscqZkVQ9RpMYoHH+jQjeI+nzBQd2bqiS5nF78PpW48dV6MuhF6tYx3LykesVP+PM7NVkbYx7OD/EVwJHSLtA1SS91GruWFR14hw+FurPHzuNbSAqEUun8zuwGZxgNXIg6QxQAs0pzHHXnpH53GvtZG3JQW3rXfkL5zNZEcJ78is1Oxc4iF002mYlXm3LuNmfDKEewQbKdDDftqKh/MhOKWfI2UFbEN6gTpHW2Mh2eBsFtnWStFMkQ7U2fS5VAQKfKjHDoSvigtssDc+FMcOH3uFNpI+GM+UGgsjv6Zkf9Xd2aQenHBACTIo/E8zMZonq7eJAsNGlO1BJgSXJSmaaNqdektsHZWav+Q3rQG/1z5vy7oeU6AW0ogsc6F5xz2J5VE09kGBZPMQ/BAqVvT1UVIIkGZ039lsbX5Se871p+OIjFZfSmwkqffRZAZQDBkuedvi5pTQZc/V7OBTyFFeanMlvXTNWHF7pE76rg1PR/JFh7GGBoDzzsIcCxpK7ic8O/DgqVeyAQE8jm9kZXYx1zH92q608DtT8M1cCIMz7/16oNcvu7+6B2aYoBWKSsmnM33YJuLtSdxmE6wxwJNRjKTbS6/0VFqW609oes2sq6ZbOgvs5Fk3mIYpESLBf2j3Qdb6LGzQc6j2faiXU9mS2jYHt8PuqUpbmRtd0YRNdCWHbC7JotT5x/w0glMhPSvHAyHxfMuO9Fg09EdgMZ6PDNxQLjC4CXG6tD6epoXdKIZKwZTp39BhHQ2bv1en7grgklhIvy6zdAZOBOfXdIVrjx8eJ13qj7VAM5U93O+CVpkZZh0bV8xDn/AEuhXiI4qa6
 VVI8QUq3
 yiW6VFkWSDkPqeugUAVZvyHWTK08SLR2k4AThMxzqQ7tqRJMihV9qShUt/qlqNbhJaUr1jFSZHtUKQmRmYkEPumu3tze8mf5kGhBDCkiwFYZ+8cO2wobl+7cO/crnPyYRVOw4Jpq++V+lARJqg2azFsvvgWZ9jx3qUajIUHD1/n05nBwIR8spZicErV+VYrmvaa0N0+Jxk4rQzdpuT79fzoH6UVV4wN+yYiqHIOT6AXx3nK4A9Mm1LA+j667sAa0Xkkto26j33kMs0B3bvQujWUo/fdLB+2MgGnuQY0urJ9c+wydZfE3aK4sebkshEyu7ruN6jF+FZrThf4LMNlbD4VnBk2OMU7Nkm/YQ7PWVTG1Xzd5fH/fXbxXQrHItJ6koKiLE9nakwf881bQK6GCUaKDGxLvUtRuStv45gsIIdhAHxeixejM/M83WFUrX2xR8URDunRuKD93+YmEmi5RQ3FjWC5KTysuvZpK3vFU7FyXvMBzFc/H/aGuNNIhSJsm+fml8xHlMe+68f5wDDYd7QHBzO7l4VXiXpanHKMvnYDOnHV4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Xuewen Wang <wangxuewen@kylinos.cn>

The shrinker debugfs count file uses single_open(), so all memcg rows
belong to one seq_file record. When the buffer overflows, seq_file grows
it and retries the entire record. Queries for subsequent memcgs in
an overflowing pass cannot contribute to the final output.

Stop the traversal once seq_has_overflowed() is true, using the existing
mem_cgroup_iter_break() path to release the current memcg reference.
Check for pending signals first to preserve the existing -EINTR
priority. Leave the overflow state intact and return zero on overflow
so seq_file can grow the buffer and retry.

Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>
---
Changes in v2:
- Move the overflow check after signal_pending(), as suggested by Qi
  Zheng, preserving the original -EINTR priority.

Retested in a single-node KVM guest with 1024 cgroups each caching 16
ordinary files on ext4. Output remained 8865 bytes with three show
attempts. Count callbacks fell from 3075 to 2472 (19.6%). Six fresh
guests per variant each performed 101 full reads with no probes
registered. The median of guest medians fell from 127.8 us to 114.0 us
(10.7%, about 13.7 us per read).

Output matched byte-for-byte across the tested guests. Small reads,
seek-to-zero rereads, populated memcg teardown and signal stress passed.
Separate probe runs had no missed or dropped events. Small/sparse cases
had unchanged callbacks. The 64-cgroup baseline timings were bimodal,
so their apparent timing difference is not attributed to this change.

 mm/shrinker_debug.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/shrinker_debug.c b/mm/shrinker_debug.c
index cafb566301326..eabdb33353a45 100644
--- a/mm/shrinker_debug.c
+++ b/mm/shrinker_debug.c
@@ -84,6 +84,11 @@ static int shrinker_debugfs_count_show(struct seq_file *m, void *v)
 			ret = -EINTR;
 			break;
 		}
+
+		if (seq_has_overflowed(m)) {
+			mem_cgroup_iter_break(NULL, memcg);
+			break;
+		}
 	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)) != NULL);
 
 	kfree(count_per_node);

-- 
2.53.0


