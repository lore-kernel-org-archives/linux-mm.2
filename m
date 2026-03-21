Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 906E21094477
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 13:29:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C7146B00AC; Sat, 21 Mar 2026 09:29:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 976F66B00B4; Sat, 21 Mar 2026 09:29:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 865D16B00B5; Sat, 21 Mar 2026 09:29:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 742EF6B00AC
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 09:29:29 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1260D13B27C
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 13:29:29 +0000 (UTC)
X-FDA: 84570152058.19.0E8CBC8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 01241A0002
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 13:29:26 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=i5FjQD9l;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of syoshida@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=syoshida@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774099767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=B82GY4CexGK1pHocVV2TZ4m5tLtWLMUbz4lCPpzldPo=;
	b=mzJCG9T1Yu8j6uyNQ9dNJsV3BId1me1qscjyI+ENuMraZBPeXD60TvpGLYQF7KfYBh/Gy9
	ZnbgvoVGrXvDbVi/+MTUax2kZTHG51ZmKovMofUNx2v6nIQI/RNTW958icCx2x5lrcgPAa
	G77lh4IOnRUZOg1nr0Mm6wAw5xhPN1c=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=i5FjQD9l;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of syoshida@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=syoshida@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774099767; a=rsa-sha256;
	cv=none;
	b=Y5raTU0EgWVkQM9ilRkJ3KcduASs2+8idv4yuOU/ESopED9feLmWuvSVV1gfspfDAP4aum
	LtT+UQ70wwTRD3nKNfDsJIjHDRrTe5J1qcCpxEXLrG/6HUvr9ZDXUI3UA3DxOZMWa4BkTm
	BPs4//ZdZVPtbu1P477UXTc97tnfYLw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774099766;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=B82GY4CexGK1pHocVV2TZ4m5tLtWLMUbz4lCPpzldPo=;
	b=i5FjQD9lOB7rIFlNHKZM5dQ7kFQlXuQ1rIVAkX+8GPdGBm9+CXAjbzNw/aaKC4JjGx/dsY
	501a7kq72M3pMy8ptIySr73umOu5NKuQMNxBjAAGcG788nbkdT0pLK9wvXJ7bHCSi/Qay6
	4FmTiBEZ+HYHztJfc29l/tQGzwUIagc=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-480-k2osCrfINsS8Md2qFDs7zg-1; Sat, 21 Mar 2026 09:29:24 -0400
X-MC-Unique: k2osCrfINsS8Md2qFDs7zg-1
X-Mimecast-MFC-AGG-ID: k2osCrfINsS8Md2qFDs7zg_1774099763
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-35641c14663so3569787a91.2
        for <linux-mm@kvack.org>; Sat, 21 Mar 2026 06:29:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774099763; x=1774704563;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B82GY4CexGK1pHocVV2TZ4m5tLtWLMUbz4lCPpzldPo=;
        b=oDazhRNW1rXJoXnHK1h/M2A/dPDsjPgcqq1zz1ZTixsZIeZyPPVDldaQ7pJXUeWC5o
         nfja/5qrjns2ImAzblWzVyDRQqaANU7E5XQOxbWzkKiYp+FzOPCmqw/v02c5GeHZGj3N
         c24TIYCKH2GpY7O9dMmJkmsSMyAZFbg5s0N4PXD786VMBMnsrCC2NBQGdvUoTULDG3cg
         /Bn9r0ITCM78nXziy3GKUXZIez48psw97OFMuSd6OdcyGQe/LjKJXjj39VEMlcx+MC9V
         cVr6UuyPeTEYgrhUi5EE9S/jQkKw4GccxB3kCIjWy2Po/nI2YvmI9jKr099txcxfAcnN
         LmuA==
X-Forwarded-Encrypted: i=1; AJvYcCU4CPwtgNvOTdCbwh+tFStHvjM6EAnKkkBuao0BsxLlVwWGdjtDUmoN14aRZ2WY8jSkkcOOmr+aGQ==@kvack.org
X-Gm-Message-State: AOJu0YwPVVrGcxbCLzxd4AeebrN/QpVfheaV9CU4vlkv9YH23f0Vdhyi
	KTfDEFaYvVLIWktjCCaua6TnRHcy3azgUvRKuC/IyS5uwFccgC/iOxUbzbKvPw/Fkz0qW9SU0VL
	rqMsYZON54il9ROXpR8swRpgJ7kWLK6wiqTKItIQY28uFr/SjVr2a
X-Gm-Gg: ATEYQzxg+DKI2cKioYwtT5p4c0p+zaMziiep3ciAFjOJZMP1QkZU0t5MX5TGh8L42L5
	j6Y31kYm3DhDJPrxUZUopfLJH4zc4hmagFh/LTZjMkZSZ4GVwftZ2G2VZtSAm95Ugx251dVlUpt
	P0bUPzP4XTFmR/0aXNvFsEm3wQPAVtS1nAGw3b8YKRm8IuuG9pifftHiUjyFuKdcPnqcD6sP0Hf
	YBwDaqw/GemAaAkTNUaN50smVrIilnzD6mNORNNSWDz6vbDj/7KDdKPMbojzubFdIIZePNrPfs+
	J2dfnMEEugbzKH4XxQEmGBxep/CKcgvtb1xl7QvMlvIxU2MRlqkObanxhfQ46AvXlFDdiTf8VAb
	1K7LUvMKy6lZgoYya1RERs9pV1e+C/dR5VSOpEy9oxbzU/A==
