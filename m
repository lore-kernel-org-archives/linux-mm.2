Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26216C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 02:35:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A9396B0098; Mon,  7 Sep 2026 22:35:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 259DD6B0099; Mon,  7 Sep 2026 22:35:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 121D56B009B; Mon,  7 Sep 2026 22:35:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E0F146B0098
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 22:35:14 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 61D551C1F57
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:35:14 +0000 (UTC)
X-FDA: 85189028148.07.2CF1F71
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8A239140003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:35:12 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EhPiuI3v;
	spf=pass (imf09.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788834912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eMmtbVHJ0q3i7VkqBKjhsBvkJHggSH9rxueG+47NtEw=;
	b=TH18WUy+fXxnFicpMMxCeXQJ5g81UD//FYM3JTIv6I2OxIi4bQ1H89LOvb/0UxoLwk6sKS
	q3tLeOXznfkFnuT1GYT0NPXz8vppl+BSx/V/ZosfuxnKbIvjWN0y9xpz7T6LsCWbwmRB3R
	nkJg1tI6JmrgKSCpnsaGXECrltNXsAE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EhPiuI3v;
	spf=pass (imf09.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788834912;
	b=pBdQiuvmWiI/76lzRtUuWh5AxI/uwNA9vfhOVrFLEiZNfOvs9hhuz4qaalQM30DCtCIl5B
	J+75wP1D+Xyq27rNm6YIowbSjdaFov9mEFhP8IPfL32aWbRdNwKBdW4LHZ5dXrDnIM/rJX
	2wRkMtcpTmzxafJ52sOAiATV837lpQM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CDFD9602D1
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:35:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85C4E1F00A3E
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788834911;
	bh=eMmtbVHJ0q3i7VkqBKjhsBvkJHggSH9rxueG+47NtEw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=EhPiuI3vzT+vj3AzZG46gCFz2og2UtKkIFYvMzir8gnnbLLJNSxTBDGkSOf1wrv2t
	 bduAzR5i3GvIylk+Q90QGM4ER0q0KjXF38nq1KtSXKqN7S+fDn/9brt32SvBlyfYll
	 /1XhjCTHWgn43Uhs6X+Q48PWqv2jSP0bdAiOjcnyRalVwn3FSEESOPvpzZav7+Xei4
	 NlG0OzbFsFljHNJ+muzHLZ9WP4FjI7g1qVIGSIG71nJJ4xibsTJDzXziWFvc+UhItp
	 onSiay6Qcu+c7LgxDI05C98Bb6+zW2XKGlzT9YOJTRf4v0YmxvkNzt6nlAzJq3A21n
	 7QgpcijD/SJJg==
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-529a1ee0e62so50218501cf.2
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 19:35:11 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBy11Qzde164RCA9wh/bW3oN95tnX702kvW3E1j4/8YD89ysCFgsPR2oi3uYkQ1DOPQSVMSwWMPA5A==@kvack.org
X-Gm-Message-State: AFuF++lw0FJZOmYb/Fncx0lnQ8QVPTOL+4GKzPGTSOh0HQydg+AaYIBe
	MQl1z+Lc/xRO4m8bJskQO2l3w6gGCYHOFITuoea82kjR8uLfavPbcEfyaYuzfGv8cGK01pbUCpm
	IEzJBJFobiysacylsO5PpHK0/K2ADzWI=
X-Received: by 2002:a05:622a:4812:b0:52e:2d1a:6f14 with SMTP id
 d75a77b69052e-5305495fe41mr315608421cf.27.1788834910922; Mon, 07 Sep 2026
 19:35:10 -0700 (PDT)
MIME-Version: 1.0
References: <8e4db9a298c5ea6ccb192e274caed5b96f0cf022.1788751143.git.baolin.wang@linux.alibaba.com>
 <ap9zPPughaSlfXM2@fedora>
In-Reply-To: <ap9zPPughaSlfXM2@fedora>
From: Barry Song <baohua@kernel.org>
Date: Tue, 8 Sep 2026 10:34:58 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wn5ArqhG9w7gJY7X4G+Lg6=1teCb70dzPdN0k+5H8MbQ@mail.gmail.com>
X-Gm-Features: AcwNN1XJdP_8a8O34UwYY4Ts-BqbCBJU3Y_Odys9qaBt_-F_ZUk2tjclx1aQlnU
Message-ID: <CAGsJ_4wn5ArqhG9w7gJY7X4G+Lg6=1teCb70dzPdN0k+5H8MbQ@mail.gmail.com>
Subject: Re: [PATCH] mm: mglru: clear the reference counter for rejected folios
To: Baoquan He <baoquan.he@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org, 
	kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	hannes@cmpxchg.org, david@kernel.org, mhocko@kernel.org, ljs@kernel.org, 
	ridong.chen@linux.dev, hebaoquan@kylinos.cn, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 4cny3aqmdrqomc9khug3zzaqurire77h
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8A239140003
X-Rspam-User: 
X-HE-Tag: 1788834912-586889
X-HE-Meta: U2FsdGVkX1/cLIsjF9oWRPCiYhkOwNfaryW8RewtwNxpik1jeb5O4PS6YYi/ibG5SbpJtxtSJr17t7RYl7I5WCqmTGB5jVq3zoGlbQ1kFyVEV6n3WWa7rxxs5AVNdxsO73GA+L3A8yEIVOsogwjg7Qdjt/7KQq69LTMckhG+SIP+Hf7BVIEyiHIk5ewwyjx55oBD8rbEjWhyvxmeOVFrDv60Sq5yDHvQVX6q1Lvfu2lpoS4zwQR/T/zRMoaCLeXxhRPjQQKrFYfMrV0kDSzr8uFtY9YXCWkfSiuetE8qTADe4xUNqywHrf6m8nzVidWX5W4iF/ZcVOAyP6543FlM/F+i1+n7or4gbYuBZTTgrxpOgi+W5/NMcjevM2IBcjmDI+AkFkUQAhIimDX/Tz9XzYWYOpq+3bMKLNzmTfgVJQW9wq/Y5kiSv/b+Y6T21otGocjNgiOr4RkXvjoZjGJbOOTzRhlDXFQFMzPzvhaBLQxdtzTvjsQ5cZP1H/Hh/eIEL17js3Bw52curSDOEwgZ44VLcfadyvyvIay2aUsGx1MbC9jD8RdOoOfMDjkvR8tJgWEh/Dj22EAFLGuTpKK7O0zXT21OW4QFb9LTue8NFcR09v1tpifW94TcXjkneTXJKE4VLYF+Yj5a2jzejUMuh2M769v3B+RzhDToUoF3vT53sNauHoc9VQn8akH3DHbhK6crdTkTfh9rD+isrGO/m70Geywweq4FIUP10Msr+7aqWjG5Wu9ogiFyOuwhPZVnqIIN04AJft7RQ4CTyrbIempcyfkA1KN5CCEP4sanLqNRXFL/5fIbxoCqMRGgsT5LlZiB/lUr1cmShp9QaT7MSZPRGlXvi+WDs6e7qKsnmAHIiO0scZhDAbWIIbTm4gt7rnjAOyMnzhwYYY/lA5TJ9wPUX845hHpf6/D2lUz9nymkbFF/wSQvjB7qC4TrCZYnk27LTOawJtBp5rgfdCE
 3UfH44ne
 9TKKZeOWr2KXxOHciQQxqdvyEp0TimIAo2Wei4s+gSgpFe9LKh8Rpt8CtRfEUD55e2uRRNsT345ADGPkgA8dStuNXAvVvamXIETRVTjvIWQ8pXwF8uqJpR8rjPPOx7jSVpoStVSBLM0SgdHndrNNDhz0Yx3ouYtCo/PxBa2c5qn1rwCpEb45lh++XZGLHJZEp9VpeuV/6uJyM06GryRdISLBXTW4YfIIdME0mSsiVqlFDQDJYTBeXkhd5ctLrDlqwzDBdB26cACHGpTY8fihbGzM7u1G3Jvv7ckkA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 8, 2026 at 10:30=E2=80=AFAM Baoquan He <baoquan.he@linux.dev> w=
rote:
>
> Hi Baolin,
>
> On 09/07/26 at 11:25am, Baolin Wang wrote:
> ......snip...
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 40d3f1b48a74..42c0a09938ab 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
>
> Well, this seems to be based on Andrew's mm-new branch. I usually track
> mm-unstable branch. Maybe the subject should be marked as below?
> [PATCH mm-new] mm: mglru: clear the reference counter for rejected
>
> > @@ -5021,10 +5021,11 @@ static int evict_folios(unsigned long nr_to_sca=
n, struct lruvec *lruvec,
> >               }
> >
> >               /* don't add rejected folios to the oldest generation */
> > -             if (lru_gen_folio_seq(lruvec, folio, false) =3D=3D min_se=
q[type]) {
> > -                     folio_set_lru_refs(folio, 0);
> > +             if (lru_gen_folio_seq(lruvec, folio, false) =3D=3D min_se=
q[type])
> >                       folio_set_active(folio);
> > -             }
> > +
> > +             /* See the comments on LRU_REFS_FLAGS */
> > +             folio_set_lru_refs(folio, 0);
>
> This looks like a great catch, while the code change could bring issue.
>
> Because move_folios_to_lru() relies on folios' flags to decide their new
> generation. You just cleared it before move_folios_to_lru(). This is no
> problem for rejected folios that are determined to be put into the
> oldest generation. But for those rejected folios that are determined to
> be promoted, this could be wrong. E.g currently gen window is 4, and a
> folio is referenced, lru_gen_folio_seq() decides its new gen as 1, which
> is the 2nd oldest generation. While folio_set_lru_refs(folio, 0) clear
> referenced bit, this causes it being put into the oldest generation in
> move_folios_to_lru(), this is not expected.

The original code looks quite weird. It even prioritizes folios
that won't be promoted by `PG_active`. Do we need to change all
the cases just to call `PG_active`?

