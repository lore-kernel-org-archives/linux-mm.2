Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D323ECA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 13:10:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 754008E0124; Tue, 12 Aug 2025 09:10:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72B988E00E5; Tue, 12 Aug 2025 09:10:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 668708E0124; Tue, 12 Aug 2025 09:10:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 52C968E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 09:10:27 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 07AE558677
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:10:26 +0000 (UTC)
X-FDA: 83768139294.15.BEC1636
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3EA0D4000B
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:10:25 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AjFMu9mM;
	spf=pass (imf12.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755004225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Shp71aTpcjkRwp8fdFozCS7DFDAA9ma8z9v4/SjxSDw=;
	b=Lx801k49JRAL6TbJG8Mdot6ASci1Sdh4hvJv/qToRsvJ1dsBCLWlG0AIIwH9yb+uhI+i7g
	LRMYhb586CbIQnZf1ExUPcxTcD3FSeYJi7k3+Z+ISZ6W0C2uJU3+vF93lRJ5LE7aEqIiT7
	+sf1E4nMCQVYXXsBvnBcMguitfZDmuU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755004225; a=rsa-sha256;
	cv=none;
	b=mt2RFfNGR0g8n16rMAlvh1nt5tmfFtl+WQUZfFfGpYD+ISc+OGd2xZxrJMYTaDM7OIB/7g
	/Nhhl/Ub1CfqfJqrwoB18xtEj11QS4TA1r/a+knlvz0p7e+xgLe+AE24RjyMwrWJth5Xns
	qcrZrasT5ZxC+YYmIsKmRi+nQ3oh5Ss=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AjFMu9mM;
	spf=pass (imf12.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755004224;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Shp71aTpcjkRwp8fdFozCS7DFDAA9ma8z9v4/SjxSDw=;
	b=AjFMu9mMHj/koIN2a/83vdrCIASVbbwJyQBeOBV+cv4llwtnAv7jsZ8kd40zFsySRK3TfH
	3QFfQDzMCyfbpioEFUJxJwS90D7z/kEel+cDycBMfcRTnlNTk49cIIYoa0QU3jd4Hb03C3
	UQbNo/vOySqsNwS1elZSW+AOYFm4Vgo=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-584-DibAMnFxNhOH8o8J4OV6gw-1; Tue,
 12 Aug 2025 09:10:21 -0400
X-MC-Unique: DibAMnFxNhOH8o8J4OV6gw-1
X-Mimecast-MFC-AGG-ID: DibAMnFxNhOH8o8J4OV6gw_1755004218
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BD2F4195608A;
	Tue, 12 Aug 2025 13:10:17 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.156])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D4E08195608F;
	Tue, 12 Aug 2025 13:10:07 +0000 (UTC)
From: Baoquan He <bhe@redhat.com>
To: linux-mm@kvack.org
Cc: snovitoll@gmail.com,
	ryabinin.a.a@gmail.com,
	christophe.leroy@csgroup.eu,
	hca@linux.ibm.com,
	andreyknvl@gmail.com,
	akpm@linux-foundation.org,
	chenhuacai@loongson.cn,
	davidgow@google.com,
	glider@google.com,
	dvyukov@google.com,
	alexghiti@rivosinc.com,
	kasan-dev@googlegroups.com,
	loongarch@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	linux-um@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	agordeev@linux.ibm.com,
	Baoquan He <bhe@redhat.com>
