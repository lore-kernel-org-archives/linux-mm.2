Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4511D35157
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 07:49:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 591496B0005; Wed,  1 Apr 2026 03:49:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 540D76B0088; Wed,  1 Apr 2026 03:49:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4576D6B0089; Wed,  1 Apr 2026 03:49:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3061C6B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 03:49:40 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BDDF8BA5C1
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 07:49:39 +0000 (UTC)
X-FDA: 84609212478.05.34E8E1F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0E9A01C0009
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 07:49:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WVmXq4Md;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775029778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cRal5JpvGQi/Ec1z4Xph87pR/OtOOriU8MwfQlFWDg0=;
	b=y7B2U7pEEbrCV0XjVzJkJtN5d+DSGIy/HqisYvF4YKrPqISzGQwgpRUAZKwWtr09aUM6gG
	wNv1N4xn4E2ddRZUKs0RtghVREbWPGoPDjGc8Hm6VdVmyCyEdYRoPIdd/wdnC4ed0oNHJJ
	88JmpsH4q7cLSM9AEQLUtzTdppWjwgU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775029778; a=rsa-sha256;
	cv=none;
	b=N0W1Uit45BvvsZZXEpiZKdSmci9lKEQjJ7A6Ztz2dhohxLgMT5DcCzzjJqlxG/1f0KJQBw
	owQo3VCdRksK4ZUopiDrEfJSClX+TGYmzMDBSR0VHk5vTLG+m3WVhK5F2M0oi6925o331N
	Nn4AjdPxjAsf0HiTrwziXSafQouHU40=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WVmXq4Md;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DEA58405B4;
	Wed,  1 Apr 2026 07:49:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9691C4CEF7;
	Wed,  1 Apr 2026 07:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775029776;
	bh=KXrcAabRXu64p61zi0r/SiEB+D1HpCqdbity0mmwBtc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WVmXq4Mds92NLhisdW5zIPu95ypbyDQ5cW7sYnZ7ymo0YlW7BzXrBQpUeXlhC/qsk
	 MblqDdXhREK80qPF34v2Kbw8Q21xXmxzphPaVnu2fn/ahpcEGRFmJ9iDn7YdqiPBh1
	 +xd8Aavr8LoJZKPgA/64FkWmAevt8V7iQGNXRTuoedmkSqXL10uzrfrH8otepZGZLs
	 fxe7H7piYA0MCvI8R0DtxMfC43MNiSQ6TzXYVfSz6h94G4KI6uZe8b0c8XkzNL7Bke
	 UPCNshClzH1MkpNjrymmG/npAbTxpRGt6mw2VjHCyQUlmwOnw2TTbDRswi7VCXrSWM
	 UWwY+v2RUf+rg==
Date: Wed, 1 Apr 2026 10:49:30 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Carlier <devnexen@gmail.com>, Peter Xu <peterx@redhat.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v4] mm/userfaultfd: detect VMA replacement after copy
 retry in mfill_copy_folio_retry()
Message-ID: <aczOCqrCx7Xd5HIF@kernel.org>
References: <20260331134158.622084-1-devnexen@gmail.com>
 <20260331200148.cc0c95deaf070579a68af041@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331200148.cc0c95deaf070579a68af041@linux-foundation.org>
