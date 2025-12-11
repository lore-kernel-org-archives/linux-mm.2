Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C0F4D41C17
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 10:43:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E999E6B0007; Thu, 11 Dec 2025 05:43:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4A616B0008; Thu, 11 Dec 2025 05:43:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D87466B000A; Thu, 11 Dec 2025 05:43:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C7DEA6B0007
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 05:43:57 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 698408B116
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 10:43:57 +0000 (UTC)
X-FDA: 84206854914.26.54195B1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id B426E4000A
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 10:43:55 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K9zhqO8e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of alx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765449835; a=rsa-sha256;
	cv=none;
	b=n4I+jjkbY+2aN1m4CwI6up23+CLDlKTe2z0Pmw4e1XLvVlTRytJASSClsxNxts8S0jo4wZ
	GHsivIh1ouAUrJf5lY9VXxWECXmhlMUdeT+YIEYv/xjjSkQMZdZG/sMGJ2NISgvN9Ak2nM
	wF3mA20qx1EjbezwToddlw5D9wwZHow=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K9zhqO8e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of alx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765449835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CNXDhEfUs2p7rqxHrG1BCgqb9DusTf8GED65ME2P2Z0=;
	b=q2zZHN5MHMwRgheG2O/eTeFQobnlCkLYOjpzc0tpsFrIhsiqE/fmkqfDH5CsL1jp7hCM7S
	Yxg2paKD2Tr9KNzxV3XeUZ6ool0QDFIm1J6krUXTEiLgNFg8VqXpqdmej6Ql7tB8BHdnZY
	dP54wBhOKkITSID/NAvZ7hyIdByZNuk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CC56C60151;
	Thu, 11 Dec 2025 10:43:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 978E1C116B1;
	Thu, 11 Dec 2025 10:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765449834;
	bh=2xVmGhP0PFx/hs6+oME8OSKXBynf/1IS5/aMFkAz6UI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K9zhqO8ebB/VUKGBrQ1r3WX69JHHTEQgI9B2kxnC+jLmwKWooo/4A1tZV9T7+p3fT
	 zp6P20bxrtxphcno96IgwkJNTcEJCje7itPRtpTyvccmzzGp2ARk5zTomK7iFlye8s
	 7C23XcNrJNfI0j9O5ZU5eo0X4tA/FKAAqWIHLvclQ8unbHXg9dBo6veu+Nso8/aVxs
	 698U5ANWF94kPC18hsxXLCsF8OBftDF0MNEGsR+yeBn3R0Yy7ccLtGo/Yt6vGju2R2
	 A+rs5KtDnTcxGNzvNgSyjwa+/AyQSXuTzYWkjjH70GbYOFR+3B8+wIYA1WgQ0Mc5iC
	 qUBuz7R20S4zg==
Date: Thu, 11 Dec 2025 11:43:49 +0100
From: Alejandro Colomar <alx@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Alejandro Colomar <alx@kernel.org>, Kees Cook <kees@kernel.org>, 
	Christopher Bazley <chris.bazley.wg14@gmail.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@suse.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Maciej W. Rozycki" <macro@orcam.me.uk>
Subject: [PATCH v6 1/4] array_size.h: Add ARRAY_END()
Message-ID: <5973cfb674192bc8e533485dbfb54e3062896be1.1765449750.git.alx@kernel.org>
X-Mailer: git-send-email 2.51.0
References: <cover.1758806023.git.alx@kernel.org>
 <cover.1765449750.git.alx@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1765449750.git.alx@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: B426E4000A
