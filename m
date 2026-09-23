Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81EFBC98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 14:11:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 676316B0088; Wed, 23 Sep 2026 10:11:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62C026B008A; Wed, 23 Sep 2026 10:11:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ED0E6B008C; Wed, 23 Sep 2026 10:11:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 27A246B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:11:52 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 914A01A07F9
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 14:11:51 +0000 (UTC)
X-FDA: 85245215622.30.F49DE75
Received: from mail-yx2-f13.google.com (mail-yx2-f13.google.com [74.125.224.141])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4FBF680005
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 14:11:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=IttdNk1I;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf30.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.224.141 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790172709;
	b=YgXdMctNL+ruxdvfQbP9a1+gVtWN+dBuyTh+9910qjFjDzJPf8CmiSTaDTXakpW/QhZfV/
	6PREkbF36KHJYDMUD1SUuPpLJQ68XBGHQlL1zg04c5n0mUSYYLPkyFe7zihCMVL7zn4gQ6
	TbdrmVqyGrMWAb+0y/zlqM2Ka+0yMeM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=IttdNk1I;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf30.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.224.141 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790172709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f7LX2hgCSw8Eo3VcIXgLYrzvPbWMXRZn6yDRkmN7Gj0=;
	b=S4Wxriaupc6ym6B10bIL9VGYurOgDiD2BjiF4ltElvlfQXkb/Nx5M8P9msxGvEJA6Vf5ty
	tt8fy6lihedvNTXIQU3KYx3vRKiTIKNhjHU7SkQQ3t12QXkS/lrSqN1fsqEMie26K2ad5R
	U1nZOcbT7jqqXQVG4pBEC7HKDUevTho=
Received: by mail-yx2-f13.google.com with SMTP id 00721157ae682-85d43f9b120so13154467b3.3
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1790172708; x=1790777508; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=f7LX2hgCSw8Eo3VcIXgLYrzvPbWMXRZn6yDRkmN7Gj0=;
        b=IttdNk1IN8bJqYYnllB1ggabdMq7NR2VsZ96lIKZGBEB6e42hUvrL6jz2h1bIsaEWF
         YlMxNtg/MW+CnrHIOux0SpmlzcxJUnI2aWxi/QNcKSSyE2jMFbZ4c7pBq4HjCXBs2cX0
         gedp2g+UBhjAQwb3SVl6tW0qdIqScoMtA60u+qeOIk4Vg5+7tnpQH82X1A5xMqYfvEJL
         3FbORBu/TR21CJidBWbj9QWkuTOKYl/e+2uOPBQ8mWCzUdlNy6GrJxV8sFgYVLncuK6s
         sXFZuaLMA+Kvnv1aplKMgdsWuOAuIhYEKiOxCyD6QLtsTiVz1qjXb61zaI5Ev4kK+DR4
         RQfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790172708; x=1790777508;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=f7LX2hgCSw8Eo3VcIXgLYrzvPbWMXRZn6yDRkmN7Gj0=;
        b=Gx5NR3mWOSACI49pv2scRu8LwElAmfwshh3JlNWwDxD+72NCq5YNPZAvhQpoSDaZ8w
         ElKm2CwFiFcQimSvwxZXQkI3yQ7DSszU0gRIVlGWTopEbwvKx1hb3SYv5NRS+Iva7fqq
         AKT65oeU8puBTrSAzq2+lwnnt9ZqmRnlBsS4E4huWCdu/WhsRGVL4fHrUivx/a8cl48C
         s+R7jBOTtzzk0Qv8I9R1Lr53C6V44txZrmJONxJulklAA9daZ91qzEv+ZNRecCXrzG39
         8cCA8Wdh7Nk8/07KSr7qkp3YJzC3bJndD5tijky7AnmWWzZyVZyVbA5hMnKEqkcHUdzJ
         PplQ==
X-Forwarded-Encrypted: i=1; AKwUvByb9yDvWRcWSgas7u3yf3oI4Fh4n+b623vv5/4tOtL7nC0WwFgb1l7CaUNzJ6cXyGgIEwJ7XKzQ/g==@kvack.org
X-Gm-Message-State: AFuF++ml6KHjteOUH01QpdSxnxMTSSP2JSvbU9lDp0VIxrDqxSfiUkse
	um5Jekg48yFb6Fl3WR+V185mJ4uCOcSVbJa982bl2fw2zeQP8gqFUEoJ+oTZvFR+MrI=
