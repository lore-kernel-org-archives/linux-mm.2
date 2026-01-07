Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6621CFD625
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 12:47:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01C796B0092; Wed,  7 Jan 2026 07:47:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0B8E6B0093; Wed,  7 Jan 2026 07:47:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0DAC6B0095; Wed,  7 Jan 2026 07:47:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C95496B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 07:47:46 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5AA0D1A0345
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 12:47:46 +0000 (UTC)
X-FDA: 84305144532.11.54256B9
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf28.hostedemail.com (Postfix) with ESMTP id 05EB3C0006
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 12:47:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=J02v0lJc;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Pi1la0j1;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=J02v0lJc;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Pi1la0j1;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf28.hostedemail.com: domain of hare@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=hare@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767790064; a=rsa-sha256;
	cv=none;
	b=dIPzlvljQ6sBL5B6YlbDKwLgxcsq06AeqDMqCY6KZmyvWop5ZQPVzEUDQU8C1m4hxEQG8S
	JHMS3A0qziUUMdx7fC9bhmAwuM5iidmh2b58OydjoIYtyA2onmac0PGsmjnCwo7WJtk1ON
	1OaCvZRWUYjFA0Vagtpi3ipUhyfElbI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=J02v0lJc;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Pi1la0j1;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=J02v0lJc;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Pi1la0j1;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf28.hostedemail.com: domain of hare@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=hare@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767790064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l4yeaiwFw4tFr94QA0WF6Qmoj2lmHuBzJ0Gyzocch9Q=;
	b=0KNfaJg1ZjPrQGelD0xFolPH8ujz7uP5wcwVJ49XkNf8U9/PA7bkIxmvN0BW83UHY097ov
	xgnH/ZXqe6YVnJVyjnYG3rnWhB3snwxJeEaKIR+Nap2f3WEf7tc+jPkbBmlz02G8bVDYe+
	VgDYzJaWVv7VFH2s2gl67S7+so7O0FA=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7102733C2C;
	Wed,  7 Jan 2026 12:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1767790062; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l4yeaiwFw4tFr94QA0WF6Qmoj2lmHuBzJ0Gyzocch9Q=;
	b=J02v0lJcmFfUHIBCQh1KeYlJ4SIX7PXEXiv0UZgqTr0kJCYnoVDlgPnP4NAcnRrgOwn40D
	RRt/yy+mLFiYsJcKKI8vNZ5kPpXXJScRfmAEZZlkFTj73vkz2R19QuvZNP/Zel3RLda4RM
	T50J03s0OPkOPHfMbTqVk8913+SYWcw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1767790062;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l4yeaiwFw4tFr94QA0WF6Qmoj2lmHuBzJ0Gyzocch9Q=;
	b=Pi1la0j1rVisr6xRsyp4Vf2Xkd3BiP87V1B6+bahEKU+FcJ19mzc+mJZKsx486pPuKMFJm
	CHygq9ydid+NfDCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1767790062; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l4yeaiwFw4tFr94QA0WF6Qmoj2lmHuBzJ0Gyzocch9Q=;
	b=J02v0lJcmFfUHIBCQh1KeYlJ4SIX7PXEXiv0UZgqTr0kJCYnoVDlgPnP4NAcnRrgOwn40D
	RRt/yy+mLFiYsJcKKI8vNZ5kPpXXJScRfmAEZZlkFTj73vkz2R19QuvZNP/Zel3RLda4RM
	T50J03s0OPkOPHfMbTqVk8913+SYWcw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1767790062;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l4yeaiwFw4tFr94QA0WF6Qmoj2lmHuBzJ0Gyzocch9Q=;
	b=Pi1la0j1rVisr6xRsyp4Vf2Xkd3BiP87V1B6+bahEKU+FcJ19mzc+mJZKsx486pPuKMFJm
	CHygq9ydid+NfDCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0E0923EA63;
	Wed,  7 Jan 2026 12:47:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vucEAu5VXml2YAAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 07 Jan 2026 12:47:42 +0000
Message-ID: <88dbe97c-3510-4ce7-ae85-067243a152bd@suse.de>
Date: Wed, 7 Jan 2026 13:47:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] memory,memory_hotplug: allow restricting memory
 blocks to zone movable
To: Michal Hocko <mhocko@suse.com>, Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 david@redhat.com, osalvador@suse.de, gregkh@linuxfoundation.org,
 rafael@kernel.org, dakr@kernel.org, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com
References: <20260105203611.4079743-1-gourry@gourry.net>
 <aV0kzBxg57Mlw8mx@tiehlicka> <aV0-ChclC7SCrxcg@gourry-fedora-PF4VCD3F>
 <aV1nPG1BgBQDWkjE@tiehlicka>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <aV1nPG1BgBQDWkjE@tiehlicka>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 05EB3C0006
