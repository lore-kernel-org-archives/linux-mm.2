Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 938F5606A32C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 11:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R4Kfyci+
Received: by kanga.kvack.org (Postfix)
	id 7CD506B05FF; Thu, 19 Nov 2026 06:54:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A45F6B0601; Thu, 19 Nov 2026 06:54:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 693756B0624; Thu, 19 Nov 2026 06:54:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4E8F46B05FF
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 06:54:10 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C9741C0A51
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 11:54:09 +0000 (UTC)
X-FDA: 85451710218.26.3BAC77C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 09255A0004
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 11:54:07 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R4Kfyci+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795089248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BwOaWdPMF7ZjoGgqFFp4mcfQGWRKB52ZuTxmt4DQgm0=;
	b=lX+poiZwdhy7NQYTa9EkCSjyCcI5qKE+l7rFmJjDOZ/jHODbmcH0Y0mxJN8WCqwobQSVl7
	maYzrptgYk+1dmOuYeEjgt3ycpuyF82ZGvyXNrULyiSTaSmvxPnappv5MdMwRMLq/G4PIB
	2OIkLQC7K20LGdVlIoDS3N4em6eQpTk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R4Kfyci+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795089248;
	b=7q7udJC1nReEuodfTRIAu0q6uDLkBsyGO0ixmeN7LfUBiCqzWvidgZKeCOZwjPv96XEuZu
	lJPjYfFhPeriZ1Q47rXjQBFl2tfycojMVLcn5Wp/bl9qwFkY6rH+Mw5mI7ODbKM/3YWwgi
	Epm0WMbCKvS3a7KxoppMst0hi21pEWQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 35DFE455BB;
	Thu, 19 Nov 2026 11:54:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 289681F000C6;
	Thu, 19 Nov 2026 11:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795089247;
	bh=BwOaWdPMF7ZjoGgqFFp4mcfQGWRKB52ZuTxmt4DQgm0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=R4Kfyci+0b1qYDJmcMfCUwBHdFcqsHB/hMDqNsPgugKpR4VCJHxrdqatQa+FiN9Gk
	 zwwOsDVaGjvVb+ODPak7GCzycpOiXAhOQ3uLKurWMQa4e7s1V64cfbnuiJ/Ee37r3g
	 /z8vSpc1XhYwlscXhNTdHW27s/SOk45LXTky9vdaSLTnAHlW1p1NKiuRT3j+VGh2ip
	 phmXKTR7le6ZZiDO59wOlsM1AQLK9IWC/SQIIvXYqJWP9TVP2oqiOzPG/BRk52Gl5S
	 aXQRQ7GD3bmEkC4GWFPNHggCHnAEo0twkcFNSgVkspfldlx3NXTrG5JdCMi6zS0C9A
	 EFRxOFvP9SOPA==
Message-ID: <9cc2066a-3e0c-4171-8dab-47b80888bc55@kernel.org>
Date: Thu, 19 Nov 2026 12:53:59 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Docs/mm: fix stale split page table lock references
To: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett"
 <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>,
 "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
 Qi Zheng <qi.zheng@linux.dev>
