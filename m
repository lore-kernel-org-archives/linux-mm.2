Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 302CDD10F58
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 16:01:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76D9D6B000A; Wed, 26 Nov 2025 11:01:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F7156B0029; Wed, 26 Nov 2025 11:01:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FB526B002A; Wed, 26 Nov 2025 11:01:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3BEC36B000A
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 11:01:27 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C441AC06C9
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 16:01:26 +0000 (UTC)
X-FDA: 84153222972.06.C8722A7
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com [209.85.128.67])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8F10A40062
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 16:01:23 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=NWf7Wb7l;
	spf=pass (imf17.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.67 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764172883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LSEYaUAThzWufYFQbG5NmjfparTQ345H1vYgCRR94jQ=;
	b=7F6YFE7Xc12qKvMKutAmmeyEAqCy+xj6MPIMOd7gw7NJ/n+HUB/Su8+rWnwxKwfFiL+Tvq
	p0mmDj/rg88qoeqM7HHhfrT8ll4gwvIbd2mOI3Fjd/aVEOhiYU/pgWWajReRwU2o/pj6MD
	caCV359QwMIeQlyiB/0QiyjgU8ve4Nw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764172883; a=rsa-sha256;
	cv=none;
	b=2mrJUU8NCRDpKOPQ/t+lCEqnGAJgQMn+sV8bEYMLsxP2no4HrLu4Xrztv9p+n3O/lFqyPX
	xM8rpMWGs/J19DW/EQUTQtHW/ReaVo7wSDGTteaVpS5JkR//FXH3hCBoCYc6cA+ypDqGEm
	Rdhdb5G3uSBNFtlrb2dXk1mjfWgRa/I=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=NWf7Wb7l;
	spf=pass (imf17.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.67 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f67.google.com with SMTP id 5b1f17b1804b1-477a219dbcaso61744625e9.3
        for <linux-mm@kvack.org>; Wed, 26 Nov 2025 08:01:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1764172882; x=1764777682; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=LSEYaUAThzWufYFQbG5NmjfparTQ345H1vYgCRR94jQ=;
        b=NWf7Wb7lsyy/WA/Bfvx5t9A4oozJLdFPR+q+Pkty27AtAGA7+yh7z8coztZFQjT9UN
         fsYrrZ2lLoRUTbPFSVMe31v5AjAIOgzxvZxDXgdXdhE8gSwT0dRh7S7lz4lNKZQ3aPKN
         MVtQtG+AGv5l/4ooUscDm5vnmCe09PBtDDQRpzt7+yKAUgM0zlMrpia4+Pa7yS/92Zjc
         Cr/gfg+DGs7QTlow1eOrGIk10cvIaQVyeA7D2Ar4a8v8JijOpkyNinWmO5HdGBi/N9Br
         dwIyujcYR+XQxeXeWP6O4O4apIrYvFcqD52ITYpR8wSHG+qFlZcuVgDe1LxHIW4jfqBO
         QB3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764172882; x=1764777682;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LSEYaUAThzWufYFQbG5NmjfparTQ345H1vYgCRR94jQ=;
        b=c0uTvQCjBBmUCtfnCREr5dgxWN86eC14s/iJShIhIj8bS3x3qEK1mmxG1/kMUxW6Nv
         dY17NPFjIrIHoorVbsXMpD32mBgEQJAprMJXlegSDDmy/4gQpAPdu1eqxDLg5sNry1fi
         eXT3o5V5Bwgl9nQSt0VXFcP/tUCiUuM8qkrlkmUf8RKgckZNm8V5UNwPT1D3n/SOFkUe
         3ZogwWBpPuVSMBQdn9zNfDEZa2B5+6gj2fCv064KxfZ9zWzcphD1flDgL96cyIyqGij5
         uFjv8PvsLEkRZBp2/QH57KR79xJeRupDYV09Ql0IvR0ZvoqZVuk3hMFx9X/OqxgET5ej
         ITww==
X-Forwarded-Encrypted: i=1; AJvYcCWgDccHjj5XDnqOlVwq65sZbNfmMiS2g+WA7vvD6u8rmivymqQc5pZ31igwGL3tUVPzJOH7xdGzyw==@kvack.org
X-Gm-Message-State: AOJu0YzKfar/uSQQ8sij+76HHF3uUu5CudEjqXk4FNB8v4eep0zvH0mU
	qGnmAyahzrsasH9bexoQX+OpqZN12IrjpVOACKWpZC2ysJRAl+INxcgvBcO+iVdH18A=
X-Gm-Gg: ASbGncsrzMCnhFiSRWIgfeZyuSwpEOSMIKPmIdaTHKXv9JDduLHvyVrHBnoPGaasPrf
	9QUg3TV7TE1/YPspZ6vtdHaAFYDODqdb4kXzM9C7QkXjfG4i7hYyV8RXDo8s+aQOXT2hYZ+szy2
	6sNDUCuTmOz4aTKLR2YpznSkh0d1HKH8jsKsuq4esRVzDLJL8DDdqcBjCntg4uO8cft1yzqfmIi
	7xuhnCOBqCzDa6J001bXX/MqWm/pPN+W4KH9ndjSs3hwoG4OmZkLqkZ9K+YAUkYDqQqlYWYW1tH
	tJWmreZ95OPjkWlNWPAoZFOlBIiNz4CD0wbszVhghS7SIxudSK5/5kyxGBom7SM1Y/w2TosuLZh
	mDHyQiu5zqf1BaBeDRpNFu5x11y4Fq9oWSAEA0XW2A7tmO/ZkLFuBjJLXfXXxIM8QgtagvcLgn0
	a9G3XskhCrMilYpoWz27Y=
X-Google-Smtp-Source: AGHT+IGmW6B0mWDbCOocDZ2euc5+xXD69i8th6QMhNJdys8XoC7Ssf0VJWSdjafP9//scVbg3OATOQ==
X-Received: by 2002:a05:600c:5494:b0:477:93f7:bbc5 with SMTP id 5b1f17b1804b1-477c0184c3amr197847725e9.10.1764172881604;
        Wed, 26 Nov 2025 08:01:21 -0800 (PST)
Received: from localhost (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-479040cfe17sm47110715e9.5.2025.11.26.08.01.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Nov 2025 08:01:21 -0800 (PST)
Date: Wed, 26 Nov 2025 17:01:20 +0100
From: Michal Hocko <mhocko@suse.com>
To: hui.zhu@linux.dev
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>, Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	John Fastabend <john.fastabend@gmail.com>,
	KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>,
	Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>, Kees Cook <kees@kernel.org>,
	Tejun Heo <tj@kernel.org>, Jeff Xu <jeffxu@chromium.org>,
	mkoutny@suse.com, Jan Hendrik Farr <kernel@jfarr.cc>,
	Christian Brauner <brauner@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Brian Gerst <brgerst@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org, bpf@vger.kernel.org,
	linux-kselftest@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [RFC PATCH 0/3] Memory Controller eBPF support
Message-ID: <aSckUNAfVokeC_2F@tiehlicka>
References: <cover.1763457705.git.zhuhui@kylinos.cn>
 <87ldk1mmk3.fsf@linux.dev>
 <895f996653b3385e72763d5b35ccd993b07c6125@linux.dev>
 <aR9p8n3VzpNHdPFw@tiehlicka>
 <f5c4c443f8ba855d329a180a6816fc259eb8dfca@linux.dev>
 <aSWdSlhU3acQ9Rq1@tiehlicka>
 <6ff7dad904bcb27323ea21977e1160ebfa5e283d@linux.dev>
 <aSWnPfYXRYxCDXG3@tiehlicka>
 <87af0c7a8fc35cd96519a4e3f09d39918bdb7370@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87af0c7a8fc35cd96519a4e3f09d39918bdb7370@linux.dev>
X-Rspam-User: 
X-Stat-Signature: bcfnje6wu1mrf9hyjec5p5cjs5k1hprn
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8F10A40062
X-HE-Tag: 1764172883-545371
X-HE-Meta: U2FsdGVkX1/R0OIi6BORMfyU0hkVytDMygzBr+kOcxWpsXvo4aSbR3HpijbXGnIE/QQpJFvzGP+cG8KTzGYaxEbwVeGVzDNxdlOp1CiYB1+Bxw9BgVjaBOVxZMZv6JZ6n9rXZ4x3kd2S5g4TYt6xEDsIs64TGoFL+X9gYivIdcmZFiOWRe33MAs8bBm8qg35MBFFA2sSE6gAZGpHbSVCnLCyo2bMphxd1nqUiuIKeUJmm2JenYG7KDMPtCofw2j68rXi5CJEjOe90j7nVsufsuqX4pid9YnbRDCmyPMbbgW6jFl0pdFZHa9yCZ77HyS1FvwxONRvrguCbz4VNamhdm+M86p0HAahrKaj9tdL/nHfXckrAthnmqg49zoGL/2OTYLZECcvoEwj66wxCn9i+ogXrxCUl/0IGZ9OLDv0qeDgM10mSCm7o9UZrqU6TeNuxcSZFj37m8Q+of+5a8Na/UOMr0W8eDsz3MlsHxlR+AaOBxe5p0D73tIDuq+cwBYCIRQ3oefNrtQN/br5Wwpn+7XvUH1nMvbnTDa5xvM6ZfY3UdSPUeIsiMXwnWO9EurArzOoaqM5l8f9eUIOiD9JAevIMaREyZUpPbCIuJVDvEq8GYKTWLpcHsgfHcfhPwGYNaxGKDF8wJmZLBwYv7YT/fXgPmzZYOFURG5JnwOfRSaZEjwcfjQNNGTCcBVBzCTSTYZ7Ck8A/lK0awtXI9Fm4vuILhTWoToPfe53T3v433A50E3hBElmWTdNGJnUYgImpdNCsyeXPp4jM+GMAK1U2FKCXeWDV4CWelFuBOJqHJQPICskxAzXeL33/4gYSsjp0E8mLYD0V/10tsUppUIxyyw8PyFScMFHVHbzcgd8l9lApvdvWyx7XAeipOWOOHAxdw8aFbMR1WTJg1pKj8PrgRQZgpZAi7/P91uZXucznFONsA2/KVaHIl2z5ja5MTH7POeCiJ1HSjnmsves5R0
 2zYeAPor
 qwPaqZ0/fo5NMwHieVfoqty8XyJ3ZOlXM7c/8QQoAzlDaB8DcqymaYst/99OHzPO900mwIhPFm+iPkVGeI3hbElXX3BJcvw3l8ISAoE04I6CCKCWehnli9FyYzNjWSiL3y7W47h919Xj/7uMgQb6QRHvhYcsLdZfaeIINiAUXnt0DnXtN5MwykQ7igGWxBmlVjHoNUgz4v+JhvP/F/5jG9Y7EkztbnW+2PjFKFGk7T3xvyTnCFNUhcewtmPFvq5ddQ13h4x3XoQKcOAsdfA6i2J0rLOiF/TqdLQlmagkJ3tQW472ddXls0TCzqUbrwaiu4XWw1mmZBRfIDGvQxAZqsd/Ex7Nfn7LWxM2270P1osNsv1IU+D2D2CHLcA4I0Op3NBzajpFaMzW9kB0bqr1+/2sGA5iPCDccOogt1hILxSx+VxDNO0Np69BawFUnLnrHvx5dU7b5wJzHuE40wZUlTFZ+4Uys3ujnM5ewjzNxXQCVLqdNCGQ0SNwYAzmB93pT9WlxoU/sUBtKQv6qiv91I6PopS9AwbBWUGaSIc7gs27rL9nGZbvoSdsUNvsQg+wUqMxujAgL6dNgftRD2bF7IMVR96uTTE8va4V1jJyRxmupiMEVfQchdFZR3A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 26-11-25 03:05:32, hui.zhu@linux.dev wrote:
> 2025年11月25日 20:55, "Michal Hocko" <mhocko@suse.com mailto:mhocko@suse.com?to=%22Michal%20Hocko%22%20%3Cmhocko%40suse.com%3E > 写到:
> 
> 
> > 
> > On Tue 25-11-25 12:39:11, hui.zhu@linux.dev wrote:
> > 
> > > 
> > > My goal is implement dynamic memory reclamation for memcgs without limits,
> > >  triggered by specific conditions.
> > >  
> > >  For instance, with memcg A and memcg B both unlimited, when memcg A faces
> > >  high PSI pressure, ebpf control memcg B do some memory reclaim work when
> > >  it try charge.
> > > 
> > Understood. Please also think whether this is already possible with
> > existing interfaces and if not what are roadblocks in that direction.
> 
> I think it's possible to implement a userspace program using the existing
> PSI userspace interfaces and the control interfaces provided by memcg to
> accomplish this task.
> However, this approach has several limitations:
> the entire process depends on the continuous execution of the userspace
> program, response latency is higher, and we cannot perform fine-grained
> operations on target memcg.

I will need to back these arguments by some actual numbers.

> Now that Roman has provided PSI eBPF functionality at
> https://lore.kernel.org/lkml/20251027231727.472628-1-roman.gushchin@linux.dev/
> Maybe we could add eBPF support to memcg as well, allowing us to implement
> the entire functionality directly in the kernel through eBPF.

His usecase is very specific to OOM handling and we have agreed that
this specific usecase is really tricky to achieve from userspace. I
haven't see sound arguments for this usecase yet.
-- 
Michal Hocko
SUSE Labs

