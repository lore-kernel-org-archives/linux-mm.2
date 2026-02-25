Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B91D6FCEE8A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 11:35:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CBDC6B00AE; Wed, 25 Feb 2026 06:35:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 076626B00B1; Wed, 25 Feb 2026 06:35:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E90996B00B2; Wed, 25 Feb 2026 06:35:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D21466B00AE
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 06:35:43 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 74CA01604B7
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:35:43 +0000 (UTC)
X-FDA: 84482774166.26.23264BB
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1090140006
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:35:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="d/1MOW6y";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=x9VqnedY;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="d/1MOW6y";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=x9VqnedY;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf11.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tzimmermann@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772019341; a=rsa-sha256;
	cv=none;
	b=QQ5mXSAbZJ0Kv97Oofovhbo5J6lsbKAWDDA4MEkJmMEjbHdgN//7rftINaFgATC16TM0OY
	OTH2WMSvecDQWa/KS1q+U5O0nKmA58vr4f8kr7xwFBAwk3dxpUrymn4C6WNUd9ZvZw6Ye8
	SCAWHJS4RxUTadq/MZBQbuLgDhPWx+w=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="d/1MOW6y";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=x9VqnedY;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="d/1MOW6y";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=x9VqnedY;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf11.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tzimmermann@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772019341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1aY6r9vtQDBmuQFoWtVNnGY9iK116zu55UD0rtR50Nw=;
	b=hsdz/M3Qdu5MB5HvWBjPX0VjgJOOpGcPnmUu9RiyAxkBuzTThkhcEltGZos0hzcYG7hP3G
	cvylAGF6rY8kBkHwnMy0jz23JB5OD/F2NMgbkfkrLDCxP/SSIkBtGy2+Jh24fOkl94e9/m
	Xl69WMZEFy1D4Av59iEAzgL07iULvyg=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 84F1E3FFD0;
	Wed, 25 Feb 2026 11:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772019339; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1aY6r9vtQDBmuQFoWtVNnGY9iK116zu55UD0rtR50Nw=;
	b=d/1MOW6yh3ZsLj3Oidq7wfi/4LOCYn2mf7Ta7kh8TZHUaFp9tJRHwFbFlUeFHWhi7+Zvj3
	SOgqRvPBcpF102VvAgEg9SA4yV/IFOvXLyqwAlMtwaLmvcGzDFYSPNS9cGGLJQLhklej9g
	3dRb+n+jWweAgLGHQrk72n8deI1UIPE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772019339;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1aY6r9vtQDBmuQFoWtVNnGY9iK116zu55UD0rtR50Nw=;
	b=x9VqnedY7jUIO1liaWISDZKZyASKqWAgL+6ZagDMedOH6kCiWAK3EwHeopHPORkDV/WQGo
	hsA4yedE2XAnILCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772019339; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1aY6r9vtQDBmuQFoWtVNnGY9iK116zu55UD0rtR50Nw=;
	b=d/1MOW6yh3ZsLj3Oidq7wfi/4LOCYn2mf7Ta7kh8TZHUaFp9tJRHwFbFlUeFHWhi7+Zvj3
	SOgqRvPBcpF102VvAgEg9SA4yV/IFOvXLyqwAlMtwaLmvcGzDFYSPNS9cGGLJQLhklej9g
	3dRb+n+jWweAgLGHQrk72n8deI1UIPE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772019339;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1aY6r9vtQDBmuQFoWtVNnGY9iK116zu55UD0rtR50Nw=;
	b=x9VqnedY7jUIO1liaWISDZKZyASKqWAgL+6ZagDMedOH6kCiWAK3EwHeopHPORkDV/WQGo
	hsA4yedE2XAnILCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 301113EA65;
	Wed, 25 Feb 2026 11:35:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TmNoCovenmlwIAAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Wed, 25 Feb 2026 11:35:39 +0000
Message-ID: <788bd9a6-003a-4761-ab4c-1bc0cb716d9c@suse.de>
Date: Wed, 25 Feb 2026 12:35:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/6] drm/gem-shmem: Track folio accessed/dirty status
 in mmap
