Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58B72F3ED5B
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 17:49:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 629436B0089; Sat, 11 Apr 2026 13:49:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DAA46B008A; Sat, 11 Apr 2026 13:49:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C8AC6B0092; Sat, 11 Apr 2026 13:49:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 380216B0089
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 13:49:18 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CD6988C58E
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 17:49:17 +0000 (UTC)
X-FDA: 84647011554.19.403716C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 507C340011
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 17:49:16 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NecIxejH;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775929756; a=rsa-sha256;
	cv=none;
	b=RbywHjW8K4kTy50/Pnh3a2Ie8hGY0TDCl45AhB1z7Mtx1lu2LZGsPAFhy6srh3xKWkjKlZ
	X7WRPFFBesdJLDcd0GTPF3GP3f0VUN3h8SwuA2TeBxqZhPYl8WbC4uX/NIbkE20mLhz6v1
	S6ErDAvndmVYa1H262QCJRKBqWYIjjE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775929756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/WOtnDcnJ4iWgh3CqEcT2Lx2s/iroTQe7Nvu8lfV5rY=;
	b=pF2XUF4dLKn/lNUgocG/2orlxYa1nUlPqd6xdRs0Nuz3kw05mvLN6+1tRNLRSAZ/tjOsB1
	LdET8rVxH2z/TX1YTbp7dPbIg7G/r2p1GKPEsFnL0Bs/fe0V3LyYVP0LIzPYixZQvPjQHx
	zAznEE4PuEIri6kLJO8V942Wd2xclG0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NecIxejH;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B37876015B;
	Sat, 11 Apr 2026 17:49:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B2DC4CEF7;
	Sat, 11 Apr 2026 17:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775929755;
	bh=+6mYAdHtZoxSPEip1gB6CQRvcztNhH7wHvVyj8tMCMM=;
	h=From:To:Cc:Subject:Date:From;
	b=NecIxejHHgL7OTGZNJKfdRSYkrGQeFnaOyknArh0kDzSfCJFCvaA+lRyUwh0z3JkO
	 S9MgoemYi3uZWzl+zA6Zi4ZnRF6xR5PJnYTA/+U1LywdxqPvoAgoGYM0ZlJhX3eRqm
	 7D7ppemTslRGqDBrZ7TZYguNFIo/IumMDnaEwJ1d6/C4n3Nsn6b0cqOT0CCSJ7gcAX
	 vxCJPV2uf25iF6rXN8384gJhlkaGeAYqVOp3lQF8uJvUFlNCqBfAl6lVrixFv/UtZm
	 QUBFY+vaU+OBrFA5gpxkpoCWdZ1BGJ7jRo+zVHlL2USpSRXHC13dhd1FRxgM/nxT45
	 dd5FMrlcEbCxQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] Docs/mm/damon/maintainer-profile: add AI review usage guideline
