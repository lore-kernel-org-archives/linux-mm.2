Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 085FD60A381E
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 16:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=PlplbDYY
Received: by kanga.kvack.org (Postfix)
	id B53EA6B05BC; Thu, 12 Nov 2026 11:40:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B050E6B05BD; Thu, 12 Nov 2026 11:40:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1B426B05BE; Thu, 12 Nov 2026 11:40:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7CD476B05BC
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:40:14 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1253A80629
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:40:14 +0000 (UTC)
X-FDA: 85427029548.23.034EC55
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2C12240002
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:40:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=PlplbDYY;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.177 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794501612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gtnUQwywPg0HjDfSf6ZrnT5Doe5dkWtLl9mYnrnpV/w=;
	b=kXrFEi74jDlWfDidFO6ys6IfQ/f0T6N3hECxTyfEq3HrB9/oectSePu2oC9LkoRTxuWunA
	3BoLDxtE5/huBPtjHKyux6RkoNKB1yVRn/KZVCN+H3IzQ+Ka/kXDIiPS347TeOV/V0rLEq
	X0AMN9HsfmgCJNKldf5MAjYZli6RC/A=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=PlplbDYY;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.177 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794501612;
	b=Ga8n6ZDLZiaW/Nd327lXSk6p12WmW5e8jAyl2S4RwZ4owSLhK0ybT0CLZNNvle99Ic93H6
	8YrS+wdBGXWWLVM6xsK1w6UEisJ94h6Xq6pZhfxDAkbj6BcEKJzu0FFPnxHueVwFAfTCGA
	cS13FVKhKBAG/jhXlTBmT1BuO1DBSgg=
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-93f1e5d7450so443536285a.2
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:40:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794501611; x=1795106411; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=gtnUQwywPg0HjDfSf6ZrnT5Doe5dkWtLl9mYnrnpV/w=;
        b=PlplbDYYQUue0XGzsM5K3bP8H5s59s3jqW+52TrDxN1mybjvXsa1p9GwFOHYAIG72l
         J598I/PHpVOyBQn9EWi9xINcQzoTy0mhpjqSQIH7Zo+EJ9sf4l0dZKAP73pZQVZeA1vg
         F/B/LrkaGa2XYu5XIJfH5CcKryr1WwcbwKQVz7syVZiyTM77Wmc5Vor2WBdefQgSbtqL
         MpPIG26MFw1jhbEoWFkWyg+W9z1npuvuSE3tpv3NOAk2fcqVTzK/Y4gc8rUu7ALgyX2/
         mTg9Cu7rG+dvCwzOnmPi2uiWBeAh2bUHC6gWCQ45g33w8ZVyXNV/X9FNFFeLfVlDE7OV
         dCog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794501611; x=1795106411;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gtnUQwywPg0HjDfSf6ZrnT5Doe5dkWtLl9mYnrnpV/w=;
        b=fHLJmOUQjf+JLtDDmnK96gVxSvJCoerXRKhf7KkWv4T3fYeoPqsjs1ENq70UgIC1ih
         Tlx7R+FbHAncRF07I6WHqkKKgzAlsrIcBP0OBTrpGWFNWc5H9upxHUGvK55ENdFW0XHG
         HIeISPHGJzai9JCuqx4R3ogHQ1QZKKN7WYbhq8NWMvF/xICk4xBVIhcaAvYGOeu4Esnj
         Nb0CuPKOvJfU+eNL7ogGk2T+naEBkysVSqraL9coIBrUv1NtJW45scpVAlkqNeCZv8Gr
         02JOSIugHG0YUwggRS+6jEv9H2HFc3W7YSdnMlXflsQvnXys5E4ZVWwOrZbItuLyP70I
         w0EQ==
X-Forwarded-Encrypted: i=1; AL+hErFACNGhauBOpnJyg38YdXPrYfPYtkhPx51CqyS3knbx1yuibBPZYGyjPGwndY3ZUEuVbVjUCDuezQ==@kvack.org
X-Gm-Message-State: APuU4Z8TU9u+Ww3HealyKtwNDNA03Y56BP2dt9Kz6dtL96MVTExTPdCn
	BNEVCRB8xXJJ1q43MSmse8peHrctznwnunwKhNQLMv7mDuzzA7IhgV7XbjvmtARRAiA=
X-Gm-Gg: AYBFou31vCSqOlWNV/C61CzsNQC0LNt9DfeAPOxhNH7VWlaxpT5+9MtTGDwp4mWILGt
	NxMsxRhYIJYXuCzI7t8QVVSiHVOuNMSdZMQso/5IdcDjT3TfGwn2pdLuB6xpWSa44tlLVanJ+dZ
	o/Sj/bnXc3MYoN0Gli3h2Cceau2ncEjhh4SHAmMQfnad8wrxFpdLH8bDztStYMBFCu7zTSbRwfE
	WeGnX/I8eY4cSXdCandFuomE7eoEIjZ3Yh5yBjkmnaE3BjOPHfl39zIagtufDfBCSxXc76hen8s
	vf1LyFXQBAwDsxSlTSJXVzT1rSg32MAiVSXRe4dyaglR2NrwQvPoyGmFerBHasDz3zqY0IhZZiW
	er/DbSxgDCJ0HHdjwh/QCeUtenLk+75yRQgGwcItv7eQiFIuLVEe7jzp+53/pxhrAtdv5Rg3jv0
	PzpL3KO6ShOcyHjB0WIvuCEjVI9+zQAr/JuLO8Ik92eDBvX2nTd8E9Zin9OCY2mlPvFtJ35p5Bq
	LNOLn/55J5iS5zhfq6V6iQeqF3dhiBEauFs4R1w5nKxpAXstEXNVPZqSXsaxFKIvgq6vfFHqFIF
	B/R0GI2rb8TZ14bu80GrdCDPK1rXe5bBgchsAmgpktqFC+Epb1UZKNZFVHYMcJlhgCnY1lkZXcz
	bXn/B2oy3
