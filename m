Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACE961099B33
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 18:20:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF3C26B00FD; Fri, 20 Mar 2026 14:20:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA41F6B00FE; Fri, 20 Mar 2026 14:20:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D93746B00FF; Fri, 20 Mar 2026 14:20:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C49DE6B00FD
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:20:39 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5345814032C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:20:39 +0000 (UTC)
X-FDA: 84567256998.23.3C0937E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 74D8A140009
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:20:37 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qVMqG1mC;
	spf=pass (imf26.hostedemail.com: domain of rafael@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rafael@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774030837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yiczHS10H+pmcmPNvctJQGu/Q2TRPPG25Vl7gUjSRes=;
	b=ZNQDZ8TZn18N064Dm2Gq18xzx7MvgGwmRMjEoAIPssD6hrG+THrKOKMw6PWOALrn0+twOO
	n2a1hQmNhN1e20cI5/0SsYnHYPm3vjMLNOC0IvwFhsLxolSN5uODJ7TXmjF37NRnFPmF9g
	NxIo/QW0sAvtuQ/DmU3RIiPcqMp72IY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qVMqG1mC;
	spf=pass (imf26.hostedemail.com: domain of rafael@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rafael@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774030837; a=rsa-sha256;
	cv=none;
	b=4tm4Z8owhgpPIeHLX75rqlis3358zW5mawYwy+awIBxukpcnlhrPDmIf3gf9puQpx5HwGp
	CCwQ5fJQ1u5An2ya/g76ot3tZUAdJ8rafzB0Lg2wVDoFNJVuYuWqrIoXYkuYdEmezZ2OOA
	jts1C1nNJ7T2Gn/AKSaKbawkoLabDno=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BF39C60141
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:20:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CAA6C2BCB2
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774030836;
	bh=/2FmF1+s9+JnUik8tx08R8i2DCSkv7HYbO/lzTxtn9o=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=qVMqG1mCerSIzYCTuYFicWV18EMmjuYGgjXj1gFLkmqNKhYmfOpzbDvL8pk4lKZEo
	 t+sgjiQUYKtMSaFZ9JDu4IITHwDFHMGbKYwlSyNR8qurIyTp/nGn+kN03BKKq1jKtY
	 Ow0Dnsf+ZxbAZIovTbiewSShLyruuRfdF49MqnA1vFjkYHF4xBbTak1UlUMgQZlgHL
	 nZ6kKk1DkqCbNAMcZhzQuq+L6PONmDUntUiqS0PN4cZnk7C2+Oirj+nYlPhIxwqXvD
	 CXwU/Fiqjk+Fw43KTnMzUK1y/W7myHVvCs016y4us934SnGaaY66ExLNlHOmhICOCT
	 Kz6jZa5lMCsQg==
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-4670bcc40d7so758546b6e.2
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:20:36 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXObo4odPQGj9kL2y2FcuhUbAZPpaDYPHv2E6IQQLtepsyJuPJK/o2zxrWHucO+xW3CwmsKGxTqmg==@kvack.org
X-Gm-Message-State: AOJu0YxoxkxJVUZz45O591WspSCcuNjzmZy3DIDUJxsp8/lZrH6NQ5CF
	4c+AL5YatS9Vh39Kn++hug/vTldcXTx7g93QvTww2ic3PEgxeMsGQSMr6rDAa//ajknQSk/+2Ei
	Z48BnzZB3lQOX2wdkFoY+0i2aREDouVI=
X-Received: by 2002:a05:6808:1645:b0:462:dc57:f8ba with SMTP id
 5614622812f47-467e5f095d0mr2208888b6e.27.1774030835503; Fri, 20 Mar 2026
 11:20:35 -0700 (PDT)
MIME-Version: 1.0
References: <20260320170313.163386-1-youngjun.park@lge.com> <20260320170313.163386-4-youngjun.park@lge.com>
In-Reply-To: <20260320170313.163386-4-youngjun.park@lge.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Fri, 20 Mar 2026 19:20:24 +0100
X-Gmail-Original-Message-ID: <CAJZ5v0gHTPCkVySAuPBkPoV=SwmBRG_c-TtPbz0CNsUUPEkY8w@mail.gmail.com>
X-Gm-Features: AaiRm51AjAgtOUbYQswu1KWiSaj81rVMqfYBli5jqjANmDWpKKnCsKuexQlpqPY
Message-ID: <CAJZ5v0gHTPCkVySAuPBkPoV=SwmBRG_c-TtPbz0CNsUUPEkY8w@mail.gmail.com>
Subject: Re: [PATCH v6 3/3] PM: hibernate: fix spurious GFP mask WARNING in
 uswsusp path
To: Youngjun Park <youngjun.park@lge.com>
Cc: rafael@kernel.org, akpm@linux-foundation.org, chrisl@kernel.org, 
	kasong@tencent.com, pavel@kernel.org, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org, usama.arif@linux.dev, 
	linux-pm@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 74D8A140009
X-Rspamd-Server: rspam07
X-Stat-Signature: uyqynchsk6pnadkgr3gcqauktp6ekfj7
X-Rspam-User: 
X-HE-Tag: 1774030837-633438
X-HE-Meta: U2FsdGVkX190O8XbiBC+RTA0kcohH5PUsBnsjsZavzLwro0PO62fNnvLFDvBwhdxVlbsmHrOhGHUN9n29bO+cvt7YpAO2nOmo5Gqx4EyvMQnbarDYNFbjVk7z4pO4+0GDhm5L4+/GxzPO5Qua8Mv52ZBCN7MlMWDhqARWmGMTQDyive3d+Wiq01Eps+F+cLsuN+I8c6Cz/CIE8ivYwmWtDlCWxse083ecfPICHhTDhG4MJBwjUs55wgDrJM36lADhFWJC7qQXT4XdOKFPw/etkhFXUgIdykuBHRy217JmoAVpzIcysrv3XgjcXAPCsAVT0mknZR51FmVfkgv2Pno5cd3kiV0o2irQbLyYSPKg+oSEtanSDlu3ppKF8SodO+IV4l/72qUAVn5YcwlCkZ36xiBDIGHTkJy4qWR3X3VkLTac0qahSUkWcwvtcs9NVv9gKDEHoVLE6YK+VJLTDtZP8iCmMQeK3yeXeWs6xojGIdxYP+pHIC00AogN4SMTOLSZfnaHDeoAvkZj5F7q5gW9xxcBP7JvI+tly7lLvdAjJ6qtRcqTiau5lpVXjrdK7J0jrPPdwRwM2uUT7AZeRsJ6xSGcJ9GfuB/f+pJzP7UMrqFIPV7k1+Gntnp2KsWNjAozo6kxdwYHs3MumtUieW1fTzt34msIsCRtmm+AYNElPn8EeQfYO1IFgarg5ydlMVhVIfjKANrZRdKrGsZf5txDZZvDVrJBw7rxmuoIpb5Dzx/9BIlvz+yq7An5PdrswlmGHQBYKDLb1MmdEzqVBb2kjrxeVGBeDQFSvMzsPayurfgPe6qfGVQM39e/qhHC/jLsZ+CXBS8/nYvLi6pM9Rhjacj3yGXdElzaZpY8AfMIC31DSTHnSjGHwinsKIGKspMONtTTQTJYLSEKPYCdkWjT3fYVrcBgbZhVBLHpTPyeJV44s4gwONA9j2xz/3cuQKG6Zq6w7i55zwRIXm4wlV
 T5NUU1lD
 GDueu+qLV24wdSlZN45V7FWhf72S1A3GevGtSDOYrykDZQmiwutx6+AUGn7Zeo6167wAJIKaN+mllRzDrb7h/mo6Q5QHZDJ0HG16+A304gJiJVTaVJcV7N9DjqucDyWjRYYS1u30yr2eV2nM9Ra5byxc8lBa0vL5M3phi4CO6Zpkp634hkfE8Ct1wbsLMGiB8/pWKBbIcQ9+xD0MO7m4LcyU42rCrugmZNGt2HPu3PblDTY7v6TIw2kBoiM5632HbDFcpDPq+wN351ZwSoSFJN8+GsndnnrjotT9psBPQJ+B5y5kB50pMBDFrAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Again, this patch does not appear to depend on the rest of the series,
in which case there's no need to send the other patches along with it.

Please send the next version separately unless there is a dependency
on the other two patches, but in that case that dependency should be
explained in the changelog.

On Fri, Mar 20, 2026 at 6:03=E2=80=AFPM Youngjun Park <youngjun.park@lge.co=
m> wrote:
>
> Commit 35e4a69b2003f ("PM: sleep: Allow pm_restrict_gfp_mask()
> stacking") introduced refcount-based GFP mask management that warns
> when pm_restore_gfp_mask() is called with saved_gfp_count =3D=3D 0:
>
>   WARNING: kernel/power/main.c:44 at pm_restore_gfp_mask+0xd7/0xf0
>   CPU: 0 UID: 0 PID: 373 Comm: s2disk
>   Call Trace:
>    snapshot_ioctl+0x964/0xbd0
>    __x64_sys_ioctl+0x724/0x1320
>   ...
>
> The uswsusp path calls pm_restore_gfp_mask() defensively in
> SNAPSHOT_CREATE_IMAGE, SNAPSHOT_UNFREEZE, and snapshot_release(),
> where the GFP mask may or may not be restricted depending on the
> execution path.
>
> Before the stacking change this was a silent no-op; it now triggers
> a WARNING when saved_gfp_count is 0.
>
> Introduce pm_restore_gfp_mask_safe(), which skips the call if

It would be better to call this pm_restore_gfp_mask_nowarn() IMV.

> saved_gfp_count is 0. This avoids the warning without requiring
> state tracking in snapshot_ioctl, which could otherwise leave the
> GFP mask permanently restricted if mismanaged.
>
> Fixes: 35e4a69b2003f ("PM: sleep: Allow pm_restrict_gfp_mask() stacking")
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> ---
>  include/linux/suspend.h |  1 +
>  kernel/power/main.c     | 18 ++++++++++++++++++
>  kernel/power/user.c     |  6 +++---
>  3 files changed, 22 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/suspend.h b/include/linux/suspend.h
> index b02876f1ae38..7777931d88a5 100644
> --- a/include/linux/suspend.h
> +++ b/include/linux/suspend.h
> @@ -454,6 +454,7 @@ extern void pm_report_hw_sleep_time(u64 t);
>  extern void pm_report_max_hw_sleep(u64 t);
>  void pm_restrict_gfp_mask(void);
>  void pm_restore_gfp_mask(void);
> +void pm_restore_gfp_mask_safe(void);
>
>  #define pm_notifier(fn, pri) {                         \
>         static struct notifier_block fn##_nb =3D                  \
> diff --git a/kernel/power/main.c b/kernel/power/main.c
> index 5f8c9e12eaec..90e9bd56a433 100644
> --- a/kernel/power/main.c
> +++ b/kernel/power/main.c
> @@ -36,6 +36,24 @@
>  static unsigned int saved_gfp_count;
>  static gfp_t saved_gfp_mask;
>
> +/**
> + * pm_restore_gfp_mask_safe - Conditionally restore the GFP mask
> + *
> + * Call pm_restore_gfp_mask() only if a GFP restriction is active.
> + *
> + * After GFP mask stacking was introduced, calling
> + * pm_restore_gfp_mask() without a matching restriction triggers a
> + * warning. Some hibernation paths invoke restore defensively, so this
> + * helper avoids spurious warnings when no restriction is in place.
> + */
> +void pm_restore_gfp_mask_safe(void)
> +{
> +       WARN_ON(!mutex_is_locked(&system_transition_mutex));

Could this be changed to lockdep_assert_held()?

> +       if (!saved_gfp_count)
> +               return;

Please add an empty line here.

> +       pm_restore_gfp_mask();
> +}
> +
>  void pm_restore_gfp_mask(void)
>  {
>         WARN_ON(!mutex_is_locked(&system_transition_mutex));
> diff --git a/kernel/power/user.c b/kernel/power/user.c
> index aab9aece1009..88de4b76a9dc 100644
> --- a/kernel/power/user.c
> +++ b/kernel/power/user.c
> @@ -119,7 +119,7 @@ static int snapshot_release(struct inode *inode, stru=
ct file *filp)
>         free_all_swap_pages(data->swap);
>         unpin_hibernation_swap_type(data->swap);
>         if (data->frozen) {
> -               pm_restore_gfp_mask();
> +               pm_restore_gfp_mask_safe();
>                 free_basic_memory_bitmaps();
>                 thaw_processes();
>         } else if (data->free_bitmaps) {
> @@ -306,7 +306,7 @@ static long snapshot_ioctl(struct file *filp, unsigne=
d int cmd,
>         case SNAPSHOT_UNFREEZE:
>                 if (!data->frozen || data->ready)
>                         break;
> -               pm_restore_gfp_mask();
> +               pm_restore_gfp_mask_safe();
>                 free_basic_memory_bitmaps();
>                 data->free_bitmaps =3D false;
>                 thaw_processes();
> @@ -318,7 +318,7 @@ static long snapshot_ioctl(struct file *filp, unsigne=
d int cmd,
>                         error =3D -EPERM;
>                         break;
>                 }
> -               pm_restore_gfp_mask();
> +               pm_restore_gfp_mask_safe();
>                 error =3D hibernation_snapshot(data->platform_support);
>                 if (!error) {
>                         error =3D put_user(in_suspend, (int __user *)arg)=
;
> --

