Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 924BCD6CFB9
	for <linux-mm@archiver.kernel.org>; Sat, 24 Jan 2026 04:42:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E217F6B0586; Fri, 23 Jan 2026 23:42:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCEB56B0588; Fri, 23 Jan 2026 23:42:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD1466B0589; Fri, 23 Jan 2026 23:42:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B8D1E6B0586
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 23:42:30 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 49CBD160209
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 04:42:30 +0000 (UTC)
X-FDA: 84365611260.20.076B14F
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf20.hostedemail.com (Postfix) with ESMTP id 506331C0002
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 04:42:28 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="H1JBl/eQ";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf20.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=jiaqiyan@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769229748; a=rsa-sha256;
	cv=pass;
	b=BpHdTuA2uzK/sA3WotylMBRHQwP9e6vjw9H+/1SaLOlSd2xj1fgIC4Sm/3BAuq1mVKsGLV
	9ANr+2zNf9FdbV4V18OF+0Ht1EO0jSK9P3s85SHq+41kflkVTEaxLwXSzTHT6tnXfZHFom
	gbL74r6ga3j2xKXoRmc2rXlGsP2VBgQ=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="H1JBl/eQ";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf20.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=jiaqiyan@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769229748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EjxGKhpq4iqA0uBvWR0Wc+v1/ED4GcaN9vazZi6cKNs=;
	b=BFBUUmT4f4MIrSeVjo4SZgEM8M2h+pkS89wa+iFXDyVdHoLDHgaDqT8VPwgLkXRfVXZ027
	PjvLTYiIOUpACS47fGuYVV58P64/U33ciinbOCyVNW7yuKUfD1A8+yuuZaR3fuxiQQEDB4
	Rxfi/ocGdU5thZqjI979D4txsPi+CpM=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-47ee730612dso17805e9.0
        for <linux-mm@kvack.org>; Fri, 23 Jan 2026 20:42:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769229747; cv=none;
        d=google.com; s=arc-20240605;
        b=QT7KX3b7mhmGRkeLo9nTa0Ncah9oAf3FIBNfs6AxcQ3YOvG6qlYdtXVYBrJMf0zitk
         ++JZYB1UgUFmeemebz3tg3qbTd0G5dNmcXgpTniTdXX7fdSLuNWL/fGGwTUn+zj0JrXS
         hiaSImlyZvllYde2bz4wVPc3y8FW3hfnlGMKXo8FJTazdj3KfQh1pYXFE0SS6fb+HXTm
         IKJ9xQBUqibuTZQDR+M2MkRJ8ZyCCFqK9ESQ914KKORjDj1ChCtD9B6TYDPBgtmdoATB
         obMuU4gD2PHqrhYtj7Y9+OOe52AyeXI2x8sBB3QMVRRLgVaXxFM9a0/5Got7on/KJNjC
         xeqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EjxGKhpq4iqA0uBvWR0Wc+v1/ED4GcaN9vazZi6cKNs=;
        fh=DIaebJJcxabpQoYfmuVqiqqeAHbt5VOI93MjB663/es=;
        b=WM0CHxqZ7bLBJFDMjy30U/+rD3YhCvfi8NDYtPaqstRdq4dH8uOHfyzDoJKmR04mKp
         dh9aeM8P4mbaiXjRtHDdBhi1JoRNkmSoaj50f79DY4XygWa85IN0AuDT72ftyaLKVYg5
         LDNiztNtEk4Kq+/B04pbxAMVQhFj/YHWpsURzBbTbrC+cobcScsqYlRE81Hh8xd0QGDV
         8+MBASp60oUEcr249wU4aK4mnF8knc1/3koQ2JyHcEEqW3R9v8O9rJNlR20xtKzyfweQ
         cCevEpl9xm5/Mvzr7xP4UanXj2MyoL97viPojdDoJNCEuIs1EO+PmIz/mzsI4DX+QwXS
         s87A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769229747; x=1769834547; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EjxGKhpq4iqA0uBvWR0Wc+v1/ED4GcaN9vazZi6cKNs=;
        b=H1JBl/eQxSvpxJYEzsjdX/jl8JCf70d3DQmaGXC6g+ghL4tESpUEM9/sorZbBo/Po5
         goSQTZPF2mMAD9cvKVegSfkvHvWlJ8mwXLCP2g59aXrr5PzrlBP6d4dbhWRcQLfAhSHu
         oQa1ZW/qLxZPGfdTUkCyIqhYesutc/ZED4PL6swmoFtYPKRm0tO/8UyTAQrLDnX02McU
         NM7LnzijcsOdI7Ak+2KXHiho0XR677RZjVEFqFM5lr43Cq5uIs6cdR8qpTSWAzvC8+AT
         UlzJ6ub+M3KC8VBTAhbpl0sdKCr4+DHGJk5x0WO3uA0kXk1vJ1lMN84iSM5/QMwJ+Qao
         yQjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769229747; x=1769834547;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EjxGKhpq4iqA0uBvWR0Wc+v1/ED4GcaN9vazZi6cKNs=;
        b=FXt5BV/QCztVS/MziRpir+O7e/vvKZdVGI/Wzq414LGSA/B99r66lSURp29NgNnXqA
         nExmUyS2lNsNSlNpIHop/XmHezOUE/XDVe1+iUZQ3Tdgg4B/lfblNurzcc9jyBqKu/dp
         pQ7C01HBEdxsPemnsoQaN/YHnsQ1agn1Hi5RcVqAnnFFUnCH6AmfrcF/mVLfjiub93sL
         hhpCa7gywi8bZqQA89NFWf7pRnKMMc9rJ43B/xTCNiiuyBB663TRE53u+01Y5z2fH668
         NleGfi658Cyr3aB87tx7xYDyZcprkKNgQ0ppq0+Nx+pCnIqLcY27vDChIOy2G38U0Mxp
         GoVg==
