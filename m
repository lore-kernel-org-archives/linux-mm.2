Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A06B2C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 08:57:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8074A6B009B; Mon,  7 Sep 2026 04:57:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 791716B009D; Mon,  7 Sep 2026 04:57:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 659AD6B009E; Mon,  7 Sep 2026 04:57:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 40B926B009B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 04:57:40 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BBA0E1C267A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:57:39 +0000 (UTC)
X-FDA: 85186363038.07.B1D5A68
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2A69C40003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:57:36 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf17.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788771458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yLPlgRitmnrmrShi+KqauQutewL8glVGaymjjfAzXm4=;
	b=FV0EcC01MiKpX7mh0tvcgWQCX22n+77yNv1wAMm1hqAf1dK8MNRTTV4tXiN//WStXjy9Mf
	G//seCZlQ7mmDxiajz8UaSJsIofbyNZJ0E3fm1pC4tqP68t8BEcS6wC7Tc23CGbF7rLqq+
	S9DUyphB3pkeiQsBQijyiqG/OZBTF9o=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf17.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788771458;
	b=QA1KRjH5ZrJtzGxydZqLp5DJzPKAwhorC8xEtZ0bgcT9mxpHKSvcRU23zACLmRXIpLWE74
	xd3lohQMDtZSyo2rR2bgYUbfS3aIgX3Of8hSByUiViXqAfVp4q5JZC4S12EvyQkASLoflQ
	6rjZiz7x2xqOlua+EjQiPZK+9JAbdCw=
X-AuditID: a67dfc5b-c2dff70000001609-0f-6a9e7c7c9731
From: Rakie Kim <rakie.kim@sk.com>
To: Gregory Price <gourry@gourry.net>
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	byungchul@sk.com,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	urezki@gmail.com,
	chenwandun@huawei.com,
	linux-mm@kvack.org,
	kernel_team@skhynix.com,
	Rakie Kim <rakie.kim@sk.com>
