Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6373E81BD3
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 14:46:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B74D6B0089; Mon,  9 Feb 2026 09:46:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 361416B00B6; Mon,  9 Feb 2026 09:46:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23D166B00B8; Mon,  9 Feb 2026 09:46:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1184D6B0089
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:46:27 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BB17C160198
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:46:26 +0000 (UTC)
X-FDA: 84425193972.16.CDDF1E5
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id 53CA140004
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:46:24 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xA4TTeHC;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=z7p2bqVa;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xA4TTeHC;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=z7p2bqVa;
	spf=pass (imf11.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770648384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DSGfxZ/EEIX/zXxMZVu8MV7eH8W1DRl9z/K8tChKiW0=;
	b=VA6zUeaF/3v2m+362qcrO5vPl2psys7amqHMxNWhdR4SrHSme9UVPUMjuMKMbyn6FZTe5R
	malE8z120Q9kLeLAbwC+tKdVSKwGyeL2p/RKFVd++vJhaXrqVNp5OJEapbrUx5pRAUP28Z
	8p53YB61SUXLm76idBzm5EWl5jvn5Dw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xA4TTeHC;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=z7p2bqVa;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xA4TTeHC;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=z7p2bqVa;
	spf=pass (imf11.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770648384; a=rsa-sha256;
	cv=none;
	b=pis/QSIchDarUPbJzHGYzV9IPGJpriF/miZAe4vJrbdoptI0IBZ8r+tXysITqBVlhJ28gj
	Jp9TFENrXqIQOg+zrH7aQK3QDStJRhHGy6FYONpN9d+1RGSuFDIEjr+6zs7fAWmNkXzuu1
	b4e137syqrRsmBBGjN560FmiXpaTBUI=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8272F3E6E7;
	Mon,  9 Feb 2026 14:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770648382; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=DSGfxZ/EEIX/zXxMZVu8MV7eH8W1DRl9z/K8tChKiW0=;
	b=xA4TTeHCJ7TlIXSdLLZb/zW5GhyL4smc7HDQFRml8dnvNKnPX14PpRB//l7k59kRJ1Gvk4
	VFjBy4pPvHX7E5bXETbCIgouklLBF9WgVLateMdm7Jz7j5afBGM4Rt+0woD+oyA2Zz4pW/
	jOqrHUTAe67z6h0ckm9AftDIDIlQ2x0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770648382;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=DSGfxZ/EEIX/zXxMZVu8MV7eH8W1DRl9z/K8tChKiW0=;
	b=z7p2bqVa7t2sf6anYYtLo54Dtftdw4dIX8baa1BvBNssCLhkwNzt5JXR8gJju7MtYlhLXf
	Nw6XobUKsjEoNWCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770648382; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=DSGfxZ/EEIX/zXxMZVu8MV7eH8W1DRl9z/K8tChKiW0=;
	b=xA4TTeHCJ7TlIXSdLLZb/zW5GhyL4smc7HDQFRml8dnvNKnPX14PpRB//l7k59kRJ1Gvk4
	VFjBy4pPvHX7E5bXETbCIgouklLBF9WgVLateMdm7Jz7j5afBGM4Rt+0woD+oyA2Zz4pW/
	jOqrHUTAe67z6h0ckm9AftDIDIlQ2x0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770648382;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=DSGfxZ/EEIX/zXxMZVu8MV7eH8W1DRl9z/K8tChKiW0=;
	b=z7p2bqVa7t2sf6anYYtLo54Dtftdw4dIX8baa1BvBNssCLhkwNzt5JXR8gJju7MtYlhLXf
	Nw6XobUKsjEoNWCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 118413EA63;
	Mon,  9 Feb 2026 14:46:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZR5mAj7ziWkUQQAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Mon, 09 Feb 2026 14:46:22 +0000
Message-ID: <0d00a0f6-d0e4-41db-b48b-77157cd2e968@suse.de>
Date: Mon, 9 Feb 2026 15:46:21 +0100
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
In-Reply-To: <20260209152340.16f9b30a@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 53CA140004
X-Stat-Signature: un3dic9cx6qsuqa9yznwu9uray4ax37n
X-Rspam-User: 
X-HE-Tag: 1770648384-156164
X-HE-Meta: U2FsdGVkX1/nWRHKflirf2USXvY0luPDTwdDwK9X1gugu5nWaJfZPJKicEr26RlkcOLE3R8g9M1rjF5wh7BeE0fTgdCvKna+q4IP5vJaavZbLTMMYwlVajSpNOPBM6okHVkWYUegMNy3iTqMA0+u2qhjEG2HAuRAzkGq4CtXGt705CoCmuYx7e165KyqLPj6pwnl1IhsAc0gHz1QDAWoIqTRjYTdbLrw8TYZugaJfF65SSFr41gQwwGMkv7sSDs+kzhUyyscai5pvZUSmhsUf77m697Jr6AJD0/Pckjmw4KL0zW+sX8GrnBXxAc015fzqmAaspPUAXZnm6tmmOMxO+12+vEfmtlSpv3Rukkq21D2lX1c+J7IoDd50drWm2Li13qGXN3PsRZQO+iK/rXjKgdbEWrduh/0LVyvX01hqXbNJahOvXVC5z8c+Wt7Wbkop6OxjoqcwN4W/4lyqaiH5ElOu+ib0DFHxxgaloBCpFXuRfABz0Kq7UuRkoUzhkiZuVORDE+dqTRKt+GopYdBV0qzDDK8OeTXhrp/bb5eQc/AirMZ6lU1cl5iVRX6GYOQsNMDITWcxrMoEabHUf0pDm3obCE+LmVct0/6nCCfPITeeCFX5bWbCRIYGLBkpLQtCHH3obCipASbsGkoKsBPiR8XSAX5thrJXS+jV/FJjzcrteJIgKaVUbUmARezQv6rFO8lm1WuOBEnk2X7IYe7PYPRXnzzQmcaWnrLwbWmHdHhia7PYNxrXpydix31db0I4Vyfgv3CjNVofFGsmmwkz0cw+fm8N7SSj6uvZo8CaC87a932HFty3uL03chcDyfJ5x+aNXp3BQerO7EH5Z2PP+i1L0bxBKiTk/UHGZgcNcaZhNQCG9JoQHkxq/JMbL4lML7qhUWkkYLxGZzn46ctoeThuUxGeMGiICQ7BLx2MUeEZbTxP5qWORXMNXFzOCpDrBLPkm8iZiFiOUSTM4g
 S67WQCuq
 mJddJSZenlQ+geYMR2lm46wbIgOxrbpauQppfNAe2io4Ju5I0j+PW5neKdHniLZRETFbDS0vctCMQQKAhUTWILbhQTFbSBPt7E2pmRdVXjdBmoByihqes0o53MtCQ+O2z4p1HQGHaUBeNJEVpkeVumuJXAqVK7APIk+yRDoo3dbWJqfJX1t7kx5vDhf8zbvmFsmtpbeZu4xD41hvwi8AGliGzIjNffAme5Z2w6dooV5yM1jDo6oGYDxDhj2vB1XiBfevoVotHkQBrxsqUk2a1gOc3j59aM0KKUeoFqMxHPtV56rjVvpWtVNgxYSFNgPzCyRLWL55uBd66/SY2xIwDBxPGIIbE5qdXF3JYEY+H5QPB/xOd5bpRKDehFuzig3fvILeSS9Pihs1WSf1aTybb+8Kiim9kf6dFs0Y6UklSKqO7SwGFiNzZ2kWZNML//q5Mi+RrUHwOIMmcgg4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Boris,

thanks for reviewing the series.

Am 09.02.26 um 15:23 schrieb Boris Brezillon:
> On Mon,  9 Feb 2026 14:27:14 +0100
> Thomas Zimmermann <tzimmermann@suse.de> wrote:
>
>> Invoke folio_mark_accessed() in mmap page faults to add the folio to
>> the memory manager's LRU list. Userspace invokes mmap to get the memory
>> for software rendering. Compositors do the same when creating the final
>> on-screen image, so keeping the pages in LRU makes sense. Avoids paging
>> out graphics buffers when under memory pressure.
>>
>> In pfn_mkwrite, further invoke the folio_mark_dirty() to add the folio
>> for writeback should the underlying file be paged out from system memory.
>> This rarely happens in practice, yet it would corrupt the buffer content.
>>
>> This has little effect on a system's hardware-accelerated rendering, which
>> only mmaps for an initial setup of textures, meshes, shaders, etc.
>>
>> v3:
>> - rewrite for VM_PFNMAP
>> v2:
>> - adapt to changes in drm_gem_shmem_try_mmap_pmd()
>>
>> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
>> Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
>> ---
>>   drivers/gpu/drm/drm_gem_shmem_helper.c | 20 ++++++++++++++++++++
>>   1 file changed, 20 insertions(+)
>>
>> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
>> index c3a054899ba3..0c86ad40a049 100644
>> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
>> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
>> @@ -598,6 +598,9 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
>>   	if (ret != VM_FAULT_NOPAGE)
>>   		ret = vmf_insert_pfn(vma, vmf->address, pfn);
>>   
>> +	if (likely(!(ret & VM_FAULT_ERROR)))
> Can't we just go
>
> 	if (ret == VM_FAULT_NOPAGE)
>
> here?

After reviewing the code in vmf_insert_pfn, I think so. All we'll see is 
_OOM and _SIGBUS; or _NOPAGE on success.  I'll change it then.


>
>> +		folio_mark_accessed(folio);
>> +
>>   out:
>>   	dma_resv_unlock(obj->resv);
>>   
>> @@ -638,10 +641,27 @@ static void drm_gem_shmem_vm_close(struct vm_area_struct *vma)
>>   	drm_gem_vm_close(vma);
>>   }
>>   
>> +static vm_fault_t drm_gem_shmem_pfn_mkwrite(struct vm_fault *vmf)
>> +{
>> +	struct vm_area_struct *vma = vmf->vma;
>> +	struct drm_gem_object *obj = vma->vm_private_data;
>> +	struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
>> +	pgoff_t page_offset = vmf->pgoff - vma->vm_pgoff; /* page offset within VMA */
>> +	struct page *page = shmem->pages[page_offset];
> Should we have a
>
> 	if (WARN_ON(!shmem->pages ||
> 		    page_offset <= (obj->size >> PAGE_SHIFT)))
> 		return VM_FAULT_SIGBUS;
>
>
> ?

I left it out because it doesn't seem necessary.  In the fault handler 
in drm_gem_shmem_fault(), I can see that we could get an OOB access. But 
we only call pfn_mkwrite() after going through _fault() first. I don't 
see a way of getting here unless we've already tested for the page in 
_fault().

Best regards
Thomas

>
>> +	struct folio *folio = page_folio(page);
>> +
>> +	file_update_time(vma->vm_file);
>> +
>> +	folio_mark_dirty(folio);
>> +
>> +	return 0;
>> +}
>> +
>>   const struct vm_operations_struct drm_gem_shmem_vm_ops = {
>>   	.fault = drm_gem_shmem_fault,
>>   	.open = drm_gem_shmem_vm_open,
>>   	.close = drm_gem_shmem_vm_close,
>> +	.pfn_mkwrite = drm_gem_shmem_pfn_mkwrite,
>>   };
>>   EXPORT_SYMBOL_GPL(drm_gem_shmem_vm_ops);
>>   

-- 
--
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Frankenstr. 146, 90461 Nürnberg, Germany, www.suse.com
GF: Jochen Jaser, Andrew McDonald, Werner Knoblich, (HRB 36809, AG Nürnberg)



