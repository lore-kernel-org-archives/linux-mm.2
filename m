Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D5A2CCD1A5
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 09:05:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3DE68E0067; Fri, 24 Oct 2025 05:05:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEE6C8E0042; Fri, 24 Oct 2025 05:05:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDCE78E0067; Fri, 24 Oct 2025 05:05:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A5E618E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 05:05:20 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5A2C612A0E0
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 09:05:20 +0000 (UTC)
X-FDA: 84032424000.06.62341A6
Received: from flow-a8-smtp.messagingengine.com (flow-a8-smtp.messagingengine.com [103.168.172.143])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3CE8C4000F
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 09:05:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="A NiS5Er";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=Tlbb2HLV;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.143 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761296718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LzxoOpuRHVLLxFPTQuj5Q9D1orPS20zYzzKfEt8tzg8=;
	b=yBqH9RvaoyQfA3fbTDtryFREo7mgTo03HtfaIhv8c4+pRbtAhtunkCuwE/WgPZQnRr+P03
	YY+XBLgeuKmCqve56+IXO8wbC1GPT24kw2GQ1YSAD6acykonTJSDa/QZsmorSFZyomJcQ3
	XnpGMZsowrVt+pp32O8W7nbv4h/s9ro=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761296718; a=rsa-sha256;
	cv=none;
	b=n1tyRsTzO/MFsaApLhDgfEhqbFIGAWxh5/Utzqjd+Azi6V04fZYvlXsS2JlEB9OL9CLTDX
	BK1zOm4pbUdmzYHf5KdFfcwgtpHLW5RAVi0pveF0VMsDncozFD+WtEVjCQYPjWVliLiBJ8
	F0Ss6s+Zi4PyDRflXjBMH5dP4yHIJw4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="A NiS5Er";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=Tlbb2HLV;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.143 as permitted sender) smtp.mailfrom=kirill@shutemov.name
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.phl.internal (Postfix) with ESMTP id 65E981380333;
	Fri, 24 Oct 2025 05:05:17 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Fri, 24 Oct 2025 05:05:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1761296717; x=
	1761303917; bh=LzxoOpuRHVLLxFPTQuj5Q9D1orPS20zYzzKfEt8tzg8=; b=A
	NiS5ErwWj07SDbOX7wjxBWb9q9Gy18k1wlFyespmT6y7i78YixIe67iX6xAus+42
	dKwoTJm3rEHg+N2tSW4/dnLGihhQvGqXzQsiIr0B/i8EhsGafADk7s+EOnOiZGz/
	g25mTFNIEL85njmLOB6br8GiEza4+JI5Kl1mWkelPrRdoiui4hUwwTR8ondqozkH
	yBxU1o40xDvJMKzkLL+68Dk+UpBEBETjseTQYDwD69lu3rKNJ8KrSCzjrtQ93OPK
	l5lGqjx2llYIVym4iDsHfkEUVqPrFt3Lpi998s2SYHm5OLT/gzU7ZYNeUIeA81/e
	bMkDzAYvzEsUuARwH0cig==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1761296717; x=1761303917; bh=LzxoOpuRHVLLxFPTQuj5Q9D1orPS20zYzzK
	fEt8tzg8=; b=Tlbb2HLVyYS7KstUdegxMU7zEdNEa7N52WD4YLnYURYlpdyQQTc
	c0J83zvzy3JzpIwg+h1I3TBTst6gR9U7qn14a4PfUEV4aflq9k+Y2xvYt5cnwcCW
	nDQuawtKQSqjS4sYwbzbGYOaYOdfQxcU90SK0Fj/uozES4FU5J158KBoOMnUVIkt
	IvFG0pYjek/QvtwMjCljmAoDcmN62kTompAmvIgxKz704SqW8/8ctZA6VDhPCvxa
	KYI/0OxiER9nrnd4MSKS0bOGwvAj9xdMqYF+iBdk9WlI/rQaOXlPBhzOVrsDacB6
	rOJS88/Dn+177BnxCUTRb+dLNRtDLLkRZcw==
