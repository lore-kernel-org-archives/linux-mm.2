Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34CB8CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 15:48:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D4DD8E0149; Thu, 18 Sep 2025 11:48:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AC7A8E00F6; Thu, 18 Sep 2025 11:48:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C27F8E0149; Thu, 18 Sep 2025 11:48:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6A5578E00F6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 11:48:44 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 37D2614026D
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 15:48:44 +0000 (UTC)
X-FDA: 83902803768.02.F660654
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf29.hostedemail.com (Postfix) with ESMTP id 36AA112000A
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 15:48:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vJdE71Kd;
	spf=pass (imf29.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758210522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0rx16FrktF4Q4jtrgrrHA5a6Ai0Ce3s0txUm84e73Hw=;
	b=UPCaOVgN2MY7EovHhGIGT3phxYm/VnHsKOaRIptPr10b9jmkA53j+0h6EFD5fIXv7ew99A
	OEVZWyN38tE0S5D2d+CFuj7rML9NDpH4SCAoK2938HySWGRBZwADeLxqZLqtV6LdvnKELU
	DcbT5/HaRmHDoAKtOVd6dhog8tBdLx4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vJdE71Kd;
	spf=pass (imf29.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758210522; a=rsa-sha256;
	cv=none;
	b=2vydZ0GspBXeyyyiLqQ+wAbwPf3qwK52kuyjt6RC2aKc5Yokn8mpYW+vtOLyUgYKlOy4HM
	iRhwb52M6WBbNq2984cGgcvVBtU9BKPOQ1GnMx1vRU9220xWeVYa7S8C7vn2ksGSQ5NTs4
	kHQ6sGwtN4rl9y6mmvbilESgkAqK944=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-45f30011eceso78035e9.1
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 08:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758210521; x=1758815321; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0rx16FrktF4Q4jtrgrrHA5a6Ai0Ce3s0txUm84e73Hw=;
        b=vJdE71KdstZqkzEngla6S+gO1vveEOZ1iZN8RLEAFt+sHSOryazfJHxTEqSp2BsEyC
         iV6AEdO6jrTV/MZc3Dc0GyDRQN6RC2yYtxkuOyIbVynrZNGoYxINMljHgFggxrnJvL+w
         euplolRxFlxvEq84J38xh2A3YQAB2aEXjVqGyyDkwX0XUBlkXvE2YEfac/dBr8OTwqZD
         jxiK2/TSOpMYnnVQf8SlpWE523oW469obo8Pbn995xv2o8t6BLtImBM+3qSKb1IQo9YI
         ooFvSRUwEg0bJkmmF/XuIGNRsTVJMXie+ewWzEXhan3oJChSs/lgFeYHLl+13HkK4bLH
         oIEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758210521; x=1758815321;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0rx16FrktF4Q4jtrgrrHA5a6Ai0Ce3s0txUm84e73Hw=;
        b=uhD8+owZSG9gu6x6IE6Fjeuxotm4QipROAY+f6lUdJTH/MuIma7Dj16u66GTPt/MRw
         TVJdFqLJaLB8ShaSdpcDrhfGpyinWfHK4wjpHWOZqpssIsvLsMPIIKKl5iniCkqzgCF7
         vI9ajeWJ6QCnc6vFvVw/nJAlutoONmI+fltrvf2LwlCvmQn37roVOekM5upOvets4W+i
         OuwKgLJHafzbpfOaTLXb1FhGKWLKBUdSXe1S0DUFi8/tMOiSObPyp+8JTLruqcApsDel
         pXOz0BJOuZIHTqII07cjEiPSvwluJ/kvl/L8Ju7yY+qJssfhHWEP67pc57T/3fxbrdBv
         a+cQ==
X-Forwarded-Encrypted: i=1; AJvYcCUTYAqVPoXrYMGME/c9NfygAA/oJ12kaautgT6O6W3y/hmMobDqYR+GJrV3tYSQjWBBg6fTalqnUQ==@kvack.org
X-Gm-Message-State: AOJu0YwZIjsMaKwqJxCsTXl32V49zYk66GP8Ssv6OcVTLMiCYy02PXHc
	MEIUBbAjkP2LySY1ELlWi7gdGzvhjnNhcJ7+ucfM9/KQtZpJQqS3fmL9P5Vr2dv6kGEwORYFFvm
	2WMrZ+Iza0tbtMk73iSsUtRU+k5e5PL8/nX89f6OG
X-Gm-Gg: ASbGncut8kVxayvBEB29TaNRp2g/JjuHBpz0O71F34pUroPWXPKCQA3mim1bzytCmoG
	PsHxUmxfXE7/c8PbNpLTZCGsJHAKJGqX+/TjWMlYpD6o4/XvWo47WUtcNR0/r+A+NvW3Ai1+b5b
	uuVO51MfnoE028yVWvFNve1bSdnKftI1M/SlRs3bQ5hoZgnENa2XfEK7i297wWdKtsW+klD3iMO
	XxOLSzFGfCyrAa4IymFbXLmLFyXyqNopOzdTMLWahncAJuP9vIUn7bg/PLsqjHQ0w==
X-Google-Smtp-Source: AGHT+IEn14QDHuxEiqb1VXaCf6P34UADIYCw+R0AK6s/lF2DWM9aPjYC73nNm/t1rUXn6RFFu321KBvFpJntXFLW+cw=
X-Received: by 2002:a05:600c:8a09:10b0:45f:2940:d194 with SMTP id
 5b1f17b1804b1-4614faff8e6mr2807655e9.2.1758210520602; Thu, 18 Sep 2025
 08:48:40 -0700 (PDT)
MIME-Version: 1.0
References: <aMiu_Uku6Y5ZbuhM@hpe.com> <20250915201618.7d9d294a6b22e0f71540884b@linux-foundation.org>
 <aMkOCmGBhZKhKPrI@hpe.com> <SJ1PR11MB60831F028E2FEB6B5A3390D9FC14A@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <aMmlhPghbpnlCZ09@hpe.com> <SJ1PR11MB60833884799B6AA2BC18ECE7FC14A@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <LV4PR11MB9513A6EFA88B082E554CB8D6EB17A@LV4PR11MB9513.namprd11.prod.outlook.com>
 <aMsE9XjWKEYTIQyV@hpe.com> <1211fd9a-93e6-4ebe-a80d-083601138b70@linux.alibaba.com>
In-Reply-To: <1211fd9a-93e6-4ebe-a80d-083601138b70@linux.alibaba.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Thu, 18 Sep 2025 08:48:29 -0700
X-Gm-Features: AS18NWCH3-wHHtOkOjDEZ08ReQ721l4iWXSb56ihFpAN8Dh9hynFjggen97xtxQ
Message-ID: <CACw3F53=9+rSdUt7yqTz=GineyRxJf1FBgXQ4omYvFkwFDqZQA@mail.gmail.com>
Subject: Re: [PATCH v2] mm/memory-failure: Support disabling soft offline for
 HugeTLB pages
To: Shuai Xue <xueshuai@linux.alibaba.com>
Cc: Kyle Meyer <kyle.meyer@hpe.com>, "Fan, Shawn" <shawn.fan@intel.com>, 
	"Luck, Tony" <tony.luck@intel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"corbet@lwn.net" <corbet@lwn.net>, "david@redhat.com" <david@redhat.com>, 
	"linmiaohe@huawei.com" <linmiaohe@huawei.com>, "shuah@kernel.org" <shuah@kernel.org>, 
	"jane.chu@oracle.com" <jane.chu@oracle.com>, "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, 
	"bp@alien8.de" <bp@alien8.de>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, "jack@suse.cz" <jack@suse.cz>, 
	"joel.granados@kernel.org" <joel.granados@kernel.org>, "laoar.shao@gmail.com" <laoar.shao@gmail.com>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, 
	"mclapinski@google.com" <mclapinski@google.com>, "mhocko@suse.com" <mhocko@suse.com>, 
	"nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>, "osalvador@suse.de" <osalvador@suse.de>, 
	"Wysocki, Rafael J" <rafael.j.wysocki@intel.com>, "rppt@kernel.org" <rppt@kernel.org>, 
	"Anderson, Russ" <russ.anderson@hpe.com>, "surenb@google.com" <surenb@google.com>, 
	"vbabka@suse.cz" <vbabka@suse.cz>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 36AA112000A
X-Stat-Signature: mntq3zjsjpwi51rg8zgs1ohfbudazbbq
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758210521-737996
X-HE-Meta: U2FsdGVkX1/nGVdR0Lu8HCu3us8pz6YjOtsQ0OEzdHdoyQxYdYVZ5GsMM6lRflO6Vq3JWCyeYJwmUBYX7swb3Z3czMKaUoZYEYTq6nWarVj8D/TBXVRl3XkVOBv16E2OQEGgSr8xof00gdReYxDF3xBPVxn42P/vkt1bQAzmAKizJ3ZKDSdZwQzup/Z+fTMiFYk2JMhU5BSpqxxilk9P+h95bpn+6yKlQCftkgbbfybs0BGdoomTnzwTUDwo2b2SwA8/JEGqPv48ggpru1SpHTtuKEuHPJaImYDn1HbucVU/Xd0pFUt44QzjKas4lbHRghK1k7EynkP3vsISUaS2nL1o4TiMGfJa42eM9NLh65F3ngWE5mgOymmrVSlngMmJZqGZn0uoG+z1p3oFd8DqRMgtjH5qPTPRC9zGrjkmcwxEyjffnclBmnALag8JVs2fjtc2kKLJsD9U0hCUwZDddsCFGTnAVaVUMPr72J5yCC1laUjaqzvBnlN+em91rYXGN18LTIooGuhw2uiTozeOvUkc4wSdFKvrkt9giLYEe8MM2N0mhlPSjXJQmltAKVrS6GEc7oAcT32cmrWX5sWgZTmpFp9P+buKWKoWE3MWQRpJw+KJZ7Dev6kY8X5fbk+Toga+Iv2cusKakxaqWaIRHaR8e4trhbOAZcbuVYzXwAlTa4eK/G6lnpubKDY6KvJy2MC8inzHMHgzbkfuaHaMEIs03EVlsUXWkDaaNlhot5wDFtiJxCJ1hOxAOosrGGbxKlxPf3++BdrJkA7yFJrtQ1vwzvPECxqjIFpi1oKKxVCba0JIjRW8dUxWkCSHV4OY5AIeGNAwOfNfIDHniTh8mTIV31AAcum/uy5XT5v5h6JB18h6wDZgE1zW53NvgVEQZEtZMVS9LekPDtwL+1dMFI1BJt6B1Z6nDftjhvFZB0GbCDDCGz0807l/exBMhoG+l+9yjOmMhPzB4avWgCq
 N/qor/IU
 JJIHzGa6SBGZTBIjhW1YkoIDHCkTKmCTm53u/AawJ5cr19cSjBAqQPKtdx6ZFGxChl/+hdmA7SCKq0YOMkJW3+4zVJApau77PQQ6Av3R1LaDRE4IR8pabAUg4iYtV5VKYaq+H1BQ/EkOSAMLeueXCja8rdXgw7BWorfWgPxj5GnVsNd3t6L4hrCUykfeUB7556gyckLgDlh4hsDZdI/IErZZJcjTeHfcULlt2mpUdU58zA93fFvB14cN7N9YFJWiVxR1y8fYfjrG0HhiF/f3Sy2UWsgIBllgn0vaJ2uJPwGl0peMRx4xpdyqgdoZTni/HwXx5OqQbUMsxd3U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 1:34=E2=80=AFAM Shuai Xue <xueshuai@linux.alibaba.c=
om> wrote:
>
>
>
> =E5=9C=A8 2025/9/18 02:59, Kyle Meyer =E5=86=99=E9=81=93:
> > On Wed, Sep 17, 2025 at 06:35:14AM +0000, Fan, Shawn wrote:
> >>>> My original patch for this just skipped the GHES->offline process
> >>>> for huge pages. But I wasn't aware of the sysctl control. That provi=
des
> >>>> a better solution.
> >>>
> >>> Tony, does that mean you're OK with using the existing sysctl interfa=
ce? If
> >>> so, I'll just send a separate patch to update the sysfs-memory-page-o=
ffline
> >>> documentation and drop the rest.
> >>
> >> Kyle,
> >>
> >> It depends on which camp the external customer that reported this
> >> falls into:
> >>
> >> 1) "I'm OK disabling all soft offline requests".
> >>
> >> or the:
> >>
> >> 2) "I'd like 4K pages to still go offline if the BIOS asks, just not a=
ny huge pages".
> >>
> >> Shawn: Can you please find out?
> >>
> >>
> >> -> Prefer the 2nd option,  "4K pages still go offline if the BIOS asks=
, just not any huge pages."
> >
> > OK, thank you.
> >
> > Does that mean they want to avoid offlining transparent huge pages as w=
ell?
> >
> > Thanks,
> > Kyle Meyer
>
>
> Hi, Shawn,
>
> As memory access is typically interleaved between channels. When the
> per-rank threshold is exceeded, soft-offlining the last accessed address
> seems unreasonable - regardless of whether it's a 4KB page or a huge
> page. The error accumulation happens at the rank level, but the action
> is taken on a specific page that happened to trigger the threshold,
> which doesn't address the underlying issue.

Does it mean the soft offline action taken by the kernel is almost
useless from hw's PoV? Or, the current signals/info about the
corrected errors kernel get from firmware are insufficient to make the
kernel do anything meaningful?

>
> I prefer the first option that disabling all soft offline requests from
> GHES driver.
>
> Thanks.
> Shuai

