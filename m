Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCE28CA5FF1
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 06:12:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5897C6B0088; Wed,  7 Oct 2026 02:12:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53A416B008C; Wed,  7 Oct 2026 02:12:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4503A6B0092; Wed,  7 Oct 2026 02:12:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 293756B0088
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 02:12:02 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 316F41C3323
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 06:12:00 +0000 (UTC)
X-FDA: 85294809600.19.108C593
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 98550A0007
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 06:11:58 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GUXRZ7/p";
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791353518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SHTNYtREyl/jHXCf21L5IlTPz5bWxE9lwwBn75z0B7g=;
	b=yR5cETifjSQcsP2CYypNZSG73tF4C6pkWzjcVflIPnDfEgU/i7GxG5+cuJrrwAjdtLZ8i0
	Miko2uYd9GC0CfafHsEgoB1ADIWNqoo39uR90P08o7a9XuSLZiOFRo5eBazGObywpqMGNq
	ZBTcts9bexBBPm6KsWQHhbB/vJFSqV8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GUXRZ7/p";
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791353518;
	b=OlNRHVqIKd8blOvUwSZGKlvk1PFTKBigsPvb4H5zYHm9QC0IKupNics4SdNqs3T4oBPBxe
	iytJqcr74mPBWGbK91cdvIxefmGwIBKp5x6pqAANx77Agoq0xS1fi7jFyJsDw8REVeEict
	WhayLhw4/oFz9KZWKv/SeA8BECu5kdE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E082D601FB;
	Wed,  7 Oct 2026 06:11:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 788F71F0089B;
	Wed,  7 Oct 2026 06:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791353517;
	bh=SHTNYtREyl/jHXCf21L5IlTPz5bWxE9lwwBn75z0B7g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GUXRZ7/pbe/AJpkN5e5FcdLKuJgDihokRM9FwbQxVdtvp+2LRSkZRdVJpTE58W4V6
	 NadEbJJreUG5ZHlSm5lZ/kScR9TQREkuTlYMfmadYLCnnhcsFnoxqr2OiLnEUNZWuq
	 ezVr4PgORcyU4YJMkI9wQr6DJOzeoucauYENm7ogq5W1+ZswY3InNw/cE9J6Qp5m7D
	 cvQCMK5tlmnYwkiHKEmF5ux/U5Wfqstw1sIxE2ErO9W6TbmevR9YrLXjkXZrkcTvuD
	 NW0AbPYQSCmA2pBAFsyhQ7q7ZYL7z/j4tXZa8uou3/iBwv4XtuDPfDM2G1wFOlRTFC
	 ONz6uDRN7u2yA==
Date: Wed, 7 Oct 2026 08:11:50 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Chris Bainbridge <chris.bainbridge@canonical.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Jason Miu <jasonmiu@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Ran Xiaokai <ran.xiaokai@zte.com.cn>, regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: Re: [BUG] KHO handover hangs when memmap reserves PMEM
Message-ID: <asXipik00P2Oa1Zo@kernel.org>
References: <asE0R_f2r2TL-3Sy@px13>
 <asTTo3AFzQoqZLoP@kernel.org>
 <asU2AD6DxGSD0ek4@px13>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asU2AD6DxGSD0ek4@px13>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 98550A0007
