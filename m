Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 808FFD116E2
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 07:46:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D76116B000E; Mon,  1 Dec 2025 02:46:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4D8F6B0022; Mon,  1 Dec 2025 02:46:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C63F96B0023; Mon,  1 Dec 2025 02:46:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B1AEF6B000E
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 02:46:10 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5A36E8A0E8
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 07:46:10 +0000 (UTC)
X-FDA: 84170118900.15.01C90DA
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7E9444000D
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 07:46:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=G+Lys6jK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764575168; a=rsa-sha256;
	cv=none;
	b=3aUvtSxDeqHREqNofFwdSiOP10azfqdxP2lWB06422FzxFqM6IWKUFy0XUSF2+IikLghid
	TjY3HCMq0kgIda6ta99+QiLUhOF96qqSJOk3HDklteZiZWAIU70nVDukLK1Yr86JVQcmLL
	Cjd14PV1zaHJeMNtWSM2hlXz8ZgyW+s=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=G+Lys6jK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764575168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=41z4A7AA8zEfkiS9IW0UMmWvbzqrd+DDt90+p653r9c=;
	b=Tck5/Ij+NzNK6IzMK1m6jHgdVgdS2Dgi7w0f3pB/X1DR9zlLKs4gmKC2ZJo6vMw9ctrz4p
	EB1EgmAY9hkB8PtIiRdHqhIikkSckBMRLl7ZGa8/ftuX4u2oDPc1PIrHNPNmw17AoiqA2v
	LkeUCTvrHXv02EK42pIZXp037ezx9p0=
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-8b220ddc189so421392085a.0
        for <linux-mm@kvack.org>; Sun, 30 Nov 2025 23:46:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764575167; x=1765179967; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=41z4A7AA8zEfkiS9IW0UMmWvbzqrd+DDt90+p653r9c=;
        b=G+Lys6jKGyl+Yq6aVaJm1YduBTZ+R+7EWvycYs49RGV0MZ8tcKU92JnRE2e6TbloPN
         srReljNL3tl1sOyYs0dpo9eLOWu/m9bYgqAwjMmr0/snCAUzsq4HKohkie6pPtcfra75
         Ftwsh8/6A5vQL1wXMc1LORhxh1xXFG89m2Rnn7XEuE7jrBjtTJK1ZdjukHi0xn2HP7pm
         qeEN6+VhiAWz1H4KQ3ev0gjAFQNld9CauNUhYIHLIREXJiSf5CEC4rcako430123Bc+Z
         Z5Z8ZpcPWz5omeFG1p5sR5hkZoohX6si4MZhwDKwe8kqgHIAbleOc4vEQtAF98S1gOCU
         fqsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764575167; x=1765179967;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=41z4A7AA8zEfkiS9IW0UMmWvbzqrd+DDt90+p653r9c=;
        b=JwgnigoJ71DAZaZGdnqT7rSS+nY597hAr+oO7o/d6VVCRW1tspSofO15vyYZOAsmFG
         PEeU3U/DivxZ19e0yl6LjfKi/okuWSNXI5o+NuQf7inkMH/VFw2ZVtX5EjvkaE7+yM0+
         0FAScktGnCkvisA2PZdKOBYRv2FSechHPaUhyUPC+F7Y7BWnem6J1vwq3GIAYMgLqRsU
         RPVcEOBBIUEg/tqLshe4a5n8R1aG/xzt/THjADpYrPrJ1uO9CpngJlO9xvHD6p5OFxfo
         qzGGZ+Bhv6cYyStJMQBMQUuQsRSTvL2dEHMsGQmcrs0vneu9sSqON6HOpP7gnqPIPV7Z
         0nuA==
X-Forwarded-Encrypted: i=1; AJvYcCWVsyO5l3/0pI597WnxmeqDsH7XJ/+HlSFihQ71+If+u7M01kZpFweadt/8cC8YnrlFdkq0IVos+g==@kvack.org
X-Gm-Message-State: AOJu0Yyq54G5DLZACfVQYHOjhJrN+kQH5lHLr1EART9hNx5YDHIlrITW
	gezsSRuZzz61hovT0NP9ofvYQgQU3RExnGUs9MdfTO1Cj1ls9Ef9zna2kSwzwnCHhWIWaNvLBRK
	eL0mOdrCr8pSijHgqyh51n+1Pa0wrAdI=
