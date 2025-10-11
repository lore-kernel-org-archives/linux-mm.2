Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 700C5CCA476
	for <linux-mm@archiver.kernel.org>; Sat, 11 Oct 2025 18:19:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A5188E0005; Sat, 11 Oct 2025 14:19:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 680DB8E0002; Sat, 11 Oct 2025 14:19:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BA268E0005; Sat, 11 Oct 2025 14:19:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 493438E0002
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 14:19:03 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D9F9A11ABF9
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 18:19:02 +0000 (UTC)
X-FDA: 83986644924.05.14BA212
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 370DEC0002
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 18:19:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DmGGkDAW;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760206741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wagXGbptnC356sZgaWJU9hcbYnQX+Z4ER7umWhQ2i3c=;
	b=C4OHZQ45AmiKfSaYPiiKpIvZYh8RtedbhvXdZA+VaXXlXt0lcehrAaDOYqk/gAsHv5lOq1
	i/pq+QlWrOMLB4vEkkmw/bOZgQr1Fg206FTlyf3VMhsOwo+60CIQAlULKPas6s7YRPpmyM
	HXHHNbRdgdjyQsRv1wnaTYfw3DBTpFA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DmGGkDAW;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760206741; a=rsa-sha256;
	cv=none;
	b=LRmwbUVjlqlXxR6HTL6pXU9/Ez4rxsbhWG6lBtwVMS/resN4GijSwTWBKNXL05N5rJaJgh
	e4D8fvxcw4tVDm0MejIcIuJvcOcwBLxe4NjVZ5Nwk4bc6jv3dL444sd6GVwx3wAVHk58aP
	GxgRkLH0NexO/RQB8YTxbDYSW5VEY7w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4787E6045E;
	Sat, 11 Oct 2025 18:19:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53A3CC4CEF4;
	Sat, 11 Oct 2025 18:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760206739;
	bh=MPdjkQnoZTr/N788IvZN1eosYtsrWQ4gFL5Wool50+I=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=DmGGkDAWyxw6viSxHi+wXwHoIs/wtxfbFrp8PXdOaFKdhHAkvu640pgNrP1RuzKPX
	 rd64pTypgtTSHWy/PY7AV4KGqcwGqw74ou1UGkZekuM1MP/fL7rCqfc1RnbghdfCKl
	 ZyScDxgh35p+cvheSFmMIKwnMBMwtAqhDjC8zWP0=
Date: Sat, 11 Oct 2025 11:18:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Cc: david@redhat.com, lorenzo.stoakes@oracle.com, linmiaohe@huawei.com,
 tony.luck@intel.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, nao.horiguchi@gmail.com,
 farrah.chen@intel.com, jiaqiyan@google.com, lance.yang@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] mm: prevent poison consumption when splitting
 THP
Message-Id: <20251011111858.952f08213da2a9018cfbe2b3@linux-foundation.org>
In-Reply-To: <20251011075520.320862-1-qiuxu.zhuo@intel.com>
References: <20250928032842.1399147-1-qiuxu.zhuo@intel.com>
	<20251011075520.320862-1-qiuxu.zhuo@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 370DEC0002
