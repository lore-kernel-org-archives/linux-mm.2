Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03B46CFD376
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 03:35:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E8B66B008C; Thu, 27 Nov 2025 22:35:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C0B66B0093; Thu, 27 Nov 2025 22:35:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D7A16B0095; Thu, 27 Nov 2025 22:35:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 36AEE6B008C
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 22:35:12 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EA1F416035D
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 03:35:11 +0000 (UTC)
X-FDA: 84158600022.03.BAB786C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3C09C20006
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 03:35:10 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Gvri60gS;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764300910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vYIdm7jlXobjspOXdxZmqxS4c3i3lPHjIs91tkUv/to=;
	b=lpPIJ7z1fMXuYZthnqSnrFaX3JPw9JTrIX4f5e39MtjSAw7zMgHIKVSU5wll4E/cjXZwkO
	8oeBWw3XUNmWadnED7brZJ48EE17yjYGH3o6x7NQUi3keIQiivZVCL4dc7w6vB27oA5NKa
	gG6gjkbhXr1IA+kTr00GjWhKzNFCq3s=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Gvri60gS;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764300910; a=rsa-sha256;
	cv=none;
	b=lGAOFNw6vd/Tnpbx/lhqC/Ye2Ex4JbMCuiE5al3VGBUgI2QsBZY3jQ0NPhlf9iv2ysvZwL
	6AM9FCzladrPEdEGOLxmr9AGjH84h1uDCBorJEfsEdq+FxOIVfgXxXnGvqx6Czp0avKnIT
	itO9Xo5fjpKtywRMXq7ZAifC+nabEoQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764300909;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vYIdm7jlXobjspOXdxZmqxS4c3i3lPHjIs91tkUv/to=;
	b=Gvri60gSCMNGZZqMSOYreb6mpzc3XxCYlOr2tjh+KkaPd+TyoLduh03q5CaUDvBAXhbgud
	QJulUlS/z92a/O+mkvhz9yd7mIxel6RgkPGzeNPaSeP5pkgsu6peao4apwlsLbeK7i5tpT
	cptbmrGc7cTeKQtVyw0ecS2H93ozzDk=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-486-iBrk60d6NraI_aoxKGyGxA-1; Thu,
 27 Nov 2025 22:35:01 -0500
X-MC-Unique: iBrk60d6NraI_aoxKGyGxA-1
X-Mimecast-MFC-AGG-ID: iBrk60d6NraI_aoxKGyGxA_1764300899
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A3AB21800250;
	Fri, 28 Nov 2025 03:34:59 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.7])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BEE9219560B0;
	Fri, 28 Nov 2025 03:34:51 +0000 (UTC)
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
	Chris Zankel <chris@zankel.net>,
	Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH v4 10/12] arch/xtensa: don't initialize kasan if it's disabled
