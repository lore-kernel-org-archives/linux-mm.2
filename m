Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB2BAD25922
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 02:46:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 508F76B00AE; Mon, 26 Jan 2026 21:46:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FE396B00B1; Mon, 26 Jan 2026 21:46:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40E076B00B2; Mon, 26 Jan 2026 21:46:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2EB5B6B00AE
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 21:46:15 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F35CEC2D82
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 02:46:14 +0000 (UTC)
X-FDA: 84376204668.01.E97AE73
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf09.hostedemail.com (Postfix) with ESMTP id 479E8140003
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 02:46:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hR971E1r;
	spf=pass (imf09.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769481973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=LzjEJY6qcpwuajGjEtJvsvxgNViqBcYPvAfyJeQzmvs=;
	b=hehpoByJLYQV37VDnO4suF2W3M+dNWi3BtERQ8HW0eMPB/BFJEtu2pVbuhsGhkFURSWj08
	R098Tvc0jXdm8khj4fb9R3v9J/HSkGgn6pl5HiOtIPMLI00Z5sFesMj4yzTperArctkzQK
	4dYb7oX5aO5SJdagWrIv3L2gb2N3sR8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hR971E1r;
	spf=pass (imf09.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769481973; a=rsa-sha256;
	cv=none;
	b=qSTIILQWczq4Zx38ry7LIWi2S0AaT+I1bsoxj/qS8hiurfOAuZ8D8XzOfGz9uZHaHxuJdR
	fWLyZHRIk1twZar5hIvI0TeS97PIDq8DRViegLB8mTPlA4XeN4KHYJpKGlLB9B+Pow2kRV
	SzIBiKWx1vIO1ifnTOw1v4wugrWSWzk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769481971;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=LzjEJY6qcpwuajGjEtJvsvxgNViqBcYPvAfyJeQzmvs=;
	b=hR971E1rulwlHhX2kklqL5Fikprd3Duwb+F6s9Kj8XQ6Yj2Jaw4eHH4LTtQIHK2dLCXquH
	6F89dMkq479LNitHcu6b+3uJoxU4OmJTxEvUTw0XkKf/f6BSxmN4KOeTWWXOECIEZi/p1W
	zMXiuCpKolrY2OtAdFJaFQRE9yMbS7c=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: bpf@vger.kernel.org
Cc: Michal Hocko <mhocko@suse.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Matt Bobrowski <mattbobrowski@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Song Liu <song@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH bpf-next v3 16/17] bpf: selftests: add config for psi
Date: Mon, 26 Jan 2026 18:46:03 -0800
Message-ID: <20260127024604.495018-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 479E8140003
X-Stat-Signature: ow85m5rzeocarxmwtquwtxbix69fwgci
X-Rspam-User: 
X-HE-Tag: 1769481973-501365
X-HE-Meta: U2FsdGVkX1+6+DeQlKVyzh2HU1AL3wikoYEy5AkUfc8xvGzT8o1XwrsoBQHrqSpKhHZ7g6/ao5En6rFaA7MEDt37jYeF75cc0BqPB9vZ7LGYXnpDZMJCCw0mSwO4ZHzdDUqNSFEVakF90TgujLpWiU2CzChWICEnaDMdYaV1Gz4C1YO2U6bC2+Y3zq+/zAy6t7tWkVBmL6Hn3qn9FoKkkDQ++oI89uyL+/Yq80puwSGMgrXdeAI54FzYK3GGEv5oIaWVE5M/eR/wjjG25RpHFJG0ojKHSOV1bzcPJRw+xEAc1k28jZ03xb6Eql8EyVOFKJXJbQbSwUFdIVc+EevUmXLLXHbbC00cbR9hwGE2epk7xinEPli8hjs+wLbq/jMkDYe5cGKzm3Wa03P7v9E5zn9F5FjEWVirKHn1wJc8UuwTl9+e0ln4QcAznjJoVY4z0Amtyohm1SCkWGtk7DZorYIEkaR03PlTMfJYldKh/rEPagJCdYZq4jKFaqBhpGbZq1mbABa/L8l5Wg7W1xxvGO5BNXnsyjiJrLbRVkOL+HIApma9mO4bnfJ5f/l/8C4FnvtybAlVTBPz25rPIVKrRa8MOuQ4EHUcTRuLMdHrLXtl1mcQGea4b6gDjYoxawaRh0huuSce1+O1wcQn/lM77tWgqTXN8dcHP1NLHe8BETOAXmZFz9IecV7Aw82t6IvOw2xc8Atw3JeA8f23En1eP2DY2HV6FglJ9CY2sCOUpmDoodAmYQJv0sr3oZIrcuTiqypmiFA07D+Gg5U7o7C+m3st5GfLv2uB+uuj4e2UrP8MNdaOR/CtwE25gNXXfzLTCGfPfnXqV1u6nM3wt+JOQ7eoy2UQ3A3X7x/Kbs34S4GctZbZ+o05sLr1ZVTU1gu/+pbuf/Q7TQvm2Phx0wtOPLBv+wy9gEEurLF/s4J3TL1uidHzWYjkbkyapSntTqnlfGC8PQOHXXHlYlgRi04
 AWETHeyT
 5nKegYQZeb2Jyw6Vb/JO4KoF7M3N58c4Mgsb8wGYFX0l3AY0h+qUE0vPGCp10G9u+jqwmNH6w14ULUhnYA4pcRyLvv9zEoyBTUOtn/OZp3ZTexkvgrBg4toRuNbYd0RY4YV8hbam9GLrWWisNEq+a9Bj8cEDcXC++7882Y7rDHLO59e3Or2+x7V3bNmPjEIRTnY/6HzEiTawRJUwy0Fj13+M+eJbkZYbZkfnm88I3ttUfBnnrm4YRxZ8U1g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: JP Kobryn <inwardvessel@gmail.com>

Include CONFIG_PSI to allow dependent tests to build.

Suggested-by: Song Liu <song@kernel.org>
Signed-off-by: JP Kobryn <inwardvessel@gmail.com>
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 tools/testing/selftests/bpf/config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index 558839e3c185..e7dcb1aed4df 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -111,6 +111,7 @@ CONFIG_IP6_NF_IPTABLES=y
 CONFIG_IP6_NF_FILTER=y
 CONFIG_NF_NAT=y
 CONFIG_PACKET=y
+CONFIG_PSI=y
 CONFIG_RC_CORE=y
 CONFIG_SAMPLES=y
 CONFIG_SAMPLE_LIVEPATCH=m
-- 
2.52.0


