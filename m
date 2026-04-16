Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A798CF8D755
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 18:45:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0509E6B00BA; Thu, 16 Apr 2026 14:45:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 000556B00BB; Thu, 16 Apr 2026 14:45:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E597F6B00BC; Thu, 16 Apr 2026 14:45:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D35A46B00BA
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 14:45:16 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9B44AE4B1F
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 18:45:16 +0000 (UTC)
X-FDA: 84665296632.12.6B7BE80
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id E53BBA000C
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 18:45:14 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LGoWx4DA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776365114; a=rsa-sha256;
	cv=none;
	b=zzjSyG9qBf62UUKre+gAePfVOS07Fu+vzIEejZ3BCWsq4R7dKQKCT941XwM3dfNCc6kSSO
	mcDaat7vQ/juYh11ljHXEwypkRNwAA8rr1gkDtDF7V4NeDgvMfx/ARLPsGu8QDJcEC4FFp
	RmPnAv2WCM6Sdqw4QPO+jENRix15fMw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LGoWx4DA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776365114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vUVK8bVT3H3Ovd4zPitue1Hui3gyeuZSVSR7iXPy83k=;
	b=5IaTfBvxBvWxlxtxrhT1CMclPBqNXnF3bATZQ7Ju5WBnUe0tx8B5IGLmf5VtVdgZoc6p8S
	Z6VsdBiH1/St6JN5kIaXcaNcKxVnbYlCtgjOO/WfbZzXbF+sUgE2vtpXvWnA1HeWJJ+sUJ
	9kzlgEuBXJf0nXr+K6i9M3A6GU+1T+E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3D4F860127;
	Thu, 16 Apr 2026 18:45:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABB1EC2BCAF;
	Thu, 16 Apr 2026 18:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776365113;
	bh=DSzLVoUWI+7ROPnM9hcWYUVpzpEWUg3YpbHOgMECKE8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LGoWx4DALvA9GeqS2u8Lll7/4kWwzgUlJMY8jqRAE/QiECYsnxUnMq3shK1j+y3v4
	 3fNi+HzNL1uiGj99p8RxOoh1APID9GEjwTsVkFPa8m76RpXpL1gvtDtcCeBnmIQ0SY
	 WhmMqguYpzrA3cxvT6s2dQVZBi49KCQ6SUkWqPmrRlxI6HtTCPRPEFZL3bbF5bLDal
	 CK4/o6coxr1NOvmVKu0g+fYFGwTzhvGvzKqLMFwNzbhuEeSDOBypvgFoi56zIvohmk
	 TRtYYHKtlGjJ+nv80ztRy87X4LWhRtiUqPb7oaFTHzdJsPco57D3ZeqK+Kbbo8kLKf
	 A0jJSqBoeag+A==
Date: Thu, 16 Apr 2026 21:45:07 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: akpm@linux-foundation.org, djbw@kernel.org, mingo@kernel.org,
	linux-mm@kvack.org, Donghyeon Lee <asd142513@gmail.com>,
	Munhui Chae <mochae@student.42seoul.kr>
Subject: Re: [RFC PATCH v2] mm/fake-numa: fix under-allocation detection in
 uniform split
Message-ID: <aeEuM41NLMr9HGac@kernel.org>
References: <20260416102558.575210-1-ekffu200098@gmail.com>
 <aeDz3UAB54v2K8Hz@kernel.org>
 <CABFDxMGYBkZpAeH8zbZsQA3giN9v8dyHPq=TCZf2EZbppMT24w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABFDxMGYBkZpAeH8zbZsQA3giN9v8dyHPq=TCZf2EZbppMT24w@mail.gmail.com>
