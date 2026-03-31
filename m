Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7129810F92F1
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 19:14:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B59B06B0092; Tue, 31 Mar 2026 15:14:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE3806B0095; Tue, 31 Mar 2026 15:14:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D1EF6B0096; Tue, 31 Mar 2026 15:14:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 883FB6B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:14:22 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 242A0140368
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 19:14:22 +0000 (UTC)
X-FDA: 84607309164.04.A647C3C
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf21.hostedemail.com (Postfix) with ESMTP id DDD741C0004
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 19:14:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=QOQxu0Lb;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774984460; a=rsa-sha256;
	cv=pass;
	b=SSVgoTgcioPdlHNuWfZL5W2pKhJl7zvO6H0+bUqHABvZeqfJ2kHCACDyWK8i6mgybMN2sX
	ftGcqcm4ttDdnU1uSiZBHozPYl4mxlrp/H7M6t8i/q0TOpz+E8rPXu2N6aH1/Asj65RV+C
	SowI+T3u96ANJ0by3Sf6ZaeD81aPvxo=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774984460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bmHyVXpnDYQ20Y8tpOog8F563dlY7wEta5zrK8UkI6g=;
	b=lqf/+m0Ez4Lt6Bw4TRdzgMNX8aWQIy5rO26cC8rCiLowyzdJsB3goWR4TAzSU5ejU0eKJ3
	CiX3luVR8U2RgfK5KB5SC+a88ZcAvuy2gsQXzuPJIsPEReUMrMB1GuXCf7LDG0ubnbBx+s
	6oSOd1FABGljsdU43CAADzwVVKVk/fY=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=QOQxu0Lb;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-661b16ac011so11447898a12.2
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 12:14:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774984458; cv=none;
        d=google.com; s=arc-20240605;
        b=EAc6OLqecoHwmT8S1z7WXECJiZKkRq0m+BMuLQM9tTiM/nhqJUgACqsUDBmSB3HHdi
         lMtVyFygIXQHSEr8prpMeryUnR7puf/Hq1SEAlAwUPsmkAohDWiT3gxKPkz/Qxayal3S
         9S4+73aeLAkKyKrwhvzITDKKf87QWDFlkgVg2vj+WAHoSQtO3J+yRYF3osDLm/ZhscOY
         1GY4Xa7rHbSbVDhpTqSezhqgTFAxseK9rc1WVgl2P/nlLWOkA0Rk+fmwDmmlFBK8zy80
         fNatI36mRtHCNZMVpvquJA39gYZW/8KUqk5+uGApZl35p1itlfpvCXQTmcRwjCtu3/c0
         966g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bmHyVXpnDYQ20Y8tpOog8F563dlY7wEta5zrK8UkI6g=;
        fh=U8XvdNpgkMMEoGh4cM+fv33In7/Y4uc9/4mC7OQNClI=;
        b=DwKhUniKtqHh8AhLM/Xiuj58Y7fgEgVjLdXQVAVbm7j7IMfPgxJqxSGfM/no9w8v5+
         eDQm4jLeuRBUO284G6lOy1eZhQNZ4SsFdB7hkGCkeqP9b27/kgP6tUGIWVDsj1sptTnc
         GACAsCYmFj53Mdw/NoueESr6xQPmf6Y6Ug+J8bHwKkww1PwOhG1hsUqjAKm3Vp1WbXMy
         U32S8HcI+5+Iag2zsNe6pRXrFDrEmAseZ0FB1YLOqL3ppVyKNssvkLW0tewFbCxm6tFD
         Xq0LSbvIlXB69tnOHQOWaRcsVEXKGeqzsAPPK+4NJ5CbkFyCpSoFflRuaVxOOjJg0OW+
         MG2A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774984458; x=1775589258; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bmHyVXpnDYQ20Y8tpOog8F563dlY7wEta5zrK8UkI6g=;
        b=QOQxu0LbOVwIMH2vkcvrgWjTDMEBq8iwGaeaooxE+pdPafu6pVlGK3HTPsd0o695ML
         wnOzOUAcdImeN+Zux+gTGFhkBZGEbABcpN6q5R3SXFA5MFD6Nqi1TiaiVUt/zbNFq/Hv
         Do6L4cEXqXHGuXDlcGtk+k7eT3sY/jZd1UnLcNY3anpMsr/QqSA29f8Tpni+x2Vsz1WU
         pcPo64SaaNoLBiCkd+9w1EsNIFyKyvfOdc/XMCuaSrukBOhnk2cIsvYjIXt1OZ3bYX7D
         ABIkN/APSrfbTkuymnZ1cAdr3wnYp3FJmjmtIgNOOxRHc7fAp3yuzIbtDw3DY1Ko6gPr
         QZpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774984458; x=1775589258;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bmHyVXpnDYQ20Y8tpOog8F563dlY7wEta5zrK8UkI6g=;
        b=r52fIqY4JE3FwLcUA9+NxpeY2b1zWTe9Z5I0MC9XmAKokQRntzRUZmCZk5ztENdNn+
         vaTkzcTCR2IWybxhm/fU3HRq/F8RUalroxvgYaE3LWgOPYVkJwbm/qHSpoD0hqPTO9v7
         a8LexFAYghurs6Z1tglirI2Oa+WafynYYxAbA8dHJaohmmIuOgZu6T18fP4QJ9TQeZzI
         xCZtCXhWJNDEmU5hZxASxhNnmNHlEXCcn4HDc9ga4tKt4X0UBsPsqMNFz7Gu4bN7tCWI
         LCmTMTvxH8u9Wc0MCtDdYWeAWzWx1KX0p0Z3MYhGlSoG67sDv0KAjPOMoppbEUiLkj+/
         w6Fg==
