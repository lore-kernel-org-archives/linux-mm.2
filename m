Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBD98E937E7
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 21:19:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDA566B0088; Sun, 12 Apr 2026 17:19:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B64116B0089; Sun, 12 Apr 2026 17:19:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2C136B0092; Sun, 12 Apr 2026 17:19:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8D9906B0088
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 17:19:44 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2E81AC3789
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 21:19:44 +0000 (UTC)
X-FDA: 84651170688.16.4C5AAE6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id A60B1C0006
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 21:19:42 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uWqUOw6W;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776028782; a=rsa-sha256;
	cv=none;
	b=IIUnOAG4sAkUfoASbIbSfUCOolOnXDaRw06idQJWbd7EndMGEySeZhBjW8dCVCO1VgUIML
	tKaqZOUcj8yeUiC+rHtYFJHPbMOKdd2l3naw/KVGDpDyTMEiFN9aQOotJZvg7g3qzuWbqi
	mnqeF6+1zuAArKyI1TSrYUIJNX+98Qs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uWqUOw6W;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776028782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Bflc4qIwSqwyCIc++PkmhVkVdgXGd1cxpTltLXBSSh4=;
	b=1oaY7ecE1oLGkd2BoVLu6aRIk2/6ehED3rvIrwiJFrUZEOEigmP6S+K3+uAe0ldbhytjAx
	ct4xSf9OQK4ORtrjSTmn53M5lToWow/pqscGhPY+r8W2hg562GmEqS4gMRSlJfa7TIznh3
	dEeNE1Y87DGrAaSpHcGBHkWSuqJqmYU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A16FD60142;
	Sun, 12 Apr 2026 21:19:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFBF5C19424;
	Sun, 12 Apr 2026 21:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776028781;
	bh=A+viAtzJhebo8EZLCtKP1pqNz8neWzmWQtOaasROq5E=;
	h=From:To:Cc:Subject:Date:From;
	b=uWqUOw6W58RXhfqMvzzHjaiqCSMnugIccRIlvCBDUZbR5n05lrVD3dsDRoFnDJJDV
	 dz9/qvoDWtgV843kX1KtouCgqUwXJcx6V4Zuw5+Y48muX66ZiH3vt634iAlRu04ZWy
	 yTgQCE7NmgUoIWfZaMFR2jG40eJsXvd4cXAzMf6XIowPJ8dX7Jm0VAw32MAhqSkeDy
	 Wm46TJ5TZdPf6GaO1lThQZMd5JIyeCN2LYR4JykBLAgGDV3I+1pbc3qqRuNqY7tY1f
	 BX6+ZhOFGkogLg8KtaGXyaT6gp4CIMlTrdqI4R5xrZDyUy6FSUH0QJIlnfjZ2mXZRS
	 3utuA4U8c3T5g==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	sashiko@lists.linux.dev
Subject: [PATCH] Docs/mm/damon/maintainer-profile: add AI review usage guideline
Date: Sun, 12 Apr 2026 14:19:31 -0700
Message-ID: <20260412211932.89038-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3mca88bi76fimapru97dmh7szwodiw7n
X-Rspamd-Queue-Id: A60B1C0006
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1776028782-761301
X-HE-Meta: U2FsdGVkX19nFkjR6QeCZKGH38SpUat3gwVXFOEIJytRNs4LUkZA5iUzfRLlW6yFxmo0FZTctZcZaDMhFCR7c5iGVOWAkbUgbHhYEzQeSQ+WHcvtkBBE2S3qKuNofkOGGVhuF8ZLmUWJb7SUHeiYewH4IMCzSEox4XDiPMwud+nqPU0wHhCHsXf8D09CANI+Tl2qBPpKjj4AgBvCyImzhAS/UHzZMGYkWp3k4arFgyQikXZhjGq7H5vq3NtFj9YIlpb5Yeprs5Ozhrt5buEI5Td9Jlfq+P+XQwi/6ui2KBzYmovVhYH5uUtCTqoTcdq/MoQ0qkcD9SBtuZ9eGdLc0AlKxi3DNTYKQsR6e2Px2Oaz8H7PAJaIT6JF+f01BoUHvGjHzlyjZieF42E5CmgVqLhzCAnLkLGOrYXpg+CW2/pQfVtwIjTqSSc61SAHrf/4I6B+qIwcjsM2IYlfRttVShUFUrJF6+VhxWBh+vjZvYv+epBkp4FKByoZuW0JaVhVxcaVDhTBiuMyKLB7UJ++czggUO1J0QT5OLycFQ/rxb13VamjnUKw7b4barxukC67HJzfzi/G/by0sKZmBrfPZrUek72pWHx8T4kUKfIo9CGHUEfLbDt7FUIQxVXUhzbRndzd2WZ2CzAqWkH/Tm5hPfjEW3PYsoAujWSrPgEQDuUCy/dcgu7q/rTKFP0Lv62Hmq81D+N/MWsO8GEy6zCY5fTyPjNFstTDPC6/UeJJgIseCMhFqwXm/fShrDEgXmPnOTIXkowOObiVkzbtNCqmz/HLIbFdF+xlIWjU18j40UEpVCdR0ToPwiojXhSD3XVxd3VeURsW1+WoCcOB3LUMrFkSwM/vjF1C3aSY2Ks1C4cZSRW7Y4vaT01m11Px2cHrphH0a1f1W/MwUSKXZE9+LnGOH8VPVTtaReJZeqQeRooj8ks71Ru606AE0+bB4FVszsvdljbm76Ousx8Y+Aw
 OJJr94IA
 0DZNIj5JHvBGzNfKm7oTe2gO3bx1ybel4x8AGJ3GBY53Sj4DIVG7LOijaI/W50FgLBcy51dEmmOOJzhrhykUG8ed07rkU2Ikbb4kzbHyvFNhUrdTXj8sX9jEv6R2bHNj0ahKgFdlbyaXYJLec1iYzkkQpZ9vl9sLD/8Lx0nnk7+aonntnLAPTppA/KGT8DGWXMHKIVtscGWxPE8tcaSIVHjEGCUcwna8Yl0gOCB7Gm/VywVDI8QeFiccj0voVnXfbSNUrp/yA8eumuKLTvpSq5KWLAwj9/2EPHQzAAzy0/9Mbne+Ge8bayw5P57EyImttYxuU7V5f2ns8LueFIvxJmm2OuQ==
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
Changes from v1
- v1: https://lore.kernel.org/20260411183029.81030-1-sj@kernel.org
- replace typo-ed word: s/a non-mandastory/an optional/.
- wordsmith recipients reduction rule of thumbs.

 Documentation/mm/damon/maintainer-profile.rst | 21 +++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/Documentation/mm/damon/maintainer-profile.rst b/Documentation/mm/damon/maintainer-profile.rst
index bcb9798a27a86..fb2fa00cc9aa1 100644
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
+in AI reviews.  As a rule of thumb, drop stable@vger.kernel.org and individuals
+except DAMON maintainer.
+
+`hkml` also provides a `feature
+<https://github.com/sjp38/hackermail/blob/master/USAGE.md#forwarding-sashikodev-statuscomments-to-mailing-list>`_
+for such sharing.  Please feel free to use the feature.
+
+It is only an optional recommendation.  DAMON maintainer could also ask any
+question about the AI reviews, though.

base-commit: 507d761b28278a923d86e7a29c5d084b74639e15
-- 
2.47.3