X-Rspamd-Server: rspam12
X-Stat-Signature: 617w4xdoyawbsj3gfswqomgbfksc9io3
X-Rspamd-Queue-Id: 0E9A01C0009
X-Rspam-User: 
X-HE-Tag: 1775029777-16597
X-HE-Meta: U2FsdGVkX18TYa50bZZ0l6MgQv7PnN9/rvBsrOwoJgdtSlxminLPR/r0y1NKjw2Am2ki+PAit7jVmu7gISU4WQvi1xynEAfGLAI71iJCMU/fbuygu8uXh7mkkPlwyVKX+7H/C9WRZaE5b7TcTS0kBsdt8uq+BbiCDoFTLI1K72ZuIQIoWaWk8z4f9aZXae0hXbF0cQ3Vr2jmukI5oI8Bq2XQ4DRV+V+YkCTACMFWQtS0ba6BbOsfEvt3ocBQ7PGKL1E3s8vky9dJDxOVHBKfME1hDmpn/wX9bRf1jcaLHbgq+3Qhwl15ni9eU6acKnnwKc0I1Px2n0dXPy9s3pxbkm0HpsCpbHNDiyM4qcw4JDPgyDjk9aXmy6dE9XIMLFIe++FwsihCVOJ7ybQZDkUpL1sfcjfF1SKrJOrhMCw37uweumK0i+UFj7C64YlsIfbpMfkql27edejvSRooqRaz4fGK/BZkpzy3SZS8PsoQ+TgX08Fu4dSjPlHtpVZ0/JXECPYCQnZFLJ6MIn+5omBuMdVHK2mnbnj8tdM9EKlIDeJNZrD5hF4EjqZj9GuKNL1y9w6wHozqNebE3KeVVWqhIVMcVB1FqA9lQUq31qLXKGWTrm7m/BBTL+KkwlBQZuX1v/Q0CLS4EqU26jnpH/WMvHJVYQ7qMW88BQ0cZFpDgF4BhEaPXVNmoPpXXSqC/iikKITquFA2eMWSg61kW3jF14YCTjv33pvr+Rdl5ts6yXfxlNqIsS1S/p03hle0Xy/vEzeaXbONXQJzi32PHPPFUONdzTDS+fJpNCrs+fXWuOmW23B8upYcYJk96yhAuokMxuF4TqBsCogrSQ48fBXgRBHVN/wO5gy3Mzai9wOB0pjxoig8mbbVYnvJU7bn0mrXrlb/4z2wsodx6DCYvyB5WGsJ3jm7W08SRa4H04YXww7cli/EpBp7B7B1kU9b9Tn2ZnbVTWNxLEq0xX2fSp4
 nOWDOXPA
 jrYbEC4DXxAu5mLk4BMCayIFi0WypaOptyKYOSi7WYG9U8f7i9Iw/Q6RTyq3Kx5SblkZeMz6MYJmvpXoOBNsBr6eddPHf0LNTpne/mAlKsxm67SOHBu8ZX6+RDQ83A/UlG64GjmAI1grlw7d65744061RFb4v5ianlSTPyu/JfoaJK12LCGU1Hl9vAozIE22F8DXYTLcNUD0eBQTpgsz/BHVpCH/HhsmfvKV7NZOAPNiwXCwf89Scznloycl3+tzR9LvssGiAqaqn0oo1ImzA6vyJBdI8eOilewpkRNQIiPFkpo+e5dQVTmIroK7JP5FogyP8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

On Tue, Mar 31, 2026 at 08:01:48PM -0700, Andrew Morton wrote:
> On Tue, 31 Mar 2026 14:41:58 +0100 David Carlier <devnexen@gmail.com> wrote:
> 
> > In mfill_copy_folio_retry(), all locks are dropped to retry
> > copy_from_user() with page faults enabled. During this window, the VMA
> > can be replaced entirely (e.g. munmap + mmap + UFFDIO_REGISTER by
> > another thread), but the caller proceeds with a folio allocated from the
> > original VMA's backing store.

What does "folio allocated from the original VMA's backing store" exactly
mean? Why is this a problem?
 
> > Checking ops alone is insufficient: the replacement VMA could be the
> > same type (e.g. shmem -> shmem) with identical flags but a different
> > backing inode. Take a snapshot of the VMA's file and flags before
> > dropping locks, and compare after re-acquiring them. If anything
> > changed, bail out with -EINVAL.
> > 
> > Use get_file()/fput() rather than ihold()/iput() to hold the file
> > reference across the lock-dropped window, avoiding potential deadlocks
> > from filesystem eviction under mmap_lock.
> 
> Thanks, I've queued this as a squashable fix against mm-unstable's
> "shmem, userfaultfd: implement shmem uffd operations using vm_uffd_ops
> ongoing".

First, this a pre-existing and TBH quite theoretical bug and it was there
since the very beginning, so it should not be added as a fixup for the
uffd+guestmemfd series.

Second, I have reservations about vma_snapshot implementation. What
invariant does it exactly enforce? 
 
> I've fumbled the ball on your [2/2] unlikely() fix ;).  Please resend that
> after -rc1.

This one should go the same route IMO. 

-- 
Sincerely yours,
Mike.