X-Stat-Signature: z5hfy4bx6n6tjyo8o6fiw8knkbuqyokm
X-HE-Tag: 1791353518-498137
X-HE-Meta: U2FsdGVkX18NKb7okBu2qPWCyNvworGdQajxPyPHli1PO5BO0J43qu75Q8BDUsszJaIgq+JtxF4Nh31V4nvZ4inRGkpHBWg5/rWoS+oLBk8x/KJnrQOAFM4M3ZAcLmF/uoZHkvCgjLeoAfDDthrEIV+9UpbAg53wwbTtMkkRykJSEsWG08tMnRdWdAo6dHUMUa1vvRAfSOqYrsiK2pfOmrt787jGBuiuKslShklCsWSFnFrj9W7WdRt5bFoUCavsFS0z2yG0IlVVu/Qsw42+V6eZguQAw1VFU0Qru288qMA+1OvNePkwn/KY8A/GjBGZvOn2IhTRiakP6OTIPR4sDpEuu6VCKwMYoddZ0UOzRJTDrIRDrzAIJOe0I2r9tUawCLtxIBuT8OVc3lm6T/HHcyb0Zi6GhpzeP19nRh+/v42ipDcfmDlruejkE6Gtfp/c1emS33YBrrg3TJTYjbDcCan92gPFQvGoaB+faM7WwVhqMls+CQAUqtIFYNUFyc5Kf85JOU7OmBZsziJzI4YTwPbRZxuGUK4fwdNj6NjgZSWyOdg5Fpa6jEei1vjQOZLMXEtLPhsH6xQtb++CkGplHFNktq7ui9ovxcSvvexTr12SY2NwwP0UIQ16ccsyLMHhLdnyzY51kPPLzxva2isLfzNCJMtKVF7hK3qbKh2ouFbE7Ghl02yQmT+1InwCkws7jiRFBXeCI40HqPRJOb7crWVd9WZ9x3fesC698NBs1+ITjOztjxsTYn1lvjRkIhjvoqo0L1snsKdLZyRSZaNlVw9awvzY7l5yzenz+qK6fjQasKFWgw3xxDjGlQLH7YXGc1EkEVwiPxVuy8V4ZlxW1mOxopCbvkPuHXC2LKmZkuJj4s3Ac9IdE/QcbI/TcsVgyNITVBv5m63B4gs/nYIEWd4yGHHieFu1qtXZVY21D80kavJHkzsQl3Yix/sC6Vw2eGVa3vkfu3pLRUHS+on
 EfEgGIYg
 z+wjp0Iz4MYMVfMJ/ik5lPrvesru6360yPtlbnETNURm2cAlIskE4OIeJy0psTfNnw/qqt0burtLLEBI8KotE5PfLMnl+6NIwASQeTy9lDQTwFQ2jscAVgjqPrQ14edrBeF60HVkVdyWUo0eLojWSFtoKHvunqEqbLyBkkO6VuBf4rspOwaIscbuFGXDvRl7PodOjjiz9T7vaZ5WAet6jhTu5bJoMAxcjU5pcQIcUBEYS6XRbpo/hGoYGgnfnC3UWgJdB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 06, 2026 at 07:02:22PM +0100, Chris Bainbridge wrote:
> On Tue, Oct 06, 2026 at 12:55:31PM +0200, Mike Rapoport wrote:
> > On Sat, Oct 03, 2026 at 06:02:27PM +0100, Chris Bainbridge wrote:
> > > Hello,
> > > 
> > > I am reporting a regression in KHO handover.
> > > 
> > > In the most recent Ubuntu 26.10 beta mini-ISO releases (2026-09-18 onwards),
> > > the first kernel reserves RAM for the downloaded ISO with a memmap directive
> > > such as memmap=<size>!4G, then kexecs a second kernel. On affected kernels, the
> > > first kernel reaches "kexec_core: Starting new kernel", but the second kernel
> > > produces no further output and QEMU spins at 100% CPU. On unaffected kernels,
> > > the second kernel starts and finds /dev/pmem0 with the expected "Persistent
> > > Memory (legacy)" range in /proc/iomem.
> > 
> > TO make sure I understand this correctly, you enable KHO in the builds of
> > the installer kernel and then the installer command line explicitly enables
> > KHO.
> 
> Yes.
> 
> > Is there anything you actually preserve with KHO when kexec'ing the second
> > kernel?
> 
> No. kho=off is a valid workaround for the mini ISO.

I'd even say that setting CONFIG_KEXEC_HANDOVER_ENABLE_DEFAULT=n and even
CONFIG_KEXEC_HANDOVER=n is a reasonable choice for a distro kernel.

We don't have CONFIG_EXPERIMENTAL anymore, otherwise kho and luo would be
gated by it.

> I only reported it as a regression here because this was working until
> the bisected commit was merged. If this is intended behaviour then it is
> not a problem.

Thanks for the clarification. 

This is a bug, but since it happens for a combination of an opt-in option
(kho) and a hack (memmap=) I consider it low priority.

-- 
Sincerely yours,
Mike.

