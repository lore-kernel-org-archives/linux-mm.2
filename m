Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05D09C54F51
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 05:28:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1560A6B00A0; Tue, 28 Jul 2026 01:28:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E0956B00A1; Tue, 28 Jul 2026 01:28:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F36B46B00A2; Tue, 28 Jul 2026 01:28:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C3AA06B00A0
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 01:28:22 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1C81AA0282
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:28:22 +0000 (UTC)
X-FDA: 85037054844.19.95CB179
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7DF381C0004
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:28:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QVt3VbG2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785216500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+7L5cUB5gmn/G0XCH5EnzRVEYnRmQ6289QitHVcV3Es=;
	b=o9CQszNDSapxDkGpTHtpW5vCQ/UBLSrWbRsVO9EF4yIGYz0xQRDqrPNiCurkO/aOwYTHKH
	QctpVrLUJNMIHhXbWNuMgOlucvDv0s8DGTVYSy6SAzyYxLbbvkCFQpj7qkmQ3fRh/tcWfJ
	615OMas1EeHfklQEbzjiJxm4g6zD4rk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QVt3VbG2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785216500;
	b=2d3MAOAy9whYKSZPeur8ZWcVHqW7kxdP5F1/vgztxxN8Z77NMv17QxnqyXqalr/6ygu4gI
	WiK/fSLe9e6We9m7/evymv/pr1ySDhcO8FPzeLoqi1lOppNmOQoPS85NI5eKvUjn83HHMP
	wewr0I1cl32zNglYD/UQEdxqRrAsgFA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BF50943F47;
	Tue, 28 Jul 2026 05:28:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AA061F00A3E;
	Tue, 28 Jul 2026 05:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785216499;
	bh=+7L5cUB5gmn/G0XCH5EnzRVEYnRmQ6289QitHVcV3Es=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QVt3VbG2+UUJwhyOFGMlC4p5BB9UX9zAbrDUSY4ugI3W1kI2lxkdwDG0oAlGC0S0m
	 7ViLVdAdd2KFukOc6mIwbE7YUG9jLqlxhooMrjKTalB3SHGjL6s1pmvg+Ru4b1ry1e
	 XZGKX7c8B3OPzellSm3tJOmJtldea4eFv+ifNg7XSIOW5lySQKpadFokmN1ZLLx+di
	 oCVC2HdOqPhzAHF1KfVAyvnMgusOD27Z1gcO+EuVXA/GW0qYTOsBbHpRnwf3dYknW4
	 I4jF/VbbIJIT/AMRRV8H7V8iw+En+xxauXjO2OrmmJFw7/i2/MagjBXQxYvxlPtLw0
	 Q5/PkpCsoNXoQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
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
Subject: [RFC PATCH 09/10] Docs/mm/damon/maintainer-profile: update AI review for Sashiko replies
Date: Mon, 27 Jul 2026 22:28:08 -0700
Message-ID: <20260728052811.192712-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260728052811.192712-1-sj@kernel.org>
References: <20260728052811.192712-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7DF381C0004
X-Rspam-User: 
X-Stat-Signature: smu36qmry7ruoeyqsnyo3gkkdwfyp4un
X-HE-Tag: 1785216500-723243
X-HE-Meta: U2FsdGVkX1+rjwc2hCKMUKqqHZy97lrd8s1W6Zp2+KUpxT8itkj2ypIBYg+yNtzuHMbnYLxXVouDJeFlxgb6DReRYmyOeqyw/GfsNx8DyV5CBDo9LfdWJCMnMuuZ85W5Te9NbPnsibf/o1lFpIxyZD5vo5ZSIlX+C+nIIdX27JkxOrKcBifDYem4dHKW3+9TMgoibd+yjPVIrkeFOHG+YC+JmQYm6Jiu7BeynHptaqkOvLxtbeI5FeIs+o9t31B0SKeTHgbpL2Y1T9samm4e/h4+RQcNOtnSUttQNmMVth4kyUUtjlTYXdIVee1rvLltQg7t41wqcwp4yELhb/PEFDaf8S4HYDgg9Db/gIfVVp274xGSB/isNK8B9xVvVieyqp3Yt43H5GHQM7P2mGdSngHN9LAn/pWcujT2okQUuvlVFrXF7lfE/3Lelrm6oVPW32tXVnhx3r9+gdn9Xc+za5/CRs59vUSkMy1KtfdXdKGmjgiYS9NrmqBEkaiC7BJvsueJBMTJc8tMBGxz4OsdWlaFiulp7odvFzPY44lGuj7sXPX7Iuf66TDm8RyOpTYzo/XJtGfQ4XLvI9JG80+cXEHiN/PSkEi5rFJ7loP5JrjAXWROV1Oa5mOMna1oljusBHtYe4XlvJOvYvTXey0KyvgdSeAW9TomTPrpxA9ixiurIPPtpjeHNXiJFgW/GYKC++KXGgbIFigAizVPpTXIkCC4HbOeDsO7Co6fh21h9EZ0CoEcUQuFcZexAhoUR9Kc6GVwq8WYSmWxQlBEQhsFqAp+az9L/K1HhUGVZ71fUGFBnJhHpLL3q23vlV1j0JGSSUC3nTP2vhDae8zpWv0kgnS6q8UOy4buDNH6MezV31x7aTtYPZV5oTYXLs+iyht1eG9Q94y3gExVkG9jZrVGmgkwm4BnqOjS2weRpYRfu/O3ne5UCoc+33r0LgFBbh/fIh7FWGKOxtZQyx4uGM5
 OG1T4Weu
 8BoA58npzShyu9hjRj9Z6fxVHNgraIJUUCRDHS9THzs98Pl45ErfzlJW3+dpjaJmY7gDHIBB8HtiqX73cl36STdSsA7Rc6Zc1898OHbWDMPt0eQ63Hdvd2mmNVJVEfArZtLKAn5EJzLA0GTkbUV8Dq4C0lSsyDh6yYN7QHNycCALrQik9iPrpSH6TqgeWs4+nfXfgzEsJc5al9VTbNT81Sl34fGdRBZc2PPjT8U/Qr8enqyr1SMnW56/9wuEI9zdKQiOyCovZ6GExm/VtBnV7WsSXSCE/W0nK9FSkZj8a3+W/yjXaFSPIsu570l7rSUZhYaj2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In the past, sharing Sashiko review results was tedious.  Also it was
