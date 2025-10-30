Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECB55CCF9E3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 14:32:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55DF98E01D1; Thu, 30 Oct 2025 10:32:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E6B88E007D; Thu, 30 Oct 2025 10:32:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FCA68E01D1; Thu, 30 Oct 2025 10:32:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 291B18E007D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 10:32:46 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DB2C98634C
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 14:32:45 +0000 (UTC)
X-FDA: 84055021890.21.151486D
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6DAF91C0017
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 14:32:42 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761834764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O4Ti0tnLICSqluANkHtp232j5X2i5n5MuiXr6o5IabY=;
	b=RRKWJ8MNaekYZIJDrHTmBsMtOioff1UbUmftqcEfEgGdjsHlta23Hcq/5mOOqbWTOTIY7F
	SnCeHoOYYrRCxLAdx/LdgntrLqkKz+5sKLr4LM+r4aczvDN1Iu/M8KclfLzMLb8hn/8rMN
	9hh38z1/w7xtFYHKcpevdpcLnZ1fo6k=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761834764; a=rsa-sha256;
	cv=none;
	b=5HsewjJfTD1Cw5hZv8OoQaqEWn12VF4pwpRaFTUMMJRhWmQUeNQdqICvYoMBe+zWHqsI4r
	+nF2eA1pb2PWZtKGWZKx3hs83tQJ+Wttf3POFa/JqV9cQbd880emqP5yW33aSBO9xQVX+Z
	p8G4jNk/YZ93Ldvzbjr35Qpj2MHDAq8=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 30 Oct 2025 23:32:38 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Thu, 30 Oct 2025 23:32:38 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com,
	baohua@kernel.org, chrisl@kernel.org, gunho.lee@lge.com
Subject: Re: [PATCH 1/5] mm, swap: Fix memory leak in setup_clusters() error
 path
Message-ID: <aQN3BhYtgW3VUD1L@yjaykim-PowerEdge-T330>
References: <20251029085659.2005942-1-youngjun.park@lge.com>
 <20251029085659.2005942-2-youngjun.park@lge.com>
 <CAMgjq7BiQ2X5K+Ri+wk2J+QdcfwfDGKjT7WXC1_6b2myFGrXaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7BiQ2X5K+Ri+wk2J+QdcfwfDGKjT7WXC1_6b2myFGrXaA@mail.gmail.com>
