Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA1FEC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 07:49:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A9276B00D9; Fri,  3 Jul 2026 03:49:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 559D56B00DA; Fri,  3 Jul 2026 03:49:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46ED36B00DB; Fri,  3 Jul 2026 03:49:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1CC636B00D9
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 03:49:20 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7A3A71C3718
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 07:49:19 +0000 (UTC)
X-FDA: 84946690038.02.C9E25F0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id E2AD9140006
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 07:49:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KGndhYQa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783064957;
	b=dqK1dOSakkKSqBzU8ZgjrNkMDuKu0TCjPmmqAhadJs0fXF+XClHMKCl5H6F7Hk+rBoYoRg
	faUxnA+6kkmF+LujL6J9eP9krkNrC84ahVDs+S71892pGhyvM3Z5ejuZnZIOAq9pRneTkl
	+/xvJHYrnKu1pNCj1HTEwiP5IEwcFS8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783064957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CIkFMzoXDcnD9nBYqCI1NBbFTtaOgztPoTY9RG1HHBE=;
	b=RBl6eIWDYcFbPyEDcPyS5zSPMkHfARBwGK0O28UHNrhdISk2qbisv0gSEUiF3yQ4cdiaUT
	fcretlqfjjmHhh4hJ0fYF3vR49kQ/aiEn1J6d4xEt9iZPrIL9y8iejYc3q3yPM2daalWhv
	2/1M19CTWyRmFgdQ45+ZvCvY/lF6nvI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KGndhYQa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 434D96001A;
	Fri,  3 Jul 2026 07:49:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E4B51F000E9;
	Fri,  3 Jul 2026 07:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783064956;
	bh=CIkFMzoXDcnD9nBYqCI1NBbFTtaOgztPoTY9RG1HHBE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KGndhYQaN4X8CaaQEmB0znlSGwQ/HhvM9w2Fh8Y3LCqMZLD34jkaonGoVr8naz/8R
	 8odk1aZvEVWkWOdMsKSj8HQE6EsO+iC9Ocw4h2DuiQSpU596U9wAJIeK3SBQTqGHY0
	 A+oQ2LOV+CRewhiM6DXQOxpws8ac4znk5faLJAy/WTGvC5Vt8tsBVYpPleIlf2aB4w
	 TQBLEVQr5O48u1+B+12LUe1qWExBY45ujKtKsPWIkYCDOTX5NeWCg2AXZ4LC6JUNhR
	 1sn5tUPOClaeL94RZuGO9B31uOuAAtYbhXFvQtvfAGjoF/4U+INVCRYLR+hi8fdAer
	 Tth7J2zspZEFQ==
Date: Fri, 3 Jul 2026 10:49:09 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Brian King <brking@linux.vnet.ibm.com>
Cc: Hannes Reinecke <hare@suse.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Brian King <brking@us.ibm.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org, wenxiong@linux.ibm.com
Subject: Re: [PATCH 3/4] scsi: ipr: use kmalloc() to allocate IPR dump buffer
 memory
Message-ID: <akdpddKBt7gV6po5@kernel.org>
References: <20260630-b4-scsi-v1-0-494fb37ebe7b@kernel.org>
 <20260630-b4-scsi-v1-3-494fb37ebe7b@kernel.org>
 <7c8f0e70-f49c-4614-af95-002fb2be11ba@suse.com>
 <akTjQVQQNdeO9M28@kernel.org>
 <d92f22b9-9a4d-42f2-ba67-0371f85fedd3@linux.vnet.ibm.com>
 <akYLdBME5kgyi8Rw@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akYLdBME5kgyi8Rw@kernel.org>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 98fbt1u863bwyuicgwhg1br1hcej4se1
X-Rspamd-Queue-Id: E2AD9140006
X-HE-Tag: 1783064957-344403
X-HE-Meta: U2FsdGVkX19IXQ9fwbiS8Q5TUSaCwPsHGpQd5FZvYzPM7d4/NUDvvNDX969a574sssgO+FXSYmiD35CMXx4XMtHOEottzU1aWVZp9jgHKT5tQZMmGfdkuM4Rys+kUmGHbJbhzgSukb+Uw+5A2G/6QVdK5q4S2SnRifBGwQS6FsIz3tG4DsUzCCT534dFpZFnPvB0hzPLZDVNKCeFHHYxRqOFrelZAbb4lTrNcnH75VfDs+0lYoUCmm1VuxlPje5DCsgOZaQ25tn65A5nhG95qutSEdxa/VQck7xAtdC15hPHjUB9clm4clZ8hd4u9Hhy0/ykgFogS6syPsu0lZZ+fASABIu4zWAHRxvRLuIOWypprKl3hXpEHbRsanBH6m/f1+qEjHV9bUrJMITBUbEUQ4iU21ZpYCP6d1WSnmWqAHoZCWTDPLbOYynQ57sy1uY7/9Guh0l0g4lW1aQv1qVrb+X1np7yKry3cx6JNzG7WBv17WTvnsUO6eoki7Jmel7a/o6JVkpXdRqorxwWFn/4nbXJ7g4KsROwZps0p5ZH0Y9re86+3wEijUZ00ANdbjropR+bjwY3SeuiaXEyUaKGphWHJnoaEGTEEke8Qprv5T9LqUuCz5Pgd5O257FMZdGm3f+8ZG6VOpxtzziOAhD9UiGE89+0iK06WPOTpLkhfvzifF0BiE8joKMQ0uTbQCwccj5PFZrgZC45G8vXM77e+KGsdB/4B6eGSrhcNC6PqXt0ijfhv74lGIbC+M8uNZKPzgnMJ938H+EppJ4gETrSoM6lynqigUudy+kxHDM8R6lN79DP0HDQ+K2lZrOEJSP1sFEs1FiLkokU+sGORYA7YMusrghK9ereVhirQkNLIchXqkJ/wDdEuoSNF3rQtxozapElKOduWRYqBi3fzYzj8uj5c0NyTbSEi/g44zbjVmJpU2NlHrGrHionaIAi4FNcEoExjRi4UpqTSYzVlES
 UHRGBrbt
 tjJwf2k/68fLtgWHZc0z69NmTRaIujvbvttPKNJqdVoKu8GAtxxHVDfRudC5s4/paylxYYTug3UvvYhFWs8eITpGmcnZYIXjUvoPImXVdaeqa23LyLBxruFOoP+pKMVAXe37VDKz29ue37bJ5IPqNYGahQ198dHNV5AinDsq06pY9CWOeoEnuJOm1DVKsUoKBBlnJkaexyYU1u8HhP6/NjQg0B8EavVyBXmy2XuR5b+HBxpe6q7MbW3jIdav5JeSQUHB3X75FDlNb2aI8wBXy9N7CMJq7LZ9VK1aHzNenNzAAqyQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 02, 2026 at 09:55:56AM +0300, Mike Rapoport wrote:
> On Wed, Jul 01, 2026 at 04:03:48PM -0500, Brian King wrote:
> > On 7/1/26 4:52 AM, Mike Rapoport wrote:
> > > On Wed, Jul 01, 2026 at 09:03:06AM +0200, Hannes Reinecke wrote:
> > >> On 6/30/26 12:54 PM, Mike Rapoport (Microsoft) wrote:
> > >>> IPR dump machinery allocates memory to save adapter's crash dump using
> > >>> __get_free_page().
> > >>>
> > >>> This memory can be allocated with kmalloc() as there's nothing special
> > >>> about it to go directly to the page allocator.
> > >>>
> > >>> kmalloc() provides a better API that does not require ugly casts and
> > >>> kfree() does not need to know the size of the freed object.
> > >>>
> > >>> Replace use of __get_free_page() with kmalloc().
> > >>>
> > >>> Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> > >>> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > >>> ---
> > >>>   drivers/scsi/ipr.c | 4 ++--
> > >>>   1 file changed, 2 insertions(+), 2 deletions(-)
> > >>>
> > >>> diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
> > >>> index d207e5e81afe..5a212bfdeec2 100644
> > >>> --- a/drivers/scsi/ipr.c
> > >>> +++ b/drivers/scsi/ipr.c
> > >>> @@ -2893,7 +2893,7 @@ static int ipr_sdt_copy(struct ipr_ioa_cfg *ioa_cfg,
> > >>>   	       (ioa_dump->hdr.len + bytes_copied) < max_dump_size) {
> > >>>   		if (ioa_dump->page_offset >= PAGE_SIZE ||
> > >>>   		    ioa_dump->page_offset == 0) {
> > >>> -			page = (__be32 *)__get_free_page(GFP_ATOMIC);
> > >>> +			page = kmalloc(PAGE_SIZE, GFP_ATOMIC);
> > >>>   			if (!page) {
> > >>>   				ipr_trace;
> > >>> @@ -3226,7 +3226,7 @@ static void ipr_release_dump(struct kref *kref)
> > >>>   	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
> > >>>   	for (i = 0; i < dump->ioa_dump.next_page_index; i++)
> > >>> -		free_page((unsigned long) dump->ioa_dump.ioa_data[i]);
> > >>> +		kfree(dump->ioa_dump.ioa_data[i]);
> > >>>   	vfree(dump->ioa_dump.ioa_data);
> > >>>   	kfree(dump);
> > >>>
> > >>
> > >> I _think_ we can replace this with kvmalloc, and allocate the entire
> > >> dump buffer in one go. Once switched to kmalloc() it's kinda pointless
> > >> to allocate separate page-sized buffers here.
> > > 
> > > kmalloc() performance is on par with __get_free_page(), but kvmalloc()
> > > would be slower if it falls back to vmalloc(). 
> > > 
> > > I'm not familiar with the driver to say if this could be an issue here.
> > 
> > This code only runs when the adapter has hit a fatal error, so should be
> > extremely rare. The memory is getting allocated while the storage adapter
> > is in a failed state, so anything running on the system at the time could
> > be stalled until recovery is completed. This memory is allocated and should
> > be freed soon after the adapter recovers. In order for this code to
> > run, the iprdump daemon must be running, which will then read out the dump
> > after the adapter is recovered, and write it to disk, after which time, the
> > ipr driver will free the kernel memory.
> 
> Thanks for the explanation!
> 
> So the allocation is not on the hot path and it seems to me that
> performance differences between kmalloc() and slower vmalloc() won't move a
> needle relatively to the entire dump procedure.

I looked more closely at the code. Currently the dump continues as long as
it can allocate memory and even if memory for the entire buffer is not
available there still will be some data in the dump.

With a single allocation that may be as large as 80M
(IPR_FMT3_MAX_IOA_DUMP_SIZE), an allocation failure would mean no data
would be dumped at all.

I think the current model is better than using a single kvmalloc()
allocation for the entire buffer.

I'm going to send v2 that keeps kmalloc() and only changes GFP_ATOMIC to
GFP_NOIO if there are no objections.

-- 
Sincerely yours,
Mike.

