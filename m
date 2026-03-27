Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DC7210F2847
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 15:59:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 749E26B008C; Fri, 27 Mar 2026 11:59:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 720836B0095; Fri, 27 Mar 2026 11:59:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6366A6B0096; Fri, 27 Mar 2026 11:59:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 51C0B6B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 11:59:33 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0FCFB14093A
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 15:59:33 +0000 (UTC)
X-FDA: 84592303026.17.DEED402
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf20.hostedemail.com (Postfix) with ESMTP id F03C41C0017
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 15:59:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UQyOqSCd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774627171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LhZwKKs0sf5VOiERE9wtFVUhEEfkDjhE98UKl54LL98=;
	b=vIr2Y6y2geHEqPBgW+DGnyzm4bM2XVNNKOoPpMN06KuKZ6WCNavWTMN/5qFvS1RsjdIAqf
	TYt2KFNqyKfA+T2PN9ASGo6DuE/5ypmyFqREtrMdjb+Kx1aTHxC79mw6v6qxogwEyJmlJl
	p1LerB08r4O3Z2vDCZz+ztkW11YOOlE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774627171; a=rsa-sha256;
	cv=pass;
	b=HQGD0v6udRzb0ILoyecvMA6cQj0WzrVdyvfblkjfcS/I03k86SZVsMDwe2NF6NtCWzgJs8
	5C9YIvtRIOwZ445NdYI66t6K7+zYut0QJJ5YgNjaYjoBFrhxyZ24MAekOshqC/KUav+HOF
	TJ2K2B7DbRN9VLDU2zsuCJEx1CWCrZg=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UQyOqSCd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4853c1ca73aso22163015e9.2
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 08:59:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774627169; cv=none;
        d=google.com; s=arc-20240605;
        b=d6ljJiXlKHf8dT7ZWeYxtgKhqnUlaXIqP482dMFf/MeJDGOVE5ScQme02bfD8WQfOD
         HjNloAsuT6a49erf1An8PC8Gdw9ZYGswkLSrcXQEA0Iqhak9bj1mYQz6gkWvRXk/1+AW
         SppOyuXVKF6tMV462G4KmuDpfUky+uxgSWF6VvTQTz0NuxGazwJu2q/MQPXHWORr3pbd
         ArBILW1NiyTevBaAqPZaPhVi30aeHN2zPlSYMyADVsYmxhnHZ2OOUs1/kn4bekm5xx2J
         FNRhTHpBZqAIvsHqaynXRxNxpyXYhZMyRDcxvYnm3Qz2fX0ybTwRZDGYe6NHSzO/cpIq
         0q6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LhZwKKs0sf5VOiERE9wtFVUhEEfkDjhE98UKl54LL98=;
        fh=bUaJphgcjVtreTinFOCgeLN4XwQy9SBeD4W1A9FZKb4=;
        b=Q1jpacN/0UTonIpQr1NmmuHTmn5m07lqERJud7L0EsqsdArEuyRqsqGTxMPjYFdjcm
         4l2JSnwjSZJFZWubR0vBtbQ07FS5by6EcUb3uz+2ieLJEW0hTXm+DljmzdrjlRTVgRme
         AuCE2CD5KS5RrAmhTRXB+nvQdlbAu20YWw7jfRp7WI6TOIpPJ9LbogHBihcutWSdOE2/
         YiedoAj8vk+zwXyJ7/MZHKo7ooFo/05LmuEhD7WUAr9UKJuHZlqO7SONB5A4bVXxx5A8
         X2xWTTEUCzNZCGx+c2Ww/WHEM2l0PVZlbvt0k4ijoYMXTUnXrv9rQsGmMSU956mjmScw
         Tm4w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774627169; x=1775231969; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LhZwKKs0sf5VOiERE9wtFVUhEEfkDjhE98UKl54LL98=;
        b=UQyOqSCdJGyk/x8mCdYHP0YnkKbWnpjUY0UvJyricEZYjATVdAQXfE6UBCh9vV4kne
         okvj2d89nPWy414HXnzD0Yjye1J/v7JchXlK6g2OcL4lskxUSLNK80p/oOGyBdRliZ2i
         CYjf/+HU0Q4mzziQWvkwYJDuG2ds2Nm2ZGaiNpP6zIYbYD6E/uUxbr1o/9SJhCEGNDMx
         cWqxt3znGc3q/m00mO5IxnICaiOeAnepDE4c0fQCag2EoA5fZ+XmlCEvBP0KT0cBGjXN
         6WLEjJkeUkuZXu/Lodenrwpb/CuP0YzV2l3f9MRatmPOJEQlfxnRF24aA727k+MRPxkV
         tLGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774627169; x=1775231969;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LhZwKKs0sf5VOiERE9wtFVUhEEfkDjhE98UKl54LL98=;
        b=GYFz87GzyRYLwraPWe//5t+Se+/q9mCf0rufa2hM6xgXb4rDLb1crxio3htC8btzBc
         Sfsi1B8ho3vkecco4Zqf+iy9h5Xx3k0NLrQESCsAIhPlfGG5ZvALY95yH96EJCiBTvoD
         03ucef0AhMcYxIBT2HtZrVxbFSQkpjxX2Yt/tqvNglUP6gyA7gR1+6VW8KTnDlKqZt34
         Ikft0EFtiMKV7cf2Ky/fu7/DiSMCBB8/0UGokWBpCsBX2hKOsmw03T0XS0uEMqELW051
         rV+A4suIAGdCoQze7M5WPTITjy2tBBgcCXAe3NsFpEgfBvBYy5Z634IuXrzGqDKmZOKM
         Lycw==
