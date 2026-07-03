Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC1F3C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 02:53:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D7226B00B0; Thu,  2 Jul 2026 22:53:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AF5E6B00B7; Thu,  2 Jul 2026 22:53:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C5176B00BC; Thu,  2 Jul 2026 22:53:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E26C6B00B0
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 22:53:43 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 853DE8D8B8
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 02:53:42 +0000 (UTC)
X-FDA: 84945945084.29.06A80F5
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf11.hostedemail.com (Postfix) with ESMTP id A89DD40002
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 02:53:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DBXgN7QK;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783047220;
	b=zz7DPXQQRvsnaZ3o4OIG3fyeeFFd6NA6OUVll8lBrqlaBpoZ/kLYWtJhf+ClqhadW17FeM
	2UWgSHTx2DmWMZpadB4I1lfaghowClQcvTWUHfVyNJJyDFQBQcxVMd6U+y0jHt6/+uqrXY
	5ERrSisfJvrs0r36DqvCGXH3GpIcjcU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783047220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RvxaaOeMrCU2lWQVKAZ3wsLKjHq/cc0kdYy6Bt76nnw=;
	b=Q/fxVAxGKhmbHQoWkeDhusOlGnSi/1NKMsWiKNwL3FX4XIdIGFt23JLLMxxrV/3iwP4sBr
	kTh2/ldTgBHn3u5YdWL2CNnl2Zc9dVhEEP5T80EtiZZ8kLpwmCtt1qbSCnJnSwntjVBgKd
	qsTBNDXvKbI81gJt9SZCe4t/+yas2Zc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DBXgN7QK;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <d38263c7-b1ea-4709-8d75-2f2355ca38a6@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783047216;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RvxaaOeMrCU2lWQVKAZ3wsLKjHq/cc0kdYy6Bt76nnw=;
	b=DBXgN7QKlULmpihfVgbSTPhw1UekcupRyz0tFrKWObdxrsUClw4DMFYnLpf1Rycp9oYv5X
	XQeZtwGX58b65D62s/ZV8rZBsurIxExQ5tp1eVpN19KW86iJsFQdbjWJgseF2UWX4B4Ao3
	OyqU3/6bA7dIEONEN6KlUnG4t3gT5J8=
Date: Fri, 3 Jul 2026 10:53:24 +0800
MIME-Version: 1.0
Subject: Re: [PATCH stable] mm/khugepaged: write all dirty file folios when
 collapsing
To: Zi Yan <ziy@nvidia.com>, Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 stable@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Matthew Wilcox <willy@infradead.org>, Song Liu <song@kernel.org>,
 Eric Hagberg <ehagberg@janestreet.com>,
 Gregg Leventhal <gleventhal@janestreet.com>
