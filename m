Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C949CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 21:22:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4BB08E0016; Fri, 22 Aug 2025 17:22:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFD148E000D; Fri, 22 Aug 2025 17:22:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC3BD8E0016; Fri, 22 Aug 2025 17:22:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BCBEE8E000D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:22:39 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3A554160364
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 21:22:39 +0000 (UTC)
X-FDA: 83805667638.25.25997B4
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5500314000A
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 21:22:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=S4uR4U5P;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755897757; a=rsa-sha256;
	cv=none;
	b=YvWq1Ko7yTG1naNvXY/IHKK/qFHHIkCbyIbvU6/HTuqjzuP9yMJzg9VdkP09YHAjJ4VoMT
	PheLnnchDpgw0cZCuzlJymkaVfnQg1k7YGbRKOCd2o+Em8DoLn6SJe7fTOW7OXxJ8CwNQN
	LeD+o+EUMluThpo3iJaRyYIvULbhp7c=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=S4uR4U5P;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755897757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yzhtckg+e3wTvW8hXR7uEUObm+QutKm6afWZX0VLa3w=;
	b=nCj2g5Y0ipzExnRfyvAVNuHMD6TVE0xE8Z80ykc4lBzfE5e+6mrmV01rE8eFp32iQ8az6w
	BNi+ehX4VDQXfqDwjKTPGElie2MyDgYgqTLi7wzVORK0w6o575VAdAlfx7CVGzlIRdVXHT
	B67qucPfhw5E0k7Xf53TZ0Nrcr5LXZ4=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-24617d3f077so3055575ad.0
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 14:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755897756; x=1756502556; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yzhtckg+e3wTvW8hXR7uEUObm+QutKm6afWZX0VLa3w=;
        b=S4uR4U5PMmmyE7kj/2HkWADuX+aU7PiDvbwWD0q5YEXuh9e/YNrYeDnV1J/TNTZ1Ow
         gnskjVhCVEW7rTOjDbZGFpMYNUzWw2Vzs89iJwU2BEX3n9s9rFqR2GwEx6BO2QDbbEpI
         r2Z4xFaEEMdhhu01Te+nFbYl/Esj76Bt+Lzj8+9NnYI9ALSD7uSJZfCCebzAJ7nsrPT0
         kvnoJEQda5T3Z4fG7aeLCh/1/3dxxhplw19qVmPvk5LkzuNnB4rtxZOYbumoaJC8qj8Z
         pKUDwVEB31DGiAy2nKBFA/IWlD3sBDeR/P9pkk0FftFcR5re3/C+3DIXRZtImFL5bJjt
         HOzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755897756; x=1756502556;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yzhtckg+e3wTvW8hXR7uEUObm+QutKm6afWZX0VLa3w=;
        b=PtzRG5hjoWHS3f5E/D0r3wIzk05v9bGUTbBxAM0mpH0F5VL6E+ByTTDX6Hm+WU4UTG
         YGxs4hic1BE0NNbjfpUNA7hsSe4VvIC38xKuF+WnMMQ7pxSivLcGV5Vv94j+iiS4EVmG
         fy56UuV30Ci6Ubshe0ETiCB4xxYYg1JjJsFHu9hG/TRy/YNm/dvwy9Y/NWW+H2d2Ce5T
         otkwJh1adbCJoJG8Oz3dEtLNm5Wn/xeHpGS/xWh/p0/vV+ATVpeQdbPvltluh9ZMH8tV
         9OlUTHCYJfCG3ZckwgMhEvQdVb3MQilcddtga3BkFVo7mZHD6df0OXotTiXuJZTjT3dm
         kJLg==
X-Forwarded-Encrypted: i=1; AJvYcCWxF7+qECSPrR6HjemS/CTc59bvROPbXsFYqbJKk/FjFpe5RaBIQh1IKp1Gk6XA81xz6k5KhbXDCA==@kvack.org
X-Gm-Message-State: AOJu0YznrpqpnlqfzOp5jIRqZVLV+v/n0sd+m4/vNAMZXUF1P62578J8
	Trd/y8mj4KLzFE98+hl1+yQWsk/bxkxhrVi1E7BIaZBt9QZPmBcDCxFSFysxsDlNuiNwO8SfvaE
	+o/aktVw6Rb8PZ/0BjCwoq614ddg0AFY=
