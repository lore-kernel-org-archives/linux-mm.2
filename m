Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E2FDF55102
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 16:08:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 690486B0088; Sat,  7 Mar 2026 11:08:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 553286B0089; Sat,  7 Mar 2026 11:08:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 497056B008A; Sat,  7 Mar 2026 11:08:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3A56E6B0088
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 11:08:56 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DC10A1A0151
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 16:08:55 +0000 (UTC)
X-FDA: 84519750630.18.19B8DD0
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf09.hostedemail.com (Postfix) with ESMTP id 05656140010
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 16:08:53 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=W9bTTcrx
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772899734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=R8iZ/PJn7DWvBICYADVRrswu3ZDl8IGSd5K+vwXeoRQ=;
	b=cBA58HeNjL+7RyZKgL7tpdC6O64ZmmW2N6oRPQeKtLspPWxJQvL20gZh8gD3q4dDPhUjkK
	+tQlTPo6mO33+Y43hARShiuMw6uf/cuWPXeiaYjiL2HtH8EVLbsD8CIVD+8H0v5K+cMtqh
	QzFA0a6/6g5cT+PVtLHXbs/o2MxNt9E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772899734; a=rsa-sha256;
	cv=none;
	b=qjyZepVGnEmrnh4Lt1qhhPHfHn635Q2J1ZzhYRZxMJ+C40049G6zGPM/wn/4OyM4cfAyLZ
	o+HnW/vfvW6h0j3PycobX45imAIrEJo0GuMfrOpZaEhcO8MLomixM4akf21MO6T04vnEHj
	+kl71TipmsEr5JIznABTJRgeDLV3Kts=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=W9bTTcrx;
	dmarc=none;
	spf=none (imf09.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=R8iZ/PJn7DWvBICYADVRrswu3ZDl8IGSd5K+vwXeoRQ=; b=W9bTTcrxiwcCQzw/vvv6HPP1Ss
	d14FfXnuccCWPbER+hScTcktdhPMtAhjjx+zpIGxqNvUx/oxeiY+cn9TOwa9ok1clJzBzkwt2pjgw
	k+MvOzCspX4Mo7/Rwog7AYtByjgLnF2vP1AUSWzwmjUdH6s3XQ5T0spX487vFEieLYIt5hVRlpU2r
	snUuf+iW+N7J07rn1/EfpMEXUnqTUG/n/WvezrVwYh26Y7dOIdjB3NFQwWH3dwdfnKXDO/ASPdA+D
	OCYDUVI/I75OVAqz0jtCct2Rv1Ne5o7/FLYo8QmEpVVleT0JRCNjsd1Wuio9UTGXbkxEP36SJ+QVn
	8bUhA1fg==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vyuCd-000nEX-3x; Sat, 07 Mar 2026 16:08:32 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH v3 0/4] mm: thp: reduce unnecessary start_stop_khugepaged()
 calls
Date: Sat, 07 Mar 2026 08:08:04 -0800
Message-Id: <20260307-thp_logs-v3-0-a45d2c8f3685@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAGZNrGkC/1WN0Q6CIBhGX4X919IQhMSr3qO1BoJKa+LAWM357
 g1byy6/7ZzzLRBtcDZCgxYINrno/AgNYgWCdlBjb7Ez0CCghArCCMPzMF3vvo+YcGmErkknjIA
 CwRRs555b6nz57PjQN9vO2c/E4OLsw2v7SmXmvtnql00lJphLwmpa1opydjJWOzUefOghdxPdm
 3xnUkywFJopc5S8ltWfua7rG0eio3HtAAAA
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
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.15-dev-363b9
X-Developer-Signature: v=1; a=openpgp-sha256; l=2808; i=leitao@debian.org;
 h=from:subject:message-id; bh=AGgC5XZOt40eYEobmJCAuFdk3ct3NpfVKCtOGV6Ni4w=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBprE14Rfi4spc3AHwjUpHVYY7pPHuogMlliI8CS
 UWr60fZ/PmJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaaxNeAAKCRA1o5Of/Hh3
 beChD/9HXUfZMyPFw4kvGDcPA+cvpMo7+3HkLY67rIliNLP3R15XX3Uz0dXXXKgjToSFJ6axmY2
 b70ppciBtRZIy5A/ZodGO2+rBFSoYuv1SkWYSwxQZVKatpi8/KfTIlTPvViWJh6HMlwP0SYXpfq
 sFrOo6bnjDq1lgolf/HgbP/Fu4G3WNmfsUaMzBT/PbLUFzT3gwIF9KSVs4iww8YtHFsLbZ6rIRv
 H6+j3iLGbeuJ2YvQjyQ4om8i8dnX244ej72uKkOEaN0y0L2yODaomFFFMUsdFtTrkU2Nq20EIkC
 uK96E0xFxlotGl2IHAclbI3Ep/6TVrInKZkCKBcuVyQ58BEcfEuAzSEHkOP+1fHpACcvgt2t+RM
 HUWRa7BULRGMgzcH0+Z+wNZbfQt+ADXrJggejTmC6YQqUwDJt6yB1cFqGGg2oBlQDKGOi0AAOO/
 znjc3x82mY/e685Dt1liyrJdXpOQhgQ3oz/mATvaWef0wXR9o2R6nn5nJ/Jo2CHze9s/W85JZY2
 sTSpI3uxIGa77PnsTLiuoV7Uj94ktd65BE4Ka/Tg0SqZ8hHf07h7+pJHV39jLWO1O0yGXKfVThW
 yToy+nnr22vn5DahNBZSe2IO6/2lpigWpXGiiZKwVat9gBSWQQGwDh+eBxRc7ayW/LjY6v/LojK
 uyeHb7eUXiirqHA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 05656140010
