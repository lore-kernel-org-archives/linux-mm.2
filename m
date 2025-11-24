Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C016CFD318
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 17:38:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 476026B0026; Mon, 24 Nov 2025 12:38:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4263B6B0027; Mon, 24 Nov 2025 12:38:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 314FC6B0028; Mon, 24 Nov 2025 12:38:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1BFD06B0026
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 12:38:09 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B59FD13B176
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 17:38:08 +0000 (UTC)
X-FDA: 84146209056.30.88F5C29
Received: from sender3-of-o52.zoho.com (sender3-of-o52.zoho.com [136.143.184.52])
	by imf25.hostedemail.com (Postfix) with ESMTP id BE467A0016
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 17:38:06 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=mpiricsoftware.com header.s=mpiric header.b=lTpppgPt;
	dmarc=pass (policy=quarantine) header.from=mpiricsoftware.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf25.hostedemail.com: domain of shardul.b@mpiricsoftware.com designates 136.143.184.52 as permitted sender) smtp.mailfrom=shardul.b@mpiricsoftware.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764005887; a=rsa-sha256;
	cv=pass;
	b=7fQRdbmMSBUQuKi9YeMNcvXyw3+mzclvDNZ7GHyIAYHJ8yq2kEccVDcOCjXB7+NIUU7cLj
	f8HgZ8p/uG+c4KNME6ZTV9v3R1fPq4pK+LJANY606Z5nybcm4cHcGbpeKGoySXEiKUdaiB
	I4yJ9c8m7u230QyyNFelpqBNyqrIrsE=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=mpiricsoftware.com header.s=mpiric header.b=lTpppgPt;
	dmarc=pass (policy=quarantine) header.from=mpiricsoftware.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf25.hostedemail.com: domain of shardul.b@mpiricsoftware.com designates 136.143.184.52 as permitted sender) smtp.mailfrom=shardul.b@mpiricsoftware.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764005886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R8m+NhBlevjY7KyauSa05XI58p+o1dvP2cF9/uZRii4=;
	b=OQjKpt1BgWWkgACxIM2FRpaYCND3Lii+0USyJuvbR7Q+1bMwsR800wo8xdkfgRipHrU3XG
	T8rg9aE5D415KiiTaBq91lDSK4Y/tkIRY3kRmvTrHKzNY+Dmfw+uTs3K33hMJRoTPJwP43
	rPNOcT+zwazn5BVTo/O8RdNWq4+uy9Q=
ARC-Seal: i=1; a=rsa-sha256; t=1764005878; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=e9EMJ7C9V7nfcvE1RkIz5sC1zenMutYXhUVITHZRQIeQwm2t8Lqi234J6GVJS9aFZ7R1yhfKauTyvHWKfH6VG0ozASwZPhIHfgYY58ll59slah96bxdrRLj5Lw0y2QHBNkNw6bg7VQUlFbi+jn2uf7RDgfQp2G8Bb6oZSUXI7kg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1764005878; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=R8m+NhBlevjY7KyauSa05XI58p+o1dvP2cF9/uZRii4=; 
	b=kwL0cQzMxLZXPtmxyvwPXwNloVKqu5Hx+yuX5Ngv3DT3j5Qr74ZyZ6b5lrExPWimgUR8NUssO90xdzeNejRYWa9bpgxLTNOFHEShiPpmmRbxyzgWFhr5cgPH7ZW3/oaTzeruagG6gbtvetMOhAZIZCJ40qQtmECVWIOFwz3Ufow=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=mpiricsoftware.com;
	spf=pass  smtp.mailfrom=shardul.b@mpiricsoftware.com;
	dmarc=pass header.from=<shardul.b@mpiricsoftware.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1764005878;
	s=mpiric; d=mpiricsoftware.com; i=shardul.b@mpiricsoftware.com;
	h=Message-ID:Subject:Subject:From:From:To:To:Cc:Cc:Date:Date:In-Reply-To:References:Content-Type:Content-Transfer-Encoding:MIME-Version:Message-Id:Reply-To;
	bh=R8m+NhBlevjY7KyauSa05XI58p+o1dvP2cF9/uZRii4=;
	b=lTpppgPtFvuHA49IswZAI3ZoKkDDtySWa8cCh4Khbeyp9cMVvV8Rgy6kfAw3hy3L
	jDA5WF0GpLnrbu6w+LIi/NLkUppOKc+vkZt12i0dR6PfC1Baevf7MRc6s+LszPHdkCU
	YppXczSVyQ1EDAwCVVhNbllffiE1xPA8/L7FDxxE=
Received: by mx.zohomail.com with SMTPS id 1764005875356485.54990985986535;
	Mon, 24 Nov 2025 09:37:55 -0800 (PST)
Message-ID: <7a31f01ac0d63788e5fbac15192c35229e1f980a.camel@mpiricsoftware.com>
Subject: Re: [PATCH v2] mm: khugepaged: fix memory leak in collapse_file xas
 retry loop
