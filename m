Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAE3C606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 22:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=RGd1WEcy
Received: by kanga.kvack.org (Postfix)
	id 7A1586B00FE; Mon, 19 Oct 2026 18:06:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72C5D6B03A5; Mon, 19 Oct 2026 18:06:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F3436B03A6; Mon, 19 Oct 2026 18:06:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 257E76B00FE
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 18:06:43 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8FEA71608C8
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 22:06:40 +0000 (UTC)
X-FDA: 85340760960.15.C5ECBE3
Received: from mta0.migadu.com (out-15.mta0.migadu.com [91.218.175.15])
	by imf05.hostedemail.com (Postfix) with ESMTP id 616CD100005
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 22:06:35 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RGd1WEcy;
	spf=pass (imf05.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.15 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792447598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wIBD55LUoHoDATJCGVof+4CgALz8EVmNkMYBhtvyd6Q=;
	b=RxknPDwWDHsAYoyTPFjqGJIUb4banUWeaZr0R9IRSJWyvAKdszllSHKLkBGxl2aN9wG5uC
	tFPNAjp+LkEAqYqC31pjkwi2dRwSy0VM9WdWakWPpTsvHdtGbKTOUkToIrRpgMO8vuG60R
	tlsdHFs5GT4NuCBMB2nEhYVWtJZLFNY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792447598;
	b=DN2ukWeIq2hToHWeHyDU+h23penSkMxnDuZ24VF/nVzs66oGbn7ltxrD7iXtxdiRU3UvTA
	4cHBuqMwYXr9HGPfW+3WF7L9jFeNIvyf7XW5R9CrewdPJvoPj7rPfxDPmQJw8pkQlvuvrx
	+hhpi7a6Q+Q8Ekvbvr72u704m4BaQ08=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RGd1WEcy;
	spf=pass (imf05.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.15 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=GhC0senqgW9jk2iZrX/Oeif4+RMjrpYmvR16vIm3Y84=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792447592; v=1; x=1793052392;
 b=RGd1WEcy6qUGkInqsO6UQsWxpSvK+GCUSBAFheBJNPOMDkx2Wm6h3ooFMF3h2XC9eBo1/JXS
 mGwIUxbHAIB1I8DpG2ajAUb0Kc/0FxArxX1xbPeubnS+lc1j6hxvD5faGh3cgPyTEupWpX3uNsc
 Z8FyFfQficBtcqQvYNYy4FcQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id c4935393cb2a0c10;
	Mon, 19 Oct 2026 22:06:32 +0000
X-Mizu-Trace-ID: c4935393cb2a0c10
X-Migadu-Flow: FLOW_OUT
Date: Mon, 19 Oct 2026 15:06:29 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev, baohua@kernel.org, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, baoquan.he@linux.dev, 
	baolin.wang@linux.alibaba.com, hannes@cmpxchg.org, david@kernel.org, mhocko@kernel.org, 
	ljs@kernel.org, dave@stgolabs.net, roman.gushchin@linux.dev, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/vmscan: reclaim every zone in per-node proactive
 reclaim
Message-ID: <ataUUbN1leyRVVQ1@linux.dev>
References: <20261019185002.3428594-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261019185002.3428594-1-gourry@gourry.net>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 616CD100005
X-Stat-Signature: qempatc46rdt58bsoeu5w4wepby3jjd5
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792447595-342271
X-HE-Meta: U2FsdGVkX1+DKchAWsH3Q0RciCnHqVZ8f9/8KYKq/1AH8qUG6ek+1ZjOMIaBvhIDv/nIyAUoMJOlIMYHdXR8CGAPbD7JN/AsoALlmzwTw7ez24nkDSnLlAbZ8D62Aaa7CNw/mjKEPnLjCcKJg7n1aMsUCgQvmx77tSpHHKNb8cAgxrxXLxKu5ndtONeXXdP+HCX5f5bNEaU20L+Tq7qe4xVEvcaStX5DzPBKvN0gKUHodAcVFAlm0CV+EX+F2IN8M4lxyo8xTUDyhQCreYvcdbFNSI3GM1rBvsK+O4oCh4hGOW7L3Zgyf78KSn7PEI38osvJLLiazMXeMAhmmi69ZyJIVGN2zR2o0MALYvAyQrF9N0gZmH4zdKpj5CDIsEFH6X0xjTJ/wFw5NhE+F8T0wvDbT3IZ5Cz5j7WKR/yrFXE4ISUGFtcj5ixLpjveJfbzCYrRCCGGGSsjv5ywvuGXCgopq5C19Ej4rtTGs4l0KwmI/PVHtvke/GsLFXJupUEUj3vIb/CInLUp097lIk1rkR3U62BVacIsG8GJza6ociSe+Hn5hDaRDzZ3yZtDaF6osk98rFTKQHDN9T0Y/eo9UvSBcIErmbF0LB4TuWwcYl6n6nJfltmQQXTi2v+rnDrPBV1weqf5dsx673bUwFHUwimSqX1Yaet3NEDFfienqyQpPwAQ1/juqza9Wmdpu3KdzcPxP4nPngNt+Yhv8MmoOtD3nqnX02TBGWS4RaGFQ/b109wGAHsAjpnI7FnbxDHhdHMLwQjRNarc2I3WrmsJOo+oBjYVvrMEmp4NJivitl+QCVA9x6usvDTLMh0+r1mzfJEb4SCHd2FaTg3rE6dN0cIud5lzMPH1Ytnl0v09QAgWTr+nw+4/jxAMe0KEMs8JQYN+CIsRG/8VjVmtF5azsHjn4MByqI8lM3Ac+fJ4rXAsnt4Tnh6xDAqBPAAjttEsfREVDtCWEDQh45dz9Yg
 lkW06ws+
 UVs3RpgT/CWXTC0SL1svqR+4gLmTfC0u56i1kwjWJRnzCz02dzsORNJjtMxz7YMDtCuwmAxfjvYTmnsLe8oE+HUpVTaXMwFWKOQJ8BqmR5Mpt7bticLuGN/4uDn1snpFkeS5yEjwcOpJ3GG/yxUs0I60wkqB61SvrmsuyL1Uk1IoecwxQVCaa5wtfqjNchcDhktbzBAvHH2BMoXqkeKoOuOu9oHrACda7dIQMCpyK7qLc/Ts6sXwRsePDecz5FwZsmgVpnvjB6POlXo1Fcs0ST6JaR5kMcFi215vDHplnDEhVReNLrKg3qvzx0Dj/LSjg24wuCLKc9PeVwt3j8yuj43kT/syXhjpjOADn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 02:50:02PM -0400, Gregory Price (Meta) wrote:
> user_proactive_reclaim() limits per-node reclaim to
> gfp_zone(GFP_KERNEL), which is ZONE_NORMAL. Proactive reclaim serves no
> allocation, but that limit makes shrink_node() skip every ZONE_MOVABLE
> folio, so writing to /sys/devices/system/node/nodeN/reclaim never
> reclaims a node's movable memory. A movable-only node, such as dax/kmem
> or hotplugged memory onlined movable, reclaims nothing and fails with
> -EAGAIN.
> 
> To reproduce, fill a movable-only node with clean page cache and write
> 200M to its nodeN/reclaim: the write fails with -EAGAIN and the page
> cache stays. The same write to a ZONE_NORMAL node frees 200MB.
> 
> Scan every zone, as memory.reclaim does.
> 
> Fixes: b980077899ea4 ("mm: introduce per-node proactive reclaim interface")
> Cc: stable@vger.kernel.org
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

