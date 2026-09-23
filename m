Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC11AC9830C
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 12:52:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FDDF6B0092; Wed, 23 Sep 2026 08:52:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AE8A6B0093; Wed, 23 Sep 2026 08:52:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89E8A6B0095; Wed, 23 Sep 2026 08:52:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 60CB66B0092
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 08:52:30 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D42541A07AF
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 12:52:29 +0000 (UTC)
X-FDA: 85245015618.05.797AB05
Received: from mail-lf2-f13.google.com (mail-lf2-f13.google.com [74.125.229.205])
	by imf16.hostedemail.com (Postfix) with ESMTP id DEC2B180007
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 12:52:27 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sk2Ouz1V;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of klarasmodin@gmail.com designates 74.125.229.205 as permitted sender) smtp.mailfrom=klarasmodin@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790167948;
	b=nX9EcB3HcUT0o/bw2ceYKmQzgx1aJE+WVFryUpuNUsYp5lTuzIo1T392fY3Y68kqj6hrT0
	R7lD//NXUQdUw+qYGwZUouNdXIqdXqSombO224957pADrSHWuf8QiprH7QqB1KWgQoPEDL
	FOOGiwp8UjXpdssqjWDm71HIN7k3MtY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sk2Ouz1V;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of klarasmodin@gmail.com designates 74.125.229.205 as permitted sender) smtp.mailfrom=klarasmodin@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790167948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sm7vKUqKVBNM8fpsiqdcEcneUTHOJiE76zYrPR0ilCY=;
	b=wg7nVJAP+N1ssctyI+w7e5TCoMlDOYN1kmTYMJluFwrRCJV3a7MBsKgzLHw2b1FKkF0AG6
	b51nUU1Eo8QkwiUKEvm3CVM8YZ4hGkpmBbopJHiNIdNWUtcBnbL88g9l5OEv1DaDMl6rjP
	WyBBoXkPcVMZnqa2pxJAKhMwUoshh1g=
Received: by mail-lf2-f13.google.com with SMTP id 2adb3069b0e04-5b8c1b8d7b5so791218e87.0
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 05:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790167946; x=1790772746; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=sm7vKUqKVBNM8fpsiqdcEcneUTHOJiE76zYrPR0ilCY=;
        b=sk2Ouz1V4MhUhtpgw6nbzCN+Zl2UbEzRQ1o3LcYKG/7WkHJLkJKoK6/KLXR5T0/TBj
         0VGSqzm1E140/VZ+eMAwAJp6DpqNy6gQxU9hVmUZ0E1KVbp1uursJolqVPj7z4wRAlp1
         HhojcsLQMzr67uNS2mYbB5GgwjOmYL/7aqSCMXP6mjIqBNlgEvWLPGzNdKLWDt3uzyoQ
         VPNFz2tbZpp9KQf9L/+YDtFw00YyfvnzzzbS4k7myG/nUoAbHxKhmwN5Bfy/dIQi/vVc
         dZ5dF+GzsNNB1Yl5anH3L58P6JHnBqVVv/xNhwt+Ti27hOWrhtUzGgabmDZfdeNlCZZT
         +e2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790167946; x=1790772746;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=sm7vKUqKVBNM8fpsiqdcEcneUTHOJiE76zYrPR0ilCY=;
        b=PTnjtsQ5AyMz85COC2Kxj54IXcxynM7/r17P33rypjJf+LZykUZGHmYXTszn6/g+9f
         S/v+nQdGyVn1oxn2JKd19kYisxSEeb6qLWDuxnnYrd+MtzIEF2LrtCa/aRUG0djegEit
         OxYdcFYDpotdVmW6LupzCIoiTrcyjBh5m2dkcpXhLBG8BPTAKNoT8ZMbpsWpbRHWtY0d
         WcNO9mlv7TqByYoL88JK5MxaucAcFcJAWadzH/jyNwrZefGAjRHJpbO0htFACS+5hYG1
         k4q0WfTA8gz9YZTWrpkB3+O+Zyv4C8X/QZGtVvilVvNmFrfHdNFgDpLu2FVOg/YRWhMm
         gQeQ==
