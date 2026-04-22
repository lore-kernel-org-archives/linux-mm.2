Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCA1BF94CCF
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 06:20:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAE5B6B0088; Wed, 22 Apr 2026 02:20:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5FE36B008A; Wed, 22 Apr 2026 02:20:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D76CE6B008C; Wed, 22 Apr 2026 02:20:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C67E26B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 02:20:00 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5CC125DAAC
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 06:20:00 +0000 (UTC)
X-FDA: 84685191360.07.8413D28
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3E30F120003
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 06:19:58 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cuWdkhNp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of pankaj.raghav@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=pankaj.raghav@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776838798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QRaB+OWmnSSxx73xju1MkZZdS0Vkq8bRebe1BLSfkZ4=;
	b=Lz7wib/sOCbrb/LUNG98ZYHMVPTFwQ3hIguPSsjsEik4CBgoF2hUTLoNQsIm5G02oq6vxX
	vf7WZmrhW4kTEmp2CEZTMRSCMU29vijf0H0+TLtD3v/RV0mKYidl/QTRWlJ/0x+K+MXG+G
	zhD/x3ynBFD5GQq64hJEcb3IfQ28vWg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cuWdkhNp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of pankaj.raghav@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=pankaj.raghav@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776838798; a=rsa-sha256;
	cv=none;
	b=wUl4rG7AwQqE8bu1D15VgPH+Lhd+FchEwtdZ3oDL/+vInSD0uRnRa57S9mVKwebM3+QmkB
	ExoompgxBJWsXSgC2BbdnbMJIbuepeL4CW4bG1VCNfvfqx/HTK0/fB1h+UIfeiGfHSkzU/
	Jk9wmIWBJl5KMgrzWfq3/mRbBhFfFtM=
Message-ID: <02ed5bfc-7ebf-41ee-bd8a-c8e030c35bca@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776838795;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QRaB+OWmnSSxx73xju1MkZZdS0Vkq8bRebe1BLSfkZ4=;
	b=cuWdkhNpwy23S+cgY6T70/mYCiTj1dgyTqYd+knUz0WoPwtDYGMKV9PVgEfO2v2EePxWIu
	udohEpiaDN0Oy/ed2XRsfqeEtQ/3mYItnQNxm64g2eoUwk40sBW89qxNuAv3w16I7EmnvO
	duuHVtDyHrv73yfuMc13KdbIaMcrKTk=
Date: Wed, 22 Apr 2026 08:19:35 +0200
MIME-Version: 1.0
Subject: Re: [RFC PATCH v2 2/5] iomap: Add initial support for buffered
 RWF_WRITETHROUGH
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org, hch@lst.de,
 ritesh.list@gmail.com, jack@suse.cz, Luis Chamberlain <mcgrof@kernel.org>,
 dgc@kernel.org, tytso@mit.edu, andres@anarazel.de, brauner@kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>,
 Pankaj Raghav <p.raghav@samsung.com>
References: <cover.1775658795.git.ojaswin@linux.ibm.com>
 <d44171d5a1ec783722019ad7d1a4ede0478cc914.1775658795.git.ojaswin@linux.ibm.com>
 <kvxvy26jblhx6sijbhxbpzzwltfoskwkv2suqhop5dq742fn5y@5tlws6pzaol3>
 <CGME20260421181614eucas1p119dfe990221e6cb397d647cf24dbfa1f@eucas1p1.samsung.com>
 <aee-xaUCWMM4EV7Z@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Pankaj Raghav <pankaj.raghav@linux.dev>
