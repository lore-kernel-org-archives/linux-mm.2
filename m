Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 858BC606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 20:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=UM/qJJpC
Received: by kanga.kvack.org (Postfix)
	id 739166B05B0; Sat, 24 Oct 2026 16:48:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 710676B05B1; Sat, 24 Oct 2026 16:48:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FEFD6B05B2; Sat, 24 Oct 2026 16:48:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F7426B05B0
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 16:48:28 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A5783803E4
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 20:48:27 +0000 (UTC)
X-FDA: 85358707854.03.7232ACA
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf27.hostedemail.com (Postfix) with ESMTP id C231340007
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 20:48:25 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="UM/qJJpC";
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.54 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792874905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BuPJgnsG0Ng1Dae+yMYUghn3Dz0uN6VmqtORQTrWN9o=;
	b=Cpz0pUronNckEWnZYHmwShXOAo8w6T+GQpBx2WkfIg3wi8bLFrWvcUMmemzCWj9Nl1f+Pb
	JHVqXZ3EBP1XDBRRh8ryN0wthUGSn2OMx7CZnYOgLzGeZCS7+p66Ei46YbmexDRJNk9eVf
	1SLK48LRRFk+CjFCiSSRUcll9aBdKuc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="UM/qJJpC";
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.54 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792874905;
	b=KblBn+hz8ICQ/8tK/lEPtA6oygPPAZ9q+SBoI3mcAz1g+F4f5D/xOV8jCW2iZMDqvynvJ8
	EZFmocEvegN/cTe04dZoYhke4WaZHhXyHfQChBNy371SGgTiBcGinlqLTxqUkpOUBFHfhK
	K7HOFXUQ+vACiwK+ipjPQJLTyPIjrvw=
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-917c04630c2so20273266d6.3
        for <linux-mm@kvack.org>; Sat, 24 Oct 2026 13:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792874905; x=1793479705; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=BuPJgnsG0Ng1Dae+yMYUghn3Dz0uN6VmqtORQTrWN9o=;
        b=UM/qJJpCb8kgGMAm4xjYyOAra8+d5wnhi0ynA6lVYIkp/ucAA59EYlVqnj3m1sLpM5
         l7ESg3MLsKkecFCt2ds+tBD7U/w0c2IpcU9+hSJRgunfEQgOeJwkAhtcmHSuJkWTnou2
         HMsX267TAB0B8s+WdnWMFX5VGTIO2Uqa3ht1Pp0PiN1/KilhkwVemdTg9xT1r98GsUNn
         YBL0GIW6YZw9CDccIMtn8HNBFlp2yNKYAnTdbVA9Y07/1e1Z+Zk4S1Fm8gmAArezP5Ez
         PXNGkX/ZJduhcdiszDurH/jM5NvTo/qLfouJ7rTys3t7QuBZyVllyWKtf7/xc6QzFwh0
         KRJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792874905; x=1793479705;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BuPJgnsG0Ng1Dae+yMYUghn3Dz0uN6VmqtORQTrWN9o=;
        b=zL175G6BxRlWZMuJcgFo1WDAwZDRhWMXtTM1k47YhWOiWV6SDW4h4kw+2z75Wn9lOm
         71FTaYO/L1kMverc+jqE62pyu5tdPZEyjZ00jQV9AznHcal9T62ILLdMClmCgzut6r8S
         wuZOsRPHDC7erQ+HDib6X3MT/2FZHUXYrVCHlP9L9qBwZtKIBMF8DpLaeSlNWhX3DPwN
         hjWOoy3SbU/RhnK1cG8wFE680PQpY82kDFD4fj68f3OBA2WECuj6/IY8j5xs+wlNu9l2
         VPwZt/9Vm3i0MNxVdSx5iQ56x17VpoAEbd6x69cH8rsWs496BuXf4/t8JqsKf3FK/28t
         mHlQ==
X-Forwarded-Encrypted: i=1; AKwUvBwhqnPqYEeRAuDegPYLP3RxARXv4ho0A6eU2REOReY4mbNUtIcBDqO0tvmcCeKGElEIb/QWydB7bQ==@kvack.org
X-Gm-Message-State: AFq9FYIztLF/krYFA0a+/FkGzGojZQ6lqoT9kYfI8M772ofT3R+50I1t
	AwUdYHYKLyuo5gl1b/Rfpj9vBLgbj+80yP8Ge5JPGMUJnkv4jZPTC+XEpsRy80mCqUw=
