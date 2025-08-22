Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04CAACA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 11:05:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C2AB280019; Fri, 22 Aug 2025 07:05:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49A658E009D; Fri, 22 Aug 2025 07:05:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B053280019; Fri, 22 Aug 2025 07:05:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 26D748E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 07:05:33 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CC2CEC010D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 11:05:32 +0000 (UTC)
X-FDA: 83804112504.11.34CC235
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf16.hostedemail.com (Postfix) with ESMTP id 35FCF18000C
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 11:05:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GIfvdYlb;
	spf=pass (imf16.hostedemail.com: domain of dakr@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755860731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sBceu6QfC9/WWC1L8u9ha80WVRD+kekazvacogRY4E4=;
	b=X+nnlgHraAwHf+F/Jm96Ex4Bo0WsgnwAPqgiZyWMfLtXyDR7LKyESZeOg37qzjz68wDAYt
	DxjncOcZGZYkjqWGl5uJlyZd3r3liCgeYqIiusLzbUriPLUnxfs57aXijJT6p06mUc57Of
	N29NNd9Hq4i2WsR/u03iZbiEiBqnFKU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755860731; a=rsa-sha256;
	cv=none;
	b=VtD0CCOCOUMbySZ+Zn7xwbu91ELszjG1Q7AxFER4hitatANqDkzk+tXRH3Vb5ElJ1V/q+z
	e0gp2swBhOKl4nGxfgdQvo9s4LElqXLkHh1zgFX0lYK1kpffF6bXOKXM8+F1/SDQLJ6gHX
	cRzVygnSRHt+VM1tJ12CFO21Kez5yOc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GIfvdYlb;
	spf=pass (imf16.hostedemail.com: domain of dakr@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 25EBA5C6EF0;
	Fri, 22 Aug 2025 11:05:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE74DC4CEED;
	Fri, 22 Aug 2025 11:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755860729;
	bh=WJf6g5RzafPQV91L2VIgFZn7ZVuqRfgK1tvm7SBza24=;
	h=Date:To:From:Subject:Cc:References:In-Reply-To:From;
	b=GIfvdYlbRH5IIFq4bXFlt6CRdt01QKOGW3IwCR8DvTJ8Gy1V6y3W8SwFRHPCm7/bu
	 XvY3Ttkh6vYbxe6aNuvh34/KpCA1QMKEsYr/fiO5u04KF0hoeYcZ69JCyC7JzPESJO
	 SA3fG0IlQytBFERdE3qkky6Wrb7BCT24vUBsLIPn2cTD6tLVZHXebQ8Ht7/C8ydCxl
	 dk1Qp4MFSRFBeBBjBcpDJVsqsoRXoY+17Kvh3wTvYZVECYXsZsWhKxWRiXb7vSCuUm
	 xMQWvzbrpwdxtc5fqFDJVZRo4W1hhI9xLLp6wR+1K2LLlm4K0SNCB8dEnritsbedY5
	 dJxOiy/FxxcMg==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 22 Aug 2025 13:05:25 +0200
Message-Id: <DC8WOHIEAHQD.21VWTH8VI8QG5@kernel.org>
To: "Miguel Ojeda" <miguel.ojeda.sandonis@gmail.com>
From: "Danilo Krummrich" <dakr@kernel.org>
Subject: Re: [PATCH v2 2/5] rust: maple_tree: add MapleTree
Cc: "Alice Ryhl" <aliceryhl@google.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>, "Miguel Ojeda"
 <ojeda@kernel.org>, "Andrew Ballance" <andrewjballance@gmail.com>, "Boqun
 Feng" <boqun.feng@gmail.com>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, "Benno Lossin"
 <lossin@kernel.org>, "Andreas Hindborg" <a.hindborg@kernel.org>, "Trevor
 Gross" <tmgross@umich.edu>, <linux-kernel@vger.kernel.org>,
 <maple-tree@lists.infradead.org>, <rust-for-linux@vger.kernel.org>,
 <linux-mm@kvack.org>
References: <20250819-maple-tree-v2-0-229b48657bab@google.com>
 <20250819-maple-tree-v2-2-229b48657bab@google.com>
 <DC6DC244ZIUL.304JSP7JFDE9Z@kernel.org> <aKRx8xsY8CpzbeEm@google.com>
 <DC6F7BN2L19O.1APQU9KWZV7H5@kernel.org>
 <CANiq72=xdryEKzo73-1vaBqGNNme2kRU0atP5PYOnOOXjNxZZg@mail.gmail.com>
In-Reply-To: <CANiq72=xdryEKzo73-1vaBqGNNme2kRU0atP5PYOnOOXjNxZZg@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 35FCF18000C
X-Stat-Signature: oozswx1mpdcezpxpprs6onejyshn5w94
X-HE-Tag: 1755860731-734074
X-HE-Meta: U2FsdGVkX182afUYlJsJUcKKVC2e/ITc5poNxqORgclbOehXMOGMuvL2NvMI0jZRrOT/fFppsqGEO6QEgPagERFZsz+I17ct4WxbQMHq2/RK7NQcfRJ2u1idZFaPiHGfLrluEVrM1hUs9uLy+YGFecYgGIlgVan/QvoEPzPY5qU6ILFiSxogLPHzU325lf61NL54883g9BGArEyUqdmGuZBtYZMem6hLGJZxe8p2ezVBDiHm58nM+b1WPB/9qnESnxrgneujeIaNrbeTvNI4YiAcXq1OjBz5bMo//vt1gzutEFyl3pZmdDRNJOgSndKjIMIVrOnuCsvnK0EwZIpnYuGoQGmDXx+QOLB/kL32GA4HBvWb3aAadjybOS06Yp491L0GaB3OTbcvICNNbNgm9NUbtO3wZ0aZ2sDBTCLhEPVR217hPPOMbLuC77LIcVAJD4e7c/lky0hJ0R40BOkLlUmpccs7hMWBJKxP5+4yrHgMIg6v5WKbneDOw2AKRlb+oZU+wfre6o5ryKp+f4+ORlYrIq3/gT4s7es74A5JtolQDqEn4U8oKK2HPT9WpiNZAuzCZNEug6LQM1FaJJIGcdB3M3cDDYXe/HnuxD2tOIjratuIExpX7yd0pk9R+H4OG9EEujT4HTe4Z7YS3N17NE9dG+jy5UDkuX0/189AZ5Ux52fkjpy/2d6OKdGKK6rKWXyyjm/S5czdNjVALYbq90LMZw9+e29fBJDGJ1ABqf5DugOFQcBTIaTkj9tFMkyDgOrf9yguZ2AA5W0Hkes785RROH4ftbkdZEHaQDzGwZoLX05YzotjK9ysgRYo+QcL+YGSjqXR81FMvT20qz2ZaQqMaHuq6k+pAJ3SlADI/YAWCV39VBMZDGoahjcdTqd3D3IrpfVK+qh5MWgWmAVlNSBxXRqeOeIujg5SYvZzkyQU1wE+3bjLXVdTOYgtF088EGs0EvpSvtrZKVZdaXa
 3KEOZh+I
 WjYJlgc/vq8ve6ioM4OS+8pKJeuMYh0K6h5cZvUU20RqV0YYEaiTnNjhW0VpSV/JGbTOj3Flt9yflBZaWf3sLkW5R/5HFv2tgPBb57UfWBvDEJD/4sMEVhbp2AFjwmhRCsoduckhOUStp31SOeoDVL/CvaOIxRaINqHEFIExBczC9RYevpFvsV7Q0qkcTlJ8YZTU6dntYDDFZsF9iZAK3/H9GK9TNQYBhNOMvMh4SPRgj0hDnjewe/EFvAR+UumxKYHPuzvvggNLZm3cRKjjpBsrSYRDv+KqggiPglN/BLwadn5PlPRx/bAho20qeNlIoOEMidE0ZTws6svQKwylezYAIfxUq2xezo6D+oHFGGIeRvLnGRun2hP601bRK9WcFX8rFvoGq/g6XSxZ7ZRiALHxhYi35rTjDQuMjcDsGqZo0BncFoSwCEFDJeQpdkuXEXSUSPSMOU+CCd3fXG0uy0hL5j8l6Je4LXG0cMlECvykiw4E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Aug 22, 2025 at 3:40 AM CEST, Miguel Ojeda wrote:
> So, as a rule of thumb, probably we don't want to show `unwrap()`s in
> examples if the code could have been written "properly" instead

I think we never want to use unwrap(). Even in cases where we relly want to
panic the kernel (because we reached a point where otherwise it is impossib=
le
to prevent undefined behavior) we should make the panic() explicit.

I see it fairly often in reviews that an unwrap() sneaked its way into the =
code
for things that can easily be handled gracefully, such as simple range chec=
ks,
etc.

We should probably check if we can get a clippy warning in place for this.

> , but
> `unwrap_err()`s (i.e. error ones) within an `assert!` are likely fine
> if the example would be better with it.

I agree, for obvious reasons unwrap_err() is much less of a concern.

Yet, it might be read as a pointer in the wrong direction, i.e. read as "un=
wraps
are OK".

If we want to check for a specific error type (or cause) in doc-tests I thi=
nk we
should just use is_err_and() instead.

For instance, instead of

	assert_eq!(
	    tree.insert(100, the_answer, GFP_KERNEL).unwrap_err().cause,
	    InsertErrorKind::Occupied,
	);

we could also write

	assert!(tree
	    .insert(100, the_answer, GFP_KERNEL)
	    .is_err_and(|e| e.cause =3D=3D InsertErrorKind::Occupied));

which is exactly the pattern also shown in the example of is_err_and() [1] =
and
entirely avoid any unwrap() calls.

[1] https://doc.rust-lang.org/std/result/enum.Result.html#method.is_err_and

