Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8532CA5FD1
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 17:59:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19E1A6B047C; Tue, 20 Jan 2026 12:59:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14C436B047E; Tue, 20 Jan 2026 12:59:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 075856B047F; Tue, 20 Jan 2026 12:59:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E8BA06B047C
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 12:59:29 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9968BBAA8F
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 17:59:29 +0000 (UTC)
X-FDA: 84353104458.29.28D7797
Received: from pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.12.53.23])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6AF65C000A
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 17:59:27 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=PvkPagIF;
	spf=pass (imf28.hostedemail.com: domain of "prvs=473b322d2=epetron@amazon.de" designates 52.12.53.23 as permitted sender) smtp.mailfrom="prvs=473b322d2=epetron@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768931967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=jwrVgQu8T1zQqFt9YAueQy5DCsjrQY33U9ppp5mocfU=;
	b=LOaFTh3dqAxWO1eXPviQneCSGGfCd0WhrTU0tKsmBvePhDVnvpoX4h/lzEpCuX0MSaZIL/
	nLpKQPcXQEt5gptMKXdiCZ/N7BRg4geKajGeiMC6xWvDBepnhox9eja9rmT3qGwz1fIK4N
	AD6ItaWJSs99/CCf6j1JeeL2lkYv3bc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=PvkPagIF;
	spf=pass (imf28.hostedemail.com: domain of "prvs=473b322d2=epetron@amazon.de" designates 52.12.53.23 as permitted sender) smtp.mailfrom="prvs=473b322d2=epetron@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768931967; a=rsa-sha256;
	cv=none;
	b=Za9Dv/YkcknclmQBrU47LfFbIBlhTzkto5scSU604XOB31jw45Yxv2cvUgerAC1uupseyy
	NVNY5ND/IjwCFPUGsdKfABOn50ILXmZW2kPve50eReOxhaS/u6a1AslW49jAT2lfVZ7jeR
	ZhcBoZuqMHXS9l6CIIyAUlTZLCouR34=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1768931967; x=1800467967;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=jwrVgQu8T1zQqFt9YAueQy5DCsjrQY33U9ppp5mocfU=;
  b=PvkPagIF17YBVMSINEn8eWLc8q1cAjmp2qvf8yu2ZwJgqiD6nWDGlQ2B
   H2ftG/qjzN5vAJvIHh0QflQEGbTrcTNdFsdGT1s8yt2Ha64ezOdCYc9zW
   fiknjq1XU3aKS1XsmPk86rRByXlwGZmbUHHpbI26srUpm8wUEkIgS2LRm
   gRTPd82K/ikBKTcjFJMLGfFOTMQZL3mV2/aX1266kzzmGi9y8Gb2TEbLp
   OJxJab52B54QqDbpeozzpcgxXbwwwko9YwKlp2Av61OK35+D5C/0NU0+h
   SL8+qJvpfHwlpq1zSposgely6Fu/TTk8dXp18qabA2goOl5W3AzoE1luI
   g==;
X-CSE-ConnectionGUID: DOz3H3uJRdeGXpuxql/bYw==
X-CSE-MsgGUID: h62isw/sQbqrB5itx0IYpw==
X-IronPort-AV: E=Sophos;i="6.21,241,1763424000"; 
   d="scan'208";a="11095148"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 17:59:23 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.236:10556]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.14.244:2525] with esmtp (Farcaster)
 id 1f2c0798-ec03-4bf6-a1ae-8006272cbe1b; Tue, 20 Jan 2026 17:59:23 +0000 (UTC)
X-Farcaster-Flow-ID: 1f2c0798-ec03-4bf6-a1ae-8006272cbe1b
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Tue, 20 Jan 2026 17:59:23 +0000
Received: from dev-dsk-epetron-1c-1d4d9719.eu-west-1.amazon.com
 (10.253.109.105) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35; Tue, 20 Jan 2026
 17:59:21 +0000
From: Evangelos Petrongonas <epetron@amazon.de>
To: Mike Rapoport <rppt@kernel.org>
CC: Evangelos Petrongonas <epetron@amazon.de>, Pasha Tatashin
	<pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, "Alexander
 Graf" <graf@amazon.com>, Jason Miu <jasonmiu@google.com>,
	<linux-kernel@vger.kernel.org>, <kexec@lists.infradead.org>,
	<linux-mm@kvack.org>, <nh-open-source@amazon.com>
