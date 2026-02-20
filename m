Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9AAEC5AD2B
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 17:34:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 067E06B0088; Fri, 20 Feb 2026 12:34:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00E2B6B0089; Fri, 20 Feb 2026 12:34:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E07516B008A; Fri, 20 Feb 2026 12:34:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C5A6E6B0088
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 12:34:06 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5A6E71C177
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 17:34:06 +0000 (UTC)
X-FDA: 84465533292.14.1D823B6
Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5886220014
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 17:34:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ifRpMV82;
	spf=pass (imf13.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771608844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B3RiLfffpu7Ffa96sGXtUyFTXMqhEfmtMEWOofkZHzs=;
	b=Ntcw8AkxkFvBNA/zMrgzhX8zdB4RIq1eHSBeG9LTtdygqSP4UzBQCBjKzbWf7eALnwTe/c
	XASG732kCtoImeF8/k/Wjrczr9bAA+wG+4HD2C3UqT149ww8nZ64YO0rV9kCoOixqQYBO9
	HCxCONv6Rh6whPMCkrvC6zxFwjUWwto=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ifRpMV82;
	spf=pass (imf13.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771608844; a=rsa-sha256;
	cv=pass;
	b=hRJNjYYfgtegPGvXUni6PtTNyZLRbpQ5qmzOyTe8hmvBFMyPLEMwo6h6gob5CwfksJeKFJ
	M5itVoAgNQ8ZdZjVdSfAMytCRksd/upVWRoORnhEe143ph39DxXPl2wqN4VQQGLBSaR8mh
	DZiA01PHQxY0i9QMvb+MWeN7bTqZJ7M=
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-12736a0147cso191952c88.1
        for <linux-mm@kvack.org>; Fri, 20 Feb 2026 09:34:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771608843; cv=none;
        d=google.com; s=arc-20240605;
        b=lHkElvJBg954sWdz3J5otT9dQGbMc0+YzairaI5TsDl3f19SUYK2823p2oh9fhDUY6
         kElltcUuJhzgWrKzAH9k+ar1aXZSAMiYlAt5lpqh3VdH/bJVshS9ERF8XmXPbnjQKGn6
         gqK6r/5qmpYFmTgJYVg2b1GXxAOdZ7l5BC6OVBXnI3EIN20fUENO0SDxXXa5tbiDKD3h
         +i1xytcJ+oCJiIEzRa3BC0LHS8F5OTmJNHTNcvTKWrt/3hIajiTtev7LGr2F384knSeq
         YY9ThXRuu2GG6GhQIQvrPeMrWjxCMwFC32GumElrdHiqlfbHN28oSA34VYIYGhRMI+ns
         tLIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=B3RiLfffpu7Ffa96sGXtUyFTXMqhEfmtMEWOofkZHzs=;
        fh=LrihlPWwAvKxxkdJ6T1Qx1svHZqsoyZq7JrtvIW/V9k=;
        b=FSfSobIGMoGAF0TtuIfVPdwr5mSICrWfboYHVhR2eKPA6sjaAhLEKQuL8DLiFPUxle
         VfQdgpLFqv+S1hmIkqFoY+Ui+JqQYTn3mn6wusAYQ0awfXI1DdLYk8B1TRAag1D1iBK1
         Rr8swjEComi6X8HDkb0GaiAJT+/WeKO1+Eo9J3NM3+4bic9lglI8LrIWYZ7+z8Ix8OxQ
         r83Q7I4FZhGAZ61JPRF9hQ7hsgq+feARYfRRwaDSQxMM7ZiRJYDcF4jVThKqkz4e0hhi
         F3dYUbBFY8DoM3QnUuOhbHS+ErljYEwqnolhY/NGv+VwHdneZY9bO0Kb/wYI4OCe4CtG
         0VYQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771608843; x=1772213643; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B3RiLfffpu7Ffa96sGXtUyFTXMqhEfmtMEWOofkZHzs=;
        b=ifRpMV82wO7qH4Ws3ySHrJ9v4JKSW8ebNpHXtqngCQcb2PxLXfpJybtgFwjgHCwibA
         V8p0li5aSu0EkJpCK6dR0pXhNA9vnOLdJP1oGwIiqNgkfwYN1ahTfSdxSkIZWGMCojdB
         kuj+AgaZcyw39B3ZbisebR2QZ5kViDbACsuRXYylP3JZ2HryBwJVwcvEoYGF6TYeS0m0
         7FdQvDgKxxOAvtz3ZDT436wyKym43VodexB305OoyzmhWjrfa9fjosN/UEGIhMSbKnZG
         2Qtjks7oiC4Jm15G34Zfv8Kxbkv0hFGsZl/KMFVluBuKBUUA78p0LDjmT/ulhT/hV0H8
         1wPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771608843; x=1772213643;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=B3RiLfffpu7Ffa96sGXtUyFTXMqhEfmtMEWOofkZHzs=;
        b=JNWFsPRHo/Z5fyie8xOpvAeb6Cu5tIkMLrszcTM0aFCG+EsotH69EgeFLTuMNZ56ac
         oNqVlWlT/jai7QW1dQjBANK5O6xbRKSwzrB+dBDestgEy0P7nPUUjf/XXfFSpdEDDHwm
         3veUWIbvZ4l1+83CaoE3XTnPvU5uB+I6/gYs3Utf4Di0+4Vr1lOW7aMT2xIeMzthtu1P
         B4S+TTaKTjgZ4oeNnvexOva+gONsAT4sXmP7sQE2o0e3phLR0HZeLPwk2Tn8IeunXSLh
         WCJdzZmWfMwduxHW944ZDTQI4pYDwpU33qEk4sr7w5JTQtJZ23kopg+eHnVtdEm+hu1P
         xJ/g==
X-Forwarded-Encrypted: i=1; AJvYcCW1709L5nMfXndd1cVsAdF7r/mllluezERNMd3at3Im7fqLONhmNZjBoGMI/0upvhnhXEwC/8AAYg==@kvack.org
X-Gm-Message-State: AOJu0Yz4cwRGfBZ6oseVZ6bf9wCdtz8fzosMeXa33QC/s/FDYg3WWk9G
	MMrnbRoojo9LC7fy38grwh0ddj4HRALA7B+BkjigSIyg2gq3s9SzKMppr53o25gx+JpxGGPJEei
	c9fvHsqgmqpnuHK+YRimtjfv1+TdnJuw=
X-Gm-Gg: AZuq6aKHPhTd3Jw3EZRUeqsLLvcB7Q0wXyxkBHMxsUYIJDkWiDmMeQaMvH2s4D73ugN
	Z/VvNtGjrHcEBpS+yiYBgsKsb7BSapkFldU8RUQypy8jG9JcIHuQwRmG9FMP582IeH3Y7hdYEAv
	ktNZJEA8omnAuXpKZPO8nkn8Yor4TtrUDagq6wcPMzuLLoBBY3eQ6Cad+2CP7SLRBzZMuxjHZqh
	pNaVEfpSOF1pHHM44+9Fxh6lV61G7PvZglwZILfpNWCyN/2TJ/OWE/KEtbCFVjS6KI0+PDE1YcU
	60Z2O1B7SoHvu15S4nXpx6WYcLZd8jkEF0HPM3J/vcTStTZEZoYSOa/JN7YeM3KK0eE/nsYQLEQ
	y++vFDYAEFhg31k5vIzcEm72w
X-Received: by 2002:a05:693c:2c17:b0:2ba:674a:dbe8 with SMTP id
 5a478bee46e88-2bd7bdbce7cmr74947eec.8.1771608842904; Fri, 20 Feb 2026
 09:34:02 -0800 (PST)
MIME-Version: 1.0
References: <20260220-unique-ref-v15-0-893ed86b06cc@kernel.org> <20260220-unique-ref-v15-9-893ed86b06cc@kernel.org>
In-Reply-To: <20260220-unique-ref-v15-9-893ed86b06cc@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 20 Feb 2026 18:33:49 +0100
X-Gm-Features: AaiRm53lo0keI-FayfnRj4AYfVuM2jzmE06bNyAO-n4MO92LWSUkvblDHz_tCFM
Message-ID: <CANiq72myc+tCEHm0WtZspZHWwsSzvesxsmUvk31=GCdUN_zVNA@mail.gmail.com>
Subject: Re: [PATCH v15 9/9] rust: page: add `from_raw()`
To: Andreas Hindborg <a.hindborg@kernel.org>, Tamir Duberstein <tamird@kernel.org>, 
	Benno Lossin <lossin@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Dave Ertman <david.m.ertman@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Igor Korotin <igor.korotin.linux@gmail.com>, 
	Daniel Almeida <daniel.almeida@collabora.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, 
	Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	=?UTF-8?Q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, linux-kernel@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-security-module@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org, 
	linux-pci@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: s8e3ji3gdunodr3wgxs15xxinhf7i8ce
X-Rspam-User: 
X-Rspamd-Queue-Id: 5886220014
X-Rspamd-Server: rspam01
X-HE-Tag: 1771608844-835708
X-HE-Meta: U2FsdGVkX1+m5oQo4MNJDnR3XYRUu0dahTJk2M/UDpY5lziYoWJbdQZhl99gvzJwIds3AX/0vDF4ZV5Fq8In3em97ll8Ul5BZz+cSjIze+1AqKJU/6OSca5JGJFXH5KSUR6mOi0OxN/CzSPpkCDX8fHYlUqKuiidwfCTeoHs92RkfxkZI9v+ghnuVpb01SLLqlT1+q21xwo2ENYKuiE0Gn0O1QIZRQHOlcgYMZQQYZWtB3NjSHem15fzpVlpWtfVxILh9tcjGZ1pWHx/8EqZ2/dpFL4lYGmRPh3f6I7E+XqSutlzWozsxMhqknywl5Y32xUwFKDgCRl/3+IWL8KfzU4a0gcf4ubrLOpjtSri30cWavYH+4HXCbwYQCkfn68PuYaxcEyx458nDyACUSKFOGx6vMc2GotHh2t6SOMD0E4Zp6meTxAKHnX+ez9rrP3xiFFZcszOrXG2QCM0kBkGgygFu6SomrQq07CyG3ThB/9ohv+A+TI1pva42te9i7u4lqbNqgQRhylWTiPNYBggDTP2rSReYAggNt6G+E43ujUeX8MZf1jZj27mgxaok/WUM4cWsNxUFDceJluIRVamMOFGQGtFqhnk09fVYhqzhlowNtoUYNeGtRSxdJnwXzCgntRBTVZen/00LOl/mVwgQe12krGySa0hKLCzTUnuvhMWhaOwqtKReOGD/z/oOQ9bxULtPlQquY1f21Q4GRW78++40aOJjA6OAXtuQzrCElcum4Flf4LSRrjz4vXkevxrTXLm45a65GExDGJZ+XQk65Cvmpxr46AiSSTUHo+gPfAMrI9NUBa3oZYIfpx2EANLUJBPrYRuZMv0ogfhAIRmCw86S38uZ+B8GaULueirF9BM4cy7Ddx7zhBItz4NX9Bv1cobjk5Lzso/cEkkufsIJur+biyzReNd4fX1FJjbftdmhNGOHzS0u7jf9nZe2V1JVxEIpdE/uwUxe2m79km
 4CX9x6ee
 X1aNt8+299VvE01z0BcuGlnlHf4sLlWLvYTOZx1zAS1EhFGBC0o7MtWzeIqmlvrlQLclijqr7Ar3o3KDBFpqS3qYrKbcDT6PrA7VyhOz08vV8EJMdMdeOH6qzgxuovDOgX2f3b/Djd0kyhkD1Jxx9BSf5CZjZKmQu5tD6ewp/7lLGxLVGkDd7tVdnHZFJRJEy75i+C6odtS7uOR3SIzkatHHSyYJ3o++LMor4ZZNJs1L1sR/48DD9GAMQXMuJJ6P4RG7gv7JEab7wOE9gwhijkbOWhJXWoeyjcaXBazaZ7wldnwTTOYgx/8gb8x5/jFdvADMAPxVAr2QpGPFrZurcaKDs7aKF1iR50WK0bSBzXZqPVmwGkweNASeSVFjo0huPEokNq22bavQQsNEUacV9DHUBC/NBw9FVk0iUt/8TAZE5xb2Dl2pNxky+xpzZFX7Dd4GF65cMdPxOIB/+vGbquMhTLhK70k4cdeMevM7tG6POnhK18uGrH2SyIE3jfqux0T2ssrHU0K/qvIEitFZPVj4xApd3tDczIbs8uHhgUyDdpqLCKUAqsR6UHa+A4C4iH5mXQ9uN8ho1nuRBE/CK9ajd4zV9FQOfW7OsaxvUtHBmI3Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 20, 2026 at 10:52=E2=80=AFAM Andreas Hindborg <a.hindborg@kerne=
l.org> wrote:
>
> +    /// Create a `&Page` from a raw `struct page` pointer

Please end sentences with a period.

> +        // SAFETY: By function safety requirements, ptr is not null and =
is

Please use Markdown in comments: `ptr`.

> +    /// `ptr` must be valid for use as a reference for the duration of `=
'a`.

Since we will likely try to starting introducing at least a subset of
the Safety Standard soon, we should try to use standard terms.

So I think this "valid for use as a reference" is not an established
one, no? Isn't "convertible to a shared reference" the official term?

  https://doc.rust-lang.org/std/ptr/index.html#pointer-to-reference-convers=
ion

In fact, I see `as_ref_unchecked()` and `as_mut_unchecked()` just got
stabilized for 1.95.0, so we should probably starting using those were
applicable as we bump the minimum, but we should probably use already
a similar wording as the standard library for the safety section and
the comment:

  "`ptr` must be [convertible to a reference](...)."

where the term is a link to that section. Cc'ing Benno.

I have created a (future) issue for that:

  https://github.com/Rust-for-Linux/linux/issues/1225

Cc'ing Tamir since this is close to the cast work, so it may interest
him as well.

Cheers,
Miguel

