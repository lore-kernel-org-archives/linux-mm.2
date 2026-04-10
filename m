Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A685F44850
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 12:19:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0878B6B00AA; Fri, 10 Apr 2026 08:19:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB67C6B00AC; Fri, 10 Apr 2026 08:19:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBA8D6B00AD; Fri, 10 Apr 2026 08:19:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B87816B00AA
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:19:24 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8EDE4B730B
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:19:24 +0000 (UTC)
X-FDA: 84642551448.02.F316363
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1194640008
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:19:20 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ItHIgZPX;
	spf=pass (imf01.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775823562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xA0gQtLpnpN6dJllUvcccJ/r+mNlQ650rHe5aRjH1/Y=;
	b=UmwYTcRikBXb0MjH6Y+udu9fx2b5mDgnJ6oEQ2p5htW2cqDkFfeIc0EIT438j+pTv2MYfq
	tsmdukt8HgBpWi1xKn3ad1hd1TpjpqHTOo+Z/xyU3S9Al8+8fRGn3dJywPMjoc886yVGd6
	f8/O9X1hiGSpXnGzePTor5n36rLy9qE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ItHIgZPX;
	spf=pass (imf01.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775823562; a=rsa-sha256;
	cv=none;
	b=N2z5g5+kj7DdydLrPMuhgWKulc0K+MRg7I7qYh4ALhlUKy3NyrL2LSrSbVVGHnfyOZmnMn
	hsygZUFE91QUKQe9WRsawxVywl5wzMCjAfh3CVu/6nS7D3KCI7hjnmphDaLoHOfYaSssDM
	fBHnDDGmC3h3k+Ls7sj8GnQ2t5Z/2HI=
Message-ID: <5f99b289-629c-47c4-bef0-966d6678a2a8@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775823558;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xA0gQtLpnpN6dJllUvcccJ/r+mNlQ650rHe5aRjH1/Y=;
	b=ItHIgZPXvITZaz44MjQUvDrn8+360iGxPQ4SupGVPlQJSXbTrdOrEoo4Y8x9OckfubKKuC
	WCMKPWu6Y4cbfbIrxy7yYu6g7lZP/gF4pNlezFZTINd4MZl80c4szu9X77x7P2SVip02/X
	skUbST20k2vhZ6MlLVxYCHvrmnVFaWs=
Date: Fri, 10 Apr 2026 13:19:08 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v3 0/4] mm: improve large folio readahead and alignment
 for exec memory
Content-Language: en-GB
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
 willy@infradead.org, ryan.roberts@arm.com, linux-mm@kvack.org, r@hev.cc,
 jack@suse.cz, ajd@linux.ibm.com, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, brauner@kernel.org, catalin.marinas@arm.com,
 dev.jain@arm.com, kees@kernel.org, kevin.brodsky@arm.com,
 lance.yang@linux.dev, Liam.Howlett@oracle.com,
 linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, mhocko@suse.com, npache@redhat.com,
 pasha.tatashin@soleen.com, rmclure@linux.ibm.com, rppt@kernel.org,
 surenb@google.com, vbabka@kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
 ziy@nvidia.com, hannes@cmpxchg.org, kas@kernel.org, shakeel.butt@linux.dev,
 leitao@debian.org, kernel-team@meta.com
References: <20260402181326.3107102-1-usama.arif@linux.dev>
 <803a0c15-0a6a-4c00-b6b3-eaae56d5fc15@linux.dev> <adjkCOiLgZ_-zovg@lucifer>
 <adjllNan2vgBNBHJ@lucifer>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <adjllNan2vgBNBHJ@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 1194640008
X-Stat-Signature: srfqn3ccu3668h5ej399sdm8u3gc5fuf
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775823560-272888
X-HE-Meta: U2FsdGVkX1+FDCJsoUksNAiXzXmqfVilqNaGrzxgeUaX135CBgqMXYEeLlBVtbkxEl185DGrz+JzNMx9MY0Q5TuSze94khMNuKYNcNWAdZvDAI9F8U1DcF1m0f5Hx0PUwlnJh71DtouCyUwTu9xLp6eKl3YMlMyhIO08JjuWS2gPvXGbUTdIPcriCMq4Dz6oUynaj37JlXRoehD+qgw2eIALIrkAk/0/I5poce/sOAd4BvGQaUStzTFz+L9yNy08st2ddU+Lo6/2a+eQR6ax1v1Gzn60nvqGdU3DVQ04wZjV7BR4QMetfN9Cvo6daw+H6ViobDovxvb6lPAccCNj4oEGU1vikLOLyXSB+cOugdpBKie1aqsOXeIB18A1RCpU2P4VArl+8DyAyZcOCobKLk2GlXsX7ki+IkVqgeGlYqYDQ7oGXXZZXrpD+ybCu+60F/VpnL7ESTJFJt5S0wk9abD66OFVtcc9wXbwvRVmzlxOCln5BBkriYs5iMbHiyrIVvdFtp2CU8bCTSNMuj4WDnBLg1erZHhXGPlvInyfZNpgbj6ljuc76XHAidOndnwhK5JywBHxky02LW2JpR+brtjB5qOAWQhRJvk8yeBhY4ordXHs5IphzLHcTe9lQP1iMed1QaazRJ1Nfc1D1u74XZ2S/pUMVamxGv0mA9Vk4PqrArSIZKaFZlvsxBAgNXqo2DTEnOTySTbiRcFWctG9HmCIZE3/nLjGnP6w9+m5Jc4cikm8WF3GJ2rJyvE9zkSlf0WjGClPDbU+rSBfTGA9/6t+JkJUI9OuZrPzXbvCB9zay1g1KLxqacAEDZgNTGxHsynUsTLnzB3xVFwqYauoopLbAxz0CmpGvklmfk/rFXXbd4Rk/k9eHBoD0DuxWM+A/QQ2rkOC7qLCDs17nXjVPWql1k052JNrkgaaGyHKjLXhz3xT4bFYgM+lS/Yd6z0sZTKRw9YPSg0AJwyXYwX
 sP4Xp9kf
 bSBu6MrvTOym3SgP5K3zhvBGnK1CLJMZLKH/0akjWm7u0S686JD91RPgMqV5bqA/IZ45pd/7Vt+Wfq+ykACpZPGfUzUkbSuZBHpqBfSCNkHLygdHW8rwubnr/A0ov8xtHEqYVrXiMn5apqg50fJa6PUJc7qdJLXdcD+i1Ptmlf1mA0+pSKom0qiH/K2LnjsImiDe6KzSW9ZMoPZURr7d41wAMCWytdCfIlL8zZEdGZe+x83c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/04/2026 12:57, Lorenzo Stoakes wrote:
> On Fri, Apr 10, 2026 at 12:55:42PM +0100, Lorenzo Stoakes wrote:
>> On Fri, Apr 10, 2026 at 12:03:03PM +0100, Usama Arif wrote:
>>>
>>>
>>> On 02/04/2026 19:08, Usama Arif wrote:
>>>> v2 -> v3: https://lore.kernel.org/all/20260320140315.979307-1-usama.arif@linux.dev/
>>>> - Take into account READ_ONLY_THP_FOR_FS for elf alignment by aligning
>>>>   to HPAGE_PMD_SIZE limited to 2M (Rui)
>>>> - Reviewed-by tags for patch 1 from Kiryl and Jan
>>>> - Remove preferred_exec_order() (Jan)
>>>> - Change ra->order to HPAGE_PMD_ORDER if vma_pages(vma) >= HPAGE_PMD_NR
>>>>   otherwise use exec_folio_order() with gfp &= ~__GFP_RECLAIM for
>>>>   do_sync_mmap_readahead().
>>>> - Change exec_folio_order() to return 2M (cont-pte size) for 64K base
>>>>   page size for arm64.
>>>> - remove bprm->file NULL check (Matthew)
>>>> - Change filp to file (Matthew)
>>>> - Improve checking of p_vaddr and p_vaddr (Rui and Matthew)
>>>>
>>>
>>> Hello!
>>>
>>> Just wanted to check if there was any feedback/review on the latest
>>> revision?
>>
>> It's -rc7, this is definitely something for next cycle :)
>>
>> On my part, my upstream bandwidth has drastically reduced, and review is
>> probably going to have to be a hobbyist thing at least for now.
>>
>> Also, not to be mean but:
>>
>> $ git log -E -i --grep "(Reviewed|Acked)-by: Usama Arif" --oneline | wc -l
>> 21
>>
>> So... :)
>>
>> Review in mm is very lop-sided, let's try to balance it out a bit!
>>
>>>
>>> Thanks!
>>>
>>
>> Thanks, Lorenzo
> 
> (Note that we're in a 'quiet period' from here until -rc1 of next cycle and
> won't be taking anything new until then. We plan to do this from around rc5 or
> rc6 of each cycle in future).

Thanks! Just wanted to check, as I am always confused about this. Is it ok
to send patches for review for next release at this time? So that they
are in a good state when rc1 comes. I wanted to send PMD swap entries
for review after I am finished testing, but I want them for review for
next release.

