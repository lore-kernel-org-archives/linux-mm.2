Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A48ED25021
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 20:24:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72E8F6B0088; Sat, 10 Jan 2026 15:24:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D9026B0089; Sat, 10 Jan 2026 15:24:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D15B6B008A; Sat, 10 Jan 2026 15:24:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5079D6B0088
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 15:24:42 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C030FB7361
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 20:24:41 +0000 (UTC)
X-FDA: 84317182362.02.3550428
Received: from fout-b2-smtp.messagingengine.com (fout-b2-smtp.messagingengine.com [202.12.124.145])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9A69640013
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 20:24:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=bsbernd.com header.s=fm1 header.b=JTWFp3nG;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="v QRjGHL";
	spf=pass (imf04.hostedemail.com: domain of bernd@bsbernd.com designates 202.12.124.145 as permitted sender) smtp.mailfrom=bernd@bsbernd.com;
	dmarc=pass (policy=none) header.from=bsbernd.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768076679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HIjvHAvQOdvsu9w9pgBxXhvqwLspuvmXIf95Cc7uW8Y=;
	b=qxBD/fLauNYSlwBCcGvHclQO+5JOvU3oYbxne+OJ2Iv2crnJILMnNH1U55VDZi07s6mmW7
	iCLst0+effdDxlylV9bfbtshsAvCjhjp0goIww2h/ti7uz1is6pbgwaq+fAjJfGSEwryAh
	5PAval13Qo19fQxGtGJ9a/RQAabvfHM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=bsbernd.com header.s=fm1 header.b=JTWFp3nG;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="v QRjGHL";
	spf=pass (imf04.hostedemail.com: domain of bernd@bsbernd.com designates 202.12.124.145 as permitted sender) smtp.mailfrom=bernd@bsbernd.com;
	dmarc=pass (policy=none) header.from=bsbernd.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768076679; a=rsa-sha256;
	cv=none;
	b=hnAwgz0e5LoQqa3GX7I4BmQA1badjrgmBjdeF5zikaa1XtiWu5EtFvQQLPWOxPhVmCO/ky
	PFTf8FipMWr9pd+i7GadiUT5j2+P4jsc4TG0LUu4ufg7pvkLGmJdbLP3j0EDQdDJF+p/Jl
	JgDathYQ3HwA9DY2RyNAd3YAmwYYQIA=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id 898A71D000BD;
	Sat, 10 Jan 2026 15:24:38 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Sat, 10 Jan 2026 15:24:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1768076678;
	 x=1768163078; bh=HIjvHAvQOdvsu9w9pgBxXhvqwLspuvmXIf95Cc7uW8Y=; b=
	JTWFp3nGZWy5GDmFO51fWjhYz6SRh8zM/GfG7HWDJXM0wEnqgaBkcdIIFQWN0LxN
	3jNw1QumloS8v7HZm1FXaWUXlf9GKYxVoKpLnR1NJYj8RhPZicPgUDmd67of5qEq
	l4/mVNbrYsHsnC0slBPC/IDL463lVK1lz6E8K0YbIa7xfbY8ypXTZGzhuassCodY
	hZsVoqu4ahDIF5NZGv+8nBxAqOimv+ozvrsfV4AyOj8kiCnChW5zANTWkKBNqAbM
	gfzLS6/efOyGvMGhM8EezbDq6Z5ZbXHNthXufAEk3ns4taZgHA02sQ6mJLu5ba/p
	utaVTU/yyCLKDaNdPYiNCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1768076678; x=
	1768163078; bh=HIjvHAvQOdvsu9w9pgBxXhvqwLspuvmXIf95Cc7uW8Y=; b=v
	QRjGHLZwRkcaCMToHJ6I2dr39RJct7DqjCsprZ4QEmhQWhdVSpBlyv42DhEanxjt
	jPwp5WqnEUGLJ4pDWPO40v3iMf+uB3O+fKvAgIk/FXr/LVlzcJ0iPWxsSVh5vo4k
	GUkbbIueXjsoMt0zq8gcQfAcPsh8ERg6mGZiQ5pTv0HbwLcrZFl66ePHlzR3l9P5
	TFt3b/RVEHjcbqu40o+3VRffxAUDnMK59RQtsBfKQEJox+OHQShVJKxdR5nRiTWp
	7wv72Hnv2Wi+3ahXIkAdb4Y83s9ableXM4V1O6ZLtAGzJ+PX0pg7gwwVYf9gPM8B
	3pOjVw3xRJW7UV07FN0Kw==
X-ME-Sender: <xms:hbViaTEbYUmjjCWymhchCZgqYvx0JnlOjgq_7k0sZENaBfWYlU_Wzg>
    <xme:hbViaS56pj6R9-4eOU_Jof_E87S8ZMe0EZmp-rbmaKU1tVxQ3h8gk9xKaOzIeXDUl
    JVSomcZFOwhkFoA5vLpMgEzHF6TiwWZ2UyVPK7HINO1cyKGyNg>
