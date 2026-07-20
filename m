Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D010CC44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 19:36:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CA706B00BC; Mon, 20 Jul 2026 15:35:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65A966B00BE; Mon, 20 Jul 2026 15:35:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 480E16B00BF; Mon, 20 Jul 2026 15:35:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 10D776B00BC
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:35:36 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 95A25A086E
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:35:35 +0000 (UTC)
X-FDA: 85010159430.21.E2D6C8D
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf25.hostedemail.com (Postfix) with ESMTP id CF81BA0012
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:35:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="E/FsecuJ";
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784576133;
	b=rREs6Np+xSRb/tZudNf9Zlfu+7t4XSdTaB0LX2AoPkJbOssrHeyaHbwlTmDrPGUGGzK4uM
	V2StwpXS9n4FJcSXv24NWhFpVh3VILgtFodZF4tv5j/fu3GQcXWCwvMwCOKwrC5e52gDqC
	YcTFL/Y9xXQRNGtGIIHFnGL6gO5QqSE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="E/FsecuJ";
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784576133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+bbISnSBqmxoccJ9u0omFuHBSz5EtUsg09tULZikjEs=;
	b=qJFyrjHObpt3yoa+bU1DkNjatCE7YnUfiayT6/GSJs+V0yVSA01hNk+1vAi5B2Qsab2rYe
	6wxGIHYIuoZnsQTpp+HS89fnA4nlMiCfrLqyuo/a+vyU6GRktX60cxSraCXCaJjuMnv9cX
	hw8Y5rLj5BDO3rwlmhlbiYidFz029q4=
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-92e5d50b0dbso540132985a.1
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576133; x=1785180933; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+bbISnSBqmxoccJ9u0omFuHBSz5EtUsg09tULZikjEs=;
        b=E/FsecuJT7uBvT8wOC10pNqN6a2J40kmnSrWJBLgeLjmAX7bk06nyV74GUcTFyIdAe
         kGvMQm/2heqnmUVID8t71DXYXfcfTYGyJGX+sQaUS4KQJT52TfggNU3eysohb0Ewv73M
         R1oze+Qqk3DRMrKwDbOZ2RxL2s913Ce5NUwL2ORQBbM1yV5Z9YEPFXJkGmqm74E5JDoX
         6ZposgVkm+t+KVXiZdH8Mw3VvlHZNEBJpWXGWHc6hjWyI87u+zl6XvsEtE1ym0P4UdCD
         KUEVZf8kVd8FEYnawZ+H5gdHFCgju7F800RfzNP1/Vmz39fbBmPCYXdvzTAOlkJoUC8V
         GMtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576133; x=1785180933;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+bbISnSBqmxoccJ9u0omFuHBSz5EtUsg09tULZikjEs=;
        b=CrNgLn1CYmXT7Otli5+voUApOHkn8wch3WSIPgzeVUrSl5YicCrPwugY+3TEVLDGV+
         K9GGHj0WkQSkGJtWHccXN3Dka/MXq1jcTeaVoIh+HR0mOuyN9MO0gWrdOjhyQ39aWIsK
         Eaay3dghPpPuby3825e44vtNWK+9tW0yrFERmSqutuCdPuDsmsf0My1Jn0s7H767ewOq
         v7b9P3ldM5wqA8Ej5NqMyxcShOgmOqjMJo3lAbKVy5Je+Uafle3tPwyW/BNikh7PlHp8
         ha3nRqnsSccXUACAG6TWHSmp4nuUBrNainqo0lhqYRBUapW8d4mhrJb8jq7I5Ez2TUgG
         CTig==
X-Gm-Message-State: AOJu0YwXKBB7MHOmYl72AJB9Y6uB2t0qWhgaCkoOpvdJa3ub6yymBl9c
	nXWlu8fexDVSb0cYiOZbU5I07vW/HZ18QbHpWCzuF8KiKp2s2hFgwmvVYpngX2s41Ouo+OB5YE0
	zlEAs
X-Gm-Gg: AfdE7cm1dzQmY0UnXqp01htXZvXYnDxW2DCtwCIZkEj5hgoKAlniJKHa/yKZ9g+ig5i
	uVrP2pKmMIYoxC5n6XTIDBjKZ4j6IryJD1GdfTk+KU3FyuxR8Tfw32HhawbQKA0bkFVUOewC4Hw
	jJhQCenXsOALG0VZHaaeh2ovQVhHjaZ9aUaPUBvvI8F/nAhYajROCihkH9hm4MjG2c4tIGSNg8x
	A5nJQEN0444CJQvfpazRO6To6GdtwRz4LcYs5WtLz08kFi9C++J5pNPgQprxQvIZmTakoksfKRH
	SvNaQQgAoZ5Nyg1jtHnGUI37r2oEVw05xGUo+16d1JbRhuyZl7I+gAKElVmQDSd+sBYxog5JpSf
	2hzV+dwujh48Jk6INCEmH8AtavBbnKvtyq2uiab+EBiasvuiVgGMwm2OjJ/XOgzlPrJYk2bz4RN
	1mjLSv4u2+wajLDlVqQL9sra9LUzkbEZQqQfCtQ0Gc9sVk3ibWTKpvGpIEzDURqB0=
