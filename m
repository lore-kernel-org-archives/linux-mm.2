Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50410CD3444
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 19:30:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98E878E0011; Wed, 12 Nov 2025 14:30:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 940398E0002; Wed, 12 Nov 2025 14:30:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8071C8E0011; Wed, 12 Nov 2025 14:30:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 69EF38E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 14:30:00 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1D403C05EF
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:30:00 +0000 (UTC)
X-FDA: 84102945360.04.560D102
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3DE4B20007
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:29:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=jPsbAhRE;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762975798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nze/QytclSTH4fFVa9JSQZznz6m85tFFzurTQmWSt3g=;
	b=p9HgcwBr1vMVM1kMxxlV/7QNVqtVYkkiskKbgpPes6znQqRPQ7ishX8npO8p8fE9V3sbfS
	B+pUBAMXD8hLSwmevEtoqXchaZQ9kRtsO6VKrdjOeyM4vWposs7zK5diZufGWFkP2c/DBE
	p6OvarYhjm4t4Zwha+7munV9yABPBhI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=jPsbAhRE;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762975798; a=rsa-sha256;
	cv=none;
	b=bymEHnPIZ2IWbzWQ98AYBzTF57wNPD2L9Wa7UubiESmjFclZ3ZXwNiN4Sja7u965st9ho7
	dQhm41u9pJSTJVOgBIFkO9unLFKoaNNZzP7LUWgqcJcHD2R2VODWkpZO+i7g3JB8WBvxZC
	1dqVjphhuDN2CtwklDWIgFb4NpEWqvc=
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8a479c772cfso4405485a.0
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 11:29:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1762975797; x=1763580597; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nze/QytclSTH4fFVa9JSQZznz6m85tFFzurTQmWSt3g=;
        b=jPsbAhREtwhHYesdM6W2/Bj3UI7cYRIz13FVoLUF1loo/Y3CGgAUu95ajQYqPQV6Zl
         iuUu18Jp/bCottNgPNnkwtJveTBV+y2AKPMWszgN+4Y95ehB6Hc3/ZUyKXymg8QzIBEY
         eCi6nkn07el+P3G9R+FPbW2jxOxysHJoHsMWkirUc4d9jOaePyMaSn9k57RjfX+5VAw4
         WWQ5H7qYgElK5hpbNCN0Quew2yxDE06C963dfhsvB7iby2FRu3lQHPhen6bqM1VhPzW8
         kw61EINQwX5lNprxgLdtcbK0fjcrRYbGO1+kgoqseVyALMB+c7KYGkRWcD9zCo60XxJG
         1rxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762975797; x=1763580597;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Nze/QytclSTH4fFVa9JSQZznz6m85tFFzurTQmWSt3g=;
        b=nOvbWCqVtDn5875UZo7nW3aV+N1XI1bi8FK5te643RCf4CwNQOkLRcmCWVVEim3i8k
         BZhL6IMq3iRxO/Un5pr35PQouzCaIER1lEAABQurdvmPAUnyDAyKiiODQ7+Czs+1LZIu
         Pvw6qYRa5Fa8pRAM7wO8Eiwo0l2AxS6YwvKHT/NR/nVOwHMiU05qwHF18xM7xvRRIWSQ
         6XvWFj4HvQ+iw/2+Z7qxTQwhhZ3Mw8kUY8KWUuWikVuESJrfjd7IbHBzbXPYMo5WQB+L
         XDWTzmOUWFDEnMHVt1sOnmfVvwqNfeaoS2rGsTRJg9M0iZhufxU1uQjwYpFJ5xbmE/Em
         OqWA==
X-Gm-Message-State: AOJu0YyXthWSA4Xudh8FW2tO3zdlEgA2UJhS6Y/EMju4kWhph95vycy/
	xZscOcYu/slri4KvQqXEGtyYX9zqYPZUR4ioIJpmIUqrYpvmYkkskQI6uzH8n4I+g25j0TetyrS
	etpxj
