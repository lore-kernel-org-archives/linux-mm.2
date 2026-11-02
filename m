Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AB01606A589
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 17:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=dZK7zyHM
Received: by kanga.kvack.org (Postfix)
	id 51EF56B00EF; Mon,  2 Nov 2026 12:56:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F6126B05B1; Mon,  2 Nov 2026 12:56:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 433436B05B2; Mon,  2 Nov 2026 12:56:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 182A66B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:56:31 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 399651C1DFB
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 17:56:30 +0000 (UTC)
X-FDA: 85390933740.04.5116C4A
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1491C140005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 17:56:27 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=dZK7zyHM;
	spf=pass (imf23.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793642188;
	b=8jg7ZWYaF4CDsDeOdvgrMFx08k4lGVB4tOWcpHml6AiynIBQKitNEB5ao2yYP4CW94zCPT
	t9uE3DfB17vj4I+uhI7HVxFbzCBSPGXwAMY6vkxuFOkb66nZnooG2WNE/5Zr1NnOGeATO6
	nrL3qKYLbxqpDOrGoFseGk8kzhRigpM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=dZK7zyHM;
	spf=pass (imf23.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793642188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=wksPVf4+3BY129091ZVPp8TwYhF+Bq8Qv4YKU7zTmjs=;
	b=rqLcO4+Hhv/A2KK3U2wjq62GEA5jvZvDh6IGq56JJrt4eACFp1DJHIGzlYxbvOIAS+MkbN
	TqCgaOxipKh5q0eUIDNj7JDYT5hapetUJbitE5/q2rf8RC2cAkKFe45Dbo854Wk3qJFOHJ
	WkRjsunPJLWbSYlYqbybKK8s8tb59kI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=wksPVf4+3BY129091ZVPp8TwYhF+Bq8Qv4YKU7zTmjs=; b=dZK7zyHMmVcP48N00IenBMCX+Z
	o/yReFYgu0RlweK61kvVICf3+IdrR04qdXyCDYFGJlfQiMz3Vf18t7orAjRSwQnHJfQIBX6UU1BH/
	DpiFtlXZi54c0aV2bdZz7/uWb+H3p3wPrAkobXdf4hBYKa+sP98O5HOzKBxenRi2ul/w3nxnbFU0C
	au3VMDS9FkEXUnokh00uqNwuR6KExyRWhKz4Bz0VeCeAW5a1iUMeLkfnErUN00knw5G/sm4s+DwdF
	aDCYH6zmK0tb9CmbVmr5mJ3CL6kfOXOaDrnnNy/Me/GDAPIbbJ2Wno5OnJ/2X59JoziyW/Cn3MA1i
	rGfY+6Vg==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xNwGe-0000000HXav-43SO;
	Mon, 02 Nov 2026 17:56:25 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v2] Docs: mmap_prepare: don't italicize structs
Date: Mon,  2 Nov 2026 09:56:19 -0800
Message-ID: <20261102175619.2274135-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1491C140005
X-Stat-Signature: 39hob1oh85dugyc1tymeswc13th7kw4a
X-Rspam-User: 
X-HE-Tag: 1793642187-873361
X-HE-Meta: U2FsdGVkX18LUapzl4A+fzrbjidUXj1FwsYxTmppxQ535L0aaZvp5b7rJHR3dJDPI51Pj7qqsXpx+vq9gS45MuDZUZsCc1kYa4np5rcq0jSyZT+GGyMC8GHt2Bijom6vH9gLnfz3rb8pIF1bT4agO5Y8WPodXZFfRGKZ7xbxrP0duTotx52r4sB2/wLTH9IfK6wQk1N2LBp2cG35fOSde0S8upLWkU7fyPF3E1Bgt9OEnLnygGnO45b8HyoD07CADAV2BFVbX2/RO2JH2jS5Tw9foTT7FLB26M8Dp5MCADsoJW22zSKwlp9ZQEQ+R1+cA3Ebd1ykICWeDHNsku7KwtSPtypdYG0PTeEVBrShGVv3q8jLo3hhh87DpsRGBvl4x0Iwqwail00rCC9S3KZwbfCnNrZp9JZ235U2o0JdyjlgK66LmU9cXulyGwj6ilk6gUGaP9sesIIEnphYp+sJgRx9ZHe/C2BjDBUWqNqVIIz8ErLY1XNwjNWbAu5DHcl9DfVi2J41K7x+w2/3oh5uS1CDD2IQGDOFD7Pz24T2OeL1syU01OXSdrM003jVyblBCt4knLdseZeB23j8PEem9pTxPVTDKB+VVm4Q0YkPEgsAZ0j/8ozjdjCQ9VyYm5JlKf4gRkUALYw3hl2pH1W1uX/iW1DkT5D203QpavfO4gnkiwYTOa07DgB8/77BuYd2I0OLLU7nzEV2HA8Uy9qhyGiy7Pz8pglBhUc2CwX8EkReAZhBGvYHaLtLkDgl0V73XeCnwBipJxSDV/7g2VgAUfAxK5LlGmV1MopUNWkvlmn5PCOdh7bhAmwQmXPRO5DvnAl57gSiTxo89vGDOR3lL/l/MGR6IZhqyYdHRlOpsuvbio/WCWIpQmHHzqQDbn+MZ2L+X1GMN4XS+L6D/1tnmFM/uhmYpgQaXjgJ3ToV6loNLPwzDYsfgcmRSv/Z9zNHlngkT2umZjp/wyRmI1C
 gyaffWLq
 7obh6PXuTXWtTZ7xQeM3+7vFLLyKSy3ZVHnYh/KMpGu7prSCXfT4s1AFutlvTljzYw8TXdoXZrqludrmE/0L2S1YA+f5YZkCCeLqL6N7p3EfmjGaq7iz1jAW+VOk1e6uJaliofwbJAwlXvg9S+WnEF3TszyqVuwmL616ChInpegGeQ/aK6Sl2wASCb//Ijg9XMJId1ALOOpbXlkIi5S3/pEQKKI69o1oLeXl4/UXhTKlQWo6hfckrtBgU8iJBGRW+q+Q8k6Bnu1r//DRruu3GD+QSwGmYzdjjBvQ2SkI+rOpFa3t8xnUhksq+PAhukyT6a78y14DNRFfLx5DWa7rgq1lRj5ij2ptG+085xtWY/9Tp+PmbiErZrxPJempWjGOJEwFikqYeGqPw0KnMQXEdcD/KneYBX+IAis3aIbcpT5dVvgFp0bVbJCf+oF3Q7UG1HUKqL/XNfRQHndpVZ8e3LgFJGvyG+kgV3/q/62xKcCdccSc3Rtt+eK1dkdCoCHZ/xVsSv8b5yjhoXKR37bJ07xsd9ABLAH8ebIYX6Z4skjbogHkFJ1lMRoHfugvraXErrhQk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Using a single quote mark `struct xyz` causes the html output to be
produced as italic. Omit the quote marks so that kernel-doc's automarkup
can make the "struct xyz" bold monospace ("code" style") in the
generated html.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Bagas Sanjaya <bagasdotme@gmail.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
---
v2: fix one more instance of unneeded single quotes

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org
Cc: linux-doc@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>

 Documentation/filesystems/mmap_prepare.rst |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux-next-20261030.orig/Documentation/filesystems/mmap_prepare.rst
+++ linux-next-20261030/Documentation/filesystems/mmap_prepare.rst
@@ -156,16 +156,16 @@ pointer. These are:
 * mmap_action_simple_ioremap() - Sets up an I/O remap from a specified
   physical address and over a specified length.
 
-* mmap_action_map_kernel_pages() - Maps a specified array of `struct page`
+* mmap_action_map_kernel_pages() - Maps a specified array of struct page
   pointers in the VMA from a specific offset.
 
-* mmap_action_map_kernel_pages_full() - Maps a specified array of `struct
-  page` pointers over the entire VMA. The caller must ensure there are
+* mmap_action_map_kernel_pages_full() - Maps a specified array of struct
+  page pointers over the entire VMA. The caller must ensure there are
   sufficient entries in the page array to cover the entire range of the
   described VMA.
 
 * mmap_action_map_discontig_kernel_pages() - Maps a discontiguous range of
-  `struct page` pointers over the VMA. They must span from the start of the VMA,
+  struct page pointers over the VMA. They must span from the start of the VMA,
   but may terminate prior to the end (leaving the remainder unmapped).
 
 **NOTE:** The ``action`` field should never normally be manipulated directly,

