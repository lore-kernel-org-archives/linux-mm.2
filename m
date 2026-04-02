Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B01FED3942E
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 14:36:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F77D6B0088; Thu,  2 Apr 2026 10:36:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CF846B0089; Thu,  2 Apr 2026 10:36:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFFF36B008A; Thu,  2 Apr 2026 10:36:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DCDCB6B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 10:36:09 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7530C14070D
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 14:36:09 +0000 (UTC)
X-FDA: 84613865658.05.83A84DC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id B6C75140016
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 14:36:07 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gZkI1qKF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775140567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M4lioeZV/Qgvpz2qdwy0tvOL0tbHRvWqrRW18fGnoQk=;
	b=4d0q5msPiz4EYWm5Qjw3MEORMNhefXVNZaW7/YvVpfETWwh0SzuedOWDD0mPbVIHCZItkP
	ox+ohD9wH/kfi+5Q0JdQWufxNb/46PlQwpW5ZR7/hDBeBNkq+7wgBBXb+9EMxQbI8gRCD9
	8PLLtjH+x27qCI+Ded4AuQVf7cxQVn0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775140567; a=rsa-sha256;
	cv=none;
	b=q7pFLDsR0ce8fpKwKNhpXxbYTmooJijP23AymZROPTJdjuGthVLSv7YG9AJ6a/v7tZL48T
	a0LLiKZaFr3m+KEi1gUNQM15FYpY44Fgu3VnG5DISla+ztyPAaTWzfZ+205C/dYBs30hCp
	7xBGS6aKwrYXSYoqr0f0d17KlqbnkbA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gZkI1qKF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A5B5F60121;
	Thu,  2 Apr 2026 14:36:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26644C116C6;
	Thu,  2 Apr 2026 14:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775140566;
	bh=7SCfbCoJtq5q0RD/JJGIsXRe60Kg7wtGU58y09PXT+4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gZkI1qKFjAV9FAxkoNjUA/dEdVQSCBB10/ocV6e+opRkjrRtkhI+Lk9iAIFfL6/PU
	 f56d2pMSIHuxBL39mkIEw5Q/9Eri0du3hh7BNqeoAp9NgH1bO9WisKrkpdNLfXjOXS
	 EMiROD7uRd1E2Zt5GXe94xzEl0snqaADC3hl57Dly5KeZsEzSjDudfeplFfjFAX6Ui
	 ABWg7ae/I4DwKF/Vuope1cyerZbH/ZP+T16UtJyrhTcBxbgABci2BDTXv/DgkH9uDt
	 aEkG6BpCQ0am7WfrWTBvR6XFtj/CuYsb89Tzj/VN+Y1++Ao6a1uKCvko07pbhhWiHF
	 R2SDTi52RGyjQ==
Message-ID: <d1fa25cb-083a-4afc-afce-a62929acbb33@kernel.org>
Date: Thu, 2 Apr 2026 16:35:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 03/10] mm: fs: remove filemap_nr_thps*() functions and
 their users
To: Zi Yan <ziy@nvidia.com>
Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-4-ziy@nvidia.com>
 <aaea8ce1-eac6-49d6-8c85-7361977b9a9f@lucifer.local>
 <b098fce7-be16-479e-b9a4-36f0ad71d242@kernel.org>
 <53cf6157-58b1-4539-a276-2486e8796c57@lucifer.local>
 <25899F67-955D-44DC-935E-D7F234BD335A@nvidia.com>
 <cd36fe49-56b6-4ec6-8dc7-9c793f939bb5@kernel.org>
 <EF04F17A-89ED-40EB-BA91-7A82713E28F8@nvidia.com>
 <f7e1bdbf-cb88-42f0-ac48-1a273bda2455@kernel.org>
 <44DEB48D-589B-493D-A278-4896BDB58564@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <44DEB48D-589B-493D-A278-4896BDB58564@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B6C75140016
