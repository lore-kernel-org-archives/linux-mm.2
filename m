Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B00BED2F03E
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 14:53:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A7CF6B0088; Tue, 27 Jan 2026 09:53:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 156146B0098; Tue, 27 Jan 2026 09:53:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 023D76B0099; Tue, 27 Jan 2026 09:53:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E36496B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 09:53:45 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A032FC09E7
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 14:53:45 +0000 (UTC)
X-FDA: 84378038010.05.244E7F7
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id 518B61C0007
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 14:53:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=SEekw7BU;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zmp1gJ0b;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=SEekw7BU;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zmp1gJ0b;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf21.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=tzimmermann@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769525623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IRIApCgKGYxC2DppFnFx5NvIXuyDk1qFzdf/rcXhHGE=;
	b=PiiE/mt0KwsFq3Nf08H5Vo8/4K9AQhSQldyD0fcaRjnlwsIZX1AoRJx0Ajrrp5WoXECIu1
	kO8lZ8y0OOo3Lxef+Ke5dVTLVVG1qJn/I+mG0JBr/2RYSFzXzqhW+ArJRwujsiceVXCKpI
	7YcX7kTdm/HwcKA+zKdPrrBfvoypZNM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769525623; a=rsa-sha256;
	cv=none;
	b=ouHut/Rfpebby0lEXvbqC8ngGRaJgAMFwenakFhozY6ZE+EttUy5C09yaPEKwO20ZAto70
	xxyWQHT5zHtvaIsHFpy4jjEr1htFUXD2V+7hdhiJyz8dTk2JhBkUa7s2oT+zFfumCUZ6mI
	OhPeJ1QAaWGjhJkLQmtXhG+sU+bMNio=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=SEekw7BU;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zmp1gJ0b;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=SEekw7BU;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zmp1gJ0b;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf21.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=tzimmermann@suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BC34A5BCC3;
	Tue, 27 Jan 2026 14:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1769525621; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=IRIApCgKGYxC2DppFnFx5NvIXuyDk1qFzdf/rcXhHGE=;
	b=SEekw7BUT+gh8ltKvxV08Rc67bXN/9nbrQaOHAVxCt5t+MOKNE3T/mq4ArGPCqRy7pniBW
	r85kFKf3wX3OrWCKD/u2Ot8MGFt7Fo2BUm/PqSbcHhpPgapXZCUc+qTm/4+6K3tkV4/O8Y
	SGwPH5adQK7l6jLCZzM3hP9GTw9Fkxc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1769525621;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=IRIApCgKGYxC2DppFnFx5NvIXuyDk1qFzdf/rcXhHGE=;
	b=zmp1gJ0bswcoRvW93hZJGL4sU15PL3jxp2NHycxHZwA+NLx6CpAqZcB1/CMnlf7OjpkWZQ
	yLxzcDc0wfU2QtBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1769525621; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=IRIApCgKGYxC2DppFnFx5NvIXuyDk1qFzdf/rcXhHGE=;
	b=SEekw7BUT+gh8ltKvxV08Rc67bXN/9nbrQaOHAVxCt5t+MOKNE3T/mq4ArGPCqRy7pniBW
	r85kFKf3wX3OrWCKD/u2Ot8MGFt7Fo2BUm/PqSbcHhpPgapXZCUc+qTm/4+6K3tkV4/O8Y
	SGwPH5adQK7l6jLCZzM3hP9GTw9Fkxc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1769525621;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=IRIApCgKGYxC2DppFnFx5NvIXuyDk1qFzdf/rcXhHGE=;
	b=zmp1gJ0bswcoRvW93hZJGL4sU15PL3jxp2NHycxHZwA+NLx6CpAqZcB1/CMnlf7OjpkWZQ
	yLxzcDc0wfU2QtBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 634473EA61;
	Tue, 27 Jan 2026 14:53:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8R3NFnXReGmgXAAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Tue, 27 Jan 2026 14:53:41 +0000
Message-ID: <2bcc0da5-e3b8-4980-8e26-d8215ae53120@suse.de>
Date: Tue, 27 Jan 2026 15:53:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] drm/gem-shmem: Map pages in mmap fault handler
To: Boris Brezillon <boris.brezillon@collabora.com>
Cc: loic.molinari@collabora.com, willy@infradead.org,
 maarten.lankhorst@linux.intel.com, mripard@kernel.org, airlied@gmail.com,
 simona@ffwll.ch, frank.binns@imgtec.com, matt.coster@imgtec.com,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org
