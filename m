Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9675ECA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 12:51:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 382388E0120; Tue, 12 Aug 2025 08:51:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 332588E00E5; Tue, 12 Aug 2025 08:51:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FA7F8E0120; Tue, 12 Aug 2025 08:51:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 094FC8E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:51:33 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D295B1A02E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 12:51:32 +0000 (UTC)
X-FDA: 83768091624.23.C534EBC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 120921A0003
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 12:51:30 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Mw5aXb8Z;
	spf=pass (imf19.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755003091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n2YWNQ1R3q2yuyqJw9ejU5xCE0/f1sakMXwMmNRUMe4=;
	b=Ob/aAjxOFLHEFJNG98VuMgAJNSkffw6tMEs+mi5VGFgdAWrWre98IvOdFWrgGmfVoSh84G
	12d54p3mSy/gz78LDSUn30QHR+IpAZIXWRovvFceNnAUJ4Oocqw7x4s5IoidTZVyytXX8+
	ohZxec9bpWEzF6RnBUVobY1KHEXFTEo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Mw5aXb8Z;
	spf=pass (imf19.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755003091; a=rsa-sha256;
	cv=none;
	b=lF1VivF/mLo3znDcPfA6DzAO1dFBzrfSw1vUAjSpfmBOltGitCdDCGRzQmXM6LOnzil2pC
	cG+fOspPmrKwNQEatPgVW6ti4P2c/pB9yDMyo/FE4xYw56QAzo6tO84CZhj0NluXU75z7C
	4JCE/gEqzBjQeT3+OCxYhnSsv+lJIvg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755003090;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n2YWNQ1R3q2yuyqJw9ejU5xCE0/f1sakMXwMmNRUMe4=;
	b=Mw5aXb8ZWUlfduAfzt0xMILGzSZgg0bjScmi3pasrX2FICiSh5wJau56BWpVHBFsTPsktq
	/psXyfRFyHqA/jHd0c+AELaxA1D1IEnVH8C1uPm/cM4xzz4vCSZiFk736BxbGPJqJTmnPK
	m8qS0cjbSp1reSu+LB9IRTRqW38xuiI=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-665-9kKnlE7PMdGWBVGqhx90ng-1; Tue,
 12 Aug 2025 08:51:24 -0400
X-MC-Unique: 9kKnlE7PMdGWBVGqhx90ng-1
X-Mimecast-MFC-AGG-ID: 9kKnlE7PMdGWBVGqhx90ng_1755003082
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3E4DF1800370;
	Tue, 12 Aug 2025 12:51:22 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.156])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BFF7230001A1;
	Tue, 12 Aug 2025 12:51:15 +0000 (UTC)
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
Subject: [PATCH v2 12/12] mm/kasan: make kasan=on|off take effect for all three modes
Date: Tue, 12 Aug 2025 20:49:41 +0800
Message-ID: <20250812124941.69508-13-bhe@redhat.com>
In-Reply-To: <20250812124941.69508-1-bhe@redhat.com>
References: <20250812124941.69508-1-bhe@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspam-User: 
X-Rspamd-Queue-Id: 120921A0003
X-Rspamd-Server: rspam06
X-Stat-Signature: n7mhmgjnx51z95nwr8zbjntnofpu3yf1
X-HE-Tag: 1755003090-894286
X-HE-Meta: U2FsdGVkX1/sYIKsCyOkbxbVj9yiolRio1kGlGgmVWReLxQ3W8y3r844+fL4gnKuPcmrQDrBXIXAU7uRyr5K2m1EKBg/p5RarmGmnu6DsNW3PKor6XHH0N96Z5oT7aXUBN8U4hzGZldET2bRslq5qg5rSz5iYgtokz8n48ADdOXS101vjcBjWjPKAdRHPPrZAfx0s/J9EsJP61SslxRc5kC+/GV+QceiaObNqc3EhGQbch81daPERR3qPgGcjDfP6dLl7ZhV2L2a/qs5NRgeK0hGR0T1yJ7KuwQRlqBpx4kEDWTFzgUbYUJ3K5RX4tDLY800yw3Dwxc50nbx2np+E2H7egFn+0LyGBZXSkEUB7t6K8HoZEuMhsyaBD15CeV8z67sR680GTIiHke1nKbZWv3GeM3BynPfSlnoXvuv4rvaZsmBI9bdpS46NKNk9By8Ye55fY8/riqyzL1QLQLKQkGImGyX+wiFFM7U9Hfdy5aTXyH0TrRKIDx9k/pRdlWRa9ZzaAygtEJYiuvUbtJq6RefUCholmPlVgkKiokLSwqHqJkSS/EYpk99w/QFSbzXmv4CQbpCdTWQnU1WCElTQdCKhHO8kkrZBj5SWn7fUsiHThzk9awRk9t8ZouDfnoi4JNyoG8lbTQ5u+5INmOPHLgYf8PkmOWW0Ziq16zxZr5O8tIuLNgt7w98FCV3NMB982/ESNDg5IcuMbnsW6LwHNBLn/jrNICJ4aoZTKaeNIBWUlBfPTHcsMn3mfX/wXqXZthxg1NS6TaA2GDoDC6Wt9c/sMYth003ZHsHUX2rv6kwLJSUf7Qabsco1af7J1mXgcBpdSNNxBmwvZeFjTIlF2taiHsOYB+fp1jfGNtNxnEYJrBcZs8FClFkLP4idfI13AhX2J2C7jfHXRyoNbfANkRyz+MES4UPFvrNW53AZRX8It8mGt2Ddb6jq1e6LkYwO3ZAubuU00JRC0VBSRY
 /UsFB1me
 6VgxZTvaXhd57pFGUXE3X3ovnCkqdkKKEFc51UyvM6jMQf1iiqIQEyX+6BstR5O4lHa/C4UJjExglL52hhFyr80Tbn3fbRi53almFxmR61tuFKm/fNT1vhWy25epx1TRUnMSKr06eCOUcgC9+FqU3+ueIgQ1LP7uHS0OzLVOOG/adfX1K/eqREAbB9G7BQe0UtKxu0tEkbLYpq92gHcpV+4R258OZ1WVBhbvWvCCbvSpMe4XZ4L44D/JRuygnprdNvcL4/TU1q3Ud5aN3/auoL7W1Dx1tgzcMlb0zamtNaXXOliaVC5CCb30mk/Ta30fn4VJxyEKoB1R/Gcy1FWVAVPNCjb8ACsWeNKbyXsJ2sBXJBBd2018CdNzPQpY7yc1+6Oi/axqBLwfS+BxsGqU2bUosuw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now everything is ready, set kasan=off can disable kasan for all
