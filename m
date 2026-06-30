Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44EB0C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 21:19:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A4836B00AB; Tue, 30 Jun 2026 17:18:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 607616B00AC; Tue, 30 Jun 2026 17:18:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F6A36B00AD; Tue, 30 Jun 2026 17:18:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EC94A6B00AB
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 17:18:56 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6954B120115
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 21:18:56 +0000 (UTC)
X-FDA: 84937843872.16.819A9B8
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9C3614000B
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 21:18:54 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=VYWfR6c9;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782854334;
	b=PHaFcYdF++qxcrobDTYa73YzMPrabZ0QcN5Z/bkKVeuhZSXbfiVzCycgPz1qo3tVhrGRtv
	pVlnpC84QgMiOOQ9iEoOLPdbUXi4/QwGJFVV5b5xEhD4H22UYXzmIk8tHc18IWxr01B77c
	MAsMKYefATK77pDUn67tFQCRXV481xI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782854334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BKwO5GGulWgyuo4GgOfyW93Razp13/peNYJDujzNXk0=;
	b=2pBy+vSY1O2+/bdUuGYcUiVf8WMDykoyjarjXuo+nmDIwI7nGeRI3oN9dE6x9joUpFH1X+
	vDIvWhHhCs56YA1FapJ8ScSrnDtQA+VROAPQYoGCt6kTyRUM3fjG2OUWBigCUodESLjmHX
	Ffp2oevcPL078LueMPItK1UtrWqHlwo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=VYWfR6c9;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-920f33347f5so444279285a.3
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782854334; x=1783459134; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BKwO5GGulWgyuo4GgOfyW93Razp13/peNYJDujzNXk0=;
        b=VYWfR6c9impwLvoEjaGIIOHpi5NRNvrPYCwclGU8A4rx2FqFIqplV9NqRHtGGUeUnn
         rkxMBr86Th+TeFIRHUSt9DSyxo5AKuCRRppSpFqrFDAzReMvhvIN9hEj7xTu5r4Hapy7
         YHiayVjDe9utnlIXZAReqy/6keFCQbjtyUXTh0Ey8/IHVdyaL0tUeAVcOR7VHucRwRBy
         teynGl4OTVRcsjz3RRIe10DdDvBx05jYg8I36wdtaV0rdczsdZNm3FCwIA7u9lwUkzBd
         pzrkzuakOBu1q4ixcTs+7kOw0DmGdtDe3ES2KjKhidnnL/QJguCGJk3vIqenI9O6J/eE
         7eOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782854334; x=1783459134;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BKwO5GGulWgyuo4GgOfyW93Razp13/peNYJDujzNXk0=;
        b=pOkDagRzh/2uJWvRKuMOFKfZZiF1tJBJUJ0OVw37x9d1loUCVSQCa0cL3k2Qvs8MW/
         XstXvIU4lf4NEHi7jaxXpZTDb7Qs3TFcVLZEd3iiRhIwC18vUSQkXwLsQhVPWOAtl1UD
         ID53v/t8kyNKk2HZi0j3b5tok+wYiZq1V9z4vpyYRYe1YBC+UhFBbHYzXdhCwelLiRCc
         I1sQufx89avYLaOG3FcbLV/MWUrIduTE6Jdg5IPzgZK34d4fgX+YtTDoDSVvXO9Md0EF
         64A9mFqn/Jsyn7tm85IQbNay6XdM8za+TlzaYyklzdugmbH6iBnAaHN9EtcVJx8xuD4N
         vrmA==
X-Gm-Message-State: AOJu0Yy/buIRkl7bpomdFJtYrXf7csTvv8Yf0T4Q+SqYb1GfXDBI824z
	3se5nQNON2yiIw7ig+zBtRj8W9A3Eq6qZiC4lHYhbTeBsZoPBDoa/Ijhw+qRq6EkLtM69nFqiIZ
	Nzd8b
X-Gm-Gg: AfdE7ckzR4R9coj1D/ACIaWp0VnirZRBYxvweDfQE0zqIpaAhIWRaEirfe7iFctUG8t
	mSDZQSVpjGuSp+NuA/u+BwqjXYpJJMMy1Ulay+G5nDI4NnxAGKAi/FUoxR7G4wLBm8SwZ9ABPKA
	wZdt+TrBa/lFFNdxvva3NMwKNuSqopNxfpfppAtsEu9r8XMaGCcDLxDzgiiWHH/HlERESNwe1Ip
	dUbTuJuvQ7dzX7S5YmWyFzdIu5YMhK0XTx7KQDtrREMm7w/3ZiYePxNnzmTaSGNKxv7wYZvIFdP
	9qK7pIqHzSKZASHZtDybdSPiZ7QPZ+RCkl7eL9N5Bdqtg25zIDj0Va46cg9Tj3wOq6p9eIUKBp3
	K/lgB1vC+FbOyAKW/MQQ6C0AldJItg8PS16iqdTxClc1c3Op5zUdXmcwfgadRTH/bPzaH/+5jHu
	4ObrLcgQkpm8DLOYI71dZxH+qfT+dIY/HYpTSwv9iAe/9qhQqAHtBFgN4+HE/3ytszeUDHH5YLL
	A==
X-Received: by 2002:a05:620a:8018:b0:915:8f76:8005 with SMTP id af79cd13be357-92e6d8bc859mr391991585a.47.1782854333767;
        Tue, 30 Jun 2026 14:18:53 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e62366303sm335924285a.40.2026.06.30.14.18.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 14:18:53 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com,
	david@kernel.org,
	osalvador@suse.de,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	gourry@gourry.net,
	iweiny@kernel.org,
	Smita.KoralahalliChannabasappa@amd.com,
	apopple@nvidia.com,
	Pankaj Gupta <pankaj.gupta@amd.com>
