Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77B24CA1016
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 08:04:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89ED48E0007; Thu, 11 Sep 2025 04:04:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8540B8E0001; Thu, 11 Sep 2025 04:04:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73CE08E0007; Thu, 11 Sep 2025 04:04:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4E10C8E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 04:04:10 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BFE3213AD2B
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 08:04:09 +0000 (UTC)
X-FDA: 83876231418.17.3CD39D0
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf19.hostedemail.com (Postfix) with ESMTP id C3D471A0011
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 08:04:07 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L+6huQqW;
	spf=pass (imf19.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757577847;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UCXGwUwpyKq6QC0HqHvB+PlNFDZF/zHlcXjRKnHG9yI=;
	b=8pk6z/Iz4ndIZs3gqhj81D2ewM2rDYvizSqoZ4jpj//KRMWjx333iWaVw+eYjZfYDA6VLx
	FzxG3leLnupj2SKgRhqhOaik0EH6cSDGQAyvnWDA7W5e0Tpw+4mgm2FjVZca86ZstYKNoy
	6Q+ycaOeBGbXm6F2dhsjPq2JsSIWIjg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757577847; a=rsa-sha256;
	cv=none;
	b=sDTA73uoIAtlFmISYpM4fue7C9ZmXAV1yrPpMTsuyk+OMOCYo5KFpkDCpUkzoG3Yrx0hN0
	X9vaZ7J3l5DyXwBz7J9kT41TJ1P2SM6dlzLNL4GtiiqHfRJpbtx/1oEgLIFRG93tQ26dAC
	pOZfnmz5KqUryfrsGP932f1IP2yavTU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L+6huQqW;
	spf=pass (imf19.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b00a9989633so91634466b.0
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 01:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757577846; x=1758182646; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UCXGwUwpyKq6QC0HqHvB+PlNFDZF/zHlcXjRKnHG9yI=;
        b=L+6huQqWvUOz+pMPgVlo8GrFWGUDEbo0BGoBCB1GgFYTdvM0VhZpI+Yz7IYUIRTkuO
         Hzna3oK1OIEBqNHsxCYMr4+Yspmiyr0nMxCmRG22x2Q0XjbjwWjXJWltsxEnzVl1FP5d
         iJIS/47trQloiJOpmbXd6FVbHCM6BAY6Ct4C4bUAwYYr7mHzBWuxpXofhBso9Kr/Kgc/
         ZfQAa3yIOOmFm6DFMJbDDx/FyBkRI4b89zlUOSMZKO2846MIEcurjV9xFB8BB6u4gwS9
         WvYW5TZe5vrzNbfCFXy+sdTDKfbW+Rbx6AkcBbS+cgLeKNtGIYHOwZmOkoPdblwlM7rS
         7HOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757577846; x=1758182646;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UCXGwUwpyKq6QC0HqHvB+PlNFDZF/zHlcXjRKnHG9yI=;
        b=F7bzaTdKK/ENBQXeDFybSEtfVPscE12qby0LukC+LWSvQDVzvO1rC3d5xIDv4VuegZ
         Hw7zzoKVgibsbo+PtMYuTlpU5j87gflz5jhOFnxSpzfgvCYdD7+tIrPxcQtml0kK3Rh+
         ZxHbxa0Hpw9i3IttzEhDk6WMAK84LWXDFXJRVXo0lyV5JI4/r5n3OFrVfsfY8eO/3zvM
         oHXu1slkXQm8N8essGvridTT//pRZWL7jhkmynkempJWUnyI+O7IPbVXEGJT8mmIEy6v
         tLF08t77AHcmZK3Fn63h2kLV7lviV+jweNPmy4M3w0+SL7BnAwLKZqtqdQ0at59A9nX9
         votA==
X-Forwarded-Encrypted: i=1; AJvYcCVw4lLhSxS1K2m9vDwZXlcY8jiRLQGDF4O3yIBvRhkvu09Cj1mxjxBJTSTzneJtq5xCfFKG9hfsAg==@kvack.org
X-Gm-Message-State: AOJu0YxpMeCFiKGmPNLJGyGGbzsovNYO0Qvg5WsjjBetE8gBFC9kyk6O
	3uYTiCc1jpR1TseKZKtObD5GrcvfqR+gybT+bPFbs8LdTmikTN61b5y1
X-Gm-Gg: ASbGncsc6CzuGSaCKBEotlN1gEyunMNy8ogL6SvMKW3VMIq8NQz8DUTjy+vDCFu/yDS
	jQRDZCRgtis1EhoFjJ3IMJI9smYQPL6pOLi3SlTVVto9vyg0Oc+O1KT/D5p2Tes32VOK3vUs86r
	+2dSTjfnn+85E3DysgvB8pFymNu5gmmJR3WNMh90dcuYHAqKp8NrfNsJDJ9LwvvcQr6W0UD/K1F
	j+gLPx3kyEZWPOdLXMRARm/rUOcAnE2krZhlQRbUVGt8k6Ryr/gDJtjeS7UjFxs1oTif78dV1D2
	N28al2VropDIzAwiwh/r7MI+s+QZxDt2ARM8ejeELBqxRlpigb3cOu4IYyQn4x/Zqruh424jXRg
	sejaYrVTN1xfKqiN37VaLsGkSkA==
X-Google-Smtp-Source: AGHT+IEcMSgKo4+sU99486bq3+Fvkta2bK3Nuc0JJPNS1zet5974H/X47nBk+8+kC1RGRur6L5MELw==
X-Received: by 2002:a17:907:8691:b0:afd:eb4f:d5d2 with SMTP id a640c23a62f3a-b07a640873dmr285777066b.31.1757577845911;
        Thu, 11 Sep 2025 01:04:05 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b07b32f2122sm75915966b.85.2025.09.11.01.04.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Sep 2025 01:04:05 -0700 (PDT)
Date: Thu, 11 Sep 2025 08:04:04 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Balbir Singh <balbirs@nvidia.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, damon@lists.linux.dev,
	dri-devel@lists.freedesktop.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
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
	Mika =?iso-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Francois Dugast <francois.dugast@intel.com>
Subject: Re: [v4 06/15] mm/migrate_device: implement THP migration of zone
 device pages
Message-ID: <20250911080404.r6vqlhyi7qyjutij@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250903011900.3657435-1-balbirs@nvidia.com>
 <20250903011900.3657435-7-balbirs@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250903011900.3657435-7-balbirs@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C3D471A0011
X-Stat-Signature: kabny8pn1bgxpjw3jy81i5dxr5cyd66o
X-Rspam-User: 
X-HE-Tag: 1757577847-42002
X-HE-Meta: U2FsdGVkX195oAYOU0xlUIb5M6g4T0m0gvnzkpmm9B4qd8G1IhlCsYck78IzI8Zeo48H4Iiyh1q0mTQ8Y8rD1kCbDzlyVJ6/N/F2c7JytYKNZpwpBBOFXSOqJHeve3AmdSMOh3R+Ra818qMtZKi6/hQmZ6s7anciv9DfeqNCL9+atfFGPEkaW7ESTN1tYDIdsKseyd6ZjytMC9nIqdwGumGdhWWfs6yFj9EhJDgOFAJ/NATWNqSlphyCLMS7yB2B0A8lQ6IgQRdnDHdNdusFFlTWW0xllL0Z9nT0AlyYr9at4sAQBTDVAPmT5qAkNJSmMNRhKzqICTuz2VTth9CbkLdj+zWmoD+/O52lYqolNdkjR3KNYbzwBxhsCSim5/2YliM/DIwilhzrSuLF2+4I9C+xLWq7+MZ9IDTTMGnieyBvoIOfFfCtxMzL7P3g75Ew9XzAKZ+0F9j5pniiJmLl4I3QTVNgivypsXTLqjbc2BASQYlRFKFAWqVIrtF73ovjw29QHVsef8pXAw/ajHYdWU2QjY785CtgCsAWirxqltVthBIOU6rcBEbNgssi/gyohVsA6zbHe0D2tMG7w5E+43oacb1PP1FcqKin0O1QwsOKds++q+7d4J/r/kpeOuYiz1maDFghhxpUlF1010jkyH6WQ6RmE5KCgg4+41YTz1cr15Wzhd3tTOzPlBTTzCJPQhUVn2DYJwnbs8UNXhndswb1Rz1+Chsr2n191tmqh5xbsiwx5dA4v6+cS46Onrh8caWZsnGiY8OjKLqARQj7GSSBs8bqAZpqho+K6hdAA+eWwDD0JuerBgaw+Y+wso5PHJbS8TogxqXjQI7qgRXqn/ujP54ckCoV76wQZxlRPLx7KESYzwngY5n6cBn9ZvpRIqjyTCwn98J7Mx80qrWPUt4/c0dRGHDV8EELngWHdJ55Wwb80Hy969y+ODDWJh8xUgs53AgQjuwQ0RDZUdJ
 hgfRtDxQ
 KBZQezhmcl4+cBHTAthLkFrzjMv7nCw48FpVum/wiXUPYZvw+syKPXqVsDgrqkBZtsSpnzxikosgTR5b2KGAa8rrN6ZY3md4FQ914Ay3cbGIRs4Gcx7yMn+Z3c51JHFTLrInv0TGxWv2NcTevaoF3EUbDYGmB//SNuI0x2ekI9WXo3s7KNApX8y07hdKPAFDSBC991//ek8t7ru+bwwN6gmDFEW7YOcu+2nP96YDrgl5RfTJA2nj4ZmUjK/z9Pz8Mi9kr7O2BcSlArRUTsRMwo5QCLm5T2NQrzt3wahSUjAW1Ma1rn2BSxfXY3cdGKlXBeiRUXz6Q9M7fbPufXZhvkESKYLbegQwCkhQDytO59Ingrg0sij342VCy+NASJ6xQ2++W9odjGUb/oWgspcHCKMKjKxkVmBWqGCaGJh25KwGDLFejugx6YkciEgQQnaPSHYshInWilgx4cG8KyYEsFepwKQvFC0hsPQ3LVIY9E7TBSeWcTP9gf56qzUiq62WNO+Qw/sK/Lh6aAziln7ItG7gFOzxZ/bUMKYLX8KW+j5rEF1qLyJHqNBbc2JfjOsgFRXSZ3QLx2xh5u6M+vXXGjIm2W1GsD40dVoFg/TABk+GtRmehu9Qb0BB+/9TwtLpLs8OMhoOw2z78CqOP8xP4939qENU2EEGzR+r5qWVaNAHU/LR5GN8q0qYuthjcc4SeS3s2kcX5qqiMx8ZWDFlAqY3Yh3z6QqrHSwTprmOttGXCMAtgnLrup1MkL2yxE8rgayaI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 11:18:51AM +1000, Balbir Singh wrote:
[...]
>@@ -836,15 +1107,47 @@ static void __migrate_device_pages(unsigned long *src_pfns,
> 					migrate->pgmap_owner);
> 				mmu_notifier_invalidate_range_start(&range);
> 			}
>-			migrate_vma_insert_page(migrate, addr, newpage,
>+
>+			if ((src_pfns[i] & MIGRATE_PFN_COMPOUND) &&
>+				(!(dst_pfns[i] & MIGRATE_PFN_COMPOUND))) {
>+				nr = HPAGE_PMD_NR;

This one trigger BUILD_BUG() if !PGTABLE_HAS_HUGE_LEAVES.

>+				src_pfns[i] &= ~MIGRATE_PFN_COMPOUND;
>+				src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
>+				goto next;
>+			}
>+
>+			migrate_vma_insert_page(migrate, addr, &dst_pfns[i],
> 						&src_pfns[i]);
>-			continue;
>+			goto next;

-- 
Wei Yang
Help you, Help me

