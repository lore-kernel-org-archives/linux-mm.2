Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDB26606A337
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 10:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=oJi7KdRq
Received: by kanga.kvack.org (Postfix)
	id D83ED6B05B0; Sun,  8 Nov 2026 05:09:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D14FB6B05B1; Sun,  8 Nov 2026 05:09:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFDF36B05B2; Sun,  8 Nov 2026 05:09:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9FDD26B05B0
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 05:09:11 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 27C2D1A0341
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 10:09:11 +0000 (UTC)
X-FDA: 85411528902.14.6FDA3CC
Received: from mta1.migadu.com (out-240.mta1.migadu.com [95.215.58.240])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0E3A1A0002
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 10:09:08 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oJi7KdRq;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.240 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794132549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bMJlZTOTEJlmOuVWJz4GRAC6Q9ZXPrxhv+08R2sTA74=;
	b=7vNNVNQ58q1ze8QU1cJ8dE0FeV3yVf5JVlh9Y0xY90/eIAdwprFykQNAQiyz1iLOfKzra1
	w5Adjbh4bX7mP4feusXGvvCTEpm5vLQPeK2IJ1BcKwsiyU7TOmev1FsTXVm6bmEuY0vaxV
	eN+cy6waQLECZx3YGdH4scB/FLIycz4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794132549;
	b=Qt2Xy2EeA0JouVmn232dysrVoib9tB546MuvEBygYzt7FCJMwZoUOcyhQyAkaoTaWTTxWN
	IMJJhqChIKliF0msvUrsKhChtSEg9KuAdKM2P/2LVTyfSAAUHbxzwrd/Lkjj82fS148xme
	N/AmFlg49m9Kr3y2v4KcD+xbh6QLuVg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oJi7KdRq;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.240 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=bMJlZTOTEJlmOuVWJz4GRAC6Q9ZXPrxhv+08R2sTA74=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794132547; v=1; x=1794737347;
 b=oJi7KdRqKwDGAFpr7Bmv9zJzxhR4ofd/6SKv8EmW8rADUsNX2np1y5SzvNmn5z4ppLwGdrb/
 KxVerOoFanoXU9/Vb9kHUjRBhpKKjfHm1sR0yFld2vc2O5vaimBScxbcCJH+/nS9tTBJnuoOJRb
 fiaWVOj6l7ZrFkwFxkVXDI68=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 2d28383a0356ad5a;
	Sun, 08 Nov 2026 10:09:07 +0000
X-Mizu-Trace-ID: 2d28383a0356ad5a
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: hughd@google.com,
	baolin.wang@linux.alibaba.com,
	akpm@linux-foundation.org,
	david@readahead.eu,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	stable@vger.kernel.org,
	mason@kernel.org
Subject: Re: [PATCH 1/2] mm/memfd: handle GUP pins more reliably when write-sealing
Date: Sun,  8 Nov 2026 18:08:57 +0800
Message-ID: <20261108100857.94336-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261103-fixes_core_2-v1-1-f332954f1df4@kernel.org>
References: <20261103-fixes_core_2-v1-1-f332954f1df4@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jrny543iiag8gp45wb1eruc695m9gj6h
X-Rspamd-Queue-Id: 0E3A1A0002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794132548-499386
X-HE-Meta: U2FsdGVkX18wYuVZdsawDRsSdl2+q3YrsPGMm41PAO+Ly8av7sK9QfyAApMPICYbcrHhie5kpDZ18MNSng17DvEy9s17qDrBxTbY2M9ELcTWtTtcmrBcx2uvRoXf3tRWrL6ZH4H00AcTibja99tdYjpAe4VAoq4J4Zbg54/JoOXCxnmu60SABECBCMYUYakM9XI27Qx/OEvP/2Acvb/XB7KvaLVJUSD9aXQmaeU8E6TzMDSIc0r3sbC5+efcsw9X8MWitwuO9MwBw7vmJUgTX83sJQ7quoV38+wTK/AdJ6iIlS366XTTLnEzCi8S+zVigzkRslqHbJROuow/DDOjTOKQ2jCE682afIlYPoUZRGniMVDSS6F5yeEn3k8qkkZRCKh177Ucbb40RpiGnavc70KB6iokr62MwYE0iUsjx/3WmDAEqQqidXrWgQSfKCg7AtSO4YkkGIv0+Jid0p/bSP1FJvqZ7qNZYyKsSOR56UpL6QKmTdtNChhDSl9vl3jSROngIYSovA4di9pZYvUj7qwMmYGXjICOj+Sn5qvdPgFVdIKyx1/2/5AJnmDH2KgzAwEp50jZNvD68ZFbhvLnOjYm3rowmIwx+xUz+1OKlIrb0mE4CNYPaeQhTBN3aGml/FiBP4v9XTFtcg2Cp0Qq9TU2iTbqXKNd/HxW71UuMXzjpepTgeTmClLWXHBmBKxICr++LpkFg6KAYj0GV8ZTp+ECGGVcpsI2XXuv2xj9AReG9GB2rAmHDD1MiCZyyokpGL0dOWCWIVDbSZ796RKVfoEIU1ipqQTpp7mhRis6b58qexZXe6y4zTbGQ3imKIPbeRrCo3kLaidE0HEoRIRo2a8Gm0X+RG4zv3JZOberiBOGfsRkMagk6o5lgJTNRMrA2a0nYWMj9uMX+EMAyMX6AfNISV6IENu5DvC3Z/Ztw8+NGivch31pVXBmjeIZwpvjIn9T9V0sEQXkAEon7Ai
 mrZfvWH3
 V1Yb+7R1+BjBVLW7AjntrJLuO9IQNHoao5yXIFrKCOcLay9srdTx1z3D7X+4w3DK3Y5/QzlB4OT3ZddPbwSMNz+EwJz2UT7IeXDsyqhfD/pwPA3p9xn2hptclH4me0J98O2fbRbCm9smavyuEB0T4BdUgI1cx5BLJdftQp/J0V4wWUFpzliSQQ/fxRaLeTYQ97x8EXa8/2ToadISIA2PjCun/LvuI6I1DHJQ+q2QwIiSi4dh7TbtbFfsa2NFzzxdeHyh/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Tue, Nov 03, 2026 at 07:31:44PM +0100, David Hildenbrand (Arm) wrote:
>memfd_wait_for_pins() detects GUP references by comparing a folio's
>actual refcount with its expected refcount. As spelled out by
>folio_expected_ref_count(), obtaining the expected refcount when there
>can be concurrent folio (un)mapping is racy.
>
>So it is possible that a changing folio mapcount can race with our
>check for GUP references, and F_SEAL_WRITE might succeed even if there
>are some, allowing file contents to be modified after sealing.
>
>For folios with a reliable pincount, detect FOLL_PIN references using
>folio_maybe_dma_pinned() before falling back to the refcount comparison.
>For small folios without that, the 1024 pinning BIAS makes it very hard
>(although not impossible) to misguide the refcount comparison.
>
>This improves FOLL_PIN detection for folios with a pincount. Handling
>FOLL_GET and small folios requires a more fundamental change.
>
>Fortunately, most interfaces that allow for GUP'ing such pages use
>FOLL_PIN, in particular interfaces using FOLL_LONGTERM. However, we
>still have some FOLL_GET leftovers ...
>
>Fixes: 05f65b5c7090 ("shm: wait for pins to be released when sealing")
>Cc: stable@vger.kernel.org
>Cc: Chris Mason <mason@kernel.org>
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