X-Gm-Gg: ASbGncsQQt/uPLP5Qwzv2OBKigrjvjXbEt7L0xTBJxeOFhobL0oqgYsCUZIEN8BnR6v
	qUOyOMMwggFa3KBmje5obA0c28NTKNETV3SIwsIC2AVYy0ExRDA9qfeiwDPfrFhN+qzjJnylIL9
	xqg8DTaXl2bLZtFTwI+QVkFcEyHQi31QuA076nP2uNj8nzqLOxjCpYLbRM9SLSIGrT848awSntP
	TzUwObqTu/aMuzXDvf7OfXfd8Qr+557o+HxMUAwvDcRyvkLd9RJ/qV4EjpgJkBDwHXXsdo2wrUy
	edZAi+xTdN/Lms7n7Bk0/9aE7w==
X-Google-Smtp-Source: AGHT+IHpTLoLMzrhDTM+fR6j+pavoy2bgPuI5ZiAywuOKGqjCTxDu61UbwRm7ObkpkhJJWbvMkHdh7mew6/Pb/9sLu0=
X-Received: by 2002:a17:902:c402:b0:246:7702:dfd9 with SMTP id
 d9443c01a7336-2467702f08cmr1356055ad.6.1755897756025; Fri, 22 Aug 2025
 14:22:36 -0700 (PDT)
MIME-Version: 1.0
References: <20250819-maple-tree-v2-0-229b48657bab@google.com>
 <20250819-maple-tree-v2-2-229b48657bab@google.com> <DC6DC244ZIUL.304JSP7JFDE9Z@kernel.org>
 <aKRx8xsY8CpzbeEm@google.com> <DC6F7BN2L19O.1APQU9KWZV7H5@kernel.org>
 <CANiq72=xdryEKzo73-1vaBqGNNme2kRU0atP5PYOnOOXjNxZZg@mail.gmail.com>
 <DC8WOHIEAHQD.21VWTH8VI8QG5@kernel.org> <CANiq72=ZZ7+tMi_XsRKunGAqm_v+kehFqzpEMMqm2qcTvzA9Mw@mail.gmail.com>
 <DC8XIFWZN1SE.ZZP90D2N843X@kernel.org>
In-Reply-To: <DC8XIFWZN1SE.ZZP90D2N843X@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 22 Aug 2025 23:22:24 +0200
X-Gm-Features: Ac12FXzfzYShObxnsby6Cr2atstzxQL8aJjurXwQXu6DbRAE7q9OgPyAk8odYRk
Message-ID: <CANiq72nJiJ4K6jy17x-YRYnJpjqTnohYWvoFrLkYQp0X4tLL=w@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] rust: maple_tree: add MapleTree
To: Danilo Krummrich <dakr@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Andrew Ballance <andrewjballance@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, linux-kernel@vger.kernel.org, 
	maple-tree@lists.infradead.org, rust-for-linux@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 5500314000A
X-Stat-Signature: te519e49qux17ygiqsmgsrmhds7ogci3
X-HE-Tag: 1755897757-73916
X-HE-Meta: U2FsdGVkX1/+g/x7mBy7e3h83cMqWaop2X+8o0oRLFSVKOc7NecnDoVY5OZakpY2jIpVx0A1HPl+X86g0HPiIWDDD2QSzCD7UT4kvKxPFTgXgJIs+RmMSW2nA2DhtNv0IBex+KlDikNEwINqvnutCBz2/DUOYKet2eSv3aWYnG256rh7m4Q7uzso4oZ2ORaQ4YOPOQbevC5EHq0dGcGVpTJm2XywkoJFIkVmwagzXVd6AncLjjAC2peyGwNFgnFBZ8N67u9uKQvLT7kd1ldxttih0n2iKBXgOzQaBGzpTPVFK92V01QEJ5HPlOBKM0Dr7tk2EgxdVRC/4s4yG917xHMVRh9TJrHZbR4Bh8Wirroqyftv/VwitqYsTeyWgTNMjWYOSj3lF3pH4mvwv+PUk68JFhspH7/L7bd9xZtJPCTrD0zTMMTkw1uZVIJgRIPgeMPKug2ehv/cI/2L72Yi3dcZLDdtP1L6wgy8Qh8DT6ZNvX+N/n3u/IcQ6fFBK+DqG8iggZmF5FO4w8wBbZSAZ0KDz22o8Lbky1oYJoBvuVWY+gt4+fZZngB4HMGBsNPQBw2N+LCr8Jz3fsoj58WmMTfIUb1naAv8BXByD2t49OKJEJ1d8CZBNgMgasLhIetIRQCqBz9sg5OnttWA/jCH85AJzPaVc6RUamqqR1zowvang0zpgSDoJOtlMwm4PkjieBGDo5zR+ZS2TvRxbaL6fkZhEHKCCqLBcXVhu+1yKh6k3cNTc833bbtAnEopDYBJrnqzMPvVpcAXkWE1spfVbKIC0oP1QVilYdEQYtHTfGyiCFRNYITVHoYMKEZUJPbxTcSobArBxw+tP+c0p49udkhkFOAXdLPW5D02lLJvLNahB9uBHKaEm5rPMizyQozVWGRARoOW6hLjl+Q0VXiES08ShVEq+LBTEYk10h+kw/isNHCraIXDnu+t2xkImSi9+fRjSQoZa8IQCDc1sCQ
 kK7NLIz5
 85VDObT0cua5viULGU2cPOUV5htSMT4xnQixf4WZqxZkxtNYF/yCcP1+ceu8CY/5Jf/DvMzLWoJfK3pucfnyar8zjv5wT77V5hfRF2X8MDeV6pLeDolHw5SuAPYQthP1sKJqK66mnTr0hEt0DI//huiRSPHk5J6Soah0nl1sJsYkvXPvMXD8xQc6bUuEw8NijeUlSJsJGgvTfpm1Ph5Uj2c0cs+OqATtcBdL4ot+bNvGE6vRf1BNSx9F2mDHDzLly/JqcEA1yQ9VVLtlCaFD6vefxO9NcD3daxKaxTQ0gkEqGROgdJgXpl492pjXniThhdyAhEGzLh6MTcpD034sE+LKdIfZbG+XCnQNRBldJJqLqNs2+fD5GCW/kmqor8RQvYVi2gJRu+sqgonWBZ6+C/pCIiv0KWEThsNjjuQEcgmwqM3iQ5ABPCUtUFRA1M4FrnzTT5+5ZE14ZmHXzlO1yQxW5uNN4d0dLaGy1hxqwyeryROutHLrGUBef/2ZURB62Qwz+CCMLvpUBPDpkuNQeCHXcBR0XVF/4OIhtd+9oDTtfsrDIOLx3aqlrRPaWBj8kZV+e
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 22, 2025 at 1:44=E2=80=AFPM Danilo Krummrich <dakr@kernel.org> =
wrote:
>
> Why not? I mean, the above is cleaner and more idiomatic with or without =
the
> lint enabled. As mentioned, it's even the showcase that has been picked f=
or the
> documentation of Result::is_err_and().

