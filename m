Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D20DAC61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 17:22:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8263C6B009D; Thu, 27 Aug 2026 13:22:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B0786B009E; Thu, 27 Aug 2026 13:22:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6576F6B009F; Thu, 27 Aug 2026 13:22:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 31FAC6B009D
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:22:21 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BB8261C01CF
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:22:20 +0000 (UTC)
X-FDA: 85147718040.15.ECE7798
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf24.hostedemail.com (Postfix) with ESMTP id A595D18000F
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:22:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=E+XsjCqq;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787851338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tltuI5yMhdPmNzhZrv3APrkDegnN9eE8RZrbuDy3HtE=;
	b=pnfW+IXOblDr33x4K0O9S9WSBYcUYTxjPSpWRfhyDp18hoHZTYlyVYfqNZi8AohYvM4TWb
	VcnxVZmaEZWNX0kVG8hVff6c3SG8cW9sccB+LkBV7t9a6zMKGbRKI6bxtAlX4jcnS8iwTY
	savO6lNvsOOFzqPnDvh2VYhzMwA681I=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=E+XsjCqq;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787851338;
	b=dUaCVUNARkEMk+/1t1Zch03FhWtrWo6TJ6K8aBz1Bi1BzgjqrnsVQyeOx8WbaYUgiLblUC
	oAqFy56NcQvONX7fMzumWKjNxNz6lX9BeVHeiDjYY8ifYyfsrh7d3z8zy1koVMMaKjUZgO
	JkM56h+ebfIKiLnmg2rWFqGzwNtTvcg=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-69fab5a852cso69035a12.0
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 10:22:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787851337; cv=none;
        d=google.com; s=arc-20260327;
        b=ppgD9NyxN+4sWF6CEMtSrobDSRz23vtT4ezVIgzUR5Vfa2eNd6UE5JO/JhZo1m+OYD
         nrTBLCtpRcO/Jx93fVToR90+pWugE6I2OMIcLpZv0wI6L+TQOThSlo1VpeGBHd4D0Ojj
         1CYOx9/gv+6B2wJ4xiennX1FG/zEK8iCM+nL29hY5utJoyslUUvUis/Pv3NbDQNtZct4
         8R1PM7pPoPwaZc/Iw1yIB31wCL9daAx1sY/U8jzTVGWKS+Pz43OiHhlnRcewj4pmOkA1
         2KHaN1PYlZZ3E4C5rMigQu1PK7UaOia2sTSpckh3ZpRmOHCdsSv+/1nRhpVTJsJtKFA4
         suDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tltuI5yMhdPmNzhZrv3APrkDegnN9eE8RZrbuDy3HtE=;
        fh=9vq877Yc5EE2iYxZ6bU6VLRQqjjS/vaOybjEEYh+oRc=;
        b=jXOtczUgqxB/RxL1+vyiqbRhgGJQj/sI8Uz/foM5542a7APxVOts0JAfd6tcg3JrsQ
         YqHOz0HP7rjdAafnsLlrmDLhnyqJcY37Io1jEQ5e4yqt4cdBWwup+6Wa+cGKPGw1yhzd
         9pOuO1dDeISmHf+s+AsIHAuNxZW+HPngkP+2NRn2O8/nYGv+iP0ar7nGiJzDhFH23xdP
         9fSqcvWWPJiHS1BnhO2NPuttQ/PiGRtLKCcY+xn6iexKHAXFado+6QnR+tl3usg4coTb
         h2Ar6w7fkWPAzmVW8/OHjvHztgXZet5nAmX2hVd8ZI7Gk4mlN/tO0uRoBzJCC4ebZnK7
         vEhQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787851337; x=1788456137; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tltuI5yMhdPmNzhZrv3APrkDegnN9eE8RZrbuDy3HtE=;
        b=E+XsjCqqoJfXse5cTGFHJuFoS/Kawn3BLEtgB6MHMoHW2YVuKOhOjHXlb2D67rXcb0
         YU3MtdlkGn3jRs7fqFccCCINXY1VPL4B93o8EnSeHFPwtn2d2a8qNVeXQIH0dWV5O2T2
         Idln2jLwM7kAnJgonFehWVmX/SLj5+EBvGP9+yCR7JDT8R4SBtaCSsT57pKdbSBQAUgt
         rqFrqq0Y4Mkuu6LYuWcJkSVOUGHM+tYNeCnpcFVYuzBT7+hnsRsgRUPtKgT2856alpR2
         fAyAlrPNx9xXfoJNxvCfLU7lmJiDaJvjsqnyLe9MhH9XkJOETW+3HhQ4VS/Xrx25GzR1
         qy4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787851337; x=1788456137;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tltuI5yMhdPmNzhZrv3APrkDegnN9eE8RZrbuDy3HtE=;
        b=VutCiHh+zwCXokSS1IDi76dJpDwnvfQkjY0MBSQyfYaSPlgNif3OuVKBEDzUSC2ITR
         iQWqZ0bkjzQxCMa1Lki87nmcBFnIHpqqA5xNDbdzj788TkgoQpixwMakbso+cwNmc+jE
         rkbzmEV8BulKXWpeb0/i5dwjpQcS5VFYXdfYyCqCIS9JXssnPHfLFGjhUn1VZBywjIfw
         qrowABiLkTQaPDS8q2e4+MmAQxHtCg0Klcz1/1QCceZbxb2bbXwpk6CY1AmqnZ9tAyhh
         SRy6K47xDt6Dml86pw8zM+UMXUKDT1D6u7DdQ2HpK3qlFZHhTJyZDetn2wIDHPbM/TWQ
         uJ1g==
