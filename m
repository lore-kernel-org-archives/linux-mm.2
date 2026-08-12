Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2FFAC5AC67
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 00:17:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B59606B0088; Tue, 11 Aug 2026 20:17:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0B2D6B008A; Tue, 11 Aug 2026 20:17:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F9D36B0092; Tue, 11 Aug 2026 20:17:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7B9CB6B0088
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 20:17:52 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0B703402CD
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 00:17:52 +0000 (UTC)
X-FDA: 85090704384.07.3A3749E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 67A69140009
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 00:17:50 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eM0nOym2;
	spf=pass (imf23.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786493870;
	b=D1UubHQQcUwU70dmTMiFsyTReohrcqqY2YTSrjhA8bz9dccUwnIYwUfiJ93t48mV21oCNA
	bDT/HT2o6TBvngmBg/dYtXCsEyiL1CgBLQYgAVrJ8+oY5/RuA0T4aLYHndYUK5VHdMn87v
	91j8Qsnp08AHa0nYKNouaUk7Voi0Fnw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eM0nOym2;
	spf=pass (imf23.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786493870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=glKqfK+8vzTCcTVl+aipxjInjbAI8DgcIFu3nly0kUY=;
	b=e4Ad/Fe9uZlvWz2jSM8xivv+AjggdHGZSlNWU/wu/i6DY1rP3OimWJOwXNy2xzjhbZunsU
	SAxpe6m/JfSV/W5XeBc5VQxJb17f0w4vM2ZKFkOVCt622NblsvxLrNIrZuoze8/3rrQEX/
	vZSiGS8nZ775NnbJBOMGBwqZ1sB2m0k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CF8214304A;
	Wed, 12 Aug 2026 00:17:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B11791F00A3A;
	Wed, 12 Aug 2026 00:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786493868;
	bh=glKqfK+8vzTCcTVl+aipxjInjbAI8DgcIFu3nly0kUY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eM0nOym2AGLDqOZx4l707CB6YZfsavdmW4jozp1YGS6OTk9ElQ+5pMP3jZdH25VN9
	 h4SilSashnxag0aWqDrMETcxkHsUhK83w6jubzXHtiBquUKc1XowcYtE8Czk4Q5wVS
	 l3kGCRBF1DcRfad+neGD/cpPRDKdVAS/9nt7dW+ehAWVzu4kwOKQImVGZJCrQDK5Ku
	 +nL3kbap8HBJQU4gyrOb2p7sYQTnIwpC0PbaaWdaVQX6yzD/K0wdSjGZYPgtUO/OF5
	 hFKTAK5J1NYf9lBnglBI7NU1+yyeA8u3+9J0j2QRj/vLC3OnVFm+YYSD1GWnd5apMW
	 Jg9jUpLStmBmA==
Date: Tue, 11 Aug 2026 17:17:48 -0700
From: Kees Cook <kees@kernel.org>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-hardening@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH v2 2/3] slab: check for ZERO_SIZE_PTR by exact match
Message-ID: <202608111716.0FA9DB17@keescook>
References: <20260811141240.62519-1-kmehltretter@gmail.com>
 <20260811141240.62519-3-kmehltretter@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811141240.62519-3-kmehltretter@gmail.com>
X-Rspamd-Queue-Id: 67A69140009
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: d95479dwz4yt4mhnjmxb3757pkp9mycs
X-HE-Tag: 1786493870-404757
X-HE-Meta: U2FsdGVkX1/aA/7YbTElZNmGOspWjOBH2QkZekqyf0SODOQJ00AWWCrT+NdX5NPl4cKvAgLMLnKGXcY3x7zzzvLkPwxfuBiTYmzWwzaGFd2FYXBqRpit9+Yl4cJzj2STMqnQxLaAAv2APuCpE9N5Ac2HLwd9Dm3TmDfxmM0ZsL78PuIIlNvkSVB6WvYfmurFtLkeTodOUOysZe4V1uqUE3R12fHKCUKviDrsAPH0lKx8SiVFmOYQGOb4AoO8/tK1iDCG7eREMe0UcKrKitC+iPCsjplnG/pyUOQMCi1KxkUSsrkwkjeD8GS7K6ZDpIn+UuChxCtLiiCRiHkd3k+4YL1YLm2MMuqYuVKeHNnVWP+oQordmNLCsUvHbxTIBK9tyL8y+/2ZQ0qyivDR+ZCbcUINYe0+NYPp2mi0jaNSCaaGv6iSTkk8uDlcKPHT2PxT7nMhG9HiGdAs73zui0wyhAXeGjTI2gijYHH0sk1zcZHY8+hHMCbT8GzXgnYhWKbsQOlcvorqj/21ufvqUSWd6DV1mk/fKG3QYHEag+vGpZ4zcXq6tP3fI3IwemJ/dszDjHfeMgbjkuUTpZ1DeXMttH626VqY0EP47iSCCNfIoPtuGjMT+PSA8tOkyMLF9eD+QrEgpbPUqXRA67qMvPwBQ72SUGc/fp36FkmAbL9uYVCDWtwk8WnhtgFVzdZGlYJNIsbSLggFDqNQGFRwb+C8wwakZA+tncP/HuL8Pj16RZcrCt34yqkfFG/woGIr+XXM8UK3CPOKopEQG554KSVrLCBafG1zDInEdd3sn8XMwdWAZQ7yc4xAucOFUKlqpq707bko698aC6afDBoIVwn9OMRUuU63xRkUrnteII+Z3Zr28rkHu+ynIPaNcgUQr+AjacE95I54h4YLZ5AjksIFXsy4iJbXkxSE+M5STl7UODkCbyt59JixKuHdwrPEI4TA1mZimZ5qGg8D4Y6pKmX
 beU6GnoK
 8HVFlBOuGmSymyJL6nZqVlK+Ma2U4ynyV7O0pQTqldzkC0c4OVZeD1gzKfF2KLClLq+se9IxZv9Q1dpfXkHNndGUylzeqWXJNeEG/205XaW9fStqt/q1bX85SYDrdeLGDM2YAiccGNqyQ6JR8R5Yf37VucKxTGu6+lA4ms8hDbHdo/ViRlw7awaDICvOO3I4OjgeZnDcnCHLRghvMLfBgTGCThem9e4i5J/1VAGfTFYRTI6JiEpp2j/+8U3k/YRVFUhmCtmjqJ4WVeaBbs+ng5Zg+Ew03qG9SpooO1m1zL3fWFahhYi0/yVdUi1TaCR33M0nB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 04:12:39PM +0200, Karl Mehltretter wrote:
> ZERO_OR_NULL_PTR() returns true for every value less than or equal to
> ZERO_SIZE_PTR. With the sentinel raised to ARCH_KMALLOC_MINALIGN, up
> to 128 on some architectures, the helper matches additional values
> that are neither NULL nor the sentinel.
> 
> Compare explicitly against NULL and ZERO_SIZE_PTR. Store the argument
> in an unsigned long temporary to support both pointer and integer
> address arguments while evaluating it only once.

Can we move ZERO_SIZE_PTR to cover the ERR_PTR range too? See this issue:
https://github.com/KSPP/linux/issues/93

> This also changes check_bogus_address() in hardened usercopy: nonzero
> addresses below ZERO_SIZE_PTR no longer cause its null-address abort.

And then check_bogus_address would also catch ERR_PTR.

-Kees

-- 
Kees Cook

