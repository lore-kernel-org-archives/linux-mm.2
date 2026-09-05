Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB773C624D6
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 11:23:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A45CD6B0088; Sat,  5 Sep 2026 07:23:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F5F16B008A; Sat,  5 Sep 2026 07:23:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BF566B008C; Sat,  5 Sep 2026 07:23:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 651946B0088
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 07:23:45 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D940680322
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 11:23:44 +0000 (UTC)
X-FDA: 85179473568.14.0BE9988
Received: from mail-wr2-f10.google.com (mail-wr2-f10.google.com [74.125.225.74])
	by imf13.hostedemail.com (Postfix) with ESMTP id 064F820002
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 11:23:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=L33hcGnn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of memxor@gmail.com designates 74.125.225.74 as permitted sender) smtp.mailfrom=memxor@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788607423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OK8u0A1r5wARyyx+mQthY7pulPX5uc00KjP5Fs0Y5/U=;
	b=bJPRpkcUjeCYzg+0bC3ZSfv5wffoijtuTUKjmTbM/EuNKQTkwF/VE+c8+CpjhPKgeFskhy
	cpd4jox8AC2ckQgF4gwD+wSZjRsgAz4hEQ7BTepuQ5wfVEUJkUsrMmjQvcRE55JcUlU++x
	FmpWmlzMdpSLEJUZ0QDmoFW8SafZRNg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=L33hcGnn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of memxor@gmail.com designates 74.125.225.74 as permitted sender) smtp.mailfrom=memxor@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788607423;
	b=Ra5QHXGeKGe/dcyfQSL7yOpkZzNu8ZuBK1x1zPkDfBPXj64D3tB48atBoo08FYHNZGfS8u
	PP797tLpRZrvNxPrtwWoKQwWaf7aii04sx8/qWxk1MztFCpteM27EanrjsF+tRJbQjI4m5
	+OBbpjh2pAi+1aXQyCII7zRwcZ9cA58=
Received: by mail-wr2-f10.google.com with SMTP id ffacd0b85a97d-48436370540so840107f8f.0
        for <linux-mm@kvack.org>; Sat, 05 Sep 2026 04:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788607421; x=1789212221; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=OK8u0A1r5wARyyx+mQthY7pulPX5uc00KjP5Fs0Y5/U=;
        b=L33hcGnnXa2FIH1SJFifT4e/gmQ+lD0++NnCILhfQqIQTsAR+4lMZIuWc6bFlabXWr
         DzodqPEZ7WZIOv12Kxe9Yr1RrTo1rICWxjkjv9fxjuvuSH4ar5IdIGfKBeFKhnnwkGjs
         9yKr1ldG8n1xMLX65PB5NybDxQVZGe9YZJM+AumjPRfrQvquLIhmoP2l0WBT797PJm86
         j/mikTBlIqqN7nYHXXXOWLzoc6QWGQ7T8eSH1T6/du38CEsB0ArYzHi0cG5QYzZZx4cT
         8eKhI79Cj0zVbj+sMegCPQhreWxD6lUARSJ1wJlBCLN96rzi89ECKtYGLtmtKJRpSRSV
         cWRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788607421; x=1789212221;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OK8u0A1r5wARyyx+mQthY7pulPX5uc00KjP5Fs0Y5/U=;
        b=G+PiAMVAlGWQJh1McfHkeM/0geF10hufa9BF0lnadWoA54rXDPpMS1xpE42WnYSmuD
         5xuBeG3I+zL82k6sDlVcpck2SCEjtxwZHkVz//+bB9wQPIiO0Q4Wv2QRAM7vr1TaVfaI
         1EK1A9seuyfNKumfoWlP9ksSq3h/JiVq06lZPR/u8H19cpduLz25DOdkUCOlnjPc2507
         WVz1zCDVP51bSbWWWmIHHJLPsbQ5yOO+s3E/QCwFUUkO+BkYJkUUrX40bcE0LbJVXZA7
         l5d2D47ECzSLAbZoTSvHP7tGuiNkZFI1hph05m7V3FHRnN3aU44F+zzeyelNuby4R83t
         Bszw==
X-Forwarded-Encrypted: i=1; AKwUvBw8bvUm0yrf18diJo/vXnv+PuRMyCDSwfsS1IiB3F3w/e2FEHfxETLnhzlFPk/FJAecPvTNtazvFQ==@kvack.org
X-Gm-Message-State: AFuF++lhuycagVdDBb+9ASEat4y0b7dnOwpG84uukLyMRDudic0x5zFj
	Zat7Ip7dBffxXSv3+bZrsFzacVYUkKS5vTEkK+kMDx0t57/Fp79KbEPO
