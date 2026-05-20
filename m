Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DE90CD4F5B
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 01:21:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57DA46B0005; Tue, 19 May 2026 21:21:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52E726B0088; Tue, 19 May 2026 21:21:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 444166B008A; Tue, 19 May 2026 21:21:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 32FF46B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 21:21:25 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BCBD0140320
	for <linux-mm@kvack.org>; Wed, 20 May 2026 01:21:24 +0000 (UTC)
X-FDA: 84786045288.19.2705834
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 470741C0003
	for <linux-mm@kvack.org>; Wed, 20 May 2026 01:21:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OPdBqzaN;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779240083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=EaKGk24Z7ZdkbvdHfuSkBUwjfEj8QPAEB7faP87DITc=;
	b=4Jt5JxrtPm6rgiwnu3iteVty1jkYl9WoP1rvTAobnEOmArvufKRuFlxbuAUW2oxdiDc3Rc
	5IFAuS1NX9HvJaTaYynD1ii00p0dIpaJFzB/ZHuvw/mABwtVOcdYUIaKRVLqEZYYs65NAc
	kwD+90hxQdNM5/fyl9EQM2QqeUgG+xU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OPdBqzaN;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779240083; a=rsa-sha256;
	cv=none;
	b=E+ngoGSQDpY8k/k4Jqt3tnv0FkjrhhuTRDc9XTghE5w2gjeJBD+2eaDZhhrdnnIZhXINeq
	JGa/fHvn0j5GVxnS4qhTLosftgR3o5Pq5W0gqnXsNiFLQcdSw7W+4YJGEptMFJnCvhCfMl
	SqlF/gQhwZkKaM+OhirMwBDI/mho9jI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 93B506022F;
	Wed, 20 May 2026 01:21:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6674E1F000E9;
	Wed, 20 May 2026 01:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779240082;
	bh=EaKGk24Z7ZdkbvdHfuSkBUwjfEj8QPAEB7faP87DITc=;
	h=From:To:Cc:Subject:Date;
	b=OPdBqzaNraSbHm9bHtnmYlCyua6gaP78FWQB/jYLt5UA5oEwoNjr4Ze0hoJ6FMAPg
	 F7CWhLtw+LVi2UyvJpB2eM/DaTLzxySQ4JQw0aOYMiI8qLYlfLQZR8A7yTi+J7UU3J
	 xEvF7Djp4M5j9atLHOjkIpZKfUmgqHiHFDNLr0SWhFkGbnOSYJx84AQ7+/9geK1xGh
	 rlJlvHnIUpK+awIuLGEHgoAIcRgDKh2iOIYTJnigCohyHR3JldYysi8BTeRatht1t3
	 1l79YWLcZZCb2rFJxgNGRJbVfs9Kg2HbJwFLFj94Ws8aH6e3wL2IPtL4xhBZ27LBon
	 T1BkOfzppwQeA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
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
Subject: [PATCH RESEND 0/3] mm/damon: reposting three reviewed patches
Date: Tue, 19 May 2026 18:20:58 -0700
Message-ID: <20260520012104.93602-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xrsffyi9dyhn9yjf1udtuxnicy4n4t6r
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 470741C0003
X-Rspam-User: 
X-HE-Tag: 1779240083-179249
X-HE-Meta: U2FsdGVkX190F/7/NhccjxqM4qxeLJbJ+NAC/f9Cc3/785bRihMTDfv6xw2QzATFXoZYPPFplIYzhmjJjcp6jfa1kTJBzgQy4GGl/w6h76+4gbevsjBw4YaE65DqD99oXpp4dXsI4Ybs6UB0379ACp5k16ro7n008uhZgjLyD64elHO1mSBeOePCPSsbCK5x0em6MVAd/A/y9AD/4jpzGDNB8BUzfM/K65SJbsU4J5VmL+rSN21Y94nOy5u2OT+kRc8kRAXjNfcFknuh6me/Mw4ku8OKB1IpJAFfU+COJGMuWgVlaz5ny6rGAI7YEMvve8FbMy7nCuYTkW3m85vEtdtdhU1VHl4JfjSa2vMSVNVa34ZZC6ojcmKuwo75UoBq9leEPnZNvkg/P7T6nQbVfUrFnhaC0tddW91ELMmLidbN110mjNBf7eOiBYcHhHoHvj+yZibgctUkHzD4NSPSMxVsPtaQBX5nvlGZC1V9jgTR8y/M+iff6XV4DcO2InHkmQKdP4e36KiXeYT9rE0Cvp5bj9INMoxaMihMJ7zhKoWOWEZDdw55AToljqT3ngkSAw9j1/SPDRfKNnRcUlVBXzoXbwSeKun37GJaevDdY1eLWsMgTgxbLYDx/TAGmJSqejC2As6NaUcKEU6XPCTTQLHqMwmEcHXRiduJiG32YTY2bmtgm02lFfArLTOdcHxyrnR755gS21dTN/515JPHCeGFfRa/3rrz3xNoEgmylArmExoJFcNkIzRWfTN3xGGW+yITlEb8SiiorXiSWAYCBN4kEnKhzzw64/O3fWiFbwlMJEugvfB7VWiGlcDOqXq/M9RXPqaJx/BmT97LCweLOo25iSxQSkoUPMFgL1DXsU0b3kHcDtsZMNUHW5mnIK+0E1Wi8GeiAOdG+oSvGnrbo7XWc9xgOVJ9Jd1Yzw1yFdDIYebMBXV7YlPQ8p9nOB50V9NM7v4K90AD6qMJaj5
 /Z8Sqdjc
 s98mXsZjsQbnzcFQuMiHMnGDWa+wTVd/y7fYUtoU2uD6Rmz9NMsxM0arZ3EDnBtz3S6a3W1q8HkoY+99UrT7sKtRxGUq8rcYju6IaJRLAp75OO7IckSzRk1FKldAJ4a7P5xLoHdY17SYthqtAmDJEWqW+9NZysqQGIaqKtZig3DiI8Xse/77dQ45JN3C61vf6ZNz+ahstoN3qy9I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series reposts patches that were reviewed by the DAMON maintainer
but not yet added to mm-new, for more visibility.  From their last
posted versions, only minor changes including commit subject update,
Reviewed-by: and Acked-by: tags collection, and rebasing to latest
mm-new were made by the DAMON maintainer.

Sakurai Shun (1):
  Docs/mm/damon/design: fix three typos

Zenghui Yu (1):
  Docs/{ABI,admin-guide}/damon: fix various typoes

niecheng (1):
  mm/damon/core: clarify next_intervals_tune_sis update path

 .../ABI/testing/sysfs-kernel-mm-damon          |  2 +-
 Documentation/admin-guide/mm/damon/usage.rst   | 18 +++++++++---------
 Documentation/mm/damon/design.rst              |  6 +++---
 mm/damon/core.c                                |  3 +++
 4 files changed, 16 insertions(+), 13 deletions(-)


base-commit: f4f9ecd6383da01075a0be8f9c08b82152061fd0
-- 
2.47.3

