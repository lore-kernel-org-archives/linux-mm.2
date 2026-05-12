Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6F70CD37BE
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 04:12:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C66596B0088; Tue, 12 May 2026 00:12:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C17B86B008A; Tue, 12 May 2026 00:12:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2D006B008C; Tue, 12 May 2026 00:12:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A38FF6B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 00:12:14 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2C21F8C5FB
	for <linux-mm@kvack.org>; Tue, 12 May 2026 04:12:14 +0000 (UTC)
X-FDA: 84757445388.07.3597FB9
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6A4DF120002
	for <linux-mm@kvack.org>; Tue, 12 May 2026 04:12:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YO95Z045;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of agarwal.vineet2006@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=agarwal.vineet2006@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778559132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=PPUpmSjgTJAbeTHDAZfVXaAmUiYjeKJO1WxUBCqQG2M=;
	b=fmUO/nZaY+t+l4lUgRfedOfhZxS0ps7oEHmLkWsV75Z11QFNxHtK21y0OJecBlBtyPgjUM
	vDP+YNvSZgDqquv+OrIOF7Jh1RPCXgZJm2AN2/VyznXx/xXKvS24lTJu29g8JHPIAuJ20B
	ytYnTJxE53akJSQvBMs7HR5TSZkON6s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778559132; a=rsa-sha256;
	cv=none;
	b=1XG4fBCgl+7pDxkUKOE3pp+2wKs6nTXjjIXgZAnhME3gY0UjF4oV19cr/MJAKdz9X4qxFR
	ftkzo6sMsE3y2fgtjoOp4s/Ve85lGKjfgnfjr+08zN1TNZBp3bhH+XOg0m836vOYTLPKvH
	rz8tTqrb3ayUlBiBLWUUQv+bPdQ511U=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YO95Z045;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of agarwal.vineet2006@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=agarwal.vineet2006@gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ba3e3c4f87so46087335ad.3
        for <linux-mm@kvack.org>; Mon, 11 May 2026 21:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778559131; x=1779163931; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PPUpmSjgTJAbeTHDAZfVXaAmUiYjeKJO1WxUBCqQG2M=;
        b=YO95Z045dAc1JqE5j6M37bFFh2tHNYyw7esgbgvalWaaaLnusVhjYmJjuj3djgWAKj
         CbZq4PuG2xyyNREC4yWfwporuu+4gY/PTQNu31BKIaeNgjU5FkuPoIAoMezXqLOJrFZV
         OUc0NkbRF3Ey7Pm+TtnBh1KqH0as7uDHL+m29wzqUF7MQGW9Kw4Ai/phJdMw0qEiX6RP
         Yju5ARRtCNPKby8FCHhU63zHJvN9qgdbdQyLhXjLF3UjauLBB322LpWkQBszpztuM70p
         6Fp3gz2TI+6iUD0WN/0lU76S6UbwXR3Qui8/k7Etpxu4T37aSzHp9D7NpKzuMxrI+oOo
         91jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778559131; x=1779163931;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PPUpmSjgTJAbeTHDAZfVXaAmUiYjeKJO1WxUBCqQG2M=;
        b=mYBz7KJaiTqKMC4e4Z3H+fC7Q4csX9IcrMMHKVKBHrv6Dth2XLDcbaThoCdj6sRqma
         vb1HwokyjKsfliVAnbsL1eEPL+5kASKtTtiz+A6pprs6vDJIRzPUZaWoHhPG3qOlrz+P
         mVg5+t3+m4aYu0pIJ2xEMhNF9EzqEv8jyG3wVnZRHjjtgDAirGmEkyAGidN8pzvvHCtR
         mdv1MtOShorEVRX2592cNconXIqZ7yTybWokbG3z409WUXXEE7EMNmWEq5e08Td6I5s1
         Yi3UiJBHTHhIJmUBFW8PM/6aBIkSj3gxeWUebCz+fUm9Q8+ioYAXiChUJu9nPHiagWNK
         gtjQ==
