Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0065FED9EB
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 16:11:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 424EF6B0088; Tue, 17 Mar 2026 12:10:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 400CD6B008A; Tue, 17 Mar 2026 12:10:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 312106B008C; Tue, 17 Mar 2026 12:10:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 213146B008A
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 12:10:59 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D13685802F
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:10:58 +0000 (UTC)
X-FDA: 84556043796.18.5A516E8
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf24.hostedemail.com (Postfix) with ESMTP id 25AA3180003
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:10:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=IzsneINd
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773763857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=GIpTaSuegAQ4fTNtnx/7u9lJwfUGgVImo1bT6hoKYi0=;
	b=tT7q42Nu2p+2oVK4+eseNiDQTlq4iDK91cmLmYroZgQm8MlkHe3UqTEprApnwJiwluB/aU
	KAlENadUy4Z8xizRo4SKiiTg+X+cq5HPJG6uGi4W3chyN7fdn8nqOIyR4G3t4NNZMOQAOM
	vJFiU/FPWOcVLnL73cpZRotjm43pdwo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773763857; a=rsa-sha256;
	cv=none;
	b=t9x9f0wFd6xYLG5wm/A8kZkj4jDUzrDPcWQP+N9mwx5mxwia3O3dlWNvotFdjpcFV/h/b1
	e3WrdXkCxJkOJgzyng2xCJxE4Rmo+v4DnXAxTOJpb9WZRevVVaCG/up6RS86aUNSD5Of6I
	Lwo+gQp6uKomiGwD9k5KZ22KVtrDcVw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=IzsneINd;
	spf=none (imf24.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=GIpTaSuegAQ4fTNtnx/7u9lJwfUGgVImo1bT6hoKYi0=; b=IzsneINdagAZUXnHS4HTKhx89v
	pYI1fKwxNjjNH2DeIVLFieTUrfK8whe6mBAl7T+nG5CsRbYJbTqbLh7n8ar/Rb0hB1SiExIz3h4sp
	WPyGuwLGqcmx/Z0/o0+hv1nEUm5fVhSoG9/w9aWP4rtF0gokfLcBQPCNiRyQhEIP8AwlVZA81ec8B
	UoNjVw9Sw7U9W3+DKppEHcX3sYw3j46wD2luAN0aDWoeS8Ldfa/eo1qXaDH/CulQc5U3K/3Pcxx9G
	Ck7y4S74SkuRhtaI3XL4ZY1sg+GAm2ZiiLc+mG8g1ICtp9pDKetrBKvSKgN1wPUrw/aQ6AA8vkPgm
	VYCzoaCw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w2Wzz-0030CZ-1Q; Tue, 17 Mar 2026 16:10:26 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH v7 0/4] mm: thp: reduce unnecessary start_stop_khugepaged()
 calls
Date: Tue, 17 Mar 2026 08:33:55 -0700
Message-Id: <20260317-thp_logs-v7-0-31eb98fa5a8b@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAGR0uWkC/2XN3WqEMBCG4VuRHO+Uyd848Wjvo5RiTNSUooux0
 rJ478UtpSkeDnzPO3eR45JiFk11F0vcUk7zJJqqvlSiG9tpiJCCaCqhUBFq1LCOt9f3eciA1gX
 yjD0FEpdK3JbYp89H6vnl584f/i126+GPxZjyOi9fj1+bPHa/WfOX3SQgWIealeRWWX0N0ad2e
 pqXQRzdTZXSFlIBgiOv21A7y86cpC5lXUgNCK2xQXXca2J7kqaUrpDm+KnIOzaIrONJ2kJKLKQ
 FBGJC52RtfU8nSaWUhSRAMEpGjYFZRvwn933/BsVOHeXVAQAA
X-Change-ID: 20260303-thp_logs-059d6b80f6d6
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 usamaarif642@gmail.com, kas@kernel.org, kernel-team@meta.com, 
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
 Breno Leitao <leitao@debian.org>, Wei Yang <richard.weiyang@gmail.com>
