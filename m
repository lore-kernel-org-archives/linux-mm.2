Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B8DECA0EFA
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 22:25:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58BF58E0069; Thu, 21 Aug 2025 18:25:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53D878E0056; Thu, 21 Aug 2025 18:25:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 452CC8E0069; Thu, 21 Aug 2025 18:25:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 34A938E0056
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 18:25:38 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D052411806A
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 22:25:37 +0000 (UTC)
X-FDA: 83802197514.24.0090FCD
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf29.hostedemail.com (Postfix) with ESMTP id E76AA120014
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 22:25:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=A5PI+cn1;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755815136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UxGwaneklEuoMgdpuTZgMXLt8KwC3lX/BurqK3SzmgQ=;
	b=6hzJA02hMnFbQ2oONh1nlJXXyFPZBtxQGGik3gdun6UnxUMD/43/jgObw+c/IlWVTn2grq
	oXoKA6igvrdRq5/jprSLpAF/A3TOqbDd5jkuMjM2q79ZkDK+r1nMmaV0XnWkLxt/KmxXv1
	iUpwVYW9yeEzrA8skGuVN3nXIRlE/Lo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=A5PI+cn1;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755815136; a=rsa-sha256;
	cv=none;
	b=57JdKD0QaHQ6XkMX3dYKBckKeVi91dedvPS0VgUPP7ZCAdYPQoIxzUWjPckCQ9dg4ryYw5
	oHebGKInL272UDU1Ew/U+rKBw5CKFJSTO1Bt352ic3C8ZbbBvkdanAP9NYP8odmFyl2KoI
	tS4ZSPXkVcw4Tj7KZRQFwhN6zjerKmU=
Date: Thu, 21 Aug 2025 15:25:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755815133;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UxGwaneklEuoMgdpuTZgMXLt8KwC3lX/BurqK3SzmgQ=;
	b=A5PI+cn1DU9QLvz2iLs8e7hbKx5Tu80+L3JyEkBLiwMXENfZDbmMKIUR7U3/BcGTymVzpF
	i7IKbkQUN9fZryt8R4lKD+3aA2vUbSthhaFICBXDkNDbwwhL+vJrhudaRREzYcJ5Drv5v7
	UD9So2ZuJwcfvQ+FZ0dcxI5UNWsUOEk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Boris Burkov <boris@bur.io>
Cc: akpm@linux-foundation.org, linux-btrfs@vger.kernel.org, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, kernel-team@fb.com, wqu@suse.com, 
	willy@infradead.org, mhocko@kernel.org, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, hannes@cmpxchg.org
Subject: Re: [PATCH v4 1/3] mm/filemap: add AS_KERNEL_FILE
Message-ID: <kagqatguxrcxsb7ka3vq5xfm2vbjly7ixletkxwbyyq2uisnly@frthso35okfd>
References: <cover.1755812945.git.boris@bur.io>
 <f09c4e2c90351d4cb30a1969f7a863b9238bd291.1755812945.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f09c4e2c90351d4cb30a1969f7a863b9238bd291.1755812945.git.boris@bur.io>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E76AA120014
