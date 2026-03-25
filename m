Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC5CEFEA82E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 07:36:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CF916B008A; Wed, 25 Mar 2026 03:36:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A0C06B008C; Wed, 25 Mar 2026 03:36:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DD236B0092; Wed, 25 Mar 2026 03:36:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 409A26B008A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 03:36:55 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BCF2E5AC23
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 07:36:54 +0000 (UTC)
X-FDA: 84583778748.22.116FA49
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2AE12180005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 07:36:52 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VoZyamcp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774424213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4QDqa8Oss2P57ZZPk/DNe4VJvd5IIMEBJdZf2wj5P/s=;
	b=Feh0Lpq+U6T06AziPxP1FEsUsFygJJ3MktR5uJHOZfn7sxZHjhN4S39G+AnnulIfTYYukv
	HLWIQLgKTIHcUOLgtXW9FqFO5qfqC3yG6KPiizs24XaJ+n3NLBMAqpt2xVSQ+mgnn6Hp1H
	etBsMHmk4DyTxJx96NM8emwVBqS9Mb4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774424213; a=rsa-sha256;
	cv=none;
	b=e8yHsoeoHaCDuhaE/RBwAx+yrTOYdaBk1731TraBfleFhUfWbBL/tU0VPtrJOzR8ycMSsL
	wevhreeFaXJV+atTIBHC4RryWvYgeziP/FWSayACztmnICBrr5hO3xj2ue6LW10q+rVP/T
	ZkFvE/OxcK7N2tyZ6vXQn+3hugB8Vto=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VoZyamcp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 233D7440B3;
	Wed, 25 Mar 2026 07:36:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96FD5C4CEF7;
	Wed, 25 Mar 2026 07:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774424212;
	bh=opMqCnHb5NP/n4eovyOLUHlmdDCFdJVAToF0fcD3gVU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VoZyamcpvTqhe3Hs60wKIY2dMLK/Juv5gUS2KsvWJ26bDipnCR/28YSrriFXpdOnV
	 2Q6+eQjiMFsiPwQVGdVd3P1RrxUDm0d6brZygx10ZEmYjHszYinD7Kzqvhnl5Kb1Zj
	 Cgz4ZC4yEc/3XrF1oC375hv3BbOcs7eKPpiUhFnahkQxOZO5SfpzEpaa7TpilK4Mj4
	 r8HsoT53C90bpXJCF+X18aLcr+xxsBj3YSVe+MNMPbwffDAlvZY3inGlOMi2z9Pjxa
	 GTS3wRIgLjp2m1BVojuBBieD7ev+EwBHO5l3MlwLq8QFqyoeSHzQij4J5BG3qGr7Mz
	 mJ2yCyP7W6nHA==
Date: Wed, 25 Mar 2026 16:36:49 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, david@kernel.org, lorenzo.stoakes@oracle.com,
	ziy@nvidia.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com,
	mkoutny@suse.com, akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
	lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH 2/3] mm: memcontrol: correct the parameter type of
 __mod_memcg{_lruvec}_state()
Message-ID: <acOQkTDJvieu3sh-@hyeyoo>
References: <cover.1774342371.git.zhengqi.arch@bytedance.com>
 <90524ca3806e24105ab5f2d69435f57c2ae034cb.1774342371.git.zhengqi.arch@bytedance.com>
 <acM93qmvDFofjWdM@hyeyoo>
 <5a9d9152-8e23-4438-a322-ec524fd159a6@linux.dev>
 <acNv8w-xNWwZHVo9@hyeyoo>
 <d86749f2-c4fb-4c7f-b630-27fca222066c@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d86749f2-c4fb-4c7f-b630-27fca222066c@linux.dev>
