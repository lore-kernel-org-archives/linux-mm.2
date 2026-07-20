Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F788C44529
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 19:35:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36ED36B00B7; Mon, 20 Jul 2026 15:35:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FA906B00B6; Mon, 20 Jul 2026 15:35:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1740D6B00B7; Mon, 20 Jul 2026 15:35:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D4F616B00B5
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:35:25 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6B7EA40290
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:35:25 +0000 (UTC)
X-FDA: 85010159010.15.EBEB599
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf01.hostedemail.com (Postfix) with ESMTP id A833D40010
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:35:23 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=qopQMr2z;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784576123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v2LDhxlVOpgNtSXDCdv8imM0ubGsvF9EJ4oiPoX2j2c=;
	b=xZyhbELo6ymhsW7Fal0Eeq/OrUlfIQ2N7A/ndmRkufOzzxGpvzwQdtnnP3uSAjMMJpGIq1
	MkLHhF2L8Xf3+8Aa/HrwpfGANyNgCpCdjXVvma7vEAKDT2+tgf+r8tDvacNp4djD3MaP2U
	2hyRgfexbk3r3keHAsAH1SVMy4wv+B8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784576123;
	b=byMFQkdZhNw0A4IhblRXvDlYZ1N5rPnAWZX7quMR4PE680Et0iGbaAq7ftuASGBxnhGJw5
	O2L8lCzM2+xgwjtKEebdYj4Rd85htyXy62Zv7fDiJmRxEb0eCQPPm6PiKL46Pme6T+ePVU
	iav27+9x/eywQ4JFfOaMPn7kOccLcU4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=qopQMr2z;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-92e533aacf2so395281885a.2
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:35:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576123; x=1785180923; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=v2LDhxlVOpgNtSXDCdv8imM0ubGsvF9EJ4oiPoX2j2c=;
        b=qopQMr2zkaaURt/7phMGqJ852BVIbxEMyewVCiAw1u5BKUhC+EeiKX90c71J7V8mg4
         3HaHwKsuOybn6eZMsRUIUsNMFzGEYz1qV9wXpMk0GBTbSkxbV//WQitRPaXvx8y8LR1t
         j8s6k3GBneLLkHG54swFB56nuSWmHW44YpObKv5T5PPCoc0e6vhuWqRujck2NnpYd8NE
         q2SadJ9vBMkvHiSFtWBavgA2Z8Rv/l48QCV5egxwqIO+P3fdzbbZVhMwXcUwJOmyVPFv
         Dr9El266y89/n1+5Wftv1P0ZgUBqccfOYfx7kg4O1eqlzUU+/Pv54NT+X3lEZMjHCo8m
         6TRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576123; x=1785180923;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=v2LDhxlVOpgNtSXDCdv8imM0ubGsvF9EJ4oiPoX2j2c=;
        b=ZDaHOdMT/a+rKf2w8ziCTqx+HaXsqceceCgBBBsvMv4pVepZVLU25B3ASfs9f3k4yr
         Ynf/yLqQRbfCE1hkjz3CD1TyZt1BzT3M4uIHC8y8daefpvuDp33U6LryfldPn/h1BQuN
         F4xmwl1eRdhk3s32xpJqImY8Zv+OGBHRr2ObF5NFyZaTBePupLF7YMlODRemZuonii4e
         QDerUP4sqw95k7HFe1bJQCSuv5chS7gTD1Ew59izJMjimUQr8mTf2nzya9d51a1IGIdo
         pQet8jvhjUpYDFpNduqzPuDYofGe7uVYmCXpWvJlEI33XksOhSygIWLctAiK0dt7ON96
         Eivw==
X-Gm-Message-State: AOJu0Yx7y2/5xSXWdCi8NhLKFxPv4KNUEcOz8+E+rEuA7ZzKQT8Bl1y8
	gS9k6k2+6F0ftetbA2y+CY/bbUd0b00xQSedjWpfQ+S6/we5gJnjbZeTitL96S1FIj0xMTCbTDW
	4eSlJ
X-Gm-Gg: AfdE7clLzdNix4Ocd3Z5x7SPhUQR02O8vZtPoFjS1RcDA9HoccP7VSJtCXwCd6qK66k
	IBynuSsZRFQd7GLe5UMxJb5ZB1UeTKcRPuk8MPfraUotyaRiPlBDQLgQn0Lf2/HPz5jQBPi4eSS
	sXWWjstemfu+c3x0mVMqI2hCpHFWl+4L81JLCxN2WTJ+qdiolSb6IBotla0fBkP9Vdy7Runouj9
	ei+876z0mMp5u/2jYlP4vlhb7qaJzT5zxLfqp5hO14E9f1+/yAjuQQvFeeWmXexfVX0muBTDyy8
	Lbk9LzpjoPQHui96bg18iUHeMXEpMNZxil4hFumlkawap7ZTmy2LFzKuCiQNI1Of4FmBNqIaMtg
	91RqlOuZwzMBNEDxQhjFXyvWnwaQIKnDqSLUPLo1TJNeBy9jVGDb95JEt83ri+gAkCc5QVMSCHW
	C7dP9cbA7dlJSjB4KKpWy+CVy8zJyCfAmZSKZ9cbE7v2p4O17YCpiAKyRasVTqUl0mIHgzNJPDn
	g==
