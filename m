Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EF51106FD9D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 08:33:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58AE16B0005; Fri, 13 Mar 2026 04:33:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 538CE6B0088; Fri, 13 Mar 2026 04:33:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F0706B0089; Fri, 13 Mar 2026 04:33:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2A5096B0005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 04:33:46 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B8FB6C2AC1
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 08:33:45 +0000 (UTC)
X-FDA: 84540376410.20.484F2B0
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf18.hostedemail.com (Postfix) with ESMTP id 44F6E1C0010
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 08:33:43 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Xtt7juVZ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=AR1jn7Xj;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Xtt7juVZ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=AR1jn7Xj;
	spf=pass (imf18.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773390823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=By/5ukn2mwKOcgj/f+9D00tvg2cfhX8HhLGnGYQXqis=;
	b=ikoizaBftSp0ot48hWEuZNClYJ2EFHVPkPd45t0N7dGvHAJBkrcqDCd52TNwIf9fhujPKl
	OfTRn61R8fCKNQEbE4vqaqRBg8NIUamIMcH4QKFGZeS4iZMdPIMeYhFfm++Nf/jAIrrK+g
	+onyoSncawjY2U0Vy9Z2DYKDrtwNMEw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773390823; a=rsa-sha256;
	cv=none;
	b=S7br8aEf9/DB2g4FaIIDR/imPe9owu4zxyUt1XmpQ3LCpR5D/ogkSu479u9ogHfEpsYji8
	+8dMzINURU/3WeqOUWoee6ciDgSVkJ3NGNVOXq7mg0nDxE+424QzKUm3q9Pleku9/AhDT7
	70wx/YPdmaT/iyb9HMjBKS/WMHyBTGw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Xtt7juVZ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=AR1jn7Xj;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Xtt7juVZ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=AR1jn7Xj;
	spf=pass (imf18.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5405D5CFD9;
	Fri, 13 Mar 2026 08:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773390821; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=By/5ukn2mwKOcgj/f+9D00tvg2cfhX8HhLGnGYQXqis=;
	b=Xtt7juVZnOR+TX/3aKQVKYH4jA5lwyX1gJfyddLaPoit4EXLrx7beuoZPoIUr/7pa7+c++
	JezHlC2b8MjF+kVD7zlO7lV6VIVkgptp1gfb3VTDqFRGI1ARiJX/rcomq/4a91jUpdpg+W
	rOT3g1BvlXkgAvdRS2duRmyv6Rbgk4w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773390821;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=By/5ukn2mwKOcgj/f+9D00tvg2cfhX8HhLGnGYQXqis=;
	b=AR1jn7XjRExFQnH6CLbctLjz9P5lTakrIJzXfuc52EULHxZxVqswY0YIftY+7neJOogX5f
	2jXtr3HjtV6cbfDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773390821; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=By/5ukn2mwKOcgj/f+9D00tvg2cfhX8HhLGnGYQXqis=;
	b=Xtt7juVZnOR+TX/3aKQVKYH4jA5lwyX1gJfyddLaPoit4EXLrx7beuoZPoIUr/7pa7+c++
	JezHlC2b8MjF+kVD7zlO7lV6VIVkgptp1gfb3VTDqFRGI1ARiJX/rcomq/4a91jUpdpg+W
	rOT3g1BvlXkgAvdRS2duRmyv6Rbgk4w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773390821;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=By/5ukn2mwKOcgj/f+9D00tvg2cfhX8HhLGnGYQXqis=;
	b=AR1jn7XjRExFQnH6CLbctLjz9P5lTakrIJzXfuc52EULHxZxVqswY0YIftY+7neJOogX5f
	2jXtr3HjtV6cbfDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 02E3B40423;
	Fri, 13 Mar 2026 08:33:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +8fqOuTLs2lVSAAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Fri, 13 Mar 2026 08:33:40 +0000
Content-Type: multipart/mixed; boundary="------------7ZdkRrZrk9ysaFnV0R6IQqxK"
Message-ID: <d3818663-2673-4de4-b483-557602f6e8b9@suse.de>
Date: Fri, 13 Mar 2026 09:33:40 +0100
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
In-Reply-To: <TY3PR01MB113460CA616D3576DA0C3FC698644A@TY3PR01MB11346.jpnprd01.prod.outlook.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 44F6E1C0010
X-Stat-Signature: 7isy4dtuwdaq1j988ba4y4fy398qz4y6
X-Rspam-User: 
X-HE-Tag: 1773390823-391293
X-HE-Meta: U2FsdGVkX1/ph7mC7t7AM9PmS9xIdy9zcS5hHpeSdpTmg4Ak1OBzh/K/0FAvdQ20wZbYsZTYCIQ1V+pdDmhL5bpXwEVXN7edxR/z787SWgM8g2pY/RyqFgdbH8KG9ImS8DdNwASYZMLhp5svohDpREa9e9c3RTkPTLj9y5AM8VQPq63GsqbZPTn/z9/kgHrFs4AOoITMnlGRCesQaHLcKwPqgo5orkOb5QfVjJXHKzqiBidK/rJR0qDbUZW8MK6WC8IBx3uoL3McK6KZRlwFnAZ7lpZ8MF+xWPDknX0TmSDOyYpigTkVEQR4uWtuD2QTZHPScyBMpJizBTjxlyPyX0EUD5S0gHSoV7AuQRgnWxrZhaoLPXzc6y4IkWTWRb9ql+JfVrIrVy9xPnU33RPXYep59fNpnKQwPvzc7s+0ew0gRFdQXWvIly//QDdodU1bosBYg69kc9zyuprIhMaKPggMOqVx6fwK+XrevOZhl0ilzdPe0YukIor//ZAvoYIgMYDWzvsAUXjssf1/xMt+vq1sv/k6CuA79BWoUgnmajkVmbTKesXfXarTzVYArG8UFHo+JLRI+7agJpNKVxXQUGvPBWMviq0kSw0YwTAwXriBbfgBUe2iUQ8pfptOBoyJClI1Loy/LhpoT1jjy+JVmDqWj3UgJlwvXIX/l+rwSyB3nIewGVE12Vgo8S8zGlkrj8UhX7TIhOAUt1DFX2XZ8SqfSUQSQaCXgXHKdJrjr2Lk1ZwWcDPritz/3m2yzuybazJW/MEStj8j4mhIbmlYPnYuO/ohOc9yQ8fLrsI+MHGTxGwE3a05iAoRPHmRrSlvMAW+huiIkVj22SOnz70Ec8q0E6KUNzrB6kLIgd5zdFdwYUIL1700FmhyhSBBf7knXXDPhCdMTK7d8Z1UzOWXDLCm2xw4v/S4zIh1HsCodmVb6uwpkfWYKo71I+JieG/pTWMGXTYpLGXzk1/cANh
 iD21n2P1
 s8xyopEg5BkxVno4/okKIPt+SfKtYV86whMnQsd6Oxi0wVu2zBY4dSiPbLSfMvlu6/BYWNGl4asZ5/6Z0mRcOtyWNHPn3/OTyabtBA+AOQHPOVLnHhZnLnv895Di5sp6WisApBCTXQqAXPAg1Iq4QAMDeqhrHFZ2TPkul1zSeMRTfpfKc7FOdZ1XxFtM5BZKvvjbBgw5+XExolgEhwoq4sbzWoKEu1RZGQ27+G+m54j5xAypK+W7/8N+c4vu7+y8zYvjsvVx8K6Q/eWYHw127vfwO4CaqVgFHClesssn5qu+LqY6ApMouYfjVIT3DFXmtHgq29KwXl6ZwvjUMH7OejDwnH1qhZCb4C1Ue4Nb3yPvsgo81wr8dVLHb4QfR2ZaMgO9RH1BtTB/LwSQmtmWc1TO+V3k5gdpD9Fr1xCXzz5QET43qFbrkCtwexgoiYox0ArRFiAAZPSXOdD4fTgA+M3osz3rM7jXgAWtHjr6suXkmgeFyAyEq1BFv8suOMEHnWw7SnwHsrbgwBQY4Z8oQyA2+2tN7d5r4iMF5ZqLLleBjbVvhCBlW/gTRwCiqxHsH8UOYKI9FXhVfjM1AiY4uxhjd7avb6UvaVgCcAloGsGHxnke2PoNsrP5CYzcCp8GW0Iu6RD93QsrWCbRLXkI/NoRbx2+1rVS1femwAi+FZFSWyy5ZDxlCpZ5j1Gp+spEDB/3bVzZt9eIzgvKszfTCsO4HrA8ENcf2xDjye7AiDe7xGbYfwsJVhdCMYuSGtmCWROlgAKAeUHiNIcjDhRO7fo3CKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------7ZdkRrZrk9ysaFnV0R6IQqxK
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi

Am 12.03.26 um 18:46 schrieb Biju Das:
> Hi Tommaso,
>
>> -----Original Message-----
>> From: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
>> Sent: 12 March 2026 17:37
>> Subject: Re: [PATCH v4 5/6] drm/gem-shmem: Track folio accessed/dirty status in mmap
>>
>> Hi Thomas,
>> Thanks for your patch.
>>
>> I'm working on DSI support for RZ/G3E from this morning rebasing on top of next-20260311 I'm seeing
>> that weston hang on my side:
>>
>> Reverting this patch fix the issue.
>> (git revert 28e3918179aa)

Just a guess, but maybe vm_file is NULL. The attached patch should 
handle this. Could either of you please test?

Best regards
Thomas


>>
>> I'm wondering if anyone encountered this issue?
>> Thanks in advance.
>
> I am also seeing same issue on RZ/G3L with weston.
>
> Cheers,
> Biju
>
>
>
>> Kind Regards,
>> Tommaso
>>
>> On Fri, Feb 27, 2026 at 12:42:10PM +0100, Thomas Zimmermann wrote:
>>> Invoke folio_mark_accessed() in mmap page faults to add the folio to
>>> the memory manager's LRU list. Userspace invokes mmap to get the
>>> memory for software rendering. Compositors do the same when creating
>>> the final on-screen image, so keeping the pages in LRU makes sense.
>>> Avoids paging out graphics buffers when under memory pressure.
>>>
>>> In pfn_mkwrite, further invoke the folio_mark_dirty() to add the folio
>>> for writeback should the underlying file be paged out from system memory.
>>> This rarely happens in practice, yet it would corrupt the buffer content.
>>>
>>> This has little effect on a system's hardware-accelerated rendering,
>>> which only mmaps for an initial setup of textures, meshes, shaders, etc.
>>>
>>> v4:
>>> - test for VM_FAULT_NOPAGE before marking folio as accessed (Boris)
>>> - test page-array bounds in mkwrite handler (Boris)
>>> v3:
>>> - rewrite for VM_PFNMAP
>>> v2:
>>> - adapt to changes in drm_gem_shmem_try_mmap_pmd()
>>>
>>> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
>>> Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
>>> ---
>>>   drivers/gpu/drm/drm_gem_shmem_helper.c | 22 ++++++++++++++++++++++
>>>   1 file changed, 22 insertions(+)
>>>
>>> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c
>>> b/drivers/gpu/drm/drm_gem_shmem_helper.c
>>> index cefa50eaf7a4..1ab2bbd3860c 100644
>>> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
>>> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
>>> @@ -598,6 +598,9 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
>>>   	if (ret != VM_FAULT_NOPAGE)
>>>   		ret = vmf_insert_pfn(vma, vmf->address, pfn);
>>>
>>> +	if (ret == VM_FAULT_NOPAGE)
>>> +		folio_mark_accessed(folio);
>>> +
>>>   out:
>>>   	dma_resv_unlock(obj->resv);
>>>
>>> @@ -638,10 +641,29 @@ static void drm_gem_shmem_vm_close(struct vm_area_struct *vma)
>>>   	drm_gem_vm_close(vma);
>>>   }
>>>
>>> +static vm_fault_t drm_gem_shmem_pfn_mkwrite(struct vm_fault *vmf) {
>>> +	struct vm_area_struct *vma = vmf->vma;
>>> +	struct drm_gem_object *obj = vma->vm_private_data;
>>> +	struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
>>> +	loff_t num_pages = obj->size >> PAGE_SHIFT;
>>> +	pgoff_t page_offset = vmf->pgoff - vma->vm_pgoff; /* page offset
>>> +within VMA */
>>> +
>>> +	if (drm_WARN_ON(obj->dev, !shmem->pages || page_offset >= num_pages))
>>> +		return VM_FAULT_SIGBUS;
>>> +
>>> +	file_update_time(vma->vm_file);
>>> +
>>> +	folio_mark_dirty(page_folio(shmem->pages[page_offset]));
>>> +
>>> +	return 0;
>>> +}
>>> +
>>>   const struct vm_operations_struct drm_gem_shmem_vm_ops = {
>>>   	.fault = drm_gem_shmem_fault,
>>>   	.open = drm_gem_shmem_vm_open,
>>>   	.close = drm_gem_shmem_vm_close,
>>> +	.pfn_mkwrite = drm_gem_shmem_pfn_mkwrite,
>>>   };
>>>   EXPORT_SYMBOL_GPL(drm_gem_shmem_vm_ops);
>>>
>>> --
>>> 2.52.0
>>>

-- 
--
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Frankenstr. 146, 90461 Nürnberg, Germany, www.suse.com
GF: Jochen Jaser, Andrew McDonald, Werner Knoblich, (HRB 36809, AG Nürnberg)


--------------7ZdkRrZrk9ysaFnV0R6IQqxK
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-test-for-vm_file-before-updating-file-access-time.patch"
Content-Disposition: attachment;
 filename*0="0001-test-for-vm_file-before-updating-file-access-time.patch"
Content-Transfer-Encoding: base64

RnJvbSBlNjQzNDZjNmIzZDk0NmU0NDI0MDY2ZDg4OGNiNDFmZTYwZWI5ZDg4IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBUaG9tYXMgWmltbWVybWFubiA8dHppbW1lcm1hbm5A
c3VzZS5kZT4KRGF0ZTogRnJpLCAxMyBNYXIgMjAyNiAwOToyOToyNiArMDEwMApTdWJqZWN0
OiBbUEFUQ0hdIHRlc3QgZm9yIHZtX2ZpbGUgYmVmb3JlIHVwZGF0aW5nIGZpbGUgYWNjZXNz
IHRpbWUKCi0tLQogZHJpdmVycy9ncHUvZHJtL2RybV9nZW1fc2htZW1faGVscGVyLmMgfCAz
ICsrLQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQoK
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9kcm1fZ2VtX3NobWVtX2hlbHBlci5jIGIv
ZHJpdmVycy9ncHUvZHJtL2RybV9nZW1fc2htZW1faGVscGVyLmMKaW5kZXggNDUwMGRlZWY0
MTI3Li43ZmFkNzJjYzAxZGMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvZ3B1L2RybS9kcm1fZ2Vt
X3NobWVtX2hlbHBlci5jCisrKyBiL2RyaXZlcnMvZ3B1L2RybS9kcm1fZ2VtX3NobWVtX2hl
bHBlci5jCkBAIC02NTYsNyArNjU2LDggQEAgc3RhdGljIHZtX2ZhdWx0X3QgZHJtX2dlbV9z
aG1lbV9wZm5fbWt3cml0ZShzdHJ1Y3Qgdm1fZmF1bHQgKnZtZikKIAlpZiAoZHJtX1dBUk5f
T04ob2JqLT5kZXYsICFzaG1lbS0+cGFnZXMgfHwgcGFnZV9vZmZzZXQgPj0gbnVtX3BhZ2Vz
KSkKIAkJcmV0dXJuIFZNX0ZBVUxUX1NJR0JVUzsKIAotCWZpbGVfdXBkYXRlX3RpbWUodm1h
LT52bV9maWxlKTsKKwlpZiAodm1hLT52bV9maWxlKQorCQlmaWxlX3VwZGF0ZV90aW1lKHZt
YS0+dm1fZmlsZSk7CiAKIAlmb2xpb19tYXJrX2RpcnR5KHBhZ2VfZm9saW8oc2htZW0tPnBh
Z2VzW3BhZ2Vfb2Zmc2V0XSkpOwogCi0tIAoyLjUzLjAKCg==

--------------7ZdkRrZrk9ysaFnV0R6IQqxK--

