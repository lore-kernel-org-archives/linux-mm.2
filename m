Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC29D60A6F59
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 13:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y8LiwM6l
Received: by kanga.kvack.org (Postfix)
	id EF72A6B05B8; Mon,  2 Nov 2026 08:57:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E80AC6B05B9; Mon,  2 Nov 2026 08:57:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBD896B05BA; Mon,  2 Nov 2026 08:57:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BAE576B05B8
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:57:09 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4CBCAC0CBE
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 13:57:09 +0000 (UTC)
X-FDA: 85390330578.18.E6B52F1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id A1AEB40005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 13:57:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y8LiwM6l;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793627827;
	b=vGXShMA9XDI1XIZabdyYdOko6LAcMSNOr3oUaE3f6Ug9fsil3Eugx5PcoD8EQrHsCZcsGp
	JEh6KnmOGkYCoaLgLS5MqSKQ6pToMHBm5uEQ5oVqdMSWx0DWNsI+vdQh1c3JFQvdJawIzV
	buOmRQKbH+J4ikJPhUgN3D9AULFub/k=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y8LiwM6l;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793627827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GJ+cB/jMdtBTVyuYUnGuTW2ZVmrLQs5lN8q3rXjKKYI=;
	b=JPYdb3pP/oZ8Sy07qK9ujSW/hiGzRa4+FI1jvkYHEae8hPUScdThApBDKl6pbZ0ZiD0A8o
	6o4xeQK587oGs1TBX9nCTpyLUlyMEuQwlqmMNJCmuyxVSRqfsJbiXs+//xB4yds/fUQLqm
	iqcylKit4qdP/DxJPvKtKSHLgW1GQGU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D293643F1B;
	Mon,  2 Nov 2026 13:57:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E0C51F0180E;
	Mon,  2 Nov 2026 13:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793627826;
	bh=GJ+cB/jMdtBTVyuYUnGuTW2ZVmrLQs5lN8q3rXjKKYI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Y8LiwM6lvjMblBVw3nOnUa1v6Cu8s9t84KZtbD9xvJwNO1rcFroykRpHiuxtJ5Ph7
	 XJmf4/AbtvaRkY53d/MpN9J1sMUFUIjdcsj4B+MYocRvBfVVTdEHA5NAxEZ76QO84e
	 riOSZipZXAynFTi35mlwG6JMmbx8pUQ/7CkWkGELqNFo8esUwp0bA/RAQ0BtcNYcJu
	 QiBGE/orViUB+EXBotlnsk6qf4jkYPvoM0aeqwDl1o0HIribGcDthN+bPWVMDLSVJZ
	 qWYRodPrvmtI2ljc33AIK5T+WeTCpCw+Q9RGgYOvOdc/lxDwm1Nlr3y8PYePk8g0qi
	 LzzRzW8SnZJhg==
Date: Mon, 2 Nov 2026 13:57:01 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Josef Bacik <josef@toxicpanda.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org
Subject: Re: [PATCH 6/6] mm/mremap: split first so a failed split is reported
Message-ID: <auiSshtJveaEdL8b@gremlin>
References: <20261030-b4-mremap-pre-split-v1-0-c1829811aed0@toxicpanda.com>
 <20261030-b4-mremap-pre-split-v1-6-c1829811aed0@toxicpanda.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261030-b4-mremap-pre-split-v1-6-c1829811aed0@toxicpanda.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: A1AEB40005
