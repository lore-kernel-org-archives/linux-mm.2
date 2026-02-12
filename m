Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87B01EB4906
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 11:20:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C56736B0005; Thu, 12 Feb 2026 06:20:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C047B6B0089; Thu, 12 Feb 2026 06:20:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE65F6B008A; Thu, 12 Feb 2026 06:20:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9AB496B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 06:20:12 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3D1451607B7
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 11:20:12 +0000 (UTC)
X-FDA: 84435560664.21.2C63A3A
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4169A18000E
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 11:20:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=C3tMKIKI;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770895210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uuJZ1LL+pWX0H8ov90r/VJ6P5HuHKOKqyZW4flS2e6U=;
	b=22llFyzd/Efn18TeieDVclxODfrLjfNykiDKUsKaX2SAWEPgMGJufuzRlnsGGDzfM0hVpb
	L3nUqgnmxw2D7OzRBImS8DMsCvzeEXcVBGwQv6zvaucoFVkD75bKSOOR0pJoiirDfV7Jzm
	XAj18MJb7//C1G22+cI2QxLQukqqY4s=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770895210; a=rsa-sha256;
	cv=pass;
	b=Zw1WJbCdW4ItStHR+ejJWdAb5iZOoV3qKCGcTHV6ioVZpIg+BZaIkZJwwETYZuONgkytky
	Xnj0HrV2WUNFcmuZpPQDNxsxKmq8if383D+MrL0Uia1GLBHp2nrhkA7Drujn+wdt0HgEaZ
	EOEf9x1VlGHOU1X+BKZ2id3LRM2vQ9k=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=C3tMKIKI;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4801eb2c0a5so74380605e9.3
        for <linux-mm@kvack.org>; Thu, 12 Feb 2026 03:20:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770895208; cv=none;
        d=google.com; s=arc-20240605;
        b=Bwu4B+9dYOrvHUI2Cpc95dr5a3WJIwMNXmtotKof4KxlJaq3dJXJgY8IIv8Q9yQlie
         xa3khOqhzr44w6n92Do8TCdQ29DU3vRSUAu1qAZdV6O6Q2ozzih4imn6A5PfNJwFAVPB
         eSG405FcbZ8mlIebq2zycjYG1Q0Z8Ad2PQ6rxkD8zOTs0qLSuPBW0usy3p/y5d9Ts+vc
         xsL8vuRjhu5DLuFEXt/iES51NNggyjeO6/b+buKEw7xqFPxNFohkf9CzQ/DDvs5MZbJh
         Po6cTz4lcxKoRqJA1PxD+LHM+00+AnBs2A/xyj69NomW03Wx2Itiv/EZtDDzIUmQVKFD
         y2Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uuJZ1LL+pWX0H8ov90r/VJ6P5HuHKOKqyZW4flS2e6U=;
        fh=ws1Rkuqne/P5m51Cq8tbWsh5FObX+T1eAAjGQ1wCM6E=;
        b=kudkT82kjEBJH5pZG+T6rk+12SbHYthjCl6ij4HH/ezf+ibLu3cKG0+Au/56UuYkg4
         Lbkcx6N6rNm3n+FJhWQMRfHtf8MN68f6S8JAv+cBUPpn+FIqqaa0Dxxw9BISFYen8A3L
         RshgKV/kFVWz9YqXbMUP6yvkKRxFcTPCfcn7o8JAobPoglrK6GRWjP9KDcagf4Ei/hC2
         cWi2ESuw4koADsjBSC+sRsXEjkF8KRV9Jal5tYRhWO2+VgTURzCupGeHXSQK2250X+XG
         p+5HmoGHbmNoiH9Xpfpu4/uScSdgFspoAT+NlGPC7zC6S0OwGGkBuK/satIBix2JX+4J
         WzFg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770895208; x=1771500008; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uuJZ1LL+pWX0H8ov90r/VJ6P5HuHKOKqyZW4flS2e6U=;
        b=C3tMKIKIc4RttKT8jl8/MQ4MCQQtpGLDGidNKytGneMuNhyXsTBSiTd9DElQ1KL7ww
         v2R08tNDBEJhnSqgXiOW+Nwue0/uDGJEwE4Qb/KU5vaeIDIncrwWArhelLciN92D2w6V
         IsNnTLjw5RmV2Z0QNrDzPsuN75ZVzhOlqS8GbscD7WbiSlhSsvM16brH/tYnjeO1Kh6n
         Iyw589/GpkyzzoDJokDqJZqwf6HGzkOQdPDG8IjD8gLSt4i0mL4IOg+xyzS2r/j6hxNl
         S9JhDtl3n8KZPDf4XroVFkEQhEleFpZbvgLhegbkLmWAHS5n3brCIUXeS3+XXxmt0FdU
         0Xsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770895208; x=1771500008;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uuJZ1LL+pWX0H8ov90r/VJ6P5HuHKOKqyZW4flS2e6U=;
        b=FKeyefhHA0iVI36wFAnwcqnlPeqyH3ggfTtDBnCK9PPDoE0TuImkuWFFbwwf0S1Qdn
         4TS9tvN76WSkkYpTC0GUfFKNJn2J0fWMYq4ZvDzYYWP4o4BGyoDGj8VnJwCNZ3EQNXk/
         /Oav8gOlr9hAWz/Pu5qGslz51jPF1V81GxTtvkUggG3j1jw7WWuUcDJ010Fdem1Qi1e5
         RrIfm5ODj7XJJcV9j9r4vAfPMMxvlYo7/rzBlsECk1C8iCkLvWF1pLXb6cOrnmwGgZDj
         G8oxbuEYnmR0GcK4KKYYhMcNFvgs5idRVC9pvr/4THvduvqXqfJnNHddYvDUkSKliuM9
         oyMw==
