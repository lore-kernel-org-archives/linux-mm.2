Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8A3A606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 12:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GghFJPnB
Received: by kanga.kvack.org (Postfix)
	id 7FB386B05B0; Fri, 27 Nov 2026 07:27:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CE916B05B2; Fri, 27 Nov 2026 07:27:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E4FD6B05C0; Fri, 27 Nov 2026 07:27:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C19836B05B0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 07:27:20 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E05FF1A01C4
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 12:27:19 +0000 (UTC)
X-FDA: 85480824198.15.A26D55C
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1173340009
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 12:27:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=GghFJPnB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795782438;
	b=qEgoJiVSIVrAIDBXNU0yH/Flx8FCugvIN0liwKl/tOVN3jiBzom+GA2auJDZViRxqc34R4
	nJK7EtT8hitlq3s5T1JUzcjWQNply86iUNa5BhXZrgP3L419qOVjcqWCxvu0NuLPho5N+Y
	H70pfBDWeFUi3zhxgbIOVEMIH1eGqpc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795782438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=xP3AX9z/qSFgWuu0g11r9oN9g4Vo2+Ez77ENP8nsuB4=;
	b=IH+j9N9SJaQTN4L5LAh1XU7zIcHrocOpXyMS07xPYdFGCEf6NsOp0uSmMKEQZu6XkdCSPT
	OMRPTtbJgfR55vAQG3BY7MVeB1Yec2DDxdTR8AKlifNMOqozVOJFwLRrQo4EPufOJyJgOc
	WXzzCjzOO0254iKesSQVgZrLs87YHas=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=GghFJPnB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-cd8b2b817fdso353583a12.3
        for <linux-mm@kvack.org>; Fri, 27 Nov 2026 04:27:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795782437; x=1796387237; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=xP3AX9z/qSFgWuu0g11r9oN9g4Vo2+Ez77ENP8nsuB4=;
        b=GghFJPnB/d1+XSB5BFnEDmuQH0bX+Q7uVNr4yz9WWfeOMevIzEe/XSKGs8uP/X0ZYt
         YQVj/yfQyxqWqNYjSzXdnNiMvag8zyWzeEwyh+S9dtqF6djxsv5PZNqjDLvbUGfHi+Oo
         3HswR1BRMPSs7npfxCHhe8rhZo8b/ifu7pTJUt5H6eXDcH3PvFTgtlEm/T8wdskjZ6HR
         wwoXGdluBRy8uuqu00MOmvYFrOEvDbU95ER2vFJ2DzOdECqWEEM0gF57bu+fsBN4i+ya
         jbPtiCE1tyUbiw83o+LYz4BsdAEkgS9rrIzUNxzx5RyfyCij2+iFL0qu6BKeiIA7hvhS
         kI2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795782437; x=1796387237;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=xP3AX9z/qSFgWuu0g11r9oN9g4Vo2+Ez77ENP8nsuB4=;
        b=y/u9lWdTqN2zbogOHF3Cp0wt+PvcOOo4h/ng3aquCsx8BKhgt4WzXnibAsT7LYRFIF
         jiffeYIEnF13ovVkYnzlU6aLRrYp1gkgH/ftCMIjQVfbshBvEpcdSNaO5wgD9jxd9wuf
         GeLBMZud0Jg6NH7Wbin5kqWCiIs477hPLZECPLfvH2t2bCKHluXJBKndnid4qwmiBntu
         AvbJ8xYnVcsdVr2GVkLKX4akTnQ0oenBA5L4xnZ2t/77fmiDovJVYDwIm5SWb/Pxqpbf
         jT253bbOMn38LbboEz93kgmPNIg/ks/VaQoIKlfT07RxjjAXEFSMps+NXeB+gRj3HmKW
         QfWQ==
X-Forwarded-Encrypted: i=1; AL+hErE6eOgyPcaGfpP1tU0ydcVR2O2M3LYK67kfKPiC/Zbb5scJAZjv3KaodfPftWP/8ly6q6TMkgRLFA==@kvack.org
X-Gm-Message-State: APuU4Z86gsoy8bnuJGm0a/5C/4khwWTbQ7ZQLKUL/UdmffQEOdqwUJBQ
	eOas1DAr3VmVOXJMPu0L/Xkf865IllYvuA7Uk5vXUV1gFGyyPPIxE+1W
