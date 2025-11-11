Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2623CCFA13
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 01:00:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CD0F8E000E; Mon, 10 Nov 2025 20:00:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57D818E0003; Mon, 10 Nov 2025 20:00:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4936B8E000E; Mon, 10 Nov 2025 20:00:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 39D268E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 20:00:47 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C867987AE7
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:00:46 +0000 (UTC)
X-FDA: 84096521292.26.C5F2F37
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf17.hostedemail.com (Postfix) with ESMTP id ECD4C4000F
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:00:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HAyzilsu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762822845; a=rsa-sha256;
	cv=none;
	b=YgBVCtmsfhwI9gywvX4jNXa+pHMQT+2tiVzrpGxeVTYnkqMVudyi67mJvcUNiV1jYbqbou
	+Qg2ubp2GCvD+dhRQjMELeVqMenDOiUyf0pTjO3sp7uL3kLxwe6nVSeWReDRMXmZPN0ziK
	ggTQKBZpeAP1NLYmDArWisTdj9T00wg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HAyzilsu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762822845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e8DKKG/b2Ml/VevY+oANvvTeILuRGs8NqX1/6ypJaMU=;
	b=iufz8YVCUhBEoobsstwNpVnS3F4tI2+zSD4Eg9PFzYuN8H3eZXITFiytDAg0Cp+6tEqYoz
	gYUutOgm/FuClf9JV/43ttTt+jqLu6do+O9Es05UDPEmk3ZO9/tQR7v0TfZZB5qc1kLu9E
	2IL/yyVF6xERWDQNG2qHfErdRolj7WU=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-77f67ba775aso4315727b3a.3
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 17:00:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762822844; x=1763427644; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e8DKKG/b2Ml/VevY+oANvvTeILuRGs8NqX1/6ypJaMU=;
        b=HAyzilsudi1GuGXFzGKd4VP21fNlgfNT+9W+kDef9lIRbs/CA0ZYiPGf5TQY79RKPV
         elXY7Pw60tfTp+CMgldpwt0Rdi9JhLNRNwPZTJeSe4SPyL87+goul2SxPoXQxgtzcRC4
         JeEomt6x0qqGUz2bSpg8oyKu6SavX4H4OJXiNJDnjzdLYxJrOoWN6f/q9Vxi3GKS8aRA
         enAaH1je7llUUUdavyP82PUm2c+3R9rwWTYn65QdyroxQhaXtajTECqKC9kZ1YuWSry0
         sZJilLSyywBsbprIfenaFqnK5oNTw4ucTcC9YQooeN9WaTPC6T4BpR4cDsnXOzvG222L
         UMeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762822844; x=1763427644;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=e8DKKG/b2Ml/VevY+oANvvTeILuRGs8NqX1/6ypJaMU=;
        b=SMlnya4cFOZ4Tn9eXTS1uV9HComASp1xtKv7Qb2WdO3vjcsGe/cahsqtrqIY70fMRy
         VRBTAdtdHet+kTAlM+IluIrBQDaS05rYcTPgKA613JOO4GjZz0SYDmtBXYAaFcDbVTSC
         qSuWrlFdUhJFmpV/D1J3dUdReDH7BD6OFNEeFZjBaxdHOoN6nv7yndag/xUxCpfgt8yt
         v+ylx/O7vZRutg/Xmgrz0Khv2MGvdiV3rOpGqbMjqaDBIfJTNSSloZUkG5lTYYhUxJBr
         3HfXG+hvHMuwE/XKGK7C5Js55nXyTW4fXb46X60e9VSSHKqeQyCdvGHSlf6SLDQz+u0o
         bV9g==
X-Forwarded-Encrypted: i=1; AJvYcCXar+OdIbfFlsn+ckiBNQJvGqXYgQ13p373uRrGwsXEJuwcPiJZkFQ5ayKOKzjhIGMLidvk+jWaoA==@kvack.org
X-Gm-Message-State: AOJu0Yzf1Isx1T7F7hNyw4CuQhJhaYUJW1M/HeT/E/6FxnjAbHmBj18k
	TNJASHUlrkBLNysmgq6M+0pdt220lxXpwlrqh6BbjJmmAwz16i2cJftd
X-Gm-Gg: ASbGncswCMrKrGAB/xvlnAKq0E5UMxRlmKIPfo3pXxU/dxiDy+HtLV3ePjxkTvGYiOp
	QsD+hnP86auNK2T9jtPGsyPhsugIjkJMzMDBjTI6umi2c3YCjuJFqarfSvylkeL8KigRkiKT28n
	cGAxoR5WBelGM1heSeSQ79qXwY8H3SSO6qpM7f+icTy2W0opw2uKFMUNIo8w5meonnfXXJaq54I
	c1aDlRpyYQyc8NX0MH5rf7n7U4A5TD/rkxqBBCQnMo1uSLMAK27BjUK+acwUVhb3HwSnCg+Luk7
	3KEkppKgmYRJ+SuJvINPBHBYmtueqrwfjjdm/vWUbkNLdVYaOpgb3krS0lLucaSyadI1AtMANbF
	QEUNFYp93tXq5PanMbfoi0ue0z7p2YZz1B2Hkb/mNQGV/sv/kg3v/UWijSDVPBh1whzf6Z/uoYk
	f45lB7K8rs0JXZwVe2sdpedComlA==
