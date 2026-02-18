Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B59DE9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 12:33:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEBA26B0088; Wed, 18 Feb 2026 07:33:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A99956B0089; Wed, 18 Feb 2026 07:33:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CF6A6B008A; Wed, 18 Feb 2026 07:33:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8B20B6B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 07:33:52 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DBEB414011F
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 12:33:51 +0000 (UTC)
X-FDA: 84457519062.16.18B4FE4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3F99320007
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 12:33:50 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="dW/i8orC";
	spf=pass (imf03.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771418030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tPRTH5D/YtLHQRbJV//XCuFvKTE73aRX+m2Us19zizE=;
	b=rpacVhphbmTHq4QI9czpPjvDeLM828RH34bgCRE1EOJs6vK3DfHaFbgLYnAZUq7MGvV9Fg
	jMAKEO5IUFBDeWy3Ck+FHRVEUFTbePKMKkCDhKWvrjeNlVWeX/xaEksUY9IEJUQhKZWRQo
	q8+S5q8fTXqmK/JAvzI3pqDnC89Wi1E=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="dW/i8orC";
	spf=pass (imf03.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771418030; a=rsa-sha256;
	cv=none;
	b=brROBUDJ2aRsSU7gyj0evbosvY2Ttfc3RfUO9f/eUkui+Xcl+HD4m+bJIxknlLc8YkIuu5
	7JvZtxM3RzohrqSDC6Tsn8cAT319Q30SjiRwsD1+/TJ5/WZbt/f56GhbZWk5P+wVgE65Lf
	1Tw/Oc23TlbS2nvXQmfhmGJNAyfvXv8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 15C99441FE;
	Wed, 18 Feb 2026 12:33:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB5EC19421;
	Wed, 18 Feb 2026 12:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771418028;
	bh=tPRTH5D/YtLHQRbJV//XCuFvKTE73aRX+m2Us19zizE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=dW/i8orC81AsU4bNVV5MeaYMzqX8sW/RQ/Nd21nyFtqx5GQzupMt6/ibvEQFTk3Wt
	 54LQ42QAS6mkEkVk703xT3dWEhgEoHbXxC8WLzlbdAWzrPkkMfmZwLeuKt/4sTfisb
	 XrSOAVwW7qXnHEf5z8uKTkAIXEd30JCoPOWdU2iqBqAmKbf42j8le2TUbY0/HJyNrf
	 Lsk9iRVf/smIFK4rYZMiueOBzaVCP8f747vbYXBQo8doBajY9Ai/yClmRzQRkURRqB
	 t1Junhh1cQZMLlpORdxKmAVABQUpRqzm5oaTCGyePlbefCupbmrn7C+zJHEoWbe4l8
	 kF7ugQHz6fh2g==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Alice Ryhl
 <aliceryhl@google.com>
Cc: Benno Lossin <lossin@kernel.org>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam
 R. Howlett" <Liam.Howlett@oracle.com>, Miguel Ojeda <ojeda@kernel.org>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn?= Roy
 Baron <bjorn3_gh@protonmail.com>, Trevor Gross <tmgross@umich.edu>, Danilo
 Krummrich <dakr@kernel.org>, Will Deacon <will@kernel.org>, Peter Zijlstra
 <peterz@infradead.org>, Mark Rutland <mark.rutland@arm.com>,
 linux-mm@kvack.org, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] rust: page: add byte-wise atomic memory copy methods
In-Reply-To: <CANiq72nCmZ57VmXsXdXbP9edmWYqOWCYgWNTPGKvxC30sy94KQ@mail.gmail.com>
References: <20260213-page-volatile-io-v3-1-d60487b04d40@kernel.org>
 <CANiq72=5r2miRm6GWszb2gDNi4k5-RZUzvdOdFQ3yyndvmHbAA@mail.gmail.com>
 <CAH5fLgi6NVagOPA_=r7Dmk9MFXrvZVuq85D9bsJfUqLNOZjCaA@mail.gmail.com>
 <M50jfg_TPSF2G6kHFKHc8zxjC5DT3HtgXhWFeXdZxPwnsMnjr-B9ieBi-pZAXpPcInhZ21cxtYYvSciNJRS3Vw==@protonmail.internalid>
 <CANiq72nCmZ57VmXsXdXbP9edmWYqOWCYgWNTPGKvxC30sy94KQ@mail.gmail.com>
Date: Wed, 18 Feb 2026 13:33:37 +0100
Message-ID: <87seayb59a.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3F99320007
X-Stat-Signature: 9eop8f9r4mhkq99shjfog78n7h9636eb
X-HE-Tag: 1771418030-280436
X-HE-Meta: U2FsdGVkX1+RxNkwK/pes9vP9LrtgJUJ+dG3NIoHV3U5P1GmnL2QB8Y9onavkdh+opiFvy/z+4ozm8+Zmw2QI412Bxjcg3VXIgmQ8PIkSUlPITXpziWLYiw7jYtEkCI2HSyGTe39bQvNSl2FRGkJly2uf3i/tQtVUY97ITzzTygUrCXzu2p5rQ9w37DKABSiftqZFOTTzyF9PHiLO7dHHWMeeNfOPR2TZCf4Krbrvl79tYa11zsfx999l1+DgKa38I4A3cz+feNRqs9fAn53namOh1pf1wXw6sD/QlCAf7y3R4sjJ1WxHMSLkoktYsoD9/utHgg5iDo8joHuu3EGCiadI7cuaQ6utQbUyTXeUzXmPB5CO++48Aas5psNYxa7G+Z3a6ZreZejDubaL97m2OnSVR58MvQNEsCQNYdJkdf/VB11KCQy1x70I7DA/r7hYx31TzKZDXby1mZYa8zLyGb4xQeEzinwzBw84IvqVzGEnlHNfgQ3FEAx8uXZyYBLw8xxAOg0JLQCOfTZ25qwdn5k8YyxDTBOVFXnV+SOK6UWybxVu1oIJA2Cnc4rkFNYoTKJ15a9OivRoLgkjA4RXl+S3sAA0+CKXvWb2gLcx8Kq9peXCuHxqc5K/spctQImJaetdJijnXmifxSHIteB5HDOOwyovva2ko7RXo+eIeQh1nMua++CoZLcmnDWAqEGOMF/wY+RKIabeC9FZfnMUKMMsV/KWEOZ7VqAIFNrjQeJgFCR7/Ney5VV0/biMzaslxqj51fCXSdaRu68ViNHdW0++6iQc+FzBGc1ctjh5F1djqlvNqMsaOCuAlPbD3e1Uisu6880Cw8jqmltr5lfDXHyRKPEnfUUoECQfH9YjA6pHMFI//xIqk9I/v1h3NKzlmZqvYFnvF3NzuxGfMe/vHM+6LaHLyDtoMfGRSqNSgQpImyjgjA8kjPkJDqDOQ9mdQ1i901eppDDzvh6gBI
 2aTOGiz/
 cZBpndWwoTeG0fFaTRksyrYIFrB6/yJz8wPEFqKIAAru2MAB913h42wH0axKbU86PR1rBfnHlkM9z509msnmU/ct1Pl/vR8Xf5ANsYRT+EjWu/kko+Qd+QkIJF5LKSGcRIVGPtFpoOUEdYiwV/MOY30lFGikekeR7PNCWKj8z0G7liavNRzy+SkcV9FGwn12gr1JUVaVt8ymAdhQBvX12QxJ/M6+oSsKiPWF1rJUxHrtkeO3MzkReXYxUiVWX0RzWZQ0tSB73JzsLdQINoLL93OCtH8ujBV6FdIf5yBmtuupvD3QHKbECx1nzI2BLQIBCOwEtDDh+849WpDU2kiCXZHZ1CjOqWLZy3fx04E0lpWsRsqy0VAA4S0awvw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Miguel Ojeda" <miguel.ojeda.sandonis@gmail.com> writes:

> On Wed, Feb 18, 2026 at 1:00=E2=80=AFPM Alice Ryhl <aliceryhl@google.com>=
 wrote:
>>
>> That's right, valid for reads implies that it's okay to read it.
>
> Great, thanks for confirming.

Cool, will adjust in next version.

>
>> valid for atomic reads?
>
> That is the one he suggested, so it is likely to be a good one if two
> people thought about it :)

Great, I like it.

This document should be in tree. It's not, is it?


Best regards,
Andreas Hindborg






