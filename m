Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 621331049515
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 10:19:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92A4C6B008A; Wed, 11 Mar 2026 06:19:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 913276B008C; Wed, 11 Mar 2026 06:19:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80E416B008C; Wed, 11 Mar 2026 06:19:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5F57C6B0089
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 06:19:30 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 01C3B1A06E8
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:19:29 +0000 (UTC)
X-FDA: 84533385300.07.6298207
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf03.hostedemail.com (Postfix) with ESMTP id 11A6E2000A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:19:27 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=XVBQbI+T
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773224368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=BPJtUVDvDbQT34GAqQpc6v3iTpP2btLxeJFBbCq2WRM=;
	b=fjP2+SXFTCPEUMp9OLAtKCm038iwMRzIWuJAtuaVx/WbUNMUHmBfYxdJj2oLHPJ513Mfjw
	x5T6is+nvSo3O3hOuryZlNBGW6+jyiluD0h5fZlbUyhv0qut+tjdgIdEeWw44PInEiE2Jp
	aYsDSVnuss8DujlntaZhe/lNc8QqtKw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773224368; a=rsa-sha256;
	cv=none;
	b=xMhexWMxFJE8wxfUt1JYFeJnC0J2LnE0x29/DeRq4Fe42dVCcWicX/RX0GTx9ZBPXHnOcq
	Qm10SaTbVF+V8ua4nw6GAGy1N2pbkOuz1F28AXr3GGPCyNe0t54HoBI26YxXBvFGzlAf59
	TMpt3skDy7M4URtVIvPt2IgjvUHPqsk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=XVBQbI+T;
	spf=none (imf03.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=BPJtUVDvDbQT34GAqQpc6v3iTpP2btLxeJFBbCq2WRM=; b=XVBQbI+T0XuAMVugCeeJ7CCDPi
	DC9VW/0WUAxXJwIh421a0BIXWbJArjYdDcy3Sc6UZ1oW5HdIYLOpkRKpFJrkm+uiRmWWI7TSq8Ej4
	u10cym2dIZ8nDb554SR4Fzmwe4fA3IkpA820f7iq/uu8wryu5Ln7zhiIGJBOYJAFAOkETSqFApNvz
	ByUEvSdI21QzMIKP683gGTviBGpkJFYFXSHhkOJe7cZ2eDVxQ3XRM4Qv2AK4B8LraztbkZEb925Po
	p2IdEJiCSVVjZCdpi9PItccBli2loXYUGPqH1KDW6XnR+Airfc2TAoNrnL2YGDCeAcroY8/gJ4wpR
	GWXPRwYA==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w0Gek-003hKP-VQ; Wed, 11 Mar 2026 10:19:11 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH v6 0/4] mm: thp: reduce unnecessary start_stop_khugepaged()
 calls
Date: Wed, 11 Mar 2026 03:17:46 -0700
Message-Id: <20260311-thp_logs-v6-0-421e30d881e0@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAEtBsWkC/2XN3WqEMBCG4VsJOd4pk78x8Wjvo5RiTNSUoktip
 WXx3otbSlM8HPied+68xJxi4S278xy3VNIy85bRhfF+6uYxQgq8ZVyiJFSoYJ1ur+/LWACNC+Q
 tDhSIXxi/5Tikz0fq+eXnLh/+Lfbr4Y/FlMq65K/Hr00cu9+s/stuAhCMQ2WlsJ006hqiT938t
 OSRH91N1tJUUgKCI6+60DhjnT5JVcumkgoQOm2C7O2gyJqT1LV0ldTHT0neWY1oVTxJU0mBlTS
 AQJbQOdEYP9A/ue/7N00TtG2bAQAA
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3437; i=leitao@debian.org;
 h=from:subject:message-id; bh=SlcRmMAd9e7RilnQBzhjPWgJcym8P4Qfi/tBeqY+WfU=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpsUGYe0n4Emg0DgcwLIYYEzbtgFsgQN1fXoCb6
 QuGYo05/qWJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCabFBmAAKCRA1o5Of/Hh3
 bU0mD/4wVqEHYUQmFAk4UC+Lq8RIr56qC7E3dYy5PHZGyTcZ334GuwtbcSyrnlWYY+UnrGJNkKz
 v0VVHjxfyoGTzFrfNp6X13LtsJl/PMggi+K6IaGHqsvXTAP3g2HYLQYGBy4hHQGcY1USVYREHda
 gbLMtq4sm7ytz6KD4Q/5xBwG3bLrs569OYrULDNgF5m/wL4ily3Cf25GO/ATBJ2SjDyr+zFZuLy
 PAjq+9z3NTrVZG1fgN/0U+1HkwQGJIag5i6wAhTUQxHF3NV7V8H+er631GpYupTlzlIdzkrXeLd
 O7Q4CKLJGEhr2FsjYdjAi29k6CUibx8fzb1l7AGbDaMIRrpCnbH/DtbRv688K9G9lEeoy1T/l8L
 EqVrLjBlOnDZxDjAbUMJHeajeVyZy5whaUmwMUfECXYDAO0P/YfexMad2vtDPtkKHjRq/TLK2sv
 /roSFUIV7YUd0o6XMxHPryq8yBbTbVglac47f1JZWopLNUc/tH9X87pr0P2UieMijZdlF/zuxZk
 T9AVT0IKbd8+3jB+auV/9N2H+khIO0vRv1HFJdY1Z+B2Tuk342sSs1eZgkIrd7Rx7My4i16++qz
 07O3PVNLquxXaXRS7b/3OfGM0sF8/NrAIF01YSRgoxYRS/b2H6ZP7Mug29NXFxJ1bnhgfdPsCpL
 u8yUhmZMnDhoAJQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 11A6E2000A