X-Stat-Signature: mzabrt565zkcgmjr74kk5pzn4dgj5smc
X-HE-Tag: 1767790063-496922
X-HE-Meta: U2FsdGVkX1/uT+EvUj/QGicdXFureTAenBWOghf731dfB4cICEoX5RJ9ysKlCxcVHHBGEfNC0EAJdn+zDTnDk4+wMnv3q8xaxkFtukOwEXkIoYMLhhtqW8+45TI8IWvGVzf7Z+Yxs9OCbn35yf6UfiTmIzSSuBM3bnvZttPhDGFABXS1lypeOkLBoxfO5JcirgNmbmGYgUhr9t1m/P1vs9cFK/ZXDNPeQ63tc+povxc/VGdWJkYkOtmbbFvQB4vfv6BsU+LfvlVeN4XsFKemEHEB7GHFHqbcsDUw44lH2BjZWeutTEWwMAvmCE0RT2IwNJGaFKaHqSLkLYnHfSoPWaRXWr4nqRZ0s4ACqXiEVeM93XQW3999is0OT77h0BlHdR+yTXExTl7mnGM/fMF7+dFHMDJpzVKj+u8mMCadOYJtNtO832WQlccZFH2lOdq4p+mywxfhTmEkQfaZPZd/1Ab+kioIoWwaWFylFlmEdstmYJoKTj/udTuiZBlzQvphwYh2FpjzxsMcjNUBoTScCOELS/BCPABWMz2gkiAkhG+wrHDzD5MEIGCR40axayETLboaqGbQ8j5zeo5JFvvo6vh9ZHkSv2Jjd0PvqbldsiohxzESjdIdjzZGyWyaDH8tYSVk0lQLjYtB9tOGhmk6ooMaEqf8LFJLlF5mxFLaRPPPzxFXzaRBPXFpaKe/ads1QbkqqUzZwGciZ9LkfNrdptsYYBA8ckDhI5Zd6084XSmCsvWkuAgePgXgsTNJu5BtQ5rZnEyXm4gSTHhQZ5yburdmHyhPqW428ukD+nEzZ/G8YKK1HPlCtQ3EePplv0VnnLj1n/3cQeRmZa8sRebiwkh7YToc1VJAYcVB0I70EbX7GPsJOtB/iD2cZGhM4+BpHjZxTLpIl/+cPT47mA9LZ7HM0cxd7XgW8shKg3+SURcj0ogEtSZ1qcQlhqhptZfl8WqvJ++evYGh+jDlJJt
 hPvKf5Og
 6G09VpftqfeWR+bITRDYs1VpSp3BO/qrZtYI781hHt6jpy2tAvTg19lUvza10NO/bLKHatayLNv/LDCKJv7MigKJHSR5wjDAcPaALQ1htXH7h3NPUN0TsOTVWdgN0TEH11gloqBOq7kGT9DcZaJVmVxyVH2FTe5tfcAiAcQoeQrfJ6yP18JYsUaIfUX/fgoy1c+xJCrqREKUyexMtWopWAz+bP3mIVz9gpF/8/0QQ+R3Vi+beo1PDQdsaOXSI6fixQnOopdplVkTNYAKa8ag0CLz7z+9zJlL6xOa+VRGUmWNR+RRm+M1bytzX6qHCNVKYeLw1HLJ9uJpJRYcjm0K2MD1a5ospDiqfgZAy+3p4H8Zv7VoAYsC9v636AS0QPqu1NkC8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/6/26 20:49, Michal Hocko wrote:
> On Tue 06-01-26 11:53:30, Gregory Price wrote:
>> On Tue, Jan 06, 2026 at 04:05:48PM +0100, Michal Hocko wrote:
>>> On Mon 05-01-26 15:36:11, Gregory Price wrote:
>>>> It was reported (LPC 2025) that userland services which monitor memory
>>>> blocks can cause hot-unplug to fail permanently.
>>>>
>>>> This can occur when drivers attempt to hot-remove memory in two phases
>>>> (offline, remove), while a userland service detects the memory offline
>>>> and re-onlines the memory into a zone which may prevent removal.
>>>
>>> Are there more details about this?
>>
>> The details are with Hannes, I was just recapping what was described in
>> his devmem talk at LPC ("To online or not online").
> 
> I know of policies to online newly added memory blocks but I am not
> aware of policies to re-online something that has been made offline.
>   
It's not a policy per-se, but rather a udev rule (which one could
argue _is_ a policy, mind). There is a rather long-running SLES bug
around this if you are interested...

But in either case: we cannot prevent the user from writing arbitrary
udev rules. But we should make sure that the result of udev actions
makes sense for the system.

>>> That being said, rather than movable_only, should we have a mask of
>>> online types supported for the mem block?
>>>
>>
>> I briefly considered this.  I went with this for RFC-v1 since it's
>> fairly simple and because movable is really the only zone with hotplug
>> guarantees (any other zone makes no hotplug guarantees).
>>
>> It's also significantly more complex of a change for questionable value,
>> but if people see this as the way to go i'll happily pivot to that.
> 
> Sure, I wouldn't push for more complexity just for the sake of a
> theoretical extensibility. And I have to admit I have't tried to a quick
> PoC to see how complex this could grow. I was hoping this could get into
> a simple mask for online types with default MMOP_ONLINE_KERNEL|MMOP_ONLINE_MOVABLE
> and special cases just choosing one of the two and zone_for_pfn_range
> checking for the compatibility with the requested online type. But I do
> appreciate there might be some obstacles on the way to achieve that.

Yes, and really it's only ZONE_MOVABLE for which such a treatment
makes sense currently. Once we have other zone types we might need
to re-evaluate that. But for now I guess we're fine with a simple flag.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