X-Gm-Gg: AYBFou0bmWie2tPHZw8c2E/oABAux8E9AwaRcIUYvQ/pr42oDJOn1NaqS+9b/zXxDST
	iRZ6Ru5oXqz7vmU7pXow8RU7rdDUKx13SSIYLrDXjc4v5FB/gR7FeXgoT0u6ZziD6LB6s5NdSoA
	o9ReahdOgR9PwZOrovm/fEyhiQpDD60qevTpA3KEupBNgIuvZ3MLQ6nAX0PeRQUaghA4tH4cRn3
	bzVl9Kp+w3vOotbRJg+t9DCgXhztn128rDXNXkZcnuvJogJE37hO0paBYpfv/qyXpo9xg3Fnzqd
	gS3YWOJ5LArUMCbObmGtVvKaYJZ+kcMHSWLv9ZCY6SvXuN4vdkyvrjF/hbJNeiQGgEoLvdqRYW9
	0wM6Vx9EBzaTdlHUY08kuToVduObBZe1E3J4YWpKqrOdIfettK33Z0PBCIg+z8ZiL9gL5HAJuNP
	v6MxVp4Qs3KjDJGYEPn3hJ4PuiBuZ03GQWGtMtVNp67v5CJs0HN3p0HVzxtnFG4tBoYhNCP2wYS
	RO4sHA=
X-Received: by 2002:a05:690c:5705:b0:89a:63da:faaa with SMTP id 00721157ae682-8a45c8372f3mr11122287b3.101.1790172708255;
        Wed, 23 Sep 2026 07:11:48 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532eb3396f6sm20644991cf.19.2026.09.23.07.11.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 07:11:47 -0700 (PDT)
Date: Wed, 23 Sep 2026 10:11:43 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Chris Li <chrisl@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>, Rik van Riel <riel@surriel.com>,
	Gregory Price <gourry@gourry.net>,
	Baoquan He <baoquan.he@linux.dev>, Kairui Song <kasong@tencent.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Barry Song <baohua@kernel.org>,
	YoungJun Park <youngjun.park@lge.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Wenchao Hao <haowenchao22@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Tejun Heo <tj@kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-doc@vger.kernel.org,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <ryncsn@gmail.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <arPeH5MPDaD95aDp@cmpxchg.org>
References: <e879ac65cb0940325736df7984c737edf1c6be94.camel@surriel.com>
 <CACePvbXThspPYD8DZkAeiJtYuMV79vGgC1SGhpMwhn4COWOtcg@mail.gmail.com>
 <785353ef79844e81a8cd97e87b00ef1f785b15e5.camel@surriel.com>
 <CACePvbXZ4i-DsmbQdNtBQb79y59uwZC9J8qHD2wTWpcYaet3LQ@mail.gmail.com>
 <83539be885f15bb567b30264f5f62e718f4a9fd0.camel@surriel.com>
 <CACePvbXZQERwLF_f2FYTHsv--kq_-Aw2vVVFF+z+ovdnsHy1bA@mail.gmail.com>
 <a75b2eac4297ca6b238dde6f9246d2c1807b935f.camel@surriel.com>
 <CACePvbW_-6M63_a7Cp+09dTmpHeMEdj9VDQZf8g8qoYKQD=wvw@mail.gmail.com>
 <CAKEwX=NrN7-u7gnGvWX3qfHaBQcN6FKsFP-4-k76F=sxM1LJqg@mail.gmail.com>
 <CACePvbVuFULQVvi4UOrvKaJ-5kdWWU5iJH20gH-9nZ-6ZbEqMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACePvbVuFULQVvi4UOrvKaJ-5kdWWU5iJH20gH-9nZ-6ZbEqMQ@mail.gmail.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: f8x9f53pnwx7hmrctqut8endid38wj97
