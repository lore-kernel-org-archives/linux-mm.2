Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26849CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 16:25:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E0888E000B; Tue,  2 Sep 2025 12:25:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B8C18E0003; Tue,  2 Sep 2025 12:25:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F4CC8E000B; Tue,  2 Sep 2025 12:25:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4A0DF8E0003
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:25:50 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E5B2013A342
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 16:25:49 +0000 (UTC)
X-FDA: 83844836418.29.E805844
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 42A2AA0011
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 16:25:48 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iRITIK3T;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756830348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=SUik/jyyQ1k9liiWuKi+y+woyh+KAPCpYTGPEAo73+c=;
	b=PtW2g0r4iDXBF6/gG6U+3SVq9qy13XhvplG+i9XXzJ4KWmJDn87TdsXI3zAST8ptNOtxBl
	lZ7ZTmjNZcPYxA1MdhKCEZ6S0eVZJMUv/B27zGWnR4hpwnZ1G/Bn8a4cQzGvcOkKnoNgod
	s8AdzqoDVyW/VZJ8zWc3oPJ8R68yHy8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iRITIK3T;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756830348; a=rsa-sha256;
	cv=none;
	b=LAf49RNZM3PQXbJB0+VM1cLcu7cCWsuBWOjEvhTxdZDCnRMOzj2HcX6TVdixTeh3Xraa/B
	JxK/U+egMSGvoBC+trflr88rjw59h6FGrTXQcz5h2noJq2AUXTXre2T+AD1jaSnTdhG6zN
	fvVJ3iw4FG649yjmpicBUK85r7L0+lc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756830347;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=SUik/jyyQ1k9liiWuKi+y+woyh+KAPCpYTGPEAo73+c=;
	b=iRITIK3TB2PGGcM9bk6PNrl77mVOgIhg4Ok8FO7eJLzsiIGOXIqUZs7IvDK0zVP79nFE+v
	zY6VH8W1Wz9ZZ8PGsSA2rL7c+9Il8gwzSQQIXnkQROXQaHnm5tjHjBthccEflRGYnO1p28
	vJxdX2Rp/4QXS1e/sXHfyjLalKoxSWA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-349-tMtwTW8sMByXxpPUBno_fg-1; Tue,
 02 Sep 2025 12:25:45 -0400
X-MC-Unique: tMtwTW8sMByXxpPUBno_fg-1
X-Mimecast-MFC-AGG-ID: tMtwTW8sMByXxpPUBno_fg_1756830343
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 293A518003FC;
	Tue,  2 Sep 2025 16:25:43 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.22.80.27])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AE9FC300019F;
	Tue,  2 Sep 2025 16:25:37 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [PATCH v2 0/2] selftests/mm: split_huge_page_test: split_pte_mapped_thp improvements
