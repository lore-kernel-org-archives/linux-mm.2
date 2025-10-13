Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 801BFCCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 13:07:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B23328E0045; Mon, 13 Oct 2025 09:07:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFB478E000F; Mon, 13 Oct 2025 09:07:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E9D48E0045; Mon, 13 Oct 2025 09:07:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8C27B8E000F
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 09:07:23 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2CB328769E
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 13:07:23 +0000 (UTC)
X-FDA: 83993117166.19.7A8E23D
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9364C20004
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 13:07:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WxSHAw4I;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rWFoi5F2;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HaLN6Qo9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9sAjJpKY;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760360841; a=rsa-sha256;
	cv=none;
	b=4Ax/JfzIDtRM+cReRopx7DAtIEzs1uXY/Pq31drRjA3Js/TaoyEFUinx1yhM9DJ/7AaamE
	Q6VV2NtLkCI8aYDUnSRbKJU5crX5uFcG2uWY5D+O4U67NWOJOtIoqwjUkGXS1dWlZ/3Xas
	V7ATIHEabML6CTlH1wnzsmHL9ou7lKA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WxSHAw4I;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rWFoi5F2;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HaLN6Qo9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9sAjJpKY;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760360841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E3CnuRpErbgZ0qQjMayTZw+D5tyXqR2/i+elJ1QiCcg=;
	b=YhufkRGyAbmCaGmWxWXffB3ITQ4Ca2Qsf9ifz+teQekg40m+A+e0FCCJJcGJ7aIIQKmVMX
	89AG2OWSeehr2Vzmqc+xsRJEf0udH12IuKYpgJdbKl3baG6vilXYa+jt8+Z9cU11xVoXB/
	UFl/UM4zuo46W2lP8YzZcMemjZG6H6w=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D7649219A7;
	Mon, 13 Oct 2025 13:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760360839; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=E3CnuRpErbgZ0qQjMayTZw+D5tyXqR2/i+elJ1QiCcg=;
	b=WxSHAw4IMFUn7RLE+0EdtM9sipT0TUIxYsQyP5uz53WvLjsoEZj6Ww0Nqk1rDjaJ/96gSv
	I8+UWL2fVrMsqfMmGnAg+Q7GO75F6SFChwIGrX2NMjjvjN94Awrjflq1h7ZjxixlPnZwQJ
	J1r5DxJPeqpD4DrkGgQCauYuQ/uk9GQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760360839;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=E3CnuRpErbgZ0qQjMayTZw+D5tyXqR2/i+elJ1QiCcg=;
	b=rWFoi5F2xi8+vhJ0Pn83W+YKOGfOpipbLwAmGBOky1uY+O5EKhSryQkguzE/ipdSfApR9U
	yjkd0JCjeNzKK1CA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760360838; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=E3CnuRpErbgZ0qQjMayTZw+D5tyXqR2/i+elJ1QiCcg=;
	b=HaLN6Qo9bnVAG0mENAom18/5bu7/rEo8RaEuoaCvS6oa40IU9UHmnzogATaknE4j2rnnU5
	NpRof9hmAWxibTKVn1RPb3irg7bLhzO8t+IwPOan3uCQ9LefRXWh7pZB643F5GqZdCnSHG
	4WGWM2kKLaQOXiQVNJzDEpj1KRFo9EM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760360838;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=E3CnuRpErbgZ0qQjMayTZw+D5tyXqR2/i+elJ1QiCcg=;
	b=9sAjJpKYn6yzEh84RG9SAxBlyXHF3iNOHS/Oe4RiDRCSlmBJ1HaVeUSq4fmHF+1vtPNxlt
	X2q1L7YEZ+AvYNAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C28FD1374A;
	Mon, 13 Oct 2025 13:07:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aNYuL4b57GhTRwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 13 Oct 2025 13:07:18 +0000
Message-ID: <71803dce-3fa6-494c-a4b1-55d98fc4aadb@suse.cz>
Date: Mon, 13 Oct 2025 15:07:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC RFC PATCH] mm: convert VM flags from macros to enum
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 David Hildenbrand <david@redhat.com>
Cc: Ye Liu <ye.liu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Ye Liu <liuye@kylinos.cn>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251011093054.886460-1-ye.liu@linux.dev>
 <809f552d-3282-4746-ba49-066d2bd8d44f@lucifer.local>
 <7ca0960f-9d1a-4ba4-b074-a6502578b82e@redhat.com>
 <d619784b-b967-4795-aad9-6e79d4191b83@lucifer.local>
 <dfc18351-bb77-4099-bcdd-eb2bd4f1bea5@redhat.com>
 <fa2d7db5-688c-4d04-abcd-a60f79a6bb7a@lucifer.local>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <fa2d7db5-688c-4d04-abcd-a60f79a6bb7a@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9364C20004
