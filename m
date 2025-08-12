Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B88ECC87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 12:50:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57C018E011A; Tue, 12 Aug 2025 08:50:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52C008E00E5; Tue, 12 Aug 2025 08:50:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41B588E011A; Tue, 12 Aug 2025 08:50:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3126E8E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:50:46 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DDB80B6414
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 12:50:45 +0000 (UTC)
X-FDA: 83768089650.27.1905039
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2122D4000D
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 12:50:43 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="X/XdSs8P";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755003044; a=rsa-sha256;
	cv=none;
	b=di/dydWIZUKWezVgF2pk7P93Net9mbJUqC058FPp/oql0EdEcGFaQBWAKjjk1Ezzdcp2zi
	WZr7vhbfk/jS7a/Sv8noyrAUEc5+jmYrGc98682vdiqdwYd0dzFXTjjJz1uyMYUZ3BiaeA
	Jp08nyQlHSwiV2liucrKecBgd06F8+o=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="X/XdSs8P";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755003044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QN1Z1dUeks4QygHE7wKCYxkrDkPOGTvp8PG+uI+E7oo=;
	b=JiagdAtBAlBlm1zlYIEi/ZKCFP2SeRYFn129w1c3KBG2+HIlo+yYfGcRT1hQhhNhNIbOj+
	GNW9fbWq0Tc/c/obMJZFeAFYHryEPBpV4/cG+Yt0+eAxxMb9u7bTQVOsVEeLlYp+xcxVGr
	pDR9QMwXqVUMS1n+q4tgptelJkapFis=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755003043;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QN1Z1dUeks4QygHE7wKCYxkrDkPOGTvp8PG+uI+E7oo=;
	b=X/XdSs8PTu3ylJyvanUGtztD1FqXURsn1U86/F00/Yes2x9egJL5eqkDSvad4yVdK1n/Op
	oeWIGDO4qvGzbpVixQSejg51xwpFK5YU+hWhCIYHOXlKw4RCQwY0sbaoXjPwv9kCbXR3Fl
	7otrlob90Zu6je9qFRTIMuc8L3JvUUU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-620-at2M-5U8MMOmrD3AvQwZ7Q-1; Tue,
 12 Aug 2025 08:50:40 -0400
