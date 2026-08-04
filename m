Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B817BC5518F
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:48:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C37BD6B0114; Tue,  4 Aug 2026 10:47:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE86F6B0116; Tue,  4 Aug 2026 10:47:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A89FB6B0117; Tue,  4 Aug 2026 10:47:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7BB356B0114
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:47:56 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3FD081A00E9
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 11:11:22 +0000 (UTC)
X-FDA: 85063320804.28.1352042
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6D2E640009
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 11:11:20 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YF8xGfBt;
	spf=pass (imf11.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785841880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LgjopR4+sMbnTCcng90CwjYxmC8eTU75ghK8mDOW5JQ=;
	b=onZ1yaO+mBatVHpa+flxGi1/yZP19khdv1MgGiEsUC4Ys38IlRNTeaSsGghaDmH3tuIWIC
	g8yZpQvbfo4x7TotESnH6pzg45MqtxdbAPvw6CvgCCprEX7I62obe3d5v3GXq/dxhpSZCI
	kfpaldoke8cUwfa0Ji+nmwQv04SpXCQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YF8xGfBt;
	spf=pass (imf11.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785841880;
	b=h4vhd5BDLM0DHmmd2WFTWWUdwemI+7L64+VoIgjPHMLKLXpxadepRS5Mk7p5YpteFrAnFg
	iqp7Aoj2hWNCNDaCY6NdSzePUJziL3XVUaiSQfyds5kK6a/lqJyYLLWWi/mk0XR5Jgo5Bw
	Zc6VkBPQVPKY9kFSyS627lH6ZAHbK8g=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2d004f135b1so45309705ad.3
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 04:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785841879; x=1786446679; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LgjopR4+sMbnTCcng90CwjYxmC8eTU75ghK8mDOW5JQ=;
        b=YF8xGfBtwIbbr1xI+mOS5g0XyIEp6XgcwaxHhXf68WOBsrPNA5Wlxor0trGTn93WJz
         FKoszKT0eNRtU+53zE4OztQn7doJK1YsDg2Jl5pFfVjDCbfp3WP1PGweGUrdkIqXaofl
         VMgzYdw6yWeHqTZrRFIdlPOBhNE/etHJOuhH7gQX98gc/8JROVetZL85sQeqV15219Yr
         mR1LswYV6rMKsjBn1qGFQErFBlzlGY0EcATEyXpgGQnRura/S56PzKLeRqFEFV2uvyqf
         ti5DUoWBcHGnYBLlCKuxxIfVQUZd1gL7P4+TuRori2H6PJ8VqVZ0jF8zmxsaMqFqhPgv
         ZJGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785841879; x=1786446679;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LgjopR4+sMbnTCcng90CwjYxmC8eTU75ghK8mDOW5JQ=;
        b=G4IGEMjQ0qlFzYwefxIbUYvegtKQ+MkZQEA6cxxMFzhbnt/Lu6hL6M9WQ8BAoXrM4b
         2v6RUALI4izE/22rRiyLEK3fXxZgHvtFMOSbIHgsxJqN390tZY2h5AXcqIP4XYqbdI3H
         RhtVcN6lWZttwgrPsTVI3qyi0Xv1gUZFLEwe26sqBDmNhHsmzNiqWz9xKNsYvjVGzb9i
         KByHxZvLNqtzUgmiG+nIhc6/NpVZDB/2rvZQFdViKeJ1u7Xvvl4XLE3+rja317mFFRG8
         zrFeO7VNKF5dK5ytSL79QE4Gz0Jbp+qwnUD7nbPcD17fD103qZgav7p9BXyuBO2nQeXI
         2uQw==
X-Forwarded-Encrypted: i=1; AHgh+Rog27VxXzoDa6N/G/yOT1NPHLL4fpBoD5mVAitOvD4boSo/fvnFpTCD2E6stMq9zB+Y+WZeV4knNg==@kvack.org
X-Gm-Message-State: AOJu0Yz6Xss5fNe1lFAgFNq7TfDCb/nbl0GZlgtjQpga9bqWW7cCNvXW
	WWxm6xwjxZYv/UNK6eXik+8BGcjv/a3sF5138fM2gOmsGoHbyG21YxUV
X-Gm-Gg: AR+sD10wX7hpqa+OoM48ZxFS3Pu3m2dAHX5d0DEtc6WaDKNPnTWLsIzTRHewEbaLfYT
	8x0aOkgAK3PoDFbh/xHGHueoeXLxNhx0EpMdk60Cwsy7pP4OFN1zRQERRT3AnIoD3CGa1pR6nub
	oNmEERLH8TsooTNIattQlPcQDySW0eTmeetI79i6PojB9DGr63lDMHgtrqSdCRVbapS8wANV1Ow
	EP735JjZZt/vxHbsp2pAE0GMk+igvDDJ9RZFDcofcPRoNzyYfGRdTATIpYYamIcAhNfVOPo7AoG
	9qv+A3hngRtb++gnzomg4+dlD738HsfZ/zKT1cIY55NOlbtQ3Gkvb6Xw8ysh7Kqj4MHzmsSXI9h
	UPb8cIdJRSiMQNakT6OtNg/3M79bQ+YBX0zRm44Me3yOhon9crD0n2BoW6uTDjPXJ8zUlvEvwM6
	bDtOehCCY4NIp0Q1Jw7BUP0yszK+8wv10UByl4c/CaPZ/EihW+k6pY+6VEGRAajdxG7wbxF1hkC
	Y7WP2lkLgHdvov0tqbKiubxOKsegKlcHA==
X-Received: by 2002:a17:902:f541:b0:2ca:5970:732d with SMTP id d9443c01a7336-2d0524810e8mr139202435ad.41.1785841878309;
        Tue, 04 Aug 2026 04:11:18 -0700 (PDT)
Received: from NV-J4GCB44.nvidia.com ([203.18.50.8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d0a9f9370esm5403285ad.8.2026.08.04.04.11.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 04:11:17 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Jianyue Wu <wujianyue000@gmail.com>
Subject: [PATCH] MAINTAINERS: move mm/folio.c to MM CORE
Date: Tue,  4 Aug 2026 19:11:09 +0800
Message-ID: <20260804111109.393127-1-wujianyue000@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <anG0QwQddFNo8PKJ@lucifer>
References: <anG0QwQddFNo8PKJ@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6D2E640009
X-Stat-Signature: heb73f48nsj41j1hnc1izpctpxhx381y
X-HE-Tag: 1785841880-124932
X-HE-Meta: U2FsdGVkX1+TnWnv8Xm9JwBt010fngCHZyqj1R5aT1GkzA5FKIntXTTfN84x292hCPArXsU6dASlKPxkwnau9EeN+11i/TI76Zn1WU+Uf8RFIFgAFkAEFcPVV3QRv2SO8uOJEwiNOEOHeN+lcmZvStgie2umpnA+t1FWBXTqehN7AmQbnc61IA5OGejE1ZRViHDrP4HCq6WkOdeAdjugW47ROguBk2exvSgIdWrE9kFrV6IFZTnvnxNTeabSTDGoZXKBS+/uFgClvl9W/yswRM1A+ZMJGv9yMlqPrTFkzHcEKgZmOPVY6GSM8E5y/lBRHITWXfDDxRsJZpvYdiRLLUOezCO+NONtBv97wc15zfzb/0qO2e4TgWBmmobTGpJyQWy+CqgLaEZNqjTAXsAyxYZqq/Fd2Yfscf9/7kbZ4WvgbV6/feJsWrBzN/fjqkb6c9zWwdyApaMHVDg5gi5DDaFTAXxtfe2OwhPQFsfHomZfFXaO3LdanQYICszEOaWiml9Fp9oUdDFtVNkR8TvejE58Xg5tmez0ZfNFfWp56KBOcSXXJ743v0wbHFH1Ms39Q/87BffBh01ciPLm/PvWks3ROL5moLVI9u5It3LgynKCphgplnJgRCtGpjGjoSXRUK67ahrZ+bigIJcTj+RaEv1HXs2LjK7mvqja7ULUk/MU79sYRw6rBv2Tde9wZue52Lxh4AUJvM+1yKA7kMwzlLMw1YAHTSfkxnv4WJ/XMTqXR+mvJq13IZY8hFhERWiT1KhqykdwHHlqNKkF8RGnoF7tZDU1M9joIzE1SoHiWCMDRs26bcAWk8c2so+WLlqYNZvJbt68EPzqxRH1I2zuMHQrb5gpRQ2knGIeNxjd5GONuwg5g41391nrj3+OLJD6B21JQhGqFEEzxc1UehYWnfYXZMx3FFV5b360RfegjSFol1+8oqqbrjluObkCrNn6BAYOnuFpRV7DVCxn8an
 Xk+hCOFr
 O8QH094VjZDBMtcvM6nEQ3YF7pl5TxqqnG37NyXx61fL1N/VrcZml+RWxIgJJhPhePPUVXbRVIQXzTzdhIeBoKNIHMr7O73ZhPi4wX5f0hiqq67burTTqIS+GxMnRpOhvpLrP0VkQioH0eWRFl5cLDIOdYGxv5bmFuiB7qiUldklyxPpjXqpmGeDn9j9PW8RXUg0QrjE35bBMRUUYKD7OrDzaK6AV+RBlIjE7hRobQ95gax5frelINdKyhDNtrHZZcM/fMIiFcuc2xRh+U1THqfJvGZvqIOUhh3Lkavh6pQl3DXh+tTFGNag8ok3lvH244w0eZWjMKtpultGFKFx2hTj//w07BJAMotT78hs5BtvN6/fWtlrnRPFVWHpmF2VfceSRtXd/Wa8e9S8IDjlhqk/2JmyeYIUtcyRQ4H0a8e2nx/YsQJjY/CYVV1tccBZbfsziwUTCm3omasP7ysT40zvOGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mm/folio.c holds generic folio LRU helpers, not MGLRU-specific
code. Move it to MEMORY MANAGEMENT - CORE, next to
folio-compat.c and folio_batch.h, so get_maintainer.pl routes
reviews to the right people.

Fixes: 8ed6d702d442 ("mm: rename swap.c to folio.c")
Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2657cbf6df90..e9c8567308a7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16990,6 +16990,7 @@ F:	kernel/fork.c
 F:	mm/Kconfig
 F:	mm/debug.c
 F:	mm/folio-compat.c
+F:	mm/folio.c
 F:	mm/highmem.c
 F:	mm/init-mm.c
 F:	mm/internal.h
@@ -17091,7 +17092,6 @@ F:	Documentation/admin-guide/mm/multigen_lru.rst
 F:	Documentation/mm/multigen_lru.rst
 F:	include/linux/mm_inline.h
 F:	include/linux/mmzone.h
-F:	mm/folio.c
 F:	mm/vmscan.c
 F:	mm/workingset.c
 
-- 
2.43.0


