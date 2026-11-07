Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AE6A606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 22:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dLayhXvj
Received: by kanga.kvack.org (Postfix)
	id 81D176B05B6; Sat,  7 Nov 2026 17:22:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F5676B05B7; Sat,  7 Nov 2026 17:22:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70AEB6B05B9; Sat,  7 Nov 2026 17:22:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 531EC6B05B6
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 17:22:15 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D906F1A0419
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 22:22:14 +0000 (UTC)
X-FDA: 85409747388.03.D09E2D5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7792EC0005
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 22:22:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dLayhXvj;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794090132;
	b=3tpzVP+581USTxFlSwq4Fa2Ztl04pzMl2V10DNukEeR56g1maRhOqlZ0IROrOCN7T1UpRb
	TautnpSAb9Rnpwww+/Amn8s1FBEVR8GmuK5QnQAFL12CMDl4guSab7XPbCVC+r8GUHX1R+
	qLp8KEWuQsU+9jUaXeRZ8Q5/RFAndQ0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dLayhXvj;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794090132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dECklwOd4xlNmvN3OSaJ4I8wcJsGZw3Lw9lBlak0+Zw=;
	b=rM6guDSJ1H4vugQ2ce8BMtS0FEWlzzDGCE88T/cl2m7lScjaBWVjTHpP2xCHU0JIM/0F78
	eTbkw7srKcs5qI3EIDK8rXiv+Oyg/0F8JkNEBt8QKZhZPVXAFLICGmQATTObxDZB5RBLMJ
	CT5j2voQzfN8i+VnipVBZadTV2IFR9Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1C8F561210;
	Sat,  7 Nov 2026 22:22:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 988D01F0089F;
	Sat,  7 Nov 2026 22:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794090131;
	bh=dECklwOd4xlNmvN3OSaJ4I8wcJsGZw3Lw9lBlak0+Zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dLayhXvjlMyPbPhj+Cwg4k8CwNhxhZBR+fX479TcrnQ8IrINvaP0MxsFRMp3Ej6c3
	 /m3nOpiDvY26qgBkfMF8ZvqZzm0Sywrd2TocaoiBZ+ptWHrWDF/jpLQD6IqXrcSnQS
	 jV280FrsdLZlqxUT+H7sveM/obf3IZ0878/1zpBVclT7+RXf6ApF7+ae+sKjG5kIDx
	 xBUxG2voo65F7oy4l5NP56nndP2Mf9Pxe9igP4TcyojKsz5XPtkvxVXYXDsL6mLbHc
	 OxgU775qY9BiOg3DqTWU3n5EAktfKM4DmkeHNOnHooLqvixYbZiPD6EaBvqIwkiWdq
	 XvulXIidcnBgQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 6.6.y 3/3] mm/damon/core: remove unreachable damos charge_{target,addr}_from
Date: Sat,  7 Nov 2026 14:22:01 -0800
Message-ID: <20261107222202.331476-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261107222202.331476-1-sj@kernel.org>
References: <20261107222202.331476-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 768paphb1h34y7qk4fjzdmht9m9md65z
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7792EC0005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794090132-358871
X-HE-Meta: U2FsdGVkX18HZfHMQBSe0nBGxNysxINkJRKPtygAGxFYje4JsOjZUrUX66Xz9gK+JoA/QCosmM5Xt1XJ96fVacFsfd0htlNBmDV0w31fkFZyc3kffujbLkJQYIebedSW2tuR2cmtUvjR/kcKBoTKcKPpO3IKCCZfAh7TT4r82hb7ZolNog0nQY103PFJLOF+v4CPGdt9tT5g8Dj+RnQd15OYAQkpC8rfEhQM390KJZmDspeDOyoLKeLVgz9g8FKY1v7gD6F67upHTgSYbZ/Zp7IWEP9RCAIFQYlUi8zZW4mHEowfu/ENVWAWSXb3D66XSk2m6ZKN15PFJHkBWOUxK/JyH4bOUKdOKx5c1QGA81GM9UUbic1otJG4jnHBKwHtplLKCLBYdpKJwMY6o0OZWu+4U9wBUXiozltW9jGpLUchotACpOL56XTKBIOPtLcMEdqaUy7RmkR+nAYj3LODcgOK/b4yBqX0WbHoTMvQj4SNje1SvhyHcxB0JOrRzlYHUQ5o8KjpdH+hU+HeUCOjl4ErfV2Nt8vZ5DTS6thQyNZTLtJ+8Sb8vMhtbPAzCyAsW1w2BzVOr1e9pqu17mUXLtJhAod8/5Nxgvd8ZNj6A8ZZhRrJh1DmZoeoQljJTCp7WK3rIFqiidHdqjYIj3hMfIYg3Lh8ZFMJMj8WLUehwuOPSDfDhjJjZLVe4dHrzt+Dm8WEwZTXUDBP9NsiVQQRvVqa/KgGuzjlo9xSAMGstVnrsPRgaDlufzxdUytVpUD84kKsNLVYkTgCrg8lBpLtJxU8/R9nOVEoKUEVzIw0m+1DT5MuLSCQklEd1rhFsxqBt7VEjP5kpSGSF8j6bg7j0O/87zYE4mYvyJ3qjxDZ8inDJQj3xUd7HlMHdp8WmuD9fiT0GZcbk5yPWr9lbTT1m7OcYCRmvZWWvQ1HaNmv6tu7dHglzVVyRtnHXVp6kV09pUcNI/vX9zC6kirH8xB
 Z+U9BfTd
 Yj458mFeaNfBXqEqo/B0wyxnGwBDPLK8EPIuyHkV278XfiYlde9ONPOCNqxe8QucEVrSWEFtnH0bDcYwqVe4WWlzmiC+UdFqsHOJWXs+2KMFue8qrKNTbH3WwLfm7oikdfFh5jBLntzAGvUcTV2A1mCa8BzZvZJa65KHemIPs0Rwj5scITerhrp+YwOUHs4tbs0FTpp+vPlXl9VJkp2O6zxRNnamZs7mHAmFxMGYCLgXSdB9LpMAxfYeylF5DAcPfaHB5HUo2eirjhSKKgsi+xsDAQB0T3qdDNu5RKzNnAZJjfxEurY4eKLqLLgd9ERo5HxpV/N2Xh0y4s6PC8L0eT62xpir5VnaG/Mxi+ZJx/STVVTEv89m/tDmhkew6w/ch6qZcMrRd4vn4a6U=
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
 mm/damon/core.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 99e934a6d1ce9..61d45d40fc1d3 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1088,6 +1088,27 @@ static void damos_set_effective_quota(struct damos_quota *quota)
 	quota->esz = esz;
 }
 
+
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
@@ -1115,6 +1136,8 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 		damos_set_effective_quota(quota);
 	}
 
+	damos_fix_stale_charge_pointers(c, s);
+
 	if (!c->ops.get_scheme_score)
 		return;
 
-- 
2.47.3