X-Forwarded-Encrypted: i=1; AJvYcCWB0GRDttE1w0iKsOlJPpEZMY0Nsq+W1QXp937uVKXoQqumoDKmtiWsq353LFjwNt7L5MnRsQCaGg==@kvack.org
X-Gm-Message-State: AOJu0Yx1e8RkSJeReNtPg4NhJuYuv2gbMYOZyvE5Md0x5oh3tcJTVs8D
	CJ8BLwZxC6PJrGPClWsVVTeoaqLJ7DVeOJIu7uKlMJQo5OzPFrVdDUaMwHoKyuJlqXI2Z/Q8djz
	50iBhDiwZgKXfVWmkUDRM2684aTHA12sS/qPR6hA6Aw==
X-Gm-Gg: ATEYQzxZ7dJ1lQ6qjSO/Qgy30oW2NU6k+xtNo9gkveKXFu5QoGiGugGhWwyaVlNIxsE
	QEkjPrQ25oYs/mjCptREuWIPxnrUZI+HTsa1jUudPAfM2tQ4jGtb2HLKpfSAQDHoUtZfweiCIeS
	ME4VWCNMwRXoZV68+AzbgkrrYpMLjQHFi5A7LJKTBGA/Emb7LqgfuaPEBgtECbXI1dpXKvxxIqU
	0ZKBy/+bqnGBc5einoiYIxZIoHCCJu/PxNMrgtlm5s62gsF4iq1TVkO0N+SMSWo5n5XmfKVAcUT
	8dwd1GMbM9IHIisTJzwpn5pm3BQXzFytgkZDqg==
X-Received: by 2002:a05:6402:4308:b0:66c:4d3c:fe2f with SMTP id
 4fb4d7f45d1cf-66db02aae4dmr430347a12.7.1774984457471; Tue, 31 Mar 2026
 12:14:17 -0700 (PDT)
MIME-Version: 1.0
References: <20260331175456.4065874-1-luca.boccassi@gmail.com>
 <CA+CK2bB0bMxW721Q+SzFJENe4X0_GwcOh83R-mm1V5dig3oP3A@mail.gmail.com> <CAMw=ZnQZm_k_mMQPmKwuBtkFyXXgAn9MK1NzmVbZst4nGu6xhw@mail.gmail.com>
In-Reply-To: <CAMw=ZnQZm_k_mMQPmKwuBtkFyXXgAn9MK1NzmVbZst4nGu6xhw@mail.gmail.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 31 Mar 2026 15:13:40 -0400
X-Gm-Features: AQROBzDlFd9ZpXe2hTLzsg799tWUQs2xMihrXKRkRQAFEGJt31hcnoPOvpe85WA
Message-ID: <CA+CK2bDL9=uNmy9hq=3D-w=MHYsY82FNCkqvNeNpnTnX6meYRA@mail.gmail.com>
Subject: Re: [PATCH] liveupdate: truncate getfile name to NAME_MAX
To: Luca Boccassi <luca.boccassi@gmail.com>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, 
	Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, pratyush@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DDD741C0004
