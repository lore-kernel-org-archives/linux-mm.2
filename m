Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92D8D606A33D
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 23:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=SRU7+qtF
Received: by kanga.kvack.org (Postfix)
	id AE49C6B05BC; Wed, 11 Nov 2026 18:03:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABB5A6B05BD; Wed, 11 Nov 2026 18:03:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D2B16B05BE; Wed, 11 Nov 2026 18:03:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6EFD66B05BC
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:03:17 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F2859160448
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:03:16 +0000 (UTC)
X-FDA: 85424365992.04.2418044
Received: from pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.155.198.111])
	by imf23.hostedemail.com (Postfix) with ESMTP id CFEC514000B
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:03:14 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=SRU7+qtF;
	spf=pass (imf23.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 35.155.198.111 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794438195;
	b=8GepYNgUlipaTJ7jrJlZxhXGu8zXuIjsZa0d7f+rD9KVTFFilMlc7kuZQBeXHN4G1sDqz3
	SpLCT88zmwfDr9LEtVS/alYN4OoIDC1SgCzVDEqnfimrCIevcxTj6tU4gulBUFyf3GIXZB
	PVGUvk4fHpBCSjHOHzrNwjYezYQv+Xo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=SRU7+qtF;
	spf=pass (imf23.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 35.155.198.111 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794438195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pbZnjc0aH7SqSay+uNUOqZC70h/Fhs1yPbwPdK/7hRk=;
	b=ODIoAQd5y90lC5UvtTS5n7+7Ge8fM5D+ELt3yASLTlhfMSX4LdvqRfmVoevuTGgdbhLj9S
	GqU4Rd9CNFz6VdJg28v5lCGBO0mTlIoHjDoXysrK2bExk7lUSyXvs3UkByvGD4Wme+3e0l
	I/W9A2eKVm0zeibBUOWx3aXzr5RKHeY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794438194; x=1825974194;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pbZnjc0aH7SqSay+uNUOqZC70h/Fhs1yPbwPdK/7hRk=;
  b=SRU7+qtFcHAGUOQH8FmgxXEuNmtPJ9QhjdG52F7y7jws/hkfDmGti+oh
   yvKijC7UqAp2yEGlkQB9K1tCUEhWXalC7zT01QLbR0lbe9SnoU0OjJrjw
   y6KWCKmwQ3tZZJL7ah3G26tXW8vT4BOPJc9EjQLmeM1EZrFaUKhTXiEA3
   By5zY0ZQWPfpNKfTTUjZY3oqxurULsyrt+vh1PGvwJHRExpUIHMm+Lobg
   U6gC6mn65TUFLwg6UxPpTtAV+ONIesk3eoHkcfyNqJFC5FFMzJyT1tGNt
   SOyyH7H2+YZa1sX0GK74mCcnCb56+hm5BceCxLk7KlREnKlDAkdmi1D+z
   g==;
X-CSE-ConnectionGUID: 3Lsv9MqRQ0+uXXjXKo9SdA==
X-CSE-MsgGUID: ANK7tCt9TI+DkYa4xsb2Mw==
X-IronPort-AV: E=Sophos;i="6.27,208,1787011200"; 
   d="scan'208";a="33663271"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 23:03:13 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.111:5799]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.55.227:2525] with esmtp (Farcaster)
 id 7b1afc33-599a-4b5d-a75f-31c09bfd95d7; Wed, 11 Nov 2026 23:03:13 +0000 (UTC)
X-Farcaster-Flow-ID: 7b1afc33-599a-4b5d-a75f-31c09bfd95d7
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 23:03:13 +0000
Received: from ip-10-253-83-51.amazon.com (172.19.99.218) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 23:03:10 +0000
From: Alexander Graf <graf@amazon.com>
To: <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>
CC: The AWS Nitro Enclaves Team <aws-nitro-enclaves-devel@amazon.com>, "Shuah
 Khan" <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy
	<robin.murphy@arm.com>, <linux-doc@vger.kernel.org>, <iommu@lists.linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
	<nh-open-source@amazon.com>, <linux-mm@kvack.org>, Jonathan Corbet
	<corbet@lwn.net>