References: <32FBD023F945BCCE+20261119074854.252609-1-zhaozhengzhuo@uniontech.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <32FBD023F945BCCE+20261119074854.252609-1-zhaozhengzhuo@uniontech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 09255A0004
X-Stat-Signature: drg1zjpuhof1a4qtpq64yyt83gd1ykyi
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1795089247-123132
X-HE-Meta: U2FsdGVkX19bVY6D8JjXnetH+5zgTWQfahLas3GhYvqiXZwbI/JuPghd7EWuOuI4m2CvgbVezLEA41YTRH0kgHTj6csKsr1V9jo9iOch4dogOvjAfyWxZI0HL8h+Z+Yrw8GXKdJy3ottDApa1Rx7DK8FjWb0A1WMRNeIqa/PZqlIx1kUrzwhOpGi0TlpnyvqVYFlD+fUuxK9b35ksC+LW1acgzPsq3MMnHsDiUvJP86IhCiNAeH/MA1c8sDliFkpJaA4Vg01zQ5fUF3qrwyN/C2/oInw78aCX/0DztJHjuc7Vjtm15Wc5mf+50fmV8ITXCvRcfoh8btqEkYv2O5LpPQugLPbWpgi6WMrRTTz8GbBugQICHL5HhEhltEl354Ezl/MB6IJlO0ftwgyQXTr2j6VGbfhrISpsV+5DQM7jSPlp7vkJ9pm09TbcylkYCa1N8+AZBOOlwNr42y77JaFrJGvTdL7XIrs7f/cQL2OytGYhelhXnhPiT7s/GNUywW0YtgWYkwin9uq6l92YhJR9vTl3qDVQRWKKTPbY+2qyZcZlhqFCl0KmIkeWiWM5y2/GkEMyq2gm0dsgBDa1wmVCMvkbnJHNpm5f1uKekG8Vg18w7xSGnk7oo0Z3O82uNbA4AocoGm6vqrb1l7H7MmD/W7tyXS0vnACAb8i5tU5tO74DZ1/VbcU4LKmkhOkdnq97tNnG3Fp8hjlg+fdf/yGe4TnJdhB2XYuHjzXPRSIOGCC0EZYcOEA14UjXe939CkZhmI90yxPLObb2ojEKLX8eQKgo/GEB1Vwsc2AqAnNbfqgTT391PdCmV6YbJ+iqgOZNvAadtSOorKPMwu8QIRCB2+r163lfr/b/GWVTcigUgrHQ1geXTeA6akc6DrG8DN50KCBYEWOhEcsOKWkbqzJTe2J8JWPmqgd8RRIxF39mvnq8BDNnzdpRuk7YomLmfrUk9cB6L5sf0UPQvTrTDn
 g6CjeYKB
 iOXD7qaQoYaGAl2O5nQVSaz9z6HlI2LnhwfbPAE76/3coq2+LzRF/o3z20rLiycpLKeRURdS3u5xXGnzIJKpPzumRnZm2msmmS9HlOhyG8a/ebBxYaclao8goHYMjApMKSbPB+z4WpjlpNBjzDrqUgNKqyT+wEqh8tYEwXxYHzIfjGznp1ANNcldum0PsxaHG0H6BzH8cO5vyUU8TAICrC1IogR1Bde8oXDTFEZxR2gS+wQWJKzkLwFbmWMxdSRwCNK0AuP78tLVQm2Mvr/a3XWJlCyDhzL+zFMypb0nrwdl+a4i7UHx3/1372kbyoLfgxkU95PwwFK0kowZ14JUItF48J3P5kBiR50SmJzffM0E3Kzqf10PuroJzop4SZGDOewgkhy6pefcN0YM+Vc5LmnQLbbyZFsIP8NM1KCXs4IRNplwve7IgoVk2IQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/19/26 08:48, zhaozhengzhuo wrote:
> The USE_SPLIT_PTE_PTLOCKS and USE_SPLIT_PMD_PTLOCKS macros were turned
> into Kconfig options, and CONFIG_SPLIT_PTLOCK_CPUS was replaced, but two
> Documentation/mm files still refer to the old names.
> 
> Update both references.
> 
> Fixes: 394290cba966 ("mm: turn USE_SPLIT_PTE_PTLOCKS / USE_SPLIT_PTE_PTLOCKS into Kconfig options")
> Signed-off-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
> ---
>  Documentation/mm/process_addrs.rst         | 2 +-
>  Documentation/mm/split_page_table_lock.rst | 8 +++++---
>  2 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/mm/process_addrs.rst b/Documentation/mm/process_addrs.rst
> index 04b649818cc1..0b6355e6d1d5 100644
> --- a/Documentation/mm/process_addrs.rst
> +++ b/Documentation/mm/process_addrs.rst
> @@ -659,7 +659,7 @@ acquired in :c:func:`!__p4d_alloc`, :c:func:`!__pud_alloc` and
>     references the :c:member:`!mm->page_table_lock`.
>  
>  Allocating a PTE will either use the :c:member:`!mm->page_table_lock` or, if
> -:c:macro:`!USE_SPLIT_PMD_PTLOCKS` is defined, a lock embedded in the PMD
> +:c:macro:`!CONFIG_SPLIT_PMD_PTLOCKS` is enabled, a lock embedded in the PMD
>  physical page metadata in the form of a :c:struct:`!struct ptdesc`, acquired by
>  :c:func:`!pmd_ptdesc` called from :c:func:`!pmd_lock` and ultimately
>  :c:func:`!__pte_alloc`.
> diff --git a/Documentation/mm/split_page_table_lock.rst b/Documentation/mm/split_page_table_lock.rst
> index cc3cd46abd1b..ce7908bebce9 100644
> --- a/Documentation/mm/split_page_table_lock.rst
> +++ b/Documentation/mm/split_page_table_lock.rst
> @@ -37,9 +37,11 @@ There are helpers to lock/unlock a table and other accessor functions:
>   - pmd_lockptr()
>  	returns pointer to PMD table lock;
>  
> -Split page table lock for PTE tables is enabled compile-time if
> -CONFIG_SPLIT_PTLOCK_CPUS (usually 4) is less or equal to NR_CPUS.
> -If split lock is disabled, all tables are guarded by mm->page_table_lock.
> +Split page table lock for PTE tables is enabled at compile time when
> +CONFIG_SPLIT_PTE_PTLOCKS is enabled.  This option requires CONFIG_MMU and
> +CONFIG_SMP, with CONFIG_NR_CPUS set to at least 4 (see mm/Kconfig for
> +architecture-specific restrictions).  If split lock is disabled, all
> +tables are guarded by mm->page_table_lock.

Instead of having information that becomes outdated, can we just refer to the
Kconfig file?


-- 
Cheers,

David

