Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 453F2C87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 23:29:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A77EB6B007B; Fri, 25 Jul 2025 19:29:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A50096B0089; Fri, 25 Jul 2025 19:29:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B49C6B0092; Fri, 25 Jul 2025 19:29:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9298D6B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 19:29:18 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D3A961A098A
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 23:29:17 +0000 (UTC)
X-FDA: 83704380354.10.FBE6453
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 564B040002
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 23:29:16 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=juXMQ+hR;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753486156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E28miUOt3IoVgflcrHHHqc+kmbtbPFDdzOXN9QZRsLM=;
	b=OBnjbV00tgDoFnDzV61jJa31XPWDR+bHhtTfFNJT1gLTxgq2eIdb54WNV4Sr9xKxThHFWU
	77sXK9xaEA/1itnSXagpc7vSPB8kl97GbKnan17fT0clpRK4tUPMHJnSlbSGHi4dMJIIrw
	Oe5JJ7kAzvh5csaAgC8a53YCbptUjnk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753486156; a=rsa-sha256;
	cv=none;
	b=3l3Bg0rldupNtLv7CQtyZ969iV8eW7vZuQnjbwogWdI4jdMUmZUSYfnupEvW32k09cMoQr
	ujJBCElOtn9uy+I2avQlwQzTJv8ktLbH4p5Ds24NKtUugdoqfR2QRCZkh4r0iXCqEHWm3j
	S5wWSdCLn3N1SZWvZ7QXv9pvjNLOqCU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=juXMQ+hR;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6BC33601DC;
	Fri, 25 Jul 2025 23:29:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6059BC4CEE7;
	Fri, 25 Jul 2025 23:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753486155;
	bh=Ue/oc9CczBRUT94O9K4iabIwDmOGkWuBOTBAj7/504w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=juXMQ+hR8u7of2YddrxLgmJWdlDaztSFcHXZJGu3KsrI07QrKldKez7JT+vEJqRxS
	 30/q1aVLfgiP2/DSc0J35svPdqSLOkPtJd6W8YxovgeyTMI9GKUI+kHWGvfD/PVv/u
	 vjfopHQQJG2I5ZP1x+wecue6BQZPAL4hY9vUDT/Y=
Date: Fri, 25 Jul 2025 16:29:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: <andrii@kernel.org>, <avagin@gmail.com>,
 <baolin.wang@linux.alibaba.com>, <brahmajit.xyz@gmail.com>,
 <catalin.marinas@arm.com>, <christophe.leroy@csgroup.eu>,
 <david@redhat.com>, <dev.jain@arm.com>, <hughd@google.com>,
 <joern@logfs.org>, <linux-mm@kvack.org>, <lorenzo.stoakes@oracle.com>,
 <mhocko@suse.com>, <rientjes@google.com>, <ryan.roberts@arm.com>,
 <superman.xpt@gmail.com>, <thiago.bauermann@linaro.org>,
 <wangkefeng.wang@huawei.com>
Subject: Re: [PATCH] mm/memory-failure: hold PTL in hwpoison_hugetlb_range
Message-Id: <20250725162913.5ab54fa56b8b67c749cff948@linux-foundation.org>
In-Reply-To: <20250725033112.2690158-1-tujinjiang@huawei.com>
References: <20250724090958.455887-1-tujinjiang@huawei.com>
	<20250725033112.2690158-1-tujinjiang@huawei.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 564B040002
X-Stat-Signature: tiapqfg9rusfbbzbz51mtzjpscf4t4jy
X-Rspam-User: 
X-HE-Tag: 1753486156-580501
X-HE-Meta: U2FsdGVkX18w17rUGNTh3W8rYpxjOsozxEaQHoAeO1YsjlW3Fx4MGSBF1hx3jJMsA3qL7RaKGqLcIwzktUDfTmeJbXhhfXS+iv5HOhVnusFozhQIc6aloDqkZ/8ee+21e6egqNjCvCIWemsGht3lP0OSQE8K8iV8TdV8JXfZRhVyQ+mhcaOpLHzXzCCGeKLyPm/Y7lhHniNQapdzPX/Vf9loquoPw63QE9OG4anu90sJBElsIqtumu28Uyae8sPY+lgjh8imqYDc+IhT8Dn7l3Au0WKz5Lb1FmmcO8HDkil5T8EA6eEmAruuH4sO0deaXUxVsUDg2Pnz/s0nwZjz55NsiGcGm0RnOVcCuF2Cs50U/BcxTiyGoENsJPvMXXznaGCK3VRtMc+PnEtTlWZ2KNHK+7ruxpTNG7ipqpEjkeTffz1vJsYAfMrsHi6LjOL4OfbI3pjzVFCB/WhemeyT6B04cXenqtUW6B7HyZfMHIjTJJh2deE6ZsxdvGJxE3yjazXb/kpfsSLDKfZ1bEUwThNzL/xoJmx7WbI+x8nL4Kgm4vLNrrNlmQ2ooKL8WcT0sdt/BURpgAXPemm9kbJtIqFioDX5aZYE/7Aw5/n8SlYTrj9PQEgEiWzxWetMYhvZrksZKjoQp7rmgIRrnODySjn8fpS95PrEuMf0hsC1HWku9y8TkrIYGlsdHVo0h8EDLmAhQ+n4CrFysRjlC1GKvoQMRkwJwBhPqGa3aSdrAQw/x/ta+nl17GWGwRwFNb+XKZXUSCAvOyn/MkA+TPxpMKht0GP4Zc7HfvYRCy1nDDayj4JkTLyZk3lDgCLkO16Pvrt4h4fdouHH3q1bk9vpXv8+WTQuN6qXggnAjpwmJ62dO/y3+b0/FRT6iGImnxle/0xaHLq2zm/OfC9vwvCgkwajZqu+s5yhEO814r0LCBcyqns0vbaMJBZ7oxnrWPip0M3PtFukb+gRbk74fdE
 SpBxt4/T
 FwTyWhFHwyr05Fm8ebx/cL5qDKjkKrLGYjo2z7paxC8eHTHbmAbjV2PEzLL5IxPUZnvI0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 25 Jul 2025 11:31:12 +0800 Jinjiang Tu <tujinjiang@huawei.com> wrote:

> Hold PTL in hwpoison_hugetlb_range() to avoid operating on stale page, as
> hwpoison_pte_range() have done.

Does this fix any known runtime issues?  Or is it expected to?

In other words, do we have reason to backport this fix into earlier
kernels?


