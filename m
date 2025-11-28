Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0F8DCFD376
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 03:35:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 042CF6B0089; Thu, 27 Nov 2025 22:35:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3B5C6B008C; Thu, 27 Nov 2025 22:35:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E25506B0092; Thu, 27 Nov 2025 22:35:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D02C96B0089
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 22:35:00 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9DD08C0118
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 03:35:00 +0000 (UTC)
X-FDA: 84158599560.10.E5E7266
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id CE31610000A
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 03:34:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IOBh9EPI;
	spf=pass (imf05.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764300898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K3b4hcMhxxjCn2BaG6Ly1WYT5S5cKb/IEvtIbpVbOV0=;
	b=amJhvimM/jbMboRxSuBw2S38J2pBflyFa2kFN5E+3K2zNxbqmDbBruAqrBAtvmO6/rIu8D
	Ku9oZAt6/l42v2dKnkSgM/TsG/I3qwki1QyTafVi6QYST5/5V4mcsJsJjKomAZDJkAAdkl
	/hxIqwmFAoYR7YZ2dBwRvqo5ucA2wAk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IOBh9EPI;
	spf=pass (imf05.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764300898; a=rsa-sha256;
	cv=none;
	b=CLJF3q3BQOX2RaiRONgJ2GqL/JpBeNW6dj+v8aB6QHVSEtdmlk3/TtBOzEge8jW0ei4mty
	4ElYxXbNdWSF8Xuz/7+/3VycQY5Vj6Q5ZL5lMi5vlksNvkQnqR7uObDkpvvuWSIIzXvt+i
	KIOJWZvuEsxeV0GTCbP9SGI6U8ZFVTM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764300898;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K3b4hcMhxxjCn2BaG6Ly1WYT5S5cKb/IEvtIbpVbOV0=;
	b=IOBh9EPI0fyBMdw9jULXDvUTZsqLyIMxiWIbz/wHmA6J6R1g+hnzLLJpwnybAva4vGP8gC
	Kx2NCyBN65HR1klTWfieEPdGHiqWzO+iuLU2TmGcl/11L9Pb35fBH24zHeDEo6zg2Kjbc1
	kFPLtzgQXjr4Lwh5dVTW0Z5XXZWMQ9A=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-509-Z-W1bC2_OWGpYgZiaAnmrw-1; Thu,
 27 Nov 2025 22:34:53 -0500
X-MC-Unique: Z-W1bC2_OWGpYgZiaAnmrw-1
X-Mimecast-MFC-AGG-ID: Z-W1bC2_OWGpYgZiaAnmrw_1764300891
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0441B180057A;
	Fri, 28 Nov 2025 03:34:51 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.7])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AE04C19560B6;
	Fri, 28 Nov 2025 03:34:43 +0000 (UTC)
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
	x86@kernel.org
Subject: [PATCH v4 09/12] arch/x86: don't initialize kasan if it's disabled
Date: Fri, 28 Nov 2025 11:33:17 +0800
Message-ID: <20251128033320.1349620-10-bhe@redhat.com>
In-Reply-To: <20251128033320.1349620-1-bhe@redhat.com>
References: <20251128033320.1349620-1-bhe@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Queue-Id: CE31610000A
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: uynw7rhipsd8wio9f5eymxh7jfwisy1i
X-HE-Tag: 1764300898-764054
X-HE-Meta: U2FsdGVkX1/WyWdTvMdnO7SaETpiCFMeuIuMJa+jggj9vYrVUMu2hf90lzyy5xnjhamd9YTDLL0MEkfzNVygzQbG+61deqTb/x6zr17NniecCaIEqhXfsFOZozZLZNh7bMvIiOALMS9n7AXU5Lkxa5cOopRgn/k+jiN8VzTijCSh1SnkGaPBoXpm00EqIHXjF3F/cyQTi6CRh088UXJWFTbquy6Hmxzgat5fbWUFGDPa1gWVENv1vb0Z+kFD3iO+bVKdE5QRSBaFta8fGzx6+FpYffRRLGPxY4JWbjNt/xTbGFdyYjlshIHeh2CYte2ne5o4rUkzM5nAUBR0QuMkFpaTh7UCNslqPvm0ur3kaJ0ur62yi6twdXVaAPJtTeH5QRo0mU4mBoTDTDckKoaHWu19QeC4Dc49/pUWCLp2EfD50Cwd+XKy83fFjT75QFFh89UEpuO4PLZmLVWEx4RBt5yk8z2MaE7nXPbAFfRZpmolI0TB5f81pOZ1Q0ZR0UTV0XH60eXZlXP74Tnv2q7xH+9SY1YQrywHBZQ53oi2b3YGmujjoEDb8mpeZDY+VOmWo3mT2px4q/EkEHTTlYRgtc+C5+awQJPZhzqeYt/GjVspjaWUOmGxx8K2VACsDQQtQjC7/J1D7ICE2fpB67TDDm4OT9/AKO788sCRBfkVeiZGy5J4x/KiHSB2n0+I0Ho59zHpV4WAfSvONJpvZtvbUCUYpaFsCFZiDN3QXEigjTtQsw3WtOTY3yRKnSsKM0SoQoN0dnmXjrX52TTKFdAHxJ0Q1vgcZNzXx7UP8FUjWOQYlhVhYwDPVkbz7Q6wgfYHKL8/RPYtrkJtlvw9zU0VU0voEw3K2tZqTMlF6mYwL5UrJI7q7NMrFWyDtw4xUA4DPurhvzWWmw7zgVw0/TRSjAR1o3EmcAqjAxVgDo4opbPiiH+ScZG1GMrEiVgppbpSOU7k/7tAz+DwBqWtexW
 /77biYeU
 J8Bix6byRQeUrbz1pg0bB1wtCIoK5G9VxVuPbrQLqzoXR5E/PqdMaNp+0qbvzLp/TBrfbLgigZeMbpZZVUZx+drTSmj3oLWqRo/BFeRxHoB2rJR4hkWKUNzruA24ssFqnExJbpJ4j+19YEWPJviOa0H/lUZujTxV+MNWJ3KYPGuebWN9rRBUIUBZ2KjxhMFSOIPFsgU3+yBpRxP/3dJpQR9llHqw78V0H+8fOVOe/yRzOAGEY9mgGvCl1+3KDWvBBT5GjnpSJ+Erl/dKiuiLyJhDOuqFSPLg2ib5K134e4yaXQYBlGmS/U3vTzfwIxe95CcRnEHS6azBpJs6bXzC0L92oH+peH91SsXf4PuWB3uJpXrvr7Ppgx5s41TiiIPB0Cr2m+7UFmwvz7OetcrEL6jioWzQ/DITICHQTFmwlY2r/vN0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: x86@kernel.org
---
 arch/x86/mm/kasan_init_64.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/mm/kasan_init_64.c b/arch/x86/mm/kasan_init_64.c
index 998b6010d6d3..d642ad364904 100644
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
-- 
2.41.0


