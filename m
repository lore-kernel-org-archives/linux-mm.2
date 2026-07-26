Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2C07C531D0
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 00:53:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 454AF6B007B; Sat, 25 Jul 2026 20:53:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 406BD6B0088; Sat, 25 Jul 2026 20:53:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31D8B6B008A; Sat, 25 Jul 2026 20:53:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0D0136B007B
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 20:53:36 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 85371A042D
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 00:53:35 +0000 (UTC)
X-FDA: 85029104790.20.6E3A746
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 82363140008
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 00:53:33 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=FMabStzN;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785027213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D9RJYrPyKu4j2C1jazqGEHEdAG3mVPG/Lir/eORzk/o=;
	b=8C0/e3aavnPEpG7UYZ7AMincHVbU41vm8KS8UuS2iWdDc7MSd3Oph9M8CX6rwLMn5sK7Zg
	UnNvP2hzDGRRxe9N357/JKuU+ijTAzzyQYCvZWvNWStgA+eH2C3Gvo4PNPhLoYFpC3pz3C
	vxxbiberIuA6FMcVZBJE+8WebMLassE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785027213;
	b=h/0keQiKqc2Nso3LGDiYNlZ+qbwK12/mRsJ1MVkFXAWwXkmk/CPdi49WZI9ZE4NoXFsy5o
	av4pHLr784G7nU/Cn0GEeT9Wcy029O6Um/Yh4ug2B70DseGq3zeIQYWZ7/SIhLwz3zjVhf
	CP+pCq2dbO5O0+QMrwycSz+dTYXKnhc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=FMabStzN;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EEB3141A7A;
	Sun, 26 Jul 2026 00:53:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05CE61F000E9;
	Sun, 26 Jul 2026 00:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785027211;
	bh=D9RJYrPyKu4j2C1jazqGEHEdAG3mVPG/Lir/eORzk/o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=FMabStzNIfu4BbASuRyUJpfWNjOtTeoXLye+5n6j+SyyzME5KViEIVwVi552hWN7z
	 K+V3VXq6r/hMEnTwAecCk3iT20TTRVyUCWwE92HChBFBQuYN2UwlY2BGOoGjGXekpm
	 1WmVE0lbN3o2krSVS5ne6vZZeceftxEnprBiJ5dc=
Date: Sat, 25 Jul 2026 17:53:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matt Fleming <matt@readmodwrite.com>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain
 <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang
 <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, Dave Chinner
 <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, Roman Gushchin
 <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Kairui
 Song <ryncsn@gmail.com>, Shakeel Butt <shakeel.butt@linux.dev>, Matthew
 Wilcox <willy@infradead.org>,
 syzbot+c5b060ce82921a2fd500@syzkaller.appspotmail.com,
 stable@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kernel-team@cloudflare.com, Matt Fleming <mfleming@cloudflare.com>, Roman
 Gushchin <roman.gushchin@linux.dev>, Chris Mason <clm@fb.com>
Subject: Re: [PATCH v2] mm/huge_memory: Initialise workingset state before
 folio split