X-ME-Sender: <xms:S0H7aHL04JtqiuSargFb7zQJAxCpLHhAczxS72CAoPagNc7gcmbR2A>
    <xme:S0H7aEOW8NTp8RxBicT8q61ykl6-kyA9HsqMozR6Su22VJiynieIW_V5hk-b9rkqs
    Mf2esSAT6WU7UsRfm0v3EDuiR_rksm1CJ2_8LZVKWONGCfF2p3Zsg>
X-ME-Received: <xmr:S0H7aCpD1WNKN8XVf1yqtLQ78p6E2Z7A67xQoTfj_lmd1ri0D7ljIjUq-uET1Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddugeekleefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepgeefheelvedvteffleeuffdtffelvdfgteehgeeiveetgfefhfei
    jeehveekieegnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghruf
    hiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrihhllhesshhhuhhtvghm
    ohhvrdhnrghmvgdpnhgspghrtghpthhtohepgeegpdhmohguvgepshhmthhpohhuthdprh
    gtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghp
    thhtohepuggrvhhiugesrhgvughhrghtrdgtohhmpdhrtghpthhtohephhhughhhugesgh
    hoohhglhgvrdgtohhmpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvggrugdrohhr
    ghdprhgtphhtthhopehvihhrohesiigvnhhivhdrlhhinhhugidrohhrghdruhhkpdhrtg
    hpthhtohepsghrrghunhgvrheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhorhgv
    nhiiohdrshhtohgrkhgvshesohhrrggtlhgvrdgtohhmpdhrtghpthhtoheplhhirghmrd
    hhohiflhgvthhtsehorhgrtghlvgdrtghomhdprhgtphhtthhopehvsggrsghkrgesshhu
    shgvrdgtii
X-ME-Proxy: <xmx:S0H7aNdki9UJUz0NQesx9xxTyDsPWu4kz3OouIZBFGvZJCcu1qQ2LQ>
    <xmx:S0H7aLae0FnbklGqvr3ErBnn_WMZkGG8niRmkyzB02Rg153NsKVAVQ>
    <xmx:S0H7aACB0vysQ-M5-RkvyLNY2LXH1dkxsQEusVw75cPr9s9yLP-Tng>
    <xmx:S0H7aGCiXudRcMIYBzADUv7SEN63WFVKILIuG87dZnH5nNRU0pIf8w>
    <xmx:TUH7aNFSqtzaDOz-qPI1dGtn0qLQi1xryUp4aAbrWfAvhOkN2V1U5nWA>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 24 Oct 2025 05:05:14 -0400 (EDT)
Date: Fri, 24 Oct 2025 10:05:11 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>, Hugh Dickins <hughd@google.com>, 
	Matthew Wilcox <willy@infradead.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, Dave Chinner <david@fromorbit.com>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 2/2] mm/truncate: Unmap large folio on split failure
Message-ID: <efm75n5srtb4xp5akp4x6sq6522p4hivzge7ufwnkodsw2yixt@ahntf6d2qe4h>
References: <20251023093251.54146-1-kirill@shutemov.name>
 <20251023093251.54146-3-kirill@shutemov.name>
 <20251023135644.f955b3aa4b4df23f621087c4@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251023135644.f955b3aa4b4df23f621087c4@linux-foundation.org>
