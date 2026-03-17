Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 723D1FD877F
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 14:45:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B94AB6B0096; Tue, 17 Mar 2026 10:45:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B45426B0098; Tue, 17 Mar 2026 10:45:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5AAF6B009B; Tue, 17 Mar 2026 10:45:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 95EB36B0096
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 10:45:53 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 29B99140167
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:45:53 +0000 (UTC)
X-FDA: 84555829386.07.6B637D2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8A03A180017
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:45:51 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rYAOlfU1;
	spf=pass (imf06.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773758751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6+DjvRt5Plf4cbtyVJdQoNIMI9qxeEUQHVaHtnOgyUY=;
	b=aITMHUhbUAVlhSLom0BeAb0oU0kmlXS4csUQRZdL1NkEfn02tCPnjdYZ8i8Od5ONEAxHxr
	s0zvOeVGeODMg0ajj7hcgFSQQkvSDEcvrRqW+raVL7Vw2FZdyL9e7JFhMnYfDjj3fonsfI
	D1o297uGPDkeQsuAd8QYifIwZvERVWE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773758751; a=rsa-sha256;
	cv=none;
	b=tkfIlE5dRhA53uzJoehqqgHoQDY9i9n9AvR6led1FpziFaNBUCMZnL7xG5H4SDSCRw1occ
	rKXS6/ItdkvuEMG15fcrdA4La6IMOd7gQecvjDD5OZZDpdIb3JCNR7cGo+c+dL+942qSkc
	aRqcEFNMWfpcbH8fwD9pZCNNvQT+H3w=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rYAOlfU1;
	spf=pass (imf06.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E269360008;
	Tue, 17 Mar 2026 14:45:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F0CEC4CEF7;
	Tue, 17 Mar 2026 14:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773758750;
	bh=vWWXSXsJOObdgoBPa0ZCzYH49f6ax9/VVCivy/CV+jQ=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To:From;
	b=rYAOlfU1LhAd33yPEOu0WvE7C2l35cFvPVoYDzFyFoaaxRtVtZOoT1IFgxIQuXo1Y
	 3hha8ywax6Q0nTV3aqfco4vLdEh6KFpEWP38aJmMY6FeeAVEcV36s/o5CrpW9EYgK2
	 FP8teTaUv3yhkB0T0IZ/4uSAoBBk7QDUhoSK0l573zFH1SJYfL5mh9nqT5Z7MeqZSV
	 hVfvZjsxmBzPHCj6/0EO2CKlAxGIb7JcCToDeK/GNlRhQGksUEZJBGI5IY330BSbTc
	 ahedwupp5RwGF6SOZIeJaxd9MM832F7ip2hAeygK2S4Jq3qko+vfxmV4Te9VHZu50T
	 gPorz5mqji+7Q==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 17 Mar 2026 15:45:48 +0100
Message-Id: <DH54ZZSBOJ0D.2PR3WTIRSH2OW@kernel.org>
Subject: Re: [PATCH v5 2/3] mm/vmalloc: free unused pages on vrealloc()
 shrink
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Uladzislau Rezki"
 <urezki@gmail.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
To: "Shivam Kalra" <shivamkalra98@zohomail.in>, "Alice Ryhl"
 <aliceryhl@google.com>
From: "Danilo Krummrich" <dakr@kernel.org>
References: <20260317-vmalloc-shrink-v5-0-bbfbf54c5265@zohomail.in>
 <20260317-vmalloc-shrink-v5-2-bbfbf54c5265@zohomail.in>
 <ablnha2sgGUMO96d@google.com>
In-Reply-To: <ablnha2sgGUMO96d@google.com>
X-Rspam-User: 
X-Stat-Signature: jw3ukr4rsqpdbn815c7ai7inwspyshoh
X-Rspamd-Queue-Id: 8A03A180017
X-Rspamd-Server: rspam03
X-HE-Tag: 1773758751-187541
X-HE-Meta: U2FsdGVkX18Z0I05XXtkX7DpWT2kT5uMHkr/YeDiER9vlQY9DXQc/KPkprvNbOqtpnZhGiRIHRlAuijBIswfRfNvm3rXL+kI2ON3pvERQE3Twa7b6V4EKCNBkE6JgLDiPRI/b6M22I2KmSZBnprVaZU9ViwCj0fw9L0HdWit30qIUXXSXu+HQjSJOlai/ph7nxv3MgSWQq8A8Nhww7ZiagtoHOnXVTU4PFs5KudG4bsJ7k3BaiUkzPRmzgzZacq/7aSSlznkCn5Mwp1Q4CmYrejsyuNXcc8RQhfwBOSMhsIv2bFqaUH0UnBBQcIkSTaOHpdTpVfvdcmG6ITYu1LzOPnKFTGCMX7sRJRZxIxELZExjnuRtVcdAYvfdwvu75EuHfSa8A0qg79SdNdYVWO4x4RXB9yda5MX8oBo/8+NoxJ4lzVuacgEHk0mqLB0BMzlMJEwQbAeXTfTZ+NADY4Lr5D2zVUdZRGl+E/oREe8Cr6/fCS/3rLYJZWcMTDUtpXx4UA/44PcRAWKRgYRo8KeSS7CBCdQgXXMl11dqIOZju0nLC75OHHjQUJn5ky+ZJeZiKyahWoL1/hLlPOyd6HyN9JWCYkF4ngw0xpByPlhtGKdZvbFod0Jetgl0eZpV+prDXVMdJ5hN/v9s3hRMHcmuKxBOSqgDtZfXDHwTYGKmg8FufjeqxVBcRCefrWQ/h0o3651yn0fCKLnly2d7Zf0dT/hjhA0PRbYs0bZWEK3qU2dkCvBQ91rc2KxRgeSi7IzYvmWv3MTneiCAYe5hT/jjhIdWOB9x0psjZ/HAROP0JlfjR2qdNLyt0TNKRgVK8p8B6IeDO/DPCGXnt/6uKog0QryNav1rjn4Ba6E70pFcpTXDJw3eP9pVg6QCI1xUmE6/vgbYa+nwkMbHvBLep6bxaZpYqkDEUjJAKdJqk8hYgfTgjPgyLaS7TkL6O/F8jGgx9Nv3noZQghkX3Q5S66
 tzqYErQ9
 OTlaQDrr5s/A5ZkQ+X8ijn/3ZbZO+BctKwkPxTzb8ATHexHZOsQcq8f1F1jbJsvbg23ffCnNAbUaf+aDG0OBD+CTKsOXjCAAZS76pc1FTaTLOM7TsXyxoFGPiDBsS3+nehDPHG9wMFpG8SA++FBOfVFynQXnhBoKFo2YqzJAvwpAHeuBJp0msOjVfzXMXzyXspfBbOpCn+DPECGP9VdkRJezD51af99U/Ai1qEbKgINll2mM+CEvg28j7jB3AIjjIMbRFdNX2ddY2xlXtUlnzUyI7If0mA9JSmk2b1L8ccHkCKYE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Mar 17, 2026 at 3:39 PM CET, Alice Ryhl wrote:
> On Tue, Mar 17, 2026 at 01:47:34PM +0530, Shivam Kalra wrote:
>> When vrealloc() shrinks an allocation and the new size crosses a page
>> boundary, unmap and free the tail pages that are no longer needed. This
>> reclaims physical memory that was previously wasted for the lifetime
>> of the allocation.
>>=20
>> The heuristic is simple: always free when at least one full page becomes
>> unused. Huge page allocations (page_order > 0) are skipped, as partial
>> freeing would require splitting. Allocations with VM_FLUSH_RESET_PERMS
>> are also skipped, as their direct-map permissions must be reset before
>> pages are returned to the page allocator, which is handled by
>> vm_reset_perms() during vfree().
>>=20
>> The virtual address reservation (vm->size / vmap_area) is intentionally
>> kept unchanged, preserving the address for potential future grow-in-plac=
e
>> support.
>>=20
>> Fix the grow-in-place check to compare against vm->nr_pages rather than
>> get_vm_area_size(), since the latter reflects the virtual reservation
>> which does not shrink. Without this fix, a grow after shrink would
>> access freed pages.
>>=20
>> Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>

Feel free to add

Suggested-by: Danilo Krummrich <dakr@kernel.org>

>> ---
>>  mm/vmalloc.c | 20 +++++++++++++++-----
>>  1 file changed, 15 insertions(+), 5 deletions(-)
>>=20
>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>> index b29bf58c0e3f..f3820c6712c1 100644
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -4345,14 +4345,24 @@ void *vrealloc_node_align_noprof(const void *p, =
size_t size, unsigned long align
>>  			goto need_realloc;
>>  	}
>> =20
>> -	/*
>> -	 * TODO: Shrink the vm_area, i.e. unmap and free unused pages. What
>> -	 * would be a good heuristic for when to shrink the vm_area?
>> -	 */
>>  	if (size <=3D old_size) {
>> +		unsigned int new_nr_pages =3D PAGE_ALIGN(size) >> PAGE_SHIFT;
>> +
>>  		/* Zero out "freed" memory, potentially for future realloc. */
>>  		if (want_init_on_free() || want_init_on_alloc(flags))
>>  			memset((void *)p + size, 0, old_size - size);
>> +
>> +		/* Free tail pages when shrink crosses a page boundary. */
>> +		if (new_nr_pages < vm->nr_pages && !vm_area_page_order(vm) &&
>> +		    !(vm->flags & VM_FLUSH_RESET_PERMS)) {
>> +			unsigned long addr =3D (unsigned long)p;
>> +
>> +			vunmap_range(addr + (new_nr_pages << PAGE_SHIFT),
>> +				     addr + (vm->nr_pages << PAGE_SHIFT));
>> +
>> +			vm_area_free_pages(vm, new_nr_pages, vm->nr_pages);
>> +			vm->nr_pages =3D new_nr_pages;
>> +		}
>>  		vm->requested_size =3D size;
>>  		kasan_vrealloc(p, old_size, size);
>>  		return (void *)p;
>> @@ -4361,7 +4371,7 @@ void *vrealloc_node_align_noprof(const void *p, si=
ze_t size, unsigned long align
>>  	/*
>>  	 * We already have the bytes available in the allocation; use them.
>>  	 */
>> -	if (size <=3D alloced_size) {
>> +	if (size <=3D (size_t)vm->nr_pages << PAGE_SHIFT) {
>>  		/*
>>  		 * No need to zero memory here, as unused memory will have
>>  		 * already been zeroed at initial allocation time or during
>
> Hmm. So what happened here is that it has previously always been the
> case that get_vm_area_size(area) =3D=3D vm->nr_pages << PAGE_SHIFT, so th=
ese
> constants were interchangable. But now that is no longer the case.
>
> For example, 'remap_vmalloc_range_partial' compares the vm area size
> with the range being mapped, and then proceeds to look up the pages and
> map them. But now those pages may be missing.
>
> I can't really tell if there are other places in this file that need to
> be updated too.

This may well be possible. I remember that when I added vrealloc() and look=
ed
into growing and shrinking, I concluded that it might need a bit of rework =
in
terms of tracking the sizes of the different layers. Unfortunately, I don't
remember the details anymore, but I'm quite sure there were some subtleties
along the lines of what Alice points out, so I recommend to double check.

