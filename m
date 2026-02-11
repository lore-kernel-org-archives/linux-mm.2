Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F7E1EB597C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 08:13:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 062446B0089; Wed, 11 Feb 2026 03:13:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F318C6B008A; Wed, 11 Feb 2026 03:13:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E50FD6B008C; Wed, 11 Feb 2026 03:13:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D3A2E6B0089
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 03:13:35 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6BF4F57CFA
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 08:13:35 +0000 (UTC)
X-FDA: 84431461590.19.FE9BEFF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5625B12000B
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 08:13:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="dnt/nrfg";
	spf=pass (imf29.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770797613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wosffRiOYStgrb1M6Bi1sC14SSDMH8Tg3Aw0IukakUI=;
	b=mQHHQgjJSDMd4qSHcVOVk/q8KiX6CHfD10twkAxXsYnKYkAT26WejzbAqA1p9LKylThVFI
	/CgxyqyVdWS03c/ut2sb31UcmPSzoiDrlfZJ0A+QpDPuCpbTlkJT4vUfba9XQy6tWcLor6
	/IKKTCKV6Bw26jklBkdyi5k1gclctJM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="dnt/nrfg";
	spf=pass (imf29.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770797613; a=rsa-sha256;
	cv=none;
	b=CUkBtfytzPN/toPrnZbA6Ev2D+mmcHAqJDRfYvU15HKWEZFtkitUa7tSddWNtYlM1Yh36G
	BAF+eetmkZ7dbN266xO11IdOIH2G+rJP+UmbD14CVz21EZ8L6EvhOAbEJ+8nLt1GZBj6J0
	yaRGcHp740ikB05Hv4Zr1iuIjtME5ZU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770797612;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wosffRiOYStgrb1M6Bi1sC14SSDMH8Tg3Aw0IukakUI=;
	b=dnt/nrfgGgDQvE5NptGUoE0yuf/teIZX+sqUFyBU7ukHF/IvHzIlLTD239pvekdw5LiDel
	HCaYi0ME3M66cKsSb22TTKWFJpG9OWNdDYDjQ7Hl00C9x0G9783q9Y/m3g0ygRXvEwlepM
	4P3WLiNhrAMI6jDCOuqLza67qBrrVtg=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-43-_738E7mzO0OjcNAo3uxJvQ-1; Wed, 11 Feb 2026 03:13:31 -0500
X-MC-Unique: _738E7mzO0OjcNAo3uxJvQ-1
X-Mimecast-MFC-AGG-ID: _738E7mzO0OjcNAo3uxJvQ_1770797610
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-38310a79f92so38967941fa.3
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 00:13:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770797609; x=1771402409;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wosffRiOYStgrb1M6Bi1sC14SSDMH8Tg3Aw0IukakUI=;
        b=VPcB9RCzcN3SV7U146delEC7VgjDqamQeMaa6SqVCM4q2oZY00VbFtCbr9jiU7LiP5
         xDa6vsgshDfGDwTgOeYKbB2qyqy2PbLVm1343Pe2kbFWE1ZDMKu18bEDQetFT9j2Zyj3
         WurBWYS9RIqWIY/II9eKP5e6WVcLNEGba+NIF3/qMc3+HqisWO305hiqe7B4W2r4b2ac
         zOzyNejDTWftEUUlWFPHKJFaRTZ5iz4xvunb/TDioo9AhznvRGrQvy3cfaLYocAGTftB
         s22BP6K+ziXOQ2D/Twpt81ti8Um4QvRKvbLQxVIXydSrzvNoH0YF/nuFPTy9WK0BRXc4
         DmdA==
X-Gm-Message-State: AOJu0Yzk0jUcL1kksILyiX3FBgT/jzkYdr/6Vwq2p1btjZW4StrFTHag
	M6nzcxNeArY4lvSOXDTe5f/2w9lz9Xd+4rFSs/+PqtEHcnWSM2FPdYtIphDHPdtiJVsSL6dW95t
	MP8aAD23Ln7b/iTA61eBoMIQBg4vLbtcgEvzPmp6e3vocDfwD293xTVaZ3A0AyMHwDTQBSivD9V
	JMPJNvrd20Lcb1V2qcV79AQKoykmJXuag4Jl8=
X-Gm-Gg: AZuq6aJQI9aRQqEUSnNbRQwGC+dgIYt7ukq9WMfZz1vIgDNH54ozXxWb9vFdwzgo+xm
	WMwAK3m6hUQJrMhhxWn9a/mr8qNVdy1aMyaTpwE4wtTgoUncwgRM3czWlSpdayki5QJ+/i0Bz4F
	tDO3GC+D9WiqK52EnRWsR/5R/ObpgExayCtETR1gP1DDlNEIxQyiH0dp+IXwZnf/Z/UZCVc2HA4
	iGq8wOfT0VhpgPqqNqvbuyjDOpxjCVwMo1gkrX/fi1+N/bs7Y7ccaMwKnowvvFIy7/3w54i5xhx
	vuTZmzXJ0nLRE6QSD8zKjpr6hZqycR0dKK5i6KuXp3Nw9t8CBdSPPPdTr5x0iPvnEIzOC16UAyd
	YBDLn8VL5J1gJS5sXUbcuwdqdJtNjl8vNU8JU
X-Received: by 2002:a05:6512:3a91:b0:59e:465c:3b21 with SMTP id 2adb3069b0e04-59e5e23124bmr410214e87.41.1770797609330;
        Wed, 11 Feb 2026 00:13:29 -0800 (PST)
X-Received: by 2002:a05:6512:3a91:b0:59e:465c:3b21 with SMTP id 2adb3069b0e04-59e5e23124bmr410194e87.41.1770797608838;
        Wed, 11 Feb 2026 00:13:28 -0800 (PST)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59e5f568737sm188515e87.21.2026.02.11.00.13.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 00:13:28 -0800 (PST)
From: mpenttil@redhat.com
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v5 1/6] mm:/Kconfig changes for migrate on fault for device pages
Date: Wed, 11 Feb 2026 10:12:56 +0200
Message-ID: <20260211081301.2940672-2-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260211081301.2940672-1-mpenttil@redhat.com>
References: <20260211081301.2940672-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: sSIYGdzPTXozcfmaKxBTIKyjSo3te69Z3vGroWr1fVI_1770797610
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: yonn7owd1omr5736txusoha41i7y9e49
X-Rspam-User: 
X-Rspamd-Queue-Id: 5625B12000B
X-HE-Tag: 1770797613-638374
X-HE-Meta: U2FsdGVkX1++KAsrm/tUq6ZImD8B8m8b5f3HpBUE7X0ecJinIQbQGZzYXLUJFYDbkjNGZmqYLXFTOpqFCkU4sLd+9U/n5dSdZphzz0Yn+EH93HX//Y+KbzOwFgcs1VDQscutQ7TfnXC6nBe6IFZ1ZKeDVT7Av8spstyyqxUgmcWkCgyioLcyZk0jqYydn8DxrzqHYoKj2ZREVUb5dFF3rpBGTrs6Xa8DOe4hWMMlLtG+1zFZ3GI7gM2FmMk1bLwcSTEAlL+frdz1VnEGfx3fSD3MhCbFAIHvqX98+4NwMhrAiwlQL1MvdFQdUIq2qpwP+ZEcmtKtRj9Hrwg8FRv8u/8QjcMpJsqcFK7Ap0A49ozbxA+Iz08WnSGEQUA1Wr9M4i71FqcojWGdwSfOwdoLsP1nXwa3quPrBvwNpkR5xkN/d2iRUw5RK/jbyJgBvoKLf6ybR8rfopKKdVrX1kut7IkzCjw3rHp//tuchvfH8Ht25TYdJLBi5PMNYY779Oqk8zOwqVfGdkh045AiXlR2cZZB9CJgRxAjEehhHj/GR959pCSmiLki3dU3Jg9OpA9U+pKF6Wong+a68xGCxKgqVpsWDAiHk1ftaN00AP2mvj4T8QuqIEgOu5udvYEqcc6QR2ML6nVJZ5Lz+ZHFyh6Al0Lm3NCNQdI78/yinMgqjIue7fBmZq3cWm+5rWx1EMwbQYzl5Mg7WdZkQ3ncgHoywhFW6TxPQ/3GWfJ9C42O6pv3CZLJKuurbW4iZWjqoLPoEr3Bj1nJ3P1HOjKdPnDgcbPVpJwQnh3U3912UboBbzgop33NIitJ0BCjYuH+taBzdRpK3N7U9/67H8imjeqXjbsMSkExTIJHoXCOgeuxUxAByhiUNc3DiYvPfHb7oG7ECBFlKqCgy0snVZkQ8idGn7lsWH0oIoLkPKKmv7R90yj3nuIUTaDGNlWkG6Z6h/reAJO+b7ZRyN98OLdFnX9
 uzD4KsRJ
 637ArqfZPXJiP1tN2CKadtp0KC1KFz/+hvxOpWkKUG1yEfbGfGtUeRSUIaHw0sPj7XsCctPxvmFz3rlg8JIIv6vy3IZD7GR8vChJ7Ish0+iyxtSILGST61jG1wcFtIXLgqZf9PrQx+stgJ+yOdR0LiZZWJ9te9m/oY5VgOhUtN3d2oupoDfKA7bXXTWPt9pUH6LU/SN18B+xggmq7y0LifMkv8c9DVg/drlQ6Tvm8ZVTBFFbomX/wLFvZNXxqZBGRPT6yb93jIoRPDX1pooWRukNo64fRSnGG+zQagRcuAGOEtp6k5xuoXUmfBu4ZcYQilxqLR5nUfya2Nptirp77W9zDY3HCaqWuzOaEPXl5bOiLk9DTAsJj1cGaT6sh+Su4a3IJcTZgESjUaCLEGHY+rOfuX8TBgx7ARg5vq5HYGDp6AEykUcZEb+/LwlAluHo3G1Ogb5HUcOQcZ6sKN+0i6QhfjBUt2nCuXRNPbDSV8FEdXj8YMnmqfXT7NDt92hQ0bao8UsrWLa5arxQrVYYgCrWkhw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Mika Penttilä <mpenttil@redhat.com>

With the unified HMM/migrate_device page table walk
migrate_device needs HMM enabled and HMM needs
MMU notifiers. Enable them explicitly to avoid
breaking random configs.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
---
 mm/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/Kconfig b/mm/Kconfig
index a992f2203eb9..1b8778f34922 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -661,6 +661,7 @@ config MIGRATION
 
 config DEVICE_MIGRATION
 	def_bool MIGRATION && ZONE_DEVICE
+	select HMM_MIRROR
 
 config ARCH_ENABLE_HUGEPAGE_MIGRATION
 	bool
@@ -1236,6 +1237,7 @@ config ZONE_DEVICE
 config HMM_MIRROR
 	bool
 	depends on MMU
+	select MMU_NOTIFIER
 
 config GET_FREE_REGION
 	bool
-- 
2.50.0