Message-Id: <20260725175330.dd30f4e9b6f9fd28c5b41aa9@linux-foundation.org>
In-Reply-To: <20260725101419.3938406-1-matt@readmodwrite.com>
References: <20260725101419.3938406-1-matt@readmodwrite.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1zcdz6uz9y36yhear6hy5xak6d65eseq
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 82363140008
X-HE-Tag: 1785027213-80123
X-HE-Meta: U2FsdGVkX1+fOcXR2EH+qY6ckjOi4+7l55w5zgsSUG4H6tG6geP4ZRJEf0R1sRAq92pL0OJq+sxPtAzbO02+TMzvRQBVuGKwZWaeUS6KP8SK0Qp/arzJSnDZPby9/Maw3Pg7nfHEHNIOnvmlI4prxBMNH239A25waxxpmgxkqMPtxn9W5F+lH7tkpNIho7Qpt5fqI78QPV4R8W4Hob+Ea9v2lCQvxc7H2UeZ10Z3/jONqYPQc7iRcJqgaa/3x8z5R4Os16BlPwEH6NWMxsj1QhZGS/vRerxYSfK80dGJ7W7roQQnieHoRYYk0cSk0WVExnSgsR6/Cy7e/BleIw6R7WgRJIhYS2zCR38SdEtXT/40X/hOgrZru0DwzCXzIP4SrEz36NbXnm0eRhKN2Dnho6cvfHfBxhKmqLHGNt7pr8GQ5ERvQUaFKyztwUXHRwfKx1bMDH7Y5yUlLkvY661korGl2rJUfHqGCJLkODUrkyuQVe6glCEPrIK7wXBwG0gBTRc5p1UetIwfvZLKOMDwsdZwUyQ0nY/1hKgRFGaGvlS4etCBaW/U4ZQUC7ORlF99frorpGrL7LRppYrD92qxUFDql5m1v66fbmsfN7lw7my9P0O+dRdRj8FiJ0ydqHDtTBorzOS99qdk3mHPmgjv2GcXLFrfS0mWVhfOo0e9monrufjHRjdaeDBxiau6bPKO3MCFK7DFWUrk7tunVyDLAleX/9NMLRm+T1MhTa+tbZRjip5b3dm9gtUP4V24Hs6SEzEKFvgo0COYuCJDn4fil0MYPTe5+rcQdJ+IF0bWxQDcdhlutB2QAjxq5Yp5J9qiB0+IRUFdSgas4o89XZB0i3PDij3b2Hf5dJVFK9tEMVq9FgdFd7rooRhmN+EywaGwEXsWh+B8yHXg2gB5CkuP5SnqnV7GokOIsZjyK1NPZsx6h3nODLqMrDLlqbJjoMseQFoT1O68y0j77QNoLOh
 jD4u5HeC
 8Ln9R0nQsWHcF0RaF3k+3F6cy6Z0+nwy5TgwGoqmA8uil4cb5PVjun5x07WRNoo7IhRLE93fO2aUdh5wLtu34g5FrR9iXSM4vOKEFxLdKYkYljd8w3tY5sDfKtY47XHTT5hlWVzG+hYze6w+MsTR+gPl1JyBr1/K4G9z2tsJAhIp5p3Dkmw+InjT43AfvBnlWwgt9nbGr5q9Ta5jaFUqg27/uhUpSXe7D/Ty6hV7TuN22iITyXNjZ1srtC+BSO8gfLcOvdycnQUUyfZMLk5T5dLX6qqACkejJDoOnksgnliT2I8k/Tbi0lCcix5oEPfG0+PqgR3pfRiDmaRx3PVKljxvTCplK3h+B6nCjz488czwK9mVbuN7MpjXp0cUGiVVBR8T3bZOHGxin2JfM/vYZi4pPnGiMYGQ+Tbc2EozvWLBmoNpAbFD9NebM7eTuiVbR2y+el94zhBd2h2rNqL7KFSaGnzTCBkGCXmrToBue7mU3PNUaCWknyGMXXYqnoYgyeIWyLXzyKM7PF/qa9YCeQdc3TuABkWTjmf07VexH2NFwPZk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 25 Jul 2026 11:14:19 +0100 Matt Fleming <matt@readmodwrite.com> wrote:

> xas_try_split() adds __GFP_ACCOUNT for page-cache xa_nodes, but
> __folio_split() leaves the xa_state's xa_lru unset. That lets a live,
> memcg-charged xa_node exist without being linked into the mapping's
> shadow_nodes list_lru; when reclaim later walks the list_lru it trips
> VM_WARN_ON(!css_is_dying()).
> 
> Use mapping_set_update() to install both the workingset update callback
> and the shadow_nodes list_lru on the xa_state.

Thanks, I'll queue this as a hotfix.

Sashiko is wrong, methinks.  "Calling local_irq_disable() strictly
disables hardware interrupts" isn't true on PREEMPT_RT.

	https://sashiko.dev/#/patchset/20260725101419.3938406-1-matt@readmodwrite.com  

