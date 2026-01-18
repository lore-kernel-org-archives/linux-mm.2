Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FEBFD4A5F4
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 04:21:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 467746B0005; Sat, 17 Jan 2026 23:21:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4159E6B0089; Sat, 17 Jan 2026 23:21:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F74F6B008A; Sat, 17 Jan 2026 23:21:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1E2566B0005
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 23:21:30 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B3E21D1D5F
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 04:21:29 +0000 (UTC)
X-FDA: 84343785498.30.1DF157B
Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	by imf22.hostedemail.com (Postfix) with ESMTP id CBAF7C0006
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 04:21:27 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GkwTnlVk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of kartikey406@gmail.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=kartikey406@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768710087; a=rsa-sha256;
	cv=none;
	b=aaq0hkJeRcSBDonBGQU58VaE4U8+sqRoLlYG2zC4ln/a3xGeLsMz/ZCTnw51lwOP+RMvOD
	FfRiezP/2EjUNS9dk6f/vGJxiABDVEuxI2RYG1hpMqseQH4kfooJ+kOLjOkNG1cT30TONt
	BhlQ6cNSmM3FwdnfquC8+jlIhvsI9yE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GkwTnlVk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of kartikey406@gmail.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=kartikey406@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768710087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jvMq2ABTBLrDp9blsAOvXWpoeYwpBXEHUIYBa0P2DU0=;
	b=APf+0UXWbmpcxpxrOrWpGbd/AlHziyAIgWqw3055htxxUJndhiMAB2mJ0MRPPtbOFw9lx/
	IAWMNcdllTlZ9A8fXXfEkbKwHIMu6/J4PfSrrZYoT11xVD3sHvdHAo+F22/OCuEx21W3KN
	2AAQqrvfQGmiJ1d8I+Ub2OSOPJGMYi4=
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-6442e2dd8bbso2449494d50.0
        for <linux-mm@kvack.org>; Sat, 17 Jan 2026 20:21:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768710087; x=1769314887; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jvMq2ABTBLrDp9blsAOvXWpoeYwpBXEHUIYBa0P2DU0=;
        b=GkwTnlVkx0MXUlnHjlDN96HdY+b4BqJK9KPZ9eynt4uzrwFPfami6ODhO7a9MjyaEA
         /qmQtfaYdFddFGRjlueavA73xZVThHiwGe+Auo7TIcHtkrS1WgmQXQgRoEHRVBJ+ffjH
         oAwY3KvT3WsYJvNsQmgSmpIPiWf/RaFSRTfkDlM7noRdE/Wqid1gox5QUdaXt0WsOb3C
         95EFUPJA7dSybpIs8uKkSV+KSm5J4jOPXOTkeVqcrQOJRaKZwa5QgCXy3Fjsc1xFVYKy
         lfyUgnh5MGQAmOB9e4zibbivri5PXz4f2j5DZXZninNqkfnGxqpTY29l48SRT6FPKvmy
         Jv9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768710087; x=1769314887;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jvMq2ABTBLrDp9blsAOvXWpoeYwpBXEHUIYBa0P2DU0=;
        b=ftEgGXsQxGO+iw+/8eWqCojYLLg34nQ2XHCXUwIf2cD4AMnLRW/IE502BEkzgHV8sj
         8zIUO83gSo5vf5/9Ckuh7HJAYjXOAdLaAVpbi9ckBXAj5kWDuO6Mlp4A0g8KaPIKSL/F
         FuTg1P3LQn3eqmjUnp4xbtYJAQRCgKKIK/PdnDCOYBEdzPkvqCFeBVG0X5ssfIpI+a+m
         M9cHl9CSmIKpYu5bAv8LWO2Dlo6sVrxw6yejsCGx4JevLLGibIeXUahdlJho6gH1hl9K
         P4GZ2pdPQbamqgS3HGMjycG2o4ZMn17OY4DLhzfMzGcYXP+bbt+MjngpH2XtrszG98v3
         KzLQ==
X-Forwarded-Encrypted: i=1; AJvYcCUgxph3sokHzVdWeRKW+GGJ69YAvuLXFYMij7J7lR3O36W5l/FaMi4UuBSjQxFP227r+GTE6VWGiQ==@kvack.org
X-Gm-Message-State: AOJu0YzmdDi55V/wpidGKxNijcRpoyZUwUOF4y8GiYhGlyAoI4e0x9oN
	yoVsoEeHV+sxsHkIglBp0XtD7w3WQtmGNIpIRo/idDgNcNhYctviuwXJCqV+TlVXiMEHKxT2uTN
	j3HShpEnZdd/FxKT6Je0NbJtxLHcy58I=