X-Stat-Signature: g8fy19ct3okq9bdstejffxwnno16rje8
X-Rspam-User: 
X-HE-Tag: 1772899733-383706
X-HE-Meta: U2FsdGVkX18hRX3RusfGXF0cvCDMLudrUvstu04l0v9tykLlLcLJlGBOH+CJNwXj5ZDyPIDkr0oXAmuDkJkTZDTqBzBqUXt2C9rbBpcSkULdvM/3gGeTe2pchHEgjBZ60ee500g/kliEHmUbnNlUvMhaiRRuOXYRYhHdB4p5D1qQ0mCp9S2evmfkOwBEz1Z2VSfGZyzBdi4g2FXfy2hQpE4y7xLmXUr7nRAPBtSQkRx0ddpd4erip5ObIo1QwJa4fpNrCx3o3QxfAWRJkJn6HCtMdDC8ZP8ShNSf61PgNIF19VZk66/jEACQQzBf1P9UR4zBUL6nKbtyaImEJUgR541Hm+WAxKo4eS7eBN3n8cazWl23WIrTXDV87X99Jo+6fkNcJT8MJh6CSxLC1+la8Nwj8Nhnv+zhUsG0M9nRcjbQewiHMS8l+Q9B5B9CSjHgcBI3uKrB4C2Fwf2X5NNrHRfkMattPBsiuUu71+Xu/URnb2Jff3Fps2K/li5z8MOI21u2AvY2ynDlbSXOe0WFEq3VmkgwnDSx2beWIyT9hbn8Q9fGyvMnFpcqr9PpLLhPlBQH/bh5Xk0+9x3V3ODvE55ntfvZ+4s3A3tHhO+hT5B7C7WQn9mZiLgqx71t8ntpF3X7nLxkc1IZ+Zn/076WF32wjTILBPe7E8h0WzVvpg0AxZZ+zgoxZAPaSJX1AbffAOZbYfkTzmriSaBAq7gZ5Rt1mkxSlXPpzWxoPpRr0rWoDgKdl97WMev0lo6QAO9mXqJYmMXEJfxz1af06Ue3IYIxtGyn/U2Xoeezw7T1ztR5SqtvlOiIodHNAbBPBoShedxPU86uc3PlOPMz8qa++As3ZSkbiJ7M0VSarOUKw+oW7Jq6LoI8eqlhvoXZsnTwp8LRXxIdM5R0Eue02/CUavTMFO6P4nHVQc7rghiaMfqw+xpdqsdUJKi6a3l9E9FraiN2XEAFCOS5ubOWrIf
 0XIxzO93
 VELkHyCN8MuBYG2GucroUiqC7ozG0QZO/5T5vGjQiSl4C1dJjlFVuT9BO9AaTb6Gdt4mecIBTaIadD5K9H2JA4mugHkvEdq/n+sYF1TiqgxVkLWJPZg5SVbAv3D/aBBNMfhHGvnl9QR9wgDGbx+Kc+BD+mOz4jaioAr3mjdw7xHd72i3YbWRRwZTPfHtUXpEbbBLlrZ3+CU94WXQjN1EBVuKMBOfAAxEcRwrhyEhK1a7j3thykZ361awlN22HcSeufm3mfCRyGhCq1GvpwDOrkCRpRr798gleqX8a
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
      mm: huge_memory: refactor anon_enabled_store() with change_anon_orders()
      mm: huge_memory: refactor enabled_store() with change_enabled()
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


