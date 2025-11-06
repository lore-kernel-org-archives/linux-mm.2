Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF310CCFA19
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 21:29:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA1E68E000A; Thu,  6 Nov 2025 16:29:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E526A8E0002; Thu,  6 Nov 2025 16:29:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D40F48E000A; Thu,  6 Nov 2025 16:29:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BC1798E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 16:29:28 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 89D461A0257
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 21:29:28 +0000 (UTC)
X-FDA: 84081473616.06.991E3C4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id DE696100006
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 21:29:26 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TgiegNxT;
	spf=pass (imf05.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762464567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uKmnrwBJh2QsEJ5R8DLB0opqHAQSJh/LYJ/G3AZFd2k=;
	b=zjapiyXaVsDztnTi+iFt137D5T/ixvaWns0fhSHRmio0qh+65Jvad/Yj+8sXT0tuiYzQYh
	eyB1A73qEJd1OeAfRcNbN1JIdX4rZH6RcI3Ky69UQQsCe/pKtWK1UMWzw2XegFJ4pDpi54
	cjYKGqVqDgkdH7JxDPLhUdu+kr1nGz8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762464567; a=rsa-sha256;
	cv=none;
	b=F/icDfr/nRAAKLqogGECVsucZrVF3pU8Jdo9a/dSBJJPjQZzg0P+hi13VIKPJLFeHnnvY5
	3IYyuso9Sv1P8D0iCzGwCckvod+vgeUJoa8jbTlY+4x50xtmW8yvaHHbwdLR+QM+fyzeh7
	4cBPnXOW7lwo5hOunsA90WLClvr4xxg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TgiegNxT;
	spf=pass (imf05.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762464566;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uKmnrwBJh2QsEJ5R8DLB0opqHAQSJh/LYJ/G3AZFd2k=;
	b=TgiegNxTQgEAONyqlDcSOGj0bGKE+Y1uLUYpcxMA/CsA1iGQgqiTmHoGuh+nW8OFwu5uWw
	cjXSNs46YOC40AKW/qKLTcnz++bxTv9OhhWRQx6NYYsBbCbrDU+DF0hp/mB9oSbKQ4dUAC
	ySf2iQlxJbxL2C+BG0QRNFZjaI2iv/I=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-683-hpWa3tvvNlG9IJXkEFsTig-1; Thu,
 06 Nov 2025 16:29:22 -0500
X-MC-Unique: hpWa3tvvNlG9IJXkEFsTig-1
X-Mimecast-MFC-AGG-ID: hpWa3tvvNlG9IJXkEFsTig_1762464560
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 968D7195608F;
	Thu,  6 Nov 2025 21:29:20 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.65.101])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5A6E919560A7;
	Thu,  6 Nov 2025 21:29:19 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: david@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [RFC 04/10] drivers: i915 selftest: use pgtable_has_pmd_leaves()
Date: Thu,  6 Nov 2025 16:28:51 -0500
Message-ID: <297c6fa3dfc50c28c05c0974c86a205984d752ed.1762464515.git.luizcap@redhat.com>
In-Reply-To: <cover.1762464515.git.luizcap@redhat.com>
References: <cover.1762464515.git.luizcap@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Stat-Signature: 114s14zq57fsumfebrk69d8nz49qweoo
X-Rspam-User: 
X-Rspamd-Queue-Id: DE696100006
X-Rspamd-Server: rspam01
X-HE-Tag: 1762464566-56159
X-HE-Meta: U2FsdGVkX19Y1uv9lOEaddx4f3ROkogVskx+ixfITz/YrAVpdfMDNe+ZorZ3AMDCWvTaqPr17H2oLIBx5OvneJ5vH2PcyZyVPvUDGZNjA/co47QQ6qgBcTtacwRwtrvnga0Zg0r31DIslntAOXI9Bd0HLS6L5DthiVaafnng3w3MZjKwUXAEIhYffqpLWkzPdXUVrg3OZYg0zfi5p/FW4MewbXex+3TMj34pku5kdVUYEjlnSpDslH/SVUXRBg3soHQT0lVr9sTWuPtvWSsmFdtm4QvJLz1twNo0XsYeXWdQvSJaE6w1IoseG1GXiKosy7KmA3IflZtjk/x+onm3QDfDltly30AKQoc/QhUCY0XKlDd8BYYSBo/pICUxhQjuaIxXcdpaQ0YRRHJ7oWeP3DsWQU3QIHhsdOip3bG8IOX6Qp4w4xcNCYf45ONgzcE5Ip2bDNJz3/ABJDgXhrXNTNSehIqTNUqJuAwwXppsByHePxxVATGxJCuJ76wWLIk2nZsnizD7wMm84i6tVGD/3FSMmQUCTYY/nORAqMf8tKP5mxSIncnJYLpyeviJuxbOsyDOuHz6SA+xWW79E2i3c5cF3G7Luhthb36oBqlS5AL/pFbNBotf0M991ckl0tr2+sfKMFDI43pH8QdfLw+1fIQjtU7jBKpVeRVEHj5lnsunMDKFYRQVLuEIPfSryIqCMqFp0FP/UOQ+GT4YtAktWNz4gJpe5CAbAiMu9Oi1UcLgMcBTPRJCm9gPsw8pUBE5vI8o6DI+m0Eyp+nXGU3GTb5pimMqUqa4LWSmoveBCuxhjBdp7XwoZjh91zxapRE6IGbrmcqrx/DcPGh4IrYb4r5REME59NAiyyqfbDtsmVMv8yKUGqi/VvvXkKIKwcuRurfA6itQDH0XEfW2EDTfzg65UZxcmdv7LHMHClCOjZO+ve3L/gvXGU5S07ViolqQ1GfnihELOV70N5aJNF5
 YkASHfFf
 XoNo4wfE2Fzg4fGDL6UvGGRD2NRhdVw2UqaNVyRZ2d4WBVz35wxAB52syKPZOSIf1k88inhyVf4B1TuIMw+AqEdENZsft6PnnYEeWbEO/8tClBy4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

igt_can_allocate_thp() uses has_transparente_hugepage() to check if
PMD-sized pages are supported, use pgtable_has_pmd_leaves() instead.

Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 drivers/gpu/drm/i915/gem/selftests/huge_pages.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gem/selftests/huge_pages.c b/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
index bd08605a1611..c76aafa36d2b 100644
--- a/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
+++ b/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
@@ -1316,7 +1316,7 @@ typedef struct drm_i915_gem_object *
 
 static inline bool igt_can_allocate_thp(struct drm_i915_private *i915)
 {
-	return i915->mm.gemfs && has_transparent_hugepage();
+	return i915->mm.gemfs && pgtable_has_pmd_leaves();
 }
 
 static struct drm_i915_gem_object *
-- 
2.51.1