X-ME-Received: <xmr:hbViaYwuLUxBo4AvCYL0TGUJkgD4cGtPAkhrjdbkQokTsysr6qBMmf_FgpVjw8VKU4bnMoPiNvqNSOb8pOpGkAk2SxlsPm98qOPhJ1W6U949PG8MQg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduuddvieegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdejnecuhfhrohhmpeeuvghrnhgu
    ucfutghhuhgsvghrthcuoegsvghrnhgusegsshgsvghrnhgurdgtohhmqeenucggtffrrg
    htthgvrhhnpeehhfejueejleehtdehteefvdfgtdelffeuudejhfehgedufedvhfehueev
    udeugeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    gsvghrnhgusegsshgsvghrnhgurdgtohhmpdhnsggprhgtphhtthhopeelpdhmohguvgep
    shhmthhpohhuthdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurdhorhhgpd
    hrtghpthhtohepjhgrtghksehsuhhsvgdrtgiipdhrtghpthhtohepjhhorghnnhgvlhhk
    ohhonhhgsehgmhgrihhlrdgtohhmpdhrtghpthhtohepmhhikhhlohhssehsiigvrhgvug
    hirdhhuhdprhgtphhtthhopehhsghirhhthhgvlhhmvghrseguughnrdgtohhmpdhrtghp
    thhtoheplhhinhhugidqfhhsuggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprh
    gtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghp
    thhtoheplhhinhhugidqmhhmsehkvhgrtghkrdhorhhgpdhrtghpthhtohepuggrvhhiug
    eskhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:hbViaRNPq2Vk62v1j6bXlJKpoGqk-CiiC47EcYcyzT0WJmWMhVJgDA>
    <xmx:hbViaens_xNAqGpELOKVSFY_b2LL95XOv2Sn45w86HqqhONha0OpDQ>
    <xmx:hbViaWTrPvkN0e7Lj6MFrgZE_MT8P0g0JxwSzKASaIdXn33bowWGCA>
    <xmx:hbViadUNfSjQUYtw__vwRCj0yfTBBSgAGrjotByGUr9wodAmBiEUQQ>
    <xmx:hrViaZ3AzD9P9cEwQOl2g23Ar1HZWqdIBycHay5HHU5Mwct-hUzJ_gIq>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 10 Jan 2026 15:24:36 -0500 (EST)
Message-ID: <60036371-1321-4e3c-a870-5b51f3d867d9@bsbernd.com>
Date: Sat, 10 Jan 2026 21:24:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: __folio_end_writeback() lockdep issue
To: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>
Cc: Joanne Koong <joannelkoong@gmail.com>, Miklos Szeredi
 <miklos@szeredi.hu>, Horst Birthelmer <hbirthelmer@ddn.com>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>
References: <9b845a47-9aee-43dd-99bc-1a82bea00442@bsbernd.com>
 <b7b72183-f9e1-4e58-b40f-45a267cc6831@bsbernd.com>
 <aWJ-pHIY8Y8sjLeC@casper.infradead.org>
