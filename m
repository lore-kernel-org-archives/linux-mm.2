Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40C01D262A2
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 21:28:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 874AC6B0005; Tue, 20 Jan 2026 16:28:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84CDA6B0088; Tue, 20 Jan 2026 16:28:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74F646B0089; Tue, 20 Jan 2026 16:28:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 634256B0005
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 16:28:21 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0DB06BAA28
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 21:28:21 +0000 (UTC)
X-FDA: 84353630802.22.3AF842A
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf06.hostedemail.com (Postfix) with ESMTP id 79C0E180009
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 21:28:18 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ukFmTDUU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="K/Z8I8ag";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ukFmTDUU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="K/Z8I8ag";
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768944498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GcAunUIhJXMUoQv1m80mheOHzlZ+Ht6+5c4dw4DMriQ=;
	b=t+3nZRalxmhrlBLg7D3j11bIc8YUfYtcPuYrV07qnBnXk5t0j7STvbFvBvOaQLxxQHEFMT
	UqpHSbkIK+uwHdvd0LNtzftaXw7eY/T+cq+2edrDF4EJymC/5P6rwY8Wkg0AjiFv2U9tJI
	0rrX0P9vvCCfoLozLFP9mgmc+X2CIWY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ukFmTDUU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="K/Z8I8ag";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ukFmTDUU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="K/Z8I8ag";
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768944498; a=rsa-sha256;
	cv=none;
	b=U88TmsMMx4GZESw8f9UFPS7qwo8s6zCT7cp0LTjGpTJhKINaTyM2O8dOwob6YIFebQJte2
	EtNH/Mv3O3QfneGqhqNYAZxS2pif3PDf4KbDGJPOEOy5wOawlhpUszHxQIMR03qdRi9D0Q
	/DNrhivHXBBr4OGyMoiBeEddbxv28y0=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5B84533684;
	Tue, 20 Jan 2026 21:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768944496; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=GcAunUIhJXMUoQv1m80mheOHzlZ+Ht6+5c4dw4DMriQ=;
	b=ukFmTDUUWGubsTGEGlpDs26O7n22s1NFpOwstBhY9w3aq5vB5XQdqFZagsSMG+bwXDZaO/
	UpDfgWOss8VLPwj7FLfgDg1ry1P3zMTuvj0KT5LXxiNSCNP1PxS1Ah/3fqN5CsQZHp7p5w
	neAT1c3+Ixzr42RxLryZ8FeVoZxU/Lc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768944496;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=GcAunUIhJXMUoQv1m80mheOHzlZ+Ht6+5c4dw4DMriQ=;
	b=K/Z8I8ag4bVtKifrfxpIZe8OBQkrveGd7t1sLAXBUK+vBSXouMDDMChzobYgeJKdhUtvKa
	gHE2JVkZXqZlGyCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768944496; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=GcAunUIhJXMUoQv1m80mheOHzlZ+Ht6+5c4dw4DMriQ=;
	b=ukFmTDUUWGubsTGEGlpDs26O7n22s1NFpOwstBhY9w3aq5vB5XQdqFZagsSMG+bwXDZaO/
	UpDfgWOss8VLPwj7FLfgDg1ry1P3zMTuvj0KT5LXxiNSCNP1PxS1Ah/3fqN5CsQZHp7p5w
	neAT1c3+Ixzr42RxLryZ8FeVoZxU/Lc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768944496;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=GcAunUIhJXMUoQv1m80mheOHzlZ+Ht6+5c4dw4DMriQ=;
	b=K/Z8I8ag4bVtKifrfxpIZe8OBQkrveGd7t1sLAXBUK+vBSXouMDDMChzobYgeJKdhUtvKa
	gHE2JVkZXqZlGyCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2CA413EA63;
	Tue, 20 Jan 2026 21:28:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id C2d2CXDzb2n/dgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 20 Jan 2026 21:28:16 +0000
Message-ID: <f7ed3125-e7ce-45b0-a077-a2979a6238b3@suse.cz>
Date: Tue, 20 Jan 2026 22:28:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm/vma: use lockdep where we can, reduce
 duplication
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Jann Horn <jannh@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Will Deacon <will@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
 Waiman Long <longman@redhat.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
References: <cover.1768855783.git.lorenzo.stoakes@oracle.com>
 <bd410fd91d22eef37f9b617327cafce33b267b09.1768855783.git.lorenzo.stoakes@oracle.com>
 <30f843d9-03cf-4c7c-8a29-8e11b12e47e4@suse.cz>
 <61ca35cd-5c08-4196-89b6-ec3feda69e36@lucifer.local>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <61ca35cd-5c08-4196-89b6-ec3feda69e36@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 79C0E180009
