Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CF9AEEA849
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 01:59:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87E636B0005; Thu, 12 Feb 2026 20:59:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85F986B0089; Thu, 12 Feb 2026 20:59:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78E186B008A; Thu, 12 Feb 2026 20:59:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 665046B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 20:59:48 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0A2FFC1845
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 01:59:48 +0000 (UTC)
X-FDA: 84437777256.16.CB89B07
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf23.hostedemail.com (Postfix) with ESMTP id D42DB140006
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 01:59:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf23.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770947986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8Ev5vUX3H6TZuoEAoWQW/SEp4Xz2Z9z+VMVJ/Lw7EDQ=;
	b=5nXOzVx0bLUjXpxGYBZhEytldiaNKU/X3XOOizxFycdU0wR9IIeXVOVxCeHAn9toJ+kcmv
	tqfmXipxNd25eVyETMvujIsgMeEagH96X62WGqw7qdMj5bDHdK8EMC/O9JBqjP4Ib82uv2
	wHB23DNoK+r2IneHwoApaNqDkZOKWws=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf23.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770947986; a=rsa-sha256;
	cv=none;
	b=NSuJkLQoUwGeXmFbocwl2pDdju8IrMtmvvp5zbDG7ubQHLFQFrS9/NF0454cGCZf0cJc1K
	mhu9DemuGwZf2x8lD6rAwu11juVx/4r66PlY3+CuMIydiW7y1aMq6Txhln9Gda/orr8PZK
	3mIkD6jvlD2eXWqdk/qRHJOEhsZUdY8=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 13 Feb 2026 10:59:38 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Fri, 13 Feb 2026 10:59:38 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Chris Li <chrisl@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, gunho.lee@lge.com,
	taejoon.song@lge.com, austin.kim@lge.com
Subject: Re: [RFC PATCH v2 0/5] mm/swap, memcg: Introduce swap tiers for
 cgroup based swap control
Message-ID: <aY6FiohercUYKyd6@yjaykim-PowerEdge-T330>
References: <20260126065242.1221862-1-youngjun.park@lge.com>
 <CACePvbU3OoGg5-dHXOJk=62AkBxJCLmzwcHdHuPe2nnxfzMLBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACePvbU3OoGg5-dHXOJk=62AkBxJCLmzwcHdHuPe2nnxfzMLBw@mail.gmail.com>
