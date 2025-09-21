Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D52DCAC59A
	for <linux-mm@archiver.kernel.org>; Sun, 21 Sep 2025 22:26:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A27EF8E0005; Sun, 21 Sep 2025 18:26:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D89A8E0001; Sun, 21 Sep 2025 18:26:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EE748E0005; Sun, 21 Sep 2025 18:26:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 76C738E0001
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 18:26:22 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 11BEB140427
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 22:26:22 +0000 (UTC)
X-FDA: 83914692204.07.2F87052
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id 52E46140007
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 22:26:19 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=eXHuVgdZ
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758493580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Goc4fu4E5QtA9qLOcM+4h+EpWxYEBSIjsqPof2KABk=;
	b=oIhWw6zasEsQlsr/acuneXmzxsBVMyTIGg/vRp6imH6H+cM2hedczmV9O4bsFWN2R/1itx
	sgh+vnMK7d3i5laLh73k/30poadwH2xF5R6i4MyYdvafEW7f7QRS9+apz+bhDKJBBIEJ5e
	SITdL7+FtiDRTupkGaiQcz4BPbkUNs4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=eXHuVgdZ;
	spf=none (imf23.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758493580; a=rsa-sha256;
	cv=none;
	b=wrWiwjy8v+XDy0Jo/XG9r1ckD0pYIEueY7wwq1b0PMaBOqKjXQGfYjFSqNZrN0vdrfV2g/
	MAmIzsZQZdqz+6wAThjw96tMSboy41EBFHsYj2STVcaoo8xNSMT+bqo5evPXsb2Z06zJyz
	KV5/SoCuSRjU6MwZATYKRFURrCeWn80=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0Goc4fu4E5QtA9qLOcM+4h+EpWxYEBSIjsqPof2KABk=; b=eXHuVgdZPnG4LY9fvzsP9Thzot
	7SaWdtBpIJZJ+ZMtycjRH8f62jRq439I7bIDyx/lEVq+2Y10XLWKT4YXi7uMdnYZoofhXR7UdOOOB
	RSmpSUJ7igwnEk+/VRLt6W6jicEw9dEBpykWNOAi5hSq+cGm/noOLpvNUmbGliqToIXvQ5yXENXp2
	RhvcPu7pLZ1vqzz82SGYd/zFFjc43f6hYFhbKRjCSKqROT1b0A30axHs3tfmYRwL7WZZCmarTEiKL
	JkJqPsmNJcpyljqdklBvphzT8J935OBZoPhSuDwqpF7dZ38OGrRXbJC50KHrwCVSBrEm3TWxEt6d5
	dCR4URDA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v0SVR-0000000COjD-2G10;
	Sun, 21 Sep 2025 22:26:05 +0000
Date: Sun, 21 Sep 2025 23:26:05 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Miu <jasonmiu@google.com>, Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>,
	Joel Granados <joel.granados@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Petr Mladek <pmladek@suse.com>,
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
	Steven Chen <chenste@linux.microsoft.com>,
	Yan Zhao <yan.y.zhao@intel.com>, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC v1 0/4] Make KHO Stateless
Message-ID: <aNB7fTesaVCXHB0E@casper.infradead.org>
References: <20250917025019.1585041-1-jasonmiu@google.com>
 <20250917113609.GB1086830@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250917113609.GB1086830@nvidia.com>
X-Rspamd-Queue-Id: 52E46140007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: fi8d1q7gxpnshpoomh1xaqx5bpp5ooeg
X-HE-Tag: 1758493579-990467
X-HE-Meta: U2FsdGVkX194l4aeWCuWTo4DEWuYjv5Oh+3PN9xHBI9CaTDGa+TuouQRGfoUQxDWH4GlTzoyV3lLTJh5J72Xn9DOEfaVsg1gOSUkcdihCjcbZGwk3vzm0E7Dg3I3ZgTAaY+UQKldKzpKauWxRODG6AdeDYT1egWUwsJ1kR8Dzx6+PGy+MKM4DxJnTnhgLGiLSX+aXfUP3Tpnc1y3RdGOlf1ulTJcs0GoRz9wdXGjjUHO7tKb0Tr6xeZoipqaXP49Am/b91QSDh55YGKIXicu69mTiRwJmatcVZ/nMmKi5iAqyAPZQAk5j+i5Kk/bZoydufe4zzw+nMTVBolADPpy9TYytGptrDfZ6oVg4brxvtsFO17Cpo1SikoPLmEUuCb36KRn0PpOhhmgh778Py1P99wiTIioLjkAO8XPj6MP6cwO1Ndg3b1yRFoFxkA24jDS9JW5nJ0p84Num/cyMutJZGMB5BYrBFbLPQExz8TaVkBQgfvoR0/LVOOL4KeiX2IAmdKn0rwE1UvEzAc/L89kRSloVd3TY9xPlHZwOZ3ACZEt1ofD0UoXTZRy/BG2N78e3hM2/MVSpDp3Fa1chMsNziCcGVNoOxDAkZT/CCdKf4CbmA8PxArFGYZMcK3V4woUa3tsdG4Au2qOiG1VcVm9Tt8cRQ8S79Qvag5+L3uKwRSPMjxmqckerIPMHTd4qveYd080SVjvHX8VEKMgltjnkmJzscJPEkG3L3uD8/7XwvizyrMW0z8OJykfNfD11oqcOzHMkNOo1PS9mVovYEjCSgVMhW+l5+N1LGQcPkj7YJlBwxmJVuJGwZDNsKq1e9JFXeWr+3dIVPT6risR6M4Rq4yomb4Zu3+u4/1+aD4wsJfoTrwqaepkRh0sZLJKJWsqF/IxryupKYwQkThTWrasSbQl/REdaCbejGzjnE14OieDSx7rrTrbkI0LSI3slOJqE6Qd2x/3Pl6u+BBoaUc
 3og3alMr
 x0HxfKgDjz0/ce5g5exyQovBkg9JelGWU/r6zKA6q6wmpAyAcrJpSvvgKXEYnEXxwypdQHDAZcEb3GBCsSg4rC7denWy/0z//JS4VnX2eS0mA1XdbaP/A4fTfXw00aoUklQAIuh8Crr1i4PU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 08:36:09AM -0300, Jason Gunthorpe wrote:
> On Tue, Sep 16, 2025 at 07:50:15PM -0700, Jason Miu wrote:
> > This series transitions KHO from an xarray-based metadata tracking
> > system with serialization to using page table like data structures
> > that can be passed directly to the next kernel.
> > 
> > The key motivations for this change are to:
> > - Eliminate the need for data serialization before kexec.
> > - Remove the former KHO state machine by deprecating the finalize
> >   and abort states.
> > - Pass preservation metadata more directly to the next kernel via the FDT.
> > 
> > The new approach uses a per-order page table structure (kho_order_table,
> > kho_page_table, kho_bitmap_table) to mark preserved pages. The physical
> > address of the root `kho_order_table` is passed in the FDT, allowing the
> > next kernel to reconstruct the preserved memory map.
> 
> It is not a "page table" structure, it is just a radix tree with bits
> as the leaf.

Sounds like the IDA data structure.  Maybe that API needs to be enhanced
for this use case, but surely using the same data structure would be a
good thing?

