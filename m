Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27396CA0FF2
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 16:23:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58F1B6B02B4; Tue, 26 Aug 2025 12:23:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53B6D6B02B6; Tue, 26 Aug 2025 12:23:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 451166B02B7; Tue, 26 Aug 2025 12:23:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2E55A6B02B4
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:23:37 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 015DEC01BE
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 16:23:36 +0000 (UTC)
X-FDA: 83819429274.17.6D935FB
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	by imf26.hostedemail.com (Postfix) with ESMTP id EA019140012
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 16:23:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kd5OQve5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of pranav.tyagi03@gmail.com designates 209.85.208.177 as permitted sender) smtp.mailfrom=pranav.tyagi03@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756225415; a=rsa-sha256;
	cv=none;
	b=buYkDJR6zIbBQlJNUG6XQi7l4CCbmg/CZjSxivKHMC92ZLmMDczafDTw7JKXYkMRmuDn3L
	1r5piUBwR9jq3GFZx2F1fMsVov9G8U3ON9bi9LxlF/mXb2d8g51jsy2ODGX9qSPVhG/Upk
	g1PKsZ9Ot/9wJUfSsIdP8hQf/hFtPxo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kd5OQve5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of pranav.tyagi03@gmail.com designates 209.85.208.177 as permitted sender) smtp.mailfrom=pranav.tyagi03@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756225415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6aYFk7sq5CM2dSodTk0DRa46bB7zw/9j1RzjFIhceTA=;
	b=oxONJSEfT6XV5DymKPa3lSm8gkSfIH5Ab41L/1mh8s17XB7pTyWFMbfzX6zBmt6rldauVq
	v8BAPni7XeVxqas/OZK9APbbtYIyBBJ++zDlqNhLUHiwH8EtVoJSv6c5F6AmZlsTQcyKl8
	sTc/oqwF/iiaWOwz19X1adp7s7H5Nwg=
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-3368a889717so5906841fa.2
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 09:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756225413; x=1756830213; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6aYFk7sq5CM2dSodTk0DRa46bB7zw/9j1RzjFIhceTA=;
        b=kd5OQve5943sAtQIfkxqKe5/YsZ7cTMHE6Fp6VgHvBwKgwRoqKPCuyL8rQZ6db/nX4
         sIoQZw09DN/vneUFau5MbYKo6iAu4CzOc/286ngZyvrSldWteGZ/ZuW2uwJm5EKYeNWI
         GGFdh74/kzyDsTYz6JHRfipw1C8vKtUIj9SJgXpazaR2d81N6zSS33KZ127+2X063eu6
         iSPjk2Qp0IuYFRJ2DOGQJtX1hVE8z/+qENCGh8nS9mQ0wFU66pA5K6ikoti1J6PIXLEH
         dC3R5+MAgPHYS/BOO7s5Xy1qvs2P0e8Xt1yf0ZuziigrsUSPWh8pCaRooMga4jRyXaMy
         eTfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756225413; x=1756830213;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6aYFk7sq5CM2dSodTk0DRa46bB7zw/9j1RzjFIhceTA=;
        b=JoSvCFNMhe+0GCb9SVqn6SP64Jp2CsUAJE8+ouaWQddMWbjiqM4+MepoD69Z0L6Ofs
         MMxIR6T4/LwJCsj8zs/1QEV75r9HqaQojLte/7a59tMSU393nF7pF+TFk6Ymxwpdg8DR
         NqGrolK2wrsA3Ui6Cpwx/56gOfgmvN2AdwYYxEOKHe1X07R2/Ldity66ArQDKXqLh+IZ
         0Ll1lNtCd3MQwpnAWEcuX6TdS3HejRyMHw8xGvQgT4W3go+zRC2ooLgx7v4vttaSkj1W
         nvZQkfHG9xEQUCpQCqE5xj+kugTnr71M+vmJgccChRIeMhBRQf0yT0A9nAyxVevtJpB2
         KCLQ==
X-Forwarded-Encrypted: i=1; AJvYcCVL50vOqj+Pfg7eov1j02/L+6gt8/uRKSlOpmEhqMhlr1tRrgmxuaY+12SAFa3o66CnPnDUQ3RjoA==@kvack.org
X-Gm-Message-State: AOJu0YzXoEEF+H0s8WNqz/9zz+0bQuv8EziC4Nd/UNfnxdwtEsrj+jLf
	4Agp5fm/w/VCigUbcBU5jlqid82yW6IcC5PTQW0W8pb26et8pkY/Nc8Kbd21We9bqXTGkYSbQpA
	rTXYYJzvL7QohFvSqYebdZOwwabb6ZJ8=
