Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6506B60A2633
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 08:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=ilvokhin.com header.i=@ilvokhin.com header.a=rsa-sha256 header.s=mail header.b=s1G4iNj7
Received: by kanga.kvack.org (Postfix)
	id DB0126B05C0; Wed, 28 Oct 2026 04:20:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D87866B05C3; Wed, 28 Oct 2026 04:20:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C011E6B05C2; Wed, 28 Oct 2026 04:20:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8B1266B05C1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:20:40 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6A828160C34
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:20:39 +0000 (UTC)
X-FDA: 85371338598.24.76801F6
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf23.hostedemail.com (Postfix) with ESMTP id D0E83140003
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:20:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=s1G4iNj7;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf23.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793175637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DLae2gx4aGYIpiU/bvQJfKJhKs4nNCXiSW/qMDyeW24=;
	b=AWMWnfxuYg6dbpVpGl+EARJA5bMajsSakS4DY7376942ekQzky8HHdiF8Odlo34+RgiWuC
	nXXtE6Y3S/F9L8D7i6dM+EiGHR5tmvZMQg4xYTH032IB1AGqbDL7PQ5x4RwR6Wiv9FCkHP
	OPmMqjxKBZqTcUCHS2H1qbIKysnc5IE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=s1G4iNj7;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf23.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793175637;
	b=LULkeAecofh55lpc2aS8us58rAUdv02a+de2kN6EXW7xFtVrgSN350+r2BECJgzvO9dK/b
	EAKgqV4e3KV7sZjhEQmIJyNXEnwzKnqDJVl5fU86FJ6tRS4ORfdb/Enho7Ct9AM0DAoo8j
	MXMVge7mpsA8YzCKlXby/ryvTaJ0yKM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1793175635;
	bh=DLae2gx4aGYIpiU/bvQJfKJhKs4nNCXiSW/qMDyeW24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s1G4iNj7/OxMe3QEsIAEnZ0bhFm524AJi+UtsiJDNZZkymmDz57s/cSBMC+SkARw3
	 i3VKwlDdDVQAtn3D0ok4bdXGCRiRr75QTXzaZRCjPUoxQd2Dwf/537SkAttNRm5m+i
	 dIZin/56CDIf1Rz1jHjqkNsZ3h7kYtj+ZQxQXxGI=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 67144FBCF7;
	Wed, 28 Oct 2026 08:20:35 +0000 (UTC)
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
Subject: [PATCH 05/10] drm/i915: switch to __nonnull_args() macro
Date: Wed, 28 Oct 2026 08:19:44 +0000
Message-ID: <33ec8080594f9f4ef1d50e36497339c9a6897393.1793027261.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1793027261.git.d@ilvokhin.com>
References: <cover.1793027261.git.d@ilvokhin.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D0E83140003
X-Stat-Signature: 1jkz3n6wktekrr1i5u3aan55o8sc15ro
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793175637-522128
X-HE-Meta: U2FsdGVkX1/tMyA/SqgP6bcxWxPMVde1+a940xjH0rfQkzwiUZ2SKgH8Y13P/4mt5DdmMRxXc0Nlv0jUYyAit4jswFqwW2ofAZt2qBml5uD8mpYrZbECb2Sr6uPO7gNLWzOwA2GkmpWxcRJBSlXtlxWexaG5s0TDzeWKDZaXjqFBHu7KTS2dhGgcuk7F+xL02VUpPYo5ODf3xTlVO/Ui0OOuZJZJttasJu8HKWqjorIEtz0CSoPpnbkBVBODd5VpKSmsyAcx1fAumQcfWZuHICIdR6+pAtHHki50+DqSZ/zUwv1ZSXDuOyNuzA9PPDCqXwukDqjINJwZ9BRQOgRC9yaHSwVSmWuL6MBwdRDFhuiUJhFBB0Zti4FEXt64J9pRIZDy4SpU+CX2wFGTFbwH0rC8q9XXmcqYL1CJ/rzhzsTQoMZGjO+1Yw5eEUsz+J7io0ntIrCtO5/jWhicKM9ENuHfREg1Wg9MgggU/BHS5dAiwJeHQ/dLtOeZV8mbNyHYvNgDr6DRKPMqvb/zqQsMIPuqvoB8BpA8kw2vQmsjDWSFdRP9okfiDHjz7ZiN7+Zdxz8Y0DTLysvMj2HlEv9lobVj8U//vGsXIzWoXj4g9bER7HfG/5x+KOenHaPClx1JZ2r2Au0BUBuavl6FK1AtmQvYIXLTNpXbHbQGgkPiHreEYUp7gkI9fzCeGifWyFHh6F779ovzMXiOKWpCfQIfIlVTZl48XhaNLLbPOoDpN7IzKey3TbB7rQFirZnFwg+nQJzDnOYSnQb+vV32HLEnC0L3BSdODgBDs6z0HA7sRiBaTa/LYg6M7b7t025bKfvafKsOCMBsqyTvtGXqLIN8+9fmRcMoetBqP8uKGRCuOwzrLSXxovSAV5179FGGn5WGxrTD5O06U+kM1u8YRH9oFQyE9gGEm8fF0rxWqHy/sFJshxtItiEC2lMcyr+5U502gczoFk+NhtVy53Z0tOq
 Q5C/7sz0
 RpCozX3uOn91HGPsTJ/tmqBcH3rAeG1ZCpPn4+SgmLPGDrFV/tvrP6trO5o9HBMKI6XBqq3i7K6cUQv3RtsqAuXc4sN+iCKoMxJYMaB2wY2Csu+V6BI8pnTdwAduNXt5g+7++7PmHFC1EhfKa7TUoWrA+umaAfmGAkEev/9biMb0cUVrW+V3kfkAXXKmCgNPE4wYQFOzddPW2p8hqaDVVoAKZvATdiVOl95u/KMYXsaDODNl6tximbWfz+8HwnTGL3fP96ARp9ev4UaocGrHqNQ7LJ1KQYcfj3V0Y5hpUTaYy07wQr3B72oi6Bh1cJ2hCXa8NyL/dLmeNvCUQjZR59cT6E1WJJPj9sXjzg0Wa0INUCFrCa4FIMp3mqfzEVUV0KNE1/IOp8H4RObk=
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
 drivers/gpu/drm/i915/gem/i915_gem_object.h | 4 ++--
 drivers/gpu/drm/i915/i915_request.h        | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_object.h b/drivers/gpu/drm/i915/gem/i915_gem_object.h
