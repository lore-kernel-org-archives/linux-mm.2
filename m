Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A50CEEBFD37
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 10:47:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C9E26B0093; Mon, 13 Apr 2026 06:47:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 153836B0095; Mon, 13 Apr 2026 06:47:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0F1D6B0096; Mon, 13 Apr 2026 06:47:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DBCA96B0093
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 06:47:05 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A68E41A011E
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:47:05 +0000 (UTC)
X-FDA: 84653205210.02.5828266
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 21386160009
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:47:04 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WGpqAMZw;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776077224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y6u5wulhQjVVN5bFQYC0fomjLXzk0fpwG2XuHYh9Ntk=;
	b=RlIce4ixf1K4gJlf9JCKayYGJ6/rDImasMkMDJ4XS77r093xbI54kmTL7v2XnYQEvSNudU
	bJoBkOOJajYIFsjOBnFxvOih6YPytEsg+XT5W4w+9ku8kkYgBji4vSw+YAgkbOriqiBXt0
	fEnJ7DOrbD6II6g7IzRwVfzF6unBIBw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WGpqAMZw;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776077224; a=rsa-sha256;
	cv=none;
	b=K1JdDm2m09tvuI8GhDvxf0TFgWP8e/fFxdqcPGLDhcohVB6+UDz1Ty+Pwb0H0heeDfnBsg
	amgAsN1u8bzSgnrOzL2owozZavPfo5Q9LRGVJ9Usso+BnTtjmGarSo0r6TZU90SjIjOUat
	vEzjOoVBxnozrIW07GZd084Apl/4Ho0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8D37E6132F;
	Mon, 13 Apr 2026 10:47:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BBA1C116C6;
	Mon, 13 Apr 2026 10:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776077223;
	bh=7BjG2iui+OOkytqZRFgX73f96pAwpD0HBcDk3D+4z8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WGpqAMZwqLk55Is2eL0eB1vwScZ3SQzfPptc0tEa8YnuxOBvqK65DmblEZFWTFUls
	 BAZsmbz4EwZnRjINLzmf6p4vQA+g6H1HCXtcRNir7/ziXHSBjjxdT/GitpWpfrgmlJ
	 F/Q7Q6N+6BN5EadXsfECMVTtel1Eci3z//R6Yz+w1J9Xj7l+O0I2jps7H+urDFTKVb
	 F2MAspwFUMtBEl08yUiymrX2HVgZYURM/kCxKxCgvR1GQuICN8y6r3cSAw1l3EgqiC
	 4gQtAVkNN6Dge8uqFoVA5zzJ0d9vgj/ROCfcXfwr/qng/RG21jtSoiAqAcpsDYvUwE
	 CORrZMuUKWTuw==
From: Mike Rapoport <rppt@kernel.org>
To: linux-sh@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Mike Rapoport <rppt@kernel.org>,
	Rich Felker <dalias@libc.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 03/10] sh: mm: drop allocate_pgdat()
