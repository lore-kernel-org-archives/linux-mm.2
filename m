Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56851CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 14:54:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A15686B0008; Thu, 28 Aug 2025 10:54:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EBBE8E0029; Thu, 28 Aug 2025 10:54:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DA068E0006; Thu, 28 Aug 2025 10:54:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7D05B6B0008
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 10:54:01 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 29F28579B2
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 14:54:01 +0000 (UTC)
X-FDA: 83826461082.01.9E5845D
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id 481E8140002
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 14:53:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=NGzwkZWd
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756392839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=63fVgPj0dBu19FzzCkTktPqPtLpDcCZYhJHlKuiK014=;
	b=XrdQgKeXWy+pOYuKC5JWGXSTCg+rBSDZ3TQPX21KlNMjPIqclf4lw0PRWU+8sRHnFaCN76
	BUjlVAo3QRIz7Wo6XgsXrkNo/wGFgIee6MgbzXz0+BLxQtO0S2zLI6aWXKzVYHqirxzrxa
	tnxL7Z7q1/IQ7B0N7pgx9SysgxZMTJA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=NGzwkZWd;
	spf=none (imf23.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756392839; a=rsa-sha256;
	cv=none;
	b=q76W5NUCBX9VGMxA8KqRgJINVa8VD+F5a7yfXXq8QsdVsEI6z3lJUxxD39KdBZNc3mTvhM
	QT1qkAPVGVDDERhS8w1vuk+A84CkOLAwZ2pk8TOvwyZ67chjeGRj6bDOcwAhWRE4P6Mova
	7qkc2hwNlJ/kbt1xr0nbX89jxeSFeVk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=63fVgPj0dBu19FzzCkTktPqPtLpDcCZYhJHlKuiK014=; b=NGzwkZWd3jUW+MVaoOX2lFIM5Y
	jmBb/Ikm2qiKcf2l5ll36mpL87G1rh1GhTRXX6mxM9T0NwBFvGFse5LMniR+4P3Izaj51rm3ry1Li
	KqNwMJ5gY6PdfVqquMKO7UYJ5fj4h+G1f7d9myCc1DV3I+RLJjaTvQ2lUJaRRXCHSwTvmDxs5bhjY
	6BgJlM/k1Cf1kL+ytgAfWZLHFrTBGuQdJ8CD2UQjNeAZcsbjH38uSTdOs6JwYs7obwFG0cHOR1xub
	+hWOFWFCMct8D2+Bei4ytIaa6qLfmdPVWmgJWnvOnRC/63IjhI2MtLOpzaqcaE5SAV17KsmOhT6cQ
	ZffuRfqQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ure0i-0000000BRXD-3HRg;
	Thu, 28 Aug 2025 14:53:56 +0000
Date: Thu, 28 Aug 2025 15:53:56 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Ondrej Mosnacek <omosnace@redhat.com>, selinux@vger.kernel.org
Subject: Re: [PATCH v2 7/7] virtio_balloon: Stop calling page_address() in
 free_pages()
Message-ID: <aLBthEcK1rDPQLrE@casper.infradead.org>
References: <20250826205617.1032945-1-vishal.moola@gmail.com>
 <20250826205617.1032945-8-vishal.moola@gmail.com>
 <5ee2b684-94d9-40be-b01c-b0538ced33bc@redhat.com>
 <aK9Ogjn71JoOM3w3@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aK9Ogjn71JoOM3w3@fedora>
X-Rspamd-Queue-Id: 481E8140002
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: yu5ckr6j3mefbkfq6jpm3arhmopk51p1
X-HE-Tag: 1756392839-998216
X-HE-Meta: U2FsdGVkX18+4Ct5PTjIRN+bc0F6gOFgvP+SKxge5w8Zp9HR873kOyycXQrwThSSZWzzRiHHgqU6yNzbD0ej+ACYFkzIkDaft86p/yzgx8HR8+3TwwWPOvsF39egq+zksgpwF+OrZlY7itMUemYNQaD2TPLdQfL+ZZprJFU0j5oPtjsgJSxibXxmrGBW1BOWft5s9D1TiKAVRqFpvAuVPMh+pvtuNGejeA780jJjMCOSb0ymQjCkALOx27Q7wvcM8qIJBUFJqcY9EmMNPr1wOlv0KXFK8pwk68OAZy+Kq1E2UKpOYKVjeDK/QMODLRtUQ8A9t9HLk25bsL3Pck2Ih9CMyD8FlCD45wm9bMd+SXGI1sNCFcx3sl6LEKwLfLpLcs6jzn4Trk5fUPwCcndrLpP0aQsMj+agCbqNmdK48hg9x2LsWmp15ScjMcL+oShD0nGo5OEKuww4n2cvyEevHiPlc/N09E9FwK1H1weTNjvywMYevg9LLgsKDzvEdDId6DcH36WurV6UqLhN+XFeAGs7DGYgbKdgnJQiu++rne7UHFgPE6s7E81hIlt4DIxd5b3n6zp/+Ee5crzB6uTmrHI1LzlNusVZk+pfObwFx/Zigmap+pTr0fQ8K5QCNTxzPjSgeZh7XDNQLllScMdmU4piiWIbn4aSBojMWgU9IJJiWWVpi2dqB54qqVmNvzCd+g0CMfCbtzRSmz2ZMNxa5GPfrgw6FsZHgVrZFQl9k9bk1cT2n1UZJwJRJFXBokSeUVirZGu25+I2XNYKEsngiutHKDtPBRpmIqrp95wiY7/13S6iwkkA8v+m9H08O/80Pjvp0ISpKMPeP10l8ih/x7RxeVpU2ks0yJuKe/D7oNSX4Uhw4rgGCbTrldEcBJBbPq/RK+pp2QSKee4ykpD4h/89Ktmcm55bGAc2+65BDfzKiWc4te/6Z9n0N90UpyOWSHY5PDqcNwG7ntiHhRI
 YrVWAcIc
 tnhHUGxhtgNIzP3D4oEpi7pajF1atI3gHAZr8wmO3rOa5wUomn6RsFxeYLYEJ3zQTKnUOWN2QNG3t6IPJMjiWzYEZviSY47BdfhldbWgVHoMRIFfuuPsG8euGxSN07nStVkf6lYVbLFDz+COEbk8SZFG/UCCeITF4kbMPJlv2bxFQp0iahTL3TjTem6DEGJ+Aa06Ah9Qv5IPRSIYtefqtG5QRjxXun7cgSuSlEarhznXFBuBvp+9EoEewh8CyRjuH1E11iTsU3K8bFGsIaid7tubsX/asaISD9JpdBqBKb1K7udEslN5OBggoXOjVFIjJgzB4AfUoBe0+ABI1kAd4Tiqc2GI7flEiYLNz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025 at 11:29:22AM -0700, Vishal Moola (Oracle) wrote:
> I imagine theres more of these lingering in the kernel, but theres so
> many callers and I only looked for the ones that were calling
> page_address() inline :(.

There's only 841 callers of free_page() and free_pages()!

It's a bit of a disease we have, to be honest,  Almost all of
them should be using kmalloc() instead.  To pick on one at random,
sel_read_bool() in security/selinux/selinuxfs.c is the implementation
of read() for some file in selinux.  All it's trying to do is output two
numbers, so it allocates an entire page of memory, prints two numbers
to it (while being VERY CAREFUL not to overflow the buffer!) and copies
the buffer to userspace.

It should just use kmalloc.  Oh, and it should avoid leaking the buffer
if security_get_bool_value() returns an error.


