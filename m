Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D27EBF513E9
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 02:48:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BAEF6B0089; Thu,  5 Mar 2026 21:48:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07BCE6B008A; Thu,  5 Mar 2026 21:48:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFEB76B008C; Thu,  5 Mar 2026 21:48:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E24F76B0089
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 21:48:16 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 832991B7590
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 02:48:16 +0000 (UTC)
X-FDA: 84514104192.02.9261379
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf07.hostedemail.com (Postfix) with ESMTP id 100B240007
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 02:48:13 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772765294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oH6CKIc7CKhiZNogBxq3XeRxOM0v6Y0jZtCVFRGhjA4=;
	b=bjaisoy0BM2QsKE5BbVidDiQiWkvkSQAwHGVKeJZqMcnEWmA7lab2z0rSvlIb1MSO5JuEW
	3QgRteZdojVVvfoS1J/t+lFg0QF8mDP+sHMX9VHcJVKdNjYCA/pc2ZIJFIxh6gqwDuYrr/
	UjslU6XAUBvGiDahlDz33hlIxxaJKjo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772765294; a=rsa-sha256;
	cv=none;
	b=8FJlR5dWh6lsShv9eBiHbKid9vN85hV+pHuNoeu6ZkAobmZbnhX+aisGtWj5N3kcehTd+Z
	YmaXY3/2lwNMFP4pQgZgBDiuSARBmeBNNWbtOgAxeXU1wQisthmQ0FaxQA+C4lyqZMtbxr
	VpE9+PjVr7TaUbOS+OwSB+iVn7xJO3c=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 6 Mar 2026 11:48:11 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Fri, 6 Mar 2026 11:48:11 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: linux-pm@vger.kernel.org, linux-mm@kvack.org, rafael@kernel.org,
	lenb@kernel.org, pavel@kernel.org, akpm@linux-foundation.org,
	chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com,
	nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org
Subject: Re: [RFC PATCH 0/2] kernel/power: fix swap device reference handling
 in hibernation swap path
Message-ID: <aapAa/A57D7pkASc@yjaykim-PowerEdge-T330>
References: <20260302165334.1278479-1-youngjun.park@lge.com>
 <20260305202413.1888499-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260305202413.1888499-1-usama.arif@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 100B240007
X-Stat-Signature: 8k38m94sbxuazhomzwaqdnumc934do75
X-HE-Tag: 1772765293-956008
X-HE-Meta: U2FsdGVkX1/DHGxmuT+F4Tu/2SUxVgBUM26Fkszq4L5E3a4Z9FDjO+o81adyvVzAjEs1habNSulfYvfluLk2PIyvQtgAJJazm9jwiI0HrXIl3FTWbPhU9gjMCv9ChdotnBNgfZx2y0MjyTT8aQ7fPQZbqUygHWUkZ1wDnKBejfWnhv+ag1tDgxcF8S0ngpVSiDYvwfyl9Rijpf1/ASkQQybtCdmz649OcA/WwlGMKffyvQJYo3iN/Ciawihw2BQDqm7W8O3cHuQV7dx1fvNAxuwP9VbDv2VbiBDVA70QjkAsF6fMvug6x36cspPLfO7Kd9aj7bvn31xebTRG3CheQnS/oxWX5vBGonBk2WV6p8us81YaKHRagvYQAq7KMNaD+yKxESP8ZSCzoSdBFksQttrtbSnkVJMcrIZ34e8GaBlJcZQm/T8ko3ZOSef/h4/XLGM7dqy6bt7voHFG1rq7etTQZWUdatUw/ObSFVWvc1qsk52IzWZKvRtnJF/F/SgLFvE22WqKtIpS0AgaCl5scs3D0RK77ooQS0gxqqzC++KmBzpxIDgUneLvab74aHj5fsLdsq+EDC4BLK2FJe8eFBiv9c7jXI2LUkeQVAQcd3SMZgu2ou9o8WR2+L237hw9ece38x7Xy5F2vNnhHKobU3eLWLlxHDCoyZfqBG3NcvyILt2Dicayt/QtlQdvpUkZ1AwZjNlBZHD6DmYHzpxd/dX/R3F5JNRH/QibFTTLWI/rQfyfOnoRZtPcEt2dCWSj8xensoJJZJB4d1UTCriYvbFrJue0xvPFO/Jvr4fnE2MybAF2Kb76LEYuHWxu8SobuCFM8OKhtMaNzjo+0EBucL0eRj5DAjMsTv9QOt2bvGW1lbYWA3TUk6iWaiwOIyWq7rUlhBSCZajoXAPR6knX6jyccBOweENu4EL9l96b0jOKDkmYB6NKBHVY9sMnJao54sL1sHlz6CT0vWFptLy
 pYTNBSG0
 UnyD4XKtjjF1tfzCigpZ0emzvNmVq9BbIYrLUm/TRgdlWDrdd6h4Mol3bp0Eobxnw4ZJDHK0vlnVPMdzTCzHCYSiMT23OsdNup52wwgbnfMc7kUHCLYaumKRbg5xyVZiZePGZYfRo89EG7Rd3G4G99fjTZsdS1sZ6rZQ4qcMkq1bT6qGP08847wRv7H/58e5JwxtwfKo4hIHiW7gvyESueFn1B5KP1LbW1bASaS8AwPLnQnfAni4F6kEyhg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 05, 2026 at 12:24:12PM -0800, Usama Arif wrote:
> On Tue,  3 Mar 2026 01:53:32 +0900 Youngjun Park <youngjun.park@lge.com> wrote:
> 
> > This series addresses two issues in the hibernation swap path.
> > 
> > First, grabbing and releasing the swap device reference on every slot
> > allocation is inefficient across the entire hibernation swap path.
> > 
> > Second, in the uswsusp path, only the swap type value is retrieved at
> > lookup time without holding a reference. If swapoff races after the
> > type is acquired, subsequent slot allocations operate on a stale swap
> > device.
> > 
> > The fix is to hold the swap device reference from the point the swap
> > device is looked up, and release it once at each exit path.
> > 
> >   Patch 1: Release the reference immediately after each slot allocation
> >             as a preparatory step.
> >   Patch 2: Lift the reference acquisition to the lookup site and place
> >             put_swap_device_by_type() at all relevant cleanup paths in
> >             swap.c and user.c.
> 
> Hello!
> 
> I cant comment on the feasibility of the approach, but for proper series,
> you would need to squash the 2 commits, otherwise it would break git
> bisectability.
> 
> Thanks

Thanks for the feedback. :D
I have squashed the commits as suggested and sent the v2 patch.

Best regards,
Youngjun Park

