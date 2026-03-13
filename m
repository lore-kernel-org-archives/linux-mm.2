Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94636106FD9B
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 08:00:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0420F6B0088; Fri, 13 Mar 2026 04:00:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F20D66B0089; Fri, 13 Mar 2026 04:00:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF9726B008A; Fri, 13 Mar 2026 04:00:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CCBA56B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 04:00:41 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 59847BB7B4
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 08:00:41 +0000 (UTC)
X-FDA: 84540293082.16.4558AE0
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id EEEE0180002
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 08:00:38 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=CCxYtvVa;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+NQiFsmK;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=CCxYtvVa;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+NQiFsmK;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf16.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=tzimmermann@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773388839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VKtKkJNq3HnXxI8Cjc3OiSLdOJaFBmBtFTAxUnoa+nY=;
	b=jBG8AKygGPM5dgsu2lhR2lyksqlfxbU2WVbr1ShrV3uI5EJOVQuOZVivIVFzxSo3XDG6NZ
	UAx5W1fb9AjCehExO/mATMQolQs8Vm6HMcUYmUDhFc0MS7S6Ooxwj1VZNJVOMAtI/IViOG
	MDb0WhJoWGNeJ831Rq61AvRpMx1w13Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773388839; a=rsa-sha256;
	cv=none;
	b=dNSfOlqp+fOvSrbQjnk9JMGCqJUgPNt87YIBWupjkou/pXTSRrqNlV0zYJuLoMGc7ha9w2
	HsD1O5pyTdzZyUyuz4bmspwB9DGsNWUGawoqpof4k3bNEuh6zEI3FW3Ar+1jFzv8E2T29f
	wMya9145nb9bMxEtgwxWejOaFJ7/Ziw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=CCxYtvVa;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+NQiFsmK;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=CCxYtvVa;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+NQiFsmK;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf16.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=tzimmermann@suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 135B75C177;
	Fri, 13 Mar 2026 08:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773388837; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=VKtKkJNq3HnXxI8Cjc3OiSLdOJaFBmBtFTAxUnoa+nY=;
	b=CCxYtvVa+3JQkLOh7ByUmT7qTm3aMbeXiwJX2CORSQdVASPFycgxFV6/jJRnfDixtsTLeT
	NU4yqim6dMvbX5UijgnSIF04ti7FMeLK9x14vhxpaHi9cJv69knuG3VVo3vgF8wzPijNnc
	8n9c4ed3gT9g9feHfDAKWMZ7HuIYSA0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773388837;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=VKtKkJNq3HnXxI8Cjc3OiSLdOJaFBmBtFTAxUnoa+nY=;
	b=+NQiFsmKPLBel1iVXvd1GfseEkzpArZcGsHxD1e3hvMj5CCfF4SyOzXqebagB9ce/eAUDC
	SG4Z0L5ohxAmtXDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773388837; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=VKtKkJNq3HnXxI8Cjc3OiSLdOJaFBmBtFTAxUnoa+nY=;
	b=CCxYtvVa+3JQkLOh7ByUmT7qTm3aMbeXiwJX2CORSQdVASPFycgxFV6/jJRnfDixtsTLeT
	NU4yqim6dMvbX5UijgnSIF04ti7FMeLK9x14vhxpaHi9cJv69knuG3VVo3vgF8wzPijNnc
	8n9c4ed3gT9g9feHfDAKWMZ7HuIYSA0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773388837;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=VKtKkJNq3HnXxI8Cjc3OiSLdOJaFBmBtFTAxUnoa+nY=;
	b=+NQiFsmKPLBel1iVXvd1GfseEkzpArZcGsHxD1e3hvMj5CCfF4SyOzXqebagB9ce/eAUDC
	SG4Z0L5ohxAmtXDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B7ECD40402;
	Fri, 13 Mar 2026 08:00:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Uwx8KyTEs2lLJQAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Fri, 13 Mar 2026 08:00:36 +0000
Message-ID: <20a82a3c-80ed-4f9a-912b-088284c27b68@suse.de>
Date: Fri, 13 Mar 2026 09:00:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/6] drm/gem-shmem: Track folio accessed/dirty status
 in mmap
To: Biju Das <biju.das.jz@bp.renesas.com>,
 Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
Cc: "boris.brezillon@collabora.com" <boris.brezillon@collabora.com>,
 "loic.molinari@collabora.com" <loic.molinari@collabora.com>,
 "willy@infradead.org" <willy@infradead.org>,
 "frank.binns@imgtec.com" <frank.binns@imgtec.com>,
 "matt.coster@imgtec.com" <matt.coster@imgtec.com>,
 "maarten.lankhorst@linux.intel.com" <maarten.lankhorst@linux.intel.com>,
 "mripard@kernel.org" <mripard@kernel.org>,
 "airlied@gmail.com" <airlied@gmail.com>, "simona@ffwll.ch"
 <simona@ffwll.ch>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
