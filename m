Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0E54EF48CC
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 08:15:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B19F6B0005; Fri, 13 Feb 2026 03:15:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 268886B0089; Fri, 13 Feb 2026 03:15:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17F276B008A; Fri, 13 Feb 2026 03:15:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0CC886B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 03:15:43 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D30AE1B40EA
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 08:15:42 +0000 (UTC)
X-FDA: 84438724524.29.6B6683B
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf08.hostedemail.com (Postfix) with ESMTP id 17A62160005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 08:15:40 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DUe9ah6N;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of 3q92OaQkKCPQWheYanudhckkcha.Ykihejqt-iigrWYg.knc@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3q92OaQkKCPQWheYanudhckkcha.Ykihejqt-iigrWYg.knc@flex--aliceryhl.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770970541; a=rsa-sha256;
	cv=none;
	b=1bm9YGEpUiuuKYmDituq7a+zKj9dd/V3ygVmelEXqYhdpXDtLuE8D+ned0x+1q6tenad/b
	fp+pdUzWn1aWOqwVbJccYrFQ8Rh3ArzKvSMKVYmbmXp6BZLpb5Zw7yN3wBbTgqOc8jslAS
	YLHKh/WMhc6VIJEd95r2Afv21DAuYtw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DUe9ah6N;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of 3q92OaQkKCPQWheYanudhckkcha.Ykihejqt-iigrWYg.knc@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3q92OaQkKCPQWheYanudhckkcha.Ykihejqt-iigrWYg.knc@flex--aliceryhl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770970541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ONMzuSrIGefFUjDdOGU+2PvM9DC5Ou6joU7zcGGF6tQ=;
	b=P4FHPYDG2UdUgtke5XD/xTxkinFYGe8JFlkctuHKpzto5sjmjOput8mKffp0uedNm0xXW2
	E8EamngkoVlrM8Bml7CIyCz/2LfzdCj1SwmlFyRs5+qkDda+/g+yexQJoap9lWPe6G8Yn9
	JBZynhBhXvJL5vMxUef1mueVeF7WezI=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-482d8e6e13aso4249225e9.3
        for <linux-mm@kvack.org>; Fri, 13 Feb 2026 00:15:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770970539; x=1771575339; darn=kvack.org;
        h=content-transfer-encoding:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ONMzuSrIGefFUjDdOGU+2PvM9DC5Ou6joU7zcGGF6tQ=;
        b=DUe9ah6N4nMR8KalpTadVoxAL9W77yBlPHjWXff5gQLh8uegU5xyVzKDjjirk/3Bwc
         Jp0wgo+L1gKltUiHTMAQT7pNfWLyeFtx7dUNLyHJHcDLR6B0SuySmbSrTUg3V7JVzvHj
         zNt3FwN9SjCtNuzGFJWH0oS+klLXf1iPK5tx6Evm0XRy0dCosYR4CnzD3xaLESI67GqV
         ui7oZpT4LIr8yihygkUK/TbX+rGj3haCEX22cUvED1j2ROjgpTDJFzaUQpWJAAErRQqZ
         OhDRpaCMZMx2TlXGAp8FxgTGAVYoBWejE+xkCE54MHp810WhbuM8HuhOBCwhU2uOtFFO
         E5QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770970539; x=1771575339;
        h=content-transfer-encoding:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ONMzuSrIGefFUjDdOGU+2PvM9DC5Ou6joU7zcGGF6tQ=;
        b=Q+noYvxurl3PoBHx3xbr3uJmYemXL6E+3KfnWeqSzkXMc7zUCo+7ztea15zmCBANvS
         4ESaBbNJTj2djJYDYkmzwRPgrDNtrgcDoKJ6u4KNTVCGmHW3bLUd2C3tDzzQGj5ZOSnk
         NHjpMy+YmSsSkktM4QR4Gl3cTdx1OhaK44DWfceNHLKKkCbHcC9nZsXBcYEgJCmrl8ti
         FhkWUNfRhe5MFaPyJMq+BtX+zCpe6AKFAtuW6E7EAzorbVey21pgftNbD7MHsCKEAsIw
         JIClTlaDu3nBVtQAMHfXa8EOzcbzz9KqotAC4jwWI2n/ZCCVceb5Qj2jiF0f4D34Rx/Z
         bqBw==
