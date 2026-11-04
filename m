Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13E2D60A2605
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 21:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CNrR6Ix7
Received: by kanga.kvack.org (Postfix)
	id 168A76B05B0; Wed,  4 Nov 2026 16:53:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13FED6B05B1; Wed,  4 Nov 2026 16:53:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 008936B05B2; Wed,  4 Nov 2026 16:53:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C04C66B05B0
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:53:17 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 51017A0897
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:53:17 +0000 (UTC)
X-FDA: 85398788034.08.A81E462
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5B17740003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:53:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CNrR6Ix7;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793829195;
	b=Hd+y8dj13T0oo7bciMPek/dK1ZnJxMbmsqgqS7Y34iBgzKqiRYVImG3IiNSCU5Sbi1tH3+
	IuTf/xwgWLkfEe1FMDP/B2J82b8kGrsOkDG2FOj8ZFDXTys1vjyodbmlCp4mjM/a4Dv5YJ
	Iw5cX/86v6DbZpeJMHt4nMoAZxg+uEs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CNrR6Ix7;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793829195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dXhZP77Jedhgmh+dWAEC7Sdp0jRlMNTtA9C+vIq2qKk=;
	b=5cB4rQ+mpjQh9uA5dg7mkyJ3BWpqsGt0I4tPUlAVNlhN6XJCP3p6LX903VixuIo8avQNrC
	cEAE7ej92lnaulO4lu4oUDATwYMBifYE8G7YxtdS0NpGzMQ+VmJTDRI9lvbHqKfIYBceue
	cCnfSIavVw+8aUHq30QWeUxAumDAHzE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8634643D6B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:53:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65A341F00A22
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793829194;
	bh=dXhZP77Jedhgmh+dWAEC7Sdp0jRlMNTtA9C+vIq2qKk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=CNrR6Ix7wlD5iLKxN3Z8zTQhCt9Zp8e6xd6x6nEqnwCKBg4eSnPPpx/JWe0rYD0Qw
	 BzsY2eEaIin/b+CbeGCK9lf6QcrAn0ofCPaRHBrxkpfbvNR5kFC9JyaZr1ac2gIeoN
	 HmpnXlTWeppbhZBIGFtntBO8as/fPBw9fQbb8MnsEaZ+H9CEoB4/mQKzvZErE8iIOV
	 r9+jc1gNeR+TBJc79Qq0jEEuYbokzeybjh247r++eEJJvTvkkXdBaF0PVnRuvZmcVp
	 pwqmiHyBguLONcX14bwkPGhid1pggD5il6BUQUfFwmeBOFigY65+4Mtx/U8JIvRybz
	 4ZA97ByiiGsVw==
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-93efc0452b5so89485285a.0
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 13:53:14 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBxeMnsM57HTHDk/FrGsZZUAPLSJbjA5XJwRTTAdwdIBXnsewhXf6nXEe3tMNQ0FOiVIC4pmA5Hugw==@kvack.org
X-Gm-Message-State: APuU4Z/7oe5+0iJxUj6XZQlznFZABhRtnHOP9HAkFIdrLTvJpdtUnGIn
	ZFVJPhb0LScyqYqCUjYfz75Sy7o3tWvo+Hh+smjOd5W7V5dndYid03H6VHMfm/EH2RtUTCq2tjv
	fBaKI+eygGRkcZ2oFqvI780m0lHGFssM=
X-Received: by 2002:a05:620a:4555:b0:943:f301:49b9 with SMTP id
 af79cd13be357-94421738a60mr2860432285a.53.1793829193621; Wed, 04 Nov 2026
 13:53:13 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261022220203.91911-1-baohua@kernel.org> <CAMgjq7C6htO2bp21Bq-dU2feN2tXuxHaqgNcG5sD=u1bwbEuYQ@mail.gmail.com>
