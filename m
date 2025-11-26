Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EFA6D10F58
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 16:03:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A31696B002D; Wed, 26 Nov 2025 11:03:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E21A6B002E; Wed, 26 Nov 2025 11:03:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D15A6B002F; Wed, 26 Nov 2025 11:03:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 78FCB6B002D
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 11:03:53 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 350E414068D
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 16:03:53 +0000 (UTC)
X-FDA: 84153229146.15.2E02729
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf25.hostedemail.com (Postfix) with ESMTP id C9BB3A001A
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 16:03:50 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kPKZ3wAG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uqIQ+n9a;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Lk/Nhk9G";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=n5TJLFtk;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764173031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RPrG5VZ8dbFpMl1gPbnglTWqVMWpkRXRRbryOB85xqw=;
	b=YXfaytPNhNG4jh/Iw/+5MKS2swkVBFEFCrVoFIttAaoSyTuxvvE87L09OxVjla3HJHZ2Sv
	PS2rhayXESbEkJM2c8x/nd84UxMpyYITWtvbnJftNzVKYFWK+TdaKAUfSByi48gV2dildZ
	vSCGq+//ww/10nXt/Vn9wpTFrlbeAr8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764173031; a=rsa-sha256;
	cv=none;
	b=ZefvvpsX1XPikKhOjUV2Iqk7mRWg89UTOwwE1PMez05SKsgAIvcWaLDdeoCAg2TpGdFfnC
	fmMwAP4+OsStE5ucvciMtjWVs00hAjub82YVW4L9uV/OPi3c2Ev01M9/ZVzEpmZtTXdGAM
	4/FQbxP5qGcM4C6e54P0VXGU0O39EC0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kPKZ3wAG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uqIQ+n9a;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Lk/Nhk9G";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=n5TJLFtk;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D429B336D7;
	Wed, 26 Nov 2025 16:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764173029; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RPrG5VZ8dbFpMl1gPbnglTWqVMWpkRXRRbryOB85xqw=;
	b=kPKZ3wAG4De8dA9ywTCIpWMlGogGUjnt9+umVRpLbbB0aMJtLAsf35QdqJ2bNF6fQA61NB
	BPYdWPYOPFL/9N7Y3heA+ivgGfyTg3/5eyPPluUqGMFUemKpT2tUd+zn1/uNaeuDAXv++T
	mWEM2coeohzXwuknOUd1pBPDTwnnO+0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764173029;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RPrG5VZ8dbFpMl1gPbnglTWqVMWpkRXRRbryOB85xqw=;
	b=uqIQ+n9aoFgiG2ulF7mdBC5ShVr3P31mH6P2r8uI6JAsOhkYSSPhIe0abcp6ddwXwrZsN9
	E7CU0v3nazHgBFDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764173028; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RPrG5VZ8dbFpMl1gPbnglTWqVMWpkRXRRbryOB85xqw=;
	b=Lk/Nhk9GRyOztzS3y/+CfjpVWvYFMV5ST8hVRbqPyw6X7HLf5zjdLNlW1RJ3NcFAhSJmfT
	T5PGPrm1/UjH9VUhjC+l02mLdQR4+vJJiYZWDUOpKzu2qsktMud2BNX9QNQiu57IwXEz8d
	HlEovPRq+xQmFEUWCiUS72St/G4FOa0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764173028;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RPrG5VZ8dbFpMl1gPbnglTWqVMWpkRXRRbryOB85xqw=;
	b=n5TJLFtkRGCdOsOeMwe5e3krGhGSVdQz+hqbXPxg2fDsOqwGzZzo5A6jATNiejRPQtr1Zu
	rTeShEmf0D6YVOBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C77883EA63;
	Wed, 26 Nov 2025 16:03:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AL1rMOQkJ2nQHQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 26 Nov 2025 16:03:48 +0000
