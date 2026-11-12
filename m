Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F8E9606A334
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 18:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=FnYrG07L
Received: by kanga.kvack.org (Postfix)
	id 3E6FB6B05B8; Thu, 12 Nov 2026 13:11:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 395B56B05BB; Thu, 12 Nov 2026 13:11:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 217146B05BC; Thu, 12 Nov 2026 13:11:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E6E8E6B05B8
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 13:11:42 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1022DA8306
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 18:11:42 +0000 (UTC)
X-FDA: 85427260044.04.63AF0B7
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1FE2A1C0006
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 18:11:39 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=FnYrG07L;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794507100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vbhDJD4+BQC4thd2CH24LWDde1jZ/0BhOjMBI9uZ0t8=;
	b=I3QzG2u243Ts+QJLeesS9lIg2sIEK3r7RNx6Nn5pSLsDSbw9OGei6d9eVbimVfTlQsAQpg
	+/UMYiwZETOxXbV97BRaOcU7VXYtaTvYmcVIfZ5nqPp8tL0j44usMHwlMyh554slVKwlIv
	lBL7kPRYfVTRiQ+6iXwDWlhtEgEIAFM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794507100;
	b=XWaAiJIZ3DWC1IxvceSST3UB81S30SRIQv8N+pgv6D861T1ej5Gqb4LLCV1hWIp0kebRbH
	YzSj1yn+kuDnwzsdbISqGtMMMU1bMqQqm7P+FXyrvMslawJg3gjryx6q22qUHl+uvIBVTU
	x7xt0xkc9FgZNMCfMTzqQlDggeozM4g=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=FnYrG07L;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-93cc1ab5f6cso3534985a.0
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:11:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794507099; x=1795111899; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=vbhDJD4+BQC4thd2CH24LWDde1jZ/0BhOjMBI9uZ0t8=;
        b=FnYrG07LvOEhzF+3SlAa335W2b7GPsiPApiiqSlZxwPUO+6YZUZyJUFEiVWXVbZOQw
         evRk5MTD3TwhYAgqitk0x9EXjUIHot1DyLlIOyxuinkmo9+5QZsnxWVsZFuQ4DSQJWPg
         JKyqGh5zEMyYxViLsK8KKzsly3tfY9CPEN9PyOceHwoRbgnDip7HH0BYsCcqK4MAPpHU
         fkjTr+rTmUIPcVpLONx8wd1LBHH6C82+6cK8DLOj0W0ZOYEj/WNKnasJ0kCPgFViZ0T6
         74WCha4+a3oeBDOQWSfo+f7mo4DxUGueH3E5hW5UkcULDpRxf/SxNhTvj0yQuAfVJOWz
         0dWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794507099; x=1795111899;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vbhDJD4+BQC4thd2CH24LWDde1jZ/0BhOjMBI9uZ0t8=;
        b=C4YFuYhWUh/2W0GYvrbLw2CXn4BkJZIwmhJku8JTwrGAf9jxxjlckhZZufDXKo6+xw
         SEFsQ6q9AnqbyZwlAi1k/YMfqklHeDifLkgCI4EnhW6MvbH5CXX9B4ZbPD1VOCl421kR
         ZwPVok45HCCyfROfnpc7eYMqJt78QZu+C0cYCtNn9NLj3nxPaeWWaxLswBL9ebOYxRDq
         9kst1zFeM6acxQBsEX2vicibAOO8modCYz9kFTS78QGIStkLJ5Iquay1tmCHjuDLa1lc
         6SXNDdfZO6LGvjjeo6ZFrVmjHulVtIHG/zGfGv7xAIxQEnsbJVCHZveLosrfH616/c+8
         3/og==
X-Forwarded-Encrypted: i=1; AL+hErHNBL1l3vbsE4gvUyIjo38iyaI+/I6HBSpEU/JToEOpwa3hX7CyguLSB6wWST73aGN7hRjPk8s5EA==@kvack.org
X-Gm-Message-State: APuU4Z8IEF64SgOw9sv9MXFLnBNQXzpMHkK9WgTjdxXAk4bfVBXWvuaN
	KJB8b/+0daCVszM2yE468HMntQMTMETZrE6RpDIU0aR9MgLPiI6BOFm+yRZaYqJIH+I=
