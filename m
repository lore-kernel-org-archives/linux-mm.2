Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3241CCD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 14:06:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B8136B00CD; Mon, 11 May 2026 10:06:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98F9E6B00CE; Mon, 11 May 2026 10:06:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CC836B00D0; Mon, 11 May 2026 10:06:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7D5696B00CD
	for <linux-mm@kvack.org>; Mon, 11 May 2026 10:06:06 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 38E9216015E
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:06:06 +0000 (UTC)
X-FDA: 84755313132.11.C01E5F3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7B5CE140005
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:06:04 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VzzaUGht;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778508364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Hxie3l6GF/3E3owdSqmOU0xCneMvVXO4cvVixoG97o=;
	b=F4hFRojyd0rv8kOYq85Bfq6NqemjCgY2zmqKvmfGeypEIQEU6f0aiO/yT5MP5UmtZJItdz
	3pfI2gT+w48goZ+c5SfGtMj/06pDo5YAkiXnJz7Yx8beNI22k9mYZSgIEq02pwyShox+4m
	WFvwMYn4zbhbZQ1t+U5973jYd1IljtE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778508364; a=rsa-sha256;
	cv=none;
	b=Couome5TpVdtzj1QJO7CnSwk5oNHyjPmsdmV63cRpFSG+QQBETbLC+yxUNtVP4Iahg6Mal
	UR/POQcOM8W2h2ofuuaPkV6fkxHqG/qWUczjkBxhbJAp8Jz+aLqzrShs+0DNa0FJ005aqS
	698XzyBT1KYdmg/RZcyqqp7Yt0HlUAU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VzzaUGht;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 83DC443768;
	Mon, 11 May 2026 14:06:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6A89C2BCC9;
	Mon, 11 May 2026 14:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778508363;
	bh=MFrlSNsTp04kT+A7ReVQ6q1RUJiMOyuWN+whgS79KCI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=VzzaUGhtjmv+hgICpWb9Ds9RkOduoJ8mQ0Y/DcgBVY2dFaaRVfcVxiN2SbUKQuwiL
	 o7eRr+5Toxr4lABnCNoOTIMMN4aJ7fOgqOVvyGtkdg6QrUqs7rUeaGOqi3u1nVPDkg
	 Ksz0MxzCsMSNEnnyFYKhliTDT4hT3Njg5ZT2r8cMD3/8wzL/mBhdvfWXpE7D+1LW98
	 rN7lvX13lEtdJbla8okiBqaGSKrxpTp5HtBwVqWJp27YyraoMyd04koJ5hVKbMZSfn
	 dFRNDUbp6ZtPNR/BNeg+D8gkJkfsmTb8oqE4KzJl4JXpHPBQHLEyE3u3AiI6BbVR9e
	 ixKjUMbFwUVSQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 11 May 2026 16:05:33 +0200
Subject: [PATCH 5/8] mm/bootmem_info: stop marking the pgdat as NODE_INFO
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260511-bootmem_info_prep-v1-5-3fb0be6fc688@kernel.org>
References: <20260511-bootmem_info_prep-v1-0-3fb0be6fc688@kernel.org>
In-Reply-To: <20260511-bootmem_info_prep-v1-0-3fb0be6fc688@kernel.org>
To: "David S. Miller" <davem@davemloft.net>, 
 Andreas Larsson <andreas@gaisler.com>, Mike Rapoport <rppt@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7B5CE140005
