Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CD6D107760C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 19:09:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73AC06B02EA; Wed, 18 Mar 2026 15:09:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C4586B02EC; Wed, 18 Mar 2026 15:09:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DA666B02ED; Wed, 18 Mar 2026 15:09:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4EFC76B02EA
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:09:52 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1198A160121
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 19:09:52 +0000 (UTC)
X-FDA: 84560123424.29.7ACA928
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf13.hostedemail.com (Postfix) with ESMTP id 662B820011
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 19:09:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=YNRPCRI5;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf13.hostedemail.com: domain of gpiccoli@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=gpiccoli@igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773860990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c5teEie7C3ePZgybh/X+lnNmt1q5goT5Jx00idPTCrA=;
	b=6VA2lefi34mif2JHnEK/rx+WGb2Qjclrom0d4XFTJfVTEHRvRq5Z+3+8InYR/kVxxOJY8+
	RJ1WntSEC3OePCcv0AUYKHgvXsH9yTnsXE0HKxqpkjrMtf/G0SfQupGZC4YwTijUvWo+ea
	5RmkiWnwa0ER3Nov9y6omGXsemvg6QQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=YNRPCRI5;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf13.hostedemail.com: domain of gpiccoli@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=gpiccoli@igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773860990; a=rsa-sha256;
	cv=none;
	b=frPPG0xJbViKd2WjxlHxDVTZRKbH04ydChS9MOxiGgu+7GpXUP54+SvzLRLC+lc4tMxGrV
	7H1k2QyuB+QX37wCRxGInEf59FZhO46AhhytQQN7T3OniY9pmCrBLgB2820+MgIONzSlGh
	nfMVdjykSGGTJUda66YQ8HqbjvfKo28=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=c5teEie7C3ePZgybh/X+lnNmt1q5goT5Jx00idPTCrA=; b=YNRPCRI57rf3zAqRC0P7QRYu92
	p7mPCnkVq2GJl1vWixeCAsenGmp9lGyZantrZEIOtPonMlp9y2rbDcbvT7w3hP0MkUvi3TyHlNcxi
	fsBIY7KIxgeCu31eC7xpDBAdnBetqAD/A8qVAp2yDuF0euH5Pfw8wgB3qg3PaqcTTjSQ3xTjs4eZF
	Mk1oo5K6Wl9qqFXsXybx5w1hG1UWJrlH6sdhVCppR/IK+Z/T1f3miUeuZMQUKNo89wcK8tRgu5U81
	s0sfBV4ZKKD1EEt+qDul1FlJUOpkOzPXuLTi0k5N87mfCBLMQ/kXRwGdYpuya1WnewsG2jw/6yzr6
	soGTiMGA==;
Received: from [179.93.15.111] (helo=localhost)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1w2wH5-002x5r-Ku; Wed, 18 Mar 2026 20:09:48 +0100
From: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com,
	kernel@gpiccoli.net,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	SeongJae Park <sj@kernel.org>
