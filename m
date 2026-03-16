Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F6DFF46448
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 10:22:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7761E6B017C; Mon, 16 Mar 2026 06:22:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 736966B017D; Mon, 16 Mar 2026 06:22:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60EFC6B017E; Mon, 16 Mar 2026 06:22:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 50E0F6B017C
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:22:55 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F3D8EB63B3
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:22:54 +0000 (UTC)
X-FDA: 84551537868.07.09D652D
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id D15721C0005
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:22:52 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="K/CLOCYp";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=4sMo17Hd;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ooysrVrp;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="aKNu/FTa";
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf21.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=tzimmermann@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773656573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rwzBT/l493QcDN4Dzxv5Qhn7CZojZ4bhJCatnXm+Up8=;
	b=FODidZ+mDbk3jWW7oHgQfKChEB1WtwR8XxqJZqI1i13pg730DoirTeslz22eVropkwWGCX
	DX6iF1qcZnevfBhitVypwXRS5gK8a0b0QU2wDfl/DJDVAlG+OOqJuppysBbHp7oYsJ/PR2
	lKG5urfHj4kyHIEWBIqNBsjYcFiorvQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773656573; a=rsa-sha256;
	cv=none;
	b=Y9NAHpDSDrfSmJnizcUmRNnZhmgEcVa7GBd8uKlulZu8yQoVOTqzxddeM4XBF2mcjC1I8I
	fx2iQgs/jrJNofBqDSst4RqfIJw/jUpEUkOT39XJSJCJOFRP8vNjsg2W91ROEMXKiAzMtV
	+po9BhFfGQRujEuubI0VZAFRlTyIfaI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="K/CLOCYp";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=4sMo17Hd;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ooysrVrp;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="aKNu/FTa";
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf21.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=tzimmermann@suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 230E85BCD8;
	Mon, 16 Mar 2026 10:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773656571; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=rwzBT/l493QcDN4Dzxv5Qhn7CZojZ4bhJCatnXm+Up8=;
	b=K/CLOCYpmSDK9beoF5nneeWm/0B+DmFKN1qrgDX38PsrK4rSjz6GtyrbxG8L8bondgF3vK
	8XcjqwneVZfxSN1kLSK9hcWI5J4Te73FbtTIe4FMZeeTP9ndNbXzTmF99wOz0Zo709G/Ho
	uYHXlomAXWtfHlZcTKp+IDfioNL2IXQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773656571;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=rwzBT/l493QcDN4Dzxv5Qhn7CZojZ4bhJCatnXm+Up8=;
	b=4sMo17Hd1qSjMLBrgD7qqA0B2AzEz8XKgFLT16rQIOu/GuB12s3o0xWfPtevFbmh0pkI+H
	aJQbTV+HlZ1VN3Bw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773656570; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=rwzBT/l493QcDN4Dzxv5Qhn7CZojZ4bhJCatnXm+Up8=;
	b=ooysrVrpBPA7VMz3a4pKXg3qUxQ0ithnJys3wy3E9ai2+mBj0EQzp7if4pqjr6cqa8XKor
	nddGf9xC/49gwpi5opP8yJn7yDnFGfDvuVUkJFFIS/cI7w1CQs8PUWUWpDG2nOTsXppMum
	7JFdfq3FNm9TqU/ltrmwPGYor1jCN0Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773656570;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=rwzBT/l493QcDN4Dzxv5Qhn7CZojZ4bhJCatnXm+Up8=;
	b=aKNu/FTa2f5pjlvodB7ZO2e6Z+Zg4raSOE6e3RNyZMFJ0l0vXt9UBjEBSgSQ9XYzh/gJsn
	ZHLVNUMPFueen9CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C62254273B;
	Mon, 16 Mar 2026 10:22:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Kq7pLvnZt2meVwAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Mon, 16 Mar 2026 10:22:49 +0000
Message-ID: <21f56de3-ec1a-4d7b-8abf-c538584e18b2@suse.de>
Date: Mon, 16 Mar 2026 11:22:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/6] drm/gem-shmem: Track folio accessed/dirty status
 in mmap
