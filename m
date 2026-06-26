Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFD81C43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 13:40:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A0666B0005; Fri, 26 Jun 2026 09:40:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 750F76B008A; Fri, 26 Jun 2026 09:40:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F16E6B0092; Fri, 26 Jun 2026 09:40:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2FF606B0005
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:40:47 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 98DE0C1F75
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 13:40:46 +0000 (UTC)
X-FDA: 84922174092.21.8759D13
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	by imf23.hostedemail.com (Postfix) with ESMTP id A291C140002
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 13:40:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QRZm2VNM;
	spf=pass (imf23.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.167.177 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782481244;
	b=HUfHmJLlfi0c/9cuqUJ7u5FMwAzNdGOdBjpgwN/S2QOpIRhUD6XD2edYPLm/rpe0jzUYLO
	1SvWFYulckCj81z09RRrOGbxpBZGkd8zDTgYr3wGqKd9IW0ejYGr0BmamTTYc08Rlom1UZ
	p6K9+jqldJsYHlU7pm31NG0Bt8bnCoA=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782481244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z7nOuOaqJ+HhEFHuQRDb5Od6EcEUrr2fqyYE9i09pn0=;
	b=0oY6c+0cXDgnRbQMx3BWlW6LAhKx8yWUgP3IIe07vYPVlHyPEB+c4g0xRiiH9+C8WpHfDY
	MmPD5dwFqTYz76rmZguzQFyqX8+YxJAgctvzHsTBTbLhEb/nDO4qr1fVNziP4vjsrWGLvF
	oqvM/oV/BneZEWr/jgAWVIc9WQ0fOQo=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QRZm2VNM;
	spf=pass (imf23.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.167.177 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-4877a7b451dso731920b6e.0
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 06:40:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782481244; cv=none;
        d=google.com; s=arc-20260327;
        b=rWDbOoc36JJP/PLONxl2SIo4vTSsxQk+bnAEGj9BKUTmXJer7xwUFWBJ/DS5abL7ao
         dwsSUhO8+4nIMCr0DsCeIr2iUDcm27a896ApZjbUZ1ztC4VTkhzuInW70/tPNthvv7uQ
         aIZYDFtd0BYKgY7zFqV43x1ibbZw6kdZ8iv+THZy7MApkg4LFnnOXzaDuVD5EbLRlHFg
         uEe3pW4CCvtSH6YYsOAjqUo25fawUX85xzjXi2Y/hXlvfteBRbqdFIZ9eDZDb3MNu9y8
         H/8SpkpUMkPxRXJSR70Y6Gjg32ET6PRWE3KSWyFEeQVmBKD8F6zA5p0MLOT7MhE7G503
         nDCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=z7nOuOaqJ+HhEFHuQRDb5Od6EcEUrr2fqyYE9i09pn0=;
        fh=J6NN7ZeX1YvXoAaYTWLFGIWi/Q3dttTDd9Y6r0hvO0E=;
        b=HbMYcXJ//0njcMhVyJYjV8T5KABL5qDTX7w0EG17IE+rAQskuuGUdfmT9fgzKCrcfW
         eD91fsqrVm2Mo4kImleasw0SR07BdWCTL0iINeR6oupjZQFggwFzm/6Y3iWs2aVCmWxp
         QcIykTigJK3a5ty6j3R24datQzOwrkxx7xvuIPoY1VE0SkGRul7Z6XLTOhziC3p7zBXa
         mlZWeS3fOVl+FFICcRNjkR5bXtaPxFwo4uZH0FtDYpiSsckoMKCy/+xoF853pUQ/kOSE
         XsL4ahvVB9Lsb5QTQQxq7/Fj4vKNxYyL1C9SjnT8vbvBEok173EMAhR0r7oPmu2W8ei1
         7RyA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782481244; x=1783086044; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=z7nOuOaqJ+HhEFHuQRDb5Od6EcEUrr2fqyYE9i09pn0=;
        b=QRZm2VNMv+eSkzRLvibknh0WGpXZBO+jpXnuKcejJpOradjd1RaV2RuBjf9nxcYL+R
         Lf3P26NAyETTPsPEpln/8Z9d8B0KExhsZ21ki8y+/5hJZPqgy6yvE8DLxV1+lOrXGYhL
         sqhR7BmrOyDejaS8loGVpSU72agYfmbb5Nhpk98WKGAzTnYOQSt0v6UYV5SZecxSdlR4
         AcUk3JJ9m940gE2iB/X+EmesK+fMAAuNNsK2IufqcYiGHwFUOemeAJYf0XsM8FbPUGu0
         zEoqtY4n0WIH2JW5qSZYc8y0Bx8xX5zU4QATGmPmjd8CSHY5zw2IOkN2N9XKf2r91Y5b
         SgVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782481244; x=1783086044;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z7nOuOaqJ+HhEFHuQRDb5Od6EcEUrr2fqyYE9i09pn0=;
        b=FUiPolsLsRg1uPpy9TED932I5mMcdnhzO+b3XaFQ/wBRIQ4A3GNQPCr8qnJRRc5Clf
         JAVTyMmztl0qClsARZMU7ofI8fMD22VtVICWr3jajQeHGdxYMwQAj6AekGqAyXbtMSp0
         zVGixy8zQtSJ+eGET4xmNoL3THn3Z4+C41/8coD9du1V/lGG1s8bbhBUqfbDjExh1ZkR
         35QUtn9kobw4GuhCxzFrCEjf8JVDnUW99/aMJqzuvPbaBnBIoBmXpDtkW0/LsGihVgTF
         7MGQ5N3BtwFK1c4BM6MfD5X2IY29q5EUzTND/gRdyEd6O5dXXUj89OGMRmBRN7XcqleM
         R7xA==
X-Forwarded-Encrypted: i=1; AFNElJ87bmOnZqwEhy67Kzpz9NA94PXyhKowbhwN2ceuN6hKddhfwhP37I1+4ypihS8XDukstLR7qdEj0w==@kvack.org
X-Gm-Message-State: AOJu0YxxJVnjsPGnvu+75heyFv33xT0ULnpWCDIgvahKW91U/AMgKF2l
	x5IYXJ9zVuRDlUOEaRI4xoUfOZKGXn6sonkX93SL+y3ak+Xg+/Gcnb+HOl2QCasU64+KhvpX2kK
	8EoRDIrpvd1j/jcmswvEcNykmaLtS06Q=
X-Gm-Gg: AfdE7ckAgkEbCOli56C3rpoqr0Bq4LHLJ3QOKMWuw/n1lB2UUuJ8qtdp7zB4GZqpcUs
	sggxsTE6IqQ8NYt5paHw3lPc3Dwi8OkRXaz6LOf+KKcX8Y8OGdWnlElZD6gMirG/NiFuZ1mwHZ2
	jzgIQP2cY4gGH+WPZu0KoTgdkE9hHoUDOaTjOk0ASBjrmIyByOQltRa4ezhWuGekfhwe0HiCR1u
	yQdqxibDleeWxbb6jvQ2XWCg4s3Hw0V6zEi9yPOUij7mZnwjFFLnuKQ6Cn9T6WOCv4TQpW2QjpO
	6KNyb/OCmfn6czoDeDMf5j3l9cM1BQg=
X-Received: by 2002:a05:6808:4f06:b0:48a:ddd4:6758 with SMTP id
 5614622812f47-492190050b0mr5817430b6e.11.1782481243648; Fri, 26 Jun 2026
 06:40:43 -0700 (PDT)
MIME-Version: 1.0
References: <20260622043934.179879-1-farid.m.zakaria@gmail.com>
 <sfv7zc6jboy2oxv7zuyofysas4ncbzenwsuzveiyduisfr6i7q@mx23er7uxdbg>
 <CACCo2jkDuwy5w_yhX8833m+s-rY736pk8xtKjxg3_y_7BCOHeg@mail.gmail.com>
 <24420045-a6eb-4999-ab19-1e344eaba8a4@app.fastmail.com> <20260625-atomkraftgegner-hunger-kursbuch-b452ff2becab@brauner>
 <CAG48ez2X1p5Nm2_sU=SK9wUusUO8c3_T-=FGrrOhkm7Kn9Y_7g@mail.gmail.com>
 <20260626142616.5232c61e@pumpkin> <CAG48ez3o1Mt59dWdyknh_SEaoi-cHv6pdmix+aOdBy3C0-LkYQ@mail.gmail.com>
In-Reply-To: <CAG48ez3o1Mt59dWdyknh_SEaoi-cHv6pdmix+aOdBy3C0-LkYQ@mail.gmail.com>
From: Farid Zakaria <farid.m.zakaria@gmail.com>
Date: Fri, 26 Jun 2026 07:40:34 -0600
X-Gm-Features: AVVi8CeZKEr6pYEvQiZLNZQm-8wjFrFVRAZtiYfPsykWMJrGX7gKBfmYSbb5urY
Message-ID: <CACCo2j=0oPQoJP7cxDNLLV_gVrWor5ituowNVYGk-Z0gXPdV=w@mail.gmail.com>
Subject: Re: [PATCH 0/2] fs: support $ORIGIN in ELF interpreter paths
To: Jann Horn <jannh@google.com>
Cc: David Laight <david.laight.linux@gmail.com>, Christian Brauner <brauner@kernel.org>, 
	John Ericson <mail@johnericson.me>, Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, shuah@kernel.org, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, 
	linux-kselftest <linux-kselftest@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/alternative; boundary="00000000000058b742065528412f"
X-Rspamd-Queue-Id: A291C140002
X-Stat-Signature: xzeiaui186hc5py6io7cnmqd87uyog6i
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782481244-783558
X-HE-Meta: U2FsdGVkX1+sre8s/eiZS4Ku6WCsr5rXHNHKEh47wIWlY9jlufy4SBc1ercxZumyeOqqZA4rcswkmDelo5MGBtiXtpc0Z9wb3Z/dvqAKwVVl1+kl4gdi+jrR3XldG7pcHs8BDSZvpjCoJ6IydYcBuG38bBg8mWEX/ArOnFTSlpSiYi0T1WarCFBOU/qOWtdDJ7oVa83HiiWnFw3yPm8x/sd2Te3Z79/zOHzrDbSj/MNH4Z/bojAWjymEw86Zri9fc6CxN92sS+3yhH3MUj5fNTyNPBvrI1WsNUfBmRtk+Z2rDogDp+BY55v+51fd3GECIaxVZ8jU703i4ygZtEnz05+KVRVMufuKQULf759ZS/Cz4kiIxvj+jdtVgMBu0j3w1sR1cxs2eQsNKnV8ooiLNhQ5qi8zXWMU/MjJOIdky9M2Tb+In3vwnVEvYNH6dpI5T7fY6rHUGpK4i5UxLn/EhneljIHvK2DRJN/+tbTMPxQbz5ByDFf953OVg2x6Z1Zx8wBMEOCDElE40GTnDIZb3nXsbGla8IrM6EbOhHiLb2Yhu8D0bDxIjl65D/FyL10aYM9dmKyW77dM7WWlwZm1u6jrtOYwl83J+GzkRB45SJEFXofN0atAndNQllBJ7Aj9O/N21tT+ZzHtHktvLS+UwAqfZ8bqXynivknPP7F1HxW3Ib5B2lDbKlKTrBf4FmN8ia9D33eFHpDqG/wjuokCOvnp6KgKEJAnJJaUQhnpQhAUgplDeqhx9yIXYoXZLcoM9DVxSuOaS1Rd0cF6m7gFLVvOgjyDj9xSJb5YmEiYhN36oSUo9GjE4+3DsPEahWOLbw3tFSYG7jK0Z0SP0vTR2FhNIiDE6TpVbUQa7nQyK+q15Sb0anqguS1B/ZXc5rsJgqiCdzyYRrsbfidOF+ZyVNLpCVqROZvFHuE5QcFq5ewgBw3ElZa8r/5hlTr/9QYHqDn6wqGaOoO8ksjOhBB
 mnRSfvyD
 8A0+AHllei/LHqdmSP5pHGxfr7V5/a1kss8tVVkBPLESxW8wFw67Q5JenUXJ6ZryjrduKq0Un5pOuzUZFA25BTyo6JGPU8cuPLeZxC1oYQ8AaNmgfN/pUciS+Zc6wv4IWdb8zwuXC0Qw4AeQSegAjGFVAhlV4x6hlxJ8Gq7lmRlsWRCrTXf2HxKVhZd7U2qC3NpG6yJJggWXP+FY02dQPMOgbiVBz1WOGy6q/l/iv4tI8+Flysc0fYlRQ6CD7aoF4D6S63shppM0BxieEVzZw0zpPG2Adh0Uyr10P6u+wje0OXsnkbwHYLRm2ouNA2V058bTvIbfCQiQUdB58I/Cc/rT8WjIjw6QtxjyKDWBCX0LpNYlzar6BcpS1yXzpjkGiLYpBeBp+6DvBRfrZQSdLuZPrHVTkg9QFASkZXbMZiYPQ2y4U6ORYG6gc7B0z0D9tVJLjAt0ClkmznqkS+NMGlY52grYP8SQukXtivdSj7BUrWQI8ZdgN5mtAEPXbhlGI3LzzWun4kVSAalbYlI2ND6oPuK4xDALOxe5YC6Ztj3r+mkZquQwikMAi8nyONPh0wDCFwNzA44Xmx3IIiGeQq8jE4H0ed1nuSTow28hMSJjtqHBZTtQV4173dxv4oj+ODl2G3k5hxmKOUww4BXxoCjqIgSiF8TrAP/k6Q0K8xM7TIBbAJofVGbd64Jq3XZwGadv1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--00000000000058b742065528412f
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

It's very tough not to get too idealogical but please forgive me a little
as a Nix user.

What you are describing is a feature and not a bug. In Nix and similar
store-based systems the goal is purity and reproduction. Security
vulnerabilities are solved by potentially rebuilding the world if they are
sufficiently deep in the dependency graph.

The flip side to this deployment strategy is that it's very easy to
understand and audit one's system. By not linking to global library
directories, you cut down on a complete vector of abuse or system wide
updates that maybe make one vulnerable.

Back to the discussion at hand :)
Glad to see some discussion. This is something I continue to think fits
well in the kernel and this strategy of deployment is becoming increasingly
popular with tools like Bazel and Buck as well.

I continue to wait and am ready to make any necessary changes.


On Fri, Jun 26, 2026, 7:34=E2=80=AFAM Jann Horn <jannh@google.com> wrote:

> On Fri, Jun 26, 2026 at 3:26=E2=80=AFPM David Laight
> <david.laight.linux@gmail.com> wrote:
> > On Fri, 26 Jun 2026 14:39:22 +0200
> > Jann Horn <jannh@google.com> wrote:
> >
> > > On Thu, Jun 25, 2026 at 10:50=E2=80=AFAM Christian Brauner <brauner@k=
ernel.org>
> wrote:
> > > > The arguments I have heard from various people so far are:
> > > >
> > > > (1) Userspace would be able to clone a random chroot to /woot and
> run a
> > > >     binary from it without having to set up a complicated sandbox
> > > >     effectively making dynamically linked binaries more like static
> > > >     binaries in a sense.
> > > >
> > > > (2) Quote:
> > > >     "If you debootstrap/dnf a chroot to some location in your
> > > >     home dir and try to run a binary from it, that it tries to load
> the
> > > >     libraries from your /usr is a pretty unintuitive and not at all
> > > >     useful behavior."
> > > >
> > > > (3) Quote:
> > > >     "[Various remote execution things run in locked down containers
> that
> > > >     disable userns, which makes the sandbox impossible and hence ou=
r
> > > >     builds wouldn't work there."
> > >
> > > FWIW I think someone also mentioned to me that it would make things
> > > easier for them if they could build a piece of software in one
> > > environment and then bundle it up with all required libraries and suc=
h
> > > and run it in a very different environment, without
> > > container/sandboxing stuff and without static linking. But I guess
> > > that's kinda niche.
> >
> > The problem with 'ship the shared libraries with the application' is
> > that you get all the problems of static linking.
> > If there is a bug in the library code you can't fix it without getting
> the
> > 3rd party to rebuild their application package.
>
> Yes, it's appropriate for weird use cases like "I want to run this
> historical version of the software and its dependencies", it's not
> necessarily a good idea for normal application use.
>

--00000000000058b742065528412f
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto"><div>It&#39;s very tough not to get too idealogical but p=
lease forgive me a little as a Nix user.=C2=A0</div><div dir=3D"auto"><br><=
/div><div dir=3D"auto">What you are describing is a feature and not a bug. =
In Nix and similar store-based systems the goal is purity and reproduction.=
 Security vulnerabilities are solved by potentially rebuilding the world if=
 they are sufficiently deep in the dependency graph.</div><div dir=3D"auto"=
><br></div><div dir=3D"auto">The flip side to this deployment strategy is t=
hat it&#39;s very easy to understand and audit one&#39;s system. By not lin=
king to global library directories, you cut down on a complete vector of ab=
use or system wide updates that maybe make one vulnerable.</div><div dir=3D=
"auto"><br></div><div dir=3D"auto">Back to the discussion at hand :)</div><=
div dir=3D"auto">Glad to see some discussion. This is something I continue =
to think fits well in the kernel and this strategy of deployment is becomin=
g increasingly popular with tools like Bazel and Buck as well.</div><div di=
r=3D"auto"><br></div><div dir=3D"auto">I continue to wait and am ready to m=
ake any necessary changes.</div><div data-smartmail=3D"gmail_signature"><di=
v><br></div></div></div><br><div class=3D"gmail_quote gmail_quote_container=
"><div dir=3D"ltr" class=3D"gmail_attr">On Fri, Jun 26, 2026, 7:34=E2=80=AF=
AM Jann Horn &lt;<a href=3D"mailto:jannh@google.com">jannh@google.com</a>&g=
t; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 =
.8ex;border-left:1px #ccc solid;padding-left:1ex">On Fri, Jun 26, 2026 at 3=
:26=E2=80=AFPM David Laight<br>
&lt;<a href=3D"mailto:david.laight.linux@gmail.com" target=3D"_blank" rel=
=3D"noreferrer">david.laight.linux@gmail.com</a>&gt; wrote:<br>
&gt; On Fri, 26 Jun 2026 14:39:22 +0200<br>
&gt; Jann Horn &lt;<a href=3D"mailto:jannh@google.com" target=3D"_blank" re=
l=3D"noreferrer">jannh@google.com</a>&gt; wrote:<br>
&gt;<br>
&gt; &gt; On Thu, Jun 25, 2026 at 10:50=E2=80=AFAM Christian Brauner &lt;<a=
 href=3D"mailto:brauner@kernel.org" target=3D"_blank" rel=3D"noreferrer">br=
