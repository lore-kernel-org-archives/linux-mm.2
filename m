Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 961F9CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 12:51:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30C6F8E011F; Tue, 12 Aug 2025 08:51:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BCF98E00E5; Tue, 12 Aug 2025 08:51:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 185868E011F; Tue, 12 Aug 2025 08:51:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 04D688E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:51:23 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C38661A0306
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 12:51:22 +0000 (UTC)
X-FDA: 83768091204.16.0BCBBF4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id F10931A0006
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 12:51:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Kwm+UoJc;
	spf=pass (imf19.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755003081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UNvwjh3bkLYd7LcWTIY96phbAPIdD7DxmW/f2AxTNdM=;
	b=vnO3ySLB1Tuhc0lqzu+rygPR6v+l0rpzfblXiwV6HiokCNwfc22WP682+WdhuxonPMEhMw
	VOO5OJmuGJZPS0Q6JcEgczyLfq0l/5WyXfnXIb+Dw0kJlgG3/gUZogOZtbOHEdAvOk/a7n
	+QPkNPw+g07ZfLhL7yeqFfhedGIaq7I=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Kwm+UoJc;
	spf=pass (imf19.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755003081; a=rsa-sha256;
	cv=none;
	b=fM5pNeUl9mAn+H454rFNk4dZ/Zr4MVTZ3s8voD5xoj56cHfouNVHcsp/y3/fOasvNfP64w
	+UsVSnIO7ENr2dqlnS8o+cDK3WFraxp1/844h6ohi9de7fcA6LO1+N7nJxuGt3w9Vpf3Iq
	ghleMUTMKnZz7ooKdx1vFURq8c4VYHI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755003080;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UNvwjh3bkLYd7LcWTIY96phbAPIdD7DxmW/f2AxTNdM=;
	b=Kwm+UoJcvmM9myIAtNUf7wi/n39N/hhapSb1NEygAlIw3Ep8DwuQit1rrDXKIjESkKXS16
	1eu0DW83uDjc2otHVu3epAuOpZMN3fmklTBnBNrTIxhAKQ5INAOwt4nIttJJ5UOdAXjctM
	qHGGFVVjeGOSmH3bgs+RCb9lyER3+tw=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-515-BarAkwZZPNi3t3OI2JjPPg-1; Tue,
 12 Aug 2025 08:51:17 -0400
X-MC-Unique: BarAkwZZPNi3t3OI2JjPPg-1
X-Mimecast-MFC-AGG-ID: BarAkwZZPNi3t3OI2JjPPg_1755003075
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0A2E81800352;
	Tue, 12 Aug 2025 12:51:15 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.156])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8EAE530001A1;
	Tue, 12 Aug 2025 12:51:08 +0000 (UTC)
From: Baoquan He <bhe@redhat.com>
To: linux-mm@kvack.org
Cc: ryabinin.a.a@gmail.com,
	glider@google.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	akpm@linux-foundation.org,
	kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	sj@kernel.org,
	lorenzo.stoakes@oracle.com,
	elver@google.com,
	snovitoll@gmail.com,
	Baoquan He <bhe@redhat.com>
