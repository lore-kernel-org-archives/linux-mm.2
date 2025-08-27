Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2FD9CA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 12:37:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07B8A8E014C; Wed, 27 Aug 2025 08:37:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02BF18E0147; Wed, 27 Aug 2025 08:37:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5CDC8E014C; Wed, 27 Aug 2025 08:37:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CAC978E0147
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 08:37:46 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6E67959F92
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 12:37:46 +0000 (UTC)
X-FDA: 83822488932.15.B71DA3B
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	by imf10.hostedemail.com (Postfix) with ESMTP id 930BAC0012
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 12:37:44 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0fIsFYpN;
	spf=pass (imf10.hostedemail.com: domain of 3FvyuaAkKCBcx85z1EL483BB381.zB985AHK-997Ixz7.BE3@flex--aliceryhl.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3FvyuaAkKCBcx85z1EL483BB381.zB985AHK-997Ixz7.BE3@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756298264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PHlZ4FUGjTYbyYIeiOkCe6l8zJlx/Qt0X5GixYi+qFA=;
	b=lt148UiV7eQ8Me9HAOnW866LJXg56VTtFJUc4CRmGhZyBaAydqbJkQjm6OyuAsBwdWJqXn
	ji83mAge5qAL9VwUWDXMlkI8ILRpC6CSf1XEeByP3ISM/MDu7dlTcAqVef0mc33jPPch+E
	5HMZ/OHqzXPWSYIvyTMbFapk3OkGsGc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0fIsFYpN;
	spf=pass (imf10.hostedemail.com: domain of 3FvyuaAkKCBcx85z1EL483BB381.zB985AHK-997Ixz7.BE3@flex--aliceryhl.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3FvyuaAkKCBcx85z1EL483BB381.zB985AHK-997Ixz7.BE3@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756298264; a=rsa-sha256;
	cv=none;
	b=Z9nDoAgktkDLySIE78yVhuZ3Xk/5uBZAp8TpHAFTQ3R48gPtxQ8JFpZiA6KMJ4xUwTnzBf
	nEI5BCKn3MFrUy2CDm9QHX/tzUjV5SdHC9QYuOkzkL9Mj+c0qHL0xleMMTr/rCo/K9h0D7
	421Y9LdqXjzEvo/AbzKEobQ5Fhp1B3M=
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-afcb78d5c35so117595766b.1
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 05:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756298263; x=1756903063; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PHlZ4FUGjTYbyYIeiOkCe6l8zJlx/Qt0X5GixYi+qFA=;
        b=0fIsFYpNAgTcunyEvoQnkp0y8wNmwm3E4rUemLoRu0ZnnuE5647dK97LqXiaMkkhOB
         7zL+m8Vn9zKn9drdvrAz0lQMTVGEeUAxc2mWDI/AQtcBNaFkfyvnQd6yj/41b2aM4/cq
         BH+biu7BSHh1fmFOxwD2lvECAtrktRY6oxtRMyR2ZWCxA+UilKSg2fEjdB04db8apnym
         oDnbadNxoIkO8tSpN+vxHUn3LE1+VJ8OilOHF6ZttiV2KdYDtseiKe5uFqrCXGBGmVOA
         CO6yOOZyia6dEngHnX0K5M7LeWb4b5SgaHQMb9vLnaHyZVVQMA1HPm0NjgoM2pi3suTZ
         A9aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756298263; x=1756903063;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PHlZ4FUGjTYbyYIeiOkCe6l8zJlx/Qt0X5GixYi+qFA=;
        b=uA4vgRLY6rnVDeU9jLOA91clOTASinnGdRWC+yRfd5i5XuUgRo4v9KVPxGjFlbWIfr
         aaX3J+0y60/BIwosfYHOjC7uu7heKWo+oc2lkNA//QMgV/PTMFaudAZxHcOLC/aSE/US
         6/DTHobhalkF8ihvGECxRsu4gw2Ly+MJTHAzgpTWds4OpiT10yr0S/DgS9BmlofsNxaq
         JfkP31PiXiC/PaVqG+j78K3V2T48g1ntOb/rlqVbv6pGxHtfpNmonemmZjwEVv5dTCQQ
         M+ozVws/h8CDFBWcBdUmSKqpY85pIt0U3XMCwpbqDK6kA3l/S+r2izrkSGOXTH6mhPFb
         1D6w==
X-Forwarded-Encrypted: i=1; AJvYcCUGjkNiH4HyOx9Weee2E8N8/7dX7N+4Bnv+ZoO0ds2i6YMbvLtQ4JdZlAFV9NdAUmG4LIaNY/1Mlw==@kvack.org
X-Gm-Message-State: AOJu0Yw4oTBddWVdOszwpX6fhBabHs5udJCalJ3KTtWisk/JJVhbshoi
	ewPD5sT33eIMhcvFyiPM+oxAjKNJ+WlEfuB6Vd2P+UzF9V8KrHFR+UkNyPp+p40BeJ02TqjrfEC
	gL1JSVUXsBgs1cq1cKA==
X-Google-Smtp-Source: AGHT+IH0jTqhQCc3o7iTxWA6hTslX9AebGIsdzPOVI9oqOTQ+BfQJDAXi9TjCHSy/v+Pknx7OhAmDoPj4AWRRnw=
X-Received: from ejcty13.prod.google.com ([2002:a17:907:c70d:b0:afe:8897:3390])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:9486:b0:afa:1a67:e012 with SMTP id a640c23a62f3a-afe28f86573mr1588124266b.8.1756298262860;
 Wed, 27 Aug 2025 05:37:42 -0700 (PDT)
Date: Wed, 27 Aug 2025 12:37:41 +0000
In-Reply-To: <9179276d-275a-49fd-8697-82283fea4bfb@kernel.org>
Mime-Version: 1.0
References: <20250823130420.867133-1-vitaly.wool@konsulko.se>
 <CANiq72kQv9nJYyiuHvTdaJs2SvZ_bFAnexoEBgjb0CDzPjBTYQ@mail.gmail.com> <9179276d-275a-49fd-8697-82283fea4bfb@kernel.org>
Message-ID: <aK78FckaX26MOVAF@google.com>
Subject: Re: [PATCH v4 0/2] rust: zpool: add abstraction for zpool drivers
From: Alice Ryhl <aliceryhl@google.com>
To: Danilo Krummrich <dakr@kernel.org>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Vitaly Wool <vitaly.wool@konsulko.se>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Uladzislau Rezki <urezki@gmail.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	Bjorn Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Nhat Pham <nphamcs@gmail.com>, linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 930BAC0012
X-Rspam-User: 
X-Stat-Signature: z8n3t5k5ngwcjkh9ueiusscdk7rwuqbu
X-Rspamd-Server: rspam09
X-HE-Tag: 1756298264-112885
X-HE-Meta: U2FsdGVkX19BSOyBKkDU//YH3qJrgkdQ+5hrROZqFRKLBG2WwE6zuX0pJQKEjor44c4hLbK93f2qiwj2/+Tj/zSFRWZ+VOTHC4ku0qpd0Ctl6VjV29IwHWTjo1d3YO29oKyi2FMC4XWzkbMNxRJZna4b6E3V+c3RDte4ceBO77YM1wGzisadvZVXFjDU3h+Qe5GRkPfbdodpJdA1pFY6aWF5/ETGQINqSRtREBSzelcam9fFynRum5FfrVgz9tMDU7b6jr2zxUGSTo9XyEoXn3u98JjhKbwW+hztP4wyl8R9PkXgI05Qvgvh9pOfRClJurRe5haDOgQqn6UfTklsWBkxlQF6HgnmjMCopOKX16Bz8dM38VLL8J6qxhNuXLis1wdx+JgSyfIPtEFONwTdDQu5o3biLSDGM8yGpZLL42vWfsA3OCryiowaNlr2LksnFo2eTsrx9Xkvem1u+sSEYSy0VnsfVbKTOWCklzbVbRvrPgsBluImCuVfM7S0NILJqPjeCqbcgBss9mvgWUrvlRcxXAKtaFsZGUuN/Sfr43rPkyznbLDBEOjzoq/ZiTgaj7J03j5kCWV22E5/ZBmF/Ywe6KxIFV+nWbrrAdB/8z6L5mMnlgurhVmns8nlTHx3+vMm+T3TQuMKxaAGIt+jYu0C0uzLNSDvIRmeJlKwqywxtOl8yUSArBiKBljsMv3qD8uO+Y+TEJOO9/gs+nxNbatHq6QC9cObkXCsRd1kllHMFWiLcOcM1IIJG4roET6qldN3vsJsknnVKlBUu+3+W0DjemGLVIWVrbBdTBmwGdNy0qLdb9hKrQldqXke6eSKYww9Knyf/dEWeQQUIHnpuMjDJB6PuHmeICo0tDkmcd+dtt0YXrVdSPcgL+v10vWVg5sj4CydfuFRbeFgGT/MNIxk7xC4a8uu0XKOvIHKqv7F2H67HaiWqyvKvEJDBu7CpJBXSORP22aN4Tdzz8B
 KSEFt+rI
 wgqH00DytYW2fteNIGdhSXzS7lNLZ4ZS9W+5fXMo7uE3pKjOaTLl2zs3f5D2THECz3sLwu0KLyn9EMe6Fz02gO2nvEketA+z7RSJqxM4JU7yDOmoxfy1M/6BtdgY50DLHZWSsDJ3f4GiYiY5YkKB8D5bwcM1bNG0pkWdQ56yry0mZyW71fLYrTA0NDFvDs0t8RpDC3RWDs6syQx8qf8iT11LyNuatGN0vnTwaQs6n8d5+4VFTZBIe8FdPWPlqpO0g9tw+e1QeCKaeIflk2gl6r+wAhTfZrid8HPSRWp0gLcIePADLj2f99WS5gZiUQjj66IW9MJk6Na3PdYCBbOHyJ+IBhwUWD47xKtyDSnIvRugU1ceqotrlt/57y8+kFTaOtnlFS+DcoH17zvniGxAz19HtEa7a0s2X4j9oVEvIpu4odao7dGI6oVwaJ+GnFelkSa5U4543lXesuZ2ENhV8/aPCkzpCTwsloxG615IqmQz0puSNk8Uf+hqUMGofuKFUH9SseYqgGdFSJMaIkrRKNuQ8fHQGNzrGVlJnYp5xVuimU3k+QKj3TxCocm3rdxtwRrjABiNuX0ger0jXTDOl2ivdGeNuNoiB7Vc2tNM14AKTMhdk56tczcaN7JqGtg8xou4GLG3LWnbu2Av81rxGWCtBnBx+uztyA6ShwMxb9LUz1er3Z+5OsUnlIg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 01:37:22PM +0200, Danilo Krummrich wrote:
> On 8/26/25 12:43 PM, Miguel Ojeda wrote:
> > On Sat, Aug 23, 2025 at 3:04=E2=80=AFPM Vitaly Wool <vitaly.wool@konsul=
ko.se> wrote:
> > >=20
> > > This patch provides the interface to use Zpool in Rust kernel code,
> > > thus enabling Rust implementations of Zpool allocators for Zswap.
> >=20
> > In v1 the usual use case question was asked -- could we get some more
> > details in the cover letter or ideally in the patch itself?
> >=20
> > >   bindings/bindings_helper.h |    1
> > >   helpers/helpers.c          |    1
> > >   helpers/zpool.c            |    6 +
> > >   kernel/alloc.rs            |    5
> > >   kernel/lib.rs              |    2
> > >   kernel/zpool.rs            |  338 +++++++++++++++++++++++++++++++++=
++++++++++++++++++++++++++++++++
> >=20
> > Should a `MAINTAINERS` change be added? Was maintenance in general disc=
ussed?
>=20
> @Alice: I assume this should go under the Rust MM entry?

That makes sense to me.

Alice