X-Forwarded-Encrypted: i=1; AJvYcCUUFZPTpaJIAu2FWbZBmlMiiwOJAPxY9IkieRz/fTBxdgnIt5nGzC5Rh37MXirCZI1kw27I4sepxg==@kvack.org
X-Gm-Message-State: AOJu0YwflDIK/eOeZNAa4rathZimp1I/MyMNLPUzkmckbnfI9e6nH0SN
	kYSdSrnHb+3AOxttE7JwkDr5cIWjJyrjKSmLf4tGa5FT9cMiJbqBeJeUbd/jnD/ZYhJ4/4IyL4I
	Wgs+gnzhQrb7V0LNkYupZtXbGMbCGrnqGJroGN8MI
X-Gm-Gg: AZuq6aIFPMzpcKK2+hYo5o9lIhHq4KBqE39e7dbP/0bo4UGhRrpYTUBMeNeMvp0O//r
	zLX7mJ2U2V0LDmBFRqhWfwXEvJt3UPg8YZJyyDK5+ZKznCXCdLN9GkTTO2suyqqkl8GKnUigsbW
	1VUrWjHwt9uoNm/BQ39VXDEq9rOLW+W24CGqqR1le45iXrwZwzk550hp5l7X7moyGwp41+C5AMF
	wdZn9gKwrLHecHatxGxCYOT1G4fo1EfOPxWK7BNEQ500lWTV19zOvzmKhF6Fps68Mxh72V6Amll
	7thkI9CSiYx9LABvSOEHxuvqMPeP5RTyC6JBh2u2U/8aBk2LGkmP+D+ss4B/lswsxjl0Zg==
X-Received: by 2002:a05:600c:a08:b0:46f:c55a:5a8d with SMTP id
 5b1f17b1804b1-483656ab4dbmr31192355e9.4.1770895208246; Thu, 12 Feb 2026
 03:20:08 -0800 (PST)
MIME-Version: 1.0
References: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org>
 <20260209-xarray-entry-send-v3-3-f777c65b8ae2@kernel.org> <q43rzzvpfh6ke74eyn3nypiek2ihaq6nat552asiobqge4vxmn@knwkb5dexnga>
 <87fr77viat.fsf@t14s.mail-host-address-is-not-set> <fU1FEYt6-SY0KlyJy4VClCr5j6P4d5-wukzc_9TkSDSBuQNlY26xyOIprMbHEVMv-H-nrAJ1iN_9tcfIXEI1iw==@protonmail.internalid>
 <gta2wjt4tkcvyu7g56gqyipiigbmbk2ca3biqzmxc2npch3rk7@ccwzwgnk7mcz>
 <87y0kytggx.fsf@kernel.org> <87v7g2tesf.fsf@kernel.org>
In-Reply-To: <87v7g2tesf.fsf@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Thu, 12 Feb 2026 12:19:57 +0100
X-Gm-Features: AZwV_Qh4Uvl5z8msbaXaL0Qyn41nRXBEYB1NV8RVqoJ71paHuFQd8_cFVxm_IPw
Message-ID: <CAH5fLgjfSWfhUkmG6_ugue6Wp5LKtkEFJofWViJSNByq3sO2Sg@mail.gmail.com>
Subject: Re: [PATCH v3 03/12] rust: xarray: add `contains_index` method
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Tamir Duberstein <tamird@gmail.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
	Daniel Gomez <da.gomez@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 4169A18000E
