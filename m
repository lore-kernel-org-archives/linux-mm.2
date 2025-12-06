Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1507D3B7D3
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 12:35:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEC4F6B0005; Sat,  6 Dec 2025 07:35:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9D396B0006; Sat,  6 Dec 2025 07:35:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8C0C6B0007; Sat,  6 Dec 2025 07:35:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B4B466B0005
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 07:35:28 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D3C6213B0B6
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 12:35:27 +0000 (UTC)
X-FDA: 84188991894.19.954A532
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id 75F5C80004
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 12:35:25 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JQUbakmx;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xHxRT2bL;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=NAkHy5ca;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FD7ycBcw;
	spf=pass (imf02.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765024525; a=rsa-sha256;
	cv=none;
	b=1bcAV6YbOEXnjFLOS/4K0HKoi9ksjS8CkIuuFLQ+K8XRVMT84oPOtf0AJhHq2fVNVxsSSB
	glHm3wiWn3Gt4UHRCFzPkVFz1jXamCY2kDEbQOLczg5nQRsptAd5y7rhcaU9P3gGcFHGwh
	QQgDzOmAHwVP1m49SiQhcfpMHKuBs0U=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JQUbakmx;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xHxRT2bL;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=NAkHy5ca;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FD7ycBcw;
	spf=pass (imf02.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765024525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5Nsbauxx0BTUi1oISALadbV1/HwdnVnaiXWwejprpqw=;
	b=nrHg5bIwbIDY5Q1B3GqHV7LyhU+nVafG1myWhBL6EGGZ9lQZyLFWjpBMqBxWW1cpGmtsOP
	I1khrTzKaCqG7VqXkPjtmvxGIDhh/oR3qiDtueDiXNHGOUM32Uehso1dpWoWnt/0fTVBkJ
	WplVcCz0mLV4+6PKr/TEW/U1uZPUSW0=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 525495BDAD;
	Sat,  6 Dec 2025 12:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765024523; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5Nsbauxx0BTUi1oISALadbV1/HwdnVnaiXWwejprpqw=;
	b=JQUbakmxKW/vExSuk19+LscFXwkwqMRfPxodpGlLAIhGW6b610Cby2436q/tBVI+s9Qdv+
	2k33X/W72w6yDYypUgVRbemdfOeVd7/RmqCKjW5ggC0X8lIxlhyvUTE3H9nMDoJA7UiUhA
	DDOzWiwkJEgXP4MQGngmBznbwZ1dtVQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765024523;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5Nsbauxx0BTUi1oISALadbV1/HwdnVnaiXWwejprpqw=;
	b=xHxRT2bLlu2JWhMPlfoxdhYtGL0cWylQug0SWcEUUbBqs6e5JSmMIHpWdmaK7mrI9KVd07
	rfMvDl0n3Zjhr7Cg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765024522; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5Nsbauxx0BTUi1oISALadbV1/HwdnVnaiXWwejprpqw=;
	b=NAkHy5caQcdDsuUT9AVh4gkDTCEbPXrI6upP4BgHmaN6u7+DaUkh7o4NKYCFwbWUo8yIHs
	p+T7ybDivVzxqeeRe1K8SWUUtJIE8QrtcROdA0X+GzN8QPnXufwL5Yn8sC81x+9ZGcNltD
	hNZs7EZ7NQ0/ZArNC7OdYcIhC3Vrh2s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765024522;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5Nsbauxx0BTUi1oISALadbV1/HwdnVnaiXWwejprpqw=;
	b=FD7ycBcwpixFwN9ri7OIaKPLTnbxWnUUwmsK8sP1znm1so/ofvkWAjPAeBi0k/ZUR8cvno
	sQ3LtKCc2kFwLmAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2EEF03EA63;
	Sat,  6 Dec 2025 12:35:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 13aOCgojNGmpSQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Sat, 06 Dec 2025 12:35:22 +0000
Message-ID: <47e99b07-e599-48d7-92ad-0471ed6bfd8e@suse.cz>
Date: Sat, 6 Dec 2025 13:35:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: avoid use of BIT() macro for initialising VMA flags
To: Al Viro <viro@zeniv.linux.org.uk>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, oliver.sang@intel.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251205175037.1287366-1-lorenzo.stoakes@oracle.com>
 <20251206011435.GM1712166@ZenIV> <20251206012608.GN1712166@ZenIV>
From: Vlastimil Babka <vbabka@suse.cz>
Content-Language: en-US
In-Reply-To: <20251206012608.GN1712166@ZenIV>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 75F5C80004
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: tocn9fdu34zw8e5bj37p5fm98hd67rbq
X-HE-Tag: 1765024525-810582
X-HE-Meta: U2FsdGVkX1+GC6kiwr7IzEddw3999/Z24QbKbkL8p49gLyH5kocdLbQCMmfNFnTwolow+aWbvDLyD3Vybp96o3qpC77S50aTC3dVaJtjAMZCpGGFUIuF3MoBbN/4/K1FxRDgzAMdyfeC+gYmENco7IuPnZAHXRpYftYkY1PF+AdVq2GVnQ1/kU43cRBRMxGrk4ig0SoN5VEQGZia1viqeWZOWtLQ/ZmOx9VmDzfkda7K1sDuGl/jwGSv3aQEom+SrLfWTRp39RDMMBEmJJ+xlw4g194ev3bcY4nvhsguiGK3fVmGhKhYgyFl6NJpfENaLr25FQrxwyXg2loitFwQc8ohjxHsxcWulivKxmNx3ZnLYXqt5SdBpjk3xbNj8wDwpe4MpRi61Z+ypVQoFpvnKLcpxcjqQETS71/iJGpuxnCDQu0L7M1dZvwTj1yfbqWt8PYyBDekKiX9e99xbaVT5PCc+ObEMBmUSgNtwP6LpgGzWHT9Tl3dy8xMbHK+e5U5cx6Q0os5K7S6L1o42j1cBY1MHf1X1M390+mRX2eZ09BSbzRlv1dI3GOG1tC0gEfWPfeLW4gOm6skUVYNjjx2GaLHvNwy9kTTr0FMNFaGC8dkjq7xtDXLMKqJbZO59hGrcKSQPw6JC2/0+AbognZm8+pcAyS9MZLmAk3ZgJgX9tAbw3zsowvG/dCpSLVoRUu92OJH3pHIaseQhSk9kR3srnujUfaX5lKP/i+p+y5YECNAIwsddUaC84BQal7tVBN1hljDLP9P+k+GqEPBgOORhcs7kF8ZjeBfHNIsQQ8FgQTC6+99yNl6MN8087IQwnFSfc5ZlBQ2bGMXViwEsENPpZmqDsA2kWPJ4lI8Irk6hFzpwIMygAaVA6VkIvNRqz+UnOVq97tP4/b9ksOjfsvVjJbRSxUy9vZasAGL/oMnLzwtYYczjvV4RYN2hA2o9gC3uHODn6QS4PXygU1x1QV
 QOJhE++X
 xW9xqwRzm3dUbqmOJz/9e1RBG2IsthIJN3BSD4CxjBAuvARt9JZ9puBEETfeBpmApmwu9ii2qqKM8ZvrnLbg3FUPzlSKv1xhTGnE9zvXRWa2Ix5CwuOsjZT721AWsb7PFjvXCbvw2+szizxdPPjC/KgOQRB2uDpzuU8zxi3Z/bNQO1Aa+MOlIFBJ25JxXRNx19K8g5Dh9pinTJk7mClj6gPZ/onjfIEv5bNSISOnUlbPEpWLKSbKU9bjIoQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/6/25 2:26 AM, Al Viro wrote:
> On Sat, Dec 06, 2025 at 01:14:35AM +0000, Al Viro wrote:
>> On Fri, Dec 05, 2025 at 05:50:37PM +0000, Lorenzo Stoakes wrote:
>>> Commit 2b6a3f061f11 ("mm: declare VMA flags by bit") significantly changed
>>> how VMA flags are declared, utilising an enum of VMA bit values and
>>> ifdef-fery VM_xxx flag declarations via macro.
>>>
>>> As part of this change, it uses INIT_VM_FLAG() to define VM_xxx flags from
>>> the newly introduced VMA bit numbers.
>>>
>>> However, use of this macro results in apparently unfortunate macro
>>> expansion and resulted in a performance degradation.This appears to be due
>>> to the (__force int), which is required for the sparse typechecking to
>>> work.
>>
>>> -#define INIT_VM_FLAG(name) BIT((__force int) VMA_ ## name ## _BIT)
>>> +#define INIT_VM_FLAG(name) (1UL << (__force int)(VMA_ ## name ## _BIT))
>>
>> What the hell is __bitwise doing on these enum values?
>> Could we please get rid of that ridiculous cargo-culting?
>>
>> Bitwise operations on BIT NUMBERS make no sense whatsoever; why are those
>> declared __bitwise?

I was confused by this too at first when reviewing, but instead of the angry
display above, simply asked the author and got answers.

Comment says:

/**     
 * typedef vma_flag_t - specifies an individual VMA flag by bit number.
 *      
 * This value is made type safe by sparse to avoid passing invalid flag values
 * around.
 */     
typedef int __bitwise vma_flag_t;

It's done as documented in Documentation/dev-tools/sparse.rst section
"Using sparse for typechecking".

So yeah the keyword is __bitwise and indeed we don't perform bitwise operations
on the VM_ values, in fact we don't perform any operations without __force
casting them back first, to catch when they are used by mistake.
It's not cargo-culting, IIRC it catched a bug in an early version of the
patch itself.

I wouldn't mind if sparse provided a different keyword than __bitwise
for this use case to make it less misleading. Or even better if we could
make the compiler itself treat vma_flag_t as a "special int" that can't
be implicitly cast to a normal int, so we don't have to rely on sparse
checks to catch those.

 
> FWIW, bitwise does make sense for things like (1 << SOME_CONSTANT);
> then you get warned about arithmetics and conversions to integer
> for those, with bitwise operations explicitly allowed.
> 
> VM_... are such; VMA_..._BIT are not.  VM_READ | VM_EXEC is fine;
> VM_READ + 14 is nonsense and should be warned about.  That's where
> __bitwise would make sense.  On bit numbers it's not - what makes
> VMA_BIT_MAYREAD ^ VMA_BIT_SHARED any better than 3 * VMA_BIT_MAYREAD?


