Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D73EBD711D3
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 00:55:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45CC16B0088; Thu, 18 Dec 2025 19:55:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40AA26B0089; Thu, 18 Dec 2025 19:55:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 316926B008A; Thu, 18 Dec 2025 19:55:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1D7B06B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 19:55:43 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C1A61B8C61
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 00:55:42 +0000 (UTC)
X-FDA: 84234402924.22.1EE653A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1112D180002
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 00:55:40 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hmeJRar8;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766105741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XKf7NAvmeFIAlIyrPeEGD6S12tjcn3i5LQBUR7JDlO4=;
	b=YagbolMvSofkB1YT/2P8cqm45cp4L0RbjtMgT/0+CbfzC3f+j6Mwsg7JjuQUFsHjy23g1C
	2OpiE2xtMfq2KNB2/gSjFJO0LzQILdYeUpUe/sF+Hs4ZkJ+cfapJkqzx33ZrYxsgme105S
	ABix0kZtUOh/W4WWHL5XkhUEoiOJmrE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hmeJRar8;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766105741; a=rsa-sha256;
	cv=none;
	b=bYiTIKjjtmsa9gaBzyPpkpNt++mby9xkoqmac22LMNiNHaRFIG86ide9NiPYzj6+9Ehooe
	dOE0wKYMd+fowrn2Ml+BbMV3obWbYiz7p36XZjgMJ57OarXgRz01VH/ij4askSUHWummL3
	xDgu80isasE997iyQ49xD+q2S3uf7Og=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D14A544331;
	Fri, 19 Dec 2025 00:55:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAA9FC4CEFB;
	Fri, 19 Dec 2025 00:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766105739;
	bh=O1LcidgndLzEkC1OJf94E8Uc/cfbHzpboI4JrAyy2AY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=hmeJRar8IjmjTQao9wLarnCCJ7+qmVNA+7IK8+9GCoK/Cfn2vtG3zIWfHX9+2z69+
	 XcfO4JPSyyVRepDDywNNF8b5U54xff441uDr/bQSsNkCy/pdZZP2U2pRFWVtxLB/w8
	 JQbSl0o+fiWPpk13dF4zKGKLLVF7tMs/mcO5RF8w=
Date: Thu, 18 Dec 2025 16:55:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com, david@kernel.org,
 osalvador@suse.de, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 corbet@lwn.net, muchun.song@linux.dev, laoar.shao@gmail.com,
 brauner@kernel.org, jack@suse.cz, hannes@cmpxchg.org,
 mclapinski@google.com, joel.granados@kernel.org, David Hildenbrand
 <david@redhat.com>, Mel Gorman <mgorman@suse.de>, David Rientjes
 <rientjes@google.com>