X-Forwarded-Encrypted: i=1; AKwUvBzOJU8xBQCbjf2iJbNm8B97HI+5eCuHWBvzkjy4wmYG5Ck+97Wr027LckWpHsgg9+vuXgxpCZnN8w==@kvack.org
X-Gm-Message-State: AFuF++nfg/Eo6raHVGpXWNrvUKE7g2o66sB3IHIGV+DmLOOvXhMGeb77
	cVTfRAvKrGLlM7Gc50yDGVsXCb9ZBGEDVonmxxfN84Jkv4H42EkzSHt5
X-Gm-Gg: AYBFou3Cv8zPYX/VDffiMdjX/4HbcpAb/Kai2TKfL4D4aCGvqF0I9C+q69fYsk+yiYe
	O6dgl1knwYGrQHrlAhcY/qeIzpfli5ST8VdbY8sDBTMKC54Gphlk/QqQ1mZZMN2A3WdUJgla2fr
	wa7Q8oUy7AGpSzJMdDIDH2WTov1FsZFFcVtg4tLZinr/QiAP7w42sSwuA0FChUjUf3tK8L8BzFl
	oM7tlSXXb3aismo8XoBwGVOPXPGgO9DKiDsKBL0WmwIz9DuSbYgfBkKr/J0Yi77mW+scockZnvl
	NHcRqmyRs8BHTZEAnjsQLUL3Swzq0W07JzGx1iDKXrnyBJvIcNbnq97/7TyqwaJHZSgd6IAchta
	Oygyj/+XRe9DysGg/vvlqJcKdtI7mjFeh0TqN9N6zEo90SiFKW3tWJGeaXoUZe7oPoQ7IWnZIun
	9X/+KvoAP0PxtHqcGC+UMrpvn7abDTl2DExFUfwvTyp4wEdxEFvi/VRex5n296F1NNesOepxtgZ
	UG3ffW0xAxf577MKYsinBBHZgyf
X-Received: by 2002:a05:6512:b22:b0:5b0:113d:8ae5 with SMTP id 2adb3069b0e04-5b8d895fe88mr1057730e87.10.1790167945480;
        Wed, 23 Sep 2026 05:52:25 -0700 (PDT)
Received: from localhost (sol-eduroam-pathost130.ki.se. [130.237.96.130])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b8d85956c0sm567280e87.78.2026.09.23.05.52.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 05:52:24 -0700 (PDT)
Date: Wed, 23 Sep 2026 14:52:22 +0200
From: Klara Modin <klarasmodin@gmail.com>
To: Chris Li <chrisl@kernel.org>
Cc: Rik van Riel <riel@surriel.com>, Gregory Price <gourry@gourry.net>, 
	Johannes Weiner <hannes@cmpxchg.org>, Baoquan He <baoquan.he@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
	Kairui Song <kasong@tencent.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Tejun Heo <tj@kernel.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <arO0RCCE3Woh_I_z@parmesan.int.kasm.eu>
References: <e879ac65cb0940325736df7984c737edf1c6be94.camel@surriel.com>
 <CACePvbXThspPYD8DZkAeiJtYuMV79vGgC1SGhpMwhn4COWOtcg@mail.gmail.com>
 <785353ef79844e81a8cd97e87b00ef1f785b15e5.camel@surriel.com>
 <CACePvbXZ4i-DsmbQdNtBQb79y59uwZC9J8qHD2wTWpcYaet3LQ@mail.gmail.com>
 <83539be885f15bb567b30264f5f62e718f4a9fd0.camel@surriel.com>
 <CACePvbXZQERwLF_f2FYTHsv--kq_-Aw2vVVFF+z+ovdnsHy1bA@mail.gmail.com>
 <arKbXe1Qe-FDCTMM@gourry-fedora-PF4VCD3F>
 <CACePvbWW4avTV2WB6iRU+LN5zqkMTg3UhBrq41R0iw91-7Ni0g@mail.gmail.com>
 <5a7ad159b2fabf377b7e1fc4248c433287ac11fb.camel@surriel.com>
 <CACePvbUtEdQLmmudON_qC2aKuLYCNktBuAecFKiSvDC6eTfXeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACePvbUtEdQLmmudON_qC2aKuLYCNktBuAecFKiSvDC6eTfXeQ@mail.gmail.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: 1hr8gsxe1xdhs77w4enhrcgwrj49pu9z
