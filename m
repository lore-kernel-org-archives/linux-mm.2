Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92781C79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 17:12:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C3236B009F; Mon,  7 Sep 2026 13:12:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 699456B00A0; Mon,  7 Sep 2026 13:12:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B01B6B00A1; Mon,  7 Sep 2026 13:12:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D93D6B00A0
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:12:31 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BCE42140277
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:12:30 +0000 (UTC)
X-FDA: 85187610060.30.3003E24
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 378A2180004
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:12:29 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XS7xqzm1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788801149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0/q3LnB7iB4S2lxLwjnJON3GEVnAZWX6/MrZWM0ze7E=;
	b=WDpnUyG2iU8ebhHJnseiDsJHiWqWCB6DmfTrruKXEYDGyou+4sbOahLvrUW1AHpxFNouCv
	Rd0Qs8LcK9KUU1I+xaXfFCY7BO8WiMEo4YdvAZYhknMLl3B9lTDwKZPV67u1jgMfkIVRoF
	YeQE4naziGNFw7qyZc3ALJps6jhv8r0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788801149;
	b=vDu2cO0CsLOswdV8fTcK/Wa/oxhtAzzIO7CWezcE8AqmM2UCjJRaUvIJTcmYqBK/ki20o+
	BiXqYIHy/oLqURNY//WWTA9pgs93NcAFT1gFyyN4qQ40HFPzmy0NdE0KT8hjfZParCdX0t
	SK2FN3CXtwBa1s9NlsoA7uGnDD5wvHU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XS7xqzm1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CE8D1601DE;
	Mon,  7 Sep 2026 17:12:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05F901F00ADB;
	Mon,  7 Sep 2026 17:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788801148;
	bh=0/q3LnB7iB4S2lxLwjnJON3GEVnAZWX6/MrZWM0ze7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XS7xqzm1n6WT4wl9MW3ztP1LJNt4ko47Pwim0W0AhcLyEBxRB5U14yBncpwnSR+sw
	 Vw99DOU+BGaZwg3iMoQtmZIgcseZ135BF+6JS7qKI7qDaOcLtJgStVt/+EACZ1wTPl
	 uWPZL8fdD244JTPR1hEynpbM8jvUl1oixww4dqvgkwfrACUCrEoajcfwdhCMnJs23h
	 8DxmjX0GiuLwZYsNyYlqgVDLtQ/SRUIxvX8EUhgBrfMHBS/6/ccISKi/ksPUIgcAPz
	 nU/4YN2h6u+R8QWZaxHilbajYQu6MynQtbMuXfPiSTI6XqTlR0F8CYsfwsl6vp5CGy
	 dWilWD2DPpEPQ==
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
Subject: [RFC PATCH v2 7/7] Docs/admin-guide/mm/damon/usage: update for probe_hits_wsum DAMOS filter
Date: Mon,  7 Sep 2026 10:12:16 -0700
Message-ID: <20260907171218.101430-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260907171218.101430-1-sj@kernel.org>
References: <20260907171218.101430-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 378A2180004
X-Stat-Signature: pbda1chi1t36cjtkytrtuw147cyzsxsn
X-Rspam-User: 
X-HE-Tag: 1788801149-640510
X-HE-Meta: U2FsdGVkX1/Ng62ChkiKL3SfQJtUHixeWCYM5Y/wFjTnumMxoeZUJ1MdsJlasym5gMh5+Q+OuXDeBOUtOz9PJBZz+cdy7J62tuBBHWRs+swCHvmYGa60QGLu0qrkm6j9t7cf9c/mfjUkwnpe7DydyLhb9aZ0tyrVEn09ilLiKGoxvCUbdFF67Xy3Dzsr19R/APe2yZwEc0HkPZJk1KaJ/MH2GDAvt003DYQlw2qAZ+tTWC/B4F8f92/f8ID9kj1yrJ6YWWmhr+eLM+FMizfhrsfpC7KR5QJn+kzcMvBxCNofXK/ug3Hq/hmR/V4vUTbeyw0ELalI244WglHtTi7ywHqIxyp27fQbzTXsSCsGsQj0HuAvNT4q+IkG5gn/k/zK/VnsWs9NU3+MXHaiUrnviu4ag4dhB4eAlwfpLDqcLwsWW8AiM/A3OVpILsRJ/32ixFO5DvNfu7bpnOHG6P/6q0XxBUmfLlOaG5WPg96p033tzdQhs//L9ZJbCOMndgWnlTlFwZvu530VNaJ2/2eDS4xncq6ol4/CecTtx1gsl645DECThHqCq3RocwHIXTyHVG9LOYOaIcJ51H7tKlWv+CQ2X0AEo3E0Eu5QEX8XOmHzBwAStr9a5ydwazyxKbAiCBXKcygV56N2STKYLABaFJn/VuPezceBEk1AozdJytTvL3nX/HOMviyQOy7LrOcC7aqXK3ljwQzGLSGtOSGyzACq6nonqHueC2b+PlJ9XZ+fqQvgPB4PvNm/TTkj2q2kdLmLAqxTZoGNzVX0MOs9Qt8chHEetoGzgdy/iPs+nEJ9DuZthiaJ2k4q/bzaEN+jABQ9cZB8CX4qguo/VpkdlVBHe8gGb5Su0UM6PvTT/GLwXExVYRcR0aLLFeEnWboA9ZNepaEfJZwawoRk9UvMR1Mt0+7ppIKf26eI/X2Wg2LWFT+3w/L/RT0uBCIFbGCXMPxH7loV8LHVKZ1NnqS
 Ps80WWeg
 vQPTwo6O8vNopdWM+C7DtehSECtMavh75wrhIvdqWiRB8nLwMYtrt0RwuVsLEclBk78aW77TTl15TC/bikV9iuNHRDJ5uDEt7yBaJFk/u5t1bnEJSwqC41CIrwOUQTYESIthFEKRnbCqRMAqmkWzpDj0j5xE+cjqqqjQfsZE6oieGCO7ww5ryUVOu4Slz//M9It1cIC8iyOcZpwCn0QXQuShuzjF72NgFbwL3mOPgR2R6oHsqaqrjyiawZaaszI2+fQLX149tA2DoV0RjLbc2OpyreQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON usage document for the newly added probe hits weighted sum
based DAMOS core filter type.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index 023c6334024f8..d3e37400367bd 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -551,6 +551,10 @@ and ``damon_target_idx``.  To ``type`` file, you can write the type of the
 filter.  Refer to :ref:`the design doc <damon_design_damos_filters>` for
 available type names, their meaning and on what layer those are handled.
 
+For ``probe_hits_wsum`` type, you can specify the minimum and maximum probe
+hits weighted sum value for the filter to ``min`` and ``max`` files,
+respectively.
+
 For ``memcg`` type, you can specify the memory cgroup of the interest by
 writing the path of the memory cgroup from the cgroups mount point to
 ``memcg_path`` file.  For ``addr`` type, you can specify the start and end
-- 
2.47.3