Subject: Re: [PATCH 2/2] mm/mempolicy: stop copying the nodemask in the interleave paths
Date: Mon,  7 Sep 2026 17:57:27 +0900
Message-ID: <20260907085730.2009-1-rakie.kim@sk.com>
X-Mailer: git-send-email 2.52.0.windows.1
In-Reply-To: <aprm5dwF_kWaOe44@gourry-fedora-PF4VCD3F>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCLMWRmVeSWpSXmKPExsXC9ZZnkW5NzbwsgzmrtCzmrF/DZrHrRojF
	l3ermCyeb/3FaPHz7nF2i+Nb57Fb7LsIlLy8aw6bxb01/1ktvvVJW6y+yGKxek2Gxeyj99gd
	eD12zrrL7tHddpndo+XIW1aPxXteMnlsWtXJ5rHp0yR2jxMzfrN47Hxo6XHuYoVHb/M7No/P
	m+QCuKO4bFJSczLLUov07RK4MpYfvMta8JG/4sXzY8wNjE08XYycHBICJhLHt51ghLFfT33C
	3sXIwcEmoCRxbG8MiCkioCrRdsUdpIJZ4CeTxKoZeiC2sECExK/tfSwgNgtQyZ6PG5hBbF6g
	KY/u34OaqCmxbuMtsBpOATOJJT8Ws4LYQgI8Eq827GeEqBeUODnzCQvEfHmJ5q2zgeZwAfV+
	Z5Nobb3JBjFIUuLgihssExj5ZyHpmYWkZwEj0ypGocy8stzEzBwTvYzKvMwKveT83E2MwLhY
	VvsnegfjpwvBhxgFOBiVeHgvyM7IEmJNLCuuzD3EKMHBrCTC+3rq7Cwh3pTEyqrUovz4otKc
	1OJDjNIcLErivEbfylOEBNITS1KzU1MLUotgskwcnFINjIY5ny8Iv7llE1j1s9/lnKG2hMSN
	fonDHxyy2L7XnU90cn+8e2n1y3ss2mdKJBhtWhJD99dPKDrdv+LDxyPqkYcuvA35Gbf+5yzr
	aLG0t6IhH3+csyjYJ3jWTanFrF6uZbWU6nzLndMk1ac7vzpls8WPwcVKSGLDu49azv1Xlunz
	rr65h/1zlRJLcUaioRZzUXEiAA0wCWuHAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJLMWRmVeSWpSXmKPExsXCNUM9RremZl6Wwb/FMhZz1q9hs9h1I8Ti
	3JTZbBZf3q1isni+9Rejxc+7x9ktjm+dx26x7yJQxeG5J1ktLu+aw2Zxb81/VotvfdIWh649
	Z7VYfZHFYvWaDIvZR++xOwh47Jx1l92ju+0yu0fLkbesHov3vGTy2LSqk81j06dJ7B4nZvxm
	8dj50NLj3MUKj97md2we3257eCx+8YHJ4/MmuQDeKC6blNSczLLUIn27BK6M5QfvshZ85K94
	8fwYcwNjE08XIyeHhICJxOupT9i7GDk42ASUJI7tjQExRQRUJdquuINUMAv8ZJJYNUMPxBYW
	iJD4tb2PBcRmASrZ83EDM4jNCzTl0f17jBATNSXWbbwFVsMpYCax5MdiVhBbSIBH4tWG/YwQ
	9YISJ2c+YYGYLy/RvHU28wRGnllIUrOQpBYwMq1iFMnMK8tNzMwx1SvOzqjMy6zQS87P3cQI
	jIBltX8m7mD8ctn9EKMAB6MSD28B/9wsIdbEsuLK3EOMEhzMSiK8r6fOzhLiTUmsrEotyo8v
	Ks1JLT7EKM3BoiTO6xWemiAkkJ5YkpqdmlqQWgSTZeLglGpg7Ba+/n/imXWde/3M0tT1ehjb
	Pn2Ycdnsb568xoqCS1kBDeHGBzaX+uezW/A/5xVdVDYnJFOtInP+yycHl2s7zVqjqTJVItd1
	5Z6PJWvFy6rDmr/tXcbp9LFMP0DlUHGS/LazptOaDqYuDPTvWnn6LFeWaXprR/fkIwd7Vqxi
	Odxw+r+SpOY3JZbijERDLeai4kQAyw3lVHwCAAA=
