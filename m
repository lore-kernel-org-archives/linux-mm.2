Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DFE6C87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 12:51:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F6078E011D; Tue, 12 Aug 2025 08:51:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A6668E00E5; Tue, 12 Aug 2025 08:51:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26EEC8E011D; Tue, 12 Aug 2025 08:51:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1240C8E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:51:08 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CEF711DBFE5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 12:51:07 +0000 (UTC)
X-FDA: 83768090574.03.530D7AD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9B2C020005
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 12:51:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="evj4Kd/J";
	spf=pass (imf03.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755003065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+hQAnfUidTkYrnmu4spIdiJcPf/3EYQSdRJ9OD5/zYQ=;
	b=OXIbrpn+yRJFhsl5EjBFNY38WfWn5j1oiXie0aEK/0QQDVt8KMgr1nHkBzNF3xVBAoq55u
	KmqaOAUPNc/qnZ8mXNL9AqnDEeuvIxnY31A14/FEQVj2VdyKLoKWCZt31GGps9z0hotYun
	fTSC/LL2Y1NUnPHkMl44f3vckNjH8wc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755003065; a=rsa-sha256;
	cv=none;
	b=vqwhBoFeXYlRWUyKZKIVe2f8INaaNWLj69jF/bgX2qIbgVHWrQxpNLzw75kfPvpEqRhGq2
	ABSfdfRXHCL4DnmybE1s9m+ukLqHBKNMy7Q0k/8bbvwEFzjDTpTjMYctA/l6ejPO/CMUVG
	4D2dD/r+Q7qJzo5OBe//b6tgJg99emc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="evj4Kd/J";
	spf=pass (imf03.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755003065;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+hQAnfUidTkYrnmu4spIdiJcPf/3EYQSdRJ9OD5/zYQ=;
	b=evj4Kd/JUh3KWdAScBDvk1LlgvM2nf3zfi6xtrVmkfbbWlBvrjxLQodefXRrmIwUxoAxPO
	/VbTjPT7w+PPHyxYggQvEIzm57iQiqpVQTu4BWApW5Hx7WryYGAmwEXh98b7DbK/ZAVOg6
	dklQwkwGm+4yVVr36sgk428zvquE0t4=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-433-lYRCxuF9OOOH8dMMXILcPA-1; Tue,
 12 Aug 2025 08:51:01 -0400
X-MC-Unique: lYRCxuF9OOOH8dMMXILcPA-1
X-Mimecast-MFC-AGG-ID: lYRCxuF9OOOH8dMMXILcPA_1755003059
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D0B1B18004D4;
	Tue, 12 Aug 2025 12:50:59 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.156])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A33053001458;
	Tue, 12 Aug 2025 12:50:52 +0000 (UTC)
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
Subject: [PATCH v2 09/12] arch/x86: don't initialize kasan if it's disabled
Date: Tue, 12 Aug 2025 20:49:38 +0800
Message-ID: <20250812124941.69508-10-bhe@redhat.com>
In-Reply-To: <20250812124941.69508-1-bhe@redhat.com>
References: <20250812124941.69508-1-bhe@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9B2C020005
X-Stat-Signature: bzzaom7mjezz8hew9mukcceit7b1ch7z
X-HE-Tag: 1755003065-514519
X-HE-Meta: U2FsdGVkX18Bcazp/n8m6HSE4UvZt32gcWVIKrM4zBzGGHxxJ3r1EqogP5bbWgaUDLFiExPwVLHlUBPJExeqBteYshm+ucs+y76zDBiJop1ct7j8499dddd0MOMr7x7W+GPKkDuW3Gj8ebSqZ7TKC5D5KkOvwient+yj7iRvLQtL8rfI8kY3ur9r+zp9+1Zu/USasHGWLNfra3J145GdfL8CTJ8wGFlxld29rfPf4q2YmNaiKjBBOusl4b9V3P7I5+Phv0quSH2v1Cw90bDKiQNricEiE+6GhYJODKG4L4FFW/1esU4dKYMJvQNgeNj984kOid+84VC4BOtgQnkxZPr2tqmDOGpSttWH4N2BandHCteb90SlWAj697LxgjCkc+iT5eN7G1x0DVgdgLhf+nnlCuFz3FsH9MPfnao+HPGlljHIgyx3NLaR/BhfgCn899Snn8Lwuw3DVjlvpg+aGcfZ1c3jPXLKfnqYN55FV/V9h1E2wicMPgBjSBR4WZB39cFto55kTDoJZaXKn+Uzy471PNmsbY0p9rsAbsUwOFqrRA3qp2NonyntHTW8Ei1Z/W+vFJi3mg3Atu9uQQOUH22Gpk4F5utTbIHHp8fzTzWBmaq/lkPv/AzSzhX/hT2oG06+LHWVHJu0CUUz9lZCNh6N19dW2HCk/kAvz3NDtYxfVmdJcs81eu/1sdl8PAMDcTKcoN+Lezfzo3WFqefcYoYiMM8v2v+WYndGf5VbzDoRfeHxTIyNvQLjXpIgeJaJjKiPRXaeeplVFgPr82cvVRhIm0GobIP+GUqOcnO2y+1NcbO7G00RnbCi7j6posTC508I+we757F+VcPUYGlbWvzjYRV3IL2yy2+5se9V9TbGXtIHb6jIs9uQDzYdCrUIbFYwTb40GcXnZQ/EcehDJjn+YXQh6PB7UNZFm7qsLoB1SF+ZzaYVaLRXfT1sOQM1DO+bkSvgsYOYNjo67zo
 1ZVJzsR7
 qyw/S9GZmMnEoflwOrydOJ8Tb1XQrDXIq/vcz5WWvsWfBIrOl/n22DZQDXihyf6yA2cSt3dln3hGN47ztx+u76/o6PPn2ZSGUQZQveaTeAkp1+EeS90/Rg5OV0Fxowlevv6D8vvyYJLX1/TLDuMnAmRHbEpPphYPXirXwQNi4HmtLgV3O8SR6rmneLla7Pv7aDdJXC3RU/0dSSoMPlRcYLaE3tdIyfi48HMCRa078DAr9RJ2uYHlKTkJvo4Bs1w248qY1otk2GN7eUjKZKon5cAkyFnqRv48WNjvUAcUB6bEeYXzxOsMfl7sfreZUe7hKS/sC9ajNdDnySvNL3izA6sg+7z8Hl31La08TTAxjI/iQuEUJ/CskopOV5eXktFehNf3rm/yjw8OxJhqIV2VIBnIlQQ==
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
 arch/x86/mm/kasan_init_64.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/mm/kasan_init_64.c b/arch/x86/mm/kasan_init_64.c
index 0539efd0d216..0f2f9311e9df 100644
--- a/arch/x86/mm/kasan_init_64.c
+++ b/arch/x86/mm/kasan_init_64.c
@@ -343,6 +343,9 @@ void __init kasan_init(void)
 	unsigned long shadow_cea_begin, shadow_cea_per_cpu_begin, shadow_cea_end;
 	int i;
 
+	if (kasan_arg_disabled)
+		return;
+
 	memcpy(early_top_pgt, init_top_pgt, sizeof(early_top_pgt));
 
 	/*
@@ -450,6 +453,9 @@ void __init kasan_init(void)
 	/* Flush TLBs again to be sure that write protection applied. */
 	__flush_tlb_all();
 
+	/* KASAN is now initialized, enable it. */
+	static_branch_enable(&kasan_flag_enabled);
+
 	init_task.kasan_depth = 0;
 	pr_info("KernelAddressSanitizer initialized\n");
 }
-- 
2.41.0


