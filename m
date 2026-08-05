Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4FDBC55ABA
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 14:53:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC5136B009F; Wed,  5 Aug 2026 10:53:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C75516B00A0; Wed,  5 Aug 2026 10:53:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B63CE6B00A1; Wed,  5 Aug 2026 10:53:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8D50B6B009F
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 10:53:36 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0A73780495
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 14:53:36 +0000 (UTC)
X-FDA: 85067509632.30.7FCB164
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 249E440003
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 14:53:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=XgANokC1;
	spf=pass (imf01.hostedemail.com: domain of mark.rutland@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=mark.rutland@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785941614;
	b=EfB4SXCzXQeRs7jAIUIrcshBBfVvCQtzp9BJu5mtJpJv4Zg5bNhsPca9oPQBPtdrPKW69V
	7H9Dws45iE/ixztYp+sjOrJS0tpScehxMer3FyZZNiyVaNMkQLKfSJ0I+dL6V4tWu2O8ir
	gwdM+/8LQ0Ymp/drMSsrJuByKsxyydg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=XgANokC1;
	spf=pass (imf01.hostedemail.com: domain of mark.rutland@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=mark.rutland@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785941614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kov5DddpRaSHaT5QtIBhO+yv3izobi8lORUTe2us6Es=;
	b=WiL6LcOOi0i/ifaNmdlmcPWgDueg8U07o0DJMiaMYuZRKZQ5pAZE/5oU7IG4s9zOo7VXJa
	glULwfMjsARXGvjnneJEGkd6Pk6npMGvD54fgq4Hdpagb1zqEIH8a599gKWpDs6CtMdLs8
	4kNPP/kWN2UAyZi0GSTj5DSSXUsj6Ro=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D705F153B;
	Wed,  5 Aug 2026 07:53:28 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8A06C3F632;
	Wed,  5 Aug 2026 07:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785941612; bh=K0NMuw1cdB8mhCo22y55f2vhoceFHsGS1XGjNj01RFk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XgANokC1wy/pXB+aYJ4f7KYRB1lAKM4KkLXZvORJwCDGWcBvspQ5D2OkQ0mEdzGOw
	 IfCn2OXVY2KnBju9YVSjsvw24cmBPBpNC0hQn/mS+3lJWMJys3O8g7ZXwNRoex59zK
	 a9PT5dHCKKnOQwWU2QAJ6XszSUhjjlD/4dkCiI3A=
Date: Wed, 5 Aug 2026 15:53:28 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: Yang Shi <yang@os.amperecomputing.com>,
	Ryan Roberts <ryan.roberts@arm.com>, dennis@kernel.org,
	tj@kernel.org, urezki@gmail.com, catalin.marinas@arm.com,
	will@kernel.org, david@kernel.org, akpm@linux-foundation.org,
	hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
	linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC v2 PATCH 0/16] Optimize this_cpu_*() ops for non-x86 (ARM64
 for this series)
Message-ID: <anNMvTAvUJkfspSR@J2N7QTR9R3>
References: <20260715180455.515692-1-yang@os.amperecomputing.com>
 <0344c559-1959-4531-9265-d5a5180eb7cd@arm.com>
 <fc21c840-1584-4844-963f-80cea7f2e674@os.amperecomputing.com>
 <amCPBrdltFSE_fEf@J2N7QTR9R3>
 <25d1e09b-53e4-7cd5-87db-b58437e4e690@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25d1e09b-53e4-7cd5-87db-b58437e4e690@gentwo.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 249E440003
X-Stat-Signature: bdua78ih3fyeiouadbb4ebpg17cfygb8
X-Rspam-User: 
X-HE-Tag: 1785941614-324180
X-HE-Meta: U2FsdGVkX1/LtoYWxJny/Uta9+PEJkWNQwQ4RhkLMg5y8uRxYnzwObFh3xTeSlhwqoBF6zOMcDGN+3+Rri3NzV2crSzDigERgtUj9sSaeALXMwm9buobsTBnDA6GqOsBWVXG3L9MbznTLO8f98/+tfCa9o7bVFOlHsWloKkkt0YlPzco2Zlpcnzw3yClwve6j2Xe3xB8ZB6ImO5M5q0wMrFM0pc/bHnx7fhaSCL+Z2l1nED0qOPnRbOOONlx2XOXMW9UJvZ1+OsmnJqSGJuvnxf530wKtgCIq5RCNYYRmEJqyH5yo6cK3ifNwjHB3paOIwiH1THCRlukcy6gimsb63ipPt/QrmMPEiFS33TFUEQfKt9MzsZQaPU/T4NOV/WsB5mliGhFFsVUrmIHxPLVeysGpQ67sp+yUMhigvsSokBy9N9Aag6UE/Ucr5q7lbU9EVlpYSD3vIWQWAOHbDwRr/2xIhtyfB4fr//wuulk1v0viBjX8Lco6g2fABKdBGsbfZiFf8H/eOE2WX+GLzlimfcs7jF1b96Nlbn6ZlnxbL3fINcfVG0nUZhvpQQvyINFVuE4EK26b4VEji/5uyGd+g5qmYJ1uEghfsG6k9WnWyaUIRIxw2dDUt9wMzmP8JZuprfuDEdu9xgXz+tZ2Fklt0cvvcIk9ELiegJLcAPbKt905kfuBw85Q6riOqavWN7F9NdlelR5men7cPPdb/WbKAJJOmVXlGuE5xe85DsygTN9BHl1sqmTkEAGm7Ri/LXPOkVgAHgSQVc860u4lyN2I2R/rcm0F8C0FixIJN+MxYbADDNsOBiGQnHpbqF6Q4tl7oqOueDfZIgtrtVfk/PFkytxHZHp7W2PWK4k1d/VDmKni71oJY0d6fdWO+Levy76IgOz4MUFVvN0OLWS02oHWIaRpotvZp+4ali1E7NcmnHo088MwyIDEhSwI9Q79AECD0l5R1h7tA9DGgL+8ZG
 vnbealG8
 5K4n6jD3obVfpKzglDL2kf0+LP+vgGqyMtFN4QMRuGzyYxOlkAdNSB0Zg+b/gEZHQry1ajUKg3xPDo9Ol/udJDJtvXhsnlwhLDD/TkkVZV2JUUOqcgVQGlcy8gO0t+5Gg+DC/qK0Lbcd4gwaJsL7DkvN4icj8Ea3yzH9sAgjmNBDx6ve6xfKBj7gNQ+AuUKw/wTeOUrEAvh/qsJHukbMpV9hggC003ydza3Rtzu1ie/CFAWvHIpsbBnc6IBieEif+tZLtmHYjo88XKgC34Vs0dWUEeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 03:06:27PM -0700, Christoph Lameter (Ampere) wrote:
> On Wed, 22 Jul 2026, Mark Rutland wrote:
> > I expect that should come with a reasonable benefit, but I don't have
> > benchmark figures yet as I haven't finished converting the xchg and
> > cmpxchg implementations.
> >
> > > It sounds like it just moved the cost from one place to the other
> > > place and it also seems hacky TBH.
> 
> Yang Shi's patch has *no* critical section. There is no additional code
> for the RMV instruction. The RMV instruction is executed on the correct
> per cpu area.

None of that was in question.

> One of the reasons for the performance win is the
> eliminattion of these critical sections. Your approach still has some form
> of prologue and posthandling like the current preempt approach and
> therefore will not be able to have the same performance gains.

In absolute terms, yes.

However, I'm fairly confident that the vast majority of the overhead we
have today can be eliminated with simpler alternatives.

There is a trade-off, and there are surprisingly complex interactions
between page tables and other things (e.g. entry code). There is risk
and maintenance burden associated with that. Hence people want to
understand how much of the benefit is attributable to what. So far, the
statements haven't convinced me people actually know what portion of the
overhead come from which factor, e.g.

* How much of that attributable to conditional work when re-enabling
  preemption?

* How much of that is attributable to RMW sequences to modify the
  preempt count itself?
 
* How much of that is attributable to system register accesses (SP_EL0
  and TPIDR_ELx)?

Any of those could easily dominate the other factors and might easily be
avoidable. Most of that should be measurable today. For example you
could restore the preempt_{enable,disable} calls atop Yang Shi's
patches.

> The code is more efficient, there is no restart necessary and the
> technique is already widely used on x86 for a long time.

It's true that the per-cpu page table approach will have fewer
instructions in the fast path.

However, the other statements here are potentially misleading:

(1) There is no restart in the scheme I have proposed, so restarting is
    irrelevant to the comparison.

(2) On x86, this_cpu*() operations use segment relative addressing, NOT
    per-cpu page tables. If arm64 had a similar addressing scheme, I
    expect we would use it.

(3) There are a number of novel problems associated with per-cpu page
    tables (e.g the various unsolved issues Yang has described), which
    do not apply to x86's implementation of this_cpu_*() operations.

> Having the ability in general to map mmemory differently depending on the
> cpu opens up a number of other optimization like

> What we are proposing here is a basic new feature that simplifies code and
> allows addititonal performance and functional features that are so far not
> possible on ARM64.

While this simplifies the this_cpu_*() operations, I don't believe this
is a simplification overall, and IMO, describing it as such is
misleading.

Mark.

