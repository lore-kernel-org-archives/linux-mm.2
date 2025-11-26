Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39283D10F5A
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 14:36:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BFBF6B000E; Wed, 26 Nov 2025 09:36:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 770586B0010; Wed, 26 Nov 2025 09:36:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65EB56B0011; Wed, 26 Nov 2025 09:36:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 559576B000E
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 09:36:35 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E6B7C16057C
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 14:36:34 +0000 (UTC)
X-FDA: 84153009108.03.09CBBB4
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id 74D504000F
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 14:36:32 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zLw4ZbUS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qp6oXA3b;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JPzvPdYT;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=VTWyHUzB;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764167792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7z0672rpdsxvyz3FUPlVrUalvSuihGpQm4We7XgcnJo=;
	b=FbKShwopXXMyFstNNo94TAiHAINeVOC1khAy1CR3E/aPPIDbTfjAXXcWYKIjPE+ulVTDaB
	jzNb2XMy3JT+w/uwk0tP10o8pU3sfXwa52PN0DQPzG+/kMl7orzR8psWQp85N/p+Kne7mK
	mUZ/kNwiKfDc6lo2dQ0L/MBDBeScy4A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764167792; a=rsa-sha256;
	cv=none;
	b=NfxOSS0091EpuvqmoyRUUYKj7T2fCxfItG+LYXEWMqvS4AIF5tSYaEnw1NrhJSHJGMDGnH
	yl+7TU2f02Il3BISzIeszV/l1xos/3h+nl2VSeJo7KEZQl4UCWK9NjrBCl/4Siaz/7jMvF
	Rxe7PqC3D0bLAquJVtxnTqKXfYZEEM4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zLw4ZbUS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qp6oXA3b;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JPzvPdYT;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=VTWyHUzB;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7C2F733689;
	Wed, 26 Nov 2025 14:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764167790; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7z0672rpdsxvyz3FUPlVrUalvSuihGpQm4We7XgcnJo=;
	b=zLw4ZbUS5Y/41ZMDAQQOKBR2Ec4d3NZ3ZdjyMpKj/R3vkD4H7EG1nD2ppLZ64R2+b1xKdh
	9RmfRCpJrUwUbhPeRhhOQBseIsZX2QUZGsuS6bRuzQfzT0vz1ieiDQbtgtPHaS20HRbusc
	S4GQbn7ftwxd2WJnI1hlAD/Ju2DM8KU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764167790;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7z0672rpdsxvyz3FUPlVrUalvSuihGpQm4We7XgcnJo=;
	b=qp6oXA3b6xYjCaQWjm57uRCnuLxmF9/A2RvgmLWrwWunFCKYn8+rorJYsjW9RzLe79DeI6
	5kGo8Ldcw/gTj+BA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764167789; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7z0672rpdsxvyz3FUPlVrUalvSuihGpQm4We7XgcnJo=;
	b=JPzvPdYT1Gr8HtNb0OKXnTvlF+E4nSCtGT69tKh96Xflj+oJ89C184vLPvSelvzcvWpcHR
	HvRE8sz+LNaXZnPot58M5kNoH5qlI3f575YbHy12S+6TLDf9sdPCge0WSQVWmQqYhvF+cy
	yI5DUpWPSY6JMC4m4mJ/JMYnYKCpaUQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764167789;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7z0672rpdsxvyz3FUPlVrUalvSuihGpQm4We7XgcnJo=;
	b=VTWyHUzB3zYFjL30eEJRM87vY9z2W3NNFbCdRfwVej70pXCpMHjmt7TiMIbd/NkHHfpNvJ
	8EznE4NUyxicAuDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 705B83EA63;
	Wed, 26 Nov 2025 14:36:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ICIwG20QJ2lmRgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 26 Nov 2025 14:36:29 +0000
