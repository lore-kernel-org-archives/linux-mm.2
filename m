Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CF92D116F3
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 18:54:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CAA86B00AE; Mon,  1 Dec 2025 13:54:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87C336B00AF; Mon,  1 Dec 2025 13:54:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 769BC6B00B1; Mon,  1 Dec 2025 13:54:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 621986B00AE
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 13:54:43 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 28176131DAD
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 18:54:43 +0000 (UTC)
X-FDA: 84171803646.03.13ECADF
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4A43116001C
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 18:54:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Du43G4t6;
	spf=pass (imf08.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.169 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764615281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oOg5rJpRGxMNF8jVCfiFK+KijweDt56lenCGhh8e8sU=;
	b=jghMWXZMi/8Jzg94yrG7r5ZfKbAdXNUd9jImJkrqmNbbJdxf+BHLpZLDqWoz+CiOnq09oA
	k0abYSXwJJoc+wK63AHIbkwyGiciLM0whEjB3cKG/mBkINyIsKS0OJ9BhESd9jeydjCCCH
	ULrbh47geWopaOEaaMeC3Auz4sTc6jA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Du43G4t6;
	spf=pass (imf08.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.169 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764615281; a=rsa-sha256;
	cv=none;
	b=ZIXmWXk9GTZ4CUJ563rXmz9R4aPzES4CsQf0uJUGVI8qVXeU+8IViE2yoy7NxtNWyNb6fZ
	+VNToFCMVIBK4qZ+lYUEbMdnKd1jtHcJf97P6nlzAPuDi1P4C9m7so2nRSoNLWfPNfeMjt
	LkzuZ4NGc9Dif3y1wOsJ72sOQkgR1ZE=
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-8b2dcdde698so525221185a.3
        for <linux-mm@kvack.org>; Mon, 01 Dec 2025 10:54:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764615280; x=1765220080; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oOg5rJpRGxMNF8jVCfiFK+KijweDt56lenCGhh8e8sU=;
        b=Du43G4t6mcIKvX2K40sNAJLg+LIpwNTSeXMSxwP/xzicG9/EB1TcBZYTG5dFrrB/IH
         28R8CoNO/n/uiVeRtLh6AXvq4DjVeYsiSaoUHLtKib86Qx6x/ZCZ5Zic2m5ZzzLmXoAO
         jEaZkzd85a1kTFzAZXYoo2gWxx9FZNadRz0KTnq9JBmVHUJ/XjzfTn5TnoobfeZNgBHp
         0lp0idTiCXzztg/0Q1zkUgADK6z6dS+9KOsKVDdjoJPpQx3V8Z1siBkhcDNDkxN16zKR
         oMB0XIHa2J0OSaF6DXTVDm2v3FNPWNO3hz57ScDDjrR9BmkN2mbhS5+bQavN0cyScXvk
         PM+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764615280; x=1765220080;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oOg5rJpRGxMNF8jVCfiFK+KijweDt56lenCGhh8e8sU=;
        b=mnWocpXK2ysi5qYIt25shP5C1iBDni/BwflMMcJuHW4oqywRj/DMGocDCIbqJmd11M
         ibDrZPjZJluUREUt+uXguPtclG4eEtD02XdvVQazjt/iNnRcxOhbvXdGW2u3Xg4FVVjK
         xb+Zl3t1rEMKW308XbKD1GrEzATF37eKbDcHvrFhzV4qvKm9oW2v5VhQqd3kGzfECbb3
         fpVXoB+Qi9IrA0y6mEN8J+A1m1uUoSQYk8nbJA+/9ATf+wmjMUGN4Ir5+nvldI5fzr6I
         nZs87qS5EgwjjQFeqCp7gfRS0d4oEKOxNMOUbeUkpqztaXj2hXmbnO7+NoziVCPeSxBQ
         z+bg==
X-Forwarded-Encrypted: i=1; AJvYcCXZDDp/Y9HmVl12Hx+a2kBu55818QEZbkp6OGApyv5FwNI4AeOHB87VvS9oB9dbGx+8PD+gVfexmQ==@kvack.org
X-Gm-Message-State: AOJu0YzOXSShza/Ej8kt7KslkTULO+BS9WU7HhjqymEz2f8Ca66mdZeX
	BNdUX0OD0Ff9euAkPCGPdigVtX5c0fobo1+kfyZ2GUNZF4nUVt/Bu9KOy3s24NaA0zH7b54AWOO
	PLjVt11ted+TRxeKBaqSeqy+CBCjq9Ko=
X-Gm-Gg: ASbGnctuBJUYRcRsSf8X5uQ7D+WjqzCH9TKuKRkdx29xlwrPI2BtdmWx19Hy2Ut/etq
	4ynwn85E4fObEU8/ZFt9yl8luRvQzXDio+JDfnTb7ZdeOY9XlsQcsKOQRg2PAUmhVyZ9GOLCnsS
	QE5pJCvUzDD2HCXq4j0SAZxLyLjMYZYNNX0wRg6vrVh6RDDO8ZLB8nJGyTlwkJoswfTpn7nwdAl
	lFIkVRjqhlK/9tNXhZAqbCrPR1IkyFiJpljzrrBAf9bKyPMiKzzqdAFVCN4XAf2JtLYxw==
X-Google-Smtp-Source: AGHT+IFvtCZPLKp1YCRvIO6mnzB7p91oDspUqUoM6+7uWHiItsPnpZSZhZORj9MZCoQ32PWx4DVeeUQMSRa9edkrXwc=
X-Received: by 2002:a05:620a:2688:b0:89f:27dc:6536 with SMTP id
 af79cd13be357-8b33d469962mr5370805785a.54.1764615280049; Mon, 01 Dec 2025
 10:54:40 -0800 (PST)
MIME-Version: 1.0
References: <CAGsJ_4xtc7ipFKYNQkGa-dSn7C8S7-J8LURqYrehfgenfPT=+w@mail.gmail.com>
 <20251201122912.348142-1-zhanghongru@xiaomi.com>
In-Reply-To: <20251201122912.348142-1-zhanghongru@xiaomi.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 2 Dec 2025 02:54:28 +0800
X-Gm-Features: AWmQ_bmwvl3kdnkWbR9j8-2n5AWf-ANkFhsuD4XPHVzCKmvTuAbVpchMYWzrFpY
Message-ID: <CAGsJ_4wvwH8oMYhbbhnbJAdX-fqBG9z-hXYqfshEXU0ChRpFyg@mail.gmail.com>
Subject: Re: [PATCH 2/3] mm/vmstat: get fragmentation statistics from
 per-migragetype count
To: Hongru Zhang <zhanghongru06@gmail.com>
Cc: zhongjinji@honor.com, Liam.Howlett@oracle.com, akpm@linux-foundation.org, 
	axelrasmussen@google.com, david@kernel.org, hannes@cmpxchg.org, 
	jackmanb@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	lorenzo.stoakes@oracle.com, mhocko@suse.com, rppt@kernel.org, 
	surenb@google.com, vbabka@suse.cz, weixugc@google.com, yuanchu@google.com, 
	zhanghongru@xiaomi.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ks68sm7kgtkdfimudon6gq1urdj41prp
X-Rspam-User: 
X-Rspamd-Queue-Id: 4A43116001C
X-Rspamd-Server: rspam09
X-HE-Tag: 1764615281-148368
X-HE-Meta: U2FsdGVkX1/HoASf9CnS+ygsZ22BF5TvsE77Oj47I2f1vLfFehQxu1t07BVqnCmxgmt+GsCXnHSfPN19Jsb0E0v+rGA4MRgsYwfCL16qlCMPGofM4mUkiYzSAqy7DE9hXORE4wyLHcUjhOjVtusbkAP0KIlFEz1HkB6j/2kSf9XcXDpRtdQ8eK9spnPrZ1xcNtm9PCFEPrGO5IqQoi55tSMnsunFYuPCeDndDpsLcClyGA4mYpDp4hDJHLYqHcM2M6LYPzwOC1610Hp0CNBr7j6XLv3FCtKCnuWRfd2xpzk6lTnm7UTYp7mnD2VnhdEoiN7WI0oa5+9ddxS7anU47ff5xwLpMrbn2U9696XXFey8pcwqLDomqcRjP8imIEeopI3r4QjJSMSksmEJ0y/LfUMyinP2usFDCwWjWF/hkfwweWL3PsVHq+TQ3Z4ObtJ0MupgD7XF7qiCtskiSSci6e008yRjtf7z2tUNVV/Lam3h/p8QftzGPhyiHZ03olzWK3xZxY68txxXijfJ3PcR6LjiPqaa9nGD/SBXCvyZGHB3AvJRBeIneG2I7Hhd+qHPqNXuyXBrooFuNvYLBARXpJgno1URfXEQmx2NVbdty5/13ToQ8mdTg2SKOHLGUGL91h9CZyyZ6xSDuhoWPT5oJ2tHrkap8TE7F2c0Jbe+A53VWMvTk4VZRpn4Dy8rXzOU8/95vOsFNWCTQ1CWGPr0DROiiTtpa2HIoXDNp+3u0Tq4xDVBkMrirQ+N5ehdMCX21PHa8HFXg6z+irwYfWguEM8sjsYp2MQ6FMZjU8uBYlChQyYW+N0NYxzOAxcvMUe7Kyqkvdtzq4JxyUkXEkcW8vd6ggu+eBlWoGQYYmfz4aBXxv+Do8xyzjhQlDQexDWfArAy++f4js1IvS9NwXSPO1eAZTsQIp1V0FolthI4DJsbp0AkeQSCSyD/NfJo5jFkBeuMf0Iyf7+TwKvHO8Q
 yFqHSErc
 fYI8z5lJrgzC3rhInKISfguPgS3Y5mWpfPo8kj2Q7n4niQ2+vqGiBNJTJ2A/zabKtBwY7SIEQiKKNATIeYH/APfMLVvnTmHwcuPquIhNZrnCVBrP4Ep4HmWFVe9Op++hbTYrj3apmgbe0uiXIk7HNphjreM0NNlEhQrnhplbwUPi5ryagOm0ECbrOIltK+JM7ftLO4GV5eD1Jni1iiuvc6AAU2XSy4O8zacKtrQB0KMVrmGvI/RYTjlYg48zhS2rIdiF0Molff2Pe9sZrcLjVCaY/RO8M79jvVedqBWAakyutaqAgqpSdq33HecjhJavfnodzWHMTiLFGkAESd/AL7ivshFU2OSRo+jJwmYyomdrMeNCOgo4g6WeV/73ZwO4B0VV5HxL4LAHgzel6of0P4vJjGA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 1, 2025 at 8:29=E2=80=AFPM Hongru Zhang <zhanghongru06@gmail.co=
m> wrote:
>
> > Right. If we want the freecount to accurately reflect the current syste=
m
> > state, we still need to take the zone lock.
>
> Yeah, as I mentioned in patch (2/3), this implementation has accuracy
> limitation:
>
>     "Accuracy. Both implementations have accuracy limitations. The previo=
us
>     implementation required acquiring and releasing the zone lock for cou=
nting
>     each order and migratetype, making it potentially inaccurate. Under h=
igh
>     memory pressure, accuracy would further degrade due to zone lock
>     contention or fragmentation. The new implementation collects data wit=
hin a
>     short time window, which helps maintain relatively small errors, and =
is
>     unaffected by memory pressure. Furthermore, user-space memory managem=
ent
>     components inherently experience decision latency - by the time they
>     process the collected data and execute actions, the memory state has
>     already changed. This means that even perfectly accurate data at
>     collection time becomes stale by decision time. Considering these fac=
tors,
>     the accuracy trade-off introduced by the new implementation should be
>     acceptable for practical use cases, offering a balance between perfor=
mance
>     and accuracy requirements."
>
> Additional data:
> 1. average latency of pagetypeinfo_showfree_print() over 1,000,000
>    times is 4.67 us
>
> 2. average latency is 125 ns, if seq_printf() is taken out of the loop
>
> Example code:
>
> +unsigned long total_lat =3D 0;
> +unsigned long total_count =3D 0;
> +
>  static void pagetypeinfo_showfree_print(struct seq_file *m,
>                                         pg_data_t *pgdat, struct zone *zo=
ne)
>  {
>         int order, mtype;
> +       ktime_t start;
> +       u64 lat;
> +       unsigned long freecounts[NR_PAGE_ORDERS][MIGRATE_TYPES]; /* ignor=
e potential stack overflow */
> +
> +       start =3D ktime_get();
> +       for (order =3D 0; order < NR_PAGE_ORDERS; ++order)
> +               for (mtype =3D 0; mtype < MIGRATE_TYPES; mtype++)
> +                       freecounts[order][mtype] =3D READ_ONCE(zone->free=
_area[order].mt_nr_free[mtype]);
> +
> +       lat =3D ktime_to_ns(ktime_sub(ktime_get(), start));
> +       total_count++;
> +       total_lat +=3D lat;
>
>         for (mtype =3D 0; mtype < MIGRATE_TYPES; mtype++) {
>                 seq_printf(m, "Node %4d, zone %8s, type %12s ",
> @@ -1594,7 +1609,7 @@ static void pagetypeinfo_showfree_print(struct seq_=
file *m,
>                         bool overflow =3D false;
>
>                         /* Keep the same output format for user-space too=
ls compatibility */
> -                       freecount =3D READ_ONCE(zone->free_area[order].mt=
_nr_free[mtype]);
> +                       freecount =3D freecounts[order][mtype];
>                         if (freecount >=3D 100000) {
>                                 overflow =3D true;
>                                 freecount =3D 100000;
> @@ -1692,6 +1707,13 @@ static void pagetypeinfo_showmixedcount(struct seq=
_file *m, pg_data_t *pgdat)
>  #endif /* CONFIG_PAGE_OWNER */
>  }
>
> I think both are small time window (if IRQ is disabled, latency is more
> deterministic).
>
> > Multiple independent WRITE_ONCE and READ_ONCE operations do not guarant=
ee
> > correctness. They may ensure single-copy atomicity per access, but not =
for the
> > overall result.
>
> I know this does not guarantee correctness of the overall result.
> READ_ONCE() and WRITE_ONCE() in this patch are used to avoid potential
> store tearing and read tearing caused by compiler optimizations.

Yes, I realized that correctness might not be a major concern, so I sent a
follow-up email [1] after replying to you.

>
> In fact, I have already noticed /proc/buddyinfo, which collects data unde=
r
> zone lock and uses data_race to avoid KCSAN reports. But I'm wondering if
> we could remove its zone lock as well, for the same reasons as
> /proc/pagetypeinfo.

That might be correct. However, if it doesn=E2=80=99t significantly affect =
performance
and buddyinfo is accessed much less frequently than the buddy list, we may
just leave it as is.

[1] https://lore.kernel.org/linux-mm/CAGsJ_4wUQdQyB_3y0Buf3uG34hvgpMAP3qHHw=
JM3=3DR01RJOuvw@mail.gmail.com/

Thanks
Barry

