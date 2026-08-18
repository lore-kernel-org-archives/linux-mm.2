Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1899DC5B572
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 02:13:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BB036B0894; Mon, 17 Aug 2026 22:13:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06B4D6B0897; Mon, 17 Aug 2026 22:13:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC3096B089A; Mon, 17 Aug 2026 22:13:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D05F76B0894
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 22:13:47 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5D601A34DE
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 02:13:47 +0000 (UTC)
X-FDA: 85112769294.17.3DC39AE
Received: from mta0.migadu.com (out-73.mta0.migadu.com [91.218.175.73])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4F3EA180003
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 02:13:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=D1nkQdHr;
	spf=pass (imf16.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.73 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787019225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jqI+gLxknlBDLLeOTDhZctdTBOtwwvCitAa1MQ9WEBQ=;
	b=FlKeXjODmwwM686cysKbOD/7qTTJVsbxlRpMmoQ3sEG4g7GXqOg8x0adF2SLC1PioRzVYy
	ZZrhM7rMoKa58s1j+KULXBhajiegiGM+Px98T9ZiXUMVtHGHOPyKhEeDH8vTOeSmk6IF5c
	Ek2JVJn8GRdcnQTcqakQDhAtIkQGq9E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787019225;
	b=Lm5rbH1rxCSLZlJY7dh4u5JHGY3NREs9u5dqNrRCpE0zN7esgU63IJ95r23UdrB+KnMaEE
	IsScqRkV3KFkuscCLOivBz/SfRXI2R6aRSbd2xQ/hfv+nUlMIrVNyPIshHkNOnZNsULiZG
	Qwk5tIwE7n6AKRQ2F4c//kkBlxKsUJ8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=D1nkQdHr;
	spf=pass (imf16.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.73 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=0PU5qADEL7pdf7bNZgRQ74sxC6pNxIIp3raq58ojt4E=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787019220; v=1; x=1787624020;
 b=D1nkQdHrAsatLKEjVrljJKf5nRjM9kaKsf9/P4sK6XADWBro4xo81BVuU1n7FlYmyhxOK6uv
 hHMzmMtosEOFoyZHjCvosrgpfdTXH7Ws0j0vPSPniLGea4jkVOVQHW6CTVN1EAvNpwRukvZZfT6
 UkcUdKYqW1ZF7EjJKjRBS0O4=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost.localdomain (223.70.159.239)
	by smtp.migadu.com with ESMTPS id 142a8766c7c2699b;
	Tue, 18 Aug 2026 02:13:40 +0000
X-Migadu-Flow: FLOW_OUT
From: Hongfu Li <hongfu.li@linux.dev>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	hongfu.li@linux.dev,
	liam@infradead.org,
	lihongfu@kylinos.cn,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@kernel.org
Subject: Re: [PATCH v4] mm: Use a folio in the softleaf_is_device_private path
Date: Tue, 18 Aug 2026 10:13:26 +0800
Message-ID: <20260818021326.5910-1-hongfu.li@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <d0d781bf-43fd-4a59-ae0f-960c1e942f19@kernel.org>
References: <d0d781bf-43fd-4a59-ae0f-960c1e942f19@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ofizwx3qa943gtwe1thkdgs5nuafoqu1
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4F3EA180003
X-HE-Tag: 1787019222-269492
X-HE-Meta: U2FsdGVkX19KcyhjaqKbOjuz/LCIdEsRJa0yuODvv0fwEQtaTKghCHN5+sp60STZm+cgRd29fMk8fsstyvK/MDZW9Bk4jvPw4poIzqIV2RsBT2aeynz1gRhcqCOtc544J/htoJM7wkJ8pijupkwf6IvGQi2itd74G59w2I3fspVaIZIAMULL6oIr1J1LGkWoI1mO8rwXxJQITafvIYJTd3OAhPQW2u68Ph8QZltdvKS7aSoNEIhA6U5zWDv5jMQXc3+L5qTdW2Rfa1Z9MBr+ZpkZfO1bAd8zX6pfUyGNR/9q7cAVpX+qXJVI7xfDlrG4JExO0H+lZFWBrlWTHkWc79C8PHOjDjCJ1qD9HUUoBvK5k7yVT7HtIwsVYWmpCs8eUrAMEyd8JrrOtiuAx0AbVDjPlB2XE7riq+ao6bmz1a59sH7L9O059bjwImnzXHtUQO16BYhQQnBGGXUZ1CsqMGPtGWaziwqemPGgnSI/CmMx20vfzWLwRoeRKJB86Jrs2a1kDxJhzQbKbEqs7REgcB5I1bIFleGpb9KDIKJAHCRkOtUnILxdphUQPDmvB/3q0hQFehR7k9Lq7+L6LGmz4k5WdlnSabKXkpDBIq4Q/O78HMoAna6oJIjvF5E1EgZ6yto14drJGGwcniXWR6dQ+B2mkbIcGc8bdCSevlFikFeJBhxBD2x0kN9KUfhpkqrpztuQC4vREXRuNQd0c9lm3Yy86UDXBPpZxFzG13N10K7xKHc71SSpLOB2/CPoZGtMHPfNBVHUP03+3fK/SydhRVYk7l+RH7TlVxyWmqa7nYBTuzh6h5XpjYhyLSG9FDqGriBT+H0qLcGoT0tXqBCGvTv0Uko1FwnjB8g7XMS0gWrGd6Cf8HDLyfm0V9ozVMZw6tUpy2iwaTfh3keRWrrLlvH+9qCmWuu94hKwpau/UuZ3jALsA4dW0A0VqaLYQ+ZfKcB8eHZsU7gzhvgCB2S
 Jwbhgd4Z
 zTNchnL+FJMLMbRgGgY70I/GMsotymY2jMUToqhp6JMvj52WXsZLpvfLf3oPUCUU63nCfCyLPLCsKcwiOX2rOaM0Y8pVOqCzja8fHuwsyiLg8vE+x37ZvR7PkaSMxxwrgcIRybzFGXKcs42UlBAVrOwkuLVsOH6h0EQ7Dzd4yKC8iKEWzIK1ncEHBiP/p2Fi844YE8xV33TkAzJYy5ZGoWfNHIP/25fHC24GhuEpW4uqZXs7sCbHE7syhFWC4dwfk2z4aBPZID4YOlB12CEFp1ECPHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > So after migrate_to_ram() the folio might have been split or otherwise somehow
> > the page doesn't belong to the same locked, refcount-incremented folio it did
> > before?
> 
> I suspect a split.
> 
> > 
> > That's kinda a footgun... but this documents it at least.
> > 
> > I think a comment explaining how this can happen would be helpful though as this
> > doesn't seem intuitive.
> 
> I think, conceptually, calling into something that consumes a page (vmf->page)
> always needs care when operating on folios.
> 
> Passing the vmf to some callback might be the odd thing here, because the
> vmf->page contract is not really clear.

I'm very sorry for introducing this regression.
Thank you for identifying and testing this issue.

I will double-check this code path and apply your fix to run further
tests locally.

Would it make sense to add a comment here like the below, to make this
subtle behavior clearer for future readers?

diff --git a/mm/memory.c b/mm/memory.c
index 4134ac607ee0..2b6d6c863ecb 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4937,6 +4937,12 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
                                pte_unmap_unlock(vmf->pte, vmf->ptl);
                                pgmap = page_pgmap(vmf->page);
                                ret = pgmap->ops->migrate_to_ram(vmf);
+                               /*
+                                * migrate_to_ram() can split a large folio, updating
+                                * vmf->page to a different folio. Re-fetch folio for
+                                * correct unlock/put.
+                                */
+                               folio = page_folio(vmf->page);
                                folio_unlock(folio);
                                folio_put(folio);
                        } else {

