Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00540CD8CB2
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 07:24:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D79B6B0088; Wed, 10 Jun 2026 03:24:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 161C46B008A; Wed, 10 Jun 2026 03:24:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04FED6B008C; Wed, 10 Jun 2026 03:24:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E583C6B0088
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 03:24:42 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1F9EE120649
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 07:24:42 +0000 (UTC)
X-FDA: 84863165604.07.EE678C6
Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 24F0E20006
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 07:24:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mEKyKVNs;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.172 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781076280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rf/c/xUvAcS03/zJkFNJkmBhyUqR627XeIXzc8m5gwA=;
	b=jbY0Mc1izi+r0Acjtc3cFqtckJZiBu7v1BlQlxU/HsI0ZhQ9QIkl/VqFsgEydFF13B5Ncv
	Zo+SW5e7hiSN4+/1K6jf31ADKMxWvYMsZyxBSkTyq0lqz16T0Jpe2NgDadHeweWFNG2YNp
	c+wymqimua5Pa09vqF7md8OkZpxvjcc=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mEKyKVNs;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.172 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781076280;
	b=Kt+RLEUv6bbUkBh9c1D3aoucy6mNtV1LAs5Y9C8zdPpUlJwQvn/mPJRXZ+aQKsEfJjglrh
	BdeMrkbxKuZNUXgwF9JAuqO0ihg95hLVGFKA0+Vxawc+R/rSfkicifnzvhIKNDpZ54Iwwm
	YH8JOjImecjEqn/L9eyxigzPmXL3Z4I=
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-304d4e57d33so294547eec.3
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 00:24:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781076279; cv=none;
        d=google.com; s=arc-20240605;
        b=JPRgHAcxui5VjBRaPJHOTffx4jmKEofRPJxzv0O5s33dqRcnuXnWaBI+D6bP6www+0
         3VaxOyQqk9s4KWS+FwI1PTdr6HPDUNy7lAuiw1NWNVy6lEXORBVscqFRcbOHeN7NybTX
         ROgB6VMBsWHE+JkY8o2WnHUH2xZF+ZkbcwGx5V2K2gaSIi5I85PplQ1MzzIFg9nlhwMt
         Cnwgq9EMTljYhuaprslHBe0oZaBQe1BZYctBYwFCh6od81ZNZy9+uFFz+SuHAj5oNjD9
         gmb+cz0IBau9HxgvpYB0AqXTaY1vKXmHZWf+Zd6kGS16HaSoevwJpxXr9BAEWAMrRWsw
         mylA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rf/c/xUvAcS03/zJkFNJkmBhyUqR627XeIXzc8m5gwA=;
        fh=k8faypVJcNh3Qz4H3+dTThkKIonvYjKPNgnO7f3612k=;
        b=S4Uuu9iaQcUIzqms3MZ/s7SKW7UIBftxpcsubZxu8hnqTwQlXYXCRZFmHddlXdD6NB
         3kHXFEA1KuulyJMu4UH0Kv+b0slIg209WGNbDDrYjSzdABusvKeBmP8S6N8XxltOGAsy
         pPMrRa+ThcVOSsrXuTAP66nrXQWf29RWDzUTGBfi2xYwrTV2uEoOSSHfLIgHHfdyAas7
         CKFMKyHYiww760gt06NRVq4FlMCyxsOecSXVuTDmJtQ+crk/6ANDGMvQB7QVK0Zfdkb1
         PpHyRujxEnba+IHNVw+SeM8AvmHXtrsbgCrfKScHa8QO3hm9J7Uu2miD8lg1VK2ASShY
         nzNw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781076279; x=1781681079; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rf/c/xUvAcS03/zJkFNJkmBhyUqR627XeIXzc8m5gwA=;
        b=mEKyKVNsUq7XPezZ451KQxg8GTqRJ3WllV9uTGSprokuRfa2mhrW+u4kU7WvFNtG32
         /hxF+saQSvKbDJcL/TnqC+jP58zdHuExjBz2H1AmCk19VsXp+68YnMHaEAPRs0M7faCh
         yvDOHwUOyiRi+zgNwpiCOH9qcW6eAX1NQ3oMWzoBPFGD9tMMux/mUX7tS5h+FKTVyFQj
         U+GsxLb+fvbwIdDZYAsvxOXk6sHoTGpJExXTTjW0gIYwnpAszGDEpJTUMZN39+BzUgcX
         pW+Utz9l9HzQIpTCGIv5A61FvBi+dUpNzMxAOA00U4C+C77D/550LJKVOhQjIGHqPVBf
         9y3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781076279; x=1781681079;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rf/c/xUvAcS03/zJkFNJkmBhyUqR627XeIXzc8m5gwA=;
        b=l/itRM0QOfTDYvqOiC7kwLnyn0eMJJHB9CfXR4h0//+m/fmIz8/Co32fUM1C9DG360
         6lEdPMBjsSJIKX2wadORkD+Z8+mSI1Fuvgcy4cCqZV0zaoVH/dLIvmIVjcWt7HKH9e2O
         pI09Ul9008UyqwPn39xRyoFG+cxFNLmw1HwY1y3E+XeqsaFGeBfDsQNkolvCdQ76844C
         IsjXAuz0RKL5MG1gF/++3XynVfTnWLyEk00H5Zgd/f2hQfC6cPa0yQCck9MSIiWVKa/8
         QJ6p0UaErkRQEnr0G3+GFhNuEvJBRi/XvQUYC85lMM1dVleOp7lIWoWiiagaQ6YjPsK+
         q+Hw==
