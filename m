Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE6B9606A331
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 15:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=BS+wWOBp
Received: by kanga.kvack.org (Postfix)
	id 179D56B05B0; Fri,  6 Nov 2026 10:15:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 129976B05B1; Fri,  6 Nov 2026 10:15:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0189C6B05B2; Fri,  6 Nov 2026 10:15:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D12696B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:15:45 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 31A21C0820
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 15:15:45 +0000 (UTC)
X-FDA: 85405043850.20.57094EE
Received: from mta0.migadu.com (out-214.mta0.migadu.com [91.218.175.214])
	by imf16.hostedemail.com (Postfix) with ESMTP id 121A4180003
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 15:15:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BS+wWOBp;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.214 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793978143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BQ98lptuezRaClL/2frvW7Abmv8umTPGLgyOyGvfOsk=;
	b=F+3HHUZ848/x3pX/iiE6hL4auHInXcDTR8M1Dim0xnitDTp/HiwFJ28WSL+pFVWrYDZyqs
	ZxZUCOoDlMcxUVt5poBY9MUYt/ieoa5uvNV7jBDX87PVc5uGdOgUoEs/xkOHkaxURoqttn
	dt/YYc5KiZ3RH4QHwZCZkFu/LH1xY1A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793978143;
	b=oABdNvByqgc55oqqC3kYRz5eOIncw9nUSpqc0VVyCOnwlC6dGhAKtyqBLJpO5EjFcp6gfn
	+jJNdWwBChqWlRSeuX4d5uMFu2j0gLaz2iE2n0xaZLKTjT2zz/mCwMdlLe+9E4lpc0zje3
	F/DKM1Imz+KmXWgg8CktmNE/+MrD3FA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BS+wWOBp;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.214 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=BQ98lptuezRaClL/2frvW7Abmv8umTPGLgyOyGvfOsk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793978139; v=1; x=1794582939;
 b=BS+wWOBpkanXuDOzgufMBLVEhna7aL+1g1sop8joueXjNrvUxsu52rtxyL4e5+hOz9zL8jlw
 Rh9ddG2x6Kkkn/xyndIPS43SbZU39nj7wSqa7RQPOvmrrvbiMp0l4BaQy2ZZCzgMAJU5DmfDGTC
 wzRss1N8g3/8HPDXGEJwL1DY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 8657a346237bb2f3;
	Fri, 06 Nov 2026 15:15:39 +0000
X-Mizu-Trace-ID: 8657a346237bb2f3
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	willy@infradead.org,
	jack@suse.cz,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	peterx@redhat.com,
	hannes@cmpxchg.org,
	songliubraving@fb.com,
	riel@surriel.com,
	hughd@google.com,
	will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	peterz@infradead.org,
	jgg@ziepe.ca,
	kevin.tian@intel.com,
	joro@8bytes.org,
	robin.murphy@arm.com,
	steven.sistare@oracle.com,
	jhubbard@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-arch@vger.kernel.org,
	iommu@lists.linux.dev,
	mason@kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 3/5] mm/mmu_gather: flush pending references early before the folio limit
Date: Fri,  6 Nov 2026 23:15:33 +0800
Message-ID: <20261106151533.89428-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261105-refcount_overflow_stable-v1-3-70b9c655da3e@kernel.org>
References: <20261105-refcount_overflow_stable-v1-3-70b9c655da3e@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 121A4180003
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: auoskz37856196xjzos3f3y5o5xu619f
X-Rspam-User: 
X-HE-Tag: 1793978142-939654
X-HE-Meta: U2FsdGVkX1+PU/kY1H3T/RdPe/dmf2zjnA+uQk8U7EGCoAnBdlwIc4MmLWGDUfxf/gnuYBHkoKNA9MNQ32BqAKHFAeUgWhFJ/rRYhKSIgkrkYJSBNrcE6CETUFjeg2yfDbtnCQ86pljwy5KAcA+BqVOox03jp2MAkfv9zCNV9rjvclQYt1c6LH/nE42bDv8olnPLT5lCs4PUkz8NSn6aTwGtGCI6mipRKT6I3BttowBN9QfZUnNnfRRojtgJojs5QXRw1q0eO+9TQdgzu+ngtAfE6fZMcT0UgF3Q0PG6v8mQfMu+R97bkgjwXKtL1dsWh6+HCqGACZr4vVVBWK6pMyBVgRyuwq3WV+uq9SSWiSP54GZnpXD1+Rh61n4a6p/sEEr+SdlsilRSuW2fS2mqofWGGPTP8UP+qA/0MBUCqU1oIXEtRcZNH94BsazI0z6qSg2sDDZ71SCOl0OHiHonlOr2GiVCqL4dJ3LQrOY5ZLds+JaQ2I54bJgX5ewRKrgXU0ysPn8AkmShbKrgIPAnnLuqiTjWw6R5XFrfKYWh8pPcg0y1DMO/7/o6GOErB5OP/dJ7gToWvKh3EQdn2XQR19dtpNtQm8ETp/hm36A4i+S1ISgbORt2is0eP9rcXtN5u5KVv/3AAwlvby+5vV+JDTK4lpmMvyAsh4+nICsM7tciUgJp2AKDvRnYUtFcSCc5zNpdeFG8VQy2yVSNM2Bq82hv6+mfOPt7Dqctif2Y/qFfVZ9r8nlT4ThXsymrlb1JknJh7QepeRHRHozWqKoiQw991IivoZZKRz6kpv7nLGqBs5bOjP45w5ayiHHVe6tCGrpavUOlJQIRKd44Ee6+ku/9uGnqktpNPGIyGX1ZDK/echisUte8ND/zpMUVpLvGv2Qk8rGsn1ApJhNYfgRgO6Ckab6HhbNvFjKbUBEtFzExljnBWH2pEifg3P+hK8Qnmp1N6VsXziLQMNYwLkK
 Cq12NYyR
 ieRqyOPc+6//00EBWs2hc+ejrh5gtudQcU8w/6cJ4e2I5CGrMv12jufy4A9+DJT7SY9sAOqKZUDzaXtl9wUE5c0Dt3nAZ2YxSkza48HBgvd/6Xi588hprxWuEr2PVg/YHo2x0oVSwCoScZM43yTwcRuieocL32Mo+3jamc9AhMuNOaa9eTFqImIP+bWo6DB3xNK27uE+4v33OdnaG2765SQqNc2+/v9/yxYXBeMWBA4u1x/1ol8kaD5aRnfuI1RQ5Z1GsjT66fmFhXRJroQdHbBEIa4MscMoHVZOizjS3CZeB2Kb5f+VvWF2E1kvvN6iYHX2455iIPX+/BknA+EMAtelgAzRwdz3i6tkUt2ezRBzZDFG+XeGLjMy+dd1OddtaBHMf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Thu, Nov 05, 2026 at 02:10:12PM +0100, David Hildenbrand (Arm) wrote:
>When a task zaps mappings (e.g., MADV_DONTNEED), it can drop the PT lock
>and defer dropping the folio references. In the meantime, page faults
>can refault pagecache folios, creating more references for the same
>folios.
>
>Let's just request a flush after enqueueing a pagecache folio whose
>refcount reached a certain threshold. Start flushing well before new
>references are refused, regardless of the caller's privileges.
>
>This is a temporary measure until we have something better.
>
>Reported-by: Chris Mason <mason@kernel.org>
>Fixes: 10ebac4f95e7 ("mm/memory: optimize unmap/zap with PTE-mapped THP")
>Cc: stable@vger.kernel.org
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