X-Gm-Gg: AYBFou2I4C3LnvyeQ/mTGG+QewjF5iyBQoCM6PDsbYsBoa0kw6OeIOfUHyHa7Vn/+i/
	Tu2sEPhOrmmEIqK2HSMg7LJ4cVrEbcyYGpnli1GyRuR1n/unRO9CSxEUGUlypIBt/1c8Em3/fo4
	aRuoOFv15Nd7m8pdGh6YSW4TLxuNh2NdVjoNFzbyANGU9xM3SqctBvXTr4jz68fbv6FNIFVqqtb
	Oj6UhqtqahgQU7qQSiqzHIoNC9tKu29sDIqU/O249JwUF12NOKSc66+FFMo/NWlJ2bGVK3O8xqf
	0Wu3Du4/LMR64eVG2v84Kx4rt2zU30spBuvcEKGGv5YqV9WWNZjFN/5iPIclEKHNT/55UG5zSkT
	YOAKlBbFIuvqZKerrN8Ef5JMSh5oE/AJsks5ogNafgjTrWAobkel7iI3VUV7s3AiMTnEaoMIaQr
	5N3o7Ed7mfgY1Xotcc52CcLziZ6XNCS3Kp2Sa6UT4gQBoMtl0RMxoZyF5DdC5PkOE0EGFLvO5I7
	SS7uJdZWHe4vvjoOZ5upu9XpK5Cf5U8a8DVE5DJ+sd1re5KNwBHcrynTiLC36UMzpUUg7aGtWDA
	nUdbVTGe5UWj9NaKieusudDxfew=
X-Received: by 2002:a05:620a:4001:b0:93e:9292:1b9e with SMTP id af79cd13be357-940ef7ad8b6mr372744585a.1.1792874904799;
        Sat, 24 Oct 2026 13:48:24 -0700 (PDT)
