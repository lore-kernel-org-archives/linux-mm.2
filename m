Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 881DFF4213F
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 18:44:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3CC96B0005; Wed, 15 Apr 2026 14:44:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEDB86B0088; Wed, 15 Apr 2026 14:44:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DC5A6B0089; Wed, 15 Apr 2026 14:44:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8BBC06B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 14:44:24 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E3DAB13B2CF
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 18:44:23 +0000 (UTC)
X-FDA: 84661665606.23.A58C70A
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf17.hostedemail.com (Postfix) with ESMTP id B919D40013
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 18:44:21 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=eSTTIvS8;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776278661; a=rsa-sha256;
	cv=pass;
	b=4DXFNrRb/YCputED6pMhDy1v5QuNd0hA3CuPxxJ1SrjHZRSihXnz43qUTeDEC8KminEbCh
	uktOEDKCSQLWvABcv7FcHaKxIDkHF8QLgC5lstg5mo5wJWFJQxpAHkemLcgolk8+IrI1W4
	InVxcohpC8q6a5JfTQDtjbyoxBcATDY=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=eSTTIvS8;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776278661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f+yQntTqR0h6JwI09uPQd0dPCAWFqdxHNy6GJxTs0Us=;
	b=WbELUd8fWcmMnJ+moCCfmEYgryb9elXbHuBqQIny78nJ94m+UQSOrqjd33izBqWV84eU03
	3c/UiH1m5uf62Ha5napt56sHj0h0FUxxoWMypbxpR2DQrtu1Sr58LmpVhUKpOtjY9tX+Cr
	S2U9EThisPMMnDarD96S4eb6NB6QyuA=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-66d65646c65so5352754a12.1
        for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:44:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776278660; cv=none;
        d=google.com; s=arc-20240605;
        b=dFBvHLWeqqydqzzJ0nwAXf9HJBCJNDEmcgkf7Wczon2wD8vKdsRNCcil5sX5t66y4A
         EzfeJDr6yZa4HUZjwtWM5+Yubz9evkkYIYNhUk2nns5RpR90V+holpNciQdrCsAcbaQq
         qDhFQceW++qPO1VuXnsRttMn7njmhyD/6tEUT6zaH4VmD0s4kOymo0Y2HcXqn8vw+dpP
         vfkO7fSLHgzOV550XA0TTp8V0QP6mu1D2mE084rjG8fcm9YGg78660IWkFOfJW44xOSN
         PEFhPE/7k+aDzFhmVnp5dywhQgV0aYT5CyFFBao9/Mx/R+nPdyRfrGnzgpRHjM+E3L8L
         K96A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=f+yQntTqR0h6JwI09uPQd0dPCAWFqdxHNy6GJxTs0Us=;
        fh=WF8FmuLc8jWcE5P7MQABZEZmIFq56VEmv1RnidQ1Jbk=;
        b=Mdqr56FLFag/eXY7Jj6ZNK7i75HP2nDTDFP1jQxRrLw1pOjLEmRg7UNH6zTTw733TG
         iTPdXhP1kRPRWsG9HrwK4d9DawBDQlqAN+GuG8F1sVDiiQk4/F8LRN2tCqpNEQRDEUju
         aNuDn3wdQ0bjWLRSiGSJnEGm/yHWV/+xpbm/L5pyxBaTNz3FYZLT64V7FOhNF/p/fUqf
         +NjukxY6KFW9SZhvyvFgefpCg8BLTAm+86K5vIb8g20GWUSqft2NzAhoQuHsEFopkYZc
         hgEOUdQQmeqtbvZi/cENY2hJImmPLTmpuFTqbNIYBCaJljZYbNQdvpULhDil3jpwYuCB
         e6qA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1776278660; x=1776883460; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f+yQntTqR0h6JwI09uPQd0dPCAWFqdxHNy6GJxTs0Us=;
        b=eSTTIvS8X9XGb+U0UCplvHnIei3p6jYEhpw90F49T6i9VrOxSBluLLNPhW6VuqMG8O
         Zghq98eVEUxv+FnGneW0nkN8iJo1HUQeFln3yKIpz4hzlRrNhQyLrLdbFkBUbnkA+fky
         Vb6Y3RbWehgTH0ZoT7ds+iLrd3yiPRBFdtgCuKAcDvJ5xFZjKG8pmD51MTL6qbZIQVDo
         uVYIk5QGcwMc0Kp742mt+gobHq2Yq0swanI6XWHms1OGRGCpBdlPJPUJWXzKOfyVW+R8
         3cI4vW4povxc5Q95bRJ4cPS5ftkGlREULdJD3yLAhcvqZD2ZHHwBZkbgz7pHJ7BPr5Kr
         7bCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776278660; x=1776883460;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=f+yQntTqR0h6JwI09uPQd0dPCAWFqdxHNy6GJxTs0Us=;
        b=sRXqIf6LCuMw5DLBB5CkzoGmAIKmXSPHwYhE/c0lHPF1YE/l0GPLW20G7qpw5tXHUG
         K6hkqzlBY2uHTuLCdCRCYL5uBs6tl1Ks7O6oiJaY6Oet5o8ecIJ+esSziohJvutkLI6w
         Sh/34s3yrYbMi11q4mb38r9xZJbiX1hSGsjPQnaro9zp3bPXUHoiLZbirFuq2je/LrFj
         OvSNTmBSnxgPKxiH2MdddeBTiMC3bk+QZFrbs8YDY5qEcjK3+lC99JsY+KHXCRaLInsI
         mypL/S+asxlkPpvDXb6S0wiweIU0P/k2ONii3esWeD0oJFCiL/SXkZi1c6U9CO4RdZ12
         F0yw==
