Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2540C606A32C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 07:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FmSv5120
Received: by kanga.kvack.org (Postfix)
	id CF4926B05B2; Fri,  6 Nov 2026 02:24:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA5076B05B3; Fri,  6 Nov 2026 02:24:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B93D66B05B4; Fri,  6 Nov 2026 02:24:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 945CD6B05B2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:24:02 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A78F3160CCB
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:24:01 +0000 (UTC)
X-FDA: 85403855082.29.F3DBE6B
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf20.hostedemail.com (Postfix) with ESMTP id E69371C0006
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:23:59 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=FmSv5120;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of thnkslprpt@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=thnkslprpt@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793949840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=t8XtYL0CMtSz8VjOCnnSQ70xiU2Xw1jxqraDN3jPXMg=;
	b=LTPf0sjPeE/lmGtPJiMMeIcGibkeWEYc2w/fQ1Lk5lEgVp9E13V7LuE8GvZGUZCY3WKUjw
	rFZ/hCdAZ0vu8wfyP6rAzBtmlK0TiNiWVKi4MR3SQ1mpgcX7I/4QwAzk9cfHkuqzrdc+Pp
	O5oNSLJQyw4o8Xxd4w5pKvAMo+1XIJk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=FmSv5120;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of thnkslprpt@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=thnkslprpt@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793949840;
	b=PFQZ3mmIGormd3bqFrAD2ojYFrEYpxazTYdOeWIaI3DkQYUm+oK8rpQoVBHUy3Y1/Gly0I
	Rf9WM2X0xZLKVSEpGT/Fj6Bm8C3+fEvcfXb4vyatNLrW8bG3tDrF5+RoMu2Lo1ZWwzMty+
	jKnO1acDPfix+c9A59JHjvXriijvo5c=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-48dee593f18so212946f8f.3
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 23:23:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793949838; x=1794554638; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=t8XtYL0CMtSz8VjOCnnSQ70xiU2Xw1jxqraDN3jPXMg=;
        b=FmSv5120TGtOrTRc3yBTobQlfyI9Zbhq8H0Bcj1pSoWuLZrCdTAyTeuIND6xoTp57u
         fyx006WK/QXeWX9ImW3mL2mjjwNoKEjc3+Qv28gboOgMVm9WlYi8OMhYkqsHcYhvxHog
         xIbsg/4oIn1i3j4tLAYhgkVOh9MA0l2IVmjW69Xm1NA8EPl2PlGc8NRqRqh5FtGk9yNp
         FW7howgkQV7BaWSZJiBc2Bm5M33vl+9uZ1rAl1q5N9SBV0j9EWwqDMxljqgJfbdnYz+G
         OmMtUV1zFYGCbIAWx9DAjPY4XSYi42ZcSo9scCDBgvGzYSEVRpSAxsMQA4aBfC8qI/f8
         wjdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793949838; x=1794554638;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=t8XtYL0CMtSz8VjOCnnSQ70xiU2Xw1jxqraDN3jPXMg=;
        b=YkWnwtFOTR/EGKi4vx1E3RJtnNLt4jCZ8UKv4qf5mucb77CBSptenLrqoaGI4Ts5dI
         6e4I+AZBOTGIpFFgqJLUMLREhg34hoN0E9/H0oilA+9PbqsD+aElCjBoFEbius94fR7S
         O+pb0Iu8glNCWUublIkr226ILLjLubCKK0rnFeM/vCx1j4vnOYw6m0NW/SHgwHq3/Yvs
         LnWPjCMd08tfzclp+0yoi0Qp+R4dGWrpO7MRgGhTXEdqxAuYRemInLyFF5KxWXnglDNT
         0cExkCfQoSJQH0a1Us/Ra4phjamS9RCIKOmcQwxDurGArxfNhR9310pswDYt6MTRCACl
         ypoQ==
X-Forwarded-Encrypted: i=1; AL+hErF5YkAQ9ZE79xpT6go3ywAw1irOuJ6cYFcK16DlrnLS9kqjLz9Yy7yBD2D1RtHl96B/9fCEYh5phQ==@kvack.org
X-Gm-Message-State: APuU4Z9Ev3OIUaSEbISlpbhPPj4igfugq4aOoP9+cXLbUtz9KIozK5mI
	FGgQ6E2iPGY3smhR+tZG/W9t7BPueZG1ebO4Sk9VL/jbZHyUyWZjTvfj
