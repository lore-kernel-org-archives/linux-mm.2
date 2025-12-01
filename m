Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0BB6D111A8
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 09:01:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D2F36B0088; Mon,  1 Dec 2025 04:01:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AA6F6B0089; Mon,  1 Dec 2025 04:01:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C0C16B008A; Mon,  1 Dec 2025 04:01:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0A5C66B0088
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 04:01:19 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A6CB3140889
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 09:01:18 +0000 (UTC)
X-FDA: 84170308236.14.FAC63F8
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf14.hostedemail.com (Postfix) with ESMTP id A3B2910000B
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 09:01:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Jpi3CzPQ;
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764579676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mxmnSSeFCevDFxHXP8UnjPd3wrJiEWtNZQwj48atiFU=;
	b=nSVSgFKs0IA2xi7TKYuwgNTf3munH9/uwMO1FQR9mnk1tTi4Ixjh0gtQcVgiT81dztAVR0
	pZ03paiYbGgOW+Eqd/3JhZy1+LCcjWmkROopBKjbpD9f8tX1IAYLZfFx8p3u2RTmYsrpQr
	jg8nAvGNN1+3p8eiKjgSUv558i/OOqU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764579676; a=rsa-sha256;
	cv=none;
	b=BfsdMKVbZNzIBc+ivxXZs5yXIQbnUS6dSqeYv5nZC6h8NJqbSnToMIB6IvtL37JVIPakj1
	e+AbSZkwbEGsUtYG1i0GyXHbAL9cLYDTAwgPEFvMmaoIUOns1EQlFVo8tgHqRiXgItQ+RX
	7ajDB6/juYH75YhD0TyUu2IFPDqxlMA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Jpi3CzPQ;
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b73b24f1784so759738266b.0
        for <linux-mm@kvack.org>; Mon, 01 Dec 2025 01:01:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764579675; x=1765184475; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mxmnSSeFCevDFxHXP8UnjPd3wrJiEWtNZQwj48atiFU=;
        b=Jpi3CzPQKPSitynJwhrYDQ+ohanAFPB/3OqFBuZ2jyJRjtIhjndYVyxHe05juwDyy+
         zYRBGfpJ7i7j3XJkHGS/vQ/ralLOyrZoiSYKpyTntKubckLiCLaznhvug+iVFQPuuY0b
         8CTBC1Tw5jTJUY9DDpXtgZ+8naT9ROs64rRdZapF7vDL/nez+rAmqXt7HtWaUR40Yn9k
         uTIX3rwOa87Ak5A+EP43vGXZTfu41sn3YdN9AcZH6Emr9DsiaQVq8jCqp7yVxZQqk95a
         B8hbyixFztMXc+GP0VTPkAfScXPXL3/p20O2JosfjJwEK1l7m8b+c6KjIUwi02jlS8oI
         VCIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764579675; x=1765184475;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mxmnSSeFCevDFxHXP8UnjPd3wrJiEWtNZQwj48atiFU=;
        b=jeLovsv/HfVXQLt/0ltU4w9WENCk4Ux9Sql0hTMt9UcUQiSP97zwSo3QWNEa5VlQUv
         ySaeFJ1j32i/j9Fp91GMILA+GmUiU/rMtN4ludr0xHxHUkQPAjh2xQxIkbL8aInNkd+E
         flkgU7Yr0ZhQv9dgeoqV2c/zkYsrQ7zeE/Oi20EXXtpsYJaHLvuzTJJGD1RGnVMmjyaT
         w3qPgNQwuEvYSuAVmvP7ai0akEruvEUkTKEuKlb1cIkRjgpXG3sS/64LYj5renm+fcik
         1OMNf9ov49xFjw5UmyRwixtfeZx59yFngn2FXLz+7x1r/R7Fiwnsbz7pkYlWL/MDhG9C
         twPg==
X-Forwarded-Encrypted: i=1; AJvYcCUBBxXLag1ord3t3MyA7CKZv+/w+mCz0QciGCMTd7RJDRuSO6xXFuvDdPGysYwB3Wp/II6WGkMb8A==@kvack.org
X-Gm-Message-State: AOJu0YyflkN2qL6PHPvqiuivjLSA/7VhoxrMKcoM6jMKGBDaQt5Sxfsq
	jtufYB9LBYe0hBMiCE/DUePOY6t1inr1D9PXcM8rD4WvL0dimqvKVt8/WokclDWjFU+EtEaz8Ak
	uKE68nZSJn20nmkSbDJAQOhjQDLVcgXM=
