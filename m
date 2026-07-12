Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE375C43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 08:27:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6DE76B0088; Sun, 12 Jul 2026 04:27:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1DC56B0092; Sun, 12 Jul 2026 04:27:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0D6E6B0093; Sun, 12 Jul 2026 04:27:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AF8746B0088
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 04:27:39 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 37832A0790
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 08:27:39 +0000 (UTC)
X-FDA: 84979445838.07.9446672
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id A051E100002
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 08:27:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YpiLFbDb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783844857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=enyWtChxLifT9CO1+iCJe3PI3c5SIL5ZQ7wN+THBh48=;
	b=KbzAv0A976cMLJmd8igo6DIYNEsiF79sw4fjdKrvpDKkQ4/ejXeKJvfEUyoarPj9q8sSIz
	QC5qgbz/PulASEmzo1IY4al4zvywpQVKrJwfr/69RLomGhg/vQESMP5K/YmlSy1YenMOYY
	1KvoC7a0rfc3NEpRnXD3lZwQDs/Q8MU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YpiLFbDb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783844857;
	b=MwfD3dbJL28jjJjT/mm25/XcXFxtlNrmmVuWh7aSscA0ivqpV6M6aW8g08+8qKl4awiUOe
	hgi9Zx8lxyAGxDSqkPZyiEjLDomdcXbB/vcqhtQLUQFHfIbfdkxZkfND8npSbG4qmlDGQf
	nVebeMJo4Eda8iohDpv4Tv8yF6durcU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 01311600AE;
	Sun, 12 Jul 2026 08:27:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 844B11F000E9;
	Sun, 12 Jul 2026 08:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783844856;
	bh=enyWtChxLifT9CO1+iCJe3PI3c5SIL5ZQ7wN+THBh48=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YpiLFbDbz0bHYo0Nbd3BrGFfnFO4xG8aecNSUO1DIa7bjBaf9hmAzUdvqCQnhexG9
	 hlMpdqz3ofJIC6nqqLWRG42hdIckXAL6I+GZJugsXIUWQhGQrLv2mfppOLribndjsG
	 YNg1PwAhBhq/YeeqUPBH2Ec6tZ65DKH3rsGbm9ijvbRCx4ZcgS4z0m2VLkbFHp/mmk
	 X8cVMfVHIeYXPWXxec354SXLL38/PhHyemE6WcxuRJqQUiOtNqOn2H/4a0suxjgchm
	 bXIEEvgR3eZYM3MtRI3CVCktl8o/JtKc1TG5VezFBpdIsVhGF4V0P3JC6BbVg1q0Mf
	 2VAy7TNmEoKUA==
Date: Sun, 12 Jul 2026 09:27:22 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Toshi Kani <toshi.kani@hpe.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	David Carlier <devnexen@gmail.com>, Dev Jain <dev.jain@arm.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] Revert "arm64: Enable vmalloc-huge with ptdump"
Message-ID: <alNPeT-TUEx1IrwE@lucifer>
References: <20260710-series-vmap-race-fix-v1-0-5b3794c113fe@kernel.org>
 <20260710-series-vmap-race-fix-v1-2-5b3794c113fe@kernel.org>
 <alIX0XoykjTz69sk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alIX0XoykjTz69sk@kernel.org>
