Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38A68606A881
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 15:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R9IZPu56
Received: by kanga.kvack.org (Postfix)
	id 1F72F6B00EF; Sat, 14 Nov 2026 10:40:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A7D16B05B0; Sat, 14 Nov 2026 10:40:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09C5A6B05B1; Sat, 14 Nov 2026 10:40:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CE5B86B00EF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 10:40:03 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 471CD4046B
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:39:58 +0000 (UTC)
X-FDA: 85434135276.16.28CA5B1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 76948C0008
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:39:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R9IZPu56;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794670796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X5eNB7t15oqibkYLEbf3vFkeTE0MI+KiGdQxvQFH3vg=;
	b=QsUg0UeMrc+MK6EXFYu+ys9xUxyvxRqQNcDxvKYeFDY1v4L++M35eAnoBNctfVPY71g/Av
	f5z5lR1nhPwvbs/Kqm4Wvf8c5EC8b1y4w4btiZ79O+OcAeqPQfYguvbzsW2xDJ79KnC2TX
	ECplRm/vXMTXL5VoGeu++hXjNv5cb70=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794670796;
	b=HXQtElvMpg9Hs8e/sCLNYZW3ol1nGnvemPn/XZ4GqrH4v73MARvs8sKQmcxSmJbJqzWFGU
	Hi9ZfiG2Gq6H7MfRJ+cRw1HcZPcl/XpBfy6ekQIefl+CZdQPS4MGcx0h57No3isY2wjIOj
	Ny2qgsT02ixq7856EB42jyfEeym9e4M=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R9IZPu56;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0028461838;
	Sat, 14 Nov 2026 15:39:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E2E61F000C4;
	Sat, 14 Nov 2026 15:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794670795;
	bh=X5eNB7t15oqibkYLEbf3vFkeTE0MI+KiGdQxvQFH3vg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=R9IZPu56rcOtuEEtMLDxI46lPqueOi50zstru67q8h5p5BHM4vSyaZe8p+7nnG0YW
	 emOitgZWSXZvi8MHAANezIPSoH3rzGObtF177H/gG6ZNm7/YVnUiz1F+sZlxrCBYz1
	 g+9auJWpWmSQl9aqTQ89LdUUAn1z891utpLgCvPVv3qA49q5tAeKchWnfA7bLERAOi
	 IttAJOudp9wQXqLoJAl9jTG7Iii+j1yjJj29ptRwWcvMDu8v7UbP6qrpNm3fAPNqyK
	 /wJt08rgmxK1t2GfhYxADkh6MrDnRhOINHy4qyNxenT9MncKmBRn6Qif3nRxJtV71K
	 mF2G5t7uBO2mQ==
Message-ID: <822c1c7e-bfdf-4570-bf30-08f187e7253d@kernel.org>
Date: Sat, 14 Nov 2026 16:39:44 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/userfaultfd: prevent poison marker loss
To: Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Peter Xu <peterx@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org
References: <20261107-b4-uffd_marker_loss-v1-0-82926b22704c@kernel.org>
 <20261107-b4-uffd_marker_loss-v1-1-82926b22704c@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261107-b4-uffd_marker_loss-v1-1-82926b22704c@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: knjgda3r49ftpetb8pgg8de4a7ndof7n
