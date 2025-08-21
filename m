Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C425CA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 22:49:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 796E1940009; Thu, 21 Aug 2025 18:49:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 747AF8E0056; Thu, 21 Aug 2025 18:49:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 636DA940009; Thu, 21 Aug 2025 18:49:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 517388E0056
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 18:49:31 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EFA561A038F
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 22:49:30 +0000 (UTC)
X-FDA: 83802257700.22.B37A12C
Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	by imf04.hostedemail.com (Postfix) with ESMTP id 02CD440005
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 22:49:28 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=bur.io header.s=fm1 header.b="m aERdqm";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=UktnjxML;
	spf=pass (imf04.hostedemail.com: domain of boris@bur.io designates 202.12.124.148 as permitted sender) smtp.mailfrom=boris@bur.io;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755816569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qz8k9Dq+BLY/ejp2bsbmNLU/oeah8tJNSPR8Lkv6lzs=;
	b=DZcuyEHPsyqmVnx4UAGK2WEYmfAzHuWyRNm/kHzW12AOFoAmYQJXPLWlFIvI/suPvAp7Ja
	qvTVZXmFc0xqbAkaJAnM6tMJFEPDMRiAwTyo7koRowxePnrB2h6pwZxhVVAAE0hoVybt84
	fFHlCOfKuwr6LKkdr/tGbHEAuJD9eFI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755816569; a=rsa-sha256;
	cv=none;
	b=spRgLERG24Ffc7zM0CM1sl8rSmzmyUdwggwweI2M22j6MU1DnOmR3EcphBe2lEgGutotcf
	veOJhROADeumU5qukq/r1uzp8MF8ZXpRs1k3leePCFGXw9GX5H6UslxK6wlprMl3SOKzHc
	QfVf0iRJjzw+6mQIBGB3DBNfwgKSiR8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=bur.io header.s=fm1 header.b="m aERdqm";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=UktnjxML;
	spf=pass (imf04.hostedemail.com: domain of boris@bur.io designates 202.12.124.148 as permitted sender) smtp.mailfrom=boris@bur.io;
	dmarc=none
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfout.stl.internal (Postfix) with ESMTP id 023491D001EB;
	Thu, 21 Aug 2025 18:49:27 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-12.internal (MEProxy); Thu, 21 Aug 2025 18:49:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1755816567; x=
	1755902967; bh=Qz8k9Dq+BLY/ejp2bsbmNLU/oeah8tJNSPR8Lkv6lzs=; b=m
	aERdqmL7f+UgTVNEijJ8MTqdc8nis81Cf1Y7XVkmII4pOxGTTB1MXZb+8K/yS0V1
	lLjajlwOXkflisOLgfiqq6ycEpoMlhyVzIEu7kMj5WQ92bsKlOMWBTEIbpZV/8rT
	i31yXeGs8JPrMvgwUQIV5Wy6oqrGcZCSd/E3NqtiCGs2p1IGOMOlFKERnf2psfXg
	uBSili3ULneGLFReQKDxWxKYgsSODJlUj4G4pOgh8bA6FwNfLzTQFMjYyHE7at/7
	ZF65N6fIZfxH64Oc/+IgPLT5W9Vfj7D8oxxVbrBvySl08xez+vKUWLYLFBkcnaWP
	17Jvvt3WaVVXGw4ly7qwg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1755816567; x=1755902967; bh=Q
	z8k9Dq+BLY/ejp2bsbmNLU/oeah8tJNSPR8Lkv6lzs=; b=UktnjxMLIEn2L57Ys
	NGpTai2dIdF6PhZd8XzV1hgC8oAjZ7yyHjD5qHFIRuXKgHm6cAm2t43sJ99Vu8yz
	wGgod6uXOf+oW3kL5843UIPORr6Q7kbpz4gId+BqTq6cQSO7lmp8XgSzDnMSCrfn
	X8z6UdTyqIY6fD3RdUQw4wAeVfKZ3ZDBMuTb17iA3XBH3u3CFY1YhTyAM34ZxtS3
	EZ1WWht36gAg7CETYzdBd1kqEZWMwhIFTo5iCN88cFAgAlA/eafmmZf6CDroPAEs
	24O/oRGH/0gHNzNLmnlcrzTAkKKWIy0DSL1HZdoin6NTjrIF2Fr+ifNatDFjl/M8
	c4/UA==