X-Mailer: b4 0.15-dev-363b9
X-Developer-Signature: v=1; a=openpgp-sha256; l=3627; i=leitao@debian.org;
 h=from:subject:message-id; bh=K7rmQCyF+eYkt2rtfVnW2pLnbI89ulk+s3m0i2EK0Ak=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpuXzqVo3pv+oXUzdYQyoehzEa5bFv3rDm/EZXq
 CTjOsNY3myJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCabl86gAKCRA1o5Of/Hh3
 bbD1D/4zXmRvD8WOlD/3tbYoM2zVOtzAeKDAvLXsyBKcspC2Lao3Yvl4IGQEuiiPD4uWghiirvh
 BmBKrMqekw6yNHuAZ24D7hTvdVKic+NmdPz40DiTaoz1OnMl3EvYph3Ed2Z/ygSYsLVXjwez6nf
 jCE/+U5AHU4yXQ6k2rVVhI/9Zbcnw3AhZFzfz6CuZ5XYeYwGcpLh/N4eQqJND6U82vKSQfqqEKy
 u4WmHMWdS0u4uDqBuFS1fp4e59NAJ8lcGJ1jRDUlzzoDP2q3LHZ9DehQM5rEIPgMPC9UCRihhiA
 yUvsIvuE9rx8+Frs8qHsdEiZbODxTCLdb6hi5TLwIdydTRjgtUzQ8d/3ZcLbQQvID/CIFI1OPF5
 6jAIZm1tSVQ6CcAcjyj/wilZbrSFDJydyTHcJ3/NE5w+mNGqcC/hU1S8ymealE5lCBJ7vTuJ4xD
 rn+6Idd8tTYGMfququXGHb/AweE5f3OgUv+fcXmGqVg79oCwbI5cuHtNJx3lbgYKeLBMnDrdkek
 TH/W1pVdlddLI38Qm876iXB9hIrni7lRuH6ldX9czzQO7pqhjoLrkxCVuqfym7P0epUvHoK0BDD
 UXyOrZojJBxHdwSKzt8f30OA/Eciym3h0POC2tUuszne5VIoPXCSGZsf01EvM/Di8XMQgxBH/Wk
 p66tULo9Iti9akQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 25AA3180003
X-Stat-Signature: 33pknyjzt5y5su9de1kn6wa1byy1xkmd
X-Rspam-User: 
X-HE-Tag: 1773763856-262371
X-HE-Meta: U2FsdGVkX1/09NUUtVz9GSFxk/ihEvJZuc8kDdPXzZK9kSaE19fRi8u41y7Aeni0VtNU6l76n1ogxoWFPitxC4A3G+curTz7qIAegY6O8zDQuKSNZsGL662rAdXYw1DUz819ie5V6dMW2MpKKcNbbKEMBx9/n7zVGMvLMSZZwzbVZrR/QBeN8SamE4X3V3YLIPsTguiNbET/XAugp9BtjTmXK4v5eSK0emYCpJLImhqgptIbOXWf4goaT+r7JVFxSTRZ12qlZHHIK9DwSik0S/h3T8FBgsWs9gdJ+pCPmDDFfbKImy8trCcWCc3nd/wfMAwvJZMnjzbLcdBcLgZqzXeqbapyxgWLBb4BqGovBWurgXfrVqXOCDeJb+iHzqkQAwWN9qPcG6TfCsXB9xfG26zqsQrED9NeJ3YtiVvAgZzIPe69/iK7+8e/mJiTDc7RnRtCQndlsQtCoKdJ9hhHHm1qQBtU2xkz7L9IF4eEBsJ1/o4XbKOtMk3wLDeMv1P1seO8QcGbMA9r6nYIuz+idqJbKQCy/M3EVPNyLiITOvCifARLe1mRDv56yrg0FGvd70mnjRYCZ0PaJDFaSdQpVvgz6FZkhlM5LZBzdOaJ8QETM2zo5CZl7X0EEbC0TZjw8xTVQtC7zP8WRv6pCXGP0D8TQ1mJBnLA+Ce5gPgvOti0DboTiTwvyia2t2NM9Orpp8ZinVXrjgOSO6NtBj4nbC+2shcHLSFzWflUPfOu2zToZJHW/lIf/05HAB6WB5D5HSYWtVn7/hE7dbwYxiwfyrRJSW5mA5sfvwfDGyKRpWzPr4pm9/EUkVMMrCuZAtiQ6iggKu8s9FLfdGw0yJR+G5y3ulXSMnFm4IyUc02bMPZDNsMGJPgRAz0T6fo1/wdBCfqQ+aDZRNCqUtHdgaoXVsUe5F7liwCMiYOAgoQD68Am2PFwkig7ww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Writing to /sys/kernel/mm/transparent_hugepage/enabled causes
start_stop_khugepaged() called independent of any change.
start_stop_khugepaged() SPAMs the printk ring buffer overflow with the
exact same message, even when nothing changes.

