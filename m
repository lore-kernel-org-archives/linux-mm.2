Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E1B1D3517F
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 18:59:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8437F6B0005; Wed,  1 Apr 2026 14:59:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F40E6B0089; Wed,  1 Apr 2026 14:59:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7095E6B008A; Wed,  1 Apr 2026 14:59:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5DAC16B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:59:38 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0B5EDE02BA
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 18:59:38 +0000 (UTC)
X-FDA: 84610900836.23.7A038B8
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf23.hostedemail.com (Postfix) with ESMTP id 00066140016
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 18:59:35 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QnzwP9SE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775069976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0i9YKqvf28dpGpqbXn02UAG5kadwAQZLMa9CVUhdlMs=;
	b=1F1E7YE33K3x8hkoCg7w23nAYvpq0vS71DJ0HllKKtdPgjxbGJ4GGtymNIdL66xBHKaScV
	77CSakEJRqpXJpk7ycEA3/OS4NSzd3zC6JkOav/aGTf0KQRiwGZxBoq7DzWA04MSKkhlX2
	H3YS+O2S/gwE4FV9wwSqJXbhmCEFcP0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775069976; a=rsa-sha256;
	cv=pass;
	b=5yI5tsAhiexKsv28DD0fsylIeskhNEidvcL+iO3xpdhXCJyTacPVpUMDYEVmxTXqQ3Sl71
	aF2sjxpla/57q2ujVmvWxPirnGdCUK8apmGhFEcizOFtWjwAzMfz9pkHF99ns5tBxTCh8A
	eaZhBe2BQL5Eyuc8aPswDqwi/rnj8EI=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QnzwP9SE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-661d20c9787so164509a12.0
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 11:59:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775069974; cv=none;
        d=google.com; s=arc-20240605;
        b=aE1ActTpnityOEHENSbh5aff7KWoRPskRb0/FbZ9ph7J/3ot8+c4htAlpxGXdS9pbj
         qchLZYMATF2Vv4d/wQBdktRy3i0B2nPI7PpIRf+nP+pkgw8lnhm0eWF7B24ff7+P8Tth
         acy1IO7G8GbtyniCYtrTCaqF2NzlOWhsKztDTKyaircinTElRTjzZ9wCfeq0c1IppKGO
         xIY5VyLjRVsE0KbGJHchX3gkTavW7sErltH18hHKJWbPbq0FaB6lGm2UXKt2gQ7eo94w
         bgj9PQcfkAgaxVd4HPdzsfnliNOX04BY4qMyxVVYUwqZA50+LUZekwiYaFVDbHjnKiFD
         zPyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0i9YKqvf28dpGpqbXn02UAG5kadwAQZLMa9CVUhdlMs=;
        fh=qv4NSRwFu3Lu9gKqrNOWGzfhll9UE5VJ9A67GweK594=;
        b=blpUvoMmdnqkcX4zo7zE5ZmobAS75HzT9isrr1kfiKSHlqq+Sx3U8V2PoEYuRJpejr
         QoxK4OSZZQcns+yqF9jQdH33yZp8T5th5BPfzB4Xccqld7dCo3vpSK1sjFAc1rAgHbhw
         hL0tfZYImcVVARbAvQNmunCu8vjkw9LWX4KmZwDII5hNmaxUcBiFi6Hs6HJZphLzTlcI
         aJga0UXyPm7atoWQJIEGecRhVNSQIeXtOd10YFqCzUPsNvYsWKPdlE8BlHiShpHhLwHR
         t6l9IoNZspxs3Dl8HdBAvTgOjG7sU1CcmXay3mA4itqgPEhKcKXl9kGSnplRfV4irp9l
         TXEw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775069974; x=1775674774; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0i9YKqvf28dpGpqbXn02UAG5kadwAQZLMa9CVUhdlMs=;
        b=QnzwP9SEO0mPWZQALTaHwrudmeRIJEWfEoIwj0LM7IoR9fOnijFZXd/TqNlJm4cFaq
         WSpgfP8wHJfJvo00in3HIvY697aOVW/EpIkVpkLg8nkEKwhh4JZQSmQOv62evgr7Qvhf
         zBCnZOE5boXACxf8bbjyBZNBjzeupFMwDSsU7K+v7v3nDpTvt70bVukESYpqSx4LJ8BC
         PlxGj8IoIUvQ2ljz6f6DNGidDdaEYHvO/ZGbpv1Kln1efsK3JLeINGb8Rf50vHpA9C5u
         gfKyxe1zv+p4SQX701traO2vIEITUh9mnaegeA3uaB7mZAQwoMGroaqXClRcF+RhW2ok
         PH3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775069974; x=1775674774;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0i9YKqvf28dpGpqbXn02UAG5kadwAQZLMa9CVUhdlMs=;
        b=somhzkv4s1C8ddokUzfZLZ2M39+oJeftxek8T+ONFIFl/2aYNSVglQqV58fdHlMsPj
         it8uExMDfIU83FxssAxR/H0zDxIf698sJF/k5FVF3OcZVP12/qdN4jqgOBc4PoUy+f9U
         PvVQHsqV1b4pdPiG5Bgn11smSiXo3QEAqIbwG2fBfiVmwvMtf3k7djqOCJnUpoyY+Rt+
         cf3ibj7CnhYSZINJ8c7hl2zJIC0J421yQz8ARecUQSpkz5pShlKXOoYveuC6FfrrdKQS
         ty/MZPyIJ6j0gaiCwEyTUqLxRkLUDbOgDqFEyGD3+CGh3gZzJynE8y3oFgeFppTxuhEu
         698g==
