Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33E6BCAC583
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 16:23:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87E8A8E0003; Tue,  9 Sep 2025 12:23:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82E828E0001; Tue,  9 Sep 2025 12:23:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71D188E0003; Tue,  9 Sep 2025 12:23:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5CC1D8E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 12:23:35 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 043F85A517
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 16:23:34 +0000 (UTC)
X-FDA: 83870232390.19.3C4784D
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1B9E91C000F
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 16:23:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=2+kDySGv;
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757435013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OiVBofelZHpMzXxZ3S925BN2xoWncKB8wIE7dJMH83E=;
	b=BgHbcjagSd//0g4VOSDDdPaMaZBIIFY1IfjWBgThPHcDAxrdr/PbGRpfyCmaCHZBgXOQAL
	9yifnZoian9m2HwImVcfFov4DtyWZFspMKjzLsCyALUjtw9VOhcfKhTjV18othRzIafYin
	b2Z0mCvbf/q46aXXRswBKPRaYkkDbM8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757435013; a=rsa-sha256;
	cv=none;
	b=519UE/F5pfmMqzgnaT+I+VQQQ/D7czI7idAPUT4Dc+WpGsJvfuR1aiNs7JuCcU8UG6Cdhl
	77PZ/Jzo64cGL+mk1coJwxHhFRs9SaHimlj/Yip5fOQHX0ctZon14Cem/2NOfcCuB0kBu1
	9ziVAwmSKdmj5WehlOY3q2O9OsVBLPE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=2+kDySGv;
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-61cfbb21fd1so27897a12.0
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 09:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757435011; x=1758039811; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OiVBofelZHpMzXxZ3S925BN2xoWncKB8wIE7dJMH83E=;
        b=2+kDySGv7rWfJdSUUe1M19NYm32mZJ5vSiVMuStZdA60sM+5ooc7sov8WnsPoQBrbZ
         ZvU9hrfPDs05qV9iDqYcsItTVuKwTikTHUzBSdELhXWU4+NbfucThhOl45j76YICPQp0
         vFuGLDLhxiFeIaDODKQqbD4Qx7woii3vpStt35mBBLbNYjYnypCKvdlUeXl2McADHW32
         OL8FDRbcgAK/8gV5qH1wdUab48sh0kdLMcwBlKxyGw+/yd8ETkjpIYGN7AnDSuF6PltS
         ehhHwzscMMtKtq0K/PJFSAigSwrbJzK5Dto4wwI6sQp8C5vGQDx8GOolI2AwEttqi+Gg
         +pSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757435011; x=1758039811;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OiVBofelZHpMzXxZ3S925BN2xoWncKB8wIE7dJMH83E=;
        b=d/wjLoAIGpQSW+7JYJA8I+XhTd3iPxxilZnVU0wLmYZzJezMFHRipjD42XLV/nxP3+
         u4rEctq3nLuEQqf9+VJrM8Mf/1rEUJXzx53F7PXqk+Jjxl/+ZTxKC2LqBUDvACqgF1xk
         NDhgUwS6Xk2F7MobXNhdNlOyQ4jgH70gGtq4mu+jZ5BLi5890yy16hKrLbLBEuy+UETv
         w1153hweKlRliV/y9iqr9K04YJiu5eB0jX6pPj9ee8LzI6B74kpyM5Uodk/lnI6rKdp1
         IebBcwxdSywHGIsTVTVg8L6x2YjRf25nTVFHTh63yOZQNsd77wTA3mHA5knD6BdL6Obd
         zcuw==
X-Forwarded-Encrypted: i=1; AJvYcCWqEBNOTnqc9S8vOwo95RY91yOvz6OzMGdf+La7bHKERBDIrsR5INJSaAuraJVJvUHdsXGqKtC2xw==@kvack.org
X-Gm-Message-State: AOJu0Yz1JvrJW6rSU7uxVYiTepWCds/tF9HnenQ9aUUhKUEJEDRJopIR
	aY76zlZi++t+yVpz/nX5IVK2xhCXtUqykbaYONWrmKpmjlaoJiH7594yMDo54y8CsKE+mr5mxK/
	0Ov9q8GTWSkvUeoqthl98eaMvhAJyJMSNVzVUrNky
