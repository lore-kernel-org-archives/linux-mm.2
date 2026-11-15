Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95E81606A884
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 22:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=qwaE8OCh;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=4+zODNCs;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=UL2AJR1B;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=8xD41Gpx
Received: by kanga.kvack.org (Postfix)
	id 9817E6B05B6; Sun, 15 Nov 2026 17:01:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 959A36B05B7; Sun, 15 Nov 2026 17:01:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86ED56B05B8; Sun, 15 Nov 2026 17:01:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5607D6B05B6
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 17:01:00 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BC0C6160838
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 22:00:59 +0000 (UTC)
X-FDA: 85438724238.23.7369D33
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7CAA120006
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 22:00:57 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qwaE8OCh;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=4+zODNCs;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=UL2AJR1B;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=8xD41Gpx;
	spf=pass (imf31.hostedemail.com: domain of clopez@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=clopez@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794780057;
	b=TZ1VkTe8QbXHzoKEWTd0RFOYa2F+OfW+umWDnH/vymEuFpSKDpsSHOFrIDhuXzU24WuZGU
	SEIMSOztDPTTZvkXl6WnOILux2Xdjz0uLix6dtWmLhCECPHVZSHGk4b7HuUBxJDRBzck8l
	20PoQaSQ1DZOfaqtc57HfWguDhQlb2g=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qwaE8OCh;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=4+zODNCs;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=UL2AJR1B;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=8xD41Gpx;
	spf=pass (imf31.hostedemail.com: domain of clopez@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=clopez@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794780057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7FlApLM+6NHXeyNHrZs7qFAb7ZQYfBd5O8QQnbg+ljM=;
	b=8hLkgnzD/6MSYa/Q5gMpHcv1vHkAw5gjSQFT7KVekGAl607tzV+J9Q755s8kxk3HS3Hr18
	zBIR5ZR6I7/Eu1uN7MUuaItIbGJ3NJg5xm311oocAJGD+u1uwMZagGruU217Pr5vd5l7JG
	cUWMIXK+e1N5xY5KVyGZuw22LG+D004=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 220F51F453;
	Sun, 15 Nov 2026 22:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794780056; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7FlApLM+6NHXeyNHrZs7qFAb7ZQYfBd5O8QQnbg+ljM=;
	b=qwaE8OCh9q7DPjRCRWrDN3gSH+C/rRxOO4tjyMLG9u1935rUbhmfAqEsM8HKtkWWRu9Zwg
	Edk21Rf9o6W4cR/K8rlzm3w3VQgzTPqYi4XjKDo5va8dWtQTK9ZcUoAoaK0qag7ugYH9WW
	lJyY1EnCiHEFQrN5YOkYwKlBRizhvdc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794780056;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7FlApLM+6NHXeyNHrZs7qFAb7ZQYfBd5O8QQnbg+ljM=;
	b=4+zODNCsDGJ5IVOEpCHjeUo1EVO9r5zTadv/CLmLmfPhVg+HsnElN6wR+yHo9EWPWXC3cw
	l/ef6th5jEOjNdCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794780055; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7FlApLM+6NHXeyNHrZs7qFAb7ZQYfBd5O8QQnbg+ljM=;
	b=UL2AJR1BrjXZmm+GGh4UMq32pWsgoSMmhN+u1mUj191Yfs5b2UovWRoPPLgbaxf4LoQxHe
	wCkxg0dVMwml21R9t1wsR4ic7Og+VfwWcbt6UfUHcYLsnTPWJqR53SFSh/uwgiQIBxfef2
	wFXlaHNqK/MHeQ+sqT4+M+Bw5A8iVJg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794780055;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7FlApLM+6NHXeyNHrZs7qFAb7ZQYfBd5O8QQnbg+ljM=;
	b=8xD41GpxBN+xCOa43OZxnWJbsv0+D7lCV3ihsL9anYIBLNyrixPBhfRBT9DyCinpAMuTWb
	81hngw5kGsBimuBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0D712134F4;
	Sun, 15 Nov 2026 22:00:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9PgqNJUr+moqcQAAD6G6ig
	(envelope-from <clopez@suse.de>); Sun, 15 Nov 2026 22:00:54 +0000
Message-ID: <f0a6bfcf-b131-419a-8b7d-ce10e0c507d8@suse.de>
Date: Sun, 15 Nov 2026 23:00:53 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/9] mm: fix eager write-bit restore for write-notified
 shared mappings
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-riscv@lists.infradead.org,
 seanjc@google.com, pbonzini@redhat.com, akpm@linux-foundation.org,
 david@kernel.org, peterx@redhat.com, imbrenda@linux.ibm.com,
 borntraeger@linux.ibm.com, frankja@linux.ibm.com,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Peter Feiner <pfeiner@google.com>
References: <20261112142039.907090-2-clopez@suse.de>
 <20261112142039.907090-3-clopez@suse.de> <avd12eMWaTl87uL0@gremlin>
From: =?UTF-8?Q?Carlos_L=C3=B3pez?= <clopez@suse.de>
Content-Language: en-US
In-Reply-To: <avd12eMWaTl87uL0@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spam-Score: -13.50
X-Stat-Signature: e4sei7kwx3mppn487yz6gajawdnauqn5
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7CAA120006
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794780057-820019
X-HE-Meta: U2FsdGVkX1/F2dWpW1UShVrl868o0EKyrfCQm7tvvljrlN6ZocV7TAl68ceQdXe1fR/UZDCYKo8gvnwIoWMJMACZkSiyptAj+hURO782l238W0+i1PQnFkxyswZ26JsyQkO0hN+YTfMEMDjdnQGhyq/42rYSteXMGds5kZjDwD22F0cy7S+pS+Y8ak13enaagJnADGoFw8DUJfQE45GjMHhnOJL4PDnMeZwfL+LzbxGxNn7hh9adO7tvnK7NSxx0ShLMglMY1C2+Mg1D1YZtM5tBA+Jgxl9ggxMAJKPyl/MvtJnHS4aJo8NpcsiEYeG1u8DCdWWAIupU8VVl3qdNl2n8M3PacAj/ihxTTse+3nKQZYjnnTA/8ehKATkXuhkxmYp1FFyErDGb2eYJKgHM07iGQw6FEzNECqAyvZ+3C0j02KvGbYafutcfC5DTtv4eKABhDXq6M+HOfwiRmwSD0SyVksJWzTPF5dMC0dsn0m+EOR+cQRTpQ6KiuqY4bVUtYgKUkwCukp1sH8GEu2mApgAgXqfqqjXGoSKC1RMFX2gYsP8Yyor5tl8TdTIFUQQhUj/nV/V+EaTwuzwnFeNlcwA+MgXpGIILt7N8ne1571Qfzvzp+y3EXsiT4tp5GO5jDM19mIcNczCf7lvWse3wL6ZXPGp81vfsTKlYESGETU7txYPnwnBvEKU4m0fK96BeVCn49N71flNeHVa8Qoir+aTWTWjUNhxyapdDinnJM95qxPfbs7H8N+G44e3JL4icEmAxijKBbl1B7wxufvNyL3Q13zYrnAevtoVL+8+qWfWhpKvdyKLVWEYOFG2dE1hlij9sYCiuy8QlUwDSaapwJOxzAPfC5qR7aPYn9VJpq7kHD2SRJdLl1s/zjk7sbXzIQ2z0q30wvjfgPDBWT0Mx5Nlq0NBk62GMOGFjfXIIdMi5oBrA5Noe/cfzYcG81OxOaYQsf7xxuUPmBDAYqJf
 3RPbOiFU
 FrPa93zRybgpPjc/axBnP7o2RF1kGwoQnK80MLadGk4az6UchlMqRwhO9/kt94K0BvZIsElPLSwMCJJUJo4SCzLNU4xPF36GIiDWZzr6V7uBeCFIPrhsPgrIDifPoz+9Pmv/XuzAMjiYX3SI6i++gWakrbSxupDHqtU8sWr4LvvBnxRwa2LCH0EDCKRLTt4SermzY1pNz6IVoTYNox6Yset3GfUGllaXC7T4Rx3OJAVluhntss7Vye7tz5eJ0XvUsV7+hxGeqe8i7z6sn/6kx5kQB5X7OqvRWXmyM7SgI2kCcTZS4BJKQkpkaUqx8WQb91cppmvDiZuwWFW8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/13/26 9:47 PM, Lorenzo Stoakes (ARM) wrote:
>>  static inline bool vma_wants_manual_pte_write_upgrade(struct vm_area_struct *vma)
>>  {
>>  	/*
>> @@ -596,19 +604,16 @@ static inline bool vma_wants_manual_pte_write_upgrade(struct vm_area_struct *vma
>>  	 * if we can't do that automatically for all PTEs in a mapping. For
>>  	 * private mappings, that's always the case when we have write
>>  	 * permissions as we properly have to handle COW.
>> +	 *
>> +	 * vma->vm_page_prot lacks the write bit if writenotify is already
>> +	 * enabled, so pass it with the bits restored, as vma_set_page_prot()
>> +	 * does.
> 
> We don't write code in comments.

I'll drop it.

>>  	 */
>>  	if (vma->vm_flags & VM_SHARED)
>> -		return vma_wants_writenotify(vma, vma->vm_page_prot);
>> +		return vma_wants_writenotify(vma,
>> +		       vma_pgprot_modify(vma->vm_page_prot, vma->flags));
> 
> You mention vma_set_page_prot() but then implement it differently from there and
> make no effort to abstract it?
> 
> And so both callers now do the same thing, and both open code it... you should
> abstract that.

Okay, I'll add a helper for both.

