Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EE42CD8CA8
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 02:48:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 122006B0005; Tue,  9 Jun 2026 22:48:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D3596B0088; Tue,  9 Jun 2026 22:48:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2AC66B008A; Tue,  9 Jun 2026 22:48:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E22186B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 22:48:10 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6F7F9C1FDC
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 02:48:10 +0000 (UTC)
X-FDA: 84862468740.02.29BF263
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf19.hostedemail.com (Postfix) with ESMTP id 24FD71A0007
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 02:48:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gDf+YFv4;
	spf=pass (imf19.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781059688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lkq6AWcrvDXEYK4VWmEuauydPf93rxFze1ELQOyN0Nc=;
	b=VbkqvSLJ8uKpI1Hz9yiPqyOdo8lMBTmtdfVgeBcAw9rYs4G/aeXPF8kLJRW3hePo3SG8Wl
	Pwg7vcrfMmuPcj9M6TfrL3EkxBimdrWQNamXqYnaf7cYIpx/UL0yVIK7gYIf9x/USUG6I5
	kfR8DmvUfg8MdLp3AE1WITMSf0Wtmso=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gDf+YFv4;
	spf=pass (imf19.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781059688;
	b=u7KC2emAyB1oWFx5dRSTKXhgCTtAb2XpSlPHLebROD48ActRhX0IT4t6QgzGPe+eOw0lj3
	RSvn6f5HIvRkDfFh7DBg8N2K47KJtCj60z2qG8T68tTmTVJRVNQQvJ6CvyjS+zWRH6q7zI
	1EUJDB41Bo7yUaoDY6e8p0yy0luvk+g=
Date: Wed, 10 Jun 2026 10:47:54 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781059683;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lkq6AWcrvDXEYK4VWmEuauydPf93rxFze1ELQOyN0Nc=;
	b=gDf+YFv4ph4C8SIW7GcpK9BNl1xqQWql9vQlsSJRSwoMkBH/wV4qAATBCw/yRT3rQSJH/t
	lvzs4Jplkq/h5x0b+gaw6vPsQqpzYhu//laoTacJ3AwBJ/sNGrl8S67LS0qE1s9/2vu8Xc
	rp1rg+nGzKtCCofU1CXmoJNQt15W1Jc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, akpm@linux-foundation.org, cl@gentwo.org, 
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/slub: allocate sheaves on local memory nodes
Message-ID: <aijPhntXmxmGIh41@fedora>
References: <20260601095706.106551-1-hao.li@linux.dev>
 <33506b25-ab2f-4f31-a380-7c0fe65567a3@kernel.org>
 <ah-naIiz09TTBpXo@fedora>
 <5d8abe93-edd1-4b18-9ea4-7731dc831223@kernel.org>
 <aec090c0-137c-475d-9236-fc581bf1c97b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aec090c0-137c-475d-9236-fc581bf1c97b@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 24FD71A0007
X-Stat-Signature: 8ma5w4tytg6i893oaq4siyy476ir9i9b
X-Rspam-User: 
X-HE-Tag: 1781059686-770880
X-HE-Meta: U2FsdGVkX18jhVghdY61gB7pnC6Uh0Vb7e2OfvyOGqgqpTRiinOrM1Y47vREvr2JEu2X3nFEL2oDS63WlQevS4TSBWhGhv1hgMdFOXacnQfWMFuNYDZ3lq3eD2uI2ielQlXlARAT6XUUmVUExdrh1/6t/OqgxlH55n8vGLRzqKsH9v4H4BygbhrGFc1J75diTMlE8wCXJ0lg7V8kCL+9poiQasd3MkF5pFQak+Qj9d1Wc8DbJ3hVUUwHhqkEHu1Ue5/68NyaRTlFLhQurkKfNQ0+Zq+GhL1uj7JtDK52dFh9y0i3b/FdR9qgL+47LWTsuUeVNIaiIkOmzuZdUs3C/GY9NDvkpiPhDaA0Ry386bgN5KFzFaB3vWcPk8VtYPEfonT+R656jZK/q6gz6Oeu2di9fZJI4t80QseDY0nZzA+UXvhQcbNVyuj1vtb6Yl2cSsKyF61WCbOihoCUnNspnc6YIjDpNvy3+cx/t3qajWpG67v/V5sD8hnnvjGKPx2uXsjbAwydkPo72mYlwQCF0hAxYGOCbWo0BYJCPdxAifiZMVNpnYsRZK15A37tnL5x/fHb4b6jJqL5ie8Kgtsa/IaOQ/70rWiTp/GzRoGIkXT48nfe0YYaaQ8vmC69bwMnrB8tc23TvYQ0oUJYegwcOPqKBTdf7f7u7hursYBX5ivPktoHF/j6mJ8Jwu7uzBMjbkgUB4zxr9eg4CCVnsYPsF5bpOj7sx6xsVRbR3xaRR2N4WC1HHmiH6gFIrLumAMD3OdS9gnEKp9Tcmv+Euh3NSjJ84GM/gvKMg40rBkEQ3Ky6gzRB/DTYPv7sMEB7wxm8pUsfsPX5whFubiYyd0hzDzI+kd/0ROkeSTPor5IoPmNtCGZaljhJlEWMMw5CKE/5kQw1Ysc73IxJipI9gC7kvcs9esf/Kpx89DhMKy4siCZ78YE5z3kFlSfprOcL7P4aCtirKY9mW37A//ZKNM
 GT7Zi7x7
 JaZu5bEnZpGuRjBW7UA7xKy1pCzquiLAajoagza1QOonJSk3Wq24h7Kh/JGgCMb/WCj+DZ2bH+dyuh5R8ASDIqqsd+zaLSWXgqlyG8hU74kLvYV0KkUlyQU2dRX+qMNmS9TFkGGdQqyTaCJHQq5sCyytB4B8P/3pxqyXmqvVWt+2llllgitgqrKPQL1l2WMX0pGKyY2pydyYKuEY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 12:14:55PM +0200, Vlastimil Babka (SUSE) wrote:
> On 6/9/26 05:41, Harry Yoo wrote:
> > 
> > 
> > On 6/3/26 1:26 PM, Hao Li wrote:
> >> On Mon, Jun 01, 2026 at 08:28:16PM +0900, Harry Yoo wrote:
> >>> On 6/1/26 6:56 PM, Hao Li wrote:
> >>>> Sheaf structs are exchanged through node-local barns. Since barn structs
> >>>> are already allocated from their local NUMA node, this patch aims to
> >>>> allocate sheaf structs from their local memory nodes as well.
> >>>>
> >>>> To achieve this, the obvious choice would be using cpu_to_mem().
> >>>> However, init_percpu_sheaves() and bootstrap_cache_sheaves() iterate
> >>>> through possible CPUs, whereas cpu_to_mem() is only initialized for
> >>>> online CPUs. Therefore, we cannot use cpu_to_mem() and instead need to
> >>>> use local_memory_node(cpu_to_node(cpu)), similar to what
> >>>> __build_all_zonelists() does.
> >>>>
> >>>> The primary goal of this patch is to improve NUMA node locality.
> >>>> Although the actual performance impact is minor, it still yields a ~1%
> >>>> improvement on a 192-core, 8-NUMA-node system when testing with the
> >>>> will-it-scale mmap test case.
> >>>
> >>> Oh, nice :)
> >>>
> >>> I have a question though...
> >>>
> >>> I wonder if would be better to handle this by e.g.) not returning empty
> >>> sheaves back to barn and freeing them if the node id doesn't match and
> >>> it's not a memoryless node.
> >>>
> >>> init_percpu_sheaves() and bootstrap_cache_sheaves() are not the only
> >>> places that can allocate sheaves from remote nodes; sheaves allocation
> >>> could fall back to other nodes and then SLUB could keep reusing those
> >>> sheaves from remote nodes even after memory is reclaimed.
> >> 
> >> This is a good catch. In addition to the fallback mechanism, task migration
> >> between CPUs in __pcs_replace_empty_main() and __pcs_replace_full_main() can
> >> also mix up sheaf structs across different barns. So yeah, changing allocation
> >> locality is not a silver bullet.
> >> 
> >>> If this works well, we probably don't need to handle it in
> >>> init_percpu_sheaves() and bootstrap_cache_sheaves() at all as they will
> >>> eventually be freed, while covering the other case too?
> >> 
> >> freeing the empty sheaf if the NUMA node mismatches instead of putting it back
> >> into the barn is indeed a good idea. I like it. But unfortunately, my testing
> >> didn't show a clear performance improvement, though there was no noticeable
> >> degradation either. :-(
> > 
> > Hmm... the idea still makes sense to me, but yeah, it's not late to fix
> > it when we have data to back up.
> 
> I think if that approach doesn't complicate things unreasonably, it makes
> sense to do it even if there are no clear wins (as long as there are no
> regressions).

This make sense to me. let me double check the performance impact. Thanks!

-- 
Thanks,
Hao

