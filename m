Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87092606A89C
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 04:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=av3kerPu
Received: by kanga.kvack.org (Postfix)
	id 8A5106B064D; Thu, 12 Nov 2026 23:55:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8565D6B0662; Thu, 12 Nov 2026 23:55:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 745A36B0664; Thu, 12 Nov 2026 23:55:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4CDE56B064D
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 23:55:14 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B9FCEC0527
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 04:55:13 +0000 (UTC)
X-FDA: 85428881706.25.4D6BCE1
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	by imf04.hostedemail.com (Postfix) with ESMTP id BFBDF40003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 04:55:11 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=av3kerPu;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.42 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794545712;
	b=Q4PScQSvfxJZEBFl0H9VatMWrSoed1Uj3XrmljeV/89x2OEbu5Wturgm1pkHO+DhDm1Ntz
	y+jFhzpKcxKVhU0h+ABmUNspGliSot7NCaOwQUgT35+ABKYBaDTgFgJw3p6Or/xD+CY0uQ
	e59pSDY7WAONCVOuMzRCWhJBzeL6cAI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794545712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ksSqi9LFAnauiWq3VTcsn2XVnb33hHx7fgUlFBfWLfI=;
	b=2pI6mD44zpAL7O0iNbblxa0K4fq5HZ32aY19LPijrSfqNSY4o32YGLTSZTJDgjNqgTcuCQ
	1NxdAPgblXdO7Qr+KNAtNBCcQ6yqjilkx8RmP3bkMMXr+UImv8AKTaz/5mUuiP83cPcTjU
	/BaSBL9w8jwDgehgLWahpE6a+Sm5sVs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=av3kerPu;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.42 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-91c847584b8so11357476d6.0
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 20:55:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794545711; x=1795150511; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ksSqi9LFAnauiWq3VTcsn2XVnb33hHx7fgUlFBfWLfI=;
        b=av3kerPu5l3RmMzgu0d6mDCl2vu86S6cJbIDleg9RmpSLFIHG9H1TGwxzeVCFt2WJ0
         S2nDhg9yuRxymd/C10QBs7qcTdOttBd+BcS4UGP367NUPxvFEL4q++TltyFcVuOBk2xn
         jwjZgI2nP8+VDUxKcTHmyPTcLeA+jBqUC4bFcuOZ98fjRBp4moyLyK5w4w4YZYeGBSMF
         NiK1Kme8FsmDwtGnfXH62IXbqNZETeQdWPQ9/RGqtEBX+ZKRgAM1zzIqk3pv9tGHKZsv
         Gt926Ysy9w3yNwx3lNgmVwK4B9XD0nPPjYEkE5F+xxiOgSN31MK7b4GwehpzaczTq9W1
         7YJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794545711; x=1795150511;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ksSqi9LFAnauiWq3VTcsn2XVnb33hHx7fgUlFBfWLfI=;
        b=I1lkSnIEvrK+ymfXRotJifKVCyw7Ok1pbwoV/6NgLEVFHUKuAvvyujd2qDV5949uVf
         B7IgIgtyHmpefI0OthvJu4Qh7CSDCS9UH9xEiTklS+qpYRxRVX/lvNb2mEjOR6qgQuap
         89dJcmddV/MCm6/kYjGJDCX32Ny1k5ATVng7miNSPZ6D7NUCaw2uKPTN+NGRfv3/MbLy
         nxfZgHGTtjSs2VWvayIBn1584t5pM5RGNSGeBBR7ebmG9qroDeZEtrDFg231cDWnWTrk
         7V3zHEPRXOASM4z1LG2yx04TV7QG30Uc8ylEF2TXqmTuSZ07+QYlx3BtjT1PUM85S8uV
         WoFQ==
X-Forwarded-Encrypted: i=1; AL+hErF8m66ScD7sv/+QoEotZVFtCzqDlgxaW/sviPqcmCnESLSyjI9rMG8gTpkFxcFmi1xhf62DIiflGw==@kvack.org
X-Gm-Message-State: APuU4Z/jPc6WPs8W2uVnbJQCKIuWRCHwI9lX5YGZeAkzJmw+uZZeRQ+M
	z4hFcleG/Dt0AXwQ8X8fy2D7kQxN4SOOoy6nleHmLpCIwrtTYhYdD/ZW5nNg+yQ8GRE=