X-Rspamd-Queue-Id: 2AE12180005
X-Stat-Signature: db5wm3s5zt6jh7zcq8be9tck5tgd8q57
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774424212-676784
X-HE-Meta: U2FsdGVkX19YlGyrIK2KAfQe5a+5vN040M6QjN8aYMRVWZqrkvneY1Q2T+sWHWWUpKi9SpE+7hl8mWFtUaJzKxhKhB/LYICyiE1CP7aidrpFZrojYuyWyQXTa6HYfvIV5AYfphy1MQU9g4y4Xk0biQ1urASCcLuuKHrIKcPNkmDTEdeEfQb2eUL+PRgYWnlQX1915gdvNSvdmnfgn69vXIv6e8zW3QpDO8YM3eAcMsKgVj6hrIpTKCsIF2kTQ70BuTwUw/nrD0t4BWWdgc6rSAoiwFugZbQxOS/Gla8pnJMjkhWR/aIpL16CvV3MqjJI39n6D09YUHya+9o/xtyg5yFviwDGj5W0NKcjXD0XBLOUd6r+iV4lIUeqZhYOxbw9WTRArEuC/OKRBYZz2jSnBkKWB0jIg+RRGrloUYw+DwxiYrRRHbnLL8y2lJrNT2b61FL5V7aAmOb1gHGptah49ubhsrW0MIbuxZ5vda4gI6DRlsoshUQt/rtgUQOORyITHSJiZpFnqy8jnax55F5fBCZ1JEVbMH9+z5K0Bmw9IcNmuLSYJQIvEv/vOIm1UVnHkC9VIelI1CHKeAr8mv4aLFGRsx2v90H4dM85NVR3ZCm3MaNLiOyrPNN3XPtgH6Rcecwn0RMjD8sK9CRpMYbxK47cu9rYY2UHXQKzt0ah6jEg8zGzhmfoGq6b97AhI/Bey51VVW+9Y1L8kuijexo3JPZn6EgPoNv35FWnkzE+8eQfPeao/gepYL/3kojmxRc6BjUc2Hl/5f1wPlxnhLEQS8zWb6OF5yeRA4/yqqVacgFAQO+hnFXDgsrGTf3oGlFrOPXUcOQpgDSwrBjTNftc31V023H2kqmY4RwQciynPrecpDSjy/62GB9rx/2Sx+dvzzKSpIsK/Uwy+wOxpQmbzK1NELHpJG7z21c48K3XwY5WFG7v7oxEkAVKhw/CfTVjXdlAqt2CiY9ReVfQenm
 aGsQW2w3
 SGf3V
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 03:26:46PM +0800, Qi Zheng wrote:
> 
> 
> On 3/25/26 1:17 PM, Harry Yoo (Oracle) wrote:
> > On Wed, Mar 25, 2026 at 11:25:06AM +0800, Qi Zheng wrote:
> > > On 3/25/26 9:43 AM, Harry Yoo (Oracle) wrote:
> > > > On Tue, Mar 24, 2026 at 07:31:28PM +0800, Qi Zheng wrote:
> > > > > From: Qi Zheng <zhengqi.arch@bytedance.com>
> > > > > 
> > > > > The __mod_memcg_state() and __mod_memcg_lruvec_state() were used to
> > > > > reparent non-hierarchical stats, the values passed to them might exceed
> > > > > the upper limit of the type int, so correct the val parameter type of them
> > > > > to long.
> > > > > 
> > > > > Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> > > > > ---
> > > > >    include/trace/events/memcg.h | 10 +++++-----
> > > > >    mm/memcontrol.c              |  8 ++++----
> > > > >    2 files changed, 9 insertions(+), 9 deletions(-)
> > > > > 
> > > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > > > index 7fb9cbc10dfbb..4a78550f6174e 100644
> > > > > --- a/mm/memcontrol.c
> > > > > +++ b/mm/memcontrol.c
> > > > > @@ -527,7 +527,7 @@ unsigned long lruvec_page_state_local(struct lruvec *lruvec,
> > > > >    #ifdef CONFIG_MEMCG_V1
> > > > >    static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
> > > > > -				     enum node_stat_item idx, int val);
> > > > > +				     enum node_stat_item idx, long val);
> > > > >    void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
> > > > >    				       struct mem_cgroup *parent, int idx)
> > > > > @@ -784,7 +784,7 @@ static int memcg_page_state_unit(int item);
> > > > >     * Normalize the value passed into memcg_rstat_updated() to be in pages. Round
> > > > >     * up non-zero sub-page updates to 1 page as zero page updates are ignored.
> > > > >     */
> > > > > -static int memcg_state_val_in_pages(int idx, int val)
> > > > > +static long memcg_state_val_in_pages(int idx, long val)
> > > > >    {
> > > > >    	int unit = memcg_page_state_unit(idx);
> > > > 
> > > > Sashiko AI made an interesting argument [1] that this could lead to
> > > > incorrectly returning a very large positive number. Let me verify that.
> > > > 
> > > > [1] https://sashiko.dev/#/patchset/cover.1774342371.git.zhengqi.arch%40bytedance.com
> > > > 
> > > > Sashiko wrote:
> > > > > Does this change inadvertently break the handling of negative byte-sized
> > > > > updates?
> > > > > Looking at the rest of the function:
> > > > > 	if (!val || unit == PAGE_SIZE)
> > > > > 		return val;
> > > > > 	else
> > > > > 		return max(val * unit / PAGE_SIZE, 1UL);
> > > > 
> > > > > PAGE_SIZE is defined as an unsigned long.
> > > > 
> > > > Right, it's defined as 1UL << PAGE_SHIFT.
> > > > 
> > > > > When val is negative, such as during uncharging of byte-sized stats like
> > > > > MEMCG_ZSWAP_B, the expression val * unit is a negative long.
> > > > 
> > > > Right.
> > > > 
> > > > > Dividing a signed long by an unsigned long causes the signed long to be
> > > > > promoted to unsigned before division,
> > > > 
> > > > Right.
> > > > 
> > > > > resulting in a massive positive
> > > > > number instead of a small negative one.
> > > > 
> > > > Let's look at an example (assuming unit is 1).
> > > > 
> > > > val = val * unit = -16384 (-16 KiB)
> > > > val * unit / PAGE_SIZE = 0xFFFFFFFFFFFFC000 / PAGE_SIZE = 0x3FFFFFFFFFFFFF
> > > > max(0x3FFFFFFFFFFFFF, 1UL) = 0x3FFFFFFFFFF
> > > > 
> > > > Yeah, that's a massive positive number.
> > > > 
> > > > Hmm but how did it work when it was int?
> > > > 
> > > > val = val * unit = -16384 (-16KiB)
> > > > val * unit / PAGE_SIZE = 0xFFFFFFFFFFFFC000 / PAGE_SIZE = 0x3FFFFFFFFFFFFF
> > > > max(val * unit / PAGE_SIZE, 1UL) = 0x3FFFFFFFFFFFFF
> > > > (int)0x3FFFFFFFFFFFFF = 0xFFFFFFFF = (-1)
> > > > 
> > > > That's incorrect. It should have been -4?
> > > > 
> > > > > Before this change, the function returned an int, which implicitly truncated
> > > > > the massive unsigned 64-bit result to a 32-bit int, accidentally yielding the
> > > > > correct negative arithmetic value.
> > > > 
> > > > So... "accidentally yielding the correct negative arithemetic value"
> > > > is wrong.
> > > > 
> > > > Sounds like it's been subtly broken even before this patch and nobody
> > > > noticed.
> > > 
> > > Thank you for such a detailed analysis! And I think you are right.
> > 
> > No problem ;)
> > 
> > > The memcg_state_val_in_pages() is only to make @val to be in pages, so
> > > perhaps we can avoid the above problem by taking the absolute value
> > > first?
> 
> For more clearly, here is the diff:
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6491ca74b3398..2b34805b01476 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -787,11 +787,17 @@ static int memcg_page_state_unit(int item);
>  static long memcg_state_val_in_pages(int idx, long val)
>  {
>         int unit = memcg_page_state_unit(idx);
> +       unsigned long uval;
> +       long res;
> 
>         if (!val || unit == PAGE_SIZE)
>                 return val;
> -       else
> -               return max(val * unit / PAGE_SIZE, 1UL);
> +
> +       uval = val < 0 ? -(unsigned long)val : (unsigned long)val;

We could use abs() macro in linux/math.h here :)

val should not be LONG_MIN, but it should be fine
to assume it won't reach LONG_MIN.

> +
> +       res = max(mult_frac(uval, unit, PAGE_SIZE), 1UL);
> +
> +       return val < 0 ? -res : res;
>  }
> 
>  #ifdef CONFIG_MEMCG_V1
> 
> > That would work for memcg_rstat_updated(),
> > but not for trace_mod_memcg_state()?
> 
> Why? The trace_mod_memcg_state() seems to accept 'long' type,
> am I missing something?

Nevermind. Without the diff, I misunderstood what you meant.

Thanks!

-- 
Cheers,
Harry / Hyeonggon