Is it idiomatic, though? The example you mention comes from the method
itself, which is of course the obvious use case for the method, but it
doesn't imply other ways are now not idiomatic anymore or that people
have stopped using `assert_eq!` or `unwrap_err()`.

It has just been 2 years in Rust, after all. And, from a quick grep in
the Rust repo, it doesn't seem they have migrated what they had to the
new one in that time.

Also, do we expect to use that method in normal code, and not just
within asserts? We haven't used it yet

As for being clearer, what we want to assert is that the cause is a
given one, so `assert_eq!` seems like a natural choice (and it isn't a
case like `is_none()` where there is an advantage). Plus it means it
is able to show both sides if it fails. So it is not a clear win-win
in my eyes.

> But especially people new to the kernel starting to write Rust drivers ma=
y not
> even be aware of this fact. If they see some unwrap_err() calls in exampl=
es they
> might not even thing about it a lot before starting to use them, e.g. bec=
ause
> they're used to it from userspace projects anyways.

We still have the issue that they will see the `assert!` anyway and
thus can easily think panics are OK. I understand what you are saying:
you want to minimize those cases anyway.

> I think we should do this; I really think otherwise we gonna see a lot of=
 them
> once we get more drivers. It's just too convinient. :)

A potential middle ground is to apply the lint in normal code, but not
in examples.

Or, even better, we can actually only allow it within `assert!`s,
since it is a custom macro I wrote for KUnit and not the real one,
i.e. enforcing what I suggested above [1].

Another one is a lint that just affects `unwrap()` and not
`unwrap_err()` -- I think the Clippy one doesn't allow it now, but we
could request it. It could be combined with the above so that only
`unwrap_err()` is allowed within `assert!`s.

We could also go the C way, warning in `checkpatch.pl` about it like
it does `BUG_ON`.

What I like about the Clippy approach is that it can be locally `expect`ed.

Cheers,
Miguel

[1]

diff --git a/rust/kernel/kunit.rs b/rust/kernel/kunit.rs
index 41efd87595d6..86ea37319f7b 100644
--- a/rust/kernel/kunit.rs
+++ b/rust/kernel/kunit.rs
@@ -160,6 +160,7 @@ unsafe impl Sync for UnaryAssert {}
 #[macro_export]
 macro_rules! kunit_assert_eq {
     ($name:literal, $file:literal, $diff:expr, $left:expr,
$right:expr $(,)?) =3D> {{
+        #![allow(clippy::unwrap_used)]
         // For the moment, we just forward to the expression assert
because, for binary asserts,
         // KUnit supports only a few types (e.g. integers).
         $crate::kunit_assert!($name, $file, $diff, $left =3D=3D $right);