X-Forwarded-Encrypted: i=1; AJvYcCWKV7ClngeckWiT3Odz/NOw5q+LvuqVHXqHgHvMwzRz0r8yGQ9xZ0gjH+E3wwBsUH/H90PRFUH+Tg==@kvack.org
X-Gm-Message-State: AOJu0YzoD3JHU6R8pVOgZfALxOWSyHrxwvKjPD5WDEyiFWyOTknUAxf9
	bq6ZQ4OQD3asSGTQcvaZM3YmedLnKKu4mWvA4wLkmTvHGvX1w8H/415c8+KkYxmx4gIiqKhoNAC
	HCohzVfE7gB2LxSkdOiWbslRG9WykBZLTP75eP9a0
X-Gm-Gg: AZuq6aKm6ZO2ZP4Gn/t1Pcblq1qA2N/eD91ljlIzmfX/V+DFRX1gkvj3tbOP8GgL5ix
	o1ezDurP7cDdWFGXeoGwSr5YyfMCpZ8zTaGBntbE9X+E+DB6LSVedvHOgcHmGNo9TBRSOr/YsUk
	cmiCOHHITh05nT/JSze35vU06/s0T76Ymniu6LXQguO5EgoxtPSRADioe0meTlwxFxh06R4GhRE
	Ri0KaaTW0zW5EF67mQ79xC2l3m7aoYSUgW9jdOU9+skhID+QoYosk4o3QsaQIET2qepaB53GTGN
	VGC+nUJ+eJgoSAGdzj3+VSSHjHk=
X-Received: by 2002:a05:600d:844a:10b0:477:95a8:3805 with SMTP id
 5b1f17b1804b1-48055bca261mr205085e9.15.1769229746467; Fri, 23 Jan 2026
 20:42:26 -0800 (PST)
MIME-Version: 1.0
References: <CACw3F52D8=s_uj_jRtw1J-GjAvt4c3HNMKb2sJGUjznvyAK80A@mail.gmail.com>
 <20260116141157.29578-1-boudewijn@delta-utec.com>
In-Reply-To: <20260116141157.29578-1-boudewijn@delta-utec.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Fri, 23 Jan 2026 20:42:14 -0800
X-Gm-Features: AZwV_QgQHog8bttzRf6AzcHgHizMbtJX5B80VgdWnIgjFvKVXrtA08K1fLxEeRM
Message-ID: <CACw3F529=PC-pwXOX0gbNrnS7HTwXq93oVT=V74J4FHLqcZ-ug@mail.gmail.com>
Subject: Re: [PATCH] mm/page_alloc: Fix freeing of failed-split poisoned
 compound pages
To: Boudewijn van der Heide <boudewijn@delta-utec.com>, ziy@nvidia.com, linmiaohe@huawei.com
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, jackmanb@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com, 
	nao.horiguchi@gmail.com, osalvador@suse.de, surenb@google.com, vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 506331C0002
