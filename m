Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17931C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 13:45:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01FF66B00A1; Tue,  7 Jul 2026 09:45:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F39396B00A2; Tue,  7 Jul 2026 09:45:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4EE06B00A3; Tue,  7 Jul 2026 09:45:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BF0FC6B00A1
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:45:23 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 15B2CC28D1
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:45:23 +0000 (UTC)
X-FDA: 84962102526.10.08931BF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7B0FFA0014
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:45:21 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D4MiNEMJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783431921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5dBcpWRkjDihs/b/BMTjKD0Em+iYR5MGgaj1yp5+iB4=;
	b=lpnv1AJLlz5bBukNumuoLJDGb8Cck2hfq7VAgJvgFQSxEtg5qhtRILkXeRJ4Mmrdaa6SzX
	ItG4L2cI5l8Nl+mhZvMZnpPlBz5MqgUrB8iUwcwVO49cAsiuRSGMtyCT1kysjrC+cuIh92
	owWLFbl1x/a5sm6pk3Z4sAnsO23UYHo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D4MiNEMJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783431921;
	b=6f3Hmd/xm7vjfvUp4rs3Y1UwbKNJRWyyHlHmBJQT0qCepM9OE74gBQ/Bkn+cfNM0QJzFni
	gaGfrOnAA51vGq5Qr82KV82x7LsigY9VlprT1dK+7ZrxWETtCYHpslXGYDd9HNoUuDAu03
	4ztoRx/hT7ug0ox6oMSmpj3Mt/WRCuU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 10878618BE;
	Tue,  7 Jul 2026 13:45:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D9C81F00A3A;
	Tue,  7 Jul 2026 13:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783431920;
	bh=5dBcpWRkjDihs/b/BMTjKD0Em+iYR5MGgaj1yp5+iB4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=D4MiNEMJNcTmxqDlMZCoH62oCY3cYVFlHkMoBqrh5hHiW+Dkz1tQ86/trc39HBApB
	 X8eTLZMbpulAs2C3Qi7h2HOUF8ZlG4WoS6laW5KEDFs5hksV4FvB1SM9Mb/hU0J1jN
	 cnd6ToDcIboBP6ZkVct206hvBMTDII/mesleY4CAYoajJA59MBq5B2HQGdh8OBRGCH
	 Cz1/BrGJS2BL+j9VOyArVQM+I36I7wJyh/jQfdHw9WjuPhudL3PsbjSJWAbR6TTlOo
	 mJe+J5t41xG4qgLkjJR9YkpnmJMS1R/P7Ou2LFGJ7HLqAt2ngKfOajl46FCG54bY59
	 I0j6afhX/vIoA==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: =?utf-8?B?7ZWY7Iq57KKF?= <engineer.jjhama@gmail.com>
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
 linux-mm@kvack.org, rust-for-linux@vger.kernel.org
Subject: Re: [PATCH v2 10/83] block: rust: allow `hrtimer::Timer` in
 `RequestData`
In-Reply-To: <CAGAB667mVuECQDwYDij5PcZ-fvqr-6womuRCHibrwiR_wP=YDg@mail.gmail.com>
References: <20260609-rnull-v6-19-rc5-send-v2-0-82c7404542e2@kernel.org>
 <20260609-rnull-v6-19-rc5-send-v2-10-82c7404542e2@kernel.org>
 <CAGAB667mVuECQDwYDij5PcZ-fvqr-6womuRCHibrwiR_wP=YDg@mail.gmail.com>