X-Gm-Gg: ASbGncvCX/SMREnP7f/BCzBFrqrQPxyRvDHZDSUUnGWyiYX5fd2GzuudNT7JWRJD4Sp
	CrtuPPD7bdhdcWUTMZcDf5LUKDz+C9fqyMFV4S1e4eEkes9X1y8jpeuYKmXlrnZDsa8Pkx1+cCF
	fl8+Cf6IGeMmae6a6tanEShKMKvsNdIbGHk0K0tFDhJUupl8ACiesELP55NlRUOioksVq9teEdK
	lHqSyrJozdHnyXueua7zgCoFXwkvLEql4mTic+g1n/OwQwsz8YAFU8/50sh0LqBLWeiGkSSWgad
	feKQq49p0Sw7Zi3vjgHTkfIscus=
X-Google-Smtp-Source: AGHT+IEgR1DdVllyHOeHiRvvKQbP5W/yciHkiXXT8zXV8yo4kCCAug8/rhvvEwNd/SEZmh5QwfddA+G1su9EGVjpcHA=
X-Received: by 2002:a17:907:1b14:b0:b76:3472:52df with SMTP id
 a640c23a62f3a-b766edb87fcmr4030364266b.10.1764579674291; Mon, 01 Dec 2025
 01:01:14 -0800 (PST)
MIME-Version: 1.0
References: <20251128025315.3520689-1-wangzicheng@honor.com>
 <aSm800KsCAptVZKu@casper.infradead.org> <ti7h5cbrg5s3zf7surof3zmxb6supnl34x7hsbziqutm7r2laf@zuunap5hwsbx>
 <CAGsJ_4xJ5qMght93FQOYrk1OiJTh-wFC4e8Nd4K0A156N3ZEBQ@mail.gmail.com>
 <86c62472b5874ea2833587f1847958df@honor.com> <CAGsJ_4w1jEej+ROuLta3MSuo4pKuA5yq7=6HS5yzgK39-4SLoA@mail.gmail.com>
In-Reply-To: <CAGsJ_4w1jEej+ROuLta3MSuo4pKuA5yq7=6HS5yzgK39-4SLoA@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 1 Dec 2025 17:00:36 +0800
X-Gm-Features: AWmQ_bnswMDYfF0lQTLx1DlxQcT6Wt6rEWzfD7LxVrDE92N05MOtOpqZN120qhk
Message-ID: <CAMgjq7DOPMp3Eq9_SxmxNhY7S5--3uf0PByNAJOAEne9hb+T9Q@mail.gmail.com>
Subject: Re: [PATCH 0/3] mm/lru_gen: move lru_gen control interface from
 debugfs to procfs
To: Barry Song <21cnbao@gmail.com>
Cc: wangzicheng <wangzicheng@honor.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Matthew Wilcox <willy@infradead.org>, 
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
	wangzhen 00021541 <wangzhen5@honor.com>, zhongjinji 00025326 <zhongjinji@honor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: A3B2910000B
