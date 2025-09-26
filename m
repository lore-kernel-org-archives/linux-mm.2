Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37024CAC5B8
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 16:41:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 781768E000E; Fri, 26 Sep 2025 12:41:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 759458E0001; Fri, 26 Sep 2025 12:41:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66E438E000E; Fri, 26 Sep 2025 12:41:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 51CD28E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 12:41:14 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 111EE43C98
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 16:41:14 +0000 (UTC)
X-FDA: 83931966468.17.86D0885
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0B765180015
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 16:41:11 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="QDyk/ZYG";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758904872; a=rsa-sha256;
	cv=none;
	b=AxOh7P841q3plK6dDvONLyfXbdjGMUPSjwdexfS/qwA2OsVy+x5TdHK/pjzbSaeZdntGkM
	vW6sWB7EUhvdDA4+CYCYyY333jnu5IWSG9xR3IEp/LPWtVzTr50dZIoZEkt9vKEsr1wl44
	cASpSIWE4NLhOkWH2RMSY81dmnF5nq4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="QDyk/ZYG";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758904872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OhK/I355tEzWCZLpIKaGMRHfbyhnGIybWqmQS9Bgtnk=;
	b=EQOHrnGbKx6o7UhPUM6wDLJppKxJDuADnHUSqhLpGvOis5DEkDW2Sthu46Jd5Dt5XjmWVG
	tn335o+ekCyGVwiO58LVJDXwXHAeEjHrpxZ5a5uRAEhCybhqtSCEAVMdNCrKJpBhD2ZsYx
	QXQQY04F2r2UuHzKOJgXfXoS0CoGFLY=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b3727611d76so270829266b.2
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 09:41:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758904870; x=1759509670; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OhK/I355tEzWCZLpIKaGMRHfbyhnGIybWqmQS9Bgtnk=;
        b=QDyk/ZYGC6wATOJogJskeTjsR2z1YMwi2S1zO+yJv5nINzhdCweO5Tts1s2yuian9F
         abj119OhJt9EpH+kbWxb5wLJyQD+cBmZHg8Pqbv/Kwsq5afT8GhdroP2z3Ohwvx5PhyT
         7W7IJKSQ/bK9LVufJv3MtChhhGXGfwtDOiJahdP3iSD6F0zESnRU2j1Xg/Zg9CnaMdfu
         4XewFvcJxZF4z1g1mVaoNGQ9qvI6FQRmWO+OaLOuKhPURSamfiIij60i/sIaQmlJ9dMX
         bZ8siNFqtFrKNidg/qeBK5E8ZBsB4UwKc8KUS3aJDUo9FX816AXM0Br1hyjxzUPkQnLZ
         S+Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758904870; x=1759509670;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OhK/I355tEzWCZLpIKaGMRHfbyhnGIybWqmQS9Bgtnk=;
        b=aIf0Mix0ru+cYN+EKu/VQbC5VVYmlA/FmzRIuOo4FkhFTCKrZmazfzh+1DJt4a2jN0
         1VzFrrx9tb+JrENWKOvoAaKx8jb+m8APTMH1FBWJoDzTQI3n2HF20TkONHwe8+W7DnZI
         tIjvIybWf1dlUJ5XiLvuyrQFOhvCJ8YOb0VgWlEVPHoOMvA8AAf9PUiQttBGyM1iw0ED
         NJrVU54fv5Yi/uVDA3oIcM8lFfMjN/iAp3o5Bbzh7MAa+IIzrC6VgepS/LalNY2I6tDy
         SKIW32dH+ZEBj3t6NJsEYAsD5BurYSItrElH8l31V5NMQvVYNspW0uIm9CoqXZ0k9/bz
         tEbA==
X-Forwarded-Encrypted: i=1; AJvYcCWo5pVxbdrI8vfM6n9J0fkj+bD26SgfVwFXOaX5y/tNsFk5cyUOguH0HtYpK4yvRlSc+tzwf9Ajag==@kvack.org
X-Gm-Message-State: AOJu0YxfIF6ZRuoVEqif/nv1IDB3R1ovlagFtI99FwwEihVDxKeSXc3K
	MN/I6KT7ZLogLa0VO2OgcX/Jg+U7hPJkZDvM4hWfkWImuq1aWWMMtF7wfy1FXtjm3BOH+9cJUYO
	S0Lm3N24s9xUVzQQsYyGJ0jDsh39JJJw=
