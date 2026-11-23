Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD19D606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 15:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YdmdSugz
Received: by kanga.kvack.org (Postfix)
	id 938F16B05BC; Mon, 23 Nov 2026 10:01:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E9576B05BE; Mon, 23 Nov 2026 10:01:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7607B6B05BC; Mon, 23 Nov 2026 10:01:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 525156B05BC
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:01:12 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B9B4C1208E4
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:01:11 +0000 (UTC)
X-FDA: 85466696742.13.B02C689
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0A7541C000F
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:01:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YdmdSugz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795446070;
	b=TUY6bB3ZRUcaAWcHsummKe1HsGvu6wA/8STDuW9fuJYgyjjZRhvWvsPQ1c+7+V5UYKhG+1
	1PgP1A2EMhU1QGHE+qHRuwvofPnYpmKtwqLwu23fG0wKgwzMWBmJOPWa3iYH5+SBlHDdPU
	emhXPl/DMASojJsyRLzxGbuQGpPp3Xg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795446070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8up+ChW7Qsjki9eTuIEICGRZ3EGbMsHsimy8g5WL5tQ=;
	b=I+4NyL1r43UHM9EV4uNu5Eyii3YctY5vSyI4+hBdMgESQTpPrNkFJ+hGyJ2qk2lqiRunG+
	Wc+QGNLFSu6+x0B1Y3hVYxg3jhwGy8EEvCiRZRjbjt74Rkx+yMoJQVQo7OWjPx2TLafTzW
	h+4P4Eb+T4d0o+dErXxuYRbvQR9ICGY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YdmdSugz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6B6B56213D;
	Mon, 23 Nov 2026 15:01:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D670A1F000C6;
	Mon, 23 Nov 2026 15:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795446069;
	bh=8up+ChW7Qsjki9eTuIEICGRZ3EGbMsHsimy8g5WL5tQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YdmdSugzHZZCcWuN2gDwiGu0jKBzhwbjltPTF1SlrlZ+0UHqirx6FFIS6npuQ6KDg
	 dJ/rrJ675rVKR4qm0MD9cRxuL2JyJjtBkEa/+pV8s5qdNCE80X2NqxMHdglC4sJEmV
	 czkuwJRfxnngk0ZHKJLBvJ24AEhvetCIFS2IWbUaf1DeIG9ML7C/87vda2ABPfDVNK
	 JR8QuFDKDPvYUOXuyw0GAJSFZN2td4EB6uVvnDFytL3uCY+LMbTqcrz8/eNiNr/iuU
	 FWi7SoPy2tuwp1EGz1js0ohggF11MWoGKvBEXy/dQCAyY4RBCO7wMXrIbo2OqmGdSD
	 E9dlPWTrdTZFg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yifan Feng <evanfengff@gmail.com>,
	stable@vger.kernel.org,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: [PATCH mm-hotfixes-unstable 2/3] mm/damon/core: fix damos_walk() hang with zero watermarks interval
