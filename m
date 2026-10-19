Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EDB1606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 23:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gNXTSu92
Received: by kanga.kvack.org (Postfix)
	id 191B36B03B5; Mon, 19 Oct 2026 19:36:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 142B26B03B6; Mon, 19 Oct 2026 19:36:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 009E06B03B7; Mon, 19 Oct 2026 19:36:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C970D6B03B5
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 19:36:03 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 54981A08C3
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 23:36:03 +0000 (UTC)
X-FDA: 85340986206.05.1F5C901
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 762D6140006
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 23:36:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gNXTSu92;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792452961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FhKtU5w8GBj/yeJDEwS7da8UC+5x8nc458iXyjzet9g=;
	b=ejijSwjQKnP8IVaiPmXZoiwZc9jz5MU6IU6YihyDvmLfvEnye4lk6vkpj/HBKYNQx3HmjX
	ohpFFXtFXlU4xD5Vu9MCfYj0RPK3DNvxYCJB2NHFy9PiCGGsv2+ijb4s23AIremaZRh+NH
	DWHF+6aXlbflmTwFbl/TFj1B7g6OfmM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gNXTSu92;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792452961;
	b=lrsQD6jxaylvJGZDwxshtyCrYqkL7ij6YOolmX1Hd3WiFm9SxMMHE7gts3cbuqtA68nSM2
	f2ljadjrlOOobKkplVzRaAm4pRAjpXpCbC+QidGNwr/lPSt6Fu1qA/2JFpxPNhdAzd68VV
	hKd0T3FHA8fePJ/1f16ZWkQA/6WB4mo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DF1F460A5A
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 23:36:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E6831F000CB
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 23:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792452960;
	bh=FhKtU5w8GBj/yeJDEwS7da8UC+5x8nc458iXyjzet9g=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=gNXTSu92jBmXmdxQAiSfPljfEV05rK6BJ3RpiKEQ8XRwVUwxD47Iy2yQpmQPI8rGr
	 a0tfbEe44MYi5/6ImPwdDhvNth6OoSa8+tru3+d3uAeRTNUfHBgvnUj7jcYiCw5ccj
	 jNytduKQoMz+o9r04sXSCNlimT5Yd7+Ze3Gh3NqdOyr4c4rVoU3yt5Dbbn2vsNyxN6
	 H8pLOjIDJmJ6lw+sROT8F8pILSFhRFf9UebtFlcF5gJI15Ah91X5Bg+z/MUPLLGrsi
	 GQG1m9eRlWKo8K/1Mk1gF75G7n5exymRzJYA//sgauhgH16Zd6jXZd3I1NW5IJzPoW
	 M4qt/rrJoq/BA==
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-930c0f9c1b1so258380085a.1
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 16:36:00 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByfUDmcPI8VWvJpGxRjlfOlCH7XEyZknBio+bnqJrKtYZMSMkUVIaz3QzdMhUO2dMQfcoA7on1DjQ==@kvack.org
X-Gm-Message-State: AFq9FYLXWVWxjAFjQKJFptAl6TFSrwcNP/Bmi47/4wMDBL0cSVZGC5ET
	Jz652YShdChWaN91wwonudDdrUDrhq1RcdgATxH8XejDl0/gXbRmnZjBtD6NFiK8mnihTvbix9g
	e2+c/vrsADX6IWzAe8TbqBQwKobYEy/s=
X-Received: by 2002:a05:620a:4552:b0:93f:3829:8494 with SMTP id
 af79cd13be357-93f38298718mr932075885a.31.1792452959559; Mon, 19 Oct 2026
 16:35:59 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261017050928.128582-1-sidchintamaneni@gmail.com>
 <20261017050928.128582-2-sidchintamaneni@gmail.com> <CAGsJ_4wGq9oc05=-g4aWptLdCbTwUjMjXk4Rd6KjJ6x=tzMm+g@mail.gmail.com>
 <CAE5sdEhGFtGF6LC4xNkMwGj3vTxLOW=GNBXnk3-JmsgjntXx0Q@mail.gmail.com>
In-Reply-To: <CAE5sdEhGFtGF6LC4xNkMwGj3vTxLOW=GNBXnk3-JmsgjntXx0Q@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 20 Oct 2026 07:35:48 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wmvBvEn_vXu8-c6BRAnRewYmTs8iUd8T7KRx7_svZrwg@mail.gmail.com>
X-Gm-Features: AclHuK_aaDmiOoPjOifUmGBKmvM4s-x70UIqD7plw7aV8rDhARGqcnWCGr0bz_Q
Message-ID: <CAGsJ_4wmvBvEn_vXu8-c6BRAnRewYmTs8iUd8T7KRx7_svZrwg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mm: multi-gen LRU: fix NULL lruvec->pgdat deref in get_lruvec()
To: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@kernel.org, 
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, ljs@kernel.org, 
	kasong@tencent.com, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, 
	yuzhao@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	apais@microsoft.com, rlmenge@gmail.com, stable@vger.kernel.org, 
	Hardik Garg <hargar@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 762D6140006
