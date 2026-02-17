Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82B6EE9A03E
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 23:36:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86BC46B0088; Tue, 17 Feb 2026 18:36:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EEF86B0089; Tue, 17 Feb 2026 18:36:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D0FA6B008A; Tue, 17 Feb 2026 18:36:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 55AFA6B0088
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 18:36:39 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C9F5EB6D76
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 23:36:38 +0000 (UTC)
X-FDA: 84455560476.26.B253B69
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf05.hostedemail.com (Postfix) with ESMTP id C9BE710000A
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 23:36:36 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OImH0M2b;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf05.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771371396; a=rsa-sha256;
	cv=pass;
	b=by6KWKTymJhKJpO9rCu4rCWitA/OlIlwwXGypWlrgc4p5lDSQ1gfhbWNPOyCS3FITqHE1T
	RU7q25hMtRtyDkSwkLCYr2fuA2AWCHti5zHlV/2qgXEk5SiyWhSZm4K+l09W2hvz1xhCgu
	7gA0Tjg6BIsT2xe1ETKe9JF9Tbb05Yg=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OImH0M2b;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf05.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771371396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wk1effero1CXwxRd3Bkv9v1OFKIW6OFHxrrQapskabc=;
	b=ODy/8l7h5MtKK+iNxEX6yzB0APvNNrIV9e0BcIktWM+cvX5XxEFHDPtBq/wbfmrdpztWsk
	OyAVmP2yaTzthOJuSgDTV7WNGdE1zNr6idB4AvLEe8+Zi02UJphhHVl95ns0xE99Eb5tCr
	gjg8o7woi83auBDUO+J/jnVNJ+RUToc=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-48371bb515eso54066435e9.1
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 15:36:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771371395; cv=none;
        d=google.com; s=arc-20240605;
        b=L+Ihyxvntb3niV24IwS7/qPv+oesHMe+77h5CGUINVhGRwc/dNSeJtryIBEnmoTwuo
         xj1FgeXqbMWBBuAXGHb2W6VOckWjpENy9sEzGzbomPEJrVbf/o3lH/tVtZ/Pe6J//meH
         EYJJWQBjWaVLmIZ8ITsqPVsDLgqjpcOTmzPN57ZWiFwMfwU60U7T0vF0BklK1kl11C5S
         5gVOOclH82c4HhT/O2M9V+9hBqINvnC67koC07TulWi2l0hW6Vx1Solq3P2yReU9xb8k
         Kz5I8w/je9blrzosiKRgov/LQ6m8twUid4/QKyq/37SNVcar2cmBkeps7UyNrzuUN484
         wagQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Wk1effero1CXwxRd3Bkv9v1OFKIW6OFHxrrQapskabc=;
        fh=ABXmZnBdoZTR4yAxk+iKzJ1hvPe/vHvC1K3Uxj2KghI=;
        b=UBr/guaJYO0uW/NIQRyd4+2JhrwuqzpA+7usuv6L4olElb8ENxEZ0OTfZJPzhdceqq
         Kbq0eYrX00KgfEkjftmxGx2YxBC+JXDmPTDBBVQ3P/779v8Nq4fSDz+c9sCDec5QAvke
         TP2uERnvmjYESAa5uls7Xw6bN59zDI3UZplQjIUlcWKreuCXdGMnnmVYKHaUr6sWWAGh
         QwOWCa0WUvfgeO3zrHAos64wBqxUTjz3n0z0UfCT29zQB5si6UkjbQmsvn8YuE57RyCQ
         b/gvf5/LW7ZnGw4LfI+v33RkSTIUAgMsInzjb7OYn7fZotESRRGEUvAdk5QYNJwhMRB7
         eIKg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771371395; x=1771976195; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wk1effero1CXwxRd3Bkv9v1OFKIW6OFHxrrQapskabc=;
        b=OImH0M2bg0OB7C+QwBtC4g+vz837P9KEwcG0DQRbsKRQ7/agqJhCD/bVUujkz7dWk1
         aj5VLXBIFOGz6bZmRrm9tT7BQWvLfWH5GyYAvjSgE39xioD3dAY4gfQKFcTQig+cxwRQ
         ocw3GKXaQB5QxiSWJ0g5ywcSyw2vGI5B1wW0osBo5ErjM0c3JvIdDV69eZBBY9xMJGp6
         /6X5y5h1qR6CvmO5opeT0m5aKdV9HZRMbiUA33l6xNZbvdaGwXGydCNuMC1YcjqdfWOj
         5qO/JRgqEZjXZI57lw1ITsd/EpDWFDK2TyBonE3NybjECULVWqhhZrhDDaNSKNKWuegM
         JKzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771371395; x=1771976195;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Wk1effero1CXwxRd3Bkv9v1OFKIW6OFHxrrQapskabc=;
        b=eaI6EzNYu7DG3TFYfYXAOr3FVTaPmpXRjOL0PNLBloiZP9f86TXNhLprANqPtbDrUf
         FBFVcZHYeMHfKq+E5cycicvSlkq+rTyHzNYuXXk7nE6tEruFdZKtjHS1xuKBmBu906lB
         K/FCmR3qIiVYNrZSdyHM9ATOhIJUcWuIcB29CddJ/ck3RfBKw+tzLHowLzg+ufzRwhax
         YhQrRJYH2y0KZp8KSbeaCIZSyaLj2P5qua7RK3qcz2+ZtUzCdXNcFUzzaPG0rcUJ+5OF
         1jgVs8a42xoURx0WcoYY96O3O73764s3SbDdXPzyhG9eV4T+YTbsHy9b2E1AA0L1OfnM
         o4bw==