Date: Mon, 23 Nov 2026 07:00:47 -0800
Message-ID: <20261123150049.81317-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261123150049.81317-1-sj@kernel.org>
References: <20261123150049.81317-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: b1trdbtgocs8pqgcn65sd7rg7nx9dgh6
X-Rspamd-Queue-Id: 0A7541C000F
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795446069-748342
X-HE-Meta: U2FsdGVkX1+uGL8COXX0FSkcYffbxu5yKpgpuBJTzlAQu9znPy9agBHY3xILgr7mWxUOWONWrNFB2o6eaFP5KA4wmGhZNxcuoRmqTB4bWHAOa1rix/1CtyGMreyv56hrxavUNQCzHZ0ygkblS8qecAHtmNXGNupjF6aiv5cKDbJmW9Stpa0284rLcedHPoaM+dEmTpEmfDIUg7+JNgeBDCs5+tEA2sq0y4vZ+wg562ooTIpzIDLXwDkPsw2bmbJeQOUSiHMzST4Z3XLSqNiz5XCABhH8vBsXXLWQ/VK1HXfqpR2N7SNLJBcYjLLhsotASivN+RNpVnuHSmOe6DN5t++BuEbS/5+PevHDjorZRyQKOza0NfAvkLmJ3hV6szj5Lg3dwPip1Kdf74sPiyMdPfDEvGbcxb3brmjp/yNIDLQ831etLGWxB+7aHbCxWGNdrYtBA3ekPMdHzmidjvfGGoqBS4qgWw5Qhi8IgaOhmlmAjQ/S9N4WdaFzTBpF6yEjt21BPIiXCrsf2u/FjpC7qiVqdjy8oXZ6rVMtkhqs0rYJONrQA1pnQIEpXcgvW+A/lIS/u0a4JtP7Ufsq8gw/k6QtZl8GNT3O5HzPeVM7kAe5qJQoIKVTV1DMJfnWWni4+EjCLTce5HgiQMjweQ6IV+D+fF4jTsCV0U+/iADoiw/ysuvjK7+W5SEs2r42jth5DD097PtrQMLpBB/DC4FZ0jqqyoZJz+BCSn6+dNqFD6I0yR0ihQm6IpM8rqalhh5o/Z389ZsoTp2cV/blXzO1Nizd8qosx5rEbdaLPlvSUT61wIXT1JSoEDb9qCIco0CH7Es3XbNlKDtzmVNKHIRsDCT/2cF6v+B37MHpKR+BXyRPwPHAEFfVDHL9V8f50du9UTCHCyqSRM1nU+509u1QQXH7r3FqL/aZDDSn+VFaOnOwTnxkBle3GjSZbWjuFtDL6H0bEi3mTAqbMmxVpS+
 NzyMpzmS
 w8Eu4UGCGvuk3MuPMx1M9ncL6DwCYiPER6JJSmcvHyaTM66V7Lkzzfd66+iWWvLbw2NSOhHye+/D7bGlvzyjbepfDORO3bxAl8tC9GFYQ9iT+eiUCIh3ebWEhYlMgkLHwycqLUlBErQPladC4WPzGZrQrx/JHeTrdUMFOx2Zm5oE1fg/UTUFHdEurjduqd7wU0z5d92KoDJgaEFwuQQuIgkIxludNuMyxjw4vhMppiBMFGreKmBoO6mHrawHWHRSDT+vrkworKSIlLLapnBm5FbDzHCHDFEoilI0w4MqF6pyjBuWX9eYTd/5KpoPpBuUORf2m/aGNRsbDwOE6KpIY+/G8Y3IIdGIXdX/Esvfk2IvsxcEAv8bgllFQIhIGWYCCOYk6F/ekLscAjXn/0J2uR519KYSpg7v4qPbt9s5Kq4c7RCLaM7V6vgcGFnbFdNHGKZITQQB5lZpMlG9/czanCFoUods5iZg73eJY7TeG4ieo+sTsScK+MDnQVGPKwDPvJMMPNXXp+aXTmYzBOet2ElroQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Yifan Feng <evanfengff@gmail.com>

kdamond_wait_activation() cancels damos_walk() requests while all
schemes are deactivated by their watermarks.  But it returns without
waiting when the watermarks check interval of a deactivated scheme is
zero, which is the default of the DAMON sysfs interface.  The kdamond
main loop then runs with all schemes deactivated.

In that state, kdamond_apply_schemes() finds no scheme to apply and
returns before it calls damos_walk_complete().  The walk request is
neither completed nor cancelled, so damos_walk() waits until the
watermarks activate a scheme again, possibly forever.

For example, with a scheme that has the free_mem_rate metric, zero
interval_us and a high watermark below the current free memory rate,
writing update_schemes_tried_regions to the kdamond state file never
returns and cannot be killed.  The writer holds damon_sysfs_lock, so all
other DAMON sysfs writes including "off" fail with -EBUSY meanwhile.

Cancel the walk request in kdamond_apply_schemes() when no scheme is
activated, as kdamond_wait_activation() does for a non-zero interval.

Link: https://lore.kernel.org/20261121025626.75981-1-evanfengff@gmail.com
Fixes: bf0eaba0ff9c ("mm/damon/core: implement damos_walk()")
Cc: <stable@vger.kernel.org> # 6.14.x
Suggested-by: SJ Park <sj@kernel.org>
Signed-off-by: Yifan Feng <evanfengff@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v2
- v2: https://lore.kernel.org/20261121025626.75981-1-evanfengff@gmail.com
- Collect R-b: from SJ.
- Rebase to the latest mm-new.
Changes from v1
- v1: https://lore.kernel.org/r/20261118235012.14859-1-evanfengff@gmail.com
- Cancel the walk when no scheme is activated, and leave
  has_schemes_to_apply as it is (SJ Park).

 mm/damon/core.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index b8678a53b0a98..2748f91999240 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3492,9 +3492,13 @@ static noinline_for_stack void kdamond_apply_schemes(struct damon_ctx *c)
 	struct damon_target *t;
 	struct damos *s;
 	bool has_schemes_to_apply = false;
+	bool has_activated_schemes = false;
 	unsigned long max_region_sz;
 
 	damon_for_each_scheme(s, c) {
+		if (s->wmarks.activated)
+			has_activated_schemes = true;
+
 		if (time_before(c->passed_sample_intervals, s->next_apply_sis))
 			continue;
 
@@ -3506,8 +3510,12 @@ static noinline_for_stack void kdamond_apply_schemes(struct damon_ctx *c)
 		damos_adjust_quota(c, s);
 	}
 
-	if (!has_schemes_to_apply)
+	if (!has_schemes_to_apply) {
+		/* The walk cannot be completed while no scheme is activated */
+		if (!has_activated_schemes)
+			damos_walk_cancel(c);
 		return;
+	}
 
 	max_region_sz = damon_region_sz_limit(c);
 	mutex_lock(&c->walk_control_lock);
-- 
2.47.3

