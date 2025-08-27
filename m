Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6899CA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 18:34:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52AAD8E000C; Wed, 27 Aug 2025 14:34:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DBC38E0001; Wed, 27 Aug 2025 14:34:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37C7C8E000C; Wed, 27 Aug 2025 14:34:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1E5FD8E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 14:34:31 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D9E3B160664
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:34:30 +0000 (UTC)
X-FDA: 83823387900.23.A91ACFF
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0562D180003
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:34:28 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=m77X10gV;
	spf=pass (imf24.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756319669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YA6lB2OHRh04z8ztLcpTUu2sKqTDk2Id/2bOxOEc5ac=;
	b=MoGIOZvtp1vHWzGwPeWOHWmYhMXd+frRfKLmsRrks4XesTMrWztVo7q/C8nfZx5agvYeNx
	zd0b85jOcnhBDllkRWt1ANc2RWlcmmOFFmTLF4G5WOoixkVHxe6q0pihLbMUWTjZ72txe+
	BnZwdsEetpCnnTVC9VgdMIXLsOilLto=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756319669; a=rsa-sha256;
	cv=none;
	b=faeFQuSGBEuX5vVnEWErWF0kXYbGbLnBCEaby60/PM4wnV043jSxK/COCAjMWq2cTeLJHJ
	KZOkZwDUuVn2q6V84a5YyIHPVXwRFvJ/p8kGXTprrUJsBRJq+U/ulAGYBH/iFsIQXQW6Hi
	GKCs6ZN3Oxb29ByhagH8T+N5TEuGmgs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=m77X10gV;
	spf=pass (imf24.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-45a20c51c40so835055e9.3
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756319667; x=1756924467; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YA6lB2OHRh04z8ztLcpTUu2sKqTDk2Id/2bOxOEc5ac=;
        b=m77X10gVbLKmx2leg+5pmNjMmQle3ENbf9of+5F/qVQQLbR1cFjCLKofGhDRMngXes
         4r6SLy37ElXJo6O5gzr1hihz1hevYc/vA6CVhAA3Wn0qliKr1eOZwpbLPgIcTDUE3XH5
         s94xI595jBTkEFXwSX9ud3hrGrhXq/YWvQ2vbgU0w+l9PivaQr5GP59kJSxGazc0edBJ
         AVJyb29dMIPWENmclQ20nA1UQT/5WG+kQIeTRvpw++duNAY09+Vs8Oy7uB/FjGUACdhz
         yKjNWCBsFXhuhc+dTwhRnCi9ynqR32DQTsIh0GZ2KdBGCQE63pyZc1yfzq4MAngdK1RH
         0r+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756319667; x=1756924467;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YA6lB2OHRh04z8ztLcpTUu2sKqTDk2Id/2bOxOEc5ac=;
        b=VChjLzjSNbLF5JWQjCoPRWW0NqR4vXtYqJPNaiEhz8e9slDWiapNM/U3+JeWAUCOXB
         MLZYWF2t8Z0lPGvzz/Mi6fFOriDhWsKgLz+Eo+UIWmQ2DeMQpD0MAhtytLCOZL8uqWSP
         AGNfKs5rG7XZFPiKwTXubDdwBdvBDFhQPGOAl9KZ4UrQ5w6zaf92i6Ue45VLjQDtfUFt
         L5KVaeL39FX/IW9QBXM38ypamqHy91UfiVVPmxCYZ7fyXeS3U6su93xKEQUgs+UOsdkf
         aXHhh61V8qGD5ExKa2NHG0udUylOIN4En5Z8UlJVZtoaJWdH/7SEsTD9N9XfIsJfdWZ3
         XRGg==
X-Gm-Message-State: AOJu0YzWw8dJkP6ZAT1i/q2g6czfHS5G/ycfxI3iUIdbtHF4ZPvPGln5
	YvXb5LrzdTaEgmDsydWPTgOpZSaU/37D3j+WzB1GtYbQpuGCAkclmbP9
X-Gm-Gg: ASbGncs20GEOQL05OZdFyl6b1lbaz0QprwcSa0isumYfvdDWOnWBbbhNBrqzYOFZYsG
	OCBkgpibSGfq1vupi5Jcb8tIkjNajDvbtGGmQRhO4GiG8xQJX24iW+5LEpnmAqx7/XC/tUNE1sd
	zByHsoK2EucBoaKmDnZcbUOJaGnN7mEkkKp2IyvBXXOhSYOknhD0w0OdPpYhzNnEYojkZaZPBb1
	iXsOVFudyV929P7G1ZdhtjoaN7KAhcbqJoYmcAQfUYYDmOt4l2bXzbv/fqIRogYl13ec/L8wfJ8
	w3XzlgCE40goQR3j8vhAufEZLM63pPCOISnjld03YZ402IyFO6s9DT4A0nRrcBnve6cJPCDEgZ2
	/MYEjrG5hffc=
X-Google-Smtp-Source: AGHT+IE0hXtxhpjlhfM+hRo7ji39tkDJ8DWU2BUHg+pIVaprTDiApHeE6ZCxx0FjYX9RgVOZ2NgUxA==
X-Received: by 2002:a05:600c:1c14:b0:459:d780:3604 with SMTP id 5b1f17b1804b1-45b771b5ca1mr1652945e9.3.1756319667550;
        Wed, 27 Aug 2025 11:34:27 -0700 (PDT)
Received: from localhost ([2a03:2880:31ff::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cce1724939sm3580972f8f.26.2025.08.27.11.34.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Aug 2025 11:34:27 -0700 (PDT)
From: Yueyang Pan <pyyjason@gmail.com>
To: Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Usama Arif <usamaarif642@gmail.com>
Cc: linux-mm@kvack.org,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1 2/2] mm/show_mem: Add trylock while printing alloc info
Date: Wed, 27 Aug 2025 11:34:23 -0700
Message-ID: <7e2bc96faab1a338829e549246189ad96e6c866b.1756318426.git.pyyjason@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1756318426.git.pyyjason@gmail.com>
References: <cover.1756318426.git.pyyjason@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0562D180003
X-Stat-Signature: zcaha4p3m6eesj153y4gyhzhsqzae49m
X-HE-Tag: 1756319668-780957
X-HE-Meta: U2FsdGVkX1+zPbIk003WarmQlIFjhBB4RhRcjdgBiQ62V3gMEPPNjGLnHM7rSORaQ2mCmV1TEeLjsLBkDIaRPNjOdh3bTHEoQe1NV6t3hClcfG88rzJWTzvqN0xNHdR2yEasj2sTOA/iILiZrxEdPoRU73f0nMUtc2l5E0AIqljDmeqdKnThcjCcl0MUzsZk3YnJwaUspMVO/VREWGXy8OBK1GVaZzXbwon4hWX2+eC4qP6dtlitL3AZCYXKCO3I5Ww2KecRRXkS4yvwmZfSmTG/NNyj30PlS/ioB7uOuW1Bwpn/zLHOe9ak869dzfOAW2gMes0KsVKiMbnWlRszE2uxb6DI8s6LmYE0XU7Wy797AgpnDbxKlU0Jkum3C4qoiqhMFlBtAPdavn2I+cXxBCHIIQDLzCo7U1EJkLsNH26SZxiZOtdtYGPgBK2voVIOaeOBB4G0Z5Z6PsL9kdLHmZryAuaZXZvTlEEeWnkB5zl9PALgegxa132ucnQfZwFFXauKy9mOkajR5GEhjupVNIhYO1hj8pEOFWQ2dyzpMEQBEp7BivgMRhhT+SykaQVUlK2NxIPRlQN8cWC+13iP3x7pi9kINnMroBvejGJWEvFYUWXjhSn08LOBQV9Szd2KI9f8YbiWqYixgWKTJLsl1HOUWmNSQSY/ReQuRt8xmDKqM0YGCnZNpJjKkBHzEEBNuA481paS67LlLdFnv+EFY6NeItCj5zlo6O1sfbW8OBfBaBv++yAoSNz94/u1aeq5RD64aqdXVLNOkd7UZb2qLVFVrZimp2fVzlZo5JuhTSIZKzNEbFTjK0qpfpyEKkSW/JEpobdbz8Lvf24q27d3lls1xXs27Y8ebhFUD9h1eEV/MIqP6FJ+acskIb8DcTri3JZp+S/nLkDuOHXaPq024A8fm+wfbObw72quxZ100EflPYTf9z5Lw8VYUySkGkQAwoMd5CG07wGQgA4iGxq
 4bdFKTUT
 HFfhitK8U8eNAmMnAGHfRLsitQUgNMnOzSobJ8hsXeH1xASx79qPpYEyPCONSWjDRsnOk+S+TcID/fgiGR/j+t7UgG0zkgjANDtXzkntnu4w0abFTci3wZH9xT7SRvkeZyuvDQdnZKs5C5Kl3RK3kHgWnfVFY8ne3wU/S/YgOdUIGqFTVKapYXpvSs9bL2ufz22ba34DpaZWG4mWz/NrOjhrw/cSjObNpwJTLbz/JMqQjeufJxuzHCcC6g3004qBeC4WowrE8SaOHWvmLktX4grNTj+dsAz+D4R43oP4KL0DWmXOAK+9YvHwk/iD3bWAv9Ds82zQOEO0HN7Uabyssf/OhrYKmjuo4WREdHgReVkp9z4DpBKi5PCZ4SDYnpEgSZCY8vHEWhZKEpwtcdJRC1qrMRodMXl4HBOtr9VtQsUiKRcAF4yNJwoYgxf8OYp4xdTDQt1u92LAWhyuKR1rHBzNECb9xqt/QFItx3dNrwDtg45y086T7iJjTMqcmrS/lcU3V
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In production, show_mem() can be called concurrently from two
different entities, for example one from oom_kill_process()
another from __alloc_pages_slowpath from another kthread. This
patch adds a mutex and invokes trylock before printing out the
kernel alloc info in show_mem(). This way two alloc info won't
interleave with each other, which then makes parsing easier.

Signed-off-by: Yueyang Pan <pyyjason@gmail.com>
---
 mm/show_mem.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/show_mem.c b/mm/show_mem.c
index b71e222fde86..8814b5f8a7dc 100644
--- a/mm/show_mem.c
+++ b/mm/show_mem.c
@@ -23,6 +23,8 @@ EXPORT_SYMBOL(_totalram_pages);
 unsigned long totalreserve_pages __read_mostly;
 unsigned long totalcma_pages __read_mostly;
 
+static DEFINE_MUTEX(mem_alloc_profiling_mutex);
+
 static inline void show_node(struct zone *zone)
 {
 	if (IS_ENABLED(CONFIG_NUMA))
@@ -419,7 +421,7 @@ void __show_mem(unsigned int filter, nodemask_t *nodemask, int max_zone_idx)
 	printk("%lu pages hwpoisoned\n", atomic_long_read(&num_poisoned_pages));
 #endif
 #ifdef CONFIG_MEM_ALLOC_PROFILING
-	if (mem_alloc_profiling_enabled()) {
+	if (mem_alloc_profiling_enabled() && mutex_trylock(&mem_alloc_profiling_mutex)) {
 		struct codetag_bytes tags[10];
 		size_t i, nr;
 
@@ -445,6 +447,7 @@ void __show_mem(unsigned int filter, nodemask_t *nodemask, int max_zone_idx)
 						  ct->lineno, ct->function);
 			}
 		}
+		mutex_unlock(&mem_alloc_profiling_mutex);
 	}
 #endif
 }
-- 
2.47.3


