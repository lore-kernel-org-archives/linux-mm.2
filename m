Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F867CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 16:25:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 078538E0020; Tue,  2 Sep 2025 12:25:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02A7D8E0003; Tue,  2 Sep 2025 12:25:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E80238E0020; Tue,  2 Sep 2025 12:25:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D46268E0003
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:25:52 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8A9A21194B8
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 16:25:52 +0000 (UTC)
X-FDA: 83844836544.22.4450332
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf26.hostedemail.com (Postfix) with ESMTP id AAD1614000C
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 16:25:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=k4GvEXQR;
	spf=pass (imf26.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756830350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GcPdMor0DAjh6R8iQPAqOOTJWJrwCejd8Sgqd97vrSQ=;
	b=FHUqmZceY8bzDEKeyE5Ryc4JdXFVkwCY4MoaMs7T13meFnzj3QDsd9GH0hgVPdnVilFlXc
	hataap4NMO4S/RWg5JyVJW70zKOeJV5AR1TAaz+hMbnIriv8HAxl0zpmrtW33+ft+TzVAG
	htG8G1LQVNihiUY1ojFjnhE2GKSeZPQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=k4GvEXQR;
	spf=pass (imf26.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756830350; a=rsa-sha256;
	cv=none;
	b=oWW/vmoK4hPQb5gNGk/lGjmkrlJhanCknwrP7YQ7tFr6k7h79e4DVDf3boFVCA1B7IMeXv
	X2mIKGLyICtKi1oE3dxo6bjfEZ4hySrWB9IHkDMGpKndpBIcleNFKvAp5zeKkc6z7PNRld
	yAE5INKKbbzGfdHvWQwD842jGsI9fa8=
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-b4e84a61055so1782759a12.0
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 09:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756830349; x=1757435149; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GcPdMor0DAjh6R8iQPAqOOTJWJrwCejd8Sgqd97vrSQ=;
        b=k4GvEXQR4SOmq9RlzCIQETZQoN25FZNzAmNGyWLjGZ2P9Ghtu/fbzLfzgkqTsGe2CF
         +W2sbbL5qUHmIOgs0SzWSt/cJnfQXGZbO0YB0VSh23EbaKHCN9XUWZwB2QaO5zaVWw1h
         vtD9ZF0XgjQpS4p2vJHEWHEsaKhoXQquT1gonk10TovHqJ9u+3NGbL2Lnaj5xBsbExkh
         pgv/YYHAn4oL0MTDai9QdFt3uk6zZBOA8Sb6jmi9D3rDQuOsmB7AKriOjU+RuiLcUFu6
         dQeWN657LBkr4sUon5XB6mCvqElu20n3LNECQ58Xubt3Zy+qlhn2BUjvlyn5VE+AbWVp
         6ndQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756830349; x=1757435149;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GcPdMor0DAjh6R8iQPAqOOTJWJrwCejd8Sgqd97vrSQ=;
        b=ARyqFUDdj3TqBcuykHtDBuR5Gti6wWRLUY8/QIbWM5LnbDDi34YCiSRIqFd8wF8TNC
         N0L69BCl4/HN7Velb4sgFKcdGGh0YeUeuO14p42JqQsqpbkjh5c6Gb+FYjSs5Bbw3Awi
         l1Zcsjlv5xs+8Tip9hzTprH5KQ5kQDkHbu7t22Mt9hI4cO3rJGJ/fStcG/TMA6B6VfuI
         Ei4rMfN3Ih9ObGo2Bkfp5N8XcK0dzl7+BI2o+peJ/S5a/J1SzLj/cVuB1N6GCsqLgV9x
         UO/TagopW32u3eHxGiNhg26dSC++uNLgzWdhAVjGCDZ2o61RncBixXf0A1NLMG/nb8cg
         SYAw==
X-Forwarded-Encrypted: i=1; AJvYcCXBLX+ohRa41kRp2a6jedsBzFYsyxFykMoq7GtuG5tp4bkbT/AJ+BdHzkn9rM7gLpJ2pRgxe7+euQ==@kvack.org
X-Gm-Message-State: AOJu0Yw/OHHurydP3O4HpVVhGhOdMtTTa/vCL8fb1+eGtqPl7elq6ebW
	Dxj1YBPiRCHHhcqsbV2J/ev8S4Nprpg8DYzHRmrMf4dWwvAJ2BuNlLRI
X-Gm-Gg: ASbGncsz7ksIEzmyr2n7b9EXSibJdYOzhwEdEHEsrVXLW73GpUvZU9CpPK/fjV0m1p3
	ud3JPwlAIpjEQN+aOjVlONx8lBPBnJEHd0lpELC194Oc9EU3Hwaf1uBxoyMsu9tMvMrRfWUrioX
	EZXHXeIj9Mxgr9ygm2Cu18oRYd1oIpDZMOf5TPIBcmkeZnQSerPEAg5dvCS7FAi2Y+16SdScyV5
	EjeUBU91lHm3H0gmcurM3Fyc6GoAk8NUXVNdq/3J4VfRzyCVvbfFhUYT82piW6EhO2Ym2dXcEhd
	66KF2eUCd5m5vCgufry3JduZPV1Kb0w0j0wylShbUkZsJWkrKYuCmBW5abq5EeDWpENZPdBNcEE
	mpwSWwpnnGtYG9JdG9EJNGbLPyO3IzBM2oZEHDTe1nBVus43QG5HFbaVqdd0sWT2Y
X-Google-Smtp-Source: AGHT+IHRkVVvH6HeHtH/xz4nXdtQTfSeAESUw912Xim7vgS5k4YyWFipqPYxbu3wyaBkhiL2HjH8DQ==
X-Received: by 2002:a17:903:1250:b0:249:1234:9f7c with SMTP id d9443c01a7336-24944b23caamr160625785ad.60.1756830349339;
        Tue, 02 Sep 2025 09:25:49 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-249066e042asm137861455ad.146.2025.09.02.09.25.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 09:25:48 -0700 (PDT)
Date: Tue, 2 Sep 2025 09:25:46 -0700
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, hannes@cmpxchg.org,
	ziy@nvidia.com, linux-mm@kvack.org,
	David Hildenbrand <david@redhat.com>
Subject: Re: [Patch v2] mm/page_alloc: find_large_buddy() from start_pfn
 aligned order
Message-ID: <aLcaiiWiz1jHb45y@fedora>
References: <20250902025807.11467-1-richard.weiyang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902025807.11467-1-richard.weiyang@gmail.com>
X-Stat-Signature: dzni5jncynnmfd8mmitzquf7t9dwiwr3
X-Rspam-User: 
X-Rspamd-Queue-Id: AAD1614000C
X-Rspamd-Server: rspam05
X-HE-Tag: 1756830350-163859
X-HE-Meta: U2FsdGVkX18fCD5CiMxa6hv0MCF+YIPoRq+jrRvQLeMkLNOmIR/UTS8ulM5u53LyqOsy/600tMi8E6F+ZmUdCLFSUShaNrSWbE8ClIdy56GN0U5eco+5ziUGbNdOeO2yPoAjY/7KOa6+6JB2gAT9CIEAvbVHiKHng3UoQI2EzRVKMgk7MBzlaXn0UgpjHpwvo6qBBhUUPRoQgUjHBQnYqyfWOtZfn/W/agLNsqzN9IsonY5q8xMqB1dc6uDNXEdDD58+9MlFPNSn3VGKuc22afc1cnPv5BRGH4ugMoecE8RjZLLOaNBnTdH1Kku9kRdM+mxS6NcU919xJJMTXE4Vw6hLAqOHbgw78OUPXsmk6u9ydMkbw83wUCJ5V3Yp8ctVydVGkQtsrcJDMmlqOGUVTvPdieVllRSKbMooipVvgcfL+dB3LFQjQqB/B0HvLSn5Hfl2zIIwFAkppXWiVtlFIv6N+dMiAGo7Po38rfmLBmFxHep6mwkSgujMB+O67pWTYJOj1DOn4TTgKuGpCXHijviNQZTod0nQ4U6bO5S5Ixv8NwfcCOm9WUQDsSR+IFkmBfUEJyWPlad4hu6W2qAUe7Q8RkZbcut1gvCoHlBrQS/qUyWw+YexvFj95XaR/adCtzEDo4LnLxJn1TYWE+XTH/B7zDSC731VsqkoNXwpv3j/WuPjLSN3C1CO3VrSEwd1MlIUNAKcjuC1FujFdYOOBNlqWT2IuXz5Y0+nOZ3Jo7yTMsYACZj4WOEUT+cV8V/NWPJRfjchElJNnqwxLf2TWsfoCOD5eT/MAaRqVkA0JBP/fwfoTocrG+FU5LhajukthrikJh+cX28A/ufcKfvigjS956YI4gz7KvzJas3Evx/4uOvNk41CUzBmkuV0RvrdhE+T64lRIiZDx3l9gDYwzwwnvl5/ufWWb37PsAiR0+ur1HvCndggJNQMFDOo70AvsFZx7BCPqjdFTLoI8/X
 kpZUgzSD
 Av4vYeeEdjt39x96jZ+NpRbwJGe0LKyt9DNa5NEqWzhwhmh/givnlMH2UqaobOr7INMQbnzLZxtfKZ+7dnDxGeJs+hf5ZX9nGNex3PrhKwb0Ia+2H2c0iBCC7mBZsspXhSFR31E1Kf8m9AUCBukMJg9iquM0EgZGVyBuVDGlyZX7i8njjgGSzi2fEbyQnc0weJ670KcS36Ym7aZUuOvG2UgdrzWPc3R3XUzdeJeHxLyzTJDGPhKgSZq2lic9mCX+F21e0kr7VzIy2oOI6eL9zyvMDIDLHRh7ct4LGz2d+ZFLf6JFFeRFDDVifkWxMUiVOCCzu269y7MneUniZeqtozK4QdTjFMlS4+iv4juiCp/zbydzOqB+N2iQkzUMP7Y24idPcTSo4qL0k1Z9iH1r/Sbzg9CmN4ZluHffG0p7it9A+sipIYQG/EbIFZzMQlSsKiMGbYuYMs8FpQCxK1ddgr+wTOK6SiqK//OCdNmFBA3LkcLUEb/jGoxqaUXHZRn2Sbg+gfea+UHfXdKA+4B/3YZzbDNiaCbHxXvQnXLgMm0JR6NM3SBZ1NAdOxOMpnS6Y62u+g04cTEcE5MmxPpxkt7Dp7L5ws/QpXE6qXVGNHOmbj8qDboRZG3U9Yyq7sIni5m9nhjb5JeGXr1/y6M1FjdT1XSFiqVbTJvmto1hAHs6LUH7p6ZQcNxYnOct1yJQON2M06ICb1M74SseNrUG+Q+pvcUUI54ZCJJ2GJ4RhkVFTQQlZTnXphbY/Lpdfbhh/+YjOrknry4n36Ty2lHl3PPSK+Xu0ZV6lDPj2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 02, 2025 at 02:58:07AM +0000, Wei Yang wrote:
> We iterate pfn from order 0 to MAX_PAGE_ORDER aligned to find large buddy.
> While if the order is less than start_pfn aligned order, we would get the
> same pfn and do the same check again.
> 
> Iterate from start_pfn aligned order to reduce duplicated work.
> 
> Link: https://lkml.kernel.org/r/20250828091618.7869-1-richard.weiyang@gmail.com
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: David Hildenbrand <david@redhat.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>

Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>