X-Forwarded-Encrypted: i=1; AHgh+RrtNmiKBVe1ALbgs1fBOdKlFaH7J+EkUKhx+mW+J4GfMi6pxIylXTVWT8z4HPVIcIrPiPFB/UmpBA==@kvack.org
X-Gm-Message-State: AFuF++lR0s1/ROKiHHqyImkaPctRsQxqYF/mDeeVBXWAewb2UAHAYEMv
	/1HKupU3pS0UT3glS8P1JTAKYWUnP+s95YQNx+WpQcb2sABa3qZ2uB8UIjTDVLNq4xNJlUGcuOu
	gQr8Gv3tFfwiEmIpAL+35RR/nIShp3mI=
X-Gm-Gg: AR+sD13UQdi9yqXidVSYDxpNL9GnVWMi9qRcan5vNf2qBMU9WPcTMGtmtVHBJ3k4gxM
	gGpVptuyocMWWVLJx7T+U4NZK8mydScPwPuXIYJ3tcgqmQmx8V7qcspoJioY48iAvLVjTsNUWz3
	VV879l05LILlGQs2jbarTegX3ePTrgJefu+U6ZtqtPTGH47b9UBKWChmRK5sbrYMWa6DiMwEgIL
	B/akVqRoqftlJKiduvFN3tH1wTWZeZvfmee8Mq5WReFL+9vARrAGd0ZE1blUxGpIOJxASCFlT2A
	nsNRJWXAQwqyxTptQfYZJyX/qeTZIAYNVcyUC0QqfsYztxeKpNvqOxM/pY7wCya/SZgMe+LH6lW
	G
X-Received: by 2002:a05:6402:23c3:b0:6a5:f4f4:5c0e with SMTP id
 4fb4d7f45d1cf-6a5f4f45ca1mr5745899a12.14.1787851336822; Thu, 27 Aug 2026
 10:22:16 -0700 (PDT)
MIME-Version: 1.0
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
 <20260821-swap-thp-cleanup-v3-5-9b43f5163238@tencent.com> <apBQqJZ89MHZi2RJ@thinkstation>
 <c796694d-7783-4f99-9ce2-331e1c551415@kernel.org>
