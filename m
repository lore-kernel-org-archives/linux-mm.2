Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D470310FCAC9
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 18:51:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48D4B6B0088; Wed,  1 Apr 2026 14:51:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43E426B0089; Wed,  1 Apr 2026 14:51:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 354B86B008A; Wed,  1 Apr 2026 14:51:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 279176B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:51:41 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E14971B6E4E
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 18:51:40 +0000 (UTC)
X-FDA: 84610880760.10.D7B0383
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 104D5A000B
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 18:51:38 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="FGdDqaE/";
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775069499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2/x93cTqMzgKzKo7NdC66xuXcF3upnjPuMcb8NrXVDM=;
	b=LGQWMzqysNIQnl1i0L6vCpGYBw5V5jrfwjA0gRhDi00qSzSo5dofqJe27MgrsOnbvN+mW/
	MjSuiQBVhOMFSH+FULupoAX2YSpwHzW1WkUu5mj9EaxDYgu5TMm4PILaKBYPeoiA0+b/MU
	DP8gk6JV0uNeanW13z2j5zACBAtRAzE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="FGdDqaE/";
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775069499; a=rsa-sha256;
	cv=none;
	b=cAlldUB1YtLeuIqQSGuu5rW3tf8m9vrGmVYBZswFu3qJMgoBaK8KJ+wQguoJUh6PanCPk3
	USdTYvPFEyBZLcswO6uhN0WF4SBJB/rZ8/0Lg+DQr28EGVUUo78zOH1YsSm0fBTlkqPPvw
	41pEhgjgIZArA4ujnzRQLH3s19rzdhg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 21A3243B04;
	Wed,  1 Apr 2026 18:51:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABE51C4CEF7;
	Wed,  1 Apr 2026 18:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775069498;
	bh=2uWJMj3r0MZ0oqzNatIfZ8p/N+aYGDnHXLEESrphDXQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FGdDqaE/D/FmAk9cntlrbwEh3fEtBVRB0F5WcDmGGHy8v9P58md1DLQy8K4K9Tu7m
	 5Av4KtNqDVe1CZIehIXZcgGHpJ92y0emq9m+1i/KLNuReQcMqKfhx4zLoMql4YUtfg
	 XYIsoVRrBvYH57tP1mbdBm6VT7hGFFcoAAHbZHP5oYhx0ctRSXGwTTXmUc8d8j2GUc
	 DQOIkvunvxOMkIVtBV/1pKRWBI5kR3Xejsm9T91/IpYOp/i2d1THTEjUDVRXQ8wC9V
	 iuiqspBDmYtzuXEsCeeo8ji6JyJzXaSLa5EjghCIEf47TGOanI0bZ5RNhbP3EO5Gck
	 NuzB9E4tjUZCg==
Message-ID: <816a5813-3d2e-4d2b-9aa8-8ef20b3c6f7a@kernel.org>
Date: Wed, 1 Apr 2026 20:51:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable 1/1] mm: fix deferred split queue races during
 migration
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org
Cc: ljs@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 richard.weiyang@gmail.com, usama.arif@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kartikey406@gmail.com,
 syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com, stable@vger.kernel.org
