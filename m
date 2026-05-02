Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A132FCD342C
	for <linux-mm@archiver.kernel.org>; Sat,  2 May 2026 09:40:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 167936B008C; Sat,  2 May 2026 05:40:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 118B86B0092; Sat,  2 May 2026 05:40:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0078C6B0093; Sat,  2 May 2026 05:40:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E5AF26B008C
	for <linux-mm@kvack.org>; Sat,  2 May 2026 05:40:20 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9D61C1C0E78
	for <linux-mm@kvack.org>; Sat,  2 May 2026 09:40:20 +0000 (UTC)
X-FDA: 84721984200.02.0D67130
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id C8D47140002
	for <linux-mm@kvack.org>; Sat,  2 May 2026 09:40:18 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=w6p4l2EO;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777714819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SWeHR6TXJDPcoGPqibXbLCDi1G+IQjTVYqkvcytFWlc=;
	b=BeD6QPy12v1oc5lbHCJ1qJGVF/pRvp1Y7XXWIC7wmvwkkx5Nw9kJY5ogBn1fxktF/JkPTA
	EqotosqlgvCluupbDyDMmi0rJyAjEn5UYZTvekkaco9qqonLWX5My1H4Z1bI0U7YQCDYxH
	A5oiYwud2hVg/IGHCZej2skwp1aV2Ug=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777714819; a=rsa-sha256;
	cv=none;
	b=xpALLTYaD/rYpGgI3pqrhuehFGj8ezY9ZVkzqvIID/saITyujv7UaBh0KqxSxwafc3t94H
	RWJe/6aISBQPHPPihlVv5mooAotLiCG559u3Aul7IrIJOC9NpLnQ4lehsPcBE3nHsG/iju
	74vU2z86mfc1WuEZws6gV6+a52zy71U=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=w6p4l2EO;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6B0A541577;
	Sat,  2 May 2026 09:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DE59C19425;
	Sat,  2 May 2026 09:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777714817;
	bh=7xfYirXqLDemJ0lxq6Q0jqEoUICU/Y40sa71HyYGu0M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=w6p4l2EOWVEGTKk5N8xYPA1OCp6ynnUGWz/czSAMj7WfaJTmTIZFaSrc3ODjouruq
	 otQLjxvDZ7aR8mU19J4bd8jm+u5nfAqnQGOW2B0sJ/b48Ddjn1x8CCcvKYEFwyQcAj
	 m0IMDTBtQqJfyJyiL4lF0TL+hJOP/Gv59YNmL7Uw=
Date: Sat, 2 May 2026 02:40:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Anindya Roy <anindyaandy1904@gmail.com>
Cc: rppt@kernel.org, david@kernel.org, ljs@kernel.org, security@kernel.org,
 linux-mm@kvack.org, lokeshgidra@google.com
Subject: Re: [SECURITY] mm/userfaultfd: cross-inode page cache injection via
 mfill_copy_folio_retry()