X-Gm-Gg: AYBFou1mPE07qIFgWKlO110UuElztnUHUrctFBarpR8ZRUAEtai+cAjaZwHQ99kf1oi
	zfFnSibVp/TyWgz/+J5lHTVOxuLhNXaAxvFoKpWGkxf0Tr2WSBwhkQGit910yRAt3wDN5L4/2rK
	pvSREq/6ZhKKfgNp2LuNjFp8fNw93JdMCJrIo3cdzxI7Py+AYDAXxBAQ4biD9VeXjJn40WsQcc2
	L+DYY2oxZ5QISRcvp0/9Yq1pLD9YXZiI40LWaiIaW1DUYBv4m0kDTbBv8PVLLbym0Q+zEmHw3xq
	m0A8NTtsAIgRpktrYGuoy/EoP6L4+MVx2u5TPe+N76biJXaGz6lupczRnYZN+osQ9b2ddSkzWGp
	xPlxCWYUEErZ63ue5wD4Tpa3YFAf6cJiviSpAp6LpNxdjP4iRCUL5TSTiI+tu+F2djaf6SDaVt0
	xJj5nbPDepJw47pI73q+Z+1+UFpRyYz3PFP59rAfG6WV2C5ltv7a77D+OJTiUXGMTS5MLfSbA6Q
	PkSFAFSK7AeqOhISOZzCPe2cjpAv3/XCjXnypEONXtrueqGq5f5+GySld2addAkSqi9J4LheN93
	Zu6jedDaootXD6C8KwXaH7AFW7a6DsgqPZP+sRuTpks1h1tdPA5J58l3JSyBtF0bm3pSioWn/Jy
	ryK+xW25zeYjDf6p+vtccOUfc7Y+E
X-Received: by 2002:a05:6214:5e05:b0:91f:2abb:a7ad with SMTP id 6a1803df08f44-91f2abbad77mr1153566d6.16.1794545710518;
        Thu, 12 Nov 2026 20:55:10 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23d73206sm12150726d6.25.2026.11.12.20.55.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 20:55:10 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 03/12] fs/proc/task_mmu: downgrade writable migration
 entries in PAGEMAP_SCAN write-protect
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>, 
 James Houghton <jthoughton@google.com>, 
 Andrea Arcangeli <aarcange@redhat.com>, 
 Suren Baghdasaryan <surenb@google.com>, Balbir Singh <balbirs@nvidia.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 =?utf-8?q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>, 
 Andrei Vagin <avagin@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>, 
 Arnd Bergmann <arnd@arndb.de>, Muhammad Usama Anjum <usama.anjum@arm.com>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Chris Down <chris@chrisdown.name>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 =?utf-8?q?Miko=C5=82aj_Lenczewski?= <miko.lenczewski@arm.com>, 
 Michal Hocko <mhocko@suse.com>, Mike Kravetz <mike.kravetz@oracle.com>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org
In-Reply-To: <20261111-uffd-state-fixes-v1-3-00713d368976@columbia.edu>
References: <20261111-uffd-state-fixes-v1-0-00713d368976@columbia.edu>
 <20261111-uffd-state-fixes-v1-3-00713d368976@columbia.edu>