For instance, if you have a custom vm.min_free_kbytes, just touching
/sys/kernel/mm/transparent_hugepage/enabled causes a printk message.
Example:

      # sysctl -w vm.min_free_kbytes=112382
      # for i in $(seq 100); do echo never > /sys/kernel/mm/transparent_hugepage/enabled ; done

and you have 100 WARN messages like the following, which is pretty dull:

      khugepaged: min_free_kbytes is not updated to 112381 because user defined value 112382 is preferred

A similar message shows up when setting thp to "always":

      # for i in $(seq 100); do
      #       echo 1024 > /proc/sys/vm/min_free_kbytes
      #       echo always > /sys/kernel/mm/transparent_hugepage/enabled
      # done

And then, we have 100 messages like:

      khugepaged: raising min_free_kbytes from 1024 to 67584 to help transparent hugepage allocations

This is more common when you have a configuration management system that
writes the THP configuration without an extra read, assuming that
nothing will happen if there is no change in the configuration, but it
prints these annoying messages.

For instance, at Meta's fleet, ~10K servers were producing 3.5M of
these messages per day.

Fix this by making the sysfs _store helpers easier to digest and
ratelimiting the message.

This version is heavily based on Lorenzo's suggestion on V1.

---
Changes in v7:
- Keep the atomic test_and_set_bit() in set_global_enabled_mode (Sohil)
- Link to v6: https://patch.msgid.link/20260311-thp_logs-v6-0-421e30d881e0@debian.org

Changes in v6:
- Keep the anon_enabled_mode_strings[] ordered similarly to sysfs format (Wei)
- Link to v5: https://patch.msgid.link/20260310-thp_logs-v5-0-686099175bf6@debian.org

Changes in v5:
- Used the lockless __test_and_set_bit() primitives (David)
- Rename the functions and variables to match the code (David)
- Link to v4: https://patch.msgid.link/20260309-thp_logs-v4-0-926b9840083e@debian.org

Changes in v4:
- Use the enum instead of int in the new functions (akpm).
- Explicitly initialize the enum values (akpm).
- Link to v3: https://patch.msgid.link/20260307-thp_logs-v3-0-a45d2c8f3685@debian.org

Changes in v3:
- Extra ratelimit patch.
- Create two enums, one for anon and one for global. (Lorenzo)
- Remove the `extern` from set_recommended_min_free_kbytes (Lorenzo)
- Export set_recommended_min_free_kbytes() definition to mm/internal.h
  (Lorenzo)
- Link to v2: https://patch.msgid.link/20260305-thp_logs-v2-0-96b3ad795894@debian.org

Changes in v2:
- V2 is heavily based on Lorenzo and Kiryl feedback on v1.
- Link to v1: https://patch.msgid.link/20260304-thp_logs-v1-0-59038218a253@debian.org

---
Breno Leitao (4):
      mm: khugepaged: export set_recommended_min_free_kbytes()
      mm: huge_memory: refactor anon_enabled_store() with set_anon_enabled_mode()
      mm: huge_memory: refactor enabled_store() with set_global_enabled_mode()
      mm: ratelimit min_free_kbytes adjustment messages

 mm/huge_memory.c | 147 +++++++++++++++++++++++++++++++++++++------------------
 mm/internal.h    |   5 ++
 mm/khugepaged.c  |   6 +--
 mm/page_alloc.c  |   4 +-
 4 files changed, 110 insertions(+), 52 deletions(-)
---
base-commit: 9dd5012f78d699f7a6051583dc53adeb401e28f0
change-id: 20260303-thp_logs-059d6b80f6d6

Best regards,
--  
Breno Leitao <leitao@debian.org>