From: Bernd Schubert <bernd@bsbernd.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <aWJ-pHIY8Y8sjLeC@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9A69640013
X-Stat-Signature: g1e83qndfjrwr46w5j78ya81uemmkqzg
X-HE-Tag: 1768076679-337684
X-HE-Meta: U2FsdGVkX19UFtr9dmPbCR11+6bwh+0eU5UWG50uSyw14UaypdwzornsrNtvsWNRxd4pRsn7iz9+k5LSTGmf/hwUXmfIc4LzINVuEsvp/kl+Kixeuzm+igK/xHJuTqKVZKJutfylEE1KWZEcx6TxDkhsbF56MTt8HuXjpEug4Q51zLFAYQuEBmcbUZg8uU7n6+3vDgL68nPqZkfx7Ny4/ydE0Ep9F6yC9KP3yb1RHy3GCGbqazr/tJWYkbc8JcsD8OsUgGoPxtvLLyZKxnTuPRmL6/EP0OTk/88h3J2IZgp1aZs2foYN3FpXI4CJoZgJ8RtkAsVwy0ptepYJOWGbembYxm/G1/rMkTOQp0RNKSs4LQagSOr7JXRdOJjBGdrNJUGX4PbTyO9DhohbZm3lJHzqTuReKPbUzskcKzMJmQqGk+9LIJrnva8ASn1p/GNG67aRkV5sprfVlJq3x4D3yuJuAoilpJUHAw+mqrH2OZPpMeepM7xUNZ35ld7XMLbhXmeYtEBf0ARNXL52qbne/YZ55ffwTs6jzdEVePKPJT0+Ky2T/pPfZ0XxgPjXsy14LbCAGfbb24UP/XPaU68H/tpCsXQ72B+pkuuciTpBDeK5LAHxJNvEWK4DUzxYiTDGfZOSG/komAShaRHxthkei8ld5pEfx3OSQPaMPiEM5+dSfh3E+3n2lJiHVsw2U2i7Vo+h+eiJqQ6C4fQjn2zI/vOsbaVeV5kXMPpTwHyKj86+13kdY8StOh7c3jI0SAMjwa1s+wN0Hb7FDQLEUYyh2odkmKi7eUfr3lCKWvHR+OZaFftoMbqalb4cYEisft005E0LvjW20555mLxtW9ueYMnMEOAuwlwIlqaVtU6D68HYbSMyD8S+m2qQG8bz4iH8H0x6k2E+YxIuLpLhYIKTfl1DrLuti0yeS0HwcnpNCx0QjXCjwUthP51qfeEKlGcO6Q1TojofeCu4o4rmQot
 fESdFuvb
 mvyh9E/k3zDCXBg4hsstmkBHyTwjeMaWS2/MDf9TVH114HJAZxgdXAVeYfsF8EiVVYH5n9rzlDwkKFpfU/ObE1PJcIibQWbQqnYiyU4mmtHCum8CWn/6cGryU0JdGF6xdqm0rw+ZiTddXr7k9QYyVV7Z7pb6sFHEboSago0aT+ph1zzppdRZUqttvBI+oYd5bWiZAFTBb3fMosNJQkzGs4trDKBopi+9EikOJ7MQrs4VJWb6lt4XbT0zqMwKf++ws27Y9BMYiPfsZOJIND9k/tha1s2w4/qU9OvW+Fy3IMON/tXyWeGmU8X69L6n5572MXh/kWa4x94JgnNOo2NrEofkKPfTkbSDoZF9L118a/prk5dA3hcVYYSUtktpZcFV4OwBpjjWnpZ1joy21NhXelDtrMRzI6h5jRpnToIbvBGIqL1QGTLvMo+Z0o5NJtgwi9kMl/+/ULuQzETk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/10/26 17:30, Matthew Wilcox wrote:
> On Sat, Jan 10, 2026 at 04:31:28PM +0100, Bernd Schubert wrote:
>> [  872.499480]  Possible interrupt unsafe locking scenario:
>> [  872.499480] 
>> [  872.500326]        CPU0                    CPU1
>> [  872.500906]        ----                    ----
>> [  872.501464]   lock(&p->sequence);
>> [  872.501923]                                local_irq_disable();
>> [  872.502615]                                lock(&xa->xa_lock#4);
>> [  872.503327]                                lock(&p->sequence);
>> [  872.504116]   <Interrupt>
>> [  872.504513]     lock(&xa->xa_lock#4);
>>
>>
>> Which is introduced by commit 2841808f35ee for all file systems. 
>> The should be rather generic - I shouldn't be the only one seeing
>> it?
> 
> Oh wow, 2841808f35ee has a very confusing commit message.  It implies
> that _no_ filesystem uses BDI_CAP_WRITEBACK_ACCT, but what it really
> means is that no filesystem now _clears_ BDI_CAP_WRITEBACK_ACCT, so
> all filesystems do use this code path and therefore the flag can be
> removed.  And that matches the code change.

Ah right, I had mixed it up, fuse was actually clearing
BDI_CAP_WRITEBACK_ACCT in the past.

> 
> So you should be able to reproduce this problem with commit 494d2f508883
> as well?

Yep, reproducible.

> 
> That tells me that this is something fuse-specific.  Other filesystems
> aren't seeing this.  Wonder why ...
> 
> __wb_writeout_add() or its predecessor __wb_writeout_inc() have been in
> that spot since 2015 or earlier.  
> 
> The sequence lock itself is taken inside fprop_new_period() called from
> writeout_period() which has been there since 2012, so that's not it.
> 
> Looking at fprop_new_period() is more interesting.  Commit a91befde3503
> removed an earlier call to local_irq_save().  It was then replaced with
> preempt_disable() in 9458e0a78c45 but maybe removing it was just
> erroneous?
> 
> Anyway, that was 2022, so it doesn't answer "why is this only showing up
> now and only for fuse?"  But maybe replacing the preempt-disable with
> irq-disable in fprop_new_period() is the right solution, regardless.

With fuse tmp pages mapping was NULL in past? I.e. I *guess* the trigger
is 0c58a97f919c ("fuse: remove tmp folio for writebacks and internal rb
tree"), although I'm confused why I didn't run into this earlier.


Bernd


