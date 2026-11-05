Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 330A9606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 09:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D3Ff3mLR
Received: by kanga.kvack.org (Postfix)
	id 599BB6B05BB; Thu,  5 Nov 2026 04:26:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 572396B05BC; Thu,  5 Nov 2026 04:26:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B0206B05BD; Thu,  5 Nov 2026 04:26:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2660C6B05BB
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:26:55 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A62571609A0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:26:54 +0000 (UTC)
X-FDA: 85400535948.25.D80ED38
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0B694160009
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:26:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D3Ff3mLR;
	spf=pass (imf08.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793870813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uRkdO17Voxl0dXI2uG8wshwdNsr0g145kxXlot39KlA=;
	b=yo+DsZ3YL2SLZM0sro4vGggsIUQwQekNiFp4J6/5mM21vd2mmt+ZvZUxStII8omoRFfqID
	55NfS5Az24gOYi7BQpHntD5K77hHl1dkBGhtjdMtdyzi+wGpuJCH0W2N7IWYBYXhC5oioc
	qo7bm/OMEgJBGtsg9g3a/l5IAMUbnFk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793870813;
	b=VSYYhY3kcSxju7I4CUTRYrdKWtLCBld+FDmhJpJaElv+ari4ASmovMxqFAeH+RABLICvv2
	sHzUsIMx5Y2a/mLEHEBnqZxIO7VBpQZBF2zYJwEcMNX6MXKXySwwrHvUW8iUnKFejW1Ejk
	QD1vswQ0uwHuqjf2q9lI7XOPRUkbOEQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D3Ff3mLR;
	spf=pass (imf08.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 039AF4167E;
	Thu,  5 Nov 2026 09:26:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D9A1F000C1;
	Thu,  5 Nov 2026 09:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793870811;
	bh=uRkdO17Voxl0dXI2uG8wshwdNsr0g145kxXlot39KlA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=D3Ff3mLRu4OChP2iUFU4kKDEzNr1W2PkRr2N3WCoIANfV8eYMHtr1p+zNArTikMKv
	 sIeNox3CK7OeKmR0k/aKUCimJ0pteSN4s1zni++glIrXGPwO7cvGWhSq552JhrNX49
	 bGfQHQ8ydG09LI0e/Oql3VJY9nT9unfJeUw515TqftXpdlpc5ppVtOGIBv39kZS+zf
	 ZCQFDxCNDKlsk22SXXDV5wi8rC9W2zjgj4O37W5RZvhthRVV52dbEIhMn+XJlTPFqo
	 vQ6t0k65Vj7JsbJSQBIuTKGNtVNTBX2BYaNwnjSubsYvM+7XdWyIRrdNOPBSU+c56Z
	 3ghh+boYYNBdw==
Date: Thu, 5 Nov 2026 10:26:45 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 12/12] mm: hugetlb_vmemmap: make vmemmap PTE
 conversion folio-oriented
Message-ID: <auxL1Q4S9wllEn6B@localhost.localdomain>
References: <20261104023510.260766-1-songmuchun@bytedance.com>
 <20261104023510.260766-13-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104023510.260766-13-songmuchun@bytedance.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: 9ck17mq1aysnritxfownbw9nd7qs9799
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 0B694160009
X-Rspam-User: 
X-HE-Tag: 1793870812-348302
X-HE-Meta: U2FsdGVkX1/jSOlrl9Et1SjXSlOO6IjNG3E7cnHicpgLXdEc2pjmqwB8Dt83XopvfUuTr2e2hQV1DPyCSDepKUffdgwDpnUIkaWZerhpSmXst4HVH2qqiFJ8OnpXKI5orhkmAYGesx0N7kk6tNiw1sliQtxdV2x3n1P66Y9xlTPSp0+cl4xWpcby37v7+z64GUk1rxe6XNfHiSVO0XF2Sm4sVV7Y5yi22tfhCRX8zEoruAe4NGGLk53UQs2XQH3BTSuu1Jkqee0i/O5/3syrgsHYFmzc3cFcMKWA9nShKiwMotkzhOh1veQ2+0dVivoCnOlHIzEHC/5gO7PY1bxfO05v85WM/PvYGuRKO4dTUsMBQY5vE/XJYni8rxqWAeh8t+3ph6GGGBYNwq0FjS5N6ij5CiI0d9+PdgjpuMATT7xTD35XWYwNaIEvbeimnr/3FzYxFDXFlU1T4afyttMwc4ZmYC9K7DjtpK0093tuCdLg3JBPIRuskNSrXGOeqbJI25/ITvEcwCzb/vsdx/7oABkNx/O4Au4WJAsDwDwyTLS0WLVDZRNSuNBR/AavTVquT/gkwA1N1fQUY2cUUqulCUc4k5Q6zIaLCXyU5YOHQhN3aekL88NH95ASXjRvWngWnbKyc7WmC5ge0hl130wcB+0s2KcyCqQWJbn3c+piS/6ORxkM3J2xic+C3C160UMQZtLD4Mz6Nmr4/E5Uz+2LimM16f6BwuQC4hTICAFayGebdEWsXu1K0hwLiHbuyx8ApyvdSg13HwbTDKRkwyDeVvY8YGXbz6s1+XrcUNkjp14ZUpXfHGZplor6lDp8Yl5ziXR4eWdJ+Ms3TTODv76wnwL2W861h2ymmUHEIiagjfy5/URuEUg6xkfd+1uBysxeSqt2D7vBJhkWdeTKtSUJZg7+8XWdUNzsvlWvcgnfM7Fdmxn/CKTQ5SQSA+mGMBSYMiQTFmCfEEexovUCcyG
 oS/doVV2
 q/FGT/cKfIv6/E8u2Ay66xX8x4YzQ1PBf4OjEwQcgXf4F+pvc/WrEtTx3QuBs+wmMxkPxBv07arUfcQpTj2tDdMqdqIQXvceXQM7nd2DKzmCMPX9VLY8I1+pUPlE7O6Pmgab1/w4dzKIITjcIELrJAJHYF4irmAZHW8/wLX7KuET95uLkipEeQXsx84dDxlhWUxzIlyBIqFXy6H1FtkDs4DVJZH7nFD2WulDAhAZR+Gqzuv/79bROvEiwr8wdQlHuNaMv8f/VNNvaN2OCTO+z+MnaIm28iDMjQt6dlcUcGmWt+OOn20NZc4BpKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 10:35:10AM +0800, Muchun Song wrote:
> Converting a folio's vmemmap mappings from PMDs to PTEs is a per-folio
> operation, but the current interface exposes a raw address range and
> hardcodes deferred TLB flushing.  This splits the common mechanism
> across layers and couples it to the HugeTLB batching policy.
> 
> Make the folio the unit of PTE conversion and let callers select the TLB
> flush policy through the folio-oriented interface.  This keeps
> HugeTLB-specific eligibility and batching outside the common operation.
> 
> No functional change intended.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Oscar Salvador <osalvador@suse.de>

But I have to say that I would put the vmemmap_optimizable_order() check
upfront in the caller, so by the time we call vmemmap_pteify_folio()
we now we can proceed.



-- 
Oscar Salvador
SUSE Labs