X-ME-Sender: <xms:d6KnaDCzhHnvfHvuHCCL4qcU-NFiMgKmNsAm9wT41e2w8tTXHyyLpg>
    <xme:d6KnaPABSA3S2Y7j2HymIGkpODH7YgoJEccFDlUoueX-i2sszJxmUb_PuIqcgigjL
    8M0YRcoHMdWNEYJn00>
X-ME-Received: <xmr:d6KnaNpEpW04h_Y6NuC4ZIfjOSy2tTzaWe7Mw5y4zGdCT8YFRHdMqXE1IimkZIB4w5XBO7mYATqs6768vcnOuTLWXRo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgdduiedvfeegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhi
    oheqnecuggftrfgrthhtvghrnhepgeduteffveeileetueejheevveeugfdttddvgfeije
    fhjeetjeduffehkeelkeehnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepsghorhhishessghurhdrihhopdhnsggprhgtphhtthhopeduvddpmh
    houggvpehsmhhtphhouhhtpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgu
    rghtihhonhdrohhrghdprhgtphhtthhopehlihhnuhigqdgsthhrfhhssehvghgvrhdrkh
    gvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrdhorhhg
    pdhrtghpthhtoheplhhinhhugidqfhhsuggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdroh
    hrghdprhgtphhtthhopehkvghrnhgvlhdqthgvrghmsehfsgdrtghomhdprhgtphhtthho
    pehshhgrkhgvvghlrdgsuhhttheslhhinhhugidruggvvhdprhgtphhtthhopeifqhhuse
    hsuhhsvgdrtghomhdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurdhorhhg
    pdhrtghpthhtohepmhhhohgtkhhosehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:d6KnaKE6y3mZz_JB1eJVZPfB1IhwDO6PzYHq_F8LKknWFyxDgJndPA>
    <xmx:d6KnaBsbC29AeQtHuhwoTibIYfUFxX3iQiq4-tN--1eYXpJKsfcbeg>
    <xmx:d6KnaAbu6CU2JbjeeCQ_rBNkUozqnK_-vwenWbyfNEtvw6a4IyeSLQ>
    <xmx:d6KnaB5c_HCt8z2br-SbgT_81pRZlhI4iLcYDoGVdC-EeivmPOko9A>
    <xmx:d6KnaB-7zm1FGxyW80blCA5aKir2c85km7fFkV5aje-6JQlY6n2NoVoB>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 21 Aug 2025 18:49:26 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: akpm@linux-foundation.org
Cc: linux-btrfs@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	kernel-team@fb.com,
	shakeel.butt@linux.dev,
	wqu@suse.com,
	willy@infradead.org,
	mhocko@kernel.org,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev,
	hannes@cmpxchg.org
