Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73FBCCAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 08:20:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC1B88E000C; Thu, 25 Sep 2025 04:20:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C98E08E0001; Thu, 25 Sep 2025 04:20:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B61068E000C; Thu, 25 Sep 2025 04:20:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A62C98E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 04:20:05 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5E223B90C3
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:20:05 +0000 (UTC)
X-FDA: 83927074770.22.575040F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3160B40009
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:20:02 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bPQqEnOQ;
	spf=pass (imf17.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758788403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dt/4W+oqi8hOmboeA6NMHOzDnnOSX/FWFcKdqFw6DIA=;
	b=HVkTFwFPgJ1ChbDBwjsaXXqUgYh9kpw8wnIxx+tlHQ+VxZs4qQd5jEsfDBHHAf9qlTAA49
	fenGq234315vByQRJX1Fjn2sxfkgNmzGBFcWGXd7t6SiSc0DJbIvUnoi1bC0ilHL9uxPL5
	hssmMRABuhqSWGDezqanJwAiBsquXYk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758788403; a=rsa-sha256;
	cv=none;
	b=fIBSKWD3nHNaNPQd6awzi6cd6ttrZaj0Afz7TkFlPiid9fK28U8mv0VjvMZjogfw/EmEoM
	8A++i1/iLLrWM0TUmIB7aLP+ZzGOEl9mgnToe/uxRRbVSKvZQ0khrfGkaSCDjsBu+fIRbl
	mVDOos3l59+0/PJ39xohwY3zJjdPmeA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bPQqEnOQ;
	spf=pass (imf17.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758788402;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dt/4W+oqi8hOmboeA6NMHOzDnnOSX/FWFcKdqFw6DIA=;
	b=bPQqEnOQc4W1+1lBEDMVTwjg/Owpdgt8qEnH8u4F0Hv1G1hC9Ki08XVdwBifvUcbHGDdW0
	U6cvZaUJvumPGzbT3ts0NclkxEZY73k5oOzQX8zBSwBhtMTRQkss98OFZIbjIjE8p3v71x
	G9+AzJPesTmoL/UBWbDKmfeM9Yj/JdQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-131-KgiPDppWNWWf2warNT6Ubg-1; Thu, 25 Sep 2025 04:20:00 -0400
X-MC-Unique: KgiPDppWNWWf2warNT6Ubg-1
X-Mimecast-MFC-AGG-ID: KgiPDppWNWWf2warNT6Ubg_1758788399
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3f7b5c27d41so310609f8f.0
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 01:20:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758788399; x=1759393199;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dt/4W+oqi8hOmboeA6NMHOzDnnOSX/FWFcKdqFw6DIA=;
        b=TBpKJDlvFJZDyVq0sbTbmGl648wIsD3m8FZNT9r++Veq3neHzjNRhZQgYjoXGMl1w3
         c7beUp9J5sVbMeCis8L24LWZF1znjOpvEyQrFtARvcwuhHhsdRV58KtuVLoyDdbVwtHT
         s2aXbUGk3qfsgh79ABxR1fbJbpVDk42abq76Ko3HsI76T4vNN4TarLBZ0isDftAzjx//
         CmdFSktf14hHXM/4TXLPic+dTKlIg4DIylpUbwUeWtyNMvh2uzgZMuYTVaSpoFlybJis
         pa7lPnnP3GrguBgP/Yl33rRcKWK+bzMIts4o62/fz6LflYFEoDnZukgyNAPtOa7mc4Tt
         7FQg==
X-Gm-Message-State: AOJu0Ywk0dYDHYRzcMBuyLi93KiLUyW1beLnfqi+fk++OtxzzkTUEaay
	IXxY+37F6znrX+dzR81OYqkcqiRE99sjA0c2yOGhdDM5+0YcSi2t+5TJwfo91ElL1jbhRBZpfSG
	or1pwjAK9B0CzZjhjOPuJDL5M0Sr54jY5U8y7erD64NfKtNblflU/
X-Gm-Gg: ASbGnctGYiQTu6CaiMPf2AbpTlN8oEYietcQ84x9IixEa2WGoA8i9ZkE38LHOYkDKIS
	RvKriBcDWEK1Hvqw7UvST4Ydcyv1gMAscIQVd0EDeZMDPoSKNJYByAN7LGICvQER2Sk50kbktLZ
	x4ebIR+nlmcyuzVMU8bdzDKewx2dUHaks0/msCUa/7Oq5IJoJFsguF+WEsME59sXT4a5yMRYPis
	UmlJEvHWN4YnQF7ZITcblQvAz5nlUWyVbjV97NqTbZE8eOz1151W628gfjfHwA+zjP6uraRfhkr
	SJyhY9MuaaFN6V7ncI3t2rZ1wjpDjroJstUlUQ2yuzogCNKp7tpCrrDfWDtT4x+/7A1h7N7mLC8
	B2GXADInC2age4omAZ2IL3I4iKA==
X-Received: by 2002:a05:6000:610:b0:3ee:11d1:2a1e with SMTP id ffacd0b85a97d-40f5fea54d4mr1470390f8f.10.1758788399367;
        Thu, 25 Sep 2025 01:19:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGCmL6IcJzR81nn1zjBi3mVjL9imP2afVOUxLsTA1aITrClZ80cCqOsn6rBksXQQny10pYe9A==
X-Received: by 2002:a05:6000:610:b0:3ee:11d1:2a1e with SMTP id ffacd0b85a97d-40f5fea54d4mr1470343f8f.10.1758788398782;
        Thu, 25 Sep 2025 01:19:58 -0700 (PDT)
Received: from localhost (p200300d82f3ff800c1015c9f3bc93d08.dip0.t-ipconnect.de. [2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-40fb72fb6b7sm2038140f8f.2.2025.09.25.01.19.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Sep 2025 01:19:58 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org,
	David Hildenbrand <david@redhat.com>,
	Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH 6.6.y 1/2] mm: migrate_device: use more folio in migrate_device_finalize()
Date: Thu, 25 Sep 2025 10:19:52 +0200
Message-ID: <20250925081953.3752830-2-david@redhat.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250925081953.3752830-1-david@redhat.com>
References: <2025022401-batting-december-cf51@gregkh>
 <20250925081953.3752830-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: uF4ikL_EI7We3TfuJ6KwwWgLFqlpJE_otxOI0KmO16s_1758788399
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: wh1krsckj54um7z8o7xsuzgr9uhm7yyz
X-Rspamd-Queue-Id: 3160B40009
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758788402-210576
X-HE-Meta: U2FsdGVkX18pR1m8iF+rnNJRvcJ7pYMwTLijlleSCec684gCRpGCeDWqfAwaVZbKeGU7V4W8Vs3xNvsKrkTS+3JV4ZH0Op0Lzef23+6GCID9BCiOtpHTZ3okQZQnfHmkpVrOXQ0bVQQrh0H4B+SY/aElsa/1EEfBU8faccSI4HrOpZBG1E2jTKp01juS3m1htc1CNMcobWegN0Rhh5RFy7rr6aZ6STD/S9fCTzgtVuJvo1xHqb+gimUYN0cZ8UaBG5THQ4F63exILN95ZohuWVgca4cDFmfTuBOkRL7qMp8oBFCvvQWsQknyjJrSAynpQOWi16EJZiX9UKYQOlzjoHGKH6giJrR8qhu+dPb8qSgPHrsyaOymkWtxrkItQrnKefuwQsmLOjoWYOOSUtgB9X5NwKvV80j8+I4/Aep1UE5B0OU1wzej355RZe3cmZv/v/Dbj9dKuQdYNrihNwfW+QEZZpDn+zOQ/e4tpnYBP3yqzvA33lg2gx3P60s0KQLxgJWf63omTGJ4dnu2E80+3WxjEQynf//7nKjZe2rKSw06XckDf4oOq+nVtLCsfPnoOjBn+RYi82BWURlB5j3S76zNwVZhXyZtAyhd8Mh7B3m+gDpj4ORVa1cYjW7z9pTyDxdU2m5851C9gp5FQgcJJ89Qo9Jy5/Yxumu0vAyDjlXd8D0ivpzYRGBg2+gJ/faKZkIT7uaNkM+W8tEzEcsNlSEkH6rg9IjUfTTf9pIuU6TqeWtW/TCOs/c6ADoV/oz+59qd8I93iJUjnnFaLv6sxtPYeF2BZ9bYTH7NyVdYfro9lxyBkITWtEvDZwB5ONeaiCpWOCtjzVZ9bxFNebcz5dhFe48wwhknMJ/fKYAhCO5qRa0tzyhiw3C0sD09THEDuJzrudj1Kdyi14fHL+71PacuKZSYxtCL+qERDNQndoxOo6GsnLzfl65II/RqHwqrEUggO7ff/hOlB9X+PgD
 nfIbeCji
 SEAeimyQySCkVLTH3gJkpFbR1c38WLThgyX6pAELkToKbg7wamxIiRp1V0tt3W86i8+gt39AIii/Yr8QDJQ+syVN9AJljP0JkQF/VodY125b3n5WrGiNizvS/yH/qVlNqDz0XhfxQQxyrJf7pM9Fio1iA9BVrwVXBLMi4skVMs3AvJ8CIvWA65yQISz64HYKPcvnbbMalkbqXcBbJDrgOa2q+gzzrqkE8hTuynYmNLo3CxJjgUmiu2SmWRZuycYKNccH7RqNSoSnOCVV8I29+ku4DKQWHnIKsO8oE9x+dz5WuFCnn76D5uFlmO8Po1p+4tGLqd//Uy4Mx4+4pXIRwmfGS6ty5omW0GMZoZkKll3f9IpPLDFQm1l90pYiApWtd6sI4WnLowV0agkXVWaRgMqLOFFachu3EBkzUv+n5rh8gPoRpZZ/uTqxh+triGqjP/jQ4GZoxEfpyovZYeUWAWXhrLf5kzEe03yD3Rmia+XNYxzw+AB4T2bBQH+zmOlxbo64p7GYrpsPT3vERV4Bz7djKW34rhT2mZzjr1fSm64Et7yo3PWX4xiw498VhojWzNAH3TDcMhsPj0XWJvuZtT/DBJsPueEjhe9J3H9EH7vOIu6n7JjXIHUIJkZssd6apsAvoDNHpHvO3t51/vDhWlTABjz1p0+grzZY6gv8uUO27mcYCpysFUEuGZyEH/RTOhiWoQ56HREVMeB89QTZKt0larqa/OYMIG37jUSyzrtF+QyFRLEzTNnIzLAr5JlbWDpd5Rh3Qb9CEnccM3qavKRq1pBNGgx9K6xzhdaNAZZdVEE6Hz27ny6xcj9tHzFOhySPVXD1rHYta7aH1E9kMAnNuv4MdavowzXJxWAcLEYzeXVMdXPXmQnkPR8w/eZAxvJGmItLyiuGhs36/K3c7xDjDpqeLQbhP6CT3aOjJcKfXqcI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kefeng Wang <wangkefeng.wang@huawei.com>

Saves a couple of calls to compound_head() and remove last two callers of
putback_lru_page().

Link: https://lkml.kernel.org/r/20240826065814.1336616-5-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
(cherry picked from commit 58bf8c2bf47550bc94fea9cafd2bc7304d97102c)
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/migrate_device.c | 41 ++++++++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 19 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 8ac1f79f754a2..06a52612b2c45 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -814,42 +814,45 @@ void migrate_device_finalize(unsigned long *src_pfns,
 	unsigned long i;
 
 	for (i = 0; i < npages; i++) {
-		struct folio *dst, *src;
+		struct folio *dst = NULL, *src = NULL;
 		struct page *newpage = migrate_pfn_to_page(dst_pfns[i]);
 		struct page *page = migrate_pfn_to_page(src_pfns[i]);
 
+		if (newpage)
+			dst = page_folio(newpage);
+
 		if (!page) {
-			if (newpage) {
-				unlock_page(newpage);
-				put_page(newpage);
+			if (dst) {
+				folio_unlock(dst);
+				folio_put(dst);
 			}
 			continue;
 		}
 
-		if (!(src_pfns[i] & MIGRATE_PFN_MIGRATE) || !newpage) {
-			if (newpage) {
-				unlock_page(newpage);
-				put_page(newpage);
+		src = page_folio(page);
+
+		if (!(src_pfns[i] & MIGRATE_PFN_MIGRATE) || !dst) {
+			if (dst) {
+				folio_unlock(dst);
+				folio_put(dst);
 			}
-			newpage = page;
+			dst = src;
 		}
 
-		src = page_folio(page);
-		dst = page_folio(newpage);
 		remove_migration_ptes(src, dst, false);
 		folio_unlock(src);
 
-		if (is_zone_device_page(page))
-			put_page(page);
+		if (folio_is_zone_device(src))
+			folio_put(src);
 		else
-			putback_lru_page(page);
+			folio_putback_lru(src);
 
-		if (newpage != page) {
-			unlock_page(newpage);
-			if (is_zone_device_page(newpage))
-				put_page(newpage);
+		if (dst != src) {
+			folio_unlock(dst);
+			if (folio_is_zone_device(dst))
+				folio_put(dst);
 			else
-				putback_lru_page(newpage);
+				folio_putback_lru(dst);
 		}
 	}
 }
-- 
2.51.0


