Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7384606A32E
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 20:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=OgCkpHE1
Received: by kanga.kvack.org (Postfix)
	id 07F3C6B05B0; Fri,  6 Nov 2026 15:46:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0570C6B05B3; Fri,  6 Nov 2026 15:46:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E87CB6B05B9; Fri,  6 Nov 2026 15:46:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B9B876B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 15:46:21 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1D91A801EE
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 20:46:20 +0000 (UTC)
X-FDA: 85405876920.02.D9264B1
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 327EC1C0009
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 20:46:18 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=OgCkpHE1;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.172 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793997978;
	b=ZB4g/w4YY0BRI0Fmm6jbY+MOG4t4ErLSa429x7zd81nZTjMC8ei49pzvJ8PsB+ENu8h+uw
	zG1mvGLM66xsKbdg4e43X8gW7OUSNJ8XObDNKwIrVwZBDcskQfV9KzucV3vx1Jg5DVO6l8
	POwiWezwybV0AkCqFpuruC1MTZy7CK8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793997978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZEes90VLavY8K6YFysNzmt6SItRkZVxy3F/LlAcJTS4=;
	b=LG18qYq+6W0xUH9VTg5o+xL/1oq5/hMtWGrhvdulDWp71B3v6OtXpTBNoKR+Gi3lcC9Weo
	OzyoMllIs52UG4CFICC/tpmc5Osc1HHCdKl2rUpmjouuFfsrxFk+URDoYrh14whCAEyY+d
	WEzlPBsJkP1rUuhbreTSokmdNDRsjMI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=OgCkpHE1;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.172 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-93e63ee7b4cso114130485a.2
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 12:46:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1793997977; x=1794602777; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZEes90VLavY8K6YFysNzmt6SItRkZVxy3F/LlAcJTS4=;
        b=OgCkpHE14cBZZ9MQr6lmacBmUMK1McPk66fc6UiIhvYC2o+2QCFNsTTGGUWCHVYuo6
         5NxuxIwYEFVTF56jmb3azGLarkZbKYi/ZMCRy5N11YAU3s/eTueE1bBnNtRz1m0vIrWF
         SBAYoe+V4K8cc6U73aUXyKBijfDIQO8B1YSrEk7bC7Xp2vTcQa7fx2glJcxDolzkGeBG
         k9QJpFM2pL8xIu0w+etA8XOI0Do0agbQGmjhUPFWvsdIJj+gcvcCpenPGXh7k8D7ftAv
         wNw51o6Ezz1TRThaZAUB8kags5c7TpQwTe51RcoMR/pS6RutNtkRdyKaqk6DmCrqMB6/
         qyCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793997977; x=1794602777;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZEes90VLavY8K6YFysNzmt6SItRkZVxy3F/LlAcJTS4=;
        b=UhvT5/pl5zh+WGUHPLn3ssm0X1Vpy5qYb81k2TQTQFwmpz3ajA/148otNdlIJhQnB/
         CWvTkobVBnWNIWKHrZyW/oRseLB4z4NxtQBVKubMpCmFsMzBLPNbaZs1d5Vy4Xcjg6lV
         H6oqdEiny5FgcKWBefW6Q5yxxA5caaZcBvkwm3+3pOj16J3ZYNjwpmAJUjrSWxBOfUZO
         h9Z595b8T7JjGv9VU5sn8Ph8tSnWi0dK3yEodEmaNj4I8PLm1hEEcjV5tX6ZFz7fXIez
         VBryYylwH/II5FXFEzHSSw9Kx2vt0ndPx173ub9q4AZXz/JhkABudEVv3Y+zmunrxDpq
         +hIg==
X-Forwarded-Encrypted: i=1; AKwUvByBrV8JU+mpMahn4C2yUszJy+6Mus3oKKfw1ovkIU0hFhplCkRatPe/+Adl37PFKmJc/0Sa0zf89g==@kvack.org
X-Gm-Message-State: APuU4Z9pUk52fQxwd63tz98VJlHNSCXJQE+eTF+ERNW4gSjRpw1afFvr
	hRlfWpHhXCGHFUdzJtYH7EpHCp+tRJQsjDLtfcQPQwPD74Cw+LHYrSm8SrTbiCTUs0o=
