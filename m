Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F064FCA9ECA
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 22:49:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B27DA6B0088; Sat, 10 Oct 2026 18:49:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD99D6B008A; Sat, 10 Oct 2026 18:49:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C9506B0095; Sat, 10 Oct 2026 18:49:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D7F66B0088
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 18:49:27 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E2C94140527
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 22:49:26 +0000 (UTC)
X-FDA: 85308209532.08.4ED24A4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3D637A0003
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 22:49:25 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=cCKvVcGN;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791672565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jPS6JmRVMqShWeHdFYFwBFA3RIGj7GQ7jqcXY+ZDXOs=;
	b=lhrCu3nu6Y6/DN9CRhci5G6eddO2CzVnSaqxcrXOWSWfYyNm0FXGBFCQTM+DpV20koeO3i
	WHF1ylO/2fG11+wNmg+vxhurwixPYceQI78dkOSwud2Lk/tDczoBOzPbXRCPF2YRtKbhvM
	btPx0za9++EQzVAR2PGGuANNgzyhUjM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=cCKvVcGN;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791672565;
	b=E07JH3cJGFgiJ2tuV6rT7zhHkd9/tAwjms0x2NFpZ369WFvE7ekhfiYS0aHyQCp04xGbx5
	VwGOHxZWMWurRNdlNI1CJT9j1mWcu3vjZsSl3Phu0olxydm977aNAy3/eZ47Y+gl8UkWan
	HcBZU+WQzuSuOCcXFDQfloMuXRKw9Z0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9B0D1600E2;
	Sat, 10 Oct 2026 22:49:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C95A61F000FF;
	Sat, 10 Oct 2026 22:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791672564;
	bh=jPS6JmRVMqShWeHdFYFwBFA3RIGj7GQ7jqcXY+ZDXOs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=cCKvVcGNc+90nm8E9Z2ocQr0PJEM0cEkTWElHOJVfgP86fmSKvHvwMdlskZpEeeP1
	 KFoRYy18Ef80YtLtvaVFC3LlmUEIh0wTzMMm43s9NpjOL+NTXwpt8D3PGv8KoiDATy
	 w+caLivHqYdlKmqVfBfFhIoxu95yqs+f9h6x/t7w=
Date: Sat, 10 Oct 2026 15:49:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Johannes Weiner
 <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Harry Yoo
 <harry@kernel.org>, Usama Arif <usama.arif@linux.dev>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan Jackman
 <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v3] mm: page_alloc: make defrag_mode retries follow the
 promoted order