X-Rspamd-Queue-Id: 76948C0008
X-Rspam-User: 
X-HE-Tag: 1794670796-580458
X-HE-Meta: U2FsdGVkX1/tSGjsg9ASUnMv1orLvJD9v9TaCOJQwpey7SV4ZVOBh0StvYN12+B+Q+R8GeWZgMEKfzcZF3gU7dsx0r4G09TY9UDYqeUbpVoo1y/3N7un3/3jlkgI0dJElEowswpXVQECmt3fSTyRDAaSdtvYWoSqxSHbNR+yxAqT9o/qxuGaKU9rhLqGF5sxCEHDZkWmUODS8hQvAGrqikNcyllg+k0FzVcxB3rre7TfqKPnZsuBSW5KqyG4S62+3R87zsDryCH5O0POEtbS1jeaD8xMhCxsXxEpsVUbWsUgvRe7RGpl1cnAmGcMQ+YBAaYllhZf/2OexiPbnO7r7jRpODKv+GLX4TN9QdN89y+ALbZY9mEYKdd7YBmk9586PCMuQqplRbSZKeUf39irbLgKo0IHOFW5+Rt0PCLncPTeSmKOXsoIcnp++qU+phfjHE2/r6LfbzOxy8YjzA/dW77xFe9F1YU452eE4jGPY00+75NVDl6FN+HcrjWScFYLsGb+a0KB3EjGkfXRX+T9WBrpRI2hbAswuAS+FsJl6+DIAyAZctiMdPWNRs5en8kCrsLLBa1fc+JkcTE+5zqc50CipjAfhfitZ9cRVMUjVnk3Y7EWWY7XeTfEcF6rGe83TYMULb8lYm88C/0tN8tLjW6lgnBrlSNqsn9kOFvK3eEoFFZdCdIW1K0XUTEqwbG5seWWS/8FL7f3HTzIDwGzf75b5xEm49CdQ4eWSAPQlv4Ul6o36OtXFP1TES01D73Ucwv6gSekrjpCKckJxwUd7r+lw+p9PX+CnzUco4pZidgrsNqIeL6G5CkEmIWJpkFIC7aSh8FFVOWs0sWxpEJIzd3ZMpt78DyMXWZqHLll+4mADxssqhWCoOAFj4OZByelujhm8KCOyq59v5X6bja0vrko4u54FsRETfsC/sFg9bRNr4qhEEvR95hTOB6m6f8ONHtPnkPrecD4JyM/Dpc
 OsSCzP70
 hupsx+jXarn70ci44oQKv0Pc/7VrdU+kQye3vFPtq4q9ZopZkEub4n39OD+KqLzZL5jMtm9dZrP3ktYkJzGWJ0dOkBmFWbUNvpQ0IeiRKfFvbdtEAntrYKr8EFhReOSM4dDJ7URW6jvxFk/DWmugkCC012IeithaZpR5BLWk5Ot+AqMPv3GIUuLnS0z6OJljMCbaiFRzyL7qVeelicYWzHoawH8nNUZnbx/D4PEpprRL6mEvrGjsWr++y5E3v1bs2rzxIugc74F6QTBWeoeYeTNqeMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/7/26 00:51, David Hildenbrand (Arm) wrote:
> Unregistering userfaultfd leaves poison markers in the page tables.
> However, once unregistered, hugetlb PMD tables can be shared again.
> 
> Further, shmem page-table retraction can discard poison markers even
> while registered in missing mode, and fork() can skip copying page
> tables containing poison markers.
> 
> To fix it, add VM_MAYBE_UFFD_POISON and set it before installing poison
> markers. Preserve it across unregistration, splits, merges and fork(),
> just like we do with guard markers.
> 
> Use the new atomic VMA flag to disable PMD sharing and page-table
> retraction, and to force page-table copying during fork().
> 
> Move VM_UFFD_WP to bit 44 and make HAVE_ARCH_USERFAULTFD_WP depend on
> 64BIT, freeing bit 12 for the new flag on both 32-bit and 64-bit systems.
> Expose the flag as "up" in smaps.
> 
> Losing poison markers, while unpleasant, is not really fatal, and the
> use case is rather a niche thing. In addition, we rely on the atomic
> VMA flags infrastructure ... so let's not CC stable.
> 
> Fixes: fc71884a5f59 ("mm: userfaultfd: add new UFFDIO_POISON ioctl")
> Fixes: 8a13897fb0da ("mm: userfaultfd: support UFFDIO_POISON for hugetlbfs")
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

Ping on this one.

-- 
Cheers,

David

