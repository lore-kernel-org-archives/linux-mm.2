Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B18D7CA0FF0
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 02:15:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8B938E0116; Tue, 26 Aug 2025 22:15:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E632B8E0105; Tue, 26 Aug 2025 22:15:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2A998E0116; Tue, 26 Aug 2025 22:15:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B815C8E0105
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 22:15:29 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 814951A0410
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 02:15:29 +0000 (UTC)
X-FDA: 83820920778.21.4C71406
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf01.hostedemail.com (Postfix) with ESMTP id BD93940007
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 02:15:27 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="bxDqgoY/";
	spf=pass (imf01.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756260927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=i9yGig0Idr2fpe7UYWg3D0zUqXiTMpFVh0D7qgxLxlQ=;
	b=aML4TzH6SkMQ+QVB1hfoX39jyyIkEg6fHapPKt8XDwvLboa3iZhxDI0xPUzMpqE8JU3Wpc
	U75B3uTnR7bgIid9MLXvSW08mteX2ScRpIikXlMnPs7TqsGtzHvYj4sT9B/cbwcReUID3C
	H9elJ7qB9tDmdMk2x5tS3sDQIMKWRnI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="bxDqgoY/";
	spf=pass (imf01.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756260927; a=rsa-sha256;
	cv=none;
	b=5aXhyxTwgbZCgTFcLH0LzRsJvpHm1OHUDGuDWh1la7YbrXexT1dmJK+VKlWvRd7QlWBzZZ
	8laJfSY9b/Gvj7xqAAUxzafFcPQVy4GgkKyiUTGGjvMA6rsuFlH8zJ1Y3A1btHMLkgWGPo
	ikkm7W3KbeWIeqZWbzu59DPSycU1fbo=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6188b5ad4f0so8726786a12.0
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 19:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756260926; x=1756865726; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=i9yGig0Idr2fpe7UYWg3D0zUqXiTMpFVh0D7qgxLxlQ=;
        b=bxDqgoY/RwQAiC2n09hHNI921kDS8YFT9uBa96yRF56az1Hy45EE5M9WtKjOj9/Swq
         sS8G53xRKWdH6l8RUHMp+fpB1flp7bq+ebmj1TkzMD062i3QQcM7X40/kivJBJAd44OT
         +xci54a033+u1xXY9/lrAxAZjx5ubj6U03HNQutiLFs/tRRgHjw5BJRKjOatx2c+I4kq
         lEShMWPKjz6RjnBVEHBnMqOajGB8ayuAWhQGMJzAOWpLQ2ri5CCOoYIMZci66Pwtov9W
         9UUAOe3pt7/FySkKHBao/QC3zmjTPTqSBPaZHXDh1U3DLI7fh/tfiK6J4pEACfWIX2nm
         /d3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756260926; x=1756865726;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i9yGig0Idr2fpe7UYWg3D0zUqXiTMpFVh0D7qgxLxlQ=;
        b=hsbk79mYcHqvoHePLHpKsiv3wGdmWq/wdAsO++HaI9NmN53Ew1+yRO/A8tpEbaUXrX
         hPlPbfOoAl/NEtlLFx2K59mVb+gB3YFkLbZ2k6HkKaPLMdDYcTrp6V8iayQlalfgL8fm
         rmQoV4NR5VRco37q2LErMRYsBEf0pf0NwgD+9F7sE4rztE4RNZKo/LqYnpGix/IJdaw4
         TVDLdx+Gv7eacwgtlxMwAKKkZMZHNI6uVVRHRs+CTR4F4ynjZEZl5l2J6csgEE5HdRIF
         Ogy7fZQ6h4CytleaI5K/TUnTbI8BiR70rjizjjn7LWKHOrOsVKUfqml2aUaqOfrBfIVz
         +gIA==
X-Gm-Message-State: AOJu0YyKtcIMO1+xD8YVGkDWB3zcXcSd9kcwMGpt9yzdjkNnVDvRpJD9
	m5sywEvFIlujsDfwTKQrCrTx04so8sMVcp5+odPz2HsG5+qG1YAujakE
X-Gm-Gg: ASbGncu9e6CQf2PGLmROHTNaraVdKNFfxURk/GcA6CBAFcOXzwvr//ytwTQ36MKQ7A8
	XbNn2WwngN/tUW4MememwqcR2IM8IrVLJO6G97Tlpb9HQqT5BLRPRhEQWUHN9Zunm+2KTitHfQV
	MJxih2ykliVaVDN0EOXJRUGRjZ6ESgIrBCAXOe4XlsrkD62AvaFS9AFa/Kkd/f3IawIdPry1Xbj
	bnH9/ern6r2rrJoRtWs4wDybJmTMEn4FxqYwt+JBJCs+7dRYMFqbYKKeuQ7QTmqVNzhwo2+LGDP
	RB4I5n2BM7TM0Y8l0VQ1nl1gaKQ2oyvKR8izFDCgzDfCVZHiakSpS3kBDoEfEfFKNKBw+pFS2KZ
	ZJJZUE/isAzqfTF1wa6AtHSyA+Gg5jsHHIQXH
X-Google-Smtp-Source: AGHT+IG+kxqSZSQJHy7xDc/Y63pS9Yhru87Ye4QgwBd4Ru4iRABfoHWh5/0W5DEzRZuscLPqkri8ZQ==
X-Received: by 2002:a05:6402:3589:b0:61c:5e86:7a93 with SMTP id 4fb4d7f45d1cf-61c5e867fa2mr7167249a12.38.1756260926187;
        Tue, 26 Aug 2025 19:15:26 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61c316f4fc9sm7871788a12.34.2025.08.26.19.15.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 26 Aug 2025 19:15:25 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	vbabka@suse.cz
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [Patch v2 1/2] mm/page_alloc: use xxx_pageblock_isolate() for better reading
Date: Wed, 27 Aug 2025 02:11:20 +0000
Message-Id: <20250827021121.13645-2-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20250827021121.13645-1-richard.weiyang@gmail.com>
References: <20250827021121.13645-1-richard.weiyang@gmail.com>
X-Stat-Signature: exwtogwij5z3fnst66c4ahg858dh7aq6
X-Rspam-User: 
X-Rspamd-Queue-Id: BD93940007
X-Rspamd-Server: rspam01
X-HE-Tag: 1756260927-425931
X-HE-Meta: U2FsdGVkX1/TD9F4uuw+9RCb0LA2ijHU3lCZqmwLOy8fH9PJXKDYJ4QzvWfXK23zmWMtPYH8WB9vc269V9FDwkTtdh6CjP+ByUOSWJzhr153aG1SaaYWfm33RBp1OHNpOdUrJtxmMow3pfiM6xWBgE3uRQ9TNl9ZOnm77mgpnquKYnfHfzOgKkFFnH//54yPjpXFODP3iIv+2wGZ6GKE+5iNBIEZZStmZsz52kG+hyeV65tf4AxbUMpxykQsl8jTPVE7+ltKXfztHS5F419byq865dlzP4fnTxGwv+SNyxaUEsQWNL/CpJmGMALki1ZgQj9oWT4xNefIOvZqAYzSonAwKj2iqrEJkxiziFS5N2l7j+WwU5sTyLNwZMEhH4PRwBLNHbaT4FEOZjdcSnBm32PXgIoLdUVuKnQTonUR1V5MorkG84+/xuHv5tykcDBd3uKz4eGLgKIKtpLovXDLum0jvKSNazCLZ7S9TAep7afEYIQsNuyKuO6nv8lLz7lYx8fyyClCA+gWbIO+E/1BH53EVsBsmGuJ9HRvUgnUBJPhUv1kRpyAHIHFCV7Qbg9LP4nw2n7fTE4NHkf+/cQ8WjFACumcsdk9kEJUX0tFkIgGIQ3UPZ309JXbxVAB2AshV4YVkZxIk07KY/xB0F0xO4e9/5LMzGQfCv1LnTFKvz2LKpZqGdwF3R+GdSVPsFTr4HkcZ6FC2tfTOLcVDXTaO0qBZcMCV4fFUpQu20OKggrKPmwBirgzRGtRlJd3YEFTTP3NzhpLdy/UbUdJPpt/CzztyCFv+3EP+jpWJI7cUyebgidHXBNvvckl1b/a0oqC3KwzoQD8MHZV7dqVkFWFfFJAeH5wi1fiQ1T9LG/1qQlPpcTvS9c8d5aL/gN71vdAQavJie8fxp5EmbxdAUguVGqtVND2ugFIXwxzeT5AIATuOeKM+GJBSjI/RCRa3EZt76XyL0d6HGNtOIyavyx
 FW6Rckl5
 J8e/r/FR6DVP7zvTqnlfc03BlTdL+7k824IYlCe+o99ZBSU6WCHt30+WNZ6H0poGfWSw4eRhUpEsmVZb+wRew/q1Pf+x+TVPqakrSr78U4fP/2pZ8FTPfy8FdtTFZfoMFL6UuPALWb+ahFXprs93+npgPPcHeaFqHNCfZ4tL8N5t3oiw0LPHDLzzOzgl5DFsPsWbWtWdgxRDGusV+AjLy/Fcw6G1OyLssrOuRZ8eCWzjz7l/A8p+NIJJ1K5y3ISAP6oUzlLBRyPARdtlWyyClDbXmhHn/A6oh/JX5AM1arQzWcUQAfbrbPs7wWQ5YPMG5/oUsMgSYd9d7bsCKxKGTXE/7yVjYa0Smm/DsQMgDNEPxIie9pMt+5A5cWOEEd2LQP8YQPJZ0ZK8kd3rf0UM6BbSo2+P9ozur3Co1kIs56Nuu0zxKVchg/7qMO4v4HtKWF4Yp0MErrNqw+2KXKSnhktS0y1h6Wu9DSn5JCDEGVHt2WIYyjE3sv86spFpmvZ5EmMOAGchJ3K1Tw29meD8H7DCBaIwB7s9FASs9sJfhToIMUXCdPOoVyFqdOPBT7xDUrnznoDLF13E/mv6nmc+TNmOe81PIQDp9BbmrwFRbWBhhNERETV/GERfwuISi1MkLcwtaPLa1tblBbcYZK1cjYxeIew==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since commit e904bce2d9d4 ("mm/page_isolation: make page isolation a
standalone bit"), it provides dedicated helper to handle isolation.

Change to use these helpers to be better reading.

No functional change intended.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
---
 mm/page_alloc.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index baead29b3e67..e534f31a6b39 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -538,8 +538,7 @@ static void set_pageblock_migratetype(struct page *page,
 			"Use set_pageblock_isolate() for pageblock isolation");
 		return;
 	}
-	VM_WARN_ONCE(get_pfnblock_bit(page, page_to_pfn(page),
-				      PB_migrate_isolate),
+	VM_WARN_ONCE(get_pageblock_isolate(page),
 		     "Use clear_pageblock_isolate() to unisolate pageblock");
 	/* MIGRATETYPE_AND_ISO_MASK clears PB_migrate_isolate if it is set */
 #endif
@@ -2058,9 +2057,9 @@ static unsigned long find_large_buddy(unsigned long start_pfn)
 static inline void toggle_pageblock_isolate(struct page *page, bool isolate)
 {
 	if (isolate)
-		set_pfnblock_bit(page, page_to_pfn(page), PB_migrate_isolate);
+		set_pageblock_isolate(page);
 	else
-		clear_pfnblock_bit(page, page_to_pfn(page), PB_migrate_isolate);
+		clear_pageblock_isolate(page);
 }
 
 /**
-- 
2.34.1


