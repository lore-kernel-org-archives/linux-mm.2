Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CB6EF588E3
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 15:37:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 705DE6B0088; Mon, 20 Apr 2026 11:37:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B5F66B0089; Mon, 20 Apr 2026 11:37:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A4E66B008A; Mon, 20 Apr 2026 11:37:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4943F6B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 11:37:07 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1435FE57E0
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 15:37:07 +0000 (UTC)
X-FDA: 84679337694.12.2921451
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2ED404000D
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 15:37:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TolJBDx7;
	spf=pass (imf27.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776699425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bhKXz21irPByGBa7VXYiJn8tYPqBAC8fQ5GrPsI59Tk=;
	b=KcJGooKzUDca019KmZj6eXCuqURrpOhLR9Acx0+D3Tzw3bDayIj7b1h8NXC9/Mssm+ewyX
	aOh7UKD5h+l4d4/QDbjiN4/GqKYrFDWovZ6T4ly2DRtWMMdJD4M19Ya1DvnESzY7DZ2fiT
	LwgIm2o/iqTwx7dcw6YT5MZBIQs+Xsw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TolJBDx7;
	spf=pass (imf27.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776699425; a=rsa-sha256;
	cv=none;
	b=kaB2BYTorG5ViZlpGIM9TnxcjZhMmXu4jHYRsINIzEmG/+2FW0PRK47rTRHD6NholhZmnd
	ZK3uRpzi4YeJy9LvIGydiVQT/4pi/yZA8JGpyY39tPKh8e5eHNV38nRv5Zyt6EvpvE0dBI
	HsBK1NbWht42NsvCa5xjFQRPvdIAFnY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776699422;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bhKXz21irPByGBa7VXYiJn8tYPqBAC8fQ5GrPsI59Tk=;
	b=TolJBDx7xE/H9YRYEOaaa2c59QbAENz915P8NEt1sDN2YLJOzN6LkfmvImpF9Dh5/0Xs6+
	gf9i+ca+ZqcN2IT85QX0vNIVoGwAprWrxdRqy8IuT2/vM2+BprjQmXu6llX+CEoU0R5Swi
	XILVICuLYFXBJDmwoW5IMq2RfMhlvs8=
From: Usama Arif <usama.arif@linux.dev>
To: Nico Pache <npache@redhat.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	byungchul@sk.com,
	catalin.marinas@arm.com,
	cl@gentwo.org,
	corbet@lwn.net,
	dave.hansen@linux.intel.com,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jack@suse.cz,
	jackmanb@google.com,
	jannh@google.com,
	jglisse@google.com,
	joshua.hahnjy@gmail.com,
	kas@kernel.org,
	lance.yang@linux.dev,
	Liam.Howlett@oracle.com,
	ljs@kernel.org,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	mhiramat@kernel.org,
	mhocko@suse.com,
	peterx@redhat.com,
	pfalcato@suse.de,
	rakie.kim@sk.com,
	raquini@redhat.com,
	rdunlap@infradead.org,
	richard.weiyang@gmail.com,
	rientjes@google.com,
	rostedt@goodmis.org,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shivankg@amd.com,
	sunnanyong@huawei.com,
	surenb@google.com,
	thomas.hellstrom@linux.intel.com,
	tiwai@suse.de,
	usamaarif642@gmail.com,
	vbabka@suse.cz,
	vishal.moola@gmail.com,
	wangkefeng.wang@huawei.com,
	will@kernel.org,
	willy@infradead.org,
	yang@os.amperecomputing.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	zokeefe@google.com
Subject: Re: [PATCH 7.2 v16 06/13] mm/khugepaged: skip collapsing mTHP to smaller orders
Date: Mon, 20 Apr 2026 08:36:40 -0700
Message-ID: <20260420153641.215894-1-usama.arif@linux.dev>
In-Reply-To: <20260419185750.260784-7-npache@redhat.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: o4qgxmcqb34xpymz4qopaasy8rsnyz53
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2ED404000D
X-HE-Tag: 1776699424-531638
X-HE-Meta: U2FsdGVkX19Ac7JwDJujKd4zD7slDc3M2QBnQTczYlY4AdYOEF2FkL8oblvxTHdDh7CxbmTAi+grs44/1R0wBQF1r956tqMUd8i9cxBPavKF1OEWCyNn3EkCqQAqdz4S4NwXGcMtvK33MxvWEg+u2TTF8Shkkq1ZyFHtX17RNCmV4hqiL1cWLJCAdg4P1ibVNc99Hmxg/X+VQgTcS3SSd8LHz+kKWUUHXhGuTp876OmKQVvw5o5mROU5pwtOfUVlw6G58JUIrukO7HRRYhQyO6cpknRaKPLC2SZZEF6BEqAgDt7q8lIU7ZeMMF8XWcSWLg6P9C421Bf9ad+ZLBv9bs9kL97rnL4+CAifJLGaMxJrlKTXAyk0woXfR63zgJ7Uk+xoqwAazIv9Zx1Jv5kuZGTnsIslTP4AvQDaeWaK4v56/b+MkDEUT37VZVynHoFTFQhRh7wrlMRQbjyqNJUZ0C97jYX14hdob1u4XtDYFXdxMMHzgp3HEpwNScDxom4Imnrdy4YDJb20bYQvIWrNcGecLOcBPCq8i/BkSz7dqgNai3czxI/A0N8HjbjUWi9PBUneDUzWiov6pQ4eKS3Ozf4+LRDwfQJ1gH/kXZyhTmU9FBXYj7E2N34J71hQLvIPZII7mlO+RuPMPe7pKVW5TgbPd7dydA0FByWmx7vmXVhBqW+4KQ52y2xMnNylhX3NZgXv964io6zH/7cPUpK0tnLtAqq5ZqzjoTEdDgpqVhy1yWyVfWnX6wC25w3HKvhXocUhHEkg5JcwvmUW3s6/exEH5TCTcXaZjroVIVgMcFM3t8L4GZVkHzATWTUr9wcgov25do9I1DtmliMClN2RUYfeQbCe5IHy60EBZ97QmDA8DmZA7/6tvhUuvSSr+zwJRDq5HsQFk+Oiheq+HUVvHntSHDrQFPNmcEncqVDCD3AhbrLxTGhXfEPSSDex54Bp9brLytqyR1gOS1+fIBr
 0BAMKB8m
 zJjLnpQalN3Gr9meNl10v53/FLVJY5xDZGkfvMsOtmjbzaFgG7AZTffK+8XCXgrgU4WAjYJugSH1bTdZ4+0HencHsVXPRHWM655Kj19l2nzl1qaaRCz3NGJw3d59FsR4HDU1bWAsostH46uXjLBMJ5r6IjA6aEY4yuI1uRNv3WzDpE7v3ibVhz0/XXHlyWZretnD2tWwc+kdciTxqNmNwnJnbetKe2lFCU0wkYKZySMrmFq0qOI3J8SRHG3Ij9hgw7rRSMUhlFyfaXLB9UGLwDAuLNsThQxlXXlGpeZr1Uv4uBkEmRI4kNHvceC9D9pSyVZPs6dKny0B0WNtuV3KuzL8QOaMdjYUHFUdzSHNP0DzGqVAOP7OZKSujylxtZBX1ieNyoKLaApXzL40=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 19 Apr 2026 12:57:43 -0600 Nico Pache <npache@redhat.com> wrote:

> khugepaged may try to collapse a mTHP to a smaller mTHP, resulting in
> some pages being unmapped. Skip these cases until we have a way to check
> if its ok to collapse to a smaller mTHP size (like in the case of a
> partially mapped folio). This check is also not done during the scan phase
> as the current collapse order is unknown at that time.
> 
> This patch is inspired by Dev Jain's work on khugepaged mTHP support [1].
> 
> [1] https://lore.kernel.org/lkml/20241216165105.56185-11-dev.jain@arm.com/
> 
> Reviewed-by: Lorenzo Stoakes <ljs@kernel.org> 
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Co-developed-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 

Acked-by: Usama Arif <usama.arif@linux.dev>
 

