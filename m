Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 031B6C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 19:35:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE4726B00A0; Mon, 20 Jul 2026 15:35:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6E606B00A1; Mon, 20 Jul 2026 15:35:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5E2D6B00A3; Mon, 20 Jul 2026 15:35:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 763596B00A0
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:35:10 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DE1D9802AA
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:35:09 +0000 (UTC)
X-FDA: 85010158338.29.C54C54F
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2D3E31C0004
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:35:08 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=G+DGJOBL;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784576108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AbvY/gXh+2/u61eyWpGKI13cVvWaG4WQkB8wV0sMVYg=;
	b=PGYkIiaWkwVFzSaW+JECGNyPDA4Jn90bQWMGATkLInrhRfO1PXTs9SmesGyerzRXqnUzpK
	ML9tW96w8qYR0voqM5o2syotg/9dmWK0wP+Cdkc6kQj3SSB0XCmAzT3ga2q413aZtRxCnI
	ZnDK2XKx6V+KYT9wg/Q2/fVaESBCrW0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=G+DGJOBL;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784576108;
	b=2oo+cw8IbX5Q7o/2xBIs6uEaSHWjFSS/6RZ8DvsElkO8sdBy7z9f/Omj1JjvnPQhu93fnK
	Z7sUikuTpTPWZR0kM7c41h4pgWV1AQZQgrI6ZvK1gHjrEnWcPKYkNNuzlEjdFdvzMFFTPs
	YbXZO35Jnrb4OyS7u0rHwsQZkmS8d5Q=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-9305a2121a1so722930785a.2
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576107; x=1785180907; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AbvY/gXh+2/u61eyWpGKI13cVvWaG4WQkB8wV0sMVYg=;
        b=G+DGJOBLjuSUZnmTUGpB/m+NqIUK4+A+AxAJ4qS/iR0zJXRJPiyNlbU8/DxHR8F8fy
         Ow+V8IhaLSu2rdH/1Yr5e+cdagkhHOcGQ2ohJiRIBmu2sbCSbawZgjb9kvTxj58U58zV
         xHYOU2OEOZ/iqb0pR7XhrIQ4xXaCsBoGAnegkuoD8PNbu3BnoXW0dSKGR5R/QC0+gvKe
         OfOBCbvEVTbArRLSUacpMWBOYO29dzRAsUVHDOrbMRyxKdINF/ovsfhsm4OwsXM/vNW3
         iKCjnaBcGCyiX+lvHLIy9idWS/B2fnzCiLnUV67tlT/Qmnt4YkNStNW7IZp3IxMkfiUY
         dSJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576107; x=1785180907;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=AbvY/gXh+2/u61eyWpGKI13cVvWaG4WQkB8wV0sMVYg=;
        b=hsUJEKJnVoazWFltQEff/jCZhx4A/SBaSQNuAejq+x/ctoBzPGGkq16VhMECMpL+ui
         m1ad8VKOe6iHlcmsGX1Bc0HOAmXKgAtA4qaM4EVgkfqNa0yeVNRjwvGVSXDEIVQXXz/2
         97rFGc796WSLFA+A6WCZ65LsalPwkdJqp3oQX1eQnRZ52cRg9hOqpLR+EtbJ69+DQfUX
         pjSYOM8Y5N7QFZFOdK8YKhAQUlIZECNDAnJopxn3g3Sos76DOoor5vTgHTThEI/nyxeI
         Co5y26J+V+wR2ErINUPk95ihdlc6eoHGquTBsJOMn8qYdFIthfbriF21QC7QhnGbkEPI
         ueKA==
X-Gm-Message-State: AOJu0YyT/i6cZxmx3P88oDTeKn+kpQouvfbqrGHOjLP+Xa/h8EPlpAzo
	8w+OXl/FL3K9N87RnYZ53naHbys3sZAOoa+yjdJZXulS10vlukf/h7YJ72VLV8kNS9g1ljapGIY
	KJjVh
X-Gm-Gg: AfdE7cnbpymomRnvOXhjL0/1vvcTGxDlRC1tv9GPolWvQld/zZfy9VWeevZXKdy4yC6
	1gSNkcqk/cMRonyIcjbCqLFuYnevdMJbVWchOEXcCeOlGL9hdVFZpm4llVz3wtKoX0rOk6QZnwc
	geHMgUyM2+OHapMKx+8QhxPvkBWpgfSkXfYomGAke703BaGdTzjyUbB2ZnYT0chDE/0sfXtjin1
	tbezNH1Gd4DL05LoHr+fwy8vdNo2jUlYe32yIDM7VzzPb4TQFoLbE8YrrkGaHUZMIQzEIeHULgc
	ICo+1gnVwQDbisBG0zLWxS3T7vmZ0FcX7oCduW3oupDwkH8yzbuqWccHjnK/LwQsNqZgjmlMbHH
	yQ38PFPmKSFZ/cCG5Z5Da1vvboJsDdFw29jqVUD5683aPrSnaMcJP+kdCMv/1DwKpuhE4P9HCLC
	SGwA4Qiqqjw+BpfHPdWifM8DhcWBHKD+uzdz1BC4DYyV/D+EdK68+NHvx4wA0nW0k=