X-Gm-Gg: ASbGncuUZNcqKqR6tGg4a+klmDahM+BZgon8XbN7+NfAvA1JBCkllRZh5JnXYFvZnLT
	Db+SykuNiFBZoLipX//hEetEdJXLn+9PkBZGn9AumksNRAKEK8BItlnorXlrlena1ybGkVA2Avh
	rbuK+lGAUDkLkXsxExZ70atl7etDmZJapxjPlkA36jnEy6T3BrGovAUEi0Ych7gEbQY5aVmaEaF
	RFbbcyhRTSH5ONABJk2koJ5P6a34Md08iHRNG4l+SQ3
X-Google-Smtp-Source: AGHT+IEpjhWf1f/zS3jSy099Km83UZ6GPfZLXi6Q4O+DwExC5+sMeiNfCbXZVRgPSvKKAmT1gOicI5bAQG3N8Tbzyt8=
X-Received: by 2002:a50:875a:0:b0:621:dc0f:6b2c with SMTP id
 4fb4d7f45d1cf-623d2c48760mr247988a12.1.1757435011094; Tue, 09 Sep 2025
 09:23:31 -0700 (PDT)
MIME-Version: 1.0
References: <20250909090659.26400-1-zhongjinji@honor.com> <20250909090659.26400-3-zhongjinji@honor.com>
 <aL_wQkwBZ7uLM2ND@tiehlicka>
In-Reply-To: <aL_wQkwBZ7uLM2ND@tiehlicka>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 9 Sep 2025 09:23:18 -0700
X-Gm-Features: AS18NWAMe0CzoiFSDbepBrWqyKfxIxGSu3RBWJfK7KdLpTSnI-kM7z2JwBdt3mM
Message-ID: <CAJuCfpFr_oCQPhoq4CfsnTm_Reu=oAGA6Bu1Uy-MUR7V60QnKw@mail.gmail.com>
Subject: Re: [PATCH v8 2/3] mm/oom_kill: Thaw the entire OOM victim process
To: Michal Hocko <mhocko@suse.com>
Cc: zhongjinji <zhongjinji@honor.com>, rientjes@google.com, shakeel.butt@linux.dev, 
	akpm@linux-foundation.org, tglx@linutronix.de, liam.howlett@oracle.com, 
	lorenzo.stoakes@oracle.com, lenb@kernel.org, rafael@kernel.org, 
	pavel@kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, liulu.liu@honor.com, feng.han@honor.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: j5w8g63k7trh7m6fpj4ftom9rowwx1hy
