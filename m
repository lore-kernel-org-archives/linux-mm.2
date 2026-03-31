Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1708B10F92F2
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 19:40:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FE436B0092; Tue, 31 Mar 2026 15:40:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AEF06B0095; Tue, 31 Mar 2026 15:40:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C5586B0096; Tue, 31 Mar 2026 15:40:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5A1AB6B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:40:21 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EBEF613A96D
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 19:40:20 +0000 (UTC)
X-FDA: 84607374600.21.9151D2A
Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	by imf18.hostedemail.com (Postfix) with ESMTP id 22E2C1C0006
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 19:40:18 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fso3bxds;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf18.hostedemail.com: domain of luca.boccassi@gmail.com designates 74.125.224.49 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774986019; a=rsa-sha256;
	cv=pass;
	b=az+VnkuBmmbv03eXRToEaybjZUpp5rdXgs/6thVm58SjN0sXW3j+dSZszEA5AhQn80kQQy
	QY3jJVJ0rGfq5cOSOr6ypsShMYnVZ9RZZcug3Sbo1nHY5gXW16BS4yH8/gyfdayvmjpWIb
	g5qc1FXC674jVHU0wHDb/Rq26t3Y6c0=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774986019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NrBqUb822UIvex6OIe+3K5fMDptrtW6BzFohhlrirV4=;
	b=vMGLNgdOSwDERjoA/7O93ikW1d+STNk+ZOvp0+IX43X6AyI3b7TdKgIrTBx3uXiMCKu2CA
	O8IoRy4HCEo6ydmqLMqtM0Fex33f/H4RLxZvrhklb8kHR+8r8ucwtsZLZH9tVdG0dQ61fA
	gjckk864uaEsBskKwiZGjr3G3lK3sf8=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fso3bxds;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf18.hostedemail.com: domain of luca.boccassi@gmail.com designates 74.125.224.49 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-650182d19e0so5004800d50.1
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 12:40:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774986018; cv=none;
        d=google.com; s=arc-20240605;
        b=J7Anv++CwA1LkS6SToI2obDJkRDN7iTMtVf8L9PT3oB6Y4hu+1gPJ/wQlUS9yYR3TT
         6wR7MR3Y/FdrMATMnDnoRP9mbKjwYJkoJflRgru66N3oJN21fyc2uExplwez+ozQV7x7
         IUmvZe5kVxLW3fixwXrVaVgdlaz0PZEJJxA98x9p/Y+twVUGVoIZVBgORr1ECVMP5Fi/
         6h2X8RZ3qsVcOIYbEdD66DGOHi5vCGTHObIWNpiMo/p1Yur78CrxfFNoy0tPKgKvjsNO
         WL3Pc9/b947g9xOwW0vfHRKXzOdKLkk591xWW73dsfwqcYIJnWRpRoRgkA7tZqB4NXQo
         TMgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NrBqUb822UIvex6OIe+3K5fMDptrtW6BzFohhlrirV4=;
        fh=maHgZh05xg5THzD+5Lfsv7xuS5hTn3Ub+9m6GFFeifA=;
        b=GOtShza0h7CwQREPBVkGoeNsmTAe3C3880FyNTilB7aClvLVa+v3m1hDRYkZN/SYF2
         UvY++1Zj/uA+5xY16aqjagzSfsRxyjJ2Ava9pQZROjGq9oOaN866NYenudehezw9BBXq
         a4NNEWnLnHzVs/tj+Rm6LEVvY9QB4is6A3RFtXEDux0nOUWw6IYl7rYyL3n004EptNfP
         7bJNNc81OUf7OeSTVVoL7H+54LrRPUVci7stOMMc0Z7jumkJKbyBBA2yVFGK/5krchPR
         PJwmOOEoTVYMIzojS+5nGV67aXjuflZCbqwfNSdUw0dIqx8kJBYN2Be6kGj+76LnZMYK
         aRAA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774986018; x=1775590818; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NrBqUb822UIvex6OIe+3K5fMDptrtW6BzFohhlrirV4=;
        b=fso3bxdsJer095pFLlt3btDKVOv1Csga0mzMevFfgzl5CGjYix5H5MtbH3T3ewTlIm
         Tc/tiseovp/nBEZ+87IIUvwry4nKaAKYj2m4UDEAYkKDDc9af02W2/QPyGBHDQhpbbU0
         K/TAJQdgkZ9XprZhemSdQAg7ykBuLoVSFCTE6ANiTZzQXzz/gKDeJIZi1Hidjg+gm7OU
         8Dckfl4YD0Ld2T36v/gLYEmtC+wrGVeqHb4vNmM4RlWue/iG7HKokTUet69yC30eWNgl
         rmN3db1BccpIY3vTfsAJJ252VUXxKkVRJsihR8BsiM1SqBzHwdwGtmg4/ddiCRoueT5B
         rT1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774986018; x=1775590818;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NrBqUb822UIvex6OIe+3K5fMDptrtW6BzFohhlrirV4=;
        b=me6TcGm+MUaXb1HApA4ApeWssN7TPNB4Kk+PAx/YUBPTlWaGXBHHqfN/gS31xyxiDd
         uNWmeE/zeqKN+MMQzPhgLg2eabeRe1CWlnrUyJra0cA7YRUm4ZNfKViARbc/JIvneNQE
         t2VfphxLHkYdYEkQ9NmVXOgx2iNczm9JbYjx9fpaS6sS8NIQact+mne/YA6AeG2N/cnM
         vsoG8XwO7nso1QwW9Eeiox2rdW2OZRfGpYhb3HoCaYMERvL/yV4K+GyNjnJV2a91Kl6x
         BX9MHfYIBPH9PHSUhanuGnMAFIMwB9ubqafAg9F5OFHn4g5ppfwluT0KrrviyyGjCvh1
         ASiA==
