Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86B58C5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 18:00:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 630296B0095; Fri, 21 Aug 2026 14:00:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E1286B009B; Fri, 21 Aug 2026 14:00:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CEFF6B009D; Fri, 21 Aug 2026 14:00:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 249906B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:00:11 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A62DAC0208
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 18:00:10 +0000 (UTC)
X-FDA: 85126040580.14.0F8EB37
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf28.hostedemail.com (Postfix) with ESMTP id A4B86C0010
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 18:00:08 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=J13eEYgh;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf28.hostedemail.com: domain of edumazet@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=edumazet@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787335208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fRD5LXMABXwFBhfh7sHRdigPlTTh85JRz2NyITaJ8R4=;
	b=qNp8WEljWM+/po0RVy0ygGRexZGQsdJXoy0RmBDtP37fzb6tdeWwyjQZvOj1eNAYyQzFNX
	PVuihthqBEDEHJVdbATNhsIoEXl8bMTmifO9r7e2z19dRuAOXDfcFYHsezatCoAWHObkmL
	6gwmnRWO5RagB9T0qvj2BqQgT2HKrrs=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=J13eEYgh;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf28.hostedemail.com: domain of edumazet@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=edumazet@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787335208;
	b=bKYykFFkwSt2sPXMd/a3pRekCiMTQmUOnnWBaaMPfciEpFQTdWvf0djWY4XMeSLEx0hJhK
	Y273ryVluJxktMjZ0RqDz1uy5s40cfkY+dHiOJdyzMLPKiqvTKatX2DMoG9ZNql0jzQG/F
	zTNMP90cEGeWzu3bstWmnz5VJGsz/0s=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-5276d598b96so6723721cf.3
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 11:00:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787335208; cv=none;
        d=google.com; s=arc-20260327;
        b=HMGJaZuIs/ByPMZo7BpT/uoghzJRkZhWMYJQYl1282LWX0D8JGj1efL1d+P9MEODSV
         P3F50sIxHLpH7H8lut5r2r6brUo/cHjHN61ssWYqv7wpC+EKQYxSdvg4gb76oo7sZj+p
         UHGKRK8Uz30YkaHKytQ8zyfOw1/KQiH4dUjzaADKh9nCqa/260lb7V6+ZdH0uily/xYI
         EsUHpECmZ6L6F1TjeBTmdN3V6+PfvwIjd/NTFlo4aM8DLzTyKIjQr4M82L70MsROSRjO
         MTZy1hDIGep6GYR++9AXNhql37iCzp9XbZyXERgYHE8V5sW1Cy7lJQAIYAtIzwbI/d5P
         q+YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fRD5LXMABXwFBhfh7sHRdigPlTTh85JRz2NyITaJ8R4=;
        fh=onIMa1rAHAwo3VKVVvAS8i149tmu8vJ2alewNgqvG/8=;
        b=F+E+VanlrMX9KQOdJQwMCUUVW8JPeFzTzNVLU7d2CVjA1nV0WogelCyM38hNGm7lE2
         oW4LUtj7lvI1Vu5lOZKAOCJVbssD8NcobANHGwXV1WImQ7CwbIO/x2ZRaLEE8L3JOlJf
         sB8YO7Zy7uQR3xfOBwmNMD9ODEnq0wzOk0wsV1MXuvcJhZmdE5a7u6Vl4Tj+YWfd/aa1
         vuE4ATej0xS+dWMPiK2ZVdPPJgiejV5CqPNz48rGDVo+bg9o8tblDYogmG8PKGeiolqn
         sWKVVSPPLaYla0GIaiXGsb5/FFPfB50LtWkZI4/RqjQAYwAXKSsJ8vpBzDsiluj9QLlE
         g+qQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787335208; x=1787940008; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fRD5LXMABXwFBhfh7sHRdigPlTTh85JRz2NyITaJ8R4=;
        b=J13eEYghEeMBE7ukON83QDouNCz+DylKaPaVzhY5otPRpuVW5XXMDrcu5t1Ft1Uiur
         eZPA/wThOP0EHwcBtNuVvs2OG806IqMslZUBpRyZr1Lz9d3qGqTQiz0GHOklLYKHXUsv
         eY2kqJEm9Le+t3nw7rqF5Poejlif73hArUnDQ/jO9xsVwU8VkT77MddpherR568n5UNC
         Cw8yeQPDLSWwEFdTyAlMn7T6VXJY0iF8D55GT6m0vaoDVZXkb6zZZLTYBpbMavdraVwc
         0a0yyfqcaC7pra8jay4NtYQjKo5ZCUuGQ8hwH3La3Qoqsti4tc1VIejil0CrSXsrgPf8
         uq0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787335208; x=1787940008;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fRD5LXMABXwFBhfh7sHRdigPlTTh85JRz2NyITaJ8R4=;
        b=LoEfLaVCvNivtBBhr5Aiemzrshz1QCjYZVJPt6m859xiAXHAi92tetKgk777wuam2G
         TR6aQro3ARNSgTR9GUKlHwEir8e7kL5A133HoqvU5X5KMZ8Coasn9Y7sbknIDKalzWBC
         PVEZ1AoGeDt4qkWg7rtG72MMGPMIFQ2kirdoqToOkUyNUxojGddISO+vyG8mJxZ2/ZK8
         2qM0GyRSfk0kDl5iMZw5QA7oWyah7P8o2rOWMV4lPqBY9xfYV2j3coVNvYDpphrkkz0k
         cRh5R9z2jAbn+hye3KKJW6PlszTg3QfMR/cvfSJt8N/iCRfX+aXcC2LAJD0NfCfQmOCS
         lxYA==
