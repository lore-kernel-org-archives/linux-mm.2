Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED09DCFD376
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 03:35:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B0C46B0010; Thu, 27 Nov 2025 22:35:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4884E6B0093; Thu, 27 Nov 2025 22:35:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C55D6B0096; Thu, 27 Nov 2025 22:35:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2B3606B0010
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 22:35:18 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E6A16B8555
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 03:35:17 +0000 (UTC)
X-FDA: 84158600274.22.D2E8B3D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3B3771C0007
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 03:35:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VqQLxoZj;
	spf=pass (imf20.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764300916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IKXZUrmhKSnLBrasgIFsU0j1OV2RdKEZHqiMi8x1qZQ=;
	b=W2L/Pg1ZNEU/QtFh5mLqeW11nKxF8oxxoZJ7YI+4OZV4XN+Jq3u3rSC201gr8YhEE+YlUL
	2lkf03ESmdgwv7M4VSnnDIReWsAowybr75YkYllBX8geU+kr47sPZC/8N3wMxSWeOnK2h/
	6LEi746+b/hhkOUVKgSV+2xrGJ/H8Ac=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764300916; a=rsa-sha256;
	cv=none;
	b=3q8PbFhmuvqINcaGx5mB/u5SB+Fo6KyQyvI9hu3c/M4B4QE2ReqtOM5vOYgOsxcAoafUPe
	IdtDmTSRBWVvmpC2EOtDuWfT2O1mvYMtOdvRS7Ei2UPMcwlOmZ77c0e19ahspa1qj4Gduf
	SclnF1AzXpJTgLRNziMw045kWf5IJGk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VqQLxoZj;
	spf=pass (imf20.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764300915;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IKXZUrmhKSnLBrasgIFsU0j1OV2RdKEZHqiMi8x1qZQ=;
	b=VqQLxoZjE1jXNhrUtq2A+0hGiEFi33m1M8AmWRS91Q4rWzG1jExaFzztt21rLLax5YLAM3
	jWFX1prwXwX1/R+yZyR8rpxejJ6opn7nsvY1dC9rmWgqgjqEzM+YBKDEOU+DP6qOfgm3EH
	O+93x1ABZrCF2ktL+gL+U+2/rNtR584=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-286-_d3nj9KnOtCZzyg-FTOf-A-1; Thu,
 27 Nov 2025 22:35:10 -0500
X-MC-Unique: _d3nj9KnOtCZzyg-FTOf-A-1
X-Mimecast-MFC-AGG-ID: _d3nj9KnOtCZzyg-FTOf-A_1764300908
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5E284195608F;
	Fri, 28 Nov 2025 03:35:08 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.7])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6219519560B6;
	Fri, 28 Nov 2025 03:35:00 +0000 (UTC)
From: Baoquan He <bhe@redhat.com>
To: linux-mm@kvack.org
Cc: ryabinin.a.a@gmail.com,
	andreyknvl@gmail.com,
	glider@google.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	akpm@linux-foundation.org,
	kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	elver@google.com,
	sj@kernel.org,
	lorenzo.stoakes@oracle.com,
	snovitoll@gmail.com,
	christophe.leroy@csgroup.eu,
	Baoquan He <bhe@redhat.com>,
	linux-um@lists.infradead.org