X-Gm-Gg: ASbGncuwYhWEY2d0ilqeHRk4DtDSa5R2+m0N7pE7QhRZvfqrV/nVZrbV/hUOhJlmVhl
	xk6jJlKtDvcW7qMVXv53Uh3wikFp1SGYEjX9f3mEqQAulfe+0WmzsrxciAS1yBXRKmBtVscXOI0
	ruP7ge9AfVwdlCdgt73cCKT9646+BChe+DjtUinCtD4zLwcGH+S8M2oZ8dDWvhF38X/dAXgamJY
	h9UW2sohkXZQyECk6cXd2QNDVMvHZSA+V1Br5IqJgtsHux4Fy+ILTSVkA11vM/3L3+N+kgJLCZ4
	N86JA1LJJn1tABhFC1Q3EJNzjdoB0xna5GoGnQO7xlQIzPu3iTI1/rTPd1xIckkE/cUMHSzB8dz
	dpJ8wCZxM2G87NiuvC32OQtIBygM41xIp3RgVY3Fo9alMJorSRl7uiCXkvMZ0AIX+7R0bjjZ0L+
	5o3I9/veEm2bMzKBy2cwNf/9smaA/Bn3d3QGhNgUhMmArAYtIpoY/nX5VAKQjzMqHa
X-Google-Smtp-Source: AGHT+IH1lDcByGDzgs1svKTRXfQs8NRaQexk4Q0+NImfdOthU+jf0vqFA5hw/PqFsiRTGmnVj1m8eQ==
X-Received: by 2002:a05:620a:1a0f:b0:890:2e24:a543 with SMTP id af79cd13be357-8b29b77b3c0mr590594985a.34.1762975796840;
        Wed, 12 Nov 2025 11:29:56 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b29aa0082esm243922885a.50.2025.11.12.11.29.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 11:29:56 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: kernel-team@meta.com,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	cgroups@vger.kernel.org,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	longman@redhat.com,
	akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	osalvador@suse.de,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	kees@kernel.org,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	rientjes@google.com,
	jackmanb@google.com,
	cl@gentwo.org,
	harry.yoo@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	zhengqi.arch@bytedance.com,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	fabio.m.de.francesco@linux.intel.com,
	rrichter@amd.com,
	ming.li@zohomail.com,
	usamaarif642@gmail.com,
	brauner@kernel.org,
	oleg@redhat.com,
	namcao@linutronix.de,
	escape@linux.alibaba.com,
	dongjoo.seo1@samsung.com
Subject: [RFC PATCH v2 03/11] gfp: Add GFP_SPM_NODE for Specific Purpose Memory (SPM) allocations
Date: Wed, 12 Nov 2025 14:29:19 -0500
Message-ID: <20251112192936.2574429-4-gourry@gourry.net>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251112192936.2574429-1-gourry@gourry.net>
References: <20251112192936.2574429-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3DE4B20007
X-Stat-Signature: 4oixfqahtgie375brr4utnrwknji4sej
X-Rspam-User: 
X-HE-Tag: 1762975798-486142
X-HE-Meta: U2FsdGVkX1+DidqrChnYHNFA8BEXLJ9JsiI8nLCeGmJJGl1cxBAj1N71NJ5BfS56hcSEC4fOM34nESoNLDRP/Guz/InHAMCI/OQWWvFsbZbzLy2TSqbtoYGNmr3DEhnuIcsZ0jhFaAxOqhhgBk3IsDKWUVkAzI1UBLU/hKXEV+ccugbkSAgWbqg3NfYijIeRyx71LNC28kqEAYkDgU3kWj9aV4KPdUEaJDb5suZ90CU1fL149sIYIa7F4RaoxHo/leQjWuRfGvmLkWDzAHTt+YZbPeg7HoMb/C2wPgJFxCUfbXrAkl+gfB7CIA0G942Wdsiv+kcUBN2XSeEs91hllcvHjVA5qBAymDgncC4dM+K2NuOToqqvDVkNgKVb+s/r7wMiTXDMviD1a08j0HijIr/pN6c2xbbNnz0rUFKd/yo20Pjh1WOV/JJdWEO9xY5wh4OaZpnt01XRttpdab/YqoFcTIehTML2zk5hAqJdLPUbUnuJDiihHA7O+68h0gV7ArRkWNUg3x4/cwalb4l69pDOUuweXJM50hAJDOh+x43kjrxnIakId63jbD31G0KFez/rnF8sP8kq7GPwViMNkeSLcVgU8LAc0kCi3gPN4Sz/eBq/hanjttGszB2FNEOXZFwrnTcqy0b+jRH+B8s/Z00c52HvvCdcStTtTfPvXC87syjihW0kbPGVUZcfAjeriCiPuWvRzVgR8RMSRRxPrYHMvGF+VXA6mcCnQvCxMqsArqzvlIae5lcV+Tbb3PAEsyckTCH8sxisI8GDzq1ZhA58kTLITGVPyOmusz5GO+WvPhgOkWwp8Wc60h/N+t7mztCAVM7LLVzSooVZ6xhF1eLClgoo61asjZC7zJYYQVx7xV2LphPu3myqJMVSneRfzDjLlY933ph+9UaLBDa+NY5ickztiiu2ERtVfJD8FAMjtw+n5fK2vvdzR6ySxt8WO/F9RXd6wUhdRguWQf8
 /hG40OmO
 W9D28G9ViU+dFLzYqE9QL3m7rAGUmruPi4SOdb56acW2vlFLr/zO8gdi05jMlQxQyCWK2DXl7P+bSMAjfeeEQDVesMubKvTCg1eFIaNKa2LiErKcwDTKpUlAUpDJ4ur1QnXyfhIZ14J5EnTdCowVMWUKH6udrECGHKRckitrumk4DWZ0RkZro+7pdTDpyovEqD98/wT40GpzTiXNZOy25wc5ab6b4FHt5rEWPNDCUBMTJTYVBtN1Sc+ce94s6hzL+BRMEAhTv6zlxMW5Oq69DBWa4VD9gs1PJcLb+Kj92khN20oaRkvcjZiqzwVf9zfzv2OI1lFYL2N+gSPOxhO+h68F50i8IzW8LSy5ScQjP5yjaeUN/3iljsSPUdQ2yB6NorFwBEGf01DVKIl2Ut0fEEBZBI6pXlddBdF0DFl12z4DpKkIgVziLOEXBFLHXl/4oZvIgc3rZu+1yhpM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

GFP_SPM_NODE changes the nodemask checks in the page allocator to include
the full set memory nodes, rather than just SysRAM nodes.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/gfp_types.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
index 65db9349f905..525ae891420e 100644
--- a/include/linux/gfp_types.h
+++ b/include/linux/gfp_types.h
@@ -58,6 +58,7 @@ enum {
 #ifdef CONFIG_SLAB_OBJ_EXT
 	___GFP_NO_OBJ_EXT_BIT,
 #endif
+	___GFP_SPM_NODE_BIT,
 	___GFP_LAST_BIT
 };
 
@@ -103,6 +104,7 @@ enum {
 #else
 #define ___GFP_NO_OBJ_EXT       0
 #endif
+#define ___GFP_SPM_NODE		BIT(___GFP_SPM_NODE_BIT)
 
 /*
  * Physical address zone modifiers (see linux/mmzone.h - low four bits)
@@ -145,6 +147,8 @@ enum {
  * %__GFP_ACCOUNT causes the allocation to be accounted to kmemcg.
  *
  * %__GFP_NO_OBJ_EXT causes slab allocation to have no object extension.
+ *
+ * %__GFP_SPM_NODE allows the use of Specific Purpose Memory Nodes
  */
 #define __GFP_RECLAIMABLE ((__force gfp_t)___GFP_RECLAIMABLE)
 #define __GFP_WRITE	((__force gfp_t)___GFP_WRITE)
@@ -152,6 +156,7 @@ enum {
 #define __GFP_THISNODE	((__force gfp_t)___GFP_THISNODE)
 #define __GFP_ACCOUNT	((__force gfp_t)___GFP_ACCOUNT)
 #define __GFP_NO_OBJ_EXT   ((__force gfp_t)___GFP_NO_OBJ_EXT)
+#define __GFP_SPM_NODE	((__force gfp_t)___GFP_SPM_NODE)
 
 /**
  * DOC: Watermark modifiers
-- 
2.51.1