X-Gm-Message-State: AOJu0Ywd7YQ8Yty/4RsPWj9DxUpgyOiRKXo8b218iO8pSY5HMuC7Hx35
	pxy0u0H0FpZ+Ulh81CIDtG2X9pWEDKyGQjRYdqxtidm+nEBTwIKcJhehDqm2DQj8wBN3SrOvt1h
	SwufnZF5q/v5oGIMPay7cBfQaPg5o/3w=
X-Gm-Gg: ATEYQzz1T9zrsMME3XHnqAisaiNZreBT7ZUFNPb5nyjQyya1V9wAQ/DeGxZ50987kts
	DfJOWeFvpifQYcqHDTwyV8Pj6qQZOWpo7OAWSwCrxdCr5kXBsA2agZDh7Jgk8+Q1ycXIUNWDVbA
	HLFClKNhTP84tggHbsjLFaRmZGj82CohtGg38doEIC+V3f9sP1kKaXtfMBDgIJhbQiveAl3lyWm
	tCNk1VUA/qKnAe9kkIhPJKaRT6xpp2c4Ve2Oko09zit+3bkOSAFbLgRXtcVTF5dv4eJva7qEwP3
	I7msS2ITcN1p1Py82XRCAehfsKg06BaJDk0paMU=
X-Received: by 2002:a05:6402:34d4:b0:66d:d25e:6588 with SMTP id
 4fb4d7f45d1cf-66dd25e65e0mr2119583a12.13.1775069974477; Wed, 01 Apr 2026
 11:59:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260401131226.4011156-1-mjguzik@gmail.com> <ac1psq0rx_GOWyYi@home.goodmis.org>
 <CAGudoHEe6yYJX_qUsCk4EhWDQQuM_4c9resO5WRJ+yix-6=hPg@mail.gmail.com>
