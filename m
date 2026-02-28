Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E8CAFEE4EE
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 20:15:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A8716B0005; Sat, 28 Feb 2026 15:15:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 456536B0089; Sat, 28 Feb 2026 15:15:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 362606B008A; Sat, 28 Feb 2026 15:15:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 22A3D6B0005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 15:15:19 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B49CC1BEA8
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 20:15:17 +0000 (UTC)
X-FDA: 84494969874.05.FC5D2BE
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf05.hostedemail.com (Postfix) with ESMTP id 182C0100003
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 20:15:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=x8vdrzL0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 30kyjaQYKCE0z92xD9v33v0t.r310x29C-11zAprz.36v@flex--kuniyu.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=30kyjaQYKCE0z92xD9v33v0t.r310x29C-11zAprz.36v@flex--kuniyu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772309716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=+1l77ROHVrYnIJu7/SbY4bBO+iFzbL+oFxXs1/Hwx98=;
	b=ptyaIPcXTPfyM6tf5EUuVRvScFMUdyp9lqeB/rY4zQlE3aacSrNpvfzWJu1BP93+O2CRz8
	wM3d/HG7OaCL8uFivJihBlbotA4sKtLqC1a3DQx5Gk8Hk3TDOKpz2UkUy3fa7jTmLVTiVT
	Y88HNANJbbA1mg25ecR+0MKuxdKHjmk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=x8vdrzL0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 30kyjaQYKCE0z92xD9v33v0t.r310x29C-11zAprz.36v@flex--kuniyu.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=30kyjaQYKCE0z92xD9v33v0t.r310x29C-11zAprz.36v@flex--kuniyu.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772309716; a=rsa-sha256;
	cv=none;
	b=Qkz1NANZKGiHzNHZKTLtmSquH1Hy4XVmYgJ252JQ/xKkANNWffioVl8m1mJd1jiiT4uecD
	5RX1DlRIMC2aYFJDrp0VEM5q8aazyOVf6KcZNh/UgY399DATYywPq8gvfcjokZsE7GirZi
	mOoxDyx5aNTp9MDvHq+rXQpQUBQWDzE=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2adfb6df9d6so216582525ad.1
        for <linux-mm@kvack.org>; Sat, 28 Feb 2026 12:15:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772309715; x=1772914515; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+1l77ROHVrYnIJu7/SbY4bBO+iFzbL+oFxXs1/Hwx98=;
        b=x8vdrzL0qmyB5nemrU1MxRXYAGBPQLijl2t0zU+Nku9cdqTTlneNewL75FQDTCOfpX
         uuC5spxCWNJyiPgdUVW8gQD5SWdoAwEkP6UmkRO6aYOXCAxaNQ60FSkpbWfiUKs/JSq+
         nP0kigh1D8chzgDj+/vo8/yQD2qxP/xzFZGUbYnEgtJI5asstc4pQSlXXZkTYi+6TMIv
         rNAfFghbdGwIuQs3WNQmDrKK8OVrCRJ3DNue+4PbN4rXW6w7+9beYnGcIHBtv3npaBtB
         mRQtah/8Rzs2emhbhvs+WQ6LELmHyR1N8U//kecXd/9PVKlwkLw2/Du1fXeIN14XHrSC
         senQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772309715; x=1772914515;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+1l77ROHVrYnIJu7/SbY4bBO+iFzbL+oFxXs1/Hwx98=;
        b=M6cs3EWoekA3GwFeQSykpkJC6kyWxjM59vcWesMOLx/vOtV7pehCx8wFgtD+X9VFP8
         pyyCGFOKkkDpRSalcKnS9ap++L37dDt3qrnEGKj2eJ6TKBWLXllAEXSQlcTkhqAzHf2Y
         9OpWCeQ4N8V9O7LlW8rXGQst4Z4jz8HiZkSMTTuPt7o+/LQd0jiHJ4wrpS6dynse6kLr
         Pk2/8eNvCgzZd68GwLwh3cBIt2J1CEp7H7Yr8zRByZkqMQsVv8XTFIIycP2jq8tgD8xu
         FfRgKnIM/Kq5j7SMECoOPm9mVgcO3GDufO8b1vSLJugz6YhDGfjSBVKpXF3qGawHocAu
         plOw==
X-Forwarded-Encrypted: i=1; AJvYcCV0XeWN5y391cCEMPshRQRVu0abLD5YTitOzT0MHmbp+lEZ0uf42IoXgyntuxzfvA7t2vGx/4jTqA==@kvack.org
X-Gm-Message-State: AOJu0Yw3P/kP2rwaOtqPIRkskVhICucPDCYtoF8od55KrlR+sEGFzxQc
	c2V7GswbRxg4DSzAS7V12zzs0xXjjM7vYJHSCpSTMk22FhkAwX+iJaq+I8Ey1MPVdgDI9X/3ciy
	p9uJEWQ==
X-Received: from plbm2.prod.google.com ([2002:a17:902:d182:b0:2ae:3999:969a])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ab93:b0:2ad:d5d7:bad2
 with SMTP id d9443c01a7336-2ae2e4d67dfmr44403665ad.48.1772309714615; Sat, 28
 Feb 2026 12:15:14 -0800 (PST)
