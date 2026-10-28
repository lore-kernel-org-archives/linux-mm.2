Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C81660A2610
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 08:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=ilvokhin.com header.i=@ilvokhin.com header.a=rsa-sha256 header.s=mail header.b=fRqV9usC
Received: by kanga.kvack.org (Postfix)
	id 12EF26B05BA; Wed, 28 Oct 2026 04:20:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DDF76B05BE; Wed, 28 Oct 2026 04:20:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC09D6B05BF; Wed, 28 Oct 2026 04:20:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C0C276B05B6
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:20:38 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 48258A0C4C
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:20:38 +0000 (UTC)
X-FDA: 85371338556.30.55F70ED
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf26.hostedemail.com (Postfix) with ESMTP id A9085140009
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:20:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=fRqV9usC;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf26.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793175636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AdVY/3WZr/KgFPIGBWq+6cOVqwnT9WYPit6o2kFUWLI=;
	b=zjib/WhY0/GBjNLD8QhsgMTgSxOOr6D1W4gRIP7JS2ghUL3kCqRlwylqtvmD35nwvu1PJP
	hizuR+Pzx2a+rmZR/z9xdzLiVoL85YoRz1I1Ny/+9dAURYV1yPYZ//zuM4pic8LrtFTuTX
	US/wMy7Dm0uAWAwPJ1esc/R6nGAM1ts=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=fRqV9usC;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf26.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793175636;
	b=ueVlKiiFrQZsO46heC40QV2/p86DXH/C6i8FO+6gZR0ht7wJMd1YM3doDJqw4EftuYNbmF
	5QCUHXAyHhOaDBLRnoEiifSdn6rVDv4sHUMSa1Wp/PONpjxS5gUzqGe/QQQUbfs09e7Bss
	rqLpKghJoAqDMvStKIOcWN5jjXgkSwQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1793175634;
	bh=AdVY/3WZr/KgFPIGBWq+6cOVqwnT9WYPit6o2kFUWLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fRqV9usCJkdMBWrlhWbddwDwn+QiWrVuXXhlmM06WA8hyjUwJjBOQD3oUvn7U51hA
	 cz9ypprvSW6rwhpGQQm90dgUka6nWyEZzu4lfjwdDuK2/cx66TCGAU3CwyclW84k6b
	 EOioxvCx2Rj0sgA/zgEBxG2IHQAcr5/J9BnKuTEI=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 65391FBCED;
	Wed, 28 Oct 2026 08:20:34 +0000 (UTC)
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Lee Jones <lee@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	Joel Stanley <joel@jms.id.au>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Ryan Chen <ryan_chen@aspeedtech.com>,
	Billy Tsai <billy_tsai@aspeedtech.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Kees Cook <kees@kernel.org>,
	Andy Shevchenko <andy@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Whitcroft <apw@canonical.com>,
	Joe Perches <joe@perches.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>
Cc: amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	intel-gfx@lists.freedesktop.org,
	linux-leds@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-aspeed@lists.ozlabs.org,
	linux-hardening@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Dmitry Ilvokhin <d@ilvokhin.com>
