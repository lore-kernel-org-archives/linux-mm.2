Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16903CD13DA
	for <linux-mm@archiver.kernel.org>; Sat,  2 May 2026 19:27:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 258646B0005; Sat,  2 May 2026 15:27:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E7E06B008A; Sat,  2 May 2026 15:27:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F8B26B008C; Sat,  2 May 2026 15:27:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EBC956B0005
	for <linux-mm@kvack.org>; Sat,  2 May 2026 15:26:59 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 60B671A052B
	for <linux-mm@kvack.org>; Sat,  2 May 2026 19:26:59 +0000 (UTC)
X-FDA: 84723462558.10.FE234A2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8706EA0002
	for <linux-mm@kvack.org>; Sat,  2 May 2026 19:26:57 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r+pCmAko;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777750017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Q0vPEUsxv5wgefwDMW7oIJcxABRb8MFRFQ2dv2Q/CQ=;
	b=LhRzbdky1M2PiOrk5ODhxON7hqpkIM/fugFan/gRrqUTtVYhWH3OChXwUYNbEOVlFN+/Ej
	SLAAAw9pogRAsHmcj5EujAgdl32OGTUXgJj1cnBhHLQSJnHklky9VPzr+eewUY8jNPR5qy
	dzDDDUjwyq5wFgk7a1jDJrBb3oufXsc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777750017; a=rsa-sha256;
	cv=none;
	b=ndTQD81JmBUYOu8WILFaNUTnxNuP+Pc8L+t2TKLd7JcQeFBe4nPxZWhCh1mV8UYCmcbbx2
	0LajF21bT+MoOfcQYyIC4YGwcBykWfJ7hGK96lgbY0pB0Q/vDWgnOp8Hjdiiytp5mPDCYo
	uGcqJPdlUUIDeGTBpHozDixgttYb+0Y=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r+pCmAko;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3B999441CD;
	Sat,  2 May 2026 19:26:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC92C19425;
	Sat,  2 May 2026 19:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777750016;
	bh=ldgwJtCTkzHPPRfKWSOAhRKGHoYUFSJVGmPSRPQnJHM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r+pCmAkoBRGjWcNoVaHweAd9qL2BKY551LYCzPALDtT85wbj4VBOyw2WXd/kqjiPj
	 +Ip2tpYWPwmaDO3cfwZj2YVIToM5etmnQR7KX9HgB7IngsG4UL5m+yXLeEeareRBZw
	 zJKgRWlcSLumweQ1TgKQe/ahUdV+P4c3WG1LN9KmgL0Sb4VLyyIPrgND3IdMF9MAFf
	 ZHkgGwAVE/ZzKPf0BFW8arGJYeF1CPRMcito/OxPzHUCjpF5qx03js4YFEzb4oZkJp
	 3uchWEEiUQRbR/oDYhCaorGOHXUU1tm1jMQF/xythj51HDM3iT1Zsur3NXF7piq/6I
	 /qG90n7ZN6kdw==
Date: Sat, 2 May 2026 21:26:50 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Anindya Roy <anindyaandy1904@gmail.com>, david@kernel.org,
	ljs@kernel.org, security@kernel.org, linux-mm@kvack.org,
	lokeshgidra@google.com
Subject: Re: [SECURITY] mm/userfaultfd: cross-inode page cache injection via
 mfill_copy_folio_retry()
Message-ID: <afZP-uhukndgjtO1@kernel.org>
References: <CAMyZbw_ppC7F98+5huwmGjz03UGv8L8MoU9zL2_YYDU=fA3Qxw@mail.gmail.com>
 <20260502024012.30be89b2549bb18a1a1d0ddc@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260502024012.30be89b2549bb18a1a1d0ddc@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 8706EA0002