X-Rspam-User: 
X-Stat-Signature: 4nb5w4noci156qb8bpjsb9bn8twqka81
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792452961-406403
X-HE-Meta: U2FsdGVkX1+kOxsgJUVPfjG1HXp6atdOETVuuF+6d8LFZz057BzXeZ8pI+r1VdRH5aJSAEulOmMQJg9UmOke1CJhzk+rsfxQWITF6zspasHQIsux2D2vtD4FsR+KrrD3fBcLvKst4JbOIWLAMiyRcQ7daTM4sLwe5rKjryjFMeJpz3tn3y+BFKHaVO4iXM6Z654PU76Y3cw2k8Dlijw+7TcZKhueW5bUzGa2rMprMeRTgLQX1Kdygas+WX97PmYWbIeLXY6vEYNdz/fkzXIk604zRERGKwfuZ15zdPH1m083Aa490h41gQXRLkhC0qhrjpaeigtN19fLn3FrlRpa1Q7wD/yNaV3zTAqNSJMOV4AoOe9C5Hpoy4JxymDXkd4nCk8vXW9LRtYZtja71DRuViz1QqXjXkDM49b+noN6YLfgcdA4B4Z+P1/HO13HBltnzAbox6nBuKRS6lRc2vG+/F6d3ZKIzV1UfRzUVi8kwCArYRj+A9YD5+o82HOnWru6nzKOnbeno1AJQ7SVbQpedKDKHK90IvsLHVMHKFEHU8atIHEmAYoT3VLnZ47WM7dbF6Kbb6BftXJv3plKQx1aDRLhtFolFwtm5r9KAA7pcJ6Sdq4pyJa4eRifTb2wwFJ3Zn3npftONSG5h+it600jGKp3o7ePY/qqh6XXFSQivG/QlYtLT+ABDVMZ/sAplTckRryXGkWFTyDjveCuW0b5SCvkbNyN4JAy4NC3bxjXdi6FZMLyMdz/zBfvsDUKrp0W6Q6inPhV5SBg8nQdG6hNTG3rsDpYdkEYZBOQCoxmZ+nUUV0I22T6JiSTUKEXvRbtdv+FjfBeJXs0ZlpzSxQeUcDbJ696e9k7eh7WkvjunUthT53MPKDrWy2GGNsiHmXbe9gTO6VcD3uwjtAGXlt17+gbs+qlfFjh6DtCyEGusb3sUdnzIZWt1vNGjMK49ztNDiw70yvHUuzCpVaTUM7
 tSE+oKut
 eAmug2eCfMwUTYPb9j0aonSMO8iMpFNQ/pTl8jH/w6DA+vsp/IxpD5kFXI49z+pCJLn8+d6QwdZR5KsC+lmQ5qOMEDZQQ+oQImNDZtdyB41hucc6jXppafHRBVnsv8zt5HJnSHgcSO2wEZOfuIfAOwpigIcOr2l/5DxcfGvjhQW0NcRMKx9Ajn7JYQnLuUhXF86BbyFvCgwaFRDfupld/mhIy4fahmaJm+Dvx0B77KrtwcdFDcRMxS2ebbNmD+yUheYP2WxU/n0tyddpVlJGk2XK9kY8D4mwcjNy+1ou3jnKpi7Ug/Z1C6F+dvPUigYnyr448JjS5q6oQzrD0zCMeZ9/22RUvjazJDZ5mH+seNznqzzBX+8bSJJ/oBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 20, 2026 at 4:33=E2=80=AFAM Siddharth Chintamaneni
<sidchintamaneni@gmail.com> wrote:
>
> On Sun, 18 Oct 2026 at 14:24, Barry Song <baohua@kernel.org> wrote:
> >
> > On Sat, Oct 17, 2026 at 1:09=E2=80=AFPM Siddharth Chintamaneni
> > <sidchintamaneni@gmail.com> wrote:
> > >
> > > Andrew Morton reported that get_lruvec() has the same problem as
> > > lru_gen_shrink_node(): when memcg is disabled on the command line
> > > (cgroup_disable=3Dmemory), it returns &pgdat->__lruvec directly and s=
o
> > > bypasses the initialization of lruvec->pgdat. The MGLRU debugfs
> > > interface calls get_lruvec(), then dereferences the pgdat pointer in
> > > lru_gen_seq_show() and other paths, so these can hit the same NULL
> > > dereference.
> >
> > So userspace must have booted, since otherwise we couldn't read
> > debugfs. The reachable case is therefore a memory node with no
> > LRU folios when debugfs is read? So this could happen on a multi-node
> > system where folios are landed on other nodes but not on this node?
> >
>
> That is my high level understanding. I'll let Andrew to comment if I
> am missing something,
>

I made a silly toy setup by running two numa nodes with one of them has onl=
y 4KB
memory, the other one has 1G-4K:

qemu-system-aarch64 -M virt,gic-version=3D3,mte=3Doff -cpu cortex-a53 -nogr=
aphic \
-smp 4 \
-m 1G \
-object memory-backend-ram,id=3Dram0,size=3D1048572K \
-object memory-backend-ram,id=3Dram1,size=3D4K \
-numa node,nodeid=3D0,memdev=3Dram0,cpus=3D0-1 \
-numa node,nodeid=3D1,memdev=3Dram1,cpus=3D2-3 \
  -kernel arch/arm64/boot/Image \
 -nographic -append "cgroup_disable=3Dmemory
...

Then I got a machine where node1 is very difficult to have a page in lru.

then i ran the debugfs for mglru:

/ # cat /sys/kernel/debug/lru_gen
memcg 0
 node     0
          0      14972          0         953
          1      14972          0           1
          2      14972         18        3308
          3      14972          0           0
 node     1
          0      14972          0           0
          1      14972          0           0
          2      14972          0           0
          3      14972          0           0

now you see node 1 has no page in lru but yet i didn't have any crash.

i think i will need more time to figure out what is the problem and how to
reproduce it.

