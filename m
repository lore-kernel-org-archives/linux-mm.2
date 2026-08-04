Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86751C55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 15:12:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3B606B0107; Tue,  4 Aug 2026 11:12:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B121E6B0108; Tue,  4 Aug 2026 11:12:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A28C46B0109; Tue,  4 Aug 2026 11:12:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 767076B0107
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 11:12:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E120A801B0
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:12:36 +0000 (UTC)
X-FDA: 85063928712.26.694D94D
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf31.hostedemail.com (Postfix) with ESMTP id 129AC20003
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:12:34 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rLAs1AMa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785856355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oZg/83J6jaYapJ+FDWL5X9kFic1mYHbSf6imxqk8cwY=;
	b=IdaOp3whRGPm1Q+bCFDpxUQP5J38fKZjIfplgdORr7Mn5Bls9Zt2UJxgInb+hP1GwmJWBv
	SnU0I6QGHyHbCFNTOVI2Ls4XOx0t7JNtO8r/PQvoTC83xi5+jwI1Igd/BxhdM4FnPPwqIz
	weFSRw6Jae950a3UWH73w7ED2/qSdj4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rLAs1AMa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785856355;
	b=MD5uyqGUl+J+h/wX0el51XNVBR0/Oc9o5X7ji0DEzixE1naB4/E1oSfD5YGdQPi4Mm6LHj
	fwtnE5EWNZ1tyIufG8VT8tPgyE2HnlL8auoAW+bpWFj2DKic+dX/gl8/9IR9qJo5eUyK8G
	/7NTj3MhF3tF8gUhQibUGtIaajjPxNk=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2ccf2360620so43044565ad.3
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 08:12:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785856354; x=1786461154; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oZg/83J6jaYapJ+FDWL5X9kFic1mYHbSf6imxqk8cwY=;
        b=rLAs1AMaHNHBRhABhDSNdQUHlVrb7z2JHDBgLEjKd82OJMGR7VitZmPVDEZzJ+NG2S
         pwCH9dSjUqqhexgc/a8CKAD5pDk6gt+mg5Gu/oY4x7PwsNERvkwBY3P2T/wCVCr3YRLW
         d9cZ6JEQAJkElB7ed2Kuznrwov8H8+N+9oejNy5xOkbyKq+kKVEMCXu5e+eUKxLwEZ3P
         imoB5o/CEC1hnaUMPtvK+7Iyuj8c8SotaXDI2bljZ6C/nZsWX+ea/anAr0KiVRRsZVMp
         YAuIFHZGvZMZmVncLpz3uTAGaFV9djrsvBaain6lyClw2l9/69rLtHM2UXnoRN2Q12Da
         /noQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785856354; x=1786461154;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=oZg/83J6jaYapJ+FDWL5X9kFic1mYHbSf6imxqk8cwY=;
        b=msmPta2ybiwWsZnM6xwe1xd5m1EMGDRWMfjGXfS8eQR3p5CC3SzebMrTymp7/UZuSQ
         IlomZVtxifQw69D4Xy0qCBC3ZfX19knpBm0vszW/mQU4tcR3Zz4vubVLuAnF1jMv2wny
         ERL1gn1mz9rcP8TX2rufJVebucg2qZ7/PBa2VVJOm2ItWDI0Bh8yTnKONDJtbgRhKzjI
         ztPw8xDzSWQQT3IYd8I+Yl/teJVo4zxHdQgSaTlKjk2G/PUz1PxpAEoV5MH7nDQH+bcl
         yDWgJD3OW0wt+dXqv4y4mCA2gnwBnsuSyfXqOx8H6FKAIqTxViwUc3PGc0uA97aFUSAg
         5AGw==
X-Forwarded-Encrypted: i=1; AHgh+RoRKS5BkyrOLh1jmp6cTL4Sr6N1iPbNznjjsfOJgmrcOjr1+gyr3q8h/5wyhaH9Ko4DpHD4Vr6Hhg==@kvack.org
X-Gm-Message-State: AOJu0YzCT6xtlPzApltTCCPhE1Lut1wsrSw4LnEoGUpdbTABVBUqkfWr
	ZB3DlzcOowbu3haJt8LdThFxW07kwRgpwfwsrklR2xDO0jwU67wvqF2c
X-Gm-Gg: AR+sD12FTiwyNtbR6Nhh8lfJNdcC5a06iqQpyHoTG37frWcRRHXkMXYRMumR1C1n9N5
	1vMycYgKOVNcD/NtxOwlLoZkAE5za/B3Pku5nhh26451g+o2QYVvu4mdb+RfDESFHTzCizgmzQ0
	pMIGudixc9ulJGG3AqkQ2Ee/WsiN5wEIY0u5aTvJLw0jzsNvfgE02zwH1+FWTsBc8EdAyZFV6PW
	chizBhIo1S3N0z6VASURpODGLt1iCWhdc/x/uw7cqojHyGXONSkTVT/LiOG/LqTYVOGIeKtN14t
	LQjn4pxI+Rf6/IPH/QhMTFipWN06NDaAbD9s82LEH3aKY4UEUYaYzkh4mrlvzc40Aqs/WKMgnz6
	M6M5rw3pHtxOaAkpjuz+sffJm3Sflj+4+NPY1CDrn3H4UprdmIm7fuELQehgMHznuBGkBEvwEXL
	5C6Fg5ouMfRlyTRGp8np+0/XaBoSZgT+gyQjaTzPi57DEuy8bZ/e5DNvU=
