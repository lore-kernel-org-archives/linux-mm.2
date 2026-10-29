Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC7C8606A324
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 21:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PjDnZcPZ
Received: by kanga.kvack.org (Postfix)
	id 092236B05B2; Thu, 29 Oct 2026 17:16:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0697D6B05B3; Thu, 29 Oct 2026 17:16:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC2166B05B6; Thu, 29 Oct 2026 17:16:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C664A6B05B2
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 17:16:12 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5585D40537
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 21:16:12 +0000 (UTC)
X-FDA: 85376921784.12.B0C2419
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6B99818000C
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 21:16:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PjDnZcPZ;
	spf=pass (imf24.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793308570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7HPc+rMGPZrFziNDFBiRAZO+y0q2SHxYTSQY6vu6qns=;
	b=W95Nvb7BI8goXSgpEU/jaoKw8OnpETt2dOIc6N8irzK3Jl8GNFZsG/P/M5GTWNX3iqLu2y
	x330P2ewtr1uqqMa8R4QBC7g3FNhW/FBMZyWcMMrGxrIjrG/JbiCsFVt7r6zGAPlUqFihL
	J47QkfsTLZKk5OGkgPZNe7z1tj7AY5w=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PjDnZcPZ;
	spf=pass (imf24.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793308570;
	b=WYBV/YvIXRUTwccYw+vtHdfGzCLrGrALgCn7RmLfMtIB3cZFeGSb5J4xgbLkVVD1NCZiN3
	TCu4R+bYX1ZBZNhKocBzSyZhXdOx4pDD/WxKxwCKgXC0csgWeS4U/Qrw/WbtbNzUt9q4xm
	VWdpH0XB1PBn6IP+rch4FaYRXGH71LA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9DF1443C9B
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 21:16:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8079F1F01825
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 21:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793308569;
	bh=7HPc+rMGPZrFziNDFBiRAZO+y0q2SHxYTSQY6vu6qns=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=PjDnZcPZxZwSTafleHkQ33qoE1Iuzoz2P4Lz8aFvP1ktGboBUmwwCpmJod7gkifqi
	 UPVZRyMr1VAJqQMrSBjmm/PpoYC95+h2DT0sPQseKt9K2skglmTtJIeHDZrDqYsFql
	 DJi6xLqFr6KOzLghr4zOFoVaTFJw4WKbB5tEiITuISFC5NPqCFMEUZTBWlmzEvTY2L
	 zOKT9TJS9GCHwlzdz3OQ/FM2PwUfSAPwjB3tMt2V13N7Usm7MWLdriZyz1+KphdaYf
	 WZ5Y2Q+Dth22arg1Sm1R0bs6PBrf7xW4y2619gL8G46/b6ycZKMSA9b+eZvuqbcRDA
	 KthZ/+i63KBGg==
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6a642495d81so14481a12.2
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:16:09 -0700 (PDT)
X-Gm-Message-State: AFq9FYIQD3ErBemUW3wrnwXaVUJNNwlONmAxWiRSx8s5ZheCLT1I8bpm
	uxz/EB6fX4+NfevHr+3bmiyi6/B51JtfqH6orB0zUtqhJG/fOiXHGxFJaphVacvw8hgX82kOqJ0
	9+kSNW8hX9VPVykeRtxSPzqXiRMaKQ+k=
X-Received: by 2002:a17:907:3d89:b0:c46:645f:cedf with SMTP id
 a640c23a62f3a-c4ca7a0708amr27430266b.15.1793308568498; Thu, 29 Oct 2026
 14:16:08 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261030-swap-fixes-v1-0-73f73a59f2fc@tencent.com> <20261030-swap-fixes-v1-1-73f73a59f2fc@tencent.com>
In-Reply-To: <20261030-swap-fixes-v1-1-73f73a59f2fc@tencent.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 29 Oct 2026 14:15:56 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOwqiCzqGP_eh0Po+0cHSCLC-T1xoFqEo9bC0A2z9V-yw@mail.gmail.com>
X-Gm-Features: AclHuK_UcWeTFbGNfIrkG08As9JrhrqrnG737h-qpITyGjdoPDrLwmIQ1HgUGbk
Message-ID: <CAO9r8zOwqiCzqGP_eh0Po+0cHSCLC-T1xoFqEo9bC0A2z9V-yw@mail.gmail.com>
Subject: Re: [PATCH 1/3] mm/zswap: drop the stale zswap entry of a zero folio
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Usama Arif <usamaarif642@gmail.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Chuanhua Han <hanchuanhua@oppo.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Mani Tofigh <mt4022@columbia.edu>, linux-kernel@vger.kernel.org, 
	Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6B99818000C
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 1bpdzfijf466f984bswr1ugngpd3nfb9
X-HE-Tag: 1793308570-396302
X-HE-Meta: U2FsdGVkX19uB0reYtNoRJ2WmTPwienjPzehYlHVBd5hycLbcWmHeU3B2o1ce1lKxEpmohNTCEic1kXJC1kHLnK1aHMjcNGL3I6W0RzU+hxBW942+HtxgHVztbOAG7o/U36b56v1Y8BqEl5hMWgMUSIXW5oSxQUaWdvS1xSP62P/XFAQ3IAtd9JrOw0vJblj8KzupBHwRYtZOxNvN+ZBp0N61DSjDHdLhSaEr/F/W+DN6TvDLQnfU99ZsvQC5Tsfhh3dEqWV+VNjTFWigkyMb5vmUzp6it6bWxUBwXnVNJk5fVJdUcZm+8aGoiekPsZs0vJvvbuKqHURUlwRE5myprG7njp/OeqzOw96zbo0e+0lP6tnRWL5cS0nOOaBJs5g4Q1lK6iWt8F42ciRA4H9n534HkIQkN2YRT5MWqByHp3n47fNGdy4RX0xenPCEX1Sy8AuG6K/lCh9+Gr+o34/BJUu0A4lwvlWdvvzpM97fohETe75X2/BCJjufT63+NQXil6TBf+D6rZJ4fhI+Q9XTZozJjFXlBxxO8YocPlURdxZJB7iyIqvJynPkVwwJ40RGOC87tieZOethXYVvODJ8VNZQeaw4rS910x3p4SNmmRmJ5TZo1ZazfOt8xEpuNxSOoXDgNPdOM0bLwlRn2QLbFmWiVFUdLna4fuzHV2nGrm3uvk7wc+Ya/SqqtM7Wbn0y8Qzm40yXyU0mZKlTnZ5pJDarUnW1lm/cv31327yUZ7TfPAbrZiWmEDAzLIgmoi0K+cAvkQl/Hrj94gsZsjOXuXQtgtpf7wp/5808Lmy85r92EhKWTdseUwkzumouytaL8sYQbznSB6iHrp/SYrPEKCaltVHikmO0eY/PBf5uzZ8SLEYA2EE3dMqoRBY/99WwvOrVibinwCaTw23kOGFcDn6JmX6XXtBdrA6UvKP50+3gILMhfZnY3sLY6sfSmdAiTjWlIHmo4M1EfNmRcl
 czTHAl+u
 6EEXe63C9UBPk2gvyH7oOpivne2fK9cGHiWmcmTjdzJKVLKQwl0oRLmV3EakT9I3A8zrrIUnlSgoIoQh5BrLOF06dgmBKy+XuJhFzMDTdGxnZ6QelrmDJBQ5qvoyAPgkb3VA4UuwVPW8B65P7cUTkYTP00e4S6MiWr9gx8Ka5RM+9+lkPpS3/ETPGH+AHbN3TuylGvPIiXefaz05mBn3ILNNoXLnpwWbB7GsHt4ix2uNxMlMGcND+SrY9I5DlbgcnHxZpdjbgXGPCKJ7kv9A5p76hdJ0bKK7vULs1MS3bY7bReVzOmQ3peLHAL+deAf42pGB9ZPe7TpGAHSVoDyQj/HjjntCIifoLy7YK9DI+gekNsjzQ8LioV4qnTzueE/HdDrN1vMbkjnT+vbM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 11:32=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Josef Bacik <josef@toxicpanda.com>
>
> A folio can stay in the swap cache after zswap_store() has stored it,
> when a swapin fault gets a reference on it before reclaim can remove it.
> do_swap_page() maps an exclusive folio writable and, for a read fault,
> keeps it in the swap cache, so it can be modified and swapped out again
> to the same slot. zswap_store() handles this, it replaces the old entry,
> or drops it if the store fails or zswap got disabled, "otherwise,
> writeback could overwrite the new data in the swapfile".
>
> swap_writeout() does not get as far as zswap_store() if the folio is
> zero-filled now. It only sets the zero flag of the slot, and the zswap
> entry with the previous contents stays in the tree and on the LRU:
>
>   reclaim            fault              zswap shrinker
>   zswap_store(D1)
>                      swap cache hit,
>                      map, write zeroes
>   swap_writeout()
>     zero flag set
>   folio reclaimed
>                                         zswap_writeback_entry()
>                                           swap_cache_alloc_folio()
>                                           decompress D1, uptodate
>                      swap cache hit:
>                      maps D1
>
> Swapin looks at the zero flag first, but only when it has to read the
> folio. The folio that zswap writeback leaves in the swap cache is up to
> date as far as anybody can tell, so the process gets its old data back
> instead of the zeroes it has written, until that folio is reclaimed.
>
> Invalidate the zswap entries in the zero-filled case as well. The folio
> is locked and in the swap cache, which keeps zswap writeback away.
>
> Fixes: 0ca0c24e3211 ("mm: store zero pages to be swapped out in a bitmap"=
)
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> [kasong@tencent.com: fix zswap_invalidate() arguments]
> Signed-off-by: Kairui Song <kasong@tencent.com>

Reviewed-by: Yosry Ahmed <yosry@kernel.org>