X-Forwarded-Encrypted: i=1; AJvYcCV01sdOQlQ7e5KXFZsDIFTnQhF70TAW+OEJCeNxOGlsL6SAPVhOFRR2VRGtLvMBypl6vGvJfH6ngA==@kvack.org
X-Gm-Message-State: AOJu0YxCBM/NDlu0RO2FLFFJo8ufislR/xUydFTeV5KXbB1C3TbvoZNB
	eH+3vEjIMaUWv/vKhJ5g8tVzvkohxoZtlD5ZGxcQt8gREounjqAu3G9wYuYbmAO3P7TNiIZH3ZX
	lSo5gFBaYC81iU2v/rl4aIugi5DM1nWo=
X-Gm-Gg: ATEYQzyJolk4Y92/onWdbyFkg36/9On0oVA532D7FPSeisnVnaWMDbU2QNDIYYF1FiS
	XI/+PqYsB+0kP2V/aSAPYESDwG4hounOyeA/5QvSzgQd7iCOr+q5PWaxBiwKOktqtOp22ZVnsBa
	YFnfIYW5Ju3+9x7qgbqChiZtMEZy63IpyR4U9NKRLJQSCnu2QdfmORI5cFvC8ubNyZ7y7PvV1Uc
	v4bSI3ml6Fx9K0pZNPxRi3sd6iZK5CKE+hvk3xM3IpRE6RiFhbKER2E03vJiA2FBAcsF2WhbDYd
	IhJ1z6mXaTOl84/+YJqdy76MWvCuj4/P96OKlO9TvA==
X-Received: by 2002:a53:be51:0:b0:650:19b1:751c with SMTP id
 956f58d0204a3-6502fe65217mr459746d50.53.1774986017941; Tue, 31 Mar 2026
 12:40:17 -0700 (PDT)
MIME-Version: 1.0
References: <20260331175456.4065874-1-luca.boccassi@gmail.com>
 <CA+CK2bB0bMxW721Q+SzFJENe4X0_GwcOh83R-mm1V5dig3oP3A@mail.gmail.com>
 <CAMw=ZnQZm_k_mMQPmKwuBtkFyXXgAn9MK1NzmVbZst4nGu6xhw@mail.gmail.com> <CA+CK2bDL9=uNmy9hq=3D-w=MHYsY82FNCkqvNeNpnTnX6meYRA@mail.gmail.com>
