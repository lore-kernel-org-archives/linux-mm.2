Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F0E5C83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 18:41:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D9078E0006; Tue, 22 Jul 2025 14:41:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B0968E0001; Tue, 22 Jul 2025 14:41:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2F2D8E0006; Tue, 22 Jul 2025 14:41:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E1ECF8E0001
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:41:53 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B8B0414049C
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 18:41:53 +0000 (UTC)
X-FDA: 83692769706.06.9C0279E
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf07.hostedemail.com (Postfix) with ESMTP id BEE6540005
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 18:41:50 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753209711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zNijhzVPAXfwFTdPv9HWM2MvChy+xHYpSf07GU5iK7g=;
	b=dMnH9T7xSKvKj+XOULNv4mS7xXorry0aacNkrIP0cBIlzpnieBlj95eDoWK3++oTwRoArF
	/5Xbs3fI4t73Mc+VpAY7+ZpjTwBQWQg/mDe55Puhd+6EkGgyXiZfqAonN5YJEUUrBmjGY/
	klDWpozFq9sSow/dGbrjMI+x1mCCQUg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753209711; a=rsa-sha256;
	cv=none;
	b=JL3cgkiuJQb4VAmrSsxrrN0pX0wKx/XlMvoomC3pDNAo0jq5dnRm6CzX4UZQnnlUMD+8uN
	Uooo+/sXmAs/0to+wvVCYEI/IDhkpgbhBkP/7uDRz0FSe4f8UDaTZGup1rzUY/zJP/vydO
	moPhi7w+Rb9nYh2WrNxD4TwZKXHh72A=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 23 Jul 2025 03:41:47 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Wed, 23 Jul 2025 03:41:47 +0900
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
Message-ID: <aH/baxIgrBI3Z1Hl@yjaykim-PowerEdge-T330>
References: <20250716202006.3640584-1-youngjun.park@lge.com>
 <20250716202006.3640584-2-youngjun.park@lge.com>
 <jrkh2jy2pkoxgsxgsstpmijyhbzzyige6ubltvmvwl6fwkp3s7@kzc24pj2tcko>
 <aH+apAbBCmkMGPlO@yjaykim-PowerEdge-T330>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aH+apAbBCmkMGPlO@yjaykim-PowerEdge-T330>