X-MC-Unique: at2M-5U8MMOmrD3AvQwZ7Q-1
X-Mimecast-MFC-AGG-ID: at2M-5U8MMOmrD3AvQwZ7Q_1755003038
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4CC9C1800773;
	Tue, 12 Aug 2025 12:50:37 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.156])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C2C97300145B;
	Tue, 12 Aug 2025 12:50:30 +0000 (UTC)
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
Subject: [PATCH v2 06/12] arch/loongarch: don't initialize kasan if it's disabled
Date: Tue, 12 Aug 2025 20:49:35 +0800
Message-ID: <20250812124941.69508-7-bhe@redhat.com>
In-Reply-To: <20250812124941.69508-1-bhe@redhat.com>
References: <20250812124941.69508-1-bhe@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2122D4000D
X-Stat-Signature: ktp37w8yrmarn613b73hzw77uddqekb1
X-Rspam-User: 
X-HE-Tag: 1755003043-705402
X-HE-Meta: U2FsdGVkX1/OWZ/Y6OwTQdW0+/Jx9XJtTUrZhk7FNlHWTTlQJZB6zRrSB2G6ZNCbRseYV7k0s7dLzf7EPkwgwOTqfRRb81j0Um4DeAROrvwczszMLPeWeReToAasOUbiu1jL6X5mRQeDY84LxYlb5gA+jDeSBjqyjTsqVJv5lJsWReVxCN+9eB4fxsEW4mYeyMmlXZ3Zjt9e832y10bY5DrLY5tjWL7xexI2+Blf1GA3vMsazlMWeV3FL/BLyvKyl/lMOJugbqJeYqU/xQvXg5H8nQwY3eINRgiElF6p+MXgYJELWd8xK63cy9HZ2wFN4valIJnCfYMQ+MMoe2R0fiky2ud+y8MNuwbNXAsA/O9FEBmwHIMREBk8MLzp18uCishiItOAJmjfx95hkdAwGL5wJ0XHm5HPhzpvsMNno+RMjgIuvgy+1hFinZY2HG0+iq2fItiugPkIE24MUsqlmmWeocBeE5FM94BdJI8hZ9QdsKcFPZg8XPNexVuWXvvScomofYswhPcbFtLLASpVodagf8zs4O7KMflj0bLmKSUs90kqVcCi6bVqWgFSSP5FM7fHzKBWGdU+a46QRGZ3vV2nyE0WfYtee38ePN1d0rHOywvUwausvJ7yPWQ+3vGkjQe/v5O+AA4heR7cEyi3sD2g6V7o6xVLWFkog/S160utwCbDEjc4O1BeYuHuzWNOcFw5XBVODWS1zyZZYgMuMWYY2iOFCgkKCvM1LKOpyEmCNtn8q2QVzJY6DopAWiOuNSurB8JRtl5nQisek3vGEAeBOcOnumw4DJQnuBpyT2BZHl+N9SfbyqjEt2StDFh5SCP+O/JXKiJguTmDiuO99blJn/FZLIaUzCck/t0gSpZokkh50RwYUNObOaog3G1Sk9lEWbl5pgSDcCCRX2zNnEQv7lkmhhwgi9bANWflOdaJujCxkLpyKA+CNaVy7DtU8oYkTn0cXY9meHMNVkB
 PJ0JVK+2
 WigcxtdRE6qWX2f4OwsfLqRCE5SspncS/7pL8MmZXRHnJpVrTYjvf+HqsgMZ/aax53YxTtlzDihOnuOrB/HqiplyNYrfw/BJ8lrBNwwHBIzfWwJW3xhB+VuguFpaVMyLmQayGfSEMNrnucqHzVRSZ2/5A8f2msOuENkRBZpAwBcS6WclA39kvPXMCw6XJszAQAfguVPT9R81Jnj8Y0KBKrQAri5FXpJth9+fNJFeuftZdyWszwmnwbQ4NFdiphFGSUx8Zcb35tHElljn3ApKPNlxRg500RXMSGi6GsRgQmY6Ptm1kxPmnlVBJo03FpnJ8hIsZsA2BJj6KDe3DfBQToX+llvrFzIhti6AfRqamPwJHE1paK02MLveV+T+otVL1UtYoWguj636CdOYV88lxU/gFwA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

And also add code to enable kasan_flag_enabled, this is for later
usage.

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 arch/loongarch/mm/kasan_init.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/loongarch/mm/kasan_init.c b/arch/loongarch/mm/kasan_init.c
index d2681272d8f0..0c32eee6910f 100644
--- a/arch/loongarch/mm/kasan_init.c
+++ b/arch/loongarch/mm/kasan_init.c
@@ -267,6 +267,8 @@ void __init kasan_init(void)
 	u64 i;
 	phys_addr_t pa_start, pa_end;
 
+	if (kasan_arg_disabled)
+		return;
 	/*
 	 * If PGDIR_SIZE is too large for cpu_vabits, KASAN_SHADOW_END will
 	 * overflow UINTPTR_MAX and then looks like a user space address.
@@ -327,6 +329,9 @@ void __init kasan_init(void)
 	csr_write64(__pa_symbol(swapper_pg_dir), LOONGARCH_CSR_PGDH);
 	local_flush_tlb_all();
 
+	/* KASAN is now initialized, enable it. */
+	static_branch_enable(&kasan_flag_enabled);
+
 	/* At this point kasan is fully initialized. Enable error messages */
 	init_task.kasan_depth = 0;
 	pr_info("KernelAddressSanitizer initialized.\n");
-- 
2.41.0


