Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD0A11093168
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 01:44:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2036D6B0088; Tue, 24 Mar 2026 21:44:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DB4C6B0089; Tue, 24 Mar 2026 21:44:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 118496B008A; Tue, 24 Mar 2026 21:44:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 021A36B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 21:44:03 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 963541A061D
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 01:44:03 +0000 (UTC)
X-FDA: 84582889566.29.2B17353
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1B5F220002
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 01:44:01 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mogDwU+Y;
	spf=pass (imf03.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774403042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uAuJL99nwE1kSN+lk2RDVVfLW+YTSHu44HeLX02tujM=;
	b=rJj6Esx7uiaFuIwZPU4TcGhTX9Co60CnBiyZiAN+zPpD7L768IqN0cX+4w6vlZ4nqn/L+I
	pwOIgDL6sFy7/s4gRRXaOt7J2ZXeY26Fb6beWlvkjy54a/2Ig4ln+IyaDtsmTKyfgyYPST
	WMMmCtl4VW7umzTUZt1pTbrlxAmSKAs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mogDwU+Y;
	spf=pass (imf03.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774403042; a=rsa-sha256;
	cv=none;
	b=d3NUrTfEatJoyJ8KUNgA91vY6BvR/kC0dFfeQanjIWbHnhYld93d7ShGzUfK2tXz5mPkET
	Ji03jBqBSsGonOYj7eJsN3M6bY5FVXX4wrkAKpnT9LGhUKhwRJX5JPZ5etDijT199ofNYR
	EUrm7ouofOvaGNoFSqJdZQNkMD5ipHA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 10880404E6;
	Wed, 25 Mar 2026 01:44:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D121C19424;
	Wed, 25 Mar 2026 01:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774403040;
	bh=I7dzjVKoQcTtp7Dkp6x2GsVxUVnjvFtpsLUpGsILp4A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mogDwU+Y57SQzOhbOXGTVmrfdwli6fzxvt8tt22MnMvv4l8eJNRvEptsjwjtMxRjR
	 07/BrTX5+jqzNvSXnfvVwg3xrnjAHK8Q6LVaqGuGZW/0OoN4iQlJMuM6557KhFOEPy
	 Grxsi/0Oi5C7pTnZ0eASklN/E96llYC4CzV1GznCkmKU7bwfN/RPZLvXRwn3rjv6x1
	 7IvByYSIHgow6pXfrJ9XVkOxPSPVO3W2G583GacNR94IH+VZ23Kl4+0sb3unuCBuZS
	 JSbMRrc6H/txaiKtGeGFIrb2DIEtjWc6pKMgclLqumgx/h5ToaGShSBdx3ZeSYDKAa
	 PspuOY4/ZX5lQ==
Date: Wed, 25 Mar 2026 10:43:58 +0900
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
Message-ID: <acM93qmvDFofjWdM@hyeyoo>
References: <cover.1774342371.git.zhengqi.arch@bytedance.com>
 <90524ca3806e24105ab5f2d69435f57c2ae034cb.1774342371.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90524ca3806e24105ab5f2d69435f57c2ae034cb.1774342371.git.zhengqi.arch@bytedance.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 1B5F220002
X-Stat-Signature: 67c35dkbbdc5g5tm4cs853pam96376sn
X-Rspamd-Server: rspam06
X-HE-Tag: 1774403041-412863
X-HE-Meta: U2FsdGVkX19gCEzFf7HzA8AIhpntqSVHXdg2i8ubvycdeHVBGHI9nR43OHDcbgrxnvv4i01s+ni+dZAJDjgr/6BA9DbqAAOligg578fMuHoN9Tr2ILuZtaczCiGJGKHOrnQsd/OnENbrZWHooialAfEf9uVum7vg2hVnZkckHnXdpZ5igF83UzGK2x/e2X+4nrM+z3c1tYUfU3h8Hgbx3MncrCy4wRXICbvl7OjSGiyOIpZD+ux8+VUg+5820ij18JjQSS6s9+58ABJxXYbTgap9pl1cWDLUZjnKKGtBwnFyVzmuZ+eF+VlxSq6gDmZie68iZMa70o7T0v4IcU9To7tNpM9eZpca1Iz/QJrhRo6tpqPMK7GRFod5SIDTzOVZ6PwpF7MhiZYcx5xEnL7GGsfAv/wbLvANXe0X2nandSxe+bLdctRrbNSLBgjEbu+yjSFaKyz8U/MgcTOby/vWybF+NZ4Gzqul8i8fnLkdOWiTzHuxhWeh7eNnRpK6vlopG/JN4e01NqyjUDEbJNAaWII8Gaqz60Uad7i7M9jPvOaUoikyt+Q1/uLWBIoqKbJEx7kztiZ1b90AIfnZcuPg2DxQIkaOKJ0K9qbCVk5NRZFniww/OW0C7yvbduzxeC39sjF6e1/f4UuGYdVUPKeecmWB/ZmyGW6Igl/GN7A/enxRQ/bhDwtEyGaMXG8arfVi5biUMS1KHvWXklwlKIav4HOJpNaij974jbvoiMF6XcxPTfX0CDS8xIP8601dV+4g1M5LE56p8UXgzycEtdIROxXAfKQucXNJcsVnkS1aE2Pt3Ishwt9OizrYboUfUoXzFp/vW2S2tcXs9O+4T+Tu+61w1IeixTwGIzQxu8Csy2XyDI4DR+O3LP/VKZYE0sU2fm0KFDravObFUOEHZZP1szvgk8+0ZZeOMWWPxdbMrmqryC+bskCS9qALYT9HlR+b1UwHzID1TPzo4XDTLfg
 GO9X8Okh
 fyYzR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 07:31:28PM +0800, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> The __mod_memcg_state() and __mod_memcg_lruvec_state() were used to
> reparent non-hierarchical stats, the values passed to them might exceed
> the upper limit of the type int, so correct the val parameter type of them
> to long.
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---
>  include/trace/events/memcg.h | 10 +++++-----
>  mm/memcontrol.c              |  8 ++++----
>  2 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 7fb9cbc10dfbb..4a78550f6174e 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -527,7 +527,7 @@ unsigned long lruvec_page_state_local(struct lruvec *lruvec,
>  
>  #ifdef CONFIG_MEMCG_V1
>  static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
> -				     enum node_stat_item idx, int val);
> +				     enum node_stat_item idx, long val);
>  
>  void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
>  				       struct mem_cgroup *parent, int idx)
> @@ -784,7 +784,7 @@ static int memcg_page_state_unit(int item);
>   * Normalize the value passed into memcg_rstat_updated() to be in pages. Round
>   * up non-zero sub-page updates to 1 page as zero page updates are ignored.
>   */
> -static int memcg_state_val_in_pages(int idx, int val)
> +static long memcg_state_val_in_pages(int idx, long val)
>  {
>  	int unit = memcg_page_state_unit(idx);

Sashiko AI made an interesting argument [1] that this could lead to
incorrectly returning a very large positive number. Let me verify that.

[1] https://sashiko.dev/#/patchset/cover.1774342371.git.zhengqi.arch%40bytedance.com

Sashiko wrote:
> Does this change inadvertently break the handling of negative byte-sized
> updates?
> Looking at the rest of the function:
> 	if (!val || unit == PAGE_SIZE)
> 		return val;
> 	else
> 		return max(val * unit / PAGE_SIZE, 1UL);

> PAGE_SIZE is defined as an unsigned long.

Right, it's defined as 1UL << PAGE_SHIFT.

> When val is negative, such as during uncharging of byte-sized stats like
> MEMCG_ZSWAP_B, the expression val * unit is a negative long.

Right.

> Dividing a signed long by an unsigned long causes the signed long to be
> promoted to unsigned before division,

Right.

> resulting in a massive positive
> number instead of a small negative one.

Let's look at an example (assuming unit is 1).

val = val * unit = -16384 (-16 KiB)
val * unit / PAGE_SIZE = 0xFFFFFFFFFFFFC000 / PAGE_SIZE = 0x3FFFFFFFFFFFFF
max(0x3FFFFFFFFFFFFF, 1UL) = 0x3FFFFFFFFFF

Yeah, that's a massive positive number.

Hmm but how did it work when it was int?

val = val * unit = -16384 (-16KiB)
val * unit / PAGE_SIZE = 0xFFFFFFFFFFFFC000 / PAGE_SIZE = 0x3FFFFFFFFFFFFF
max(val * unit / PAGE_SIZE, 1UL) = 0x3FFFFFFFFFFFFF
(int)0x3FFFFFFFFFFFFF = 0xFFFFFFFF = (-1)

That's incorrect. It should have been -4?

> Before this change, the function returned an int, which implicitly truncated
> the massive unsigned 64-bit result to a 32-bit int, accidentally yielding the
> correct negative arithmetic value.

So... "accidentally yielding the correct negative arithemetic value"
is wrong.

Sounds like it's been subtly broken even before this patch and nobody
noticed.

> By changing the return type to long, this implicit truncation is removed,
> and the huge positive value is returned unaltered.

That's true.

> Could this corrupt tracepoint logs when passed to trace_mod_memcg_state?

I'm not sure if that's critical but yeah that's true.

> Also, would passing this huge positive value to memcg_rstat_updated instantly
> exceed the charge batch threshold and trigger endless, expensive global
> cgroup_rstat flushing, severely degrading system performance?

It would lead to more frequent flushes, at least.

-- 
Cheers,
Harry / Hyeonggon

