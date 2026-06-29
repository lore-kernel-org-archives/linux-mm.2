Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CD4AC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 16:38:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92B3D6B012C; Mon, 29 Jun 2026 12:38:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88CE56B012E; Mon, 29 Jun 2026 12:38:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A45D6B0130; Mon, 29 Jun 2026 12:38:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 41B806B012C
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:38:26 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BA5E08B436
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:38:25 +0000 (UTC)
X-FDA: 84933508170.10.45DAF74
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0647A100010
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:38:23 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dxS4NUWs;
	spf=pass (imf05.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782751104;
	b=3XOtu9MG7IutflboLzNBz1L0FjiS5GSVQw+bOUcITV4hXBnoNrCYC/PhKseXSbRU8K/a3N
	3RxhXQDy8r92nLWc7DDfNu2JXYXgCmOSXzDbqhQLf6KlO72hl+IqIp9j5wNjzgIELeVUec
	ygnFggw78FFSO7JORzucXa3lRjZptGw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782751104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rOFTBMMTbyd+uFN7Y0FcTh5M4MANHeKRdkzp7z4esAc=;
	b=kBrtyWBB7Dz72xMx3DGvgz3nlCrZ4f7XrCwL5VGq5i3lLUQ2TQMZ6tiy0SR7eAtjdQs/sX
	jBb/NuPQ3Q3EKZ0DEzoRAwEaAE1MuGmYEiZxAAYNf+CVQ78K59WcPTFLnJo2EYN4O8mQGQ
	no+o6gXpVCYk1a1T3q1ojx9Rm88aEkA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dxS4NUWs;
	spf=pass (imf05.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-84347ad88edso2962135b3a.1
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782751103; x=1783355903; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rOFTBMMTbyd+uFN7Y0FcTh5M4MANHeKRdkzp7z4esAc=;
        b=dxS4NUWsLZrIm+/PuDasRCIhgi+DCnHeVh8S2HCYWQEhK4MSv/O4UvPCSNPHgm1z2a
         qaL5k90UkW+00HuwWPZiWAAwHW+acPwWwqFQgSOp5rungZZMn4FfPpLv+66PHin5lZxJ
         fo5grIdcC4A4ch5cj+el3Zlx41dPYa45CuXyqzLJpvByIZtpLHawPEqA6qF1/6jIZgIW
         M+s7+vsoKeoUyQGj4KRU9wIMOgxiJUkEpMGCwo3A+BBI7u2xI/+oiIdy445IYkQ1hK/M
         QtGVXdHkLnqIJ0Xj8z9QDaJV7sACG4BjexZ72bH6/cuIS/iDricnN+7LKQp7OIb+XaKw
         e5Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782751103; x=1783355903;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rOFTBMMTbyd+uFN7Y0FcTh5M4MANHeKRdkzp7z4esAc=;
        b=PMOCg3pn8V/AQtPARXNszeJqVQ0ZaGuZDIkv+J0C/1/wq9zilXEXUE9SF0aZwjBjI8
         uaA6bMMK+ieRhrDI7a/Ta7anJQvPrbO+R/ZIE8h/AOYpVEnCY/hTZFWq4WtisQWhrkld
         ymgFBZrUhdvR8NxZ7o+rT+7DnLgHQotlmm0FbjKcuRjlgoRSkYNAvlEzdk+onzR6914i
         DWX0VrFcmXv8MOKrsrw8X91eOYW6YhfBo1UZT7riTs2/pO7tegB0KHf/QFR/JqeGD7EJ
         HJhKSokQ6NZN6JnrQulG1P0JtXJBGmXfKbEtXSY2vqNCncdi/Qphp5KAHahs0Igv/YKG
         T/fw==
X-Gm-Message-State: AOJu0Yx08BBJp3gy8fguuoSNrSf/rmbNSQus+61U0MNtF2XkMu5+OGFk
	a+Wff6wgNxQAJRtAelKaBFNi49dEppMc8WzXjL3607iqpGIC9j/fZCIT
X-Gm-Gg: AfdE7cmY3Jb6t88x9Sk82xA8hSxm1bTjEEgJ9qrbnyhnEKVeKIXjTp4o5tIhjb3gQuS
	+crp/T5zklkodbf/R4xceQAbaN6MomgjPd7ExAqJ0Ji/H0AJOleJaWBNPh/jEAu2zRT7RzGhwfC
	4qxlGAWQNlqJbJrySE8GBc7haZFujSRJ6lDTuHyDyD0p/zsMNbtWhL9/o9wb40QsWPALlaanGUG
	MS0P1QvaPYjN3b8ytoIdv1SWPd1ntyVVvznJYTXSVLjgVfkcJsEIOCyQGEqAw7YmcQSUtAGXe/y
	r4FfHq7OX+cvEjIKVsAeQZsIVSXrpercjEXK4t3Jnjz8wvnBV03N8XU7rjj5kd/ykPQo2CrFEa/
	XAAt0e2rOlSGAn34pjQHBLiFw7IVi5XTocvXxM6tPJMW1TstqM5ho9QOvtZM9mW62y7ym29rgkZ
	fPbRDVpwg=
X-Received: by 2002:a05:6a00:438b:b0:845:e432:e93 with SMTP id d2e1a72fcca58-8479f283236mr184928b3a.48.1782751102978;
        Mon, 29 Jun 2026 09:38:22 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847a02d41c0sm18474b3a.33.2026.06.29.09.38.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 09:38:22 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: rppt@kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 7/8] mm: remove unnecessary empty range check in early_calculate_totalpages()
Date: Tue, 30 Jun 2026 01:37:35 +0900
Message-ID: <20260629163736.1606688-8-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260629163736.1606688-1-ekffu200098@gmail.com>
References: <20260629163736.1606688-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: c5fhj8787y1wha4boccapj9msf7biipg
X-Rspamd-Queue-Id: 0647A100010
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782751103-82411
X-HE-Meta: U2FsdGVkX18tnOIE5fFZVKymzN/vEeuZlLj40HOgJLR/gX0oA4gwW1wsaL8FgworCCavGiNgketRgLQerEQ7xAG4iqSKKL7FSpejRH8sX86AQtE3Rp7UOa2lawTsKwQaThNe1FW2kEFLwfzA1QUwaVj9llaAJwQ8Fax9xe8JVoNjAMTP3Nz/y8O3EXv0MDaYbCWJEpFSOAyNZdpagaotnwUzup3WzRug5xpYkQlQ7/IafhRJatWRk+7uXwIJ3JDYklWdEI9nnggt0qh8v60dXpNcXPMxWwxRu8Ty1tcmprzerWaWGafc/EXlR/nnPJp9bZcrHpI34F33BnFDClNUx3Q2TgqAuhjuxA6N/uAbEJjK8OsKq0gVFKBEMxSSQlnHrW6ixzZ0aQDI4xOtN3NX0ydN5cVQuf2/y45T9m4vyPcxlVLSx779ihO7FtG7/xVKkddfKSC/myl6yuGl8SIhnX0NV+OwCpxTT4iPGmIr15TlAMYz/xcVBdwVZAmeFDHage5NxvQJzk16q0+tRQp7c4rgPEnq3G1Ar747DT7acujpOX35qGKUse6fcKDLxo3XqPh7ZYdVKqqFVgNFDe7+bFJReZDGLdl/TCIy7HwcGadh/8dTRSEVu0sIzXqVWHdYkY/riWIAR8vjBO4o4r1V9P92SZOkecMGlz0El5bqEmCklqSwRUNm9lTjEUVb7765moeC+WM5MQjyiSJ/dMW51n2BA+17EXB3oJoDczMlmyj5/s71n0kMC0bAe5B6Z5qn255mBCF6Vhs5/7qAXYUmdqCIR3b7xNkvM2ChO4Vdrc5hMWSTNuNdsY8yw/seczWV2p5asiIs/PhNMX45dw50uiL9dOBFdGspwM17bFwC5UHVNy2IddsjPDI9Og7RpPGxBiyPTnUe54LTBpUIsAU8sxEVQZKrrhRHk1y9PJP3PHvdLs4cmnwcgNICurQVk7iAIhHX9ePAkICb3lYlc+t
 FdT9e3zo
 YdAFTnqptN4s7Pf9EBNoljCmcsaZeTOaQ97F7UmClZRcHWeityG/6DI1JAwjsZtbKihzOmtJm6M0MQ+I5lgj8cUxbqbigbrUxwDZB4dW6e9VvZ+SvqDEnNGxJo0lHbrSBdVix4Bh3WJvj7C7BLFtvwueSEdWzxHAm34TLVXo2gdxMA2hKDn1/XU7P1UfPSlNUmOpTkkbFHW1Cypc6Ytgv0WmlUlkKaQ5R8EiHpRjyM+oBvVjNjU9ue7xlZoecSZ2feH2Ql5ZjSp1oiS7eALag99o8UZIY8l8AxbQq6umpxwEx318DMoQ3KVXV7+E80VqwKzVLWXD4rNZ+PQ+PlwlYxtXRDMoE00dM3hhI5reMzlFnwS/u1p6WWfEE2SrsZ0uBU6pZLcXQ9qdpYgyAk/M55PL5o9th5lcjFUQJodLY3QGsJjwLyr5vVvgkBRGxABz73mOQpdc8CN0tVyRjfM4+XDi7xIs3jTfETSoQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

early_calculate_totalpages() iterates the memory ranges with
for_each_mem_pfn_range() and calls node_set_state(nid, N_MEMORY) only when
end_pfn - start_pfn is non-zero. for_each_mem_pfn_range() never returns an
empty range, so start_pfn < end_pfn always.

Therefore the check is unnecessary, so remove it.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/mm_init.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 0f64909e8d20..17498a13eb99 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -332,8 +332,7 @@ static unsigned long __init early_calculate_totalpages(void)
 		unsigned long pages = end_pfn - start_pfn;
 
 		totalpages += pages;
-		if (pages)
-			node_set_state(nid, N_MEMORY);
+		node_set_state(nid, N_MEMORY);
 	}
 	return totalpages;
 }
-- 
2.43.0


