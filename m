Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC1B4D58E73
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 08:00:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AFC06B008A; Mon,  2 Mar 2026 03:00:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2874C6B008C; Mon,  2 Mar 2026 03:00:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B0D96B0092; Mon,  2 Mar 2026 03:00:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0B0456B008A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 03:00:45 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 84DF55BDD0
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 08:00:44 +0000 (UTC)
X-FDA: 84500376408.19.A160AA7
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf19.hostedemail.com (Postfix) with ESMTP id 78F291A000F
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 08:00:42 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ky87Q6xs;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772438442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ahaUefrpAT9wCz7+iCHqiZLSAca+K4BST7Qwhh9CAlY=;
	b=6Tf4ilDNI/dpJ32aZPjt2lt5PmskTEJee5tysPC3x/4fUJK3GXDsz4i29+ieqgTtifmjjP
	d29nnAm/X5GWLEzjCSMTno56S1a6ZvAplHEoA0jCwWjGw0/QupV2MnUX9VTmopUzjxXMZ1
	DT703w2UXwHmidmFJtl/Qgu/NT8uj/8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772438442; a=rsa-sha256;
	cv=pass;
	b=derTSomDYZOwyuBjNfyS1nUtpylwPDKZTMx19r36j7ZrCl1sKA59AI9A9T4vHj18x82CPp
	aQPCvs44QGE91LB9gsvwO3iUzdiiMKeIMo26LYvlxzOI15qXn/ysjhEQ7NLf0M/ixiH1qA
	9fzqm1O3kqOB+TLMt/d795sv+77bHTs=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ky87Q6xs;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b8f992167dcso427342466b.1
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 00:00:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772438441; cv=none;
        d=google.com; s=arc-20240605;
        b=AJu2sDsVVBZT4nI1wX2yJxJx8vWEB4J3HuQE3uKFaIGYU/8xlEDRf0yAGF8Eg/oZZA
         1yoj7A/9FsHqdPWIZZLgCUc6ozkvNzzwZwcC+fPLXjDzkN0TGltOaThb387zSjTkrzt3
         bk7bww9iKB82xuP2eXAxXrrW3HpHNg3ld2tKpEG/lR2o6R7OMztYjspzfjom4tiq60eS
         95pWtAOtbP+tW6QLpEMfsoFP+MOhxjz9pwOtfkgeS4qGpPutqBfgyQRcORrDBW+IG3Vb
         azzpYDdXNdqEWGYQB5sv57xrF2cpKuhIRf8Waq8fxzFV9oNDqMCAhPpLGVPlwawgDmpw
         6k0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ahaUefrpAT9wCz7+iCHqiZLSAca+K4BST7Qwhh9CAlY=;
        fh=2GL/OeQsKG13zEgYXhm1jDRhReAYslyPOzdaupY209w=;
        b=QM4yA7uw2pX7v82dwtTLVlEqHpGF2J0+jv2JhQpeo8rM1OBBNt84E+WaN+YsCA8Hfq
         n+mnRuvfeOi+PNzwKNcEuz+6Qd+YVeiRh96CyOJkz39gjE7MV+qlR8T/VW4WIqXx1Ub3
         M0aSxsIfUDq7jkD5ymlqBzz8MNRAnxXBT4l+bkAbllM93OoH9hFqaeIygNdSQ7aWIJLv
         GWZYWOMvpDwVU4jgXNLa03L9NWHWzGUQwCxN4F/SeOgw8x7NkIKAQlyUF/13GLo998if
         LKjEhhWEshi4nqlHoe1b1zcCU50wCWVhdF0K9Zaz+9TtZGKQ7v4Sl8XnPlhqlZ5WP+uP
         wY7g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772438441; x=1773043241; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ahaUefrpAT9wCz7+iCHqiZLSAca+K4BST7Qwhh9CAlY=;
        b=Ky87Q6xs1bfDASVyyz0qmKi/YNteVBBCGfu2BB/nsPuhIWaB8Q0vzrjykmSEuVWvU1
         RafoIW4o2ylusfBzK7z/t+tFurDWdw8DEnpO2jq8VszaPL3eoy6X18d1e6yayHlVa+Gr
         q/zUfNstRjxweihiByy9bey92ubC3vG3QMaCblPFSV2irgcw1ul2b9TCHJsAFvVY6YgM
         osdB6Fe1XYCn5LIq5Q884QY4aSzFSV7+vD2st/tZwB2JvJGJ+k90evYWHAywRfI8gnw0
         YbK/LNuDnKBWwIK7469wWOcdaXdZeqg7pO7WKxvH60kl6MMh073JTxwnGCT7DQqQyK0Z
         TqcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772438441; x=1773043241;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ahaUefrpAT9wCz7+iCHqiZLSAca+K4BST7Qwhh9CAlY=;
        b=VLwhE5e3TGmWljuM8YodbnKLNQZdrKyjOLv9K56l29cYTdESGnRAuVOhDmbsFHxXiF
         fouq0+e8k6cVWHo5JupA46ECJBtYO68+SnzbIBWv5+upPNxpLmPSTKakZTq63rBsIVhd
         b+xbo6mR5njfBKXeMigSnYZPcIXoxy7HFajtuxM2MLJ5Wt5RvAOLOu+BXJBQoef5IFxH
         bn5Ej1GLobd1CAgFc0YbficEqEitXl2PoQclZyJE489O3s/6dbr3BWCdm1dSPdtmaL2p
         4tZ12qe/WkjyDvdN1XYuHc5Wk4KiKUDRhVa8HTYZM20zNF13NvVKmuER9NAqXdEz9NfY
         B9AQ==
