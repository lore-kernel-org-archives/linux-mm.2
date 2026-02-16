Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1457AE81A3F
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 16:00:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BD7D6B0088; Mon, 16 Feb 2026 11:00:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35E2F6B0089; Mon, 16 Feb 2026 11:00:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2433D6B008A; Mon, 16 Feb 2026 11:00:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0F0DB6B0088
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 11:00:05 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AE7705CFC2
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 16:00:04 +0000 (UTC)
X-FDA: 84450781128.17.DB21AC6
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	by imf03.hostedemail.com (Postfix) with ESMTP id B18762000D
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 16:00:02 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EugFQDpl;
	spf=pass (imf03.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771257602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cguGeKzLADxEQ0EEoT9dyo0zsVksU3ePFG1DeF7kjsg=;
	b=lhYdarb9Kbuf1A9Ulhq075yIBkfnqg2Nmm5Wd4Whzn7yQDctXd1iNeDuPyWKj46m+g2Ug0
	kqvcc6ZEjZxyWDzqQi7OBDtdw9qMQnMmWVIzvQc21qhQkqwNC6V5vx0mMQFCJqzeLRZjy6
	oM0qJ+Q6j+RGRRrp11qL77d3FCGSsys=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EugFQDpl;
	spf=pass (imf03.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771257602; a=rsa-sha256;
	cv=pass;
	b=IcMfQK1K75IDu18r6D24BVHTflnm3bmlPU1SGw2GLMNUJMK9zLNIfvHh3JnY3UK1ISvylr
	QuAktv1FG+ps+bRG98Cwsuj310pdzWBCLBs04kgweI+u0HMMNcvU8Ds7elE8Vj9yoNKMZP
	uhxa8UsohXRvbuaau1qvDqQJY/pgxSw=
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-793fdbb8d3aso29792737b3.3
        for <linux-mm@kvack.org>; Mon, 16 Feb 2026 08:00:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771257602; cv=none;
        d=google.com; s=arc-20240605;
        b=FhUsX3lCqUMaqTIaAiI7bIL9HTbRDgEED/hHeUpy9xdIfcIjSvvzeII0Rx8SGQ3MSG
         Qqvm0nnC1XxwL8alz8+nA7xKGQf0ftunuhnnsUip5oiC6Bo6+hNgakgFt1AfUt0t8+A5
         JNFIBvISyXCOZV85wi7+kh2nW4iUdQMbin0J2sXXL94NuII1x38+MFaVNLeqTDrkTAYz
         apgWCG5joCMlalIKQejXYypAQaZRp6nkvgSR74LSCG2IJRgug0Wcmo2tVvY9wIrOBGHv
         8WNO2JHSui+tqUhnODw45eJNfeRqmOLGTxNkQQpUjmWeUeuZf18JjKguk9/yDcHqkVw3
         I2MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cguGeKzLADxEQ0EEoT9dyo0zsVksU3ePFG1DeF7kjsg=;
        fh=Gl25Zsy2isBTunXuKTY0qR56G78xR9gRyFHjpP0UMeY=;
        b=eOWp7vSMiP0cO3aMKSdEheVRbDRH739NPmwf87bvSPzBXRCuKdaNd4P3KTgCSy1ZoV
         qQqTDxLDjQEzMKBxnna+AiywFgKc39tdXAYnHBh8C/GqbBYf5t6Qf/lqVQz9/CZRDmkk
         jy3+otuGC49HvMEJ4+lePU4iSbQmXDn0Ac8QIeM7nl6LOjsG2dCwKy5ICcfU+E7eENEg
         QMNtBCYWGamwJzF8yb7ZLNA44ArwXhRH/D8nD4vckkFnd4iIIYUH2yoJ3HCx6B1wOdHj
         VfP3aG2MvtOTrZwPtaqb2VJfw4zQZ84esHVisezphEPzbCwu6w8wksidAAOLQuxct7n7
         yyGQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771257602; x=1771862402; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cguGeKzLADxEQ0EEoT9dyo0zsVksU3ePFG1DeF7kjsg=;
        b=EugFQDpl321mN0t0jCvDgBcSXvASI/iU5RrtAVkuPQEZkUgarTZsURGxmuOAhFfGq9
         9FKiLTO2nfwXxB3VRDD68IwTMoGxqr6KQ9mRdAcvZWckJjByPaVfYCqMhfryQO48FgJc
         VnU7vfj74NuLRLTksacSX+Sn1Hc3vc46EFcBVAtzBezmMnH8Y7S56EdA2mR8cU13HElo
         D5vLciP8T8HLAk4K+QwfPBDM+8Nuhk08DDVomBPmG9WBTstTIgkMl1EMLtqthbR8IIDT
         yv9dRZ7iS/vtpuESACVN41Hh+LpOHTQJEBdd2FTegrH/sNlka18urg2KvmRdijuLxLUp
         wKiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771257602; x=1771862402;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cguGeKzLADxEQ0EEoT9dyo0zsVksU3ePFG1DeF7kjsg=;
        b=ia+m7QkcMT5eEA9/mTRVCOt+n38fUX1vraLydLF/Pefqx0R98XOd8SYSTWl0LcAl8O
         bmqThb8AgAg51WachmwDsWP+t2UH8z9Mfn6MmrLSq66Zawx1jfcjjjRxGko/HHQz7ISQ
         ewsA0aGkoKEQCXX7YdsKnHKYK6HaiDV4BzVYNjoGTWHho6HBu35E6Y2VX7vHq9Yfoxna
         ojVqti0oitNq+VF1PP5OFKdA4nsjU9CbZWkhsYvQivsca5Ez5P3FCSdWAhqGBFlxiX1R
         dfmMN3AC/jsHwBYiEvr4wXGqpQa76epe5zWiOZeaWyS++NSUH1jtSxBlwuW5tbeZ2Gmf
         mcAQ==
X-Forwarded-Encrypted: i=1; AJvYcCXEmtxx9cNCYYLeD3WUsmsNgrvC+woaCEeXg6FxuXQlvBCXKKJpQwRp1pTjshhnTBXilyZHQCBqWg==@kvack.org
X-Gm-Message-State: AOJu0Ywsv/kWsfdW9W+JxenxHQwLl0H1BZ5BZn568zXWPVWIbZJX8oXB
	Hh9ON+bFVKFogTmh3gnSNiKI9e/16n+1GTfMwoUdtLujc6SuTVtwSuzAhenAWWwYTtyhcUgDbtS
	F5gxlLfHCBlbWQihzuvg0jx09PHywKqU=
X-Gm-Gg: AZuq6aIJnzjsKutr9FMV2m+iDfCl0LILTf+D7mMJgdzeo1S6zA/v4pLl+65xC1kQoZj
	zzoVVeNpW960/tKMeKppuYgnoNZHwdihz/DI6MbTroBptCRBJoZCHGizbM21Dg7GLGuzdTK79Vf
	8G9j7mgMMG2oO+DdF5lmr3FbIjJbW11keggZwBXgGgRceSNJg/p2EL4U+4tDodpYG98yVhtS1QJ
	31D3yhXts8OqRYeAv+bXpqmaC2c0Vw2I3ilSemqwfwJDzOZtZ3EDD2YzkHUNeeupgrp6i6IYXlt
	LM5YWuRgo2Bof47/Jq0=
X-Received: by 2002:a05:690c:f09:b0:797:ab90:8cd7 with SMTP id
 00721157ae682-797ab908dfemr77487637b3.51.1771257601638; Mon, 16 Feb 2026
 08:00:01 -0800 (PST)
MIME-Version: 1.0
References: <20260214084514.2842745-1-haowenchao22@gmail.com>
 <aZMAVF1S1kP5Gny_@thinkstation> <ddb0d3f8-a617-49a2-8fb1-e6293f376030@kernel.org>
 <aZMEvl7WUKyxmgIh@thinkstation>
In-Reply-To: <aZMEvl7WUKyxmgIh@thinkstation>
From: Wenchao Hao <haowenchao22@gmail.com>
Date: Mon, 16 Feb 2026 23:59:50 +0800
X-Gm-Features: AaiRm52fIgXASX0clklIgIwAP4FMcTQwHDv3f4RKVwgOcf3J2gFBYLnGQkTPJyY
Message-ID: <CAOptpSNMx7moZnLP1Q9xX_6zw2xJL4OV4N=f8rzyZBLuTMEJnQ@mail.gmail.com>
Subject: Re: [PATCH] mm: Add AnonZero accounting for zero-filled anonymous pages
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 88cgt9ifuhegd4ypqzxbuu8bkfpmjgu7
X-Rspamd-Queue-Id: B18762000D
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771257602-500187
X-HE-Meta: U2FsdGVkX1+y4Lp1pTaQx9Yo1pRzUqtaRMb7u0q77A1gklk7ASqAuNYtc50pgipezaeNEzs4d6+umXI/hghbieGP9nTp5FeQrPmZRFZtvZERJ4j7B90bFi6kusoWsBLbKsX770dun+NcA9ovZFT+nwCjTalYtD6tiBjjWySsFAw5dWtSDkzk2J6dUy3Qn6GljhOkN5iZJpCWxjwbOXM4eRtt6b0QjVSfhg7h5JN4yRnY944Th1E3Pn+oWpTvntCFLtjoQd9deAtJJ1IicaISKPGkwSZOC9e3LKh8g3YxnWVa5pZ1KKhQ1F6WC2n+4HjWGlvuIBoDLMer0dmMXRi0rpBwtZHYW/SSNq12QxeCKCYrJr+NdbJ85hUPYfg7JhDZoLruw4BfoP0Z/RFaWgqAX/56Sk+53bAVDnKxojgt1e/mDpzQk6jbv5T73pf8Z/qM29i/aKlDdbfnoePM3gu2agpUFrZRuCQw4GHrVwgNGQn89SSRoAFsianMAR4U26oT8Fzg7HltShuqJ54BYfdOBoUGfoMkkWuSUjjGHSK/YHCmQVnCkh8W3jVE/G5LwKjpqUc0q497GR6vMUKWjuSlJHs6OOaY9lOOefcFjBBIEF+gSkfDzw1pdBUmXPWSZygczIh19SBK07HJutx7dKePa3UPB5pYFWyriUqIHrlobS6kHyYw3usev2io6PJpy9CSsQF++YfCJ3v1mtLJ+QK7iSh0D9M9hlW8bQ/QQZpVJkZDlvxF4ZxBQDkZA1jXdNu6USuHb4iIzfBWsDiLCvsCLIiC04EKypEGpbuFX40KxQ0QY4L1hti9LPBF9CRuBiTa4PSYByx5BUgVOpS5h990zN7WbKoEJqIyI9evnphR5EoWzuGgMc+iuWMRGbs7y3YnnzRn+cCVGCVJITwtUERvp+N0q3m9FvQc65FrIb5GdtFHqSW+VKCv0yWPc12pJZ5frT9nY5dD0KnNqqpZg9Y
 N18RypBx
 SPdGsI5zmoFXs3rs4VyNvc3aGqQBOlbYrGljzrSBUg+gC9CTi7lX1VaHA6VbsjST+7UCPdCyO6rJR67SyLOsaKrGjHnTNpRnT0ewx2DbofBgnXawGJHy/iUiB8vAHpEG78YSkMe1t14nAaf4tmW3RQIp1DkyytsiuXOlZuGiGgF/YfTMbp9z1FrEBE4yuTpv6GNlyP171hNz6PdGCpCDIBCiqKWHSdfO4krIzwegnlNwjE+Yj1X08S2ddaM0b19Vb74sBizWijmimpImhpPzsq7ronxE+hIJ71snPtdNYyf3kYMd7LsbAyiUh2vf+vrzAVqzguND1HqvKat+HYNrGmzkr2eJMPHKEXpGq7t7vyuiiUrdLnSG5VkNo5FbY/FYulio0Guyy66k6rJ9BxB77bYoCOA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 7:58=E2=80=AFPM Kiryl Shutsemau <kirill@shutemov.na=
me> wrote:
>
> On Mon, Feb 16, 2026 at 12:45:13PM +0100, David Hildenbrand (Arm) wrote:
> > On 2/16/26 12:34, Kiryl Shutsemau wrote:
> > > On Sat, Feb 14, 2026 at 04:45:14PM +0800, Wenchao Hao wrote:
> > > > Add kernel command line option "count_zero_page" to track anonymous=
 pages
> > > > have been allocated and mapped to userspace but zero-filled.
> > > >
> > > > This feature is mainly used to debug large folio mechanism, which
> > > > pre-allocates and map more pages than actually needed, leading to m=
emory
> > > > waste from unaccessed pages.
> > > >
> > > > Export the result in /proc/pid/smaps as "AnonZero" field.
> > >
> > > I expect it to slowdown /proc/pid/smaps read substantially. I don't
> > > think this line in smaps worth it.
> > >
> >
> > That's why it's enabled through a command line parameter.
>
> One users want the stat and all users on the machine pay the price?
> That's a poor trade off.
>
> In general, smaps scales poorly. It collects a lot of stats and most of
> them are ignored by user. We need something like statx(2) where user can
> declare what he is interested in, so kernel won't waste cycles.
>

I initially considered two approaches:

First, exposing the needed information via smaps. This does incur some
performance cost but is the simplest to implement. The new feature can be
dynamically toggled via a command-line parameter. When disabled, the
overhead is negligible=E2=80=94only a minor if check, which is insignifican=
t compared
to the full smaps cost.

Second, adding a new system call or extending madvise with a new command
like MADV_GET_ZEROANON. Userspace tools can then use it to measure
memory waste from zero-filled anonymous huge pages.

This is slightly more complex but minimizes system impact: environments tha=
t
don=E2=80=99t care about zero-filled anonymous pages pay zero overhead when=
 the
command is not used.

The exact implementation approach can be discussed after we confirm whether
the upstream kernel needs this debugging feature.

Thanks.

> Kernel cmdline parameter is the wrong place to declare what stats you
> want to see.
>
> --
>   Kiryl Shutsemau / Kirill A. Shutemov