X-Gm-Gg: ASbGncvSVtoNbEJwwnRcuV+Az56j6VGhJv1nOfy1XtBNoe7DEgFpHQRQ0dGweK6OAca
	iEUjKEVORHs3/9/afgSwP6BGC+iWboO5bguwow7gDDwrOJ8IGwWSYp/K4cMZoLq3tSn3ZjLcqwo
	1Vst461tqXg/eF7i8cc4lLZK1u+4zmZonoGCX+0gZp3M386S/1XZ1hKyoGjr1TiAmX70JuH6lFM
	Fikt4T6SItNPmGvVdfYN5FfCPFgM8vPek2l9cQJiw==
X-Google-Smtp-Source: AGHT+IFY8gu/RrCyr3edgcmpVM4R2w44fG9KMd2O0YJMqKVLqnlWjuRIpRapn1ch7o9iKR+T1hVRKcHiM4nMmDW1D0I=
X-Received: by 2002:a2e:a54a:0:b0:336:89dd:41ba with SMTP id
 38308e7fff4ca-33689dd43ebmr8627441fa.9.1756225412701; Tue, 26 Aug 2025
 09:23:32 -0700 (PDT)
MIME-Version: 1.0
References: <20250730142301.6754-1-pranav.tyagi03@gmail.com>
 <CAH4c4jJ8VywRUfn2z8HnA73vNxviZ53DZttcR3JaPULF3JFkQA@mail.gmail.com> <aJOG-IAmYhjoYVf-@x1.local>
In-Reply-To: <aJOG-IAmYhjoYVf-@x1.local>
From: Pranav Tyagi <pranav.tyagi03@gmail.com>
Date: Tue, 26 Aug 2025 21:53:20 +0530
X-Gm-Features: Ac12FXxDQE7gyOdZYAnPp3w1u4iY3ylCUDIqHFUVWVKzr1Z2KPlM4NdLcQSO8Lw
Message-ID: <CAH4c4jLsFNzBEhCQVSCT43tZjbf5wp88xU_5BXnN+4t5CxU52A@mail.gmail.com>
Subject: Re: [PATCH] selftests/mm: use __auto_type in swap() macro
To: Peter Xu <peterx@redhat.com>
Cc: akpm@linux-foundation.org, shuah@kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kernel-mentees@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: EA019140012
X-Stat-Signature: xydno3mcxnfisrkautaome19tg7ntyqn
X-HE-Tag: 1756225414-588697
X-HE-Meta: U2FsdGVkX18yhRSepphxsJwFE7a61x7hlsxlMk1FxRbtrjfbMDV625ggw5OWWVFYaYk+RbWawv7H4HA0sigJaIe4aTO0x3fb0WW4d8pscdBcsnMkr7ZpNRVFhdwRzQ2yoDmz5j7LLYjz3g6JYFAk1rqtjjMUpRTfR7E9bi3nsJlAwhNuFN6deleWsCPaq+rbZXaff1JSXVHT4WOrrkNKPoubL3l4/3gNbLreySi1zdEdPh4XAUHOOSPKNfwCkbnQdLRpU14o/GKSJybTw6CMCm5rMmuMoR8nFBip1VEDLl49+kSMkPDPhSZdHL3rh7bVeshKsCZRP4R7sEmzS0/UhNpziuREAYeyn/S21sCFmGTzLV6dcRC0C4tpy65PSsBhz44davhVut+jszn68s+NOlsfrx7SHHcIR6HF4wZU+oQcy/lsc+zm5C6CuBqA6KUvjd/u4KmfKJ/zoiI9foN6amKS6TCzjXDffvmWTmmSxdwqDNLb7mhxJCBvON0os7uf9g4yGUvcw0ovNuWix+FTobAKBWaPdiCORrDqxR171R8KGtu83Kd0P+Y2Am2z7+6UmNxuj9KI5SFPii+WwDZcyrBhyp3YDz7O3mnYdlOhA5mPdEqnOkePk65fZ9m74mdG/sebt/GyBjtz/EFiGGSvNFAjDvw4D9S8cTBV7JiQFKEZVbDtuum8buIklzS7jCQhVjFT9UidN2QrA3yIRpJTE2pw5xPvnm2s1qhptyyVkqD60wByHNiiSfHF228D2CM0/TvJEIzb1s0b0urw/n9uMaNTCVSmYLN8MVxoey4xx9jnqPCyhoHNM+uFB7DmlZtSXdA1Fa1qJbY2bVVKe4VtygaPfW+pngVphHXXaziaJzs0UZGzoCP/DSn5/nMnEw2OG6PRpHZXybN5LTscvRFLT3vCzeVgkvalSWI9stOpCnXyEQnmpN0+52fBmfZdZKmpjbC8HFdZZScuoi40uwW
 Lmc4JomW
 BkRhPzztKGvQkfmAgxqhrtBU82G08d567cQGOCPQHbe4Ie7/ptRCJlPZaJnEoZsIBDbv8LHzUzutfu1TEFpFh/262uLudLu5L14KfOkakUtZ7Zni2LV6WguMmwtrbT2U8SsyDX+/iozdmfwIkqcJ387ZOZVv146zEPjCfBf6fTLD+Id35ctjMKQxWHLYqG0QX7asCG7DhDiPURmLKxXrAgxq3zvIiVdSR7nfTyytFD+4fYFaWa/D3pTYS9HgdG70N4FhomiJEP/sYxOg+8cxkmF0Y6AmxIBrROsxd8RgHz4TBZgxehVBxI9h5pQXJA9ihLvmjNI6PMq/0lqqDHP+qIgjMSWoCgE4Kla+9v0Ygw64bzHkSZF3GSN+dl/QswaIIAmzAuF5N0Zx8pvrc4LkyaEyNvpAXgGhD/LKkgPQ3JJHX8BlPdc+ThKAWqx5GnkKtoLHehfwTY+LiOzEsPrWyWSYvTHjRJPEJYU8H
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 6, 2025 at 10:16=E2=80=AFPM Peter Xu <peterx@redhat.com> wrote:
>
> On Wed, Aug 06, 2025 at 09:15:50PM +0530, Pranav Tyagi wrote:
> > On Wed, Jul 30, 2025 at 7:53=E2=80=AFPM Pranav Tyagi <pranav.tyagi03@gm=
ail.com> wrote:
> > >
> > > Replace typeof() with __auto_type in the swap() macro in uffd-stress.=
c.
> > > __auto_type was introduced in GCC 4.9 and reduces the compile time fo=
r
> > > all compilers. No functional changes intended.
> > >
> > > Signed-off-by: Pranav Tyagi <pranav.tyagi03@gmail.com>
> > > ---
> > >  tools/testing/selftests/mm/uffd-stress.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/tools/testing/selftests/mm/uffd-stress.c b/tools/testing=
/selftests/mm/uffd-stress.c
> > > index 40af7f67c407..c0f64df5085c 100644
> > > --- a/tools/testing/selftests/mm/uffd-stress.c
> > > +++ b/tools/testing/selftests/mm/uffd-stress.c
> > > @@ -51,7 +51,7 @@ static char *zeropage;
> > >  pthread_attr_t attr;
> > >
> > >  #define swap(a, b) \
> > > -       do { typeof(a) __tmp =3D (a); (a) =3D (b); (b) =3D __tmp; } w=
hile (0)
> > > +       do { __auto_type __tmp =3D (a); (a) =3D (b); (b) =3D __tmp; }=
 while (0)