X-Rspam-User: 
X-Rspamd-Queue-Id: BEE6540005
X-Rspamd-Server: rspam06
X-Stat-Signature: 7xi69m5wrokatti35q3ahfojt8q1ehcw
X-HE-Tag: 1753209710-104889
X-HE-Meta: U2FsdGVkX1+6iZPXknbJJ6CN33V0vwGFqZ4zAdecMaE0IbwY9qepqhRSLSNvY4m93cwJhVCGsOewhej1ss8enVP3SkV3UXg+1VWWjVH7LFtiKOm5ghwi2+vcZFlWBvcIHXIGGdnxAbekPG7lbvo/q04Fe8MRS0K3aVg7wn+h1eKwcqHnGf9j1mEVWWf9dheVL+v9FV1+VTzkVZeC5WQPuIfy7sFrjApqZXY3vtpTX7gnAAEYNgVxOsfVS4rvO9dSFqvxjX2Cc+VgmH8lzvhgJ3xJIlMNxxVFzxBCgTYVOkNneV1QZqOS/up1Ae5mHd9vo2bSX21XbO5QKDYYchTsGqie7ZWcpkvzzqXEG90lxTQZoO5395aRu7RpMSt0TU0bJ37R7tmDg7bfbwn4YsR1+lapxB1LxsAD/fbsVh65HNcvlQ9jbAxYgyANHB82JpeYRz7fq2i/1UqnqUBXwF3t7XxLAktdaUEiwoGdPZFHQam2wNpQp3vtgY+cHFYeRWQOMEsL8H4d7Cig7Mu04te9IPUiycTb/UQfZVIaks+waaIJG9T8TjoyC0v60lc+yMePQ6O1UQbUo6AHvn/7AhVh7ep7jqdAuzAgNBcuAG4NNm6A5/4w3UOEsPjQv3tos6wbZg/VHPnxU7/rLE57d3d7QfLz5+zr/dzGfWA4HQuzyq+xrXSSS4wcBBnJ36xpzEGvW7PljWUbiAppIY/sxJGS5THl5eqDUYvzZ0ULvzyiXX9fVHjRrg5kT6puUdb8jHfGuTl91DIRbkeWP619OBPMUYg2QH+3qfNxv7BvURTLHmdVq2c2mSgdNpzjpHpnOJTp6OPQuFK+TOFEVYvMl0xcEr7gZPtHHuw8eNwY9vMyA5cZSv+BlYokEiULo2j0Wv+8ef2U1HdJ4MvW2YnUxZYEZBPAxo+Qud5wgZIlIU/bJ9CpKNzBifVOf5gxPK4vi9W4aaMPNhi2v43DU/fuGPO
 rIiC8mNq
 jjvWmeX7zw6qjwA3/Kl4GmqNTSHNdyveicY/g0Ms2E7qBiuhWodzxDCDss85MFK2jkO5jlDHNxVC/iFX6PFDPZVfkLD6vSVqCi96JDHy6nSACuxF4x7M/SWysxenzNnQDgdw8BzRR8TRvhAr7eGGV8kIqOPutL3u/oX2JGqIYcVQHUACwT3VG+3cqssKFRGy2kXvaGYAzPGmHEmj2aYtQLZYMCEt4zBxr1c4iLqg7q0ozee5keGpYA1ktr0aCv1mAw+6n4TASmM4xMss=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025 at 11:05:24PM +0900, YoungJun Park wrote:
> On Tue, Jul 22, 2025 at 10:41:20AM +0200, Michal Koutný wrote:
> > On Thu, Jul 17, 2025 at 05:20:03AM +0900, Youngjun Park <youngjun.park@lge.com> wrote:
> > > +  memory.swap.priority
> > > +    A read-write flat-keyed file which exists on non-root cgroups.
> > > +    This interface allows you to set per-swap-device priorities for the current
> > > +    cgroup and to define how they differ from the global swap system.
> > > +
> > > +    To assign priorities or define specific behaviors for swap devices
> > > +    in the current cgroup, write one or more lines in the following
> > > +    formats:
> > > +
> > > +     - <swap_device_id> <priority>
> > > +     - <swap_device_id> disabled
> > > +     - <swap_device_id> none
> > > +     - default none
> > > +     - default disabled
> > > +
> > > +    Each <swap_device_id> refers to a unique swap device registered
> > > +    in the system. You can check the ID, device path, and current
> > > +    priority of active swap devices through the `/proc/swaps` file.
> > 
> > Do you mean row number as the ID? Or does this depend on some other
> > patches or API?
> 
> You're right to ask for clarification. The `<swap_device_id>` refers
> to a unique identifier added to each swap device entry in `/proc/swaps`.
> I will revise the documentation to make this clearer.
> 
> As a side note, I initially had concerns about breaking the existing ABI.
> However, the additional ID column does not significantly change the
> current output format and is gated behind `CONFIG_SWAP_CGROUP_PRIORITY`,
> so it should be safe and intuitive to expose it through `/proc/swaps
> 
> > > +    This provides a clear mapping between swap devices and the IDs
> > > +    used in this interface.
> > > +
> > > +    The 'default' keyword sets the fallback priority behavior rule for
> > > +    this cgroup. If no specific entry matches a swap device, this default
> > > +    applies.
> > > +
> > > +    * 'default none': This is the default if no configuration
> > > +      is explicitly written. Swap devices follow the system-wide
> > > +      swap priorities.
> > > +
> > > +    * 'default disabled': All swap devices are excluded from this cgroup’s
> > > +      swap priority list and will not be used by this cgroup.
> > 
> > This duplicates memory.swap.max=0. I'm not sure it's thus necessary.
> > At the same time you don't accept 'default <priority>' (that's sane).
> 
> That's a valid observation. While `memory.swap.max=0` controls the overall
> swap usage limit, the `default disabled` entry is intended to disable
> specific swap devices within the scope of this cgroup interface. The
> motivation was to offer more granular control over device selection
> rather than total swap usage.
> 
> > > +
> > > +    The priority semantics are consistent with the global swap system:
> > > +
> > > +      - Higher numerical values indicate higher preference.
> > > +      - See Documentation/admin-guide/mm/swap_numa.rst for details on
> > > +        swap NUMA autobinding and negative priority rules.
> > > +
> > > +    The handling of negative priorities in this cgroup interface
> > > +    has specific behaviors for assignment and restoration:
> > > +
> > > +    * Negative Priority Assignment
> > 
> > Even in Documentation/admin-guide/mm/swap_numa.rst it's part of "Implementation details".
> > I admit I'm daunted by this paragraphs. Is it important for this interface?
> 
> Thank you for pointing this out. My original philosophy was to preserve
> as much of the existing swap functionality as possible, including
> NUMA-aware behaviors.
> 
> However, I agree that the explanation is complex and also not be
> necessary for my proposed usage. After some reflection, I believe the
> implementation (and documentation) will be clearer and simpler without
> supporting negative priorities here. 
> 
> Unless further objections arise, I plan to drop this behavior in the next
> version of the patch, as you suggested. If compelling use cases emerge in
> the future, we can consider reintroducing the support at that time.
> 
> Thanks again for your helpful review!

I'd like to revisit the NUMA-aware swap priority behavior based on
further implementation consideration. After refining the idea 
, I realized there are potential issues
if we fully remove NUMA autobind behavior when cgroup priorities are
set.

For example, suppose the global swap device priorities are configured
as:

  swapA -2
  swapB -3
  swapC -4

If we update the per-cgroup priority of swapA to a positive value, it
feels natural that only swapA should be affected, and swapB/swapC
should remain subject to NUMA autobind as configured globally. In other
words, the presence of one overridden device shouldn't disable autobind
entirely.

Thus, it seems that we may still need to retain some internal structure
for honoring NUMA autobind even when swap cgroup priority is enabled,
at least for the devices not explicitly overridden.

This leaves us with a few design options:

1. Treat negative values as valid priorities. Once any device is
   assigned via `memory.swap.priority`, the NUMA autobind logic is
   entirely disabled.
   - Pros: Simplifies implementation; avoids exposing NUMA autobind via
     cgroup interface.
   - Cons: Overrides autobind for all devices even if only one is set.

2. Continue to treat negative values as NUMA autobind weights, without
   implicit shifting. If a user assigns `-3`, it is stored and used
   exactly as `-3`, and does not affect other devices.
   - Pros: Simple and intuitive; matches current implementation
     semantics.
   - Cons: Autobind semantics still need to be reasoned about when
     using the interface.

3. Disallow setting negative values via `memory.swap.priority`.
   Existing NUMA autobind config is preserved, but no new autobind
   configuration is possible from cgroup interface.
   - Pros: Keeps cgroup interface simple; no autobind manipulation.
   - Cons: Autobind infra remains partially active, increasing code
     complexity.

4. Keep the current design: allow setting negative values to express
   NUMA autobind weights explicitly. Devices without overridden values
   continue to follow NUMA-based dynamic selection.
   - Pros: Preserves current flexibility; gives users control per device.
   - Cons: Slightly more complex semantics; NUMA autobind remains a
     visible part of the interface.

After thinking through these tradeoffs, I'm inclined to think that
preserving the NUMA autobind option might be the better path forward.
What are your thoughts on this?

Thank you again for your helpful feedback.

Best regards,
Youngjun Park

