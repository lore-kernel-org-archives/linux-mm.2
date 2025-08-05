Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23FABC87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 09:20:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7088C6B0099; Tue,  5 Aug 2025 05:20:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B89D6B009A; Tue,  5 Aug 2025 05:20:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A71A6B009B; Tue,  5 Aug 2025 05:20:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 480616B0099
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 05:20:45 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D43A31A01CC
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 09:20:44 +0000 (UTC)
X-FDA: 83742158808.05.334E667
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf29.hostedemail.com (Postfix) with ESMTP id A8F91120004
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 09:20:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JKYLIDdF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=W9D36PnH;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sNtts3JH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iBbEuD6h;
	spf=pass (imf29.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754385642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PHMRVK7QVsCp1KUp4tnCghouR6JYlszhPaJzdNosRRE=;
	b=2a32Fv2/zyBuTPPQ7sN3B2rWoqtuCbwR1dv03p8101xdzpvPOwhKnP0HYPvqdGrF6ukh8B
	6RRVop4oMtdhvW6CiPnl4rp7fCqORMOPiV3TECxx5kxlBQFUUQv+mgS/I0w4f5l8jLPBs1
	bzCnHU7CIeenawawfdmY1wYdQA1nWXI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754385642; a=rsa-sha256;
	cv=none;
	b=tAHAor2X/yjHqN6+pI0zbL8GcjMQE5wFvJVYV3Ri/kW6mOzmk65tid8gxnEUGMKj6WssBf
	960vnvin/gloNzWrJ1BivNJdePm6H72YarY4cL7y5sbtcjLxTLcVY/FPe/XawB9G9NqYku
	5kl8bMH/nfbLVXDbkHbm5a0t5OtRbeA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JKYLIDdF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=W9D36PnH;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sNtts3JH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iBbEuD6h;
	spf=pass (imf29.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EE60221235;
	Tue,  5 Aug 2025 09:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754385640; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PHMRVK7QVsCp1KUp4tnCghouR6JYlszhPaJzdNosRRE=;
	b=JKYLIDdFNs3aYZsa6GvIKNRX/cwlIWnX7FxSvXIq3suGXbfTqxwOJMyuwHtpwCAM9xjFNi
	xLCrwNc9kYYtFh4lhdCeYRWby/Zs7JEcU2EAcKoOD4kxXoZZZLqyA/97mi86LXue45vuSF
	f8AOwB4+02DIcC3uO5T2zVh3YUJ5sqo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754385640;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PHMRVK7QVsCp1KUp4tnCghouR6JYlszhPaJzdNosRRE=;
	b=W9D36PnHk3baL7DuUyr+HqePGIz/D9842my0AB3oYO9sgmWmuNxfoifsnby6agNFoX9kEn
	rCuEpPCAhjZi8iBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754385639; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PHMRVK7QVsCp1KUp4tnCghouR6JYlszhPaJzdNosRRE=;
	b=sNtts3JHY8JNB1Izae96sbqpsMi7G2NcXCderJkWaCw+EUDX9DXMBzWA78rKB8saNuU7HJ
	68GHr92raH00HKny/JUEV+4bMmN8Xx54HX9t4rdwS+1KjZmZDw3PPJegpimf/ppJ2gr4M5
	5eDHPg3bfwy33oT6H2v1v8uBgXXheb8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754385639;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PHMRVK7QVsCp1KUp4tnCghouR6JYlszhPaJzdNosRRE=;
	b=iBbEuD6hS5eB0gMuFdHIdxCKTewxxhF+o81zBLSFRjEkFPDzRkMqNoekqYE2IdfwIPXge6
	smG0P5aUgGKq2VDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D3BA913A55;
	Tue,  5 Aug 2025 09:20:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ci90M+fMkWhuSgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 05 Aug 2025 09:20:39 +0000
Message-ID: <3c6100a1-78a3-4211-a62d-eea07db91b62@suse.cz>
Date: Tue, 5 Aug 2025 11:20:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm: Correct misleading comment on mmap_lock field in
 mm_struct
To: Adrian Huang <adrianhuang0701@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Liam.Howlett@oracle.com,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Feng Tang <feng.79.tang@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Adrian Huang <ahuang12@lenovo.com>
References: <20250805084726.2054-1-ahuang12@lenovo.com>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20250805084726.2054-1-ahuang12@lenovo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A8F91120004
X-Stat-Signature: p9jjh8dbe7zgz4wwbt95oqpe7fc5jcna
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754385641-628906
X-HE-Meta: U2FsdGVkX18vgs+asMP2hVml+cyqRx4QaBk0017yukblMyNddfkM/FCohMK4lKLSQFKYpB/a9j99TAynFIK7Xt8Ybi/l3wCCZ2w8znsH4k0SMbJ/CXKQpPkrmNqapWcS66WSwgpcWnR1drp/3JnjblibBIguyJncokXl3b8LZMA0Fodpb3cZkXYjrbC0MYszs6UgvAmzYl210dw+eXxM5XaaAIjyWXXTaM+t3+BBHWzo+QPWgugJfWUj2udPXCjkdXP5d8vw6pwKJGOMiYUu1N29pLSfGvRuDkqy4BRBx/nr28dT+M7hPN/4K9DDNqsoUGKjFw3c2Bf/Id9tydyZbhg8ommA7fT/j2xt6vz4u4r+c2n9my+NEmmZ7tcptQkLHwP4YCN7OZ4w0orqRWrZ7bbG+f5tNg2UFqLVSMNrQqrcyRPcgrACcOrgDA9TQC8mhQ710l1q17ezGpo8AJ9F0BboO/Bd8dWI/g8brdRsOB5VebXfCoTNOr1L/3TcjznKb+9PAbDlVD2/caPQrIVFsojZOusD9NF7lpvvJvnQeuK0gJ5F4pyWRG7K3jnr3WSRNvhpGrW2Z23Bf+dyYlNG6IRTo4/vyDq0fZ6UTKmCjRWfTM6cFWg9RV4QzFVimY7HrlnuQvEyhmm4+4imRuz2WnCTTN3J8SKO7fMpaF/KMNqTdZuQHNqZzSxfvO2iz5EtGirHR7rRFp+9M/hkTeHGcvCGbJ/bj5bFm6lQYzUKTQgXbs1TpzVSv/E35HKLETRI43BREYpLJ/jzUiS43VikL/lME22drGSbLiUuF93CHe0j9pAgHqR5xvH/LWwjtpo45f/HP0a06ZzHNc6sHNmnmAhr1trgOit5MI2ZS8lqX14RNDSm9c7brJrKenJBSf+zuaq5nFqWPmfa+U+SxuD0sQD6gCBm/kESamQ48dlg52eJoWSS/D4XtarK/S+tVG3RT1tkarDbMOP1C7UG52q
 NrbNU/dx
 MiymxU6WdmKPIlrsnXqFRsczIJi8HlYAJZrexUJAQDSBRtEqq93F2UXRdCMUeR+B+Cc4BY9RpYErTb88sGbeACn9jGoVt1D2IxAsar/G3ummUjpsmLwd3/nCVoyvrJm3166yiHR+zFKPe7DGPXPu6Zj7Gj6kXdagWYBVIVjN9IwisV3UWmit+1J1GCLmllRzHKJbnmEbpKIKHIdXJf5aO9n0UKaBCw/2mBaDS60YCmZ9MlR6c3kD6NhX6aNX0rfEojXZuD3u7T8pY9vUBddgNgg4s8PIbUayPNyz1gpoe2Rwhn8iObqeovLGJEw24JOtJMDlqs36qHcPvtxCKU1GmeIChndu15kaM4IU2rAL1nG86sSEVzH9wRLCf3N4ojnqcmodBj3QP5j2K6FmiiybrxE8ZB/PyeV0nn6DbpNr9qo30RVZ7uQl9GM/8WfVAskbBzkkKgmQWg+E+BTsbH8xqMXp6hw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/5/25 10:47 AM, Adrian Huang wrote:
> From: Adrian Huang <ahuang12@lenovo.com>
> 
> The comment previously described the offset of mmap_lock as 0x120 (hex),
> which is misleading. The correct value is 120 (decimal), and using '0x120'
> could confuse readers trying to understand why the count and owner fields
> reside in separate cachelines.
> 
> This change also removes an unnecessary space for improved formatting.
> 
> Fixes: 2e3025434a6b ("mm: relocate 'write_protect_seq' in struct mm_struct")
> Signed-off-by: Adrian Huang <ahuang12@lenovo.com>

That seems all true so

Acked-by: Vlastimil Babka <vbabka@suse.cz>

But I wonder why we just hope this remains true "with some kernel
config" and don't employ some explicit alignment to make sure it's true
(except perhaps with some debug options like lockdep bloating the
structures, but we don't care about perfmance in such configs).

> ---
>  include/linux/mm_types.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 1ec273b06691..ec90bbf22e2b 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -1027,9 +1027,9 @@ struct mm_struct {
>  					     */
>  		/*
>  		 * With some kernel config, the current mmap_lock's offset
> -		 * inside 'mm_struct' is at 0x120, which is very optimal, as
> +		 * inside 'mm_struct' is at 120, which is very optimal, as
>  		 * its two hot fields 'count' and 'owner' sit in 2 different
> -		 * cachelines,  and when mmap_lock is highly contended, both
> +		 * cachelines, and when mmap_lock is highly contended, both
>  		 * of the 2 fields will be accessed frequently, current layout
>  		 * will help to reduce cache bouncing.
>  		 *


