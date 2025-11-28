Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EE7FD116EA
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 07:02:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE4EB6B0008; Fri, 28 Nov 2025 02:02:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBCE56B0022; Fri, 28 Nov 2025 02:02:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD38D6B0023; Fri, 28 Nov 2025 02:02:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CA64F6B0008
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 02:02:26 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 62B8C1A045B
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 07:02:26 +0000 (UTC)
X-FDA: 84159122292.12.FD23CFB
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 754764000B
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 07:02:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FIWVS0iY;
	spf=pass (imf17.hostedemail.com: domain of chandna.sahil@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=chandna.sahil@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764313344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z6Dwan2VmZRzoqc+nruHJuXpjL9VPRxB9Hq3gVoV6ww=;
	b=j2shDHKQa8t1j0oZpoaJivADJsUHwlrkamsN7EjVx6egXYSMXtIrNV6SMl8GKTsLc96y9e
	xX+WiI4QwRb2NI9q0OvB22I967k1hTBnpPvf/SK9jtQd1ex6bK5VBngCa1c6EhS6QJy+mn
	wUrplrnw/Ir/UCdDsanot7xuS2F12mI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764313344; a=rsa-sha256;
	cv=none;
	b=X2d4wV9aiElDNqVbug+jgOiHrVzrjaWwS7xHh6M0noix7b6kIRj5SgZK0oXpdOlyc2onny
	G1Q5jPhbVvXYsuMnQeY9JBUTYWhDBticwg5ojSJkpjFzfPNw9++ubWimmKEAXkxl2uOJZb
	s61J4NkbeD0jSIi9GgDuc85E/2r1cAE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FIWVS0iY;
	spf=pass (imf17.hostedemail.com: domain of chandna.sahil@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=chandna.sahil@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7ad1cd0db3bso1272269b3a.1
        for <linux-mm@kvack.org>; Thu, 27 Nov 2025 23:02:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764313343; x=1764918143; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z6Dwan2VmZRzoqc+nruHJuXpjL9VPRxB9Hq3gVoV6ww=;
        b=FIWVS0iYV987/Pqr8b/KgTS8E/5h20wcEahHrUnhd1l53MZ7cn5hyfrRL+29qIGJTl
         iMEUvPASpQis5DQFJiX9owr/XxWg5BvouNuAes66sG+CowVkKPpruhALXutELagc8dQr
         FWKzUFgIa1gpwxEgMPSMWKzAPGt1EzJPPLqOfY89xZ3KR8UeWBKLX09udjEmD9v9Srm5
         wjZMFlaTNtNmZjsNu0PBsWvaCf8ly46Dq8e6AawVXF345ub7/GUwYCOo2k/jB2a4pPBI
         gXOwcMkaz5908g1FNgsAQq6NXELLKBLUe7lpzZESIuXR287XWrtsL9epkVADUIMMUZXQ
         0cgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764313343; x=1764918143;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=z6Dwan2VmZRzoqc+nruHJuXpjL9VPRxB9Hq3gVoV6ww=;
        b=MFPXB/lp/ZeORnMlVhrdvc5gV54zFUc+PlLWdWKLX+NnbA6/SmpXy99/W/3HWO/7qb
         jBGCCddgdBCzVVFY3PcwkFokU22fYrECheuIMdDhsTg9PS9raLiawsXHLNHRUFbMyTiL
         ukAud4ck7oM1aeinzx6/Yz6+etq96sfqTrYA4QS6oQMQdull4I6zakFFTMFyIlUYEejZ
         TgGIa1cds8/ApMLBhDbUrCyEagKSspCiGV6GLkpoRJbpqU+4ix6vo4FsvlO70rq7H4uL
         XH99katd1Kpj7SGEKCrOG4sKq0W9Nx8pQYV+DG1kO72hfPAntkLcQn4xk2Bs5UlzzFmu
         N25Q==
X-Forwarded-Encrypted: i=1; AJvYcCVYT5unzTBw6nFhYi34KWuQ/mysGowDoyJD0KsttqqPDIbhRcL1tEqTv5lKduPxBY7Um3dOo23qIA==@kvack.org
X-Gm-Message-State: AOJu0YxeRVlKDV4VCk54P7WOuThtzYqEnL3T1Ly0YAFd+pbvz+Ek6A+o
	UMxCltFO6Qnz2kQj+uDronaH8E4wGB4qvHxBPZkTUs+mKcTLdSmG2OYt
X-Gm-Gg: ASbGncthWAZpWzvmRwyZhdQCmlLamEg8z2ao6d6Ebn9gv7NH3MJ6cvDh8MIkGOvog/r
	aVIVym5CLpeHvr/Nhu8gV9BgUckfYzz76pCrYhSsHnuRIvNldb7CPlQeFZoANAueQtACdn2pte2
	b/vJzen1H1VksnaVi5chk5XxYTFuklI3L53tay2rO9TYFQszYmfNQqF74Iaf6B/tfmttimHjPGI
	gOq/FdA2kqf0eafdbZKXnpSIp3+mjWIjqFREUIglKeHmcZbOVkMQ/gxHli/zAXq/hkA0WK1+3rO
	Gs7OWN8XpLlHB3+Lrz3Ox+xSVVo77SxefPh7RX8jzzXnPnNjbfFn1iDS4voWKVtbVITEPv7olp+
	m0XaEIvZV2b77LpEbb+WO0tzpEP9rWDzpVXy+rRsOtCB9ljSq0hvf9sSccyRS4gNloVFYl+LciM
	JjYHY780JNkWRRD/nA+Rn5DDQ1ig==
X-Google-Smtp-Source: AGHT+IH+IQitqVj1j3CAw6jNknzr4zB8MMqZXg8hNjdTrBVT+rJukm/aBPWjiVm5HNUeP2S7B19X4Q==
X-Received: by 2002:a05:6a00:4f95:b0:7ab:6fdb:1d40 with SMTP id d2e1a72fcca58-7ca8740ef73mr14757832b3a.3.1764313343103;
        Thu, 27 Nov 2025 23:02:23 -0800 (PST)
Received: from chandna.localdomain ([106.222.232.43])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7d1516f6970sm3864693b3a.17.2025.11.27.23.02.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Nov 2025 23:02:22 -0800 (PST)
From: Sahil Chandna <chandna.sahil@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	zhengqi.arch@bytedance.com,
	Liam.Howlett@oracle.com,
	weixugc@google.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: david@kernel.org,
	Sahil Chandna <chandna.sahil@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	David Laight <david.laight.linux@gmail.com>
Subject: [PATCH v4 1/3] mm: pagewalk: simplify hugepage boundary calculation
Date: Fri, 28 Nov 2025 12:31:42 +0530
Message-ID: <35ab82f052d248c0047c10bf01853e37e4f9b4e4.1764312627.git.chandna.sahil@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1764312627.git.chandna.sahil@gmail.com>
References: <cover.1764312627.git.chandna.sahil@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 6778ia54fi6mktp181cj51q8q3zff4kf
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 754764000B
X-HE-Tag: 1764313344-901503
X-HE-Meta: U2FsdGVkX1/vWE/UmC8fCgu4jKWqZK9B5Q9z5795HkkefivTy/wQmNjGzb4//Tg9lMFibd526tT49SI736/xUvkZoLfOjnPqX5mfB1nR03a9gGBzrSPA8PhjwpSQnmgWmt+IQEnpwz2swwZ/LGPZL4ligtPFaIpFrW1cmISPdHkUjwkXa5z5h40t5ilVZ1t++ylBLhzqUqkgBhaxSkOQtBIdXr1O32MGoWhXEXbBYrqM9cWPDDIx8ifRaAX6XD4CREnjrKHsa5SqbsRiEzpbTf+aZfn/jMJZWZBstIBHpA1ElsEF9OvoIpoq/G4KNoyaU+mZhehOiarfgtPA1UP0U+sGbcbE1CxTezE8azgFLo5eKw7oAT9lAMHPaZoFI21F7hmWmhTgSKBm9Y9pF3QKllTeuNBtjkrcokvppun+JQ4WoTcLPM1VjeqPi0v2enZQoP2a9SZiEJcGxV2HnlM+husBsE25u54Wh+9dZHHrrtoLpNz+JMX9/s69lo94GV5HQfGUUhdYt+fS4khqZK3pNfSxcC9n1RxDvxHSwH1WpR42+LIKsJF/tcXV9KznCOEL2zfbpNlCpsCEPYD8rE1Hcel43Pad2UP7oDvPFqA5idc63m6CYBuqWz7dp1DO2QPzf3b5A95lyicec7bTAZJ/SK2IeAvx/TmVRwzhZFgvddD8jtRsG1Pksde87Tb17qNreinmEhtcbncqgR43atFjizWdX3+78ai7+HoVq7fIyYMyzdkRooEi9upvTRg+UgtYVxGgojWwWM4bf4j94w3ejUHsq7XRO5yMXH4sOpCsRjUq9KvfBlH1G7sobAyJTAAhlMTrhu34+kMlrVueaYaNND7FvgE8+w8qlZSV9Wg1zdyFlmrOLR+O+JXbBvZgrsw9EBgMci3n32KmLHtioXgsdE1IGdO1LOmDmV1P0w8DBop7Ww1PJN/EGXfwrEYGpuOKgn8VqTDhMFXWpQDmo+a
 fXq95fye
 N8suRg3UfgIkq9jl+AX8Y2UqxOj7JdWCpMHVX//mkS7KR0YuvgBrB4GnOVtwggMLZyiD2GBdZHNP3RDkid8HaHaCUJjZIz8UcadO4mYN0iGTfqq7NsjrRhxVj3DDsXNyJ3ZAcuf62N29pDdWcdyE6mJaFwH7hYUxoPkV9RI7qJLfF9a6mQ09ZzvHfK1fxPi2BpwZMtle3ZE0F0rDQr08XllmWqdu4aftc6an6brPBwEjK4BLw7R3Ghxns5AiKYrJIJ5cQQHmmbqFPiH29iberQMm2gNIb9Y4VKUAYDe2YRDZZtvikRRTqw6y9WBtFf9ruFF86PywBk8PFEvhn48KmtqHy1OJEXQhMFA8bH11mHv8sYwvBwy4kOc8llXsaVlF9tJ0eFCgmxeZ/m3PcOgSukQTKC1+cCyKQOV5eOf1wsyTNyRLqQlccZgwn5sphXnbgJZZ7EWPuX6eaZJbxGgAFaNEzS//eFtH8fkIVd9IYQFcFxSZvkoNHWGLbP9b1pyCex23MNrYzE4bMUMgOgqfVaL5aI/9nz+Qc3wh+wD5go2Hq7wAiO7zjVddzs5Rzuu7ol/7RUtzPYcED8F5fCcLAwORrCBrP6r77t4MG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace hugepage boundary computation with ALIGN() helper instead of
an open coded expression. This helps to improves code readability.

This was flagged by Coccinelle (misc/minmax.cocci) as an opportunity
to use min(), after which the boundary computation was updated following
review suggestions.

Found by: make coccicheck MODE=report M=mm/
No functional change intended.

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Suggested-by: David Laight <david.laight.linux@gmail.com>
Signed-off-by: Sahil Chandna <chandna.sahil@gmail.com>
---
 mm/pagewalk.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index 9f91cf85a5be..9fd59d517f37 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -312,8 +312,7 @@ static int walk_pgd_range(unsigned long addr, unsigned long end,
 static unsigned long hugetlb_entry_end(struct hstate *h, unsigned long addr,
 				       unsigned long end)
 {
-	unsigned long boundary = (addr & huge_page_mask(h)) + huge_page_size(h);
-	return boundary < end ? boundary : end;
+	return min(ALIGN(addr, huge_page_size(h)), end);
 }
 
 static int walk_hugetlb_range(unsigned long addr, unsigned long end,
-- 
2.50.1