Subject: [PATCH 03/10] lib/list_sort: Switch to __nonnull_args() macro
Date: Wed, 28 Oct 2026 08:19:42 +0000
Message-ID: <580fdfbe2eb6694438cbd8f5337bd2f1edac564b.1793027261.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1793027261.git.d@ilvokhin.com>
References: <cover.1793027261.git.d@ilvokhin.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A9085140009
X-Stat-Signature: oeakdte5fzg1yefj37kdd54x9z9xnmjs
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793175636-478825
X-HE-Meta: U2FsdGVkX18H06wngjGyrfawnyCDRKl8Uhg9CYNxOZVG/qrbqwTNmJD+LT9Tbeq35YlBfs7u8qAQFWX9KsNHpC8fAJHaFkaw5FcS1fIGPQyW7YGGSRvb2LJHhNNgoJWUgvxlnyM3I2c8bK4aAqMTHG5eaxLRZ40KX25BdEFsEPKETPGaPpLg2bNzjx3hfp3cM12CVWDtvFDgd0AMFGRB/f3wAnzB/2SFtakeANX93Mo4zFHwwnNjPcpKFfAgPS6t/ItjQ14BWJuktOte3QeanRKc+UNU+cpHd6ZsNF6zJwvf+x3/XoxoJeGwwHeIk3L05HujC2KovNyBE1XFh/wNi6IwRIXd1caqO3Smpr65L3jXXO2jiv5fbuP5yXK7URDW/RYNosDKl0NDpyMXiNFFEUmQTQGLCUcyT7RU7GVcAQoOOIZkbKf2bJO9wSM00emlm2Q5ZW/kX25AXQXFfSBpoChmQ+1tUKBIf8z7VIMkLF6nVRdkzAOoJxuxlAwaajQZF4rKhrtdI8bzZgE4Si67xkiCCWLSMWa1wyRLTgb9GXGCKQ9mLIKlTg0Cs0OUH7+I0+wezt2N/QRKYZylvzYonJnQQwmeDzh1PFvl0zGvx8sHfkSnvzeMQVjWAIXnGHcZc79EyKhG43vU1EHKJvGHkr2utfUl5RrH7rf7GN1RemEiYi6lG+iEl1vb/qBY3up3kkQvi1oYyKDQW0xwg4pCRp2fgnk9l2Po4CtjJ3nXFAWYH21fjJWczFuLpqmYLGZKliqjvGrFxbvgf/ON7tPr0cBXIBD0TZrll44CN9J/qRguYPXjh074XovBNvmtI21nJDJCTOORjj1dgUXfVaTPY7tw5yzkakBbkyQe9MjXY8MNgVUQFo9aj0PASbYwcTKYJxHbfbQAdtg1KtC9QkoW/GqHOto1oYmcA8ECPAMtJx3PB4Uw0K0fN31mgcI3ifpzE+Kvqrqof17s6LDwGXj
 WjiwY/jN
 2l24CUQSkZxwKh51edrq5L0AnHzVMDQh4Pt1L00oaXqUpA4MJ/UwxnfKQ7RmBtxHqWACK/ddzauTHNiVUi12cAdQEM1jUHlIk3CDdJYUaTPDis/a5VdDFDExorSFdaZ9nj3zdAoxnxrMPsWps8f+P73+CM5hQ9radRlbMo4uSjbj2pyb/asKAbuG4G8ez8OjdWhygJd+x+q9HG7G06v7mJx2mfMUOTdqJcqM3QVFS/8jZyhyf/JRFtzENsFVl0oVxT/z95YWgEHD7ATMQbEATj3b8eb8amfFTkKCvhSE7y6Pwz4zjJWer0Y5C8B3u2ILUdL9fvzidH/pGpYiDLmZDgc8bOf0EQR1a3j6qTwqhT1r5JKEb4A0mpHSCqvbJmtK3gw4cxLhu4zxM0+8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Commit 22302af28d3f ("cleanup: Annotate guard constructors with
nonnull") added the macro __nonnull_args() to wrap raw compiler
attribute.

Replace __attribute__((nonnull)) with __nonnull_args() to
standardize nonnull attribute usage across the tree and keep the
attribute's quirks in one place rather than open-coded at every call
site.

Add spaces after the commas in the __nonnull_args() argument list to
follow the usual coding style (according to checkpatch).

Suggested-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 include/linux/list_sort.h | 4 ++--
 lib/list_sort.c           | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/list_sort.h b/include/linux/list_sort.h
index 453105f74e05..48a91ef0d751 100644
--- a/include/linux/list_sort.h
+++ b/include/linux/list_sort.h
@@ -6,9 +6,9 @@
 
 struct list_head;
 
-typedef int __attribute__((nonnull(2,3))) (*list_cmp_func_t)(void *,
+typedef int __nonnull_args(2, 3) (*list_cmp_func_t)(void *,
 		const struct list_head *, const struct list_head *);
 
-__attribute__((nonnull(2,3)))
+__nonnull_args(2, 3)
 void list_sort(void *priv, struct list_head *head, list_cmp_func_t cmp);
 #endif
diff --git a/lib/list_sort.c b/lib/list_sort.c
index ff99203f208f..da34c46cf5d8 100644
--- a/lib/list_sort.c
+++ b/lib/list_sort.c
@@ -9,7 +9,7 @@
  * to chaining of merge() calls: null-terminated, no reserved or
  * sentinel head node, "prev" links not maintained.
  */
-__attribute__((nonnull(2,3,4)))
+__nonnull_args(2, 3, 4)
 static struct list_head *merge(void *priv, list_cmp_func_t cmp,
 				struct list_head *a, struct list_head *b)
 {
@@ -45,7 +45,7 @@ static struct list_head *merge(void *priv, list_cmp_func_t cmp,
  * prev-link restoration pass, or maintaining the prev links
  * throughout.
  */
-__attribute__((nonnull(2,3,4,5)))
+__nonnull_args(2, 3, 4, 5)
 static void merge_final(void *priv, list_cmp_func_t cmp, struct list_head *head,
 			struct list_head *a, struct list_head *b)
 {
@@ -175,7 +175,7 @@ static void merge_final(void *priv, list_cmp_func_t cmp, struct list_head *head,
  * of size 2^k varies from 2^(k-1) (cases 3 and 5 when x == 0) to
  * 2^(k+1) - 1 (second merge of case 5 when x == 2^(k-1) - 1).
  */
-__attribute__((nonnull(2,3)))
+__nonnull_args(2, 3)
 void list_sort(void *priv, struct list_head *head, list_cmp_func_t cmp)
 {
 	struct list_head *list = head->next, *pending = NULL;
-- 
2.53.0-Meta


