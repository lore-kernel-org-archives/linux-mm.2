Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BE66CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 10:32:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42A216B0005; Wed, 27 May 2026 06:32:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DB4C6B008A; Wed, 27 May 2026 06:32:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F11C6B008C; Wed, 27 May 2026 06:32:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1F5606B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 06:32:14 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C439DC1F3D
	for <linux-mm@kvack.org>; Wed, 27 May 2026 10:32:13 +0000 (UTC)
X-FDA: 84812834946.05.1A2B9A1
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8B008A0010
	for <linux-mm@kvack.org>; Wed, 27 May 2026 10:32:11 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LhfTsN57;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="38hJRJ/a";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=rUSXermq;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Vd1Aathu;
	spf=pass (imf25.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779877931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/iVDbonB5iVcc71aHgBrmp6zUevmWkex4U5IfatpEuU=;
	b=FKxROW9Qoh2JiX4YFle4H4+71+qWJzG3/g5rwyobsEq1bp69j4352qiPzgshEjWvETSRjg
	TJ7EqyM38xucd0sEh8MKC/zKHFQcX+pxJFi6f0tqbuA6+bXJVZQTyPKE1NBNt+qpJ9Gr+Z
	qwSwka92dwEKzZL/QkGLjZQYxQQ73a4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LhfTsN57;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="38hJRJ/a";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=rUSXermq;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Vd1Aathu;
	spf=pass (imf25.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779877931; a=rsa-sha256;
	cv=none;
	b=OISHwWAzCdhSQD7SGvFQ9/GnZgUmh/L6eFq7qtt2CXPJ1jQQsBRHQbTNEqf24vHyBETD3K
	4Ly3cAw8BygzLTUrReNks5hlRn0i8DxvOvkXvL0Z4hI3M+89QDc1TOwR2f1ISgiYZIykTF
	2h7luPAXdel6nXurSI1mnV9zM8zFD1g=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1F63C6AE7D;
	Wed, 27 May 2026 10:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779877930; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/iVDbonB5iVcc71aHgBrmp6zUevmWkex4U5IfatpEuU=;
	b=LhfTsN57WpzI1z3nRLx3Qr4ZOB29/iNOoyrzN2zJfTrE1wM37HqKOVNxE+0pmmh+96CGgL
	ClnbOt9fJbSntOLprtdU73hSSrGUaG4rs7fQRIocBqfIdeRvRByZTkeCSM+qRRR1gP8cxW
	YymuZRzsKL2qCYTeY8XPGnpSt8xz1z0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779877930;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/iVDbonB5iVcc71aHgBrmp6zUevmWkex4U5IfatpEuU=;
	b=38hJRJ/aYULRaH7nj9+lemxNLcqvmoX7Rstry2i5MyJIIrg4ZcLT7hVixZTzW5JCCEj3SV
	lrOYr+Mp+6Mwa5Cg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779877929; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/iVDbonB5iVcc71aHgBrmp6zUevmWkex4U5IfatpEuU=;
	b=rUSXermqj5p+6o1u2s70i1xg2rk+qjx3miOAGUr/oPtcJrnDG6CG9Jd0Pet85Tmj6oT6bw
	t+1Hj1wlInPbAwm1WWH+IdUMLgxpEPaI28tYPxOdJOLX6n3sX61HzM6HXF9vqVzmzu06OQ
	7D4L/YVUPxS5su8OQv4Z34yS2kCABQw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779877929;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/iVDbonB5iVcc71aHgBrmp6zUevmWkex4U5IfatpEuU=;
	b=Vd1AathuWLnzak7qfLlI16n6ukTo19y4ZCavPNf6NRxoo3UU3zvmMP6zpiVd1FDQa2u+SU
	xoIrKMSYvMfw3cDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C192E5A7AD;
	Wed, 27 May 2026 10:32:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IQoNLijIFmr0bwAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Wed, 27 May 2026 10:32:08 +0000
Message-ID: <025ee28d-c941-4cf1-a6cf-565686ea0bec@suse.de>
Date: Wed, 27 May 2026 12:32:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/6] drm/gem-shmem: Track folio accessed/dirty status
 in mmap
To: Boris Brezillon <boris.brezillon@collabora.com>
Cc: Igor Torrente <igor.torrente@collabora.com>, loic.molinari@collabora.com,
 willy@infradead.org, frank.binns@imgtec.com, matt.coster@imgtec.com,
 maarten.lankhorst@linux.intel.com, mripard@kernel.org, airlied@gmail.com,
 simona@ffwll.ch, dri-devel@lists.freedesktop.org, linux-mm@kvack.org
References: <20260209133241.238813-1-tzimmermann@suse.de>
 <20260209133241.238813-6-tzimmermann@suse.de>
 <d89422f1-f00a-47b1-b68a-d949d6d6a974@collabora.com>
 <850e8355-7884-405c-a70a-986ce032c019@suse.de>
 <831c0943-c75f-4d42-aa5f-90ce34cf8530@collabora.com>
 <67855fcd-2afe-4a1d-a51a-210e45f56167@suse.de>
 <20260527121832.7264f0db@fedora>
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
In-Reply-To: <20260527121832.7264f0db@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8B008A0010
X-Stat-Signature: ff8fj5zjai83j5rtcfzhc8kcfbjkudrp
X-HE-Tag: 1779877931-10836
X-HE-Meta: U2FsdGVkX1/Bw5yw4A57J2suTCmVQIzIo+iqGB8+oIoQwLRSycI34OUxuFtCGD4fhf+AZLJcUs6D8ymf9F/t1IItJplF5OZ95SB5K+p8w3K0cGRb78DC6Oi/J0w8uKaLaJaSm/Sv5iT1Oev2yCPJ2TVoECZqGGEWjopYjKEsGc9ylyAFvtokUfQfebB4IP1uzc7TG12M4VrMSDuP+Ce/hPqiqLfwuLXiaezttnVMCLo93XCWsmPL9NcdaT8qtFr5WQ0hfUWbNwBfWKuV+ZV85t3/ADISB1WU5oTaq9T8E7/VqR62qMfevaXxij884YB0eev8wRPXRwcy++FcuLrujBRimQOqsfQvstmGrZ1WPrNhNNfAxPGqBNWUZccBBIN4X4DU1lI2ekmfu9fiNiwAQOC6FhXnb9FlAywG6dHn8bILOGFVvFBwpypQxGt9MjJFoLMSI+Mi+UAMQ+YOEvsDdt2MGUq7GpjLA47ueBstzTqHG3aYtVmQULMcr97Z/SDlEZWVSqnGl+TK9jV+Dy0Xjh6aWz77o0e8fvuE+pW4iMwNg6LkQKvuBnAL2iMdgzldQn4yMBtgJyNzwndLkL9Jx0GLO1Schmv0vmGPEPiJB5XO6WLJxy3LHrKCXgvSfl1SP7BVPk1+Lx0nCM1H5ew8xzMODKPxIRjE1jlBcFlfBnKdmuyvx2P7uhj4atfewff+uO8CQTLKieJhhL4Yx5EmMDT/EdQKZiICakKGBu7rmx0i0ui/vQZVok/rpggtweY5J2tBVgWwBigXeRlLJHqSDkvoGPkiC1rGQmJYqUSog/WgFIn12229ij9iTl4aherRlLlF5VOSAZCcY52t4qbQQZmrD9zIudOvFxMuyhYEy4wAje68qxSsIqLH8kNMau702qQeSHdf7yWqttG3mIH0rqtBUwL9hn8jdAanOHUyDv6aSZw7CbmBmypKZtxSZVNHnRXt6BTqSCG+ZZ382Ma
 GohM4x15
 hjljxmSdywoZMDTJfQaa6HOIOe+j3VL2HI7HzWUMi84QVHxNeAJpvns9utuRQIoKbwiNHeQ0nR3dSQpN3tOY26IAc5lT6V9zVvh3Prfz43hYt40/z2ceecf8Q49OD68G7SIul1rckzqqgDWMkEiwShjKvfyktZHy2Dq4j8Q+P/HBIOJwNOjgh6vx/rA95iPYley0K0mkb/gcbr6MI+mXvXiFHONq7HWWnMbapRVKbtLg17AarhB6rEiNRZmsOgIxolcCq1IP2k0r5hafQqG2Ty7UtUfGoBklGK7NJnlWCKKeBk6x8pkSIkSfkF0QGVQcgm43yyHZhq8SL61e5oED+jZURuGQvOx6oriipT5kXfiI9g4mDX0HZBTuU341X79zt1TZBqxTk6njQklg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi

Am 27.05.26 um 12:18 schrieb Boris Brezillon:
> Hello Thomas,
>
> I'm inlining the diff you posted so I can comment on it directly before
> it's officially posted to the list.

Thanks, I'll incorporate those in the next test rev or the official patch.

Best regards
Thomas

>
> On Wed, 27 May 2026 08:56:33 +0200
> Thomas Zimmermann <tzimmermann@suse.de> wrote:
>
>> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
>> index 545933c7f712..07e117673124 100644
>> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
>> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
>> @@ -554,21 +554,6 @@ int drm_gem_shmem_dumb_create(struct drm_file *file, struct drm_device *dev,
>>   }
>>   EXPORT_SYMBOL_GPL(drm_gem_shmem_dumb_create);
>>   
>> -static void drm_gem_shmem_record_mkwrite(struct vm_fault *vmf)
>> -{
>> -	struct vm_area_struct *vma = vmf->vma;
>> -	struct drm_gem_object *obj = vma->vm_private_data;
>> -	struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
>> -	loff_t num_pages = obj->size >> PAGE_SHIFT;
>> -	pgoff_t page_offset = vmf->pgoff - vma->vm_pgoff; /* page offset within VMA */
>> -
>> -	if (drm_WARN_ON(obj->dev, !shmem->pages || page_offset >= num_pages))
>> -		return;
>> -
>> -	file_update_time(vma->vm_file);
>> -	folio_mark_dirty(page_folio(shmem->pages[page_offset]));
>> -}
>> -
>>   static vm_fault_t try_insert_pfn(struct vm_fault *vmf, unsigned int order,
>>   				 unsigned long pfn)
>>   {
>> @@ -581,23 +566,16 @@ static vm_fault_t try_insert_pfn(struct vm_fault *vmf, unsigned int order,
>>   
>>   		if (aligned &&
>>   		    folio_test_pmd_mappable(page_folio(pfn_to_page(pfn)))) {
>> -			vm_fault_t ret;
>> -
>>   			pfn &= PMD_MASK >> PAGE_SHIFT;
>>   
>> -			/* Unlike PTEs which are automatically upgraded to
>> +			/*
>> +			 * Unlike PTEs which are automatically upgraded to
>>   			 * writeable entries, the PMD upgrades go through
>>   			 * .huge_fault(). Make sure we pass the "write" info
>>   			 * along in that case.
>> -			 * This also means we have to record the write fault
>> -			 * here, instead of in .pfn_mkwrite().
>>   			 */
>> -			ret = vmf_insert_pfn_pmd(vmf, pfn,
>> -						 vmf->flags & FAULT_FLAG_WRITE);
>> -			if (ret == VM_FAULT_NOPAGE && (vmf->flags & FAULT_FLAG_WRITE))
>> -				drm_gem_shmem_record_mkwrite(vmf);
>> -
>> -			return ret;
>> +			return vmf_insert_pfn_pmd(vmf, pfn,
>> +						  vmf->flags & FAULT_FLAG_WRITE);
> I believe we can go back to
>
> 			return vmf_insert_pfn_pmd(vmf, pfn, false);
>
> if the mappings are no longer adjusted to catch write accesses.
>
>>   		}
>>   #endif
>>   	}
>> @@ -635,8 +613,15 @@ static vm_fault_t drm_gem_shmem_any_fault(struct vm_fault *vmf, unsigned int ord
>>   	pfn = page_to_pfn(page);
>>   
>>   	ret = try_insert_pfn(vmf, order, pfn);
>> -	if (ret == VM_FAULT_NOPAGE)
>> +	if (ret == VM_FAULT_NOPAGE) {
>>   		folio_mark_accessed(folio);
>> +		/*
>> +		 * Always record write access to the buffer. The natural
>> +		 * place would be pfn_mkwrite, but this breaks KVM.
>> +		 */
>> +		file_update_time(vma->vm_file);
>> +		folio_mark_dirty(folio);
> We can be a bit smarter here:
>
> 		/*
> 		 * Always record write access to the buffer if the
> 		 * mapping is writeable. The natural place would be
> 		 * pfn_mkwrite, but this breaks KVM.
> 		 */
> 		if (vma->vm_flags & VM_WRITE) {
> 			file_update_time(vma->vm_file);
> 			folio_mark_dirty(folio);
> 		}
>
>> +	}
> The rest looks good to me.
>
> Regards,
>
> Boris

-- 
--
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Frankenstr. 146, 90461 Nürnberg, Germany, www.suse.com
GF: Jochen Jaser, Andrew McDonald, Werner Knoblich, (HRB 36809, AG Nürnberg)



