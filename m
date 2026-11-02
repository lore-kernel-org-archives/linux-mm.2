Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F210360A2601
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 13:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=WnbDgX2C
Received: by kanga.kvack.org (Postfix)
	id D169C6B05B1; Mon,  2 Nov 2026 08:29:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C79656B05B3; Mon,  2 Nov 2026 08:29:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B41BC6B05B4; Mon,  2 Nov 2026 08:29:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 861F66B05B1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:29:21 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 06BD9407DC
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 13:29:21 +0000 (UTC)
X-FDA: 85390260522.15.738DC0E
Received: from mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0A8B9120002
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 13:29:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WnbDgX2C;
	spf=pass (imf29.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.175 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793626159;
	b=JycljwqYKaQurKqU322zBE76vQVodvsNvPyldWBYLL9pkdjYEXaute0xcxRQTJ/qkfuZZ8
	+iZeowuqBkPs/7MPZVzF4k2ueMtbRyh9G/MEPmxyyqEYaMGVMnDpmF9hyPM40G71YyczhK
	PAoJt0vWTGeg9b/3EDgFzawvHZkOOKM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WnbDgX2C;
	spf=pass (imf29.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.175 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793626159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OHnx1MWHnNS05Fb0GSs5HhOjNANQI9agb14wDojH6MY=;
	b=vEirujLSPs2UDaQ9Ns1z84UT4LsuV6P4uo02Y9rdIYiIHHqLPw8hZqLhgMDTpdND69fVme
	beqqNf7K2I+24RVb6CZA3LJ1F4zW394SLK9f4TwwpeCaws9IVlmx9jwRRxmDQlixTK93gs
	liyNT18mgY98K6tddXriRSkv1L7i4XI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=KyHJ47bSIgeXP+kKXIy59s7ywWqOI47F3ePHg/aPldo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793626156; v=1; x=1794230956;
 b=WnbDgX2CJal+tGHK4IOZRa3i/XR/cZoUYAE/mf4c/TpsYnoIPm3AAvAsWKRYO4EJ/p6eXQcG
 eGk9Wsyp2sHcipSCom5x9DApbq/7+YBKdIkZ8ujC2zmuwUviebf8RydVTdBVBQCkosdqXFm8+d3
 1MGaysJVBw2Sqb0nmrTuhjpo=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 02021b5d7b6d5952;
	Mon, 02 Nov 2026 13:29:16 +0000
X-Mizu-Trace-ID: 02021b5d7b6d5952
X-Migadu-Flow: FLOW_OUT
From: xu.xin@linux.dev
To: xu.xin@linux.dev
Cc: acme@kernel.org,
	adrian.hunter@intel.com,
	agordeev@linux.ibm.com,
	akpm@linux-foundation.org,
	alexander.shishkin@linux.intel.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	borntraeger@linux.ibm.com,
	byungchul@sk.com,
	chengming.zhou@linux.dev,
	david@kernel.org,
	dev.jain@arm.com,
	gerald.schaefer@linux.ibm.com,
	gor@linux.ibm.com,
	gourry@gourry.net,
	harry@kernel.org,
	hca@linux.ibm.com,
	irogers@google.com,
	james.clark@linaro.org,
	jannh@google.com,
	jolsa@kernel.org,
	joshua.hahnjy@gmail.com,
	kas@kernel.org,
	lance.yang@linux.dev,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-s390@vger.kernel.org,
	ljs@kernel.org,
	mark.rutland@arm.com,
	matthew.brost@intel.com,
	mhiramat@kernel.org,
	mhocko@suse.com,
	mingo@redhat.com,
	namhyung@kernel.org,
	nico.pache@linux.dev,
	oleg@redhat.com,
	peterz@infradead.org,
	riel@surriel.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	surenb@google.com,
	svens@linux.ibm.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	xialonglong2025@163.com
Subject: [PATCH v2 1/4] mm/pagewalk: delete the unused member
Date: Mon,  2 Nov 2026 21:28:44 +0800
Message-Id: <20261102132844.301730-1-xu.xin@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261102132416.300084-1-xu.xin@linux.dev>
References: <20261102132416.300084-1-xu.xin@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0A8B9120002
X-Stat-Signature: 6of13yr8cfj4a5i3m47zqqsnuseazscc
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793626158-66575
X-HE-Meta: U2FsdGVkX1+3deyxyk30/sbTaWFsmmxgbrSknJULy35hhsCTRwwt1zsD9B8EV6g+KX0/0vXf5gYxPxb2Hv31/vCQYUiPGOM4Q3fcMfLbeE5vByPdpuqctYu4UsJRXWmWOt37IpqfGCgD5EgfwcjiNI9e65G7NbYomYuKGUCdA6XGWD6xZ25+1ysergboE3/MOXLemm6mWApAfaPZk26ZuSNx8ht2QLurUmQrdozIwLXqdH5RnTSzKLV6Mr6RIawVTuuU3TtgFLd1MIc7SHGl4Nnk2Pa+6IkmXGf7jghJ9wqYvOiekHSN9rPLONZQ3Dl83YPFzgSCi+qJJx/iZMRu6IOEvGptHmll98r9veUpmM/GvI52cSHTcfFJYg8IRFpL82cJ3ZMovptgoT2RIf3mC56zaAfryfr7jG90S0JYkfmo/kJ9PhORyEaiD9SJtacUALNLX9TwJakbelBIpK9bYFW25jyXpEDZTGPCy3najBk670TrxHpZovgMrHtaEx01f6whtgJjgH/6cAXqAx5AU32l/bEcFIrhswdKVYKDhFrdipazERGpRaXb5jiHjD4WvOp9aKy/4jTflzjUgwftipyHghcWVWdvgXcf0qz4CtwcE601uQn5l5vihVZu1kT8O2GU6v2WxheUeJnNhRICXE35tJJ4imY4obQw2XosCQNmE12mq/mi+jqpTVN8kYX0HIm/1DJUXUGDXsVEIki23a2rE/A46JfMDGSBAsImNA6fhkooFr5/pFU5nln+sCS3Bq1ImktN7gPZ2+7oGPHRu7g4rXmc1XlvmJ8lEelKR/Qh/UteAy6JwoIWcba8O4aHp0H09u31QKQ2wZVSVbAJn7XEY+yHcoJcGa/n3At0YawDCEKXOw/+fwCIAeFqoHJrPocr1GH7HTNa47H0V3bu/sTfTRgy2KYWi0gGkATLaeusGlmXu+tmXAi3OCwDw1cyeUUpEk7avDtryFTLBSy
 NmJzlSeW
 iMBo6LGVQEWyhOETckHq0sf5yU6gSDdtcdJAcMokLVjNIIfihXg7uBXzKkSTBjDc1MGA7AoDJuZb4xq2L/UCdVO2zuUIQjOcEAElEI8TQmawMkGtKoHfWU14vf9YM7ne4xIUj8f7XkYwZwBVyT8vIYoEZ173tro9vmpr5uSac2lVh3l2ZuquI0gr95/LV0T+94UG6JtS+W8ORXAhVeEl4NRTh7PNfvLgiwEXpz9KztD/wncrqYrZyKQNp/I0xlXGEAf4OHhJfGaVnfoPcnaNnU7c4yV6D0WVfwZboiSjWyQRouYs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Xu Xin <xu.xin@linux.dev>

The 'vma' member of struct folio_walk has never been used since it was
introduced by commit aa39ca6940f1a ("mm/pagewalk: introduce
folio_walk_start() + folio_walk_end()").

The VMA is always passed to folio_walk_start() as a separate argument,
and neither folio_walk_start() nor folio_walk_end() ever reads or writes
fw->vma. I audited all the current users of struct folio_walk (the
callers of folio_walk_start()) and none of them assign to or read the
member, so it is safe to remove.

Signed-off-by: Xu Xin <xu.xin@linux.dev>
---
 include/linux/pagewalk.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/pagewalk.h b/include/linux/pagewalk.h
index b41d7265c01b..1c397be0d092 100644
--- a/include/linux/pagewalk.h
+++ b/include/linux/pagewalk.h
@@ -183,7 +183,6 @@ struct folio_walk {
 		pmd_t pmd;
 	};
 	/* private */
-	struct vm_area_struct *vma;
 	spinlock_t *ptl;
 };
 
-- 
2.34.1


