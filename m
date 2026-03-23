Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF210EC01DD
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 12:08:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5713A6B0088; Mon, 23 Mar 2026 08:08:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 521856B0089; Mon, 23 Mar 2026 08:08:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E9196B008A; Mon, 23 Mar 2026 08:08:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2972E6B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 08:08:25 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EA5CC5C0C2
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:08:24 +0000 (UTC)
X-FDA: 84577205328.05.CE7B6A6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 579B9140002
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:08:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UMpoQMqH;
	spf=pass (imf09.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774267703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kug4uuXiIKz9HVtBxQUo1Wgxm+X2epKT6qijYJOAhGY=;
	b=Gz3iGlZ9hdMWlb5DqNzxim20orYITm9ub/e7//ZqeSzLONsapb1ydp7Z0DeopDawZhGSGk
	q9G2sD+ATaWTvNqTD+rU6abK8j2pvI9nwEUgWFqnI8U3ogFdlOioBh6gK7FsWQ5quv0OTc
	1IAPKCe5WHhmRBzAx5L6Ye3XtomXNgM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UMpoQMqH;
	spf=pass (imf09.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774267703; a=rsa-sha256;
	cv=none;
	b=LOT8duN89F6XL2A6SO2oa3fhC6sVa9Qnj6AnmalVrFZaa7DVYkuaTb9X6HivkrmHmWEfbi
	FYQa+g2XL/LpTxImXmf1RAzwy7/Tl/AYFjlfuQ0Gqs8kx55XDE8/W2h4wOD0Ndrpfw6v10
	jFjETtSraOiMF3M7C1X+PugL+7kAoMA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C379E60103;
	Mon, 23 Mar 2026 12:08:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4AF2C4CEF7;
	Mon, 23 Mar 2026 12:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774267702;
	bh=Q7c7YRUKbJB7h3AZniygI8hUU3h+dXr9eLDt713Z4Wo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=UMpoQMqHQpm7Lt6rdcCSDM3Qt7iufMTBL2PLg2t836OcL31jTd38g1/hWUUmkQr6C
	 BXGgrMe84kl19LRKekTspkCCzyVgqCBTXdNAG7z/fogi1teOof5l0z14e6+yTpiPtv
	 aJ/GDzQDltsqPhYId2yr2ZpjNXTd3rHNA1pRqT2A8xlgC21eTp8j4OW61MHhDm8Glw
	 vZnyAD05Zg+LyRazFM6/PNhZXiVPtU/g0STcRZPeUgWat/pC1Q/4PLcZ0koEiQ7OYS
	 otN3wGnrTLkFcWz1fRNmHcO7pJw/KugCRF8623wWzWfoZ4RHsCfC9ghBv/ZMSvV11w
	 L1Bou7d4+8l5Q==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Jens Axboe <axboe@kernel.dk>, Miguel
 Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6?=
 =?utf-8?Q?rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, Trevor Gross
 <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, FUJITA Tomonori
 <fujita.tomonori@gmail.com>, Frederic Weisbecker <frederic@kernel.org>,
 Lyude Paul <lyude@redhat.com>, Thomas Gleixner <tglx@kernel.org>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>, John Stultz
 <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 linux-block@vger.kernel.org, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 05/79] block: rust: change `queue_rq` request type to
 `Owned`
In-Reply-To: <abfU_itQLa4jDy5L@google.com>
References: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org>
 <20260216-rnull-v6-19-rc5-send-v1-5-de9a7af4b469@kernel.org>
 <abfU_itQLa4jDy5L@google.com>
Date: Mon, 23 Mar 2026 13:08:08 +0100
Message-ID: <87ikamrbo7.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Queue-Id: 579B9140002
X-Rspamd-Server: rspam08
X-Stat-Signature: ptnjqc9x7s4qjc841g95qap6kczc5fwo
X-HE-Tag: 1774267703-547276
X-HE-Meta: U2FsdGVkX196vX1iSKv6ygnLnmUmrCN3GVgerA1EEFl+yx6Kb+Pi+wFVXULXWKiBTfgkILlgY0EpRNbBTXIcbZ6sUthm+vM1ZyiH7QVfgUkktXJTGiuZ2OX2Mku7T4Um3EzV4bRldudzsEAJbKhUGgKf9x7PH+wH1Dx1+7xNxV8dyI5KLe2pmHgAiddNmR/e3j3lBt4jG0pxWRMUuxQ4ojL1ctiEDQ02HiNPaS8y5lcFdHWEvlVlbiHwuVttHM5ToV0lm0KR6IAeroHi+87EH7dNJBQkqoZFeB/t039BeCEygNWT0Q+4MvLjKYtu6JceLHdMSotC1MhFOkUwCrFlNdkCBWLwrdEVNwF48b9GJ0PJiOt9RjqRvSGIPqpiQhayPZmL4SCvwuD/nE2493qlC/nHQV9ED9Paj2gb5DavU30Kef5shdugPSDIEQFmNgkye50tiYxN3HIQ6Cg6uJ5asH0awRSpJzVMxfyUznIUXhmMZBj6GWkfr0Ocb0xWfIC2Hok/CvvXuw2HwroEDLzg0V68OSKzsKSKWv8hH3xJAJlwd5dawdfVKEuyh/OvFcj3FmMyTwUpEpTgNRwyI/oy8moLb+eGchay8BEHzA7MCldeDXq3wtxZkyiio68BskhMsDGFHbz3psURS/f8WMtqljVctfQkmpWcOpZUMk88UVBtjq+RRpP327h19ryGMtx5+wqx6i+eBI2c3Wl7eQi0a0XKieMzb1z0jINUp90wrDJYJFKqx13UYVbRHgqwFWIQkTVu6Y/Oll6L9tla5INYh8O9R6h+QYYa0NUyvUzuq+YKOgyaUkk+AhibwG13h6VWB/542/5iy8dsHPo9DpXP3B7vkbaRrlY+wdRioGYWAvp2OLgsjSi1wCkY94uYsdofdjcLzHvjLAy6OaJYvqB4c9vEZzh9bgXR82n8NgUO2uBPiJTdr06E7NYsFLcfzx+hjXXwz+AQVnAdnWrWTD9
 9dg+qzK0
 j+/kTTUJoZGqvjWtXCWVaiAsK0yi7Gkbl+nJZhE+JRhUt1IY4q2GLtnxVBB7S+c4Gw1PdvWMXrbsOSFk/6sgXttIdDqS7BEfEnpUF7RV4CQhT0FDMWKxdEOiz7PCLpCI4dCvm/ffnjs+BVnc/XQGRr6xWPWJgEMpd/MLRRY6zuR8dFC6lL6K0luNsT4RzRThxNbq/iesqgJbwYXpgRgFshYRFXmsuWne8Mc9nx2hyJ575IA/otWL4D0TPU5NGcpSli29DHwqrcsVVhhiFnINP+EHyBKwGkTf6eNKCDRCe348ghoRf1Fr1PE4LuOtaCQJTlULK8b1nE5vV/jZ6W1erCaA48f2olB9KVSFR6nM2KV4hNSyisz+FGTOR2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Alice Ryhl <aliceryhl@google.com> writes:

> On Mon, Feb 16, 2026 at 12:34:52AM +0100, Andreas Hindborg wrote:
>> Simplify the reference counting scheme for `Request` from 4 states to 3
>> states. This is achieved by coalescing the zero state between block layer
>> owned and uniquely owned by driver.
>> 
>> Implement `Ownable` for `Request` and deliver `Request` to drivers as
>> `Owned<Request>`. In this process:
>> 
>>  - Move uniqueness assertions out of `rnull` as these are now guaranteed by
>>    the `Owned` type.
>>  - Move `start_unchecked`, `try_set_end` and `end_ok` from `Request` to
>>    `Owned<Request>`, relying on type invariant for uniqueness.
>> 
>> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
>
> It would be a lot cleaner if we could implement HrTimerPointer for
> Owned<Request> and entirely get rid of the refcount in request so we
> don't need ARef<Request> at all.
>
> Is there a reason we *need* ARef here?

There is. Real drivers will need to dma map the data buffers in
 `Request` to a device. This requires taking a reference on the pages to
 be mapped, which in turn requires taking a reference on the `Request`.

We could split up the reference counts into multiple fields, but that
would be less efficient.


Best regards,
Andreas Hindborg



