Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09488FED3C3
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 12:54:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 379E16B009E; Fri, 24 Apr 2026 08:54:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32B206B00A4; Fri, 24 Apr 2026 08:54:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21A986B00A6; Fri, 24 Apr 2026 08:54:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0BDF26B009E
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 08:54:24 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9FF7B1A0167
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:54:23 +0000 (UTC)
X-FDA: 84693442806.10.3B50AAB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id D6989180008
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:54:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tb+TBMi1;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777035261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oiD7MDVH4lzADkp8xadkfQ1Y1hNPTBi0mXKT3b+URDQ=;
	b=aST7XURc0AAqhVXB/+AIMeqTK7Y+33pV1rGjlrZL//C5f2lFebSWdL/E1Ix3fmK4LkuYPj
	rHG3xSL/4CVyaBHTIxtxG0oTyx9RIpAbOwbR2QV6in6g+923iz0QcDlaJTM4M5sER4ShCK
	6YkOTXHoelKGzAeJ+5ZPl96kZUlyny0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tb+TBMi1;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777035261; a=rsa-sha256;
	cv=none;
	b=G5sWhiyqX2e0ccg0nOzTiJcwQAMbnmf+mbnKq7jJvsitxsylDDHlp0ugWW6z5lS26t6a9D
	uJPzPMJXe9mQlTSqMfrylowDVuLQVRz/pFXZ0b82if5Gc7sbTdRoAxZKoqmou4TQScIpPu
	i41S1RBS0bOsHXvmvBeNuWr+CalLgSg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 263CA60132;
	Fri, 24 Apr 2026 12:54:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F4FBC19425;
	Fri, 24 Apr 2026 12:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777035260;
	bh=4un0AvoUA+zLuhMb6+AyLNGwgmWdLWkPi6NVYswIZ80=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tb+TBMi1jFQtKruV0mazW23XvhWz95tKb+MHlI1XunrIZWMwTL6vFacr28CB/ZUBl
	 Ku6DP5vY9utRnL7Kj2hWoZr12wMlYHV2faKXC2J16c7XmPT6JlnvhmrFOpnyI6wYFS
	 LJ7S1J9dlVsIR4jL0eqz8w1e+GKtxC+Nr59+ynZH9S348LkkbJGM1RnPCgtUYmNhyI
	 yeK5ZXSsQGgLw5JOYD+LZPWJoCs7Z29irMSDFfF3KI/MACi9Cu0ayo9e6mC+Dup/XH
	 OQJq4UMuGKoWR/0Ax5FaMmfum2c2FQUNygcnGrQOMPiz0ZyncHrWHc3RivHAL7D1mR
	 zQizA7rigd3hQ==
Message-ID: <896b3956-3cdc-48b5-a0a0-a3ec35aefa07@kernel.org>
Date: Fri, 24 Apr 2026 14:54:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v4 09/12] mm/truncate: use folio_split() in
 truncate_inode_partial_folio()
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Lorenzo Stoakes <ljs@kernel.org>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260424024915.28758-1-ziy@nvidia.com>
 <20260424024915.28758-10-ziy@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260424024915.28758-10-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D6989180008
