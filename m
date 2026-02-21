Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D012C61DDE
	for <linux-mm@archiver.kernel.org>; Sat, 21 Feb 2026 09:30:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF3CC6B0005; Sat, 21 Feb 2026 04:30:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA1986B0089; Sat, 21 Feb 2026 04:30:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA0766B008A; Sat, 21 Feb 2026 04:30:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 963376B0005
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 04:30:30 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 31C0D57192
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 09:30:30 +0000 (UTC)
X-FDA: 84467943420.15.C50C563
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4955280002
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 09:30:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=k7TC17dq;
	spf=pass (imf02.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.49 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771666228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nSs1kiH4UgjbK6XO+/po2020yekHGxUvh25+4x+p9MY=;
	b=FGgKIG4xypWaK4mr6VRWt9McjTUke0/X6Q1NFgRfPVO1Zd7+T7UogZOQ+n7/djf1iBdr5x
	UFapNkVH7T46acuBPGkS6BnCF4AcCi3uPkWNeeBMo5yeoG3TwGaLloaWad65RcpA4WAoS7
	aDCpsP5ctMwB+HgPZsCUIg+fZH/G45g=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=k7TC17dq;
	spf=pass (imf02.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.49 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771666228; a=rsa-sha256;
	cv=pass;
	b=OOd1sYupA30WsT0lYc7sJ6VxJhak3OIupz2lDu9TTu+wnfn34o9wCGXz3o9JNRtxD20g5E
	Uqm7paPY+EU51gMZUTXAaSV5kG901KTzeJwg/CW+Bq7BWLWcfWenzidngs/6a3l0ra/QzI
	4BQGjYseL/bMpW2+5S4lsqZXZiLYPYY=
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-896f82e5961so40950936d6.0
        for <linux-mm@kvack.org>; Sat, 21 Feb 2026 01:30:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771666227; cv=none;
        d=google.com; s=arc-20240605;
        b=ioHryL2iHMrZRH8vQNrZR9GMJf1KG3nOIPP7vergc17dPmxvPgD9HCcmlO1r6aSChq
         2mlp2HDq+egNOu+u144HFrI6WXjbDtje+Q2umBtGHLZBgOXUGO5KGub8fEMLIi5adm4V
         X5CIyNheO3aS+AdcQWmbuxvs2VCa1MlOF+JnFWWWPX5LFHlkDZSvlwP0S7HtyZReEL1O
         L2W3rQ1AyFUxVIX+0dJusYVZzGU1RqIKGS2Ag+/g3wa0vkNtpfW8lLf3PJ6tMGWXdxrX
         Hx2Ib06hl8obmKd8sdSXuF1rcHEXkk6ONirtOPqAwQX6EHclqlui7nNGTWXzF+mGyNZb
         clPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nSs1kiH4UgjbK6XO+/po2020yekHGxUvh25+4x+p9MY=;
        fh=E1072Ew8pceVyonKHvoWOrGVf1qNpk2VPzz/G+P/TXg=;
        b=bDPhqZzSAlHcmfqn4lHJQFOAxDlpsvS+u01jN/4rko0Oczs5pYuS2GqEp9UX3WEmP6
         gkp5lEPCGzMRwv0BbGC1poU61GPJFBGLLSvcEMtXTQ1slgv1ePhoWiOLWqiU+zDjhqFi
         FU/Mdpj54CDfQi5ZoHDRrvxGKL/yOHqLwIohZmKKr4vkZUCr16j3mHv6q6afLZ2Nc0N1
         Ada/zFgTCrpsOsVVUDXnMils3i93ZW35ceCjOGaCNjObfUz9nHeu3fSa6DeW7YfNhvIc
         /yVm5kAM1kFWcz844bfEPA0ehpLTYTjNUprRtomK6FQyI4MBu2Zuxq2/LFNWT2Rqj3QQ
         bFLw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771666227; x=1772271027; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nSs1kiH4UgjbK6XO+/po2020yekHGxUvh25+4x+p9MY=;
        b=k7TC17dqPfSuySOyJYO1GNL0opPjtbLGP9hIW4KbQKPL61JO+HfGVJZU2VYKE3Pcdf
         nwWjsoBvffSSJvhP5dTAt96gvGv72uhZFsQXleOvYG4Qfl1itZ8s3hXHWNkbbKLg+4LZ
         4Nhr4PI9rF5cJjONi19N0QQTvoqJuM3fdbegIC1Bi+h03nCg+Yg+7BhyuDFRCKosuh7j
         cQnAjjZUmZJ/XUqnEMYlv/VtIZqG+H/sevEezRJqKRWJ98ci3i5iVv1twSXmilcek1LH
         fZ4TnusIovW9To34bCM0NU38e9uG3tx5QseQjzmmKnUCz5RnuBAJx6Elwj31UZtZ9VjT
         3ffQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771666227; x=1772271027;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nSs1kiH4UgjbK6XO+/po2020yekHGxUvh25+4x+p9MY=;
        b=mAYKG5YWOg5gzUfFGoR1DjpOsB4kHzpumTrEpHQWwIH01ckUvMlXkQGejN4JKqFMyn
         5+sUgzagPQWO+d41gd+MncGx1ld0qGKEA/NFvtr6vv93yZV4hEDxHYsYyYto26sOQU0x
         QfjRq3q7aRNNe6keFjNSK2+7aN15dKsKb0v7xcwP5x3GCJFgSeyV+cxWwSSIeIZrUMSR
         UHi+E0OYVaug35zVkQYmaqjB8MiAYpiqkDaKRetNEsp4AIaogrPkE4pruEzeEha2g1Wv
         s0WphyYMcvo/+Srl7Yk7k/y7Wf5j3HVUdKMKWSades8Id+fRGHgvDxQq8tlHSy+MMYd9
         hpKA==
X-Gm-Message-State: AOJu0YxrfrcF1BkQn8jurNKgUIz2oZMgGRqVCa9CkOnwSChNO6VGCZUw
	ZeYPS9JCEd5FStIyflRW/T3cwCd9hAjMPa6+95xa52Q//ocGi2LromDP0ZMkSmUCC91b5tVvqoG
	36lwgVNdlJMVyE6M6/f+BU+TTCMS+KJs=
X-Gm-Gg: AZuq6aI1HtFnSgBLo+6k1xsrds6K25KLZLng88N6o5f1KVIpBPY48ZJwuWUyMOC0pDS
	VKG1EoxE62ulx29FpJMk3vA3pzhcMyvHzDBmJeoFKB2FWIhZ3iQ2kKROKIffO0BCKEcmQVbEDuU
	2YxNVTxKKDn9XgDM64FuaM8B9aD6fwpbgLfv/s72XnDnaDIJL76F1DM59lA+3s5FPxU5bZh+WU0
	ePtsHG4JLVTrIPuN5SevdE5AV/Or9CNyr3nsUIr3D2+TkdmHxGzB9bozpqCEdOJwEwFIS2fsf26
	HY7Www==
X-Received: by 2002:a05:6214:27c6:b0:895:54f:d8d with SMTP id
 6a1803df08f44-89979c55838mr38346736d6.12.1771666227043; Sat, 21 Feb 2026
 01:30:27 -0800 (PST)
MIME-Version: 1.0
References: <20260220-swap-table-p4-v1-0-104795d19815@tencent.com>
 <CAGsJ_4xF5sK8H1RsqRNoi7DfGBtThASsozY30gq_kdRLaYgaTw@mail.gmail.com> <CAMgjq7CXgGxhtU3XJYnxVQ8fFYtNZBN3uF4FgqbBVV75ohOhtg@mail.gmail.com>
In-Reply-To: <CAMgjq7CXgGxhtU3XJYnxVQ8fFYtNZBN3uF4FgqbBVV75ohOhtg@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Sat, 21 Feb 2026 17:30:15 +0800
X-Gm-Features: AaiRm50VzHuZ3t2BF9KIHE7v476R9sPS41fw5BuYxm6USO1DUS_s-bOs-YtbGr8
Message-ID: <CAGsJ_4zewviHRYcDVe5RSDKR5XyRppLj=7BN4dyyCCGDTKhD1A@mail.gmail.com>
Subject: Re: [PATCH RFC 00/15] mm, swap: swap table phase IV with dynamic
 ghost swapfile
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Hugh Dickins <hughd@google.com>, 
	Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Youngjun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 4955280002
X-Stat-Signature: f5s6hz9jw5r5awbyw6yzzp87znzyg7ys
X-HE-Tag: 1771666228-492178
X-HE-Meta: U2FsdGVkX1+t3H7gnpEmmpQwfmy2no6Kf7mX0QZ81+udwX2cCaGMvStmeqK64jRaOQH6LSXQA60AoeHgZfdp9CUNN15hbwxzko6RyjOKxL1Ugh9GVOaC8xDGNpoQBKmVgiLp9jZzoToRzJPcG8UaWineYpTi8R0y/ssQg1vejPzMr9GTzoWVra5QheLxIxFPvE5H9H+q+1XeSoDBgJkZ1gZpfk4w1bSdzkb9MBOu+CZw6s+yYZWZQMYzx/QVRona75OJAgkivNE4VYlqGVADvDqjvEeGyfFcf+3tP3+mb5oWzkvIuJVqikKE8JVNKWzTjx4sEo+StqBBWVapxzATHe6xODiHXaBxAKn/kjk6dtTzI/4yFgJDFl6xUugfVAdi/CZb1h51EBb/TRUhfBumwhxji6e7z6w3yTGvYDONNMExv0X6OqIKC8Esm5FTNBymt6+RyNOvfQEbycDtWJ8KYPi0XpKCF/Mu92MdSM7wqtHfDMkARAn3R6ENi7hSeeukyBwrCDmjw49S7K4E2f1Vfe0sh4J9tK9kzxhkwz/p91iMqv8YWf3kKEbq3RRGk23gsZHPtj40h1Rb5OAYJjwUCey9MQuEU2XuwZzyMXqEtlApZcoDKAg8ODouRYgQRU0pxsjH/WiZwu+gRWrhW/6QoYfDHvJHR2ck2f/Tdmv5CdpAo2cJ1+KMnRVqOqJSg2J80LJ9GrsRfovQJYtrFb8N9bC19j99RZ5h096tLM5IG487JZUv/5vrBg/F8+PKs0PFIM//15Gjt82wZwJBR8Y6ubUXriYSpk8xiPNvwHDxb2f+lGP6GSBFd3wtVvt/7A3R3oamtsK6xQ7f/MLn3PwNAK6zkAjzdYORSpQkGsqYvTMWuLJ92m7dd+xs9EIVmibz26ST0Xa1tkcwRWJjNB4JY5al1pWyOA9sSLg60+xbdQZQmKdxrncJ7pz/0iR76ygJWBXmpDXggh2UZb5MpCX
 T5FNJpEo
 80lyKCEmLsPDpX/5NGrC5EOSPf+s0sWwDZ8ekEI7nov3kuF8cvtcJQaNDFxu/Aw8HDjWLks0QcpvCj7j8xFkNSJIYG5C9Td2Vb5hRbkHp4rTYGSnjJAWlYJBZgGZCa6HIbDddWZjgWZ/TufjD71F8mFUVInfkcksJXD5w02RcgFq+XtLDYyczeYiZkCOA3tPGfrGaMVPuw4798Ext95NNhIkHFNozCKsZkaYzYgkaTvKsbQNVaC42CvB4z0D05YsEM+1jcGDsn1zCjSe6wDwKiddjal92G49BROJRlxnnCH7a1AjceO2mLjPqznYP435conI41qgiQAZ6jyWVm+/wnRgSVU9Y5m8XR00zYmPUaexjk55fJ4na4Ky+5zHAlOCR0cEHo5Y4cF/PhcVWJ6JUcMR/3ob6NFg27CoOqCALzpGg8d0PXtas9lxrRtlEag/QBCyZxzQiSg6z47oQhUxChXZqrvwJuK6AgHFp7e1ZCpayMyCOwEsXp8SR3BVoWtMN7iPh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Feb 21, 2026 at 5:07=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Sat, Feb 21, 2026 at 4:16=E2=80=AFPM Barry Song <21cnbao@gmail.com> wr=
ote:
> >
> > On Fri, Feb 20, 2026 at 7:42=E2=80=AFAM Kairui Song via B4 Relay
> > <devnull+kasong.tencent.com@kernel.org> wrote:
> >
> > To be honest, I really dislike the name "ghost." I would
> > prefer something that reflects its actual functionality.
> > "Ghost" does not describe what it does and feels rather
> > arbitrary.
>
> Hi Barry,
>
> That can be easily changed by "search and replace", I just kept the
> name since patch 13 is directly from Chris and I just didn't change
> it.
>
> >
> > I suggest retiring the name "ghost" and replacing it with
> > something more appropriate. "vswap" could be a good option,
>
> That looks good to me too, you can also check the slide from LSFMM
> last year page 23 to see how I imaged thing would workout at that
> time:
> https://drive.google.com/file/d/1_QKlXErUkQ-TXmJJy79fJoLPui9TGK1S/view
>
> The actual layout will be a bit different from that slide, since the
> redirect entry will be in the lower devices, the virtual device will
> have an extra virtual table to hold its redirect entry. But still I'm
> glad that plain swap still has zero overhead so ZRAM or high
> performance NVME is still good.
>
> > > Currently, the dynamic ghost files are just reported as ordinary swap=
 files
> > > in /proc/swaps and we can have multiple ones, so users will have a fu=
ll
> > > view of what's going on. This is a very easy-to-change design decisio=
n.
> > > I'm open to ideas about how we should present this to users. e.g., Hi=
ding
> > > it will make it more "virtual", but I don't think that's a good idea.
> >
> > Even if it remains visible in /proc/swaps, I would rather
> > not represent it as a real file in any filesystem. Putting
> > a "ghost" swapfile on something like ext4 seems unnatural.
>
> How do you think about this? Here is the output after this sereis:
> # swapon
> NAME           TYPE       SIZE USED PRIO
> /dev/ghostswap ghost     11.5G 821M   -1
> /dev/ram0      partition 1024G 9.9M   -1
> /dev/vdb2      partition    2G 112K   -1

I=E2=80=99d rather have a =E2=80=9Cvirtual=E2=80=9D block device, /dev/xswa=
p, with
its size displayed as 11.5G via `ls -l filename`. This is
also more natural than relying on a cdev placeholder.

If

>
> Or we can rename it to:
> # swapon
> NAME           TYPE       SIZE USED PRIO
> /dev/xswap     xswap     11.5G 821M   -1
> /dev/ram0      partition 1024G 9.9M   -1
> /dev/vdb2      partition    2G 112K   -1
>
> swapon /dev/xswap will enable this layer (for now I just hardcoded it
> to be 8 times the size of total ram). swapoff /dev/xswap disables it.
> We can also change the priority.
>
> We can also hide it.
>
> > > And for easier testing, I added a /dev/ghostswap in this RFC. `swapon
> > > /dev/ghostswap` enables that. Without swapon /dev/ghostswap, any exis=
ting
> > > users, including ZRAM, won't observe any change.
> >
> > /dev/ghostswap is assumed to be a virtual block device or
> > something similar? If it is a block device, how is its size
> > related to si->size?
>
> It's not a real device, just a placeholder to make swapon usable
> without any modification for easier testing (some user space
> implementation doesn't work well with dummy header). And it has
> nothing to do with the si->size.

I understand it is a placeholder for swap, but if it appears
as /dev/ghostfile, users browsing /dev/ will see it as a
real cdev. A /dev/chardev is intended for user read/write
access.
Also, udev rules can act on an exported cdev. This couples
us with a lot of userspace behavior.

>
> >
> > Looking at [PATCH RFC 14/15] mm, swap: add a special device
> > for ghost swap setup, it appears to be a character device.
> > This feels very odd to me. I=E2=80=99m not in favor of coupling the
> > ghost swapfile with a memdev character device.
> > A cdev should be a true character device.
>
> No coupling at all, it's just a place holder so swapon (the syscall)
> knows it's a virtual device, which is just an alternative to the dummy
> header approach from Chris, so people can test it easier.

Using a cdev as a placeholder has introduced behavioral
coupling. For swap, it serves as a placeholder; for anything
outside swap, it behaves as a regular cdev.

>
> The si->size is just a number and any value can be given. I just
> haven't decided how we should pass the number to the kernel or just
> make it dynamic: e.g. set it to total ram size and increase by 2M
> every time a new cluster is used.

