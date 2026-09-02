Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 604C5C61DFD
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 05:48:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE9336B00A1; Wed,  2 Sep 2026 01:48:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E71526B00A2; Wed,  2 Sep 2026 01:48:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAF846B00A3; Wed,  2 Sep 2026 01:48:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B39F56B00A1
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 01:48:01 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 479918075A
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:48:01 +0000 (UTC)
X-FDA: 85167741162.25.B2392C2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id B24F540005
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:47:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A7m5oHnu;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788328079;
	b=XC1br3Lee5tfsKuZBsxLcGHTcQqL/dWhc5Bt5O3Szz/xZ5Q4bPcWDRiB/Wdil1gIOM2qiQ
	EP2hOx+CBWrW4vdltI3KeMhM3cX73tG3JTeGe+fGW7FUPhzr11uskJtXv8BkyMDgVpsJNY
	QRMBLMn5DKuHqJ9FolAW1/wthV9t3CY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788328079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+7L5cUB5gmn/G0XCH5EnzRVEYnRmQ6289QitHVcV3Es=;
	b=Ml6wARFhoKX04pUHEzFPtp6lFtxaKRkCERg4zFaytwcry8fZIP5zT3QxDmGX/3LgyRVQiD
	VQl659PCpHjXv48yKT2OOoHU6LJ9L8OUeZvF66Cyi9Djr64gmOkivhTtpR0QfcLT2ETFqT
	iIuOD2fiR+C3Z0KqkhA7OMOZ0YtjoLo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A7m5oHnu;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 515EF602A8;
	Wed,  2 Sep 2026 05:47:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DC481F00A3E;
	Wed,  2 Sep 2026 05:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788328079;
	bh=+7L5cUB5gmn/G0XCH5EnzRVEYnRmQ6289QitHVcV3Es=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A7m5oHnud/3hqN3P0e/92GwC1TwwvZkzr13eGqpNp6wNxffTd2DX243Ns/4sYjmuw
	 SbeScDff73MU0Dji7jmkBwY6Je54afEvxYHwr5XXCX8km/tHl0/VUucaH2LJoZmYCR
	 fcERvk8nMyRYJtpanZeVtevI1I4787S4PW1ktiElSZJZmhypyV7EXTJOsNJiclFO9D
	 QhaibuNqlbNZsHHmgjvNu1cmwPJqSKXJctSLsNUcubQPlm0E40mCt3eNeOd0exjE7N
	 4cMs/KFGDHHGmwCGLOJTuOjjIzqok1qvt5agmgcd1/BvgxsQKxw29zriy9IkEq/nTd
	 ZbhMUsJ1Ppt+A==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
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
	linux-mm@kvack.org
Subject: [PATCH 11/12] Docs/mm/damon/maintainer-profile: update AI review for Sashiko replies
Date: Tue,  1 Sep 2026 22:47:44 -0700
Message-ID: <20260902054747.99370-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260902054747.99370-1-sj@kernel.org>
References: <20260902054747.99370-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B24F540005
X-Stat-Signature: pwc66ce75s16hmee6yqt878jpmugmaoe
X-HE-Tag: 1788328079-310951
X-HE-Meta: U2FsdGVkX1/gB1UUr5STsA4dhNQjSnuCQXYiF0OF9eNPodMXLBPWpnEMAQ3uRn5+YRc45hKrx7sMphV4UUoZbYz9OjZHBUeL+4W0ljS6DQ7DqJL91D7CpP7AALgQ+LB4+AcS6MkjC+jUy28yzuov2chklbom+YMxEZgV1R9c4CIYofJFiNVKmhzWlUcdssCC/WngYidd/s57RsFlWBgQQ3xrUwQD/NMgl68Lr3avCLx38Q1n+9lY8Jy1w6p4hE0SNKjh1khrzBVNttaBXUIm1LGnwS8jyScYBXToVq4ry1F8dHhO7EpLlFQOyNvY9vWbHSykcqktfciAONqEcDFwvv3vEcP6aiCVaWc7AJWcMHo0BLsElIdgbcFEgWID3+2wwm1iBDPMG99EEd3VE9vGTgNdbBLyCMoPAVj+T5XEuYJ9avw7fSE25BoeZLU/MfGxd+mT4WNu/hV0NowaBwaosUW7nLXMb1XIqWiWXM13FdG2tq9QTsDQ3wEuvoOU3nQbUPhbnP/QLe4HIikcAtXhfJWX0bjzYY9M4tb31/rtDiMqZx8aZ/l5sp4zNoE+wOpAtkUX0oHdJtktPrMdRnJsB6GJFizXxnKdbtID5yclJdolqXsw9N/JvSDpafkLVh9o2q67w/Bv37Pc/nNTD3XQTYmfimGF46tsuys/eydw+TB5cb9HbGTXO/NDrWiNvPZDWMkm11eZbFT4u1Kn1xhzfiRqMSUzZ35LF3Um2cVDkKd8P9XxxKwWEdKhg6o8bCss5L5JINo2lemqqF+YXyG+O+NuOiwkRA2DUejXwld0xLBSixvuZnTCQeIZ64fllRbZzn4NdT2ZdorOUNfB/7GF/9pxOmfOZcz4mJI5wgSHc2Ko7t4MkpoY9+ykDRXuH4W3J7Gmqins5B6HahHIRB7Dnr6bfplXQ3vVosQTY6kMPpF0svAf4Z4oAbSOu6c8hVg/a+cMmLFwsYETh1gBCP2
 rLEfPSf5
 0fHQma6EtlXwPMw+x9DOZOkbbMRXuhSsHzo7SCNP/SkoYpBoqHJXPbOlU/yMX/iIhzYzX7RMtPVrVmUpn5y+Un7ZlIKxs56uMyMvZu/b4IG9nDeq9txX41Z1VdAQ1BVoq+6EwBYlD5pCdpsd9iW04pnh4307HIWl18tHH9sj4y/6WAT/fHVPvvBhlE07HZ6vvP6rwGktY6tDxkUOMFe+1C9BI7b418u7Pk76cqGI7mbXWSv2ylKdjlGmSzBzMO0SDXln5k1TK1K6LkiwZCWbJhs1cEI99W/yilEgKo0JxFO7ys3H0VIcqX4MKgkf1dttwJauP
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