X-Stat-Signature: 38xdcutijy77wwxwmctnygdqs4hgm1we
X-Rspam-User: 
X-HE-Tag: 1777035261-116488
X-HE-Meta: U2FsdGVkX1+sAkTbIxzPkso3teoj1ZjcWHSJKk3OZ/LkrhrbhRy0y4R4fxLr6rzmUWCizaCxbpXVSQcUDprr1d1l0oFZlr3s+B01hBOCuabkwrcwNWcOL/MjkHQSlUFf6TEAf3DBugk1pYlJ1B3Mdc6uj2wz8dFez6xbpD1wOSMy0d17EiIIBS9KUYtgJsy16iAV/ZQxhIvF4/J6hvLCHi+0rXuIhqWYqnEPGmp8a7LINzhKnKEgu2ro+ceDeHYatdmqx9vuhnXiuqFgxfT6kfed6canf/8BQ2zIDyWks3SXDYSutP8776S0frTUsEvXCSwyPrleTmqtQ/LEGIIF+AVFzLybl9ZAsdQC2MsdgPHYpIn4D8qYZUnN+lhIBsD3MwSzpEab16Cc1C7fO5qwYDB2IjDeGg0K/rhXgNJ52ic4DvP3RIW7SUYTN9wJSKxVbuI13SCtGrDyQ0hGdd3v1gk7Hep7bhQM1BonXVif31CVlqObhDxrr9SlqIxa/moUE+Y19Q8C7OMk3tJT4KdsjeJPgvX8bvApdIz27+RdmaOxgOZuFCwHu3ug/xwvy9U+oD9vqWreGsPCKABQnx4meSYS+xsVdBG3SsTjxrAzel/053aVponrw2julc5ojX0b+tgxjzBj5poljUaRuGc/5lWa++NkUIihPtK3u3P2QTDchRmNeaUtbsaU+WwIJ4oi14lpzN7Z8sUgQLQPMZc5GANtf1poksvigMoeBEmmpwAWkYdWl/NQfSpgx517eH7bqzJYktDguycuLHmMiLuPFo7O3VvNihUV7Fu+0tM/TlDXTe4swh3etvZ99Z1G+qE6zdv3L9m9U6c1zd3aGP+T0aCE+1uxwjL0ugkhTPfnI6JgSMhUJsIWd4ExQhFywN5WPTM5WL2gsaD2MkIh82rZKuG2T5VHLUQP7e5gpZyIZpmPzKZAQkWI1mBiGs6TbGMStIxI/P70eP5Cx8wrskh
 BhqMGsgr
 t3yr1ocDOP5Fz1GXd3mHpOw8dBioqg9akNH+yMFuy1aGZOE8i/qCTzrbiktUjHRaMD0s8yTGf+n/lmnbhGQz2xugIoAtZFgG9uUv9zsIN903Ad6UTJad5/afDvyXiepWupgN4xcfWpMggMz37YnNf24xOXEpbAr5Ul8ITwduDF9kssUGxTBK8YHxFgRqAzYuwC0JGQLyoTiqunVTqVUBzjixvSMRDMapwz3aLIdYxS4+V2VaIby7dMvirqnvteX59M+AoOH16sqm/ncPy1VN4r/+5JQ1k0mViJRLYFux9xGYgxFWLEtk2W7Bcn2/MAmBKfk9g5Xq19+/c/iQ0OMMfnHKG0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/24/26 04:49, Zi Yan wrote:
> After READ_ONLY_THP_FOR_FS is removed, FS either supports large folio or
> not. folio_split() can be used on a FS with large folio support without
> worrying about getting a THP on a FS without large folio support.
> 
> When READ_ONLY_THP_FOR_FS was present, a PMD large pagecache folio can
> appear in a FS without large folio support after khugepaged or
> madvise(MADV_COLLAPSE) creates it. During truncate_inode_partial_folio(),
> such a PMD large pagecache folio is split and if the FS does not support
> large folio, it needs to be split to order-0 ones and could not be split
> non uniformly to ones with various orders. try_folio_split_to_order() was
> added to handle this situation by checking folio_check_splittable(...,
> SPLIT_TYPE_NON_UNIFORM) to detect if the large folio is created due to
> READ_ONLY_THP_FOR_FS and the FS does not support large folio. Now
> READ_ONLY_THP_FOR_FS is removed, all large pagecache folios are created
> with FSes supporting large folio, this function is no longer needed and all
> large pagecache folios can be split non uniformly.

In general looks good. Just one question:

folio_check_splittable() also rejects SPLIT_TYPE_NON_UNIFORM / new_order for
swapcache pages.

It's confusing, but truncate would never stumble over such folios, correct?

-- 
Cheers,

David

