Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83AE3C98315
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 07:20:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CCF06B008C; Thu, 24 Sep 2026 03:20:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87DDC6B0092; Thu, 24 Sep 2026 03:20:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76C776B0093; Thu, 24 Sep 2026 03:20:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 49B8A6B008C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 03:20:12 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CE9F4A53E8
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:20:11 +0000 (UTC)
X-FDA: 85247807022.13.A235411
Received: from mail-lf2-f12.google.com (mail-lf2-f12.google.com [74.125.229.204])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0D72F40006
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:20:09 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="oDt4S/qN";
	spf=pass (imf01.hostedemail.com: domain of klarasmodin@gmail.com designates 74.125.229.204 as permitted sender) smtp.mailfrom=klarasmodin@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790234410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4viioSB1Cdhru9S874ZQwRNPODne/nPyQTptgVZoI4k=;
	b=Pp6Pc2a3SQV+m1vegcJfEHXOFq/I8+jiPxmBxpDWI6wq7fGfDsN2DAKFwqVA7dOUv6/el9
	pO/YySvELvH8V7aiUe600qY4vnAW07/HZD4DBrvc3+M3pKmJNlWoa5z+QlHD+LHIkP2gO5
	/P6wEl4h0jG0vhN0LPUkelbi1C+WFX0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="oDt4S/qN";
	spf=pass (imf01.hostedemail.com: domain of klarasmodin@gmail.com designates 74.125.229.204 as permitted sender) smtp.mailfrom=klarasmodin@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790234410;
	b=zaEsfp6kFfNPmRJsmspKDHzcZqMHn6OJZEm6is9z2thihrhYLbJw0OkXz1Ad79e98j84ct
	YmFh9rgAyO4LMpPCPyruSqORL2pEMbxIyz7pbF/7zsV+UzbumHh9ta3pKpKAJ6IsfL3VjD
	e+BMAEmQbolJ4afFWb5xYoPo2hQTeoE=
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b5e4f1801fso1716660e87.2
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 00:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790234408; x=1790839208; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4viioSB1Cdhru9S874ZQwRNPODne/nPyQTptgVZoI4k=;
        b=oDt4S/qN0DXQ6xRiyoVW8yHSZvRJJXMTrpSbLRN6840tHE6ry1aVuPZWUlCqx7uHYV
         +/j4eP+MORA59ksFCGxqabZbsNE6tiiN88EnjbwY4PePtueFcS3RiCKAT/zq4O+PLPC4
         FuFVh0B/J49ZKrywFB63VyqEViDAtNA9F2/4OSTQfq/NWP5JAbOoqltJI+UkWjF3jtTf
         didFUl6qBLKlQgWXPYSMZsUOOZBWE8AVUGVeFb/wslhmXTj//+WpAnKW7F96J+vg3iVk
         ijSaEis+38DMP8Y7NJE3NrupKwJ0uKBXYOANb9bCNR4sgi8ewr71bpDEQsYquXj4bv4q
         QUhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790234408; x=1790839208;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4viioSB1Cdhru9S874ZQwRNPODne/nPyQTptgVZoI4k=;
        b=N/h2pm4iXfBe2ZX+I4u2ZQfaP3HtMeA01WMI4nymnKYynHK6vrPEzz+hAS0Q0e5n1R
         A3iArAkR5C1PfmEwZugAfo3GfVZo52+QP+MwM7uD2x0zlDy/9ge3Y0OMmAj92MJ9F2Zc
         S9Qz0yKpFyv+LouKAOHUP/lMQORguXSVjvQQ4YShFtBqZ35LIwJTT5FkRjqP99p2qjsP
         6v86Y2gjzhupkJHngyzcKJzouxrjC3o2kxhg5ROeQTUYde3toM8L2V+XOnZBWNBz3RjX
         4yAaQrMkg4BA5JmZCR22L6/CyhQVpTCy8sQMuMQYA9J1xXbN4FXg1s05XI7YLypG13Jn
         TL4g==
X-Forwarded-Encrypted: i=1; AKwUvBw2+wod9zSTv/7Xw1nwWDnM/0cttmg1XuEji/aAerlCCW7u3lNvuvERK0ppzVdUFmq18EOoCE8qSA==@kvack.org
X-Gm-Message-State: AFuF++n+JnIiPd9SY7Bwp0KaLxqfuVathpBDr1e2RV8HIi1u7JyCNFeC
	/gljx+09neCIqK8Leib6ShCIpMQb9ahYxll0n7bJoK4mBvHr9rp6Zww9