X-Received: by 2002:a05:620a:4626:b0:945:ad43:1d59 with SMTP id af79cd13be357-947b000d7a5mr1094709885a.75.1794501611290;
        Thu, 12 Nov 2026 08:40:11 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9479e7ffa11sm759904885a.43.2026.11.12.08.40.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 08:40:10 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 03/13] mm: cachestat: restart the walk after each entry
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
 Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>, 
 =?utf-8?q?J=C3=A9r=C3=B4me_Glisse?= <jglisse@redhat.com>, 
 Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
 Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, 
 Chris Mason <mason@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 "Borislav Petkov (AMD)" <bp@alien8.de>, Mark Brown <broonie@kernel.org>, 
 "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>
In-Reply-To: <20261111-mason-migrate-et-al-fixes-v1-3-3d2454362e8d@kernel.org>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
 <20261111-mason-migrate-et-al-fixes-v1-3-3d2454362e8d@kernel.org>
Date: Thu, 12 Nov 2026 11:40:09 -0500
Message-Id: <179450160935.482102.15213700511149025586.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2C12240002
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 5adit8b8kpcp7ayt11risgy7x33dt733
X-HE-Tag: 1794501612-686035
X-HE-Meta: U2FsdGVkX1+feF3TvE41LT/pp2iYLvlSLVsW1efiRb2NxHlvBAyeyzWbJUjriRJDgPizTCfDLWxZoG+H6yOxDfbtZa0f7yHYk4oZac7+hR5zhLbmAzWdksH1jUdEX2oGI4bG3OIaDB8OxNK3vFw+aZwDfOlsKQTviwiYGC5nY+zdBPIOoMAfRUSyPXzMT23i33AHyF8YbK3X5vM7RxIeAO1fXsY5iUBY+N0OLKgkSeLzL5GVPKbCea2hWkpCpEPVfepqeSdThzTPgiv9qvXmkVA/RbySbq5fm1EY6r8fzkxS9WYWR/6AKMaxBvxJb5EUTTBnjAeMJ/7HONQDnyUrVeAm6wlb90w+ESmAvPI6YY1SHJAfQ2VgvcGPZKxd38jXF2z8j+njiCyfUXhpavA61FXGhDFY3IzVfnEbfF5MEv9EpW+8YqnIKnA3zl+224rhsoOzjbTF/9Jk5OLfti801547wckYqUttvMmyI/znyZHXJN1BzxEB9f1AegxoHVvBCkq27UkC0G6d7Dq5VZzgzj27iy1Fg86rkQcoAmkFWAPIfbIfh4ak2yA9Tlyo84rVvF5XHPInBKiRSC1m2Wbx2EDBKN/NW4iqWt5PkgaZeNys0snJumnpDIoF+dEAJlobwVCYltnZlFzgNiNlVFNo3aZ/3BcXpOJdgmUrABYRjRNSJgzRZd3pQL50QXMIv9+ke+obYEk5RbZtvDAr2eSDtzLKpvsrC1dZMxkHrEBt1QtIKNDTWUYeSabi88IoRpwc0psLTpvyRuvFzgOHI83Wb7vvDpafJnXFE8WgyQIV5Xdh2zVzcEnFL6g+zgCWC4UwdZ25PtPS7C4T4ZbkEBjGT3CmxuMtxf4xgmwJWMxNzfmZkgFn1rxAqhv9XnSK3QQ66VGVQGGtOnX3ctgfqOrTN7ys+frCfoZvQbxgMj66Sdgw7IqvjCSzW8b9GeAoIv3a+IhjZI+rT/iLZtRkN1k
 Ho+afkvS
 dpA+s3Xcd1f9dxCk4j06LyiCzi5ENTIQwVz4/b1SiamqQTnXBiVdcxUnTeun4SFyDiP2M4SMx46APupydl+toVH/V93vXv7SOp6SG3EwVQqKDkOuaz9i3yMv2Bsxt+ODstnTV01ZLWwTYOOthnrVY8GA0yxH5Z077MmsOLG962RbcOSvEdyG0TPIQk/wy/Jf93WLpubMJz6WMNe9HPAlos2nu5nZeHjrxBQdxZEE2+xEmVtfvBYpR6UExrTnL6AfZC0aLBRzw6YFK33M5+7RWGshoavH3ETw9JfjB/e3P4OLE6ToeHmOVn4AO/2jmR6GCWinp2QL0eB9eJAQAz4T5saDSYWlRngvP33gkbb3sGby02aTNg6MVSWJQ6BVgsWgMbOmMref4NnxI/7RDSaGdjqbTJnBxjJFEEt+G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-11 18:13 +0000, Lorenzo Stoakes (ARM) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> cachestat() can leave cached pages out of its counts. This happens if
> the entry that the call has just counted is replaced by a larger folio
> that starts in the same XArray slot.
> 
> The issue is that filemap_cachestat() walks the page cache under the RCU
> read lock, so racing concurrent collapse/split is possible.
> 
> Thus, an entry can be replaced immediately after the walk has returned
> it. When that happens, the next xas_find() skips the sibling entries that
> point to the slot of that entry, since ordinarily they belong to that
> entry.
> 
> However a concurrent collapse_file() or __filemap_add_folio() (when
> replacing a shadow entry) can store a larger folio in the slot, in which
> case the sibling entries belong to the new folio and the walk still skips
> them.
> 
... snip ...
> 
> Fixes: cf264e1329fb ("cachestat: implement cachestat syscall")
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ ljs: squashed 2 commits, fixed up comment in code, and commit message ]
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


