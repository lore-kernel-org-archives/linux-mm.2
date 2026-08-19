Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39883C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 04:49:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DF536B0092; Wed, 19 Aug 2026 00:49:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 190CE6B0093; Wed, 19 Aug 2026 00:49:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07FE56B0095; Wed, 19 Aug 2026 00:49:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CDFB66B0092
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 00:49:07 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4942240312
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 04:49:07 +0000 (UTC)
X-FDA: 85116789534.03.D3056F7
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6244820005
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 04:49:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=L+dm97bf;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787114945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IoFXAdzKannU9+arcilmY3guZOSDUnov+4cFgsfSc/M=;
	b=i2IuQvEXjaMKUDrbgjM+XIXphTEOZbdsh9qZ2Rxdg2oHDnOFpgDSFl8hUqq+L9/THDXehN
	WuzGup/PD7BcKpypfnme1mELeZXDKlqhCVVcGABd+ur7ctx2dX0Q50aoSoIsqnlNGXN8u/
	fcp8qf0wjn+JN1mQ7F/2Oln7aE4islY=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=L+dm97bf;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787114945;
	b=yWcc0mRO/0pT57gsuSjWIiBg20ln2Krdy8LDxcjRGdqYBWwMvMlcIdDhqFILg41wJxIJ2D
	OhcuZMeM0LUtpJG759v+IBYzZ+V1bimuUfjstQ0srfHR9QKgtIiQkx0o5EVmhyg+SOtduP
	iWWqTeqa4+t+eJFeDg6LPlhNPSQkF74=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-51c10e86e52so85481cf.1
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 21:49:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787114944; cv=none;
        d=google.com; s=arc-20260327;
        b=oHJIfpnJPfwervPewMeJMXIpm1P9KPtvVp+JcXSZhuZ640AgGMKWzQg1oh6B51yg9u
         sB2NQ1haJmOXmciAVZzIVEnzLdlwmTqSUiS46YKqB8I/zhgRsCvdtR0YK1xzkzCeNlMZ
         An2nteTPzCywmNcTCiiCgmxusVECALEhMm7M4L7/kKmvoqgRKr+soc3cETH1p+5arC+r
         6H1o7ooN90tgXbbKckmKzoRks79z3HEU2NOgTd2M3Q1LIgctx9zOQ+4a2WQ2Bubx5nGj
         JKLTqf5zlcBdQSpbhC0Ww+Qr3QkmIDizp8Ue078/kA0VbGDOyn8FSZb0IKE7HObNEE5g
         1Bcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IoFXAdzKannU9+arcilmY3guZOSDUnov+4cFgsfSc/M=;
        fh=WPMOO6tCzAJZjgf67Vs+cjfYsaLywxpjPVmHj7eYMzs=;
        b=DiMkBqWXwMpR6cCp8v55u3sUpjsNKBunJTi4gc8QjHtkAOxCH/K7Z4U7aqNcyGp5+n
         LWgaAOgReS57XHEfWBZecxNsCQ394sSxKj8bmY+8awTKZOmbGQFhuidrXVL8bt7KEt8c
         J9qbtKOwoKyUdbyt2ZUhzh6F8PELdKrWr/mmFn+bT9ixBk/5w2gtVxOVOtSzPaEx37vA
         tKHHPbZ7q8esIu42ND1BKKeAmgmJNDPngEe2UKtI7xSgNgdEQ+uveoUcQiWwiXcf1VAV
         KFOup2SFKV5oVOeSHNe812ABgLQZivdDM2UbpUuwsLM4HrGY8TzOFbgIhgdRXJ2nGDke
         HbkA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787114944; x=1787719744; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IoFXAdzKannU9+arcilmY3guZOSDUnov+4cFgsfSc/M=;
        b=L+dm97bfZm1UKgva/GhSomKJRurBerf7+fOxApGEy9NM1N5DtG/w+Hesfvt2047rs7
         iObs4Yyi2XUuwJoOfHfSaUqTWLal0fj5t8CAAdWrGGcVmkB2+K8M6u4acDS96pdAMWvC
         DyJdFRrqJ7dT1wr5AfzqY2nClEXtErye4duFdcHjUjXvOtZbIdZxReeIMkYwEcJ/kN3P
         qnpmRpTTuIQHddKisLTTmL59OgP+aXjxX6HfFFwJDwF+zZzEPV3W3xMPU0DSwUroMWIj
         BU3Fw9h7/PX7MtCmzR8cuI7uNXzlMTxGJpuQBYKMNC1Z5eV11oYqfJiSsJkhuMNX7W9e
         sNEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787114944; x=1787719744;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IoFXAdzKannU9+arcilmY3guZOSDUnov+4cFgsfSc/M=;
        b=NUQZevsldZXyRcSSuOUAaC3dmgmzKlEX9CQ0zklOGANJpZrza0S/GCjQQMvxHgRrbi
         fQDNFQn3rRJORYQW1NoUurRTv30o6zMER4UxykYkuTHZByGvDm5d2Gs5aKOlwLSsvkwb
         woD97EJ0l/2K5do/tG2G9YCH9uC5r79ec8K5YQAtUN4snSHOr+gIf800TwyhuS/RI8Bc
         h1WNrdlCv97oZjqdR+NZ/0vEf94I+mcy9F3jtm+pyMSM/UFqduu/UeraVh5nQHMR/nRI
         tXYTRZCZwJAvU7ip1XLPM9uz9kkrAD68sajbsQmYjkMWOVN77M/e36F0vZgn8InovKMP
         7m8g==
