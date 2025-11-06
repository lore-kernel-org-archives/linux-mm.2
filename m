Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3658CCF9F8
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 08:43:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD4F38E000C; Thu,  6 Nov 2025 03:43:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D857E8E0002; Thu,  6 Nov 2025 03:43:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C73EF8E000C; Thu,  6 Nov 2025 03:43:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B7B768E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 03:43:29 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5A8A44B656
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 08:43:29 +0000 (UTC)
X-FDA: 84079543338.16.6A65149
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf30.hostedemail.com (Postfix) with ESMTP id C760280008
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 08:43:26 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Qx1DyF8b;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=hz83f4WF;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Qx1DyF8b;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=hz83f4WF;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762418607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6wxOKvhAdm48qlooVKjaBjyYeH3EW3cuitf/SbPCNNM=;
	b=eoiSE8KPxDc+2nDun5ZjPPP0E0kRl6SFMUkjUrGWN4slSYUaALN4BdrPwBx/LTqHvSJHMl
	Pk+vdrzfdDLVbwGWp95nmKrpF6VNtJt503sDk6d8GZF/+BREjNfHlBcizrfmyhTOx67xX1
	j5wUeJExMkxYZpT9X85X5KiUkuHV8f4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762418607; a=rsa-sha256;
	cv=none;
	b=c1Oes+00cEHG7eqP+Me8ZcygAQXPJ7EFMYFg+o1XgasKeflaLBeObMaRhXbMz0ypt6YooE
	SM/82tLpv7RFwxO1qUsPbaYsRI24fznaTV+rcXBb32JaVz9LO9I6rNrvLDNmC/cripGyoL
	E9V0LkmSyfnCqsGngCi1VdFBPF76cl8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Qx1DyF8b;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=hz83f4WF;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Qx1DyF8b;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=hz83f4WF;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 341A221190;
	Thu,  6 Nov 2025 08:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762418605; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6wxOKvhAdm48qlooVKjaBjyYeH3EW3cuitf/SbPCNNM=;
	b=Qx1DyF8bQCYLj9t7mZCAvvFrws8+n1jXO5EwKpY8+rQEg6oXH1nDLJbO6h8Nzx05Hd+3qU
	VoUQ66QxjBoEciDBd6vd9pIqD9WakEc8eS/VshX6hLW1DnGpHNp/AuoWOPNtqxgejDzwrd
	tlmVZ/8LbBlZlwLcIJoNdsqJYfnnW/o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762418605;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6wxOKvhAdm48qlooVKjaBjyYeH3EW3cuitf/SbPCNNM=;
	b=hz83f4WFMbiUeZtQU2g58YEkl2m37uvhtVYbr3fl+k+lJ2fwYEi8ZNC6Yce+LjAUzwkCMR
	z0Is4VktCuM5Z0DQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762418605; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6wxOKvhAdm48qlooVKjaBjyYeH3EW3cuitf/SbPCNNM=;
	b=Qx1DyF8bQCYLj9t7mZCAvvFrws8+n1jXO5EwKpY8+rQEg6oXH1nDLJbO6h8Nzx05Hd+3qU
	VoUQ66QxjBoEciDBd6vd9pIqD9WakEc8eS/VshX6hLW1DnGpHNp/AuoWOPNtqxgejDzwrd
	tlmVZ/8LbBlZlwLcIJoNdsqJYfnnW/o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762418605;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6wxOKvhAdm48qlooVKjaBjyYeH3EW3cuitf/SbPCNNM=;
	b=hz83f4WFMbiUeZtQU2g58YEkl2m37uvhtVYbr3fl+k+lJ2fwYEi8ZNC6Yce+LjAUzwkCMR
	z0Is4VktCuM5Z0DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1271413A31;
	Thu,  6 Nov 2025 08:43:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ptHYA61fDGl+ZQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 06 Nov 2025 08:43:25 +0000
Message-ID: <a1922c8a-6cd1-4d79-8a7a-7462a1e791f5@suse.cz>
Date: Thu, 6 Nov 2025 09:43:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] slab: make __slab_free() more clear
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 kasan-dev@googlegroups.com
References: <20251105-sheaves-cleanups-v1-0-b8218e1ac7ef@suse.cz>
 <20251105-sheaves-cleanups-v1-1-b8218e1ac7ef@suse.cz>
 <aQxbp0cikSkiON5M@harry>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aQxbp0cikSkiON5M@harry>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1u1wtad9n46uxwxefaescqsau7f34x9m