X-Gm-Gg: ASbGncvE1yMNYgoBzwpnsokP5f5BS0SJKwDXnh6FYBv3WdnJdB7/axFO24ukbGw6H1I
	AXCJexrhAeaZjloNkb4KY97UYXMWg+8hKV4ubEC4F47vXKrJ/r/8Ey45+4UPAp/8Eyu8Rjl94d6
	S4Hv3f9HyHXHbpsuspNNYiwDTPAn5PBMSTxD81qNGlA1EkHXlIYzyNFAR0BumZY72UxK21WCRq2
	Qmes4OIrcv2PjTYzhSvMB48Lbb5zzBrECNb8fysssFkKbcs4Cnp1fX8ip1W74zA/EByIQ==
X-Google-Smtp-Source: AGHT+IGqwnjgmfy7EqzITV88vMnRPycjMmKiyI5mIf529ef5ciB182DPeOKwE99J/PSeSRK6P2V8fdv2RyhwoORqyXM=
X-Received: by 2002:a05:620a:31a6:b0:8b2:ed02:21ea with SMTP id
 af79cd13be357-8b33d49b0f2mr4792072885a.67.1764575167356; Sun, 30 Nov 2025
 23:46:07 -0800 (PST)
MIME-Version: 1.0
References: <20251128025315.3520689-1-wangzicheng@honor.com>
 <aSm800KsCAptVZKu@casper.infradead.org> <ti7h5cbrg5s3zf7surof3zmxb6supnl34x7hsbziqutm7r2laf@zuunap5hwsbx>
 <CAGsJ_4xJ5qMght93FQOYrk1OiJTh-wFC4e8Nd4K0A156N3ZEBQ@mail.gmail.com> <86c62472b5874ea2833587f1847958df@honor.com>
In-Reply-To: <86c62472b5874ea2833587f1847958df@honor.com>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 1 Dec 2025 15:45:56 +0800
X-Gm-Features: AWmQ_bn9tH9Nt6hi5IKbA74esNHYlxcCTecj4tqskduI27poYGIU-ulp06YqJ6E
Message-ID: <CAGsJ_4w1jEej+ROuLta3MSuo4pKuA5yq7=6HS5yzgK39-4SLoA@mail.gmail.com>
Subject: Re: [PATCH 0/3] mm/lru_gen: move lru_gen control interface from
 debugfs to procfs
To: wangzicheng <wangzicheng@honor.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Matthew Wilcox <willy@infradead.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, 
	"david@redhat.com" <david@redhat.com>, "axelrasmussen@google.com" <axelrasmussen@google.com>, 
	"yuanchu@google.com" <yuanchu@google.com>, "mhocko@kernel.org" <mhocko@kernel.org>, 
	"zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>, 
	"shakeel.butt@linux.dev" <shakeel.butt@linux.dev>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, "weixugc@google.com" <weixugc@google.com>, 
	"vbabka@suse.cz" <vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>, 
	"surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, "corbet@lwn.net" <corbet@lwn.net>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, wangtao <tao.wangtao@honor.com>, 
	wangzhen 00021541 <wangzhen5@honor.com>, zhongjinji 00025326 <zhongjinji@honor.com>, 
	Kairui Song <ryncsn@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7E9444000D