X-Stat-Signature: iwozhumyfo3i47ic4gpg5hba8tfh41pb
X-HE-Tag: 1760360840-696843
X-HE-Meta: U2FsdGVkX1924RLd2EiIpBbRVlEKKlJz1oiBQErsXMk1GXU3+o85Yn0tO4tzTULQaz1cdZchCzo1Faby4gACv2y1lI4ugqB9S6sbrplKODxMbqmwI8wiRDM03sg2pCmiQopO5a9R4gzz6DiLAA5I/56ZFd0R+n34j1tAvqZem6hIg5U2fxGvj15kyOwxFRojbNFJOmYWJ5OHqBB4q/CBEHTiQxUhq1VsY7Y64Jj0rWsq+6Se8S+PHKJSecYcKF5ZlFHLkpudJ095IMsZd7GQkgHICmcuvvmjVArveZJ14wIRo+XO0pzTWclQQOEhkKJm5iJdq+N+f6wpCqDNzDoH2yJvCYTGgsTwsHols5BApDNb2D0XqDEqokzBpH9iWZI3cSlMiRNAbuPPTXkHLYVTr+vnMH3B4hjtI9UTKUnfz5Na76qeawASxoBSMNMkI0hTMTwQLB4TZeNQS7470Mtx7HslM+BdK1lMzdmomJG2sQ+302kVuAoqc3U0xcZ0/R3ZrnceX646VYlts5WiN59C7m7aJjqjSzrFjIsqDouhq05F0sVCsg00NgppUMEdvFto6fX3D8csPG1JR3k4P1gEx2f7eryvIBPMaJKkDsfjJKxoYdod/jcOxfhOFhZzLj7vQzWNk6yMOlCmqFOApA7Jf8UEEqUosdxK92kFgzfYYapAuY6oTNu3ObBxnLeV3gt3vQuWHdHNeQm+Es6GGsaer15nn9mwV2Tai7h3hKe54s8hypmcv9cP99ExABl1XjQKfGuf1dWaZhd4lMkGFYDVWVf4l8gNddBdE6nEvSeIFWhmDVQoj7VT0slukNck/fCqvAKl2uLETA3OTqXXpXwsMHEdIB25WyCwPlYRAYKV4/+BF1Avl00jIe3VEoSKHf4aKxklG8yrJgV7S9gr/snYZ/t8JnrYQhz53yB9hAH4bV8OJ7/KOaettUCeJleF5rAv6UBrbVkbz1DlCKZrmry
 GYX5M6gV
 UiaeoFJ77lsqdONgRUJ3BXQ/LE2UDd5aMGYm4QHwSjeQISkjKqyA6hgfauMBMuhfqMuA1k8RvYqS4niLX9/btauBzRhQxGDaz7dOb1tByMVtm5iobluLErhQbMLOuBGGxkvGE/Nwll9Se3y+fPpfGXnUUAukyKE7giLbXEEZdhOHamJJrd+HfaWXy0jePrJQLY1O0vVc3PGuyBRWQE+GPp/6i9bPfPRKvQu3RJ0oyQPBkZMgz1L2XB4zkd2ELNlHwtmrc3xa5PiTxe4m1IZ+29n8OaveNTFONLVxC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/13/25 14:57, Lorenzo Stoakes wrote:
> On Mon, Oct 13, 2025 at 02:31:35PM +0200, David Hildenbrand wrote:
>> On 13.10.25 13:33, Lorenzo Stoakes wrote:
>> > On Mon, Oct 13, 2025 at 01:12:20PM +0200, David Hildenbrand wrote:
>> > > On 13.10.25 13:04, Lorenzo Stoakes wrote:
>> > > > On Sat, Oct 11, 2025 at 05:30:52PM +0800, Ye Liu wrote:
>> > > > > From: Ye Liu <liuye@kylinos.cn>
>> > > > >
>> > > > > Hello MM maintainers and drgn community,
>> > > > >
>> > > > > This RFC proposes to convert VM_* flags from #define macros to enum
>> > > > > vm_flags. The motivation comes from recent drgn development where we
>> > > > > encountered difficulties in implementing VM flag parsing due to the
>> > > > > current macro-based approach.
>> > > >
>> > > > This isn't going to work sorry, it's not valid to have flag values as an enum
>> > >
>> > > I don't follow, can you elaborate? IIRC, the compiler will use an integer
>> > > type to back the enum that will fit all values.
>> >
>> > switch (flags) {
>> > 	case VAL1:
>> > 	case VAL2:
>> > 	etc.
>> > }
>> >
>> > Is broken (compiler will say you cover all cases when you don't...)
>>
>> I assume you mean theoretically, because there is no such code, right?
> 
> Right, it's a general point about why enum's are not such a great idea for this.
> 
>>
>> >
>> > An enum implies independent values that exhaustively describe all state, however
>> > these flag values are not that - they're intended to be bit fields.
>> >
>>
>> Observe how we use an enum for FOLL_* flags, vm_fault_reason, fault_flag and
>> probably other things.
> 
> FOLL_* flags are an anonymous enum, enum fault_flag is not used as a type
> anywhere, nor is vm_fault_reason. So those are both kinda weird as to why we
> even name the type (they're in effect anonymous).
> 
> But also 'we do X in the kernel' doesn't mean doing X is right :)

I think the example to follow could be GFP flags. Nowadays there's an enum
below it, and a layer that adds (__force gfp_t), so you could do similar
thing with vm_flags_t.

However I'm not sure how compatible is that with Lorenzo's plans.

