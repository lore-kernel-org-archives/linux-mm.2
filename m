Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AD5BF54AB0
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 13:27:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E598A6B0092; Tue, 24 Mar 2026 09:27:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E09B76B0095; Tue, 24 Mar 2026 09:27:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD23E6B0096; Tue, 24 Mar 2026 09:27:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B92486B0092
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:27:27 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 54E19BF756
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 13:27:27 +0000 (UTC)
X-FDA: 84581033334.24.20AA643
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf19.hostedemail.com (Postfix) with ESMTP id 492A31A000A
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 13:27:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dpYA9lL8;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf19.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774358845; a=rsa-sha256;
	cv=pass;
	b=dxfoWsPCEp+0GiMZsAfzchkqRMX4KIxa47YCWzk3/+zrvEh0aD1BAgTvZS2ipTKh6FGeGM
	aO4dIV9QUDbs6s3ZVS/b16yw4ap+SIxe3qBic503Oaqu5mo6pF9+JPdJ9xV8C6EmHV7Feu
	xI3MFQJadDQ4WI0skZXt/V5eu5vdf5U=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774358845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VAVyjs7BfIwZAVkKntYRgyhMAqaKjTB8tChCQpQIM34=;
	b=F0kcSJbEpTn6fMgk27sBParv8ccrXBgnkhfaj9Klgx1n8RGfFtOOlnh1h/f5dGAOkC5JDW
	qfxRIoGw4sda71mr2sdcVpxRHOoGVNRIn7gI92U1QDuGUt8/OKw/KYtvZoJd5ajOd1NWTT
	c1WLBFfW8w7jIyTGW1+2fXT8QTp9+qo=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dpYA9lL8;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf19.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-439c6fc2910so1010852f8f.0
        for <linux-mm@kvack.org>; Tue, 24 Mar 2026 06:27:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774358844; cv=none;
        d=google.com; s=arc-20240605;
        b=De7hepSaZv5r4xr07tq8QECj6YgZqA3pqn5zs+dcsmUF9px+abIgjAPb01Nma+hAA6
         IIcFVh5tLNe3xQXWfrsVsmIgkYAQFgF2th/0CZkZZYI1KjUa2NuerCk8aHSNUSJH2E8r
         4rY934RCJaK/u0uEnqJc9wQXH7bPFK5qPRtrZ2wuSpV3dvcFivLKu34eKRcB4TLUdib0
         kmXCdsi6b26AK1MCDH4w/JKEi72lBb5ekcdX8rXCiUp+DTXuTvwSaqRsnJZmSzacH1Vu
         Tf/KXfvfwEhe7tcuihkTSCf0PE/3SFuK/GzEZPkB6CjmlVueQq4D47YZWE10kwtFhvfh
         T04A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VAVyjs7BfIwZAVkKntYRgyhMAqaKjTB8tChCQpQIM34=;
        fh=9Gl+39/F4p9I1nLUf+DeJkCKcE2YzgLHhO5TPPz3UeA=;
        b=U2cJ505BItsEgx+hFKxy6SsP+Y/slxwhCutAF5XzWBBH/jB8PN1RYz3r+NUhZUbPtb
         hYNQ4iIelSZ0cJ1KgR1sQjo5derTLbohldLzTt8Pgx2zJVAaXUEmnpzYMe6/nCNRcKdD
         IaqbzR2J5IxftfBd5b730Dxc8pdiyxEz6LpWF9DinvO6BqGVnfQeFiXekuCbT2ZIedQt
         TIGjiYz6WznhWzbTuFZ6EVAJeRo+kq/v6BxTRPqVs6NqhxIiMnK7y+5khBxW0c00cTw7
         oz+WbFaIpdpATMT2eudLUrl5F4IQvS5Wklj80n7woOobFMyPGTUR6QyHcKt4S1Ss5FZ5
         ZUlg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774358844; x=1774963644; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VAVyjs7BfIwZAVkKntYRgyhMAqaKjTB8tChCQpQIM34=;
        b=dpYA9lL8fRvoKgMP1jSgqViF7ketG0EAUxt8UG48XJNDPQtVTQ5+XgrItOO8Pljh26
         uma+BZYWU/Tuu0HUsE8NViujEZqy0oMgxCmg4+xWZhwwap/K4oQj3w2feMGgY8yC/Lz1
         Yqz8OnppNRNsn4j+lT3YA+isgGRzqQtq05dRjduF0ETuqRq+ZqgpgkYaCWNTk1Faiqy/
         5mawBdKUaLFreItx87+iCAQwk9hYPT+Bpo7T9XJNMZXlRzJOerdt2Dq3JDeLSDZ0iUHg
         +yhoTWv5fLB9qK5n5uy2VHFqFma07wUHo0NaCCSqIr20Y31hNOqLTaUs+9xR35HXIW+9
         pEdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774358844; x=1774963644;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VAVyjs7BfIwZAVkKntYRgyhMAqaKjTB8tChCQpQIM34=;
        b=TzMZlK5RBuOEIbcnOzHQeB5rVgpaHnvErB1H7zu0BD9V2HM+lS6j2DbvTC7jXOIfxv
         wdM64AoTXh6spgRFM2aq03lM4U3Y6BeniIV/WaMuMNkFZhb1rptqgE/Xf21BJA8k3BlV
         jMLeZzZPYUfjriUdJZOkDb3sde21KrYAQjY5EvIiiGaTdergDpbHo9EQvunHoW5Py2WP
         l6ifLI66Le383B01pvTgomhbKwKNciBZgw8tW6p65KJdUYjlbEoMVWLNUduZopL6BRPm
         8fxHdYt2WBlErQKl5vTAYOkj4UfkF8u28TM04Hmj7FS9JROPX8SuPb3lZ7GTXziSaVrI
         /wNA==