Message-ID: <058f5858-f508-40f8-adfe-e5de78621d64@suse.cz>
Date: Wed, 26 Nov 2025 17:04:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: fix vma_start_write_killable() signal handling
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Matthew Wilcox <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>
References: <20251126034404.2264317-1-willy@infradead.org>
 <CAJuCfpHmqy3jA-7YUEpLBe+cf4_4TSbimqZd+9Cc4Z30mODdZg@mail.gmail.com>
 <cc823b79-7a2e-4a73-bd9d-b0aa492807b7@suse.cz>
 <aScXSEY7v7_fcEZF@casper.infradead.org>
 <44f4d9b7-45e3-4d2e-b1df-cab8e254e54e@lucifer.local>
From: Vlastimil Babka <vbabka@suse.cz>
Content-Language: en-US
In-Reply-To: <44f4d9b7-45e3-4d2e-b1df-cab8e254e54e@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C9BB3A001A
X-Stat-Signature: e58i36zach8sqwgmfhwijaosdjq58gc1
X-HE-Tag: 1764173030-157665
X-HE-Meta: U2FsdGVkX18Vz7jSBLNJvwfDunr8vDHIaZ9lIBRBoBP2f3JFoJUmNy2qcb7lOoxvsvOKe1MGf+zqECaLnGW5YtfH6cYdcS4L8uqjlB7n/F5YOcl+Qb4QUG+QPbtky2cS0QNKp6KFiHYKQYIOnaf9ovOH+NXJedfRlwa4P9xggTulAcOkI/E4yxt5ws3KPqaNQbIP3gpdvJ52PXL55c0Qnfg+CIEZysLreJlouRg+FSLXrhSMrvJ/VBvtmQvgNRqA0aH0VSBGrwuLZ9d12vbaKszX3sJxsioaHjHpsYX/d6GPthxpI6OeGUMTNZJmTe1VxiYdjauTEo7PVDyEIqPT6QkP9uaFyvQfqTr618gM9gSJBXkfIjZp3onZXmnTzS/g7e/mGPWgP2GgzLoiiDiBHjnH6OeQDGE+0aJkFBqkKGmz58/r+zVuC3n6NaHckiKO9KHj6IkwlpgsHANPB3gaJnWx4G1YR1dbfQgAxC4KSiAy8oU8Snx2J40Q/KG5cEHdFAXkY6fxYlhUP7Yt5ob0L1MU56IwAkPf147KKJDOozgv8MJnLfg9r29Xa9hd8GwMxetHdMnbtGatGQzN+oanOKk28feKGrNATM48w5Es2unTWShJBsAfyqQF37mmU+WMQgSy+jVw/dzunknTRy7795wNRUJX1mta6kTUX+6gw1ubusGn4ALvRg9jYpKqEurkkah8G1vJKR3ZUtbL8X2ss97sxsuka1scYHRZRzKM7QKLXExs6s1MU8W7Gb+BfYok45GuF1BDAA8crY1PqAzVGQ9JShTMB+3trIyn8VLkXDw4TIUGR85g+WDh19lPVA47I8eCanRK3KrwJQx+QZA/NPNviJ7DqTWmBcMMxekqdc/0W9gLT5SZP5OmO8BOy3dav9LNUfaUHr41jSkM491w6GRBSpG6XLX5hyyOqq5KWHccvjnn7XiZbpJuUt6Ocqd85o7tveQeWr1tWfLZPnc
 7lUuSHKp
 +/bfQijY28sumJM6FcFAJJI6X0APextATntwwE6CLiQvNXnsg0hVoIla0xzer1zZr8ehUcLIjDBVH+Ck2UrxMhtwKjV49w4opcuDEwaNZmnQUyCw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/26/25 4:20 PM, Lorenzo Stoakes wrote:
> On Wed, Nov 26, 2025 at 03:05:44PM +0000, Matthew Wilcox wrote:
>> On Wed, Nov 26, 2025 at 03:36:46PM +0100, Vlastimil Babka wrote:
>>> On 11/26/25 5:28 AM, Suren Baghdasaryan wrote:
>>>>> Suren, Liam, Vlastimil, Lorenzo ... none of you spotted this bug.
>>>>
>>>> Doh! This is embarassing...
>>>
>>> Hand-rolled synchronization primitives are wonderful, aren't they?
>>
>> That's why I liked the original approach of just using rwsems.  I
>> mst admit to having not paid attention to this recently so I don't
>> know what motivated the change.
>>
>>>> Wait, why do we consider this as a successful acquisition? The
>>>> vm_refcnt is 0, so this is similar situation to an earlier:
>>>>
>>>> if (!refcount_add_not_zero(VMA_LOCK_OFFSET, &vma->vm_refcnt))
>>>>         return 0;
>>>
>>> But this means "vma is not attached" not "we failed to lock it".
>>>
>>>> IOW, the vma is not referenced, so we failed to lock it. I think the
>>>> fix should be:
>>>>
>>>>         if (err) {
>>>> +               if (refcount_sub_and_test(VMA_LOCK_OFFSET, &vma->vm_refcnt)) {
>>>> +                       /* Oh cobblers.  While we got a fatal signal, we
>>>> +                        * raced with the last user.  VMA is not referenced,
>>>> +                        * fail to lock it.
>>>> +                        */
>>>> +                       err = 0;
>>>
>>> Returning 0 in this situation therefore wouldn't be correct.
>>>
>>> AFAIU since we started with attached vma above, it's not possible that
>>> the refcount_sub_and_test here will drop the refcnt to zero. We could
>>> just WARN_ON_ONCE() on the result (in a way to make also the
>>> __must_check happy) and then can return err below.
>>
>> But how do we know that we started with an attached VMA?  Maybe the VMA
>> was in the process of being detached and still has readers?
> 
> So we're talking about:
> 
> vma_mark_deteched()
> -> refcount_dec_and_test() [ ref count is zero ]
> -> __vma_enter_locked()

I think it's refcount is NOT zero to continue with __vma_enter_locked().

> (meanwhile...)
> 
> -> reader attempts to read
>   -> optimistic check doesn't successfully find write locked VMA
>   -> __refcount_inc_not_zero_limited_acqure() somehow doesn't notice 0 refcount and increments
>     (??? how)

That shouldn't be possible, yeah. But per above, it's actually not zero.

> (back to vma_mark_attached() -> __vma_enter_locked())

Back to _attached()? but it's _detached() above? You mean _detached()
right? Just to be sure

> -> refcount_add_not_zero() returns true

Ack.

> [ process gets fatal signal ]
> 
> -> rcuwait_wait_event() errors out
> -> oopsies need to do something, maybe [VM_]WARN_ON() not right?

AFAICS from vma_mark_detached() we use the TASK_UNINTERRUPTIBLE variant
so this path can't error due to the fatal signal.

> Correct me if the above is wrong.
> 
> I mean is any of this actually possible...?
> 
> Seems dubious. But I guess right now we assume it _is_ possible. What a mess!
> 
> (Again I wonder why we made our lives so difficult here)
> 
> Anyway even if we are midway through a detach, the detach is ostensibly waiting
> for the readers to go away, and our reader is about to go away anyway, but the
> process has a fatal signal so do we even care?

Yeah I guess it's for the best to keep vma_mark_detached() use the
TASK_UNINTERRUPTIBLE variant, maybe document why. Aborting the detaching
would be counter productive.

> I actually wonder if a WARN_ON() is warranted to see if this even ever
> happens...

Not for this path, but for vma_start_write_killable -> __vma_start_write
-> __vma_enter_locked(... TASK_KILLABLE). I think it still can't
trigger, but since we need to check result of the
refcount_sub_and_test() anyway, we might as well WARN_ON it.

> OK just going to reattach... my head which just exploded from the above :P
> 
> Cheers, Lorenzo