X-Forwarded-Encrypted: i=1; AFNElJ86h/05SEW1KFuFXagl1wvOEY9Dfyy1bpBmOyYaF5xg3jWuqPjibT+XZGHaa54N1mXbqhlebYlsBw==@kvack.org
X-Gm-Message-State: AOJu0YzNhV9hcdtv+tBdP0EYJVqfWfKrQxWH/ah8nz1UW6GM+AzYYC2Q
	8oMtfTjw+I9UUC8dQvEqDRGDzsu93ZcUtQ1DKb47BiHJX6iKphkZz3iQ
X-Gm-Gg: Acq92OFw5XKxZTPN8da/k33uhQYsmYkE7dc170ndYDIyYflVGrU0hSQWqxu2Knzc3zV
	0/UmBEg0qV75gdkBUzDHZ8Bfyf5RAZXRZzekeeZKST5PO05QaCXYsfl6Ur97bDTSosqRfP5nKju
	3gTi7FnSQiYTtgKT4Lz3+YRw44jpn776JMfK2FxaeRhEH6ZmaK/HlAAWeRzuBLxZJLm4eOhmO0k
	QGVIWMou4N8P0rffIbiZO0aCRt71veYwl9BpMuz9Y+gTj2MmAiPhemFyPpCeprwbaCrgrI1g6D0
	jEBcCqkW2J5j8XGZkdN0gI1wfXqIWAfyFoa/bufCOKxst/mG6GALp1BoftjES2xYu3ULRgsKeDO
	hvGRxeKRtTJ9Fl33tXuFsPiaVPSFIgh7JOZkJjhBOU+jb+ATdQtfsiLy6L9n/XpFRQk2GPiDIMI
	S505Qvt6XF9LH1r9F7US9IkAYwJbbyNBkBFNErVxfA
X-Received: by 2002:a17:902:bd47:b0:2b0:6e60:9586 with SMTP id d9443c01a7336-2bd01174247mr10425085ad.17.1778559131150;
        Mon, 11 May 2026 21:12:11 -0700 (PDT)