X-Google-Smtp-Source: AGHT+IFxgrUWy77gbsunqJhGkWdQe0ZI1d5eQkSH1uE+PZ2zCTXOzCFHVH40iYpbqAAUkEG/NUEFKw==
X-Received: by 2002:a17:903:1103:b0:298:43f4:cc49 with SMTP id d9443c01a7336-29843f4d12emr612625ad.24.1762822843523;
        Mon, 10 Nov 2025 17:00:43 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:d90d:a2eb:35df:9157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29651ca1b8csm163515505ad.85.2025.11.10.17.00.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 17:00:42 -0800 (PST)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: rppt@kernel.org
Cc: akinobu.mita@gmail.com,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	dan.j.williams@intel.com
Subject: [PATCH v2] memblock: fix memblock_estimated_nr_free_pages() for soft-reserved memory
Date: Tue, 11 Nov 2025 10:00:10 +0900
Message-ID: <20251111010010.7800-1-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <aQo1VjjQw1OZG8nY@kernel.org>
References: <aQo1VjjQw1OZG8nY@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: ECD4C4000F
X-Stat-Signature: bpwoo6s1imeb1ytctu6ndyxgmzeg7kze
X-Rspam-User: 
X-HE-Tag: 1762822844-918690
X-HE-Meta: U2FsdGVkX18vXd0nxuj/M9xcIi/I+OOMJk8P0W3lhyVAOUsG8rJ3wr9LWL9ByI8NbC+HyjHwTIwy22tSDHjx62C5iYlcmM6XACCyncxQycxr8JCPegvnzr85R7g7WFBtEzjAT8QzoZ2pzSmhCfb/OnGUGkIhRuJgqj/0i5PyEVRmlTBrz30LIYUg5VUcFpLJPDhAJVww3J1gB2wQpBloMGOxwWTRj2T0exRRKUuiRhMGKF/Xmnv9JRV/vi9TtgQNlkSGcUg0YDSEmI5z1Pw/PbWayntxGJGNPplLIbZGvRUt6IP5qCh5fqLnTaWmfXlEs6OXv6mgd60iV2RnG3VevrVGXGelknrNds2KXbstNkX/u3je2jG+k01KVNttymWi1jPlNCHfI6XLTRSlXW9qjyINN9N8CSq7z4WJbDhHxGdqYGa78Od+ra7wFTEaevnrzKrz/Dsu5r+8MJvc2lTMvJgzz80NrnSIrQ4JU46cM4+IAZZy2SYHvUyfX+qFArGR/OBC6EpkR0vLpmOC23Mi3eYCSEFYHZbvRWSF0BIKsBv1J0omKwmXJYMr4wjnEnBbN5wlJy6V6gHxAc22qepflZO3vkMSBOMff50Ntx6jMuRcJXDNOkZWotYvyP9vQN6yzDD3V+dTtXI85oXbPmu2H+sbiyoELVmn7v4xM8U2cH9TsuF4WVJgXp4Af4uiKruJbQleXoa1nBHVG74lwhjYL4QW1xNLc8OgVj8Gp+uW5Mr9czi8sKm6LR1NDAn1+sjb7Q79Q4qaysWBLSD6mV8/ZIMhNjLO88XI2XX7GF+ZAz9SWMcUFC4eymKQubQBlCBRS5hNWyZarLDo9xHzGCxJ9w/Sp9AzIk6gcatGlpByoJWin/KV9YcRwArIMTicmj0bNyB0W0cgnCtfaxt3+3FlBG8w3ugcgjDb2xtZTlFXoCcCNvvqYLJH/2gTrg9dm0PtGCUi2FoTUSMuLMOnzp2
 kBFnyR56
 8U18zwX/aHRCVOXXaHzKDzT5E5eWL4/fpixTYnjhbhE4MV6DXES0IiIBcIdlhnyyxvmpfLimVnBoA7AfyGGtJjycmOLY3qsy9y++1nwiWDjiopAREI3abikzgz9MHg4BejcWvvI1t8nvypAzqIi7GI5joJ+12gIuUNJ1F/XE6y5jolp6K6jaiVxHKbC8tza2j1EY2c39w3KLlqYw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memblock_estimated_nr_free_pages() returns the difference between the total
size of the "memory" memblock type and the "reserved" memblock type.

The "soft-reserved" memory regions are added to the "reserved" memblock
type, but not to the "memory" memblock type. Therefore,
memblock_estimated_nr_free_pages() may return a smaller value than
expected, or if it underflows, an extremely large value.

/proc/sys/kernel/threads-max is determined by the value of
memblock_estimated_nr_free_pages().  This issue was discovered on machines
with CXL memory because kernel.threads-max was either smaller than expected
or extremely large for the installed DRAM size.

This fixes the issue by replacing memblock_reserved_size() with
memblock_reserved_kern_size() that tells how much memory was
reserved from the actual RAM.

Suggested-by: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
v2: instead of subtracting only the overlapping size,
    replace memblock_reserved_size() with memblock_reserved_kern_size()

 mm/memblock.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index c7869860e659..905d06b16348 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1826,7 +1826,8 @@ phys_addr_t __init_memblock memblock_reserved_kern_size(phys_addr_t limit, int n
  */
 unsigned long __init memblock_estimated_nr_free_pages(void)
 {
-	return PHYS_PFN(memblock_phys_mem_size() - memblock_reserved_size());
+	return PHYS_PFN(memblock_phys_mem_size() -
+			memblock_reserved_kern_size(MEMBLOCK_ALLOC_ANYWHERE, NUMA_NO_NODE));
 }
 
 /* lowest address */
-- 
2.43.0


