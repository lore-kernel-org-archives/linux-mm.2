Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27EA8106ACC9
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 16:31:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 845816B008C; Thu, 12 Mar 2026 12:31:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F4466B0092; Thu, 12 Mar 2026 12:31:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F5F46B0093; Thu, 12 Mar 2026 12:31:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5D3586B008C
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:31:43 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0F2931602E6
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:31:43 +0000 (UTC)
X-FDA: 84537952086.27.513FD2D
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1CF4740006
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:31:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="h/6l9183";
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773333101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sTldllX6d0omLBgu0LmuFrBJpxfhsmTLRlWR1u3QCOg=;
	b=F5+D6AYIDj6ReFoeKiFMhJEsX0fovgOxR3+jFImQAQerZR4PBrLzssmBILrhc8bIkNIRAD
	yxwHTQYP6CduG1weH6k8+7ZOjFvyYtJav1Gmuhg6sWpJ95XXA8/Jr2wQIT2SavQUH4dZgS
	aM2rdwQvBNxv2tUpTL3dlI2tvYeKgwQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="h/6l9183";
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773333101; a=rsa-sha256;
	cv=none;
	b=rHwMFrU2YCVxpRdklV6PRRi9JnoO1gEbKKrv+enCA/9AdbUHsQBCiMV62b2rJLi9y7tevx
	3LLisAGnkEmLXKoOwF0+BRM+Mulmo1MNfbhTo5o2g75rB40q/adpLHhAyYVVpIBFidjZen
	2+C6P7/T91/NDYt1nCky0bgCa0BAuYU=
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-8cd7aab92dfso151327085a.0
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 09:31:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1773333100; x=1773937900; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sTldllX6d0omLBgu0LmuFrBJpxfhsmTLRlWR1u3QCOg=;
        b=h/6l9183+w53cAZUa7UK4G5S/0n6BatjbOR3cJu7ymviTsTIem+wgvJ7+0S5rPvYAI
         LBw0ZSECPBP/kgb7q5++In1OqpJAum3S7tqILLGRMlHIISPxa0q+KZ6Aqsor7EvONGOQ
         Nwr6Gs4v+BV3RKu0cvZWG0hw9MRLs326KNs4DBn+MkwBiOZPi7fzhzBNpW0GdmUJgi8e
         jZ7gmzETfJudqFqmtgHKTIL6zBupkhWnxwW8MjBR+gwjxU3uTNQsePD2QVsuQRMrrwXx
         /kV4HI6lXcWjfdWG21a3e7XShgVQAoFc1Zoebvn00WJE7bR1S3fUQalPCSryYh9mTh3r
         m6IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773333100; x=1773937900;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sTldllX6d0omLBgu0LmuFrBJpxfhsmTLRlWR1u3QCOg=;
        b=H7UGBEYSc0KWsOfeB0JC7+BX1pUA8yJzY4EBk/M1ULsfi6veypEjuQ8f92bPvrTSdf
         zVwfgE64X/VOZ30oP7LQ1rLVC/tmzP+JduSHa08n5uoJzqa+NzdFJMJos8nCA+afVNe4
         97SfT/DRKY3T8z1c1hRJghHp7bN3x/y2qi8LCViv0MUotB7gw/wA1pFlVHUxJuNa3uJY
         2fD+Yf95xDYJwj95TtcComMXiUp09zQueYVBEJi/SwuP6lEXsCmY4S+CzWvQADHXTGOt
         pUgcnpdRgtZ8jvL+2daxWCioPDo6nEJZ+F2Gg9S13NoIJV3S6Tkbily+mBVr3nuou8Jn
         otXQ==
X-Forwarded-Encrypted: i=1; AJvYcCXllnSETEGWzD87flZxhjVIFBQdx/5Fy9buDF9rfkLq0lW/Q97qGM5Orbdsc19+YkasAIY2I3nLsQ==@kvack.org
X-Gm-Message-State: AOJu0Yzg+73k0XMaLb0MqQd9Iyhh6ipqk4H5SETmYcznQ3J7dfTmR6gC
	kGaDAwRyYJXCqTSlNu1KnlSTMbU6BifGzoODenXJFqjJNuOKZVQC0tbecJwCduBzL8BpHpfh6Wm
	ZwdYZ
X-Gm-Gg: ATEYQzzv0JpgqCFhEBp0cyP/5vtyjnyv+bSSir06BX7TY4z2p2sRZqL5uMyXjJn4WMy
	XndOZynl9+McwwHyZ6FZp12swDhjAyucqfegPGp8LKwNOQOo9T6tNx0E+stboM2D1K5MAAg7N/7
	r35m1IKeq/Y7ELPGHWT2dg7uK6ldrf11K3HyAfN2fbKZEuS+Jka4Ry8HpCgQgVDUFE492srt3hD
	8LBQlweF/W4E5PQj/rSESl6uYV7OqtZqJI70lVrqyE+GPVkp+7zD5ZynkmLQb/NeN/gZqNVN9fd
	Ve+8vijw0D/XExv5KaKAhwGd9FDlmnKPiQiv/GCNYXqcnv4nKQig4U5di5QplTTmbG3uQZbN83n
	rwqQl4LbBQ3mqTIR4uAjzBdPFxzt25Kf7/wuXVqGrCRhCZ3wi0INsqK/ppz5b3dJ3k915KezgF/
	hTcyXquJi1j1clh4XuF3D4aGPeBINGmSHrTz4Qn6elW9TrJD/mRKAHamGyfWEb6X2KA2hlPo8mq
	yQVRbPwDA==