auner@kernel.org</a>&gt; wrote:<br>
&gt; &gt; &gt; The arguments I have heard from various people so far are:<b=
r>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; (1) Userspace would be able to clone a random chroot to /woo=
t and run a<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0binary from it without having to set up a=
 complicated sandbox<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0effectively making dynamically linked bin=
aries more like static<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0binaries in a sense.<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; (2) Quote:<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0&quot;If you debootstrap/dnf a chroot to =
some location in your<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0home dir and try to run a binary from it,=
 that it tries to load the<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0libraries from your /usr is a pretty unin=
tuitive and not at all<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0useful behavior.&quot;<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; (3) Quote:<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0&quot;[Various remote execution things ru=
n in locked down containers that<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0disable userns, which makes the sandbox i=
mpossible and hence our<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0builds wouldn&#39;t work there.&quot;<br>
&gt; &gt;<br>
&gt; &gt; FWIW I think someone also mentioned to me that it would make thin=
gs<br>
&gt; &gt; easier for them if they could build a piece of software in one<br=
>
&gt; &gt; environment and then bundle it up with all required libraries and=
 such<br>
&gt; &gt; and run it in a very different environment, without<br>
&gt; &gt; container/sandboxing stuff and without static linking. But I gues=
s<br>
&gt; &gt; that&#39;s kinda niche.<br>
&gt;<br>
&gt; The problem with &#39;ship the shared libraries with the application&#=
39; is<br>
&gt; that you get all the problems of static linking.<br>
&gt; If there is a bug in the library code you can&#39;t fix it without get=
ting the<br>
&gt; 3rd party to rebuild their application package.<br>
<br>
Yes, it&#39;s appropriate for weird use cases like &quot;I want to run this=
<br>
historical version of the software and its dependencies&quot;, it&#39;s not=
<br>
necessarily a good idea for normal application use.<br>
</blockquote></div>

--00000000000058b742065528412f--