Date: Sat, 11 Apr 2026 10:49:04 -0700
Message-ID: <20260411174906.79491-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 507C340011
X-Stat-Signature: f9xpoatqnobyds6y5tuogbs4siuf1zwa
X-HE-Tag: 1775929756-900283
X-HE-Meta: U2FsdGVkX185vTXM6yiL+MH+KU+W1LfUrjB8PR9KZEV5YkN3wz2ybBMFFcmY5WaK0i/eQyVuCw9/OxB9crAT+YFsQldcsQOF+vbzhJW0pwldQLzWOm0r+R8O+cabS0IHPtxeuVAFi0QDwQoI0ywfM6Xh8J0cSxLe2vZdg83dSNnVh2Lcbp1YTsKkn6Ih8DUDVmcmXQXG+oda9saOizqmTcci3M4BegtqzobvKAYC9M/vPzUAo4AdG8Zcsl8K+tP0Xysm+GqmLVpIV2fWh9p+0CWtrPyKVGyjh4pgSpYhZ6i7/5+rCpBS+0TwtxTAzAMLjIw3fISXAkmDgPMb0fjYYK21NmeT8aiArzhVbbLlETecWo0bvhPHsk1FBFfj/SZjeGyKuVH8fV3wQGrCUfaFGHlvquUpxP+0NyTriCx0L+uIFnbxiE7BOfm+cbLUns1ZSgn7ixNNu0We+eFIJWp3YkIzVG35pBMupg1+qTh/XGhIpvPGKYPV566m1TWNgQsUrvbUqtUc74ghEFsgvs+JK0fnR9NNKQY4cvxd6jHRA+rEDN21z29n5t2BLePUTiMMtTo17REhg/YzjLpHvwK7XDDo6K5SDw012k50keme5Cum3JKpsug+nQdaKJG4ny2i9wt2F50oj903TSRArpwi76h+2mQMtAVXwe0Z8PVCv+wraNQVtLhPiyAyqxqbKZ4mutR2gZS0izrKQv1Sg3hhAzNg1zcRbB98jRitSWsRgLjLANkDMOGvBkaMl1iQUH9Nfvm2upAnayYePLeEoYl2hElRhGgzKf3mzMRqW6fWGzUavLNvcvcvGv5ObdXJsiBOcu51q9+mJ2pJHYlFR+SxMO9eHPWsa8+qyiVPhZZo6WS+UNq/XWxjjBHPYkXOBjez+mSc3H5YtY7iPiXAMII5aNG4C1jmaKzRLiRf/NaP2XGy+HeFOl4dhxBQgj2vNiOCz9C0zNhLbZJiN8UlzPg
 Y7BAeFhY
 j51H/Y+jJbshsmVag1pRgE6oVBFwLelq+MWJ8YC8uoNi3kl2aTsINXupx8IYKpIN38cTRmtN+ad+qxIoobVVqlv9YiencxLLzLmJXDlCqHf/LWllRC/gtIy0gD5WtZvfTjCxVOf/30BUGdtoMduYm1HKajq055DaCzadxqKBEshbhZ7G1qLsoh0Nx95sTDQ7RdwIdyy84Yacsi0WoOkpU7lGQAWvtrfYseJ0hGv6o7U58Nk8e03VVAUniu4Lz4s5whkRoUW9UNXYtJKftuTiWZTa8Z5tT9sEXXnci7t0BjoI6iAWNV13uLnVQufYBCSLfm4uwitUcfDdwbRbuccVa8UgFRQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON is opted-in for DAMON patches scanning [1] and email delivery [2].
Clarify how that could be used on DAMON maintainer profile.

[1] https://github.com/sashiko-dev/sashiko/commit/ad9f4a98f958
[2] https://github.com/sashiko-dev/sashiko/commit/b554c7b6e733

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/maintainer-profile.rst | 21 +++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/Documentation/mm/damon/maintainer-profile.rst b/Documentation/mm/damon/maintainer-profile.rst
index bcb9798a27a86..5c23b1281c50c 100644
--- a/Documentation/mm/damon/maintainer-profile.rst
+++ b/Documentation/mm/damon/maintainer-profile.rst
@@ -100,3 +100,24 @@ There is also a public Google `calendar
 <https://calendar.google.com/calendar/u/0?cid=ZDIwOTA4YTMxNjc2MDQ3NTIyMmUzYTM5ZmQyM2U4NDA0ZGIwZjBiYmJlZGQxNDM0MmY4ZTRjOTE0NjdhZDRiY0Bncm91cC5jYWxlbmRhci5nb29nbGUuY29t>`_
 that has the events.  Anyone can subscribe to it.  DAMON maintainer will also
 provide periodic reminders to the mailing list (damon@lists.linux.dev).
+
+AI Review
+---------
+
+For patches that are publicly posted to DAMON mailing list
+(damon@lists.linux.dev), AI reviews of the patches will be available at
+sashiko.dev.  The reviews could also be sent as mails to the author of the
+patch.
+
+Patch authors are encouraged to check the AI reviews and share their opinions.
+The sharing could be done as a reply to the mail thread.  Consider reducing the
+recipients list for such sharing, since some people are not really interested
+in AI reviews.  As a rule of thumb, drop individuals except DAMON maintainer
+and stable@vger.kernel.org from the recipients list.
+
+`hkml` also provides a `feature
+<https://github.com/sjp38/hackermail/blob/master/USAGE.md#forwarding-sashikodev-statuscomments-to-mailing-list>`_
+for such sharing.  Please feel free to use the feature.
+
+It is only a non-mandastory recommendation.  DAMON maintainer could also ask
+any question about the AI reviews, though.

base-commit: aeaae01df7d17b5742e22b65b06f666ddea76816
-- 
2.47.3

