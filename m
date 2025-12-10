Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1183D3E781
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 22:46:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A0436B0007; Wed, 10 Dec 2025 17:46:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0785A6B0008; Wed, 10 Dec 2025 17:46:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECFD46B000A; Wed, 10 Dec 2025 17:46:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DD72E6B0007
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 17:46:40 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 66AD6BAB6B
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 22:46:40 +0000 (UTC)
X-FDA: 84205047360.25.5D5DF2A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id BD569100002
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 22:46:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p0j+r5f9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of alx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=alx@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765406798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CNXDhEfUs2p7rqxHrG1BCgqb9DusTf8GED65ME2P2Z0=;
	b=g6rQ6EYFpy8LXC26QkBrh4WbPwWR68Q6GDeay11hdeZRCBEZ435jCjcpNTIwpF9+bwyOqV
	pIhZXPIPbmpVitfDM3sm5IXIc1vLovT6/ALWox1E5OnzNzoCcyFkW+yi+EADJh76sN8X2w
	4rBjd0SzOUXWdltubszyKjxjEZnobrE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p0j+r5f9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of alx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=alx@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765406798; a=rsa-sha256;
	cv=none;
	b=JirQttEPUFjbVd9J4xF/IzkC4kDRRG2B4hL4smmZeYp9LjGWTe+XiT2cx/XxZeeZeuglJn
	8nmzUHKBfjy2zGsaGW2DjJn4WybTK8yzOQIDXL0LMoSA/AmTX09QXcN6dlRvcSHoTsRTXB
	6ph8qQmI5ZCc9igvub3HfI6vKjAoggA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DA1A143C84;
	Wed, 10 Dec 2025 22:46:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF61DC4CEF7;
	Wed, 10 Dec 2025 22:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765406797;
	bh=2xVmGhP0PFx/hs6+oME8OSKXBynf/1IS5/aMFkAz6UI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p0j+r5f9ceLd8JHdJaXG7/kP8pHtSxWUPFhU+TbgylfEi6XsCOmOT7ltMtjUZtofz
	 Qs1F+acTHhoCLqplDmCTxk9we3iblfj2QoOLV78cMgJf2XnhfPwfuXrjyBm0TgaIuP
	 D5OMULpUvRNtf24eC2PYQhofqtglZFrh2rA5QOqN0vK/E6WtbZ22LfeQD4pTYsuqye
	 s3IZnsmwfqd1GpC8sFO37M4ynILFwQuQST9kbk47DJm6ArDM/BTk3WhCTA99mwg4iR
	 ehvsbtK5Kwr39gN2HxoYTOuanvMnE16zsb0qeY/eVBI6ELoiJucKZE4NdeX2Fxt7ca
	 nPMzwhrijLiww==
Date: Wed, 10 Dec 2025 23:46:32 +0100
From: Alejandro Colomar <alx@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Alejandro Colomar <alx@kernel.org>, Kees Cook <kees@kernel.org>, 
	Christopher Bazley <chris.bazley.wg14@gmail.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@suse.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Maciej W. Rozycki" <macro@orcam.me.uk>
Subject: [PATCH v5 1/4] array_size.h: Add ARRAY_END()
Message-ID: <5973cfb674192bc8e533485dbfb54e3062896be1.1765406337.git.alx@kernel.org>
X-Mailer: git-send-email 2.51.0
References: <cover.1758806023.git.alx@kernel.org>
 <cover.1765406336.git.alx@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1765406336.git.alx@kernel.org>
X-Rspam-User: 
X-Stat-Signature: y7gbxfo981tqhs67hj67htekxtba59g9
X-Rspamd-Queue-Id: BD569100002
X-Rspamd-Server: rspam06
X-HE-Tag: 1765406798-843243
X-HE-Meta: U2FsdGVkX19pYvoyuE3L44LAgLmX4JKJ4yaUKvzHyxzOtYxW7qfVuPyirwWEX5P+U2Y9vgZMIKAlLc8O3mmStMioXbigZLeLH/13sK+QrHtiNtvRki/RZzJO9FtWfnCsF6Q2aXSrLk3eDcF36rLCwh48IFsrMHkldvBRCNWFJKBZEHBvrpjjAwoOYezuUo0LlkNH35hpsnHbcX2FUi4uK8ySR2KuwnWfAdzcLrBc0fUQmlBqPn9dhD/KiMt5n+rdrHkxiHEyIN2pFc81VNYRmVhdg1DKivf/UOiatX++5swCPNvBAebYi0W28Z3OcPO9ZLqcmrmkiizbd6ZcVneqiSXJ3Vjr2zzROP7T92mmRgJvVb8PNNswEjIjwHVH/Y1rpMb/K6E7zW+x3KbxCnf3YoTAKkeKTQJmbOK0cflwgxxjM6X0srDZPgfWtcv9OIE+jpWo98uxuLc1bHFmBe/Oh9nXqcqCW2LPw81tYmzE62ZOH2WEaFOwsnAoiZ4B45iqhACmqaWM5vobKTh6gmdnzmeiFVkGzajmzhglkYJOVjFofp9yX8cpZLbMZbpyYVludvv2G9qKvwFduXGBcEVu4KZdAy7Hm4Ek3Ax9ti5QhofREpl7Li/jMhqkmdiYYLko6Q5kEk1M6Mc8mVpLiQDJjOFVb+ZlNv+2d3ngVOXMyXRRa3GTjB70+bnAuA765+u46plsOE+dN2WsDITomAnIkf6zYXFyQ89rlEM3urQ/F08m/mDFhTSyXbpoicQaai3jn0b5gKR+838cqWT/BPSae//01AYgy/RgghIRsfySk8Sa1zJVu8EzQGawE+zAlDKOek8beQ71UpmMfkv5p6e6GUwNK8Hp4AXFQYhUlsBs7M/+QC7rwPNXVhqo4lqhaeLZIvOdyUaQDyh1COtBKUrVwa7rY8MPJrfWBTnr6x9ilPLrsjPbdj+nRZzlV13AfXQ23j1OMbrh7Y0PWZYlaNk
 /uGtlmWk
 +8k7U1uZbx/CNW5elglZQkBGKWJe0rj0cpzXcwRwyr9iavhM=
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