X-Gm-Gg: AYBFou2O6j5I5m/6QyWw/n0RQ/trG3JArbXQq/a+74JwBj0Q1peY+IUYeDNqIuODjas
	f1Ql3fbd/gJh4LKxBUg9OX/m7yVT2n684dFc56iaq5RIODt/D+bvD0Th4UvwUTIYloOszywQQth
	qiA3c5mTnYFSwvrEHagZ6jDmM46GFctlgqqLdZW/e/fTUWi00yx2pJA4xcmnaKvyFCrgv5A+yTV
	yN4Br6AicCf9qp9kZgZONGnj4QWAwzhTvHTDqIZwO4u6g1NcETk2QUlo3O4O6cVYKEaY3K7MraJ
	g8U8c7GYcfKP3nrH2b74s9SBtuMIuGPIb3onQJ+0dQWV2tYkGyfPkt5u3OBZq80bz4Y9gLpIXyl
	VxNZmVp96DVVR0/THAljtd654t++a669fcxIv67A04JP1vpKgxr/nX0TXUyvAoz5gyy8ZM6ETik
	V2qP8fe7HrA+8pIOqgUjsDpAvvmJJCtCO4By+pshtP3k4J1S48qyDRZpW39bxsl1um8qq5B9GFy
	DK6vt8rXUgk/uk2yBZvSs/dqPVvH5Uj/4XjVS3c7lfABTY3AUo6VIq7Fk3w2D9SHVfNWP6uFTgQ
	Xva0c3tH44f7llZ9lAGcg6MRF14=
X-Received: by 2002:a5d:5888:0:b0:485:8c16:5ef9 with SMTP id ffacd0b85a97d-4858c166172mr8839779f8f.51.1788607421304;
        Sat, 05 Sep 2026 04:23:41 -0700 (PDT)