Subject: [PATCH v2 11/12] arch/um: don't initialize kasan if it's disabled
Date: Tue, 12 Aug 2025 20:49:40 +0800
Message-ID: <20250812124941.69508-12-bhe@redhat.com>
In-Reply-To: <20250812124941.69508-1-bhe@redhat.com>
References: <20250812124941.69508-1-bhe@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Queue-Id: F10931A0006
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ojtb9nn8ztm66jgacaaq43iu4hkbhsaj
X-HE-Tag: 1755003080-66647
X-HE-Meta: U2FsdGVkX197L6IJGVyD8Wl9kAiCOg5RNiwqdqDq7McLz2IVkaJD/oPVntQtdA2FsdSlp6G7Snxs+m+oVmuV81Ece3vESvRU+gd98CAumoknKN1CcYCimFmMRvEP+G/LfFVf7BnW9ZRLw5Z6mAfj4TnojtVWUH/xPoUZa2o8BjkBrZth4NWgLj0chPvn0lKjQnMP1vg3fc7lk/UkV7pneoUbMX+IZgDRiuixoxT4eCx80eHX2VFsoYqCJJNrkxCneA0dGzeSFK/hWTg1/4kqVpvDI3EVbJgOXKbzcgxiMFvnbaKp8l/cuLTqaay6mZVRkz0Lx+6Wut99cfQSMghKQHM/OjRJTPl8njJFYBW8MFUq2C02eL6HnsmQg9EbOUirEDdlbifBkv8/DDatyAW4s9ukfeAt4nxpjwnZkWW4Z4Ip06kZS5MYPAFlTMCEh5FkYzF7UQ2NIzk+T8JYK52MgQkmxeaX7ixWXyPvWNBav4U4aEBStB1MHCYOu3dYNr+CzaoPyfHGXgi1BwWccElEpGzD4Z9W1XqqzH8GLleg+1DUj5JpchdfGyEiB3XyMzq8CNSPAGc+vic5sLqr7l7RqtFQBUeWkh1vb6xt9D906fMgFSyvqXkYclRxP/1Wl89fJ+KPVtYInmTXTHHqK+r6YfilNVnLP1vp/wbfJmk/x6zsOZDo0XKcYzGmUQPydJDdY/IoUsql+/SI69k/eYxv1Ed9LFKazQ97/mVui0drJjxkCHEpdeLpAL9JMcQ9Yp7uq/hf9eJS439Nf9egpaJwTOJ6kQyOXZZFLWG7UhxBGGzUpFUwnUjMS6XPtzZQkiNofxY3JhwRwJOeFG2vDcguvFCLZ++UBEna+0kJF0VIHgydwWcZpMBaaM7lBt098WqXB8Rg6KJ9KgFYdaNMRWXQYrZrLwW+Bhkv1UbjL2k2BDXBQYMViml/FYypKsTGxa9/87Tek8u8Dcmmm/eYoiO
 clhE1Zdl
 NBDF3+GV0JYaW763LugKmzsG/u1Ee5WsK868XUtouxfRkvRxOmfJJBTnhPHAJ4T0rsvdQCbnHVt5JnCXv72QTbFFw5kkXgo4iEozF/jUYDFghf7Pi/HWs5VjXhsaO2I9YoNBle4fOO84MlGheouOhh0JOYR29toojh+xObgSqMO6l02WT+2BPva1nb01TGay3I+DjA9KyFouGtOFsDF4ACxIam3goUsRDwVy0E5YYKcDHXqaUt6gEiSYIelnd0vv0MqsACV3pVm2ioQ43XtLNbj8WulaJ1y+JAOs6L4BX7nn4tBVjsslG11f2eOi/gB7rxSa7OLlhb0aaQ3ImMF5S7tulSuOBFW+cg8IU94o7QiclXcu986K+XqEaiUGsE4jrZO36hhytmvxW9L6Jy517hpKbZA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

And also add code to enable kasan_flag_enabled, this is for later
usage. Since kasan_init() is called before main(), enabling
kasan_flag_enabled is done in arch_mm_preinit() which is after
jump_label_init() invocation.

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 arch/um/kernel/mem.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/um/kernel/mem.c b/arch/um/kernel/mem.c
index 76bec7de81b5..392a23d4ef96 100644
--- a/arch/um/kernel/mem.c
+++ b/arch/um/kernel/mem.c
@@ -26,6 +26,9 @@
 int kasan_um_is_ready;
 void kasan_init(void)
 {
+
+	if (kasan_arg_disabled)
+		return;
 	/*
 	 * kasan_map_memory will map all of the required address space and
 	 * the host machine will allocate physical memory as necessary.
@@ -58,6 +61,9 @@ static unsigned long brk_end;
 
 void __init arch_mm_preinit(void)
 {
+	/* Safe to call after jump_label_init(). Enables KASAN. */
+	static_branch_enable(&kasan_flag_enabled);
+
 	/* clear the zero-page */
 	memset(empty_zero_page, 0, PAGE_SIZE);
 
-- 
2.41.0