X-Gm-Gg: AYBFou0euDNsRyiBokKq8VrxdUSahbD0h3/SVKWx9gGGLM9sMaMpwUFNHW2Um1jBie6
	85qCd9LkeVDzJ4x05MvC8vtc8wN69BQF+CvbcSvM+RxFPORKmt3p/daiUMs6qmw9ESP2qKIIPtH
	wwKlNj41xYbjcBSCpAqAubsXEn+m0qR86W8ILqVF290YsWVUbMuqr5bZyDdFqZ9FFRWlhWd8lwa
	bWY45JBx1jYtoTFB3WDNz5yy+SYNw2E0zxCSSViplAS5on/vHA2d+bKiWgjnoW45LC7+pVt0EEL
	urSsXNSRsWPh5aNmSIulROvCuY4NR5MTBjPMYzNd8B8KRprHkJR/26dXJoah1cruASM/kh/rxyJ
	GJRdqu8wBZEW5lCTKafOA8ZPoln28FlXQoPOPddzrEjBvWdtijR4XhP/dlJRPbdTbLW3uyx/JTA
	Nfx80nykdrc7Bn7qOb+QIUbq1RDjGjga7I01MnZzwBb6suXuATwTPqjXQiskIYKV9Zzis4i+ec/
	HMBj+QuF0ACouUBKq0i7SqV0NX0
X-Received: by 2002:a05:6512:234f:b0:5b5:e2e2:5f2e with SMTP id 2adb3069b0e04-5b8df05906bmr513502e87.18.1790234407919;
        Thu, 24 Sep 2026 00:20:07 -0700 (PDT)
Received: from localhost (sol-eduroam-pathost130.ki.se. [130.237.96.130])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b8d857f7edsm1229650e87.31.2026.09.24.00.20.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 00:20:07 -0700 (PDT)
Date: Thu, 24 Sep 2026 09:20:06 +0200
From: Klara Modin <klarasmodin@gmail.com>
To: Baoquan He <baoquan.he@linux.dev>
Cc: Chris Li <chrisl@kernel.org>, Rik van Riel <riel@surriel.com>, 
	Gregory Price <gourry@gourry.net>, Johannes Weiner <hannes@cmpxchg.org>, 
	Nhat Pham <nphamcs@gmail.com>, Kairui Song <kasong@tencent.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Tejun Heo <tj@kernel.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <arTNdz2P4ZZZfruh@parmesan.int.kasm.eu>
References: <785353ef79844e81a8cd97e87b00ef1f785b15e5.camel@surriel.com>
 <CACePvbXZ4i-DsmbQdNtBQb79y59uwZC9J8qHD2wTWpcYaet3LQ@mail.gmail.com>
 <83539be885f15bb567b30264f5f62e718f4a9fd0.camel@surriel.com>
 <CACePvbXZQERwLF_f2FYTHsv--kq_-Aw2vVVFF+z+ovdnsHy1bA@mail.gmail.com>
 <arKbXe1Qe-FDCTMM@gourry-fedora-PF4VCD3F>
 <CACePvbWW4avTV2WB6iRU+LN5zqkMTg3UhBrq41R0iw91-7Ni0g@mail.gmail.com>
 <5a7ad159b2fabf377b7e1fc4248c433287ac11fb.camel@surriel.com>
 <CACePvbUtEdQLmmudON_qC2aKuLYCNktBuAecFKiSvDC6eTfXeQ@mail.gmail.com>
 <arO0RCCE3Woh_I_z@parmesan.int.kasm.eu>
 <arS6dvzAI5XLHuG-@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arS6dvzAI5XLHuG-@MiWiFi-R3L-srv>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0D72F40006
