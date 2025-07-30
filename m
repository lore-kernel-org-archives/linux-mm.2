Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72F5BC83F26
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 18:51:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 100266B0092; Wed, 30 Jul 2025 14:51:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 099186B0093; Wed, 30 Jul 2025 14:51:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA2A36B0095; Wed, 30 Jul 2025 14:51:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D5FDA6B0092
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 14:51:03 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8EEF21604D6
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 18:51:03 +0000 (UTC)
X-FDA: 83721823206.25.2B67E80
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2D17320017
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 18:51:00 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XAB1CmEL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=LPx8WEcN;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XAB1CmEL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=LPx8WEcN;
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753901461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oDmEDfpUBvEBNUKgJNpynXmBAjcVVOYDhddchKRFs5g=;
	b=WHCMchHLQuikqow1tsKw2208snIh+Xv8PJKr0uzlcCMZ8gCg90oLqs7C1wtVdqU3vXuRse
	aUwfl+DZS3wVQXL79xduDILsXIwC6sqymymWPW8s/0/P02jlgqz0vQVYErAChQWB5E0dIq
	xrfIzPyd+YPNZ58wP+GczrK76qcNe1c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753901461; a=rsa-sha256;
	cv=none;
	b=19vKjuSPQp3czvx3B6hPMcayVljVeQ8AM3yMl9I5e/As6L+pdzJvS22S9bJJfQl7chtvGD
	y/gNdqrJPG/VzWCZ4VNdkUnmMNXRCKndEhPntuJE8SCbc3fqky4ct18DNwbAYLh8/21dMY
	In3kswPQjxPEqfnIG4iBRqFj2ln3QDY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XAB1CmEL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=LPx8WEcN;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XAB1CmEL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=LPx8WEcN;
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5B6621F385;
	Wed, 30 Jul 2025 18:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753901459; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=oDmEDfpUBvEBNUKgJNpynXmBAjcVVOYDhddchKRFs5g=;
	b=XAB1CmEL8YSfYTgA7YedCmajVCMmwq42QNSJtDOZ2rgT8pafbaaolh6Ch1jZy+AUPymYmJ
	mS6fZuhChwlZtfkHEOjmMUlxaLz4anh7LDfvFSznS+hs/Qwiq2bNuU5TdipQt/K6OfpyRI
	Og60BPdTyRAPE8p8BxvScAb1zkjokHE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753901459;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=oDmEDfpUBvEBNUKgJNpynXmBAjcVVOYDhddchKRFs5g=;
	b=LPx8WEcNoosZxVHTyp6an5jl2PYF6PvYIKQ4P3Mfq6V10VyC1noKYPGQW13CKOzVx1uw5C
	8bzlLdtonRkVaXBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753901459; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=oDmEDfpUBvEBNUKgJNpynXmBAjcVVOYDhddchKRFs5g=;
	b=XAB1CmEL8YSfYTgA7YedCmajVCMmwq42QNSJtDOZ2rgT8pafbaaolh6Ch1jZy+AUPymYmJ
	mS6fZuhChwlZtfkHEOjmMUlxaLz4anh7LDfvFSznS+hs/Qwiq2bNuU5TdipQt/K6OfpyRI
	Og60BPdTyRAPE8p8BxvScAb1zkjokHE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753901459;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=oDmEDfpUBvEBNUKgJNpynXmBAjcVVOYDhddchKRFs5g=;
	b=LPx8WEcNoosZxVHTyp6an5jl2PYF6PvYIKQ4P3Mfq6V10VyC1noKYPGQW13CKOzVx1uw5C
	8bzlLdtonRkVaXBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 416581388B;
	Wed, 30 Jul 2025 18:50:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6cukD5NpimiyHgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 30 Jul 2025 18:50:59 +0000
Message-ID: <b05d424b-fa55-4e12-a1af-7504b1be20a6@suse.cz>
Date: Wed, 30 Jul 2025 20:50:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] slab updates for 6.17
To: Jason Gunthorpe <jgg@nvidia.com>,
 Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Harry Yoo <harry.yoo@oracle.com>, David Rientjes <rientjes@google.com>,
 Christoph Lameter <cl@gentwo.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Pedro Falcato <pfalcato@suse.de>, Bernard Metzler
 <bernard.metzler@linux.dev>,
 "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
 David Howells <dhowells@redhat.com>