X-Rspam-User: 
X-Rspamd-Queue-Id: 4FBF680005
X-HE-Tag: 1790172709-1033
X-HE-Meta: U2FsdGVkX186U+YbcyVWqVBfQz5YCU0di5cBGFkDIrCK1YUjxX0NZsGshV67texSq7/drZkRMF5jr/4QoaJMZYxqu9IeEUscM6Wr2FPpIAnw0GNwcfcO0xlT61yGxFlvft7H+tmDQm+VOX9gM7xJD7jbCwr9mt8bkCaJei6DazHS6M1sWberlFySz/KRRjkpGQ/T3HOF+fWtTXDFpnbEzmIcuMhftOnLm/sKZJiy5b+GckQu2b4Xp7cZEMXeEj/7DAvuF5o6xOkeNYEDGGm8nxypn7bnOW+RxEQKgfIo9o1HaoQeOWuAZV36NnOfbk9njzr6BqU1sbl0za8BzB3bL7rAmS80nExYTJBHtj69+gYDroP5bO4CsD9qkwc9fqVKEVuxLHVDZMnIFiXF62ce9aDSSiD6DmUu/zM7obJUWwFnEXs00n1dBAjCUHrHCQpxwekyLv/8xyNK21SW9k7dUoeVSpqkmNJ7UjN1iVWf7YdQaSCYfV/TGcUXmBA6DL1YTuOb/kl2NI8dnw25n/UV22reOFzjAX24kMgvKEMxcB2tHk496A9WDZYgCDzSU/2Kr5rqawgaqOrIVDNQczPL5ctysvrOGMZmc4hA7mm0EazgITarlmZtRzaKLspSNtz4pUR2PyYVrp8N4eQ+mD+mgZ3GFTSwKK9G05jIXzs9IHD1CfU5AXPKtsnbSQdpO7ZkBZw+EqiyiCwWvdmK78SGXUky1aUsLNW3Ogz5p602Feo+IXIiFuYoOCI6+yYN43bKiBAIUlaaT034A3gvEDISEL0JM57QjWF2QHMoDhLI77pKlg9gdES6OyQu3N4GcCEGygadNAy0/uHXjwS7TmSANJnz3p1chyOw3iJtK/OKUhTOPZrWWCsGpT8aWo43vvR5Oc2W7wzO6oZ3cJTLSUVTRuiF0/MGWhamZ6Fuf/4HSS5uq6xvbNy/hQ6MfhBWdRzlbWTcpCMk9CkUWQJThe/
 IkmR9oN1
 O/Sjm+TK/UE8ti7SMvuxWBHTj9oARbGBE0r8huytn3/iYjbigsmQRoYtmocIVqUIBrzelmXKLktW66L50GatVp9Zy2efmC1czLegUhsEWUIBv+53dBkMloNRlhx2EOeAk4Cy5fX4gKAkueNjrDzthZ0bFZb/KO0fr0FMorvWnUOykHt+Hxn62Ev8dRwyUiWEIEjWOFvOIUV3eH8fTa42qXj5+Oogfs7HpEPrZFvsIl0lsu9S2OJ3QSc0E5ECBWrx1LIjxuWH801TWJhD95Nwm6yHSe/S6TBrAPdR08YmFvvgSwhVDpqyUjFwgB496APyr6Tfetr7z7Kbo9lffLVmyA+SlnO6nHt+vxedMzqeh8hzslFiYlDJyBvpXLSJY3KwzjKui2lX6AjMB1P6vFn+R00fI/WXhG+PG6eQrKz4Ocs9vEzvXpJxBurVqTcZBDtPxqS0mASfCFo5p7yA9cQYjv9FJQ5kzt0PmWuz0QjBecTt7cbxD0QkwIg3k+0qVUNitX/RnwUGSZBtNZ4yuWn/ytN0UFNVSjaMFrf6ieziw2skLyNnU6ullPtGyL5MDOLday+zNpNSdui/QxkWc0Hg9o0xAhnhwlTnEbAksvasVp1GsAEk28w5Si8wfnOpfi6va3bqYtICjirNe14SmwSEj5P+wRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 09:37:48PM -1000, Chris Li wrote:
> On Tue, Sep 22, 2026 at 7:33 AM Nhat Pham <nphamcs@gmail.com> wrote:
> >
> > On Tue, Sep 22, 2026 at 8:23 AM Chris Li <chrisl@kernel.org> wrote:
> > >
> > > On Tue, Sep 22, 2026 at 4:59 AM Rik van Riel <riel@surriel.com> wrote:
> > >
> > > Yes, I can agree on what you observed. You are using anon + zswap on
> > > that app alone. That is not what I originally asked.
> > >
> > > My original request was for the whole system: what percentage of the
> > > total system RAM size has been swapped out to zswap.
> > >
> > > Because when you have 100% of zswap out, it will likely trigger
> > > different kernel code path on allocating memory. You might suffer
> > > global memory pressure you did not observe in the single app memory
> > > pressure case.
> >
> > What does this 100% figure refer to? Pre- or post- compression size? I
> > legitimately cannot tell.
> 
> The 100% I mentioned above refers to the pre-compression size. See my
> previous email in this thread for details. I have been asking for a
> max(%) number in your fleet for more than six emails now.

Because people keep telling you that it's immaterial. The job of the
compression layer is to make pages smaller. It has no business
deciding what is "too much", what is "too hot". That's the job of
reclaim and OOM killing. That's the job of cgroup residency controls,
of things like MGLRU's min_ttl.

You have absolutely no way of knowing what a safe threshold is for
every usecase now and in the future.

The argument isn't we need a bigger limit. And I refuse to haggle with
you over what the precise value should be.

The argument is a to use an xarray and keep making pages smaller while
the policy layers deem it reasonable to do so.