> > >
> > >  const char *examples =3D
> > >         "# Run anonymous memory test on 100MiB region with 99999 boun=
ces:\n"
> > > --
> > > 2.49.0
> > >
> >
> > Hi,
> >
> > Just a gentle follow-up on this cleanup patch. From what I could find,
> > this is the only use of
> > typeof() left in the mm selftests, so this should be the only instance
> > needing this change.
> >
> > Thanks for considering!
>
> Hi,
>
> Andrew should have queued this one in branch akpm/mm-nonmm-unstable (even
> though I'm not familiar with the branch).
>
> Said that, I'm also not familiar with __auto_type.  Looks like it's more
> efficiently processed by the compiler in some special use cases, however
> it's also new so maybe some tools (sparse?) may not recognize it.
>
> Is it the plan that the whole Linux kernel is moving towards __auto_type?
> I still see quite a few of typeof() usages (not "a few", but 2966 instanc=
es).
>
> Thanks,
>
> --
> Peter Xu
>

Hi Peter,

Thank you for the feedback and I sincerely apologize for the delayed
response.

You=E2=80=99re right =E2=80=94 this patch was initially queued under akpm/m=
m-nonmm-unstable
and it now lives in the mm-unstable branch.

The motivation behind switching to __auto_type is twofold: it reduces compi=
le
time across compilers and improves readability. Support for __auto_type has
been available in GCC since 4.9 (quite some time back) and in sparse since
v0.6.2 (2020). To the best of my knowledge, it has since been widely adopte=
d
by toolchains.

That said, I acknowledge there are still many uses of typeof() in the kerne=
l,
as you pointed out. My intent with this patch (and a few related ones I=E2=
=80=99ve
submitted) is to encourage more consistent use of __auto_type, starting wit=
h
selftests where it is already in use in several places.

Thanks again for your review and for pointing out the current branch status=
.

Regards
Pranav Tyagi

