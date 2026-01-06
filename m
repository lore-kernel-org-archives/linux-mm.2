Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC91FCE9D43
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 14:57:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D25D6B0095; Tue,  6 Jan 2026 09:57:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1531B6B0096; Tue,  6 Jan 2026 09:57:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0211B6B0098; Tue,  6 Jan 2026 09:57:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E78456B0095
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 09:57:52 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9639DB6DFC
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 14:57:52 +0000 (UTC)
X-FDA: 84301843584.09.0778583
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5D23512000D
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 14:57:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yU2piV4r;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qeeWPcu7;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yU2piV4r;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qeeWPcu7;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767711470; a=rsa-sha256;
	cv=none;
	b=vV9upBsIffiflRhWfzqtbxrSUEVPAXp25mTYcre9h90nRB+tK44ZJ3z8VEUbAyjnrKd1JK
	jQa95WgGm7Dir/rbyDg3vtxmzl4t2AgOQwTcRYe6n6Js4QuvIIX9rwop5scAxGucJL1BH7
	LLfFfQxebFZ+QCrNPOg0PtgVskSlhM8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yU2piV4r;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qeeWPcu7;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yU2piV4r;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qeeWPcu7;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767711470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qsC/YcxIIP/Q71kGi1j7c+YPs+5yV/hT9CXO0tg+FGQ=;
	b=d3Rt+GaqQUkcjHYMp3xc4eKgTQNacnNIP84locMr9RJAzsE6xhGuYFrJK8OHlnYPKM8G/O
	d1K+zf24XbPityz/20DZWBC5gu4y9RQn+2dat0SLn/7EQAQ0ROxVQKVsAEOi+uxAgzsiZ9
	HSbmCHfDuVJRAQ1xg6oTlMqlI1UGxJU=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AF81C5BCCC;
	Tue,  6 Jan 2026 14:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767711468; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qsC/YcxIIP/Q71kGi1j7c+YPs+5yV/hT9CXO0tg+FGQ=;
	b=yU2piV4rRZkvq0fusw3n+7BgmqHKqurPCmo+7zB0IJ1OMqHtDfsJKgu5cbIHBLf23qkWmS
	HfQnCl3tcIbuOiscI3DAjUo3P62KndLO1hePwaMB/5/prlKGqVElrNBSHCG7MuQRe1Xsnc
	v/oNmivhiZmDTlQ+o9ANX1JbYOPFRjY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767711468;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qsC/YcxIIP/Q71kGi1j7c+YPs+5yV/hT9CXO0tg+FGQ=;
	b=qeeWPcu7eqCoOWgCEkxmWV07IxyWhSH254njJCG7y351BUGT1a0jqlsPEoFcRBmmMUL0d9
	BnPtwryejHlNccDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767711468; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qsC/YcxIIP/Q71kGi1j7c+YPs+5yV/hT9CXO0tg+FGQ=;
	b=yU2piV4rRZkvq0fusw3n+7BgmqHKqurPCmo+7zB0IJ1OMqHtDfsJKgu5cbIHBLf23qkWmS
	HfQnCl3tcIbuOiscI3DAjUo3P62KndLO1hePwaMB/5/prlKGqVElrNBSHCG7MuQRe1Xsnc
	v/oNmivhiZmDTlQ+o9ANX1JbYOPFRjY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767711468;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qsC/YcxIIP/Q71kGi1j7c+YPs+5yV/hT9CXO0tg+FGQ=;
	b=qeeWPcu7eqCoOWgCEkxmWV07IxyWhSH254njJCG7y351BUGT1a0jqlsPEoFcRBmmMUL0d9
	BnPtwryejHlNccDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 997FE3EA63;
	Tue,  6 Jan 2026 14:57:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kkMkJewiXWkLDwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 06 Jan 2026 14:57:48 +0000
Message-ID: <f003dce3-b338-477a-bbf0-128f31e3f7ca@suse.cz>
Date: Tue, 6 Jan 2026 15:57:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] mm: only interrupt taking all mm locks on fatal
 signal
Content-Language: en-US
To: =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel.daenzer@mailbox.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Mikulas Patocka <mpatocka@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Alex Deucher <alexander.deucher@amd.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, amd-gfx@lists.freedesktop.org,
 linux-mm@kvack.org, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>
References: <b672e17b-461d-16ae-e7d3-45d3c1aab142@redhat.com>
 <7whbqlfrwjr4z2d4bpny3rjyl5tetdyx7ccf52uvby7hgywoym@6l6m2xcytez7>
 <e597171a-cc64-4811-a043-db2e539aaf94@mailbox.org>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <e597171a-cc64-4811-a043-db2e539aaf94@mailbox.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5D23512000D