X-Stat-Signature: y5xukwqzucccfyypftsqzq3symdmcdp6
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793627827-656472
X-HE-Meta: U2FsdGVkX19GOcCSkgf1KEdMmr5pL5eHGal4ARh3QoGwxIJpatbh6UBy4ZXMLBkn6WmjRzcUzN4JvHN6NL5o95lafBhEaKVBFhoGFYUJsxOHOrTpU39ex+m7AXnrPtXoAR61zGojHXQR8HsnIb8AMO8E7hRXh0IrSO65pmAUYL2lntg28P4oRf8Lw3IpAevpsH8NoRi4RVtu1NkXN0dpvyysMLiW65+zl0Fez/5DKg71Sdlx7djHFqKacGsSutTNemNY8lAUwFYZiI4KmRMCMACXyQfBulBxzhO0moCf8bPWtLzRVdYsqVJlteE789MCEwpUr6ibaLgx9jETA4kk10Oas7xWyGlCr2lsfaRT++XlhxnbmfFH2bnJTaPxeHJkzfNir6LUSHOuj1zXvG0edWjsv3hVRCrm6XdNnLutwh9ZzpgDx//JapJhDteA7phEfSJN1wGL6DiZ9sOlP7x7QvODhx0aNEjOXZGIJ2nIfEgXm42hO0CYkv+JDY6TB0O3oMUI3NiP1VSovwRqs0qvF4kKFKF2H6OhEg6cBQ9rtaCGYQEAuNzGp9Rq8NXMBXpiZg5tOgIbtV1DeHQHrHBKr6NGTR1We+0tO30P50NkY7HtMK2rs1Dd57m/Ye96EJOVZzT5Yob8uAmRTqQyZ+QC7lXKqKZhwWhgJxps0zk6i7YS3v6u7w5WAzHR//Z8q638QnkH00NYCmjnfIu/G26iDaLsTA+xDJVms6OMcp0L1TCE3N7EMuwKNLE0R2sCQS8XBZ5gbKaItr4WtPu1u0Yq3RzlOwC3bdlP19Z6NDQTeMlgP0c+1Nh/isSruIKo+maKBCelVgKaaBp/vWN74tPv7HzZiS8yTLpm829zXukNp5OmA6AGAwEVXgswMHPTypxaLJVI3fFvGuP351H+6JF7rlCBfsfdZ3sIXlPAz/v3SCThUDUTBtUo2vGFietpxLB/Zk92i/xuAE/AzBodjXD
 qHajm3VL
 0KKE58WyJQY+iGbfmXOkz9hOYXYRA8oySE9xMZ/bnOP6f53nMqRYP/l7TlWp/DwvrMAt2bnboeI6dbDaKa/eijsVEgqM4fJhjGSnI3il4VWKId2Lm6f8iRLXh+2zX6UZ7aK44oecGQZdbm7bGIxWEYT1QsZWJ036XsAuB9UD/HxuCMi5RhXaTsE0j9hlzHFltTPNfJtdnQEF5EpjAgFJf8XcZpk/Q37f/uXgDCCrQQBT/FI+bTfqnKWtj5+nZxWEFhkxCAgMHBz+OgNn+K21enXHPRyLODN24NyNqxAVffUOs0Q2F4tKc8F+q1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 02:42:51PM +0000, Josef Bacik wrote:
> mremap() can return the new address although the old range is still mapped,
> which leaves the caller with a VMA it does not know about.

But this is established behaviour and a trade-off, e.g. 'the unmap failed, just
get accounts right' in unmap_source_vma().

So all you're left with is an unexpected MREMAP_DONTUNMAP, basically. And only
when the process is doomed where it doesn't matter.

>
> To move a part of a VMA, that part has to be split off, and this is left to
> the unmap at the end of the move. If the split fails there, the page tables
> have moved already and there is nothing to go back to. unmap_source_vma()
> returns void, so move_vma() reports success.

But it can't fail there as we already did all the checks ahead of time.

>
> This was reproduced with fault injection, by failing each allocation of

Yes, of course :)

> such an mremap() in turn. Anonymous and shmem mappings hit it at 2 to 7 of
> 7 to 13 allocations, with numbers that differ from boot to boot, and no
> longer hit it with this patch.

The only way it can happen in reality is huge memory pressure + a fatal signal +
bad luck on timing.

And at that point the process is going to die anyway, so it doesn't matter.

>
> Fix by splitting the source VMA in prep_move_vma() whenever it is going to
> be unmapped, so that a failed split is reported before anything has moved.

No, this is a big cost for no real-world benefit. Now any kind of failure
results in an unwanted pre-split.

This is more likely to screw people up than rather pointlessly trying to do a
favour for a doomed process.

> An old size of 0 unmaps nothing and does not split. If a later step fails,
> the VMA stays split, as it does after a munmap() that fails half way. The
> unmap at the end can still fail in its allocations, or if copy_vma() has
> merged the range and it has to be split again.
>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

So yeah, overall, I don't think we want this patch.

It's not really accomplishing anything that matters in reality, adds a bunch of
complexity and causes pain for normal users.

So please drop this one thanks :)

--
Cheers, Lorenzo

