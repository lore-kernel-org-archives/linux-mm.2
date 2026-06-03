Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02994CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 19:44:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47C8E6B00AF; Wed,  3 Jun 2026 15:44:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42DAD6B00B0; Wed,  3 Jun 2026 15:44:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31C3A6B00B1; Wed,  3 Jun 2026 15:44:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1E3A66B00AF
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:44:12 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C056A1629AA
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 19:44:11 +0000 (UTC)
X-FDA: 84839627502.26.2124B8F
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf28.hostedemail.com (Postfix) with ESMTP id B6DA8C0003
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 19:44:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BOAAzDRb;
	spf=pass (imf28.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780515849;
	b=TxKwrTv1s8uOVInXnOtqKe5wAKCdWTQsPI6mXFc5qws9loz+5xBfFpYYQrw2vVLymcawtZ
	AO7n+9FSzTlGLcDzW+PT9R1aayEYF7nMNTN+Tz+kKs6GyEsJ27O4jBc3mdgOJw+N6mKxZG
	YYJYIo1VPpz25D51NUXsPo9Eq4KK/AI=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BOAAzDRb;
	spf=pass (imf28.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780515849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tKWW5TWS8+vthnq2nfmHnpW8WNnuWHVJr50OUxAWpps=;
	b=8XK/OAM0bY+WDAM30CDNwWM61xtnZ+1GbEIWG7cmnmYDD/GbdVsZMRHCfxmSCKRy1SRAhq
	YovzkWxNfNQCqdVVBrxaqyhagrkjEPE7Qo3lV/0EzTrz2g629TBNu1B78M5H9EDE0H7eRV
	sJfaNGhSXVaYdE7Vo4C1PWcnGV4YATQ=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-5175d339e8bso123561cf.0
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 12:44:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780515849; cv=none;
        d=google.com; s=arc-20240605;
        b=AgxL6mqztsiHRuSibFIbF3CRStN06AwGz11zwnzz1kk+gOT0to0DqhJZIqATPgGnUC
         Pm6rSXxHAO0YLY33xMOEXu0HMZqWhsDuN9tNqe5cTXCdLHzGWEG84ZgZLZ4IAkyPe+IS
         CQOoCLIB3OZvwXQzOoG6gTj6StS70KtyGnCNGgeTeXhozLOtFVTzybPBZzzIu5ZwLOcI
         TQVmxYq0O/ebXtyTym0JEao22cHSTJyAsfgznQJOEsOm3S/weKV00ZFUFbjvozoCrKPo
         4JO6kJDDBTb6nUMtt5EEHcsoPsjXJbIx/xP0+ZZ0tNPMjUVRPkcFWJ7MwWTxsKP+2d/j
         6+uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tKWW5TWS8+vthnq2nfmHnpW8WNnuWHVJr50OUxAWpps=;
        fh=hzfPE472IRx6L11ABe31Ddj6Z2L3SekaH+yoKdnKwpg=;
        b=Sbaff99L5d8riw+saYkJVHpGAiiS/hM4yPy11IZG8hXdIIDwqOyL6yiBpNibwltHAh
         siqWBZzl4s90Zr3ai4JYS/hRXJp1QDAIEXTvC8elGeU9hFyJ9fRhS+WcqCqQwSGbeV1X
         b8BqkWJ3knDsOdIDfWMtYSfFiZzQdeIgqyWLnFcTbqCw0b2wukuX68XuT6KhdsU+6/tN
         nZPmBjGO3BAF9cp3cc67ulDz1rNqBRj6E6blY4gg0+jmfaAK8EnP8UoFW48rECa6HpsI
         TRuCxKbtJiAJT8xKViV32n+NCb7pRnc/wf+n8tSKp95KxP9h/2sglxVSf1/Ww0qiA2Aw
         LeUg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780515849; x=1781120649; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tKWW5TWS8+vthnq2nfmHnpW8WNnuWHVJr50OUxAWpps=;
        b=BOAAzDRb6UWz1oRpF4UOoTIXc9yWjWhCetPgRm9PwfbLpFyzC3ARNHu971CHPTAWGw
         v+9BmBaB3Y8vAiDlhyVTGUHgkZQgzR0H/I/0dn7APTPdZonbYEEPgBefOdWHF534dKeX
         zrr4HcfdKSgK7JXR7FlV/h/Jt8a9QzFVkFYlpGJas51OHnKh/3fJzu2APZ9VsM3UT9pt
         9UplQcFyy/aw4Od+NolTwPuX/5tjAPcrq2jX7kEuyB97BcwuU1kh6fzRzG6UaFa2zLcM
         dh9K7jBY5JIFu/APIMxQ7D9rtVBGEB9CGRgPAQBYdOyzyZCBv/uP/ddbUH7OytqbnDD3
         EPvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780515849; x=1781120649;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tKWW5TWS8+vthnq2nfmHnpW8WNnuWHVJr50OUxAWpps=;
        b=ZzC4b/ypGSYbYepdE7ij/zyaXiYOu0CcFtsQ7mCuWRWymzIE2gpUbjcU9vMoDU+xmx
         CB6O8Qq2zwoJAd59P2dVmewtb1URwkH3T9kT6yNDMQhSn3DpzKWshKI1mfu0ZjCiW0Pm
         NIw6f+eSiwK5sSOj7PeyTPqhRFiKXkzjUTrD6Ba//0px+aSiN4l2MiKooFavSX+/f8ZK
         SB/MQvJfeGoPz3W+T1jDvfV23OkO9nl/BDLY66KwRWuJbLObHi596/0DMLLT9B3syafv
         9uL50mZi2ELDeQSe7y6SyyACz/lcV2zr4i2SAvr78NlPJmSRbREhtElLqmradKYr+VkF
         wKIg==
X-Forwarded-Encrypted: i=1; AFNElJ8ReSdg8kzD1p5jLe53+Q+THZ0TYjUOl5BPZPH666sYyXL1hTPHnkQaGPwShJoDsxKP5Ng5X70JzA==@kvack.org
X-Gm-Message-State: AOJu0YyBPL4UjQDtyBxSUiNgKGMLcq+B97ob5jMWZifKnDI7Cvh8SRh+
	7FDr21oudgxz4tD8Flzm8fSG3CDLuo0NIiE/nIq1tLDXFwApkgVB6y8TR4VhAcvSXs0R8y9t4by
	UjOZe/8wmAKuYxVYvPQg2QQ28MbMcS6HA2v07bNfX
X-Gm-Gg: Acq92OEkvvFlujMgJofR85c8I+IYDWYU2Lac5zoXMhVjru7SJIecTTe97d7iz/ryg9J
	WeUQ9A5roK2XltNbJ7kai+5NwaOSLeGNEyz+GrPMPJw8nbQadYxoZw3CrfwMlBunfo2HV1B5anC
	8W6/VI7Mx2QMExF+6HdquNfivrHtZaqe9eW7oTf56JbdaNXZPrbymXfXZcU1U9dHGUPxfJCcK9v
	bPFmy6MRL07fn3++FAzLdsH+nCQ+zfH2JbrYHs5kYjGlaH/o/GPKH6XkE+XA2duclKmvfh0ff+W
	kknRaW1MeZsUD51DzrcwW6zbyTN5c6K44rH8HZPikC977nrf
X-Received: by 2002:ac8:7eec:0:b0:517:5f1d:9f7 with SMTP id
 d75a77b69052e-51787bba853mr1137501cf.7.1780515847916; Wed, 03 Jun 2026
 12:44:07 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1777936301.git.abhishekbapat@google.com>
 <d064a1a8de127c0e321f675a9966e533a0917e7e.1777936301.git.abhishekbapat@google.com>
 <2f546525-8ff6-4bbe-86ae-6f474f7cefe3@linux.dev> <CAL41Mv7zCEFUAD43wBRo+rno2AK-teUUaVSdx2Pd7qDU0uNwsg@mail.gmail.com>
 <c627136d-8060-4e2d-8473-0fe322ce1e6c@linux.dev> <CAJuCfpFn0Oefewvjp1jBhCOgxxwhHFy_RK08DwQywOjYcfr2pw@mail.gmail.com>
 <b15d5320-f3ce-4b69-b6e1-b422173acbf0@linux.dev>
In-Reply-To: <b15d5320-f3ce-4b69-b6e1-b422173acbf0@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 3 Jun 2026 12:43:56 -0700
X-Gm-Features: AVHnY4LIC0STljzRMceUROKx_nMGdYXxEAkt2XKpSe8yoHu_RolL6-n_X65WdHk
Message-ID: <CAJuCfpHdron+NEh4GnLZ39jwUyxJrjmhZGACAe7JpV89Vy6Lkw@mail.gmail.com>
Subject: Re: [PATCH 1/6] alloc_tag: add ioctl to /proc/allocinfo
To: Hao Ge <hao.ge@linux.dev>
Cc: Abhishek Bapat <abhishekbapat@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Sourav Panda <souravpanda@google.com>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B6DA8C0003
X-Rspam-User: 
X-Stat-Signature: cji4mzagtckust7u9z31uuuddmt8848d
X-HE-Tag: 1780515849-347092
X-HE-Meta: U2FsdGVkX1/tNjFNuubt5S9SkaaMgnBcenceZWI3KF+pT+IPJxIlr7iUpw+/NpUGoMEK+acbz+EvdTke/esYSt+QgKmeNAEtnfIMVmKZVjk+4vlZBsSugFkD8FpkGis8BbrAH4ZvnG7yNiY3GOtt+jXdLbdei5CgSnaa1FX8pzrff98o0sz+Xwan4xfi524J7sLYxno3BvYuZjH4vo4uWjZG2EtOxzvtgrwZU7CJcDcb/V9Z68hjcdC+sL6y4gu88I/ex8cX4N/AD4pHLiS1OTnT8aIgF3HU2rBX7x6030cQ28YoklDtp1pgxE3kgBR4Jju+8TAcMbx99wjiDyEK8qG/O1N6Y0c5hdSreCnScPgomUVMJueuoI/UUYawXptBCiSrFmBkhSSfRdfjxHUlRleNFwaDq1NCnjmsw3orhcIwUf61iaGXGYuPA9Utly51qTz7yRSiLBIjJ/KQclfnx4GfC3iFxHnzIiDXxSyPphtSWVwKkGqP7neaTONvn1Qc+BOafeoyrD6Iz4Bsx5s3af4Bo0HcL2bhMoSlK3jW8onj6kkGMPvl/m3NNPgcI5HZZ7kSEf6D+66BnrSyesdFRiaQke7VOZzdG7vHdNRE6uO66OxPzhDkQD5UH7DM9e+Va05U3krSHoct6fxNTa8MvGzWZL5odgAT0vsTGOgTtSe1tYz9SdjELcORMqXT0rW8taYG8DQEguXoccF0OJgjKrG8N1aoXzVGzs6cpHRxNigwF0wna+OoTextXRNepPDDuDNE4Ydarf+3ySq/TszWJPr4XBRa0lTlpwqky/FJbICDswCcvdf99JorW0wNEa3z3LNKGmPmY/w1ycMqlYG5x1ndIdRT94SSuEY4c0ybskk0J0Oz6vXPJzQsI0wXIWD9OILt++P3LidxrLLufmAlxpM2F15989742DhHjaZMQU6l6m024qML2mne0kKI0bJDdMjoUdPSjvGRsFiTmY/
 clVBMyR3
 iyAZFpIiYd7H3QucLtOoPxy4clItVu0P8gx6pUr1c4vXKxBUm10qPTLiRggF4ldnGHJdSeOkMN9K1dBb7mjahWzLo0xMDAWWJmTWlDklrlfL6/eCgN24H2dP5EiSmm4gXlqPJp1a986aP2BVK6iKpaAkcHR+Z4gr2v+J2BsQ6sZSxUcdokdtgX1uAswJOwFcD3qzBBM1IKMbDRFwqrBUl02b71m83JFlcK5E9TSptjSQzmkoPSJYqHK2HavxBsOFVVRh/JBeVYVkhPWY9PAp4GSUeudQ4s166pGGheyATwFFG8V+1ettqFEJNrpSVALAN/5vy0HKOoyg+M1M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21, 2026 at 1:20=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
> On 2026/5/20 01:42, Suren Baghdasaryan wrote:
> > On Mon, May 18, 2026 at 7:53=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote=
:
> >> Hi Abhishek
> >>
> >>
> >> Thanks for the follow-up.
> >>
> >>
> >> On 2026/5/19 07:41, Abhishek Bapat wrote:
> >>> On Wed, May 13, 2026 at 9:38=E2=80=AFPM Hao Ge<hao.ge@linux.dev>  wro=
te:
> >>>> Hi Suren and Abhishek
> >>>>
> >>>>
> >>>> Thanks for the patch! A couple of minor comments below.
> >>>>
> >>>>
> >>>> On 2026/5/5 07:36, Abhishek Bapat wrote:
> >>>>> From: Suren Baghdasaryan<surenb@google.com>
> >>>>>
> >>>>> Add the following ioctl commands for /proc/allocinfo file:
> >>>>>
> >>>>> ALLOCINFO_IOC_CONTENT_ID - gets content identifier which can be use=
d
> >>>>> to check whether the file content has changed specifically due to m=
odule
> >>>>> load/unload. Every time a module is loaded / unloaded, the returned
> >>>>> value will be different. By comparing the identifier value at the
> >>>>> beginning and at the end of the content retrieval operation, users =
can
> >>>>> validate retrieved information for consistency.
> >>>>>
> >>>>> ALLOCINFO_IOC_GET_AT - gets the record at the specified position. T=
his
> >>>>> is the position of a record in /proc/allocinfo.
> >>>>>
> >>>>> ALLOCINFO_IOC_GET_NEXT - gets the record next to the last retrieved
> >>>>> one. If no records were previously retrieved, returns the first
> >>>>> record.
> >>>>>
> >>>>> Signed-off-by: Suren Baghdasaryan<surenb@google.com>
> >>>>> Signed-off-by: Abhishek Bapat<abhishekbapat@google.com>
> >>>>> ---
> >>>>>     .../userspace-api/ioctl/ioctl-number.rst      |   2 +
> >>>>>     include/linux/codetag.h                       |   1 +
> >>>>>     include/uapi/linux/alloc_tag.h                |  54 ++++++
> >>>>>     lib/alloc_tag.c                               | 178 +++++++++++=
++++++-
> >>>>>     lib/codetag.c                                 |  11 ++
> >>>>>     5 files changed, 244 insertions(+), 2 deletions(-)
> >>>>>     create mode 100644 include/uapi/linux/alloc_tag.h
> >>>>>
> >>>>> diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/D=
ocumentation/userspace-api/ioctl/ioctl-number.rst
> >>>>> index 331223761fff..84f6808a8578 100644
> >>>>> --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
> >>>>> +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
> >>>>> @@ -349,6 +349,8 @@ Code  Seq#    Include File                     =
                        Comments
> >>>>>                                                                    =
        <mailto:luzmaximilian@gmail.com>
> >>>>>     0xA5  20-2F  linux/surface_aggregator/dtx.h                    =
        Microsoft Surface DTX driver
> >>>>>                                                                    =
        <mailto:luzmaximilian@gmail.com>
> >>>>> +0xA6  00-0F  uapi/linux/alloc_tag.h                               =
     Memory allocation profiling
> >>>>> +<mailto:surenb@google.com>
> >>>>>     0xAA  00-3F  linux/uapi/linux/userfaultfd.h
> >>>>>     0xAB  00-1F  linux/nbd.h
> >>>>>     0xAC  00-1F  linux/raw.h
> >>>>> diff --git a/include/linux/codetag.h b/include/linux/codetag.h
> >>>>> index 8ea2a5f7c98a..2bcd4e7c809e 100644
> >>>>> --- a/include/linux/codetag.h
> >>>>> +++ b/include/linux/codetag.h
> >>>>> @@ -76,6 +76,7 @@ struct codetag_iterator {
> >>>>>
> >>>>>     void codetag_lock_module_list(struct codetag_type *cttype, bool=
 lock);
> >>>>>     bool codetag_trylock_module_list(struct codetag_type *cttype);
> >>>>> +unsigned long codetag_get_content_id(struct codetag_type *cttype);
> >>>>>     struct codetag_iterator codetag_get_ct_iter(struct codetag_type=
 *cttype);
> >>>>>     struct codetag *codetag_next_ct(struct codetag_iterator *iter);
> >>>>>
> >>>>> diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/al=
loc_tag.h
> >>>>> new file mode 100644
> >>>>> index 000000000000..e9a5b55fcc7a
> >>>>> --- /dev/null
> >>>>> +++ b/include/uapi/linux/alloc_tag.h
> >>>>> @@ -0,0 +1,54 @@
> >>>>> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> >>>>> +/*
> >>>>> + *  include/linux/alloc_tag.h
> >>>>> + */
> >>>>> +
> >>>>> +#ifndef _UAPI_ALLOC_TAG_H
> >>>>> +#define _UAPI_ALLOC_TAG_H
> >>>>> +
> >>>>> +#include <linux/types.h>
> >>>>> +
> >>>>> +#define ALLOCINFO_STR_SIZE   64
> >>>>> +
> >>>>> +struct allocinfo_content_id {
> >>>>> +     __u64 id;
> >>>>> +};
> >>>>> +
> >>>>> +struct allocinfo_tag {
> >>>>> +     /* Longer names are trimmed */
> >>>>> +     char modname[ALLOCINFO_STR_SIZE];
> >>>>> +     char function[ALLOCINFO_STR_SIZE];
> >>>>> +     char filename[ALLOCINFO_STR_SIZE];
> >>>>> +     __u64 lineno;
> >>>>> +};
> >>>>> +
> >>>>> +struct allocinfo_counter {
> >>>>> +     __u64 bytes;
> >>>>> +     __u64 calls;
> >>>>> +     __u8 accurate;
> >>>>> +     __u8 pad[7]; /* Add alignment to not break the 32-bit compati=
ble interface */
> >>>>> +};
> >>>>> +
> >>>>> +struct allocinfo_tag_data {
> >>>>> +     struct allocinfo_tag tag;
> >>>>> +     struct allocinfo_counter counter;
> >>>>> +};
> >>>>> +
> >>>>> +struct allocinfo_get_at {
> >>>>> +     __u64 pos;      /* input */
> >>>>> +     struct allocinfo_tag_data data;
> >>>>> +};
> >>>>> +
> >>>>> +#define _ALLOCINFO_IOC_CONTENT_ID    0
> >>>>> +#define _ALLOCINFO_IOC_GET_AT                1
> >>>>> +#define _ALLOCINFO_IOC_GET_NEXT              2
> >>>>> +
> >>>>> +#define ALLOCINFO_IOC_BASE           0xA6
> >>>>> +#define ALLOCINFO_IOC_CONTENT_ID     _IOR(ALLOCINFO_IOC_BASE, _ALL=
OCINFO_IOC_CONTENT_ID,     \
> >>>>> +                                          struct allocinfo_content=
_id)
> >>>>> +#define ALLOCINFO_IOC_GET_AT         _IOWR(ALLOCINFO_IOC_BASE, _AL=
LOCINFO_IOC_GET_AT,        \
> >>>>> +                                           struct allocinfo_get_at=
)
> >>>>> +#define ALLOCINFO_IOC_GET_NEXT               _IOR(ALLOCINFO_IOC_BA=
SE, _ALLOCINFO_IOC_GET_NEXT,       \
> >>>>> +                                          struct allocinfo_tag_dat=
a)
> >>>>> +
> >>>>> +#endif /* _UAPI_ALLOC_TAG_H */
> >>>>> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> >>>>> index ed1bdcf1f8ab..5c24d2f954d4 100644
> >>>>> --- a/lib/alloc_tag.c
> >>>>> +++ b/lib/alloc_tag.c
> >>>>> @@ -14,6 +14,7 @@
> >>>>>     #include <linux/string_choices.h>
> >>>>>     #include <linux/vmalloc.h>
> >>>>>     #include <linux/kmemleak.h>
> >>>>> +#include <uapi/linux/alloc_tag.h>
> >>>>>
> >>>>>     #define ALLOCINFO_FILE_NAME         "allocinfo"
> >>>>>     #define MODULE_ALLOC_TAG_VMAP_SIZE  (100000UL * sizeof(struct a=
lloc_tag))
> >>>>> @@ -46,6 +47,9 @@ int alloc_tag_ref_offs;
> >>>>>     struct allocinfo_private {
> >>>>>         struct codetag_iterator iter;
> >>>>>         bool print_header;
> >>>>> +     /* ioctl uses a separate iterator not to interfere with reads=
 */
> >>>>> +     struct codetag_iterator ioctl_iter;
> >>>>> +     bool positioned; /* seq_open_private() sets to 0 */
> >>>>>     };
> >>>>>
> >>>>>     static void *allocinfo_start(struct seq_file *m, loff_t *pos)
> >>>>> @@ -125,6 +129,177 @@ static const struct seq_operations allocinfo_=
seq_op =3D {
> >>>>>         .show   =3D allocinfo_show,
> >>>>>     };
> >>>>>
> >>>>> +static int allocinfo_open(struct inode *inode, struct file *file)
> >>>>> +{
> >>>>> +     return seq_open_private(file, &allocinfo_seq_op,
> >>>>> +                             sizeof(struct allocinfo_private));
> >>>>> +}
> >>>>> +
> >>>>> +static int allocinfo_release(struct inode *inode, struct file *fil=
e)
> >>>>> +{
> >>>>> +     return seq_release_private(inode, file);
> >>>>> +}
> >>>>> +
> >>>>> +static const char *allocinfo_str(const char *str)
> >>>>> +{
> >>>>> +     size_t len =3D strlen(str);
> >>>>> +
> >>>>> +     /* Keep an extra space for the trailing NULL. */
> >>>>> +     if (len >=3D ALLOCINFO_STR_SIZE)
> >>>>> +             str +=3D (len - ALLOCINFO_STR_SIZE) + 1;
> >>>>> +     return str;
> >>>>> +}
> >>>>> +
> >>>>> +/* Copy a string and trim from the beginning if it's too long */
> >>>>> +static void allocinfo_copy_str(char *dest, const char *src)
> >>>>> +{
> >>>>> +     strscpy(dest, allocinfo_str(src), ALLOCINFO_STR_SIZE);
> >>>>> +}
> >>>>> +
> >>>>> +static void allocinfo_to_params(struct codetag *ct,
> >>>>> +                             struct allocinfo_tag_data *data)
> >>>>> +{
> >>>>> +     struct alloc_tag *tag =3D ct_to_alloc_tag(ct);
> >>>>> +     struct alloc_tag_counters counter =3D alloc_tag_read(tag);
> >>>>> +
> >>>>> +     if (ct->modname)
> >>>>> +             allocinfo_copy_str(data->tag.modname, ct->modname);
> >>>>> +     else
> >>>>> +             data->tag.modname[0] =3D '\0';
> >>>> Minor nit about allocinfo_to_params():
> >>>>
> >>>> When modname is NULL (built-in kernel code), the current code sets i=
t
> >>>>
> >>>> to an empty string:
> >>>>
> >>>>        if (ct->modname)
> >>>>
> >>>>            allocinfo_copy_str(data->tag.modname, ct->modname);
> >>>>
> >>>>        else
> >>>>
> >>>>            data->tag.modname[0] =3D '\0';
> >>>>
> >>>> This is of course workable in userspace by checking for an empty
> >>>>
> >>>> string, but I was wondering if it would be cleaner to use "vmlinux"
> >>>>
> >>>> as a default:
> >>>>
> >>>> else
> >>>>
> >>>>              allocinfo_copy_str(data->tag.modname, "vmlinux");
> >>>>
> >>>>
> >>>> For some context, in our memory analysis workflow we often group
> >>>>
> >>>> allocations by module to get a quick overview of where memory goes,
> >>>>
> >>>> for example:
> >>>>
> >>>> vmlinux:    2.1 GB    (kernel core)
> >>>>
> >>>> nvidia:     1.2 GB    (GPU driver)
> >>>>
> >>>> iwlwifi:    800 MB    (WiFi driver)
> >>>>
> >>>> ext4:       500 MB    (filesystem)
> >>>>
> >>>> Having a consistent identifier for kernel built-in allocations would
> >>>>
> >>>> avoid each userspace tool needing to handle the empty string as a
> >>>>
> >>>> special case. Totally fine if this is intentional though.
> >>>>
> >>> Thanks for bringing this up, I can certainly make this change.
> >>> However, the information is not currently exposed this way through
> >>> /proc/allocinfo. /proc/allocinfo does not categorize kernel non-modul=
e
> >>> allocations as vmlinux, so there will a delta between how IOCTL and
> >>> /proc/allocinfo behave. Suren, could you comment on whether this
> >>> recommendation is fine by you?
> >>>
> >> Right, /proc/allocinfo indeed doesn't categorize them as vmlinux curre=
ntly.
> >>
> >> It's just that in practice we often group allocations by module, so
> >> having "vmlinux" as a default
> >>
> >> would be convenient. Let's wait for Suren's input.
> > Hi Folks,
> > I would prefer to keep it empty because vmlinux is not really a module
> > and hardcoding this name also seems suboptimal (in case it ever
> > changes). Empty string also aligns with how we output /proc/allocinfo
> > data. If the symbol is in the kernel itself, we do not display the
> > module name at all. So, all in all, unless there is a strong reason
> > against it, I think we should keep it empty.
>
> Hi Suren
>
>
> Thanks for the clarification, that makes sense.
>
> For userspace tools that want to group by module, we can always map an
> empty modname to "vmlinux" at the
>
> presentation layer =E2=80=94 no need to hardcode that in the kernel.
>
>
> Hi Abhishek
>
> I noticed the new files (like include/uapi/linux/alloc_tag.h) were added
> in this patchset.
>
> Should they be reflected in the MAINTAINERS file for easier future
> maintenance?

Yes, definitely. Thanks for noticing!

>
> Thanks
>
> Best Regards
>
> Hao
>
> >>>>> +     allocinfo_copy_str(data->tag.function, ct->function);
> >>>>> +     allocinfo_copy_str(data->tag.filename, ct->filename);
> >>>>> +     data->tag.lineno =3D ct->lineno;
> >>>>> +     data->counter.bytes =3D counter.bytes;
> >>>>> +     data->counter.calls =3D counter.calls;
> >>>>> +     data->counter.accurate =3D !alloc_tag_is_inaccurate(tag);
> >>>>> +}
> >>>>> +
> >>>>> +static int allocinfo_ioctl_get_content_id(struct seq_file *m, void=
 __user *arg)
