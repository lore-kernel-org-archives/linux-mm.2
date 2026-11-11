Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F264606A320
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 08:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z0lg2dMz
Received: by kanga.kvack.org (Postfix)
	id 46FC96B05B1; Wed, 11 Nov 2026 03:18:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4468D6B05B4; Wed, 11 Nov 2026 03:18:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3370A6B05B9; Wed, 11 Nov 2026 03:18:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 048886B05B1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:17:59 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8BF6A40223
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:17:59 +0000 (UTC)
X-FDA: 85422135078.23.7B90812
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id B4762160003
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:17:57 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z0lg2dMz;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794385077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JjqXs3HoQpEHN6otr6mHB8M84/EWiaNnxYY5mSAu4Q0=;
	b=TrW5jR+3toJgvHHFWvliIGGr0vH9hJ1Jf0lfynARTqdB3ThCrOHTScFvP7NeXF9/mJkRWm
	Go0IPcpEsa2+LM9DHeWLS+rxPk3V1a0iG/djbMIKn7z2sBupEj0ovRJpEN1hs0nluRoCHh
	DhMntezlLp0YmJoXcQMwakttpBpIObk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794385077;
	b=PJ017F5M3qR12iFCZrJb3qVz6RgoprcWDPw3PJfgGKCv9QKZkM+3j6BwuEDUoVo5ey3jQ3
	AWVVvC4XMu2HU982LLwtgst4C7aIz85tG0F6HplLuynuHuPcWryvpY3JpFrYJ3Uw3Kq01C
	QQ48vMQHcsMXvfTMEhMJ1+fC7+Z0P8k=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z0lg2dMz;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E885243597;
	Wed, 11 Nov 2026 08:17:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1DBA1F00A05;
	Wed, 11 Nov 2026 08:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794385076;
	bh=JjqXs3HoQpEHN6otr6mHB8M84/EWiaNnxYY5mSAu4Q0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Z0lg2dMzPTK2I/fb78yKkOyDefR41RgDE6wgeC5vIbTKMnC3M7veH0J5PL0PnYO2r
	 UkrfGCByL7Wya/iziyNm/lHZOO9yKX6OgBvNZbZL5ASWu3hoM1UJ+7XTFSGXN3emB+
	 ivyOa/JbkeIgjkMKGAUZtsx2Cw/AUyKiRfoEoIKmrWUleGk3J+7Xk0bnjcWqrQ3Hc7
	 f4ZFLrznIqd2imPtCkvhJ6mPRraoc+xDyd7RyX2ECrEXXcEUu9xqzpuoeUgfnqhsL9
	 6dBC3QVeNEdRJ6p/ZznhT2vi5iihjT712vi0Do7Utqd8Pa5MdMnSqSxhh9D7eAE8YS
	 MDVSudr6R6u7w==
Message-ID: <cd873616-28b4-4c81-95be-2a239d8680b3@kernel.org>
Date: Wed, 11 Nov 2026 09:17:42 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/khugepaged: check for empty PTE tables before
 retracting
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: sashiko-reviews@lists.linux.dev, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Peter Xu <peterx@redhat.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org
References: <20261107-b4-uffd_marker_loss-v1-0-82926b22704c@kernel.org>
 <20261107-b4-uffd_marker_loss-v1-2-82926b22704c@kernel.org>
 <sashiko-outbox-203403@kernel.org>
 <28b818cb-f038-43ce-a2e2-a9c97befba09@kernel.org> <avNO1pvPuMYIdYTE@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <avNO1pvPuMYIdYTE@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: ft9ieyjq5amyyj7g3cwwm5pief3okyan
