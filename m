Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7ED8C88E53
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 11:49:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CB326B0088; Sat, 12 Sep 2026 07:49:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7626B6B008C; Sat, 12 Sep 2026 07:49:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62AB36B0092; Sat, 12 Sep 2026 07:49:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 41EEC6B0088
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 07:49:10 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 27510A04CC
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 11:49:09 +0000 (UTC)
X-FDA: 85204939218.03.94D4CAE
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf29.hostedemail.com (Postfix) with ESMTP id 63CCE120006
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 11:49:07 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WDstIaOK;
	spf=pass (imf29.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789213747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uF0MF2gOEFEki0fjUid9TInAQpR7MqNNTpN8voxnJ2M=;
	b=MS1agAs9q2BYZ6w4Aa32UhPCGHpVYDREW0F4LbngNOl+7pC5+KVngSh356210jW8bv+cFl
	0qK9P9mtGxmu0pXRPwlpgFgqfXCHmNnTPH5jgJtn3u9hAJoq0YpglrOQOqY6Y5vckjeAYA
	5IdgJt16i9uYaH9HeqRV87bySJZtX1s=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WDstIaOK;
	spf=pass (imf29.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789213747;
	b=higJdJCntoO4baCLtk/mEyryMGZwyFjX8Ao+HoaEGRxtR25occiu08Ek7ETJpwb6NtDDpX
	psBbjTvoduUo7BlFCEl3hpi+QEZvQQw4K/pfvqLUB2tI56vcJga7Py3lb51fZMhub87zik
	4B6XCLyOh6atdMorZpbI9jzdUSPTtdU=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-49ccfae359fso13287175e9.3
        for <linux-mm@kvack.org>; Sat, 12 Sep 2026 04:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789213746; x=1789818546; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uF0MF2gOEFEki0fjUid9TInAQpR7MqNNTpN8voxnJ2M=;
        b=WDstIaOKtks4vqCbpGsOBYBRNqEYXoYBIuUdm2TG/aiHCRFxGpi8dAnLqkrH1ZSUC2
         5PxeNt+MtFiFViXUkJa8A/obzQ4UnroHPo9Gkoalqjk/BkSkQVRWAogVANj645T+yjk7
         EncTCdIgrcEjp6sihNuwGh2s43Qd/KGI4wc+QDuzD+Rjyk1x1+9cR1GY5UhaEPIR97Kz
         3MnREz0PUKrrPpukMclzPEdD5x1iy8Uoja5HEj0SKklf6YyJz1r6KIKZh+Dstbw1rsb2
         AW9hqJ/BN4J7XAjd/05BgOKLNd/AGZ9D5y0pE29ZPJTykhwCMZ6viudjUo9d2P1zCOAa
         207w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789213746; x=1789818546;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uF0MF2gOEFEki0fjUid9TInAQpR7MqNNTpN8voxnJ2M=;
        b=m1BkZgPq/vgzLYEG+tHJ+c6rcTFYuKWbgB6oTpaFOZ4aZViyNfR5GXF4RfqnrAs6/O
         fbP24FU2K+wdBJVOWUZDIHGOFXrw1osz4wEbXfas1vYeGc+OWc6jZEsqi8e9CO0GtyYv
         6C1BVtDXblyuBqqVNFSt9IdJ3soZyFJet3aB1Y5BcYZiBQi9qUD/09u8rjXbT/dv0g+8
         HumHf09ennjtqrfL6CW1LkeIkkBSGbcrWe4EkfvMJTAFbiBzmyPYeoMyHxbsQ/8bt+QL
         ddRBvZxWgliL7vKSbJ6peoj5FAcEHHvtYB6hq1Ni548/SotFEcSirKj6jn2T30Y6imQu
         xZEA==
X-Forwarded-Encrypted: i=1; AKwUvBx2VkhRfWRJajeSnwbRgTmUv7mS6YRkHP9RAq7eXTFEzgt3F59YaaR4fwr3+XNwg5dQsXTtVdiO6A==@kvack.org
X-Gm-Message-State: AFuF++llVqZWqTXJ18f0eZsgap4b56A+Im2s+3DSn+yAItrsCBWIlKX9
	QZxIi6PzGxMh3Csd5ju12PEr6BSYJA037FzATR0MGaHM3L8pwHxdppAG
X-Gm-Gg: AYBFou3R9WT1XZP+TUZzFvrmzH28DI+0jHx6LQ7eOYe9eQHrTksc3OcUxBKUSEn0nrK
	VmVL0FL/e5/nNfJIG/Ol/qflH3QCeLrK24yQoSmVgNSMDgdsrnm/4b3BuaRBb6dVHq1krgHyMe8
	CLfosVgLw7mGq/XMsTrQPQDOEd0OZdSxyF7VtORArW8D6Trgxy9opNi6D1uJoa0JDwAZKcCLNpv
	tdpJeZnN5YarjccIjZYmphTJ6QfepSa97Ij8fJDlrdQmjex+5QDUOUJJpt5lguRAGNxKBNAIbAI
	eg3SUBSp2HaFpyKnbGy7RC9L3ig+yPHu7inIrWskrxe8cY/KVKLTkec/wTVbabmjcjXyh3290z0
	fkNcFZCtTFP3ThOr7wr4sq95UWWi1p1HrgKo2pKrZxYsjiGGvBkYuYNPCjTiKuUxzOHtr9DhhA1
	nF/+w19DjPQB2CCAUZkI7HkfHQYIcnmrTq9gRUiEQTtrnkYu1aPDWzOtjuewLR3MaQKG1X2uif+
	3VseBV/SUaBUH+5eslN3jZ2xslavstJuw9xAqj6aBwXzs1nDjTP4Srlqh+qutCn4GDq5z+821oG
	iDTHQGuCVu0X+fZ6dx3jT6YhNUnrVwjA/Xjycr94BmVtF9ATd50wDo42vVoEH9pRSDW6TJeI6js
	vLYRSipc=
X-Received: by 2002:a05:600c:a07:b0:49c:fc6c:be0d with SMTP id 5b1f17b1804b1-49e619bd19cmr94593925e9.19.1789213745604;
        Sat, 12 Sep 2026 04:49:05 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-b260-f201-9983-e8c4-aff5-7a36.310.pool.telefonica.de. [2a02:3100:b260:f201:9983:e8c4:aff5:7a36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e62232cb7sm113609845e9.4.2026.09.12.04.49.04
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 12 Sep 2026 04:49:05 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	linux-mm@kvack.org
Subject: [PATCH v2] mm/secretmem: Fix the enable parameter description
Date: Sat, 12 Sep 2026 13:48:59 +0200
Message-Id: <20260912114859.88957-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <ap25Wj-kt2nsMn59@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 63CCE120006
X-Stat-Signature: 7efz3cqsjbax396z5of3ugccsxs6qhnr
X-Rspam-User: 
X-HE-Tag: 1789213747-903922
X-HE-Meta: U2FsdGVkX187IStBsEjYtciyPRiQIFt9wGd1/E86DdFplIWittbjTpVLAwgjAGrYzTucSv5z6ephN4iYuRhJBzY/L84uwXnOC7h/4kVrRFslSJpDxqERBdeiZDMTmGoEG2QpPJGdvfZ+POKjsfKpAhVVuhjAYHImvvL6rgjbvfI3fJSuNEU4F+onMgp3h7mmuEh2H2Mie9L3KPlEp3QveKkrovIecetV1/iqF8NoTEiRJq5N+mjYH6iM2xUca8DGpQ7MT1PWnRo6qnJ8vLKuGMiS6xnGwCYJlMOm+6DoxqP1yMwmRLCaB7z1D1FLv2hiUJFbXoF+NjI+ReNJvJAqhEmgIt+uAUoECjgjFGmo0EB7J1anSR/Xlzj9gq7lHp19hnAU5yxSJzfFKtmKgzwyBYwQ/AlF05o///72nHvVgKc7NXuxLrbjvkw3/wWkhJz2C7eOxYxm7QQDE5AyNS+5gN72jxrhx/KKJ1bblCKX0YgiNv0Az0xbzlL3XA2vyVYyFW9olaeAH19gLGTVgHzk6wgy+5UMnLv82irPS1KSgyLb2ch7LMtAtHgFcBI/Kh2/29qBA/HIFKCDepg1WwOsnM+cnUlErYVLPZ6F0Pna4ySUe0xM/OIwb1pdW6eztsv2JZOoc5+n6Qi47WDS8g9zOCo9YGZfaUlU/RddDNp7KB+/9xSIOWNkVHtDiu2fUo/QuQNO4+t2iywzb4vnqIWDmDI9Y6qAB/1UVfm+XterHGFtMUZMQE2ECAxPBhOPzofV/L1qI8egUlYZ4ZIuiD/eOW5AebH+OXHvF5FvPadlqtm6Axzg7AVsLpgW1uNPaXJXKMU2tUb7vF+rfAaIAO8UY+1Um82LJZzK/VD3r1X2WUkHQxi3kYvk49IhSjwuBniuokCjCpoOkysN8+rgM9vCRjcISpVh3X4Ob8ZR6IamhdE4roMIZMNH6mwYvw2XcTdBb8OLtKUVEOWfMRtGjox
 /u5/9x7U
 V+o15v8uK4uFm5lWlMQee/B6KWdru3ZOf3lCngn3shWig1KuYJKzxUM1azyyloVBkHaN051yOXIEMYXVaHxBbJuB/hzwXvawoXMsLktU5FGM+d2/5m4xbIrzjX+lbUSmlcpksqMk6uIjJ/DmgVTAlCFDQcmQzmbA6Q3jbdI7tNtyr0tsJxvWU0GvLZpCb18hLcmS8q4FSREOzZW7Qnc57rifCoTTBFnflJyTNMODFq9B1dsnB4gflMsfbzXmSS4fhfK64lKwIV+Qf2fSxEQ6PH+opLU4LP3SWpIGbC4OP9cD+sYgYuArSomXTwYsIsAt+lQOW8fjcr8KXWnvtbKYk29Y8+sqP22/LLodxa0QoxeMLOIOBojNY6efdHOFjp7Qv54IFybXH1TnWiGM8FFDTRKdo4CtqTQbgWnRYxVOkxDZgThNPsbXhKbM893YQFfyviGnT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The module parameter is enable, but its MODULE_PARM_DESC() names the
variable behind it, secretmem_enable. secretmem is built in, so the
description only reaches modules.builtin.modinfo, where it is filed
under secretmem_enable while the parmtype line and
/sys/module/secretmem/parameters/ say enable.

Use the parameter name in the description.

Fixes: 1507f51255c9 ("mm: introduce memfd_secret system call to create "secret" memory areas")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v2: say what a built-in module shows (Mike), Acked-by collected
v1: https://lore.kernel.org/r/20260906171523.3009-1-kmehltretter@gmail.com/

 mm/secretmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/secretmem.c b/mm/secretmem.c
index 384f5cfc457f..4e32bf55a599 100644
--- a/mm/secretmem.c
+++ b/mm/secretmem.c
@@ -39,7 +39,7 @@
 
 static bool secretmem_enable __ro_after_init = 1;
 module_param_named(enable, secretmem_enable, bool, 0400);
-MODULE_PARM_DESC(secretmem_enable,
+MODULE_PARM_DESC(enable,
 		 "Enable secretmem and memfd_secret(2) system call");
 
 static atomic_t secretmem_users;

base-commit: 986c24e0fe44f844b44d365b71ce831947f50298
-- 
2.53.0


