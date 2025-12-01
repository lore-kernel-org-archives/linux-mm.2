Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F8B1D116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 13:23:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45D756B000D; Mon,  1 Dec 2025 08:23:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 435046B0088; Mon,  1 Dec 2025 08:23:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34AED6B0089; Mon,  1 Dec 2025 08:23:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1FAA16B000D
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 08:23:18 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 48E16139C6F
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 13:23:15 +0000 (UTC)
X-FDA: 84170968350.03.0BF5CFF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 90F9F1C0016
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 13:23:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cqxUaKnE;
	spf=pass (imf18.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764595393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5S7rehuYscd/hErv8J5+olzkbmCgkfxJ3MreqUx/Zmo=;
	b=mNWBhXBbqIxGvD2AFglDcKEn3eVMR5CO6rr6RkB2tbwQcV0b6PK/U03KrCnbR9RtD6WVha
	GKi4WrnBtHBlpA1gIFZKW26StSBGPd/jTscpD0AEkrhK7n9KnnxeirsJt62TPmI24GVwQx
	30epyj4CU8Tywyzaxz2XizALp1yPdYs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764595393; a=rsa-sha256;
	cv=none;
	b=SORT/9QL9kneNQkSMQbpe6cBPllJ0Zxv8IjCLsN1RsUK5ZFoJ7zm0FcEdLkguRZMXuqRta
	ON9i/iKnvtlpCj/Zfpdo/QxkeaT+W7qTSbyjyL58ppru8/GaRFnJjtYx11RjvHaUa02oR9
	SEfrE95D9PZTYsTx2dLX+DV22u3ll5k=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cqxUaKnE;
	spf=pass (imf18.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E9B296001D;
	Mon,  1 Dec 2025 13:23:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37675C4CEF1;
	Mon,  1 Dec 2025 13:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764595392;
	bh=/5hgmbNcBuxVVJJcYDy7YeTK1UEsFT0pKtlTdyuekFg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=cqxUaKnE+6gErEu/ml7xQrLCDayT1lGoVeW+FyRqEBgt4BU85HzSBSkUzkCD/+jEF
	 ho5xpl3kOJ958YyyK/XrrbdbajYrOBAqLuR7wft337hLePDckCAlatmd6MOQ4r9Am/
	 XJ7sxb1WcR5HGlxtU7X9u0xuB7gmYo1Ivb+qmndiJgIJws3GobRae5/vxPXLRS0faf
	 MWVSL0+2tP06OZYoPc9xN2Jk5Ubw5jfd0ACuqDgSxcMyM1BZAOsYziU8FSTr/liGU4
	 wtdMN+XanBsT4Fg/MwzvHjsE+46k2nOOa4hrgRxW8dcNxi6Iqw1+E0C4odvn6t+ofA
	 aq3YfXg/D7NbQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Alexander Graf <graf@amazon.com>,  Pasha
 Tatashin <pasha.tatashin@soleen.com>,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kho: fix restoring of contiguous ranges of order-0
 pages
In-Reply-To: <aS07racwRsh4ep_L@kernel.org> (Mike Rapoport's message of "Mon, 1
	Dec 2025 08:54:37 +0200")
References: <20251125110917.843744-1-rppt@kernel.org>
	<20251125110917.843744-3-rppt@kernel.org> <mafs0pl96w7hk.fsf@kernel.org>
	<aS07racwRsh4ep_L@kernel.org>
Date: Mon, 01 Dec 2025 14:23:07 +0100
Message-ID: <86ms42mj44.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 90F9F1C0016
X-Stat-Signature: y86c5aeawwsdc5kg5htp3y7dt3hn6nxj
X-HE-Tag: 1764595393-804122
X-HE-Meta: U2FsdGVkX19n3rEYm9Qawy1wSj9EiwcL7C9aCzxFN7DKyLT5X3IRBV1InILaIJJcCtlXcrFhUfci1WUHz75aTfo7xUJA4jc1LARtMmsq4fLSZN4gILYsMSbTY94EKt/R5ZXvMKPJLwaNKEP45tLG8BLc4SDWHjwaqJ0m5K8aiOxreDKgrtchDn+bqBIEpEFpLPEkKLhw6+GJZVoJU5dc3FtkpGZi/8nIoCeQBxQfb1sjURlBdyX67vVyGE2YPq97bbCwdmz5IbDJ5kE72xbRbPwTuDHfHl0iVDX8nBkZq75OOEcnS1FsVFNGobnhSwMn1tUkHJEZAkwmA2ggVRrBsqUGccs6K4oa4MfiL/rPMzwU6xZEP636GbJfDPKgc388FZHxJFMHFCwgyky+CBIeqnjomjJiEa2bkwY03WbuklKZloF9FoZdqnK1sHg7YpdHNTxl2PZZEexhn49n0FzY62FmipP55xEIIq6yVZfVZbPfFP4i4RovpTzrX3LYotNZJT89usR5Ymlmf0W/dooHTlLzJjZ0UtCjqk8Di3kHKHnU3tZwEAyFf04fBwVfcckGIkNkdYDevZraOZpeZl7k5ty3BcJlMU7wFoWCDl3v2NRr3zkBFIl7itANjsXHotS9Z5JNj14fzoZohl0+xVpCnlzXvHmo0mAiYpz+Lqi8AJgG+m4N+wCy7T+M8AABKpkq4Ei+YXFPRWy4T3yj2+whfbXrQnR933TyO0Se1YLnTb52tyd0DLcOzJpd9NwBjDjxKJOvLEUwiJaO07hWSFrn79IzbLPK1WUikCzM8zceZka7LgHggGBHNCkm6pNKm6Ef/IaJ22dCfyGsYYn/djtjujDNLjsqXs8As+fw/zA33CCuO2mtpj8ge97YiFSrogIhyv4YETI7/0NmKMGr5LXF8KvpmDP687QWARRFh74si5xOaTG6hx5K0usuBEIo8IO+6oXp4AruMTTZALgZeLm
 s2hOOV2+
 au+iW+rVA8YPhNFb4o0YkBJDVsKWEwAc0SaP3FSLUce+wWt8KEyf16wa15uhF248LKzBK1m7x5Aw12Q9isf6EKl0Otqi/xWLFYnYlHfxczjI0oDstVXzvwl4zKaX4P4gnJ6xmSR6C7Crhcetn6LMQeaORIvmg7JiTqDO4tR0aRc8TQ9k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 01 2025, Mike Rapoport wrote:

> Hi Pratyush,
>
> On Tue, Nov 25, 2025 at 02:45:59PM +0100, Pratyush Yadav wrote:
>> On Tue, Nov 25 2025, Mike Rapoport wrote:
>
> ...
>
>> > @@ -243,11 +243,16 @@ static struct page *kho_restore_page(phys_addr_t phys)
>> >  	/* Head page gets refcount of 1. */
>> >  	set_page_count(page, 1);
>> >  
>> > -	/* For higher order folios, tail pages get a page count of zero. */
>> > +	/*
>> > +	 * For higher order folios, tail pages get a page count of zero.
>> > +	 * For physically contiguous order-0 pages every pages gets a page
>> > +	 * count of 1
>> > +	 */
>> > +	ref_cnt = is_folio ? 0 : 1;
>> >  	for (unsigned int i = 1; i < nr_pages; i++)
>> > -		set_page_count(page + i, 0);
>> > +		set_page_count(page + i, ref_cnt);
>> >  
>> > -	if (info.order > 0)
>> > +	if (is_folio && info.order)
>> 
>> This is getting a bit difficult to parse. Let's separate out folio and
>> page initialization to separate helpers:
>  
> Sorry, I've missed this earlier and now the patches are in akpm's -stable
> branch.
> Let's postpone these changes for the next cycle, maybe along with support
> for deferred initialization of struct page.

Sure, no problem.

[...]

-- 
Regards,
Pratyush Yadav

