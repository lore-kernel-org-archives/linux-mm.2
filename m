Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87F1C606A323
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 08:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=ilvokhin.com header.i=@ilvokhin.com header.a=rsa-sha256 header.s=mail header.b=gY3XUXUz
Received: by kanga.kvack.org (Postfix)
	id 8F6346B05B9; Wed, 28 Oct 2026 04:20:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CD336B05C3; Wed, 28 Oct 2026 04:20:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BBBA6B05C2; Wed, 28 Oct 2026 04:20:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 46BE66B05C3
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:20:41 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5CEBA140BEC
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:20:40 +0000 (UTC)
X-FDA: 85371338640.17.523307A
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf10.hostedemail.com (Postfix) with ESMTP id B9D29C0005
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:20:38 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=gY3XUXUz;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf10.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793175638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f3wDiNCwMmjyXbWSfqLqTJmF38wOioqFlsZp1JBWY8g=;
	b=6Dl86VO8O74scGNHQk3oLCjZsF0gW5csCdR4foirZtop3fSovIWGWeTVbfY14YoOEKCA6v
	U68tdiEa4tinDHM/rohQJuwmeCaAtF2KOPf38ybSlt/Yie/lxDBtW5OO9ffyw9pMBatBIl
	D1yLmJpjechkyZ+jrGo81sE3fpj9/mo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=gY3XUXUz;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf10.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793175638;
	b=gtLKCmhMQKze7QOPtJcobVNxATn4Kg+ZG87WnXljnPyXRWrwB1XSpwHGkC7VTslpWcMmju
	o0AXg8Wy/KPEqmW+cbgJ7YD45xXnTOYFK7wUL9jNEHmDVD/QV0XRu7hkr1QmpdjDx8CnkT
	/upw4tIMjMS4vUU1z2fXh+6Ge3yTqQQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1793175637;
	bh=f3wDiNCwMmjyXbWSfqLqTJmF38wOioqFlsZp1JBWY8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gY3XUXUzE59WwCVC4Qxuo4c1OjSPVasCM7D1wASmJouVr1JmoDvCR1fpvkN/NRule
	 x920S0FQBtza5BGKQpbvfVCzTkgENiiK4WcKdNZUluCqTy6kzWj7Aq537yU0sAAPsA
	 q2wy/d0fqfUd08AA2eVS24Chvy9WL59hmC+ynavA=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 0D880FBD0B;
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
Subject: [PATCH 08/10] leds: pwm: Switch to __nonnull_args() macro
Date: Wed, 28 Oct 2026 08:19:47 +0000
Message-ID: <ed2b0b67c306bb458ba389f16dc92904203a104b.1793027261.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1793027261.git.d@ilvokhin.com>
References: <cover.1793027261.git.d@ilvokhin.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B9D29C0005
X-Stat-Signature: x3mok9yaiockkqxfsm4fiemrrzinews4
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793175638-798752
X-HE-Meta: U2FsdGVkX1/uXmUhjPef//Ks5N0WLabsehgO9nGrtKVb6F4Ooh8enSRvh302qHGLYYQ+Z+D9b793t4/tWr4o4lAjbwKZyUcxDo3Exd7h0kd7w0q299dskODwWQK0rsDY8RbdeRBm4w2w+3CYeszfBl5/As6bO8w0cZkX4rDq/hBlLOZT0VNMh32j5A0pZgErTLLxbTS09002lSnrKBa3nvbl+L/mo389ulAK85tAk+vFEmF2hhNNsggNhRA5eNJwMBIxwveXJbMi58kyizByc2NTz7A6SwPYbOO+oQCvjqIoDsAPROfp1jY9C+9Ia8ZQFxKZP7rzZl3L8tTvhiZpwN/OF8nxOz9F9A/IX832/0YPNehswZU8yPXML8XhCbQ6EGbUKvLrinPXH6QV1N4tumheOCCraia9/dWN/Mlq75A6HvmRru88pw5I6OmqC1JiZ3rcv1ya7ZAihzcmNDbAmy5CO55xhZPggiykKfiuBR8WwfW0eIb5yyshlQywOe6hqd7SuK567lBEpJZaYn38FeyY465X6IzSx06gs/SeufyLY3JAoi198+G/UDl5Qh0P0zN9A+pINCbnWEyOBM0AIQCcGh07kudaJ23CS4J5DlDbhZRJzimid2pHHhQx5E2MwjeTU5s6nCZX+KFkrIAYlpXkHD1JQFz2X9LyVqpKkQeumDkz8SsWmaIlQvHuhB7GT17XjeSAmuLENi4/D69eriBm/bgVR5LXc5geWMJ5C19bkQJRDJK2lO8dLVRZKyCkjOjwBd05h6hm7iNrA0v0tKKotrO9H8+Q7wCVOO6KUVCSJGvnxRwfxLTPIaKQwliRsXKiQlySRUgDYKLJ2I4pnFYzua5N6+fm2nRiyQLtsGbFOjkdvf8fOZxJpFBn/O8p8appTEeMcCfBB9JX+1si2+aagvno2Vr1dPaMgBtauWxOqBT8BHob8SAnL3VCLWM26pjaIuqSw2y44sYHzNq
 yR8ph4jL
 BFNBrRH3pyknDF+3OVEn0my9sSbRLWaCXu7rx/uKGZ6Op26bwut2V0gX/D1zWpI74ft3PGZFUj+1rn62PjziP2iE/np97A3H01nYUTYt+3ZDt40a5AGJa5TgxkwL07gn1lWkErXUG5uscPZUyhgMbFDlr6WXD6/pj43N/CpPz/GCTgotPAtqnOwqEm/IjOaEwoZv0QhVtVezqBwlwtFZ93wP+KJr6elVQcyDugR21Lh0NFscPZNALss/Fhi857XsRpa6QawH/z09jD96QxFDHuquyd0UkQBoMtpE3DBJfqhxk6s6zbi0bkDXFTsRyf67gNug2aUNIx5nY9Mhn6xvAcHMMhZtalWS7S33PD0CKMoQ5Y7ZefFv0CZV6M9ZhxSAiXi7D68iD7s59soM=
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
 drivers/leds/leds-pwm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/leds/leds-pwm.c b/drivers/leds/leds-pwm.c
index 6c1f2f50ff85..0363d370828b 100644
--- a/drivers/leds/leds-pwm.c
+++ b/drivers/leds/leds-pwm.c
@@ -80,7 +80,7 @@ static int led_pwm_default_brightness_get(struct fwnode_handle *fwnode,
 	return default_brightness;
 }
 
-__attribute__((nonnull))
+__nonnull_args()
 static int led_pwm_add(struct device *dev, struct led_pwm_priv *priv,
 		       struct led_pwm *led, struct fwnode_handle *fwnode)
 {
-- 
2.53.0-Meta


