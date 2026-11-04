Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F1046082BD9
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 16:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R8CZWTpF
Received: by kanga.kvack.org (Postfix)
	id A522B6B05D1; Wed,  4 Nov 2026 11:50:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DDE76B05D2; Wed,  4 Nov 2026 11:50:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 856956B05D3; Wed,  4 Nov 2026 11:50:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C8B56B05D1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:50:19 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D80A6807D9
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:50:18 +0000 (UTC)
X-FDA: 85398024516.16.DD340EC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 38BECA000E
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:50:17 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R8CZWTpF;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793811017;
	b=PjjU8mioN2VE1KjlRJUcj8+TiNfEwD1wHVb7GzLK19eWGmNxuw60MEeAJT3riLS/tSeZyC
	wMAHkNsm65IOTH7TbXba1HGFzRqdK8PD8vPvxk9dakr1nNJ/izRHdodfX8iEVGICu3tX2C
	7Usmyx5ODa1vipKPLtMCTgtXo7D/tUk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R8CZWTpF;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793811017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ZclUos6zhiP0jw7ZtxiOvkyNi6042C1+3TQ0krAy9mA=;
	b=VE0pCuPHUrcfMpZt4bnSVQDCdgWEuN8KMvFZzIn0NR9qjJZNHC9pPPaDPKRSlB/U50mQzV
	E3Aj9pKdUJcw40lJlDArvABTr5n4gsyh1Lod1sf99HJw4PIQlOwOqmghJL4bst3uQd8nkt
	2HWPNW49baG4/9WYi/EtoFpUbJChsl0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BE5AF60A9B;
	Wed,  4 Nov 2026 16:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF50E1F00A15;
	Wed,  4 Nov 2026 16:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793811016;
	bh=ZclUos6zhiP0jw7ZtxiOvkyNi6042C1+3TQ0krAy9mA=;
	h=From:Subject:Date:To:Cc;
	b=R8CZWTpFONfM8ysslHzZ230/S602fbk70oVCVRgZ/TvuOMeIQ7GI6vD87SIXI1mYQ
	 75iazJNg8/NLR9QBUP6Gsh1zib6hm0MCVmcPWkc6vw8AN2/G/sbDJW0SiBMR1FkBUq
	 o9ns2ushtc82dC8yPgrVyBoUTjBudAw//+BKY3NsXznyntZ/xrPyz3TYRMfLiBTuqP
	 DCmw77YRG5DScGSdnyc4fXIyGEjj/5KxcF1lLv1FcPQIdTblIBwgTJ0vhqrALjkeZ2
	 4UftRGr3Z5YeUBFQRB3YeSCLBIty49O0QBe5EkBpLRNKxqoHiz5VPfTvNiKdAAswH7
	 FNtyq+p0022Qw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH v2 0/3] kho: fix bootmem sizing
Date: Wed, 04 Nov 2026 18:50:08 +0200
Message-Id: <20261104-kho-bootmem-sizing-v2-0-b0d1a834780f@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/32OQQ6CMBBFr0K6dpSWAurKexgWBQYYkdZMkaiEu
 0tx7/L9P/PyZ+GRCb04R7NgnMiTsyuoXSSqztgWgeqVhYpVJmWcQN85KJ0bBxzA04dsC2mdGax
 1bpROxPr4YGzotUmvxY/9s7xhNQZTuCiNRyjZ2KoLkWNqyR4G40fk0HfkR8fvbdUkg+fvgElCD
 Do1Jtfx6dgk+tIjW7zvHbeiWJblC3yt8dTnAAAA