X-Gm-Gg: AYBFou0FSmik0crTTU1Piq2sILz28ds+g+qRsk8oFkg46fDsW6YW4o7MPpm6tMEeF3m
	WJuCVkTPFoPuNY5JuPKbICAilgBrXKlbRAdGdiagUKd56ulprS912OElUVFWF2eI5f6nvcGF7co
	m4iAuBxHDPtjnivRdK1C7t7CsvpaOBCQv7s44wzy99j6FMHpgDSQvs62KCvW65e0np0/ZYREnUa
	xnLok/WNSDU7g/3Xz+LpeuW8Ne1lXpiCKOw7MtumNwLhPGCdahPXeiYvjrx4J5A++aO1s0ErRdQ
	4r4TFA95TRD1zPQChRrVN0PHVMq6sbB8bL8lKtPVL/vTyOLKKVkeNCoi1vO1ym/UOWylGsAdBn0
	pkq///NZ+SwuSyU1L3yFa7bZF4doYvXPysgQ5u4Lfg8O/PlO9jxFSbn5zkFQeVkYL8AjqMtztbO
	MzDs2Fo0+9tLox+tjKCjHOOiJu/IIhcRdwAzxCjKDRL6MgO03yv4NQikbSu50XXi7tuxMFPTR9O
	kakNgjpyOhSbN4AJYwenVJMllOUmHpfH9ks9T9A/darItA5o7GlVIdXQ7XrWW/DFjlQb4YSxGV1
	KKDWel6veHSu/XDVknOr+Zv1/JvnSYUpidzTO+0+5vuvbZfw9LsI7YyH8Bn6IBgCMjjAXe9gXhu
	/BsRJD4E=
X-Received: by 2002:a05:620a:410e:b0:93e:c12c:fbc4 with SMTP id af79cd13be357-9494bcaf24cmr27719385a.81.1794507098958;
        Thu, 12 Nov 2026 10:11:38 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9479e7845fasm776538885a.18.2026.11.12.10.11.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 10:11:38 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 09/13] mm/migrate_device: fix use-after-free of the
 anon rmap
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
 Rick Edgecombe <rick.p.edgecombe@intel.com>, stable@vger.kernel.org
In-Reply-To: <20261111-mason-migrate-et-al-fixes-v1-9-3d2454362e8d@kernel.org>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
 <20261111-mason-migrate-et-al-fixes-v1-9-3d2454362e8d@kernel.org>