X-Rspam-User: 
X-Rspamd-Queue-Id: DEC2B180007
X-HE-Tag: 1790167947-422614
X-HE-Meta: U2FsdGVkX1/QN0FqSTAmCtWmTp1wHeDTSCU8Dena2n3ZeFj0HaqcZ56uZ4gcDWHI+nipjPLnASte/b3EzSKG8d77nq/Ozq0Ak7b/s4IoiKlvm2Kt1d90o7mDpkEmL8R0XA04Dnx+KdY1zZc66OF5qT2hF1+/0ANRNcLc+hV7BxowSNFLE9nN+ytMOMqB3gurH71RlX1c9/qEZiJ7SzY1Mma0Hu4hfAO/M/7aePJteu4kI1IDiwX8RXe9N6ubuTjYYMQXjXJ38bZEm4EQ1aYAiZKvUN7ag1p1/s2QK33U8Axs2IjouUDv+JUkt2i+dm2HHQci41W2SA0I1gXQCb/IxXVHDUm1o4tQF/hNsut+Vof4u7Xhuiqr6Wu0RB0zXo4YThP0kDrLZLCYUuvQxxOA83wdqfmBQwSsA26u54XAbBeHlee82+Jk4QYJ1rEsBWyyv9L/fSBKayeVHEwxfuDA1f3tsl84oHvJPLqZkdGbtLlLB0hxNNmK83UfBmijtczePtMx/CVReSpHGN0dUWJfhOCuA1Boh1vKBaeul6+EvpJHTh+OV+klM3V3LnRXET4I0vzjlsD4KF1r+xhp+VtMOqz8Wo1tDQDfHozt6nDIAQdD+RjMVqffbTRgS+5YyuRlPwnYgvfZb1vpc+/4LJ4eryXAdRaCQakBOt+8GKbLfGB7E6YEdpfX6gf/ARfBEo3XolLLvDumYCtluQSCdDNSAms6+n7cNW5+7V8dtmBRqcKlBiUaNaM6I3hlBmKBOyyPBp4Z0yOcCOBTHlAIPtsJERHHlBTa1PdQpkywmp8Z1Km67aAxxj/NP3kwGHsxav4/+9euqpI878r/raQGVDoh/fiCnCU2fzEGIh7d80/OpCP852268SewBJS5czVTBp+b9LLQQ0pHZqONXgFXb9BkhzQS+WsIKNsAL1ZTMRSCPWnAWbYzIbABF/0qn1nWn0+nS25sCADRrJuh9jjrXUP
 aFoN0luL
 IlZaFBDQrmSiGUpRBkVrVsDFvpEgzO138XNhPLG2faaoG/FQiIMilVJ4HyYcnZHQAh4GLUvWi3H6yaP2419Gd/1t6F9m/stoEgTJEiNKwAZ1mq1J1s5C3f2CowQCBw7LRa6iRhqAdKltMiSqwG0uwb0Vmaz4O7KrjKacAsnzoQ8X+QRSE+MbQuobKc7voz5r1M0giJObcw3APzsX0iXPsgZ4XC+1c8zQIbpVjXfHYPQGDmIyR9LDzk4G5c7FqFlg4r0aCVg2Rp9Ki/SBvhA2Tg/tpwgwi2yTIpVMpC3frE/zTLx8Q/OmcwF7lE6IGP2Hde/5vL2pimnCP6LLdNla8w1zIKMmOLsYeciHOBHo1I2zZXTUHk6GJOTbyIy+jNHHs2ztXABhQs8tnQ/D5reLZUEZIlWi+3d1xyYUG1UTtjJG0QU/UohMF16fdPONvUEhQZO9w1ZAt2a2z+fTnPwe8x0t7C2lqYhk9emqQb1oo58G1iuzK36k+uDpXwwUg8aMk0m3zo2ZGP3VEjO6cMERvPZT+wzQ7T8PmlCd5fcCIsP8zTJezjXSS2JugxfIrz3/15iAhG34BkCUiLOMDCNGIH3ooQz8emirzVb6PY/J+MaRW9o20mxyNYtW8HREK+oSAyjMZ65kJveVcBYmQncnz36JXNLp1YbikEZ817oQ79fYhWlGRcWzrzaTKaSzGvagsR3QtioSNduAIesE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 2026-09-22 21:10:53 -1000, Chris Li wrote:
> On Tue, Sep 22, 2026 at 5:53 AM Rik van Riel <riel@surriel.com> wrote:
> >
> > On Tue, 2026-09-22 at 05:43 -1000, Chris Li wrote:
> > > On Tue, Sep 22, 2026 at 5:20 AM Gregory Price <gourry@gourry.net>
> > > wrote:
> > > >
> > > > On Tue, Sep 22, 2026 at 03:32:44AM -1000, Chris Li wrote:
> > > > > > Right now it has 64GB of memory.
> > > > >
> > > > > That is exactly my point. You are running 1/8 = 12.5% system ram.
> > > > >
> > > >
> > > > Chris you are missing the point
> > > >
> > > > Zswap:           8812236 kB
> > > > Zswapped:       24927876 kB
> > >
> > > I am well aware of the point. The 7%-10% data I provided is before
> > > compression. After compression, the real saving is about 1.5% - 2%.
> > >
> > Here I'm at 28% without any issues, with room for
> > more.
> 
> 28% is one thing, 100% is a difference beast completely. If you
> haven't tried it, don't assume 100% will behave the same as 28%. There
> is a point where too much zswap makes the system unusable. It is hard
> to pinpoint the exact upper boundary. However, figuring out the upper
> bound larger than that exact boundary is not hard at all. I haven't
> seen any one can use 100% system RAM sized memory swap out to zswap.
> If you have a data point showing what that system with 100% swap to
> zswap looks like, please share it.
> 

Chiming in as more of a user perspective.

On my 4 GiB BPI-F3, I can reach more than 10:1 compression ratio on
zswap during some parts when building GCC 17 snapshots. E.g:

MemTotal:        3966864 kB
SwapCached:        31872 kB
SwapTotal:      16777212 kB
SwapFree:       16638128 kB
Zswap:            280140 kB
Zswapped:        2859840 kB
AnonPages:       2927376 kB
AnonHugePages:   1409024 kB

While this is 72 % rather than the 100 % you asked for, I think this
shows that what size a potential limit on the uncompressed size of zswap
is suitable heavily depends on the workload.

I have been using vswap consistently on all my machines since about
August, and I have also tried one or two versions of xswap (but the
current lack of writeback makes it inconvenient for me). I really
appreciate the work being put in to decouple zswap from needing a
physical swap device to work.

> >
> > > You are not listening. The boundary was set due to feedback from the
> > > application SLO. Those are real deployments not imaginary usage.
> > > Please respect the user.
> > >
> > Different users need different things.
> >
> > The kernel needs to be able to accommodate all of them.
> >
> > The kernel default should accommodate the people who
> > are least capable of configuring their systems.
> >
> > Hyperscalers can set their own defaults across their
> > fleets. They know how to adjust settings.
> 
> They can use a safe value, e.g., 100% of RAM. Let the people who know
> exactly what they want to swap configure the boundary they want.

My personal preference would be for a default uncapped (or very high,
and I don't think 100 % of RAM is high) limit on the uncompressed data
which is backed by zswap, since that would mean one less knob to tune.

> 
> Chris

Regards,
Klara Modin

