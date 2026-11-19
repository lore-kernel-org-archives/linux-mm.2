Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF8B760A380C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 16:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g9N1ef6P
Received: by kanga.kvack.org (Postfix)
	id 805C06B0645; Thu, 19 Nov 2026 11:49:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B5F76B0666; Thu, 19 Nov 2026 11:49:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CDEB6B0646; Thu, 19 Nov 2026 11:49:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 47CB56B06BF
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 11:49:55 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8EA0C40B49
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 16:49:54 +0000 (UTC)
X-FDA: 85452455508.05.7FCEDFE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id E1CB22000C
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 16:49:52 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g9N1ef6P;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795106993;
	b=ATHHQQRGHUbNnleyuo45CqhoRANrY1hxTwdOvdduPCu/ZczG/VSgCrraaY5zpcys9fuGHS
	SY6oxtCqhEPfp6eOmybd0P3uAH/HQNTuACc6MD9laQJ+sYTuHwB9rjG+TkiU0a3SVBtp1B
	RsXE1a+ULV9KmeYOazDb2GcGfckA524=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795106993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cgnUywPdHuklLyoXY2ufjz/z54I9DR8+HzA9HduEBDs=;
	b=2fm9N1KVm6hvKEMw3KIXCtYbpMHKjXKpr+EmY1T9gSxRPNpZLFULVYua9E87/vX6Z0iFzc
	VYaLHmZCBWqAkVz+sScgwBYV5NMC7zv6MwNTFOY4fmXojqym9pq008s65ZoblpEWrdXiP8
	sHg2Q7b0wkhAujEkqFaCAkaJfjeljpU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g9N1ef6P;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1068E43BC2;
	Thu, 19 Nov 2026 16:49:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FA641F000C7;
	Thu, 19 Nov 2026 16:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795106991;
	bh=cgnUywPdHuklLyoXY2ufjz/z54I9DR8+HzA9HduEBDs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=g9N1ef6P2doS1PmgxYW7xGRRWTQXbFbNonLn68nycyaWZIBtK3gotAxU4mRwstTdL
	 im4muFFNLYMyrJd9KM42RplnWdlQpT5UEaVj+5bBLxeMtQ2DpkusiicPmTZb0eP6P8
	 fBL0P23yEa9RCntOvgiW7l05z7Kt8SO2ObOBDKMLIDIZqtXdb0KkP1oMF5QrGbIVVt
	 ampVZE3Bpsvddh/ZAa3nrLOV6EDdn28kFhb48C6zHH/YGHTI/Q3kFh9MLhNfIhesb+
	 FC/8c+2uzMNimXuvN1CxQeBp6FqL/ZDVwqkzvD71HPd+VBBqWhyWYtnA24+f4ND3nk
	 x9BdadIfCrsng==
From: David Hildenbrand <david@kernel.org>
To: Hugh Dickins <hughd@google.com>, David Hildenbrand <david@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 Hongfu Li <hongfu.li@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Hongfu Li <lihongfu@kylinos.cn>
In-Reply-To: <20261119-for-memfd-v2-1-59f2d8c9752d@kylinos.cn>
References: <20261119-for-memfd-v2-1-59f2d8c9752d@kylinos.cn>
Subject: Re: [PATCH v2] mm/memfd: drop redundant hugetlb allocation mask
 narrowing