X-Forwarded-Encrypted: i=1; AFNElJ8PBaOJCPYYhSEcjtRy3hVrEKopzuofKVJFYpSToJA0ifD10EMlsZidwU4eZRbUAUk1ZSXMLGgFtw==@kvack.org
X-Gm-Message-State: AOJu0YzalYGsaarDsrCw3ktaWnj+VctLU48EjHmUafVLjCqFv/vKmrH0
	TAcG7gN7YS7AVyTfLmIF+/mmhPgDhjWLYGK/RZswrUThhEkUsYFzHmbriWfcAQIytfe5TvGBL+N
	+qjvRHr7nAdgTQS4C00JN+1WDdCpEJZI=
X-Gm-Gg: Acq92OFYKQRRFLgaWxl5HbtGsRkfJtGuRwgpDiMWt5dBX7U1bMf3BG4Pyv4GhN4PJzE
	A+KtMjOWcChNeVAjqo7LQadez6XB0/tq73AMTfrqiR0Xl0imC+Dd3FYF4slQHu+cYY5QtGQ4Yuk
	ANk5Bjrsgs0A+cAl236yEwx7j/NrPxq7rbyt5Mz8BYlvtE9EdSFmEgAiaCJh1GiOax2coDAzmaC
	U9ETAAA977SkjXhTrU6/xDpup8/5X5feSGGSCazPLy/r6tIWqVziU4GPpcjCLY8BRpqIK/OwlRt
	DY0GeFva6Brd5j9a1mPRclbQybGsFIJJgUuSm9gKMiFjyMycLef4FvBOJTAxmzAvE/gl5HUx7/z
	aycRntgC8EGw8FD81u5AnYrDWzp3U2aXIFQ==
X-Received: by 2002:a05:7300:3b07:b0:304:9b4b:3b9 with SMTP id
 5a478bee46e88-307d602d73bmr1982949eec.6.1781076278814; Wed, 10 Jun 2026
 00:24:38 -0700 (PDT)