X-Gm-Gg: AYBFou0SQ/QMLCBTcoSmyrLW2Q9RWRNxFgLHhaYCXjzLDF/nsH0AOP8k5DreRjzwItO
	gYscgmpaUvPnPW5n/6IpfFjJILBG2arScbZCA+v00Z3HQJ8Ieb2GGk4FNeT1lGbQDm3z8GqArTC
	xkTEpEKfM9bwklHrxFnGXBgkx18E4Er4KsMqxzSCbdJkL9Ye64Ww04/Oy8ezemvG5gJDMuXPcTc
	nYqc5BOOmaRrRx/77C+dQ4sKv6FlJn7APLYSzOL7AgjOaexZv4/nquB3JVb2tJu94hu77ljhDYi
	x8LchfJi7ekfpli2b8ZqEDnJA/X1bcXKi5qZ3iKpw/AobJxO9JxQrX50mdWq5NlBX5w/tnBu/hd
	TjOYjXqhcGcQF1OTT2rFe7JBmK0O49B5G/Oc5a3pyKCiljR3aDZTAJ4EHsyoox0BSit+LMIsFQr
	G8nWDOwXZq2c35zXMcx8i+GQn0rkkNjjdi8olL1jHeHNCUXtIiD4p9qcfnLcAFfKw4KFcDe4Ooq
	z2roNyDzPRmLaTrIo8M0cmzRqUCR7ltRRaGIOSxhoh+/lp7AWKnhILvVT8lWbHAdx76cgezaffR
	12vCEFGMOYN8XAOmvGK+UL1f6FSiJkSKl5mx
X-Received: by 2002:a5d:5d82:0:b0:48d:facb:5937 with SMTP id ffacd0b85a97d-49273e5b191mr3119041f8f.7.1793949838028;
        Thu, 05 Nov 2026 23:23:58 -0800 (PST)
