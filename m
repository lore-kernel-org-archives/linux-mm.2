Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8619CA5FAB
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 23:40:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBA936B0088; Mon, 28 Sep 2026 19:40:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6B426B008A; Mon, 28 Sep 2026 19:40:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A81536B008C; Mon, 28 Sep 2026 19:40:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 867636B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 19:40:02 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0C0381A034D
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 23:40:02 +0000 (UTC)
X-FDA: 85264791444.11.4E8C743
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 298D240004
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 23:39:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=YbM3qQSO;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790638800;
	b=khFqP4cHwua588c/dm3Kg0tARMiheMbsAw0gafC3QRvx3m6IbmUiVCNEmPpK51mHjv5NsL
	fBvFXwDNqcp08vxkhwA+GpZx8+j5BOCYDLpp2FDEwPTXJ6fEkTx3HjSrNWGziteidRwmCE
	v/V9V1hJqBus/xrg5qAOsQMiy6tqWY0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=YbM3qQSO;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790638800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1HFLO5rBdRNtlKvRCci2EuPZ1UPk8TFVkIuVr0KdXBc=;
	b=VO/q61NmNiOxkhXEdrxK8E/Jg4c/vGE8JSh+u3lf7SW1pKlIuPbPlZecl8OrfQNjgHmGkz
	zGEGiqVU1HD0d+zVccwDDKwSA1cOF5zWff2lMQH2pmRiftNA1qsDjQp73cMUtKMoq1xJ6P
	ozE8e9UhJvcgqmoOK3/CS9tPstwEpPo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EDB9F402E2;
	Mon, 28 Sep 2026 23:39:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 391A51F000FF;
	Mon, 28 Sep 2026 23:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790638798;
	bh=1HFLO5rBdRNtlKvRCci2EuPZ1UPk8TFVkIuVr0KdXBc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=YbM3qQSOZprYyJJo1LOb+4d+Unzi6Iot229rfqkh1ZIpP15t4Xir0u6Ip6jr0ONa1
	 W32A/o6ob8UZY2av8Rs4ZiZzDO14UDp3WmYDpngemwMM5JwE5Lo9QT8cA9uKHVYhR7
	 gCT5kHe5AejMLxykgr9gbhIZ/9JtumReda/umMW0=
Date: Mon, 28 Sep 2026 16:39:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro
 Falcato <pfalcato@suse.de>, David Hildenbrand <david@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 0/6] mm: make MAP_PRIVATE-/dev/zero mappings truly
 anonymous
Message-Id: <20260928163957.832a27ee9596a25a282c2707@linux-foundation.org>
In-Reply-To: <20260926-map-private-dev-zero-v3-0-d4781e84ccfc@kernel.org>
References: <20260926-map-private-dev-zero-v3-0-d4781e84ccfc@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: hckudforxihkn5egcm7soh7pr8zxsgka
X-Rspam-User: 
X-Rspamd-Queue-Id: 298D240004
X-HE-Tag: 1790638799-229851
X-HE-Meta: U2FsdGVkX1+avn/w11Y0ZQXwHi7ZNva2Ei16rnctZbEGW4mIac/zRFrDEGW7ahGtdIxxh8xHiL7ahrCbCkH77wGm8hxYDAS+QeMxTx7Hn+W/WOb7yQ+li6iE7OR+2lfqSVZehrVsv9zCU7z/qfgsYDcVhfPDrkH0iBg1Inu7ksWXBuOSlELxE4pNWspjKGDYuShXIlwC8gfJHhZ+p3gsYVqnfzH9A75Hu/61hS+0B27Nzj+IWRzSUeIvRr1sEDBdxTo47kKEGYeUGYu3A8HKd4lNLRiiXmZk1RkbitxU8uvvv9imsy6Jyp+jlxbdK/2gskrN+OLLc6cy3P8F0HQOek1QBiiC+hdr8XcEGp6ld728ThrXaDcaiRA3K03c+B0SMbggOdgjsdY5MbCDEmgdyXlh8pyHU2KN8WYKJsyhv6+M0ytz5XPwANTF+xXEVcA7HNUFbyG+aNn7Mp7sLQcyc5HfaXtS3esT7a8bhVW2y/JC7TYcYWUg75Gcm8lrzn1cK7G0JcM+v3IXyJlS8rP3pl5XznQJGJhQrzWkEMeKwXVZ7Pf+aGFipVrzQUA8KHKOOodLOfZ0hXziLkJgcZ+Kabml6afoehdvIjN2TUonhXAN2LmZZQc+QSGyNW2N+b7CE9irMCQtySQ0/FvANThVRtLqwE6UMZ7e56H/jQRc4OqX9b4QxYRj6pvapisBGyzal+86DqzSXpeG7JQA8r8lzp4CeT5r/OA+3zAoMF9XxD3qZMbHfo6waGROxuy20Y5oALucMjG91OZI6mfjNgBGCFEgxji6b1gaHZq+SivKpDHY/vBoWItIsLr0DuhcZTUyCEwn2uLO01CmwQpEKI91CWZrLavIhSBrFTJwx2oySv/m/HVpIShPN/fWbf7M3jk3hq7Tstt6mAFsDfnftXFTvMKf7qUg4bmlGAwpqTQccKYfs+6pleApW+UFX4pwaJPazZc3LgWCGE2EfKlcfkg
 RdDrpQZz
 qkrlaNPyB2RgtzAcYS6wzvqOCq1vsK3qATBHc29c7t5eCfwjKrSJb1SbqsjPWprqLT6AAJDQN7HUZD4qbg/UAkdFgjuXCaZZ+WIBUcTyWbeT5lc7BY2T7HLpRudqUnWUFl9EhZY5ruxrv5B8nCcONBoIVvAslYMUxJinN2xzb52ftTzQH7yvQNUMdbDd9uTMM0oofxvXnzawg4g10UR8x/P3gFf/G9aTRQhkKQDoqIXObyMLymfxgJburHIr9miUXVijIOtZn7qJyWeZgy3eDb772r5petRnq8Sj+HcXQDrP3Dwit1WMfijNdZrm373ivI4x6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 26 Sep 2026 11:41:05 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> Historically anonymous memory was obtained in linux by MAP_PRIVATE-mapping