X-Gm-Gg: AYBFou2oOogH7czSHXdB9/XZr+zxNtICQUgPT+4Vv65AmY10FilzVbJzaOgvl/qp05p
	TQzmzS4E9I0+oOZNhJZaLhks6sP8aJZIWPegYRgPW4WWs4S6O+QlzzgJ8LbHnioG1G5g1e8R/8n
	daiTzWb/vu3lsLDB2vhitlecqP8Ln+SqkhEBpdcGuVoIcykxQIZET159LPGNkKHgWBsQ017z4cS
	/xwYATmP1oZb52QHBJqA3SLVGk3ZYCFWTWO0tIdpf1zf4lSZ4hItEE34UKFYALoBYQHim8ZdOj6
	USTfl5RLm945dOX0SitqTcJlbsFkRy+wJzUhiIxrr4SVlSOl+yqPdo3V3uRVmtaLQtwBrJmv0KH
	Cc6uW2PLeKoaw0GduVMZ4/qClvplOOgrM3sxA8S6OAxz56Jt481qhDOrnZ7D9E+UIT9x1nW9hpZ
	qW19EXCGPgwOZiDVye9p8W51/CpSTI2X7JZLcJRBF4VCgLPPxV+F6xwnV8/ny4X3rh1B68Ex53Q
	4HwwCltIg1xKnlEspuI/PYGeC+rm6/A0qsUo14doJFmWKB7hCYpSeFl9fsh0YCQ6COvJ+nY6rR5
	JmppaUrXfL9/3bYuoqvIoJWgbVGYjjIgPSxy/IQMxBcmb9W0bJTUK9MLSGz5L64YR5QqM1SYCGF
	P7H7T9jI/VA==
X-Received: by 2002:a05:620a:4507:b0:939:a003:7127 with SMTP id af79cd13be357-945f35a6235mr574216085a.52.1793997977262;
        Fri, 06 Nov 2026 12:46:17 -0800 (PST)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ea6ac8d02sm28364526d6.42.2026.11.06.12.46.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 12:46:16 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xPQpE-00000007fOt-0vRe;
	Fri, 06 Nov 2026 16:46:16 -0400
Date: Fri, 6 Nov 2026 16:46:16 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Song Liu <songliubraving@fb.com>, Rik van Riel <riel@surriel.com>,
	Hugh Dickins <hughd@google.com>, Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Nick Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Kevin Tian <kevin.tian@intel.com>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Steve Sistare <steven.sistare@oracle.com>,
	John Hubbard <jhubbard@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-arch@vger.kernel.org, iommu@lists.linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH 4/5] iommufd: fix cleanup when adding memfd folio pins
 fails
Message-ID: <20261106204616.GL663069@ziepe.ca>
References: <20261105-refcount_overflow_stable-v1-0-70b9c655da3e@kernel.org>
 <20261105-refcount_overflow_stable-v1-4-70b9c655da3e@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105-refcount_overflow_stable-v1-4-70b9c655da3e@kernel.org>