References: <20260401131032.13011-1-lance.yang@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260401131032.13011-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 104D5A000B
X-Stat-Signature: rig46iz8x1rzgjr7x88o37dseo9guncx
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775069498-18659
X-HE-Meta: U2FsdGVkX1/mtM3I4vJCPNzFeY04fS2SzfB9ms1MqoEAtabQrpUlvWvLZtOwgqdOUmlxyVCT0P0HxApOsYdIlwxOF2taCsiPy5RqlZQPZx/MDltnlC8WsiSVxubCXndRDUoobN6gvoESBYXVcP9v/eH5qF+cRMvB0Uifx23ob8s+ktnZleIb5hFwn1IaNXuPtyh2gLF2+qFEKDwgixuiaSpTVdJYxN9WsqtvMtMU3uy521Ti5zooHJPB8g/t3f9zKTmt6djbwr2z9/jL510oaVRsdY1F2Xuh0bfljj79EQ9n6NcxfflND+UKTB5sWyBOMQcEMBKMWis/wzBvelWKzrkyhaaTXAUpczkUcQweU+OXzpYt0KeLTFWv2Ns+4fV3Wjep+UGSYSZb6+Mgvo04Dhdlqv6j4g6RN3ciSwe4mv3PofyhCUgU6B1QRsfLWsrzSXOOZH4WUhipo3oQ+Q6KP1n1OdMwJCDKa2TQrTfwyWXwzCqXM+yHvr+V1E4isf4WD6CQ6P/0XL3/16VlBzNzJ1exheyH49VG5RePqKojbGv1KQl0PBq1rh+poA6Cj7QmY2EsVYW9dFfH3OeQ906GVXRZF/pYqvBoGmzX4+srh0GNUqTSamlegWvz9S52S0mUPfLY5bL6H9g8PTyfkI+xeJ1lPTYZW/EVVIqUe4L2sBTZb533WXp4wCMG5l2my0tRi+RW0VPU46eyblcf4MJP2POAI6DPq9/09Rd4MNLSt+U6itjd7OFe3RgPfvqPJfM3BPD0jHDLOd3i6yhfxqHJ9zUifZAazoiq3mRi5Kv81hYRqKYuSiA60Na3yUuhKIAZM+F1RgZu0hwZeTk5QA875B7uB2eMYVw/mcQzRxymRDFhBcpC8p+2nxIZlHRBbENvKD96vbqqj7AmT4HBvuzFciLfay8UED0ZYO3Km3cExn20lkmfco7S+R1rONq9pK2WTLIpsuxPyp2/kNnWBuT
 eCKq9Ne9
 TQJ1AElypjnAAzBJtgGJ2oQjS6c4/ESwqEkEkd6D2uVYzfvXLlNhbJkFSjaGUoXGQeGwhT5jClDz2nlbk7v+V7jwlOyWNrUV3BsG+L7sME3hmMg2YXxl0RTingEuUUR0ynAls15A7jIUXigdIvhDyFNe5abL8CMLOwWZWRNC16WTvCdIK9AN/3A5I2IRxDUqOhNdaudBujdNIzGDE7c49cI9i3HTckKW1naGKCpXgz9r/m8mVh+4jSbqqkoWYHVJPof8tzIqVkx8c6aCyH7LSm5srKC7rjyKhFL/VTtGFDVBRoCOyGrmJn5GHh4PWXJ2u7b/QJqeXWCS52VH4XrMBL8YPjhsPk5uv5cAOX5nA8TzD/4EwTai0w7HDnztWOyyUBPz3uViyLT7+m/wrtQjjZ6Im7mYRV1hwlvHaG43W7eWYcnFwJCHEZGUU0gxg8NyKNF/B7QzS2RdSg5yEAp4WLUcIZGpf/1t1bMZG7cxxGrbIJHbPoN0W3N3KH8HZKlKlpb7gyQMficSVWD0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/1/26 15:10, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> migrate_folio_move() records the deferred split queue state from src and
> replays it on dst. Replaying it after remove_migration_ptes(src, dst, 0)
> makes dst visible before it is requeued, so a concurrent rmap-removal path
> can mark dst partially mapped and trip the WARN in deferred_split_folio().
> 
> Move the requeue before remove_migration_ptes() so dst is back on the
> deferred split queue before it becomes visible again.
> 
> Because migration still holds dst locked at that point, teach
> deferred_split_scan() to requeue a folio when folio_trylock() fails.
> Otherwise a fully mapped underused folio can be dequeued by the shrinker
> and silently lost from split_queue.
> 
> Link: https://syzkaller.appspot.com/bug?extid=a7067a757858ac8eb085
> Fixes: 8a8ca142a488 ("mm: migrate: requeue destination folio on deferred split queue")
> Reported-by: syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/linux-mm/69ccb65b.050a0220.183828.003a.GAE@google.com/
> Cc: <stable@vger.kernel.org>
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---

LGTM, thanks!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

