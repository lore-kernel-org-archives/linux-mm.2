Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 197FBCCD18D
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 12:23:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6368A8E0105; Tue, 14 Oct 2025 08:23:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60DF28E000D; Tue, 14 Oct 2025 08:23:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5232E8E0105; Tue, 14 Oct 2025 08:23:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3ABFC8E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:23:41 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CAFAC140906
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:23:40 +0000 (UTC)
X-FDA: 83996635800.11.B7E3757
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf13.hostedemail.com (Postfix) with ESMTP id BEF2520004
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:23:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cKWtrWfJ;
	spf=pass (imf13.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760444618;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G4zpYT42/pWjG2wOiPoPN8UFfIlZHUseBg40P2GM6ks=;
	b=XfSbbrbjO86aiIdjTtCH0oMRWXkfXtTqoS2tH251GU4XRIzwVSrT5PjCRiD0I0X9Xn0q0Y
	axiG59Dm2/8+nltzLxKOK3rWT2ZDab7cMoKDQ2lcnMAnjpT4f0n6qh4uBe6mYot9/b210e
	0eg+2qE/sSs8UMNEkf/YSfH+RWg+VHM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760444618; a=rsa-sha256;
	cv=none;
	b=RLrn8XcgkS25vXp48Fbnm9MyDLWPW2HUXUU4hfIG5N9kQz+lbH7Yhyo2MIhoma0JT/tTH8
	170crwQfhVD4nlUtYf2itL/pq74cIxBtLgfuRYl6WmmP3iCfMvuTZsjYimi0MAhse5gDiT
	YeNaDvi5tuAHJXqhaR6SVlz57JkY02s=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cKWtrWfJ;
	spf=pass (imf13.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b3f5e0e2bf7so987279566b.3
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 05:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760444617; x=1761049417; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G4zpYT42/pWjG2wOiPoPN8UFfIlZHUseBg40P2GM6ks=;
        b=cKWtrWfJTuGO7Qq+K6xaUb9wsy7AcqI1B+Opmxk0YLAFFqkSi7j5d/pDY0E1egQYRd
         hOtFWrfy+pkubGU8MGVOAQRheXCYcsINiUGaujyDbeJDzftKL+FQoNywNQS7MIaG/0Ft
         mDUjbOXxW1MPKYwTayOhrIBMVMZPQv/yYYtGTLXQFSvjKO7dykiGxtZrnJ0qgn2XFkpi
         ACy2omTTsbA+9tqs79OMh2lQATaDCoDNV9AQ0KET71i0a2oxYgTILjMO8NezerB6ugTP
         KFTAZYStjKPGqpywhTpaOC91FZ17taVukYnBy5zmFFKexaUYGXmQrXW22ByWwNhMvZYr
         pP+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760444617; x=1761049417;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=G4zpYT42/pWjG2wOiPoPN8UFfIlZHUseBg40P2GM6ks=;
        b=M2nFxQLpWu/Ete5v06uhdXR8LJseExrGUAYvN0jaBLpELA6/D92FqJm7O6HJ+7nTrj
         qahinNVfyQL0E9Hb+FeC/ARxaIy7mo5ju7Uh9Pjuzcu7vLbU5D4FONPYY8VzJrgGk+nL
         V7dqlEYax0GHrvyvsbMa5H9tYJEBCDcODNN8Jv/CLON2ipTwS+ne3b4TnF5+py5SeuGF
         HR65AmuloWASZ6GnrVA2M3XF3VdYOWx27/7GtH5zVZ4d4ne+4PzbvWVQ5hU5bYYjFFm0
         +IBdoPBygeXpMkbsbuk3w4T39kfCN6HzTapgYRMk9iv4mwBEJz9tQhwMxPru+lQLez7l
         X93w==
X-Forwarded-Encrypted: i=1; AJvYcCVSnxwrMLnPdpIa15BZxLUdE061LWQD1x8F0Wfz8hY2YP5feSaEE442AIV1qN/TroQFK4EePVRePg==@kvack.org
X-Gm-Message-State: AOJu0Yy7rlVTJd+5OJrJb4thGsoHaB4ewScdRoYrgPoqfy/8af6ItTop
	7v7pLGBTSYJ1tVHjV2thxo5UaOhVWiF2PwWW079GdAF6HkD1Bh+u9vLs
X-Gm-Gg: ASbGncsIcLxlpWNAsi8E6gqHym38cGafD+4eEDqQqtKqvB1ZY643+vhfwKpr4gGFnkq
	yqeC3paYI1xWeRo6d8wyWKWMy5szVUe36d55U2TzEoPYP7a3qXv/nVzHp3TzUfqdXioOesjbiz3
	XqKuxjVpzE5pbSyID45AHhXTxsDfgwESPAO2mWeqbA2jhG9M4e4K34qqCuMtELdqkWU95Oac8H4
	4Iw1/5pE53nr/alozhtdENDzeTuXSCvhviEcnWwx7d7aOalrDhOUV9jlzlLQsteLmfj4baCLPOR
	yDblkOeFyzVYqcUfA0FRyipOWW9ztTgKnjd7JWWhpQOERjeC1yreQOkCEAduGFyB1VALikzvoSA
	7TB0Kc40kJQ/dsxYp4ZDnV3mvGe5zxwV/y92OUjTuB+V1tsxeyKg=
X-Google-Smtp-Source: AGHT+IHDOAfe4JNqhFSA9gUX7LcGwhfmUpTtqm0hZRNoZ9LOkkInOSpqZhVqzK5eUfW8u4Wf52cxuA==
X-Received: by 2002:a17:906:730a:b0:b0b:20e5:89f6 with SMTP id a640c23a62f3a-b50ac5d07b5mr2495753366b.60.1760444616765;
        Tue, 14 Oct 2025 05:23:36 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-63a52b715ffsm11262090a12.22.2025.10.14.05.23.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 Oct 2025 05:23:36 -0700 (PDT)
Date: Tue, 14 Oct 2025 12:23:35 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>, Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Muchun Song <muchun.song@linux.dev>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>
Subject: Re: [PATCH v3 20/20] mm: stop maintaining the per-page mapcount of
 large folios (CONFIG_NO_PAGE_MAPCOUNT)
Message-ID: <20251014122335.dpyk5advbkioojnm@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250303163014.1128035-1-david@redhat.com>
 <20250303163014.1128035-21-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250303163014.1128035-21-david@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam05
X-Stat-Signature: gd4ak5b4fpg1zccc39tr5hhecgye1xq3
X-Rspam-User: 
X-Rspamd-Queue-Id: BEF2520004
X-HE-Tag: 1760444618-46683
X-HE-Meta: U2FsdGVkX198AhPIbI238bOnGU2OWibvBmy5punk3wLCoB3WxC2DSAilPpUv7Re0RMnoUGrHMuu+4U4PNvFZgaLcWc9er9WQEn5KzfsWOmRp7rln5QnI+PrKjzCwAZLfF8H0wLJdg+Zt6um/n89oweZE2URCx9xlmsz9DpQExd9CeAs9Na7fCCet7QKRzmq128cChqN6hzfjo6jBYs1D8oGHwGqBjv3CmqNPmbcmBw8EtqvSpu++WAmEj+cGHtRRKDu0/f9NiojxugVqPRwGqW8FlmQwcufAueRaHRObudwxgWZvmAbJy+jbM7Rkb1UkwcREC7kzuKuJF1Y2cq8VyjrLq+0Pk/QUhw37fPY5J2idohDi1BwrU9sOKdm9MDwxUGorUHxlP9rIwPnGLP6mJOAgOBR8ZbFdNyyLZ0talfZSHyspg7b7n4y4i5xQJQszdK6YmCtfOVeo86/zkECgOUP/xIbE8QRI45CcraTE5uj/+xUiU/2Ig1/x3ACCsFMKQseT/N0Kz6dmH7/qzOe0jwVNogl2kDAo6QQ0D6hGm7zkJ7zaIGfCheVbv8g8RnvHVNnr6kVTfoGsHbRv5H5S5bMS/1XmlvUh9CbrD59UEiIlpzlpoEMDU3Wdz0z9wX2ZPOb7U3dcgV9VRv28bjnlyYdCwKPxcnEhK000C4RWpAWlCOX47wsqVCLd4PSJaMeWI5Z1H2vS2uwSR/h6RCDvgHx1Ek8a/y4NDXrCAf7tS2m3uPIg7krdGZMPkGjR0V7OtGX3HG4rX3mgn20jnE6GTj4vLDEIsZPtpo3yGF3YBIRZnCziiTGPChd33zF3sAp5/hC4CJVOAto7mVAmCY+haPVojcGvUqW6aDvhLp2NZU2rzeKEU5aFr1PWo4ipFroXFSgGKCXsWc9p7/EL/x2Gn0CiGZvGKb69m7JNFhotLOZOFamVNiP65lfKxNU4folDvdAx52hOo1Epphqb8Tp
 2tSJ1H4e
 UhR9mSC2frpF5OFWRYAe5KrEh6d//0CIdfG2xyEEuVZLm8WBOhA7/gVZMXtUYfMv9bFnFiy6pJ+mBGch2v+0QZe8Vvw2C/bbVIZl14LoY9cUcwcEsYSnFttRjn1SegFC21hx4Z2IVsMC1D7qITd9Y931lZ4HB1OgG0fYtcnfeGPRWkoVYsbXsOLcoHsa7KRFt8lH+8+BVGJsJvdY1dMro25SE25onlDi0d6iY90JrhNTDdxtyiWucVYTddA+TCI8J/iu6enDyHSNoIIrsmZnvMan6dxAByiYUnC9+PB8xbYTJrjS4PJad1UCWin7/S3O+/+AV1OXySsbXt/q6aLvyaOHfKOcxgq02WVgvnUnV0v8YHT1xB7zW67tOC5U+rcD8xdOKVAdh+Xeygy9aLUuvCmrIVDQT1K94YGmiEepM0IZkeBKbMK/oAkHTJlLPMwcQz/z/3aTo1nvScntLwFlSyXWcPkxiAJxsLKItY/THQbpEQHjUEwx8osiGKso8sX3i73lDJmYR0Rg0qzlM0APl8BLg0APL1K47g5B0DWMe37jr3KBO2NtdNQ0xEwAqoMAUpvQm6C8awV3j0qAe6jebEY+ekz7/66iFKYctsoqKNC0xwMEdfk52kFg4aJeV+qqmK9Jqk2iLOGLb0928rq65QXGEFjKG0FE4lPmfy4+5MDcnKy2oHuWL/ZSBHA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 03, 2025 at 05:30:13PM +0100, David Hildenbrand wrote:
[...]
>@@ -1678,6 +1726,22 @@ static __always_inline void __folio_remove_rmap(struct folio *folio,
> 		break;
> 	case RMAP_LEVEL_PMD:
> 	case RMAP_LEVEL_PUD:
>+		if (IS_ENABLED(CONFIG_NO_PAGE_MAPCOUNT)) {
>+			last = atomic_add_negative(-1, &folio->_entire_mapcount);
>+			if (level == RMAP_LEVEL_PMD && last)
>+				nr_pmdmapped = folio_large_nr_pages(folio);
>+			nr = folio_dec_return_large_mapcount(folio, vma);
>+			if (!nr) {
>+				/* Now completely unmapped. */
>+				nr = folio_large_nr_pages(folio);
>+			} else {
>+				partially_mapped = last &&
>+						   nr < folio_large_nr_pages(folio);

Hi, David

Do you think this is better to be?

	partially_mapped = last && nr < nr_pmdmapped;

As commit 349994cf61e6 mentioned, we don't support partially mapped PUD-sized
folio yet.

Not sure what I missed here.

>+				nr = 0;
>+			}
>+			break;
>+		}
>+
> 		folio_dec_large_mapcount(folio, vma);
> 		last = atomic_add_negative(-1, &folio->_entire_mapcount);
> 		if (last) {
>-- 
>2.48.1
>

-- 
Wei Yang
Help you, Help me

