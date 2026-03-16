Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEF3DF53D9F
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 21:14:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4067C6B039C; Mon, 16 Mar 2026 17:14:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B1A46B039E; Mon, 16 Mar 2026 17:14:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27F2C6B039F; Mon, 16 Mar 2026 17:14:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 12F606B039C
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 17:14:25 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D5D9A1A05FB
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:14:24 +0000 (UTC)
X-FDA: 84553179648.30.689C14A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 49B9340009
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:14:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WSQBK1iL;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773695663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3prCBr/mqT/iHcEgzC4Gc7fd19WQSXtz934z3UHU/Wg=;
	b=QL2rDrTGnW9OyZiB+f9qTEoRxpY+k2i1QqsJz6CDDxgBNegt3f+F0WKuePbD27w7h1Y9PL
	wfZDVAMdSs+U2su6pmAB85x9W75RDVabvjzGOx6pbP/mur2MkMx379QN9udb/4j8iaeRLQ
	ODPlkbl1gUV3FMCYUxmwhSMwpb1zXL0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WSQBK1iL;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773695663; a=rsa-sha256;
	cv=none;
	b=a6CZ1rdrDzPP1POvsYMkaMpafQTmYca52Tp7mCdYUYHVgrijEnPwb1K6MVGe7w7Af0oHa4
	Dw7yM2BViFBFfPZPl2ifSliVLdCt6gxoVRimvrfp+ePTOoCJQAEA4wYQlZ7rR3PIrt2vCG
	Q2iZxZPgzr/n8xySzfbQCqZ3Ocwx6Ns=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B80E16132F;
	Mon, 16 Mar 2026 21:14:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF9A6C2BCB1;
	Mon, 16 Mar 2026 21:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773695662;
	bh=dElPd1/2yYuQnbmBxFem9K254mqoyGxI5ua35pg5dJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WSQBK1iLku67+ML1WmdG5gvZLWS7LBzAh+jY1gRa2yWEDslVldYCYBTPugdDPtK3i
	 CJUPJvXQZ/W8O2eLGawpJj4z7/Gc/0AG/4/vE6vYrREysTXhDw+AehDa8KdJrBOSlC
	 XhH22ZMH6c73yrZxTi5u16TG0R08vkR0Hg/N25ka99GCvGxJVINDVuFd31W7b8egcK
	 vue6N3UbG8dGv7WpxgZ343wv1BtFDUqGFbAbGk7WlXYTrbd+eiSrkAi0pp+So15ggU
	 sTJ2YQNiWnWZSMjPaxJ+T1mbsuo+/9JntOuw+gRsL+gTD6u/BCWW3CJwONZsgLHGWx
	 bcXTswhvf3Pkw==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Clemens Ladisch <clemens@ladisch.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Richard Weinberger <richard@nod.at>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Bodo Stroesser <bostroesser@gmail.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	linux-mtd@lists.infradead.org,
	linux-staging@lists.linux.dev,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-afs@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: [PATCH v2 16/16] mm: on remap assert that input range within the proposed VMA
Date: Mon, 16 Mar 2026 21:12:12 +0000
Message-ID: <4e152e7b8e1a93baf0777628eef9409d031cf8f6.1773695307.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773695307.git.ljs@kernel.org>
References: <cover.1773695307.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 49B9340009
X-Rspamd-Server: rspam07
X-Stat-Signature: kgwrdqbq94i1e6b46a6mx4uiubj8kkrz
X-Rspam-User: 
X-HE-Tag: 1773695663-123827
X-HE-Meta: U2FsdGVkX18BeT9kKa3YpxK9BKt6DCGbby1AUTdlkzJmHwZ3hWHI6ZDNwC8IrBcTCzxxmpiXGb2N7LmCqqa6ymXg1DEHnORSuFdDS+rV6wnpqhDmrCW9JRIJiYnAyawJMbntJvK8loqcgyxRZg0BtC+4YgF93yWPgf6K1jtPAoG/cmxL46uhrWL+u6sFhj0zMgWlYcoHkaYlLwIHAE6Jj4K3uVEbea852ZBztUC+VmUgURLtIygkdRMPXxoY1yFQRE6zhQ6GcfxVneXRB7r5NGQGrSbkTDmqjk2W2RCQEuHnuAxkyJeCMaNyn2CKwSyeUGcxH18t4V/hpXEVUDRJROFuO1JT+z00o20FkEwMaqc2Z4ysMIL2WbdUl/4ecCc9hxDqrAia9va7nMcmde2x3PAfcrcudWPkmR0071mvlam9Ne/dgXfyXxFCaCjJCLSeswK+59y1zQNh2TqQY7gKKhYTQNUwNRtviLSZf/6brycjymIu3cjx0ahsTVQptQrR6M58B8d7UqjaxplCKTOQ496n3EdUqcrMmVJ+XwXuCdS++/iRqxJ6pxxrcw2JwT0wPs38GkiCDEQiV18sqRtlkI2QxS4oFN/PWE9PthTjgzC8+DGFL8oM7oXoKLhQ7G+E5KDxZPsL0slrbPxvDXtL5s6BfMKIdWJIcZ5swtP0zaiB6Nn6julrmKUxKWxAveHBqLXw1IpAohUiDn3j3yxcrz74dionmkujNs8XsmHmtRqsOQLy30oLilujUc8ktxyjL9vhrkdpyV5l5+oT+XxFezCzBttmHXkRBWVsMGaE2Ty+6mXl9WfXERHsy0CNQZP8zL7VjjgMawbn2JT1ly1WYSEj8in2OD7nHgItK0wAUUp2eyOVxQrPk/DVK3pyXNSUZ/k/8LNPvnGJSa0NL7zWiI6G+Lx/ygDH8iDzXxTbtmDpK3kZds22uOqWYBryLo7plc24yRGvGS+hZY9Hrkg
 UeqFqmEs
 EFIk57L33kmNcuBKloMkDpwOgCazWBI2usrbmZMKxnja3I05o5QmlbiFEMZOfLh98pZnAFE2ASuzhVQdKN46MVgIEJPIxQeTPAcAIwMOe8+7MS+QDjG7Y6Zu2nbn12EcSYY9WEAGMZ7dydwT/uo/ySfdjKovT0bE4EjzCFaQiGygXjrOYjis84+7ouMLnsPVYSl4JJVGx63ZRZdrVtp7WIUEcl3MrdOqx7U1cHx9Qcpb/UY+xK1mF9hd3GRLqiL9y6tUR562oCFGPF2xmrpu2029sAM+WpPjNOkwXjMpWCG3AH76/WJFAutM+JQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now we have range_in_vma_desc(), update remap_pfn_range_prepare() to check
whether the input range in contained within the specified VMA, so we can
fail at prepare time if an invalid range is specified.

This covers the I/O remap mmap actions also which ultimately call into this
function, and other mmap action types either already span the full VMA or
check this already.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 mm/memory.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index 849d5d9eeb83..de0dd17759e2 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3142,6 +3142,9 @@ int remap_pfn_range_prepare(struct vm_area_desc *desc)
 	const bool is_cow = vma_desc_is_cow_mapping(desc);
 	int err;
 
+	if (!range_in_vma_desc(desc, start, end))
+		return -EFAULT;
+
 	err = get_remap_pgoff(is_cow, start, end, desc->start, desc->end, pfn,
 			      &desc->pgoff);
 	if (err)
-- 
2.53.0


