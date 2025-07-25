Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 375F8C87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 18:17:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC4AB8E0002; Fri, 25 Jul 2025 14:17:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C75F48E0001; Fri, 25 Jul 2025 14:17:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B64948E0002; Fri, 25 Jul 2025 14:17:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A1EA08E0001
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 14:17:50 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DA11213407E
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 18:17:49 +0000 (UTC)
X-FDA: 83703595458.30.364CA42
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0E66616000D
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 18:17:47 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gmNDpE90;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753467468; a=rsa-sha256;
	cv=none;
	b=vPpWf30BrNGh0RugqN01CdJy8bjwoW+BMfpJllZSG2bgaWSVLXpHzae08krJlO345sjzsO
	P8GcZeImQdiHcSOGnpDEWp4UZl+86T3b60t8izxOvUDIalVIreG+qCbNzT1mPvl8bl63JT
	QDssVlYPEBWF23/vmcJRCQwC5fGlayM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gmNDpE90;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753467468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LeM7IuoQIkUR4J2lJM41mRdSF+EtBai/uwDsajCHaho=;
	b=hOBCQ2srL8b7an9LRKTu7hrH+2Xq+/LPtu/4F8SBftFKmpqyTOmK57H9G6ObajdJyzna1U
	SDfP/B9mkEiq1aXuBpqw9TN96yGd5LtVZygEBfK9HL4AJsd7NKHcpwsUUv066IBQLZwKx8
	PWdd9e5xwDx3Q2SZRy0SX8H9DzY6o8g=
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-70e5e6ab7b8so22811547b3.1
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 11:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753467467; x=1754072267; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LeM7IuoQIkUR4J2lJM41mRdSF+EtBai/uwDsajCHaho=;
        b=gmNDpE90nu+fTIcnDbC8ZYpbY8BenBmyaREXxjJvf4MTfyWvW3ydxWM3X69cQi7mO3
         x/iGO+IfgSOA+NIY+3X8lUqF4WXj3HU7QGrmK3haWV+ZXxYXUMqe2aR4k1ANonT6YIqI
         nyA2maBosG9KY6NZY8b/o2iZgHz8mZVJn2kJARXjMRUlx3RqTFdKY13dEyVjgOXcyzWX
         AycyuUfY1dylZH3mnr5me9I6oZxa1B7kD8GMUte2cMzallckn8fgiFYfoYZ55//S+Jj6
         R5NZBs+Mnf7j562/M/o9Uo+USdEvSrpFyRJ9DI8VGE7tw/lnasiQNfKhlTptrmbHrAjZ
         kSwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753467467; x=1754072267;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LeM7IuoQIkUR4J2lJM41mRdSF+EtBai/uwDsajCHaho=;
        b=Tv9Ce2I/tX/TSh36a2Pw+XYj/66Mlf1Ioz846dpzo5HwAyvQxbPVysIzP8qvp4VTKU
         rxVVxcaq8sp3rE6LY3qXWTMiQQtr/l5a/QfEt1iYlTFzCYP7/TKxJExn59HrpmW7Qw9i
         DKg1qMirKjK3ii7lv7JiLomddmbsTB4zQxEOWhP0yabsz8DPWZAoBJerwcPKtUuaH8Ax
         62AnpGv/QA1SzmGUCtdldSwAPpw51OkxF8bgG55leD4uDd/0ZQVrYdt5oaioVKr6EnCM
         VJ5M0mRB7LvlE3u4g5Y1G17CiZx2HGL87SZN4Pqzu5qUdspIak874r0nHfyFBLCZ33Bs
         QXOQ==
X-Forwarded-Encrypted: i=1; AJvYcCXldKcqvPFHM37ssjiGrX9pKr4b6jo7zGO4kA/Z7pT73RL1lWisQkL8yLSoVHUtL7AVlr2304AWOg==@kvack.org
X-Gm-Message-State: AOJu0YzPjCl8rHJ4SSFNYh3n3OEZODvRxSSQRbaFEDlmCn4V2UD30/01
	7BGRI1OoqU+J8jSb+5/EQBsITFcH+egDbE4/3JK2esTnTQ+HXDa7G/cX
X-Gm-Gg: ASbGnct+StxEXepVWzfhSz8D7jgiW13TR1Z/h8lh3JrtOv1xkYdBs86sdh0FG+wtfLD
	H/J09pCSqvt9ZMSf8uglJccTdxBODBtr/5CgXQzJccTWga68i07GbORjT/EEI1FsYk0B7M2Vd8A
	3xWtrVi6dQ6ttgbdwuOZAROF5RohFzZy8xUvTh+WUXLHEyf66OGqnIpLQylbwnhJ2OET5JcZAPX
	FdqGLKkxeKfMEYzEhCCcPCh4IGsLq0Wzrvsvn2ZjUFN3tOMSptajvoo9cZ7RB9O0dbdBeJSM43u
	pJ7p5K8XXPILg/ip1D93QxciAcuD6T6bg2ehrwKKNxiL91pwl0hZgJ25L++tdL/VNa51qkuh13W
	UnseaHEDy7DLtVSatIHuUbDX/j9CQlvDX
X-Google-Smtp-Source: AGHT+IH/38TmYy2syg/0GKf0hg71IOf1MWOIAEKCD39p03XO+eVYqErkVKfZE9DTfnNjbia20dJJBw==
X-Received: by 2002:a05:690c:dd3:b0:70e:779:7e84 with SMTP id 00721157ae682-719e341de28mr36872037b3.27.1753467466968;
        Fri, 25 Jul 2025 11:17:46 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:4c::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-719f23e85e4sm823477b3.84.2025.07.25.11.17.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jul 2025 11:17:46 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH] MAINTAINERS: Add missing headers to mempory policy & migration section
