Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9C7ECCF9F8
	for <linux-mm@archiver.kernel.org>; Sun,  9 Nov 2025 18:07:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55FF78E0012; Sun,  9 Nov 2025 13:07:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 537488E0002; Sun,  9 Nov 2025 13:07:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 474958E0012; Sun,  9 Nov 2025 13:07:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 35F658E0002
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 13:07:02 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D23858820B
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 18:07:01 +0000 (UTC)
X-FDA: 84091849842.12.FADA11B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 489378000B
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 18:07:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aDkCAdDT;
	spf=pass (imf02.hostedemail.com: domain of alx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762711620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RvJPb1oWiSEFrItg9k6KHW7Ej6FEWzRZAf+cqndt6+s=;
	b=3AjrsHrvMjGXQ5M2CYsQJ+NZxVvaLB0MEjZY6beJubTOMOlwl7Af+m1mj5t7AXjOUZvV9P
	thcaqvIYDZy+rHL95cdIVDt48+CmuhsrVm0NwFIiOkdTIR46sH4qJ+FrUke/vKBD3m8Zmx
	CFvx595AYO8GYkxGw6XCuxcI3LBXRvs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aDkCAdDT;
	spf=pass (imf02.hostedemail.com: domain of alx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762711620; a=rsa-sha256;
	cv=none;
	b=gIIa8Hq/6A4AVd+o9+bD6ubLSH1QaSMAT2sPhVX1ai4MkGHBMgWRU92OnAZH35+FW8W1cy
	mFbcPWjw1FMj5vJAk0aJfvHhdd24S8hq3BWHa2Dg2kkvcYHm+P33v0ZTzKl9ZWZ+yb1YH8
	+DjwnxBcbAMDpvOezT2I52FKSeWkKoY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8341A60007;
	Sun,  9 Nov 2025 18:06:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 423E4C4CEFB;
	Sun,  9 Nov 2025 18:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762711619;
	bh=NCUBtJbYbJUSM0PsF/hMhn60Ld0of4iArhANi0uVhgc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aDkCAdDTBKcWRXGOcI+UXsgw84QaqZW8IzPm/a5rL26dy7qe0gMOs2b6A+v9DgZj2
	 +DIGa0IqVmPRS/VbYmO4TJJYdIUvsj6jXaQrQ5yBqUR+cIN15YTt73BjpaPdLFmRgc
	 vCkxN7ZDOIWaOzuTDOqZDjpFyoH7hQBXCTHATd8m+SIsmvc0x6wH3gc2CAC2NYPxwf
	 SabU9UBOkBkGKWrKgWjHub/Rdr7mMOcbR4e8SQ1306D4JrbsjjG6JKhkTsnrDhrs8P
	 HGTtJ+zmeAlXnotgcVFov1Ztmv6+6SauSlmGzOAKT2Gt4meJIs6ftUeg0as/tFPkNy
	 SCdW6cr5zTyAQ==
Date: Sun, 9 Nov 2025 19:06:54 +0100
From: Alejandro Colomar <alx@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Alejandro Colomar <alx@kernel.org>, Kees Cook <kees@kernel.org>, 
	Christopher Bazley <chris.bazley.wg14@gmail.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@suse.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v3 1/4] array_size.h: Add ARRAY_END()
Message-ID: <2cb4ddff93b3d3037ef8d094de94227982117f87.1762711279.git.alx@kernel.org>
X-Mailer: git-send-email 2.51.0
References: <cover.1758806023.git.alx@kernel.org>
 <cover.1762711279.git.alx@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1762711279.git.alx@kernel.org>
X-Rspamd-Queue-Id: 489378000B
X-Stat-Signature: 3m75ymsuegdibhjkuht3ihyz8mxys751
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762711620-738521
X-HE-Meta: U2FsdGVkX19m0tsZN8yo2A9pKQrlX33LPt9BSswKc19wfKJco9RUri5lYfrlJalF2gOkXNpRiv90S425+9iqy3YEdKf1QVYlLDixGaj2eh3bXZ/96zHOmZJZa+bzdTrCP60GcRn7aI/ME9DiqqEuKwQYRYAxRK6NQ34LcTRso7XTM4P8f9QCWsuDXtncSKKqHd27T8Qm3afi0t5a3sdf7D4zNXzjs3MIYSo6bQWIcReD60kR4cZAopV3aUtqmAMsAMMwmn/HkIosROJ4fz25VeCwiBqKG3xck36B/1e9BNkWzJWWqVJH3iQ+9PmTHC6WA6T5W8dbjHu0ivxqzJnwQky7v+lSU1yMQQ2HuZZP+MYACL0ZFWrqesO/Iw7e1eycODm2Kuct3tqDOrlUmPlSq+rSB+s+oGn0kz4QPrk/YgKMDSxDVKA/8gDfTzPhJc/t4ogicwzP0VGRCBtblwGVc0zcIYrRWV5+IpVmPEY6rNYkHqr79FadDBe6HEwmVOb/o+wfkqHW7bL/1QWTA9oyeSeVWjDmEjkoKbjp5PgNlzFBlPZlQDPfLg/5aS9lshZVG8bB97Wc9LysJ2QoD5QQMuvw3UXYdIZ0i2iKb1Io+EJZWv6h2GJ22PGjXLKpQ3TbS3lDNTdDOdKtLqZPJ8UFOXTF6x8oCkkIGoVFgJwoehE8V6cIejSZ7IOBjqhebGZ2lxy0QWyn2vLuSRPTgy5jIv9aXwBhhNrC46PVRluI7QfjWtz7BidgkBd25FhT9J3WfkX1v5MWgyXXCB+D48S1HQmBo3hYgEUqvGXg5qLfiHOveo85ZWHTgfREeGQWDSe+M9UpZYbx9QQ8eMEhHvR+FiO+N1PUGfj5i+sSkn5gQoZOVtONBSxMa0S/dr/9IJhN4BFdx0t/sxJn3wbmZ78TNjRJYUSTZTJyahSNjH4hu/zN6GIbrpMxN4JKx8G34QgLQz5M/eoU3oi8rxQiXZs
 cKG5Bxsh
 hiPbUA/c4Tzv3vE81Q3UxxCg7hoPCmV3+TSNOs6G1/nAr4qv/MYh9T9vYeygPQ1L4AhaHv3YPh7u1iSoQufswkuy3BDEX6motEbldHGW+BzuRBlNRK9riHr5Blk8yMSibXSb6SCByelF410K399mhJ71IEM6C22dJTjCB7IDNIxjs0vzi+WFqMKdjuUIEc1LEp1EZOxpA7wkrv2eGZFQt+dBOAYgne7w1yDj8NdSYtgbUbw3P53FKw7wPGISL8kFVqq+KJZT7Qhgj29QX8dhFEbmxOEgBGLwL2LxDkG/dCJrc1ZwGJQRDNk5AOmCKCNlvvHgkG7FLvTw2/nNUFDPvQ6O6GHgM7N8LHEQm+2Uh8LUoFMaBBcNiao3nVV5g5GIs6r6sPvKlMlBvuG8epLXrANt5liACahOfR+rEFzEyN+paOBre0M69Z092vHDAU7mn6NJkq8VMBpUN/QC8bN9eUYirutGqFc3UNmpBQGlg2mgmLCDz0MeSlmbomTe+Z85Jr32hqDlCMvJIb5sooBin0cIC0Jd1EgIbPliU7Xy0++DpiIBO/wZ4ux2HNkuEdt9hGnon4B1pPinIbw4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ARRAY_END() returns a pointer one past the end of the last element in
the array argument.  This pointer is useful for iterating over the
elements of an array:

	for (T *p = a, p < ARRAY_END(a); p++)
		...

Cc: Kees Cook <kees@kernel.org>
Cc: Christopher Bazley <chris.bazley.wg14@gmail.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Marco Elver <elver@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Alejandro Colomar <alx@kernel.org>
Message-ID: <37b1088dbd01a21d2f9d460aa510726119b3bcb0.1752193588.git.alx@kernel.org>
---
 drivers/block/floppy.c     | 2 --
 include/linux/array_size.h | 6 ++++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 5336c3c5ca36..69661840397e 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4802,8 +4802,6 @@ static void floppy_release_allocated_regions(int fdc, const struct io_region *p)
 	}
 }
 
-#define ARRAY_END(X) (&((X)[ARRAY_SIZE(X)]))
-
 static int floppy_request_regions(int fdc)
 {
 	const struct io_region *p;
diff --git a/include/linux/array_size.h b/include/linux/array_size.h
index 06d7d83196ca..b5775b8f13de 100644
--- a/include/linux/array_size.h
+++ b/include/linux/array_size.h
@@ -10,4 +10,10 @@
  */
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
 
+/**
+ * ARRAY_END - get a pointer to one past the last element in array @a
+ * @a: array
+ */
+#define ARRAY_END(a)  (&(a)[ARRAY_SIZE(a)])
+
 #endif  /* _LINUX_ARRAY_SIZE_H */
-- 
2.51.0


