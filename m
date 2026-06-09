Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B160CD8CA4
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 14:20:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A12FB6B0005; Tue,  9 Jun 2026 10:20:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C3636B0088; Tue,  9 Jun 2026 10:20:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 900656B0095; Tue,  9 Jun 2026 10:20:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 84C766B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:20:52 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 48F421A05C3
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:20:52 +0000 (UTC)
X-FDA: 84860585544.28.771858F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id A940B8000C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:20:50 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=flnRsIYE;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781014850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mr28FJp+qSm7flFpPjHxz5ehcZCYEDaf60+LJYYJIlM=;
	b=Hhg0pOnDPMlIV2C67CSMqBUixS/f7/WmIprv2gth5iTrTSBexbq+q0TJGR5pmUV/91NTtc
	KO29JoDBKlEzryc7wuZHB5Q0I2CCjfSWTn3WEyhditUQgCVN4kYkP82TmhzUyQxMJPhNUE
	CKLGMAu40rEZH1KgtNQRd4fplcIbMDU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=flnRsIYE;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781014850;
	b=FB4pq1HAfmTqDhGlErTzzq5W/fyouBL+cKraOkDCN7UyucCQ98vZ93MDI40jc9xxF0s/IZ
	FFmSPman+hwPk6nWNiDEA1la+dKd18BJQuQMcYACBP7eKigbsaHqCIFQUYigwHj75RFmgn
	ylq3QImV9l2cbPTxBVQncZhJC3mmOd8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C677B42A4C;
	Tue,  9 Jun 2026 14:20:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC891F00893;
	Tue,  9 Jun 2026 14:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781014849;
	bh=Mr28FJp+qSm7flFpPjHxz5ehcZCYEDaf60+LJYYJIlM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=flnRsIYEt297kGasiVICyMjovbQkZuXa1e93qSqoj8rtO72Ul2/+OCht2TNKTGvQx
	 clV47lt+1HdPFqFtVoYnhoY/LT4WAfFd4ny+KbAhComiD+WgPrjgFT0klkORkA5crA
	 oFq10gZpLtekqZuWY0F7kKf20Sz14+udXOt9gCC2z+sbc2ztJ0NHBjvPs+bEVNhiOl
	 6feU5XnMBVkhSPjqPrn3CkP0VIWgFD6GxshUhr4elJngfhqMzWcmUIQA2hMkO/aObh
	 6CWXZJ6AFaMhJO9Woi8ft4fbXCgqehSVEL6YShghEmu62vVWATiImXlvI2FfQrj3dU
	 //JhhRTsHDXlQ==
Date: Tue, 9 Jun 2026 15:20:43 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: ranxiaokai627@163.com, linux-mm@kvack.org, ziy@nvidia.com, 
	dev.jain@arm.com, akpm@linux-foundation.org, baolin.wang@linux.alibaba.com, 
	baohua@kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>, 
	linux-kernel@vger.kernel.org, npache@redhat.com, Ran Xiaokai <ran.xiaokai@zte.com.cn>, 
	liam@infradead.org, ryan.roberts@arm.com
Subject: Re: [PATCH] mm/huge_memory: fix memory leak when
 kobject_init_and_add() fails
Message-ID: <aighDgd9FiAeOWij@lucifer>
References: <20260609131249.89288-1-ranxiaokai627@163.com>
 <c9500789-5a27-4348-84b6-a787230edebf@kernel.org>
 <b3a6dc63-7701-491a-ad06-ee0be7d23123@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3a6dc63-7701-491a-ad06-ee0be7d23123@linux.dev>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A940B8000C
