Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C708AEA4E07
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 14:36:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C95176B0089; Mon,  2 Mar 2026 09:36:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C17DE6B008A; Mon,  2 Mar 2026 09:36:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF02F6B008C; Mon,  2 Mar 2026 09:36:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A05816B0089
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 09:36:35 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 50A2D1C0A4
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 14:36:35 +0000 (UTC)
X-FDA: 84501373950.29.0041C59
Received: from mail-yx1-f46.google.com (mail-yx1-f46.google.com [74.125.224.46])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6503D1A0017
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 14:36:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="eQoRHS/0";
	spf=pass (imf19.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.46 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772462193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YVxdvulkv9AqICT4Rbowxho+KRVq5jS/cPPbAw1RVpg=;
	b=NDOY8TzaffdMqWXH63JyhssVd2Jab9WSOQMfZS4bLpM2Sladx+82lFQk9Mark3pAPmKypL
	p9ygnTJG1RopusrM6tnlExj/Gca7cSTjz3IBvJLgL0WuRm1RWDH+7pha6Dqxt+lisMAfCR
	OVsOA20ZUyVoAJ2axdySTJnaCv9rLU8=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="eQoRHS/0";
	spf=pass (imf19.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.46 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772462193; a=rsa-sha256;
	cv=pass;
	b=z2Iw26JzJHqzkptRSRfU95A+/NyD1d+NsIV+2A00LUrnNU04kK2GT2AxVrKT82qbw8i5+9
	XBzc9VaQ1BLg/ExOqSNc67rVzy2NZkAaQ/ykiKK0bJY4AbgNBK/CWyYCP4sV/Ye4lNzJVe
	KbKHlwgtirpefAg25RGoSVD1fRTkvko=
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-64ae222d978so4074107d50.1
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 06:36:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772462192; cv=none;
        d=google.com; s=arc-20240605;
        b=R6NY30SnqEDP9jBsnh7lJzz82CqbP6Ph4aXVJKG5cDynzX+blpCY4sO46/gLegw/oC
         9hB44pShhn4tZ0rZkgYc9Ik6RyiHasCKBG2iwYjlLSssB+V+heI2/OGP8SGbwkdke1vp
         B/aX6kkfXmCu9zgwnMzfu6tVA6zjdu2iOBrAJW1BnFZTj/CwXYlSfybYpUZpf6Fd0qgD
         cnhhxneHNp36ZmQZaaYEfr0n2R4CZJxX2b7DdObJOEGdGG8UbMBJR4icbcOrLDCZaCXC
         KcyuZiDjt1bbLk8JSRXfqCQxQ67kdWHPNYzt3IfPcFyhWFVJ8JJKOJYLj1AbyqF6Gdt8
         ACPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YVxdvulkv9AqICT4Rbowxho+KRVq5jS/cPPbAw1RVpg=;
        fh=EPkARMYsGqOk/RJNVBKIKrSf46oplvt5KiVk2GYssWg=;
        b=MVN9KBu02iNuQdUqLewyGihvXVwgfS1Y1JrzipxPeN9w+g92+9+MHxDQGhKjICxO+P
         OAhyILTbUjan77KvwRBlSmfbFRJ9OZHlwxjTyMftLeRsc3D/KBLindp2fMeq2yuUyc5Y
         RdpwWRPbqTTp8FCsal7au+KG9MUZYn0lOiUFo+0aLfchfWo/LT4ntyQ0pBnCurBTm94r
         wYbvM3E274di7QHCa10wGTFl0kfoXvj8u7o+NmYo/if2ZkXoNEKU4VytbH9G7p81O63a
         +DwqKYZsOfBTVwxSiqkNAWcC3mCuhAIwzQuK2gKoWh7L/LBrurAWLOinToghjpWN6rUp
         MnFQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772462192; x=1773066992; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YVxdvulkv9AqICT4Rbowxho+KRVq5jS/cPPbAw1RVpg=;
        b=eQoRHS/0M8kXArWkdyrrM6WJxYmNG0pKxHtbYxDfaFsnaStaGgLqFmkZFUqfqow4cS
         +fXHkkSgGbFV58u3ZyyIn/tbOuXf9ZAehfGAEMcIRsbHOq0sZcqVqtROqLApwK1r2MpZ
         v1qYW6EiV2GhI3M3xCKART3cLBqP/ckNfSH43nw4hbX93CbMesuQ36OzlNWK1Q2jcOe6
         YUBpMW1Gjf4cZK4+RQEHHjYOMaorDDgybTzB/xCARUcuZPXpo9KFqi2TfNjCupgQivlZ
         qS97JiBffuA/w5X9vHobI81AI6PBQn3nnKFrr8gWs97/3m4ARtg/iW/0qMvDcp08YKB5
         3j6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772462192; x=1773066992;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YVxdvulkv9AqICT4Rbowxho+KRVq5jS/cPPbAw1RVpg=;
        b=Bh/nvU+Dd03emruz3aaTa100bxo2EKg6nPUbHyaxeJTAIEgYwKtBBJVajZN6XZq0eR
         5JDbyQbymwNc2cExvq7XMbpcarECgUXc2VeKdd6eHW+csyQrmSbX0b/wKhF2wKc3AVfQ
         2ArRJzV2XgxkHGFTTO6vBiTmLWAXXFQ9fm9msTXhIPFhgkV12v9criiUwJfLmxr4OuZb
         hc5RQr8aILhNHHSa9IBkrOsX13RxAL7mOf1c8kza3dj/l8LJEASdxAAfzRVzsqwic+R/
         GVvT7kEj0GrT4WfgPOCP/urZPqJPItpOmJpe0L+Fxw5WEa9kBKoQjabW16DtyuHmWNjk
         y7Kg==
X-Forwarded-Encrypted: i=1; AJvYcCVeN9mSRPAp5MDKuJF8p43fPAJpr+o7KPAXKH6SK2q/mBnDx5HcOYhci+OZOII5n4jtFTuCKGhzaw==@kvack.org
X-Gm-Message-State: AOJu0YwQ+5PGAQ9V3i6+pYAHUxNfcBkU0O6A/9e09fwTIiYheLH6ByAU
	S2BEMPolpje48kF1qu+c3DcJysKNB0pZr63BSFka5bQV6Tkr4oGFouIpRPEU3M9zyp8nGGS/gVy
	sSTDYCtdg57ECI9SvfLB7AvlTYaTAtRw=
X-Gm-Gg: ATEYQzxMNZmVxYSA8tF87feS4fcfKclRKNnjUodmO5WngRok1FC1mDcF6/qA8nSQYj0
	NTn9wAgpLtYauPUhDCkCbwVK2KYWuR5ZPxlBK5ZAnOPATfYmbvl4bcUs+stWF4v5ABtSUjmGnRK
	f3/URpgjH18rH6+9JhcJjbjWXzoAGnypj5Cwa4xoQcn/QYzxO/rVHRcXp8qQvDl3pyut04OKmJI
	AiK7WEhnkE+obQPjHoFHbJ3jbyE3k5Fy5lFqN1qg8L56LqPpfwqfeGdotLkrXTEGuA9Oi38j8j4
	QPlT+I0k
X-Received: by 2002:a05:690e:1a9b:b0:649:e6de:8f4a with SMTP id
 956f58d0204a3-64cc22100c9mr7049108d50.42.1772462192392; Mon, 02 Mar 2026
 06:36:32 -0800 (PST)
MIME-Version: 1.0
References: <20260228161008.707-1-lenohou@gmail.com> <20260228212837.59661-1-21cnbao@gmail.com>
 <CALOAHbBKr5ni=Ap2ASq2hx041WAghd+CzqbXGBSFPExBMJzcUg@mail.gmail.com>
 <CAGsJ_4xA3tApXCs2S-sZh2qA9RK_1masQ7nb1NYyCHXwnP9FAQ@mail.gmail.com>
 <CALOAHbBRBot0EXmzPNb2zpgC2GV5NfnzAZuosTb-iygjaw3U=w@mail.gmail.com>
 <CAMgjq7Bqb0M4bjCeaxjAgaB-Kj_kWKVjMMNdG7528w+uTwGnjg@mail.gmail.com>
 <CALOAHbCma=SW4nu_GPv_pbuuXv1V5JPB-9cA3z1TeemWqU68tg@mail.gmail.com>
 <CAGsJ_4yAkaqqzSu7SS=_fgZ_AQCqtbv8LmuPGCb7SiFpGk4csg@mail.gmail.com> <CAMgjq7AkvgzW96-JQzEg5c4oW0cMsjPHcCnukCUZXgSvXL4-DQ@mail.gmail.com>
In-Reply-To: <CAMgjq7AkvgzW96-JQzEg5c4oW0cMsjPHcCnukCUZXgSvXL4-DQ@mail.gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Mon, 2 Mar 2026 22:35:56 +0800
X-Gm-Features: AaiRm53lZgh4eoelw7Zz1lBPu2wE512tW5csxjy0RkmTHhPTFIfXQPqWdWp73oA
Message-ID: <CALOAHbB3rQ2b7ABqFegt2afYRL7KjpWREucrhOYfTT=onV1+Gw@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: fix cgroup OOM during MGLRU state switching
To: Kairui Song <ryncsn@gmail.com>
Cc: Barry Song <21cnbao@gmail.com>, bingfangguo@tencent.com, lenohou@gmail.com, 
	akpm@linux-foundation.org, axelrasmussen@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, weixugc@google.com, 
	wjl.linux@gmail.com, yuanchu@google.com, yuzhao@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 6503D1A0017
X-Rspamd-Server: rspam08
X-Stat-Signature: ojufzy7pbj1neyey7roh86wbib5ac34f
X-HE-Tag: 1772462193-281876
X-HE-Meta: U2FsdGVkX1++jgmcYv6/iHKClb9Hx8y8UjFonGU9fyX+6wIruu0CDfxZ9cJYf8NvmGEkmE9RKbVIfB/HbQnHuqlnhXl/xzZOD98rEeAe1qjZVJex5tahv9WYHHwf/4G/ulLAo4nb6bhArF/vAYL+etNBb8YJwfRl5lx0LWYq8x5aSzvIRDkBiCnM7FGalf21NmnWX1eC2zZ/vVlG67VLp6uCVpwjQ/kbwSsVsTABjZCOSTnkR7TiE6k60aoJk+kqj24vCg19ptb5VWL0cmyJcEQaXNwVg34CvAd+hUZP6qWyUvw5wQPIHeQ0+oaqSPsz69D+Ckcm3nsUBqK+LwG8cTft24g749vGOUjuaFnFV+54Qj0Dap5plEpNwnqewW7aAazKb/S1FNO+URi1a5dOQcMnYMpwOJnKwTejwphD9QmiC+vhthOPuuUN581dXVOZ22FuDKU+Z/TMMEn0hfMfjIISZEVv69mNlz0HJTFapj1+8+TjY4IVnNmNxXAqtcm5UiAhRGls+m9lOd6g7QnGw/Yb/+VYuK6S8m3p9UhPRmNUi3fqcwFOjrFmP0BZ9gzUV3+Q7LgP3yd4z2EcI6KyLBbJIghP6nx9AAU4fH6pjZYk65Kl/OCtL6F1zP6SD28ueT2OCanW13C3KVEJUndVbeJ+8h9OMS1vQunJCXRmk45FtkfEfjDE3HX4+ev9i3iZOL8uQ2CBnBQYuxOGXgeo7C6L0XbqhN2xb8US7Y3bbUseoLMJ3LChu+By1MgTjv7DS9XLd8P+NqiTLHDsNzHKeMPP3SXshFncElMdUISJvR976yPmXVs4ABXmVbquQPxi+x2B/bAirPHW6CjkrHnwxcpvxWdfBWmcl3Q6fskz796cW0Y7MW3flWVy4WjfY2EFugoN2KaX1JSXAMY+iqpz5Isi+6zBgWa5tocZi8cx7jvmOK4V8oq8mlQ1CfGMObs/tUbeKhmIDpbTY2/CK2G
 9JO55zyM
 m5WdP0gdYjzKhOpzcoNlQtdVRz5cf+RbY5anVjBCG2m6THIHCkKP02disEOcnGxKj7JkzJahcHDDzh7q0hGvN34fDFT/Ipit9p9kZ8+CFqQ+VqS+xpCiQjWNpaZwGho37kuxWDETaN7R8H57TG+VDdjmJ/KnZRQXAEnPa2Aa6CXiFGX3im78BKphVNKoGD2L/cS/xaBpUwme77HoA1uoaiQv4rxThr1MjMBJq9bkcHm/13WZ1xy+DuOexYEQHxxAfmIKwWxgf6aJMCxU9ykInti0l7O7sWmaILmwnDHVF909cHLlhchBCzB4EcwAuLDbMspLzGbR+TNdooqNOkI58wk6BinO9ZY2zQ6gJZcvufGJVq3OZ5+0gaKB7GoQtpwj7A7FeFG+/EjKacCmZD90+FrbcaZ/q16JuBPmkc9UlJa/UsdhkWBrIsZoQg0wJYX9xlUqrLbPJXu2xgW7qCgDZwwmS+NlSMtR5dGu5mcc4GJKp6AY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 2, 2026 at 5:48=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrote=
:
>
> On Mon, Mar 2, 2026 at 5:20=E2=80=AFPM Barry Song <21cnbao@gmail.com> wro=
te:
> >
> > On Mon, Mar 2, 2026 at 4:25=E2=80=AFPM Yafang Shao <laoar.shao@gmail.co=
m> wrote:
> > >
> > > The challenge we're currently facing is that we don't yet know which
> > > workloads would benefit from it ;)
> > > We do want to enable mglru on our production servers, but first we
> > > need to address the risk of OOM during the switch=E2=80=94that's exac=
tly why
> > > we're proposing this patch.
> >
> > Nobody objects to your intention to fix it. I=E2=80=99m curious: to wha=
t
> > extent do we want to fix it? Do we aim to merely reduce the probability
> > of OOM and other mistakes, or do we want a complete fix that makes
> > the dynamic on/off fully safe?
>
> Yeah, I'm glad that more people are trying MGLRU and improving it.
>
> We also have an downstream fix for the OOM on switch issue, but that's
> mostly as a fallback in case MGLRU doesn't work well, our goal is
> still try to enable MGLRU as much as possible,

Our goals are aligned.
Before enabling mglru, we must first ensure it won't cause OOM errors
across multiple servers. We propose fixing this because, during our
previous mglru enablement, many instances of a single service OOM'd
simultaneously=E2=80=94potentially leading to data loss for that service.

> many issues have been
> identified and I'm willing to push and fix things upstream together.
>
> I didn't consider the the OOM on switch an upstream issue though.

This is a serious upstream kernel bug that could lead to data loss. If
it is not recognized as such, the upstream kernel should consider
removing this dynamic toggle.

> But
> to fix that we just used a schedule_timeout when seeing the lru status

So your proposal is essentially something like this?

    while (status) {
         schedule_timeout(random_timeout);
    }

> is different from the global status, very close to what Barry
> suggested, with some other tweaks.
>
> Keep doing the reclaim during the switch did result in some unexpected
> behaviors, including OOM still occurring, just much more unlikely than
> before. Like a typical TOCTOU problem for checking the lru's status.
>
> Let me Cc BIngfang, maybe he can provide more detail.

Looking forward to your solution.

--=20
Regards
Yafang

