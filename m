Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD884CD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:50:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08D016B00F5; Wed, 13 May 2026 09:50:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03E7A6B00F8; Wed, 13 May 2026 09:50:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E95C06B00FA; Wed, 13 May 2026 09:50:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DB4446B00F5
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:50:00 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 98AEEA0140
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:50:00 +0000 (UTC)
X-FDA: 84762530160.17.417556D
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf08.hostedemail.com (Postfix) with ESMTP id A53F916000D
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:49:58 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=n2uai5Ix;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778680199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Tp+YGNU/YWh4+mnxkJ6DD+LKecTb+noZ/uA14eabz0=;
	b=rsTH+7S3hmOgFwhREAuaL8eHVqjzaO7E5zxPw4Gug+0g5wiWL6jjOfxx2nNI4/Wvmftz96
	BKFXmUHw56+Arylbt0Q/qrIB6zULEM0YRZbwH0kNJ7xYY2vd2MVBvJ4d+6oA6ZGkfSfLAt
	KTYU0lYP1KwH3QiQC/P3zTfZaRHsHfo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778680199; a=rsa-sha256;
	cv=none;
	b=rNc20mBvL0yo3Yj4QMQJdc4FpifLD+mF1ZVu58YYZIv1RQ3ajllNfcH/mxncd1ibOPACCU
	mZwjk6fWyxeI22HtKbWiIQ2742U+siC951bkGpoiG0+6TP8r+gzV6SZ6vy1beJZB87Ed3s
	5xTeXX3gAssqjB3GeazTjB+YRoyk6OI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=n2uai5Ix;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
Date: Wed, 13 May 2026 06:49:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778680195;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/Tp+YGNU/YWh4+mnxkJ6DD+LKecTb+noZ/uA14eabz0=;
	b=n2uai5IxdJAShmUa+j/JoWwab5GJNy3E6yWqDJCvqLjWm3jHAKlVgCZErANW15rfgwTodd
	NtXRhFrNHsQMPvq46vHzvy8Ev9BQtvpXhqkVwYoXO3l0t/H3dxEgDfLFkLjjHboVLDP3f/
	SPrO/lYuYclHVrdAv/qnWRFAs9+uPjc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: kernel test robot <oliver.sang@intel.com>, oe-lkp@lists.linux.dev, 
	lkp@intel.com, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Carlier <devnexen@gmail.com>, 
	Allen Pais <apais@linux.microsoft.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Baoquan He <bhe@redhat.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Chen Ridong <chenridong@huawei.com>, David Hildenbrand <david@kernel.org>, 
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Hugh Dickins <hughd@google.com>, Imran Khan <imran.f.khan@oracle.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Kamalesh Babulal <kamalesh.babulal@oracle.com>, 
	Lance Yang <lance.yang@linux.dev>, Liam Howlett <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Muchun Song <songmuchun@bytedance.com>, 
	Nhat Pham <nphamcs@gmail.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Usama Arif <usamaarif642@gmail.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>, Yosry Ahmed <yosry@kernel.org>, 
	Yuanchu Xie <yuanchu@google.com>, Zi Yan <ziy@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
	cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [linus:master] [mm] 01b9da291c: stress-ng.switch.ops_per_sec
 67.7% regression
Message-ID: <agSAT4ldp3dzKWPl@linux.dev>
References: <202605121641.b6a60cb0-lkp@intel.com>
 <agNO8G8tPnPuVrGq@linux.dev>
 <0e1b8994-944d-4dda-8966-3cd43661796d@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e1b8994-944d-4dda-8966-3cd43661796d@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: A53F916000D