X-Rspamd-Queue-Id: 1B9E91C000F
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757435012-918667
X-HE-Meta: U2FsdGVkX1/UQ15rCXWm2/OK6WFS5BHZ9b9onYD1RRFl3dUo5OmwUvIWhQF0Le/K0Np/0pYgC2E3AYnd85BPS+j5tGw4dPYFQGhq2dfJC+SE273Ft1XVgx9OdKRuK5tYHD0pYsxEt4o+pJktAMbU3fspk9xZmWgHf/hjBJVLdYB4G9jL/ktWYx+oE/SxRoSi56Q0+qnBXXkR0YAClL8K1p+YBsLMeuX+Ab3ntbwbgJQeTv3fS7n8Jw1osuHV/ddfzokJl3jkC2PFnIM+k2Yq2QopyLpKMKoZus4BEya1L/Z0fflCAtRVj4gfClKKpgYa+9YTHytE1LlFhmsB39N4HhaU/I4XBaAuRkjKBSm4loVqkBDGXV+iTC79k67jTa+3d6eQlH/54WTXtMGb4MVhltx30tlz6uaPRHEPtBQkdlebd5VpLWea3qMBtWsONs7gFk9fQ76Aru1rM9CUPpp/55dV0FIOnehgu8hopQ9IpnWyGEPqpvG/aOpM2EWxRHsXtbCXfPBnpHQp6dzs6+PDf3Yd1l5I9jXpBQnyyy67tVdMBMrudzqDFsrMKfdq8/fv7pDd0UiqoZJ/HOZdO44k5I5EVCPfBmm1lovKEUt/MNbwBpEnSQwDX1Au7gMHURb5GyBwN8a4xHMtcLRFGbmoITuodEXIx/yyUPIJJuMJU5mmJRKb/528FFgdfWbKMGIC1tpJNfJ27+qmy4UOh+IefQvIoNDwHW3BxhoQQ/Y+7Y68NIZ5zT5sU8wbhQ8Z9E4sdoQtFfGvud9zkXNf46Yc5lK1lS0T3KmeT/8840oNHz5zNjnXrHeBQmRu/rt2hdWc8ucVbM7hP2CdBybBlxOTpPs/uJEpmeqH575ZzVgbrYTDflTKI8SB+EJVHI/zNz76QwiaoCzUhTGg1DTudL8VcRJISnLA2sITjyys5VISWVZbEHcamePc0e8LcrTUOIPbzUHO/bk9OZhLl+UkZKd
 0iexxNAu
 1QjMWv3ju2CpzjrypXUC2gS4SQ9FA2/1/BrNk/N3fm/ddR6MwupirQRWIX+lRp2PnBBPEWy42pWatI8xVN2KDVnNDw/q30oeXnPVnZ78G3yEWtkkfmfuFyTTi9AJyh84cUg9T/TUm04OJZfqtWPe6A55D4E36rTerTXHcXCscBhBRNFyIb1GG9lAkvc2VdY0DZ7MFEaYHASawlbObuoNc2WYnmdCWy50Oxo/VXskgYzpLtj4P0+sEA3W/Zsl1kXPAAbXVHNC/PowO2/nUIgsHca+QM0lnFGfwYJ2x1asvfhBTEcb7bk0xeQTcLc4kj5638xuj9256zVt718nSlLjSVAwPt09fBwQWQqyxZ67y7t8tntbWmMsv/0y8hbfRSMj0fpxC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 9, 2025 at 2:15=E2=80=AFAM Michal Hocko <mhocko@suse.com> wrote=
:
>
> On Tue 09-09-25 17:06:58, zhongjinji wrote:
> > OOM killer is a mechanism that selects and kills processes when the sys=
tem
> > runs out of memory to reclaim resources and keep the system stable.
> > However, the oom victim cannot terminate on its own when it is frozen,
> > because __thaw_task() only thaws one thread of the victim, while
> > the other threads remain in the frozen state.
> >
> > This change will thaw the entire victim process when OOM occurs,
> > ensuring that the oom victim can terminate on its own.
>
> fold this into patch 1.

+1
With that done,
Reviewed-by: Suren Baghdasaryan <surenb@google.com>

>
> >
> > Signed-off-by: zhongjinji <zhongjinji@honor.com>
> > ---
> >  mm/oom_kill.c | 7 +++----
> >  1 file changed, 3 insertions(+), 4 deletions(-)
> >
> > diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> > index 25923cfec9c6..ffa50a1f0132 100644
> > --- a/mm/oom_kill.c
> > +++ b/mm/oom_kill.c
> > @@ -772,12 +772,11 @@ static void mark_oom_victim(struct task_struct *t=
sk)
> >               mmgrab(tsk->signal->oom_mm);
> >
> >       /*
> > -      * Make sure that the task is woken up from uninterruptible sleep
> > +      * Make sure that the process is woken up from uninterruptible sl=
eep
> >        * if it is frozen because OOM killer wouldn't be able to free
> > -      * any memory and livelock. freezing_slow_path will tell the free=
zer
> > -      * that TIF_MEMDIE tasks should be ignored.
> > +      * any memory and livelock.
> >        */
> > -     __thaw_task(tsk);
> > +     thaw_oom_process(tsk);
> >       atomic_inc(&oom_victims);
> >       cred =3D get_task_cred(tsk);
> >       trace_mark_victim(tsk, cred->uid.val);
> > --
> > 2.17.1
>
> --
> Michal Hocko
> SUSE Labs