X-Forwarded-Encrypted: i=1; AJvYcCUFegTPtW8Mrf96wjO0pnbeIUGYthm2TGa2EW8qppdSZLYr4XZZL9Ig1iNuQbSf5wF0iOYe/E3DWQ==@kvack.org
X-Gm-Message-State: AOJu0YxO6kaM/n3YKFqjMdSpTIlB0Pwv8KhnqKQ7gcruZrVLMvj3tEFj
	QjKdRVrwWzY2BTcuu0wITlH/Cs3CrB5g31KSMqd3c3XZLLP0r+pe+jV64wyBP90HW8FD4Opjs9m
	1TKy5DZHg4k4byCBsxGvGCO6DPqgWCFocj2N6XD6p
X-Gm-Gg: ATEYQzwGWEJ+e6jfGdzw1R+X62s1IdAvXFXCBSesJo4zBHlJ4AQ2pqyY8tbSCZH1Z6q
	bl0pcawSL71KEke4+bN21qIeeLeutZ4cpHuahzyA5HDNxafb6rwbV8KDW/flX5Mdqcf1B/ched5
	DXw8lURYYPzsmUdSRz5edLGeq4z6kjXP1tf55ojzHdkZr0uiGbqvMQEi8MIizohcAEi62IsmTFa
	QG9fnH6vW7A+SO55dpYQu7J2SSJ05EimGTWOPMqtGOEwSK1F6/OY7UWtlCm0BplHfAQQAOCARl0
	XOYoewZ2EnHtfE2oa82v9oyq+z5ceQhZsBuhanxp6FlpLZu3
X-Received: by 2002:a5d:5d82:0:b0:439:b3ff:9ab9 with SMTP id
 ffacd0b85a97d-43b642919b2mr25933211f8f.48.1774358843215; Tue, 24 Mar 2026
 06:27:23 -0700 (PDT)
MIME-Version: 1.0
References: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org>
 <20260216-rnull-v6-19-rc5-send-v1-5-de9a7af4b469@kernel.org>
 <abfU_itQLa4jDy5L@google.com> <87ikamrbo7.fsf@kernel.org>
In-Reply-To: <87ikamrbo7.fsf@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Tue, 24 Mar 2026 14:27:10 +0100
X-Gm-Features: AQROBzDq-YxIP2yXojVICe3lT7Gw23jBxgQOd3OOjRsR5pVnUNgTkbDxmHX_7ss
Message-ID: <CAH5fLggq-1pReNsRtgRfm0Y_PiQvUsXbMMkPkyO9kuhqzB3wrA@mail.gmail.com>
Subject: Re: [PATCH 05/79] block: rust: change `queue_rq` request type to `Owned`
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>, Jens Axboe <axboe@kernel.dk>, 
	Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, FUJITA Tomonori <fujita.tomonori@gmail.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Lyude Paul <lyude@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Anna-Maria Behnsen <anna-maria@linutronix.de>, 
	John Stultz <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	linux-block@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 492A31A000A