Subject: [PATCH v3 1/2] mm/memblock: Print out errors on reserve_mem parser
Date: Wed, 18 Mar 2026 15:56:32 -0300
Message-ID: <20260318190816.1811325-2-gpiccoli@igalia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260318190816.1811325-1-gpiccoli@igalia.com>
References: <20260318190816.1811325-1-gpiccoli@igalia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 662B820011
X-Stat-Signature: xpn1kmo85gmsomsf74rxnt13jdcyhwge
X-Rspam-User: 
X-HE-Tag: 1773860990-194458
X-HE-Meta: U2FsdGVkX1+F/YhJtj0mCtthkMMlrDi8mmE9cY1wIxFfYM4GJpwfz2ONPfcM/sb1YfTgxptW0ud2BPxn/hARpkx8cks4Ic6OyLEygApY0Gb83vuw/u3QoEZqGfo0nhED171DSjtCYTylbgKONMg/vYGcXtIgo/BW1EmKvOw077VGK2WUGAE5S8frQ3Jb3K9npyx1KPdwTfP7JzQBA5OKPIE9i0n3OUI+4Us+TdWn4Gul/uQJ37kwbdYOb8e191R3Yn+dkz5IuakurS0y/K+2NLanE2LN/a6coKSe9TB9wIKjzP9l7XBQTgGcr3aiCpDLmrAgdQ+bBNPUbO6Y/T9EPj4TStK9obR7r/jQ3b8Yv768MQUJV0cMEglv/hVx3YgM8RyD/x3BSJrjRSdUf6EtjLli6Cnyz6GdlCCTTlE+LYbm5jzabQIimdMARkbqhBRbOO3ohVt4W5PK1HauGZeOya6ChseRWaKNZUZR1lSpq3+FyBu9DadWa4K6LAj2JOuE2b+Yb+/NImXouO3eb67kv5q6KKYvoPKxQtkc9cAI0guMmEwtj2rqqf4wMYqNZ+z8j2xD7b+Ju/wIVJi4EvhYfcy4JWwIdYXqUbkUdlhx66DqObq//6ihuWSFelB7vS8evFDHUnCZmai0kKS1lxpdx53lzg6HeqvdT4fF4fMvxp+RFVchf6KzOgiGyF7V7WfllUCv/kBKocyoapOERXTFtI7pxalPzt1T4qgkAreiX7L1wWtlm7+Fl+OPqNaob/P/yHXi85LtnKmEcM48+Vr/bEFTkDyHU8Eas0uUXndeVvbBDJUrHr8Ceg9t0StzpXMy9s3faJRHQMcRnCM5L8Adczx8fFAin2CxM4oDMAo9oT3U5cBFJGx/hTAVd60LshIgksH8e4emyz37yiIoTQ1WWSKpA8Jk8/4FSVqm3UPDpJWGb0Siy5lliRyPz3688ncl8DdW+WNErHmmxllwxLd
 SQV/rTZZ
 Qh2jkCFp2qDit+mHqDidlsqbQM9MMiP7UPt35ob+oAI/KlHk7TrwxGffxJVFcZcfEJjmx6uO4B3HcI5KWDUGlJQqZvhNA6meSV4jyhOpqc9RWxZGo17aeiErg+3F8iNDH4OJa77IkQAppDMEKMctBvH7sUBdCR3PxiYX+GGdnoBC0kXy8QIqLdGhPiMEuNkkuF24ErLAbRZWPXWo3OWjsqYazAIP+B/2YPFDM88a0rMnIot79iZxGYvbEgoh/gyR++jd0sIz1n7VLIpvmLcWUv2syzfkaqH6MW1C+QTCRamibrLlVZQpJAY+YVkHo3okvPWYwgJDDs4qKgnBhb2xS/N+0hOk+LfXl3x9AzRNgX3ANoQFVRObeP/kel3HWExUxvKaGfF+av7YxTGEBeYrB9xQNu6QyU0vFUBnrgtsg2L/OkKmRrUdZAMtf6KhmVJY3I5eY/z9AJgJ5tlY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The parsing of kernel parameter "reserve_mem=" is subject to
multiple failures, like duplicate naming, malformed expression
or even lack of available memory. Right now, all of these fail
silently. Let's add some messages so the kernel log can provide
useful information in case of failures.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>

---

V3:
- Removed unnecessary blank line (thanks SJ!).


 mm/memblock.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index b3ddfdec7a80..ac08d7f8c15e 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2642,23 +2642,25 @@ static int __init reserve_mem(char *p)
 	int len;
 
 	if (!p)
-		return -EINVAL;
+		goto err_param;
 
 	/* Check if there's room for more reserved memory */
-	if (reserved_mem_count >= RESERVE_MEM_MAX_ENTRIES)
+	if (reserved_mem_count >= RESERVE_MEM_MAX_ENTRIES) {
+		pr_err("reserve_mem: no more room for reserved memory\n");
 		return -EBUSY;
+	}
 
 	oldp = p;
 	size = memparse(p, &p);
 	if (!size || p == oldp)
-		return -EINVAL;
+		goto err_param;
 
 	if (*p != ':')
-		return -EINVAL;
+		goto err_param;
 
 	align = memparse(p+1, &p);
 	if (*p != ':')
-		return -EINVAL;
+		goto err_param;
 
 	/*
 	 * memblock_phys_alloc() doesn't like a zero size align,
@@ -2672,7 +2674,7 @@ static int __init reserve_mem(char *p)
 
 	/* name needs to have length but not too big */
 	if (!len || len >= RESERVE_MEM_NAME_SIZE)
-		return -EINVAL;
+		goto err_param;
 
 	/* Make sure that name has text */
 	for (p = name; *p; p++) {
@@ -2680,11 +2682,13 @@ static int __init reserve_mem(char *p)
 			break;
 	}
 	if (!*p)
-		return -EINVAL;
+		goto err_param;
 
 	/* Make sure the name is not already used */
-	if (reserve_mem_find_by_name(name, &start, &tmp))
+	if (reserve_mem_find_by_name(name, &start, &tmp)) {
+		pr_err("reserve_mem: name \"%s\" was already used\n", name);
 		return -EBUSY;
+	}
 
 	/* Pick previous allocations up from KHO if available */
 	if (reserve_mem_kho_revive(name, size, align))
@@ -2692,12 +2696,17 @@ static int __init reserve_mem(char *p)
 
 	/* TODO: Allocation must be outside of scratch region */
 	start = memblock_phys_alloc(size, align);
-	if (!start)
+	if (!start) {
+		pr_err("reserve_mem: memblock allocation failed\n");
 		return -ENOMEM;
+	}
 
 	reserved_mem_add(start, size, name);
 
 	return 1;
+err_param:
+	pr_err("reserve_mem: empty or malformed parameter\n");
+	return -EINVAL;
 }
 __setup("reserve_mem=", reserve_mem);
 
-- 
2.50.1