In-Reply-To: <CA+CK2bDL9=uNmy9hq=3D-w=MHYsY82FNCkqvNeNpnTnX6meYRA@mail.gmail.com>
From: Luca Boccassi <luca.boccassi@gmail.com>
Date: Tue, 31 Mar 2026 20:40:07 +0100
X-Gm-Features: AQROBzA80Z5vv8p1B8O-wR4-lNM3XMfZwPtBcQ1uf2wGh6dYtIhVFfM-a8O-V2Q
Message-ID: <CAMw=ZnRKEaWC0GiXWHpbiAchpZeBawOCoDgtq18B1UJsZpNN-w@mail.gmail.com>
Subject: Re: [PATCH] liveupdate: truncate getfile name to NAME_MAX
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, 
	Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, pratyush@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 22E2C1C0006
X-Stat-Signature: 7qbgdrzreyh4g8bc7iruqk6e7hpuo5zx
X-HE-Tag: 1774986018-973460
X-HE-Meta: U2FsdGVkX19owRaTa63RdYY6JEL7cGxr+DVfnlBzQWCt1C5+rYslV0cHKvSyi83N4IkVEn07Mte+bEPtB5GxcuV6IUAIyXh7FwY0op/Cu1ud562PCiQ6Ua/bAxebaDIiNwVap07MmNhB0qQBUe5sciGTuUe/5aw0e8gAbaIyNyKXCcJ6aekNtahIyXXRlY9nnNj6YnwDUgUSU9k4ZP3gSyhJsw4h/5m+wIn2J56Cu6bhmSR5r6B0niOBdDJtJUaUDDb1wKeyAlLOV6EVBVCEsfMPsyXgBnzhKUTO0OMKQgjqxsMzFT4P6Wc5kwXebCj/Fzi2DApeHrwabdjGFCzSV7KsjobDoZg6/Xce1uy91QbwOm2dryaBE8+I5MovzEtb30RMoOAig+IdMQ8e3X4I4CqKDHwO0kajtzVerJy7RU4TBiaY+R/NBPmUVC6wUzA3hJUdWuvMDR2Q7KYOx5GHchS9ua9zlJ6gUZEhhsreo9X1HM2yC58QD3j+oVKFD6lhosvh7JE70TpGdbSwKTQeFOI03hD4uxIBNsVAsrVg/wisU7GtDrdQw1OEuC9wybS9qUS9aQF7ryo8uSY4GLruAk4UyviJlMO9UwD3aRljsVKsOaUEQtgf7VhGDmwYWVK+Ld9p/SDlzsWKbuxmnOyUOmF6R4Lr2mHiaDEbu5aSopAVrmAeXUGudMRgR0FTBe7vC4OOW7JPvvjZzXerVaKfjd/i+BGC8FKjWrseI/si/1WPSJxTnTrClS9vk2lxnDcT9uTrn+7m5jPUURHEHnaM6uqhWD35k5bSuonWlI8H1v1XjzoKrBJuoJscupTkf8CJAjG0yJtyR/BtiKx89IMcv+Vy8JneEvttbKOJv90y7BmCssgol3Bge+jge9/5PylW6Ge9ei+uGYD3klgi3vkpyAic+N5HY33Lb2A+wS0xy6Q+5ZSyn+meephepdI6xHkm48gPeHXHslogQDXNNm5
 E79x5TcH
 GWP6yLn3WUL+zwyumd0BywEM9LT37EgOX7hx8FqSigA6f6Ow432TN/YRFf+OEGhmXhr/63e4WPy4dvuB2NOUy8b6vAkXCcvuG+Gs1GGh82FlmqgN0YKDkJ3ybLR/hWYB0QQSi6zgezRF4TYuRK7DZBBUjPIQmeap2gCZSrDEJSnoGT+3Emu7ns9/av7tEswPGNbuHYXq8IfLgzbHGLXBxJk2OFyUn/Q60zcLC1aKgu+vZTzlm5luzu1pVeKNeK4kUTBPk7UbkIxqDwIbds0pBth4xZZLSdB85vaqc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 31 Mar 2026 at 20:14, Pasha Tatashin <pasha.tatashin@soleen.com> wr=
ote:
>
> On Tue, Mar 31, 2026 at 2:30=E2=80=AFPM Luca Boccassi <luca.boccassi@gmai=
l.com> wrote:
> >
> > On Tue, 31 Mar 2026, 19:21 Pasha Tatashin, <pasha.tatashin@soleen.com> =
wrote:
> >>
> >> On Tue, Mar 31, 2026 at 1:55=E2=80=AFPM <luca.boccassi@gmail.com> wrot=
e:
> >> >
> >> > From: Luca Boccassi <luca.boccassi@gmail.com>
> >> >
> >> > dynamic_dname() harcodes its limit to NAME_MAX bytes, which includes=
 a