X-Stat-Signature: mxx6zcmeghzp1srmg9tqr76e346hmr3u
X-HE-Tag: 1773224367-927447
X-HE-Meta: U2FsdGVkX18uJVd5IsSuvKdK3BfPLE/Yz5WE3oJJfhYngD3UAnmyIokfjkuk3RjpCW4ysZvURm1cRLND2jYWURIB6VUNKc1PWUbnqXPGwCI7LWDweFGaQ8wR4mGXuMbwkKVnowYlzlNdIIRgkNccRO19KJ5kCh3+U1D6LTk96WAxQMruc/ghrEP9y35iuAhD6Cv0eLINZZdtvA3zH/QxwQ0xnT2ncd0PHNu03fI6j5VwvSs2Wo9lC/s/0dHbQzSuRsqhcyuJklR7SzYpMKCdX6vSiFxc7pyHoPCTLxNStk4j+SmAwBJhWpuntPcMQOlbXSCGSwl+VAWnI8/F+2E5SMyBu/WcIkEvyY2sIvqmFQpGemRyqw0raNRQAwUTlEzr+4sHMwp+N0a9C/8n1jM0Q9pfwXDFL/PzqplQMvpyNrtXHc1yJI8qgGlRBjDZeUF0Fh+3poAM4Q/8AR/7GNEu8NMrsZy0XjKOC4eBrovNGX9XL/VPc8FyldnxDqFWUIWY54X4BSCvLfiYCNor3lZEelZsNVges7mIyESbslXbarbYf2ywDKSLxQgRcsuqLjfbKn6jnYT7N/svEoArzCW/GRI8Fs/b0Ns6hS4VFwSKbs3v4ikqqtN8Qpn6kWEnfuaZ7y7wqG10D+GQiPI8rQOI/p+T+dNtXIXXbvCcJUkMr05DuM04sKkPhgx544kz6JO2y/K1gqQqs0PSIQlSGX6TQ9REj8UdHHINZhrCERXPdEoqvlyDpOhHal2QT3J9GyvwhL4jSWT76KfNcl1lrmpVB6T26K0j5XP8o5tDiT3Vu5oMhyR0KPhs+QMRrE59/e+gPnwqrGNLxyUQ2SaDA+ANZhX+A8rsC8hDhnoA2LlCplI/b5K5TLR3CAaZxBPFDL2fZLBY1Px2ZhOCAPUrlHhiS5U+tKek6LRQwZy+nanOEEgnWFCvahdKjPnS14bry+cNSHkg98NyDJkl55hbf/G
 P7r5oymt
 J9saN+0PGmg2kMfJAwD7HmwUGxy+WH7RDaEyS4K1ZTy4qP1Ck8YYk8daZE5EW+dyIvNpgGP8OVbmQaHRPipLL/OcfHSygb9m4A8EpEy5WSG3Ql8MXd/ldVI5Txb4feq3ptdOoUuXnvR3bWlaqAlq6IV+XdnR0ZX4vnyn7TVQRrvow/JBMSialAApMaM+fO/jrJ0HzZrkhwBRnKur7wwzz/ThNlR6++nbvLUSsJrcUnp3+DtNo8UA2ltEpJj6aIVDQfFbRHcu2KciMrC6gXqoI8iXIq3l9SBNY1LT2tPDNQthU7lmLe1VATCg7UsbP5zKCdvIIcuXY0puyBCOlBUqnxCQWqdYNYpaH0UyNtYjctF5ZNBU=
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