Subject: [PATCH v4 11/12] arch/um: don't initialize kasan if it's disabled
Date: Fri, 28 Nov 2025 11:33:19 +0800
Message-ID: <20251128033320.1349620-12-bhe@redhat.com>
In-Reply-To: <20251128033320.1349620-1-bhe@redhat.com>
References: <20251128033320.1349620-1-bhe@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspam-User: 
X-Stat-Signature: 7h7c6ncpa9cjthsk7dgz5uwz5mwimy97
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3B3771C0007
X-HE-Tag: 1764300916-659539
X-HE-Meta: U2FsdGVkX18IASxVFH+bAhCKqDJRtymnob22hKMQ7k9mW4yy+i49GshsXommnCq1Y8Xdk+yLmlRTs18jVyy5f8wb4/14N+hjxPR4WCJXLn3aIcRmxzQK+JObNNu+JmuRxALtNvgAZ+uj3FWQqzv/EK6Z2MpQjO74yIJStRJpW4mDk7lwW4TUGxUvRpB7Qq9Mfuer8U5Lmmh28a+B2XYwYrqrrZGIl+mupoq5mqUXnBn+/IAfSO3I6d0AIWzwpuH3I8bTGLWqcC5eYJU3rrsgprw5zj4xm9pUs42rkdXdGzwFQRNgsE6hpcxg4YS0hN6j4Bw7hZQTHe/SJqGKrGvkWvQ8vNANoC2DpZclyAJA/9ZESlDDvCnUuAUevkivDGI8k++Nufxfkai/mW8Gte0mq5g3+3lD3aGQIDuTgaiQ8sirthmtWQ2qquNRx8zz2DlCJSquYxDBWvS6tAJwUd/rULo14yEn2TMXFFi7O21T+bMMgv02ain20xD/QAuxhQk/DWYCXYEOc5JYcuOUxLo0RFrr77dthwnIP9MSh6rtdoKIV2/rjqRzeh1r8ayrL/j18XONtJQgMTF77KgNL9Bg2zjT5QwvI0GmxDV9cfsunZkO/wfpmsfK2PQNtF02zKZ2sOf9kqT7boMUSUnSfIQND/lPxcL4iGpT0JIg5CaJOzkeoBrfIouCp53y+qsW0ROCY9EPkGi329sXC0GZ75qd0HYMvYU1AdtZ7Z2XJWLfxnz5/nsuffdjwb5ao6aIO6zb04GMBHgVDkqfZt1YGuWacEk0kaavB9tiChzyrNGqZUOgQQEtweXImWJnwevhDnfpglCShW7ZYs+DNCY6amX3civvCkXJLWdcrgrBsOA3DVw3c38PPa/AhOKI2RVcTCdR8fAiaOGrk7pd4CtR1MQvyqAqnPgTWB+rmhcZFu4iTZ+NWHkx2R/kZZdn8+lWm/30iL0x+aF5Q+q1ZcrNXEs
 3HnXzdEi
 EZlNyZES5ZVelXNTB1N0HwF/kJKIDUuD9F10nvCG5VS+0apTaW/XVkBwE8TZHtwaFEH5hW4ErHuFWB4H7HvCDYZlbGcA2siTABssPaOLV/X3uim5Rf4T1x5Ys+mKVnaLIK3flivcKBS0dsK7Zbu9+BlEMsPLwpAVp53PnHbCMO4mwXbTDYZLGMlcIoQaqRnr/DvHmxgraiqLp1S/ea5IES+AmtMfAACSnWLZYcYyROAa9g4rlbRcmLiJO/X8/vl1achljCvFf7qD/+jpJJeG5N5gDr/jgn+MPADvyvfYAY0MYAhKpCQkcAWa2opyYePg7C1n6dkoL8/iKp88WrR5m162BXv4HX2ajkV4vYigs0IeLsq2JhPiZoM/svmQ1ScwEAu2S7iZKOe6UsLzXEhGIVDFagcLie/Gy2T61jMgYc1aA7mB1vn6Dmi5wrPWgDIgly1qBugpRNerSpJ4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

And also do the kasan_arg_disabled chekcing before kasan_flag_enabled
enabling to make sure kernel parameter kasan=on|off has been parsed.

Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: linux-um@lists.infradead.org
---
 arch/um/kernel/mem.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/um/kernel/mem.c b/arch/um/kernel/mem.c
index 39c4a7e21c6f..08cd012a6bb8 100644
--- a/arch/um/kernel/mem.c
+++ b/arch/um/kernel/mem.c
@@ -62,8 +62,11 @@ static unsigned long brk_end;
 
 void __init arch_mm_preinit(void)
 {
+#ifdef CONFIG_KASAN
 	/* Safe to call after jump_label_init(). Enables KASAN. */
-	kasan_init_generic();
+	if (!kasan_arg_disabled)
+		kasan_init_generic();
+#endif
 
 	/* clear the zero-page */
 	memset(empty_zero_page, 0, PAGE_SIZE);
-- 
2.41.0