X-Gm-Gg: AZFdTZdihAiXtPr5vyUaTdZy8LyIGQ7qKzfUa/k7/s7opu+12vUCmh6Qa5HqB9ShGUz
	0sKvwzOYL6pbJFH0Ll7cn+rF7tZeZyKXB6ISeqLGdHoRfohni7HMAUTS++0+bu0ZemD5y3vBOeu
	l/GIVidy3B/GC8O7mjHgODEXTGufFuPVsQQQkSdO613Pb3N3AUz1bk1PvomXOXecYkIAHn+8L7i
	+zxRs3/9yTF38F28fiwI1Oz6grv6LY8shoHGgF4JEquqm7ICNyC5tN7lS3nC7Q3X6CX5lGp8+xa
	eQbPt4vtmyF27eh+EtYnZ9MxqRhCsaRQP9LXpSjS38bGOHNBnY3FueGZz+XnFVbp0PS2ojL+asH
	fRFK5pKk7tg7LRMih1fJxaOhgDEyIBIhz7sDFogJxs86G9KCqsxzvNUSo4HpjcaZG1EcI6Ypqtk
	WqZA6secO0NGYvhmQoR2qqTdMKB70hDzIB1MzIKg06zVSov2iEOdxzNGEngBw9hrq6pyTXGsoSu
	HmGtX4Ao6yhkqhHtLoz38gVA6UsxS2GfeuuCnV3yoV9ZI7QAbtcPdrG5mS2QgviRu7Jjcxo/z7g
	az2AjNdWY1WmOX7i4jUXDQ+RC43sbDpgwzsE5tRqLXvM1Yc59T83osh1vDopTRz4RxU=
X-Received: by 2002:aa7:9e43:0:b0:8a0:92ec:5f1c with SMTP id d2e1a72fcca58-8c87654841bmr25686023b3a.0.1795782436179;
        Fri, 27 Nov 2026 04:27:16 -0800 (PST)