X-Gm-Gg: AY/fxX6vi5g+nCig2bcq0sSmry4LKPZ21TpSxn/V5aB3gLojSvF8plyP3BOzcWjPHRM
	imfAnR7s5qfKwgN52ZeUiBImL5bTlrU3cHWJ8CTgcdoWFvrHbq2WSbsBE5yuGxpVhsKIsmSKYoZ
	JM3BnRNFXWK6tWICG1y5tb5r+63Ci+j5buxmj6wtnJ7EiEtezFV6laDY776sSCZSfJmoDCJ3h2z
	3uuXa7H8EBz7qgrqSMCIJ43KNjX1sDlxRJbvoOKX0rVCAAmWVWCE82FW73cshIlxobc2LlWF7IL
	TmR3Htd9m6CzUNoGaDeGtzuTQ0wf9PBpBNAL7Ja3h4Ssl51NwR747O+erwE=
X-Received: by 2002:a05:690e:1302:b0:63f:9a63:46e5 with SMTP id
 956f58d0204a3-64916485743mr6337211d50.28.1768710086767; Sat, 17 Jan 2026
 20:21:26 -0800 (PST)
MIME-Version: 1.0
References: <696b56b1.050a0220.3390f1.0007.GAE@google.com> <20260117165722.6dc25d72fd58254cb89e711b@linux-foundation.org>
In-Reply-To: <20260117165722.6dc25d72fd58254cb89e711b@linux-foundation.org>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Sun, 18 Jan 2026 09:51:15 +0530
X-Gm-Features: AZwV_QixRjSHf6Sj2BD4t0Ssbbsgw1OyPwSQbE8CQ4kPIPXAspb8klvrwkVJpOY
Message-ID: <CADhLXY6ACKeyLrjARTTdfWyrvUdLbtD-wXiQvsvhsbGjwmUqDA@mail.gmail.com>
Subject: Re: [syzbot] [cgroups?] [mm?] WARNING in memcg1_swapout
To: Andrew Morton <akpm@linux-foundation.org>
Cc: syzbot <syzbot+079a3b213add54dd18a7@syzkaller.appspotmail.com>, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	syzkaller-bugs@googlegroups.com, Johannes Weiner <hannes@cmpxchg.org>, 
	Muchun Song <muchun.song@linux.dev>, Minchan Kim <minchan@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: CBAF7C0006
