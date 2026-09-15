Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81108C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 04:17:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA9F36B0088; Tue, 15 Sep 2026 00:17:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5C556B008C; Tue, 15 Sep 2026 00:17:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9B316B0092; Tue, 15 Sep 2026 00:17:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B29AE6B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 00:17:02 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0CABA80173
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 04:17:02 +0000 (UTC)
X-FDA: 85214686284.18.DE88B2A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4CFA6100009
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 04:17:00 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=KWrjAVLC;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=KWrjAVLC;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789445820;
	b=eyExGNWZzPHFyG1pmAifP4KI/TFQAZVDv/YtdxJf5mwKXZ/X+fLxky6gozI9rHwZr2hX6/
	g+dtBxCjEhvxE9LnlZxNciENo9fg6S6XwbkCIK3mMqk2siETYxtK2pwlC1x6tw5znK1Myg
	Vf0nfBbJU3B7ZVClAKutiqvoXRMZpQc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789445820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5DcEPacjJf0+F0se6JCTkxzrdHbL2Pp64Tt6ymciBRg=;
	b=Duw4mQZU0Xe0HB/EEQhnSnTPdZMF3EFLMx9xUV8GSonYH74e5gQAJpj9a7KW/ObWYGW8KL
	+H8o8s+IbsFXpQ2CKxkunitJqv2pYRr2R5c1Rg2ceahVrWXWy7JreY7TrtJuCmyR9yFpPy
	JW/OQ2tt8BnVbTWeRKM8Xidlagw/984=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7C6886025F;
	Tue, 15 Sep 2026 04:16:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7ADD1F000FF;
	Tue, 15 Sep 2026 04:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789445819;
	bh=5DcEPacjJf0+F0se6JCTkxzrdHbL2Pp64Tt6ymciBRg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=KWrjAVLCns6TP+OVJPC7RcegKRYvNZral/TIjux1pI++moz3BjkEU55c0F4wy33jK
	 a0CqotZJu7tC9ebvbDUFFr2DL1Ys8t2w5L171nNShd2C9e+3vV+yLk/aybIzcEpvlz
	 fByoWHMKqdL9EaALLWG9zbkWtKbjrQe9pmkrxbak=
Date: Mon, 14 Sep 2026 21:16:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Baoquan He <baoquan.he@linux.dev>
Cc: Baoquan He <hebaoquan@kylinos.cn>, hannes@cmpxchg.org, yosry@kernel.org,
 nphamcs@gmail.com, chengming.zhou@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kasong@tencent.com, chrisl@kernel.org
Subject: Re: [PATCH] mm: zswap: return -ENOENT when the swap device is gone
Message-Id: <20260914211658.644e5b9b61405f4a9460b8df@linux-foundation.org>
In-Reply-To: <aqeUyxJmzC397G7j@fedora>
References: <20260913063031.1689420-1-hebaoquan@kylinos.cn>
	<20260913005149.a28c21aaca165fa0255f8475@linux-foundation.org>
	<aqeUyxJmzC397G7j@fedora>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4CFA6100009