X-Stat-Signature: ag1zo3pmuspae4s14tic4b5ceyonio4o
X-HE-Tag: 1768944498-933214
X-HE-Meta: U2FsdGVkX1+Ds8UtT0w4BuH3BDvUHJqqBknvqn1kkxwtFDVG27TovyW/nBSfPI3FBxIMzLi7OiVnEB4Yk0elPF7jYPbdvoBD+m3++us9ZJHxjJxlSYK1UeyHPNYaqqws3O1U4TvaaqLh+8z24xFmIVMxDVaQHhUGf8HMdRb6Da+ugbSle4zlbmvo5MGfL52yfOFU1H7CnQp20+oat0B3sayA2VFy3SX7WcQUaK2L6hnjSGHDimUvxsfZ9Uy+JEDDtIBYm6h4peMZS4MOAsRs4DeZbyVJSA0+htYtRPPwqFD53tpR5UwRqoE7GH4gm39m+dyzIIov7z+DXpduHHoKyhlBytYe/xtTifqbGCbVfOZhEf09KFsM5uN2FE/N2mQyW03LTj5SYe4l0pzrrmzY5KPCwBTxnhn7teWNrJ34SmOoqqJVJm6ZdNZTD4U1rteske5+k3O3yvsoMv/RqXBOhlgSDCsWPhqlGpMCvXObPv1yZ/zpsfseOkGhaXDybY8S9KFEMMEE66ULd/o74o0wai0rKAzgr3IVxJs4c+NdERKDq3Ivldrf9QK2xlNeVvjfy2CKzETwxlYXH5K4tNTJL3FuUa/9fmrH7IaRBXgtnErpMa1yRXxCmnv5zBXyHgDFs08upMkieRmf8C1izeBruxslVpSEaKqdRbHVPHe6wNBSIOTS1FAFY4x5vK/J6cqkMfwaOupu8JjjRWQf+/h9Jm3o93JfqKgxe21oowRY5WPNpEOnMd6nHUKC77JLmLngPhhM6riDiIK8SICWJEjrWdlMW7nZRRU1b+CNbQmjfU+S9R+qE7DMGOSFqeHRF1/JTOHMUP9+7Z+8LScorw6QHHRmYkBjhm9Jjr+dp8fJZIjvsgNGmkK/ywqI00h14vSYSNDlPOT0MWyKXgf5rmzavT3RShS/HPdgJl/CY5Fxo0s9iGbo0H5Y4/2w7mJdV56ZYywvHuLY+9qkwPS4cVf
 jkMM03Hd
 VCbkHCMnHCOF9NfIP6O/lQ+HRDdsNSklWT2MQ57513YZsVcqApdaQJHQJHLhLxJ8g3Og8K3D7tFTk+Ue1RspviOWlRTnUr2/ZttwMgG+A4SeilEjnkqGEB7L5igBoa1oAWItXfH5uKVmL1UmIVF+uQHewBxtNL6DzcW0/2luZv/DpOju/0TzjCQNv5ACrl4JDFBcb/i9wXJtrA4+vRHOGoHJmOW6Q1ukVC+82/UAmu/n6DSkgPgMrUYtw9lGg0EZNnBcvEcr4kSBxvNrv8KxBOZPKEQZAHJN2QiuCmNmvhQu4juJbaU15b6f/ka7KA7FwPSVEAzXQ4N1d/RgPmjDHggQ87+7VWuqNLNNu4AKnYJbLcqc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/20/26 18:49, Lorenzo Stoakes wrote:
> On Tue, Jan 20, 2026 at 02:53:30PM +0100, Vlastimil Babka wrote:
>> On 1/19/26 21:59, Lorenzo Stoakes wrote:
>> > We introduce vma_is_read_locked(), which must deal with the case in which
>> > VMA write lock sets refcnt to VMA_LOCK_OFFSET or VMA_LOCK_OFFSET +
>> > 1. Luckily is_vma_writer_only() already exists which we can use to check
>> > this.
>>
>> So I think there's a bit of a caveat in that
>>
>> - is_vma_writer_only() may be a false positive if there is a temporary
>> reader of a detached vma (per comments in vma_mark_detached() and
>> vma_mark_detached())
> 
> vma_mark_detached() and vma_mark_attached() I sasume you mean.

Right.

> OK so this is all very confusing indeed.
> 
> This function is _only_ referring to the situation between
> __vma_enter_locked() and __vma_exit_locked().
> 
> Despite their names, suggesting maybe they happen on lock and unlock
> respectively, that's not the case, they're both invoked on lock and enter
> on start of TAKING lock and exit on completion of TAKING the
> lock.

IIUC yes, for the vma "write lock".

> It seems __vma_enter_locked() is more about getting into this state with
> refcnt equal to VMA_LOCK_OFFSET (detaching - note elsewhere we say detached
> of course) or VMA_LOCK_OFFSET + 1 if attached and waiting on readers who
> are spuriously increasing the reference count.

Yes.

> So fundamentally is_vma_writer_only() is actually asking 'are we in the
> midst of a VMA write lock acquisiton having finally set the VMA's refcnt to
> VMA_LOCK_OFFSET or VMA_LOCK_OFFSET+1 but haven't yet completed acquiring
> the lock' - e.g. having not yet called __vma_exit_locked().