Date: Mon, 13 Apr 2026 13:46:41 +0300
Message-ID: <20260413104649.852228-4-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413104649.852228-1-rppt@kernel.org>
References: <20260413104649.852228-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 21386160009
X-Stat-Signature: kpmzh74kaj1fixyusqjpy6xz9kb315wi
X-Rspam-User: 
X-HE-Tag: 1776077224-657690
X-HE-Meta: U2FsdGVkX197TgXfhVEuB0seZLPfCKQiEX8E07F73zSECIh4RpQb7nxHR0EMkffIycmmiZs3vMc/jmtH2OqIrTAJYyw+Qk07ByN6r1jNEtvnPBFxaMnavP8Ji9BzIgsXPdM+CWgmHNpOkcd200Q4tZHWAibwyO8q7L5ubgFjFxMeDu6fc9N6c+exZfjtXDGDemFAv1NQ/oywnhCVRW9bgRHzoMjD9v4L7j64mJAZtSWoOWrYoP4hWwjKr4aWs78OG2swQCtlDH6xTKwqA+RJV5ja40B+E0/GJqe4xpLCN1RIqBZPCHz3isS1ra397g+SLF52gvp0Oj9eBt2PURWWe133rmz96kF9sT7fgUr5gAx5dz5xvPzMZ79nfiZgl4ExJcZVGy6UFfvwL6liHTwEShx5F0Joi1W10XfI7kOWc+ukkJ5g4JzBd5WbBXpbxgsHSgypKgdJpe0XrdSrmRpoVAQnmFuiqzj8YYuWbubF2dbC0+IP8u80dj64UTzMOb9At2BB6Oemh08cbWiY4oRo1z5bWAotSTpPR6H6W7kLSXCk/Vu6rwLdaqepHNUP9Jad+02tUnqQS5KsoV7JdeLnmtMxSl4z6EGmdJxxLUs2Bf3cufZF9Rz9P+mixqvfAPB9nyoX6S2cCTEThcBe7LBYVrcd1Iudi8qKJJZMtX353P/20wwzvAaLbgN6f0wv3RoZyiYNsMINuXUS1QH94dGUduyk+BlLlWH0ZmYj/aFJzio78ONHHdZ/J+0zNXU6Bs7tiz2uKqgK4hv0XShBAW1pA3HQOw/A75Br0xoLW1nkO/UKqS3yjvcpgeE3FhEwmyMz0bOdYO8MyOZJdvuQyHqqignjA6Y58hTT/kzGnY8OK8+I5tL/YAMOIDQCUAgrNxoqMI9MyGJ2vePKYEz8YnPP0jBtOJ0QBaQ8Q+SuSqWRR6rxdcLiwY1ReOftSdHobEhMDhXnO1S6ZYOzFxCuOLK
 ynqzaTd7
 MaVybecFuUq1UdKJi4cf7adPZqlqUinx7TgOZ7AhlHO7LtZLZfpKfIhIvywvwGNZkU4EtS0lxgQ+vAr/qTXEcUjY54JurEhGFQrvwSbu/3YRXXcsGiNuuuWTl40mpiP+Ajeqa0rDifugbFru4Y8Qyioy6aBPk5MNF82gaU6tGo8WdANoOHshM9SDeYsQzRReCcdavvH/VOtHikR85/yj26cLfePG9SiyvLbpOJh8Ief4obcPWV+C9A69WiOuxgwPzar4a1DWELff3zPZoGcHON1bRmA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

allocate_pgdat() function used to allocate the node data structure and
initialize its node_start_pfn and node_spanned_pages fields.

Without CONFIG_NUMA there is no need to allocate the node data and
setting node_start_pfn and node_spanned_pages are redundant because they
are anyway overwritten later by core MM.

Remove allocate_pgdat() function.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/sh/mm/init.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/arch/sh/mm/init.c b/arch/sh/mm/init.c
index 464a3a63e2fa..977392b478b3 100644
--- a/arch/sh/mm/init.c
+++ b/arch/sh/mm/init.c
@@ -199,20 +199,6 @@ void __init page_table_range_init(unsigned long start, unsigned long end,
 }
 #endif	/* CONFIG_MMU */
 
-void __init allocate_pgdat(unsigned int nid)
-{
-	unsigned long start_pfn, end_pfn;
-
-	get_pfn_range_for_nid(nid, &start_pfn, &end_pfn);
-
-#ifdef CONFIG_NUMA
-	alloc_node_data(nid);
-#endif
-
-	NODE_DATA(nid)->node_start_pfn = start_pfn;
-	NODE_DATA(nid)->node_spanned_pages = end_pfn - start_pfn;
-}
-
 static void __init do_init_bootmem(void)
 {
 	unsigned long start_pfn, end_pfn;
@@ -222,8 +208,6 @@ static void __init do_init_bootmem(void)
 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, NULL)
 		__add_active_range(0, start_pfn, end_pfn);
 
-	/* All of system RAM sits in node 0 for the non-NUMA case */
-	allocate_pgdat(0);
 	node_set_online(0);
 
 	plat_mem_setup();
-- 
2.53.0