From: Shardul Bankar <shardul.b@mpiricsoftware.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-mm@kvack.org, dev.jain@arm.com, david@kernel.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+a785d07959bc94837d51@syzkaller.appspotmail.com, 
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	janak@mpiricsoftware.com, shardulsb08@gmail.com
Date: Mon, 24 Nov 2025 23:07:46 +0530
In-Reply-To: <aSSGH6IBIuK64EUX@casper.infradead.org>
References: 
	<703387c8908a609c3de966574dfcf481c5a97216.camel@mpiricsoftware.com>
	 <20251124161149.1302507-1-shardul.b@mpiricsoftware.com>
	 <aSSGH6IBIuK64EUX@casper.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
MIME-Version: 1.0
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BE467A0016
X-Stat-Signature: fajzquog6osfu5zj4h7d1ooyyrkk5tfn
X-HE-Tag: 1764005886-393247
X-HE-Meta: U2FsdGVkX1/1xCXbxKuiV6ctKZfEGoBHNsPxP1mg8ZhL3I1AXNTSJpaY/5TGu756SFEQ2WP5/WAaTpNn378MvI4W5rYF7Ctz0dhjMkL9CzZv6tS7tnSq3ii/G1prneiEEZUwwWyu3lsWvNgV9z6+2hr8mfcESMdrIFo1BnvoVg2+UtQXqVYQ95yCPxRnRsBX5pc30kwX3uyRr9/7CQs+56I/qKuIyxcqXnoAFDwJRn+JrNKVQasMH2ej9viRfyy0SVJNvHnL1E20a6eZZV7VkOZFvNRY5bPz5zluisOy25DuNGQ7fxsAf00hwLmzxenk/veZZ8CkYnGOsagfgsMCofaplfad7R2w3wTSzQRelEJFpaNvhp2NgUP1PCbPjepzlCcnp5fn0He11n6JUb0EA4p0rdOieMpw1XZug/q92U9KpHqCChhkljOzEOsnBmk+NQW3p8p0CvZFBERN+bN+tvhsj3SB7qWKpt9gVVBVhW6o3gZaMzJ1HDcg/nnHHTtN3+IrlFOHzHUQ0IfG8zAal1DBzmfKH+DuEaQKG7TOT4rQJxAYOdKm04Brfy8+D4qOpJGNhAignnfPxPyQRevcjoiCiOUduX9QX7bmdI0+ICrI6BQumGttEh0cxVaSto0H13D6s+KX5nJ2Ahd/51TelobI/AF08tNRg1aJMpZumJ7fEvNBoBGY8ewhXBc9kWelvJwNEEXZp7gsViOpjF8CjyZ4bdaMfZz2SjAz0cFf/CmSN/P41C9MBC9850CmYMsKwP0jW5xI8dWQP0g0yOQpuPBoVq1TK0WrvArGXJJc/F5p9uWDKYp8JDamIAV9hndld3sxxGX5pvmTXw3Kcu3ZlYvdaaInhQB5C1Gi5DvQKCVkvfRNMNwhRlKwFQRuYdbZEPyo5WTYU8TPDxqOdUweSw/RFVjNWAzjMtsnkAxk3aBgN1qbqUGgfXlQqjs7BEHh4YiVcYl6Gpv4m6yq8O4
 RG8oh0Bs
 zFnM4nqCXgVgjcJegcqMRWz8VDUO3xJHDM6CCycPhnmsM6t/jRlpTA7ux+xANlX4GXHatgnsiLAlKyxPwWrBrCwZH1EOoEE4M2HZ4hSys7gmLRQPt5PCKFXYHo160s75YUyotNFoq4w7XegTvfd+nLoDVbFgTyX/Z5RFHEYGnNGu1sIMn2s4bIlwj/nj7Qk+vi8K3IxSsSZeBWYLCRd46SnQvY4Dj2OoU67Fuh8tZK2XwEkwElDRcdfYt3PQP7gJTUdR7MXy1vbp7nqPyoGwT5i8Dg6/AdfH1ONRcYN2jIVNiRNLtYOb/6kSvyx1R7hBHVj2365uDekxJszit4FdR3F64r7SVek/gLdvBvXVEKjJE/Cre/H+2nqMy+C7UdydAc6teQOm8tSFbZgUD2+v4wjiW4590VyUdgRczC2NDOE1wPHQFrXm+zix3S7H574NmMUTpbhlluphbZPIuUMcUFF8QJtZDpsCJlvbknV1K3NlUuKhmQd7/YT0jnMsHrETpWdFJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2025-11-24 at 16:21 +0000, Matthew Wilcox wrote:
>=20
> Then wouldn't freeing the excess node in xas_create_range() be the
> correct fix, instead of requiring the caller to think about this?
>=20
>=20
Hi Matthew,

Thanks for the feedback. Agreed, this is better fixed inside xarray
instead of in collapse_file(), so callers don=E2=80=99t need to think about
xas_destroy() at all.

Looking at the internals, xas_nomem() only allocates a spare node into
xas->xa_alloc and xas_alloc() consumes it only if it is required. The
only point where we know that the retry loop is truly finished is after
xas_create_range() (or xas_create()) succeeds =E2=80=94 at that point, any
remaining xa_alloc must be unused.

So to align API expectations, I=E2=80=99m trying to understand where you wo=
uld
prefer to enforce the invariant:

  - In xas_create_range() after success, ensuring no spare remains?
  - Or in xas_create(), so that non-range callers benefit as well?

Once that API boundary is clear, I can prepare a v3 that moves the fix
into lib/xarray.c.

Thanks,
Shardul