X-CFilter-Loop: Reflected
X-Stat-Signature: b6mp3x7xnshnwi4zhom444ha49ik8cig
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2A69C40003
X-Rspam-User: 
X-HE-Tag: 1788771456-296180
X-HE-Meta: U2FsdGVkX18fQtQbkY4T5jmOdd+gBJwuMP2JKiJNenjgrX7gvFG5AFjSU+G/V5LoTtXaq30HF1q53I6ZisqqW6HksWqBIDGzVCYOlMrLzlhL9c48V79eYlZQoDmaOLAyWfR7k7ybEmLYWgmy06qt29zf4DI+z3OzpFjKoY5FeRui/+UL96WPAVCF+POJ2Q3hbON0ZDxEh1fH+CXNFb3ikFQv0bH5WO1HJp8RzNW+2uj7nmDhcsr5JKa6d2Lof/WIaqHWFGXVXniOVIQxQ12hBP+oRm5RGMtBG8uaSVgoJKRfrHnC3bTH7Cm2jdiSYNuLNNjOaKbARCJguxl5geo0ADxNfEdsKX/r/mdpBAhh2yNElrQ3K8+3r0Mz/Vj4cGPqL2TQB3DHHdeiVGundEzRyc7Wogt71aRcGl95OMTv4iy4cKkDpOwVXqamPq8pLu66xxrdSM1UwxkDwyh8DqBh2gnUA34m6D0AFT9mz2+2N5GIoIz0x5M7Ht0gt8yln6zm6qrjSCNDjgzNRBCOoNYoznof+8Pxehnr7MGg+YynOoywkLBoYBHQnz/DiaJg8WL8UQj1CjfyQ0mQupIV3mppZDfrqpIfDI2LRAWCPAhMj6vzLTOE0Ac3owNnu0Ot9hux0Rzz+sWXlwfLfdp9sLHe2vJ6wMqHHkEd2YkE6jDjxxv9iVk44p1sA33gTG5zCLyl4HmJAXVjDzAqxmqPEDt/XdSrn671+2g7Ny+7IOL52NTStnv3PjgSiriGX6qeu3GOBCgFC6zOO8N5NYTMldtn8/E2rLl05pmS/E7xVu3SysWMmctXWQfCaBJ0+DaDsG6ZFLoSWeyhCam5WitINK7JuF77wcfu6P3MTMApzDbQnegyQrnGFcwo/L6KM6Q9rq9S/GwxD5jAPZMXhPPOpL0yFEuI9tW0wUyt6pIQbAytKgZXBDPyt0+b0DRFLrX9liya9AWzLz+pBrEror/lfgq
 9Id9mUdp
 csXP9cn0wBbWRCYSbSTpf2wAoR0k/jDn8DSb66/iOvBXO6+hBBk1Nl9B5qfkxlT6yLKhc4tnnDlEzrZLz72ql81wFIRtlXYCpjV/gA8tLWLqYrc8/gTIuAtQuZi1txtY7xVDRuLU9ydNsNvBTG4/tu5DlaoM3XBPHn0E5/twrxM9XfTQy07DmxRBmxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 4 Sep 2026 11:50:47 -0400 Gregory Price <gourry@gourry.net> wrote:

> On Fri, Sep 04, 2026 at 05:01:37PM +0900, Rakie Kim wrote:
> >
> > What I had in mind is the gap between the two reads. Say the policy
> > starts with two nodes, every weight is 10, and 100 pages are
> > requested:
> >
> > 	/* the mask is {0,1} here */
> > 	do {
> > 		cpuset_mems_cookie = read_mems_allowed_begin();
> > 		nnodes = nodes_weight(pol->nodes);	/* nnodes = 2 */
> > 	} while (read_mems_allowed_retry(cpuset_mems_cookie));
> >
> > 	/* a rebind grows the mask to {0,1,2,3} at this point */
> >
> > 	/* calculate total, detect system default usage */
> > 	for_each_node_mask(node, pol->nodes)
> > 		weight_total += ...;			/* 10 * 4 = 40 */
> >
> > 	rounds = rem_pages / weight_total;		/* 100 / 40 = 2 */
> >
> > 	for (i = 0; i < nnodes; i++)			/* bounded by 2 */
> > 		...
> >
>
> Consider:
>
> 	/* nodemask: {0,1} */
>  	for_each_node_mask(node, pol->nodes) {
>  		weight_total += ...;
> 		nnodes++;
> 	}
>
>  	/* a rebind grows the mask to {2,3,4,5} */
>
>  	rounds = rem_pages / weight_total;		/* 100 / 10 = 10 */
>  	for (i = 0; i < nnodes; i++)			/* bounded by 2 */
>  		...
>
> in this scenario every value is wrong.  The weight total was calculated
> based on {0,1} and the loop will use {2,3} weights and ignore {4,5}
> entirely.
>
> It's the nature of the mechanism and race - best we can do is ensure
> safety.  Ensuring correct distributions would likely require locks or
> reworking the entire weight mechanism.
>
> I'd rather keep the change simple (cookie the value that can cause a
> div/0) and leave the math alone.
>
> ~Gregory

Fair enough. Your example makes the point. The mask can change after
the sum as well, so matching the two reads does not get us a correct
distribution either. Keeping it simple sounds right to me.

Please feel free to add the following to this patch:
Reviewed-by: Rakie Kim <rakie.kim@sk.com>

Thanks for walking through it.

Rakie Kim