References: <20260127132938.429288-1-tzimmermann@suse.de>
 <20260127132938.429288-2-tzimmermann@suse.de>
 <20260127154511.6e2b9008@fedora>
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
In-Reply-To: <20260127154511.6e2b9008@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 518B61C0007
X-Stat-Signature: jtnry775c3z38bwono6znp7dx6awu6kz
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769525623-540753
X-HE-Meta: U2FsdGVkX1+rlsgtl0dKj3G+IMsxMtoFIBfheYzA8TAfFfigyE2TYZdbnFB98hIN4UL+AbTbkiLVa5SARFP1ERKTGu/rvI7aUaKV3PO13f8TPX9D8A4cfAA6DPuhmxKAgo2MtnWZdhBxhRL2UumviVnNwoZAzMvGNTSCMrAd++8n36SRyOi34J7q4389P1llOM7xOyVFOuFf4X+hFptXzTbwJxN9LM79i4Swhy1tMRAK560EuJf97pp9S6bhgJMCGLqeY0qa0OnFFG2mbwoosOifgGsVl6wOkcg+4GWx4j8D77WwhOrlI5sSZinfSy+0VvuwoXhTFi7zBOlG1lL6zi+4whZFs4NHeGzYtVIEEgiyxHOcuJnEpyZAscMy+hfFZFw/98UAdXXxrX3Tfw2Cq0uBfivcynGkMckoVWYZAyXmwkH+Zthap2T+3NHN5dKZrSEhLcfHyfPjt/JWcLM6QWZklyvzzrSSC50sxFgt/Y1qmcokaRtkwpAzP4yaJwoS9xf3NYM6YWq5+5TccyoX7hZJaYBRmFsyfQxtOweqM1SxHzA2QsSeYr8vKWrEAYjaQqmW1EszM/4d/0qnkuaJ7KTQt4F+2N8N9OnJ9mDOJnjYkV4RIzmNuwlcm5IXKPMBZFiFxp8wABGQWdclr2hDLBmosjo+4LoVkh9xATTUWBurgi3wZA0Yt3gawX6pkGNbydXg9YYnmHNFqbY6UvlAIj51fD1iHcUDaYekOKEyk3mtfuxf9noGY5OzOFyO4M3UaqI3Wv7NsqEklcLIt8oAEUkTg8rqMYIqDF0lQVZsrWOXZ99whREhkVFqMkoWVrp1Bcj6a85ijkL7oTzx4zwNrwj82pyA+qPzZ3D/BhDMH8qXYet6br4NCjWnbg+ue1AS9EMagozZ7rFBXkpA1LCRe9smZx6i31256MOzhvE7zngF9gxjfS5DDnkT+VA2Jk2K/uvJFlE8Q5I5L2qA9fc
 ofZdWEbl
 SLL72loTkpv/JtsaoL+ZmYMvhhRp89sh7eVplyosR0txun2zxG9o1Zk7gcQ/vE6dXFAeobnm0VTKplgeiFPCs1H+8YGu4L5u3MktyyXRAN4f6J2SiMyDeZAn5pBjBJoKWHvw0ex4oQvC2KCZyl7VYlW+dYXxF8qm20l+YNCDFu1UMayusCKI8lFTSS3pgcwA+2YTLL4eCHAlxMR1H7pxQZ+O/5aJ9ECGw5kayNx0rH10oqeMCNqr8zP7iAkE1+75V7yWwDOrVwu8mTc/sSCpaT0csSF183XvQoRQIuG5D8tb/OPscu4QJo1aEz1lehL7LGbuELNt2cLKzKwc9WHzdKPkMSro/chaXwrmBlTgBBUfWb6TGDFRsXWRKw8iO1pxp/ju5pXpaRQmsNVU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

thanks for reviewing.

