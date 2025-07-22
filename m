Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48613C83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 14:05:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA4778E0005; Tue, 22 Jul 2025 10:05:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7BE58E0001; Tue, 22 Jul 2025 10:05:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB9DB8E0005; Tue, 22 Jul 2025 10:05:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 980FD8E0001
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 10:05:30 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 580B4C03B2
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:05:30 +0000 (UTC)
X-FDA: 83692073220.03.4A7AFAE
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf18.hostedemail.com (Postfix) with ESMTP id E053C1C001B
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:05:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753193128; a=rsa-sha256;
	cv=none;
	b=ijNEkFSIfbg+DlyVym/OhE+rKddkFPvAwPlkbVZZZjne4iDu9bitUDek8r0PW1JaK/+k1A
	hmtfvefQ2q0mukYKoAJ5MFQ5RjiWXyTYmb4sCT4Ey/UMeWeait8Jj8RCG1x+Kn6KuRfFzE
	YJLxTibPPBvBh9zh1VtO1qor2LzXmhM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753193128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PTNe71QcbUOnajsqaB1XNgteDvKoUXAm9oHwoK7vOzI=;
	b=6dvEGidab8oSncS+xBfAF1HkhgALMvJNsnCjxwe1AEEIfCISIF/NZ38XNeK7b/M0f10NzI
	gkgFbuR/YgdViq/7uO+ilmFsE3TOmGfNvqAaUDvrC4WlUp/xF4xecux173pL9h3RmzbSWK
	iIHgpiK4dJGDMpw9ew4yYJgYKiDmrrY=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 22 Jul 2025 23:05:24 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Tue, 22 Jul 2025 23:05:24 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com,
	kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com,
	baohua@kernel.org, chrisl@kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, gunho.lee@lge.com,
	iamjoonsoo.kim@lge.com, taejoon.song@lge.com
Subject: Re: [PATCH 1/4] mm/swap, memcg: Introduce infrastructure for
 cgroup-based swap priority
Message-ID: <aH+apAbBCmkMGPlO@yjaykim-PowerEdge-T330>
References: <20250716202006.3640584-1-youngjun.park@lge.com>
 <20250716202006.3640584-2-youngjun.park@lge.com>
 <jrkh2jy2pkoxgsxgsstpmijyhbzzyige6ubltvmvwl6fwkp3s7@kzc24pj2tcko>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <jrkh2jy2pkoxgsxgsstpmijyhbzzyige6ubltvmvwl6fwkp3s7@kzc24pj2tcko>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E053C1C001B
