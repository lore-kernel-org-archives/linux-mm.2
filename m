Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9FA4F34C64
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 15:45:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B5016B008A; Mon, 13 Apr 2026 11:45:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1655A6B0093; Mon, 13 Apr 2026 11:45:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0542B6B0095; Mon, 13 Apr 2026 11:45:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E45B66B008A
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:45:22 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8A360E2B3A
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:45:22 +0000 (UTC)
X-FDA: 84653956884.02.36CA13C
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf11.hostedemail.com (Postfix) with ESMTP id BF14F40013
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:45:20 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lDzW3BDf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776095120; a=rsa-sha256;
	cv=none;
	b=68g8KmOend/54r0bqnitIy9iNhUpeum8YT2SlvxqwMgYbiYh6RfjUkCxlakVsY+Moj0nrk
	FfJZu6FedoEcAMmoZ807rZK/SfOegxkCLdenpuyASItURBi4NwHigzi1SHSMmxzAwklIKI
	aJzlAshL6TC1bSijy2J7grlLPjDLfrc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lDzW3BDf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776095120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=htsoCPI+ofgHrjo4de/zPWGfBmVrF9y41y6UhCLZPHY=;
	b=qDLC/E/SR+WgFdsbaNg7c/cMWfoaXrNYdUax7PAZ1kO11z4nkj1O9yBlu6bubpiXQ8641Y
	bBJdsi3s/AUMEFvnnfIagMw8XU9RHVmlZRdqAPb7EzvOcHTFzZmnMrki+r+tCU3HNI9+ll
	jUKalgXZ+Q589iXd8iXzaqLmJJUEZhU=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-35691a231a7so2991819a91.3
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 08:45:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776095119; x=1776699919; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=htsoCPI+ofgHrjo4de/zPWGfBmVrF9y41y6UhCLZPHY=;
        b=lDzW3BDfm76E7RlSUhn7hIJUOXeSswzSPDqwXcLG5DY5kSycC7XzQ9ypNVHtYEzs96
         eb76PVbh2yzfqLC+JzjeD/dXFCi3TYBisaZDrphCe8DXQnMZIoY0RJ1R6Wt8U/fSpYUk
         TcI1kpR/L6XZ3iuVjAdDbvVxJmF2wYvPkNJCcSc9AgY2ldFg/o4qQdrtX9lVrXmyAUcY
         RMa5QBqmdjVYimg86NgBW5qIHoshcufgunAO47C6NJNhucfpLgyxVQhCfnf2yVtK6Lfj
         NdLdlYgwwNnqZvAIdci0l/vjxjAHv7P5+U/8AGQ4bTSWEnNQbdXKS1iO+Yw1IsswvLdS
         J5VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776095119; x=1776699919;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=htsoCPI+ofgHrjo4de/zPWGfBmVrF9y41y6UhCLZPHY=;
        b=A4Q5JSNmPqJp+JkbYRcuacLVtQS/F8ikdMmt6yUXcLgdOpJoMAkB0sL2e1v7+Ne9zK
         wAtznJ6Pp+DnK/LmBmMXy+SS8eXpUM54EOTrlw/6GY2sMyivB+D8rCOetUA5QF15/mS6
         QidL68LdgtSxoyQKjKKb/cslqpkiL+Cu+DYnSu1rdnvr1713dG5ELyxH5WILaC1hBw0c
         7O9GN60OOiRNvPjZhPa/+QF/b5pYIM5WzP+R8dNDBEP6lvx5sXaTfiObEbNl3z9WaMCE
         qai9qZYNI9co9l15oeVICQoQLoPejF8pLKbJ2Z9/qO4U0lM71/3QYHpqYMfRWIozm+Xq
         6d8w==
X-Gm-Message-State: AOJu0YwjZ3tVL68QapxpPi9KTiDGrwAOVj/CRIqnPeyYC4z0Zdba7qQb
	zzG94VFhYIITC3LW31UVWX7icU5+XDIznQeQnDOLqbENFbO5GGPxo5kC
X-Gm-Gg: AeBDievm7YhuTMb2fqreFPHNE/ChmcOeni9vtFkaYT+JIz8aqf9IrlsQBQ6zXkJL9G5
	KTzl+wj7dvLcFXFzcF7aRGTHJ3tpeA6o6Qt1cNXsIfj16rdfiwSQOsLW1PZgtZLMnDOI25n/mfg
	uoPYPX4Wfw0yhayClIolqZB4Y1bcBRwmkHbCdeBRuBgmlAlDvN1nVqRJ0a1Osiur5CuLv3DzGxU
	ES27iml4PEau9hfQu1nqgTaiACJyanmd85azbK+9I4sw4ZK+l2EXZYe5A0poJT5gqCwbQ6FZ25u
	a4tWG61HxeuE38vXKOq7m8uWDNfWojWahbQmgch7HwsYdNCdm4nZ8yjtHWVM1O4loirePBDjpkR
	aO1/SvbRHLDOQ8t0pctUwtScMQgQECl9AJ5H1R+gF74n0kwcQf5HKDHwBqQ8Tmn0NG4TaxQUHzq
	lBgQOnFOUJAJw7JTPhDwx3wpHi1ocn
