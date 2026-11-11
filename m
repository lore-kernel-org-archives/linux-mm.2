Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E02F0606A334
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 21:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gsyTtvK+
Received: by kanga.kvack.org (Postfix)
	id 0ACDA6B05B7; Wed, 11 Nov 2026 16:37:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 084BC6B05B8; Wed, 11 Nov 2026 16:37:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDF916B05B9; Wed, 11 Nov 2026 16:37:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB2CB6B05B7
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 16:37:31 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3CACD80410
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 21:37:31 +0000 (UTC)
X-FDA: 85424149902.05.80DCB02
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 67AE91C0007
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 21:37:29 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gsyTtvK+;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794433049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6gjeT2Gi8cfGTOGWEBofK3N5lri6Fh+ybZzjWjQ+1WM=;
	b=vdYCecAMYTZvLgkdeMnevfDeYL5hsXpdAvgeOsmmbtXKkR+tFGFNw0P1a/vI9Yihizes32
	y2OdR17xSVvwHQUmDM28Al9VW8cZaMaS9O398ws30wdSWBRpT/EZTVmezQrYNaakNxaKN2
	jsXhA4/V4z/PufDjL4aAO+jpnQm5WJU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794433049;
	b=ZQCtjz3/EwzmNCMs1q8IGB6DwcAWHVd59vauolxXYxwR8PyfbGvrkd7b+C4FFBBWrjMxjy
	lJHKu+DfVPbuTdA0QOtaG/Qhpuc5ggvRkkDdF8iA4rWj4UzG8v03mDrSypD8KCct2zK/Ld
	nVSAc6PrXWcIZBWyfy/hg+4tu69vWuA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gsyTtvK+;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D91D1630B6;
	Wed, 11 Nov 2026 21:37:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B196E1F00A05;
	Wed, 11 Nov 2026 21:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794433048;
	bh=6gjeT2Gi8cfGTOGWEBofK3N5lri6Fh+ybZzjWjQ+1WM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gsyTtvK+N/jxHzvvUXlTEFxdTkdhvoykYl9xN87NYL8eVELuq8W8SStuQLRw7oQ7O
	 2OPf8vbm1Kab7muSu2s33Ey0gIdi9255YlG86QrQfeH9+Tkhr+6HWKtO0LjgJ6dp+l
	 IsjTaylleg7ITxEvkmldijQogtzXT6VXOh9HB0GlC9r7t4M7qf/h4bKIV5lfex+CQD
	 zrjT1pbqj+zX88miIuufgBljeXw61znVZBzjfqKwhaSbfqjItfnphes4bw9hDKaNP0
	 PM1I5gsQlCPXVu30g7PF47AY8jkfFbVGEX7k21e8gVQeXzxWhb9FzDghYrYYgKoDdv
	 Db1kTJ7cop2jw==
Message-ID: <d652a02e-a637-4b8b-b9ab-13167b30e926@kernel.org>
Date: Wed, 11 Nov 2026 22:37:04 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/9] mm: limit pagecache folio refcount
To: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Song Liu <songliubraving@fb.com>, Rik van Riel <riel@surriel.com>,
 Miklos Szeredi <miklos@szeredi.hu>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Hugh Dickins <hughd@google.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>,
 Kevin Tian <kevin.tian@intel.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>,
 Robin Murphy <robin.murphy@arm.com>,
 Steve Sistare <steven.sistare@oracle.com>, John Hubbard
 <jhubbard@nvidia.com>, "Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
 Josef Bacik <josef@toxicpanda.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Neal Cardwell <ncardwell@google.com>, Kuniyuki Iwashima <kuniyu@google.com>,
 Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 linux-arch@vger.kernel.org, iommu@lists.linux.dev, netdev@vger.kernel.org,
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org
References: <20261110-refcount_overflow_stable-v3-0-318625d63a98@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261110-refcount_overflow_stable-v3-0-318625d63a98@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 6wzhjrdrbdapscktdntr471phnsk13sg
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 67AE91C0007
X-Rspam-User: 
X-HE-Tag: 1794433049-581946
X-HE-Meta: U2FsdGVkX18DGuNr7OdQ8MMD6mgaPfDyQfZ8x6LWjIHCEUHDb/Q4Lk8KLE8h3kXZDze7FR33axTDdi7Sui7dbjDYgUn4Aki5fXrd3iNloNZlyQ/LPWd2ZnTNAG7O2yOGuVMgFdIlLPTgbu9c8TY4PGTJXPPvR93XUTHVtEMK5eCtpzc3zLUMFN/fbzz1KYWalO0Av4a8AYqBwRcFfCQMGfPTMxOm4A/WXIoyi1Uv9aqAXZ6gEHO4mSWjbzEUczbUH4xBEKlHHIaXRt4W/fpABWxx0qUvIf8G4gpaM7bZUaEMWky6dZmPkeTWyKjUEInIBxRWZsvbEDEn5kJ3V4DIb9CWptulXHCbolcaAG/7Q9wvSeWxj5S9pa51495HwEYR0BPLG56uje1ndRykBzeT5J/tXWfVj2jiwT8dTQb8Nby+4n2BIGqIBCA0dvqUYNTNP1LUEyGmveZhWIsEClAu+dEuQViZw8mJw2sfMAGg8TwBUQjaJNYrNECfrhK01bgPlrD3QcBS0ZgmzZpJUn4R8k0cg0NeFD8usbcm/YuwfCzYlMBkVXc3+Q269WeBdMtzdUyH6aDf5DRxVqfbJcwU04JMRVfK1af4SucNTdBDCuZmZrO5vDOq7/p+BB91eFI1bkmQ5MLefiJRUtKfJkc68kWnwTX1FNyD+Y1YhNmSUELKw/WIpYrbkZS23ieQwx0SLLK54BA2+Mogv1SHmCzGjAT9AFd5vRItQuoMhlwdGKrLkKgj5V159aDgFCHIYTsjU2159W7T8GOlz9D/r7X1QCuwMrckhvsD467CtIUIqQCNdgMxb0G3wNPGm5XhYaa0nTTtOv+ldQTZwxKXXoUBpUBjQUpiGj7I1H1LAJhZvn7/O0q4p5OJUirfY4sVB74+iQU0rslc7v9sCLHM29rwIhhkHasu4t/c3JaeaS54kFhqRtjlIZLT3376xB6MNe6EsQpz+gFMxlMq8JhXrKV
 C8YE+m8T
 ODDm4uu381tEoel7APUjAOEjRtv0fGfufnzOfMldqoqZwSmeji8laHuwwuhsFAZGxKxkaU5djWQhc7rckt7qbdt2kl6Kedx9vxn9LEMcu0iqLLv1zbR7fNI9lawsf+/4L4Bz7LzUKGMW5btA1L7GbncWL0HwOIxPAoKIvbO/22Kpwt1MauX4Q5NEjprug7JqYwbRDHR0WmfRfvAIJ7O+ZHbl8vOwseUFixFwDT6HtmyeEfx1tgkrBd+Saewgp5/lqKskcaGxd1YKMcqxivzKr4MUl2cH+oOf+9Ep+TVw1SmpuzPPY4fVuPViMlI8hygVt+KRpSSb4PhCnyF8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/10/26 21:35, David Hildenbrand (Arm) wrote:
> Note: I really would prefer doing something else right now, but this is
> rather urgent.
> 

As this is really something I want to have fixed rather sooner than later, I'll
throw the first 5 patches into -next tomorrow.

In the meantime, I'd appreciate some feedback from -net folks, as that must be
sorted out as well.

-- 
Cheers,

David

