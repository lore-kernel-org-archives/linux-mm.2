Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4086F3C9A9
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 15:58:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D50E66B0088; Tue, 24 Feb 2026 10:58:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D31E76B0089; Tue, 24 Feb 2026 10:58:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C09D46B008A; Tue, 24 Feb 2026 10:58:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ABCDF6B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 10:58:46 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2DE4AB6B60
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 15:58:46 +0000 (UTC)
X-FDA: 84479808252.22.41BCBAF
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf15.hostedemail.com (Postfix) with ESMTP id E9E7AA0007
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 15:58:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=YzHtuGK4;
	spf=pass (imf15.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.45 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771948724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K0Cl8twM23eFbKY4o+AiEr3XIzEfi52x6hS0RyhMeTs=;
	b=RSdjPpuQqkF4l9mckjv9nsSqHKHuoJHSaGU/fWrCfv5IuRAGdiqAdHVaQSNjt8AOi5Y8pB
	UFs8bn93n6zOq1ZOhpo4Z9GloXjHdLuK/2VJyWoXV5AJhnJiITJ48SRPJIh8hPFUlXecnh
	PghMdn0bKhbdMNibja4ihgmhD96NsKo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=YzHtuGK4;
	spf=pass (imf15.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.45 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771948724; a=rsa-sha256;
	cv=none;
	b=RT4+IjaaiK9+Qa8sLK1FTZwveasFycB9IcWsXRmmMdByP2DhhzB0qZj09Z1s/07I4YUAw6
	/4fsDAXYlJl4OMeY5u09E237nO0564MXVMZpHstE2VOSAaweEWDoSJ/Hzawj4UTv9jjN+L
	sRo+mjR4ftEgl7cH5JCFSfquHr8Eh7I=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-89577f866d6so72083236d6.0
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 07:58:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1771948723; x=1772553523; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=K0Cl8twM23eFbKY4o+AiEr3XIzEfi52x6hS0RyhMeTs=;
        b=YzHtuGK4d3+Qfa9LkSr5vWYAFCSl5ie0aSncdU7I8G4KHoPFhLOwTPgl0JqYZVTERu
         iAO4xevZ6zs1dr91Emn7oJlZbL/xojnYHEJ/CsAfCBkFSD6adAaID4ygBNMlZxSp47lL
         IrWtPqSf/1XTmbqW8asSSj19K7r0PW+JW8vfxC9QQs4L5B2KR1PLL8frNvi84EjOnfKo
         U562XlC52WeMQ2PyR8U5kHXwN1mOp2i/JKcnwK/t4VaJ6p4yP+Y4gaRJxC2luFIgN8F1
         WQ9+DAulVHe4rJNgNs9sqjZJLu0HTmLvB+omlpsG7cDuRPKDIiCQZms3vAJ21KPNzVNc
         xlTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771948723; x=1772553523;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K0Cl8twM23eFbKY4o+AiEr3XIzEfi52x6hS0RyhMeTs=;
        b=nkNgTDtpbXtaDhaHj8XQlblfuOTF0Dty74Ha++hs6pDQesRthtgiFqR2Zb82NoCrG0
         /JLD7Jx6Vui7oQyAYj6IwMhgNd8kmoWW0M4LDOlDklhkyEGX7uakMoQ9OiJUL9tQytW2
         u5Pu5X5VqssYeHALuwcBiOBGXNlwXG6Zrw3uMM5DzFs+CKadrPk5pohTT6dLvFOthwr9
         /P7lReK5IPSYlHyYWvITqLSq4DG2CVLiu1rPxpLacD4RGB/Zrp1ZA3hKYX2LZhqBxTB7
         NSK9nqX5MGQ0Ro927/ULKC/glZDczIut6rDMc9btr69TCRKuW+KNGaoGqwBKaG+zVQcA
         kfMA==
X-Forwarded-Encrypted: i=1; AJvYcCWsi1ZV4Te6e08dM2jjR8aU3VvD5PpFejUoey039VXJtWD8eGjL9nEoAnp7XYF+F7x1//e09Dqe0g==@kvack.org
X-Gm-Message-State: AOJu0Yy1ab0eG+Tu4EMYJNW1hxc4Qaayk3UcGQDc+eDPT/J2KHtN7L1q
	H4W/SxMwnKfeuNwrmOaR6nklb+D0W6dvqnI5SvcvpGbVWM3BB21Ro+rgmZSiLTOFgQk=
X-Gm-Gg: ATEYQzypLVYKF1ycEOjj3NpiVB/Fg3SV1/idVjPbmJqadWxiZDv0qpj25pF6YZ/nd+k
	u+emBGxQtPj82wCsBnxycCK7ttW+jRp70DrRa+bmCSHl6gT9skiz/CSFykR9eBKji9DC21rrXs4
	NJeWtBenuh32xo+BnJjmPqTOqJO1octEJzFhoPXiX+Z3xTM+ViAM8aYlclVUAEmyy5mHkiEFoqE
	gwOV8KyBtoo1GWoe6milfDkImA9aXScEE2qnrP9Z/v4QgNpsmhX31uibkUghF5uwLZ+Y0WhOpIA
	HBEtu4xbSaHCHECQh5ok9tXMRN7+2UC2gGQiB45C5/jeZ7oZVKnZV3gud7BvoTWQFHdlWJPppz2
	gAmtIiXcuesqXD0Ki87rOrn95ZxK6LGY+kHY/fIgKtuaf0QtIAPGuXJLSCJ33iHT6+KD27cMzDH
	eRVRzUnVx9eusb9kUAYYHYXQ==
X-Received: by 2002:a05:6214:e4d:b0:880:88cf:59ff with SMTP id 6a1803df08f44-899b34f0ec0mr7442706d6.22.1771948722556;
        Tue, 24 Feb 2026 07:58:42 -0800 (PST)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cb8d0ebcd0sm1219652585a.28.2026.02.24.07.58.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 07:58:41 -0800 (PST)
Date: Tue, 24 Feb 2026 10:58:37 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Kairui Song <ryncsn@gmail.com>
Cc: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>,
	linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Hugh Dickins <hughd@google.com>,
	Chris Li <chrisl@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Youngjun Park <youngjun.park@lge.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: Re: [PATCH RFC 08/15] mm, swap: store and check memcg info in the
 swap table
Message-ID: <aZ3KrfD_6vfxjRcs@cmpxchg.org>
References: <20260220-swap-table-p4-v1-0-104795d19815@tencent.com>
 <20260220-swap-table-p4-v1-8-104795d19815@tencent.com>
 <aZyCJ6pH4hey-ZoU@cmpxchg.org>
 <CAMgjq7Aq5ckraKtNtet8+1ANuqnitFsXxefbDJQZpBxNmaW7Cg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7Aq5ckraKtNtet8+1ANuqnitFsXxefbDJQZpBxNmaW7Cg@mail.gmail.com>
X-Stat-Signature: ayehmcpt3rex5tnwc1dj7rjcye18kkwh
X-Rspam-User: 
X-Rspamd-Queue-Id: E9E7AA0007
X-Rspamd-Server: rspam01
X-HE-Tag: 1771948723-533213
X-HE-Meta: U2FsdGVkX18QIRRGNgMCqdO8UxuxLLcLRPVbrJsSIzO2PEiADaEuypWklu2ZiXvqv7RzWxawpK9QHi5lgLseOeZPRvc6FoWQ7UiCmftvV6wkDP0zESrMXLoiqCb5upjfkYA8BhX/+7zgOdHl9m88uTye2X9tqTnjrJIIp43+bj3jUX5GPHZ2AlzqNYVQWWtLO8PfgKAW2U3QFeqqQncqSRT1EkuE/2hvKU/5h/uKzLGv13DpG5EY+5BvK8Pph7nGnwmUZs926A/mA9ARADxj/1PI5zVETpFU32p0Plwtqe9vSTvwcTKVoWpzp2eYfCN8gVzbnP4Y2pr++ZTLrquWv7GVx8+7frpas4T1TgJzmJlK0vKxJnODYFsKs318Xm0EFLbk3tNaxpkQ5TFDaklVZYr/p35D0VIADDaVwpymtV8xhdGoz6uLtWJOGJi7YcfxxIgh8hDXd/qVh3yOe0R3wUUK3xphUO9DDRzipGHAA9z26KK1Vmg9inOfz2biuazGJp/w8TffZ+y9q6VpMBfW0FEniJSSA4p1h4s7OL3xfLn+1l10sJ3dqhLrDMikdw5u1ZwntZQuSoM/75P3/g/CH6Bx/Y630yj7KvrhynYUmA+9p/Tnt7yX68TbUo9fdZ8rY+qzL+Vpj2rEDxnW2h9QD8a5+iwhr8EIyoqETyN/l4OxOZ995oYPfXgcm+1+XywcVQFcy8qEwaXXfWob2U7AYL/NGowUjunVuAVaku6nYaKIADQkyxlBRf5BW4CXg3IS6ubOKrrh/57wSVR1czCJZ74x6fmsr89cM5nl+qc/p0X2VTHWNEbVBa0CytTGr8H7AqMeBu1CnXfcpQT8/E19iaeXZKNwWgqDHTHraA6PGKrmpPzqoaRaOrlqokYsAuFpt0SYCDMoTJUulMaNhye0SHWQuQxFjnTGu5R206Jp9YzsJLSleDuUPDmW84XKnBcKEw5g/nCovFkrTYi+tc7
 JtEOII3d
 YEjBzbN/5gbBWE8FTSwHmneoDKUlZHg5/xu2WEYP4uVQuiyjRZik+TGuHxgiH9wAmCXK0zae6yQ7RYlDnIiImd7yvInY3b5N2Pi3mNihtSCzuE08rIIksLVWbAarsS21gJZ/eDqTWfiKQn0wMKxTa9wFX/CR41AVn9VKWK6tfrx78x7tLyDelbZVyaEpFlmCVLY3fr5WgBp+TcrRUACnpF+EO0WuydIj5lEbd+IKwWiWwPaj+EST96W0grlPd4VMtBogot0km4bei9geRDiYhZBtwh+GHF1e2dSvUwPMpDptGD8L3O6aZuA91v0pUfWVlPMjFlCzbcgDhdvQ+6nAL5gxCHbu1XFidXtcGGajbACg/TehHd6e5vKhTAWQ26JyTS4lC3iP/gnHjkhOEFLuRk0LH0vOkeWgxX5k0hOFaJ1NkrxpX6fvEhpUGxWDyFJvOsmxMOd0beTmpAsXmJhZXbg/5dt/6uUhgCuksQ3uKb9v6N6iQiUKOR4MFDyKl4P7y8eEnK7Zk5ZPxioBbZKjEsfWO/jXwP96qAuq5LMA2KqrqlMQrtKR0FwVlJEaWtZsp4oFH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 04:34:00PM +0800, Kairui Song wrote:
> On Tue, Feb 24, 2026 at 12:46 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
> >
> > On Fri, Feb 20, 2026 at 07:42:09AM +0800, Kairui Song via B4 Relay wrote:
> > > From: Kairui Song <kasong@tencent.com>
> > >
> > > To prepare for merging the swap_cgroup_ctrl into the swap table, store
> > > the memcg info in the swap table on swapout.
> > >
> > > This is done by using the existing shadow format.
> > >
> > > Note this also changes the refault counting at the nearest online memcg
> > > level:
> > >
> > > Unlike file folios, anon folios are mostly exclusive to one mem cgroup,
> > > and each cgroup is likely to have different characteristics.
> >
> > This is not correct.
> >
> > As much as I like the idea of storing the swap_cgroup association
> > inside the shadow entry, the refault evaluation needs to happen at the
> > level that drove eviction.
> >
> > Consider a workload that is split into cgroups purely for accounting,
> > not for setting different limits:
> >
> > workload (limit domain)
> > `- component A
> > `- component B
> >
> > This means the two components must compete freely, and it must behave
> > as if there is only one LRU. When pages get reclaimed in a round-robin
> > fashion, both A and B get aged at the same pace. Likewise, when pages
> > in A refault, they must challenge the *combined* workingset of both A
> > and B, not just the local pages.
> >
> > Otherwise, you risk retaining stale workingset in one subgroup while
> > the other one is thrashing. This breaks userspace expectations.
> >
> 
> Hi Johannes, thanks for pointing this out.
> 
> I'm just not sure how much of a real problem this is. The refault
> challenge change was made in commit b910718a948a which was before anon
> shadow was introduced. And shadows could get reclaimed, especially
> when under pressure (and we could be doing that again by reclaiming
> full_clusters with swap tables). And MGLRU simply ignores the
> target_memcg here yet it performs surprisingly well with multiple
> memcg setups. And I did find a comment in workingset.c saying the
> kernel used to activate all pages, which is also fine. And that commit
> also mentioned the active list shrinking, but anon active list gets
> shrinked just fine without refault feedback in shrink_lruvec under
> can_age_anon_pages.

                    *if inactive anon is empty, as part of the second
                     chance logic

Please try to understand *why* this code is the way it is before
throwing it all out. It was driven by real production problems. The
fact that some workloads don't care is not prove that many don't hurt
if you break this.

Anon refault detection was added for that reason: Once you have swap,
you facilitate anon workingsets that exceed memory capacity. At that
point, cache replacement strategies apply. Scan resistance matters.

With fast modern compression and flash swap, the anon set alone can be
larger than memory capacity. Everything that
6a3ed2123a78de22a9e2b2855068a8d89f8e14f4 says about file cache starts
applying to anonymous pages: you don't want to throw out the hot anon
workingset just because somebody is doing a one-off burst scan through
a larger set of cold, swapped out pages.

Like I said in the LSFMM thread, there is no difference between anon
and file. There didn't use to be historically. The LRU lists were
split mechanically because noswap systems became common (lots of RAM +
rotational drives = sad swap) and there was no point in scanning/aging
anonymous memory if there is no swap space.

But no reasonable argument has been put forth why anon should be aged
completely differently than file when you DO have swap.

There is more explanation of Why for the cgroup behavior in the cover
letter portion of 53138cea7f398d2cdd0fa22adeec7e16093e1ebd.

