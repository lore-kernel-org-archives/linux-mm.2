Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC4E4606A33F
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 09:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=kf1SQrmK
Received: by kanga.kvack.org (Postfix)
	id E580A6B05B7; Tue, 10 Nov 2026 04:58:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E09756B05B8; Tue, 10 Nov 2026 04:58:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1EDF6B05B9; Tue, 10 Nov 2026 04:58:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A99ED6B05B7
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:58:34 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 15CC51C402D
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:58:32 +0000 (UTC)
X-FDA: 85418759664.06.484C8FB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5F86040004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:58:30 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=kf1SQrmK;
	spf=pass (imf04.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794304710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TlKmrMqubWGcutwYU1eLJxZAztftwteeVflHLwgBZxU=;
	b=ECVDPXNmdWX6s3HrFRQAhO8u9zoENmJ7GH2l1UnQ2jgqwnBGCxIJ7eEKLDPMHpwelomgs9
	E6rjwgOSThiMzqsxccw2Kpp0GNRzSMlkCa9e066/m5URypQTW9Wq6BpNMl+8r9scTCC7y/
	fHkehFAFG574bM/GW8RVK010Gy7e3b8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794304710;
	b=MH8+bJQpVtDo0dcO1uy9FGmSRy8Ef5ikbtBYlUE9jYh3AKaeqdrwpQw1VUOUGy4IroD85y
	j3oPUdvL9bU0rbiB205HmLX7ht6XCMQsUDRo1tLei8qjGIkreP64IVta/ajcAewHNciDXv
	QEXXybO+tRLSRrsLQ8eNTTiGvOGbuxY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=kf1SQrmK;
	spf=pass (imf04.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2EAD41516;
	Tue, 10 Nov 2026 01:58:26 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 470B33F882;
	Tue, 10 Nov 2026 01:58:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794304709; bh=fl+3iIkJlZcywl1c+YGvuOIqwpFdKU76MjeZXGMEd7Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kf1SQrmK1e0qc+QMHXjVSFZ+A5DZQ4BHKBMeWJR15j6j07DccroldNhyH+PwOr29/
	 75Ygl0XwQ8NuPANvbjMf40w1fDrvHwqV6kDFd9SkKHB+xEPzKCJBPfif5DMBglkVBV
	 q2BUtTcJqx1EkMpzURaTmwnXyUMMS8UuKX1rBcV4=
Date: Tue, 10 Nov 2026 09:58:24 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Rik van Riel <riel@surriel.com>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Yuan-Hao Hsu <aa9736195201@gmail.com>
Subject: Re: [PATCH v3 5/6] mm: gup: introduce gup_unshared_pages()
Message-ID: <avLqwIWHa5CAbHO2@e129823.arm.com>
References: <20261109-refactor_gup_fast-v3-0-2aaef02df0e1@arm.com>
 <20261109-refactor_gup_fast-v3-5-2aaef02df0e1@arm.com>
 <7627c0d90188b581e7740bf8d17c8dd07b460f89.camel@surriel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7627c0d90188b581e7740bf8d17c8dd07b460f89.camel@surriel.com>
X-Stat-Signature: a4ui7rqyosiztqs95tm4e9goagifkfpz
X-Rspamd-Queue-Id: 5F86040004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794304710-180289
X-HE-Meta: U2FsdGVkX19oI1KdDrVeFW8lVy9FsJa0mPRwg5GwNnzbBQzm8mKP9DARFiUACUQ3HgquOtu3jY7LgLjYanmoaAq3VjPXv5D6MTHDLDKFWldPL3IP6uGqVm+UjwxU+U0/5grDeCHqXYiKT9/YW7rrkwF66Y3DCL534a5JASABpkwJNrwIkrpRqFyjyylmHTvv5D6fyhjkNabK1Z0PqatRXCUhgmZJ0IXej5YrRZNjlnTB7zd5RuVyXUhlu9Xt1EXFQlWpYdxWmOrkK4EwA093ogQB2mKEUhfLVFmvRplnOdGT+2ZMWOIOKa/qLjQ2FhOWB0vUwMNHq073UrV4zb+JyCHoMEEmHdft3laSM73G3Kaz0l+FkVBZrf9pkSXcs3IvHX8kyyQci9t0+xsePcyzhej6YcSflbv1hAb3F88p9g6FLV3bR628Fo4SyJkqpwPVOcEYGpZ/0R/n+SOeoURRf+gs1zstCyGKcklByxwCGZc+lvxVGSD7DYDMd6YURwdWp/rTS12jBe/JX1Li1MUyewRchm+MGNm19s6lVgY6sDd0excUMEv3Ylv65pPp2Og/dlaHofU0pHZcZYd1OLBeBkWG7KbE15vR4fB86gsxEuTM2aJnictjkpFwuoJ6SyJKeERpI6J8tKc3Ud0hZHxkorP+IXPkCoKak56kcJGXeLbZSw60FRREq4t9rs/iAQvOYpsnsy3zqm4QZ0lOglbJoRRlH4gUEwB9LD6lM9uB+JZ3LXz9E/tMFMMC+eVCxEDow7kjp9xNE2HFPtmsUDQidDLDGjN8y2/hpkjWd7bdv3pv8ST8w7YACUGVrmPJ0MQ/sRyWaEy+32/AsmjCzkEVXmWGNXESaWJ3gRkXtpFykT4l3RMftHE16A8P+m1yGA46BVCSzcT21BwCfey3HECgS8LWOUjH1tcnwLv8fLRmiOt6Y06FrPcjknNbUJoValET1UNsXNzaJz+9JMH776x
 GU0/HhFF
 rIPgu8Zglwoz1d2QioKs3ohNVyv1Z1t6I4u3QpLmKgSBDgGUx1yOcuN0FmmvPYHTEhpljHKcBrtJGPQPNF6ZfV9yleGUI84l9ts1ssC03wXIVsbs8BB0r4XR78PJYEcn7YCha5aAT0TPVvCt5PKlX5MFV1VKfMR5LwPdCSZMLraaNXLhs5dZikn7U7hfTrLWCTsrRVWUaM+N9QvJ6xTMh7SixRUrpI8iQsSHWVLe/X+TzXBFh/VGCAZ5qC4yQjcFCI42KCoY+kfvqNDsnBnZX1B19x3wEqHd70Ly3aeAB6tufLP2cuH2az3cstZ7Us5x9A3g+nrjqAAAixgG/SggiC0bHg23qtXJBJb1TIifezPpEs8oMKmcOqey00q613CKT7uF4sRMWVIzHZif80kIgnFs711vxfHUaBuhI1V5d1tIATe8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Rik,

> On Mon, 2026-11-09 at 12:32 +0000, Yeoreum Yun wrote:
> > This is preparatory patch to make gup_fast_pte_range() batchable.
> > 
> > Introduce gup_unshared_pages() to count consecutive pages within a
> > folio
> > that do not require unsharing, and use it to implement
> > gup_must_unshare().
> > 
> Could gup_exclusive_pages() be a better name?

Yes. This seems much better for me. I'll change it in next-spin.

> 
> The code all looks good, though.

Thanks!

> 
> > Also add a folio argument to gup_must_unshare() so callers can reuse
> > an
> > existing folio and avoid the compound_head() call implicit in
> > PageAnon().
> 
> Does that count as a functional change? ;)

Right. I think it would be better to remove below sentence.
> 
> > 
> > There is no functional change.
> > 
> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> 
> Reviewed-by: Rik van Riel <riel@surriel.com>

Thanks! :)

-- 
Sincerely,
Yeoreum Yun

