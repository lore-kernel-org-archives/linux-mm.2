Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FF20EFD208
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 08:15:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3BD46B00C5; Wed, 25 Feb 2026 03:15:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D13376B00C7; Wed, 25 Feb 2026 03:15:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C32BD6B00C9; Wed, 25 Feb 2026 03:15:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B17DE6B00C5
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 03:15:06 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 268C5B9A8F
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:15:06 +0000 (UTC)
X-FDA: 84482268612.28.B435FC5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3491A1C0004
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:15:04 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aBQ7Cu7o;
	spf=pass (imf21.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772007304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m4icHQGTRNbNNPTctslHsQ21pBhC6HpCZWDHuC81RQQ=;
	b=ziIanm/2i3qVBRcwgspdIArBLZACCnGuCHvqtpifjT5JmwRouUJyzi40+CbsfsMQcNb7iw
	3LevWOQZjiCE1kt+7uycoDWekrGEffAy4P4FEI5xN6ZEwQti8t6eFQrqDr6kzmV0du7AIp
	QhSbQeOyOXhzubQSktBxldMkvrf7bX8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aBQ7Cu7o;
	spf=pass (imf21.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772007304; a=rsa-sha256;
	cv=none;
	b=8KaQrFdHe5hKAWMoYfqHOT2pozYEGy/0enm+xuZFM90ra4kcC830cNN1rvyAR1Hfr3LQig
	aa9PJbRYOLcfZTroFhuL7ZYTSof7OmCDUQSi0qtJwSk6LE8K8i2timscQbK+lrbPEpBJDw
	R0JQErdF++iqW8TkUpHZolme+dkRxPA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772007303;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m4icHQGTRNbNNPTctslHsQ21pBhC6HpCZWDHuC81RQQ=;
	b=aBQ7Cu7oIvPXDrYJy06P2ZPPWanvHEuZVoeLwrmhebJNEc/doj5sczyJN7jSRkUWzIu+cl
	mNStw2v6lGkxQMi0l5Oij/vV4T6OOQwEioX9F7CX+ACGAC+Qv1MH4vTuCkc3CD4AL0rhi3
	1+EUtw4CB0s8jofjbiuSrXHxWyLVJqk=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-647-dIDhZlzRPtCltfWDvHZypQ-1; Wed,
 25 Feb 2026 03:15:00 -0500
X-MC-Unique: dIDhZlzRPtCltfWDvHZypQ-1
X-Mimecast-MFC-AGG-ID: dIDhZlzRPtCltfWDvHZypQ_1772007298
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A1EFF180025C;
	Wed, 25 Feb 2026 08:14:57 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.55])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6EC9E1800465;
	Wed, 25 Feb 2026 08:14:49 +0000 (UTC)
From: Baoquan He <bhe@redhat.com>
To: kasan-dev@googlegroups.com
Cc: linux-mm@kvack.org,
	andreyknvl@gmail.com,
	ryabinin.a.a@gmail.com,
	glider@google.com,
	dvyukov@google.com,
	linux-kernel@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	loongarch@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	x86@kernel.org,
	chris@zankel.net,
	jcmvbkbc@gmail.com,
	linux-s390@vger.kernel.org,
	hca@linux.ibm.com,
	Baoquan He <bhe@redhat.com>