X-Gm-Message-State: AOJu0YwzpNDqsX9dGpBszqUNtCFyUoL9I+Txg9ZW33XU/OQgjzIzLfh0
	O28ow1eErUtu5gp1RVUwuF+rQT/bxBy4446f/intLk3KrSb+u7jWJPGHH7CDvFMG9sH1skIC7tK
	1rj4c00oANeYMby4baMqaFd0G5p1paAQ=
X-Gm-Gg: AZuq6aKnKR5XZ6kjl2UOwysj7nR9lv45M+zTakDrFtgMcRYXzr3eNkEnnRhbr8QOvk7
	FPqqjrPGrh/hMa7rcGGu0t4zfHKWygWFlcYfEgUlyqRojZcWyD1NdmnJNL9je2WXb6CGHznMfSu
	7Y5OIhzM2+7lBmqHesHqhMvfWwfnZNDHcTf2ibcrDzc1Fx1HVf202xNBEnISB5KalQgNPuOtRX4
	Zj/7eeUfW7zb0+LiMgFYicdnvhCq7cvLQ4htqzwDvUEpnN59iOuqxTqkUN7iN/GvdkzRPZa7aJ9
	4fbz7mBbd1dBcTpEyUixIByfwqCNMlPxgvYZEKJ6dK/s+LwRt8RrCek=
X-Received: by 2002:a05:600c:6217:b0:480:6910:abd1 with SMTP id
 5b1f17b1804b1-48398b5d5c6mr3435595e9.18.1771371394920; Tue, 17 Feb 2026
 15:36:34 -0800 (PST)
MIME-Version: 1.0
References: <20260208215839.87595-2-nphamcs@gmail.com> <20260208222652.328284-1-nphamcs@gmail.com>
 <CAMgjq7AQNGK-a=AOgvn4-V+zGO21QMbMTVbrYSW_R2oDSLoC+A@mail.gmail.com> <CAKEwX=OUni7PuUqGQUhbMDtErurFN_i=1RgzyQsNXy4LABhXoA@mail.gmail.com>