To: Boris Brezillon <boris.brezillon@collabora.com>
Cc: loic.molinari@collabora.com, willy@infradead.org, frank.binns@imgtec.com,
 matt.coster@imgtec.com, maarten.lankhorst@linux.intel.com,
 mripard@kernel.org, airlied@gmail.com, simona@ffwll.ch,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org
References: <20260209133241.238813-1-tzimmermann@suse.de>
 <20260209133241.238813-6-tzimmermann@suse.de>
 <20260209152340.16f9b30a@fedora>
 <0d00a0f6-d0e4-41db-b48b-77157cd2e968@suse.de>
 <20260209160109.79a020ae@fedora>
Content-Language: en-US
From: Thomas Zimmermann <tzimmermann@suse.de>
Autocrypt: addr=tzimmermann@suse.de; keydata=
 xsBNBFs50uABCADEHPidWt974CaxBVbrIBwqcq/WURinJ3+2WlIrKWspiP83vfZKaXhFYsdg
 XH47fDVbPPj+d6tQrw5lPQCyqjwrCPYnq3WlIBnGPJ4/jreTL6V+qfKRDlGLWFjZcsrPJGE0
 BeB5BbqP5erN1qylK9i3gPoQjXGhpBpQYwRrEyQyjuvk+Ev0K1Jc5tVDeJAuau3TGNgah4Yc
 hdHm3bkPjz9EErV85RwvImQ1dptvx6s7xzwXTgGAsaYZsL8WCwDaTuqFa1d1jjlaxg6+tZsB
 9GluwvIhSezPgnEmimZDkGnZRRSFiGP8yjqTjjWuf0bSj5rUnTGiyLyRZRNGcXmu6hjlABEB
 AAHNJ1Rob21hcyBaaW1tZXJtYW5uIDx0emltbWVybWFubkBzdXNlLmRlPsLAjgQTAQgAOAIb
 AwULCQgHAgYVCgkICwIEFgIDAQIeAQIXgBYhBHIX+6yM6c9jRKFo5WgNwR1TC3ojBQJftODH
 AAoJEGgNwR1TC3ojx1wH/0hKGWugiqDgLNXLRD/4TfHBEKmxIrmfu9Z5t7vwUKfwhFL6hqvo
 lXPJJKQpQ2z8+X2vZm/slsLn7J1yjrOsoJhKABDi+3QWWSGkaGwRJAdPVVyJMfJRNNNIKwVb
 U6B1BkX2XDKDGffF4TxlOpSQzdtNI/9gleOoUA8+jy8knnDYzjBNOZqLG2FuTdicBXblz0Mf
 vg41gd9kCwYXDnD91rJU8tzylXv03E75NCaTxTM+FBXPmsAVYQ4GYhhgFt8S2UWMoaaABLDe
 7l5FdnLdDEcbmd8uLU2CaG4W2cLrUaI4jz2XbkcPQkqTQ3EB67hYkjiEE6Zy3ggOitiQGcqp
 j//OwE0EWznS4AEIAMYmP4M/V+T5RY5at/g7rUdNsLhWv1APYrh9RQefODYHrNRHUE9eosYb
 T6XMryR9hT8XlGOYRwKWwiQBoWSDiTMo/Xi29jUnn4BXfI2px2DTXwc22LKtLAgTRjP+qbU6
 3Y0xnQN29UGDbYgyyK51DW3H0If2a3JNsheAAK+Xc9baj0LGIc8T9uiEWHBnCH+RdhgATnWW
 GKdDegUR5BkDfDg5O/FISymJBHx2Dyoklv5g4BzkgqTqwmaYzsl8UxZKvbaxq0zbehDda8lv
 hFXodNFMAgTLJlLuDYOGLK2AwbrS3Sp0AEbkpdJBb44qVlGm5bApZouHeJ/+n+7r12+lqdsA
 EQEAAcLAdgQYAQgAIAIbDBYhBHIX+6yM6c9jRKFo5WgNwR1TC3ojBQJftOH6AAoJEGgNwR1T
 C3ojVSkIALpAPkIJPQoURPb1VWjh34l0HlglmYHvZszJWTXYwavHR8+k6Baa6H7ufXNQtThR
 yIxJrQLW6rV5lm7TjhffEhxVCn37+cg0zZ3j7zIsSS0rx/aMwi6VhFJA5hfn3T0TtrijKP4A
 SAQO9xD1Zk9/61JWk8OysuIh7MXkl0fxbRKWE93XeQBhIJHQfnc+YBLprdnxR446Sh8Wn/2D
 Ya8cavuWf2zrB6cZurs048xe0UbSW5AOSo4V9M0jzYI4nZqTmPxYyXbm30Kvmz0rYVRaitYJ
 4kyYYMhuULvrJDMjZRvaNe52tkKAvMevcGdt38H4KSVXAylqyQOW5zvPc4/sq9c=
