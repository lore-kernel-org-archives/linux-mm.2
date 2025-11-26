Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A3D3D10F22
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 11:43:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 945906B0023; Wed, 26 Nov 2025 06:43:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91D736B0026; Wed, 26 Nov 2025 06:43:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8332C6B002F; Wed, 26 Nov 2025 06:43:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6DD2E6B0023
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 06:43:27 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0441DB9E10
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 11:43:26 +0000 (UTC)
X-FDA: 84152572854.15.DA8C060
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf15.hostedemail.com (Postfix) with ESMTP id F0BD5A000F
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 11:43:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lc7cDo5a;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764157405; a=rsa-sha256;
	cv=none;
	b=mXT9f/ILptA749N/NHjBzTYndf7a1Fx0AC9OxTb5ynhvpGqdDkRX/F0SlKrRcJEKqwxncj
	Zu4lHFXGF9LVQ2Tp5WZYgFSdUV639fnGcjo6eRQI7UYIRpA2LhJVuukMVElqRi4i5X+lx7
	+7jiat9i4Vlz03Hi7jnFWdb92vNfjtc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lc7cDo5a;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764157405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HizHoqpNeWcHTKitT8HzR42sbJzX61WpEmC9UcbHLd4=;
	b=WdIlHiw1giTMptZ2waCT+v+JpgsK/aUYNXYkLZzgDlC6m3eRvp7WsCDAsHgMiW2lldRvpg
	19zSEjGNQhYNtbCcxS5Ru+4W1kjRiI7ekAI+ygrkm0dIgo2QhD8TnmaTnW/Ksisd5N+ln8
	+nSFvu/njiQTqdNb8Sbiy3LBFgHENZg=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-47796a837c7so43744895e9.0
        for <linux-mm@kvack.org>; Wed, 26 Nov 2025 03:43:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764157403; x=1764762203; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HizHoqpNeWcHTKitT8HzR42sbJzX61WpEmC9UcbHLd4=;
        b=lc7cDo5avd1nNROC2qjO6Bg2DIjlrLE812eIkPshk/Mj+Jf1aDJopFg+pa/G4oVv6L
         Wvu/fj0rn9+ltMn0TEmpwploWaFHiX0O3ARniRyjVYBnixboYrJ8Xfh1UFKWTtnYUD+t
         FIPrHn0yxwlHmxqOerKdVnx7fHUzFZYfwjsT832djKaJLENsYMhbdNvGjDQJUQrtTUfZ
         QghlvhX32PYM7FVpLxSJN0e9TfdmAnFl4RHK0I1ssYRj9yALnPHbPcm+n89CLVLcR85H
         tPL6jWgLptIzMnQ/r8SCJ3/DUQl3vGsAryrFDJfU6pd6luJ1qZiWou5fPEELYVbsJu09
         NIOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764157403; x=1764762203;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HizHoqpNeWcHTKitT8HzR42sbJzX61WpEmC9UcbHLd4=;
        b=bjW8dYnCKGJ5XeakTzawpypZnN26jSAPXegFa3kjodCk7EIHfY8p79sIfriyRzTuu7
         sPuzdaBozb3ZIdKoSw9JwJaCtbL9KvMVFsZtesr2J6cRfx0y4J5KFe4E2fT7Hxli4Rz6
         QiStOcKlwOlFupx2z+J0ielL3vx1RIbZc2bRY5ULo0yCHNQlreyPMfrMZlo8Rwle4afR
         b5dYzlBTFbBApD2fKXaeN8sEkZ6nh+t67TOSgT5z0bd2ISN1atrAUb3gxD6akaORCSHN
         PHVpzMpUeyM1EgCRfm4xS1ALqrsF1Nt82pqjXYQgn7d2frN0D86Rt3Km+CyozSCeTzXB
         +GMg==
X-Forwarded-Encrypted: i=1; AJvYcCWCLMhmlak2u0AehVbPp2yMaSbarqsVWrNWn4QVK4i2qbwZB9qV8tJ/FKIVX3c2rWRf27vkuBaS+Q==@kvack.org
X-Gm-Message-State: AOJu0YyeJjuhbBfim1B83qv18LfIArlSyne2luj4nOgxONTHk8mAXbXe
	IasLeWBf0GnA6u7HoLvaga59pFS3cmsA7t82miGUil8Gog+JZHKIDnKm
