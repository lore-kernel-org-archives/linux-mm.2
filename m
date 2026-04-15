Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31DC4F41998
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 13:19:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C83F6B0005; Wed, 15 Apr 2026 09:19:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29FC76B0088; Wed, 15 Apr 2026 09:19:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DC216B0089; Wed, 15 Apr 2026 09:19:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1171B6B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 09:19:17 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8C661E04BB
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 13:19:16 +0000 (UTC)
X-FDA: 84660846312.11.9A81BE7
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id D5038A000F
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 13:19:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=cTsWp3lK;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf15.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776259154; a=rsa-sha256;
	cv=none;
	b=y/H9nfI8f8BVJDjj6sPKo2gxmtuuyusYGlCmSqasQoCjcqjFPFP/gKj8CDwetn2MESHppq
	L/29ZGWD3l4STP78du/T4Evzxfy6VnhfTx1+sKn7MG15MSh3OQrpDyJTdjmOQKFlzwhnWF
	4EmqR1Tw/Ur3D4q+lzkivuAuBkxrL+k=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=cTsWp3lK;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf15.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776259154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=orY6koiAJaNJGnwmy/hv4MlDyhppHnSuDXJ/omxV6HM=;
	b=ZWFQxI1b20PfpoJ0Uda40zK0VnDx2CoIvdNhGgaK1XGr9hv9/3pB2wIhCjGVHDO5aRHrxs
	z8xeoGFQkJ6ttIrPfACfgdELqSylF49YiNj2PWlar4kxLKOMKmrh1W3QU0d+6h7K/svFjE
	NVjmZGaW2XkbM2DVLB6rwU8/e/Tpaw4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=orY6koiAJaNJGnwmy/hv4MlDyhppHnSuDXJ/omxV6HM=; b=cTsWp3lKKMHyGaOX1tBCXsBfvP
	BMZB5NncQ90AOdtdmQlKCI3ihoRE64ilhTCAlPLvIBXKnjyaURFD5I/tKITPjL09Ez6gGG+Ed2TmY
	itAW3JQd5ZB56jAD49XacwFMyIbfzSk5RwvQ6ieoKPBnbXr1uMvHPTS8qWKEDZqbizPH+YNEggTpO
	2sfHTIyVwSM3GAEEwQVaucksjZHTABfr5JhexMmo90VH6WkS3VltIy+6YXp3oCoca8xN5W2cb7AO9
	XKLz7GJeWKr0jE8R59VSDS313GzG/TpIYAjwjqfXDfzq6vHA43v35IeD3ICmyC4BfduFHl5ej5/jV
	VTvjJ5QQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wD08x-0000000HU0R-3bxe;
	Wed, 15 Apr 2026 13:18:59 +0000
Date: Wed, 15 Apr 2026 14:18:59 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Anatoly Stepanov <stepanov.anatoly@huawei.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com, zuoze1@huawei.com, artem.kuzin@huawei.com,
	gutierrez.asier@huawei-partners.com, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] Use high-order folios in mmap sync RA
Message-ID: <ad-QQwctxvJVHW4U@casper.infradead.org>
References: <20260415192853.3470423-1-stepanov.anatoly@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260415192853.3470423-1-stepanov.anatoly@huawei.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D5038A000F
X-Stat-Signature: azgp5mduan6oouw98fbjmnsr8ffm8zu6
X-HE-Tag: 1776259153-410464
X-HE-Meta: U2FsdGVkX188LHhZc+o1qYcd22tX6ILMEQsmLOEaSLAZDq4q1bAMP/SIz7yk/f8hvoBAa7kZgR72OIuAAB2wdXtu7HkumAoZ9pvC0P92dDNZoxby2XFPbr6tF2e60B1ZUqiDb31JrS9R5ps+1EVm6bnnToWPEbMxdiGu8aQLrnI/pMNAYHkKNu/8E8DA6lpxN7CeWK1gnD25RVxhhOZ44s2JOKnMNoC/7BRJBEXu8dHfVnq7VlDKe31uOrntMjzeWSQFx+tIs5hzSWPKBuVmcpqhrZDOCdO5T1bnNKBSzixht5OiBZaOalNPA9DAvsP9bZKvKtdhHuWeX4cIXOu0sX/OTf7DkYsg6z8KKZ9sjhWnq+YtSEVPRWBu+t1Qfp+T90CWzsWLt+ZECV6i1tx38op4uzAAUKxzlC3UhgA12IVHAtP8V1/vouGftZx1Dipe7P+xMKINBtm9xXJ+NDqd26NRekpcx5/bZ+dLXZsDzHpaxDq3ghaIlGRPqC7/BBmE6V7m6YTO7Y7vKcuhQDXQtgEchq+o3VYFYDjE0KbxGysB5qItiaVEZIHHKS+80itFGJbVdLyIBTm+EWLorptfu3GbEcRX5F9u8WB3GdU73wFZJN1lyibTCIcuupZPtKX8z0CbKsat5GEvIGqnRFWPebpmkAgWFB3lKYNFIwBEVECfyC/7fcq0I16lA8/9S2897sjcn6RblObh5HuoWdxsKVje1r3HnMLuRwsPvO/YdmDTxjnY9pXhwvYtJAHtFaLGVJLwI9efn6HU78prbzWM6o45kBKOWqUG/ucGb/W9MQKVaLfZrmlHx4Rxc/GIODTzN/x/fUZWAmu1fWihlMMQwn6581UwJ8+ZYDCLK+38Ot0R6gTcxoMnPPcav2hZFejZgWSj5U1Jb+ijZf3fmsOIUVXQv+7of08ca3IxbVasKuO4elVaMJ8reM+G4oJimB8qpEWI3sudJAm4OlGGGCU
 VZ1AJrcu
 78hulHQfWMTgkKzuhwUWKjX3DBTYtK0QSi2ety18POyGvr+VsMtxuqBDn8F0j906xZob+K8833qdsLvvZZOs7pBuUo6Uh8YghcYJViPZPjNcigUoHGRWRPkGhAYA4o+3wxyMIab8e3kPFV+B4FVo4kTCj3jOzPLcPvf+N6VOBKO9azXxhct3xptOy7bL8pwiCgD3my/N0lyi5TeDVnijCNElJ6rTdTEnT8Gcre6foqZDb5X/yq6DeOYb41B/BVzHTLEoA4yqpKwn/PrN+u2HpKvRbHA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16, 2026 at 03:28:51AM +0800, Anatoly Stepanov wrote:
> When "fault around" is enabled, 0-order folios might significantly
> slowdown filemap_map_pages().

There's a lot of "might" in this patchset.  I'd like to know that there
is a real workload that benefits from this, and if so by how much.

You raise an interesting point that faultaround may be slow, and maybe
we should start out with 0 faultaround until we've determined (somehow)
that faultaround would be beneficial for this particular mapping.  Like
we adjust the readahead window.

> For example when async RA won't be able to start,
> we might end up with a large mmap'ed file with 0-orders.

That is a feature, not a bug.  If access is random, then we don't want
to do any async readahead because we don't know where the next access
will be.  We just end up occupying large chunks of memory with
never-used data.