Message-ID: <cc823b79-7a2e-4a73-bd9d-b0aa492807b7@suse.cz>
Date: Wed, 26 Nov 2025 15:36:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: fix vma_start_write_killable() signal handling
To: Suren Baghdasaryan <surenb@google.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
References: <20251126034404.2264317-1-willy@infradead.org>
 <CAJuCfpHmqy3jA-7YUEpLBe+cf4_4TSbimqZd+9Cc4Z30mODdZg@mail.gmail.com>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <CAJuCfpHmqy3jA-7YUEpLBe+cf4_4TSbimqZd+9Cc4Z30mODdZg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 74D504000F
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: c3h85rz3b8k3oszkhpzkq49isfcdamqf
X-HE-Tag: 1764167792-917755
X-HE-Meta: U2FsdGVkX185D4Zk1ujb0C75H0WZ/bPlbpi1tqSH8ISLkXzy/MlhuSqtWbg53TKPEH4v9Sa5mpJ5ju8VFlooZ/InRN1oLOk4ckW/S9B7VwX7qe5qVvJq3pvaEePE1tc2vKgsJs4bV5Q/7eeBY+oos94rQvP9zPgW9YL04q1/D41O4HgMdzbowHoh6VMgzsMpBAd2AFef2KqGsLZHavOHmVdYWf+JV6lsjE3CAU2f8fTs8kKUyflW2Xg8WdmHS0jpyo9dPPWk9jCazdkhIDssAHEdFCJn3TCEHwyBn76siQJMjgALEsHzuWssVV29H1iki8FU/BQi5cdkM8/MfrheDd7/v9SU+nFJ7Pehm0d9JZDWoALMZoa2RnEXE/eh7JGawJrqf/T2r8Zr9yPepA0w4PggPe2nGFo0nDuACQOeKHKvV+J3VVBRFnS5zXLFLhJhrAKkoSSex3J/nAgPThPgUquIGIbmT5N8lPq3aCCAVN74jTGfZfa0RxdjB6OaP4FsyA+As4xaa7hLL2jzdeqRlDar8EFiEpP9hIQEkM7wCi3e5lst0VWw8vkf1om9Qqg70Db6VaFLuirFP4oGUDlylhRrbrDXVuQosCQeymVxbvsU2nC/nrkIAoa6I+06nwqIZxbKxscsoXzKNjiByLJVWV/EfnKCtADZ9/AQcoNZfQiJoj65KG/JHJLXe2XmbO7/QJVjU50zOQeJ7wSfnNRQhHBOQVEh6+YlsIWRKUwilmz9434xXVoaebmJDqRnYykNp0E6b+UI3HpJAXWMjiFJYtZ1+aO8tENNHWdMVBfwKo2gmLbv5iVOfQbE8QVoh+BzVCXP60Iu/j8fMHP5xz3F8cwJjMBDObHCbR9+tt6LiGfD/DjEx9uu7qkJ6za/7XqOe2DVNktCRR1VKASu/UjcgryuzXdv7dIYRSkanK6TRC/x9fJctEHrBZIRA+2Ey5W0bUvu1VI26UZiAEv0zKP
 UuygVo9N
 FavXUAQ9zHwtmq6Gn679UZUNRpHNRb86zhOGYT8poBsKEGJFZbSkKJXLTNSvwtebPkp7aodRSsauWDp3ZhRMH/ZqLMztldr4NqubJ6ZBSvCLTvh1awDrloksvBiS/MwTgqTQd0tgtnfoSuhrM08LURDphX6XzUdanoLXOzPmFB5Qqp80fgL6dRs+fFHM9h2Z3SnpOkTuKNUgpv9TRMzw0ELfbuW0to1CvIPDOA9rAMuP4M1Mgsv07uaEZQSQ7I8cbIYWA1ffZxVcHhsE3XHCgEQMrD/xH0jkWsYz8TR4FutdaWyzwNdIrUvU0D+/hOogJqcC+D10f5ebRCo43jfseKzVzLB8mJnJx0wdVWEfdhCuzIa+IJHZlY8Sqk7sx2EHXRZlGvGbb9XBNg2kLV3HPhqmRfkwySNIkbIs4o7yhCMii3dungy6YPeY1JkBEbBwcoLe94UijtF/M1XZPGzZ0unc7qppFH8KRSt4AJwg22SUnxAoyV4hvG291+911Ovz9do9YWStwsAwVaimX9i1s58XhYLQE8YO5Tn4+33R2KZ4mYcfNkKgrfSaHPDRz2l+yFmTr2fbWjhDTmJOscMIDPM9COY4z6hwqtjOyYGyYwqrUcc8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/26/25 5:28 AM, Suren Baghdasaryan wrote:
> On Tue, Nov 25, 2025 at 7:44 PM Matthew Wilcox (Oracle)
> <willy@infradead.org> wrote:
>>
>> If we get a signal, we need to restore the vm_refcnt.  The wrinkle in
>> that is that we might be the last reference.  If that happens, fix the
>> refcount to look like we weren't interrupted by a fatal signal.
>>
>> Reported-by: syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com
>> Fixes: 2197bb60f890 ("mm: add vma_start_write_killable()")
>> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
>> Cc: Suren Baghdasaryan <surenb@google.com>
>> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
>> Cc: Vlastimil Babka <vbabka@suse.cz>
>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> ---
>> Andrew, since the vma_start_write_killable() patch is in mm-stable,
>> I don't think you can put this in as a fixup, right?
>>
>> Suren, Liam, Vlastimil, Lorenzo ... none of you spotted this bug.
> 
> Doh! This is embarassing...

Hand-rolled synchronization primitives are wonderful, aren't they?

>> Any other stupid thing I've done?  And am I doing the right thing
>> with refcount_set()?

I think it's not wrong, but because it's dead code anyway. So it's
unnecessary.

>>  mm/mmap_lock.c | 9 +++++++++
>>  1 file changed, 9 insertions(+)
>>
>> diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
>> index e6e5570d1ec7..71af7f0a5fe1 100644
>> --- a/mm/mmap_lock.c
>> +++ b/mm/mmap_lock.c
>> @@ -74,9 +74,18 @@ static inline int __vma_enter_locked(struct vm_area_struct *vma,
>>                    refcount_read(&vma->vm_refcnt) == tgt_refcnt,
>>                    state);
>>         if (err) {
>> +               if (refcount_sub_and_test(VMA_LOCK_OFFSET, &vma->vm_refcnt)) {
>> +                       /* Oh cobblers.  While we got a fatal signal, we
>> +                        * raced with the last user.  Pretend we didn't notice
>> +                        * the signal
>> +                        */
>> +                       refcount_set(&vma->vm_refcnt, VMA_LOCK_OFFSET);
>> +                       goto acquired;
> 
> Wait, why do we consider this as a successful acquisition? The
> vm_refcnt is 0, so this is similar situation to an earlier:
> 
> if (!refcount_add_not_zero(VMA_LOCK_OFFSET, &vma->vm_refcnt))
>         return 0;

But this means "vma is not attached" not "we failed to lock it".

> IOW, the vma is not referenced, so we failed to lock it. I think the
> fix should be:
> 
>         if (err) {
> +               if (refcount_sub_and_test(VMA_LOCK_OFFSET, &vma->vm_refcnt)) {
> +                       /* Oh cobblers.  While we got a fatal signal, we
> +                        * raced with the last user.  VMA is not referenced,
> +                        * fail to lock it.
> +                        */
> +                       err = 0;

Returning 0 in this situation therefore wouldn't be correct.

AFAIU since we started with attached vma above, it's not possible that
the refcount_sub_and_test here will drop the refcnt to zero. We could
just WARN_ON_ONCE() on the result (in a way to make also the
__must_check happy) and then can return err below.

> +               }
>                 rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
>                 return err;
>         }
> 
> 
>> +               }
>>                 rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
>>                 return err;
>>         }
>> +acquired:
>>         lock_acquired(&vma->vmlock_dep_map, _RET_IP_);
>>
>>         return 1;
>> --
>> 2.47.2
>>


