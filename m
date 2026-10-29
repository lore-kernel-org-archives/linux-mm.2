Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8A1C606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 21:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cUxhcSPi
Received: by kanga.kvack.org (Postfix)
	id 02C696B05B7; Thu, 29 Oct 2026 17:03:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1EAE6B05B8; Thu, 29 Oct 2026 17:03:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0EDF6B05B9; Thu, 29 Oct 2026 17:03:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C073B6B05B7
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 17:03:04 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 151131204E0
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 21:03:04 +0000 (UTC)
X-FDA: 85376888688.17.6D00FB4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 208E94000E
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 21:03:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cUxhcSPi;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793307782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pFdMJCwen6N9JrBbr+moXA8rlsyaQPsNKoYeVLEHUfA=;
	b=rtoaycqNSTag+T3ywRGTFnanGI6aEPUnmbwqY1/UfWea6JteA0QqRIYt2QXx+K1f20W/Dd
	qEDIjJfrjOUQG1h1vRJsEjpP9WmIAay7v1shOgfquW7cWPKNwa4xzuC9nzO1HS+8vDmMl7
	hIBU2dHgSfSKNVpgVKjwSYc2abmanhU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793307782;
	b=5xzDjFQENvrmbd1avxNq4LX/WYeTEmE5L5IR6s6Z9M70hRufkjckIZT+RgzDvCApfFkB3o
	0F1SIM3V9NMbHp0dY0edf2pwU2DG5iMu/dVhdlJFOP6xATxJH6jrF9jKUc+/OCIz67XJl0
	VD8HDgSeXvyCT4aY5cfyh3T4rYHLddo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cUxhcSPi;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5625A444EA
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 21:03:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D72F1F01452
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 21:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793307781;
	bh=pFdMJCwen6N9JrBbr+moXA8rlsyaQPsNKoYeVLEHUfA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=cUxhcSPi/tITdJen6fvOKkVtsXBb2MCcrCpPnkgTOWvdakP0TbT0tYFgdo2A0VH9v
	 Hhev/qm82oNN/H428O0soZv6TAmZb5OkNu0eTQXCKwgciEzMkLgaeFq2H1hyC9HOEh
	 zjXUmVuo1pAa6yVNj0RkvexznWCRRO0SiIvY6Ss2TYPlutNrh96KrtdOzQ2o2PjiGU
	 kWQ8BmBGS80kgIVrug2jckdtW6b1a3J1pwBoVZKEmZPgY0yU9zbR/XyzRYFthrnA6l
	 DAFHNiyHUJgM0MAvCAqnQ8p4U5hLyvOV0QXmsGvGy1Z2sYlop4zOl0rcwzYd1Nlx0J
	 oXfMA5s5v6bKw==
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-93e4c00d71aso230746385a.3
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:03:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxP6Zg3Rqd1CtX84uNnOBhBX8rh9Wecan4QHyKoJpRltB6EO5T9zTYgpX0I0G69WO0buGMf5Wf1BQ==@kvack.org
X-Gm-Message-State: AFq9FYK8UKvQn2oXRTrWRAoxO1tc8Q7USd1QR9A/1XzE7e7P1tWYwoB/
	nK8g5D/xBn8CDQ4qBLzjzg58h9m+0tF9Arp+dtif9Zjhvh25m+TzQuHPub4dNzckW2eG6GL+hIM
	bX99liELZACOZaFoZ6VYnOpcDbvfw7CE=
X-Received: by 2002:a05:620a:439f:b0:939:b099:d52f with SMTP id
 af79cd13be357-9442171b930mr72138385a.20.1793307780343; Thu, 29 Oct 2026
 14:03:00 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261028010611.3929937-1-tjmercier@google.com>
 <20261028010611.3929937-3-tjmercier@google.com> <auHMXBwnwuRwHLmo@KASONG-MC4>
 <CAGsJ_4zuGRjH+=1JxH4BYEC-vJumKjkhXPse0jW_nKEzQXXVmg@mail.gmail.com> <CABdmKX1PvZjnJkqD48_Pb64Je_oZVO3F-oaxMsBYzHmY-GjbDQ@mail.gmail.com>
