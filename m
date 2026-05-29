Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23C43CD6E45
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 06:02:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 626596B0005; Fri, 29 May 2026 02:02:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D7C36B0088; Fri, 29 May 2026 02:02:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C6306B008A; Fri, 29 May 2026 02:02:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3AC766B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 02:02:25 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D69919B937
	for <linux-mm@kvack.org>; Fri, 29 May 2026 06:02:24 +0000 (UTC)
X-FDA: 84819412608.26.6A7AB6D
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf25.hostedemail.com (Postfix) with ESMTP id D86A5A000F
	for <linux-mm@kvack.org>; Fri, 29 May 2026 06:02:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=D26I0iOu;
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780034543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ysA2+2QmQlKEz3sLNPH5gm2mAt2kHzz+HEuuGXt7ID4=;
	b=JFyr1kqSoFXnsR/U9QgxxBr05l+HFOSaoG970MVLrHNV2DmFVgTZ1TuVNrr61euaL3kVh1
	FbbZvuGVtUyni9SUnLW2vZAKPk9zgxpJdYhmLgb00StKAtWyKECjXJCej/o5EOAAdlqLMc
	lGYxEG8ceypgrnc/qSe6UrwSA9vDaFk=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=D26I0iOu;
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1780034543; a=rsa-sha256;
	cv=pass;
	b=XwtHLqnTJHH8i0vlLlC0NBLnutmYQJD76eeEGFX/ZlA7UD3K66o7j1VV1jnYolTRe9ZGxo
	0YHQxWXOCKtH8Pzmse9F7hhkFxwvzjxCdlRwEztXeB3AA81jhuSoZ0Gc1QpkBIUi0kFdlw
	sIR1qOXHXIMF25o3j/epNMaJ41vMWxM=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-bd0209f25c1so2046363566b.2
        for <linux-mm@kvack.org>; Thu, 28 May 2026 23:02:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780034541; cv=none;
        d=google.com; s=arc-20240605;
        b=UPORp9UCgozIquBqnLZRAoH5AvJ1Y5f9jF2K3BJqpYt9Le80oJCECrMpbdwmGRJwi3
         M6umKGfPbKPa5hnIMYhKo0xMeesLYHDZ0VqWw1eR/CO38EMyaFuY5Rl/Lcs3zMhQCL3b
         8bRPqkyNcI2KoMS35izvmkU9SaxRmjBluI7AS0K2aPfzxmXNrsnv/Yi8B8XuY3r/Mi5M
         tHujFgTRVrPOjvUj7J7grb0jZwGXKutHfGXU+9JZkN7fOfZ7psuorr9N9wFLy19xpSy8
         lbMq/6j1D2P8ORdqX8IOtjoBTjBTks3VNsQXFgn5t/mdDulGFmHZex4dYPQWEH4yAw5+
         Edyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ysA2+2QmQlKEz3sLNPH5gm2mAt2kHzz+HEuuGXt7ID4=;
        fh=TnDzDe7FuiG/kwBpyDxKnol8NnzTpSi4+j4aTgiwmPM=;
        b=A/TYZCNRz9hv+c1cf0rrlo9fiDloUBr4qn2v64bA9pGe8EqyYL8INMrhcdZZHJaiUi
         qwxiRSo8PwOg4H0FGOL95UrpS0gqzW7Sm3QUyCpwHUM7UOxxIYbDz7XQ6ruTQBBu1OtN
         +b3dWxVnKbqDFHG4lEsE3knymZalMcefBWvzSgZyt3Z82jIlmqQ87Wc1oMq/GY1HLXzk
         0/iQ5d+FbXmhVYX2hjd50yWGd666AHmBVgexJ6a2xyzgyFg6HHGAMw0vHEKvBWAzPiow
         WvpepmkKfIjgNX8r80o0NLclcc217vAXWMUAvQQ4F0N9WwnyruJQrqjHdRpBqjUtcYVN
         f6yg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780034541; x=1780639341; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ysA2+2QmQlKEz3sLNPH5gm2mAt2kHzz+HEuuGXt7ID4=;
        b=D26I0iOu+vST6KWJMU8h1yCBZ3Oxry4hd1uKBAVf6qzlkAt5QyftO/vj8AhQceI/ea
         rzU7RMXn+ELY7pWQ3is9656nsHQyz4aHIo1hyOEmiCpyPSYT4BJErE6CzdYWLs5Mpfcl
         W4BTlhVexSaGBjVzHgoCKcbdoqEDCvotURF13Sgpb4Pm2Xj9zdxZIJo4JkOHc94piGhu
         YhwqojyBvGzvv04o3iEzk0mLggD1i59ZxIk+cscpqT4xJ1ws/zKpC4fWwnaIch220IYP
         ijfK86k9n9zPcLZF7ao6iUceCFMEsXCjNYbETbUCHOaL/pH7eL8s3zzN04aHOUaVa/fX
         lqUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780034541; x=1780639341;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ysA2+2QmQlKEz3sLNPH5gm2mAt2kHzz+HEuuGXt7ID4=;
        b=W7zDPQHC+0Ey2oCONuOr3Onm4jRs0Bc7k8dRU6WMrfXGiOji7rSowWU+IeZLBfDA2a
         oPla2+I8A7uBFUYhkB0nA6djryj/DZ+fJzP70Ne1qpOvgcxvDL67kPE+PVo2uZ8Pj5fr
         /1XfNHsPEjnA7smEJnQAFJKNO3MtspmgOqamd0tz6YsATDz/VTNRp5ezZ4spArjmO/qF
         s4iUzzdXL/oCPCnFUryIUa4Q03D/jr0rwxb5SXNHSlzjZJkpq+bh11Yhl2wk8tFjTk48
         CRQ9VZbtKt+EdFgvhZHITixhiyNhkM+bJXxqGKiNIn14wWNXVbl3aGXd7hpjcPJ5wbgr
         BgTg==
