Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4A46CD6E52
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 18:40:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E60736B0166; Sun, 31 May 2026 14:40:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E115E6B0167; Sun, 31 May 2026 14:40:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D270D6B0168; Sun, 31 May 2026 14:40:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C4CB26B0166
	for <linux-mm@kvack.org>; Sun, 31 May 2026 14:40:18 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4F39D1404C5
	for <linux-mm@kvack.org>; Sun, 31 May 2026 18:40:18 +0000 (UTC)
X-FDA: 84828580116.23.A01975D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 94FC54000E
	for <linux-mm@kvack.org>; Sun, 31 May 2026 18:40:16 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EfEXoBUS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780252816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gDniEbMiB4BenIn/IEHnw5RVCpuSrlVy3WIRuPpMhNc=;
	b=xSqFJipHXbMFpXKllburGzeCVTbWjiiCcM11DfYJI1tL4ZTWsEmWLgnSltU8eyWB8YuKIo
	KnsFw1BeRVO7NRHXCO38k0wcrdaBq5rAnAfYO9Tgq5VLPz2XsCYK3OQwq/1WYezmenvY8J
	1J4HSFL1i6dkuOVNgQ8fWqJqHhHFlOg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EfEXoBUS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780252816; a=rsa-sha256;
	cv=none;
	b=g/lMce9ZCjzFjx9H3eFLwdvF5kCjdlzF4qjmd2QpVVDpcTg0sYmu02MZPziLIDlyW+bgNY
	Qn4UVwy3v9D0ZoyHylhJzYSNH6V5KcfqSP3+cn/sIz5C3IJCs3twMMyLsYivXlnWluyLB0
	Ku0vN1UqBDlg71ml5wD4Rq0CJUwtirQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8FC2042D61;
	Sun, 31 May 2026 18:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C921F00893;
	Sun, 31 May 2026 18:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780252815;
	bh=gDniEbMiB4BenIn/IEHnw5RVCpuSrlVy3WIRuPpMhNc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EfEXoBUSjPod8EiHuVf9Lmqp1p4/N3NVQlW5lhUe0FyWBvAktt2PWa624j/IOePkn
	 0Ewu+Agvw+xgJUP1FX3jaxtxBh4l4ZEIHu/P767mkGRGv+d/L0vBSmquJZ0DNd4G2S
	 L0Vw2YD1OmSRoghPver90S6gJIFsTqVfmEIFMKmwtELvbyQRz48Wj/WkWjbuBx62zW
	 NziZEd9RUrErHU38a2ERl7/PFegHNGF2rUikdBUOD3gFdSKn79Z5/9tMz8YG62/lMB
	 x9/lSQ3C4QTa8Nd2lIQi7Tq3/70a0zbjjtGb9wGeAyHy7iEPCmwXeBcBBIhjSl/zPW
	 jwwu4bwp5UgXw==
Date: Sun, 31 May 2026 21:40:07 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/12] mm/hugetlb: make bootmem allocation work with KHO
Message-ID: <ahyAhyVGzXdrigIw@kernel.org>
References: <20260429133928.850721-1-pratyush@kernel.org>
 <20260429133928.850721-13-pratyush@kernel.org>
 <agmS5yZRflzN1M8U@kernel.org>
 <2vxzo6i37bs6.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzo6i37bs6.fsf@kernel.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 94FC54000E
