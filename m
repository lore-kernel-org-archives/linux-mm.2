Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C673ACA0FF2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 04:40:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA2658E0008; Wed,  3 Sep 2025 00:40:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2C198E0001; Wed,  3 Sep 2025 00:40:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCC898E0008; Wed,  3 Sep 2025 00:40:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A64928E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 00:40:53 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 04FCCB99F5
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 04:40:52 +0000 (UTC)
X-FDA: 83846688786.07.812D642
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id B8642C0004
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 04:40:50 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="g/0NYcxN";
	spf=pass (imf10.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756874450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nFKFd7BRRcC6ayNrWC4OEZv5/Y2ehiWbsueptb8aZyE=;
	b=Q7CagkChqXiaIjktzDRRDNqoYPm/QY7k+/EFQnTp2NJ60DgjZzHiDhqZyqHuFi3p4CTJmL
	wa2TuQpqd9S2xFQBo4/rMKnbJUJ/khxZI2/pN9aARbUZcDG/Thoj8lZEyEAPIUTJMlAZvW
	tIcHRfSKis05X5kvWBAJOqjtobagHtM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756874450; a=rsa-sha256;
	cv=none;
	b=73s1hLWaXBc9gJeFPCyeF+bUb9Sdm8I8Li36nyE20Pn7wOyrjMHVMXUqLaoDgs+YUTY1xw
	6XFszcgiKe8RylAD7mVkzLvDNgV86qDKnPVMnXgDSTQZ1boK5A2ynXVCuuhtusaVMzOSij
	20nyMPxufWUbkw9rpLwKJZ7tvTDmOcQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="g/0NYcxN";
	spf=pass (imf10.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756874450;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nFKFd7BRRcC6ayNrWC4OEZv5/Y2ehiWbsueptb8aZyE=;
	b=g/0NYcxNSEr4GgYqXVxw9p+peUkNR9aQ133p1ox4aYurC8k5T1oAtJ+1mdRml9O6ZXmJ9r
	vwQUH+o4z7IfwkB1CNqOsJAXI1o1j2aWVO0hx9hM4hv1T+AsqqnhXr1IkVF3K1bHQu5qjQ
	Ay+cx/MWO6PSfbR9V8+VnXHiBQjWVjA=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-679-zpsSxfeUOVawH7u6NeGAVQ-1; Wed, 03 Sep 2025 00:40:46 -0400
X-MC-Unique: zpsSxfeUOVawH7u6NeGAVQ-1
X-Mimecast-MFC-AGG-ID: zpsSxfeUOVawH7u6NeGAVQ_1756874444
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-337f3ee628eso7600731fa.2
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 21:40:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756874444; x=1757479244;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nFKFd7BRRcC6ayNrWC4OEZv5/Y2ehiWbsueptb8aZyE=;
        b=fxy0eXN0DnMs93rXdoMPr49FPQLXacQaYkezLN0+gmu6k//Fkx5pPermpPQTWyZ3MX
         HKY0DV5mlDG6fgytgmo5RiwqQgeTbx8nEovX3Ek4vsHvSzexm0OyyVEZH5oVEu13fWXS
         YV1C8mgsEvLtDMtWzqd0Rm8rz/M6CDma4zG8uQBGFkNKGajnh19Kh90RIeS57u6UWged
         C1WnGnIpI/bEE78dsPXX+BffM2TpHoI9wrEmsU29b9h+Rm2HrJww72Ux3q2rNrkxoI2Q
         lCMgD7Q4wT26nILtm/lkT0fa2hTn8Q1ZbeqNnXm/XD31mwlTZPJl9FSHCXDaTD7J1VuC
         /0MQ==
X-Forwarded-Encrypted: i=1; AJvYcCUetAvRrn8fNNk4teXyTNqgqWhEKWTiDsuGnJG7HXTdVDMCYdfxHoLlAxRjykJVMUhO+iFGmEhFnQ==@kvack.org
X-Gm-Message-State: AOJu0YwtJ8U4OOGmfiucy2fkbiMaTShfAZjD0nlsqsFhSs5zNktC3Fm2
	0SChOjyhWcHJu7J6JhVL1zSWk7CO226aNs+SVOZgepxG6V4b+WPaG7QMNrJsmG+gWZMxoavKbRn
	SIDH4W5BwzQunX9FaaFcyVDgyl9SwrBGpOTC/Ih0i9IIkRZQfgRY=
X-Gm-Gg: ASbGncvH2IEvWid/nyYnaT+JmJpp3Mrz9Vweo9EdrzHwy/UaTJunDjraS2zKLpmzNGn
	8YfDvKd7PsptlGzAD1CYlxqSeClPT5n+ClC2YnzewYhMdYw77greClKdbmR7Pzo1hzpoaqdPp8r
	fP1XLY9vbwHV0zVT96fjqqtrNtcBXSKUgxHy1myIhXoDK7+pf2VGsMteeMOH8+Chl17EKgMEaqc
	QlUbmwp8s1YKzReQtirV++E50em5vOfxqd3GbR7iSlJECVSzOM24sLBtC2AfX1LHzj2h5in/YUW
	cUf6lBIy7n8JvfJMsfFSGI1WrxLWhyvlXqxP7UlN3jpjI4Vp+8DnClWiLLakY5DCow==
X-Received: by 2002:a2e:a990:0:b0:336:e1d6:8920 with SMTP id 38308e7fff4ca-336e1d6917cmr23417411fa.31.1756874444351;
        Tue, 02 Sep 2025 21:40:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEB9QYuRkeTjERXflES7M4qiiN/3BjWaFP3YSaUZpEcyOTHs10oLde5VZHbPVXv9pkoXi4/XQ==
X-Received: by 2002:a2e:a990:0:b0:336:e1d6:8920 with SMTP id 38308e7fff4ca-336e1d6917cmr23417061fa.31.1756874443807;
        Tue, 02 Sep 2025 21:40:43 -0700 (PDT)
Received: from [192.168.1.86] (85-23-48-6.bb.dnainternet.fi. [85.23.48.6])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-337f4c50f79sm7951591fa.1.2025.09.02.21.40.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 21:40:43 -0700 (PDT)
Message-ID: <ea6caec5-fd20-444c-b937-6cab61198c46@redhat.com>
Date: Wed, 3 Sep 2025 07:40:42 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v4 05/15] mm/migrate_device: handle partially mapped folios
 during collection
To: Balbir Singh <balbirs@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: damon@lists.linux.dev, dri-devel@lists.freedesktop.org,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20250903011900.3657435-1-balbirs@nvidia.com>
 <20250903011900.3657435-6-balbirs@nvidia.com>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <20250903011900.3657435-6-balbirs@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7cCs_ZqSpmamF0B7uZw6yx1NqITczt0RmajcErd-MgU_1756874444
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B8642C0004
X-Stat-Signature: ep7itf77hjw7izpe35ymiaypr1yrdcib
X-HE-Tag: 1756874450-958997
X-HE-Meta: U2FsdGVkX1/nTJTlA6mA0hqwfw6crCv2qSYLvGHB13QSNtUFg4vd3whzg3/9sdqFjl6fWXQHVrmmDroQ3CXFQlYowrcRBDjNXrPpDNTrGcJGZXSVPt6T2t3mfq3/Jycrr+9PaXnB/Dsn/bSqpnhonPYEKcufu+VfDHzHyDx2dR646zwPDIeBUzvkACW9yvHMfojHyUldoLXwlE0hfi1VMwOt3innFhQlv6DGw0P6WRQGs/jkIB3TYK/DmAKWpgYY2IrQNQCAApie0nJbx4Z8xhr+EFl7HlH7hgsSRgDsHXw7f5HT7LA2g2VNSRSiXeA3hlVa5E+EcY3dFlxZr/oJbUpARYTKiFLOOqm4XpO75oz2dwtgLoKSNLKs2NImJc1z0KSt2c37HIuyUYg4yMfRgu/JgIgNvuFoJQhzGz3DCZQLeBbEQg8JWGlruSXDAbH+LHkhUfGhqQRxGSb7glyFlhDfu0IAS7LUhJGsnc7gxWfAOVbV7MEhcx2wKO3pRJLrPBUcefw5+8DphpCHveRbkucRinSL24Og38DG0v3ut/PDHEkIf94RGve44ketK89GJ5ZuXA18iyFYfS9hTUkdaQlt5C7kSYr314ovObRiAmQZnzITqOVtzZOdI1fZ4Jd53hzX2pxnNSB29iRk+/0HZqXhyrx1vsT5QkFWOVXJ4Dgm0iD53O8ico1Ma/IlqljLbhwea8B2gjzltyQ3R4ppTbw9NCJh8a53fXIe0xRZhF3/nySP8MeO0hEWclxvhEm5Voc/sWnvW9vQTu1tOTRQASeMhhhHbRVp+r0eIiXFnHXZItEVjTdK6UpXqQijuX4lomy5nkc51ltaEzKW4SiGbFaEvM4vuWOdlxOVlDSlPewWjyuyF6hh3mRwpP9AaVhc3iCKP3DRbg+4yx//8u38fqyN3TgVQLryLka5LrNGp+IBY4Pg1FSmI4f5+l345VY+hprDGz6VR52Xi8LyxLq
 +qrz1+bG
 SrcD6erdVZ1Pb5kx5fIRI/shWBn98cajqc+MNka81tTRTxnfF5Ul0BOjt+w3Jz1Cu5uYs/SW88+LJtQx+Q+IhFvmBufFcq82ZqACwnF4FNg0F3hVg19CKfw5wzmOY/WusGnSha6tdwddtRm5DvBpoud86cAPgwGQKphfMjv3oj8CWZeFoKEzGveb7iU4w0j2e8vBMn4sHbWZMlF25BPFIEtsYOKywVgdEq5jnwApI4xgBtUp2m+Kz7a571plPHHusAf7/cUF83DFDB0NLv3nRH7yu4C5awvwEM2v5dIr9/w4f/lSHqPKjJtzPYmAXmVw/K1/NOOS2n5eg2ocN0jL4K4rrdp9xFeEbZ/BxQVJSRbe0GsptjMBZwijh/4GgoYgCFQg854yWS2gc0u4XnefNs7ZN9SHAvka/6M9YK7+YM8ibLCI6npbJgpN77XMZZfka6B1JFt4gLP8Q3dqNt09D89ErI4+tIxP5EjJBU4J9EeOIaEltITiMo3ttcir0M4u4UayUxu8rXwIC/5gs7wEaQEEYgiqzqTJ2dcFy1qHrSZIF0UGliOh7wiYIfrXXpfqNlsY9u9MtNcaLpPLlJUySZDaLiAuNWrue+ny74eLWUlkJvTgZQkbsxknLibtPOzCmANTKupUXD3CLBHgj6MIFQVijivRzmpy8pkMXouGuo2FJ2YYFazJOZoDSpIHqzKVRfKw9YIoAANHMzY/i6fpN3LbcDRgsdq9QMwrkQXGf3UoMZQY1BIsUlfnT7jTjTCfdN+2y9b6yf1Bj8pqanau4oaAu86FQw5ewNAtLbs9XVBPKJobCLxeCmCIE0lXlNQ4ERqAN9+p9OlCXdU0trd/agiw/QOxWmL8ykhPg79nVoFM9wITGT3Vlr+RtQg0mayU85ceFH7xIedTS7rog42DmqqmBRiuuFmrAqJrF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 9/3/25 04:18, Balbir Singh wrote:

> Extend migrate_vma_collect_pmd() to handle partially mapped large
> folios that require splitting before migration can proceed.
>
> During PTE walk in the collection phase, if a large folio is only
> partially mapped in the migration range, it must be split to ensure
> the folio is correctly migrated.
>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> Cc: Rakie Kim <rakie.kim@sk.com>
> Cc: Byungchul Park <byungchul@sk.com>
> Cc: Gregory Price <gourry@gourry.net>
> Cc: Ying Huang <ying.huang@linux.alibaba.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: Danilo Krummrich <dakr@kernel.org>
> Cc: David Airlie <airlied@gmail.com>
> Cc: Simona Vetter <simona@ffwll.ch>
> Cc: Ralph Campbell <rcampbell@nvidia.com>
> Cc: Mika Penttilä <mpenttil@redhat.com>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: Francois Dugast <francois.dugast@intel.com>
>
> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
> ---
>  mm/migrate_device.c | 95 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 95 insertions(+)
>
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index e05e14d6eacd..e58c3f9d01c8 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -54,6 +54,54 @@ static int migrate_vma_collect_hole(unsigned long start,
>  	return 0;
>  }
>  
> +/**
> + * migrate_vma_split_folio - Helper function to split a(n) (m)THP folio
> + *
> + * @folio - the folio to split
> + * @fault_page - struct page associated with the fault if any
> + *
> + * Returns 0 on success
> + */
> +static int migrate_vma_split_folio(struct folio *folio,
> +				   struct page *fault_page)
> +{
> +	int ret;
> +	struct folio *fault_folio = fault_page ? page_folio(fault_page) : NULL;
> +	struct folio *new_fault_folio = NULL;
> +
> +	if (folio != fault_folio) {
> +		folio_get(folio);
> +		folio_lock(folio);
> +	}
> +
> +	ret = split_folio(folio);
> +	if (ret) {
> +		if (folio != fault_folio) {
> +			folio_unlock(folio);
> +			folio_put(folio);
> +		}
> +		return ret;
> +	}
> +
> +	new_fault_folio = fault_page ? page_folio(fault_page) : NULL;
> +
> +	/*
> +	 * Ensure the lock is held on the correct
> +	 * folio after the split
> +	 */
> +	if (!new_fault_folio) {
> +		folio_unlock(folio);
> +		folio_put(folio);
> +	} else if (folio != new_fault_folio) {
> +		folio_get(new_fault_folio);
> +		folio_lock(new_fault_folio);
> +		folio_unlock(folio);
> +		folio_put(folio);
> +	}
> +
> +	return 0;
> +}
> +
>  static int migrate_vma_collect_pmd(pmd_t *pmdp,
>  				   unsigned long start,
>  				   unsigned long end,
> @@ -136,6 +184,8 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>  			 * page table entry. Other special swap entries are not
>  			 * migratable, and we ignore regular swapped page.
>  			 */
> +			struct folio *folio;
> +
>  			entry = pte_to_swp_entry(pte);
>  			if (!is_device_private_entry(entry))
>  				goto next;
> @@ -147,6 +197,29 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>  			    pgmap->owner != migrate->pgmap_owner)
>  				goto next;
>  
> +			folio = page_folio(page);
> +			if (folio_test_large(folio)) {
> +				int ret;
> +
> +				/*
> +				 * The reason for finding pmd present with a
> +				 * large folio for the pte is partial unmaps.
> +				 * Split the folio now for the migration to be
> +				 * handled correctly
> +				 */
> +				pte_unmap_unlock(ptep, ptl);
> +				ret = migrate_vma_split_folio(folio,
> +							  migrate->fault_page);
> +
> +				if (ret) {
> +					ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
> +					goto next;
> +				}
> +
> +				addr = start;
> +				goto again;
> +			}
> +
>  			mpfn = migrate_pfn(page_to_pfn(page)) |
>  					MIGRATE_PFN_MIGRATE;
>  			if (is_writable_device_private_entry(entry))
> @@ -171,6 +244,28 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>  					pgmap->owner != migrate->pgmap_owner)
>  					goto next;
>  			}
> +			folio = page_folio(page);
> +			if (folio_test_large(folio)) {
> +				int ret;
> +
> +				/*
> +				 * The reason for finding pmd present with a
> +				 * large folio for the pte is partial unmaps.
> +				 * Split the folio now for the migration to be
> +				 * handled correctly
> +				 */

There are other reasons like vma splits for various reasons.

> +				pte_unmap_unlock(ptep, ptl);
> +				ret = migrate_vma_split_folio(folio,
> +							  migrate->fault_page);
> +
> +				if (ret) {
> +					ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
> +					goto next;
> +				}
> +
> +				addr = start;
> +				goto again;
> +			}
>  			mpfn = migrate_pfn(pfn) | MIGRATE_PFN_MIGRATE;
>  			mpfn |= pte_write(pte) ? MIGRATE_PFN_WRITE : 0;
>  		}