index a2f4b6758a65..648d0b4139cf 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_object.h
+++ b/drivers/gpu/drm/i915/gem/i915_gem_object.h
@@ -127,7 +127,7 @@ __deprecated
 struct drm_gem_object *
 drm_gem_object_lookup(struct drm_file *file, u32 handle);
 
-__attribute__((nonnull))
+__nonnull_args()
 static inline struct drm_i915_gem_object *
 i915_gem_object_get(struct drm_i915_gem_object *obj)
 {
@@ -135,7 +135,7 @@ i915_gem_object_get(struct drm_i915_gem_object *obj)
 	return obj;
 }
 
-__attribute__((nonnull))
+__nonnull_args()
 static inline void
 i915_gem_object_put(struct drm_i915_gem_object *obj)
 {
diff --git a/drivers/gpu/drm/i915/i915_request.h b/drivers/gpu/drm/i915/i915_request.h
index b09135301f39..f559203c332d 100644
--- a/drivers/gpu/drm/i915/i915_request.h
+++ b/drivers/gpu/drm/i915/i915_request.h
@@ -437,12 +437,12 @@ void i915_request_cancel(struct i915_request *rq, int error);
 long i915_request_wait_timeout(struct i915_request *rq,
 			       unsigned int flags,
 			       long timeout)
-	__attribute__((nonnull(1)));
+	__nonnull_args(1);
 
 long i915_request_wait(struct i915_request *rq,
 		       unsigned int flags,
 		       long timeout)
-	__attribute__((nonnull(1)));
+	__nonnull_args(1);
 #define I915_WAIT_INTERRUPTIBLE	BIT(0)
 #define I915_WAIT_PRIORITY	BIT(1) /* small priority bump for the request */
 #define I915_WAIT_ALL		BIT(2) /* used by i915_gem_object_wait() */
-- 
2.53.0-Meta