X-Received: by 2002:a17:90a:d403:b0:354:a57c:65db with SMTP id 98e67ed59e1d1-35e428287ddmr12153944a91.20.1776095119534;
        Mon, 13 Apr 2026 08:45:19 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35e41355470sm12786052a91.17.2026.04.13.08.45.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 08:45:18 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: akpm@linux-foundation.org,
	rppt@kernel.org,
	djbw@kernel.org,
	mingo@kernel.org
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Donghyeon Lee <asd142513@gmail.com>,
	Munhui Chae <mochae@student.42seoul.kr>
Subject: [RFC PATCH 1/2] mm/fake-numa: fix under-allocation detection logic in uniform split
Date: Tue, 14 Apr 2026 00:44:37 +0900
Message-ID: <20260413154438.396031-2-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260413154438.396031-1-ekffu200098@gmail.com>
References: <20260413154438.396031-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BF14F40013
X-Stat-Signature: nznpoj378iy6mjs1ociy53bsnqdznaj9
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1776095120-505457
X-HE-Meta: U2FsdGVkX18M/ZxFwZbET4FX4PSdKYtptE0kiWxwseR066loG5umtD3QgXcEoM+IUBFHDtT6D7iiSnoVOs084NJ915XpIZ3PYfVn1+OQToxwCm0XEFu0q9O4qNELtcp+x7KDur98M4qOPBVbeWgZdge5kzKdtFJzqPkqKLuArL9MvMJHjTzfRRb/lHYqkVyRqpTTBG6+yLJfAjOZRAL5ZTjEjVYVUCskHDcq27oOTIVxe8srJ29Bak5yn2pPa7coJuZtGcCmckhu0K40mvOWsHvWBFd3JdztUEFJSokavRJX/WkS3x/zA2r0c+JTIAOwZdN510OI0oegWcw2vvU6CfpiciGTGJu0jZBTMObY+uq7YUDivLBvC3cQf/NLC0o/dAmHMMBinf//ZtvDUhabbemQQ6oiDZOHmKC3mWgmu0aeHh5PLy+4I6b1Hjt/rksKWK1WkxdTmhjvKvKJmauNbah4UWCA1T/pO3FINJr/uQxViGnSVLGWkYyPZs1KjmXNxJqYQIQTTzhiZJZmc1Ju4fWFprqtn1W40JTVMp2TuA4TZHK7hNd5JkbWgwI6effUQaZurWAogQEADPgNbrWwFWHUeHCqLpiYfltBHcVLKrROodSD53p520gzyrg88/uCOTynpiFZ/DcABHIQxV2/1xSvQvbTgWNbSgNA60lgZgMgjsAv+i5RQUfBG8AVYA9+eJ2coyZlH5CtqcFendQa32y5TYr2e8CzNfHBFdKKTmtqvbQ4ijh8JFwg18+nycGnt2T3PTgUEbImktvxNmUTA2CG5KHtoTpm3p+4Wcp9xLhmflfKbhKBfCPYMSDLhcYYvM1T8hAAFSw2GLRwz0MMUH3LXKbNMG/HXC2zv3sLY6YNh9KiVRLo4IBTYNiYm9PwMqrSL4U2/6VOIxlKfCIdYePMpJ47KuHLTzXukbFH5IE7NTppwiqNXao54zZS5h2okrCYuHDSi7F7I5Wa+ys
 JRdnAgf7
 vQSQ8IqW4eN2o5hJ+4oIB2JuDg5XhuKxNL1QFDntMD24y5k4Xm7B9cOOoiPpCq+LlFs7GdwFZ2aZd8Tyl3pm1tFdCTfcCP0SI6R+JuY+1CcSBskvmSa9+iAjmbzsKXdQRHzy61Qk0xN7/TaABVy89dL22jNLpnUA75uWCJ7atm8excayUNzTzI2dpYCiFmpSzALWpgbdnhXv8qR6BtQhvSzoGuf87K0HM0rC80YgPvkkkxcm+6PC2je2Wpr+JX6LpNt6cVIsN/A5l7TtfPlUJs2ww95X/B+rZC99bt1jh0RNMrovdsd3PEDpDHpsvsSH/3azpBtxSdXydZPz2Cj66oRRp0XVNsDY3SJac8ZGZ8hKbGzcMeGEnOlns00Cv154FWvTDKMbeiOFWv+4XLEZ5g006tbu90wKPUm3l
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When split NUMA node uniformly, split_nodes_size_interleave_uniform()
returns the next absolute node ID, not the number of nodes created.

The previous under-allocation detection logic compares next absolute node
ID (ret) and request count (n), which only works when nid starts at 0.

Fix under-allocation detection logic to compare the number of actually
created nodes (ret - nid) against the request count (n).

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Reported-by: Donghyeon Lee <asd142513@gmail.com>
Reported-by: Munhui Chae <mochae@student.42seoul.kr>
Fixes: cc9aec03e58f ("x86/numa_emulation: Introduce uniform split capability") # 4.19
---
 mm/numa_emulation.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/numa_emulation.c b/mm/numa_emulation.c
index 703c8fa05048..e7f856c8f2a1 100644
--- a/mm/numa_emulation.c
+++ b/mm/numa_emulation.c
@@ -416,7 +416,7 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
 					n, &pi.blk[0], nid);
 			if (ret < 0)
 				break;
-			if (ret < n) {
+			if (ret - nid < n) {
 				pr_info("%s: phys: %d only got %d of %ld nodes, failing\n",
 						__func__, i, ret, n);
 				ret = -1;
-- 
2.43.0


