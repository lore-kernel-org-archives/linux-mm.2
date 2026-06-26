Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C044C43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 14:54:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F0F96B00AF; Fri, 26 Jun 2026 10:54:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C85E6B00B1; Fri, 26 Jun 2026 10:54:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E1386B00B2; Fri, 26 Jun 2026 10:54:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E9C086B00AF
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:54:42 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 74E71A0410
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:54:42 +0000 (UTC)
X-FDA: 84922360404.03.C0A1FAF
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf24.hostedemail.com (Postfix) with ESMTP id C5DA118000D
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:54:40 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b="X4YVjO/v";
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf24.hostedemail.com: domain of shyamsaini@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=shyamsaini@linux.microsoft.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782485680;
	b=bkjU8d/vmyuAPCdmd2/hfzQGTqsp3jTvuT+PQ7mO4E7UQNbAVANjJWuzTVxdce2TW7Hkee
	9vbik4TNPtvVyDibcHGBrCWA8nPohqoVEKEU41y0IitcU+OBGN95UGulo9x2v3iCRI0oq+
	Tt7GaZJU4s9j2sxZ7QY0u/ndmFrYBa4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782485680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FTDVjpRWTB5xLz1rJhXl+zL1ZWA88STzpaSgnQuzgNQ=;
	b=SdouSrOIYMQl4dzIRMBA1iv5KM6F7U2G6trLYerX+7eiyH2G2VluvKVYs8ljmXvVU9DlAi
	5XC/POk3b4t9CYmhiN/Q7W88axH467TkWPVzAue+Djtudx3lpiMM8D1rrue5U/s00J/skz
	XUljZsNMlQL6bY6OoRS6Wm6B63xEaaA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b="X4YVjO/v";
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf24.hostedemail.com: domain of shyamsaini@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=shyamsaini@linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1152)
	id 6D95E20B7169; Fri, 26 Jun 2026 07:54:34 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6D95E20B7169
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1782485674;
	bh=FTDVjpRWTB5xLz1rJhXl+zL1ZWA88STzpaSgnQuzgNQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X4YVjO/vL9TlHYJDpGFXqcbR/6jI85VyLql7+Y7KNo3wuPzKze1wVfItjL6ugt2ao
	 pRtIz4B/j0SCfl/IFlU18O2+U5ip5iqGWbNp2s4UOb4BDQ0+ex52Pb0uZQW7iDtOEy
	 LL5DyWYNLkeqztby2/J/kT+3I2LZIL5V+lDkfDBM=
Date: Fri, 26 Jun 2026 07:54:34 -0700
From: Shyam Saini <shyamsaini@linux.microsoft.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	tgopinath@linux.microsoft.com, bboscaccy@linux.microsoft.com,
	kees@kernel.org, tony.luck@intel.com, gpiccoli@igalia.com,
	bp@alien8.de, rdunlap@infradead.org, peterz@infradead.org,
	feng.tang@linux.alibaba.com, dapeng1.mi@linux.intel.com,
	elver@google.com, enelsonmoore@gmail.com, kuba@kernel.org,
	lirongqing@baidu.com, ebiggers@kernel.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC v2 PATCH] reserve_mem: add support for static memory
Message-ID: <aj6SqipC/dIN01iN@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20260619062331.348789-1-shyamsaini@linux.microsoft.com>
 <aje-nY6QbwZP9XLG@kernel.org>
 <ajyC2eX9MKSU84Z8@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <ajzovhWHcFQZ9d3l@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajzovhWHcFQZ9d3l@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C5DA118000D
