Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 549EB606A319
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 22:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=lwn.net header.i=@lwn.net header.a=rsa-sha256 header.s=20201203 header.b=nlXmjlIE
Received: by kanga.kvack.org (Postfix)
	id 4B5916B07D3; Wed, 21 Oct 2026 18:54:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4657C6B07D4; Wed, 21 Oct 2026 18:54:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A25A6B07D5; Wed, 21 Oct 2026 18:54:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1F61B6B07D3
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 18:54:47 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BE62680305
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 22:54:45 +0000 (UTC)
X-FDA: 85348139730.23.0187D37
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	by imf06.hostedemail.com (Postfix) with ESMTP id 29CFE180004
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 22:54:44 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=nlXmjlIE;
	spf=pass (imf06.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792623284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=suSsouaZz1fXKpPu6iLikqlq/1Qh9RuPI9U9VIbMVyQ=;
	b=OQ5lzgrCwY4n08bIuWzJQPvsZmuFmHyibKS2R2TmCIBnVs5OCzyg8L2ngxanGEA4HVSfFH
	60SWM0N9/mHpHXIw2M+Iape52DmIXd4P7JK/8Vd+LvALXTapciikO++C57uZwfmKz0Nqgk
	nb8/YcQ5H/jAwT+cxoYzBu6XjuM806U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792623284;
	b=CyNxbEDLwnijLMyWo7GS3ZXLZxdjfKfANhJKffU1PNR90UognvUdwKcrlQV7JgUjtbdPe2
	RnztW7v/hyR3Tw/P+BhAC7pwcCH7PUHfrU2vCG8Mo3pXU3k7vq26K05ltlJhB5oAlUDpQJ
	tXgRnW0fkGNIYcWudsE98YXdylJ5oUc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=nlXmjlIE;
	spf=pass (imf06.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net F0D1940904
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1792623282; bh=suSsouaZz1fXKpPu6iLikqlq/1Qh9RuPI9U9VIbMVyQ=;
	h=From:To:Cc:Subject:Date:From;
	b=nlXmjlIEozbQ6y6mOLLB8cjkG+hCD9nM7qRP8xlZKfx4Vomtbf7ZjpFKcuXTTjXXB
	 zrDH9YThX4P0BGJGJuuIJH5nw3is3ScQ/S6c48PY6QgQB1/4TYkYV946e/BbPULFRh
	 KxtD/Dwpe/SeUfi5IdmKBwC/L4/nFOMICnZmaLV3pRWm/XONDL15C0qf2VAWUVb8G1
	 Qo7SHs+IWgQXJ44QozTDrOzM6HgHcLBKZD6764c4wqEZnFqnDlaFvfm96PJ0JpsiWl
	 uMIoswBEOVzQCxodnxJMHqErG6mCW04tY9GtwDnnPdHhIwdsj2/yUVGBtmeRhUZ4tp
	 4iZtTjeU4kmWA==
Received: from localhost (unknown [IPv6:2601:280:4600:814::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id F0D1940904;
	Wed, 21 Oct 2026 22:54:41 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: linux-mm@kvack.org
Cc: linux-doc@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>, Randy
 Dunlap <rdunlap@infradead.org>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>
Subject: [PATCH] docs: core-api: include documentation from linux/uaccess.h
Date: Wed, 21 Oct 2026 16:54:41 -0600
Message-ID: <878q3q4qby.fsf@trenco.lwn.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 29CFE180004
X-Stat-Signature: qf98118eq14493573zzwrbiyasy7z7zq
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792623284-546845
X-HE-Meta: U2FsdGVkX182oA0AyQWu+jTNF2o892bQRvPPmS5O0j5+avkoRGAaGLSHj/9vRMHD+RtfRIV1myPy0GGOPQxk3E1X+W3vEISRN9fUxxhFQ3U15Kra7KJ9rCOlDQclfI2XCYdDgLrYTXsEmvRYo41yMs2G7QMMGT9ehpFVWfSX/kN8F540jeIiqggCslLir/kBqb6eP40i8Dsasy5QX38KWbk1WnpJDE0c8ddwcvWK7qObnLyxWH0yu70+1SOf00ofjrAlR0ius5g6YtuHiB2a/gG22NwGJSZik0TbXJx3JRSrHGWM/CgWZOvuy9Eqxgp1+xYsycU4S3hl+a2Fd3VuaKqtPObr8okk/qEtGx9Oicfh4LWzz1yl07KMI5oFoPlCYn5tY0x08rk2oXHDeNYEnqaLm2tb0nI64ljG9AarycBjxGgNHNdO1lfRKeNWdBim+FNTdfiCqw2+T4lXfaEckuDYNdGAnMFX1Y6dxpBqiFxsAc2tFS6G5h9rfolnO6CsgwcW61AHy+p5Jb4gfETjmZds1VLG2BCXNRZzWcOnKxg9LSddb/+EjMnppZ9JOAz8jKmrS6BIPzivYDLvLYsbTE5vTt3JayTlh1duRl25Lekj9BlTeE6806cmmEjYT6aY40sm81DzjLV57XFpFqHYBfoqUyf1RCwHLk6c+hYoUmhJeSKj2FdDJhjpFMbk37P0uRZgFCpUc3cArqxz0wKL0jy6qIzzOXORh79D45U2EfAcKqa7L9QlURRQZdHN4hZqILYYSug1bujr/WHjvTV3CSoDLhH4RABY5VJuPaivuYRSPNrlxhO7hpqq6vFmE2MpuMZRH3Vs8lwxisx+/0sBIARBfP2ycjlo6T6nz2c0jqYuMeXDPYZiW5bcHtW1tISbw2g05UHqpoD/5/5u+b0Dpno+NIGvU3/JCG/OC5y1z+NnLPZusADj2B+xbcGOgfKYSoVwH55mjbxLhv8U97/
 lIVrNs12
 atPZY2hjWrN1bSPkmSACo1x9uwwqaZeSW43KR4vjqsZXBoJdI4nQxwmOIIhKQW2NiezfzrluzszdzH40cxVbQNBJRi6UMNVOomwaEo1+BhpFAUCE8zVsGRCkZAxHL0AEhEy+Zq9kXM4p/CBsjIVUuDqSQMvuIHiV4v/VtuY0MYxrJwHTwAzeeFvUCX95r4ZTtox8mwmq86LrOi/zrsfqFF3uASeApY8QVlNa7tqhoasg/PrSdqmhRF/LwNik+6UFi/dS9ntVaZq4gohNXuzNOiAro42f6sVEve4R3OQ9+xitWy0/wpNgoWnxifIsm0bsI8/y5Rn/tl20Pp8nrcFvE489M2vFjeIJlF07+tYm/BW7LTeUD6rHsPa6QRVy3CbeNC/23QErNCXE9iLTgI6GZSs2adA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Documentation/core-api/mm-api.rst brings in documentation from the
x86-specific version of uaccess.h, but many of the functions in common use
are documentation in include/linux/uaccess.h instead.  Incorporate that
documentation as well.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 Documentation/core-api/mm-api.rst | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/core-api/mm-api.rst b/Documentation/core-api/mm-api.rst
index c1d03a5a2a19..b8c00bc5314e 100644
--- a/Documentation/core-api/mm-api.rst
+++ b/Documentation/core-api/mm-api.rst
@@ -8,6 +8,9 @@ User Space Memory Access
 .. kernel-doc:: arch/x86/include/asm/uaccess.h
    :internal:
 
+.. kernel-doc:: include/linux/uaccess.h
+   :internal:
+
 .. kernel-doc:: arch/x86/lib/usercopy_32.c
    :export:
 
-- 
2.55.0