X-Stat-Signature: 4ie3qfh95kaqn8qatzaa6tw7rqjzjrao
X-Rspamd-Queue-Id: A051E100002
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783844857-748304
X-HE-Meta: U2FsdGVkX1/GhrLqdFZ9WZPa2zh928DHE6vGC/SavG7qR1VeFFnxmHPfDXee2LDKknX15gnbmgwH4ruEmA43R8AH+AfinTIFJUbRtbLfAdC8Np8XlBgaQvB10iCHVfaAYipAf0w2w4auTumO+PEZT8KluMSdaYpGSSHxO6QoV5Pcgv+ZBL93149k2Bs+usYGzgJigCEL9+YspjOjghP503WBfHzklnedR8+jO+PKn9lftJ1L1JZ+qeQfIEtz8O3gBbZtVWyNu/4PjyVZH+EJUVtt9S7Tfpbm3Ati1BRdgu0l+7x6JurxmszYe9OCdaF3UqoLcS1xO/8O6B4gAbr8tLOTRI5D5M0OYqGc2teS9k71mJ3Cxy4TrZpO/Q8yWagAOLkXfqDqOK6FuJDXew1wXsgCOEGSujeB20bCFvzgWx35kb7l5bZ4n7toA9KGzuKUH9hjXWjA7vM4raML9Lhxv6dO+rO8xSyeKtV4Zv/sq+jUsvy+tJiS31nBfwQFnOegP1tpfNDerdBMTtSbEssZZ9yeowGdytpF/fK9S1JWF9xpKng/RYkHS3m5SApqkTYpUaUfanlQV1HJ5SA3rRY3sBGzqtRr7p8s7645EmVBBahN6w5VBtfk59ApzeIFfAfByBjhDkQmkMXs66bzNcJk34kf0Fyfwpx/V64ikB1SETPi7h1iybbFzQFBRzuiF5uIiRaqco4ZGT2tcOenqRN3+SGcFvHBrx0onDIzVeVoXDryfNs9cO9QJ0p5g/oKMsX1nqWS+dVM2FPTHmTD4VNSaBQ9vo9HxhijLnBVM65k2CubYWB0F+sSpFXodEUA/moPVIgbU70jJvvtrJ4m56quYURVVglHDAX9j7Ca0uTIalFuZ3WERSfCFAKw4WdjqSpwT9U9DcZddOxMoitm14POFawT6FQXcsju8hTzWbQhFTCJ3xWsxUIjj+WF+RQxP/OtaRWv0EwFDebaMGxHf39
 uUdKFjH+
 Q5njKXQN1gPXPqxGbn4Fxpy27QNYJ0xe2HRu2G/QbO8zTbsx1eZs/+fVlNKyTsp50D4yuqF8Ohb2oZHP6Bjj5c0MuJ30JwOzmpquA38EgDuPBIv613Lb+TT1TB4Z4DglgGmw7o4PKdbSwZVo8vTLZ+fP/Sa2DRtxxctEYZxoQSjOVrhV3GN0xTFXLV5OeCcT1sFO5rE4AXu3y7SGtrPEs93z3xIrDkUGmAFUo6Y8AvUjgYkzfu3DQ4k4AqbwBfVHcjeo0W8GBedv554Im5iZ+3Nhonw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 11, 2026 at 01:15:45PM +0300, Mike Rapoport wrote:
> On Fri, Jul 10, 2026 at 11:49:19AM +0100, Lorenzo Stoakes wrote:
> > Subject: [PATCH 2/2] Revert "arm64: Enable vmalloc-huge with ptdump"
>
> Without reading the full changelog this sounds like you are disabling
> vmalloc-huge with ptdump ;-)
>
> How about "remove redundant locking guarding ptdump against vmalloc-huge"?

I'm just following the standard convention when it comes to partial reverts, as
I revert the majority of the patch and I ran 'git revert' to do it ;)

But then again I do remove the arm64 ifdeffery in the same commit and
you're right it does suggest I revert more than I do so will fix it up!

>
> > This partially reverts commit fa93b45fd397 ("arm64: Enable vmalloc-huge
> > with ptdump"), retaining vmalloc-huge support but eliminating the now
> > redundant mitigation against a race between huge vmap page table freeing
> > and ptdump, as this issue has now been fixed at core.
> >
> > We also simultaneously remove the arm64 ifdeffery when acquiring the mmap
> > read lock upon vmap huge page table promotion as it is no longer required.
> >
> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>B
>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Thanks!

>
> > ---
> >  arch/arm64/include/asm/ptdump.h |  2 --
> >  arch/arm64/mm/mmu.c             | 43 ++++-------------------------------------
> >  arch/arm64/mm/ptdump.c          | 11 ++---------
> >  mm/vmalloc.c                    | 15 +++-----------
> >  4 files changed, 9 insertions(+), 62 deletions(-)
>
> --
> Sincerely yours,
> Mike.

Thanks, Lorenzo

