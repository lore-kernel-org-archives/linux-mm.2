Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94043F8D757
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 15:23:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D010A6B0092; Thu, 16 Apr 2026 11:23:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB1A56B0095; Thu, 16 Apr 2026 11:23:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B796D6B0096; Thu, 16 Apr 2026 11:23:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A371F6B0092
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 11:23:47 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 53D5F1A08DE
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 15:23:47 +0000 (UTC)
X-FDA: 84664788894.18.EA52002
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4E1EA120012
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 15:23:45 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=S3EJSYTO;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of mclapinski@google.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=mclapinski@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776353025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b68ONNVu+A9z5YiXqc2LhLMiu8RR50d90ZOohhHUFtk=;
	b=fL0TLnseZUuZ+pj/s5ifz3YK1uZZpdcwivgcu6Q+Io9ciCKb8/3+jdeM9+WQrUxDY48w8I
	tzUEPE9If8lDzNmKu9eCH7cn4vIhaLQkLFmH6zHYuGpSn9Fyo9VrCc56g8KOo/5xStGVBZ
	oqGuObSBbQ8lqvEXcvsPZvc9eX2SKDU=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=S3EJSYTO;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of mclapinski@google.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=mclapinski@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776353025; a=rsa-sha256;
	cv=pass;
	b=f3S9uNgh/B6GwGtNX9/oy91jRACXTty6xAydQWedVreX4fWrxCJFA0XeC468Zpei8Tnj/N
	IulJYUM/KOSLqg2KyBM5N+bvvC9NOnFwI2eoH50mze9Lk7BQWAolYpj/KXMYcJHvSembRa
	0jLT9PpDiQBEDvn+nygsgEpB5FxywlY=
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-126ea4e9697so7575c88.1
        for <linux-mm@kvack.org>; Thu, 16 Apr 2026 08:23:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776353024; cv=none;
        d=google.com; s=arc-20240605;
        b=YFroEOBXCwH8LrxcqbqUDBU/XoAcYQmNgppMgWfZQD3PV+MedqTcwqMTFgHoH213ye
         h1AzWVjrc8O5pzDTiDX0Td9qTbq0SnBvF8r9M/rbnuo/jDMGJIbY+StBHkjTCk1TNmDd
         xjtAOgjT6WaG/QoNi7eZ70mSwji6CYbCFejsibpP93kHQ2RBuEP6LVbi6mTsKAvFs1nA
         cCG8tkT0KdcMrNEveEv/2fbCGHXpjxSLSzP2V0Q8sXyammyquFNrLJQby+n3fZRCIAak
         nok+K24QaVU5FcRfgZatBZqS3iZXSuRXDjI3m5VWM/U3TWlttJECtixSYLOnpperPRG7
         a1pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=b68ONNVu+A9z5YiXqc2LhLMiu8RR50d90ZOohhHUFtk=;
        fh=H7evBPqhs8+Ig4/r991/dxkf5DRHmVG2FTme7EVtkRI=;
        b=ghpsGBensXRLIM8h85nHaUFpXLyAp7Xx5/Pfd/pDGipE/8wKMcejMsFSJZ8e4jcr28
         vWcnuzyUXyNopoS+5BcPKM/fNTiXZENlH9juzm5RayPuVJkqlV7c3Hr7Qx81NI44kq+I
         ULQk7YG8VwcdTxkjGDm6OGQTETASztbzS4fOZ2ea+QUpzwbq4WP2tkp+FwgX9451GRno
         xT3O4g0kJ0nmTlqoOA9akoYROifi0pW+pgQjV0XqVgNyTHyN+0+kcQVWMymAX9LxkgCF
         trmkYKHwcTFNoT0bN1OA+gm5pwGn8QbeUtjysZLSeIjSm2uaXJoXa9/ztGxrFwie4QBU
         7IrQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776353024; x=1776957824; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b68ONNVu+A9z5YiXqc2LhLMiu8RR50d90ZOohhHUFtk=;
        b=S3EJSYTO4cfCQPZ+Mz2GPn5+o0jCX82l9prZkW8HtGlJ9bGdsHwpUaFz4H7Ed0wrdN
         vGN8B/LyrkkHjHN9xn+H4bE62iy2YNLgBLYKPw9E7ygosbe3rEBluH4hFDSwV1iAejFE
         qV7FoUfSqQfoY9VfDkh21+SwS9Uh7NEbkBHNC6BX8BpRfj+kTWH3OkvAFjHXkpNyy7OS
         UF7mVi1FnAf25IePeg7cWhbTdBvhXKX90jvqtn5dg70rAcaq+PFXQs+KlH5tTJxn6lf/
         svAd73SPaYElik8rLoeTTwWSAHc1bGIoVsGXp4625Vasxh87wtzZ7fndXASqk9G8bBLU
         8JtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776353024; x=1776957824;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=b68ONNVu+A9z5YiXqc2LhLMiu8RR50d90ZOohhHUFtk=;
        b=k4URK5z5i42Fhh9rUZOMbx2DN3e0SPlvbqjvLSEkoT3BoWBxvhwSiU8QwcaKFLNAyf
         tTV72B3dxmGNAHIPznx87fVtT8XkyPUSLcYZwOlN/+yj2bQZM4I7cVuKzfSWb7JiulpL
         E433KstpJZQq3wx88vsXV9HBHvuRWL1pM9Zcu2TEkC6VGOXCeXTAF9zdnJIrAI6k9IKN
         2iBdcbzl/trWaHo4nLE85lgIpRKYkirM61d3DKrSpw5xplIqPLXMMcy5YA+EG6APnRL4
         PoFD/uIa3tJH13yNmRj8yPzvF2qqdN0GESHy8KR93WmkYPWb3JU7c8WcX4QeBnqFGbzZ
         PrBw==
