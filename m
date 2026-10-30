Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1666D606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 19:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=Ruc6vxep
Received: by kanga.kvack.org (Postfix)
	id C7D166B05B2; Fri, 30 Oct 2026 15:11:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2E8E6B05B3; Fri, 30 Oct 2026 15:11:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1DD46B05B4; Fri, 30 Oct 2026 15:11:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8ADB06B05B2
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 15:11:18 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1A4ED1C4194
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 19:11:18 +0000 (UTC)
X-FDA: 85380235836.10.14CB4CF
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf17.hostedemail.com (Postfix) with ESMTP id B952F40006
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 19:11:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Ruc6vxep;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf17.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793387476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=19Ak8N7iaTdP1KRs11X/V7bN5o/EP6FFYiTibflRDNY=;
	b=DJ5zxmcV4qpuf0fbKGDmmRXtAaFwHrUgo//rC2kpF7m7QEx+PuAp293eX2MM0mboVZNqTl
	bgt9cVpew4mEOOaFQcCv1dzehT1BcC2zcwN/80blvtUVijI2HDaIWnbeWelzKNpYpJyhFH
	IJxFaNFKOAn5VUDbZLK4uw8PZVdbHeE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Ruc6vxep;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf17.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793387476;
	b=IHrZxkiU/1VjeGXgLOWNGpeSjR110/fEpBQpghFrqFx7DOyYjsFvzduCeE1D3hnLQbz1oz
	iA3ASMP6MxMlUveFA7BeU7yx+UMu3oZoRXdZj8ZOM0wFQsutYlKPaiOXOmPGIzZnogzHWd
	K8KnfavjJSFxCTPIhyzhKAZc4jyxG6w=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=19Ak8N7iaTdP1KRs11X/V7bN5o/EP6FFYiTibflRDNY=; b=Ruc6vxepI0BvkM9nTI1PMx6lZm
	EzQJ5W1MMjkIG9wl8uxR6Th2S+A7dJz5IpyMMZs5KQZcY7TdPCURl6Gfq3ziVCZ5kv1DFFwjb0Hwg
	rFkFdZqHj/RhRXcq8lpfu+cHuqlXaA/jE1LV4vDJIcB9oajzT3GMSJrB0nMB64OpMfLZQ26n0xK3f
	sWN0JQrmDwjUnx2+gJnIA1SMHmIE46r+aHxfwjFg8+MAlbAbu6elrzRyHm8wKmQcmpO6k/1nztfL/
	fzWrgD9Q5QzQwWwse7xx4cJ+ckGn9+7mE3x8LMCGlu8Sn0/9ZBpcrbvyWTQcqm63WlodJExydZqLd
	QXTHm8PQ==;
Received: from willy by casper.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xMs0M-0000000AIZp-2cp6;
	Fri, 30 Oct 2026 19:11:10 +0000
Date: Fri, 30 Oct 2026 19:11:10 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"Liam R. Howlett (Google)" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>, Baoquan He <bhe@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Graf <tgraf@suug.ch>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
	Lorenzo Stoakes <ljs@kernel.org>, Chris Mason <mason@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>, stable@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [PATCH 4/4] rhashtable: fix vmalloc() deadlock in atomic rehash
Message-ID: <auTrzlSFCWNJYisW@casper.infradead.org>
References: <20261028154218.1668182-1-liam@infradead.org>
 <20261028154218.1668182-5-liam@infradead.org>
 <auKshDXKQXt1kvjy@gondor.apana.org.au>
 <auMbCuecFeRmBFSK@pc636>
 <jfvq7vkx73vzp2ukq6nwnb3v3g2ezdcyppba4oa5lpzmz6ls6t@akc46gonndgy>
 <auQhkHG6XlgNTdRr@gondor.apana.org.au>
 <auRo5WBj2OlKlWGW@pc636>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auRo5WBj2OlKlWGW@pc636>
X-Rspamd-Queue-Id: B952F40006
X-Stat-Signature: rfqzymkk86emm94qsm5t5b3i7eezaw9k
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793387475-554210
X-HE-Meta: U2FsdGVkX18ZWsPUufCDalGsbcI2YgMmffoJyX3uCVK3N11xBPFtlcKsQtthWSTjdNP9QNhpcfhRCZsK4cGTyEuR4Cy4KD+XD5pEJz+DsiQp8Q65Eqt91tkoIkUYpMNAqGu0heTvvHhPvCdZzzx9bcJvMYANBMMM5MMYtUZ7mxsXSsszxeHw3po5mImbUHVGcAfAnZOK8+52MYlrqVyUVnBtg/zNtBAwKbRZ09xCgt+GeBl13sVPeokkScfb3fzr0QN+QRjLHbOegE5onwl+M661co5Zl6q0uhFLtkJAI3UL3R/FCbsgeVSg75eYdJ6UpIsAoYkRKUaPRM3TVRHkLOrIlZd7zQ1bLqTPnNDRhc8s28OIOOSWjf4jorpXofFWmRn7UyIqMayBqP8L9EicFPAblbJl5ShpwNwekXwBw6lDS0eurJLeWrups6JndrVJr5xM1cM2+kSmSwB0xCuY2thWfTukRW7s7DrWGQUUAFLXv/y2MSm4rGYekzdrafmSfNs2em7UcCmYqSuNE6Qni1fwX5LB3OMKQJRgNPVnBBVur2xD/qP2qgEXR3kNm7n/Z9tKiSet0EGatr5TpxpIb0AzspboUQCmjSwgcAk1dZ2dX6+LbRQxRYOVpprSaVEyiNUgkobmTzQPUhxRKXW2F2irqWFtuXjn1TEW3kxC7P9SilMDF0qk6VG9CuK60sbGfr2Z3AoxQeeZNjOK1u6Ia8hR8qX8DM9fOk/A+j0S37pt9HsV+Ze4tBfanZvZZnxELM5hSqK8x5srGYHlnxe9jR0gSSC9lGq1yl7Nu52E2Pn2qpzxTxB9BPI/CPP7tKsZciRjlWZEXfDdr8CYNMyhiJdM1176n5bwHKEei8jj/5QeFBRpHJopN+/fLCAqciuZ+DK7J5Heqlvb4a7QX8NXtKMSYYiJSQ5fDzC/qsYtEHeDssXLn45SAI2oSyZUWEPD15dP03a9QnOJq0XOWUM
 ++WdCybZ
 YDa3qz5sVCYS7iVBPw3MysuifFmcvXVOQjKV5CKcc+W7DFUO281mXkbjbPHdfJRLYlmC1TwtweEzPYLlgA6J9wcHjdPCWWaBbwD8US4tU1wZLBrPFGC4u4Fa0a2ur1OU34rv1aoviOMeSi9aYEal9sg6r7WOsLjIlkOd5cAxzmvczwhymtH8TfJgssUiuR7+1dQfEQ2bTs6IWbZkXxV6M15oV8rhOsZTy+6o8tT0ZJhnMo8TY267PoE5fY4pPVe+3go5+8atFgFT12j0vXk0c6oOxeWrNLiq4OpHKRWWmnJZY+FR2lgbzoTX56KfXeP7XOzdK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 10:52:37AM +0100, Uladzislau Rezki wrote:
> The problem with spin_lock_irqsave() is that vmalloc() path can take
> time to alloc and map pages. I am not sure this is worth to switch to
> irq-save locking primitive. So this is the "heaviest" allocator in the
> kernel. Callers have to be careful how the call vmalloc().
> 
> IMO, this caller has to be fixed.

Which caller, though?  Are you saying rhashtable_insert_rehash()
needs to call kmalloc() instead of kvmalloc()?