In-Reply-To: <CAKEwX=OUni7PuUqGQUhbMDtErurFN_i=1RgzyQsNXy4LABhXoA@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 17 Feb 2026 15:36:23 -0800
X-Gm-Features: AaiRm50S_8HbiTq-rHvY-Vu5YZbVnz6yG-KBkKAQGni1VF15QKHPJ6JJsJaTSsw
Message-ID: <CAKEwX=N+djRJ7QVYbvi2ziiWdPcpS1Z__wH2=mBef4EGcdNorQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/20] Virtual Swap Space
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, hannes@cmpxchg.org, 
	hughd@google.com, yosry.ahmed@linux.dev, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	len.brown@intel.com, chengming.zhou@linux.dev, chrisl@kernel.org, 
	huang.ying.caritas@gmail.com, ryan.roberts@arm.com, shikemeng@huaweicloud.com, 
	viro@zeniv.linux.org.uk, baohua@kernel.org, bhe@redhat.com, osalvador@suse.de, 
	christophe.leroy@csgroup.eu, pavel@kernel.org, kernel-team@meta.com, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	linux-pm@vger.kernel.org, peterx@redhat.com, riel@surriel.com, 
	joshua.hahnjy@gmail.com, npache@redhat.com, gourry@gourry.net, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	rafael@kernel.org, jannh@google.com, pfalcato@suse.de, 
	zhengqi.arch@bytedance.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: rx7zqrkkohg913qkd6orsywwuuhpfkk7
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C9BE710000A
X-HE-Tag: 1771371396-420563
X-HE-Meta: U2FsdGVkX1/vqGXaMOYF33DG8xTuw9VJAX4Yp4xjaRPArmByExwScVdKYCHZ0y58G5RS8SAbIQZ+MD3g14Nhzrt22HKQQCrYM0BuHW3+p62wyUsljHSyiq5c79+Ou4UceS1qeFTpakSLjVNGXb/YV4NGW42h1WiPlUprF6Z9KEEaVmoqZ/vtOwygtvxQtwwPf7AcV6ut/4DSi+radcjZlpSU4nxVuIkDDmWY5pWk9aihjTIwOlF+X8Q7QWPv59A2d1/D+/6rf2YctiZpdshp67cLLSJyzeuKP95dBHjd3oZKj2FikGW9s5dRRvGqe43KmMyHsMnXH/Lnd70T16sXhWs0Zbv1u70dS5fLwzWoI1JuNQ4enLmjcuCwImGhgH0U5JfMkD8HMfzj2qKeaXrEKC2K8PHEVqQ34h0Us2ePII5q6Y6VlE0r27Mxig+lude9KvLxBQCoQFzfymKNGEwYjcDsa20dONg8az49mNCzfWU9nRQcPqxQ+B+9hnrQAJISeGbT7lGCDRVA3oMhNm2sj9YghoWpslD8bhkx7lvkR6vz5N+X1fpCyLgmA7WyRxb8gu8v1sw+FCG/s5n/XrKxGWsilG/z90/XlSPjE00o0sBbpjSLyMgYZE1RmJbRHRJS1TI4tS9BvtD8w7PR8dJ8ZqilORRDZ4zvgRfQSwY+G4aUP+P7y4bOXftvMpeJikixAVKCsMt16zbR8YEkdlk5jY8XzMKfLk4RJ2JQt6PTIWhY08l7oSZ19aXMJ16NBzTzyV0i/7s+J4Pmxv2AZmcKhZDJoMiyxbehO82uEx94I2rKrurQUzIQLtI9IZP24V9gXzPSke3yvIqSwFfhT1gqjTb/eM8ohsRvjtgRLJNIn65y5uVfRNAWUyrMvDP7SZgzFkgay0V/L3sfJw+pC+ObaW23fWbhhQz1DDtrfsk31VVX+1VQ901NDnzAfRY5T8b0dozeSAgPXOpFwmLGWvX
 4+iLerBs
 AAI4VOf2qUYsVaXOQ0x1Gp2HkO29Fv8VBsIkEMGH3FcW/HLwk04blzSvgqxiZqxFPf72zvi684agGPDh5RZNTna4DNgg3q667TPideUGJs2mgoYcIKbUDsJfhlaLAX3TB+W6dRnwS56RObAtDIyGkSfn0UviYui8gQM4cxVCNxTYue71bqB+8Qmr2dOc77HP9sIf/8X3q16JEJbckx5BB3EatyYlh3fZDS9XTv25Wd0kEqGRgi9n2oJ0SnDm05MHEKiATxPbm9p5nFI5tvwpd46t2ztUrXv21Ur7uYn5Ihci6nRzyVY9cEWg4l/2Hvjhfs7m/WM0dAhlONfo8d39fMzQshRnyv0KL6g/FYEeUIKXOLL6a2lw27kcYCanLJw+0WJhrpIh7G8rIq0+YXdQS+/9+y6AXaW1L6ETWdrocRAmCFCHacCCmRb+Ede7SH2ips6ySspGs4hmEWGnI/dSvLIfNMUZyS1XbXArotVFlv0U+zXlux7ycz+ZnwQtTkKI37mVyTnVk5K/NDOxT1Zmya51wakIBbIpxjN2T
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 10, 2026 at 11:11=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrot=
e:
>
> On Tue, Feb 10, 2026 at 10:00=E2=80=AFAM Kairui Song <ryncsn@gmail.com> w=
rote:
> > # free -m
> >               total        used        free      shared  buff/cache   a=
vailable
> > Mem:          31582         909       26388           8        4284    =
   29989