X-Rspamd-Server: rspam04
X-Stat-Signature: ur75uydor1ej4maagswau1xxwbk6h1x6
X-HE-Tag: 1778680198-403911
X-HE-Meta: U2FsdGVkX18JdJ1O3Ahaepm9LdM72qVfA3SybqcpaHTLjtB0zHEkSo6hiTHSfVB6ZIzGyszontQNsV0iKgH1/BKG8zVWM0wNM3cTVVGM5/E9zE5dhcOKwPA5gacrgDX59EeVKmc/zKE+UtkFhmYzP4hDDyjv2bny+BkkKicD9ixpsU5vD5wFYwJOl+DrRGTTgofWeXi5BgPYrLAdyY017pJkHr/F65HjSoGDg+wUYGkE3TBMjXRYE9kkIiuItvjhipDwvVZyCHZLC9UJOjupcmcA1jKKfm5ErHeMV+YcPThmJGVb33JfBHe3vXA3TR/YgVLDr4nOQQG0JhmXMYi+EuP/xSExDLs8HREb407aA2ZXKox1TVbbsN7eX1p6iuQAEjmgEjLL+xTYvy03z6690bJUNGhaDDAJ+TEcKtanGr0+J3a5TDbO3KqBm8ECXWC3P6ej1Xl2c5YTpnp2XFag8KY/Oi2zzoJ2o0FkiVEiGAIxI+65fHRBWWa1G6kKTskCoWDCS6rJ0nta9U9hdydUSwRdxEb75l9O0YysKXahUcNxnPUcfP0lpI1gmLFTRPIszjsAQSXWSheSxpo+RnFinD9eX8ELRpXdqExPVyN1476Fe9Rihvr9lQoi5w9qm94c7Aya7iwENwAp7T4+3qzuMa/vfcToLMvf/Sh8pyM2vyirJPWBQ0zdzruKG+6fH6oQjdgJAQXvrPbvz4Gxe1h9C3D50JvVJLb1oOGuRBR1srRGeEJnuhC+6AhUg26KM6U5d8BvjOD9F9f9kdc4gXkDcDAstDsb7GWxj+RPGgGLRc9ZtkdpDGagl7YkmXlQWOa9V0fiWRvDyHpytkUWDcffiUj5WrHhCdKodH19eAWw/vEbZKPyN1h+NpBwWeLlZ57uLzi2qQlIV752UxRdsaZK2g0qOMAER4OYdyYo1iPyGq5zPXoQ0zHvlMZB6madchL5w3TgKtz/LUAtDOKaUTO
 MVkxP0in
 e+UqDLXyoJktG4GULv7jwZA7obFTCSs/ABXzw5KrDJZmWt/cppI7bKD/wKr3VP/HhvvhYYo5164ah2Yx4jCndj0/pOzjKFuhgHhKkF0xKJwUD8fQDdeta+cy8Vwgzo30WpHd51HQGe1ABArz4cFtHaAqflaJWVi2NeBRotIddG+JLfJUiLFtndAKz81zSn5XLXi3xbk807hW2GBaKBOHdQVO00z9WqyUPCnO9KT0fL+NV8GIP3pcHlAUeLcACIM11F/ex6C6W6n3yTjnrjBfrToihfQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 10:10:34AM +0800, Qi Zheng wrote:
> 
> 
> On 5/13/26 12:03 AM, Shakeel Butt wrote:
> > On Tue, May 12, 2026 at 08:56:52PM +0800, kernel test robot wrote:
> > > 
> > > 
> > > Hello,
> > > 
> > > kernel test robot noticed a 67.7% regression of stress-ng.switch.ops_per_sec on:
> > > 
> > > 
> > > commit: 01b9da291c4969354807b52956f4aae1f41b4924 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
> > > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
> > 
> > This is most probably due to shuffling of struct mem_cgroup and struct
> > mem_cgroup_per_node members.
> 
> Another possibility is that after objcg was split into per-node, the
> slab accounting fast path is still designed assuming only one current
> objcg per CPU:
> 
> struct obj_stock_pcp {
>     struct obj_cgroup *cached_objcg;
> };
> 
> So it's may cause the following thrashing:
> 
>  CPU stock cached = memcg/node0 objcg
>  free object tagged = memcg/node1 objcg
>  => __refill_obj_stock --> objcg mismatch
>      => drain_obj_stock()
>      => cache switches to node1 objcg
> 
>  next local allocation tagged = node0 objcg
>  => mismatch again
>      => drain_obj_stock()

Actually I think this is the issue, we have ping pong threads running on
different nodes where though theu are in same cgroup but their current->obcg is
for local node and thus this ping pong is thrashing the per-cpu objcg stock.

The easier fix would be to compare objcg->memcg instead of just objcg during
draining and caching. In addition we can add support for multiple objcg per-cpu
stock caching.