References: <20260227114509.165572-1-tzimmermann@suse.de>
 <20260227114509.165572-6-tzimmermann@suse.de> <abL5rcYIaFFO3GW2@tom-desktop>
 <TY3PR01MB113460CA616D3576DA0C3FC698644A@TY3PR01MB11346.jpnprd01.prod.outlook.com>
 <TY3PR01MB113461ACB668738E1952EC8898645A@TY3PR01MB11346.jpnprd01.prod.outlook.com>
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
In-Reply-To: <TY3PR01MB113461ACB668738E1952EC8898645A@TY3PR01MB11346.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EEEE0180002
X-Stat-Signature: xy7pqdu7tqbhca5dr8zspa11utyhjdkd
X-Rspam-User: 
X-HE-Tag: 1773388838-345829
X-HE-Meta: U2FsdGVkX18p4pNqC6vcVKJYo9R/Vnvzmje9Imvkatk+58UQBpezysC/Oe22B0g9rYJoeP8O8rYB+KGIAVpNkgL7h4KyedGH6gN2CLdLknKlEDltvOupviqMEMlB9z4gs4+xjl7vlbGkxuU8x87AobewO9Mrxn4DqBWFThuoa9iUiFgN1orMsDvkENewFKCmJMEypZSYItyApZLXICWUCGNwmXRs5mMX029Hb9WasH5YGzJL7ZDH5aI7nOKVGmJBWrn9Ncnv1iEgPQhGfu44pOItl/oPV87nDMOhCmls+mTJ2nbQwHhSUKtQEMxvcNlu2NI0FR04bLJECPgJZHqixY9i10BpLzFshHu0YrOcnAXMWVWVTv6NsGXT3y0gglmpYQwtOeJH16uf/2skA6Uwx88v2SahT/WKRMRanr5ibdOg3P/59mK+bE4kfaABy4ccK2rRtFSbolCdLgEiKqRrIYgVvIxULFf8FLImMLkqxCTDS+blPyJzUoU5SzVBIY6/YQ7WNLx/Wz9j1dD9/hrKlFHh4tHNZ5E2Q/8aVw28t2gbvDBBfGhm0XGVy8XkDVWKSKiKo93NSLMq3NYxYZPBDuEDyUPljN6CPakpsKvgEwmcKvanY1JJCS4q+K2MfIlu+/Ko6ME1Rn2w+KUG+X2DPnJSUZl46m2m6pWbFoRJl1BT28nrpyKZthaiAFXx2pUax6XYNVPOzPJfkR3TANtwOxQGvGgeNuptmwJMKOm9IXc3/Asva0U7wgjHTxRHfbWWWjgJKnCkfry5+CDGNeCqj+BczO2c3y0q2HfNF9FhHDuuizy8zZnosfat4RKqQGEhYXNjD8hvlkfI74eTEEDfXPbrrxiSRedZIfqesWjwMyqifgrOtjpkO0iq5SJouvNmZlKIozyKEMcYnogih6rNmJhSH1iLuwkl7IzflKOhO+8VdK4B2DB9Z6C5oJcCLqOXqksIVVGW0N9zj86giWa
 OOsjuIzF
 F0ZBJo6RP3NgWwTqlU6IeRjvWBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi

Am 13.03.26 um 07:44 schrieb Biju Das:
>
>> -----Original Message-----
>> From: dri-devel <dri-devel-bounces@lists.freedesktop.org> On Behalf Of Biju Das
>> Sent: 12 March 2026 17:47
>> To: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>; Thomas Zimmermann <tzimmermann@suse.de>
>> Cc: boris.brezillon@collabora.com; loic.molinari@collabora.com; willy@infradead.org;
>> frank.binns@imgtec.com; matt.coster@imgtec.com; maarten.lankhorst@linux.intel.com; mripard@kernel.org;
>> airlied@gmail.com; simona@ffwll.ch; linux-mm@kvack.org; dri-devel@lists.freedesktop.org
>> Subject: RE: [PATCH v4 5/6] drm/gem-shmem: Track folio accessed/dirty status in mmap
>>
>> Hi Tommaso,
>>
>>> -----Original Message-----
>>> From: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
>>> Sent: 12 March 2026 17:37
>>> Subject: Re: [PATCH v4 5/6] drm/gem-shmem: Track folio accessed/dirty
>>> status in mmap
>>>
>>> Hi Thomas,
>>> Thanks for your patch.
>>>
>>> I'm working on DSI support for RZ/G3E from this morning rebasing on
>>> top of next-20260311 I'm seeing that weston hang on my side:
>>>
>>> Reverting this patch fix the issue.
>>> (git revert 28e3918179aa)
>>>
>>> I'm wondering if anyone encountered this issue?
>>> Thanks in advance.
>>
>> I am also seeing same issue on RZ/G3L with weston.
> Just add I am using mesa with panfrost(Mali-G31) on RZ/G3L.

I ran the tests with bochs.  I don't have panfrost hardware to test 
with, but nothing in the driver sticks out as problematic. Only the gem 
open/close logic looks a bit awkward. The mmap code appears to be identical.

>
> Disabling Mali-G31 renders weston desktop during boot.
>
> Looks like this patch is creating some hang in panfrost driver
> during weston launch.

Does either of you see any warnings in the kernel messages?


>
> Cheers,
[...]
> +	if (ret == VM_FAULT_NOPAGE)
> +		folio_mark_accessed(folio);
> +
[...]

[...]
> +	if (drm_WARN_ON(obj->dev, !shmem->pages || page_offset >= num_pages))
> +		return VM_FAULT_SIGBUS;
[...]
> +	file_update_time(vma->vm_file);
[...]
> +
> +	folio_mark_dirty(page_folio(shmem->pages[page_offset]));

Out-commenting either of these should work.  Could you please go through 
them one by one and test if out-commenting either makes a difference?

Best regards
Thomas

> +
> +	return 0;
> +}
> +
>   const struct vm_operations_struct drm_gem_shmem_vm_ops = {
>   	.fault = drm_gem_shmem_fault,
>   	.open = drm_gem_shmem_vm_open,
>   	.close = drm_gem_shmem_vm_close,
> +	.pfn_mkwrite = drm_gem_shmem_pfn_mkwrite,
>   };
>   EXPORT_SYMBOL_GPL(drm_gem_shmem_vm_ops);
>
> --
> 2.52.0
>
>

-- 
--
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Frankenstr. 146, 90461 Nürnberg, Germany, www.suse.com
GF: Jochen Jaser, Andrew McDonald, Werner Knoblich, (HRB 36809, AG Nürnberg)