Received: from localhost (nat-icclus-192-26-29-3.epfl.ch. [192.26.29.3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-485958f1493sm1014293f8f.37.2026.09.05.04.23.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Sep 2026 04:23:40 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 05 Sep 2026 13:23:39 +0200
Message-Id: <DL7CEX9EX781.23V26M3600JEI@gmail.com>
Cc: "Roman Gushchin" <roman.gushchin@linux.dev>, "JP Kobryn"
 <inwardvessel@gmail.com>, "Shakeel Butt" <shakeel.butt@linux.dev>, "Andrii
 Nakryiko" <andrii@kernel.org>, "Eduard Zingerman" <eddyz87@gmail.com>,
 "Ihor Solodrai" <ihor.solodrai@linux.dev>, "Alexei Starovoitov"
 <ast@kernel.org>, "Daniel Borkmann" <daniel@iogearbox.net>, "Martin KaFai
 Lau" <martin.lau@linux.dev>, "Song Liu" <song@kernel.org>, "Yonghong Song"
 <yonghong.song@linux.dev>, "Jiri Olsa" <jolsa@kernel.org>, "Emil
 Tsalapatis" <emil@etsalapatis.com>, "Shuah Khan" <shuah@kernel.org>, "Barry
 Song" <baohua@kernel.org>, "Geliang Tang" <geliang@kernel.org>,
 <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-kselftest@vger.kernel.org>, "Hui Zhu"
 <zhuhui@kylinos.cn>
Subject: Re: [PATCH bpf-next v7 1/2] mm/bpf: Add bpf_proactive_reclaim kfunc
From: "Kumar Kartikeya Dwivedi" <memxor@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>, "Hui Zhu"
 <hui.zhu@linux.dev>
X-Mailer: aerc 0.21.0
References: <cover.1788516769.git.zhuhui@kylinos.cn>
 <7d8b77dc99ffe99a7bef874a257472fdaaf07e1c.1788516769.git.zhuhui@kylinos.cn>
 <20260904110308.4473cde499e91aab14dbd5fc@linux-foundation.org>
In-Reply-To: <20260904110308.4473cde499e91aab14dbd5fc@linux-foundation.org>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: gwdqzxqtshfenkuayjpf9jfay5tw3qxc
X-Rspamd-Queue-Id: 064F820002
X-HE-Tag: 1788607422-329904
X-HE-Meta: U2FsdGVkX1/92wLmLisVRQzotMofLUmo/Ao7JAFe8rsYvGwW+XOPrIeLGx5N/Ym6xtk9pS/NX1xGWOgdHxFI0wmIIbWPvUHDQm/C5PrIZRh3+UACzAw+6ekSCIUyD/lKqEJjLjDbQPAVBFQnXHH/CdRDsldvFS8Ob5WhnaJQWd5thFjgDj6AthAZL546ZEJ0+Ul2Si8+Zq+D5PUQuqe+BrMEDgYDjHYIxvwOj8EdqeEeTV8g7JKtAsN5NHir2piMOiP5BwdymOWm/Ex0J+sdmaQRerj21ODFqBS4O5cpCpdjjlknSVKWn5GA7BR8grWrBaccrT529O33Y7h1pDAmti0u/2iy+mzXU9lDhA0FTA97qIDCx6nnlNqttgCYCaFu3lKSxXHFSrRq0qRSIHROlXXk/YqFCQ8r78VCymAjG6VntwQvantYyWxBiMam16sxySX2AhM839VuITXE6kXW08ZfEGVAptjx5B889mgPm8wQoBjuAqiniBAA1zHzOIqk2wo4QmOv8uQFNn9p8QcHa1uGlJwsjheV8vo9tmFdyK2m42s5GjgOyhFaPjZkoku4fyqggM6Xjk783mxj+1qv1hgAQq6LFL74/NMkyqzk8pIh4QjWyKo2B1IjNpAwdaSxb6F8Sy9eW74U17hsje5ht+ZYkgoNDrG2ta1kBhfHDFP0J62g5WJgdRWpYuSkf6l73+E+k/rgD2Eaqk8Sn443+FAZ1sc0KCUZILkPqh7A2kRpQRKzlyyKmp8wUk+pSI8q3UB/JQGAbUmyLM/1h8+wCpI/pdcSolIs0WgUmI1/kT5CEri8KwMEd7233J2lsyQ2hFzkfYE4jCBQezDS04ZSnHKC9v2htVCZLVacNVvmf5kEfImLjDGwl7uGz/UW2Sq6rKtV41DXZ1bZLTJAQWqDjxrF+z9XE2RjbqSDd6cml0tSJ3xuUpH1pXdzh/LB4XPTxvYxpMhsQno5fwX56+h
 bqfkrEoS
 DGcc73yS3zOVsUhlwS9wgPFKz8/4R/9zGYNArXVU8QJ4oVVkycxVwvA/jxwW9EETr7OjUMIXrGV3+HXxj7Rj9k5K9Iw2gyeHpEbr9Rn39lSckX4nIjYsmoWNyqc/mdyDIs/cHFtHaADQIkbIWxGosy9Y7q/yYoBRxjjH4TITyh3POfWOzLAsDHDKAO9zgpYWY8sw1s/pPW9W7I8lfZmXVSDHFn3SZmAFC0avycXOUFqC+gY6C9ptSGy51nKHCxSppwB84mWdQ+zqDkb+OsP+5f9g9pqc0Buv1jJlOAWSxiPiHrQSsIva1SrVEwnugDEO5SYxLkCXGrICtYX9ANRIh79QHjqxlo2J+eL3GiSNGANuJkXj+b05YZk5XOX31mnyavDSH+TKaViXyc3ldR1YvbrkJT8iJxWP0SRVW5hfNsYKN2hlu557iDjkplLii1gQ3ksZbpd3brt0HsbM3FdXDqTpxQAO8qmlvkDcLC/lIZWKbNAjQ+3z18Anz0Sq0zeMbLBu7QN6AeKgBZ98=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Sep 4, 2026 at 8:03 PM CEST, Andrew Morton wrote:
> On Fri,  4 Sep 2026 18:20:19 +0800 "Hui Zhu" <hui.zhu@linux.dev> wrote:
>
>> @@ -159,6 +160,74 @@ __bpf_kfunc void bpf_mem_cgroup_flush_stats(struct =
mem_cgroup *memcg)
>>  	mem_cgroup_flush_stats(memcg);
>>  }
>>
>> +/*
>> + * Reclaim must not recurse: try_to_free_mem_cgroup_pages() overwrites
>> + * current->reclaim_state, so a nested call would corrupt the outer
>> + * reclaim state. Reclaim windows are marked with PF_MEMALLOC;
>> + * reclaim_state is also checked because it is installed slightly
>> + * before PF_MEMALLOC.
>> + */
>> +static bool bpf_in_reclaim_context(void)
>> +{
>> +	return (current->flags & PF_MEMALLOC) || current->reclaim_state;
>> +}
>> +
>
> Would life improve if try_to_free_mem_cgroup_pages() didn't do that?
> If try_to_free_mem_cgroup_pages() (or some variant of it) were to
> permit nesting?
>
> 	rs =3D new_thing(current, &sc.reclaim_state);
> 	...
> 	set_task_reclaim_state(current, rs);
>

My understanding is that given the current restrictions on where this kfunc=
 can
be called, this is mostly a defensive and shouldn't be firing (?). Given th=
at,
we can probably revisit this when such reentrancy is necessary, even though=
 I
doubt it would be the case in the future. It will at most be invoked from a=
 wq
callback or a kthread, so should be fine.

> ?


