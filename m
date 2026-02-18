Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 326DBE9A03E
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 10:18:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 556296B0088; Wed, 18 Feb 2026 05:18:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 504496B0089; Wed, 18 Feb 2026 05:18:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E60B6B008A; Wed, 18 Feb 2026 05:18:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2A9EA6B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 05:18:06 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E17811B3C6A
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 10:18:05 +0000 (UTC)
X-FDA: 84457176930.21.889728F
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf04.hostedemail.com (Postfix) with ESMTP id B0AB440008
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 10:18:02 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=MixqCoh1;
	spf=none (imf04.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771409883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JSbgq0EcfUZhNPyWfFrWFmo1kdV6esGJ7PBWXAnMYXA=;
	b=6KDmZdlNTF6qMS5Qpcw3PUgs7aJGhWEe5wg+NxO+k5EnH46QWvK5x9dk7MMkPGw5wJ05n8
	DI2O8o1O10JKHjqRR4prlMk1cM7fBdZJKuDkgXeHTKIEVpugVd4xthAgI1lYyf9gaAygEz
	WqgCcreuwZ5rQT39j6cqmQwvrgjNxZ4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771409883; a=rsa-sha256;
	cv=none;
	b=xvYjgcK76iP6W7M9YauxSg27CBURcJzDX/xNunJgFxw5BqUaEbjX02GfG3TRDmSMuk7wXN
	kP7ATyPiWAzhiPKsirdTLnP7D1B4hCOndnuTAAo54Cp+hyqFpDf0PqQ0MPU6fVHBmJKk8F
	MShoKIT4y+U5g8Zl5bYagf7elmwWlSg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=MixqCoh1;
	spf=none (imf04.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JSbgq0EcfUZhNPyWfFrWFmo1kdV6esGJ7PBWXAnMYXA=; b=MixqCoh11jPxOeY34UG98Pbcrx
	vNPOeORRcdv6BMxE2gfHrZ4fA0Skbfe3G4en1ZfXgkfJnblAt2Q/xqhIrsj8Lrb7bxMpQLfX1qF9d
	F6eFPo5ZlufMeRK8+JhiFvD6E76dAGMgbtCteGghY2hsO2HETqdcAkIr5IQ/rlbEqTUqVEUE3ZNRm
	4O0xrOSgeNkt2g53lNGHX8DsaHIeQgl16bA6/nEUVe1WI9krN5RQlxxzpDaCUBCe9E+SARx7Mq8OE
	LFE5UjeK31gaSWhBJn8QyFhMuv5Ms2U4vbrFfTYtgREpgCDoJGXtu562xex8+ZbhwBnzypy43kEQo
	wFg8CabA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vsed2-00000005s1W-3f1Z;
	Wed, 18 Feb 2026 10:17:57 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 4FAF93004AB; Wed, 18 Feb 2026 11:09:15 +0100 (CET)
Date: Wed, 18 Feb 2026 11:09:15 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Gary Guo <gary@garyguo.net>, Boqun Feng <boqun@kernel.org>,
	Greg KH <gregkh@linuxfoundation.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>, linux-mm@kvack.org,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] rust: page: add byte-wise atomic memory copy methods
Message-ID: <20260218100915.GB1395266@noisy.programming.kicks-ass.net>
References: <20260217102557.GX1395266@noisy.programming.kicks-ass.net>
 <aZRHJ7pSzOHruPA2@google.com>
 <20260217110911.GY1395266@noisy.programming.kicks-ass.net>
 <aZRWOIPThLfIZ1Ph@google.com>
 <20260217120920.GZ1395266@noisy.programming.kicks-ass.net>
 <aZRokyTqsd_RwdkK@google.com>
 <20260217154800.GY2995752@noisy.programming.kicks-ass.net>
 <cbbea9ecb994df975109d97a7756d73e@garyguo.net>
 <20260218083754.GB2995752@noisy.programming.kicks-ass.net>
 <aZWGq8EMxz4omw4L@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZWGq8EMxz4omw4L@google.com>
X-Rspamd-Server: rspam09
X-Stat-Signature: hu5e9frfbre5goy98jipqmaikd5sqk48
X-Rspamd-Queue-Id: B0AB440008
X-Rspam-User: 
X-HE-Tag: 1771409882-550781
X-HE-Meta: U2FsdGVkX1+sLu9Xxba8zTKidw6201ylBfgnnZU/eEQORWpzEQY/1EYsfB2mt472G6mFWKBu6GU9+iNienMhWxDJi/d+2RVawX9UzFcWQulQsvYTD6YuoBE/fMZgfb4BF45rLrneI6vcHOafM42ImZQUGpZFMMFyEtJQI2oqWBijKoq+29xOfrTNcxv9psRjXznK68VGkvjcq8f5/dFH6zG3dj2gwb8dzHYwJGCwYHtZ2gZyxCgzXzE+dTU9Y7cvr5rMjOns2rxLZaVNGT8GNirc4tcvx8Q653+U4zqjR+YSaWzL4V+hXpl2+tT6h02yui6MZMszWrvyKyXqqjIgsAVPT67ecAvT3czj9dF4V/n9OAUFcQuumhPVC3VC01SN8gn6dMYO8TYHg+133HSgz0vAYlFIsGPhHMu/53wLfkc3GFXga2rDbFQCA4jeEmxqxA1NRLeWCCKeD/Yw7iTPetVWhecerSMQxkmsXmaLuZrG37QUw3pvSDG9Tv//Uuh+dYAY620l/fU88u55+3g3mjwrKhAsMs016ynTREaYk2Sv3gsqL+eQzrW5LoCNsTba24L6EKBO/W1AXnLZFZT19fYw7es5oegBicRN8xjzVqKaTIpb4N6/8MKRzhvTUQKays/JCp4YvSSDpFo92QdUERu6ifWu7WKCE+It9DHIJo5Rt0dQNgQzmnGXZ3cx6Qvfu9TOPe9ugEbrCiWXHQuXVQRRHs7Rg47aYIUzLcOBWSKg0vAPXznE9fhY1w4Xs3LxgMfHEAuk2QX8aLEEiWcdLRX9PyYA3RG30hR4fe803pRObo5MVmbGSQCMz3CIZUFY4Y57L25RGGziyK6qcmsh6sZmlNWYIip3dPlT0ysjCks08kkRTZotIoD30pMS4gAUhyIvuTLWBgV5n6INd9xE2MFPQuPOP5qlItt7nqZVhJQzDSahLvgbLrvdudMXi6W6EjDj77Q3Q+cDEVSSXiC
 GtCtX8k3
 S1M/CjpTgtHrEkC/8T5ZlGD4aAkCfZfrHL3dtq6hqEIABwLXT2YJ3tOZwoK2loe8uKergBdQvR19bvM9hXkx9MU/i8qHOcgMvSyWt60vnWrbg91SZDkJyECju2y4AAfZHtjSUUuGek8hA/CqvwPidwtaJEAvf75V6e3ypEsOvKwKFC0xMw9mx7VxHoVuyHrW1UhlYVUNHmb9pizuUQOvUo1caOfIMvPkSvJ4zLiiUAKHv1CDG9OnsTvhX46EFilJDi8fj+TAakPgyUlWgh3foRzmKMtFnYG9aIMBV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 18, 2026 at 09:31:13AM +0000, Alice Ryhl wrote:

> > Must we really go write things like:
> > 
> > 	struct foo val, *ptr;
> > 
> > 	ptr = kmap_local_page(page);
> > 	memcpy(ptr, val, sizeof(val));
> > 	kunmap_local(ptr);
> > 
> > 	ptr = RELOC_HIDE(&val, 0);
> > 
> > 	if (ptr->field) {
> > 		...
> > 	}
> > 
> > That seems 'unfortunate'. It basically means we must never use local
> > stack for copies or somesuch.
> 
> No I don't think RELOC_HIDE is what you want to be using here.
> 
> The way to stop the compiler from doing this is to ensure that, in
> LLVM's eyes, the memcpy is either a volatile memcpy, an atomic memcpy,
> or an opaque function call. According to Gary's reply to my email on V3,
> it sounds like an explicit call to memcpy like this apparently falls into
> opaque function call, so it should be okay.

Ah, so we should write:

 	struct foo val, *ptr;
 
 	ptr = kmap_local_page(page);
 	__memcpy(ptr, val, sizeof(val));
 	kunmap_local(ptr);
 
 	if (val.field) {
 		...
 	}

That forces things to be a function call since it elides the C memcpy
intrinsic for not having the right name.

But that also elides KASAN and such that want to hijack the various mem
functions for instrumentation purposes.