X-Stat-Signature: o4dpqbhbbigj4imdahkhndkqgkma6851
X-Rspamd-Server: rspam01
X-HE-Tag: 1789445820-572725
X-HE-Meta: U2FsdGVkX1+aKQvMnVCIsjZEuETNkEsyeVzxToJ7jTqn5SSVK41tcbo2dhkcR2V+rHURvTprTYr+OQQg4Mt56arpSSRImq9vD4WTWVYTFgAo7Dvt83/shfXi25oi4tKFwUzWkny7YG0/NgnyxmZTdKSLQubzt5V1a6GFqFtVgy4Wm/qtAZVktHTU1XeS0+epMX+vhvy1jESOuzhIl+dO7OJJouG0L+8uvAnK/DCW9So7simXJ5vFwpbFj3XII2guhGQDJfLC0Z2mm7gdqGfQCJBNwfPTQquW86M3eZEEDXi5l6GOU57ziu4kzgDUJE8KnJ3GcUB2kr5CN+o60yWp9ix3NN8cLO4rQ48G45tg3augYF3VqTgFQIu7DMtszqRop2ESYFhkRduqPLiZhBOK3RoUaJso5WlQ10YHRwrlOViwQRDWIA1BAVT6p5rC+X/ERROvhEeT+MigOOGCpASr7ztIeGNiBM7rCK11NkN9ipqWD6PUeZRpx1MxAMP2rHJp6MIrgSM5c9wgxTIrnIvr1zEuLU1ElhndRSIrOdZ5U3qGeXPvtgh7+qG6Zq4ugxGGHXR+YwL3+M92BVq3hlsDtIYthCuTjnCdR8Xvu/m0r4WYFHvc03ROaLEGHdmcBovqU2OG8zEuwfVyUXKknH/0H184s86ct3dbpBGPLY7YvJQebLlIy1lDzYhXrOki+FdzJTQJ8gj4lDYHeG+FrkfT6kY++P0MEGogzF4fXgEkKE6K8Q+K+UPe1H6K5JNpmt0nylbpEEyEoTGubQ5DZ8b3bb8CnQtNpOe8CcoAcNGRYGseCzKi7AozkoBcSBdvIvjd821mylUDKQWj99ppmgCkxPgHRq2Z7r6P2qf8CuQe4PnR5QDV33ndryRsR7qJBRUdw7smKKY4IPIdPNVGuty0FSODJGlK0AWesKXx9WxpCOqBUGO/w8cpaxP6A9U1ONhDtlZUNwbOcunXed1+nsd
 OsKE59rL
 MgnOlf9NWyUr+jJnjdtHoSdOGT4pQSDhge9DH5PbOYfiK19tk0YLAuXVitnx8E/OyQ4K4WT8sDjgCTpjr+1ChSbLqWXV9CGLi58NOI5jN7ygbYgXsgcNr5JVPJg5rQUfL539HIxU6uA2NWCIoMJZDoLsN/GYwfO+q5j+ARPVG0mG2TK4toLq8hLpOaezsV6uFboN76E2acBhaSBQWl6KPs9k8w6vASHcBjwP+p90SL0ZS0neDuwt8Hwt5/8HUNRs6B0h9jrzn17joOE71BtshU+EVVPA/ewAwcy5csGzsL+9X3lstZyCsM5oAMPt9KYjpIhk8LE9kOJ1jZE/39rJBUK1LudC3N4tEKcjztdUEUAbQKjcrcJcIt3c0fbhSAVx8Zu2r+odlJdAMKOrDz2ROFu4oX+lHB4njCMgoDmwd6wsailCarBAeUOZc3Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 14 Sep 2026 14:31:39 +0800 Baoquan He <baoquan.he@linux.dev> wrote:

> > 
> > >  	si = get_swap_device(swpentry);
> > >  	if (!si)
> > > -		return -EEXIST;
> > > +		return -ENOENT;
> > 
> > mm-new has changed.  I made this
> 
> Thanks. Does it need a v2? or just use ther version you tuned.

I fixed it up while fixing the rejects, I hope.  Below.

> By the way, which mm branch is suggested to take as a base for mm
> patches posting? I usually take mm-unstable branch, seems it's changed
> to mm-new now?

mm-new is a front-end to mm-unstable.  The only difference is that
mm-new isn't included in linux-next.  New material goes into mm-new and
if it hasn't caused any disasters for a few days I'll move it into
mm-unstable and hence linux-next.

Ordinarily there isn't much material in mm-new.  At this moment
mm-unstable has 405 patches and mm-new has another 96.  That 96 is
unusually large because people have been sending huge patchsets today.

So mm-new is the best target for my merging pleasure but it is surely a
pain for ongoing development - it's changing at a great rate.  Those
500 patches landed in 15 days.

I suggest a reasonable process is, approximately, to develop against
mainline (or mm-stable if there's anything in it) until you think the
code is ready for mm.git.  Then rebase/retest against mm-new and send
it out.  But keep an eye on what's happening in mm.git so that the
rebasing doesn't cause nasty surprises.



From: Baoquan He <hebaoquan@kylinos.cn>
Subject: mm: zswap: return -ENOENT when the swap device is gone
Date: Sun, 13 Sep 2026 14:30:31 +0800

zswap_writeback_entry() returns -EEXIST when get_swap_device() finds no
device.  -EEXIST is the shrinker's "page already in swap cache" signal,
which makes zswap_shrinker_scan() stop shrinking entirely.  A NULL
get_swap_device() instead means the device is being swapped off, so the
entry is simply stale.

Return -ENOENT so the shrinker skips the stale entry and keeps scanning.
Independent of xswap; affects all swap devices.

Link: https://lore.kernel.org/20260913063031.1689420-1-hebaoquan@kylinos.cn
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
---

 mm/zswap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zswap.c~mm-zswap-return-enoent-when-the-swap-device-is-gone
+++ a/mm/zswap.c
@@ -1016,7 +1016,7 @@ static int zswap_writeback_entry(struct
 	/* try to allocate swap cache folio */
 	si = get_swap_device(swpentry);
 	if (IS_ERR_OR_NULL(si))
-		return -EEXIST;
+		return -ENOENT;
 
 	mpol = get_task_policy(current);
 	folio = swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), NULL, mpol,
_


