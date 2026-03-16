Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C840EFCBD4
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 08:45:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3A016B00B8; Mon, 16 Mar 2026 04:45:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE7C16B00BC; Mon, 16 Mar 2026 04:45:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99E826B00BD; Mon, 16 Mar 2026 04:45:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 878E46B00B8
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 04:45:54 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 273DE54EC0
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 08:45:54 +0000 (UTC)
X-FDA: 84551293428.10.9C88D1A
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf28.hostedemail.com (Postfix) with ESMTP id C00C5C0007
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 08:45:51 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=RKnM5v0i;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bh7FO9X1;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=RKnM5v0i;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bh7FO9X1;
	spf=pass (imf28.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773650752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UcK0mCj2Jo8AI0kfTvelbnqRTyW2MZtbydy4WExAfks=;
	b=yOnadIZYayjqXXqxZXpWlAbVD5wxCy/Ik5ulHMAOJo86vbvgarMlImhiDndcLaV+qYv7C9
	hA7fOwc+eye9EL9w9mvEzuZHE6O2Nw5YeF+N9SdS9iBShAh+mtcfGlFSn4vkrPkCKI6OMy
	D9TmzCrQRpXZXeTsjQmRoOdl2tGlXf8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=RKnM5v0i;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bh7FO9X1;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=RKnM5v0i;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bh7FO9X1;
	spf=pass (imf28.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773650752; a=rsa-sha256;
	cv=none;
	b=nJ7WcOa9tPaXf5jbXgU3tQATlo8QdZqtlYor6TQjE/H/Ew0zamIL+rhH8ugzSCEw+J0Dow
	2JXMsUENbSh81k35bXXm59ykvSKZh/JMdSFEyKpmBXvf41/XL+GfdnycNeNBEAmUXrtNji
	rUSpMUNjHE7d6+doBkmbrZGMUVSTiEY=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0438D4D1C7;
	Mon, 16 Mar 2026 08:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773650750; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UcK0mCj2Jo8AI0kfTvelbnqRTyW2MZtbydy4WExAfks=;
	b=RKnM5v0iKaypRbV+xk8QYDgskUYIsvLndYi1j/JP8u9VZm6G9nQOEX41GheDP8TXTIONOO
	tvEAYh2rdn93ub8L8YJSOzyhT8RWrEEn2yiwdYuVanXap/ScmKn/Mdsi3KSbP5ttD7pMay
	vBBgzYeHGAJPAej5MoN0+CC0Eup+Ma8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773650750;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UcK0mCj2Jo8AI0kfTvelbnqRTyW2MZtbydy4WExAfks=;
	b=bh7FO9X12wVVbZW3DBYdD2VW0HVn01MPJI5/g6y3nFrehfRxQINgYmyBsSS9j5evGnEsTX
	SwIg8GZZx7P7/gDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773650750; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UcK0mCj2Jo8AI0kfTvelbnqRTyW2MZtbydy4WExAfks=;
	b=RKnM5v0iKaypRbV+xk8QYDgskUYIsvLndYi1j/JP8u9VZm6G9nQOEX41GheDP8TXTIONOO
	tvEAYh2rdn93ub8L8YJSOzyhT8RWrEEn2yiwdYuVanXap/ScmKn/Mdsi3KSbP5ttD7pMay
	vBBgzYeHGAJPAej5MoN0+CC0Eup+Ma8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773650750;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UcK0mCj2Jo8AI0kfTvelbnqRTyW2MZtbydy4WExAfks=;
	b=bh7FO9X12wVVbZW3DBYdD2VW0HVn01MPJI5/g6y3nFrehfRxQINgYmyBsSS9j5evGnEsTX
	SwIg8GZZx7P7/gDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9963D4273B;
	Mon, 16 Mar 2026 08:45:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9UkHJD3Dt2nrbgAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Mon, 16 Mar 2026 08:45:49 +0000
Message-ID: <53f11658-5466-49a3-816a-ff6fd2e1da6f@suse.de>
Date: Mon, 16 Mar 2026 09:45:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/6] drm/gem-shmem: Track folio accessed/dirty status
 in mmap
To: Boris Brezillon <boris.brezillon@collabora.com>,
 Biju Das <biju.das.jz@bp.renesas.com>
Cc: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>,
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
 <20260313111851.4c1f89f3@fedora>
 <f3384342-cdc5-4260-b670-4ffde76a2802@suse.de>
 <20260313125644.65131b27@fedora>
 <TY3PR01MB1134662A395AA0A048CEE152E8645A@TY3PR01MB11346.jpnprd01.prod.outlook.com>
 <20260313131835.52c5c935@fedora> <20260313134328.3166c4d0@fedora>
 <20260313135521.07823792@fedora> <20260313184549.08656eed@fedora>
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
In-Reply-To: <20260313184549.08656eed@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C00C5C0007
X-Stat-Signature: 1czzpumsmmc9rpdotk853ji5s6soxdr4
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773650751-871301
X-HE-Meta: U2FsdGVkX1+zL3jUclVCQ5eL4Dv9TYV/qFwYz49Gq+SS7Ous+mPrTK2x1++r9qEgzV+L9p6UHurdIAgovm/6S9vcgSrXL6zgG5v2P0bTaRpev7s2g0nGi0Ig3pDnHY2Nwcfy/tSlW0Mxx4ZOtWt3BhhDT3LvxmDDkCrRZrBf4pVoqxUvXLdj5555UUIz5STVzEvqhgRzGnoKVWlBfvtIPTz+d9zzVucoBlaXa+J5aPrpG+Z3hv8XfESiQlokB1KhBSauA4jqt4fB2Qj7kBKNRtatTMOTb/A7+OJk60RT48rKj/Oco0PdDydZIf1Ussx0U4xeCEBAxGAz/c+80/lO251UPCFbZ0GatEg27Mg569vr6zPXsWH1vDqm5erNdpoxXONCmMclcBL2i/eEYTz+XKi/+4HQ8JdxiIoPoCe35ZZX5qHckHXfRO5UshTybtGyWtKJiMJ+8LkgepkYQoZzoIGFnqjx5Ews6y6aCZ1GNCBNWn+UU7DH4JAFHgiEV0MHYJ/BK0qnAmrjMPtutS4uFw7jyAnsxiuBxhasVsFnOAX1GhPCak23yMF+9/xndnL8fq2J9a8RGGZgpYidFYoPhlZkQ1+ZtQrXaG3LwAuQsSo7OPam1QlgH3T5Gqbg5Gtsuchz/9DJDYUDHtL1LaFA8CcWb6G4u+6yTyk7gkrbyHHjncCZ47V7vM5dv2TEzg+d/UZ8KHkGT+TnJYycKjVrM5j5Y57cH3KEvs4S8bsS8yepSq6pVvZnJjjM4+UGE9eFdYLeyxpSG5wUYo4x2+ZfBE1bq7l/uHZGEyxfxgz97pdHUSwLIRVSMV6i0FdfsO3kwhj+qlMaSaAGUtgUhFhtOZFlE91ybkTlCP/LnR/Ybo/nv76eEEXMVlE7bpbPLnKErXnaEffaWuJ09dJNV9kEQzVXLSsYOY0kaXOexostEbgYCLUuUYMgrJaEWgAZkqnDu/No6rIZsf7oIDaTTGC
 U7Rh8P6d
 msjrUg+VdJLvUjE7X+wrKxKQQzR2ODgHiN+SLHsC4k+NEEx+DnG2ou6BO6XRTbb0NDzVNDNjMa0sLZwite7ijg+sISud/m2lgDdBUMkZ/5Mvl8BBRWeOII01NvZyTfKBZ+9BOiAUJGO1AzFHRNajsgRQo4V0m56s/zPojniP5DIrMb9XWIKOtUdxN7Qdt4VqMBhw0/TCRD/uwVdMBXG+eXyuSOHhxX112r5h01vrJGjFNdGWMWHbBqVDNax711qmkbMLi3gffnTwAe8y9LQe9G6yMwsUca91dLZ+6nszUG8isa4/Y0TSSge9MSD3qrIoiZScpg7/lKiwmuNLxBbOKx+lIt67ZXhiSrVMjUyIE9KsMPUDLvr3qJ3cbAmBtV3abdUJ/cpsvstUd5lwgDFvRwALHWZi0WIhP5Kr8ACPE7sk2AMzeW7hcqS/D+9VcqyqCjp3ql5b4lT4KmyKyDiRFTGj7Iqil1nI1bb/sniYO/W/e9AcvJjeTqEq6M9iOUG/xkrZ4lzPXa9Be8ESVdU1XkDIBfObr2VsggIz6KRC4LcApeTKtwHr48iwcxMyMKm9cT9omN6MuS+oUsir5gQ1EQQ6Bz1e/bS4U1A3Y3Pe/13Uuch9+x5rEa0vQev5tlSdAK6+48jz0X5xzcldAnLzRChrMQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Boris,

thanks for investigating this problem.

Am 13.03.26 um 18:45 schrieb Boris Brezillon:
> On Fri, 13 Mar 2026 13:55:21 +0100
> Boris Brezillon <boris.brezillon@collabora.com> wrote:
>
>> On Fri, 13 Mar 2026 13:43:28 +0100
>> Boris Brezillon <boris.brezillon@collabora.com> wrote:
>>
>>> On Fri, 13 Mar 2026 13:18:35 +0100
>>> Boris Brezillon <boris.brezillon@collabora.com> wrote:
>>>    
>>>> On Fri, 13 Mar 2026 12:04:25 +0000
>>>> Biju Das <biju.das.jz@bp.renesas.com> wrote:
>>>>      
>>>>>> -----Original Message-----
>>>>>> From: dri-devel <dri-devel-bounces@lists.freedesktop.org> On Behalf Of Boris Brezillon
>>>>>> Sent: 13 March 2026 11:57
>>>>>> Subject: Re: [PATCH v4 5/6] drm/gem-shmem: Track folio accessed/dirty status in mmap
>>>>>>
>>>>>> On Fri, 13 Mar 2026 11:29:47 +0100
>>>>>> Thomas Zimmermann <tzimmermann@suse.de> wrote:
>>>>>>          
>>>>>>> Hi
>>>>>>>
>>>>>>> Am 13.03.26 um 11:18 schrieb Boris Brezillon:
>>>>>>> [...]
>>>>>>>>>>>> +	if (drm_WARN_ON(obj->dev, !shmem->pages || page_offset >= num_pages))
>>>>>>>>>>>> +		return VM_FAULT_SIGBUS;
>>>>>>>>>>>> +
>>>>>>>>>>>> +	file_update_time(vma->vm_file);
>>>>>>>>>>>> +
>>>>>>>>>>>> +	folio_mark_dirty(page_folio(shmem->pages[page_offset]));
>>>>>>>> Do we need a folio_mark_dirty_lock() here?
>>>>>>> There is a helper for that with some documentation. [1]
>>>>>> This [1] seems to solve the problem for me. Still unsure about the folio_mark_dirty_lock vs
>>>>>> folio_mark_dirty though.
>>>>>>
>>>>>> [1]https://yhbt.net/lore/dri-devel/20260312155027.1682606-1-pedrodemargomes@gmail.com/
>>>>> FYI, I used folio_mark_dirty_lock() still it does not solve the issue with weston hang.
>>>> The patch I pointed to has nothing to do with folio_mark_dirty_lock(),
>>>> It's a bug caused by huge page mapping changes.
>>> Scratch that. I had a bunch of other changes on top, and it hangs again
>>> now that I dropped those.
>> Seems like it's the combination of huge pages and mkwrite that's
>> causing issues, if I disable huge pages, it doesn't hang...
> I managed to have it working with the following diff. I still need to
> check why the "map-RO-split+RW-on-demand" approach doesn't work (races
> between huge_fault and pfn_mkwrite?), but I think it's okay to map the
> real thing writable on the first attempt anyway (we're not trying to do
> CoW here, since we're always pointing to the same page, it's just the
> permissions that change). Note that there's still the race fixed by
> https://yhbt.net/lore/dri-devel/20260312155027.1682606-1-pedrodemargomes@gmail.com/
> in this diff, I just tried to keep the diffstat minimal.
>
> --->8---
> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
> index 4500deef4127..4efdce5a60f0 100644
> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
> @@ -561,9 +561,8 @@ static vm_fault_t drm_gem_shmem_try_insert_pfn_pmd(struct vm_fault *vmf, unsigne
>          bool aligned = (vmf->address & ~PMD_MASK) == (paddr & ~PMD_MASK);
>   
>          if (aligned && pmd_none(*vmf->pmd)) {
> -               /* Read-only mapping; split upon write fault */
>                  pfn &= PMD_MASK >> PAGE_SHIFT;
> -               return vmf_insert_pfn_pmd(vmf, pfn, false);
> +               return vmf_insert_pfn_pmd(vmf, pfn, vmf->flags & FAULT_FLAG_WRITE);
>          }
>   #endif
>   
> @@ -597,8 +596,12 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
>   
>          pfn = page_to_pfn(page);
>   
> -       if (folio_test_pmd_mappable(folio))
> +       if (folio_test_pmd_mappable(folio)) {
>                  ret = drm_gem_shmem_try_insert_pfn_pmd(vmf, pfn);
> +               if (ret == VM_FAULT_NOPAGE && vmf->flags & FAULT_FLAG_WRITE)
> +                       folio_mark_dirty(folio);
> +       }
> +
>          if (ret != VM_FAULT_NOPAGE)
>                  ret = vmf_insert_pfn(vma, vmf->address, pfn);

All these branches with NOPAGE seem confusing. Can we change the overall 
logic here? Something like:

if (folio_test_pmd_mappable()) {
     ret = try_insert_pfn_pmd()
     if (ret == VM_FAULT_NOPAGE) {
         folio_mark_accessed()
         if (flags & FLAG_WRITE)
             folio_mark_dirty()
         goto out;
     }
}

ret = vmf_insert_pfn()
if (ret == NOPAGE)
     folio_mark_accesed()

out:
   ...


This would keep the huge-page code within the first branch. And if it 
fails, it still does the regular page fault.

Best regards
Thomas

>   

-- 
--
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Frankenstr. 146, 90461 Nürnberg, Germany, www.suse.com
GF: Jochen Jaser, Andrew McDonald, Werner Knoblich, (HRB 36809, AG Nürnberg)



