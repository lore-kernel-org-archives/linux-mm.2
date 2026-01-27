Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4021D2F03E
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 14:51:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2029D6B0089; Tue, 27 Jan 2026 09:51:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 186366B0092; Tue, 27 Jan 2026 09:51:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05BA16B0093; Tue, 27 Jan 2026 09:51:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E468C6B0089
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 09:51:34 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 73664140117
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 14:51:34 +0000 (UTC)
X-FDA: 84378032508.28.A6C4778
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3EC808000E
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 14:51:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="tEcTh/k0";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=GfYXPRDM;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="tEcTh/k0";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=GfYXPRDM;
	spf=pass (imf30.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769525492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M3tqet/7U9w5GkoOfLDlX8vgaZNJQICiKO6Ia2zmu4Y=;
	b=NSa8Q6ZKpD393Q+e6Zp7ZBbhL34jEdjnVuph1XAW6bMo374nJMpCh/bJe5a4JjdAnRv2E4
	KLDZQTXNt8xHFa+oJbmi9E8QW9Os5dXVyoN5GHXbpN6oBtIwU5WNMTu1qKLJvrs8jABaa2
	qqYK2Gj+ZAp+5dqWubxBSPxGTFfaROU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="tEcTh/k0";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=GfYXPRDM;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="tEcTh/k0";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=GfYXPRDM;
	spf=pass (imf30.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769525492; a=rsa-sha256;
	cv=none;
	b=gU3jQBL73TXM/gQqno17YdlSfLPGDaDF8/bTSSALK2CSSkk7Txfd1qhVjD03/xCMqK5ssJ
	8Lb6iMijegz8tLTiuiNnoI3bm6xhQmz4JW8kZOv1nuZtaKi9rWhaELEzskIZjeNMBk/EXV
	EUprff8WdZxqjphWI3ZV3gq4R05uoQo=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 98CA75BCEE;
	Tue, 27 Jan 2026 14:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1769525490; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=M3tqet/7U9w5GkoOfLDlX8vgaZNJQICiKO6Ia2zmu4Y=;
	b=tEcTh/k0XSDTWpNvxt9WeeO+qABZKMsw1MIn59edlh/BbXGULGPHqw33Iu2YIKETNAFZyT
	RcfEwbcuDsjIfY7iKYwmdd87kRGI8dYZS2WlvWAhJeE+c3rhY6CtwCNyJPNlNST23ilbnP
	/GpZkUaWnj2dhTuLpVy0fcqu2mqf2Ys=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1769525490;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=M3tqet/7U9w5GkoOfLDlX8vgaZNJQICiKO6Ia2zmu4Y=;
	b=GfYXPRDMPODzkZmCAiK7mjM7cwVYPenOe/UFYrDEye2QQjL+HRCXh8oEzEvaTq3oCc2XD0
	wZ5WhvwcdridTrAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1769525490; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=M3tqet/7U9w5GkoOfLDlX8vgaZNJQICiKO6Ia2zmu4Y=;
	b=tEcTh/k0XSDTWpNvxt9WeeO+qABZKMsw1MIn59edlh/BbXGULGPHqw33Iu2YIKETNAFZyT
	RcfEwbcuDsjIfY7iKYwmdd87kRGI8dYZS2WlvWAhJeE+c3rhY6CtwCNyJPNlNST23ilbnP
	/GpZkUaWnj2dhTuLpVy0fcqu2mqf2Ys=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1769525490;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=M3tqet/7U9w5GkoOfLDlX8vgaZNJQICiKO6Ia2zmu4Y=;
	b=GfYXPRDMPODzkZmCAiK7mjM7cwVYPenOe/UFYrDEye2QQjL+HRCXh8oEzEvaTq3oCc2XD0
	wZ5WhvwcdridTrAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3704D3EA61;
	Tue, 27 Jan 2026 14:51:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8W0PDPLQeGlXWgAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Tue, 27 Jan 2026 14:51:30 +0000
Message-ID: <ab2651eb-918b-4be0-9ee7-7af33f87378e@suse.de>
Date: Tue, 27 Jan 2026 15:51:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] drm/gem-shmem: Map pages in mmap fault handler
To: Matthew Wilcox <willy@infradead.org>
Cc: boris.brezillon@collabora.com, loic.molinari@collabora.com,
 maarten.lankhorst@linux.intel.com, mripard@kernel.org, airlied@gmail.com,
 simona@ffwll.ch, frank.binns@imgtec.com, matt.coster@imgtec.com,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org
References: <20260127132938.429288-1-tzimmermann@suse.de>
 <20260127132938.429288-2-tzimmermann@suse.de>
 <aXjEjaYsqo6oIsAl@casper.infradead.org>
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
In-Reply-To: <aXjEjaYsqo6oIsAl@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Stat-Signature: qeoctznm6fs5xrcekt5wdatkxa4i1tik
X-Rspamd-Queue-Id: 3EC808000E
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769525492-842458
X-HE-Meta: U2FsdGVkX1/W85YvjlGVoikWk7fbCYzGnSRgyQju03C/CX0XiEcFnaeWLKqV11W2gEW2gwqX/eVAGyUcESn/qQBlVVSYnb3toFlpwoUOPcbQ+gXZCYPI55FXaOAhpvqoLxE/qMZlm1GFd3aMc2Wd9Q6nojCVv1NODLw06QQXYmr192UnzRYfQ0cX2GQI5F+Y2VSZAjQdtoJqpzcBSR+fCBzifUElHdhLohHQJ6pGFbBLqmcpYbvgQ0g4O9PaDtzumnY9o4JrvoT/f+IH81sx63krmClndW4lAWFjTOyMnrtR5wyWaltq3gRKmINSM2RaPywUTS/syqhzxBBcNyzb1HImLUUpUn0IA77mLIVCTKDpPc9oXc2vqUOcZd8tStUVPS7yOqE9gaFPJ/icAIsmkqSfM+MHwIitaD7oJT7X0etxxDakb3np3XKqGafF/2pIBGTeeibk5D2t1uxMoitrS+4yn5HbpOfIF9j3KtYFFfKhIcP2JrH29PUszfsb66OynFAZP8YUusir5JCKGXPQcxuS2neykrvvdBPqXTj61KsRMrMxZv9MvW8ViG6GLc/i/151i28OlDV4uWohSSjFvd89gG6GeJyF4/qtGeBT5/6TNLRrWIKQzjIFuCJVX0vHz2YUGU8N/b3Lzo2tt8bAxeD5/FPHxJ3y9gr4JwDTli8ho1SpS52KJ0X1AJCkNJX9qFvbabBHhGSbRjxUWcRavviTSZfQinR8KcdWeLJYFi5fhB6cPNdhSsHcYETzf8ymBczkKOrM6fHT4AaqRu2RpUBbNksQC01+X1RslmtycOAvQgHl928/gjxF8rV01LoM80Zms5xnsIdBfIoS1QzD7//mo6WZk3Gw3RyJHch3HhJORk4HG7t1g8GQ9+l/ZQ/G8F0UifQ+AntoUcGAlHP1Y9Evb3OVodU49RF17dH+gNjgwmFyqVcDLBwwmWCNRlNzzOVqj8JelAk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

thanks for reviewing.

Am 27.01.26 um 14:58 schrieb Matthew Wilcox:
> On Tue, Jan 27, 2026 at 02:16:36PM +0100, Thomas Zimmermann wrote:
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
> It would feel more natural to me to have this function return vm_fault_t
> instead of a bool.  What do you think?

I took what was already there, but I had the same thought.

>
>> +	pgoff_t page_offset = vmf->pgoff - vma->vm_pgoff; /* page offset within VMA */
>> +	struct page *page = pages[page_offset];
>> +	vm_fault_t ret;
> [...]
>
>> -	if (drm_gem_shmem_try_map_pmd(vmf, vmf->address, pages[page_offset])) {
>> -		ret = VM_FAULT_NOPAGE;
>> -		goto out;
>> +	page = pages[page_offset];
> Can page_offset have changed at this point?

No, that's a mistake in the patch.  This line is left over from an 
earlier prototype. Apologies.

>
>> +	if (drm_gem_shmem_try_map_pmd(vmf, vmf->address, page)) {
>> +		ret = VM_FAULT_NOPAGE;
>> +	} else {
>> +		struct folio *folio = page_folio(page);
>> +
>> +		get_page(page);
> folio_get(folio);
>
>> -	vm_flags_set(vma, VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
>> +	vm_flags_mod(vma, VM_DONTEXPAND | VM_DONTDUMP, VM_PFNMAP);
> Just so you know, this is going to change observable behaviour, maybe
> in a good way.  For example, we'll now be able to do O_DIRECT I/O to
> this range and ptrace accesses.  I think everything will be fine, but
> VM_PFNMAP does prohibit some things which are now allowed.

Out of curiosity: how does this interact with the hugetable support? 
Using any of these new features would implicitly disable them for that 
mapping?

Best regards
Thomas


-- 
--
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Frankenstr. 146, 90461 Nürnberg, Germany, www.suse.com
GF: Jochen Jaser, Andrew McDonald, Werner Knoblich, (HRB 36809, AG Nürnberg)