Date: Fri, 28 Nov 2025 11:33:18 +0800
Message-ID: <20251128033320.1349620-11-bhe@redhat.com>
In-Reply-To: <20251128033320.1349620-1-bhe@redhat.com>
References: <20251128033320.1349620-1-bhe@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspam-User: 
X-Rspamd-Queue-Id: 3C09C20006
X-Rspamd-Server: rspam11
X-Stat-Signature: kszxtjbn79ojmem34qzmxoo1e5jgxj1o
X-HE-Tag: 1764300910-848063
X-HE-Meta: U2FsdGVkX1/z2lpqvqr3JgvUMFIH2np542GdVgWwEBQLsBG82NUPpDV5DlbGoVi6vrNRaUddoX+sSaKw9p63FsQVfDp+WTS1S7hoqJM4uAX3xMEoOn6U3cnee/7bYkpFthcIbeizeOLhhfoiwpJBE4Fxm3fneEFaheKP2dq6sd6L3Y+bYwNUtt1Jwrz6y1UK7ETI0FSGF3sd8eNF9FmhjWiQEMLpBYaDrdofVFf/1BSXLwBu271H46VpaTCPKXjPA+bn3oBK1c0cfZTmTi4aesb0HpZ+xgZu5aYrqjTjyNUNiHvJQKs0ITP7XNxn3uCZQl1+zuDZdJjf0fOOHPiHdXfULToLcpwFCTVCET9IieJuRbPbV1e2Ccsk/osgzG3JoOQCJ9hfQqDzZSimJhCQtMHiJ8LpbyUnczoEhIupLubaFodc4GyTfrwYkMkILSdOQ9nIrPJQG0EHKHnFZiaVHZs6xDcIdQyW1QtsXOhEnG4p/n45pqyTerFi0oF6UDAW7z9Ts/JxXuJVlPNPVSQmPeP3qkbvhXHm08AnrKwTrD+/VLsQM+vDsUYotqgFX9q77wNOwiAFXEBc+B0zhpmAkehFWHw5e8dIqRw/pac+oIHqXPhdQdlynxtfGjMPAr202KOr1VCc+cuduQ3hbGm9n04xcR+x1TQGyfQMQaxHI2hXcD0AiHa8zwrnk+cxle1RoHbnILkQI8e5G4wzQ3PEjc/DJrJGZFWh6ybfytplmG8KjgBxmyCgCRov7FszbVmhYM/CN1Mn+Wum2ZLASBwq5m7MsZbWe9xgjBQk/Sa59oD1vpmmuqGUNb1qG3dVsjUyqfjJQih6UebvYly9zXSL+Q8CSfN0VgJCjsY8960JKYbByPdyx4PWBU4Or/Tr/+N3BMTrGsKLJd4QudJpIBbFdgWH1mdopzjBH2biEiLT/Bu6I42djp060bZWjQ6GWMLI6/BOGa+CpiZlZQwEq6S
 9VrEXHxW
 4EAOrA3Srb7KC3k0PciJHctfNHSqTKmHeFBWGmtEsVOnS9M+6vBv50QUOFpl+Z/q0A4oFvYoZxnSWc/ONPASPKZ+RqPc839Nib29FJhZtXj3Lps8M9eeMELAgU2toG/hKRqjLpKzYJ3OBlnuqL09U987a0YQdDWWx8x3Vw/4wH/5Y4RHkcljbi0AlfLD1C5EhWy7GSnpQeGKJv898y6en5dFF43k6Q9gcpWxjJ5iCTMugB56OOLe5DoeIdTlbCf1wuK+hff5DluCE/dTX2/EuNu6y/gKmzi+IOi/DT89SDPX/hbODmezavIDcq7Mufpv548fKfuJhN7yFww3TkYq1PKzAMIWyiZd4zOYDqb9eQPx1V5PJXCE/Qs/7URP6bsMSbrwE1o8rcp4wR4W6dy5oputnJ0nfg+B0lFjLtUizKFtg7qQ/+Dm6WPhV8ipGY9gYzLALTJ+ZcKKFpCljaJFqlfxr3hC3PB5MZmx3UMIvDVoZj7k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Here call jump_label_init() early in setup_arch() so that later
kasan_init() can enable static key kasan_flag_enabled. Put
jump_label_init() beofre parse_early_param() as other architectures
do.

Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
---
 arch/xtensa/kernel/setup.c  | 1 +
 arch/xtensa/mm/kasan_init.c | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/arch/xtensa/kernel/setup.c b/arch/xtensa/kernel/setup.c
index f72e280363be..aabeb23f41fa 100644
--- a/arch/xtensa/kernel/setup.c
+++ b/arch/xtensa/kernel/setup.c
@@ -352,6 +352,7 @@ void __init setup_arch(char **cmdline_p)
 	mem_reserve(__pa(_SecondaryResetVector_text_start),
 		    __pa(_SecondaryResetVector_text_end));
 #endif
+	jump_label_init();
 	parse_early_param();
 	bootmem_init();
 	kasan_init();
diff --git a/arch/xtensa/mm/kasan_init.c b/arch/xtensa/mm/kasan_init.c
index 0524b9ed5e63..a78a85da1f0d 100644
--- a/arch/xtensa/mm/kasan_init.c
+++ b/arch/xtensa/mm/kasan_init.c
@@ -70,6 +70,9 @@ void __init kasan_init(void)
 {
 	int i;
 
+	if (kasan_arg_disabled)
+		return;
+
 	BUILD_BUG_ON(KASAN_SHADOW_OFFSET != KASAN_SHADOW_START -
 		     (KASAN_START_VADDR >> KASAN_SHADOW_SCALE_SHIFT));
 	BUILD_BUG_ON(VMALLOC_START < KASAN_START_VADDR);
-- 
2.41.0


