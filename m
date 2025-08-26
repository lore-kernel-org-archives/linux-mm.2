Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70853CA0FF0
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 21:22:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B36B58E010A; Tue, 26 Aug 2025 17:22:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0FCD8E0105; Tue, 26 Aug 2025 17:22:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FD788E010A; Tue, 26 Aug 2025 17:22:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8B7508E0105
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 17:22:23 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3CA151186CA
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 21:22:23 +0000 (UTC)
X-FDA: 83820182166.19.C2B2E16
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf29.hostedemail.com (Postfix) with ESMTP id 62B0B120015
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 21:22:21 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=j5hnS0Iw;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=jiaqiyan@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756243341; a=rsa-sha256;
	cv=none;
	b=YjDRCtqrE+Pf8Yju6fHLHk/m8x5ypmnuvwKftu1oa0Gp69TmGi4Hb7i7ERdPrwjMiKq9BY
	yudKYszbBcUY2uSjEqpEODmo/m0mNJhAcAe/L+E3Qy3aCkOcBEWfI28ShTS+aoycbaL8T7
	Oak6gFZTpl/24trd31RLzThd5DUbkLs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=j5hnS0Iw;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=jiaqiyan@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756243341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9jpPNZ8lISdv+Dhq7ZXaCZZODxLUSaWGXHiRUxlbj5w=;
	b=rkdWm/3pFt7Vvzw5Lp+lZbFpp3FLSzy9nM3CEP/30mk3Ug/KjtGW0P7W6ZLQUZ+LOwkKK+
	ylrcM0105xBxkMig+y9t9ucYdP7VYt/uLpHMtaxRQSEk1eVn6WKxvePZbtQ5Ss2NZnDXHs
	Pnm3wWHM9Qu+LHofe8CDmfuBlkQvYHQ=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-459fc779bc3so7985e9.1
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 14:22:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756243340; x=1756848140; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9jpPNZ8lISdv+Dhq7ZXaCZZODxLUSaWGXHiRUxlbj5w=;
        b=j5hnS0Iw6+3GhKFTpHY8P4OlumSNKky9+Ee0lS9IJy3xJFGrmAjDgOxZtEeqmiBUJ1
         UubRFoD709MedJY8+cea6yOkc72rRDka4zmLiiv2E+FtWYnEhVJWPwgkdQhUkMEgASrq
         0WQwV1twlNqyMgPkPQKkL8DAbAaohm0pCwmBGj4yU6mtID6XFcOOTGWBEQhTwDzJLcsu
         d9HEgmuuLa7CKqiFWQXd1W4T7AjqbRMV9gnF73h10/rV8WrU9poCO5CqUacWS6jNJu/a
         aiSpYXS9fUTI/le8eKoXpDrD1nvWsTDJbnFMTm7Gmhsyel9wFI1Gbx9a9pd2pKuG/91h
         SI8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756243340; x=1756848140;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9jpPNZ8lISdv+Dhq7ZXaCZZODxLUSaWGXHiRUxlbj5w=;
        b=V0xUs2dCNnImRmdez2cEUAKpa4lfDSKhCiI+dyI5M27H5/WdOD4RK2qwUBoCGksnP6
         cUbNX97miT8+ECDnDQlrnrRe2YPLTx3OJ8fc6wxlleFg3MMdM6UoHIW6g8z5G4keLwH7
         95e/KvRxmAC/VzVvNKbnHorDlKeuvMP7d+vasUZyhplz/Eul3UTNybSGsxANYRC+VbSc
         L2/lErexv54EIyDLeZPc15fv/OZD36wb5/wH61U9nNV1gAG5SvZ1YqyRE2G4FYHlpsE6
         uawu83+QvyQKuCWyLUOuyxYpqx4VygEaGFASfb2SALQ1z0RALpEJNi9IQPZHFfSCk7g4
         2ctg==
