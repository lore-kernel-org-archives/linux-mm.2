Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56A81C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 09:10:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41E466B00AB; Wed, 12 Aug 2026 05:10:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A7896B00B9; Wed, 12 Aug 2026 05:10:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 297046B00BA; Wed, 12 Aug 2026 05:10:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 043A36B00AB
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 05:10:00 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 126DEA0196
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:09:59 +0000 (UTC)
X-FDA: 85092045318.05.F98E20E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 44DB5C0004
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:09:57 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=jxqYMvlB;
	spf=pass (imf22.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786525797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y/GN4QuJypCeC9+HHxdjIeyzkZpsEGzvfwU/qohNVHE=;
	b=H8vB1Ew0sUf0SvSz9vQaZwgO/mFW164j8n37iQqK5+q0SSPRLXp08qm2VO6hOw5PTsOqU8
	j3lGBccBYhAseq3DOXuuO156CYfVyu+iRsEAlpdYA/XNXra2EwWPExUxlvb1MLYxvtiVmb
	/WN1DTMjqq4bPEa4duiCakOxTmEzL1o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786525797;
	b=xrg4E6Fa/qBTVOiwIsldYGGb0lZfphCa6qkpI7K4V/5kjhjFrEwbqxMJRPAm+bMN1IAiG5
	Si927Ztk0nz7TICVV3m3LD7mJALNXir5T69H4HLUXc46tQew0xh8iZmzcodrh0XGdLkC1l
	nu8UD50ebkzE6FH0qdzstPcrwH5bVOE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=jxqYMvlB;
	spf=pass (imf22.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 584BC1596;
	Wed, 12 Aug 2026 02:09:52 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 24BBF3F673;
	Wed, 12 Aug 2026 02:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786525796; bh=LX8Nh4wdVXX5g3het+SjjqM7M/nDJ5ubrty1R5Hixk4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jxqYMvlBkL3ncKNzC5/Wt3s+N1Vc7pWerEEOg8PZJaipFROgrZRoMpbWvDpofPFLR
	 s0vjhD4OwtyjE/rLqRP4hXsO8POma4XhGEff6gnzOby5sUW28kyUEgw/5h0WazM7Vw
	 bJLPpIq8eAfXlMyZoOK1JErGVSa4CgFUY/ujiZ2w=
Date: Wed, 12 Aug 2026 10:09:51 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	workflows@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 3/4] mm: kmemleak: factor leak confirmation into a helper
Message-ID: <anw4X4mkepgo2-p3@arm.com>
References: <20260713-catalin_pto-v1-0-5b93b1131089@debian.org>
 <20260713-catalin_pto-v1-3-5b93b1131089@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713-catalin_pto-v1-3-5b93b1131089@debian.org>
X-Rspam-User: 
X-Stat-Signature: 3nostp73skyiy8xxdne1prhwe7icqu9m
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 44DB5C0004
X-HE-Tag: 1786525797-115560
X-HE-Meta: U2FsdGVkX1/qi2FUoJ3kTWHfw1kye7tTy5TQt0O/qDoA9z/s4432JKGZu8B4bCGf7ONwCwJu2LPUrKzzici+2XwxSMGk0roe336WELdUY0yG6vsPsQaYZNgFRGgmJcetEGFWZSFeDbFxFHI7NSREhrbNKl29wVmAIxMuSD4iWRki/XepVilsHCoZCuISdtGwzdUvYuh9UpxoyN9eFY3Anocs4Jz1knMwDjByYtamgX1GIzvjzcUNXG2x5SHjGu4UiLVsMpkFHR+2mTwzoh2m0Q1/M+N5diCqlS2ylmiwJzUJBvgLVrNpPUuHGZzZjDs/KS7cSFXPf7TNe4BKbIjKEtTDNqS7e5cy2ImYnJKbTlEA+F63Pp65sgoRd6pECZwnbHRgqzdvvIOKXE1RQFBYSj9JI7mawJNWhnC2pgItVTeSU9sFsuLomOL9DIkpahJmU7jxeY5nbJQLsw5ac4HmLBfITjqvGTpZrmbN7Ff+5JtLxH6+GOtpAW2vAD8uF06NBhAZIudsUAsBbLS9yjiiuw2TtUwSYH7EDV1yAdgmAAzGVmWjdILY31z4Ik40UDY3FJRKXJWYRK0p9rCYlFyo7az7HASy2mPkSdAX8toauWAanxsfej49s1mbXzrX5Qv0/w+frvttmxUCLCrfqLSuKCZx95tSZnraYnNP7yBdnnsJh+Zid3gLBODPzRifNpxlUkIpLVVB2h2UznnoxQfgL5KBI2EEXISyd9xNMt2velrNM63RhEvYZiBDg136GK9JiBElqzFa73V3JPLjaGEAYoOC9btaWp+fiasjMV3E7kGsJ1hafrkce5REsd4IBV9Tv4yl2nQJNBA3I5soBrlYI4tf4/SbS0BPTUsY33wmZIhsnidkC7luqYSyZSYIWvcEtEsrDcRIIwgr24rVDE/+6d4IAEIePQ5u2quKqBi1EzhuYQk5ww3qAW5UFC8MtAjfkNGuuJ2dW6INqp65ipi
 Gr8rwUKZ
 C8OjcRpJrFmivjxy2Y1vFc+YuRiGMW4h7Z4eScIRTeH5dD7JiSWY+MD3R3fjrSsNYjklMbmjv0mC0LB/zTQdKHVG5k/2ojIzj0Z7n4j6QpuEUa7VZ8U9XRFg7amebnnPgEF4OazTdYlkVFfoG0o2qixMykWSJ1ZMzFwD8uK7JhyBbm0GSNKRk0NvPd4AOsmpw4P99akBqHWklwlf3Fj3oJw8yUfKwM0f20mKyGUSV0D2xHfJUdk/kRarFjqgxe1UN0U8J5ZuBN1eDRkybvpDxiu5+8um/SaUfLz7VQuXmKBhc8o5hyuIO7nov58C+C0Qk9suw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 04:48:06AM -0700, Breno Leitao wrote:
> The reporting loop in kmemleak_scan() decided whether to tag an object as
> a reported leak with a four-term compound condition whose last operand
> also had a side effect (++object->unref_scans). Mixing the candidate
> tests with the counter update made the check hard to read.
> 
> Move the state transition into confirm_leak(): it returns true when a
> still-unreferenced suspect crosses min_unref_scans consecutive scans and
> is newly flagged OBJECT_REPORTED, leaving only the reporting bookkeeping
> in the caller. No functional change.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

