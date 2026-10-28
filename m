Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AE56606A323
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 08:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=ilvokhin.com header.i=@ilvokhin.com header.a=rsa-sha256 header.s=mail header.b=csUWtQzw
Received: by kanga.kvack.org (Postfix)
	id 043FB6B05C2; Wed, 28 Oct 2026 04:20:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F14C26B05C3; Wed, 28 Oct 2026 04:20:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD5E66B05C4; Wed, 28 Oct 2026 04:20:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A347E6B05C2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:20:41 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1BBBF1C4644
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:20:41 +0000 (UTC)
X-FDA: 85371338682.26.A006205
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf06.hostedemail.com (Postfix) with ESMTP id 86F5B180004
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:20:39 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=csUWtQzw;
	spf=pass (imf06.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793175639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7iGwC/zgOWLrxX4ANiv2xF58zogBn71EZM14tRgOJbE=;
	b=QpPLEwZHQ9v5fb3CjyIBQZs5154Ws+mq/ysBPZ4DZXMLve2HXz+I8ODtBHVtr6lKtB8tBS
	JMK5ZfMs3zCKapjKb8gWFspluBtKftWthsiUfNmdmrxcCS+XBR/BE16eICqIajpLN8vPFw
	xlwZzSgwUQ/Rku3BnBGbhEk6MoCTm4w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793175639;
	b=eho5CxDQoXKG7wzCSvIYuTNsJJiY/hiI3nfjHiRteU+ERogqE4zFrCfraOb16olzK+ubwj
	D4QT5I215Bw+DHh+HWSfeWLhDTnv6L1+EMI5nm1fr+zQ7Of+v/U1RHXe+RZ+j18XoO82GY
	c8bhO3xi8QeiGvS5CvG7A42CWSTd4Hs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=csUWtQzw;
	spf=pass (imf06.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1793175638;
	bh=7iGwC/zgOWLrxX4ANiv2xF58zogBn71EZM14tRgOJbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=csUWtQzwD2E/XlWZClH8qe1DSNmkf/BxgxVrI21nciRCwiVBnNkgR/QmWPWiXgOFf
	 r7hvwbXh1TI+dwN3mfeJxPnh+wv9MNKw/OzT9SWuYLztFyR/10iP2qfxQuy6XpjkYc
	 swD9LFS71C2gJ4LZM8Rqw6CkTpFxgtqHX1iTdRcg=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 91086FBD11;
	Wed, 28 Oct 2026 08:20:37 +0000 (UTC)
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
Subject: [PATCH 09/10] soc: aspeed: lpc-snoop: Switch to __nonnull_args() macro
Date: Wed, 28 Oct 2026 08:19:48 +0000
Message-ID: <6b82201d601c23bf8545f8d581fd6632c36cd208.1793027261.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1793027261.git.d@ilvokhin.com>
References: <cover.1793027261.git.d@ilvokhin.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 86F5B180004
X-Stat-Signature: tg18bsi6uofxnmpbkzya41ttdcut8gq1
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793175639-60593
X-HE-Meta: U2FsdGVkX1/rhPrvnMHO28WSVx02pxfX6sWoHgh8RbUJjA82L+l/zHyubYWFyiBURjqYAVOOmNM2O619YNw8f8C/7cvcUplpmQY4j3L3/pX+t1+dKFjk12b484LWzZrOxywehhU9FhRKMXY3YXdlV4dKNpOJgbbIH0Vv++rHOx6/faC+x/v/6a3kC2lJ4+w4OUl3KTCBQpcEfSQgUMxG6gtW5HC+2R4sZYDQlwtu8sz6JX3PqHZoF37nm//9Jd3RIP1wVdQPeLSNxw6NjNIxs8TBwAadkmmbHXMwPVKg7/d/5BPKWJ0GDx4kEuZqUs1Vzm/dceRf2pbGiGJpMlX2XEtclV7qt9gskS2UHP1A6wchR6Ci0Sx04jAcWJXTAMz3v7ALV2LM2/h+2GsQMly+9ly9VBnNLIohflQwENqc2XNTATIZ2oohIJKAW9yIxTXtha4B6Y2ngoYINQKPRvGDvQ5dRLDzA0DP73g5oT6D0AxwqfmLkUTvZNFvHotC0sli0BqSaD3bBOjIVUdRd62jUkJszcHH+vbtmn+9TLEOHGnwsJyx9MXj01wH7IVNS1WKeruXGGQAoUx1U4z3P3E5bfSOb6Z2D3Sqqyn75G66xSkJAT1yKXuIostek2a8bNTSbc/CqWvyB5J2nVMYTkeR2fXy2V/EEYi8IFE/oaE3vtfVada6HOQXZ6AamA+6YEMusEbE3qPB8O3Fg6AKN3Zs3D3fJDkpnPX4P3JJsJ3LLag+Gda9N/bpLrvbQhci9XqqoEbCjlBO6VwzRdZl2FWgNx+7Y7jPlN4OHc/BMVkOPcB6HTYJDt300d7bxyPqn7Ne2sOIS52Ocgjgr50IGKeyHfKJ3esp2R5UAPeEgMxtlM/ZI55oxv1mQn246IZ7hlSEg61oFGuyFiU10bZTCM/hKJSyzR5BhkDx6ms6VfDbztg/U8O9Hr2gAoa0U1yiKHnSzcH5/nSinl3ZmSGtmmw
 8YZqffy1
 +Q5r+ZxKx3D7ArLRTo2+z8C5RKtREfNVkpyZVpkt3Y3y6swxvdHzaQAGK03delIl7GAJzB/6MDm6o6PMYrmeUpC5PDsRvV/WmP0Oti/cj88mo2exUhQjVB+UZO5L/uDG+IJHwb8utThsul9vMGArB+FkqUjg5KZbkm9jw8ghqz9o83gs34UxpicZDLTR469ehF64xJ9Oc8rLC9fFqi8qVHwaVYG2MJE7Mh1PMkxwpE2DNpNHURcDzxdkx4B9dDkd6wKxPQ7iv/sujkamp6TqZy9MxYRZjTWsKxhSlDJ9sqOyAtiDaU9utRaRee2jlL5jzr5Pz1bWZh91PudZWFF3VcI5KChbATQLlfEFChkD76RNplf1zyzREq90omjTjpgOISJeRn3vUUAhXVi0=
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
 drivers/soc/aspeed/aspeed-lpc-snoop.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/aspeed/aspeed-lpc-snoop.c b/drivers/soc/aspeed/aspeed-lpc-snoop.c
index b09dca34099f..ee84a06a035e 100644
--- a/drivers/soc/aspeed/aspeed-lpc-snoop.c
+++ b/drivers/soc/aspeed/aspeed-lpc-snoop.c
@@ -226,7 +226,7 @@ static int aspeed_lpc_snoop_config_irq(struct aspeed_lpc_snoop *lpc_snoop,
 	return 0;
 }
 
-__attribute__((nonnull))
+__nonnull_args()
 static int aspeed_lpc_enable_snoop(struct device *dev,
 				    struct aspeed_lpc_snoop *lpc_snoop,
 				    struct aspeed_lpc_snoop_channel *channel,
@@ -279,7 +279,7 @@ static int aspeed_lpc_enable_snoop(struct device *dev,
 	return rc;
 }
 
-__attribute__((nonnull))
+__nonnull_args()
 static void aspeed_lpc_disable_snoop(struct aspeed_lpc_snoop *lpc_snoop,
 				     struct aspeed_lpc_snoop_channel *channel)
 {
-- 
2.53.0-Meta