In-Reply-To: <CABdmKX1PvZjnJkqD48_Pb64Je_oZVO3F-oaxMsBYzHmY-GjbDQ@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Fri, 30 Oct 2026 05:02:49 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xggGnAhguPkCJ5k08v3QYKUv07_MhF-acXdBczMAEpdA@mail.gmail.com>
X-Gm-Features: AclHuK9dc7QMnH9xT-OkQ4nOME9fLgwIUxGnHM4PmofBeJVL-x30ExOe2tYWoAE
Message-ID: <CAGsJ_4xggGnAhguPkCJ5k08v3QYKUv07_MhF-acXdBczMAEpdA@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm/mglru: stop rotating offlined memcgs to the old generation
To: "T.J. Mercier" <tjmercier@google.com>
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
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 208E94000E
X-Stat-Signature: i6fdwqwug1nuk99wknxofwec5ipm3nb9
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793307781-566620
X-HE-Meta: U2FsdGVkX18j+a0iQqZdGDKLQojclamUIB+W2ecLw5E+/qbwQKYmmI6NJJonGFt5dmKYQuwQXBRmq2SYLuHEXrcMNa6xym9tU+2V6WYZb8wOU9G6CBer2JAGLb3Na9hN8lgQioa6hMDpVqKnk9q7r9Ri1BHjKRKgVEdZ6nbuHtziiPcoK/9f0YcZKLAAYYpfWPZ8OvONakZnllHL4W5nzdmHSiwR5t6Ux0dkmvVJFN+Af0vVzutlPQt9SrvtOAms/keD0Lhv4GTConovs+SBVUNYoNatxnny/OGa+szPLBhbhoBp8PhzGtzRLSk5JybA6lPQdsgusQKSaQ7j0Od9SUn3mLWRoXP+ohtfTo4hUfsiIAg4JByz0S65LF29tXV6PrCh/qDelkoLAmwmErChfDeq3wSza4mgt+6sCvfpLVuWEemHueclrj3O5/FbE+jNAcQJPsv0yfNakIVsn1V52p44RqWejd8r7P8hEbsqQQT1l0zJAau/GBU+Y1VtuON4w1sPDcIlDvgk52BJ0x9+Uh62+kXqt8C8bMpfCmQKxtN/w1TAE86XLLSDWS5C72dfd1Xe0v9+QLVP5gbUn6NhBaIDVI28pnV+Iv3aJSOUj8IN2J5j4Zymd+WSsKjXWaISRxXmtFqturLYBZc3Cx22kh37QLl7joi5hwxKzlUSq0voS1w2gH4zNiuHvQJpmQ8E87EKFF/xv6RHIWhKKETYcxXTcI5MF3RwS9kQjILgxi1+/0SsaMC0CbeSkmIQACORKQ2jm7eP72XKl5rO3UrEhgVE5OwUQJZI9llQdZvIdqvYq9e5b6XXWw+mOj16pQkmxo4RZmTjEFwKrcmbC6H0a1XjbucwzPrDmGqi63PzEOb5hxvyf+SJvvfcs/PUaxJHbmgLy3ZSG1/NQRp1uxEi+NexWun3zBruIB89pC9XIkcJnarDTHJ9m/ZFd0n5kRaW+FLzgT8WNVkuFThOSs8
 Nu2/YwxU
 QfkOJX3FmCp8Ns8hom3EPz7oWTq1N1qKlqp/pqk4tGXWLKa5s7d3SkbTG5B+Q0CM7A0th0LsqyFuK3DQG2VOaiPOFDtuei2sKr3y/lYRgoqQRo47pwggCwQ7TKGJ4ntrhqO6L+kiwc3Rrgkau5PyqkHqyrO7WazjPmd77GCSEPo5wNvqSlAX8sciwcAvqu/qYCPHVeIhpnTlfdMMv6WDPijBN1A0BiE6TtplVlRvpvxG6v02Fhfyid1c1Ts+5QnPaRNRYvg1YNyTdFOdNk40L5KW9HRvZ4Sn++wocb5oxepau/JJsFYHX6alNGIg+CzmlXFNX3O7XMwOPiQ3wssnquZ8+sp1U8e36s1hekcrNU1OPRaw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 5:22=E2=80=AFAM T.J. Mercier <tjmercier@google.com>=
 wrote:
[...]
> > > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > > index 636152d8c94d..45a2c1021f4f 100644
> > > > --- a/mm/vmscan.c
> > > > +++ b/mm/vmscan.c
> > > > @@ -4538,7 +4538,6 @@ bool lru_gen_look_around(struct page_vma_mapp=
ed_walk *pvmw, unsigned int nr)
> > > >  enum {
> > > >       MEMCG_LRU_NOP,
> > > >       MEMCG_LRU_TAIL,
> > > > -     MEMCG_LRU_OLD,
> > > >       MEMCG_LRU_YOUNG,
> > > >  };
> > >
> > > I think there could be other usage of this LRU_OLD macro, but indeed
> > > offline is the only user currently, removing it is cleaner.
> >
> > I'm imagining an Android use case where, after LMKD or similar
> > userspace killers implemented by various OEMs kill an application,
> > we may want to prioritize reclaiming its memory by making it more
> > likely to be scanned and reclaimed, while the killed application's
> > memcg still exists - not offlined.
>
> I think it's an idea worth investigating. I had a similar idea which
> is proactive instead of depending on reclaim hints. The code is behind
> a currently inactive flag - it runs memory.reclaim on an application
> cgroup before offlining it (so no zombie or reparenting), but I
> haven't had time to properly test it yet.
> https://cs.android.com/android/platform/superproject/+/android-latest-rel=
ease:system/core/libprocessgroup/include_platform/processgroup/processgroup=
_platform.h;drc=3D2ed7b05ab42dd67391ad2819b0ee399d89128ead;l=3D33-34

Thanks! I know Minchan Kim has explored something
similar: releasing exclusive file memory when processes exit:
https://lore.kernel.org/linux-mm/20260421230239.172582-1-minchan@kernel.org=
/

The idea probably wasn't well received because Android
workloads are quite different from typical server and desktop
workloads.

The fundamental assumption is that a killed app is unlikely
to be restarted shortly, so its memory is expected to lose
recency. In practice, this is usually true.

There are some exceptions, though. Some badly behaved apps
have monitors that keep restarting them whenever they are
killed. We might regress these cases by reclaiming their
memory, only for them to restart immediately and have to
read the data back from storage.

That said, this may not be common among apps on Google
Play.

>
> > Similarly, a foreground application might benefit from a lower
> > chance of being scanned and reclaimed. This suggests that Android
> > background-to-foreground transitions, or LMKD itself, could
> > potentially leverage the reordering of memcg LRUs.
>
> We are planning to use memory.low/min for foreground protection.

Thanks! I guess the challenge is figuring out what value
works best for different apps. Should we collect data in the
lab, learn the appropriate value dynamically on the device,
or simply hardcode a relatively large value?

Any thoughts on this?

Best,
Barry