X-Stat-Signature: jo6c1wykrjrat36wnpbra5hp8z3pyxw7
X-HE-Tag: 1764579676-245007
X-HE-Meta: U2FsdGVkX1/dSNzEKFgxDyhFiogVUJH0M6qiEgHJvLM6IVPjdEjm/93K9r+NVebvvnG1kuXm0TXa7JPg7G2yo9MzuvkCM25VpZgMz13Lwwtzyal5BBl0efOYXQ1Qv3pShq17QifDBJQF7mC6Gy9WUSp8hm95UwNvMSCgUB9dQ7F7YP7FU+sdJOl8mb2BkKp0qNrTIb2vlMn1F5bl7HPfqVjPhRYIXSeRGuHAW3dIJOG813nsQe8cgEumB83r3fAaXW0r3gyUWbEXRSofQd8+mFBv9dRzlJjzs8P3nH+1A/N1ZPXUgngSZKirql1h4iramMpdoINsomH46zomC+vmLkOMoQl6lw6hM+RlhzK4YSmHm2ugCIM/vTeGQyNeu7SAgF/20OyHrRXrRzXkMNvR7W6RrsSw1Si/lLyEgpcvj59eP0LiI86u29mN2DHWyTvtlnJEDw1hMj4ZVMbKgaVGXcGhgI7LDvB91Saa7HnHIcRaeqSzIwfIeY+RmULTrOKEWWTLcpJsHAr7iBXpk6Xs41MvuhGvxrboUdPPAEcK1N4hV7Uw92QVwZjCDCntUWOXlp7atnoIsGteRQp3IEem4KdtYI4+eKaHs+zW1Buu2HghyQzZ3K3+pjVj/WdlB/f48n81v4r/IG9ndmOpglYz5CH7Angt1iN+KhJ/XiCRTMGceEj+DDACgslrXfQyRYi4+P462GdhHG1XLfToD8lGUvPuL9m+Oix/8yM9wSzgb9rLJ/ZAxG+ZDgQw7WMvnxa3ncian3Puq2O+MxHac/4dozjnLtyl3iVrU//R9HR9PVwi3PxxVyo3udVAQVdqLeK7vyxWmex/pVmMq5JftruMUX0w1AiKPCYv1DyL3Qr2/LA8uEpAKY+HdvjaznUqi2Anxy2sFDNLQA6PO50O0IgQS2iU1ay6jB0poZRQ2o7OzVBgRpQWJut76oNzh9ad2IUSx5mjaUz7n0SuoJl8RQN
 u5YYn9l/
 EBcUzfKakadwrR2/DJYv8ROxJAkAovuDNnPwpP+eGxIvXJI+ZCcGmjWq9PvLRuNt6ygmAqZyMXY9TqqqNrAHVIa54WD+bV4P3rtIcb6vRy4Vd/zEmR/kKibymhp9sxVRQTOOSpAMs6Bic/3xIrvZoOlzcOkKh3KUthJudL9v8mgXeKSTED+2y30iQSaRQIKwV5FByzYQCRCPCsZYzCCVzKytF+Upt/foTYGtgvrLqMHQhu+7sZBdEgfSOaLtRMCQCd05Nq+4+C514tUJJ0+4colNBM110uyZLY1AhVYHG5w5iNy1/uwR1esnKtphtr90H8iBnWW54DmbX2Evidjiplw5wnK5V+O3xyEFSlcm3qyI2Sw2nZHRGkhALNaQ6CT2LYbE8302WrA4S2IWNwZKIG4xBNLTO+IVHRzdTiGg0S2Ak0qYB3yQ7crUvH3OJxtkckUXPHz6Jctj6Wj6tc/8j39MBofnhlzbtbNGwvc/1211ZQRQP90IK7RTaV3sSnWeLGxK2fTiZg7x5ELADXwnvDmwdpUNfacMduDi8npF+nG0HkH04T6pCMUtU+3KJ9iws8Z5f74eVXeAyGg6Jk2wXzy6N28rM4ZJZeZwar7J0DcpcI+0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 1, 2025 at 3:46=E2=80=AFPM Barry Song <21cnbao@gmail.com> wrote=
:
>
> On Mon, Dec 1, 2025 at 2:50=E2=80=AFPM wangzicheng <wangzicheng@honor.com=
> wrote:
> >
> > Hi Barry,
> >
> > > Hi Liam,
> > >
> > > I saw you mentioned me, so I just wanted to join in :-)
> > >
> > > On Sat, Nov 29, 2025 at 12:16=E2=80=AFAM Liam R. Howlett <Liam.Howlet=
t@oracle.com>
> > > wrote:
> > > >
> > > > * Matthew Wilcox <willy@infradead.org> [251128 10:16]:
> > > > > On Fri, Nov 28, 2025 at 10:53:12AM +0800, Zicheng Wang wrote:
> > > > > > Case study:
> > > > > > A widely observed issue on Android is that after application
> > > > > > launch,
> > > >
> > > > What do you mean by application launch?  What does this mean in the
> > > > kernel context?
> > >
> > > I think there are two cases. First, a cold start: a new process is fo=
rked to
> > > launch the app. Second, when the app switches from background to
> > > foreground, for example when we bring it back to the screen after it =
has
> > > been running in the background.
> > >
> > > In the first case, you reboot your phone and tap the YouTube icon to =
start
> > > the app (cold launch). In the second case, you are watching a video i=
n
> > > YouTube, then switch to Facebook, and later tap the YouTube icon agai=
n to
> > > bring it from background to foreground.
> > >
> > Thanks for the explain, that's exactly what I meant.
> >
> > Android lifecycle model isn't obvious outside the Android context. I=E2=
=80=99ll make that
> > clearer in the next version.
> > > >
> > > > > > the oldest anon generation often becomes empty, and file pages =
are
> > > > > > over-reclaimed.
> > > > >
> > > > > You should fix the bug, not move the debug interface to procfs.  =
NACK.
> > > >
> > > > Barry recently sent an RFC [1] to affect LRU in the exit path for
> > > > Android.  This was proven incorrect by Johannes, iirc, in another
> > > > thread I cannot find (destroys performance of calling the same comm=
and).
> > >
> > > My understanding is that affecting the LRU in the exit path is not ge=
nerally
> > > correct, but it still highlights a requirement: Linux LRU needs a way=
 to