Subject: [PATCH] mm: fix CONFIG_MEMCG build for AS_KERNEL_FILE
Date: Thu, 21 Aug 2025 15:51:22 -0700
Message-ID: <6de59ddeec81b5c294d337c001ba0061631d4ec6.1755816635.git.boris@bur.io>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <f09c4e2c90351d4cb30a1969f7a863b9238bd291.1755812945.git.boris@bur.io>
References: <f09c4e2c90351d4cb30a1969f7a863b9238bd291.1755812945.git.boris@bur.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 02CD440005
X-Stat-Signature: n6gj1k4ur9aptxs931kk4wzjacduwkej
X-Rspam-User: 
X-HE-Tag: 1755816568-992769
X-HE-Meta: U2FsdGVkX18N+drz0b/7Ryhl/fLN2xwA3w7A2qSA/Q8mV2VROVhdJbYeZJxhsRSP5zsr5ZWKdy0y4XkQooP/qv2/OScba42OsVtVHYjJXcXvlj+WtIuU/5S5NVLzncSvI4NJDGkH0tMTJRk7CfDRSfaEgDrnnKXcSOYwg+cfCVC0Rq+4khPlEC/BzYa3H0PtTgnUgAYBrB8SzbtibZvnsERCWP2EyY4wYhuE1wjClE8jUBVtsNYzXqSv+6Iyu4OrRpMzRG4Xwcp5U+lC0xFyY3ikPakJ57gJvrCiZWQfBU3UnRQBuYlpBRXsiMFG6DyP2YWBdbPPp+KcvTs/EvSrcOjzsf4QpTt7pQBwJ9/rrRP6dE6D6PMCi/JtuWjdDvKlOdS/Wq4JaVWAjIyLEa7B58pgUwmFGFZtuPL1FZ1uF6OGzyGFBLdiPO+oye++mwfTo/mBaOwpdAs5nF9l6Efl7QsclsFLvSPKREVyOgKXnre6g0Nc0nvFlWqEvOWavnO3nQTNnO132OEMmX5a09le7iSF53a+Lcm9xWNC3CecIKusTPKHDIN1WD8BaEeHEx25wboKmsxqfVEFIJsX6PPIEBBa4FNtNt409f+//zYJtNF2me1l7KzMY89hNzQ5acQ4EtcvDp/LBu+9Az/MLWhr+bzRO2CJimKKZQuoas+DtGsYEmTLEJZ6Uc1lx9far9/Oed0pBTG+uCkM+Ti6vzlM5LLw/Fug1FcT9ZK6Nhcg6kq+moGP8wr0VclOt9V/s8lh6gOXhDJgnB8XHz55udCmuSwpPXnoFnMntOo7bULcqsZsbcptsyTI8yoSxZjCzw3aBercwRnqg++lDyMQAF0nv6wmM05y0mlm66BmNgSUEZ6RJpUCS/uN7M90juAYjUfyDFB3pqGwIZqL1j2E8OWQVJTNSdWs2ktnds7jUXSPudOb5872n6fmekdnkAlV0pWU7p2tY0QTw0UJ+VyNMxI
 gPRjYOzL
 FdjytMjU5Bx8eaFPOELGMgmDgJtLA/s4WUcaTDASW+fzCQYFymZl9A+dN5UPiYYE50oFYYXCN1TTXEMhiTE27mvk4GSL6Hw9pj2loGj15o5hVZoBHIeC/eM9VGBVT3QeNivNM0YMzRs+iCiCLL8zZVR9IqAO4yFhEqYlNXVMCAt0yCzeqEBSjlPDdbnIqYEXPPvuKFTg4glnq30TWh7TBaDY9szfvkx4oVku5z2URlDWmsbCOc0Ccy1x2awYvqQsD7TdDqziGYgxlEmGKaKsNKkrHHTisKRpV/q+HfuO1X0p+uUs37y4DVZ+bxuWmwIDpUnO315lKTKK+ZAKA/VPEa/R9oLHrWUJ9GulDNILpQv8QitA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

this needs to be folded into

mm/filemap: add AS_KERNEL_FILE

for it to build with CONFIG_MEMCG unset. Apologies for the churn.

Signed-off-by: Boris Burkov <boris@bur.io>
---
 include/linux/memcontrol.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 9fa3afc90dd5..e693978b2022 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1059,6 +1059,8 @@ extern int mem_cgroup_init(void);
 
 #define MEM_CGROUP_ID_SHIFT	0
 
+#define root_mem_cgroup		(NULL)
+
 static inline struct mem_cgroup *folio_memcg(struct folio *folio)
 {
 	return NULL;
-- 
2.50.1


