Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A7C8D185C7
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 10:52:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F13BC6B0092; Thu,  8 Jan 2026 05:52:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEB736B0093; Thu,  8 Jan 2026 05:52:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DED706B0095; Thu,  8 Jan 2026 05:52:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CBA246B0092
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 05:52:41 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 77DCC1AB317
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 10:52:41 +0000 (UTC)
X-FDA: 84308483322.28.F4CBF39
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf03.hostedemail.com (Postfix) with ESMTP id E914620006
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 10:52:38 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OZWatOhS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=o90qgpF3;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OZWatOhS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=o90qgpF3;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767869559; a=rsa-sha256;
	cv=none;
	b=BQF2LpUrrZSlyvHP4z4NzrcoAIdl4ojMz4BhxBvCD7h6MmqkTsngYwsH2+WmMaqjCYTbvV
	bMPF7AVTNrzBfp8L76RX3CwdMOEk460AN97gLiV7kaZoNSNOj0hHGzaPZNxYwfr3zl3ikU
	akyQ3wpBlVcVN32KNuPYg2MWCq46kQI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OZWatOhS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=o90qgpF3;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OZWatOhS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=o90qgpF3;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767869559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yod1SBP8Av8mIX1056fUl6cNPUx3Lw9V+pfuR+yXM0c=;
	b=rIqakdoc+XTM/T7PUoX+if8LFJpyLD7w5ySwCxsCDE0doxStgTd5Q53q7FnKDxXelJ92D1
	6r2G4SN4XRyxXCPDUMXYrDAGZxoWyfPiqm7lb598yBdZcgFObSJWtZQSzBP3vg3piEznS1
	ltdsyMq+1hLolk3vkG7GkmdrlYdnB+A=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2D5C533D4C;
	Thu,  8 Jan 2026 10:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767869557; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=yod1SBP8Av8mIX1056fUl6cNPUx3Lw9V+pfuR+yXM0c=;
	b=OZWatOhSXbyKwoe/5KAlVpASvMoU7eF24kLJhBW5mHc7SVFD7CrQuTGReUBYOz1MMahnGN
	SKwdFT0f04eo5jgbEIC6OKolWFa56x2ZBwqMgklpdlW56F6au1hRizipkuQQBVibNuwYM9
	sKRNCGNPrIqMl+UYxbOCgS5zkhyEEhM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767869557;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=yod1SBP8Av8mIX1056fUl6cNPUx3Lw9V+pfuR+yXM0c=;
	b=o90qgpF3H7JtDSenbiPpXm5BCmrVnQuvPTE+gpNt/gVyGTLDm1ETaTfkAlspOmIZQulwuT
	ntg0fVPcGzfGPqAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767869557; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=yod1SBP8Av8mIX1056fUl6cNPUx3Lw9V+pfuR+yXM0c=;
	b=OZWatOhSXbyKwoe/5KAlVpASvMoU7eF24kLJhBW5mHc7SVFD7CrQuTGReUBYOz1MMahnGN
	SKwdFT0f04eo5jgbEIC6OKolWFa56x2ZBwqMgklpdlW56F6au1hRizipkuQQBVibNuwYM9
	sKRNCGNPrIqMl+UYxbOCgS5zkhyEEhM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767869557;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=yod1SBP8Av8mIX1056fUl6cNPUx3Lw9V+pfuR+yXM0c=;
	b=o90qgpF3H7JtDSenbiPpXm5BCmrVnQuvPTE+gpNt/gVyGTLDm1ETaTfkAlspOmIZQulwuT
	ntg0fVPcGzfGPqAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EE7A03EA63;
	Thu,  8 Jan 2026 10:52:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hq3jOXSMX2mdbQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 08 Jan 2026 10:52:36 +0000
Message-ID: <30ecc144-ea2c-4259-afbf-3d96849aded2@suse.cz>
Date: Thu, 8 Jan 2026 11:52:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V5 8/8] mm/slab: place slabobj_ext metadata in unused
 space within s->size
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>
Cc: akpm@linux-foundation.org, andreyknvl@gmail.com, cl@gentwo.org,
 dvyukov@google.com, glider@google.com, hannes@cmpxchg.org,
 linux-mm@kvack.org, mhocko@kernel.org, muchun.song@linux.dev,
 rientjes@google.com, roman.gushchin@linux.dev, ryabinin.a.a@gmail.com,
 shakeel.butt@linux.dev, surenb@google.com, vincenzo.frascino@arm.com,
 yeoreum.yun@arm.com, tytso@mit.edu, adilger.kernel@dilger.ca,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org
References: <20260105080230.13171-1-harry.yoo@oracle.com>
 <20260105080230.13171-9-harry.yoo@oracle.com>
 <fgx3lapibabra4x7tewx55nuvxz235ruvm3agpprjbdcmt3rc6@h54ln5tfdssz>
 <aV9tnLlsecX8ukMv@hyeyoo>
 <7uiizca4ejiqw6zegjwmou5va4kw7na7wivy4kxebrju7dsdwo@5brr7vhwf5oh>
 <aV-Kn8vfyL5mnlJv@hyeyoo>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aV-Kn8vfyL5mnlJv@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E914620006
