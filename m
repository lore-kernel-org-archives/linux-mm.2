Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1837D6ACED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 11:51:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 650566B0088; Thu, 18 Dec 2025 06:51:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 628076B0089; Thu, 18 Dec 2025 06:51:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55E3F6B0092; Thu, 18 Dec 2025 06:51:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 41DB06B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 06:51:47 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A65A4BE2AE
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 11:51:46 +0000 (UTC)
X-FDA: 84232427412.29.6BA3AB3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id B5574C0007
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 11:51:44 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bF7EOa85;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766058704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R66Pyrl7UWSGGVtbWDdERYpX9vfDXqKAkjOQ6BUipx0=;
	b=fBIdXnar6wqC1iIzLJhRQYJ1JH4J3krPyPGetdcRszhj2XkYTiKKOS+cPGqrikjsAECmYP
	dcnrYpVFQaVq8h+feigF9gThIom3ZQpU9/OklOEaUxTL3UfjCp7oQR2MxHuNUEWvrDX47q
	/PPvXIlivtUMTLEyepq8swSyv72mpI4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bF7EOa85;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766058704; a=rsa-sha256;
	cv=none;
	b=11n5RpEDHL+LKFRfH1jIZLY+nGVWn3zrI2K9lu81wKlnzN4yRkljNhKp1uaYqWkQ8BePLD
	UJHAF/Bl8R6ArvvpquD94cDFVzfIzvZ9FVKiyumfuPpT1QsX0ViQH9bUjDuGl9/ts7Sx4G
	PFFFku1pOqQqjgjPQhLQppsV/odNQxM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BEA234032F;
	Thu, 18 Dec 2025 11:51:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6819C4CEFB;
	Thu, 18 Dec 2025 11:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766058703;
	bh=9hGn2FeJPN4hnz5ZpNDfyZdQc2Q/0q3NgIHMdRCBgpA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bF7EOa85IixPjgRaZ2KOj1lp6hbMTILcry6l6a/ENPkhpNsWTIwQPPLCNr9q7cWWE
	 mWo3UU3mrvuytkMEHVa+Y7aFx4HenCeQR/V6ze+QnrydfuZJlsTfEzWLydbsbQ9y4l
	 9mX/ib/EdLG5YdXKlgQXZIaweitfFvrg/CnV7IHUd8EnLADIM5FIXoO8TerDTaTd9Q
	 uAl83Pru6+Csuea9rmZRBLxqInKMyCfyPngAnojRT8LYO26s05aZVlADUrFmniVocG
	 jQoEClg+pJz+PlZ12G5/e1tFXcrJ0/8+Op5T6XTTnyVVCyQ75NLlhQSI4i5DfcYrIf
	 nuhtzr1CLQkTQ==
Message-ID: <32e4658f-d23b-4bae-9053-acdd5277bb17@kernel.org>
Date: Thu, 18 Dec 2025 12:51:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] memory leak of xa_node in collapse_file() when
 rollbacks
To: Jinjiang Tu <tujinjiang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, ziy@nvidia.com,
 lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
