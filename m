Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 660F1F45A19
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 08:34:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8B1C6B0089; Sat, 11 Apr 2026 04:34:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C62966B008A; Sat, 11 Apr 2026 04:34:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9F5C6B0092; Sat, 11 Apr 2026 04:34:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A76C66B0089
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 04:34:49 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3B01E13B946
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 08:34:49 +0000 (UTC)
X-FDA: 84645614298.28.52159F0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 452E6180003
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 08:34:47 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="CSF/JNNW";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775896487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jRUQi4i1xA2o1RTW5OrGDepLB52lvZpCsLr2BKB3rIk=;
	b=oIVT0TLM9Lg71ic/8R5+Ntw21pc5X5eLhlpDWWOCNYs24OXoJVFA5lX43JrObGSjYgY8BC
	8i6+KtMpBVe132/gwDf+pvpOT+HOBNYX3vUNVPefAw1E74/5a961JHCVk2nHdqga4qbyiM
	Mb2Ajt6EeGzBbU3b9UCzcUg0yCEDPt4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775896487; a=rsa-sha256;
	cv=none;
	b=QxxYqHqIt2VWC0hUuz8k7F1imZLjGZVrRnb3YTnBkLPYMAkE4aInyx6ePV2DnW4UAEhJTI
	tc3gVQjd3eKD7NWi0Dd8CBkUEFANOSowGU8HO5ZB3ppO5gs0GKcmUckai1kvqXRK7K8z0M
	5DDg9/x1ejUdwwL9j4fHwovDYntmWpI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="CSF/JNNW";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 098754452A
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 08:34:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6BF6C2BCB4
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 08:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775896485;
	bh=DyLwqEKuL5KjE62apaGDYRhTFIbG0PtD0EFlCVYwDYI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=CSF/JNNWVwUIaY1xWB14OJy6Zk2UQD4MbZgxqg57MgnDkG9l10IgeLnTtnnoAitun
	 DqZ2QisMMxf8NHO1XGqfsu+UNW+06MGObukefV6OIRHrxuNqjLqvsdYUb9iqzjTrmH
	 fzM/4zjGFWIYkZ6YAucJ5GbB5y8mncJ3ONFxb9nL1YRwRY3hX4kEIB4XyazpBybiDX
	 SIm2UoWViqxhypNEF9v2eGOmdwjF1qM24YtuVRLglsSAosKKljLT6E8sJQa2oC/1C2
	 NT6V5efZ4zBuQzVHpxDiKwUujYqLODp1oxjkgTLnr5odB/EGVmroL0abcFrBeNZ0Bi
	 3eEOtEoFYS95w==
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-50bbc41677dso38745381cf.0
        for <linux-mm@kvack.org>; Sat, 11 Apr 2026 01:34:45 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCX3PeWUitxujoLzuVqCWjvgDrZfCeiT6Y3XWGtT1Sc4OCMpRN27jB89JNLm3TxRDVv2Enb4AaL5mw==@kvack.org
X-Gm-Message-State: AOJu0YwbJh4flyXsntMA6L4VoJcqv6ZezCWJq8sNm7mg9BrDKVEnt1B1
	Fjthez43dHrto9hY8e85ga6p8Jta2igEz8JhV2+fPE5gkyJTdMddQJ3BMuQqSldlx8nZC7LRm+a
	p/hmgisWn4tRpqYdlPbbF/T+r/aXif+Y=
X-Received: by 2002:a05:622a:13c9:b0:50d:912c:c2cb with SMTP id
 d75a77b69052e-50dd5cf4e97mr93506381cf.42.1775896485079; Sat, 11 Apr 2026
 01:34:45 -0700 (PDT)
MIME-Version: 1.0
References: <20260411062152.2092967-1-lgs201920130244@gmail.com> <CAGsJ_4wLSLy_vZjGYiJpTEOBXtyTTTVdTr-wW+sKKb5b0S0Bhw@mail.gmail.com>
In-Reply-To: <CAGsJ_4wLSLy_vZjGYiJpTEOBXtyTTTVdTr-wW+sKKb5b0S0Bhw@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 11 Apr 2026 16:34:33 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xjwA3juUUJyUPgMyYfo7VB1BTejTDyDeQC5=QK+=yTWg@mail.gmail.com>
X-Gm-Features: AQROBzAxFAwPtnvyQ5Fnb7CV7PLVzXzgQ7HWh1trE8tDGJlU8llE8h5X1dE7giE
Message-ID: <CAGsJ_4xjwA3juUUJyUPgMyYfo7VB1BTejTDyDeQC5=QK+=yTWg@mail.gmail.com>
Subject: Re: [PATCH] mm: thp: Fix refcount leak in thpsize_create() error path
To: Guangshuo Li <lgs201920130244@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 452E6180003
X-Stat-Signature: 8kq8uwqdmgepf38cuoueqjitcimeepq3
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775896487-536428
X-HE-Meta: U2FsdGVkX1+0GPg5q3E/iXwRMNw18/1t0kD2PGy412/aHl4RL+8XOKZHqQID8KBIeKsk/ewFlEll54zaTkjHYeu4kdJncs8aAJ7baJt9yKWpcmMIy2CNpqECKHyZ6+2yixLPslQnkdmuRspMiOvXzkJ91ni1IMIkR2iFNkEO/2TJSmqyFZqQ62uyYFidD2JKn/dzpf0Xnn+2j478HVV7QX1Rdj4mIzJ8H0n9DJ70F/Bkz/FtGVE0i7fHz3E4Wn5f3Ov17ezFdNQ9cIY3cknBea6MOOmmoBWh1WXB0KivxUvOAiAWJ6aZu1momg7hlVS3D5leI6ItttxxLiRn6FRMwZs6ukIo83ETnGy+FfS3zwrlSeFehxcpd1hpLTqa8KhCoogL74l0qOQS23ICrkw2fTcLRHKju64GQmLmcaOWo+jPTA+NBlShGsxwWOBm5CJZ5x3gzDq1v+7zbPqqGK3qaID5rEGSmwomptg5tfNk3PS+dFJ8e+wERxmORhOe+54kPUJE1S3tQlKHo0QAqn719QaX1tRFOgzWCMwM2Ey/2Hn0jIZ4DAOiQZSspPGhks4QZqz/sf0Jl4nddrcraO2uTWUVhZUJ8CaZDh8L4T9nsIgCzu/2wUtOhbov5PDOMzV8+dsw8EW0nhKmufAHCdBgmL/G3qw/7NIY5nZCXeQJdnhGHk8qJmyBnOX7hiUh1aSIXvOfRn21ccKnrfvypOFJzHuzRgCaoMTXBiexEXavipW+szHCzuyZbZ4E4rqW45Q30yrFMt5sJLfUB9G1q5aPgLFzVqoqu2ytut+OSdwXmKdEC9raAdk+Z6/Rt1KF94lw6M22mEo3GEGH9hsyhgfc9o4kFKenPr+DZ4jfc3365Inmgtc7q04oQidkzP/G5rOwTwpd3AH036yHly3g7t0CSKhie4QEyBQ6HTRjfaVQjo5D5Gvj8N3BgOvbGeZnUQSOKzYEHYZ/4da6OXWUMLG
 KtiRx+DZ
 0GsurEP8tqTtgLagse/N4aKD97tHR1aIGcax5LD4LNI3uZFv7RE2gT2TLwMlXcfWWjooBkRwBPthZDWnrU+2UqA5MiOKX3xDSfambwlzmFdCllJssM1KWCJMLe77ZvHTCeIYd/70LV/U3vgZIQ5xhz33aYfdeZRnRJqHKqIcgNQkbUHuho1avvmJPYijCMdv26vg2veznF4QzNpDjsHKXEzxeSovHztmO4FuBFK1kMkIUXmbfZviGjcJayusoSzWApfwleu6RTSlHwsWhXGbDGU8o/Ow7Ahag+9zITDAdundqan4keicHW7MtZdBrMB6gmPRKVfskisjxDjGnKK3dQLB75nzXj/FVnCxN/l596U+hM1IxSQqhx+L3Z7ltCggiumz4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Apr 11, 2026 at 4:32=E2=80=AFPM Barry Song <baohua@kernel.org> wrot=
e:
>
> On Sat, Apr 11, 2026 at 2:22=E2=80=AFPM Guangshuo Li <lgs201920130244@gma=
il.com> wrote:
> >
> > After kobject_init_and_add(), the lifetime of the embedded struct
> > kobject is expected to be managed through the kobject core reference
> > counting.
> >
> > In thpsize_create(), if kobject_init_and_add() fails, thpsize is freed
> > directly with kfree() rather than releasing the kobject reference with
> > kobject_put(). This may leave the reference count of the embedded struc=
t
> > kobject unbalanced, resulting in a refcount leak and potentially leadin=
g
> > to a use-after-free.
> >
> > Fix this by using kobject_put(&thpsize->kobj) in the failure path and
> > letting thpsize_release() handle the final cleanup.
> >
> > Fixes: 3485b88390b0 ("mm: thp: introduce multi-size THP sysfs interface=
")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
>
> I=E2=80=99m fine with the patch, but could you send a v2 to drop
> the err label, which is no longer used? Alternatively,
> could you rename err_put to err?
>
> @@ -825,9 +825,8 @@ static struct thpsize *thpsize_create(int order,
> struct kobject *parent)
>         }
>
>         return thpsize;
> -err_put:
> -       kobject_put(&thpsize->kobj);
>  err:
> +       kobject_put(&thpsize->kobj);
>         return ERR_PTR(ret);
>  }

Sorry, my mistake=E2=80=94err is still used by kzalloc_obj.

Reviewed-by: Barry Song <baohua@kernel.org>

