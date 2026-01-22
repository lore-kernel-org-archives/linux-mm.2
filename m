Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8727D3EE9B
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 17:32:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 479D16B02D3; Thu, 22 Jan 2026 12:32:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 450EB6B02D4; Thu, 22 Jan 2026 12:32:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3878A6B02D5; Thu, 22 Jan 2026 12:32:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2503A6B02D3
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:32:45 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E6CAF1AFB2E
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:32:44 +0000 (UTC)
X-FDA: 84360294648.30.67B254D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1311D4000E
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:32:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=AJ5b+VU7;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769103163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mnTEXkLc24NF7JpmtU3RW47d36CSrpzoHFIeJjA4WCE=;
	b=6f81tKRf0pn1eAA4mExG14F52es5MzFdHw7UthxpSM4DEmA++EWOVQQr7uK/WITK8Au/HF
	jZ/SL44xnSHzv9noujz3RA4vM9no+kzrA7rNSxCEutZe0JMfcxpe+BZLFjUgAlk6u6ufZc
	jByijhPv5Ed6seXfVt2v+9yTXGyFXSY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=AJ5b+VU7;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769103163; a=rsa-sha256;
	cv=none;
	b=6aM2TXkaByHh7eS9FEqU7BJNMScrlyIZinYL7vNwX//acSxML3vX5TXObnial4SYG12kmu
	Vn2DXyBA/kwVSX4aGkauUsuyKD7WmGyeI7DMwpbc6UeRF9Yplf4lUq8D8XcxlWkB7/lAh5
	eSUhj/jyjc215gxvUv2fn2IlpAwU3Mo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CABB440AF0;
	Thu, 22 Jan 2026 17:32:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C0BAC116C6;
	Thu, 22 Jan 2026 17:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769103161;
	bh=T51xee8w+q4wOs994zMPrpOU5VE4HghA2NdWC1B5WOw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=AJ5b+VU71V+YVuXCL+/s2IIrCquyiH9XVNXLJR+hLQ7dV6vpzsPbop2aH5WoMNnrO
	 DIU05IfK5crWnQI5+TL9byn9gRtfEdaTa4TS+eGy51sPheUdhofNjIZsraB+Hk7Mai
	 lYuu0tdzu92OU+IWJkpUnl5Ce5HU5OcjcagkdF7w=
Date: Thu, 22 Jan 2026 09:32:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>, oe-kbuild-all@lists.linux.dev, David
 Hildenbrand <david@kernel.org>, Linux Memory Management List
 <linux-mm@kvack.org>
Subject: Re: [akpm-mm:mm-new 279/310] memory-failure.c:275:49: warning:
 format specifies type 'unsigned long' but the argument has type
 '__fsword_t' (aka 'int')
Message-Id: <20260122093240.ef007fed49c166ae5ff256c1@linux-foundation.org>
In-Reply-To: <202601221142.mDWA1ucw-lkp@intel.com>
References: <202601221142.mDWA1ucw-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1311D4000E
X-Stat-Signature: bq9aj7jpa9jw1zb1rk1otk9th8hr9ym5
X-Rspam-User: 
X-HE-Tag: 1769103162-944230
X-HE-Meta: U2FsdGVkX1+IF7EpZ5Oyd95AnFXkdrYpByU/P3xRBIuG85BIsmbZTDVST00T6AmC3nftJpc6FeBipY3P9pZh4K3mDQ0p3g49im3i8LuC6s1YTbGWQmGJcI0PmZuAslsmlK1QDs4Am84X/0w52SaoScItGBBlt9C6hr/q4IIG46Yw5oPxsQft+AGd7rAUiqNPacS182Zm4p7lmuLmXIqt2HtI+3ipo/80lzWP92+CB2UVGS1dYMzs3+W2GWH1jDbW4kLgkqsycK+Q1F5Dz8ALtZbssgG0FzgpQCk6JkIp0syb2FsvMj7zeEREto7Sm6FvlnPWkIfscDuoJt1bRfDwG49ThY2IffKmYmSz2SBJZXEdDNKm2GSJWPVUOQxckr7W7vtGM91qWQ6PnnpbccmCq4c4PLn1fH84uFnEICrqwVqXjKJOOFNPZ1hqUuOHO6k6ntZDm0W6DDLqR+61D3setz0GPYEM812LFQjFCv6CUBkFZwsD6bnNgoc7ctVVECRSAGTwk80WhojyETfJJn4MXQffGTHyT8f+mQxdVnRDcfX+CM/8b4mWPx0UVYsalUJIpODW1DWjhdyNXQimBH61J02ELM/PoCAMiYcaMSzS4uauwbNGihfK9pNMYwlBobgBFOz9xiqgAUw2ttVZcbzA30wHuQZCbKEYTH0YOviXhb67r5sLVh1OeumxpbdMIMKlN8FgjtqV8mPWeR2Dj16r5Avx1VmFi8ZiaqObjgkP9dSQe0VVwuQnlqVhygzX2Zaf06ZnQRsr+0kaD4jj0fDsqfAwiD+8fEU5P4FJkFB6/QT6vJf5tENGeaThCCZTwKgwaxpo8Be1quuI40k60OObtyCsLXxeRo3h1F3mjvTtweg6+mExEwx1AAVtxwHLQxeE3wBEr4ht36LQT+v+H3Df7ST5Ru+41ngeUMwdaqQ4N1mTFY38cVejhxMlbLjuAzLDFDsq6ytT1PBFQnfBoh0
 UsPO2zyN
 BSuYlTaZJVbvJ+tsGVaOpshONbvJ5calBy7yYjLy9dfEgy82P2YEJBA6MFny5LCUPTwlX5pB3TWD+KPCVOfmxoJoMqT8Iqn9gXRNhImU+YfxEgK2UPgQa43d/U982Fg3s01RqOLztU4D4xZIKzMVr7QzDZZeKw7Ml44RC0H20NMAodL96Obb+Ebcp6xymsW6Fwf67UNOZvVO3s13OAhtb1FKVID4EntgjAieCaRTciQjdoCDcUFAZz7jhKV+Oq3XIPZXzwDr+8OvpU8p9w5KD0zp5znkw9Du9wYWc11DwTJ3lXqUnx57aCZ0bVH/LBH/p4LlkzAwLdgaVpbCAhDnWm4nEvS1VbV6Njn7DA7GmSP+eiC7PRowJ/4C6LQcMaUVSAC3W6G6o9Je5T6HAZ0eK3glbbzr6svFM6PxKIW+wT3gT25k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 22 Jan 2026 12:00:08 +0100 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> head:   dc4fe40a11269aead253fa0beb098b00417b8694
> commit: ce9b369feafe8c65aa134b0c8791bf7f19e463e2 [279/310] selftests/mm: add memory failure clean pagecache test
> config: i386-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20260122/202601221142.mDWA1ucw-lkp@intel.com/config)
> compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260122/202601221142.mDWA1ucw-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202601221142.mDWA1ucw-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
> >> memory-failure.c:275:49: warning: format specifies type 'unsigned long' but the argument has type '__fsword_t' (aka 'int') [-Wformat]
>      275 |                 SKIP(return, "unsupported filesystem :%lx\n", fs_type);
>          |                                                       ~~~     ^~~~~~~
>          |                                                       %x

Thanks.

I don't think we can rely upon libc's __fsword_t being `int' in all
situations for all time?

We could add the typecast but perhaps it's better to change
get_fs_type() to return int?

