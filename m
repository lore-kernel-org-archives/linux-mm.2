Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DF9ECCF9F8
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 22:50:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA3328E0023; Fri,  7 Nov 2025 17:50:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D53E48E0006; Fri,  7 Nov 2025 17:50:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1C1F8E0023; Fri,  7 Nov 2025 17:50:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B31968E0006
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 17:50:09 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 67F00BA402
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 22:50:09 +0000 (UTC)
X-FDA: 84085305738.05.553D9F0
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9E7F7C000D
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 22:50:07 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=OP58clBB;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762555807; a=rsa-sha256;
	cv=none;
	b=mWTW6bL0HpBM4XOhw1qp+JwFH/6p6BYkGcFKT7IACv3Ub4mxe4+F+u0yENYcUhYJBAJaaK
	O+lYObQLryJlh4iYgu7SLzx8OOCuFj58I+Voosy98EYB+H6G7DnRIOQONLOu+lT+uoWZ2W
	l1lb88xoTzfTd/MmSw2CNQMTGD+eUDo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=OP58clBB;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762555807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jCHR6ylRLZZ9pqd+jMer6/IGdndwoE5PhK5YE6dS19U=;
	b=MhxCs2d+EL4jfbNPV5cLWvvZaU4DZT02d0YK2Jdqx2eVbbhsYpuhU5zv4MyuligpneSTte
	I+6Xw1yRrqM76L/zly80WQb8yybsaxrPKdTdFstdN/xyk+S4KhmGneCDbzHZkN1nJBDeHW
	n+Qz3BvRPaxL/K7grHB7TCnjS9poJ5o=
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-88f8f346c2cso117858385a.0
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 14:50:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1762555806; x=1763160606; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jCHR6ylRLZZ9pqd+jMer6/IGdndwoE5PhK5YE6dS19U=;
        b=OP58clBB2XWJUAFIB4zEq9SopTFcHO/82+t9yCJ+TFehcjkBXZFZgXw+ZiRmWKzJq3
         TQmhACSbE4J+DZmUl1s3wQiDxMIu8l+ZMwBbJ4NRpJRDWpvlSXmK0Oq0+Rp0XyFDypBq
         PqOKmFqvF4fWjNXiZKSDqJcK1xJVShhXfuft2CqlASVN8cut2RtnZ65zaOqnIENVddr3
         vr0rQvAllOrFUrCxzPIAo2IbXEOQ/NGwpA+36SApT2RqW4fdXvHy1V203jB5D3K7NeZL
         aEXfiCi0Xl1jN7mvY3X2HLPj9UIfVh2jT0HGnhJUWd/kQZrQ89G/Vdn6s8PwRXe/rVLu
         zlZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762555806; x=1763160606;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jCHR6ylRLZZ9pqd+jMer6/IGdndwoE5PhK5YE6dS19U=;
        b=CbrtDshDGA3CS/9eSMVeCUDFIkVMwuap5C+ROCZFD9yr9ZSzl4mDo8ei4WugCwDi/A
         e11TiFq8MDH9ko/YScGfpuz1Ixi7nIlhNQ4RF1LtLbCsz7fCSEM6r80A3odUoVY9yivw
         a4BJUDIcIrnD0dukRe9x1N0JrDqQU1GF+++MMASmlhdylTt7lAeA/mdmS2oiagf+y4yW
         TewBv8NoHnnExjmwucVP4Qfn4O2dw8VQHc+L/5cbmBEFLXpZ0i0fovI/FQEmKUO1RSHV
         zPCmy0JkXDmGfaaBy72r3sS0k2iSFYrygDRiPcqKjvoj0TWTncPp3mHcWi7ozph6wlxF
         Lf8w==
X-Gm-Message-State: AOJu0Yz6e+6eF+kR4iwuar9+cpAGVTRlSQ3iblEC96Y7Td46Jii87d4t
	UZVAPCUS0nPl3CdLBTr5hzmT6oMn6zv2c9covNi9AymI2v0hrn/9wAQ0AgU7EQ5LKHB4qO7iQZj
	rJyP1