X-Forwarded-Encrypted: i=1; AJvYcCVQQQzRfwyIiw5/qa7cV69kqGF+B8zI/0m7PdOmHXUGiIo43PBpbf87qlEqMiEooCbUIdpeWbp9tg==@kvack.org
X-Gm-Message-State: AOJu0Yyb3N8LALPoCKXZNpbeobdXhs/uB9wxh1Rc+xhfwAsVJQWBlZkx
	/zGuigT+MH1ND6SvMgtp9D6DSgQpMR9XJDw3elzJxmuAcsz4/iy+c29z3XQNmqyYhDCUQmHysBk
	eRz/oxrMpitch+7KcU/NtmLB91rIHRQw=
X-Gm-Gg: ATEYQzycwTkM29phqlQgun8VsW95LVbdc760vv7SUUwErUKf9hphtJ9NCy9imZsicbL
	UNa+JCUC3gcRt5xVLdE2VlQTF6EdCYiUgKCoL2CoP9lPQuRb9FzJ4e2P+3AUYEkH3bli6BgeQFb
	hU2hZw39bImuVy09N6gqr2wc5K23H5yfl4WbYStcJIOhKmRuxof8WtUHknl/u8iG9AYgeI4bet/
	Cdh/tO5hQrqCjyOWrDdqZpug7+pMXfF4C25mwnwsSGOC2+t7ZcGvHEj7tuizjC1PSYhbA/t7vyb
	wfmQqg==
X-Received: by 2002:a05:600c:3b24:b0:483:6a8d:b2f9 with SMTP id
 5b1f17b1804b1-48727d5a329mr55071975e9.5.1774627169154; Fri, 27 Mar 2026
 08:59:29 -0700 (PDT)
MIME-Version: 1.0
References: <20260326234629.840938-1-joannelkoong@gmail.com>
 <20260326234629.840938-2-joannelkoong@gmail.com> <20260326174237.0ad75b578219aad36f137e4b@linux-foundation.org>
 <20260326175052.06871e1fe76af965a114bb3d@linux-foundation.org>
In-Reply-To: <20260326175052.06871e1fe76af965a114bb3d@linux-foundation.org>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 27 Mar 2026 08:59:17 -0700
X-Gm-Features: AQROBzCsIj0J9Y2u5MtJepoRMfzd88OvWi-Y5duJeQ2qQ2Uz805LBD2c8vxY-dA
Message-ID: <CAJnrk1aFauY=ug2UyxttA=hKdsP-Rq7xwYCp_yyYQn2QeKiZVg@mail.gmail.com>
Subject: Re: [PATCH v1 1/1] mm: start background writeback based on per-wb
 threshold for strictlimit BDIs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: jack@suse.cz, willy@infradead.org, miklos@szeredi.hu, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: F03C41C0017