Message-Id: <20260502024012.30be89b2549bb18a1a1d0ddc@linux-foundation.org>
In-Reply-To: <CAMyZbw_ppC7F98+5huwmGjz03UGv8L8MoU9zL2_YYDU=fA3Qxw@mail.gmail.com>
References: <CAMyZbw_ppC7F98+5huwmGjz03UGv8L8MoU9zL2_YYDU=fA3Qxw@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C8D47140002
X-Rspam-User: 
X-Stat-Signature: 5oah761ao1jcufqkegyzmksitc953qk9
X-HE-Tag: 1777714818-375189
X-HE-Meta: U2FsdGVkX1/O9vIkt4jId8YiR/6e4nFn6Nv8i90G+6fXIFYqIgNAn3ivVflCNwJJan+dY+5sVjXrqbhN8UCjUG6roIwjh4fk37OFZxNv5h0Qxp9RFhZ/3Rvn9FdEHPYiowYjDNQujvAD/9tt8qeyyUNUBKIBH9PgHMojwvg20TvwnRtXQyBDds54jeaSP6n4KQjF6X3gfVXqFVV5aFHW6KVH2j/Ulc6HL1sywOpvXEZ69AHj0e636NW9iTUMbRlWWXNFG5GxrVIbSVAaXEfP9UREQPMu5kWW5f4V6treGxVKfC5rptp8OMn6t2Qy38PydbIpbFTHmIV/0yKzDE0Thb1G9ELDpY5VmcWuIK5uonElVqW6ln+00SDQ0ags4eOvmrhO7t506Ntmv9h4p3RKxN2lDF184AWV++7/KcHLN27ghCkJgnJR2xmhxq4ENiu5ebs8AhLZJO+dqClofSQDJdICue0Hx37DqZwvXv3w8v9rIaHzFy87M/9aoYLjiHNMXr9rEBA2iU6/I/dBoLQzgXpqpDezSgv3KA+4kY1kvDDjfnjcVCXXVEbnCWgeNzP4oin02CCj9ctZ7URsYyBApNbWalEtPx760b0yN7IMUF2l0mRLrYmGgcwcrAhEEPEKWcYeEGuc0pgKxsfljmy9Qfn4hLXsszIBE0iUkljub56EkeebxM5t/G8s+9YVEGXlD7RkuIe7ZtiUfNe7x+zO1d99rfQLItdoTIqUtUnNa9tUZ/O9uoAQ5zW/zkGXXqd/fofDsXZ7ctnIl2QfUtgp/0ulVFPQCgEgSyCOGw4B3RBW4nRoLL9qRKDA1nH9Lwva20a89Qma6icXzwJxiry4Qzv3iJ+gSCLIcEtsNKGLZHM+3vIcJwhkeiFxiAPEYKyptMQjJTh2Ute4wwj/V1YBAFDP9VRLGvZNOElBOuaYsFv+W4yCxA2DcL3ZjgB0793NqECCky+HoK9yCLkNyKV
 o8Lxtvs6
 boiuTw40IefEk/Dfp6CR1zYSh4UFxsvwqnjcf584IAjkc3mzY6BJa9g3ynZ5LbFuzo317EG0emS5hQwKC5Auv8IftyPCuu91RvU66ojvZpbSJSZjC/PVCfm2qUFjJkKCqoTnR1itqJekc6q6xHqGPCLPDGc0eTZPbK/lQG9A0vfGczIKFJXoI57G48rsrBvmKPojNHbQaVKCs1V7E0JyBzfRX3YlHCWCQPhqVIZ4G7LfeqToX3hKXnSPoGPvp2O3GEB98fgQh2W0LjILK6KrSxjhs6Qe/X8TkqEOhBybcrmJlyhv4LdVdlMg48cx8t99jZ0UG8VGnWu8hVupa+sishE4GFx2TFbDMbGw2xEYMiYGUy17YVSo2Y0EcN7s6rm2hfZbmsepd1TnglTsDCwfS9fHYna4ZS4DgSRZzY1QTm6TniWQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 2 May 2026 13:50:02 +0530 Anindya Roy <anindyaandy1904@gmail.com> wrote:

> Hello,
> 
> I would like to report a vulnerability in the Linux kernel userfaultfd
> implementation that allows cross-inode page cache injection due to VMA
> replacement during the UFFDIO_COPY retry path.
> 
> *Summary:*
> 
> A local unprivileged attacker can inject controlled data into the page
> cache of a different shmem/memfd/tmpfs inode than originally targeted.
> 
> This occurs because mfill_copy_folio_retry() drops all locks, allowing the
> destination VMA to be replaced, but does not verify that the underlying
> file (vm_file) remains the same when execution resumes.
> 
> As a result, a folio allocated for one inode can be inserted into another
> inode’s page cache.
> 
> *Affected component:*
> 
> File: mm/userfaultfd.c
> Function: mfill_copy_folio_retry()

Thanks.

> *Affected versions:*
> 
> Introduced by: f5f035a72423

Only in 7.1-rc1, fortunately.

May I ask how you found this?

Annoyingly, Sashiko found it:

: If the locks are dropped during the retry, can the anonymous VMA be
: replaced by a different type of VMA (such as hugetlb or shared shmem)
: at the same address?
: 
: mfill_get_vma() accepts these VMAs and returns 0.  When execution
: resumes in mfill_atomic_pte_copy(), it proceeds to
: mfill_atomic_install_pte() using the newly populated state->vma.
: 
: For a hugetlb VMA, mfill_establish_pmd() will allocate a standard 4KB
: PMD into a hugepage page table hierarchy.  For a shared shmem VMA,
: 
: folio_add_new_anon_rmap() will be called on a shared file-backed VMA. 
: Could this sequence cause page table corruption or kernel crashes?

We must have simply failed to look :(

It claims to have found other things:
	https://sashiko.dev/#/patchset/20260402041156.1377214-6-rppt@kernel.org

>
> ...
>

