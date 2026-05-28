Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82606CD5BD1
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 07:20:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92AB46B0088; Thu, 28 May 2026 03:20:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DAF36B008C; Thu, 28 May 2026 03:20:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CA5D6B0092; Thu, 28 May 2026 03:20:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6E6136B0088
	for <linux-mm@kvack.org>; Thu, 28 May 2026 03:20:21 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 01388C16FD
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:20:20 +0000 (UTC)
X-FDA: 84815980242.24.205E80F
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id D529880010
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:20:18 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=QtaFnWQF;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=iHu8vGn4;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=QtaFnWQF;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=iHu8vGn4;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf02.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=tzimmermann@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779952818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5aGcI9PPptELztrSCxzrX/AUy6F2vWs30qm/fc1s9Tw=;
	b=QVgO57w8qlYp7oxpsnEGyOkq0vrHq2UeKMlrdn2fno61Abb9t2pv4XEvPQtAgMBZ5Ie/gr
	+L8jWL5EMihWwxtcaIMCBRzS9RAIvXnApEA7CK8xsfkVcuQW67gancOxyMkjdSUTiUzZ1y
	PU3TINoWZp9uoXkQ0bDJ4vFFMtVa56A=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=QtaFnWQF;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=iHu8vGn4;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=QtaFnWQF;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=iHu8vGn4;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf02.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=tzimmermann@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779952818; a=rsa-sha256;
	cv=none;
	b=TB/T+0RBf1dygJFGjoIEce3R3V9vVrxCYiqYzms47IbxNeKKD+jWCJ0Hr+/oklENGpH5NH
	dRDEZgjQKApY1PypS1plUuzumT/a8WxAfOR+Ww6soCrbP4VqQ0hdOam08rNZ0VzSENKcVT
	/G2zdgwI18h+Vz5rZoLlJVMk4MB6EJ8=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7F4C6672DF;
	Thu, 28 May 2026 07:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779952817; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5aGcI9PPptELztrSCxzrX/AUy6F2vWs30qm/fc1s9Tw=;
	b=QtaFnWQFawYVNkUmrRSO0WLEV6rZioksyVJhIgoJrX5A5WydoctYNUEJEKtfmUJW81VH2V
	UxLRzyAF+9YiS+eBCjKVQHdteLTyi9pg3snxLVFkehOVelVDMG4lMjVlh+6+A1uFo8nBz8
	emKa+JfrJcS5seeb2a3olpPMBzPw/QA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779952817;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5aGcI9PPptELztrSCxzrX/AUy6F2vWs30qm/fc1s9Tw=;
	b=iHu8vGn4Q8GAd1qGjX/u0e2E5GA/M/cNqeFQKJGbMU8ZYqB/uoWpYINqQ0MQu4mTVpLWu0
	E9EkdtulJw3/5qBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779952817; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5aGcI9PPptELztrSCxzrX/AUy6F2vWs30qm/fc1s9Tw=;
	b=QtaFnWQFawYVNkUmrRSO0WLEV6rZioksyVJhIgoJrX5A5WydoctYNUEJEKtfmUJW81VH2V
	UxLRzyAF+9YiS+eBCjKVQHdteLTyi9pg3snxLVFkehOVelVDMG4lMjVlh+6+A1uFo8nBz8
	emKa+JfrJcS5seeb2a3olpPMBzPw/QA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779952817;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5aGcI9PPptELztrSCxzrX/AUy6F2vWs30qm/fc1s9Tw=;
	b=iHu8vGn4Q8GAd1qGjX/u0e2E5GA/M/cNqeFQKJGbMU8ZYqB/uoWpYINqQ0MQu4mTVpLWu0
	E9EkdtulJw3/5qBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 302F45AC77;
	Thu, 28 May 2026 07:20:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uR2LCrHsF2qMRQAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Thu, 28 May 2026 07:20:17 +0000