X-Rspamd-Server: rspam01
X-Stat-Signature: 918tdfbbetrrjtzw4qi9rysxrpbbi34k
X-Rspam-User: 
X-Rspamd-Queue-Id: 3CE8C4000F
X-HE-Tag: 1761296718-228915
X-HE-Meta: U2FsdGVkX184yKLq8Soxaq9txM8Y4HHSw3bYGYjVpvFJpYce7Y9Wki9sBrlldmFmzzD7qusS06mWj9HBeFaOsnM18ycdiqxeW8On6B96JilpIAboIa1tq6Z8IiqGNjsrHp0qOXB6DXTYW0+t5xjHF5mKmj0WKxVSjCJPqCiYkwHKngNJltolXqY2t4lqL8XtSupal+rm5cjYUePI/9RgQUlEwVArtpd0fBdiDOC/j5VF87WZaWkLYZDNR4xuOgHVTKdG1JE0M8JUN4qlDSo3zskn5XfKk10ADAJ85vB7vsITmqYP9ptuuk/J6k+CbqZ8U3kbXkZThEg2KwakAPyI8h6rx4ggWcbTqpOQnm7AwpjwOhv/FikmZIvV1IBasyYgFCGtLaYt9L03isAt7v0wrgWaEIvLAV/Dnf2iG/iSNY6XstZdsn0kbypu1p50iSxmLMmokvK4iyaazNZ136hgwVPskwxC3QGyNilYkSkDsNc4w8birBH9Nt8VO+XwwFSHwwO2qE5Yvjfb6PnlfpDqxPKmqGTzXC/upK3p18xox90HhL1Sq9shkIAAVgzU1+krjE94ndBhP+DN04n3btvyzIxavc+f4Z0eGekBttDgqkmjB06NrLrDigjXQEeat1XbzDv+dSmiCnRUVcBI1cFhh5Era6EQvcyZNDTCaqV3v9UXL4HGJvcQ7EDYDaERI/8Uy5wC+iJL+QEZjoYKbLPG1BDa2+A8wGGY22+937dnpaPFgrMyRUhZYhT0A5+4X/VP0E8vJb+GWoAsB8y553cmyxlZxtUkFONIgGHC0ByAM4gLmVeBXOcFn3xW2ihj46ToUtjgHYQxGkMoqdl3YGektNzyTaJLi29Lr5/vSc/5FE6fHX39Wq+NEUYmP2lvRdzqLCwY6HxhjR0esqNqSsDqzR7aQe6p57APw1ZJfk9MpBWH204Yh6A2HuWCYiWq4T4aBfBwTfPaXLv6vUm+YsN
 3nxcbIgf
 jIxFcYFZTFPyPTc/Y89b2A/ZPYDwQPoJvn/0d1me3aaLHau1M3cuWMUAbGswNs7kSIQ9DCDIEazrZBHBKxnb2+bKue9uVzIt6sg7nUxmws4jWMebq0LBa/KWdMXPk7Ck7aOFsm5AD0OmOeLc1z+DJPrjXlaE1/GTLhYlvKXlQnrPfNAcT11lT3zh+Z85h53Cw1ndHo4jpbvLbf5AbCIereTAjLE6/xMC7jL0xO5JoHuY9VrDB1gYgZGgYhNbHT3lyPpijA0AFMbzMHjHhZHhjhEP/tb3L/e0Lxhs1RkHTvr8NobzVhJqNTpR6V8wfiY+VAsbcrLyH2QKj6ohD4hbn9IEbuB25w57y+eaiKJ/pByUv4BZjor1jh+mlqArR37LSGjIHAfWZOmJuz/+7mDcr0vwhFnOeD3ISoyXkBITP+adxqkuF/G0YV1nd8n5vwP654NipHbxAh4JR2ws=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 23, 2025 at 01:56:44PM -0700, Andrew Morton wrote:
> On Thu, 23 Oct 2025 10:32:51 +0100 Kiryl Shutsemau <kirill@shutemov.name> wrote:
> 
> > Accesses within VMA, but beyond i_size rounded up to PAGE_SIZE are
> > supposed to generate SIGBUS.
> > 
> > This behavior might not be respected on truncation.
> > 
> > During truncation, the kernel splits a large folio in order to reclaim
> > memory. As a side effect, it unmaps the folio and destroys PMD mappings
> > of the folio. The folio will be refaulted as PTEs and SIGBUS semantics
> > are preserved.
> > 
> > However, if the split fails, PMD mappings are preserved and the user
> > will not receive SIGBUS on any accesses within the PMD.
> > 
> > Unmap the folio on split failure. It will lead to refault as PTEs and
> > preserve SIGBUS semantics.
> 
> This conflicts significantly with mm-hotfixes's
> https://lore.kernel.org/all/20251017013630.139907-1-ziy@nvidia.com/T/#u,
> whcih is cc:stable.
> 
> What do do here?

The patch below applies cleanly onto mm-everything.

Let me now if you want solve the conflict other way around. I can rebase
Zi's patch on top my patchset.

From 3ebc2c6690928def2b123e5f44014c02011cfc65 Mon Sep 17 00:00:00 2001
From: Kiryl Shutsemau <kas@kernel.org>
Date: Mon, 20 Oct 2025 14:08:21 +0100
Subject: [PATCH] mm/truncate: Unmap large folio on split failure

Accesses within VMA, but beyond i_size rounded up to PAGE_SIZE are
supposed to generate SIGBUS.

This behavior might not be respected on truncation.

During truncation, the kernel splits a large folio in order to reclaim
memory. As a side effect, it unmaps the folio and destroys PMD mappings
of the folio. The folio will be refaulted as PTEs and SIGBUS semantics
are preserved.

However, if the split fails, PMD mappings are preserved and the user
will not receive SIGBUS on any accesses within the PMD.

Unmap the folio on split failure. It will lead to refault as PTEs and
preserve SIGBUS semantics.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 mm/truncate.c | 32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/mm/truncate.c b/mm/truncate.c
index 9210cf808f5c..6936b8e88e72 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -177,6 +177,29 @@ int truncate_inode_folio(struct address_space *mapping, struct folio *folio)
 	return 0;
 }
 
+static int try_folio_split_or_unmap(struct folio *folio, struct page *split_at,
+				    unsigned long min_order)
+{
+	enum ttu_flags ttu_flags =
+		TTU_SYNC |
+		TTU_SPLIT_HUGE_PMD |
+		TTU_IGNORE_MLOCK;
+	int ret;
+
+	ret = try_folio_split_to_order(folio, split_at, min_order);
+
+	/*
+	 * If the split fails, unmap the folio, so it will be refaulted
+	 * with PTEs to respect SIGBUS semantics.
+	 */
+	if (ret) {
+		try_to_unmap(folio, ttu_flags);
+		WARN_ON(folio_mapped(folio));
+	}
+
+	return ret;
+}
+
 /*
  * Handle partial folios.  The folio may be entirely within the
  * range if a split has raced with us.  If not, we zero the part of the
@@ -226,7 +249,7 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
 
 	min_order = mapping_min_folio_order(folio->mapping);
 	split_at = folio_page(folio, PAGE_ALIGN_DOWN(offset) / PAGE_SIZE);
-	if (!try_folio_split_to_order(folio, split_at, min_order)) {
+	if (!try_folio_split_or_unmap(folio, split_at, min_order)) {
 		/*
 		 * try to split at offset + length to make sure folios within
 		 * the range can be dropped, especially to avoid memory waste
@@ -250,13 +273,10 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
 		if (!folio_trylock(folio2))
 			goto out;
 
-		/*
-		 * make sure folio2 is large and does not change its mapping.
-		 * Its split result does not matter here.
-		 */
+		/* make sure folio2 is large and does not change its mapping */
 		if (folio_test_large(folio2) &&
 		    folio2->mapping == folio->mapping)
-			try_folio_split_to_order(folio2, split_at2, min_order);
+			try_folio_split_or_unmap(folio2, split_at2, min_order);
 
 		folio_unlock(folio2);
 out:
-- 
  Kiryl Shutsemau / Kirill A. Shutemov

