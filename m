Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF0E7CD5BAB
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 02:27:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1BA06B0093; Thu, 21 May 2026 22:27:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF43F6B0095; Thu, 21 May 2026 22:27:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E304F6B0096; Thu, 21 May 2026 22:27:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D3F846B0093
	for <linux-mm@kvack.org>; Thu, 21 May 2026 22:27:49 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7CB50120977
	for <linux-mm@kvack.org>; Fri, 22 May 2026 02:27:49 +0000 (UTC)
X-FDA: 84793470258.03.FE1591A
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf23.hostedemail.com (Postfix) with ESMTP id C33B4140005
	for <linux-mm@kvack.org>; Fri, 22 May 2026 02:27:47 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GVpw4nkH;
	spf=pass (imf23.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779416867; a=rsa-sha256;
	cv=none;
	b=16TeVMbYWB7vapz5E0KkoWQ+SvjMC4sFwXQmDDxYvjnifUBKDUPyHyCjciZP2mJW4cfLIf
	cr01HXUzgFHjgsBLEjyXyoBc/ZcWQ0J7hhCdflAfD9vOBB/swE5Qyn/7key8b0u/35ueEv
	0OUe+xoQboVk6LIqQOXPsOO94lKirW4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GVpw4nkH;
	spf=pass (imf23.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779416867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uLflcTnDVR68YXOTUiaDyXVU/XHr7QC3203n7y7YGNA=;
	b=1FrNBzf25M15lszm8T5teQJdyQhh7BgQfuZl9GXCJVwcoGp08aPtEcfY2dagabvg7kBcM4
	yFbdg+3FIDH1AvOTgmMGNhF7ZU45wz8YE+oL9flWvWEqeBxRhGQZPSRqlhDimx04h/dJ52
	+q25JazUtrfAMjF/lc2xgchvLbcspqA=
Message-ID: <150014a5-82d0-4e53-8595-b01b3bf43832@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779416866;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uLflcTnDVR68YXOTUiaDyXVU/XHr7QC3203n7y7YGNA=;
	b=GVpw4nkHZflPEGjsfKYHrPnisj2uSGUz/jH04R8rFFS6qfVFmYVXCQ7eZNWVP+ct/UCMvM
	5NytgX00z3Av116TkzeRk51G4La7vdHEP5NeWrdXXv+B0nOyKtG2JlNyKk3gv3e9QSn9V9
	6YkanccAoChLgcmi7ZWHvgil1S7hpXs=
Date: Fri, 22 May 2026 10:27:38 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/4] memcg: store node_id instead of pglist_data
 pointer
To: Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Alexandre Ghiti <alex@ghiti.fr>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Harry Yoo <harry@kernel.org>,
 Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel test robot <oliver.sang@intel.com>
References: <20260522011908.1669332-1-shakeel.butt@linux.dev>
 <20260522011908.1669332-2-shakeel.butt@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260522011908.1669332-2-shakeel.butt@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: C33B4140005
X-Rspamd-Server: rspam03
X-Stat-Signature: kzay9dwpzz6gwt5jp8cfm1domkjpgdhb
X-HE-Tag: 1779416867-987896
X-HE-Meta: U2FsdGVkX194ClxoS7Xc803XJookxocElh26jKzH0yqnqF9oPpxwTUK4EG+uAB+4sgdT3ParXuB7gFHWq9sZ3zND3wzsnQfnFePPGNvsjFFstj64a24vlpVHXDwm9MO9mxKyjur/9o+EqL4aBPasn6LuoJRfkSz+KcHa3Uinr6zUugh+CW6Hlf9bRRFWbSZfTXpt3qitkjytIvFAlDbSt5uzSisa/r+D4+kZDHe/axgES5Rjul7krY0rAlAKeqnhE5Ya7jRI9xIozoPga+vWnf6R3YV1I/cw+4ihXrqs7G8lLD1+U3dde4kAkdYjFxHt/kgqK4u7XAOMSD+NSR+gB4nQ6zgWaLj9Wll7+ND554T1oBYj9TojCdWmrdpXt/F17pm9qkzhZXAk95Oh7hjEzJk+dnB3pWykN3wfRbO7U0rJtt5MoPFGv1foSn/TyMHJncSYOg1QDgXuD9TX7kgoapDQzo/qKXZk/OQMxs9sQWHdvmtzk3ohbTno5MSQU0Uz/7rTTfn4e/yXbzF4zihUGa8ncYoF4rN2hQ22pEk/BY/hfEwT/0M/LP1FHZ/0G6+XenBVu/oShiFGsn7+aCVOu0cbZ6qEMylmVXqryBcpTqmdxDdpBTQc2pZeivt7fz7x58nqYNXy/ce4YkohHog8M68M/dovwy6aXGLcnyfUzaPsxogBnlbgmAtUqwwxRDIUT8Igt+yNFiNIctXbLBkQRN3WSjdyZTQPt+5C2tbX+fKSUWf12ah9boi94fIbqaoFrpKn+YTCWSH6HbxWGdiwv5gvEUXB4e/ljYg1d159dIZLqDTtuQaRji53iNdb9MBLFtXOu3Pgyml/0lEi63W7x90BWXV+wfQkJGVuvpdVPURe/daQm9fP5vPi1WcbGlzXFnTKhVZP18sbgrIWjJOW4o3Vn4U/DyhqFOIQs5MSPuEparVUkk3q9tOjLxS+lZmARca4tNDV757ynmNB9fo
 v6wbDhF0
 TlbqFC/NyWC2Tb3D2r1r432gwSswX9KItA28xQtFy7AQA5kLxiJBxnK1P9QQYhQl1uZQAhharUtACOA3CaCWoLi+AIzpvCx+iCFGY1HbqkXfWTWvpSJM7/S4OynSdo91yOZDVf/DGj+R/bxFfmy+3CpbF4N6xRTdhDNWhzvewkrn8GcWYoCNkJfEOwNELWP/+miK6adohjCBmo25N85/A7I2nrLY1UklrWYqoAbz2tsfKhWh9j3IxDBqtcGlfZ5bUSr2EYaOWN0yJGQzRyC5qZQ/0gqOrBukunnQZjIlMHj4mC03m+nKfRWqG9Da0vl4PtcBQ4PRYocQ5wB2+9dRXrlr6e0oG7C0DI0TDmcYgJEtJ9IPJ/Of6uupnew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/22/26 9:19 AM, Shakeel Butt wrote:
> The struct obj_stock_pcp stores a pointer to pglist_data for the slab
> stats cached on the cpu. On 64-bit machines, this costs 8 bytes. The
> pointer is not strictly required: NODE_DATA() can recover it from the
> node id. Replace cached_pgdat with int16_t node_id and use NUMA_NO_NODE
> as the "no stats cached" sentinel.
> 
> At the moment all the archs limit MAX_NUMNODES to 1024 so int16_t is
> plenty; a BUILD_BUG_ON() makes sure we notice if that ever changes.
> 
> Fixes: 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
> Tested-by: kernel test robot <oliver.sang@intel.com>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> Acked-by: Muchun Song <muchun.song@linux.dev>
> Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
> ---
> 
> Changes since v1:
> - Added tags in the commit message
> 
>   mm/memcontrol.c | 26 +++++++++++++++++++-------
>   1 file changed, 19 insertions(+), 7 deletions(-)
> 

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks!


