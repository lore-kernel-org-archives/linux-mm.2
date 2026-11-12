Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37298606A333
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 10:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I0TPDV43
Received: by kanga.kvack.org (Postfix)
	id 2F2606B05C5; Thu, 12 Nov 2026 05:43:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C9E26B05C6; Thu, 12 Nov 2026 05:43:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DFDA6B05C7; Thu, 12 Nov 2026 05:43:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E6CBB6B05C5
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:43:14 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 78F15160496
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:43:14 +0000 (UTC)
X-FDA: 85426129908.10.57ECD11
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id C03A71C000A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:43:12 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I0TPDV43;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794480192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dNp3udoHGBTm0oHVGK0tf8e5QbmrNR/x3XeLPS1gMFU=;
	b=lg1Gce48i88P43yK/746f0V6ZgR22VX4kxDn8VJ3cdp6CVHk6joUCXMtLXwrnNbzqiOnAU
	qWxLnJQiqVGL9c8YeiKhy4Klci/ZqzErdhb/dmGGQq5gGBNTccDhCsyKXx9V+Nxq/pbXSE
	7IQtCyn0T2BLnELZHL/qTfx+fXzWoQY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I0TPDV43;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794480192;
	b=otHy3G0wENFoHaQzXSjE/eu9U5sXHapUpu4PUsaDSPPonG9XWRUYbXstg5rsLfMoEp3n/s
	+0Oc86GLw/v1L6Z6K5nFweVly175jeFqFOy3L+7vMHKT2LZ66IceXAR5wDHiwWidp5Jv7F
	cdpoh7l8o+TyT76fnfK8X6FD7+dGt5A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4F75963319;
	Thu, 12 Nov 2026 10:43:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 677411F00A05;
	Thu, 12 Nov 2026 10:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794480192;
	bh=dNp3udoHGBTm0oHVGK0tf8e5QbmrNR/x3XeLPS1gMFU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=I0TPDV43709xds1YjFciabcX8qY1kutyiqT4lX2KKlYro1DwODMPjRG7nVRyeYq66
	 vbZLurqiksVuDaoY1LkD/b5xi6IUC05VrWqzoS8cg3dmM9nvkWpd4OgnlddW53//yA
	 122d/AkBmYZZwYRJlhvhMXsS8VBFwcTE316zNFd+ifJo08ZSFBQlXmz7faIhXQ/gQ+
	 D5NSx6U8O4FZXgtjJm9Q3eL7+2hksA9jy6WSRf07SPq4o97j9rpTcs6rKAst/0vPMl
	 zHVfGezyt9McTCfCB2BTmdo44x/6PrUKOMOUdEqC7pTDwmEKnIu/+nlrdqSywBLRqG
	 moyZYmFfXgPEw==
Message-ID: <f5a411f7-ea17-451d-9c43-26a68464c6d2@kernel.org>
Date: Thu, 12 Nov 2026 11:42:55 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/9] mm: limit pagecache folio refcount when mapping
 pages
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
 <20261110-refcount_overflow_stable-v3-1-318625d63a98@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261110-refcount_overflow_stable-v3-1-318625d63a98@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C03A71C000A
X-Stat-Signature: qa8b5mgmwi1sw4pb7y3skaq7s1gb348w
X-Rspam-User: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794480192-838896
X-HE-Meta: U2FsdGVkX1+5uYoA0W56geg3QjiDJjrjec4+4BfTJ2kfQYLSulC2PciR+5LarXB0qqRsV/5AKRyvQJGxJugSAHrlWu+UjhEaDT5RPRiwEngf1iuEM3LXyQyfcAVFKg273s6FlAoGGTNAQhFHPcShEQ6OU298iN/EOqH5wVyC/+w3vfx95C9jKF39bfxQQAWOMuKPXyjpuvWcM1hOybz2KwrxsFmckV7N63kmyiEUlfzUQqBhUs8YysXMeeGQ10MVck0jF0PY5mJp+z3UqEc3sLUUzLtiQIW0/4VQzOV20xVQuE0GfrBSKNW9hTM5pef6SifcDCNLlTiKLdr2NcJ7ogzzYWjs7IYmpeTOEeqwLSisMDkIdvPPX7ezJvyVCKf2liPNd6sLiDx4NGBIZ5gB9BU701MOUOuACk+LCwpqIOwYzdpYwvkIQUvEpjRjFYFRDYTMwLXNdM0c/Uo/sZl9b7j2ye+c2PWeiltiEdFkEAa4UIVgVAwKe3VN07RstCDZYAPAK5tdi18l7bN3ZsJBHXFX2ldZyQ2WaraBxJKfW6nr18BUQfohbKEs5RV8A76bx1ZzsRjXZoAS0bgdF67sdnWuK48M6OJt1anoo1Ri9IL8woPhOGCRfxIVhwYGOv3DM16/H7M2QDJf/1+dnXR1J/4gSUq/K+oQyt+irPz78VEbWFCiMwbZkMb/u4y7g7W9HkfXJjTflVyxBl37+HQAQyjSx4Ium8aMMXXnf2CLJi8psJp7i3L+F2uwUmWa8RCp3KK/CSy6hKLSnlAqn0/qDJA/5OmxGBAvWM32YDL0cJdS9OlHM+e//mpFwM/HcVBsRICRezzc+zzzgCo7ocS5547CWrG8qwoA4vnMnjMUb1ceo/IDniE5aDYyMs1Frm4Sm53w5U6O7NYPbDkrsORKe7g+d6rPsAZ/NmrHdHaWC4JZkrui+8t/0jC4KQF84NjZGUmSmfwYGD+xCrCAQw2
 t/PZP/0d
 AaPpQcwf5TI/i8DKIgDZDH6JTVp7nqhJ20xoEFAoDyPC6BZiagGeGp9GpUP9qA6wWpBoVr10HcZige0si+DSdiybGwJyLykHCkekYW8HKg+3xs8huNsdL/Yp+GmZ3PtPs+ic5iD8t1xEUD+ySN2AtowunsBkL/C0U+gHZH3FrdWL3U2KIuMl8rLkRltSIEWF07+W+fJJmhWH9Jt8dnYc4n2KfQrh9YBs4aenYDQ+Nm9S9T+s5QDDiYN1KwTIHZhk6LCzpN3dz1KiwmbEvMCnENb+o6rhaPqSXIcVN8GIzjz0fB2FT2jFOktvx6FU9DpbhvS1mvNCFGq4d3/JFcEhFtKTQYvcpHauqOs3JBcFcErqPus4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

>  
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 9871b4f32a916..0f6d57432a7e5 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3968,6 +3968,11 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
>  		unsigned long end;
>  		vm_fault_t map_ret;
>  
> +		if (unlikely(folio_ref_count_over_limit(folio))) {
> +			folio_ref_dec(folio);

Going over this once more, I'll just use folio_put() here for consistency.

-- 
Cheers,

David

