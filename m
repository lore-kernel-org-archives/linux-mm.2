Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4323EC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 14:52:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47F9E6B0099; Wed,  2 Sep 2026 10:52:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43E616B00A2; Wed,  2 Sep 2026 10:52:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32E5C6B00A3; Wed,  2 Sep 2026 10:52:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 07C286B0099
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:52:50 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9584DC0200
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:52:50 +0000 (UTC)
X-FDA: 85169114100.09.744A49F
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf18.hostedemail.com (Postfix) with ESMTP id BE1791C0009
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:52:48 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=JBE23ZtY;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788360768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nA5nu0+O7KB9P/Xs27S/xlgEyjuqVVZbaW6JykZXG08=;
	b=5Ebb0gtkxER+j3bqo2cWZL2ZHi7WIeSWJNFYMblnW5qjSfA9G09ra2oNcb8e6PPnF1dtgC
	yPlkY5IVUuqtW37EP0hibrIAKHvdCuDjgyyAlmZAD3ksyN4pD0WKRO2fH8szga2jsss1Sf
	vhz+ED37z/eomUBL5KXBud2IhDy12tc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=JBE23ZtY;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788360768;
	b=BWBvy334LrvgZdTM2LRGcxrBNbhNupaYSjG7IviCMKeuXPaY9Zn+fTnmJzw5Qw5XdMGIq1
	5ZCuuVltivMo+pxNRjC9UfPL8olVorwWRt0WSUQMJCRdTOkWyEyt2YwTvK9Zmfs98GpUK6
	SsHQpNUeVxqDm3HqC9IkgLBprHWtmH0=
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-9387752a4d0so102998585a.2
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 07:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1788360768; x=1788965568; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nA5nu0+O7KB9P/Xs27S/xlgEyjuqVVZbaW6JykZXG08=;
        b=JBE23ZtY+RaWK8Dezcbpmyk9a49fEf33Kd5jbuJjLKQHHPd7ewk2DA0JSD4rPQ0ssO
         TNWEDGDfrlWJHcK7Bao++QifbZxXkaoAu+DoJeuZrevxopcUGr/RVbH42i0xkvEHzu/T
         xi0ZUSvZsQGldyRHIrrGRGYya1SNyo7JRljZf2hKbpdcsuVvZAYML2AiEZqXQ3A7PT6U
         jFsQqhJkuX87tKKeb8ahcwilONh1f2DlmRXTTNCOYZ85/Q3XRw0bLzsruN53bOGbZ/YG
         iWvrAkuBilDsY7VA+sdsyleLqwn48fVOcfmwDrpWyE2qaxYM2wLns/0HYCNQtpiaAx7H
         aLRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788360768; x=1788965568;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nA5nu0+O7KB9P/Xs27S/xlgEyjuqVVZbaW6JykZXG08=;
        b=iSUSxz+kpFNel6eNY4tFxNsnvuDfvR3ckbfxelx5CfwQ1h+nnPu0KCGlx5vSAlegHi
         u1GIK15NuPebhEQSS+RhB87MBZFkcqX80ht0QPb3XTS+cDzQa5wtY+28Qpvt4J5nXy2B
         N3abqyQsn/tPr70DkwLQ/xW8DgRL/A7KcGwTeinFeKM5TEaiSXYwH3G9D+Ay4ZXJyAq5
         OoBBZ65NRH8DuN2ZDeJkrhHUgRVVlMlPHfXi9vCvCKQXXRzFjlWU5TuEOwD/0KKQkNhS
         EzYUCMGakFs/kCJjEeXAioHqQJS5/AOPWdpLHbB8zgjRJf9CmR5dtWsD17t1FhuSpAQR
         fpIg==
X-Forwarded-Encrypted: i=1; AHgh+RpBA+2WliSVdbAYckweAds0hzb73INg81hkj7BUjCoMXQHr08S714yYVHM2r313jONY5p7G1jVX1g==@kvack.org
X-Gm-Message-State: AFuF++ktuO5hmqZBQAmO63KqoW3pnH87e4clBNQd2MJlJPS4pIJsTiAE
	AbtIW/5Iz2Aj39l2FgVxkeVbT5XEdA+oCM+bkFf54hEMIl9KoSysCntFf6IO3tjeXd8=