three modes.

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 include/linux/kasan-enabled.h | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/include/linux/kasan-enabled.h b/include/linux/kasan-enabled.h
index 32f2d19f599f..21b6233f829c 100644
--- a/include/linux/kasan-enabled.h
+++ b/include/linux/kasan-enabled.h
@@ -4,34 +4,32 @@
 
 #include <linux/static_key.h>
 
+#ifdef CONFIG_KASAN
 extern bool kasan_arg_disabled;
 
 DECLARE_STATIC_KEY_FALSE(kasan_flag_enabled);
 
-#ifdef CONFIG_KASAN_HW_TAGS
-
 static __always_inline bool kasan_enabled(void)
 {
 	return static_branch_likely(&kasan_flag_enabled);
 }
+#else /* CONFIG_KASAN */
+static inline bool kasan_enabled(void)
+{
+	return false;
+}
+#endif
 
+#ifdef CONFIG_KASAN_HW_TAGS
 static inline bool kasan_hw_tags_enabled(void)
 {
 	return kasan_enabled();
 }
-
 #else /* CONFIG_KASAN_HW_TAGS */
-
-static inline bool kasan_enabled(void)
-{
-	return IS_ENABLED(CONFIG_KASAN);
-}
-
 static inline bool kasan_hw_tags_enabled(void)
 {
 	return false;
 }
-
 #endif /* CONFIG_KASAN_HW_TAGS */
 
 #endif /* LINUX_KASAN_ENABLED_H */
-- 
2.41.0


