Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEC50E9B269
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 14:03:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1622B6B0089; Tue, 24 Feb 2026 09:03:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E6166B008A; Tue, 24 Feb 2026 09:03:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F27116B008C; Tue, 24 Feb 2026 09:03:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DB2B86B0089
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 09:03:20 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9454C1BFF6
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 14:03:20 +0000 (UTC)
X-FDA: 84479517360.03.6EF9B26
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3166A80008
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 14:03:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=mvBU86ky;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf30.hostedemail.com: domain of BATV+12cee3dda5acdc8daf7e+8220+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+12cee3dda5acdc8daf7e+8220+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771941799; a=rsa-sha256;
	cv=none;
	b=iq3scGcwY5F3XClJ1ypzNPscDTaOeuoH5tybUnXyERAHndT/ER0arKE1dFnQxh5S6Hvuc3
	v1RRERzRXEnRir2N/5Mp1dgzhka/t5IEJxLi3G53QyIyG4E+gArgs1JFt9J6Fwn6tN2Kyp
	rbY0z1QWXesNfbjdkcTnDUXnll+ygJU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=mvBU86ky;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf30.hostedemail.com: domain of BATV+12cee3dda5acdc8daf7e+8220+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+12cee3dda5acdc8daf7e+8220+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771941799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XgaqhpWFYGvROue4gL/TfoePBW3Q9dTD+bwqL6WL7RM=;
	b=fVIksqUMAb6pDPlf30rc/PjHVkZO59AUlUt8JJcNgsEyN3I8D/jlgi5mHjjKpzZdOeI0lf
	AWrQhmktjqV5ehF4JinBLuXXRxaK7WcU7dw8KTJP2O7Q/FqMELRhIpu46/hM+7Dzo7hBuo
	Gkj5p6tMaHIzWT6QAxSjKeG5h41vNqY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XgaqhpWFYGvROue4gL/TfoePBW3Q9dTD+bwqL6WL7RM=; b=mvBU86ky7lcd6I5HRE6fGvlYXJ
	uwBfVXfU5HIZuac/qboBp11jZkMJwtoEOsB5UP/9IC7UeHSvym5KoL7DGmOoZZhtSOSSoFbfc/UOc
	ToSEnISXcBFvarBZCGLFzZU07L0IqUOqIVTsB3DSwui1xXhb7yTEbpt0SfC+5Cv1DiQb/LZelx8W2
	/uJGEl4W5I/CXwx/E5qUcSpKUEBBHsyB7NZZyoHOJKjCNrEgGlFnxitvXO4EDty5jBl6MXKtLlJJ8
	o74PfH29QMfgyEc79fLI4lcPCOlYkCVqg3lkXNJ8D9hHD1Mfonx/i+Sm9gxfKQibqMpT8juPeGEOT
	G+fLUUIA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vut0L-00000002AsL-3V9s;
	Tue, 24 Feb 2026 14:03:13 +0000
Date: Tue, 24 Feb 2026 06:03:13 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Michal Hocko <mhocko@suse.com>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, zkabelac@redhat.com,
	Matthew Sakai <msakai@redhat.com>, linux-mm@kvack.org,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH] mm: allow __GFP_RETRY_MAYFAIL in vmalloc
