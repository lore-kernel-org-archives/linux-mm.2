Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57201FF885E
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 08:35:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 542466B0005; Sun, 26 Apr 2026 04:35:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F38D6B008A; Sun, 26 Apr 2026 04:35:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4096A6B008C; Sun, 26 Apr 2026 04:35:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2B5756B0005
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 04:35:06 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9F068C1BFE
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 08:35:05 +0000 (UTC)
X-FDA: 84700046970.30.12E01DB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 90E93140004
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 08:35:03 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="YDMFyZZ/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777192503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hsmcK1ZqcBUFaWtRiDoLbdAS5LLO3iYDMpiHJ4ojWz8=;
	b=DVHqzq1SsA8mW/BnAOHakqppdYJ677ZxnUHoIpu+rCMRTbzLZFZLbXmjKSIeUC99HwxEhW
	ln+fqLZ25xOB+QsJPUCPY8A1Q5ty38CHDoLw5MrmkTM9dLuCfFvl/4FpoHLzR/2DAD/mi/
	Enaw0lR7WurMcHivpCTszNltmjij5fA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777192503; a=rsa-sha256;
	cv=none;
	b=8pKAOQMYh+/+nBo5VZF/jivSXLcVqvnYX3QQEUjpNTpgJFDp6TMooU7a2xZYE2NvdT+m5G
	SgqLeY8y7EnE9519m86kVlhaLgFI1YLF8Po+aFo56cVY7+G1nNiPbSz7VVUzyqoYr5eycn
	SrGguZKd3WJ1jwvhx1CqicK/VAzq75g=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="YDMFyZZ/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 31AE044599
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 08:35:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13DC0C2BCC4
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 08:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777192502;
	bh=xVeg6cLID+JhfPIApIaGZEe0CDr+S3A/xz1jf46aA6I=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=YDMFyZZ/nBXgIduDufs+Z6FawaVk1j4/S+FgcYg6nF8TRe9ffr1+vUl1b8KiLH3rV
	 Szr3lqqQUaSo+sG3gLWieMb6DDRcVAJNgaptgVaTrYSIOAS2k4NGhU/XEVTFAQVRL+
	 kqAHwSArjbNCiOuHKRXtOF/mMcE5aixaO9CkLEd05/48tIAH9ufeAriKpves7y0e2D
	 TpHA+6ATcBhn1HDHhxLxcaLlfxSS+S0UJ9p/enZdAk+ckNfFgV3QPlO2Vp86JwOrA3
	 JItZjWrr9R0FDhyxxpbjAiBST4Pj+9KTxpvbfVh7EVAQSJHkrtUbFTumvS8UkxKw4Y
	 oZ2SRuJMdAm7Q==
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8a151012558so101376946d6.3
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 01:35:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+eWAqgXzC6WbGbvPrMnCCQoIzmbSocfFefgQF5JPk+fjgSxYUff8/7KvUy/RqNuagl/7u8pSi6GQ==@kvack.org
X-Gm-Message-State: AOJu0YzblCxGzwFxaHhyJcB2/kP+0EwxfawAPORLQh9ID1wrDb64zyYr
	cGEDNRTn1Nyea1Jgwyi+sa5aKS+HBo6OR15Sisl7UdCgOjMnMiYuENJqXBEvCarJZU32zO/RknD
	JtBzedMqtrnu1MeN985XVS27+3Lul1hc=
X-Received: by 2002:a05:6214:459c:b0:8ac:74d7:dd17 with SMTP id
 6a1803df08f44-8b02817761bmr572254846d6.50.1777192501064; Sun, 26 Apr 2026
 01:35:01 -0700 (PDT)
MIME-Version: 1.0
References: <CAMgjq7DM6Sd5EYx=PLtYHBYk6gAPFupYg2a7nib2KrGBO=HtGw@mail.gmail.com>
 <20260425205759.1701-1-baohua@kernel.org> <CAMgjq7ADH89OVheesAPBUCK11pYmje4rXTLkxRW2nAw+8r54Jg@mail.gmail.com>
In-Reply-To: <CAMgjq7ADH89OVheesAPBUCK11pYmje4rXTLkxRW2nAw+8r54Jg@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Sun, 26 Apr 2026 16:34:49 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zjdOYEtuO6gNjABm7NDxW0skzBFNRNee-k2D6VwsYEQA@mail.gmail.com>
X-Gm-Features: AQROBzCncax3okfyoHUgr0JCLB1FEjZXTYLMU2M6YWS1_NV1STJmGWtKknJHQss
Message-ID: <CAGsJ_4zjdOYEtuO6gNjABm7NDxW0skzBFNRNee-k2D6VwsYEQA@mail.gmail.com>
Subject: Re: [PATCH v6 00/14] mm/mglru: improve reclaim loop and dirty folio handling
To: Kairui Song <ryncsn@gmail.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, 
	baolin.wang@linux.alibaba.com, chenridong@huaweicloud.com, chrisl@kernel.org, 
	david@kernel.org, hannes@cmpxchg.org, kaleshsingh@google.com, 
	laoar.shao@gmail.com, lenohou@gmail.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, ljs@kernel.org, mhocko@kernel.org, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, stevensd@google.com, surenb@google.com, 
	vernon2gm@gmail.com, wangzicheng@honor.com, weixugc@google.com, 
	yuanchu@google.com, yuzhao@google.com, zhengqi.arch@bytedance.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 90E93140004