Message-Id: <179510698892.3387.5467712392240271132.b4-ty@b4>
Date: Thu, 19 Nov 2026 17:49:48 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Rspamd-Queue-Id: E1CB22000C
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: hp8wp1xfqnps4hkwhqagtgo6ign17r7r
X-Rspamd-Server: rspam10
X-HE-Tag: 1795106992-856412
X-HE-Meta: U2FsdGVkX1/2UTZodbm3hBTldjhLLf4oXIYi8iNjvOTObXOtbfLSJnxb7P7a0BfZETGmQ4VJSxGSxCaAGXNruf1U854G4BZyydyE7cKncSfw+f4W4A8JZgnQXV7Z+aH6MhwDRKap5JEj94LrclBN19B8tfOSbXS8eAnPoJrGtwpOnGWHgVYWtx6bRl0aEMBheEKKiKk1jh7DnwPsizMbQwIjtSETg2jmrUV+u1tYA+FI+eU3djGOOBT8OJ+TNozz14XjT1eCzQQMTrhvvM72qINzFmsncvwIcj6J40QfPuZ3ToVX/p0G6kxzqxrol4HIEz8UedcFVKXBOrTlbpY6VBf/Odys5RgSbPguU/rZv87ClCCZcpTS7iCzsFIWMW370DDPbIVKuQxEHI0xOJ3AsCbUdl1bCw1+KjFXSIb/jOLi9986UhGmFsyi5GITKMV8mEvj67R+K9i9+4QsRI0ziPDW7S3Q437liwudyEBi7OGqZjqu5YDflphuJTItD4xt3o0CaQDQ+Gq5aTj0vZXpoU1eqRk1FyoOpZcMEjmLT2lD5KMIcKTlE5YnIl6NhmhsukuNMbJ+qsajlY69nQDkKJkD/4AkeODzxEi8+hJXVqcTorO5cFO6qXZnxmrlRrCl+fPI4Eglo6HR+xZaftFygcHwRJLIz5FHdb13UBQQKxgCWSJXUjpG+typ/RhgHNaAYPh9IUkeih3ikwjAUwWrNDyH7DbTNxFEwnoHMcMvbPFDsOrFlTgmJlyF3dfcI2XNY0qwxgxZdWhrEs9KfcNoS63cpGuR33RyMyhNK3u3fCqaZC/7CqIq/pmryO9usiYRKMqSG8WwBHL5kiCMrNKvdvbu0HS3Y/F27N5a+M0b4CdEbw+p+Vcx4LjuAL5A76yRci7Q9DptpFq5TeNWZraEHmwHXussh1eKdNwdPASZQeY6D46kiADOhvW6EjFBDOK1VbI8UeHzSMaJjbzPe1d
 Ly0sewfg
 XFRG0q/19qM1jRFVxJE9I9p4g9aR4s2RxywV7Egf1F1zsmeWsQbEPxr4z6lMXr+U0VEBA+rDeyoQpXVPEC3SWtZ8JJ4UFxLTx+ycNAuI413rOtOgkN9IfCE1+4HyGY5xn9oLL7v1cEEqRaopljgphmWUTyRAlhtz+LqBQRCAInfAVII4eGjNlBWirxl6tI6VE+rg9WYA8SR/To0w7ATgQ8oeURcRs1sLMToNQI/fR+W3l5s/9YpJYrOG5RfqCx3Mq0qL1Oym4iio5Vlh1IXKlliDSSYx2GxreJGMTu/X5yUTVt6VKROh2qkrdkE3fe3Emu2yOvEx2ht83g5RP6YBzRmLKgME0v29Y9jY2LFKPoD+8FJh5zcN27KVgC7krnaIhSXgmnYMNLSlElB4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 19 Nov 2026 17:49:45 +0800, Hongfu Li wrote:
> memfd_alloc_folio() derives its allocation mask from htlb_alloc_mask()
> and then clears __GFP_HIGHMEM and __GFP_MOVABLE. This mask handling was
> introduced by commit 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios()
> for pinning memfd folios"), when the fallback path in
> alloc_hugetlb_folio_nodemask() could still call
> alloc_migrate_hugetlb_folio() and reach the buddy allocator, so the mask
> decided the zone and migratetype of freshly allocated pages.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: shmem-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/1] mm/memfd: drop redundant hugetlb allocation mask narrowing
      https://git.kernel.org/mm/core/c/b2f133fb

-- 
Cheers,

David


