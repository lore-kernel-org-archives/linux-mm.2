Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84D42CD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 09:22:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C06776B008A; Thu, 28 May 2026 05:22:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDE456B008C; Thu, 28 May 2026 05:22:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACCDF6B0092; Thu, 28 May 2026 05:22:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9F14A6B008A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 05:22:53 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 55E061C1F92
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:22:53 +0000 (UTC)
X-FDA: 84816289026.18.6A17985
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1C56F100005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:22:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xUhDNAX8;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=lKVuW3ID;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xUhDNAX8;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=lKVuW3ID;
	spf=pass (imf05.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779960171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kJro8mbHImDhirojnVpmZPJsV5TTMdlc3fEkULtPDsM=;
	b=vN/lbfDQ6olyvNLe1wHzkPLMxRPGuLs6vo+gey+XCBIz0VFyt0Z+UcGSQQ5GooTHHJotSJ
	WJFPpHU/eWa8ah2FaD8SMv/mw9hXMXVc07XTcTVqUpMCnv9TW0cuo6Za34tfxKs2BiC3wL
	TaICpAagTSroLnZLlEgyzjHKYG4nZ6Y=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xUhDNAX8;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=lKVuW3ID;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xUhDNAX8;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=lKVuW3ID;
	spf=pass (imf05.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779960171; a=rsa-sha256;
	cv=none;
	b=eEko941B6gBUagRXX2rtPdyevyvylZSX2DeWe91GHaWiohFVcJ6pWHz0eYy0+glghhijHs
	9k49hilodop84rS8VP4DaVv5/19c6/tqAfxmUaKoN6sl1/A6+7zN6+ytQkKeAdaoL0lnhl
	ZV0PofdmvqQ0d9v1jHjlPrsemwe8s84=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 84D836739F;
	Thu, 28 May 2026 09:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779960167; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=kJro8mbHImDhirojnVpmZPJsV5TTMdlc3fEkULtPDsM=;
	b=xUhDNAX8w97FSnq17BOXT9i2lAP7znijGcgBEPeHXx7BejVABlgJpkXEVlSLlcPQrtG+LP
	zAr9l0nLlxyNH0ja2BtzXC4u3oYNvX096ZlrFcyTfgJdFxEU7N+OFa9VkwFvR/dT3x49P8
	CWKFYMIi87R/tPq4LWC3YASMas4MxWo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779960167;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=kJro8mbHImDhirojnVpmZPJsV5TTMdlc3fEkULtPDsM=;
	b=lKVuW3IDYL1T69TMVRcdGcqUA4eypiMCi40NTGMUdgsQhai7qrGcAQEh3NvE9OpR9X5j48
	Cq2WlSNK8L5Y/HCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779960167; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=kJro8mbHImDhirojnVpmZPJsV5TTMdlc3fEkULtPDsM=;
	b=xUhDNAX8w97FSnq17BOXT9i2lAP7znijGcgBEPeHXx7BejVABlgJpkXEVlSLlcPQrtG+LP
	zAr9l0nLlxyNH0ja2BtzXC4u3oYNvX096ZlrFcyTfgJdFxEU7N+OFa9VkwFvR/dT3x49P8
	CWKFYMIi87R/tPq4LWC3YASMas4MxWo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779960167;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=kJro8mbHImDhirojnVpmZPJsV5TTMdlc3fEkULtPDsM=;
	b=lKVuW3IDYL1T69TMVRcdGcqUA4eypiMCi40NTGMUdgsQhai7qrGcAQEh3NvE9OpR9X5j48
	Cq2WlSNK8L5Y/HCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 310675ACF1;
	Thu, 28 May 2026 09:22:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bx0bCmcJGGpTQgAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Thu, 28 May 2026 09:22:47 +0000
Message-ID: <5d34e0b8-1b3d-4a7e-bd5a-f0eceee4a83b@suse.de>
Date: Thu, 28 May 2026 11:22:46 +0200
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
 <4a00d72c-9b87-4511-9da0-bcb40fae4d74@suse.de>
 <20260528111140.2d9535b7@fedora>
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
In-Reply-To: <20260528111140.2d9535b7@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1C56F100005
X-Stat-Signature: w67rixg9werrwd1gdctq1o458wgztiwo
X-HE-Tag: 1779960170-39339
X-HE-Meta: U2FsdGVkX188jftPNGTuF6WSFaUPji/2l3X8zvz1JKtm1EJpW722ptDHqo/weUGDWUchXRbEL83AH5nVEYu01pkEPHpZr5Pw4qQb4MJ+1qggZAjOOdw0YwR0g/Gttz8E2Z8FY+Isw04nXQqrN+f/ssDADTBt7Y7I4oC42mXZ9wj2sw81YLF7tzDjdRBbAScUaUj7D9QpXz4e9+cML7395ldNezMFYUzKnfaU2ZzKTsUczLwLXgD4+R5txrTFRpLF5Svic4vUBUN57w0OmEigB1tW9TDCBkqfPF4yeCfL0+L9BbE19lVgSAr9S7PlpelD3YW3bru+zKM515jxLbFE4/eFGNX20YZAk1Iz14Cetp66TKt/xqW77IFTx5IPcios6HjfE+eDPvn3FWTTJXX1rptg38DtAmgsSdV4flrF0bLKAI5z0vFYDNQBoaW3CmWIs2KG23mAxNkqw/r/OaDUsxPJ8MqwIRafVwB9rYlAXKJonZYBWQjpiW81SmAW5ohBA28mdYQYkb9EmTj0B1jWaYWZulbOpaxEl6JHq0aX959LgP4Gu5nCnLooscwhgY9BG0eeocqBWOPMqdSW7+AnVsjceVVmmg1U5QCbYQmCOc7lOgf2EPn7Ut8PPLx0qImYC33joCASl4ZGFk+tQBAn85OWszuOUs9KQDlfTxSwErPj+LDLYGJIdYJIQXYIlz4tadS7T37WvD/8CJ4b7bnZLMh9ODBybqJN8e1OoM+yyis7NrRBi7H9thWorLdKpEwwwrQoOWog4FVlAnC71+il6CcVl/72Pefw/bPDzdoTtG7lOqexML8m9ooAqYlqNRCO0BprXF6trLnqcm2IOdUEhPjNOYShgcxw0JZCYMJmJCZ5OifBgi88AkhBGhRtzXWGKBSyd8WllzseS7f9iYJm6kROkSjiHparX31f6fFQ2+flK8UZfhxKxUaZ1uyUSgZShA3kszWxley8RiZcCha
 8s5T9g0g
 kv06ygX60PN/F8kkk2zDiNasi6LcmzhxK4cDRICpXg8wlpRe1UtE4Ez3/p40hpPtdw7VQQIEHeapAdtOpJfFeBBh44yRX3+6zx3TRfO6hCbsXm6W3h6VQHx6OinBTQ2+HoTJFNWtHtlag9bE5GD3cV0/RgaTJbI8K41EavGUS4ay4Xno8UlW15e+WU6gF9N3psNCNdi/AwTLXv6X8pRgdwxULM/0udY/z1O+N7fr/9v9Q21Dw6DZVJXsZKy5ltQKVHC7uMDd7TJtd4UdujZP7tp7wbn/aeXRxugulfD6DqUZdqBkTxLcjAIgAZMb0zcNacPHzcPxwtjaKlHHaQM1t2STS13t4/7fbabhMJj5wFQzCcdgDxHzN8DBzr13BAWIqOAg+xF9ahQhdg8osNXAMsuBk/pSa0RlDTVLOem1PqzBMGVFZKRZX2rUarzWVTzXqq1QjmFJ585rRBlM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi

Am 28.05.26 um 11:11 schrieb Boris Brezillon:
> On Thu, 28 May 2026 09:20:16 +0200
> Thomas Zimmermann <tzimmermann@suse.de> wrote:
>
>> Hi
>>
>> Am 27.05.26 um 12:18 schrieb Boris Brezillon:
>> [...]
>>>> -			return ret;
>>>> +			return vmf_insert_pfn_pmd(vmf, pfn,
>>>> +						  vmf->flags & FAULT_FLAG_WRITE);
>>> I believe we can go back to
>>>
>>> 			return vmf_insert_pfn_pmd(vmf, pfn, false);
>>>
>>> if the mappings are no longer adjusted to catch write accesses.
>> If we don't install it as writable now, won't the kernel not split it up
>> into 4KiB pages when the actual write happens?
> It will be installed as writeable right away, regardless of the write
> parameter, because if pfn_mkwrite is not implemented, vma->vm_page_prot
> won't be lowered to read-only in the first place, or at least that's
> what I remember from the previous debugging session I've done.

In insert_pmd(), the write parameter controls whether we run 
maybe_pmd_mkwrite(), which sets the __PAGE_RW flag.

https://elixir.bootlin.com/linux/v7.1-rc5/source/mm/huge_memory.c#L1632
https://elixir.bootlin.com/linux/v7.1-rc5/source/mm/huge_memory.c#L1655

That's at least how I understand the logic here. Performance-wise it 
might be beneficial if we track the write flags as before.

Best regards
Thomas


-- 
--
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Frankenstr. 146, 90461 Nürnberg, Germany, www.suse.com
GF: Jochen Jaser, Andrew McDonald, Werner Knoblich, (HRB 36809, AG Nürnberg)



