Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 822C760A6F4E
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 08:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=ilvokhin.com header.i=@ilvokhin.com header.a=rsa-sha256 header.s=mail header.b=wWjFM+hS
Received: by kanga.kvack.org (Postfix)
	id 3EC896B05C1; Wed, 28 Oct 2026 04:20:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C3FC6B05C2; Wed, 28 Oct 2026 04:20:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 265D66B05C3; Wed, 28 Oct 2026 04:20:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D42836B05C1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:20:40 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E0B00C0BE4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:20:39 +0000 (UTC)
X-FDA: 85371338598.20.F8FC988
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf21.hostedemail.com (Postfix) with ESMTP id 598D91C0005
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:20:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=wWjFM+hS;
	spf=pass (imf21.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793175638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vb2YQU4qe6RImWUZBE+u9ZEB8G8V69bXRBRkb+fLOpk=;
	b=BgxH6IKcqfLIuYQRFgB8wtZ16YwHTDnJn3kINtqsJvlv53NB1L4foCbVpvS8qKm1mMCrSa
	48GjrABNy0WciO9zF5yyjfNl+AQrKRhu1KEjtthzF/vQnShNNj6uYg3kmclAZwervZx8Do
	SEBOp9VINT6M0a8ElODmvI6guIgKecQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=wWjFM+hS;
	spf=pass (imf21.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793175638;
	b=LLvJTq6avZl/OtLabDSbmNPy+NDD1JKkLbAob+J02/kB7JlqNvbzG6AzkRVZhjAZ4HSJLL
	ot71jeISXovExCVe6/pdpIVLRXmHumDYANLcGzVodqMa6O97X3B8lItb+7JoHvBdDEw2Cp
	h0La8ehetaFWwaEQWJJwKsOgLStaFU4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1793175636;
	bh=vb2YQU4qe6RImWUZBE+u9ZEB8G8V69bXRBRkb+fLOpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wWjFM+hSTX3U8gdI2PDKi0wYk083s1rAoIucjog4b51AlSk0W2rJkgCKL+Evcl1K4
	 At9r43JjYcrWS5tKi0AYK2ha19HMAuni4cqUY2nx1yH++BKUGrmpWP+YV3sBEzZllO
	 r22BvFE5Ff0AYARkeLMplF+npotdwEUvo/Wg0P2c=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 7B5ECFBD05;
	Wed, 28 Oct 2026 08:20:36 +0000 (UTC)
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
Subject: [PATCH 07/10] drm/gem: Switch to __nonnull_args() macro
Date: Wed, 28 Oct 2026 08:19:46 +0000
Message-ID: <5bfdc1491d297b5e98cf42322c790f06481c28c7.1793027261.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1793027261.git.d@ilvokhin.com>
References: <cover.1793027261.git.d@ilvokhin.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 598D91C0005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: oc9prapmwu1ico7axuuf7faiihsgmynw
X-HE-Tag: 1793175638-265680
X-HE-Meta: U2FsdGVkX1/dAf4gR+Z19F7J+klpTfpidj83jAXTB18/ypzGeU7C9ViHYWNeyMERG4V6DiPHWZ/9FzC60rF8h8tShLbAwRUXBVVk/bPBuSvch8FGVow81shXF2Fgeu8B6vDBjDG7TEbxpV46eFqxDEB0lM18wv0lWmEQKs5NQlgwlBjf+XkuIJx1mGBTP+FxsmTX4zDbvCUDtnn3lCm8vVdzPOkL/Ha0KrgU8UIJb7W+klzO95ZH3SYpfx7+9hnoZNEAnI5kUIDba4ILgfuVuGE1hM667X447WQAwpUlzw70oudNcFk0x1ysPybRYLqNxhJx/0FC2abPP8nLtdsJvP2dvCwghsroHArWfwVXz5aaylgdVVTsa+0GdXC+VBoFUDwYcQOWAN3/GCnU0sy9rH806uwdIcRVnSVMifkFUYD+dVzpX21ZC41QDmxcj5MAqNgvZ6sop++IKQq7zPknGIAXoD/g9bmFYjcmqRDba1uLGAidoBWF8GU3cxqrG7Y9uhhVYzLWIDZFisfdZFudxc9TLsqzErgcZDqnIboYR2xrcq1W/ojjk0gXprcZYK/qbLZYJG6O59Y0GODTrvbuWjZmAf+IppRWut42UjpBRDZIWwZ3Ia5r4ZUKiOuMu7mcKJCYwnj2M88gA73R1pDf6RXccOMagtslQqYQssf0ybZAODtjyCd5MTE190Oqk6Ecz7xPi0vIKnTQaMmty1jpYNKsSFq0xZK+HHeJWDJp9qNG0TRBvSrkrmoJpJGDtXGJKDP7b2X8cJaRBbtpOIPgR7wAuxa4DhljXhr+oMGmW45C+/vC+mAa+xlT5WxMsshbzfOafJ4Pzwtux84fgrpHgN2ylrHlTonUjq/+16WNdH+iX2kZr/mmVFCnj+6MrjWytgdCHhV6fy0MsnjofQI3usH8glne6YXiV0ZyNCn3IbHr9WPteYSa7ptllU0WzmBEajsLyz/UoEpuiUFY/pU
 8LZHgPFS
 LtlaG3/jCXW+qBIptZQ51E4wCFU/4UBQEYYjFcJ//MV57cLyXrhZ4pgWb9cYYa2Txzt5BS94vzolagtaS3iPlQYxKJ7hMNFRtmEsyBySKPHMzwn9oMjqVs9PKhqyHj4Mu5hjARV+caEnUH9Jbe9xCiNV5dUoDXrBlmSZUoob/fCcCFBAM7INSsPVTDgJQTo6ToBtzN6lPrccr/fQZJoxHZCgu94rdEndJ/3SCZUvyXsZFRwa5K19p8qxgdZeTKRXhOzNE8yyacT5eroWkl5jB8SbhyOqYlsPYAJVtOTpy1Vyp8DbuQFonBe9j/PWCMQMUkhCxLCMXJHiTgtmpDZ1Ds27+7YeGHOoesA/btvlhK/nZpBO4lFaQIgeSDWhLtf2mtSDBj84Y6s9icoM=
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

Suggested-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 include/drm/drm_gem.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/drm/drm_gem.h b/include/drm/drm_gem.h
index ed329408acbe..56dd15921c7a 100644
--- a/include/drm/drm_gem.h
+++ b/include/drm/drm_gem.h
@@ -566,7 +566,7 @@ static inline void drm_gem_object_get(struct drm_gem_object *obj)
 	kref_get(&obj->refcount);
 }
 
-__attribute__((nonnull))
+__nonnull_args()
 static inline void
 __drm_gem_object_put(struct drm_gem_object *obj)
 {
-- 
2.53.0-Meta


