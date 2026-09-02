Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92649C624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 12:10:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F1C06B00E0; Wed,  2 Sep 2026 08:09:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A2D86B00E3; Wed,  2 Sep 2026 08:09:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DF906B00E4; Wed,  2 Sep 2026 08:09:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 733C76B00E0
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 08:09:59 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 07A341201DA
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 12:09:59 +0000 (UTC)
X-FDA: 85168703718.11.34DD158
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5FE63100003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 12:09:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CQFuAyuN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788350997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jIXfuktxBX9npVbn29PNwEDcICMHnTCbs+iOm5eKoxw=;
	b=ByCkmCC6qCapcNhpu++86+VUWAnLn44atsxlUsvh/nCT7JvNdDHNufcDELHWbyCClmnoo8
	e7TWX8wyUoG/8e/1OdnO2o8xJN4hMpTb+Ds5efUcfML8f2HG9+5iZzgzX9MMec+/8reIE7
	UXmQ2V9eONsOQslgkwy3jJClnbM1rXY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CQFuAyuN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788350997;
	b=KjOOtM1uVij+YIsiZ/ougiXVyr+oDIiHRuI0p9P1JHJdCQl3qOn5Y6bcc8oSKsoAH9JRZb
	7VTXxv8azxt6z99rXgZLTFuGbXpyNHe2lRyYYrA7j6Bww1wjJ2Kd8/2nsmTcJ2jmgFZ4+v
	4x+8L6Mmf+KImV8zwHVbi2dLuArySsM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 387DC43AF5;
	Wed,  2 Sep 2026 12:09:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B35051F00A3D;
	Wed,  2 Sep 2026 12:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788350996;
	bh=jIXfuktxBX9npVbn29PNwEDcICMHnTCbs+iOm5eKoxw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CQFuAyuNHerDnWsaFITNdyKdYk0CDRDVo85WOXqItPK45gd2qprMEyHWZtia5OZSD
	 F+oNuD69Rox5filuXKINVTARp9sP3eAtoharI+a3M2Rss1fvn2x2VqC6o2bnFRH5lX
	 sWfvLXb1DLtYNwb7jeTUmS/hQ/87QH/5c2hyMiXPXNLunXSDqWjqqIHT7fx0mtt1cb
	 p1IfB55BWUQcWZ/99vYKL/i24P6KmHe42oWKm5A/Bq3divRGIFn/AZs9yj28TGXlGE
	 TBOPKGpJU+vTbGBPFq8cP7Iz3+tYBQsIeMQbIxlczwpxE4pmP+9v23ctQP2IEoPg8k
	 nC6gFCN9OuuFA==
Date: Wed, 2 Sep 2026 15:09:47 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Eli Billauer <eli.billauer@gmail.com>
Cc: David Laight <david.laight.linux@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>, Brad Warrum <bwarrum@linux.ibm.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Michal Simek <michal.simek@amd.com>,
	Ritu Agarwal <rituagar@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 2/4] char: xillybus: replace __get_free_pages() with
 kmalloc()
Message-ID: <apgSCyj-h2xVc2ss@kernel.org>
References: <20260830-char-misc-v1-0-05e2ce44f291@kernel.org>
 <20260830-char-misc-v1-2-05e2ce44f291@kernel.org>
 <f6001085-9234-4025-ff34-6cc4a66c293a@outbound.gmail.com>
 <20260831123937.32255a49@pumpkin>
 <apaF1HUtJnstuUN4@kernel.org>
 <1729fb06-6beb-f8ef-3e71-47fc3f00345d@outbound.gmail.com>
 <apcPg_y-HsMki7we@kernel.org>
 <9a3d6a08-339c-3315-cc81-46907d0836ad@outbound.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a3d6a08-339c-3315-cc81-46907d0836ad@outbound.gmail.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5FE63100003
