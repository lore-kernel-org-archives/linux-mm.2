Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 330FCCA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 09:20:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 881D18E000B; Fri, 12 Sep 2025 05:20:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 831968E0006; Fri, 12 Sep 2025 05:20:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7208C8E000B; Fri, 12 Sep 2025 05:20:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5ABB88E0006
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 05:20:04 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1D4C816068A
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:20:04 +0000 (UTC)
X-FDA: 83880051528.20.2F7EF34
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0CBB7160007
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:20:01 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=oT7QcAey;
	spf=pass (imf08.hostedemail.com: domain of sumanthk@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sumanthk@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757668802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rZc9834EQmnX5OjtQuA7Dp/c6DGjo1MBldcjPqT/2OU=;
	b=fH0/NTZLGDPy11gaDOYnC3mPTpNd5n9tOJRy7xM2tMcLOkZilzFvcDOysVDyKjZk60Mr85
	ug78ggDI+AxrgvfRisE/+6FtQoyjCFN7/4xgPbQLO7eD0aEYXiVw5PCjAsfecI+SoGIos1
	2+yhGXMn/meaC5T1kWWVrFpP2qelJec=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757668802; a=rsa-sha256;
	cv=none;
	b=icsYUb+z0NRk2fTRraALlW4roFrAkkxxBkr8nrARsEp+FEysHKF/sGrAWFDvmQoqCHK/uj
	3xKEtfEWONCtRQhwi4XL06DUQlaAtP9tazYaAo7tKF3EXnB+dQwk88mOoxGcQMdV5cFn7d
	88F+CVc7+CSB1Jvr9FMhf86MJw2B6mY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=oT7QcAey;
	spf=pass (imf08.hostedemail.com: domain of sumanthk@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sumanthk@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58C7s0fp010489;
	Fri, 12 Sep 2025 09:19:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=rZc9834EQmnX5OjtQuA7Dp/c6DGjo1
	MBldcjPqT/2OU=; b=oT7QcAeyDCK579nnNLWUMSZVrW1VsEuASH/MVg9/rpXyvO
	qx2tdjP0DI+d58PUpp8IUcdgMKdIsu3scsvEWQqpXSyldabSxttqvPuCNi6JvyQU
	eKuC8ewTHbhVNDwSv+J26pujadusNJFEx9ewhKtws+CBinrWUAMumvxYHGTfNv8r
	wGPFxPpU9Zy6lx+1iEs65EeIg4GN+IoY+hzhHSETrAo8ql3om5qxClC+0R5cZXlW
	lUFK5/KKHtP9nmUDrJnTHzg8eWbRrYWdv0ALZnKtkhGraqtCz4UhHEe9vn66LyNl
	gmHXowVT99A8gtSQQKBkcmWEnDMWR/FkWnu6CqRA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490ukexmfx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Sep 2025 09:19:59 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58C9FceJ011457;
	Fri, 12 Sep 2025 09:19:58 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 490y9utf24-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Sep 2025 09:19:58 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58C9JtNa18284942
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Sep 2025 09:19:55 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ED3472004B;
	Fri, 12 Sep 2025 09:19:54 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5581A20043;
	Fri, 12 Sep 2025 09:19:54 +0000 (GMT)
Received: from li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com (unknown [9.111.76.176])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 12 Sep 2025 09:19:54 +0000 (GMT)
Date: Fri, 12 Sep 2025 11:19:52 +0200
From: Sumanth Korikkar <sumanthk@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        linux-s390@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Subject: Re: [PATCH] resource: Improve child resource handling in
 release_mem_region_adjustable()
Message-ID: <aMPluIk8EnOuIWbi@li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com>
References: <20250911140004.2241566-1-sumanthk@linux.ibm.com>
 <0ab2cb14-ba8e-4436-b03d-9457137f492a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0ab2cb14-ba8e-4436-b03d-9457137f492a@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDE5NSBTYWx0ZWRfX8+MoGTPNm00b
 KOFWKPKV2Xy6RGjoy4rtU6RkByiK7NoS78T8ir18gq0fRHiE730SriDs43zGcf0b4Hjb5xIok0I
 BWWHNTnZhD4ZiOO+KQTPmY+i19osybJzSjnXpE/Fx+XFj2/sBsz6CL71CXB/GNRQh7X/PRVR0gA
 AmkvzSmLGJRctE6HKF044iUzNjOzF3AkQ6oNFAzMmYSFmsghNoUtk8D3xhk/hUHm/sCyxzv9QGV
 MryrgP7l5jM3fk1GMdX/L1ARR4/zvtumI+U7v1eUYLC3pqPp/fzUxpEKt9P1+3WUjEXo2ZGbGns
 cFZJG+/JGGc4BlQdJFES5+c2xq1ryJtdmCUCrf3icv8QG8DJKQoQFT0W4Z3WihToReKBIAY8505
 lRWnYkx6
X-Proofpoint-ORIG-GUID: YvJGDlMvwKn3eiGsY0_1sV8saR02XCv-
X-Proofpoint-GUID: YvJGDlMvwKn3eiGsY0_1sV8saR02XCv-
X-Authority-Analysis: v=2.4 cv=StCQ6OO0 c=1 sm=1 tr=0 ts=68c3e5bf cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=2Bmdxn4tqa3G8kVuJ3QA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-12_03,2025-09-11_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 bulkscore=0 clxscore=1015 adultscore=0
 suspectscore=0 priorityscore=1501 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060195
X-Rspamd-Queue-Id: 0CBB7160007
X-Stat-Signature: ej36wmnsetifd8aoqokcroj4qmpynd7r
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757668801-730891
X-HE-Meta: U2FsdGVkX18yJa4yIXuoJ2rK/ll8XjcoaKS+ilkl+SE7qSu3o4EL4kFeSJqdDLgGIU4XGIgmizV8JFIa1VjBNuICIEmFb2kXyPHl4Lfs6ElGB/iN/N8LLl9TLBUV7201BNW5yiLva7PqGFUXiB7zPOovp085tYFpZXauzw9Cy+K9EdgEberdqwHUnYWHtFgdL7uDFtGvJFMKmBW+ujY7SVv0Isd8xk4mtIlPGPdWN4eoZpVQoqn/cgll830jJFGgSIfq/wbnmE/kpn3eRGiOH1tlIeEJEp8V8f2feaNODLmaZyI8wDjmVLx/RAujYG1XjVZ4VKY4w7cpLOfBNo1dLjpsrTlx6vBO8YAh2fzOSbk/FY+IJOlm/rQdHH5KsxJSc8Npt0Xq2f0oKu0zPcO7yZc/lNzfr0+VsGgRTiYp9R0dWy6nedksq63chqNIjsLRTxbgxIDoQYOgoVbF9B8u1s6L4j7VEywabm+f2QMG7/852p6KJbv8kkwXvLnxahuIKaG5GVvxrDle6yzPf3KL27yP8eVN3uKgRTvWCX2b+Vrizgdyn1F18pKMtp0Q66Uc3mLMlSUeyX+IuvbZscJdUWz/P5BM0CSKzcojdIZzpNpL/l2bnJz7NgAdAnyL169UrKLwwx7WkXay7sUXCCfmbnydugvDxLUgBSdo9yZc9TfHzhqXC0Vt3YvDuO7mzSe+oNmYLZlt2dSNb7JyGQZ5DCmCK8AjLf9B4OWM6CVaSwuapr7ySnza+R90cQMyXzsVQcR3QbOs9rpBiP24nDS+z2UXXqoYRsAcrkpkqJVD90OpFPgqkRIq4Nm5lYmyw+jULcC8Nc6hTkMBKbuM/tGu6XT27xP0OIanUkkFTWXVKH8EB9qRHfluLuyIaUS5cufbaeBlr6XHa3gleIRqDBJwlbkovVtn4F19DVBpNOyo7dABdoWHP1oWfPGllrRb/99hVZjd2WuWd82ZOkE7jlt
 hAw2y9I+
 EperO41ObzB6YD/2g/ey+3M5rrHVQmZAQYTR6iTO8FfZrTEnjIZTMS5+fds2Blaq0kxbn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > lsmem
> > RANGE                                  SIZE   STATE REMOVABLE  BLOCK
> > 0x0000000000000000-0x000000014fffffff  5.3G  online       yes   0-41
> > 0x0000000150000000-0x0000000157ffffff  128M offline               42
> > 0x0000000158000000-0x00000002ffffffff  6.6G  online       yes  43-95
> > 
> 
> First of all
> 
> 1) How are you triggering this :)
> 
> 2) Why do you say "and removing the range" when it's still listed in lsmem
> output.
> 
> lsmem will only list present memory block devices. So if it's still listed
> there, nothing was removed. Or is that prior to actually removing it.
> 
> 
> Is this some powerpc dlpar use case?