Received: from vini ([2401:4900:8fc8:73c6:dda6:576b:fa0d:f68e])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bc83101ee1sm85082565ad.79.2026.05.11.21.12.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 21:12:10 -0700 (PDT)
From: Vineet Agarwal <agarwal.vineet2006@gmail.com>
To: sj@kernel.org
Cc: akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vineet Agarwal <agarwal.vineet2006@gmail.com>
Subject: [PATCH] mm/damon/sysfs-schemes: fix double increment of nr_regions
Date: Tue, 12 May 2026 09:41:57 +0530
Message-ID: <20260512041157.109845-1-agarwal.vineet2006@gmail.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6A4DF120002
X-Rspamd-Server: rspam04
X-Stat-Signature: fti443bbstnyhedcwaagtmw6f6m57q9o
X-HE-Tag: 1778559132-705860
X-HE-Meta: U2FsdGVkX18YpFPHAud0OX4hg5l/Uauip5Y6UvMEUwMUWoxWaSxb2qAmrPRW8nBMfpso69e6lfL7dar0HW1BNt6ksVA2vNNeyLvtkr4P85/4sqaLDZ8neNLV2gmKqmp/dWfcoiWDXWZcgiZYtcjOuwDWCLMFLlW8yMUfNjGUw+2t63FdPrkqI2s+kDUFNa+DAXrcOso1lc2IWB31iKYdnPmk0KOipOlEGdEX7cYX4udBm3UHYxAeNftkA6smCg/ab2k3A28tgQ7PSUpZFxc1g+MKHkEXdlVOKzwnPn+gbB7o25kt5e3VFxAsrWNmeju7p0vq2CZ01yuSjew+y8GTl8VTRoPdrOk86zm/S6rxht1D5fwM6G+eYjTKgJrzb5+g9aji5YietTqNM+pH9aU8EzKNtdekF1m/YoEUIdPU4ZGjsKgDD6SKRSqLxMIbiQ2ta5TMQuuEejkbRUul8Ow8xdsCJbMpDSyrN2oPyMl6WjNninJKeeuFMLT5INGELa7dj3fenzjlnKRpg9GWi8MaS//5S7b/q5CzOFL9nJ6YpNlHV4mbgxwSo38W3HITx4JIgq5z94QOnEYu4ahs8a+7zncr+LwFgyY87LX15ey7hfu+w75Miq4vU7NTWeQnQD1tYaNPnnt6XPah8wlq0FDnWNW7p4Y3FNFFe40qM+PyS+P68j4fxZdE34yPeDDdkraZzKCfLYLG626BoEJiDxaLCH3q8byqez6mpWjTRknUYfZM+WrWnyTjZkKAXj6yMCNN3t59NpdLPGOIWo2/PjN8cmrX9/6FG0C8dyohFCxRcBWuknPwIdJ/pwz9VQ5E3eXxh4IL1MZvxrlRi6mPoUYR+IRQYw+4kmhWHRVuj9S9fAQaqtp0jC+goYpH3wrLHf0zNHd5FgSyiP9F6qv3Cue79oRHkiWcl21iRbtCmqW7cqncaaLafXh3MxMIsFABU1i7HrgfuRhreELPfme72AD
 lJ6OkZ+j
 GTwzA/QmMeJSzC57eo3z11WAMRZLwJcnGH37mGUd4aeKjqAWu4pPsqeBKMKgoenwIw9O2W4RX9cuG2Zu/8UKDKlyza1HY8bYXcngQDEUfCaqObpgZpxw4fDIuGz/SR/A71PAUyZyWXNofJOKpa0JBuIR0DPKrDjjAFjMW5rEIofpHR0RVcHKZlqkCAtvPDqkAti9Vk2tx+qnOXqJjDmHCCG6ido654Q5tK2NflRIuTYZ4dvFOIlRpAIpBWbFJpx9IWOI9gfU3YPPqFUnstuia2UcveobrpwMe2BOwRaLd03Xve/u+dPkUtTu0MPYw7MILkD65BDjQgh/y0R2rlI8LaS/vI/lOPwVT6E5cqjm8VPpeWsNCtVueRYU3RSvThIrFIBTYv2I6c7bOACkR+Wq6+sF4QI9s3xXAj45QeLj+S7Vq0sRv0Zu6YdwC3UaO7fJLIbHPoxzhPir2maXUpxBka43wO3JPVOf5DVC2H84VL15bDww+sUzjULVGADJgtVExSHN+jT/zh1hxmjPRbDaBYO0tC+e5Ra1cxzpG4eM7GI+XhyH7q46EIl5k1Zi3w05YjoUjIsutKxtSjkQ98Bbes6ajcGGn1mzZzSSsKiRBgsZ5pIjLFMXG1AMjYdUe8dAGXk/BXVXYTjiKq0F6c37/YmiLvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_sysfs_populate_region_dir() increments
sysfs_regions->nr_regions twice when adding a new region:
once explicitly before kobject_init_and_add(), and once
again through the post-increment used for the kobject name.

As a result, nr_regions no longer matches the actual
number of live regions, and region directory names skip
numbers (1, 3, 5, ...).

Use the already incremented value for naming instead of
incrementing nr_regions a second time.

Fixes: 66178e4ec30a ("mm/damon/sysfs: use damos_walk() for update_schemes_tried_{bytes,regions}")
Signed-off-by: Vineet Agarwal <agarwal.vineet2006@gmail.com>
---
 mm/damon/sysfs-schemes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 622c3799db87..5d966ac86419 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2998,7 +2998,7 @@ void damos_sysfs_populate_region_dir(struct damon_sysfs_schemes *sysfs_schemes,
 	if (kobject_init_and_add(&region->kobj,
 				&damon_sysfs_scheme_region_ktype,
 				&sysfs_regions->kobj, "%d",
-				sysfs_regions->nr_regions++)) {
+				sysfs_regions->nr_regions)) {
 		kobject_put(&region->kobj);
 	}
 }
-- 
2.54.0


