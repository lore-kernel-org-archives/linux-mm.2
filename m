Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7413DFED2CC
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 05:02:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABACF6B0088; Thu, 12 Mar 2026 01:02:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A653B6B0089; Thu, 12 Mar 2026 01:02:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 967476B008A; Thu, 12 Mar 2026 01:02:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 847C06B0088
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 01:02:23 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CBDFA1B8903
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 04:52:23 +0000 (UTC)
X-FDA: 84536189766.17.4D3D04A
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf02.hostedemail.com (Postfix) with ESMTP id 158B780003
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 04:52:21 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OQ2iCeVk;
	spf=pass (imf02.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773291142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E1vWEw3aH1CU/V80MgU5PIVsH7624L5NRdF0t/zNwCE=;
	b=R0TSjTUnOvYEaVwba+xHk82pEc2j60122bYZ6WQjLDdEd9idpgo/1afshWJv+XqrKTrFYt
	ejMxjHb12ZU1NIKsP6NEZksGDBl/RSiiU4qzE1PWFLh+WQpvK9LTmdCTnbhGe+0qMeE3PG
	zKez1pG9PtQ8RDdnTaenkZtDx74iOBw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773291142; a=rsa-sha256;
	cv=none;
	b=GaRLxNSrbM167YXqiAyGQ5MEtaWzlR/FxSNmNrgW9wzwTuf29YO5EwsQ5vxWzVX/yjr69t
	NKxoNHirtK8pFnUC/+yPRrOBub4Y1HDYqDMzPAiHG5zvdTAf1qIxBvqKEF+d3k3D8stp0q
	F28H0eoOYIHqUUEWICXMwL1JMj3ow8I=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OQ2iCeVk;
	spf=pass (imf02.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Thu, 12 Mar 2026 12:51:59 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773291138;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=E1vWEw3aH1CU/V80MgU5PIVsH7624L5NRdF0t/zNwCE=;
	b=OQ2iCeVkcObGvWsFlZrLLWqXGLrueqRqnqST3DkGLlPUTbR28argcKL/7ZMCyXjWa+ewy4
	nDOzOsJyA6pckkiIAGSTEyM0OzkCofsKGQMODrP7yx3CgAo/wNn0c1PnVEm8YKCnzUJh6v
	uvQSkGZAyVu1i2F5S4Co2G0/LWSWIjI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Qing Wang <wangqing7171@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: remove alloc_full_sheaf()
Message-ID: <7wlszh36sgr5skju2t3isdh5oglycxdc4ibilzsr3gfpgdlpit@6wyoxzrcvcq3>
References: <20260311-b4-slab-remove-alloc_full_sheaf-v1-1-c4c5bb587ae5@kernel.org>
 <abJCu71plqm4t0i_@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abJCu71plqm4t0i_@hyeyoo>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 1nyt78iminijg66x39camktqpc457qa4
X-Rspam-User: 
X-Rspamd-Queue-Id: 158B780003
X-Rspamd-Server: rspam12
X-HE-Tag: 1773291141-359239
X-HE-Meta: U2FsdGVkX1+DFUVL9lXDQgehQP/h2siQVfgUQNA2ElxuTMjZndctQK7immcgcvnApoOUzabETgfbST18cTYFCeuu2DGzg0N4ge8bdF8arucYUR5qVoF84WJiXancpvw9qLT/1glVZBzsNYKAPo1qHb278RniEQqa8r9YP5+Xt0R3mWzEmTqmEK/zzUQS/8IUy09JSbdzKXe7arMkA6/BRu/Sa76YlHcKthscaTinVdZhiodnBL6ZYws669hgfzJhALOpYlSfkLg24XC4nNlySqB0TxhOy6M20wLmYMYZlm+Ed8OoNBx9IWc59+tbWfKC/EMwyL+FzlMp4n/G022wCfQhQjSTh8qVE7CtQK+EiW1lKvrzEDRwMRu4yV9ysLYO74X/+hsesDq6bTixOtxomzOHWGQTMlbM6C2PhuxEXGJNkn3l97gUvlRHAa9o7mfK8cY5HVCbuhqETk3kDOYOZfFAN5jeA0UIWDE6zmDPhEG0zE5xBIhNdXyIlrXEHdKGm91+KPxIYwFUHMWsKisBhVBLL7uSwnhaCxBkxHuB6sIQoFzvqYJqjaswz3eagRwB+GNdMpwWFN4nYi35BItrangLA/3hFPQJg1/6Aljci42qzt/PCW2mzk9xVovTbNKdhTYWsMhuCbcwGRx/jWTen50RgXZdbWnen+sjlDvnTghhHKn1xsfGv6ii/IElfSHNoJ1i6EGoKmhYZ6FaZCrcOszItH1s+I5GNC51LkcTziu12dQGDO7XgaXdzGGPDt1r38dNc+mStY/pgjo85K0GjuEDq6p4bqLMoZbFmYXvtXjO33HkgHUiW6e00O3N/KXjPLKUQTJ9XGMjRdnJ/jw0VgCTQAIU3Cod+DiEN0DPgOr63r3W+jD8oWL8aedy3DxeHu4HX6TFcmms9speV4gkYBYt7A2qWWSi16FwMGpVG1cADyVF9YDopjZ/zgxrV3jumThrD2/BTfnUzGRp3vP
 bt+OEv+s
 a2cBFzNMbEy3t36iuQX2t7w+OUyl1H9n8ChaLEZFT7uDgjoQO+PQ74qgjXM4XP95cTondxhr+umDLEHEMZnZb3iVq2VefoEDfkMdPNJF7DTVNI2QvZ8Cj2tAj2+R0mJsMcISi5tli4RE+oot7k8XEmFMKFyb1w6x8gWWarWRW6S9/ZCWE6VtNnZFdU1hWJGjsB4xnq5WW5wxw5hMPy7+iALyAD+2ODPcQVycxYVM8om+j9tlJ+BM7WQmUAIr4iYW2iLHepBG1AfjN8HlRcFycBn1Lfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 12, 2026 at 01:36:11PM +0900, Harry Yoo wrote:
> On Wed, Mar 11, 2026 at 07:22:33PM +0100, Vlastimil Babka (SUSE) wrote:
> > The function allocates and then refills and empty sheaf. It's only
> 
> nit:					 ^an empty sheaf?
> 
> > called from __pcs_replace_empty_main(), which can also in some cases
> > refill an empty sheaf. We can therefore consolidate this code.
> > 
> > Remove alloc_full_sheaf() and refactor __pcs_replace_empty_main() so it
> > will call alloc_empty_sheaf() when necessary, and then use the
> > pre-existing refill_sheaf(). The result should be simpler to follow and
> > less duplicated code.
> > 
> > Also adjust the comment about returning sheaves to barn, the part about
> > where the empty sheaf we'd be returning comes from is incorrect.
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> > ---
> 
> Nice cleanup!

Indeed!
Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