X-Change-ID: 20261103-kho-bootmem-sizing-5d6aed47a243
To: Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Chen Pei <cp0613@linux.alibaba.com>, George Guo <guodongtai@kylinos.cn>, 
 Kexin Liu <liukexin@kylinos.cn>, Sourabh Jain <sourabhjain@linux.ibm.com>, 
 kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.16.1-dev
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 38BECA000E
X-Stat-Signature: xa7suerbo5edziadtohekd33fd6f856a
X-Rspam-User: 
X-HE-Tag: 1793811017-670594
X-HE-Meta: U2FsdGVkX18gi+vys+LKAv5zOjLn+JzcUxRFJtGMTJgOAcgscgZ3fl53kRn9YpgfY0RjcAjCaJKpJiU6tWPYrCDyE7R5gTeRY/yypnw2ySZLE/b0U+QOJDup//nBPByEcXQE+KHSzY7oLVSsP1B0+515N5icgYhTPVqSCXIhBYBWblcPfeckwino7gzG3jj4KNJf5v9BcEpwR9uSWZn5jIOvMubbY5r6QGzDS+qZc19SVLa1M3wh1dmQCdCstUo1vUOmmkSzP7rzkV7HleWm+Zgu0kA3MLuovjUcl2Glc+QUwJSrpY21GHComasmqET5cKe5i4lsVRIY8Mi0nXhajuiqDg157T1fyaDEs2xO6g0U2/NwI2W+Am15SpX4QibWVbDot/4+tp/Lp8OTSm3xSTHYQeC7AFP+PD7s7vBi9GVWWd5Fv4lVjG8GmtFPGelpF1n1WA9hygdZQ913VHG8Z8hY7MGG8fOyuzJro3lwZS0d5mM3F/pPPn7103bExk7s5MrXgerEoOoubYDWQm4OSDgweC2RvqCG2YE5ai89oTzsI+IIOnPDdgEXLVayWCN/yT0lPG+tcodQJuNX5zddKkcvVIXTBfPhfcGaGxiql+4zaILUbo3I034Od2Rq37nSAWqWEySyvn6rRQB9spQeDjMNEI9GVjM0Uweozj8Pjbt/EeEpuYOnMxyplMIEMIUhMuLAu0nm/TQhivCZeMKuc/jIXjFzypt4hOQ1/e9Ipz6uCXKJ8TBZmDhxD7vT54Cx4nJclslvclTF76dAeawyBxsiyZecMXGaLGC5bn6VhA0owY9A8RJLWtg0K9cWfvh0Zgp1Fm6Dcq8xfpP9PQ8IGATgXKc3DhAWVIeYJn2CFQ6eqnPVPBF7U163U0TfNoHsoIZ4/LzGJ+QtuTm9xzMhTnBhoe9wUzpWB4eFRafkAHXIaHKPdaAlkF9yttXuhTrsMKf+O2UcTS0tjPlw6yE
 aS630HdV
 n8jc0juIOBJ1lNdQhYKp0Uqs3Qu9rrJb06COdZnCa30tz0RG6clDa/RxNOLjlU5gWd5sLIXQKF9aWu9uIvPalZ0rPhKwuRQmExwVrLwsBydPRShWYcFrMv3J70uq9Gdxi+b0ZQPvTjGXZGvflB0qLdqpaoa9hnYEAOGiR1gXTgglNLbVnFC8axDZps4zuq2/QyaILjc5bsHWk0AF2S/EhneLmy+8AkYgYS7GeLew1IqzZGIbK6YTgA0diBtBKsGsZAzaZDKNlkKKdLNWPhaWR/mAqARqkruzd90LeKQOT5rR8E9RMWYuz2uFvm6DAod41310yRlCfd1stetk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

There were several reports about issues with KHO bootmem sizing.

The bootmem areas are sized from overlapping views of the memory reserved
in memblock, so on NUMA systems memory allocated on a node is accounted
twice and with CONFIG_NUMA=n the lowmem and the global areas are accounted
once again in the area of node 0. Besides, the lowmem and the global areas
are reserved even when they are empty.

The first patch makes kexec walk the bootmem areas in address order.
Otherwise kexec on arm64 may fail if a small area at the top of the memory
is the first in the list, and with smaller bootmem areas this becomes more
likely.

The second patch skips empty bootmem areas and the third one makes the
lowmem, per-node and global areas cover separate parts of the reserved
memory.

---
Changes in v2:
- add a patch that walks bootmem areas in address order
- update kho_bootmem_cnt directly in kho_reserve_bootmem_area() (Pratyush)
- don't reserve the lowmem area if ARCH_LOW_ADDRESS_LIMIT covers all
  memory (Pratyush)
- extend the comment above bootmem_size_update() (Pratyush)
- Link to v1: https://patch.msgid.link/20261103-kho-bootmem-sizing-v1-0-45aa74098f34@kernel.org

---
Mike Rapoport (Microsoft) (3):
      kho: walk bootmem areas in address order
      kho: skip zero-sized lowmem and global bootmem areas
      kho: fix bootmem sizing

 kernel/liveupdate/kexec_handover.c | 212 ++++++++++++++++++++++---------------
 1 file changed, 128 insertions(+), 84 deletions(-)
---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20261103-kho-bootmem-sizing-5d6aed47a243

--
Sincerely yours,
Mike.


