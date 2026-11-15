Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32CD4606A330
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 22:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=yNGX8YxI;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=dHWSkrl9;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=cJgxd3Yd;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=w6YCGSqQ
Received: by kanga.kvack.org (Postfix)
	id 145FE6B05B8; Sun, 15 Nov 2026 17:02:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11E4E6B05B9; Sun, 15 Nov 2026 17:02:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0347A6B05BA; Sun, 15 Nov 2026 17:02:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BED116B05B8
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 17:02:00 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 30AED14081D
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 22:02:00 +0000 (UTC)
X-FDA: 85438726800.13.7B27891
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf27.hostedemail.com (Postfix) with ESMTP id 14DE240007
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 22:01:57 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=yNGX8YxI;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=dHWSkrl9;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=cJgxd3Yd;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=w6YCGSqQ;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf27.hostedemail.com: domain of clopez@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=clopez@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794780118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1zf9DtiDcfPDq5FyebYj0+43UHmIfZzFWjiLt3zTvI4=;
	b=jIFzmH96rC5GY7GllALy5qizJw4zuSLa8Ekba+ga8UZSjVEufWIx0aButYfBjlSbOegbPT
	6Xobz+qHVXSvvLHBLyA5zOUvv9liaDAYbPXFM9Ap+H4+/do2oDEBpI4GuCMD8xhkp6gur1
	dD4TMfJcDtVIhqoieeiY4ysxhB2AiQU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=yNGX8YxI;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=dHWSkrl9;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=cJgxd3Yd;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=w6YCGSqQ;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf27.hostedemail.com: domain of clopez@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=clopez@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794780118;
	b=JS1N1X72lTcxeIJ0WIQUiFEJOW8UQE2XfTYLkmL9oz3I0Kt53675D/fC/FZo2GUlOrdQmA
	3rORoIdU6t1o4/f0R2gvfaCVpfOLtGBip0KD1m2i6a8V9inqcqNUVsQdANro+U+PBKwaMl
	hsCk4ly0G4x2eYb1PjTEwPyrMIO2KVY=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 823DA1F453;
	Sun, 15 Nov 2026 22:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794780115; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1zf9DtiDcfPDq5FyebYj0+43UHmIfZzFWjiLt3zTvI4=;
	b=yNGX8YxIAosQlOja9ZU/DwAPoErOoX9tiCZ8akKF166Lm6qYQSMCeAL3R3/sF4TQjX6FLE
	ycbjHmfI2H5imUKG32J0skIjvnlST3pMqc4fujZJvoc+xd1o3qxri9w24OytkYPztxdXa8
	mVpwdedxzbtfSWpy+SUNIgEqEP4lses=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794780115;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1zf9DtiDcfPDq5FyebYj0+43UHmIfZzFWjiLt3zTvI4=;
	b=dHWSkrl9Ab90oUOi+637KJWjEanMbqrLDo3uZW0Gyq6k0uWKl8iO8v4ZcRmM8vAWx36wiG
	v20AB2TvWuegIPCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794780114; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1zf9DtiDcfPDq5FyebYj0+43UHmIfZzFWjiLt3zTvI4=;
	b=cJgxd3YdqlBzrT0x3saP226VtNmr8Dbf0IuXsJ9QRky7GmCFPKjT/AUigeik0r1vhnYNH2
	ICgRncrTSMVHljQ9jm5u2khxArdWaJ6CMfrTjAjSrnMudJQ5V84BSRo+6RpWMXavkh/iz9
	tdLK99DGjhU5Q4PGrZawd1ea9gBCSVA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794780114;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1zf9DtiDcfPDq5FyebYj0+43UHmIfZzFWjiLt3zTvI4=;
	b=w6YCGSqQW59XynwaOG0YgMU9UeloEIJoSsXdzI1jbZzMZoXjJ4gKyf4TsH0cnQjD68KAzM
	nAStPVwSQnbzEOAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2C67B134F4;
	Sun, 15 Nov 2026 22:01:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lhSBO9Ar+mr7cQAAD6G6ig
	(envelope-from <clopez@suse.de>); Sun, 15 Nov 2026 22:01:53 +0000
Message-ID: <079c15fb-8b41-472d-b9f2-d88826e27286@suse.de>
Date: Sun, 15 Nov 2026 23:01:52 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/9] mm/mprotect: add MM_CP_PERM_UPGRADE
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-riscv@lists.infradead.org,
 seanjc@google.com, pbonzini@redhat.com, akpm@linux-foundation.org,
 david@kernel.org, peterx@redhat.com, imbrenda@linux.ibm.com,
 borntraeger@linux.ibm.com, frankja@linux.ibm.com,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>
References: <20261112142039.907090-2-clopez@suse.de>
 <20261112142039.907090-7-clopez@suse.de> <avdw0O4rWi4WrTvy@gremlin>