Subject: [PATCH 3/4] arch/um: remove kasan_arch_is_ready()
Date: Tue, 12 Aug 2025 21:09:32 +0800
Message-ID: <20250812130933.71593-4-bhe@redhat.com>
In-Reply-To: <20250812130933.71593-1-bhe@redhat.com>
References: <20250812130933.71593-1-bhe@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspamd-Queue-Id: 3EA0D4000B
X-Stat-Signature: zfin1jpfyam6fpyjsm6bdydg8z86zw3n
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1755004225-766630
X-HE-Meta: U2FsdGVkX19+X69K8oJgm6+Gm3qaLfLjznjzaGvPDkvb5TtQx0PRsrjg/zdM+ZWYgc4c0D5sjW/zgaJY+DrOMg+PmE9EziBVrFX/PtURROcKaTKnJ6WMNbgM9xfzBiZIWu1MsTOvnPdTmS6iFjzODBPn+HSdIwS5/YKNTlsfCDsZ2ZlsEvuDw6yA4jtcZv2hpdMOr+7K4zmweTQ4aJ94X3Kqfu+3ZUEpECd5Y9VSeSkSEb79bGSGKhrPSo5QYJhKuh8cBu8spVhjQnkB8kmtfPP5eH2XdPCkIch4QPRQfEi8J6/Et4WgNJ0FDi53WcpfMeSipqSbbN087OcE1i/HgEsGdKYCky10c+iNIAYEG4OAA1muNfXXCPkwhFh7apdKZPGEhQwiawKzhuavGaBBRsJBIOsPMB3jO+T4PnCkrKWMJacw3GhJjmG6aBo7ioZ6QVXTvgdR3w+r72r+c9qjqxWa0I7yqRY00mIGGU1MbsweOjTU33eEsFHkRGWQ3bArAp0P8RkaRPaEJW6FBEPIlslA1jaVcqIuHxva4jeYyKwSyBFNQ2dgEFzbPho5EX5iGZgeAbRQWyUkqGJp+9fbolubDnVaSnikcTr8kNSryJxzXjfMKdLvFl/9jtoHjgnEyFYF6Jn56Ba9tQYWk84VE1JUpSzOZhoW0qJhI0MB0oBnyp/ssT+VdH6a05AC+kgMVSJz6bLwSn0VjFG5dlEyVvjsYHTFUJ7KJeG9t9k8uq8IdZHPxkf/9lLKSh2pCCwY658+UWAmHBYhbFiT/lbfwZIKAF3DR14sJl97hgGOPXiWlK5s3vI6mXtUbqwmFoNSWvhjOyRd1D9am41GQsGuI1Nn6l569rMvukuW31ArueLn0+Eslgw+IkSypIXf9NbjgaeWd09dmRozPeNfW5dt7nuH9X1etwqYXpX1xtpcP4ByLeNF+ZZIsr6yM43mxPmLIfr2E3sZpl2co3cx8di
 pDSerK5z
 nge1cPa7BEBgf1wa/onyBAby0spZGD5v1LvQtkBB0otbRClmILZq08QbtHTnGkJ88an31RdLyplkDNYbyDJ0JRA2nUsTfeHse6Cz6V8T9UEZ7Zs2//OOeZd931NG1KBGDaErHMcn4o3JASdehMXuhs0vei2XYGOgPWmK66yP0AJnW6Gazgij67kxdqDfuPbltfgASkfToR834jf/XDUfEEXX04CuxMn2i0FQN9GxNMyRtR47zVqsQjXkI4/PFOPtMNnyQTMUqaEc8LVp6wP+F6OpYnHwhA8SBQSxSAvcJjHAczD0VUjrx0T8dRcek9ePZ/tx28XzojcE8t7j1erxZ+GqViG/sGrycYtWlTb54RMjrg5VyuvwKjXBnv6N1rmTnQQBo5N64k4PYyvQdQidHJxKusfjzXHWgmDfBSBL7Awu/QkG3ykNGG6NfjGRmy6QuDiV7W2wyfFm4xloI/mv7Sl84G6YRwsTBUFOG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sabyrzhan Tasbolatov <snovitoll@gmail.com>

With the help of static key kasan_flag_enabled, kasan_arch_is_ready()
is not needed any more. So reomve the unneeded kasan_arch_is_ready() and
the relevant codes.

And also error out if both CONFIG_STATIC_LINK and CONFIG_KASAN_INLINE
are set at the same time as UML supports each of them but done's support
both at the same time.

And also add code comment to explain why static key kasan_flag_enabled
need be deferred to arch_mm_preinit().

Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Signed-off-by: Baoquan He <bhe@redhat.com>
---
 arch/um/include/asm/kasan.h | 5 ++---
 arch/um/kernel/mem.c        | 6 +++++-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/um/include/asm/kasan.h b/arch/um/include/asm/kasan.h
index f97bb1f7b851..b54a4e937fd1 100644
--- a/arch/um/include/asm/kasan.h
+++ b/arch/um/include/asm/kasan.h
@@ -24,10 +24,9 @@
 
 #ifdef CONFIG_KASAN
 void kasan_init(void);
-extern int kasan_um_is_ready;
 
-#ifdef CONFIG_STATIC_LINK
-#define kasan_arch_is_ready() (kasan_um_is_ready)
+#if defined(CONFIG_STATIC_LINK) && defined(CONFIG_KASAN_INLINE)
+#error UML does not work in KASAN_INLINE mode with STATIC_LINK enabled!
 #endif
 #else
 static inline void kasan_init(void) { }
diff --git a/arch/um/kernel/mem.c b/arch/um/kernel/mem.c
index 392a23d4ef96..d62f494e0808 100644
--- a/arch/um/kernel/mem.c
+++ b/arch/um/kernel/mem.c
@@ -35,7 +35,11 @@ void kasan_init(void)
 	 */
 	kasan_map_memory((void *)KASAN_SHADOW_START, KASAN_SHADOW_SIZE);
 	init_task.kasan_depth = 0;
-	kasan_um_is_ready = true;
+	/*
+	 * Since kasan_init() is called before main(),
+	 * KASAN is initialized but the enablement is deferred after
+	 * jump_label_init(). See arch_mm_preinit().
+	 */
 }
 
 static void (*kasan_init_ptr)(void)
-- 
2.41.0


