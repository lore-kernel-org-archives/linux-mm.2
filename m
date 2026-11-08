Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EC5B606A322
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 19:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hyxSBYy+
Received: by kanga.kvack.org (Postfix)
	id 50D486B05BC; Sun,  8 Nov 2026 14:22:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BF496B05BF; Sun,  8 Nov 2026 14:22:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FE0D6B05BC; Sun,  8 Nov 2026 14:22:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CD29C6B05BD
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 14:22:33 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F0291A80E8
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 19:22:32 +0000 (UTC)
X-FDA: 85412923344.04.AC674A3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6747F80005
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 19:22:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hyxSBYy+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794165751;
	b=SdwKJL4N7hlUy9V0OoF61Gc1U+UHU0n3ELucKtNvurB6y9iSABgOb++Fs5jjBaxW/DivoG
	XB2/FNeXH/a/IoyLK4AyzZeOZkiH6paYlgL+bo/SDxH9BrTt+N4M0I/8K3U1cB4ftXHFFT
	uOj27BUIF15WWVB4LZjUFrASmzDlW/k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794165751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oUgpNIq5y7P8hrOoDRzoRBlVsghumVDo96fytymZU4o=;
	b=WCkDin6jDjv10C64hyubFFm6SmjiZ6Hy3WXjW7Q99o6sa1BWuLoxRkxqJkfh9r2A2XU3St
	gd1iAJR17ohwucGYGQDqmJhzTMM9fww//eAmW/E9vmCb/HZ69qu8XNRKo6g9MRRI+zdImU
	xMZBgidK6fG+7b6B6e108/roPKfpii8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hyxSBYy+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0B22061AE2;
	Sun,  8 Nov 2026 19:22:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A306C1F008A3;
	Sun,  8 Nov 2026 19:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794165750;
	bh=oUgpNIq5y7P8hrOoDRzoRBlVsghumVDo96fytymZU4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hyxSBYy+ZbiG1f/nMT8s23nOmEzncM825cfwxYgWkFd88wNDXqh4irfChr2u/b/a0
	 nHZXZGkQ0I95CINQI+3l5T5pAzmzaBaIuf2esEEtE4Q46z1WblVquDw4AsKNjgUVd3
	 cpo5U5d3R6hpv8lgL8zBsEuAaAV8hr8ie0Q1x1R+1tf/hd7g1jMOyjVmaRJrrjCaPP
	 0SX00Nm2F5E9u9GSO5mxoa1pw4e4v852Q66bbb2WQyqHZCZHdaGRw/+cIxZWyD2HDm
	 Q7BipHtMctHHzLC7dIQwe6mZbn8gbnJFiq2n8mri7CyJqcLy4ZjRa/zpvL24h1mYzK
	 gtEiYmSKD8Q7g==