X-Stat-Signature: wn595zk14j6xe9p679gyg7wmhfoxgan7
X-HE-Tag: 1774358845-633314
X-HE-Meta: U2FsdGVkX1/YcbE9nEtDdTjdvMBQ2T2IU6o4nQlAG1Bfuu3f6447xuyKJleavBsAr7TXNN+Ye4f8o5BqRUiaxMt79h03pmX2XkuteNE7HJ5o3KXdAyOGFR+IM/eNH68qADxu/PklM7hTqv2VotAW+blPqyc1giSH5K7k88Sr2miRraIIR0HXi67bLhzpeggyUd+khTZf0BVavgYG1E0irXO+MrIEtA7kYCkDVG41x2aq66MqBlfZq/f07LZt02pgx4H3Qj4u2FKia2mJrEjMFyaHelutc6Pp45sF2S3N2GSVo2NeNacSJ5pPHMSEQt2j4obGS/KSFZDuayD5skuFf1T/MloC9UEydEpAEaXH1ne883Z7HH9I9lgr5QaPMfGXfETfyZiZ/b4lXnm2s+emU3fGTqSNo8SZ9w/FFE2sQJH1PjyRlGihKNvU//kQbxHc+wcvOQ4MoEnmUvC/wvmxFL79CRnBI4bznrOfzsgyAV3ZHk/rWb0boEyLtkPgNdfbpo7Or64d0rR0yDVo8AbDYij98VZjk7EAeT5qCT6Dk5lw2BCQv9PGhtceaTDH7t4BN7P0IGQb6qT8/0JejASjVaOFfVZBPwLnK2T4s25IrBWFagxYHart+5QLm8mVbFRviTjYM/Voj+swzvJb1rnczzmDfJpedPwGjO1CxmQGQuPcxw+GyyHztejmfJ90qGpt+u658udHQDoHhgLO/NDyA02zrm34ZCHzc3lsSvzmijHO0RxoLcqRSmUKJfhZ3DVIKIlNFp1/BKTOjltm//2lFDj6purFuK1mzZh020rneiAyrNG2pauMI4DYZylQTokkD51pT1arXi9rsF7TrB+J8pKtWc8qDDbEYPfjE3wbbkNfMoxqhtFYiEOL4dVyX+fqaYSauK3ed0sg/LAR7f3uvZge1oGuDDqMh/LMgvAspESK6eTi96G8jZrLsa2Np5gznol0ssxgQKbkdPR6ahd
 4tBRbf69
 vQPkPWE2DsuQT+lU6ZOe8iEJCmjf+ukw5+bSLHPCLM4ip4DixWflcRa7XSR6jyIqFkICf8nmXDF4sVYwnDXBUQB2eoRDHZxi42szQWD2yyWWD7ylkKOBTMieJMkfafl5dNSkfiV1ciIXwOCJjaaihenmZIugNAJrBXTnIgOc5sTJ5BntgK5VckSAXUbJ+5mF4nXQ+KOKI1Yg5mJEAKtWIkHBwd3BINc4hnBtsDqJvoj73Yhka0posyLU1x0ZGKiForYKNVZhzeJi/gKz91VKe/GmRbjQdf0LlVU//yAHl/XYhm8wSgM9FqkH/nBA/8dCA8qJuwEANYZZHcBZOUtpgiJVc5S04Qwg87ZYOznmMHXxkodXKU1iHn0Y1XLb9m0L7YPK0num8C3vrEtPd+CZzyb+Wgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 1:08=E2=80=AFPM Andreas Hindborg <a.hindborg@kernel=
.org> wrote:
>
> Alice Ryhl <aliceryhl@google.com> writes:
>
> > On Mon, Feb 16, 2026 at 12:34:52AM +0100, Andreas Hindborg wrote:
> >> Simplify the reference counting scheme for `Request` from 4 states to =
3
> >> states. This is achieved by coalescing the zero state between block la=
yer
> >> owned and uniquely owned by driver.
> >>
> >> Implement `Ownable` for `Request` and deliver `Request` to drivers as
> >> `Owned<Request>`. In this process:
> >>
> >>  - Move uniqueness assertions out of `rnull` as these are now guarante=
ed by
> >>    the `Owned` type.
> >>  - Move `start_unchecked`, `try_set_end` and `end_ok` from `Request` t=
o
> >>    `Owned<Request>`, relying on type invariant for uniqueness.
> >>
> >> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
> >
> > It would be a lot cleaner if we could implement HrTimerPointer for
> > Owned<Request> and entirely get rid of the refcount in request so we
> > don't need ARef<Request> at all.
> >
> > Is there a reason we *need* ARef here?
>
> There is. Real drivers will need to dma map the data buffers in
>  `Request` to a device. This requires taking a reference on the pages to
>  be mapped, which in turn requires taking a reference on the `Request`.
>
> We could split up the reference counts into multiple fields, but that
> would be less efficient.

So how exactly is the refcount used here? Can you elaborate?

With regards to the Owned series, I still think we should split it up
so that the patches making ARef+Owned work like Arc/UniqueArc is
separate follow-up series.

Alice

