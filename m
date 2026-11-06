Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E772606D807
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 15:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=CmzgYoZC
Received: by kanga.kvack.org (Postfix)
	id 0E4006B05BA; Fri,  6 Nov 2026 10:39:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BBAA6B05BB; Fri,  6 Nov 2026 10:39:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F130A6B05BC; Fri,  6 Nov 2026 10:39:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C56126B05BA
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:39:25 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 542CA16076B
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 15:39:25 +0000 (UTC)
X-FDA: 85405103490.06.CC22AB6
Received: from mta1.migadu.com (out-202.mta1.migadu.com [95.215.58.202])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4C8E3140009
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 15:39:23 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CmzgYoZC;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.202 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793979563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4tmGxuQStKCk7w+onoi1RLdqwI1kArXig6jzABebmog=;
	b=ib2PFvJLi0dGRBiK8Ks96zHpN9yJ7Fh0sbbxbb8kiriXdHbzaunQ/4QqoS/2BEJdEoLcjt
	LSaEjCE1KvAcCjDBluK0yCeeQE+BxyLqwEs51OmmyG1ac1GIn+SsfI3T6cUmJhvkhYVkHW
	c8adkouUeYtutYz0HbJF23Htmy95pjk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CmzgYoZC;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.202 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793979563;
	b=T8AYRsvQkRXlONz9jPsmjDR7riSkeDpdxgTcOfBJP57hqqqlroPa0rb6wvoGdDxgt6beOI
	4TbJd8qUwm9uWWZQQtIG9+sGNXw/E6qHPg2xF8+DRtxD3C/B7t/pKVDK7bBYYjPBqOHb4k
	x9fZ1GEwbLaXZ4XAkrjiEUWVc2v1FKI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=cxp+oaexrpUE0cyElicHmhKBrNrP/fzOSAf3exqA3F4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793979561; v=1; x=1794584361;
 b=CmzgYoZCoSCoPOD8d4J2CNcL+azM+zYCz75PcmISXevWmg5vTMxyEjplZCkCK5TM1Om8yZ6V
 Zbx3Wd/Y4LxkocPiaUzZIXerQYHYqPH79yMQI8F7Y4Qt8r5e7Ub4KBDOVvOGzoyHoXX09hBsmQG
 4dbcIPuXWKdimO8uWiqmyp2U=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id be0c1e5625ffc958;
	Fri, 06 Nov 2026 15:39:21 +0000
X-Mizu-Trace-ID: be0c1e5625ffc958
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	willy@infradead.org,
	jack@suse.cz,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	peterx@redhat.com,
	hannes@cmpxchg.org,
	songliubraving@fb.com,
	riel@surriel.com,
	hughd@google.com,
	will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	peterz@infradead.org,
	jgg@ziepe.ca,
	kevin.tian@intel.com,
	joro@8bytes.org,
	robin.murphy@arm.com,
	steven.sistare@oracle.com,
	jhubbard@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-arch@vger.kernel.org,
	iommu@lists.linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH 4/5] iommufd: fix cleanup when adding memfd folio pins fails
