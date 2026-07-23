Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4F2CC44532
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 00:49:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B683B6B00DD; Wed, 22 Jul 2026 20:49:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3EF36B00DF; Wed, 22 Jul 2026 20:49:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A07486B00E0; Wed, 22 Jul 2026 20:49:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5FE186B00DD
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 20:49:25 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D8DA612034B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 00:49:24 +0000 (UTC)
X-FDA: 85018207848.22.13F3846
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0EA7240004
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 00:49:22 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fg6XJpBy;
	spf=pass (imf11.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784767763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fyTd7T6rUzEB3/oICDROxSxSl5Otj7aDGzpt3a8utTA=;
	b=FBC7jbRUUl4QplFWP+4Qwm/c5o3eJntk/U9Q0DoU9+3GhVMmZqs/kQnFRNnc1uocbuIyL0
	hbZyCRIoQglCWjRF2IDa4jC9T28KQ4c/0YO3QAAgbvAnHWJ0hV/cH64PZr5865unnAkURr
	eIUUxcZvSxC9SL17u83tzAvNZDtXdEs=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784767763;
	b=Km8LVuK/z5NxZgV/tTtVXt2jwiDZWnGUS3OG7eQf1PCjDDQTxF5hrrR3iO+QYYzEHWstVS
	tjT3RihSv7f4I/LvGxrWSkawqHwt2VIOMalvQjxsiAGt4FQBe5LjbGj+T8FmpflTzL/GHe
	WCMCrGNyTB1Q1xUdjaMYTbFBAQf3XcY=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fg6XJpBy;
	spf=pass (imf11.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-47f707e5d75so27737f8f.1
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 17:49:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784767761; cv=none;
        d=google.com; s=arc-20260327;
        b=cA6u2e3OuZora5sd0842BeIORY6I+SWhHiC388BiSJTkhD8Q9dBP+Inzjo91nT7/zW
         ec6miVoVbypgwZtMuwwtK08uc0cYk+DQ6Mnisqj7lfgG69/QwScpdy7TkhIJDLfKpdSS
         WTLQ5cmH6E/obzh+nGs0k4cWlGZ4JCnFYdG7zn+yuykGG+P414/B2w9YBM01MFe/uX04
         yxLmbKrSCc5QctycILICz3/GufiO16Sd6mGQIw00otFcoHkUnfK/R5srpcEfpn8uqVhR
         z7n68L28KHmqQiaGbutgvJ3TuGN/jcyMj6jhkNSOyLM5c5LdPuNoCK55G3GnZ5HMI4VC
         eDYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fyTd7T6rUzEB3/oICDROxSxSl5Otj7aDGzpt3a8utTA=;
        fh=Tc/aLweBsa0xbbqVM6ol2N0BOMwFMr9HApctnn/RP6Q=;
        b=SNFgltgAFkNcnwU1UDs0r9vjoYv+A0jTB0TQGhkLuTfrTW4WAui8WiMAnNCcTjvz9Q
         wLILik1j/aqtPU6wbG65/6tJZmKRkdSJIeXzgtbtKykJQBO9onwPxVRVyY1p33ZCIjEh
         GKnLmX9JWRJAiab8fZvJPvdX8+AbFpYHk19ujDEa37V6kCZOlpUgvqJM0BsDSAaC5jJB
         Mix3cLPKpyp4HluO5hdcovhI4ImJNHC/IhySADTREofokc44JHhv0cqcoZWfgqIHNuBI
         bFaWHdaBTVL+coAqpQ2m8mQaafaahULYnezSx9hDK1hk7I0RlTPUlVC5J7br9MhA8bwT
         OAeA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784767761; x=1785372561; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fyTd7T6rUzEB3/oICDROxSxSl5Otj7aDGzpt3a8utTA=;
        b=fg6XJpByNevTvDot74DWvben2XDgkm4ljcu4lH2uREKmq8vT3qbCIP2FOTqjkwsHxt
         N9u8f3QTgy80+t/ElsSsG0cC4Q18REX6aPte6MvWn44hUl0f/bo2BBrU1LvwxKv2Z04k
         5Hu7Yuhx1DDaMMQnD5F0BUiqMjPKdeGLqsq6szHUeMGav74NIuW2/yCosihFbt142pbw
         LenQkFc6jtHjHJKbTPV85OgeN6aXFvYUjXzspC8iDTWGgP9TniCOs0ko7hAoHsMaBEDw
         aE0ul0X7X4Ki6ABt9VzlYNkoiQd4Lu9yDBItsFyvFbGIs8jhjdaRlELVH1fhgjd+7JX2
         mPRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784767761; x=1785372561;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fyTd7T6rUzEB3/oICDROxSxSl5Otj7aDGzpt3a8utTA=;
        b=iMxkpxJkDgEtqhyGpY7piQspFS4kXpKIF41MvG96ZPIBvqrL4gzZIf5oa8Ao7k3QGy
         CqBWSPWmW/fqxzPgho6N1qnKPfsAtEYDRVlT3J1F8v0ELIGkrJYj7saG4e7+ez3oe2sS
         cE5r6DGhBLXA9u7Znjsjp9epJoznYo3mjF1IizEGBOaHhL4gbscJKZNy0UiISZYjwcGP
         DYaFMKdy3/kPH1n04wEdU9G2LmK9tgNZZiu5kBoOkfAZ0bdXmbrec6UZX/Tt32ZAcvCH
         WZ64ZfmBYSLdnSFUAeTmb9WoAmKLR7BT4jh26ljS8v9aDOnnBuquMNsIJr4VVpvxqFVU
         CZuQ==
X-Gm-Message-State: AOJu0YxUvTw5mE3Es1q2FQ/gwOtDoeSCnhtZwsb3y0000pdhDIL7AmOv
	hWgvd7ig8Z6E/Z+gnYax2eANhIBEmoFW0tOcRAu8NfqmHTiP0Ub13i9ZMn1/ogNXQa2llVmsGbI
	vJ0vIm2yudgtYHljRtfZEFQT23JSQkjY=
X-Gm-Gg: AR+sD105MIpH+wHDFg6x0pYEE+jRR5+69ub4rmh34jGVafquxAhSyzG0HzQE68tNGsS
	I6Eo9MOlTHrgxC73PKghcOr1ow43XZ29Nn+e/ia3JGUEYE1de0yRmqX693EemjbGiRXXI0nCq59
	h5sAjEco91RWcT10a/HDuZeePeP9oRPo7K7UTaKWALaIEwcHlQ4b7olK0qeikcVX0bJXFWW+ctz
	SNGv3qoJqxEyYsoxL+rpNehqnbakc1GsS38Up6hoWYrtrWOXqnBmZBnivm+1ONqWlHAHdAyap8k
	4Mt+ns7fs2HKYoZ0sYYTfDHHCOfnSnzARcXMnBsSuw==
X-Received: by 2002:a5d:5d0f:0:b0:47f:5369:bba with SMTP id
 ffacd0b85a97d-47f8da7f6c1mr1093188f8f.15.1784767761397; Wed, 22 Jul 2026
 17:49:21 -0700 (PDT)
MIME-Version: 1.0
References: <20260502-mglru-fg-v1-0-913619b014d9@tencent.com>
 <CAJnrk1b-5eQrPtug7i7n0h7=j0gaaGhihf3tbBZLfxz5fABUiw@mail.gmail.com> <CAMgjq7CmQjuOgeU5XOEwA532TB0=8U2aDXBz_prKVdFY0uyxWQ@mail.gmail.com>
In-Reply-To: <CAMgjq7CmQjuOgeU5XOEwA532TB0=8U2aDXBz_prKVdFY0uyxWQ@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 22 Jul 2026 17:49:08 -0700
X-Gm-Features: AUfX_myussgyhcuM93cCQAQlCgWCScVh7Ij_fRdmm-RY4EMqkWgA_IEBZnGIj5Q
Message-ID: <CAJnrk1YqpLhsbC5m0vL-w3HG8dXGSPOH7Qq3-XAnJYTBdgN9qQ@mail.gmail.com>
Subject: Re: [PATCH RFC 00/32] mm/mglru: MGLRU-FG and refault distance support
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, SeongJae Park <sj@kernel.org>, 
	David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@huaweicloud.com>, Tal Zussman <tz2294@columbia.edu>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 0EA7240004
X-Stat-Signature: 7pn6zxeeaepjnzuexowfxbc65enhmhjr
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784767762-435233
X-HE-Meta: U2FsdGVkX1//22EpK+EM3foRSTXfU07yUB6M85xZEO6NvrWYFjum79EU1ewFIbUrzmybXmzngXce3tKIHDhRoL0nvV/3npgCVmEGFKAc80Ucoc8IlD5AJbuvqGIKl7m24JeC6sb4cU65q+kfqURh87JeO/qhJ9Gv2gqed4IjYqbzTh7SNAJwrKESMgheo7ZovBY9odV9N8NA1TWzbveV90s8SRbyMOxK4s1YtyOVXtir5RrTlpK7jFjI1LrVobiMrsoxRAM1bPomrKbxNt4HGSXimWfuo8j9qiscBy5qfg2GSke/2wDs9cL5NiCXI88dLDdtp8QYbisNF5hlNXz1tfIsZmQZQR5AANeEkxu4hNI1kx/rJUwwLWomawz0pWvwaVK80Wm+O7hbLlSYIj7j/39eBfSgwly9+6euL/gA7DmM36STJwS5AYM2rSGfpCzUnSrxIgQaw1FPoAN5uR6iUFFsoPhUzzYMxL52FPithmfbgLcx6jKnYFNKObI7nolpBdkHPrLGLklVXFapXD6dJ51PosXDbLvv2nD1v2H4QrjMCj3zLKldruhpNKFkg22ieiJgpVzaY8UBQiVqs39uP5RyDc+5oIIN4pdGccVzTqV9FKrd1zlo02RxYwzr3zJVESyM/pPb3nfiSP7pSAX+tTAUHI9CF98kPLEdaFO5IMau3y0ZmkgnUL2NNssglzBYH98B0eKgwLzz+IjWMz3w/TlJx+oW37oTrA8PBf8L56Cnmu5EqE0CiKceVJoUoxJLza8ziCkywxh7f6tmnCm8ibDIbyHdfq7SQvbTuZUyKUF/rmNBCk5DSUyyLhzHfQxSmU+EDbSAdg6f1/OGmwRFHsgPou0jfZgI1pzDDVi/pPRX9BMawfvkPH0x9VOqIDaDbvHhtvZgTuqXDpklaNKqIYFU2qeQWGdlJC2iGOvk/JXsMgpIBZtSOhdxQqvHJyWUeY7BeCnO5Ga7fILPwMb
 wdzkVKU2
 pAWfkzyDxMBRAtZMS4yc5dzmN4t968+KNgyvztLM4wDCb0x7Lq1Vd76HhuGkc1Gl5v1z1ZWyAi+DiNyjfyA8ctkWZvxjKbUYAhmwuP6Iq9JvPFYaXDHh5NYqb3rdCqHmPhxD4WbLfpxiRdZ4K6PpmEy1tseoYqtq/kKMysLvgX8bkA/x62g0kJf4GfpnxWe6jRfMee3YmileQOPZ0W9al/D9ty4kYfzAhXgu4IOfFSVVog+YRRNPZ1G7idgrRNIEUABMWTOZ2yYxSI+nHHTgHTojqSLTCPY5jmCA8HMZi13uehPCYfRv8y1zoF+0baVgn6dcdJAL41tLcNJdTZzXhSQlZuJ8PXBcojECpwSiK7wIX58txIJukDG2hRUH4Zw8K7ugDDJLcc0Pm3K14W0/WqP41O6IS/elRhGNz3gIKk2swuj/a0ZZr/dhvXHWrmKdnja6NvWhz0YXV/sQPaez2tHx0g/VZyiQsGy++hs5rSsiXEzMEDibKLwQleA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 9:23=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> Joanne Koong <joannelkoong@gmail.com> =E4=BA=8E 2026=E5=B9=B47=E6=9C=8822=
=E6=97=A5=E5=91=A8=E4=B8=89 08:03=E5=86=99=E9=81=93=EF=BC=9A
> >
> > On Fri, May 1, 2026 at 2:03=E2=80=AFPM Kairui Song via B4 Relay
> > <devnull+kasong.tencent.com@kernel.org> wrote:
> > >
> > > This is an RFC following the idea proposed as LSFMMBPF topic [1] this
> > > year for demonstrating the design and improvements, sending it out so=
 it
> > > can be discussed better before or after the event. It's stable and
> > > performing well, but obviously, it's too long for review, so I plan t=
o
> > > send these out step by step if we are OK with the basic ideas here.
> >
> > Hi Kairui,
> >
> > Could you give an update on what your status and plans are for this
> > series? Are you still planning to send this out in independent chunks,
> > and if so, do you have a sense of the ordering you're thinking of?
>
> Hi Joanne,
>
> Thanks for asking!
>
> Yes, I think I will send an update next week as a new series. There
> are a few other MGLRU related things going on recently, so I spent a
> little more time on swap queue (which is quite important to solve the
> allocation issue for layered swap and multiple series may get blocked
> by that) and other patches. While I've just setup a new test
> environment and suite for better MGLRU testing on both server and
> android. I'm also collecting more test cases from others, and
> comparing performance against other reclaim policies like ZFS's ARC.
>
> The code didn't change much, still appliable on 7.2, and I'm just
> tuning the params in it to fit more workload better and some micro
> optimization. Testing is the hardest part for this :)
>
> Latest tree is available here:
> https://github.com/ryncsn/linux/tree/b4/mglru-fg

Awesome, thanks for the update! I'm also happy to help with any
testing that would be useful to you :)

As part of the work following up on the LSF reclaim discussion, I'm
planning to separate out the classic LRU and MGLRU implementations
into their own files. I think this will conflict quite a bit with the
changes in your series here though, so I'm planning to wait until your
flag format and MGLRU-FG changes have landed to proceed with that.

>
> >
> > > Worth noting that the design is still not finalized yet, the tier and
> > > refault calculation can still be better adjusted, and with more
> > > benchmarking and testing. This is rebased on top of the current
> > > mm-unstable as it is supposed to work on top of another series which =
is
> > > currently there [4].
> > >
> > > With this series, I'm seeing an obviously performance gain for tests
> > > like GET/SCAN with LevelDB (which is borrowed from Tal's paper [2])
> > > and MongoDB with TPCC [3] or YCSB [4]:
> > >
> > > GET/SCAN LevelDB [2]:
> > > Classical LRU: throughput_avg: 993.64 Ops/s
> >
> > If I'm understanding it correctly (and please correct me here if not
> > :)), the changes in patch 22 ("mm/workingset: simplify and use a more
> > intuitive model") for calculating the refault distance would also
> > affect classical LRU - did you also see any differences in performance
> > for Classical LRU before vs. after?
>
> And I posted a similar (but less competent) result for CLRU previously:
> https://lwn.net/ml/linux-kernel/20230920190244.16839-2-ryncsn@gmail.com/
>
> Yes I did a long term test for that across a few weeks, Classical LRU
> seems also worked better, however this is quite long time ago, based
> on 6.9, and tested on top of that older email, so I can't guarteen how
> it looks nowadays, should be fine I think:
>                         Before            After
>                         99b80ac45f7e      dc6364e0a90c
> mysql                   7461.17 qps       7587.36 qps
> (2G Mem, SSD SWAP)                        (+1.6%)
> mysql                   89915.23 qps      90204.59 qps
> (10G Mem, SSD SWAP)                       (+0.3%)
> mysql                   66962.37 qps      67186.73 qps
> (2G Mem, ZRAM SWAP)                       (+0.3%)
> mysql                   94720.35 qps      95135.87 qps
> (10G Mem, ZRAM SWAP)                      (+0.4%)
> mysql                   100694.54 qps     101018.13 qps
> (24G Mem, no SWAP)                        (+0.3%)
> fio                     6707.12 iops      6769.88 iops
> (16G Ramdisk, zipf:1.2)                   (+0.9%)
> fio                     1784.00 iops      1786.88 iops
> (16G Ramdisk, random)                     (+0.2%)
> memtier                 79199.06 ops/s    79595.91 ops/s
> (6G Mem, ZRAM)                            (+0.5%)
> build-linux-kernel      1766.03s          1764.74s
> (make -j32)                               (+0.1%)
>
> The gain was mostly from removing the workingset_activation, but the
> overhead of that function was reduced by a lot since 6.9 so nowaday
> test may not see any gain.
>
> My plan is ignore the second part (refault distance) in next update,
> so it can be reviewed easier and won't effect CLRU. It contributes
> little to scan resistance related jobs, none of the benchmark included
> in this RFC's cover letter benefit much from it. In this RFC, the
> refault distance unification is more like a demonstration that it
> could work and improve working set shift or significant over commit
> usage performance for MGLRU, like the file scan test in cache_ext's
> test repo (result not included here, but it does performance better).

That sounds great, thanks for the context.

>
> >
> > > MGLRU before:  throughput_avg: 951.12 Ops/s
> > > MGLRU after:   throughput_avg: 1344.72 Ops/s (+41% faster)
> >
> > The numbers look awesome! Do you know how much of that is attributed
> > to the MGLRU-FG changes vs the refault distance improvements?
>
> For this particular test, >90% of the performance gain is from
> MGLRU-FG, the refault distance part contributes very little.
>
> > > This series basically composed of three parts:
> > >
> > > 1) Make the MGLRU be frequency guided and rework MGLRU's flag format
> > >    to shrink the bit usage. The format rework and MGLRU-FG design is
> > >    strongly bound togther with 2) below.
> >
> > Could you say more about what binds the flag format rework to the
> > frequency-guided changes? In my reading of it, the patches for the
> > flag reformat work (encoding refs as a single int with
> > PG_referenced/PG_workingset as the low bits), the addition of the new
> > generic LRU-refs API, converting all workingset / referenced flag
> > users to this new API, and then deleting the
> > PG_referenced/PG_workingset page flags seem all valuable and
> > non-controversial on their own. Would it be feasible to have this
> > first as its own standalone series, with the patches that change
> > reclaim behavior (MGLRU-FG, refault distance) separated out into
> > follow-on series?
>
> Yes, exactly. I will drop the flags unification part first, it's not
> mandatory, just to show we will be able to redefine the flags and make
> MGLRU-FG's refs tracking calculations much simpler. Without that, many
> strange bit shift is needed for every MGLRU-FG refs operation, but it
> actually won't hurt anything (just extra 5 - 10 CPU cycles per
> operation maybe), and the flag format looks a bit ugly.

Gotcha. Can I ask what speaks against having the flags unification
work ordered first, with the MGLRU-FG patches based on top of that and
submitted in parallel as a separate series? It seems like the two
could be reviewed upstream concurrently, and I think that would make
the MGLRU-FG series easier to review with it on top of the flags
cleanup, and freeing the two page flags seems like a sweet win on its
own :) Is your concern that the FG series would then be gated on the
flag series landing and you anticipate that the flag series would take
longer to land than the FG series?

Thanks,
Joanne

