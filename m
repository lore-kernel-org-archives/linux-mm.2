Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF04CC79F82
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 23:59:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81A7E6B0088; Fri,  4 Sep 2026 19:59:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A4886B008A; Fri,  4 Sep 2026 19:59:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66B746B008C; Fri,  4 Sep 2026 19:59:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 45AAF6B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 19:59:26 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CC0D01C18CA
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 23:59:25 +0000 (UTC)
X-FDA: 85177749090.11.34CB2D9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 374B040003
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 23:59:24 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TO2wh+yi;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788566364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q6CYCkPfdGnTvONd8HyYxDOWKWY6Ru41NtJnnGeiMOg=;
	b=Bhmfge6UsZVQwUgDC+PHxfUBtdEQkjusTMDdOjq91CGYLmQQfrgBv8ICzKKWSRUH5oCQLJ
	gaYoz92iP2VFrGPRi0HuehILULp8go6H7vwybvzCGQ7wELPHZHVsKWxt0kM1FFKIpzYQSa
	IXfWK5Tb0vL3zCnEYjIFJjGtsDwk2nY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788566364;
	b=6TP0fwHnVr4Ys4VSLesaN4C/rR2iMF1Z7bo41YL+pUVxwYO/XEZDTj3YVAIszKmuVnQnMc
	DROE8/+JG7+w8NCYQl5Rl7QptqENekTke7T++DSSzTsZD1I6XFIkpg6lw3XSR2jYHk8ThP
	kVhYdSej39aUrirzn50O2+DUs+HqL5Q=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TO2wh+yi;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 81F25600E2;
	Fri,  4 Sep 2026 23:59:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCFEB1F00A3D;
	Fri,  4 Sep 2026 23:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788566363;
	bh=q6CYCkPfdGnTvONd8HyYxDOWKWY6Ru41NtJnnGeiMOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TO2wh+yiKuCY1xzOsag6p5uyZOXkGCKAu9zZFjNh15nMGEvsNeP3JUEKP/3W6gy4g
	 WbwV4TwI9PmwEOMxdK1pUyUclBKMjDYdCkbwfZPK+g7Mjk/SPZCKrCzozGJzrPSp0n
	 5bv8HIAON+IMF62uJcQs+DduMLKa6eaNblScfGB/m50OIaNQGqCJ6XrKD9sUPZ9/3Y
	 Mh2J/WDXU7wQzlDDTU8ydWzWZ/3yb1jHO2u+4ILT+G4ObOjIq0e/Iq83JxXY5o39KW
	 r9afyp+V+wiGXbaD0D3k1ylmzO1hUcXV5jqLlW0/m5JA1OXOzbSXrS7qOJQT17lHju
	 uv+gfGJJnXxmA==
From: SJ Park <sj@kernel.org>
To: Hemanth Selam <hemanth.selam@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Arnd Bergmann <arnd@arndb.de>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/5] asm-generic: fix typo "explicity" in comment
Date: Fri,  4 Sep 2026 16:59:15 -0700
Message-ID: <20260904235916.67459-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260904104854.25272-2-hemanth.selam@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 374B040003
X-Stat-Signature: or1ajp4c8bugx73776xs6zofbs37xjfh
X-HE-Tag: 1788566364-305960
X-HE-Meta: U2FsdGVkX19uifXZSv/wrB3CFP3SQKu0w7sYHHel3Lh716gkOwQji4nHz9rBn5eflFjkYHwntYSvvBiKpQ1DzI886X5/P3WVLKBAScDqUSIt+jrJVHLkkBLekkyvxyABcCFofxbx4kHHD5w+1ejVA/jP9wHNBxNs4lSHuFW8lbjmjhq2oESe6Y/f6EtgL1ia+kUewQOxNYNq1KDgOz+193d/jkBtClA3HZIfzIVGc8FEGbF2EM+m7L9T2CZhpKqml8NB80adUXC2NygAPCHKvoqlS/6n1AmJakiYeh8sqx0CPuetIT00rqolSTdlyVdWstF+tZ0jYPJWq/X8GJ4Z8PjKxHFNA6M6Bcgs0HFStPkwbLtuH/Ky3di5WqZRdATI6qK+liXqO9tRF+GUOEIpv7Vs6NXRRRpEB3NUNZwEYop6AgeDfIhDrZBSJI4Gz3dDk3JhUp9hEyhrtJ16X0cLl68NJknHKLDi37StNsZANnGH1aXfBGo5DBkosa/AkyLFZmopASIzk+a2TxBp4CnPJyzmxj35fAcDbhjpA7QymaRhzTvAfb9Byv0ylewvy+n7K09soaKLMMZ6qkItEF+oxTX8mLwevAn+IcJE8nTp2getDgFy1vZ5BaEblMPk3RE9Xy+lfUfkZAABfPJvCmvHUA1nLYwPiqeSjF4SqIZKNogg2uBO0WOCm/O7Y3hV8FsFtXof6TldhG8PtfSLrbGRyGQC6OEglipmj9aBgBIbMI87dIkpx6NNvan9rfZAulXBG2fBgjkNEHyAeeo1de489pKGqzz7xKSTdd2Pa4rqF+Mkk4gZ/KQnfVMfS2mtmszpIPM9lMdSVf7eITbCW4iE0/gRLa+ncsJNF/AXfrQjghhX0YBzjy8TYLR0KyPlzjM/odu3Imnki4m1jvZ/cEBbDKgxNa791kRu1pcG9wmH9sfh1BI4TL+9rW6BleksuQp/BYzhXz1Px2QnGu4PDUA
 JWO80ZZ5
 N1yPwzxR3kd8dXsGb2GghVOmJRZ2M4m8rxNn9kvtX2XQzEObiWajLTGyeEllKtDKZOPN06b6PTI+9oQvuz0DDyjKLdqLJkyK0YibrwotMDulYhqsi42aJIbGjzmHqLBmNSGe0BXjz4YjBwUQPOUApzI+s5MNMriVV7MutkFVyUz+IxAd+qOMfuxEEKdbLgtsmhLETIBcw05UGEA4BrjOg/i9+wqW1TI4nOsBdbMIE2wqbB0/kH4bJP2oNi72bhA4N1MPEifoqzhc6BfOn8UAiVOefJEOJYaIfr4a2F2l8qtaX/c5C3EyfcMsJftg7hjUSxdIoBhrfik60KOg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  4 Sep 2026 16:18:46 +0530 Hemanth Selam <hemanth.selam@gmail.com> wrote:

> Correct "explicity" to "Explicitly", reported by scripts/checkpatch.pl

Too trivial, but 's/explicity/Explicity/'

> using the misspelling list in scripts/spelling.txt.

Again, too trivial, but I think mentioning spelling.txt is not necessary.  LLMs
might disagree.

> Only touches comments,
> no code changes.

Anyway good catch, and looks correct to me.  Thank you for fixing this.

> 
> Assisted-by: Cursor:claude-opus-5
> Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