suggested to minimize the recipients on the sharing mails.  Hence the AI
review section of DAMON maintainer profile document was updated to give
guidance about available tools for making the sharing easier, and how
the recipients list should be managed.

Now DAMON is onboarded [1] to Sashiko's automatic review replies
feature.  Sashiko directly sends its reviews as replies to the patch
mail thread. It also reduces the recipients list to deliver the
reporting to only the author and the mailing list.

Remove the old guidance that is no more necessary but only confusing.

[1] https://github.com/sashiko-dev/sashiko/commit/b554c7b6e733

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/maintainer-profile.rst | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/Documentation/mm/damon/maintainer-profile.rst b/Documentation/mm/damon/maintainer-profile.rst
index fb2fa00cc9aa1..a7c1352339378 100644
--- a/Documentation/mm/damon/maintainer-profile.rst
+++ b/Documentation/mm/damon/maintainer-profile.rst
@@ -106,18 +106,9 @@ AI Review
 
 For patches that are publicly posted to DAMON mailing list
 (damon@lists.linux.dev), AI reviews of the patches will be available at
-sashiko.dev.  The reviews could also be sent as mails to the author of the
-patch.
-
-Patch authors are encouraged to check the AI reviews and share their opinions.
-The sharing could be done as a reply to the mail thread.  Consider reducing the
-recipients list for such sharing, since some people are not really interested
-in AI reviews.  As a rule of thumb, drop stable@vger.kernel.org and individuals
-except DAMON maintainer.
-
-`hkml` also provides a `feature
-<https://github.com/sjp38/hackermail/blob/master/USAGE.md#forwarding-sashikodev-statuscomments-to-mailing-list>`_
-for such sharing.  Please feel free to use the feature.
+sashiko.dev.  The reviews will also be sent as replies to the author of the
+patch and the mailing list.
 
-It is only an optional recommendation.  DAMON maintainer could also ask any
-question about the AI reviews, though.
+Patch authors are encouraged to check the AI reviews and share their opinions
+by replying on the mail thread.  It is only an optional recommendation.  DAMON
+maintainer could also ask any question about the AI reviews, though.
-- 
2.47.3