X-Stat-Signature: nnop4mfxpnk83h8owdtewu7pn6bd86st
X-Rspam-User: 
X-HE-Tag: 1778508364-33985
X-HE-Meta: U2FsdGVkX19jjCxoBKA9GcNvO/QWIxNXtwwNvgHBfDxe40fwyisOgVmsrLCjy0s9+PkEPKe3uSQosTXY8imqDojyUUJapo6ICL47F/MyEIUIwkGhV0JEfA4J76LXV2zXbdarX1DP9HZEOPzpUhiP+IsTmTUd4jGnL0XadCtGS1c1eHtz0S41IF+U8KBWBp2e6SPS8tJzur7kFXtcsZwcV5eRnDoFB1bb9Ps/xjsWncSOh2ZbgADmZTZ2dX1kMPed/EoclxwQrRba4xxNby5NpKMT/qHCXYumD22oQ343Ax9w7ga3HALTAD75jcGAq7Jlc1iwm9WEoXU2RROhuTqV5pkBaRdz4pA7Xf+mCnfe81tKs616XvoZoqdC8IImVdNNSIatNwEc/Mv3ZDA3KmAgew4GPPvWo/2Zlmc5r6oNG2L9HcNqTgZl9WelMb/WcRYNU6HY2SDFMLZOcy//sMjNNKVS7Te4TGqB5Jv33MAYtApE9s3udN6IijwZhQ41qHikRMopcRGOh/2h3BrriPRNwhVJ/G5ZzzOzwX6de9S0T2FX7TahEQVNvXgSCE6EeV12Pub018JSEdSojsiI1PEWCYkiRDie78Hdevek8CFKblDed/0VY3hQSAP8U/56fdTwvZ/+lp/U+Zzq3fCK7phcR4CMFr4p19T9fru9H7ycTqg1+iuo58E3tL3FeYFRlGO9fHJtXzqWdY/c29MRQiIBSPgPt5sXHhrZMimchR9q2V1Bq0qrD83zpNC6OxgQZ6SqtLLqj9BEMQhhP1sZrgxdNRMx4p7Cqwwmea3uYPEcRSprWWShamb1/2Tnj/a84nCZ2a+XzE9BNvEXtBgnqXgE+PjfJcccpGWIFJ2LCPr5296l6N/fK0onbQZNkvN6K9jOsAExQYf69n/hfI1PatV6oNuE51EKaydBD8qiawtLlJ3qKsbrFdFFuI0thkuVAFJmOyyT3Dk/DXAXdQBy2cU
 Q740WAIe
 iZY0cYNt90vWagiawusE/amge+8dpEok/tOTjK8LMc3DOA7F1o3KgSc0lpG+Ekvfi8TVtN0aXOYZQtm9axdkUID/J4jBGE3kcvT1tqMJFoWamg3fg1ol6dd5X0o3law2tPknGB1Opk2wXY5jLcz6tK9jpDyfGHfRZ+v1MMNoclN7KclgfBGfgPKIAKXWGM08suQR5GMJuq5GI8eHX60817PPareTLM4PWuyxXD0LLNGh9Yznb56nWojtxC4Hnq4J3MuYOPgcirAXFS+K/bpDL2EDcP3S9tnOTMtXyxLC/fjp6nvSYBamI7+q+IPj89wfTyqGkv/MLz+ki1/s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We removed the last user of NODE_INFO in commit 119c31caa59e ("mm/sparse:
remove !CONFIG_SPARSEMEM_VMEMMAP leftovers for CONFIG_MEMORY_HOTPLUG").

But it really was never used it besides for safety-checks ever since it was
introduced in commit 04753278769f ("memory hotplug: register section/node
id to free"), where we had the comment:

	5) The node information like pgdat has similar issues. But, this
	   will be able to be solved too by this.
	   (Not implemented yet, but, remembering node id in the pages.)

Of course, that never happened, and we are not planning on freeing the
node data (pgdat/pglist_data), during memory hotunplug.

So let's just stop marking the pgdat as NODE_INFO.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/bootmem_info.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/mm/bootmem_info.c b/mm/bootmem_info.c
index 74c1116626c8..cce1d560f094 100644
--- a/mm/bootmem_info.c
+++ b/mm/bootmem_info.c
@@ -62,15 +62,8 @@ static void __init register_page_bootmem_info_section(unsigned long start_pfn)
 
 void __init register_page_bootmem_info_node(struct pglist_data *pgdat)
 {
-	unsigned long i, pfn, end_pfn, nr_pages;
+	unsigned long pfn, end_pfn;
 	int node = pgdat->node_id;
-	struct page *page;
-
-	nr_pages = PAGE_ALIGN(sizeof(struct pglist_data)) >> PAGE_SHIFT;
-	page = virt_to_page(pgdat);
-
-	for (i = 0; i < nr_pages; i++, page++)
-		get_page_bootmem(node, page, NODE_INFO);
 
 	pfn = pgdat->node_start_pfn;
 	end_pfn = pgdat_end_pfn(pgdat);

-- 
2.43.0


