Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20CEFD11181
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 15:53:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49AE16B002A; Wed, 26 Nov 2025 10:53:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4732F6B002F; Wed, 26 Nov 2025 10:53:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38DF96B002A; Wed, 26 Nov 2025 10:53:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 245AE6B002A
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 10:53:21 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8195BBA931
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 15:53:20 +0000 (UTC)
X-FDA: 84153202560.26.3D22FD9
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0DE0B40011
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 15:53:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YMAuOhU7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="shG//uAk";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YMAuOhU7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="shG//uAk";
	spf=pass (imf01.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764172398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w3CdRk1/FYm1K30UHjB+Cdh7iVQGuCvTN9ZAjwyeBng=;
	b=bYf+ql/TXX4AbDk5+gXmbSpudpKEX3TwOzVw8sEQXD05f1IPW+dUOLcu3vBDeE8c70/qfg
	QIQkz7rNcAiQBe1tCNQByrBeAvINyOaTt1RvPfTPHN68jzjnmwLJN4T7jnshT/OimWkEYs
	/LV5GxRmE1oZmeqJCDXxhwMwk2Hh8QI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YMAuOhU7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="shG//uAk";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YMAuOhU7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="shG//uAk";
	spf=pass (imf01.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764172398; a=rsa-sha256;
	cv=none;
	b=IAXnt6TJNqEA3krRiOvzMQGqd+9HVpVx6uoF9EBN4BPTwkL+bnKM1QbsrnJxZkoAX8uubE
	ocDKfLVGZPFIN5lnsVox4yNRJvLlqxl3lFk7O/Umy1dvN6ZaS89oS3AfspB2LBDdkDpnke
	KwvW89mjt4rXGW2acW4xV0ges1dIgQ8=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 24D87336EA;
	Wed, 26 Nov 2025 15:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764172396; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w3CdRk1/FYm1K30UHjB+Cdh7iVQGuCvTN9ZAjwyeBng=;
	b=YMAuOhU7Gg9olSxZ4G6N3u/GCB9KhLdGTzfHF8Us2v+D46oZxeN0e2T5vIvtHDYQy7EZwF
	5gLRaMCQjzgCAzdob58E1ZiylZfi3lTXEwOKeR2nLCsLUpIgUHKIrX41Bv/eTSVPTD0lB2
	VXfCvTNCPVa7G+NfGCbJSQFsIVJXApI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764172396;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w3CdRk1/FYm1K30UHjB+Cdh7iVQGuCvTN9ZAjwyeBng=;
	b=shG//uAk1/E9AfQeu1II0vM6EuM1cJ/kaGEMqg2ALVT/ONyoJKM+Mw4GywIigOE5waTNsX
	bfJJL+aDB9IMr4Bw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764172396; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w3CdRk1/FYm1K30UHjB+Cdh7iVQGuCvTN9ZAjwyeBng=;
	b=YMAuOhU7Gg9olSxZ4G6N3u/GCB9KhLdGTzfHF8Us2v+D46oZxeN0e2T5vIvtHDYQy7EZwF
	5gLRaMCQjzgCAzdob58E1ZiylZfi3lTXEwOKeR2nLCsLUpIgUHKIrX41Bv/eTSVPTD0lB2
	VXfCvTNCPVa7G+NfGCbJSQFsIVJXApI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764172396;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w3CdRk1/FYm1K30UHjB+Cdh7iVQGuCvTN9ZAjwyeBng=;
	b=shG//uAk1/E9AfQeu1II0vM6EuM1cJ/kaGEMqg2ALVT/ONyoJKM+Mw4GywIigOE5waTNsX
	bfJJL+aDB9IMr4Bw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 19BE63EA63;
	Wed, 26 Nov 2025 15:53:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XuHxBWwiJ2nwEgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 26 Nov 2025 15:53:16 +0000
Message-ID: <eb55892e-bfd7-4a07-904a-4a4bc06eb138@suse.cz>
Date: Wed, 26 Nov 2025 16:53:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: fix vma_start_write_killable() signal handling
To: Matthew Wilcox <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
References: <20251126034404.2264317-1-willy@infradead.org>
 <CAJuCfpHmqy3jA-7YUEpLBe+cf4_4TSbimqZd+9Cc4Z30mODdZg@mail.gmail.com>
 <cc823b79-7a2e-4a73-bd9d-b0aa492807b7@suse.cz>
 <aScXSEY7v7_fcEZF@casper.infradead.org>
From: Vlastimil Babka <vbabka@suse.cz>
Content-Language: en-US
In-Reply-To: <aScXSEY7v7_fcEZF@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0DE0B40011
X-Stat-Signature: ayb6hbtxqx9rijd85s4qwtc4zuw6ynjf
X-Rspam-User: 
X-HE-Tag: 1764172397-370157
X-HE-Meta: U2FsdGVkX19NdOZ1xkWp8STEpp3p8CibCuR086WmLpwSmCXdI6rWY47NbRXQfxH/ddiuEAqtyvHV1keTRy6M1sxxam0w0X87SSYm8Vha2qiirY7XaIXuD3zrB6vXmGjod33ZHaQvSjEpvXEFjsqz7ZdkZJo3YPNyy0j7zkt4DRWQ9IuWkvKrUgYCcA6qyYiCPMc/pADqgsmqv0W/G0QQOEi2BgbsH8ptpzIhpTYliV+m3J8zUsWXSMPA+zMh71/5yGX7+k+3rcmTB28B1yIum33vsgP74izPK/9FQU2XCO1Vs6XcrNfEVjn7uyIuztqeo4hNJzcpUnouMVPCeLwAYFYxykjb6vVGF13y6MzmS+jbdl+sYRbig82yMrjiyr0Gf+baFArVjbEWvnqHPRjhtdUCDmKAwvUCLund1LMZvU7X7B9USnJvcjEFj5mwetFpL2lxyAb8HQ3B2SjgnQnBm7IhVJ77HgkzvYG44TxCxxcmJUGO3cKU5iZxt7HozruncrOOis8Lf7Rm71IVMVQ0Ttgn3dduMhKnsn6dIMrNGMvHAYFvQ5fKrAhfpTpunskYjzdbBfwA/vFvGOJJ5JQMhWsSLhjGVWFrbxrKOxnnsUtoOgeYBTEPA0nHpLjMDRhWxaQ8w3ktKkZ6IGXrz2PSdoSbD0x/OxIVkSlj6+rKj57nzTlu/YVJDpNVhbGfC8K9AlS0g8TGCRDCS5HMxVJBBVkfDIZywOkvEJMpL0TRlafxpPaELJCi3sIBO6c4ViwOocspxiAErOc7wY2es2FBHLNkVDUaIgV6BCXKYqXr+R4qvUNiWb0nZWjtYDQruxB4aI77ja8Y9JiqEnmsrwX921nIzITfWmohChMNIxUAoVYMy8uMg22VHufR9vYYbtq074V3R8G93Gsk8aaL8WpAmeGlPffwqxZqSIsPo38nju7thfho7u84q9AkIaUX2T589HssXJrIEsg7ULP1COF
 XwIzZYpP
 6akgvR1cakZvHChz4jthOddK9gmGJzJVr6HgBA8PoF6CdhQufT44B0c8d+lPKuuHw7VtK6mMzzk/IQWv6GYEjde8rjruDFFkaMEA8P1vm7juvfgU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/26/25 4:05 PM, Matthew Wilcox wrote:
> On Wed, Nov 26, 2025 at 03:36:46PM +0100, Vlastimil Babka wrote:
>> On 11/26/25 5:28 AM, Suren Baghdasaryan wrote:
>>>> Suren, Liam, Vlastimil, Lorenzo ... none of you spotted this bug.
>>>
>>> Doh! This is embarassing...
>>
>> Hand-rolled synchronization primitives are wonderful, aren't they?
> 
> That's why I liked the original approach of just using rwsems.  I
> mst admit to having not paid attention to this recently so I don't
> know what motivated the change.
> 
>>> Wait, why do we consider this as a successful acquisition? The
>>> vm_refcnt is 0, so this is similar situation to an earlier:
>>>
>>> if (!refcount_add_not_zero(VMA_LOCK_OFFSET, &vma->vm_refcnt))
>>>         return 0;
>>
>> But this means "vma is not attached" not "we failed to lock it".
>>
>>> IOW, the vma is not referenced, so we failed to lock it. I think the
>>> fix should be:
>>>
>>>         if (err) {
>>> +               if (refcount_sub_and_test(VMA_LOCK_OFFSET, &vma->vm_refcnt)) {
>>> +                       /* Oh cobblers.  While we got a fatal signal, we
>>> +                        * raced with the last user.  VMA is not referenced,
>>> +                        * fail to lock it.
>>> +                        */
>>> +                       err = 0;
>>
>> Returning 0 in this situation therefore wouldn't be correct.
>>
>> AFAIU since we started with attached vma above, it's not possible that
>> the refcount_sub_and_test here will drop the refcnt to zero. We could
>> just WARN_ON_ONCE() on the result (in a way to make also the
>> __must_check happy) and then can return err below.
> 
> But how do we know that we started with an attached VMA?  Maybe the VMA
> was in the process of being detached and still has readers?

Yeah I didn't write it properly. What I mean is we passed the
"if (!refcount_add_not_zero()" check above, which AFAIU is a "is the vma
attached?" test. If it's not attached, then also no reader could have
incremented the refcount, and we can be the only writer thanks to mmap sem.

And only a writer can also detach it, so I believe we can't see the
refcount being decremented to zero by our refcount_sub_and_test().

But I might be wrong. I'll go through Lorenzo's scenario...