Date: Fri, 25 Jul 2025 11:17:44 -0700
Message-ID: <20250725181745.2494226-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <d546df23-70df-47a2-9211-2bb971f8834b@redhat.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: woto6o99dfc4wsf6tapmwtiokhftdcud
X-Rspam-User: 
X-Rspamd-Queue-Id: 0E66616000D
X-Rspamd-Server: rspam02
X-HE-Tag: 1753467467-6279
X-HE-Meta: U2FsdGVkX1+9RxNTI8ZjWH0+QvrZTxFjW2WPqL69684gQjRk3xbetwVKKOxTaAWXmIgk5ilSK3zzsyXz0MNKtNN0WdStrkLxSlhWiqtUKdy9DrfFCdeeNslcf5Obx/RrVfH9OXhTQpOhviZQnvPuSbF2zeBi9eWgi1UgeTK/Jn9WR4PsynYLM0KJW1AhmyW1UjxPjsk9RmPsO6/257aGSAcyGfMBVmWbFpWSvFNtDYzmqFtmucR63rPO9YK8a1b3Vpim4r5M0jh87MAPgL9W2NSqZ4UDA9HRonBfr7X7SI4bnjoIkj+1Dd3PMWnVXCf9ERHiwZwRaJ4pQIDw7sZUpqY8+38jS9O6crsS6gJS1V6YhBh9X3d6qFlHyGlRSPrYzMP69QixOcLopm8t6HEzbJchMY2ioWHRfDoqKHjc882erXFfY688Xb2AwoytS+6GTd3O70ft6ckc1eZ1uMdmeXOJQ84yOafKzuO8p71smCFjUqPfdzyY2D5ShxcFe5jv2GBdtoYLFJ88qKBnmu2MiXC98Wg5Iw5psnbVFbSIesM9xvNTB45vCgAMBrpMdUCZO92Optvw68EQH7/FGGqmF8U+ir3AqmL3uJOvu6zUw5/RNZVNNJ1dULWqnCBzvsf9hi1/w9BA8scQ+fFc+CL8b7VmIV2Tmfh0Ih92p+g2WfW9WJSdralv7Scvyj6914p3cMZ21PQj8lWbVa04+6XlNJiRLQmkhaGRCt7lME8esGo/BhfdLYrCLk508lE0x88p465GnbEt9FQKdNV4yg0j5wpTe7HNU1fksDKEtELRdxOxVi5ZDef1tCBKAIKbxA4wySxNmoOLCBNSPwftxp3sRX6aCl+F0Ku8MKL27djRAwQRiRh1wGI2eIUAaatRUrft7y1Bo3mJ2Jxjfv7ggO6qBS6MrAc0bbsJDwwYOQPgSjxwkWqfWA8+QNZyZiaOuW3nPEo6oxAHcQ2c7HDRnH+
 quOTXBN2
 rxMm0Qv6Abeq13Y8eCKCUu2KTUDwIOv4PCr076zxxuM637ZdSyHXq3UJVyKweZOfduVuXbPeZ3OCHLkgivoXu11JiNh2HVVLARH7rV559whUX+OrBYsZgZg9jb5GJEqMYP+64yVkW6gRhXa1L25itrI4CVVXHXRUK7Ec56Ru60a6Z0RHtB1dUpVtBIAy5QRmBHm4iOHQXbrIsDZqanPs9jkNpqJWmfQgrYHEaDhnTn3Xl7mTqFYH7uevaGlhPKejD3+gc19CcPBeoK96U+oJTXdc2JJec3RRKyOQqt0J5q/ezSPjZO/rHA+BEMZUHGaVtZabixIDB+C5F72mcacOsKbTtD0j1MEmI7A1bgyqU4dQ7Ql0zx39jhHrPphbOnhBh3lRnO9H9/XPEsMY9GhFHmJxSyg73LqmU6y/swrC8tZfIsAGQidxzTAq+L3MZrxt1FGoMHo/hMmSOXGOiUMkebetbkhcETbdzRi+311MSy8C0q17uXtEo9esDhTr1R3uw/Nu/9pYVkFfCR5D2cggYxsvXhOHnazFtrINLstbLveBYUl0W/R9694BTrI9FQJdoIY6L/D0gxGYSuTbRv4Ddb8Qxuw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 25 Jul 2025 20:03:09 +0200 David Hildenbrand <david@redhat.com> wrote:

> On 25.07.25 19:56, Joshua Hahn wrote:
> > These two files currently do not belong to any section.
> > The memory policy & migration section seems to be a good home for them!
> > 
> > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> > ---
> >   MAINTAINERS | 2 ++
> >   1 file changed, 2 insertions(+)
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index a8bebd0886df..dec8db8b5cc7 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -15838,7 +15838,9 @@ S:	Maintained
> >   W:	http://www.linux-mm.org
> >   T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> >   F:	include/linux/mempolicy.h
> > +F:	include/uapi/linux/mempolicy.h
> 
> That one is already on that secion on the mm/mm-new branch

Hi David,

Thank you for getting back so quickly : -)

Unfortunately, I can't seem to find this file in MAINTAINERS in mm-new.
Perhaps I am not looking correctly? Apologies in advance if that is the case.
My HEAD for mm-new points to dd811f4553a9512501205ba8e58ef1a6af4cb291, for
your reference.

Thank you again, have a great day!
Joshua

> >   F:	include/linux/migrate.h
> > +F:	include/linux/migrate_mode.h
> 
> Yeah, that one is missing.
> 
> Can you rebase to mm/mm-new? Thanks!
> 
> -- 
> Cheers,
> 
> David / dhildenb

Sent using hkml (https://github.com/sjp38/hackermail)

