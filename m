Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDD23CCF2C9
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 04:53:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FBEA6B0093; Sun, 18 Oct 2026 00:53:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D2866B0095; Sun, 18 Oct 2026 00:53:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40FF76B0096; Sun, 18 Oct 2026 00:53:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E8DCE6B0093
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 00:53:33 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B10B716045E
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 04:53:31 +0000 (UTC)
X-FDA: 85334528622.15.5CADA49
Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	by imf07.hostedemail.com (Postfix) with ESMTP id 01D3A40005
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 04:53:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=j6bnptqf;
	spf=pass (imf07.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792299210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=NL6FeozJTfgi7BCvp1Y94ucO1gEoaYL+GaN20Lo4AzI=;
	b=SyUzNf1f9S+JJmmLRWtbn6tMvk7GuNihYVt2NzBNGXx5pzEoGnJ7GoT3I/PNwXIkXRCOWE
	cTf6qsyNsaW7HmJyeapzz79Mlxw9XmznPrmhZr43BTRMtwrbcdrWU7qtviU++6f0yLtEdi
	tXL6TIufWqUcRGjOs2fpdA9zGTpla5I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792299210;
	b=gQErLzWCvEu9o5Dk4A3C/V1djj5QrloSxCpXPKGqWpjtzKvm8yGt2cXBkAvQeFVCt1q9Y5
	+RUuCecJR15HisTw6jbx1OrUzqdXVZJHcanD5IT+cdZu8bbuj6Jk3Zsu8slYNWzmblwP4+
	dRtrhymg6+UmRCVaQRzBdCgrOEQWcGE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=j6bnptqf;
	spf=pass (imf07.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-35943f55c06so1558027eec.0
        for <linux-mm@kvack.org>; Sat, 17 Oct 2026 21:53:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792299209; x=1792904009; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=NL6FeozJTfgi7BCvp1Y94ucO1gEoaYL+GaN20Lo4AzI=;
        b=j6bnptqfb/FNIoSVUUHDLQUkKSymmDVFTuhE5u7fKaBUZDLNA5vyE6H2/RAPhm2omA
         FYgFRZM7m73dBadrL8ujuCyKUJ6RS3bn4j1AC+oTCbAQNvpGP/rAG0GMsDFmqDfQFWjJ
         UZcYY+kRyecrX1E0sz0eapdUX5ryskf92DzBD+VI2jB33xY0qSAKgNEFTz8IsxIjm7OV
         DYD9mENiavekLGaBHNVd3rzV0Xe/yWrR10a2d/+i3y9LoLzhgQNzWrWrfhuNIb8waTV9
         Ll54n3GogkpZydweZMlHbMMYlRIq8GCkYvkddPeL/EnhRQbBy0l+sHVhqeM+RlYrUAC4
         Gx1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792299209; x=1792904009;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=NL6FeozJTfgi7BCvp1Y94ucO1gEoaYL+GaN20Lo4AzI=;
        b=CMcUHBVdo3CnhpM6XlIACysvOkE62LgOTi49pjQVLmgcsMCJiBxEG93QXXvGdhX7T3
         qJRIKn7xR0Wm/xsW6i2ofc0T0CIshlTVO1OUsVIxS2hAwpSiGkuUJLRZV8wwlYSC42lC
         uHbE7bNEabQLZjMeB4JuT0pC1d+mibUnQCwpd5yQC19ABWn2RIyh+sQ5RN9qjnuWIYs3
         vKWGVNzq4+izhvEvj++w0WwgkokreLQnTJ0iUl3C/CkDhwAfPtJVaqydCQeqZPPlhgBl
         gXH1MpPzxCiqplTfoRTS6xOjlk+kkFXDMzEc048Z5SfKxEnC0UkpO62mqNLLAs1yRcls
         JyuA==
X-Gm-Message-State: AFq9FYIsR0nq9mz4ogF3cAXR++7m1MKw90MK2VrS2OCOt6jU94Q0VBAj
	jjYoGwETSB+1MkY4bxjFEbGcut/dzlgQ2ZXIBWkD0cMF7TGOQbTTZ2Vf
X-Gm-Gg: AYBFou0JvGJM0pRp+MFCWrun/c6qu5RFMCC2ofGd31ksWPkm4MQcZNwzwtHSSFa9ehZ
	AHyePAuufTdT91T5Uq6SFf5Idcniac8EvHvsKA6gx2/otwKWNK3ZLUZ5cjn24hX66u5gA28z1Gw
	0UZeizNTU5qOWGxQDOyUpU4i84mXMj6DX5VlJATGXGTJXuKpahFTFZP6/Fcinw4SmwsCSE2fjXI
	f0hpzKiMlEFSPuRZuB0CPPOPFipBcFUuWYOIPEI795KqwNzpvWFXQTkHb2o/yWpIkq48UChvdIL
	pZCGTcPRjo3JElXh08ZixLL6+nVE7SxPcWCUYB76Tag8smKfPNl2j4ZhbYvqz6Bv2arV/or3+5q
	9tPsBK3GsOja532ftmRVSbMNDkN86X/9/Na85uBK+Ixk0L9pi9tsHNeJSDJ8KUltThohkgXhVAd
	AlVlA+rMwGFBSKT1R5CbqGk/T70yKrPA6tpfVfnZpJbw27idJxTMSq4pPdo9On/7bE0QLfpUS7a
	arJ
X-Received: by 2002:a05:7300:3aa9:b0:360:aeee:9b8a with SMTP id 5a478bee46e88-360aeee9f90mr7930486eec.8.1792299208567;
        Sat, 17 Oct 2026 21:53:28 -0700 (PDT)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-360826875b3sm21621460eec.21.2026.10.17.21.53.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 21:53:28 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Sun, 18 Oct 2026 12:53:22 +0800
Subject: [PATCH] selftests/mm: keep ksm_tests on small pages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261018-bug-selftests-mm-ksm-tests-nohugepage-v1-1-55ed54bdad35@gmail.com>
X-B4-Tracking: v=1; b=H4sIAMFQ1GoC/yXNwQqDMBCE4VeRPXchKxKkr1J60DqJS5soWS0F8
 d0b2uN3+GcOMhSF0bU5qOCtpkuukEtDj3nIEaxTNbWu9eLE87hHNrzCBtuMU+KnJf4jL/MesQ4
 1kk663vfT6BCobq0FQT+/n9v9PL9GwPhqdwAAAA==
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
 Usama Arif <usamaarif642@gmail.com>, Yu Zhao <yuzhao@google.com>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Qiliang Yuan <odys.yuan@gmail.com>
X-Mailer: b4 0.13.0
X-Rspam-User: 
X-Rspamd-Queue-Id: 01D3A40005
X-Rspamd-Server: rspam08
X-Stat-Signature: c1g6z6z764zchdcqatk5441w7rrsrhu3
X-HE-Tag: 1792299209-378323
X-HE-Meta: U2FsdGVkX1/JPjInIlCFIChpt8AarcTL3TZAhwPmm7VaqvhlVl2jE7FCOAL9pQv8wymPdHLG7lUb11bJ59ZLk4DHHA3JqrdeOdqTyeWh/njOxX43HeDf0RE+DGDK22wqwq7cjrtuwnLMG7fb0mhAhGCHGxbJeXIZvSKbRS/tZAKXjkXz7yMxMsQ4jTxsCT05vxScsb3/BkZic26Dc3vIDxVedNo8zooOPdinW5H151YaZBDDHohLho9N4mn/KlI2uzR8aRyQYI3qIkGP5lRZ4cuPXMC7YHDk09EE2A1DMi1txfmu6TevfrT9o+uXMS4p5z9902ERjLW7hi8pniE1o286oSmdakIareMKk5YpMNd4i+mLcj3EzSH721J2RP7UKhb+2SEPB2CWLswsekCovpz5BgctVGkOiWcqv3MkwxCNUBixLahXXf6XQOgD8+gsMLabH/dv5WSxjigNiq+DOcACcd73T/2HsxEZ0tf6Q82Pk7V95U0iE4jE8hnftw7FvHs1WBlA83EsH5/p/6F5fv2fcgv0AU3iYXEZKHVFnLeaJ3ujgi9lEpv3CYNZxO5YD+D5HCig5nqAztxyGdrD1aWzMVqojd10eBc1LlRq5cct8Faa0MhQNFukiZKnQCWyK5yyEMTc5dXxtzGSTt2KORe3mxucthGzLw6Q3Qw9mQyIG4PKcbou181j9MB5akh+96nZmzuraS3Wf46Bi/Jfo2767D7xA+zhQPidEhMSQltGLJ2zmV2MipGF9Y0j22b7GxCTNoR+1iDnJiuL6R+Cx446K2SxgAXJ5ASdjuX7q9pXnWHs0jRzC0IaFoaWJLOtWrK42oHyC5GDwtanR2bQa1EK0tSFTF0w9NMgk37nkzbkcbRV6W0c+VVEBRtQSRIfQFSTJBB6plKAAGNx9bsWiCSrgcZ05i+9Y41QyEF6xbKg2rGw1kMUePrpzznjR0Y2R79tuAhvfReSlhIU/6Y
 8lg7+Yio
 T7jqu0w74Y6eBHd0L5DOg1BEssPl1roC8WHUkgqrj2//LPduGHgz3Hy9zAzuGZkZWhY1KPOnXR6KqC51is4g4FUGybFY+uwyhHHp/KK7QqrSQ+0uiZqaF29+MjPPPmdG1Qg9xiFC0nwrCAmBhvwy87SRsl4reLLtOH41kanRRCp9vJBO8oaVwMiC7QvgyKrIGsgDdrqPJfZQ4sCZLX8OvsJfFC64nXJFSWqP0VJyL96EH7OaPMWwy9wjl5604AUCLjwBiRFU6S0I3ZWEMv/UoJvqfHC5wSJEtPPr/bq6W4NV3If2GDD65MwZD1QFxOX2yV+/cEV8jpi+Mqi20IoyTSVc+2i4zD5FxTIJs9ShLSisOaTGef3G7R56avE5ykKoPqFeu7LkzeOnGBqSbD5GymMH856FmsLjulp7X5vNHt0KnG+coUe0RloBi5aqx80pXX5GuXqMKiIVsDMCJ8ZxHhqtqSgW7EzPYC1kKMptLWCxHW/2PT/ihH7h8DXlb79R4Df1jqZDmZPi8iPSsRuUCXuERQVKwnbjgr07IHuBFHq1TeAM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ksm_tests fills regions with identical data and checks KSM's counters
after merging them. allocate_memory() maps these regions without any
THP hint.

With mTHP enabled the regions can be backed by large folios, which KSM
splits before merging. Splitting an anonymous folio maps its
zero-filled pages to the shared zeropage, so with use_zero_pages=0
those pages never become KSM pages and "KSM zero page merging" fails
its count. "ksm_tests -Z -p 10 -z 0", 20 runs:

  THP setup                     before    after
  default                         0/20     0/20
  every mTHP size "always"       20/20     0/20

Map the regions with MADV_NOHUGEPAGE, as ksm_functional_tests does.
ksm_merge_hugepages_time() maps its own THP-backed region and is not
affected.

Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when splitting isolated thp")
Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
 tools/testing/selftests/mm/ksm_tests.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/testing/selftests/mm/ksm_tests.c b/tools/testing/selftests/mm/ksm_tests.c
index 5fd7792a0d479..140ea833353b6 100644
--- a/tools/testing/selftests/mm/ksm_tests.c
+++ b/tools/testing/selftests/mm/ksm_tests.c
@@ -178,6 +178,16 @@ static void  *allocate_memory(void *ptr, int prot, int mapping, char data, size_
 		ksft_perror("mmap");
 		return NULL;
 	}
+	/*
+	 * Splitting a large folio before merging maps its zero-filled pages
+	 * to the shared zeropage, so keep the pages small. Ignore EINVAL on
+	 * kernels without THP.
+	 */
+	if (madvise(map_ptr, map_size, MADV_NOHUGEPAGE) && errno != EINVAL) {
+		ksft_perror("madvise");
+		munmap(map_ptr, map_size);
+		return NULL;
+	}
 	memset(map_ptr, data, map_size);
 	if (mprotect(map_ptr, map_size, prot)) {
 		ksft_perror("mprotect");

---
base-commit: 90201351a862182bdabfc1ad1c97b1e1b6ed5931
change-id: 20261016-bug-selftests-mm-ksm-tests-nohugepage-1414868db0ef

Best regards,
-- 
Qiliang Yuan <odys.yuan@gmail.com>