X-Received: by 2002:a05:620a:1711:b0:8cd:9584:632a with SMTP id af79cd13be357-8cdaa8ab027mr479259385a.41.1773333100079;
        Thu, 12 Mar 2026 09:31:40 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cda210d972sm417972985a.28.2026.03.12.09.31.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 09:31:39 -0700 (PDT)
Date: Thu, 12 Mar 2026 12:31:37 -0400
From: Gregory Price <gourry@gourry.net>
To: Riwan <coefficriwan@gmail.com>
Cc: "Andrew Morton (maintainer:MEMORY MANAGEMENT - RMAP (REVERSE MAPPING))" <akpm@linux-foundation.org>,
	"David Hildenbrand (maintainer:MEMORY MANAGEMENT - RMAP (REVERSE MAPPING))" <david@kernel.org>,
	"Lorenzo Stoakes (maintainer:MEMORY MANAGEMENT - RMAP (REVERSE MAPPING))" <lorenzo.stoakes@oracle.com>,
	"Rik van Riel (reviewer:MEMORY MANAGEMENT - RMAP (REVERSE MAPPING))" <riel@surriel.com>,
	"Liam R. Howlett (reviewer:MEMORY MANAGEMENT - RMAP (REVERSE MAPPING))" <Liam.Howlett@oracle.com>,
	"Vlastimil Babka (reviewer:MEMORY MANAGEMENT - RMAP (REVERSE MAPPING))" <vbabka@suse.cz>,
	"Harry Yoo (reviewer:MEMORY MANAGEMENT - RMAP (REVERSE MAPPING))" <harry.yoo@oracle.com>,
	"Jann Horn (reviewer:MEMORY MANAGEMENT - RMAP (REVERSE MAPPING))" <jannh@google.com>,
	"Zi Yan (reviewer:MEMORY MANAGEMENT - MEMORY POLICY AND MIGRATION)" <ziy@nvidia.com>,
	"Matthew Brost (reviewer:MEMORY MANAGEMENT - MEMORY POLICY AND MIGRATION)" <matthew.brost@intel.com>,
	"Joshua Hahn (reviewer:MEMORY MANAGEMENT - MEMORY POLICY AND MIGRATION)" <joshua.hahnjy@gmail.com>,
	"Rakie Kim (reviewer:MEMORY MANAGEMENT - MEMORY POLICY AND MIGRATION)" <rakie.kim@sk.com>,
	"Byungchul Park (reviewer:MEMORY MANAGEMENT - MEMORY POLICY AND MIGRATION)" <byungchul@sk.com>,
	"Ying Huang (reviewer:MEMORY MANAGEMENT - MEMORY POLICY AND MIGRATION)" <ying.huang@linux.alibaba.com>,
	"Alistair Popple (reviewer:MEMORY MANAGEMENT - MEMORY POLICY AND MIGRATION)" <apopple@nvidia.com>,
	"open list:MEMORY MANAGEMENT - RMAP (REVERSE MAPPING)" <linux-mm@kvack.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: mm/rmap: Should vma_migratable be checked in try_to_migrate_one?