In-Reply-To: <aee-xaUCWMM4EV7Z@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3E30F120003
X-Stat-Signature: 4iy9ty8fye8j3dpx6andqwk7uimqqina
X-HE-Tag: 1776838798-982198
X-HE-Meta: U2FsdGVkX192Yl0b97akk/l6RKzRd5zv1ySGAfbvZ85fb71W28Ih9LpFet/tJ+3q2E8g5K3K1tud1ROC+bYnAk7nTvSxWihOxYpS4Zomo1EtExgA1h+64yMsOLVBjkjIlXsUzgQupME31J0J+UIBEG/5+MsIGxH+3Oq75ux8qQYQKhFaos2kaihjxuqo9tOMklTp0TW/DE14m+KSmcF5zpXgjM8/bBO0BGK9pTvktJoZPzTFFdhEPRS0NT4K2z758GLQzle3PACldt+40imyFaplm1ym34Jv9iDCZrc3IeKYAsrPztxghwIN4VEa69Px/6MFSlaKxZ++RXFqJ7trt2Lt2m2F1PCmSWqP02liKibQSE0umOwcD6DHifj+GRFngxBfyuWXWeZy6ZjRNfcciTDZIuvua1rkvnJcw0RYnG2oyfFU2G+dpzxfauX4DyGAFNaAfMGHEuz1LEXonM0Dj8r4JIeXMBsUdWJ++eRLtUB79KieRdLoPn9QAZndoWdnJt5aS1gMt4F+KCjOgg464IqHlFVKNx9IfKL4Wpsigj6qwnLQctLFbfr6FmW6fe2IXn7YiXnX+9RpwFnR8WZMoqoRzwsA5p2luu71rwBSnBd40F+R/8M2KfGQM1615+Ro9HVrKo4dmOSabSSSR/i0au7lBbs2MdwSVibctOFDRcMleXlLLvLf/L4Ydlj2+CYKVlLFKIW9OtgGajMMeMJNEr9PGImFnYNTrC3bcacHUUZjjuHHw4F4Z9ov3ZbJbklUar3BUUHu2e0eQOkRdW34Bjd5CNkwvrstUZYd7+zl01D+L/KG8Z8DBlxFya5H0/Mg78pYtTTbMaAMHkqaWMuZPXbEuUi3LT+Vm6RK7Yl5idF9KaNfHYs52QXSfL1/AUtxUJ6Bhbgdcm33NIzwcz3S/0mmWoejjXhOQvBqIkFoKE9nfH+SClgfW0YXZOpi7z7HMgDtDprNxUIs6FcMtEv
 PjL9dan+
 Opseh9vqXFKOnHqAAo6Z+H6QhvWdO1n+pC34dck5buJwpuWUOGwPAZEGYd+rQbPiIzlwLwu8Ky/Bb0ICI/BZ0aIqb5g2UV4XYlRZG608G7OUsK890GtI2R4YADi4QQkO5EZnZMkgrmRpDvnotrorMlZ1zztYfjKOgSTsA7iuSoUQooi0jCcRHVm9WoJiG1VCVB7lfqANy9FkX0wiZTIAtkaZpeM9lYsTAhNZ2FtFvjMoZUh/LQuCzMczTBQR1PYuqlXbHGdv/LifEVP8JKmsMBH27gzZrolUu44kjHyicf04DfzJrbn6uSQcewtQQdVuLPuDZlAYYdx81AEI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 4/21/2026 8:15 PM, Ojaswin Mujoo wrote:
> On Mon, Apr 20, 2026 at 01:56:02PM +0200, Pankaj Raghav (Samsung) wrote:
>>> +
>>> +	if (wt_ops->writethrough_submit)
>>> +		wt_ops->writethrough_submit(wt_ctx->inode, iomap, wt_ctx->bio_pos,
>>> +					    len);
>>> +
>>> +	bio = bio_alloc(iomap->bdev, wt_ctx->nr_bvecs, REQ_OP_WRITE, GFP_NOFS);
>>
>> We might want to check if bio_alloc succeeded here.
> 
> Hi Pankaj, so we pass GFP_NOFS which has GFP_DIRECT_RECLAIM and
> according to comment over bio_alloc()
> 
>   * If %__GFP_DIRECT_RECLAIM is set then bio_alloc will always be able to
>   * allocate a bio.  This is due to the mempool guarantees.  To make this work,
>   * callers must never allocate more than 1 bio at a time from the general pool.
> 
> And we seem to be following this.
> 

Makes sense. Thanks for the clarification.

>>
>>> +	bio->bi_iter.bi_sector	= iomap_sector(iomap, wt_ctx->bio_pos);
>>> +	bio->bi_end_io		= iomap_writethrough_bio_end_io;
>>> +	bio->bi_private		= wt_ctx;
>>> +
>>> +	for (i = 0; i < wt_ctx->nr_bvecs; i++)
>> In the unlikely scenario where we encounter an error, do we have to also
>> clear the writeback flag on all the folios that is part of this
>> bvec until now?
>>
>> Something like explicitly iterate over wt_ctx->bvec[0] through
>> wt_ctx->bvec[nr_bvecs - 1], manually call folio_end_writeback(bvec[i].bv_page)
>> on them, and then discard the bvecs by setting the nr_bvecs = 0;
>>
>> I am wondering if the folios that were processed until now will be in
>> PG_WRITEBACK state which can affect reclaim as we never clear the flag.
> 
> Hey Pankaj, yes you are right. I think the error handling is a bit buggy
> and Sashiko has also pointed some of these. I'll take care of this in
> v3, thanks for pointing this out.
> 