X-Gm-Gg: ASbGncuw6TmsCKBmJzCgYu2NW7rgyB4epJWqnOe/AL8gOwwW0NuCGDV0DUShp3/u5pO
	ktVoSCErg5pqJSI1J7iYoPSvpFlu5Abit3J1vksqfUFuA/ErpTYkz0Ce2iBwTB3fhEB2Dg5SbFq
	DefzaHqEvL8JJ2a/I3qDPMqhiISS3EI7SuZG1H0IioGdXksYHL8DQolK09YiYGA3ZVAeFaEtGR/
	2R+0f5sNNJ0NODkDavQa8NE6dBjT6XtQCFUs4jFOF/02QE4+aaKQNuV75WDhS0LPaTq8HjFnTRM
	d8pojepnXTbV4vIxutnNeyGiuhuCP8G+XRinFkhO+FPYrT4KCEiaCHLdhYT5414ThpLmHExaIe6
	Lq0QU4Vc7ER9qI9z+Ptx/HwOVqF2cYu0on4ZQm2oLK3w4WfHhyCeqOIw6G9jaeGIA0y5+bB+1DJ
	shGJ0zjyyYRiw7qNxWk27yBMqwwcUu9p7wnB9oQoFka1WZKxQKRuLk5o/x9KCZX4nHS+RZb96LE
	LmSuLUuPhcCpw==
X-Google-Smtp-Source: AGHT+IFFPECdAOsGcbR+MEazzzIO7MJP4xCB0/B2/FxsL9mdOEjwM8IeKSGUWcVdouQFvc3wSAz+tg==
X-Received: by 2002:a05:622a:120f:b0:4ed:6e79:acf7 with SMTP id d75a77b69052e-4eda4fa468emr10231361cf.41.1762555806006;
        Fri, 07 Nov 2025 14:50:06 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4eda57ad8e6sm3293421cf.27.2025.11.07.14.50.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 14:50:05 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org,
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
Subject: [RFC PATCH 1/9] gfp: Add GFP_PROTECTED for protected-node allocations
Date: Fri,  7 Nov 2025 17:49:46 -0500
Message-ID: <20251107224956.477056-2-gourry@gourry.net>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251107224956.477056-1-gourry@gourry.net>
References: <20251107224956.477056-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9E7F7C000D
X-Stat-Signature: 3e8koebooip6ndyg46f3tpa898cda48e
X-HE-Tag: 1762555807-505013
X-HE-Meta: U2FsdGVkX197CYI+hk/qSBZzbA6Ul+fZG8Xwtd1nvjW1fBsnQYovbUyw4oaey920NWnhjyTokoeFpoANRFkAJOmESFsRw3py6QHPga9eQcATGs8PGVoRnLJogjbuWIpn/n99FBQu02fIH5c/GGV1FDP/pnqlVbyjg0Z9PuKQGkJK8PxQDCknZUzFxafYUwXzIxyYo0Udxbi7IM6kz+cxbRiS9PVf3/c1QZr875ikG+dgaExnXgIylKY8z4AN0ozqV4cajUvRYcaZOxBjZ1zbT+fFqkHumhMPv8iqnPErNOn0Zd3ti49IjJ1W+w3JYzgzuxwCUintzA/Fo2T0KSviBin3p46VBFLI5aFuVwzq/4IgS2vj4A+dNuq7IByY/ouokhNAVQVIxrXWbNhmf/78S4yrVUB2g3PpbmbhXfgANVDiUkUdZzn2veLHtzvKxV9SpAX8rrG6GWdVHci2FPdHiDSvz0cGjkd8DlikgXfTwvnggu7o6H4FIxHwvYfiY7W3XLIs8N4pg9twneP7r6BQ7U7MSkfZLKhuEeSLFTb9bEDkAHB1jJ3QcEFsKPhrvUISbhHawFLgLOMDAHMaCpFU8PltcmZvZA/FB4O/1LZGwnASYFvCWfFjBTeRWGmIHI0DB/kw+oiOWcwgwVOLEGE3klLrj9fGhXJTa5bdoeN0zqlai0El9wtAzaFnwXuUsfleUsslzghv044Dyocp3PgA+7RjvbABXWCtJ3ulrJ8Cnk5EsOdm2sWQpF3DGxP9fIxgs1/r8Tu6vo9JbO3X7wPEEYDTSBeH0T27/Q6i47FZLkNWmV0+2LLvFJqMYrSkWIo5JF5Rz5eVQ4N/n+s+UrX04VlloFvyI67OZ2V1EsMT2/ey+jG6PVS/BAGBZkCrivRNk7wpU9mU7XlJvXqivdJO+woXfVPXdy+1Z22mWU6GxYS2dTAgMcMTGLKDUZI1VzcRzVNXvX/Ckfq9J2AF9xC
 MAxaE5hR
 Bjq18hvuTVCEU2FzgnTa0sHqyUxIY40PQYSmiL2+eRdRW8t3DASU5Y4K/zAn6HylXzhh0aagB6UxoBoZTx08ZY+oYyepO2bKEHdk3kWKjiMsW66AYIBitKxviVswT5WrHY/zyDfqttG+QXSM8e9bMIaf0Yz4vcmn4ntd/4z8UH9lS1syT6/BCTzwLz1tYFE/uhK6+7zTq/CKqaR5vqAzUiEzvclDCMxjmKClu6b90f5MBgve7uEfpflL5Ow5ClRJv94yIhXxBsU3lR2Ibms2OVkv8CAHiX5tMX5RRQ9RRL3NIoa9zBTVKqNpg08fVsGboU5H6OzpVA+p7EIl7Dfnfcqy6XCGuBXmnA6mZOpRmIdqRTJWM+qUJ78PAbrdz1zdgL5YUrGtsi0E/GWGj3TTsAxqS4XjmBH1oWzbu7TBrljt1mkYnh96vge/hIyOVDQAOBtfS1O5+kIR0yW8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

