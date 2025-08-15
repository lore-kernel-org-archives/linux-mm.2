Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12FCFCA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 08:50:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D14278E01DF; Fri, 15 Aug 2025 04:50:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC4318E0002; Fri, 15 Aug 2025 04:50:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB3468E01DF; Fri, 15 Aug 2025 04:50:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A500C8E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 04:50:00 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5AED6C08D3
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:50:00 +0000 (UTC)
X-FDA: 83778369360.30.0CD0E09
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf11.hostedemail.com (Postfix) with ESMTP id 909E440006
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:49:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WreTsYT+;
	spf=pass (imf11.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755247798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=eHQLohzqd1J9nxeI58BgHsBYqZgOdkDJsovsL+xaQIg=;
	b=ZxK8BJJvyb/+XWkeCnA8WcJnNaFrt6smLY8sUDm7pQlyF7yiPNN0EzJEhCKvpxKs+hJjlG
	ET8QwR1mIUWQWT/otNEZf70BI3MoeLzQMTz5Ii9wlidBL+Tl4DLtf1VchOFHPEcKgQkf9c
	5Ix3ceJnmM6XHABX4Wpd1U7YN4/DlUY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WreTsYT+;
	spf=pass (imf11.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755247798; a=rsa-sha256;
	cv=none;
	b=4Xw1hxaRrvDhI9XQbY3QK2Ug0Py+a+GMeTtKiipOpl7lL5WslGRn8XSnOml4Cq5SoLb/GR
	Jf8Zhq8iIQH3lfzn1x7xtlZ7BiC+M/gk7kJjjtlMmPDs4CNfjbNG1XPSMcUwmHn5ER/vME
	T7IVDlZ6/HtffufYVsbND3GZrDlKhv0=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6188b72b7caso2087240a12.2
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 01:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755247797; x=1755852597; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=eHQLohzqd1J9nxeI58BgHsBYqZgOdkDJsovsL+xaQIg=;
        b=WreTsYT+FFbNI5huH/q2KNT95aWDmefyy+oD8fETaflqoicp9TpPBcw3h8lIVRK5Mk
         zAGLeXADbunMOVMF/GGvyQTmB5HlJPn7xa852nPNCHjdfoNT6QwmEA6WTh7AaUqVEdcf
         aQIEMC45ewzpXzcp4FbOcV9hLUP6RxOMSfiX2xt6BqidIXH4OeQp4wjXHyv2ursQgtSr
         5hhNAXMqPPER2L+trsf6Lpi1Ai/qYkTexbO3RUNh/y8pZ8vlLwcJ/57uBt9nCp5Mt66T
         r8JvaLHNyt9kKEdSPiavjShRiHX1rG/QQtThvyb/UJLNmRGlCB9mqoYjJXI+fxNZoC3K
         kf8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755247797; x=1755852597;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eHQLohzqd1J9nxeI58BgHsBYqZgOdkDJsovsL+xaQIg=;
        b=V1nGedetLBA4knH8Q3Jplbij8etk3X3he9lak8f2g95NPT8pjir+aLGGK45ML8d/0H
         Q6k4rcW84RCHU3mEDwCYXD+bfr236YDeZE7JlP7i7X2dGmQBqFcj18KUx5biVOljGggh
         AOTj3Lc0US94teExg/aOb1QKbhQD2C+jkVQ20hp0RKB+xB2qUeIe5ATj/4ZJOVakhNGA
         oGwoVYehjKLe4qfdsdxZsjfDt3eyJTpKiAR4Cpcxi9NquLpPv+zqxBM4PgZdADPIDpOt
         2Ltgx0n2pLetR+iDHRenEZJ/io54eZaF6VL1ZyTXlTtD+3WfiaS3tLoXawvmI37I9KKk
         HjUg==
X-Gm-Message-State: AOJu0Yyke0oEv7CoOF8YMRUDqtuwixNBovLULuWf1l4h9tlbZlVPS5jQ
	TFiFATFIyaPTZZiqgD7YVheR0NPKVyVi0oXpcEoPN0DUGn+KnGqkmBLC
X-Gm-Gg: ASbGncus+mkovTYw09s4beZA+yuC1QDQy6FQ6LS5jAo7kbeVsb0DUlRoNPRhy1ZVOsy
	7LNFzWgGFs+BdOOrO7li12NSwjVV4gKQf7sy13yf7p8VFNYPBVUO8tVT4GIEyrJuvmfdSrYHhzI
	AoVPkiVboSWj8kCWrk/OkDcCTkhFPgz423WPvKfpltv3PgVZowrzxM7a+suVHjYcdW21ZxmKJh+
	RdDrx19qjnWMOKI9HA+87ktiFSB98QOTV01N19wNex8lfwsiSkakchvqhI8J2p72Q6zJPYwQT8S
	RefFH4u4x1BxV4vkUIx48CmB2tSXQ3RliqclLComZvGWB7bHuPAhhwvUgk1y/lWsjibmcrvZ/bO
	rIowI3Jrg3HpfpiW3O4ifTQ==
X-Google-Smtp-Source: AGHT+IHdZcGz2PpV7id9SyfQ2WY0E+wY0bTmp8Pu/Osn6F97d8fUTJH4YF+cI6MbmO84Ulcq/swxMw==
X-Received: by 2002:a17:906:6a0f:b0:ad8:85df:865b with SMTP id a640c23a62f3a-afcdc288daemr109083566b.33.1755247796774;
        Fri, 15 Aug 2025 01:49:56 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afcdce72defsm97359366b.47.2025.08.15.01.49.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 15 Aug 2025 01:49:56 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	riel@surriel.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	harry.yoo@oracle.com
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [PATCH 1/3] mm/rmap: not necessary to mask off FOLIO_PAGES_MAPPED
Date: Fri, 15 Aug 2025 08:49:41 +0000
Message-Id: <20250815084943.23063-2-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20250815084943.23063-1-richard.weiyang@gmail.com>
References: <20250815084943.23063-1-richard.weiyang@gmail.com>
X-Stat-Signature: idow3ds31i7sohy339r45a9z7y5k9eg3
X-Rspam-User: 
X-Rspamd-Queue-Id: 909E440006
X-Rspamd-Server: rspam01
X-HE-Tag: 1755247798-188125
X-HE-Meta: U2FsdGVkX1/2GU86BgHCD3lLveWxtXW27T0XASMCYj6oFn1blHQwYQxry8dFxetuLr2B8vF622dCCkVR/ffPDNYhCWBD5GaFDK4d5sM/hdGTLR+fk+Y5p1htZnj0Yvme3yKWdvMbOdNU/BLUVN5Q1WD2wX9EoCLc0R2Z3WcDZz2uzQ5nZuZyM+G4ARVj9ZjyQe6GgbVZxUVuGIkum5iycD0rTW/e3A0+vAHwBKkRupKeNkbutMbKkeOjSVlRXczjgRg8rBbbkrc7MD1q0hY0hj/SlBpz83Qt6aAsTUAFB0TFUcQcFAtMkAKk4mWopKgs/HfyWUSSSbHBg2+RdekN41NpNjZjKg6O+v2lbbBpOXWeFQcIDp58SZn2/GyMC7XQYBdQfLiUdcsbcDXXcuVfahkPv4jce0vFjcGfvnNWknpTnoiAPSd2ygu25fdwvu05ayLaiP647NVj72/U5X3XTcjGIqTA2628PolM03dPJSAmNuGOX27Aksale+KcYRluFNo7YvahtoCveWo55ABn2NT+et4wQhj/Fivm2GOBKywTqz29b0NN5HTND4Em+Uq+9Un7REyLcyVSnyWTmDglFVLqIvV8woQO9m2u3kERZbir7xzCX0hWILSLZrMYNg0PRf/BCGapRACH19OOgrxjVAoIqzw9ozLzKhWKnmQe3ohDSg9LLJh0R0pLqrzdsMQIltUpy4ykQAjujTwS6K1euAulE4Rs9hAskGUVu1YPHPSaO+njFKUONTJkHdV73kukxoKDoxZhK/MvK4Jgc5YTMxxsU9UbKNRVr0nCuVrIJydhX5Pq0MxA8fTlI8SlRakJ+egl/4eCl85/68+5lzspLs/eV6LUktjOCis2BeJEpnrbTS19l2Jnx9/6cPvGWku5QIL5OUTGnpuD4dzMGBYiOYj5SRdVpZvdFLWWApMqNWtyAEKZctLZuL7d0J9Vnc+iEknqnFkENOpyYq7vMei
 OqN9wTgM
 1f87DeHOUGo3xEhMROXQteVwaDGSDFkTW3lf4Q9jYjw3/HqF+xr65Kg7Y3Dpa+72/sEmxIjuP39s8lcKQYJpsjkK3xgHgd7UhGcDeI7NVz0wXrhz+tJh5lnOF0T3e1HTuv6LyF+SMDBFemM63uhFoG+9NVO8mdjEKE1dqthrzN2d1hzoL8INH3LXA/BvU6L88qcnvh+MHkPuR6FI5yE72Jv0Citt5DzqictIizdkLJ/jDV2EsebcQAuXdDA48XTs058ENkyGJKoks0x9zyxgycwAU5K3k6Zc8gzcvlVk2ouEOZKtei9jIPHA+R44o0Hz3CZZfr31tpqEE8iyTwrECt9Ig/ndI+DVHTpPwqjiUmBJBcvutnnWJWYcxzagoGT/3Z5qgYZsDfb2Kh2upmZT0NGBjVJ5dExApenhP08igyBEa4PbO3sEtMy8IcOEvQSW7FegH5AILamLcdbPb0nuE1ms0UnyxdBOE6WSk8V16C0+GACTDAUJ3bBqsfcy/jpeeZN+00PwCApjAuVTTgTpVTzC/xOUrxCFmAEXX0w07LlnRBe0BUjUiwgkOzR76KSyov2WKxGphQvKNGocXeQg/yjqSAF8h1EzvvqBta3jusCdRpEE67lx3JheRBHuFUGRqkS+f
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

At this point, we are sure (nr < ENTIRELY_MAPPED). This means the upper
bits are already cleared.

Not necessary to mask off it.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>
---
 mm/rmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 1c5988dbd1e7..a927437a56c2 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1749,7 +1749,7 @@ static __always_inline void __folio_remove_rmap(struct folio *folio,
 				nr_pages = folio_large_nr_pages(folio);
 				if (level == PGTABLE_LEVEL_PMD)
 					nr_pmdmapped = nr_pages;
-				nr = nr_pages - (nr & FOLIO_PAGES_MAPPED);
+				nr = nr_pages - nr;
 				/* Raced ahead of another remove and an add? */
 				if (unlikely(nr < 0))
 					nr = 0;
-- 
2.34.1


