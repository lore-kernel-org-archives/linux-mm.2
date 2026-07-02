Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D055BC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:54:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE94D6B014E; Thu,  2 Jul 2026 20:54:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC06E6B0150; Thu,  2 Jul 2026 20:54:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFD626B0151; Thu,  2 Jul 2026 20:54:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9AA6B6B014E
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:54:42 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4486D1401F3
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:48:13 +0000 (UTC)
X-FDA: 84944570466.13.01138C9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7B8F040008
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:48:11 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fp7zdAg8;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783014491;
	b=QHVqWJZ/kwP29eESoPwA3Fnq4kIUcmcSEq3nw6oZBvLFRp37DyM3CWBcpGQPujOoaD8f8b
	FoOhzWfJnqbjCCP9xM1fIiy4qApRI+BS5HFETyBWqyA09wareboqCKbKDI3auf5wwEFHVj
	GRYBGGfon3zm9RwJKRB3DQe/9YSVdvI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783014491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3wIIvBhOVbUuy4vpl9hlDspmUEb+HloUkA6ennnR9Lw=;
	b=RyeHJ/NfPV37PdbWcHsJrWDrd9VmrIWqkSLcDvR5fgzMn4jYhKlzEDrRf1nkSuZb3ilLfR
	RCw5xPXyhXll+n8drgSDbO2ZbCxD22TfwS2843h3pjYheQIBdmNStlzewunrIkrMkBd1Bf
	3aAOKhbBYmDQQ5HFKrmd+Kny+fZdZ/c=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fp7zdAg8;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 564BA43E51;
	Thu,  2 Jul 2026 17:48:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19A071F000E9;
	Thu,  2 Jul 2026 17:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783014490;
	bh=3wIIvBhOVbUuy4vpl9hlDspmUEb+HloUkA6ennnR9Lw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=fp7zdAg8doKNxnr8JIRlrlwniwEbc2HqbslY3XBOOzZ/cebxWmBGbu17RG26shWqO
	 fN+wdt70I9KdmQEmzsOHKtedRldBM4wlmHgaYqfudU+PWStEcAnKL+QsJtwoWRqTEf
	 nvaJY14lUd/a1gBpJeDOFCiNOAN9Ti04lOsYsi7A=
Date: Thu, 2 Jul 2026 10:48:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: David Hildenbrand <david@kernel.org>, Linux Memory Management List
 <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Subject: Re: [akpm-mm:mm-new] BUILD SUCCESS WITH UNVERIFIED WARNING
 f4b4fac1867633ac17c35842f03933f6a7a4425f
Message-Id: <20260702104809.6a137d91eb7e42875b16afda@linux-foundation.org>
In-Reply-To: <202607022346.lOHuTDpa-lkp@intel.com>
References: <202607022346.lOHuTDpa-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7B8F040008
X-Stat-Signature: fpy3wgtgdgbauczhr766wjj75cnd1hy4
X-HE-Tag: 1783014491-539223
X-HE-Meta: U2FsdGVkX1/LPY6ggdK/Koca1LDRnhfZfN6VKMLcN34RiEFVsx7lCpOVrAKySEpI4DCyfr2/7NU4r1ziIgYaPcsNQpGT3fqgxoRmPL8H+scmloK+14jpqsLXz7c3YY7QnOEZvKKbHVNowZ8+3XOzk15ucpp78UHSNQlKdc4EWNXHzWur1jRcVtvGP3CA7rNuFQ2Iw18TSQIuZgQt1m9mNXnrYukmQvBwb3aiaj67dh67j5y9xTHK2bqmNcyPS+A+gk++Puv7Izw/AAGG+AMBrcCqP74M9evFoCoZlJByulwcoUhHqNI2kuqSw5fyjUWKguTTMR4aDu6JW7aMPGOE6uBGsLYtuHSF+iGatU5bk/GTew+R8Rsslrb/aD+lbnXT8Dd2wfS4gHA7f5PpnMP67ghFtwS9eeQzTlt2VnJzecsh8bihNWg21u20WgYo6L0fItBiKtS9NN5oK9VYQJfXSlCGfI17pekj4yccVpJAWUMpyq0vSz9mKInZ/9UaetI/xnrFswrXZc8jJ1PMtWp9phbSzyijqamYUEkvFAQoWerGCHGw4djFEvsLKCwU+RHNwaTtutUZtqXDBFQ3d3typ78fBaGCIvqpa00X+IqNNfgbWewflGH+K/qYmWmye8Waei04v+vfrTmgJJVyBc7MVbxXOaE1rgulvvZNme6tmH8dJe7v7wz1ZW2GXxoQOxHIvh4xfTU65QDT8PcIg1IhERrkGVuaMxQCxhe6x2LRHaoEPUjCh9AktUoeHxLSZBitcfZeJDDw5CLxfyXozIZg3xpPBP0eJeTyHfk3YPwVYEg3eaEXx/5t8DhK2e9iNatdKgM9DG/4xP39RZnvemeJtj6OFENvzg5xvcdXLJvLGqm5x30VyBoUgDl4IXjC2l/3fB+UaN8GHXeHwHWvo9NSoN9pvhZzi9IEL8Oa7VKw2EkKtamKcsOIsCvi2bEofBJk4RCTQGtgtqucGlgI8S5
 GLU6dC4e
 DStoh+LPnpZ3715pB0YFG65vYQsr4jx4v1mXYDbjMu6y/fV0H13LVo0999nwABMHcDp0tGouueLtpHZoaRqLBOyeP6DqLgEq186byUkQNiHGiN+ak7qxNs10+24ufEYLksTEerDqw9rkSRDZc0YkUp/VHIKx5ngRzvYt5gaefGhfNEqy7V4FnE1OIYw3YlY9ddY5jIvpwHQWdZUno+X0oFQ24G/6+MqJZsUaCBOIpVjwCbxxAKs+S6mlH7UhPrKzakaE+L0ldId87ijX67WVgnxJCfKmG4I2ZjhzQH1njJnUzDG4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 02 Jul 2026 23:31:59 +0800 kernel test robot <lkp@intel.com> wrote:

> tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> branch HEAD: f4b4fac1867633ac17c35842f03933f6a7a4425f  mm/swap, PM: hibernate: atomically replace hibernation pin
> 
> Unverified Warning (likely false positive, kindly check if interested):
> 
>     https://lore.kernel.org/oe-kbuild/202607021433.DYT5fDqE-lkp@intel.com
> 
>     mm/vmpressure.c:254 vmpressure() warn: check likely/unlikely parentheses
> 
> Warning ids grouped by kconfigs:
> 
> recent_errors
> `-- microblaze-randconfig-r071-20260702
>     `-- mm-vmpressure.c-vmpressure()-warn:check-likely-unlikely-parentheses

Thanks.

I can't reproduce this with that .config and microblaze gcc-15.2.0 or
gcc-16.1.0.  And I can't see anything wrong with

	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) == tree)
		return;