X-Gm-Gg: AR+sD13u6FMMoWwROnp4CDVBacAWQhO3RdfXxbrLlQ/QFjB/809R43NUyg3W3/HGNrv
	opRTjR+7y1MXwNh96AJfiukfY3cp7HDh4NiYCmjtScQg4bngSW/+tSELtEwSP+HqixvB5zq6bDJ
	7o501JfdmQZe3Nq+mwebFc6B8xHf0Ulj/VDzfuFD+/ZoM4Zbl3ERzxpcjP/2Vbx4ZKq5Gaky460
	8GTCPfh/hdPaIjWihHvcVyJ8mUo1W08g3SfB+XGFF5yultMtN5aUUW+aZ5lP6I7S+YCPWErrPRo
	73XnTP/wjuc/sswQHMCAGWwhq8g0JLAaZRFzwMRbkBYfhM4ua0GFYnHO8xOVCljyPdzeUhsPaYi
	qdLZc9Xr4/LsHvbzB7RYgNsN1/pNCVLdA2Rmg9Sv8dzZ3yqIoVgyRt6WAfWLjahf42bGX/0nXvx
	vCrB8QnrGhiJ2bF+46QJxVx8rwiQlrVo2f5f19vbK3CBZqihQpw08KwqRlYGu4RHpvV6TfbLkE4
	44zO0Vl46nMRZAGc9G+/E/hFPU82zMwTvy7GV6pHe+8
X-Received: by 2002:a05:620a:294b:b0:934:9524:2e89 with SMTP id af79cd13be357-93960dd6f3amr562266385a.13.1788360767786;
        Wed, 02 Sep 2026 07:52:47 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9395f35fb95sm220613785a.23.2026.09.02.07.52.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 07:52:47 -0700 (PDT)
Date: Wed, 2 Sep 2026 10:52:45 -0400
From: Gregory Price <gourry@gourry.net>
To: Rakie Kim <rakie.kim@sk.com>
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, matthew.brost@intel.com, 
	joshua.hahnjy@gmail.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, urezki@gmail.com, chenwandun@huawei.com, linux-mm@kvack.org, 
	kernel_team@skhynix.com
Subject: Re: [PATCH 2/2] mm/mempolicy: stop copying the nodemask in the
 interleave paths
Message-ID: <apgzMZQPTxS9QtDy@gourry-fedora-PF4VCD3F>
References: <20260829015943.1258774-3-gourry@gourry.net>
 <20260902090047.1944-1-rakie.kim@sk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902090047.1944-1-rakie.kim@sk.com>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 5s7qbhthryo48syr7xcfibgwwko8aibr
