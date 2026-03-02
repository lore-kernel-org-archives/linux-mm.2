Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F83AEB3626
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 17:42:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C4EA6B0088; Mon,  2 Mar 2026 12:42:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76B9F6B008A; Mon,  2 Mar 2026 12:42:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68E946B0092; Mon,  2 Mar 2026 12:42:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5BAF06B0088
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:42:07 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 23F4BC1338
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:42:07 +0000 (UTC)
X-FDA: 84501841494.20.EA232E8
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id 80474140007
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:42:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=a42+4d0j;
	spf=none (imf26.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772473325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OyqRQXmyeow1Ax++bz4eoQlAeCJ22rHQ0OvcJyCtics=;
	b=uQY9YMQjTq4ssCw6DFMWDCjK8G6Ymvd4GzV3MtaEoFvKWMtlwPJADQgOcasL+fDKjVBNJA
	5RX17U5kANk5usQNBQU+2PQbe3Hl6gWcNm0oKahxOjr1mG74aYp6vXDmBIKq3K4Ti3TGVK
	3w0F7NEStGOoq26CmCdu0C6RyX8qPFE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=a42+4d0j;
	spf=none (imf26.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772473325; a=rsa-sha256;
	cv=none;
	b=sakfMxUZL0HqCr+XY96c+zV7nsVVxee/Sst+Pu6QTulfIcJfUR03dcLvQX9rhgoGNoroMt
	gOUWcwf2CR2t++zJeFkFpR6SLgmcRkSNxnT+h5WvUD2lQQj2t9fTCPF4aRD/sIo+VgOrng
	IqBjvZA7KFUBPHQkoc8aVDa3ETtUhd0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=OyqRQXmyeow1Ax++bz4eoQlAeCJ22rHQ0OvcJyCtics=; b=a42+4d0jt2MGw+3tvzq6tHZF9T
	KMVGjuKfsUnQbOELMM8O7tKpX9KBPlfUPTJTu5V9RAI1l/1ZUi/OwbSggoyl1msDUmSN+CgfvGYAT
	+XBBExPqckdHeflS1QgVJoyN4innxdporThqLlqay7HSrM72w1UZgjFWZkrOAOdBcxSSyrkwfVSYW
	3Vcsu1BOyOY8g+Uo15LEkC9q9olDZ5UZjXlrCIvHZ8CxBdOGplt1jyp+dNQYrwJ7/LU5baVnDRjjF
	rJPu9vPm3ZIiPQ+ry7lEUYvA4epsMoRgF4rZuvfrNsFUKG0zWz11bT7R+rjb8goRalNtcgaRAkqHX
	Bnexi7lw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vx7HP-00000009qlL-0cKj;
	Mon, 02 Mar 2026 17:42:03 +0000
Date: Mon, 2 Mar 2026 17:42:02 +0000
From: Matthew Wilcox <willy@infradead.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Chris Down <chris@chrisdown.name>,
	Andrew Morton <akpm@linux-foundation.org>, kernel-team@fb.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 2/3] mm/huge_memory: Prevent huge zeropage refcount
 corruption in PMD move
Message-ID: <aaXL6oJamjnfhh5d@casper.infradead.org>
References: <aaBVz7eb6-VBCvaz@chrisdown.name>
 <6147cf80-9d02-4c5c-ab81-8cb9b00044f0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6147cf80-9d02-4c5c-ab81-8cb9b00044f0@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 80474140007
X-Rspamd-Server: rspam08
X-Stat-Signature: c9oux8qtnp8okakt8kuowjm1mau6c6mm
X-HE-Tag: 1772473325-951938
X-HE-Meta: U2FsdGVkX18rJwGlTfmyG/zRWxYbWdSj39VPJBlpR2fsvXo711+C8zNyHSeVkI3lqEjDzZbdhmw/2MJVYZPPxKwqhuO9cprsmb+qk1XDWbUOu3PWq157RJeMOcLt+S58TnRUMv9UJeyKYPd4vJcTiscvJ0mAnXlKxuxJ2FlUWneAsNRubfC7O+f9RwV8AUjZokdTyOrak9UKNPwP20qsi3PsietHSSC8ux+NdhHa45BoB/WEWYLm7OZBifnn/RA/l+3qhg8AIiSgJmKH4l3Ekyktyur7zEWz3PdogbMJ5DA6KmAKkRkqKsNGaT2Gm/plkAy3kTvIldEFRafMrWHCVYiAd54VZVuBXmrj6BbgQ/qcFaSuWxiSl07xHwkT0xZjvd+syPDTj0mUz7CDpPTrkax0WrR1ICyXLHZegQ+SDub5gvKK6p8ydqdyhGQFlD3vEG4+AjgRPNW9CUiPLq8iMvJnECcyejO0NDLNM6hH5B4X+8TtTkoA06xEsiyOEDDYCofLmBrVnSb8lMyeocw+x/fiqnaOzApBDZHZYQFcpJ9sPxVVVbg93H6lu39+kGRknZ2TjrOCRnIhOchfbV16M5H2E4Q/eG1BuoZeze1xdCZMA0mgLQyImFs3mEk+Jv0W4BqgpFd5U15O/5mBoND6jf9Ww0GNmxSMqnVMMm1WkBpja/He53xS9gJWq2GjSLgUChrMLCI9Egj/Wq1PpQm093T+gP5UA7371aDL/T0ZDw8QgB5R3D7J/ce2Mr1zT4Sbd1L5E2+9OQYwc/Hxsm/dYuJF9P2AZa7bmlgHtY7mxlySxxMovgNresfIvT50Q8kaQI2C1p95pChNZqcvBk/XVaOIm3lXMeXw4CQJvRX4Cp1pVTRq7LEy95lksu1lBkEhv7YiMCgJT0j95BCTg7aH/qfO0dFfo4gtN+JJUvZY3S2HWNYvR+C5Jjsuq3xIKlTRhA7Jl8ig6Fnl9yRyRQp
 tPvO8zYP
 ZeNDGaqzhz8pE37CfJcyp5v24L7kllVi/8Sss5fEly9DkSkli1pMbEo+wj2EKf8lspxtzlEMuWGFntpCb1lCHZGi9DkrdLdTmcwaIwNiAwOc2X0StIaXv6r8lK12LfTtQVZIaygwLaFTx7rmAyqPqX3L+mSDv/2ZA3s0DafIZIsve34mcSUYTgO3EpbyVKpErP98dNLhTHZzw95eM1PqB1Xw2XwGiWZ/uHXUFDLlzS4clMZZDCUNwzlqehSXy2JPFOCo4NMg0mEBuGdOJM3PJ7bWCtEtkIdcKyNmg7QZltl+zRmM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 04:17:31PM +0100, David Hildenbrand (Arm) wrote:
> It doesn't make sense to leave something partially fixed in #1. It's
> been completely broken from the start. folio_mk_pmd() should never have
> been used.

... mk_huge_pmd() should never have been used ;-)