X-Rspamd-Server: rspam10
X-Stat-Signature: uymxwwdgxr4g4caa6gfsn1j1hn6kmf4j
X-HE-Tag: 1767869558-532005
X-HE-Meta: U2FsdGVkX1+Wh/hITaka99zTb3u8Wl2rVHzDGiRG21eCLPocNlioD4DB5VVQt4cNQ53dW6tIQzG+CyJ63C4x+7ydWqofEh+Biaj2xVlckHAArm9wYqzYnWSBXFjwATCRrBifocjpwXMJx6N49qLlRzCfGjy/A1qkr8fmiVkr/8e6dtWIHPsthOr9oPkK7UWKJdsq6M7nk+kgzEYdsA2le2KLpGZAaEN3K8DvL2bZExf7bNatSirZXBVvE0QtrevDdgDojxw4WWrh4z+50/y68WM3KrCuUPIgEyMfWad4dPnwCvKhu37O0USC4dgIXioWgR/9uuTkxlT84QqA8lAZRe0AOc91WybYJsd2VhaP3QzExDglFr3aOgYvFAjKub0w1M7FedjHO/YPN83vSbNzAo2CgxtZhL7PZLOgjtAW6To6oCUxJ3zwMoPSDq7TkLxxxOGP6oztEVFKO1IiFX/zdH1H1JUn5JWQIi0lENgl5bfFsXEACycuBklcW8m30A1XNDWIba0JHQmOmt1RhbGjfe/rvUNHHr21y2zOjjnpwTHebtVnWtdc5n6XCfAVUtXWLJe8a6ktHDAjMYAlhPtsGkxcq+sTpu61za9SiN9jhA7lWQaYkK7LTHJ5Gqy5nUrQKSvL5lcnU71V9UubqJtP419YW6ZANLfVscWbxqzekve/mdt6QXuqWpH3F3C168VFlXwL2z3NCzXCp3HccWvt79u5Hqfb9go9ECffjGny4rr6loNy8qsvDdOMPgtewmYMKtiqBOrshVv5VCxB4bY7t0m/RQ5dnOLL/NYfK36ogvCT5VZZMoaNjxxMv3W1XNOsnYp9nnNMG2n4LKmoDAqyE62ogr/rDvB90PFQSZBCSv4iQnGLWAhwBhAdL0ccA+NojDPG769iYwj21t4GmqDuDuuFSrihLH7wRT8zROLUNIIS9fpeingoaW2quQHe3Mn7P/2txd75yRpn4jgGdKH
 sfgCz2fe
 hMleEiYrNTq9t1BvV4r192cPxbJiWmHiyXb70cr+fE+9tkWstwet2YALa/z7UphW0yg6MLBDum2JPztsKI0C4mI7eRPyBtuNg4HF8fG6mfp40iHYNTSbO8/h5LGYHyoUKkE0Wz2Aa5xFc9FycnOW1URo4PQuKUC8uIjHLoZjzOieq2lH82vcWYi11YBFcicJg4nwJKyKqEy3JXUHc0r4VI5/dYTfGadYrUTaJeIo0CCgQJtarL63CE5NjcLqOS9gOq1D0XJs5ulFRN+D6EbRrVLSRr7zuGLgh01QHq2gYr9n25bqMIihV3SNqzRFqo3WRRqORulsaNiVM3QLsyPsiu1mT4l4btsLgSnBPQQkT1DXG/zvU2mGft2mCeqVaCPlDihbO/q+jUyvFulK4FHuyahElbw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/8/26 11:44, Harry Yoo wrote:
> On Thu, Jan 08, 2026 at 05:52:27PM +0800, Hao Li wrote:
>> On Thu, Jan 08, 2026 at 05:41:00PM +0900, Harry Yoo wrote:
>> > On Thu, Jan 08, 2026 at 01:52:09PM +0800, Hao Li wrote:
>> > > On Mon, Jan 05, 2026 at 05:02:30PM +0900, Harry Yoo wrote:
>> > > > When a cache has high s->align value and s->object_size is not aligned
>> > > > to it, each object ends up with some unused space because of alignment.
>> > > > If this wasted space is big enough, we can use it to store the
>> > > > slabobj_ext metadata instead of wasting it.
>> > > 
>> > > Hi, Harry,
>> > 
>> > Hi Hao,
>> > 
>> > > When we save obj_ext in s->size space, it seems that slab_ksize() might
>> > > be missing the corresponding handling.
>> > 
>> > Oops.
>> > 
>> > > It still returns s->size, which could cause callers of slab_ksize()
>> > > to see unexpected data (i.e. obj_ext), or even overwrite the obj_ext data.
>> > 
>> > Yes indeed.
>> > Great point, thanks!
>> > 
>> > I'll fix it by checking if the slab has obj_exts within the object
>> > layout and returning s->object_size if so.
>> 
>> Makes sense - I think there's one more nuance worth capturing.
>> slab_ksize() seems to compute the maximum safe size by applying layout
>> constraints from most-restrictive to least-restrictive:
>> redzones/poison/KASAN clamp it to object_size, tail metadata
>> (SLAB_TYPESAFE_BY_RCU / SLAB_STORE_USER) clamps it to inuse, and only
>> when nothing metadata lives does it return s->size.
> 
> Waaaait, SLAB_TYPESAFE_BY_RCU isn't the only case where we put freelist
> pointer after the object.
> 
> What about caches with constructor?
> We do place it after object, but slab_ksize() may return s->size? 

I think the freelist pointer is fine because it's not used by allocated objects?
Also ksize() should no longer be used to fill more of the object than that
was requested in the first place.




