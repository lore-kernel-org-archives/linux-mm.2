Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B71E6CD4F21
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 22:03:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F020E6B00A7; Tue, 12 May 2026 18:03:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB2656B00A9; Tue, 12 May 2026 18:03:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF0076B00AA; Tue, 12 May 2026 18:03:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D28676B00A7
	for <linux-mm@kvack.org>; Tue, 12 May 2026 18:03:43 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7DB581A05F8
	for <linux-mm@kvack.org>; Tue, 12 May 2026 22:03:43 +0000 (UTC)
X-FDA: 84760145526.04.70FCF77
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id DC0608000F
	for <linux-mm@kvack.org>; Tue, 12 May 2026 22:03:41 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=T4o3pel7;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778623421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZhPBSIHra0vFIWdPUrD/Njm5qzxfWkRa4Qa6BDpAoso=;
	b=47qSIok7IayLY8hxZBNb0LE2XU1R9BuLImrGc6NvRges2a2JBr2qnL4J5a0jeemIB4tALs
	tbexIBkmFx4h55K1QUkXZ1Wp4/GHdLHUbhZGyD8DvOOu9p7rukm76jyzG7uC1pciYuKUF7
	3MH/I7sfnPciFjw4EaaS/HYrmMABEbo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=T4o3pel7;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778623421; a=rsa-sha256;
	cv=none;
	b=04uJcNi9vkIHcbLOPnzG3T6d5QlWBdvSiIlNSv1eHCZzQJD3K8+HLJx8wQ70BSqX4gTtlF
	2arbJ1gQVnx9y8HRMZDjHDSRZwg1h6jCcxWoEejLOG+jcRIpmK7yGwCMPP2RwDml6mlAIH
	pZJVlCf+4p+Fgt5fMMBZPKWD0KfEPiY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 51422600CB;
	Tue, 12 May 2026 22:03:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB07CC2BCB0;
	Tue, 12 May 2026 22:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778623421;
	bh=PMBxXTOyhIbf5h7jETfZzmAx7cE7H+742mFIV8K+mI0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=T4o3pel74ki5lb+QT8HOdIrQtEGla5kb/L2PBSrfkRLDOfF+w347Hr/V4Z1xvGdzy
	 ykVuyD1VUPxpezth7FPAgd5mZpBtO2uSeFlsmhGl4vDgv3hWHgKh7UHZ+arSwpfIrf
	 CjzH2AzXfYzJGRS3FEkZ9RTVwqZAYmJ7+8rWVTcQ=
Date: Tue, 12 May 2026 15:03:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hongling Zeng <zenghongling@kylinos.cn>
Cc: dennis@kernel.org, tj@kernel.org, cl@gentwo.org, linux-mm@kvack.org,
 kernel@vger.kernel.org, zhongling0719@126.com
Subject: Re: [PATCH RESEND v2] mm/percpu-internal.h: optimise pcpu_chunk
 struct to save  memory
Message-Id: <20260512150340.c8ae97f9299918a1f12f3e7d@linux-foundation.org>
In-Reply-To: <20260511070309.44044-1-zenghongling@kylinos.cn>
References: <20260511070309.44044-1-zenghongling@kylinos.cn>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DC0608000F
X-Rspam-User: 
X-Stat-Signature: g9us3anuppft1wuja7qrgiuxangtwo5r
X-HE-Tag: 1778623421-831078
X-HE-Meta: U2FsdGVkX19I1ILkZRwp20RsKbnZMuvezTUjurZ0TCqT/WvW3s+2oPM34PqdRf7caQW02k1NNlYoKp7oljAnIcvJ3CCeCWx7Vfb23aFFDVh+JMeSymyngoC9nCb1R37H8oNJDPCUI2QRt+2L1gn8geJSKEaCaE3dG5ZaBKns/Y+WRbZ9NebrGshDzSm4qphYAU16tQg8SICzqhXGCYvjoQPceZdUD6bml93g2O8A94q0xBX1vWk+PNXtTwa9Dx694BXwTRNKOFbhuQp8L4jRHP6/iMCazumjMt5hgMgMB1mQPyXjRmBi7fHeZbOyr4xHVVQrSMNk1hCM8w2bOKHtgFdJ8vEWrT5MN83l+ZdI/YZrvaYfOc5yYAsmzpszR9WBG+xgA9D6AZSowNa5SvenwA/BoDRaMIpeNeTkf8DvZ/44SheBT+8r3ibFPrWsXMER9bGAqlU4ROTuMVLUDNXu6RVjvM1xBBN280KRNAkUyF9ABgHE9av+0GnIprr9TUwUBu2Q0tdtTvMHgpfBAOpx7cJY5+PcO3vEpBGBXDBIPWIhpvegyXGM1+fNmtoxu2qOGRzV7HHCd7bNMbAGtYqCGn2aA67GXY5hMuY/e5cHY1utKpKRFRvNx6ETkxVj/XgQ0sGGS3qHmA31xmjuSOCuUF3a/RCxr+x0a0NHbQ4UqlMjH1najMButTJQ7oOqHzYksnPVyWPr0yCk6Sk8OXwCtoy7EPZDltxusxS7efu9MQRhi6EuFSyt7q6TSGrJpy2AuEcxx6/kOzZvakeLRcbTqU5RpSrPJ72otTL39RXEmpxHFAcfTK7riRmy2ogGBqnlqJES/JLLP2wCKnC6nkAJNi8z9cJJbQzLr4hyALyWhdYCsKBP0C8kI4Uzq0OZsVRTf31w4WPbGUliOpChxXxZf2GslK4wmHWplM3XCyA+AZJGs9FMJXV/F6C0YVTq6hS0KjikGi/14tzOi3xCSNq
 5d7sDAyE
 RZ4ka6sDyIDU0UMMlCnQiWU0ePtjNpx+jnkREKMlkX4s4EXiYlS/n6CR/C17JfUL+JQCfCQaiX5w3mn+nvUmPmKByrRkAe4001kDN8ax5undEzsiai9YN7rAYQhANIRBpxTAxuP+68ypUETNWew2CLG7GJrhp+Tfq7oI+ORkGG5658KioscsVcey/HGogo8OLlw4opp74PgRYCPr5zAvBsH0X7DnSKAP/t0DWaZYLxKp/76fix3EpcS8PSkM1GvmB2X6TCOZqZYY8DAzZKLe0FyXHNveWUrJOPCHCX5xB7trzlXWDO+qz/O/9zURZukkQU3dAAmv1tWSm0og=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 11 May 2026 15:03:09 +0800 Hongling Zeng <zenghongling@kylinos.cn> wrote:

> Using pahole, we can see that there are some padding holes
> in the current pcpu_chunk structure,Adjusting the layout of pcpu_chunk
> can reduce these holes,decreasing its size from 192 bytes to 128 bytes
> and eliminating a wasted cache line.
> 
> With allmodconfig (CONFIG_PERCPU_STATS + NEED_PCPUOBJ_EXT)
> Before:
>  /* size: 256, cachelines: 4, members: 19 */
> 
> After:
>  /* size: 192, cachelines: 3, members: 19 */

Thanks, I'll add this to mm.git for testing, but I'm not planning on
taking it further until Dennis has taken a look.


