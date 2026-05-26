Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26D4FCD5BD2
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 14:44:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76A8A6B00C2; Tue, 26 May 2026 10:44:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71BD96B00CF; Tue, 26 May 2026 10:44:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E32C6B00D1; Tue, 26 May 2026 10:44:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 45F656B00C2
	for <linux-mm@kvack.org>; Tue, 26 May 2026 10:44:26 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E0BEDC1A2E
	for <linux-mm@kvack.org>; Tue, 26 May 2026 14:44:25 +0000 (UTC)
X-FDA: 84809841690.09.D2A6EB9
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf07.hostedemail.com (Postfix) with ESMTP id B85A940009
	for <linux-mm@kvack.org>; Tue, 26 May 2026 14:44:23 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wErWFlsr;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=gXhoc9y1;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wErWFlsr;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=gXhoc9y1;
	spf=pass (imf07.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779806663; a=rsa-sha256;
	cv=none;
	b=mr+UmIRG1e6Weh4LUhecvcevdSFEIRC9IdD2eJRrlIajxaniO87CnSdoVneRaIwFuZIqMi
	C+G1/3F14ZAHFACTuruAMAj9tUVcXEeOZa+pB762EZgn5ZdZc3PRDJRWrL/bHscRu2pZs5
	c6YIfSxPf5htlRJrAq5FRVLhK12aHGM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wErWFlsr;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=gXhoc9y1;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wErWFlsr;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=gXhoc9y1;
	spf=pass (imf07.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779806663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xSGN5MnauGYIiHQIRVAhWm2E3gq8TYxrC2C53w6vF5Y=;
	b=YXYG0Agnh7EqkBXcP9fCrzJ72hLJFJiVBAiz31tHo+g3fKtL9Ni05A/zdaAxyud5JkyERL
	wqPXsYhdXfVyFS7v5AGbI6ds9NrAsMhQqXGUOJrjh7nIvQe+p5tZB9eINwg3ANG6nYrhGV
	1T0reLTPCxvgxoxrxeBgaydRZ2hCJHU=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 16DAC6A882;
	Tue, 26 May 2026 14:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779806662; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xSGN5MnauGYIiHQIRVAhWm2E3gq8TYxrC2C53w6vF5Y=;
	b=wErWFlsrUXXYAc0gDI1DDrJ+qPgznfE+4+qFot/TZvveLbdwDV6cC8umTVAps7oT3cno/J
	BxhK9OqU3BDLs5OdvJcHxvXXm+BP/788T3pw+UlRC7ogzm+a31wMvTMeVbP2NuAPr69uKM
	Vf9ST0lxGsQbkh7JIRUhXS2lO0TIps0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779806662;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xSGN5MnauGYIiHQIRVAhWm2E3gq8TYxrC2C53w6vF5Y=;
	b=gXhoc9y1WGbtKocceAjH/67WYJ0TUX3Sg3pt0JunysECvszYvwME5DZ8llgW0wnwrB1Kvg
	yLH+ZDXhBeoViLBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779806662; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xSGN5MnauGYIiHQIRVAhWm2E3gq8TYxrC2C53w6vF5Y=;
	b=wErWFlsrUXXYAc0gDI1DDrJ+qPgznfE+4+qFot/TZvveLbdwDV6cC8umTVAps7oT3cno/J
	BxhK9OqU3BDLs5OdvJcHxvXXm+BP/788T3pw+UlRC7ogzm+a31wMvTMeVbP2NuAPr69uKM
	Vf9ST0lxGsQbkh7JIRUhXS2lO0TIps0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779806662;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xSGN5MnauGYIiHQIRVAhWm2E3gq8TYxrC2C53w6vF5Y=;
	b=gXhoc9y1WGbtKocceAjH/67WYJ0TUX3Sg3pt0JunysECvszYvwME5DZ8llgW0wnwrB1Kvg
	yLH+ZDXhBeoViLBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B77225A266;
	Tue, 26 May 2026 14:44:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id d0JVK8WxFWoWPgAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Tue, 26 May 2026 14:44:21 +0000
Message-ID: <850e8355-7884-405c-a70a-986ce032c019@suse.de>
Date: Tue, 26 May 2026 16:44:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/6] drm/gem-shmem: Track folio accessed/dirty status
 in mmap
To: Igor Torrente <igor.torrente@collabora.com>,
 boris.brezillon@collabora.com, loic.molinari@collabora.com,
 willy@infradead.org, frank.binns@imgtec.com, matt.coster@imgtec.com,
 maarten.lankhorst@linux.intel.com, mripard@kernel.org, airlied@gmail.com,
 simona@ffwll.ch
Cc: dri-devel@lists.freedesktop.org, linux-mm@kvack.org
References: <20260209133241.238813-1-tzimmermann@suse.de>
 <20260209133241.238813-6-tzimmermann@suse.de>
 <d89422f1-f00a-47b1-b68a-d949d6d6a974@collabora.com>
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
In-Reply-To: <d89422f1-f00a-47b1-b68a-d949d6d6a974@collabora.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B85A940009
X-Stat-Signature: 9syjz88ehs48ka9gd644akiswjxi3xbu
X-HE-Tag: 1779806663-43191
X-HE-Meta: U2FsdGVkX18MU9+j004Ij40vo5eCvCcKpQEnVq8hv1OMZ4rvqmZcLyA/NF4erNddEZB4vXB9rKzUiY1zEli+VhoHy27C6k8JF1vM+B4xkRtiYHTFRjw46qMmy6FUebR4KCV+zf/0+m3JfL1eXfu3SGCzZ2f20dWGOiOpla0+V5wJptVnla8vmqbVtOotqndIcAjhez7hiideoRo59uom+LqBJPGwmceqwsbX0BnotczqChYJE/rBzYYHY10CnDt+uMgbyMqeniF7j6EYaZk9DiuF0/A3FSRPKBaOGgmslp4Z6dyfPm715sYl/N0EOWoWte4iKpdH+IkIQTrHSMzE1rao3Gzlddj6pxvcS3L7tr0JFYKvzgfE49/sHRysotm5ciwdOcfO+HBByeVGccZbUR7PcOyg+Q/FMUTqNKT2G5Xd0aq8dYwBVtxrVCA+fPbW26sNUIA4jCT9hFDsPrVaO6evhAHenfRu0gP/ChaXOoIW9mG+bSDlXwA0SQ+o9GkDvIGZZDKk1KO1nuSrLS2g+y4lnIXyC/Z0HT+TBrAMvOEyxxbVXfu4n6PP6s2wcH46VHTgcdEcs6U1AsoVNaWeYKtfoHcXZ0ZAnJ4Vec6RVhSXYGteCEbNDsHNsq7Q0IiAbUnLxzDiTt0q44z4m0Gj3HN4fCi+HOi6K3Mlqfq8O4gRUzgJdlQ0cYDP7OBYfV00W7/iNf9StCxy7Ug4vyDXaxDKegUP3/38l5/Rs2tsed2XElozrz9mJmBZPfpKS4tBpxdE1isO1qCfCD/47LDTTboqz7lGEUcRF+lYPuk6aAqcUV4DWcaUnWqTRFP2W51bLfi/Xk0szhe6NV9UTwd0mdiVDIyZwiP1E4sZlwjXhi1pvxClFhrNOXwYUxwX474IA/eXswP/LZF9MtQHrTE20TSiNv0mf1yh0QR74lmaTXBHSOpJKCF/F6YeFpt8qKoTl2/WiEHA0ZEH2lp6RR8
 oSoavalJ
 lC03Zxv1vuLlq/nj2ftfYF+PcZWUtlgaj0Z8fBn1YndEkSUwkOnoPLV7jIA0b/qkUbKjvD42t2tFyvLgXLp1PXEvVzbl5XKCTsB7gEYMUUmPvkNvxUQdqKyy9BdyY/IBDAN7c+k+bwpY7njv3tQ58YRQrmPYioa8NpXPRmZMBkWc0XS8rcDbimKskb5982H2c9GJzc3WVuBymFImBX2gK+ZY67+1PhC0axBkDgEv05Bh9jErELDqSN8ffTb5yHfllP43lVmpwDJujuF9hSdUs3BIvepHiD4g2FQLHiKE/AtOyR+gXNGTX7HWAN/vTSHzdnEaW1lsObkeJovUnT9y3QR4TPai3ffvrJ+wdAjcp/Vk1+EXItmI99+tWpIAF1oU7gQxYC/i8df6jZho=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi

Am 20.05.26 um 15:11 schrieb Igor Torrente:
[...]
>
> I'm not familiar with the drm_gem, code so I don't any more insightful 
> information
> to share.  But hopefully we can find a better fix for this.

Do you have huge pages enabled ?

Best regards
Thomas

>
> BR,
> Igor Torrente
>
>> ---
>>   drivers/gpu/drm/drm_gem_shmem_helper.c | 20 ++++++++++++++++++++
>>   1 file changed, 20 insertions(+)
>>
>> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c 
>> b/drivers/gpu/drm/drm_gem_shmem_helper.c
>> index c3a054899ba3..0c86ad40a049 100644
>> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
>> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
>> @@ -598,6 +598,9 @@ static vm_fault_t drm_gem_shmem_fault(struct 
>> vm_fault *vmf)
>>       if (ret != VM_FAULT_NOPAGE)
>>           ret = vmf_insert_pfn(vma, vmf->address, pfn);
>>   +    if (likely(!(ret & VM_FAULT_ERROR)))
>> +        folio_mark_accessed(folio);
>> +
>>   out:
>>       dma_resv_unlock(obj->resv);
>>   @@ -638,10 +641,27 @@ static void drm_gem_shmem_vm_close(struct 
>> vm_area_struct *vma)
>>       drm_gem_vm_close(vma);
>>   }
>>   +static vm_fault_t drm_gem_shmem_pfn_mkwrite(struct vm_fault *vmf)
>> +{
>> +    struct vm_area_struct *vma = vmf->vma;
>> +    struct drm_gem_object *obj = vma->vm_private_data;
>> +    struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
>> +    pgoff_t page_offset = vmf->pgoff - vma->vm_pgoff; /* page offset 
>> within VMA */
>> +    struct page *page = shmem->pages[page_offset];
>> +    struct folio *folio = page_folio(page);
>> +
>> +    file_update_time(vma->vm_file);
>> +
>> +    folio_mark_dirty(folio);
>> +
>> +    return 0;
>> +}
>> +
>>   const struct vm_operations_struct drm_gem_shmem_vm_ops = {
>>       .fault = drm_gem_shmem_fault,
>>       .open = drm_gem_shmem_vm_open,
>>       .close = drm_gem_shmem_vm_close,
>> +    .pfn_mkwrite = drm_gem_shmem_pfn_mkwrite,
>>   };
>>   EXPORT_SYMBOL_GPL(drm_gem_shmem_vm_ops);

-- 
--
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Frankenstr. 146, 90461 Nürnberg, Germany, www.suse.com
GF: Jochen Jaser, Andrew McDonald, Werner Knoblich, (HRB 36809, AG Nürnberg)



