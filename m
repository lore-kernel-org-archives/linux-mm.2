Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79D89F513ED
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 01:28:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF53E6B0089; Thu,  5 Mar 2026 20:28:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA28E6B008A; Thu,  5 Mar 2026 20:28:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 984436B008C; Thu,  5 Mar 2026 20:28:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8988C6B0089
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 20:28:29 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 45F231A02F5
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 01:28:29 +0000 (UTC)
X-FDA: 84513903138.23.3BF90CB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id AEE361A000D
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 01:28:27 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="GLd0s/ch";
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772760507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CaG7jr+VfjnCoSN4V62oLqn5tLh2gzx8QQSFMx4Q7MA=;
	b=sQY+JAmv63pHxCy8thYC5LrCFPHIc8QFIYom2xKyJYWgRKVeAq6VoFg+UTvIEzCxoptPiI
	pNe1Ygx1EsK+HGf5SqtLo0f9Mx0L2tSB/8roPKm9zmr71Dv9F9AdBoie38cMG0ULk//0Cv
	1Mo1mnE120bmmGZsh68ymSnxRiRev+A=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="GLd0s/ch";
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772760507; a=rsa-sha256;
	cv=none;
	b=HqmRBlumDsxECltX92JqfCef+8/lEHwj3vZfbQ6wPY9OeoCfj3j7NVV4paMXTYXia2ki0j
	B9ceZ7f+oY2vLkQz02j6ytgvvUnPMkQ+sLSzQt550G+EFFPFMmTgNm8UTiXY0T39OBz94d
	a+Dm+6LDUcD6/A13kV/J9woMvEcwedg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6F214400A8;
	Fri,  6 Mar 2026 01:28:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9ABBC116C6;
	Fri,  6 Mar 2026 01:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772760506;
	bh=xoqtM6KgSSyBmEncwbFJBFIEM74nLDE4UHST+ZsEmS4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=GLd0s/chsfmYvy+LIH62gG5cEGAEj5HMdsosVlCij4305RrtKNFRubz7oaemcCLGp
	 cYE1e6xHiziyBEv2LfZDfBA0YvxGjkdcmwIMHkbsWGB3BeloGCws11aDALA3BnxMIh
	 KTm0M6zqfZxOWL8K7hZizyGYcV4OsvQCT4Rk4jEc=
Date: Thu, 5 Mar 2026 17:28:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, Yue Hu
 <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep
 Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>, Chunhai
 Guo <guochunhai@vivo.com>, Muchun Song <muchun.song@linux.dev>, Oscar
 Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Tony Luck
 <tony.luck@intel.com>, Reinette Chatre <reinette.chatre@intel.com>, Dave
 Martin <Dave.Martin@arm.com>, James Morse <james.morse@arm.com>, Babu Moger
 <babu.moger@amd.com>, Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota
 <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>, Matthew Wilcox
 <willy@infradead.org>, Jan Kara <jack@suse.cz>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>, Pedro
 Falcato <pfalcato@suse.de>, Jason Gunthorpe <jgg@ziepe.ca>,
 linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 linux-mm@kvack.org, ntfs3@lists.linux.dev, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/6] mm: vma flag tweaks
Message-Id: <20260305172824.fd712ae310748dc6338d6d5b@linux-foundation.org>
In-Reply-To: <cover.1772704455.git.ljs@kernel.org>
References: <cover.1772704455.git.ljs@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: AEE361A000D
X-Rspamd-Server: rspam07
X-Stat-Signature: cndoeugjimcr4pm4sqqnoos5ud1kct43
X-Rspam-User: 
X-HE-Tag: 1772760507-654843
X-HE-Meta: U2FsdGVkX1/0Z5lYASbLKxCbXCG1p5VN4/DVJCU+o1FMUvFk876IIwuxq4baQjS161sDwTlJWWR8PKf4wulk6pv0eNjLizADa3kbdvICt/i4w8XmR86okw33vIivHasXs93vdjDChxYyKT6WJ938ksMo6JzZN7ewCLdVm+wV9Dyy0dGHCTprx9IaoLFGB5HViRMM1CrGzfZuSC8UbvZTgV4CJuAs1ghD6oc1xwAZOhS181l/7FzZ1B/DEt8PUAKCgkkgaJ2KqbTDzrqkrxAsJzWWAmTJunCflex0itDavCVIWJD+4J2dxlFVbDzsYTKOc8Lh4gGM2/XBjYPA5CGlvau6X+Lqvs1JvzTVZE3n5yCC9U/XuLudqQyn20WNI2PiE4R7QDNX7QCPnBC24iqP8Y0FVIzzu9q/TsaXKdMjWQOS8dki7r3EMGIk1m+66MvxgZEYbVgTwIp/416V7oYOpD43vjeCUWzOCiczpvDzw/UQ4EivqqkSmZqi5913x31fbArUY4JquhK87gMureybWfmY9FWods4kBTUbtVhbZRJ8UuNfEo/DsvN2o8S1ZpRq5Pcz5Ae/KfA8tlE9oVQcwgRwFWkQCEUPjzYfqyA78iNxPFpU0BwL5Kbg6pazrxqum5FUa2GSnR1HbsOFgIFnxqFuocsA0q5b34kp21s2y5ttesXHIDZLgfhQ77UIT7ut+VBWCRCx3P8hMcp9PCRiGQRVRLQ9QNLNDAnQqIAomI8llkWSokUYWV1TplYO54OvAYv+fg29CHO8ZMKGhWn9xTN9wHPhjmzRryCiHj3zOHdj0TxRPeU4hAMeymq+lHWY+wcA7Pl6xxNhwCH6XlkJ0B+ptK/hXWK0Dnb+jwpUHSlvmvArR5YYwKNmlTWfjhD6zQWT1VE12Conc5NQEnW+GbNYI6I1UAyaFOW1bT4NtMw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  5 Mar 2026 10:50:13 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:

> The ongoing work around introducing non-system word VMA flags has
> introduced a number of helper functions and macros to make life easier when
> working with these flags and to make conversions from the legacy use of
> VM_xxx flags more straightforward.
> 
> This series improves these to reduce confusion as to what they do and to
> improve consistency and readability.

Thanks, I quietly added this (and the -fix) to mm.git's mm-new branch.