Message-ID: <abLqaeW-eulG22Eu@gourry-fedora-PF4VCD3F>
References: <83E1B606-C461-4FC1-BFF8-FC2BEFDCE2B6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <83E1B606-C461-4FC1-BFF8-FC2BEFDCE2B6@gmail.com>
X-Stat-Signature: x7ybwkdqgdcee6eqncwecob4kk6m75fk
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 1CF4740006
X-HE-Tag: 1773333100-767064
X-HE-Meta: U2FsdGVkX191wS8v5P6TI2LSoT4h4FH7x9dKRNyUDwyxeBAJmFZcrjl3nxbCRDJ4vKVnHItXmhGTeNkH9GHNmb0B33GESol18+6y0iuBR5upjs6FuB3a3WCSxt4VE1m9Q0s8/Msq7NxBsrGeBLZLRg+qctfrFTFH/M9s45J82kjHiG1TOEe9YAeQ82HQXyJE9YkTN5EWWJNu3ub5q9+vx3qVCpBoftVzMYNl1Afut2AXenQor5xqotwzCbIBAsyPbiSoihmunNsxzbpIhLQfhgFLJLmB1kPa3nnd82nYUwaT3oF8msRk/AUmZLYe/5ZlxriKa73Oa3qe9zzRA3ZR6Gg3ezSMzXbRWGHNxb6qm3V5WeqimQGAeQdUpvNf7naVnkluxZYu1h9Z95yzUgTjCyPjzkwhj3AqEklxofBvQ4MM/X8697jX0KEFtpsuKupXaJfFnvDHjaZfMF2xeQcZ1BT9NGmOz+hARTqpy9PCHt29/jsyHAt4uA46TLbw7ZxBGaYZXLfhbxIVc5fnkbYA2HxVI6xb3EjdCi57FXJ4on9dAo/PbsRQU0410M0FUSetGI0qT9PcrmHT9SNhud83J3yVrkU50fUSbQwTBKFp++hk4WoSa7K61rCCTX2Vjsv0OQnCiAgMCCnfNSbW5iFKa9+FqvOLf6hyV/COWucWA/faLLp03aw38cIj1nHgZTKLM40gDoaaS57al0OsOX74LX6UwkKZ+O1hoLvFz5mA4ltllQOe+1J5MEHnAFzLmb0cfacWSEGwtaElllzObIiQsmrI4Ke1g5UdB6kHGIZlbmw8V3arFIknlla2zWVdsG95L9QUASYkd0Oe+uezo6BHWxn18HodaJhrxnGSWgSZaGN/sorkmxkG6zVnLdiGDCvmHPPUqRq7kK+DktHa7QruH1+HJK1RMQBJ216qCemHWiPcTmsZu5GJx7b8NafQweMGEFDSHwcXdfVrRMJMkrB
 jQUP4+bE
 DpzpEw92Pt9qeb28QM7LWYhJPJhzZLSLjRNJJeIBNapd0cBCE0aM2r1VVVFH0FBxerteE0Q9OsMVVbatyvNcLDVe0WEIPyjSljXo3bZnvosIuFm7XgF3kuWEMgGYvfjnkve1IWeh6rS0TsRJWyIKY9QTxIZ6cAKjanDGNcfytLj/0EwQGWDXKvyKH0pC+OtSx3R5nDFE0rGVrTG2jzNQPmkWjPuU4rNb0tgF2778w5pchCubq4fGS6cFhJYTlkZ8pXR1zdQaeRYXzRVmRvF+wW3tQGclExgyhWYt1ICia+picgMKLJQ5K0kvIUe84K5M5gE1nFKkGqO+Smc3/d3dsQyAQOmzMEMWX397B2hJ9ZmcwS0Skhux6ogUepNETP4O9f0onR6dUm9uYs3qPKZJXIz1KpxIV+vLsrhgayaj0WVsUDVDYQ2rGsNvJbVO3XfOm5EO0wOZIqUPXhxCaey2+tOzeAbcngdKYiKppSgtGn+LaDlDvjF4l9f3Vyu49ZfL3ACs/ex8jT8GzdO6jEcuOWxzRD4NiFdAe59KYzNT4hNTBCjHgqj7wnshna475vV8ewVKR3dCP+mcmXnB/bANhSuZ9RYd6UEmDgLy/ArFx4d+SpBMaGciItxDaaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 02:46:55PM +0100, Riwan wrote:
> Hi, I’m a phd student working on memory management and I have the following question:
> Is it intentional to not check for `vma_migratable` in `try_to_migrate_one` ?
> If the vma is not migratable, it would be logical to cancel the page migration at this point.
> 
> From what I understand, `vma_migratable` is called to check if a pages in a specific VMA can be migrated or not.
> From what I can see, user-facing migration paths (mbind, move_pages) and NUMA balancing already check wether migration is possible or not with `vma_migratable`, but other migration path, such as compaction with kcompactd, ignore this check.
> As `try_to_migrate_one` is the only place where we have access to the vma (due to reverse mapping), it would be logical to check here for `vma_migratable` (before we only have access to the folio).
> 
> I’m still new to the Linux Kernel, and may have missed critical subsystem / behavior, and I would be curious to know if this was overlooked or if there is a reason behind not calling `vma_migratable`.
> 
> From what I could get, here is the relevant context:
> - Implem of vma_migratable : mm/mempolicy: check hugepage migration is supported by arch in vma_migratable() (https://lore.kernel.org/all/20200402041052.Y4zsoYman%25akpm@linux-foundation.org/)
> - Implem of try_to_migrate_one, previously managed in try_to_unmap_one : mm/rmap: split migration into its own function (https://lore.kernel.org/all/20210701015416.0t4MkxtDR%25akpm@linux-foundation.org/)
> 

Cursory look, it appears that vma_migratable is intended as a shortcut
to determine if an entire given VMA is otherwise not eligible for
migration (if it's backed by dax, then it's assumed the data should
just live there always and forever).

This is different than kcompact and others which touch individual
folios - but will have different ways to determine the same thing.

If you're just trying to migrate one folio, you can get everything you
need mostly from the folio's flags, and so most of the callers you're
concerned about most likely do eactly this.

~Gregory

