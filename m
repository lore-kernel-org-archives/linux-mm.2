Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D927606A333
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 05:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LCGBC/PO
Received: by kanga.kvack.org (Postfix)
	id 4C5096B00EF; Sun, 15 Nov 2026 00:42:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 476436B05B0; Sun, 15 Nov 2026 00:42:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 364FC6B05B3; Sun, 15 Nov 2026 00:42:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 101056B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 00:42:56 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 845231A0587
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 05:42:55 +0000 (UTC)
X-FDA: 85436259510.25.031BD6B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id D91D140007
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 05:42:53 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="LCGBC/PO";
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794721374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nyBkJVwlUhwTxJyGO+bv5cKEFN7sPZnmNLTwTWcdOtQ=;
	b=7z5Op46oEZWY3DFsHpQL5nrmJcW7wh0KiUpNzvMgk8vUaEHfCsXjXMwjmAhNpEYMXqvKV3
	KoVPtUiUbWxKBFVb+lc3RGzLQegkyVOlqGyhyk0coQ2FIQt5OxcprCyrtTwciS3btxEctI
	EmTBX4D5aanoxTjAPKn1ykz+X8KG1uU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794721374;
	b=ot6S6yUSgNru7W91+eLN+re46YAPczC+VzWy245XZLw7qC+1CGM/L6VPcWa+ItQFOX1q8o
	II+G7Pi9BkuAQx3whGdjKwjn8V55A5Kx+zaMGuRrIhyTNM20rbdYEkowvoiS+PdR094Sp2
	7tWph7qjSv6Ne8ZmjT17Oq5qQnlY6G0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="LCGBC/PO";
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0480C455A0;
	Sun, 15 Nov 2026 05:42:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B9FE1F000C4;
	Sun, 15 Nov 2026 05:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794721372;
	bh=nyBkJVwlUhwTxJyGO+bv5cKEFN7sPZnmNLTwTWcdOtQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LCGBC/POf5Gn/rnspd1Eu2NhGBKKHCC5PeEenTKJRyjA1UBFCM1dny8zz0QppLOUM
	 HUiWHTNDTXtwkwW1OQyWllS/gQ2v0jl/x5WpfwxLL+0Q1BzwRwMyIlkhwZlBlvE/Nd
	 u783YyJBqEacJoSMuwJIlCy0bup1mHkGTtHTODpEBhAfROGZ8kPKWfgrFdV+YB5MFy
	 QY5pke4h0wswcPg0lWCW9z7Rv2iPlZabnpStD0oVk2erJMzkbG57hrs/O/pJjgnnkB
	 qIXZaGwq/OZ4+T05gvgbrOOtA288S3SeslMygDVYek2efEcTJVgcLvbLaxObJC7QL+
	 TWu2cBtCMwfug==
Date: Sun, 15 Nov 2026 07:42:40 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Peter Xu <peterx@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/userfaultfd: prevent poison marker loss
Message-ID: <avlGUD3Gl4UF0Upt@kernel.org>
References: <20261107-b4-uffd_marker_loss-v1-0-82926b22704c@kernel.org>
 <20261107-b4-uffd_marker_loss-v1-1-82926b22704c@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261107-b4-uffd_marker_loss-v1-1-82926b22704c@kernel.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D91D140007
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: fk6a5nmxxhg7j5ai7ub4m98y16yckkyq
X-Rspam-User: 
X-HE-Tag: 1794721373-126561
X-HE-Meta: U2FsdGVkX1/b3hn7JqNmSxU6OezHcfSZHMkLF2wcvYjaHXdymGFRqJikgeCqcMwy+0F5Xhk9s88DIiXSb0TBh2zGvQiZkx1bfTGvP9drLg1tdIycWhnZGH0vpB6c14QJVK+xqxiHiZzO0jwQM9GrzQYqCFcxG3ZGFzpzY1QHQ+K443TKxtMQ7uUSja44pxWX3pAYm4vEtDdAPJLlDf/WLWgHVbMoXnnBakIJ5ZvrLnD75nfYHV3pHo+xry037M9oQCARPIWqESgboizZW9Cj7j3Tcz5xmw6qEwMDwlXwUbFQduMxc7Wc/Ln+xQzvCd3l5KRtLH60JX6/8qznR0ZlX9DucYG4lQfJPhq3RWCDXg3ERIXxK/JfEss9996v5thwvvTv6cHFb2IPtQGCOSbXEORnqXiqujTte9n9Amz7Q+8OTuKvyufJGQDiW4a0hFH8o983eaaBAU+XozIf7MHcXvzLwnUSxWjKdWRUAYc9eN8GOHSv5nGDEpXdWy/JGVbdIR7h7T3LA4H5WViWJvNFsss727XF4/wcfXiUfsV6+DIhjtDZ6SGCKsjqa1OSC+GqeSLqzCTHlY2XMSc19IzsoiVa4JAHeVOsWciLa7NNwwSBKphvpiLh+Yt7FHLftne28IfNHMQACD/sINYalkuknOtyTsKlIv2esDjk7Feh2QcZYAnZ8WqD47iTtqiWcdruKhAAuAY8Et+e0A7dbQy59ia/ClbtN2QC95Va59IoJ92aIyCjshuP0n4DXd5UmDQ2iTyjHGHed84pBDmTzs9Cfom5MAznz6rTbNZyFgUqOymAvxMqu9j/6nhT6mpNmkhJZ6EOIfWAwjz0SgHtZJ36zx0TJz6XfyzPX3OLNTT++j0y6kQRKseOQBiroKS9MVQ8jnSeGUgFj/giHLqIAODkWcPHseGq46dNQzgL0dJVpSuruIPJttzZhGh6GBqrh+Ild+4mWC2T24RbkIuir0w
 vT+S53bV
 yDjWlidWkcI9DcKFe163IjGKMOYg14ujkJ6hClbqBlVOFsotlPZjwL5EVUwZHQkMkr1zvpoUAbqni6kUBeJJf6uL21+tZidbim16Pcpsg5iSkeBYJu6ex8OptGpheXhxv7joLjhZShz1J/agkQc120HoBpTCHybOwxD61KhtXzM/p37tll/UbLw/C7LpUlrLIXqC0woApmjrL/8FiNSxtv6AnaCK5+idny4/i5WG4quVUPl2cHG0yMaXWWLYe6bjCoEh501YjTr6jyxXjrSDM5gZvdg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 07, 2026 at 12:51:05AM +0100, David Hildenbrand (Arm) wrote:
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

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  Documentation/filesystems/proc.rst |  1 +
>  fs/proc/task_mmu.c                 |  3 +++
>  include/linux/mm.h                 | 45 ++++++++++++++++++++++++--------------
>  include/linux/userfaultfd_k.h      |  7 ++++--
>  include/trace/events/mmflags.h     |  9 +++++++-
>  mm/Kconfig                         |  1 +
>  mm/khugepaged.c                    |  9 ++++----
>  mm/userfaultfd.c                   |  3 +++
>  tools/testing/vma/include/dup.h    | 20 ++++++++++++-----
>  9 files changed, 70 insertions(+), 28 deletions(-)

-- 
Sincerely yours,
Mike.

