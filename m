Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D8F1CF3959
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 16:37:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B1536B00C8; Wed, 19 Nov 2025 11:37:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 762016B00D7; Wed, 19 Nov 2025 11:37:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6785C6B00D8; Wed, 19 Nov 2025 11:37:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 546486B00C8
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 11:37:58 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 27D4D59716
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 16:37:58 +0000 (UTC)
X-FDA: 84127913436.09.9CFAE5A
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf27.hostedemail.com (Postfix) with ESMTP id B7A6C4000D
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 16:37:54 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763570276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZM7rDxC0VfAIPS040RV0Yt5B6rsIxJQzvNIDiA//oq4=;
	b=zucopcIRbkFkQ7j2zQFDqmB637U0pfUduWGJjDVxwtmWHcLTuX53uXHFf2KtUq9DBzeuoa
	XtgDF8h3I5ukrgRaVax497VIIYU99OodHupof0z2wooP8rGrAOoyva3DZ65CsMezU/FQ4G
	uSpU6HMoqEe/gZapN4LFWCHvnICgG+o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763570276; a=rsa-sha256;
	cv=none;
	b=eKQ+Z1veTv0MIeDI14b9T6BWjCPYnHqWzYEjxIzeXhMwxtm58e627bz+fiMqwSTPOVSe9O
	/BjQOPsvefDCEv3xnWCrtNmg7NG4FO97MLlFkr1evGU554/q6AjsG34n6rxU0MFJ1l9iRy
	PBSs1Xu/mD0y4azf+aO5CrN+uBzSFKg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 20 Nov 2025 01:37:50 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Thu, 20 Nov 2025 01:37:50 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, shikemeng@huaweicloud.com,
	nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/swap: fix wrong plist empty check in swap_alloc_slow()
Message-ID: <aR3yXh2/DhYaN8h7@yjaykim-PowerEdge-T330>
References: <20251119114136.594108-1-youngjun.park@lge.com>
 <CAMgjq7CgwjqE9XVy6EaNe0XARYOJsOER-Ch16wuZxWfq4EdFJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7CgwjqE9XVy6EaNe0XARYOJsOER-Ch16wuZxWfq4EdFJw@mail.gmail.com>
X-Stat-Signature: shbt6cbmnd5o9u7mbutf46diu388u8kj
X-Rspam-User: 
X-Rspamd-Queue-Id: B7A6C4000D
X-Rspamd-Server: rspam01
X-HE-Tag: 1763570274-286734
X-HE-Meta: U2FsdGVkX1+TyOeoy+f1z8Gpim0Y50r//MfxubSSYduJQ0/VN0ELoy2g15RwH4dmXdqDDjNN0Q0cTwR5tIUg2rGdq9FFYozif8OheANIZ6K2UAJyjyfOfIh/dxLfmO0sVdbOgJUOTE6yUCSlejtYj/CSs6P7dW1YKpy6XZ2cMQqv/Wlrs/vdDxlF61+DFFedvfLm3M2Mk+lNfVk95umH+KiLCp5LDgv4AOzb/75DHOr39tVFJKdtVYJlivazrkc7/FSsk8XMqy40t+CeRK0hKsrFpq5CCM/kAN1+ZTNJ18DKrQkoveTmOKGaJZVo07VVZQT5TAxGHDhB7CQQVQ3GZFALcGaPbv18ccmnvfcrt6hi89OA+N89lXEy5EeRJz3hYiUl0v88936da7MUhy/CeaFKzFk1FXyJKevcipFMNqsTuR9/MF9z/2bhf7fL1KiFwSLTTIr9sH26djW2U444B1LRPvdrS9gzFHJdHye8HffiT6VjQOAsKUyY1iGPZYeOhdcBx3c77mEgbIsBUDF9zEY+VuPHAoarLtui97qPHryZ4BzXuZYmDSlhB2P/kDlR1/23XuE8iraulxMv8YeyiZRzZ9YYxsxi84vOfW23BSa84c/DMh6oz1FRhXj/5wER/xogxh1zR0sZ0WXBLrk4Izh1xP3/qHtmpaZwRjvxo2kr4uBM8vsINM/YZJmSuQtiPt/OPym2ZJEnKi7WITyiM7nukYSXCfeDd3H+XH/Festuc/c6fsOMjE5Cnddx41Y+nuH8UCk8X2mO/PCoTj09d8P+NvOQFzh0TB/lItAt/Fj+qnF+kg/Si9Bn+i6twH4E5U9BiNUdb0GWrtlT65GHzSYuXhZAPrTaJnF3aYd/CHL1dwbXpU8AH6vAIblznPAYDJN8MS75mhzEcic+Jc0S6el1DKv1gGf65TPB46fOvPWKMfB73+/Z9BTgT0QLVWyOcbTc0avLfYFD0G5SC0a
 tdHJKmf7
 oWn+v2DQWJWVjYTMZjxBeA/6WFFUL5oH/DoSp863Cyo9Tr7oltdkj5WCd1GDCz+i4F8a5L6va+Ky3g5WQ4Md057nJb72P/4rtysUWr/GvxG16WaafWVWPB1ZH2jr2YLgkIhwHlzw7hWBpWYrbonH3CsoxjV2hbaUF/ksNFkOF7rUDknb5wOiYcGqRtreycj1Ebu+ekEYwaf99f7keEZl1ND8U2C4Tx7GIZ2KndkSymOryNip7ppntDrTYKd9qgMgngpwnYrWF3XFgFbrUbLaqxZs/UHZSorVGDc0x8r3njohNjgtwkDAEwYJpOugFDA3PgK05I8OUdcsd8uo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 19, 2025 at 09:02:14PM +0800, Kairui Song wrote:
> On Wed, Nov 19, 2025 at 7:56 PM Youngjun Park <youngjun.park@lge.com> wrote:
> >
> > swap_alloc_slow() was checking `si->avail_list` instead of `next->avail_list`
> > when verifying if the next swap device is still in the list, which could cause
> > unnecessary restarts during allocation.
> >
> > Fixes: 8e689f8ea45ff ("mm/swap: do not choose swap device according to numa node")
> > Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> > ---
> >  mm/swapfile.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index 94e0f0c54168..cf780fefaf7d 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -1374,7 +1374,7 @@ static bool swap_alloc_slow(swp_entry_t *entry,
> >                  * still in the swap_avail_head list then try it, otherwise
> >                  * start over if we have not gotten any slots.
> >                  */
> > -               if (plist_node_empty(&si->avail_list))
> > +               if (plist_node_empty(&next->avail_list))
> >                         goto start_over;
> >         }
> >         spin_unlock(&swap_avail_lock);
> > --
> > 2.34.1
> 
> Thanks!
> 
> Acked-by: Kairui Song <kasong@tencent.com>
> 
> BTW I noticed the comment here needs update too. And the plist usage

As I think, the first part of the comment is out of date and provides
wrong information. I suggest we simplify it to keep only the last part:

/*
 * swap_avail_head list may have been modified; so if next is
 * no longer in the swap_avail_head list, start over if we have
 * not gotten any slots.
 */

> here seems can also be simplified? We never use a lower priority
> device when there is any higher priority device in the list, as
> devices are removed from the list when they are full.  And the first
> thing we do here is plist_requeue. So we can just keep trying the
> head, until the whole list is empty, seems good enough?
>

if we can guarantee that cluster_alloc_swap_entry() failure is always due to
the device being full, then we could indeed improve this by removing
the "try each device in order" loop and only trying the highest
priority device, as you suggested.

A simple implementation might look like this (though it needs more
thought and testing):

spin_lock(&swap_avail_lock);
while (!plist_head_empty(&swap_avail_head)) {
    si = plist_first_entry(&swap_avail_head, ...);
    plist_requeue(&si->avail_list[nid], &swap_avail_head);
    spin_unlock(&swap_avail_lock);
    if (cluster_alloc_swap_entry(si, order, SWAP_HAS_CACHE))
       return;
    spin_lock(&swap_avail_lock);
}
spin_unlock(&swap_avail_lock);

For now, would it be okay if I just address the comment update in this
patch, and submit your simplification suggestion as a separate patch
after further consideration? 

Thanks, 
Youngjun Park

