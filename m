Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FACCD47CD0
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 11:28:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04F916B0093; Fri, 16 Jan 2026 06:28:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 027D46B0095; Fri, 16 Jan 2026 06:28:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E92C36B009F; Fri, 16 Jan 2026 06:28:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D2AA46B0093
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 06:28:00 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 799C416061E
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 11:28:00 +0000 (UTC)
X-FDA: 84337602720.01.9C7076D
Received: from pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.12.53.23])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4F425C0003
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 11:27:58 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b="Y/AeMyhN";
	spf=pass (imf10.hostedemail.com: domain of "prvs=46959d345=epetron@amazon.de" designates 52.12.53.23 as permitted sender) smtp.mailfrom="prvs=46959d345=epetron@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768562878; a=rsa-sha256;
	cv=none;
	b=I/QImdSCwES959y26ejt+ukTCHeaYC8TQplCcKxNjBjOeX3AtGE8EYvq2Sxk7QV7859j9k
	LplwER6vna/m590GyRzYkDjVN/Ie7nwL3GSSZH94Tnro6sSshQBG1bvvUoPUJb6XgExOYu
	R2Wce3ogSq3U5/kh6vovVzttce0Bjs8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b="Y/AeMyhN";
	spf=pass (imf10.hostedemail.com: domain of "prvs=46959d345=epetron@amazon.de" designates 52.12.53.23 as permitted sender) smtp.mailfrom="prvs=46959d345=epetron@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768562878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=qG4MzEbXGT3z4AyiZSiGB/Kf0T7fme7tElgC/AQRTv4=;
	b=e4/F3TsdVIzbukhWBKpmvXqHv1vDMrbTlURrcyIJmDEpV37FgrIQS1e6nXOrDKJlXbJ68H
	YI9sWeopIwGTP7nQs63NmBRDFRNuSRUPLlWRHjZdkVl2Hysf+lk2lwXFVCX6/BEm9kATCE
	duiFWGTwYdyUbwTDsBSG3jKg1tsxGPQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1768562878; x=1800098878;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=qG4MzEbXGT3z4AyiZSiGB/Kf0T7fme7tElgC/AQRTv4=;
  b=Y/AeMyhNBwN1WyAnmihqtg3exphu870gfF4dESKthFbYC/qQKt8lVWHX
   L+Qhp2DJW5zuRasRs3fJhhC4y5I6bQzQle8Vpp1pR+ZEswHbeL9llSsPL
   Hvnbk1KAg9Craawl+N271ZM0AJSkh0gaI+ANoKvu0q2zb24cKNsH+xGJF
   AJziPhMyI5ioxpVPp/dlY0mSiqFXR/FQSo84HhRzZd7F1w+udA5xVD60k
   HORigfMnH9eOqvoKA2P60zccoxSYqZfPI6vCmx4mqrlz7mDMp+TU2/Fi8
   a8NzN8CNG5ll1MDeBeiTH43o5NrdEJVoYUviz95ph0P43zHxsSmLjrgIL
   g==;
X-CSE-ConnectionGUID: kYRm3ihZSdOkaD7jQUuX3A==
X-CSE-MsgGUID: CLKyTbR+QlGW1oobF33dUw==
X-IronPort-AV: E=Sophos;i="6.21,230,1763424000"; 
   d="scan'208";a="10862801"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 11:27:55 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.105:5994]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.60.191:2525] with esmtp (Farcaster)
 id a6631774-5337-46bf-80a0-011e601a8a40; Fri, 16 Jan 2026 11:27:54 +0000 (UTC)
X-Farcaster-Flow-ID: a6631774-5337-46bf-80a0-011e601a8a40
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Fri, 16 Jan 2026 11:27:54 +0000
Received: from dev-dsk-epetron-1c-1d4d9719.eu-west-1.amazon.com
 (10.253.109.105) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35; Fri, 16 Jan 2026
 11:27:52 +0000
From: Evangelos Petrongonas <epetron@amazon.de>
To: Mike Rapoport <rppt@kernel.org>
CC: Evangelos Petrongonas <epetron@amazon.de>, Pasha Tatashin
	<pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, "Alexander
 Graf" <graf@amazon.com>, Jason Miu <jasonmiu@google.com>,
	<linux-kernel@vger.kernel.org>, <kexec@lists.infradead.org>,
	<linux-mm@kvack.org>, <nh-open-source@amazon.com>