X-Stat-Signature: pyfbq9417qhqfga1n9mk3ajbzx1ggswb
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775140567-330000
X-HE-Meta: U2FsdGVkX19vECElMK6JiCo6KCOBd7mFgWw6pzx55hA0YOkDxOBs1iVlwMqPSZUpJGuc00FMRPFEdQVSqnYS7w9zvPbXN5QZvUcMEKRsM2a4DO5L65Jbz25up1LO1t4v42Fx95vYDXQwr4MX5wRG1aAvcb7qUMtlOfgKeKvAMUXgpbbfrOsQ6KDmvTWheqeKEyBmQ5jntT0V9sY8rSpRq5sOMp6dup57E0MySoG8ks+M0El5zo0vmWIm13kRAYlJZCGos89mIbMh5d5zrsc4zy+gWKMQPPRvVA2BG0xe38tAFVPeu17Xt7S6goHO0hKgEWkKd72ER6mtlC7SDx0bDDSEX5y9/f37KmBhcbj6nGeNy7mOHTKMap+CpIThbDvWl2hRuxBeSV5YK/9muW0qgAL+c1CLUUM0uW0R+jO/KlRkeXNTSl6hJkBe0appqvfV9/aR0Va1A0GX5nvWlpfDXqE6i0d4QdpS+bdo6nLSJdowXIrQs7+qBb79AGlaGbCOJMTtSDP2aD2sKvEZVN2a+ugavzG1zrgYAAmQYJKM4/YCkGS30TdABCYHHkSWRkPPw+vcIF0TwE9kIDzISTXz6UYwnTg2OUhKViWvZs8FLsb8vkijcwIbJoBcxihq5C3b0plF5qqq60bMNJ6RGpSi1tMIoNd3KyfynT9jsHonwlfYgyBRwt6+8Wz1lfTbbcmAeeLg4nKQPfq1V4kH1r9MF+N2wrueG6UIWY/MLX6HUvuw8c0wuKi9u1zgx9wovGaQSDmBNLZbo8UNQMkpL6dyptInBHkXoN+I1rlGnNgqufTDQHlEtasbALa0LlmIiBjhs+poShHu0yJ5IRfEkOnZPIS0LlmrJVqOgvspH+7ekJwtrM/Hm46iCNZkQnKC4ccx2M+sifuxKOel3m5sPKd29BznPPoUVpWN4k5mg350lBhihtM+GHzAw5o04FtGoa+4gqVwoDy0lZhb0hnNxTg
 JtyWl2AN
 pukcDSNWC0ujhkvDXtoKqKfsqCcZg7/nXhcwE152jjNSd3CauN10K+qmPjz6ujJm+E0AQKr7dCpgwYikxuKSW3wd7GiKhIgR7RO/OZq3ZuNnrusVrQeNXcNBWKMrpNNgoRmH12noxYV5W5U0+FzrZ6Y9+yBQJ2V+7ZSEF8rjmvh0RzxWJjtrEUKivGl0T0zdfxot2Xhjq69/wHOyN67a7NSQYaovaM2r8noXy92KQAQ+s2XBSJVy2qJ7y6IFg6Hib8kUJAEVoDzKCpyoPc15BhzD5r5/HWh2m+DXNzFQJfUL0w0ezrKA8o16kGW/Wgi9l/XpdmlbwCU1s71o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/1/26 22:33, Zi Yan wrote:
> On 1 Apr 2026, at 15:15, David Hildenbrand (Arm) wrote:
> 
>> On 4/1/26 17:32, Zi Yan wrote:
>>>
>>>
>>> Let me think.
>>>
>>> do_dentry_open() -> file_get_write_access() -> get_write_access() bumps
>>> inode->i_writecount atomically and it turns inode_is_open_for_write()
>>> to true. Then, do_dentry_open() also truncates all pages
>>> if filemap_nr_thps() is not zero. This pairs with khugepaged’s first
>>> filemap_nr_thps_inc() then inode_is_open_for_write() to prevent opening
>>> a fd with write when there is a read-only THP.
>>>
>>> After removing READ_ONLY_THP_FOR_FS, khugepaged only creates read-only THPs
>>> on FSes with large folio support (to be precise THP support). If a fd
>>> is opened for write before inode_is_open_for_write() check, khugepaged
>>> will stop. It is fine. But if a fd is opened for write after
>>> inode_is_open_for_write() check, khugepaged will try to collapse a read-only
>>> THP and the fd can be written at the same time.
>>
>> Exactly, that's the race I mean.
>>
>>>
>>> I notice that fd write requires locking the to-be-written folio first
>>> (I see it from f_ops->write_iter() -> write_begin_get_folio() and assume
>>> f_ops->write() has the same locking requirement) and khugepaged has already
>>> locked the to-be-collapsed folio before inode_is_open_for_write(). So if the
>>> fd is opened for write after inode_is_open_for_write() check, its write
>>> will wait for khugepaged collapse and see a new THP. Since the FS
>>> supports THP, writing to the new THP should be fine.
>>>
>>> Let me know if my analysis above makes sense. If yes, I will add it
>>> to the commit message and add a succinct comment about it before
>>> inode_is_open_for_write().
>>
>> khugepaged code is the only code that replaces folios in the pagecache
>> by other folios. So my main concern is if that is problematic on
>> concurrent write access.
> 
> folio_split() does it too, although it replaces a large folio with
> a bunch of after-split folios. It is a kinda reverse process of
> collapse_file().

Right. You won't start looking at a small folio and suddenly there is
something larger.

> 
> 
>>
>> You argue that the folio lock is sufficient. That's certainly true for
>> individual folios, but I am more concerned about the replacement part.
> 
> For the replacement part, both old and new folios are locked during
> the process. A parallel writer uses filemap_get_entry() to get the folio
> from mapping, but all of them check folio->mapping after acquiring the
> folio lock, except mincore_page() which is a reader. A writer can see
> either old folio or new folio during the process, but
> 
> 1. if it sees the old one, it waits on the old folio lock. After
> it acquires the lock, it sees old_folio->mapping is NULL, no longer
> matches the original mapping. The writer will try again.
> 
> 2. if it sees the new one, it waits on the new folio lock. After
> it acquires the lock, it sees new_folio->mapping matches the
> original mapping and proceeds to its writes.
> 
> 3. if khugepaged needs to do a rollback, the old folio will stay
> the same and the writer will see the old one after it gets the old
> folio lock.

I am primarily wondering about what would happen if someone traverses
the pageache, and found+processed 3 small folios. Suddenly there is a
large folio that covers the 3 small folios processes before.

I suspect that is fine, because the code likely had to deal with
concurrent truncation+population if relevant locks are dropped already.

Just raising it.

> 
>>
>> I don't have anything concrete, primarily just pointing out that this is
>> a change that might unlock some code paths that could not have been
>> triggered before.
> 
> Yes, the concern makes sense.
> 
> BTW, Claude is trying to convince me that even inode_is_open_for_write()
> is unecessary since 1) folio_test_dirty() before it has
> made sure the folio is clean, 2) try_to_unmap() and the locked folio prevents
> further writes.
> 
> But then we find a hole between folio_test_dirty() and
> try_to_unmap() where a write via a writable mmap PTE can dirty the folio
> after folio_test_dirty() and try_to_unmap(). To remove that hole,
> the “if (!is_shmem && (folio_test_dirty(...) || folio_test_writeback(...))”
> needs to be moved after try_to_unmap(). With that, all to-be-collapsed
> folios will be clean, unmapped, and locked, where unmapped means
> writes via mmap need to fault and take the folio lock, locked means
> writes via mmap and write() need to wait until the folio is unlocked.
> 
> Let me know if my reasoning makes sense. It is definitely worth the time
> and effort to ensure this patchset does not introduce any unexpected race
> condition or issue.

Makes sense.

Please clearly spell out that there is a slight change now, where we
might be collapsing after the file has been opened for write. Then you
can document that the folio locks should be protecting us from that.

Implying that collapsing in writable files could likely "easily" done in
the future.

-- 
Cheers,

David