In-Reply-To: <CAMgjq7C6htO2bp21Bq-dU2feN2tXuxHaqgNcG5sD=u1bwbEuYQ@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 5 Nov 2026 05:53:00 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xp=B+oJCZCP0V=OCKhcWzru+VuL4G=rA2VnA7Ah++aVg@mail.gmail.com>
X-Gm-Features: AclHuK_6pK_SD1WSi63iVUPMSwF_6r0P_xsPznQpqb35-KPgBQKMXG_bepb5-Dk
Message-ID: <CAGsJ_4xp=B+oJCZCP0V=OCKhcWzru+VuL4G=rA2VnA7Ah++aVg@mail.gmail.com>
Subject: Re: [RFC PATCH v5 00/14] mm: mglru: fix swappiness behavior
To: Kairui Song <ryncsn@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, hui.zhu@linux.dev, 
	axelrasmussen@google.com, baolin.wang@linux.alibaba.com, david@kernel.org, 
	hannes@cmpxchg.org, linux-kernel@vger.kernel.org, ljs@kernel.org, 
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	weixugc@google.com, yuanchu@google.com, zhuhui@kylinos.cn, 
	baoquan.he@linux.dev, liuxiang.277@bytedance.com, wangzicheng@honor.com, 
	lianux.mm@gmail.com, liam@infradead.org, surenb@google.com, mhocko@suse.com, 
	rppt@kernel.org, zhangbo56@xiaomi.com, lyugaofei@xiaomi.com, 
	ridong.chen@linux.dev, kunwu.chan@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: t5hfiqoyt6r9tw69anwsa9xmw1jr5ifn
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5B17740003
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793829195-871845
X-HE-Meta: U2FsdGVkX19nIWwm3sDLX2fsW0SHE2soB51/m92n2uKo6WE4GD304PZYNbwbg3S4/nBqc2ubE+upz4pwS9AaViqaZEsYUYEliUhjgC1S5tymR4D5IdCo7guOqnk6OOB7ccGSrMLx21yxFJwhkwzgOH9f3/gBMXDBrq4C9ynG8GyikoSYr48bgA7/4OcBEajLMu8dRVsmOUAAugwhdcSisbm4BNrhXBH3Gj/I5OLjtvp4tj4ob4hsPlNfn8ZEHPHE7oJ3Bsw6P1sa6n3HilqcUcM5nGkD/IUw0lNFFgC8MOIv7xHFX8yCkVd5vSY8D2fB8/ps/MU8iY5NBh7u914TgoLwlVVkirmdqPShETtItEl0Th2Pu8BjHLN6DDDq+50gpA5zGtY+4JghLCBZypk8UcZbN4yDb21ap3K4CjFY9mwt23aGufOABUDAUTxi22UVcWCWTHhMsQ13ykBIsyeSDp5csxaQpgc62U6tHRnWHgDzOX6USBHSDVTkYphC644joHMsH9wjmDuknNs64/0+op8KFS0k/bRmDXuGviz5zcWUfpDcvgT84KZNlU9UE+yNpDtLiqIet6xDaLWf/xOd58UblVgLp+Dm51T4Iv1qdWn4scK9+VBbz2gfN+7SNRVIXPpW9w9nGqJqoDGD2fvah5S8hBtN8NFBRb9ubg2vrcfQ1ukeha2Q4qqF244hinBT2KGvJBFGstlEq2cW94hah7Ws4rm17D1ZMXTcTvg+Bg3phiPQdbAqrzxESjlbJOSAqmYwq7Lc9GMSmoZo41BXUQ9LFfwRlQgfD/grmb2if1pGDkNzthcQ5/ri0h80TnU74b+aqWx7CeBafhCYxQWRsQVIiC5IkjedZv4lkRm5xrYVNEvY/pvQfPSQkAUVYmkfwEHlO6Gm7TAd0ORH5mEaznhAPfkV1Sn6OGoXcBNJedEMuGZ3m+ZJ0REARRj0oP34MuxikGkZml9Gx4hB0Bx
 JLaGuo4y
 01lZ22aaz+NpX7mgTY/G56JAWJD1NV92xyfGfwrP8DGxabSNoHnjmO07H/1NnPq39sEGKa/ee0iLt38Go0kBIztZs7DT/vHIlLWuOyKPfzmEUo+qcn4tcXO6ciRbbzrI11M4Rovw53PC9LXsvijXMCRjjLAWC1Bq7XtsVXdFVfc9iCVLzrBoDepf6HxncqFkl9XHLxCpvw7fEOr+mummMVcqVOmHQmMaSpruWppqapcB0IA91gwbYdPceb2jMTTZHn3XNzCwORGm5ahzaCOI2ELVAYPIBU8cl0rszjWL824XSipt+zrowmm+cuq+S0s/c/oMq/uocNwpqs8hlJwxsvi7MZAv8KnGRkKF5Ry/ma19XktYUTNeRuHGy9mLZj/b6j9V8w5KiLiNmwOyXkyrd4l3sOLLsBzsplDazdK8/mKQNaitepY5u6oZNvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Oct 25, 2026 at 12:10=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wro=
