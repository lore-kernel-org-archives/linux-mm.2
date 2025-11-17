Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA155CEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 15:12:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E6318E0016; Mon, 17 Nov 2025 10:12:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 396388E0002; Mon, 17 Nov 2025 10:12:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 285668E0016; Mon, 17 Nov 2025 10:12:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 110DF8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:12:00 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7FB87160141
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 15:11:59 +0000 (UTC)
X-FDA: 84120439158.05.9392FD7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id A749780012
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 15:11:57 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fYFQfp98;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763392317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2+XeOac7x9dGcuLMSUxMnESiDOWeN3Lx2j0ugWvLhI0=;
	b=aZcT5YYMoBNogBfqP806d+yz3HJJ12IxAQan7U55bk3I/2I4pLyrdbLKYfWO5Yhx1r+odk
	eNH9ibE1jwmrSTtEyfzIYmwR6SjvFnL+khi1TswFeRGdG053odpa7MxAWHycgFw5cUTJuk
	aIl0IC5A6/BSkxsI//HANACbQWkxfZI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fYFQfp98;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763392317; a=rsa-sha256;
	cv=none;
	b=bltMxS8E4+wRfADwaAeyVxZDnTQOzu6QDCY4ZEZXKZezqs+aGXKwsOrDWWq9hhd415oMTv
	1gG1pNvD4OTQ/qI+aqoFy3aZV3JshfFLVCz+iaXZDR8bCPCkaG3KzQkSy63Nm7yDwLeoGM
	BHO2CUwE6DBtPWLhXKTeQwL0Nz8Vyk0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 43AB2444F9;
	Mon, 17 Nov 2025 15:11:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D213C113D0;
	Mon, 17 Nov 2025 15:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763392316;
	bh=TwfGBepi2IUAU/4JFAvHJYTM1sRw3y0VTMA2H2PFuPQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fYFQfp98q8CZPq2D3/1HwhNKfQ02GOU/p/lXsiGElTjPUzEmC11RUcdhfE0uh+LZe
	 hkTadqxNsT86x26pV78yE9cHtXOZohKJc0CnrhNLYiIZQceAFHoqFiPE78DidXhXLN
	 tFAKq7VHPXZt3xIHdv8rlwuvCmnXJCirwhXCPCvCDSY+GaHO9QVUWndBeMs4LtVKhB
	 vXQzJeyLQ5i7XRjJafFG+RpCQs24WSu+XrfAhKl64rdC/PRf63+PQQaFX6cPXenQKt
	 k5jwAq/pMGJUEEMPjo9TEaBxkVgMEBH/vcGjv4clAdluHxZE2X66gZlaSyNyJg/OV1
	 zEIIjPZilJmXA==
Message-ID: <9e617d7b-afd7-465b-b075-32b02257b90b@kernel.org>
Date: Mon, 17 Nov 2025 16:11:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/8] mm: introduce VM_MAYBE_GUARD and make visible in
 /proc/$pid/smaps
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Andrei Vagin <avagin@gmail.com>
References: <cover.1762531708.git.lorenzo.stoakes@oracle.com>
 <94d1e9c6c6dd8a4de1f2a8022ca92e2e320730ff.1762531708.git.lorenzo.stoakes@oracle.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <94d1e9c6c6dd8a4de1f2a8022ca92e2e320730ff.1762531708.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A749780012
