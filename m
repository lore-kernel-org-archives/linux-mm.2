Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1CD960A3837
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 08:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=ilvokhin.com header.i=@ilvokhin.com header.a=rsa-sha256 header.s=mail header.b=Jg8BLE8I
Received: by kanga.kvack.org (Postfix)
	id BB4136B05BE; Wed, 28 Oct 2026 04:20:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3E0C6B05BF; Wed, 28 Oct 2026 04:20:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A539E6B05C0; Wed, 28 Oct 2026 04:20:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7470C6B05BF
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:20:39 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EA958160C33
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:20:38 +0000 (UTC)
X-FDA: 85371338556.08.A05A974
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf18.hostedemail.com (Postfix) with ESMTP id 53D811C000B
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:20:37 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=Jg8BLE8I;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf18.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793175637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ceexsp2t6/v12ItyH2pSPyV+syh2rxnTHvgHk3Ni1dE=;
	b=rOONv5eDO3R6/Q/17wUK9UWs050oMqGTxUNgJkB8JFqr6IgVOEl1b035wv2ot/dvpcu7+k
	uojBi305RI+Y9nFqz59GoIk95v4vRhaAGaUp8wWXH4ikpYym730jCr7QCmOzuPuRq3NmA1
	WyOot22pDk+Tw+XwUWtleyAZoBOKs8w=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=Jg8BLE8I;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf18.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793175637;
	b=GAfYWDFBibi9mpqZ0A4ZRKpjymIcGVy5aYx+tkZQm+K0SnVA6C2y4NZmDDZ+lx89dTWaBp
	Dh6z/3ZvoNY+5q9CKKcJejZarzbNbyK2EmaOT+ffgm8FOvfzsZ1Q08IkyE5zfqlKk10NvH
	idJSZxZzRzNsQNKK4BBWfx0/Dd0YnL4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1793175635;
	bh=ceexsp2t6/v12ItyH2pSPyV+syh2rxnTHvgHk3Ni1dE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jg8BLE8IZCB+yObRAAqiVmVgU9sigg/nFDUGFqQXhWnSUadRZwDKyR4LY8EpthVle
	 pA/bIha5skUWK4mVY8+AIkx6NRdoOUTSd/zD45eghCBSekWpPyZ52q6p9FUlikkAVg
	 i5iCn86ahK5MOiZH/P0BO+c07/rkr7dgAwZrsWjg=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id E1323FBCF2;
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
Subject: [PATCH 04/10] xarray: switch to __nonnull_args() macro
Date: Wed, 28 Oct 2026 08:19:43 +0000
Message-ID: <e2660c4c9f5e6f97be2ef7bd3752d259bce77d81.1793027261.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1793027261.git.d@ilvokhin.com>
References: <cover.1793027261.git.d@ilvokhin.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 53D811C000B
X-Stat-Signature: sdaqwapire8h5e5m5wc5k7nsisnxhcmd
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793175637-307075
X-HE-Meta: U2FsdGVkX18z0vuxDuMwH+RQYU4tpHzGXwnoovJVOyhWWcqdcz4h5Q+swUz/LEueV0jiwyuJFqENEw2pYVoXBPuQIyEykVfP7wCrurucE7n69eVBCbEsxrlV8YYUnqlnIMnKxquknNUyikY4kPIulwHH8Dq4MyXCBAEMUqnx3pEvHfXCXFbaeHkeklEaJcA6iRP2JNAM4GdicqWQwhCgaJ7azpthumUlKjEhtomSYAamAzR4Cyv3YmgKCdK2O4LKoP2JIOul5TbSPl4sPbqQXSgnfps5wasiJHLupEhoyqaYIlAC5mdiUZgQCIwxqHtxYldqJ+KTtukC1HpDkUXBt7QFmAV+uy9eGakBCw/NHnQJAXLQFKz4bzfUZtga2G76MCWtwDZqMMjsDZA8FvPVyE+1ggYE4JqpZQf8N9d3ffJZ+Sc779MICftuUwoE6GXh2WFP9F+Y95foz1701bHtro/e7ot3tKBzT5VdQs2a6I/PfVi0aK1auMNS1htPzNlr+/WvoLVxGfitAXDR1G5Zsj+l/kq5RSADdEpIDrmn+NAnfWiNJ4sIVRNNvMNAbyGktD+5hGk4wMcczD8xyp8iQRCiNL1G1sNokitHs8VGxYNwUBf8cartfI8Uoshj9hMuVpd07z5NpUbWZ8wF+dtzg3YM3HzYRQW5+5+/ErK70y93ZXxFEgcCfLbH6gutDMSfZh4CKdbIVNWcDq9AY4sHjdEE81io+qHL3gNl3D093SpYlowN3qleMC6xL8zwDK9oc4ohfefmAfGwHJElWU+MXcFSd1pk1nLMLSxTJU/4GMhJFs+QICF1EiSWQCq+HBc2kW0MLdRvpDcm6CEwxHgaulKH5AoJw70AqV08CZZ1B+fHOX6L8amASmTjUpnkDpjWexAeRgA7MgPehYKaHy4ToUQq8x98V2NbkOUFqwpY2cPuB5jesjf7uEqdR86tNbrdIWZVNnX9cdKIkDLfUhP
 XpcFmSFV
 /znMVzW1eQwXKFCXdEEVClDR4Ah8D7tZ2cI3tHvgouRQNgXH/+sWL+HjMJjVn7/ZMyLZHucgJtHmx+64vRNCVfDTBDUIm5VRwr6yCNAc24uzYq+m20VLZQqPgadgS/18CrrlWE3w3tZH83qd1lGBXoXDFRuy0nL0WG/Fxd9RQ2B5S39SKCOa+nnH+LW+n9dvrGrrgh8BEwuijPTE2sya1sm8eCUriKNrozR1yWyDHlv9QZMZ8E5rRrZtLaCGXHSTAR3q9s2ng3mlkAXu3usJfi32ahxCn6fce5CYXmsKJ695Kr6TjE5/OTrvYB6LFhNv3nY0AZ4h+ANHjlAHlrnF2qmDp0euIP/FVKb88D3a6jMTJHY2W0OsHTTggOgDNVe3j5hGD7gUceeoe/xY=
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

