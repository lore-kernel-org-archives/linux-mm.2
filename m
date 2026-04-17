Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEA5CF8E49E
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 02:17:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CC016B0005; Thu, 16 Apr 2026 22:17:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97D256B0089; Thu, 16 Apr 2026 22:17:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B9FD6B008A; Thu, 16 Apr 2026 22:17:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7AB1F6B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 22:17:27 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AA11FC3259
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 02:17:26 +0000 (UTC)
X-FDA: 84666436092.05.C84A7C0
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf21.hostedemail.com (Postfix) with ESMTP id A98841C000E
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 02:17:24 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ePuf2bAf;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of alvin.sun@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=alvin.sun@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776392245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OpE0Ez+CfIoCGnUqity0iKPTIYaJICOJp37vNEf2Pwk=;
	b=MJPI6Uso9t1F8PxD3fPBktOoDxeIEee7eWE3B3o8lj1qNXdK5IcVOzNWFH9WlA6qNqR6Qy
	jLoOdZdaMQGCFif2O0bdgg4zZn73VRXjdqQr558qaCMHsz++Yijjn6Y3GnGPwZSsv3kPr8
	gbO/ttB7g/sM31PV4cL0//Kg38dXtIo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ePuf2bAf;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of alvin.sun@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=alvin.sun@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776392245; a=rsa-sha256;
	cv=none;
	b=kBaGQ4odN2XFXLNkjqz05SxqMRL0HqhB8DG6sslSOsmPHIHsCdNIUa7PL/gQJxQqYfgczt
	zk6Uv/6u+xN6A2dFR2ko4IHZZyQICClQNgAABS7G45bYwKy2X1N9OLT2zmaoNEn+dVVqAO
	d+frVTEzcuuViYtcDIP8fPyEKwVsPEQ=
Message-ID: <df183bfe-21b9-4393-902d-18835e0bcf48@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776392242;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OpE0Ez+CfIoCGnUqity0iKPTIYaJICOJp37vNEf2Pwk=;
	b=ePuf2bAfPWmOfImJwnTQrq5T9bUWrri+n7NIsp9KYnA7oO4nDzM/fUB3u3FeYxVV4Yj8rb
	rfunkJ4LPwc2adnexxRrsZfpZc7edlQSEbIYcXfKfuVNYxFuMjtjok63FVo/rbLN3G+OLv
	RsoxMO0TywgV/aDVUFRtorhw0NJoElM=
Date: Fri, 17 Apr 2026 10:16:57 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 4/4] rust: xarray: Add Guard::find() helper
To: Matthew Wilcox <willy@infradead.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>,
 Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>,
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Tamir Duberstein <tamird@kernel.org>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, =?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>
References: <20260417-tyr-ioctls-deps-v1-0-41c6e9bb061c@linux.dev>
 <20260417-tyr-ioctls-deps-v1-4-41c6e9bb061c@linux.dev>
 <aeGKTIRFgBqHNI9S@casper.infradead.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Alvin Sun <alvin.sun@linux.dev>
In-Reply-To: <aeGKTIRFgBqHNI9S@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A98841C000E
X-Stat-Signature: idocxmoa4x9uka66s9mxgb5sypxtehc1
X-HE-Tag: 1776392244-426683
X-HE-Meta: U2FsdGVkX1/zYa5sysEuFG9SAgS8PWyghi0FRdUWY9sFmR3v3V2Onk7ITpLqyOFVqQVuGVs+IlAEjcJNBOoJC/cL+Vgw3YAaWEnyqaNzELQvWwOBk37KSovNzqwmqYKx2L2ZTOtddd/CW98EttLg42eS0oqFB8/jwY+/jUDRycGlcv6o9YChTzOnV/UX59X6ufkFtlAFZLKG0LEQD6dlDDN16J+p0droi5c2xX9K5peuLpdlAK8EGDOg0KcRxUei0QEA/6rvNg5NU14q6iCFLb/0WrfkuSUAzJ3tEm9rhNIO7wyyJe7hy7VchkM6aMZtJqluvYFfqhmlS12mm8C4Wjan5frZsQpZE89qFElMTM0ddQAtXriq1BPZ6rq+9lE8HuTzCz9cP3VuATIeQoq5WA0ku0iYd8Z5bW+FuNWS+iuTf+TxnJU7V5DDwCEaTLTZ0E7SlLSK4KaiPPtqG6yoBL/XFNCy/wrukwojTfJ4DXNcLI94vvY0vM15rkZD0AlBaCsuyJ9+LwpFuEsJHDSrPsyUrAGrtbFNvbJcXu37kgBm1wOwFWuJWTtudycAy9JIL/ZyVT1JT0Iwkd9fVdiHEHj0DPR8ckC0O1VnUxp9DwErjppNAhHTTeI7tNZuDC/y/XdAqZz0BaWeuSo02YJkEIcV2si6Mo3ye/k+sLyyYC4qN8Acn34Ub4hpRCt0UZCKdvim9bT0e8eJyu5oT4aPnR0tfjsfB9OPcwOLxd8xILePpO8u3Yo4GKg4+/Aqm8xZklx6VdXe2irRN8e/Lw9yXZk+xZ7eEeiuK61DDrXO++ETIrycYZpw2a1KDy0SgBAO9cGmPXpFOv+ShH7Pmq/5WDKoPy50KXq2AGRfdw56ESCP0Sv4a0mFyez3dK75rcLm60fcmGueHagicQ6Rt+cJHRGIFPI+6BxIu9oDZlKNoh0GXFAAA2z9gzCEW76yRkC8aOeQSTanacHSEth2Vec
 V0UG3zp0
 kePkZsVlKae8KoWKdeBPTK9XJxhNRUU23XNAzm1xBKusqbnvvdsnOEAU4Az6fKddcsN+CYkH/PXUGOnd5BXlfSlBirsKxouKGIFdEEXQPaI6F5epQ9agDuy7qJAFFQ5nKqApqkUAJBInTo+/TByTeSi90vztkvxpK7QOdqssJ1QaGjEr7ZtzUa5G5FKqhFzKc2dMZdTw16nRb/nY+UR8tcYXnDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 4/17/26 09:18, Matthew Wilcox wrote:
> On Fri, Apr 17, 2026 at 09:05:54AM +0800, Alvin Sun wrote:
>> Add a helper to find the first present entry in the XArray.
> Why would you expose a function which does striclty less than the
> underlying C implementation, rather than exposing all the functionality
> that xa_find does?
>
>> Returns the index of the first present entry, or None if the array
>> is empty.
> Why not return the value found, like xa_find() does?

Hi Matthew,

Thanks for the feedback! I had considered both returning a tuple (key, 
&value)
and an Entry struct, but only returned the key since that's all Tyr 
currently
needs. I'll look at other Rust code to see which approach fits better, then
implement it properly in v2.

Best regards,
Alvin

>
> This is all very troubling.  I don't think Rust should depart from
> what C has without good reason.
>

