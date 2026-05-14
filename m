Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B167ACD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 10:26:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8681F6B0088; Thu, 14 May 2026 06:26:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83FC46B008A; Thu, 14 May 2026 06:26:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77BDB6B008C; Thu, 14 May 2026 06:26:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 672806B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 06:26:52 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 192CE1A0187
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:26:52 +0000 (UTC)
X-FDA: 84765647064.21.53970E1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 70A344000B
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:26:50 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k53Afmq4;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778754410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5WSp3l+cFaCwagWOamLNIglte9pwaPW4eqiv/rOhLBE=;
	b=gNOdbuOy94crVXdLoJA/otTxPB8Ehbp15qqmAqkJErcVhuDF2WcRAsyNKWm/6BjAQrUdpF
	W4R42nIQjhQfOHuA2ZQfXe+hhoCC0YEjLIF2rCNmtGS4injPPSe5sQCAaTv4jBVJvX4uKO
	ghlpke5++DaVavQfwfFgGGyak11qoAY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778754410; a=rsa-sha256;
	cv=none;
	b=u3gJNe3vX3j6zwYkdhPVJTxdEozi/jLYwLtKUcm0MbMS5cmGRN3DY/w6OJnFk+sOclF/hq
	0JRY70WUVACmKausBt026CYoQAqznfTqfODCOCowshLtubxDyj4lnY7v3qd/rqrBPpyhBT
	gL1IIszSKtZws8tRvLibe2ZytXIuNN4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k53Afmq4;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 52A2A444D0;
	Thu, 14 May 2026 10:26:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F5E4C2BCB3;
	Thu, 14 May 2026 10:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778754409;
	bh=yI0AVKoI2bMfRl+o+LGYeYWOpoh1qRXG1ugi4tFJvZs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k53Afmq4bnnoAwz5A0yxAX8gAFwPUFDRHN3ai0uBVL/s4VQjrqi6+HT3LLXM5ejNP
	 KbZyRBz+CY1oauNPyq2cyCwAi6yz2pWR8SUWuxiYYYYuNqL2nTqXn3p2aOvdTKNPOY
	 VNxIjY1TM4PTmtuapTf+OI2b/rFq3E6SbkoFvW7MJcyKiV1rGIc9JnQHO7aXn43/gb
	 DKHjB1F4i+58E5BG9Gfzf1GTADwb767FNXstGOmEtyuaQEJ9MXui4lTfMvqB7SFDcg
	 iZwyKI/UN4GzpRPNT2uBJYeJImy/N4vgxCvKHEjwXV8azn8G2x/j3/twcJeJk010xy
	 9Wlz60HUysMTg==
Date: Thu, 14 May 2026 13:26:36 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Luiz Capitulino <luizcap@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>, Li Wang <li.wang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Mark Brown <broonie@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Nico Pache <npache@redhat.com>, Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v4 28/55] selftests/mm: hugepage_settings: add APIs for
 HugeTLB setup and teardown
Message-ID: <agWjXHKrNruVGE3O@kernel.org>
References: <20260511162840.375890-1-rppt@kernel.org>
 <20260511162840.375890-29-rppt@kernel.org>
 <635a6440-9339-49fb-ad9b-ee2f4b285ef6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <635a6440-9339-49fb-ad9b-ee2f4b285ef6@redhat.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 70A344000B
