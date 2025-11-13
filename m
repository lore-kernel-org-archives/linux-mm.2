Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12F46CDB463
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 23:41:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FEE58E0003; Thu, 13 Nov 2025 18:41:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D67A8E0002; Thu, 13 Nov 2025 18:41:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5132E8E0003; Thu, 13 Nov 2025 18:41:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4189F8E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 18:41:17 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E2F8AB6BD3
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 23:41:16 +0000 (UTC)
X-FDA: 84107207352.19.A939A7A
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf13.hostedemail.com (Postfix) with ESMTP id BBBF520005
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 23:41:14 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SgswXiB9;
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763077275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4x6pEjtL3otCMAxYfyAWehKRe1O2vnTiFvW9j1r5WIs=;
	b=tew0QUdxxChmgvExp4CkHW9ZGwmErUExKAQ3gParzmeswipi00YHjgUmEqCUqMKFVVJNar
	ohFj2VAq83K+mZtFCa7/2AHcXDSste1tePO68e1Z0GmMuGZc+oTvAlImzngwsMvYonYvRN
	kGnap9IkMDfaMc7fdXam9grhKf3LUuQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763077275; a=rsa-sha256;
	cv=none;
	b=8j4RQ0XA9AZekFJs4VKAnfkzNOb3P+d2IVLBCb/HsBkupulgZVOy4PfRT9BbrBseYE8Eut
	SHZna7wafWDiu8Wr36xv943jCd0tj0zcDlTHgXC0YR4NbuoJFZeSCGVlNq3tAHtpLLubfp
	4GYiagmP6DLIOvvjSvVnR1+tyJ8qd2Y=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SgswXiB9;
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Thu, 13 Nov 2025 15:41:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763077269;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4x6pEjtL3otCMAxYfyAWehKRe1O2vnTiFvW9j1r5WIs=;
	b=SgswXiB926SytBNME63W8b1SrazsyLnbM6zpXRryrnawR2Ca/fegFi3sKErwHm5klTe2bj
	5DyDPLZOvtX0vz9W9xJ+DDl1ZBhlq6L01agG+8QnMwdzhBmKhehVbMrNgp9fMjxGiSBaP2
	rOsKBwF4wbT6xdpAgt2vzOtoMYXGczc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@redhat.com>, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/vmscan: skip increasing kswapd_failures when
 reclaim was boosted
Message-ID: <7rx23a4moclrdb6csumf2g3kfp7rgy7przq6lsknwumeb35x2c@jhrmjdcfhzcf>
References: <20251024022711.382238-1-jiayuan.chen@linux.dev>
 <e5bdgvhyr6ainrwyfybt6szu23ucnsvlgn4pv2xdzikr4p3ka4@hyyhkudfcorw>
 <59f26b5b0c49f8d0f3bdb33f99d69dd3d442ed60@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59f26b5b0c49f8d0f3bdb33f99d69dd3d442ed60@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 5uf8t9r8zkfggpmwdfh1jr31fadd5opp
X-Rspam-User: 
X-Rspamd-Queue-Id: BBBF520005
X-Rspamd-Server: rspam01
X-HE-Tag: 1763077274-952249
X-HE-Meta: U2FsdGVkX18t+Wxqf1Kx9r9NIdN/NhUgiGltNZdshbCrslSqjn50k3FdqomVwZeIo15mtAc10TUxyczM4o1vqrQXyI8QIi9PhopDBdNi1b3hsSCMhnmuEgllQhFXqc0A+qtUPielcOIrrAoa+1ZCoNGIMapg7K6WyBxZU541xeMCgIK7LsATYp6cPlBspG53VksGzAGT/mKh/eTouRLAbOKbKzRuLFJ+3ldSrGuOS6jTpw9h3TGmRuCr+Ff1qd6Z52xl/wFtFrmPW8vwmSQOJJqByEV5x/JRdYHX75HpX5Hgdc9QfERmlTcBWdLn9GZRN2yZMeA4BPSH4ITDOpW+E8+tq9xdtp3UkP9vqY1s9lW/kWfOzCpQbx5LCi9GYFJo1txpb/4HOs+szGQydRKjErWrfAdr56u2W4ifmeMnOsQyxvvPbiR5wK13wXlVqCGzPkT5EfM09sb4liUk0wiQOOE8bsFro5By+VzZkP+bqX4pDY1XjCL9L6J8vBu8zUgRXsttUdVLJuJttyZaz4iTBe89qqmUoDTLJxCAxHBapix/zxD1OzWg3+7ZhjTwoJYVth6IjuJ1gi/D49qCCBEJYtVr25b8K4DPn5/C889zvAbLHneHuRF76Pgq7zuRQCuXwWaR9XFpJFPTWDuo0JX7IaFY0ny9DX3LNICESnC4stj66dT49cQu7Tyx8petlzk174zEvr+MRcqaBPzcQp2fiWqVdWZTuYwhRl2w9rxRVxY1BWLgIvd7L9AIxiPDG9miH0Vnfo4CCMHzFk07tdbR6Qpk7JPw2U1FWz44P2SKabrcmuL2OBNRJDhTaqmKMQNREPjZONkSdbUIfzDL8W0VhDrxUcWvpF72fmD4Fp2Uy5Cal6wklSc63Qm+S8n0mDkLjKZPVGQiKUPDstG0cnNUPKLEnXSvFvWWlbQ5zWYxM59rfc2YIIhxbt1xBGWyDkmTfvEO+xGzgsgjup9H0bq
 OhugfxdC
 pxvt+xbBwEbugRgvb4DNqPSq50QBYe1HHGRB1ZcdER3FMxBdOfVieww0Ev1xl3QQ3plx+Ixc833y5Ni+FsJn57xgzch92zf40ZcctLdPs/VOwcdluQH1UMVrYrrldjXkfYX6eY0X88MuH/doeDc+p7hh2HEHydEcoiVnu+7NJKpFVJQ2qw1b4EHYNcgpQSwRrtX9TFJjy4j6bPhIf2bDgwd5c0LjnsBmbGcGtQx2VHN01YSdeaKQJttfclxUF5nM6qgnO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 12, 2025 at 02:21:37AM +0000, Jiayuan Chen wrote:
> 2025/11/8 09:11, "Shakeel Butt" <shakeel.butt@linux.dev mailto:shakeel.butt@linux.dev?to=%22Shakeel%20Butt%22%20%3Cshakeel.butt%40linux.dev%3E > wrote:
[...]
> > If this issue (high protection causing kswap
> > failures) happen on non-boosted case, I am not sure what should be right
> > behavior i.e. allocators doing direct reclaim potentially below low
> > protection or allowing kswapd to reclaim below low. For min, it is very
> > clear that direct reclaimer has to reclaim as they may have to trigger
> > oom-kill. For low protection, I am not sure.
> >
> 
> We have also encountered this issue in non-boosted scenarios. For instance, when
> we disabled swap (meaning only file pages are reclaimed, not anonymous pages), it
> indeed occurred even without memory.low configured, especially when anonymous pages
> constituted the majority.

Basically whenever the amount of reclaimable memory is low (i.e. in the
range where it is very hard to satisfy the watermarks), this issue can
happen. 'This' as in kswapd failures. This functionality was added to
detect such scenarios where kswapd hogs a CPU doing nothing. The
memory.low adds a twist that we can allow kswapd to go after but let's
punt on that for now and go after the clear and easy issue i.e. kswapd
failures due to boosted watermarks.


