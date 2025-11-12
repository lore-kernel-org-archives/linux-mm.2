Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91800CCFA1E
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 18:58:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C03648E000C; Wed, 12 Nov 2025 13:58:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B650B8E0002; Wed, 12 Nov 2025 13:58:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA2B08E000C; Wed, 12 Nov 2025 13:58:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8952C8E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 13:58:49 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4585B13B79E
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 18:58:49 +0000 (UTC)
X-FDA: 84102866778.21.3D53917
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf08.hostedemail.com (Postfix) with ESMTP id 753E7160004
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 18:58:47 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ajCwFWEs;
	spf=pass (imf08.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762973927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z3WsKjgbP+KqyauiXgVNPCy7vp9KyRxhPHjuMUUOEgo=;
	b=Cv5U8rc5fOaF3/g5nZAO3+7Bocf29s6/dzTWxR5q1OS2JxotHSeDBG8Y/fqcLjkASvSlVF
	ZKfvwGXH57h53Ve2mInIkPY/HI8ng8c/p8zzDI4u7uah8f2/3P1mdj4Hbr9KM5NC/9A30J
	NlCbnrtFh2Z/UixOEqHbsHyjvxszBO0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762973927; a=rsa-sha256;
	cv=none;
	b=P/2XW7EBQavT/7qQAre6vrDRF/akaxcJfdyV/JSSae+ttgY3ptzq62a9XQ2d6J1X6fcaTN
	NAihuwV90v1KLh81wWLBcHr+Zsg16qAK162IVioqrjbE0TBP2paiBqlFpLwp5mIikDn87u
	kR+dgU/l6npbhSxS4gnuj7OO3N4HJV8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ajCwFWEs;
	spf=pass (imf08.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3436d6bdce8so1483152a91.3
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 10:58:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762973926; x=1763578726; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z3WsKjgbP+KqyauiXgVNPCy7vp9KyRxhPHjuMUUOEgo=;
        b=ajCwFWEssiNcL45xs2qaqgGA3Zm8JvS7+k8OqWyygWfWvO/JG8eXW3AWZqyRQysXmW
         LdWDtPdQ2eye7zX1qAGkcsP8BNGforxs/7Q5T40JLTVPIEX1IMoCZzKptEJUCdK2+VUc
         hbcmV/V28EnKNylawk2KNYwBrPgraUs4315qCU26O59lWmIvJiUXVoh0Wk2eRVhmK6c+
         PY3FyBsWiZhExIUPIaOQ04uB1wn/9Ejn6Y6AORBbHItjagUxb1F8urz/f7qx7viZVihV
         MRnF47hMvvwstK06tMiLHMuFyYfS5uGzdEyp/lMTVlUpAz5eYAhzh2tDsp1uJzJlXhT9
         vTOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762973926; x=1763578726;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Z3WsKjgbP+KqyauiXgVNPCy7vp9KyRxhPHjuMUUOEgo=;
        b=DnDmUl7z9EiSnruYw2zI56W+Rlaa+SoTw/T/WpHEy7I3+2B3uWb3TZnNkZacrdvezO
         h5yLLzNWrxg2TeXF8EEvKcn9MnGWoLzZkdGZpX+JrJ9mYldRxRIG67FQrcj+zsLRxHPr
         53IRZTHevECXNt+biqJLyovV9Qv5d9vqGcWH361t3wWSUQVLg619NGT4ORj26ejbXRmk
         Zkshc0uRWcspKc+zVILkMEFfiHpZYSakuEMEk1V0XKwRPhSgZaa04Mgagls0TkUFvW0l
         ZfuJpt8ERFxWBQMxSIw4agzqiHQ8nj4N/csH9ZacCTKXZCvaAu1P0XYgdRhY/Siw+pma
         n+Jg==
X-Gm-Message-State: AOJu0YwmQgFrLdmo2E27ntr9tQUtMKRcn0rUqLhKPEecASZw3wR8hIJT
	z1jRIeDTVNpTdRJxS+veNjnWJ6Re1y+cydXGcZLHyljxzvwbLGvpXFdcOLB8yoJt
X-Gm-Gg: ASbGncuah2Kdi+E4RvBgIBK3R3eRvhVj6wlnrVRHnWuZV18/goNZapPIU9+XvEve6PP
	OQabG5sahNh7U9WlPzUKjQ0IgNadwClsbhGrlmGdepYS+9WOY80hDrITKdzy1MEUD8ZfR+JZbjT
	RIuC+xNnxF9I856xqR0cdnEJIpAsAA1a6v/BdAHlbN41R/Hh9qa6b5fpORiW3fUaDFhPnBGzUKe
	A3dZdLB1/IZRsGZ6aN6j4y6r8wwi/X7BpC3ZSAJPWrbXBQtN00BJIy0kUgDnfGOu+EtC6tBRI3G
	pmxqa4DG3BPr+yn48Fb/J+HEzmgvTVcJDxkxBzxQsNLv7YBVpV+nUZt5K1p0/dcs7i/LbRfKlW7
	7OxPt3x/tsGrstqjzkP6GO9V1qH70k2AJXl/uzMfI1pp1je3HaepL56Mz92x3pCJjcxxf72dHpg
	JOiTlt2bnoQT7ZYZxXHchjT2bhDLs9igsA
X-Google-Smtp-Source: AGHT+IEx8zgd76NJsV1NswRAalmGvg4jw92jAb5hKFRpnzCjVrgOWDoh6LdvYOwY3ymtnsLGhg2L3w==
X-Received: by 2002:a17:90b:4b12:b0:33b:6650:57c3 with SMTP id 98e67ed59e1d1-343ddec59b1mr4825254a91.21.1762973925965;
        Wed, 12 Nov 2025 10:58:45 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-343e06fe521sm3491565a91.1.2025.11.12.10.58.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 10:58:45 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH v2 3/4] mm/vmalloc: cleanup large_gfp in vm_area_alloc_pages()
Date: Wed, 12 Nov 2025 10:58:32 -0800
Message-ID: <20251112185834.32487-4-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251112185834.32487-1-vishal.moola@gmail.com>
References: <20251112185834.32487-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 753E7160004
X-Stat-Signature: dr14cwk6n1qmumzdn55cjsfuprbqqebh
X-Rspam-User: 
X-HE-Tag: 1762973927-775627
X-HE-Meta: U2FsdGVkX1/2q5qer0uaTN7kOsjK05J6HvU3q6VylQRucJAIAZ85mcOSHgQViICnFjJXPkT0NjmVgFraRE2URoQ3GqnRP21xYHGjv4mSvrZLkvNdzQOqZXGfkabddcVn1hKD+Hr7/se2CqBgqyaGLB2nO4Wjy4rE/fZItA8+rK8osRDaU3DYxHJatQrhKK1G3YaHdOHErhRfIE7tDgQiPw+9q42R58C0Az5D0YE0eqebYo/kobAcKcE6tL0CIn7MtF9Ef2IEJIfKESzQ5hEgkNRe9gvsRuR/7x6y8ajAXAJD76n/wN4wRf+WdsFw888FfAxhdxdFqzb5vVtEniyhNH1Wzheeb7rBiPlqPdrxVOdfjtwa7jtA1GqyVE2d8Mr6Q77LA1rckuql0WdNd0guTesMcvSCq1R0WRNS13tVCW2kJbh7ubtZcOAme6B/r8ZMUFYfKmtBdU5PQwSz1yqa8hJ2J0o5MbJqHXiTqRf6yboNl1d1JA7hPZjmJor/ql7ViIjC33TENOqroEyKQcy/xZtJrWDlrknezc/hX49xijO2DpjXE7nqe9vlaPuJGaIZy9Ee9d6xGdAMmxKc8mHzXZk8WshMTKLsMzqrzxwz6pA84E4qkWnNLhphuICW2RyxvBo6h4CZa/qUb3aSs6H/yMaa/EYaYrZ/ESOu9f9WTDMP4Jmewkpd0J5/RnHa0sSyx+bRnzAiJ0SLgWkQ6WXGW3GzKETm3dGCN3r3DjQzgLhtPCGSW/vj2aMzNvgx0WwsWev0foEXKyuCiHjLuR5O2zMqzzqhu4Q7pscUFjE5TmndapHSeNhNDFaVxaBXhLkMknlwegUAVYbHMcmHrPx9VsEVgAE4dxdYB138V4vw0z5i/kimXUXDq0UBHIeyAzDIZhdQzT0d9iMrMIhiic5ecVgq8Ji8gGr3ecL7Y2C3/YAy9mUNh/oKkM+AHU6EQsDFMHp5NeQKv7njS+sWgYQ
 34LmhMUF
 rOzdZr8GHI8yvJq7fq5vgv9g371uIM/8CGLAuxSy+PajJOnR3klM1MiSG7BKW5z3kVghv6RjRLwVFtrq7EUBw6DFXEwyMThWhkGRr4NoXGASQP9QgXyzw+1mQ887mwke6ZIQ7xvrdozIdHBaPnmKnfaeQ7Gq/gUR9QPVOqbZXHQRROhaRnxMouALZAZMiI3kE20MxlyqJr1v+V/WGHlYBTNKUxdeeJL2AD4zMNxuDiqgxWZ3jWBr49rhVP19NISje2zo2hulI22x3KFm+CxOAeQWYEQfSmMhE1Ep1VAzD4FJ2lhxccwxTdUzwTCybrp5ApOURzq6mRKGNDoYjRgCpv021H80q+obhDltl0sGk8xj66G0jV4wHZWvaJbqKYlsu3gDps5RQhUjZjbAnMmSWc/QcAVMGZLl/ZMurY/bqelYBdh0aZ71ln/qekmP+9ooET1w2w89gUb8r2KmfeqOMB/SWGRCIkQ9Sl4mz0IqnL9LS1Dn+f5hfa4nYsBMwHow4e0ecbcWV89gaiVFzYq31R8qMTcl/sXcfOsIZWw6wq7RRekia8Avdr7+1thfcK+4nHuYhDpUbUOx9cTeQQf64ON6YQg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that we have already checked for unsupported flags, we can use the
helper function to set the necessary gfp flags for the large order
allocation optimization.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 mm/vmalloc.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index c0876ccf3447..6a3ee36d77c5 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3634,10 +3634,8 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 	unsigned int max_attempt_order = MAX_PAGE_ORDER;
 	struct page *page;
 	int i;
-	gfp_t large_gfp = (gfp &
-		~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL | __GFP_COMP))
-		| __GFP_NOWARN;
 	unsigned int large_order = ilog2(nr_remaining);
+	gfp_t large_gfp = vmalloc_gfp_adjust(gfp, large_order) & ~__GFP_DIRECT_RECLAIM;
 
 	large_order = min(max_attempt_order, large_order);
 
-- 
2.51.1


