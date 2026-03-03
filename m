Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F09D8EDEBF1
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 20:52:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38EA76B0098; Tue,  3 Mar 2026 15:52:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 366676B009B; Tue,  3 Mar 2026 15:52:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29D386B009D; Tue,  3 Mar 2026 15:52:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1B32E6B0098
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 15:52:33 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C5E258B02C
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 20:52:32 +0000 (UTC)
X-FDA: 84505950144.28.6C7DEE6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0C117160008
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 20:52:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YCGoGU5Y;
	spf=pass (imf08.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772571151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H7um9YRePm9A/3yajEgmBEmhDlDSDGvE6j2nvGvtfA4=;
	b=G8WSkyeAgpahqTMUE2GHQ+/Av0cWAbf98zveJyudwv3XEmdYvo8mSbW85wPi5NMuy0fxp7
	2PPa1eUoTFXzCiytcqb3CwLa8JCqKRUeD+R8vhQIM0d4gcIWToX3yxwA6pZmczGJsoeQuq
	3RMnxhB6OlxKNqiUqQn7x8N98g7QdG0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YCGoGU5Y;
	spf=pass (imf08.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772571151; a=rsa-sha256;
	cv=none;
	b=0wwccdU1ptoakGAMNmi27bFWqP6h5jlOjYdcA09yBhNfdjCzuMJqHTeFPSRG38wGQg9g9Y
	9AOttERDUmdYNJv4PYd93mlfvf16YksCWNDxzbSE0NaTIiiZahQ38oFmt6i1giUqkCEqka
	0Gg2s3CoP+JfB3TAEQLi763c/ft1S2k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B142940D98;
	Tue,  3 Mar 2026 20:52:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CF02C116C6;
	Tue,  3 Mar 2026 20:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772571149;
	bh=Xeo5EivCSK8i5ewFGXEJ1ysYZsQ7yZF4ov0qH2Wp40A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YCGoGU5Y39HeDTKSZIz/fjegDB4ezi/z5WfVFuIsI15kReBnn/1bImL6tNTrZugWy
	 zEIdljZz3VdMgP5z4YNVpKFnKfu/fNcryiqk9WOl6obxZrnZ1sB1Ei0rg81L/yr8R8
	 YNagly2k+91n9w27EUNbivoU8RTsUry5AStbx5KGb5Gqq8ox+7PYNCn/gPJHDVITeE
	 No9E0TTCBHKiNp/RsPqi0WPCGAwxx9+hvnJCPPYfJJO2zvKYbs0zwdH+bXUCT1oxnH
	 /rUMFRrQVnhAkj9X0iY7HoBFvVCdMKJ+mZt7IB3XP/HOMZ15Qqt5Wdl0PwZE0G8f8x
	 a3pWuJ8Me+Kng==
Date: Tue, 3 Mar 2026 10:52:28 -1000
From: Tejun Heo <tj@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ben Greear <greearb@candelatech.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Korenblit, Miriam Rachel" <miriam.rachel.korenblit@intel.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: 6.18.13 iwlwifi deadlock allocating cma while work-item is
 active.
Message-ID: <aadKDCKGHk1Ua-7_@slm.duckdns.org>
References: <fa4e82ee-eb14-3930-c76c-f3bd59c5f258@candelatech.com>
 <18c4bfed-caca-bef3-a139-63d7fa48940a@candelatech.com>
 <e7d92fab-9d0e-4a58-aa0b-2c6545772e68@candelatech.com>
 <3456b2c89f057900b39ce79ea8ca1154c5014e43.camel@sipsolutions.net>
 <0de6c8d1-d2fa-44ac-8025-cfcfecd87b02@candelatech.com>
 <bed9cc03d3c214b2601093f91e4b00f3715762b2.camel@sipsolutions.net>
 <c616fc41-3bc7-4ddc-b65c-a622111d8548@candelatech.com>
 <35779061f94c2a55bb58dcd619ae91c618509cf4.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35779061f94c2a55bb58dcd619ae91c618509cf4.camel@sipsolutions.net>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0C117160008
X-Stat-Signature: xpx8arqofpg9b8mhpckowxcu4x1f5mgb
X-Rspam-User: 
X-HE-Tag: 1772571150-30067
X-HE-Meta: U2FsdGVkX19nhT2SDlymctcWPo7Vw8pE0JvLdUTScS96o0sPZCR9UYNOZ2L4eiTXkBjPwg+ZOG4xc6JFdFLlJMRCgt1H4rp6emcnzyiDn77CP2csw7NO+HkmcNFOr3wmyYuww0r04Ba0BE40FHaprNPFKGjfvnMw655cnCNi7jQe7IdX4n8lMRdpk2eFp9M8GzgUojuSE/hwDQQvHBU3GlN7ufY+1z4V1tXfkSVZBoFnXpXa4iC+TIcLLpYgTLfcAPfW04JpOHvc5rFfvh/Or+gGF4UcTtXhDYafMUjq8xpv30EBfHPYKAdj+SPCqe/jKx7crRVOChk0YdlvUy6Ch3ehTjchG39YA3GVKeUm9Q/Fhh8aI6onGsr16zq6/UWTFLZQMpvP9yN2nwoKRbzB6Npe5mnNxh7buYO0ACOxeffH8sChtUFOO2h9/OfecMzGYFzbCib8B5Qh4foslDmBwtM77cmM2l0mx7b7nXCqtWVQGiUN0as7RD3quz2x+r4D4t7CkHLxMKAsRAKdFoUWV8CHwiWbhrpXkNMMFjNFZywiFt9OCM3XVSXQtKmkFAZfW5nEzQdv7Kt9gKPpjRgHYcuyiR89oz15sep2O+mwBJLbuP/vq5kZqRZ9Widmr7RMEyCHUdtsznGcpaSOt/HqQYuGEFNuKIKXzax5thG0LsVIDA7Jgr7NF05EDw+XAmsfe2UDLRcbc3wPb4x0qVU9uab4Zpk4UQjCwkugvvhoV4FUcddZyj3YCBEfxLXn+ygSy7e/WQ9AXlSwrlnvG+HICqt/Ji0mY55gPGUGe0/8iUrYWV9eA1/PeMI79k+DGQdeSiLtACCqvd7dBiHR8aHpbnunzvo3MrJiXox6frXaTDIzLuuw3IOmIGgUVmKQoTqU12wduzJ5gPr9M/hMubRUI/oRlr1rv3NT/kbbr3XBCtWXQK5g4HMO6/wpBTEmP8QjsJpW9airUVgpzBvffQG
 nX2wuH/0
 BJdjdH3MQELZbhGLHOTv+ip8aPjVD9ra/Ah4c9+JAHXMOz7KtTOGXerQAGWtySNRmHWhtbZyWOdZ4XV5gdJmeTf3eay4vgchnLfxrC7KcW3YI1GEvVF6VE211dBF9qk6ztuQ1N7nwkt2G5Lo+twrVK7qzvq+t9xaPjfwcfwxmJ31VSHkNUVL8J2JETu3GCNE5kxzR9tnZ7uqW6Nw3h122WE9RQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Tue, Mar 03, 2026 at 12:49:24PM +0100, Johannes Berg wrote:
> Fair. I don't know, I don't think there's anything that even shows that
> there's a dependency between the two workqueues and the
> "((wq_completion)events_unbound)" and "((wq_completion)events)", and
> there would have to be for it to deadlock this way because of that?
> 
> But one is mm_percpu_wq and the other is system_percpu_wq.
> 
> Tejun, does the workqueue code somehow introduce a dependency between
> different per-CPU workqueues that's not modelled in lockdep?

Hopefully not. Kinda late to the party. Why isn't mm_percpu_wq making
forward progress? That should in all circumstances. What's the work item and
kworker doing?

Thanks.

-- 
tejun

