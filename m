Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E446606A31B
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 02:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=zMv7TaMh
Received: by kanga.kvack.org (Postfix)
	id 57E736B05B4; Thu,  5 Nov 2026 21:59:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 554BD6B05B6; Thu,  5 Nov 2026 21:59:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4923A6B05B8; Thu,  5 Nov 2026 21:59:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 21D3E6B05B4
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:59:47 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 810CB140B83
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:59:46 +0000 (UTC)
X-FDA: 85403189172.27.FFB2EDD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id B3C89A0009
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:59:44 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=zMv7TaMh;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793933985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g0MaA95Bx3ZoEANP3GZek3B2SzCrodWB+6/VqV4dGcs=;
	b=f2auGEj94rV7kAkcueyMjyzhxsi0yN+dHH44cdBF2vs3AVCv8PDUEgEVTgFFodNxnvEpJi
	vuHHew7LnAdtXOr7k52S7kzSEx63WapPlpeHsJFl3Jp8McaAwGScUc8yQZAFyltG0Xb+Jq
	LNQpHvTpF0E7zSz+60FrJTKM8vUFi5E=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=zMv7TaMh;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793933985;
	b=0+l/I1OlCP0Mp/Aj6SZCwvsPAN+yR8mRPwc5hjp6QvwP4E205g2NXWlHK9879M/TKpHpdt
	SSDmLg0Fvckhgdm6LqJbMLgrCPxuiv4pa/6TkIA4kmd+81vk5XQJ3Xnh5Ru8Sl2ytv86OV
	lLoa0tbo0yTQCxY5XqFpGCwIwGTywuQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 305D360202;
	Fri,  6 Nov 2026 02:59:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F5281F008AB;
	Fri,  6 Nov 2026 02:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793933983;
	bh=g0MaA95Bx3ZoEANP3GZek3B2SzCrodWB+6/VqV4dGcs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=zMv7TaMh+8CJiKiz3Jbclm1ei9kNfUkBmRzCfBVB6LdILr7EU2lvxKPKfCnMNTgBf
	 nfcA4A1uqXz6FO3f8sGRDFS62Vmu1W30tiaLLBCRPfgDFDZj407JOhFeLegCN2Axem
	 Q+UptajLNRQmUmpdda7AanFZeq5TNNrrJpLm+CJA=
Date: Thu, 5 Nov 2026 18:59:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Josef Bacik <josef@toxicpanda.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, David Hildenbrand <david@kernel.org>, Vlastimil Babka
 <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato
 <pfalcato@suse.de>, Muchun Song <muchun.song@linux.dev>, Oscar Salvador
 <osalvador@suse.de>, "Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
 Sarthak Sharma <sarthak.sharma@arm.com>, linux-mm@kvack.org,
 stable@vger.kernel.org
