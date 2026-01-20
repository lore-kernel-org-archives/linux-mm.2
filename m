Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79653D2ECF9
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 06:44:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9A5F6B0370; Tue, 20 Jan 2026 01:44:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D44226B0372; Tue, 20 Jan 2026 01:44:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3DA96B0373; Tue, 20 Jan 2026 01:44:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B5D196B0370
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 01:44:44 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4A2EB58C3B
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 06:44:44 +0000 (UTC)
X-FDA: 84351404088.06.AD078FE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 69D97180004
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 06:44:42 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MZrlEhoh;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768891482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o36L/7+teoVK/NrokCGWRYNhVF+VUPJa/AecgI9q4Zw=;
	b=qSrwgSCFE8IqrjOaiomvXvvFhPqg6nlHRgdmyK0hKTC4n42WFQ+B1SqWSIRvqvozxnl5c0
	sFehrjvS1CMNzRO4mtjXd/FG468c7m6akHOrbiqzth204PyOMSUu5FgnHjbX257FvMYKzS
	2F6vQ1V7yo/bHJs5TJ8xDThp/93vPTc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MZrlEhoh;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768891482; a=rsa-sha256;
	cv=none;
	b=p21YFeP0/crkM/aoE94M8CV8x7i/j9nvxHNwepENVFZA6Upi27sePLIuSuUZr8s/ArUC8k
	jbT+ZOZjqzeXSOltvO3nrCEUbRTeSFk8zo3bWF5E4ezKeB+ZMBmmSH3jDbQnsoL/UDk/3C
	LEViCBYjEqQC1PJtbbJbh3arx7BfGmU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3A748416C3;
	Tue, 20 Jan 2026 06:44:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA230C19425;
	Tue, 20 Jan 2026 06:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768891481;
	bh=fVZodrtrlB4eQWOfQQDpyqC4aE5YuNhMLG4v6dA486c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MZrlEhohCL9rwVNrkEbEnAMLK4YjTjhZCaWebD3/VYEiAD3GBN+4ahxvemx5oAMJq
	 Ke7Qpx+VhrnwjzSXzNhthxzW6DfIZo5hPk1NtLBqc+WMQCW4g/bcDL2zefvpRtwqJf
	 TR9VQtaagkwHm+D7qhTEzDApB/i+ceen3GSiWw5s4iLHrbtxKgXh4XRpSSbkKK0KFr
	 iSJJuuHZjY75pVGREsqiX2NjBxOuVPOTm9MuZHkAmLVNokM5ScpupSLMLLuG43jTCp
	 qBRuRL7PvknMNc7755FIiuXMKgLk9Ih6lQtovnTMGnKsJQycdfPIkmgYjXgf8THEk4
	 hYasGi/d1yWug==
Message-ID: <ec5971d7-faaa-4716-a697-1c7c90d624d7@kernel.org>
Date: Tue, 20 Jan 2026 07:44:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [akpm-mm:mm-unstable 319/345] mm/balloon.c:19:33: warning:
 'balloon_page_device' defined but not used
