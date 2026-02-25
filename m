Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4507EFD202
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 08:16:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C7A96B00D5; Wed, 25 Feb 2026 03:16:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35AAA6B00D7; Wed, 25 Feb 2026 03:16:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 274B26B00D8; Wed, 25 Feb 2026 03:16:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 146E86B00D5
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 03:16:07 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D94821B6CBA
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:16:06 +0000 (UTC)
X-FDA: 84482271132.07.DCD15DB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id E3612180004
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:16:04 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FGqHqNhv;
	spf=pass (imf24.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772007365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=19vaP3y5lR+93yTFpmYDfoD2vHNlJZSHy6oOHn35u4M=;
	b=y4k8m7amdjUxUtFNyY+6gY46hKDZib+Ach7emqXkn2V4iNOwYhpo0DY8bztot/RTyoKQEq
	0fU+1nOsW4VM7HqT4g/SMrUJxHAZMEkGMBDs9D3g+oqwT4jeGvhDBLc8MXkIncoqCx8C3o
	1tPj50l1/VXxG+aENFr52ZqK+zWULl8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FGqHqNhv;
	spf=pass (imf24.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772007365; a=rsa-sha256;
	cv=none;
	b=a6tvJy2pZxTno8ptcuqppkEtYKH19Hi4PYFe1jOf0sScz9pIGpyXkS3ggTSL6I8x0OuY3+
	gZDA+2ud/FgRfQerPC27ScELzljfcWNqsxUcY7Ax5sKbz7EnG/n9iFswX1kGQV6VED+LpH
	xN2z0eI9RO6cS3AmGyYJQHyB4bJS714=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772007364;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=19vaP3y5lR+93yTFpmYDfoD2vHNlJZSHy6oOHn35u4M=;
	b=FGqHqNhvHyj4ogM9d437AJZMOmNwcbrAbzhWHw5ZM6OKF626Y1BD5JdLs1FGgPKUY5pjF+
	/WR9927+PJ5ejhyM6AQ5q9O5LeKpDKdTslUxYAjbOXTd86VVOzUUHI7ze9YE3Yo06sdvYR
	U3ibOyuubt91n4Xe3Z5z8nW7shs/IQ4=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-659-fNbyuKNINK6CJvlLPKrBfw-1; Wed,
 25 Feb 2026 03:16:00 -0500
X-MC-Unique: fNbyuKNINK6CJvlLPKrBfw-1
X-Mimecast-MFC-AGG-ID: fNbyuKNINK6CJvlLPKrBfw_1772007358
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 83A1E18004BB;
	Wed, 25 Feb 2026 08:15:58 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.55])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D0B361800465;
	Wed, 25 Feb 2026 08:15:48 +0000 (UTC)
From: Baoquan He <bhe@redhat.com>
To: kasan-dev@googlegroups.com
Cc: linux-mm@kvack.org,
	andreyknvl@gmail.com,
	ryabinin.a.a@gmail.com,
	glider@google.com,
	dvyukov@google.com,
	linux-kernel@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	loongarch@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	x86@kernel.org,
	chris@zankel.net,
	jcmvbkbc@gmail.com,
	linux-s390@vger.kernel.org,
	hca@linux.ibm.com,
	Baoquan He <bhe@redhat.com>