Subject: Re: [PATCH v3 0/5] mm/mremap: fix accounting on a partial move
Message-Id: <20261105185943.3d6f4b34fbdbba8599bc7360@linux-foundation.org>
In-Reply-To: <20261105-b4-mremap-pre-split-v3-0-f8789de76849@toxicpanda.com>
References: <20261105-b4-mremap-pre-split-v3-0-f8789de76849@toxicpanda.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B3C89A0009
X-Stat-Signature: dykx8i5czn81etonbiwxfyqa7y8ecbsr
X-Rspam-User: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793933984-926753
X-HE-Meta: U2FsdGVkX1+Xr5S4Gz/ZESFPJE2YcE7q6Tv6wLgfQKm0YbbrCpsjCv1hnvT2tTdi2egyWvgWYTN7al4jZqMrgn2/4MFeA5/oJEwYcGNZ2pqllZK3ezjGFYg0sGa4qjO1cTyiLIGVZQh+VSAA+P/b5i2uCprK8VA7u5TCpcLhPHJAh63DieEt0oL6zvHX7MqVtOjRO07bNby2NWqwrfwKRfpXzm86LbJCaj0MGHzjM6ZI0gPcMdfK95t+KG+3wy9FpoT7iMXg9ZTE1Lh9tTqieLxsTi9fzLtY4fFBpu4PaV6hcyIkC+Exj+xr9w/s0pv4sH9S+H4bU3LPfqt2iZzsRPZdvYLnOft5zpqi5/86wNj6k36ddHpsNJBi7wTRAJsrFmg1PtbP+3kJCKcx6QLdILOvlnyjD+R+giBk+yCdeXnv3guc20A3Scytb7SrhD+M1ofEahZ7Ya/ML/NZN46iherVaRmNa54ldsjeioLO5nV7FX5wvbXTjQU49cXfmSF+KnVw2KHGHgXkHl/YrWvMoAQJBIgZVkShhlDv97+Zw0QyJge1poeQzyKanO60/zPkcwnM9A5zuarmBQ0I2vpXQmX8Reua6b61tdusrWP0YozzOkhyNAk/1g5HOKFzs0GYMhPU5HSw9cKxnaYEroZyDJhA9R2mv7dipxekTBvF419e53EFNn0jOCN/xkPsbkpgUplOggx6V051dU5TmS3yy6TRxOK+trTm7HOVKKox6m4lSvaN+FNPLEyoEvDzXf03gaL34AVeBxCPGMDepSt6YN7ZA+jdv5Uir0FczxD0MV3ZqHoh9becbh4lFoPhxrPiJFcJe3SH5DfKw/bCkNbwWPeP0cDcfJyqV8n4S5Kow9hz5bFYjeiWUttJQN+f7bK5ebzz4ErSMoxWHIZru6h0N/joFjKYug3CN4W4QLZp24l21Ukh/bXif7VCUl5XUeSwnrJQOR1OZ3PVlq4T6T3
 nCxh817E
 wmgTBghPinQ+mXrjwjeNFWEoChPVjY9i6RpAm7/WI+FL7F15L6pfMugxaCTGIM0KT5aoGyVR8eJnaV/rveqrejqOB61dqh121ddcHq7uhoGX4c0sAt6N5gcAYTOmoS8AnFbFsIjLruXffsv0+xRo+R3ALTk85Eo7y8tnG5CUDe1gEmTqwL6pX96KPQCQQFIl5R5s1g5uUDUAtPR9BsS1s3iprsThXfZS6aCl6lC9tpH+2I9GJklyRhPNA2bWz5C508O/FDYKMxene1Vln09L7lmtBP4LgRgcrdhWJMCGgDOogqYWSInDAQE0l5eUCJu6MsU88tdeSEZKjHPGwWGneORAiQJkHU0uhIhd8kL4jKhoKbOamN+71w04f5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 05 Nov 2026 14:02:02 +0000 Josef Bacik <josef@toxicpanda.com> wrote:

> This fixes a hugetlb reservation leak and two Committed_AS bugs in mremap().

Indeed it does.

Please lmk whether LLM's runtime test plan was sufficiently complete:

: I reproduced all three accounting bugs before the series and verified
: that they are fixed with all five patches applied.
: 
: The new HugeTLB partial-move selftest left three reservations behind
: on the baseline and none on the patched kernel. First/last-page moves
: also leaked three reservations before the fix and none afterward.
: Whole-mapping moves and populated-mapping controls passed.
: 
: For the unmap-error cases, identical diagnostic hooks in both kernels
: failed the first source-VMA split, or allowed the first split and failed
: the second. With a four-page source and a one-page move, cleanup left
: four committed pages behind for accounted anonymous mappings and one
: for NORESERVE/shared mappings on the baseline. All patched cases
: returned to zero. I checked task-specific accounting deltas and verified
: that every surviving accounted source segment regained its account flag.
: No-failure controls also returned to zero; destination data was checked.
: 
: The updated mremap_test passed 25 cases, including both new old_size=0
: shared-duplication cases, plus three expected rejections for overlapping
: or misaligned requests. All eight mremap_dontunmap cases passed,
: including locked partial moves. No unexpected kernel, KASAN or lockdep
: diagnostics were found.
: 
: This used x86-64 KVM guests with GCC 13.3, KASAN and lockdep: 8 GiB RAM,
: four vCPUs arranged as one socket with four single-threaded cores and
: one virtual NUMA node. Both kernels contained the same temporary
: fault-injection/accounting instrumentation. Cleanup tests used munmap;
: process-exit cleanup was not separately tested.
: 
: Tested-by: Andrew Morton <akpm@linux-foundation.org>

