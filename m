Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC35AC79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 17:09:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E840B6B0092; Mon,  7 Sep 2026 13:08:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E35166B0095; Mon,  7 Sep 2026 13:08:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D23A96B0098; Mon,  7 Sep 2026 13:08:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A77B36B0092
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:08:59 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 442941601F3
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:08:59 +0000 (UTC)
X-FDA: 85187601198.09.EDC80F4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4D886100007
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:08:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aoskVabW;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788800937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j7x/51HwsP9l6I4L2UsRVOYC9hBKf+rW1hZb9VZ+8mk=;
	b=OyyD0RI/GLCeztznu6E3A8J3/ofSV7Pskx0Rpcf/mkxxFaTgnqW8TfpqJ/RrMEARcsX3hQ
	29feW2cwhYVEmbDp+RS55DRHaABcQO3lLjuR6SZ6Sre7b0iDKE5KKx11z9cX+nOXSkirNH
	B00gpVEwxEGiKuvKTWB7VW7ZZJbeRgY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788800937;
	b=c89HjQpRbE5ZfismysXxUDLRdCQas+rv6M11m0DT5fBkq/f5d3zqE3CJeUbcI9wFVYj+tg
	6raCV9SalnBdUVw9g4NhhUfgxQ1QQt4iTAwH2+MsdjI2tqWpLHsJkcpyR2JDjfnXT7Nrz6
	zVhk+HPeEwZrnjr+w7HWzlRjSoB+sjc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aoskVabW;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1B5C74368F;
	Mon,  7 Sep 2026 17:08:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30AAE1F00A3A;
	Mon,  7 Sep 2026 17:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788800936;
	bh=j7x/51HwsP9l6I4L2UsRVOYC9hBKf+rW1hZb9VZ+8mk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=aoskVabW49we9m61if+yG80C3wtGQ69YtOvFI7mW0eoHdMIHHFnJ3qaxHEKq0LFHS
	 5MN11lbxi667fu1q0kWnrr2xojlZU6Pjj9shKb0acrAX/MqY47KHdVM2WKpQkEsEYD
	 rROTjv/GJeFU9O5ZZOhJqZ9cRg/LjWupTnHG/Kh0LbkCx9e2FYQdVVS4toYaMSfJPN
	 retSexSkntzEcSaWZjSrYBmj1cWP90KvFbE8LenDGr3jPKFad9FqK6Bsfu/aM/hQ1G
	 yo5nqG2djiu7I6W/APCdjcIAMBkZZSEhKJFQOWudMlP9DXUkR9N1NzbG9Rc1Vb0Xlk
	 QefYvOkesgvbA==
Message-ID: <42c1b1be-d176-45fd-b467-464b5b87e116@kernel.org>
Date: Mon, 7 Sep 2026 19:08:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] tools/testing/selftests/mm: add MAP_PRIVATE-/dev/zero
 merge tests
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20260902-map-private-dev-zero-v1-0-a578c730cec7@kernel.org>
 <20260902-map-private-dev-zero-v1-6-a578c730cec7@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260902-map-private-dev-zero-v1-6-a578c730cec7@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4D886100007
X-Stat-Signature: om5eu74b44q3rtakyufths1aympx575g
X-HE-Tag: 1788800937-691632
X-HE-Meta: U2FsdGVkX1/Vest5JMuA/u35qIQzpl7b5gO7UXHuMbcameOriwfMxNgxtdSKeVJBQ0YLlkjbFMzS3BFgO58cQ7u0FRvDrdKsUxGRuasgW/5rr+E/3ZRy+MW+18W6nDuz+CKFEDBKO49y8TEQE/HxyFcSoIbQSqBBrASlU5naCElnQqgsyvW6GGaApa4qjpBc/LDyCkaSuQdKMTlawOfMSWc6D6m+/B2nKpQTYe3UGU01BLh8XNdfSg11mPHeJ09+A1o8EpmyEeYFTrFhevt3V0rG1lfWC1gRJ7YfYBBtgKg4XJSsUeubsvVbLsZbG85hv5l7mHyFxf6Q2E1aHZVX3rKhyaiIqLqO2niogy1csAXgn5Bo7hUXe334xZzDLmcOw0GRwm4zW/M1ehO7iEtxbS5zZxYDUGFGeTzBmfnYneUONpii0M2zv/hMFX7fP/1pKPgBEtOWVMR4NIhdYKnbMZeaCstl9Eo6+TFrn5qska5MeXizht8ZXscmWD3TDCp8wTw2u1Ntt5e1K+sSG7S9U8qTwKHcAFnpCjJSbsfwEy/0Hj6wJdH5ic8/tOYaL6NmkbgPO4PzLDdwyjn0TW4yNAmTNXo5LJX1KgqcY+u6Majz+ML49ZBUiZJYqAGBVLLH2eGXkgsm1ycRuUH1F3IKjyCt+ZaIiWNgE5sCGyJs+N83MHPKoLTbLlmiOM+fyCHnQ9sVY2gT6el1GIzdsIjBBCz5mTiJe/XFaQGgVtewjAhr6Pe6hjUbbkcofEk2v2/2wclfxMMGwznx/rU59b7xw1Hnp5MG8Runacriqfa4nuHHckTJsQRlMMiYT8BrCn2jeJt8BqIzpoTpiFwbW9FZlQdhKYwN9HGwouWcxBohd7ss9G/6AglnWOiYu3ZtfWy/RPH0AsN5Sek8t/Qhji1DwsQR6jSFgKmhgSzHwhG1iabcgXXFXq5I90UAVgzQ2vRXa4k4xpubT4nSZiqqIDB
 xoKcY5Un
 V/++UW6FtjH4+0UYsJQVrh2oPicr1MmFKFnG5DO1oGb9DgZKhf7AjKkueI3ieTHrtSYMuiMLuluMdWpiFJTSsAxpr8kxR9Z7YWjJY3OcTbTemgi6HnTpdKTd/rZkF9pYMVOoS9n6U6pAEx6SH8oDQn/fkygttmzQj66NhSY16UvI/PhuZu2S2TUdJMiDfmX/HPxwQe8vYA1oldJDVwOqnMzNuXu+2A90MUKpAX+H5pw4qm2YrbbO3eFpMfpA6TopOZOd6eDOnPkZ2cTmfkGSxDOKAdCLDJ+ut6tfjBYWjUYarwOb8np3ZscflXlfONcG8xtVJhyrmxdqcf7s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/2/26 20:00, Lorenzo Stoakes (ARM) wrote:
> Assert that MAP_PRIVATE-mapped /dev/zero mappings behave like they are
> anonymous.
> 
> We test both unfaulted and faulted/unfaulted merges - each with the regions
> having page offset of 0, which would not merge if the mappings were treated
> as if they were file-backed.
> 
> With the recent change that makes them behave as pure anonymous mappings,
> the merges should succeed as their page offsets are equal to their
> anonymous page offsets.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  tools/testing/selftests/mm/merge.c | 104 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 104 insertions(+)
> 
> diff --git a/tools/testing/selftests/mm/merge.c b/tools/testing/selftests/mm/merge.c
> index 52b8727b6628..7c528d470404 100644
> --- a/tools/testing/selftests/mm/merge.c
> +++ b/tools/testing/selftests/mm/merge.c
> @@ -1362,6 +1362,110 @@ TEST_F(merge, anon_and_page_offset_mismatch_memfd)
>  	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 5 * page_size);
>  }
>  
> +TEST_F(merge, merge_map_private_dev_zero_unfaulted)
> +{
> +	struct procmap_fd *procmap = &self->procmap;
> +	unsigned int page_size = self->page_size;
> +	char *carveout = self->carveout;
> +	char *ptr, *ptr2;
> +	int fd_zero;
> +
> +	if (access("/dev/zero", F_OK))
> +		SKIP(return, "No /dev/zero.");
> +	fd_zero = open("/dev/zero", O_RDWR);
> +	ASSERT_NE(fd_zero, -1);
> +
> +	/*
> +	 * Map two MAP_PRIVATE-/dev/zero VMAs next to one another with offset 0
> +	 * each.
> +	 *
> +	 * With these being made truly anonymous upon mapping, they will
> +	 * merge. If they were file-backed VMAs the page offsets would prevent
> +	 * merge:

Nit: "the" merge? You're the native speaker, so I don't know if what you have is
just correct :)

> +	 *
> +	 * |-----||------|    |-------------|
> +	 * | ptr || ptr2 | -> |     ptr     |
> +	 * |-----||------|    |-------------|
> +	 */
> +	ptr = mmap(carveout, 5 * page_size, PROT_READ | PROT_WRITE,
> +		   MAP_FIXED | MAP_PRIVATE, fd_zero, 0);
> +	if (ptr == MAP_FAILED) {
> +		close(fd_zero);
> +		ASSERT_TRUE(false);
> +	}
> +	ptr2 = mmap(&carveout[5 * page_size], 5 * page_size,
> +		   PROT_READ | PROT_WRITE, MAP_FIXED | MAP_PRIVATE, fd_zero, 0);
> +	if (ptr2 == MAP_FAILED) {
> +		close(fd_zero);

Is the close() really required before the ASSERT?  After all, you're also not
munmap'ing, so I wonder to which degree we have to clean up.

So maybe this could just become a

	ASSERT_NE(ptr2, MAP_FAILED);

Same for ptr above.

You could likely also do

ptr = mmap()
ptr2 = mmap()
close(fd_zero);

ASSERT_NE(ptr, MAP_FAILED);
ASSERT_NE(ptr2, MAP_FAILED);

> +		ASSERT_TRUE(false);
> +	}
> +	close(fd_zero);
> +
> +	/* Assert that they merged. */
> +	ASSERT_TRUE(find_vma_procmap(procmap, ptr));
> +	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr);
> +	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 10 * page_size);
> +}
> +
> +TEST_F(merge, merge_map_private_dev_zero_faulted_unfaulted)
> +{
> +	struct procmap_fd *procmap = &self->procmap;
> +	unsigned int page_size = self->page_size;
> +	char *carveout = self->carveout;
> +	char *ptr, *ptr2;
> +	int fd_zero;
> +
> +	if (access("/dev/zero", F_OK))
> +		SKIP(return, "No /dev/zero.");
> +	fd_zero = open("/dev/zero", O_RDWR);
> +	ASSERT_NE(fd_zero, -1);
> +
> +	/*
> +	 * Map a MAP_PRIVATE mapping of /dev/zero with page offset 0, then fault
> +	 * it in:
> +	 *
> +	 * |-------------------------------|
> +	 * |           faulted             |
> +	 * |-------------------------------|
> +	 */
> +	ptr = mmap(carveout, 15 * page_size, PROT_READ | PROT_WRITE,
> +		   MAP_FIXED | MAP_PRIVATE, fd_zero, 0);
> +	if (ptr == MAP_FAILED) {
> +		close(fd_zero);
> +		ASSERT_TRUE(false);

Same question regarding cleanup requirements. The ASSERT_TRUE(false) looks a bit
odd.

-- 
Cheers,

David