X-Rspamd-Server: rspam11
X-Stat-Signature: r5mw1u48azta6owmzaw8yhf5x1mbejea
X-Rspam-User: 
X-Rspamd-Queue-Id: D42DB140006
X-HE-Tag: 1770947984-342966
X-HE-Meta: U2FsdGVkX1++KSnQrp+TMb2g178uKDdl91uQ2R8ylfYlEJFDqOdDM5l1FWfRJagRZfl4PDMqAbGctLo96Q1vztyzXfagsfCCInlGjUrVcHKdYcSTUZ0+QsNSTquW9H8p/wtzCoGKPb25+lQ6+VYIBHCDDF5Vto+p6hw4FMPPLCDi0llz151bPOHB4LIFVT7EbSdJYwDcokzNtIxW+7GPIj0bXTCSw06eSC9E1k0Zx+pA6VpcTy1OdagFt8cQ58E/MoYbtvXj1Uv3dvyr1gaM31hDXCh5XBx287ya0GSbifkZIiNddhoWCNUcxpUBiEl3/S9Nh9NjgKjpA3nJM7j6SbVBrxibjxzFAFuMGosFQ4V4dj8m+UGZj1Mko++mbuoEJRy93FP3QVOwe3Xiy+0/GfUS4ZwGu+YwlsNkuExhhLwAItEEpesiSy934LcXRwJCIV9dyFHtDCEsfh7i/xPiOBDY1wmQ172Io5YDjr0iZvmyv1tpZsjaW+gxgrLgrJqps9g2O7Y5k9guIzD9D9DQDRpRyaYyrK2KBuHVWWCcvmWVqIewLQq5d0wnAyA2DH278kUkzO/b2/wW9GIuts3rr1jw7D0zhHPfw0gi/PKPgbg6pn6SuX772BlxyTn9ByTdqOLzBLt9DyVirmwv4tv7jqrqdzl4vTKwDTyOtn7Sn8EScUE9fL7OMdHoIkgbbBs6qNn8QkerXqT5spxgwfxIPkxFyrPXvEKbRirb7/JMZxDGQshxy/t9hUhnrpobRBf4yBHyMQgnFHhT+r8MoKWqWcUuO7ehKqx7JfHklhPsEPMUb12e7JJ5DAwXxqhXdNZBnbyqeMduWl6Ra3s/OVT5CaiG21L/sS5AkrFpmZS33Y24niEY/57Udp49inBWDJ3A2zKBhFcvMoxcQnl3DjZMXisjeShynmH7V8zEvUrF+Rke+5rH/0R4ZKyxik3RIt2unRPRY0OQ0h9wLUPmBmL
 G2J0w9g6
 LfozBpOV1q69siGBLA0XZo8ZIqkNAtkyj8FJs2nDy0zns53zI9wdgaBiiHmayoqHAAVZxNG8siD71jIMlrqIMu2YCq/IfpwHaGsFJcxSiMd1QlmHYkM16w5loNzm3Ruw+kyCRais7DA3shRH77WwNDIOYKyp8GHV8G0oFhPZRywt2T7f4U7Fd4xIC6VcffGvijFy0VSiBi4e6qP2jIw91k6jCWerR4tUw3ovNOVgKRaqAPwVqC3XRoNY0GE+Y9oPVSAkbO+B+xols321/lTeo590kfIrQ4V5s43Iw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 10:12:04PM -0800, Chris Li wrote:
> Hi Youngjun,
> 
> On Sun, Jan 25, 2026 at 10:53 PM Youngjun Park <youngjun.park@lge.com> wrote:
> >
> > This is the second version of the RFC for the "Swap Tiers" concept.
> > Link to v1: https://lore.kernel.org/linux-mm/20251109124947.1101520-1-youngjun.park@lge.com/
> >
> > This version incorporates feedback received during LPC 2025 and addresses
> > comments from the previous review. We have also included experimental
> > results based on usage scenarios intended for our internal platforms.
> 
> Thanks for the patches series.
> 
> Sorry for the late reply. I have been wanting to reply to it but get
> super busy at work.
> 
> Some high level feedback for the series. Now that you demonstrated the
> whole series, let's focus on making small mergiable baby steps. Just
> like the swap table has different phases. Make each step minimal, each
> step shows some value. Do the MVP, we can always add more features as
> a follow up step.
> 
> I suggest the first step is getting the tiers bits defined. Add only,
> no delete.  Get that reviewed and merged, then the next step is to use
> those tiers.
> 
> Chris

Hi Chris,

Thank you for the direction.

I agree that breaking the series into smaller, mergeable steps is the
right approach. However, since introducing the definitions alone might
lack immediate usage, I propose a slightly
modified roadmap to ensure Step 1 demonstrates some value.

Here is the plan I have in mind.

1. Swap Tier Definition & Addition
   - Introduce the concept, grouping logic, and the 'add' interface.
   - Value: Enables basic exception handling within the swap device
     itself using tiers.

2. Advanced Control (Delete/Modify)
   - Implement logic to remove or update tiers.
   - Value: Enhances the usability and management of the tiers
     established in Step 1.

3. External Integration (memcg, bpf etc ... )
   - Apply swap tiers for broader swap control.
   - Value: Connects swap tiers to other subsystems like memcg.

Does this roadmap look reasonable to you? I will proceed with preparing
the real patch series based on this structure.

Best regards,
Youngjun

