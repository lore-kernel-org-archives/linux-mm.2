Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E67F7CD98C7
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 09:00:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E2356B0005; Wed, 10 Jun 2026 05:00:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BADE6B0088; Wed, 10 Jun 2026 05:00:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F11FD6B008A; Wed, 10 Jun 2026 05:00:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DF01B6B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 05:00:53 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 89FFB1A090C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 09:00:53 +0000 (UTC)
X-FDA: 84863407986.18.E0D5C03
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id EA285C001A
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 09:00:51 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oOrtrCec;
	spf=pass (imf22.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781082051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tiOydzZ3dGouBDJ5gNoI3WoKFWG5GSSkN9FaLALzY1E=;
	b=FlZqzmSVxcWuun4eCgezFqii1VosOawmKjoV23G/Dz0pB53vQlyeLBiztdMqtqtbdG2Jkc
	2wvQbwk/fZUfNh6NqiBI3EG9qSLLTpWwkQWMuDjqsVOdg095bBR/uLwqxmZgUaTJA9wGXt
	1PzFN4Tj/6oe0+O9Yu/xLx+MaKAYluU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oOrtrCec;
	spf=pass (imf22.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781082051;
	b=yCDCXjFR3fRG8V+HxIcPYTLgtntm2TitmRyQmP0TTmIsYy95xjYwH/N/WAGPSGWEz/jcEg
	8Ey95fsfEIZrAR0ECDcwNst/pq5qiPPQCnfrsKUNM/+GXrJC3LFA1QXflKH8lO7LshW3Lw
	he4NDyYJYHMmNuNeTpZ9ZS7iYP1mCms=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 66D966001A;
	Wed, 10 Jun 2026 09:00:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93AD31F00893;
	Wed, 10 Jun 2026 09:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781082051;
	bh=tiOydzZ3dGouBDJ5gNoI3WoKFWG5GSSkN9FaLALzY1E=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=oOrtrCecZ1/1S/jm0lzpOyrLHHWmGV4pfQC7Asj81mRDFXy48a1f/rBtiLJk4WPpf
	 g1eCPvVJ9DJMgC7WFpzHOeA2uvz415UEJiQY/rHi8pUm/RJBeRn8RMecGR8g1bO3yV
	 eZwyZG92FRvD5X9r14yhr/SW6IyBBuG1E4GVPX2qrQfmK71uP0Jt9lTBtxRH6d53Ec
	 P3+5gT1ya6f3i9Pu5Ulyi+19+wTV6bcQ9T+MwU+q/e4RqONNVDrYDXE0d3rzQtiwfp
	 BsTM8LTK0r0d28/qEvIE6Zv1naanu9TWae+dpRiwVSeeO1qHpQXxcLPIreviq1Jw0N
	 FZ4oyEYIrEzmg==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Yuan Tan <ytan089@ucr.edu>
Cc: "Liam R. Howlett" <liam@infradead.org>, Alice Ryhl
 <aliceryhl@google.com>, Anna-Maria Behnsen <anna-maria@linutronix.de>,
 Benno Lossin <lossin@kernel.org>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Boqun Feng <boqun@kernel.org>, Danilo
 Krummrich <dakr@kernel.org>, FUJITA Tomonori <fujita.tomonori@gmail.com>,
 Frederic Weisbecker <frederic@kernel.org>, Gary Guo <gary@garyguo.net>,
 Jens Axboe <axboe@kernel.dk>, John Stultz <jstultz@google.com>, Lorenzo
 Stoakes <ljs@kernel.org>, Lyude Paul <lyude@redhat.com>, Miguel Ojeda
 <ojeda@kernel.org>, Stephen Boyd <sboyd@kernel.org>, Thomas Gleixner
 <tglx@kernel.org>, Trevor Gross <tmgross@umich.edu>,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, rust-for-linux@vger.kernel.org, Priya Bala Govindasamy
 <pgovind2@uci.edu>, Dylan Zueck <dzueck@uci.edu>, Yuan Tan
 <ytan089@ucr.edu>
Subject: Re: [PATCH v2 01/83] block: rust: fix `Send` bound for `GenDisk`
In-Reply-To: <CABrc2FU9HuRp4tVEU_R1RdMMRkkS=tM4Uv70WG3UBTeho_C42Q@mail.gmail.com>
References: <20260609-rnull-v6-19-rc5-send-v2-0-82c7404542e2@kernel.org>
 <20260609-rnull-v6-19-rc5-send-v2-1-82c7404542e2@kernel.org>
 <CABrc2FU9HuRp4tVEU_R1RdMMRkkS=tM4Uv70WG3UBTeho_C42Q@mail.gmail.com>
Date: Wed, 10 Jun 2026 11:00:37 +0200
Message-ID: <877bo6hiru.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: EA285C001A
X-Stat-Signature: t3jkc5qcpqd6ysyk4qjfg9z78xn3pb14
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781082051-821497
X-HE-Meta: U2FsdGVkX18uFQbv5x5QY182wnJZk86j8LscyqqxXWOdNt9BS18IhVI/hNLcpYagXFm86WSuGCQxFnIY8uJgGKnLL6vfF4h3BoV4iOYc6zPBs/AYLYGv4p7gQnBKu1HFQ9FlxGagA6t8jN7IuBTm+sCfEpxTNq31wGUM1+iz6HSHgTxUsHjKpqBGPXjLvsxrIoQK7g/QP+nNosyhs/xDQJKrm1mkWO1vk6sxZxZgipKZTvzPWMsYtjm1t0+GmsBbXUH/hv07o36H2q9vqZ1zg13F1ZvGHp+unEw7vmg84rAHop1oFFdamwd+XVTzMlCb7qj09MZs456bxosb19UpcOK2dsDX/4kNx2gtznD/1XE6DlNX4YAHVwEnODZ3N0z1ZhwJbsDiAwt5agjE79PNDweUmp+f/IbsDIxS69QMVciUk49mNdBxGyFy1dMgR7N5jw0GrZj8d5iSsZ6myo3GLkCkP1/lxe6YhSZPhEXNxFsMKF5IyjTJJsB5VG5hCZRUzPbbY93jwihnRdKLo3cF4qRoI+GkkSO5uC35K0yxtjGdnRwpDfo3OtLrA/NzAoYqMJ/NBnKv54kDdqwakUUNMs+uF+WA6UZYfjD5V1O+fiTiwKhoHgy5D3y7EM/hzHAKPwDjo2t/MtwzN9wwicEsoZjyCc4byl0kUxxKB3cqmKljgg4/JBX5OtyQJUeD9Tkfgxvb6zc4qwMnANge5sGdJpIifygsk3ON21/luPXjaL7qA8zZSySABppr07qxL7dCCkUx93ueNuCCuFP+a9cJUhPu+bmjvgrJ2ZXTAmdtdIT2sQFcllvMnGWRp6/kJMHcTmGAhJzjwEee22tPOTj+JccTuxv4eisYdBmw/lLn5LcjZYX+AdQrxzMy4Qtj3uzz6tWa7OaIF8gOe2P5lZwpT70zIyUX/qSna4XJiH4/fEk6FV5selmvQU74p3qPKoT6zESzwXCeq3WvtnspKfG
 76zS0MGQ
 ML1MrOD/lJzDsAhJpSmI2LFx6CHXGOWwg3WrxZy83QWK3fsY/Wjy9+3SrB1HQu5gkKvVt41119tWUFdP1PjlWv4wSSQr9edr84KMf8PnFQaRdwcLnpU4i+O45+baqQyp/pic0Jb3AF2gDFOdKroTrSWNvCDBhCVusfN4LJUSysTxYBZ9wguoIZ9BJUh2ALbCG5kOJMkQCjKyT8hNHLA+ukXdAaJUMtZPSphl5exTSj6dPLhUEW/Se52cKCeGYr+6Tghj3YwXhuAFggg7zT16GYz+jBN/o4jBz2jQrzftznMMjmpoPnrX5XpIEtUK3cldW5foZEXEoDevqFhF/XzvlpYYjW6I7erDU2qJV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Yuan Tan <ytan089@ucr.edu> writes:

> On Tue, Jun 9, 2026 at 12:13=E2=80=AFPM Andreas Hindborg <a.hindborg@kern=
el.org> wrote:
>>
>> The `Send` implementation for `GenDisk<T>` was conditioned on `T: Send`.
>> This constrains the wrong type. `T` is the `Operations` implementation,
>> which is typically a zero-sized marker type that carries no data, so `T:
>> Send` says nothing about whether the data a `GenDisk` actually owns can =
be
>> moved to another thread.
>>
>> A `GenDisk<T>` owns the queue data `T::QueueData` (stored as the
>> `gendisk`'s `queuedata` and dropped when the `GenDisk` is dropped) and an
>> `Arc<TagSet<T>>`. These are the values transferred when a `GenDisk` is s=
ent
>> across a thread boundary, so the `Send` bound must constrain exactly the=
m.
>> Bound `T::QueueData: Send` and `Arc<TagSet<T>>: Send` instead.
>>
>> Fixes: 3253aba3408a ("rust: block: introduce `kernel::block::mq` module")
>> Suggested-by: Yuan Tan <ytan089@ucr.edu>
>> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
>> ---
>>
>> Please take patch from Yuan instead of this one, if they send a fixed
>> version [1].
>>
>> [1] https://lore.kernel.org/r/8839ddc5ff54bf454d508cde91d27d00fc3e2dd8.1=
780633578.git.ytan089@ucr.edu
>
> My last email mistakenly enabled html. So I am here to resend it. Hope
> it doesn't disturb anyone.
>
> Sorry, I've been busy with other things and haven't had the chance to
> send the fixed version.
>
> Thank you very much for reviewing the patch and for preparing the v2 vers=
ion.
>
> Could you please add the following when applying this patch?
> Reported-by: Priya Bala Govindasamy <pgovind2@uci.edu>
> Reported-by: Dylan Zueck <dzueck@uci.edu>
>
> I didn't discover this issue myself. I just helped write the patch and
> I don't want them to lose their credit for it.
>
> Please let me know if you would prefer that I send a v3 instead.

I would absolutely encourage you to send a v3 so we can pick that one.

Your emails are not arriving in my inbox though. I only see this one on
the list. Please check your setup for outgoing email.

Best regards,
Andreas Hindborg



