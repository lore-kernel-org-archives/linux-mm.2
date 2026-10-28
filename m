Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE9C5606A334
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 08:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=ilvokhin.com header.i=@ilvokhin.com header.a=rsa-sha256 header.s=mail header.b=iyuSnZld
Received: by kanga.kvack.org (Postfix)
	id 7965E6B05B7; Wed, 28 Oct 2026 04:20:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71F596B05BE; Wed, 28 Oct 2026 04:20:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E66A6B05BF; Wed, 28 Oct 2026 04:20:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2E1F36B05B7
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:20:39 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1C6461C4644
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:20:37 +0000 (UTC)
X-FDA: 85371338514.02.F379A9C
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7B6FE160003
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:20:35 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=iyuSnZld;
	spf=pass (imf08.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793175635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SMf0dV4x3xb+DslLmuw7FBFheVT29/cwuNdKSpo2QkE=;
	b=HxQ/1FTDvZUvJW9+oAE180rxV+P2cyx9e9dZK4e7PhxHekdsHDdce0T3dvr9/ek9L0JrZi
	lT7xc73+rQffg6X5B4mRYkwEc+rs2j4ju27a9w5RztrpzrnMAQA0Ge6XMCiquDQ7QdzgkQ
	G2q1qqBNqLD4IbjUX2HLlg9NV6EXHm4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=iyuSnZld;
	spf=pass (imf08.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793175635;
	b=th0QqtkyoySwnsImHImZOM8wfDkpo9eeP/GQU03kqkghCDZkxzE59PIL7NdbMD/mXNgNb2
	RjrgosWr4VqhcT/TQJAr6sAjSgmryYP13+MnHKmPV7GXfV6qDhUUyPF/TRSvbwRJPbHa5b
	YMUkENh6mo9l0r31F8k6hRtVadwNN7Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1793175633;
	bh=SMf0dV4x3xb+DslLmuw7FBFheVT29/cwuNdKSpo2QkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iyuSnZldpZjUpO/QwNk+P5YouZek0N2mycnUxbkQccvDC4YJ19S4/mULi0aeehza5
	 68UlH00B7Uiw50tvUL0mmPirCWsysK2dNqpdy84iHfp+1EmJSSkCPH4nrPYKSc8ftb
	 VX/gnIntc+RIw7VOplejxDi+mip28Hr6aXN6ETg8=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 65638FBCE4;
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
Subject: [PATCH 01/10] docs: xforms_lists: support __nonnull_args()
Date: Wed, 28 Oct 2026 08:19:40 +0000
Message-ID: <fd33c32bb1f1cf80721887b6e9bfa49749e03d20.1793027261.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1793027261.git.d@ilvokhin.com>
References: <cover.1793027261.git.d@ilvokhin.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7B6FE160003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ffsy9wsskuognfciypctxoauek4dn4hd
X-HE-Tag: 1793175635-956596
X-HE-Meta: U2FsdGVkX1+90geq8Afja1lwzIyjedAMv9VUg+Mf4OGnTIazHldFGNWXuaEAd1f66uK461fusVnax9LfaoBWmZH8O9sY7zuqDja1IFZWXghmTy0cy2NPIb9Wow5XweilK480qy6KScXD+WY9QGyVZF1ro8KpGj3pgEDCqMx/S3BH852jim/yIcx7Tmkx0+CxZapFUVfWT6Zb92F0gCIKzQ2bqQqBhTmxpsEduyS7r1sja9xY4Lp9ZyBFUY1U7eiRFXofQoPf+IU6chwHLe9pgfQ/r5KUcCQTJTj0gtht9vllL+Wly9ZugJAdZfWtJn9/Dtb9xCap13lZXyk30bJavpY8xjDH1ijYFYvxweZpJGnPsb148o7kUSTrc22e47F9OwcPDsBv2gg2epT676QO41b8ySzQJhQ54WEDrfp/hmcgDQRBPcarY2nQ7vi3pPu9lXYNKwCFi8yGPSTFT2ZAa9j1BOux+qJenHta/vr4qcR4ordT2Zpd0fMZzscHwo2EoF6SJ+KhSVa8py/fj3LoyBQ4+kGIlg4Saa/crcxQ9yowTDKJaPAF35vAMlQXk2wCjh+YnudQYfiDVbAnS3XBcH/oJTeYbZF/2WT8eYijP9tgMX5myyMK23Xd9hUhrrbzaIDOKuss16+cuFrZ247HF5XUP7lgj9Gi8u01F4QMlKb5VGEPxfwmeYL5K6hz+0iBKB1O64bMcAV8+5z+BvycMPcWMkYtQ5OVdEsMRnIhEWTtaraNqSZcShK44AVjHZsotgg7IMHYALGWGizPzo220uZe7V6RzHHNnSMO4gvAonXSj2KaABJJZ6zk+oF18QinFZHkN9rjK/tW1QFRmApAHjUBz0S0DQlUqx7RcfPy6J9XiZdrWhNUlPX5mmNErS2hBorc8YdfxMkaKV8TIsGJvis8yXrhAECopHRvM1PmxvUzgW0BuxkKFuisM3u/X0BHSoe8yRgX3EmwJW5adhZ
 rCdwTCWC
 UfBbbxPF2ZEFz9FYydxdfopN4Qp018FrhEWapbAxBiYmOad3FXYjuVGgSY5CaMCOTzQQGd0FON3GbU4obttHch46hOUHD5P2LDb1XoEOPknmhvYi0hOvYypJOWs99fg92i9P4Bwifne/PSvr+igTjgQUEMZDfBWxeVo3gw5SL1P/fB1UMM3Mi+h0+bKZjoAfa/gO7yDa411/icoobdf0Swv2PrjsAb6JefRMnzD2dFnytf4Ezh+K61okj9aZMFFReF0jRb/carkZstjqohY610CcFz61m/o871tYXzS/ENNSYDGZ7olvIKacQXMZijdPNS/Fv+OdpuksQF59ZFfh4oeZUU6Wgsopq9YuBrxPlkC08Rdr4gNRoxBdIqL0ywgzyuSIRVnjJufmrEfA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Avoid kernel-doc warnings by supporting __nonnull_args()
as a function transform.

This is a preparatory change for the treewide migration from
__attribute__((nonnull)) to __nonnull_args() macro.

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 tools/lib/python/kdoc/xforms_lists.py | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/lib/python/kdoc/xforms_lists.py b/tools/lib/python/kdoc/xforms_lists.py
index 320f977c5bac..a8c47ede8637 100644
--- a/tools/lib/python/kdoc/xforms_lists.py
+++ b/tools/lib/python/kdoc/xforms_lists.py
@@ -108,6 +108,7 @@ class CTransforms:
         (CMatch("__attribute__"), ""),
         (CMatch("STATIC_IFN_KUNIT"), ""),
         (CMatch("INLINE_IFN_KUNIT"), ""),
+        (CMatch("__nonnull_args"), ""),
 
         #
         # HACK: this is similar to process_export() hack. It is meant to
-- 
2.53.0-Meta