References: <86834731-02ba-43ea-9def-8b8ca156ec4a@huawei.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <86834731-02ba-43ea-9def-8b8ca156ec4a@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: dchs6j7gzyopx8xw9dru81tc7d38rdtq
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B5574C0007
X-HE-Tag: 1766058704-531990
X-HE-Meta: U2FsdGVkX19Dt4ujIubD/CmnvwgAGl/AWBORETZxj1MC3TK85L7Q4Bq52KuJZ96CWYtU0LWQQaGhHAUSVzaoQ520UmaCWTyhPUWQlkTbRhpUWWKDmsUMkLCKnCYRNwgg8mIV7qOVwM/D2u3bg1NxnntG4Zu1SBRaGW0roGXeVjnPyN0XjNwx+5hXgg7TxdxjEOQ4ef5hsHx8X7yTkryhkM7d/uwYBoN+CCgfgXxAM7FQ0SQi8QAjWs96/gtDUQZ+h8yPMu+4q4gYCP+c8MLFK0G0+RtzhoqGTMIdgCQgpSrkTkGRUum+xz21uRPRA2QOyYD4M0EiDsnEvkZpC6wMuZ4G8qly3G/KdsCwkAQePZEq45oPyWVsMJr3cF1sdqmfPuLtdLB/V/VOG4L4mexpgl33ogZcazJ+9psduWhmJ5jzlYY0YR8C+b32yrodus6qIUvYnkCUsFlTDG41wXlIHPpj9EZhCUvEeln9h1/eK0cceRxz4cXnkaeWDKTZH0yiemdlnR9MTyczwvD/aUXo8Cue3/08clIUo5T681hwrCuRkKxyl+s48jEMPNToWeejjgp1jLhJqi/8EQ7kD9cE6tmAOD1DPTOuNwz3w5E7wm677hwigLzXZl/sqlICdl1doUzrXkumS71jVOf4fOlkNQoQq4uC8B2UNTKx67EmmH9kCMQ6gEyPjSwifl4mUc6ztyVyAqCRUvjAZyHrWD3dLeLm+y3+A4aYwNF/wjNK2b743L1jYk9oZimDUT5veIW0SnwUXK3Mhdqo34Aq6ZVzz0l7S1wOYbU1+K3yBaLzyXx3BIIDiAH6W/O07DcuNinmT3nKJGLoLpzZ8p0vpJcVLzIHcoo1tOdHOswP4z1LBtPLG4hQJEnUq2SiDXjqydXqXv7yD3gGeu+ouXHm/QPgpw/HsOv1IbfvfZ6J9xmf9tYOvHt91tw28tYMGxBpHbeolwi60wOBkkk5KqZbwFd
 lefg68AF
 /ZDehcW3mbugU7e/BC3I3dUbM51OHVbDs0NhxYVEwAUKG4aXTRpGIcDUNfyqZ6QwmUrEG/Ky2WlGMkOWfaq+MdFDrE3ghiW8M+bsfM3bppHlQboLHa0OKTEh44xsz8AHQOa+y2NfUtByC6cPOupEXHK24MNIoiYdUip+vzZzRBLI+ui4NDaOejQ+UkFe7F9U4HBDzA8q4V3kiVks6nvWJwjWa56qzI9l/17pNJCF47FJjXh6fjpoDK1gnRWzb2WYAoezeUSBFrITUZyksm37Jhp1YFsFZM+82OiW9QEuNt6As07ulK+RWFiqP38U3Kny4exQOf/MA8ATmbVl/wc7PnZ1yzYF65Yi+u+wvPAiDi9jF3EnRRvp/IIiDL2dRThvqYjxcKanUCp4bIQU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/18/25 12:45, Jinjiang Tu wrote:
> I encountered a memory leak issue caused by xas_create_range().
> 
> collapse_file() calls xas_create_range() to pre-create all slots needed.
> If collapse_file() finally fails, these pre-created slots are empty nodes
> and aren't destroyed.
> 
> I can reproduce it with following steps.
> 1) create file /tmp/test_madvise_collapse and ftruncate to 4MB size, and then mmap the file
> 2) memset for the first 2MB
> 3) madvise(MADV_COLLAPSE) for the second 2MB
> 4) unlink the file
> 
> in 3), collapse_file() calls xas_create_range() to expand xarray depth, and fails to collapse
> due to the whole 2M region is empty, the code is as following:
> 
> collapse_file()
> 	for (index = start; index < end;) {
> 		xas_set(&xas, index);
> 		folio = xas_load(&xas);
> 
> 		VM_BUG_ON(index != xas.xa_index);
> 		if (is_shmem) {
> 			if (!folio) {
> 				/*
> 				 * Stop if extent has been truncated or
> 				 * hole-punched, and is now completely
> 				 * empty.
> 				 */
> 				if (index == start) {
> 					if (!xas_next_entry(&xas, end - 1)) {
> 						result = SCAN_TRUNCATED;
> 						goto xa_locked;
> 					}
> 				}
> 				...
> 			}
> 
> 
> collapse_file() rollback path doesn't destroy the pre-created empty nodes.
> 
> When the file is deleted, shmem_evict_inode()->shmem_truncate_range() traverses
> all entries and calls xas_store(xas, NULL) to delete, if the leaf xa_node that
> stores deleted entry becomes emtry, xas_store() will automatically delete the empty
> node and delete it's  parent is empty too, until parent node isn't empty. shmem_evict_inode()
> won't traverse the empty nodes created by xas_create_range() due to these nodes doesn't store
> any entries. As a result, these empty nodes are leaked.
> 
> At first, I tried to destory the empty nodes when collapse_file() goes to rollback path. However,
> collapse_file() only holds xarray lock and may release the lock, so we couldn't prevent concurrent
> call of collapse_file(), so the deleted empty nodes may be needed by other collapse_file() calls.
> 
> IIUC, xas_create_range() is used to guarantee the xas_store(&xas, new_folio); succeeds. Could we
> remove xas_create_range() call and just rollback when we fail to xas_store?

Hi,

thanks for the report.

Is that what [1] is fixing?

[1] 
https://lore.kernel.org/linux-mm/20251204142625.1763372-1-shardul.b@mpiricsoftware.com/

-- 
Cheers

David