Subject: [PATCH v5 02/15] mm/kasan: rename 'kasan_arg' to 'kasan_arg_disabled'
Date: Wed, 25 Feb 2026 16:13:59 +0800
Message-ID: <20260225081412.76502-3-bhe@redhat.com>
In-Reply-To: <20260225081412.76502-1-bhe@redhat.com>
References: <20260225081412.76502-1-bhe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: WZOnLQ-0MddOIO86PvPH-JkHPC4J35HcYTjJFY-BAxs_1772007298
X-Mimecast-Originator: redhat.com
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Stat-Signature: n5yzppr7ikegrktpf6drt76paxdyw8rq
X-Rspam-User: 
X-Rspamd-Queue-Id: 3491A1C0004
X-Rspamd-Server: rspam01
X-HE-Tag: 1772007304-890971
X-HE-Meta: U2FsdGVkX18T8oL+7q9jlaIkVuLrFb//lWBPS53AaLOEVzJkhyRJqQ8PNVTxhp6JS408YB26JulMAdh2OdznwFUkiJhJC2quRCzL3wwpzpefOwaLIIYEyx6GrQi1zcfrglfbx78ymZjoISRAi1rofwdfAPgu2kb+2awwu6z4XXqOaNjvqm9irxaUHz/Op4VuCHHzVAzXqmObXKnGHLq/P8XPeqGQT27Q4x5yVM2qQy+xkYiatKRF5FVkjKjjluKiz9dC3dRVONeyWqKBFuknOco5gg3X361kwg2oI4w1uAdxaGTlChuth9lqGszXy6HSKRoixugnnOCqc81n6fRd14clftRgolKmMqF66ZmcBPl3q9+GFSxLPI8sRbWeHctIgFhCxKGa1kgXII6fD46vXuU7BkyXTsFBs+Dx5YDX/YXg999CPxIbpgOEtlhCHVkC23d7MomJGRf9RyBDrmcvsNjszM8ORnVg05LrZuPeUsY1lWKBLsbn6QMm2EtSUYgWgjB/E4j4mxRC5/dixuuy1Ci3n7vZ28S0URlg3V/SVbOMdrbBBhCD0zoOIQyxtR3H5992g7CpRxNB/zgACTkPZ3cDc4EI+1DotUTcXbPBGl+tJBNqdE5j8IbVFB/o9bkqBrvyQhBNopzD6IuLkmgpBsBbyMotZBav73huG6JTrC5LKK5p1PKS3o2+pZdSvrVzkzUwQmFHNifOz7D8EGrR2Dgm+/3n5gSi3yxSabIefff993F1/6ZLMdk4OeA0q1dCzCgH5BZVQYhjTHD9EEnCabdQGrON8i3riCHv0Tx7vM689EDQs/913x4cceu6xAGlI0FgFE+M3olYpjdnvnQ6UhWHfCvwwn2zokUQCJhtmkPNXYi/QaDgREcVOo44nYr0WZKH1v1Plt0k5XNfVlElfp5ak6g5g/1hzWERWkjV3RkIrZNghpaTCTt/sldoPD/l6lqVql4kHk8xeht9vXg
 urcRHKXv
 6kJRXvTzxHpRdSx+QSXvwQLejM7xbJ86/NVdhUQXH/CXIY+VOLB5dUTN9Icpd4ayUzsqAOZucn/bh5l97O4br2UF5nFls+zRVBhfwS5HctVH9bfC6mpaAXp8e7ruSvvJ0yWazDnQ6o6JrxlTZPv9yyZWon5PIElu1Y3exU8su8BE5GffUJqcAcdp54MlCid8/9b15DyAEO6sfL1IF/TNN7HGFiDTzGp3Mh6ze5MZKKyGAvNsJCcvx+zoKi3Gfc4YIpJ1bihYv5cjA4npwEd44qFJgSvqoT5bUJsz7l8DmPwVirHLV2/KpnLE0LN3EX7P8qKFkgliCCYLJEk7BSphYERDRP7Ah3qpa+8toDcWrHAvIK/mEO7nrs+yixp4rf7L3Q6Zq+3XiY3fBSFNd2s/Pi6j8gBReDZfddqklcsmf+WDJPtAtGOCTAeQHkFu4nMJXtj/Fla0jJ5LHNHCvX9PrF9/joD4eqgtv8ARQau841BoIf2rEi0pIeO8rQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

And change it to be a bool variable. This is prepared for later
usage.

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 mm/kasan/hw_tags.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/mm/kasan/hw_tags.c b/mm/kasan/hw_tags.c
index cbef5e450954..26a69f0d822c 100644
--- a/mm/kasan/hw_tags.c
+++ b/mm/kasan/hw_tags.c
@@ -22,12 +22,6 @@
 
 #include "kasan.h"
 
-enum kasan_arg {
-	KASAN_ARG_DEFAULT,
-	KASAN_ARG_OFF,
-	KASAN_ARG_ON,
-};
-
 enum kasan_arg_mode {
 	KASAN_ARG_MODE_DEFAULT,
 	KASAN_ARG_MODE_SYNC,
@@ -41,7 +35,7 @@ enum kasan_arg_vmalloc {
 	KASAN_ARG_VMALLOC_ON,
 };
 
-static enum kasan_arg kasan_arg __ro_after_init;
+bool kasan_arg_disabled __ro_after_init;
 static enum kasan_arg_mode kasan_arg_mode __ro_after_init;
 static enum kasan_arg_vmalloc kasan_arg_vmalloc __initdata;
 
@@ -88,9 +82,9 @@ static int __init early_kasan_flag(char *arg)
 		return -EINVAL;
 
 	if (!strcmp(arg, "off"))
-		kasan_arg = KASAN_ARG_OFF;
+		kasan_arg_disabled = true;
 	else if (!strcmp(arg, "on"))
-		kasan_arg = KASAN_ARG_ON;
+		kasan_arg_disabled = false;
 	else
 		return -EINVAL;
 
@@ -222,7 +216,7 @@ void kasan_init_hw_tags_cpu(void)
 	 * When this function is called, kasan_flag_enabled is not yet
 	 * set by kasan_init_hw_tags(). Thus, check kasan_arg instead.
 	 */
-	if (kasan_arg == KASAN_ARG_OFF)
+	if (kasan_arg_disabled)
 		return;
 
 	/*
@@ -240,7 +234,7 @@ void __init kasan_init_hw_tags(void)
 		return;
 
 	/* If KASAN is disabled via command line, don't initialize it. */
-	if (kasan_arg == KASAN_ARG_OFF)
+	if (kasan_arg_disabled)
 		return;
 
 	switch (kasan_arg_mode) {
-- 
2.52.0


