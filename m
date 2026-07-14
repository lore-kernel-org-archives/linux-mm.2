Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 030A7C4450A
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 19:11:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF5A76B00E1; Tue, 14 Jul 2026 15:11:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA6116B00E2; Tue, 14 Jul 2026 15:11:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABBFF6B00E4; Tue, 14 Jul 2026 15:11:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7DC6A6B00E1
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:11:07 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 044DE140453
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 19:11:06 +0000 (UTC)
X-FDA: 84988324974.05.9E8AAFC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2800E20005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 19:11:05 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1ubEDfd2;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784056265;
	b=QjXx3J0eFsflX7U8SNaP3HYH+rhV5q/MunfkEI8QfeaZInYkiX8rCPEua0INF7RGtH7CAI
	ceQhVWQ71V7/k+m7W2pu/a1r5ZkJri0C60Oat9ybYnacpTP1MiKl89yfK3y4V/Tm6rlomg
	srzncXzCNcDQ0riCuRbbnN9Ejfrf6DI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1ubEDfd2;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784056265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w6alW6kAgplsNU9MfVHgcE3PqiC79iFkgMzFjduJ5sQ=;
	b=Dw8x6fL+0ClZQWUQ0zCILicVjxnKJLlUToZtsaKitzqsrrd7F3KHNPZWm6AQYL/Wkqfqj/
	DCoWreQJc8dWkifeyshJ9NtF76NRIlS/Vt2g7+8XMNiuISrYTeIHZvmJh40saZmLbAP+q7
	KeLbxbahkik7k5LGoqiqa4u6+aa5CPg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0312F60103;
	Tue, 14 Jul 2026 19:11:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C740A1F000E9;
	Tue, 14 Jul 2026 19:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784056263;
	bh=w6alW6kAgplsNU9MfVHgcE3PqiC79iFkgMzFjduJ5sQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=1ubEDfd2R3TAeYbwE0NtyG9rf0Dt9m11go+ZNpZ99iG+RnxImznq3aOOsz5c9eTc6
	 krHoU0nLrt5epm3hWxpU2WqYggIoI9WP/O47lr/puJ1MOxkLyocPEqwOLTWCTbskuH
	 IUe7SZrZnxZGODba8idgTvTKApYNyA9BPbBrjoeU=
Date: Tue, 14 Jul 2026 12:11:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt
 <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Uladzislau
 Rezki <urezki@gmail.com>, Toshi Kani <toshi.kani@hpe.com>, Dave Hansen
 <dave.hansen@linux.intel.com>, Andy Lutomirski <luto@kernel.org>, Peter
 Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, Ingo
 Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>, Catalin
 Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Dev Jain
 <dev.jain@arm.com>, Ryan Roberts <ryan.roberts@arm.com>, David Carlier
 <devnexen@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 stable@vger.kernel.org,
 syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
Subject: Re: [PATCH mm-hotfixes v3 0/4] mm: fix UAF caused by race between
 ptdump and vmap pgtable freeing
Message-Id: <20260714121102.9cb28d080556c94d45a6bc3e@linux-foundation.org>
In-Reply-To: <20260714-series-vmap-race-fix-v3-0-b812eccfa0f9@kernel.org>
References: <20260714-series-vmap-race-fix-v3-0-b812eccfa0f9@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2800E20005
X-Stat-Signature: k1ddc1grq31jzsmxx6hse4unfshhu4j7
X-HE-Tag: 1784056265-825047
X-HE-Meta: U2FsdGVkX1+ZngPFy4XBM4KJRZOI5QgL5NQuaUcvCYQLCk7p0fS9WE+xPA4fIhReGtblE9ry+VDi/9Jo7A1mDuZhYCW+CXb+IhE5Te5eDERYOIKda27q8ViO/vDLxyMPCkWbdjbpXvh+lgzPzF/8SPYhW6dH9D3PNbQ6+QT0bd2eP33f01AGOXxvTfR/VX6bfshSj8qVLTutfXZjWbUjh52V90VnPB506umxVDqP0Txampr34IK7qAHp7Q+Kw9/BPe0dB5JzsO/7tyIRUxtbcxP2u98z6SiPwY0uIWMA2nOskSLYS1AJE+VHVm7HnIDd71J7/Hux/HXS6L8kdIOYA8bwwhqjn9QZSmko/wHzsfCSrfaFWf7ihs22BpgDXdcWRWcyDvNwfKKkosj2N1UkjZ/yr0vf40qv0hPV34+gdPKPQSvvd3XYwvMt0eYShK4MYrPRanObec6wTCsKgWyQLfS4puOvLki04PF8mK07ZOSHGafQ0lTsYnwQaH2wYbo1+vj6jqu4n59BJeIFX3jrlmasgfeEI9KoqwTXo31SCaiFFg9B2Pw6U2cqEH3BJrvT8/kwRJAtO9y4jqhK0SgSWClBoH+X5EzSYf8nVYi2mBJD/Ihotk6vgM6WrWwI/yBx2PXJJM5SskTC0uLt4NGtWVygv4Xfy4drbvAdJY8huFBZx1vNtWnz8mUNHajd3G7dMMyetraJwSRKZwb1gakJheMpF620EXtUcxOTCHjAbbQWt2P44EbCS1u0m+AXppopCSUKRK3kkOmc/p5NrfARF8cGhlAMVr3CEEwuBZjxd6qwimZVVS7uR5SrO7wHCYelVyo8BIGNwWSyRruhRanQ7P4wwPw2VYufMyrk4MVjI4kepYigSvLcPtIdW9DIIpjG+3p3UcjvhnVS1y6e2FWx1FW/9RdgM8gUMsFNtLjRckSpIiIV5Hf52mu3xc4PpuusRVra04l3/XUSvyrmndk
 YL9VIq9l
 9usgQ/2iVIKZTWv8GVO2VTKorKN9JCAhcuzLR8Py9nggClzBkIz6yaFqa87OXduN38KmqFfKwENKTKFQ8JkKta3BzEE17MyRjSH+ibCiOqv67nig8ZvoLnx1yB4WWQZ3+I1akNTa492nWtMSN6+6Qcx+9IpCfnSeIV2KXpYXhiYDdYppMPOiMHq/mwiDbXI/1JmWJ6+9xV5qYSX3GUHapgS73YM9cNUMjhx94nbrtwp2OUJ0JKi9rnWe3w82NYEcxcC0qrnmw5END5cMGb09Q+o7wA+pZvacaILUbx/Vo+oNG0SbIfwq6/eiLtJN2v5d2kVNAafBvndrN0WVei1lilG7l1PXZhtkyEwUiJwHzfL1onxAyJQG4e0adgMXguFK3TGsfJfR+TQnXJvlj6d0mvcmzBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Jul 2026 18:24:22 +0100 Lorenzo Stoakes <ljs@kernel.org> wrote:

> Kernel page table walkers fall into two broad categories - those ranges
> where no exclusion is required via walk_kernel_page_table_range_lockless()
> and those where exclusion is required via walk_kernel_page_table_range()
> or walk_page_range_debug().
> 
> ...
>
> This series works around this by #ifndef CONFIG_ARM64'ing the mmap read
> lock in vmap logic, then partially reverting commit fa93b45fd397 ("arm64:
> Enable vmalloc-huge with ptdump"), keeping the enablement of huge vmap
> support, and removing the ifdeffery with the partial revert patch.

Thanks, I've updated mm-hotfixes-unstable.

> v3:
> * Rebased on latest master of Linus's tree.
> * Accumulated tags, thanks everybody!
> * Reworded commit messages as per Kiryl and Boris.

I've confirmed that v3 introduced no code alterations.