X-Rspam-User: 
X-Rspamd-Queue-Id: C760280008
X-Rspamd-Server: rspam10
X-HE-Tag: 1762418606-425136
X-HE-Meta: U2FsdGVkX1+BBHxSuTvGFZEHbtyUuL078XbW6Do6UfQ08Y080p7ARTvIadvP/quhPSL2VE0TGxvoQTZx0Zz3zuPJkP5iJY2Z9Q8jvWDaMBLKBNl3IDJu7GBOKoMiDhwEH24sGIU0ubL6GNOfMVQCviKW5C6u4mGXPQ/6LOsXqawW4UrHuoF77iNcNcQBXXnVdHDX23jd+isSCo4rB8oF/PasmD+ACCukbkx0SI/7+0LeCf/SWEKA4j5/vmGi8cAVogie+xNNe3v44eI8bHlP6hbKqkeDzInC86yPSwqWWwNIakiCIMb4BMWnHBQZGB8cDc2gjxpSjOsZnfaUSjl1uuSciDG4Pof32gEbGa+Czj0PEvGU0njte/OWnB37QsW7QIJChPNOZXpr6nbxfSViUwZLdUkl1xyi20sugFpMJhQzN1H+QKqOBAvarUpuEPhS4o6iqAvReVCLg7fOrv6O1iuq2wvejDqz1rTooSucfsg0NnYY/8FxVvOlLBO1z8Dfr1oclJgjSjyAgPdFVhfeu0sD4W3vk3tfwzNQFKwIcBJ7MepiidkFN5LTjStydD+JagbdVr4q66a7vUarsybVDdc2eXAfJ+x0AH+dsajtAm7OtNc6Obl2USAz0QZ0c8Cueq9XTvu8fvbBcTv5+1ytgnZnhbbls2IuikWkcR0ad3LkPqOufMSQ0dpyPwRrk1Cdna9bLo7NnVP8E8OHKHoRFCWhCfLIV0xWPdxlpr3voRKgzpdrKCfyYnapk88IUKXUSpH42whhEex3hVjQt3cfyUnEttGegcK1klJ8RS8BF6MNDq8tpuuhc4f8g/7QKNMprv3soLa4RD1VqPuF2B5D+xkJ5HAGSBZLsrTii9BQ+cRIcDIUkMog8Q6hRtrSh1Wxly3QPx8DWooKO87zg3j3H8+q2HBPu60Fo16OSmFNJX68hc2fQKnZa+Ae3bMCwZB0APyMTimZZfm18eLEcKg
 uTgIsQEW
 XbfgIVEoZYOxIpg+ou3teooJwrPWE8gYSTnbDoD7OhEBAYmFROQb0NbqcFgIBxaONsXrKFaRY9eAqrWXxji83EZbfk5CvKZvmXrCkaE0EzdU8dWXq2EmG5patShh66Cx8u+ir0/AIp3AofEcWPopnZiK3xNdRrAqcc49Nltsg7hNmn/VN7Fr1n1cKLMtZYCTjWrk/t35aezfDVUhEvDtXG8XFnZ4LZcC4gP0xtXcAGU/QkAEGur8pRm891fF0pFFKA8nxm590qvcI9/6bkT4lBMAjw0TlVcei88ymcwCwlXxXvgU8a13RnT+5owZbRcfIuTSoY+2EftvZK1Zz1YA9KTVDtAyM1/WFzjntkBQyDLNWuY0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/6/25 09:26, Harry Yoo wrote:
> On Wed, Nov 05, 2025 at 10:05:29AM +0100, Vlastimil Babka wrote:
>> The function is tricky and many of its tests are hard to understand. Try
>> to improve that by using more descriptively named variables and added
>> comments.
>> 
>> - rename 'prior' to 'old_head' to match the head and tail parameters
>> - introduce a 'bool was_full' to make it more obvious what we are
>>   testing instead of the !prior and prior tests
> 
> Yeah I recall these were cryptic when I was analyzing slab few years
> ago :)
> 
>> - add or improve comments in various places to explain what we're doing
>> 
>> Also replace kmem_cache_has_cpu_partial() tests with
>> IS_ENABLED(CONFIG_SLUB_CPU_PARTIAL) which are compile-time constants.
>>
>> We can do that because the kmem_cache_debug(s) case is handled upfront
>> via free_to_partial_list().
> 
> This makes sense. By the way, should we also check IS_ENABLED(CONFIG_SLUB_TINY)
> in kmem_cache_has_cpu_partial()?

If you really mean testing CONFIG_SLUB_TINY then it's not necessary because
CONFIG_SLUB_CPU_PARTIAL depends on !TINY.
If you mean using IS_ENABLED(CONFIG_SLUB_CPU_PARTIAL) instead of the #ifdef,
that could be possible, just out of scope here. And hopefully will be gone
fully, so no point in polishing at this point. Unlike __slab_free() which stays.

>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>> ---
> 
> The code is much cleaner!
> 
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> 