X-Stat-Signature: 4n9npxio9atbugh81k1froawmaqcnn39
X-Rspam-User: 
X-HE-Tag: 1777192503-664717
X-HE-Meta: U2FsdGVkX19xVqYJXsgYoXZ4ntqYsY9mADEvSMt2hKgLFHK6ULeC2BeYLpGDFC5U0fuoAWakZn/fEyoKsXjzOQfjOgBNOlw65q008kpYPUWpuS4T2DtlUzz7zhw7s9dAE3jCOz4MHFwcAbSN7GszhXtaU9ZsDNzllwR7j8RJrY3VzGImxfC8Z1cmWW785Y0AxVtcxn9jAEvE/H4WAMG+byqL3WkqHc0GvCYf8HLVRi5P8fobXxDjWbJb6FiGNbEF8g6KJllYRHv+lGByX9ecSTkmYEFCAnqUI/ciU+LXe6NnbH6L4Bn/XzZzhm+8WgOD3Vcr3/+ISg+oRQNy4ungYRLemSDVp7qdz0mwlwErPfZpMDhlILeDdi0z0NAjneetLH1qsJFNwUS9zVtrOMc+a3li0S9dS1N+Cy1cguPJTklmHUQd8thn6DJ3rsuO/5/dVVfkLKvMizmyZrgpbK9PHj6XXzQDSARF9Xg4hzJkbmoa+v2+rpXPBpzLz/fekbS2WAU9UyF9GrBL0Y2eZe8bwZjeSG5C8B9JUMRt5XznBox5gsylSdS+mE6AHeTig5KWh6Esg3Pa8EwLdHKEl9dUF4CfxGd/LiQwgqFOIJvVhOWTWOATqqDLH8Jb3X6UptYE7MqwHvgBhth9D5PUhm6cBbkP2KDQCn5Vf7vnkmK/wZWJ+IoaTVdDqbfdNNk9PMXIu2W/afjI1nfS7W/no2YOmkqAIj5joPmE1hVIXh7qA2o3TZnuwDsinwyxI8KUEdEiLPoLrhljokFqmpZvptPAD3aKfX15vRMMKD1DD/wVWCBRpWkdDXhhMNvBARnCtMFygWl4Zfs8xqx8A8ZceMRrTl7ZN80beG7p4AnThto1E4ZWkcsrWfh5Rt5NB/3f4ebpoZ5aqWT+gEKVPwnzwjj/a7GkIqmXN8ZGJq/XPCt6/q1HC0HAJ3r+iFNV+/I4awBP9Xylij9iyqiaawpAikp
 oGIz5NG9
 0n19ABbVYtRf8DrmLnaKeqLrTaxvbmM0DRbBvF3ln9G1ggFrq/zLWQeSRSpFLigZSReHCKtjg4qykf7UXIZKU4qVS9m/dVQkPrwD0qEqypV8vdN6dONg5TlgD/DyAuCsJwzcqHsRbDzt7NMC1l4UOrQkwMq45j0CZIBy4FgkledXt113JCgH5y36LUX7XBpbKGwPLna6vms9Lf4AUUWk6YzM34q9XOmtTJmma4bChXpLDwmnzKrVyVNK+jDrvlFU7F6Iejln4+Es5jiY4UVLDY2BIEXTO9DKP/Dy2TTIOajN+I4iALKpUiNFudnp1mQsVtJPYZlJMTZWHhdksZtcysE2AqzzO1k0JfFafGTnK/Y0IY1jJje+e2mQHoFDMVYj3a1pcu6aVXufE6x8nRYZk81oA0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Apr 26, 2026 at 2:59=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Sun, Apr 26, 2026 at 4:58=E2=80=AFAM Barry Song (Xiaomi) <baohua@kerne=
