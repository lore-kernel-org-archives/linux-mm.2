Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CE54CD98F2
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 11:47:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B98276B0093; Tue, 23 Jun 2026 07:47:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B48A96B0095; Tue, 23 Jun 2026 07:47:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C2486B0096; Tue, 23 Jun 2026 07:47:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 70DB46B0095
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 07:47:53 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D3BE0A047F
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:47:52 +0000 (UTC)
X-FDA: 84911003184.30.A1BDCEE
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	by imf28.hostedemail.com (Postfix) with ESMTP id D82AAC0002
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:47:50 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OUtwUqIP;
	spf=pass (imf28.hostedemail.com: domain of igorpetindev@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=igorpetindev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782215271;
	b=aX6pWk5UJ/AcE55YG/mCYvY8fVs+xdEbDxKeEuMmsG/50oI2Lt7Tn9+V5H1rQU/FWWyuVL
	QiQ+6vfmTyQrX9sjuqs3k5Xj1MpaiFePZyU1D2LurzBxVZPXssGckE/OL3tJt4miKe3hS8
	HefhZsvgf60zdaF4GkTZJfhnztNpjIE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782215271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=td7t8deEuBI9NJcbRvHq0nNqOQXrk79C5vlrBc2QmMo=;
	b=Wcbrw46DW2zcnFrT62PyhN4kEPyncPoKS0btH2CFnWcHgNiYrezJYj7NnopM7jFrwUMMtw
	m1MpDQSP97Aioe0D/GKzUHKO7ohHWhBX4t5wT9VT1qUsSVltmsOBatmNDWKsAMmetl+CUW
	sUArSmia68FLom0orE0J26EmQLB5H/M=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OUtwUqIP;
	spf=pass (imf28.hostedemail.com: domain of igorpetindev@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=igorpetindev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5ad4a5647e5so5920625e87.3
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 04:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782215269; x=1782820069; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=td7t8deEuBI9NJcbRvHq0nNqOQXrk79C5vlrBc2QmMo=;
        b=OUtwUqIPOOXmyQdYg1+axDZNilLD5ewQuBcpnnBHjVkcEMKrEsiDRcSwbO8pAZ3Mqm
         H5G6v5OS0hTMe4sftgIDi+ndJnmZhwKd7Avm12v9CEAVRczYZl7yTGOmD4zgQXccCSfr
         lKNqcal3M8dcYRRym96cl1VKQC+3Qki2KuHYQL1RwviSjMoENJI9teXe19diMG2usdXZ
         pW3ruDn7WrWVexSx+/CNru7NsjPKgzX1fgHB81DCx7KJjXHVOM8eyvte5gQt23XS6j3E
         vH28L6TWkFV6Rt0TZLwv+gD9P/ibaio47HVtpL0yjm0VFPYdIDP1c1u4JgvX4Bzr7yPS
         FFnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782215269; x=1782820069;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=td7t8deEuBI9NJcbRvHq0nNqOQXrk79C5vlrBc2QmMo=;
        b=qX5eLdrZyXLEPquObeN8slVtp22PX+SLbOwq2/p9jj8i4cSqi1calmh2R3LWaAkisP
         zy2ddkASZT+/Nhca1DeRTOMZNmzewBm0j1se8BbbFgbwd+pqctVfULlQeAW41eWbSF78
         I9fJndNnKyTH+Pl2RPfQGuR9t2gtp/nWwJ+4P31vheSd8hz3tZVcAev22yf/szoEksIm
         OQdGPHAoJS0yvlrf3PdY5pECyahVk6tlJNyTY2CEGwnJHWqkFFlW82yCBh3cqKkB3bKF
         83ZQ2Bby8rdlP/zCKYvydbDTk3L7h9kb5wJGdU+8r3WvoA9bBEqVBOayDNdYshKrWxSg
         WPxA==
X-Forwarded-Encrypted: i=1; AFNElJ/ANJGRw9LOPBW4scIpERxxddWlBdKAf9OrGdYDCnELS1DcjhtmNk630BmM+IXXgczfyAAKFv37bA==@kvack.org
X-Gm-Message-State: AOJu0YyYtDC8dk+saK8LVoMv0NmJvrB0jVB8EbRwWSZee+4w69UWzvzf
	XK+dE51TYPVKZXDbxw9zNJ6N9OLdz5RRI0SOkrkxZ+gxFiLLvEN8A8uO
X-Gm-Gg: AfdE7cmOUTQcHt5oa4QA/3BawjpLzczlwuKxKK5r3QfvhNFP8LHWyCZJXGtsUQaTSm1
	9VaKXoHo5tB/o3XR0DbNwAVi9lcx0pHUcJQIUFVTbeG0X5NI2j9hLUS2UhmI9SQWo23U4gyFRN2
	H0LxA/AQVWoxMhDuyvhzK/nXuPRHTQSJvEGzsDbZhoRV2XU7fgznitkqtRtTHCpJndb+qGlpTiC
	4xcYKtfL0xBeS1ZxIP0CsE+zZVgvPWy8vmA/uVJ7AUcFnaQJgxityxGp6f2wiN9mx9RKSLQv28F
	ewfuXazhIFynKwTmJgxVKo8Oq6wNRYtRfu1a2J/La3dWLfZXUjJDGO42Vx32pqZXrnhtmji2+nf
	GfPhOJjyspinuO7eo01f4IwwlO//oLtC7iAyfwpMOWxkt1QWvWZ35hP8TRvAFGrtsv4c8wTLXfi
	lfUV9bwV+Nx6gij1i8wkM3WCT0AbeI0hL2rk1+rggYBwq6BQne5dV/wxTUK7oqNayZ/Jf17XeeI
	QCW9acuTybV0N16bNVlmg==
X-Received: by 2002:a05:6512:8042:20b0:5aa:6dff:cf1f with SMTP id 2adb3069b0e04-5ae3511a000mr374430e87.45.1782215269005;
        Tue, 23 Jun 2026 04:47:49 -0700 (PDT)
Received: from g.localdomain (95-25-158-125.broadband.corbina.ru. [95.25.158.125])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5ad69555981sm712083e87.34.2026.06.23.04.47.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 04:47:48 -0700 (PDT)
From: Igor Putko <igorpetindev@gmail.com>
To: ryabinin.a.a@gmail.com,
	glider@google.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com
Cc: akpm@linux-foundation.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Igor Putko <igorpetindev@gmail.com>
Subject: [PATCH 2/2] mm/memory-failure: remove redundant initialization for hw_memory_failure
Date: Tue, 23 Jun 2026 14:47:43 +0300
Message-Id: <20260623114743.4565-3-igorpetindev@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260623114743.4565-1-igorpetindev@gmail.com>
References: <20260623114743.4565-1-igorpetindev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: a6srxxryafypzex6hdud97dtkbt6w5ic
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D82AAC0002
X-HE-Tag: 1782215270-301759
X-HE-Meta: U2FsdGVkX1+GJIYt66ACInqa9gNMwho6nZiZDhe2zWFebDjogOfqAVyfAw6w/pYDa9XbXEWotARAW9nzdERo117CcfKQayysSXRaWe0/VPYexDE243dyKhkrs+YlOqEEaYrUVyfYlO2cl29FgWrX2wrlgmNYay842zTcbEJC9BtstQ2rqmYijAQYWE+nGCNxVvyZ59poj9cfcOjqyXk12nYHVcav4r30NrMDq+E9Wq6usGWfRgXfR3PuVe8QlXF+/Sp23tvopvcTjXIulxVke02zsqC+k8zcbQd8UvGLfNHizJUUs0G4BlbJ/4qR3tPz7+h2JnlsSw185I8eZtfmGKj1mxrbybh1hb6v7s8kfPLrkIgs23Ka7AuIS14a7VECLWTdHyR0aJCxp7JshTAZQdvoX11XIbBQbnMWiNVI2nMB1qDynMpfnLWx+cii+OafpOonW2qEfxJYCozSzddkfcmVVJ4cBkEb37J2YAd4B8qO0q1/azbOqVK1F7cX0ahUgLYbgknyZbyqAmYyEAg4kN3ZTLfq3zvfe8y61RY1P8W/3kDQ9b8Lcrbozb0H26mld0MTk/J4Mfc7eeyF34BTZixbKcoKRD/EBy9P714+1GaSon3bH4h/WE4z6FhrILOIaJK8uQTrc3s8SEYYuNADFnuFMHMOgODchBWxSmi/s7dpZDh/Rrc8KYuXgcsZLLIrnsJaC7uAvN6y4uFMYSHhvLFhYn0YqZnRAkgEl56D4wWxVgX/TiX2wg65rL+9WLBBd8DuiFA3ZT8CibzgTjFM891EG6siHDlFlUi+9VD82qr/rDOxXmvN4Vo0U0F230457kgcNtFvXg0ipEFMPa0MKxTdfslcHe8lmq2rQc35R0IEeqw54zqGji2Xvv3vO4pTVp6pE3H9G2DH4Zs2I9r+ARr0H615pS90tL4iabNQePbs+SnrGwuEmMQGntjgHPiDb/KQL7FwenMbw5ctuzv
 MMa9zaru
 jS7fYu89pIIWDINSikQo7Hcb0ctvHOUWleYVg/z51jNjTSnnMcd4AyBianX0E04JgqXFtO441uo6GFyv4TlWnZnD1yXKVZyfGFWt1wjmRY5vtOtztq6dZFdB7LTIvH03UajD2ajEVPcGOJrJechReHNdpBOx/qJqC0VSeih9wJ7z0caTRe9vHRCO6d3OQNAqqjENKaoPykN6uMKuYlymxXrZRFElWZOtbnbYK/ywHr6ZRgHFeIqbtu+TKnRHUHKTTZp/2Hiay7TUSYKvqpzKPsokCtiYjo7iWnY0LRbRGRmFSy3fo3fSPqiZrlPxL7KAQxxnT4bMZjSxjpAjWGKrBWzXF+cSh9h6tq1jnlqwUYhoLZqGxpgMNZVmiv4VvYmEEOJcJx0sasGmm1rt7UchPIF3yay9ktmOiZ2yeCzTGqC/CYAT2zwsc36nSJe7bKuMwRqwVekjUIqyHX5as3NrdLR9p3/nnyXbGyhA7iS6XJYABIrrAc7w2Na5UB98BBqTU31y+GSO6KSTurwXJPKw9BhcEyOZ4ZT7cLFQO3SLl4k5EJZB9GVc0nqjR2Vo+v2bTbzjN5e9/o6mnObVNArrZbhq18JEHFlB3AtnDNPszNpc86ZDN2rKST03cMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The static variable 'hw_memory_failure' is implicitly initialized
to false. Remove the explicit initialization to follow the Linux
kernel coding style.

Signed-off-by: Igor Putko <igorpetindev@gmail.com>
---
 mm/memory-failure.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 51508a55c405..4963ea9f6ec6 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -76,7 +76,7 @@ static int sysctl_enable_soft_offline __read_mostly = 1;
 
 atomic_long_t num_poisoned_pages __read_mostly = ATOMIC_LONG_INIT(0);
 
-static bool hw_memory_failure __read_mostly = false;
+static bool hw_memory_failure __read_mostly;
 
 static DEFINE_MUTEX(mf_mutex);
 
-- 
2.34.1