te:
>
> On Fri, Oct 23, 2026 at 6:02=E2=80=AFAM Barry Song (Xiaomi) <baohua@kerne=
l.org> wrote:
> >
> > Classic LRU respects swappiness, while MGLRU only partially honors it
> > when selecting the scan type, resulting in a much smaller overall
> > impact.
> >
> > For example, when building the kernel in a memcg limited to 1024 MB
> > of memory, with swappiness=3D200, CLRU barely scans or reclaims file
> > pages, while MGLRU still reclaims a significant number of them.
> > Similarly, with swappiness=3D1, MGLRU does not reclaim as many file
> > pages as expected for such an extreme swappiness value:
> >
> > pgsteal_file
> > swappiness   CLRU          MGLRU(no patches)
> > 1            5,894,538     756,589
> > 36           799,998       497,282
> > 71           548,331       415,612
> > 106          407,012       383,814
> > 141          253,737       354,249
> > 176          189,003       347,805
> > 200          0             346,078
> >
> > pgsteal_anon
> > swappiness   CLRU          MGLRU(no patches)
> > 1            3,962,404     2,768,654
> > 36           2,830,250     2,976,260
> > 71           3,121,386     3,142,954
> > 106          3,521,720     3,382,383
> > 141          3,504,471     2,970,859
> > 176          3,592,335     3,163,130
> > 200          14,095,617    3,209,132
> >
> > pgscan_file
> > swappiness   CLRU          MGLRU(no patches)
> > 1            10,270,808    886,997
> > 36           1,010,341     569,036
> > 71           656,136       490,972
> > 106          460,326       436,042
> > 141          295,184       403,132
> > 176          235,147       390,358
> > 200          0             398,363
> >
> > pgscan_anon
> > swappiness   CLRU          MGLRU(no patches)
> > 1            19,341,957    5,960,884
> > 36           17,530,774    6,394,951
> > 71           18,624,264    6,673,569
> > 106          20,088,558    6,976,364
> > 141          19,686,813    6,206,580
> > 176          20,936,177    6,344,854
> > 200          45,313,873    6,295,581
> >
> > refault_file
> > swappiness   CLRU          MGLRU(no patches)
> > 1            5,795,115     678,254
> > 36           720,877       419,659
> > 71           469,270       338,518
> > 106          331,584       308,983
> > 141          174,509       277,375
> > 176          113,352       272,390
> > 200          0             269,349
> >
> > refault_anon
> > swappiness   CLRU          MGLRU(no patches)
> > 1            738,618       578,308
> > 36           451,410       665,723
> > 71           514,961       657,870
> > 106          633,161       786,893
> > 141          648,640       662,673
> > 176          668,779       708,969
> > 200          4,816,312     672,514
>
> Hi Barry,
>
> Thanks for pushing this series forward!
>
> One nit pick so far is the test data seems redundant with the one
> below, maybe we can just keep one of them.

make sense to me.

>
> > This model also allows scanning and reclaiming from the two youngest
> > generations, including the youngest generation itself. This can help
> > resolve OOM situations[1] and reduce the need for aging.
>
> Right, the OOM reproducer is demostrated here previously:
> https://lore.kernel.org/all/20260318-mglru-reclaim-v1-0-2c46f9eb0508@tenc=
ent.com/
>
> That series is merged at V7:
> https://lore.kernel.org/linux-mm/20260428-mglru-reclaim-v7-0-02fabb92dc43=
@tencent.com/
>
> The problem is largely eased as described, but it isn't 100% fixed at
> that time. It will still go OOM with higher pressure. So before this
> series, I could still see OOM after hundreds of loops. And problem is
> gone after the fixing patch in this series. Unfortunately it's very
> hard to reproduce and that reproducer is the best I have so far.
>

thanks! I will put this into cover-letter in the new version.

