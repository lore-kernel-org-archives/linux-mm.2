Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 690D6C88E73
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 14:45:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA3BD6B00A2; Mon, 14 Sep 2026 10:45:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2D206B00A3; Mon, 14 Sep 2026 10:45:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1B716B00A4; Mon, 14 Sep 2026 10:45:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 860D66B00A2
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:45:01 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 04F5B8011E
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:45:00 +0000 (UTC)
X-FDA: 85212640002.09.8776950
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 64B59C0002
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:44:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AZ4BIdI5;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789397099;
	b=lUuGL7h/pcB7jR5tklGffiCsuWI8mdQmcQiBp0cXe2HVzsG/QaGF4MIqa3IJ4OHVVzk1Kn
	5i6HsUtj+4X5cvm93xX8zEXxUK5obd+0ClE7UJcfP9RhEqTZAwsRRiOSsqWtpRJpeHotLh
	vm4K5i7JQ/nbWc1VbBA/3hkA5Thwcqw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AZ4BIdI5;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789397099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KlTkThYMNDC2bLrO2MA1hCJuFVsV7BXLwZ+Px5RpEUU=;
	b=fDLIhw0CM2bP99nIhinkFRF1dgjM+81f9dySUefHZiWRktXQ2P6a4O5NeAa+FtUcn04inW
	oLr+Ve1ISyfZR5TZ4gPHGIHLB5tSkxLrHL8+gTsh6yxnSr6AVUrh5zNpOMpf6Wjra7baf8
	eUwfxZcGYgDpTPn1amlrhHakY3lhI9M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B319543B4A;
	Mon, 14 Sep 2026 14:44:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BB6F1F0089A;
	Mon, 14 Sep 2026 14:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789397098;
	bh=KlTkThYMNDC2bLrO2MA1hCJuFVsV7BXLwZ+Px5RpEUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AZ4BIdI5O3hJqwLDTzpdnlXAJJ8z5jmnuGpDAmnV9v9bxOPtFQHcFG9lgURso2RHk
	 BIg+MpMzQ/TAsnLTVbVxSL5Cmxt/NaebNIucLcvwN4X/3CufGd4o/mNCkCk9zpzReL
	 mTkDPQE32ASU1w/wPwv7mC9dEbsC7uY/l8Gabedtm4AnkBnWdCWYvWehOZl8ZmOzD0
	 Fz/jEc/joTy88BjTUpf8K5ImN4g4uDXyBJCxvNrqlN4PEXz2CflftdTBqDSk71cC9+
	 nBBOB0pOpis86iohGXrxEkxXhx5jCYtswugXw/Za3//v45QzwZ08MZEK6gxVfP9Tif
	 CpwngOKfFPeGg==
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
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 6/8] Docs/mm/damon/design: update for hugepage_size probe filter
Date: Mon, 14 Sep 2026 07:44:43 -0700
Message-ID: <20260914144448.93732-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260914144448.93732-1-sj@kernel.org>
References: <20260914144448.93732-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 64B59C0002
X-Rspam-User: 
X-Stat-Signature: qg1k5ncabwuyd7gst1hmcdtmanzj765q
X-HE-Tag: 1789397099-893553
X-HE-Meta: U2FsdGVkX1/JVLy2FMnYkHVtNEDpL4ouexUp3tny0wmjxbBMZeiA1+ldQnaI0YnrXwEAMXFv5I9MME+LHg0HkXtqg4tUrFJuJ1c8rrxBDJ5JUGZWkuQtx6sAVtGz0dWBpG2Egn2lXdScfBGrnbzfq+HjirdMBCoMyJ98Li/r56c/meo25uFZG0DvFe5FEL88cDuXZUi3Mj8Y3xQYd1yWTWXb/LcerXi6Qa8nsWLBA5WN+wgiJhX1rN5NxOJezOXdmnyqu9Q4nx4yS+O8nEo9gHseT4Zjajti2JQpSAMxLpTdi2Rd3tvsCaZhprjWiVBq3/ep/jXAYgSkHmmCeFqnx9bD+GLMq64ab5A+gm2RxAXK50/UYkPItOCnMJDmyABWUdXf6yw08M/BmkV00UcTIT3j+P1p+1R9QQ7QbAKqnz/B/dtN+FPkp2M1KmXUcIFLyRy06SUCl4DLjjVe6Mu8oCG/ghSToJdXRr7Y3Cr7WvMR+1p/rgCCe6QtxxBgM1TLs7qxS86hHgEGVexPGxp9uhXbEn0x9JqjvwPgE6bgeeKlUNiNb7JTyvTuAeRXR0sRvpg4adpWbCj1OatpqxTfzpmpA6IMLlrH8Y8I0Y4E6qgJVN6V3UI/2DoeHrrZ8iO00bdHPbUGlNNqJjXtRP7OEEyqBrdTl2UVdvF41XEMAWRhwYdY+/BYks/xz1fkNTCC1XaraHaKgsVWZWmGrvNLC2XNeuUgYqsVfJVyllKp1ZognSNT2P9YJC7NGQZtfaXV9J7wJZEcM4wHc2mJxwbCKbxrjba4SJAu25ummen5dyvZQPhBpkxybesIu+CEsYPJ74/u8rNC7yTFfStGuge3bT7KNPvMl59ZbRrfgvEInNo3b3q/Zw7qFmQCrEqb5LLJGKyoHJ9whxkiFB1RJQPA2rLnzvqCAWl30jlbFBrQ8h5hJih4iFKoPtMvmVALG+WQvKsc3mIompf/kBn9a9B
 EEjYCsLM
 RlyR3+zHYuE0RTka/9XoPl0+nvmSEdQQFkVxEmq1uNHi5ocLxLuoBRJwpFQpl+DkH2r/7nMOKPjl55HFc7tI7gs2I3lgWxrhzhWKY4e+MkEbCnpK5OWFx21xky8uxP+BIudpARt/SK5uShzrA6HVx4vVxKyt3TnkAFsub4faDowO+c2fVbP401P0yJO+6MBKH07zaQbxrUv6SVddLPt46YDVxlF13/GsresX/eIUrVq7+ewCQ9V8JAiYaMeiBAbWy/ihGZHuV+iy5w6xfUv28nnTVGW10acrRmtFOqE281CiwN1PtmADzAr1oiQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the newly added hugepage_size data
attribute probe filter type.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 707170bcd1b33..0a86792f90a18 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -300,6 +300,8 @@ filter types.  Currently below filter types are supported.
 - ``pgidle_unset``: Matches if the page for the memory is marked as not
   access-idle.
 - ``pgidle_set``: Matches if the page for the memory is marked as access-idle.
+- ``hugepage_size``: Matches if the page for the memory is a part of a hugepage
+  of a given size range.
 
 If such probes are registered, DAMON executes the probes for each region's
 sampling memory when it does the access :ref:`sampling
-- 
2.47.3