In-Reply-To: <CAGudoHEe6yYJX_qUsCk4EhWDQQuM_4c9resO5WRJ+yix-6=hPg@mail.gmail.com>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Wed, 1 Apr 2026 20:59:21 +0200
X-Gm-Features: AQROBzAtXRZ_CwFo5re774L0ZeHV8vzCeImo5_ZZnpTqnzZySVPVQvUhmy7njOI
Message-ID: <CAGudoHGattJEBvQNEdcFBEB-Vq1mOMbGSOH_uy4MSSy74aaQPg@mail.gmail.com>
Subject: Re: [PATCH 2/1] execve: only smart people should use vim
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 00066140016
X-Stat-Signature: w5bja6mm1pyb88q8xinfgwerkeef8yrz
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775069975-190400
X-HE-Meta: U2FsdGVkX1+rRSA/jtVqKh0u6CXbCkXr7rXpKRD6FvIMnY5Ew1F3V50DL0IAdNQQD9J9YrtTx19ULH+XuC7Am4Ha8axgEXhB42Hezb5MKcIR8Su9Gy6Kw25MOno3PIlFbQm3J+zKc1f62jIyJzn3zEtyTZ6Srnv0P5iRQPbNRvawiL8I0W5gtlsjXOQNd8pHSI1Ow23P5EcKrQzELKYirYhlBUA8r8Fl31HNmEd9CytFTt59ownCb5mCGTD5uwTunML1KnAdEPDkanPqaDvfAdAc+vKSaaXvtXcSvqexzs5CGuAtQON4+iCTLdajD712Ryr4ECl8GIlxO9hrAQAgBJ2Nc2GqzJQy1skQx4eASx03sT1mfGPRagl2uxLnvLMlQyu1ABO5ZQZKr3eKFHbScpJLsum6M6kumx8OQm13uSrVNF3pb05gHBGyu3aw5/BnYrwNdVe7afx09I0k3/TxUdOAZ7aAvWYUJHDTZBZNqrvoEPgeLtRHSh1BbNgoGpPJLeX5bp8ZeRAC1vfry/b0JEGLlMKrNiW+nuQuz23H7y7jXMIdcKRvVi2uNNoh4tmZdFEjG0BjGeOiTpFEwTp3ixxRBtqckKYpiFgeT/JtFtyznikWdHY3ViZVuipbz7Y/m6MLrcoCjCmT/twUAnAOSBpCYtk6DLCNHvhQ+eHLX/CLCpshkU3PrjTBPG7LZ+92ZBqRQ56tXe1YHOlV6K8a2E3eZBRZ+CjTh/PzMgQmlah3zqB6RyzAY6IXd8IsamrhM3OC0ywD+pEMWSUnCeV4A8mtqTOgfZO1FCo0rVRbwm8GgBYW2FLQX51xMaw/LdkMg0p7roGSzo52fRMObbVVVl51+2EK1adlzgPW/oJbb1C0F6geGVKHvtVR0AB2PTLKmBzspvoO60e2A/ZMF9vyUx4B5BoI0g9RWm/1/Xeo2aG4P/iN6kqgLM0S9DGDL/obEQbpZyv3DDuU85/FuI7
 MjYbojkh
 C3KB7mTrv+TQNyUye5bWBYBeiwI/J6STt4je8RHTr2LXN3snJqlaOaDl0DayyqBtPedrI8D8CiZJC6XzS+JUPM0ub8Tlfh/jLdRB4DpkO5X81EXpOZq1QvwRSm0wh2W2832HUH3JCncXEa9xSJkSfWC84Yjfe9EPAQAfJ9H3orzjZEuiFpcdyaCk/Ttl1AUhkVlvhYOMSvg6cfSrADKcrMk9f6q+hQsh/4VEnZwTndM1yU+EW9mJDhCX1V9X11WIflstO6NZfFdzOrdpf/kRYyL0rpZjtYl/Kvrv3VIoxjrNZZwOgF9I0YoE1FLQy9zOGrZ2zgeulmMnSajjdDEtqX0KF0ckpw0+tUv63Ut8QZ97fuHTi7GXGUSDzAxCkpZ7wVC0zZ07Ei2fXAc6ingECZhnoctrnsKdrehUOzg9GiZWJVmKEBqnNBU9psMRA23H2zv/uiEVyeF1Q/prtHWxhkH/pOKXBsGbjIh2NCcVFoSG5zYTGNitoWHKn61EbBJRKohno0Z30qLeybPJq5R8cqjgqGFWG1V1ajunXX/XG0qxnZI337RCWovbNhIxUCeQjCnTcUOlXd3EyixPKjwBHp2faijjQuzq0IGNMNowfA5rWa8xWj0/CHCECVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 1, 2026 at 8:58=E2=80=AFPM Mateusz Guzik <mjguzik@gmail.com> wr=
ote:
>
> On Wed, Apr 1, 2026 at 8:53=E2=80=AFPM Steven Rostedt <rostedt@goodmis.or=
g> wrote:
> >
> > From: Steven Rostedt <rostedt@goodmis.org>
> >
> > To keep people from getting stuck in vim and not knowing how to exit it=
.
> > Make running vim a bit more complex.
> >
> > They can go back and use emacs, of course that will fail too, but then
> > they have something to work on.
> >
> > Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> > ---
> >  fs/exec.c                        | 11 +++++++++++
> >  include/uapi/asm-generic/errno.h |  1 +
> >  2 files changed, 12 insertions(+)
> >
> > diff --git a/fs/exec.c b/fs/exec.c
> > index 2e954b31e3a2..ecb425388008 100644
> > --- a/fs/exec.c
> > +++ b/fs/exec.c
> > @@ -1741,6 +1741,17 @@ static int bprm_execve(struct linux_binprm *bprm=
)
> >                 return -EMACS;
> >         }
> >
> > +       /*
> > +        * Only really smart people should use vim. If they can't figur=
e out
> > +        * how to circumvent this, then they have no right using it!
> > +        */
> > +       if (strstr(bprm->filename, "vim")) {
> > +               /*
> > +                * Learn to code!
> > +                */
> > +               return -NOTEMACS;
> > +       }
> > +
>
> I would consider extending this to nvim, otherwise looks good.

that's of course already covered, my bad!

>
> Reviewed-by: Mateusz Guzik <mjguzik@notobjecting.org>
>
> >         retval =3D prepare_bprm_creds(bprm);
> >         if (retval)
> >                 return retval;
> > diff --git a/include/uapi/asm-generic/errno.h b/include/uapi/asm-generi=
c/errno.h
> > index 1a8fda40cd8a..4cc4ae653cec 100644
> > --- a/include/uapi/asm-generic/errno.h
> > +++ b/include/uapi/asm-generic/errno.h
> > @@ -123,5 +123,6 @@
> >  #define EHWPOISON      133     /* Memory page has hardware error */
> >
> >  #define EMACS          134     /* Editor too big */
> > +#define NOTEMACS       135     /* Editor used by smart people */
> >
> >  #endif
> > --
> > 2.51.0
> >