X-Rspamd-Server: rspam04
X-Stat-Signature: xsfcoxt7976qt6rcnmuodi59kxm6g8x3
X-HE-Tag: 1777750017-987665
X-HE-Meta: U2FsdGVkX183PWMAfLTCDHJVnDE1bh2mpItUGdbASfvxmP+5DKXdjLa5gwh0EQLQA4GEN03S4ZC+qIc43pZARyF2HcOMhLVWh7JedSIBD5oKH51hinvgFxCuloANF1T9iyMCFhsyJLoyVLOi6j9Z+KJ3MhjVDLJS8PVBpWF11zg3Taw+nk/SmCX7QLRg0+KAx+8Np52YdW2zaseYnUmvSAi2MRT+e6ZDyjzHw9OZNJUBO/CmXDrB2+tVr364gtQpre6KrTg7EcJztyQRrgzIngNuXMZY1fYapggs3L73VaPVVL8vdGV1cO8WQoZ17rSRrXyW7GuxJi9XJechIW3iAqKZ7euPIYtQ7BK+omKbL2Z7uSRtx7VLsA30+dArVaYNdlouZQQxNRxyVIi8IRjbVL5GLVORtZ3rPzx2eMNDfNF3iRIetVaFUO9xC+acOwg0UKx6gUGwcCiJQfqYokv0J6qCwQKwLIH1fOe8tzs1VYjJSVtQVevGJF/1ETakn4/cICROLdTTBFoB27xhfWX23sOfWP8luUx9a0ncVZywasCDid0430tSPnRcfMS852T4vI+7aWXtsRKl1KLriL6QbadDERpvwycVKNRrzug9nAWff7aDRlocR1NuQZMwGsonBFD3l6579RXHBrz59fcPNqYnkxEL955+VJQiuntObrmtG2lnXC+p1UvyO3HUzcwvP5rSNxWmEG3r7F8J0i3rw8WOdEmr3jkS9J5l1mXureGO9PZpeUD/hnCQFkJa/FAxVVDJjo5TNgd5OUhPtMj8rth1I6jhzGmZcF5zzBn1qeKWgc/+HjECTJ1mQ2tKAyY42eSHr9OOrg6Ct+83ecP81vEvr6Gk/02JqoVWRwppptTKgrazj4q6540Fk4Frx6SnssTkSb+D442ZbN6Pc0RTgBNkRWJ29O0j4fWhwQFKwqMiS7sKxNDSwJNU6FugVEKpNM6zt5KpU3PPwVyQT4y
 f1mKf0UV
 84QufY+vlX43+N1LcuzJFERhZtbsjH6icAlIHxQI9BU7WQ3w/UTM/iNUHXcOuMaSSeYRJON3C6iW/7Kohh/GQgMTECwOQ03zwslE8d8WsnAZ2sh2w7cnZ3UVmIcOjfvv9YyIW6oRltdWNKqFwug6Sv3KokIDzf2f5B2+pxMueLq5GX0mCT5BbX3gV+JT9M5ItON+3BI7VK+BEj1JdKxfbFx50N2ExbqgFoAcGCh8sNPBlIOEywCAsEWQ3YYoUhY7P404ALW2VI0Oc87/RPPHgivE2Iqg56c+8LvNjH6A3tPkovMktmV+iwOWPytCX2hPArWaecBFjJ3K5gg2rrfVBZa2LPja7JIlEuZXjNzLI8azqYrk5yhKXzBRY0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 02, 2026 at 02:40:12AM -0700, Andrew Morton wrote:
> On Sat, 2 May 2026 13:50:02 +0530 Anindya Roy <anindyaandy1904@gmail.com> wrote:
> 
> > Hello,
> > 
> > I would like to report a vulnerability in the Linux kernel userfaultfd
> > implementation that allows cross-inode page cache injection due to VMA
> > replacement during the UFFDIO_COPY retry path.
> > 
> > *Summary:*
> > 
> > A local unprivileged attacker can inject controlled data into the page
> > cache of a different shmem/memfd/tmpfs inode than originally targeted.
> > 
> > This occurs because mfill_copy_folio_retry() drops all locks, allowing the
> > destination VMA to be replaced, but does not verify that the underlying
> > file (vm_file) remains the same when execution resumes.
> > 
> > As a result, a folio allocated for one inode can be inserted into another
> > inode’s page cache.
> > 
> > *Affected component:*
> > 
> > File: mm/userfaultfd.c
> > Function: mfill_copy_folio_retry()
> 
> Thanks.
> 
> > *Affected versions:*
> > 
> > Introduced by: f5f035a72423
> 
> Only in 7.1-rc1, fortunately.
> 
> May I ask how you found this?
> 
> Annoyingly, Sashiko found it:
> 
> : If the locks are dropped during the retry, can the anonymous VMA be
> : replaced by a different type of VMA (such as hugetlb or shared shmem)
> : at the same address?
> : 
> : mfill_get_vma() accepts these VMAs and returns 0.  When execution
> : resumes in mfill_atomic_pte_copy(), it proceeds to
> : mfill_atomic_install_pte() using the newly populated state->vma.
> : 
> : For a hugetlb VMA, mfill_establish_pmd() will allocate a standard 4KB
> : PMD into a hugepage page table hierarchy.  For a shared shmem VMA,
> : 
> : folio_add_new_anon_rmap() will be called on a shared file-backed VMA. 
> : Could this sequence cause page table corruption or kernel crashes?
> 
> We must have simply failed to look :(

We did look, we didn't reach a consensus

David Carlier sent a basic fix for changing VMA:

https://lore.kernel.org/all/20260328170101.184163-1-devnexen@gmail.com/

then Peter suggested to take a "VMA snapshot" to verify VMA didn't change:

https://lore.kernel.org/all/acrRRRT1xrAqNraj@x1.local

and then David sent a patch that compared vma->flags and
vma->vm_file->f_inode:

https://lore.kernel.org/all/20260331134158.622084-1-devnexen@gmail.com

but since comparing all vma->flags is overkill and could break existing
userspace we decided to postpone this until after rc1 and only check the
ops to ensure kernel won't crash if the VMA changes. 

As for me I'd check if we are retrying with the same VMA, but we don't have
a way to verify that :/

-- 
Sincerely yours,
Mike.