> /dev/zero.
> 
> The canonical way of doing these now is mmap() specifying MAP_PRIVATE |
> MAP_ANON, but we must continue to support the legacy means of obtaining these
> mappings.
> 
> As-is these mappings are an unusual edge-case - they satisfy
> vma_is_anonymous() but have non-NULL vma->vm_file, and their page offset is
> the offset into the /dev/zero file.
> 
> Commit 93c0c8dc87f6 ("mm/rmap: use anon pgoff to track MAP_PRIVATE
> file-backed anon folios") causes all other anonymous folios to be tracked
> by their anon index (vma->vm_start >> PAGE_SHIFT at the point of first
> fault), leaving MAP_PRIVATE-/dev/zero as the outlier.
> 
> This series remedies the situation by making MAP_PRIVATE-/dev/zero mappings
> truly anonymous with !vma->vm_file and correct anonymous page offset.
> 
> It starts by bringing the memory character driver into mm/ - this file
> implements /dev/zero, /dev/mem among other things and is already (as
> clearly indicated by its name) within the remit of memory management.
> 
> By doing this, the file_is_dev_zero() function can be provided, internal to
> mm, which allows for positive identification of these mappings.
> 
> Using this, first prevent any other mappings from mapping memory
> anonymously, then make these mappings truly anonymous and eliminate all
> code in the kernel that previously had to account for these strange beasts.
> 
> Finally, it adds userland VMA tests to assert the behaviour and selftests
> to assert expected merge behaviour.

Thanks, I've updated mm-unstable to this version.

> v3:
> * Added tags (thanks David! :)
> * Moved the reworked mmap_prepare vm_ops comment to 3/6 where it is introduced
>   and fixed a typo in it, as per David.

Here's how v3 altered mm.git.  Includes a merge fix for the
recently-added hotfix "mm/vma: predicate setting mmap_prepare VMA
fields on new vma alloc", per yourself.

And...  really?  I already had David's tags so we did a full resend for
a single comment typo?  Little -fixes had their role...



 mm/vma.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vma.c~b
+++ a/mm/vma.c
@@ -2816,7 +2816,7 @@ static int call_mmap_prepare(struct mmap
 	if (err)
 		return err;
 
-	/* It's invalid for mmap_preprare hooks to clear vm_ops. */
+	/* It's invalid for mmap_prepare hooks to clear vm_ops. */
 	if (!desc->vm_ops)
 		return -EINVAL;
 
@@ -2932,7 +2932,7 @@ static unsigned long __mmap_region(struc
 		allocated_new = true;
 	}
 
-	if (have_mmap_prepare && allocated_new)
+	if (have_mmap_prepare && !map_is_anon(&map) && allocated_new)
 		set_vma_user_defined_fields(vma, &map);
 
 	__mmap_complete(&map, vma);
_