IIUC in the current code it's not used in that "are *we* in the midst..."
sense but "is there a writer in that phase that we are supposed to wake up
because we are the last reader", where a rare false positive answer only
results in an unnecessary wakeup of said wanna-be writer, but nothing worse.

And AFAIU this patch tries to reuse the function to ask "is the vma read
locked?" (and we presume it's by us).

> With __vma_enter_locked() called from:
> 
> vma_start_write() / vma_start_write_killable()
> -> __vma_start_write()
> -> __vma_enter_locked()
> 
> vma_mark_detached()
> -> __vma_enter_locked()
> 
> OK so in __vma_enter_locked() we add VMA_LOCK_OFFSET but then wait until we
> get to either VMA_LOCK_OFFSET + 1 (attached) or VMA_LOCK_OFFSET (detached),
> since presumably refcnt == 0 is detached, refcnt == 1 means write lock
> finally acquired (but you have to check the sequence number).
> 
> And _there_ we could have spurious readers.

Yes.

> 
>>
>> - hence vma_is_read_locked() may be a false negative
> 
> Yup.
> 
>>
>> - hence vma_assert_locked() might assume wrongly that we should not assert
>> being a reader, so we vma_assert_write_locked() instead, and fail
> 
> Aside ->
> 
> 	Every time I come to this code it's like this - having to refresh
> 	my memory as to how any of it works, getting confused, etc.
> 
> 	This speaks to this being a broken abstraction similar to anon_vma.
> 
> 	What I mean by leaked abstraction is that you seem to need to
> 	maintain the _implementation_ context in your head to be able to
> 	correctly implement anything. We simply are not abstracting details
> 	here really well at all.

I think this would be true if it was applied to users of the high-level API
of the code - actual locking and unlocking for read/write. Do they have to
care about the implementation details? Hopefully not.

Here we have to think about the implementation because we are trying to
improve the API (to add assertions) so that's not surprising? If your
complaing is about an "intermediate" abstractions level like the
"is_vma_writer_only()" function then yeah it's far from perfect.

> 	The fact I got this wrong despite staring at this code for ages is
> 	indicative of that.
> 
> 	Also the fact an ostensibly simple series has turned into a
> 	'restore the context' discussion this long and taken this many
> 	hours is further suggestive.
> 
> 	I think we can do better. I'd rather not do more 'cleanup' series,
> 	but I think this badly needs it.
> 
> 	So maybe I'll convert this series into something that addresses
> 	some of this stuff.
> 
> <- Aside
> 
> 
>>
>> Howevever the above should mean it could be only us who is the temporary
>> reader. And we are not going to use vma_assert_locked() during the temporary
>> reader part (in vma_start_read()).
> 
> I don't think so? Spurious readers can arise at any time incrementing the
> refcnt via vma_start_read(), so the temporary readers could be anybody.
> 
> But they'd not get the read lock, and so shouldn't call anything asserting
> read lock.
> 
> Anyway I think my use of is_vma_writer_only() is just broken then.

AFAIU the whole thing (vma_assert_locked() after this patch) would be broken
in a case where we are really a reader and vma_is_read_locked() returns
false wrongly, and thus makes us perform vma_assert_write_locked() and fail.
So the scenarios with spurious readers can't cause that I think.

What I think could cause that is there being a writer (not us), causing
is_vma_writer_only() return true even when there's also a reader (us). And I
concluded that could happen only in case where we would be the spurious
reader racing with a detaching writer. But when we are in the temporary
spurious reader situation, we don't perform vma_is_read_locked() there.

> We _do_ need to account for the VMA write lock scenario here, but I think
> instead we should be good with refcnt > 1 && refcnt < VMA_LOCK_OFFSET no?

That check would tell us there is no writer. But there might be a writer
(not us) while we're a reader, and thus that check won't work as a signal
for "we must have the read lock"?

>> So it's probably fine, but maybe worth some comments to prevent people
>> getting suspicious and reconstructing this?
> 
> But yeah we shouldn't be asserting this anywhere during which this should
> be the case.
> 
> So hopefully the above resolves the issue?

I don't follow, but perhaps I misunderstood you above and it's late here now.

> It's still racey (write lock might have been acquired since we checked but
> that's just the nature of it.
> 
> But if we use lockdep as you mention we can actually do the same 'precise
> if lockdep, otherwise not so precise' approach in the stabilised check.
> 
> Let me respin.
>
>>
>> But I think perhaps also vma_assert_locked() could, with lockdep enabled
>> (similarly to vma_assert_stabilised() in patch 2), use the
>> "lock_is_held(&vma->vmlock_dep_map)" condition (without immediately
>> asserting it) for the primary reader vs writer decision, and not rely on
>> vma_is_read_locked()? Because lockdep has the precise information.
>>
>> It would likely make things more ugly, or require more refactoring, but
>> hopefully worthwhile?
> 
> Yeah good idea. Will do.

Ack, thanks.

> Maybe I need to make this into a broader refactoring series. Because this
> so badly needs it.

Yep :/

> Cheers, Lorenzo