X-Forwarded-Encrypted: i=1; AJvYcCV4gPA5yAY4wfxT8Wv/HDpEixUNAiySBoOr9k2dX481qOmV3Bkqm4OVuxoI/+JM2xazwRP3coFbyQ==@kvack.org
X-Gm-Message-State: AOJu0Yy8ZB+NYXSCo+hDd3ik8tcAWQNrAVH9zb6rzbYvn6X5rkVqkQRu
	SpfIZMStcoukrA7vRQH6mBvol6ANxzFveFRM9mkckWOStf620uEgpNR+kflT0Knio9As8XeTzNy
	GH26a3BlSxKyDWjpH/fDq5eFM6InTDEY=
X-Gm-Gg: ATEYQzxtiPDhIPppEZ0IBjubNogcR5p6UUCla+6J7jbkmE1sIzulZPo5l7/W3SXwlM4
	Xgx3naj/L1HqKe+UcI74GvCBxm+3FTKdEcfSJXyLMk43EWwEq+tcQ5kklOchYw9BEfUWh4KWZuJ
	YCkUgJcD00JrYdF41b60PnUas4usW7Qju+09pqVgQzpKEWLfGLdCJU08iBCEZ4IW5srjj434vRV
	OJxHiEt3X1FXm/op0pkPaiuqk7NUQgQbCRi9ZSh3+dy38RQjzfvSJC3qrazQt1zC776D8vxiOlj
	9S8R+5imvD5nmLymV74zbDpd0R2gOhtcKhSMljat
X-Received: by 2002:a17:907:3d10:b0:b8f:9beb:45e7 with SMTP id
 a640c23a62f3a-b9376510149mr816400466b.29.1772438440483; Mon, 02 Mar 2026
 00:00:40 -0800 (PST)
MIME-Version: 1.0
References: <20260228161008.707-1-lenohou@gmail.com> <20260228212837.59661-1-21cnbao@gmail.com>
 <CALOAHbBKr5ni=Ap2ASq2hx041WAghd+CzqbXGBSFPExBMJzcUg@mail.gmail.com>
 <CAGsJ_4xA3tApXCs2S-sZh2qA9RK_1masQ7nb1NYyCHXwnP9FAQ@mail.gmail.com> <CALOAHbBRBot0EXmzPNb2zpgC2GV5NfnzAZuosTb-iygjaw3U=w@mail.gmail.com>
In-Reply-To: <CALOAHbBRBot0EXmzPNb2zpgC2GV5NfnzAZuosTb-iygjaw3U=w@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 2 Mar 2026 16:00:03 +0800
X-Gm-Features: AaiRm52DPMthLXqSbO8DAuF11Ad1oARoHHYBayU7992KP2cqR53vpQrr_pXL-Vg
Message-ID: <CAMgjq7Bqb0M4bjCeaxjAgaB-Kj_kWKVjMMNdG7528w+uTwGnjg@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: fix cgroup OOM during MGLRU state switching
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Barry Song <21cnbao@gmail.com>, lenohou@gmail.com, akpm@linux-foundation.org, 
	axelrasmussen@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	weixugc@google.com, wjl.linux@gmail.com, yuanchu@google.com, 
	yuzhao@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 78F291A000F
