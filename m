Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15E72E66886
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 04:00:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D04E6B0005; Sat, 20 Dec 2025 23:00:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07DA86B0089; Sat, 20 Dec 2025 23:00:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA1E46B008A; Sat, 20 Dec 2025 23:00:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D50A86B0005
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 23:00:45 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 61135C0DE5
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 04:00:45 +0000 (UTC)
X-FDA: 84242126850.21.9F3C6E4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id AC0B12000F
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 04:00:43 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YCnKRBU+;
	spf=pass (imf03.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766289643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=RAc9nadAgGb85nuLMIBB9oG6AZY4Tcddq2LTgbVGuLQ=;
	b=iPyksnwfbI6Z6YfjprUC3dOIdl/IxD/PTHLKDKA+dQYCUF+6yPJ9NSUJMG/nkR+St3H57a
	y0iRys5o0M0TifB79zo1TFjLixTb3UzNJl/oXGGds1s2O/oCimUjk0zXNsu5v3LmAgQiaU
	iY4YxMpzHA3XtLJYcobFhWzKNo+9QI8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766289643; a=rsa-sha256;
	cv=none;
	b=Byl7C+XzEtMTAAEUae98qqZqs9wbZ0Xw+Y2mDMGj9qD79TxFkpqvQcBiBa5n3f3WraeG3E
	BdBS7yDwZS7CxNiq5rJt+3DndwMZ8x6ogkMe+Y80gA3NmBq91f6xpc/Fwqu/vsnJVR6sDa
	LRY6IXP2NgCxIqZID0ihViLyaejNhhU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YCnKRBU+;
	spf=pass (imf03.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766289643;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=RAc9nadAgGb85nuLMIBB9oG6AZY4Tcddq2LTgbVGuLQ=;
	b=YCnKRBU+x24NYXpvvNSRhIsF7zf+aLKRSF8u/qIMesVTMjWTDBU/dOZVQE+U4VM0690+oc
	mwqGrt9Yk4cy9Ik61Rxf0G58XPyAQFi+oPVqXqQYZzLOGg7Tjh0GzTfhKDAjhpMnhmWc9O
	KllkScLsBG/ngej5plsjIYTJsJpBhtU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-656-LbOpMcg3Of6UFM4JXCRlRA-1; Sat,
 20 Dec 2025 23:00:39 -0500
X-MC-Unique: LbOpMcg3Of6UFM4JXCRlRA-1
X-Mimecast-MFC-AGG-ID: LbOpMcg3Of6UFM4JXCRlRA_1766289637
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A442E1956080;
	Sun, 21 Dec 2025 04:00:36 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5507919560B4;
	Sun, 21 Dec 2025 04:00:29 +0000 (UTC)
From: Chunyu Hu <chuhu@redhat.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	shuah@kernel.org,
	linux-mm@kvack.org
Cc: linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	chuhu@redhat.com,
	Luiz Capitulino <luizcap@redhat.com>
Subject: [PATCH v2 1/5] selftests/mm: fix va_high_addr_switch.sh return value
Date: Sun, 21 Dec 2025 12:00:21 +0800
Message-ID: <20251221040025.3159990-1-chuhu@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Stat-Signature: gf7tcuonqby3hjk5rmodhtx37ghh4zd5
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AC0B12000F
X-Rspam-User: 
X-HE-Tag: 1766289643-458474
X-HE-Meta: U2FsdGVkX18aF9iZ818sE2srBmPvuxniWgEX1cP/YOMe6dSMYvu/bCDORrl18gaeOVv95VLXDs3lbqL2kAg172p/2wBfiw/PQY+kW2xA5D/BgfC3DhqTsGy88UKBPaPdvx7Lwuv/tKSt6S6KxKGIErMcWDWuBWt3JHRvKodmdkmNm0YroM1GL12tuFcOyGKkfXAkyqSeInb7ZvR2YAaWb4CLyRKf+gXUkruLA5LnSUzM49X/SJL5q3ezxDwvV6dtM3l/zhCy9VkiDti1qjMP3SM+kfBFAtwnPzWU2zEyhEnWc8LIBG9CWSHjIiXpXDZcWMJzkW57jrUoAA+opysQIDoT693SAlgW0orpurqQoNvEcY42LWQ6IDwkSulH5lEFntizpQT3q3lBRnj61xaMBhww+Ulqyh3V6qZDy3hPiLjFrOLekb/0S1pYzOZbHioG2dNxNrJTpgkkWovH9hWNQbCrbf1ufDfBENj2n3tuItmfQbL37+PLMUeBQIi/gF9UNJdSPJEDNrvKp1Mlivd1tmZx8nPhk0lBrj4cpxBL1lDT/xDrEz9zTLrayxPU7u+y7vhhFrVrC7JAPhNTZN8deAyN1pq98qzPboy7XhDKfrCGeOXH1OjUqj+/aPTXQapxh+MCsIkTXr2KPw3avW0Xp4CeQqSgH+/PSngPWuSmA6uCAiqcUxoNI9wTsFGX1+rZJSUfdZPqlXmtyhwCqkZAB6ClupGtSj+uauuCs5AyXSmdAXMBOF5iIcLXfMtjvHJft8QoDqW1INzC6pSuI67ED35ksePokw9sy2lp051eVEY9Mjlomm7ExOQTC2g09Httongn2dNf9ndTjs4qyp30Cr3SSZiUVX6rdd8KdupuU4tI7Xl/W+QP0hsLYvN5xptwjDZGK771O/fMmqFXhzgu6Fka/LbwzwBdfcEua6JlGB5KQPqD+yUYaAwsDszpIlOS5Prv1YhLCPTH/g8P4tj
 3l4uUvxX
 +31zrtLmymBt/is1Jr0dZto3eUE7UZEppiHxEkwpU4R69cesNNGlOg0PUSsSOxCjNKb47k6UWQKBts0U8BSGB8dVhsovSRS9HU9+mQmHHZg2rEbU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Patch series "Fix va_high_addr_switch.sh test failure - again", v2.

The series address several issues exist for the va_high_addr_switch test:
1) the test return value is ignored in va_high_addr_switch.sh.
2) the va_high_addr_switch test requires 6 hugepages not 5.
3) the reurn value of the first test in va_high_addr_switch.c can be
   overridden by the second test.