> > > understand app-cycling behavior in an Android-like system.
> > >
> > > >
> > > > These ideas seem both related as it points to a suboptimal LRU in t=
he
> > > > Android ecosystem, at least.  It seems to stem from Androids life
> > > > (cycle) choices :)
> > > >
> > > > I strongly agree with Willy.  We don't want another userspace daemo=
n
> > > > and/or interface, but this time to play with the LRU to avoid tryin=
g
> > > > to define and fix the problem.
> > > >
> > > > Do you know if this affects others or why it is android specific?
> > >
> > > The behavior Zicheng probably wants is a proactive memory reclamation
> > > interface. For example, since each app may be in a different memcg, i=
f an
> > > app has been in the background for a long time, he wants to reclaim i=
ts
> > > memory proactively rather than waiting until kswapd hits the watermar=
ks.
> > >
> > > This may help a newly launched app obtain memory more quickly, avoidi=
ng
> > > delays from reclamation, since a new app typically requires a substan=
tial
> > > amount of memory.
> > >
> > > Zicheng, please let me know if I=E2=80=99m misunderstanding anything.
> >
> > Yes, but not least.
> >
> > 1. proactive memory reclaim: yes, that's we are after.
> > When an app is swiped away and kept in the background and not use for a=
 while,
> > proactively reclaiming its memcg can help new foreground apps get memor=
y
> > faster (instead of paying the cost of direct reclaim).
> >
> > 2. Anon v.s. File: *bias more towards anonymous* pages for background a=
pps.
> > With mglru, however, the oldest generations often contain almost no ano=
n pages,
> > so simply tuning swappiness cannot achieve that -- reclaim will still c=
lear file cache
> > in the old generations first.
> > To some extent, file caches are `over-reclaimed` in such senario, leadi=
ng to a disaster
> > when user=E2=80=91interaction threads get stuck in direct reclaim of an=
on pages.
> I strongly recommend separating this from your patchset. Avoid including
> unrelated changes in a single patchset.
>
> MGLRU has a mechanism to ensure that file and anon pages can keep pace
> with each other. In the newest kernel, the minimum generation is 2. For
> example, if anon has only 2 generations left and we decide to reclaim
> anon folios, we will fall back to reclaiming file pages. Sometimes,
> this means that anon reclamation is insufficient while file pages are
> over-reclaimed.
>
> static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>                        struct scan_control *sc, int type, int tier,
>                        struct list_head *list)
> {
>         ...
>         if (get_nr_gens(lruvec, type) =3D=3D MIN_NR_GENS)
>                 return 0;
>         ...
> }
>
> This is probably not a bug, but this design can sometimes work
> suboptimally.
>
> Regarding this issue, both Kairui (from the Linux server side, cc-ed) and=
 I
> (from the Android side) have observed it. This should be addressed in
> MGLRU's code, and we already have kernel code for that. It is unrelated
> to your patchset, so you shouldn=E2=80=99t include so many unrelated chan=
ges in
> a single patchset.

Thanks for including me in the discussion.

Right, we are seeing similar problems on our server too. To workaround
it we force an age iteration before reclaiming when it happens, which
isn't the best choice. When the LRU is long and the opposite type of
the folios we want to reclaim is piling up in the oldest gen, a forced
age will have to move all these folios, which leads to long tailing
issues. Let's work on a reasonable solution for that.

>
> Please keep your patchset focused solely on whether the MGLRU proactive
> reclamation interface should be promoted to sysfs (LRU_GEN already has a
> folder in sysfs) instead of debugfs, if there is a v2.
>
> The following is quoted from
> `Documentation/admin-guide/mm/multigen_lru.rst`.
>
> Proactive reclaim
> -----------------
> Proactive reclaim induces page reclaim when there is no memory
> pressure. It usually targets cold pages only. E.g., when a new job
> comes in, the job scheduler wants to proactively reclaim cold pages on
> the server it selected, to improve the chance of successfully landing
> this new job.
>
> Users can write the following command to ``lru_gen`` to evict
> generations less than or equal to ``min_gen_nr``.
>
>     ``- memcg_id node_id min_gen_nr [swappiness [nr_to_reclaim]]``
>
>
> >
> > See the case in the cover letter.
> > ```
> > memcg    54 /apps/some_app
> > node     0
> > 1     119804          0       85461
> > 2     119804          0           5
> > 3     119804     181719       18667
> > 4       1752        392         244
> > ```
> >
> >
> > Since the semantic gap between user/kernel space will always exist.
> > It would be great benefits for leaving some APIs for user hints, just l=
ike
> > mmadvise/userfault/para-virtualization.
>
> Nope. This is just an internal detail of MGLRU and shouldn=E2=80=99t be e=
xposed
> as an interface.
> Hopefully, Kairui or I will send a patchset soon to address the balance
> issue between file and anon pages. For now, you can use `swappiness=3D201=
`
> as a temporary workaround. Take a look at bytedance's patchset.[1]

Agree, Thanks!