X-Forwarded-Encrypted: i=1; AJvYcCWpTjd4OHCm8fCbgmAqo0RPnnFcSz89UniLr0WcoKxc5GPTWjMGRtLXMZojKEX1erqwQ8SGq6CA6A==@kvack.org
X-Gm-Message-State: AOJu0YxMj0SNnvZ00186uDH6sJPzZwjzKTP4ByVaBKpAVSZKWbap9iqe
	dIOtZWSfMHj9BTCCMwo+fYEEO1XhSNqBygVVyoZ3VB7Wznm0kSd3TbhzF1org/ypIsj6ze6qhR1
	vam37h9u8dQ9FW/Nlmn225AqOLCpHth0+6GoWQPxa
X-Gm-Gg: ASbGncuqpUC6P9gX4J5eDh+BQjhng0LrkZat/Iud25GPlt6Z9udtZ4kUoUcIJP2dBqX
	QrmRR7dcDVM5Xuv3MAoUB2LDnF5y2+hQwPGn33knvnTRAtHHVCg2KPzEj7lG0u7gLzD9yp90UzJ
	QMbRL6msj3mm1KlepBS6s0bQDHDQaId/AWmY2Af8vnAWSKbgEin8wQaxJe4nGEQiuGl9qBTOMQ9
	oN428vJaFMfLBlMeIS/WtCJCiE8WLCj4UXxpsjUgy9TyFzGB7ArgoQ=
X-Google-Smtp-Source: AGHT+IHWb/iGY2zxWEzy1j1Mu3+I3ku1JITkNvPq6UT+dcJ5yYMgM9SwHqFRIknb827acU4jRh04vE/b7tdVOttHKaM=
X-Received: by 2002:a05:600c:4a28:b0:45b:4acd:836d with SMTP id
 5b1f17b1804b1-45b6697dacdmr1183155e9.5.1756243339304; Tue, 26 Aug 2025
 14:22:19 -0700 (PDT)
MIME-Version: 1.0
References: <20250821164445.14467-1-kyle.meyer@hpe.com> <CACw3F53KmKRJyH+ajicyDUgGbPZT=U3VE4n+Jt3E62BxEiiCGA@mail.gmail.com>
 <aKd1K3ueTacGTf1W@hpe.com> <CACw3F527M-x=UeB0tN_sjCgp_YP_8yLkVRCLP2dLO2bzXrqWsA@mail.gmail.com>
 <14a0dd45-388d-7a32-5ee5-44e60277271a@huawei.com> <aKyKort2opfQYqgA@hpe.com>
 <2bd5c32b-dfc4-4345-8cc8-bbda5acdc596@oracle.com> <aK0UTovxnKfjPwXs@hpe.com>
 <714d066a-a06e-4b49-b66f-68952c6520d9@oracle.com> <aK4Ksy872gR7WuQF@hpe.com>
In-Reply-To: <aK4Ksy872gR7WuQF@hpe.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Tue, 26 Aug 2025 14:22:06 -0700
X-Gm-Features: Ac12FXyZq2QuV8uyQ0XiJC-UJJLJHPA1321axAxYENUGY5wCfC3LnKnzP71Qm40
Message-ID: <CACw3F53dULMH2UZLz8SR2GMuGTmjC-u9Mvomzi61oejeLEn3_Q@mail.gmail.com>
Subject: Re: [PATCH] mm/memory-failure: Do not call action_result() on already
 poisoned pages
To: Kyle Meyer <kyle.meyer@hpe.com>, jane.chu@oracle.com, 
	Miaohe Lin <linmiaohe@huawei.com>, russ.anderson@hpe.com
Cc: akpm@linux-foundation.org, david@redhat.com, tony.luck@intel.com, 
	bp@alien8.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-edac@vger.kernel.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, nao.horiguchi@gmail.com, osalvador@suse.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 62B0B120015