Subject: [PATCH] kho: skip memoryless NUMA nodes when reserving scratch areas
Date: Fri, 16 Jan 2026 11:26:35 +0000
Message-ID: <20260116112640.64900-1-epetron@amazon.de>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
X-Originating-IP: [10.253.109.105]
X-ClientProxiedBy: EX19D043UWC002.ant.amazon.com (10.13.139.222) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4F425C0003
X-Stat-Signature: s5s9c88e1hp9dfqan696ewrngynr41p7
X-Rspam-User: 
X-HE-Tag: 1768562878-29600
X-HE-Meta: U2FsdGVkX1/RjYjBq4S5YLsQ7qEIr7L8dnQjTpf12ejnJ2cECaE2Zi7Rsylxm3NCwnKRHFXsk2TASQjmhrGVzT7wTdNpeszeA69QgvzvjH9jDRFGqV0rQLORgYtut6TvF1LgDw/sfjlYss6wOKAg58yojrI3Oo+sdNNTenO8Jsz6t2kWsn+iFsJ3ShLgeiJuNHs+NvkPI8bLmtpLv5yqI8AfGTZBjDGyjC7I/ipe/ymuQHUZqbfqMNG7SNFQOX96zr0nkBmMo0ZMoBo+fF6SPhwz+fg3TP0MRQUiW74J/AnDpVnpZRv5ywEn1Mbe9WbyHx0XRJYmqW5V1D7dsN/Ar17rsL428kyqO+SOCrfbSaGNS2FpBQlvRXNqz6zagU+LmLC2sGzEPa5eFAQdomK+rP7X1jRGLrIUzcQvcbGT2+1dKLnvd/M+9/VjcbwdN069Y2rLBOzZXSyh8+eBzfiYqde8Sdq4kdR1ofCQZLDy21qQiC//2WtXOMdBdj/tkRJTvhgFuRPA8UT0PuxLYHK/nL5GUfI8DEJoiTGmMsL169b3xQQEyTW/igLtOW5y3ofzmlL1iXYUhXbvV7CAZrD/HiOyMRddLrMDRsS0tBCpts69wAb9wRbKt2dJbs4ev3PPOL+ntLOEsllWZO4u6caITWqsAfH29NgSWZE8bm+NBuWPB+QZIpSOsoPw8klZNW5AIrYP+WzkX4/Rfc6FrpOa2pnVSOiYIW02S5tKJ9al8VhsyApNjudfbXSM9CuNLCzFDg+xqJz6cu86rp5nn8EiqIm8EwZvEBaH/lWgScx3lW8K128lkMIPRw28wyl58gPnFa9lk5xYX4B90m08gU1e9/xlO6kfMoNjqYMgzIlWJyRBqDP5ThsnmwtaRTILXx7r156ivD9oLYpQ7M3Ci1MfbGNf7o5wEw/5h4SXxbNbN6gvR6o8tLsI307NBT23zn1VsPLeLsRL16OYfscbCgw
 jph9cxTV
 nN0Ha759FUSCL0GJYaGFMBIqVAweIL2anqfjxJTHdXhkOOeHCXUxuyNG++bHuxYQ8jwA630uHXDlGJgqRM69x3FXFHWFvOJqBYwmOJd8felS0GBZyoemmz+2jPMYAPsCTRaJsL6Kzz3lCh6JmF9TTA9AI1AfFh1sa/ICCy6kj15VccR7zTA1mX99DFznnMw44FScrNNco9dSyWjeDQJ3dZbWm/UBBHVp7Dw0b4wBB6SXTHWogPSQJX/4BirXn9+VbWVdAa9YoDTRM5pPxPQohlZa+piTTxqBIYGZzZwYF05JFpcNmxrM0C30DMVCgxELi/Yf2o8TxttskltC0zkxQMbmLj+Tfe8igPL8VcD5HY9Ou7c+4+SaX3f0K9Pd5Z3CQM5YZ+YMzq9kllOBOtuzurX4D70n28NNXc6YRUMmHIfGrJfH+Dv5G1w4G0XmQIDTOyZV+qWKQs2qE1Lc4E7SPlRBy7+VWk3683P40R7cgO8p+UXhshqPK9a+R81OdJZ/CUOFTjdHV1kb2PR7YMl8F0SHI2oFbDxvTg27M
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

Fix this by introducing kho_mem_nodes_count() which counts only nodes
that have memory (N_MEMORY state), and skip memoryless nodes in the
per-node scratch allocation loop.

Signed-off-by: Evangelos Petrongonas <epetron@amazon.de>
---
 kernel/liveupdate/kexec_handover.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 9dc51fab604f..c970ed08b477 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -623,6 +623,23 @@ static phys_addr_t __init scratch_size_node(int nid)
 	return round_up(size, CMA_MIN_ALIGNMENT_BYTES);
 }
 
+/*
+ * Count online NUMA nodes that have memory. Memoryless nodes cannot have
+ * scratch memory and should be excluded.
+ */
+static unsigned int __init kho_mem_nodes_count(void)
+{
+	unsigned int cnt = 0;
+	int nid;
+
+	for_each_online_node(nid) {
+		if (node_state(nid, N_MEMORY))
+			cnt++;
+	}
+
+	return cnt;
+}
+
 /**
  * kho_reserve_scratch - Reserve a contiguous chunk of memory for kexec
  *
@@ -643,7 +660,7 @@ static void __init kho_reserve_scratch(void)
 	scratch_size_update();
 
 	/* FIXME: deal with node hot-plug/remove */
-	kho_scratch_cnt = num_online_nodes() + 2;
+	kho_scratch_cnt = kho_mem_nodes_count() + 2;
 	size = kho_scratch_cnt * sizeof(*kho_scratch);
 	kho_scratch = memblock_alloc(size, PAGE_SIZE);
 	if (!kho_scratch)
@@ -674,6 +691,10 @@ static void __init kho_reserve_scratch(void)
 	i++;
 
 	for_each_online_node(nid) {
+		/* Skip memoryless nodes - we cannot allocate scratch memory there */
+		if (!node_state(nid, N_MEMORY))
+			continue;
+
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