4) the nr_hugepages setup in run_vmtests.sh for arm64 can be done in
   va_high_addr_switch.sh too.
5) update a comment for check_test_requirements.

Changes in v2:
 - shorten the comment in for hugepages setup in v1
 - add a new patch to fix the return value overridden issue in
   va_high_addr_switch.c
 - fix a code comment for check_test_requirements.
 - update the series summary in patch 1
 - add reviewed-by from Luiz Capitulino on patch 1 and patch 3

This patch: (of 5)

The return value should be return value of va_high_addr_switch, otherwise
a test failure would be silently ignored.

Reviewed-by: Luiz Capitulino <luizcap@redhat.com>
Fixes: d9d957bd7b61 ("selftests/mm: alloc hugepages in va_high_addr_switch test")
CC: Luiz Capitulino <luizcap@redhat.com>
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
---
Chunyu Hu (5):
  selftests/mm: fix va_high_addr_switch.sh return value
  selftests/mm: allocate 6 hugepages in va_high_addr_switch.sh
  selftests/mm: remove arm64 nr_hugepages setup for va_high_addr_switch
    test
  selftests/mm: va_high_addr_switch return fail when either test failed
  selftests/mm: fix comment for check_test_requirements

 tools/testing/selftests/mm/run_vmtests.sh         |  8 --------
 tools/testing/selftests/mm/va_high_addr_switch.c  | 10 +++++++---
 tools/testing/selftests/mm/va_high_addr_switch.sh | 12 +++++++-----
 3 files changed, 14 insertions(+), 16 deletions(-)

According to the doc below, I don't add the cover letter, not sure if cover
letter is preferred, and if that's the case, the doc need an update.
https://www.ozlabs.org/~akpm/stuff/tpp.txt
---
 tools/testing/selftests/mm/va_high_addr_switch.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/mm/va_high_addr_switch.sh b/tools/testing/selftests/mm/va_high_addr_switch.sh
index a7d4b02b21dd..f89fe078a8e6 100755
--- a/tools/testing/selftests/mm/va_high_addr_switch.sh
+++ b/tools/testing/selftests/mm/va_high_addr_switch.sh
@@ -114,4 +114,6 @@ save_nr_hugepages
 # 4 keep_mapped pages, and one for tmp usage
 setup_nr_hugepages 5
 ./va_high_addr_switch --run-hugetlb
+retcode=$?
 restore_nr_hugepages
+exit $retcode
-- 
2.49.0