X-Rspamd-Server: rspam10
X-Stat-Signature: 5gasft1iy8gex41wp6oen1qjdr496sts
X-Rspam-User: 
X-Rspamd-Queue-Id: E53BBA000C
X-HE-Tag: 1776365114-907032
X-HE-Meta: U2FsdGVkX18PaCHN8Hr5S4KXJRWkxTtccTGjH1JhqsiEuPauKxza3ju7eDAnTa6VCa9/neDw9+34om/E/2jQHKY1eiAiV6MRQEFF5W8+jMdIXZeuyhd8Q0WFilJVStBJ6/6kT9wua/LLFdZ0eVFrQ6uvbxQiPg1/JgTiqJIPZIAA+VLBf2ANHlcKziMeTVoItBKMsfZOz1/Jhtx2devP+RgvZmmLA83oDbwTwbatU9/ORYoYx6A+yOKunfqZsJ/wky8OAsJZD3ZUnbaXNfgcH09LlmYkJ2oN4Y6QVsvmLwVHrDN0O5cGgaiPxCF5tW4vHO7jXq/qbcev1NoEhwuOunWirvuGrnAE70wwXhR/g8kk0cZ0I7cDDEhP118ZxEnP7Ap20ykkk1sttJaWzOIxbC9XY67m/Wv3n1vCUJey3gQIMHVqMFZ+6DpodoKUGGE3A0jV5yQyQsZfSjRWoeFMF6JEuzNXnd/l9/fjHyaNM5Zkj0xkUhNut1uz9gtq1T98YfK3uzP51XGtM70S5eZXBEGmyl4ZuEMHjsSXYqmc4kQtWxoexhuqJ2+IbAvAObme1dwIg14vy+P8jGaTkWPUXxAQG1mnQX+JiMGT4Z9gfReWBBetf2vtoQVFiNWc79dO2/lnIwpcZQkoMucKEiFDRrhFT09rTx6vx/mylrKfoFwV6eHC83vyNehUrymYQA3r1uLUPOMxBmMKpaIIn/KrdRGGtPZwsgNCBysxiLxp/GRGw781/uSsuSMLz13/sYXB8VZ/C1flN4/4l+YYiPIxwUDEb20LdI7VgEo6tcGqvaPmb1025+cEGcQTNY6mLBBed+doWZYPunLs4MdshpWCjFIH9K+EhiUj0w+S00zc6tuBWbn0jmyPwmTSH0eJ4JD3BA+GMcZorot2BdJUvW5Gx+V9pBlq/iHijsWXdxVr2KuZ8Nr2AOqs2EbH4s17o6HOK158p8sXxDQB5iY8vS9
 7INu6C/K
 dk9Hi4Y5ZiiB6FftLzv5fziKrjyGVZP23SSgVBCWwfB6I7p/sjfrRaSkfKzoSZX8PcZwKcvP27IWhCYhnCxHeSNQhl/+iKGAEmDjTjPDTOtE53yuqFFc4kLZMfcTYb6UhT0gTWKhwFaYQOHQoeJqcA3HJJN1XNTapIuvcffgUMrw2pOQs4wNx9smYLF2RZGRTaiqANkf3/YYA0LDe5l79IXwv2sML14oopt+dWIavwjGjPIcXPnHugJ5NwXW7RHC01YPxFC+xze9wDn87hnT5R6QyDTDFOi5ph5/kV/oCrzAbdkSf1F05M5ym2c0UtfO0FPbaRdBgyurD3fY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 17, 2026 at 12:25:54AM +0900, Sang-Heon Jeon wrote:
> On Thu, Apr 16, 2026 at 11:36 PM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > On Thu, Apr 16, 2026 at 07:25:58PM +0900, Sang-Heon Jeon wrote:
> > > When split NUMA node uniformly, split_nodes_size_interleave_uniform()
> > > returns the next absolute node ID, not the number of nodes created.
> > >
> > > The existing under-allocation detection logic compares next absolute node
> > > ID (ret) and request count (n), which only works when nid starts at 0.
> > >
> > > For example, on a system with 2 physical NUMA nodes (node 0: 2GB, node
> > > 1: 128MB) and numa=fake=8U, 8 fake nodes are successfully created from
> > > node 0 and split_nodes_size_interleave_uniform() returns 8. For node 1,
> > > fake node nid starts at 8, but only 4 fake nodes are created due to
> > > current FAKE_NODE_MIN_SIZE being 32MB, and
> > > split_nodes_size_interleave_uniform() returns 12. By existing
> > > under-allocation detection logic, "ret < n" (12 < 8) is false, so the
> > > under-allocation will not be detected.
> > >
> > > Fix under-allocation detection logic to compare the number of actually
> > > created nodes (ret - nid) against the request count (n).
> > >
> > > Also, fix the outdated comment to match the actual return value.
> > >
> > > Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> > > Reported-by: Donghyeon Lee <asd142513@gmail.com>
> > > Reported-by: Munhui Chae <mochae@student.42seoul.kr>
> > > Fixes: cc9aec03e58f ("x86/numa_emulation: Introduce uniform split capability") # 4.19
> > > ---
> > >  mm/numa_emulation.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/mm/numa_emulation.c b/mm/numa_emulation.c
> > > index 703c8fa05048..c1d0a76aef64 100644
> > > --- a/mm/numa_emulation.c
> > > +++ b/mm/numa_emulation.c
> > > @@ -214,7 +214,7 @@ static u64 uniform_size(u64 max_addr, u64 base, u64 hole, int nr_nodes)
> > >   * Sets up fake nodes of `size' interleaved over physical nodes ranging from
> > >   * `addr' to `max_addr'.
> > >   *
> > > - * Returns zero on success or negative on error.
> > > + * Returns absolute node ID on success or negative on error.
> > >   */
> > >  static int __init split_nodes_size_interleave_uniform(struct numa_meminfo *ei,
> > >                                             struct numa_meminfo *pi,
> > > @@ -416,7 +416,7 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
> > >                                       n, &pi.blk[0], nid);
> > >                       if (ret < 0)
> > >                               break;
> > > -                     if (ret < n) {
> > > +                     if (ret - nid < n) {
> > >                               pr_info("%s: phys: %d only got %d of %ld nodes, failing\n",
> > >                                               __func__, i, ret, n);
> >
> > The error message also should be updated, now it prints the last node ID
> > rather than number of created nodes. I think it's worse creating a
> > temporary variable for ret - nid to make the code clearer.
> 
> Is "worse" a typo of "worth"?

Yes, my bad :)
 
> And thanks for catching. I totally agree that the error message needs
> to be updated.
> 
> > I'd also recommend running qemu without and with your patch and verifying
> > it works as intended.
> 
> In the next version, I'll try to include qemu based test results.

Thanks!
 
> Best Regards,
> Sang-Heon Jeon

-- 
Sincerely yours,
Mike.

