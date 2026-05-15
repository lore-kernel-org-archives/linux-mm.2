Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFB26CD4851
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 11:36:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61EA86B0088; Fri, 15 May 2026 07:36:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CEE26B008A; Fri, 15 May 2026 07:36:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E4496B008C; Fri, 15 May 2026 07:36:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3C9F36B0088
	for <linux-mm@kvack.org>; Fri, 15 May 2026 07:36:18 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C70B81A0633
	for <linux-mm@kvack.org>; Fri, 15 May 2026 11:36:17 +0000 (UTC)
X-FDA: 84769450794.27.79BAA54
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1BD8D40006
	for <linux-mm@kvack.org>; Fri, 15 May 2026 11:36:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rj+xmIGM;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778844976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gxtuscaVmAUd4jSiCquCb76bG4Yk/KBydn38XTztzFc=;
	b=IVxb939KvFpuXLFnkzK+lzoCYe5EuetYoA73z0ZUbhEZachZ0q8sgTk03XePAhMoyEs2nf
	zVySCObvYxROU4T5QHy6W/ulte9s+6BAfLK1YXS94Z8KzB4nxnTPv3d3jkLrzJJaoveD5G
	/o04nYzinXWDO7PqrHnbD/CHUT+oErw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rj+xmIGM;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778844976; a=rsa-sha256;
	cv=none;
	b=J5TXcB8V1bdge7LDKzhEHtBtDXinxWKIkwZ6I6VyIZQB5qlAKMVAy056lrFn+nmwBQBXNj
	hp73SjsZtgj8GM7flukc6uo//AWZGBOV/nx87HoSL/IaqwRvWQjURFBdCZGy8HFuPsudz1
	vzWxVLLrMZzpokzVx1A5DCV2jiBwDhE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EC60640137;
	Fri, 15 May 2026 11:36:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E4CDC2BCB0;
	Fri, 15 May 2026 11:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778844974;
	bh=fpmX7i/2n7TdRNKJMWKe8p1y7hQIc9tuTqTKByIO/BQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rj+xmIGMjzlDWh0IxoCnDOYMIH0F30W9EiLzViLa2qvwgjUXdNlndaYRBThYVelwf
	 IiIJVzgMUgt71fsVxj7TVWuka608WaiPDsLpIMsCQ5kiEYFWSBObT+pcfjfMfEPJ3k
	 MyTHm1hD8h15MhpZ/hkCMycRF54tQKazQerA34chvGVNgRYJr+bUPA/PlIK0I65o8I
	 lhLzeiYKlv8L/7px58M98rSBpwXmzaXNPsM5AMg+gMFTsuiuPqWfzZIptyIjvWhPHa
	 vuftc5g5DEnOFZZNDsxoJTy8AUvnrV+V0MFqHoELqY1D3b/AL0JNKigolj5HJPbK/m
	 ge+NhZ2i9k2XA==
Date: Fri, 15 May 2026 12:36:10 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: ranxiaokai627@163.com
Cc: akpm@linux-foundation.org, baolin.wang@linux.alibaba.com, 
	hughd@google.com, leitao@debian.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, ran.xiaokai@zte.com.cn
Subject: Re: [PATCH v2 2/2] mm: huge_memory: refactor
 thpsize_shmem_enabled_show() with helper arrays
Message-ID: <agcEzrqJlyxMeM35@lucifer>
References: <agW3KFDoBqZI7-kp@lucifer>
 <20260515060441.53094-1-ranxiaokai627@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260515060441.53094-1-ranxiaokai627@163.com>