> >> > NUL terminator and a 'anon_inode:' prefix. If the name passed on goe=
s
> >> > above the limit it results in userspace getting a ENAMETOOLONG error=
.
> >> >
> >> > Truncate the name to NAME_MAX - 12 - 1 characters to ensure this nev=
er
> >> > fails (accounting for prefix and NUL).
> >> >
> >> > Fixes: 0153094d03df ("liveupdate: luo_session: add sessions support"=
)
>
> Let's remove this, this patch is not fixing an existing issue, but a
> preparation for future uapi changes?

The linked patch that increases the buffer to 255 is tagged with
'fixes' so I don't mind, as that's enough to fix the -ENAMETOOLONG
error in currently released kernels. The original version of this set
the truncation to the current max buffer size, hence why I had the
fixes line.

> >> >
> >> > Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>
> >> > ---
> >> > Builds on top of this just sent by Aleksa:
> >> >
> >> > https://lore.kernel.org/linux-fsdevel/20260401-dynamic-dname-name_ma=
x-v1-1-8ca20ab2642e@amutable.com/
> >> >
> >> >  kernel/liveupdate/luo_session.c | 7 +++++--
> >> >  1 file changed, 5 insertions(+), 2 deletions(-)
> >> >
> >> > diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo=
_session.c
> >> > index 7836772956406..4a40c7fdfb44f 100644
> >> > --- a/kernel/liveupdate/luo_session.c
> >> > +++ b/kernel/liveupdate/luo_session.c
> >> > @@ -366,11 +366,14 @@ static const struct file_operations luo_sessio=
n_fops =3D {
> >> >  /* Create a "struct file" for session */
> >> >  static int luo_session_getfile(struct luo_session *session, struct =
file **filep)
> >> >  {
> >> > -       char name_buf[128];
> >> > +       char name_buf[NAME_MAX];
> >> >         struct file *file;
> >> >
> >> >         lockdep_assert_held(&session->mutex);
> >> > -       snprintf(name_buf, sizeof(name_buf), "[luo_session] %s", ses=
sion->name);
> >> > +       /* dynamic_dname() rejects names above NAME_MAX bytes, inclu=
ding NUL terminator
> >> > +        * and a 'anon_inode:' prefix. Truncate to NAME_MAX - 12 - 1=
 to avoid
> >> > +        * ENAMETOOLONG. */
> >> > +       snprintf(name_buf, NAME_MAX - 12 - 1, "[luo_session] %s", se=
ssion->name);
> >>
> >> I am confused by this change, the maximum session name length is: 64,
> >> as defined in:
> >> include/uapi/linux/liveupdate.h
> >> /* The maximum length of session name including null termination */
> >> #define LIVEUPDATE_SESSION_NAME_LENGTH 64
> >>
> >> So, 128 should be enough to include:
> >> "[luo_session] %s", session->name
> >>
> >> Or am I missing something?
> >>
> >> Pasha
> >
> >
> > Yeah we need to to bump that size, it's too small - see the shared doc.=
 This is anyway needed for safety, as the user space call falls apart compl=
etely if it goes over the hard coded limit,
>
> If there is a safety issue, it should be fixed (even without a limit
> bump), could you please explain it.

Nothing specific, more from the abstract point of view - given that
this will fail with a hard error if it goes above the hardcoded limit,
it seems better to me to check it, rather than assuming it's going to
match, as that's error prone.

> I looked at the shared doc [https://tinyurl.com/luoddesign under limits t=
ab]:
>
> I see:
> TODO: this needs to be bumped, as for the varlink API we will impose a
> cgroup path prefix, which means PATH_MAX + "/" + client-supplied
> string.
>
> Why would we do that? Why can't we use a 63-byte unique identifier for
> sessions and an in-memory database that maps the cgroup path prefix to
> session_ids, where the database also gets passed from one kernel to
> the other?

Because that requires tracking state across all runtime, and that's a
no-go. The session itself needs to be identifiable by cgroup, so that
its owner is uniquely identified in all cases, in all situations,
regardless of any state or lack thereof.
The structs have a size as input, so it should be doable to follow the
usual process and keep it backward compatible.

