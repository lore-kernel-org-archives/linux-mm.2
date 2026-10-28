Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29C8560A3803
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 08:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=ilvokhin.com header.i=@ilvokhin.com header.a=rsa-sha256 header.s=mail header.b=VVlo1g2c
Received: by kanga.kvack.org (Postfix)
	id 831D16B05BF; Wed, 28 Oct 2026 04:20:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E2E46B05C0; Wed, 28 Oct 2026 04:20:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 683596B05C1; Wed, 28 Oct 2026 04:20:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A68B6B05BF
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:20:40 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A89C6A8A56
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:20:39 +0000 (UTC)
X-FDA: 85371338598.08.F295EC4
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf20.hostedemail.com (Postfix) with ESMTP id 18B8F1C0009
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:20:37 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=VVlo1g2c;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf20.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793175638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FiKV5NXJkUgnsMcI+sXb0n0HNmp3jB2cH055fflH0Yk=;
	b=puatbGTAVcf4Hbys2bL6c1uOb9GnW9i8NRtSvkY2vPHGp1U0XXJScpUPvZWjfBxNs4Yxci
	goOnRYaOUl1gywFdfw/3moAcnP9kGUl7UA3Jqh5RUdEgBP6PqBBckhwJobAu5A/nmeKUrL
	wW+9h88zwUUJj8+fjexmVeDzoWRPy/c=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=VVlo1g2c;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf20.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793175638;
	b=yzX01aJxehbisXWSjfKjUy4WHujY5wdt14whqHcQ5YK8lOx/k2+MnAH5/kFEvRu3+29O3j
	Bk1jFF1w4CBp5EHoO8ME51lqa8uhzWshibVrybOvPPhXu3vShBxCU1Dzgkaw6bO+QhFxSC
	DrrRsTbn8TMdIPdHc+qGR0UFEECOjdI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1793175636;
	bh=FiKV5NXJkUgnsMcI+sXb0n0HNmp3jB2cH055fflH0Yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VVlo1g2cdt+56K8mWNs+kTnpuMnj6v1NqMXFWNclXmipKK5Opz7hXWMThpTbOSgyj
	 eOL9BeLA9artebTwUe3aomW3AQpvt1PlkLxI2lRkk5FAhY0kJkXeOLwyoZBdm+iTWu
	 I8Pef11LheXSvHn1Q8Fn9g/yAIYYO1mDlqVjQ0aw=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id E3709FBCFD;
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
Subject: [PATCH 06/10] drm/amdgpu: switch to __nonnull_args() macro
Date: Wed, 28 Oct 2026 08:19:45 +0000
Message-ID: <d57489b8bec240794a7a8aaac6e1e3e0d78ea331.1793027261.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1793027261.git.d@ilvokhin.com>
References: <cover.1793027261.git.d@ilvokhin.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 18B8F1C0009
X-Stat-Signature: pamnmmka5di8hu3ta9zduc93o74c8bkn
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793175637-864021
X-HE-Meta: U2FsdGVkX189s22Q8QMx6OrIXX8adMOqkQoUgwRCgodybiLMr6nltBys3KjkFRgycmwvRoa38q8qVQyyD2cwiNr7Sr1gjb0OCZYzTbQt0yOiZAWe5kFyYRiEToFhgIx3a/hCdrjQtzZmZPei/0dUyQVjB6jk8xf5i46ENN6Ha9fVgudfChxTQ6wMqouVd4ue4wE9ZiLkUD50KB3azlQFNMz4/FLt66dJK+Cdz4T9neKi1HGdkuZzpB+c0x/2TRfEeJ1uSYzO4cvPFms683CdSfdpZ3x1cdywedJRYhmFRQ/KZQYHed6GSWm7XGQhyGNRCPggGVSoR1pnlk/xaJm58js6OMvJRLinQcQcXslh6pWuEcZpOvUSSf4hkPmVVZfoUqkDkwylVH3fHCYbp0j+lsMQLPMUXTrJDe6GMa7hqJcBojTw9AZzaSVZ67Wovef1kXXha+OFr0i8mCb1Nr7XzOUU02SyCxegxT1JqqGNBnO3T5shtPI7j2IFENvDRjeiL4R/zsME/Mu25ZxONe4HWQM4HbWEEyonrvq8J2qjeZnYvEdFmp9nGhxrZzA9N97V6n8FFpOG3M+Czw+pJ5Yl5HD9sESoMm7zJNRvlC9xkjQO1iN73QYesvDVVFv0RpYqcDGPwfYQX26otSyWEY5mFmTLQ1uMb7bgH2RIrzTrq2+q3qXalreBJhEjKuSbzWTpoT4X4dPKcScc0EfYgXNvz2XGqG7Dp8H7Ptq83dOt6pxMM4UlPimkdKx5QdSn7yV+Vt61V00fciEF8O0x+N7ex68Uf3y4znnQRb5cm2N+1/Ta4F4CSuZH2OSMlSVbAEtgsQGv4T8q5acajrmYw6wyjEH4Z7sVZisb8sdJcJHLHXaQtpV/DHCLh4r1xU/SQnkcYw97T7+dU/Q3LW4HlN3UNaaa+er9t3ePVDoaLj5xQVHUV2uz1mLWvatjAGPWHl4pvXfIACbntHzPWkmZa7D
 /jFKvJj0
 ycSxNO7fbBxAlig+c+fFGd43kVxPw0asM9MnIrkxzF2z3zqOT7XA/U57dP5Ftbr6hV1TLWZMKdjra9eQEtjbcGx+7vvFZ6yWep4C4TBOLPJzNtAlXluuF9AGRTUxbVDYr/ZZ28StSrQD/5pj94nprkby95nrxjB8CntynMGmSmJBcZdPYcf3Qt7RI8OlEtztUoNSyUOd2OdMG1OltLQa0lZ2teyTzLvRmk3C9XAdpSK//VC0ZCOrOtuIf1Yi8V0FTe1h8Z9o8qxa4PBl4r3csdDEkVtH9CH22nWt/Nnmc0Uv8J0d+9xunbSpvNRqPZN3xD7hOgSBec6PC+l24Qmyxt3aWyC+clhzWEWtR0FyOp11SF9eDXHme364TklsvnCqCOKO3NzIsH+z2f6w=
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
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
index 8f0720a77520..c238564b4a31 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -307,7 +307,7 @@ static int amdgpu_ttm_map_buffer(struct amdgpu_ttm_buffer_entity *entity,
  * move and different for a BO to BO copy.
  *
  */
-__attribute__((nonnull))
+__nonnull_args()
 static int amdgpu_ttm_copy_mem_to_mem(struct amdgpu_device *adev,
 				      struct amdgpu_ttm_buffer_entity *entity,
 				      const struct amdgpu_copy_mem *src,
-- 
2.53.0-Meta