X-Gm-Message-State: AOJu0YxLRbJdy66iYsLM1J0U70InlMSLrhYcvWxyCEOCoyssrNGXRv+I
	RHnxOfjgLUMeTYeOIE540FqqlIqnSn2BVZgOE+Z33yOnh0EQfPPaXQpQVH8Q4Utce5wZbkTfqGC
	FZ0AsdbkycXpTPJG9oQcgTqH++VQZyhA=
X-Gm-Gg: Acq92OGjiW4k3jP3DGsAX9C3G0kyERD9iq1q9pmA8BWrLdBFUxexHOlTv7hHhAETFgB
	N3BN14k5bYkM9Iu+PkTNblKkjbmX6izuO/bpUbMqufbz+HnewniATTJQNHrju5iFe0MTXIByYkx
	VacUJjfJZgo0WdtQDwRmbL2KapkXHuSm33264MuQUQPLNk/R20R5tgpPUc1b72GjvpTu6ycbUc1
	Vw1bSuadUwLngs0vZB/dCw1CMpjWZJKw8bVEnb+XQxGYUfJ4Ye6mVF8VDrjev8FgoU4LlUzW7Bh
	9jRfCsurrXdIkI7g8NWUnTP7KRg9VK1JG62VgF9bQqWZwOY4NOw=
X-Received: by 2002:a17:906:f583:b0:bda:f14:43e2 with SMTP id
 a640c23a62f3a-be9cad0b1bemr60036366b.26.1780034540958; Thu, 28 May 2026
 23:02:20 -0700 (PDT)
MIME-Version: 1.0
References: <20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com>
 <20260428-mglru-reclaim-v7-3-02fabb92dc43@tencent.com> <ahkmMLW9zIyZJLN7@linux.dev>
In-Reply-To: <ahkmMLW9zIyZJLN7@linux.dev>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 29 May 2026 14:01:43 +0800
X-Gm-Features: AVHnY4LGf8Ne6BTatow6k7YOKy_uNXWOio_iTP69CJDuoNFTwMd-Yo4xIyRLJzM
Message-ID: <CAMgjq7DYAyu15Fn6k6A7bozonT+hrV6ZrXL3NTmg7T+DWPj7pA@mail.gmail.com>
Subject: Re: [PATCH v7 03/15] mm/mglru: relocate the LRU scan batch limit to callers
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>, 
	Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
	Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Kalesh Singh <kaleshsingh@google.com>, Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, 
	Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org, 
	Qi Zheng <qi.zheng@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D86A5A000F
X-Stat-Signature: uwwekz8u9jg5g9u6b3gz534a3y6r8ouc
X-HE-Tag: 1780034542-88449
X-HE-Meta: U2FsdGVkX19uqXcAYs6doGgpEEqK/oN9/7Z6LgZW9EN0j8vpFCxzPqyeHsQys+EiLMIg5nvdznzv7g+UIBD6AfbOqtqY2sd8i9iqKhLu6lVCMQFq1tjoqh3fbk0VSrRPondei1/EK4+6Wlzl5eNPzd1psAiBpAosukWXVu5bYEhgjLiLFRoUM5ddlvCkU/MsXCnfea5B6sl8eVRBw78Ndk3YHtV+K5XBeN/vJ/2lE3AGEoalErp7nkC0A1EPz54Hut9ks3hfPpARQ2Ips+22686b9LvvLnVHxNrI/kmTrbfnaNH+MFzRfg+13XLMnBBNulApjvPMqu3rIqn8HbU8IWKJxjLOb6DCE+NFqrMeSP3sJ0i8ME7rwX3zRu/BAE4VgwHjEHFi1AE+xpN0nzOhjYDRqVvJUFwo4fto/iSH/wRjyUrAtVx2qAAkldri7lHxXaWnkVXmYAylgyhos9JAd6w0EDcCYKYIDjx4dNJ/4WRRdXY+gFrsiAxE0uuSSyPY68QWDuq22Y2Mv+TAj0zl/yefk1sExo5+PCN/BNdfiftK7GEyEsYoYJs4HKqCaQKzXKsR1uKjM2xkYMooAmPygiX4btLojW2+BX0Ff2+k5aLioZ+pdHsUFOAep1+1SffZuVHH2vYhYOeXbUSpfBn/cytzCIHuYbtunD7rw/R5xvxYNM3nT0cl/MJ45/2XYKh1qc0ALSr3QjnOb5a4kJ70lfC1wSvs5nKKgC/3II2eZjWmrgPZEU0a5bb+R7FIkDxxu1wXT5eim8jC9MeTttmyfCX6W9Al/sY9YH5ji14RmAwB++BiWMmKL+IHthX+nWEfZ0y9Zaj9Q6jeI55n6tvvKkmGsR1SAQKvNxM06g/mGjyzD3u6L87m0XolAn+klvcyp3r/yQpfepWoXvxtlPMaT8PPHxQs8knunGjxVwqWcv3cijRqWYUAhnxQz20a3RbonY9HA7hWxTK089S8hpq
 tYHr0Hiy
 Mz4bldpintZN8i/NanTrwSYchfuxjYtcBjYEZILhPHUOxpxf43nl7NDzezpG6xVq5oHWoSPEdt6q2AYG8p/tfFz/tt8F88keyjjNhckQ0UZzmuq8G9f4kee/PG2A33oDC0FuRSXCYcDDzMbZaJzGnb4aEL4KLTbt7mKOKXamArtvT7qJJzgRDVql4aHCgRNfUgtXMarns8dJO2t0NrUU3BfCM8/nJ+/SJxAWNVW8l77YCu9DoD17D3GEsXMC5bxZS1Jf8W9fKyxT6VnXwykH/+Tvi+4PYeskiylDYe6NVbffPPXpywJ8rPw5bT6HfjJGf7QjlhGY8mzI0d9qo8xiLmVEnKp73GJJ66Xm/0YKcr3iaf6yTtwXVkSd9geAH4Y+QW+WkreImY3Zt05qXiKD6e9gPGQL+Ga4Rd8XvY8Es7Ui+q0Xk0NM4s61K+Ck2KvDJ5TIcL6/zb0FSTYkkf+FLpTEJbF6/lriv1351um+++VMm6hGo3AUIZ+YKCIGwmAVakiMvLdzEffAHq/BE9okzuVGmcpYxvP+DjMxtAZEjX8u89o/ZSD/NzYDVT6MTEuteaqxnGQ5gGyl90gywrz2XZMFRSG3pgjE6SGMJLnH3JV1CbDLbRWse7350pVIPOtMBPesjsaZSMtVuatiGLv7+y3GHNZMqWCvwkc9TcA4mUm9gFDU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 29, 2026 at 1:40=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Tue, Apr 28, 2026 at 02:06:54AM +0800, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > Same as active / inactive LRU, MGLRU isolates and scans folios in batch=
es.
> > The batch split is done hidden deep in the helper, which makes the code
> > harder to follow.  The helper's arguments are also confusing since call=
ers
> > usually request more folios than the batch size, so the helper almost
> > never processes the full requested amount.
> >
> > Move the batch splitting into the top loop to make it cleaner, there
> > should be no behavior change.
> >
> > Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
> > Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> > Reviewed-by: Barry Song <baohua@kernel.org>
> > Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  mm/vmscan.c | 16 +++++++++-------
> >  1 file changed, 9 insertions(+), 7 deletions(-)
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 7f011ff4c478..a011733a6392 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -4695,10 +4695,10 @@ static int scan_folios(unsigned long nr_to_scan=
, struct lruvec *lruvec,
> >       int scanned =3D 0;
> >       int isolated =3D 0;
> >       int skipped =3D 0;
> > -     int scan_batch =3D min(nr_to_scan, MAX_LRU_BATCH);
> > -     int remaining =3D scan_batch;
> > +     unsigned long remaining =3D nr_to_scan;
> >       struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> >
> > +     VM_WARN_ON_ONCE(nr_to_scan > MAX_LRU_BATCH);
>
> Do we really need a warning here? Also why are we limiting it to MAX_LRU_=
BATCH?
> For memcg/proactive reclaim, we can get larger number. What will break if=
 we
> remove this limitation?

Hi,
Isolating a large chunk of folios off the list is usually a bad idea,
livelock is one concern, besides, concurrent reclaimer won't see them
anymore, and LRU operations on them will be skipped (eg. roration).
Under heavy pressure, this could lead to premature OOM because some
reclaimers will see the LRU as empty. or accuracy loss.

There is a LRU isolate throttle for CLRU, which is missing for MGLRU,
so just being careful here, can be removed anytime, but I won't think
isolating more than MAX_LRU_BATCH for a single time will ever be a
good idea.

>
> Anyways, these questions are orthogonal to the patch, so:
>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

Thanks!