Subject: Re: [PATCH v4] mm, hugetlb: implement movable_gigantic_pages sysctl
Message-Id: <20251218165538.b299508aacdaf7d941035ec3@linux-foundation.org>
In-Reply-To: <20251218151211.1237411-1-gourry@gourry.net>
References: <20251218151211.1237411-1-gourry@gourry.net>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1112D180002
X-Stat-Signature: tub5iptxhesp5rfda7u38kuyie8dym3r
X-Rspam-User: 
X-HE-Tag: 1766105740-812242
X-HE-Meta: U2FsdGVkX1/1XspqfA0CTOZfgzVfefvA9u7KXW2XBZ5/sYAodX+CRbaYUmwxAPYwdag+s0gdYVxskTdwuY6Jy/PrU4OgfCaNOxKvRooVtSlB0LAafzExv3eltqFavYtXaChDyLlcCGtPls++63iET2eiFKaHqCloztwV2KCYIRzFXumIXXNLnqHfI2ywnFa+si9IC9Pt2LHRzasDTUHXDWyaEBc8uRI4QRp+BzR19NNp0CFNXd8NglXlMuKnOOMwPu8dOcBIOID08qfsaVTLjGePnFmJw+OYNOtlCKcjhGbNYijAc7nvnCg356Q2Ef2QF44+M/fZZX82hWh7SJwYMuxFHjd5P8oV2pTytg6C7xNtH2QXdAOjDxf/HIu7Dg1yJhUQ1LfYwg4dooH2PIUE3Qqv5+8GLf6TI4snXWk14KZUmOXKs6EUw3JCZ/d3sfV55pCekWpc6aDP1ol9e3n7Myg3l2nbHdNiUubw3OkVu0RxYUlRfninInH2howHXwkbbJdMab3ndPEc5ALod33e1XLWKx0ySe9DUWQOwkzbXrQ/VAjITQukgav1eRz9dTIlYPmNB6ktAbQTl9OGKjfZdK3ZbPkPKkZfWRpInyO4k3pPuvA50+K0+O2741Acr2EzIV5Ko+UZZ+qjp1RsCvYXbc8KAWLBuGAK8hziOcUUlUsPnAw0k2adx0yrew7ESI9eZNZ6i49BVUFVyhTkNU9NIsdhMS7pM1BOWikYFA/iU9YExcvm0E2IiGF64iizAfHNnI040uNzZKd/XBIQj+kgj0s2noiC4ZJdux72QbF1j4qVR618uSYoPT9cYlOcN2kblLE69TVyz5mpx9/xeTjfMnGY5xa0Zwgv2J8KnzVUXhuvWdgswZJym1+ZmYKN0RdqDcMWg/1Uje14xLRLO6AUITCQARUYXtxe1l9JQ0JHj0H8Xrb16uNHGz3CGyBADdytHNxriclsrMVmKWnPPmq
 TkDYZ+3e
 Tup17inKnKtgrN0nJ1e076zL5iwgHPpFgyePXS6ZRqanJ5uBFcS5jud0B2oiWBcEL8jOBTx2GvvcxDC5UX/3BAW4i45gqyCvmdNomSkVwwikZCB5sr57eNcV7fv5Bl1I6G6dDAkhppKe6FgPKWSu82jSfAJXJUBozbhbh7JlDSkWh+DwF24O/M03nCP+ZnVcMh5RSQsjyg4sa8qt4jfU9ymHi+AnRcYuX8ki1bCcez78vLyuY5YGAUAp0wM5AbkLlh+5XS9MqxbpXL8g5TT/dR1XIAkmDMDz22jqapA4ODpHubjJGGJdsTNA8BYQozrnz1rDnm4ATZISwhio7z66HvbAv1/WRUN40CNSnukDMjGoPMDT0ZFwjKFE6AqBOLnbrU/3P+R/ClSyb5krsOJJT/TcEgdljY+7IE00SxhtMuB1Zvp8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 18 Dec 2025 10:12:11 -0500 Gregory Price <gourry@gourry.net> wrote:

> This reintroduces a concept removed by:
> commit d6cb41cc44c6 ("mm, hugetlb: remove hugepages_treat_as_movable sysctl")
> 
> This sysctl provides flexibility between ZONE_MOVABLE use cases:
> 1) onlining memory in ZONE_MOVABLE to maintain hotplug compatibility
> 2) onlining memory in ZONE_MOVABLE to make hugepage allocate reliable

My x86_64 allmodconfig blew up.

> ...
>
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -49,7 +49,6 @@
>  #include "internal.h"
>  #include "hugetlb_vmemmap.h"
>  #include "hugetlb_cma.h"
> -#include "hugetlb_internal.h"
>  #include <linux/page-isolation.h>

What's that doing there?  I put it back.  Helped!

But the build still failed because the patch refers to

	extern int movable_gigantic_pages __read_mostly;

but forgot to define it.  v5, please ;)



mm/hugetlb.c:497:56: error: 'struct hugetlb_cgroup' declared inside parameter list will not be visible outside of this definition or declaration [-Werror]
  497 | static void record_hugetlb_cgroup_uncharge_info(struct hugetlb_cgroup *h_cg,
      |                                                        ^~~~~~~~~~~~~~
mm/hugetlb.c: In function 'record_hugetlb_cgroup_uncharge_info':
mm/hugetlb.c:505:30: error: invalid use of undefined type 'struct hugetlb_cgroup'
  505 |                         &h_cg->rsvd_hugepage[hstate_index(h)];
      |                              ^~
mm/hugetlb.c:506:33: error: invalid use of undefined type 'struct hugetlb_cgroup'
  506 |                 nrg->css = &h_cg->css;
      |                                 ^~
mm/hugetlb.c:517:30: error: invalid use of undefined type 'struct hugetlb_cgroup'
  517 |                 css_get(&h_cg->css);
      |                              ^~
mm/hugetlb.c: At top level:
mm/hugetlb.c:580:56: error: 'struct hugetlb_cgroup' declared inside parameter list will not be visible outside of this definition or declaration [-Werror]

<and much more>