Hi David,

I am working on the item related to the last discussion -  dynamic
runtime (de)configuration of memory on s390:
https://lore.kernel.org/all/aCx-SJdHd-3Z12af@li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com/

I came across the problem when I tried to offline and remove the memory
via /sys/firmware/memory interface.

I have also modified lsmem (not yet upstream) to list deconfigured
memory, which currently appears as offline. An additional "configured"
column is also introduced to show the configuration state, but it is not
displayed here yet (without --output-all).

> > 0x0000000150000000-0x0000000157ffffff  128M offline               42

True, this will not be shown with the master lsmem, since the sysfs
entry is removed after deconfiguration.

> Do we need a Fixes: and CC stable?

It will reference commit 825f787bb496 ("resource: add
release_mem_region_adjustable()"). Since the commit already states
"enhance this logic when necessary," I did not add a Fixes tag.

> > Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
> > ---
> >   kernel/resource.c | 44 +++++++++++++++++++++++++++++++++++++++-----
> >   1 file changed, 39 insertions(+), 5 deletions(-)
> > 
> > diff --git a/kernel/resource.c b/kernel/resource.c
> > index f9bb5481501a..c329b8a4aa2f 100644
> > --- a/kernel/resource.c
> > +++ b/kernel/resource.c
> > @@ -1388,6 +1388,41 @@ void __release_region(struct resource *parent, resource_size_t start,
> >   EXPORT_SYMBOL(__release_region);
> >   #ifdef CONFIG_MEMORY_HOTREMOVE
> > +static void append_child_to_parent(struct resource *new_parent, struct resource *new_child)
> > +{
> > +	struct resource *child;
> > +
> > +	child = new_parent->child;
> > +	if (child) {
> > +		while (child->sibling)
> > +			child = child->sibling;
> > +		child->sibling = new_child;
> 
> Shouldn't we take care of the address ordering here? I guess this works
> because we process them in left-to-right (lowest-to-highest) address.

__request_resource() adds the child resources in the increasing order.
With that, we dont need to check the ordering again here.  True, here we
process the child resources from lowest to highest address.

> > +	} else {
> > +		new_parent->child = new_child;
> > +	}
> > +	new_child->parent = new_parent;
> > +	new_child->sibling = NULL;
> > +}
> > +
> > +static void move_children_to_parent(struct resource *old_parent,
> > +				    struct resource *new_parent,
> > +				    resource_size_t split_addr)
> 
> I'd call this "reparent_child_resources". But actually the function is
> weird. Because you only reparents some resources from old to now.
> 
> Two questions:
> 
> a) Is split_addr really required. Couldn't we derive that from "old_parent"

old_parent->end points to old end range before the split, so I think it
doesnt tell where the split boundary is, until __adjust_resource() is
called. Hence, split_addr was added.

> b) Could we somehow make it clearer (variable names etc) that we are only
> reparenting from "left" to "right" (maybe we can find better names).
> 
> Something like
> 
> /*
>  * Reparent all child resources that no longer belong to "low" after
>  * a split to "high". Note that "high" does not have any children,
>  * because "low" is the adjusted original resource and "high" is a new
>  * resource.
>  */
> static void reparent_children_after_split(struct resource *low,
> 		struct resource *high)

Nice. I will use this convention with split_addr.

> >    *
> >    * Note:
> >    * - Additional release conditions, such as overlapping region, can be
> >    *   supported after they are confirmed as valid cases.
> > - * - When a busy memory resource gets split into two entries, the code
> > - *   assumes that all children remain in the lower address entry for
> > - *   simplicity.  Enhance this logic when necessary.
> > + * - When a busy memory resource gets split into two entries, its children is
> 
> s/is/are/

Will correct it. Thank you

