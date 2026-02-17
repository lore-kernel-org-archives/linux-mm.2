Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5B89E68171
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 13:09:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E028E6B0005; Tue, 17 Feb 2026 08:09:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCCEC6B0089; Tue, 17 Feb 2026 08:09:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD8A56B008A; Tue, 17 Feb 2026 08:09:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B97A66B0005
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 08:09:44 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 45334C0632
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 13:09:44 +0000 (UTC)
X-FDA: 84453980688.15.B7D8FBF
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf22.hostedemail.com (Postfix) with ESMTP id 766CDC0012
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 13:09:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PpJOZ6BR;
	spf=pass (imf22.hostedemail.com: domain of 3lGiUaQkKCAslwtnp29swrzzrwp.nzxwty58-xxv6lnv.z2r@flex--aliceryhl.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3lGiUaQkKCAslwtnp29swrzzrwp.nzxwty58-xxv6lnv.z2r@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771333782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bk/cFXLoYLqrj4sg1yVxZO5NjYHyns1konO/B0ZPP6Y=;
	b=YGnxhw4/DpT74mIsUwvll5XPjFFfNdoPBO6qtA7Mi87s5udmwy8udDO4awBG3bz4G+Vr8r
	eEoflfvZf6+IApR/UFhjlX+vo/wG8XoALN7j2MUWmKNz5T289cdyjNBfknx/ipQgW6/pPn
	nBZIr6IW6/gORwkd+pQnEaGv/i//uAI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PpJOZ6BR;
	spf=pass (imf22.hostedemail.com: domain of 3lGiUaQkKCAslwtnp29swrzzrwp.nzxwty58-xxv6lnv.z2r@flex--aliceryhl.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3lGiUaQkKCAslwtnp29swrzzrwp.nzxwty58-xxv6lnv.z2r@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771333782; a=rsa-sha256;
	cv=none;
	b=yOdZmHukTyQNhtqqP0mHFsj+gVxXPVySWHZ27plPUk1s5/hj1R8KCx9rm726qekLXUMpdc
	VPyp4F6rcbleKFmdJKepAJz16kxJZhslQEy/8kpscPB3SGsenytIfAEWt5v8iN9ha792pm
	VTF86DqVeGMYx+9Vfmo8wYr3rqEv2/I=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-43771113b3bso3264845f8f.0
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 05:09:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771333781; x=1771938581; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bk/cFXLoYLqrj4sg1yVxZO5NjYHyns1konO/B0ZPP6Y=;
        b=PpJOZ6BRUsM96xtnFcqfPaEMSXLLD1q18fH/ZeydN41BKsFSl3MqUJ+6weOprS9QvJ
         ZlAi6deyWIBH72ImglaRXs4rdh02u0DXeSMbn0y8c+DpPAb2BO8SoVEkjiZZ8qhA+Jus
         QLVVIne4vyKrXNVjyYeIkqGANKpPsEYIqzMcUJk/15Rd9OLsUp44V5R+yRT6Pvf7aKzl
         aDtIMInzZG4Vqktv1FfevS49Bd4Zdb0JccY0hGij6O9KjUebdNpY3Cj4xdPvzX6W/nkw
         1oXgAnkPJ7p9j7xLO5ssKiuJl+nWtgoz2TlEQhkhWJahI3p7m2XhtnsVjZLhF+NuPIba
         cS9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771333781; x=1771938581;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bk/cFXLoYLqrj4sg1yVxZO5NjYHyns1konO/B0ZPP6Y=;
        b=wbbAO7WuQxQqBJHefKrLKhiSeJT2m1yMIzkdYdH8kWm2PyYWjB3GEOt+H7HBoF0JTo
         5jbi9euPljrqP2NLiQfBNYiFqc4+lDeRShFxmtEhsXWR/64GnDgNlqGeEXqfv40Dr8Du
         KMxlXW/E419QJH40FxBFxEZQX1nQVhxCtI3QqPDsSwJtyE52N3Gae2weLKxPKCUacUOh
         4/HSS+N6d3zZ93kSL0V+PV56D7cIHwdQ8xHyk1QcK1t7bRdCNhQKdWU5rm50VPkEE+89
         lBtlucaY/UvT5JX4NhLAvHNkXke4uDuh9XRzCUq4CqHm/4zR+RnKr5dXtyUWDkjrAayE
         J1WA==
X-Forwarded-Encrypted: i=1; AJvYcCX6WUofcajSTpS3bjizEWO1eTjmfdP2nKfa4JL55B1A6fjHD8dfNBXBmZoLKxMPaFBmG1U5RAt89A==@kvack.org
X-Gm-Message-State: AOJu0YyhB7tuFCcP1EzzQ+7GF71NmXB74/j9npgGOv7nLiJskGMhMHYB
	ca9GUCnQq6xztRMM9+bJ/z5nz+CFY30ThCwMjt7wZOyDXRp7IsExoZpkpmqCIf/dYk9a6RgI3kv
	LPJOQa+TcoHRuBqXtMg==
X-Received: from wrwj6.prod.google.com ([2002:a5d:5646:0:b0:436:284a:139b])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:4305:b0:431:8f8:7f1e with SMTP id ffacd0b85a97d-43797918f32mr27847831f8f.48.1771333780501;
 Tue, 17 Feb 2026 05:09:40 -0800 (PST)
Date: Tue, 17 Feb 2026 13:09:39 +0000
In-Reply-To: <20260217120920.GZ1395266@noisy.programming.kicks-ass.net>
Mime-Version: 1.0
References: <aY9PBfx3RRV7rXZ5@tardis.local> <20260217091348.GT1395266@noisy.programming.kicks-ass.net>
 <aZQ19FEeGgigdwz9@google.com> <20260217094515.GV1395266@noisy.programming.kicks-ass.net>
 <aZQ8lJJ-U_8j03Z4@google.com> <20260217102557.GX1395266@noisy.programming.kicks-ass.net>
 <aZRHJ7pSzOHruPA2@google.com> <20260217110911.GY1395266@noisy.programming.kicks-ass.net>
 <aZRWOIPThLfIZ1Ph@google.com> <20260217120920.GZ1395266@noisy.programming.kicks-ass.net>
Message-ID: <aZRokyTqsd_RwdkK@google.com>
Subject: Re: [PATCH v2] rust: page: add byte-wise atomic memory copy methods
From: Alice Ryhl <aliceryhl@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Boqun Feng <boqun@kernel.org>, Greg KH <gregkh@linuxfoundation.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 766CDC0012
X-Stat-Signature: bs9ijjd85r3fddi63jt69q184uhmpotz
X-HE-Tag: 1771333782-560225
X-HE-Meta: U2FsdGVkX18ltmrTVk+ct8l8HVZEZODR4PMSD2OaptM472dfpDVB+XlfY/OCJMW9aRqnwcq2baiO93t5DGQKrUErAo53y3G/6OV8rL6/Xq5B7qYAcJ8sWLoWijixHqMx+arKi5+AEg3YP0S5WJMmIFdyYfGPU/Le/03K6ACYu7mzbAyp4Jd+u0Q/N8uVSscIB+omxfBYEpRw429MYZKXrAY7zjU8OvfG6E9Lfpn77c+Lgj8xUspsou0VNx8qhCrNSNpdbwCBFTeOCHjsRcGcmyTjxL7n1Pf4nNezBnoLmeRXJfeZW4loSvQ7UuU9y05PFraZF6hFWOZc/Z6/Ac3nBEzq7xWfLSxsLdns+A1HjIYl3p97ndjBRWcIw9oB0ubO5V42ay+cXM1dTLVWEmi4gTK1GpBLZ5IXCxvwL2Jp9ZEUuNJCtzHy8ysO6oRpp09skGkZC4ikOswYcqGOK/6SUj8s1vKMqWoMX+fk0dyu/FQJMLb3uQnWKGmWDZw2q2m4rdpkCXyUZX5QWZuKfMFdWf2l54i7lL8wYnhk0WLlJdwzLqGtHbaCetbBSxbLriyUCXMb/m+jSrmvSc0oy1uTpFJvfkHg82MQAZgFbBiopYq3/Q8F79IKTy5lL2ofWqcZMTEGdIj0t3NkJt9VOxYbeuuaOZgRPCbZCRp75SsK8N2+0frht3hmVDB0AO4g9SCJzUmZhvMY+TqTER7x6MrqJZfKQ4uaXAwSlNOAHfr7Vfgu4ZKaTreCvZ4pUBW3cGhqZnxH9HUuBiWMQAn/xSwZZ3WRG+Gt+Sz+0AGbpZ4GI8OqbSp0jU/5SSYONUn+6tu0tjAz5sXrM7+Uf5HNUGC0UVrJSw17rucLjNqEF2DuhbsjJdXbmYgnckWebQQqRd+eOmgOq+xpuWvD/x8ftwl1CTmfKxrTRVSXSv4kgDECWfZS6zQU+OD5fAqnwLHikli3e+o8QUSDjti848gHFrb
 uXVtQeC8
 OJ/UC1CioW/IGKm6ycHcSs7iO6LcDwoqC/baSojiY1TQywUfjnKtHJBFu84nQxyqGjwzUrnd37z4FVoDifGOTulsdtz4jEutRY+unCzJXuVkoDYdnzXFTwz6AaiHHGuDGVg8FLATotVF3U0ioM/GhzZhwndegPi2HpBzTTm0Ml3J/WiQHyrGGMLnMNX3Y/v6jnY6DOafVsTyJRLTBEXiKC99vqC3Xa25mm8ofL+4SroCf+xtyX1k5JDN5bo4yaVpKKDd0KuCwChjg++8qfEttYWXozlfpVYgukz9nQOXv7RkNjPu6DJVdpDxlpuDnNliSn/rAysq101EJ3HMb6k+Q/ROIPfDPS4wiNVE9NoeluNh7pje0a9nzyNNwjx1WB+MRi14FLc/zObjRpH1QyoCnXGozQdglTqlVHYWcUAUt3bLzfHTdzP4a3TPpGxzNcTsBB6Zlx1pahCMhzcPqFf2mxmvgBC6PJ60UxarnYY0tJqhpvBsQD/dFujYN+aRqtrPYP0eViozn7b6BdnxYKmC1dRKhfMpggndUXslVpQ6MyBFJ42UJyq9l10S+zEzjWQHN/mbHEcBONI2ntR2TOVOrKapUkkshCmEVZ75/71iMPNl6qxCQczQ9p6mrlfdfm/6hce0iacTkiW8S5wDtp9zRFkHKEXOvU96Ola8zlRkqoF12T/WqGBaN1DE+MQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 01:09:20PM +0100, Peter Zijlstra wrote:
> On Tue, Feb 17, 2026 at 11:51:20AM +0000, Alice Ryhl wrote:
> 
> > In my experience with dealing with `struct page` that is mapped into a
> > vma, you need memcpy because the struct might be split across two
> > different pages in the vma. The pages are adjacent in userspace's
> > address space, but not necessarily adjacent from the kernel's POV.
> > 
> > So you might end up with something that looks like this:
> > 
> > struct foo val;
> > void *ptr1 = kmap_local_page(p1);
> > void *ptr2 = kmap_local_page(p2);
> > memcpy(ptr1 + offset, val, PAGE_SIZE - offset);
> > memcpy(ptr2, val + offset, sizeof(struct foo) - (PAGE_SIZE - offset));
> > kunmap_local(ptr2);
> > kunmap_local(ptr1);
> 
>   barrier();
> 
> > if (is_valid(&val)) {
> >     // use val
> > }
> > 
> > This exact thing happens in Binder. It has to be a memcpy.
> 
> Sure, but then stick that one barrier() in and you're good.

Are we really good? Consider this code:

	bool is_valid(struct foo *val)
	{
		// for the sake of example
		return val->my_field != 0;
	}

	struct foo val;

	void *ptr = kmap_local_page(p1);
	memcpy(ptr, val, sizeof(struct foo));
	kunmap_local(p);
	barrier();
	if (is_valid(&val)) {
	    // use val
	}

optimize it into this first:

	struct foo val;
	int my_field_copy;

	void *ptr = kmap_local_page(p1);
	memcpy(ptr, val, sizeof(struct foo));
	my_field_copy = val->my_field;
	kunmap_local(p);
	barrier();
	if (my_field_copy != 0) {
	    // use val
	}

then optimize it into:

	struct foo val;
	int my_field_copy;

	void *ptr = kmap_local_page(p1);
	memcpy(ptr, val, sizeof(struct foo));
	my_field_copy = ((struct foo *) ptr)->my_field;
	kunmap_local(p);
	barrier();
	if (my_field_copy != 0) {
	    // use val
	}

oops!