X-Stat-Signature: mwt4pd877ymxrtmjyrujtsf5am6cp8mu
X-Rspam-User: 
X-HE-Tag: 1767711470-974241
X-HE-Meta: U2FsdGVkX1+8TDnmNPNXy1hKawEafwZXBSm+P7a9OTpQ2CaPn7joDuROeOay67F0VAwwIR0af1FeXlS6r9BPAodNoUvDAUO4ld0Wnl9pYeOp/iVq3GFFudpjgbnn4lT3eO35Y5jRKIvJbPaMz2EDwVkYn6foXn25MjewfQ34Z4QhaNntyOowvjCfcBV8BbL1SFxBhCtQoABEIz+iiIEOmO1pk1nS2anFgpLW0kJ0NFhJcM5rPgg08QdimIVyUFPzpUcXoPbIvuwf+myqoFcESzdKaMtCdwMnN9YLA4m2xjo4IOjvuRkxHUm3kzNIR9UEvzrT3ATxEdI8e9PRz+fVdP2G6167tNTS4aJodxNk4gWrEk7oS49RZK0i7+wG4M0sw7b8vr7r0751qbmzzUWoI0waWfhgKYhoG+bDqVCbu767WWOPJky9GmzMEHkCgduQLuMZGaz/yxYwjkyEBmRrEH9mLHFMX85mtJU6euA0YBI0Yea1Cvxxc/r94G2rbJaAQMg27NCSvx3uCWJzd1ZxbxVXzONmWXW7o0wdda9o7uZCiEH8jamAN4P2sThGPtlEpeKvB6WQx2yvYxsEYnOr1HxsP0CfNeaeohnKmOoKAq72N5rgad97sgE9dhIzhPl0ZMo2ISQn9/ruxkzUs0PzxbeqGqdbt7WsuYpOBDtGnzQLblxl5i3Hfastt7DD/Lq88MlAc+4HW0F6HdvSk04eJ172UDL3FusvDDTzp0pwGfXflVfOctYku+8weZHl9DwyKQkky7UpMaVqpGbsvKw9zNhxSEUlqMIl3cYNqAJZ2JhH6+4lx5UYiMXDTyqC/L6GqQj5e+3TuQXgnxILCa2FHiFypAQM98/2Lvz9lEycP6CngAj5imPP6pOB+Hv0bxfPlzlMEAhG3dRusz6IULKzi8quXtcqKKrSZ4mdxdkiF1B+rW/5fcy4HR5oL8lG+30ovmgEruBwHXY5Mh5912I
 JS+l4r+4
 zd1BJVXQQHjyJFJ8yhaIJ/xor2HWfINW1Au8HVAGmNqtIdJ9csQXfxeKEXXgosnfko2r+U2XKIFJoKBUgWGWd3XD2NnD+U3Hly+Pj6/jV8YiWxuXiKndwdJJLR7Up/a7Nz/Pl46OyWqgsJ4bNBn6iDgdgTA4eVFObO61341S8AD/BSl65DA92czCaeI3xezddV5WGrFweS31QnZrLVzkdSwqfEXy/qC4cAp9fnz/sMrrz5W2LNf+3pMUcyJ9htrCyHQ+riPqWTW8OW/yVeozDWl8z0/DzpdQKjqXlI9zatw8bUBOAQC/xYZ4UzvRfYA1lgOLWynNRhjUIWUh8wJW3tq7EDg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/6/26 12:36, Michel Dänzer wrote:
> On 1/5/26 19:15, Liam R. Howlett wrote:
>> * Mikulas Patocka <mpatocka@redhat.com> [260104 16:17]:
>>
>> I'm not saying it's wrong to change the signal handling, but this is
>> very much working around a bug in userspace constantly hammering a task
>> with signals and then is surprised there is a response that the kernel
>> was interrupted.
> 
> I'd go further than that. If user space fails to retry the system call
> in response to -EINTR, that's a user-space bug, period. It can happen
> anytime for any number of other reasons. (That most system calls happen
> to get away without it most of the time doesn't make it not a bug)
> 
> (This is assuming the system call can be safely retried, otherwise
> returning -EINTR to user space for non-fatal signals would be a kernel
> bug)

This is true and the userspace should be fixed. But the kernel still tries
hard to support even broken userspace.
Even though commit 7906d00cd1f6 is very old now, from 2.6.27, we could say
that technically it violated the "do not break userspace" rule.
It's not always easy to undo such breakages, especially after many years,
and if some other userspace meanwhile starts depending on the new behavior.
But I doubt that's the case here and anything will have issues with
non-fatal signals being delayed.

>>> I'm submitting this patch for the stable kernels, because this bug may
>>> cause random failures in any code that calls mm_take_all_locks.
>> 
>> They aren't random failures, they are a response to a signal sent to the
>> process that may be taking a very long time to do something.
>> 
>> I really don't see how continuously sending signals at a short interval
>> interrupting system calls can be considered random failures, especially
>> when the return is -EINTR which literally means "Interrupted system
>> call".  How else would you interrupt a system call, if not a signal?
>> 
>> I feel like we are making the code less versatile to work around the
>> fact that userspace didn't realise that system calls could be
>> interrupted without a fatal signal.
>> 
>> And from that view, I consider this a functional change and not a bug
>> fix.
> 
> I agree.
> 
> 


