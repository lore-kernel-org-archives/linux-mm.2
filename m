Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D2BD606A329
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 10:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BckKRnto
Received: by kanga.kvack.org (Postfix)
	id DAF1D6B00EF; Wed,  4 Nov 2026 05:31:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D87C66B05B2; Wed,  4 Nov 2026 05:31:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC4386B05B3; Wed,  4 Nov 2026 05:31:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 929416B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 05:31:42 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3BB1C1A05AB
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 10:31:41 +0000 (UTC)
X-FDA: 85397070402.21.E5EE7B5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9767D14000C
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 10:31:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BckKRnto;
	spf=pass (imf09.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793788299;
	b=MtlGMe5Lf0l7BBLB8dVU+ySsZuy/FDyswZArp+FhOmxNNMa/FDWm3aeXdsm/TyBE7g7pX1
	IzoZ9845Gm2FdbVpq+un0A1aDygLWJiIt1mOazM/IeIU3E2YTeIRcUXXz+UUwmI3+rFJW5
	BzjX98kTGuFb4sE5VQazVWB3N/FpCt4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BckKRnto;
	spf=pass (imf09.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793788299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L4FLZcP43DZnnGwB2Ff/3PX8AXs5+l2GsOb5VDmefFY=;
	b=m+Vq2MCQMXb/XaagXqtTIYMRLc3IePtsr7Zx0ltgeoGo2YzE//3SobroSnVjJCIaCDZdxt
	5LhwPndCe150OljhJaRKJofb9mGfJE4peoyMrdXtHCorU02neBLJp7IaWSBhF9yJm177oF
	aHyG/VYcesF6akmw6623cLjIej0NdFQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CAA714451E;
	Wed,  4 Nov 2026 10:31:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D75BA1F00A1E;
	Wed,  4 Nov 2026 10:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793788298;
	bh=L4FLZcP43DZnnGwB2Ff/3PX8AXs5+l2GsOb5VDmefFY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BckKRntoBWtnIaO1wAT9iKwLdh7ctP/N2hyM2T7ImOR+lBQOkxttg3u2XtBw3EZTR
	 VUUTzXly3EpovKme4CyI1X5JXbwUHb2Q8Q4gvEnwz8yZX1SOcF5cGF2WrZa9G3TToU
	 5DNAdHpqkJD8uGBH4AW0F7zmRNa7YRbeRsYD9QHZtYj+l3nrqyNurxVHkSutfMRY21
	 OKhsJtGUy0QDs4kdKisIwrBrUo+8tZyPoMi837Ex+eDS26Hfc5ubQhOvMw7JEh1m3K
	 1BnZ7mKnFMLNUoF1vS4NopGIf7mmixPEWyBQxeKqi6lQPqCoeSSpGoE3EJc4dS+dCf
	 Ke8peo41Ws8eQ==
Date: Wed, 4 Nov 2026 11:31:31 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 07/12] mm: hugetlb_vmemmap: simplify shared tail page
 handling
Message-ID: <ausJg1hMuE4UJDH4@localhost.localdomain>
References: <20261104023510.260766-1-songmuchun@bytedance.com>
 <20261104023510.260766-8-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104023510.260766-8-songmuchun@bytedance.com>
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9767D14000C
X-Stat-Signature: eexagzj5ofmfjj1fcxzn8juo87eoswfk
X-Rspam-User: 
X-HE-Tag: 1793788299-758685
X-HE-Meta: U2FsdGVkX1+ZBhtu9TtNA4TSJgABlZF6h86AFnbgC/ioyMIZs5vrGuScfFbQ+57aaDdA49FaV7K1OhBOIxuoUXba61UKJ1TvToPtBeoX372DTZ/yN0VAA/twkzSUsi37lC1lm/oxKzz/xntjaKkJwGm46iea9gCEgbCcS9smB2RequtPrriOiIYvni+iA96gqiOdzJJ7SRIJbfzCxxaaP4ZWc+++iJP1S8aBZV2Ea/M78A+b1qJAtQixVRmURGGLrZ+unhmegmNjkn2fYL4JQmKX9m1YpLDE9u20sznm0cpS1gV0m5nbSMXaYy4pc7rDfDsG7j0cUUt82nvKArRAUuIAPRvSqrE3Mqvw1tdPZWDfIpl0/HRsBKptZuF2R+EgGLkHexJqkD1zTBpIPzsUzgOeGRV4dvO9US74cKjz+hrwJoGyspMWNDefHblTETn+H/dTJg1xeqe/e6Rr7gPB9BR1CXZbVOA1/h7fTBfimrAbTMUo0514DzfG6nN12i/BtLXxWUJ3djcyLge1x9wiPzkseDcNtYKXtDGOUZ9kop3Zh3dvYpvjzOwpvl6p2km+oSOgSa//opsIyJ5DhfChKTn8UsMY59/rNcizJL/0cW8hsUi/SH4lWN+MYUbz+y5TSwSHFTjADWotjnB+We9bGwTzNEGK3keKZYo+Ai5ZyonuGlm+K9NCSIWBOzxcxxKTqlN6bxWQeUX5BfNQRw5xjVoThktnx6l7iYhHdkUD3En0Co5qNK6T2JJ7OtMj+DL32r4pIPcBFOlCLFAyE1qCtWZBhgS9Jijta/KlQIJwGXF63N8MyJxwYwgLKn+IuWi8FywtqWh2+Ik1dcAMxVE8VQsWV99OK591xTIMWBkpyQzABagSsQkgAYQlyoHjioJBUL+0N/f2+OFvNlI7KQqPzxxcsG8jhm/bVDaeXGycBCfD0putIQmiYTM7AaFKHi0pk3fI1OTAcW9isdZGmP5
 aCg7Y1Gc
 IuJzEG2wpz4VhdVySN0UQEg/DZApkbYn4I9LmPO5xFmA8xoKaywXGsFDLXYG7hq1rnrcztoTdlgbXoGs7dF0CoPZtuxG5oPVj7QZhG+zynvctxZWegqI26HIJQf4yLVbDYuhFlAc47U+9uSaeXJazo1TRq3wqoj6AlZ8jFYUpzlmEf8aoWp8UEnFcQG6YaljTL6PdtzdEb83x7mCVRBIL2BneIvQ7Wa+FyOSW421ZDy0tsN3Jl4qPX8hqlWWK7qZEdsX8nYaK1z+9kitq+VLy0cWg719BKjBmwtgjTa3qMt19Ppa5jCsTBUJGtQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 10:35:05AM +0800, Muchun Song wrote:
> The remap walker currently carries a shared tail page selected by its
> caller, even though the optimize and restore callbacks can derive the
> same information from the folio being processed.  This adds redundant
> state to the walker and couples its interface to caller-side preparation.
> 
> Derive the shared mapping state in the callbacks instead, keeping the
> mapping policy with the PTE being processed and simplifying the remap
> interface.
> 
> No functional change intended.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs

