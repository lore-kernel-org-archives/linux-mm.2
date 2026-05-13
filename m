Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D9E1CD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 07:52:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 750206B0092; Wed, 13 May 2026 03:52:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 700E16B0093; Wed, 13 May 2026 03:52:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 617016B0095; Wed, 13 May 2026 03:52:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 509AD6B0092
	for <linux-mm@kvack.org>; Wed, 13 May 2026 03:52:35 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EACCC140782
	for <linux-mm@kvack.org>; Wed, 13 May 2026 07:52:34 +0000 (UTC)
X-FDA: 84761629428.08.C1010B8
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6990780003
	for <linux-mm@kvack.org>; Wed, 13 May 2026 07:52:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=f0+V9mG2;
	spf=pass (imf30.hostedemail.com: domain of 18810879172@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=18810879172@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778658753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=lpdvcDNP8HX01NlxU6uGsA7tI4rt59uNMOutPm2jps4=;
	b=oIoCX6/+V7ckidvhzkBMCCKB4QM0pV2+n+hCO+7n8J8yeU+rM0rDRHj16DnAWQfBJZkqiT
	BcHIJmL4lrBjaOwYUI/082+vszlUBFWN9jNzom8N+MijdgjyFT+XSKXs/LqH0Ish7y3lzv
	mKXVoHoEcYOn13+laLIUW354N5Am1pQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=f0+V9mG2;
	spf=pass (imf30.hostedemail.com: domain of 18810879172@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=18810879172@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778658753; a=rsa-sha256;
	cv=none;
	b=u99KoiVsmrRuI5F3PCjsqWOTIHdTQXlNjl6hvlB++HbdqSf1ilxKYc4PInZfQmq/O+a6pZ
	JCqHtANIAHoJ0OUN/s1gkoXBW3RdRziAIuBtrPhnp3fE9bbfLnfBHsy2+nlCIQD6Igd2LH
	vxba8Cli/iGNULeA7XqwiZQqhlz9mlI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=lp
	dvcDNP8HX01NlxU6uGsA7tI4rt59uNMOutPm2jps4=; b=f0+V9mG2zkNrRd43EG
	YkjUtEgp9NAW2i2vxrWYrh2QxbGHzYB5u7n9s16fGR7q0IlDa7txqzAGdu4rehbB
	oX68kBpuPHEvV2LU8zemihA4lp5GdZCMDR0h/nWIT/csqzm7nBojjkk8yXztk5C2
	7r/DRi+MNBqyzh9SmSmmibBZM=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wDnQciwLQRqR559BA--.36720S2;
	Wed, 13 May 2026 15:52:18 +0800 (CST)
From: wangxuewen <18810879172@163.com>
To: akpm@linux-foundation.org,
	david@fromorbit.com,
	qi.zheng@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	wangxuewen <18810879172@163.com>,
	wangxuewen <wangxuewen@kylinos.cn>
Subject: [PATCH v2] mm/shrinker: simplify shrinker_memcg_alloc() using guard()
Date: Wed, 13 May 2026 15:52:14 +0800
Message-Id: <20260513075214.2655710-1-18810879172@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnQciwLQRqR559BA--.36720S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7ArWxKw4xuw1UCF1kGF1xZrb_yoW8GFy3pF
	W5G3y7Ja1rZFnYqFZrAFnxXr1UJw48uay8Grn7Wry5tw1fXF1agr1xtF47tFykGa4ruFZF
	qryUWr1j93WUJw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pREzuJUUUUU=
X-Originating-IP: [39.156.73.13]
X-CM-SenderInfo: rprymiyqyxmiixs6il2tof0z/xtbCzhITCWoELbK6RQAA3I
X-Rspam-User: 
X-Rspamd-Queue-Id: 6990780003
X-Rspamd-Server: rspam06
X-Stat-Signature: h5ass5o3jnznc1rgm6aio5mno7ieibfc
X-HE-Tag: 1778658752-274916
X-HE-Meta: U2FsdGVkX19lqMTl3DguFcLwFrYUvz21T/IMys9GCvDc9FGGlIhUeidBEjUMUxXsFIrC0+2NLuXI+7+tuiVv79akC9jkL5Vk5TnU1NH+25nADUc5gd35/99toEL4nhVamVbw6+Lg0EFHrbu9KgALajCAW24BNI/HQsIi5gX4FYEE0j9lFMx8hXqLD+cLdUb9cg1WL0UGDCOoUJ8DAUkXvxuis93XFROOEx34etk4H2d6kAJW/t41wr9I/LwCs8yomNlGbVZJYO0fP+OAvJSO4nDMfpkn5Ma9cITBtazuYiPZJKqOJmwQjS1utPkng3itd7/jhLtaESrn9bK59M5Ptnh32o0FBoTgiCkA41+/gXt4V2UWssPDyktNuCceKGzVcZGBHnHNzRn4k2fVgXs/tKHIFJ8xoodjb8fay+QNOIU/aouJJPWfQCbbS23TibmkVZgD0YDZdbVxIoPWwwMGToMSrAII5iI2VmcoyKtHJCEjFZ9tqHt5s+dJwSCBkw1WcaZrArf33qKjXdQ1+EMFE9UiDu64xranvd6zu3Yn0duaULxttYjaYyNw9s+3//73tRyYooW9fq2hUKdk3ry8UdNsufTFqwAGPn4jTKh0W1TpuqrVs1pS9mabUf28/hY6u5yLDBgp9QLAqoE+KnZYsyT9PaMdKDbQiVCrj0rg1c9X/24/Rg0jc6jLUtK9UoDDf3YI88PCV1t0QqfOxI/fz656uSYivqLJGbQ62b38a+WY3B0nBPan3EsezJ1J0La6PTIqB/Hh8dxtSiOvqWXyR23YhDqHjbQn88RX30Iw4wjEznRyscX9I0vvRlN6+qszHAj7Pf9aJdI/OHwDAbwwEl5Yhu5Tc3hdNhS+4zVw4/e8wDleoGb8CHFzSa7VyaZOiEl1SUfc6dWLpU4SaJ40zHsgMlV9hbesqyWCUZ3Lt14zxgPp6aSH8KQbmiM2jwJo7KBmro/3dQjy5RcyHcB
 kpq//cik
 +xTVwLHdNlOtj7WsgQ//kO7ZiSlyTeecWZa3oH58dLUKnRfx2cR19JcMD00fA1uRzDaU2HEBEWs93r2iFxMUMfjopptod+xkjqELVzoU1yjeS5vFwqK6NWTWVo2egUE7m3wZzWcWM60UuVK73L1rt+A2J14ZslpfaG7Z+LSi4KgoEwVzRxaPYnSgz0RMneRAkvG0VbfARO3aJAX1HhhEQMldFUjSy4HEj+PXgmxtEZkcDk3m+4fi0BqiNzEoWv38DGuFJ/d1QJSywaFLASZ4aNCT0q2/B3V1aS0xbvDN0eWN7MtniupHg9Jjz99x0zKVVTBlR1FBik5OF8rEimLdqYQhEf2djsCKjE8GkqHgHtJ5LlB3pZMwy2koxathPeQ8WluXvTKDkv803trc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use guard(mutex) to automatically handle shrinker_mutex locking and
unlocking in shrinker_memcg_alloc(). This removes the explicit
mutex_unlock() call, the goto-based error path, and the redundant
ret variable, resulting in cleaner and more concise code.

v2:
- Drop unused 'ret' variable to avoid compiler warning (Muchun Song).

Signed-off-by: wangxuewen <wangxuewen@kylinos.cn>
---
 mm/shrinker.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/mm/shrinker.c b/mm/shrinker.c
index 76b3f750cf65..cb03fbecc75d 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -215,29 +215,26 @@ static DEFINE_IDR(shrinker_idr);
 
 static int shrinker_memcg_alloc(struct shrinker *shrinker)
 {
-	int id, ret = -ENOMEM;
+	int id;
 
 	if (mem_cgroup_disabled())
 		return -ENOSYS;
 	if (mem_cgroup_kmem_disabled() && !(shrinker->flags & SHRINKER_NONSLAB))
 		return -ENOSYS;
 
-	mutex_lock(&shrinker_mutex);
+	guard(mutex)(&shrinker_mutex);
 	id = idr_alloc(&shrinker_idr, shrinker, 0, 0, GFP_KERNEL);
 	if (id < 0)
-		goto unlock;
+		return id;
 
 	if (id >= shrinker_nr_max) {
 		if (expand_shrinker_info(id)) {
 			idr_remove(&shrinker_idr, id);
-			goto unlock;
+			return -ENOMEM;
 		}
 	}
 	shrinker->id = id;
-	ret = 0;
-unlock:
-	mutex_unlock(&shrinker_mutex);
-	return ret;
+	return 0;
 }
 
 static void shrinker_memcg_remove(struct shrinker *shrinker)
-- 
2.25.1


