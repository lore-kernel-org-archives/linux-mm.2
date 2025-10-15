Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D210CCD192
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 12:36:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 935A98E0025; Wed, 15 Oct 2025 08:36:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E6E68E0020; Wed, 15 Oct 2025 08:36:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D5A38E0025; Wed, 15 Oct 2025 08:36:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 67C6F8E0020
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:36:10 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 21785564E4
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 12:36:10 +0000 (UTC)
X-FDA: 84000296100.27.84DA721
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2C23010000D
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 12:36:07 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ai8s2Bss;
	spf=pass (imf14.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760531768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mXqZCy2SyArQfSZB6+/vhy8c6RWAc9H5KTcnkJHJQFY=;
	b=gFcPr7gU+MMV43mCiKlgu6Ou4S7Hj17kzx1W/S82LG0wea3usdIetJbnbczTqMnfxZmnfk
	ZJSdtjCm/9sSedKNd++4P3qugViBJmOl7Gk5GUBzNg1Plnz55ZZLiO3vKWW3ikZJpR7sy7
	enngY0pFhYvogrwt7Y8beYcKM8asz2E=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ai8s2Bss;
	spf=pass (imf14.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760531768; a=rsa-sha256;
	cv=none;
	b=uMuY9qKhhFRLKqgvnWQ0Qv3AXqDzathVPtyxGUG/TU9NLR3h3CPENdLRLey+UJMMhC0OUK
	PDyPGtKsThIOERHtdC7KMnJ1l3fpGylIL9ADdail+t1G5GImbECyKlra9j4XC1nHPcRFjG
	wGa2NOdFkH1znxkV7VFdtPZsmhvYB8M=
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-58120c35d47so1201027e87.1
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 05:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760531766; x=1761136566; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mXqZCy2SyArQfSZB6+/vhy8c6RWAc9H5KTcnkJHJQFY=;
        b=ai8s2Bssijp0HXEWvdtltWyExhqj1VMuOvR3h4z6sUFiNwCFebjZIc5LCJdgRn10oV
         d2vVfsUpCC+e0uwk+CRuuGxlgXp7C71DrJAhTn+YSvIsMbekR2YpKCWbXPGBQpO84gc9
         Nmre9kMuK7+Fb14wwkFZ5+XfALuFui0T16rpycoEvJhJOCc8qXtOWaiY60WJOcGy21Ff
         YI9ETlHsXbZYCUqXqGi9Ta4wTuperBLC3eQQlPe5uc1CmmACk7q3pn/Tl3R6RHbqwawP
         2U+iPCmUq2DHGc9i8RFwlWgFArBgU8GvwariG2wnC66VrtAscBcGTOhtc0eP+FATKOhc
         v+JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760531766; x=1761136566;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mXqZCy2SyArQfSZB6+/vhy8c6RWAc9H5KTcnkJHJQFY=;
        b=ReDM790U2yw5IXPVoGRcBH2R6yqM6NNcb+EGRBs7I2drNhnJK7d20fn+PK/xouk2bV
         eEXUDEkOk0SCyGyP4BHLxrJCLEKIFm+6qvlZOSYAxG19M5po+sg5ODCiLiRXNwSgfE1V
         j5luKZdyB5KFgV28KPPlWbh2PUxdJx2We+OkIVNlHztfsHYmB7qSdKVWmP+b5KBs/+Pp
         8QzRj10mPSoPkpUNhWH3kazdVe7TGwnv2Y1CQCLZ66i1yQXHkd5jjqW6TkZLlAMBQn8L
         TiEi4D4N32gSp9/diPV9L8lvE/1OiVq6odNbZEeyiOUxExYiZ+bIl/6UNFBSvttstCAO
         WGdA==
X-Forwarded-Encrypted: i=1; AJvYcCXdiUYroWysvFza62LUtN4gVZFY/k9ngE+7ia9BAm1p+3chY2T/1du1miDm0OYSyWdUyqHF8CjshQ==@kvack.org
X-Gm-Message-State: AOJu0Yzgt9x0N05HJRAhGm5SCOEgshCZcVVSSj7PJi4ShuvtZ8PDslpV
	o8gGqMfKp5yaV8zNu8HRI1EHAhhKvHpptpJtss0vG9hvOSSRBdgVgHhN5KtVy8QkSGvSX4z4Z/A
	kqdn1+971xl7ZRk+mOGHDFZX9f7kXJRo=
X-Gm-Gg: ASbGncuucJn/U5J6BGTcvJGVDqS6+6dHSvhmV7SDt8nWgvwMvLn6fRCTLjCi0iKjnBx
	euUAQjHjSeSCDSXE615dFLlgYksi0iTUf4gBiwgffTHD6sJMbAYjxlDvIAZZ+pRzkmyXplw8NSQ
	CpzcA56cDQTcgYC60VkeXAm2+Nf8XZnWBq22RUkC8WyFYbHEwovgRD7iGYasrgcruiHZqh8vUt1
	e8QAGzL2j8t7o4NZFM/A/0jnW2aFl7DfWGJcPLBHc2rliij
X-Google-Smtp-Source: AGHT+IHpJJ3i4VE7K63V7qp2FsxwGna5n/UOWX+WqUQGecNnl4cdq5PAcjc23PWmzxHfk1E5P7xRzKbuz8NuSN92NCQ=
X-Received: by 2002:a05:651c:f1c:b0:36d:54b3:9f75 with SMTP id
 38308e7fff4ca-377795d5fe4mr5645081fa.2.1760531765871; Wed, 15 Oct 2025
 05:36:05 -0700 (PDT)
MIME-Version: 1.0
References: <20251014083230.1181072-1-zhaoyang.huang@unisoc.com>
 <20251014083230.1181072-2-zhaoyang.huang@unisoc.com> <f807f3bf-a05d-4e0f-af4c-bb0167dde51c@redhat.com>
In-Reply-To: <f807f3bf-a05d-4e0f-af4c-bb0167dde51c@redhat.com>
From: Zhaoyang Huang <huangzhaoyang@gmail.com>
Date: Wed, 15 Oct 2025 20:35:54 +0800
X-Gm-Features: AS18NWBHy47J7vqNuZdMWmFiioMnHOdN9PsD8vuUcKjXC1NTUEoBMVAQrHP3CgE
Message-ID: <CAGWkznG=DAXz5s1gAcs9=OKJC0v0KwB=FK=mKL-c1DSw3jGqfA@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: call back alloc_pages_bulk_list since it is useful
To: David Hildenbrand <david@redhat.com>
Cc: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Mel Gorman <mgorman@techsingularity.net>, 
	Vlastimil Babka <vbabka@suse.cz>, Sumit Semwal <sumit.semwal@linaro.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, "T . J . Mercier" <tjmercier@google.com>, 
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, steve.kang@unisoc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 2C23010000D
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 91b4adphumddgab5zujpuwcz958h7r3u
X-HE-Tag: 1760531767-156091
X-HE-Meta: U2FsdGVkX1/iVBMLeotcIKgT6IYSZ/FxfJ80hb66iZll4YPWy22Qjs9nDDr16O+R/WR5O3N7ThokfHdqPi8uuJvyKXxRA6hm/aA0O3HgcxIubi83XMZKXzzZeUpagTIYGCh82B9ei3b0icORs+iBG7min19Iu/+cV+8qNGojwnXN8OJPo5JKibUDRV6w8NRD66W1K4U30Ps80+kUG0/AU2OWaYRBn9BlVbALKd9foGtZgb6ZI/7g1zl1cDwhxM9MphZSkgjjevn9FwyfmEPYdbeHTWC8gEDxu/vyh+KLdGMjSPe2THbyZY7Sf2XKtEagQ63tw2BPBRJtwFK4dt189jLDz8yhcLOtHPxX6Tt03V03Hcje/yy7DHHSZXs4DJoxAM1ah6e5/lg2IZ5gTWRNn5MFOkATxBnCMbbj6J3Z4ImBGOaqgQiixSnoXuCkiVPEEowGV/UU0nVCKjTUPnwI47GnIfyA+Q3NUYaktaQXB6GUMfdie3uYVFuoAxpjL7TLETYwDMc0Kb1/Tvscdp7hoo/nlgUbeub4C650sEmvNelyWspW0hdbK4rnRPX1GS3LJ7yF6hU0WyZPXPTSGHnyQnaPrViMNHfBUe6oQlbkVMU9Z+HVxhgO39zMyVtaaUnVXOK4HD17uNyCj9r7+QCE2YGgttlIKF5F+xALgyrS6i8M7qMwrEAs7GQr+IGzkUHzuaOwnFBs5PuRvTy8wL3AVIKtQzWgJgw5fgeYUXndR3WOgQTwURfvifcItPob4S8qYIr8sS6Gc3UjFGt3k1hgseGzgqYZ4VgYks+vG+AAgM9wowjwA80MeEGXDuDYjo/5wF7XVrZRaCL+/mtj4YE8H2zovrw7GTYvJxkogvZqWMvCgHm064Y7zaqj7r3iHYEWPxQq90di5ityBVUHUT76AawPLd4Rs2JMB5qkIpZhJFyx7CZGZnFCg2/t97nZLkbalVwGZ4KItv7JRCqG8Eh
 g9IhtX4c
 bKY1DuyUlGxIpD2sSVGpqI6J2tQcfJM9mZ5k/HLOKwWZx6bYZhf9FYVjYz+NI68vdyZUPGmLOTETMyowNPK60bFvjwz+pPvtgGJ71XvzOKfumuN38eM00jaMDO7DPjeWuZcuRrKIwQuPZUovYMlkQJKl5rBWxU7VhZyIIA0yCVY0qnPL3VgN7J0EWE+y+//vJQlOhLr+d0mR/fxVPpq29zQUEWy0VuwMT3jbmPMn9U63rwz0Fak+3Yd43ZSCjmWSP7KGSU3KJYDnKAwRhI/PvW0wwR+8qPkfRfl1uFeXCpS6bRjKjCOb2dse5AekgUEErt7JqPwJgX0bM3jDHY1aHHgyEKvyVI2kz0dRIsuZV4KRM6pjpFC3zyeE+WA0tfrWy8IIlsQjdkEW21pntRE5gk5NWH84okOisYl3ApbRR1Xwv9pm7xHek/LIKKN+8TODa2K+pzrZcOqj9RHD3hxLqOZz3W0RXQWxgOEQgVZDN4DB4w94=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 8:16=E2=80=AFPM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 14.10.25 10:32, zhaoyang.huang wrote:
> > From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
>
> Probably the subject should be "mm: reintroduce alloc_pages_bulk_list()"
ok
>
> >
> > commit c8b979530f27 ("mm: alloc_pages_bulk_noprof: drop page_list
> > argument") drops alloc_pages_bulk_list. This commit would like to call =
back
> > it since it is proved to be helpful to the drivers which allocate a bul=
k of
> > pages(see patch of 2 in this series ).
>
> "Let's reintroduce it so we can us for bulk allocation in the context of
> XXX next."
>
> > I do notice that Matthew's comment of the time cost of iterating a list=
.
> > However, I also observed in our test that the extra page_array's alloca=
tion
> > could be more expensive than cpu iteration when direct reclaiming happe=
ns
> > when ram is low[1]. IMHO, could we leave the API here to have the users
> > choose between the array or list according to their scenarios.
>
> I'd prefer if we avoid reintroducing this interface.
>
> How many pages are you intending to allocate? Wouldn't a smaller array
> on the stack be sufficient?
Actually, dma-buf is the main consumer in android which could occupy
half of the system RAM(mainly by multimedia which passes the memory
between GPU and display, camera driver, NPU driver etc). Dozens MB is
quite common or maybe more. This commit is proved to be helpful in the
scenario of camera APP cold start which allocate around 300MB memory
in an 6GB RAM ANDROID system
IMHO, page_list could be more efficient than page_array in memory
perspective which is an uncertain factor than iterating the list
>
>
> --
> Cheers
>
> David / dhildenb
>

