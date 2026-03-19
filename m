Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDE601091912
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 19:55:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D56946B0537; Thu, 19 Mar 2026 15:55:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D06E36B0538; Thu, 19 Mar 2026 15:55:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1CD16B0539; Thu, 19 Mar 2026 15:55:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B090C6B0537
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:55:58 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5D54C13B85E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 19:55:58 +0000 (UTC)
X-FDA: 84563868396.27.8AE37C1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5CA182000B
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 19:55:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d5mNuGPz;
	spf=pass (imf13.hostedemail.com: domain of rafael@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rafael@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773950156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AhGru4UQJ41C7ujoWKs071OlKr3sy0e7FlvLA7OSKM0=;
	b=cEHoxkbhIdrd+12SRmgU43sFz0K8LxVEyAOaaT3tGgzSFYmThNOG1JtzkPmgPrRMJu+qDt
	L4bBF9P89uQR96ebHG2MMh6oRrBKd32Begt86Zy6Iy/YF7pLuSGOKUzI4qyr72XGWrVwxR
	9RTT/4qh0NCgECMU8V23OYow5JUq7Qg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d5mNuGPz;
	spf=pass (imf13.hostedemail.com: domain of rafael@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rafael@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773950156; a=rsa-sha256;
	cv=none;
	b=Do6kKHbqXFD6SQTYZoSbgjZlwFph1F58++ATelaTuVKzBcbZuWDAEc+HWw2Qa9LlejDoCZ
	1uJA7cCgy4Q2EijTjZl8oDL6Skqvc1NxkFiRZd6CX5t6yvTcwtZGXqsVK4nvzSOGQ2Q/Mc
	U5u1faLjezWG2MA1DGF1gMJaEeqjOSM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 52C60402E3
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 19:55:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C95C2BC87
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 19:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773950155;
	bh=MU2PWkwYa9gjkyC4x9WFjSpsoWEcBVGc5WAJ233S1+c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=d5mNuGPzFTO/HZJ6pqGunNdQBoCAvat+cDGeKNOYOmVLTx8f5g2TV+ff6hF98vUUo
	 zDcyjC5ddaPTwoiHJ7Y5Br1z6G0zH9QF3dqVfh7pV8cF078zrFBL5L0XR6hVvJNDC0
	 645VIMqExMUSekcP03aO8mK5wivjgvp3MpDrBZJ38F5ghPJn2jWSqvSLX4cJ9CpKzB
	 NlnTo9t0+n1fkX841+WJorYRIzBtWVmJpsply2YGjzUpqKgSDdco35rZnGO+4RZB0Q
	 cmj2ICU7JAjRf/kzHNwMZzSWwrM/XgbdL41EmWNABH1mnvTvd6zOr9hTpC5fsXsYvi
	 RWg36X7gtSF2g==
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-41bfec86420so201262fac.1
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 12:55:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWCcK+CpK2o3q9qCkmk0F2yIDPXOjhFtPPSjJQozYzmRErIgRuRBV4KgzdiP6i0G039IlbDNNlFuQ==@kvack.org
X-Gm-Message-State: AOJu0Yx1ia8mCArWvpJWxuro7s7sWOWBklgxkf4Ehk4mKQuc6pzCh3G4
	UyqSi9lnkxp3Om+z3m3sAcuLrXeG7550eVi21KRbk3AsqrZsyLylMANchwvgUU7/7xVtQrF9geW
	ONCLi1wbUDls4fKZGDapP+DX5M9d2HK4=
X-Received: by 2002:a05:6871:8909:b0:3ec:a08c:9707 with SMTP id
 586e51a60fabf-41c1147f350mr331245fac.42.1773950154297; Thu, 19 Mar 2026
 12:55:54 -0700 (PDT)
MIME-Version: 1.0
References: <20260319142404.3683019-1-youngjun.park@lge.com> <20260319142404.3683019-4-youngjun.park@lge.com>
In-Reply-To: <20260319142404.3683019-4-youngjun.park@lge.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Thu, 19 Mar 2026 20:55:43 +0100
X-Gmail-Original-Message-ID: <CAJZ5v0i+KdG1FFTrrpt4fV_DDbY833yDzDs42Me7qmzxfCi73A@mail.gmail.com>
X-Gm-Features: AaiRm52qe5LG4Isvbu9lBVNG-YYTUoDnvsDwaG5GsrQgc9ibs7NjaQkQKJwUaqs
Message-ID: <CAJZ5v0i+KdG1FFTrrpt4fV_DDbY833yDzDs42Me7qmzxfCi73A@mail.gmail.com>
Subject: Re: [PATCH v5 3/3] PM: hibernate: fix spurious GFP mask WARNING in
 uswsusp path
To: Youngjun Park <youngjun.park@lge.com>
Cc: rafael@kernel.org, akpm@linux-foundation.org, chrisl@kernel.org, 
	kasong@tencent.com, pavel@kernel.org, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org, usama.arif@linux.dev, 
	linux-mm@kvack.org, linux-pm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5CA182000B
X-Rspamd-Server: rspam07
X-Stat-Signature: 5nke39ir577wa6knfeztcd7atxso6pm5
X-Rspam-User: 
X-HE-Tag: 1773950156-311532
X-HE-Meta: U2FsdGVkX19e57R07eNMzRjBXvCSXBzyQ664xWj+ZXY3BtZpuwgHgdGGXbI90JEs7/avM+5wKxjwyv4kiHRt67XOt+E2s+4lDWVRbfl0LxFsxBJNVe0qFu4EQbJ1FC9CF6qG7Ph6e6CcNw4j/DuMsMbkSsgt47CPVbjC/YpR7ak8DM6NX/xrcRfuFOwkvtG3Q/xFkmLJm4/5bPs7wZSUFWo033l0OO/sQhVmvW/sijPxAEPI3sAXBCSGiSYsFo5542E8wIerq281RK/nVhH+i5aOQJUtvOa1ya7RRJOX49IiW75qSeLpEzT07wcJLWvCaji6OFtCPEqW19qL1YUqNzF4cckDntRGcA8iMOkvmzfvKnxrfLyHAbtjCttcfFOTJ99yFitlGNcfzkCltFFwMOQAdEjuuMEHm1n7JM6SODowl1TOvrsHC27BIjO9lc+JrJXWURf8uD0XQITlmRcFfFZFzy+H0OWSw1zVWzS7utBpmZwxPBkkM36VQZEsXaZyXvC2mhq+rr26oSlIOCTyFNLRgMke10RwyfAOld8lSN7I0DDsA79C1HJZO3MJpj3mIy+xVB7WGXRBasDN6sdgjqi08dqqridVCvB3CeXKlRtJWhap766kPBQqhIIdweHApEzctnRuo2EebF649V4shmpVhDdOBguFf/B0Hj4PMW5RFOnIAcMDH3gMrwy5ffm88DqzYYTCsqa5ZLMvVaFZKUtY3ROR8gXkN0sz+MiLHNCXKFybxU6lX13nxoHvovcKzFwKvxmWTM69BGa1TkbSe2pvfwecojmRB1idUOy6x8LndRKwrp5J/W7MQN21PNzMKKPOynZYi9khGc1eZ3KB9Miei7AjpNasqj04eqsMK+EvSE4pSzZECt/n1k/1jLArabw81nC8+9mdXlSIFvjOg23XTOTjuV6jW7jHVX1cWrcYaVcwumRB7GV0xyJK5VdfMmryteYCkezKcvpOoZZ
 UbT1Xf4V
 Lw+zyiUj0HrWYEIVDBwfLiBaCI5pl5LmBRpPPY8gDNmGt9zOpE73JknFc0ErutpZ8LhCY8Du9f6DKa7OwiwmbKem7QBT8ICWGHv9rCfceDkVLh9v3XF8sUU3qHLgrACMyOusKh5RPO/keh3TXY0+KAq+JRT4fKEnf+Wq2OUWYriBEu6loSD4w9lB5/fHm1J+eppXFhoL/0Ir3d8HeMJcmbOHpsW6FA2p6kHUHcpVilC4R9BZL6/5AFSNZrHI7nMzuLjr9z6dyOdMKo7bWLmx7i6f1JZfT1oOAiX04gNSQZ6j+iELu+riOijGuTQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 3:24=E2=80=AFPM Youngjun Park <youngjun.park@lge.co=
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
> SNAPSHOT_CREATE_IMAGE and SNAPSHOT_UNFREEZE where the GFP mask may
> or may not be restricted depending on context (first call vs retry,
> hibernate vs resume). Before the stacking patch this was a silent
> no-op; now it triggers a WARNING.
>
> Introduce pm_restore_gfp_mask_safe() that skips the call when
> saved_gfp_count is 0. This is preferred over tracking the restrict
> state in snapshot_ioctl, as incorrect tracking risks leaving the
> GFP mask permanently restricted.
>
> Fixes: 35e4a69b2003f ("PM: sleep: Allow pm_restrict_gfp_mask() stacking")
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> ---
>  include/linux/suspend.h | 1 +
>  kernel/power/main.c     | 7 +++++++
>  kernel/power/user.c     | 4 ++--
>  3 files changed, 10 insertions(+), 2 deletions(-)
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
> index 5f8c9e12eaec..e610a8c8b7ff 100644
> --- a/kernel/power/main.c
> +++ b/kernel/power/main.c
> @@ -36,6 +36,13 @@
>  static unsigned int saved_gfp_count;
>  static gfp_t saved_gfp_mask;
>
> +void pm_restore_gfp_mask_safe(void)
> +{
> +       if (!saved_gfp_count)
> +               return;
> +       pm_restore_gfp_mask();
> +}
> +
>  void pm_restore_gfp_mask(void)
>  {
>         WARN_ON(!mutex_is_locked(&system_transition_mutex));
> diff --git a/kernel/power/user.c b/kernel/power/user.c
> index 3e41544b99d5..41cff6a89a1c 100644
> --- a/kernel/power/user.c
> +++ b/kernel/power/user.c
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

AFAICS, this patch doesn't depend on the rest of the series, so I can
apply it separately unless there is a problem with that.

However, for the other 2 patches in the series, I'd need some tags
(preferably Reviewed-by) from mm people.

Thanks!