X-Stat-Signature: opitk9qkopkat5pcjf1ips83wpnokpbf
X-Rspam-User: 
X-HE-Tag: 1763392317-170895
X-HE-Meta: U2FsdGVkX1+ovDr37/CsCXBIuScurxA8yqJUUeBeNMSZxFKknx4+5L3OLaW0AXU9q3DqQsGtDhdNbxngWhFd7em5drLnXFSFyGHzKPr7JrrI0wXtcmnqeReIksN6DoXH/UhMnNvKwFUP3NEl2aThyZL93KMt3wyTTx642wZWKCNZJcKHtrZEm1ZpaJY6n8LrupqHMXUORUzqZeMiVFEZLdpPiHb9j4sRiOjXMmTzObAP9Jgd2j2LLzjf8EhoEQtKCRY8c+iDgwza5FzCdWl3pmbrAurP0BIjoYT3x2dtAsjurR1H1dGBsUF0s2txdObsjKTdvlY8LtjbiZGOyTwL+zIDrguHVQCMri/Qrn+v01wfYJWsvQHdFbx2zvCBP2x6nXqVdjUK8xD2G981HBXxk25tvpy3YCs/I0RImLi37fyg8IjEFyDvogQ/RH5laT8152VTqhzYfTeS9+ttsB2MpK4oMkDwblG8hz50OLCaVnboJ+cGAitdjNGSadhSmFP38kRei14spwg+nittzpg08OqHEbnfdnIg4M1qer85lOVNU8hv9smrB//JVInvYIV2GwAU8rP1szrqW8te9z7k6XxBBKnAre1LUJaRgpbdBCV38MhiqGXWZkqG7DmoqwvHnyOmRBRO3/mTz7QMW7OqCTO9VGQNcPPtkOpQFKSotzY1HC+Hn3PPWCMrwIdQukUiP9WF/ySSb59gwM82ID8/FezridVoPRvFNHZ4YSri9OQxvIofhHGZgsCAVA8U+6Dv7423WCwrN1LDScuNGeG4ywl5fybuJuTAhc40JhqeylxBLkOMksuwNUeWGv0gmFm6ZTO6FyBmYlLZq23ZoMK9NLwJvcCUoNvUcrZERwbSyzoJj4zobJAb2NuBZTZAMj8QUCnn1/fGzeKyf1dYC+6OxCR0uyH1Sg1I0pVlnd5o+NyHKQ+W2HGlJRcGNGMWCTTST5UyXfoQa5aqRJ9+otz
 jT1GCt5K
 z8OWzN81q1yU4Ar7sVvzyHHPb2OnOjqr3D5JY8ss/yCgWp3uY0SR/8vbbhXVQVNfrrVYNvuFjTj2prtEuKDMOv0MGov2l0+oHhXW90qfjARc9jZsy+VLtNJap8xt0hWzDDttwAwK8JZ8oscCc031rUj2IYovXiDkM6uDYVeho5UQDcbj6zPJAy0WwDFCi2qYsTi8a9eRnXTqrrQJ+COGLttyFt0sG1GWaXbBl9lUBCnorHNNn71jdWxc07P4BiKMmWWyA8bCngrtipHQOJO5hHkEYWiXYbz/BSA/vrVqmcbNyp6ASokxv79kgfkui+EwL3PiWvzM5ITo1V8KaVSUFAV2l3o9622RKmdplUEiFJAcILvoHhQp+oJq+GtIO3+qcaGTLh+85ZtQvlHQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07.11.25 17:11, Lorenzo Stoakes wrote:
> Currently, if a user needs to determine if guard regions are present in a
> range, they have to scan all VMAs (or have knowledge of which ones might
> have guard regions).
> 
> Since commit 8e2f2aeb8b48 ("fs/proc/task_mmu: add guard region bit to
> pagemap") and the related commit a516403787e0 ("fs/proc: extend the
> PAGEMAP_SCAN ioctl to report guard regions"), users can use either
> /proc/$pid/pagemap or the PAGEMAP_SCAN functionality to perform this
> operation at a virtual address level.
> 
> This is not ideal, and it gives no visibility at a /proc/$pid/smaps level
> that guard regions exist in ranges.
> 
> This patch remedies the situation by establishing a new VMA flag,
> VM_MAYBE_GUARD, to indicate that a VMA may contain guard regions (it is
> uncertain because we cannot reasonably determine whether a
> MADV_GUARD_REMOVE call has removed all of the guard regions in a VMA, and
> additionally VMAs may change across merge/split).
> 
> We utilise 0x800 for this flag which makes it available to 32-bit
> architectures also, a flag that was previously used by VM_DENYWRITE, which
> was removed in commit 8d0920bde5eb ("mm: remove VM_DENYWRITE") and hasn't
> bee reused yet.
> 
> We also update the smaps logic and documentation to identify these VMAs.
> 
> Another major use of this functionality is that we can use it to identify
> that we ought to copy page tables on fork.
> 
> We do not actually implement usage of this flag in mm/madvise.c yet as we
> need to allow some VMA flags to be applied atomically under mmap/VMA read
> lock in order to avoid the need to acquire a write lock for this purpose.
> 
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>   Documentation/filesystems/proc.rst | 5 +++--
>   fs/proc/task_mmu.c                 | 1 +
>   include/linux/mm.h                 | 3 +++
>   include/trace/events/mmflags.h     | 1 +
>   mm/memory.c                        | 4 ++++
>   tools/testing/vma/vma_internal.h   | 1 +
>   6 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
> index 0b86a8022fa1..8256e857e2d7 100644
> --- a/Documentation/filesystems/proc.rst
> +++ b/Documentation/filesystems/proc.rst
> @@ -553,7 +553,7 @@ otherwise.
>   kernel flags associated with the particular virtual memory area in two letter
>   encoded manner. The codes are the following:
>   
> -    ==    =======================================
> +    ==    =============================================================
>       rd    readable
>       wr    writeable
>       ex    executable
> @@ -591,7 +591,8 @@ encoded manner. The codes are the following:
>       sl    sealed
>       lf    lock on fault pages
>       dp    always lazily freeable mapping
> -    ==    =======================================
> +    gu    maybe contains guard regions (if not set, definitely doesn't)
> +    ==    =============================================================


In general LGTM, BUT in the context of this patch where the flag is 
never set, that's not entirely correct ;) It made sense after staring at 
patch #5.

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

