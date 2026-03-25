Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EE0DFEA807
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 05:17:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4589A6B0005; Wed, 25 Mar 2026 01:17:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 409986B0089; Wed, 25 Mar 2026 01:17:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31F2C6B008A; Wed, 25 Mar 2026 01:17:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 236E56B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 01:17:45 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C8DA21B8034
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 05:17:44 +0000 (UTC)
X-FDA: 84583428048.26.227F1F9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 405FA40005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 05:17:43 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sbyTnvQX;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774415863; a=rsa-sha256;
	cv=none;
	b=1ANhzxC0Lq3qGEXdH1m37Wnee2IglAm1q1TpnyNHOJTIKbVb1onlyNaZjc9LytuqZuX0DK
	0wbyXqSb+Q+Ap1rc/hzgJogIotw+w0Mn9zgGYahnw3bk8U9b4qvRaGggqbJtiZ0JzmpKN3
	DD/XITXBwSkVGImk5n9onPwA3nFupLE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774415863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/HducUYbwe5EZQIsYv3Zl2v/PYNEHVmUXeWTxd9fkKM=;
	b=QdqsUpuzSIn/IKXQoLycwig3HbOIUxd7+Mz5lLar1nuYekTzOONYMRIjEUfNbT9+A/w36L
	QOmFnZioD4EK8TDDk2Usm/IjES5mMSJJ6s7mEOe7JzyIl0gCaIoP1d5PZe0Af9a0xPjq89
	DiuZM5X1FqqMd0uZvhWXaPC0JNb0xfc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sbyTnvQX;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 39A8E600C4;
	Wed, 25 Mar 2026 05:17:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A087C4CEF7;
	Wed, 25 Mar 2026 05:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774415861;
	bh=pjCTKc2xw7ZjdrFHVDgRIXNLOjgy/TRByZz3N7OKr24=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sbyTnvQXzYmouz0eYNVcPEX6pMhS8V6URGzQpnmCRb0P7u4qw+MybOEB1rtSyBcxl
	 epwRgUITlUDkRsv9POXJEM5oXbLtv9PKoRgy3xmeJ1lTBKf/cm0QKBbGl6bF84Swjn
	 Zr1ZBKZAwcAbKGF/uqLZvr1xPgaxD1vrVWK1WRnRKz571ns0ycn1JgKd8NL/aX+ntJ
	 ThVYCz5bxT2XHtCFCMTSFWCf3hQ9O6gyU0KjF4ni2Px8pC9h0XnDtx4XxiD6V8qDIq
	 zQdYqBz/9mnUARWpOVUPbkGF7twb9qM4Z8jcm2Q4TbDe7O2/iNizT+TgwMtroCbdXG
	 QMZNdBkqxQCMg==
Date: Wed, 25 Mar 2026 14:17:39 +0900
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
Message-ID: <acNv8w-xNWwZHVo9@hyeyoo>
References: <cover.1774342371.git.zhengqi.arch@bytedance.com>
 <90524ca3806e24105ab5f2d69435f57c2ae034cb.1774342371.git.zhengqi.arch@bytedance.com>
 <acM93qmvDFofjWdM@hyeyoo>
 <5a9d9152-8e23-4438-a322-ec524fd159a6@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a9d9152-8e23-4438-a322-ec524fd159a6@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 405FA40005
X-Stat-Signature: f7wewzdszihccsjaxh4px5f5wid4o3dt
X-HE-Tag: 1774415863-276566
X-HE-Meta: U2FsdGVkX1/mzj5FQFG0oO3j9CEkt3WBVA2ihLSrF6pxi4UZsIik2Y009b6VIverILPdChABT/bT57cUw/q/vX9tvb5DTOFP6YWwlFw1ib6u6gs+WFMASI209vTZYS5bHQ97ZVh6BIpf4Ep9W5LsIXNZC6kBnO6zrxv1uZbH9P1/2+0z6wQkCcFupX+FhsexPz84l5m4CZXMNZAkR6d1gU5s5DiFYYTDq9AaI8DcF4QDeCpW21pyTc+OVoUxU7Ptf2aKK+YGTuch15QNrA3JKB6mlc6PjsTINC8l2FpwP5iFgCIflQpx/gqPyIsYiXlE9Kt+oQlApXaUNuQtFbFD64FZJwTRLU44bB22WX/Q6DclBG7+WQKwJVcRz6kxPROXoV+yKtFcHwFZoa+1G2DEPDislWpL/VJVeKQ7MGCqr/GFUv+C0KdvxsFXwXoQLRkeVr1CIfZONdj2185Mkl8wxjUdDZe1rCBWEw+BsrZLkB314FXj2/NxhiPf5Q1InD3d3mi/03Z+MdtjVySoxAK/uoRhVDXkiRw52/BV9DsOHU4bEURWIbuTsyWla/ioo+ntDLXIfGCZ1wCS2o4GkxObztjb0Hnmv8JZm50sZTl5u9XAv5bI25Gx1DnqIkDWTf3cDqh1GXMdqfnHmWOt25i2BA9KfteM4bS+QEkgaQ2gofMOiXlHjGcV/+6bsmefzsZ6BNvGbZhEkkDZtrVMiTJhuhpbKfh2u4Tn6u+PMR9J0Rlux79E9O1bDKl/N8WqsedRIiETa7Oy+4ixhESTwK3ZHNhAWpWnUDEgMNOC5QDzobcKVa/+r+nZFMgf5SqiTD22sM0Gpd2GJs+Ewc2GzNEDOoacuof6LUxgg0U1l7rAd1jtl9OQpvwmVLIWbZ+j1baJMsViTCdMQZx9/fLYw/8qkFFrGeqNnFJKe3C2uCn3I9r4fkCVMJ9rqHfEhyU3d7PlO1ewAxAwq3oVHg44frw
 LCCU/LmK
 GHjhhtklAOFtCM3n0MUTUJRuGo74lgFJyWpiFC/Fki8X6MI6JW2EPFWvhhGedA1S4AVoDHUM5KaZdzYEmKx4IuWQqO2JYNS/Ia0DbQUunnVmcFJqmqK57Dj1j68r020xloqzoF7tpmqLmTP1sn8ECo7JmZJPpQKjGMekuxemuLzfPUeNRutHEdFpwxGwAK3+KNxD7IELgbXr5bWavl2WpHkBTKP1giyEedCrPZ8bWkVp60EsbMWHgOWbE/DnMP6aaY0zRiS91wYWFC3PbRSHzfheIx+XXb0E41Q7PLMaguCSeVuFzTRDW+kFkjdnwuC0NUP7Zrj02Z32IsEhb3VSstUwbquCvgXL+dRwcaOr3qJnVNRPJl5H2nBMZko8OjMHdlnSd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 11:25:06AM +0800, Qi Zheng wrote:
> On 3/25/26 9:43 AM, Harry Yoo (Oracle) wrote:
> > On Tue, Mar 24, 2026 at 07:31:28PM +0800, Qi Zheng wrote:
> > > From: Qi Zheng <zhengqi.arch@bytedance.com>
> > > 
> > > The __mod_memcg_state() and __mod_memcg_lruvec_state() were used to
> > > reparent non-hierarchical stats, the values passed to them might exceed
> > > the upper limit of the type int, so correct the val parameter type of them
> > > to long.
> > > 
> > > Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> > > ---
> > >   include/trace/events/memcg.h | 10 +++++-----
> > >   mm/memcontrol.c              |  8 ++++----
> > >   2 files changed, 9 insertions(+), 9 deletions(-)
> > > 
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index 7fb9cbc10dfbb..4a78550f6174e 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -527,7 +527,7 @@ unsigned long lruvec_page_state_local(struct lruvec *lruvec,
> > >   #ifdef CONFIG_MEMCG_V1
> > >   static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
> > > -				     enum node_stat_item idx, int val);
> > > +				     enum node_stat_item idx, long val);
> > >   void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
> > >   				       struct mem_cgroup *parent, int idx)
> > > @@ -784,7 +784,7 @@ static int memcg_page_state_unit(int item);
> > >    * Normalize the value passed into memcg_rstat_updated() to be in pages. Round
> > >    * up non-zero sub-page updates to 1 page as zero page updates are ignored.
> > >    */
> > > -static int memcg_state_val_in_pages(int idx, int val)
> > > +static long memcg_state_val_in_pages(int idx, long val)
> > >   {
> > >   	int unit = memcg_page_state_unit(idx);
> > 
> > Sashiko AI made an interesting argument [1] that this could lead to
> > incorrectly returning a very large positive number. Let me verify that.
> > 
> > [1] https://sashiko.dev/#/patchset/cover.1774342371.git.zhengqi.arch%40bytedance.com
> > 
> > Sashiko wrote:
> > > Does this change inadvertently break the handling of negative byte-sized
> > > updates?
> > > Looking at the rest of the function:
> > > 	if (!val || unit == PAGE_SIZE)
> > > 		return val;
> > > 	else
> > > 		return max(val * unit / PAGE_SIZE, 1UL);
> > 
> > > PAGE_SIZE is defined as an unsigned long.
> > 
> > Right, it's defined as 1UL << PAGE_SHIFT.
> > 
> > > When val is negative, such as during uncharging of byte-sized stats like
> > > MEMCG_ZSWAP_B, the expression val * unit is a negative long.
> > 
> > Right.
> > 
> > > Dividing a signed long by an unsigned long causes the signed long to be
> > > promoted to unsigned before division,
> > 
> > Right.
> > 
> > > resulting in a massive positive
> > > number instead of a small negative one.
> > 
> > Let's look at an example (assuming unit is 1).
> > 
> > val = val * unit = -16384 (-16 KiB)
> > val * unit / PAGE_SIZE = 0xFFFFFFFFFFFFC000 / PAGE_SIZE = 0x3FFFFFFFFFFFFF
> > max(0x3FFFFFFFFFFFFF, 1UL) = 0x3FFFFFFFFFF
> > 
> > Yeah, that's a massive positive number.
> > 
> > Hmm but how did it work when it was int?
> > 
> > val = val * unit = -16384 (-16KiB)
> > val * unit / PAGE_SIZE = 0xFFFFFFFFFFFFC000 / PAGE_SIZE = 0x3FFFFFFFFFFFFF
> > max(val * unit / PAGE_SIZE, 1UL) = 0x3FFFFFFFFFFFFF
> > (int)0x3FFFFFFFFFFFFF = 0xFFFFFFFF = (-1)
> > 
> > That's incorrect. It should have been -4?
> > 
> > > Before this change, the function returned an int, which implicitly truncated
> > > the massive unsigned 64-bit result to a 32-bit int, accidentally yielding the
> > > correct negative arithmetic value.
> > 
> > So... "accidentally yielding the correct negative arithemetic value"
> > is wrong.
> > 
> > Sounds like it's been subtly broken even before this patch and nobody
> > noticed.
> 
> Thank you for such a detailed analysis! And I think you are right.

No problem ;)

> The memcg_state_val_in_pages() is only to make @val to be in pages, so
> perhaps we can avoid the above problem by taking the absolute value
> first?

That would work for memcg_rstat_updated(),
but not for trace_mod_memcg_state()?

-- 
Cheers,
Harry / Hyeonggon

