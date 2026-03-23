Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C93FCF46137
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 14:53:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F199A6B0005; Mon, 23 Mar 2026 10:53:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECA966B0089; Mon, 23 Mar 2026 10:53:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB9396B008C; Mon, 23 Mar 2026 10:53:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CA0626B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:53:38 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7CEA5140C0B
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:53:38 +0000 (UTC)
X-FDA: 84577621716.27.DE584D0
Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	by imf09.hostedemail.com (Postfix) with ESMTP id 90245140005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:53:36 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ox7xIAEB;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf09.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.169 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774277616; a=rsa-sha256;
	cv=pass;
	b=DPVfJs6xgdyhe+TLi9rIMUpFzo1AgG6jq+MwQqDTeJ4qcfGmHcPDAHt4BcAb6NnQ3usX3u
	koRFn9wyQU6WKGTF84ShUICi/tOoaKgKiF1TuXEJFvxX9WPr9aQk4cveu3RuM7wHcZooy+
	LLmM3XUtTlWU79V0YWSTiD3eQnMH2WI=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ox7xIAEB;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf09.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.169 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774277616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LI8/dUz99GIMIFX7jL9A6Uqav/8pN6H5Y3gQQrLVq3g=;
	b=e5QQaGNI7hZL94a0VzbIwTBG4mJNF4fBr56uyriLHKfBkRf4lmlKVTdRolNlNl/kuF/OLY
	PaiJNI8wbgRURsPqHQpGdW+NLVSlOvearDrnotpyIlo28Wc+u25QBTwOR/szZ9MyA7yDSj
	0mQO3oYV7sDyh2DTZuiMZ/KF0NgBk6A=
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-2c0e6f5abb5so141164eec.3
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:53:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774277615; cv=none;
        d=google.com; s=arc-20240605;
        b=doQWvnPzBzwygUeHwjGUpLEBRvW/PQ3NI68XDD5etgCO/d8ZkiqvmgQw9+gZKkAGbo
         C73wmDenaonxveaM0G65OLecPmZ3CAXtBddB0xEWLO0+m5fV2ovN//sOekZugwNiOiC/
         HwxEUeKviBgZoK/3zwl3PhvFnXw0pwjOx50UZT+F1KOLQUaX4/kMnIi2quuaJS/TLVLA
         fCIRRgvJ1k/kLKi/558WBaLcHV4MwNSQO7kx+EaEQO+cgevKMQL7hagU512jgvh8JfGw
         Wq3olBZIeIOwRtvOnFvjwkCuEM6my6QDJhKfHkRWoguzv/LubAQQk+79ANBqsz0DBgz0
         nH+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LI8/dUz99GIMIFX7jL9A6Uqav/8pN6H5Y3gQQrLVq3g=;
        fh=GuUTEibTBeuZ3u/BLN6AEHXdaHb6l8XaFxB1hkvCri8=;
        b=JcxWNkrZMwaZ/XJRbzupieyhLOp18BmiYOHwlCfuRAHo/+vWwkTdQ/Mmh5GvUG6IFp
         syKN6KfyEDU0q0o4hUIlJh4BZXXDbWOhIV7qGYJyKQ+MA9bwoQljeYKv8DHDfkm9JIjT
         aLD1SE3DyeIzHschWyhTgRoTvS+jRxxk/Wc63kQylaye4lvS+TEEdqEE2jYzSjQf/m0t
         lJxG0QMY3uMffLXnPgFH5x6DRJcY/k8EcWH++Z9xkr9bWc0y4Nei0V6xlY5pNjXJEseH
         xL/Fm+fZkQBD6qX4JKMQ6Wupwb9KfP2k9bF+HxbEdCxGazgQ+CJfGn+wr67+BsPhQnGl
         EUlg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774277615; x=1774882415; darn=kvack.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LI8/dUz99GIMIFX7jL9A6Uqav/8pN6H5Y3gQQrLVq3g=;
        b=Ox7xIAEBsESXsqiddBvYfO/8eyKrScLLmv9eewfutV4u3BuWHUtLViSS4XNMFY3lcc
         W75v8Hhe2kYK7I/TXlD44HBzj8Ha+0dmLFdyJD8cmD76MR0nrvuV3AsUBlHUeJ26ku6N
         OOIH30eadjcRA5YAnXw4xP4CqwwxsMscelseSfVQaaK0ZjuUo+ymwyd/UMe6yd6mMCR7
         9BY0WROawNsGYbKliXzSO1ehVK1lQ5VWgSFtpLN2hGpFWySfVgNxIv4Z7Qjvbcu6wCcd
         fNuCAv2Elwz1cknxWhv0P0hbr9RwmfUW+9BylJHoFZ36wJ4OuZAi60+HbhJLFomateHH
         RRWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774277615; x=1774882415;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LI8/dUz99GIMIFX7jL9A6Uqav/8pN6H5Y3gQQrLVq3g=;
        b=OG6wAhokrRUWSMSNvdSzZyxSOxX5ffeDDjaCtWmWASObREQt0tiBQL8kj9E/CxUM4o
         U3whoAJikwuK8oUpaTwbogBB/yNue6xPQQ6sEF9nWXvlbYGOVMsIDyiN8xlU0t5llQ54
         dSKtOuCgXVL9xT8GKC8Zd8qV/ENBv+on4AhXuFp0NiPcb/8xjIQf1Nh6tqYN+2CZkiAw
         kv2A3/yLPTA8joHjY/qOk5qsB68J5BrmTa+GTVsLdSk8S/nudlU4WV6BvJHtgsZ9dDcP
         MqqZFVTZ8jn3gKNFq5/gx8NuAdOZK/m6DZVy9g4u39uEdR4dJegM+jqUH/gzlbz170ou
         wdWQ==