X-Forwarded-Encrypted: i=1; AFNElJ/G04urxm6m4EIglwa4RMYxTsnBmlstQTc4QY2yuRW4PvOqAOGPhKOEiuQ3BaVba7CNgnwBilB/gQ==@kvack.org
X-Gm-Message-State: AOJu0Yy1FKD1dIneEPyajH4c1v+ODzCVk12zdjWv1uf+ppzPVT+43/2p
	NYyefIfFA56X3GN+0Vl311RrbUsnKZFZZ5RPfQDTHfaG3Wi2l9pVAGTouNLqXdYmUNt/UtNnZqB
	C+1Pjy+esuT4RRPTuZpja22QyP9U/DAc51oU4E4CP
X-Gm-Gg: AeBDietCZxlWsaXIsvjFXXjf5psx8bqSr1HpQPISV0gA6AFPwQp+/YwKaJaks7Qw4BT
	COjsVtmIDKJSpP0fCU+6fOYyr45RluaJ4h3S5ZvQGztkQO/OC0icvBuu5vq8LK5x7vE3oZVGrlQ
	AWVGLLFPHuY2JYocQ0PBZJLyHyvgSEQ4GQJ0pUSuh927AlsExAy/ak6j62hKSSjNplEZlokXzlQ
	s3HSaD3tBWZTbD6VJFD2qsfZVrDi1qrVtxyaAw4NkY6UXRmj/CkAuZ+B1a3A4ZJFBk/ZuKAZMvf
	jIGDmTAQfQWs9H0gQMLaZ7MUmMEAXooDxEttQHS4BpKFhO0MGuOLToBpRr8=
X-Received: by 2002:a05:7022:6b94:b0:128:ba6e:f809 with SMTP id
 a92af1059eb24-12c636c86f6mr184550c88.6.1776353023426; Thu, 16 Apr 2026
 08:23:43 -0700 (PDT)
