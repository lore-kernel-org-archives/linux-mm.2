Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2998F606A32D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 09:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f0wHaTbe
Received: by kanga.kvack.org (Postfix)
	id 3812C6B0628; Fri, 13 Nov 2026 04:54:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 358836B062B; Fri, 13 Nov 2026 04:54:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26F6A6B062F; Fri, 13 Nov 2026 04:54:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 026C36B0628
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 04:54:07 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8115C160500
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 09:54:07 +0000 (UTC)
X-FDA: 85429634934.21.008636C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id C948040004
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 09:54:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f0wHaTbe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794563645;
	b=BFnKqQrmLAPJDWevuRZtj5LPsDMsWzcWFJWeHyvhu/ZdtFqABB7so1yjM744jaIgmm4u5x
	6iWrBHbd3dlkrqJcfA/7oyl8PAt29R0vl5L7SzmbnF6lnR3CKEq9gNSAjwzDKc0O0QLiwM
	5w6WWrZtviMXbwZSAAzxE98e1f/Y+zE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794563645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P8EQ9FC4cZYCHq8yHZtNznd9EQgrZ12HAlgtAWeleac=;
	b=prvZfb5XSIMRx9CG/Rucc7hoXE8ReHluPMveJaTysquePI96DozutyXm3RnqvmC4DHEo50
	Ocjn24XBAukn8DWVHMu6fUH2R9+M7aunxNvoOmX5bPP51dV82SW/PGcSgB/cSfU8ZA7p1v
	z/3r5xiSMXK9XBdbBEeTwYc/CZ2tsww=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f0wHaTbe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4BABE4056A;
	Fri, 13 Nov 2026 09:54:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E7341F000C5;
	Fri, 13 Nov 2026 09:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794563644;
	bh=P8EQ9FC4cZYCHq8yHZtNznd9EQgrZ12HAlgtAWeleac=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=f0wHaTbedH8MKd3xbBvnJTz6C3TbsBFAY862o2AQcfBrjdYCZA3KKd4lOYhc4HnOS
	 izioEzZzwmUKgaqN+BTovULVcLTwuMKzmhsM3ubNMZE53yu9d5l1ZvOzQAg97twAMR
	 M1C+9ppPdDuBhepWvTHZ2XnpoSlD6S+Ou1ltqktZfoiXbzqIpWy846z0TXOfHwz2Kh
	 rH0ywqW5+yfwOMr3/lL6BhxTLLZ081RzXBPdRO5jt2OwfRB8CaXvj4nv7up1OW30Ly
	 awPHrEqKhyxkGZvqah8xlnrPQemguFQVjnqn6N5tpOi0JMBf352YsDajD5YdT1recb
	 bBr9/SbnYAwkw==
From: David Hildenbrand <david@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Qiliang Yuan <qiliang.yuan@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org
In-Reply-To: <20261112-bug-mm-shmem-undo-batch-v3-1-212db8c24058@linux.dev>
References: <20261112-bug-mm-shmem-undo-batch-v3-1-212db8c24058@linux.dev>
Subject: Re: [PATCH v3] mm/shmem: remove truncated folios from the page
 cache in batches
Message-Id: <179456363894.3289.16333011678633371676.b4-ty@b4>
Date: Fri, 13 Nov 2026 10:53:58 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Rspamd-Queue-Id: C948040004
X-Rspamd-Server: rspam12
X-Stat-Signature: h9oineeu4ayop4aagqt8omnqqw87tow6
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794563645-317560
X-HE-Meta: U2FsdGVkX184QMl2wwPxxkDIxVRH7AeATF+yfqYJDqXJ8vuND7ZCI0s9yusLqlTpsACiIFFp3UHACRldmriHsISNFDUjOYMsV8CoyzjP0ObL7ehumjCjALQsokkANL7BkxwTpIKj40V7ZrZ5tV8kau0zUSK0IgWf0Rq7R8V1ifvUC29UQJ6Kq6LCZrJBl3bbCl+mSiFWqArZAjlYeRyw6e5aMpoDphn3WnTcgWLnYI6OnSzD6wh2K6mQy3TQxHkyMH+ch9RjtqUu0jrZJNJz1hnJobjfNF3WrADNAn/1cvq50PeRuehnkzx3eXF1pZQwbWYDikM+Tqt2zGSeHhS+vVPN8//Bt/9DNPAbKOZWv8MdBb/nj/48enYqeW74gPZXBhNpGGFCP5is5CT9h3OfzfEnMTxHq3T+/wdZLEcnYfmstXkjkpzV4BxWPXWrVBQ8T58+G7H0oNhmxP5OxOTiT2y1TIj73mAgDDaV7+vnhzCfgPwKq2++myYLhDN8Xxt3gWjDQ7gT98QK6OMLpc3VunDaStPe/btJommiZs8t4iN6X/GMR7693e797Ii2JVBkbhIXjQaSDp1JR5C4kqBNX88nOcdZxyaDg3mbPdqOKyYGxoLM14AHN8ez4RcFDAEuIo/nVRyuQa4S5scB7e/BntUBJeC9OpDw39J42DLVCaNfg0Yap0nXvHzxNvUuz0p+Azai8/ZOb79XwwQTSdWHI6aWn/Wy4XIiutuvv5zIwzkMnNqRDeY3xHg7spDkF1XlSadUWPUd/CGJh1tvRTPX3kcHB8oP7BDIZBfQvhhJueLGp1tqzyTZqLeO6aOT6iB2wucbjTs7PUScM4VkC6EOEtQis4AuL6C0tACPkaFEZCqGIV+Mrb+QRRbzniUp77/UKvxj7fZ0kDBQ+n+CVhhjKORY7wptYya9OP+2BJqphOgjYUojuAgxEnD7HftQIUrqIpNq42MqL4dC3x2mrW0
 kVQzx3UM
 Mnud6YpZLk3MQL3El2VfuHcBYGGV/hNNn3wup1c2xCRopRlhyAIhouuGPCOEM2XSnejJKeBkuRER+IMt27kfStxSHm4THFTMBFTxFCpjwSQeEP5aNKPAusNnVC/3r7qRvXzPI6emCgQted87Vxlr9vC95hWPiQilFIRb+ohtg/7lt1WGvTjasVPw96lulL70qEPECW2qeUZpXMsxskNAA8n6TRuuyAaG7WyQMltzCASFUAbTIg6Sb7jZnsUqFpJrIZHt0QT2PwwJnfY4JO54FqGxDs5b5lM2+NeiUkhjVXxOLvurgRXQium3IWBqxAa+6PM+MIzB+1W25XiaC/TQmJ8hGVLG9SnXt/7dOSWhkiby3kXay0ttuzjmsKIUdLrU/Uaf8Xj+T5p6WOOk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 12 Nov 2026 04:05:12 -0500, Qiliang Yuan wrote:
> truncate_inode_pages_range() takes the folios it finds out of the page
> cache with delete_from_page_cache_batch(), which takes the inode's
> i_lock and the i_pages lock once for each batch of up to
> FOLIO_BATCH_SIZE folios.
> 
> shmem_undo_range() calls truncate_inode_folio() on each folio instead,
> so filemap_remove_folio() takes and drops both locks once per folio.
> Truncating, punching or freeing a tmpfs file or memfd made of small
> folios, such as a large /dev/shm segment, pays for that on every page.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: shmem-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/1] mm/shmem: remove truncated folios from the page cache in batches
      https://git.kernel.org/mm/core/c/2e0dafbf

-- 
Cheers,

David


