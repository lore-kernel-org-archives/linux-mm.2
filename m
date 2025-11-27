Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31B20D116E7
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 02:22:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78B416B0008; Wed, 26 Nov 2025 21:22:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 762C36B000A; Wed, 26 Nov 2025 21:22:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 678426B000E; Wed, 26 Nov 2025 21:22:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5571E6B0008
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 21:22:31 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D524C13BD56
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 02:22:30 +0000 (UTC)
X-FDA: 84154788060.25.2AAB649
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5754F1C0015
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 02:22:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764210149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pdjWkcPex6Z4IwI2NZ3a/x2uMX0QM3/L7+8rpG9CWd0=;
	b=VshZYIIJ+7BwFJ1k9unxVffYYhrR3ccXR5qGVN+N5cKWN9+IW9kW6FS38mW0iPXb7ILLVN
	rcAVxFTlJj+2ME6cAzq0D4QlKcumeqh8URgB54rm7EHTrC7EZR7QcB264z8JIPywLioiFW
	sfe1adrTpR3HO7f0BstPNrXVLFE79TE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764210149; a=rsa-sha256;
	cv=none;
	b=E0/SK63ixfz+PQDlL8/2ZRu18IyT5AeSo9ri20ZiSGnh0Dr1xLroMdStXjrnF4xfgyQS2r
	pwegifqg4rEQuQPur0N59WM/I8XToHUOYQeUP4vzpPVRmc1UUlHPeMOVnuwBfXNhezzt1A
	ZCrFpFnvmxLCfLx8gY5SZs82uhuu9HY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 27 Nov 2025 11:22:23 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Thu, 27 Nov 2025 11:22:23 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, shikemeng@huaweicloud.com,
	nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 1/2] mm/swapfile: fix list iteration in swap_sync_discard
Message-ID: <aSe131xi3VChbWzw@yjaykim-PowerEdge-T330>
References: <20251125163027.4165450-1-youngjun.park@lge.com>
 <20251125163027.4165450-2-youngjun.park@lge.com>
 <CAMgjq7C0BVx8OVhEgJu3sVTAgTMrh_-vs9OrmwQhyFX6xC_LKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7C0BVx8OVhEgJu3sVTAgTMrh_-vs9OrmwQhyFX6xC_LKw@mail.gmail.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5754F1C0015
X-Stat-Signature: gbhi791dn7jhhut4jgrstt7gxmeb4fbm
X-Rspam-User: 
X-HE-Tag: 1764210147-143735
X-HE-Meta: U2FsdGVkX18Kx2GPEupV9LR4VE1dLxeedYLIs6TtQ2g/7Wbtlrmg3SPm/d9mucLsI2VWE+SrxegDqujmn6v5/7/9muy6iRd0RSZN7i8S0/inSR3eR7DCXNoY0o0dYcz4l/se49kR/I99qFNKCWKYqC5LzP4Ta5HF4oCxcU8PFcKI+Z3clqTaV5ghjCYRlO57aCzt02Nv+Yfx0aBVJCxli4SXcAH0p/BBo5Ev0Se0+Y46aMNREI6Zyguw0srNaSUssRXC8izlyLCtAqF69aUKfmVAYfocrFamsZbC+1PN+tHobJL1BPuOUK50odmLnBOKol4e05oyuC3JTornRzIMxCps4Ml8E1v4Jwpl9ATJ9Jfj4oxO0sykbG6s2tnn9CJDAbu1L3WfdeG3QS61UjTl79lRpMmS8uuqRqGpKLJaZ5enCJ/mxEIlEvgWtGwnfx0QdjJjEzXGwszmZYSHPYoiexvDvRN9hCiUA2Mm5hnS0pjF1iwBWyTiF4p8juGnjN5iKpGZhOXLXRaOYkUUPGfnXy/MOSCxiFrEGvT6jOYsqazPJ1I1wUtRDmy2nOakBHUdjxB/mlT/S8zm5yd2vGt7qATfeeRPmYl/7ujOfMV/VJ928aU5JdLOD0fC8Zg3BsybHDLoNcrIJc36BKAn45ObtURLcRF7Nki1byR8Q8HcDBV85CMLJkvA0E63MMVnWipFhle2Hd7ot4JF0r8KjEIWKO2CGnmnEOxKCVL7GM5rhgSHu4kW7VYyVGKFCNB41gfNzk/dbfyThci7MkmyPRvVim1FQq0pVpDQWIVGpDBjQlYoFIf8nUq4BOu+lkvZyR1JDpezSR1kcZX4dcVzp0t329njkwos6EG94oXKrVCekVg17TBMRxZKWOyeVrPN2QzeUH4K58ZBaw00+m8iHoSujy4gQT0mYXwQ46/Pdu9h/+v3X3dvQHYq49JqG6nqJn1rTkkRv8a+Oh13KMKuxI0
 X6iDfXrf
 XVqESm4Xxx+0OnSjkDBfjx7Y+/ZuSznzMmMkgjDOR2HaDgosnUMyz/zlxUFwTTVHIaJVCH8MdnWJsHQqt0EcoHcMzNBWbEkd+9Hw6pgT0t0rbzIdVogzW6/4JNHF7P+JxFDLXRiWJTXihAAYm6jzWu10jR9ACTpPW0Q84RWd9POWJc8h1tDliBLnCnG+q626ulme10EEn0atvFoMwixookcyLVOaBbncFw8JvoQZQ6y0FC/MGP2SD3WaKBO7kR0hlLdtUVBXs8Polge1GvdpezXS34jecxAiPNoZfE8lELIjBdBqCh/Yxrc/prsLbxjKQN1MjSHoRI84Y+GA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 27, 2025 at 02:23:05AM +0800, Kairui Song wrote:
> On Wed, Nov 26, 2025 at 12:31 AM Youngjun Park <youngjun.park@lge.com> wrote:
> >
> > swap_sync_discard() has an issue where if the next device becomes full
> > and is removed from the plist during iteration, the operation fails
> > even when other swap devices with pending discard entries remain
> > available.
> >
> > Fix by checking plist_node_empty(&next->list) and restarting iteration
> > when the next node is removed during discard operations.
> >
> > Additionally, switch from swap_avail_lock/swap_avail_head to swap_lock/
> > swap_active_head. This means the iteration is only affected by swapoff
> > operations rather than frequent availability changes, reducing
> > exceptional condition checks and lock contention.
> >
> > Fixes: 686ea517f471 ("mm, swap: do not perform synchronous discard during allocation")
> > Suggested-by: Kairui Song <kasong@tencent.com>
> > Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> > ---
> >  mm/swapfile.c | 18 +++++++++++-------
> >  1 file changed, 11 insertions(+), 7 deletions(-)
> >
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index d12332423a06..998271aa09c3 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -1387,21 +1387,25 @@ static bool swap_sync_discard(void)
> >         bool ret = false;
> >         struct swap_info_struct *si, *next;
> >
> > -       spin_lock(&swap_avail_lock);
> > -       plist_for_each_entry_safe(si, next, &swap_avail_head, avail_list) {
> > -               spin_unlock(&swap_avail_lock);
> > +       spin_lock(&swap_lock);
> > +start_over:
> > +       plist_for_each_entry_safe(si, next, &swap_active_head, list) {
> > +               spin_unlock(&swap_lock);
> >                 if (get_swap_device_info(si)) {
> >                         if (si->flags & SWP_PAGE_DISCARD)
> >                                 ret = swap_do_scheduled_discard(si);
> >                         put_swap_device(si);
> >                 }
> >                 if (ret)
> > -                       return true;
> > -               spin_lock(&swap_avail_lock);
> > +                       return ret;
> 
> Nit: I'd prefer to avoid unnecessary changes like this, `return true`
> is the same thing. No need to send an update for this though, a really
> trivial issue.

Okay, I will revert it to the original code.

> > +
> > +               spin_lock(&swap_lock);
> > +               if (plist_node_empty(&next->list))
> > +                       goto start_over;
> >         }
> > -       spin_unlock(&swap_avail_lock);
> > +       spin_unlock(&swap_lock);
> >
> > -       return false;
> > +       return ret;
> >  }
> >
> >  /**
> > --
> > 2.34.1
> 
> Thanks!
> 
> Acked-by: Kairui Song <kasong@tencent.com>
> 

Thank you
Youngjun Park