Message-ID: <4a00d72c-9b87-4511-9da0-bcb40fae4d74@suse.de>
Date: Thu, 28 May 2026 09:20:16 +0200
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
X-Stat-Signature: sszkgykx3ws6b7bru7n48x5qwc5ryjgf
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D529880010
X-Rspam-User: 
X-HE-Tag: 1779952818-506449
X-HE-Meta: U2FsdGVkX1/qNKavFpKXyaB2g6/xngplBTn9hIX32nwqa8qMQ4imN2XEM42eK5d7YMoSppvyLDgGHrKcfWK+dEj54vmKONI+1IVOdJT6ANTqSYBg1Ocv2FSysKATJ8VnJ0kbauQNKgqN98JxPA4Ybj5RHQ/XHSlFH6jQ8CRHLg7vHYpuZlaGkQnMcBzeBTyhxxnDqW9UqY5BxY3uw02OiZevILuqOQUMGz2kVgkyeAOb2uvZIgkqV95hcwRhG3DEcn6z41DMaGtA+ANnIJ1GgV3MeONOqWvzF8tZGutiF/0AGPsdQV1Ope6S1bklr4oE7viqdE27qdw86hzAH6s1bUXV31l8sBWhsQLZYOYESuUPez/b4qC8/EJ7JycRgTiSJNJ8v0MA+zAj2LMHj7Eudz3SSTtAerwoW789OonmwtfSQwlvhoyKM5F4EWfuPp8OLOW/BLAYga7QTi/l1uE5H0ACZ1PG37aG6TKzDaPBJI/OoeDHaYyi6mj5bT+ksHSNCTZOdUmZAwvx1TGnQ4qmHj51p0BkL7uvkKVX9LNQ9dGjQ8aGni4VPkVbQXtoD3YgjlietMsWvHejDcz8RWqVyRqZdLINRtAtZIzKtKX1wV9Qi8VfeEaXjrbz3pHsMvtxnvATvjLglo85yFir/rfcfZcr9O3+RPpSj15TwTy6mdfCsbIMIb2pY7S6bhV+qwq1bzsMvRbFNLXDtez/t9FfqfA6CjpTH8NUFdRKBn8zSNr5m1RxtgMVP1I4fS27Qz92VBNa0YwNmyJue9LgG+LGMbwvRyaS9D9yIWZDk+37teU/0A9aJik/8uvaI9zN3vGIadK2QUtH15Cy/S96SsXGmBPjcUZr2p2VS7I7a1tMbUYinpHNiD0DkYy9FOT1wUhu3KLekto8cxoOZg0BzLomJPdrkF5Z45nVNETR3dm4UcF6dSfWW+PgL8YCD/VsyomsFxDdCsmBoslpE8z3cvK
 fA0FHHuC
 lOiRHrnRvQvgjuPorWsb4OBtodr/LxinjTq48OK5vKhd/O+VuunmLURN3HTVORiijhmvPPbeA0nv+yLnnNDyo0CKvb4OZiIiwlBpfamGGqFRFd529XPz8JJkMoD3Ex+qbi9Xx8spAEWG77cedDUCEEEUo0TPexPvmF/fFooqEcnRExd7LCpkZfJwAjeqMEUPViePQ+VlNOq3E1O8u7LvF2ZqZkJHUPdrvb8dPx1vwc7qB34YEmyo3bIaNZFAfqT2IHC74y4tc7RrOHbVgeKsm7GL3L2Kp+Is6TtPNv4VO4r07ismhwYVcpfwm1lurqOYsSd0n2wd5uQ1MIab3kOBZ5SEkVkdvLZG3+Hb2Zn8+/ZVBBuuSwpDjGNPEkAkwrZP7zAXxyP0PFRhL8No=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi

Am 27.05.26 um 12:18 schrieb Boris Brezillon:
[...]
>> -			return ret;
>> +			return vmf_insert_pfn_pmd(vmf, pfn,
>> +						  vmf->flags & FAULT_FLAG_WRITE);
> I believe we can go back to
>
> 			return vmf_insert_pfn_pmd(vmf, pfn, false);
>
> if the mappings are no longer adjusted to catch write accesses.

If we don't install it as writable now, won't the kernel not split it up 
into 4KiB pages when the actual write happens? If so, this might impact 
performance negatively.

Best regards
Thomas


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



