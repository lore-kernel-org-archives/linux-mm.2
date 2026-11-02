Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC9A560A2606
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=jBnJTgXW
Received: by kanga.kvack.org (Postfix)
	id D84CB6B05B7; Mon,  2 Nov 2026 09:07:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5C396B05B9; Mon,  2 Nov 2026 09:07:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C71C96B05BB; Mon,  2 Nov 2026 09:07:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A88C76B05B7
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:07:23 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 435B9A010F
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:07:23 +0000 (UTC)
X-FDA: 85390356366.20.DF49ADC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6DDE01A0006
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:07:21 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=jBnJTgXW;
	spf=pass (imf19.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793628441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XU7NgO7ikkcuAODAla/GTJ/uKE9KKokx9jR+UBm8e9I=;
	b=QKh76GW4jxUB+rqwW9Fgxqz1yGySojWG+1JehL5yuNe/nz5QHfVq49ErpAsGelu8psQNjA
	kybbFahEP2zUOeaigdNDSYUF3OVT9HnpTyBMQL5at0PSSkaupoSCUKmNUAgYzymeGoS9iP
	58QrkI9ILGVsus+XcCK6i7yxzPYhOmE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793628441;
	b=JiyWBzqn2/RCOFuwKdwkkDrX9DObY4PeU/bkwlj2YUGHNpXMO20krNF9vvEBA6e95PXU9F
	xZt9nYhqLC0R3MI9mLbc7fNABUqKszT0b71jrIm9ObOrRkZK4v535w0pQajiLwsUkMQigQ
	BTAH4Hx8Zvb5fCUTy0zV60ceaVx8ljM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=jBnJTgXW;
	spf=pass (imf19.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 688DD1691;
	Mon,  2 Nov 2026 06:07:17 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8799A3F59E;
	Mon,  2 Nov 2026 06:07:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793628440; bh=okA/++pW27xIdWmqVZy2ykipgObAMuboinr6ec1sU5Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jBnJTgXWfHg+QNg7DQOItwTLd4XyLxdbeDwlTbO7ufrAlk2WRjxuW02nKMvY37PPk
	 QL0RxH1OvafU8aG9fX+0TV5TunRW15831s/wOJZNZVYvdCkmiqkmIFDuopKtGau0G/
	 +lMCckX1nd4n1qkrQi9h+UUvCfMyPVH/6hwSKrnU=
Date: Mon, 2 Nov 2026 14:07:16 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rik van Riel <riel@surriel.com>,
	Yuan-Hao Hsu <aa9736195201@gmail.com>
Subject: Re: [PATCH v2 2/4] mm: internal: fix inconsistent in
 folio_pte_batch_flags() for shadow stack
Message-ID: <auiZFJ7Bb6cQnqtX@e129823.arm.com>
References: <20261102-refactor_gup_fast-v2-0-bc1ac018c834@arm.com>
 <20261102-refactor_gup_fast-v2-2-bc1ac018c834@arm.com>
 <85c4a87b-2c8b-4ef5-bb30-6518080f8be0@kernel.org>
 <auiI8jzumVHmmSV9@e129823.arm.com>
 <9a67e7f6-0ec6-414d-8689-c70eeed6100c@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a67e7f6-0ec6-414d-8689-c70eeed6100c@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6DDE01A0006
X-Stat-Signature: sdshzqu56qfpf1wxud8fqimqjn4ae9fr
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793628441-614404
X-HE-Meta: U2FsdGVkX1+uzZgG0A0U1QmuVMIlv2N3U0GZPFZlL0RgS7UN9LQ8BYX1ZCms1o4V/TIOHbjpyQNQWaMPD0T1Ud6DqvF5BRHLZrIbAW+3DRwhJrRDJHlcIo1Huc0khEXniXCOPZgUWMbOnmZVAozNkI/Ezb+UbxtKdnUxMD3GEHK1j/JJqVYI4NYVuX8EZNcdGx76wvJNOJ9kvg2xXNsDv5eqypbRr2p+NEsXknYkt8Crr1pMrtEBQR6eDQTrn1CMxriNBVOEtCTQhFITPzvvgvCUqqf9h7Ln42/odQL5PkY9nxTq+op2RP7EGtOgAUGfD7n4eqMkwVX6/n/UGgfeAdi0wQJkzi1Szu5NIEu+qejjWKkRDtUlq98Ut0c9XsVjet5594qjxVEkzuCzHWvPuXQpqfG8kJv2uYgKJ8AztN0FCBqOWrxH5M5HKPwsigfxXYVItu3VSBW81O0mI8YCDcfM29hYeJEB+VTQgoO5NEElMaac6AjvDiIXTJoIZsO+z4uVy/oNfn0Kf+ML/67pMqQm9KnscUIHz9MMes4Y68lUIxN/tMm5TM65uevEqMGyUAEIDMVPF3brhs6HaDblSFk4DCqZg5evt2c8Dd4kYxFkAS65Mpu8Nh1ympSb3jHrEcqoa1tgvKsKaiJrHo7EivM4uZDLYLXFoUKTVYQnTlJ8lEQtziwerNoIh7GH7+Ue+1C/NbB6BfyYf1md6v6n47Z9SaoRNK4715K0lVU7WSR6sma2s5QMwKudNp8fO8hSvOCjaXMp53QCTOMZqJ/jRkVP9nJxc3c2r7oqwBUm1j+a755JvylcLPukajQbawXlJka1VP2McsIEqgc9iskKZcAmfrRCIF7iKE4KqMwE2zVn8QIqCACORONBCQuRRlqH1+xQ2cr/nP1s/L+d7OQ1ddhPTCMj1L1EU/nLrW8Lo7myFoJhvCao9C3eJAUQs7DNdf5xIH8aqRkcymMyD/G
 hu1I0fOY
 qiJTKOfHne+sCb2cT48rEIlAYmghZWyj3EMcDoG9jDWJIO+IfSN3uDI9ijDfJt9Q7wyumioxntyOtdvOttajKnSQpETxYo+fiFjXTzwhfl/b01C6WMRPmNkS/Ks/Gmn37EeZgenOyO2YwtQOblZaahpAPgobgzRQ+AQoCv/EcQ4DIu/FS8hRkh/wkgWefUTKJIzU+kJMqg27TDNPs8kkNkPg0tAlcfETnsN6awPEbBDY5qWJ4jvtsJ2QmB2zTnA319YpACBeFxna5ogMb4b3r8RgZGeH4OgfSHaez
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> >>> +		if (unlikely((flags & (FPB_RESPECT_WRITE | FPB_RESPECT_DIRTY)) == FPB_RESPECT_WRITE &&
> >>> +			     writable != !!pte_write(pte)))
> >>
> >> It might be nicer and more efficient to track if any was readonly/not-writable and
> >>
> >> 	any_unwritable = !pte_write(pte);
> >>
> >> And checking once after the loop.
> > 
> > Sorry. But I couldn't follow. If we accumalate with any_unwritable
> > and check it out of loop once only, we couldn't properly nr value or
> > Am I missing something?
> 
> Ah. The idea was to simply reject the batch entirely if that happens. It would
> only matter if some folio PTEs are writable while others are not ... well, ok,
> there are some cases where that can happen, but it's not really the common case.
> 
> I think we should simply disallow ever getting large folios into shadow stack
> VMAs for now. So I'd prefer the fix below.
> 
> Thoughts?

That's my preference too and we've discussed :)
I'll repost with below unless anyone has any strong comment.


> 
> >>
> >> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> >> index 4b71d010b2aff..9a2dc90ef9690 100644
> >> --- a/mm/khugepaged.c
> >> +++ b/mm/khugepaged.c
> >> @@ -367,6 +367,9 @@ int hugepage_madvise(struct vm_area_struct *vma,
> >>  {
> >>         switch (advice) {
> >>         case MADV_HUGEPAGE:
> >> +               /* PTE batching doesn't work reliably. */
> >> +               if (vma_test_single_mask(vma, VMA_SHADOW_STACK))
> >> +                       break;
> >>                 *vm_flags &= ~VM_NOHUGEPAGE;
> >>                 *vm_flags |= VM_HUGEPAGE;
> >>                 break;
> >>
> > 
> > Yeap. once we do this, we don't need to this fix patch anyway.
> > But I don't know whether there is practical case changing the
> > VMA_SHADOW_STACK with huge though it is initailised with NOHUGE.
> 
> 
> 
> -- 
> Cheers,
> 
> David

-- 
Sincerely,
Yeoreum Yun

