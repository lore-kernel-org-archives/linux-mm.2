Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA8F1606A337
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 09:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oCAqElg+
Received: by kanga.kvack.org (Postfix)
	id A91656B05BE; Thu, 19 Nov 2026 04:11:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A68546B05E2; Thu, 19 Nov 2026 04:11:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97E4B6B05E3; Thu, 19 Nov 2026 04:11:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6C4296B05BE
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 04:11:45 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C0223A0A15
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 09:11:44 +0000 (UTC)
X-FDA: 85451300928.19.8A9A985
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2E921A0005
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 09:11:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oCAqElg+;
	spf=pass (imf15.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795079503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+ob3yII6XgPfaGzBlNNgVC1u1nxxTdD3c2/x1BrWMGM=;
	b=unsK/hzANm+00+sBaFLJ9xdVQqz3eWX59aq+B8XDJv8P4nGO81sAUSNX2gmH8WSMFykOes
	5VQbaC2kGZ86wAKJBPRAbsgY7hLtmhCVkCata/oxYUb8rtuuYkXy77YWpqzJOgp+dOl9uR
	GEgE+GM/S0dYSfetUgP2M4F2o0hOW6E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795079503;
	b=35SAq2mPdrqXcQxIM+6eq7y91nAoVu4p+4Sy+CQvCJ0rO1nFWPNphQH7mlp5kPPy2oqq2h
	Vn0qzWUArw1b0i1lDqFhiytgDg2VwyS2ZlqwpkF0fDISXPzbmHvxDN0MfEQ0hkGEpmGL4a
	enWoilJB4OqUQy0/NJFiE5wZ/t6FRMY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oCAqElg+;
	spf=pass (imf15.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0DBF8626B3;
	Thu, 19 Nov 2026 09:11:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C28301F000C4;
	Thu, 19 Nov 2026 09:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795079501;
	bh=+ob3yII6XgPfaGzBlNNgVC1u1nxxTdD3c2/x1BrWMGM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oCAqElg+jHpUv5NZi3+X5pT71z2hb8IbZEPK5BleYGMiMxx+phX6OjUT/P/4JUK2Q
	 gHVX8e7WqtiDEHBKb5OeG3+JgdTndcnYo+GJ4u74ENd96k6WZheR7PExY00+0aU+fN
	 oTV78DY/bCF6fuGrMLPl96Z2obRF3NzoMJzPTDcBtla5/DdGBhEyFt4AGOfdP2jkyn
	 wgW8UBwgVdqvAGib+vgTEmLFnEg4B6mqeSe1TfYDkZ1XM1hOX+fI3Qjn0gkajd6TLh
	 U5sKOqVa8tgXrJoD6aa8iOCHtuoYt75M1hI6VQVHKNjM3LzrR800nK0vZnwiwLPZFb
	 Wfp9a+v0hoLhA==
Date: Thu, 19 Nov 2026 10:11:30 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mel Gorman <mgorman@suse.de>, Andy Whitcroft <apw@canonical.com>,
	Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>,
	Rik van Riel <riel@surriel.com>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Dave Airlie <airlied@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, Peter Xu <peterx@redhat.com>,
	Breno Leitao <leitao@debian.org>, Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Nick Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Gerd Hoffmann <kraxel@redhat.com>, linux-doc@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-s390@vger.kernel.org,
	Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH v2 09/15] mm/memfd: recheck the page cache before
 allocating a hugetlb folio
Message-ID: <av69QsxDuugzEJPL@localhost.localdomain>
References: <20261116-fixes_hugetlb-v2-0-4dd9e94ea9ac@kernel.org>
 <20261116-fixes_hugetlb-v2-9-4dd9e94ea9ac@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116-fixes_hugetlb-v2-9-4dd9e94ea9ac@kernel.org>
X-Stat-Signature: 55bjpz74zcshremzpg9n8j7k9g6y5xru
X-Rspam-User: 
X-Rspamd-Queue-Id: 2E921A0005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1795079503-890779
X-HE-Meta: U2FsdGVkX1/kPa/b0t3dPiACoOTvYMUtwgfXlVtlUBkoG3sUg/8tLogIraf6R7aIGSHIUEFVxpZuVnuEOzMnSXCw0iKxv43IUOcb57RotkBOQ7+kfy4u1LUjamRIyFFv0uWLVDFPVGWOGi9W6TFRFHVLikmc2T+HZGV4YnKfsSCkIt7/OQL0peNzZIdB9QkKSq7xOSQNmSg8CjfZUZiDXoIS0vz3gmZ5JNmCAUDNjpZiykh813It2i0Q7Mgzj6E72wXTLCZkrI0XfrsOFqw8K2eMcqBMpKkRI7iolLGu5XTtq1czLj+wV7PyddMlS9bkAn/Kyeq/OE/j//m7uNsOkdl/cjVikWKLs0bPhM7mt+l/biTMwHIuDStfQ7z5bAWk6zT4gNXOV9K+BvFJ4hVBgA41swVYYBOvyBif6x82Tn1oOQXOw7/k1o/s1sx0ZTuEMHWj1jsDdtc5nc+Ld/RtKh6LDHRNekpQ5Kp7D9+4Gjw3q4fnFkvJopm8AeL6bpRipxJVYpoDINKVEdJ/dIBsxaSUyVGVCiAYDvAiZ8HZIz4btwAzmFxoUjgCr5hbjjKvlImx3yCppCaaezNHYNNUzMF51gnmyZgo5y6D29H6YlD0gQhAOwFYN5xxcHzhIfTwajxbf+tbO8XGXWcBLLG9ZQXlZS+r40Z7WSsoWGYg3NTVGYQQdce76ZNehsNIEncgL4gKekWFL46F9rxUUjTOrqmRBBoNEEXHRB1A27zrIQU0qiXxmuKOEhfBL074ol7Sf5Jc1vUouCnNPKUY4j8MwTftg9qf7na/JvrPBZN0Mhkrg5xJBmgvtqKKYksuLw09UBHTwWY0oRPvSF4NSButQWF6hDO5o6zAcpTuHVisEYWcZmC4ZBGgb+/GmNY8PqwD7E8CSam7LMrO/6dPitW1ACRhZvprnYd7IIhN7j+OryOpLRMEIgag+O/gskyyz6F6BMrVdyRgr5Df0BT4qj4
 KSO+zn6d
 4VvyIImMG8mUUvPnlar4efjft2HyWOATwRs1XwkNKxieYdgTFA2YnC3/qZVkCF11ozpaeSZSPWyaqkD7qRCIM9YmDIbec6rW6GHSjL2Sp5iL7/kaMJs3KCINo3m1SAdl+KuuErwgovcrThn8PpzOlBj6BbEuktOrykmEHi59tinc/2OX/3yuxQyh7O7U6WHl9y9BoWGy5qeLA38B5eHCVW8W3js3ZZMMnqqVuBbJvJjQSVqpuf2yX7evANHtrnzLfvd8bOMqifwj0ry3d41eDn9ZIzoGRYDqMJCJEutdKhGvALFxMBDcsJfrnKLtxxkA2JMhwdLDTkPiobDgncpgQrhgaESAJqNosTxHfKlOolfQqmURPDUToVaYn1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 07:29:30PM +0100, David Hildenbrand (Arm) wrote:
> A concurrent fault or PIN request can populate the page cache
> after memfd_pin_folios() misses it in the page cache but before
> memfd_alloc_folio() takes the fault mutex. The latter still tries to
> allocate another folio and can return -ENOMEM even though the requested
> folio is already cached.
> 
> In particular, hugetlb_reserve_pages() finds the existing reservation-map
> entry and reserves nothing. If no global reservations remain,
> alloc_hugetlb_folio_reserve() fails even when the pool has free pages,
> effectively failing memfd_pin_folios().
> 
> Recheck the page cache before reserving or allocating. If the folio is
> present, drop the lookup reference and return -EEXIST so
> memfd_pin_folios() retries its lookup.
> 
> This is probably not worth backporting to stable.
> 
> Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning memfd folios")
> Reported-by: Josef Bacik <josef@toxicpanda.com>
> Acked-by: Muchun Song <muchun.song@linux.dev>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

 

-- 
Oscar Salvador
SUSE Labs

