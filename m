Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F527103A99F
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 02:43:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BD076B008A; Tue, 24 Mar 2026 22:43:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 347336B008C; Tue, 24 Mar 2026 22:43:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20EA06B0092; Tue, 24 Mar 2026 22:43:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0B9E56B008A
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 22:43:54 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 67DDA140654
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 02:43:53 +0000 (UTC)
X-FDA: 84583040346.17.FE80C9C
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf10.hostedemail.com (Postfix) with ESMTP id 47A15C0002
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 02:43:51 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=gm+VbmHo;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774406631; a=rsa-sha256;
	cv=pass;
	b=3RGYrMLSD06xmkiNnPSSwd2EAPtJfJUwZiqCNkxs2YbM4xzcHxhv/eUn72tc7M/68dJ8R6
	FdmXPTDrY8agQjN+DLCKhs5ZXL57rEEK8/GcyNn24xDH6cMl9eF0xIN/HWgFDmVj2kyBQR
	/lDlGaGEmacS7M8cm6cB5EpXlSzd0yU=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774406631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S49Ro2Awewt8DGHII5530iVBK0Fi/44fxcec5lAc15w=;
	b=ilo/vI44gBImWBkquU+0hcT1cS2d6qYHjI0PX1V67nLadCzpJkFBbbXR+E3w7YGBj62rtL
	0jmsuJYbDaJqF45K045RxP1MBqGskX2qGy3TPsobuoUuUcb4Ujut4aPCT2TnugXwrGmftc
	TdciRdl7eqHOREPxvE7V5aThowGSDbw=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=gm+VbmHo;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-661cfb9f3aaso7953754a12.2
        for <linux-mm@kvack.org>; Tue, 24 Mar 2026 19:43:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774406629; cv=none;
        d=google.com; s=arc-20240605;
        b=iXQNPWT4Uy/f6TMoFGCt/jBIOypnLu2goOgrzKSt3ftRAxM6Fey3Zzb5rw7UVs29jH
         sXAqBIU3c6xMsLX27OYoeExqsPjhjotqy8rOAGlZIbEVtq0ihGQu5FzAvipc0DX9xPUR
         p1IAg6WVy4ptMqQXK6GJK5dhHnIp4DZeGZ6XmeU7KC8KqeKDBdcWBtEnfl7zb/wrDPn/
         5H66NuSgPm4sW+AOGv5UFPx0wkjb9kpUYqWbgQc4Kk4fDN8W+s4l1SsrDjlIlbPGaqsl
         DRjUjD3FLv0zPCy/OxktXn6T3jEEnB/zzfs9vzf3ZRPeJCtY/OW4zi9CXZr2HW2z13m0
         g/KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=S49Ro2Awewt8DGHII5530iVBK0Fi/44fxcec5lAc15w=;
        fh=NupFN0s+zrlGTVtWH7dcRqAgvX6AmxA27j6XI/FNxJo=;
        b=YHTyteOMRbsGN8u5l/7Oo3UpCXaTE41vNnwCSF0hOPigCLviRx/j0skk7rKJmUPLgz
         5n2rLyPl8SAfG8l/EQ0+2SNQHUAjEKhbB3DwZfLJaXKAqyVNYPBFzWITbKSsdk9B/1sx
         qrPcSm+2h3g9OQR7zIKdYgvB7smgnjnlACFBP41wLD2v04YPceojAQc5dGx68nAVw23P
         5nt1pgFYeU+VMzqL5Bj5vEHRhepjogLJLk0N5vmrBotfQsWqfw30lg9MHl0scJp+8dcP
         f446l5i8NsWe/3NhVsyBaFpuZ8mP067RtZcptfGfyzNM6ReKWRsHIE3zuupYCwj8+g4j
         fDxg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774406629; x=1775011429; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S49Ro2Awewt8DGHII5530iVBK0Fi/44fxcec5lAc15w=;
        b=gm+VbmHoDYiQYA3+je7/cZnX8IM/1LjNuzNb23yOB6HfI6wNV3kcxJxL6e3Cthe82f
         uwIAGv1nXOOKHFOJE7GUZU1RqFaD5eJFJgYTXlK+l92f3bmm9BfO9TM2BGPKtkwIBVqp
         7aMQPdYB1DodZ6MbgoNz2O7r8T9u8Y37iT6HJBonoyDOdGrSJ091whzJJj5FA30zh67Q
         VgROxIaS9IuuyyG+XjoQk6mSuL+ZX33a6GA018eI31rL8hrwQfAn8r9x0CopOlXgaoVz
         +5CpMwX1eeutk+438wrOIj7VhXEBRyBnsTcnG3IPcEkEv1yv/zvaFdFBAjxow9Ymu7FV
         51cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774406629; x=1775011429;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=S49Ro2Awewt8DGHII5530iVBK0Fi/44fxcec5lAc15w=;
        b=diTjjuBiCTWFt9xdEbmoA9xUckWsgUNe3rJv3cOjPRKspLel8iLsE+3ODaWuN1HosA
         EBVw5D+cP5sxYFAwhEdAN8uHlTR9g5NHk+ydnCNcwAxrklszYTHLim4JcBD+bwZxaamK
         UvKqLjDAV+Ns1UX19FU39NzRZcGZRK3FejjtOetEiUD1HaPRWkjAosIFx3Fi/5hd8qqO
         sOty9PEPjR5hvYZRiAzSvXny17HwiPl39OQ+unfBWLqFLPLh9YGCKqeX0G5IuNthw848
         rXBR5qLLimC0VhiIjs456wGKcV8/M5hEDf8LyExkMHqGUYcTFSx9fhBkeSlOUCD6dtlP
         N4yA==
