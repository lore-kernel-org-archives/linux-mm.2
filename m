Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE180D116F1
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 03:34:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B38A6B002E; Thu, 27 Nov 2025 22:34:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28B5F6B002F; Thu, 27 Nov 2025 22:34:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C7ED6B0030; Thu, 27 Nov 2025 22:34:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0CEC56B002E
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 22:34:29 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C702712BA5
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 03:34:28 +0000 (UTC)
X-FDA: 84158598216.30.A53A69F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0E7501C0005
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 03:34:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KHDnTcCd;
	spf=pass (imf21.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764300867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6bb3Fj+IEu5TgR6FamitgP4LC7HB+ODz43uA7YZcX7g=;
	b=VJKgwd8PQudED72kijPdJUCBz0GP3cLxfEChlX7wXAnggVOLaaMkQidA00BQVDuxYttbRB
	98Aho7nvj6Z6/OSe4ccSzf62QWKlWJCK8QTJej4/qr/8wjcvQ4L+UDQf2jeJ83uLPpb3vx
	IHfR9gt51WnfsZgYfFF9ZCTBVOyiZ/Y=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KHDnTcCd;
	spf=pass (imf21.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764300867; a=rsa-sha256;
	cv=none;
	b=VvuwwRL4nBRRn9tIEIJkbrlhnklnFRXz75igu67ViTrmwC6bx5qYEd+m/YQTcgr90VCxdh
	mSnZ/pxjykonYXWEK32c+vFwHNFzvkXB1Ge5TnMSapItHzFreqOhzQRSMrn5LUxfy83XV5
	alID6muhZ58M34s/lqulPoJ9xng3a1c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764300866;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6bb3Fj+IEu5TgR6FamitgP4LC7HB+ODz43uA7YZcX7g=;
	b=KHDnTcCdYiGKfKtU2jggwOuIEf8lZwzXLv55+WpfP4/2rZTa1RWx9JWcpVd76OK62Y6xIv
	Nad0voZumV4kVxAOOAisY79Zr4njutB3f/A1l1bG5YP96NX+nQXYmwC2+lOqR7tHf8QwB+
	gjfYgEtxlakNgxOc9sqP+EgwWYtaiMI=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-639-sr4zb15qN6-IOLblGY_jsQ-1; Thu,
 27 Nov 2025 22:34:20 -0500
X-MC-Unique: sr4zb15qN6-IOLblGY_jsQ-1
X-Mimecast-MFC-AGG-ID: sr4zb15qN6-IOLblGY_jsQ_1764300858
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E2EA5180057A;
	Fri, 28 Nov 2025 03:34:17 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.7])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8142319560B0;
	Fri, 28 Nov 2025 03:34:10 +0000 (UTC)
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
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH v4 05/12] arch/arm64: don't initialize kasan if it's disabled
Date: Fri, 28 Nov 2025 11:33:13 +0800
Message-ID: <20251128033320.1349620-6-bhe@redhat.com>
In-Reply-To: <20251128033320.1349620-1-bhe@redhat.com>
References: <20251128033320.1349620-1-bhe@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0E7501C0005
X-Stat-Signature: xg1ppzeeahyxyge5pamwyt8sss8whs8m
X-Rspam-User: 
X-HE-Tag: 1764300866-231601
X-HE-Meta: U2FsdGVkX18RjAftxrfIyslErEFhQkfID+56U5v2pI20NoIDJbIh15PUHLwRCfqiW8wotVC37U8OPUA1HtRLvDSbTY5izHx9hOyeoGseKd9xJLiE5tnw/oSTKTcYTJuww7ZjF68SZkVXpL56FynmynRBqqFsYKMHUzl/rKDU0MtxtipZZWTJZvQv/8BR+b0pnN/+qIxGPrO+YdMZc6ueLJn1cz7rpmbS4RweSLiIDsCIzhHhdYwyCnWP85+ogWeOPJo32vK/bg6DDp7jW5CqgiZEtT53PFhblOoJlMfCvg32srBSOOz1no5eAnpZlu/eoOUevAuJZLaiDTlcoPeozcw1PZHdPq2r4KCUcBLHtp4flBB8yuBDCkSsvzY6imUvTfKIhc5yyiZmmP8EMs2TNBtfC/7lpvFvdkecSPWBclyM5RhI5DHMldVce+k3DRXrRqHZgeSLp90beo8UCSzSiyHq9+XXQKe2QJe5Rwat6erzPvvVoFRROO3fpeToSyUUIsjVaka/DbrTPYod/ojlGJHq/agpup6gAveohC2A3UVRhnsfTilj3xjStqfv0G3XVqEOOuI6HqJV6SPnc4B9t6m+sMFrwNSLO7WBdl8c+Qm4lde+w5wiMqVO1yZ+pfz83XY67jaNWP1OZ2IVJMbgp1ftKyH7R9OvSRdHOBLLt+rfrXpDPppKdSkcRYVFBRV0jKZVFzSM+Hjj3MCsaLDmF296y5PXGrCq3oZZL04e4KxIg7/+tzmjd/fy9j1bwP7OzxHlHqL0ITaiHfwI+2noqf21o/uDSKBCQ02C7yGo1X7y3SsBWWLiBnp78NGc1jHD0DdGhqLhzf9gLDbkUf7FgRDbUHCULw/+CtuoMzhxZhRhe4pPbH8W5t64XDkX3Ymi9T/OsQkU/fS+yr7U+UTbQM3OTIWOx6RHFBfhZeBUtMN8yRFKjpJS4C3fyuuEceFo9TOFAcom56FJtvklDfm
 +Dog2nj9
 oawChsBuqDIHQE45jmoqKH3YaP54EskV1sfsej9TtdR8P5APXUgGkM7YP3c71a0f+PA5IykCQ8j6ZqXohEprHiHDkmakAvblB1NHEdIpRw4xQAYL35p7l3Q33kzLnoQaHgWCrj6/bTVuhD1VsbZ/r9Uy3cAM2RB1wH4k9Lka2i978z0NXs4vnSNJH+o6ypSFR3gPfC0iFS5/Rp1SWWgFeFwlnjOQW9imUv0CF32cZPXwZXdz6xakN/630ld4L6mii5J2Sbzs6/nEZjrIRcp5z5wBv1Wveg0zGvzBBi7hIu3fKnPPFEIjGIBMlH0t34TwXNvbYm/Zdh/FPaJvLWIEas5MmGRQaEYanF6B1uyD3O/xgWFFxjDGQwy2Yqf+AUXfvPhJURC4G1rx4G2mq56dWm+K88bzP30K61hWcnU55IAV+PHzBw2JV+KrYQm+ANXZVCqjCBMnJloMu+V4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

And also need skip kasan_populate_early_vm_area_shadow() if kasan
is disabled.

Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm64/mm/kasan_init.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/mm/kasan_init.c b/arch/arm64/mm/kasan_init.c
index abeb81bf6ebd..eb49fdad4ef1 100644
--- a/arch/arm64/mm/kasan_init.c
+++ b/arch/arm64/mm/kasan_init.c
@@ -384,6 +384,9 @@ void __init kasan_populate_early_vm_area_shadow(void *start, unsigned long size)
 {
 	unsigned long shadow_start, shadow_end;
 
+	if (!kasan_enabled())
+		return;
+
 	if (!is_vmalloc_or_module_addr(start))
 		return;
 
@@ -397,6 +400,9 @@ void __init kasan_populate_early_vm_area_shadow(void *start, unsigned long size)
 
 void __init kasan_init(void)
 {
+	if (kasan_arg_disabled)
+		return;
+
 	kasan_init_shadow();
 	kasan_init_depth();
 	kasan_init_generic();
-- 
2.41.0


