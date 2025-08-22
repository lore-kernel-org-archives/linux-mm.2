Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEE55CA0EFA
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 00:24:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00B66280001; Thu, 21 Aug 2025 20:24:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFD8E8E0056; Thu, 21 Aug 2025 20:24:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEB9E280001; Thu, 21 Aug 2025 20:24:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C98BF8E0056
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:24:29 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5B5821405AA
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 00:24:29 +0000 (UTC)
X-FDA: 83802497058.29.9276686
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf22.hostedemail.com (Postfix) with ESMTP id 67ECDC0009
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 00:24:27 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=e6po8DxD;
	spf=pass (imf22.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755822267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sCSTC0WIj5wZxnOAo09AXpNhmufPIU9VpSHbeth6h8Y=;
	b=G6EciCjG7UjRG8JMm5nsPegfCiW+vQbsiozn7jgc+2CdXisJP6K1X2OlvLyd3QKsc0iJH5
	ZhiF2oc2Ot78BMNcCL9ljyBPhgJ3FacSXPamk96bbuuOEp7NQpdTu6U6tlTS17WNIoJtEh
	ZK1fjsiFAuwZ5nhvQ+OLMjB2J/ZI2j8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=e6po8DxD;
	spf=pass (imf22.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755822267; a=rsa-sha256;
	cv=none;
	b=Bsm9Q0Jv2izqAn11V1BWXGUj8y+U9yIJHofbQubUNzNOQbUh42A8HSeWRZMAq4v0nUyVij
	6P+qHT6iYjQIUFGB4VEpj8aDamJu8yS1X8QX/6fneXX+RgIxMVMujswNPDwH1KN7NVDLsC
	HsvXfjJLXxa+3tUfDDRAYYI8jwrZHbk=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-459fc675d11so17125e9.1
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 17:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755822266; x=1756427066; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sCSTC0WIj5wZxnOAo09AXpNhmufPIU9VpSHbeth6h8Y=;
        b=e6po8DxD/2QVMKQ7ya7BcWmqplQDwCW1h6ATkNsbuK8DiCvcLMtAI50os233E7jWMv
         BIIt0yiaGdHBDudGFRUFNuwdwHgNAIBs283NsAU1HTDFvKtoIhClKghvowpDHZ623vjj
         COBLZD5KdBmCBfv23EiMSYN+jhIpOpGN7EtTCByDyR4Sn5/Os6Qsi/Y9pBGbzI1FwUB/
         Nc2rzSbmr5ppektgtVrXG8GS/aosC3G0KRrQJqVOFjyJZP3+Hq6lOQoQSJlL/re6A35y
         RE8EBZdPEXjrCmkD0MZYpeKl1gRo3zlLlChxh24DqnMqQmOB4xexuLlzlPxNnrkYa7bG
         irFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755822266; x=1756427066;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sCSTC0WIj5wZxnOAo09AXpNhmufPIU9VpSHbeth6h8Y=;
        b=rj/73vEpN3U6zhbSlhg180ou5M5jS7uYD/mLwnmShqs6URI3arVQez07kUq3wEKBNI
         XKujG0ejUeRzl8Hnt3IsRUx9G1wVY/p9UNN+YnrwsVBgqibxmOavXoC6cFrXX32C1Z/E
         m493kU4yz3JVkT6cbbkAmKiMLVxv92WMmsLePHddpRJnJh5xLZIl0gEDeThJ0WiQq7U8
         40ZcFyb4rxWZ/Qr8x52txgMa4CODM8il2A1Tv9Ath95BzdvJxlUQ7KzP6nHv66/UY1dn
         ruw20YD1x1V03MTg/vcjJiXG4HOxM3/GvXzo9holA7nHX26t627IOp+AR7ui0t1a6lXE
         vWsw==
X-Forwarded-Encrypted: i=1; AJvYcCVUq3KeQf9myew3d8FStY6R6HkVe3MnEs9dttqkYvt4as27srKFkunJJmJf37JsTGRMPIcJVEMkmA==@kvack.org
X-Gm-Message-State: AOJu0YwzPg3RblaGHsn0aiRlGk8mMk5T86Zn7AhFX0V35TXXVp8x9v8A
	KkR0jJmOahSqb2jqRMGbzj04+eSfgB+ilGSMkL3ssqsBgRERS/HIzmuc29y3YJED+WDEigzNQs0
	Vz+GCXDAQeqI7f7giulQXMZYraYKVL7vKUoWeO+Ud
X-Gm-Gg: ASbGncsjbosMW6leTnCaV7+9/fCUktdZq1n5T2IRppNVOjgdPMZ+/+W/D+g8LfyBA+e
	KaDqQt9SUwNlbA19VykAM960Cyj9+6Knhds4Mm8DyfyMti5AAw8OwTZsN1lvg2aah8lJ6iNsQlL
	j2eF/geg6DXxeS+M+g43Fc124oTMXN93UkoaLd/QFMB+IntI1yQKA46umzZkjyRvFD7Y/1uM850
	JeKCQJa+RYf9pxVgIs4DACJF81UxIj465a1mYNbph0y
X-Google-Smtp-Source: AGHT+IGH3NeXHDM/VzClhYP4trwtkdeO3+yJ+kVPFdTAwoZ40UPilU+wF+IASK3XljS4g/6haDSsaWYELnnhb5+t924=
X-Received: by 2002:a05:600c:4b9a:b0:453:65f4:f4c8 with SMTP id
 5b1f17b1804b1-45b52119e54mr240435e9.3.1755822265590; Thu, 21 Aug 2025
 17:24:25 -0700 (PDT)
MIME-Version: 1.0
References: <20250821164445.14467-1-kyle.meyer@hpe.com> <CACw3F53KmKRJyH+ajicyDUgGbPZT=U3VE4n+Jt3E62BxEiiCGA@mail.gmail.com>
 <aKd1K3ueTacGTf1W@hpe.com>
In-Reply-To: <aKd1K3ueTacGTf1W@hpe.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Thu, 21 Aug 2025 17:24:13 -0700
X-Gm-Features: Ac12FXxEDY6SrAotIEMY6iY0lvmtqJulbKla6z5zGMm5JvGnSkWnazlZYTp7qjU
Message-ID: <CACw3F527M-x=UeB0tN_sjCgp_YP_8yLkVRCLP2dLO2bzXrqWsA@mail.gmail.com>
Subject: Re: [PATCH] mm/memory-failure: Do not call action_result() on already
 poisoned pages
To: Kyle Meyer <kyle.meyer@hpe.com>, linmiaohe@huawei.com
Cc: akpm@linux-foundation.org, david@redhat.com, tony.luck@intel.com, 
	bp@alien8.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-edac@vger.kernel.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, nao.horiguchi@gmail.com, jane.chu@oracle.com, 
	osalvador@suse.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 67ECDC0009
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 4oyibdr3edzmsbgcszaen9oh71mt11nm
X-HE-Tag: 1755822267-365309
X-HE-Meta: U2FsdGVkX1//PCLCLDt3v/1ZYFhvaJYmNL6YhseTGcGwv/5F4ye+cuHrFzhn+pmIZ68NPsuGnl/fy+9K+d+Hao5ZqzJXLGx3FIaBahny5TWWOlw4MNT7JkvIKMjMo4IwZ0qs6YbpGxaaYNyeitFnHWWgFi+Z7p1kThy2L4YaOVZRcM2YU6btg1xRNOy4ISbkhqGF8cjGNPcRhMGLgCBgefA0vpofbkTqNdXNLpxiEnfLa4h3PNTW2MexcCb96vh/CgPMscOZvmJRIKIek+q+8JlXq37QgdUy8X0BgQxKLvhfpZelFNbefevddt1iS/xK8GRWPawS/ZIG9PYPqabziwBg9FL2pXnGy82qwW2hbazFS9rAH4mu/WMKosDfcp4FKCRTP/BZKgfCUyTkPQXUGAge1nMRrvlaZ79ppVcln0F0xgTX5g/5UlNAibDxUnIJYLNvl+GSaDS9WR0ElBuO38Ae13mdqu1PhZLlYYSrPFmGc7v9SBgi+xAsYEDzPZrrqoFDNggp4k50qOXNWVpuWcBfBIQnqH7qIy2kgEkEdSv+jf+WAy8Hgs6/0AZl3V8Z5AzTsRMRfKclHxz7RI6paROW+KZWLsup9OucyRYKa6g+k83W6e64eT2XttDwaFj5u3czmynjrrhjAWR2lka7bYpax232vrfh4PxNuIvxgkdkbV6iLUkFl+CertATqNnp4vjmwJw0YtJI0+VDx2z/sZF3JvWiU5WISoGIGCfx4ATaXQFXZG0cmlUvDcSMYMAWTlsucncK5QW/TaehDlyi/vgvXC6UtgeclD8+/S2oMCY7SwoC2JrMvl/EdWFoI65dmyMYgg+xOMdDoVk9UMjafGLg6jiKNW4MUVbnkWCQeQp9h2pi2UyQEHm54CVCcuUfWEhhnePwylQPNo3r2ziJvQcEUB1xMmoMYtA3kKWfku+5TSOu6QxhT1Og63RHLuF4JON32Wz9LPOYLquVC/S
 S8La8L+Q
 nVRqs1bHH3vNyrFdDnFUfj1Greo7bfVN129DFIRDjrNwGwJtlieZ5DV3KHYlrlLRT0hnQ5fCBy4pc7u8uEC0OmVhVoQ3Wj0GGPv4Ay/OPQzeH9fto6joTjI4wkouC4zFwwLC7PrIhppoSvJ/tbrbAFJyeY5U2iIGcrhmFxK1dZuU69o8XHgVO/QqBe2CR5wChS+0xRelJMncLL2F82foW9x0nQzEhdq30qvAlpNDh8KGqUP02BxIYXR/X5XucUunrPRbcsygp4kN2GQoQNg7Wx7Rnol3Q5c7eHyYoLZHjryId3ZYyBovIzpVxr6htTN19lkd2Gqv/mzFL7LU3atbk7Sc2eA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 12:36=E2=80=AFPM Kyle Meyer <kyle.meyer@hpe.com> wr=
ote:
>
> On Thu, Aug 21, 2025 at 11:23:48AM -0700, Jiaqi Yan wrote:
> > On Thu, Aug 21, 2025 at 9:46=E2=80=AFAM Kyle Meyer <kyle.meyer@hpe.com>=
 wrote:
> > >
> > > Calling action_result() on already poisoned pages causes issues:
> > >
> > > * The amount of hardware corrupted memory is incorrectly incremented.
> > > * NUMA node memory failure statistics are incorrectly updated.
> > > * Redundant "already poisoned" messages are printed.
> >
> > All agreed.
> >
> > >
> > > Do not call action_result() on already poisoned pages and drop unused
> > > MF_MSG_ALREADY_POISONED.
> >
> > Hi Kyle,
> >
> > Patch looks great to me, just one thought...
> >
> > Alternatively, have you thought about keeping MF_MSG_ALREADY_POISONED
> > but changing action_result for MF_MSG_ALREADY_POISONED?
> > - don't num_poisoned_pages_inc(pfn)
> > - don't update_per_node_mf_stats(pfn, result)
> > - still pr_err("%#lx: recovery action for %s: %s\n", ...)
> > - meanwhile remove "pr_err("%#lx: already hardware poisoned\n", pfn)"
> > in memory_failure and try_memory_failure_hugetlb
>
> I did consider that approach but I was concerned about passing
> MF_MSG_ALREADY_POISONED to action_result() with MF_FAILED. The message is=
 a
> bit misleading.

Based on my reading the documentation for MF_* in static const char
*action_name[]...

Yeah, for file mapped pages, kernel may not have hole-punched or
truncated it from the file mapping (shmem and hugetlbfs for example)
but that still considered as MF_RECOVERED, so touching a page with
HWPoison flag doesn't mean that page was failed to be recovered
previously.

For pages intended to be taken out of the buddy system, touching a
page with HWPoison flag does imply it isn't isolated and hence
MF_FAILED.

In summary, seeing the HWPoison flag again doesn't necessarily
indicate what the recovery result was previously; it only indicate
kernel won't re-attempt to recover?

>
> How about introducing a new MF action result? Maybe MF_NONE? The message =
could
> look something like:

Adding MF_NONE sounds fine to me, as long as we correctly document its
meaning, which can be subtle.

Let's see what Miaohe's thoughts are.

>
> Memory failure: 0xXXXXXXXX: recovery action for already poisoned page: No=
ne
>
> > This way, all the MF recovery result kernel logs out will be sitting
> > in one place, action_result, instead of scattering around all over the
> > place.
>
> That sounds better to me.
>
> > >
> > > Fixes: b8b9488d50b7 ("mm/memory-failure: improve memory failure actio=
n_result messages")
> > > Signed-off-by: Kyle Meyer <kyle.meyer@hpe.com>
> > > ---
> > >  include/linux/mm.h      | 1 -
> > >  include/ras/ras_event.h | 1 -
> > >  mm/memory-failure.c     | 3 ---
> > >  3 files changed, 5 deletions(-)
> > >
> > > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > > index 1ae97a0b8ec7..09ce81ef7afc 100644
> > > --- a/include/linux/mm.h
> > > +++ b/include/linux/mm.h
> > > @@ -4005,7 +4005,6 @@ enum mf_action_page_type {
> > >         MF_MSG_BUDDY,
> > >         MF_MSG_DAX,
> > >         MF_MSG_UNSPLIT_THP,
> > > -       MF_MSG_ALREADY_POISONED,
> > >         MF_MSG_UNKNOWN,
> > >  };
> > >
> > > diff --git a/include/ras/ras_event.h b/include/ras/ras_event.h
> > > index c8cd0f00c845..f62a52f5bd81 100644
> > > --- a/include/ras/ras_event.h
> > > +++ b/include/ras/ras_event.h
> > > @@ -374,7 +374,6 @@ TRACE_EVENT(aer_event,
> > >         EM ( MF_MSG_BUDDY, "free buddy page" )                       =
   \
> > >         EM ( MF_MSG_DAX, "dax page" )                                =
   \
> > >         EM ( MF_MSG_UNSPLIT_THP, "unsplit thp" )                     =
   \
> > > -       EM ( MF_MSG_ALREADY_POISONED, "already poisoned" )           =
   \
> > >         EMe ( MF_MSG_UNKNOWN, "unknown page" )
> > >
> > >  /*
> > > diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> > > index e2e685b971bb..7839ec83bc1d 100644
> > > --- a/mm/memory-failure.c
> > > +++ b/mm/memory-failure.c
> > > @@ -948,7 +948,6 @@ static const char * const action_page_types[] =3D=
 {
> > >         [MF_MSG_BUDDY]                  =3D "free buddy page",
> > >         [MF_MSG_DAX]                    =3D "dax page",
> > >         [MF_MSG_UNSPLIT_THP]            =3D "unsplit thp",
> > > -       [MF_MSG_ALREADY_POISONED]       =3D "already poisoned",
> > >         [MF_MSG_UNKNOWN]                =3D "unknown page",
> > >  };
> > >
> > > @@ -2090,7 +2089,6 @@ static int try_memory_failure_hugetlb(unsigned =
long pfn, int flags, int *hugetlb
> > >                 if (flags & MF_ACTION_REQUIRED) {
> > >                         folio =3D page_folio(p);
> > >                         res =3D kill_accessing_process(current, folio=
_pfn(folio), flags);
> > > -                       action_result(pfn, MF_MSG_ALREADY_POISONED, M=
F_FAILED);
> > >                 }
> > >                 return res;
> > >         } else if (res =3D=3D -EBUSY) {
> > > @@ -2283,7 +2281,6 @@ int memory_failure(unsigned long pfn, int flags=
)
> > >                         res =3D kill_accessing_process(current, pfn, =
flags);
> > >                 if (flags & MF_COUNT_INCREASED)
> > >                         put_page(p);
> > > -               action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED=
);
> > >                 goto unlock_mutex;
> > >         }
> > >
> > > --
> > > 2.50.1
> > >
> > >