MIME-Version: 1.0
References: <20260416110654.247398-1-mclapinski@google.com> <aeD5kboEdzwuR4P_@kernel.org>
In-Reply-To: <aeD5kboEdzwuR4P_@kernel.org>
From: =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>
Date: Thu, 16 Apr 2026 17:23:32 +0200
X-Gm-Features: AQROBzAD7ws_4z5SDd0LjpAlZ33XQQakBVV1I13_nXLGtUXK3uD9T-fFc-Ww5TY
Message-ID: <CAAi7L5dFaxwoU5dho8sJJ41+SSwgrmXW_NjQZnn7UPzj0zoowg@mail.gmail.com>
Subject: Re: [PATCH v8 0/2] kho: add support for deferred struct page init
To: Mike Rapoport <rppt@kernel.org>
Cc: Evangelos Petrongonas <epetron@amazon.de>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4E1EA120012
X-Stat-Signature: 47zoybggmoz469dbks9cm671aru6ot9y
X-Rspam-User: 
X-HE-Tag: 1776353025-212625
X-HE-Meta: U2FsdGVkX1/C4bi3bYZyzg3JaxlTl0Sfu3vsECHCbdwDgmi54Fgjm76Uusn1jhDLOZvsDIhCUqkRvljTEpqj91qImeIix4T3FQAbGJm8YpGh7qc8asxncC/6aRYq0Hb0sZLVIBK0aua4ItVlGTQ3833hxPcQ/m/jJFoiRfLLLFLrQgXT59ef7DPQpxE9azy7+T0b46mUWsGJ+dK/OFcYHDzVHuhkf1BiATnjhp71gW/0EFueli9WlH5a0rA9CyWZC3Kbn9k4K+eOM3/JIGWRJsji1WnJqGhtUIVCvg1aGlIZ2TJys4/3i96lKesV6L+v/r2rF5EN+3D2QysTX6tde+ZJWSZA+PdfhP3mdS22cqX8W3QT4Gnp6Spclhxd9G9w7h4VAZNu0bwiwe+9QVowGKCXTdYL9p5l4cjXEKM5i8LXQ6iCNOVs89Ip9/KbO9tv+uyN5oZpVRPVmCNDflPTW8CI+usGNAmwjD1wFtMUQDm+KSxi6psCYE5Q/VEO96Bz8i6XO5KkRp37MVRPW8/iekCSrCIgV3Y4nIWVGlacQNZW/eHrgH+y4QGwVHGCYxvHVvkL9QJ8Pfg1fXnmKerpgmAvNJwGR1Vr4P4MaXEzhK8VSNzELYMfjC4YVPJDzguSiUgXYdatL1VvLigYx9Bai3nHjFvu5axPka/YM+Xfp/M/diajFR6KUBlvrYY48thdgEUVaXGLZLoo5eUwmjkunC3O7QnKkFW2psXse4dHihItgRv68KbUZY5wt157KcclLD+5Z8DDjgc1tWq8VI8rJ3xHveM4r2IL6FK8dqidEDHZKnjP2yg+J6mPfLrslm8uLJkGow/FFah/iiNogql6PKFVZtBteUR3ZEWlR5rmISO0JkWLFXzq9lPTo9D+K8nhKrBQF6+wWZ//J393MX6f9pb+SGNWRkvwMNYc4QHBfw2y/kUO8N0Vje90uH6lxuy9VpcQ34LX7TluucqIhyB
 G4wlO9NU
 LLJoz8GLBEOeXwURJzqmIspzWHXia9d9S+ArPm3PFaS3ZfuvsKX9sIycPvEhWkoLjP1qcERiPByHSeJXRh+XJFNmUEq7E7PA56wn95FaLLaZurH7kC3AJ189sD/WrzASndnyr933yeF4K1Iv4c4TYis8SI09cge1q0EHAfc8DFhZ4YYh4Hix42GrDDomP2q8vpAXu57n4tKre0xzZN6tv72YofDIW1X3pn87X2P55xruAz2KcHpDT8mUc29tAyoaeA/S9U+X2ad9HbHEcgIpfQal2obvA9fN0hGU+o3mRImOYEv2oGqWnf6zSI4j3IVFAWJBH8lH9tyx8nLWc0f0uz/HFDVaXlLVVeyAAJjE5Nu5VmqGBH0OaZM9amOe9KedIut1D
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16, 2026 at 5:00=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Thu, Apr 16, 2026 at 01:06:52PM +0200, Michal Clapinski wrote:
> > When CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled, struct page
> > initialization is deferred to parallel kthreads that run later in
> > the boot process.
> >
> > Currently, KHO is incompatible with DEFERRED.
> > This series fixes that incompatibility.
> > ---
> > v8:
> > - moved overriding the migratetype from init_pageblock_migratetype
> >   to callsites
> > v7:
> > - reimplemented the initialization of kho scratch again
> > v6:
> > - reimplemented the initialization of kho scratch
> > v5:
> > - rebased
> > v4:
> > - added a new commit to fix deferred init of kho scratch
> > - switched to ulong when refering to pfn
> > v3:
> > - changed commit msg
> > - don't invoke early_pfn_to_nid if CONFIG_DEFERRED_STRUCT_PAGE_INIT=3Dn
> > v2:
> > - updated a comment
> >
> > I took Evangelos's test code:
> > https://git.infradead.org/?p=3Dusers/vpetrog/linux.git;a=3Dshortlog;h=
=3Drefs/heads/kho-deferred-struct-page-init
> > and then modified it to this monster test that does 2 allocations:
> > at core_initcall (early) and at module_init (late). Then kexec, then
> > 2 more allocations at these points, then restore the original 2, then
> > kexec, then restore the other 2. Basically I test preservation of early
> > and late allocation both on cold and on warm boot.
> > Tested it both with and without DEFERRED.
>
> Any chance you can clean that monster and send it as patch 3?

I fear that would delay this series somewhere into v15, which I would
like to avoid. Can I clean it up and send it separately?

> There's no real difference between core_initcall() and module_init() with
> respect to that deferred page initialization, they both run after the
> memory map is fully initialized.

One of them runs before kho_init() and the other after. So it allowed
me to expose the bug that I introduced in v4.

> > This patch probably doesn't apply onto anything currently.
> > It's based on mm-new with
> > "memblock: move reserve_bootmem_range() to memblock.c and make it stati=
c"
> > cherrypicked from rppt/memblock.
>
> You can base on for-next in the memblock tree:
> https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock

I tried that but that branch is missing other commits from mm-new. So
I would have to modify my code, which would then conflict with mm-new.


> > Evangelos Petrongonas (1):
> >   kho: make preserved pages compatible with deferred struct page init
> >
> > Michal Clapinski (1):
> >   kho: fix deferred initialization of scratch areas
> >
> >  include/linux/memblock.h           |  7 ++--
> >  kernel/liveupdate/Kconfig          |  2 --
> >  kernel/liveupdate/kexec_handover.c | 52 +++++++++++++++---------------
> >  mm/memblock.c                      | 41 +++++++++++------------
> >  mm/mm_init.c                       | 27 +++++++++++-----
> >  5 files changed, 69 insertions(+), 60 deletions(-)
> >
> > --
> > 2.54.0.rc1.555.g9c883467ad-goog
> >
>
> --
> Sincerely yours,
> Mike.