Am 27.01.26 um 15:45 schrieb Boris Brezillon:
> Hello Thomas,
>
> On Tue, 27 Jan 2026 14:16:36 +0100
> Thomas Zimmermann <tzimmermann@suse.de> wrote:
>
>> Gem-shmem operates on pages instead of I/O memory ranges, so use them
>> for mmap. This will allow for tracking page dirty/accessed flags. If
>> hugepage support is available, insert the page's folio if possible.
>> Otherwise fall back to mapping individual pages.
>>
>> As the PFN is no longer required for hugepage mappings, simplify the
>> related code and make it depend on CONFIG_TRANSPARENT_HUGEPAGE. Prepare
>> for tracking folio status.
>>
>> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
>> ---
>>   drivers/gpu/drm/drm_gem_shmem_helper.c | 58 ++++++++++++++++----------
>>   1 file changed, 35 insertions(+), 23 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
>> index 3871a6d92f77..b6ddabbfcc52 100644
>> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
>> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
>> @@ -553,17 +553,18 @@ EXPORT_SYMBOL_GPL(drm_gem_shmem_dumb_create);
>>   static bool drm_gem_shmem_try_map_pmd(struct vm_fault *vmf, unsigned long addr,
>>   				      struct page *page)
>>   {
>> -#ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
>> -	unsigned long pfn = page_to_pfn(page);
>> -	unsigned long paddr = pfn << PAGE_SHIFT;
>> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>> +	phys_addr_t paddr = page_to_phys(page);
>>   	bool aligned = (addr & ~PMD_MASK) == (paddr & ~PMD_MASK);
>>   
>> -	if (aligned &&
>> -	    pmd_none(*vmf->pmd) &&
>> -	    folio_test_pmd_mappable(page_folio(page))) {
>> -		pfn &= PMD_MASK >> PAGE_SHIFT;
>> -		if (vmf_insert_pfn_pmd(vmf, pfn, false) == VM_FAULT_NOPAGE)
>> -			return true;
>> +	if (aligned && pmd_none(*vmf->pmd)) {
>> +		struct folio *folio = page_folio(page);
>> +
>> +		if (folio_test_pmd_mappable(folio)) {
>> +			/* Read-only mapping; split upon write fault */
>> +			if (vmf_insert_folio_pmd(vmf, folio, false) == VM_FAULT_NOPAGE)
>> +				return true;
>> +		}
>>   	}
>>   #endif
>>   
>> @@ -576,13 +577,10 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
>>   	struct drm_gem_object *obj = vma->vm_private_data;
>>   	struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
>>   	loff_t num_pages = obj->size >> PAGE_SHIFT;
>> -	vm_fault_t ret;
>>   	struct page **pages = shmem->pages;
>> -	pgoff_t page_offset;
>> -	unsigned long pfn;
>> -
>> -	/* Offset to faulty address in the VMA. */
>> -	page_offset = vmf->pgoff - vma->vm_pgoff;
>> +	pgoff_t page_offset = vmf->pgoff - vma->vm_pgoff; /* page offset within VMA */
>> +	struct page *page = pages[page_offset];
>> +	vm_fault_t ret;
>>   
>>   	dma_resv_lock(shmem->base.resv, NULL);
>>   
>> @@ -590,21 +588,35 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
>>   	    drm_WARN_ON_ONCE(obj->dev, !shmem->pages) ||
>>   	    shmem->madv < 0) {
>>   		ret = VM_FAULT_SIGBUS;
>> -		goto out;
>> +		goto err_dma_resv_unlock;
>>   	}
>>   
>> -	if (drm_gem_shmem_try_map_pmd(vmf, vmf->address, pages[page_offset])) {
>> -		ret = VM_FAULT_NOPAGE;
>> -		goto out;
>> +	page = pages[page_offset];
>> +	if (!page) {
>> +		ret = VM_FAULT_SIGBUS;
>> +		goto err_dma_resv_unlock;
>>   	}
>>   
>> -	pfn = page_to_pfn(pages[page_offset]);
>> -	ret = vmf_insert_pfn(vma, vmf->address, pfn);
>> +	if (drm_gem_shmem_try_map_pmd(vmf, vmf->address, page)) {
>> +		ret = VM_FAULT_NOPAGE;
>> +	} else {
>> +		struct folio *folio = page_folio(page);
>> +
>> +		get_page(page);
>> +
>> +		folio_lock(folio);
>> +
>> +		vmf->page = page;
>> +		ret = VM_FAULT_LOCKED;
>> +	}
>>   
>> - out:
>>   	dma_resv_unlock(shmem->base.resv);
>>   
>>   	return ret;
>> +
>> +err_dma_resv_unlock:
>> +	dma_resv_unlock(shmem->base.resv);
>> +	return ret;
> Why do we need an error path that's exactly the same as the success
> path?

I just found the explicit roll-back code easier to work with. But the 
other style does it as well. Noted for the next iteration.

Best regards
Thomas

>
>>   }
>>   
>>   static void drm_gem_shmem_vm_open(struct vm_area_struct *vma)
>> @@ -691,7 +703,7 @@ int drm_gem_shmem_mmap(struct drm_gem_shmem_object *shmem, struct vm_area_struct
>>   	if (ret)
>>   		return ret;
>>   
>> -	vm_flags_set(vma, VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
>> +	vm_flags_mod(vma, VM_DONTEXPAND | VM_DONTDUMP, VM_PFNMAP);
>>   	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
>>   	if (shmem->map_wc)
>>   		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
> The rest looks reasonable, if everyone is happy with the less
> restrictive aspect that !PFNMAP implies, as mentioned by Matthew.

-- 
--
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Frankenstr. 146, 90461 Nürnberg, Germany, www.suse.com
GF: Jochen Jaser, Andrew McDonald, Werner Knoblich, (HRB 36809, AG Nürnberg)



