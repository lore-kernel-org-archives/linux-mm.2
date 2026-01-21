Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9167AD262B2
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 06:38:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DABEB6B0005; Wed, 21 Jan 2026 01:38:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D83816B0088; Wed, 21 Jan 2026 01:38:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C82FC6B0089; Wed, 21 Jan 2026 01:38:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B62786B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 01:38:47 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7B2EAC2982
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 06:38:47 +0000 (UTC)
X-FDA: 84355017894.08.11C923F
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf07.hostedemail.com (Postfix) with ESMTP id DF15240005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 06:38:45 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=RdMO5FM8;
	spf=none (imf07.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768977526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I4u8IJVOmEePXbjX+xDPzw9Fz95TVJK6x3yuVVad3RA=;
	b=xvUudLM5ieTNiAdU2sBE5gxexvfpi6Xkz/JpUHq6dDtMA0jI9X5ek16xrKTd/4ymaoE9X8
	kH1ZK0tYrnk3dSl0/qDgCcQjNpoywZOjeB3cvkZkkF0bsqkV9RIJIKMBGcLQINc3AiiouT
	766crqQT9F6oLUFSrCvz/5zFnepGcUs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=RdMO5FM8;
	spf=none (imf07.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768977526; a=rsa-sha256;
	cv=none;
	b=ZmUxSFhPhS6Tgfl3YkQ7AB8Cv3edJeFxt53aR0euRcheCOKraFud2SoZ3EjxTSfQDKciDP
	H5gVY6CheHEikU+YqmKUeJG7ZEAqX2zP6oHSKzn3+eQo+F9X0fIgdtV9cmnBJ9uBgJjJz1
	qIyM1KBVXXM2a3xQgkGC98C0vCI8fY0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=I4u8IJVOmEePXbjX+xDPzw9Fz95TVJK6x3yuVVad3RA=; b=RdMO5FM8i5WTJ7VEdnht2EtYIq
	rOCcKGWGEQyb6LXeAgHDAkjx4Fw89srT7KQ5BArMiuH1XizTI0FFdqXzIog8rKC4cPf/PrtGjihxB
	8t9AHLWkxLdjWhtaBRTjCbnCpGp3xBBaJfTs3OEWIcJMPpLyvrNQKbXMSiq1Vf5nJfn9l2HT5lV4A
	atktoik3uXhPt++HSghrOxMZZmRaTxabzmsPOrdbZLsuTBZQeyZf5bOL5pvEbWwmu2wI6c8Vd7O3w
	riGv4kijh3P6qTscVzoq2FyWDaZgbVUBerdh7y1quImqB0enBxniEwFCvqbPTwvPhx88fH+Apjrub
	3fzdOx9A==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1viRrJ-0000000FzUi-3JeI;
	Wed, 21 Jan 2026 06:38:29 +0000
Date: Wed, 21 Jan 2026 06:38:29 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
	shardul.b@mpiricsoftware.com, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, wangkefeng.wang@huawei.com
Subject: Re: [RFC PATCH] mm/khugepaged: free empty xa_nodes when rollbacks in
 collapse_file
Message-ID: <aXB0Zcu4bIEvSSuX@casper.infradead.org>
References: <20260121062243.1893129-1-tujinjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121062243.1893129-1-tujinjiang@huawei.com>
X-Rspamd-Queue-Id: DF15240005
X-Rspam-User: 
X-Stat-Signature: kg4m977zkwi384ugy88oei65c5w3emxz
X-Rspamd-Server: rspam08
X-HE-Tag: 1768977525-946776
X-HE-Meta: U2FsdGVkX1/XDLCIqo5yGHta+dgXgWbY5Rl8Lfu4EIWyOBZTXZXSsx6fD0+kh/KPPmdpcGYYRihcVL8OlYhw+u25MU5b+2i0Pc8k9gHoRK6YNPXqM1vScadc9gF86H4k1PLXqLFWiXvNSOAEtFJ0+JlPNq3qOeV4Scdrj72OV6pjtVzTZ+Sxk8P6KlFSxuO0uvAEdyBTv6YSUlRCkHDs/dto4ea8ZO/PB1Te9t0c/7Zq5NUt6l9ipTzYRdaFWaMR+k1vkn8RdMaDdwd0/eTO8qg+M1mscVeVinegTGCrykeSDO3/gR4abtGwVsQYjtr6xPL2yRR+/mipJn6JnR1Jt13cBytzAjHBqX4TTFOXmDgGapODiheBLdrZWHGImuIUKaMAFwf4DiDTnU6/UVlbYJbiIjigGwqzglEtGtPorEY5z4ootxmhtC/fUE4e0voFk4Hq3or4RHP/xmn8nd0xgLbkygyb4nwTRM4RF4AVISNUaEAJgjdLn+dmVpo2We7IBcHkXT6RvafRKntzE8jbiqGJp298rT13PfIReje4Q0NxT3edxqVpHBy4NzhF1cXsjAvDD9CdwmtYu3eEa3SJ56E5yLkbBHBYVQz39d9Nn9gP1DmhpPnedMljIyOegWzScoTS5cPGTsV60uKdJZeNhdy4LqGFh9napUjRzqRrmcRHigA4SDE8UX8H794i94MRIiMAfYTSxw/jl51vfNjPn0YSL2UihJLTummuRO14gW/4Gpb2Ac9afp+0ZtMI4e84tPJYCP+E4bYAOxPtgCNZI6t7m86VPlOBGVc1hTgy3DZ3Z/iU+p/b9grGaiuu2uCMgUNoDG10IdPX6Cz4jW9bdt0in2jh/QPzCzI7jQal8Qo7FOd9qWhpNp8UGne4JLfEMbfw3PFhwRCln0NivFRiX5AluezDvFk3e+wmdGvkwbU8Gubv+1YTDm8yAtLDER56+XgwlDFlomb1WLt0JbE
 0hAd4vWq
 pn6HKyJz7Kn9EshVWdtgjTmTb1O3bh26npbQIH27SAe9CwSLyGSbGNNPwgG8nF3p4CkK0FHeC6oJJQohvwc2N+mOyN2Mp74/TWrVpwp+xyOw00Tmg/nyjGuCekWHgDsAVjzR/oc2pDFPn3qTYR4nJWLKXXhCrhLp5GCsKz+dwHTtTilj6jN2okzNungaMqvaztewbugDPpltV6Ql3njEulFI/5KxFdnfrGzJAlnWcoXK2zXy4ghV0HjnwJ3o0/CfUTuSz55p+S8CmBxF6yvjWmf7mIH1f8DliUqVqPzDov/4cRrk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 21, 2026 at 02:22:43PM +0800, Jinjiang Tu wrote:
> collapse_file() calls xas_create_range() to pre-create all slots needed.
> If collapse_file() finally fails, these pre-created slots are empty nodes
> and aren't destroyed.

try this instead

diff --git a/fs/inode.c b/fs/inode.c
index cff1d3af0d57..85886af1e7ab 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -744,22 +744,18 @@ void dump_mapping(const struct address_space *mapping)
 
 void clear_inode(struct inode *inode)
 {
-	/*
-	 * We have to cycle the i_pages lock here because reclaim can be in the
-	 * process of removing the last page (in __filemap_remove_folio())
-	 * and we must not free the mapping under it.
-	 */
-	xa_lock_irq(&inode->i_data.i_pages);
-	BUG_ON(inode->i_data.nrpages);
 	/*
 	 * Almost always, mapping_empty(&inode->i_data) here; but there are
 	 * two known and long-standing ways in which nodes may get left behind
 	 * (when deep radix-tree node allocation failed partway; or when THP
-	 * collapse_file() failed). Until those two known cases are cleaned up,
-	 * or a cleanup function is called here, do not BUG_ON(!mapping_empty),
-	 * nor even WARN_ON(!mapping_empty).
+	 * collapse_file() failed).
+	 *
+	 * xa_destroy() also cycles the lock for us, which is needed because
+	 * reclaim can be in the process of removing the last folio (in
+	 * __filemap_remove_folio()) and we must not free the mapping under it.
 	 */
-	xa_unlock_irq(&inode->i_data.i_pages);
+	xa_destroy(&inode->i_data.i_pages);
+	BUG_ON(inode->i_data.nrpages);
 	BUG_ON(!list_empty(&inode->i_data.i_private_list));
 	BUG_ON(!(inode->i_state & I_FREEING));
 	BUG_ON(inode->i_state & I_CLEAR);

