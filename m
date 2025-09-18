Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C167DCAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 02:27:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17CE38E009B; Wed, 17 Sep 2025 22:27:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 154A38E006B; Wed, 17 Sep 2025 22:27:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 092058E009B; Wed, 17 Sep 2025 22:27:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E9ECD8E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 22:27:38 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7F33513BB17
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 02:27:38 +0000 (UTC)
X-FDA: 83900784996.01.1CF3B2D
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	by imf15.hostedemail.com (Postfix) with ESMTP id D504BA0006
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 02:27:35 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Zhxh72wZ;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf15.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758162456; a=rsa-sha256;
	cv=none;
	b=sQkPxpl/x0yBdGYogpDJ+iR/mDVC7veZl3KOFtGl7WVBSRZ7xqvDZMPxizWlWCietqevPl
	qLSTHBuEfTGGvIV7Y1SUDyvZgQVVrQX1YWhJBUQG34jrg8in40w9QT5LEpzevqWbKE/4fH
	YzOdCL0+rGP+wcwyBK8y2xIb7+16xQI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Zhxh72wZ;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf15.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758162456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QFrjr7oI44As9mOdavnrOAOtlOzT/S4ln2vJMFz/Qt0=;
	b=6PfOcd0+opoqnKyOPC7DvnUV3Lfb7xRy2jSP4e8BDV4dWo0BgU445Y4uE71Cg6l5sbnF4H
	0QfBkWk3sIpPA5xyQHSoOd0tzNOsXB3jDSG3PUBRPGFgTEkk2Fr/CkPVYkYk8W/qj8DlFl
	k7NC4hgXQM+cs2eJmw+Tmdd3t4kxB5Q=
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-723bc91d7bbso5336077b3.3
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 19:27:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1758162455; x=1758767255; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QFrjr7oI44As9mOdavnrOAOtlOzT/S4ln2vJMFz/Qt0=;
        b=Zhxh72wZvC67Pvgp5UMwW56/BGOi8jzCP6+WO2xHNsuA/bpI1t3eV/3PzK4pM9HksP
         cnnfDCEMaVoxbMElTISWTz5Rzc6NfQy3HEkwgP5DjtYmJeOy60/7kpvBl8Mg5Dtypvhb
         HtYbe6LRwwlu54Y0iZGiQC6tPAa3CVkWU92uPT2rKbOlmqjqOH+8C+ns95xCDmzYnMYH
         QvJXtyNpcI2VZKuykk0qKMvbsyjPVhRIuj2NAMwJPNY1OS106G3n27l+HIb9+CS1HvS0
         z6ae/dCr6pX/rt41AyPzGAaKCMyV3ja/et2UhrqoCwWgkmYauUQllQWmunW5+K648BYQ
         Ppaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758162455; x=1758767255;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QFrjr7oI44As9mOdavnrOAOtlOzT/S4ln2vJMFz/Qt0=;
        b=hZMlax+HDRzG65wgbrijs+3Y76mc0vV8gVhLbHHgYtNH1Gcivw2V0SepMtQZrZiz6D
         Nkx0f3pHKG2dQAwhqqnopUVjkqyMiNvLfyWOhSFDNfXv5BJBQDGaEEk8i2EBGB8FQLhy
         ZnHgHl/F6AMTIckF6jilLnYn0+pyYrSNdRuaVBsGRJ+lNv1zGwoKfzH9D9bIxb0J/wqT
         fXQ64ofwYQlnDCX4k5zaR3r1/DUI0Kl6q7fnoisigpwJ4bmCuXTVX4mzy07R9/PXQTeF
         cf5ckMHFLzSFMnJa2IzBqZgW25zT2zTjhTwpZdJ1C39IkojLstjyrW23BnvwHpgmwx2z
         6O8w==
X-Forwarded-Encrypted: i=1; AJvYcCWGQOf/FniX0BXCqMI/A7wAxwjsdtsLDMKRppZNzI+og+PE3u0Hr6B0nae9y1NkGoT5Dzymbs8SkA==@kvack.org
X-Gm-Message-State: AOJu0Yz9ycEYu2yYB+iKFPxaDV4spT5D8ir4hZULIhqhOX4KtxTDDqxW
	hlp00GBZIFjDe5V3FIlkeLMV/4SB06qusZB7lU6ZWhssO9m5ZwW0MFO9cwfJIn78ReKdumTSzaT
	Kp3BY/hW5jKfRVmeH3BqcA85lgnnn2jWMEA0YxFP2GA==
X-Gm-Gg: ASbGncvek8hDLaLbu/kYA4Lucsr7buPOid9dazO0l7WVom+csWIaYVVpFsIf9lqD8PT
	N5onkEwJHrv6j5KHnnmPdxJt0FRu1jbrolwHlRx0vqTVbAMDhYvg5OdOHoFOMbn8WO4CJ7oZ4xu
	vDLdJ3EK3uunI2pJ7CnLfvx+kHcNgOuZDg5494UGfotHiq8WBMMVkpXUVgdug9p7sll/fJZ9384
	P3+Bo9mUJXH/pMC1qMkyybe1C97wN1VuSxpht1BkcWPqA==
X-Google-Smtp-Source: AGHT+IHr9JgnFjpeT/zNs9L7BOU9gS2fjyMz5QFUAEpR4RhWUaYl+0KPaeqk8mPlazZxDIMzmM/v0qD8tnH69VyiLAo=
X-Received: by 2002:a05:690c:6f83:b0:72c:bb8e:3d70 with SMTP id
 00721157ae682-73892a45ec8mr44504117b3.47.1758162454739; Wed, 17 Sep 2025
 19:27:34 -0700 (PDT)