X-Forwarded-Encrypted: i=1; AJvYcCWQa8/kupI6XJ4Fh2BTOp+zDYt4n9j1ciEKfNh7zLkTUbix7Ah4gVku7qKCyG+wayPVlFvYq4lEzw==@kvack.org
X-Gm-Message-State: AOJu0YztuLYGP3MjVUuhZmkNRkeFokvEtXBQSGgZRD6v3DEqM/QNZK7I
	4bDGBi+eyoi3c6z5HLUUKPwQlT5GvyrIniWtkGffc4Ml+/XxTpu3na/ixIK5EJp/m/07fFaCURh
	ySA7mvbMeW3w8pM9de68XnJiS7Ek+VMU=
X-Gm-Gg: ATEYQzxd9fam/TKaQREpm+a16De/QBJWt1G1qNVWbSh5Tj2KWW40WEYoLQKErPvDlo1
	JjQ0lGVyufMTtjFS6jq59AMAt13bIpqgOZd2h1XtEfzM2QlspxMY5Sa70GSJdtMHH2wb0WTEf+g
	vboWvTGZs+4lh9IB+YhINxrx7JLPIzdfOpYNXIS/cONm+17OBmkQiNfSbBJzt1I4NSZA8xfSWKg
	yj+/0Wb4pPgU5FP/5dW9t8Ozqfgt9agZuYVnfiuu0ZaAGh34MQAcRGdoTLRDAXv3bYs3Rt6rUj7
	02Z3gCj0IaIUR0hHuagDAj2Ja2yi6NeGEUVniXWWn3T7e8Ccg/j/LqYickcl2kc509J8+tBTZYc
	0nf05BKMdqh82X8wiupmBZEc=
X-Received: by 2002:a05:7300:3215:b0:2c1:27c:758c with SMTP id
 5a478bee46e88-2c109938d44mr2357139eec.8.1774277615132; Mon, 23 Mar 2026
 07:53:35 -0700 (PDT)
MIME-Version: 1.0
References: <20260322192159.88138-1-ojeda@kernel.org> <20260322193830.89324-1-ojeda@kernel.org>
 <4fba0163-547e-4099-8b37-5d8429bda6da@sirena.org.uk>
In-Reply-To: <4fba0163-547e-4099-8b37-5d8429bda6da@sirena.org.uk>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 23 Mar 2026 15:53:21 +0100
X-Gm-Features: AQROBzBN4j7-1buNPtn5ON4A_wtJBuiQQ3UlTVe5clvsCt_bKh7FB_BsDwGf67A
Message-ID: <CANiq72nmFsnoP3dv_-0PWH0XBpf0OuPzNR2CP9Hw56Z+RVifAg@mail.gmail.com>
Subject: Re: Re: [PATCH v2 0/3] Inline helpers into Rust without full LTO
To: Miguel Ojeda <ojeda@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>, 
	Daniel Almeida <daniel.almeida@collabora.com>, Jean Delvare <khali@linux-fr.org>, 
	linux-kernel@vger.kernel.org, a.hindborg@kernel.org, acourbot@nvidia.com, 
	akpm@linux-foundation.org, aliceryhl@google.com, 
	anton.ivanov@cambridgegreys.com, bjorn3_gh@protonmail.com, 
	boqun.feng@gmail.com, dakr@kernel.org, david@davidgow.net, gary@garyguo.net, 
	johannes@sipsolutions.net, justinstitt@google.com, 
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org, 
	linux-mm@kvack.org, linux-um@lists.infradead.org, linux@armlinux.org.uk, 
	llvm@lists.linux.dev, lossin@kernel.org, mark.rutland@arm.com, 
	mmaurer@google.com, morbo@google.com, nathan@kernel.org, 
	nick.desaulniers+lkml@gmail.com, nicolas.schier@linux.dev, nsc@kernel.org, 
	peterz@infradead.org, richard@nod.at, rust-for-linux@vger.kernel.org, 
	tmgross@umich.edu, urezki@gmail.com, will@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 90245140005
