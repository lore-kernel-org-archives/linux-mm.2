Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADE7ED3CCA0
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 03:19:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25E1D6B0088; Wed, 14 Jan 2026 22:19:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22E156B0089; Wed, 14 Jan 2026 22:19:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15AE16B008A; Wed, 14 Jan 2026 22:19:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 075DC6B0088
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 22:19:37 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B63951AD5BC
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 03:19:36 +0000 (UTC)
X-FDA: 84332743152.12.9EA8F18
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf28.hostedemail.com (Postfix) with ESMTP id D060AC000B
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 03:19:34 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=bCC7h3Fl;
	spf=pass (imf28.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.170 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768447174; a=rsa-sha256;
	cv=none;
	b=XjuYAwBddk8Qil/ngYvx3rsmlVF1szaV3ERLrRL/2Ol8H0prdmlbIqiLtX8M+Sha/Lj2NY
	OpPA11H1m++tnz8KANnMbieUeDC6O5jcyAnKYBm0gqvh+x8QrbMIP6eK9Y4Sa3TX3pxmBd
	GoPps5Rdr/TNbr6j61QWlGXHWK/YomY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=bCC7h3Fl;
	spf=pass (imf28.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.170 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768447174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tKXqxmU7xXY9AwNPMkhuQdHIllpg5AG9czMEf/Cg/lw=;
	b=Bbfpo2bpbIlLSHp+nZPbpnGQeB20LYp7WH3PBWYd3iFskfCRKt2cPcRgEghLWvJ5Kc9BMr
	hotoH0BN8H1ApcKCc3l3OyuYK3IVRCKC73zA2dJ4Exu2yVIassSGq82IbWeGiDSNrS8LMg
	dD9rIaSNJMTsEADTfxL836yeg9C5RN8=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2a0ac29fca1so3253785ad.2
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 19:19:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1768447174; x=1769051974; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tKXqxmU7xXY9AwNPMkhuQdHIllpg5AG9czMEf/Cg/lw=;
        b=bCC7h3FlSm1BT3VRZXp3uS7KmnTzPDIwqTGfdbFH+TmMEl69erUQH+xMW/nZ6ZnrFu
         0B16SNhgViyVwxBtGGiZ2qaeSzwGcsGFzzrSAiSxEwlllpZi/PN+drgn1QwgBpxO4SKc
         EhptRXbcypK6wU0NFZqSzVNau8/38HuGcxpkI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768447174; x=1769051974;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tKXqxmU7xXY9AwNPMkhuQdHIllpg5AG9czMEf/Cg/lw=;
        b=sns41PCXEi9lWWZzwJdOWD6Yvi2PtuJS/MUFdmzLC86QM8ZKhhR+TLSxatKlkC4R3B
         sipYQUk29FBA6mH1Nwr2nMGvMmhmIvGgfgp6WILb1zQItNYZlDl7drIvxeXuCV6muu90
         SaHOBNTPIXysabFYgeosTYTjzv77x4wV/OKSA6pIr3FN8LkUfQlR7aa0evWrhn7Onp/x
         IhHxeYw8TRB+nViJ0XxV5jbcvouvxO6B/hKbbA2t6dehpWLbCCZn2HmMHx7YKMgJY84q
         bA9u4pgo9Pd2nqrzs7j0qj20zg0aadkK6U9Q+tx66ef45Xsu5h2VS8qp+zzUUGUFTC/D
         fvBQ==
X-Forwarded-Encrypted: i=1; AJvYcCWWPlZzXe1BAl7uItBHYByee/12ZlNQEw8Wg6E3T4MlVBEIx9GxnzVbnFrrypQ34cOXfXPQ6j3AwA==@kvack.org
X-Gm-Message-State: AOJu0YxN5DwRGuV96prFFWzrADFPhz8XIGVtZhZfwa7mGopKoBoG6HQu
	Xl4lFQzvJqZ/I3be7meOkAMMSJ21tNDtRQEZi3zjBTw2jY3N1cRVqYbzLbRwPryfVQ==
X-Gm-Gg: AY/fxX6G4YAAfb/DSdPP8+Z0zJgthR86INoRwF0AJh40njJVxJ4xwBg1FceZme6++jS
	bkgQ8fsh3QeXeP5Qf7VcO8tZbaG3y+IIFsvpPIgY0scqRFqQ3p6b+kYv9r/cFOA2BzRovumM3vE
	3yhBvpeqk+sxNUbDD2z/LNVDu2sQQEiqXuyyzl+T3oqnrNiYI6Yn5Oge0FStzNwISpekFPu13+x
	IiEeMn50qmH+yQnba+ynvs2Q4WTMkxoYttF8i2pSdaik/5T05YTzEsT5iFINsASgDAqApJX5UWw
	Z+ZXNs6+lohTJCEJo+Z0jqg7goQgL2/T7yz2exs2IxZgaSr14kXyRQzMrBWQtNhLbcHbarMGZKI
	bHOs7gz1Z9vgB/nhhkLjxDzci36Iej3F/rw6JLB/yhm5ISMkBB3mKerFUQ9Z6wUhTSnAZgVpv1X
	Ugii8WP0pm7C4ChiPzGSq2eV4SmzoBqkUPRSqPjFW4+BIoAWJAmhinmkZW9Px5D+dIxKggDiwvZ
	A==
X-Received: by 2002:a17:902:f64c:b0:2a1:4c31:333 with SMTP id d9443c01a7336-2a599e08b02mr49620495ad.19.1768447173710;
        Wed, 14 Jan 2026 19:19:33 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:36c2:991a:5236:1fe5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3cd495dsm242463815ad.96.2026.01.14.19.19.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 19:19:32 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Chris Mason <clm@meta.com>
Subject: [PATCH 1/2] zram: fixup mark_slot_accessed()
Date: Thu, 15 Jan 2026 12:19:00 +0900
Message-ID: <20260115031922.3813659-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
In-Reply-To: <20251216022729.E4A43C4CEF5@smtp.kernel.org>
References: <20251216022729.E4A43C4CEF5@smtp.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D060AC000B
X-Stat-Signature: 3rnho5i5irguq49xcnnpmngstnh5r3y5
X-Rspam-User: 
X-HE-Tag: 1768447174-509293
X-HE-Meta: U2FsdGVkX18fHyJ204JmnpPlgqffNSjH8wbpwxcWaQwj5+HJg2ga81cwz2JbW9BjVTzp6o2AAgRfus4y0HXr2hLSf4IwinHxvirVyaB+NK7PbpO9kOioEtdTvap9AFKviD7nASxqPS7IEbZFOfkwnaNUV4qvbzlRKU2Wx623871+EnMkj2Js1auoSda7Jg0mzppk+pr67kKEXRKKUZL7huGkVD0bNozSfKFWK1NGbuMigQ15GglfD+xmDxfvUI/K/xuLHS5d0JFCwRPPFuFz4VA0st8gkFnRFrnGpTWqwuy2byfmnh5Y4iJjOu7+Jd+8ZxNDrvfvFYQULrBBOCRdll+IPBiV40/PFt8R5v5zkxn+Cd99iaR1YSkkD0wpfK8xOSHuYRTNO4HEuvwVfPa9pydmQPnAjlPOYgjNQCmJHWYyg+z3MqBttVk7JOte7Sg+xAbubNHSLq92F/jUygDaLyWGiQvzzfhtuBslTbl81+rO/SqsK8uSiVA6uJSSyRmhCyWDgmlazCfq3jqg+7SjEe9LXilASqXaNjPxX4MoAubB1MKtNOnmgz07nhuaSjwCIzasZEdq4QZXxAWimVJ/mL2jYGjGfhy1ql1Evv8CGKU4Hagvq5BOag4kUwDJX2M5Y1z/bHFhEsdsRuUWAhPQAcabnyzCC70DU2xSdEjKx5/taVmPfWbCUAIpyoYdqgiYpkUj5bLJDN3TQUUPEVWdHUsffIIqdFrcGVdTDYSzPIroEjWLnNfWM6+XcTmJWWBILz8xNt6PWytpw8x3EijfU9nrde1SLEMoCc8P73SOhFVIwS3qEFW0mIgJ6AG4gn16xfl9bY3/ujKRg2hesYacSpHrV9D5WvlAMMpzxXcszaFXhiqY6GRtiFunnPGpvsUbfL4nJNwldx2RFLSUmhjJ8WsW3dPDaRK2Cv6koN71bopGZQYfUqnpDCpy/32zdx3CXDJcYQtzZ+YhUZu6mi/
 f2B58gTL
 TFKswYKX7LXj5DyQzZ5y12aWWfuTAly7Nzcz0l4ORmA0FQZVsWGxN/m70yhY6jOnYeuVpd/m15EoUXY9D5681OIju/Ndd+JxEchjcuDLo7+HMXVjcLBu8d2UJ8i5A1o5e8uOSN2Hap1QkW+O2P6YIAt2OXvVY7Isz+UR1LSCYmY3Q/Y85RBBA1k/fkNOAoE4RsWgsYW83zPZRJoHBUdlqXwQMqO7Wvq9aKupRqt1hIzcZxnWc4pGmKsHGizDZHj3/r5fueU2q8K382F/XrfcSEwl+hNVhjzibMX/46QrQCnR1TTuK2ueb9p3RcZ3fTRTBQ43K2Lh2kaPVYsxN0wQLbrtHODjSYHsTTnPr/zn6J0VkIWKjxdN8sDI0OcvVfNFggX3pMVvbKaopVJjQbfLGYKi6Vg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mark_slot_accessed() should continue using ktime_get_boottime_seconds()

Reported-by: Chris Mason <clm@meta.com>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 76a54eabe889..cc51aa8b6181 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -190,7 +190,7 @@ static void mark_slot_accessed(struct zram *zram, u32 index)
 	clear_slot_flag(zram, index, ZRAM_IDLE);
 	clear_slot_flag(zram, index, ZRAM_PP_SLOT);
 #ifdef CONFIG_ZRAM_TRACK_ENTRY_ACTIME
-	zram->table[index].attr.ac_time = ktime_get_boottime();
+	zram->table[index].attr.ac_time = (u32)ktime_get_boottime_seconds();
 #endif
 }
 
-- 
2.52.0.457.g6b5491de43-goog


