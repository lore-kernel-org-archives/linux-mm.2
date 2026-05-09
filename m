Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0AEFCD3447
	for <linux-mm@archiver.kernel.org>; Sat,  9 May 2026 15:35:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF9EB6B0005; Sat,  9 May 2026 11:35:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAB316B0088; Sat,  9 May 2026 11:35:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC1E76B008A; Sat,  9 May 2026 11:35:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 99BC66B0005
	for <linux-mm@kvack.org>; Sat,  9 May 2026 11:35:54 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 226B6C080E
	for <linux-mm@kvack.org>; Sat,  9 May 2026 15:35:54 +0000 (UTC)
X-FDA: 84748281828.19.172C362
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7ABD9140008
	for <linux-mm@kvack.org>; Sat,  9 May 2026 15:35:52 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="qgz/kqoo";
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778340952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3aA08lCG2AEm7bSOzMWwhQkfMyFmJh1k8T1IbrjwfZ4=;
	b=aXha0kGNS9wzgNp9GvRaeu3RghL5uFvDQDWKmJBaScBU4iwqk8WwdGPfYssfVRIu+1wpBP
	wdaD46liFpJKyznS4XMVJjn+ZKR2OK7q1UxTPOYq1bm4oDsYhOrC7WeVr9A702vdh+GPbh
	dvWNpQSwG3ys6PLY0PqG0WbigQQ6LYQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="qgz/kqoo";
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778340952; a=rsa-sha256;
	cv=none;
	b=I67cWIv/gt36osW4HJvh9QUDS84o4Pr+72g7Nt6s38i7OzeW85iZ3X38z7IAgodqUtC7BU
	teRmAIpRLNp3FNrvMYZfB+DQuy1PxqmVHjzVZ81ZsxgGYZFPQNYOBFSMIeWYAu1bRRrIRL
	9toCTVknBfy6bqZ15p1Y02hHAou13zM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C623360120;
	Sat,  9 May 2026 15:35:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BDD0C2BCB2;
	Sat,  9 May 2026 15:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778340951;
	bh=tmcnbuw+ugtesj9KcIv3suCuq9QnKOxMSZwtLoJ8dAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qgz/kqooInyVkxq9eY15oPPq4XLR5G5zW8VYI6ZGSoTmnrqdTaPSyZJ14p0atxZrq
	 EtOiHGOBrkRIr0/ooVrD29IrL/JuKC7pcTx0DO/4WFFEkaXJ96O7+cb5/b7PNr5qvv
	 l6sryzBi+VhW17eCpmB20N8ytXKl7wTCE29rgA2Ul6lj+ondjPxWIgG9PF6vTiePNA
	 07sOIM9TG7vDbjwXth3qDO0RJ+2FC9AjAvCncgiOclv7f70YwMEISkxUGxbA8khmDz
	 QIo1td8ZSmX42qJ6xaNfMKYjOF5MQQvdv8jWc2eefQKM7LEmDslfQAuC8TNE2UdN8j
	 cOVr8fnKBBm8Q==
From: SeongJae Park <sj@kernel.org>
To: "zhen.ni" <zhen.ni@easystack.cn>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/3] mm/page_owner: add NUMA node filter with nodelist support
Date: Sat,  9 May 2026 08:35:45 -0700
Message-ID: <20260509153547.89036-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <9ebddab1-b7b4-462e-a920-f850cc5c55c5@easystack.cn>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: os81sczkw56a3ykd8ufcfdq8en7peah4
X-Rspamd-Queue-Id: 7ABD9140008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778340952-75131
X-HE-Meta: U2FsdGVkX18QzLHf9c1YN6uY10gYcSMCkTYdKDulv30g9O0/8fyXjenkk+mcaEJUgtnBnlqn9dowx870JsIgzq9LYPaTYCYoAZ/7CUmm24JD7Gh/4APFFF9kVaOz6qllioJqe2+xxcxuqFr/+OfDH5RUeh0uYREA6Zd9TVjuDSii+x0OO4H7X1VLj4iUrbW94gqZbLjuTCUEk3C7ciV4Lg52cCGZqous/3A63WXEHXtUFiz6TzV/PCJmvKHt32jO+6Eguge1dN8qpNgCsKO8FNV3diutg2IgUEdZD2p7tENtmZx+WLFBsnON4tCwR9uAaQNybzEbrp/eimiPNYXTQJDO/HLwEUbLW5Kgxph+RgDjDnGHDyLVrRPgByLB0mg7fMgDpKkV4LVIVtJ5h7NusMsrTulAFsrvF3xkpAOL/niFSOkLWwUR8h5jN3oe3KRykZ1o7WXbn3ve+eC6fzAYWsnWHhMTSQpQOQeRr65LkwAI3NsN0JBALPZUeT46BjXuiU2N7xAxSkIRHuGc3DO6uUOTLy9dAYzOyt1iKtIkND4N031W1cchJFVDCiNwDtCFSNPUuPNaWBAuia9Ntua7gv4Fn1pnFLCmOrgqpxt08A93PblmVIF1Dh1DXAj0gdaGvcTzBH/SYqlMpJUHONbxT2B2ejzCn9GgzCEjm3c3gnMqyg02DU3/ydCC49Rk0Hs/QRpWGzT/3047++gorrCp1yY4YnFHk4dnE+hAXOb4uBxArKCnY4o6nukEzoPlGKNmSqoQGIZIVGq1O2TlWDZO5BdCJJPPsLt+cUMXg/gHMd4HbeKmCVk1fmDm2TsYuzvWs4ZT0a43hN9zxJNiwdBq9hygBMW16bPfGJ5PD1yMgXQY05k7u6kjjA493uwBsfegv+82XtcWOcP7DCRHL2NEF8fg7YDZ1RR+tSh9abyII1V7pBVHUuiXZz98/nxQUE+dH0NsExel4Ns6Cua+6zX
 A15Ykjmj
 hO48PC48WlAV919iYRFYhAI2pxRUkmtm0P7MVOmo1OiMlrgakmZOxsY2zf2HnjuxgmGr8+xqHzhhD80NvM/zDWmxTMKhLliHKjc6gOAV+GSKHXY51ejgGJX88EQxjs8Xt88+mrsR7J6o5G4GbxgzmSEGOfTL+KD2vgTVycbZCgApgYGi4qP8jcdmIbXsld+QKnWcXC3uKyarjtWRr6jeD4qN6O83bVirpyLS4aQAAvFzoBu5WudTIz98hK1jwhEApukTfp7RMLckCJeHDsZMbbrszNz/9Lvn2wHD/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 9 May 2026 15:27:22 +0800 "zhen.ni" <zhen.ni@easystack.cn> wrote:

> 
> 
> 在 2026/5/9 08:44, SeongJae Park 写道:
> > On Thu,  7 May 2026 14:46:42 +0800 Zhen Ni <zhen.ni@easystack.cn> wrote:
[...]
> >> +static ssize_t nid_filter_write(struct file *file,
> >> +				 const char __user *buf,
> >> +				 size_t count, loff_t *ppos)
> >> +{
> >> +	char *kbuf;
> >> +	nodemask_t mask;
> >> +	int ret;
> >> +
> >> +	/*
> >> +	 * Limit input size to handle worst-case nodelist (all nodes).
> >> +	 * Worst case per node: ",NNNNN" (comma + 5-digit node number) = 6 bytes.
> >> +	 * Formula: 100 bytes overhead + 6 * MAX_NUMNODES
> > 
> > What is the 100 bytes overhead?
> 
> The 100 bytes is intended as a safety margin, but it's not strictly 
> necessary.
> Maybe I should simplify it to just 6 * MAX_NUMNODES?

I wouldn't mind keep having 100 bytes, but I'd suggest to clearly document the
intention if you will do so.  But if you also don't think it is necessary, I'm
also up to just removing it.

> > 
> >> +	 */
> >> +	if (count > (100 + 6 * MAX_NUMNODES))
> >> +		return -EINVAL;
> >> +
> >> +	kbuf = kmalloc(count + 1, GFP_KERNEL);
> >> +	if (!kbuf)
> >> +		return -ENOMEM;
> > 
> > Would it make sense to use kmalloc_objs()?
> 
> I'll update the code to use
> kmalloc_objs(char, count + 1, GFP_KERNEL)

kmalloc_objs() use GFP_KERNEL by default.  It can also understand the type of
the ojbect.  So you could kmalloc_objs(*kbuf, count + 1).

> 
> Thanks for the review!

I'm happy to help! :)


Thanks,
SJ

[...]

