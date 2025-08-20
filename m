Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D298CA0EED
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 05:37:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D63A8E0023; Wed, 20 Aug 2025 01:37:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05F9F8E0011; Wed, 20 Aug 2025 01:37:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E926E8E0023; Wed, 20 Aug 2025 01:37:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D715E8E0011
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:37:02 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9DBCCB8ADC
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:37:02 +0000 (UTC)
X-FDA: 83796027084.02.C47A265
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id DA2E3140008
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:37:00 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HR6ocByz;
	spf=pass (imf09.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755668220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z1K+NrhffiuczGQxxvXLPTT8safjMr4ane+44BSMgbw=;
	b=nZXIOq+h4NgjaQJVQpcOMw/S3YT92vbRLjcLod39/v8cN3N90J9CYZjEN3q/T5mdzJ9bWV
	uc6GrN9y9nyOC2Ym/s5BgFujgNdhwz1ST+tLhPKPZ/cojccKpDGt8KRO6dhqy/P2F+HeaM
	4EpVSQyUoTHwIi9xaGrnMfII14h2/fI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755668220; a=rsa-sha256;
	cv=none;
	b=W7bPjeVP8Zj2qMkj6uTfbntjON1IjdOr4UKE9/mb7JuxT4bVDtyoa6w4YoIlqflhx7UU/V
	K/IA9p3jj6KeKDaDhPOgNXXJGgXc3gqcJZPBQD0StbYMIr96UWQA+JdyajvKobuGELepoS
	dSlgCpglmHtVg1MHjsf/HRO2rdx3p8A=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HR6ocByz;
	spf=pass (imf09.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755668220;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z1K+NrhffiuczGQxxvXLPTT8safjMr4ane+44BSMgbw=;
	b=HR6ocByz7mw4F8A3NwodU+qxiioDXqR8oSQ1Umtfp+E5Vw4+b9dd+ksDTPkrXZacS3kPgL
	eek0BdaqzpVQwvgyO4Osld6GpNEWupdpH1HfQOgV1y4l+mMtd8kouOkzldsjznPx+RS2y2
	jLdMuVBkMC7n9iw4Ic3Gc+M11HObT1M=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-679-FM4T_kMAMBejUgJcViqkcg-1; Wed,
 20 Aug 2025 01:36:56 -0400
X-MC-Unique: FM4T_kMAMBejUgJcViqkcg-1
X-Mimecast-MFC-AGG-ID: FM4T_kMAMBejUgJcViqkcg_1755668214
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 62A951800366;
	Wed, 20 Aug 2025 05:36:54 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.99])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1826D19560B0;
	Wed, 20 Aug 2025 05:36:45 +0000 (UTC)
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
	sj@kernel.org,
	lorenzo.stoakes@oracle.com,
	elver@google.com,
	snovitoll@gmail.com,
	christophe.leroy@csgroup.eu,
	Baoquan He <bhe@redhat.com>,
	linux-um@lists.infradead.org