MIME-Version: 1.0
References: <20260605-page-additions-v2-0-03f04c8fdbbf@kernel.org> <20260605-page-additions-v2-1-03f04c8fdbbf@kernel.org>
In-Reply-To: <20260605-page-additions-v2-1-03f04c8fdbbf@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 10 Jun 2026 09:24:24 +0200
X-Gm-Features: AVVi8CcJk4M5vfxHb4jSqPUTv7a1Q71ZMBg6Wn623JR3CU4FY_KhUqWoN71EW-U
Message-ID: <CANiq72kZQxLEXnz1U7K82TZJWYUF=8f=wC=RtTL26ADfr9RQJw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] rust: page: add `SafePage` for race-free page access
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>, Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Boqun Feng <boqun@kernel.org>, linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 24F0E20006
X-Stat-Signature: 61caxxcgir9zraxgroxe3mgjfm9ek7m9
X-Rspam-User: 
X-HE-Tag: 1781076279-653698
X-HE-Meta: U2FsdGVkX1++yo7gGSIlVO6S767lOOvq06V6rQMwt8Oq2C3k3zsVRoMJpWzXvI+NW1liImjLRkroLxbn/cs6OsZg+wj2T3RJj9vOFMok4o89GBCVuJJRdsGDwYpCGUYbRI1A+WZtNHrElDCyMADAFqjjEU+mLDILeedGjR5sD0rw1XCYSs+NQmTyaPcFKMsHvWzJeb/DHA9cA2h6fxGHfRC5kIHFgVubKqDfxY7MKSDuKnxFaExdQqrOOBaZAbzptkD/OP2ONfBPjpJpuajLiHNIQFwXhVK9AkV3sHdCWVb8myf4o2MtUjDpCIT4XR6F0gHpSVNpMWHXLizTE3FqRvcU8omDV3haQbRfRA3VwlyjxOzx+Uare1KKoq2gcm8I5jFZe/P4dfG06rfFSevqErDcAfZNf5+W/CG/cwGERyll4CCQjUkwhkK9LYjPKSijLdBDRVmh+HWTmJoKYhEisuqvRVQdzkDcRvWQQ5ESYsQv/UQ1SnlzvUJTi0FMANp7XlN/TAwvAxdkgYu2k/rw0dR0A+TsEtyj9Kb55Fkl5KlEfevDjuQAAtgfhbqwGliIAFYK5vAs90MR8v36hTW37coYJMJFsnmEQJgxoAvL6SfRADG+/hPl7Vao6iRzOs5kzkQqRjRFVwJi96QBkFXN7R5QcB6zd6wa+MQ0hbMFTXLuaHnDDDJBZB0kL2TdrDtcaUUAzp+qAHbZMUz0KMSNIxyaW3BQ8+2KdIRPiDLZOSoQY9ML9ai0ar6lZj9obE+ueqMM7m87lwGL3oyP7cJ9XeG9Rh75u3w9BLFeuuGlWcXhic9eY5EE7f/DXp3absO31Jsh4adhncY0x3sgBuSc4EeCp6r0d4tqZMYHwRz+iJuABWIt38dvygHm41DrvJNbvR93jjRzPUxWhzmAyg0t6dlG+VpvUgTImrBl+m+lmdq4eCLqx29onYSwO9hydr3dtK07g7mbG8FjW3qTz/t
 y//sbhZ4
 l7Oq4WZp1Yuc582ruJUJLVbsBOUZUftRdRBKvTaIGRicuiWiqUlI95PTLCayLplTlPh1hgGCiFZ3c2hA6aCanNNeKTLRT9INn/uNQect0Z00z21DO8bu5bgnICikIQ3/9O5pyJxA5Cq+msJoDiRNo/gpi8kKNU+G8Cuy97t5MxeaNLDMmXL4gvaW5oRbfpM/ML81InmhTjW8jXZ1D+gE6ghcEonPljLlKRyDWkL3RfBkFAcaYtGQocS4X4S2TpWTW8RC3omvUWq4mZip9O5jBw2Mxqn83OYqYo4rf6u6PwWWHtE0067xI+sTTEMkUbHAczEdgpXtBGyAK6+ZqO2x45pzyFvvLfERKD5LhXQrBjt1cMgrFo3YXa5VycLXrSbSPOtmI0CZ867yM80I/hj8FlGn6bsYi4gOJtQaq9Bqq5G9iLARCNP2lTkakdHuJ0rRQGBvavqh/Hsr2Js95rKyp2LHHvsHE74XiSJMcRT4w/QrKVZgPojxjrMtLSZkgfXVtgWs9uTehTveMS9u1ENo7a6iepJ1fBrubDiVj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 5, 2026 at 2:49=E2=80=AFPM Andreas Hindborg <a.hindborg@kernel.=
org> wrote:
>
>      bindings,
> -    error::code::*,
> -    error::Result,
> +    error::{
> +        code::*,
> +        Result, //
> +    },
>      types::{
>          Opaque,
>          Ownable,

>  use core::{
>      marker::PhantomData,
>      mem::ManuallyDrop,
> -    ops::Deref,
> +    ops::{Deref, DerefMut},
>      ptr::{
>          self,
>          NonNull, //

The first hunk fixes the imports, but the second introduces an import
in the wrong style.

I think the first part should be in its own commit, and the second
should be here but with the correct style.

But I just noticed the first part should also have been done as part
of your other patch I applied yesterday, so I just rebased to fix
that:

  dea66841b9f8 ("rust: page: use the "kernel vertical" imports style").

Cheers,
Miguel

