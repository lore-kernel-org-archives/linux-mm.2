Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF102CAC5AC
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 15:56:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3431C8E0012; Tue, 23 Sep 2025 11:56:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31AF88E0001; Tue, 23 Sep 2025 11:56:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2305D8E0012; Tue, 23 Sep 2025 11:56:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 095BA8E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 11:56:47 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B5A53140497
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 15:56:46 +0000 (UTC)
X-FDA: 83920968012.17.0393C57
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf12.hostedemail.com (Postfix) with ESMTP id B192E4000A
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 15:56:44 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mQOLoWOG;
	spf=pass (imf12.hostedemail.com: domain of kmanaouil.dev@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=kmanaouil.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758643004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RAZ4THQUhLp/jCSZc6k8pRe3JJ30LyWIBv7Rdm7k38s=;
	b=u7H/T4owRw/rJZ1Nn/DJ4HqKb7j02dba8rE+zHPPx5PeICTgN4lbHSOC50oSyZhX2kYBav
	Vzl1MhvFxMnQvP9HunvdzFTJfagKLfMRgbjWOLi4fW0kmBgQlC6OXM+EvpVXHolwK+gTQt
	TbwKAn0JbyGKAh62ruFkZfzEwMJraQ4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758643004; a=rsa-sha256;
	cv=none;
	b=3TbMgEtbWNFpNWF4xnxZkLxMy00Q2QfPfQwKqQNzfrId5W3LdvCQi4QOvRK1TqD6axAvGp
	1+67VVLfm4Eqge0ckWUicoxZrxfjBqAnXThhTpb/A2zkdX/fXD4ckePTRCcmeARqkv6aUX
	bN/6gxGqv/ivCyeuqkWQJodTbLJ4Gwc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mQOLoWOG;
	spf=pass (imf12.hostedemail.com: domain of kmanaouil.dev@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=kmanaouil.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-45ed646b656so50639275e9.3
        for <linux-mm@kvack.org>; Tue, 23 Sep 2025 08:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758643003; x=1759247803; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=RAZ4THQUhLp/jCSZc6k8pRe3JJ30LyWIBv7Rdm7k38s=;
        b=mQOLoWOGDrWF/a7hDVd+X5o9n/ya91y7WLwwD2HcgAufDR5m7N+eG7XfOFwP7eH/9+
         oB66UKjeomGejDhJasQbPOIccpwCfaPuh9632ynYLFVR563oA8lXiQWTeSrdc3U5Z5pD
         8/OTfiWNuntB0z3i4zMCorexOxAF9vMTBnmXLwcJwds3YXe0y8hbbd5AGthPoL8pVEsU
         T3Fc9wP8Ynjvm50MZ/zayGvpyHqgsvZd9aOpt5W7kg06oRpe50wLXZr0yzzl3DEvYnT3
         GSAyXhpCXFBi+nAwEzvFZPwWoDbW+mYsBvdxIM6ZX3rqoMmvHWgj93wdi/TWmJwOvUON
         djPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758643003; x=1759247803;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RAZ4THQUhLp/jCSZc6k8pRe3JJ30LyWIBv7Rdm7k38s=;
        b=VOiGMgN1Vawh138VA50O7lqwNq1jwKiMMaCqXg0stALcyzFCrvIHBs5oxHcRXEh6EX
         xXk0+ELDrIcfcvd4HJKSmqHFJSgv5BPrLeTmDIkYOTIW8SsUutJ/cY1EdVg31GK6bkgB
         2ahGG9uB1BNeAaewbrwBxaktNkE+mnU9YvL9cmj6MIXM23KjnuLTvlACUBU7XH72jJp8
         yHwI/ieByD9hqMtMDxMbIoyY+2PAA7Tr2Eml6oPvDVDfXb5uD2InDWlojxJQHcr5DoPD
         h7V67exQnetDRnvKYt4kPZRYY6uJrLxpVPEfqr3hool+PL9BgfZ0iW/p3JTjzP0+HRWB
         2AdQ==
X-Forwarded-Encrypted: i=1; AJvYcCXg0Nvh10mrHBJ61zocTdkH4BkiXHvKrY9zSCcwQHJj1ycLrUGXX9GOPpF6Yj1bmYowD4xEYqkSwQ==@kvack.org
X-Gm-Message-State: AOJu0YzKslgll73QQ0CqfycEEQPqag4eg1JIH7eUR4m/WWCxbeFopWLC
	dp8jhCMVHGy3r/fg7Y6XoEMojfE3mihbrJ+UPOvaul8yWXHC6dtQbnsD
X-Gm-Gg: ASbGncvfjVIKG9PaUQpzrK9KYQgduyu6D7ctB1+qTnvxsJbK+VyMc8HuAjpIHxnDkF7
	heHjQw/VVuSZ/1vMtqL7Va0MzJAJrXaIwNvq9DpVoWrGU3fD4kpxzxBc9w4A91P23UMVTbGuKlO
	UHLTUOEPGff5KZFG2dTu7EUfsoyKbfZNpH7dR/lm/mwv5mODMHDdUpC73tJu8qa7Vzwrw6oIo4s
	2HWqTDw9RgRGQEdNjb+7nigSass9MsNunawbFoivQEplttmHp0hwO4PgcxWM3elihNeMuJTZECa
	huiXYo0n67I6155BRvhJq3nYiPOEbSCY15WWibkgqVKdvA2uUQ1QKYyZxzIStYh5FO4UCzTYNHL
	Y386+OfHNAj7lM2ZekU4PMEp20hNIfVOwqHStpAhzDmtoBhjQFFwUQR+B/bYOKYe3C6b4
X-Google-Smtp-Source: AGHT+IF0O7ehdqAB1QQAuoqY6m+j/Uj2ZkmlzqIVAVJm6bomKNVnwhf+M+9Mh3XvnYTFUDYTzupMzQ==
X-Received: by 2002:a05:600c:3b93:b0:468:7a5a:725 with SMTP id 5b1f17b1804b1-46e1d975205mr31719315e9.1.1758643002051;
        Tue, 23 Sep 2025 08:56:42 -0700 (PDT)
Received: from localhost (dhcp-91-156.inf.ed.ac.uk. [129.215.91.156])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-464f0aac439sm284469705e9.5.2025.09.23.08.56.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Sep 2025 08:56:41 -0700 (PDT)
Date: Tue, 23 Sep 2025 16:56:40 +0100
From: Karim Manaouil <kmanaouil.dev@gmail.com>
To: Balbir Singh <balbirs@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, damon@lists.linux.dev,
	dri-devel@lists.freedesktop.org,
	David Hildenbrand <david@redhat.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Ralph Campbell <rcampbell@nvidia.com>,
	Mika =?utf-8?B?UGVudHRpbMOk?= <mpenttil@redhat.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Francois Dugast <francois.dugast@intel.com>
Subject: Re: [v6 05/15] mm/migrate_device: handle partially mapped folios
 during collection
Message-ID: <20250923155640.lbtvyi54ueyv2tjb@wrangler>
References: <20250916122128.2098535-1-balbirs@nvidia.com>
 <20250916122128.2098535-6-balbirs@nvidia.com>
 <3FE3F2B9-86F9-4EED-863A-093FE3959B1A@nvidia.com>
 <62fb7aca-cd30-4058-bfd1-d08f78d5c38d@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <62fb7aca-cd30-4058-bfd1-d08f78d5c38d@nvidia.com>
X-Rspamd-Queue-Id: B192E4000A
X-Stat-Signature: m784ztxbe1eapb7pfbfkaazscgh7e337
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758643004-386490
X-HE-Meta: U2FsdGVkX1/4B92IpoZL8HaBg5xaQnU+tt4EhR2cWlQwNdb4oyWkfMfUYnl8weT1NaEXNmGR7KqmjP9XrsItD0XERjn48mFfteERxMVX/5NbuH+jcd3K/75iW810Qlw3MoIFXmQLXSeTzd/UYdhzH1Oq9Tk/dSGcDhWbUEVp/zEy+qLRoMIoue8s9IKbPjYgub/B7AntFAZ8wQbQe9Eo3SC9G1/BI+vboXS2kXjdu3vA1KBhRoCQnZudD16c3YhRryCJ2DVvS42O35YV4t2LEEoNCYZTKsgBlRz+9pZ86BQpnzkwvzT6RmzO9NnufQLjySaqQoYIthf4hzkYazezAs1885/GNpQNOPj6YxWNIp78ZMj4LNVtJWFb7lx6GE8x+R256DAqEtGnRIkl+o4X1INVhQmiu+LbHfumVnhvJhTmrv/k7yw94wq0fLewOO3itsuZ8Bu77gm4Iu/EgsgmwC3XcdXkrSMI1hb17fYMIyu4efTc2vnT0RyXYKR7/+NqKX6Fd3mOVYUGDb4yjWGE5sHKL0Nzqn+6Kdne73njCZc7ENggJvy7HivBJOyAYklW8LCDWP3PtPOWHgbEF+wGL2Bd2g/en7h4SFOQJjinDVwVDKjEZwvd5wOZYJadkJBwIpNxd1P5WXjSMjNgomHDrB2z8Ink21xzxI8qpBbufN6/bI+qu55D5BwlVFNFDK/wHbJRlb0wiAaakcIVTSWcH1NPwcE6AvYfDoUVOwjQY3Ya8/jjlD/t80YIdmElIy+H9qUmYreK2/oLkYFhSBYMTqQsf6yJMdT+1bywkHl+Wh9r9OnZTjAW8R5tt9UMHfap3g1+PraOaPbV0mUBdpgCFY7vrBIykHcsGxM7oRBHt5sB8WRMaoBoNTk1zq7vOKb60ZUxUlEX6oXwAQXD5oHOQ2/zo9Q39BvQCJggGjUw7HWgZvRPrbNuMd1GTnV0GdslR0K00C/ZrzKb+kw6PbK
 uRPR5b7L
 mzUQPhg+8W0yvQhfMXgOTdgE0j2UGAaiscF4wVe6701/YV2abbbs/is1MD+WYxi1dFju0Um3O6RARGhE0nna/3AeWQ3ufCySTSB8pbM65jOmE1hkcReZ+7GEwN3uXjvV4AVkZz7M+eFprXxm3+i4UCQOrR8D/pKgaJ/E1f11OnpKVwnH91CdI2i7F0BaOIfKWuOx9FNn8hmtmzTA96DJ7anpgVaXEOBnL3Z6iV+I4OkGWq/u925d3Y4yDZkAbGcKDtAFyOZcowXncEYLjQZZvANtMzZRfVt3PmT9rhwsP6dXkKbs4wY+asRX/muzZq9iKvWCEnEaVgbyLEjw4X69RbmNqLqqhWxzad8X9sKyFo4DfjEZIxI7ULOVhgKvZqQn2FPCC87MNedQLcqinrfYLkAV7FYW/s5NfMqaMZwczQTORfdWuK9sIpdrMBxnf2srE5mYi7oRZyXydeJiysxVPsvREYOF7/n2hs/PwIEzeodwSVOwPrZotQp6VU3OcilJdtATDzRacEBJwWl/EkG/uMcI9RM/WJLYDQcuDI0hoTIgB526yFVX2r5YCMnPqbJXfvSmhQJV/XZdpbamgvVvsKSCvlo6J1xqxj8uXDVrPiAR+yVbDqAsISgg6nbec9F5nky4sKtOlG7hlbfIYkKPESlsgdtF02Msv1RUCJPQRu++nAO1tG9EsZjOREGgqOosyLVl82IRzw2FfuiZMAbUu/aH1MPq/iU7UExjiRgw12NZKolKfNjOV5Y1cNLQrpw8ZU7U5ulO3hSLKQyyhH8/mcGX6ac388ICWWVEDiN0PyCt2D80IrOFdWJu2+Z8WtxaTQzCw1Z9JAQuBqZouHYUPk27+dvwc+Iky8CillZFHACQBiLb22Bok65ztFLnlf3yF/l+CPxGGOzMxr3dGwDEEXnzFu49Q7RSK8qA0dCLfxrpCaYV1Io8VJV7GdepdU8+8Begb6Og2GuAyH1oudVQe27DMAbjN
 R06+wTNp
 7wDpQQLB+bo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 23, 2025 at 01:44:20PM +1000, Balbir Singh wrote:
> On 9/23/25 12:23, Zi Yan wrote:
> > On 16 Sep 2025, at 8:21, Balbir Singh wrote:
> > 
> >> Extend migrate_vma_collect_pmd() to handle partially mapped large folios
> >> that require splitting before migration can proceed.
> >>
> >> During PTE walk in the collection phase, if a large folio is only
> >> partially mapped in the migration range, it must be split to ensure the
> >> folio is correctly migrated.
> >>
> >> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
> >> Cc: David Hildenbrand <david@redhat.com>
> >> Cc: Zi Yan <ziy@nvidia.com>
> >> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> >> Cc: Rakie Kim <rakie.kim@sk.com>
> >> Cc: Byungchul Park <byungchul@sk.com>
> >> Cc: Gregory Price <gourry@gourry.net>
> >> Cc: Ying Huang <ying.huang@linux.alibaba.com>
> >> Cc: Alistair Popple <apopple@nvidia.com>
> >> Cc: Oscar Salvador <osalvador@suse.de>
> >> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> >> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> >> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> >> Cc: Nico Pache <npache@redhat.com>
> >> Cc: Ryan Roberts <ryan.roberts@arm.com>
> >> Cc: Dev Jain <dev.jain@arm.com>
> >> Cc: Barry Song <baohua@kernel.org>
> >> Cc: Lyude Paul <lyude@redhat.com>
> >> Cc: Danilo Krummrich <dakr@kernel.org>
> >> Cc: David Airlie <airlied@gmail.com>
> >> Cc: Simona Vetter <simona@ffwll.ch>
> >> Cc: Ralph Campbell <rcampbell@nvidia.com>
> >> Cc: Mika Penttilä <mpenttil@redhat.com>
> >> Cc: Matthew Brost <matthew.brost@intel.com>
> >> Cc: Francois Dugast <francois.dugast@intel.com>
> >> ---
> >>  mm/migrate_device.c | 82 +++++++++++++++++++++++++++++++++++++++++++++
> >>  1 file changed, 82 insertions(+)
> >>
> >> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> >> index abd9f6850db6..70c0601f70ea 100644
> >> --- a/mm/migrate_device.c
> >> +++ b/mm/migrate_device.c
> >> @@ -54,6 +54,53 @@ static int migrate_vma_collect_hole(unsigned long start,
> >>  	return 0;
> >>  }
> >>
> >> +/**
> >> + * migrate_vma_split_folio() - Helper function to split a THP folio
> >> + * @folio: the folio to split
> >> + * @fault_page: struct page associated with the fault if any
> >> + *
> >> + * Returns 0 on success
> >> + */
> >> +static int migrate_vma_split_folio(struct folio *folio,
> >> +				   struct page *fault_page)
> >> +{
> >> +	int ret;
> >> +	struct folio *fault_folio = fault_page ? page_folio(fault_page) : NULL;
> >> +	struct folio *new_fault_folio = NULL;
> >> +
> >> +	if (folio != fault_folio) {
> >> +		folio_get(folio);
> >> +		folio_lock(folio);
> >> +	}
> >> +
> >> +	ret = split_folio(folio);
> >> +	if (ret) {
> >> +		if (folio != fault_folio) {
> >> +			folio_unlock(folio);
> >> +			folio_put(folio);
> >> +		}
> >> +		return ret;
> >> +	}
> >> +
> >> +	new_fault_folio = fault_page ? page_folio(fault_page) : NULL;
> >> +
> >> +	/*
> >> +	 * Ensure the lock is held on the correct
> >> +	 * folio after the split
> >> +	 */
> >> +	if (!new_fault_folio) {
> >> +		folio_unlock(folio);
> >> +		folio_put(folio);
> >> +	} else if (folio != new_fault_folio) {
> >> +		folio_get(new_fault_folio);
> >> +		folio_lock(new_fault_folio);
> >> +		folio_unlock(folio);
> >> +		folio_put(folio);
> >> +	}
> >> +
> >> +	return 0;
> >> +}
> >> +
> >>  static int migrate_vma_collect_pmd(pmd_t *pmdp,
> >>  				   unsigned long start,
> >>  				   unsigned long end,
> >> @@ -136,6 +183,8 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
> >>  			 * page table entry. Other special swap entries are not
> >>  			 * migratable, and we ignore regular swapped page.
> >>  			 */
> >> +			struct folio *folio;
> >> +
> >>  			entry = pte_to_swp_entry(pte);
> >>  			if (!is_device_private_entry(entry))
> >>  				goto next;
> >> @@ -147,6 +196,23 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
> >>  			    pgmap->owner != migrate->pgmap_owner)
> >>  				goto next;
> >>
> >> +			folio = page_folio(page);
> >> +			if (folio_test_large(folio)) {
> >> +				int ret;
> >> +
> >> +				pte_unmap_unlock(ptep, ptl);
> >> +				ret = migrate_vma_split_folio(folio,
> >> +							  migrate->fault_page);
> >> +
> >> +				if (ret) {
> >> +					ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
> >> +					goto next;
> >> +				}
> >> +
> >> +				addr = start;
> >> +				goto again;
> >> +			}
> > 
> > This does not look right to me.
> > 
> > The folio here is device private, but migrate_vma_split_folio()
> > calls split_folio(), which cannot handle device private folios yet.
> > Your change to split_folio() is in Patch 10 and should be moved
> > before this patch.
> > 
> 
> Patch 10 is to split the folio in the middle of migration (when we have
> converted the entries to migration entries). This patch relies on the
> changes in patch 4. I agree the names are confusing, I'll reword the
> functions

Hi Balbir,

I am still reviewing the patches, but I think I agree with Zi here.

split_folio() will replace the PMD mappings of the huge folio with PTE
mappings, but will also split the folio into smaller folios. The former
is ok with this patch, but the latter is probably not correct if the folio
is a zone device folio. The driver needs to know about the change, as
usually the driver will have some sort of mapping between GPU physical
memory chunks and their corresponding zone device pages.


