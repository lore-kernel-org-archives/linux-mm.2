Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD754CCD185
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 18:02:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12CA58E003D; Fri, 10 Oct 2025 14:02:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 104978E000A; Fri, 10 Oct 2025 14:02:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01A7F8E003D; Fri, 10 Oct 2025 14:02:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E31AF8E000A
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 14:02:24 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6FD591DFDA8
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 18:02:24 +0000 (UTC)
X-FDA: 83982974208.25.4F91D6D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id ABFC38001E
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 18:02:22 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XJ711jaz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of mcgrof@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mcgrof@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760119342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sJ2lObY+q0iCo+TWStLAV0Dy6ck4f+zlFATlIwWCuR8=;
	b=VI3SilflNue5cQSNH0k2/o3tNMdCiiZ4YioWezwdNdKcIOZLlT/5lzJpjRB+wE5kehwfhs
	4MmR6IvORYGTS6bUiSzccgQ4JLLrkuusMhEjiD/lPSYqjB6Z5c7n7ksob2a7FN5yUQGt+m
	fr0uJKPe24ko0lrazPqOBEwNSbEHd+w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760119342; a=rsa-sha256;
	cv=none;
	b=PpcngQBgT39YV55bStpSBS77SSVUewsBUWgP3+u3NTUx3ybPDfZYYNT1iNWO+DgsD4pmqk
	gnO6NOGNjdlyJaxBvvwxaP3EwqN0hCARftCCwD9R3/2S23bVpSUf+ehOqHcJkrNu7RtLKW
	55s3BnVRRhRSnTnLYmgvIo+Mib/G/Bo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XJ711jaz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of mcgrof@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mcgrof@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3CC1441523;
	Fri, 10 Oct 2025 18:02:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C0AC4CEF1;
	Fri, 10 Oct 2025 18:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760119341;
	bh=q+KisPcXt+RcWDp+7x7C81lpwJKvshUPJCuK/IXgIR4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XJ711jazmAFdHPqo8K3QuD9YSdSl4hkqsXZ6RP/lk4iOJmL9b06crvxk3hqsWwogu
	 cSzMOqdowJo1vLmtpIxn1DicZVfpHI5JmqVIcAF0zbXOvVvPoyICoXtbQpCZTO6Dku
	 kpDOEAQZ3lsHzn0duVhQsc2oC5WVL4dnGVfQI0vysv5yXbslxVEplhSIxdWFqVL9gW
	 cGyFymr3OQEXTUFKthpEzuxFgYi33Lgnog1dikBD5q/x+RuiHMxQoybV6zG8o+tEfx
	 Oh3wtxjEq0m32EuTT3f5gKFaVoIk1oq1hfBPNr20hWPs8oxiRFMxJ/zZSTsH/IJj4j
	 ycQ1f3S3fIymw==
Date: Fri, 10 Oct 2025 11:02:19 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: linmiaohe@huawei.com, david@redhat.com, jane.chu@oracle.com,
	kernel@pankajraghav.com,
	syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com, akpm@linux-foundation.org,
	nao.horiguchi@gmail.com,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 1/2] mm/huge_memory: do not change split_huge_page*()
 target order silently.
Message-ID: <aOlKK0b2Ht8FrDXS@bombadil.infradead.org>
References: <20251010173906.3128789-1-ziy@nvidia.com>
 <20251010173906.3128789-2-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251010173906.3128789-2-ziy@nvidia.com>
X-Rspamd-Server: rspam01
X-Stat-Signature: sje6iq1bg5r8at8cgztz4c8q183y8owq
X-Rspam-User: 
X-Rspamd-Queue-Id: ABFC38001E
X-HE-Tag: 1760119342-532488
X-HE-Meta: U2FsdGVkX18b+YlxIFghLYN4yMcTGWIKP6FdzeB8fGOL4ehRnUe1K+rAc3U1ZuaPYA8HI2mUCjxky8BK5mDWsRJXs7CO3PnQZFokIbCb9WFtE754a6irD/a83GxOLlV6yUmgg47CTSIOO6PH2mZn+w/HrylA8+N0Oc4pqbCQ5cAoliuqnz6Ye5XOobHtDvYbZYMn0SX8lvop1g3/4d/nNER5aj5+yAHvp8Rv2mZ+6/JC5ItFGtF37UoyXa0ckx2SYvJWMyQNsv7OIoRVQ4nXRUaGA9qyWd4y+ijhAnvYmMI5oQbN5yhYnkUzipNww2J7f9BmruVbX8VrkhRxVsnPDn8DEXMe6L2lLWK3PjUK5/o4urduBsqDhSluLnyJ8yMHW/RO2Rv3laPJrh/DQ7RsUxcC75I93wnWDNIkv+pOtMCh2896XwAnikyEGInc+O4/KUBZ3BT08xiFHpqUjlEeo3SdMhFOCj6+4hNxaIgkQRH5GGpbxWU7r+fM5u8pn9jkSb9RR5YITDSNu3i0CshFRPW6NKxc/8ULgB/KNIKaT1l28bqkrvz65K9b2S9z3UWnVoWT7f9mMue/tLkfr0rZgzbjAfMsfgFql0qH7NrC6KJqDgxb3eFuf/f+mHsZ7JBzebqHFn+YjntlnGFFQPBY4Bp3Y9V+Pp4VB3K+00+8IAj5004DXCHe51pWANGNpKF/qy+zCLVmtKYguItC91s2EFzj+iyuDEU1sUfwOeDolVoHYOsqA9MeKKEzOGysZNGgWjLgrlLjB0ziFJkfk14OoSZ847Hni3Ihfhwux88weTHOQx6jrUgBUzjQAF6kdvBoCJsT7fsi2+eT2GzuLWdDmGh8lYzvQRxWk/hxp/JoutPMW764UNmMhd6vW+joUgYcBxqOOx4duy5vwdQctHGRs9SI89QyDOCud4mRFEtG46335tBmnpMGYozZPeN8/wA12QZ9rf1Gjw++1Y6xbqn
 cR24kO+u
 +QW4ePN22EqsZlyQkuEDxJSaHpDKujmIJVIB7BNN/18edoTEhhcbx0liWJoEAoDZeW5Kd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 10, 2025 at 01:39:05PM -0400, Zi Yan wrote:
> Page cache folios from a file system that support large block size (LBS)
> can have minimal folio order greater than 0, thus a high order folio might
> not be able to be split down to order-0. Commit e220917fa507 ("mm: split a
> folio in minimum folio order chunks") bumps the target order of
> split_huge_page*() to the minimum allowed order when splitting a LBS folio.
> This causes confusion for some split_huge_page*() callers like memory
> failure handling code, since they expect after-split folios all have
> order-0 when split succeeds but in really get min_order_for_split() order
> folios.
> 
> Fix it by failing a split if the folio cannot be split to the target order.
> 
> Fixes: e220917fa507 ("mm: split a folio in minimum folio order chunks")
> [The test poisons LBS folios, which cannot be split to order-0 folios, and
> also tries to poison all memory. The non split LBS folios take more memory
> than the test anticipated, leading to OOM. The patch fixed the kernel
> warning and the test needs some change to avoid OOM.]
> Reported-by: syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/68d2c943.a70a0220.1b52b.02b3.GAE@google.com/
> Signed-off-by: Zi Yan <ziy@nvidia.com>

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>

  Luis