MIME-Version: 1.0
References: <20250917212959.355656-1-sunjunchao@bytedance.com> <aMstLw_ccoveLow-@slm.duckdns.org>
In-Reply-To: <aMstLw_ccoveLow-@slm.duckdns.org>
From: Julian Sun <sunjunchao@bytedance.com>
Date: Thu, 18 Sep 2025 10:27:23 +0800
X-Gm-Features: AS18NWB5MaYCMMqfKrJS9g29_klveZt2uzpxurqlqJahQN9eqVnilHG-fNbZMeI
Message-ID: <CAHSKhtccroAB_MJ-Dz0KgKgZEOfMdqdtZZq428tULMBv2hU4=A@mail.gmail.com>
Subject: Re: [External] Re: [PATCH v6] memcg: Don't wait writeback completion
 when release memcg.
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, jack@suse.cz, 
	muchun.song@linux.dev, venkat88@linux.ibm.com, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	akpm@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D504BA0006
X-Stat-Signature: d6cn4x6h49byczep7fidenj9u81w9fid
X-Rspam-User: 
X-HE-Tag: 1758162455-928428
X-HE-Meta: U2FsdGVkX1+8Dt2hUHlFfO1aapxYs2zXqiHCkKBuwWVETZFDm+ACbuK25xaPrTnEal33KsankkGplNEBzUShufEuIN0Bwp5PiQzjGjRgmT8VgTFI8YtaSRFQsGVWgcNz8FXC0a9B52bjYfeMGPDgG1k8xVn2aVHzX/w9gP6Z81vcPRvJ9l+WxMSomeWtM0made39rP4iS3FdMxwzC0LDgCoUi3WvQbcNoqxeBvYNW96XJ8VJzRlHzKI5FH4epmXLtCYBefbkdAbkvKBwoRnuY1u9L9FMnCP29t5UuTu3cwbLUVgtzT2qnAo7d8xQH3yt7vf/4yZwwyK+1bE4VSivCiGINUnrMf3cq3olFoZsWvHtiqosRWr4vLqxBwpnz/XiqOO7St6K60N2QYZAqLbLJm67+U5aWyz5E7m28/J/hv3tJ8ldRX96KFIZ/3znyRP+WEeeBL4q3TEBoTDfr3B9o5BW/0m8Qa3VtaIH85MLjREH1f+XK8DMZ/ISJBwxnf3YNYp3i0wQZusWErn5rfmXMyC5UxjQCSFlcRFzBe+7zp9o/PMqKjWX+74GKQRGpDkewIhRoZmQXXEi9yMzfsUb4KjBVPAqEUVNfRNuuC64facsMhHQ7cQVGjPrPuiNvpl18tLjq/GTBzcCqxB56EzvgU21twvxc8VP44aW+9bkFaUHU8kpwKe1BlfsEhA0ui66NAeYFOKLFQpACQo5hpIh1nZIOwcfoq6Ndrwkunp73wNLKWwycm5Eg04knLtRe4nN1s8ypS4L2hWSSSBFx1THsN+w1rgVM8m+WrI+5u0Zg9+cgRf8h8KgvbTl/tno69Dos57C+CJcKUPBsyTuvwlMvPdHB87H4XcESXCHW6TmJLWuBIY7pwHGlKdeNnMPXKkzbfpWu6xZ8KoiBtWZqbGcQGpF2QHM2jjBBEfp0xPFEhYL7QS71TsBQctK8X539/iJrR0k+AxKXBQhzNLZpDn
 dKaeSxFW
 QwBcNm6FnEUT+mfdWYrd6LqaD6wzmG5xbTFiOshFu/e+AfZYer8MvaYahlydUdydjEjeKg9aBod9jy1hOsYnmg3gkLjOSW+0VzawKdLc94TSJS7P1wDVeZ+2BGjBtuErT7Z88xYYhkLVnaqsybscg4I9a9MKH0jxAsl/AXV8sRXqdu5mD1iK63qmbGPERYUprVDuF+JKp1jxpJDQYsY9xKVOVcpkp5mCjXk1fZVXnIDXwXWgaN89iTmf74pKh/7uWTbwHa7Q4uTaqFQ3JBp9Zdn7kNw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Thu, Sep 18, 2025 at 5:50=E2=80=AFAM Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> On Thu, Sep 18, 2025 at 05:29:59AM +0800, Julian Sun wrote:
> ...
> > The wb_wait_for_completion() here is probably only used to prevent
> > use-after-free. Therefore, we manage 'done' separately and automaticall=
y
> > free it.
> >
> > This allows us to remove wb_wait_for_completion() while preventing
> > the use-after-free issue.
> >
> > Fixes: 97b27821b485 ("writeback, memcg: Implement foreign dirty flushin=
g")
> > Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
> > Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
>
>   Acked-by: Tejun Heo <tj@kernel.org>
>
> Minor comments below:
>
> > +/*
> > + * This structure exists to avoid waiting for writeback to finish on
> > + * memcg release, which could lead to a hang task.
>                                            ^
>                                            hung
>
> > + * @done.cnt is always > 0 before a memcg is released, so @wq_entry.fu=
nc
> > + * may only be invoked by finish_writeback_work() after memcg is freed=
.
> > + * See mem_cgroup_css_free() for details.
> > + */
>
> I'm not sure this gives enough of a picture of what's going on. It'd be
> better to expand a bit - briefly describe what the whole mechanism is for
> and how hung tasks can happen.

Ah.. I think explaining how hungtask occurs is a bit too detailed and
verbose. If readers want to learn about more detailed content and
causes, I think the commit message would be a better choice...
>
> Thanks.
>
> --
> tejun


Thanks,
--=20
Julian Sun <sunjunchao@bytedance.com>