References: <450d3876-90a9-4b1c-8d73-62ac19048991@suse.cz>
 <CAHk-=wg70=mihHE3_Te=t1Fmvrh22bcEs8bvH3tDEXZd6q+4_g@mail.gmail.com>
 <20250730184724.GC89283@nvidia.com>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20250730184724.GC89283@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2D17320017
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: j4r5opjbrjzqkn4pszuxba8qdfg4x6gf
X-HE-Tag: 1753901460-185756
X-HE-Meta: U2FsdGVkX1+DRQjLeNesM+Qf9YeTKEf2kb5NFQz8dbq2YTpFGlbqKvTNu4IXImdb2atZaCQexBVo+gP2Vd5V0DBqYzAbgQiHF3JmpV+Kl8Z30cvaOCBptnE5ZQzTE8XH7IbOUnQ9UvAyZWowMFwIEcjWyo5orbpOZ6oTOLovAWRIW68QSCC39LtuWrO8E6WpOigLUZm/Xjh73yO53oXO7vLElYs5tBzZyRweIjowapDY3dXwiJI9JM37cp3c+qBQtqVsAxw6OSKUwIbERcaVhI/R8HsDmr+ZAqFqVUeP9ujvBnXqMVXmbIy6c6KnOpLDjPUyujDitHsGVm/MUV9Q4HDZaQC6NSjSijvjur9khKBXi5TPGYIP2zqK16VQWtgTQ8xr4EqTSDuq0bFFQe+t4lrLam8M6aF36JIm7vnCG5Yc0Akus4C7KttEkaEBhpmAGxUkHX6uAlGKj7fuN12sQOW+bpBcanl6HjXj1HWt8DAySN1Pakq0Rk/Cwux3Xw1kk7pgE5yByrdUFpzswSuy2GXd4UUKEbjfhgpNHXH5YN+eWhOtpYxfe7/LIc/VSPiNjqkwF5EOM93uIHCePAlWlBx3YkxIEmb951/tUaEOQ1fVDu5TPswUyRiodoTxna+A6q8UbcnUrqjFR9Jwun7+iW76bRVAhO/NDHQgJ2Ot471sAR2wvIxahlsnZY9njfSUQQpIwQhsO2PAg8sMz60w3f1jrUpsCLrMJ6cluIzzPDmLBuUR8z7gcOx50pAzPOJew9mSxVoYZiZTDAI3hS6YxbdxmeHTOrgZckza9lGEfhTvbZxad86SnbyHtBdUJvmOWY5PKrlORtQjz9+EohOZhiP2s6GPOS8wfEfKvKJZHZbEmsMmKDlFNoZNm8Ih2W981XLY8kzaz5B1Ftsp6wdz3IinwWQBfYYs74vlziunmjgLDgE6JpZs+ycv0aFrolQ/T4i472W4raBvk6vI5Cj
 U65wrYCn
 X04MldcnSCn5yeC7qCJAg27P0EpfgCav0wOqUkJPt0cg9VkyoD4WJcO6bfPpVj0cU+YdQRyRKFgTrj/IdMoi3M8mROy1U7lO9QGQONvdsymCMxj9UrglWnZbF+QVza4gws/TDHDmJSHUJHEth3Ysb8RZfGpJcJtOVwiQy96fLRl7osEVG9mnWqVYEpaxu80dLLxS49vLwJ/6G/dEoOZIJhgFSggWNd7wnsiu3SwqZovh6mlWcZ3yNKGcaVl2NayJCfXU/u0GqGaT+VBDEXUdNTjoBQk3QSJDvW2kINw5lSJ2x5KuL/CFrNVGRG+7FKgXKlQtilMRsfdzEVp3ygjY7iaM4ncq20wFmVj3JZx237psQDkk2HdCJ+t0Yzg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/30/25 20:47, Jason Gunthorpe wrote:
> On Wed, Jul 30, 2025 at 11:42:21AM -0700, Linus Torvalds wrote:
>> On Mon, 28 Jul 2025 at 09:56, Vlastimil Babka <vbabka@suse.cz> wrote:
>> >
>> > We've hit a last-minute snag last week when lkp reported [1] the commit
>> > "mm, slab: use frozen pages for large kmalloc" exposed a pre-existing bug
>> > in siw_tcp_sendpages(). Pedro has been fixing it [2] so hopefully that will
>> > result in a PR soon, which you can pull before this one - or perhaps take
>> > the fix directly. If that gets stuck for some reason and taking the fix
>> > later would be unacceptable, I can do another PR with my commit taken out.
>> >
>> > [1] https://lore.kernel.org/all/202507220801.50a7210-lkp@intel.com/
>> > [2] https://lore.kernel.org/all/20250723104123.190518-1-pfalcato@suse.de/
>> 
>> Thanks for the heads up.
>> 
>> I've pulled this, although I don't see the rdma fix in the rdma tree

Thanks.

>> (the pull for which is still pending in my inbox - I've merged a big
>> chunk already, people have been very good about sending their pulls
>> early - thanks)
> 
> It is not there, it was unclear in the emails what should happen and I
> did not want to delay things due to your travel note.
> 
>> I'll take the fix directly in the worst case, but prefer for things to
>> go through the normal subsystem maintainer if at all possible, and
>> this one seems fairly straightforward.
> 
> I think it will be easiest for all if I send a one patch PR after you pick up
> the main RDMA PR in the next few days. siw is not so critical that we
> need to rush.

Great, thanks. The last version with ack from Bernard is here:

https://lore.kernel.org/all/20250729120348.495568-1-pfalcato@suse.de/

> Thanks,
> Jason


