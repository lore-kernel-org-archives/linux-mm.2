Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16D9CFCEE8A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 11:34:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EDAA6B00AD; Wed, 25 Feb 2026 06:34:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 390FA6B00AE; Wed, 25 Feb 2026 06:34:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 245AE6B00AF; Wed, 25 Feb 2026 06:34:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0E1B36B00AD
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 06:34:39 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B264F14058D
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:34:38 +0000 (UTC)
X-FDA: 84482771436.19.6A8406F
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf08.hostedemail.com (Postfix) with ESMTP id 64930160004
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:34:36 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=KFqeXe5m;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=73bPQfUX;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=VPIRHKg7;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=XkD1UiKJ;
	spf=pass (imf08.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772019276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=06rR0BzSAqyocoz661s88dhkzq7l5Ry/ExxLEADtw6Y=;
	b=YmCfYu1S3MpfbTanNJYUiSgeyKmxIRFe0bBbvws1uTIjiJpn1h+rhrZ+iGLK9yyNXM0Rws
	UtLxgmwOx2thiT4pXCYbMNiamDouMgaFhTv8mRughESgaLRaTtsND4oi0hjk5+m42U469e
	aTISQzb4ix29J6p2CqIftlHyKLHaQIQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=KFqeXe5m;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=73bPQfUX;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=VPIRHKg7;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=XkD1UiKJ;
	spf=pass (imf08.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772019276; a=rsa-sha256;
	cv=none;
	b=07ieclqoj0+aZZAXGndK95LTlX/5P3KXW0ZYLLu6EB4Uhr0Og3UTaNxCRudISkJZ3ceOza
	h99OtDylorph/yJSCIC1YxP0lP4UZli7AVP0DmJXogNqjtDaEO5Tj/wNf0PIZBza1EACDg
	IqbngV+fbWfSJp9/pNhTrQAegEuCA6k=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A550D5C5B4;
	Wed, 25 Feb 2026 11:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772019274; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=06rR0BzSAqyocoz661s88dhkzq7l5Ry/ExxLEADtw6Y=;
	b=KFqeXe5mX7IkzCXMPUSjqOZEMi4J+b1hIMPunZzDTp5Ab3zTdtXpLT90A2d44jNnxE1rc0
	ZjCHhX60opUx0tEMO9JahvF8/NjsdOiZlNDIhFIto0MEBf1NkTvr9rZVze+Eoep7YkLVsT
	5MKCLLtAOaTHbWMYypvACUoecn1aHcg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772019274;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=06rR0BzSAqyocoz661s88dhkzq7l5Ry/ExxLEADtw6Y=;
	b=73bPQfUXLwY0J8NOY6ANi6i80szQNjySSuQtnKxpr3TP/0Vj000ppmldpZR7b97YvaX49s
	SvcqqB0SVWDhERCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772019273; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=06rR0BzSAqyocoz661s88dhkzq7l5Ry/ExxLEADtw6Y=;
	b=VPIRHKg7Hv3bQTLdgZwq1PScdkfg1VUblMH/DiAd+bIAqsQbYRBI0mO9nyY78I60U0YVEi
	pt6S22B3xnK+IZBnh4mwzuQpzwfxkjC+G9xalGfYmp81QfNGpz5Ptg2x9X0ubowQzlieup
	le+Y2XNwtlCkwgAn0Obynxoaa7QUxh4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772019273;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=06rR0BzSAqyocoz661s88dhkzq7l5Ry/ExxLEADtw6Y=;
	b=XkD1UiKJlcjoeVUsLCNTuM9qeG9KzMTJJqf+I3wRltmAnnfVN8xiHLCOBVvQagZKX/geyL
	HbCxGn8c71G6qqAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4F9573EA65;
	Wed, 25 Feb 2026 11:34:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1kuxEUnenml+HwAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Wed, 25 Feb 2026 11:34:33 +0000
Message-ID: <04bc032c-3b6c-424c-b928-302a602d08bf@suse.de>
Date: Wed, 25 Feb 2026 12:34:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/6] drm/gem-shmem: Track folio accessed/dirty status
 in vmap
To: Frank Binns <Frank.Binns@imgtec.com>, Matt Coster
 <Matt.Coster@imgtec.com>, "simona@ffwll.ch" <simona@ffwll.ch>,
 "airlied@gmail.com" <airlied@gmail.com>,
 "boris.brezillon@collabora.com" <boris.brezillon@collabora.com>,
 "loic.molinari@collabora.com" <loic.molinari@collabora.com>,
 "willy@infradead.org" <willy@infradead.org>,
 "mripard@kernel.org" <mripard@kernel.org>,
 "maarten.lankhorst@linux.intel.com" <maarten.lankhorst@linux.intel.com>
Cc: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>
References: <20260209133241.238813-1-tzimmermann@suse.de>
 <20260209133241.238813-7-tzimmermann@suse.de>
 <d8d52d86fae1c3bb153cebb3ec154c84470804b8.camel@imgtec.com>
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
In-Reply-To: <d8d52d86fae1c3bb153cebb3ec154c84470804b8.camel@imgtec.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dz1e4disq9f8mw769giwetd6cp4oh8gt
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 64930160004
X-HE-Tag: 1772019276-424226
X-HE-Meta: U2FsdGVkX192M1k1k8dgr/9UiIwqgasvnwOAd6ZxN3Br2cIT3N+r1nOsiyP3TlmSWGNq3FMkWrchGNlGqeCOU2OBqvhQVK08tK/KujnLEMFKasbkBvnLL29VwlWeHAwRHoSPT1J0JUOOidfwr+acMKR4e3iXd+32x/4Ef5ltJ0xQEjoCwmpIiDYK+n4m1ailhur7CHM1NeH4r7RhgIrXEv+Wa/bDBAm/X3hnqzQncJM5DSv+/AjbEZaKn8HoNaAXF5LO9m7wyWEmzN1qj3KOCnqQIWIH0BrSeJmk4I44xGlClEGMLzJHcdMZSKNHO4E0+X3DdK2KdrsOE601NnkRkrJw4eKrLLB3NWSk4NRPeKyidunVoL6cVoMeqpTJPwOoDKqyDjHcUDnoTRB+DuBHD5AN3BdEjJnrI663ca5jgQPuCn7EU65JpZcmo7vtqnqPxY77ImTseC6X8Tdr3QSPfUNC/Kk01Ddgne+uXqSPl8RxmHfHWr0WuYpGGTEIVH/q/LHtkbe/bD2UEd0LZw7DlYDL9upDErgQ4yJ7lSPJU61teWf7k+7q9z3SyzRHRbsJI1tPsEhh+tIWRTpP9GmBXsRa97jt0sizF/hW6St68LE9QQLNpp/ZTqfoOhz5hKxvoUcfzBc5VQQ7EUx8YHEy8DuO68VNo6FzZva5g7oE1NaIiofmTlbRUCFUJBHTzhQdds55Q2w66/KnpDDhoZ445rpcr9Y7OUTTwu7KD5Bcw+Q1IWy9NWSqAOmLlRkCx+fxcxLnnktSa30TZReg6N+957+Fj8KO0KjMSblGBWL8lxDS8gHdbIwmmffiR8/jkv3FbNuzbgqZAgIcVGOMLgIt5+PSlXrpQfm/dw+7EzsH3Osl+AIZpFxPaIbaMwHJbx5pVpC5pgwruqdiGN5uoB7+Ocf0I7jbKqnA0RhS0jZ0zxcwHpuPIfbPvboialX16Jh1AH1tlTgE40zjOY2tnxE
 430dKwkD
 cl2EmYQEvLCQvfq1frM0vuDGEmbylcSus1AV5T3RXc0PP6R2y2sQIetKGBIVo0u4qKqevBSTFDNnDmNrtHKfmI80cXYGuUluVxvJ3pZ6LQMjWCwNs0Jn5RPisbJhP8UXVSN/2WBy/epj674l+Ig21SBEgtlcqCte7AOjU8qb78+rnmE/psEwU9lVhk17tQjlkIH4MCRhlvS70UGDdNt9LcBPpbZ5QP6M4lpLpqdgmgHukjgHWUAQ/4Sy0euhKi4eMPxh3h+Ri8iEsMFTItT0yOGwd3Gi33FE/v2//wNKgvdmoJZm1LeVWbILPzZcoqVA9niP2JjCxx3jOmpdK2PAt8MtQhiMWlv4W7R5gif/j0ZiOipdxnDFY3fWVGbGbp7IJArY8z7Bx9sSyR+YoiWbw8/fV0rVHnxd/M2oJeK/bj2f/01+GtLsprjLaDjltPmL3wlM+n+R3ZzqU53TpHfsZQxKyBD7+A2WGnxYN1cM/zSUzxu+OzlF43tv1JvkPARApY6xE47BSZD/Z19XhFj4u73reT8jr9seIzB9JW32qbVADsxo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Am 25.02.26 um 11:57 schrieb Frank Binns:
> Hi Thomas,
>
> On Mon, 2026-02-09 at 14:27 +0100, Thomas Zimmermann wrote:
>> On successful vmap, set the page_mark_accessed_on_put and _dirty_on_put
>> flags in the gem-shmem object. Signals that the contained pages require
>> LRU and dirty tracking when they are being released back to SHMEM. Clear
>> these flags on put, so that the buffer remains quiet until the next call
>> to vmap. There's no means of handling dirty status in vmap as there's no
>> write-only mapping available.
>>
>> Both flags, _accessed_on_put and _dirty_on_put, have always been part of
>> the gem-shmem object, but never used much. So most drivers did not track
>> the page status correctly.
>>
>> Only the v3d and imagination drivers make limited use of _dirty_on_put. In
>> the case of imagination, move the flag setting from init to cleanup. This
>> ensures writeback of modified pages but does not interfere with the
>> internal vmap/vunmap calls. V3d already implements this behaviour.
>>
>> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
>> Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com> # gem-shmem
> The change to the imagination driver is:
>
> Acked-by: Frank Binns <frank.binns@imgtec.com>
> Tested-by: Frank Binns <frank.binns@imgtec.com>

Great, thanks a lot.

>
> Thanks
> Frank
>
>> ---
>>   drivers/gpu/drm/drm_gem_shmem_helper.c | 4 ++++
>>   drivers/gpu/drm/imagination/pvr_gem.c  | 6 ++++--
>>   2 files changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
>> index 0c86ad40a049..dda9af9bf5b3 100644
>> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
>> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
>> @@ -265,6 +265,8 @@ void drm_gem_shmem_put_pages_locked(struct drm_gem_shmem_object *shmem)
>>   				  shmem->pages_mark_dirty_on_put,
>>   				  shmem->pages_mark_accessed_on_put);
>>   		shmem->pages = NULL;
>> +		shmem->pages_mark_accessed_on_put = false;
>> +		shmem->pages_mark_dirty_on_put = false;
>>   	}
>>   }
>>   EXPORT_SYMBOL_GPL(drm_gem_shmem_put_pages_locked);
>> @@ -397,6 +399,8 @@ int drm_gem_shmem_vmap_locked(struct drm_gem_shmem_object *shmem,
>>   		} else {
>>   			iosys_map_set_vaddr(map, shmem->vaddr);
>>   			refcount_set(&shmem->vmap_use_count, 1);
>> +			shmem->pages_mark_accessed_on_put = true;
>> +			shmem->pages_mark_dirty_on_put = true;
>>   		}
>>   	}
>>   
>> diff --git a/drivers/gpu/drm/imagination/pvr_gem.c b/drivers/gpu/drm/imagination/pvr_gem.c
>> index c07c9a915190..307b02c916d4 100644
>> --- a/drivers/gpu/drm/imagination/pvr_gem.c
>> +++ b/drivers/gpu/drm/imagination/pvr_gem.c
>> @@ -25,7 +25,10 @@
>>   
>>   static void pvr_gem_object_free(struct drm_gem_object *obj)
>>   {
>> -	drm_gem_shmem_object_free(obj);
>> +	struct drm_gem_shmem_object *shmem_obj = to_drm_gem_shmem_obj(obj);
>> +
>> +	shmem_obj->pages_mark_dirty_on_put = true;
>> +	drm_gem_shmem_free(shmem_obj);
>>   }
>>   
>>   static struct dma_buf *pvr_gem_export(struct drm_gem_object *obj, int flags)
>> @@ -363,7 +366,6 @@ pvr_gem_object_create(struct pvr_device *pvr_dev, size_t size, u64 flags)
>>   	if (IS_ERR(shmem_obj))
>>   		return ERR_CAST(shmem_obj);
>>   
>> -	shmem_obj->pages_mark_dirty_on_put = true;
>>   	shmem_obj->map_wc = !(flags & PVR_BO_CPU_CACHED);
>>   	pvr_obj = shmem_gem_to_pvr_gem(shmem_obj);
>>   	pvr_obj->flags = flags;

-- 
--
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Frankenstr. 146, 90461 Nürnberg, Germany, www.suse.com
GF: Jochen Jaser, Andrew McDonald, Werner Knoblich, (HRB 36809, AG Nürnberg)