X-Stat-Signature: j7wptqwskekb4bg16thdhwwmpa31reww
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6DAF91C0017
X-HE-Tag: 1761834762-131133
X-HE-Meta: U2FsdGVkX1/5xdgdHTWuqabSMJPPXoiRS05TvoRN+Cek0KSSXPX2bZUI+sD41URg6x38wCwF9msFBlnpBkYfXk1MeLFhLXoNzLXmlSlRPYAZ1KxxnXHishTzQDVYRymOLr1cc4QoUd1uDw8JsrCHW1GPFYom6fzQA9YVyQ4v6Fv4BBAaGB7y23JvbfNlo/+EREt9HZwdEug/v1aIPIEJDlUGcyZrjs1231UnDBn3qGkA7GlDsS7SYMIBsKg1pX6stL2yP+UyIpL/VRcdAGKlLQeVViYbhEDYzAH2KQ4IsBaUdu7MW0EF4G2F313AWZ/OsU+78MpebYTZr3PbUBZMFQlE7Co9hr1BCBiXT2oRbpO0NQH+vY7dq4R+SKQAJcZ6La6vlLrzulbjpmdfjYG13L6mFSSUBiSTknWhiU/TPrnu3fjfjUMeh9Gn/zVhy9aRAVy8k9up1/NxgzcBaykzy4XwoKdzwldsBubXAs3cdvuuVJEoMIwXuFXG5Y6Mv8yrPbwdO8WA0NbE1ocwQRwJVtvEpleEnQPaOxqATJhLkqRoUelZ00ZZC/MbOkcIZ0oskOml1dVqJaC49TYTmUE8vnI9SU4kRVF9QNmCycwLOiHMuv68v4r2ekwrb55SfZP2SoUeZJP/i2tgr5uT8W90y/neyC0/Sp5mIHC5s3BtIPIV6th1h/GovSlJxok5T77v3mWsHTkmeUSNS3kAnP5/kMQxYSTd/nk3ZDgSJ5rQxjtIpg2CENRDs4piKaYmuNlY9Xrm7KxpfYHvH2w14yH4INwjV90+78uCPkOs5kEppYEh5BC9wE6FRUMZ+snPFmwPOrJf/eJTjEIV5ZycU3O0uECDnGto2oFFi0wZxWFLSeMvWk5wpk1Jj4NLLC5kIZHqFVJ9Iz/rrdCvnjjNaG139UbzAIgx73uwfzXZmE9Xh8hxtbCaggZK0QyyMS9Tc9jvyRKDY8M74k400fY629c
 JT1GNC9q
 1A96jbh1/WhosuqB3aoCkYEdM7tAPEXeDF+Z9d8VCv69We2gKyvXJfFLyhntNKY0ZgoWFQe2ZTBvLrwedSloI1ycl2BMYzz3f69GNEsmmQSC0AK95cVKXV325Koemx5Yr1Zb0SfrNYeEwr6qI8QLSfYHRQaxJXrp5kuRK97XAloDmE6bBCFh4dqwnuqoBA0mBDGyiq5eGJ1VZITmwOcGredktqtFJ3Vw60/cTOUYVkkGzWhFHOKEDgzhjEXW68rqeI9X/++V+HPnqwxRQ7t1PUw8fMFNxv2bRqXJx8sk3Y/cQeWLw2cKvKUqgOGhigeW+8tlFyLk+ygXa2tw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 11:41:27PM +0800, Kairui Song wrote:
> On Wed, Oct 29, 2025 at 8:44 PM Youngjun Park <youngjun.park@lge.com> wrote:
> >
> > Some error path neglects to free the allocated 'cluster_info',
> > causing a memory leak.
> >
> > Change the error jumps to the 'err_free' label to ensure proper
> > cleanup.
> >
> > Fixes: 07adc4cf1ecd ("mm, swap: implement dynamic allocation of swap table")
> > Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> > ---
> >  mm/swapfile.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index c35bb8593f50..6dc0e7a738bc 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -3339,7 +3339,7 @@ static struct swap_cluster_info *setup_clusters(struct swap_info_struct *si,
> >          */
> >         err = swap_cluster_setup_bad_slot(cluster_info, 0);
> >         if (err)
> > -               goto err;
> > +               goto err_free;
> >         for (i = 0; i < swap_header->info.nr_badpages; i++) {
> >                 unsigned int page_nr = swap_header->info.badpages[i];
> >
> > @@ -3347,12 +3347,12 @@ static struct swap_cluster_info *setup_clusters(struct swap_info_struct *si,
> >                         continue;
> >                 err = swap_cluster_setup_bad_slot(cluster_info, page_nr);
> >                 if (err)
> > -                       goto err;
> > +                       goto err_free;
> >         }
> >         for (i = maxpages; i < round_up(maxpages, SWAPFILE_CLUSTER); i++) {
> >                 err = swap_cluster_setup_bad_slot(cluster_info, i);
> >                 if (err)
> > -                       goto err;
> > +                       goto err_free;
> >         }
> >
> >         INIT_LIST_HEAD(&si->free_clusters);
> > --
> > 2.34.1
> >
> >
> 
> Nice catch.

Hello Kairui.

> Maybe it's better to just move free_cluster_info under "err:"? That
> might help to avoid more issues like this. free_cluster_info checks if
> cluster_info is null already, we just need to initialize *cluster_info
> with "= NULL".

You're right - moving free_cluster_info under 'err:' is cleaner. 
I'll update the code accordingly.

Thanks!
Youngjun Park

> Just a nit pick, I'm fine either way.
> 
> Reviewed-by: Kairui Song <kasong@tencent.com>