Date: Tue,  2 Sep 2025 18:25:34 +0200
Message-ID: <20250902162536.956465-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 42A2AA0011
X-Stat-Signature: rucbtgu74oznft3156ihk7htanu1ccnc
X-Rspam-User: 
X-HE-Tag: 1756830348-44965
X-HE-Meta: U2FsdGVkX1+zXB9GRbgeUL7QA02P3UyGY+TGZFc2zGAl6p5dOgPIcGM9he5vcFTtR2e2ipTTTLRtRDhlCKbmDezSF8uOnOywOLnoFdk8htx0oZoI+MwNHqYDUS7+XP+Wag23Az57EfhG21RZr9HTYIhKPvogRveHcwjKLU5Ihxbn/qOrUuGchldaQ0kF77gOzuK8Ynmd1USfKaMqpY4eokHsuq2Jmq3GdFJmKgH/PYnMNKT42usT3KLpkVFlJC5CgaQAJRor8HPWMYqqksIxI9xw6BeGDILyWs+3JYqN5Fg8T0Q2ujCY2igScIQok43igrWOup2sCROPU0Thdtc6qF7JDgSpuZ0FPq4uV8sADnTKYwnocB9ErpoeT0eHOnwBlwlBO/KsZEHsP3mcPEcdxs+s4DeufNvJTjax+Kz96veot4mtqZk3jrj/mWglvC5Jz4FVakd2kWOB1y2vK7EmweuPn4YbEPa1FxSVkVI7DBUvpCiYymS54AePAFMgTDu8OTsMsIuMguESjVdhghKfEfVNTIzQIDiGP8uskniG48RpQavIn77jt7JPocDM3FXU2Cf7gH75bSfAEd/zH1zzN91yyOjq5YH9ssovTXZdbd+N9HRVZoqz6+R+Cf/gcxS6sgo2tUYS44KsTYIDwB5OeiH+1omvvySw3wSuxHvCf4gIT8cz0pNoO9vPRVTcpBwM+LwEJkt+F46crTl85heVQieMXdiuFrfvc84So5puQ4LwOrpJeIvFWhlRqGM+eZj1bt+G8Jlm0RWxbWt0yhr/NOAuX8lNVv7ScNM8WwQoLO+V2ZgxqiX9WxpBvpmaSFbgGM3oifXvWLlD4565Xl4U7seWlwMmyD+kdaloIEE4UjGaB2fSkq2VVZohPP4pyiSFArfjhD6LLMBC+HgSfxd2HwvqGydHtsH14TbvG8n1l5QMvgVkDZqemGjPfrKey06Esx1pW4y2NxPiCVVC0EB
 U0XGYlng
 5TKfYKpoxeAjpH33G0JPe4naadzOFtGQThIE1kHwx/j29S0Q8XEbGYcW4tB6k9948G4BMH9vPWWkblYjeCjWEG4KkwOd8EKZCMEowF7p+Hpq7RcjPH+MeOPV08Wt8C+KSp+tpdRyRXclabj1WkDzVmgsfBKpyymD6zyg24yTcJ5CBsL2ilEFhuNSEsD+Kg8AfHfmGc1ZC+7LLWfyzX5Coi083QUcwTxIrqNZAodA9oR+IDicit10GMFotbit7YFIPCLglLOsTQxYB9K/YAJMmxBNqu+uXhLfHnsOxGHNGeEh1MeBDHywOSN3U5+A1Q+pf3b5qw10f4fJnaG0tyUt68b8YUI/jWj6e/PDaoFuRjrzg0iDbNiIa0Hx7P9YrsRQyrzL9gIWFm/jqEFF2s6fAUgioyMRIDHcACYX8r2yLI+fwIU4Y5L/89Rb0FL9DNogKX/VBN+nafM4bGQ6YCdqbt7yunWhoi8Htr5VFXLBCcWKk1gc4bw0Bewa9zIBTXFzwHW5stNO5vTeoFoP7exgmuue+hQyEHjIG4KSzRh1rwR75ajE4x7lt3QZnkkR8butbVEjeJVzoGNfvnFs3Y6688ykByboLpp/gkjA5J9tEIIhvA0ZE+nsHc3+yXU/5vWWOopYNko2tf7HSbM5f3FsKkLHVRCCxt5ASI5jlgjQLjEyNMA10BRyiRXm+VQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

One fix for occasional failures I found while testing and a bunch of
cleanups that should make that test easier to digest.

Tested on x86-64, the test seems to reliably pass.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>

David Hildenbrand (2):
  selftests/mm: split_huge_page_test: fix occasional
    is_backed_by_folio() wrong results
  selftests/mm: split_huge_page_test: cleanups for split_pte_mapped_thp
    test

 .../selftests/mm/split_huge_page_test.c       | 138 ++++++++++--------
 1 file changed, 81 insertions(+), 57 deletions(-)


base-commit: b73c6f2b5712809f5f386780ac46d1d78c31b2e6
-- 
2.50.1