X-Stat-Signature: nrx9nq3fomes6n143a5pobobsig9zso5
X-Rspamd-Queue-Id: 1BD8D40006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778844975-139244
X-HE-Meta: U2FsdGVkX1+b1L+PLQR54NzLVwL2qg/KZ0L3RDqNkr2wicH5VVamurpKPSm4YAVz47BlC2xM6Po5deWa+FPyjH6/Tjb49Fznv1PpDri2i4BN14zWQg4wro/Idw94WdDsz6f1DMub21/tWz4cJ/2W3RUtKKp7M5VyIhTw0zkychaBSIJh09rbot2pw/cdoqP3HtC9RSFvdWYJMrAFChVvwEq5zDcuR/Pf+OQQcMdmx+eg/uXxcbH2k/dtKxL6VgArPUS9xS6mCqnj1lQrEQu5e+Fpf2mh1XkD6SS4nSineovqvdyeKfDMmMhnBOhcPVlOvvvR4wPSZIbEelpabATrdsqAp2GlmXLXOEcOy1cnhvyvkMvHLGQzp5Payrahgg1l1L7coOBuWAQfq28FwPHV8hRptzGs9nK4CM1kY0MRReeQ1Ogq/lgxOI7a5+QT7PS5mlO8z5AGr+S+NFS8Zt9vP95uOQh16jj766VDEam6Nax9gvFINcVx+EBwOOp+MTVaCTEKWk0YiI54TMYLWoZVvBA38LC/V5DmTTerr5MjSD1GuzBEPV40yhogSMvK7mAKlDhj3rf38lhilZ1E9UwvEWjvfpeSd6DaWhbI+/G3eZ4CB90r+Wq6cZs5mIylgW0s6vGri0X1HYjCtDwM3bmZVdeBFnltS8piN7nsiXoMT1AYPRQwopZkI0Np9Y/pOzZICu/LHjkNl19iyOk0R8ZhE03UCEG7ePGxTvWUmH5hbLFlRqZHW5CEHfML8+BwwM/2eztspN2GvLJ/om3T02WyNqevBNZ31+emSacfsrYIKOUka9oMmWZtyjn9ymUqU+wiJ2dFUFjcquubYJMWitP0ub7OPSbWpUc9pv8Qgj7Sk9YgfroDWdUO6oDoiS0JbaKYBU/I0+G8KtVzgLqmkaP/uuQGBifx6bqRMERVT9CmEAmbPXZBD9sqpAYqWyF+4dsobiz62g2nUIEvj0L7SPW
 YMN4wk21
 gW+zxvdzxkJ2hbfKhmDpgZVA0c43jLtLxZAtNN0/0JaL5aXkqqgbcX+bFWb4MfF7xBerXfyKM0RKzhB89W6j48QgCZx/1gV0+qUU8SB1nBI4ovhIJ+fAMia8FfFOPseQDAfwXgTgwm8sa9kKA2tir6SDljabuSFUf4ziosE3TOFiGXRq4lq6eVHHm4JcKezyLwkJ1iaTb1H3QlBA971q0SO5aGKlNksu28HOvmztXDASmHX0ILyNMJwrITvHwZ5qUi2kVl43rdtIHFzCIWdhsiv0HzTY4EYANge/VmsbaNONhmSpaYpVOuAmqCX/lu9ZeAoo8OeostlIYidFOO/Wv+bEEsH3xLl2Og6W9tUD13lWf1nhAg7khI5hS3xd4fbECoAP6+lBb4vD4tZDmmOeJdOrtXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 15, 2026 at 06:04:41AM +0000, ranxiaokai627@163.com wrote:
> >(As I said in the 1/2)
> >
> >Please don't send 2/2 in response to 1/2, and use a cover letter if you send
> >more than 1 patch!
>
> Thanks for the guidance.
> I will do that in the next verison.
>
> >On Wed, May 13, 2026 at 09:45:08AM +0000, ranxiaokai627@163.com wrote:
> >> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> >>
> >> Replace the hardcoded if/else chain of test_bit() calls and string
> >> literals in thpsize_shmem_enabled_show() with a loop over
> >> huge_shmem_orders_by_mode[] and huge_shmem_enabled_mode_strings[] arrays.
> >>
> >> This makes thpsize_shmem_enabled_show() consistent with
> >> thpsize_shmem_enabled_store() and eliminates duplicated mode name strings.
> >>
> >> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> >
> >The logic looks good, I wish we could de-duplicate. But for now maybe better to
> >get this refactored first.
> >
> >So:
> >
> >Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
> >
> >> ---
> >>  mm/shmem.c | 36 +++++++++++++++++++++++-------------
> >>  1 file changed, 23 insertions(+), 13 deletions(-)
> >>
> >> diff --git a/mm/shmem.c b/mm/shmem.c
> >> index 60cb10854f11..086762e6de71 100644
> >> --- a/mm/shmem.c
> >> +++ b/mm/shmem.c
> >> @@ -5553,20 +5553,30 @@ static ssize_t thpsize_shmem_enabled_show(struct kobject *kobj,
> >>  					  struct kobj_attribute *attr, char *buf)
> >>  {
> >>  	int order = to_thpsize(kobj)->order;
> >> -	const char *output;
> >> -
> >> -	if (test_bit(order, &huge_shmem_orders_always))
> >> -		output = "[always] inherit within_size advise never";
> >> -	else if (test_bit(order, &huge_shmem_orders_inherit))
> >> -		output = "always [inherit] within_size advise never";
> >> -	else if (test_bit(order, &huge_shmem_orders_within_size))
> >> -		output = "always inherit [within_size] advise never";
> >> -	else if (test_bit(order, &huge_shmem_orders_madvise))
> >> -		output = "always inherit within_size [advise] never";
> >> -	else
> >> -		output = "always inherit within_size advise [never]";
> >> +	int active = HUGE_SHMEM_ENABLED_NEVER;
> >> +	int len = 0;
> >> +	int i;
> >> +
> >> +	for (i = 0; i < ARRAY_SIZE(huge_shmem_orders_by_mode); i++) {
> >> +		if (test_bit(order, huge_shmem_orders_by_mode[i])) {
> >> +			active = i;
> >> +			break;
> >> +		}
> >> +	}
> >> +
> >> +	for (i = 0; i < ARRAY_SIZE(huge_shmem_enabled_mode_strings); i++) {
> >> +		if (i == active)
> >> +			len += sysfs_emit_at(buf, len, "[%s] ",
> >> +						huge_shmem_enabled_mode_strings[i]);
> >> +		else
> >> +			len += sysfs_emit_at(buf, len, "%s ",
> >> +						huge_shmem_enabled_mode_strings[i]);
> >> +	}
> >> +
> >> +	/* Replace trailing space with newline */
> >> +	buf[len - 1] = '\n';
> >>
> >> -	return sysfs_emit(buf, "%s\n", output);
> >> +	return len;
> >>  }
> >
> >This is pretty mcuh a one-for-one copy/pasta of defrag_show(), I don't love that
> >we have the exact same code duplicated across two files like that.
> >
> >You could write something like:
> >
> >static ssize_t thp_sysfs_enabled_show(struct kobject *kobj,
> >	       struct kobj_attribute *attr, char *buf,
> >	       const char *names, int names_len,
> >	       const char *orders_by_mode, int orders_by_mode_len,
> >	       int default_mode)
> >{
> >	...
> >}
> >
> >To abstract it, but that's kind of a horrible signature isn't it? :)
> >
> >Could use a helper struct, but that feels a bit overkill for this hmm...
> >
> >Really I wonder if we shouldn't have this in huge_memory.c anyway, it's a bit of
> >a weird thing to put it in mm/shmem.c, it's more huge pages than shmem imo.
> >
> >Anyway. The logic itself looks fine so LGTM!
>
> Yes, after this patch is applied, the read/write handlers for the
> shmem_enabled and enabled interfaces will have a lot of duplicated code.
> I will continue to investigate whether we can abstract a more generic
> function to handle both interfaces.
> Introducing a helper struct as a parameter is a good inspiration.

Well it'd probably be overkill :)

For the time being, let's not do that, and just get this change in (with other
changes suggested applied of course), so send a respin without that please.


I think it's more important to address the hideous duplication we have _right
now_ rather than optimising deduplicating this code :) we can always do that
later.

Cheers, Lorenzo

>
> >>
> >>  static ssize_t thpsize_shmem_enabled_store(struct kobject *kobj,
> >> --
> >> 2.25.1
> >>
> >>
> >
> >Cheers, Lorenzo
>

