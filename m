Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0631C61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 22:33:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 247606B0088; Tue, 25 Aug 2026 18:33:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21F1C6B008A; Tue, 25 Aug 2026 18:33:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 111606B008C; Tue, 25 Aug 2026 18:33:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E0AD06B0088
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 18:33:54 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DED401C0798
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 22:33:52 +0000 (UTC)
X-FDA: 85141245504.21.E70FB65
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6C3DA120006
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 22:33:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=dYWWMJLZ;
	spf=pass (imf29.hostedemail.com: domain of wqu@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=wqu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787697231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AQ9BECpJKrpP12MABcUEh0lAKrEb0D+i2kVCVQ2/O4k=;
	b=OR3O35ON4gOj3zT3LcLD9pIbQJPpvx/wAWD8AGyaDbLJMhvkwmDOajYZY7unXWPUapQZMO
	VoIOYTB8O0EsczBZ5WLOT8/z2yImJWjkTUfBpQQYIMEdSeyRXhn8SuHiHmBcSjVXn4rCdJ
	1N/q+hKh0EYm/m7bX8Y7WcEzxIK9+SI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=dYWWMJLZ;
	spf=pass (imf29.hostedemail.com: domain of wqu@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=wqu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787697231;
	b=muRedCfvrKc+y78yIxQ15lGhk40HZwZDAN3Kix0w5XqCP77nu4Zi4huSBwn/FdvcbwJQxk
	+FNcXjsJtlgE5RBa517q4U6BH+w+3dMFR8gotVb5ZfWuCOSOFnWzEyHe3v8ly+5j6UkIZl
	A012o4mzDJ9biRyQknuXzS8j/jyb7ms=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-490cf322ed0so2037845e9.1
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 15:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787697229; x=1788302029; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AQ9BECpJKrpP12MABcUEh0lAKrEb0D+i2kVCVQ2/O4k=;
        b=dYWWMJLZr+oV4B6ECnOf4V8UqQUC3KluKvA+aAFWxr4X3V1vqTs/SkoA+QVfkBPI/X
         IFUEaZcmKP+CjjV54gHvSWxrCqQ4abynklV5bQLi5P2QB9jOhfeuYFXC1aiNNIF+yoYw
         YU5f65S0qEfzn1PW4RReBb0jw8jxfTM0zANGCaJQxyI0hNDJ+hQ3BPIbVeeGqcjvyuyu
         KIEQG+Pz5K4awBAwaYrBKeidxNRO1jRoVP/ac9kWU0vctNlbzFJK6vVs6/hiuKJmuDcq
         rFevibLOs6cLaykPgr5qluUimKgqoYlB3mW16mRu2hXL0cbTY+3liZmcmJ8INH/VYgCa
         AO3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787697229; x=1788302029;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AQ9BECpJKrpP12MABcUEh0lAKrEb0D+i2kVCVQ2/O4k=;
        b=Sl4byqf+jFbxvTKj4FVnrdDtiWob6y+RaBgFbn1Te2v5l9/32JXJoTL4NGSqwIRLU/
         sCteoGVD2srNs5AFPQyTvug4B3l3idljk3it4VbqVhiOum8fXoi6mVRoxSFsZQ4a+GO/
         ZV49HJkbn3zpevciKeosqO40r1Wl6IV3/PLBwI2r6GJx933xMOhN0Ol7XuGzj9ff0u2y
         yE+wapz0GtyWSNg5ol5CtwiIjDghmKuJdbAZA5c5OMyieOv9+tDTZNqiVc7z6SdmLj1K
         LufYXuGso4fA+4E88bUvKy6Ly2z5+dXYMU8fqoWQ9n1og9U2OMGQCr55oIYbPOGz/Vb/
         GKzQ==
X-Forwarded-Encrypted: i=1; AHgh+RpimgOnXO+yVxiVCu5fgEj4hHHLBA9IybbY3EEqkbEG13pJCOgnIupp49T802fauDFD88FaJjYQ+g==@kvack.org
X-Gm-Message-State: AFuF++k8r6FdKXcfdEKKIebOVwGRpD9VT2dux+GjGWJJpY6S39WhLrSD
	BDfRM5yfzaRmAArr4p05CBRxHJN2aufVUu/XXVTfGN3hgrT/VIFiCh4uFJyVUY8g7Uc=
X-Gm-Gg: AR+sD12D1hBt5AF2/sHb+I0saBP/E+njosf8OQdvz4db4Vv0DkaqGllRjChpshVzSSx
	1QwD4m3NAauorI4DLpvP7kzacjYs6IviRoy2BPuY4cZvlaqBQHvcWUJlxa+cL92XQHSmhgXzgXo
	HvKM4fkKYWxKuYGsgramdQMPOc28pM8kLF59xvn791kUbtqIHNr/QMiCMVlQGUgBI9ZQgNyQybO
	FiydvjpPYJw4X1vjzS1IMb3H/DZX3S0IamWNuVLUHbK8fnvcpG8ibQXZ0y8rLyE1+Sl+4PQy3cZ
	/TkSmA1v6bQrahchCZDJzmq89oBI1g+ykfpA8CNyHI/2+WsWqKN+TwywxIbTiPts3hDbcehn9Es
	Sn8/bfqa8V6rIR1COd1d6D6l1UHvoeZAYUzuVeMZpPTarDG2pFPPnmHz6wiIUUHSVhImZIGOMHQ
	2IvAvRo8vSY85kf0u1BJQsTl4uPetXc0KiUTOfrlgBt1Ff8JGvqU7G
X-Received: by 2002:a05:600c:3155:b0:499:4892:d022 with SMTP id 5b1f17b1804b1-499dc6feffcmr15555245e9.8.1787697228911;
        Tue, 25 Aug 2026 15:33:48 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3965d119724sm3170845a91.2.2026.08.25.15.33.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2026 15:33:47 -0700 (PDT)
Message-ID: <cf3486b8-a506-4732-8274-b3179fb06a82@suse.com>
Date: Wed, 26 Aug 2026 08:03:38 +0930
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Removing ->dirty_folio
To: Matthew Wilcox <willy@infradead.org>, Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Pedro Falcato <pfalcato@suse.de>, Christoph Hellwig <hch@lst.de>,
 Jann Horn <jannh@google.com>, David Howells <dhowells@redhat.com>,
 John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
 Rik van Riel <riel@surriel.com>, "Darrick J. Wong" <djwong@kernel.org>,
 linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-xfs@vger.kernel.org
References: <aoyWln-Gt-yvZQkE@casper.infradead.org>
 <a1f8902b-72a5-40fd-a36b-89b6ea271cdd@gmx.com>
 <ao3sgEET8GuY7Rw2@casper.infradead.org>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXVgBQkQ/lqxAAoJEMI9kfOh
 Jf6o+jIH/2KhFmyOw4XWAYbnnijuYqb/obGae8HhcJO2KIGcxbsinK+KQFTSZnkFxnbsQ+VY
 fvtWBHGt8WfHcNmfjdejmy9si2jyy8smQV2jiB60a8iqQXGmsrkuR+AM2V360oEbMF3gVvim
 2VSX2IiW9KERuhifjseNV1HLk0SHw5NnXiWh1THTqtvFFY+CwnLN2GqiMaSLF6gATW05/sEd
 V17MdI1z4+WSk7D57FlLjp50F3ow2WJtXwG8yG8d6S40dytZpH9iFuk12Sbg7lrtQxPPOIEU
 rpmZLfCNJJoZj603613w/M8EiZw6MohzikTWcFc55RLYJPBWQ+9puZtx1DopW2jOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXWBBQkQ/lrSAAoJEMI9kfOhJf6o
 cakH+QHwDszsoYvmrNq36MFGgvAHRjdlrHRBa4A1V1kzd4kOUokongcrOOgHY9yfglcvZqlJ
 qfa4l+1oxs1BvCi29psteQTtw+memmcGruKi+YHD7793zNCMtAtYidDmQ2pWaLfqSaryjlzR
 /3tBWMyvIeWZKURnZbBzWRREB7iWxEbZ014B3gICqZPDRwwitHpH8Om3eZr7ygZck6bBa4MU
 o1XgbZcspyCGqu1xF/bMAY2iCDcq6ULKQceuKkbeQ8qxvt9hVxJC2W3lHq8dlK1pkHPDg9wO
 JoAXek8MF37R8gpLoGWl41FIUb3hFiu3zhDDvslYM4BmzI18QgQTQnotJH8=
In-Reply-To: <ao3sgEET8GuY7Rw2@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cj9spp4gis8nu56u6u99mnok9qn61smc
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6C3DA120006
X-Rspam-User: 
X-HE-Tag: 1787697230-701893
X-HE-Meta: U2FsdGVkX1/YRthFzurUMtdPvzR5L3u0jUKSrG3TYQZvdUJk+fYdAt0V7tPrX2VGgP0ke0MG8O4MrNxylH5n6WX+TjYMrLDxAWf0ADPh6PzgVxSBaASentX1poFZaHI1edN6EhkW0dqtwN+t6/xfixLh2y2qGkFlY4g4XcBcL4o+yK1apIaarZVWcbUXyq3sNbcptPM+iJyYEjKO8+3BcWkIMQGx0kOJB6ngft9UpWVtCdQJiCd+9FwO8FyF69TlbOPGbu1jf/dTPjWPXHku3JniZxvBZMgbXbh8CRICJzfAAY8v74YmYjDm70e5nT6youM72wXa8AVA7aoromej/YlTB+gVOLzllNH9s8he/wPkD/LKgzUWuUs6fmBjT6OnVWdfcmN1zG0aEiK6UBZ9GBZfDvuS5iHFNLmEmnKUchpgTmViMuiYDFNj81+vkdPTeXn7A3YeJZOXgifjZe+7M8Rw2ZMvddryj8kb3jJvFRYU2P/IUKZzU0d6Eeqc/C6CcVGKrvWcNhHzks/f4+e5wnpY/NjNuPogYrVSTy1vXuxndPVUyPlugYMDSvIiLuS9T1yJkpGT7h57KGOJY0TVlIiEjzkNsze+VTQPXXxQJetfkYQ+twVAIic6fTYhtHN3R7IU/He0ul0FN4urVfuLkAIFD/P+PyMi6SqWDrDge2njxQc4tPG3D8Uqj/LoksxDHRU9VSiYaosQnR5RPq3K+DdTz+LjQUoQWhSvX0HfKJV8XfZCcayQbcPbudaUV1h+N0ZOhuEKeI3Sj14ws2qHNzGdeaDMvq2djxzl94gG52IY3FVm8Ao3hLdB1nHhVQRjk4v4GqjX9Sod08VsnRiwiqqSIJyjRgQoXJZ1vW/GjHxglft5CZoaHutAawHQLW9DOydFRiJ9rcgdh84/l+jwlCrK4ZS1S0I3gU1/gku2WXoHbINw+nFzRFkE219yD09iLvsffzvgcnfhwwERMrh
 2pweVMzE
 cuz1OyUxUpbECOzwfFqWpiGug+boFTNXGiEfRDdWJ6Qxk6+nxV5ORdakDoTK0yw2mz0+GRnYRMur/Y7tXEKov9ytVyGDgZ1QylZw6a0VEp/e4O7rL5DUrauONgZN9ekWCXxx0CR75u2VL736OBkM560/Hqwv0+8Tq5SxwGc5c5t9et/Y6TG/bbMarld5d90+oTIrsqot89tLXAaqQzjGX1NsTdNC8vMXUL718PETqqXifgvj6/MB2CVZJMvdBo0Ze6qC3+wRxbHAveru6hgDH1n84RWoiRk4lPWAOAMAr19B7o5i90B9wXyD9XYp3P5mbujMbzexuDPqiEkcbFZedxwLsiShuxrt2UsFVQ0q92uOG5enYliBLZvZyXCNFXU/xWcG0uNMOm5rLCVs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/8/26 04:56, Matthew Wilcox 写道:
> On Tue, Aug 25, 2026 at 08:08:48AM +0930, Qu Wenruo wrote:
>>> The problem is GUP.  We have no way to force the GUP caller to go
>>> through page_mkwrite again.  So instead we make the GUP caller call
>>> folio_mark_dirty_lock() which many just don't, and generally we get away
>>> with it.  But it's a bug, and a bad interface.
>>>
>>> There's also the problem that GUP users bypass the folio_wait_stable()
>>> mechanism.  If a page is written to while somebody is creating a
>>> checksum over that page, the checksum will be corrupted.  If we want
>>> to fix this, we have to bounce-buffer the page.  There's no way to
>>> prevent or delay a GUP user from writing to the page.  Enjoy your RAID.
>>>
>>> My proposal is this:
>>>
>>>    - Fileystems take note of folio_maybe_dma_pinned() during writeback.
>>>      If it's true, do the writeback, but retain/recreate whatever data
>>>      structures you need in order to write the folio again; behave as if
>>>      ->page_mkdirty() had been called again for each page in the folio is
>>>      marked as dirty.
>>
>> This may make COW more complex.
> 
> It's probably wise to be explicit when talking about COW.  Anyone from
> the MM side of the house is probably thinking "but this is only relevant
> for shared writable mmap and we don't do a COW".  You're talking about
> filesystems doing a COW of the on-disc data, not about the MM COWing the
> pagecache page into an anonymous page.
> 
>> For folio_maybe_dma_pinned() case, we will need to do extra space
>> reservation similar to page_mkdirty() again, so that the folio can be
>> written back again.
> 
> Yes, you will.
> 
>> I'm not sure if we will have a good timing for re-reserving space inside
>> btrfs.
> 
> Why is it hard to do it immediately at writeback time?  I think you're
> in an even less restrictive locking environment than page_mkwrite is
> called in because you're not under any MM locks.  According to
> Documentation/filesystems/locking.rst, ->writepages is called with
> absolutely no locks held.

This space reservation problem is a btrfs specific problem.

The root problem here is, btrfs space reservation can trigger 
writeback/transaction commit.

This is due to the data/metadata COW nature, and that's why we rely 
completely on buffered write to do space reservation, and avoid any 
extra space reservation at writeback time.

This is also why we have the complex fixup mechanism, to avoid writing 
the folio that needs fixup, but queue it for space reservation.

Other than other fses to do the space reservation at writeback time.

I believe since we have some space reservation for no-wait writes, it 
can be slightly simplified using no-wait reservation (aka, reserve 
during writeback), but it has a much higher chance to hit ENOSPC.


Although I think on the long run, as long as we want to migrate to 
iomap, we should find out a proper way to address this problem.

> 
>> Would it be possible for MM/VFS layer to trigger page_mkdirty() instead?
> 
> Actually ... no, because the VFS no longer knows which pages in the
> folio are dirty.  That's information the MM had, and communicated to
> the FS which (if it cares) has stored in its folio->private.  But the
> VFS no longer has access to that information.
> 