Subject: [PATCH v6 03/10] mm/memory_hotplug: pass online_type to online_memory_block() via arg
Date: Tue, 30 Jun 2026 17:18:35 -0400
Message-ID: <20260630211842.2252800-4-gourry@gourry.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260630211842.2252800-1-gourry@gourry.net>
References: <20260630211842.2252800-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9C3614000B
X-Stat-Signature: s3bagp1cc3msj9e7nb89k37t8dwta9rg
X-HE-Tag: 1782854334-339192
X-HE-Meta: U2FsdGVkX18EzmsunxIehpBPlTw9LBf5AI56gwU+iC9zUGtbEzyC9YWSxiVFpS/b1UE7Xpt1Iyt/UmZejCsFGdzc3KbhUrKrBRvDob4MU8N8iti8HLuXoFW7OiOSOLL9eU+xPQuGqvZpFjU2knrJYpVwed+QuDnw2usUEFftyB6RXpYsmLQXErwxWmmVjzDVigaq4RRMtopvwAsr3Rlj31jpW91tmDk55TCthIfkd+bLLZOesYjalHc+xwk3jt/69BvDfZcln7Et6b5Mape38HcX5EmX0PlJFk9zKQ7bI6JpzzTLBFAhsm0vDfqD2cfuWeculZBD3KIyJ4yMBX+hf8Z0e9UQXAyrc9Hpb/dd3wqoBMz2KqPPTqfw70eK8YGSbaisH73DBRx/TTqYF/UwCOPSs+rDFncHobQhw6NyWPoJxX9eWcK1g+sxStH+KIC2QSL+UYHX9JBGS6o708hiPU2qSJtyRcpWagqSOHWIoNeeSBDQI0kzikq84Ryvq6B5GYxnumpqmcOa5HNcbZXVFVi4k84ZD+mk8epo/97yNZz/tzI4lWjqCqDyUlBrBI1jdPiiLQMHtnTh+z6VefbLkUDH9ImFDUAx7LG7Qgf6ZVGWibPdpQl7m9zJjCmd9+IzStOGMVA6jMj1C2L2k6CQvwCglSG++sLpMg3D6IEEmUh4sUrZWKA+89wfjVStNmZnCDumuCLDh2ElYmRRsM+Vy6+RCgjG0EZ16Sl+ovq2s3UItOJv5E0tbVi9VUNFsz5F/b6ChIdwUn3O7q17JC+BykwpaidlMQWdDxCLh6l5cur7FmUxWzMtojmhYbmb8PmhZ/zUIPGwyLivxu4vTTe07ow23MIyyr50qRzQUup0DAZJGFYqubO4beQ8YEKeM+cvy7fBUZNbODESUPUD2d+OKjCClxhNf0aXKORGtjCOWeiWN/Bs4IcYweYHmffdPvwLr41SweLKnmX7EgoQkd0
 /NgkAKQ9
 9hsoS3qB1PhdXdh00iQm+6CstQ9W70Loz4z8pWb2IzVhj5PL6liJ7SYOZ6hKfyO+7dgoH6OA8MKThodlmUxlBgVV5KZeaCDgjGCAP9JKvuymAnxlnRYdcHGgAoegFdMGNU0muAVmhNHyBZVKX95PQ5LvVw3WpGHWyM77eHZU9pnfWMx6nD220ymLR1vpiirC40VozAvHywmlcVz3TQfbHFvzU1agIbujGkuKUpfbQnHkhpfo+SLfDousoxE03RVHZd0h4NdB002NOkxYsp5cGjM5EUnmJzk5a6Lbm26tV05FEIjL03wV6iNlJgmVHoEGbuKlVinPWyD2rU6vAHpe/ohqCCwhSlCRzBQyTYkCyxdpIAMF8jrKwX9AslOOlwO3EdGtTn1vlANux1Pc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Modify online_memory_block() to accept the online type through its arg
parameter rather than calling mhp_get_default_online_type() internally.

This prepares for allowing callers to specify explicit online types.

Update the caller in add_memory_resource() to pass the default online
type via a local variable.

No functional change.

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/memory_hotplug.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 7ac19fab2263..6833208cc17c 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1337,7 +1337,9 @@ static int check_hotplug_memory_range(u64 start, u64 size)
 
 static int online_memory_block(struct memory_block *mem, void *arg)
 {
-	mem->online_type = mhp_get_default_online_type();
+	enum mmop *online_type = arg;
+
+	mem->online_type = *online_type;
 	return device_online(&mem->dev);
 }
 
@@ -1494,6 +1496,7 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
 int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 {
 	struct mhp_params params = { .pgprot = pgprot_mhp(PAGE_KERNEL) };
+	enum mmop online_type = mhp_get_default_online_type();
 	enum memblock_flags memblock_flags = MEMBLOCK_NONE;
 	struct memory_group *group = NULL;
 	u64 start, size;
@@ -1582,7 +1585,8 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 
 	/* online pages if requested */
 	if (mhp_get_default_online_type() != MMOP_OFFLINE)
-		walk_memory_blocks(start, size, NULL, online_memory_block);
+		walk_memory_blocks(start, size, &online_type,
+				   online_memory_block);
 
 	return ret;
 error:
-- 
2.53.0-Meta