X-Stat-Signature: hwwckdodaj8he87nfja4tb3ts963o8go
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770895210-458895
X-HE-Meta: U2FsdGVkX1+DEjS9xhPyXwSXKG557i8LtSLFgpHjqB8p1KZsKg0HQgtdSKXfTwsGDqB0Qm75ntVRCctzKIPXvM8t6XzO/geci3Z87CWh5hS3/dfnsQRtCu+GW2cLGFReAEWXkLgfzg6Xor2CrUrT0IgoP7uJ8WkRU0b1jJvqhnnbsCeEi4LoL8SFZr8qeAOwQQ2Oz1Ol4s838zDrrR3qBxafc4T/vi7LmDJVCG3qv03Li1Qfv4s9xpgNQdy7BVYYahiqymiOHLlHWHzL/qxuE+W7x/CsQB8FPDSDkXd75jYwjnfftk7KxDFz11oPOxlq+ONvIxJ+9SA9GQweQJaoqnXTPW8hj2cejqYPRKuR1UO5PjDd41OsQ+yUG2mEsU8bxiyEd5maA+/5lGDRdN4DbB1PGkT8WcNhqRdTUT3RZuLU5sBplUO8Vll4NzpWWvyJZ9Y3rg72LgQdgDyZMu4tLKLPExGG+eOauofjUWvlOBxk1GLCRN7WRTOMwWedORM0kCg4qgQW/fsyJFOj1wDi8RJUImZBqkSwz8CRDjuDuITmA8MPn030aPxK4tX6dafNeO9MjkGFTwmYipbEzQ7P2vlGUGTRS6vRTd2L7Gzn+XdhDpBCMTmVkOH2DiZua3aFsbM8HLkvd3sIjS5QruvMdUgMWImbjqmJsVfQdYXOiMqS3x2k6t0zd8Dkv9Ax8hj1UVmAoEbtIiuEtnMi94J73kEhd2B2Lo3aHRHreTExi4/oj44mJVRMRFGYKU0s7l/H3jxhIkD6rMKRWWC5e4yQv1NMWN8Nj9LjN5bXsn5BVZqPqC9TAQk8BpxKAf8AoruJXxc9rSkgMPZe5X0Wa+UZfotWe+lg3TX9qHkdD0pYvLcpc2DrvzyAfXHEB6TzeDvUpDAl1cf4iAx+sUxTBTo1SnwYgOcRcDjEF/b6Tu2XnSU6fCHA8V7uDy137Se+MMelHJ3S/BmalzCmcUV/lI0
 8G7sIuec
 j68uHWlHmh9wJku8XI7PxyJoKf/8jy19piEoyadNCk2jifCBAGUSAh6h+GnqXz04TdsyhA2Hpq+q90KSaEyKtifrJNQ3jX1C9XgTtKmwm/jbR+DmlNjeEYl0tCjm7UEoe8m0Mx6gCoMsQ3D1ATzt/mWoso4dby7AGn9ZYXMseQkaunU8BBmy9jyKGXXUHxFmqUOpj3l1Pb5s9HKmfVgOywh+lkFg1XUW0VyEVsvjPdn+e53oW2xZU9MN9/X7518sX6JB65W1+b8DYE5n7ZGTLOoA+gICpdH7GU9IVFxfeWO7ckrev7GFTcGdagCbYXWiG/YWeW20D3WieD41GfTyt4kM/QQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 12, 2026 at 11:52=E2=80=AFAM Andreas Hindborg <a.hindborg@kerne=
l.org> wrote:
>
> Andreas Hindborg <a.hindborg@kernel.org> writes:
>
> > As far as I understand, this is a borrow checker limitation. It is easy
> > for us to look at this code and decide that the borrow on line 51 will
> > never alias with the borrow on line 49.
>
> I did a bit of googling, and this seems to be a well known issue with
> the current implementation of lifetime analysis in the rust compiler.
> Apparently this kind of code used to be OK [1] but the Rust devs decided
> to remove the code that allowed this, because it was causing excessive
> compilation times [2]. The upside is that this is solved by the new
> lifetime analysis implementation called "Polonius" and it is the
> intention to replace the existing implementation with Polonius at some
> point [3].

I believe the standard fix for this issue is to provide an entry api
similar to HashMap::entry(). See the rbtree for an example, as it
already provides such API.

Alice

