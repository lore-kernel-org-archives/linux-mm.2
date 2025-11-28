Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEB61CFD376
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 03:34:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 179F56B002A; Thu, 27 Nov 2025 22:34:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12ACA6B002B; Thu, 27 Nov 2025 22:34:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0677E6B002C; Thu, 27 Nov 2025 22:34:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E9FC66B002A
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 22:34:17 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A42D6B8345
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 03:34:17 +0000 (UTC)
X-FDA: 84158597754.02.6B1603A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id E160020006
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 03:34:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=T9XT1fjo;
	spf=pass (imf03.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764300855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z6ce0A26qYWTGzgTeV3YqEFLmRYbdSXU7xKZaZXOpMI=;
	b=n3NhLKmIb6PP5YpfK2loNB6abHwLdbH5vdgnBjPLZorCNqcr1aXCQxL/+RSgrIjtVBWb8K
	dg+LD9K1g3mgGuTkKwUYSI03Yy/oIIVT4FBfPkhMOL/If2dEIDneB9zEoSLUPjKYOnWdyl
	igGpsDHOZz/tX7bfu+IDUVPEXqjCirQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764300855; a=rsa-sha256;
	cv=none;
	b=v7hfsX0bx4MAUHZOSSmmEmp/Z+le13jvH74ZmKq2c+E/ffnAlDZqoqEv4OWzUI8XHFCRvk
	gXoHt4nJfZano54iJ22JxmnFE5rm8eigZFvb+szUW0+47GX869g5DRO0U0qEaUYirlZ6gW
	6jJpblkwsGYJOwAYk3JLUxoQhL/d4gM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=T9XT1fjo;
	spf=pass (imf03.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764300855;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z6ce0A26qYWTGzgTeV3YqEFLmRYbdSXU7xKZaZXOpMI=;
	b=T9XT1fjodRISASupqb9gHVojQsioPyfik9hpfV7c0bmfKSRLqkbkWc9xJVkI0HFk4/5Yam
	9a1IrmIrUtwrirZCfB0JMQzVpoTmL01+9ltSWp0CBIrHFzjuCmUCk3gEWw0qzQ1lYHitip
	aiOaxM07gqSgxqSxBDaKy6N7oVSH7K4=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-607-hxO-P8tUMzmgqFinLUZQLA-1; Thu,
 27 Nov 2025 22:34:11 -0500
X-MC-Unique: hxO-P8tUMzmgqFinLUZQLA-1
X-Mimecast-MFC-AGG-ID: hxO-P8tUMzmgqFinLUZQLA_1764300849
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A4303180045C;
	Fri, 28 Nov 2025 03:34:09 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.7])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A7CDD19560B0;
	Fri, 28 Nov 2025 03:34:01 +0000 (UTC)
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
Subject: [PATCH v4 04/12] arch/arm: don't initialize kasan if it's disabled
Date: Fri, 28 Nov 2025 11:33:12 +0800
Message-ID: <20251128033320.1349620-5-bhe@redhat.com>
In-Reply-To: <20251128033320.1349620-1-bhe@redhat.com>
References: <20251128033320.1349620-1-bhe@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E160020006
X-Stat-Signature: nq666u79pwe45fufpi7spp1qtw9jpo8x
X-HE-Tag: 1764300855-27335
X-HE-Meta: U2FsdGVkX1+i0O3Q9e0JCmomy3Y3+ob0FFK1n42RocdncuZNATEWSy52M90y+pdbk1z8h0Bg7r6qbpxzkmXXRYSfKBEWRbEoZyOxJccejO4yAjnt0Tx+nTTSb3ws1OQgUHhpq6MPV8CbrBsaQfpT62nNfN8YqESCbK7P07IWaSLc9sBBzjEG/O62lwtYLyuubJakDfLUsFRzWUcJkg+X2P4LrCJCZkUfv1SwnxY2FnNB6hK+6EJAyco4poekQoA2QQbY/Qu6KZoG/3G38zSovkhRq5D9Ia0zn2ywSXoWKTssMN1O15hvM6phZNJjAUhVyhoPpzbhePCDIag+OsPehXOQQsqhi/ovtX961ticsSJVavSPslpCfN/B49Td6T1KD041TC8FYwPNWa3yvkAFC4hS3+x5P8pfRdv9Wx0WIWxlgmUWCbF+Llec+dnPTMNx3WOOFxzvTPWG9OrD1LlI3CVQTNDzwiDl1/Cl1d9vjMWVHJ7PgtWCesr57KYvrhU8/9hpPKwz8/l+bHqIOJwgLZLAm+7TxWEj7fJqAP4Qy1DoOviHeqKl4GSuGSB8+u3xuYvT627nVXVYFbB4By4pM0vw64DVPy8RE/UnZD4/4Zf2C/n638mV2iMMhJUtRH/lgHQDP+/KAixrBrTbJMP+qwys8J8jvQNrbG8kSHREjN2lfsmOgiQb6VQ7Y1TjP/0VwctepVzyH0TfCzDVovG7tPJ9OwX1CiS7Q9TpLxTZAuh1E2jpI+v08r0SSm8QCoPA7QScgPW3TxRUI+JuDCtcX0EtPpS9A4aZgFrvnJfsqMkp9NeqYdb/5h0BfKE1+VJpoEIu2T8UNI8RQtHCLbwwdxO3XsUbn1+dyDN2N9yLPfyrVdETGxyX50xlBdW8ITBBQe3ruH8GL4CAkqlQbujYfVfi2frevR00ZBBVk76/q4s2q/lNXwxQY47PN2f4BENKeTiK57Wq760EGxUaecq
 GkNEAF5Y
 B1np/MpL5tL7hY4EvTQrJO7aYewBQfLLY2T6tKw3B7cSHluAQ6jkeco+Gtvce2mUD0NGDsoFORJoDnatd1oqmEvE7ikSzgkT6LUE38tY/UVsCeLXRGwHEKc+MGRQa2EA+K3uxIsX4O5SYp2gSBn9G5VYtCkxxDP6qAnsj2Fko0sW+1SxOAZYhQwolTibSq4VL4Os2tl29QM+ZKE/RWa9yUL27qHgMMMK4NoY2bt1RIMKcK2SGzMFnCNACzTUiUVbwHIr7GvMvKhBCPnznVRIRqrLKDjChS9o1LLrdT/po4ytnbirzxBCsonbsxRTn0j9LBmX5lYpRbq05AWvTGxdOsG51KphprA+NTcsX5/bz6aOq1otHBaYpQ0Du3q89CULbZjtHgfRcFrqccU6mGsSvje+VzP11okAgqynPEq7piXaKNhYbu5gn5Ix8ox5wNYSa+wYRa9D4nQz3Lww=
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
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm/kernel/setup.c  | 6 ++++++
 arch/arm/mm/kasan_init.c | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 0bfd66c7ada0..453a47a4c715 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -1135,6 +1135,12 @@ void __init setup_arch(char **cmdline_p)
 	early_fixmap_init();
 	early_ioremap_init();
 
+	/*
+	 * Initialise the static keys early as they may be enabled by the
+	 * kasan_init() or early parameters.
+	 */
+	jump_label_init();
+
 	parse_early_param();
 
 #ifdef CONFIG_MMU
diff --git a/arch/arm/mm/kasan_init.c b/arch/arm/mm/kasan_init.c
index c6625e808bf8..488916c7d29e 100644
--- a/arch/arm/mm/kasan_init.c
+++ b/arch/arm/mm/kasan_init.c
@@ -212,6 +212,8 @@ void __init kasan_init(void)
 	phys_addr_t pa_start, pa_end;
 	u64 i;
 
+	if (kasan_arg_disabled)
+		return;
 	/*
 	 * We are going to perform proper setup of shadow memory.
 	 *
-- 
2.41.0