X-Received: by 2002:a05:620a:44c2:b0:92e:6b95:237a with SMTP id af79cd13be357-930b3f45487mr1592960485a.32.1784576106925;
        Mon, 20 Jul 2026 12:35:06 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.35.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:35:06 -0700 (PDT)
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
Subject: [PATCH v5 11/36] mm/compaction: disallow compaction on private nodes
Date: Mon, 20 Jul 2026 15:34:05 -0400
Message-ID: <20260720193431.3841992-12-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2D3E31C0004
X-Stat-Signature: fzbnorcd49x91cimrd5t8r6rqas9ggym
X-HE-Tag: 1784576108-106934
X-HE-Meta: U2FsdGVkX1/h9fd5a5LOQkowHTX2vFBu2MPWfhozfX51ttuMTu3rVGHDmfZWEFt539pZa71NP1qSNqADKCzj25jERWy/D5/VZuOPf3JcTTEchFlfY3wAxoLjHQFppOXqXAAtt5foasisfIT4dNymgT8qZFBYmsCeIeE24Bk7Mvt/15fMQ/Y9IjWFQauIGymNMiT62HEpMfE+IuNKbxdRJxkNGiWk9ZnyJyMtMYdGJkzjqfP7m3iDKaGpJcjkStZ94vGU2MIooyTT/kXlzGlh+F9vBKbAVw3IbgJ5pPt2U7XHkBU4yIQUYj+98eH3IGExXzMTd+ZeRNR03ad5oKfviUhdvraEwZ7xWEXdalBpOFxcEoHCR8QUpM1WApTmPaEKamRqkBV0sZTD2Yhgs1qnV6KSsWDqT74xXwvFDPWONBCjrbmzgp9mmQk1qjV58CmGAyviMHAMpajzPTlyz6uj5SAhVEzF/VboISXv6MXEOBQD3TuhvmrJ8IWarPDwDxwmAo75IjA7QAs1TG4bFgy3jzm87mkWs0Ws+3OYfB/Mpgdy9KY+3zuO7LKPpsTbVY/nHvOMq2g09D8sJvvbiAlx1jBUMLrd3DAMyDYsxJ5xqE5q6tsta4F6FCxJKltzFOVI0NjUq6NlOfkCsQjk8nRTxwnt8Pm3ypwXV3zI2cU0LJCsOa7F9f13eKVBXYuT7mmqrJATBR5UscYNu3lS5T9R0j3c8aeRdJ1lDij42TTrtPJSA2nCX32qGFGz03ckjdW9v36lHOQuEtm/BrH7Bc+raHNwvUYFRlAba/HQVH/0ehlgfS1ZRGioYe4nm2GT+1v+7RO3jnzry9BdCRtTGhlAAcZn8yziiUZrCUTWrqzPd9/I9ExPE300kfS4IQDWFdUTbhTOvF6x5UpKfArvOVUtY8SNwmutJieccyjhUhXzBgAeeIIpzxXjdjbGXvDvxaiIyfTgauT2FFrcnUa8i3l
 C9aaAwTp
 vQGK3FdqdltCWzcOLoROi9RyI8LlzCx6DrDviS66s+zLTA+ISVeMHrK1jXKQrUCuO1ZVboahh/Tsss2hbejHHiyaNWOMlN8VR32YouDlE+kR1bsrtrBw1e5hhTz8RbFK22Aw8oZ+THJrrlVhWWg5zIdYG4wkY0YYDMjecZtjsY/0Ua7NqCEgmXaKLmN2NZacAbMKp/lLehRubISTmbDxFy9/Zy0famNERavQXbONSiZFAs8BRrtds4MTS0FIQs8K1vonWLAohduwV+eOJqX5zeA9XNgCQMbZ5rX90fS02fKnB2J78UambY3KKKD+pumGvkiuAkXuyAQdhTXOLvX5eS7lPhvANTzhGyZcEyRtDmdeCznG6zbAYoviWGTi1tYSf/3Tc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Skip compaction on private nodes. Compaction requires the ability to
migrate pages, which is not yet supported on private nodes.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/compaction.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/mm/compaction.c b/mm/compaction.c
index 9f81055a358ed..8c1351cce7bcc 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -2462,6 +2462,9 @@ bool compaction_zonelist_suitable(struct alloc_context *ac, int order,
 		    !__cpuset_zone_allowed(zone, gfp_mask))
 			continue;
 
+		if (node_is_private(zone_to_nid(zone)))
+			continue;
+
 		/*
 		 * Do not consider all the reclaimable memory because we do not
 		 * want to trash just for a single high order allocation which
@@ -2853,6 +2856,9 @@ enum compact_result try_to_compact_pages(gfp_t gfp_mask, unsigned int order,
 			!__cpuset_zone_allowed(zone, gfp_mask))
 				continue;
 
+		if (node_is_private(zone_to_nid(zone)))
+			continue;
+
 		if (prio > MIN_COMPACT_PRIORITY
 					&& compaction_deferred(zone, order)) {
 			rc = max_t(enum compact_result, COMPACT_DEFERRED, rc);
@@ -2922,6 +2928,9 @@ static int compact_node(pg_data_t *pgdat, bool proactive)
 		.proactive_compaction = proactive,
 	};
 
+	if (node_is_private(pgdat->node_id))
+		return 0;
+
 	for (zoneid = 0; zoneid < MAX_NR_ZONES; zoneid++) {
 		zone = &pgdat->node_zones[zoneid];
 		if (!populated_zone(zone))
@@ -3017,6 +3026,9 @@ static ssize_t compact_store(struct device *dev,
 {
 	int nid = dev->id;
 
+	if (node_is_private(nid))
+		return -EINVAL;
+
 	if (nid >= 0 && nid < nr_node_ids && node_online(nid)) {
 		/* Flush pending updates to the LRU lists */
 		lru_add_drain_all();
-- 
2.53.0-Meta