References: <20260702165409.164568-1-pfalcato@suse.de>
 <2DA84662-F9E4-4ED3-A225-71054FEC3849@nvidia.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <2DA84662-F9E4-4ED3-A225-71054FEC3849@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: rsyocq3umgq6bru8e1qtdhbsudre7ity
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A89DD40002
X-HE-Tag: 1783047220-964060
X-HE-Meta: U2FsdGVkX1/3DSKMJNoydPMssIJDXa4JtOOPjlVR2s8yT+V4OuBv6HIXVsRW+bi+zH7wZz9CvRNWX0RPuGybigoxYOYNnpQwthmd6gZENWChGz7nvByBLCHkZ5Ysjg51azvYyeo4mb1NA4sye33EttRMBxYrJN5KgF9Hl6MvF+Gk2kxolMRp0vhIB8+YdpTnJ7wTiyXPUOR66YAGlS5gQD7FXdIb/SMn4auqsVC7Xf5bGnmNfvEF8yN7HC2LSOueR/O6NZoGfcWjYk0d40QYO0RfgBv0MIIxi8u/OpPFFU59mOJs0QNDEVuSZlIwyUxc6da1U8BilqQdFWpzj+JDsyn9lD2usy7Z6F793QUDlhf2RKzz0bftEdCeWd4qftGOTDdSo6JCWOp+LSRNL1EhBla7H6JAGLp56/AUMKOQKiON7AW9oMI/wiJXXyqIT3G1hN98Y2Ek0eoYh12fSdTcttKYAgzDyTyD/X7NnCYFsBiUG3DH1jiou/DVNMMVOpd7JXnKUKh17cEryZgHB6AENGWfOZxEwhZyQKXPYHQ0ojrJrU10ykc2zuihYhVSaVpoAkjPCQLz57IiP/2pD56PX6t3rqFf/8JcoLTExlyxvAPt1Et265sNTK7nOiof2PSXbdAwaz1JKG1DggS96iWigWgFRk7hUsQDftyjXWdeA8b6TFrygWkTfXX5soPgpLZs9F3+Uv/Bn23Xmy+6bRXKDnJeZUQxTt1s/UE3TWmTDWkrC041e0Wq8OYjWC1Ybu4R8KE8h3JJhUsS75b+kENVK0a5NcUr+XNyhxxnt9fLBueybzn67NBrvMiy04NYfyDWw50Uh1hUNkN4BXKcfBvcqOt93S49y1oKbPJmjn+Olh5/rhQkmkOpMeQA8Kem+cL3ifLIHdmcPUQzi4U9xirY61f2X6W/pIawm6osxhqOR2ev1OWEnxhhnDvmXV8ZU5YPy39SqyMQiupxcG+Krtw
 sDFgB7AX
 /wmcMe/H4zSYdpisV0Oxh+hI2RscQV0uVGehgfDMwVCH1BZ4waEt95Rs2KWiwm4VMCLqS7S5Sb3rGbGE4bQzvkHNKJyL1CvpjTJj0AhJHWJU4iJeVd0yaBeStBx4vVkU1cZ1j7F1ie+kHcrUEu6LJ77ULrvYZOHZ2Eirvt7CzCVdE4VIphXHtxXyMED6crzMlG4pVK26JuZKOwOA7czBetxoc0H4g0BmnqM5AJFJHNslzNqoQfDCM4rSZDzEr/JkJ8kFOs2C2LU/MozBXJ61QFVyAfOzcDi/iW1W44q2a7YWc7ad49wP05Npoqh0E6xJz6kN4F4cUvyqCjtz+iBPx09gtQA5hKIIFrdW7rm06q/kZ9JSdtDlzh44ShYPULQOpbGvMgCssbzDzqk1+yVdVdooUAgII0H0g/yQuBxc/MpACIXyZYC5fTzRTC/G7OCYhc2EIKJsdhauK+u8Cr+MN+/8RrA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/7/3 01:24, Zi Yan wrote:
> On 2 Jul 2026, at 12:54, Pedro Falcato wrote:
> 
>> As-is, khugepaged and writable-file opening exclude each other. A file
>> cannot be open writeable and have THPs (because the filesystem is not aware
>> of them). khugepaged will never collapse file pages for files that are
>> opened writeable. On an open(O_RDWR/O_WRONLY), the page cache for that
>> particular file is dropped. This is fine because nothing could've been
>> dirtied.
>>
>> However, there is an edge-case: collapse_file() might not be able to
>> coexist with concurrent writers, but it can coexist with dirty folios
>> (from previous writers). Therefore, the following can happen:
>>
>> open(file, O_RDWR)
>> write(file)
>> close(file)
>> madvise(file_mapping, MADV_COLLAPSE, some non-dirty range)
>> open(file, O_RDWR)
>>   nr_thps > 0
>>    truncate_inode_pages()
>>      /* THPs are cleared out, but so are the dirty folios */
>>
>> When this edge-case happens, there is data loss, as the dirty folios are
>> fully discarded.
>>
>> Fix it by fully writing back the page cache (and waiting) when collapsing
>> file THPs. Doing so provides the guarantee that no dirty folio will be
>> observed while there are active THPs. To fully ensure this is safe, the
>> invalidate_lock needs to be held while doing the writeout, so that
>> do_dentry_open()'s page cache truncation excludes this write-and-wait.
>>
>> Cc: stable@vger.kernel.org
>> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
>> Cc: Christian Brauner <brauner@kernel.org>
>> Cc: Jan Kara <jack@suse.cz>
>> Cc: Matthew Wilcox <willy@infradead.org>
>> Cc: Song Liu <song@kernel.org>
>> Cc: Eric Hagberg <ehagberg@janestreet.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
>> Reported-by: Gregg Leventhal <gleventhal@janestreet.com>
>> Closes: https://lore.kernel.org/linux-mm/CAFN_u7H_0ECF3jixP=T=U7AH5=Q3wQNvJMo8an3VqUDMerQfUw@mail.gmail.com/
>> Tested-by: Zi Yan <ziy@nvidia.com>
>> Signed-off-by: Pedro Falcato <pfalcato@suse.de>
>> ---
>> This patch is written against 7.1.0 (because the code no longer exists in mainline).
>>
>> Zi, I kept your Tested-by, but I had to move some things around and
>> use the invalidate lock. Please re-test if you can.
> 
> Tested it again on top of v6.12 (the patch applied cleanly) and the issue
> is gone. My Tested-by still holds. :)

Since READ_ONLY_THP_FOR_FS is gone from mainline, just to confirm: does this
only affect stable kernels, right?