Subject: [PATCH v3 11/12] arch/um: don't initialize kasan if it's disabled
Date: Wed, 20 Aug 2025 13:34:58 +0800
Message-ID: <20250820053459.164825-12-bhe@redhat.com>
In-Reply-To: <20250820053459.164825-1-bhe@redhat.com>
References: <20250820053459.164825-1-bhe@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DA2E3140008
X-Stat-Signature: eo33qwhr4nway1ct7zrpber74p9ntjmz
X-Rspam-User: 
X-HE-Tag: 1755668220-759261
X-HE-Meta: U2FsdGVkX1+LlRH6aM/4higwY7ua+6m6yJ+CYsp61sTc7qt9/QpqQc9ILm2B3Uo7BYafPdWdgIGEMUe7RJhRnbQuBL0H7QjbYS6zbri0f+KP7AFoxvQfcMLTjTceUEucuKpxWVYS/wC6w+8UTKJNuDGjJWbQdwrceIR5jPP+mTnvP0c6BzfSPkTkizbC03cRbOKcf59A6cn/WO4sND6zShBCD+vVnF/yHQfTfI8bMeTcTOZMq+UUEojQwxtt2gB/tYjZTw8T6wvEFeTP/i9gkPRcUinHh1Kx0RUmSxsp9umzxfKNfMmDpZZ5AN1hfU3zGapgG5+LOGxtJD1MvqHb7fx3qdg0KGi9MlgQ9iVtoWfvy2bOBso455OZqsBxNT3PTuc1iby5W4N+YTsBUbIFzZZqmx+gm1rs1xMTY1d2H+TdWnSjH5mZ12p9cDkluUZv5lzWJOUOd8cRT12U5pWWjhnvhgj8T41U+l0CjQ2R7Z+f3WLbErfhmj/gxk87Id5/MnppfuguwPtqFIpWmwTgWG//y9hBzK22DDhEd/UIUgSpjR4eH52yImzBnLTFStmrhWY8T18Bohp6E98IfFqbpF39jNGfRK9XGtA1fihkZCf4ocFHsVmiJb29bcmVkhljdRcu4k6HipCQADrmZgpzyas6124FFLTzVHB4Gag4whQQQG1Pdt6OPZ/QX2Yh199kgM5YbtELdsiCWhKOjvzeT1ZxayirxOHB2MWHJS3rNJ5rrmWLSidK23OzhNw3UqgzyZEHEaMJ1bcCCKQGtb3gyTD/058EtfL2ElL5IgMWvo3vNuT5aOb28wB6xqjT5yK5ye9sz0HKnMCtL9f6CriAC7cFTQVd2+1bdWrxZKR5Ea8YdaewpTrUbYWS9LDDVrNppsq4C8debiPLKZWgJhhyxSoUz7H6ro5JxTBHq+DFJXkIL0VIzUbGvaYhuv/gAzG5WF4YzArBN90xAcPMUo0
 2WEGFOc6
 OpXRi0iADNjTeX3q6J9nv8U+90ryxek2rFK9IPvPR+Iaovyu9f/ZtOtl2/S6wwPGD667vju56MyvQmL8C3hotw9IJVxXvvoxvNHz+Z7WPDt5DHQa2mDzlhF6xMPxVuqQ6ntYcoA42WGZmvOTtZi+4UwgHgFnb3tOEQxby1qt8SPOmCT8M9IUPiHyOnZMUQ0sy1tUAnCYPbsoAvSz00bziIH6b3prwIKy2L0HeghaOx+6T9PcGLWrwM7Q4n78Mg+taqsBcm4eqTQFhn89OEGpLirPMvsLQsuWNhlCfQ2lG67zGV6WJYHPsrHj+QpjoUIDinzMUTpxTF+GNGsoWf2W1NVGa5q78gP3rzDmofuVbLCUep5BMb+R+91cutcWCwGGGWIC/vAcVjZi9QFVZ/+224gLivyhCO/Nhqz6tRMgReMj8r5A0B2EDQvFmVYG4VTWW2bEfw/2xVI63/Ek=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

And also add code to enable kasan_flag_enabled, this is for later
usage. Since kasan_init() is called before main(), enabling
kasan_flag_enabled is done in arch_mm_preinit() which is after
jump_label_init() invocation.

And also do the kasan_arg_disabled chekcing before kasan_flag_enabled
enabling to make sure kernel parameter kasan=on|off has been parsed.

Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: linux-um@lists.infradead.org
---
 arch/um/kernel/mem.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/um/kernel/mem.c b/arch/um/kernel/mem.c
index 76bec7de81b5..7b7f838274b5 100644
--- a/arch/um/kernel/mem.c
+++ b/arch/um/kernel/mem.c
@@ -58,6 +58,13 @@ static unsigned long brk_end;
 
 void __init arch_mm_preinit(void)
 {
+
+#ifdef CONFIG_KASAN
+	/* Safe to call after jump_label_init(). Enables KASAN. */
+	if (!kasan_arg_disabled)
+		static_branch_enable(&kasan_flag_enabled);
+#endif
+
 	/* clear the zero-page */
 	memset(empty_zero_page, 0, PAGE_SIZE);
 
-- 
2.41.0