Message-Id: <20261010154923.998e04e42093ffe6c7c205ee@linux-foundation.org>
In-Reply-To: <20261009125503.126202-1-kas@kernel.org>
References: <20261009125503.126202-1-kas@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3D637A0003
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: noeytrz3qz868qb44puaxxsczuh7mi71
X-HE-Tag: 1791672565-908490
X-HE-Meta: U2FsdGVkX1/wX3dX3p2NIwPgauqz0VEWgWkU7M0IwYalKVhsfn4ipAy71XrOlrxcNdlQQBluSJLR7XqdYmm/j+3yQE9bcw8KAnNMalddQeN/OESHuxPuSXBdfGaj9UGsRzdTgSzdHb0F9Pvv98TGqgHX4t59zB/jqzBrMDxeI5au89vIjm7IZ1WUOpP+eZTJuqa2jwUIPHUMe9WOTBE7XsVg1xCPT85wv/3unsbkjJGKSOrgOxwubCyl707D2TXpi2FGFUyrsbFCyVadLf7x1Y/TL/E62uigHlfn15ptsJq1V/Rc0dHnmaTBmYl4kqIIyodd5R0bvvKVsXh+YPjzB85D/NrLl7BVmvr8JE1fTeya10ngi6UkLQfS7zTRU+aCo5ybeD8pqJ4/gbNqXJ4qll/kMPpv3SEoJIjjcJNdIUkxS4oAq+8sys6YMStrqhWdwkzzoldKI4fXA7RXbYpVdSNKtlDq9SacFapQznz/j4wnqmo7T0m/JJHIToArJedVTS8Qj7NuIv9reu0TibkD1BgH8H9sS/F026EQ4HH4AdPb6voiW1nlWsTgc/WTuvOX5zgYlfvXgn3PmyJuAxwk5EGwO5qbOtKa0wxGPFzSTIqD33Ti0MNPrqQzMPdFJT8IeW8V8FEeFTlFCMOktZaAvbaJnG9vCPQJJ0EFShSLHqHU0wxx/fbiew0wfzCME/UQ4GJCa6p6snrR8p8tGLlB+f+iZ3OIFALAegWRO6h5BZUo8+YGl3SxmgAJq797KoGgh4v1LnEMiupT+KR+m58ZUTXkmf/hdI0aKAvO7cIzMYpceL60HF4CzZMCdrJUDsygWq/zKJgeDQAozktzN86t/87OFamKKltxSFTm2bownh+sp5giKdk9K+Yg5MvAuIj69RICF1RYCqiStk4yAR4Yr3ENkwoXXpePIbSrJhQFtDsQfIbLZPC4nvJFMdo2E9j6pHodRi5cPL7eog8/kJZ
 qpwzN/9k
 Zj89emAtJV9rH8OJBDQxQlP5jEYdnSghQxwGy0cZxh9OlgBUwEfk6xO3skKzBLM9Nq0fXFWYrnvXMA2AWWMPRlhfDUfjoQtlfXgPZHQ/PBxu+gifhAfGnvqogmfBpMrh+DdqmdUcvgq4UrhLoV21cfOyavI9MdX4RCBua5ZzWqpHTFJY3mWfV/lqga6vmP0wlxCOKeDoLYyrwoZyOR/FzILRDcwzYZHAzENcb1Xk0XLi4UhmEZBuTnh07jtIHIDZia3Ta84iiaxDUl7Wmo1pStoMi3xC8p22zxyALuximOzlrJ9DUbiOJSPLnycWVp6Og92tyvQqYVVPvQ5NmNydV/Y1OrW1yK087VJgSpiNQHnDTDY9b1q79EoLPBjpOR5LEYbQP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  9 Oct 2026 13:55:02 +0100 "Kiryl Shutsemau (Meta)" <kas@kernel.org> wrote:

> Since commit 7e8756d7ad22 ("mm: page_alloc: fix non-movable reclaim
> storm in defrag_mode"), direct reclaim and compaction for non-movable
> requests under defrag_mode run at pageblock_order, to produce the whole
> blocks that ALLOC_NOFRAGMENT needs. The retry decisions that follow
> still use the request order. An order-0 request can therefore retry
> indefinitely without ever reaching the ALLOC_NOFRAGMENT fallback:
> 
> ...
> 
> When a promoted request takes the fallback, reset the retry counters,
> so that the fallback attempt gets a full retry budget before the OOM
> killer is considered. A request whose reclaim was not promoted spent
> its budget on the request itself and keeps its counters, as Usama Arif
> pointed out.

Thanks, I updated mm-unstable to this version.

> v3:
>  - reset the retry counters at the fallback only for requests whose
>    reclaim was promoted; a movable request already spent its budget on
>    itself (Usama Arif)

hannes's concerns/questions at
https://lore.kernel.org/20261006081050.GA234057@cmpxchg.org weren't
fully addressed?  I'll add a note and await followup.

Here's how v3 altered mm.git:

 mm/page_alloc.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-make-defrag_mode-retries-follow-the-promoted-order-v3
+++ a/mm/page_alloc.c
@@ -5030,14 +5030,17 @@ retry:
 		goto retry;
 
 	/*
-	 * Reclaim/compaction failed to prevent the fallback. The retry
-	 * budget was spent on making blocks, not on the request itself;
-	 * give the fallback a fresh one before considering OOM.
+	 * Reclaim/compaction failed to prevent the fallback. A promoted
+	 * request spent its retry budget on making blocks, not on the
+	 * request itself; give its fallback a fresh one before
+	 * considering OOM.
 	 */
 	if (defrag_mode && (alloc_flags & ALLOC_NOFRAGMENT)) {
 		alloc_flags &= ~ALLOC_NOFRAGMENT;
-		no_progress_loops = 0;
-		compaction_retries = 0;
+		if (reclaim_order != order) {
+			no_progress_loops = 0;
+			compaction_retries = 0;
+		}
 		goto retry;
 	}
 
_


