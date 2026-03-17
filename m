Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F7BBFED9EB
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 16:39:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C65C06B0005; Tue, 17 Mar 2026 12:39:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C16016B0088; Tue, 17 Mar 2026 12:39:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B04736B008A; Tue, 17 Mar 2026 12:39:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9A6EC6B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 12:39:22 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3EAE81602F3
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:39:22 +0000 (UTC)
X-FDA: 84556115364.08.A02EB30
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1CD584000B
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:39:19 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=e4Q0h9cS;
	spf=pass (imf17.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773765560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M7sJfLF5I6/Rhit4bg4ZJG0NGnrJvX7/hS6JTmMC1Y8=;
	b=PIOIDMFUbpB3etaQixLqHPZwTI7sWW6FnSR+e0l10/zs+VZOU+bpGsjVj0WZE2vb8EFM+X
	SDvIIHBcvyD324dtsFvPPvhSk+kcDx+32zsqbLUcsxxUSlNMieXC2XKKhmcjcYnNOMt/OF
	QZbBgvUaUkhYUtUVb4mLV78ioxM2H+c=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=e4Q0h9cS;
	spf=pass (imf17.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773765560; a=rsa-sha256;
	cv=pass;
	b=6qBb/zdYzXTEJWb7Fhl2dzYJbO1gF9jo/Dqrg2fApbQBqf0asfCPZzuKk1XqAPeKYFN7E7
	hZZSXmckUwbEJeaj1MiDmsYf+LaGrdOzS+rkEulbLL+9ooH7Zk9wmuRRsZOEyH8hQ+8m6E
	OeiWN6s9MIu9PNN+yitsGOtBGC6Jd2w=
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5a1330ac6c3so6327986e87.1
        for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:39:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773765558; cv=none;
        d=google.com; s=arc-20240605;
        b=k1KdiduTW9jJcThH8dXQNhZNN+eeiQIhsidGxFtbpujG87YW8EOfe05GHpqS8nEQH6
         epLhz+NaOEWLu4XBvvJPAkBUlpauqjGjMVkpzsEWPb+ESRbYKha86QgMSM6x2Ho7hmbv
         1bNSLOStrFD10E+lzLzDLY/BY6zLIPFvO0fKkTIha8Jacu/+UiKHnP79AKoocs2oYGDR
         u8zN4+iMenJ3pftlhDCYNYgIZbsc8+TYXJHTxB65TfjYcMvcZPksz9oq53EA5VgExpdp
         C3yn/F5vV6KL2PDd0kc1xkPHcDCiWAuwnnts/GasqLnNLWQx7+c3jQNcF78tydwyRsrF
         kikw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=M7sJfLF5I6/Rhit4bg4ZJG0NGnrJvX7/hS6JTmMC1Y8=;
        fh=xj8a4MFQDd/+8O/Ad/bC4225SbTJKqq36SL6A7MhpsI=;
        b=FahjZYl2LeSxMQaicFfcjPfsmaMJz6Kn5v+AxBRlJk4i+AxyKSTwqveX4/j44hJjZL
         SGv6t0zq2NitZL3fjC5eodC4CVfPTJS5/QepvepIuexM2MxLGm7nj4e4X9jpz9jSqrDI
         nkEhfnxyjDhFfI38OUJquzBdNonx0xbXEqg2Hlx0SDdeB6UWkI68nPHRWnQdHXgIY45w
         oKvgJRFMQUW38FtEc9ylQU7Kb1NpG6Tv024luyIUZNN8oRBeWoNXsmWHtYGcGlxSdsO3
         PyeG64989R6VPj+/szp+D3f9R5m1jxJYKDE1M/hLO0gACEH1aN57y6gX9lygtCWU/JIQ
         Yvaw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773765558; x=1774370358; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M7sJfLF5I6/Rhit4bg4ZJG0NGnrJvX7/hS6JTmMC1Y8=;
        b=e4Q0h9cSqQ+QX2JBGKf6YgqY8aS8GZGYkNgAkKipG2EPjIkQ6Z+nQptl1piriWfKnI
         6veLgOaweFed70Gl/L44Tmoj94jm1f93naT8ljAV5v+dwWyA4MfZkE7VilJv5SRHGYdd
         AFRx4jXA8d7Sy0Vp0paHJnHRhZ8HW9YHgz5ZQOXJmce5hGTnv88I9prbZ4gBXvD0lAo4
         +bYiCJ6Md1gnPdKLAss5TaczaiW865PQv4Rfk65KP9itNw03vb6qvatDp0AQA+ZMQwBY
         jYux4+K7lx1s39gBffO1lWSMkZOoMVq7hDRneURyLnt+VkP6E0qTSDkGgI+OQ7CwTw7a
         GWGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773765558; x=1774370358;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=M7sJfLF5I6/Rhit4bg4ZJG0NGnrJvX7/hS6JTmMC1Y8=;
        b=OU+YdR2/sSD/loFZF0wjIkNtACMPF950kKUhwk1EKpPg9VvlLseyDkzdUIHoPxwDyo
         GwbdHxgmpYFV8jpdY5mDjrF5ZPTPuYstfNWUjCBSZoEeJdgN7ZfPZfvne5GiTJ6W6mIv
         RDBdCxxwjyFYrRghmh+LIrnWsnsNQa4R/nt10GNYaLh8Jvd6oJufbyCxFxejJiqUbGhw
         sXGd9Vf19xM/cjhJsAiiUL2m7NApY3TkbzFfPAJo5YWH8iMY4TSV3fA5i4K+EeT24DOk
         Csgoz1+XEEmRIGeBgYYa3qJqeBNiXt7U6S7cI9OaKZjhg2IRyC4ZSunhKf4DUKFllGwV
         9+gA==
X-Forwarded-Encrypted: i=1; AJvYcCUu6udz/+3udJmCm9ap256U0msefVkTVyViTGOcSd5RsxxF+DtWxLOzTiMSLpI5a22dpZ5luThO6A==@kvack.org
X-Gm-Message-State: AOJu0YxgAcEn7czJVSvAu0EelUv8qvzHpSPgbYjNGdz+WkzAg+FUzNfV
	2Jn+wEd1x7fFUXBub0+r6GAb0UhBDGj7XGOvUnBK4pIVVCnbbUKiVLCMQTiomNuMMRIEvZ8h1Pl
	Gyo2IC4Vd1zt+SotV50OzDpBdzD3KVC2frHmgY1JK
X-Gm-Gg: ATEYQzxg37KYwKdKTK0lOOfu7HKoPqVVIrswYu0AiLT+2mp7PZNP+Tb5ir1DZ6VC2TO
	Kb3eyeTyvEF4MkqihXT9WKMtWddRV3/Kzi/lxznWSt+fl75PfhgXnO6Ksy4T1OEwpXhrdJdo6f9
	xDKLquL+9A1wyAMu228j8Oga43N7f6fpcogwl+58pTxSFofd0mgbgKhgq2NpmtORIYcSX5F0EbY
	3a+Zwihb3SR2Mb8TrOy4pnvw5PTSBhWTqletJIsM3hnhdZkfHBXSfvBj8c/PjAqzTXMuPNP2x1f
	m0N7g8sB
X-Received: by 2002:a05:6512:3605:b0:5a1:1074:e1ed with SMTP id
 2adb3069b0e04-5a279699781mr68304e87.11.1773765557662; Tue, 17 Mar 2026
 09:39:17 -0700 (PDT)
MIME-Version: 1.0
References: <20260317025049.494931-1-pasha.tatashin@soleen.com> <20260317025049.494931-4-pasha.tatashin@soleen.com>
In-Reply-To: <20260317025049.494931-4-pasha.tatashin@soleen.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 17 Mar 2026 09:38:50 -0700
X-Gm-Features: AaiRm51I6Y9jp9_Iramv-jPdxRAPpMtjBUm1hRG8sOIFy-KOi6SP_ShQcC0KoCY
Message-ID: <CALzav=cY4G-1MrEv1zNbqjdu3eXYnFLUK4xgo0r=DrbSdsXPLQ@mail.gmail.com>
Subject: Re: [PATCH 3/6] liveupdate: Defer file handler module refcounting to
 active sessions
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: rppt@kernel.org, pratyush@kernel.org, linux-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1CD584000B
X-Stat-Signature: tuy34t6qgq3xgw49jgexymoh7hf9bfbd
X-Rspam-User: 
X-HE-Tag: 1773765559-169107
X-HE-Meta: U2FsdGVkX18T+10D5j657QS72YGdL2DX+Wv1UTkwgTtV39pEypOoKxPt2f6eLaFlp/8mVXipWkL/TCv/4GQSxyRf+MRbN61k0TTXNENn1lf/KtJwKM7yX2QBO4BoXhGVqtGz5ZyhQ5izUvJyir8AhL7I4RHptdNxJbGZUF6TvLbzs6tzPc7Bn+xL6yv36tr92oltQgnCcozxoODSjAK4eoG3K4Gp1kAAlmWg7J8Lnhp0GQ4XNekHyLTzdkLciWM2gSriIlL6QOcxa1qOK3UBjQRFHHanNsdiOw+TfFHlVkHo9g40OU9AkdZAWP0VmJbGSB7guD9n3L1acmSIjkAOlgLc5NzfefiWLO2YeAJQx2Z/5Tny6L6lb3CwvVc/NNDR6UW/JAwTs0RlGgHv+LZniAIdOjw3CXSoqPsEl2bh63Sc2S8/EH1MlD9V0+bbsQ+f/CKxDKyKqAaOTbDceF6tp99sO/A0MgNemvBKC7iy0hO4ybrfb4cl0Kc/fu4kQqmDpA1z3io2Weh3tM8q2xqao1UP4oWF4SUuupzXjtUxzkJ53qFyANcXUSUBxWqTE8u7WOkwT6Vc2mkQGeEAN2RdYqrWSzRfxUN/T1tez9jhIECQGehBMU+BsU98j5CGxReyG5v34MzfiTeWdUQsAOP7mvLcU7P5lTP5w7vF9Ig3t1ZuNlruzXilAbZldKv3jzJTWtTQIE0+jmH/6cHfZevSp3DK69EMBSd15Vr5VGVXDchGNMRaEOPV02g99kNPMhzFz2ga+nSgpvTI2PPj3r8LGdW4PzshUVjWNQYxLzHKEERdk7BjlsdgzjjDH7nIpq05X/9Oln5+VNhZjdQ2SN5sq9G6wIn99Vz1uarifJDGDB35AcfzlgIUtqE5pXsCgB7rorOQWovQALU1g3cJruCFbx5NlHD9/aYFAeQowNgiHwm8P8ZEPnymnTQ0hdg9ujhUEOY7E6GlQ7aVAi2TDz7
 EBMYv5AP
 7Odq3okZz/BKLKfOQL58UXQ0LPK5m+CRFKR9iPuc1BT1Ax7rH17HAHfnFJHxT4DY+WRaUS5Hp2Cd2IaQVVtYCUVLVB14LgvIZqs/C2aESnH8iBbdm8uC2HMALARlVnUtZ6/z2OePkQHnIS0K816T70NAAB/NLebSmli8v5NUHoV8eGCr9p7B8UmIcrXPKqdT6AzFmgpPld09MmyCq9h9V7m3Un42fZWuTC2e79nNVVuzye9SMTMoenpegdro7wcc0kg8jwE2gPEd0zCPUGh9JbopdQwY4NX08dLPT3oZP45GaiQw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 7:50=E2=80=AFPM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:

> @@ -281,7 +282,10 @@ int luo_preserve_file(struct luo_file_set *file_set,=
 u64 token, int fd)
>         scoped_guard(rwsem_read, &luo_file_handler_lock) {
>                 list_private_for_each_entry(fh, &luo_file_handler_list, l=
ist) {
>                         if (fh->ops->can_preserve(fh, file)) {
> -                               err =3D 0;
> +                               if (try_module_get(fh->ops->owner))
> +                                       err =3D 0;
> +                               else
> +                                       err =3D -ENODEV;
>                                 break;
>                         }
>                 }

Does LUO even need to take a reference to the file handler owner?

LUO already takes a reference to the file, and the file should already
be holding a reference to the file's owner, which should (must?) be
the same as the file handler's owner.

For FLB it makes more sense since the FLB's owner is likely not the
same as the file's owner.

