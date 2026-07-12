Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF464C43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 07:12:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FAFE6B0005; Sun, 12 Jul 2026 03:12:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D25B6B0088; Sun, 12 Jul 2026 03:12:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EB1F6B008A; Sun, 12 Jul 2026 03:12:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6A4A46B0005
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 03:12:35 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E0DA5C54AE
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 07:12:34 +0000 (UTC)
X-FDA: 84979256628.28.AF87CD6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 16AE140004
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 07:12:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=En5tPSqw;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783840353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tpvt6EUERrPYZS7ccCTbDt56ATJBy7ak6+GhKYojzk8=;
	b=xTolGNACfanLYAu8/gAQoWWfv+gbQkxNpahiXFs1sUEjybrucWc4wwNDqwZ9MwCTyhnHU2
	7eJjOQUUdD5O9x5XabNswoOsmidRFX+hwhP94UR0DHu8hyETwnswgNQNql4sfAFcoW+5vu
	V1XG6uJQ4f0bDdRvu/a1NOvGv4M8TBw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=En5tPSqw;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783840353;
	b=RcKs5W5hmw7jVEOdkz+oXofPrk+ZDsrlBUxs9GwvnDSzCh+j0/HCBvGCFRbOxyYDWa2rtH
	8lwgV4DWT/4Qz+qKVA+NFK0s/fR6SlCtAJsZImdaedjTTAVdSrjGbpsDQutwxNq49QnBAl
	xgVrIXAkRVm4DqVTE/8DgUirZ+uE5xg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DDF32424BD;
	Sun, 12 Jul 2026 07:12:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A7FC1F000E9;
	Sun, 12 Jul 2026 07:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783840351;
	bh=Tpvt6EUERrPYZS7ccCTbDt56ATJBy7ak6+GhKYojzk8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=En5tPSqw1Mre1BipmFeL1T0ps63smtlA2dNlL24BxEx+sWM2i/t5uRUJRbvS3ZUZG
	 PPe0HZC38SnbxTFwsR8Fh+IiBOxH0MeV2SoSpL0n9nCdU+KTRiGXJ9IAXb3xUQoxQU
	 TyqI9pwTlStRkhdoKw1kuBcAmecaRjITTXftzwN8=
Date: Sun, 12 Jul 2026 00:12:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, muchun.song@linux.dev
Subject: Re: [PATCH] selftests/mm: remove obsolete hugetlb vmemmap test
Message-Id: <20260712001230.5c3491ee33460c98bef8c22a@linux-foundation.org>
In-Reply-To: <20260710092427.3459121-1-songmuchun@bytedance.com>
References: <20260710092427.3459121-1-songmuchun@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 16AE140004
X-Stat-Signature: af4rskx4e7dpw3nnfje8ugijmymz3uuq
X-Rspam-User: 
X-HE-Tag: 1783840352-377415
X-HE-Meta: U2FsdGVkX19v0W0hxO61t7o4jVJczJt1nGF8AeOD2bMxM+dR6O3cEGi9qY7NoJ7HdSMnG7C7Zv9JyX9lzbmjVyxNytQQf7gQSKmreiHnMnMVAbunyszvNENnT7t8LEavIejvvx+4rDsox/Lnbw2hrP044f5U0twqFhkLxOE+nexuXAZtFKTjkCf7z1hYqGUU47D5UOZ1OVm6MzGGA3ZDR6DQ28aBfWrSgzDLsXR0wF9lptlQcc5dpfDBWAafiXs2Pm9CC9bq2ytGtYm+kpeZkMVA1CR7oT3V0utXGxCxeRaoZEq05KXDiz+TjMF1272hODjEDZQbo5jBjajp68PyzrwpbJ6LAvjqwNyT+VlaO8usMxTDhSLRphjV7lMD8fJHyUNawTKXkqZctIRiJlOeXYv0m1ZDnoQnDUpcCK99gqRCwN3f1UKO5k0eMpGKIs1fsVZoLw7HJGLb13dhcxnzVM+y86cnII2tSon+WqlH3BimSJ5IjUiT2M3w4ah2PixAquiEV+XfWhuHL6ya1R8rky4yVhTjEnTMsggUMTZBJ8qZLPy30135NZEb3F1NWcKTh9sf4NuUMX7mzLvPB3OKdyY1h453E2nYu7AvVp3l/QmSKPZhbwFdCgzMyAjghSw0IKv8Ncn9A0lPNprsa2W+p/aHW1TgODaxzZVnyghVcXa8HdfE5j+A71+m6w0ANyFie4sNT/Yz6E3yNzmQEtBH5xbb8YnZ4OuAj5wTUnalJ6LDGUkw+LRXWiUD1xdu7MKp1gxiUrDvfe3AeP6Yyw0ZYAJrerL7+C6VpP8+foHLFe7Bzp8d02JRqpLOIVxJYRUaChuyprnWY3LZMNvNVAJ27MBf/crIlRI6of/VSXS4kzQXqoNkkTeXD4y7ZZvb2VSlnSnKStXhrauQThX09RsBYsdPrTWjNlUC9g9wEC8ExZLpMDe3u6cTLw/roCJWmYmE9Gqdrs3itb6KeFhk4Zb
 2tYMBqoj
 v1onEdnrgw8NtEVJ74jO1Psn+xp377yAtK4I/SCvU1YRlzMzvEVlZKiCyPQ76e8lrbDWXmvdFatdD11dV6WtnqXOEvwr9bR+zYx0BMq0AEE90VaHuCeTHZheEZWL5r0a323jXAYPNOiDfeDbt2fZUah2+TUnEuuzuoQsGh8ilaBCYxalv24rkgzLctsYmrxG426UdyYJiZyvppuoFLvdq8G0nuFPSTuUh8OZUI2Tvv4QoiFKQxxxVYWCBWFg0S0UdMK+PqAMm/ERWjwVGB11mMFZyRy6OB5evG3tQiUGWv3y2AgIrzGrmICAk3t5FbUm3Xt3qopLKDBjSZNk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Jul 2026 17:24:27 +0800 Muchun Song <songmuchun@bytedance.com> wrote:

> The hugetlb vmemmap selftest was added to check the old HVO
> layout where tail vmemmap pages reused the head page.  That
> assumption no longer matches the current HVO mapping layout.
> 
> HVO now keeps a private backing page for the head vmemmap page
> and remaps redundant tail vmemmap pages to a shared read-only
> backing page.  The old page flag check is therefore testing an
> obsolete implementation detail rather than the current ABI or
> behavior.
> 
> Remove the stale test and its build, run, and ignore entries.
> 
> ...
>
> --- a/tools/testing/selftests/mm/.gitignore
> +++ b/tools/testing/selftests/mm/.gitignore
> @@ -3,11 +3,9 @@ cow
>  hugepage-mmap
>  hugepage-mremap
>  hugepage-shm
> -hugepage-vmemmap
>  hugetlb-mmap
>  hugetlb-mremap
>  hugetlb-shm
> -hugetlb-vmemmap
>  hugetlb-madvise
>  hugetlb-read-hwpoison
>  hugetlb-soft-offline

We should leave these .gitignore entries in place.  Please see
https://lore.kernel.org/CAHk-=wiHK5_oBUdUiNAaevmN9f-ORe+QBqbRefAZaw-RbgEn3w@mail.gmail.com

I'll queue a -fix for this.