GFP_PROTECTED changes the nodemask checks when ALLOC_CPUSET
is set in the page allocator to check the full set of nodes
in cpuset->mems_allowed rather than just sysram nodes in
task->mems_default.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/gfp_types.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
index 65db9349f905..2c0c250ade3a 100644
--- a/include/linux/gfp_types.h
+++ b/include/linux/gfp_types.h
@@ -58,6 +58,7 @@ enum {
 #ifdef CONFIG_SLAB_OBJ_EXT
 	___GFP_NO_OBJ_EXT_BIT,
 #endif
+	___GFP_PROTECTED_BIT,
 	___GFP_LAST_BIT
 };
 
@@ -103,6 +104,7 @@ enum {
 #else
 #define ___GFP_NO_OBJ_EXT       0
 #endif
+#define ___GFP_PROTECTED	BIT(___GFP_PROTECTED_BIT)
 
 /*
  * Physical address zone modifiers (see linux/mmzone.h - low four bits)
@@ -115,6 +117,7 @@ enum {
 #define __GFP_HIGHMEM	((__force gfp_t)___GFP_HIGHMEM)
 #define __GFP_DMA32	((__force gfp_t)___GFP_DMA32)
 #define __GFP_MOVABLE	((__force gfp_t)___GFP_MOVABLE)  /* ZONE_MOVABLE allowed */
+#define __GFP_PROTECTED	((__force gfp_t)___GFP_PROTECTED) /* Protected nodes allowed */
 #define GFP_ZONEMASK	(__GFP_DMA|__GFP_HIGHMEM|__GFP_DMA32|__GFP_MOVABLE)
 
 /**
-- 
2.51.1