X-Received: by 2002:a17:90b:4b85:b0:355:35b0:8b78 with SMTP id 98e67ed59e1d1-35bd2d105efmr5156404a91.27.1774099763317;
        Sat, 21 Mar 2026 06:29:23 -0700 (PDT)
X-Received: by 2002:a17:90b:4b85:b0:355:35b0:8b78 with SMTP id 98e67ed59e1d1-35bd2d105efmr5156391a91.27.1774099762970;
        Sat, 21 Mar 2026 06:29:22 -0700 (PDT)
Received: from kernel-devel.tail62cea.ts.net ([240d:1a:c0d:9f00:be24:11ff:fe35:71b3])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35bc610db9asm7957406a91.15.2026.03.21.06.29.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2026 06:29:22 -0700 (PDT)
From: Shigeru Yoshida <syoshida@redhat.com>
To: Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Cc: Shigeru Yoshida <syoshida@redhat.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/zsmalloc: copy KMSAN metadata in zs_page_migrate()
Date: Sat, 21 Mar 2026 22:29:11 +0900
Message-ID: <20260321132912.93434-1-syoshida@redhat.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6r0eqS4sSNQ0L4_b-NTOtB4VWqeguXYRiR4N6C0GrOU_1774099763
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 01241A0002
X-Stat-Signature: n197ix8ux7wbe8te54q3tmsps4yggo9q
X-Rspam-User: 
X-HE-Tag: 1774099766-600939
X-HE-Meta: U2FsdGVkX1/vFssnPYq/NuaM7mNLfZh/rBKwthkvnnPEfFzUVKWxUt/MXTSdD5yLf3nchnUEai7elMSqTLKesU0w5ssNi7u5Oz+4p8pLeZrUJkg+NyJostxHNmOfrhLB4fcnfJJJFF9CVaW5tb762iMOmNpF4bWaAdkVmmkteYXpU3UzRKnkNZLGhzEvKTOLq/mnJ8c+Sz+wERhWtsSC8K10dSf1nqBxy5tJLzv/qzloq6kAHTuVJ9soa/3QW0hUlZKLjNf+fWWsdFo09ktXdodUqvVT8rThUWyyPnK8uWf3wHFN+YmfhOLg7+m8TI6k6uEqMFa/dFpycmM38tOpOUKRlV9Mpqtr19nogO8GLXEz0mJzpVmO58GU/ulRMxkDn47OLFUrE/V+Qm5gRP8edmEfdw2IO+D8pklcz2F3TDg4LU8pHBEhPixy7ODHuvtBTbF3Mepp7KyDHtmUD2+dEa1VJyejp3AZ3+zkH4Ek5ARzwy4s+urfC0R7D2IOIpQ1jueuGmOSSuYSlOccNE1ASQ+yYG1vhtKViKghMM4MARO5I2gxpmajdpx/LAHBl2HwU4NMUuIT9cNmJo6pAb8qrobvMDF4fThwcT5QDj/esO04SDQW4OL+x80EPgRBwg4SNFX9bZhBbXVk98EXfKs05I3yerdZnCIRi3Edlc5kJJrq5C0v8x0kekEP8X56L8Kse29pPLpyy9gdT06INLu3XlJlhDTLJBGwbvh0H2Ld7lArm2HKW/Tophs72pJ9wKDiwySnp2D2x5UGQ5lPAsv673To0mNYM0ho1ItTyWwJVQm/CTxv76AnCFnV45jCCU7Yb1HW5u20eq1SIyBZX/81gDhr2M9lNvIFlehDLBw+WX//fHitySTM6CEQAJU1opkSfOZCkl6NoT+Ne2zT7iwPk0xy1yICB8Ai2htPOCaHrZmmp6NnKOyXvWQxAe+WtTJ0BrppJyZwnyXpzvOs84h
 mShwFtzn
 EuO0X/zl7YyaN7+6uj5udGOrXxypJekZ4ang0IIo9ylQjwx8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zs_page_migrate() uses copy_page() to copy the contents of a zspage
page during migration. However, copy_page() is not instrumented by
KMSAN, so the shadow and origin metadata of the destination page are
not updated.

As a result, subsequent accesses to the migrated page are reported
as use-after-free by KMSAN, despite the data being correctly copied.

Add a kmsan_copy_page_meta() call after copy_page() to propagate the
KMSAN metadata to the new page, matching what copy_highpage() does
internally.

Fixes: afb2d666d025 ("zsmalloc: use copy_page for full page copy")
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
---
 mm/zsmalloc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 2c1430bf8d57..79ef9d57f2e1 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1741,6 +1741,7 @@ static int zs_page_migrate(struct page *newpage, struct page *page,
 	 */
 	d_addr = kmap_local_zpdesc(newzpdesc);
 	copy_page(d_addr, s_addr);
+	kmsan_copy_page_meta(zpdesc_page(newzpdesc), zpdesc_page(zpdesc));
 	kunmap_local(d_addr);
 
 	for (addr = s_addr + offset; addr < s_addr + PAGE_SIZE;
-- 
2.52.0