X-Received: by 2002:a05:620a:1a21:b0:930:9afd:e98b with SMTP id af79cd13be357-930b434f8d4mr1589642385a.88.1784576133081;
        Mon, 20 Jul 2026 12:35:33 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.35.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:35:32 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: Zhigang.Luo@amd.com,
	arun.george@samsung.com,
	balbirs@nvidia.com,
	brendan.jackman@linux.dev,
	yuzenghui@huawei.com,
	apopple@nvidia.com,
	alucerop@amd.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	osandov@osandov.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	pbonzini@redhat.com,
	osalvador@suse.de,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	sj@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kvm@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v5 21/36] proc/kcore: include private-node RAM in the kcore RAM map
Date: Mon, 20 Jul 2026 15:34:15 -0400
Message-ID: <20260720193431.3841992-22-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 88rsgpgnffkthtt9eooj97mtu9yz45sf
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CF81BA0012
X-Rspam-User: 
X-HE-Tag: 1784576133-849953
X-HE-Meta: U2FsdGVkX1/UqveFd+5zRjDNKYmIlQUqPZUSsoTCWclSuvvJqGVRnesIR61OseubwM+9HPgT07L0qwEMj9lzT4u+dLmnviE/ZxzgWquVVlNJqmwqMcZxihBCNbtGXUC034dvzyZVds4mIp9052d2Mm4wpw9b/rMEpx9DEklneXTSIKQWYX31cZtlQl7heWop0rXdk+XiUCRabPI0BMLBU0EGOAkL6gDpcZQ1Y4b0J8uqCnknCNLxEEsK1RC9AkcAAs9H5+HNTp05Kco1fDlcgRZc/SikR8AVkHbS92a7AmXsG6ZiX5J+iN5DBmtmPn+yg1JBU/z3/CKaSR7gF8hf6+Y0jn0EoBQqMRJUpeBd1xWH/OLPJ1eHZR11Nx2VD8TkJ8kQjZgg6v7civdQIJlSFHqb3oJrPL9NU6/CAjORu1PRLD3BEyJeSNddjt8vxYLc/iUxGipionltNJ662/GX2viywBxnGFPOZSFYXbhi+E9Ezp1rREgdtir3ipZjnKYvrn6vGmT4UYkuG1QR29l7+JKRpekEULMhnynzunZ47L9SN8L9JLi2dUPMAm1JtPUum5JM9sitCrv3PHUeKj6IE8vIKZDZtbNc6qGFS0USlHkA3cDbhK7XF2HIaZnh9r3Ka9EVa9mphIkUObpt15a7Xa3YcyncRSz5TI6msU1ieFx2Rf+riCKfGBDi1eY7S3Cy1+yxkugd2h9QsoSid79uJNxw6TFebKsuJoYpc9QH59keR7hbyvlLOuZs+gI1AeWDc17r8ZYtR/pUeNODRJcumveJJADchL8cK6kPKSi2IyH5t3lyiFQl1Zngs3vUWB4wqyigiX5UErB6yM6gBTlhBALpFBi5xMYzPkTrLD5QKIHRtM1gLUuAOGRajJS6VmZtycPVgPgzeajvFUdMzt2V5wLhMwBbdqevZ5J/xO1uvWP7CA9KsQPiNEd7+yD7e9OrF85PN0PPWEx8NWfec6g
 /G3YenCe
 e3ELD3Bg7fn+dRpxiM8O10GU4AIsZxFhPTkPb2Ruke3gTwSgTfI+paHuh+1rV1NglxuvBV18p+XmRgRRMsy/v63aAKx7I7pTRZM9QMCJRheqsEKi/RpQ4cmZnUDELd2vH8JKS2Zy5YHI0wOjBq5H8OJ1IFGURwo57X1BgDHh9SJLLR26RbEPEugEL6xxS4SAhNNpxgLLNivNfXF1td2pBM3416P9u6qSe+7+1LLpZTXc/AZn8tsSrrrAB3srVTSHnoGHgS3UZoOjvejtZx0d4fEdkKWl/VrMtOfOJuKlH/qzzr5zeNeAs+8fOC07HxsjqswnMG2UxFaorzsn66WOp9po+08yIw0rtZMncHzVMLezGjYkCd7twF6/c3UUOS/sMXdvx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The kcore_ram_list bounds its scan at the highest pfn in N_MEMORY.

As a result, private nodes placed above the last N_MEMORY node, which is
the common case for device/CXL memory - is truncated out of /proc/kcore.

Include N_MEMORY_PRIVATE nodes in the scan boundary.  /proc/kcore is
root-only (CAP_SYS_RAWIO), so this exposes nothing new - it just lets
a debugger read private-node memory like any other RAM.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 fs/proc/kcore.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
index 390547b992acd..f67194dc2a9b8 100644
--- a/fs/proc/kcore.c
+++ b/fs/proc/kcore.c
@@ -251,11 +251,14 @@ static int kcore_ram_list(struct list_head *list)
 {
 	int nid, ret;
 	unsigned long end_pfn;
+	nodemask_t mem;
 
 	/* Not initialized....update now */
 	/* find out "max pfn" */
 	end_pfn = 0;
-	for_each_node_state(nid, N_MEMORY) {
+	/* Include private node memory in the scan */
+	nodes_or(mem, node_states[N_MEMORY], node_states[N_MEMORY_PRIVATE]);
+	for_each_node_mask(nid, mem) {
 		unsigned long node_end;
 		node_end = node_end_pfn(nid);
 		if (end_pfn < node_end)
-- 
2.53.0-Meta


