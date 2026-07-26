Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAE2BC531C9
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 17:40:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EF5C6B0093; Sun, 26 Jul 2026 13:39:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C7236B0095; Sun, 26 Jul 2026 13:39:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B5AE6B0096; Sun, 26 Jul 2026 13:39:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CA76B6B0093
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 13:39:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3B584A0563
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 17:39:48 +0000 (UTC)
X-FDA: 85031640456.20.2F3CC90
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 94DE04000D
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 17:39:46 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LQiLs0wm;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785087586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qlh6y9Au18vR1Ou/T5ICe3OGlXl5Nc84fCTR2Y+rZXM=;
	b=8BE/YjGgwGnoenZV++KEW916NCprFPZ6eaN7aMezsxZaPdDHU2j9q19xHZngeKYPFl15L+
	LfocFzG1BcFzc/Pzq6OXPL505L55J1uNAGFVLxr3fJQNm8M7LhNWHbcwoFfVZlODIUNVIV
	TN060sv8cE9pW8kU5ln1D3f3fzZ7100=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LQiLs0wm;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785087586;
	b=ip6PguUKMJeJ3QTs9InTMnwokOU+3FzP67oXIhxl5BA+9lyb4dsRujYQ1fLktt9yOOdGRS
	6IBoFdpalcztcawWYh2NWh1B2bkMMuVIuBdt8KVzfyz59/7Ez6OAWJgpVVJGj1XXzX4Aw1
	Lq0/gzstv4hDvwjiR2my83A0Ub3RWG0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E32414389D;
	Sun, 26 Jul 2026 17:39:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 459DC1F00A3D;
	Sun, 26 Jul 2026 17:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785087585;
	bh=Qlh6y9Au18vR1Ou/T5ICe3OGlXl5Nc84fCTR2Y+rZXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LQiLs0wmIOlexd/iMGo03bhcgs5alZs9lgcjLpw0/DXSeCRntJkZlkj/Tt3EaCYcl
	 mXwfhQOsZHWXZIK+KMLuMgXobtj3xSAVUr3ovN6Efp1lGnT0Az1vLCd0zXPsNhVo37
	 Y9W8wcj75jQ+Tle4Ktq5n7P2kv6NymVARmBiiIcw6dY8sJRGXzyKr4oqtmOq+WXdYv
	 MNqMkpqhaDCAgIOU1f7OAFLUOzeOiNPG8P6PU9G3KFiMf5d64TJEpv2BAQXuUNDby7
	 IO2pMSPwKiyspJINKE9EGrjbo9excDbHMEgRzFqioUuC5lrtF9vh3Eukw0aZysfO3o
	 eapDe+XNU7rJA==
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
Subject: [RFC PATCH v2 04/17] Docs/mm/damon/design: document pgidle_unset probe filter type
Date: Sun, 26 Jul 2026 10:39:20 -0700
Message-ID: <20260726173935.94046-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260726173935.94046-1-sj@kernel.org>
References: <20260726173935.94046-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 94DE04000D
X-Rspamd-Server: rspam01
X-Stat-Signature: pznqxnuh4i9hijj8kt5rhq4nuhm6jzn8
X-HE-Tag: 1785087586-971058
X-HE-Meta: U2FsdGVkX1+JviOXtQ3oEgowHvt+S4ayPK+aDMxO15Xs9oe+ja3281w5DdeWsbxlMHKrmC0P0PMd2aqU5ONM3o4Ks3lVkNyPK9ODYWRbCZ9GxJHQkhdoxYJ8kOIWNFBmg3k35kmaygowZbo4G/0yW+a++92o5xWb9m3UbriSb619mN8v2mBDpZguHVgsp/8E8oKECA5MOkvvAPw8/7xeoXu0CbXLynRbozxYaFEsmmtohvoPT7FqgEGMg27lVG7MmgthuOXnR6HtQlIG2RuFkXatVby7JwFr1TCUT/8Ij91tSgvSzYbu7iPPecEuyZfiuKmbVMeaCXlBRK7eiSYPDVWpMpDNoB1sVdotCk6C4T31nSBCEM23tEPHbB6TO+1mKAvUfbnW4Hq1wXHHi5hly/UhNVFaPzmeiNsY7kldKDLpgW5YhqKWXIu9Yc+HaeCBCmdIeBgfY8Uz5sX0Kj0mQ0VeiIGBlxD3rgzfW7swzlTnNQ1STW+DnQ5lh+LdhagEbBcQWSu26UdRvYOp3pO7YV3WFvf4k6/TKKjlIwOa7eny8EPyH+ESEUqWHEU8jNptQSXCaiaR5sJFBCl/XlETlJjLqeHtd4CrIhiudLKq7j4p461p8cvZljskYqubHo9OHYZ/+vqKZsYnQe+faw1p3DImx6Cl40iWbBS29oPCZmWpTnX/sfTMLYh3686nTeVXqj+T4LeeZYx7tnYQNoaAJwh+yGuSn4jb2cmz+0PYYpDbFHG9GmoPExtMvrfde4Hx1Qj4oghcL7NwnqlSg/EcvYFabBndJInoLWm60ctb5Q2HoP8X4DkXh2h1ruesYYvS+pdZQct/fcoJbrSvxHL7mnWBu01sw32ooBuYKnNN8ZmNv8/eAc3/5N4rwzfa7GEv9J/Ge1I3IzG9/8Lh3u8TvtvU4Z49lxBbdzurezMX9vC+QxioAuXwGP0IUQhjROeYYFIyQltlM3GXZ+z/1vK
 CZBRt8pO
 f6EuNnh4uYt8zdqYsJ2X5l/d3G8rXDJcOd9gdtYwAYpCdFdH0CF4aPl9OaTWiyY8oNk30bvftkhN2BzB8eAzJh/Cn/Sg1SxxkOAGNEQ5lriLvxw6/AbMR+jOJFdU1BIGr392b177yW+MACrUEO87pVpuulg0oqwbkUiVFTYsdcF5Z8cskRbdHfwi8pxZRS+3Fk8vfAJkIeB/wzI3lMQVSlI5zLSwYezMhKUYoCjglQ94wCTf2kefVtZH9rclQENNnOa8+JmQRb6bzpeTG6vA7c7gkLKV6ADlmBKi3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the newly added pgidle_unset probe
filter type.  Also use a list for the types, as it becomes not very easy
to read the whole types in a simple sentence.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index a8c163475ef2b..c4830bd09498d 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -293,8 +293,12 @@ registration is made by specifying a probe per attribute.  Each of the probe
 specifies a rule to determine if a given memory region has the related
 attribute.  The rule is constructed with multiple filters.  The filters work
 same to :ref:`DAMOS filters <damon_design_damos_filters>` except the supported
-filter types.  Currently only ``anon`` and ``memcg`` filter types are supported
-for data attributes monitoring.
+filter types.  Currently below filter types are supported.
+
+- ``anon``: Same to that for DAMOS filters.
+- ``memcg``: Same to that for DAMOS filters.
+- ``pgidle_unset``: Matches if the page for the memory is marked as not
+  access-idle.
 
 If such probes are registered, DAMON executes the probes for each region's
 sampling memory when it does the access :ref:`sampling
-- 
2.47.3