X-Received: by 2002:a17:903:2347:b0:2c9:e9c7:2b59 with SMTP id d9443c01a7336-2d0523f7767mr135616285ad.35.1785856353923;
        Tue, 04 Aug 2026 08:12:33 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d0aa4d67dcsm9219905ad.70.2026.08.04.08.12.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 08:12:33 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH v2 1/2] mm/Kconfig: make FLATMEM depend on !NUMA
Date: Wed,  5 Aug 2026 00:11:41 +0900
Message-ID: <20260804151145.3419768-2-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260804151145.3419768-1-ekffu200098@gmail.com>
References: <20260804151145.3419768-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: urdbzqr65ybmsrdzwkkqcofgncbezjfm
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 129AC20003
X-Rspam-User: 
X-HE-Tag: 1785856354-744621
X-HE-Meta: U2FsdGVkX1/qNtDgPxSikJmYtjJeCjfjgIlN69j95aaHl2jGV6Zgkm565P5jEfHj8nwOORfJ8YOU9qmxBebNvgykyWLTz9tIcPPjZ8+AgeVIbZbMofKklWxmNYtWpQ583DiDBEfcTAxGd0UhIDlra4umkuCtM0p1xP7Pb5boByDaG63ft4qB9mYpVNDyV0JBLhoFsNzRlGY5w4/3oQxwLnYU4OPY1dCzP9OBrSF6hDdGOF5FY9DV4Po/NVQtY9iU7LmX2D/muxXCd5BKZh0k82PCLUBlotbTY/KBlJjDvt+RInTNcvfxhgioLHSER/0bZRtZN/eJgzlOHp2XWxl8RLt3kp3e4IeOjPwe00Mcx0ZbSkSfm96/w/N9/DQoawZeIrQc8/rBEfJ1QVr2VrM41N5ywbD1rzGhKrTa+dtUL6Tg/1Y8AQYaTZvosGXUoGJlsRLj1Orglju+tBFxx+XUxQEMttvUTRpjAJqFCgo8KQ6ECCd1b3REJH6ZY5h1ruIo+knURMMPU6fzich1VoGxAtmXRK1EArpywDL6nBuvmqOQhj8UUR7VqMjYh+1aiuJk5JQnu3hMSwmbiWEi0+aLdsckgVnDbCl4jeaJKPdlpXTfV1ttJ8KHT52FeIdlMC89TJI/hP0VPj7zcx4fQNYmurX0fPO8bF2y6CMZlABpik4Ha7htOIawbVL/QLD9IcbjLuNRWAu53hhcnhfPkVcPkLkxgNCHwU0omKwJthwg+gyApOLZ973XEvqmoWTL+3SVhpfyeJAi3YMv1RiYUDShUGZMA0MHbPWRsLtOPPoaRSDnaBxYSEDyjG+pdFthUzGItw7OnArqsuDtxsJPneaEZWBlhBdlQC2wZp+HTAbEdSirqkkYT9WNg1X0NYZC1xQdNLlJKJDaP1Jmn54Y85z0IkWqVC/as7ZdOVdfACfF7Hl+JoK7ty8KzWh0n/BsW4iEH7WTKWjJMBo8MLds0ka
 5MmeKKCa
 LxUCa6B2nCq7kR5e4XlQ12M2omB/TUQWxoSvvgkw7H4GsWOmx//DyA1tq/eYDcfbEePwR/NoScL1GNgF/apMdQ5w9D+8PYQ+jhP9f6Ez0wq37fh7r9y78BoHoMan2viNAMD5be8CFvjUrhxE2N30SWCj6RzffHAxUWbI3YINNkeSR+z09P9/V2wpR9YoRwxfplWVG3Ds+0LMtMQOqg/sv9v3J954xqWrTkakQvUXAE4fxdFmcHJSwyPOCPKm3EgqvTl4P5NER9uiIuex3AsiY0f/REJ8rRtYD0MmUBwv8Y/IoQZHzlmirnwoi+HjFHEMXWHZsZSrWn3thE0vrHqCeDTX4Q+ztNHINsSLAUUNm4Ci+yCrST7WGokeERO/RPlWJlqSglUh7pIrbl2eotwQPVbyKNSPAiuFmULix039u7ctlQu/55rN+kZpWIve4zilaJIrdAYU8rW1TDPpG515HdQvNXkOT6ug841ZQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

FLATMEM + NUMA is not supported by any architecture and fails to build.
The constraint is only implicit in the arch Kconfig files.

So make it explicit in mm/Kconfig.

No functional change.

Suggested-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 mm/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/Kconfig b/mm/Kconfig
index 060190e12bce..331daf7fcfab 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -390,6 +390,7 @@ choice
 
 config FLATMEM_MANUAL
 	bool "Flat Memory"
+	depends on !NUMA
 	depends on !ARCH_SPARSEMEM_ENABLE || ARCH_FLATMEM_ENABLE
 	help
 	  This option is best suited for non-NUMA systems with
@@ -424,6 +425,7 @@ config SPARSEMEM
 
 config FLATMEM
 	def_bool y
+	depends on !NUMA
 	depends on !SPARSEMEM || FLATMEM_MANUAL
 
 #
-- 
2.43.0