X-Forwarded-Encrypted: i=1; AHgh+Ro+s59/YLl5VzHvPPMoQJXR6JzTXXtnybCvE1IKN+WP6kCFIjlMjjFi38sSiJpZCS8IaigQpq2VTw==@kvack.org
X-Gm-Message-State: AOJu0Yx83EL3t8cYrBeIwBymiX33omneyd1pN9WW/YmBPEOEMcKVrsTq
	y/+YwyvhLHUAFJ2kNTeoixW1qRPWnvymSZkdYkQTWNh+vanRPDBBWpDQWz01IH2FDhUXDpNWnAP
	DOQgAY6o+u0CXEcR2fi1mc/7izjlhiuMyoo3nhA9v
X-Gm-Gg: AR+sD13Wv/PdC13bwgyI8++yJnS8qF/wqeiEcrqH0zhPZ6kIsrjA5gfZ6WNttEmUzxm
	j26jsZ28WuTm9XGH9hgjS8aW+l/XNLh3X+ywFJWY1ns6o5BicK4Ilhm28hKOlbavq2mOgAn8lAR
	PwZXYb8MvskcMjwEBO2fjrWXYj899qHeuJD6HaNBWeBXwUjxqT5AjxEWPsJTBPAyiFxxKjJUjL3
	DMtZtaYNzRSQ/jB51wLlSKNqT2DHIEXoTKY/DIzNGLiKeDsEEcMUqKJF54CBwxIeEZB+o0qm7Tx
	i5Cjba0i7bPC7XBzxgZxiU7S2Ajx//5f+AEq4pbz3Qg=
X-Received: by 2002:ac8:7f09:0:b0:52d:9d62:6163 with SMTP id
 d75a77b69052e-52dd90c9c40mr3552921cf.9.1787114943822; Tue, 18 Aug 2026
 21:49:03 -0700 (PDT)
