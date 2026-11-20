Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 964AC606A320
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 09:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NpmMayWc
Received: by kanga.kvack.org (Postfix)
	id B117B6B00EF; Fri, 20 Nov 2026 04:15:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC27D6B05B0; Fri, 20 Nov 2026 04:15:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B17A6B05B1; Fri, 20 Nov 2026 04:15:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6E3F56B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:15:20 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6C550A8E07
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 09:15:19 +0000 (UTC)
X-FDA: 85454938758.09.7944F64
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 799578000B
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 09:15:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NpmMayWc;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795166117;
	b=YW7q9IeHvMMpYjm9UHMMGp/7UT/0BJSuPSnypiDexXmOyNGN4E67rp4l/tyWSQAi8yEtUm
	bhy/TCtRmi6vnp9Tr90MpigS6HSomo+t7+M3SJOVU2qinohPuOQKXzrUqyTQgs0tBd+FpW
	PWIiaRjmqYqHG5sGdCNwbTj7WLON4tY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795166117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8isrv9NEHLj4BTWzwGDaVfY4qyg8EBKZ+TwyUn9q/vQ=;
	b=FFBeXII6hXZf3jj4wlMhU3gGTnx5zYrRpNjMLMqAtIYAnDK/3rA/T/7x3VD90uR228f+t0
	/T1NpwRHHou7Dwz77e8mbUsylazNJhDGBDilVBnBFgODhKXFBH6OBYjkTZWiaECWyTPBSo
	c3Cl9caAsngkNvZNA/9xaYXiI/kxNtc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NpmMayWc;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 96A1640579;
	Fri, 20 Nov 2026 09:15:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C66DA1F000C6;
	Fri, 20 Nov 2026 09:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795166116;
	bh=8isrv9NEHLj4BTWzwGDaVfY4qyg8EBKZ+TwyUn9q/vQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NpmMayWc8/IjJcbM5BySPSTugosV0VKDCR7gjU4WeIWpwz6FsMPr6Ae740/ek3flz
	 6JGLui1RHfSe6lCBwk5Hp7YQGGgg9udDP5zNB1rl4rRGiSUeuZg6O5Rm+YcMpErtCF
	 gFE62dy2e9P+SNwFox4veORsCnV1irB+ZzPh24NSkd9bx11WeYmbgJkKH3Bh4inlkb
	 s1QGCKkIqVr7PI4GkUzqJd5ktaCQTp0Z3KAT+DiRi6aV7YlPKdneF5LUqtE1BTXWzg
	 s3SqTj/5D9VYTiPMLaliFzkIyPpT/cDzMVmbEFP4At4KYkPE/4TBh94g19AR6puoJr
	 5NPxg/7fk0C0w==
Message-ID: <ac761e74-b38a-4daf-b855-55d5790504e1@kernel.org>
Date: Fri, 20 Nov 2026 10:15:11 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] hugetlbfs: respect F_SEAL_GROW and FMODE_WRITE before
 growing i_size in mmap
To: Dominik Maier <dmnk@google.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, dmnk+artist@google.com
References: <20261119192209.2651562-1-dmnk@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261119192209.2651562-1-dmnk@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6ehp1hskyaoja65z3kgsea64je3zwrax
X-Rspam-User:
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 799578000B
X-HE-Tag: 1795166117-720131
X-HE-Meta: U2FsdGVkX1+jQnFCv5hVTJlA8db8XxSSui3/igEiO1zm17kfKc0mgn0SEG2Mu0KIyMD9+v4Tk8em2FWTnNo7oUV7vTKB/dOXfA8AXmNAsYls9HtzcYYubgPH69qzBB2LLckyhfumlYknPyw50BeFUXwEIYPIYcArrr9yWgUxzWJ3T7tG3g+FH2C4Ig4Uzee6ckITL8rxGVS7nd8/4VG4yhc5G0JahyEQuZ0QwyLo9MhgIixuFfn2GN1IZ+CyLlAN4LSRG+P9ogqS5RX9MKhpmGr4pEXXrp0Et8VJVJ8DHWkumjvJudFAIl+ivjQE1zH7gRN7RwZRMswJ+Dsty56eSpINrpxTnAVwDEMI3f+1lmXtRwalOgjdCFnZrWLaihldcoaJZS8V9bOUJ2XHxPqUMnwopnUw4rvlQ5b1dRdNP6lX9Bs7xUkyeLhX1pzb1O4zjGJFkBY215WnWu9V3d+4YrIn2plEcuXu+kDFgcD5vfGMYx+KEEl6anUrlM0kTmDgNihfNAE3m/IT0ICV1W8u9S+/aJTRlfX+QEz777J68CC5Cg7y/UOo4SZCOhH/ypvLFvSFSWnoi35NVRrOrAlqMyW0uRy5YKYk/7+m4YWv3bCQPndNo+vRJMEewNGITQRTReS76CffR0QDqengV4AMIRQB4MCdnfB4rillFR4iYZ1z0Pj5r9h1OUBA5M07HGFOIeFzH7ULfri/43xEkO5tw28Qi+0dLOr0aB1bqoiRfmmuNM6P+Dqi0cPDYLs7PictTmij96hstl7W3ZEzLRgkrXWboRW3SN3TuxLny7buA2uWzoOa6nD3Kgt9/uhbcN8XlI+vzJDSVJWDFpgnmR/p00GwvsmOmRs/TOTclco9j5tUWjLJIPFmkQFhZsMovFHyRU17JFh27JaWqape45PPEyDpTCqY6D9/pTK0TQLrMdZ1dCm7IWpNE6zcCwo0OW/MuVlOSq8xq1F6BLVuc7B
 rml9T8v+
 oed93tZ6hhI3elij5sOiknLs0vKUNjfiQG8qQ5W8VMLbahbRiXccGb5Sq+883tbDqJfRIk+Ow1B7UEso/QWNJ5DL3KQkLXqeNrhcjbDw7BEoDdWcrF9tcs3vW3YsR4k/EIzPx99tsOQoQEpEhonqq0uXz3XFLg2LEaV+iR7Uyu6G31UIGypsI5bZtfulrsisS7H3H1t58HAezpDxgNwcjtCLvv7vwN9jaKwddPKCP4IUIYBM+rr3PJCBEIBaFJT4HKtkToKeuCfIQvsseEw0VuYmZ37XHmfM697AuCEoq9p1oz0yrrMfFnAUScLHj1F6/NdHukRZjYQkPdiXvRHDSFxt337jXp/3FvzLMAQqzIYJjwb0A3seqdrLMv38mbpiiS6pJZYp5rag9jZY6mdIPGFVgkZ+BC2tMTMT/75aAZpqAekTBqywyt2Smx8qdidgas+zRXuwiORK+kozPDf6k0erC9j7EAhgyw98jvHZMAeVp9CmWvVQw0N/OZrqW/UxCcywYK8IeW+h1UbTYjR+Pgdqmq3RpOXgYnXnaL/uSFZCUezH7vq0CAdP4SbmCb/jgU3B/YgCtfnYGn5eNBJfrGIVr62zA5IhY8/0DChQOtIFgE59Be8H8jMh8h2fuuqKHezzDl91HAUIbbX7sMk2NtocF+nvoKkWgmlQy3dYmSMZ2UnSr981oD5xx8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/19/26 20:22, Dominik Maier wrote:
> hugetlbfs_file_mmap() expands inode->i_size whenever VMA_WRITE_BIT is set
> and len > inode->i_size, without checking whether a shared mapping
> violates F_SEAL_GROW or inode_newsize_ok(), or whether a private mapping
> holds write access to the underlying file and has no active write/growth
> seals.
> 
> Because do_mmap() and memfd_check_seals_mmap() allow PROT_WRITE with
> MAP_PRIVATE | MAP_NORESERVE on O_RDONLY descriptors and sealed
> MFD_HUGETLB memfds, an untrusted IPC recipient holding a read-only or
> F_SEAL_GROW-sealed hugetlb descriptor can inflate the shared
> inode->i_size to multi-terabyte values even when vm.nr_hugepages is 0,
> causing trusted peers relying on F_SEAL_GROW to hit SIGBUS past the
> allocated pages. Similarly, MAP_SHARED | PROT_WRITE beyond i_size on an
> F_SEAL_GROW memfd (without F_SEAL_WRITE) bypasses the growth seal.
> 
> For MAP_SHARED | PROT_WRITE mappings with len > inode->i_size, reject
> F_SEAL_GROW with -EPERM and enforce inode_newsize_ok() before reserving
> huge pages. For MAP_PRIVATE | PROT_WRITE mappings, keep allowing the
> private VMA itself while only expanding inode->i_size when FMODE_WRITE
> is set, no growth/write seals are active, and inode_newsize_ok()
> succeeds.
> 
> This issue was discovered with an AI-assisted code review tool (ARTIST)
> and reproduced in QEMU/KVM on an unmodified v7.4-rc3 kernel without
> kernel modifications or error injection; a standalone reproducer is
> available upon maintainers' request. The fix was verified against the
> reproducer in QEMU/KVM, compile-tested with -Werror, and checked with
> checkpatch.pl --strict.
> 
> Fixes: ff62a3421044 ("hugetlb: implement memfd sealing")
> Fixes: 045c7a3f53d9 ("hugetlbfs: fix offset overflow in hugetlbfs mmap")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dominik Maier <dmnk@google.com>

Thanks for your report.

Your patch does various things, and I had AI fixes for all of these issues
already. I accepted some, I rejected some.

Take a look at:

https://lore.kernel.org/all/20261028-fixes_hugetlb-v1-11-a0a033db180f@kernel.org/

That was already merged, and, in particular, my description in it.


"We currently also allow CoW mappings to grow a file. Disallowing this,
maybe even only for read-only file descriptors, could break existing
userspace, so we have to be more careful. QEMU's file backend is an
example user that might rely on such things, and would suddenly start
getting SIGBUS when faulting in memory outside EOF.

So be careful and focus on F_SEAL_GROW for now."


And in my private notes I have to a bug fix called "hugetlbfs: grow a file in
mmap() only if open for write"

"There is a real chance to break user-space: for example, supply an empty
hugetlb file to QEMU, which might open it read-only and then SIGBUS on access.
It would only warn that fallocate() fails and continue. This is long-standing
behavior. Read-only users can already fill hugetlb files holes through
read-faults ..."

So I don't think there is anything left to fix here that would be worth changing
long-standing behavior and possibly breaking user space.


-- 
Cheers,

David