In-Reply-To: <c796694d-7783-4f99-9ce2-331e1c551415@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 28 Aug 2026 01:21:40 +0800
X-Gm-Features: AcwNN1XqqM0BAQHr_O9sXhmt_pq-8O_uB9N2siAFg-mlZCN69ElipsNI9_k2JTA
Message-ID: <CAMgjq7CnErLhEE1RSaY=-CdK6WErNedycCD3eRBn_o3edVrO=A@mail.gmail.com>
Subject: Re: [PATCH v3 05/18] mm/huge_memory: rename __split_unmapped_folio()
 to __split_frozen_folio()
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Kiryl Shutsemau <kirill@shutemov.name>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Shivam Kalra <shivamkalra98@zohomail.in>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: u18zqbzntaxpyuyocgy8jzqt9eit7rhi
X-Rspamd-Queue-Id: A595D18000F
X-HE-Tag: 1787851338-157544
X-HE-Meta: U2FsdGVkX1/Z9w5lB43F1ujmMUT6MqGq0hSa+Buto1NGrmuikRNdgufyk7h18IYMTntUHRtQsX+wFMcXhjSnuZNWwcvbhnATPg/Z96VxEqqjZHgbJRLpQnpTiXceWFs/v/dujZlxVrCrPsekTL7G0y7DxiMH0jmwevS6n5Ayj+ApaXcd5zAv2eMn6T9gJuNmBKRqHEmioddFFPKk7gKBTzf61MJiIuCPmJUl98uCZDolg7xLGb3vkxn7zL22yIr0aOHHgVJ0EJp6Yq/d1Vf7Ad0ZbFjER7sIReCV77GmKUnUnu2+V53kz3tbSmZOuULjLQf7kAVRwFRURk9z64rJSwFZ2TugfFtmGQhA+P/YSz+UxEpFQ+4joKYjtpEOVA6mtAf3qnwA+gWL9WuKmfS34+oBtmh8g6nLRkXcTRmDwFiKH/ZR8k+LIOl5OWC8kiZA5Jn+7ILzkWDvGKfKHrmmu6OTioNtW1hxgav1W+zSvFS6PF+zv8BmEKYybM3F7NRIir5DtogISWscXl089RZA58hs7PWxijADw8ELYboFkPW5EL15urFqNtnRsPzACfsTzU6T/yQfe7/TT3hXU2E5yJnyAFEMOTGZN3+rsEbuag2+GkZ6Q3ZqPeJiqxWUno2zQI6XWkPRwtpq2c+LVLwcShAH75DsXrS3mKect5D0iGRgTj8RII/6sa7/Ob0dXDcn64hRjyvU5NaCtBwOE/AmxvFv68ET/Q3lQ7mFrfrmM6BJ6TzXC686qaOVyqdYCGFeOG9kXeAAeqi/89hAxiXqMyY8Q96vUhRwlbsIi6lOM+Y4ePCmkLCD9pfOhQTzPy5KrY0GhfdvRwQsVFBkj6qWzx7qzi3m9SnqjOI4NxvJGk8Kqwy113iV4/wM7mXFCDm7+bA27FXrcd6yT3S+CRLfKsESBd2oCbmgrpPJpm8X2C8me3pwwXcrwMEIO/L2uaAyM+dmHe/AUby1u4m/DgU
 k8LRssZ3
 vm8yPS8xPUrL1g7QZ0Yn/8sDCuaP4DwefnCVm3symiCqhKxP3m3WFAmwAP6jRPCWvTgLfYdBn0cWcy4UZ3d68AVPwAfe6EPA28Yeqfz1XX1Z9mtjQqRmXOCHVXdbGsATqhwU62p8Sr2ZzaxARxPy7CXtVxhfvNkSHeCLWruM+WjVlbW+c6sYGVCsF5W/Avk9c/B3X3UTBsac+lc7eYILEH+jzv277jHsMboojLgBKjecQT/j6qJvd/O9xBvaQnASA64AB06vAUZnAczS2N5u8kfDApIpww/pOHtGSowmLcwB0JNuaOj7iDAjM3AKYw5S8dgepyUYqgRULvdy0cgSJs/vDFe00aDNtfi2Ai5yWGFPdJ0w8DqN87Wb6QCwOaVc2KzIeGPNEyP0S+D06hDCVa1gZF4oD2yBpSNq00MHDsuyFxdTKaxh0Z92jI2vlzPv1RvUfTLLR9qKG0vl7GgLRic/m+Acl758sj29L0qwQreFXebha0gZks44VQXWBGI7EimjKT4eHTSOvqos=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 12:22=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 8/27/26 17:06, Kiryl Shutsemau wrote:
> > On Fri, Aug 21, 2026 at 02:55:18AM +0800, Kairui Song via B4 Relay wrot=
e:
> >> From: Kairui Song <kasong@tencent.com>
> >>
> >> The helper splits a folio whose refcount is frozen: the frozen refcoun=
t
> >> is the state it relies on, while unmapping is arranged by the caller
> >> beforehand. The old name caused confusion and people may try to call t=
he
> >> helper on non-frozen folios.
> >>
> >> Suggested-by: Zi Yan <ziy@nvidia.com>
> >> Reviewed-by: Zi Yan <ziy@nvidia.com>
> >> Signed-off-by: Kairui Song <kasong@tencent.com>
> >
> > This patch is fine:
> >
> > Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> >
> >> @@ -3989,8 +3989,8 @@ static int __folio_freeze_split_unmapped_anon(st=
ruct folio *folio, unsigned int
> >>      if (do_lru)
> >>              lruvec =3D folio_lruvec_lock(folio);
> >>
> >> -    ret =3D __split_unmapped_folio(folio, new_order, split_at, NULL,
> >> -                                 NULL, split_type);
> >> +    ret =3D __split_frozen_folio(folio, new_order, split_at, NULL,
> >> +                               NULL, split_type);
> >>
> >>      /*
> >>       * Unfreeze the post-split folios and put them back to the right
> >> @@ -4053,8 +4053,8 @@ static int __folio_freeze_split_unmapped_file(st=
ruct folio *folio, unsigned int
> >>      if (do_lru)
> >>              lruvec =3D folio_lruvec_lock(folio);
> >>
> >> -    ret =3D __split_unmapped_folio(folio, new_order, split_at, xas,
> >> -                                 mapping, split_type);
> >> +    ret =3D __split_frozen_folio(folio, new_order, split_at, xas,
> >> +                               mapping, split_type);
> >>
> >>      /*
> >>       * Unfreeze after-split folios and put them back to the right
> >
> > But now you have *unmapped_anon/file() call *frozen_folio().
> >
> > Given that you introduced *unmapped_anon/file() in the previous patch,
> > why not give them the right names from the start?
> >
>
> +1
>
> And just for completeness:  we cannot possibly freeze a mapped folio. So =
frozen
> implies unmapped.
>
> So the function can possibly just be called
>
>         __folio_freeze_split_file
>
> And we can can add a
>
>         VM_WARN_ON_ONCE(folio_mapped(folio));
>
> to self-document the expectation in the code.
>

Right, I'll just squash this into the previous commit then?

