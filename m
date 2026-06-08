Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02841CD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 15:54:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BF106B008A; Mon,  8 Jun 2026 11:54:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 448216B008C; Mon,  8 Jun 2026 11:54:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35F126B0092; Mon,  8 Jun 2026 11:54:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 255186B008A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:54:30 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E597B1C0EA3
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:54:29 +0000 (UTC)
X-FDA: 84857192658.18.51CB10C
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9BD5D160016
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:54:27 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rNPbqq1I;
	spf=pass (imf08.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780934068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6e2VJEUHPiaVEzDajlyn44RRt816M9gMkmZzGYOPYKs=;
	b=00AVCmquW52giX9YjlkLvNYZxb1szW382RhFO3OeqivKH2tzMuSjBmIYz6OtmN3Ts4fmlt
	cFWvAfMQBbYF5hhkw6Rd+WT88gJdpgQfrCmKSoXWzUEl2BDJWm/7UEOl1HjQs7Wko9yHc7
	/hk/iDVYDigjD+wsmljSGekp/kNdSCY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rNPbqq1I;
	spf=pass (imf08.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780934068;
	b=VLdV9Wwqh5wVLVBU6SNzdKUVKkQVVr2qa+5MnJZt330suRwVK4j33Z0ylRp8gH1A9q5Td1
	d899oGogrXiYa+Nd6q9WXGSbrzlS7gRgRjJG6WEMZY/2u9wjvf2OFGgXta9icKG/pjjWHl
	2fV7mJw2cBouDtoO2ZMbxQ1H03hNtT8=
Message-ID: <a0945974-5e58-477e-9786-e14ea2fbcdbe@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780934065;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6e2VJEUHPiaVEzDajlyn44RRt816M9gMkmZzGYOPYKs=;
	b=rNPbqq1I7hkbyj7+TSLh7GUGIafvhL/CrNoQS89F78tQY8IyKTNll6zSvfH+Sv7h+4xjkc
	QsF5QGVQSTsv9n0ITb3SeskKIhfABcUz1mfN7/wRz9A1OJTwv0ZfxVN0ScUi/1Ih1umJUs
	ubYHA+pS+iTErOxRwpTwXGJ9p1GDr1c=
Date: Mon, 8 Jun 2026 23:54:13 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] samples/damon/mtier: fail early if address range
 parameters are invalid
To: SeongJae Park <sj@kernel.org>
Cc: Zenghui Yu <yuzenghui@huawei.com>, damon@lists.linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
 wangzhigang17@huawei.com, liqiqi23@huawei.com
References: <20260608143250.69024-1-sj@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <20260608143250.69024-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 9BD5D160016
X-Stat-Signature: djzqyjqhqa45wf74jjwnfwfircfkmi5x
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780934067-941926
X-HE-Meta: U2FsdGVkX1+TFXrb1CYc7/F2QhP6fNz2h3A9qcwAfZeVIJAgw3SeHFH94CCcwdV+bXsDTATUB8jvp4mkStg0JRzq9ApcaoCFPg4fuE02WAhxYnQ8u6zWLnbPNsNBpiIC5w31NGQPdNWiTj3S+AcxQe5qfJZCzuinorh/rp2GKCBJG0/zBTNxMP17zm5SKcpcOa+94ylu7no4GxL7aHin7uH80nZV7vyoI5hcnsu9qpF2O38TiEx6xKVG2RQ4uvDHS78Ewfv2Oei7bTQMJ8ndHj4ULOQgXs5cIZYXqC/QVMXos4iKdnuyCVIQO/VjHltexxfY+DQqxjcDcS/s8fBZseTjSLsIo74KWfeC20JQUipNbWQ/x+LoBcbaYVzcSFUFswQ+uG7198LjUAMKraXr9lLgXvaFZJgsUxiUU6nN7teLqe2HaNZoU4Z7BnQQoAcetQDbBzTSz/vA2/7/N5ctCg54lYFMfrUmRrRm86XUyPCA4Xgy9/F+ZYPVvNHqsLZSmMp/J8eiQHCyVt75gNbN1co3y/VaOOJyiKL0AaYmPOJB/j+v3FBEj4fFgWjoCUWIBtREsVK8LyFlisD/iNMJs8n2qEmJ1mHUBbD8JwqW8wZex5H4L7odn95PO/HiS59J74pfh6RviQu9BCQVDYlJ0J3DM73EGlPcfmXMFxB/C2sq+WOvbNxQDOPUhu1aqJpkUXD2dLC7nmBeiMssOOtT5BivK1AJU/zrlK0aKgEjlSrOltT0RlId2cQizuWe3aoznizPZh/xH2KGd+4Lof6KHrl3wYCUCr2E+AXNqWBXvI2o0IquI+zilKVvQNb0TDCc+Zxj4OmO9F1rSqTgktE6TMa54DX/nOtG0QAQ5l5uOf+J8ziFQDM5GVC0/+FvVvfj9EIZ95zIPODBPkyL9rnkYkfv7gFkLJs8O9kJKey5dvYUfWckdvNd4KbcPGnQLG/cfg5lIBjmlMN6B8BHc9k
 kwuHX2yA
 BcTT6z8Whq/TjSEBE6vDgBMVw/oxPa54yDqXg9exjUhsZtyn6pMcNiTe39lwFFAG/A6vARhT8rg3UyOEyYlw4aWlJagNH4kdxcx8o73iPuo1JSWRBebLY01nU2klyoVH4QfhKbgwqHkfMmm1HHlIqhq92lEZSx/M2nGfgY2ZqCxOqA0WENBYvJQqOhRHFUq5AqsR6OdtlJCZsy9uB3xW7QyTn5/Q4b0eJtVlf8ZnoEhiVdrk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SeongJae,

On 6/8/26 10:32 PM, SeongJae Park wrote:
> On Mon, 8 Jun 2026 19:15:34 +0800 Zenghui Yu <yuzenghui@huawei.com> wrote:
> 
> > The comment on top of `struct damon_region` clearly says that
> >
> >     For any use case, @ar should be non-zero positive size.
> >
> > which is now verified in damon_verify_new_region() if the kernel is built
> > with DAMON_DEBUG_SANITY.
> >
> > The WARN_ONCE() can be triggered if the mtier sample module is enabled
> > before node{0,1}_{start,end}_addr have been properly initialized, which is
> > obviously not good.
> >
> >  ------------[ cut here ]------------
> >  start 0 >= end 0
> >  WARNING: mm/damon/core.c:116 at damon_new_region+0xf0/0x118, CPU#39: bash/34144
> >  Call trace:
> >   damon_new_region+0xf0/0x118 (P)
> >   damon_sample_mtier_build_ctx+0xd4/0x368
> >   damon_sample_mtier_start+0x1c/0x90
> >   damon_sample_mtier_enable_store+0x98/0xb0
> >   param_attr_store+0xb4/0x128
> >   module_attr_store+0x2c/0x50
> >   sysfs_kf_write+0x58/0x90
> >   kernfs_fop_write_iter+0x16c/0x238
> >   vfs_write+0x2c0/0x370
> >   ksys_write+0x74/0x118
> >   __arm64_sys_write+0x24/0x38
> >   invoke_syscall+0xa8/0x118
> >   el0_svc_common.constprop.0+0x48/0xf0
> >   do_el0_svc+0x24/0x38
> >   el0_svc+0x54/0x370
> >   el0t_64_sync_handler+0xa0/0xe8
> >   el0t_64_sync+0x1ac/0x1b0
> >  ---[ end trace 0000000000000000 ]---
> >
> > Fix it by checking the validity of parameters right before
> > damon_new_region() and fail early if they're invalid.
> 
> Good catch, thank you for this patch.
> 
> >
> > Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
> > ---
> >  samples/damon/mtier.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/samples/damon/mtier.c b/samples/damon/mtier.c
> > index 775838a23d93..4a5d3fb12e1b 100644
> > --- a/samples/damon/mtier.c
> > +++ b/samples/damon/mtier.c
> > @@ -118,6 +118,9 @@ static struct damon_ctx *damon_sample_mtier_build_ctx(bool promote)
> >  	} else {
> >  		addr.start = promote ? node1_start_addr : node0_start_addr;
> >  		addr.end = promote ? node1_end_addr : node0_end_addr;
> > +
> > +		if (addr.start >= addr.end)
> > +			goto free_out;
> >  	}
> 
> Sashiko found [1] same issue can happen if detect_node_addresses is true, and
> nodes 0 and 1 are both memoryless.  It shouldn't be a blocker of this patch,
> but fixing it together can be very simple by moving this address check to the
> out of the above if block, right here.  Zenghui, could you please update this
> patch to do that?

Yup, it's worth fixing. I will address the detect_node_addresses issue
in v2.

> 
> Also, seems this patch is based on an old tree.  Could you please use
> mm-new [2] as the base of your DAMON patches from next time?

Ah, I'm not familiar with the development process of DAMON and I created
this patch against mainline kernel. I'll re-test the whole thing on top
of mm-new. Thanks for the reminder!

Zenghu

