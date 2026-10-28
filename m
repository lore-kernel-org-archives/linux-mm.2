Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE50E60A261B
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 08:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=ilvokhin.com header.i=@ilvokhin.com header.a=rsa-sha256 header.s=mail header.b=DeIiv9WX
Received: by kanga.kvack.org (Postfix)
	id 3504C6B05B6; Wed, 28 Oct 2026 04:20:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DB126B05BE; Wed, 28 Oct 2026 04:20:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12BDE6B05B7; Wed, 28 Oct 2026 04:20:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D0E076B05B7
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:20:38 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3D7EA12034C
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:20:38 +0000 (UTC)
X-FDA: 85371338556.27.47A86C5
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9C8A840002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:20:36 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=DeIiv9WX;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf17.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793175636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dWJJn/15+ghgzzIGKgM3IMULkpSh/eugDFHemmlBRb4=;
	b=Ti6QbTUhnJSFsUYvTyFYM+urtAqMHOIsif3L2B46tdteUh9DyCH+r+1QQW7GJdZrQ6mHN3
	gsXGd689ed6IXKuSHZCqzkaMXUjTZlH+446nsDGPBkBWE9Vo885FLD4yy0zL4G79Em7peq
	H8qvMmmqnoeY4NVq/1pDTQVMhsoZ4jM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=DeIiv9WX;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf17.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793175636;
	b=t43RrvWuEnTVvAhHKTVUA18Qq1MY+QwKPikWuqfbXcQ3KGO0YaeK3s9Ym6xfHSlPXADyqN
	k/IuJvE1yjSJ5dhCJOxCdo66sCTxjeAqnyvdilUsCB1dpvJ0W19Gy/pobsL2Fwdp3KWPdQ
	Ock6JerLD3ZlvmY+jmI4k9CAO9e1iaA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1793175634;
	bh=dWJJn/15+ghgzzIGKgM3IMULkpSh/eugDFHemmlBRb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DeIiv9WXQV3gD55AucY67CXV5GytqfXEJkOIlH/p1vvpmEBa02wb0CiZ7FetKO8kp
	 vKMP3WYwznobDJIR52jidVzMPZfhGDf6UWW8grvqXfGJ9aPtokciLL67F0nlp74wpP
	 VCbSuHZCHz4d69J6NRvoiFKB6uqBPcC0poA2OXFs=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id DF86BFBCE8;
	Wed, 28 Oct 2026 08:20:33 +0000 (UTC)
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
Subject: [PATCH 02/10] string: Switch to __nonnull_args() macro
Date: Wed, 28 Oct 2026 08:19:41 +0000
Message-ID: <f0d7b2f0dce916f4cde3dd466a5b51a4b88fbdd8.1793027261.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1793027261.git.d@ilvokhin.com>
References: <cover.1793027261.git.d@ilvokhin.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9C8A840002
X-Stat-Signature: 3sptk6abdejajt7anjoekjy6dt96tci8
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793175636-968178
X-HE-Meta: U2FsdGVkX1/PO2fky0T+GGADd9sN9qTGjfNIAeAZnQ9J2Xqz/QTqF0NXES2EtaV2lodDI1cH1d5CkgHGsptajSQksgskFIqTm0l2OOjOWvNQGemacK8Afi73KqG9bWENWhk8cV76ILGXUa14Y2PU4PQFZbGSTLY1Tlw0ONizScDlkdgTay+hT+ZydGjGzQ+Tm3Cosws3qeYnUoZZzUdCPj3HIcJufvMnIL25W8T2+cWK5YZD9u8lRF/F3YC76GeYOb4A/+8ntfukNIjbL1u1P9EjugpipKt7pOFqPWdCbiYXjcYmYRJz0B+NcRgqx4FaVV5K/Bk3HK1m7T7+gmMy/nn+wrpM0I35uOUHb5bzCbkO/48Laz5XDndNTf/wcR7IyWgLNmiRmOA9d0ByWyEqFv1MlxL/VLX90CBovRxxcWK320dQ3GmZh2SWhK4TPiOUhXrOEBn3QVuO+aCC0oXVvCI51J5nxNFuqxb10/8acMWX1zBGvuup6mxVOIPCUj6YYcI3ai8IvS4vNbuZ11Nw+1FJodiW2WoXRfBj+r7p8BZ4LADPNM1Jb1G0WKHVIdSY2pEN5QjbCIp/l7CWI60nh3+9HTzdwQudovl+duU5+TH5gnyE5n1pXy6dJYW1D01AnhxjSfx0INnxrF6vFmYO4tAoUMbWir2HPY2s2e8sPgJYQKttjkNCq3SLteVzABZuMaY2J6XtnMxzZQmyLj8NdofH/SbwmpiSVUxFMCxi9UZuue0az/Zsz04DPcsTOu50ZIYkQkNcidQv/fqhRxPg82d7i0Kiw94TuMcj7pPuh43wfkzD7xE+SftHqj2N69GXr/TgugATICQ6o20Xg0SqXVtTHn25KlfVlZRwBw00Y5oDJX+EAe4KTnaKp8YZWQBfwdSKcPePo6HjcY6WpCI4uQ2w7SaoIPvtPSBIspW4vzXGWb1s26zP5tqS5YQvm7Z4Sur+MNLnB18gtrEDxZz
 2xTn5yFP
 r5jcBQDdKeaF3tHYyoXnBYQBPS20GYq3RbyD2l6ROxxZl+09VZDlWgI3Lnax8rVJXj1YG0xdaVhnXf+izsinj270E+4G7JJXIp4NAB89ekBhJ5STgWuOIPCZunczxKWLr5RulAzHapqWC5wigkHolHf0icaj3VrymiWdsH+gfRKkvgRT63/S7VueuciCIt6dgnFB7Nfsoxw9UE2WdufReX5unYwtP62iXwQN/yTTMd15NOcioioxU+x4/bU40qWgRZedpihwxoFTJ3GyyDbWEenBYzRQjILcPnezldWvcMNICNspC5U3tlplz0NEg63StQoWHPWjtbxKPre9q3qQi3QmLRv4F5iaDr5QmKgnV3lKMJBzNyDUUwsO+7CfbOCNIdQDfH9efBTay17w=
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

Suggested-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 include/linux/string.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/string.h b/include/linux/string.h
index 6cb5cdd01158..1f1cb73514e1 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -587,7 +587,7 @@ static inline bool strstarts(const char *str, const char *prefix)
  * Returns:
  * True if @str ends with @suffix. False in all other cases.
  */
-static inline bool __attribute__((nonnull(1, 2)))
+static inline bool __nonnull_args(1, 2)
 strends(const char *str, const char *suffix)
 {
 	unsigned int str_len = strlen(str), suffix_len = strlen(suffix);
-- 
2.53.0-Meta


