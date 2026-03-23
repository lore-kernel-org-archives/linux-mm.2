Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE267F4613F
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 23:15:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CD4D6B0093; Mon, 23 Mar 2026 19:15:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97C3A6B008C; Mon, 23 Mar 2026 19:15:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7815E6B0095; Mon, 23 Mar 2026 19:15:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 492D76B008C
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:15:46 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 02A2F5CECD
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:15:45 +0000 (UTC)
X-FDA: 84578887092.14.A60549E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 52282180006
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:15:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jtcnUefe;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774307744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gIFJcc/U/FGZ+jTSwAe0YId8k5d0mbeypzHr/bajX3E=;
	b=C3zuu7W+8ASgL+S9I4OO1StpMQbPrcSgmWMQg3Sm9xvKAnP0/PsAmqTwGyEWvlPTrJKtvy
	NG8tJuFISjspYE41gTku6xwI3lSEnLVpDQgUqel7eV3WypLB0dCg9fnIo220g/e0VdTxwJ
	uOZWr+9KmRhcPTwFJEtgU9SbD6jJaPI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774307744; a=rsa-sha256;
	cv=none;
	b=eIjL/jZM2Y9PTlukdNeSuv0xaNhxyaqnh6eePVZqQupNPc9ZprUZReZoo4W06PTzuC3G7A
	ZU0uU/l+8848s6or1WMg8txGSoJi42rFmqERGyQjGb7OJXs2eQQ8oGPMUpkU85HsV33AJA
	F59cQcev0HvrqrnD1aOTOQc7HdZJ1Dg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jtcnUefe;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7F46844507;
	Mon, 23 Mar 2026 23:15:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2382BC2BCB0;
	Mon, 23 Mar 2026 23:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774307743;
	bh=qt20gza/ZGfZPnGlsbY2CkGg3eBlVlFouLw/z7b3qI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jtcnUefe5isd+iu1bOQ8wFtyEdgurzuxLAhYdpRs7TdAXyBqAPivTn0clXdqmucRZ
	 MvbCxhKza0TRTEGnE7WI+M0r72G7TTpQEsbRPOuUYNaNvekbEm2SBySi/GxC2hFOyV
	 pMinKZjeUOem+ULSSRrIbEYe8FFhQbnHbfmCdAd3QolLxeiRU0j4AJ2H0DWIAoD6+S
	 OcSsllTbBXwd44+SacwVNMwNBKmVhX3f3U9/JZKSrJdYJY669gXsTBMbno9kgOC3xm
	 3sksolXHcg79ASGnhVk6ONDh8394Vn/Rkcn5klWaZVnDBfI8DsysfRoFAlD81bys8p
	 oSQllZsjRUh/Q==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
Subject: [RFC PATCH v5 03/10] Docs/mm/damon/design: update for context pause/resume feature
Date: Mon, 23 Mar 2026 16:15:28 -0700
Message-ID: <20260323231538.84452-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260323231538.84452-1-sj@kernel.org>
References: <20260323231538.84452-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 52282180006
X-Stat-Signature: otd5k6k3pxqbywcajw3zftmrqpxi7gmy
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774307744-958378
X-HE-Meta: U2FsdGVkX19ZMQqKdsrR98zjdSKPOeD3fCT3DjAIxQ6+qZTN8EgwlOjFF9rsuuG0EzbpXHfbroJixZFWoED1zGXFQPk2AOqK5RH/Q4HO4vqqXFUHrKg6PDgQuhmrlSyZ8IMDYq8V7KgavzLJ7XW+KwbgEHVW6igTs2TzR0HoTube/6UCHR5brIBsMhURN1IQD32iYq0gb/yzloeu8dF3Z0Pl7CKIW80fi5y+5nrftJu6JTT+MgET7wSsXbQl+wtix0aYp+S0RCK/njSWtzeZoSCuUdFexvqFJ2YS6PfTUykWSNX2LtwZ93j4HRfwD5Sb1NyEEmosJFpKk36BEhWhz2JmLKxA+quHDUVHErWF7VfkBm1PC61AZdzzUFwoQDsToT5B+Rc0EzBpO+AWMbRxF06uVPGzp6z95h3d0GQrqcg6MeiK6AswfwFnV6cx6KivKKOZn/70vuh9w6MvJifB4Tqjrdrh+6cEDz8U8rhLlaA+adGnWQiryljw2GFRa8+IMHfM89EsdzS92fzIm+/0V6CvwUNB8vXf6eI39oKnw3UPEpq12SoRIIv4f7M+KPEE3OEmmQp3yO5N17tTL/f48SwqsnSYw1P6YM6+k8OUkU7pMdgPe1qFER/wtGOJS+pv2cZPhL+rpPqczhtKMfmwA3RZ+7TLHFsw57tTcc6pxL/0bpNuwTAOzbkPOTS2UHVAGCM6R9RPU1t8AIJwo9SCEFAyYmuMvx5XFKd+stHT19c3oRyt0rDEhQk8FBfzlfpyu9B+vvj3LeIwrm9tyX0DFP4fVVTistwiQCAlziP+Pr3OUofKvJObDS40IgJjbuoC2KbHdUdRwiB/i3Zt5ULAuzCsGAl6BI2HOcJnj6IZTndWuLNEpwL3rSmhDW2bKiTN97K6F5j0pJhuZpd8FTDhzJb6Pfs+Ovj5tfZwNv+a0a3ehm2qt6nZuWnXNYL90aCm4MY3sJxVW4ztc/cHM4M
 5NG512AP
 XcQfcDyKyDO5mC+DTjVVV2w2BCGAJ8Ei7SnX8Q9pOHpE0S5O9iXNHuolAHbYgXsKBcQvUmYudp35drxD8eYOkY/aRSi9OMrCH4ayAODyPrwAtLJ27iS/aqNJzzfPUEZJZH+oZ10epuRC9FBxwLcwJ1vMUGF66wRP7FpX/WHs5QPCKAYiF51pP3ofrezt7BbgBGp6bdltldIIqDMwk8l1KYOIsPC5Ukejs2gOPQCl3CZ2+pJQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the context execution pause/resume
feature.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index afc7d52bda2f7..510ec6375178d 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -19,6 +19,13 @@ types of monitoring.
 To know how user-space can do the configurations and start/stop DAMON, refer to
 :ref:`DAMON sysfs interface <sysfs_interface>` documentation.
 
+Users can also request each context execution to be paused and resumed.  When
+it is paused, the kdamond does nothing other than applying online parameter
+update.
+
+To know how user-space can pause/resume each context, refer to :ref:`DAMON
+sysfs context <sysfs_context>` usage documentation.
+
 
 Overall Architecture
 ====================
-- 
2.47.3

