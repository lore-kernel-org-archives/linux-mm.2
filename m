Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4116AF4610F
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 13:35:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7296D6B0088; Mon, 23 Mar 2026 09:35:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B3306B008C; Mon, 23 Mar 2026 09:35:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 553F06B0092; Mon, 23 Mar 2026 09:35:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 415726B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:35:15 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C9BF31A0B7C
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 13:35:14 +0000 (UTC)
X-FDA: 84577424148.07.A0AAEDF
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	by imf03.hostedemail.com (Postfix) with ESMTP id C60EB20012
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 13:35:12 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Owg2PYGP;
	spf=pass (imf03.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774272912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P5oJqHAVX7zT2HPF6s22H5/MvQLO5sXIIazXAuipXIs=;
	b=XIlWlRaOR5wXA7PlJF4TFhsETwDmzT7b0Mkq7QCHTBxVX/Z+U/0aotXWKF+NJ8i5KELMN3
	epbt2CqyU6vTmj908S2r5/SCD/InYmqUBo0n7AqVCHBoox+s4l37SkMHAhpUTErjpy+mo3
	cIjX4MFF2FlnnNKdgrv6bt7V+yEWbao=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Owg2PYGP;
	spf=pass (imf03.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774272912; a=rsa-sha256;
	cv=pass;
	b=GnWA+aQTqX0UcfLUOSMtqpJkY5KXUqMUIbSrm3TiIcEz9cnReEozoUAOg/YLJ4x3FlDdJc
	XLN2PsYAwcWuK1oLc+QgyFxu7+brDQou/Pingli/I/zUO5i4931PQwa/5v3VgSqwBKV8nS
	sQJUvws4N9I/5jrRcTVUZp8K2Jg8jDw=
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-2bd5658b901so155628eec.3
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 06:35:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774272911; cv=none;
        d=google.com; s=arc-20240605;
        b=b5oaiamsaw0AEZhQAIfYHkeSB4NWVqmQ1Wo0tpvWfQj9UwBrUAJKkr4Q8l0TUPxGHs
         l3kxEmgqA20R/3SRyRBKjZj0UkoHrSU3Ojuku37xwttXlBSJsEfw0YJFa0eC2JgS/hv4
         BJYm+/3ce0zOFS8MghctsdBGY4DXrBQbSH04WeiZI/e4fjQjebWOBj5uvSfkJ2A2kvq5
         MJSNkh20J5S40/rRZ2oj920diAoUc8q1z+MYNh9068ViHciHsnFU1mUHzUDtot458cb8
         Gllh9IdDGC/qPDkAYJUTkx4jYy0utUlYZxaJ1qF0+wgWEfCbMdD3wz91NpfkWlTAr8UM
         gYDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=P5oJqHAVX7zT2HPF6s22H5/MvQLO5sXIIazXAuipXIs=;
        fh=7JZwoBZYxazQT/K2+eFNbbV5WGffUja9lZmqH5HjOcA=;
        b=ftHao9CFzjwTVEfc0OJ+x35LKdT/DDG5X0DvwxPrvojmY6KWYdbXGUBsh/lorrXeSC
         mDmqLNTWg2aLnCduNz3/djWmN7fSKFQYlJ0YRMDLt8jVzdgvbkWfq1MBDrwpAsia2IIf
         Ps+fOJDFLMG2LxMPzM3+aqGjpKNEYgXI1DJYVfjEdHcpTiR91jZk6sSvg0tESpqQSE6W
         s1AylZJLZjF1/DCa07w3cRtwtpPAdCduzOoDK7n9KoKK7XT4pIdo331k/koUXsCGCe0C
         iAeMywlYgIMPh51DCSgNRV6HavoXQARWm0YLz6M181YN8L8zKL6qX2KJ9/8c00Mks2PM
         iR/Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774272911; x=1774877711; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P5oJqHAVX7zT2HPF6s22H5/MvQLO5sXIIazXAuipXIs=;
        b=Owg2PYGP++NwSB5KlBGvcEB8RUMWjIKya3c61/41SkO9lS/7NjEmDxMY96gFdyGD+n
         8rsFE/YeCZf0X1q76I9FXKaiY9FO4ADqcglyA3CIb+nmi8QMoKd9JKpjOu+4hbhPgDyP
         A2pmni4QppSTgrGtSnUtu0EitAWqt5D+7ssbXHidYkSvDZoEgKP8qdA9lURxOULVJQNV
         guedn+z4X4ybSKQX1LD3YpDwE7Md+48GxNy1nUlt4lPtbMs2eaCEAjeEt0BDeh2tIJTA
         17wif1ytCoMuv34si7tF6pKQHz1dLZ1/W0nalQVPQSXZyu70cahEUtA0KusgqSGt109R
         5LCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774272911; x=1774877711;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=P5oJqHAVX7zT2HPF6s22H5/MvQLO5sXIIazXAuipXIs=;
        b=To2kuLfP4tlO+BDU7P6o4n7Ez4i/Ccph92YnnLI0cApHSx0rPqAxM3SBh9ZlRBZGb/
         K6hrRBdDOh3HZhtd30ppG0eOmGeUCWk0j9VtgAIxXhjureuPQd0kJwGt+ahjRW7qXeA3
         prBMKD3ox0uiZKJlNnMSHPm6MiHivTlfCsuCD4i0MIOoE5HYWBvBoNGzLb+WhjswhPGy
         01XcTbsIJ9pxuYe+lyj64jWiZ25l2Po4EyMFIbXUeZ4EZeUx43Vp8ielg1ELmYjEnveI
         967fKtBbhE4IqqCzMffEUNYYEKnzVPAkRkztVVfr22U3o+bhaZAIrCylvvD/3vssC7eo
         74oQ==
X-Forwarded-Encrypted: i=1; AJvYcCU27eZ1hotxj+HcmOHJPTUt8yCqUnmknRFZqYFmYKvid9exbBTdpkePiGTawEO7tR5SFrYaqj/Gkg==@kvack.org
X-Gm-Message-State: AOJu0YzYMiHW01ku2/0VQknQSHYosQtMhl7KOl/Ls6sYb+sr+aoj8KBr
	X3PRg8SedSk9PQ1BngVbRPt/kaR2BnkqGuxG+p+uCQPX6MAXFlatrHLAnyHiEPy55sbYYUMWiAY
	bvzwvcJTE80Mjg8d+qKaC4+vwfRwVne4=
X-Gm-Gg: ATEYQzyUE0BpoGMTus2O6GwWty+LsSRJwd3z7zRvMCD5pUVdegUHC0wjMRXzFAdqYbT
	Q9iA49Df2l27TmzzHdEtfJaWGkiao2d7CAFAHVndtESEdOFV24QQRTBT0Cs8jZekl2QgwGzoSPs
	4hhy65WnMbWKZVbk5rAWOwlO47UdSrVTdKDTP9GSBlXM6OTO4FzUHjE6PZE97ktUdoveumtEJ9M
	elpHJFINNpG+qQoKeJdxL40Mht8GUXO7F8902q48EjPNy/I5kAm4lOqLqIjmrbaxgpMJVLNe5zK
	HLNeN6zvKhNWSIhUwW/q8/mxIm6Oy9sd0nF3iiYbRZ9VlUASkuscAzxxEr8JBDG5l9M58cPS2k4
	nzm8cQzcySnDLYbD76MN15So+HKTcDVzY8Q==
X-Received: by 2002:a05:7300:5711:b0:2c1:27c:75d3 with SMTP id
 5a478bee46e88-2c10956c2a3mr2435566eec.1.1774272911337; Mon, 23 Mar 2026
 06:35:11 -0700 (PDT)
MIME-Version: 1.0
References: <20260322192159.88138-1-ojeda@kernel.org> <20260323000327.111235-1-ojeda@kernel.org>
 <96287f3a-d245-47cf-b7cb-f821451493d3@lunn.ch> <CANiq72nwSWVDRqm0Vap5j5X5k+Q-wq8okQ9d3KUgZt6M4CpW9g@mail.gmail.com>
 <65336ad0-ac37-416f-b6ae-e691e3e375ae@lunn.ch> <DHA6SE9EMEQF.1PKVHEG18I5FS@garyguo.net>
 <b5063e7e-9245-434e-9877-5ac7b45f4bc7@lunn.ch>
In-Reply-To: <b5063e7e-9245-434e-9877-5ac7b45f4bc7@lunn.ch>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 23 Mar 2026 14:34:58 +0100
X-Gm-Features: AQROBzD7g_rNmuMWaBSXTkod6GcGExC_6-5XqRdaJnhqw3z7WBAm_JnLMPlOCtE
Message-ID: <CANiq72kD6HVrDTjQrTXDujyjA4Z5ELM6Nh8kFfVfNXrvpfU1wA@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] Inline helpers into Rust without full LTO
To: Andrew Lunn <andrew@lunn.ch>
Cc: Gary Guo <gary@garyguo.net>, Miguel Ojeda <ojeda@kernel.org>, a.hindborg@kernel.org, 
	acourbot@nvidia.com, akpm@linux-foundation.org, aliceryhl@google.com, 
	anton.ivanov@cambridgegreys.com, bjorn3_gh@protonmail.com, 
	boqun.feng@gmail.com, dakr@kernel.org, david@davidgow.net, 
	johannes@sipsolutions.net, justinstitt@google.com, 
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-um@lists.infradead.org, linux@armlinux.org.uk, llvm@lists.linux.dev, 
	lossin@kernel.org, mark.rutland@arm.com, mmaurer@google.com, morbo@google.com, 
	nathan@kernel.org, nick.desaulniers+lkml@gmail.com, nicolas.schier@linux.dev, 
	nsc@kernel.org, peterz@infradead.org, richard@nod.at, 
	rust-for-linux@vger.kernel.org, tmgross@umich.edu, urezki@gmail.com, 
	will@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: r7nsf3qchs1hqw7rjxpw3hhqgjcctqby
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: C60EB20012
X-HE-Tag: 1774272912-343723
X-HE-Meta: U2FsdGVkX18I20/L7tDQqcrGyczMrojjET6HDBDPqwrErtthE5QxEIcUALM3UALEKyrxl6umQRpEMBAKp03xq3hTe3Pf6wUugrLVMf8ShekI5UzEtB4t1xIyOkSIqQ6RzLJIcIJy47D46p9vdB4nbfjIAryGbgnR8xv6l3Lcdyflfmjn3k2UO111H3rniq8XcE+H75PmEW8ulFuRaQmragvpJXipd3ledmQdaBR+LuFXv/FZBIWMx5JBG3+dv9Zq2y8rKbIwT3CE/R7RlCA62BT3dTzbNTeNsupvtTlxAA5Ue4f63YlhURVXmyXVngDU8OZGz2ZOsXfQowuGZv8YN/Y7esqxs/jEv20pBd2XFIjfRUg55BI907E/HR+A31TZbNAXoY1VjhUkSdwpKKzmkw/coLKW8G3/SwsVoSBZdsG2PZ/ff0UcMhyd3ozIiZr//IhIA8tV6Ly2wP/69G/PQGZ/aAnZVcZyl4Lh4pEt+jy7l1lgrj5sx7r+FqKxLMeCehD2ePivDvzgbGVbVhc1NwEu1ySPhM3Q1L5ZA3HrP4s/nXV+opW+cUrd/+Vlmacras9wzMGzLnmUchvYNGFWCQiWDErv9gsYS70tnudnukPTil4GPOMthl2wF9GwJGrJU7Y5OhDVfZvG/dgsTlBAdKWY/q+/l8TIB2SBL4D9dI+E2x7MmeJ4bngZDsF+GHEWgM54kK5eMatkNCv/+TwRim7etRIu1vZB8f+MNZSU/1XsgZhvM6VPHieFAdwz6QRlFXhJ+n1gYFc/1fEC8TsDxcg0+7J4rbrDiSu/nzXZQaCj2jmwLca5O1yNS10DPLS48hDq/heiDmrF0wDtqNsQF0z/Ap1hotB/5a1xS4P9BGhhWQWib7/pncDpFLJGqWlNM3w0h8HG6cguqNgfDHceoyUDlV2NNhPED2rv1d+KDnDICmIYM8LcA2T0pET/CQ4tnFkEBXA5VqvWqq+eNzW
 L4he+dfk
 +fIUWNGbCa/l3Gdn5PP79c9X079w5glabVFssRQ5QVaPZrsSqqOT0Qepp4hVAFS9awDzpuU2EeiELkMUozQ81bAYgb2IMjnFIx9StN/eol/xrHGaElJYwKcgaXRuuUdVbVM7/AtH8Za4UBIlLoNjQyRc4vLYKpSHVYMTsHkl0ySyZkr+0KiUUuD14fmO+FBjx6P/bGgJ0WKjWnInilpT/NCPqDwyvpNGkfBZ2SLiwPj10Dq5pUftLOjRWhnmyvaZQkf+ln+cn6s8yFf1qpsRexX0PPLIZR+2ZnkGd842IzbD+jFej7Gyte4oEFN3Xo6y3tGf7mSXJk1VZ0rLX8uL4zJ2zKwGmh9I857TKdl7tFZ/SlHBW6B2L/V2bzzXX+bGi44QryiH/R7faN7V5NBftcSNYx1DoSOAlJcj/4SggpakWOC591cXamWoOjYhx1pAsiUTMdbZQHaX7tZ0T+1n9hWEIFp88i2RAv4DFmInyirS8Wrc9iVtnFYc8ZlbADgocQqFOw2PQJbvEmubpsCnVbEZ3Fg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 2:28=E2=80=AFPM Andrew Lunn <andrew@lunn.ch> wrote:
>
> So it sounds like my understanding is out of date. When the first
> Ethernet PHY driver was being merged, Rust could not access inline C
> functions. The binding had to replicate the functionality. But you are
> saying that Rust can now make use of inline C code, but not actually
> inline it? It results in a function call?
>
> What this feature does it actually allows inline C functions to be
> inline? So it is just an optimisation?

We have always been using the helpers to access the inline functions,
please see the top comment in `rust/helpers/helpers.c`:

   Non-trivial C macros cannot be used in Rust. Similarly, inlined C functi=
ons
   cannot be called either. This file explicitly creates functions ("helper=
s")
   that wrap those so that they can be called from Rust.

It doesn't duplicate the functionality, it simply forwards the call,
i.e. it is not as bad as a full copy-paste of the implementation.

This patch series aims to improve performance (cheaply in terms of
built time) because for Rust calling those helpers are not inline
anymore otherwise.

You may be referring, instead, to avoiding to have to write manually
the helper (the forwarder) -- for that, please see "Support static
inline functions in headers (by generating a wrapper)" at:

  https://github.com/Rust-for-Linux/linux/issues/353

(In fact, I had your previous mention of `skbuff.h` from Lore there :)

Assuming `--wrap-static-fns` works well etc., then it would be nice to
use it, yeah. But that is different from this patch series (and this
patch series would apply as well even if we use the automated wrappers
etc.).

I hope that clarifies.

Cheers,
Miguel

