Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA01DFCB61D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 16:00:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E69D86B0099; Fri,  6 Mar 2026 11:00:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E16FC6B009D; Fri,  6 Mar 2026 11:00:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC1AC6B00A3; Fri,  6 Mar 2026 11:00:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B99EB6B0099
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:00:10 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5D487C2457
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:00:10 +0000 (UTC)
X-FDA: 84516099780.04.D6BDF20
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 80A9616001B
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:00:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j8WNbSnN;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772812808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LhA+IXdOnWx0hCMkw/la6PJLWhXffuq9fpj/Z4yD+/c=;
	b=klYM/q3W7A7p5MUqxWMDVqLquD52yvYEpCozg1SMX4gGFmf0GFuAxb/tnfdzH6PCJuGm6o
	RkeDWuKgoVlS6IsL3EtVZS8AfZOUVwMXZlgI03kZKV4yjXifOFMRA1iMcNsOo2RrSX2W+U
	a/UJm/gdmgs+Qf44Cv531XPTfM0g7no=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j8WNbSnN;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772812808; a=rsa-sha256;
	cv=none;
	b=d2Nz+3bS83IoKYDKnLkRoSlgY966tfIGTprrl4ktZt+SkN8BqBWuovfShywR62h/tsn2pU
	kA/1kTLO6qeaSU0CzUInjlnnGxIcEuctZx8yr8bvYnIh5jLiRszaKSwrpPwEkMz6q7Q7Vl
	BhPVSes8hz2hPQINb+MzojFJK4FUNpA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B511A60053;
	Fri,  6 Mar 2026 16:00:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79BB7C4CEF7;
	Fri,  6 Mar 2026 16:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772812807;
	bh=b454bzPbl55ULZOmmc23V4LQKs1U8z6A+oTB2cMxkSw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=j8WNbSnNmvDwOEQchSrC+awLU1F9TWqkmTuQb3KvRpAWzLZUou3D2zzmuiS70gZst
	 Bwh7Rl9TvfXwyWnldJX5HHuaemXXQi7DRfRcLyJPjVFKnw1+1TlSa2TwmtDO4gC3qZ
	 SsjHQhoYF375E35KJUUMbA3z9iVJvPN1gmhF5c+qtjvl8fDY/ZAsG4pCvqkzZOlwrZ
	 96lpeY6THs1o2800tnctleliaxJ6DVjEL58BBvLikn6o6CIi0KBcSywr5bhQOmeG6k
	 fANs39ciRtTxyGcNUR7fDgCyNsxmJGtaT5oJWRjq5/I1L9qFqOKV9/oNAUWE9k2uGs
	 OxrKcLaTxIjkg==
Message-ID: <546df3d8-2f63-4a83-be44-4cfe21ddb4c6@kernel.org>
Date: Fri, 6 Mar 2026 16:59:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 06/13] mm: Add helpers to create migration entries from
 struct pages
To: Jordan Niethe <jniethe@nvidia.com>, linux-mm@kvack.org
Cc: balbirs@nvidia.com, matthew.brost@intel.com, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 ziy@nvidia.com, apopple@nvidia.com, lorenzo.stoakes@oracle.com,
 lyude@redhat.com, dakr@kernel.org, airlied@gmail.com, simona@ffwll.ch,
 rcampbell@nvidia.com, mpenttil@redhat.com, jgg@nvidia.com,
 willy@infradead.org, linuxppc-dev@lists.ozlabs.org,
 intel-xe@lists.freedesktop.org, jgg@ziepe.ca, Felix.Kuehling@amd.com,
 jhubbard@nvidia.com, maddy@linux.ibm.com, mpe@ellerman.id.au,
 ying.huang@linux.alibaba.com
References: <20260202113642.59295-1-jniethe@nvidia.com>
 <20260202113642.59295-7-jniethe@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260202113642.59295-7-jniethe@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 80A9616001B