X-Stat-Signature: amoibzak7dbygtkojrz7uracnwu9z8uq
X-HE-Tag: 1790234409-948703
X-HE-Meta: U2FsdGVkX192w44jni+CD2RWcVj+7N3VqHBNHmPI6t0g1lDasElpgxp0kwmzTHXGBg9PMATSVsENsNJACwUqjiZphtOMMkD1m6p1m1F8wNMPBQa5pJhWY3HhkiF6goLA3miqzaq42j4QVrzIqzWmNNzTclroDKeApWDRM7pGPYjPPCARi5cPIu1xqx7m+7BPO6wtuD0gqcvP+h4UQXnOEJKIY7dINJgqqNdgSiwnEqvMlBAyGszpO2GzdwtsxbFMiO54JXaCEZPJhlwmfs1kTGHY5wP9ANoXbX2hhxHPJW84nUuj0WG0KSCdEtBceeOD3hui/lubV+6MRJVMSRTX//vdCIEwfXlLzW0Gt+f9Iq9Ey1zItxruliarE/i7MMsTbiMhqB+NzcHjDju6En/i3De8PvZVJbpFoDmrvbPKuCFV1oQcqQsh9Axc35IGAyVjT8fEW+XeWNsmVJDp3aiK+PxyG/Vo6F+UdpHOZewYOuP+IzyYnhl0KjDLvTbuAIfogEVbAJdzWkDrDUMdhe1ooaUv+Cav3raE16/uYDhRZftntub2HMLKP/rfiIx8SqftvUoJJlaVoQ0Y3Rt+5IRgCQVKvuQ7GYFz6WQhk0+vC3o5pQJIBK8wVLq5ORMP2r+Xwqw6zAF5XTMr9CTsiS2P+DgBfZiIMKoFm50Jtc+RbqhP48Jq/aKp4dV9da6O0hH6SIccZlVeywaFYAY1EpQ6YJd5zcTk+x5dXasCRiF/m1g8bXz9bhTI+odtSwDekGnYfm9/IrU7PVczwzoSAV4sYgBJowipc2R1Sgma0WJI2hSxzvZwBznkffu0wkXjjLmJXWJYYGVdIQEKjPNeeRw3Qj4n72rClAd4m5l4W3jVtAC4MGOQIFmAUHHIQWzjIiE6lLRFabG89yTfXxUyGU5XpokD5hiLoYuzTty1BIPOpdQLZCq3dTvzqwpuiMB5LBpZ/cSXl9XsoV+vDOaqKL1
 ShGn0Ge2
 v/jm7Lijij4IEI+z44FhV8f/YxSRZAXLeGvBpEKUgqHqwYbI10wt/5nF8x+OZDgmSH9pjQP2XeSyNAUZAYWfqZmhnEscDL/2m/YvkBQpcdWGShAqvhD9av5iUQ98Kq29lpO8i3sV09eEN83V5rFyDlHt+8E1CXgfnYR8GI4tNcHrDXFJi91I4N5ENC6nehv7nTkq0fJUKZ5ML3xGgwwo6dxOSZrwpjGMkdNiCfcfo7JEeKahSoRxlyGigOSC6n/fTDT9dnn7Ka4XsKtd5lIbZWouivI8Wah8v4KiYonEfkKCDJsne7Mzjls323X0TSJD1Fum9KZbZ5oZld7qD3tFE222+ltdyp8SBle5k/o8yQVjCPcqyGAT7/IxOB0AS9e4IA1i/IKDX74qDpnWz0MAjv2ZkGaouuUBYNVM8UAxTzwEZ49JesoxGj3EZD2iHDwc46RGINbJj99EHncYFNJfsWvh1zA+zY96qqLOqj2E3fc9NVbnOW2iejSdmnDcgPnFL0pE7ts2+hhjTrJeG/pJgMELxeDesVXYC7cxPabvpXjA4lmW3yiG3R6pBLnfhJfXs4eEms9/K7vvMSDw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-09-24 13:51:50 +0800, Baoquan He wrote:
> On 09/23/26 at 02:52pm, Klara Modin wrote:
> > Hi,
> > 
...
> > 
> > Chiming in as more of a user perspective.
> > 
> > On my 4 GiB BPI-F3, I can reach more than 10:1 compression ratio on
> > zswap during some parts when building GCC 17 snapshots. E.g:
> > 
> > MemTotal:        3966864 kB
> > SwapCached:        31872 kB
> > SwapTotal:      16777212 kB
> > SwapFree:       16638128 kB
> > Zswap:            280140 kB
> > Zswapped:        2859840 kB
> > AnonPages:       2927376 kB
> > AnonHugePages:   1409024 kB
> > 
> > While this is 72 % rather than the 100 % you asked for, I think this
> > shows that what size a potential limit on the uncompressed size of zswap
> > is suitable heavily depends on the workload.
> > 
> > I have been using vswap consistently on all my machines since about
> > August, and I have also tried one or two versions of xswap (but the
> > current lack of writeback makes it inconvenient for me). I really
> 
> Thanks for testing xswap and reporting issue on xswap rfc v3.
> 
> xswap has writeback now. I only built foundation for xswap, while
> writeback part was left to other people for collaboration. Finally
> I added it.
> 
> [RFC PATCH 00/17] mm, swap: xswap writeback to a physical backend
> https://lore.kernel.org/all/20260920072043.430390-1-hebaoquan@kylinos.cn/T/#u
> 

Thanks, I'll give it another try when I have time.

> 
> > appreciate the work being put in to decouple zswap from needing a
> > physical swap device to work.
> > 
...
> > 
> > My personal preference would be for a default uncapped (or very high,
> > and I don't think 100 % of RAM is high) limit on the uncompressed data
> > which is backed by zswap, since that would mean one less knob to tune.
> > 
> > > 
> > > Chris
> > 
> > Regards,
> > Klara Modin

