Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D70AEEFD209
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 08:16:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AA466B00DB; Wed, 25 Feb 2026 03:16:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 268456B00DD; Wed, 25 Feb 2026 03:16:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 181EB6B00DE; Wed, 25 Feb 2026 03:16:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0188F6B00DB
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 03:16:41 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B4C5C1604C7
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:16:41 +0000 (UTC)
X-FDA: 84482272602.29.DB16C49
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id C9E61A000B
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:16:39 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="e5kUXn/3";
	spf=pass (imf15.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772007399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ufH5nmkXpWJzJI9ksuEPClUSVztzr8yoo3w4HNv6hNs=;
	b=BHFUBKMyHLgtqz5afQrxxi92EHwppwkHcObfhR6Crd+R/QLR9KlK4DdOSckLCV6/jkAA/l
	MhS3dhVD94LGWcGziwz5G3g7QbZFxaLfZAwipjlvjE2OJsHOPdWkL7kOpYG+jWGGJnTeaa
	jqHAcIJRpKjsdje/Ull7QWEolvtmccg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772007399; a=rsa-sha256;
	cv=none;
	b=bjCn43g8sS/rw+IStau73vs8OVuIH6K1LYTfmAa8InR+0YEpWfTMj7RwCwactkPRuJulqR
	b4FfpwlZ9s4f3g+OM/I7CqSdGbc76CkTg1wutVqyDP4CRz878Hhog+yd395Y53wVBTp96j
	FFuUKmBR/WEfHBm/YpkM5fI8lq3n/EE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="e5kUXn/3";
	spf=pass (imf15.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772007399;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ufH5nmkXpWJzJI9ksuEPClUSVztzr8yoo3w4HNv6hNs=;
	b=e5kUXn/3mhffdK3f9Raaf/GTZGh/L6Ie1W/AsQ7SgVhmeoJCDKGLXPxi9DNqJnvFDyVNGX
	9HCm6ucWNDeoJ88wccLJregxSzVz8/csWyKfgxA5jzOLkP37NA6uhyrzSy0CPcKuWWJnM3
	vqBB7MHXLu2YQJ2Vl0rf8+CudM2NOPg=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-648-Jj4asdUeMuyAfccAe_OsEQ-1; Wed,
 25 Feb 2026 03:16:33 -0500
X-MC-Unique: Jj4asdUeMuyAfccAe_OsEQ-1
X-Mimecast-MFC-AGG-ID: Jj4asdUeMuyAfccAe_OsEQ_1772007391
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B293618005BC;
	Wed, 25 Feb 2026 08:16:31 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.55])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5C45A1800465;
	Wed, 25 Feb 2026 08:16:20 +0000 (UTC)
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
Subject: [PATCH v5 11/15] arch/x86: don't initialize kasan if it's disabled
Date: Wed, 25 Feb 2026 16:14:08 +0800
Message-ID: <20260225081412.76502-12-bhe@redhat.com>
In-Reply-To: <20260225081412.76502-1-bhe@redhat.com>
References: <20260225081412.76502-1-bhe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: -XF-B-xhLrbDie7OOo-1sDgF7rvRFzQl4zmvlG_fQuw_1772007391
X-Mimecast-Originator: redhat.com
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 7maea1pdtges3scpoutd618ga943w3y6
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C9E61A000B
X-HE-Tag: 1772007399-453589
X-HE-Meta: U2FsdGVkX1+NOp8OciJLNkNMi1CSZBILnyT1VGzD7ZCfDzuLudLTeVm6Eq7cN/0HC9UQsMdFc7VCE+ZE7XDhPXNWeJ6F+yzhx1HvgpMyBMgIHrDhx8audNK6EG4JtHki1FWlmjWj+cHPRyWX19955cGaWX+3urC9m1i10pOV2l4lodyLocdgKbzsDIz75QZS63Tnc4rAnL7A+AVZ1M3z+YVA3E9Rs1Bu3SqdAr5zhDL3tUm1cAvlYZdMwypfXGiFBFnQGLHWaKVzUkNBpwRseyYVrYm9+oax+I1O8lwuMyk9tOzkk5I2vXX2mVfji6lP1n4sPaWMm32Np+N+D1lXZyH8TWDkWxUUZJZHKy0+bEcbs8pVXFX6rKPBWdW0fCh/bJFOEsEWEYlUqptkrOipbJre8Lw2ilFfKiFB+vMe+Hca/UzQwY1h89YYuceQWg/izJd1F7y3Y4KFu2hUEg4DRN0b+/Zs/61N4cBdrSPInvZ/IGD8eLConbm6jfm8qwg7+PFkMUVP84JLlxJkhAq9S4ni7DfKuu0yo8pn4QzYoOfAaS3xgCPTkRHDbJu6aQB1ak61PrNDbjQrOflgcRtg1P1QP5QzefU5LM4ex2fS1cKoLgX40V8h01J4s4+YUQD4N8oLjR50Af/B+wM/uuE3ojm1pBN+sy8DrNUfgJPaG4V6GT+1bhOZEL9Wq5kNBNVqu7kpOKRuSn3mWLLgtFtwSs5BDjJRuCiCtH0dxfI0LkkyFRAtPm/5b8MarBc5pBbD2dNTLcpn7NXe1t7mpJlKFGljoKJpDSBjX+gvFLd7mvmkbHLpFQu+w8YoN8KgN2yQ6lpv5WxQfji0iXAFH3H3+K45F3atd+oaJyHp3qLS+pRQHTyHxLc2VhK0/zMD4Y5T8j9e1VsTaPg5+uUfkC8Z3nBz+4pO53GYuUukrSPYdLTNAfkorLM5eMiVrBpYkG1BFl9gB0bCgcRNkBhyFzF
 +EuQbXj3
 N7Ph5u9rl+VU74Jjw30UHEwiUYKKuhqmO08FUMEAWCu8PE2gEn/4zSwXPDha6St5ik5ql4zv0vjxO3mUhL1sS3cEglC9xDMmIsx2kHFmLUtstTsQsNOr6bKTfma3ZanHu3FIIfPb6iXCQYg56575GFb51wsw/wYRiBWDg7LDNOqCZHdjq8YHH82SC6AE4j/rBe3/hiVYxLEpAbOzZ2gHeUisgT/IKzVvzTfPav7Ppewf5ieFWX1+MYIQPdL+/5xHcrvf/o2UYblL0EbeACWsIoBn/biieyuj+lUSTjxIoXvEiVT0zisoaB01rZLzeTSXmS6MRN60cM+d0hyqogMBX4EhH0hY2fWtLhmJ/bxpIA+QzI+SPRqYh08tCaQaafz8BHQRIpJwg810TzP+Kn6SzES2rMJtX4aAYZDirIgwBTK0jf78=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Here, kasan is disabled if specified 'kasan=off' in kernel cmdline.

Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: x86@kernel.org
---
 arch/x86/mm/kasan_init_64.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/mm/kasan_init_64.c b/arch/x86/mm/kasan_init_64.c
index 998b6010d6d3..5ebf2850c77d 100644
--- a/arch/x86/mm/kasan_init_64.c
+++ b/arch/x86/mm/kasan_init_64.c
@@ -343,6 +343,10 @@ void __init kasan_init(void)
 	unsigned long shadow_cea_begin, shadow_cea_per_cpu_begin, shadow_cea_end;
 	int i;
 
+	/* If KASAN is disabled via command line, don't initialize it. */
+	if (kasan_arg_disabled)
+		return;
+
 	memcpy(early_top_pgt, init_top_pgt, sizeof(early_top_pgt));
 
 	/*
-- 
2.52.0