Subject: [PATCH v5 08/15] arch/loongarch: don't initialize kasan if it's disabled
Date: Wed, 25 Feb 2026 16:14:05 +0800
Message-ID: <20260225081412.76502-9-bhe@redhat.com>
In-Reply-To: <20260225081412.76502-1-bhe@redhat.com>
References: <20260225081412.76502-1-bhe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: -HcprtaPsIzh_hiGA4miKAdXAyX_Ynxvn0Vok1YB98s_1772007358
X-Mimecast-Originator: redhat.com
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E3612180004
X-Stat-Signature: 3yucdfc13bx86sgm4wiurbep6ap3h7sb
X-Rspam-User: 
X-HE-Tag: 1772007364-195921
X-HE-Meta: U2FsdGVkX1/aQn0E6S+iOq6x05cFXFpgaE63uls33otDdrgdIwd829T8JdqHVlDMV71TgU5Ett+RfI7GxMnObAA2sXdrnLlVva1j8Tuvl+22S1v2WgN3sH/1MCFK1yg+7i0AFCJkkZnSkgFDxNgqaNYoqdsAeNYv96kN1UKwlrKVEsdLHQw2c8LQenHtNxLmbWw31KrUcwPAdfkj3nMB9cLyTi1ZQ1LxwpnaBZzJPWDAqUEyGl7e5CcWtgw818ULgahUU2zHdNGNQ5qPhX53k/cKqdDeu7jatiYxtQM1hPpMza/140AO+GYevXJjt5Gh9hyBwh13lfCXcDoHOIWHmV6Nk0SBs5dLFW2JZW/o8N/tZ9TigHO0TV3eKR8IsD/K/gnSTgeDxhCDD/99ui/VWU+XN2Ou+y+0yt4FaAVkrYQ6PiX+Ekj/7NXzFOZK8ejFmDhEMgdJ2cB8TWnr3no+dZN7piComNRajicpWlVX/s5SpT6aIRicC4wVskm3y0scI+sEW/VKJ/mXBSbtAiYgploW25orr8WDERqXZj+wgaG6B9ycso5d9NXXJOYZNIHYqKCOF0KAHG6ZdYDuG+Wk9zXqhiMLXLGQJy8t8lBRQelZQBVFrPR/uUDmEfYpsWkvWi5aGojwdpNS2KMlZBgi3095+8vP/wToeR6yZasGiNK7nR+Astw7vzguFISw2P/s+SiibiMi+j6gmC3PjOnCmGMB5R0IhmRSJmMSoMZ2CL2Z4TPl2uy7Y5gOQsIGOyF3jHKiI2qzwKy4dY+GM/NOAMBQz/B4kiIVRNx/3zF4Yv+vzHlKUGrl6gk/Yo73DCD4VmvEROKqPmPydNWRt4MkvVx9adT6MWrFhAkxJXEtprOUypbLkunNAPJXMn/y+GxmgSAoDHMxVzObRuLKCbPzSz0tQR8ragEbUiY9isOTtIJrGa73ipNPnqBILHwLqCzanxN7B0hIs8bBgec9fOv
 7wDKY7Lo
 X35fzsu9TaLiUDmNrmKaZXWrEpw4AeWSfsj6oJR380HVHKqLiSnI/bFIt35v8NP0TO3x8/PMSsjVN3qNalUc/BnJHNAtIqPAO8VD+FY70oLxGzGkOKdmOu6CAZuMF0xetFAKX6vjPg75RrHy4yQx7No+a9f/qxzXx3/fcI9tClgEXAe2gNm1yC5KDi3o0IG2W8RjHPsHqNcsJX7aqhfYbhSWSKArcOQatFvhxBCz3NtwZCWhvorq4IVV2eo4AqHzGApkcybd2WChOKyEZd7kqTKoDbLwqWHIA9JiW6dQt8sFO7j1naEC4QZ65gtHjdC6/omdwI/1TxEw0wCuSU0S6hE1/2y6z2ndAvLv+uW0WUG/pE7fAtoTxobrC4BbOcMH2h0VGEHGILA2GefPba0chbh2Tyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Here, kasan is disabled if specified 'kasan=off' in kernel cmdline.

Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: loongarch@lists.linux.dev
---
 arch/loongarch/mm/kasan_init.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/loongarch/mm/kasan_init.c b/arch/loongarch/mm/kasan_init.c
index 0fc02ca06457..047a059544e1 100644
--- a/arch/loongarch/mm/kasan_init.c
+++ b/arch/loongarch/mm/kasan_init.c
@@ -269,6 +269,9 @@ void __init kasan_init(void)
 	u64 i;
 	phys_addr_t pa_start, pa_end;
 
+	/* If KASAN is disabled via command line, don't initialize it. */
+	if (kasan_arg_disabled)
+		return;
 	/*
 	 * If PGDIR_SIZE is too large for cpu_vabits, KASAN_SHADOW_END will
 	 * overflow UINTPTR_MAX and then looks like a user space address.
-- 
2.52.0