To: Boris Brezillon <boris.brezillon@collabora.com>
Cc: Biju Das <biju.das.jz@bp.renesas.com>,
 Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>,
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
 <53f11658-5466-49a3-816a-ff6fd2e1da6f@suse.de>
 <20260316103621.6ed48b68@fedora>
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
In-Reply-To: <20260316103621.6ed48b68@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D15721C0005
X-Stat-Signature: ambhk5djqowykb9zqsu1c3byybnewhqs
X-Rspam-User: 
X-HE-Tag: 1773656572-814875
X-HE-Meta: U2FsdGVkX1//BSwp5QjKNk6/1sc6sxuk7DbPpRQCVrgNjdkeJTzE7gTaSORPv2geptvG5HP4znhe+aCN5Egl5fWpm0ibfSEa8YQE+4EC2aDF4gWVH+m0akCna/w31taWVRc8a90N6GiFzCBIQ619jO/jEuW+A3z3swaBjRlz+qbGoyWQpmDduwVs/cnilRLAOnBAQwnHBq+UonhXK5xaKkuVFGGM8Kg+xYCfghw7fu8ZlreO6BwyT8lUgJG+HPctgVf/LowEWWxrswhGWHU2UPTX+p1KLtOFEQbA5EnS9U/EdvAXOEUZvNtlLsizpt0XWrtSXBfm3RZfLMXp53V+p7ATMmU4jYQvy78ktr7mCKZJ2Tl5e/sf2fcIhDpcMFMxHRON5t5/cf0KMZgSe99QJjI6f1rjPB1dEQNKAJSCR35cxuMcN1og6A0+butqX7ycJ2cK4tL9covA14Gn+DQukLoEUZLfQKk3DsvHVdIozKiT0CQTuOa9yeR65nKicJN3UI8B8CJDQbzRjBaKs2TlWh2yM8/SXgN/wFQ1KV8W11JHyeozWDmOLRIuauDd+85pZY8jWgKOTBU1bF8vy6a5lvaZLV3hlLlOLg6MCurXkxjbSK8FId2vFgyy+Tv9jRwpv+z4NEsux3A0l5t6dkxFrTNpeM4sTtdJKH+M8VNjc2tJOFc3PZA5NlERVVDyy/v0h7mbJopQCOPrXjjQCM7OxD8vpEywJD5U5aRmv8bOUX2tQdKB/GgTcfz5HPlSdZx/CK9nSV4uJOz1SNlaMGoZFs5EJFd/s/wLcOUzymiKD5jJCJqDfWP1u4839o6b1QNQtr8muZTaTeS1HVCQru6LHp+3AAwpsfFndH9V6UqzF0dzl+wjpaFOqj+4uMWyF0CI89kRnyrRvoTBY5f4a8tw8rNSilk63m80i9EcaX5bb29+IOiXgPUiIHCuZajfxAdXyDxD+4QQzxGpFNybvq0
 1m0Fp0HV
 Vt6IyPPd8QdnJniz7KyHaax1rkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi

Am 16.03.26 um 10:36 schrieb Boris Brezillon:
[...]
>> This would keep the huge-page code within the first branch. And if it
>> fails, it still does the regular page fault.
> Well, in practice that's not what we want anyway (see the other fix for
> the huge_fault vs regular fault race), so I'd still be inclined to have
> the folio_mark_accessed() handled in the common path and have the pmd
> vs regular pfn insertion in some if/else branches. Something like that:
>
> 	if (pmd_insert)
> 		ret = drm_gem_shmem_try_insert_pfn_pmd(vmf, pfn);
> 	else
> 		ret = vmf_insert_pfn(vma, vmf->address, pfn);
>
> 	if (ret == VM_FAULT_NOPAGE) {
> 		folio_mark_accesed(folio);
>
> 		/* Normal pages are mapped RO, and remapped RW afterwards. */
> 		if (pmd_insert && vmf->flags & FAULT_FLAG_WRITE)

This style mixes conditions from different branching depths. The first 
outermost branch uses pmd_insert to compute ret.  Any then both have 
changed places, so that ret is in the outer branch and pmd_insert is in 
the inner branch.  This is hard to maintain. It is already confusing now 
and will be even more so to anyone locking at that code later on.

Best regards
Thomas

> 			folio_mark_dirty(folio);
> 	}

-- 
--
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Frankenstr. 146, 90461 Nürnberg, Germany, www.suse.com
GF: Jochen Jaser, Andrew McDonald, Werner Knoblich, (HRB 36809, AG Nürnberg)