X-Stat-Signature: 3qxzt4bb1bhkz1j5ntpqm7q3ywn7ns35
X-HE-Tag: 1774984459-71946
X-HE-Meta: U2FsdGVkX19AIeK2fddnCxJ3z9XqURczI2X5opkJO3TzCa3XfX1RabUwtufAyexGzhnOLFcCYT2isnvmKblqd8p8gUT6bkeClzp3FA9OzycTH5xsQ4kQCYU/n6ePeww48uJaozkjQT7qt4Wkb+gG9OzASgCNprxvT0lYPNaJzrmrlm4g0Fur8FDlB7+OeXD1Mo8DKUT+mvf92otEdNlAE+LWfFY/aTTR0f3cu6zUHML7n1wP2360qLxDxBYAqzLb9ZSqqg2xk8DE4mOexm44OhHeEj5aFemSUWqExGkrO3RaKGRBYRVXsEwS3pi/UNt1trUXEbg7FNsBqxQE26xeCYax53MKzD/WbzcILDWM1rCUC2jwDGaRKq82Vk+7SvJFEGGy/7/v4GtQzTerGnwUJPtemI3HJpXoblU1iVvYRS6T+rHWANsoJ45b6nVx67I49+L/02ZZC5BcsIcZrneqKe4zBZGgMda093cJ0bvBOY78rbIneBcjteKrBLClYEr3LzleBgpwle/GhWaG1aj2ErDZapY15WMWGhN2tOHuvuxo6pG4BMVUIk1DhOVex1C5L/V0oU0T29wUdRsPhPh915rQqWabtwLZUybdY4Vwip7c5VTlP/4NANpkv7kr52zn9v7FFd8QWJXbElxVj/ug6u4AxGzQB56hLdingcxcR76kC0NdDPs5ND6+rYtvI+eipB3nWRRaD1MvJQrDCRs90zu6J2JgQ2RvU9Dl9fhREIZhtBJQWbeC/Lhe5jHJs6H62aPl77/g/wPPnfxgoKJjI9MSUgN1290uw1AcLnSTSmkNCg8S9CiIboM9F6R2H2LbkjxmkB7tjjpH9auVev8SxziNp55Au2to92dMrgFrcFcmY/JxehiZDCjRGuuUp1EvdRF0a8MGk6GMCGNlzM2S040p1uKQaLSB5msEByQLNsIoc7UVfnJgCWQ7D0KsRmyYc+skE5GEgowaRR7YYfA
 AEqFfZZd
 OmIhG+pdvYAERI446rmPfZalTotV6mKPKpEu0JlyZARbQYddbLxDvo9j0GHqed5VWe99juUdI1I2LVVoPf1Nn0sUu+S1gF6k7gnWJgX0pqBhE46+alQd9MLzf2YkyW/OPdTriDbGaL1GjX2LApIb+iNav1co6DYScjGcnVpLJPwGSylFiUtjqTk0K7i4SpZ5hoodE9ozvoE+lsreVG5P0dZsJ3lsuynQ/nMVSLORTSHi0AFXCxl1+gYoNQ6qdrapql+B93dWZZmOHd1aftu0gNvte7Mx4USwwv9Hz+vVnjwNVBspa6cDhqXRbIpF16NA/SdASra/QdabauesFYoEmDbX8UCyA/qOfg3dTng9kwBbx1lP2hNVPKbFNVHwvKCVoI51e9p7y8zztGD66mj77H5xNyX09dqwzBeZHWyn9tv8TIyTENh8Oc1Qa16jgSjME2gjrij7IBhImKf77Tz1Rl9fiQxbaBzZhSD2Ws82wHEh/BVDYSuZ3zGTJLBiyblmkp9wemJ3kKnG0x/CE1sF++kwFNkfQQYnbRIqqbPrE2NRyFEHpwDOKbjkrCFf96Fiv0BL/StVUQKYWURHdTQ4eDnhO8eaqx3mDLG1rlBwib9aslDjgxTIroOkIIJF7rw4O0dQ5aL00mVVSzzwOzVbUBKBZX0Y5Vs1kT/w8DPZftGfMNKabAGbgO9slBfcoNDtvDpLYoVelDnRFXsN5VC/PScVQTD1Lt5i3l0Y3Pg/LK5kTcDzlGszwjkOojw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 2:30=E2=80=AFPM Luca Boccassi <luca.boccassi@gmail.=
