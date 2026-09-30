Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00855CA5FB1
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 12:41:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F4CE6B008C; Wed, 30 Sep 2026 08:41:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CBB56B0092; Wed, 30 Sep 2026 08:41:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E1516B0099; Wed, 30 Sep 2026 08:41:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CF6AD6B008C
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 08:41:53 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 59CF31C36B0
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 12:41:53 +0000 (UTC)
X-FDA: 85270390506.22.1442F78
Received: from mail-dy2-f43.google.com (mail-dy2-f43.google.com [74.125.229.43])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7178B40004
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 12:41:51 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fyWQUw4n;
	spf=pass (imf12.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.229.43 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790772111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4VQhR2B4f6Hpo8/6oGqxTMWg9JuHEuKmXAqVeCtqT38=;
	b=RRJJqZq5ynaJCpMaEPS+X7I1bQlBqfiqf03C3guhmlOaoSkkjwLZAhElUGw/h0UCF9shqy
	EtwHpslAVvX95U5AfxBqm7R8FbcXZqT8n15OWcjwLq/qxPhTutu/jtz6sb3mLtYF226UX+
	hG7MMLYvwyT0LfzLlBgIshr2kv9uc0w=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790772111;
	b=OMLwGfd3a9DiY3j+MPiecrteGRR2XOa8f3wZg7YGkdv41uRzqmdLx/TKY75JaYJsWzuZ7+
	gTf4FB7IrxCCKcx4nxsKg2QWB7P+IYYCLF/5pkHZgEE7xoDrgpzYBwp0a25XC4FtkzJWLh
	zAM6ljUMbOk8LeLnndynshUmKwKtXw8=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fyWQUw4n;
	spf=pass (imf12.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.229.43 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-dy2-f43.google.com with SMTP id 5a478bee46e88-33e79c06622so570146eec.3
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 05:41:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790772110; cv=none;
        d=google.com; s=arc-20260327;
        b=AhfcRRQj810RVlXFDhzMDrgH57X7OUcRtoyA6VCtw2FJzbnX6BiRx1V3UyEzVd0lTp
         LEzVAbxoiBQRnwI8+SXOOSLV/HpLIMB7tufKXm1HE+BEycYVdkMtXKn/Z+FInWmSSUGW
         U+IS+Vi9D08eflAMN4Y3LsDXXCa/0rt+WaOKGKJwjFnAh7fpZjAtz5vgxcLJVp8t5Xwf
         6Jwg7nZj4MuZ9xBVw7OV8PVP+2neg5u1BuBgBNgFvDNLBcUn2Ohfkwc8LADIbBnEtBeD
         29wwJ0fffTHkBvgjINwXUqS/cr7mGpc47uhqJaaUZOJtQ3JyDEHOrOzfb6J2P4UxY3HE
         VcoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4VQhR2B4f6Hpo8/6oGqxTMWg9JuHEuKmXAqVeCtqT38=;
        fh=7FqWMBOkOrqZIUd/4018vh6xocsubxc+V5kMzEttktQ=;
        b=XdoRacENUuGmq11Vn1P2vXuaUcnyiBhu9NiInK3cgzCZgeqCdmPVH0ar01xjTZ6C+E
         Fj0wXYANlpAYCn92xDXFraFfoi+bF9lDt36jvfeHn1WuFwF/GZ+s3+Srylm+rIJCRsB9
         fja2lemxfHISN75qJOfoAMsoOmQ1ivUunoVnyMvUd3x9sEeSMSf0O/cLlgHiCGugEPKq
         j8P1RmUM1F6sBflJquIHxgTlVVBNWRSwm/WlPtDwJRITdDQngvkQl2eRZwSHMZ52gaLb
         Zr3GZfURC6ZzyrKeGrSEJAlKA5wpbEiYHcmUWUzy1ZOCY7WJXnh4SKjzp6i7Q2DG6GoA
         n1qA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790772110; x=1791376910; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4VQhR2B4f6Hpo8/6oGqxTMWg9JuHEuKmXAqVeCtqT38=;
        b=fyWQUw4nwoA/Ox4WrjeCGwtLxbMSUghFO295WXzU6CZKX/fshVepYFZtwZNK874JYW
         GvEyJyADjzhPQ7wTaalHG85olOkZVE22XEcoDDRQGzmVXRlJG5j8YmWRoQyx7SHjh9/M
         VSwT0MFgcI7se6sFcnjnHcYAgz002vy2ilSywrHqs5hzba3/Y9rMpD2bCC3tu2YbtvRV
         6KahGy4OJz91EiZ5WcFBhyqE5a2VNJMpwXslgocpGb8zfQrn39QJHCuEKdaG9vIPbXok
         t9d8eg1Wq4t2z4Ax1jh2R0rPBKqRQYY+pc0iNo/rljbUnBSZ5kF1aFV57V813E/FJ3is
         KkKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790772110; x=1791376910;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4VQhR2B4f6Hpo8/6oGqxTMWg9JuHEuKmXAqVeCtqT38=;
        b=qwvMuJV2RgpFtNo80NZFXsJnH0z08xzz5slMp2eHOGkPpkvJzw0qgS3Ns/MJlZmrnI
         1UqFV7XKOC3NU0+tn9vbzwfCtvG6crR7b3xrBG39A6lAlowI7cQBPEUTD8NcYD2IC312
         l0GrmL13m2MfpzkR4c0xzGV0OoFsLvs8/wBhjRjGj2A+57Vjt3LbkXgTHDP16Kx4EQ2V
         O9WHKU/vV/hQZ9amNm2ypfGJZLZafifO7IPAtAm+Gu4rXQJIdG2O7rkXOkQDAj2g9++G
         JBv63ksyh4+2cAdUU5V5IwDuHS/YZV02TLOj3p1r9VThHAP08zfPtp7P9qXIJ6aKycbs
         g5uQ==
X-Forwarded-Encrypted: i=1; AKwUvBwj6ChIyk+BjphM4ixfR+3SOMY0jpU90+icKjPHxA25BJUhX9a6ggvADO1TjjCfMXXWPpi3Q8lNKA==@kvack.org
X-Gm-Message-State: AFuF++lDx1dRbs/mby3/Ke5tqH8srp8qWLV+LUcY6di4dTyI7SSmcY3D
	+6CXu8IX0wpKViuIgYjob1VaWB8Tzb6XrZ1JOfQ+mHHZZEa1GRyTqxTvwl5ZhtnDBTTSmuf+US9
	tJW88oS7YXFxw3zQ7dAv888fquiHc16g=
X-Gm-Gg: AYBFou2ukSiQjfDQSFAzBO46aH2huDNlo+gZT3SzafDYY3IKTIjhNMwVpxlnS7NgW0r
	0Ev/cT8+UfVBueBETlIlRC7fIyaFEIUFdjxZOr1xFDzX1LpyGI+j2hs3LDpXB+fkGdbM+B1Xfjg
	6RLFclN2RxBnHazF5jQfrEiyI7ZwgY/4QeTjK3Jt7rQcXxEfDPMFOrfbsLwxuQR1syJhsBUeVia
	7m/pJC8ApaID0oQyc2gDF9quLD3yIZZwzifL9mCL05fZzylOFah1UpR7ArseokgaLRQlPWaS/+a
	WQlfD6ch4xklrCby9Q9anjo9xO1jNnAFqEdfhiZPvwADXwABly/isCQcqrZ+GQWXwWrDhGmzagV
	J1azl/0fKtMk45tKyC96reX7mlia7qP/NK24RXMbVfQnwYrsPwkZbObF+jdI3KlNCdIwwdT6gZW
	WvEvvOwou9sgTTmtNkbWKNk2N1ekvEHYMC4neLVyhlGDfURpWGlE8=
X-Received: by 2002:a05:7301:1503:b0:340:f698:fd56 with SMTP id
 5a478bee46e88-34cdbecb18fmr2552081eec.2.1790772109954; Wed, 30 Sep 2026
 05:41:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260113192949.689834-1-lorenzo.stoakes@oracle.com> <CANiq72nHOinPTuJ7NLP=X5tLN76uxzz0k5t4tTcU+pz_JOCPHw@mail.gmail.com>
In-Reply-To: <CANiq72nHOinPTuJ7NLP=X5tLN76uxzz0k5t4tTcU+pz_JOCPHw@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 30 Sep 2026 14:41:36 +0200
X-Gm-Features: AclHuK_6PgeLG6BwdoZVcsa0OSKE70B150iJ6uNX8SMscLbiFAZtE32a1FCHYWM
Message-ID: <CANiq72=bTO5qsQWqfpgm29eJ8vufBrBg=uU0vV+fpunNsVk7mA@mail.gmail.com>
Subject: Re: [PATCH] rust: fix typo in bindings
To: Lorenzo Stoakes <ljs@kernel.org>, Chris Mason <mason@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7178B40004
X-Stat-Signature: 7x9gtdgtuiqe4earcdsge4tk7bkeihaw
X-HE-Tag: 1790772111-109120
X-HE-Meta: U2FsdGVkX19q07hGtf8/napztyAdkLo8QEhqnRe1sLXPtweko+9Z4OqgXb7Xf1I+65FhRYqZxRbdVALl8nXh4zSfrJnkki5r3lq4p6jaWv2xBN/b5B2sEbtM85kq/ntk25At73uQj6A0jGxcYkYHwD2wWMHbG3qykm45FnoZdVbRlJ7W+uKDBdg3C/sjMixB3FjL45FLsg/KdeJ2UswEW13sle2jR4hlH1yKVSU+pJIY+lkQtMWhMbcrgsI50Y3sg6BGCLZxkYXlrMie6QOB+DkjN+LqjAE8xDFwpSu/HkQNMl11bewNF/Zig9PJ1MZ8VRytVSMgvD84AUvd5pAIiBzgOrmiu4VfSLRkjwPOCENdWdwP0TzPpKm41V50iw8CLOfUd1/75hmDKfsTwt2w/r/8+GbYKLwr3vK3z13ZhrTtqKEE30Pt1/y6SxwamVM/08KX7JWCgW1PDZIqb3f+IujAhohfVG7rGbTSMvPMGezYwPLAMke4Nfq9nh6wxNF3wBxE0qY5Rn26TASuwTbvHmku7HNJ9vLTeaLM2x2dHGW5C5MgImRSXSyNAbzIUqW+txtt1/HXP/MlO1SiTXLjHtEyO22t+7T+y3shG7hIXdf/YmDXfmDQgywoNB0HX9rz+MTFEyO/COTvu2av48f4vcvdQpaLLD6HYqyh6visZbG7u9felEJilQrFHktArAfzqZcNCA1aCZNYW179tm2V5Dgm7g0XPyPWX2E5OSWNv5YNfVHdvO7R6eKbQWfEv3iGr1TTzkBsLs5TqcCTMhCHilUDg5ZsqJIznOfUsKg46BfGchce9Rv593X5hQ9F8+RRfNne9EMvthp/jcNK8zVvus38tn5eCOZ6g+sZ6zlWlS5jvZ8rWJTKMV83ke3VaeTxNZ/PJcNpU2AWdmYdJNMYyFFwlgpWJaT33eCZIVzOD7Klt2cKm5Xt2lL2uxqOoqY16JPe2LHvIMMeYhoe8aF
 B84+b9jQ
 Fkz5/7hRGvVLpeONLub1Pc8ztuINFoXaqMaVfioI7NvaX8ICiPyK8ofRTNmkgJlorAVhJfxdFgaIAK6OA6v+PHOsyd/3qZLuLG5XYje3aYf8ap3N97/mzy/C9MQWJV8l7bhkIRyLTIBMjZNFFHyRbazX8MePHxmfZ+GlGDPxmAg7HlSo/1Sc8qlWtJOI11HOV2Vc3RoOr2MCxkzwe08huyFdXkNHmuCL+85m6fY855zQ9GI+44URLCzxIJMLlUMuZM5PiKOiCGg2g3Wtm7WZDKUMoQzMcSBPi0JcIUFhtUtQ1f7HXU721V2RWQclnlXQLxRmxVYkkufIL1UBfqaWR/0SgPK6jTHsx6I77TC8UV0pbJcllDge95co0B/6VTVRQ5sjV3k3lK48VIFIHtfgL8VOFoWr+mnMgLfMoVIdVGkY7lHsfM0fqwkIK8ZBTgz9HW5VAxzAY9KnqVJrwtbu4c+Ry5f5Y4QiEmMKAUbtCiX6jI2oMiV35kZCDVfQi632wKhIMQXPWnsVelMr+PDFY9uQFolodA98lMPqxzDl5WGUEqNushOYwiC38ansSBvtqHn2x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 30, 2026 at 2:39=E2=80=AFPM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> On Tue, Jan 13, 2026 at 8:30=E2=80=AFPM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > Commit 2b6a3f061f11 ("mm: declare VMA flags by bit") added a number of
> > overrides to the rust bindings helper as the change performed in the co=
mmit
> > caused the rust binder to not be able to automatically determine values=
 of
> > VMA flags.
> >
> > However a typo was introduced leaving VM_MAYSHARE to be incorrectly
> > interpreted as VM_MAYEXEC in rust code. This patch fixes the typo.
> >
> > Fixes: 2b6a3f061f11 ("mm: declare VMA flags by bit")
> > Reported-by: Chris Mason <clm@meta.com>
> > Closes: https://lore.kernel.org/all/20260113185142.254821-1-clm@meta.co=
m/
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>
> Applied to `rust-next` since it doesn't seem urgent, thanks.
>
>     [ Reworded to improve title and to fix typo. - Miguel ]
>
> We also have a similar typo in the `bindgen` flags -- just sent a
> patch to go on top of this one:
>
>   https://lore.kernel.org/rust-for-linux/20260930123645.302318-1-ojeda@ke=
rnel.org/

Cc'ing the new (kernel.org) addresses of Chris and Lorenzo since I got a bo=
unce.

Cheers,
Miguel