X-Stat-Signature: n3e6gzzr9u1gzgm5hmtsfzpqrzzxm1nq
X-Rspam-User: 
X-HE-Tag: 1755815135-804346
X-HE-Meta: U2FsdGVkX1/VdZZbfYOs+QDLQ4ifOq27sW341tBr13xqPjLSPSuNy699Zcytwcumh6/j7/cqRDRehQA7kCWDD8h7DZrTh23dsDzFrGwvnDy/tXJcsnjLBaf87G8sGXW5C14hp6NiYozvzu9vojoTqJdvF48egNMEUvzbORIgoHyp8TQvL7s8kqB7vtRHTmCq9Aextr785NoHmjZH/WgEeR5LqsyW9fXqDFSwM14zounv5AT3htkaQdOhWcUGn9ytxr3OcEonmLv++q8WhhTdpyp3lCQRtZeywMOAhJlp8T4eujFq7D+5d5o0EdCnF0iYMyvLmUALI0Kesc7Iqi34/DuscXTA6p5OKTkrfV5zAgN3+/9tV0xN1yblGjR/4sbY/jUz0og0hDmMULeIS7PT3DnV6RgidJLb0QChB4urbVkjuCPbiLtmUz0gyOk+3K6vR/56Jt2m8dkl4boe0htSh1rWHrrSWEuxuMLWZCiPgsv7uGRaEZXkLPmljfyLl4TQEw1RI2bnFNajKAUKItOcle1hGW+Upr0xkFH+19/kg1WREA9BR3a4jmrQiu5qfSw7VvszKEUI5GMgPPP4aRDZuadpW5LI2fU2DPj9bI0kXz23urmYMfI/dATDoeRNe5+a32B41qQeRX5GsavEtTEKoVpUoDx4Qb/IHSEeLzSPoqZSu5kE25+YeDYEePaAw8WxqY9f2qUitBCXVFJKdPdZy2tyVwBdbmdCBQfe+VaW8HCrEWcdYx0OhlP2PqREBVRh0Y3+GZqwml0HQRSmZCMKW8+3wXmwzp+R1CsjxKJ8a+i40OriJocwbzl3ajTqB4UtmNFQXF6OAjHEFI5ras0k3p7Y3NqX/OxEXX9fvwLRSyJ/tn6ICx7AFwpVKLHVd7a2yJgp4sCg+obk4Qj6B7HWXtLP8KPCE0kzwpB/5PdgkN+LClXgusUibSp11BX+zYw8HZxFvxcvm7FI0poydfw
 ldfVBHO1
 5prday9lnTR0oe5zOdCpDG+BBjXcR4lxqp2ykl+mc5uWTCBMBJRtdCeR/Ep37S8KPLP/09CjFXOe+BIB77Z4fsYVH68SvMGrs71WF8b5VJYLmiYtlbIoCvflKEdAxWs8pgXs1sfZUo1h85Y96BD2M1sz5CN6QYA9gpBqRCjx+rxd8VhhGSyKNGgmOIVcpzg56/kR1QhZdt3afpwachGMMWZ5UAT0JrKM18b1zwVI5EM0zMhSStYklLJhgY/1Inv04t8HiQ+lH2mD42hSYkwbXFPd0Lv0USlrkxPL/XMT+KR7WWg80GgIzalq2Dr2qr/ePpNUhGSpN2C/DHsg2TcfNWfyJxkzXE/zzMPiKvjCMzEB1SJqx3zfwuzCFIB+OckBNsAIEoIgVD9U52vBuCo7qkhk+Cg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 02:55:35PM -0700, Boris Burkov wrote:
> Btrfs currently tracks its metadata pages in the page cache, using a
> fake inode (fs_info->btree_inode) with offsets corresponding to where
> the metadata is stored in the filesystem's full logical address space.
> 
> A consequence of this is that when btrfs uses filemap_add_folio(), this
> usage is charged to the cgroup of whichever task happens to be running
> at the time. These folios don't belong to any particular user cgroup, so
> I don't think it makes much sense for them to be charged in that way.
> Some negative consequences as a result:
> - A task can be holding some important btrfs locks, then need to lookup
>   some metadata and go into reclaim, extending the duration it holds
>   that lock for, and unfairly pushing its own reclaim pain onto other
>   cgroups.
> - If that cgroup goes into reclaim, it might reclaim these folios a
>   different non-reclaiming cgroup might need soon. This is naturally
>   offset by LRU reclaim, but still.
> 
> We have two options for how to manage such file pages:
> 1. charge them to the root cgroup.
> 2. don't charge them to any cgroup at all.
> 
> 2. breaks the invariant that every mapped page has a cgroup. This is
> workable, but unnecessarily risky. Therefore, go with 1.
> 
> A very similar proposal to use the root cgroup was previously made by
> Qu, where he eventually proposed the idea of setting it per
> address_space. This makes good sense for the btrfs use case, as the
> behavior should apply to all use of the address_space, not select
> allocations. I.e., if someone adds another filemap_add_folio() call
> using btrfs's btree_inode, we would almost certainly want to account
> that to the root cgroup as well.
> 
> Link: https://lore.kernel.org/linux-mm/b5fef5372ae454a7b6da4f2f75c427aeab6a07d6.1727498749.git.wqu@suse.com/
> Suggested-by: Qu Wenruo <wqu@suse.com>
> Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
> Tested-by: syzbot@syzkaller.appspotmail.com
> Signed-off-by: Boris Burkov <boris@bur.io>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

