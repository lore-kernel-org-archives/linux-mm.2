Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7332CA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 07:03:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5B428E0007; Fri,  5 Sep 2025 03:03:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B05098E0001; Fri,  5 Sep 2025 03:03:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F3688E0007; Fri,  5 Sep 2025 03:03:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8E8898E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 03:03:35 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 304C8140581
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 07:03:35 +0000 (UTC)
X-FDA: 83854305990.09.2E144F9
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf18.hostedemail.com (Postfix) with ESMTP id A805E1C0003
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 07:03:32 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cru9ELLZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ti5XDrz5;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=H6cma45P;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mhTlUizg;
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757055813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jDNWK+o1y/YS0I0en7giH/VTc//fJxSmKllevpf87QM=;
	b=0PtK97qlo3VMVaoymBf3V2YyHBFb2q/C0gdgjWjpTNTunkvzXcqX/W5RqhrHMEnLlYpcas
	tOzVyAAG/nkdPXFwE9RYrWCeIRkaVJNXXlUqtyany185eHsB25SBGi4a7zkFztIpSi09j+
	xDD2WPkS0hqVBfu8RaHFzR2ZmX2kJx8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cru9ELLZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ti5XDrz5;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=H6cma45P;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mhTlUizg;
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757055813; a=rsa-sha256;
	cv=none;
	b=wpyR1xKaBHMBxVbc3E1/5sfTXjBO0JQRb2l8q1czWlgQRwZyfFQOZW/XXP+/WlMxUFo9ok
	xCl0CUdb+3NJawMdcv7+QAvirY+tiWgNxxR2gm6qL6lImeMnoefcXzy6CkYJh5v3lT7zuF
	1jvRU5Vzvi0aIr0CA6iF12NIJdvKyAA=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E41FB77546;
	Fri,  5 Sep 2025 07:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757055811; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jDNWK+o1y/YS0I0en7giH/VTc//fJxSmKllevpf87QM=;
	b=cru9ELLZ7vFm1hK3pc3dq8HZYa0y6Zy/Wsqk4YcYCOuMwAz7MXpVltRmJX6arKSKyUo80G
	cPPBjGFZS9pm+kPG92CWTodhyJzUt5uqU1Dx2pqeOh+HdeOxWX/8NYZERUUj6V2rF10Cw6
	YaD+CedpZC3VWEtQHW4GWFC5I/Pg2dY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757055811;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jDNWK+o1y/YS0I0en7giH/VTc//fJxSmKllevpf87QM=;
	b=Ti5XDrz5bE95df90H7aDmTBCfiR2MYC/p616nHahMw2v4zfdc7UuhzdzvOIaE9nCZNIU/E
	cesRJLZqhy3/kRCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757055810; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jDNWK+o1y/YS0I0en7giH/VTc//fJxSmKllevpf87QM=;
	b=H6cma45Pko6dHyuctdaUcpBLRePQTjTqD+usWr+0LEENBjgNz4qLgJEA7Ea9uJ1YmEYJ7g
	TLft15KRHmCvFFlSCjx5Fu92iHcJrCR3oMRvcZSXY6UMfj5krgDWosul4O2x1IbXfaLwXd
	IkOg7RAPCLof/Hr+oi2MzoRKQLx91rM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757055810;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jDNWK+o1y/YS0I0en7giH/VTc//fJxSmKllevpf87QM=;
	b=mhTlUizgM90FEVoygwbWmbCkbgC46Y6adCQELffj6rkoDztQg9KC2UAvRnkdTlFFBnCEAo
	92k0WMQK4TdS1LCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D0245139B9;
	Fri,  5 Sep 2025 07:03:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cvEQMUKLumiPfwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 05 Sep 2025 07:03:30 +0000
Message-ID: <b371c436-1af9-41f1-811f-0425bcc468d3@suse.cz>
Date: Fri, 5 Sep 2025 09:03:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] mm: remove zpool
Content-Language: en-US
To: Vitaly Wool <vitaly.wool@konsulko.se>, hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Christoph Hellwig <hch@infradead.org>
References: <20250829162212.208258-1-hannes@cmpxchg.org>
 <20250904093325.2768507-1-vitaly.wool@konsulko.se>
 <7b1ca42d-1b89-44f4-bffb-e6b09f86fdc5@suse.cz>
 <1d42c513-cc83-4f08-a10c-cbd6206070f4@konsulko.se>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <1d42c513-cc83-4f08-a10c-cbd6206070f4@konsulko.se>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Stat-Signature: xnkaa6jrqqj87bfyderpcq9xwbxtaegf
