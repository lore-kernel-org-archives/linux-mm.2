Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1895EA3C4A
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 10:56:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63E8A6B0005; Thu,  9 Apr 2026 06:56:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EF8B6B0088; Thu,  9 Apr 2026 06:56:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 505816B008A; Thu,  9 Apr 2026 06:56:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3E5116B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 06:56:15 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 088AB1B8466
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 10:56:15 +0000 (UTC)
X-FDA: 84638713110.15.82DF4BD
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5031B1C0008
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 10:56:13 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jTkQ23nS;
	spf=pass (imf20.hostedemail.com: domain of thorsten.blum@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=thorsten.blum@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775732173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=RXnQZXBYa3vuKgwomSApzbPI2ilGOJnfCFu3tAYxZYE=;
	b=PtxcrWZweABtWhv3xD7VKpaUVNVmbwl1136E26WG7z2APLk1CurUj4MLCfjamz2nj3KRFk
	xPSXYi8ArpBJfZ46IN0dLlfQ0Ninuls/SKo9MLDxcqWd45/nkJRl+DUjTBUmZelIaOQVNy
	dWw/+ZBos5RzFDlCWhA0wwFR46fJaUY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775732173; a=rsa-sha256;
	cv=none;
	b=AT8Z3E0tzY2c/53BaVpRWZWTM+74x3XvaeEfh4Yo+R8/1WbQrU6dQbarojSQgr2SkLzMGa
	1ww1WTXE7anfy/mBqbFyyaIlhEfojypM25KnTQKzjJD3XJgvQdrAA4aDBus9tKFF0ABsh2
	WJ47LdOU0oTte8PLozcRBk9zSjE2SyA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jTkQ23nS;
	spf=pass (imf20.hostedemail.com: domain of thorsten.blum@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=thorsten.blum@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775732166;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=RXnQZXBYa3vuKgwomSApzbPI2ilGOJnfCFu3tAYxZYE=;
	b=jTkQ23nSIGAct5EbtU5wkME0Jo50XoaZjEwlRExYqRInSP5Yd7p8AkLyAUK5xLR6A3FxqY
	Kko6YFhj1Zn8GGVbS5M9yh8K84G8GbczwZC/phUvWnrqbD3MIEzbERI7qeK6WVg1uxvjhV
	lyhokgv6Erru55AunByy49Tqi6a+2kU=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Frank van der Linden <fvdl@google.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	stable@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/hugetlb: fix early boot crash on parameters without '=' separator
Date: Thu,  9 Apr 2026 12:54:40 +0200
Message-ID: <20260409105437.108686-4-thorsten.blum@linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=918; i=thorsten.blum@linux.dev; h=from:subject; bh=2OC4+YvS7JeDbioJ5TEwE9zyKJ+wa0upJUfw7ypAZ/A=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJnXW3PrJqhuWL3/6r7vc7iSeKs+XHm+dMOc63csZ5RJm n2wfOFs01HKwiDGxSArpsjyYNaPGb6lNZWbTCJ2wsxhZQIZwsDFKQATOfid4X+oVwFfyc2fU3im H1itdVKYz+rD9wWPPmUyKE73Fz9yNrWPkWHe6ab5DzPkRH9oq2b47Xpw29stbME+7Slndsxtu/2 Q24gVAA==
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Stat-Signature: iat48h4onx71kmqdwt5cn44xfnf8djuj
X-Rspamd-Queue-Id: 5031B1C0008
X-Rspam-User: 
X-HE-Tag: 1775732173-986842
X-HE-Meta: U2FsdGVkX1+liWiPJAqbtEOW/hsUgJHGOAUDPPePxq64xOpriGVFi60Q7XqZQ1M3bKzKFrRVLTZN/IH1EiVSTcch0rZWEfJ3Rzby9H5wobuMN/BPq+1Oeu3p/UZO1BhS/ESRqACshDga1XWosNKthDj0Ur4yHScUZAErzPZ4Uv16q1+/rjSAk0Yu2zyjHFUDwGCOmRq0psNvnM2pAogp7/8bS4jgHBQ3nL+tjEnxtRNGd6lK/vvQ6UQKsVBZI+K99j62vvQsFUqi7WpyNSwUn/dAnqNoyX95ALkjnJLkWss2lQaBu9Q7mEouvMBvGJa7lkV2yGAsOMsmlbAkHFQVFdzKgw2Ji19pJXbKrJpGvtKoCrXpE46w6lIViMgRdE3Xn09vVB+5Cjl1JdMAMUNSBnQBlvJkIPqTgLfuA9AZcLtSRnUh4M2InIX0q1RTCW8o4e+6SBKlrZiJoTAfmBvfXsc1oOFBeg6YqDDR+XORyrDXyFlKQUEz6t9pIkKSrnvMEPwTwNQsMmCbPtnceRDXgC62cW44r7/u9I7zmHs0fC5yXYF3X71tk6B7/xm7kMRsf2WayELlbNE7IuyRK1o1fIfYCjenNwd6RLvCxou2dzYguUCj9Siy8nefBlCY8/hJISryVb4tnGQVbv4/ufTcQ27oolNuVWYfaqbNuTPOnCfuGW9dd2eM4tKC0zij8fbW6A2FGq+vkRqr6n24k8qGLOwD3rzk3AEZJbp+ufK889hbaHBS076uko5U4IRamd/NaIiRffNBIh9EdRWZ9hkcFW5iyCNay73R5nYlZX+e93CHKYmI/+TYCSQjQHpDMGCWjpr1GoYR/Ji+YiA3/RZmFK0MYFwTbcgybyDuV/OLEHFn2d2cxLIz5xkrXBVcca2CMNcRGVTcW//yIRPH36Il9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If hugepages, hugepagesz, or default_hugepagesz are specified on the
kernel command line without the '=' separator, early parameter parsing
passes NULL to hugetlb_add_param(), which dereferences it in strlen()
and can crash the system during early boot.

Reject NULL values in hugetlb_add_param() and return -EINVAL instead.

Fixes: 5b47c02967ab ("mm/hugetlb: convert cmdline parameters from setup to early")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 mm/hugetlb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 327eaa4074d3..9fda39132d26 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4252,6 +4252,9 @@ static __init int hugetlb_add_param(char *s, int (*setup)(char *))
 	size_t len;
 	char *p;
 
+	if (!s)
+		return -EINVAL;
+
 	if (hugetlb_param_index >= HUGE_MAX_CMDLINE_ARGS)
 		return -EINVAL;
 