X-Received: by 2002:a05:620a:288a:b0:92e:f3ca:2ec8 with SMTP id af79cd13be357-930b3e4b8a0mr1508481385a.19.1784576122786;
        Mon, 20 Jul 2026 12:35:22 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.35.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:35:22 -0700 (PDT)
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
Subject: [PATCH v5 17/36] mm/vmscan: disallow reclaim of private node memory
Date: Mon, 20 Jul 2026 15:34:11 -0400
Message-ID: <20260720193431.3841992-18-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A833D40010
X-Stat-Signature: aqnk956x31s46c669tad9c68bt5637wq
X-Rspam-User: 
X-HE-Tag: 1784576123-33107
X-HE-Meta: U2FsdGVkX1+c9v6rQ2GJD314H9RPepaXSutzWz4PzQKiyxgoet4jeKaV4NtL/eZ79pPrIttVKlfTpcwk8t03IVEyQdOE9nYZawzomw+BDpic7ffL1LWHm0GUHPZgQZje7a5pJx0zRD8Eslpm6LKco8IeMAuruY5X6QeEBk/Rlzj1PvsAVdGugRSIocvFmNM9iVH+3jjwtKSmYIrTadWKOO1lqYquQEa9qkcJE8IvRtx/ssplHd0zk+ZL1u//ifPvilVot+Qm/Lylksf9fSgwX4O46cdkApUMOkKf2w6U+CsPLjwpTAUMf8I6clae+sj4QRmLzNods2ygWcBoZYZXzK3l0G8gTi4KqF4lT+iCVvE3OBbQSY3WO4Wf6Zxu8QH6kfcavWAyAan1iOjjDdKpZoIjPdCQgcSdKkalffG2qmarouRedH1UxOVXe2Demxw4qc3LmG7C0BS1BHEA9OTrtlKxGQAMU9wmcO9yrSDJJ3/tbyLGaNCQVEO5S5bdzzSGQhCwMUIKrnwP0+pfoBhhbuu65vYQt5FOitnCqgYL4mQp/+oFthVpNnFUtowPIMAYnpJHmrCok0dK3dyKw1pCMxzlGXRedM8GJQx6bOoEjAgRhg2/Gp/z6PJ4Zd6czEboywXWhtfHqHE6HbQjFkxQ/2PG7Hl49/mdM2ynDwq4Db20Dy14Ls6BFSbn7SxV/Dz1ZFiiMLxnpEr2d9WunwtfndEOvuKI8yh27yud/EMqU+WkE3Ji9qqOQ6857pgHDSVAFzMT/rLVabjZFRzNSpMR6wCDvH0Iy1A6QCZuoXTs9RNxa2yosQOBDygqVF6j25SpLiq+Qn2/5ZDcSDeKF78GbG2SOJ0U0ktrM3d1XmURFFTjj9oU5uZxnWw5DuSxiRQt7sZaIIWsf3R7In+TgrKmnYujzPvSSe2lgNGd29VtlJbv72i0G9NkRiOnGvHV9/gTl9JE5ucknmJF+B6OaVh
 kOivdcFa
 cK05BTBl6zkR8r3KdYUFXLguIuBbaVpVuOINVcXq4mPFtCKDCui+z0SHuoVm+81OvIhjBtApWhdzFcXcUerDEZ7UY96APKDdzu++JwfnsiWh7PWxHqVI1VlmE/h9F43dglqrb6j+ZIPxBLMnNRZSkwXnw2CXZkQvlul6pYID+mXzzCJJ9jI2vKSRIgBywRdzzth6T7yVktmxpamIhwQzlWeWqfs2wNvq1yr5SqDszQktbksewhdbZixVlLAiK0z8jbLra60r1eSVA8fALZb/fLaX3nalhOwWyqAIcFOywJFB2gRRRwSjDaSejJpLQtGzUpPRCzqYPPzQ5kZLp0ml5YF9QdIARtWD2LMb5Wuw0GWz8yEAOWMdcsJ6wt3iBOKOw55Wa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Private nodes do not support reclaim by default, so prevent all
reclaimers from operating on private nodes.

shrink_node() is the common chokepoint for most reclaimers (direct,
kswapd, proactive, mglru, etc), so it's the best place to filter.

DAMON's proactive pageout bypasses shrink_node() entirely, so we
disable DAMON in a separate commit as its own discrete service.

Other reclaim entry points are already covered - e.g. MGLRU's debugfs
interface rejects nids that are not N_MEMORY (N_MEMORY_PRIVATE is
mutually exclusive), and madvise pageout/cold skips private nodes.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/vmscan.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index e26c6931f5fde..86b2334c23b98 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -6141,6 +6141,13 @@ static void shrink_node(pg_data_t *pgdat, struct scan_control *sc)
 	struct lruvec *target_lruvec;
 	bool reclaimable = false;
 
+	/*
+	 * Private nodes do not support reclaim by default, filtering here
+	 * captures all normal reclaim paths that may attempt eviction.
+	 */
+	if (node_is_private(pgdat->node_id))
+		return;
+
 	if ((lru_gen_enabled() || lru_gen_switching()) && root_reclaim(sc)) {
 		memset(&sc->nr, 0, sizeof(sc->nr));
 		lru_gen_shrink_node(pgdat, sc);
-- 
2.53.0-Meta


