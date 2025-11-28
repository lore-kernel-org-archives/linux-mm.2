Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEDA6D116F1
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 03:35:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5740C6B0093; Thu, 27 Nov 2025 22:35:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54BAA6B0098; Thu, 27 Nov 2025 22:35:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4891D6B009B; Thu, 27 Nov 2025 22:35:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 35B5D6B0093
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 22:35:25 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DFC00B835D
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 03:35:24 +0000 (UTC)
X-FDA: 84158600568.08.C6DB4DF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4B704C0005
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 03:35:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=i8pKFWHa;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764300923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2zYq5Xg8QPu70UaOO3h6mVKhUd8xeQ64UlU5KTsxCNk=;
	b=N/isYhGovw+HtVN7z7HWmrqW6IafK83lGr8ZUQWmHL73/7jurHzDSc48hTFvXqD0i9qsWY
	2aBGn4uukeT4ONcsK9DTt2VpEVFNnkfpqQ/RDUCANmJ0Z1zgy8m9odijHXLDSW5hdbIDR/
	VuJFh+l1Fy5X6sh5nCwa9N+f+zxY11U=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=i8pKFWHa;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764300923; a=rsa-sha256;
	cv=none;
	b=usJBSK9Aaz1+kX361Kb3m/dsV84IrfZqxUotNwTltzxG/zIQQ9men28wlaiF4RFsIxG5r8
	w2IXY835VeUZyiRcLgmTx+cQsT8x8iRXlVhd8fTgKS388LFYpDSNJbxQS/Xp7Kx5FeQM2r
	h8ay06TqZpyhNXvP8iZYTKY+oB1l8L0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764300922;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2zYq5Xg8QPu70UaOO3h6mVKhUd8xeQ64UlU5KTsxCNk=;
	b=i8pKFWHabsIZzUmc7M2D2qRnBAkj5yahF8+wBwyVEzM76d5tJ8XO0a4S3Z7CiOgG0BQ+Ru
	Iq1Z018Ea3K+yrJJ5PN53Iz0ml1yP6mKe2vv5YJUJraFx0Gy6NUe23vwhOncxsRQPde5bU
	zUxrGQDnYJHXY+GAJggsYy/f+AsL0fs=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-677-PSk638q6NMCqBHAkPGt0ZA-1; Thu,
 27 Nov 2025 22:35:19 -0500
X-MC-Unique: PSk638q6NMCqBHAkPGt0ZA-1
X-Mimecast-MFC-AGG-ID: PSk638q6NMCqBHAkPGt0ZA_1764300917
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E833A195606F;
	Fri, 28 Nov 2025 03:35:16 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.7])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3A4DE19560B0;
	Fri, 28 Nov 2025 03:35:08 +0000 (UTC)
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
	Baoquan He <bhe@redhat.com>
Subject: [PATCH v4 12/12] mm/kasan: make kasan=on|off take effect for all three modes
Date: Fri, 28 Nov 2025 11:33:20 +0800
Message-ID: <20251128033320.1349620-13-bhe@redhat.com>
In-Reply-To: <20251128033320.1349620-1-bhe@redhat.com>
References: <20251128033320.1349620-1-bhe@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspam-User: 
X-Rspamd-Queue-Id: 4B704C0005
X-Rspamd-Server: rspam11
X-Stat-Signature: 1k1aufrzcxoyts1d7qnsmimnstsku1bh
X-HE-Tag: 1764300923-509608
X-HE-Meta: U2FsdGVkX18Y4kK7f2CahLfC7pK9ZJmSduxT8sRNyK6ddVgmOuJo+AmBzpbTHEFcbVZdmIx0RHVIjeTFiygYeqYVmvIoSsDq4F29GirhPG28a5XGlpIn+BSqsOun9c0iOxFBTnS0oUdVaU4JLJoHTLHaStBMlPu8B59xM+hBydv/+EgCDbYrScXmzTSbGkrnR3r7UfXIT0Tz9noRz+gQWNPQ6DpPdI4DTZYUDi/p2HcNJjKH7c0RmBC16w0eD5yJaD+ufKfD83/HaqD93m5VR/aCLEui4vnxlFCO9CmwaPfSUEZxnZktUOxA2vAXw6Lh10LeJWwKwVt11Rtcp2QUj+I70JKaAlTjZjb80GtRRnCH5FaVO8BLadE2uYcfHlpDCZ+LoKz/24Dnr8Q6ONo0Q0D31zwxLzXBQIkUmRkFw7Nwd5LfrsQJ9kvY20HxbyKtY5AqR2E18wIB/j19xwNlwVnNMcpS53kvX8bR1CryB51lEPpVBPOtXiPtbN2Jlr4tbzynx/Q0VqJoUUXNdTZawQzQRQB0gcop741mPYoQcz5hY8l+29LmkkkjD35W+1C0h7pw+qoTR4NhOcQn0d/G3oz3yP4J1M9KVE4ZRyuSB8c0LwknejoOw98AujTszaoL+SBOC6TBrjKRAlDd8cfVby03kBQ5NcB7ERjTgA1S6wt6rPqrinIJfVYF56DC/Nl1SQJewCj/+gVh/QyHU12Pl6W4KrO9PJms9aJ5qnTCcdQ7nCjJQWcbCXr2qZO6O6CTAuErzt4jzWiRrb4CeScqe+EHH05cTLqlyfCoNb/rigDfl9Iwe+NUjaFEa4OzSE+KqW9VfTkyaQbUwYhlhNZGzXeRrol/+kDfQw0lP+0T779aT/b05G0Uq0q+hQ1asfe8OTgXZibP+/i/F9UUSNRkt6Pwt/9FB9CgvgJaKM2eXwCTt7gzkhh+MyzNUTzVhdsd+O9Kg6Q2KdONK8Z7WpY
 50KvIcBF
 SK0rU706ZZ283rNgSdqpd9HqeUTjAkkhD0XMtJNAwmwhLdV6B6GrDFP1In2D2Be1FAM32q0MZyhh/iTGUOryteBWfhhlmOIYcpO1A1e410wp9yDYcMC7wdbsKjrAD4CfQ2DzG
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
 include/linux/kasan-enabled.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/kasan-enabled.h b/include/linux/kasan-enabled.h
index b05ec6329fbe..b33c92cc6bd8 100644
--- a/include/linux/kasan-enabled.h
+++ b/include/linux/kasan-enabled.h
@@ -4,6 +4,7 @@
 
 #include <linux/static_key.h>
 
+#ifdef CONFIG_KASAN
 extern bool kasan_arg_disabled;
 
 /*
@@ -12,7 +13,6 @@ extern bool kasan_arg_disabled;
  */
 DECLARE_STATIC_KEY_FALSE(kasan_flag_enabled);
 
-#if defined(CONFIG_ARCH_DEFER_KASAN) || defined(CONFIG_KASAN_HW_TAGS)
 /*
  * Runtime control for shadow memory initialization or HW_TAGS mode.
  * Uses static key for architectures that need deferred KASAN or HW_TAGS.
@@ -30,7 +30,7 @@ static inline void kasan_enable(void)
 /* For architectures that can enable KASAN early, use compile-time check. */
 static __always_inline bool kasan_enabled(void)
 {
-	return IS_ENABLED(CONFIG_KASAN);
+	return false;
 }
 
 static inline void kasan_enable(void) {}
-- 
2.41.0