Date: Thu, 12 Nov 2026 23:55:08 -0500
Message-Id: <179454570885.482102.16669231045892763097.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Queue-Id: BFBDF40003
X-Rspamd-Server: rspam12
X-Stat-Signature: jw8nwqfnunb9ooijwp73eamjfoxnfcht
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794545711-697044
X-HE-Meta: U2FsdGVkX1/1TMLWeKi6Agk3GcufpRA3hEpkqSxPhDDP8u0s52xRIB4aDnGwut7uFcQY1MrG5HIRrZjCjAqwOi9rP3I/sng3D0JND+OZ012pnQCoo30pt+bf2Xyx06MPAx8sIKxv+KHSTx2hoyX2JVmSFG0Z4BZD4tKxPT/qhtwlMyQJI5qhwrSvNX6vIhDzLPS1u6/RN/Ja/06p7h7PZ36wuS2r99Jf9Xac7u0GQ9F97Pa0qwYSf2rSkWiVWn6HUkIH7G+skOc/s9lvR4H2g/YQ52s3ej8voRdcybe9E3pHM96MyfLz2G57EY+O68l+rWgHrGiMi5v6N2HKx/9gg5S3Hu/5TjgJHwAOTlvt6biwX41CPFUjmWqJIT29jM+5euo+4PVeooFLR3/bOPDtvm2+qPcNUNkQCO4IWUJJNdgk0RDKo2QCHAwMRTvruUpsJtZzwOrTf/HFn1x5N2TK9ZXawjFPk0+RcE8VLAJZ7IhFsnyg/D+QZY+iLfILvW1Y/3ePJZtXBHwuT2NZOQofl0S8bL5JFa9py0iKTyqEOThAsKWGCISlxRx7ep0esUK9Rd/7gdcv2sbwcM/Pz7/Ru1UKee5fvwCoKOPw59oww9NCUfDyx78ECRwfiGvkD1pMhWdBvmjQI/oYOkbfgQCiBBTs+L8eyNYhPeJievYoIC5u4TbGmYpBJPghLNOrejUCvRVefO8iUteJdcHzb+122AsyoSEGimPqFdTIhZ5Pd8Dz6qjyXY4jtpjkhYOuBNZzGrv53DlB4DQ60wCR2U+4rp++XrLm7cIF8DKO9Qkfo+/WDyqQmRMFDQ5OY13PF8v1UurFY1O+Wb/WIIWo6tBAFL6fFRQZw9exINbMpKqTHgDhjFSXa9uIs14+j5xbEbaeLKde6faRmcGBQSXIUs6LwanK6HBIdQ4yNMxzCCbCOaPxxtYGv3Zf4arwk3H8KHIu2hE6PpEOyS2VbUIBsiz
 LghgBoWw
 0MyvU39T7WtTDJd1etOLjhBQhlgIyDfJ1U3mreCFMb3z94NPLwfEGgD8ttQBCqMm2q+Hhkyy6+ga2Q/QjDpzPF8L2+ykCJBEWr9659h/Pqapo9aefLSIO1KRHP8vnNxUgYedBfXNKPhsZchB4CdZVTg4wOjYqAzvkueecF4P3klldLNu5HDFbLjxtJGQxR3Dz7YG7WlJ2zGUSts38DsKGEuG6bK4a0t/Zb/noVqI8JQNcMOka9Llo000zo1KhPsc2+oId2pCZriutu/Wx6wQT2HKomc1OIzk6cGqZgxVU2MZQPtdKoJPY8bn+4wSWE2WrfGlDWVCwof6AQyfoupL+pv6p09337QccmLAwikwYll8rfdQcHtIQ0PBXyICaaDqzN4xu63u5SN0pDJugEHZGDQZY1pKaM3Hdq6kpfx47a++9xGDPikvRWN8BpxYa5p94jG9ZLb0ky3L1F02KFYUVyeWJP2Z/fiPJG+FtjFOvF0nc+PJrBFpHirUxcU+2jiAcI34cZ/2KX95yF5BcrJgs3fFzumk1proMk73Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-11 12:55 -0500, Tal Zussman wrote:
> PAGEMAP_SCAN with PM_SCAN_WP_MATCHING write-protects pages in a VMA
> registered for async uffd-wp, and sets the uffd bit on non-present
> entries as they are. An entry with the uffd bit set must not be
> writable, so that the page is write-protected once it is mapped again.
> change_protection() therefore downgrades writable migration and
> device-private entries to readable ones first, but PAGEMAP_SCAN does
> not.
> 
> For a writable migration entry at the PTE level,
> remove_migration_pte() restores a writable PTE without the uffd bit. So
> if a page is under migration while PAGEMAP_SCAN write-protects it, the
> write protection is lost. A user tracking writes with async uffd-wp
> sees the page reported as written on the next scan although nothing
> wrote to it.
> 
> With CONFIG_PAGE_TABLE_CHECK, setting the uffd bit on a writable
> non-present PTE or PMD also triggers a warning.
> 
> To fix it, downgrade writable migration and device-private entries
> before setting the uffd bit, as change_protection() does, at the PTE,
> PMD, and hugetlb levels.
> 
> Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Reproduced and managed to emit a page-table-check warning and
demonstrate the lost WP during migration.

Will leave the review notes to Lorenzo, the overall idea looks sound,
if painfully verbose / special.  But then uffd appears to create
this pattern everywhere it touches something :\

Tested-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


