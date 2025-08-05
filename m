Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7E4CC87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 06:24:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 469F86B007B; Tue,  5 Aug 2025 02:24:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 441626B008A; Tue,  5 Aug 2025 02:24:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37E5B6B0099; Tue,  5 Aug 2025 02:24:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2798F6B007B
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 02:24:18 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9FFFABE27F
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 06:24:17 +0000 (UTC)
X-FDA: 83741714154.15.E729526
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id E5612120010
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 06:24:15 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Er0Y0opz;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754375055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kJO5yIBXXOgt25+uyQhOeCpPCqEaTDSwq6fQ38qy9Bc=;
	b=ICkcmkDychRJV6uS6z6JqeTKfsX1WEgva5qlbkl2ww2QuN5d9rqP748XzRkJAAM2xCxwUa
	MpkXYqH79GbEimMVFue6aRqJcbreliPQ/zluktGcD9h1dsogsEkyOUcDJ/NdgW9SriCYaf
	NUf9YycxbXTAxpf+/qTgpE6TaGv9U+o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754375056; a=rsa-sha256;
	cv=none;
	b=2Y8sC56kXysCmA+kB7gzKs8XFuyZsk1kSHZN+MOakj7VAozxBhknjzj2j2g/Mntw9HU6XP
	m6pAHH/KhY0AODLH0vEUlcYGMo3nGYwB5e2Fe74T/mrptmuWzqTgHdNg40k4EfXuXaZ3nK
	vtGtWHxwcawDjgPnNV79ZBXt+JC+38w=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Er0Y0opz;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754375055;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kJO5yIBXXOgt25+uyQhOeCpPCqEaTDSwq6fQ38qy9Bc=;
	b=Er0Y0opz/V0RZYCr0TkKFMJ0EdQoLok/QP1FFMTTYBIYMGNWnCiK6ZgUJ6+GbqUNmf3awV
	WEWLIuCWShaeJYtuZvGimtvADpEswSjJoz9Wk4BlDf0Yjy9evfKrmHkb9vy5eM6QcrszyX
	boXB0a0bzm6iLXpEmpF2DM73rF3Mb2A=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-178-AR-aqPXUOv6YUb-9IY0KQw-1; Tue,
 05 Aug 2025 02:24:09 -0400
X-MC-Unique: AR-aqPXUOv6YUb-9IY0KQw-1
X-Mimecast-MFC-AGG-ID: AR-aqPXUOv6YUb-9IY0KQw_1754375048
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A0AF61800876;
	Tue,  5 Aug 2025 06:24:07 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.136])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6C6CF1956094;
	Tue,  5 Aug 2025 06:24:01 +0000 (UTC)
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
	Baoquan He <bhe@redhat.com>
Subject: [PATCH 4/4] mm/kasan: make kasan=on|off take effect for all three modes
Date: Tue,  5 Aug 2025 14:23:33 +0800
Message-ID: <20250805062333.121553-5-bhe@redhat.com>
In-Reply-To: <20250805062333.121553-1-bhe@redhat.com>
References: <20250805062333.121553-1-bhe@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Stat-Signature: iac7ix7c9yzq8pnm68yj8y558a5xzrib
X-Rspamd-Queue-Id: E5612120010
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754375055-627614
X-HE-Meta: U2FsdGVkX1/J9+nBHw02ZVmwFlAwPEFWr87G55FYpC51cvHMTRBUUL97WpH/O7KL465yhIgh2NV71EZM5KJbgkDjI8ZdIvR8RPy6tVQPCiuvIImENjBVgnGFWjRziMQSIlkl4Jb+VDZNH+5J6fNNbIJKhizLOvHErnjbq4TScDirvoU9LXSXQhz/lQD4f2dFNOpegGgLhT2yhDrJCYY3awVLrE9HWfW/c5YVMSrX+hV/kh0NSxB2rCPxP4UHX7STQxWIjuC80OMjuDI3iVwSz/LfOAEG0iqnwPRtSYHv6iX9eGAFCPy/fyPuzjMOq+vdnKdS/JyrfzlWbWqKukzaz2arm/AnAvAIYDDmWFtj2lsCGMJDLhad/oRaPawEfZikzbp6tHgZpmq1xn0vLYAv1B4QuEncuDC8eAgfimCUw5Hvd7nEpqksY3D/my8RlKSL8qe2QrVDimIcX0TK3GWSpVOBvvV6kAzS74bVTTgY6kE/8Daa9BJrPWQRpuznfw2C1oz8kTZEF7FFhQ1CUa5+5eav7pTyiIrignPviZrCalf8CzxUcFQqs4es+zmJ37d9NfKsT61gJyOvuu9ZYWpCa7eEDg3B2qttv7KXmNHmdq2mpKjbO/84g9fPcL5/uXXBLgMys1EWhDuzeiMEdqK4uwzzu1a9qi3/EHQ0rTV5m3t8CdEgwGgbt3MEa34jOgKGvLp5sPNksURTI/tie6hL77ap85JoPuDZIq9RdIh9LEEQsWKBvrYYPu6P7ZEGG/zUUHdwIV83OWnBY8rbxsA5tVsipXgh+0L2zPHSx1dx+UJ2UFUyq6tOIbEbYLkv0QlbzEv+fqCRmgugWg9vOggNDDIjA2v6GjZYWZGK67dmKNLSTTCPCER2/cpJOBgNNgodnSMzzfb3lSxwHN9vIEgMOtZwxbJxifPHZ70ln+cX1Cy3GQna1pWdSxzDR8j/NWxUnpGQJf/pWE1QYmCImIi
 Oi9Gd64K
 IPG7NojXJ6jynRcAo+7oe6pGsPOj9pdbLCQfqd0psuyrL580qFCR+Vng0RZ1gJzepOAqatCsmguReVylZQ4Anu4CkOuFM4mc4zcYFWxE79QficGprKEqnmxeHjtVws5ejcxAaWC4JDxCFtETBUNWwM+ZBIhUz4/7PgbOzmPVU7vFE32YmCWLnqcDxbe+P0eRvXZc2yPH96dFih02aD/OAHbJre52aQ3Jubk0sl7wllvUj4jgiN/iovDNFnSkdg0feI+OUmL2nmdyJ3a6kv0AILTl4xqbu7lVS2xEe5dV0SfZQrkt77umix6duIyP1gaX3LevKVNzS3swB85hAMYprqVyknVC4+Di1NXXoLt7BShoJWD/Oj9aaATZo94EfInDBI09cOPifCOtJfMlvzSfYjHJ9Yg==
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
 include/linux/kasan-enabled.h | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/include/linux/kasan-enabled.h b/include/linux/kasan-enabled.h
index 32f2d19f599f..b5857e15ef14 100644
--- a/include/linux/kasan-enabled.h
+++ b/include/linux/kasan-enabled.h
@@ -8,30 +8,21 @@ extern bool kasan_arg_disabled;
 
 DECLARE_STATIC_KEY_FALSE(kasan_flag_enabled);
 
-#ifdef CONFIG_KASAN_HW_TAGS
-
 static __always_inline bool kasan_enabled(void)
 {
 	return static_branch_likely(&kasan_flag_enabled);
 }
 
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


