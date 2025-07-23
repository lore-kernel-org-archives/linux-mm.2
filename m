Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE923C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 15:13:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60CD98E0030; Wed, 23 Jul 2025 11:13:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BDE98E0002; Wed, 23 Jul 2025 11:13:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D38D8E0030; Wed, 23 Jul 2025 11:13:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 412008E0002
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 11:13:11 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9B63B140119
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 15:13:10 +0000 (UTC)
X-FDA: 83695872540.20.CFD007A
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf13.hostedemail.com (Postfix) with ESMTP id 309C920016
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 15:13:07 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=fNZCyw2S;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7JljtQ5L;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=soEitRL0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3D9aR+au;
	spf=pass (imf13.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753283588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pnw34Pwnw+OLEEFtJ5PF8S2TL+K3w03RLCu1xE/WHec=;
	b=Aa3HkMeKINdeWIn60S54jm6Rr5NmJD7Q+eLLffBGrTePKh+kToh2ptor+FC4pNAtQtREFr
	0cB8Ft62IwUTRzEvv7j5bHQz6Vbo/b7vKIABMSGeivtteUYdu58C1oK8XAkJ6pu8rukP5z
	SP+ykl6fKYYcJtAnMNWSHaS/A1CMrc4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753283588; a=rsa-sha256;
	cv=none;
	b=L8DT7zKFLgYAtcHkshMdsesiU9nMk5bdfnUWcgT/JbVkcFZmx6hct8f4OIEx37MfFEgh6Y
	zr/8cLkCeopyOZTlkE3lSByrENmB4eBi/XXdv14bbwYNRyFpnl8RfWBDznN5hNJq+PPOMy
	rUSZvZq8/9LUWPCSHq2uIgihwTJWpbA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=fNZCyw2S;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7JljtQ5L;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=soEitRL0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3D9aR+au;
	spf=pass (imf13.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7B6F321296;
	Wed, 23 Jul 2025 15:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753283586; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=pnw34Pwnw+OLEEFtJ5PF8S2TL+K3w03RLCu1xE/WHec=;
	b=fNZCyw2SGNkIRROvzgOTdjZOczHxbDkXO2kblSToYa+NRLHYpyDOVgOn7mTSIQKQCxAA6j
	bkxLOKxDXvNljT6At44WDHp21DXwH6SCDTDvsTCIKrthcXzpGhBUSYlfCOBhiSi63FkKwv
	hXk4nnnHCYU3yjkYS5QF/MU4ktrNFUA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753283586;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=pnw34Pwnw+OLEEFtJ5PF8S2TL+K3w03RLCu1xE/WHec=;
	b=7JljtQ5L6hk9z5yfW0iRYepbYO7B8+fZ+eeQmEjYPImi99GnZrmnyQQ4vHnrrzEmV/w7bY
	HDa09UP5ZvZkghBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753283585; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=pnw34Pwnw+OLEEFtJ5PF8S2TL+K3w03RLCu1xE/WHec=;
	b=soEitRL0NeqmPXkghjdqCMj+3GWzqD48rRHSmXZUJ9gyTmAvqkkB0lR1H33Oe2GG8EVIVQ
	xb6x9V1YN/lhwzOTCIjKXjeVX8ZYnEiODQ9XdSEoW4+/0xHyLjvkDPnpelSWXgEcbSt6k3
	RQCZVCW9Oeampi6B9FKmiUaN4F2BmvI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753283585;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=pnw34Pwnw+OLEEFtJ5PF8S2TL+K3w03RLCu1xE/WHec=;
	b=3D9aR+aunc6FDx8Karric5IQ3vDnjKVnX3xjEU63KIGbX2/2jdclUgBFYn64ARaGC4WddC
	HHo1kyDwwEnlCmAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 67F8013302;
	Wed, 23 Jul 2025 15:13:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WWEHGQH8gGj5QAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 23 Jul 2025 15:13:05 +0000
Message-ID: <2f5512f6-1f0e-4e54-b9c3-8a0501843bbe@suse.cz>
Date: Wed, 23 Jul 2025 17:13:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] MAINTAINERS: add MM MISC section, add missing files to
 MISC and CORE
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 David Hildenbrand <david@redhat.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>
References: <20250723095823.21940-1-lorenzo.stoakes@oracle.com>
 <abbaed17-955a-44cc-9593-10c1afa4c6a3@lucifer.local>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <abbaed17-955a-44cc-9593-10c1afa4c6a3@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 309C920016
X-Stat-Signature: wde5dd3jzpm5yo6fyn6xyxcurf9jjxwb
X-Rspam-User: 
X-HE-Tag: 1753283587-757721
X-HE-Meta: U2FsdGVkX1+j2m2QiEY/O0SMxMCE7WbNFaYlka+uL1bMEvROEgajcUarCJxlqJCDFpCDS9utdRlurjidHtqYgLF6cdOvTlD5INNaalriFcKGJVJkGkQWrAjegrRpkAhuYIdQ8U04iQRe6cjffO+1xPea2FkaEwEt1aC93FI2UXhD7JFY1imiRtugD8R5Sl2iUwMr7wlp5cs5crJrxZzmnsrsgkV5s+IbgCcHVlVmVk+M4Nrdcu2evmd5LWVFoHZH64rhY/5wuIcOYyvnF/v7rJgzVHe26MS/1XDZgDR/YEkLBAW4upq8fveVJswF93cKaW44LDB6f1IvBR/GaC95IHQc/obAM2Q/PiCP53mCYqWWwGyX39rG4aTzXPuApAXy00F5tpB8xwDvef3iA31u7YAG38kCsp6nAPmhvTA5B/aIbGn/GRJj/W43gOJZFHb4Fy2U9GrpnVPZK4U7G+6smvUep7O1lxjTyndlOf98VnJDiUo5Ou8CSU+a7jTFKUrq0jM40giuVBS50xLrhG3FmTS+EAyicc39qvwcyv23nc4NnNHkKL86W8VmVRHkdu9C78X6Gjx//34bzLG8j5Go7wvWgLZdtWwhGiiy3SKqqg6v3vgzen7FG20Vc1K9aSKRuyZI/zb40Gxl4krEfrG/0tPYYiFVDB78JRupZLtQgEB8DiOgiNqNn61UkIJi93Sw71rAd4AGhW6BOZirFn6dJDENMkDcjFUrHx0EsLfkn6ayUC+B+T7BXpjT1ZHytDXe9+OZv5MtXkwSMHMVjtFnvMRXPscS6djM2dPlqWVwturWFUqhGfgX5ubPkBc42q4Ly3ZyL4hLm1mAtk3D9GOcQIKtMCGXuZRQTYv3AyQnuHxY5Xh7ZouJFChjnNo0jmRwbzOsCnfa+3seKAeaP4YHKyNGiG34NHgcF265iXTWcTevgqdWfWwBf2p14eXdVzDKdDVrzu4Awj/GUTL4Sgh
 6yFig1O6
 GGbdwW4KMjZ4uqQ4pMlMs3JER7r8SaaWi9WIav/fOfm3xn65yNn623WMq9IznOsH39QWC+NEuGALA/U6yrNDwS0hukbkzi7V4iP5IPpkmwOfyZdZcT7DmBkbAbVxK1lgQxo/AYgAyKePYDGFOc+fxZDcX0lT7toT+92g+kXrp+uo0y65YpoK1XzpjCR2aW6w50i2jWZguWnJtdBdoO5zjZ8jw+ShX5JQBXPC+0CM+PxYV82CMrsLcUUTzd+y6bOnv7ZOceV5SGxureRsSa6ceSsKsLOltLptZtNlHcuheQXUBElBtsnE+STDVFPj0KCPDlPefGZWna6GXLXPGCTZoIN52CdcNK1QUwaLZjcbkwOwBwqwZfi77mRXaQg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/23/25 17:05, Lorenzo Stoakes wrote:
> Hi Andrew,
> 
> Please apply the attached fix-patch removing duplicated header files
> accidentally included in the MEMORY MANAGEMENT - MISC section, as pointed
> out by David.
> 
> Thanks, Lorenzo
> 
> ----8<----
> From 9a94ef4511f6d0cb39f5edcc963b2aadc11febed Mon Sep 17 00:00:00 2001
> From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Date: Wed, 23 Jul 2025 16:02:27 +0100
> Subject: [PATCH] MAINTAINERS: remove duplicated header files from mm misc
>  section
> 
> These are present in other sections already, so remove them.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  MAINTAINERS | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 5a9d4c57add4..5a6cb44635a2 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -15860,11 +15860,8 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>  F:	Documentation/admin-guide/mm/
>  F:	Documentation/mm/
>  F:	include/linux/memory-tiers.h
> -F:	include/linux/mempolicy.h
>  F:	include/linux/mempool.h

You could take out this one too as it's going to SLAB via my tree?

> -F:	include/linux/memremap.h
>  F:	include/linux/mmu_notifier.h
> -F:	include/trace/events/ksm.h
>  F:	mm/backing-dev.c
>  F:	mm/cma.c
>  F:	mm/cma_debug.c
> --
> 2.50.1


