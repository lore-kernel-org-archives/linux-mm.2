Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78ABA606A320
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 09:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aCdYdQ9Z
Received: by kanga.kvack.org (Postfix)
	id 9E5EB6B05B3; Fri, 20 Nov 2026 04:21:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96F976B05B4; Fri, 20 Nov 2026 04:21:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 835F06B05B5; Fri, 20 Nov 2026 04:21:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4DD746B05B3
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:21:42 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D049C140DDB
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 09:21:41 +0000 (UTC)
X-FDA: 85454954802.26.7718041
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id DE882140002
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 09:21:39 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aCdYdQ9Z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795166500;
	b=VeUOQ/NV80sO3Is/QOuZ5CgQVaJE07aPCBmmIK6jxVY+LdjBtOsdbxB+7G7Mxf7QgmUBCE
	GnZ9aUQJmbk5dX3z23qKbTEjFC6cpYE4YzZXqcIwESYf+t67DMcPdjXwtFHD86Z95c1yhy
	051rjmL+wj5o36cM07bwz5FvDXNd4xg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795166500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dQwI/cBl5Tyqw1nn+8DT6GmQnd5lxLkMDcQzMppTqGg=;
	b=v3bYLyR8V5EYmHk1J73KC3PZ1dV7yXZjovu8i2uRQxP1aDe2fhOVetPf4OnNv5MzgoP+Gh
	YVrGRs2jRk2MWbDF/dlfII8BZbHktBbtRR59a5d892pJ6dYzHJnKMeX+Lf7jIOU1o3szJA
	6bE+yWmelVB4YWVmtrdJjTfhm46ZUxc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aCdYdQ9Z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5E9BA61EFB;
	Fri, 20 Nov 2026 09:21:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74C361F000C6;
	Fri, 20 Nov 2026 09:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795166499;
	bh=dQwI/cBl5Tyqw1nn+8DT6GmQnd5lxLkMDcQzMppTqGg=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=aCdYdQ9Z/pL8cGTS+34n3uCSdMI32Cb2Vez8AepJTJ71xMM2abry8mUjQEzPmufg8
	 uiRQVDAHOVeFK5G1DVJkeHGuAcKt9vJ3ruZQTwA6ZPsELz9Mx54B7yYTPJb1ux/6uZ
	 mxZbgpaJrBnGmD0DpABIshkTHL8mVc1YlAjUyX1kLxOk2to1KCKv88d53BfUsGK9Xx
	 8iTy3rU4lBM6e2EF8twBEonP8XkxiuJb8SOP7aPHAB6kEgZHSXP51Z/519+YZiGLEQ
	 tKUHM0Of/8exs0L+eREHgpyGA+mlzII7nxRcfISykbSe++jQn0Ak64q7nyiM+SDu0p
	 BktTyw+6p+Y+g==
Message-ID: <b644bcc7-0c3b-4001-89e7-3e558fbb5d76@kernel.org>
Date: Fri, 20 Nov 2026 10:21:34 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] hugetlbfs: respect F_SEAL_GROW and FMODE_WRITE before
 growing i_size in mmap
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Dominik Maier <dmnk@google.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, dmnk+artist@google.com
References: <20261119192209.2651562-1-dmnk@google.com>
 <ac761e74-b38a-4daf-b855-55d5790504e1@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ac761e74-b38a-4daf-b855-55d5790504e1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Stat-Signature: ptam7jbkhmqeiypnca8zt8qo4pwgjohr
X-Rspamd-Queue-Id: DE882140002
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795166499-708834
X-HE-Meta: U2FsdGVkX18WJ6f5Zo4CYEWxdBpoQEKXPlpmPVCqgl5cvJd7V2snvqnDrHGmU0vnxoeizGRVoZOX/DTy9jmjlK1Xophmk47L2ne9lsymQ31MeH6nPnRXioRH3unN9S0wcif84NcWM8vbv33yCc9NqaZ4cH3yBK8gxrXJ0AdhHvkzcFNK0hpNcVFbrghpif8iO57vLmfq3w8eSRBZSi2El0/h54daKoOb4mB+brcY8H6NLPZaO8QTT/Eso6F+Ez9m5/hXvrwqaSY0BccTk3wlR++dHCft79acW/AlE2dV4yg667jEJBS4t6qxAfzTDHm5pxO4CNfT1UP9+lwVZgWPpEKT0a3RFHRPKKdq5ga3MCQTHOHxZ0Se/zc3w0d43jueEI3KNrZknAOoufvt4EDhYOvj56jOQHIMbooFBp+pChgkzBiSRq0Y2wWw+kbfgDxTzjaZmNhyxXV6yP4IAhb2c5rH9T6KgrlleUAMygYsq6Ehrhm4UPP7KdC/wwi+i0zJcEDJjl6nONhulR+GumwnE8Jak1nQLIiEQFuT+n1kD4GZhYFAUa54kCOrsEfnQOCvA7ukK1gnvn2nYLwbg1bYkKlAKq7cJ5qAQkOhAFT9fKCW3L01alI4Uano2jGd8bG4stzHahLXCKOhCKxu+T3PgLn7xlk1IbpwWua2B9J3mSgbfKFTmAM/6H45z4zmwTU9ZJkIi+9KB3Lns76QoPqTspHvwlu/qa/AkPXXwfZHmgRno64bOHC4Rmuq7Wb+zS6TMxfOL9N7f9ysWApvvinLULC/RgtBzdp0h+aRNnMsWBIgQwSEMgGH1P2/TSF78W/TqoLnsonH0Ukb2pPzbEbgBAMtgLiRUHfAkoKWBUquLmV8PJ6+/AnmOQCIAw5QmsBsZMduCrQ8EMHUEBj8ze8POddFN+rlvGQ70E2zqXo/R5Ujp1hNr+OeiXg0MhzF/UsnxfpMpIxKR3sYtyRJRjI
 iswm5Lno
 7sLgt+4DuyL3e0c+GSKGX6FfS4507w0quTBn9ivu9bMo01wXCOPUEGMXdSJrpARJcNj0az9VNenVlVr8DulW+yOAnb/Fv3NRAyM8UTtAUmVrzwktUbKCFqHzLps7oibeSswjJn8EDIIjb6V762qeICiUMPm2yNAOKRF6M1esH8FWe11PTEQTLwl75djoOqkXKXEtnI02stsNhUSzUeBxKzgMGYl+vMAMUozZCRRnmtQ54MqmJhjYne+hceU6ZbfM0vJg3bOip/ppt+fZqmxgGe/XOuFCFX0RZyZjN7jZwgfIV+LYruDxf3HN6sohC60Hg0yV2ZT0RDUH2xPRI3E9HJHYdtMzas309snlucBHJfW3D2XZkRZMzY6rlv34p9xIUTdif7r+cy4yG7Y6BcQLSmj2QKnkP2RhMvU5v6va2lQ5lRlAgVOJGR0BlK3St+eshrKScX6JuspQm3SfE00JkII1rw1vFu+8fx7euGGvQ93uOForm7Fu3ZSUbYbdSSe9rTblBb44/rznhUH9BL+YF+QMqD51jkV4zPyqpAtD2Xf6/WpNpnKAwHX0Ib5NXxvdEp7AC358l/VUCx8idURYiTCXYO1niIIZOultsP9982WK1VWBIqweVcGON7ussmPjYrr8ohjs/1mil8Iw3DEmaNJmMIOTgFM2pEDC/odl89IHVq5XYdy/0lKEESA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/20/26 10:15, David Hildenbrand (Arm) wrote:
> On 11/19/26 20:22, Dominik Maier wrote:
>> hugetlbfs_file_mmap() expands inode->i_size whenever VMA_WRITE_BIT is set
>> and len > inode->i_size, without checking whether a shared mapping
>> violates F_SEAL_GROW or inode_newsize_ok(), or whether a private mapping
>> holds write access to the underlying file and has no active write/growth
>> seals.
>>
>> Because do_mmap() and memfd_check_seals_mmap() allow PROT_WRITE with
>> MAP_PRIVATE | MAP_NORESERVE on O_RDONLY descriptors and sealed
>> MFD_HUGETLB memfds, an untrusted IPC recipient holding a read-only or
>> F_SEAL_GROW-sealed hugetlb descriptor can inflate the shared
>> inode->i_size to multi-terabyte values even when vm.nr_hugepages is 0,
>> causing trusted peers relying on F_SEAL_GROW to hit SIGBUS past the
>> allocated pages. Similarly, MAP_SHARED | PROT_WRITE beyond i_size on an
>> F_SEAL_GROW memfd (without F_SEAL_WRITE) bypasses the growth seal.
>>
>> For MAP_SHARED | PROT_WRITE mappings with len > inode->i_size, reject
>> F_SEAL_GROW with -EPERM and enforce inode_newsize_ok() before reserving
>> huge pages. For MAP_PRIVATE | PROT_WRITE mappings, keep allowing the
>> private VMA itself while only expanding inode->i_size when FMODE_WRITE
>> is set, no growth/write seals are active, and inode_newsize_ok()
>> succeeds.
>>
>> This issue was discovered with an AI-assisted code review tool (ARTIST)
>> and reproduced in QEMU/KVM on an unmodified v7.4-rc3 kernel without
>> kernel modifications or error injection; a standalone reproducer is
>> available upon maintainers' request. The fix was verified against the
>> reproducer in QEMU/KVM, compile-tested with -Werror, and checked with
>> checkpatch.pl --strict.
>>
>> Fixes: ff62a3421044 ("hugetlb: implement memfd sealing")
>> Fixes: 045c7a3f53d9 ("hugetlbfs: fix offset overflow in hugetlbfs mmap")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Dominik Maier <dmnk@google.com>
> 
> Thanks for your report.
> 
> Your patch does various things, and I had AI fixes for all of these issues
> already. I accepted some, I rejected some.
> 
> Take a look at:
> 
> https://lore.kernel.org/all/20261028-fixes_hugetlb-v1-11-a0a033db180f@kernel.org/
> 
> That was already merged, and, in particular, my description in it.
> 
> 
> "We currently also allow CoW mappings to grow a file. Disallowing this,
> maybe even only for read-only file descriptors, could break existing
> userspace, so we have to be more careful. QEMU's file backend is an
> example user that might rely on such things, and would suddenly start
> getting SIGBUS when faulting in memory outside EOF.
> 
> So be careful and focus on F_SEAL_GROW for now."
> 
> 
> And in my private notes I have to a bug fix called "hugetlbfs: grow a file in
> mmap() only if open for write"
> 
> "There is a real chance to break user-space: for example, supply an empty
> hugetlb file to QEMU, which might open it read-only and then SIGBUS on access.
> It would only warn that fallocate() fails and continue. This is long-standing
> behavior. Read-only users can already fill hugetlb files holes through
> read-faults ..."
> 
> So I don't think there is anything left to fix here that would be worth changing
> long-standing behavior and possibly breaking user space.

Thinking again, I assume we could also let F_SEAL_GROW stop reserving beyond
EOF. But everything else just has the chance to break user-space.

-- 
Cheers,

David

