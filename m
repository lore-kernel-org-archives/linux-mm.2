Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFCB0CD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 04:10:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3674C6B0493; Tue,  2 Jun 2026 00:10:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 317EF6B0497; Tue,  2 Jun 2026 00:10:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22D596B0499; Tue,  2 Jun 2026 00:10:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 106B56B0493
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 00:10:08 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AEB661C20E7
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 04:10:07 +0000 (UTC)
X-FDA: 84833644854.29.756BC4A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 22B6C12000B
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 04:10:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CCnkphUC;
	spf=pass (imf29.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780373406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RprQiT8iFE4bavkRAkUlxYO6/YAO1eRv5LSSO66hPdw=;
	b=zwVieEfgQMGsKASiPykJ5qrImvlKgyJMM/Mk9g89Jwb4Xq3UuL6uI027h1v0V4lzSzWozv
	mhIsqfCOCxhAChNw/0OnioYfOP66tVPV7si1rQ1Humx/a2an7UZ8BPPqRsnsopMS9tws/G
	DoQzfrNU15RNL5oL2sggcHnUywSvvJM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CCnkphUC;
	spf=pass (imf29.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780373406;
	b=IAvT9HYM9EdAX/420LkOCuW+2/rcil2UnTZvlNUlQvhBMyyef9YPf+ZCq2sETOQnkFx3VE
	yoa7k6L4IPM9/My3wMjy8cSIXH9NrpZykTNUraBH9jOPyRoQK9CosayiUGQGgE08/BNQ2t
	r6vLN+NxCTo00fpl2KGzlY/W/lMajdw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AD00C60123;
	Tue,  2 Jun 2026 04:10:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D34C81F00893;
	Tue,  2 Jun 2026 04:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780373405;
	bh=RprQiT8iFE4bavkRAkUlxYO6/YAO1eRv5LSSO66hPdw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CCnkphUCLKzsOe8oZU9g4I49LlxWnjIbhTr81AptOG3GxufizbsO7Cq6XmF4R1d0Q
	 qpnzcfP8QgQvVt0d1ubk5KMak7QcIybEWLFfDcTAQvF/4HSi+R9pkLPRcurFO+879t
	 mpYIvub/LUwNGxuH0jIHp0p8YZIrQUxNNm8e+WNwqPOvNSEEiLoLFeErQuvHDERk+O
	 ctfCRN6g8D9SQeLejpGTs+CoK/ZkcamMYwSyBOB0yiER21jOAUD3VoqlYKLTZOW9XS
	 kTB/7spli2HK23TeuXHIn5MmYuwMV1fKBSXOjSehNlJUK21nM7d5UEDIGMCLPG/l9C
	 bDx9YEaC/NYGA==
Date: Tue, 2 Jun 2026 06:09:57 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, SeongJae Park <sj@kernel.org>,
	Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-hotfixes] mm/huge_memory: use correct flags for device
 private PMD entry
Message-ID: <ah5XlRdBMG54CWFp@localhost.localdomain>
References: <20260601083044.57132-1-ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601083044.57132-1-ljs@kernel.org>
X-Rspamd-Queue-Id: 22B6C12000B
X-Stat-Signature: uamujqe59s98f7h5x1ogfwnmr4511uw3
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780373406-11467
X-HE-Meta: U2FsdGVkX18JomEC7ZKpvz2fkqsaaEseXKwQeCMx9M8qp4Boz15UuNNNWGHJxVZ1zxUzQctNyA8laiZPPjvHJEZIOpTkGmT013daWSOI/RnwxwIaTcwQ1raPaj1NqZbyKw6itWWlhq3rTOQVf1hGkI3ag8ic0qj2Ot4bQBYZsG2rt9EjwT2+44aLADJzxWTZ0C+ILDy5GbB7n4acmKTJI4Omd3xlf8Z8YbqLmdcbM/X0P2Jeg1JqXFPlwacSA7E3YghhTRn56PeZacbFErU62IvZfHSR3aREw8HJOQgwmDuqWEtm8nfM3uM61LKMzd4sKmsaeShy55yzc38LLRbJ9TcC+DK8v6Zrz4Z0yEXHxHgFo+OcOq8s+Xa5I6cX+R5ELq/hFU8q+H2Dd2aEALurDUXaAjT9IYNhlKPayHHVJuTPvm50V5N1iCVv0QBPQi4/fQGbq15PlTkwRj6/iUPN9alhDJtIMArTbkwj83KRApd6ViqLFA0PW5aFzmWqdrZPCQMg9JCE4fTyC1ohGPm6kp+w02xVKbH3GHi1Dq5fp745VlILELhUs4x/0R4x0xvlNRQHnURvJgaFM7UzZFbTMGy7xUdm1RzVPNl3GG/arUhJ2MTt5AhF6W34bthfnq9sOPRkAhXi6UDiAZO3xZtN8WBSJYQjx/hrnS+bWR2wvVF9IpJ+HgvfoXDoxe9tr6g9jMiVd9aeyQpqLkpD1ZVtu4MvE+lakFF+12eZKN/CDrS6dULq4w4ecf1+/YcImQ/m1WpY1cwILdl4H+8OpfT/AdetqBBISSw3acRmuT2oiDBIqK9kd6N2OYgJNEioxZhZArrFVRANnTQBhyCsvRbsRfBBG2Y3VpJIX8XeaLt4+6/96nF5zKYwsHgsJmtiDqJw0OIVlnnL0GC+qFgYkWfXce7CfWfWyFzGOoZLRM78cIT6U1kGYZtWQJF0+uvR+BSQBH17DeDEfplnYssDzDJ
 RWNcm7bT
 JRsmAzqQNNQfVHBwq/UPwZ4mL3yUxHPqdp8zDtePKKkzOXiCRnpDHGkNMVBk69ZNPZsTxNdYaIJO4HmhgdPuDf1FKn22Jj45a4TjSrs+kkAEOuSwTWgWddYvYc8h65AL25FtLcBqxGaP7qhfji0GW4kAvvSYswg3t1LI2I2LyEKHTtAynP6VqF/JbxS0RJISyF9bcLpmS4j3ao9juomncgjuTtzgpJPnrCaDIW/lNMtT3WT/Kml5yH0BjkoJ/dCEUChrbpmPyZkd3clFeUFJX9RnQOwyWXqQgdETW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 09:30:44AM +0100, Lorenzo Stoakes wrote:
> Commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration support
> device-private entries") updated set_pmd_migration_entry() to use
> pmdp_huge_get_and_clear() in the softleaf case, but made no further
> adjustments to the function itself.
> 
> Therefore this function continues to incorrectly use pmd_write(),
> pmd_soft_dirty() and pmd_uffd_wp() to determine whether the installed
> migration entry should be marked writable, softdirty or uffd-wp
> respectively.
> 
> Whilst all are incorrect, the most problematic of these is pmd_write(), as
> this can lead to corrupted rmap state.
> 
> On x86-64 _PAGE_SWP_SOFT_DIRTY is aliased to _PAGE_RW. So calling
> pmd_write() on a softleaf will return the softdirty state encoded in the
> entry, assuming CONFIG_MEM_SOFT_DIRTY was enabled.
> 
> This was observed when running the hmm.hmm_device_private.anon_write_child
> selftest:
> 
> 1. The test faults in a range then migrates it such that a device-private
>    THP range is established.
> 
> 2. The parent then migrates it to a device-private writable PMD entry whose
>    folio is entirely AnonExclusive with entire_mapcount=1, softdirty set
>    (accidentally correct write state).
> 
> 3. The parent forks and the PMD entries are set to device-private read only
>    entries, entire_mapcount=2, softdirty still set.
> 
> 4. [BUG] The child writes to the range then migrates to RAM - intending to
>    install non-writable migration entries - but replacing parent and child
>    PMD mappings with WRITABLE entries due to misinterpreting the softdirty
>    bit.
> 
> 5. In remove_migration_pmd(), if !softleaf_is_migration_read(entry) we
>    set the RMAP_EXCLUSIVE flag when calling folio_add_anon_rmap_pmd() for
>    both parent and child, which are therefore AnonExclusive.
> 
> 6. [SPLAT] Child sets migrated folio entire_mapcount=1, parent sets
>    entire_mapcount=2 and we end up with an AnonExclusive folio with
>    entire_mapcount=2! Assert fires in __folio_add_anon_rmap():
> 
> 		VM_WARN_ON_FOLIO(folio_test_large(folio) &&
> 				 folio_entire_mapcount(folio) > 1 &&
> 				 PageAnonExclusive(cur_page), folio)
> 
> This patch fixes the issue by correctly referencing the softleaf entry
> fields for writable, softdirty and uffd-wp in set_pmd_migration_entry().
> 
> It also only updates A/D flags if the entry is present as these are
> otherwise not meaningful for a softleaf entry.
> 
> This patch also flips the if (!present) { ... } else { ... } logic in
> set_pmd_migration_entry() so it is easier to understand, and adds some
> comments to make things clearer.
> 
> I was able to bisect this to commit 775465fd26a3 ("lib/test_hmm: add zone
> device private THP test infrastructure") which first exposes this bug as it
> was the commit that permitted test_hmm to generate the test.
> 
> However commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration support
> device-private entries") is the commit that actually enabled this
> behaviour.
> 
> Fixes: 65edfda6f3f2 ("mm/rmap: extend rmap and migration support device-private entries")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

LGTM,

Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>


-- 
Oscar Salvador
SUSE Labs

