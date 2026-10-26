Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DE8D606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 13:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=b95hf2oO
Received: by kanga.kvack.org (Postfix)
	id 5B77F6B05B6; Mon, 26 Oct 2026 09:34:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58DE26B05B8; Mon, 26 Oct 2026 09:34:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D0B06B05B6; Mon, 26 Oct 2026 09:34:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 287DA6B05B6
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:34:59 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 922ABC073C
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:34:58 +0000 (UTC)
X-FDA: 85364873076.01.A793DDA
Received: from mta1.migadu.com (out-194.mta1.migadu.com [95.215.58.194])
	by imf13.hostedemail.com (Postfix) with ESMTP id 766B52000A
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:34:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=b95hf2oO;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.194 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793021696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xR/zt8Fn8bNjdz5e+SUp/73xZBn1BSzckF/z3HA7yx8=;
	b=DZi6TnSDfit4tAD9Y+mUkH5Lw3vKJJbVrdTCNx6VuEfLVUZSv1D222YKKfSn8yxt7u3YKS
	ywWOy3a/aN9NV80EGMZwWh3B9NeRmTW172OEWMESByAkKr6hLo9Cyi/wYnXPVOPCFjpsWf
	ub4QOLSQBo5qlMAY7NDnoK4GleriDVI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=b95hf2oO;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.194 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793021696;
	b=PuMjJBeJGaCd2bOfh2RPbI4z/j+ti/kmpyqpjwWXJHBCXnSlOuofGVuwc4k5z0HvP7VIXS
	CQ4bwUdjCXxnN/ZvpM0dHtPZhpWRzeaXwtfIy38mJLfUNIoZr9reVF7NaYijcZf8G1hQrY
	9dUhwGAiY6lEfKmcsjoSpzj2a7zaGb8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=B/1QP7GemvzA006XUysBM5X7M8mQ9nDSapjnqLDANwE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793021694; v=1; x=1793626494;
 b=b95hf2oOKU3J1aOvxO5GQ7XBgIFmgP9n5y+cmMnRrCwI8qDXSrZTMZyd9fP76lZ8DHd/AZqi
 43xt5cBBI1i5NXZZr0oYDbRfY3lfGbGgjSwixxGldISGM3qUwd4+TX9f6sBOzlBNaC/xAX7nzyd
 wYb/BfT6laPrUKnolY8jJZ2U=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id c0df3f82cb5f4210;
	Mon, 26 Oct 2026 13:34:54 +0000
X-Mizu-Trace-ID: c0df3f82cb5f4210
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v2] docs: hugetlbpage.rst: clarify HugePages_Total in
 hugetlbpage.rst
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261026080856.76175-1-lienze@kylinos.cn>
Date: Mon, 26 Oct 2026 21:34:30 +0800
Cc: osalvador@suse.de,
 david@kernel.org,
 akpm@linux-foundation.org,
 corbet@lwn.net,
 danielmaraboo@gmail.com,
 linux-mm@kvack.org,
 linux-doc@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <7B4E34FA-A8B1-41F4-AB0E-681659F38760@linux.dev>
References: <20261026080856.76175-1-lienze@kylinos.cn>
To: Enze Li <lienze@kylinos.cn>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Queue-Id: 766B52000A
X-Stat-Signature: zx46zkn49pj9ctydei7g1ichunq9smds
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793021696-968651
X-HE-Meta: U2FsdGVkX1/FaH7yf8KbRFqrdAvALRF3ecixk5OE3i+K6WjaCwyF4jLrs4WQ8qcf3YfO5wVLXA0DDF8C0LIm+hAnq3ss/lPBn0opEmeGhZF3pC3Dsjy4INQ5zpBDCBs+ELzzScZb7f3ERTaToi9Pg+OTmzwXnoXZJAVzE9jc+9Jy6e+kbISlLn2UmCkUviLocY7fswHIXIzrPXzZ/JuPnIvR57S3O4BW8SXMRH1+ycAqEeGMswgNB4ASN6LIHsCZZpF6BxAyKPAftbdHdc7z0UrOzLJ14+W0tvBpLhVl4+03Rgt4m2GlRQJMtt3lCcDRLWYIvZXUmGIM4B8uWkZllkei4ae8ms2+VN5Dy30kIOEZkwft6Kbb6KYExbq5YEGC7dG7oJvjFXrGtb7NbFaAVC7yGKOtgv5WqOSS/3Oeie+B3iNtyQUjHePGnlTh69V7EKBHF2DvEmxmKii60My03I//spoDGAruyVvTWPoe0BYNEZCoW40fJ1HCPZLhuo6H91TRxtFwQSK7eSlrWzsmVMU10lqSNSC1TSmC1Rj0/paqU2BMZVwTXsQCDDw7jBg7DM5FzYl/yCv6TW7raACISrnJjptZWAjOjjQRjqIQYRo3N2eSMDlk87V/dKWjsqclM6jyT1wDZB8QBG3KKXXdBFhYekY4uX5AMINUk2SRqDxsbfA7SBd6YcAi5zySAanEtP6fwd3NL/n8zPbHMf6LbiaH01GvUjeeYakyAOJhF+MMDlXv6SnOFPH9I1oNlSjbTMzQi6V5g31gzIwO4HKf2Io62Q/xEvX36gef0u0UtF+SkbPVdFXL64y+2VMc3dFhfvjwhkcznmIEJxkSxKzLuO8ULqbFOyCxLSUOHZ7LpPp0BIMovCtlZ9uXRHyQYykOm8Ml7C3TRkto3cH6BIvpfsAlHgP2grL2DugY+dD9rdEF0mjfn5EC5Vuq83I7JRv6yV/gaPEIxIvOnum/6tx
 v3CYJbX8
 A5KF3hQvxLIz00VwtajGLOgLqfW7G3n1xRCnawT84yu72qH3CrOs8KLCUaT8kyiszF/IfsASPkmI6oMwZ8DX9wM+mus48o4rOOnBbhkKxMm2Fr4QjcmNOn7kI4DCQsntXAd29nSEYhCpqzOSKyR2wd0oLwZvbmV3rfRg6HVRmFcs5flF2ZJKeL47opXxflDjR18NaJ7eWpiea254UJvySY4z4vM3+RX74XLDn+howjpYh0h7KWxyKf7EOtGuviy7vRegL2ddrVMPD2HvRBIPlDumeVt+2XOaG/TiFd8LuFGsJEs5lPWwKJJEjIXkGhRs0CzejCiVd+CyAAFaWiul0NfcnsthSUZK7p31kxDVtZ2bcT2VCDEGWOikkWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 26, 2026, at 16:08, Enze Li <lienze@kylinos.cn> wrote:
> 
> "the size of the pool of huge pages" confused me, since it sounds like
> a size in bytes.  It's actually the number of huge pages of the default
> size in the pool, surplus pages included.  Reword it and point to
> /sys/kernel/mm/hugepages for the other huge page sizes.
> 
> Suggested-by: Daniel Pereira <danielmaraboo@gmail.com>
> Signed-off-by: Enze Li <lienze@kylinos.cn>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks


