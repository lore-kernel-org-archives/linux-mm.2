Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B8EE606F232
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 17:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=AXenOrQH
Received: by kanga.kvack.org (Postfix)
	id 6F2516B05B8; Mon,  2 Nov 2026 12:35:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A4186B05B9; Mon,  2 Nov 2026 12:35:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5930E6B05BA; Mon,  2 Nov 2026 12:35:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 30F356B05B8
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:35:16 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AE6B11C0A05
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 17:35:15 +0000 (UTC)
X-FDA: 85390880190.21.DD98901
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf19.hostedemail.com (Postfix) with ESMTP id BEFD61A0006
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 17:35:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=AXenOrQH;
	spf=pass (imf19.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793640913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VnBhs1QNRjF1grEs77jlwblGRfEeujN01d/Qt9621rs=;
	b=dMX/VyZnk3JC41dYukC5xD1R12OkHWzf2zaBLQtla4QWqVb+MAwe1dPGjtMx6PwFEQtRz8
	4bHH6KdM36iINOE66oD+20rnCqySDWs4vhU19bfqM1xABnGirA+H7B1O0u2D43j2WdfAFL
	MNu7k4UKJPpLFtYU6xOp9huHeWaLAxA=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793640913;
	b=TryAO7W5xyaInZ4Ztr4kDOBfxGzjar47GrFH+/3kv18VznQSF+cZ3+pEReIcXSFTEUcqPT
	5xkDZrnfxbudl0FJRSjS+GAIssxCZ/X5599ALxrBOcu3Ou8+1ujrwgCbjfncaN98vyPcEh
	gD88P3dGWSEsClZ5+2vSB7v3cCacQgc=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=AXenOrQH;
	spf=pass (imf19.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a018493d57so113275e9.0
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 09:35:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793640912; cv=none;
        d=google.com; s=arc-20260327;
        b=KDVQhF1xQsL1hK4rnodGpn1tMksPJhON5Fy7ayhjLCADkY3PfI3lLIfuU2aQ3Bd8hQ
         H9JCWQALflEZv99gOTiX4p0uJZizr2p5tWSywK9wy5kgFUJzE/sxLiuY/Rxo+5vdiNeK
         lvAs/6kQQhS5yG6ugWTn5WRdAeRmQka23GGJ9pqcODydXEDK6vLaMZ10Ag33qKBMLn5b
         3Lo4HTXTDyyAN5gxo49VykpLUFinZ7jY9vDkUzdPZJuvqQHz87SOnRr6vsR8sEbykz/S
         K1mE5Qk5GzVK7TxmtYenUb56+bowak0fGAJHHLirkmrvigSjHd1Y4F8C1RaoofKxmnuE
         LNcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VnBhs1QNRjF1grEs77jlwblGRfEeujN01d/Qt9621rs=;
        fh=K8BppXKSu7K63ThmZrknMY1wrRakRdaAyWuSnaN78Os=;
        b=VxejPZYzFJv0RJC8Bw7Tb88K1uEkL43AP2CAuOmVfztncEESVjb1Fx55p8cOHBUMtD
         74pq6hWYZK43PiMgYJfkCnoPMHhaTPfv0HHhGdo4BxovZyDlR3zBpuRJpvxCe3CfD/4V
         6vuzmNZSjjZvR/eyxxeIgvBpH9bcUYHSNKaFeIusvsRbzJ5ETzH/YggvAaosbt2cWudf
         amTiTtndtkTCWGBJoYkf9q9nCOlHfgzy0Y6aJAqLkz0tD2MdHJakMqjLqEuElq/X3QTz
         gh5E24xtMZ3TNsk1ja1fKpJHedZN6xBXxWpAo9fwoodh0MEOb/MwQeyoGVFEKUx/F55D
         RSIQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793640912; x=1794245712; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VnBhs1QNRjF1grEs77jlwblGRfEeujN01d/Qt9621rs=;
        b=AXenOrQHEzHXRR4pu2/sNs1iwfAlxropBzUcgiV95SgEd8COSbTJVMnj7byTqLo97e
         h4fN8cBoq0LjIrZjyNecp14qzC5V9D0Vc3OdZCEl29rtRwzgg7F/n6/u0bD+eQWb32m8
         P3rk/lrVUvU/h+W+hX1BXDBqE6IFBnuGL67Zf7ARDoiI5imZbIEytYMKzNn2AL7En4C8
         iAJV19Vv9Nh5M9s9X4eZARnscgLDRUkmcCPnc79+FsWFtmJfHe43oIdGlL2hzZbyWjQ1
         +IQXk/h0VyG2n23bMD+Z9fbMehA1C+hLvWq6eXLUY36yMV83biVbxLaS+n5uitQgXVq1
         D1ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793640912; x=1794245712;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VnBhs1QNRjF1grEs77jlwblGRfEeujN01d/Qt9621rs=;
        b=uMwQZcJqW5fIOTZxQg545mQa2Gxnc5vJaPjrVRV6ZMXV/aEh0THHAYFCTZ9hCFxFgd
         osk/t4gbh0yNn+ccR+xMs4z5e2b1XlcL1pnbqvo0GauLWQgFatjQkNhqbKPbv/d74gPE
         leV1iDqvwqx0CAICAbiYSS1LcZPIY76FJ1+f0tQi5s1a97qTMQsjsqasUyECI8Bmu4ax
         FXkidTAdmBN464yV9aE/dGgZoE6KY0r50TFcMb5Jy0wLrIxJIi3EE0hnKxiRfD09MrAq
         F6uoq/C84+vwHkzh7Vi1FCMF5dVXqalcPdZqqrtcb9UqysUhwl/YdDUckPRPuWog26Hy
         SuZA==
X-Forwarded-Encrypted: i=1; AKwUvBxDU4tA7dgx5fcv2HDY8RISTeTQDYHCJkM3YS8jZfaS6rjj/EMFEQtvO+HOps0scqxf3Tn9pcZJIw==@kvack.org
X-Gm-Message-State: AFq9FYLdSngJRaeHx8gAKU3nln8nAAXK/LG30pC8hgLPRNOq5PChVuC1
	UjvC+AVWHCB82fjpJoS6BbzA0h+zhNd/sGu9K/jbKZpOywaiJzDjwBIijbEC3+Hn6/r7QqWPsfd
	EEiQkJHFNDgcVqpR1MvSRnIReMTOIcKlJPPcZxmRl
X-Gm-Gg: AYBFou0BDoSdJlyDTSbOnnFo9uin8nkiB4pTpXrCrxolcDPAjCI717jRWvXMrbk4Up0
	t2eXZ0PvNeJ4dq/TD9RnvKAKo/cx8xbMtX/hI8Uh3a0lXW7I0hr50GZHGevQTsuc9Wl0TtGTV7M
	RbX86/WfT+dfKpoT4grjo795bk990SijOase2q0hHnc/CQEV8irwX52tWkpYCqCS+ubOc62puF+
	5jaFETEs/wSmuzzRzd9elNLY5biRuceY6dH8KNtGdEviRgJS8CVZw4hqMRG/hIcfWQ3q1IT0PrN
	B1eccNG3kM7Ec8DElYHgy9yZVvDr+y2pc2QGceEtKMKtr40RLE+JEPxOe4HCQmvuAPiML6+xYTH
	6cURpyxlDcc111ql9EnIKP1UW/E5TdhyaUksdWObHCVcKaqgU+2GxfbFNh3L6pQlnix7QyQzRbJ
	yL9ahr9P/1HBFkUyB0izagFVO5U74632Iz91DigiGE+ads
X-Received: by 2002:a05:600d:8:b0:4a1:e728:2915 with SMTP id
 5b1f17b1804b1-4abf8764faemr3392105e9.9.1793640911875; Mon, 02 Nov 2026
 09:35:11 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261028010611.3929937-1-tjmercier@google.com>
 <20261028010611.3929937-3-tjmercier@google.com> <auHMXBwnwuRwHLmo@KASONG-MC4>
 <CAGsJ_4zuGRjH+=1JxH4BYEC-vJumKjkhXPse0jW_nKEzQXXVmg@mail.gmail.com>
 <CABdmKX1PvZjnJkqD48_Pb64Je_oZVO3F-oaxMsBYzHmY-GjbDQ@mail.gmail.com> <CAGsJ_4xggGnAhguPkCJ5k08v3QYKUv07_MhF-acXdBczMAEpdA@mail.gmail.com>
In-Reply-To: <CAGsJ_4xggGnAhguPkCJ5k08v3QYKUv07_MhF-acXdBczMAEpdA@mail.gmail.com>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Mon, 2 Nov 2026 09:34:59 -0800
X-Gm-Features: AclHuK8o-leCSnae7wNuTxaZ91TaEx6wKMCDX7_41RuiJN7yC-g4TVBlixhIwdY
Message-ID: <CABdmKX17z8146_dTxMuBT5_rKtdvGGHdYvgNg-7eSqobEaCyqg@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm/mglru: stop rotating offlined memcgs to the old generation
To: Barry Song <baohua@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: bpix7wbacaed7edmx7kbcfnoa5zt9rn9
X-Rspamd-Queue-Id: BEFD61A0006
X-Rspam-User: 
X-HE-Tag: 1793640913-427264
X-HE-Meta: U2FsdGVkX19GiBaqkXxc0d17B1dDFLifrOHEDTWmH6QEbCm1nXYEfusuJ9Fyprncdw1P58m+gIqDMSmpTxjBWMgRFh0sMQQnsnreR04PNvl3flX3cQ8k/Y+9m87YVIkC+LXC5ZENUMoDe9meA56n8fB5nBdw2uIZyNz0P2HYdq51GY9MolWcYBRlGPAaP4+M7cp4sTg5NdAVS6PsU3dOu4rrybt5pBihk3z/msl06jqnO7NbOPQb7R0Tw6dKl79+LQYJM+KT90DZK72FP48JfhqS+Ll5San9eEntZGy3t90gKB8/MmZv7dBPS6Fu22DP2i6wSmZ4ymjZM5J8yyKif3OtHVMT2bMB0/PaM8YPmWxqctPhzFXCKUWTv2WrhnOlIBIkEeAYMjbE/O2XpNoftc+O4YvldoNJNIauqkUMxxbNwTQ34LR9sC7toYhd2pqG9WJJ3QpevLgxD/H/5Tg54FqLaat3T37HZyFzIBN9vraxV8i/JMDq3pQHi+5LORLWxRQiNAMEywl1ri2cSmr0H0N704PuQkzvi42K6tEtk3+7V6KiADYThuObjSylb/nJlwCXCn3d6kqPkNarQ44YN5k/979ZhDaKKjqDJ7mygSQbBgQdIKUwhNVwFIlkV/Ts2OibXHbSsSuj1Y5O/zB6JilzCE2QzTJErJjQ9agp9qsK7DCuX9dUArW+fHuampOxNxZDgkjoa0vntr3p19YPyKVNEsBsrqZuRynWLy5KZ2sk+VsiHVpgQUEviOF30vZTbEIIKJyISn3zkkeksn8GnlYAsou5CVovFn29GuXnERs5y3mLqJGRYgwWPqy1VRlMPpNTsikxM1veLy6NhDoAIodpu2NVTgjAc3sFfIQe4/3SSsV8qB4AFhH+AN4ihI6hHlAuGY1Or9eRscRnM856i3gD35Dl4bJB+jiZogdnYJRI5T8jN+YyV2bugJEGWCiDGo7YQKCSl/Qjcu18/Fu
 KDgczdCj
 +ennpsMSK0apt75t+xzS6Gm/fv+EIH3BkBHYoH9eruyS/+H3tRrJK6PuS3HrQUTD7tCT1juIsSQv97v7LPtlnangKhMvZeoMophTOwOLjlLZJzGDLT4qoIKR0UUTpamF+nge1G8SQnTJGZ4ns2Bw58gU9uguqpEyk3wRlBzvDZqxJzCnJynXQiVZRt2EGMuVQlJS4I9dD65pwr+DwvCYhS4Y0ws4nhCfFB8XCmMD2IVgbC3FiUC9itDp/625v+V9R9qVUTCbFLVYrZXyNlajEEb0M0NQmAtCTU8te9TcvUE30MabV2dpoH9Ahaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 2:03=E2=80=AFPM Barry Song <baohua@kernel.org> wrot=
e:
>
> On Thu, Oct 29, 2026 at 5:22=E2=80=AFAM T.J. Mercier <tjmercier@google.co=
m> wrote:
> [...]
> > > > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > > > index 636152d8c94d..45a2c1021f4f 100644
> > > > > --- a/mm/vmscan.c
> > > > > +++ b/mm/vmscan.c
> > > > > @@ -4538,7 +4538,6 @@ bool lru_gen_look_around(struct page_vma_ma=
pped_walk *pvmw, unsigned int nr)
> > > > >  enum {
> > > > >       MEMCG_LRU_NOP,
> > > > >       MEMCG_LRU_TAIL,
> > > > > -     MEMCG_LRU_OLD,
> > > > >       MEMCG_LRU_YOUNG,
> > > > >  };
> > > >
> > > > I think there could be other usage of this LRU_OLD macro, but indee=
d
> > > > offline is the only user currently, removing it is cleaner.
> > >
> > > I'm imagining an Android use case where, after LMKD or similar
> > > userspace killers implemented by various OEMs kill an application,
> > > we may want to prioritize reclaiming its memory by making it more
> > > likely to be scanned and reclaimed, while the killed application's
> > > memcg still exists - not offlined.
> >
> > I think it's an idea worth investigating. I had a similar idea which
> > is proactive instead of depending on reclaim hints. The code is behind
> > a currently inactive flag - it runs memory.reclaim on an application
> > cgroup before offlining it (so no zombie or reparenting), but I
> > haven't had time to properly test it yet.
> > https://cs.android.com/android/platform/superproject/+/android-latest-r=
elease:system/core/libprocessgroup/include_platform/processgroup/processgro=
up_platform.h;drc=3D2ed7b05ab42dd67391ad2819b0ee399d89128ead;l=3D33-34
>
> Thanks! I know Minchan Kim has explored something
> similar: releasing exclusive file memory when processes exit:
> https://lore.kernel.org/linux-mm/20260421230239.172582-1-minchan@kernel.o=
rg/
>
> The idea probably wasn't well received because Android
> workloads are quite different from typical server and desktop
> workloads.
>
> The fundamental assumption is that a killed app is unlikely
> to be restarted shortly, so its memory is expected to lose
> recency. In practice, this is usually true.
>
> There are some exceptions, though. Some badly behaved apps
> have monitors that keep restarting them whenever they are
> killed. We might regress these cases by reclaiming their
> memory, only for them to restart immediately and have to
> read the data back from storage.

That's just abuse and I do not care about restart costs in that case.
I was made aware of one of the strategies apps use for this in 2022
and closed it by freezing the app cgroup before killing with:
https://cs.android.com/android/_/android/platform/frameworks/base/+/79825c6=
f2f8b46808e4b431fe52b3be78f1e8ac8

However there are also cases where apps are restarted by system or
vendor components after kills (quicksearchbox comes to mind) and I
don't think we'd want to zap all that memory proactively. Arguably
they shouldn't even be killed in the first place, but if they leak
that'd be a problem.

> That said, this may not be common among apps on Google
> Play.
>
> >
> > > Similarly, a foreground application might benefit from a lower
> > > chance of being scanned and reclaimed. This suggests that Android
> > > background-to-foreground transitions, or LMKD itself, could
> > > potentially leverage the reordering of memcg LRUs.
> >
> > We are planning to use memory.low/min for foreground protection.
>
> Thanks! I guess the challenge is figuring out what value
> works best for different apps. Should we collect data in the
> lab, learn the appropriate value dynamically on the device,
> or simply hardcode a relatively large value?
>
> Any thoughts on this?

Yeah per-app profiling doesn't really scale to millions of apps. I
think our approach for foreground apps will probably be to use a
large-ish memory.low value that is scaled by total device memory. For
system services we're experimenting with service-specific values
closer to their actual working sets since there's a limited number of
them and we control the code. Even there I think some scaling with
device memory will still be required, since more RAM and heavier
device use mean more state for system services to manage.

