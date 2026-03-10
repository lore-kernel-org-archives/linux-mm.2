Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4639FD4F31
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 19:48:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA57A6B0088; Tue, 10 Mar 2026 15:48:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4FB06B0089; Tue, 10 Mar 2026 15:48:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3AA16B008A; Tue, 10 Mar 2026 15:48:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A14246B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 15:48:54 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 56320C1673
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 19:48:54 +0000 (UTC)
X-FDA: 84531191388.09.2D6C028
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id BBFED10000B
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 19:48:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q5Wn9Npb;
	spf=pass (imf14.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773172132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i3F4iPePtn1x4aGt97CquFRyDRkp5+os6WjBiJPsrJY=;
	b=VR8mYaLpnQOKc3NmtIJ25a3Es8egQhWYKimCXpJNHaXW6sfm8h8yMNRjgSr+o+nQXpelf8
	oAKkkhLgF4JUGk1nORIsoKNIqwao9yF1+8oNZTvzUGP6gFtLuA9Ks3v+FcRuuJi7va+Crx
	mTeU71VkknBcE9bYkJOAYgwC+yWincw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q5Wn9Npb;
	spf=pass (imf14.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773172132; a=rsa-sha256;
	cv=none;
	b=UZqa7WUzaben+u6ajBxywveNtkoq1gj/zZ2RCEK3igky2K7ryuClAb6ro+SQNP+q+swWO2
	Z3ZNSg1LwQk2xckFZnVQs0kqqSXp0v9HG/etb8j9KwpxJ2R8eH2yrKrBCRF14D/D5gz36V
	DqWgjPxwnztBIkyC9dFu6JnQZ75s0Ug=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DA9D260054;
	Tue, 10 Mar 2026 19:48:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71781C19423;
	Tue, 10 Mar 2026 19:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773172131;
	bh=8RDQfE2xP1BWgVgje31aWjZMSOyhfmFEXWA2AkWRkvs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q5Wn9Npb6xtJVj5PVvDE2FjOPMVFmtv4Vy3sXQJK5oNzQiA2ouG7R5fG9SL9DMrAp
	 PoqTKHzKkywF0Xwocplj3jIsERUmRwrdrydepr/3LMPmYkRJKhNHq12jkfTzkEzTBY
	 sFijpy7ArNS7UKJFrdhZMjqdRnIYMLmh3Y/t23ko1SUWu5uTDkrXiscuYrXfJYT2Yw
	 rHNUGcWQcF99+X8AxkhOSPAb/bCV7EBaGnnVNQi2ilxIkkvbBrYnumiYnY5XNmJbub
	 08TzHLTX+6olTVPLxJtwXYbI93zCHxCFuTlW3koXJDDWo0QxgxefjQ0Pn3/uqViOti
	 l2tK8oGni0qHw==
Date: Tue, 10 Mar 2026 09:48:50 -1000
From: Tejun Heo <tj@kernel.org>
To: Ben Greear <greearb@candelatech.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Miriam Rachel <miriam.rachel.korenblit@intel.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: 6.18.13 iwlwifi deadlock allocating cma while work-item is
 active.
Message-ID: <abB1oq9c97RD_g0C@slm.duckdns.org>
References: <aadKDCKGHk1Ua-7_@slm.duckdns.org>
 <3303d57a4ea6776dbc66ca72441023f76e6f1234.camel@sipsolutions.net>
 <35a7ebcf-862f-0b3a-a245-c32196a58692@candelatech.com>
 <aadYoaA_JYduCx_S@slm.duckdns.org>
 <de003dc3-3e37-f238-4250-2df16eeb77d6@candelatech.com>
 <68c1ca1381d1871fff72b211890a64eb@kernel.org>
 <bba74cab-7305-a052-7e1c-7a7736ba4531@candelatech.com>
 <5b9b93df8774810a43fceb359906604b@kernel.org>
 <729164a1-9dd4-c9a4-f092-d93d775257e0@candelatech.com>
 <abB1b098e83bLT5v@slm.duckdns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abB1b098e83bLT5v@slm.duckdns.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: BBFED10000B
X-Rspamd-Server: rspam08
X-Stat-Signature: ei7esodnr66ntc3bq3joyqaj3b3x4y87
X-HE-Tag: 1773172132-781773
X-HE-Meta: U2FsdGVkX1+pUYnpN2bFWWIMePttAVo0Xq4AdPQF1fuILBid7Z4sIUBExOFoeBm+rFL1k/NVeJES4t7Er/0vlcRgoFneHs1xvp7CyqwwPevF4JSIFyWKGAcpRFlDek6hLk5h5p2ZbG+BKUSwfQMTXk6KVxxx2KPkAn4CxxeRXHgiZv0cpELJx/JmGq9ihx1b850ANt0VUWiXCmtx84EqgS5NtaPhqSADpiqkU058DORRJDCfzcbdYWnPZYI2fRkZNzbeAdU/rTWg0AAdP2Utlb7lvufKuogy+lZkZJ2b7VmifIELXHdadoCcma8G6Xme+bQ7bxyMSqwSQ2A2pmGIuvXd6U/cm0OsW0vKNdrn2Jg25ndUkYR1nGGn/FzDw8iiSE6K3xw7ZlOroFUqEP/gh195Y62BWPwXhsq+LB6DBc5hY/icNZtdifozXnK1PTuZzTa7Fj8MyteV01SOtv49T5YIU4o7DBhHfE3TYqF8nGh64e2oSRqhwtyaSQkjWdH3+VFWLJ3AwXIMsrVWSJBdq6qd70ED49ai/MetIrC7TLlb9NT+HtCjkoUBBqWwfLEs7nJkjBUbDoVGpDvqj3LB8DufO4RcHG5a2MvB1Fm99jMXOucPNSR9/dUl/DALsif+paR4blNvN7Vcfwx8OXO5CGO8e0+hvLROjMPXssSC2USh2+Jg7SurVXuYvuzF3st+9FL8AnwSfBrikUFxCILBQA6xPJgRujhRR3VZ5Fhx0VYJuu1gmrEUPJGr/NM5/xQpnDRO4gI3AAhajyoI5FzhhgLCLCoKl1LSHkQ5CQxXeenomYGzg7fWHUgv69/b2jXIGKrhIzeJWvghu1lmiw62vKQPbid9WzMJrqj87YCbiwjSETaNVeFRSEs23ZPiNQ+nhMlqy0wZaI/XFhapGhPoLiLLregqN0Q5215VVwFVO4lSZkIDqlnfPFjp+C6v0xbUjVLnT2otNENgjpJWK6M
 OnLG1oX7
 trianvrVgFZZk5I+ygjKWVUXh8n1iGzzst1gGxRzzAhncDtvAT6h+7zEaxfjLhmaluHXm+VDO9/krTZWZCUJ/fdXdzWTe0fw4p4f3tdVd8uVz33H1DKkA9/mYS5S6ArBEV0ZaDv7QWl7d4x+i+lZbXht7MIRcPIunbol+TytBqvn71nbyWkLsJJJ7GVPlFc4S2LgdZ44oTV/Bo5QCjjj35b54/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 10, 2026 at 09:47:59AM -1000, Tejun Heo wrote:
> Hello,
> 
> On Tue, Mar 10, 2026 at 12:18:49PM -0700, Ben Greear wrote:
> ...
> > But could this work-item (re)initialization also explain work-queue system going
> > weird?  Just using kthreads, which 'fixes' the problem for me,
> > really shouldn't make a difference to the code below, so probably
> > it is not related?
> 
> Oh, re-initing can deifnitely corrupt things. Workqueue shares work list
> across all work items sharing the pool, so the blast radius can be bigger.
> ie. It'd be *possible* for kthread_worker to get lucky.

BTW, if you enable CONFIG_DEBUG_OBJECTS_WORK, re-init should trigger a dump.

Thanks.

-- 
tejun

