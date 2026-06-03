Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 627E6CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 12:09:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCF516B008C; Wed,  3 Jun 2026 08:09:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA6516B0092; Wed,  3 Jun 2026 08:09:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE3DE6B0095; Wed,  3 Jun 2026 08:09:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B27D26B008C
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:09:34 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 67AC41C093E
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:09:34 +0000 (UTC)
X-FDA: 84838481868.26.75F9E00
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id B560040004
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:09:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gSN1iWB2;
	spf=pass (imf12.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780488572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/AVS8+IasBd+d0ZAz5wyS8dLMDp95xsMmOPLp6VieFI=;
	b=6CH5xD5uteZxED/pJXbeo2hI+lKSyQ1Ng1rkvc0WNRfYRs40EowGEhHygmGoI9n2kJFJh6
	YWx90EHknCTHAze0/6/xdus0iZVy3FH/DPXXey8nvWMqFwsNyWWQyiTYxZaDS6C5v5+OeI
	5jzD2hZcR1G+uZvAiALxa6clnx/pbuA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780488572;
	b=MyLvpd6PO+0REe5uZshg8WEZy+EF7sTLPCLw8rft5X3WBzvbFaqJWjpJ0g6RMAY84DWZeB
	pJ+4S/tHYtlM6t3TsksYewZi+An7f0pLDXfD+CEe8+a8twE4ol43phyusOh9qTFNb75a4j
	2c7/jsVzFgq1af0Lo/EuQWh5ryT+QsQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gSN1iWB2;
	spf=pass (imf12.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D670D41AEB;
	Wed,  3 Jun 2026 12:09:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3CC91F00893;
	Wed,  3 Jun 2026 12:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780488571;
	bh=/AVS8+IasBd+d0ZAz5wyS8dLMDp95xsMmOPLp6VieFI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=gSN1iWB2z2uYsbqLT/cA9xdLVkwZDaF6xhL+8a7opfqs+UP7pcl4tUR+kR3i1la7A
	 8dSDZXr1G438gduJPHbO5dX+kXxjyD1gLAfc3AbCfXrOxfRZxURXuLrP+4b95Bka54
	 j0SvIt89mU+J0w3NE1DkLJ/IIQR5gHAyGJtnUB2o8R+WCEGQ9i9BFzeUfpchTQrugt
	 8luds82brSLd7Upq+m2oNVLaBZvSfOw0Vp/NBElO4bs30bQkIso5teC2+XYiRi9TAG
	 Mi3xRTu9QvykmaVbKbDgIvAOWzRmnSVu713FkoqRfGQw8/DqW7G+z3Y47lEoTLlfOq
	 MzmxFal8Owc2A==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>, Boqun Feng <boqun.feng@gmail.com>,
 Jens Axboe <axboe@kernel.dk>, Miguel Ojeda <ojeda@kernel.org>, Gary Guo
 <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno
 Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>, Danilo
 Krummrich <dakr@kernel.org>, FUJITA Tomonori <fujita.tomonori@gmail.com>,
 Frederic Weisbecker <frederic@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Thomas Gleixner <tglx@kernel.org>, Anna-Maria Behnsen
 <anna-maria@linutronix.de>, John Stultz <jstultz@google.com>, Stephen Boyd
 <sboyd@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R.
 Howlett" <Liam.Howlett@oracle.com>, linux-block@vger.kernel.org,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH 15/79] block: rnull: add `use_per_node_hctx` config option
In-Reply-To: <CANiq72n5+JadJUW-GO0cwQrq9eJW7cB3ZK7zx4J484RzjxmYEA@mail.gmail.com>
References: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org>
 <20260216-rnull-v6-19-rc5-send-v1-15-de9a7af4b469@kernel.org>
 <Y7WTRL6v0WsR-DWju2vumM1EBu4KZgQzE0VJul7mK3pUwD6ba0UuQO8sclDzOaeLGGh9u3WG5iSKq9T3kQqH-Q==@protonmail.internalid>
 <abfe2LbhLzXiGCkA@google.com>
 <87cy13swpw.fsf@t14s.mail-host-address-is-not-set>
 <CANiq72n5+JadJUW-GO0cwQrq9eJW7cB3ZK7zx4J484RzjxmYEA@mail.gmail.com>
Date: Wed, 03 Jun 2026 14:09:11 +0200
Message-ID: <87h5njkeqg.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B560040004
X-Stat-Signature: ej9y6a9w5osee1rz7w9m9jqwjj9h6wub
X-HE-Tag: 1780488572-206548
X-HE-Meta: U2FsdGVkX19pcIb4SH73j9fLedO5XAygPyBuZhQPAoP5N/jR8vzyhnF7ptEbffQ+tHQGQys2TR4iwxb25iis/sTgsjZrd8gA1D+HpsSXfqnR3CjYNdZXNL/GFif9JPqFe2+1237CsMpJhB0FaGlwP6R4yUhmVHlV4VBFdjx1flSrSbRhijdHS4oveKlM9pDTg4Do7maqGxFStTeHsVF15irek9HAHa7lugEQI/ZTN2Mg48GfdS4K8Ab5ph9+Ab/aD3tEkeO230DTvV3/3xt/6MgACiVPGhS363eEOP6PHVspNfYCl+h1MfCx3VLe2IzSOUsv5PDapbwJ7i5pqFHYEwyCfo9pCZPTvqR3TnspgHzo5Ti3ZGHxKLX9aOhvwvKvlda/xCDGKwZERfBCoWxBT1utR2HuU8JAOE1ZDdzS5gfUalntns4uqHmq0OQ8933KIMwCZU4VW0jWCKBhIt3RW485/3C4/1p98eNwii1GcDRABUZ1zbrgcm29qcaJHhPC4Gq84BvQo4m6S1DlfPPt6vstOyn8exq+DosHbGGyzMOz9IilIwTU8w5NDA/3IeclblVTH93ay2gA0Lub/IlBPW1YbDD3O/u3apLqe3rx4dCRCqLadDtcUpOyf6aAAMoktEnM8dlm0YzyxwMdra9nRq3ducM+sC4vcrymmPo0/QtQ4CrzCAVUkCnI7WXnHQYdghXEt5/vgGwI4XLloPRMWb4PvqfdyWV7yjv28izUpqg+yKWqPKU+tcZ8Z2kGyNCWeCbbGbC60FiAhd4+1BRpXlHtHNSewuWIqMtkSUnmBgPoa6F8hWSb3e8j4t6rprZc3RRI4IW13oWUQI4TA1GsvKa6veQ5JnFG7g/GlE38MJZOhh/BhzhqIxoHxc9zAZ2CwpcZ4Fml1ThSjzcl66tlIUlSM5ScNil578L4fRQsXkdeUJzTZvvPnpZ3QkA/WAZiyUQg8VUFW3C0iKNN38N
 19O95JsR
 8DYrOSDFk6m7WW2na611jxHOfDGP4eqrWW9vdBBKJA4Zgt+iSu1K6H+gC9U8EUz24yuWLljwXclmc/D1r1G+Gs1R0rnBwfsQMGPg+9FDkIO5qn21LsZ6kOxcMCMy+zYZIz7hFe0gN0vVxv8pHrKdtPDDkayAkrNMl5eiy4tiMQSfSu6nBrg6A8lORvs2mJXZt5Nxx9A13bFtX9oj95AUD8yxszW4Nd1aOY7m/ob28tI5cLxSr9VdWU+KOCvy33sLinegYDw11oMicngtfl/Z4X52DklvPnxQ0KsgbSVgbAYQFzKnHRpDho1kJEnkiByZkek8G/0wKr2Lbsui7sDzysxFxtg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Miguel Ojeda <miguel.ojeda.sandonis@gmail.com> writes:

> On Mon, Mar 16, 2026 at 2:58=E2=80=AFPM Andreas Hindborg <a.hindborg@kern=
el.org> wrote:
>>
>> This is intentional. The line gets too long if I pull it up, and I don't
>
> Do you mean you don't want to go over the limit or, otherwise, that
> something else complains?
>
> i.e. the limit is not a hard requirement -- exceptions can be made
> where reasonable (as long as `rustfmt` is clean), and moving the line
> to an odd position doesn't sound worth it.

Yes, checkpatch was complaining. I'll keep the long line then.

Best regards,
Andreas Hindborg




