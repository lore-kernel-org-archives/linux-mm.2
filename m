Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20856C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 04:09:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D43606B00A9; Thu, 10 Sep 2026 00:09:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCCC86B00AA; Thu, 10 Sep 2026 00:09:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B461C6B00AB; Thu, 10 Sep 2026 00:09:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8169D6B00A9
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 00:09:29 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 91C74A0416
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:09:28 +0000 (UTC)
X-FDA: 85196523216.25.E976EB7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 15AAFA0004
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:09:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T74ZWSkN;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789013367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YGHkp73SOXJ8OAqpC14uJPbey8Nk7EBIVu4GrdElavM=;
	b=pqbsg7q5oTMxDc73Xkmz+ZV9wfi0OSY7OARqI4s/4or8HiyHpVMmB/m4bQiVNJUtPwluTJ
	djwwJ0SYzTo2A2QoXuibZOXUOTj2YoAEcPUTi0pmOei0lTRnlID4pioQZp0UH4x7wKE4Ya
	6Wne0dzMqPQ1fWfXItQIuSG+5zi7fSE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T74ZWSkN;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789013367;
	b=ixBu4bxAYydujxb+YQlog9WZlSdTPlz32Ixkhb2Y62v9Lxh7LVtOz+CKeSSYwnu9m65HlL
	ZJkerdq5SDyWJ2Jcxw705iPFJAHNOpH7w2Votj8XrbzsVWskCShm4IT5f/NKbjZoaTXHL5
	P00E69ZXBkORz9LpKv3ZH8/F9ESuhho=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A97F26020A;
	Thu, 10 Sep 2026 04:09:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4FBE1F0089C;
	Thu, 10 Sep 2026 04:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789013366;
	bh=YGHkp73SOXJ8OAqpC14uJPbey8Nk7EBIVu4GrdElavM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T74ZWSkNJGxb/rEDsWUcATa7kBm3vaR5wctOIL0VkTCuMzG16cfJTs5879VEQn+ry
	 Gexsnph5pgy0D5tA9g/+AWNddDRx0k6La+DONOFFhLcLewMicFWyY08zSHoam3zdZr
	 +f/ueO8e9g5vyDBc0zLdkgXIUCTUF9tJXZribfU92tzdbadOOWYcUBp50cPgBQHfM1
	 aKqh7KoES3Sa7JffhYavHuq2moVktpmDiYh3bY8GLWptRahRwmExGp+fhrzGC7qimu
	 KAIbuDFVP7URM3U20yG/hQMoL3X+LOaGqelYhrpLCqNJ5xsYoq5LZW0WQbXUcuGGdM
	 cHoXLVGRS5ucw==
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
Subject: [RFC PATCH v1.1 5/5] Docs/mm/damon/design: update for pgidle_set probe filter
Date: Wed,  9 Sep 2026 21:09:07 -0700
Message-ID: <20260910040911.148273-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260910040911.148273-1-sj@kernel.org>
References: <20260910040911.148273-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 15AAFA0004
X-Stat-Signature: 4zprs5mzci19dzwweb13c37d9dwyonwu
X-Rspam-User: 
X-HE-Tag: 1789013366-888669
X-HE-Meta: U2FsdGVkX1+t71vhWuK4SubiLEnM1qTXfD8AHLu4YrkVkti3FpfkdxhNAKYYWFKEHn9QYyQmezVTsI6aKKSXDOu0PPCcNI/5hRIRwva/VeWgy1DhCxRbsbFjwKQ26EzwhjvrFuvBTHCp/jZc9AxyMLDpgxkeIN6YTTyZr9hucJ+svS59iqQ93aBxHwyA7At2PaKCidZFksJVVypDly+7BQT/DysSlB5WQou3bcaBK4NA9jBUdVAMmL3GrxybyBqZQNE8IdYqRnX5wJS5I5nYxvCLW9MgqnKBVUrLJdQWDPBFxrv2kxof9lbEsHqXWbrImVLKJyxRqxXFdP0W4DWVBoSeESSF/d/x9AZk3NCJ+ZjlDAUG0fSUngrS14cF+zHKR6za6WdS4u/ZfanIDVtvyRUtmWUSnA4/oiNg1PAqXoRI45XOa+JPt73UfbXW8ZlwxEcr3UiKkm7ixYfRK2ijtrgccwPGQ9I61hoBgzzJdEVjQluKgZxKl+on/qMO59QT0FK9AfwLbDo80GSruTQYtItqaysR0YtZQiv66CK+p6OhJ9egw6d4QmAmPA/1Y3nfS2HJTbwp1EkwJJTQUfOkGH/4PD9L8ES35Cko2ucuQrYr4OQYoHC39F9PWnOXnsTlCkkWIgHpoGrGOUtkVyJVVRqnrShCLaRHGEdmBitWfwB1K/kAra8TXbytgnrqSEA5kQ1bN3mTL0XZ0Kg6OZkfexZJFg6K9qwy413GxlHxSSjDkIsLrMXZ89aXOYeWynRgU2JrHJJycwC96E/GWJ2QfS+7Ufv1hI1IefeCIQWaiihJlga5nRVKRT96nYORBSeo3hOMfGWC7oBbdgC1VZci6yqS4eVm3aDVVhTN7pQ7PLb5gDoDEaEIIJzDmwR/8pcXdXIwp5elR3D45JXYEoNg3FWq+jbxABmj8wVySW0qiw2NKGmRh15Ki+WCPG+AzSdnDuyDObTJ0hqEovMKPBy
 Bb+DhHyH
 hT2+h1VFHeqfIWvFfMzDXWx4jBbrk7l7R0pqD0nyhXG8VWnbySVBMLDN0wIEzPANhWabgIqbI+VGxrN92KT0LITCryKtaIEMeBGEa34V4KdMqJa3dSac28eDZjasXloq2tKlnsYDQMmqwtrJ5o/907/uvg1YAKaY7anIs3/TVnQFZ+TudAZteyVvGM3MAawzUJzIQrvJ8jRivt3nAzGJ38a8jN1jbjPzT8aNegYbHKJxBTexrCvOvFkK0MQCyCVL8z3nyQNfDHZaMuNKnY0xr2Votlg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the newly added pgidle_set probe filter
type.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 8e980dde362de..cb116a82ff20b 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -299,6 +299,7 @@ filter types.  Currently below filter types are supported.
 - ``memcg``: Same to that for DAMOS filters.
 - ``pgidle_unset``: Matches if the page for the memory is marked as not
   access-idle.
+- ``pgidle_set``: Matches if the page for the memory is marked as access-idle.
 
 If such probes are registered, DAMON executes the probes for each region's
 sampling memory when it does the access :ref:`sampling
@@ -314,7 +315,7 @@ actions are registered, DAMON applies the actions to each region's sampling
 memory before starting the next sampling interval.  Currently only one action,
 ``set_pgidle`` is supported.  The action marks the page for the probing target
 memory as access-idle.  This can be useful to be used together with
-``pgidle_unset`` probe filter.
+``pgidle_unset`` or ``pgidle_set`` probe filter.
 
 This is a sampling based mechanism.  Hence, it is lightweight but the output
 may include some measurement errors.  The output should be used with good
-- 
2.47.3