FWIW, I got the following panic on xfs/011 (not reproducible all the time) when 
I was running the xfstests with 16k block size with the writethrough patches:

[76313.736356] INFO: task fsstress:1845687 blocked for more than 122 seconds.
[76313.738751]       Not tainted 7.0.0-08885-g97cbd56b7479 #43
[76313.740650] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this 
message.
[76313.743311] task:fsstress        state:D stack:0     pid:1845687 tgid:1845687 
ppid:1845685 task_flags:0x400140 flags:0x00080000
[76313.747137] Call Trace:
[76313.748000]  <TASK>
[76313.748830]  __schedule+0xcc2/0x3c40
[76313.750129]  ? __pfx___schedule+0x10/0x10
[76313.751479]  ? srso_alias_return_thunk+0x5/0xfbef5
[76313.753214]  schedule+0x78/0x2e0
[76313.754334]  io_schedule+0x92/0x100
[76313.755597]  folio_wait_bit_common+0x26a/0x6f0
[76313.757156]  ? __pfx_folio_wait_bit_common+0x10/0x10
[76313.758873]  ? srso_alias_return_thunk+0x5/0xfbef5
[76313.760508]  ? xas_load+0x19/0x260
[76313.761693]  ? __pfx_wake_page_function+0x10/0x10
[76313.763386]  ? __pfx_filemap_get_entry+0x10/0x10
[76313.764948]  folio_wait_writeback+0x58/0x190
[76313.766499]  __filemap_get_folio_mpol+0x56d/0x800
[76313.768085]  ? kvm_read_and_reset_apf_flags+0x4a/0x70
[76313.769899]  iomap_write_begin+0xea7/0x1e90
[76313.771304]  ? srso_alias_return_thunk+0x5/0xfbef5
[76313.773016]  ? asm_exc_page_fault+0x22/0x30
[76313.774427]  ? __pfx_iomap_write_begin+0x10/0x10
[76313.776100]  ? fault_in_readable+0x80/0xe0
[76313.777476]  ? __pfx_fault_in_readable+0x10/0x10
[76313.779106]  ? srso_alias_return_thunk+0x5/0xfbef5
[76313.780765]  ? balance_dirty_pages_ratelimited_flags+0x549/0xcb0
[76313.782861]  ? srso_alias_return_thunk+0x5/0xfbef5
[76313.784457]  ? fault_in_iov_iter_readable+0xe5/0x250
[76313.786221]  iomap_file_writethrough_write+0x9fd/0x1ce0
[76313.787978]  ? __pfx_iomap_file_writethrough_write+0x10/0x10
[76313.789991]  ? srso_alias_return_thunk+0x5/0xfbef5
[76313.791589]  ? srso_alias_return_thunk+0x5/0xfbef5
[76313.793314]  ? srso_alias_return_thunk+0x5/0xfbef5
[76313.794932]  ? current_time+0x73/0x2b0
[76313.796132]  ? srso_alias_return_thunk+0x5/0xfbef5
[76313.797276]  ? xfs_file_write_checks+0x420/0x900 [xfs]
[76313.798786]  xfs_file_buffered_write+0x195/0xae0 [xfs]
[76313.800243]  ? __pfx_xfs_file_buffered_write+0x10/0x10 [xfs]
[76313.801775]  ? kasan_save_track+0x14/0x40
[76313.802843]  ? kasan_save_free_info+0x3b/0x70
[76313.803908]  ? __kasan_slab_free+0x4f/0x80
[76313.804894]  ? vfs_fstatat+0x55/0xa0
[76313.805835]  ? __do_sys_newfstatat+0x7b/0xe0
[76313.806899]  ? do_syscall_64+0x5b/0x540
[76313.807829]  ? srso_alias_return_thunk+0x5/0xfbef5
[76313.809052]  ? xfs_file_write_iter+0x22e/0xa80 [xfs]
[76313.810451]  do_iter_readv_writev+0x453/0xa70

I have a feeling this has to do with the error handling as we are stuck waiting 
for writeback to complete. It is not reproducible because it might be dependent 
on the state of the system before this triggers. Let me see if I can find a way 
to reliably reproduce this so that we have something to verify against once we 
make these changes.

--
Pankaj