X-Rspamd-Queue-Id: B4762160003
X-Rspam-User: 
X-HE-Tag: 1794385077-332277
X-HE-Meta: U2FsdGVkX1/vBibfmtV7tff14GYGAcZ1x69tEh43mxdSgl8ORerWNUu4dNqcHS5t0KyivkDTNoMFNUjVAZl2aYMF2qUrHsW4LtCePqBvFhrWNmc6qSMTqC3dLxefye/t40hAEkJdulIUY9e+kQsGhImHOoWVVqW3Ybsz6gmjfAoTORr/YT3xfRg/yXDJ0eFnBtXDuKfF1etRQfD/mre7cCNrG57Ol19Wdj9UkAcpMQRSy2fXkk+g7n3OwrWsOk8EFpFGXZIeOgFcQ9kxUOuMdi9RuM2zkJ6d3QjchPpOF3XQIykanwfDpqO5m8KYuy4CmKU1lk5ndM/3EgtujRgxJQCGPCItRtGZHtwXC7/IMsfQZ+Cjq5RF/lAU6Hg6Vp52J3ODjQUgWrh7zOUeE33/1ggvaJm1+3bv+008RNHhsOgZ2AABTR/9Fw52uwG7OjcNPMBY3kM/PG6IuIlMmrKTQUuC8yqG2da6HME+Shnw3usMWjuRUq3QSsEnzpiK+iIIEetR1fS8Dt6Q35dYtoLWKq/RT3qpIX7F2dGy2BY6Sehn4HMSOmewIbDfBKL/cmZD37A1zC3n8S3+LgF8ndSXZ7JI/suh15AXodkdkgREZ8i+ljT9m7k69BHOcLQJLAjr9a2Pm6OmgmaNay+Z6t0C0UkCO5BL4R8qqZ0XnNizosiS/STVwasWZ4S43YCt1egHGisxg0PZanEkXBlnfqjWNvQEt+fB6yZTpHC2DtMO4miVxOkpcLcOtcy91Vp9IsmavpDtX/vbxh4UwDIbZPitG2PkOlDQF1jcT8H3lfb8I2zvM+VHjJ26V0uUEs6lBT7OsPN/TY4aGc2LPZRu85lT20GAdF7N1ZagR9Ntmiac7XiY+4a716CVKMLWURVZ2JGd7nuPIRgD0ShFh1flDFizyv2P20edwXriHUtR9A8DHyer6qPcb1EJvl8HyTwVjvjd4KFCTOsnsa4HLNj8Bng
 dRnxuhhR
 gc65C74KzoOrvGCNvNAkiASYaYAaHa7L2gv518WDeg3XQ14jFNa7YxDF7RuYg/EdpJewcGPd9ry9F5ODzLs3Jl13NVkuVaGvpyu3MaocRQO7lAwKeH0TUmVvD0RkSeoZVb0LlorlTab8nVoStvqBeFgMuzsIo2lut4AOg3ZNJSGfIUFJ/RSVft7DlvrPx0n2+E5jINIn+FFntbMYzvk/BeS8ogRKLjlWzYWybM5uh+h/ua0BQiIQAoV0s8ISk6rtUDqzSQvilJtaGPuenCpVaXRx68bxEhJizNDVO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/10/26 18:08, Lorenzo Stoakes (ARM) wrote:
> On Mon, Nov 09, 2026 at 04:08:23PM +0100, David Hildenbrand (Arm) wrote:
>> On 11/8/26 00:51, sashiko-bot@kernel.org wrote:
>>> [Severity: Medium]
>>> Can removing the VM_COPY_ON_FORK flag checks here cause retract_page_tables()
>>> to race with copy_page_range() during fork()?
>>>
>>> In dup_mmap(), the child VMA is linked into mapping->i_mmap and
>>> i_mmap_unlock_write(mapping) is dropped before copy_page_range() runs.
>>> vma_needs_copy() copies page tables not only when vma_has_anon_rmap() is set,
>>> but also when VM_COPY_ON_FORK flags (VM_MAYBE_GUARD, VM_MAYBE_UFFD_POISON,
>>> VM_UFFD_WP, or VM_UFFD_RWP) are set on a file or shmem VMA whose anon_vma is
>>> still NULL.
>>
>> Ah, try_collapse_pte_mapped_thp() runs withe the mmap lock, whereby
>> retract_page_tables() only holds the rmap lock.
> 
> [ ... ]
> 
>>> Once the PMD is pmd_none, the next fault in finish_fault() installs a huge
>>> PMD before checking userfaultfd_armed(vma):
>>>
>>> mm/memory.c:finish_fault() {
>>> 	if (pmd_none(*vmf->pmd)) {
>>> 		if (!needs_fallback && folio_test_pmd_mappable(folio)) {
>>> 			ret = do_set_pmd(vmf, folio, page);
>>> 			if (ret != VM_FAULT_FALLBACK)
>>> 				return ret;
>>> 		}
>>>     ...
>>> 	/* Using per-page fault to maintain the uffd semantics */
>>> 	if (unlikely(userfaultfd_armed(vma)) || unlikely(needs_fallback)) {
>>> 		nr_pages = 1;
>>> }
>>>
>>> When userspace later issues UFFDIO_RWPROTECT on that file or shmem VMA,
>>> change_pmd_range() sees pgtable_split_needed() is true and calls
>>> __split_huge_pmd(), which zaps the file huge PMD back to pmd_none without
>>> populating a PTE table (since pgtable_populate_needed() is false for
>>> MM_CP_UFFD_RWP), so RWP protection is lost and subsequent accesses fault the
>>> unprotected huge PMD back in without delivering RWP faults.  Installing a
>>> huge PMD also causes PAGEMAP_SCAN to report all 512 pages as accessed or
>>> written after a single 4KB page fault.
>>
>> "Since pgtable_populate_needed() is false for MM_CP_UFFD_RWP" I think RWP also
>> needs proper uffd marker support, independent of the change here.
> 
> Hey,
> 
> Wondered if you planned to do a respin on this? Want to know whether to delay
> review for that or not, thanks!

Let's move forward with patch #1 for now. Patch #2 is mostly a cleanup on top
that can wai.

-- 
Cheers,

David

