Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84D9CD1CDC6
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 08:28:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B99EE6B0005; Tue,  9 Dec 2025 03:28:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4A956B0007; Tue,  9 Dec 2025 03:28:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A12BB6B0008; Tue,  9 Dec 2025 03:28:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 907FD6B0005
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 03:28:17 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3224EC0333
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 08:28:17 +0000 (UTC)
X-FDA: 84199255434.24.4870547
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf25.hostedemail.com (Postfix) with ESMTP id AB138A000E
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 08:28:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DGO5jdZx;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FwIsDjCr;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WUPBcQrC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="qZ/hlKe+";
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765268895; a=rsa-sha256;
	cv=none;
	b=uELigIM0fxIAElR5ay4PF7wDKL9qW+qTB+YDKjvpmDvZr/30/5sNJ7t1nGjOtVXeKG9XvS
	HMGlb6V+/rXLD4uBEhLFTPdUqjyB4/7cVOhGsMett1yPhjQfIXACjx5pEPLdOZ8XrvdNK2
	HOq8mVMwBByswe/SCIj0YVzI683o6MM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DGO5jdZx;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FwIsDjCr;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WUPBcQrC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="qZ/hlKe+";
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765268895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jsH3p2DHmr98O67uVDsLynkEreYeKS7zaQ3Hg9HtGGA=;
	b=TFbO3WcoLTToPLoYlgFwBRe9nZ8mXbT6ffqdM0jF0q/XgfK/p4GPwW31pcDPAP9VsDcFA7
	hx/VVP93UzNsDS6gPISe5tOpKq5POyEg5qhrS/WIUywsI84f6zjwpo+62yuBI0smrdd+qX
	Dm75iVyVg+SuYkB30bLgEpS/GwdaGcU=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 72A585BD97;
	Tue,  9 Dec 2025 08:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765268892; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jsH3p2DHmr98O67uVDsLynkEreYeKS7zaQ3Hg9HtGGA=;
	b=DGO5jdZxmFk4OwIwA8VXBjw6FhWUeSsKRS0Y7FEFvZcq4zlh/FQinTJcBB/u6QX/KLJY78
	aTOpUqslVYfiVOpSQUtFj7LkkPDcZQlJvpeOl+KkkngmS05uglMA7cQC3m0Cf7KJNI6Rv3
	5kt4gggYDkTUPLeeWOQ/HWPBzgzpGJc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765268892;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jsH3p2DHmr98O67uVDsLynkEreYeKS7zaQ3Hg9HtGGA=;
	b=FwIsDjCrnkY8auIwXgthAT2PDUyu2go4VOqUHPjeEePe9+ABhUMlSYa/WtmPJai9yRmL0K
	rzpcnCl1C/BzsCCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765268891; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jsH3p2DHmr98O67uVDsLynkEreYeKS7zaQ3Hg9HtGGA=;
	b=WUPBcQrCYtHXLIlkd4v4R0ijMxviIlKsxnfOJtvGD7ZLRpVTL579ToFC9DVrnWHE2e8fvy
	4rLfOP9mowNd2ScvZT96bj5+OGTgxVFclgXtp3m1xA5LhQBmgbHHhzChs7HRXzHHdOTJC2
	SGOxQOAZzXw7cg3BC1Z1BD6OKeMaNeo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765268891;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jsH3p2DHmr98O67uVDsLynkEreYeKS7zaQ3Hg9HtGGA=;
	b=qZ/hlKe+Gp+YCk4mVXOzGgieKD4KhPhX2hvSYSIzkkymAjRTh6VK9R2KUnXNPFQiL9eNEd
	JoSpJHp+AfOHLgBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 567863EA63;
	Tue,  9 Dec 2025 08:28:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vVNLFJvdN2mUfwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 09 Dec 2025 08:28:11 +0000