Date: Tue, 07 Jul 2026 15:45:06 +0200
Message-ID: <87v7aqhq1p.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7B0FFA0014
X-Stat-Signature: coawc7j5zhmgjtppjrd7cs7g4cchae47
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783431921-111408
X-HE-Meta: U2FsdGVkX18WAshHocMuMasEHsPBLm6Sr/xWMcqH9eX130iezMz9y/nRy+Q/Tys/BcqD7s8LH6qTNhPy6bMtYhlgHHED155SQ3gq3kVPBo1mGeuE247jr06ytZ9qcttSczqWtYySa6hbpETrmuVS/jiovkazwA//MdtqbYovrfBd2dxnFvaJNMmet3s1j/cCUQUYINewjfZYDJU4OFoOni97egbI59Eyrxh3LBf8UF6PcH/lHyp0XBOPDlbJZMX/aBoTG51ExWtkz2Jw9zPBNOeX8MEE9YY9+Sh+wn5EeG3s8vG90mvZwfV+SB1imnmPCGLBxyXgXGKlxUqs9A381J2dRSPlQgeyhuoZ2iTWjGW2MVvOH65fn0fc/Y/6BPhMxjffnByQYSJcWPaWH3jJKYUyI1ZPKVVDeIv/PdF7KF65b20HGLUvQskeV8p1F3DwVeLZIn41/5hTMNFmL9xmHEamtN+A2yrXiqZ/wYs2kr6pyQqf+EluWz4qfxqw75ZALllP2I1+7DWtcWHp07TAdGRk/F2lq/9TDHURMa3i55st209rgo4ehAfno6TcuIAH/oWPowlJt/ghXUoVYmGhttoT/oarII0JjkSxx8C4NcSlBE7KS1A+tZTl1QhpKnVK12ShZCX9GEzEQC9pQxWCm8WHKT70cOpbiD/JR4hWh2YpmuykWbuHbsnPtwEAhi3Sm26k5vpvRUf9EVj9upzXrvAjEfPl92tRm62itZT5l8GwerzLmV4N2nj6My2u7Qw7Re8exRZ7WZIAr9b4OA2r6yBmSRoMzzdwSMtxeYBp+ecpul2+iXfao5Sg6BJcNdbN/xwYj/oIGWbzfedg/CddOqJvse5HdMc/gGYWyuEN70cFsiNBLmi8ufEc2RuqlNZgrigpbQp6hDY0rG2Z0XYuywwuzqo28gCzqPzFo52meV0nUD+bnUtqxemaTzaWM9duv/XFwbDblvGJD0a4xbk
 gkalaSxA
 QWzBO8oMZuYvWV41F+MatdiL3zmsoKXpIhAsqn4OYi3vb3yXvSAZ2eQTRCl7VLyqUyFUdaWlQbt/fQj5ieIT4oAwpY8WfzsOSTyRpQ9KpXxadEh7dZJfVvPvKLh+2kFaFYMT8tfYQ96P2KzQ0+rWYzzWtNov1FAME1GlqKVry0Vu9zXR4Hw8+AikAEy23DKR4x4SMnd89DHyn2XLAv9mlzXRpXGCyGxXnbBCTQKGrTwIK7D7xwvxMMEWMz7kXTQyVf0Jfgdnzjn0hOgUNqb8SDlXgHmDVZKHDPneuv1HKduiEobpG7lCSmqDtvPMMvGmLIKMzE0Y1A7+ogYkLEoW6EJ/g1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

=ED=95=98=EC=8A=B9=EC=A2=85 <engineer.jjhama@gmail.com> writes:

> 2026=EB=85=84 6=EC=9B=94 10=EC=9D=BC (=EC=88=98) =EC=98=A4=EC=A0=84 4:23,=
 Andreas Hindborg <a.hindborg@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=
=B1:
>
>> +    fn cancel(&mut self) -> bool {
>> +        let request_data_ptr =3D &self.inner.wrapper_ref().data as *con=
st T::RequestData;
>
> I think this trips clippy::ref_as_ptr, which is enabled in the top-level
> Makefile (-Wclippy::ref_as_ptr), so `make CLIPPY=3D1` fails here under
> CONFIG_RUST_WERROR. IMO core::ptr::from_ref() would read better.

Thanks. I'm not sure why I did not see clippy complaining. I agree
`ptr::from_ref` is a better choice.

>
>> +        let pdu_ptr =3D self.data_ref() as *const T::RequestData;
>
> Same here, I'd go with:
>
>     let pdu_ptr =3D core::ptr::from_ref(self.data_ref());
>
> I applied both changes on top of rnull-v7.1-rc2 and `make CLIPPY=3D1` pas=
ses
> cleanly here (the two ref_as_ptr errors go away, no new warnings).

I'll add this in next version.

>
> Best regards,
> SeungJong Ha
>
> ---
> I'm not a regular reviewer for this subsystem =E2=80=94 I just ran into t=
his while
> building your rnull tree with clippy. Let me know if drive-by notes like =
this
> aren't the right fit here.

I appreciate the comments, please do continue sending them if you come
across more stuff.

Best regards,
Andreas