X-Stat-Signature: cicmgckziumhewcrg6y6i9ckqm9itoyc
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774627170-305917
X-HE-Meta: U2FsdGVkX1+EJuxYPbBRGCPzAW1hrvP9k1ddDRDcGnNU+8KhbA17iQ1Dd8D1B0eflmjZw38DdowKHYLGMau0pHc5lKSv4l+NnSW+z4busUcI0HQfTLqcKlVlTbB5tL1savsyy9uyoeSpcHe9R6Plipxbl0ljOoQZ0gf3YqysQ/pTwzUQBtp4/8F4jHMNEEU6HaYWx80cvmGVVe79gQorKdA9+HCiz/2dzW6b1WJsGmd4aeGxawrrEMmbs7yNx9qAwP+OjSsya/fS9sH6V7EJ1HUPSCE5MiHBKL9mBaXQ8TTpR0lnOrU3tYkGyIG/Xz4chmCABRmvWVad/CYg7EnqK8942pO3WqM7ERWJmSFu8CFGz9NuoiWqWY0Q7ptpErFbIlbqGCAsMKEjJJtI1lIGuF38jjB/LHqGjlXzNTucKdfTbjC3DUPRUDIkwigSTHN2og+wEJcJikFyaNVKwLP0nt5sTxIBei01j158+F/Zoy/MRXIhg7SsyjGG36MJke11VYXkly7SLZGgqZftXMGDkySyG1WVQl4A7Bc1DS7kxeUx/ZFcjx6Smo706aqMdiK11QeGOZGSLdgJ4XyxXOJlGz+QaevarK/8XCpez/bvcQsJA3d6vEon8oV0IEaD6Imsw9+m9KSzmMzTneBf4ZsZUAk0Uhl4cu3TrS3M436L5op3cxJWtOLZaiSPODerXmO55WNeiK4lCzmE6FS+6Adst3qwxeA4WaPIpYHw4/47SbVqIchiMf/8ewgE2odUaEPwaz0KHAFZAEtmo1USqH3EoBjLn9fp+KaAAeUBNhbvNrgnqR7JO3z5uU0FcPaQq7BViQcHEjFmQBKXZN+D7EpmX/im2h8YrBvO8BSgDsvOxqV+dr+pusgNCvT7ET97c5Mp14V48EQ4KUJQI+nZQVOcLK2i7TPPYqylZoJP22OBACLlMoJXDLRBQlMnMUst90ZnujlR8RT86hBKceozhPe
 6xU34GF3
 J/J4NqjEFKsctLokysu5FB8XozMFVLJGJFn19YxnxF4e1x3aUbePsVbEuqEaOP3qauSCRd2zxXF2HQTPwMSw6UGPzu7SI1OmXbCJEaDS/8gJ5GlCDYHFXlb1gJM4wcrT06GbVrSz2BZ9MyVQ51M8Do18rrM8bxbDxTnh0E00Vp4/DbLchwzCIfJcvv1qefRiyA/c/YDs2+/BkV6Ghkw2TTS8T9a4coygBSdfYgQhocLhmBicVDWyNKigsinMQ0avBUMHUdg2XpwvWoOagRuVwr0qVc9SnaeeAKlkuEl7AUFpezsMlqW1ktql14lBAqj9AVsLbMe3lmEX8QThC1hSfRaJZXs/8J+Z1kjIT5uaUQOzOUcYqLMTbhb1dCJiNPdJwMsD/C63YHxP9OFeWka10DySTeftk0beKIxPQgUtN3HEujqD9OROb4sbbIWJ63wZ/ugK45gbHCmjlGfy8D1g1BQlfYDFf0gc9Dm7x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 5:50=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Thu, 26 Mar 2026 17:42:37 -0700 Andrew Morton <akpm@linux-foundation.o=
rg> wrote:
>
> btw, a [0/N] isn't really needed for a singleton patch - best to just
> put everything into the patch's changelog.
>
> Transient info such as "this depends on my other patch" can be placed
> below the singleton patch's "---" separator.

Ah I see, I will do that instead next time, sorry for the confusion.

Thanks,
Joanne