Date: Thu, 12 Nov 2026 13:11:36 -0500
Message-Id: <179450709690.482102.6960491372735414259.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam06
X-Stat-Signature: boe61bkdnebb4u58sbd4y1y9d6npp3ia
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 1FE2A1C0006
X-Rspam-User: 
X-HE-Tag: 1794507099-669526
X-HE-Meta: U2FsdGVkX180mEPlRNa6WvZc7C6MU/3C2KYRXvtW1EuzHwAdISKam8ddp5WhAcOIC1DbfpkGFJVA8s+T2riunRETOu2QKR4k8hHHbrA8YQpBBQZQxHPlUCyw9D70HYXeLGPPLd5iSTOmCqxZ0n3cHB3xl1sTXy/2obO03p6kCB8jo5HvYYZk4Y0A/xP7XSwSlbJPSeR/NVFRnQeJoruOqt3KjgyCXYOtPcwX7YPsmIVCXZOhywsePlQjWCqRo1gU71duB9M3LPyDEt8NBTv9g1pdxxR+F/rHdb1IQoQyHhgzKAN8vA/7auSg9HxymmkhCJENoXfYlPmJdr9C2RLaHoC8vp7xsDya2+GtNbmceOWTaB8uFAl4bijxq01+enNAhpfZptRBxMt2djMq07qjwACij2Knr+478yQBTmwgO8zXj9cZhiYbZzeRethdtL2Ke8dd6qtl9pvBpezKKk5AkFJpEOQZeyabN1Ret7Iz4S71IYdvIA9VNtzos/DgXDCi5e9eXJAy8PGE/+ZG3zqeYuuudpsdzLAlH/Rdh+XOMHX6uFBn+WlczFIC/g19lqPWGiVQ/j0yoMY5lu+UYChn6QKdINRaLWQ5Z1t5l5qiDrU6xf04tU45BWxjl3EgzwXkVuEEuxK7vLPKtIVj2g5OU7XA+dd5U1WY6cP3YocoMwVjFrTxNDXFh8WVoxHCqdfmhqj5UbbtWLkFyoVLGDLBAf0YaxuKHB5zZE3ijRyERpA4xvoOTIPODv29rF0UKzBtU1BvoAPMftFKZTDxLt2bFBM2N3zOXshF0yscby/oRrrMAl453D6pnJfjLdo/GpAGMoUZWOAW3NlG+wG6NPwgjoCF7lqJQlxGhXqUFlBpY6SN5OYPGG3MEnu1k+Efj/6owr7/r/SxxIDIaAUGjX+Mp3dwfWonjKN8zpmcxz25Y9tWEPiDVluOK/5HIZTBpAuukyyBY/2TszHn1/eUGsE
 3+VBVWe/
 4LMdI030IDpFWadRWUp3Uak/sTXaIyuEVe6LGemKcxf110IV17rGOiS9J0bYiM3LiwndKCP7ro0U1IqmvdLBbuX8HG9dtjieSKiP09ynQ7/+cYcRMP7+fg+GN/w/TajcnKj9lKGPkwZwl1A2ALjPq7lErb3o4yIRyBwXsXBbf/dnAdHsoiIHFmaRO9ppCbOBnfiHviB2DkAxKw1Q3xoN880RmSl1dVuV1xV/RScJw3ZAVdr1B4A8pC3sJEA2rJA2LDEkQ9pA1sj4H1wKiuThalXhH18ckXFZMlxj4P1SDoo27ctZuAQUKTE44Z51YIqL+sR5ffwIlYsKMfb5xBDsPeZhvZeI7sFr5lyXRllsVwR7uIIXrSlvGgjaK6WqFDJ+1Fb+7Q8j2WUxo1mMckcNulzMSgOUZ+wapNRRg9NaNkuG7kl1MweiCccgpkVv1gvBZRGqhf/s+k6Ogn1U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-11 18:13 +0000, Lorenzo Stoakes (ARM) wrote:
> A munmap() of anonymous memory can result in a use-after-free of the
> anonymous rmap if a concurrent device memory migration occurs and the
> migration runs without the mmap_lock held.
> 
> This can occur for a long-term pin of device-coherent memory, or a driver
> evicting its device memory by PFN.
> 
> Consider:
> 
>     eviction                        munmap()
>     ========                        ========
>     migrate_device_range()
>       migrate_device_unmap()
>         try_to_migrate()
>                                     zap the migration entry
>                                     unlink_anon_vmas()
>                                       last VMA: free the anon_vma
>     migrate_device_finalize()
>       remove_migration_ptes()
>         /* locks and walks the freed anon_vma */
> 
> If munmap() runs before try_to_migrate() instead, the folio is no longer
> mapped and gets no migration entry. The walk still runs, and follows the
> stale folio->mapping to the freed anon_vma.
> 
> Resolve this by pinning the anon rmap of each folio which possesses one in
> migrate_device_range(), migrate_device_pfns() and
> migrate_device_coherent_folio() before its PTEs are replaced, and
> unpinning it once the walk is done.
> 
> A folio which is no longer mapped cannot be pinned and has no migration
> entries to remove, so skip it rather than migrating it.
> 
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: e778406b40db ("mm/migrate_device.c: add migrate_device_range()")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Was able to reproduce/observe a slab-UAF in rmap_walk_anon with KASAN
enabled, and that this patch resolves it.

Can't say i understand the change well enough to R-by, but I can say
this resolves a clear bug.

Tested-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