X-Rspamd-Queue-Id: BE1791C0009
X-HE-Tag: 1788360768-682458
X-HE-Meta: U2FsdGVkX18In/h5k4LhXDGj+ayJnyBiu/56Tr4DaKCFzOEs1I3knsBsKeOnASpFM49zcp8YLmA0271mMjaElQSDFh3mrfkuS54V4E83x3QXcdTCIa+avECu16wLP4Lae8/giJXABgfU7RgOUqqH7PJbovE3DXBalD/w3OcNyk7i9/tv0sbzvzFGxnJk1FvB9uxXPHBpx49W8/Zsn8x3XxfxLnnKeamy5jZKJg/GfbDZn5zQJY5D5DozMhHIzd9x0L0uPPTl3DvWfH+YDh06ElZRhlgXsR77BVIltPss510RCtM5JvXXI4FSRiQbj40MvtQHTnoa5PvX88vU62D658G7jboiZiA4npLJK3SBH0rIzAHQ6l9Rixx9tjUyFZELJI4PNaKYHNa/84m9RomOjNXocgzHqXLVMFx12vwgAnRgwbUtsV+Hh7FqoKbPLUCJg41vU/315EHgpVKlmLf3xKK0Z/gIEc+0+ggD1uDYQCG1g7vPriVM/VCckgpCUgDr436WGKP6nnBEyvK0mAjRmR1E98gMIZ/jvRfaT+96lqRNmWOob3WTr9yWhyJdyID6hVIDnQO4kFDeciQXGkBbT9nXBwDYGsm2FjYyNUyfZx4XZJ4u+cj0MToz43E+AZb+hdxDX0qLBvFXxWwej+0IvtIXB1kAbKXJ3zl6P1uBkfNMD0HMzCC95JCBIa1nbvuLfxvOk66eTeotNYeMXR+n0180kq1m/+jqWODA0QGiEdyC/r/wNuB5lMwqRd4pu3e49/3XaMJ0sLmbJRzeKdAEkw4fEW6vXXAEFb18q6VHkm5AhIjTYVXrXKShTHTj9T0uIDmx80dlPsmAn0IfLM8/VBOXUqeftRM0X434JW3lzAFbkWQZHElFUeFpkWlEuMj9SkgU/ajQvom8I9Isgq5+zWCBURbzz52D4uRKipPeZouKc34RbA47l3X34+HLwuYmNzkbaLquO8xIVSrK2jY
 vrT7i6yS
 jR1uZOYIm5xgNQ+O93bb7AX0/T22twyKhhUUepw5ky2DprfqaH4pVBt4P6S4yg6gxNDXwAQxTfu/+KuPKwm0do+WSNyyENsnJan9qgCqz+k60aJstB8sDqudmOYxb6gIqwLH1MiiefAEzFQUHCyzobezrMhiTw1ku/WxJRuez/iC9MWpbNaPB2PZ8Bkp1yg7TWzQqpZlZCZv0is/LsoX3aJap+F69lFmVDc6qgElaLi5MSqa2uZQir+6NV6/cgkyJqyayL/ADekbhGYHjWFf7IRTUsMpdworLk1x9pWmN+RsZMM7/SXjvr/OD8ERdofj9TrttCPfUpSUjVVzc70C4vobY02hCR1dmy9LHdKGiZ20LXvmRxTm9tOhUqT/XuxQe62FwAClWftRZtTpYxK21TegfVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 06:00:44PM +0900, Rakie Kim wrote:
> 
> > @@ -2712,9 +2713,13 @@ static unsigned long alloc_pages_bulk_weighted_interleave(gfp_t gfp,
> >  	table = state ? state->iw_table : NULL;
> >
> >  	/* calculate total, detect system default usage */
> > -	for_each_node_mask(node, nodes)
> > +	for_each_node_mask(node, pol->nodes)
> >  		weight_total += table ? table[node] : 1;
> 
> I have a minor comment on this part. After this change, everything
> else reads pol->nodes fresh at the point of use - the weight sum
> and the walk both look at the current mask. Only nnodes is still
> the count from this earlier read. If the mask changes in between,
> the loop bound no longer matches the mask the loop is actually
> walking, so the walk can stop short of the pages the weight total
> planned for. Would it be better to count the nodes in the loop
> that sums the weights, the way weighted_interleave_nid() does it
> in this patch?
>

I don't think this actually fixes anything?

But basically the proposal is to widen the SRCU() window further to
include the cpuset cookie entirely.

e.g.

SRCU() {
	cpuset_cookie() {
		for_each_node_mask(node, pol->nodes)
			weight_total += ...
			nnodes++;
	}

	/* ... snip - single node quick-exit ... */

        /* ... actual multi-node bulk allocation ... */
	for_each_node_mask(node, pol->nodes) {
		nr_allocated = __alloc_pages_bulk(gfp, node, ...);

		/*
                 * At this point, due to a torn read from pol->nodes
		 * we can visit a node that wasn't present previously
		 * or we can skip a node that was present previously.
		 *
		 * In either case, weight_total is the wrong value for
		 * the set of nodes being walked anyway - we are going
		 * to skew in the distribution no matter what.
		 */
	}
}

I'm not sure widening the SRCU window is worth it here, it doesn't
actually buy us anything.

Also we'd be calculating the weight total every time even when there's a
scenario where we quick-exit because the entire allocation fits in the
first node in the mask.

> 	nnodes = 0;
> 	for_each_node_mask(node, pol->nodes) {
> 		weight_total += table ? table[node] : 1;
> 		nnodes++;
> 	}
> 
> [...snip...]
> 
> Thanks again for your time.
> 
> Rakie Kim