X-Rspamd-Server: rspam07
X-Stat-Signature: uor77karqu6xi76a6rkrycxegep3w9zp
X-Rspam-User: 
X-HE-Tag: 1772812808-710589
X-HE-Meta: U2FsdGVkX18Z3MOa213yH5PTqNYcmSMDmm1rcFiUlYGZA9UR5Om8zSQo6O6CJaiqWpznQza9FxpL5G5zka7fEcu7CYWjBE3hsO4MU6FpED3LFEdpc3mQN7MyJQFXA9wQUFeJjAs42VmInLB9nWC/lWOdACF5PIu6NWm2/UebIO7XzYANTOJHQBjFRlCbP06J5dlpHnXSSN1orIMXV1By+mK/CA/hDqFnJBdw8kQZgKq8BZ8XHUFsiRuz6wW5OxINgQ70hUhnjWEruHcynYaD1ex84wxZrhQ+FxHgxvisEAF5VDkjEIY4ARRnDs1MaWzkfkcys+VTrxEJN3Cp5mIgLW/gV1+E0qU9H0Gq07pTRwpxY7NavIWlYk4jBSSePgaQorih3ikwjnYTWc7/qYbilwKq8BVwQK5kO2TH8b48FJhfvsmXRkQw53gvp+wwNREla3ipL9mvVaVphzMawhItEWr99Yw0v9tiFn586gOZ/ZDDsBokyNW5yNRaXpvE+VwBAdSblKF8XuPBPaA5BGoJsyT0W2xbKKm+9KqrXi9IvX8JXCUs6i34P1/6o2shyPQBDu3j5YiO/4FbwlST4UdNIwioP2TqDfa6mKwPkSdONbKNmRyC+Nj76R+CVCP+zycU6XCHOrh7IyV/lvDooGh0dgUBB90l24JTSSZG2vYI4JdkCVo6hvgNszWQZYoQDCeghd6yxyLPYwPH3Eh2q/qpZAo+UPgyO8qylazbZPWjh5HEPYlotqEYmnzr+ch7I/QrSLAOa3Un7V2NvrSxhBd/X9LyLtHbNleeIGWdPD5MC6zMFPCdCswpHGGIBVLYeqr2HMrYnZsaYsdTeSkCqT8Cfco+f0FGF39coFEgwYtGFYp3o+FK2bPu+vF5swXhEa9kAL5LDY7cOInK6fo5L0g4I5Nky5xaxcWTVjG4UrfGqSJKkz4KQXBs13lb+n08NzxIxXB9aV8HYMyjXOAEwZg
 eQDqMcO/
 ytDWkLl7qEZVa953KRQAadTlxNdJsXQK7t1tGGCcdyXKVJadVh7jFT6IIa2y846JGLyRKORCEEdpCR5Z7mOQwzX2Y7OoLkeYj3+6LffV9Uh06yay5wbvdbKGyaT0HeNWC+KOohiebMlYTyjQdf5Wnh0p2zAACL/A5nsKrohB077XpcObtlC1HDO5wv7bXWKqc0nKZbrEiOl/t7jpenRrQfRbqArrhTEmBm3DVCRV09J1R2TmvHyHhuqmdsvzlbMgGZDYXg/y161vjZxz/JPzaDLEmaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/2/26 12:36, Jordan Niethe wrote:
> To create a new migration entry for a given struct page, that page is
> first converted to its pfn, before passing the pfn to
> make_readable_migration_entry() (and friends).
> 
> A future change will remove device private pages from the physical
> address space. This will mean that device private pages no longer have a
> pfn and must be handled separately.
> 
> Prepare for this with a new set of helpers:
> 
>   - make_readable_migration_entry_from_page()
>   - make_readable_exclusive_migration_entry_from_page()
>   - make_writable_migration_entry_from_page()

This is pretty horrible. And everything I see in successive patches
around that is not any better.

Seriously, look at how terrible
make_readable_exclusive_migration_entry_from_page() is.
make_readable_exclusive_migration_device_private_entry is not any
better, but at least doesn't have this questionable flags parameter.

Correct me if I am wrong: all we want is:

make_readable_migration_entry() etc. to create something that
softleaf_to_page() / softleaf_to_folio() can properly convert to a
folio, right?

So maybe we should convert make_readable_migration_entry() and friends
to consume a page (not add new functions ...), and let it internally
figure out how to communicate in the entry that what we are dealing with
is not an ordinary pfn, but a special device-private entry.


> 
> Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
> ---
> v1:
>   - New to series
> v2:
>   - Add flags param
> v3:
>   - No change
> v4:
>   - s/make_writeable_migration_entry_from_page/make_writable_migration_entry_from_page/
>     for the !CONFIG_MIGRATION case
> ---
>  include/linux/leafops.h | 14 ++++++++++++++
>  include/linux/swapops.h | 34 ++++++++++++++++++++++++++++++++++
>  mm/huge_memory.c        | 29 +++++++++++++++++------------
>  mm/hugetlb.c            | 15 +++++++++------
>  mm/memory.c             |  5 +++--
>  mm/migrate_device.c     | 12 ++++++------
>  mm/mprotect.c           | 10 +++++++---
>  mm/rmap.c               | 12 ++++++------
>  8 files changed, 96 insertions(+), 35 deletions(-)
> 
> diff --git a/include/linux/leafops.h b/include/linux/leafops.h
> index a9ff94b744f2..52a1af3eb954 100644
> --- a/include/linux/leafops.h
> +++ b/include/linux/leafops.h
> @@ -363,6 +363,20 @@ static inline unsigned long softleaf_to_pfn(softleaf_t entry)
>  	return swp_offset(entry) & SWP_PFN_MASK;
>  }
>  
> +/**
> + * softleaf_to_flags() - Obtain flags encoded within leaf entry.
> + * @entry: Leaf entry, softleaf_has_pfn(@entry) must return true.
> + *
> + * Returns: The flags associated with the leaf entry.
> + */
> +static inline unsigned long softleaf_to_flags(softleaf_t entry)
> +{
> +	VM_WARN_ON_ONCE(!softleaf_has_pfn(entry));
> +
> +	/* Temporary until swp_entry_t eliminated. */
> +	return swp_offset(entry) & (SWP_MIG_YOUNG | SWP_MIG_DIRTY);
> +}

The whole flags stuff does not really belong in this patch. If there are
cleanups to be had, perform them separately, please.


-- 
Cheers,

David