X-Stat-Signature: zy5exf5q4sadg33pqtgp3ew6fcj6cbmd
X-Rspam-User: 
X-HE-Tag: 1764575168-977532
X-HE-Meta: U2FsdGVkX19dVTekGdrZyd91l3RTMCb54+jBnVq1Z/SISo5i2gse1UIkjok0GyUm2b4ZFgSc5UFExKiP9+54XnC9dIncOa6fLTBN1MgGLskcLpqQmthcRNAcpgXvq+b7f7txXPaEKB6/6LAppJMCsLZHJ/2BT5W0fMLVvKdWEAk+O6BamqI37tsDwqwOxbpImHHf0EwBkecxokm9MiYiR8/X5jhXuAblTYYhnvb269yoodVFCvNWGGiRh5ZZWCGI/0EsL4TuVhCMkv56EbWMdch26zP98MrkodxOkaMr8PHki2R9LWhVcqcvG7a1SkQhPsEUVQEnCtpjocDrXvpc+qN09zpT+awPv+bCBeB44NJXKBCEP4HQkJBGuhPUTKUGE8vpQbEJNJALZp3sfBNspcvUicBcuV5r2iKYCjCHc42GAREgFNGJzP0V/YYm78YBXYT6ENyS7MSrgafMspha1Ter/NfstcKzb18QJbs2taCEyO0YWUvIjcFvFBZmN1FCJ4Whj/Y0yTo7cIfIvp3epz7bZBYBvL70jkpwREC+g7aktlfU4Blv1sfKN5W6i/T1ANu2iT8YV54X7kmOa8U5K2TCHAndmorYGqvT57Bp4D7iIbupKUlUoCKu4mNGqPXIrjBYZ3QZyd2KD2+oYAt+7FmkuG8EEH75uu9zY8MYt2uXth/vSBXxbOXwOLiaWrRrm1GpZzeDosXcw3DNNo/osI8oQwK4dEFXjYypwICo9XyFemxMa6oJSw38rrzLbOIV2x04NgAxo2GIai/dGNzM31hgYjbU+NVgNiVxjxm/e/zSeze0mtstia8zMHDJ5vR7StF9J/eXcECT6SDfs9q86BQ8XU+biRP1LtrXoFJvfgnS0OcyVGHm0gz+yZ40FlFQ9uSXEnFxh5uHxvtFDY+agjBZT9PvTcjJs8ySg8nwQ1mk7S8Bmmn4YfMa3ljeXF1vm1b/j+2tQJ4Moxh8bUg
 J9fZdvoO
 GG0mngG6ChTEzDOr5pg8n03nwvjNqtpG3VyDbZ0V3jTBDw6j7ftexQ1Genqe2uendg2q4vcpxQ/oXEiju2HPZYSe8WVizvbkPtU5UfeG7dY8AvUa1/s2FmomNCJ/3F3gHewLylBU4SQX+/MawbmplIUtBTx8RLc8cuwosHtMYYWTZbR/ONffhZdRAz0cvDL89cTVPOF0MvEw0WWteoknOFq4DY+yhUIysHDw469TgAT49tcPO5UDaKfQqYtgLc8AXsWuyl7n4GBqNSw39rtrfYrfqasW6s8uEUBa2P1Rulk2pYDBmi8PHsedkMVWxPEdpEOEmGChyy8MbmvM3Q6njDERjeXKLEgDba4dII2K+eK1L+g35oefjvByh5czF2/jkSiKJGyFHN4L4wePEYtqrIF03TkFqj5pgM0nBsnFizgYohyz9c5rJclehTuJ9pVqoEoK3VquIgQXIbrUx+f5E8h9xvtWEdfcpYKK+WvN/9E8xMS/sUbpXWtqGqeij0+v4UaLo3ubboagunJiswt7539AjH5//xTmOnVXALEYBRktM0GrtbaA7GCN2jPTo2pV09/lbHmqlOH0BsY/xld9eBJ8a0w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 1, 2025 at 2:50=E2=80=AFPM wangzicheng <wangzicheng@honor.com> =
wrote:
>
> Hi Barry,
>
> > Hi Liam,
> >
> > I saw you mentioned me, so I just wanted to join in :-)
> >
> > On Sat, Nov 29, 2025 at 12:16=E2=80=AFAM Liam R. Howlett <Liam.Howlett@=
oracle.com>
> > wrote:
> > >
> > > * Matthew Wilcox <willy@infradead.org> [251128 10:16]:
> > > > On Fri, Nov 28, 2025 at 10:53:12AM +0800, Zicheng Wang wrote:
> > > > > Case study:
> > > > > A widely observed issue on Android is that after application
> > > > > launch,
> > >
> > > What do you mean by application launch?  What does this mean in the
> > > kernel context?
> >
> > I think there are two cases. First, a cold start: a new process is fork=
ed to
> > launch the app. Second, when the app switches from background to
> > foreground, for example when we bring it back to the screen after it ha=
s
> > been running in the background.
> >
> > In the first case, you reboot your phone and tap the YouTube icon to st=
art
> > the app (cold launch). In the second case, you are watching a video in
> > YouTube, then switch to Facebook, and later tap the YouTube icon again =
to
> > bring it from background to foreground.
> >
> Thanks for the explain, that's exactly what I meant.
>
> Android lifecycle model isn't obvious outside the Android context. I=E2=
=80=99ll make that
> clearer in the next version.
> > >
> > > > > the oldest anon generation often becomes empty, and file pages ar=
e
> > > > > over-reclaimed.
> > > >
> > > > You should fix the bug, not move the debug interface to procfs.  NA=
CK.
> > >
> > > Barry recently sent an RFC [1] to affect LRU in the exit path for
> > > Android.  This was proven incorrect by Johannes, iirc, in another
> > > thread I cannot find (destroys performance of calling the same comman=
d).
> >
> > My understanding is that affecting the LRU in the exit path is not gene=
rally
> > correct, but it still highlights a requirement: Linux LRU needs a way t=
o
> > understand app-cycling behavior in an Android-like system.
> >
> > >
> > > These ideas seem both related as it points to a suboptimal LRU in the
> > > Android ecosystem, at least.  It seems to stem from Androids life
> > > (cycle) choices :)
> > >
> > > I strongly agree with Willy.  We don't want another userspace daemon
> > > and/or interface, but this time to play with the LRU to avoid trying
> > > to define and fix the problem.
> > >
> > > Do you know if this affects others or why it is android specific?
> >
> > The behavior Zicheng probably wants is a proactive memory reclamation
> > interface. For example, since each app may be in a different memcg, if =
an
> > app has been in the background for a long time, he wants to reclaim its
> > memory proactively rather than waiting until kswapd hits the watermarks=
.
> >
> > This may help a newly launched app obtain memory more quickly, avoiding
> > delays from reclamation, since a new app typically requires a substanti=
al
> > amount of memory.
> >
> > Zicheng, please let me know if I=E2=80=99m misunderstanding anything.
>
> Yes, but not least.
>
> 1. proactive memory reclaim: yes, that's we are after.
> When an app is swiped away and kept in the background and not use for a w=
hile,
> proactively reclaiming its memcg can help new foreground apps get memory
> faster (instead of paying the cost of direct reclaim).
>
> 2. Anon v.s. File: *bias more towards anonymous* pages for background app=
s.
> With mglru, however, the oldest generations often contain almost no anon =
pages,
> so simply tuning swappiness cannot achieve that -- reclaim will still cle=
ar file cache
> in the old generations first.
> To some extent, file caches are `over-reclaimed` in such senario, leading=
 to a disaster