X-Stat-Signature: 6ue5bmkqe1k5wzzpsh6stabgowdqtwx9
X-HE-Tag: 1756243341-621580
X-HE-Meta: U2FsdGVkX18A7GeNkGyLFRTtZE2PUOrtHtqB98vJ5ihKw1Zn+XSRAmlRe7OVwy4WM51vpowxdF6Y6MYof+ZUKnNvExJoZl36hxmT4JhGgKgJ22b2o+QYrMoIal/T5sPjX7aeVbdMlMJkjEgO67Pba3SKxNHytPJgEDNxU9C4Ek+ETgknHsKRArghLKm4qMIOe23KaAEpmsgQsHaIEMQePnmEA1FSb07nAQohNUta5/oimby+CCyQ/IiWGtNdZuDpBgqiXZ94Dk9NzeGBOC4R43p0u4+3NU8pD8UiQrEIjhs50aTc6gxCJGTcGGXAMv6rU1/NReRfxiUeCjNNNJGOI7KGUITIZXWLcd+MEJ6/RKE66hDvP22SRTBXkopLc5wVGQszaecd7zqcO+yOImnI8BKNQZ9rKtUEYA/2qiawDUIzpPwSr22JSwnb5TjPPSPQO1k2afgg7LtNfKrKG0VN9TLeRHc9RGtLQs6OK33vpOe7n+l0rGFb2+/fjvbgSlncnDJQfQGCA5aKZ/4puhUMo//iRth4f/IetqTsvs7tHvzLTa+UYP51GgGbi63QKrfMYEEbQjxN0WL8eW5Qa+GHFYVCJ1Wl/dlIop28J7Jfh4vL/8mfJIV8PQr0/DWcsL3G4QV0YfIhdCyY02OKP/vWWyj2wjBIWH5M5StkIWoulRYG+PshqVT0NFpV2bzbwiFXsNe98+mOq3VZPhKXDK/q6veQTFPxoK7xF/wnKLOKNenZgas25DmWsPOUbsYJhPcQHe+xOgM4JsoENH3h7mwRR+gWVMyNq4ecVBvUlkH47JU+6O0pMtAjnQKy0+tdZbpD8Y10fzYONxm0K6PF90U/bolrofXCPJ4yUYzABlmnhymp+JLcQIiyEz14dLGEPsR9fKrP00CwfpPm1MnZ8eLshXFkFsfZUZ81ckRPeIR3DyiPXllPqLB/9Ath9vRlFe/21rT1woZviBUTuFRywtp
 Jjk5ueFc
 g66ZvzVjuyZGpKoA9MfETjlQ7cTMX37bHW7qV9Drxka8cTvvzNO2Nb5MZvw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 12:28=E2=80=AFPM Kyle Meyer <kyle.meyer@hpe.com> wr=