X-Gm-Gg: ASbGncvJMgM5yz8y1j5K/dEB/tEZcK2II4Q5YNdVtXfF/FZm4idaW09UytZvdEseLfv
	4WrycLPbhm8FIyuxMDgHmpwJKpxUFFqFmU/zTIpxa04mIlMQFnFONb6ireYhejohZEpK18MwgIB
	EqepBLztNLElLShp932gAKXqPUq/J5S6/uTklaX8nLKjIA4bQ9s6mU8PQis8ySkTsoWI2OjerHg
	RxjQv/srh/YsS3qPmBY3actT8miZqMwpfthFwYnYHjRET+Hmhye3Tk=
X-Google-Smtp-Source: AGHT+IGiAgB3Cp3l/+LWlbB0J5SQqcA//CNAV4YTQyXTFqA9cx49Yh6QtYgAgO3MbSqw95Dgnu0URBo7YFe9FVeY/8Q=
X-Received: by 2002:a17:907:86a9:b0:b3a:1300:e8e4 with SMTP id
 a640c23a62f3a-b3a13102ed4mr8997966b.12.1758904870081; Fri, 26 Sep 2025
 09:41:10 -0700 (PDT)
MIME-Version: 1.0
References: <20250924204409.1706524-2-joshua.hahnjy@gmail.com> <202509260132.awvdNKqF-lkp@intel.com>
In-Reply-To: <202509260132.awvdNKqF-lkp@intel.com>
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Date: Fri, 26 Sep 2025 12:40:58 -0400
X-Gm-Features: AS18NWAvPCxQoYx4Q1NMydC8ffwXDXCS1U2zPQc-T1l-6SyQtlRE3k2R9alT660
Message-ID: <CAN+CAwNBg+3RwAsBxOEMk6aK+tb2O45wfnJxBdxRPSBi+vHEUg@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] mm/page_alloc/vmstat: Simplify refresh_cpu_vm_stats
 change detection
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: oe-kbuild@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, lkp@intel.com, oe-kbuild-all@lists.linux.dev, 
	Linux Memory Management List <linux-mm@kvack.org>, Chris Mason <chris.mason@fusionio.com>, 
	Kiryl Shutsemau <kirill@shutemov.name>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Brendan Jackman <jackmanb@google.com>, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko <mhocko@suse.com>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0B765180015
