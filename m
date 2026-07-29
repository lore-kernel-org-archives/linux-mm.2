Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D1D8C53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 03:38:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E15026B009F; Tue, 28 Jul 2026 23:38:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC6056B00A0; Tue, 28 Jul 2026 23:38:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB43C6B00A1; Tue, 28 Jul 2026 23:38:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E6BC6B009F
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 23:38:06 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 30408805B1
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:38:06 +0000 (UTC)
X-FDA: 85040405772.25.F5D6E00
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id A58E7140004
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:38:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="eXKQ8/gd";
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785296284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+7L5cUB5gmn/G0XCH5EnzRVEYnRmQ6289QitHVcV3Es=;
	b=zUrQjWlvZuv7QvIcK9LczGcmwTZRbFka9k83q9HuldBdwOfFKM0QK4PwHvCQbvukjpzhdp
	8kGXdI7xoCxBLM5u9WQ+sXPlYW9kuOEoPhX6shzD1lPMdWybfxpRLZwjw3bh9ZW4c2Ear1
	Ye+SGjtDazmsvj7GDxsiTF1P0sGEEZc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785296284;
	b=4JHeG/BVBdrkcQvgOk9nKlcd4q+SzL3tQ2fAgFhNjr1fH8f7LbpDufH8U6EWn+hcliscGI
	60EaD0OH/QxxeqNmPTP+B1CrgiTdSwyDjb8U4raSmh+kmHaYMha49KWnv5AVuu7UpzwmjC
	LyQbNfBBgKaio5AYwET8ygXnNYNOlB8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="eXKQ8/gd";
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4AACA60A60;
	Wed, 29 Jul 2026 03:38:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78CBB1F000E9;
	Wed, 29 Jul 2026 03:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785296284;
	bh=+7L5cUB5gmn/G0XCH5EnzRVEYnRmQ6289QitHVcV3Es=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eXKQ8/gdJ5jeWOSOGK/oDNdW3r/sNFDPgeZNAx+2MAASe3LcWCL45R+98Fvn0WEwV
	 xIR5zTwa5P2zP/aKtVCZ2DpPOyZvGkU+UKISFamU+c0W2TsZrxDLwMkyImPKiLEtNT
	 h+VeOpIHHe3wGkuf02Dr5RRXZC3OMgrWAbWkwv9IqwS0sd6GgTAK030cWZccugHL7/
	 1VwRz4mKVpI2yuIqZkTgEU/ULXggXGgqLGOyLfX617BXEGISATiEPmMOd6/O2WH63b
	 i5a3QyUnG+MWI9SAvnF3fonkf/44L2o6Qanfq7vR8biK0gy5IvI2hG7RaKggSZ3V4L
	 8sFQyHHgsfI0g==
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
Subject: [RFC PATCH v1.1 09/10] Docs/mm/damon/maintainer-profile: update AI review for Sashiko replies
Date: Tue, 28 Jul 2026 20:37:49 -0700
Message-ID: <20260729033751.131213-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260729033751.131213-1-sj@kernel.org>
References: <20260729033751.131213-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: drpqox1zxx1u4wfd6akpxq1kqdc3e8ad
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A58E7140004
X-HE-Tag: 1785296284-285733
X-HE-Meta: U2FsdGVkX1+kAe84Jn7l4JpPBFhuE0bjNoqUsAxDZKMtF9jKgrfCnfCA3klUeMuCmhClQ+YDtjSMkT3+yTKTjzHJoGxyJ46gn9b1vsK+4ZN4aEvmruoPqC08sVlkMokTsiLWJvSzDn6jxVlZlC47eCvDKymwJQPh0/N7B/kTYMKVZFRzNuzasHJwgC5OpeXopSoU+Jmzk2gBV/+vcOuSrHk8Ij5r2/um7JTZtXxHPAMrCI70d2PRGdttEM1tiRqywFr1altqFqPk9d8wza4eiqG7cSOQOqqqodf1Zk9tlbEE/q05oInsAJKLrnnBJ1/hs23LwcBhpSTs6JYqL7wxonZbzR4lMn+hFNpdB/rigTEOE12kmLrUmMO1F5xEAbnnS+A6NJ2POlchktOtLXcuF203V04pmGRuX/JosXMJdxDUMClTjRL2VuAwFXNlm96bEflAURUZI8VIXe0Lyp2fWld6C48mifZdUAuSD3ze61IqIUp5+Z7FlIjK2FW/emMwg/m4N3fL/dE0zapiJkMShE6rzLtrTrd6UTNaBjIDQQd7znQvpIDrgNMZ0pQvqf1jua38LFoI1DRKhDePRoWH7kduoSOchA5+xDSwfK2iS/VATCm1Tode4+vAB/m4YQGiDPDopQwkAMjq4Yy6uQ6+88Elu6RTualXFNOh0wQwTAU7itXYMfGdtkvTHel3sKc0WJt21AjCR5DCAdsM/FlvJJsBhEPFIVHT5ibAt0NdlGR3wRO821JRHllAYjPsVsJyywymuFLnkwLxBU6MKhvZvIYVqjAW1tCiiPC5CeIwzL13Awy109uKplHMOVC3pTctcuEdx+VslOkzhrBq7aW5N7M1BqXHI49Jt96ZMI/93jjl8/UzAhzk7W64xpXvfHzdrRmRYhf+h4IUQns3kPl8XnuvW+cAhUY9G0YlK2l/TqAT7mQPwoHsN2KqUx3PazY3+fs1BwE+AnyOjfj3H0O
 RBGzVxy+
 O4j3Ncggva0EKL7mgGtRyTg8P3+lQV/UbZffd6i0SeCmiHVrnD43vbhr2s8hL63W/L2Gw1qR/RTN1um6OjR9ynEXyDM3wc63nQLpfydKkalbLdDYDNs1DHMDTdEJIrMAlINsZWkgROZV6MLdunvEhn4ZRPeknhawn2BEOhUcigwV2gKXLJdBMDd08Z51WrHus2ntbNVahwqitHnD+O2bJreYCY6GKPWJ9h869wMx4iGTm7p09HQu63hNkC7jMg8s51Y3V/O8ZFH+2AzalSH3svuUe80LlIjoACy8rOP57tq6+UtInjTdzDf0Q570Mm8a5cqTe
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

