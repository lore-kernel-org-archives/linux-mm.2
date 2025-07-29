Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C867C83F26
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 07:24:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1B7E6B007B; Tue, 29 Jul 2025 03:24:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCC4C6B0089; Tue, 29 Jul 2025 03:24:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBB186B008A; Tue, 29 Jul 2025 03:24:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A906C6B007B
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 03:24:58 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4CBC714044C
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 07:24:58 +0000 (UTC)
X-FDA: 83716465476.22.944504C
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf27.hostedemail.com (Postfix) with ESMTP id E3E474000C
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 07:24:55 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="ZmDj/T3w";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=hcu72KCv;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=lEqIEK0S;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=nczYPxox;
	spf=pass (imf27.hostedemail.com: domain of hare@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=hare@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753773896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dT6lTHeMKW/RxZFzXwAmbYK87ulRH345lFXil9hMwPs=;
	b=qVmMvHGFCXi+4SsZL36bU9S0rkxu5/c0rIcpxGhRlWMz6a2FKvvJDZ6uwvdJpePE7kcyaC
	e331IIEnu+Cx56sflyTHqRjueLFAix3bLZ8LvfVBc1x0q7lW4aP1kTF8RIMxTaCVK12ifG
	P0angA6YXkKScrUuCcecs6RZWrzTfrc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753773896; a=rsa-sha256;
	cv=none;
	b=ohsfzanK40MNvMblFrhI56AQVNLJRShxgLI4tNr0JLf69o62VYC62wGS9rw7Y2XC4mD+0c
	M3GtebFvKNH7B0hv9tj2Lp9trEwiWUy9VzTfvfZtJdr2jnT98dRatSyiqMxjlLI7X+T6uS
	BQK3UQ+1UucRHcjNFB5FnwiQNSxmQeQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="ZmDj/T3w";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=hcu72KCv;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=lEqIEK0S;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=nczYPxox;
	spf=pass (imf27.hostedemail.com: domain of hare@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=hare@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4992321285;
	Tue, 29 Jul 2025 07:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1753773894; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dT6lTHeMKW/RxZFzXwAmbYK87ulRH345lFXil9hMwPs=;
	b=ZmDj/T3w5fu1uvVG0If94NFuWGew6Z/BtlQ5WOVYk09zQeURHVTEAbXaHw2Lg1dpfPs5WW
	pSqy1IJBnGzGuvPu181vyaTTwgcfqd4O2flETqzZgSIby4jvvmJRkUvgh3paWS2bGZcHNo
	JT80PubdDOV1gz68cBjB/bMGuCmYYeM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1753773894;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dT6lTHeMKW/RxZFzXwAmbYK87ulRH345lFXil9hMwPs=;
	b=hcu72KCv8QVlQp3ahmymucprjUBg23AoHKHT8dK7SUZ2pMIeklMs2tJu0olO/Zy32bprap
	immtHdnPc/ALgFDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1753773893; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dT6lTHeMKW/RxZFzXwAmbYK87ulRH345lFXil9hMwPs=;
	b=lEqIEK0SsBC4FL/bS9UEmO25RxehlTJnFcrNBy2chhjuMcaFIQh9xhtp/q/2lgthBqKVCe
	A4EgMOI1TFxR2p2vvN8xgMotgiQUhW6d1qKCAMjCjoCsZZHvrXtaT8eZER+9DectEPyOlP
	M+UCAk2c1YFpDRLPiFlSom3kb5cdgzw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1753773893;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dT6lTHeMKW/RxZFzXwAmbYK87ulRH345lFXil9hMwPs=;
	b=nczYPxoxzi0hAmzMiR+bk6f5atECXXJNTW1eOl5RdcH9gwddSmgwhJu4/zFpwUll+sZkds
	1eFZrvdvAuHEr/Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0B47213A73;
	Tue, 29 Jul 2025 07:24:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dzncAEV3iGitJQAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 29 Jul 2025 07:24:53 +0000
Message-ID: <ac7add36-808d-4883-a09e-ef1bf6fd6834@suse.de>
Date: Tue, 29 Jul 2025 09:24:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] Disable auto_movable_ratio for selfhosted memmap
To: David Hildenbrand <david@redhat.com>, Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Hannes Reinecke <hare@kernel.org>
References: <aIcxs2nk3RNWWbD6@localhost.localdomain>
 <aIc5XxgkbAwF6wqE@tiehlicka>
 <2f24e725-cddb-41c5-ba87-783930efb2aa@redhat.com>
 <aIc9DQ1PwsbiOQwc@tiehlicka>
 <79919ace-9cd2-4600-9615-6dc26ba19e19@redhat.com>
 <f859e5c3-7c96-4d97-a447-75070813450c@suse.de> <aId16W4EaqjANtKR@tiehlicka>
 <3e88642f-3914-42b0-b864-4ad374b659b5@redhat.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <3e88642f-3914-42b0-b864-4ad374b659b5@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E3E474000C
X-Stat-Signature: 4dr5ne9stpsezkjkpwnjxddftzbmwe6j
X-Rspam-User: 
X-HE-Tag: 1753773895-409051
X-HE-Meta: U2FsdGVkX1+Bp40fk+0wNlAIV8RuapGenxvQeNPKlqeagOtW64VM4nrH5YkwIY4OGldsk1xgBWJSUaGHosNZYj5MC6t6Bln/Hp/x/BgZ5SEudBQ97Di+h3sx8jE+s7Z6LkohyqI2BpZVEvAK7weGQ5bl0rm4Rnv9N0oNKYuz4p3hUk8ypF6esx235QY4NyZC5ILgJUchoCrt2G78T1iD0kVrvQ924+qxzu0BCWQqXWZ5HByYRjOyBzciPAjWi0aBhbmdvakrk6pcbaOvpF7SMb3B8uf87GG/1W5LuUm9KyvCElTIO1PLUos1A0ReR2Dzpofza0cGIw/Kwq51pgia+/mu4BmezbhRgAf5jAD1WbCyDwwdwyzAKay7ZQ79HA3Fzx7pCZDiJMM5JSaC4dXTCs9TfA7/ZkC8if/iStXi+JVF0JWuUfmORlvp0jnFfZz7rbdBNx1ND7rMGEQPA5wcKJ2lmYIyhxZVHehIrcWhZev0CmXrfSySiaPdkI8jy/jhQE2d0yC13NxjhHmXXRpOMDUIXcBKlhyvS9HgszCXKeOjjdrEXP80E826TCvPeuzx80d4TX+1J4TQvi9Vy+2Pv6jRcGlLJg2+76y6YVoRGg3GbAYUaJ88Pvypf71IB36QH+puwpjPGBk7zs1Cq3kF1ZKMpJYNZDS9ZXFCEqrVBfJsTm5wTwKBsAGzrJIlPuxwOVi89G/w3QK2HA5cCTXAb/rHlQcLMh69POqtyANqRuOaljr2/2mUmfiKkvrmoBfZ3uZFg6UCcrj4oPOHCfRG/3tn7KZmnx2fy9LjYEbR8R+N3VcGIGK4BPCdKA2tO9OssnGSbefdm4DHXuumEIq8Jab2FTB0QbALj6IGYVIdCvp9JbtDpRRAR1wsYeX2gOXenTXe3TP2DDj0of1A+6U5ZZKxi8JKLVwIdmtsCPgwN/T2/Fs4Uvoeln9+7fv5T06ecARRK6dXqi6lZ09WB57
 ZlS5ksX+
 NsC/6mGpYlTo00vDfXdv6rpMMOa+OMLVQ+x0o0uyXnYCUgpGCR63NAV2aIT6ulbPFOtriX9pkyZMQ5VBx6MKfQUECJKPKDAsFhpSgHP5OELlMLRxHeeNrCnn3tgfrjPPx8JFYpXkLwuI5skZ59XF3ND89x40rdROUUMh5uuzMGPjJHDgwDrFJ5/RG3yA0611m0M76YB4nEq0Xk0jKc7KqStwKbzbQY7Ijul+JOTFyTx+tjh+t9vQauH1jkXCVJ8NQK9HWKvAnJMnhea/LJgmhNgYSGIfEm0Sm0piqgtIc27BbSemT+SAzkgm2+yrF3/lMF6hm2W8lcBsyFkhycq8WX/yAxSF09ywWrjs7Daux3O3vYyEPmaIBdvV6JA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/28/25 15:08, David Hildenbrand wrote:
> On 28.07.25 15:06, Michal Hocko wrote:
>> On Mon 28-07-25 11:37:46, Hannes Reinecke wrote:
>>> On 7/28/25 11:10, David Hildenbrand wrote:
>>> And to make matters worse, we have two competing user-space programs:
>>> - udev
>>> - daxctl
>>> neither of which is (or can be made) aware of each other.
>>> This leads to races and/or inconsistencies.
>>
>> Would it help if generic udev memory hotplug rule exclude anything that
>> is dax backed? Is there a way to check for that? Sorry if this is a
>> stupid question.
> Parsing /proc/iomem, it's indicated as "System RAM (kmem)".
> 
I would rather do it the other way round, and make daxctl aware of
udev. In the end, even 'daxctl' uses the sysfs interface to online
memory, which really is the territory of udev and can easily be
done via udev rules (for static configuration).

Note, we do a similar thing on s/390; the configuration tool there
just spits out udev rules.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