X-Stat-Signature: 4w38zn5g3oh4sgnp3c3mfbfx698xy7z4
X-Rspam-User: 
X-HE-Tag: 1788350997-309875
X-HE-Meta: U2FsdGVkX19lpb0NSRHLfbUF0bCrRxsYIfkgPe27StTwnvdiFyo+9vp8B0liaCYpMDRpOy9lKW2kB/0pESLZMT3dE/pTk/Ym1mxotXAjnP8RfWDxUU6J80/+GnqCnrsy68QByxn4Pdakp1VEXFA8Sct7szPjHLx4Ubuebx8LpfATLCRUMsOmYWe6+DcVzDM/bdYbcQZ/gwl6tgJVaI+S90rqh1ZNn7UewkyBah3KYczjmmw4DCR1c4uXoGuhKYqSA2VjnLE2hDb/gShX+y6Z/sOjoElSVmzmLbHoaEEKi46fwWLKqonWx9hbOZHOEG1s8VQqljWDQksxxn14ElVzN668SDpovo+Hv3mIRuaKEcJinOl9DxkBo+BnC++k0VagwnjEmOUCEUfO05RvO+Qp9RcluJLZkCSug7V63w8V725RpQW95efxetdR8xfAYI4dIWlFAjgUSzTSUdKVRMKA+o/0VnYgAj+voFy4zYAZe9B6gRDPY3P562ZoFeRBr9jkdkg1R/XkftPlPSi/tkorXxwpMiN1kQAaiE/gfikdkTziVFk4flOnAMtoeoZ/LIUvkRwmdy/fCGxqr0Mri1oNIlKE9ZNNAh8fXMWJhseLR7w5YqhSHtBOU7lrLuW9mxP3rvQRyy7tlLaQxXK0rUIYexmQ7eOvoIlrtIuapCA0eSt8eHwUUoab8De2dsZ3OgH8AcWliwH/vJGWoBSYs3A+08umPgXO/XVGsQePfv3dxRq8mNYOwzscK1SQyK/JZ8kW4/uikiJGVZzlRoaDV84vRjuVneqVQq/06Z6v7SRHHlNiEvu+OCx4/+DRNJL5PKl5JieRZ95aJnMN1KRXO5RC+BkyHOsLZ64kbj0sBsgDIHfCnzJ2J5PpaWgkkwrb2AClcDZQdx3P93s9moJXLwKvwMNhAIHziRpiEK0dY0lRTPNE62+hGbU8RGRcgZjaZiyY0OsSPrOO8lVetZVDUiN
 l3FBya61
 ecJ+3Z4kOiH491Df5dvFecLRbBq4dr7srwflUIbtOuXoaPtzu6SNQkGJCZUgIaGzNQVRwApJAbC9HQiC/5SoqzV6z2d/w+nNdvuPlIQq8huipDDiEsE6Ewpa3JZGLJkipUQCjS6nxZfaEBnjB3zkRki2C/WkY9w4axGileM1lXDOTzL0WAaz407AE1a7PNJnD/d6rxcS5w5b7vSGECq0qDWbwoq0guOgKDgfj7IaIrvlnm/kR/tLU255Ar/Tsz+Z9tsdOUYv5Ij6fPOAyrNrUBxDOHIASDx1WRGIBuWFy2cxvnYp8JG/7Xn0XZmTI5YMxONPdkoNcTQH9YFBn5FiHWAvRGdXAfdmU8+hclsCtycIsbGPg6W3TnwBdzXObyVEksWPo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 01:41:54PM +0200, Eli Billauer wrote:
> On 01/09/2026 19:46, Mike Rapoport wrote:
> > > * Does vmalloc() guarantee that non-pageable physical RAM is allocated when
> > > it returns?
> > It's not pageable in the sense of demand paging. Some architectures lazily
> > synchronize vmalloc page tables and this can cause page faults that will
> > take care of the page table synchronization.
> > 
> 
> Thanks for this clarification.
> 
> This sounds like a showstopper to me. Immediately after the allocation of
> these buffers, data from the USB device can arrive at 400 MB/s. If the data
> flow is throttled as a result of handling page faults while trying to write
> the data to these buffers, this could lead to an overflow in the USB
> device's own RAM buffers. This is because the USB device is an FPGA, where
> RAM is an expensive resource.
> 
> So using vmalloc() may result in a malfunction in the data transport where
> the __get_free_pages() would have been successful. This outweighs the
> benefit of a somewhat higher probability of success in allocating very large
> buffers, and surely the improved aesthetics of the kernel code.

kmalloc() still works, just like __get_free_pages()
 
> Regards,
>    Eli
> 

-- 
Sincerely yours,
Mike.