X-Stat-Signature: qrxxinzj8fkswbxsmrppwc33oamnaf1p
X-Rspam-User: 
X-HE-Tag: 1781014850-237918
X-HE-Meta: U2FsdGVkX18GrLZ2DV54NxGeuqMDAf1RrKYXZIRxgv1kd/a9OrMU2R9/hJN80RElv7/0+3ouKQmDOHiiE4/fQ5yvVg60PDogr+7nHntJMh82hzzhwrVdDZUpGLIUu8SNV5MBxit97OM6bMzFDKpcHazAJkadb2a2u0LYDVjbdmww2I4u3jkDty4gAKFKS+CXOrWvuMQH3jhS1JEyeWNnaiLHlstTB3JvcU3DV74s1N75JYFSB2dcS2CY513pZ/nHei9t5aP+/4u7oGYJsch9+H4jZ2UYkST/cVaRKjwFILPcEBgu5RB3YLtmvqU/1srUMkKS3DcDUGcWNrhKqDMUQc3Gt0ZBiODfUxPLRTjomW8u3kBZ2ocpLhx9F5SAMlUGfFPOINSXUHYiPATJ1OZ2h/81zP7ee0iWeiQ88IVSm9cjWd0Lbg3LwHgs3JnVa2H+N4pAgwHnf5ZSNBsaH9IhnvamvP0+BeX4PxBgEdHSGMPzHWvgAWaljd7atSpM/T00ti/rD39MkEpR8h9C4KmU9zbvXv3g3zkmG2IcVyMMsuJDcPvSpkz25wvwzxk1w4Is6Yo1XkgLADOziYO6kej/ZVtJvTThsMbK8OZ9C6QIKSCPyprBZlW93QRhkCc5vx3/KjLjlC53jf5SKgWeFrRBypoG7Nr0zG6rQrK3IwDb/opJJSL3m0Ux5TMqfmZ6dC0vAKRcPwBsqCSCvz3iFoPb9D49Px9WYhGeLV5s2tkIB2DAIYm5C6mTW0IoLxiRD+EMhHjTiZBBLClmzOlhUK+A8c9Lyir0y6GQgNzPv6hUw3CCuagavswR5TEw/nHnHTny3ir0LGJgsfIeAPE3qT8yVvUev1BlgjOR0gJPAPF/HEB0aNRV1o7O/vOocc86Imtcpg7MzJYuCSj4ZHuj8UJzqfB5TQQ4CF0+2J6uG9gEgCpoGndSy4e9mrs04F+/NXAW68V6cTHEVxeQnT89G0r
 dxlNWZ83
 W4cWSiKQIUjG5i2YMftu6hs9c2WHB3v2uCrv7m5Q8qZV5nzIaLj0rcL06j7Oby8SlPj1viHCDXqoKeONV3/1eNkhOq5O7QCmngYwRhqcGIfqvuks6jhuNuKdDJ7PkpW2/cUs6/G2x09WUNl2Ympu33BVlZHmpeqD0HkIF/NwMTOGfLzaFJ9vIObzXaGFtQH9fUIbJD5YyxSaSJ4yhaHaTIDqmnz7WhS7N2ZtXmlLqiOffYYrYF+/SuqUuhxNTQTBaL+b0h17NPkHlo74aoAwF4249NlQaYvEBEhf9vC3V8oWE/kD+BDSJuvteKp58q9RcCLj3AARZD+Fecmf5vTb+AyPfB3cwb+pZOW0PMvocRTcS4kprCQnpTP3ihXKVduDMcb4sp8uiEiQWsZrf0UkACA0e8jPkgJsH4ZQc1eNZvxu1jO0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 10:04:16PM +0800, Lance Yang wrote:
>
>
> On 2026/6/9 21:19, David Hildenbrand (Arm) wrote:
> > On 6/9/26 15:12, ranxiaokai627@163.com wrote:
> > > From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> > >
> > > As documented in the comments for kobject_init_and_add():
> > >
> > > "If this function returns an error, kobject_put() must be called to
> > > properly clean up the memory associated with the object.  This is the
> > > same type of error handling after a call to kobject_add() and kobject
> > > lifetime rules are the same here."
> > >
> > > This is because kobject_init_and_add() may have already allocated memory
> > > internally for the kobject name (kobj->name), and leaving the refcount
> > > at 1 prevents its release callback from being triggered.
> > >
> > > Fixes: 3485b88390b0a ("mm: thp: introduce multi-size THP sysfs interface")
> > > Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> > > ---
> > >   mm/huge_memory.c | 7 ++-----
> > >   1 file changed, 2 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > > index 653f2dc03403..601750dbe79f 100644
> > > --- a/mm/huge_memory.c
> > > +++ b/mm/huge_memory.c
> > > @@ -790,11 +790,8 @@ static struct thpsize *thpsize_create(int order, struct kobject *parent)
> > >   	ret = kobject_init_and_add(&thpsize->kobj, &thpsize_ktype, parent,
> > >   				   "hugepages-%lukB", size);
> > > -	if (ret) {
> > > -		kfree(thpsize);
> > > -		goto err;
> > > -	}
> > > -
> > > +	if (ret)
> > > +		goto err_put;
> > >   	ret = sysfs_add_group(&thpsize->kobj, &any_ctrl_attr_grp);
> > >   	if (ret)
> >
> > This looks a lot like:
> >
> > https://lore.kernel.org/all/20260411062152.2092967-1-lgs201920130244@gmail.com/
>
> Right, the same issue :) There is a v2:
>
> https://lore.kernel.org/linux-mm/20260412175428.2613383-1-lgs201920130244@gmail.com/
>
> Still pending, though ...

If people could use my actual correct email address it might not have been
pending :) *grumble*