Subject: [PATCH 21/40] nitro_enclaves: Document the slot pool
Date: Wed, 11 Nov 2026 22:59:25 +0000
Message-ID: <cb0d5adcf580f5fa3f1bfa4150040dedb4fc8eb5.1794393490.git.graf@amazon.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1794300002.git.graf@amazon.com>
References: <cover.1794300002.git.graf@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWA004.ant.amazon.com (10.13.139.19) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: 7mayyqxst81prcqdhr3u1oqqg65qaydf
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CFEC514000B
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794438194-97734
X-HE-Meta: U2FsdGVkX19oN5BftE5lOLtXZ1Jy5odG40qkTclJDuk1s/Jp+POjmUtU5wZiTJB5oeZ5pCOKczaGmcUchhAXy5JGWqg7op7E6ZLQqUMZkRs4OoFMRdujjLosIGIdfUHxHpqa8VTOQdIj9GfmEseq4cUSD6jLY4TmGX9+svwmYgbohf2u07Xl7LQkeJlG34qt4AMbtYUaG0qruS4y3sKGGfVPwQsxt+14iKyk8Pm/yGJ81JIRbqEOC+spcW4lf/ofICpbMr4Df4Q8hbjLHemSAqWdUaG+9Y8iXQtaGCAeiMvvPi1UAPX76oyxbkaOYQKBtssIgW+1hX+2TlVqOUyZBnfpstcpImmwZYyPP/V54uqzycTlAjpykRM/aqgyb5zS5XKuGhUGoenF3F1JzhzhcP1c/8tIwfIZSJfzXoNTjl+DzJjhVyWWzks3XbBxsF+miOYGDMe8ahVZzrepnTi41JUi3nWt4Nt7yNlM3flKBIcsppVRCrOiz5e1Co5KJou/tZfMgyoHtCHKeskvQiZu/I7rqE//pYioBQASxX+YU6qwWbX95wpQUP7QOzkJYtqrd+HeclcqA5rpbs3O0iREM6JD/fTdSaJvqVai8X7pvqbC/shrDoDkt6dRMdz6Pue6NDMZLlkypYSwtNPYXAqDHYWqiF3Hi7UHQ7Pml/USh4sA1LFRNN0Wf1JDUtaD6M2v6Ti/JP8VTc6JDjnq6Becz7aKaaIcgU1/segiUGCNMpA+GnrToLkgDfR6SJMhe6fpFUdwGJKjNA1N3ZctSrE+E9DaRpWmg3KNFhWR8IELWCGK4XJpddWyPUxj+QBaz8nCrMu8mRhIsaaKNKHxjZazRhDdOkDgNpeGR9nQNUlv9KL4vnal4zcQU5noymVrJTFjhLZsVOcDH/V1J/smRSJDqaXhmAhM7+alYjIr3X9O86+66FxH7jlaExUsHMBy9UtV1brSEyHDdLCfOPf0jsH
 enTHcsS6
 zoYMjPmruUTbGNLo1vccmPkcgqwfVa2JDAxsRIuX0Tvy2wj0nUgEOxQV+Ff+Jbs76sg9KiWyvL6cDMc68/ChsWTtYidQEVVda0SDoH0LEDbo0AYxzVWhXUyhchuZlhgiwMtVQFQq+DLj1DCTMEYEWob3/AASCLUExqgUX0fExxuc/5/jDUzGYeq/jCXRqQt1gI65t0QMc0sAx193VV/AtZMjfdlY1Rx/Gx2bB8vKnpbzK6q/MXAzcos1vXmc78HKKLQrx43LPqY0cenv9qZ7reARkcaj+eX/otLMACQoDjaCZkORTboA7OECaaQNbTNfPT66VaG/jLv0CYbKrN0oPjK3ekmhFo7WPO5UOKxqzOOGbmCX7MyJSvVsS7C2J2TCadQzhnzmLGvYDWIyo0XWjD8mxVkBaVEzRjbwpBQFUb0V/rMKm7aOaC/azWZjES841qNSMpOdULgoUfSzTA31BbapiZf4y8sKgOasHKwjlhZq1fET3zPmps83PsMSC34cWnuT7TXIv2NtmBzf7e6x2cVgbmAmVFd8gQTra0NwoabgUr6pM3goyB9NpchRZQi3QbezNUEJ9S2EK+4F0aghfdVYKJSu2l6vXZJJtg7S9dTqF+/ugcGGzfuRQjnqiouK5UXYiqZvkWFNqQ+SL/gb+qx0hyC9aXy5Qd++F4ugl/PzMaSboosRaFcEKfESJFiV5ZjQPIEFeFU/Y8DE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

An admin sizing a CMA reservation for Nitro Sandboxes needs to allow for
the memory the driver donates to the slot pool as well as for the
enclaves' own allocations. Document both halves of the pool: which
device asks for them, what probe donates, how they grow, where the
memory comes from and when it goes back.

Signed-off-by: Alexander Graf <graf@amazon.com>
---
 Documentation/virt/ne_overview.rst | 31 ++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/Documentation/virt/ne_overview.rst b/Documentation/virt/ne_overview.rst
index 3cfc50f788433..16d6b4a2771c7 100644
--- a/Documentation/virt/ne_overview.rst
+++ b/Documentation/virt/ne_overview.rst
@@ -215,3 +215,34 @@ An allocation lives until the last of the things holding it is gone: its
 descriptor, its mappings, the regions given from it and the enclave it is the
 info page of. So neither closing the descriptor nor unmapping takes memory away
 from a running enclave.
+
+Slot pool
+---------
+
+The device keeps a record for every enclave slot it hands out. On a device that
+holds those records in parent memory the driver donates the memory for them
+before the device can allocate a slot at all, and that device draws the memory
+an enclave runs on from parent memory too. It counts both donations in slots: a
+record pool that holds so many records, and a memory pool that backs so many
+enclaves. Neither number on its own says how many enclaves can exist, because
+each one needs a record and the memory behind it, so the answer is whichever
+pool carries fewer. Such a device reports the highest number of slots it will
+grow to, the size and alignment of one donation to the record pool, the size of
+the base donation that pool hangs off, and how many slots one donation to the
+memory pool is worth. A device that holds the records itself reports no slots
+and takes no donation.
+
+The driver reads those numbers when it probes and donates the base run the
+device asked for and one run of the granularity it reported, which is the
+record pool an enclave needs to be created at all. Both runs are asked of the
+node the probe runs on first, through the allocator an enclave allocation uses,
+so a per-node CMA reservation there covers the pool as well as the enclaves. A
+run that node cannot serve comes from any node that has memory, because a run
+in the pool is read by the device alone. Probing carries on when a donation
+fails, with a warning naming the error. The memory pool starts at the number of
+slots the device backs without a donation.
+
+The device holds every donated page until it is told to let go, so the driver
+takes the whole pool back when a probe fails after donating, when it is unbound
+and when the machine shuts down, and the pages reach the allocator only after
+that has returned. Pages the device will not give back stay with it.
-- 
2.47.1