X-Forwarded-Encrypted: i=1; AJvYcCU87+5PSMRFHEleD94dBVtOJeBZ9Q8KeuO9qv/pS21GPpHG21xwaZlDx7exOegMPeXGOYdRfPG42Q==@kvack.org
X-Gm-Message-State: AOJu0YxH2N6oLnvTje+SZvHpQ9TZyyDDOmQ28icO873iJCBYT7PkBXau
	bXbnwQqY36x/Of6zywdvJ98tc61Iu1a4Ap52oVL6yRCQUvrzWU6rlDsCbkCUmNAwo/kLCuUPZ9O
	DWb1UzoXxDHh5IjhVG9xqC4f+FgIqbx0fYgc25T/Qqw==
X-Gm-Gg: ATEYQzx9t1TM6Ee2LlE37NuW3VOQTBJWI0aT5YfZkapAlPnWjEkVDJUzh65w9yq/RPN
	uE/ZYZXiSPJeThix1LVAj0wOyBZPRZnENsQ7eYc5qOwYHshOGlyOPpwVMrDrDNn9Jp2o6/qGKBS
	qFDka4TzzpWB1Pu3XW9ny26Te35Nqao5AzbKQ9/pXp4FUy66JprSmxhasnDZ1p54k8/M1vgGDXx
	JNd1DFGIdFaZjYgmSUUx91jNvLfdRWtcUdQEyYqtqmmEsvDYowsbH3tQPf6dumRrGsmiNtebSGI
	2zPyQQu6prJyuSsxwKTfGVWQLoMtIjzdOEzcUg==
X-Received: by 2002:a17:907:6d19:b0:b97:98e9:1b17 with SMTP id
 a640c23a62f3a-b9a54254cefmr104541966b.28.1774406629257; Tue, 24 Mar 2026
 19:43:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260321175808.57942-1-pasha.tatashin@soleen.com>
 <20260321175808.57942-2-pasha.tatashin@soleen.com> <CA+CK2bD2aNu-NByET4KkBP0n2j8WQE2zjxb4g-1cv2hYfjaRZQ@mail.gmail.com>
 <20260323-leibhaftig-blasinstrument-58ec408b3c40@brauner> <CA+CK2bC6S7pFCYR0XS1ZPxw9HKjWgxy=0DkszYNjMUi735o_1Q@mail.gmail.com>
 <20260324-langzeitfolgen-altgedienten-ccef17d19349@brauner> <20260324114021.f5546d2de5b6a2b0490f63cf@linux-foundation.org>
In-Reply-To: <20260324114021.f5546d2de5b6a2b0490f63cf@linux-foundation.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 24 Mar 2026 22:43:12 -0400
X-Gm-Features: AQROBzDD_dN5K67m768ffew-lTTbV5PIJ8L5d861vCwJTCIzcd1-cpNV-0z3o_s
Message-ID: <CA+CK2bCbgXHnZ0PhzfKE=NkykyqMKq6KBXW6JqMpq2R3k3RXDw@mail.gmail.com>
Subject: Re: [PATCH 1/2] liveupdate: prevent double management of files
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Brauner <brauner@kernel.org>, linux-kselftest@vger.kernel.org, rppt@kernel.org, 
	jack@suse.cz, shuah@kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org, 
	dmatlack@google.com, pratyush@kernel.org, skhawaja@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 47A15C0002