From: SJ Park <sj@kernel.org>
To: stable@vger.kernel.org
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6.18.y 4/5] mm/damon/core: remove unreachable damos charge_{target,addr}_from
Date: Sun,  8 Nov 2026 11:22:19 -0800
Message-ID: <20261108192221.114362-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261108192221.114362-1-sj@kernel.org>
References: <20261108192221.114362-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6747F80005
X-Rspamd-Server: rspam12
X-Stat-Signature: wj8iopwnemcc5ddnksidqfj34z8p1kqp
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794165751-101656
X-HE-Meta: U2FsdGVkX1/y+A1u4eAZ3dSrW5qwqrZ8zmJP2Yp+Gag1Y+rbvUrmLQtiUsCBLl3mk9UG9WSLB7kXEMwqb0TcGKMAKYA3eEbuMv/5gIadqeG8tZXituxrmOCSH1Gijdv2QBAt6bsHJQvMEbuDuXhJKaLxQfcxDZ2YL6rPOkf5s7Jc9ka0+JcefCpMH8emxuwdFB8u68oGIPHHyoU9p00Uu/ATHQyM6WKOH86U4yi5p/u9gGd2oie7+Ejz1mcVlu1vnraLu6ShprhiLwoIuYWCkV3E1O4HS9Ko+9IPWfUSZWcDMXuEM9MoUp8OnFn3hAU0Te6xtT5hvrouZzkJWmCTr/Lgqn4oKwv8X4nftdlGL8hqsKVadf4ilmlVMC4olLmzfcRsGBeBCf8GHQ0+o+kfAp635jWSMvyGNKeEbTv7mUzm1at3kgnfkquS8/JXN7fpEYcktxNvk/9IkE0r2niBcwAx56A7f1nX7BreTwWn3K772btzBuD8e6Q1u9I69LfP/YxXqDh3+QtRahrUm+OXjXVSMaxViJwUo56qK/C5CTAsHFmsNfr8rjkLTSX4DXk7oKQhs9kp1g/G0nHHipYJrM5ddnQ/uZDJnG+snczUXrXuHMU+0YMbGILCu7RUtjIhViJi6OC6zZukvSn+nGJ2do5Mu61rNNsKlejRZdtH/lwBVtt0bUpBRqCFCBg1MSrOfjuJ4b1wse3wcS+AiOesR+5CTsBUm1kJWrVUtMFsv2c8X0uLrtDjC7NxbhAHuyNM6ZZnmm7AVxfjHbjj5/bW4Ny+0dfWJjodaDIuWs54FTdjS8IFKv2zO47OJ/1QLvwT+2uNBxoSas49E8KbUYF2JF1mX2z2+AqPGpzgFLPYC8hvsyuXM5bk8yZZl9aHWEE/nf/Qp6gRZI22C5L3864zvMlQjByCOYGmgGD8wZYKwKeGJ1zz2yKj8nlsHGQY1jtf6jwRYDZRoSM/Z+TyHSc
 x25xQBdP
 uMahAFe1VkEufyFB3CqNGhqyhHPYnK55e1E845n+hX/WaxaeqcrJHflqqlvFTXMck1kMP5k0ZZQ1Q22KGWZFzasdZOr2GqYyHU1MmZZuQhWjvPvCXnn3/XnE+E82f0PaHrLBym+Svt0aBTW11w4qDKFjO+7GfW5ij3VvCUJH208+nfekjGMFikQ1SLDEXzsAE94JVAEb1ghuMLi4b7WpAvGeW8Tx09yQNHIAR4znfDo6m2EE0ELwNjNyoXB8RXK88RyZ2kUGT1XsvcLJ1CsOO5vqV4nWGFI0t9EO17CVtXZBNQSOurntUwcRIPaKekPxHYwo/hJSX/SGBywn+091A6uHq8hT6ElKa7gUxAZr6uitcOLaZmxQNPyilW/+2zZp2MG6UNSaIg0hTYNBFLMSGnoX8GoKawUzALyoewix1F9mhdr9t3rTKG/o3RgFLa1WScgHoDcWcO4PXZKs8Hl1pxkTzDcYHKfaqz7KWWNXDiCRITNVCwz2aS/lAQVeBXb3focPN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

damos_quota->charge_{target,addr}_from saves the target and region the
scheme's quota limit is reached.  damos_skip_charged_region() skips the
target and regions before the point.  The target that was assigned to
charge_target_from could be dynamically removed from the context by the
runtime parameters update (aka commit) feature.  In this case,
damos_skip_charged_region() cannot find if the point is passed or not,
so the scheme is effectively disabled.

Similarly, the user could also remove all the regions of the target
using the runtime parameters update feature.  It would be uncommon to do
that, but it is a supported feature.  Because the skip pointer detection
logic (damos_skip_charged_region()) works for each region of targets,
this result in the logic is entirely skipped and the scheme is
effectively disabled again.

The user impact is that the DAMOS scheme could suddenly stop working
under certain uses of the runtime parameters update feature.  It could
surprise users. No crash or leak happens though.  Users could also
simply work around by re-installing the scheme.

Catch the corner cases in damos_adjust_quota() and reset the pointers.

Link: https://lore.kernel.org/20261020023958.108276-1-sj@kernel.org
Fixes: da87878010e5 ("mm/damon/sysfs: support online inputs update")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Closes: https://sashiko.dev/#/bug/linux-cd0c55fc-0cc8-45d8-9637-3334811c49b8
Cc: <stable@vger.kernel.org> # 5.19.x
(cherry picked from commit 5695abc4e742b947f586bfb6a080a80ad9957e5d)
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index f2666770b5436..00cd0e2a1e341 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2261,6 +2261,26 @@ static void damos_trace_esz(struct damon_ctx *c, struct damos *s,
 	trace_damos_esz(cidx, sidx, quota->esz);
 }
 
+static void damos_fix_stale_charge_pointers(struct damon_ctx *c,
+		struct damos *s)
+{
+	struct damos_quota *quota;
+	struct damon_target *t;
+
+	quota = &s->quota;
+	if (!quota->charge_target_from)
+		return;
+	damon_for_each_target(t, c) {
+		if (t == quota->charge_target_from) {
+			if (damon_nr_regions(t) > 0)
+				return;
+			break;
+		}
+	}
+	quota->charge_target_from = NULL;
+	quota->charge_addr_from = 0;
+}
+
 static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 {
 	struct damos_quota *quota = &s->quota;
@@ -2297,6 +2317,8 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 			damos_trace_esz(c, s, quota);
 	}
 
+	damos_fix_stale_charge_pointers(c, s);
+
 	if (!c->ops.get_scheme_score)
 		return;
 
-- 
2.47.3