> > Swap:         40959          41       40918
> >
> > The swap setup follows the recommendation from Huang
> > (https://lore.kernel.org/linux-mm/87ed474kvx.fsf@yhuang6-desk2.ccr.corp=
.intel.com/).
> >
> > Test (average of 18 test run):
> > vm-scalability/usemem --init-time -O -y -x -n 1 56G
> >
> > 6.19:
> > Throughput: 618.49 MB/s (stdev 31.3)
> > Free latency: 5754780.50us (stdev 69542.7)
> >
> > swap-table-p3 (3.8%, 0.5% better):
> > Throughput: 642.02 MB/s (stdev 25.1)
> > Free latency: 5728544.16us (stdev 48592.51)
> >
> > vswap (3.2%, 244% worse):
> > Throughput: 598.67 MB/s (stdev 25.1)
> > Free latency: 13987175.66us (stdev 125148.57)
> >
> > That's a huge regression with freeing. I have a vm-scatiliby test
> > matrix, not every setup has such significant >200% regression, but on
> > average the freeing time is about at least 15 - 50% slower (for
> > example /data/vm-scalability/usemem --init-time -O -y -x -n 32 1536M
> > the regression is about 2583221.62us vs 2153735.59us). Throughput is
> > all lower too.

Hi Kairui - a quick update.

Took me awhile to get a host that matches your memory spec:

free -m
               total        used        free      shared  buff/cache   avai=
lable
Mem:           31609        5778        7634          20       18664       =
25831
Swap:          65535           1       65534

I think I managed to reproduce your observations (average over 5 runs):

Baseline (6.19)

real: mean: 191.19s, stdev: 4.53s
user: mean: 46.98s, stdev: 0.15s
sys: mean: 127.97s, stdev: 3.95s
average throughput: 382057 KB/s
average free time: 8179978 usecs

Vswap:

real: mean: 199.85s, stdev: 6.09s
user: mean: 46.51s, stdev: 0.25s
sys: mean: 137.24s, stdev: 6.46s
average throughput: 367437 KB/s
average free time: 9887107.6 usecs

(command is time ./usemem --init-time -w -O -s 10 -n 1 56g)

I think I figured out where the bulk of the regression lay - it's in
the PTE zapping path. In a nutshell, we're not batching in the case
where these PTEs are backed by virtual swap entries with zswap
backends (even though there is not a good reason not to batch), and
unnecessarily performing unnecesary xarray lookups to resolve the
backend for some superfluous checks (2 xarray lookups for every PTE,
which is wasted work because as noted earlier, we ended up not
batching anyway).

Just by simply fixing this issue, the gap is much closer

real: mean: 192.24s, stdev: 4.82s
user: mean: 46.42s, stdev: 0.27s
sys: mean: 129.84s, stdev: 4.59s
average throughput: 380670 KB/s
average free time: 8583381.4 usecs

I also discovered a couple more inefficiencies in vswap free path.
Hopefully once we fix those, the gap will be non-existent.