X-Forwarded-Encrypted: i=1; AFNElJ//HvO+S11XaO8e6CKRqYECiAt1Nf23cA7hra63IBmrt+eQQ3E5w5WyDKKX6j+m/6aEBA/KRIUoGg==@kvack.org
X-Gm-Message-State: AOJu0YyyECelpAZmDiHtYxNy7wJn9XZoAnzGWKM7gcZTIzfEC935Lj0K
	ZoFi73abgmXy4o7yKEJkAUPIgzJJVd595karmDPMcNOAVp2w9zPGAko9ce1QhXZS/wbmHxsjF12
	o6z21UcoCxka/AwQb6tDVqlhWVRnv0l4X2ZinJMBrvw==
X-Gm-Gg: AeBDietXqsH3rONIPqlR0gEFNeEsiP0hMteD5COllhPTOfJ7viMog6BXuPa2P3KTfqN
	KgfLsyhzkHM5bhob/VWn9YrCicXfVZE8mZr5cAPZYwmylAR4scjKJ/qvq6MHA9sn41zBhlrCi8q
	tHf8E5nbnkQeffxP0AFA+b5ZGrEC2MGzo4fYVF/qpqcB5tmEhiQ+hraT65TuruD7G8cbGLvuk5O
	E25Ei6iAxoPIXgN+WQf36Dx+PFyCYSpRkM/mc8wXKc8ttOHzLKGGbpLQLRmkwHT2hcXjA4hSroi
	g72HgZJY1O/im2wWXrV67PULaN/gyURPHXfPkQ==
X-Received: by 2002:a05:6402:a21c:10b0:671:9dec:ba3 with SMTP id
 4fb4d7f45d1cf-672711d3509mr270895a12.13.1776278659796; Wed, 15 Apr 2026
 11:44:19 -0700 (PDT)
MIME-Version: 1.0
References: <20260413185127.128180-1-pasha.tatashin@soleen.com>
 <20260413185127.128180-12-pasha.tatashin@soleen.com> <ad-xwh2Ecr3Yg270@kernel.org>
In-Reply-To: <ad-xwh2Ecr3Yg270@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 15 Apr 2026 14:43:41 -0400
X-Gm-Features: AQROBzAm6dBwIuInDhC_BczhgxGme7QKv_GFc3kbSYJUQ8UndxZrGzaf5vLCT3k
Message-ID: <CA+CK2bB_qFMzf4U1oMSGCDXuFTgp+1g_JrHgfpBuKSHTwLLvjA@mail.gmail.com>
Subject: Re: [PATCH v4 11/11] liveupdate: fix return value on session
 allocation failure
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, dmatlack@google.com, pratyush@kernel.org, 
	skhawaja@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B919D40013