> >
> > Patch 9 from Barry fixes a cold/hot inversion exacerbated by patches
> > 1=E2=80=938 (which also exists in mainline) and improves reclaim effici=
ency.
> >
> > Patches 10-13 from Gaofei and Barry optimize aging based on folio
> > distribution imbalance and improve reclaim behavior at extreme
> > swappiness values such as 1 and 200.
> >
> > Patch 14 from Bo Zhang addresses the GFP_NOIO issue in MGLRU.
> >
> > After the patchset, the results track CLRU across the full swappiness
> > range (see table below), with more file scanning at low swappiness
> > and more anon scanning at high swappiness.
> >
> > pgsteal_file
> > swappiness   CLRU          MGLRU         MGLRU+patches
> > 1            5,894,538     756,589       7,394,183
> > 36           799,998       497,282       526,176
> > 71           548,331       415,612       433,353
> > 106          407,012       383,814       347,647
> > 141          253,737       354,249       314,437
> > 176          189,003       347,805       261,677
> > 200          0             346,078       188
> >
> > pgsteal_anon
> > swappiness   CLRU          MGLRU         MGLRU+patches
> > 1            3,962,404     2,768,654     5,362,153
> > 36           2,830,250     2,976,260     2,736,749
> > 71           3,121,386     3,142,954     3,246,589
> > 106          3,521,720     3,382,383     3,074,851
> > 141          3,504,471     2,970,859     3,178,409
> > 176          3,592,335     3,163,130     3,650,544
> > 200          14,095,617    3,209,132     14,538,399
> >
> > pgscan_file
> > swappiness   CLRU          MGLRU         MGLRU+patches
> > 1            10,270,808    886,997       16,246,260
> > 36           1,010,341     569,036       614,389
> > 71           656,136       490,972       484,769
> > 106          460,326       436,042       367,969
> > 141          295,184       403,132       328,943
> > 176          235,147       390,358       268,142
> > 200          0             398,363       188
> >
> > pgscan_anon
> > swappiness   CLRU          MGLRU         MGLRU+patches
> > 1            19,341,957    5,960,884     7,646,122
> > 36           17,530,774    6,394,951     5,914,405
> > 71           18,624,264    6,673,569     7,167,762
> > 106          20,088,558    6,976,364     7,821,921
> > 141          19,686,813    6,206,580     8,495,970
> > 176          20,936,177    6,344,854     10,585,375
> > 200          45,313,873    6,295,581     30,313,342
> >
> > refault_file
> > swappiness   CLRU          MGLRU         MGLRU+patches
> > 1            5,795,115     678,254       7,315,064
> > 36           720,877       419,659       448,199
> > 71           469,270       338,518       355,269
> > 106          331,584       308,983       270,736
> > 141          174,509       277,375       237,643
> > 176          113,352       272,390       184,908
> > 200          0             269,349       102
> >
> > refault_anon
> > swappiness   CLRU          MGLRU         MGLRU+patches
> > 1            738,618       578,308       1,383,725
> > 36           451,410       665,723       543,071
> > 71           514,961       657,870       683,874
> > 106          633,161       786,893       669,716
> > 141          648,640       662,673       719,231
> > 176          668,779       708,969       901,918
> > 200          4,816,312     672,514       5,511,787
>
> Right, that's really nice result. Do you have system time or
> performance readings? BTW for the performance reading I think we can
> focus on the 36 - 176 range. If a user asks for extreme bias towards
> anon/file, they strongly favor reclaim priority over throughput, and
> the behavior is arguable at that point.

I think the changes are really minor with the default or
moderate swappiness of around 60, probably just within
the noise of measurement.

With higher swappiness values (>140), I do see an increase
in system time. However, I think this is expected behaviour
as swappiness starts to take effect: we're swapping out and
swapping in more.

real (seconds)
swappiness   MGLRU(no patches)   MGLRU(with patches)
1            110.1               159.2
36           108.8               109.2
71           109.2               109.7
106          109.4               109.2
141          108.4               108.7
176          109.2               109.4
200          108.9               122.8

user (seconds)
swappiness   MGLRU(no patches)   MGLRU(with patches)
1            1519.3              1496.0
36           1531.4              1526.9
71           1530.6              1532.3
106          1533.4              1533.5
141          1536.2              1536.1
176          1530.9              1541.2
200          1536.1              1563.4

sys (seconds)
swappiness   MGLRU(no patches)   MGLRU(with patches)
1            218.3               392.7
36           222.8               216.8
71           221.3               225.3
106          227.0               225.6
141          219.8               231.1
176          221.8               245.1
200          221.1               496.6

As for CLRU, this is also the case:

*** Executing round 1 ***
set swappiness to 36
real 1m50.203s
user 25m23.168s
sys 3m38.826s

*** Executing round 2 ***
set swappiness to 71
real 1m49.654s
user 25m30.618s
sys 3m38.215s

*** Executing round 3 ***
set swappiness to 106
real 1m50.021s
user 25m31.175s
sys 3m51.513s

*** Executing round 4 ***
set swappiness to 141
real 1m50.912s
user 25m37.081s
sys 3m51.816s

*** Executing round 5 ***
set swappiness to 176
real 1m52.159s
user 25m41.676s
sys 3m56.990s
...

Best,
Barry