Date: Sat, 28 Feb 2026 20:15:07 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260228201510.973702-1-kuniyu@google.com>
Subject: [PATCH] slab: Update stale comment for sheaf_capacity.
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Vlastimil Babka <vbabka@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 182C0100003
X-Stat-Signature: 6tmq79spp7f9h7w37z6wkn8hunpjkjd1
X-Rspam-User: 
X-HE-Tag: 1772309715-156315
X-HE-Meta: U2FsdGVkX187o9FcDLbUpcV0ljX8Ggp9Db4Z8ebBGVFLHLImDYaaAl8vTG2owapu8ZbXsc2zeBIzOnJTEFL1m7qsNiq931YwIASunhkigrSrNS40irSW9YOpE0VlWXFE2UNOt4749+EODgFmATTsL1/0LFPZXJCsAqumh/U1/PotX+w4KQ/092QQvtXF5BjIoKf1S8PUAqnyoOZlB9hI01+vS1McuKpu/1yDz0CG4KZQ3ankFnR5pzAi0Kr+kwUKWJEHsg1sI26tJi8QdNbTQtQjK1YhDASApjKQGP0491T4fSUVDD/x6+8oV6Znip6q3dZCsFsdhV+ZnpFPePqT2nTsyw9I5bz2f67bn7y34Ny0hnN5jXW8OBjpgyRkAkyQDBTKL5xFVp0IYwnDtBKHXkL8uaqEBSElCbdOsHPXlz2rRnxSjofOHvttWmfqCkKGNrcMU5S5hiwJBNxJNzhLD/ScEFZSFr8q70qbmn5CMZQ8xqooR4I0VPQwM4Rz5zSqEDBqzovSZ8WCW44uSJoTCorN662nW92zhSIiEOS2C1s/OuKt3aBvlINqp3tRhhYlwToHpotufgir7+8gL2eJP9y3VsV3Gnc7RaDq9M/DqrHeY1nRQAphzAg+EsahaVp7Op2F9fbtlqQMjh6ETe+QBUP2woYZyw2XOjPYp8A3t98xtxkSjwvliKfLoLSygAK32OftFsOKtMxkWFlju+XZ6fQ3Q9LWEbU4ZTmue91I9rjarbpq8SVpflL6rGT+3D9RzYTWTfvHW6VlZFPpC+PmHNK2jn0y00mwmJYdNtkMa/VGMGAC46HwaPHZBX0mJ732hvhKU1QzkCASW+msJA3uFRO4qLkNAt7BaS9JMQ7VUA7ylt6X9qphItc/2BTh421m7R5bs6AUIdOnhtUzkf3/bbnfIoadNuGyVu0zlxoikhN8LoddQlQRU+pyNYYNkAEr620vq+mEyEu+OFdEcDT
 mXRl6pD+
 oGUeSuywQdoviY7MU90W6HOXecYhqii1mTUYocXTuftuhvznBNTRKXda1IZu2EG3F2rPGBUE0d4iAROwH7pDAaFJjrqnHoILXqSbvIrQx4PgOMS3sgfPCWX4myjGy8qlAEhcsVR6jWI/qBKOK8G8h4F1BqoZe/GhSmPpYfTV+akuZpFBDGQQFld8tL/kQwwUaciO49TbycOllT+77O9kGIuLXAvz76KGV1js0nWcyi1ABe7owpjxHFkKdKLN6upt5gOrvTORig8xXtkAJE3M+YQlH4s0bcpkRe0u4+NTMdFWSKBovW6cPcT2O36CDdcmCdOiEc7dBjsZEhOQbJ+LKW/d/JUmo9zmluIsqvGjLOgXrPne7+lvIaIyafMQm5T7b9O+gfEVZFI/Z2zi4NZUnmzSxCI/cnP6ZwHuJJ1I8lYSCPU1oo4F62juBAQk91OtjSMu8Wxc1avmObxhzXyyL8mwbjtlXKV6upsA9gettaiF5k+aiJQSLgpcCAtIhi2Bvqk8MgY/6K+DfTlX1LcLVmMrwLwcMk3mHSSZfk6RGk4tRnpqK1/3HXK6BOEehiDO9G1kZ3zO/G0rgAeNUlazJs0Of/ZHQVYvYjcIcRdSrW9nEgKEX0T+XyZiBbcGQfdcwUWsHQ8Uy+63sBrX/YXJMSY3/j5H8m7EwAJnxuWZrCFC17Ck=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The comment for sheaf_capacity says it does not enforce NUMA
placement, but it's not true since commit 4ec1a08d2031 ("slab:
allow NUMA restricted allocations to use percpu sheaves").

Let's update the comment.

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
---
 include/linux/slab.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 15a60b501b95..7477109eb315 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -359,9 +359,8 @@ struct kmem_cache_args {
 	 * may replace it with an empty sheaf, unless it's over capacity. In
 	 * that case a sheaf is bulk freed to slab pages.
 	 *
-	 * The sheaves do not enforce NUMA placement of objects, so allocations
-	 * via kmem_cache_alloc_node() with a node specified other than
-	 * NUMA_NO_NODE will bypass them.
+	 * The sheaves try to enforce NUMA placement of objects, but the
+	 * allocation may fall back to the normal operation.
 	 *
 	 * Bulk allocation and free operations also try to use the cpu sheaves
 	 * and barn, but fallback to using slab pages directly.
-- 
2.53.0.473.g4a7958ca14-goog