Received: from LAPTOP-AVI.lan ([2a06:c701:475e:f800:a7fc:23a0:3fe2:eb8b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-492d3d609c8sm2201123f8f.6.2026.11.05.23.23.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 23:23:57 -0800 (PST)
From: Avi Weiss <thnkslprpt@gmail.com>
To: rppt@kernel.org
Cc: akpm@linux-foundation.org,
	rientjes@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/mm_init: avoid overflow in percentage-based core sizing
Date: Fri,  6 Nov 2026 09:23:55 +0200
Message-ID: <20261106072354.2234189-2-thnkslprpt@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E69371C0006
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,FROM_LOCAL_NOVOWEL,HEADER_FROM_DIFFERENT_DOMAINS,
	HK_RANDOM_FROM,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: x8q7soyi9owe9kb7i56o4yhyhi8mz5jd
X-HE-Tag: 1793949839-973599
X-HE-Meta: U2FsdGVkX1+5U6s2ePmB5MsFXvDkg3fqLLFngPSkAZKxtP1zplUc1CX3LDMV3EDA+og4pjEIGOXF6mtqH63d61qA8OsJQ9QSlNhV5pMvJRhGW/pdX/f4tspzVP+GdNMCrcIn5kHxNhrgF/H4880rS7+1+ppY9lwhUwQLDkhkghn9XWGcDEKleqtkQFW7nWufGZ0XEVCog9yZAzSuhsdtZiGssJkUHHe/LmoGLMa8ZqG7F2UVgOy1+JFPIElM4DX0JYr86ccavBz3XjnBxQRHjl/naOSeNcFFDFSM8TbG2Xw85YQVciD0ZoTjLwf/hLffFdI+7+TxYYVpNXm+Tqy5IWidJfNJL7E3KD2/LWbDjTP8cMrU62QyJ/olDl9RayQhkT1/pFTKEocX++AUBUUizaVF5hNUVDjtJbL3IRBy87ZkaSw4NVtLgauTzEIkwsg59c9Gw1oFQ92vlOwDRK1ThH/bUkVwlNe13bsm4jL8LWquLvvd9wbKUq2/9RLOMS9DTfBlyo7OIUjmDkmdukn9b/m6bkbnDkn1n1uxG5hpqzl25tvbXCVoeEjx+tly5GjGtmPNpsv1uPlAb24b6UHEd94nMmqBcoBkZKFtwKqWPYvxz3eIbGUuovjvNuzY3zxDrplpLZwGwDpQMDhUACF5yP96rbSO97NdXehot0IGO9EcZPkaFyYMSnLXwVhCAuK/9k4QaTBp2IeDk8ermYfNwt/AlozjZ/TjBW5tiyoXMggg3IRToEL25YjuhjUUtH0fXzEHCqZ0FnjX1+EEm+Xt+a1vC/0TIwNjSeFwqfdPrI7BLmD7U/LuHH4ncSeEVGt3LwitFMFEAjANQfYpEuwumt+0briD0J3FoADzg67b9R3RHLapN652ZiHB0jD6AKCun8jkuXF86FbLtmYPK7K3kWJFETgLtFCA/3byHbVH4AjppQLqpRvsPmUXv812To7sYT/ICa4Nb6MGN7kf7mm
 sATPT1Zw
 8BUo+gY+yxn4HPXLpLIw/Nr3sUnMC3Angog0/g0O04Jn2JE0LhffdRvzDcniN4qUDeuLqm57w5QtVQNSrrvPXPJ1MrGxgncRM/Rywy8eUJ0neGIpUQ9NSfVePKCYIzLJlJItVQEjFVCr0Phdbw9OnaW+VckEOXlNw1JsbAKu4Z8LGaxYnMgm38Ip3oOM1ybC+WS+Fii9+72H/xhAkWtoDc8tWKbHhjDZVAttQMLfC6oqW6Fw+uw64r7Oqf7Ba4hPNLs9YD0HExOK/QgzyHBmFYrsFl4k8dwuOdm2EmUTkwbRiaw9wniVAO/ncbGCh13UA3zfJiTOa1Aj7k63JKdHFSyZxtlqjx65Xf2Yr1OjVYHJrkvRcnzOSnUXou+GjXEGF42qoV8l2UfYAsXMlL1nKEbAVJiHVssmh/rd8934WyIJdSGVjq7KavYIUzJF3Kc8sYo7XdFqxSdBhMjjcObzj+wOYZBbdRIIq9mNF9+GBWwJUNkwAPkF63MCdRo+PZrilwyqXx2rcrQLtdvKs6Sj4itG7Mw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The kernelcore= and movablecore= percentage calculations multiply the
total number of pages before dividing. On 32-bit kernels, the
intermediate unsigned long product can overflow, producing incorrect
memory zone boundaries. With 2 GiB of RAM and kernelcore=100%, a
32-bit HIGHMEM kernel incorrectly creates ZONE_MOVABLE.

Use mult_frac() to calculate both percentages without overflowing
the intermediate product.

Fixes: a5c6d6509342 ("mm, page_alloc: extend kernelcore and movablecore for percent")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
---
 mm/mm_init.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 2a0e782a151d..27a50ecd5c20 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -7,6 +7,7 @@
  *
  */
 #include <linux/kernel.h>
+#include <linux/math.h>
 #include <linux/init.h>
 #include <linux/kobject.h>
 #include <linux/export.h>
@@ -448,11 +449,9 @@ static void __init find_zone_movable_pfns_for_nodes(void)
 	 * amount of necessary memory.
 	 */
 	if (required_kernelcore_percent)
-		required_kernelcore = (totalpages * 100 * required_kernelcore_percent) /
-				       10000UL;
+		required_kernelcore = mult_frac(totalpages, required_kernelcore_percent, 100);
 	if (required_movablecore_percent)
-		required_movablecore = (totalpages * 100 * required_movablecore_percent) /
-					10000UL;
+		required_movablecore = mult_frac(totalpages, required_movablecore_percent, 100);
 
 	/*
 	 * If movablecore= was specified, calculate what size of

base-commit: 36aad21d50d1af3f6954bb0c988257a908202477
-- 
2.43.0