Received: from o6.lan ([2602:fce1:44f:115e::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c87334890csm12600941b3a.33.2026.11.27.04.27.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 04:27:15 -0800 (PST)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
Date: Fri, 27 Nov 2026 20:27:02 +0800
Subject: [PATCH] mm/vmpressure: exclude costly-order reclaim from socket
 pressure accounting
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261127-socket_pressure-v1-1-1d3a60c1dbb7@gmail.com>
X-B4-Tracking: v=1; b=H4sIABV3CWsC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzNDQyNz3eL85OzUkviCotTi4tKiVF0jS+Mki5TU5DQD0xQloC6gRFpmBdj
 E6FgIv7g0KSs1uQRkjFJtLQC60CNacwAAAA==
X-Change-ID: 20261127-socket_pressure-293b8decf05d
To: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
 Barry Song <baohua@kernel.org>, "JP Kobryn (Meta)" <jp.kobryn@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Jakub Kicinski <kuba@kernel.org>, 
 Rik van Riel <riel@surriel.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Xueyuan Chen <xueyuan.chen21@gmail.com>
X-Mailer: b4 0.16.0
X-Rspam-User:
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1173340009
X-Stat-Signature: bwisr45tda3nkkner3rc33ucptb73thu
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795782437-830079
X-HE-Meta: U2FsdGVkX1/4aEnI4NQMnyF7CErBGwQy9vZK2A7PU+M/9fwIWM06H+YwcUrvMWifj/k5ywZyrD/5PSKRZ/vuxz+2sjuUerv8O/5DvTBFWAdrBZ1Xl4+VDU5PKqgj/F+dfTKaNQnI5I6i/HAOhor8fQmyLWVlGQdny8OgqlM/5GZfI2rE9wxoigrKJL0INg8UEu2jU2L0hcu4wROsHt3aRLOhFapAX8tOZcEmIdR09++/nhvVT/us00fUqm+nX3w4ZqmWsjWFp9N1D72EU3E1vxvl00eeKGNjj85HhgjNLR981bCyLRiRxVTjDHCL9wTjrjnYwzhzblApb4TGf0lZ4F5Bv8IOofifDzpuPPA7kT6eI3jxLL3xtXQ8cBZiWfk9IrOs3eqK7P3whrBkSysaN0ny9jdbMdoCBgbM5/pO3qFyuifIIePPwx30/sRC9TE3knInga12TcoTUwAXuW831wumXYmilETNUw21XAg1qGS/t6iHDZ1Bm7Hsg5cQAeOy8TO4trOJPlvZexHctqvxBLr43sh+rWV/z6Q624aZmQeYW8ugl+hhl3hm0PxfBJPgytt8TU1mkFr1SSm9j2KgtOmZGCdOhYijWIaydkjZGiqlrLrnBSuoc3JLiKpCq0XWmS59+u1nWILJa+Bu7zRO1I9xnoT7gOnYm1uAosgk6DpIFgYmop6aNDeaL6x9C0P4kgGxuR/VH4py0WfG+oTBFoO50XyRc/luF33wOExqjnvkP1FPZwlffM3bf0XLZRB+VyS4css8kQ5r7kD1NtQnjUlYY1UJa0ZZkLyg4UYvSip8U/ev9dArw5TVnxjMjGzTVpXE7dKd0SJ/NyfrNn3EPrW0RRDV/2nMwWxB9Vaz+SVDrl35+ygcQXjRoevE4uFGuCy91+glXEBIWjelcsYSxO7sCUldWqh6deJ3lhKRzesd97WGZ0x8Ap+ORxKFro4O9YCSZKhRpzVKhKDRxYm
 uaS9rbpP
 33QR5rC3vRk+ZoQUPW5gvbq58CdgwtMb1p7KE3g94r7g9Kit5CnFiR37pg4YAr1Y3WA/FcucEpJ0nvaNFJC6SylaujOQCjwd+knunq2xMcG8Vqp+g7Fmja9yP33+q51A67+RV+roMP0Gk8NAHPwHDY64zb9vsGGhpf9rgbRDeO+v1z58UyuPi8E/N3mBU0ZsyQWs91I+deif6MhJOCfwOLHV9ODxGP6yM3etoXiqFOcuauERHTxkL63i740QRfVXs31pLY2SY/+snBoazYQWuQtemcLoz0xOYPZixk5uQddCryCi8yZvlnGWaeyCtp1z6uLxoRJsgxY7+G8B+1cMgLJQcXKwBqKHNWQwz0SUbY4tlzX6hVdGfDBLXMb5pV18SQrPW9Kk6naaPK3vPObY25HrUqreUz36h9+FwjwJ9aguEaJs02XD+E6XgT5kMIl2jRUIpWW1d17L59YqvER0X13MmOD8bKquNWvt94TAgz1MwoFlnMOeTZa9GeJXoN8+Z1wtO3e1HhvZ98NaO3dxsxxiI1MJq/GQw5nmAac9u63IV8dYvFS8MFKrxJqdIVUnbq6PsgTeApuAB0asS6lrdQvWLKfuHhV2lxDQ9WCBREDWvMkIW9bZDSuBiw9/E4oSIFtNKX4shUSDe5HI9U41jTPEhOvZwr47McL0eadfF0ZVDY8rvIqHoQh0m83AWyterx4y+IPhqPilsfTgUQN/v4zIBe0kR0HNripLd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

vmpressure() accumulates reclaim statistics but only checks the order
of the last sample when closing a window. As a result, costly-order
reclaim can still trigger socket pressure indirectly or discard
accumulated low-order reclaim statistics.

Skip costly-order reclaim before updating the counters.

Fixes: f2a950170f7a ("mm/vmpressure: skip socket pressure for costly order reclaim")
Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 mm/vmpressure.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/mm/vmpressure.c b/mm/vmpressure.c
index 3de99fef3928..9828a67206ef 100644
--- a/mm/vmpressure.c
+++ b/mm/vmpressure.c
@@ -156,6 +156,14 @@ void vmpressure(gfp_t gfp, int order, struct mem_cgroup *memcg, bool tree,
 		if (!memcg || mem_cgroup_is_root(memcg))
 			return;
 
+		/*
+		 * Costly-order reclaim relies on compaction, so its efficiency
+		 * is a poor signal for socket pressure. Exclude these samples
+		 * before they can affect the window.
+		 */
+		if (order > PAGE_ALLOC_COSTLY_ORDER)
+			return;
+
 		spin_lock(&vmpr->sr_lock);
 		scanned = vmpr->scanned += scanned;
 		reclaimed = vmpr->reclaimed += reclaimed;
@@ -168,15 +176,7 @@ void vmpressure(gfp_t gfp, int order, struct mem_cgroup *memcg, bool tree,
 
 		level = vmpressure_calc_level(scanned, reclaimed);
 
-		/*
-		 * Once we go above COSTLY_ORDER, reclaim relies heavily on
-		 * compaction to make progress. Reclaim efficiency was never a
-		 * great proxy for pressure to begin with, but it's outright
-		 * misleading with these high orders. Don't throttle sockets
-		 * because somebody is attempting something crazy like an order-7
-		 * and predictably struggling.
-		 */
-		if (level > VMPRESSURE_LOW && order <= PAGE_ALLOC_COSTLY_ORDER) {
+		if (level > VMPRESSURE_LOW) {
 			/*
 			 * Let the socket buffer allocator know that
 			 * we are having trouble reclaiming LRU pages.

---
base-commit: b95f8bb86713c860ce8536d22a988b949b884d5f

--  
Best regards,
Xueyuan


