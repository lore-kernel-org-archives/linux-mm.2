Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6330EC5CFCF
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 13:46:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56D836B0284; Wed, 12 Aug 2026 09:46:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 545316B0281; Wed, 12 Aug 2026 09:46:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BE326B0292; Wed, 12 Aug 2026 09:46:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 236616B0281
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:46:26 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A5825160366
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:46:25 +0000 (UTC)
X-FDA: 85092741930.10.59EC88E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1F23A140008
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:46:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TQWM28p4;
	spf=pass (imf09.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786542384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jmvyDkK0SEMV+6hHSi9U54dzAcSRibYyWNZkwQf61Gs=;
	b=CCwvm0ZuoCpdJY+IXcXp9/tsi9T0jw8nPvAQrP5tZR4mHFHY/5X0fj6mWy41xPCINrY/6u
	f8O34cDCmL6O9wGJXWDzKVhk9upAEUxIJClg+tFt7bM0TGc68JrUsOoIeAln9BBc5oVfQn
	iNIxij4zl0hEHauLnsuhhdCLaH0GFV0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786542384;
	b=JuUyKkyJV3oSZWsefQ3UIhFeeouSzladYJIDA6FErLbbHHWeu1d2d12wItc+zZBaKlRFNC
	U80xwuYzWZxoC8cT7ALXlzUgwN7MfgJXX7qhxq6Ad/NO7gQ2r3jMe4I53+joL5GJ1pm1lN
	hx5MofGbKc+wYD9vgp+oEbEbYL9YeB0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TQWM28p4;
	spf=pass (imf09.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BE8FA60A85;
	Wed, 12 Aug 2026 13:46:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBD321F000E9;
	Wed, 12 Aug 2026 13:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786542383;
	bh=jmvyDkK0SEMV+6hHSi9U54dzAcSRibYyWNZkwQf61Gs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=TQWM28p48UmnPpZTJo7OBBfMPXCQoOnJggGChZDveP5NohAsVU4NOdN8vluuJI62P
	 C5VH3XAhyXK9qQxsUmIF1KBtPh6faVdjusm0tirQscBfl0s+Pt26UgSqeySQ2b8S+V
	 MHTHaCFcsmmq1ysujL71P+gSIK5GJ9R6JMyUhoC1b6dW6lOH7VebDXE4ROaHPxIfkL
	 tHAp4JrfgRzx/OvY9v3ExhWN4Z3OwqKh0H6EQ24OhO/8ippvHUPE2rqwwBxczUSMGt
	 f98RZBZVY5ei1fo1Usxgq5O3GjAxiHAIqyK1uvyHVa2kbxC2Wrwir0CjTCmTbZPzf0
	 eNvdIGAjTpDEQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pranjal Shrivastava <praan@google.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Mike Rapoport <rppt@kernel.org>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,  Alexander Graf
 <graf@amazon.com>,  Samiullah Khawaja <skhawaja@google.com>,  David
 Matlack <dmatlack@google.com>,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/2] kho: support preserving high-order non-compound
 pages
In-Reply-To: <anxrvA3z3NUkWvnE@google.com> (Pranjal Shrivastava's message of
	"Wed, 12 Aug 2026 12:49:00 +0000")
References: <20260803113944.3694290-1-praan@google.com>
	<anr4-F-e5_vHEar8@kernel.org> <2vxzv79f39za.fsf@kernel.org>
	<anxrvA3z3NUkWvnE@google.com>
Date: Wed, 12 Aug 2026 15:46:20 +0200
Message-ID: <2vxzecg33103.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Stat-Signature: 1irjs44nxmmqf7u7zba7jyggxoxmxop8
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1F23A140008
X-HE-Tag: 1786542383-261014
X-HE-Meta: U2FsdGVkX18QaQLuObTDxCmy8nbxr98/1Mf0a6zZwZA/xC48l0nzl8TuKlJR0UGJRcf3ghXoDVw5O6PfGsvf7ezCkb2CnWrs7wnZaG0M5IxBu9tn6Y9QWFx/WAYb8/iieNOJBS1ink3RDkei90yDITwTNpgQoWZn8CdMoy4F98nkcuedW6gn7j+t5ybh8aTyKvH88oBZ0VPqt+rZ34EIeQt3F6lnoz9pwPJgSfp/B24J6fgtCGllWG9cD7nVh7dU1DVlL1cz2CLBM6pDhOsw3ylKDQMyqOWqgwV0nz57O3SfRKRpY3zaWEqQckWss48k48WWZack3702fJAwYaGjc87jMCZs/XJSrx3Vkr+b+khprsIPWbtcZxS25BQcruXx/rHEOsWXUoTySAWLL4bD+fTIPqozCmALEl6FGwvKYnIPjrZkSPjYs4nKyKw5TvzzeahJH7p80UFXyj7mB8wr4fy/1cyhcUutbV9WG+IHZfZJlbymv77OHHtIBUNodku/sbPS9XjsWfpa4sN8PdDzbb5lqs7fX+aRzFqqVMNM/l5w4BcPuH4F8A42mtE/Iix4pKMBnrKPHLukyhUm0GfTHOWD4c+2abowWK4D5Kfq2a4nylZTSOW7wKog0M0i0SC+72+mWs95nPBR/nasbRV+8LkOdP6JHWRcAw+TxnHIsq5ZITWMacadbVijuF3nZQmhkUqY3HyGJqBkP8KHq4Gjq3kvhfV2X9g7073GRWgxpRN53FZry6d+mBiV8MP1hRTy+BlBv2ElfB3+Nu9ZbE+iAg5og9820yGx2vMFDsyt1imwa01eD+xkKgvQLJ/f1it9ZuTlSJdlihC0P1Zvz3LWuKx/+1Wdf+pwGenVMH7v3eC0CCa2vl55faEV2T6mrY6mPDtb/YMtShglGk0tvmi3+ngVfrXvBhex3ROPci9KOA+R3Z4pd8nKk8LP3ko8xSLXSy2ROWFRZRaAOQ+To/l
 FKfyllPz
 +x06cbAH9UOFCBC6yZcZNPVu3QR5CIxQ2413VV6odyBF8o3Os4qz/rX5eIeawVO89Z0jJgiWdDK6M8G7zY4reAGNqmBnMDoBlcaU0qJmREiXrJWgtj7UFBbhd8tq1TkyCcKhDDyC8u1CehK9OBg8RIM0XB0G2qKYIaq8orwnBB4CYpO21rnnlg09SYM614BKlnaBRbzicy14au3s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12 2026, Pranjal Shrivastava wrote:

> On Wed, Aug 12, 2026 at 12:32:25PM +0200, Pratyush Yadav wrote:
>> On Tue, Aug 11 2026, Mike Rapoport wrote:
>> 
>> > Hi Pranjal,
>> >
>> > On Mon, Aug 03, 2026 at 11:39:41AM +0000, Pranjal Shrivastava wrote:
>> >> Introduction
>> >> ============
>> >> This series is required for the ongoing effort to preserve DMA allocations
>> >> across KHO [1]. It addresses a fundamental mismatch between the current KHO
>> >> restoration logic and the physical reality of high-order buddy allocations.
>> >
>> > I skimmed through the patches, they look fine to me before the in-depth
>> > review :)
>> >
>> > But we are really close to the merge window, so we'll anyway need to
>> > reiterate after v7.3-rc1.
>> >  
>> >> The Problem
>> >> ===========
>> >> The current KHO restore implementation treats all multi-page blocks as
>> >> split pages during restoration. Specifically, kho_restore_pages()
>> >> initializes every 4KB sub-page with a refcount of 1.
>> >> 
>> >> However, many kernel subsystems, most notably the DMA allocator (via
>> >> dma_alloc_coherent), frequently return high-order non-compound pages.
>> >> In this state, only the head page carries a refcount of 1, while
>> >> all tail pages have a refcount of 0.
>> >
>> > This hints that these patches could be a part of the DMA preservation
>> > series, unless you expect other users of the new API.
>> >
>> > Generally, we don't merge new APIs without the users and if DMA
>> > preservation is the only user, it's better to fold these two patches there.
>> 
>> Makes sense I think. We can review the patches here, but then they can
>> go in with the DMA series.
>> 
>
> So.. IIUC, I'll post a v5 here as a standalone series till we get
> consensus, and finally the reviewed patches can be folded with the DMA
> series?

That sounds good to me at least.

-- 
Regards,
Pratyush Yadav