X-Rspam-User: 
X-Stat-Signature: 5s4a9wmzd8g6c5nmyg155gcsxdjq6d1m
X-HE-Tag: 1782485680-406507
X-HE-Meta: U2FsdGVkX1+vWJkdhORnmUjyLbRGyj7B+SjzRiO4AuhaZj/jhDtZacvfarMlBjl23xbKfIBGGNkIs+3UqMqOCgPrJ/drKhfUT8KIjV/PheoOesgd1Z6YHqG7lq9lljxIkfZFlAADCZ9xeaUGOXkin45h3qS+AwVNxJZq7WA4ZIKw0hYQcStq8YqEw1ZYcuU37ndje9OGWIZKCvc4fB9A66XJ/BDWc4PnSVu+9imiEsFPD827mWUT90Z8/bLoL4NNW+mC4t8uB7sd1apQgr+AHisCWYXZqQ/qKYrO0hDzZkrxSR3PWVqx47ceAo4hmI1mAJFBZk8z51C7rs3g09BKXU8ZjiEnKZCsGf+JSOYnshsJYiW7cwqc27SXm36vWawnM5f+ooSa6lZtkTOHD9t8QdKkjfGMj0Xyn002pzS8sbFFLJV0w/WzW90Wwy7+0+ezJbPiTiZMOFrOYZI8NAfdhuG6XwSqTOHCZZ8L8LpcrZzONobNFyQlsh+ZhmKlNUXxI4BaYBirSmszYLK0Ki0e5sIy3LCpB3F3xH7Xc4wLS/jtlP0MxtbRQ4Pw8GV43b4XyF9xgRPAxrwPDNiGQlht86wwUlLUG0SrLt8e8fjjXCdKHmasei21Up334jg+c8PcoDJUJcIA5UI5SIRvHSNDtG+ThOh2EgWacmwYz7YMpe1JtUXGlS+iiL+t/jRsxgjLDCIZyaxHe03FMAGNIVtb2HdTmzlGu1XopuegJpQtguYWW6zmA1VxY0I90UmyCbw6earJ4rtD1IlFe/QK4vmQVNIcyy+n4g4tMQGc/bPw2ah74PfZO4uC9Oy7OFPtHH0dcEI38V0qvEf6NyttZ6h5SDFTFcItYPaACMmPNvDjUQX91zDC1NIY6ssfBhhbSJIw/PRcu45RPoHRyWkzebj2yy+pQveAeszpgfZbffKOUgXz9rTWMzv+hnxw8XL6XhnOYD3l/iy7edXzI3hL/pr
 eKACvbd+
 Q9z5QV6qNpDQucMG90EXLY7qklxcrxt6ruDkHfvgi/+OZSA1IheZGkr+42n5iT7wmHH2kTBe8n/IG0Me/WYEuxfUXAz8ZuGy+7JcXDfE5jrY7NquF5lVJXnIOVgZyooFfioZe+Ay5AqhV//9PDmk8Tp9rCVxPpWCo05aSf4MmANKt32pqKOxeEixxFFZJfV07/QnlwPRbKpdVxkuxsP1TfuEfOgiGn190XQd377bNqNaHia/DpYetPSih1rSnXcw1V/kDfR8NfysAa3kAL+UpS86Vffppe+T+QTTLkM/OMy++EpF9wV3MRbTDSH8MFdgMkUgLppAQZ8OgfsO9R8oyrrh4lLotSttYTorgmj5DdU1+uRE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25 Jun 2026 11:37, Mike Rapoport wrote:
> Hi Shyam,
> 
> On Wed, Jun 24, 2026 at 06:22:33PM -0700, Shyam Saini wrote:
> > On 21 Jun 2026 13:36, Mike Rapoport wrote:
> > > On Thu, Jun 18, 2026 at 11:23:31PM -0700, Shyam Saini wrote:
> > > > reserve_mem relies on dynamic memory allocation, this limits the
> > > > usecase where memory is required to be preserved across the boots.
> > > > Eg: ramoops memory reservation on ACPI platforms
> > > >
> > > > So add support to pass a pre-determined static address and reserve
> > > > memory at a specified location. This enables use case like ramoops
> > > > on ACPI platforms to reliably access ramoops region with previous
> > > > boot logs.
> > > > 
> > > > Also skip the parsing of <align> when static address is passed.
> > > > 
> > > > Example syntax for static address
> > > >  reserve_mem=4M@0x1E0000000:oops
> > > 
> > > reserve_mem is best effort by design because such hacks as well as memmap=
> > > cannot guarantee this memory is actually free.
> > > 
> > > If you want to preserve ramoops reliably, use KHO with reserve_mem.
> > > The first kernel will allocate memory, this memory will be preserved by KHO
> > > and could be picked up by the second kernel.
> > 
> > ok, On ARM64 DTS systems, we can reserve ramoops memory in the device tree during
> > the warm reboot.
> 
> The cc list actually implied x86 ;-)
> Added arm64 folks now.

Thanks for adding ARM folks, I had just included whatever get_maintainer script
suggested, sorry. 
> > For an equivalent ARM64 ACPI platform, what is the recommended way to reserve
> > and preserve that memory across the boots? 
> 
> I don't think it exists, but a command line option (be it memmap= or
> reserve_mem=) does not seem the right way to me.
> 
> Most of the arguments that were made against adding memmap= to arm64 [1]
> apply here.
> 
> If kexec is an option, KHO provides a reliable way to preserve memory
> across boots.
> 
> If kexec is not an option, we should look for a generic way to specify
> something like DT's reserved_mem for ACPI/EFI systems.
> 
> [1] https://lkml.kernel.org/lkml/20201118063314.22940-1-song.bao.hua@hisilicon.com/T/
> 
Well, kexec is one of the option for my use case, it also requires
memory reservation during warm reboot, I think memory can be reserved in
the firmware but this will create a dependency on firmware for Linux
reservation.

It would be great to have a in kernel memory reservation mechanism for
ARM64 ACPI platforms. I believe some other use cases like PMEM
reservation would also benefit from this.

Thanks,
Shyam

