Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 647A8C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 01:22:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6209B6B0189; Mon, 17 Aug 2026 21:22:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F7986B018A; Mon, 17 Aug 2026 21:22:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50D8B6B018D; Mon, 17 Aug 2026 21:22:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 31FDF6B0189
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 21:22:10 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AE2DD16093E
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 01:22:09 +0000 (UTC)
X-FDA: 85112639178.26.2178B96
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf03.hostedemail.com (Postfix) with ESMTP id 40BCF20002
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 01:22:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	spf=pass (imf03.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787016127;
	b=NQz8zQB/ekF+DNn596cuEvLZzaCjhtLcuMgJWuCiiLhIRN48TL4Nf8AWxe4xEkxtHJWD4+
	hbFCi8Xo1Ubi/+Ag1fjRwKyPd5VyrjrpHKvs3Su9DXYR6Ivy69vhBL6LPVcYxNqPtU8IXf
	c39tA0qtSpUHc0VaIvGQcuU0lurnNNc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787016127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x/Z4ofIVxPpwWi0+PJFE1D+GeGrpYo4IIntAB4EZ0dQ=;
	b=R68EiSeZ6kEYRQnLpK+m0d2iCEhcgWRb2arpVDr78YCDnPtred2igKSrPkXK+VSqGgusCp
	w1aPCp2J1OA+HcXziXC+XAkDlLrN/AZdX1LzbKxol6lV6ZR9ZukDQLUUrLr1Wm09P1bX5o
	mWaNBQ080xLcPpmS0GNP7oUy4USXYjo=
X-UUID: 3386d1849aa311f19a56ed5b684f684d-20260818
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:95ddea70-7988-4cc8-adf0-a1985ffdd238,IP:10,
	URL:0,TC:0,Content:32,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:67
X-CID-INFO: VERSION:1.3.19,REQID:95ddea70-7988-4cc8-adf0-a1985ffdd238,IP:10,UR
	L:0,TC:0,Content:32,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Spam_GS981B3D,ACTI
	ON:quarantine,TS:67
X-CID-META: VersionHash:7db8b62,CLOUDID:d9bb3ca6ae86ca470bf3cccdf54fcecc,BulkI
	D:260818092159OUBCKOM3,BulkQuantity:0,SF:17|19|66|78|81|82|83|127|865|898,
	TC:nil,Content:4|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,B
	EC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FSD,TF_CID_SPAM_SNR,TF_CID_SPAM_ASC,TF_CID_SPAM_FAS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 3386d1849aa311f19a56ed5b684f684d-20260818
X-User: husong@kylinos.cn
Received: from ctao-book.. [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 621905450; Tue, 18 Aug 2026 09:21:56 +0800
From: Song Hu <husong@kylinos.cn>
To: joshua.hahnjy@gmail.com
Cc: akpm@linux-foundation.org,
	apopple@nvidia.com,
	axelrasmussen@google.com,
	baohua@kernel.org,
	bsegall@google.com,
	byungchul@sk.com,
	cgroups@vger.kernel.org,
	david@kernel.org,
	dietmar.eggemann@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	harry@kernel.org,
	jackmanb@google.com,
	juri.lelli@redhat.com,
	kasong@tencent.com,
	kernel-team@meta.com,
	kprateek.nayak@amd.com,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	matthew.brost@intel.com,
	mgorman@suse.de,
	mhocko@kernel.org,
	mhocko@suse.com,
	mingo@redhat.com,
	muchun.song@linux.dev,
	peterz@infradead.org,
	qi.zheng@linux.dev,
	rakie.kim@sk.com,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	rostedt@goodmis.org,
	rppt@kernel.org,
	shakeel.butt@linux.dev,
	surenb@google.com,
	tjmercier@google.com,
	vbabka@kernel.org,
	vincent.guittot@linaro.org,
	vschneid@redhat.com,
	weixugc@google.com,
	ying.huang@linux.alibaba.com,
	yosry@kernel.org,
	yuanchu@google.com,
	ziy@nvidia.com,
	husong@kylinos.cn
Subject: Re: [RFC PATCH v3 09/14] mm/memcontrol: Make memory.high tier-aware
Date: Tue, 18 Aug 2026 09:21:15 +0800
Message-ID: <20260818012115.65838-1-husong@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260807202059.2620949-10-joshua.hahnjy@gmail.com>
References: <20260807202059.2620949-10-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 40BCF20002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: wsejkot6ok4xfmfmqmm1ecgujs1k7hwb
X-HE-Tag: 1787016125-340230
X-HE-Meta: U2FsdGVkX19z+umN9+8Gu7j/8/2Kkzxcp5VSRStc8livSbak1XX//dEuy9M7Cf8i+0Y8zj1dOulCMQb4zaPpxuL/A4gogXr9bbtKyDtYSM9V/wmfic1SjL+w7EnsuChUexxRpyr1b/2O+4k6pn6N0y0vuChWUbCEPe78BX3tqbneqV8JbxSQ+4oYgBzWMtUFxAMuaO5osWDhgKXuntQXayKLZYP/Xx+M52sStNHXmwjBzXjjiU2IIWmptRbTqLBtTz+sDrV1EvKrySPji0v6ceJb1OuH7QOT11rtpZJqyoa2uwInJ+VnFBfmJt3qp5lFaI0gnfeuSnnkAMx4io/xiUFENTQ0vLI1lqCLdQ6ExUWQZkyhIIgGC0XN+uoUnTKrCdCXi9K8oVcvnhQn4Plh5oJR9sTMKbREQ4xLqme8V5AxQnmhpN597OfWnQ1JJuthU4eHCutY5T8PK1Jig4JWZ2ijFZ4ZqII65qclZgG1mYSefG/pHMj0ReYTnu2n0uJlGbEzikWXrgWTAJU8il+xVrrPIuVN1m8nf4kCjx8IgLpeY517VPzMKGbzlHIAh8zWLJgyXBXQ/6C0w5u/7wArZ9+IFQ7t2WsleUd39E3gmEiEgPy1IbBimSFU+1V/3jX2yumYtJ7LFjhk5TpbsIUJRsRVKOjMuURgvS/tSCD7ms2a4XCdCNZnbyZavWw+lXkUrzsw+1+KE/0V5dzOk2ZjDP8EJdLAfRLtDgUpJZ9OWBp5FOjBCkkc+e+4VE+ymYbIxzsN/VHm8kk3vU30NcEtdp6QMMBLwE9mwqrl1OO3gMcUp2imJAW/pvgUukinT1TCgAkjy59WRCwp+dpQRPO9hBGHk0fTpnUQ1uw+5Bq25q5ZKjQbhQUmgFZ9T70SVF2LGOJ6avVqR2KhCiAmFFzrbFvm81cuzfEKUbj4JMN5rUIIG+UL1S7mtP01qjqAHYkWtLILI4K3rFchi9llZHK
 HqY5mQMK
 xI8otEEIc7J2snorhTVs4myOz+1UJSV+qDwXOltqIEExls1viph2nuwkA+5nGd6jAmLorWldU324xayM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(pre-existing, not from this series - mentioning it here because
it reworks memory.high behaviour)

The penalty computation in calculate_high_delay() can overflow:

	penalty_jiffies = max_overage * max_overage * HZ;

max_overage is a fixed-point relative overage:
calculate_overage() returns (usage - high) << 20 / high, so the
square times HZ wraps once (usage - high) / high reaches
4096 / sqrt(HZ).  That is roughly 130x at HZ=1000 and 259x at
HZ=250 - reachable when memory.high is tightened far below the
current usage of a large working set.

Most wrapped values are still caught by the 2s clamp in
mem_cgroup_handle_over_high(), but residues below the clamp pass
through, and some of them produce far less throttling than
intended - down to no sleep at all.

check_mul_overflow() with a clamp would saturate the penalty
instead of wrapping it.  Could be folded in while memory.high is
being reworked, or a standalone fix.