> >>>>> +{
> >>>>> +     struct allocinfo_content_id params;
> >>>>> +
> >>>>> +     codetag_lock_module_list(alloc_tag_cttype, true);
> >>>>> +     params.id =3D codetag_get_content_id(alloc_tag_cttype);
> >>>>> +     codetag_lock_module_list(alloc_tag_cttype, false);
> >>>>> +     if (copy_to_user(arg, &params, sizeof(params)))
> >>>>> +             return -EFAULT;
> >>>>> +
> >>>>> +     return 0;
> >>>>> +}
> >>>>> +
> >>>>> +static int allocinfo_ioctl_get_at(struct seq_file *m, void __user =
*arg)
> >>>>> +{
> >>>>> +     struct allocinfo_private *priv;
> >>>>> +     struct codetag *ct;
> >>>>> +     __u64 pos;
> >>>>> +     struct allocinfo_get_at params =3D {0};
> >>>>> +
> >>>>> +     if (copy_from_user(&params, arg, sizeof(params)))
> >>>>> +             return -EFAULT;
> >>>>> +
> >>>>> +     priv =3D (struct allocinfo_private *)m->private;
> >>>>> +     pos =3D params.pos;
> >>>>> +
> >>>>> +     codetag_lock_module_list(alloc_tag_cttype, true);
> >>>>> +
> >>>>> +     /* Find the codetag */
> >>>>> +     priv->ioctl_iter =3D codetag_get_ct_iter(alloc_tag_cttype);
> >>>>> +     ct =3D codetag_next_ct(&priv->ioctl_iter);
> >>>>> +     while (ct && pos--)
> >>>>> +             ct =3D codetag_next_ct(&priv->ioctl_iter);
> >>>> I noticed that codetag_next_ct(&priv->ioctl_iter) and
> >>>>
> >>>> priv->positioned are accessed without serialization in the ioctl
> >>>>
> >>>> path. Concurrent ioctl calls on the same fd could race on these
> >>>>
> >>>> fields. Just something I spotted while reading the code.
> >>>>
> >>>>
> >>>> Thanks
> >>>>
> >>>> Best Regards
> >>>>
> >>>> Hao
> >>>>
> >>> I believe this should be prevented by `codetag_lock_module_list`; am =
I
> >>> wrong in my understanding?
> >> Thanks for the explanation! codetag_lock_module_list is designed to
> >> protect the module list from concurrent load/unload, which it does
> >>
> >> correctly. However, it doesn't cover the race between concurrent ioctl
> >> calls on the same fd, since it acquires cttype->mod_lock via
> >>
> >> down_read() and rwsem read locks allow multiple readers to proceed
> >> concurrently:
> >>
> >> Thread A: ALLOCINFO_IOC_GET_AT
> >>
> >> down_read(&cttype->mod_lock)              // read lock acquired
> >>
> >> priv->ioctl_iter =3D codetag_get_ct_iter(...)
> >>
> >> ct =3D codetag_next_ct(&priv->ioctl_iter)
> >>
> >> priv->positioned =3D true;
> >>
> >> Thread B: ALLOCINFO_IOC_GET_NEXT            // concurrent ioctl on sam=
e fd
> >>
> >> down_read(&cttype->mod_lock)              // read locks don't exclude
> >> each other
> >>
> >> if (!priv->positioned) {                  // sees partial state from
> >> Thread A
> >>
> >> priv->ioctl_iter =3D ...                // overwrites Thread A's itera=
tor
> >>
> >> }
> >>
> >> ct =3D codetag_next_ct(&priv->ioctl_iter)   // corrupted iterator
> >>
> >> priv->ioctl_iter and priv->positioned are per-fd state with no
> >> serialization in the ioctl path.
> > Yep, you are right. codetag_lock_module_list() is not enough here to
> > protect from such races. I guess allocinfo_private would need another
> > lock.
> > Thanks,
> > Suren.
> >
> >
> >> Just something I spotted.
> >>
> >> Thanks
> >>
> >> Best Regards
> >>
> >> Hao
> >>
> >>>>> +     if (ct) {
> >>>>> +             allocinfo_to_params(ct, &params.data);
> >>>>> +             priv->positioned =3D true;
> >>>>> +     }
> >>>>> +
> >>>>> +     codetag_lock_module_list(alloc_tag_cttype, false);
> >>>>> +
> >>>>> +     if (!ct)
> >>>>> +             return -ENOENT;
> >>>>> +
> >>>>> +     if (copy_to_user(arg, &params, sizeof(params)))
> >>>>> +             return -EFAULT;
> >>>>> +
> >>>>> +     return 0;
> >>>>> +}
> >>>>> +
> >>>>> +static int allocinfo_ioctl_get_next(struct seq_file *m, void __use=
r *arg)
> >>>>> +{
> >>>>> +     struct allocinfo_private *priv;
> >>>>> +     struct codetag *ct;
> >>>>> +     struct allocinfo_tag_data params =3D {0};
> >>>>> +     int ret =3D 0;
> >>>>> +
> >>>>> +     priv =3D (struct allocinfo_private *)m->private;
> >>>>> +
> >>>>> +     codetag_lock_module_list(alloc_tag_cttype, true);
> >>>>> +
> >>>>> +     if (!priv->positioned) {
> >>>>> +             priv->ioctl_iter =3D codetag_get_ct_iter(alloc_tag_ct=
type);
> >>>>> +             priv->positioned =3D true;
> >>>>> +     }
> >>>>> +
> >>>>> +     ct =3D codetag_next_ct(&priv->ioctl_iter);
> >>>>> +     if (ct)
> >>>>> +             allocinfo_to_params(ct, &params);
> >>>>> +
> >>>>> +     if (!ct) {
> >>>>> +             priv->positioned =3D false;
> >>>>> +             ret =3D -ENOENT;
> >>>>> +     }
> >>>>> +     codetag_lock_module_list(alloc_tag_cttype, false);
> >>>>> +
> >>>>> +     if (ret =3D=3D 0) {
> >>>>> +             if (copy_to_user(arg, &params, sizeof(params)))
> >>>>> +                     return -EFAULT;
> >>>>> +     }
> >>>>> +     return ret;
> >>>>> +}
> >>>>> +
> >>>>> +static long allocinfo_ioctl(struct file *file, unsigned int cmd,
> >>>>> +                         unsigned long __arg)
> >>>>> +{
> >>>>> +     void __user *arg =3D (void __user *)__arg;
> >>>>> +     int ret;
> >>>>> +
> >>>>> +     switch (cmd) {
> >>>>> +     case ALLOCINFO_IOC_CONTENT_ID:
> >>>>> +             ret =3D allocinfo_ioctl_get_content_id(file->private_=
data, arg);
> >>>>> +             break;
> >>>>> +     case ALLOCINFO_IOC_GET_AT:
> >>>>> +             ret =3D allocinfo_ioctl_get_at(file->private_data, ar=
g);
> >>>>> +             break;
> >>>>> +     case ALLOCINFO_IOC_GET_NEXT:
> >>>>> +             ret =3D allocinfo_ioctl_get_next(file->private_data, =
arg);
> >>>>> +             break;
> >>>>> +     default:
> >>>>> +             ret =3D -ENOIOCTLCMD;
> >>>>> +             break;
> >>>>> +     }
> >>>>> +
> >>>>> +     return ret;
> >>>>> +}
> >>>>> +
> >>>>> +#ifdef CONFIG_COMPAT
> >>>>> +static long allocinfo_compat_ioctl(struct file *file, unsigned int=
 cmd,
> >>>>> +                                unsigned long arg)
> >>>>> +{
> >>>>> +     return allocinfo_ioctl(file, cmd, (unsigned long)compat_ptr(a=
rg));
> >>>>> +}
> >>>>> +#endif
> >>>>> +
> >>>>> +static const struct proc_ops allocinfo_proc_ops =3D {
> >>>>> +     .proc_open              =3D allocinfo_open,
> >>>>> +     .proc_read_iter         =3D seq_read_iter,
> >>>>> +     .proc_lseek             =3D seq_lseek,
> >>>>> +     .proc_release           =3D allocinfo_release,
> >>>>> +     .proc_ioctl             =3D allocinfo_ioctl,
> >>>>> +#ifdef CONFIG_COMPAT
> >>>>> +     .proc_compat_ioctl      =3D allocinfo_compat_ioctl,
> >>>>> +#endif
> >>>>> +
> >>>>> +};
> >>>>> +
> >>>>>     size_t alloc_tag_top_users(struct codetag_bytes *tags, size_t c=
ount, bool can_sleep)
> >>>>>     {
> >>>>>         struct codetag_iterator iter;
> >>>>> @@ -946,8 +1121,7 @@ static int __init alloc_tag_init(void)
> >>>>>                 return 0;
> >>>>>         }
> >>>>>
> >>>>> -     if (!proc_create_seq_private(ALLOCINFO_FILE_NAME, 0400, NULL,=
 &allocinfo_seq_op,
> >>>>> -                                  sizeof(struct allocinfo_private)=
, NULL)) {
> >>>>> +     if (!proc_create(ALLOCINFO_FILE_NAME, 0400, NULL, &allocinfo_=
proc_ops)) {
> >>>>>                 pr_err("Failed to create %s file\n", ALLOCINFO_FILE=
_NAME);
> >>>>>                 shutdown_mem_profiling(false);
> >>>>>                 return -ENOMEM;
> >>>>> diff --git a/lib/codetag.c b/lib/codetag.c
> >>>>> index 304667897ad4..93aa30991563 100644
> >>>>> --- a/lib/codetag.c
> >>>>> +++ b/lib/codetag.c
> >>>>> @@ -48,6 +48,17 @@ bool codetag_trylock_module_list(struct codetag_=
type *cttype)
> >>>>>         return down_read_trylock(&cttype->mod_lock) !=3D 0;
> >>>>>     }
> >>>>>
> >>>>> +unsigned long codetag_get_content_id(struct codetag_type *cttype)
> >>>>> +{
> >>>>> +     lockdep_assert_held(&cttype->mod_lock);
> >>>>> +
> >>>>> +     /*
> >>>>> +      * next_mod_seq is updated on every load, so can be used to i=
dentify
> >>>>> +      * content changes.
> >>>>> +      */
> >>>>> +     return cttype->next_mod_seq;
> >>>>> +}
> >>>>> +
> >>>>>     struct codetag_iterator codetag_get_ct_iter(struct codetag_type=
 *cttype)
> >>>>>     {
> >>>>>         struct codetag_iterator iter =3D {
> >>> Note, I will be following up with a v2 patchset with your feedback
> >>> included. Please bring up any other points you'd want to clarify so
> >>> that I can include all the changes in the v2 patchset. Thanks for
> >>> reviewing!