X-Rspam-User: 
X-Stat-Signature: xcdkqr6q4hgergtf68gd3fz5gqjzmxk7
X-HE-Tag: 1778754410-845174
X-HE-Meta: U2FsdGVkX19Grs08Mw6eKEJLWtiIAVb4be4ZHuJpH+oouwMzPI5+XhO6QdfRqs22evBXgOguhW6kkLpeZKoRwc5VlXtBujieIT8f4DsjoksKQA8VeZrX+I5hJYxqJ7IbjzwF2NmCVOthjfPDDT2zBc450v/XXOsFhPmIbsf6uxLWhVxfnydddNVVkbNMts4MAtT3lv8lM/91hejSkl5kRgzTc78ZUU8ze7VSWsMqKNW50i/btRm+uw1U9WWXb7IZKiKxxVbvb+cIYmDX3ofzuAfkr1Z8TXnq86Q65bEZDiY58fVI5BiFA0zXZa8jFxRqS47wlvyeU4F8I3YOM88hCxkKNP47pjBHqylcWN/m5aHmm3hCgtl+CJ4QOSvNiStcMlghtz+wVSMJplPDOOIGOwYZhnrxfq9Scgz2TGo91SKcQ4vzgGw1GIoEU5UeJB1ZV0yoRLr8y9MgOWd1q1sFJKTpczgYU9VdDvhnLBS0Rcjdqe/UZ2JakRWQ3qHoimk8Cf+XDoTJpN3yg/soq18nTTureoNpI9Zzi94Nm1MMerFCIkk8jsNOnRDdJjqUxs0RlvAKFZQ3w1QgdfPfhLJ/ZiJ7luhiREVGtEV/c0kHdgQXu/mSpFfBR8uPnl3JnZpp9KcwEX7F+h0v6sn30Uy8zJo3h6y9BUAredZBJmDeAxLZ41LRbyGeeMH5AW4u12dKc/cEekFIMe1tVB20Zyz5g9u2XBeLN25kV6i9EDXRjepivSbcc4XmClkDrSnkMSA1yl9I1MLG7JnNLJl4idYa+ciyZuIPqCW1xIvzJn1IVQAFTnbJJven5qqbs36YP/JiAfuOMJMkKLBYtpkILZoOrU7IONpRIdpUObpsHLg/GzeKXpQsvKPTmnS9/Xx30FvrDJaW+aPQRnS9PY6gGZL2HzjZPY4/FloHZWvMVyE8ttAynpWMnNhAD6GxaU7cacmxUHTf+f2OsXLUEWu77KX
 FWqzpaE8
 VKIgl4LcHWwY5VcDUOHszp4LPX38i9rXh9sQbz6jB4ThEulVUoA7XmBDtB+5XRwBXDg0mYZC+2JJ8HbRtSX3WsjEMge3BGolCWKXbghJ5HCYsGh/LpFW2LcqUSTc1HTVmnUUeMIAo5vyHk89rQLkf0he1RmSfFPxOBhIXE7E5gSaT5jcSma010R/cyPPIURqNUlqBpfW9FN0PjCL536drhUF+HRjNiPmuVFKJAR6qdB7d8UsYzaV/5BOZYzY+tG8PxcMx629OhglcWjpSxA73VUqR/BQ24F2eBeMVZOtrLAIa/rTBZp57KAHUePGXL/cD6cajNERBY9BS7w0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Luiz,

On Wed, May 13, 2026 at 03:50:39PM -0400, Luiz Capitulino wrote:
> On 2026-05-11 12:28, Mike Rapoport wrote:
> > +static bool __hugetlb_setup(unsigned long size, unsigned long nr)
> > +{
> > +	unsigned long free = hugetlb_free_pages(size);
> > +	unsigned long total = hugetlb_nr_pages(size);
> > +
> > +	if (free >= nr)
> > +		return true;
> > +
> > +	hugetlb_set_nr_pages(size, total + (nr - free));
> 
> We're using 'total' to preserve the HugeTLB reservation that's already
> there, right? I guess this won't have the desirable effect because the
> tests calling hugetlb_setup_default_exact() will override this anyways.

Even the tests that call hugetlb_setup_default_exact() restore the
original settings, so if there were N huge pages and all of them are free,
after the test we still will have N huge pages.
And if there are already allocated huge pages, tests that require an exact
number of huge pages will skip.

And if all the tests run sequentially in a clean environment it wouldn't
matter. 
 
> Having said that, this is just a minor nit and not a bug, so:
> 
> Reviewed-by: Luiz Capitulino <luizcap@redhat.com>

Thanks!
 
-- 
Sincerely yours,
Mike.

