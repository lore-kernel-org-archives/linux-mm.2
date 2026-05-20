Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0872BCD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 02:03:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0648C6B0005; Tue, 19 May 2026 22:03:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03C726B0088; Tue, 19 May 2026 22:03:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E94916B008A; Tue, 19 May 2026 22:03:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D99B86B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 22:03:55 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 614A21C0CB5
	for <linux-mm@kvack.org>; Wed, 20 May 2026 02:03:55 +0000 (UTC)
X-FDA: 84786152430.23.043E186
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf22.hostedemail.com (Postfix) with ESMTP id BB3FBC0009
	for <linux-mm@kvack.org>; Wed, 20 May 2026 02:03:53 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZMfKQZ93;
	spf=pass (imf22.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779242633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=yR0/f+KzLBdnQPqPTpQPmi8cxShP2a0wD6YDyJC6LqU=;
	b=CryMc42vP0f7Q8VSu+csFMaCVXJbZl+43E/STQtKRYas6t0sdQk69pAXm+bcESI6O2cdx2
	sxbfsSnWcVNl6OjETYyq/SQgr0yTRNpHbc/zq5lYmJ/O73Rps8Ck88+w+xuEguLPoo3TfD
	cbe3R4EAhKC37+7H1VwqwureXxxYJH8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779242633; a=rsa-sha256;
	cv=none;
	b=yNk/N0O3S6OKlw4dWNJNBj1QdPHGG38vtI82jxgUOj/JA7Jm8aQ8COz6YNXuF3DqKOjdUO
	Z6jMwZIAVTxqblWArdBCadWFdG+dHmE8MAYk9FKIybptqZi/uYlVkkxNklgGEcc2jaFJC2
	unH5Eyl7h/KzCqjm3oky2OT8JSYHxdw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZMfKQZ93;
	spf=pass (imf22.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-67f7caa33easo9247092a12.1
        for <linux-mm@kvack.org>; Tue, 19 May 2026 19:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779242632; x=1779847432; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yR0/f+KzLBdnQPqPTpQPmi8cxShP2a0wD6YDyJC6LqU=;
        b=ZMfKQZ93mXNDZsL6sa0ggWTQNwp3s1E7oT3Rp7xtVfL32jtt5cudQeg/IBPSOzN0X2
         eiHJ3iq8oxDMAGQOLmER5+ahlWSgED9JJKVmENfa/R0iMetMjExfVxW4QOT2j92PmDeO
         RX7983rQhX/rILmUmTgUh3yNOHLydChH8V799P8+P1ejRt0sAM40KyLjqxoXmO2/LktQ
         O3+FDbbmdb0HcUWrcZaD+I+I++kKUAbgmXfk+hb4Sq40cVnjWeuUw/O9RBB/gaUwMf4o
         sBq3jVIbejfp5mmvaNm/4vhPZ59SqqB+7CuL/Ej/2CZc4HRbrYmH4N8T/VH5ihh7qlzX
         WIgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779242632; x=1779847432;
        h=message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yR0/f+KzLBdnQPqPTpQPmi8cxShP2a0wD6YDyJC6LqU=;
        b=DNfsMIwIw6YpSqUHsL9QZWniY93tmh5LS7MNJh/yCwGztpw16SzMHrp3g8v5FcCrfs
         BLnqRtK+w+DprvVd7WonAsgZZfHiTImOgayug4BCSxVxg+WOTAgPwxikz0oKVV8UnP4N
         6I28vopf33NRjc3jyrjPQ+0uqFI6q6xrl+T03nrHB7dgtK+AkTq9q9QFm7Ssg5TYV0Py
         4o9BsITItdMK3wxVojTt9q2Rp4ER4TduSEC+m+4rFOZKafQLTRK0AbPhZfa4ebg6PQLQ
         +fU8PNTLHqd0YYUSS5o5+q04YqSWR20WltpQSio7/61cPFj8LmGtQDWdYRxb3S9MGu54
         DwZg==
X-Gm-Message-State: AOJu0Yw+FM1pv+y6++uZHFrRp073niTYE9sMdKwc35CUJZljyjfOUNLb
	AuPnTLmm4b2XxFOFmlV+eQVDXdDhkvxzFrUvYQyDY+CJNNJsnMKamuJp
X-Gm-Gg: Acq92OH81QOTLYkhY69BxOBFXU6ZF9Br73wM0dIfnXhtSjzKd7dyBEtOE9JJ/1ULJCi
	LrVBO3cG4IhAK2cgasKfGsO7a+T42ZOqeWV8V6jwW/3D9Md9Jb52kj5jzz1NKNQD4MEzAtKAE39
	e77U8+wsJr+X6Nc8JGTCSpXYEqpQkw+smpJtqGKdI2XFo59VrUKQpcwg00mCcUHuguNoM0CBxwa
	INN3a0tr+iYHqZqSvybtE2DlLUoBG1xkydIqgCRsTtmESnmppXnIUFQW6tEcL4B/lM6b101sm28
	rM7LIjxs+KGD4Nw3PcV9hibpLnc8ySv/01m4rjU0j+p0olDevPzx/c3bFxnMc4EGAPPryf4b1fa
	J1GMmrebP7TfYI3A/fHxCtrqDOkoxs1KjUEQvoG+XmuTmQUUU38+FzBmkUqBncYBbPkIeocmSZm
	yCbKAZ/Oyv9sIgCZevuME9aFvkMgeGwLNf
X-Received: by 2002:a05:6402:4347:b0:684:32ec:2332 with SMTP id 4fb4d7f45d1cf-68432ec299fmr9688144a12.2.1779242632059;
        Tue, 19 May 2026 19:03:52 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-68705a68375sm577452a12.25.2026.05.19.19.03.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 May 2026 19:03:50 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [PATCH] selftests/mm: close fd on write error
Date: Wed, 20 May 2026 02:03:36 +0000
Message-Id: <20260520020336.28914-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BB3FBC0009
X-Stat-Signature: 1iqh8iwfcmquzai7kiq4dz4s7csrqtdb
X-Rspam-User: 
X-HE-Tag: 1779242633-496449
X-HE-Meta: U2FsdGVkX1+RPAYZPUxSjJ1JYuTr+rQ4V2qt3nMlNvr55dWWIRUObg6zgXok1GRT+D9E5sRmalb1izJDVRJYkaexhmo/IVBgzPV1D9Y+qYTdsX4F/PDVHxPesDCL/hJMk5F6Rj3EfcRmTwrfMiRxLrYW6VuOb8u+dJ+hRDqCaltYDnDdnMOlo7menvPALPK4y0KW7Vr9DcSAbnhjp6cx+njeTjaGr11gWF8ZgW4TIlk/Uanty26iHEjxsRbbsFy1DBqbeg9PLwE+Oc0Kn6PJlNdHurqTg5MW+u/vIKNkHDXiVcApjN893d1vbYnV0g7cvRBvBb4J/NVsLhDu/yCb1vhSYlNJJ/7tlChGuoarLf7GCxPfIJpeFJlqhuXRNU9c30RbWJ1IRAv0wNnN9c9nyT6UwDXIoQhgE0llnk+ksYSKKHxFTM3nf5N+cuLuguDcwLhGZtTIqmGX43WnVR2EEpINc4IouaaCBupikMynLhgZ19tST9FH4jauNCTIpCb1XIbW6Bm6KbfVnDB7FsI4F2kX3BAzcRoPdS7gzdtGyCfHNDfNo07Z15topyElbvywIoHCI7M0IqY/IYH82MchRZf768as/iPqs6/+XD6ww3hZIJoQlXOI7t6FSEVpfhKu9ail9I3Kb8HceDhtqKlPXI8EldI3dKcgQ58junzCh2GoMDNPC3nQmJ7Blb4ly50sPayY8amXqQ3RZiLX70Tbsm8h1Os+jmNnbR1EgiMv+g3RjLupVcMuzjeaTgprL65ahtwYYC8OYtQXTxcJO1amn0cpR7jE4J7StJJJUNZK23xTFtcFGRWYgglj4VeButDH3NTL8RjFOg6+cAIe2wvRbZYtn1qcdgfS3zKmWB09fUWWuCuEhvUIP09hZNkGT7spaKExRkLdr8io+kJ+ZhnFexeibjDgWM0cM4ailrjoj2FklCAqc+ACiVOo4HnyT2lWfdCGtw9LHpXChdwYRPA
 GIgmrWUj
 DrHIKOjJoaVMnbtcKU0AuKHctvP88qyaSlg6Aje+5bdgSeKPg1aVVmBR7/CD25gwudzkpX4UQKwuo5xKhrzvFnxLkt/1h+GtQIOzltzxyqGputoJsviOg4FXy8BqFCl449u83hacilyeaRrnxorvLRyzmaN5vf4sw2/jIKyBfz6WLXVJ52301LGiFCAzqpXXMYxjk0kOK88jGo3X2sgkUc5yqyd+ymGZXZLEDt7toh7cNKdUZhlO+PP4JGDvBdaVm+gjghR2KD5R9kj/QVuyWMDhaMyQc1vPxpV+QU/drgBenEIX07124rsyxl85e2lB/C1WAq1eaNa2f5sQrz53kfXRYP0OLXDVmbHTD+SreWSxOghIEVl0mZwTqJvG7RuUidlS8K69n/B/qxZ+yhAIDXZ8bPabJK16zPcfapjhz5+L7xJig49cTM9aZgVnBtsXTnZ3rT4QFfOeS1kjRffZMwo4quFKyu8elbu8szHw70Yfaov/T9add8mI0iUDH+WBk+Zj1Mga+wg/QmLo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When create_pagecache_thp_and_fd() write returns error on
/proc/sys/vm/dropcache, it just "goto err_out_unlink", which left fd
still open.

Use "goto err_out_close" to close the fd.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
---
 tools/testing/selftests/mm/split_huge_page_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 460fa1f606fd..f30402ece608 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -469,7 +469,7 @@ static int create_pagecache_thp_and_fd(const char *testfile, size_t fd_size,
 	}
 	if (write(*fd, "3", 1) != 1) {
 		ksft_perror("write to drop_caches");
-		goto err_out_unlink;
+		goto err_out_close;
 	}
 	close(*fd);
 
-- 
2.34.1