Received: from [192.168.86.58] (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-940f0a94a5csm258574885a.41.2026.10.24.13.48.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 13:48:24 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: Path forward for Virtualized Swap?
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Rik van Riel <riel@surriel.com>
Cc: Kairui Song <ryncsn@gmail.com>, Nhat Pham <nphamcs@gmail.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Chris Li <chrisl@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
 Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
 Chengming Zhou <chengming.zhou@linux.dev>, 
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, 
 =?utf-8?q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
 Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
 Meta kernel team <kernel-team@meta.com>, 
 Linux Memory Management List <linux-mm@kvack.org>, 
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
 linux-doc@vger.kernel.org, 
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>
In-Reply-To: <12081d266e4846f23faacfc65c7be7da4ed013a9.camel@surriel.com>
References: <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org>
 <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org>
 <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora>
 <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
 <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org>
 <20261014195354.GA371161@cmpxchg.org>
 <CAKEwX=Mwc+D+AN-B5T7p=80fqCDijdsiJjd6aN_3YMrEQjyvwQ@mail.gmail.com>
 <a24ca7b8-8b42-43f3-ad72-afe62f97f76c@kernel.org>
 <CAKEwX=OdbOrFbdihntP3rmcWJUyM1UpYa5n+pYjt_feMQwx8yA@mail.gmail.com>
 <CAKEwX=PCSyCEAqxeOH6CkCMu1eB3xUn3iz5XNuTbpDM3EmWYAg@mail.gmail.com>
 <c6e62e80befa886fccd36d34a39cf56ea5b9c9c2.camel@surriel.com>
 <CAMgjq7CN7qTes+OXvCfsgPOnbtyY7YPytTEP3zZJTBxrGZ5JnA@mail.gmail.com>
 <12081d266e4846f23faacfc65c7be7da4ed013a9.camel@surriel.com>
Date: Sat, 24 Oct 2026 16:48:22 -0400
Message-Id: <179287490291.4123581.5790613647977714588.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C231340007
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 795i8ggzfth6bij8fmrk4hskfhhgka75
X-HE-Tag: 1792874905-9711
X-HE-Meta: U2FsdGVkX19cRrwx0RBmasrQmzJbpACAH0XQBMFbVroNW+h75hWkp6j0Zv4ZRfUTUfHjkMmSxLJy0lMgVY1UiFMmwiGQm0uKY4cMrsthpJc3kmTRLFHAL6BqvH+CpA6haeRgGX1bpl53IwoA9siItR6TKs8xnGEY427aKRi8LnWj1EXF9Sk+Gi59ToYT0n9uTkVVQ0lsHWxgcNRw7BjxekBt4GDEFpCs4wOc4c3QJ2A2Y5TuyAs2lpWzciMMRx3s6tAyX8L4rsIq/w2MMC5KzqDgpMUm0T1WrRUF4D4tqn9uh/Xz+vs3dYdkCs1ToUaKfN/imYoD/YEfrCGy9bl37rZX5k7WcjKyKBY7Cba/avf1DP0BndDiGGaX/NF93Vj5IQokK6TcMtGn8WjAjhHWEkdhwIXJhg9nxC6eNmXL5SIuICPRUI9mqBW+4JwjM21vS6C6it8zPn1t42z5uKqvF2YUeyCstvLB4/PTzUY/+TPrFy3b4LsWOgW+12/c5mTNj1od32f9ih2PnQ9Un3o4cdY1EjzMcPWkj594Y20T4SRvMqD+IEHm2otNsxQfFnsEq8s7U8G/nGDa4gqNKdr9CjqDX1ou46WU9TAxtvYmGOtOv0+t1679Sr7nuSRqQEk9bFAPMwrFLcF5+FAIrSu7I4DM2IGLBdp6aIWwc+Oms4dToJxteojkUd4OOxxQXTF8wzsq4SBAx+ohp6vUXvocLeF7Zq0bzzRsEqLkybQRgesFHsbwjSxW0fz0/WOl5qnJ63ScPgcpzh0bTvpZLknbYUURrTt8JEKfgRygUfC98ycREqsEMTPyAJgT9w8mNQ+tcjegHcs4ly5uIK70uey9S/nH2jMTk7mAR1sBCNz78ctIbRvWslqbZTSe7NZMjs7DYJvR9sQefhgpayYLkUKjZff7udgrTu+ekmhnehu77ERsPvqUU1hYj7URY3BCO/STKeO29WrKF/VWAgH5oHo
 OYJv6Lf4
 YrnKxSsQmPKuKYcZBoO+PWvbdG2dRmkgTovuoOtlvKXKLWwycc0aLQKkSSzSdXohejAztOmzn+93CzFqvN9BpZT6KCmK0xkmQi2+aZsyZru/bV1ffZq9nyyIdvx9F7VaH3OGTJskTu9YrF+rfR/+f3N7BPLMoM0wxQ/oqhulXFJTkMJz75UeLg/LyctSDwuPItsxI1ZR1ltfNIUAlLEkTn8yvjmIFzIL9aVIsYRKiqrvDfrMhyNikl4JOZpm8lXnevgxmHoH/ZSHw2+2N79Nu9j8uHSXTtUWgnsTx7aXhDEMg+gwXJpcNc9oNwnWgZ881q/HIuUMcDhi68/V7QUmcGgFRciqXFEI0Vo/vHRRKh7S4sPpzqOzgbp55ar0AHXSJfSw2gbpta123bo5kZipGdKB7Mql1GDY+bEo+CwE5lMyp9GDkWnXx0+2HinoTpXzVBkKC61b+8YlxlyQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-24 14:16 -0400, Rik van Riel wrote:
> On Sat, 2026-10-24 at 23:50 +0800, Kairui Song wrote:
> > On Sat, Oct 24, 2026 at 4:03 AM Rik van Riel <riel@surriel.com>
> > I also hope there is a way to release swap metadata completely too.
> > e.g. for fs, you at least have umount, and can rmmod the fs itself
> > afterwards. We also have many ways to bypass the page cache. In cases
> > where a virtual layer is just a burden, we want raw physical swap,
> > and
> > the ability to swap off that too.
> 
> The VM cannot operate without the swap cache, though.
> 
> That is very much built into core parts of the VM.
> 
> However, having swapoff remove all data from the swap
> cache, after mapping the memory back into userspace
> page tables, seems like it would be fairly easy to do.
> 
> Does that meet the needs of your use case?
> 

It may be good to talk about this in terms of discrete workflows and
interfaces, rather than in the abstract.  Just describing effects
creates a confusing situation without including the cause.

Isn't this as simple as having something like:

echo 1 > /sys/kernel/mm/swap/drop_cache

('simple' is doing a lot of work here)

-- 
~Gregory