X-Stat-Signature: 5syd85fq8a9k1mhj7ixsqidws1543y93
X-Rspam-User: 
X-HE-Tag: 1753193127-34654
X-HE-Meta: U2FsdGVkX18U8BsNfEEgRLoiicx1tZpwsDCrvTwQXkNRdryllWDDMtF9aIF7R/+yUNVNfCUFgvfnlQddP8wX2s+MWpJb+jdELFQUdIhsn0qus5qoA67pRag76xNoQDOj9Y+2UrLu0wSHTiEYH7kt+S9bE/Q8Cz0MwR3OnuH07tfn0YfcHKTibWccteFmopJv6vtTCRaOoV1WwUsWhVX5YNIbDKmmMf4/MPWsWriEBOpUvzlFkngYzjwRqu/+7rJ6q0DGJhQJGzxB3xUxqO9ai2sc6bmHVNcAsgWy/oURJbgrTvB045Ig5ThDUtmLmuJu3dMmiliplFfFlo+F4sYmX4eQivL8yUZuDJbWSgIyzvzsCrnZFunGXwI1pithWlPF/ZZGI6XqlmSaKPmiI7Liu9x9dpIhI/FRnx03K/pj6bGQ5aBHuLdNxBmVUEAyvFf8r+F62/prDC2NbU/cdCsns7dCbn4UHfRs5wTyC4vDG2qh8jcFId6o3y8Vt9738o813ykkQ2IP9fVXKIwqOOVyD7WRxO5n1bGixZfoZlLtWNu6QFHpbIgnDy+Bc/ZaFwR69H/eqZKvxDwxUgqErp9oW77bWdtQBRdkwUKNQELXVZSPmx+82DF99HRJzqJ3A151vYXE6h0urwlwlAljST6rgE8m7Z8UG/poP1iwUR2fRShDVxYe95BPWup9nqyaGHg5rBrNBM0ofdxxIKsSgPcYOZZOcDTCoSjspHjfUXKWNlCBq0nLaWdAewBEDFWd4p5kZ3E23ydHjlDInFPv/geP6XyBh+SZ7JhfPn3/+jJ94tLRKfHWhrwjND58KJmmbi3s8iILJaiFwWjrqNqry5Vux+B9JcqwASasmMmPEqwQEszEGAwqqB6V0Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025 at 10:41:20AM +0200, Michal Koutný wrote:
> On Thu, Jul 17, 2025 at 05:20:03AM +0900, Youngjun Park <youngjun.park@lge.com> wrote:
> > +  memory.swap.priority
> > +    A read-write flat-keyed file which exists on non-root cgroups.
> > +    This interface allows you to set per-swap-device priorities for the current
> > +    cgroup and to define how they differ from the global swap system.
> > +
> > +    To assign priorities or define specific behaviors for swap devices
> > +    in the current cgroup, write one or more lines in the following
> > +    formats:
> > +
> > +     - <swap_device_id> <priority>
> > +     - <swap_device_id> disabled
> > +     - <swap_device_id> none
> > +     - default none
> > +     - default disabled
> > +
> > +    Each <swap_device_id> refers to a unique swap device registered
> > +    in the system. You can check the ID, device path, and current
> > +    priority of active swap devices through the `/proc/swaps` file.
> 
> Do you mean row number as the ID? Or does this depend on some other
> patches or API?

You're right to ask for clarification. The `<swap_device_id>` refers
to a unique identifier added to each swap device entry in `/proc/swaps`.
I will revise the documentation to make this clearer.

As a side note, I initially had concerns about breaking the existing ABI.
However, the additional ID column does not significantly change the
current output format and is gated behind `CONFIG_SWAP_CGROUP_PRIORITY`,
so it should be safe and intuitive to expose it through `/proc/swaps

> > +    This provides a clear mapping between swap devices and the IDs
> > +    used in this interface.
> > +
> > +    The 'default' keyword sets the fallback priority behavior rule for
> > +    this cgroup. If no specific entry matches a swap device, this default
> > +    applies.
> > +
> > +    * 'default none': This is the default if no configuration
> > +      is explicitly written. Swap devices follow the system-wide
> > +      swap priorities.
> > +
> > +    * 'default disabled': All swap devices are excluded from this cgroup’s
> > +      swap priority list and will not be used by this cgroup.
> 
> This duplicates memory.swap.max=0. I'm not sure it's thus necessary.
> At the same time you don't accept 'default <priority>' (that's sane).

That's a valid observation. While `memory.swap.max=0` controls the overall
swap usage limit, the `default disabled` entry is intended to disable
specific swap devices within the scope of this cgroup interface. The
motivation was to offer more granular control over device selection
rather than total swap usage.

> > +
> > +    The priority semantics are consistent with the global swap system:
> > +
> > +      - Higher numerical values indicate higher preference.
> > +      - See Documentation/admin-guide/mm/swap_numa.rst for details on
> > +        swap NUMA autobinding and negative priority rules.
> > +
> > +    The handling of negative priorities in this cgroup interface
> > +    has specific behaviors for assignment and restoration:
> > +
> > +    * Negative Priority Assignment
> 
> Even in Documentation/admin-guide/mm/swap_numa.rst it's part of "Implementation details".
> I admit I'm daunted by this paragraphs. Is it important for this interface?

Thank you for pointing this out. My original philosophy was to preserve
as much of the existing swap functionality as possible, including
NUMA-aware behaviors.

However, I agree that the explanation is complex and also not be
necessary for my proposed usage. After some reflection, I believe the
implementation (and documentation) will be clearer and simpler without
supporting negative priorities here. 

Unless further objections arise, I plan to drop this behavior in the next
version of the patch, as you suggested. If compelling use cases emerge in
the future, we can consider reintroducing the support at that time.

Thanks again for your helpful review!

Best regards,
Youngjun Park

