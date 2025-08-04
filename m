Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B161CC87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 13:15:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 219458E0002; Mon,  4 Aug 2025 09:15:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A2D98E0001; Mon,  4 Aug 2025 09:15:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06A4B8E0002; Mon,  4 Aug 2025 09:15:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E71D78E0001
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 09:15:47 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4F24F1402CA
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 13:15:47 +0000 (UTC)
X-FDA: 83739122334.06.B4E58B3
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf27.hostedemail.com (Postfix) with ESMTP id B7E714000D
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 13:15:44 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Q6FFNn4h;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="vLdMo/A4";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ITCqr7yX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EIYCr3Bh;
	spf=pass (imf27.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754313345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WMPWWHhrTXPvA1icKZUtAEPt8ynjhF4y04qotWUq7l0=;
	b=PJvSZkq4ghbBXkgdJ7pwk9IqYD2yEBErqJYOlrOp+JC83mcWfUeFHv0XPkMpapyQlezRrA
	Rk5K/P0TAWnVQ2sE7syhcLeRMSDNFSGBwUAdSkF8/E0OQG3XQi1ozzI4TtCy/n7hOueRKY
	USVZO1aeNvBRyIk2vCzr9jFBiRgAkXE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754313345; a=rsa-sha256;
	cv=none;
	b=6ZBhxPrfECaNJzFuAdQdJ2hxGiiQhaiIUZWAx1y61ZgVwV7FmB0Tw22Cfbgc5DLuO9f8FN
	K9hmXGEziirHh5unHJK3JiLy06FFnO9zDATiCkyUuA9gKrrnnGdzJ9qcGhZDhvcqcbn+V4
	e/qnSRapE/5TKAT3yIEZO/iCIyKEhhg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Q6FFNn4h;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="vLdMo/A4";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ITCqr7yX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EIYCr3Bh;
	spf=pass (imf27.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E64AE21A91;
	Mon,  4 Aug 2025 13:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754313343; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=WMPWWHhrTXPvA1icKZUtAEPt8ynjhF4y04qotWUq7l0=;
	b=Q6FFNn4hlSZX3OZ8vcBw5cO00Chc0W4hi/QEqCbbELwxj85RPzUP3GiqNholR9+3nkwLJk
	tkN/QuB1u6W8dLzquHxmyIAKYVYV7zX0Tw/LYJlTbipsu4rFkazbKv8SzC062psUzcLZFP
	smgn2Ulb1BE+EPfgpBtQmQ+ifjZZbpQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754313343;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=WMPWWHhrTXPvA1icKZUtAEPt8ynjhF4y04qotWUq7l0=;
	b=vLdMo/A4HNTcHlqnEu+9lyN11LrQtO7MqBNT1nTWpbbQzY+r3xlsIt4e46Jg8fk0CaUCCX
	HQrBqJI1yRpJRbAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754313342; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=WMPWWHhrTXPvA1icKZUtAEPt8ynjhF4y04qotWUq7l0=;
	b=ITCqr7yXekZp/xj2q/soz7gmlxPz88tNbfEbfdiffXJhmYpHsUyNiHQf1wsfsa1RYdaMt2
	BSmQ00svHAPWuMYsUoyN2MwTy+qKid7lTOlJGaboHfagGwd84QLxuVrtQYKofS5X8H9de7
	0BFs/bO4vIdqnw/XBQahJX7XqZY+3xo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754313342;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=WMPWWHhrTXPvA1icKZUtAEPt8ynjhF4y04qotWUq7l0=;
	b=EIYCr3Bh2CVUZGTSA53BQtIl3NXO4tAWc1MqZ8YndobgyrozagpxHfUXB9BlT3e9Q4paEA
	tdX/QiFsdc3IDCBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C814813695;
	Mon,  4 Aug 2025 13:15:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3qx/MH6ykGhxSwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 04 Aug 2025 13:15:42 +0000
Message-ID: <04103944-bb22-45c4-8fe8-2a0a6554a289@suse.cz>
Date: Mon, 4 Aug 2025 15:15:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: memory: Force-inline PTE/PMD zapping functions for
 performance
To: David Hildenbrand <david@redhat.com>, Li Qiang <liqiang01@kylinos.cn>,
 akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com
References: <20250804123923.296230-1-liqiang01@kylinos.cn>
 <c441e6ee-3118-4603-8c77-c5b2ef40982b@redhat.com>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <c441e6ee-3118-4603-8c77-c5b2ef40982b@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B7E714000D
X-Stat-Signature: 5yxjgt9hb79xxwqzq71rxe1eabcgc18f
X-Rspam-User: 
X-HE-Tag: 1754313344-205256
X-HE-Meta: U2FsdGVkX186h2bm/9PHOA1kzlBxVesdVh7geL1+jKxk37gF4SvYdQN53qwNowWzQnIgfDBMtzqcpIr67lbRGqOfG/aSy57F/+qltIAdwZHGskx3MylelXQw5orbCE/w1UV8gLsi0FOheG0CLeJEbO6Chac8lPY/lreXbkWWcSscXzlXysRX+8ctRd4owykcJ7lGXPHmvcxgYhujuznR7phPpJam0Wq7kN1Ix4hI5FKqY7KrIGSTC6gV0ZepfjewwXujwHhYie5EBQe8krgoXyDX4KWhhrbJS35BmzPFz2hv7gYI5ygLf0XaC4RolI/hrcy6iY/Yoj2jXpZR6Ll8HZICIpUCuvKy9TVKUFVDUwuhQQfiw53d0FCfBXEnMdOkelaBYzdaTEuZo+0QGyAxr1k8whnA0k5E/SedsVl/FqJW7I7Wv2W/yXRDydPyPFUgvwdGimMMISdyAwS9cb+qzLgw6V3of+2B7kQOL50wk6K1RiDoHhUeQg498aP7ouV+CKO2eviBYjcXfDLcs1akMuy/1NPRfVEvghfcdSHe5c91IctRYEU8TOUUDXZ5MpZDb5oNfVJWez2AII74yT2MOOqEUeKRGMuy6kMgSQBPxe0RKjozs2+2lgWQSzInd0F1oSBWnPUczJDSHRZcSnFLDbHnCWRXpjplD4Qfv8XJO3UdqYq3kIdjpEgzyinDS8s1814zmwyZgluR9nBdrPSyLiUpbxGDvURGrcVWZKb3/rttgXFgcVF+ONQZc4L6Lr/yC7+0nBnN4ZUJ8X8zPmCXvvw1pkZf9EsHZm9flHT3Azsvg2/A6TytD9AtpAzbCIT18aM0rpJM1yE4C/6b7N5q2IktI8VsbbDGIXegC5lMvnfG4Wdm4BQtz7c6AtZZARq7iim1WnnL/7EEr7xopz7h2+0kfJH1PCu15IZkXGVgP1gefvj38qW9s7Pllb7bofDtpRcLo/6xbEoKSNJPxqT
 hdiAdSWq
 1wlYdv2OFKQ6yd9yn8hcRRr141ACE9sEkiP0QBSRePKAMYnwfw70gKY6YSAdAyNWp1QCX6UXeDau+mNhJkgKhW4kEhuBmb1NZAETB0JLD3DKHsHbRDWrhosvlxxeUuWaE901Cuub/kEttLu6/2qH2FovP799ldWFb0vgCF03TPMj3VjL4ibzWxrJ/goMpcLP/yKRR/tLFLQO4nTYFduSrnpJFVdNkYdq2oKJKATav9BF6Hqt3bMNdM7EFXrNJeQ4pKOXNkFuxMqWgx2+MYRRMpN0t8Miae0hBedIF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/4/25 14:51, David Hildenbrand wrote:
> On 04.08.25 14:39, Li Qiang wrote:
>> This change converts several critical page table zapping functions from
>> `inline` to `__always_inline`, resulting in measurable performance
>> improvements in process spawning workloads.
>> 
>> Performance Impact (Intel Xeon Gold 6430 2.1GHz):
>> - UnixBench 'context1' test shows ~6% improvement (single-core)
>> - UnixBench  shows ~0.6% improvement (single-core)
>> - mm/memory.o size reduced by 2.49% (70190 -> 68445 bytes)
>> - Net code reduction of 1745 bytes (add/remove: 211/166)
>> 
>> The modified functions form a hot path during process teardown:
>> 1. zap_present_ptes()
>> 2. do_zap_pte_range()
>> 3. zap_pte_range()
>> 4. zap_pmd_range()
>> 
>> Signed-off-by: Li Qiang <liqiang01@kylinos.cn>
>> ---
> 
> What's the object file size change?

The output of ./scripts/bloat-o-meter would be the most informative.