X-Forwarded-Encrypted: i=1; AHgh+Rqaa1ie0X4VI5Yis9Z0K/sW7h00VV19MtwPcw1wTlnJQdyDcIwLw1yKPxfgBxCW3Sqs7gGBDi6wow==@kvack.org
X-Gm-Message-State: AFuF++nnlmNnI/DUcz4dwDBaLCRAbZC2VCQp2CnEHETBWrwtJAJ7Z2IU
	eOcLFeLwM9t+o9/GwV0Nih8fDQRRo+qD7AvKiLNPlJIvhJPQG4yXt10dNCL1FKiXpb7g2z8tbZU
	MfNKVPRIvqxOooiFEhAk/j9Px9bN9omOpgUeXu1Qo
X-Gm-Gg: AR+sD13hHAWTgyOy31pKuDkStNU9wC/jShLRQBFyqkgvhAlzBK5403npg8BIGmgAvHl
	+268Ap2h26Vm8QCwBMf9K3ExdNnrekx1voFMEas1NcF/JtCi6Tu2WC5e31rlzH5AHzvDc2+arlL
	Y61aK1uhy/qGubxUtCDGh123S/p/lQ3q5U679vecgES9iH6omWc0Lt8F5YfUfNd/eI65XKWe44a
	YuDd9L1iQUof5RRS9/AonxQJL001okBWtaRAgpiEMq9ae2BqLukWXsLt/CaJrZBfQrzlnGPRav+
	qJ4JKNmO2+R2EjLHOIcGvhz4F6MSLkvV5ppphiYfjjeNpDllxOYf3NshioT89ifmr3YKKreW5zX
	1gCj651DhHhpmjREJrATzJg7A/oa+0wL2hfjMNN//iB9ds6F2pc8QTYdAoCGt1MZVISr3
X-Received: by 2002:a05:622a:a07:b0:52d:94c5:2212 with SMTP id
 d75a77b69052e-52df56f696amr77787571cf.3.1787335206422; Fri, 21 Aug 2026
 11:00:06 -0700 (PDT)
MIME-Version: 1.0
References: <20260821170407.3721004-1-edumazet@google.com> <20260821104043.f692421fec915c0c5bc1fbe6@linux-foundation.org>
In-Reply-To: <20260821104043.f692421fec915c0c5bc1fbe6@linux-foundation.org>
From: Eric Dumazet <edumazet@google.com>
Date: Fri, 21 Aug 2026 19:59:54 +0200
X-Gm-Features: AcwNN1WbtvhFhh8htTbRCEkIUIqA-Hm3SncWym4cDXpntJsRuIGe3bdlReu5xvk
Message-ID: <CANn89i+rJ+OK8X0wBtpK_Fd579fE2xMcrefADAN6a+tApKUfSg@mail.gmail.com>
Subject: Re: [PATCH] mm/mempolicy: Fix sleeping allocation in alloc_pages_bulk_weighted_interleave()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, 
	syzbot+0dbf6d295b3350944f0b@syzkaller.appspotmail.com, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A4B86C0010
