Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A098BEBFD34
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 10:25:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15ABB6B0092; Mon, 13 Apr 2026 06:25:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10C4A6B0093; Mon, 13 Apr 2026 06:25:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 021406B0095; Mon, 13 Apr 2026 06:25:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E8A526B0092
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 06:25:20 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 96076E0356
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:25:20 +0000 (UTC)
X-FDA: 84653150400.17.C197897
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id E5B1440002
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:25:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hB2dbYyN;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776075919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sOUsGz+ASU0qyLoYtkqkk2m6Hu8u3STTKxu7/l3GzVU=;
	b=3k0MaIzJdv46uzDCAZCuJAf7uJHfQ4UkUjNp5LxEbxzGB8X+oamLc75POyqADmKIRUPg0Q
	BAjzml/22IY/1xSEdLhBLuNMQKCcQAjYZVTc/ipkerUR/vQJvi8NF5mGcWWDRoKBaWRjj/
	vPJkiQZUfr49ArfpvZfDtf1wEH5FwKQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hB2dbYyN;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776075919; a=rsa-sha256;
	cv=none;
	b=YbGCklhGRwrwJ36QUtuPAtHLbWuefB/Z2rqo1a4kQDxOw5rJ0DRDyhRileZtJcXyWIjRnm
	OaeA/IpBuU/mxXGmdM2mnfLkj51jIU4dYJgHOLGd3hVVQ7dfJBu5/Sz+Ezre/lx0K1RdP5
	0o3TIZ/qrninzttEp/pK8I0peYF86Xk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B406E44058;
	Mon, 13 Apr 2026 10:25:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4CB0C19421;
	Mon, 13 Apr 2026 10:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776075917;
	bh=OpCtMA+VLXoHJ1J0xclfeufGCMuVGef7e420W0OMdkI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hB2dbYyNWlMxCeUtmO/7H3w7A3dMhmviL0UrOcV4LLRj6AfNbZE870kw+HAqD03PW
	 sc5kSybQSC+cDpIu294MegfONjVOcCit3vFr8BiJebMKdFT7ju+gZ1RV3OoTO98NwM
	 wv1anMpNA+t9HBkSNp4vURIg7mlq6s/6t1bJ2sJk3NcESyvscMBPH3u3XjTw4ryceq
	 V57GHefaDJIax79/kKQpSD30AvFWIQsZuBPFHQO7G32VEylQIn74c+SZbFeB46NCn1
	 VbRToJWPUfe6HjfMzrqU7r1kS7vNKBr++nFimvX6qlM9XmAIg1PxELvMJJHP3xARK+
	 E/uLbn1wFADNA==
Date: Mon, 13 Apr 2026 13:25:07 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Donet Tom <donettom@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Mark Brown <broonie@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Nico Pache <npache@redhat.com>, Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 10/53] selftests/mm: hugetlb_madv_vs_map: use kselftest
 framework
Message-ID: <adzEg1JM-OO0yzqd@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
 <20260406141735.2179309-11-rppt@kernel.org>
 <c1ff61ca-89a2-4d13-b376-03cbe7719366@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1ff61ca-89a2-4d13-b376-03cbe7719366@linux.ibm.com>
X-Rspamd-Queue-Id: E5B1440002
X-Stat-Signature: hobywhrqocduonp985yht6c1jf8emro6
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776075918-739111
X-HE-Meta: U2FsdGVkX1/LwrpI9wixSZoBwyX0zPdtijnPNDu3boGQais/E7O1E+F6pjrHH2bpBSgt7ab4MXdkYYtUjTV/He5ORnHKWRZ6BRYDApa03at8XnO8zCP2QqgofAMjty6GHtYftPTrKxzXoleMJQf2/QmmzTdlblVanWkTIYAY6SCoXFjhhyOFg4xBrzKPS1+0T1zOGG6TwnJo5Wy8dleX3tulQ17ij3tLlxR9GGo9Vmc6OGsUd58LpxtMBvyFQyWGq58odV7tzYDWrfmIpwRs7UFsCd9F1J4gIihDBciZjYLhSXBFIu++dpmhM8OWENQrboiq6D3zFChc8WPJCCsBMJc90Bb0sXfKWBCcZH3o1hgfKoAjlpmeBW9422+PEnRaDKZkqatlHeq2CGGjqwoxnxSZLo1VE2M0gO/10dvXqZ6wZD5QypUyxhu4QaHYCy8Tc2QxJR988SLPZW59DqMr7UmlpFDWezde+rZv7upgVFoqwUQdZX44NaCXgX/chs/Z0l/qJ0Dg3zAyBDjbLur6eEjpxTeQStGInYt610AHXpv1sVmr0AHwUQZ9xGadnx8BEtIQxlWty2EmjuNgtj7vGSZ3HOL6m9yO415bC4R+kZQLhloKSg1jPoG2E69SdkIBZ4TTbNNL3Cc7WJNDXYsS9BGsSL2Tl5nXKCRM0fXMTdv1bra5rbSdGNzYQsktnaIwP3UDwVmAi/2qGq3SRS6eV+akc1/oejXdmfN+uPCBv08UPubVQM0cUyGe0KS/F8bxwMjDycoSTKU1K3SC+7MaE7v+5hLVE8//AH2gAqQlH69TsmiY9CKgsyFB1Q5A2A96YGYEgC8qQTExnZoKAlyt0DuJeu4OHp9eOxSFYKY3jMn8iu7zlBzXKxUh8iI+ejhrzJ30P+M9JQNVav5fv9k3EZU+8RegDt64DekeGHZUgX6twGREEH3ehbQo1fCzN/JO0fsTB2SkiJBGILNyEoo
 BKT9UyxA
 oDMkT9JgA/0H96EnlNeflXibfjxXgKybEmGFRc2HpQNUyIJRJyxEfwOf9Nf0oOI6S2K+P1dbid5YjYjPtx6o5h0lQYGHJn8Mm0MDY2L+gatT/YtiXJ8CxDX/qoJdxdNAONXiJNwByUe37EYOCAyQjup17SGGaHBbJrZZM6kAcFQEKYdyy8M61uiCLMQdKPloCgaFAON3UMbsnAmizob3Hd9eR88uuaCzWIb0st6yfjWdehwiU7bpKLSKl7EtEa9S1KrbZeaNbX4r06C4NzmwlzK0t6C12aPHLBAZvXmbwHaklgZ3i9NXQ97jw7gzMd65CclLzSQVBD9dn9FE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Thu, Apr 09, 2026 at 10:44:28PM +0530, Donet Tom wrote:
> Hi Mike
> 
> On 4/6/26 7:46 PM, Mike Rapoport wrote:
> 
>     From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
>     Convert hugetlb_madv_vs_map test to use kselftest framework for
>     reporting and tracking successful and failing runs.
> 
>     Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>     ---
>      .../testing/selftests/mm/hugetlb_madv_vs_map.c | 18 +++++++++---------
>      1 file changed, 9 insertions(+), 9 deletions(-)
> 
>     @@ -115,12 +114,13 @@ int main(void)
> 
>                     if (ret) {
>                             ksft_test_result_fail("Unexpected huge page allocation\n");
>     -                       return KSFT_FAIL;
>     +                       ksft_finished();
> 
> 
> Should we call munmap() before exiting?
 
We could, not that it really matters.
 
>                     }
> 
>                     /* Unmap and restart */
>                     munmap(huge_ptr, mmap_size);
>             }
> 
>     -       return KSFT_PASS;
>     +       ksft_test_result_pass("No unexpected huge page allocations\n");
>     +       ksft_finished();
>      }
> 

-- 
Sincerely yours,
Mike.

