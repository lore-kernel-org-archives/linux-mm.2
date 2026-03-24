Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49FD1D58CCA
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 12:48:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A25E16B0005; Tue, 24 Mar 2026 08:48:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D70E6B0088; Tue, 24 Mar 2026 08:48:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9144E6B008A; Tue, 24 Mar 2026 08:48:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 80FA66B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 08:48:11 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4C756C1F6E
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 12:48:11 +0000 (UTC)
X-FDA: 84580934382.08.288FD86
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3F3FD40006
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 12:48:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf12.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774356489; a=rsa-sha256;
	cv=none;
	b=0Ph/b2y/6XWzFNsTO/ZPXra8vz1w7Zp+smxTwiRl3BqNxKJoblu4xXj9vjFa+dKcQeosPM
	zxohV0IEkzc6qXD9Hqtoqq7p8xPpY+/6ft/MsMEG0i8UDpTkXMjOrqfcmyL2jZo3Zd/Dap
	UNaeUr9B5K0wck59JVR/jaWCr5xpiVM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf12.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774356489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rNoNuJPsb0Zu2MhBxSefTW2Wr6TV6iWZ94UbdLbBscY=;
	b=oKY76HAB3vfYIbqDwXFwhFp+srQGsoftTsK2ldlfAMP9qCv4cZdtKzkAsdU+j4oYUn+zDn
	6ZGYOPjrwkovhZoisrWGLHgovfgPWZCyTURPWRpku9NmC4IucBbUB4fkNpgiBRWxvZhahS
	BK14j+AtNuQtoiadMD+t5ZAf0CPJUtk=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 24 Mar 2026 21:48:04 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Tue, 24 Mar 2026 21:48:04 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: "Rafael J . Wysocki" <rafael@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Pavel Machek <pavel@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>,
	linux-pm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v8 1/2] mm/swap, PM: hibernate: fix swapoff race in
 uswsusp by pinning swap device
Message-ID: <acKIBGjQDZrMQXjF@yjaykim-PowerEdge-T330>
References: <20260323160822.1409904-1-youngjun.park@lge.com>
 <20260323160822.1409904-2-youngjun.park@lge.com>
 <acH_svpUwaNtFeJN@KASONG-MC4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acH_svpUwaNtFeJN@KASONG-MC4>
X-Stat-Signature: mxsgcmqkx5mo6kb7ngrjcggmzz6r6q9b
X-Rspamd-Queue-Id: 3F3FD40006
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774356487-770822
X-HE-Meta: U2FsdGVkX1/QBAPkvnNZM6IlvtQ2P2wSBesSEVIongNDzCywkJHEf9pKPTrJbkZwevQuyuU1WcEIYc2Dj94JG7YNfaJQzT73lPo9kK3uMtNvnW/ydzzOQiQ99brz9PkNgLpEaLXvmn/3xU5PB6zZoLdftOa7S8EdvxQ0IQ5zBGOqhdWKFYPlqHjIy3jjV8ZEdaV6DeCBq8fMsTyT7LsvS9IERTd9U5YjBSfgqh8nOJMewSVyX6xOnQLaAhQbjRYVyvkgclVB0MlbOzMdFqLs7HNgLWm81yXz3Ri/dmPv0ffF3BHmzi6zBOf1+VSwrm6IaPtv/rLIOzq+mDDWdOtbzVnhH0vnPXzfSMz+Vp/oPWVYD0gsjZWPNK7WSwnu3KFNxa3h71Cie/Y02V3rgqxSeANVFZ9RujcMIFOhAE04r8hBDqFsz+G7GB0ojYXjoOwA9CFaYQAO4nsKXNjViMDmKsei+NfvYBO4WoMf3/czGfiYTrZGPKCLu0AqSALFHEr2XS66dbdnt1VsUOwZ+7i8mFOQaySGUpcnkk0IaypsJkbOsPRlzSTyDtomNDMOl6vScj09fhwJlrRWb6L1289ggFJ4nbl3HMYxNr3cRJuq7h9/5UQNYZ2Yl0KVILYujwYVmNaeODMtY8HBlAQ11kzN14I6o5Yxc90D2Wlreim2YOQ6XLtAPzZ97pVcvMsPSUYnJY9TOi66GyzEDyqONDgu2MoOmG3PvCuZR2SXwAASwHKiFG1JYRfhzCGHLWxoaOXUdcAvw9KsnJ1WBk3eKYI0nIW3NWhqcRLmyiyCzVreU4lTSCVn8/3FFl6N02dmcPsBt4xtUbW7n84Ll8i8bJ+BSa0l0NcG8A37VHWvksTxFq+0E5Urm3axPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 01:53:33PM +0800, Kairui Song wrote:
> On Tue, Mar 24, 2026 at 01:08:21AM +0800, Youngjun Park wrote:
> > Hibernation via uswsusp (/dev/snapshot ioctls) has a race window:
> > after selecting the resume swap area but before user space is frozen,
> > swapoff may run and invalidate the selected swap device.
> > 
> > Fix this by pinning the swap device with SWP_HIBERNATION while it is
> > in use.  The pin is exclusive, which is sufficient since
> > hibernate_acquire() already prevents concurrent hibernation sessions.
> > 
> > The kernel swsusp path (sysfs-based hibernate/resume) uses
> > find_hibernation_swap_type() which is not affected by the pin.  It
> > freezes user space before touching swap, so swapoff cannot race.
> > 
> > Introduce dedicated helpers:
> > - pin_hibernation_swap_type(): Look up and pin the swap device.
> >   Used by the uswsusp path.
> > - find_hibernation_swap_type(): Lookup without pinning.
> >   Used by the kernel swsusp path.
> > - unpin_hibernation_swap_type(): Clear the hibernation pin.
> 
> Looks good to me, thanks!
> 
> Reviewed-by: Kairui Song <kasong@tencent.com>

Thanks for the review, Kairui, and for all your feedback throughout
the revisions!

> Just one trivial nit picks below.

> > +/**
> > + * unpin_hibernation_swap_type - Unpin the swap device for hibernation
> > + * @type: Swap type previously returned by pin_hibernation_swap_type()
> > + *
> > + * Clear the hibernation pin on the given swap device, allowing
> > + * swapoff() to proceed normally.
> > + *
> > + * If @type does not refer to a valid swap device, this function
> > + * does nothing.
> > + */
> > +void unpin_hibernation_swap_type(int type)
> > +{
> > +	struct swap_info_struct *si;
> > +
> > +	spin_lock(&swap_lock);
> > +	si = swap_type_to_info(type);
> > +	if (!si) {
> > +		spin_unlock(&swap_lock);
> > +		return;
> > +	}
> > +	si->flags &= ~SWP_HIBERNATION;
> 
> Will the code will be simpler if you just:
> 
> if (si)
> 	si->flags &= ~SWP_HIBERNATION;
> 
> Just personal taste, free feel to ignore.

Noted on the style preference. I'll keep it in mind. :D

> And as you mentioned this is on top of swap table p3 so you based
> it on mm-new - but isn't p3 already in mm-unstable? Maybe we can
> have it there? Not sure how much conflict are there with PM.
> 
> The code and design looks OK.

Regarding the base branch. Andrew is already aware of the
potential conflicts in linux-next, and we've discussed possibly
parking this for the next cycle depending on Rafael's input.
So I think we can keep it as-is for now and see how things go!

Best regards,
Youngjun Park