To: kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
References: <202601201338.4muFmFHV-lkp@intel.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <202601201338.4muFmFHV-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xuhbzma7uq65oy1d8bkdckreeiyj1qq9
X-Rspam-User: 
X-Rspamd-Queue-Id: 69D97180004
X-Rspamd-Server: rspam08
X-HE-Tag: 1768891482-37403
X-HE-Meta: U2FsdGVkX1/nIrG2coahQHVzwbAngJDYkK4Tb5oE5T7QHwDAHCCODBHTcMrHXmzO44nY7cFBKBmEIaEnZjWTEtCQPF3T5QbgsBgkmoEE12/44RrtjhnHvqg0/s9ODRVvlIwAoMBifpdH8Z3OzpTwp35W8IdGN8BAytvPzvx1OWVV2h2YZOYo0lZ4zL0LnGfEeeEMLXTQQlvwvIXTk2tFW6Ah8jzdJoPLJa4vxt5Jm59ggqpULfeAnY4RYdzbvtvsQjQmBxBibQEXyd41JoXYCcWHPRRMrcswJ04WqXTLGwO01uaj4y2lyWiHfy3oHLxn6i0mnihXW2vAV1mvAm6ePGWgOlBFHBgoByq2Q29aLVHxlzNgB/PyMZTLOnQ87aIQMemRhd3L0m98zlcumRQTfwFlTRgKS9h18xWbrC7rmqtODXgv14FSOF3PqJBmstijqshLLWFgJdP83ztJIe2hDpeQYNLjm+KoQiq4HI0fLsa+JiCAZ0tt1E8q9FMuuZIi3JtOyPgHUctG3RNjRVV/dMOCfp9HHwL5BaFgo8+5XO8nB87igQ3gG7ZngBB4PFBjknagCuiTAyxbRpKjsxCpROBc8vsGQ+ZxxU29/uW89gOLBG/IYDCKiDQ1ewwnn2x/Xn9UXNFv4ObuXe6u7Cq+CcUC1cksz55inBAxkpzyovXCgEWhFpMhevQTVNMv7I7CYBTvLBlgbba8gvMhhA9NpOKXdpoWRONCyQXTzup3Pgv7I98MYsK6F9mRQNirvvQjWufPBgkv+DpIFULe28Bsb4M3VB3CywwJoQsiA6cCyNcX3nuvomIddgF597lolBGaQ742PVlrgWO/5bJNJfNCWA8mcgi56f562uJJsAEBo1L6LwK9IJdlT04JtshddI7Mbspizt8xFhd0CvVLoH/mRwe6ty9kZUAHmKyt77sKLYpqsk1DciVRr6He9t5MV6S9aUF7yeaKEISbdpPti2p
 wW7o1vZX
 zEkL1RFIVn8cWIz8x+4DdSXNSU6aFY1nZ8xsdr2rhUR6kA8XPRQKM5BRZNwNtAeJDJbl2IfklnUrRyk4/oNg0kahcfxr+QJyKIvh8sUnn9Ebe88HdaxjL5gnkhUFKN66ctxNm4qNornIcjzo8F9EOx6d4ipBZWek6nIxN1n6axcqJltwdJILrCR3dm9OtjNsJt7ZKIPLLrkeF0mZWDm6xSaeOLsGQ676KjmHLz9oil1VFZ/+2ZoS0aJlAXC6gloEZcOugV0MFTur+lB1ht7fA+TWDNkq2KjvtWRQ8WV6Sjz7rdvIYWdFzy1XIZLT1s45qX5EdkiADYJ7Yim6oTfSB5bxuRpaPXJus9UPHNgsq2M4JkjpN2EKpZKZb8FZIkFbHF40NWyIgGjwjol7on8AEuFVvaj9rNVoN37de/O2ZAXzaYAU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/20/26 06:31, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
> head:   bd361423f30912263920dd83326dcf142c16ce31
> commit: f100e6eee69ff5746c327bc88a7fa6f43dbdf92c [319/345] mm: rename balloon_compaction.(c|h) to balloon.(c|h)
> config: sh-allyesconfig (https://download.01.org/0day-ci/archive/20260120/202601201338.4muFmFHV-lkp@intel.com/config)
> compiler: sh4-linux-gcc (GCC) 15.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260120/202601201338.4muFmFHV-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202601201338.4muFmFHV-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
>>> mm/balloon.c:19:33: warning: 'balloon_page_device' defined but not used [-Wunused-function]
>        19 | static struct balloon_dev_info *balloon_page_device(struct page *page)
>           |                                 ^~~~~~~~~~~~~~~~~~~
> 
> 
> vim +/balloon_page_device +19 mm/balloon.c
> 
> 50fe4326e833f0 mm/balloon_compaction.c David Hildenbrand (Red Hat  2026-01-20  18)
> ecc7c3359cb476 mm/balloon_compaction.c David Hildenbrand (Red Hat  2026-01-20 @19) static struct balloon_dev_info *balloon_page_device(struct page *page)
> ecc7c3359cb476 mm/balloon_compaction.c David Hildenbrand (Red Hat  2026-01-20  20) {
> ecc7c3359cb476 mm/balloon_compaction.c David Hildenbrand (Red Hat  2026-01-20  21) 	return (struct balloon_dev_info *)page_private(page);
> ecc7c3359cb476 mm/balloon_compaction.c David Hildenbrand (Red Hat  2026-01-20  22) }
> ecc7c3359cb476 mm/balloon_compaction.c David Hildenbrand (Red Hat  2026-01-20  23)
> 
> :::::: The code at line 19 was first introduced by commit
> :::::: ecc7c3359cb47658444833b09785c2ceb8459a78 mm/balloon_compaction: move internal helpers to balloon_compaction.c
> 
> :::::: TO: David Hildenbrand (Red Hat) <david@kernel.org>
> :::::: CC: Andrew Morton <akpm@linux-foundation.org>
> 

https://lkml.kernel.org/r/27f0adf1-54c1-4d99-8b7f-fd45574e7f41@kernel.org

-- 
Cheers

David