MIME-Version: 1.0
References: <e1e0b5f8-c3c6-0537-670b-4397f822f980@gmail.com> <20260818202656.f7a248b33f6130d06b4cf83e@linux-foundation.org>
In-Reply-To: <20260818202656.f7a248b33f6130d06b4cf83e@linux-foundation.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 18 Aug 2026 21:48:52 -0700
X-Gm-Features: AcwNN1UNQi8Y6l5IunlJ79Pm3zar41rXV4mR1-ex78rbutzNNcFRfNyRWzJiL58
Message-ID: <CAJuCfpF6Zs0LHRcCbJ_-BCVoN=_9=57+-b0n03uq1gy8_Ezw7g@mail.gmail.com>
Subject: Re: [PATCH v3] userfaultfd: reset err to be 0 when move_pages_ptes succeeded
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Foxie Flakey <foxieflakey@gmail.com>, Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 7khrmd4yd59bgmrb5885err1mhjbxrtu
X-Rspamd-Queue-Id: 6244820005
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787114945-260549
X-HE-Meta: U2FsdGVkX1/8bUzudnxuHS4y96Vs4IfwC8zCkaRF07CeTbuS/sHAUCFiOR5S7UfUgxfZvdMnzKuyGn7w1JVRJQg7rCGKk1+hw2SZj9zNHAxG1wB5pMpi2NO++AuYL55ffRhDF2wCEgs2vnEj5nLWngaw6tL5n3+fvy8OBIGo8aLaKmB8MtPhw27fwLQOCKUqJijd8jg2GOzRZPwRpRXTcyDF2Jd3EkirzHdy2E78+s7NyLdfnuKVjxOixV68AndpQ10cn8WyXKtgYv6LkxEIh1aeEdhPsDgQMJc4UhOBE+k29hVbC6QXAW7c2lY4J/X2z6nRFeU66G/vBKvOPvLLjPsQB49AeqmoAT2tnK4tntbCZpvlwDYfnXE9mNWW2iD3NKtvNe44QsYXoGqpN+t4zk2+y0QW3KBN760nNd1jKB1Dr7FBZHJAawluE8zL5Ya2DDokuU2ICu1Xi454ybyuET2FKyG38e13nuhYDDvEhTKTNsJEyaEBUb4hcVI6RnHaWicoV8FgqzkVyLtHqb8MuPcy/vUBN7Kc84q3ohYeAargV0FWxof72gcFXEQfjwsVeLUyDfAmCRLBKlAomAdvx2CPRJuGZSqt0/Ih4xe3D7awIjeFIcVLHP9mhDMm7cGRELg2FOMq5Fst8116yviDZepV1XIl/71HMEFlqHnNfd9dRLp2e7TxT3nVKCJGnGzvITIF+yJ/QcP6pD6jd260QeVyo72z5dwpDsmHq/+tVQKqgte0qcgGnhBoEzMpta66sPwCEFjYrimVsp5DPQYks4MEc6lSmP4SKeEZbmzWyl8Z3ar2X2zVxy82YWWVLxmd/5dNWPO5Sy3IqIm/n3Q1zk3r6cz3Q5/Qnb/lBKvaw0J+D9Y2rpcV4AIni47t73xEJv7Yyrg0El1i45/PJ84B6s8uhQ6eDXinfrwKyLa2bKCyj0I/55CxtYLuLwj0KHtXz+jJmmuMJwnGvpCn1mH
 8J69lKeE
 JZrNWqYHIXRgFzuvy5ci6vb6wZPoZs6OafkeObEyMP2nXDAwIRSWHCs625udAzwU6emzHrf+hHxkkyFIZr6cYgI35kz9CUFyFZETiBk3pSuTucRxtrf6TX/+nB0h/Ygb9clk4fJblYmuzEnV9ojrXeFxBWJ+UMa73XUE/h0keSOKUM6k2PX5NHKxm6AVfhV9HgEhr0wpzrwJ8RzFo1xxXRZwysfFMxT2tx1cljbIVyHfXSSM5L1bB5UbK32w8YFrMNYLdAUz+H0GUn6GlbYhcSNr+5SaVGtG1LTKGzPuYYRVLWJ2IOobrDA/v0Evgkc6QFGe56teJbikdJDcj6bfrmm7hWVr+QAOjubUgaFbglfeJzAwv4N/n9m25LIeJxxxY/KCn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 8:27=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Wed, 19 Aug 2026 10:08:24 +0700 (WIB) Foxie Flakey <foxieflakey@gmail.=
com> wrote:
>
> >
> > During move_pages() operation, when move_pages_ptes() returns EAGAIN,
> > the error code is not cleared even after we processed it. This leads
> > to a successful retry but then the same pages are retried again due to
> > the stale error code. This time move fails because pages are already
> > moved, loop is terminated and move_pages() reports a failure.
> > Clear the error code once we processes EAGAIN.
> >
> > Fixes: 50944692052b ("userfaultfd: opportunistic TLB-flush batching for=
 present pages in MOVE")
> > Assisted-by: ChatGPT:GPT-5.6-Luna
> > Signed-off-by: Bryan Lim <foxieflakey@gmail.com>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

>
> Thanks, Bryan.
>
> More paperwork: the signoff is supposed to match the Author:.  The way
> to do this is to add an explicit From: line at start-of-changelog.  If
> this is not present, we fall back to the email envelope's From:.
>
> > --- a/mm/userfaultfd.c
> > +++ b/mm/userfaultfd.c
> > @@ -2085,8 +2085,10 @@ static ssize_t move_pages(struct userfaultfd_ctx=
 *ctx, unsigned long dst_start,
> >               }
> >
> >               if (err) {
> > -                     if (err =3D=3D -EAGAIN)
> > +                     if (err =3D=3D -EAGAIN) {
> > +                             err =3D 0;
> >                               continue;
> > +                     }
> >                       break;
> >               }
>
> I'll queue it, with an adjusted From:, as above.
>
> Could reviewers please advise on whether we should backport this into
> -stable kernels?

Yes please. The first version where the bug appears is 6.18.
Thanks!

>
>

