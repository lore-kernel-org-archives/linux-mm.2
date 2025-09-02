Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B960FCA1007
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 23:31:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20A588E0007; Tue,  2 Sep 2025 19:31:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E1A48E0001; Tue,  2 Sep 2025 19:31:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F7E98E0007; Tue,  2 Sep 2025 19:31:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EFEB28E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 19:31:14 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8EA5E119E47
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 23:31:14 +0000 (UTC)
X-FDA: 83845908468.16.8F51EC5
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf29.hostedemail.com (Postfix) with ESMTP id D790812000B
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 23:31:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dskJEvnU;
	spf=pass (imf29.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756855872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7LVBuPseF5aM/yDxSF13Qdsk7UYGzFKIVlH6DW5hLIw=;
	b=mWMYw79xnfZZobUljj+uAviaR8DWeMlr+jefOrf9me9sNvcrcR0Mm+QBJHNGJ1pPjzfqKk
	JMKLwICw6KmGLIbM+Yu/YrfS0/30+nnxsVo3bgstv9wLqSte4hJL3FHXW4+vEZNGQ+36z7
	nlfs7WriY1nEeOAOGuAxNKjKUOY7UBg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dskJEvnU;
	spf=pass (imf29.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756855872; a=rsa-sha256;
	cv=none;
	b=6CTu+DOni2k+jzD4f2tN2at61rESSz4b/ewKJ2Csm6kyVC6rtO0jpyaNEn0OfWr5Vprtzr
	dz9e94h4qfN6YELk9N+QRXMRC7ritRRCaR0U2HynAS0ewfkBxtE8De00kUX3rgtYgEsZty
	z9clMSm5f1jsqNtrECXGp6n9p0QisHw=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-80176a6aac0so40773985a.0
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 16:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756855872; x=1757460672; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7LVBuPseF5aM/yDxSF13Qdsk7UYGzFKIVlH6DW5hLIw=;
        b=dskJEvnUXtMzP24O9HrQIoa5PcZZu5J7y6cQYZpJMpH1galMSo0UTdyAfmQzfA+CgQ
         kfq2T4yJoxfOJL42zGI8IFkOOmbnOXstu4RPw8b6Jks7zvwkOjKiRPhhrXHATP2rcyF3
         +NbWFNwj1j8oR5ocvUB1lORPIPOrTPO7kbICndAQZlUQAIr5NaksdYRELY0K5a75cpEz
         m0SMr5TLSmyOiHSou0NNI07BH5bWm158flfS6v1dv5GaCYvrxyjonmLSKw4+dX9VFSeg
         l7qYyUmbeonsnO8dcg8hYMTS5eoj1mVlxhUI6a/BmxKYqAB4fZV7wTbkKL+jzeospX58
         nsrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756855872; x=1757460672;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7LVBuPseF5aM/yDxSF13Qdsk7UYGzFKIVlH6DW5hLIw=;
        b=lvePHhj+HgobhL8m8dM1Ku8MB65Cbpe5xPkeT6QRcb0rabyNQe1sjVdUZI0ahNmgcg
         gx4LfXk24w965O2wUXi22X3APxe4ikctIRzYH4mbMSNJy2cSaumyk1zbN0SIt03LwexB
         GSE5gFnVWE2PsFveO2qsjzVwHHnapXIRiVkxVSG9RHUMKIMPOVMCYuvNHCXoc+anKWbO
         8v3ZoQn4SkNqZuz9SeYRBtBhKw2rdlTzgSRGV8+SAhjKaTgIh9rL/qYL4u/UK3mcrY3M
         Di5502kRZoOR/jitwiFQYKefPo4xeEzuRjw5iPrC09b1Q3pepWaxCeUtrttK+R8KVYDy
         z7cg==
X-Forwarded-Encrypted: i=1; AJvYcCVCgpIat9yrtYFJOiTz3o+X8P7/ZWhjp/LjfxFVif/fQ9oKOpxbtVkYO/gXayeTFyXPCWQd9srF8g==@kvack.org
X-Gm-Message-State: AOJu0YyBUNEA/egZWh465leOzBrJpb9X/0mHQ7B128oRS05lI6LeNPYM
	bB7/WztvkF+aISxe8ueKC9gJg2oKMur+DstGmGZBbXi6300+60cqIg9gjkQqM/ZCdBXIrxW13n1
	8D8J/r4/A4tLFmaysxMF8YJ+4QbFH8NgbbbZL
X-Gm-Gg: ASbGnctXMaGNFtkSdP+D2ZIJhm05dNFLwP9QynVBXqwFB5g2f3EPa3xRcE7mfba+O4X
	eYb9iGp2NRCN9SNKxlC25QcRgKUnSC6kn6Xi99lB0bbznpzN5q+lPKpHXlrRV9HYpdp7JfhWoX4
	4s3zMW3WBTbReHzJQEAXWQznHu+xeLVsMvEn3qDfp2vqnaN268Ku7KgtxLEKWJFPuOoJcaAmLKP
	3IXPnqBf56ByApX0A==
X-Google-Smtp-Source: AGHT+IEJLw9qpc3tQQ8vy9ZMUJY17lV1WyVh4e91TjneayFN+zbp3fRwAGsuY4KKA7CdFz6YwO9eM5ggPcvXrrsIiVI=
X-Received: by 2002:a05:620a:29ce:b0:7eb:afd9:463f with SMTP id
 af79cd13be357-7ff26f9fc12mr1347288085a.7.1756855871751; Tue, 02 Sep 2025
 16:31:11 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-9-ryncsn@gmail.com>
 <CAGsJ_4xON7fYg1VvcjLOsgBb_Wp4ruC+vdA4Q496GH1jXunU1A@mail.gmail.com> <CACePvbUVK45uRPVoO3ubDfQHikebSHFNQOsMTMvJ91QQZH2HwQ@mail.gmail.com>
In-Reply-To: <CACePvbUVK45uRPVoO3ubDfQHikebSHFNQOsMTMvJ91QQZH2HwQ@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 3 Sep 2025 11:31:00 +1200
X-Gm-Features: Ac12FXx-yZJov-6VFLojy9utawTEbZVFjq9fGBjMlLTrZIwLwdL0r_i7z5HV2jc
Message-ID: <CAGsJ_4we4ZfNqJ+v7+=0hjNKLakJ-s8qtRsGo_kp0R_th7Xvkw@mail.gmail.com>
Subject: Re: [PATCH 8/9] mm, swap: implement dynamic allocation of swap table
To: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Hugh Dickins <hughd@google.com>, Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D790812000B
X-Stat-Signature: ias17r9mii8zkpnapkcmy193yxx4nwx4
X-Rspam-User: 
X-HE-Tag: 1756855872-190451
X-HE-Meta: U2FsdGVkX1+lgUo1dw6JHR82MnIhmex4u0c9DZiNhn6YRpCNup5Ejb8sZi7iepLNHJ9nIGM+DgnH361dYMY8oyHVihm+fuKHsyNKLqVuOOlW8AXtuZzbi9lWEg1fkbMrsT3wyq7m8L+ujIHM/RNQ2Xmmfcu2nAZH8INooxCXyZTYC+wFx00QibATypVuzTug1kRa9iEmiaU7Op5Ip79X6xgC2wpfMsUvzkPMJKus387eQd4xYViLXCT+R3AGBK0J/15FLRXRR+b1tS4dj8A9BksOFaeyhjYRGvJluEjrs3TYFRh6I2qu/k/4l7uFvLLKAr+7aXd8HdFnlQ2Bo7REFpsj+bbXQzgLWTL1+NXnZaqdQ1FcztkaRqrjx9pgBF0bnEU1v9cRjifrM7UHrX6abZPw8G/mbftIC/fX7n450CRcfW3MJ7mV3kFg6BcQuZepBkVc62AnBWT2OMRsACx5FmZBQYtRVM9lX3le5K7ToadXRPU+jzrRpYYcFyfFfCS3+DIM2jxYqNhxMW3AWgEavINgwCV+R5NbW/NK8ja+norFrJxjCzl1zD6ds0JJO0hO1A6JW6nbu5iTcMfT/25d3tr3oX+olaY50lTaZh6ErHRdYbsMGVkvoUHZubWPOp0Qv89OhAYNlZKtkg8J8U1yZRBvXr4rx9Nbim82YCAFCnPb8w6bSA+VNJM3IclhwLkK6mxSHcriF/Miib9IL82cluttwOL8NU9CCSrPCAA6C6MJACCGZc/EnNspFf6kU7DIW5vmEWEP8L5Yk4e+oc+qt9lPqpkPvM0ryA5tdcljm+TVDoxe0ZbVKD64QLL4XPwT/bvp+rPBv6hI/Sr0Ku11dC/nbXYyo8yPCJdQoA2PCu8w3yTgGMamtvzMRePoRYZzvyFR5XwJErTx/b49tPHrGIK2rTcbkYRaoNOt3/eMjCUG8gY+XQV9ea/WTTO1I8D03P+GuhynxLLuV/08/qv
 WW4FIpzC
 +8JfCW/ViLr7Q4Uw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 3, 2025 at 1:17=E2=80=AFAM Chris Li <chrisl@kernel.org> wrote:
>
> On Tue, Sep 2, 2025 at 4:15=E2=80=AFAM Barry Song <21cnbao@gmail.com> wro=
te:
> >
> > On Sat, Aug 23, 2025 at 3:21=E2=80=AFAM Kairui Song <ryncsn@gmail.com> =
wrote:
> > >
> > > From: Kairui Song <kasong@tencent.com>
> > >
> > > Now swap table is cluster based, which means free clusters can free i=
ts
> > > table since no one should modify it.
> > >
> > > There could be speculative readers, like swap cache look up, protect
> > > them by making them RCU safe. All swap table should be filled with nu=
ll
> > > entries before free, so such readers will either see a NULL pointer o=
r
> > > a null filled table being lazy freed.
> > >
> > > On allocation, allocate the table when a cluster is used by any order=
.
> > >
> >
> > Might be a silly question.
> >
> > Just curious=E2=80=94what happens if the allocation fails? Does the swa=
p-out
> > operation also fail? We sometimes encounter strange issues when memory =
is
> > very limited, especially if the reclamation path itself needs to alloca=
te
> > memory.
> >
> > Assume a case where we want to swap out a folio using clusterN. We then
> > attempt to swap out the following folios with the same clusterN. But if
> > the allocation of the swap_table keeps failing, what will happen?
>
> I think this is the same behavior as the XArray allocation node with no m=
emory.
> The swap allocator will fail to isolate this cluster, it gets a NULL
> ci pointer as return value. The swap allocator will try other cluster
> lists, e.g. non_full, fragment etc.

What I=E2=80=99m actually concerned about is that we keep iterating on this
cluster. If we try others, that sounds good.

> If all of them fail, the folio_alloc_swap() will return -ENOMEM. Which
> will propagate back to the try to swap out, then the shrink folio
> list. It will put this page back to the LRU.
>
> The shrink folio list either free enough memory (happy path) or not
> able to free enough memory and it will cause an OOM kill.
>
> I believe previously XArray will also return -ENOMEM at insert a
> pointer and not be able to allocate a node to hold that ponter. It has
> the same error poperation path. We did not change that.

Yes, I agree there was an -ENOMEM, but the difference is that we
are allocating much larger now :-)

One option is to organize every 4 or 8 swap slots into a group for
allocating or freeing the swap table. This way, we avoid the worst
case where a single unfreed slot consumes a whole swap table, and
the allocation size also becomes smaller. However, it=E2=80=99s unclear
whether the memory savings justify the added complexity and effort.

Anyway, I=E2=80=99m glad to see the current swap_table moving towards merge
and look forward to running it on various devices. This should help
us see if it causes any real issues.

Thanks
Barry