X-Rspam-User: 
X-Rspamd-Queue-Id: A805E1C0003
X-Rspamd-Server: rspam01
X-HE-Tag: 1757055812-102499
X-HE-Meta: U2FsdGVkX18yBSf70balCLkw7PGwgixt5oNyyubenupipp3DDzD4E5vQiAvQhRvhmXyLgPfUo6Dxu/+9NkWi9NW2zeFmX7Fiz9qV+v0chGzCFCJ8m831Z+0Ud8HV2JIKSS8P13Eqefey2iZ8ruFf4q67IcuvkREcstOf33J98lWdu9Uc+Ddc0RJQGfaigHkaiDXe9HZrYjn2hh8ryPls6w6hnCVSFQ8cOm600crRdar6JmefbR2WbZH0x8ZQeTQ0SQrseLJ0W6kpiFwtmnkkcQySE0qBSBIIfVIWANLCgxpUqdQ3rV5IeE/C0GFdzkBXrkCPGRBS9QW4x4KgzUcvvhf1RMVa9M10S+gq/KzEwfMRzOQByi0VEGJvJaWE/7DSXIqEW40JoYEMlWYMo27loZviD/S5ges919wITTfAXax22drXINx22Nnfgg0R24CC7OH/jA1C160LgNY7cb5F235UsskMLmIL/RXJ1SPuHvVTLNewYBZGvNpIy6rfd8LiWOryQ1NEZoNCxcYEykspT6g9CIIZqBtHE8tIgu4QdTiUdIHz87tuHE/FJofDfETogZTNzsloZIwj+M4UN2LSgbWATEgedPmK3HJzyeSEHtZEb5xwbt1w4gpHN0lGlDZdUYQP7EeVWPBQJHdyWV1xV3y3GO+QXn9LmI9AHXPf0cPW3ULXYVoW4xXtybenFXoV6mAEZkaPna3avJuGQC/l/4SuYKZQJMU96pFffxoLC1GQy44jnSqIyD5PBYhKFkHE/uSYeZKkl820k4A6CbRoLxpTGvWNY5HL9V+9DGpl0zditmdRAQaMSwVOhXeI8NsiVvkkKaP7MHME+TqLgO5FObBKY44lurZDpINSJp41cNamcqq3tJN5B2VaER5uKiSjMgk35ooq4ecPiAGFUrhRUowU7xTZoXaTSXYyPr1VCmQGkHeUie5zuKzWKqwPfKxXZCP0njHfN1K0oV8KS9b
 6pjgwGoq
 yfeyl6QdZIa64TdWlXevgpIVSk9R+CbSYuY6X2OPFuyCg5bUR0qGmLvwPxws66tJzZhZacCf74zTH/yfVzZNwtyESTIcm62IBlCjEh6wjYFVWVLAWf8n+5BTxJG4mjdmkqMOIGtyYQk0F+FmXhCHeTHMiS5h+ZZS+69gX7XOvTcj5Nzlq6jc8ro+qywRyVIDQ0DSIW5yXd9DqAz4iFhk8JGCGKymrzIsX6kdmRwn3EPPvuwTxNnEFvJPTAoLntaAlN02mP78WDAqpOxsetTV9QkFjLQJ9Piknzpqz/Pc7ThInQEFINQDEWUKG3A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/4/25 16:11, Vitaly Wool wrote:
> On 9/4/25 12:13, Vlastimil Babka wrote:
>> On 9/4/25 11:33, Vitaly Wool wrote:
>>>> With zswap using zsmalloc directly, there are no more in-tree users of
>>>> this code. Remove it.
>>>>
>>>> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
>>>
> 
> Things keep changing, and some of the proven solutions may not be a good 
> fit moving forward. While not suggesting that we should have a handful 
> of zpool backends just for the sake of variety, I'd like to emphasize 
> that there are good reasons to have zblock (especially the Rust one), 
> and there are good reasons to keep zsmalloc. That leads to the 
> conclusion that zpool should stay.

Johannes already suggested it's possible to do that by reimplementing
zsmalloc APIs without the runtime switch layer and choosing at config time.
It would also mean zram would be able to switch.

Your argument was "zpool API is neutral and well-defined" but we don't
really care about API/KABI/etc stability inside the kernel:
Documentation/process/stable-api-nonsense.rst
So that's not a sufficient argument.

