Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06911D0E6F5
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 16:30:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 521DD6B0012; Tue, 25 Nov 2025 11:30:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47AF46B0023; Tue, 25 Nov 2025 11:30:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31C146B0022; Tue, 25 Nov 2025 11:30:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1EC756B0011
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 11:30:37 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B51EB5830E
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 16:30:36 +0000 (UTC)
X-FDA: 84149667672.25.DB7F2B4
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9E3714001F
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 16:30:33 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764088235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=jH0ke3eiwrCDN+mNmTrDPG/MhvHf7CoYLRXzE2hOagU=;
	b=n3TGt31a2DJjRcUxReYgYvearP3sNFYf4x/d+eWKgTX+1yNW4pbONyAb66dLLHu4+yXx3F
	hTDi+/AnyQKnJmUAjRVuPpAVV1Mu72gFkAedQm6oF+sGVGnDJvmtKjipecjp52jYE/6ubu
	+3GIsbzhoNCycKQoD7HKf4k//A5guKg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764088235; a=rsa-sha256;
	cv=none;
	b=7xkKwUjx6HOo/XCeMeIAxzFjU97K60pF6535e/0M1UnOu+Dr4h8WwYsyK/eW3RACq5XKAU
	0d3+5THZgN+vw5WS0vfIAg68dGnV+lTI4CeIBdOYiysG7DaPJziogeGnusOv7lX7Rp1SMt
	VSX5056OzlWWGnytTEFB/kceBSkxr40=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 26 Nov 2025 01:30:29 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com
Cc: shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	linux-mm@kvack.org
Subject: [PATCH 0/2] mm/swapfile: fix and cleanup swap list iterations
Date: Wed, 26 Nov 2025 01:30:25 +0900
Message-Id: <20251125163027.4165450-1-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9E3714001F
X-Rspamd-Server: rspam02
X-Stat-Signature: w8zwheu1p3oi19yhk8wace5xtded8xpd
X-Rspam-User: 
X-HE-Tag: 1764088233-548602
X-HE-Meta: U2FsdGVkX194SxVN6KU1aFGhVja42b0SUXqHNAiRUAqqDEeaW5nSl0Cc0V67WkvnVKYOtYWhywL/9NJibAa5r6LJ3umU7OD/OrLSpq/NOSo0vkeIFOIYiRu2A1OXf5UaJevSN7qnSKk2e4yKYDX3fj2Q9V/sJf4y0pS4z/e4ypN67gRL25ZyEssbsCP9rKgMkTeemiHus+4mNYxSVpl/ynq4r9Az1f3zCr/9v7VfTVYpMB8iY6LcH2Q79XL9lYEIobmQBYD4x8fsOZMZlL52fbSVonaa56Hsdu9IWVKw7xu8EiXWXDEczO/dcCmGTWIPLoI0YFaPvsPp+A8Mjxf3OStSPjCa0SS/ERGK53uQRFvQil5zmvhGOVyGOx0ffkPW3oIInRLk1UDTajMFaAkiCqIiWltzDsqtvGcdLqxDDV913W0meMiq3xvrHb0bLkUbCl6PFvzpg05gfRMtTdJHknxCjb8tABE6zSO9JuuasFnxhv3o8AanpYpNVKzalSJOf8Phr+cITJ80DdAUKLPpVeYcZBWJ9iHL2ZsEWwepfeuPoLey42eaYOMf/VU/QNHLjIbJ4fx2iJ/2vSMaePqTb1CY7Y5vWhHcbl1WCertHBNmO2EFKTy76wjMPOoF0MsshWftbMdoYnucgsZSeBA1Z+UMgnVkgctA2dgk+0BatIuDosBXbJ3DiThx7kfWu+4tpMzEzH+4/8TcvjrMrZsH2QCsPnW9OIndEN6urVSX5/4RaT7qoi7771kAnD0wEma3oryuZg5hambJ19vPJmTPBtEiKgRirg3NdGBgGOn/+5oMP1eoA6WZXrORWa/PvPpYijQRKmi10cH8ddZzKXnwX8sqQSCz+Z67+inTwv91XgjsE7V3LYhiEH8Jv8bbU0qIFO2959Sx/beK5TIzDEyo5cZgv+28qOldPwjWoiqwekMJMYjh37Xt+BkQOP1LoJoFsar10DUToswUrfhTMwg
 Cg1mDxn4
 nVYr3lPW3mhyB4udr+dEXmS1tSdNVgVzUbrNA+Zm56cpDTd68ZhFAnNVpWFPqVEPFpxsMpxsFP5BYMqUF92Qamk3G3X6+ae74h7ySUy6XfOJRaUrocRPeXuEzejwQd6Df+UcGdROKKd59brg99cEua2uzaA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series addresses an issue in swap_sync_discard() where list
iteration can fail when devices are removed, and includes a cleanup
for __folio_throttle_swaprate().

The issue was identified during discussion at:
https://lore.kernel.org/linux-mm/aR53i1G45XAqCzBd@yjaykim-PowerEdge-T330/

Youngjun Park (2):
  mm/swapfile: fix list iteration in swap_sync_discard
  mm/swapfile: use plist_for_each_entry in __folio_throttle_swaprate

 mm/swapfile.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

-- 
base-commit: 624c4d7b8fac3fdf9894a5f89f84709771db4dbb
2.34.1

Best regards,
-- 
Youngjun Park