X-Stat-Signature: ekndkg4zjb8whjieq4iuz8w6hftk1d8o
X-HE-Tag: 1769229748-279217
X-HE-Meta: U2FsdGVkX1/pppzfm/jsBbP4MXI15EZHXjbNzXGrBvkhzkM4SoXjuT6HhGGkLQBJFhbEdNiHSm09xB0Kt56U4FBnXrml8eiabOzCRFzCD3p6fWIEYF5kD887e1/XHcTMI2p9wTpFPrWIVVIf5B4n1XACN8kRcI9poVGUdpOFLBz7afFERQwebV0PJH/G0CjzdvRShTaPlVoFsskB+oYD6Z/m+NxFk3k+L6YHfk6otpgH6IJy0E7a/8ctbPlAV2PBK4Ckgh+Tx3RGQbQNEfv9EVLgXuAuvlRKqx4fVoYnqcAxPvb+FXPeFqJI4aji8JHuVhMuzzRWzCJrOa+8e1N+ZAvD9jEbBovh18YT+nIaw9JNuIXRnZ7JCx4MhSA5LlMT4rhFGMyEtIhH/WH8TXHuZgnaR53LsJwWXQVgShdsrALpbL1DmXdlj0SXselZinfMCE07uAQp3GV/WoKeZTC2jMLzzrc3H5mVAjmlg1I4yG0jo9VeYO2X+kwIxb7PMIiki7J51aEhl0KQvuN3KSav6LCa2IZPIH7eIr/0Oa9/HW61z8XhScbz+EKB6yTaiKBpnCf61lDUgHhRU4LnhT4ZUqnqpcQrnKfNjXmY2mOc1QTHtYKxysawfz/OeosjD9wexHw6ejKyWDdkmxRhS7n/steVQNjqtY56XCWWAPl1m7TVmY2G//CytllZBVETPsBTRJGAlwDTsxNaPoakc55+UrXtXMK5K0SZJM17K32FGK0U/mnM/WCjBRx8C7fprmgmGznvemkYB7zg6YMQ19Gz0AZ3XxhB5n0unDVwsn4kcgCmQNTd5Hq+moBucfM2qRncRTeKp1FVHBgaZXlk49vQmrz9XZE0rWIQ5oteqqfA6q4Fm+a4Awo7RZtG7TEFwCgFEPMvIvSb4kUz6S9FLIFb2Mq0TlN6LFMMYmgsH/Q96TjlhrfAjlykvgp7Ebz3cdqVQuEJqQm0yX1ChAKIz7F
 XMfaW5H8
 Lj1WspfcS4baiVhm+YNO8mCt+B5qmcgyiEyA6L/S+Yb4CAvAZWREkZkgYiV4Gbo2441UPf9+R+Y8g4HI39XfRa11RQPc16mvF43vLMFBhrTtJCOcBGPTZYdJ5TUSf1UJBTJ0yUTpdYXjPFKnlWd4JoDiai1Zr/gibRxayOtAqFU4s6C90FXQdGQgdHmiF31kCjODwcmnuDeG+M2w3ZQPvF9UAHa8LMZwU0VaBg4a1QA2gPDPobGxhdZ5jVrexHTuiUgAKR2XvclDmHnKNyehmd48/o/OE51uu01IhWjmglqj/bLfLZh2CM+FG/kpfh4FAXW7Kla3wYxM9TdGaeX1ZsOIV59Gc0RlmaYvU0YBGuuFVjcFVoJXuCUfoavEV0IgT2FmRJoDvZRNgHizeQUnn7aWdHjg9P9jBjhfQFl7PA7CW+UxYx8UzJnCK3gWvwEV34QYzJFDouorxNMU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 6:12=E2=80=AFAM Boudewijn van der Heide
<boudewijn@delta-utec.com> wrote:
>
> Thanks Jiaqi for the feedback, that is very helpful.
> (and thanks Miaohe for connecting the issues.)
>
> After going through the memory_failure(),
> I can see it indeed puts the PG_HWPoison flag on the specific subpage poi=
nter,
> and therefore my fix won't work as-is.
>
> > >
> > > Yes, this is also a problematic scenario for Hugetlb HugePage. And Ji=
aqi works on
> > > it now [1]. I think Jiaqi's patches might apply to THP scenario too. =
Add @Jiaqi to
> > > verify this.
> >
> > Yep, I think my work will also help solve the concern when
> > try_to_split_thp_page() fails.
>
> Your fix makes a lot of sense for hugetlb,
> as it linearly scans through all the pages.
> From my understanding,
> your fix also provides the perfect architecture for also checking THP,
> though it doesn't yet cover the in-use THP case outlined.

Oh, sorry I went ahead myself and assumed the split-failed folio would
eventually be released to the buddy allocator at some point when
userspace processes who owns/maps this THP are killed or exited.

Zi and Miaohe, am I right about this? or do we need explicitly handle
in-use and split-failed THP?

>
> For THP I would need to trace the failed-split paths more carefully,
> to check where the equivalent path for THP would be.
>
> If there is work needed for THP, I'm happy to help.
> Would you prefer I work on THP support as a separate follow-up patch,
> after yours is merged,
> or do you prefer to integrate it in your patch series?
>
> > >
> > > [1]: https://lore.kernel.org/all/20260112004923.888429-1-jiaqiyan@goo=
gle.com/
> > >
> > > Thanks.
> > > .
>
> Thanks,
> Boudewijn