X-Rspamd-Queue-Id: 327EC1C0009
X-Stat-Signature: uagros4eg8yqpmhk6zffkzb6utwmkrcw
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-Rspamd-Server: rspam12
X-HE-Tag: 1793997978-346599
X-HE-Meta: U2FsdGVkX1/FB/+7M0sJr5cJo3xRDRNxao/8CR1RGB73v4VhGZbe5SQxmLlhpp9FJHZRdmP1QU8dj54khLPL2lr+r0OamM0zW+nEu6BCuGAOn44yEylpfvqNGRPauk0/LUtCLdVbpJZ1mPvNbN+GOPp3vtRs66PfhbX/66isFGVJfcXEYXVNPo9a3ULqGk1WwP9W1I7AC5r0acKynFFdLKksuDk/HvssdcEsaj6Ef3IjfeqJWiEBqh6Hk3a4pfu0UgVHIWYw4W5dUMSoNsg0uMo5sDgjaw3xN+zOOhfM16ah3VJzvf/jvtIGefR3/iNaL8L5dOCoIyoAwk2IApk9jcvKIjaN4yFc0HfiZI8NtCPVzDHrduQpKCU4Eb4ZWdBQrmfCMh4uYnbs43EsmIhAodl7lafuXaTCzafHqnM12EiUOAX4ONUb9QC7CIEGLRbJHIsLMZZSURtxAulXhBdLFgjepYzvKH8/p91Y8eKfpqFb+BJefI6O2PN/ywiiKSXqmzjv88QTuD/pMIAWTGPYYxyriRFDE39keQt8PJX3uaeVm2U46j8ecDjzs1TPZ/cGByEvSrAGmWEyja2uLhhzRR364VWNjAUL2lb/S+rN0F+momIuTVR1Okj3/dvhwJ3+CBmaPrJsuHEIi74aaGkC7mzbFvwX6odeeQzM4eFoTa/5kRoXJwmjSU7pl4oz6tLCmAryv0inm1Nd7Vmkhk5lh85+6pzUZhtOC2JUw8mmNrbsSJVK8aGvGuDy5CCsskhLU9i69WcA4ekBhFjVlxpGY0NsEwK9B2pWc242CvVcrsdXYHycfEAYZ9VtHpz2dtM2r+P5LRoV3crEudvcrWbJUZGzdp891da1PxAPbgRa4dDQAII0cM9lhwoGg53hadaYPtkifRpSjBqkyNdpbNwTAMh/MAEbjs3xh7O0Yn0L8J07Awd7UX7DDTjA84D1k7xeCzwC8JwnlWJn8lNrACJ
 HkSNOsoI
 XmtUpRG+4rHmryUpIGOTIk/8Ifml+LUeBYtwLUXiq1/bCMz4oHiVEccpRzpg4YPyOmqpJwgfdWStDXMKjjj3xy5s2iHIBBalgI7ogPUBrcxyGaaiVMaJTEriWTuxq5MPG4yUTjfv8DKLeh4Br3PCGXvNwVA8Iyifiv2QaIbXsoWHC8n63m/dwRe/dXKt/01DjM1XHozn5HFHJSkHILdYmxtqL0idFtqDVTi0gBdl5pjCMxpiImmVVymPLNh/s/R6SbMTiZrD4RLCZMMAP73P3+kjFrwAwrcEF4E+2dLAor4YgZcPc5qiOL4xm5UTu3AgPwHMuGlQXSck9VuenTY+fjRxukDNqvXVkNAlz40RYO07a7LLE108zvLfYsSDDjtZF9RJ+MsxuTFyZrYbmf0Ma2e5Bfa4L7jlbMGp0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 02:10:13PM +0100, David Hildenbrand (Arm) wrote:
> folio_add_pins() can fail after memfd_pin_folios() succeeded pinning a
> folio. Upcoming folio refcount limit checks will make this easier to
> trigger.
> 
> Let's fix three problems in the error handling:
> 
> 1. pfn_reader_release_pins() uses the allocated array size instead of the
>    number of folios returned by memfd_pin_folios(). With large folios,
>    cleanup can unpin uninitialized entries. Remember the number of returned
>    folios and use that during cleanup.
> 
> 2. pin_memfd_pages() returns on failure without releasing the pins acquired
>    by the current call. Release the per-page pins for folios already
>    expanded into the page array, and the single pins for the remaining
>    folios.
> 
> 3. pfn_reader_next() returns on failure before updating batch_end_index,
>    even if the batch already contains successfully expanded folios. Update
>    it before propagating the error so cleanup releases those pins as well.
> 
> Fixes: 92687c793644 ("iommufd: pfn_reader for file mappings")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  drivers/iommu/iommufd/pages.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