Date: Fri,  6 Nov 2026 23:39:14 +0800
Message-ID: <20261106153914.91168-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261105-refcount_overflow_stable-v1-4-70b9c655da3e@kernel.org>
References: <20261105-refcount_overflow_stable-v1-4-70b9c655da3e@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4C8E3140009
X-Stat-Signature: pydur3yqkum8wbiiocw943q4c88soefu
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793979563-585236
X-HE-Meta: U2FsdGVkX1/hIqAzQZ5yB1NxDW+EZ26RRKmxgXiaOwqZwdVc1229gEB4FrQgAx6EiWKhz5QeWoUchZpOYHw1uwddIgvdDWV5Kg3JB9fQpKQLlweszsNg/lX+EtxScJCyrrmI8NwMVDzgFB7lI67Z5pBwv7nQjYXqRNJP4UYMkud7WtkNx8sYnuESm4cjVDODnZz+WwxTE/ZR+om4FJDnsvxh9TiSJcFWiF8kCCBaITcQ2b8qi9UMuZpsdBzgr/WmMvqzDc1qAH487rISb3hFBc0+7ds+NVlcREn8U7gJ4Xr46Omhhj3Vovo9+b6hPNctZD8eUqEGOg7GoyjymuoCXdxmD97rISV7WrwvhHezjf2U/HnUwAchkOwrua0I3DxcTv52psc64U+jN5BcnZzYAT/7P/2t1NYKNvjsIvemAfKChYO+eKd9vptCMCH1utziCpSjV4JFkWGPvZMteUqdSJgBZD3CNEP/Ad+71De4FFWSQYQMB5JTvPXdqI9E+ND9SjHV9wVaLp7qERS9Uwha6TkC2Au0J98yO6Key3MkBiTho0ulev4AN46PO67C1Myrhtj8BqVbWBWIi+LBqfE/m043nwFgvP62Lmkm4LGv6OrGuAWjZd3xYx/t8WP+xQGN1hjiyM40/cjbUPf4U0GmRtpHUF0mxPsi8UMklaQLADJd+EAvZqG8/ax2jPt5uBpPuJSiaSN+9tWMnxAF+OW6OfKGD+3RqJ9AOzRdH41aGqxZVLmmy8TnRWybr7sCuaRqrXB+z98uu9LcVPXVE40gWB8Xmb94iQicX6xQByIh3Y1BAvBP5pSoQarCicZsdYWZXFLUrwKeMkJuTLx4nFMXBcDULtpGGncOZ4KLZvQsZ4X6sRenrrUBYICbPv7ijo41q7AlzL+mcHCMK1rG+zsW3TQYY5s4O3Ew+sx4WF94mIJBSluQz37O2C8kKdc7wL7PX03eidbRzuCKmc1ORts
 TBZue9bx
 4v3S2htWKQ0U8zm7yXH/2mJTkVBMcwkZ9de/1hxnexcoSoBLFTVwV8Kdo23IasaBSR7nGGWQPLXCO3lfB4ziPic0fklKGy6g823WeyZdVIm9sdWW2WTX0CoE2dZjRYILjpuzLW+pBMiINKt72YfLjQSpptCTjLUfx58897mcNYvjiK9BWpz6MhPFEv22Hpnlmv0295XuDVZkJ8V8GpBZFquFkUIzYwuuNfysU1XjJVBZJEf0RoHOcOEwTs4FIuRVEiOGblpM5VH1Z9wLpBATWRsc8Tm55X916upOaFnpSTGktVDr3NterhYsLstVdlmjStabTs/qL1Zfgvf0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Thu, Nov 05, 2026 at 02:10:13PM +0100, David Hildenbrand (Arm) wrote:
>folio_add_pins() can fail after memfd_pin_folios() succeeded pinning a
>folio. Upcoming folio refcount limit checks will make this easier to
>trigger.
>
>Let's fix three problems in the error handling:
>
>1. pfn_reader_release_pins() uses the allocated array size instead of the
>   number of folios returned by memfd_pin_folios(). With large folios,
>   cleanup can unpin uninitialized entries. Remember the number of returned
>   folios and use that during cleanup.
>
>2. pin_memfd_pages() returns on failure without releasing the pins acquired
>   by the current call. Release the per-page pins for folios already
>   expanded into the page array, and the single pins for the remaining
>   folios.
>
>3. pfn_reader_next() returns on failure before updating batch_end_index,
>   even if the batch already contains successfully expanded folios. Update
>   it before propagating the error so cleanup releases those pins as well.
>
>Fixes: 92687c793644 ("iommufd: pfn_reader for file mappings")
>Cc: stable@vger.kernel.org
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---

Nothing jumped out at me, so:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