X-Stat-Signature: e1cbwt7im4opyx7k1i1rzpt3cccqqx17
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774277616-447481
X-HE-Meta: U2FsdGVkX18Z2MuPcbylZT5zapNvRAlNju4fC6Y2xVd3aJQYmc8v+V9EWjSMIrqNGepg0W2fSOy8ctxn4Bdqz2LA+qM8QerrZyP3qzsDXAlIwuk1zv5EGxsMb5hLN6E9yioJPU8z0W8nng8KwBiFAlTtm/I3tqztRoiwl8lx2WzQ3yIdCQLDNchlogNomzUmEL7s0+RQHz9vap9IS/uKeNVDrRDvxjY5vdOgHfDMVLDyEzjspbkaaC1v9VnmpLSFz6R9qkKso7JZwN8S7EOXntP6VoVyZQF72H7sqO9zbnkqhGkJGBp1kGySqaoybajWSEqzEzcqVbK/WhbLMJUUbbRnt7GnJc4WkvSuH0DTHAy6YHilNHEKodDOVkKDcvKTpV71uGk6lC6LprZw0wRpy1/V/ORZDK2ZHRNk6uRzzjPVQxIXC6ZI5JSJL4iMqGpA23Yrld6KokwjyHGQzR8pg1XK4Dd/EZit11CeUm529g2sgliPXLu7fiHPGZrGFhTVkcqytFtyuu9s8tirXWLGPH5udtdGlg2JFj6O9EcG+ojo2nu2obRXRDXqXhTxZJ3cTitx2FcHgf6uLUAYJEZL3xG4doNJHeveuvrd4woJVj7mytiqb7ovsPjjLurQn9Az26xdz8XfZsuxZdMfHiPmvwXTcKM1qp7yfw+a+AxwO1O/rYkoIJI5wvI8BnMCshsYW7FGFIaOTKgv8n4VpHeFP1FKORdnymK0BDntBBj6tM7BuBA+GODHT+uLLrsYwu32Bt/ypkUJGmyW8OyYEjTnMeAFDCQ+PNyw8fmKKSu90YcU7tmfZql5SHR8J+MWlC+W6xvik5aA8PrT53hdZcFrmg+0ESQc3qorCF/H9rZfERaB60CHTcLHaRq1GSUdyY1CADgJRe+pYy5O5WkCsWikaE7+Y3zi4Uebkx+U/FBrt5oYY38QLDSqZ/SwCi5iHVP1IF37CZJtblK1krGpus+
 yEXeTRoY
 oNCI/ws0UMzR5zMxWNER5A41PbIL8bZ0+CQzPM/PVVwlcfF7CSBwr3uUTKl6Iv2AoyPjzbP38T6ck0gTYqnY3VbEcyN4ZvjbeZejpz+KsCmmAoqElXB77701Jjbb8QbtbtCM8ToN2mqycybZl4chCXKWHrI0DOIcMApbWxHi8QaAJGSMc8sb4oHpKjo/fQgIfH0pvmfnnLmGVM4UskpQeaQYkCE/MoUkeOpXpboMGbJ+TXeT0k9xybxedYItkDq8Bcj8phZbt1x2bl35fpEjOVewMGO0ywjaG8k5SYdyXgrIgTcwnN96lEd/VWXP0QcjTBs+Hm/fUwxKc/8qoAAJRH1R2mWA1GsJgiJwP6c/YT2cAz6kz0PoCBhUYGQpziiKWXtJyERX29aPAJTiHqDjINWDs+fwNij5RuuKscYxLB78vC6HRAScsl8BLW6CvRFjJ3TLg/7dEN75hvSOfyyr/RdZ3cTpeW2Q/cY3LHsRVCUQECp/c6KjOv5wc66xsD8sZgGMuVdqJqVJkEIDw7E3y/Of9qjg4sm6/cw8clOtHfUj+n20=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 2:54=E2=80=AFPM Mark Brown <broonie@kernel.org> wro=
te:
>
> Callers should never treat NULL any differently to any other non-error
> pointer, this is not a value intended for inspection by users.
>
> Having specific handling for NULLs is very much not a preferred
> interface, and most things shouldn't.  The caller should probably have
> it's own !CONFIG_REGULATOR checks rather than using the return value.

Yeah, that is the understanding I got from reading both the docs and
the comment, but I think the docs (i.e. not the comment in the stub)
could point that `NULL` is one possible pointer value (perhaps
including discouraging relying on particular values at the same time,
and perhaps mentioning `!CONFIG_REGULATOR`).

i.e. to me, "Pointer to a struct regulator corresponding to the
regulator producer," sounds in the docs a bit too much like it will be
a valid one... no?

Another perspective is that, when one reads the rendered docs:

  https://docs.kernel.org/driver-api/regulator.html#c.regulator_get

one sees the postconditions, but they happen to not apply in all cases
(in fact, perhaps not having the "Returns" there would increase the
chances one realizes that, but I understand that you want them to
treat it as fully opaque as much as possible).

It could also help things like AI review systems which may only notice
the docs and not the comment inside the stub.

Perhaps it could be at least a one-line comment in the real
definition, even if not in the rendered docs, to have a chance for
others to notice.

I don't know -- I hope that helps, in any case. Perhaps Daniel can
tell us what he thought when he was writing the code, as another
perspective, i.e. whether it was the docs or not the issue.

Thanks!

Cheers,
Miguel

