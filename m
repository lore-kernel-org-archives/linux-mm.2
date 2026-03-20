Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BF0D1093188
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 08:18:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CD5E6B036C; Fri, 20 Mar 2026 04:18:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A4616B036D; Fri, 20 Mar 2026 04:18:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E11E6B036F; Fri, 20 Mar 2026 04:18:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1FFB16B036C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 04:18:41 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9E9A0BBA92
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 08:18:40 +0000 (UTC)
X-FDA: 84565740000.14.952473B
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf29.hostedemail.com (Postfix) with ESMTP id 79307120010
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 08:18:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773994719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9+my7b/kNn8G0Fz8MY3spPyaX8gEEsNNfj3FQ36adCo=;
	b=fhovGhd30sIhLL7RcgKyLPd5BhFK8/miWbNwTcwdhEKiJJQbzHGzmSMDi24hbm6CWwGeIF
	jtXH82y2Zx+ACL3YYvotxHbd8+S2j0J9VdEHMwD4nNVDwvRoyKEXyzYEF5+RpeXTGYGo8b
	AF2vl+Ec1lV+B/eXAggMshkRo5fePLU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773994719; a=rsa-sha256;
	cv=none;
	b=agn1IocfgxgIEPEEKQt8iUl3CI3owTjEb9H7VVVVw/Zz14AyZo8u4ddHa2VwE6SaWBz2zF
	9qe2ttZoiDtbJL3/IFG0VAixNXNVgyQVmq1UFe40Ia9a4+267mNryKmYpI2KbVgGO0iZS3
	VRAexsu3r4D6y0Qz+0lZCgAC5jD6XTg=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 20 Mar 2026 17:18:34 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Fri, 20 Mar 2026 17:18:34 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	pavel@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, baohua@kernel.org, usama.arif@linux.dev,
	linux-mm@kvack.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v5 3/3] PM: hibernate: fix spurious GFP mask WARNING in
 uswsusp path
Message-ID: <ab0C2gPW0zj2JPf3@yjaykim-PowerEdge-T330>
References: <20260319142404.3683019-1-youngjun.park@lge.com>
 <20260319142404.3683019-4-youngjun.park@lge.com>
 <CAJZ5v0i+KdG1FFTrrpt4fV_DDbY833yDzDs42Me7qmzxfCi73A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJZ5v0i+KdG1FFTrrpt4fV_DDbY833yDzDs42Me7qmzxfCi73A@mail.gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 79307120010
X-Stat-Signature: bdce3stihei5u55essjo1o3cnzubwoze
X-Rspam-User: 
X-HE-Tag: 1773994717-223454
X-HE-Meta: U2FsdGVkX1+dYPHU5p58xF1cJmWXUkeeELAJ6DerFsZ3mO9KiAfu9mT/s7AjSlHQtcjvMK/G2pZ724g1w/PCrofXxTTOEcZkoAMDcJR4sk7VsyHr2zdAntqQY31XYN83UIVD+1aVAgg7KdsA7Bglb+abm7wHreipLlUpjdIOFlhItSUf1zQGdlRWjbWhSTv6Rxn7Vn2eaS+JUm0KyxgtCt/yYr/sP1YSss/HOzrrZa8fcBx51uMxQxdIzYOhdkpsNDBWydGNF3+FaFQjPuWYAtG5KzOrJmiOyYmdf2+ABQrDGfYph76WreDEys5Mob2mNH3POw6DEe50zVPbR8R7hEzEGMO9jhRPSibenE2zs0cRvqP+f+BGSRPTR6T6CAciNKIKfDo4iNQ/bolwYMwgnf/NsRWilhkuYwhECUQeNfIEO8Zck8RkayEV39/2yhsL5KNFL4T/PvnPAhRJpKXib96cqD2wWc2TLodWie1zu/DwcSrQNtfKTx7CYWJ4wbj02fcbUkDgqDij09TNQi2/df8DYE7dc8MmJ1ppuUIYclF89Dz3vwBb9i83I8zsKqbDaHcR6JT20VPX8/dq4hChM+4ALR/HtNfUnIbbZpr1XtTAjS+tAl6nDKvEtRN3iL1EUw4qO5mtVtTOJrQvfMc4FTZ4BT+1RlyD8lXNtZgu9q59TdyijSOFhmTVvbqLVnJeUztbKLGaniKLLz3oEmVuIZWlBGD/5giEgaz+ffOrspV7wiF/ie5ct4ATcVQggAczjJDBu5QGnFLhtXXLUmZhsz7/sGvnVuJNgzfcxxOG2DBjcCxspJyrPNJUENnjzzy5VPVcIqxEjjDDhdzvRMyLy+9okgrlVqnckavrJZrFK8Th8mtUmHYE8M0qjaPuEecY+mJEt2+s06bjXc4cJoUaas2eIw0FU4tJR2mHd+lipNdiM40K0hnPdAT1FWFJaQjwWNS2KvZ9UTUtO92VPpt
 DimsnTY1
 O+gh0LzCf3GE+9lYV2MIPySLbFaKOVan2AH8VeGxLqlMmOtyCznsE4Bhk0oeqFfpk6UvPYq4Xnct2prGt06Qbm+3oJqeCFzMsk5bpUrh/9b+8xmmRDqF4GGrBodS36eEx4/8EGncgVnWTzUd2sqdZNoQ3GN5Yz5EzdL9p64WKKhDAqZNJ+Im92t+Brdhmh0wKNZ+xH6+fImv9AaDeu5J1kl5LFaaX7zYzGagIcCLmdzt73X49IOHvvBCUKuVGrETNTPaFJn5HFsnIGtQtwBaRyR8J/ghwWwH4rquaID7XhAYaUZ8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 08:55:43PM +0100, Rafael J. Wysocki wrote:
> On Thu, Mar 19, 2026 at 3:24 PM Youngjun Park <youngjun.park@lge.com> wrote:
> >
> > Commit 35e4a69b2003f ("PM: sleep: Allow pm_restrict_gfp_mask()
> > stacking") introduced refcount-based GFP mask management that warns
> > when pm_restore_gfp_mask() is called with saved_gfp_count == 0:
> >
> >   WARNING: kernel/power/main.c:44 at pm_restore_gfp_mask+0xd7/0xf0
> >   CPU: 0 UID: 0 PID: 373 Comm: s2disk
> >   Call Trace:
> >    snapshot_ioctl+0x964/0xbd0
> >    __x64_sys_ioctl+0x724/0x1320
> >   ...
> >
> > The uswsusp path calls pm_restore_gfp_mask() defensively in
> > SNAPSHOT_CREATE_IMAGE and SNAPSHOT_UNFREEZE where the GFP mask may
> > or may not be restricted depending on context (first call vs retry,
> > hibernate vs resume). Before the stacking patch this was a silent
> > no-op; now it triggers a WARNING.
> >
> > Introduce pm_restore_gfp_mask_safe() that skips the call when
> > saved_gfp_count is 0. This is preferred over tracking the restrict
> > state in snapshot_ioctl, as incorrect tracking risks leaving the
> > GFP mask permanently restricted.
> >
> > Fixes: 35e4a69b2003f ("PM: sleep: Allow pm_restrict_gfp_mask() stacking")
> > Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> > ---
> >  include/linux/suspend.h | 1 +
> >  kernel/power/main.c     | 7 +++++++
> >  kernel/power/user.c     | 4 ++--
> >  3 files changed, 10 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/linux/suspend.h b/include/linux/suspend.h
> > index b02876f1ae38..7777931d88a5 100644
> > --- a/include/linux/suspend.h
> > +++ b/include/linux/suspend.h
> > @@ -454,6 +454,7 @@ extern void pm_report_hw_sleep_time(u64 t);
> >  extern void pm_report_max_hw_sleep(u64 t);
> >  void pm_restrict_gfp_mask(void);
> >  void pm_restore_gfp_mask(void);
> > +void pm_restore_gfp_mask_safe(void);
> >
> >  #define pm_notifier(fn, pri) {                         \
> >         static struct notifier_block fn##_nb =                  \
> > diff --git a/kernel/power/main.c b/kernel/power/main.c
> > index 5f8c9e12eaec..e610a8c8b7ff 100644
> > --- a/kernel/power/main.c
> > +++ b/kernel/power/main.c
> > @@ -36,6 +36,13 @@
> >  static unsigned int saved_gfp_count;
> >  static gfp_t saved_gfp_mask;
> >
> > +void pm_restore_gfp_mask_safe(void)
> > +{
> > +       if (!saved_gfp_count)
> > +               return;
> > +       pm_restore_gfp_mask();
> > +}
> > +
> >  void pm_restore_gfp_mask(void)
> >  {
> >         WARN_ON(!mutex_is_locked(&system_transition_mutex));
> > diff --git a/kernel/power/user.c b/kernel/power/user.c
> > index 3e41544b99d5..41cff6a89a1c 100644
> > --- a/kernel/power/user.c
> > +++ b/kernel/power/user.c
> > @@ -306,7 +306,7 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
> >         case SNAPSHOT_UNFREEZE:
> >                 if (!data->frozen || data->ready)
> >                         break;
> > -               pm_restore_gfp_mask();
> > +               pm_restore_gfp_mask_safe();
> >                 free_basic_memory_bitmaps();
> >                 data->free_bitmaps = false;
> >                 thaw_processes();
> > @@ -318,7 +318,7 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
> >                         error = -EPERM;
> >                         break;
> >                 }
> > -               pm_restore_gfp_mask();
> > +               pm_restore_gfp_mask_safe();
> >                 error = hibernation_snapshot(data->platform_support);
> >                 if (!error) {
> >                         error = put_user(in_suspend, (int __user *)arg);
> > --
> 
> AFAICS, this patch doesn't depend on the rest of the series, so I can
> apply it separately unless there is a problem with that.
> 
> However, for the other 2 patches in the series, I'd need some tags
> (preferably Reviewed-by) from mm people.
> 
> Thanks!

Hi Rafael,

While double-checking the code based on Andrew’s AI-assisted review,
I noticed I missed one case.

If userspace issues SNAPSHOT_FREEZE and then closes the device,
snapshot_release() may call pm_restore_gfp_mask() without a matching
restriction, which reproduces the same WARN. So we should switch
snapshot_release() to pm_restore_gfp_mask_safe() as well.

Also, since the safe wrapper may return early when saved_gfp_count == 0,
the locking assertion would be skipped in that path. To preserve the
invariant, it is better to keep:

    WARN_ON(!mutex_is_locked(&system_transition_mutex));

in the wrapper too.
This modification is intentional, but after review I think this is better.

I will update the patch and resend.

Best regards,
Youngjun park

