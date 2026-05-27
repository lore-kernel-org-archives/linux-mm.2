Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D5B0CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 06:56:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 773486B0005; Wed, 27 May 2026 02:56:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 725006B008A; Wed, 27 May 2026 02:56:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EC286B008C; Wed, 27 May 2026 02:56:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4B4F86B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 02:56:38 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DE0E040507
	for <linux-mm@kvack.org>; Wed, 27 May 2026 06:56:37 +0000 (UTC)
X-FDA: 84812291634.16.B101F7B
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf12.hostedemail.com (Postfix) with ESMTP id 959AB40002
	for <linux-mm@kvack.org>; Wed, 27 May 2026 06:56:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="VmPE7d5/";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=GA+npAAD;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="VmPE7d5/";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=GA+npAAD;
	spf=pass (imf12.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779864995; a=rsa-sha256;
	cv=none;
	b=fLMeYnw0e02vNlDdfZL0ZyLkf6hRcqIfkDalrBJC9UIoq8WBVCuyMv4iKZGP74kypnkIE7
	mpAQ2bfdQzqmqEP+Vd9AVcgbNs4KoJlwALoH4T/pwqizjxTdF4ULfbgYD20TKaEZDhk2wv
	sMtHJL3rhqbpvcHDgo6nWF9pyUtTcy8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="VmPE7d5/";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=GA+npAAD;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="VmPE7d5/";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=GA+npAAD;
	spf=pass (imf12.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779864995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DKonJIChTBbTxvdrXGx+kKIgXH4hM3XFhBOENEhGEoQ=;
	b=QGooqYLL0UetdBifYWTA5UpjST2w+MGaJ+jnlmHwrov7U/FXsnG4Fo0y99C5pcekZ5WQe+
	x+7/DRWAfwaUL57B0iPDy8J53nFc/GBgMSh8nWSjVBDJl90BwQjHETm4mbvRLZqo1LuQPK
	YiDO8Jy0OSBS324w4JiVnZGF1iXeIFI=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1A3C96AF0A;
	Wed, 27 May 2026 06:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779864994; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=DKonJIChTBbTxvdrXGx+kKIgXH4hM3XFhBOENEhGEoQ=;
	b=VmPE7d5/b/nwm1Zm3Ineo+D1pdHLAPSqBKIP1nY+kWJHQDBpTmGTfcIXdg2O5eulL9vnQC
	A6DsSfkO6COZY9SRtb1F3Lb7jOl41qwHF4Rml+s4DhWrc7LYvnGfL6kIJVrM6Nye6cNV4Y
	Q2tnup25YiUQ/7KBHzNUt9k+vNxY0yM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779864994;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=DKonJIChTBbTxvdrXGx+kKIgXH4hM3XFhBOENEhGEoQ=;
	b=GA+npAAD04tEiYWYwlRGKCYlrXgP0q6Srq8wgsCF4kmlZxSnD4tm9Vj5EXxhZJMSHIVQ7M
	y5pZ9LKY3fx9ViAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779864994; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=DKonJIChTBbTxvdrXGx+kKIgXH4hM3XFhBOENEhGEoQ=;
	b=VmPE7d5/b/nwm1Zm3Ineo+D1pdHLAPSqBKIP1nY+kWJHQDBpTmGTfcIXdg2O5eulL9vnQC
	A6DsSfkO6COZY9SRtb1F3Lb7jOl41qwHF4Rml+s4DhWrc7LYvnGfL6kIJVrM6Nye6cNV4Y
	Q2tnup25YiUQ/7KBHzNUt9k+vNxY0yM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779864994;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=DKonJIChTBbTxvdrXGx+kKIgXH4hM3XFhBOENEhGEoQ=;
	b=GA+npAAD04tEiYWYwlRGKCYlrXgP0q6Srq8wgsCF4kmlZxSnD4tm9Vj5EXxhZJMSHIVQ7M
	y5pZ9LKY3fx9ViAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BE28A5A6CF;
	Wed, 27 May 2026 06:56:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id M3rvLKGVFmroFQAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Wed, 27 May 2026 06:56:33 +0000
Content-Type: multipart/mixed; boundary="------------qEORVyYFqwCDMYi1Vb0xhvqj"
Message-ID: <67855fcd-2afe-4a1d-a51a-210e45f56167@suse.de>
Date: Wed, 27 May 2026 08:56:33 +0200
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
 <850e8355-7884-405c-a70a-986ce032c019@suse.de>
 <831c0943-c75f-4d42-aa5f-90ce34cf8530@collabora.com>
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
In-Reply-To: <831c0943-c75f-4d42-aa5f-90ce34cf8530@collabora.com>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 959AB40002
X-Stat-Signature: pxqdw43yt7qwxthyinurpnnqszm5awj3
X-HE-Tag: 1779864995-20204
X-HE-Meta: U2FsdGVkX1/E5mUP2IF0YIwZN24eSV9i7MQN+oDJ+pepvP7745JnhB20TR6Xx2/k56ak2gsS5RID8mOnbXPJ8iwCDDyXsaBD8NL8pQffi6eceNSuUJIysVQPOWsRlPupxhuZ6KmQ/dzhD1oTrODAWRvUvGNmx3oRo5F0BBdbqKNrE9apdWDK7IUuvkSKNP4x8LkOLxzM4Kya1QUYm+d7ImQdWa3lbrh9UKkZDd9SRDCoKEVHoGb0SyzAHcmOhLAUhe+kNabV1gE9gVnkDfh1zB/bzDoztwnEh2fKVGWMz5tAUsOc6g9dkFWgGdwa+etnph6TcZ7yxPptCCY1TIgALyo41EAH/7QNDE7yjv0j55qrUXfxEa9vt6j6AwDRzfNLHoUH+7qMxGQOGHzLtob/1RqXcalTN0/vDsYXtkQWY0OGC3Pu4Yn0G4cyyBLc57K3FexcE2CbbGNXRTkVNIaiYv6z8rGTM6rWVjl4U5tN/T3BturoCeU+7lGpjUd4woMqUtz5UP/ZYqFv61tlt/6PPrswt+giaNqXkZZVlfBkNgzwJZM0BdicTAgh0Hj7nDu3ijkBBzfRpiAbNbhHk2/fk3pzx5nFPv1Kfx+tk18zf3EShpirJ+UuL5rV4btws7nrJGV4wwGXIbA2UDqP5z93BvOSzwREctmgHZdU8Jx4cSSSBgQ+UUTSGCTFr9IIE5NnOrOhDGG9SEcbPwDoY6AizCjyRAvaRwjQM3cPRIT+ZPfyo6TaRh42bgoABXWo1xKKsMSFAFnfAr3XK7xTt05i3lnpPix8iXdBx+T0mfGm4Cp4xs/WMN0S5IDJlxfNGmTxl+ar7bbj4gMxyuHxuf3Nk/uirfbGuVZ8qC4sjG5KnQYQY1V1GN9Esup2rYDgN6rOuynzgRoX6CXrLAZ6bJaFs5LrJx31Ra/HA90xq4sKlipzlVZxbjPXHD+w7wpGAfvqRYqEmbvjVYYuk8zoxia
 7NxH4RnA
 29UIGOMeHHrYas/EtVH7WXQXKjJFphQ6dE++3TydyUB5/1dH60U6MqeQe8MSIM+5KqgNeD0Xjt3VPFDiLflkcC04hvy31SIue+AOFcPm5Z5sAeMfoL2HjVhXl1ep29hn6oZjNuT1GULseYzwL/MEUlpXQJhgKSPLZIniMwW9YMRo/2C+UIMVXgtpUzljFSi2vgsR9oPZzrbg5FE2GDDQ9q4y1tWILjQBMUM0aw0xdWtNyjNwBBqRAUCNyGuHuX/lk76zstgrk0JpB7LoJDkpt3lN83+91wvwgIR1/ZIii1kJDoqR/BR5/rzDDLd2DhDOrD2TcSs4qsXh/6UHXH966F/QSI26WRPS5E5PNcfPYO35wk5xb07anUxNRxWSN3fgM+vx+bQrrCSZTJhAsqyKkIj/PQnFmnK1kpan7S75Jzzbw4RYR4hoAcp1jqd5ZGS/164DMh9RBfT4Zb7VYJ7qH/ujdg89j/q9Zw8Oow9eUrNxLxH52w4ymi8WdhC4UJITc82Yf4vsQ/BHwWtxZTC9JOX+O0AbYAhkVo7p6DflNnAq5ixZbozGfCf/PXvH35YyOuc/2fvX5azIlPSfcVNCDsalZ9eQCkx9rPLPN1ulcNDITorPry6qapLlt5mEB9GpGqXn6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------qEORVyYFqwCDMYi1Vb0xhvqj
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi

Am 26.05.26 um 16:56 schrieb Igor Torrente:
> Hi Thomas,
>
> On 5/26/26 11:44, Thomas Zimmermann wrote:
>> Hi
>>
>> Am 20.05.26 um 15:11 schrieb Igor Torrente:
>> [...]
>>>
>>> I'm not familiar with the drm_gem, code so I don't any more 
>>> insightful information
>>> to share.  But hopefully we can find a better fix for this.
>>
>> Do you have huge pages enabled ?
>
> No, I didn't even compile my kernel with huge pages. I've already been 
> burned by that before

I see.

The attached patch is a cleaned up version of Boris' fix. Please test 
and report back on the results.

Best regards
Thomas

>
>
> BR,
> Igor Torrente
>
>>
>> Best regards
>> Thomas
>>
>>>
>>> BR,
>>> Igor Torrente
>>>
>>>> ---
>>>>   drivers/gpu/drm/drm_gem_shmem_helper.c | 20 ++++++++++++++++++++
>>>>   1 file changed, 20 insertions(+)
>>>>
>>>> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c 
>>>> b/drivers/gpu/drm/drm_gem_shmem_helper.c
>>>> index c3a054899ba3..0c86ad40a049 100644
>>>> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
>>>> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
>>>> @@ -598,6 +598,9 @@ static vm_fault_t drm_gem_shmem_fault(struct 
>>>> vm_fault *vmf)
>>>>       if (ret != VM_FAULT_NOPAGE)
>>>>           ret = vmf_insert_pfn(vma, vmf->address, pfn);
>>>>   +    if (likely(!(ret & VM_FAULT_ERROR)))
>>>> +        folio_mark_accessed(folio);
>>>> +
>>>>   out:
>>>>       dma_resv_unlock(obj->resv);
>>>>   @@ -638,10 +641,27 @@ static void drm_gem_shmem_vm_close(struct 
>>>> vm_area_struct *vma)
>>>>       drm_gem_vm_close(vma);
>>>>   }
>>>>   +static vm_fault_t drm_gem_shmem_pfn_mkwrite(struct vm_fault *vmf)
>>>> +{
>>>> +    struct vm_area_struct *vma = vmf->vma;
>>>> +    struct drm_gem_object *obj = vma->vm_private_data;
>>>> +    struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
>>>> +    pgoff_t page_offset = vmf->pgoff - vma->vm_pgoff; /* page 
>>>> offset within VMA */
>>>> +    struct page *page = shmem->pages[page_offset];
>>>> +    struct folio *folio = page_folio(page);
>>>> +
>>>> +    file_update_time(vma->vm_file);
>>>> +
>>>> +    folio_mark_dirty(folio);
>>>> +
>>>> +    return 0;
>>>> +}
>>>> +
>>>>   const struct vm_operations_struct drm_gem_shmem_vm_ops = {
>>>>       .fault = drm_gem_shmem_fault,
>>>>       .open = drm_gem_shmem_vm_open,
>>>>       .close = drm_gem_shmem_vm_close,
>>>> +    .pfn_mkwrite = drm_gem_shmem_pfn_mkwrite,
>>>>   };
>>>>   EXPORT_SYMBOL_GPL(drm_gem_shmem_vm_ops);
>>

-- 
--
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Frankenstr. 146, 90461 Nürnberg, Germany, www.suse.com
GF: Jochen Jaser, Andrew McDonald, Werner Knoblich, (HRB 36809, AG Nürnberg)


--------------qEORVyYFqwCDMYi1Vb0xhvqj
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-drm-gem-shmem-Always-assume-writable-mmap-drop-pfn_m.patch"
Content-Disposition: attachment;
 filename*0="0001-drm-gem-shmem-Always-assume-writable-mmap-drop-pfn_m.pa";
 filename*1="tch"
Content-Transfer-Encoding: base64

RnJvbSA0NDc4YjNlMDc1MTUxOTQ4MTI4MDZjNWJmYzNiNzQzMmQ4Zjg0MDZhIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBUaG9tYXMgWmltbWVybWFubiA8dHppbW1lcm1hbm5A
c3VzZS5kZT4KRGF0ZTogV2VkLCAyNyBNYXkgMjAyNiAwODowNzoxOSArMDIwMApTdWJqZWN0
OiBbUEFUQ0hdIGRybS9nZW0tc2htZW06IEFsd2F5cyBhc3N1bWUgd3JpdGFibGUgbW1hcDsg
ZHJvcCBwZm5fbWt3cml0ZQoKVXNpbmcgcGZuX21rd3JpdGUgYnJlYWtzIEtWTSB3aXRoICJl
cnJvcjoga3ZtIHJ1biBmYWlsZWQgQmFkIGFkZHJlc3MiLgpTZWVuIG9uIGEgTWFsaS1HNjEw
IEdQVS4gRml4IHRoaXMgYnkgYWx3YXlzIG1hcmtpbmcgdGhlIG1hcHBlZCBwYWdlcwphcyB3
cml0dGVuLgotLS0KIGRyaXZlcnMvZ3B1L2RybS9kcm1fZ2VtX3NobWVtX2hlbHBlci5jIHwg
NDYgKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAxMiBpbnNl
cnRpb25zKCspLCAzNCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9k
cm0vZHJtX2dlbV9zaG1lbV9oZWxwZXIuYyBiL2RyaXZlcnMvZ3B1L2RybS9kcm1fZ2VtX3No
bWVtX2hlbHBlci5jCmluZGV4IDU0NTkzM2M3ZjcxMi4uMDdlMTE3NjczMTI0IDEwMDY0NAot
LS0gYS9kcml2ZXJzL2dwdS9kcm0vZHJtX2dlbV9zaG1lbV9oZWxwZXIuYworKysgYi9kcml2
ZXJzL2dwdS9kcm0vZHJtX2dlbV9zaG1lbV9oZWxwZXIuYwpAQCAtNTU0LDIxICs1NTQsNiBA
QCBpbnQgZHJtX2dlbV9zaG1lbV9kdW1iX2NyZWF0ZShzdHJ1Y3QgZHJtX2ZpbGUgKmZpbGUs
IHN0cnVjdCBkcm1fZGV2aWNlICpkZXYsCiB9CiBFWFBPUlRfU1lNQk9MX0dQTChkcm1fZ2Vt
X3NobWVtX2R1bWJfY3JlYXRlKTsKIAotc3RhdGljIHZvaWQgZHJtX2dlbV9zaG1lbV9yZWNv
cmRfbWt3cml0ZShzdHJ1Y3Qgdm1fZmF1bHQgKnZtZikKLXsKLQlzdHJ1Y3Qgdm1fYXJlYV9z
dHJ1Y3QgKnZtYSA9IHZtZi0+dm1hOwotCXN0cnVjdCBkcm1fZ2VtX29iamVjdCAqb2JqID0g
dm1hLT52bV9wcml2YXRlX2RhdGE7Ci0Jc3RydWN0IGRybV9nZW1fc2htZW1fb2JqZWN0ICpz
aG1lbSA9IHRvX2RybV9nZW1fc2htZW1fb2JqKG9iaik7Ci0JbG9mZl90IG51bV9wYWdlcyA9
IG9iai0+c2l6ZSA+PiBQQUdFX1NISUZUOwotCXBnb2ZmX3QgcGFnZV9vZmZzZXQgPSB2bWYt
PnBnb2ZmIC0gdm1hLT52bV9wZ29mZjsgLyogcGFnZSBvZmZzZXQgd2l0aGluIFZNQSAqLwot
Ci0JaWYgKGRybV9XQVJOX09OKG9iai0+ZGV2LCAhc2htZW0tPnBhZ2VzIHx8IHBhZ2Vfb2Zm
c2V0ID49IG51bV9wYWdlcykpCi0JCXJldHVybjsKLQotCWZpbGVfdXBkYXRlX3RpbWUodm1h
LT52bV9maWxlKTsKLQlmb2xpb19tYXJrX2RpcnR5KHBhZ2VfZm9saW8oc2htZW0tPnBhZ2Vz
W3BhZ2Vfb2Zmc2V0XSkpOwotfQotCiBzdGF0aWMgdm1fZmF1bHRfdCB0cnlfaW5zZXJ0X3Bm
bihzdHJ1Y3Qgdm1fZmF1bHQgKnZtZiwgdW5zaWduZWQgaW50IG9yZGVyLAogCQkJCSB1bnNp
Z25lZCBsb25nIHBmbikKIHsKQEAgLTU4MSwyMyArNTY2LDE2IEBAIHN0YXRpYyB2bV9mYXVs
dF90IHRyeV9pbnNlcnRfcGZuKHN0cnVjdCB2bV9mYXVsdCAqdm1mLCB1bnNpZ25lZCBpbnQg
b3JkZXIsCiAKIAkJaWYgKGFsaWduZWQgJiYKIAkJICAgIGZvbGlvX3Rlc3RfcG1kX21hcHBh
YmxlKHBhZ2VfZm9saW8ocGZuX3RvX3BhZ2UocGZuKSkpKSB7Ci0JCQl2bV9mYXVsdF90IHJl
dDsKLQogCQkJcGZuICY9IFBNRF9NQVNLID4+IFBBR0VfU0hJRlQ7CiAKLQkJCS8qIFVubGlr
ZSBQVEVzIHdoaWNoIGFyZSBhdXRvbWF0aWNhbGx5IHVwZ3JhZGVkIHRvCisJCQkvKgorCQkJ
ICogVW5saWtlIFBURXMgd2hpY2ggYXJlIGF1dG9tYXRpY2FsbHkgdXBncmFkZWQgdG8KIAkJ
CSAqIHdyaXRlYWJsZSBlbnRyaWVzLCB0aGUgUE1EIHVwZ3JhZGVzIGdvIHRocm91Z2gKIAkJ
CSAqIC5odWdlX2ZhdWx0KCkuIE1ha2Ugc3VyZSB3ZSBwYXNzIHRoZSAid3JpdGUiIGluZm8K
IAkJCSAqIGFsb25nIGluIHRoYXQgY2FzZS4KLQkJCSAqIFRoaXMgYWxzbyBtZWFucyB3ZSBo
YXZlIHRvIHJlY29yZCB0aGUgd3JpdGUgZmF1bHQKLQkJCSAqIGhlcmUsIGluc3RlYWQgb2Yg
aW4gLnBmbl9ta3dyaXRlKCkuCiAJCQkgKi8KLQkJCXJldCA9IHZtZl9pbnNlcnRfcGZuX3Bt
ZCh2bWYsIHBmbiwKLQkJCQkJCSB2bWYtPmZsYWdzICYgRkFVTFRfRkxBR19XUklURSk7Ci0J
CQlpZiAocmV0ID09IFZNX0ZBVUxUX05PUEFHRSAmJiAodm1mLT5mbGFncyAmIEZBVUxUX0ZM
QUdfV1JJVEUpKQotCQkJCWRybV9nZW1fc2htZW1fcmVjb3JkX21rd3JpdGUodm1mKTsKLQot
CQkJcmV0dXJuIHJldDsKKwkJCXJldHVybiB2bWZfaW5zZXJ0X3Bmbl9wbWQodm1mLCBwZm4s
CisJCQkJCQkgIHZtZi0+ZmxhZ3MgJiBGQVVMVF9GTEFHX1dSSVRFKTsKIAkJfQogI2VuZGlm
CiAJfQpAQCAtNjM1LDggKzYxMywxNSBAQCBzdGF0aWMgdm1fZmF1bHRfdCBkcm1fZ2VtX3No
bWVtX2FueV9mYXVsdChzdHJ1Y3Qgdm1fZmF1bHQgKnZtZiwgdW5zaWduZWQgaW50IG9yZAog
CXBmbiA9IHBhZ2VfdG9fcGZuKHBhZ2UpOwogCiAJcmV0ID0gdHJ5X2luc2VydF9wZm4odm1m
LCBvcmRlciwgcGZuKTsKLQlpZiAocmV0ID09IFZNX0ZBVUxUX05PUEFHRSkKKwlpZiAocmV0
ID09IFZNX0ZBVUxUX05PUEFHRSkgewogCQlmb2xpb19tYXJrX2FjY2Vzc2VkKGZvbGlvKTsK
KwkJLyoKKwkJICogQWx3YXlzIHJlY29yZCB3cml0ZSBhY2Nlc3MgdG8gdGhlIGJ1ZmZlci4g
VGhlIG5hdHVyYWwKKwkJICogcGxhY2Ugd291bGQgYmUgcGZuX21rd3JpdGUsIGJ1dCB0aGlz
IGJyZWFrcyBLVk0uCisJCSAqLworCQlmaWxlX3VwZGF0ZV90aW1lKHZtYS0+dm1fZmlsZSk7
CisJCWZvbGlvX21hcmtfZGlydHkoZm9saW8pOworCX0KIAogb3V0OgogCWRtYV9yZXN2X3Vu
bG9jayhvYmotPnJlc3YpOwpAQCAtNjgzLDEyICs2NjgsNiBAQCBzdGF0aWMgdm9pZCBkcm1f
Z2VtX3NobWVtX3ZtX2Nsb3NlKHN0cnVjdCB2bV9hcmVhX3N0cnVjdCAqdm1hKQogCWRybV9n
ZW1fdm1fY2xvc2Uodm1hKTsKIH0KIAotc3RhdGljIHZtX2ZhdWx0X3QgZHJtX2dlbV9zaG1l
bV9wZm5fbWt3cml0ZShzdHJ1Y3Qgdm1fZmF1bHQgKnZtZikKLXsKLQlkcm1fZ2VtX3NobWVt
X3JlY29yZF9ta3dyaXRlKHZtZik7Ci0JcmV0dXJuIDA7Ci19Ci0KIGNvbnN0IHN0cnVjdCB2
bV9vcGVyYXRpb25zX3N0cnVjdCBkcm1fZ2VtX3NobWVtX3ZtX29wcyA9IHsKIAkuZmF1bHQg
PSBkcm1fZ2VtX3NobWVtX2ZhdWx0LAogI2lmZGVmIENPTkZJR19BUkNIX1NVUFBPUlRTX1BN
RF9QRk5NQVAKQEAgLTY5Niw3ICs2NzUsNiBAQCBjb25zdCBzdHJ1Y3Qgdm1fb3BlcmF0aW9u
c19zdHJ1Y3QgZHJtX2dlbV9zaG1lbV92bV9vcHMgPSB7CiAjZW5kaWYKIAkub3BlbiA9IGRy
bV9nZW1fc2htZW1fdm1fb3BlbiwKIAkuY2xvc2UgPSBkcm1fZ2VtX3NobWVtX3ZtX2Nsb3Nl
LAotCS5wZm5fbWt3cml0ZSA9IGRybV9nZW1fc2htZW1fcGZuX21rd3JpdGUsCiB9OwogRVhQ
T1JUX1NZTUJPTF9HUEwoZHJtX2dlbV9zaG1lbV92bV9vcHMpOwogCi0tIAoyLjU0LjAKCg==


--------------qEORVyYFqwCDMYi1Vb0xhvqj--