X-Rspamd-Server: rspam12
X-Stat-Signature: pgy8ozrtkdwsz7cqm7zy7ms8zu66exo8
X-Rspam-User: 
X-HE-Tag: 1776278661-57761
X-HE-Meta: U2FsdGVkX1/r69x3mZ8VQPKx4zHCuJYABWE/Hds0F1Z0Lh6t4/tJGxMW1Gnb5v6cjder9UKqphp4N7xBIbE33/5+u69XWe4xWMkRQg/Qmtc2J4WdUQkXxaisMrQG/9IB4+tl3jIjktaBZcYtmnYc3U/EOkNPyNp6TxpKNTe/nWUXl9d6L+KyZ8g2AGkZ7SMkhZmT/LFCBLe2mSII1IY+cX6TJLhLfxigHoCQpoZ4lJwuDjXNHZKnaKeEUPLhiQtV7rpBQQHp0QfDAev0bWYS3TkParJBnfo5RMGvvlkKV7+Vb4+CaNbDWu2xHAgTxtDdPNklybarTDETgy51De4XXZRK7HBp3kRwMH41WYbq3PQ+tPR0E+rUpORjMQ5hRA+Td8ozMVzk7+Lk9XfUQefUt8hu44yybKZB98ptjGrJqPBkohCp64BL7Ej9CwMY6S/l55ggrFvmd/UulfROpZFhOZtSnQDTDhOh88FjlodXO0EsFIl17/q7W8DrOOLR7VUUR5MR7KwZGJGEA/oCCE3NuL0mPwOihngfQqRZA3V+c9xK8f/0yzymjSgb5H8ZhyxPc9X0wUjwD3A2DdnmFuQ+slnjl8GBunOt4VThgWpABomeKB0w50ks9eKxj00WldLQF4rQkiFq2oBq+bkIsP2TOvoD2pS023va5pZQMmcCeUB7nTeOQCW36BXi/+gik0KoKZx26jxvNMzCcUO/sKVsyqXMJu5jb/QlWT40OZwTiUh2MQv5OkyViILBDS/ckIqz7cjxQ+464Io2iI2YD1XaTu+/ZREEtuiYwDH+lkFzxjBq54NLqKEqSBLhzSH9oVhnN0dKBJbjnMea+Um+wD8TX2lDgLNIJX6jDPT7Dyp51agTfB7sODwRLpX6yTSN7w8ppersWYIXuBFHK/EsV/LSPSRM6USrS+5YExwxaaGciSD1Pg/N+v4NxYyPE8hKKpfU7AGQOaZyhoeSPiXrb9h
 fBQU6HUv
 dayjiq31CZNQfdflYUnUjBaTLJfQz19UtLsHMeSsSXF5QALgb9kqqD20hgRECaJL+tL+9CQj35KsVGXyqnTUmgS3IihGtKvTZ51pbJXwylLJmYDRm9kweEfnXR0XYwCgLPDlI35znS3LMCukQKs3O/tdPbtuprttRNAIx3ACOV3X8CoiD/rAijB3NyaWBOpJqA5OPKQI9Gpm1LNp5/nr2dxklh+62BnwpnyDjJt/xhXaosUzx/C4Qv0BUuXyLTlVm6eydj1r7lGofGZVy3z7n0Rvw6ougvh5ge0IE2eGDDfKhIgtRjDY6gFaBqaSexTgyeGcX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 15, 2026 at 11:42=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wr=
ote:
>
> On Mon, Apr 13, 2026 at 06:51:27PM +0000, Pasha Tatashin wrote:
> > When session allocation fails during deserialization, the global 'err'
> > variable was not updated before returning. This caused subsequent calls
> > to luo_session_deserialize() to incorrectly report success.
> >
> > Ensure 'err' is set to the error code from PTR_ERR(session). This
> > ensures that an error is correctly returned to userspace when it
> > attempts to open /dev/liveupdate in the new kernel if deserialization
> > failed.
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> >  kernel/liveupdate/luo_session.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_se=
ssion.c
> > index a3327a28fc1f..92b1af791889 100644
> > --- a/kernel/liveupdate/luo_session.c
> > +++ b/kernel/liveupdate/luo_session.c
> > @@ -547,7 +547,8 @@ int luo_session_deserialize(void)
> >                       pr_warn("Failed to allocate session [%.*s] during=
 deserialization %pe\n",
> >                               (int)sizeof(sh->ser[i].name),
> >                               sh->ser[i].name, session);
> > -                     return PTR_ERR(session);
> > +                     err =3D PTR_ERR(session);
>
> it's really not obvious that err is global and it should be set before
> returning.
>
> I'd suggest replacing all return with goto that will return err;
> This way it should be clearer that since err is returned it should be set=
.

SGTM, I will send a new patch as reply to this e-mail, instead of
re-sending the full series.

Pasha

>
> > +                     return err;
> >               }
> >
> >               err =3D luo_session_insert(sh, session);
> > --
> > 2.43.0
> >
>
> --
> Sincerely yours,
> Mike.

