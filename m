Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64BDA105F792
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 10:29:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A703A6B0005; Fri, 13 Mar 2026 06:29:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1D236B0088; Fri, 13 Mar 2026 06:29:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D4956B0089; Fri, 13 Mar 2026 06:29:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7D9176B0005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 06:29:53 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DE3161D11C
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 10:29:52 +0000 (UTC)
X-FDA: 84540669024.01.B492BCD
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf08.hostedemail.com (Postfix) with ESMTP id 53EA2160005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 10:29:50 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=v7CJF3Ty;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=b6DsA3C0;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=v7CJF3Ty;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=b6DsA3C0;
	spf=pass (imf08.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773397790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cS9r7HM1bxucH6lz6Ls7p3/oVOoLbuwQJxaflp/OFVo=;
	b=S3rQ62zLmvpUUfl2nGjKAXZ0CpmFUI14WtWzrac8Egra4y53+GB22hGGQEstkU30JoHEZg
	R3vahD0rEiuBOBS7h4nQLjw/KCi38aGKFKux4nfWCDcqp7vL43CELK51j9uEVCYOj79Gmx
	nOooD22yxFRc50gkF9lwiRZy7+tl/W0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773397790; a=rsa-sha256;
	cv=none;
	b=NMepHodXzwwZybc6hKJ1rqpQMy+qrxXnen6qSnDa0U02xb/FIZC1d1BsvBGuJxoeORdn63
	BIUNAMn7PMWzm12YR4AZ84hswHYRqFtjmXeqnqXJj4ymLu+r5HD32mo1ibZ5MR3aWlq7o+
	F6LlaXMW+0spJDeTJ3bXob0ijtGR80U=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=v7CJF3Ty;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=b6DsA3C0;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=v7CJF3Ty;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=b6DsA3C0;
	spf=pass (imf08.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 83B434D3E6;
	Fri, 13 Mar 2026 10:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773397788; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=cS9r7HM1bxucH6lz6Ls7p3/oVOoLbuwQJxaflp/OFVo=;
	b=v7CJF3TyMG6ofZfyWWylnDpGaI16fzz+2z+qCkaOkHBYUYhr7+zDQEqkLdKm7KvxMZhArD
	iW0qVuzmsz9s2+ALSFyyb5ZTo4oNUXm49cKBs62lMUxtrh2u9UMr67enpJDdiRls4bwPo9
	Frjcm5lr4Xaim0NW7tAQopu0wbZag3Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773397788;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=cS9r7HM1bxucH6lz6Ls7p3/oVOoLbuwQJxaflp/OFVo=;
	b=b6DsA3C0X/xyQEKtIPig7I8seGj8dUCihPi51rsOVmFFvkzg0VwMB508F73Z65dN9/PqbF
	rzxKAAyYpKxuPMBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773397788; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=cS9r7HM1bxucH6lz6Ls7p3/oVOoLbuwQJxaflp/OFVo=;
	b=v7CJF3TyMG6ofZfyWWylnDpGaI16fzz+2z+qCkaOkHBYUYhr7+zDQEqkLdKm7KvxMZhArD
	iW0qVuzmsz9s2+ALSFyyb5ZTo4oNUXm49cKBs62lMUxtrh2u9UMr67enpJDdiRls4bwPo9
	Frjcm5lr4Xaim0NW7tAQopu0wbZag3Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773397788;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=cS9r7HM1bxucH6lz6Ls7p3/oVOoLbuwQJxaflp/OFVo=;
	b=b6DsA3C0X/xyQEKtIPig7I8seGj8dUCihPi51rsOVmFFvkzg0VwMB508F73Z65dN9/PqbF
	rzxKAAyYpKxuPMBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 32F3240498;
	Fri, 13 Mar 2026 10:29:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id G8E9Cxzns2k8RQAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Fri, 13 Mar 2026 10:29:48 +0000
Message-ID: <f3384342-cdc5-4260-b670-4ffde76a2802@suse.de>
Date: Fri, 13 Mar 2026 11:29:47 +0100
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
In-Reply-To: <20260313111851.4c1f89f3@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 53EA2160005
X-Stat-Signature: t6qekzh9nsa9nyrkoouxm74sxhiy4tkr
X-Rspam-User: 
X-HE-Tag: 1773397790-817336
X-HE-Meta: U2FsdGVkX1/udErNrUuo6o7lugWbm/n7ZBuH/6jI8BdXMoy6fFe1P//Ln9+zw26PEa0UKpVNpZT87rDjJyZ6teyiTQXrZQgJLQTkpapapeX4Zed6ZnaEkzAW94VK4p5CnNz9ub82M0/TREybtbaEDZdMvBaT0UdGd/krMv1lJLNXFwlTa4seISm491ZLXCvOWOckpaKCVALrMRTpJbXREyuN/J23THudkOBNkDE/m7Qp6TIBE9VtCRQIsWRIid2KK9nMYsqEJ5SLCzmEt/PL6dLaul9sdA60aEVtkVMxSFzK6ICPrE6qBCnTpg/m0HnDGhgn9VDqpQG5PZPgEhW4lZ5B1jp44qoJi5iREqt6mS4BY9HoO+qQof/xbQRBI6L6UwFGP1O05QNdugyR6GhOZ40WYk+GhZ9hQTZmdGUxWEGJsle9DTa7N+WLnqVxCE5ZBINhLoJ1gK5lew2Am+T2nKY6cdenKcQ2K90dFAbPC8BvK/7zfYNYHj+Ihmr2RrvZcUgUUEEMkYh4k4b/Yxc8aKNZcbvre7RE5tU17fPaFvcsMo7wyIRZqwwz/NHD/hmBQIwrjsTyJ+B+I/13MdUX/94nqPxQkkzu3Ldnr3ZvYP25prIa5mDC/auqCFVj/lI0euzVY4k/5oDz41P3Za21508tB8FJ0g8kgmu3pVFfkTHnRiCnhMdY1BwIhdKBPFkK8k05nq4K70+Yl2KFSV6WvNTBFggBS4xjVavG5epgYjMeC0/65eHS/HjwdY0WNsklKNWbctwvnRzHZDfSe97p+8ogcfmxz6gwmBhYAxTo9c9ElRjJeug3KTAVPCLzlQQ+oM04XciqxirdLctHwW7NX1prO8qyMGunVFppUZ0avfutDEt3iWoDniivsRtVCsnmZRa1svN2stAaR/HQsF7A56PBk8QtYfc1pQfWv7QYik52Q3jb18ZL40PujJiiuR+Nq00lf597PI0KA49kmCt
 udiV3Bjw
 Yv7rO4BschuPkND8K4IyodePn4wt7LYV1FCkdQzVAPRkg6GRGD/ZTX8R+BDjyBPe61IdVojQ1npbOkNyS86LcL8DMiBu2CPR+zMbaMXQY9g0GfrXx41E9L8WudClaPH5BKgir/0oDFxTsdM6Uxeao/b3+SBGfpgEjtiZq4XacNxGJGI1SfkVnIXAvjwmYQ1lbpcezoZGkWCeslOM0dfp1T72rQbo6C6hWTmpG6nuGXiMC1BWczvczURXXOgM4EZ1J+vkBy21dvVcKw34jxAZ/9UHemy/DHnGOVTRNFSKucA4Ts2VcnPgO93FipazZbUCwxLC8uShkJuAXNlmZg5goc76OFyqFZv6fIBxxN7N0BIGybKLdvcGI5gyQu/R1doVE2qFAuczePOG2gexVws+0pMMlmNjRv6tbtcE44tBZ/bXEfBfVBvIBrW8sA4JyXzFJ53yXdUxAaY6sWzaIS5usjGa92CBWG6xkBEVv3vuif4s28d4M+03+keM+pg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi

Am 13.03.26 um 11:18 schrieb Boris Brezillon:
[...]
>>>>> +	if (drm_WARN_ON(obj->dev, !shmem->pages || page_offset >= num_pages))
>>>>> +		return VM_FAULT_SIGBUS;
>>>>> +
>>>>> +	file_update_time(vma->vm_file);
>>>>> +
>>>>> +	folio_mark_dirty(page_folio(shmem->pages[page_offset]));
> Do we need a folio_mark_dirty_lock() here?

There is a helper for that with some documentation. [1]

[1] 
https://elixir.bootlin.com/linux/v6.19.7/source/mm/page-writeback.c#L2826

Best regards
Thomas

>
>>>>> +
>>>>> +	return 0;
>>>>> +}
>>>>> +
>>>>>   const struct vm_operations_struct drm_gem_shmem_vm_ops = {
>>>>>   	.fault = drm_gem_shmem_fault,
>>>>>   	.open = drm_gem_shmem_vm_open,
>>>>>   	.close = drm_gem_shmem_vm_close,
>>>>> +	.pfn_mkwrite = drm_gem_shmem_pfn_mkwrite,
>>>>>   };
>>>>>   EXPORT_SYMBOL_GPL(drm_gem_shmem_vm_ops);
>>>>>
>>>>> --
>>>>> 2.52.0
>>>>>   

-- 
--
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Frankenstr. 146, 90461 Nürnberg, Germany, www.suse.com
GF: Jochen Jaser, Andrew McDonald, Werner Knoblich, (HRB 36809, AG Nürnberg)