com> wrote:
>
> On Tue, 31 Mar 2026, 19:21 Pasha Tatashin, <pasha.tatashin@soleen.com> wr=
ote:
>>
>> On Tue, Mar 31, 2026 at 1:55=E2=80=AFPM <luca.boccassi@gmail.com> wrote:
>> >
>> > From: Luca Boccassi <luca.boccassi@gmail.com>
>> >
>> > dynamic_dname() harcodes its limit to NAME_MAX bytes, which includes a
>> > NUL terminator and a 'anon_inode:' prefix. If the name passed on goes
>> > above the limit it results in userspace getting a ENAMETOOLONG error.
>> >
>> > Truncate the name to NAME_MAX - 12 - 1 characters to ensure this never
>> > fails (accounting for prefix and NUL).
>> >
>> > Fixes: 0153094d03df ("liveupdate: luo_session: add sessions support")

Let's remove this, this patch is not fixing an existing issue, but a
preparation for future uapi changes?

>> >
>> > Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>
>> > ---
>> > Builds on top of this just sent by Aleksa:
>> >
>> > https://lore.kernel.org/linux-fsdevel/20260401-dynamic-dname-name_max-=
v1-1-8ca20ab2642e@amutable.com/
>> >
>> >  kernel/liveupdate/luo_session.c | 7 +++++--
>> >  1 file changed, 5 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_s=
ession.c
>> > index 7836772956406..4a40c7fdfb44f 100644
>> > --- a/kernel/liveupdate/luo_session.c
>> > +++ b/kernel/liveupdate/luo_session.c
>> > @@ -366,11 +366,14 @@ static const struct file_operations luo_session_=
fops =3D {
>> >  /* Create a "struct file" for session */
>> >  static int luo_session_getfile(struct luo_session *session, struct fi=
le **filep)
>> >  {
>> > -       char name_buf[128];
>> > +       char name_buf[NAME_MAX];
>> >         struct file *file;
>> >
>> >         lockdep_assert_held(&session->mutex);
>> > -       snprintf(name_buf, sizeof(name_buf), "[luo_session] %s", sessi=
on->name);
>> > +       /* dynamic_dname() rejects names above NAME_MAX bytes, includi=
ng NUL terminator
>> > +        * and a 'anon_inode:' prefix. Truncate to NAME_MAX - 12 - 1 t=
o avoid
>> > +        * ENAMETOOLONG. */
>> > +       snprintf(name_buf, NAME_MAX - 12 - 1, "[luo_session] %s", sess=
ion->name);
>>
>> I am confused by this change, the maximum session name length is: 64,
>> as defined in:
>> include/uapi/linux/liveupdate.h
>> /* The maximum length of session name including null termination */
>> #define LIVEUPDATE_SESSION_NAME_LENGTH 64
>>
>> So, 128 should be enough to include:
>> "[luo_session] %s", session->name
>>
>> Or am I missing something?
>>
>> Pasha
>
>
> Yeah we need to to bump that size, it's too small - see the shared doc. T=
his is anyway needed for safety, as the user space call falls apart complet=
ely if it goes over the hard coded limit,

If there is a safety issue, it should be fixed (even without a limit
bump), could you please explain it.

I looked at the shared doc [https://tinyurl.com/luoddesign under limits tab=
]:

I see:
TODO: this needs to be bumped, as for the varlink API we will impose a
cgroup path prefix, which means PATH_MAX + "/" + client-supplied
string.

Why would we do that? Why can't we use a 63-byte unique identifier for
sessions and an in-memory database that maps the cgroup path prefix to
session_ids, where the database also gets passed from one kernel to
the other?

Increasing this limit would require a kernel uAPI change, which
requires a very strong rationale, and would bump up the KHO ABI for
LUO. It also means that the LUO session data in:

struct luo_session_ser {
   char name[LIVEUPDATE_SESSION_NAME_LENGTH];
   struct luo_file_set_ser file_set_ser;
} __packed;

would get bigger, and thus the kernel would need to preserve more data
for every single session.

Ideally, this extra data should be preserved by the userspace
orchestrator via a separate memfd.

Pasha