X-Gm-Gg: ASbGnctdNmOwMUbe3nlRPPdAk8O9CivyJcEt8S00HjjQ9yVyIIQKSAuAu8m8BLj9hTc
	z93u1aENyGrRokSt0MIKw9NFZLASjP/Zv1gkGs8/J7PUhB38mvxEczgUEkS22UpnitALjWaP1kr
	XjYFzhdnXimibGLY85Ww7ygjRHn7tAVqjb32hkWYLUfsfeF/c4d/+h9u2TxKg0PGMFTg/oRMkKF
	yTVOgH95DPZJ6sErOmPrLYnuGhTLBtiaCuuR5emG0rzilmstLyMESbBvQzjFVvrWpdmdGuucJcJ
	6pth+MI9M+XKoUgkE1sG/QnHnV32yLhvZdXT93gaF13KqJnKM5HDI5XAV+aN+/LIgt9XamcTkRx
	RVIT8qYpfDXN1u8AE6Bf6AVAJeOmOxqWqaIsj45Ee1thZvavfw6Y1AsRViL5MDfNeDhVdn97SLG
	6E3wfsa8QHYvg0QSotq0y40U3Fltyz3HGGuBvYq00/KYApGRhVmiUJ8nEuCoSiLLu5epgk/Qcfo
	Ak6Ka7j/eI+A2+RsvR0fuM=
X-Google-Smtp-Source: AGHT+IEHuosbKX5dlS/p+QVNbfewa/DMVBSlhq+jwfkEP+9yI/mOdL1nwp6UE5HbmX/shL7O211Y9w==
X-Received: by 2002:a05:600c:4746:b0:477:1bb6:17de with SMTP id 5b1f17b1804b1-477c01e2521mr209175245e9.30.1764157403094;
        Wed, 26 Nov 2025 03:43:23 -0800 (PST)
Received: from ?IPV6:2a02:6b6f:e750:1800:450:cba3:aec3:a1fd? ([2a02:6b6f:e750:1800:450:cba3:aec3:a1fd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4790ade12cesm51865185e9.9.2025.11.26.03.43.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Nov 2025 03:43:22 -0800 (PST)
Message-ID: <fcf022e3-1d5e-4f66-9f95-49faefda04a6@gmail.com>
Date: Wed, 26 Nov 2025 11:43:21 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memblock: only mark/clear KHO scratch memory when
 needed
Content-Language: en-GB
To: Kiryl Shutsemau <kirill@shutemov.name>, rppt@kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, changyuanl@google.com,
 graf@amazon.com, leitao@debian.org, thevlad@meta.com, pratyush@kernel.org,
 dave.hansen@linux.intel.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20251126072051.546700-1-usamaarif642@gmail.com>
 <md65ppfkqim2kepsx6igvezpcnr4hx3g2dxfdojsgx4rligwfg@u5dejfzmirfc>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <md65ppfkqim2kepsx6igvezpcnr4hx3g2dxfdojsgx4rligwfg@u5dejfzmirfc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F0BD5A000F
X-Stat-Signature: da8ny9sa8q4ak8wz8fkb6shi573ti3ii
X-Rspam-User: 
X-HE-Tag: 1764157404-799475
X-HE-Meta: U2FsdGVkX18UpXbObPRjT74dpauBNkqo2UVzNjMswSezFTfx/QAMlakD4zvzG13eo29irp20zJu0nReSnSdpTuSizy/pUP4vKGC2lZlsIddh3Dt09Ji9yvZ+XGyLLEkbG2HveJ/g+Tyyl00YKcFatCdCFuRM8Eu7aWlYZZlkJGUvq+sxJ6DajizuFWlkrzyprmsu2k4hqbO5CKnL9YHQb3E70JNw7cnmhR5omBUB2AOoyCVIvr1Dtpnd3dZAdmVm6MxjzM1KSe3qt9rAe7uC3V5jmU1ugmzBpPk/RVMvMSLmi6/+zMZgUhaUhLnM1zbKFuXIvbynkyKFfddCmo5mAcgfsHpicT+YI+LyYiQVAhDBGBdSeo5KTXH21jTgMXp/uZWl7jO0Pn7gr9WEr6IhD6pthk6PC5Rn6KBJA3jtzK08dEp4cfHN9hrJWn6Vzybp3oUO15Koskec+mI94TAXGHFzuqBbvPfq6vlFEqkqhkfjvWEhtrcXeVOQ2bOgD2zsrpAYwfXL1uQhgGtenuYLfDMcDkuvpw9doK4fRrENOwlRkD2fzokHGDl8KBgueedVY3AaDDgmaOpQiq/E3uWLO13PQIev5waB0Cb8SZp0W8jX+xwT8SU5zeLlmSV37O3GL3NxP9K1vwf5WvTy49xu+IOHnIKtrYY6miy0o7wbEr6q70ptp6EIh+n7gxPMDw1pJw9dypAUwiDaSqjIDO9W5ulX42qYR104OjpErls6yXteOkbiHCR1ZwWItvz66IIkj5n3ixAQcs+G49Tsu4lmuknhK4NlAiJDe+V6iVTm/SK+WjwxS8q2/oLaaMeeNPm4kTuZDjf18BUwHmHb2NC3UqZfR2AUg1kqWdZxAaZrRjSB38yaVTT/KkIzFmh4qjzZjEU+RK4ryGkyriSUKdH0IoPliKY2+xmOSTnWsKl2DwgwS4fYprqkxehxkXDUjGp4ChmAEdpKxq/LQp3+0ci
 dNv6nS8I
 fp1fbR8vPTwX2Rq0UhfIQl+msUWLNvh4Sk7rhDBvjKMSAx+S+mmh2nToF8j35ZYHPCOillOvz9ykPoOHpNjfgS+hIJ39DHtDhl+l20Qg7AgjlN8AEAHEgUhzUZfvtvoGpZEqFaHQltvKX/kD4NQYJGR8hjs8iTXKvXyHujNDI6SRY+fDVFLzSKm1srxgOxiSEqXxACZvb6JQN7ehTHKCGwvJCmmZK2BJRwN3x5Tdd/relKccMRJt/VymJam87xnqaaxYo/JfgtfduO2xlQNMuricqk8hsDMZY3C0mhbMh/27KqRff6EjEJMrOKFJwQfOKkN0o98awMBrOVpUkEjLedSOuui0JMrAgQXswjAgwo8LpXr4GCFrYYaM/eHps8Rht2Iiv8SyCW+KcGvGzEpydygA7rrpL2XQQaS1xqhmsrnBLZNqoq+aWWGIwSwYzyka2Ii9auJZBGsJeK+F+R1GgW5hzJCeZJ5R5oN/6G43Q/kcCIu7J1obUWjd8OZZvN1wbuIQr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 26/11/2025 10:40, Kiryl Shutsemau wrote:
> On Wed, Nov 26, 2025 at 07:20:51AM +0000, Usama Arif wrote:
>> @@ -1126,8 +1126,11 @@ int __init_memblock memblock_reserved_mark_noinit(phys_addr_t base, phys_addr_t
>>   */
>>  __init int memblock_mark_kho_scratch(phys_addr_t base, phys_addr_t size)
>>  {
>> -	return memblock_setclr_flag(&memblock.memory, base, size, 1,
>> -				    MEMBLOCK_KHO_SCRATCH);
>> +	if (IS_ENABLED(CONFIG_MEMBLOCK_KHO_SCRATCH) && is_kho_boot())
> 
> It makes me wounder why CONFIG_MEMBLOCK_KHO_SCRATCH exists? It seems to
> be a proxy for CONFIG_KEXEC_HANDOVER which is the only option that
> selects it and does it always.
> 
> Can we make s/CONFIG_MEMBLOCK_KHO_SCRATCH/CONFIG_KEXEC_HANDOVER/ and
> remove IS_ENABLED() from this check? Just is_kho_boot() is enough.
> 
> 

Thats a very good point! I imagine it might have been for maybe debug purposes?

Looking at the code, CONFIG_MEMBLOCK_KHO_SCRATCH shouldnt be needed. I guess
this might be a good time to clean it up. If Mike is happy for it to be replaced
with CONFIG_KEXEC_HANDOVER (and removed where needed), happy to send that
for review instead of this.

Thanks
Usama