X-Rspamd-Server: rspam10
X-Stat-Signature: 4aj1heyhco4n4o1o9a1phigib5zikwab
X-HE-Tag: 1765449835-437099
X-HE-Meta: U2FsdGVkX1/5OnENzV97pB6TfJ8idHeCPaiFZHAEmag6ciCCbxDd5iEwPGZuu7Ae+z1g7b4ArKEAUv/XuEt+6ki+nmfcP95u5H64qa5Ln1x1XDdZi1EjBqjyxzCG6OKnUOJmRan58uBMhtMeC6+cp/VPaxNSaiSDaf2ufPpX9rH2x63bxkQ9CI/CAoMK3zErs1lNUCnPoVD87OoPh0rjZsF8TT/DyrsJQ0RCMTPxu5jP6GveAyZ2s6JLFv5PSBGS9Zdvvpz2HDM1coKPKmeB/SKTOHjmTpNOONPDe7RaeL4e75fVYnBkzJ3MZ256UJyCS5TtqwLiaaB07BSVo6+BEIVm8+d0ef5XFkWMnIaE9rWQjW9pRmvsK4PnRFnWHVVz+bdRCrFkvMYtfHnJwa59xD5tEboF1eLEGkS/boJk1P7F7A4hs67Wc8g6CZ/gxs9enfgeK1GiTXLc6G8hwK7ESQ+KfNZwuTKfR0BngH2QZkV2P1bawzHQozp8DgaCLkUezUn7+OGhA/ieeojQ8yMLUL9g9mN6T9PVG5sQxSqq767tZ05Kbhxk2BdgC2NK2YZ5HyTO0X3L/gVB535HA4rawgH1XUz7b6SlmRw6J4tCr3qVMCkykVA26oSwq6rhXMZ9quvwu7PLV9LSZJe+ZMSKZDoJN6fpPZbPtsa4VoLE62jnkZudj0oDgCvjbgWgKkOf8eBfUsjEyJsLn5cnMs2QaJ0VrDokUZ2gOmuy72scECZnDlSF1+DDg12WODQqA5Qj/25CsA7VukC0bM5cJwY26HoGVP1pVaUyd2yBV1y1o25PbpvSqLkxU/SsYjR+XXwdqqyD0V0YTACSWPgqAhe4xuiFQhzBnbRay/3YISxp04UjnrZHYiKRRJ3KhSrpJlw5AMHa6hSTqasrzmS0117C58yDRFmhIg+A/2OPOeEzmvyad3TaBuO1QoE+KUMC28ySR9jSq1bpNzVHNNGOijQ
 QDEQMWwg
 QiRn4Pmf2Mijg1yAX1F/CG0QJZQNVFeYz2ZxtFArdDTPa+JXLX+xyE05f7nL0a86quDSNa+cJu5SKwdouBi62lavhP86FXRNsoRwAe9Jjb4m13tB6Yijxy58yOl6RfnDp/U7ybQn2pBnTCXwfyjKDFFLOI9EzUuyrYaHGKZuh5lpEt7yfjhjl9xI7z+M751RKuqKIQaGhvFzW6MRnt9cO5fVr93jmqle4mVeCJJmokhhvXuWw6+gQQrZthd4oulECDnDsqeYn/nExxW4yuTQEuIulM4mHFtTbWY/eZLWpdDVODhVAjSJUkOrOUENcJtv1o7sc0fzg+OyHNyNlVrlH7dqVn9CgDsVI+Ti4UtiDH+fYiqOTY+KZAMmG39gYSY9FSn/AmG8z7QH6WuJ77CKo676p706qSoAKfnHM3qsCItH1HRZK06cPxFXuO4EXfDZotI4mUAy/3iyfIy6Bu2xtw9N5WcYb/iigG1ZRFbtElAvpQvYb9RB0YtXn0E9KSOzuI7bgthRKNXCv9R6ivFnClAzku5Lk9dFPPyS4W73wYjVWdIyYMd6xUs13SRCjHE1VApEuiqvSUeK43gqO6G853hC3/svEybqgIGFuotaqnmaureAOqO1SWd1jKGabgfM7PomBvWtyE50Caj4=
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
Cc: "Maciej W. Rozycki" <macro@orcam.me.uk>
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
index 06d7d83196ca..0c4fec98822e 100644
--- a/include/linux/array_size.h
+++ b/include/linux/array_size.h
@@ -10,4 +10,10 @@
  */
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
 
+/**
+ * ARRAY_END - get a pointer to one past the last element in array @arr
+ * @arr: array
+ */
+#define ARRAY_END(arr)  (&(arr)[ARRAY_SIZE(arr)])
+
 #endif  /* _LINUX_ARRAY_SIZE_H */
-- 
2.51.0