X-Rspamd-Server: rspam06
X-Stat-Signature: saipb4edzney6go6715founc45zt1gwe
X-Rspam-User: 
X-HE-Tag: 1768710087-474148
X-HE-Meta: U2FsdGVkX1851VXanbUJYzfwnxZUWSoqLvezi0+4F6eTCb/idKxqyFw7VYxy1HhpNKkEYW/lCdUMGjt7LiNBu7mcvoE6YjgXiuJ1iZm7Xd26Tehhzpoe8LnmwxOLDp5gThN+9kzq/Z8sme5JrhseI72NnsbvSYKeGBcv+sCIUMDRPNkXNxJc6ZtLpniDL2cgfCpkYb5rScYLF5NUXImiWrVnC5ZeNP6j+Kp4kvRET0qO7wwqDtY8bdT7Zm1z/YMg3DYhmirxwdpJQFHg6G3X9Ym6+/E6FFLTa9avEgLxz7XJYelJobsFjjpRdJjUzGMHzLefoINQtZ/SJ1w0BRbJqTZ1QPs8EDsNBTr8dVt2dUoySsqaCaTtSnxHElvt4OBN5jwb73wv9IVgSwSBdIHw4PESWFJ62eVhVFPOROwLlBjwG+FAuauPF2PK6kEmzAPem5sqLxPy2jkKdLxnLuxVioAFISSQdco1DdmiAQwOed/3+WIBkT2RRqR6ZVEb6JUfJOyn4SiaIyEa7mxOFUxfY9FxnwIBnFeLnqVwKJv/9KEgkyT2g0elrGlC6cBUP7P+YYxKApMELEUHgM5tc46LjVGdsGKFOywp9ozI4iTDOdl8CV/X2s7sCpSn3dqJPERU2eU4kxm+XcwT1QI9Y1SgvTv6Nrn28oMK3YyuGEPhn201xX4YbVYaUoP86sNd5xfU5ycjt9gSd4gCQB+9uskDynEVjFd02kZrA9Dr+9OcpAn18dBZLbifZD43YcOPPKFU/QcIkEkU202y6Zc7yA/9ykK1y1oZof8P5hXRKjEIp1L0IaMDhgFGyV9RoxZhypQUzP1vUcWPECa3/Zk1s/ddA0/WtwqjRzKG5HNGHMh16Hr5ZaLlGclP/tichbSliheAFJtZbv+hGpGOYPMhRwXiBqFk5wIA0NVkzXoBSE41Q4U45BvPyG0GZEwaZG9Fk+mobOmtE7QCsNaPwu377kq
 B+eAqVbM
 8IhoR5pgFBU0jezsvxRmlLM4tQXSmLGbbnVyk1U1GxmgnxadWfpuZHHgF9f8J4yI8GqfjGEkLEhp3cW/Y01FbLSeYOiYLjqVcejiA4P+TDZHHsYc9jWxNA5fvcnZFe08/IdK/8AONjSvCyj+eizvNeI/ZgUwyyLXc8IgbZG+QqbuctUGn5g2aZ0TB9RF2uk7a5i0rqDKLrYFJxo2pQevVqnsvH7n4pJ+gPWtfXp+GxiNHHlIzcoEUiCb9JCtllQc9n5yKnMB9zSLGWzGu2xbETY24NkE5+lMapLuuuBPugC1vZjj1E4Co7WykfJCH4ROlD8jLwC6wcOBYeThR7qLnBkFvBdIxg2rQHDS5rIUbavXlTe8JiXtK6+zjBw6kFZ3GR4KES8FoVBj1NEWquxBoGVInMD52AbiBDzZg0SqLITMyEGfrwMmmMF3isLeAh1E6ay805FYMOsj9m0D9DugbYw7SySm7jwcER3kuRMc2kuT8H/IihWwmbOTBP/Wa4fM7A9fGH1AbtoRB5HJcOSy3Tt29+M6blXy1Fuzt2Kuops3xM7cxsCTSQ0bQdZY09Jn8f8I2IPgXH39GKpisezHtxNGbluDczZaMRjPdW7Xcru5RzLGfcRVr+drRO6ehLKqN1WscTB6u1danbbQJfU2HwyJR7ixQlr3LIY/R5JWzZI5pJkSme3dtvQyMXzZrAV6gcfSEDKVjnw0uhuCaju6FmXUZvj1uJP4tlPknAscjylwCPsog1w1x/kZVOiiVSoW5QT5sWperjUZm3nX6ex/OlkA2Z64Mq4qvtqeFHxzfxO/r08IV9GDBj5NtanE4JcZ8+7Lp6TzF+5O311bEGjnTFB281NyuHG0CR7xg5ptQi1vbflkFxmE1CqzzC3ERVr676JRkLtn9gol6d44cDWQtwGmb2oqFYFlVHmjLFkXg+0/LH6Z0bS6lm6rfoPPMxNDZ/4IRaOgfviC86InJ6GC3Vr5jxR7n
 xBDd+AXA
 K7P3QTwHNc3sx9G/qcMAJcLnsK+HeZ6s43wS2WFJrkjeS/9ZnYnvU4Xh+Ye+Xp04eRQLwTFTworKADSOjKhSQJRKY/IS5yxG3sCwKPJRMKP7iQ08vnIQtA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jan 18, 2026 at 6:27=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Sat, 17 Jan 2026 01:30:25 -0800 syzbot <syzbot+079a3b213add54dd18a7@sy=
zkaller.appspotmail.com> wrote:
>
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    0f853ca2a798 Add linux-next specific files for 20260113
> > git tree:       linux-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D14f7259a580=
000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3D8d6e5303d96=
e21b5
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3D079a3b213add5=
4dd18a7
> > compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7=
976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D167ef9225=
80000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D16d295fa580=
000
> >
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/480cd223f3f6/d=
isk-0f853ca2.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/1ca2f0dbb7cc/vmli=
nux-0f853ca2.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/60a0fef5805b=
/bzImage-0f853ca2.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the co=
mmit:
> > Reported-by: syzbot+079a3b213add54dd18a7@syzkaller.appspotmail.com
>
> Thanks.
>
> > ------------[ cut here ]------------
> > WARNING: mm/memcontrol-v1.c:642 at memcg1_swapout+0x6c2/0x8d0 mm/memcon=
trol-v1.c:642, CPU#0: syz.4.233/6746
>
> That's
>
>         VM_WARN_ON_ONCE(oldid !=3D 0);
>
> which was added by Deepanshu's "mm/swap_cgroup: fix kernel BUG in
> swap_cgroup_record".
>
> This patch has Fixes: 1a4e58cce84e ("mm: introduce MADV_PAGEOUT"),
> which is six years old.  For some reason it has no cc:stable.
>
> Deepanshu's patch has no reviews.
>
> So can I please do the memcg maintainer summoning dance here?  We have a
> repeatable BUG happening in mainline Linux.
>

Hi Andrew,

I checked the git blame output for commit 0f853ca2a798:

Line 763: memcg1_swapout(folio, swap);
Line 764: __swap_cache_del_folio(ci, folio, swap, shadow);
                    (d7a7b2f91f36b - Kairui Song, 2026-01-13 02:33:36 +0800=
)

Kairui's reordering patch appears to have been merged on Jan 13.
The syzbot report is also from Jan 13, likely from earlier in the
day before the reordering patch was merged.

So this report is from before the fix. The warning should not appear
in linux-next builds after Jan 13.

Thanks,

Deepanshu

