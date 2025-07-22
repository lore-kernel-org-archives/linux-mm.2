Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28F47C83F34
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 14:23:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA05A6B009B; Tue, 22 Jul 2025 10:23:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B78206B00A0; Tue, 22 Jul 2025 10:23:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A67B86B00A3; Tue, 22 Jul 2025 10:23:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 968D26B009B
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 10:23:04 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1477D14040F
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:23:04 +0000 (UTC)
X-FDA: 83692117488.28.F80E6D7
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id 96C8680004
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:23:01 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="oBg/37Lb";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BNh8C61C;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="oBg/37Lb";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BNh8C61C;
	spf=pass (imf02.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753194182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eninw5AAsvH1vBycf8vZZytMFVc/miKgnCr/jA/ZvBI=;
	b=W0InX7XwOVdBFINTqQ9z9OQsL+5lBWhoi0nmi1dvc7Mm5SZ/j3ZPi6faSj2Bs3Hr6GDDaE
	8AR9d88LB3qm1b3KMskVZG1ffpBMw4VTpQhfRx/8uCMG5xieWNZZRnLOaF0JdrH1B/bGQj
	a7V9Y0s4ZepWheZKlmkKe4h3qvBpldg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753194182; a=rsa-sha256;
	cv=none;
	b=khSYqgTKs/2qnBlmY7EgcotpXQGXQ8lpv02qCTZ9bHk585ab2TtVkIFnWDZGiaOMTlaAku
	cZBMyAZBeHybIFRetdKBSLLSBdm9jQV57kn50fbzP4yDHS/fZzMDgCJRHwwMRFbrksl6cX
	cE6mUo57Z5sjWgwWc5BSgRMWhJWORvQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="oBg/37Lb";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BNh8C61C;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="oBg/37Lb";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BNh8C61C;
	spf=pass (imf02.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A27821F78B;
	Tue, 22 Jul 2025 14:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753194179; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=eninw5AAsvH1vBycf8vZZytMFVc/miKgnCr/jA/ZvBI=;
	b=oBg/37LbZgaItFV+HeMlDC0tDYPsHGamaFc/OqZ7cAbqfeWvo71/1rz3pv2CCP9jKFvnAN
	QbmIdgasE3e/8xSkF6QRCZU/6Ps/l11vLqILShD3vfv9FvRp3rGuCh1nuEW6zE9qqIhTg1
	xZQJJR0pzX45Zieh8rhbb1kL3kd2Kwg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753194179;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=eninw5AAsvH1vBycf8vZZytMFVc/miKgnCr/jA/ZvBI=;
	b=BNh8C61Col4domPEVzFlqz1+n0iePtAbK9GcvSTRqUHFVsaAd52h7e/8gKREC3OR9YIDbE
	n14lQqwYrHyTJADw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753194179; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=eninw5AAsvH1vBycf8vZZytMFVc/miKgnCr/jA/ZvBI=;
	b=oBg/37LbZgaItFV+HeMlDC0tDYPsHGamaFc/OqZ7cAbqfeWvo71/1rz3pv2CCP9jKFvnAN
	QbmIdgasE3e/8xSkF6QRCZU/6Ps/l11vLqILShD3vfv9FvRp3rGuCh1nuEW6zE9qqIhTg1
	xZQJJR0pzX45Zieh8rhbb1kL3kd2Kwg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753194179;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=eninw5AAsvH1vBycf8vZZytMFVc/miKgnCr/jA/ZvBI=;
	b=BNh8C61Col4domPEVzFlqz1+n0iePtAbK9GcvSTRqUHFVsaAd52h7e/8gKREC3OR9YIDbE
	n14lQqwYrHyTJADw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 81C34132EA;
	Tue, 22 Jul 2025 14:22:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uhlVH8Oef2jqJQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 22 Jul 2025 14:22:59 +0000
Message-ID: <bdca2e2e-acdb-4ea5-9017-6c1a58353452@suse.cz>
Date: Tue, 22 Jul 2025 16:22:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] MAINTAINERS: add further core files to mm core
 section
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Christoph Hellwig <hch@infradead.org>
Cc: David Hildenbrand <david@redhat.com>, Mike Rapoport <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250616203844.566056-1-lorenzo.stoakes@oracle.com>
 <727b5e89-89d7-4abf-a93c-8d6f2cb2c438@redhat.com>
 <aFDm0YrbSAvXc5Wp@kernel.org>
 <33c605a6-2b89-4b40-ba80-ed2ca665ef5a@lucifer.local>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <33c605a6-2b89-4b40-ba80-ed2ca665ef5a@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 96C8680004
X-Stat-Signature: erdhxn84t95j9q9rki3f4gqi3ypnhgua
X-Rspam-User: 
X-HE-Tag: 1753194181-861914
X-HE-Meta: U2FsdGVkX1+CIFbLB1k9LjXQTiTLYAY5bZBj8535sxuPWqG/wiN3N6A8jMmcEcKCPxXe5Ds+dBez9FLHVlkGtIfqVn4FI3Xf1U+X5vYjzVZDH/Z47d0zt+3gXlrA/WOD6TNdkdGcAkeTljEspcpYbawdhYbrT5qVnPmkiE/kdUwdenY+yK1co5KxGL/51vdMVY2KateZs2FUDcFsqOX0aypEj96YPjBC0vkjgfG1+HrA4ijBNWQrPrTPtiqcPyxU+WfTstE0QP+Pmi3E9ctwZ5n54QBkBLcNUQSKZU0BwBoOiS5xVoiOp1U8tGlsZfxFQayfQ8OvtDUMV4/BRNKSRIKbVJhpgJGKNci5mN4CMPA9z5x2CxzbedMK0GRbMbC5GAKbN3tBKYyLdLqklxaIjDWKWBpoDIhTPsqGykiHBm4Plfe5naKa2o23PolNVzYE04Yd65sgylEAkVk7G4GU9ZCo905wW3CDAUPiEC0Ye3SeldQBXmK+ffqcnqbVQOktNnBPHyU5B5xMA05nscMQxRzyRUpCAWIaTTiVbDeMZxqnL+rdVXqWRjFvyNoOamaeVl4jfpFmBlNmGAh71zeEFJqHZCTD2Ge5knMpDJ8Yqjj/DteofvG2qMXYVgdMUrudHR01ynQ5JcRGNg8+JItPPl/W621D60pJ+u7X6jWP5RHhoUrkamFyietu/H5YH+VFS94Rc8ThupTgY02qCggjoyq5RrYGv/Y0Jk7HHcS2+st6l0Br8xdq2vx3kr4fr4F/R+NrFlbYNPsp61NbsO5y57HF81Kz21APKU2UudtzBYN3s9FcX4/w0PlHaVeu6EZKPX+S5Vz8T6pZgX1dsFJGuirq83mxM5GPRmV2LwItmu2R6uj1ZhxEXZ+fgKhBZeSOeVGHR0DegUmhMw7bM5wzjygj9yo0cW9P4Wut+RiZA1Yr0X8pmL3wwYVVQEQh9cvl8A1XNw8b6ZJC/3B/tjJ
 DI/V/VJG
 YRoWuobI1ns9rApTyKn8kgFg4XChxueqVHUOSrxymkmDcaJvZVlj0spjnmluvCwt06pHkvPFLfQvZBthu9MdulV3iIrMSRL4QcDEijL6Eb+9poJRp4c8jV2GN6a/jqBirG4DvGBMaQAz7r9rP7jEnxQ6YAIR7HWz0+9AAj4j8Mzgw//S8/zQa1OYjhLiH+FO5QMAr0s2eNZkbbteEXzHF0uBqBWlcWwq6SEq69Q653jxtxTkQ9WUpSAqz1Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/22/25 15:53, Lorenzo Stoakes wrote:
> On Tue, Jun 17, 2025 at 06:53:53AM +0300, Mike Rapoport wrote:
>>
>> > > +F:	mm/io-mapping.c
>>
>> This is an interesting one. There are no in tree users of the only function
>> it contains.
> 
> Hi Christoph,
> 
> Was going through and making sure mm files have places in MAINTAINERS and
> came across this - I see you added this, but it doesn't appear to be being
> used anywhere. Should it be removed or if not wonder where it ought to go?

It seems it only gained its only user in b739f125e4eb ("i915: use
io_mapping_map_user") but reverted a month later by 0e4fe0c9f2f9 ("Revert
"i915: use io_mapping_map_user"") all that in 2021.

Ideally i915 would be converted again with the revert reasons investigated
properly this time. Otherwise we should remove the thing.

> We're contemplating an 'MM MISC' section where it could live potentially.
> 
> Cheers, Lorenzo


