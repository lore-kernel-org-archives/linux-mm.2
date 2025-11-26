Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB84BD11193
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 18:52:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD7A76B00A3; Wed, 26 Nov 2025 13:52:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAF666B00A5; Wed, 26 Nov 2025 13:52:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC5396B00A6; Wed, 26 Nov 2025 13:52:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B9AC36B00A3
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 13:52:57 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6252A5AC23
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 18:52:57 +0000 (UTC)
X-FDA: 84153655194.11.3706E81
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf04.hostedemail.com (Postfix) with ESMTP id E6B024001A
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 18:52:54 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=m619sdMl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YBkGZoxI;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VpoTnIC9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=d2RW2DOX;
	spf=pass (imf04.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764183175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qaMKF9SZ8YYtHucN7qGyJfJdGLO71CcUofmoWL8NL8c=;
	b=aGwhJoBOzl+wGYsXSUCt/UR+wiFVeB1Gl/5ZnllwuWJ/aAdtiWICCXHFobKbhoNC73NCCW
	q6vF78kr7c1Vk8ApFDhmAVil/taTGBMFOi0ThX2Q/jWSWjjLz2inUy9L1iIxwY6LzGTSrD
	1teOw82MoTLDi70vwDtomboch+ZmrSg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=m619sdMl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YBkGZoxI;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VpoTnIC9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=d2RW2DOX;
	spf=pass (imf04.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764183175; a=rsa-sha256;
	cv=none;
	b=581SWTPlfX2se2UQkkXuAkexqXyM6mNLIbPb3dVUYw9sCjzrgORXEQrfDZjAmQqjMTro2Q
	G7zz8C1rVHkNQZvLzUjEg+9+HstXxssxGiokKenZjVUBNqcjqE7Dl8ZbLzc66qdwHBObMa
	XqJyTs+Ca99OZgZxMwPq1BNHyPKZsQ4=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E04C85BCC6;
	Wed, 26 Nov 2025 18:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764183173; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qaMKF9SZ8YYtHucN7qGyJfJdGLO71CcUofmoWL8NL8c=;
	b=m619sdMlyko/A1pxaJTfS2tV5JwmT8ekbkF7BThkjBFWOCNxCk20fNCSbdlkVh9VT040fF
	tJvhmWv3ypKup1BOwEdlk/Mnx0vMNvWRY3G333eZxKdeRXcSrOhcBUb4bupGSFBjR1brkx
	d5pRq2I4Au3LzxLvlZyg2CjdsI6dfO8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764183173;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qaMKF9SZ8YYtHucN7qGyJfJdGLO71CcUofmoWL8NL8c=;
	b=YBkGZoxImOXIQpiSD+29G8WHW356DlJoxZdin5uLBCAE5DdXwkBdu+899BuihPvbtbZEga
	Q8X08bQr11wPmEDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764183172; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qaMKF9SZ8YYtHucN7qGyJfJdGLO71CcUofmoWL8NL8c=;
	b=VpoTnIC9HjtlPbrEknh8Qcr//ICAdkKH+IS/gGziyCpDcuRnpvLkAQyhQOIWkshMM3d56U
	ByjrmLWI//jabvZo3Xl8EpVkmymrFKKEY/W/XTXQFbqjORDpwrxgMaD4h/MYEetXR8O21p
	qe5Rm9na5HcsWaCP2qrZQBeqFELTkPg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764183172;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qaMKF9SZ8YYtHucN7qGyJfJdGLO71CcUofmoWL8NL8c=;
	b=d2RW2DOXHuQ0eRe1EzkWh5yWOBT3rUFENyUmxTumilPCHgu5CVXnItrWXGMv+VQVn3la7i
	/1MWkjR2g/49U3Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D16D63EA63;
	Wed, 26 Nov 2025 18:52:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id L76pMoRMJ2kpQQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 26 Nov 2025 18:52:52 +0000
Message-ID: <ae18d781-86a3-4539-9441-079b7f45e726@suse.cz>
Date: Wed, 26 Nov 2025 19:53:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: fix vma_start_write_killable() signal handling
To: Suren Baghdasaryan <surenb@google.com>,
 Matthew Wilcox <willy@infradead.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>
References: <20251126174500.2498895-1-willy@infradead.org>
 <c35ab0c0-97c3-4565-ba2d-5c418ecac593@lucifer.local>
 <aSdGvY2UzrXdR2e3@casper.infradead.org>
 <CAJuCfpHheus2oiv94r14afjVV00XZnfqHY0p+H8fxjxCSYjg9g@mail.gmail.com>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <CAJuCfpHheus2oiv94r14afjVV00XZnfqHY0p+H8fxjxCSYjg9g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rahcoh8kkj6mt41fpwyxzug1bqr1m5z8
X-Rspam-User: 
X-Rspamd-Queue-Id: E6B024001A
X-Rspamd-Server: rspam09
X-HE-Tag: 1764183174-133799
X-HE-Meta: U2FsdGVkX1/U8rXJVPtM6fwRnghMG3B/3Lc9GvIYwGEd1LnXfGyTWKMeRL5ukTiEKY0lrjrLKdUlFOPAL6p+0xcvyM94JFkqvcAP6qMxTNWMbo3qzRp1BrLZfTle5ashEJa6zt0dS8XEw3ubyoX0LAnOhp2UlBkXvDun2TeSVVuGPnQYfkJ0NRC28fYCw8HX0gDQqPFvnt8GW4FU21BaNF/o4zqjAMu6w87ZBgI4GHIT41kDP66ON4FLm+VqFV3bE45swc9rT1xE1l3y782eGAKJ+KG3BnbiHtb2tWfHpZ7xMfq6mZDIfu5hDPhq30OS/pEFGgQssj7ljzKMFbrjGWaApz/99rTzvAXJ61dQj7jOYYHJJ2lBJb0Dfvg93CXdmVQMK/pJESotNAGfjIZobA28G1SFi3lsTicCym7zzkZoeb9BNG4SmIdyID64ZrG8aPrLC4zFPfC5RDDTxhUsbt/ExT/hm/sEs4ZYxs2i9BZaBOkhHOzlK58MOhuwpAAKmVRI9O9ofye6K6O5Tgf77vAYLi5Qj7zMCmL2pRHQz4UdjfXjkplc10YxbueWHOFrlr0LW/qlJ9KexBXlR72cnOpwXi8HBjIC6EOrOEyy0LMLzlPfmiN5xItyEHJnX6o+LBhQV5l62WpQpj0zud+p0zONUltW7WrYg/owoc1fomgtg93wbLNFa23q9ftX8poV6yvWEvC+oVfGMKGqAiRC4Vt46YAUvYiR1/RemZXxbmEYcOm5a1qXQDgxs7BD4FfgG6pIrHoyvHKXYB86GgA/AGaXlE0OBTw7x8kNOP0QmJNKaNCtYLdsmdw88EQJJB8EXnBnxQw2CsnJUs/yiR/HgHwXHW1+EHuiiUX7rKmBUifp6gh2kVkUP42UPLSwPqNYxNgnGr3UT6GS37kOF/xrjjRvqMneFbYcM/CsJjDN0PBZwpLV41Ce+84WG5Hcf1/ec3s3BKSsCXUIIemqfC7
 fcAWcdLe
 UZtEjNne1m3NruYm1JYfEDifItKR25xtYZEIYEhFeYJHce5Ftf7uYJOasOAbcfxsG5dWDy/hZMtrvPKzvhMx8ZyNbCpQkaNKI8d8DemvTQfsLjJsWVV64xzM+186lRAzNf2D+PTe2IY8Y42pbpbEIlqXNwOhxZM8C4M+azAj48+Zo06ayq97EF+UeOOVyoNU2Bn81Nptc+MvvZMgRuVQe29dAct2M78BlxtdK52Q1g0MheFe+hCTVPM5mzGkJFVpn6kSkSt3Zf2cIm6MjOJXlM1A1htFPyACMYggogECT5OnCVNqUEQLsUmJiJ1Urypxf8OUrmhsE91B9LFNRFUhD6rHUzckCLy9ri0b4ycgWttX9LuaoOlYuiBNrdFA2zpuMBeYX0HFNmciHKrRLj0KvQIRcMKITGTIF2zIKsjblYmrikjBW96V/EPuRojnW7RJHMNLEvY7u4dTZH+9Lfp/zTJ1B69byb4HXl7G7DwjrxlfIfCLIxMWzPRpM8ql/EfuOv02ay03XlJ5Z86qKYhhe7YcEs7aolY1aUFEGF4RG7qii8TSfuw2M+sv76u6xBinpsEhJO2VoRMRNEO8r/4c8uqoqje4arlfUHVSkJOmXb81E6GyrpokAs0xCF4z27GtJhZ+c67IfR5D7bh0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/26/25 7:43 PM, Suren Baghdasaryan wrote:
> On Wed, Nov 26, 2025 at 6:28 PM Matthew Wilcox <willy@infradead.org> wrote:
>>
>> On Wed, Nov 26, 2025 at 06:06:53PM +0000, Lorenzo Stoakes wrote:
>>> On Wed, Nov 26, 2025 at 05:44:58PM +0000, Matthew Wilcox (Oracle) wrote:
>>>> If we get a signal, we need to restore the vm_refcnt.  We don't think
>>>> that the refcount can actually be decremented to zero here as it
>>>> requires the VMA to be detached, and the vma_mark_detached() uses
>>>> TASK_UNINTERRUPTIBLE.  However, that's a bit subtle, so handle it
>>>> as if the refcount was zero at the start of this function.
>>>>
>>>> Reported-by: syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com

Closes: https://lore.kernel.org/all/69252076.a70a0220.d98e3.009b.GAE@google.com/

Unfortunately the reported-by code doesn't work as message id

>>>> Fixes: 2197bb60f890 ("mm: add vma_start_write_killable()")
>>>> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
>>>> Cc: Suren Baghdasaryan <surenb@google.com>
>>>> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
>>>> Cc: Vlastimil Babka <vbabka@suse.cz>
>>>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> 
>>>> ---
>>>>  mm/mmap_lock.c | 8 ++++++++
>>>>  1 file changed, 8 insertions(+)
>>>>
>>>> diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
>>>> index e6e5570d1ec7..3c9bf2f96280 100644
>>>> --- a/mm/mmap_lock.c
>>>> +++ b/mm/mmap_lock.c
>>>> @@ -74,6 +74,14 @@ static inline int __vma_enter_locked(struct vm_area_struct *vma,
>>>>                refcount_read(&vma->vm_refcnt) == tgt_refcnt,
>>>>                state);
>>>>     if (err) {
>>>> +           if (refcount_sub_and_test(VMA_LOCK_OFFSET, &vma->vm_refcnt)) {
>>>
>>> Really think we should WARN_ON_ONCE() as Vlasta suggested.

Thanks Lorenzo!

Can we at least add a "WARN_ON_ONCE(!detaching);" before "err = 0;".

>>> It's an 'impossible' situation so we should make that clear. And we should
>>> find out about it if the impossible happens... :)
>>
>> It's only "impossible" currently due to some fairly esoteric reasoning.
>> As far as _this_ function is concerned, it's entirely possible.
>> I don't want to leave this trap for the next person who calls
>> __vma_enter_locked(TASK_KILLABLE).
>>
>>>> +                   /*
>>>> +                    * We got a fatal signal, but the last reader went
>>>> +                    * away as well.  Resolve the race in favour of
>>>
>>> This is very subtle, I don't think this really explains this clearly
>>> enough.
>>>
>>> Maybe put something like:
>>>
>>>       /* Couldn't wait on readers probably due to a fatal signal, so unlock. */
>>>
>>> Before the refcount_sub_and_test()
>>
>> I think this falls into the "saying what you're doing, not why
>> you're doing it" trap.  Whereas my comment is at a higher level --
>> there's a race where both exit conditions are true at the same time.
>> The rcuwait_wait_event() picked one option, but we would rather resolve
>> the race in the opposite direction.
>>
>>> And:
>>>
>>>       /* Shouldn't be possible - VMA entirely detached, so treat it as such. */
>>>
>>> Before err = 0?
>>
>> Again though, saying it's "not possible" relies on knowing all the
>> callers of this function behave a particular way, and there's no
>> guarantee they'll continue to do so.
> 
> I agree with Matthew. Returning 0 here would work correctly even if
> vma_mark_detached() starts using TASK_INTERRUPTIBLE and 0 becomes
> possible. The comment also seems appropriate to me.
> Thanks!
> 
>>


