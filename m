Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88654E78D46
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 08:46:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEA3F6B0005; Mon,  9 Feb 2026 03:46:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D980D6B0088; Mon,  9 Feb 2026 03:46:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C79D06B0089; Mon,  9 Feb 2026 03:46:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B22026B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 03:46:13 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7836F160730
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 08:46:13 +0000 (UTC)
X-FDA: 84424286226.10.AB83A4F
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0EC7140003
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 08:46:10 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LSr3Lv1l;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=HpvaYgXU;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LSr3Lv1l;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=HpvaYgXU;
	spf=pass (imf27.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770626771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C4Dh2g8phpgTAsceVHfYSE+zykMKbjUDDKJ+JPFDnrc=;
	b=ix//99n9on2tRHRmmjLURDEU4KoJaTAoex8neI3syMgt4J9jCdeugQrI68HWz7lDCDlJDD
	VKUEOMhKgxu1rMo6cSMpRRIWAz6JltgBUn6RHqXEvcn6Bxl52RVv8lPW8z8ILVVqc65LIm
	V4jf1V2m7Ea+TglyJ0WsqQ9lseJ5dfc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LSr3Lv1l;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=HpvaYgXU;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LSr3Lv1l;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=HpvaYgXU;
	spf=pass (imf27.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770626771; a=rsa-sha256;
	cv=none;
	b=J1W06YfDY8jdugGRBBU8hbI4SAWgA0t7qisTEaE7aEzuXa9PezbU+71Cg5oWb1CJWlUZwC
	bRRw+6JAINqiOTw2DlZUbsVbSEIkEOfa2qTNkodTABqHMXSB/e7wgWKGkcCINszQ6rkF2u
	W8ralJ0Jq1057tt1DW5uPi2GypJF+vI=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6DDC13E6CB;
	Mon,  9 Feb 2026 08:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770626769; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=C4Dh2g8phpgTAsceVHfYSE+zykMKbjUDDKJ+JPFDnrc=;
	b=LSr3Lv1lurFLQxSX47vqFqSKG9JPmTyDSaimgtv2ei7AJMTuC//aOPyfAHBJdtCDEILfKn
	0Y5Cz1Ln+7kjMxaP+bJ7/IwXMp0nQFT0mHvCyyaGHT2wO7SqFuSnQFiH5nmRO+H/BftA4R
	YTZdFYgd6Agchg4k57yQC4NhUimraQc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770626769;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=C4Dh2g8phpgTAsceVHfYSE+zykMKbjUDDKJ+JPFDnrc=;
	b=HpvaYgXUnQ/NVkgqCiqAPFfHqWUY22deIlVTZG36YbgZENej4DaxChxCDMTGzDMpnsnCx5
	y8CimYXDvqyaLECQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770626769; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=C4Dh2g8phpgTAsceVHfYSE+zykMKbjUDDKJ+JPFDnrc=;
	b=LSr3Lv1lurFLQxSX47vqFqSKG9JPmTyDSaimgtv2ei7AJMTuC//aOPyfAHBJdtCDEILfKn
	0Y5Cz1Ln+7kjMxaP+bJ7/IwXMp0nQFT0mHvCyyaGHT2wO7SqFuSnQFiH5nmRO+H/BftA4R
	YTZdFYgd6Agchg4k57yQC4NhUimraQc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770626769;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=C4Dh2g8phpgTAsceVHfYSE+zykMKbjUDDKJ+JPFDnrc=;
	b=HpvaYgXUnQ/NVkgqCiqAPFfHqWUY22deIlVTZG36YbgZENej4DaxChxCDMTGzDMpnsnCx5
	y8CimYXDvqyaLECQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 18F223EA63;
	Mon,  9 Feb 2026 08:46:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id J2blBNGeiWkxRAAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Mon, 09 Feb 2026 08:46:09 +0000
Message-ID: <1a5c21d2-d552-4dc0-847d-42077fed6bda@suse.de>
Date: Mon, 9 Feb 2026 09:46:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] drm/gem-shmem: Map pages in mmap fault handler
To: Matthew Wilcox <willy@infradead.org>
Cc: boris.brezillon@collabora.com, loic.molinari@collabora.com,
 frank.binns@imgtec.com, matt.coster@imgtec.com,
 maarten.lankhorst@linux.intel.com, mripard@kernel.org, airlied@gmail.com,
 simona@ffwll.ch, dri-devel@lists.freedesktop.org, linux-mm@kvack.org
References: <20260204114341.195143-1-tzimmermann@suse.de>
 <20260204114341.195143-3-tzimmermann@suse.de>
 <aYNt5m8rffUYK1al@casper.infradead.org>
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
In-Reply-To: <aYNt5m8rffUYK1al@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Queue-Id: 0EC7140003
X-Rspamd-Server: rspam07
X-Stat-Signature: xgdakhdw7dui31kq5qu7p9x9ikkc74cy
X-HE-Tag: 1770626770-353448
X-HE-Meta: U2FsdGVkX1943Zyo7ZFGCqeLRgwcC8jxspRpsd9e08o5stVU6em69u/E10rcUFkfXHUmw8331d68SuGNDrWQdhx+ylRd6EJXl8EQ6XJMI+1/OBIBp3SeU5VT009rbCWXyfCbbw3XMVQCpuDteSfY0fbmQQJ+DzSISR+IB6OVYvsVoi4PlWsI4Uv3dYvxtpauOa6SUgEJhk626Pwy2ILpr1xsNwpwCjDNP2Guqb2Cy/2dK6Tffjv4ZUHPNq+1I5MeawbcT1ieHYIR/D7Ok3M3GX8B77DvARU6FnlSHdZEVZG46Wqvu42D5TNlWpW9KW+VLv3KTUuRQtHSdcs3uen5XPqvCiCG8xXzHVCFXD21J08tvbe+GnhLwXvmKEbKiDYJJOKzKnqFV8qQeje0rebHXs4l5u20ZyYhBBeQxtM0PT0kEUHgNTJnQmUrNgs2bNpmmWAL/XqAJxf6/iyLT0FA4cnvFzDtxitmLabIF5UKov6IalFrHP0zeg2W1C2N8CYAnn6jNSvhbOpW42sYwr7dDq8FYLj4KF1zoA3sS+W1gAxdKINLqHHfQdDVJF1Q0WxvfOEfcopKti6MhEFgABedkFgPeMhpgO8wJ1RtQiVMpDgypmb5YTyhh428e4/a8ip/cZAR3Ya/hJ39OxX1p/NkKJDpjGVxsake+W9vjx/rLFr/2zoZ38N7NJMefQoyMB6xGOLdl8S+qK99ZM9bFXFLzQi2AUIcr93t3sLO5QgOSgxibHa6WUo93auWQH66Gb+xk13MbdzuzPDyGUgYRPO09PqKRN8NVs0dmQkdi1dKA5hLN0rBInns37dXaK47eIFHHD14ZA0o6YMs77RkPQvLyZgxt1o5xs/kjUMFV3/dLzLdFjyZwHfT212cLzuTGCKbrSEWWLc2GYUA9xWe1K+SXPkHYsk2uHTfW165xDM8HN4NQEE3qPZJQ8tkP3ngID/W051qZc1qUvi8x0Cd1X+
 t/9xlIUa
 1hxXV7drbYxi9AI/ELQNoJUEg2hco3WR4WTTd13omLWGf/w8dwyc3Kbh9Rgv/rhKnezZbOBwT5AjGTcdwtUJlhdlcubqFY7u8evnHVAa9S6gOb4FJkJc8/0azSWyF5UHBWn59fzuGKgbV1WUbw9IadZlagVvknMYYbJluIA9kDHGotHN1rq6FpQ2C8FQFcbAZDg3KvMrCgs0OB0F6DvneZx18UTiOoCgDwgqhkNsZmsqR65ktd9PDs5HA7PXxUbS9Dx09i3/fLsBm0FbX5UdwaXH7xwAC3kkSpiDGfSYhht7ZS996/uJyjkvMKN1JwFliqcciWaRHlA5NwW4Xhsggk/FsXuhlzF9yJC/QNek0AwBsmBn2sjF16Dlf39q9VIhD21XbexPBkxrlNnY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

I came across commit 8b93d1d7dbd5 ("drm/shmem-helper: Switch to 
vmf_insert_pfn") from 2021, which makes it very clear the PFNMAP is 
strongly preferred over pages. I totally forgot about that change. The 
next iteration of this series will therefore not contain this patch.

Best regards
Thomas

Am 04.02.26 um 17:03 schrieb Matthew Wilcox:
> On Wed, Feb 04, 2026 at 12:39:30PM +0100, Thomas Zimmermann wrote:
>> +	ret = drm_gem_shmem_try_map_pmd(vmf, vmf->address, page);
>> +	if (ret != VM_FAULT_NOPAGE) {
>> +		struct folio *folio = page_folio(page);
>> +
>> +		get_page(page);
> folio_get(folio);
>
>> -	pfn = page_to_pfn(pages[page_offset]);
>> -	ret = vmf_insert_pfn(vma, vmf->address, pfn);
>> +		folio_lock(folio);
>> +
>> +		vmf->page = page;
>> +		ret = VM_FAULT_LOCKED;
>> +	}
>>   
>> - out:
>> +out:
>>   	dma_resv_unlock(shmem->base.resv);
>>   
>>   	return ret;
>> @@ -689,7 +698,7 @@ int drm_gem_shmem_mmap(struct drm_gem_shmem_object *shmem, struct vm_area_struct
>>   	if (ret)
>>   		return ret;
>>   
>> -	vm_flags_set(vma, VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
>> +	vm_flags_mod(vma, VM_DONTEXPAND | VM_DONTDUMP, VM_PFNMAP);
> Do you need to explicitly clear VM_PFNMAP here?  I'm not familiar with
> the DRM stack; maybe that's set for you higher in the stack.
>

-- 
--
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Frankenstr. 146, 90461 Nürnberg, Germany, www.suse.com
GF: Jochen Jaser, Andrew McDonald, Werner Knoblich, (HRB 36809, AG Nürnberg)