X-Stat-Signature: wz8im63qjfoyifg6qm1tuw6e81a9t9qt
X-Rspam-User: 
X-HE-Tag: 1760206741-952847
X-HE-Meta: U2FsdGVkX18TbjcMRVv+4p/Lpg1Lay3BC1blBirqigdj00msoUrNS1eJEwxpNAzGqQ6wZll1fzrJL+cO+rCCTEFD209EdvyqSCaPKMg5aaIR5Uxntrw6r0Ztr5bljQIp5iVXWpaUWRblBY+YihrDKn1WfDDvb5nnfKktIPsXMQSXxBldj/7pxEtvDUZ5rjBOx59U/45dl4jal1fhMHAcoBH9ULsc5Wxr8y5oPJ9Gzd9l89enBF3b7tch8yb7R2SRyPfgHzLAYiqWCzBEkH1xARmb3esL1ArEEtrm5IGKhORm1GENumMdOpkr1EfLSQAn6biFm/H1vTmgEh2SzfZcSoxt964GJCiH3GRCINooeZvd1yss49XsgIFysr+RfkzahrK2DWGY71fxA+aWI16MUpnDPH5LluS/8R0IrvDzsQho/ZvDcvsugrtwfIEP17SKMkrbulYQ4iDBdTLTukVOe5ITvQC8dEMQk9vRtqbgpuoP4dLfdXFEr8QHwS+3elywBXUHhABP3UnOt8fkmtnnit4De95xcpXcbdBGqhjB43/H0JCpwY5M2HKosr8zOJveTbnDdY5DanhN14kBIlZpR35Qc9a0N7v0fYinUx38BvzaeQzbfe3f1CLoRsdUhx44BkN55KZ4KHuPh2t3oVzx8XfFIksJKk4DlHbyALoQXkr3MKmfNA5v3+yDG3/AD8td87CGxBbyvAaaTReUUk5CKsJJywmwmjmoc+6kdSqq2XzSlUBHwqSwjTeULJiY+4gflN6qzvxHmlISMjgGtvE72vabeWudtI5WDoNDV+GfS3sxIi/gTIqU0odKXKsu2kPVLfA6+nq475KDT/Qx5tvsEkwv7w/Uf3Xzuj0ew1+lSUgP4R46ZmB++f9pWduHxIHjyOzSk1lXKyTMkt1xEwqasBR/YaQ3W78jqf1FSp/lanH18zB+GuLx3qOVA6FuIZJVm0bYLXXYFC1CtSl7qhE
 y/nqdRAh
 Kjl7HZIZnrKtRvAgBjOQssp1UtYo0Vjhyo5PTJZTEg2yiPrMJqQdtk9LkAtNcdNpUCMslFlyNUcuxZ6XgyXJLEB36Eqk7nuJGTsRbnZtq1f9HYrZsraeTg2RlPMC00XlPT7ln9J0iEdJAWm7JwQ1yYw/ONXEPHZyC8QNjBGv6paLVuvMiXk0t3EyOGrwdblHZ3QJSL+mRGNvtGMDhb/4BcqglK7r4aMa/ciSuZZxGNrQxS3Arm1FVIMbexOglkB7Ch76hhUmHcG60/eBKXm/1RCdaG8WiL0CoQbXebFTiU+Ah1fwe5PVm81DZP0KLpo+xcN74D+srOpfbm1W4wshmu30MIDxDp1mA22lgrIMGNwvOsZE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 11 Oct 2025 15:55:19 +0800 Qiuxu Zhuo <qiuxu.zhuo@intel.com> wrote:

> When performing memory error injection on a THP (Transparent Huge Page)
> mapped to userspace on an x86 server, the kernel panics with the following
> trace. The expected behavior is to terminate the affected process instead
> of panicking the kernel, as the x86 Machine Check code can recover from an
> in-userspace #MC.
> 
>   mce: [Hardware Error]: CPU 0: Machine Check Exception: f Bank 3: bd80000000070134
>   mce: [Hardware Error]: RIP 10:<ffffffff8372f8bc> {memchr_inv+0x4c/0xf0}
>   mce: [Hardware Error]: TSC afff7bbff88a ADDR 1d301b000 MISC 80 PPIN 1e741e77539027db
>   mce: [Hardware Error]: PROCESSOR 0:d06d0 TIME 1758093249 SOCKET 0 APIC 0 microcode 80000320
>   mce: [Hardware Error]: Run the above through 'mcelog --ascii'
>   mce: [Hardware Error]: Machine check: Data load in unrecoverable area of kernel
>   Kernel panic - not syncing: Fatal local machine check
> 
> The root cause of this panic is that handling a memory failure triggered by
> an in-userspace #MC necessitates splitting the THP. The splitting process
> employs a mechanism, implemented in try_to_map_unused_to_zeropage(), which
> reads the sub-pages of the THP to identify zero-filled pages. However,
> reading the sub-pages results in a second in-kernel #MC,

Well that sounds dumb.  To me this suggests a lack of selftesting code.
Perhaps someone could prepare a test for this case.

> occurring before
> the initial memory_failure() completes, ultimately leading to a kernel
> panic. See the kernel panic call trace on the two #MCs.
> 
> ...
>
> Reported-by: Farrah Chen <farrah.chen@intel.com>
> Suggested-by: David Hildenbrand <david@redhat.com>
> Tested-by: Farrah Chen <farrah.chen@intel.com>
> Tested-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
> Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

Yes please, a Fixes: would be good.

> +	if (folio_contain_hwpoisoned_page(folio))

Offtopic, that should have been "folio_contains_hwpoisoned_page".