ote:
>
> On Tue, Aug 26, 2025 at 10:24:07AM -0700, jane.chu@oracle.com wrote:
> >
> > On 8/25/2025 6:56 PM, Kyle Meyer wrote:
> > > On Mon, Aug 25, 2025 at 03:36:54PM -0700, jane.chu@oracle.com wrote:
> > > > On 8/25/2025 9:09 AM, Kyle Meyer wrote:
> > > > > On Mon, Aug 25, 2025 at 11:04:43AM +0800, Miaohe Lin wrote:
> > > > > > On 2025/8/22 8:24, Jiaqi Yan wrote:
> > > > > > > On Thu, Aug 21, 2025 at 12:36=E2=80=AFPM Kyle Meyer <kyle.mey=
er@hpe.com> wrote:
> > > > > > > >
> > > > > > > > On Thu, Aug 21, 2025 at 11:23:48AM -0700, Jiaqi Yan wrote:
> > > > > > > > > On Thu, Aug 21, 2025 at 9:46=E2=80=AFAM Kyle Meyer <kyle.=
meyer@hpe.com> wrote:
> > > > > > > > > >
> > > > > > > > > > Calling action_result() on already poisoned pages cause=
s issues:
> > > > > > > > > >
> > > > > > > > > > * The amount of hardware corrupted memory is incorrectl=
y incremented.
> > > > > > > > > > * NUMA node memory failure statistics are incorrectly u=
pdated.
> > > > > > > > > > * Redundant "already poisoned" messages are printed.
> > > >
> > > > Assuming this means that the numbers reported from
> > > >    /sys/devices/system/node/node*/memory_failure/*
> > > > do not match certain expectation, right?
> > > >
> > > > If so, could you clarify what is the expectation?
> > >
> > > Sure, and please let me know if I'm mistaken.
> > >
> > > Here's the description of total:
> > >
> > > What:               /sys/devices/system/node/nodeX/memory_failure/tot=
al
> > > Date:               January 2023
> > > Contact:    Jiaqi Yan <jiaqiyan@google.com>
> > > Description:
> > >             The total number of raw poisoned pages (pages containing
> > >             corrupted data due to memory errors) on a NUMA node.
> > >
> > > That should emit the number of poisoned pages on NUMA node X. That's
> > > incremented each time update_per_node_mf_stats() is called.
> > >
> > > Here's the description of failed:
> > >
> > > What:               /sys/devices/system/node/nodeX/memory_failure/fai=
led
> > > Date:               January 2023
> > > Contact:    Jiaqi Yan <jiaqiyan@google.com>
> > > Description:
> > >             Of the raw poisoned pages on a NUMA node, how many pages =
are
> > >             failed by memory error recovery attempt. This usually mea=
ns
> > >             a key recovery operation failed.
> > >
> > > That should emit the number of poisoned pages on NUMA node X that cou=
ld
> > > not be recovered because the attempt failed. That's incremented each =
time
> > > update_per_node_mf_stats() is called with MF_FAILED.
> > >
> > > We're currently calling action_result() with MF_FAILED each time we e=
ncounter
> > > a poisoned page (note: the huge page path is a bit different, we only=
 call
> > > action_result() with MF_FAILED when MF_ACTION_REQUIRED is set). That,=
 IMO,
> > > breaks the descriptions. We already incremented the per NUMA node MF =
statistics
> > > to account for that poisoned page.
> >
> > Thanks!  My reading is that these numbers are best as hints, I won't ta=
ke
> > them literately.  As you alluded below, kill_accessing_process is appli=
ed
> > only if MF_ACTION_REQUIRED is set, though the page is already marked
> > poisoned.  Besides, there can be bug that renders a poisoned page not b=
eing
> > properly isolated nor being properly categorized.  If you're looking fo=
r
> > something precise, is there another way? maybe from firmware?
>
> Firmware records the number of memory errors that have been detected and
> reported, but it doesn't record how Linux responded to those memory error=
s.
>
> Checking the ring buffer, the amount of hardware corrupted memory, and th=
e
> per NUMA node memory failure statistics is a simple way to determine how =
Linux
> responded.
>
> Since commit b8b9488d50b7, that has become unreliable. The same memory er=
ror
> may be reported by multiple sources and now each report increments the am=
ount of

To me this multiple counting is an existing issue, and what Kyle
originally targeted. It seems to me that as long as the
mf_action_page_type is MF_MSG_ALREADY_POISONED (or HWPoison flag is
set), action_result shouldn't invoke statistic related ops, and
mf_results just become irrelevant (wrt
/sys/devices/system/node/nodeX/memory_failure/*), right? IWO, we can
decouple the two issues:
1. how to update statistics correctly?
2. what log msg to show for recovery result, MF_FAILED or something else/ne=
w?

While Kyle fixing issue #1, can we just keep MF_FAILED as is?

> hardware corrupted memory and the per NUMA node memory failure statistics=
. Isn't
> that a regression?
>
> The per NUMA node memory failure statistics might not always be 100% accu=
rate,
> but this issue seems preventable.
>
> > > > > > > > >
> > > > > > > > > All agreed.
> > > > > > > > >
> > > > > > > > > >
> > > > > > > > > > Do not call action_result() on already poisoned pages a=
nd drop unused
> > > > > > > > > > MF_MSG_ALREADY_POISONED.
> > > > > > > > >
> > > > > > > > > Hi Kyle,
> > > > > > > > >
> > > > > > > > > Patch looks great to me, just one thought...
> > > > > >
> > > > > > Thanks both.
> > > > > >
> > > > > > > > >
> > > > > > > > > Alternatively, have you thought about keeping MF_MSG_ALRE=
ADY_POISONED
> > > > > > > > > but changing action_result for MF_MSG_ALREADY_POISONED?
> > > > > > > > > - don't num_poisoned_pages_inc(pfn)
> > > > > > > > > - don't update_per_node_mf_stats(pfn, result)
> > > > > > > > > - still pr_err("%#lx: recovery action for %s: %s\n", ...)
> > > > > > > > > - meanwhile remove "pr_err("%#lx: already hardware poison=
ed\n", pfn)"
> > > > > > > > > in memory_failure and try_memory_failure_hugetlb
> > > > > > > >
> > > > > > > > I did consider that approach but I was concerned about pass=
ing
> > > > > > > > MF_MSG_ALREADY_POISONED to action_result() with MF_FAILED. =
The message is a
> > > > > > > > bit misleading.
> > > > > > >
> > > > > > > Based on my reading the documentation for MF_* in static cons=
t char
> > > > > > > *action_name[]...
> > > > > > >
> > > > > > > Yeah, for file mapped pages, kernel may not have hole-punched=
 or
> > > > > > > truncated it from the file mapping (shmem and hugetlbfs for e=
xample)
> > > > > > > but that still considered as MF_RECOVERED, so touching a page=
 with
> > > > > > > HWPoison flag doesn't mean that page was failed to be recover=
ed
> > > > > > > previously.
> > > > > > >
> > > > > > > For pages intended to be taken out of the buddy system, touch=
ing a
> > > > > > > page with HWPoison flag does imply it isn't isolated and henc=
e
> > > > > > > MF_FAILED.
> > > > > >
> > > > > > There should be other cases that memory_failure failed to isola=
te the
> > > > > > hwpoisoned pages at first time due to various reasons.
> > > > > >
> > > > > > >
> > > > > > > In summary, seeing the HWPoison flag again doesn't necessaril=
y
> > > > > > > indicate what the recovery result was previously; it only ind=
icate
> > > > > > > kernel won't re-attempt to recover?
> > > > > >
> > > > > > Yes, kernel won't re-attempt to or just cannot recover.
> > > > > >
> > > > > > >
> > > > > > > >
> > > > > > > > How about introducing a new MF action result? Maybe MF_NONE=
? The message could
> > > > > > > > look something like:
> > > > > > >
> > > > > > > Adding MF_NONE sounds fine to me, as long as we correctly doc=
ument its
> > > > > > > meaning, which can be subtle.
> > > > > >
> > > > > > Adding a new MF action result sounds good to me. But IMHO MF_NO=
NE might not be that suitable
> > > > > > as kill_accessing_process might be called to kill proc in this =
case, so it's not "NONE".
> > > > >
> > > > > OK, would you like a separate MF action result for each case? May=
be
> > > > > MF_ALREADY_POISONED and MF_ALREADY_POISONED_KILLED?
> > > > >
> > > > > MF_ALREADY_POISONED can be the default and MF_ALREADY_POISONED_KI=
LLED can be
> > > > > used when kill_accessing_process() returns -EHWPOISON.
> > > > >
> > > > > The log messages could look like...
> > > > >
> > > > > Memory failure: 0xXXXXXXXX: recovery action for already poisoned =
page: None
> > > > >         and
> > > > > Memory failure: 0xXXXXXXXX: recovery action for already poisoned =
page: Process killed
> > > >
> > > > Agreed with Miaohe that "None" won't work.
> > >
> > > What action is M-F() taking to recover already poisoned pages that do=
n't have
> > > MF_ACTION_REQUIRED set?
> >
> > The action taken toward poisoned page not under MF_ACTION_REQUIRED is
> > typically isolation, that is, remove the pte or mark the pte as poisone=
d
> > special swap entry, so that subsequent page fault is given a chance to
> > deliver a SIGBUS. That said, things might fail during the process, like
> > encountering GUP pinned THP page.>
> > > > "Process killed" sounds okay for MF_MSG_ALREADY_POISONED, but
> > > > we need to understand why "Failed" doesn't work for your usecase.
> > > > "Failed" means process is killed but page is not successfully isola=
ted which
> > > > applies to MF_MSG_ALREADY_POISONED case as well.
> > >
> > > So that accessing process is killed. Why call action_result() with MF=
_FAILED?
> > > Doesn't that indicate we poisoned another page and the recovery attem=
pt failed?
> >
> > What I recall is that, "recovery" is reserved for page that is clean,
> > isolated, and even by chance, unmapped.  "failed" is reserved for page =
that
> > has been(or might not?) removed from the page table, page might be dirt=
y,
> > certainly mapped, etc. A SIGBUS doesn't make recovery an automatic succ=
ess.
> >
> > Others please correct me if I'm mistaken.
>
> Thank you very much for taking the time to explain everything.
>
> Thanks,
> Kyle Meyer