X-Stat-Signature: khaia3ud3c1r56j5c4eigsnfe76ry75n
X-Rspam-User: 
X-HE-Tag: 1758904871-816247
X-HE-Meta: U2FsdGVkX197RDnnG7Mg1PQ265GpetEulDldpl7UbiA+DQZbAOyWhep4hfEi83167weEy+BvumVKVO6HCTuHucDYNrA/eFtZJezhBRyQ+hKRNKOIWu3GGhpJFs7Wwc7Y5sVCh1vtihw2tUhPVTiP6/XluJyxSMzaPtdlZvL/8s46qEPyWEbKr5o28IUcJxU8hxGiIY+26UObEdfDyex7sr2A4OFUFDgufgmImsHp4YIUMsyOVgffxWwmio5LO8CjMqvhrbHMpdYSmzWK2bSJXlyBm3pjvqiBFe5t6OldSy99vorDOj0prw/oeAtZSmPy51QktWShuSlwlbN08+U+9L3Db5/CGhUEcszqVmTKCMfvi08U6raSzHayJWeTQaENFmJWlI4n5O3asM9CEofJNIkE20WUpLJGjl6vkr+pc0sn8sR9whm/nQMLSsd4nHYSlHtwhr66dF6mgxT7QixPnqHUI7bPYI4Ya9Ga0XNKwev83PFS8eOM7tSvZldfREe3khMkssh11r7MBTIgnuI5sVMcf5sGI6Oj+4zpGWW+qVZVq4jeoxMUXHS/SR9lglsNz+gmM5T66JrFMh+HegMaC8+j38LD3BjQcZ9vXcifQ/gnvgqmWpyrOIE9LepFLVAjupdg4K/IthBz5acdSNOgLxb3i4yWNwbGjc7VL6zkbR/tQ9OWlCw6yn9UppNyASsylZBv0M1ZQjS+aiUbwyjU/AXwRwY57HuJvp8P6JEwsKYkiAquvN4BkfeNVW7ay4soMfNiXYeS/cKQK9X4w5MoFyKK++DFk0rL3xnFPbpQr5ZMwlyoZeQHccFvF+ySCF+eOeTS448CF1CU2yHgO11ERSS0iOmQmllqFHPVQ8rMtAp8Euph4wmiDo5UX7suRB5Aqi0zLj/rnExMgVEdnZm2ysHNdadUEfQfsJgrhEvHMywLhsXjrKPjV1BbUTTheWeZDfcA/zBssQNytMAjKdd
 KM84NC9B
 wU7lkswbusZX69r/s5nfw7NELd2nVVJYyg/Hc4dRAF0NNOA+OOej4UmXpI0KvtNbv0/YkUQjzDBoEyDbOihgq6I4MidKKiKu12wrDfQLn4ZLqD1qDBzEq2gW3+acEtTGy+8MWM7G5QJ318gmHezETGSzCYZAgeqn/7pv7YI+Hi7WjdYqL6pXetJwAiu+ZAvxgaZ4BHBzpV6IYvC+p++q0LEk3C2q+ZxllKTq9ZE8gtnZlrQpF1P1uN0fGSNtWnHwitnMeGoY4O97TqFklMSAy68aytxKj9VbhY25wNONqDJ7NIPOqis3SR7NIrsxK5Y3YqekrDj2/sZFmEtJv68L5CvrUYuU/jwDS9Va5Qgft5HML7FULLBrL5T6RhkoocIo0Df8SUvNZjdKzpWTaQ0ydAVik2WPfiu1MSqUsiJdCsZz7PciqmwsQvtU1LNBIAviPPp+mdwbTZ/13sCS334Z4dqQbSNhwSZH+aOYZRrWqY8qaASJPysTtrsdxSystZYLCXytnmG7Gy2Paj+0UDMC/Xxrjjw7buP0lSV5wbdeH2HKyIO6WvtvSMAkRuVeXIC6uHkr4l2a9s4an6m2K1CeGb0up0xMwKqO1ywZw35UBbg/Y6kU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Dan,

On Fri, Sep 26, 2025 at 11:34=E2=80=AFAM Dan Carpenter <dan.carpenter@linar=
o.org> wrote:
>
> Hi Joshua,
>
> kernel test robot noticed the following build warnings:
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Joshua-Hahn/mm-pag=
e_alloc-vmstat-Simplify-refresh_cpu_vm_stats-change-detection/20250925-0445=
32
> base:   097a6c336d0080725c626fda118ecfec448acd0f
> patch link:    https://lore.kernel.org/r/20250924204409.1706524-2-joshua.=
hahnjy%40gmail.com
> patch subject: [PATCH v2 1/4] mm/page_alloc/vmstat: Simplify refresh_cpu_=
vm_stats change detection
> config: mips-randconfig-r073-20250925 (https://download.01.org/0day-ci/ar=
chive/20250926/202509260132.awvdNKqF-lkp@intel.com/config)
> compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project c=
afc064fc7a96b3979a023ddae1da2b499d6c954)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> | Closes: https://lore.kernel.org/r/202509260132.awvdNKqF-lkp@intel.com/
>
> smatch warnings:
> mm/page_alloc.c:2591 decay_pcp_high() error: uninitialized symbol 'todo'.
>
> vim +/todo +2591 mm/page_alloc.c
>
> 06fb80866d37b0 Joshua Hahn    2025-09-24  2564  bool decay_pcp_high(struc=
t zone *zone, struct per_cpu_pages *pcp)
> 51a755c56dc05a Ying Huang     2023-10-16  2565  {
> 51a755c56dc05a Ying Huang     2023-10-16  2566          int high_min, to_=
drain, batch;
> 06fb80866d37b0 Joshua Hahn    2025-09-24  2567          bool todo;
>
> needs to be initialized to false.

Thank you for the catch, I think Christoph also pointed out the same
thing earlier.
I'll be sure to fix this up in the next version! Have a great day!
Joshua