X-Forwarded-Encrypted: i=1; AJvYcCUbY2dm7sF9Ez/qof1w6ZFBhAhRHIeVDRHngN1pcyiTfifXTRfFd6J9KxMfT0NBa/RJjwrEo0aCDw==@kvack.org
X-Gm-Message-State: AOJu0YxKVF0zOAQ0tyFz6OWrN0vRLAEEd69N5iNpqCaSkFXpMvkUf9S+
	YMkwF/TCNTpkH+Wcccpa4f8eMy/2CsCN5i668deJ6ZbRVdheO5JbWgF6VdrBuCFZjJ+JXFkwn3y
	zUvbpGG8sd8Z2iUk0SQ==
X-Received: from wmil11.prod.google.com ([2002:a7b:c44b:0:b0:481:a662:2ac8])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a43:b0:480:4ae2:def1 with SMTP id 5b1f17b1804b1-48373a07a59mr13877305e9.13.1770970539111;
 Fri, 13 Feb 2026 00:15:39 -0800 (PST)
Date: Fri, 13 Feb 2026 08:15:37 +0000
In-Reply-To: <aczcvsaftsh3oj4e7xvm2e2m6roytdy4u6zmh66p7fpzr3npvl@ft6cmvlogsvm>
Mime-Version: 1.0
References: <q43rzzvpfh6ke74eyn3nypiek2ihaq6nat552asiobqge4vxmn@knwkb5dexnga>
 <87fr77viat.fsf@t14s.mail-host-address-is-not-set> <fU1FEYt6-SY0KlyJy4VClCr5j6P4d5-wukzc_9TkSDSBuQNlY26xyOIprMbHEVMv-H-nrAJ1iN_9tcfIXEI1iw==@protonmail.internalid>
 <gta2wjt4tkcvyu7g56gqyipiigbmbk2ca3biqzmxc2npch3rk7@ccwzwgnk7mcz>
 <87y0kytggx.fsf@kernel.org> <87v7g2tesf.fsf@kernel.org> <_ZaFqe4HzW4GSDQTrXKDgkSCr7L9bxUh-h5QPqVlMUHSvE0oRFuZJOPi0JItf3VJXHmaX4PA4QWAGBeG73cJYw==@protonmail.internalid>
 <CAH5fLgjfSWfhUkmG6_ugue6Wp5LKtkEFJofWViJSNByq3sO2Sg@mail.gmail.com>
 <87seb6t9t7.fsf@kernel.org> <aczcvsaftsh3oj4e7xvm2e2m6roytdy4u6zmh66p7fpzr3npvl@ft6cmvlogsvm>
Message-ID: <aY7dqe83EJWtdSMy@google.com>
Subject: Re: [PATCH v3 03/12] rust: xarray: add `contains_index` method
From: Alice Ryhl <aliceryhl@google.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Tamir Duberstein <tamird@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Daniel Gomez <da.gomez@kernel.org>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 17A62160005
X-Stat-Signature: 5wffru3t3y1s3cpn35y9wfsqkdu6r9s3
X-HE-Tag: 1770970540-827119
X-HE-Meta: U2FsdGVkX1+/eZTBxdWq8yAfLtcl7yyBLDIlxJP4Aad1SUjuxvmQmc163g9LfD8g0E4noadDIykisYC+QGZNZw14U8sLs8ekY44hyMR7x2XXGy4karlrytPuA+ipYKPYjm8/szlGomFvX5OgFI6NJa0rolWNx8b6iRsVpjLoqSFyuNwAW6LxxOEdMDw+RpuDLHmEy/Fa+wXhI0LdR9SACcPhdf/AkieQzcBksEN0U4SOcBjnhVO7e40RPhDHfnUruO0hpQ1zf2S50J5TeHc3wlAZaJIBCf0K3zN6EbrIc7/RxbnXoKwcY+bTNv6EZqpaEfoG4vxajYLb/LATPceb+ExcB/eQq3MmSxhsHnN7VubkivnMFMQqxsmT8oJFNLq+lG7T7bYIgKEOtAfvPnJlNEFfTEtGF2i218klmHlql+9Mv8aTaNSpl0zz+Kw4BUFFNdxV390iM4SvvBsOo9m6SxvMsNiHg6kF8NQNjgJ33YCBYCBqynzFpmS/ritlpQ46zJGeSM1T3iO6TdzdRCNA0UIIgTBSmCSl3u/KirJUwYh3G0e4MMCO7Lf8mOxLdsq4W4Dwe8p0qELSpt+JJYqN8QeM3wWWlRTPeBswAmXTwRJNGW2xAEzCODAizTM+a4yob+otWT/AXrE6lF2XOvyT1aoJdKiyltATSye5VoUFhoCDyTeBgFhiKHQBsbRWyvYjRqx0qjcApFIY7cBUDJIqumTvm3mvEbp+sDpK+z5edBF4+bn/OZVc6cEWEWOxf2LveI+dE8RZv6P/LuTSohQnL7BJttEaEfXmE3/FHZ2XvdpAKY/beBfTtZ5qyXqzekBAouEaHchDvth7j5T+YOA0qKgGM4Xvfg6kZOERUZf4iL/eb8XUlUHOb4690Xdyz8f7b6v41OyaIp7ch7Zsn/PV6Pk8D4tctlMZ+eBqc+aaT+UVZ7Xsxnb7Clr6k4NyUcrhbUB6JvvUKwVzTXfc7h/
 oOkfSSzh
 SW1f+nwKpLJMlo2vyF0zg2RcZAzUGX9z5vlai/8VJ2eGhyNNZkfb/w7eYgdaam12pM68JebcToYBTZRPq/Sa75MBJNoEcsSQfXL2BQjO22bB5LvxcOL0uyx3JLryERaFBQf3rVX7Qa4EyLYJiBTLfJ5rYvD4gV2X8PBvONVus6SyC3uJy8nmaxkPWd5jh6pnMlEV+aD7JbHcfm5KQrUqa7bOgh2+VZU1D3m376l0CAs6M5HNz8aC6sC2SelhSS6eYa82qHL+0q+270ZlnGjei0gkXAWgNODoV6oKgh6UbWcuWaJWWcvek7f/QYUQkcgNovvo8rS5YdS7WvPA4QK1tJHOZP1NhP6Rn5Tjkr5DEwRKE5rqvEM3F+y4dU6S0PMOdFvR0XYQalyJzXl2iIx/sVbAQ3lv/pyIYT9KfxauY/OaKElhG1kEeIz7KUSkAw/lcJV1nlNJjX++cD0iF8hNap7gWRQW+oQO3n93hQkkVWU0rJspf2FWUCQzgyeC87TRa9AlWmH8yoXh/TYou/1dinZDZ4LvIvpurAGt7STERgVyQcuq2u/WaaNo6vYOjeBvMFDfmhhIYJ1fXeHkZTHNVmapByBBswD7rhBN8MjpaHI4NPsDxX0QLibGMzHe6+yy2WdkGnm/g70g/GbFZH+CZjWhtKgc2PxIW6beqcP+JNvX8JlokggqIc9+Vi9muR4MaikcpERa8virN+GoKHbWcZtypLyIBrgK44b7KIL63Je6iYHncFt36Bkq9K6jpnfbYHdX3od0/1VHTWBGNsmDcOjvV3zr68WRaU7VF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 12, 2026 at 12:49:09PM -0500, Liam R. Howlett wrote:
> * Andreas Hindborg <a.hindborg@kernel.org> [260212 07:40]:
> > "Alice Ryhl" <aliceryhl@google.com> writes:
> >=20
> > > On Thu, Feb 12, 2026 at 11:52=E2=80=AFAM Andreas Hindborg <a.hindborg=
@kernel.org> wrote:
> > >>
> > >> Andreas Hindborg <a.hindborg@kernel.org> writes:
> > >>
> > >> > As far as I understand, this is a borrow checker limitation. It is=
 easy
> > >> > for us to look at this code and decide that the borrow on line 51 =
will
> > >> > never alias with the borrow on line 49.
> > >>
> > >> I did a bit of googling, and this seems to be a well known issue wit=
h
> > >> the current implementation of lifetime analysis in the rust compiler=
.
> > >> Apparently this kind of code used to be OK [1] but the Rust devs dec=
ided
> > >> to remove the code that allowed this, because it was causing excessi=
ve
> > >> compilation times [2]. The upside is that this is solved by the new
> > >> lifetime analysis implementation called "Polonius" and it is the
> > >> intention to replace the existing implementation with Polonius at so=
me
> > >> point [3].
> > >
> > > I believe the standard fix for this issue is to provide an entry api
> > > similar to HashMap::entry(). See the rbtree for an example, as it
> > > already provides such API.
>=20
> Alice, can you provide a link to the rbtree code please?

Please see rust/kernel/rbtree.rs in the kernel tree.

Alice

