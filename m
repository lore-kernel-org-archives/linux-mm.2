Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AF99CCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 06:44:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4EE98E0005; Wed, 15 Oct 2025 02:44:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B268A8E0002; Wed, 15 Oct 2025 02:44:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A63708E0005; Wed, 15 Oct 2025 02:44:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 96A168E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 02:44:20 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 46A24888F1
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 06:44:20 +0000 (UTC)
X-FDA: 83999409480.17.1107BBD
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf12.hostedemail.com (Postfix) with ESMTP id 751324000A
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 06:44:18 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Q4edzjdq;
	spf=pass (imf12.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760510658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1h2ZB5tEfXNExzSYRgqaGZiEFO4eGNTSW8hgQwq0KJE=;
	b=rmsqKqhXkGjyPaImaunZMaDiAfuwatkhr2+NI4x3oe4C9Iijb4ssV1Int0Cq5Ju1EkebVA
	7Uk4jKyL74+caiSrU+v133Csb1oZQX+7YSWk9mXG8D6fzCiNQ0gZTVcEiWlbO89ENQOCgs
	5FGZf4DqXgF8XF5BFyTv0h67ydHHPU8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760510658; a=rsa-sha256;
	cv=none;
	b=CjzcN1wb4UMSqOKJfMIeUBdmjbIV8ofQ5jIX/ApDZUy4k/JUCjaJ1egZXL5829g2OASJWG
	1lzzzlH3ODna3BCpt8o1dOJ3WXI8x8PlQwlUSS6b0c3Zuf957l7HUPn5dXBLGvd3ZFF0G5
	byTHGfnXvqmFl0DYgtWDQ1zyYRq952o=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Q4edzjdq;
	spf=pass (imf12.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-27c369f8986so56762775ad.3
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 23:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760510657; x=1761115457; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1h2ZB5tEfXNExzSYRgqaGZiEFO4eGNTSW8hgQwq0KJE=;
        b=Q4edzjdquk8hjjxr6X0+ompd09vgcD1NI91riHqPfMbpOOu8OUSqBX5iGPjqSW3Fgx
         4rlgQ6dIDLeTwGua/wEPfqO4kXDXY0lR/ZhLOd73yvIcppwY7Z058myRIKxb6vP3C8tQ
         XLaefOwPT5u/JqhnedjCRyecRIqoYRKABlYzs+LKSn/D4gJCQSwfi4pkbyppt/Yxu+qY
         RytuDLY9k4H7WYFwOQpe8kcCwYf+DY4UiMbPQSmqIXDE5REjJomt4LxiC4076AgXkNDA
         6+lyE2pZ/hGuELmcLV4WG1MX5077eskzbux9Nfi4kLdOEJR+Yw5RxAyh9tSjwfJKNMCe
         x2kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760510657; x=1761115457;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1h2ZB5tEfXNExzSYRgqaGZiEFO4eGNTSW8hgQwq0KJE=;
        b=X+52k6Plzxz3aNLzmzaJpoNr6UbwHw63n5kEve6iVSb8ImpJcL+4Asq0ia9y9q42Vd
         THpnb5ePWlCCLf6CJAkpdREJtFLRZ5BrQaBnvFe0X3pDhuM50V+/6ukUuHUHfmIACQ7e
         lAJ2qRc7kYQbkUJNgSkqPHZN9V9mi5iL039pD6lQlVwwfW9Ck4EstOpXVVIhK1qApKmA
         JS0ntgCU7b13Zlzx7SGXxFMTdZdB5iuAUC22640DTcS314YD3z6BkGheGkAPEGTYzTSN
         pMRffv6ixQfgdw67LrYPpasgpakEusTTod2w8tlP7a/760QDZEzaMDCBfu3+BLy/NAzX
         4kLQ==
X-Forwarded-Encrypted: i=1; AJvYcCXS4sKKmeEjM9jbot4xClkkkMjOg4sdvY1zY0FhYH+Jc8TxWe76UmWT6yCTl8AM7Su+m6NtaMiuCw==@kvack.org
X-Gm-Message-State: AOJu0Yxsf81op9SRSLfTKCuAXzKB1dUO2CjUTC3+8ITnmwZhIb6L1Fyg
	5m37Gqkc0GgeoGxMib7E03spMvhcA7wQgxgYUg+qrQghAFgWVLaHfyH4
X-Gm-Gg: ASbGncteJlhTfTm/6Hu3ZoVlX9W0yJaiHE3DiCzdlVjVXBHPkDVGWYxP1RQ/38mvvtq
	JfqmBIYxzyUWMUziea7259lFnO4aZzXaMn+HdHKSBHAUbmqV11kH75DiGrSQrPPQMEAl0heA0it
	jc96+KUVS6rSiKBj/PxkAyaHmD47q3Xd7iyZT5pXCDxC+Q4luiCiGm+acBIi/qXoDJz0Mtdur5P
	YzM3gG40+vrEwxU7q/fcg9q28PF6WIe8N48cIOZ0THZh0MPJqp4sBkwIHAHkWVzfBmC1w3jquMs
	YGN8rnZtjkl5wUaUzTMeEe+53LSAPuDG4le0uW/WgrC75iPzgw22rBgJ3efcZxW8vK3othrMkzz
	x3+i6pIj0RKbmX4szz5ssVoUtv/1xYtc3VieqDkXfYLjOkApDrzLJkWM3jqP2AHb1+LbutpFpNS
	B36E/3WQ5a4z16a6f2+cgoqbaLzA==
X-Google-Smtp-Source: AGHT+IFo4GkQAR4kQ8Q0IeCrlZ57EjWWcL/UzLVqG910m/3rZAgcNeInZAE64rrfXWrRydS69ZNpxw==
X-Received: by 2002:a17:903:1b64:b0:28b:4ca5:d522 with SMTP id d9443c01a7336-290273ecb07mr350160565ad.39.1760510657134;
        Tue, 14 Oct 2025 23:44:17 -0700 (PDT)
Received: from localhost.localdomain ([2409:8900:1896:1396:e40a:cbdc:d4a4:cc3a])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034e44ef9sm183712015ad.52.2025.10.14.23.43.57
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 14 Oct 2025 23:44:16 -0700 (PDT)
From: wang lian <lianux.mm@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Rik van Riel <riel@redhat.com>,
	Wei Yang <richard.weiyang@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	wang lian <lianux.mm@gmail.com>
Subject: [PATCH] mm/khugepaged: fix comment for default scan sleep duration
Date: Wed, 15 Oct 2025 14:43:33 +0800
Message-ID: <20251015064333.31274-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: ym3m4hy5epa6175ep9rf4npottpdhr7t
X-Rspam-User: 
X-Rspamd-Queue-Id: 751324000A
X-HE-Tag: 1760510658-820010
X-HE-Meta: U2FsdGVkX199sBTo6thhJdisB4l3zjnhxSpTershbzfHZMMFu5BUFbuo+zo99VPzVtxs1tQq5at+IFmEp1JQvNX9yQBizMe44g2Cw99uA+OLprOVo/1v1t48Vserkd7zxXXk93zVGk+MRRMLdpkL7bs4KU363EaqzGyQbmAx/kqIutT9UJu08BtUArlKg4CgTukaGtPp9JowrrBC1SF/DgNuTJ1AEjEohnxSexcWdnBLPJnxBv1cenkPppEf5aeC6uhdiSJuyNEb22+baXq+/NZtm+SdN1jHnTaA39xNh7QsOJDWUCZfVU13IZ+95O1Lv9w9EoUjBTe5fPdk/bqqhrt3hsYabLEymF+YdUAmQJsz5WYShu06r4NR6UvyUK0UV17I3pNJuasYNk74+oLLf/4aQ8fYtFGZ6RM1rjueS4c64a06xvh9GfCNvrYgcsreRSK2flCGGjzLYDiiYN2lDizHQYNAfMtUkUILrLjK53dJXbKVuZ3tJqpF60cVfCyezXo5J5QorxTQx0diHyhrT3oArwoOmE9orj35bOWxkurqvu6MArHJKQXzOttXpmcMjm/R4z1DX10OCEN/ETl128BhJ0swcct7kU/87+mNQ7DzIXvISSalpyR3VRc358EimBKsWsCqY1UlbYPz6blhKdkjt+Mtb8UajPI0bM9zIKpmZhzYiO/ZlWVgGPw3rJYeeNN234qN2+YNhfgz7uAb6Z7dLFmKKlXLNZN96exyZlngAntkRs/nlpizb8hdrnlLMXUdOjYgNusC5VlCd7CTpg+macQU+iZWDGrmJ1Dtn9VWH/I4Q+4MfH6qF4vQseGu4nm9plNbq9Flhkt6XZoe37AC8T+xT+MpzWz7YrJ9lUp0vxY05FPYg9ntwljJ3GjsM8FxCAcYhURwyn/AY4szAvc4SygqSQw3m0i+M0YGJbe/5Wo8QX8u4H8xLITE8nBipLY2o30lZ+JYacfnkUQ
 AalwNnui
 xBSEyeHs7H71gTGWbHkSOJrV5H9ohNl7ldxVzg7n725We8fOvoHfdM/d4AfceJTB02BCt97WL4A7w2N22Gc/om2NGF5LzKLn6E2tdyjGj737MHnnGC+92L8jnhpSohNE0ayw6sfBViWvFeabeaHkSHxHwY1ZYg0BuNTl7H0OgTEIBhCPYM3o5i3zjR+48R5xpvwJ5m2w80uUCUVgkAcX6RNpnLqxsFA+GzLSoq5gOR4X7ZZe6094b9x7uqUDBe/Wg+eqVk6XmbJw7VISifkEkSUZP/UdafuDAMl+hmSfspmKxYNg/zOw7X63kc+TGtQUAg0U6pCgT6jar7bYxCJSqjwMmNF1fcYbjrhyoHwrlz+usm1CgvVe8JcrO2PJwiBkFOh7VZ2WaSXO8yws+Mra/z5GV2nEiL0nx8cqjCb55TyViEffI+0UwkMkeXXRDq2mZ7hcTEj+IlSBP5x7zL17f+4WOHlW0c7E+NFWvgzVupkna5NA0U4uPZNpDSoXalg9HsWQgTNz+wAoiDl4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The comment for khugepaged_scan_sleep_millisecs incorrectly states
the default scan period is 30 seconds. The actual default value in the
code is 10000ms (10 seconds).

This patch corrects the comment to match the code, preventing potential
confusion. The incorrect comment has existed since the feature was
first introduced.

Fixes: ba76149f47d8 ("thp: khugepaged")
Signed-off-by: wang lian <lianux.mm@gmail.com>
---
 mm/khugepaged.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index e947b96e1443..449f983b8891 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -67,7 +67,7 @@ enum scan_result {
 static struct task_struct *khugepaged_thread __read_mostly;
 static DEFINE_MUTEX(khugepaged_mutex);
 
-/* default scan 8*512 pte (or vmas) every 30 second */
+/* default scan 8*512 pte (or vmas) every 10 second */
 static unsigned int khugepaged_pages_to_scan __read_mostly;
 static unsigned int khugepaged_pages_collapsed;
 static unsigned int khugepaged_full_scans;
-- 
2.50.1 (Apple Git-155)