X-Stat-Signature: ti5kaeijrenjhthaphb9ahinwi3zjgz5
X-Rspam-User: 
X-HE-Tag: 1780252816-783193
X-HE-Meta: U2FsdGVkX1/BkMCAEE3vVJCVSNyPcn+tnTRiBGwGLK76IsLFgwYP5lR4h8HLK6v0cMxowI269Ed6j8oG8+XCxPMlEpLM4ng0T2R1ScXMf8rXOLfXPPIYcpMEEqGC86APUwNw/iZOgKh+YzeUoa/o2eSLjoGZL/J9tMvVJCLXAS8mptvD2ppIo7Xi5LsUxvuwS63yHB3/58ZbZ/fC5luHEVqgfmfLEC1uZnq8DpPIUi3M1egCY3mc5f28+0S/7fHPUF41tsjX7avcpy6DnvB9MkQCiDIwQSJ+FRS5c3/n/Lqib2J/cmXJf3XA5W4kw8p+T/mbBe/B3RpmnLEwbAqgB3Yw1BPNp5OjbYpzObg96ihP3V2DqfamZRyUpxYN4QAKbHP1kYhngGY8cKnITVw3re++2FhtWwoCsTqRK8xXNK354ldKwqktJwqW2ltQ1FIGBoXvV8m2eqCQSbzKSFXD7uSIVtPxOAqC//8CvwM1/AC8UImn1ikp4HZ2KN3Jl8ywylgnR3H20sSzJ/gCvvfLrqFqpqo8Ik+UF+sSyYccWuBEthazsNUxuL+KTL+UkFMC07LCD5+FpW4g/gIK8mIUK4Zu7icawnpX9scRuzpdSqoF6TF07ydf0sqA69WqBKS8CdI3rf9+G9kCKRXX060zsalXgInkfph7PbLfKR0cXhYhgFrSD1WXvSOVNZiB7DGiPQnoTc4ymj/BKlPKF1hBBZzSlhJ6A/X5CHMh2J4NA92+aPFGO0dU/DWFvTpwVJnat1YGKK085ZJU+vS3YapBc4I1Z7rywuT/eRbFaaYh/loOEumRXm6HPhITTYd6JXI5oJbhe/Dn3LlkjPvIOaHghhrwVSXsrbP5JHzWyLtGkFHouy89pqE/6YwAH0/Tdnje91uottDlgf0mw/X01xc0wWTjkMtd6uEiZuXUoUh7W8fehirFFplMPvfnWIjFLzztGSL/Zh2Y5LOjaKrtImn
 Mkqd0NfJ
 ceAllfJ3buMfQzyVVMoMHs1AnUpzW2Z5lzG8W3kAI4hf1B3wZmDh6K22YYl9DV20ugS33TFOOac/4yyEkYBWjAQu7peMNahtPgmumaUVw85SXjLon2DXqZXW0fPvJ5CSK5E2cx9IC34V0R1pI09FNZmXobZ0kDh25yF4r3vO0yB0Sy6CUmEHY9rDzV1Gy32rE3rw3CtN+PZoxgM+HRVTmkMQtEQMkQPThRNNzkkJPnjMLv7d3zlbkL1NcqeSJUWYTQiKbT4s12uIv9bglB2cOBA/0Vw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 25, 2026 at 05:24:09PM +0200, Pratyush Yadav wrote:
> On Sun, May 17 2026, Mike Rapoport wrote:
> > On Wed, Apr 29, 2026 at 03:39:14PM +0200, Pratyush Yadav wrote:
> >> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> So, in summary, I would like to pursue option 1 and try to make it more
> appetizing. But I would like to at least know if you hate the "extended
> scratch" (ignore the name) as a concept or only the code it results in.

Let's retry this one :)

I looked more closely, and it seems that mixing SCRATCH and SCRATCH_EXT
should be a lesser headache than going with option 4.

Tracking the changes in gigantic pages in hugetlb also does not seem
something we'd like to pursue especially considering that memory from freed
or demoted gigantic pages could be reserved.

If we add a dedicated memblock_something to allocate gigantic pages, we
can reduce branching in alloc_bootmem() to

	if (cma)
		do_cma()
	else
		do_memblock()

For hugetlb_cma we might want to teach CMA to create pre-allocated areas
and then it could reuse the same memblock API. This seems useful even
regardless of KHO.
 
-- 
Sincerely yours,
Mike.