Message-ID: <7006fa60-f4d3-4e7d-8c2b-974e9e4a1224@suse.cz>
Date: Tue, 9 Dec 2025 09:28:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: avoid use of BIT() macro for initialising VMA flags
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 David Laight <david.laight.linux@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, oliver.sang@intel.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Mateusz Guzik <mjguzik@gmail.com>
References: <20251205175037.1287366-1-lorenzo.stoakes@oracle.com>
 <20251205184342.2cfcc73e@pumpkin>
 <4eea9138-3853-457d-9113-e3caa7f00437@lucifer.local>
 <20251205213449.12bf4819@pumpkin>
 <d8bcc6b5-eb75-4a0f-99a1-295dcb04dfe8@lucifer.local>
 <e7fb4a23-5ece-4a03-8f0d-58517c388eb7@lucifer.local>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <e7fb4a23-5ece-4a03-8f0d-58517c388eb7@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AB138A000E
X-Stat-Signature: hy4yoymbz54p94gpe3cpnfpzhfgdrd1f
X-Rspam-User: 
X-HE-Tag: 1765268894-260958
X-HE-Meta: U2FsdGVkX18MwmPqcjZJDBe9en83s3a755LP/I2iHFQdPeCgfPsFj3hujV74O+vF6h65M1ZEMxu+pkMI2AsPGyxkWm6fJj2Xc9cwRSWh93D3dnys1jgdf2iHsTvgYRfRTPkm2+V2TIFoZgU0GvJDKl/tpn7EdrbnarXMA6kGnMu0ljMw1pP6Am3YNbJitdhEoZNGaT70JFUbUe+VgpxlVnwLv8mbp4OqzeE+sjIp65avOOwq+t6K8QGtjbSQDZfQcb0OBkOkPxYHS+IHOtmz1w/gvUvruy2iQ5S0iSXP4wEUScbpIgxnOPYbk5cA3vyUEWoD+Lm/1UoRcnyywTKKz30e2hRr34FfV22Ag6OH6oq8iBz8LvIFHyTmwbH1g8nobVzI3yb9i740Vj/9fLfrPZ0jjVHZ1GBFb5lUHeOo5x+eI+U+2qYdbPeR0cbiVJVKSBHFoH2/cZ8oprhkE9urZd8lzQYf6YBg5PMCfeiQEBTPN+AXklGjvwP+gaS6HA7JSVG8RoJe6pw4t4/RMMa89QWtXcnp8zI7d8rRTJ5hQgmrSy+q2wrL6FKVRfUiJAqqZr4Hmx0dbAkSUNqxjzIg5n1TZQX6xsH3Pe/fm2+iXz/Z4ZLuB3UXOGsW/VoGfKR/yHgQckQbpHOedg+9MAdEV1LfAOelDtK+J9QCe9YEnMMqtOdSWsYOQhRQPbYEjoMyAmqd8d9tHhArNsKzn5yyt7Bnf5+qCMEojwIiLGRjqzdN3sIeYyVUlXBehfmyigAyyG7wd4rX5IguZAbzct5+4E1cOqPAZhAFsPgbJRryUuzmSXWciazpZCOsevNOxFsJVFFGQMlyVticYbSNHMDXTP1RT9BueM2a7kJrnJht5v6LUMbLacqOV3qVDcN3967JBcuc5JvMazcPAPBICSw9p97hABge3VcGFZOelS6zJGkau/5lxcCWFbiCvmTrfBa1p+udmidk4HENo4OcC7W
 NatlIwar
 xp9nltTUBrkH3axt+f8OpMozzOTvMSp/pROHoxvlF/m/ggD3UizRQ6ihyR9eIcK5dYTbGafhraRENdCn7FCPZ2o0M22SU5Sdj5XYKNKe/GwOLuBXDWCKUIQNPZJuB1MJElNiPoX4fVGX9yqi1uGZLE4nlR6ab3lNFL+fAqgjK8H9nItZLNAqc7bRfDWktkf6ARzM9PbSRaf5PrkHm4xv5wewPtZXvyn4Gycz06Y8PEuWjf0+vY1GYqDqNS+u4xKLJb38YiYDKoMPz5zopcsA1woNvlaVvZ0FJc1zb2SD5HZYdOf2tHVfkYJC4Rl+ZNJL1C3z9uURpIxOMjjX9NzjqriR5rMYF2p12oisKHIHr3JUcPhLwErQ6feSF8WPxxVBrroQ2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/8/25 17:42, Lorenzo Stoakes wrote:
> On Sat, Dec 06, 2025 at 04:43:57PM +0000, Lorenzo Stoakes wrote:
>> On Fri, Dec 05, 2025 at 09:34:49PM +0000, David Laight wrote:
>> > On Fri, 5 Dec 2025 19:18:56 +0000
>> > Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
>> >
>> > > On Fri, Dec 05, 2025 at 06:43:42PM +0000, David Laight wrote:
>> > > > On Fri,  5 Dec 2025 17:50:37 +0000
>> > > > Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
>> > > >
>> > > > > Commit 2b6a3f061f11 ("mm: declare VMA flags by bit") significantly changed
>> > > > > how VMA flags are declared, utilising an enum of VMA bit values and
>> > > > > ifdef-fery VM_xxx flag declarations via macro.
>> > > > >
>> > > > > As part of this change, it uses INIT_VM_FLAG() to define VM_xxx flags from
>> > > > > the newly introduced VMA bit numbers.
>> > > > >
>> > > > > However, use of this macro results in apparently unfortunate macro
>> > > > > expansion and resulted in a performance degradation.This appears to be due
>> > > > > to the (__force int), which is required for the sparse typechecking to
>> > > > > work.
>> > > >
>> > > > Does sparse complain if you just add 0? As in:
>> > > > #define INIT_VM_FLAG(name) BIT(VMA_ ## name ## _BIT + 0u)
>> > > >
>> > > > That should change the type without affecting what BIT() expands to.
>> > >
>> > > Thanks, checked that and unfortunately that doesn't satisfy sparse :)
>> > >
>> > > I don't think it's too crazy to use 1UL << here, just very frustrating (TM)
>> > > that this is an issue.
>> >
>> > I might use some of my copious spare time (ha) to see why BIT() fails.
>> > I bet it is just too complex for its own good.
>> > Personally I'm fine with both explicit (1ul << n) and hex constants.
>> > The latter are definitely most useful if you ever look at hexdumps.
>>
>> Thanks :) yeah I just didn't want to go down that rabbit hole myself as I seemed
>> to have the answer and wanted to get it fixed, but obviously am quite curious as
>> to what on earth is causing that.
> 
> I did wonder about _calc_vm_trans(), given the 'interesting' stuff it does.

It's unlikely that this affects anything in what the benchmark stresses.
As Mateusz pointed out off-list, the profiles look like mutexes are doing
less optimistic spinning and more sleeping. Which IMHO isn't something that
this change can directly affect.

My own bloat-o-meter test before/after the fix suggests no changed code
generation (as I would indeed expect):

 At least in my case it doesn't seem to be altering the generated code (and
I would expect it wouldn't) except some weird symbols that don't look
related at all:

> ./scripts/bloat-o-meter vmlinux.o vmlinux.o.after
add/remove: 0/0 grow/shrink: 0/7 up/down: 0/-277 (-277)
Function                                     old     new   delta
print_fmt_dax_pte_fault_class               1167    1160      -7
print_fmt_dax_pmd_load_hole_class            308     301      -7
print_fmt_dax_pmd_fault_class               1252    1245      -7
saved_rsp                                3117296 3117232     -64
saved_rdi                                3117312 3117248     -64
saved_rbx                                3117304 3117240     -64
saved_rbp                                3117328 3117264     -64
Total: Before=3350750464, After=3350750187, chg -0.00%

I don't know what happened to those functions above. Could be just
insufficient build reproducibility?
Maybe the effect is just that something slightly shifts in the cpu caches?


