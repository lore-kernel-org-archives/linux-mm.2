Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06A0ECA0EEB
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 07:18:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73BB48E0239; Sat, 16 Aug 2025 03:18:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C53E8E000B; Sat, 16 Aug 2025 03:18:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 602228E0239; Sat, 16 Aug 2025 03:18:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4BC228E000B
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 03:18:17 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E9FD682F6A
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 07:18:16 +0000 (UTC)
X-FDA: 83781766992.29.410AF79
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 42C341C0005
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 07:18:15 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ql9nwuPb;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755328695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zWKSziyKTRjMjr73pZyW9gO0+wThuyp8f8idig0z2eM=;
	b=LbIN8krommpIvQ+jpsBEvMO7BV47OOmACoKbNemR6hwPhleibbh6uGqmMlGyPd3NRVUML0
	cCa07iwVyyWshCcN6BW0evbf6EPsm0cQUx412ONvLXiRrU1wSgQulKLFF0H6FbioQeBlqm
	JWZchujIloDd/O/Uti+113BSHqiE+uU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ql9nwuPb;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755328695; a=rsa-sha256;
	cv=none;
	b=0iH71doXBW12MXhPQRQ3kI+oYkO2Jz+43kaAZ/c8zHGp0vpRHe/yFsuMGnx9UlhXSa63hM
	KeXAHTTfDkxZTTp09psBEVMWgFv01iAWv4W869DBSWC3QjTfJLDrK9gE5dEo26/nKLLwoX
	sgcOSM9n0DZT2V6t9YVMXJrCJLKoJEY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C239F41B01;
	Sat, 16 Aug 2025 07:18:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A72DAC4CEEF;
	Sat, 16 Aug 2025 07:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755328691;
	bh=q7lddxms9eupJ7WiYrtxfLZxSThMQpeabpqIdNlchos=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ql9nwuPbRojAVr6LruQl/nLasMVeCeQMU5r47hx4ztR7/EgANnPh3vctind0ilMLo
	 dj9EDhePXjfn5TqGg+TlaPvV87RSxpLKj5eR8wT/h6P6PRQ57HCMDt0AC/YMcsLO0M
	 y7LPH3B2ahk3ricmJUmduuvsw8OhHP7doEX1KPBs=
Date: Sat, 16 Aug 2025 00:18:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org, David Hildenbrand <david@redhat.com>, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, Rik van Riel <riel@surriel.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>
Subject: Re: [Patch v2 1/2] selftests/mm: put general ksm operation into
 vm_util
Message-Id: <20250816001811.7f85b64fe8c748dcd6d47c27@linux-foundation.org>
In-Reply-To: <20250815064717.hlkehch75t6blj6e@master>
References: <20250726025223.350-1-richard.weiyang@gmail.com>
	<20250726025223.350-2-richard.weiyang@gmail.com>
	<20250815064717.hlkehch75t6blj6e@master>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 42C341C0005
X-Rspam-User: 
X-Stat-Signature: iekyx8zknfuwzqq73kkdwdxwnmqddf74
X-Rspamd-Server: rspam09
X-HE-Tag: 1755328695-885389
X-HE-Meta: U2FsdGVkX1+QhB7s8AFaXkiEJqVAKfvjtrGm637zPFoaV9wok60NR4h0epS2QeCxkbISH1tsbOYEeAoxMkE/45vrDdlRA1sS2jq+uRR+OINOtpaLlJbFQJgGavxik5AncsRzZAn5nRDHfaPYQZWMybKQESrg0OxnY6CvtQGFFTqbi9dihWbARxn0TsSAwBVY+LJdVdF5+IXTWKNdTpz+U2maDYXrzXIofeVWgyp/RdCudmiwoQJ8yFQTMAO9rBxtg02Ajh6pRpBJfajknkXPbo/WMriKAJ5tVuTME8xAdYCFT6A/90cQIBizgZTvnTOYTPpT85qcPccuedUB/SHr8Ml+RyaWvmoUhUmguX0UWFo+IoZZCMJcSYnrSlqp0ooM87pngTvOdDkc/gKI0IF5qDS0D7nXloZd9bdz/G8VwEe/YuXZf0qnZ3gSPHYgDKhyN3f8eedVTy6Mr1ZBd4HMb/W66z/9FwIPV3OJkucr+pMaUvBUCnj0GC1X+Hxor/a1LV3yFHZcJUHI8+RVMA/W/mtOgbIPw3MxW1TqcLY/w66hCFUJlRkxcR+PuAUJtpHqAphhKojrvuRelz//icIXFpwrk170YHZnDMhnCDlMW5vd3E6A5dnjmEi3LX27rrjJsQRGiuZVcWzNxNhuaYQfnzJngR7V+nETFDW1fxV1PfJCS0rD7isZBOlNGr0vvh37WK2IdlcytdAxNEJSmufOs1Q6SqCeBwFYe5fHJ6xRiW47/0s9ywIofBWICrPjqG9ZguvCqRIXzy6u0ZkwY9lMU5a1LdrHrxiAQz8umUcbfBegr4AytDGYiSG3ZE3pqoMCLhtgMeDYh4dcJE88RICW0gkZYi2W2JU/toat3ePo4Ozh80KG5Dugiz1NXIk1JQfnV6d/JMKeBPI6O7XbImlfbz3RzY/F9Fecj/PpXhClxBKsAgJcbuvJRiJ5loqvJuwrmhnDREGRfxY5wnB3BQp
 XqImeTHs
 QuWgl/sLORou+J73yM9z+AAuflMfwGeVxbRQj/0OcIlDCq8Nf62MLaqjUTzXV7CArilfxXDGOhdQJF9WHLrUa1t5oG63R4btZcKXd/7mje2HbMXBbYoms62eCMC0jH8HeUyn+2qWvixTiH8jHTLNnGTHRir1aIm9OiMpxIsqrvf6Z5vzBS9xJCzRlDC6rs6MRpVcvo3gg6Sej4GT9urTBYdTwpy0OaCfCSHPB/3y/m0OSG5bGyTcn2QYJhUMmxLfLnRklT8E3FQdiPSZ2+vSwa5UueBfqhwn9MXe6ga1NxiqBxtnDzFf/LcuQB5rJgn4rZHikc7PGzp0fpRKvMcrgo2xBvTJ82m5xhI5XBamD3UKXGZ8tbql0I5KcDHH04JV3loqMEmQ9qVcaDfy1O496XzRDAEc3WxDyrHLc6Y4fSVIU1nruppo0tYjlag==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 15 Aug 2025 06:47:17 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:

> Ping...

Pong.  https://lkml.kernel.org/r/20250728020930.w7sv5eccp4kcizts@master
indicates that we're awaiting v2?