In-Reply-To: <20260209160109.79a020ae@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1090140006
X-Stat-Signature: eamcjqfd7x1tnephhwc8u6z63z1coths
X-HE-Tag: 1772019340-206709
X-HE-Meta: U2FsdGVkX19WKcfJC956cRuEdnOCo2Y5bmPyO1ht/c8Ovt6AwrDQ7XXieGWCEI3+PxOxbAZjUEvRc8tARnBm3lbseJLXVLDmiV3TfxKeAkuBDRspFoEdpeH0KQ8vCBe1re6yu3BsDQ2t1AZqpl3BH5g2CGtUZ4gwsYGITPqp9bvWPUwYx415Lq5W87p92XWdcxe2MssBb7hT4HS5PCp6wxwivkbs872UlX55PkZ8vNCjMNKGME+JQKVPmZQVcJ8CdKk+kzztdpS4QYvV90LAfL3Z+ONW8QOusaQZYvNIGA4D9+7nfjq3Xp9BhK4sNNLFMpktBwyOgmIEO9G0XDcfSnq95bRqoDNT4OSrIeOUbGVTeL7p2pmj7a37IZgQr3qJ2IFq5SLjhA/V76bLOlCItpHyDy/f3P5mZWYiZyxLmb18xT9CZ/6pz2g/jRI/5MBad6qizSOxKhq9qUUafdAxxZw3gwEv35u4XtuSBYtRRvtep8yAX8KucO4JEyeOmjY8grb/gKYc0v8RyAcFD6V5qYzhZWwv07YYsEdY2dwBynUOBJ2/oYcc0GFkGawAMGfZmt446q/ixBIOL6Mjq67PCB0/U4aPvdZyH4w8pzgGis3eFxYcRraECVmG+RUX3HicKwO+BnrBICkCo6fanP3YmOcadCKXXUIY/lK3bReFJ0InvfcKoQvIp24paIBC+JM80pIOXpMG1Iv843xG6Lc6zNw2jg7/lKTQQS8smSS9z+RF7Y6KWj9BNOnuhFxHOW04VxhC2JpBvcOWCPbXC11ORb0rZvzAH5cogy9WGjnQpurxBetei5O0WiuwdaqKzg+Z72MmGtL1vG9ha/csdPhNKDZetxfnTPxQcpNk3CoG1goc0lyjqkewhwdtXO0i9tttDQ2Ihzjg/8BlPn6QEEYDqV7yX/e5gWiiTLuIdTHQau63XrGTLwxeb4J16idDdgvUcGiNSkwpqNTMqYYoV57
 0CsYBn0i
 jFHxxffDbO35VYx5my18Ql6bK3MwOzCquLgXkqgvFJc1EkGXWsxNC7xuuuw2dx5wNxSG51gfJBBSRtae3i1Wbkk8EFPH3pi24UWbECI0Chbo+LPxPxsBPWny2ctGi7zOvgAsgcPi3/rTRs0FOby4xZRq1pi+GxTpY0oXw6Qhq8Nvwdq83pYx3C6WSkB2O5Y59251OZqAYAxMtJXGD4A+xS4YhkgEWKbPw4SA+P7lLvBLqQv2XCj+TdiyDYFxWVyOujEvVx8jEF/x28DaguKRTa8IKg6G7GjGFLt0/b4yzL1aKcBCnkWjF4QsxwzwlRXUzJXx4EeSs0esCDcuGoogv54xUMDUHbmTN7N7RnvvLDwPswB+5lspQQARi7HOK/rbY4XApuGDa99wCDPwNoq/qe7h74Mh0L1rMEi6RT75F3rjUZryM6AeViTfhybVOoP5FfM18NbugT/guXjw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi

Am 09.02.26 um 16:01 schrieb Boris Brezillon:
> On Mon, 9 Feb 2026 15:46:21 +0100
> Thomas Zimmermann <tzimmermann@suse.de> wrote:
>
>> Hi Boris,
>>
>> thanks for reviewing the series.
>>
>> Am 09.02.26 um 15:23 schrieb Boris Brezillon:
>>> On Mon,  9 Feb 2026 14:27:14 +0100
>>> Thomas Zimmermann <tzimmermann@suse.de> wrote:
>>>   
>>>> Invoke folio_mark_accessed() in mmap page faults to add the folio to
>>>> the memory manager's LRU list. Userspace invokes mmap to get the memory
>>>> for software rendering. Compositors do the same when creating the final
>>>> on-screen image, so keeping the pages in LRU makes sense. Avoids paging
>>>> out graphics buffers when under memory pressure.
>>>>
>>>> In pfn_mkwrite, further invoke the folio_mark_dirty() to add the folio
>>>> for writeback should the underlying file be paged out from system memory.
>>>> This rarely happens in practice, yet it would corrupt the buffer content.
>>>>
>>>> This has little effect on a system's hardware-accelerated rendering, which
>>>> only mmaps for an initial setup of textures, meshes, shaders, etc.
>>>>
>>>> v3:
>>>> - rewrite for VM_PFNMAP
>>>> v2:
>>>> - adapt to changes in drm_gem_shmem_try_mmap_pmd()
>>>>
>>>> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
>>>> Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
>>>> ---
>>>>    drivers/gpu/drm/drm_gem_shmem_helper.c | 20 ++++++++++++++++++++
>>>>    1 file changed, 20 insertions(+)
>>>>
>>>> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
>>>> index c3a054899ba3..0c86ad40a049 100644
>>>> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
>>>> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
>>>> @@ -598,6 +598,9 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
>>>>    	if (ret != VM_FAULT_NOPAGE)
>>>>    		ret = vmf_insert_pfn(vma, vmf->address, pfn);
>>>>    
>>>> +	if (likely(!(ret & VM_FAULT_ERROR)))
>>> Can't we just go
>>>
>>> 	if (ret == VM_FAULT_NOPAGE)
>>>
>>> here?
>> After reviewing the code in vmf_insert_pfn, I think so. All we'll see is
>> _OOM and _SIGBUS; or _NOPAGE on success.  I'll change it then.
>>
>>
>>>   
>>>> +		folio_mark_accessed(folio);
>>>> +
>>>>    out:
>>>>    	dma_resv_unlock(obj->resv);
>>>>    
>>>> @@ -638,10 +641,27 @@ static void drm_gem_shmem_vm_close(struct vm_area_struct *vma)
>>>>    	drm_gem_vm_close(vma);
>>>>    }
>>>>    
>>>> +static vm_fault_t drm_gem_shmem_pfn_mkwrite(struct vm_fault *vmf)
>>>> +{
>>>> +	struct vm_area_struct *vma = vmf->vma;
>>>> +	struct drm_gem_object *obj = vma->vm_private_data;
>>>> +	struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
>>>> +	pgoff_t page_offset = vmf->pgoff - vma->vm_pgoff; /* page offset within VMA */
>>>> +	struct page *page = shmem->pages[page_offset];
>>> Should we have a
>>>
>>> 	if (WARN_ON(!shmem->pages ||
>>> 		    page_offset <= (obj->size >> PAGE_SHIFT)))
>>> 		return VM_FAULT_SIGBUS;
>>>
>>>
>>> ?
>> I left it out because it doesn't seem necessary.  In the fault handler
>> in drm_gem_shmem_fault(), I can see that we could get an OOB access. But
>> we only call pfn_mkwrite() after going through _fault() first. I don't
>> see a way of getting here unless we've already tested for the page in
>> _fault().
> I agree it's not supposed to happen, but isn't it what WARN_ON()s are
> for (catching unexpected situations)?

OK, with Frank's ack on the imagination changes in, I'll send out an 
update with additional warning.

Best regards
Thomas


-- 
--
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Frankenstr. 146, 90461 Nürnberg, Germany, www.suse.com
GF: Jochen Jaser, Andrew McDonald, Werner Knoblich, (HRB 36809, AG Nürnberg)