X-Stat-Signature: dnnxy6uyjf7uuaqw6ou8h4cqyafmjpjp
X-HE-Tag: 1774406631-815110
X-HE-Meta: U2FsdGVkX18is/CW66hJCgxLWxQiyjIWIcJjTQVd4Vpp1DeoPyFAZjQGVvxA7boXeKuIYYguSZVFpYjv/XEZaorhGKFL/a4YHFKt+dZYaRtBurMPlEm7aLvKLyko12CLAUItv005q31+9OzdVBzffQ6Kk5bqNkAAtaIYtvCQTFOUR9Rvm1hj0+sHGnJXe7P8St0rExrVr1A8o7EpZCCuf9PQh4svAvHbN18fPcp7fRpNzRWmbYCX1m0OALATxuBN+AZSS5IKgL7f/+IgRxOTxwOQKQcynglFI5id80DxO3ESkSayudBw84SJEIxiTWMdsp15L6/wFgaV9fXF64GYDl1Ju+ElMm8jp0I82EwfNwMQHdnsa5ajvK605BVB4Kqrf8Nvu4M2URIWjp/NuG97vCIbvuPZ/J+THRWEGKiFX3TqepO9MvLAZqhiQ/V97mbdd3dJBIKQimZ0h1iwal5Tt6aDCaBT8GSeE3k3/Vj7k+eZpH+DQS8oFr3d4bC7AJKf3bzmuWOnCl0sXBFaXNvwZSUIJcIChGVHl1mjkPq4uOUNH7Zo5zk/btO074tNE7CHIHpSZQMQKfoNOtnIK3Zd/AOxEU2+GviF/KJa+NG8W2LjCzuIFTd4rxzMjhEPEtqmze1A7kxUUeU6hsM/k8e2tI+p1W5TdWVG2UN7ka9Kah6UhzonotwrQCSPdQFqsM/Iy1uIRxviXP/G323OBMAJdO5zbnFEt+4n/pkuMHXBslhj92cIKMYxgUQ3Amn6FurnGDrV7CIlccLo61ahAXoP3sNAFBq1Dav3DYOSOxDOPaqMl76EsUebQCbX7dlHXKS5g7XDXYRm70teJVMf7V/piuqBiOol16oFcxfo72qao7lRkJrD9ep+uPPfWvX2LUWRExCBxHDsqAYU4wwoxp+seJPPrKDZClbhNSVGXriUHwFUEI7ZJUkCdm5OtgRTcFLvnKhtpe+VfT8tkCpjcsj
 U6W7u/Fq
 Ile7b3jpMVQ3trhSL7AmL2ORa4WRUohgPgdB29vxJGbY+5tIUnbEUBHjoPRWxWKuSXrx76I1VwnvppiKbFslVlqdBvAQjU0ME6Ocie8NZs6AkS0LZmOjhAeD9d8NaNSVqKhXydVXDp7VPp9Hg00q5uihJVKN6CA6HmD1poakXXWWGBUWg9VObv8ORWcEfmIEXufZqSUlqhtrnyFZ+F7fAEOfbuBxjAgzKBEIHlrRd1JPt2HhgTUY1c2MFXsBe1Ntc41bJtmv8OQgb8T9wzBLIhw0ln4UJn470HVdaabkanomoNpg4GVYOgTlPLjdyvx1u9G2shqs/3Wlp62J9EY9gnHp9WR+hfgjRm72EnXuKD+ZjFrJfXhD7O9PHT0zqMspt4NpN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 2:40=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Tue, 24 Mar 2026 09:51:34 +0100 Christian Brauner <brauner@kernel.org>=
 wrote:
>
> > > > So, I'm not happy about I_LUO_MANAGED. I don't think we need driver
> > > > specific stuff in struct inode and not in i_state. Track this in th=
e
> > > > driver please. I don't want this precedent and I'd rather have you =
get
>
> Well dang, I just merged v2 but Christian wasn't cc'ed.
>
> > > I am planning to use an xarray in the next version.
>
> That's what v2 did, and I_LUO_MANAGED has gone away.
>
> Christian, does v2 look OK?  It's at
> https://lkml.kernel.org/r/20260323203145.148057-1-pasha.tatashin@soleen.c=
om

Yes, v2 is fine. Here, we discussed about the previous approach, this
is one of the reason why v2 exists: not to modify inode, and also not
to rely on inode being different for every preserved file.

Thanks,
Pasha

>
>

