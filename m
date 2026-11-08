Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F02B606A332
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 19:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VVWwxJeE
Received: by kanga.kvack.org (Postfix)
	id 93B296B05B8; Sun,  8 Nov 2026 14:51:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89C0B6B05B9; Sun,  8 Nov 2026 14:51:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 716226B05BA; Sun,  8 Nov 2026 14:51:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4E85C6B05B9
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 14:51:58 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CD40A1A04A9
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 19:51:57 +0000 (UTC)
X-FDA: 85412997474.08.2A4CFBD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2FD64A0003
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 19:51:56 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VVWwxJeE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794167516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lmfkuEncO7HrgAvrvHVaRTSKNdQ3l+JsObN4du/E/II=;
	b=NtAjxE4HvRYYmBJIo9Wfj8k3ynPxJz3MbRVjMgYKECd4X7MP9//d7KRxESp01dSsnzsHT9
	54CrCbzlwD0BvCcqwgT0fQB8Z1YguZA+X0dLiVC7vSuxnG+9Xj9sFjFJzAhAQyQ1EHc5JE
	mfT3XA98veXggI3OZUHqL+i5h/U7yME=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794167516;
	b=QLArRKWOnRAEqO2PrdCXhWXqM5sXa/zZWmBtRkFNhas9tH5ZcTTNzKXPit1zulJNef9P+d
	mPiTypIhBgFsyrBTEj4scgeDVpCGkq5v54cfFIxlxMUI1v8FnVQ7gUoqbb3xouo51xDJxX
	sUjJnXTmr4hD99udeMQFT/CHGOj2QV8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VVWwxJeE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 82F7B44CBC;
	Sun,  8 Nov 2026 19:51:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3644E1F008A2;
	Sun,  8 Nov 2026 19:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794167515;
	bh=lmfkuEncO7HrgAvrvHVaRTSKNdQ3l+JsObN4du/E/II=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VVWwxJeEFsdCKe/oZmO70wy3CLjkq+dbaLQBYHovLEo0MvUIDKZNciyh8j94v+Jzt
	 eE9/0sShh7R2iqJ/0J9MGC38DIdvDzJfNGi1Sy0uIlIzxY/fAbGUb/Wgh75ezGIarA
	 IbfLGoXBdu02K4bO2CQ2CBGh9OcSBrDb0JQWGOb6r0cWFv9iNSSjci/hWBVA15cfEK
	 7GWZpNIsd9Fb4g5TtwAv1T9TeLCGUQqgBr5Rz/bVOFvPYyICpra6ZMyXBEkUnGFjT1
	 4JzfbLHXiW+j0iHNOU+m/Q+PI87jvVZrJw1W1yP/yyZ3jFWbYi2BZ+Mffen5/ge7Fs
	 oDwa/ag5xAOXA==
From: SJ Park <sj@kernel.org>
To: stable@vger.kernel.org
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6.12.y 5/5] mm/damon/core: remove unreachable damos charge_{target,addr}_from
Date: Sun,  8 Nov 2026 11:51:44 -0800
Message-ID: <20261108195145.115792-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261108195145.115792-1-sj@kernel.org>
References: <20261108195145.115792-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5nzisid59gm4kr5okyyughizbmgec7pd
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2FD64A0003
X-HE-Tag: 1794167516-857952
X-HE-Meta: U2FsdGVkX18lga8eFtdtIERBEtbIIc8wFRcaQ93RM4pLH9XWKgdI6TsLa05Ns9fF4AuXIfqvW7gGhl8azTW46CKytvEIT+FhW6Sc7wR7w1DcjpUWLj+6YUEAnAsa4ntoWwN8klNvv04joYTyUfeaGYWsfJy/JTK5VubBwlMdFkEigSQg3x62FHpu1QY/S5UnQBJq11YrG8xvICTbXscM5INaEERqnjjJPrTrEYxCiIH/KmQ5gn4yytuViXFjiGxpnEwU5aNhOzfSz1aEDuTiKwYPklXSC0hARaTyR3WTFDuxWLEyX3uEIsV1b0oM/c3yxJEm6aUKJ1TW+lNcPr2XyHj79xM+XfEAQZoNiHK9Yhym5nO5flai8HcJtHBZEkXNoQI5C4/l6YDpHCXCLF5WlrVgaExeqW46pLyuQBD6B+ZAe9pVswOdo6Z3F4Y/UkvzFw8l2chsaFGZQyu8ASIq9D/tFQEVhP9AJ7y34JE5I+YnjcRVRjdXZKsX8jbloYQAQc5ihpxr9SbT6jFGTdhp18g+HjnuJexEjO3v/vwQEy/FzwLBo65s0CMcr/erNf5PREtrmGYClFhhRkADVDbOEcj+rNu0EM5J6SIwFIanciMoIubiaUrhccqiBNtuS+TyaNJapk28X6xu6RFFay8d6/Rj/YJVk8YaXKYPvUB9J/qOYbtd513oj/78xbcfKTE2XO/8jx84d+G+sRTTr3DtXsI8y0n0AvPEMyoc2pOGEiPPwWTt2HwitkhStO14KpAigFfBtW15wbZmZfzmSlv42jOBlbNo1tU0O+cmdJKExRi9UBi3sdxV5i/UqQmqVYKU263dEN7BzL4YsjZJi5g8Zk1rBcbdTCGpanW681bd70aabE2k54Lo5bGpRewQdU6WWqXNhFcgvB5232Zcd/+PdouCiE99kAP8wf1MQbv49s+1bqCIZG8zw1CHTxwzAmD52XRfhHYIMARVgfrlgO7
 3CoKXyy5
 3uCc/lujNg0dP1zSg9pxGH7nep7bKU+MJulvv6MwFZsnnMgKEJ0lPoET+OzuWZvw5yNOvr1MrtlHqMMQwy6k4NSJg+roHXUm3yPq+QKbH2AGQ7ZXzfgOl8AezNf5ZJvJdgE+3tLHqa7vRkrKfd5Qx7byiuLjSohRbSdViFGOBs0sd+xYkutvLqRzTgxuBscx7FGs4oFqllXak52jKRTCtGe14Hctqyu4R3MCksgPLNm9olVycsjJB8ZfUKiwGJQOFRxGFzE7TVhHvvSSkkBXcEDoMjJjjIyitz+APIOR7w6LE7GlSSk/3ZoAo2dAk6+90jHYp5iwNhoEpzrK5iGH1aVtzhfMkkhWNKvP4DlJ5TwcVB1PbQpgqoIwlr9fMUAYC7VP/+lp+9tOh4/s=
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
index 046c07b86a6e7..badd0628e5eb2 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1686,6 +1686,26 @@ static void damos_set_effective_quota(struct damos_quota *quota)
 	quota->esz = esz;
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
@@ -1714,6 +1734,8 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 		damos_set_effective_quota(quota);
 	}
 
+	damos_fix_stale_charge_pointers(c, s);
+
 	if (!c->ops.get_scheme_score)
 		return;
 
-- 
2.47.3