l.org> wrote:
> >
> > On Sat, Apr 25, 2026 at 9:30=E2=80=AFPM Kairui Song <ryncsn@gmail.com> =
wrote:
> > [...]
> > >
> > > I just ran a matrix of for kernels (mainline, mm-new HEAD, before thi=
s
> > > series, after this series) X 3 different memcg configs (-j96 3G, -j48
> > > 2G, -j24 1G), and none of these showed any regression but all
> > > improvement. That's really odd.
> > >
> > > One possibility is that I removed the:
> > >
> > > if (evictable_min_seq(lrugen->min_seq, swappiness) + MIN_NR_GENS >
> > > lrugen->max_seq)
> > >     scanned =3D 0;
> > >
> > > Which will make the reclaim loop go further and trigger aging.
> > > Previously if reclaim drained the LRU's cold gens, it may go reclaim
> > > slab instead. So idle inodes will be dropped with the mapping and
> > > reclaim more file, and we won't see any refault data from that since
> > > the mapping itself is gone. Sys will be lower too, as IO isn't counte=
d
> > > as sys. Checking your data, despite sys is higher, real is acutually
> > > lower, which matches my guess.
> > >
> > > Will the following patch help? I'm not sure if this is the problem,
> > > but this added back that early abort, personally I don't think this
> > > really makes much sense as it's more like a workaround for other
> > > issues, but if that helps we might better keep it.
> >
> > Hi Kairui, after five hours of sleep I=E2=80=99m feeling much more
> > refreshed and should have identified the issue. I think the
> > problem will be clear once you look at the patch below.
> > Feel free to include it in the new version if you find it
> > helpful.
> >
> > From e3a0b50dc53a3a5f2ef1adfb73111336e3c2d08b Mon Sep 17 00:00:00 2001
> > From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> > Date: Sun, 26 Apr 2026 08:34:21 +1200
> > Subject: [PATCH] mm/mglru: Avoid falling back to another type when
> >  scan_folios() leaves no remaining pages
> >
> > While remaining reaches 0 in scan_folios(), we quickly fall back
> > to the other type in isolate_folios(). This is incorrect, as the
> > current type may still have sufficient folios. Falling back can
> > undermine the positive_ctrl_err() result from get_type_to_scan(),
> > which is derived from swappiness.
> >
> > A simple fix is to continue scanning this type for another round.
> >
> > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > ---
> >  mm/vmscan.c | 9 +++++++--
> >  1 file changed, 7 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index ef45f3a4aa38..169fbbe17c7b 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -4788,8 +4788,13 @@ static int isolate_folios(unsigned long nr_to_sc=
an, struct lruvec *lruvec,
> >                         *isolate_scanned =3D scanned;
> >                         break;
> >                 }
> > -
> > -               type =3D !type;
> > +               /*
> > +                * If scanned > 0 and isolated =3D=3D 0, avoid falling =
back to the
> > +                * other type, as this type remains sufficient. Falling=
 back
> > +                * too readily can disrupt the positive_ctrl_err() bias=
.
> > +                */
> > +               if (!scanned)
> > +                       type =3D !type;
> >         }
>
> Thanks so much for catching this! The fix makes perfect sense, it
> restores the pre-patch behavior. I was too aggressive with the
> fallback; positive_ctrl_err() should win whenever the preferred type
> is actually productive.
>
> Would you prefer I squash this into the original patch (with a
> Co-developed-by for you?), or keep it as a standalone fix on top? I'm
> fine either way.

Either approach is fine=E2=80=94use whichever works better for organizing v=
7.
My boss would definitely be happier with the latter, as it would better
support and encourage more active engagement in upstream development.
It=E2=80=99s rare these days to find a boss like this who is open-minded an=
d
insightful about upstream contributions, especially with everyone
moving toward AI. :-)

>
> One related thought for a follow-up: scanned =3D=3D 0 from scan_folios()
> is essentially driven by get_nr_gens(lruvec, type) =3D=3D MIN_NR_GENS. So
> when the type get_type_to_scan() picked is the one that's
> gen-exhausted, maybe the right response is also to age that type
> rather than fall back. Right now should_run_aging() only looks at the
> combined evictable_min_seq, so the ctrl_err preferred type can
> silently stay starved while we evict from the other one, that could be
> an old issue we can fix later.

Yep, I=E2=80=99ve been thinking about the same thing for quite a
few days. This might also help address swappiness. On the
other hand, it could lead to more aging, but it seems like
a necessary trade-off if we want a simple solution that
doesn=E2=80=99t require separate max_seq for file and anon to fix
swappiness for mglru.

I=E2=80=99m also trying another approach. For example, if the
number of folios in the old generation is too low relative
to swappiness, should_run_aging() could return true=E2=80=94similar
to Yu=E2=80=99s earliest patch as below, but with a swappiness bias.

+ /*
+ * It's also ideal to spread pages out evenly, i.e., 1/(MIN_NR_GENS+1)
+ * of the total number of pages for each generation. A reasonable range
+ * for this average portion is [1/MIN_NR_GENS, 1/(MIN_NR_GENS+2)]. The
+ * aging cares about the upper bound of hot pages, while the eviction
+ * cares about the lower bound of cold pages.
+ */
+ if (young * MIN_NR_GENS > total)
+        return true;
+ if (old * (MIN_NR_GENS + 2) < total)
+        return true;

Hopefully, the above can resolve the problem before we have to
resort to separate max_seq, which would break the shared time
axis between file and anon.

Maybe I will send an RFC before LSF/MM/BPF if we have enough
time.

Thanks
Barry

