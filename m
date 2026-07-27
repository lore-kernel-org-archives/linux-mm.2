Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79C51C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 14:39:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C4DC6B00BA; Mon, 27 Jul 2026 10:38:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FF406B00BC; Mon, 27 Jul 2026 10:38:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 778B66B00BD; Mon, 27 Jul 2026 10:38:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4570A6B00BA
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:38:40 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CD71280769
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:38:39 +0000 (UTC)
X-FDA: 85034812758.03.58B6822
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4494A1C000A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:38:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bnSiVQ5g;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785163118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W5EHzuEPBttna1pHulKblhjSxz0ZvxjVFhC8U+crJAs=;
	b=bXzTOHrgPg5VNwF2RRHUNiw0EwGfDZLhFgWu8RY6DMn/PfmCN8IYhNs+jPQ1A9zFJx30Vy
	bkUJBjVaB6jr66epvwHVD1uZUn1wq+YlJuB9QhU80F4qA0EJ2MOawd+eo1/k+9uS8gesc0
	XgizUEbLTCk5+laDqoD4EdCMai9KpQ0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785163118;
	b=0HblLb9gYGbF3vccrBI8VnIV40K08mZb1l3g09Pvf5InPRZFcCll4hU97XsZUtb4r2HVNm
	zkyOvFX/yl4/q/8vSkcyzS4PGsgm5jYHkUBpIGV86pusm1wqmjNq4QIrffk5CZQe7DvM9f
	YFN9kaSiK7pWuFeChEZd1GkJA5JDQOk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bnSiVQ5g;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 197D043048;
	Mon, 27 Jul 2026 14:38:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AEA81F01558;
	Mon, 27 Jul 2026 14:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785163118;
	bh=W5EHzuEPBttna1pHulKblhjSxz0ZvxjVFhC8U+crJAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bnSiVQ5g/mNxfLmO3bUJMLGJjREn1gY+MeN8PYhhpiI2mpFuQA6M/2xQucHbcCaBZ
	 pj5WiIlj4QbDagOg1AyfyDTZcewQ4p8eJJWFoh6/R7jpqYeLW77blMyLX74pTTu9pM
	 EQpMA5CuW0sSkk0PQbN2xzHcFmGafS6RZbFa2w29Yf4LFvTyYrIY1OnJ00GVE1qJ4n
	 XBfcGFwgDanMigiz075B7kM/ZKrpF1KTcMkQMB+ncFes45U1pLeBSgoYRYOcbRs/ZW
	 HiYVpqh7Ta9S/GiSfwqg0l2H/UNkUuyMACg4EHCasgVuDXvZobnJOgIvJNGzeLh82K
	 fbn57vFYpyDgg==
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
Subject: [RFC PATCH v2.1 15/17] Docs/mm/damon/design: document probe preps
Date: Mon, 27 Jul 2026 07:38:24 -0700
Message-ID: <20260727143829.86236-16-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260727143829.86236-1-sj@kernel.org>
References: <20260727143829.86236-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4494A1C000A
X-Stat-Signature: ikwr1qwf9wdnn4mynoinbe9c8e13h931
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785163118-493095
X-HE-Meta: U2FsdGVkX194qXrCq2JC/nu+J8GUxVjJfcDKoXbGJUt/BN4urKfLTZeJjtuWRZwFWJo6GYhfOYxHolbKTPswvoxMtQVAl7IswwUZs8q3J0QQZK1DUrLtk8WBZJ8nynk5tLwzlXM7qh3B4NWS0nPYdpZ6tE/1MyTCqnr3mioU3YGoSYWqJUBjHa+mKh2qUxBqtF18SPHNcYirRyrdSybjdvkeEKxR4s2dghyUNodXwIlz/3EWUUZKnQg6kTLSR+xEFyImCwIvcluVCnp/nBAIyuxoTdu+CgKw10vBOdyXyCnJ3XGWIDi88aUFaNVLK0V9lv8t8/sFW6ao+92orZzy9H3KpfVrbI+lVq9UG2SOWlNM0Gpbn2e5r5GUX1SQJaOau6wUfxOgIdKBGtguZY4Qu62Fjlj7ve5po/0xFCcXtsv+TOnYw0bXZ8dTGD5CGOhucPY3457Jh3Plr/CEuQBMjGirA4nzfdrc23JTMLu7kC5cbWfW42HeZWr9HdRRP1hi2GcCAHIko/vjvkcHCliQc4oU5vLMwIiqeKH+UQVi2dxZVEWpRGx1UR2k7LTakouxawzoCD8OZ35ZkVHV5mQRZDU8tYwxIPeSseM/7Jrpy3HZDyH/8gzJWTGDjm1wVD+TiAEPgKxe50iXEpN3Nr4kankPHtCETuXOauWe3domiEvaBs3SFNOKrEu05RXlweT32mMb6lcA8HblW1imro8Kdb7HmPrkno3zeKI/X+g268MyX4eZHqgxdAbtcddOEEyw7JE1POgzbaYsZpP286/PF7nlNeduKLO5EtplxUeulaFtAh5s7GAGYKA6wDPCtjV8T3+VLcttjSVMIHaxRmn/4xM+YynhI6nBHrERQfSaR0CT0xl+Y0yE5V/ttTqCgKE/jvOUImTppuiyxfKYRdFEJjE//cMxPYL5nYtdTaYcjHc9554HaVqttXj0nTA1knKfWRww/pjODxbhmTWpz2y
 sEdat+B9
 DLLSM0uJiz8faH3MA47kPippGmuoLfQZzh2FKMILkPuOc2ugcSzO/RCacQjDINvBFXiIevbXnbd/RZ1ViNrlFWJ0j/iVD15jv3gpHl3+iLjN4LT7m+4+oaUFsZsL0eAa/Hzjrtb6iJXsSrb/68Womwkdez6ud6S5hFTuctHAHwBF4Y0hBhyJp1mIWS9TwBB7W5mAkpWpbuDtapWfIRJn4JuGletPRAKSKmF56/GnBJgBtRhc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the newly added DAMON probe preps
feature.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index c4830bd09498d..7f983e0c39b80 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -309,6 +309,13 @@ Users can therefore know how much of a given DAMON region has a specific data
 attribute by reading the per-region per-probe probe hits counter after each
 aggregation interval.
 
+Users can optionally register probing preparation actions per probe.  If such
+actions are registered, DAMON applies the actions to each region's sampling
+memory before starting the next sampling interval.  Currently only one action,
+``set_pgidle`` is supported.  The action marks the page for the probing target
+memory as access-idle.  This can be useful to be used together with
+``pgidle_unset`` probe filter.
+
 This is a sampling based mechanism.  Hence, it is lightweight but the output
 may include some measurement errors.  The output should be used with good
 understanding of statistics.
-- 
2.47.3