Subject: [PATCH v2] kho: skip memoryless NUMA nodes when reserving scratch areas
Date: Tue, 20 Jan 2026 17:59:11 +0000
Message-ID: <20260120175913.34368-1-epetron@amazon.de>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
X-Originating-IP: [10.253.109.105]
X-ClientProxiedBy: EX19D036UWB002.ant.amazon.com (10.13.139.139) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Stat-Signature: b91e97kcgy6wf11rataapbnghf1yuwoy
X-Rspam-User: 
X-Rspamd-Queue-Id: 6AF65C000A
X-Rspamd-Server: rspam08
X-HE-Tag: 1768931967-831916
X-HE-Meta: U2FsdGVkX198Vx0Za6oywO7XMpP+F/yYiwiCywndr1L5ZSgDrt62eN0Eg7NvuDJG3UdJIelA6o2JIzMl4MeJTo74PBp9yQ9k+s6gJDRyz5aj0h/Rx9u+sH03KTKRIF7nwL2Sbzn1g4mlOaCsh2uJz9AJerjlp5AS4bDkCgIsrFEZI2bGEkitSznBXTh048DAkPZXzGCYq4xr1uRsvh6DTNHCKuEYGZrhQWSuFahPC1hIQCM3nsMqcvtcuqtfmQaHMyOoR6W4fejKSEsc/xMrs540i0mMgZp9qErt4l04HBfsC1P8tBkOluGD0ItPS8e0oWGOsCiVsi9ltgXfZXJraw8lKYLjMM04YqFkoBe8OIRlOLkV4mXfAbgLEu5Y+G334D7pldPeK/mEIoWMvuoRg2vb6drJbM6dnwLiK+Qx7yML5r9ij0z5mNNTgYM3EGoh1gorL1830PPu4wP2rGsfUGX31Dvhq5i4PndpI8NzpL5JPi4TnG5cDePEE4tI09QS0Y6qYWKi9NP1RdMxGJMh3319Zh65OPgWGVxNmJmF5Melalhg84nxw5j8mubbN5+ooOl8JhxDtNxb4D6k7CuFbkXRFwY/D+qHoLOF6xEdlXwYgA+8Kcc1XbVe+gUAY17lujj4qh5MKCVLZ2UsQNUqbEBikKGsA3H9u0ptyr0Ya4KkbK15UTRqk4ZAahiXtAvvMjCCrnNJtdE+GHcgQAu5DHJngOPi1+kdhZj8mPzPxWXqbFr32Rw9G9jgiWevfPXa0sPjdFa6myntFxZdlbDXZ6iclzO+pgSV5A2e2vpW2Y7B6FclLb2vUR7i+H7VMn6hnjNgQS/vlATwCvpAklQa2YrL/5emnNOrLxRmlFOCVhDyw/XDmoTGJNYyFbsGH4Nja/nbfbR7mwvDMxxdQBnFbtVWpArQ+8+6o6BUO9D7XBU1vNbqjaavYU2yQipUpgtknEEAazTNzgV/mE/cXsd
 XxCN7VPf
 etJfcfajlxX3MlSyg4/iOqQGAMF9uhiLMG0qkKK8SUbllzNUfG1tPaKvOqI3E81DhWpnIYTE+kJC4z2uA1a81vfNSOEEDVY0OGCIywpJNe6YhKb1/fOyKoZkDX93QtxubJktsoVoRX3MrOjCAw88RVkwtYz6r3jy4Pe+sRgIhf088cBadLAPXeBmP1CvsYc6MruWu7ky/UiM/SIIEXQpDoksphesXWvVg1kYDsz74rvBQsQcBPYO0o6Ie8xKaUMiHxMRE5dAZDdvYc5wCMS48Wc+MPn8LCMUue6oMhsFvSu/ABLqjLYsy+84gxro7vd69uye130ep+ca8CaCgqTC/5M7cujOEbfXMn06TXZBd+p/Vuhcb4EwFViWwbX35u2FwNO4Ji3RhfEWsq/r+0nYL0ojGXYA7hINHH2CmcbyKp/s2kwiBgjndCp+7j4ntPIfXn0lgTQNOxgdXgDw6XROJOV3z08Ry6DHvWpZH/+6LLhECV3uRdUCen43wt0ALLerkOnE78RlDrcd2pxtj180VpM8zv+5IJXDxsU+F
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kho_reserve_scratch() iterates over all online NUMA nodes to allocate
per-node scratch memory. On systems with memoryless NUMA nodes (nodes
that have CPUs but no memory), memblock_alloc_range_nid() fails because
there is no memory available on that node. This causes KHO initialization
to fail and kho_enable to be set to false.

Some ARM64 systems have NUMA topologies where certain nodes contain only
CPUs without any associated memory. These configurations are valid and
should not prevent KHO from functioning.

Fix this by only counting nodes that have memory (N_MEMORY state) and
skip memoryless nodes in the per-node scratch allocation loop.

Signed-off-by: Evangelos Petrongonas <epetron@amazon.de>
---
v2:
- Removed kho_mem_nodes_count in favour of nodes_weight(nodes_state[N_MEMORY])
- Use for_each_node_state(nid, N_MEMORY) to loop over nodes that are both
online and have memory.
TIL: Nodes in N_MEMORY are a subset of those that are online. Thanks Mike :)

 kernel/liveupdate/kexec_handover.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 9dc51fab604f..979ebaf015bf 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -643,7 +643,7 @@ static void __init kho_reserve_scratch(void)
 	scratch_size_update();
 
 	/* FIXME: deal with node hot-plug/remove */
-	kho_scratch_cnt = num_online_nodes() + 2;
+	kho_scratch_cnt = nodes_weight(node_states[N_MEMORY]) + 2;
 	size = kho_scratch_cnt * sizeof(*kho_scratch);
 	kho_scratch = memblock_alloc(size, PAGE_SIZE);
 	if (!kho_scratch)
@@ -673,7 +673,11 @@ static void __init kho_reserve_scratch(void)
 	kho_scratch[i].size = size;
 	i++;
 
-	for_each_online_node(nid) {
+	/*
+	 * Loop over nodes that have both memory and are online. Skip
+	 * memoryless nodes, as we can not allocate scratch areas there.
+	 */
+	for_each_node_state(nid, N_MEMORY) {
 		size = scratch_size_node(nid);
 		addr = memblock_alloc_range_nid(size, CMA_MIN_ALIGNMENT_BYTES,
 						0, MEMBLOCK_ALLOC_ACCESSIBLE,
-- 
2.43.0




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christof Hellmis, Andreas Stieger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