> when user=E2=80=91interaction threads get stuck in direct reclaim of anon=
 pages.

I strongly recommend separating this from your patchset. Avoid including
unrelated changes in a single patchset.

MGLRU has a mechanism to ensure that file and anon pages can keep pace
with each other. In the newest kernel, the minimum generation is 2. For
example, if anon has only 2 generations left and we decide to reclaim
anon folios, we will fall back to reclaiming file pages. Sometimes,
this means that anon reclamation is insufficient while file pages are
over-reclaimed.

static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
                       struct scan_control *sc, int type, int tier,
                       struct list_head *list)
{
        ...
        if (get_nr_gens(lruvec, type) =3D=3D MIN_NR_GENS)
                return 0;
        ...
}

This is probably not a bug, but this design can sometimes work
suboptimally.

Regarding this issue, both Kairui (from the Linux server side, cc-ed) and I
(from the Android side) have observed it. This should be addressed in
MGLRU's code, and we already have kernel code for that. It is unrelated
to your patchset, so you shouldn=E2=80=99t include so many unrelated change=
s in
a single patchset.

Please keep your patchset focused solely on whether the MGLRU proactive
reclamation interface should be promoted to sysfs (LRU_GEN already has a
folder in sysfs) instead of debugfs, if there is a v2.

The following is quoted from
`Documentation/admin-guide/mm/multigen_lru.rst`.

Proactive reclaim
-----------------
Proactive reclaim induces page reclaim when there is no memory
pressure. It usually targets cold pages only. E.g., when a new job
comes in, the job scheduler wants to proactively reclaim cold pages on
the server it selected, to improve the chance of successfully landing
this new job.

Users can write the following command to ``lru_gen`` to evict
generations less than or equal to ``min_gen_nr``.

    ``- memcg_id node_id min_gen_nr [swappiness [nr_to_reclaim]]``


>
> See the case in the cover letter.
> ```
> memcg    54 /apps/some_app
> node     0
> 1     119804          0       85461
> 2     119804          0           5
> 3     119804     181719       18667
> 4       1752        392         244
> ```
>
>
> Since the semantic gap between user/kernel space will always exist.
> It would be great benefits for leaving some APIs for user hints, just lik=
e
> mmadvise/userfault/para-virtualization.

Nope. This is just an internal detail of MGLRU and shouldn=E2=80=99t be exp=
osed
as an interface.
Hopefully, Kairui or I will send a patchset soon to address the balance
issue between file and anon pages. For now, you can use `swappiness=3D201`
as a temporary workaround. Take a look at bytedance's patchset.[1]

> Exposing such hints to the kernel can help improve overall system perform=
ance.

[1] https://lore.kernel.org/linux-mm/cover.1744169302.git.hezhongkun.hzk@by=
tedance.com/

Thanks
Barry

