Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB386CD3445
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 23:35:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 484B96B02B5; Fri,  8 May 2026 19:35:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4349F6B02B7; Fri,  8 May 2026 19:35:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34B5A6B02B8; Fri,  8 May 2026 19:35:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 254CF6B02B5
	for <linux-mm@kvack.org>; Fri,  8 May 2026 19:35:53 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B8106C1AB4
	for <linux-mm@kvack.org>; Fri,  8 May 2026 23:35:52 +0000 (UTC)
X-FDA: 84745862544.16.914DA72
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 10017C000E
	for <linux-mm@kvack.org>; Fri,  8 May 2026 23:35:50 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=EBtWCnR1;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778283351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1P7yAgLvH89rir0oBtVksaOV3OEDL/t6UQmNl2kgLcA=;
	b=kCyJAwqVOLNJGTZBAxtMLjUQGgeTZJAYslCFO5IfYXMHYTFnJB3m+qFqzBx0YUlifRqH1g
	HSBrPufVWwiIYorQ/CvegGZMiLT3EFHKawAPyEk91voHrzVGyFtPssInLgueo5zr5obJHs
	cDxpeQuXi3rnBtjtOMFBJVqHDo6vILI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778283351; a=rsa-sha256;
	cv=none;
	b=oRkoeaZb4EFLgZpEAxzDACMBszmK3C3YModjGA0CzQN29Nt3H+4orKeyqlUtilcCXHHxCz
	m3ExBrwEC6ePpzVi2t29jsox9dDWk9CEveXKFsn/py7j8pdwH3fQN1gdm1Qpg2IOjN73hK
	91S4hUxe9ZP6cbk62x0sjcbDJunG0X4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=EBtWCnR1;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 46B496024D;
	Fri,  8 May 2026 23:35:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93F0BC2BCB0;
	Fri,  8 May 2026 23:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778283350;
	bh=ljwGvxib9VGIEN21z9Bsr4IegW3/xiDgbiyxi/ymyd8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=EBtWCnR1As1p/wp7qA6DSxZix0cYkiP9lE+pbxOzKVZeFvhOhYbbWGGJ06yx0O3qP
	 lGb4HPAUl6RUjFpBAmLxzxXzqsUn+ecLqumevhIH+p+oCV8YCvrHq0Pz3grnHNk6Ze
	 caR8dDkpWWRqsfdNDTFzDbSISeWVRgjAVb9w9GAM=
Date: Fri, 8 May 2026 16:35:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: fujunjie <fujunjie1@qq.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, David Hildenbrand
 <david@kernel.org>, Jan Kara <jack@suse.cz>, Vlastimil Babka
 <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>, Lorenzo Stoakes
 <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/fadvise: avoid remote LRU drain for mapped folio
 failures
Message-Id: <20260508163549.40a7f3c8c4286a553855b02e@linux-foundation.org>
In-Reply-To: <tencent_DEDC345B4071ED3C9B293ACD437B9C8DBC0A@qq.com>
References: <tencent_DEDC345B4071ED3C9B293ACD437B9C8DBC0A@qq.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 10017C000E
X-Rspam-User: 
X-Stat-Signature: cbqjdfdo4bt481cmb9efcakw7466e49c
X-HE-Tag: 1778283350-245161
X-HE-Meta: U2FsdGVkX1847rn+47Xav/40QTZU9zPxzNkYkKxoLtQRwX9pephRHRZV77OMIXVBOQzP/Mnw14D0w6XHraXhm9Wmyd1sMPtBYPcrUdC2sOn7drK5CabMyYbvcrvLAwvjYpNR1+kf2cIn1AiNKjpvApXoDoKzC5Hj7lnMN0ngTxbL9MhoEFfGTAw5rxzb/Gq0ntllhivj2hVqM8wfyhMV3QesbC78J0KPZLk9TDLqn9V2ilCIvfBC3ft2IyZ027+4mlLVHM4pGUOZfWO3c2oal1eJsyT5Dd7ueo6V3RCinPdE4NaHyx3ZfLHQ5k/mOBqEQUxf8Cy9WCGiyxPCAzYjfRIbKOzZ2zQ719X3Ur08UE12C/JbnjaO27TK85w2xSBALq86mcvwuWdcTvgCIs6+6gXW42K53jbDnGCOeyNGNB6QORaLquibVB6X1Cetup0I2tnK0ogIesPRp32HMMfVwwTn9L4IYqq4pWUk0AtcDh4NZQsuOm8QZ0SqQAt9iExGBs+fK2jbgAumeeb8A7fbMdzBN+o4F8SaMWgJFHqypcULAgt6P+b+KSUeKi6xsnaVhzSbpfG0WxDL/PvV8HRLTmAYd90VQBR1ruYHbI8Lg8+0XPCehbSno7c/6FV2KEtM5paAuPLIupWhnfQejJAQ7Zn2chvbB2qCqgNGYKqTCRL74LpNuOZ2gZPggeo5e4rR1SypGGrGtoetigFqtz4rEsXUKMuNzlgHdH7KaLQthF+RYbYZUXBkNjM82z5ekMbO0Ldiy59KVEsnuUKs7mBcHh91vpLd6bkB0jQHN3JTEIsSlqX6Ujc3rv1K6RMVJUXro2WdiQzI//8J1updxyInAHoYmnodD1HOzqILEwEXgaXaCYcu03wcJUApGlFWcfXYBq9yyVuHxKvpgkyAx1rg2e86fBKQj3TBiUpcKGdz433LetqoxFSCTMEiXvl7p4duYwIIAcPiIcKms4D7mLV
 u1xm4AeT
 /h7LrITVDJKckXsFZrL3b+IrqCCbfTV9iQ+nmVz7IZDvwQyHWMbr7UZuxY3JCGJtgqewftWn907WhSyUQd9fdChXCFgRMu7RWm5XTID/D95AmHu0uw8V8zWUOjSlQgM69navU/GWzBHp9tj4oDQrw+G8iW+SxcM/NDkufBrKKLHgU1N0X13LRrTz9quggS+LmscfUeVQQwk+Gs1QceDzJeImpYP8QXoO5+nyWhF9fPfynkycl5zdSkT+kZD8YoHUi3ZJe24zg/1nLfjwGjNehe/zTdO5d1/FkriXEh9KZN8ldf+gnfGJFS6XdIvYbGdNQHhuGMo1xcUj+vIwwE++lNg3lgadxOK66+c0m7MI5e0imBqQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  6 May 2026 11:23:59 +0000 fujunjie <fujunjie1@qq.com> wrote:

> generic_fadvise(POSIX_FADV_DONTNEED) drains the local LRU batch and
> then tries to invalidate the requested page-cache range. If any folio
> could not be evicted, it assumes that a remote per-cpu LRU batch might
> be pinning the folio, calls lru_add_drain_all(), and walks the mapping
> again.
> 
> ...
> 
> Teach the folio eviction path to report whether a failure hit the
> existing refcount check on a clean, unmapped folio. Only request the
> global drain for that case. This preserves the existing fallback for
> failures that a remote LRU drain can plausibly fix, while avoiding it
> for failure reasons that a remote drain is not expected to resolve.
> 

Thanks.  AI reviw asked one question:
	https://sashiko.dev/#/patchset/tencent_DEDC345B4071ED3C9B293ACD437B9C8DBC0A@qq.com