From: =?UTF-8?Q?Carlos_L=C3=B3pez?= <clopez@suse.de>
Content-Language: en-US
In-Reply-To: <avdw0O4rWi4WrTvy@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spam-Score: -13.50
X-Spam-Level: 
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 14DE240007
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: yngbgk7x1xzhtn1w9snym4k5sfasayny
X-HE-Tag: 1794780117-48497
X-HE-Meta: U2FsdGVkX1/CTTAzo1/kAI4WrUZbF39T6Y9C2Iw83NLteahq9sUQkj1SfJOIkzMWF3fo+6pmlkSDaLG0cfcaWudRz8AMekjVA/MmmoRCiQhweuiuyEn/tGr0DKYD53o1dbVSykjcrwzrOK/XwbBwqM3XR2Rpa22/ZvE1TCQkwrg8YDKDfj/M3O14GoAM2JUKX0Ybk9gRQ2Y81kzIjGL0Z2TVfQmmKJ2q71K7rmyAng3NTKPL5Qbocb9D8GMWielPaQzxHlTJbqvJz14qXf5PiE42arQ2bmvXCtncI76VbAQlkVHBXDKQBRieQykgR2w3gG2qxNb1YAXlc+cEFTxz40VLrpG7Frx1YD93PkFR6TGl6BCNR96W6KRMrT8Co0C6sHH9nJLFR8gBPF/HHXYq0f7KQLdLZhWxXU7opPjkmYGALdLH2z3alq3n1cU2NBOEjrR6WQrXnrvIfaDDYQQrFpLsKc/YK75KT5wHpF0pG1A5nXy5mDZnGcAoVsulctMiNkUIhbgYnFcAODMBle0pW/fJpJ6i8wjuYfb0H//wToIJY1yFxUrjJmLZTjNrbNZtQ9473VXobZkopnMRAku9L9JF1MmA1jWO9CbbEVhvFp5OMy/xcb9msaererUxzy8SQy88g2NDM7KK4TyyMFbjoQ+VdX0yDZzLouiyS2XCRGV4u23Oyg2+p/rTbC9fxcvIeq0K6WJEvadyvOS7HJ7Zsp0JAa3ESR3LTLF9tXVO+a7jRMl+pt1hfjPmEX7lzBT6xzAM0wJOy0E2jPMpLycm3tbOj7I9OPhPSsEBPgcVjiqgNvPgd1LusWR9V5K1ZGnsHF7c/8J4rEKqOyzeY++Dq5wIVHYViyH6Ko1qALYN+cVtufUqR3FpjrlDT1Ih417Lw1LEMJr/iVZuTB/YNLIAYmt7XGjKh1yuQQB7qPrKWT6UA1IWlFVAMnNbJOECXYs0m4YT8T5kDw1UhDFNLaz
 pmrF+kXP
 ZJa40ja03P9kwq1zjWo/ITFYXu6CROH9vlylAHHrzUHXCl8k9yLRObyGMjxE1FpdeHW+LHrJ938AxrlpumKjvrCRPsbCxX0uSkYCyPXxQVxGDG8p21WRhHtNTSTO9k12GUCBUlOQ3tgyXQvsZh/BKxRxyFzGV6GiPR4AdnQGvaI1pKN/1q9mBcDFS45pJ2HmNlM8o9TVjBT14TfsGu1ox/fMzC55F/JDF1T94jcs9CEGShMACx+3U0MUjE3cyxoIVChPiR4ht/UruUO4H93/yREk393G+jZdoOQ00jIGyPkZJsCxSUXXVTwPTRheYQpqswgHGElx37T5tpgz2se1WcDe38RpeQN7C53eOWx1q/rxNNC+hYJx9zbtMFiv11bdOzMucOPuqwG8ANXpC1NCrbjZa/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/13/26 9:37 PM, Lorenzo Stoakes (ARM) wrote:
> On Thu, Nov 12, 2026 at 03:20:34PM +0100, Carlos López wrote:
>> Add a change_protection() flag for changes that only add permissions,
>> so that MMU notifier users can keep their mappings and fault in the new
>> permissions later. mprotect() sets it when the new VMA flags only add
>> read, write or execute permissions, or VM_ACCOUNT, which does not affect
>> the page tables. Any other change, such as a different protection key,
>> is not an upgrade.
> 
> I'm struggling to comprehend what this means.
> 
> 'Add a flag for changes that only add 'permissions' (not defined) so that 'MMU
> notifier users' can keep mappings and 'fault' in 'the new permissions' later.
> 
> The rest of the message just states what the code does but speaks about it as if
> it was already what happened.
> 
> This needs to be completely rewritten...!

I'll rewrite it. By permissions I mean the access granted by the
protection bits in the page table entries.

> [...]
>> +/* Whether this change only upgrades/adds permissions */
>> +#define  MM_CP_PERM_UPGRADE                (1UL << 6)
> 
> What are 'permissions' exactly?

See above

> [...]
>> +static bool vma_flags_is_perm_upgrade(vma_flags_t old_vma_flags,
>> +				      vma_flags_t new_vma_flags)
> 
> No comment, random abbreviation (but just one word). Not ideal.

I'll rename. As David noted, the name I chose is not really correct.

>> +{
>> +	vm_flags_t old = vma_flags_to_legacy(old_vma_flags);
>> +	vm_flags_t new = vma_flags_to_legacy(new_vma_flags);
> 
> This is beyond appalling and a complete abuse of the VMA flags API.
> 
> You seem to have decided that you won't try to learn how the API works, so
> instead you'll just write deprecated code that I have to find time to come and
> fix up later I guess?

Sorry, I'll rewrite the helper with the vma_flags_t API, using
VMA_ACCESS_FLAGS and VMA_ACCOUNT_BIT, and document it.

> And we're at v3...!
> 
>> +	/* VM_ACCOUNT does not affect page tables */
> 
> What does this mean? And why are you referring to a deprecated constant?

I meant that setting VM_ACCOUNT does not affect the protection bits of
an entry, so it should not prevent the new flag from being set.
mprotect() sets VM_ACCOUNT when a private mapping becomes writable,
which is the case I wanted to cover. I'll explain this better.