Message-ID: <aZ2voRA5VJytcfLp@infradead.org>
References: <ff48283b-be21-7f9a-d616-e303a4a1ebe6@redhat.com>
 <aZykWyxLy34o7PKr@fedora>
 <32bd9bed-a939-69c4-696d-f7f9a5fe31d8@redhat.com>
 <aZzPwsBp-Z4XM58U@tiehlicka>
 <aZ2N9a4XgxnurOhz@pc636>
 <aZ2YDD_l5JN78DJC@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZ2YDD_l5JN78DJC@tiehlicka>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: wbaojbkt5jje4mawbppumx87x71winb5
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3166A80008
X-HE-Tag: 1771941798-584339
X-HE-Meta: U2FsdGVkX19HqNRtIZ5NH76S0ZY1UpZacy/dpOomgKEk4h5PqdyExw53fhWcPqxwoBHcbwbIBHzjG80W7snV5DLXTxHKvDR2mZETiyFdL4ZyOWwyLJv9XNpiwVlAUY/NNYbQqaNs2ziYbpoPgMZZYGbDaO+q0X6l5ZwhJh3tjrlx79pkH1QoXZjC0Z8/MdCjI138BHKp06ooTXc/RaziyPn77BU5bREuF2ZoDnJklyguNUTt0vEOsBZb3MK6OLTKw31Z/lJ7LmvGXSNJiFKRGjFh5H3DIfQl6qMb2zkn+QYvSI6PdtuAPtQlbYU9EvMMKtJlRj5bYMBqgeffQ3sovD7OFgfAgOg5XVf2fYba2Ga6BXsVSFlzA1rM56VrbIgdCn+xZTaV3mwCyLpjGSl19hpGI4kvgJQkA2hu9tMen9eiFV+YAmF8PHY+XwHw+nl21MXdeMrCThTtwn3zxYVEeyjZMc5tX8x6SZ02OgBgpWiRBgawd+zNiq1VNIQK81h4TumjHlwx1/ywPdF5FWdciJmOxPbDGjpkMWG4uZOsSUd1L7h4xORCWZjljmHsuHshTzxN1IdLEAXInY9fLJuj7j9iplFNNS3bg9g6/RhnmbnvEIDaFEoHbtBlyccCnA/wAM0L15i4ZtCV2Palq3PTdsXHd6kY5Q3CZNL7FO9IZWs82BktaCTOmiA2rZTIua1bU07TojAiIeKOBGhiBwaPP8v3g9zr/bAnRMTqdiucVQA/h6THSgujHvSe/lsQN0Vo2MnhJfdYQGzMtOa6Z7YMc3v8MnOMMrP1Pofgh34cF1MR6NYhsBMd1bkVA4Q/F4sXvNweTRzerQGsepdQlaWxmbM4zRbvmFADNQSprBbsWXJFGa7JsYCjix9IJFyvaixFvj+jl2wg6dPjiMLqNKqzrQc1r5MYqAxh4PNSgCrB0S4TZh76GQnBwYaTPClwfgyQ6pfyBv/qHjWCv1qxkFE
 GL8HHy7T
 ojoiybpUcreWER6CtD25js94aHmFt4f9vG55G4AKOBg6PbEgn28q6qdgYg0QwPJoa5C3UL6lsswpM+0DBoVxP42O880zI6TwcPHvtW5caOkBJICQHBX4EZ0klkPg9anFIP8L4HilslqV2DfrfW8k4rSmbPpwqEJ7yTTgjVWid/vCAQB08GiipxdRRi4I9JiJtqs2ExapDpq/oh5CBmSHSApSAoM5pEUgNB1/bCqAbUd8E0VT324fIJRGre/QgG4UwWTLk29V1x5kzpfbLk3H3pWasu7EIP2WJ0WgTvK3lF8H149r3M2JL1iJyhnpq0E2MnpTfpbriVr06ng5T1SWxCnWorhfXkPjyqJYJtCx0Juz/PD5elsNzW2ZMi5yZxBEYKIF9+GrU389rte34UnPrOsmbMWSCVMnLNDYyYxyF959wdZGRwDBKaOSHipCw2cLh8lJi/pc7bMCVnuLK/3YlmDKYnFNtwjO4DARUELpxQU5iHd8CXoeg8OViS0j9NRw4+fw0ZirYg+ES0W/ZpeSgpd1pqVjX15cy0BlJ5675Gte1CSYmdGeAXGAEMiLFaPgPTw8KLTZFCG5d3uEMISxYyEFoOMFUZcmDQI3q1IhiMYU/t3aeEjnpmnh78w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 01:22:36PM +0100, Michal Hocko wrote:
> One thing that we could do to improve __GFP_RETRY_MAYFAIL resp.
> __GFP_NORETRY is to use NOWAIT allocation semantic for page table
> allocations as those could be achieved by scoped allocation context.
> This could cause pre-mature failure after the whole bunch of memory has
> already been allocated for the backing pages but considering that page
> table allocations should be more and more rare over system runtime it
> might be just a reasonable workaround. WDYT?

Why bother?  __GFP_RETRY_MAYFAIL has pretty lose semantics.  Trying
too hard to allocate PTEs is not breaking the overall concept.