Replace __attribute__((nonnull)) with __nonnull_args() to standardize
nonnull attribute usage across the tree and keep the attribute's quirks
in one place rather than open-coded at every call site.

tools/testing/shared/linux/xarray.h directly includes the kernel's
include/linux/xarray.h, which now uses __nonnull_args(). The macro is
not defined under tools/, breaking test builds.

Define __nonnull_args() in tools/include/linux/compiler.h.

Suggested-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 include/linux/xarray.h         | 4 ++--
 tools/include/linux/compiler.h | 4 ++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/linux/xarray.h b/include/linux/xarray.h
index be850174e802..cf7f8802da5b 100644
--- a/include/linux/xarray.h
+++ b/include/linux/xarray.h
@@ -361,9 +361,9 @@ bool xa_get_mark(struct xarray *, unsigned long index, xa_mark_t);
 void xa_set_mark(struct xarray *, unsigned long index, xa_mark_t);
 void xa_clear_mark(struct xarray *, unsigned long index, xa_mark_t);
 void *xa_find(struct xarray *xa, unsigned long *index,
-		unsigned long max, xa_mark_t) __attribute__((nonnull(2)));
+		unsigned long max, xa_mark_t) __nonnull_args(2);
 void *xa_find_after(struct xarray *xa, unsigned long *index,
-		unsigned long max, xa_mark_t) __attribute__((nonnull(2)));
+		unsigned long max, xa_mark_t) __nonnull_args(2);
 unsigned int xa_extract(struct xarray *, void **dst, unsigned long start,
 		unsigned long max, unsigned int n, xa_mark_t);
 void xa_destroy(struct xarray *);
diff --git a/tools/include/linux/compiler.h b/tools/include/linux/compiler.h
index 03ecf9086643..fad2c6131a80 100644
--- a/tools/include/linux/compiler.h
+++ b/tools/include/linux/compiler.h
@@ -68,6 +68,10 @@
 #define __naked __attribute__((__naked__))
 #endif
 
+#ifndef __nonnull_args
+#define __nonnull_args(x...) __attribute__((__nonnull__(x)))
+#endif
+
 /* Are two types/vars the same type (ignoring qualifiers)? */
 #ifndef __same_type
 # define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
-- 
2.53.0-Meta