X-Stat-Signature: h5fxnwfwdggzydnu5tj633tbj3obbk6d
X-Rspam-User: 
X-HE-Tag: 1772438442-257192
X-HE-Meta: U2FsdGVkX18KTpkQgMbeEdIgxqG8pW8oKSCQLzRcnuBrkvAZKcS1oHy7VofxP26YA8pwPTmJuMwmNQrkUjUVGKpZYwkJNcUTeNoiLcBgHAKUaEcYN3ds9BYL4YTRdIQkV3zU3It2sCenQGsSjwT4hewz8K3Pbmo7E8Nobwnh+v14motT8ELlm5yCTecPsNHN/jG8nYSc/aYXUbm25shMmO+reaEtflqzKrTuo5egNR5Q9bwwKOutKu1Xs3EtxhCYTBpXsECgQZSw0awq79A10G5gm+zmRj7zX0se2FgrSvTHlkF7hAK6z9lfFf4le2npoZFghbRECl8QcliVTDe8kA++UQWXGsuLtRfCH4z/GHxtQGyzoGXX1t9pZaPUqjiPNrPtvWOReTgpzTfUmqP9pmqrwRFEnngZfJNoi1ffHRh+twL8Q6eJZckUZwTAJt+a+LqvHrSzIZ0wOOZr14vyspp6hUgTBs8GxgHaepbGjZOqAxmH/809ew5uOIr6lxsO+hQL3OILoVdkGNSJvC68AonSfhPJ+hbp5+VVbK2Ah0ObDVI/RgVQ9Z1KtUtwEix+AzGk7GsCLMuqfyALjeueBs4Ys+hUoBfUsZGCsxrX3RiUUDkQ7Gh3AsYY5eDiSe3v9dn4i8PfU6sHMdiEX4u7OvE403weWvFqwz8J07Pt0EcALgMMAYWJcaJkWXYBfhaF4bkKu3CR7RBxr+qXfnhJuzvLtFsHkgMK0tpL+Ukj11Pg1cnoy4KXDJFcRRg+XokCpvmYvc1th43HsMCQxk4MlF0479WrWAfg/Ts4KaZqgQ7BH9Sx3LRM2dxKUY8X3YGLRRJByKwCA16ICAHPtLmaWZgVFB+AvAM855mm+e86+Das+9gz4CiTa+wto9vTRC7Sp3sjKCAbDn3BkuEsmpA+kVhGKMXZTsbhst4n5Lsh1C982W4S5IDzVZi+FMjzmAAV1MGmHASWTSoZmDyMAge
 O7AB2IB0
 8/x68xn4xIaJgn79VAxupPqo4mCJmo7p2phogLuu69oADnBDczVYFQGEK1ichdYWXh5dMIrEr/XSfSAy1WhybFRzCv2aITBIOOLftXHj7k7MWONwD4QUx0cVVeAuCHdku/KkGm89X7xQrubfXBW/A56FflqNA8oC6VBT2PMdOZQpPQDx+pyyiOHFbnXbDMlfhHtGXAmVronnDlvI20r22dNAzVtTC85wxUeBYIl1fPKnhRc/C8sPTg6zo1+xfq04GFtVBCTNsB9FlMZi1NFfG6PUb/i+gO69ciJzZZrXliaXWvzZNFhrckfsyJUwHcqRhEUb8zYNTJr/gkQOETgvUWkKMwfU0gpWkNIOxPAAitjMr5PRYT5jiqkOIWzReCNMjPQ1TcZN1NDxdDlm6eUs4TrMPZPf6/pGBgVETgJsyo9v8bHcNIHq73r8HiUIV0JsntOOCIFmL68Cqz+blQyJ6Aa+q7EuvKdgajW9cPkKxFvEJtods1tsdo9E3Xg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 2, 2026 at 3:43=E2=80=AFPM Yafang Shao <laoar.shao@gmail.com> w=
rote:
>
> On Mon, Mar 2, 2026 at 2:58=E2=80=AFPM Barry Song <21cnbao@gmail.com> wro=
te:
> >
> > I assume latency is not a concern for a very rare
> > MGLRU on/off case. Do you require the switch to happen
> > with zero latency?
> > My main concern is the correctness of the code.
> >
> > Now the proposed patch is:
> >
> > +       bool lrugen_enabled =3D smp_load_acquire(&lruvec->lrugen.enable=
d);
> > +       bool lru_draining =3D smp_load_acquire(&lruvec->lrugen.draining=
);
> >
> > Then choose MGLRU or active/inactive LRU based on
> > those values.
> >
> > However, nothing prevents those values from changing
> > after they are read. Even within the shrink path,
> > they can still change.

Hi all,

> If these values are changed during reclaim, the currently running
> reclaimer will continue to operate with the old settings, while any
> new reclaimer processes will adopt the new values. This approach
> should prevent any immediate issues, but the primary risk of this
> lockless method is the potential for a user to rapidly toggle the
> MGLRU feature, particularly during an intermediate state.
>
> >
> > So I think we need an rwsem or something similar here =E2=80=94
> > a read lock for shrink and a write lock for on/off. The
> > write lock should happen very rarely.
>
> We can introduce a lock-based mechanism in v2.

I hope we don't need a lock here. Currently there is only a static
key, this patch is already adding more branches, a lock will make
things more complex and the shrinking path is quite performance
sensitive.

> >
> > To be honest, the on/off toggle is quite odd. If possible,
> > I=E2=80=99d prefer not to switch MGLRU or active/inactive
> > dynamically. Once it=E2=80=99s set up during system boot, it
> > should remain unchanged.
>
> While it is well-suited for Android environments, it is not viable for
> Kubernetes production servers, where rebooting is highly disruptive.
> This limitation is precisely why we need to introduce dynamic toggles.

I agree with Barry, the switch isn't supposed to be a knob to be
turned on/off frequently. And I think in the long term we should just
identify the workloads where MGLRU doesn't work well, and fix MGLRU.
Having two LRUs in the kernel is already very odd.