X-Stat-Signature: 6axz169fxqyptrkh41hg87okgmh3dm3h
X-Rspam-User: 
X-HE-Tag: 1787335208-715468
X-HE-Meta: U2FsdGVkX19F6FKFmzI+pCmCVDevRhCA/xjyRAAADBGXAeJ9lWqD2DV8bQKN1pbaGA43XHcjEnU+ysvuAlhTdlcJyVzeQNq/w6njPUgKMF7853X4U5mRWdpYZqFvouaeeRVe51kHxUYCmwtkrkhsC8SCMdP3vpxzL9tLtsWHRGJ+fLpONqxF3Qa7NzS4ONjeDLJ4NBMAeBXOxY/iykQagoYlv5q2pSxIlxypqCaLIqYxeN7O6fy2FFz7vzuJ1AtlifyVjgUT5fGvqeGdcGZ0sqgJZpGv3BFl5Lekq28oFg+4rZIJYozpR8ndAkMF3Udv+wnR17mYVkYpMawI31bYCe43kivDcqNCWgPtzR7QJ564ab7yDY8jucZJxUo91UwtSJcs3QzlonCFkSdFFRhWaavZQtyMP7BsXtORcDqysg4vEhz0zlAHZyiHq4Yb5ZWQIT0xxoPedWag2kryurrqBCnDUkH62KDQI+GcqD7ssmSjI+Qhfff2Jcp+4xPRtIaCOmGY0N2p81XQ34ZxnWZlpyqRseuGCnuPKU52VLgYsw3MAf07vgzESIlkY99Rq0ZtnYhAlmjim7v0gXxuHaz4oC8H+MZw2FGB84Gb30X7PNBLamDtgEp280F2ZbvjnrNdlEY06YhPfbdTxjpJFvIqloP3TpBokwU9cQT98tsVFsojqSSwXERwb0YIlfnZH5NDJtp99LM53gFz+LeryQ8utDEoCld3l9AkQmF3hnQ0hl1fB/A32KkLu/n3UEHqsuKscW7zeXrwPXDvyWByjaxevUzd87PBd8xnjnmXA24Rz1U+ZAUCSe+Nvre+P/m8VEfSKOQLLrFEMbV1D+psfCZ0OD4DfDQZt3RG6Sg6CpMyhR2ABzgNVLK1co6KNsd58eVYglz6PPoiwZhSbLR93uAcmRq0aGF0syHbGUwpO3svVFo9B60wnBLyVL+jaTc608U8Q5CF6Ft8FFaXER+EyD4
 Isa7s5LD
 2siZICqNAhEwUSUEOJOc5JXgj4ZW8ooQ3qkPWQkfg/Ayeo91XmcFHMXdIgqSFhdgkd/R5lHLSJlhLcDIAjOL+yTvwbfgPf1oXv49z+I9b7ywR6/FvINk0KqJjNoYkl13TFKmoPRnIyb2dVqt68E1qmcmNrG5074N4Dbqz5Cd1wxWlcwbhsW1vOmjp1N6ub9aHXse5aby8BindyzHDSbwr7il+SDbzQviDwXKmNFXX17mXw6VbmlSHzETZFsvDtYiBJjLCoqiyMU88rqGWHcDw+0n0QLepewhZsZh/hnFT9c8oAfRHwtl23s8/KYPOsJAOXhR6xAUUvq7B1MfYd79oQTMSdDCOz9f5GjFbVIjLoslBXJj1/Ckfi0HVz9ldbsxyu7xlAbGkXne4ozdWOKt+Yz8MZjJ8ma36sK7mu3Fbp0hunBcPdYrXiFBkw6bJQ8p0NQljsyEKx21iQW88xLs7wvtVT8nx9ud1gXH4AqKgF6e255Edni8u0XB0vA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 7:40=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Fri, 21 Aug 2026 17:04:07 +0000 Eric Dumazet <edumazet@google.com> wro=
te:
>
> > syzbot reported a sleeping function called from invalid context splat
> > in bucket_table_alloc().
>
> That was quick (7 minutes!).  I was just looking at this.

That is because I had the syzbot report in our private queue.

I thought it was a networking bug at first.

When I realized this was an mm bug, I decided to cook the patch,
release the syzbot report, and send the patch :)

>
> > When rhashtable_insert_slow() rehashes the table under rcu_read_lock(),
> > it calls bucket_table_alloc(..., GFP_ATOMIC | __GFP_NOWARN).
> > If the bucket table allocation uses vmalloc, __vmalloc_node_range_nopro=
f()
> > invokes vm_area_alloc_pages() -> alloc_pages_bulk_mempolicy_noprof() wi=
th
> > the passed GFP_ATOMIC flags.
> >
> > If the current task has an MPOL_WEIGHTED_INTERLEAVE mempolicy,
> > alloc_pages_bulk_weighted_interleave() is called and currently hardcode=
s
> > GFP_KERNEL when allocating the temporary weights array, triggering
> > a might_alloc() splat in atomic/RCU contexts.
>
> 2 years ago.  Why are we discovering this now?

syzbot got better in recent weeks.

Google folks can look at go/syzkaller-llm-fuzzing

Thanks.

