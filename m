Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 537F2E63F33
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 07:35:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 903B06B0005; Mon, 16 Feb 2026 02:35:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 881276B0088; Mon, 16 Feb 2026 02:35:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 762706B0089; Mon, 16 Feb 2026 02:35:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 601A26B0005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 02:35:18 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 21E0B1CF10
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 07:35:08 +0000 (UTC)
X-FDA: 84449508696.05.F651A36
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf15.hostedemail.com (Postfix) with ESMTP id 481BAA0009
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 07:35:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IJFyYv8C;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf15.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771227306; a=rsa-sha256;
	cv=pass;
	b=Jk5zaGDc+q23bKJ30EqtMDVZ+4RsTwjFWU6TAj1ZLEVwxjhWsOC8WEMBj5bS9c6hXlkgfC
	lPPHCzWX3DO7m1XqOqpYgV3ty23Al7jcDjY8XSWlAzog7dPd/ACbQ7322mqmPU+lda2rdR
	Tru4gmgs+og4cLGx9oexIdL46GNME7A=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IJFyYv8C;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf15.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771227306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=024esMGlkL0Bwiyo9ctvcoR2iC+oqeDjq2y9rJqpeMg=;
	b=avYcgi9ieXu4svZ2YHzbVlGVn2FnQ1PiEf39taWqt1FLG7I8AOpmaysvTK/TAqRH1M0qTU
	hOa15FygOIMNj6PsdogNXb1FVAWM+y3bAxBjpmnSe9C7gsdvYIHXqOfNqcfm6RWz9VZriL
	SaM3iBpjPN+HJKT6MnJCfhPxqRJgIWE=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-503bf474fdfso28140611cf.1
        for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:35:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771227305; cv=none;
        d=google.com; s=arc-20240605;
        b=irf1KesqvPg40L7/lm2YJo2ninc6TOi+Y8YIhnxHjnhwDW3ZpclJA8e5t/j1pJYL/j
         dKNh6UHwqfYYAGzxqs7ATAWREaAjn4c8IUK+32qpSihwVpQ7D+415ayE3f5o2b1RQbu0
         F9Ciw1VU0DxAwiDoEZdj16Aj/IvNpxgk9xOe4bpQhoaQ7OHHl4i/MPX6sYU07F+KnucT
         wWzRa59zC1FB3nClnFImSRbqRd+8XVfyISmTqa7dzKVOm0lVXDsogHv2B3gn3RHXRI37
         09Jyh2zeDR6bzc1PeM5PvTuTpz3Gg4OcJ0cV8xvFj5+4T+yMxAy+/2O1VhJDGjmMbJLd
         X4FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=024esMGlkL0Bwiyo9ctvcoR2iC+oqeDjq2y9rJqpeMg=;
        fh=ax0SVDDNj9e0avQJCZXKE/RdhH5t7AkPo7KIZY3RsYk=;
        b=gGlnHI2koxqtdY1eOjh93sFn5VGzM9aSfGhd4xLr1VVdwXY7ZgBhcG2bHhzdFMjPOw
         Px/yJVIr2H20BGHJCfzZkXckdWNwRyTXH5XgpOk2JQafC0DETKNHeWweBMcq9WZHxtzF
         CBpVCq4SZhUMJcblz711DltAZUyNz1zh10o3CaJnbs1lQLGLTfvonwbunF80jGPXkOQQ
         ZHdjZWazug83+uAscKsdhH2kclzsg0hCUHo5YzuK+RtV9/eUp2lwCicOSBiGVvROToDc
         6ieCCZK1O9R9Sj3Oonk3ZGvvn4jjzJj0bHzZpTz1MGskySYzeJ9ipf17IsJ9V/bzAiW1
         ZRhQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771227305; x=1771832105; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=024esMGlkL0Bwiyo9ctvcoR2iC+oqeDjq2y9rJqpeMg=;
        b=IJFyYv8CqQk/ZwXT7Oi5c2pMQqRcKkrOJpdq5Y1mDzToG8+RzB0G1qrKCo/KAYoJJg
         5K8UjC8ummmP0MRGho75L3CB0sZrbL8i6btC0LbI6IM9wFW5JBCN8cFJiGYWxTNhClHx
         1VoiweXy+YaApItcB+kXIfwgRrDkyGb6JYUmW6/2l2o2mLwFmzFuNg1Joa7ttLjaE6HG
         gOeXGWDeGRQ9GQvhnaBA/gpSze9cbopdkfodb5BHoyoHMEUTwUHFt5BWTnagQNzayGHF
         A/X9Y7ndaTFJJ7j0oM7q45chabh7RnGg8j7GtNNcBl0gDWVJTcdETqyb3lccA0dvlEqR
         8iiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771227305; x=1771832105;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=024esMGlkL0Bwiyo9ctvcoR2iC+oqeDjq2y9rJqpeMg=;
        b=IfCGVojhP1tJ/Wy3ckys1t06X0K26kqNOwD6arr2Ba8t33WKCnXa3JtEXqCdgSEhG4
         RDE2LT0bljQW+/pDC1veUyS4/3tT9HKgLpF0zLr2EmX2YdgyxxuCBzvvQ8aHn2W4CYW5
         ekh7ghLCRBBTh1/JV+Lo3AmR3nFzbiz80UeIeLAY6ouhqz+bKE2oeSW/36VyEoqU9XyP
         0dVzro991FB19Dh52Z5Pdpsj//o3ED0CkrE5qphuvp0I9vkY8FyvjZmhTiCslozb5aqk
         MQ2Y6Y3XnYFakZTgydHr4Xm/W0Wgmq+LykFygNbx7X4M/pzB83VmncNIbaNQqynPW57r
         PxFQ==
X-Gm-Message-State: AOJu0Yz7FRtY8mBo75MJbqBsjUBNKR2ajW0NsJgpne4OT9i8ZwXsBvv/
	DORGSHKo1DXsZJUioAo4cpGeiXyfgl6mH10C2scmbsCvel0Pgyoy3SwJk4SKkiYnReu/U0kJGHU
	YPTENEglaQQaqAoa5PCh+N0f2/eK29Xk=
X-Gm-Gg: AZuq6aKE6e5w62aIy558zKaq+J2PF9BggXmF4tpW8OBzs30we1oM32z1RWj6qjmlg5P
	KwLbjmndWkYJvHUCTzjLQfkMb4jTbJ0Aso9OxmiMxnFVSH5xX5HIjLVOoExO7lBI0IucvuXAyTQ
	GH3hjYCfyBYWSqlco8y7BVM+FW07Abw4WcBs+yX3Ldh1Z6WOkkN/w7Lmfxp30MXYZ4Ke1cuuhNq
	0NW6AnXWBgidMKtvhTHPb9YnNUUPVKeX0Ty0ldcYNOt/iR67btsf5zkRRBq1lpNaiYghwTgxGXi
	Jwzc7g==
X-Received: by 2002:ac8:5a82:0:b0:4ff:b1eb:2d03 with SMTP id
 d75a77b69052e-506a6b46d4bmr131456111cf.72.1771227304980; Sun, 15 Feb 2026
 23:35:04 -0800 (PST)
MIME-Version: 1.0
References: <20260216-hibernate-perf-v3-0-74e025091145@tencent.com> <20260216-hibernate-perf-v3-3-74e025091145@tencent.com>
In-Reply-To: <20260216-hibernate-perf-v3-3-74e025091145@tencent.com>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 16 Feb 2026 15:34:54 +0800
X-Gm-Features: AaiRm539nHIx117-7otZWRWfhYh23TG2xx8FFgV-CfFgMKEERzUaheINn2QkqoY
Message-ID: <CAGsJ_4xpoC78KhYj_b18aVzjGcFGfXnpt7uLGvg7w1B4Y5cc2g@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] mm, swap: merge common convention and simplify
 allocation helper
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Carsten Grohmann <mail@carstengrohmann.de>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	linux-kernel@vger.kernel.org, 
	"open list:SUSPEND TO RAM" <linux-pm@vger.kernel.org>, Carsten Grohmann <carstengrohmann@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 481BAA0009
X-Stat-Signature: o47484wha3xbpksp3cqfqjdw1xgzniib
X-HE-Tag: 1771227306-134759
X-HE-Meta: U2FsdGVkX1+xcJF8t43zVwzTySUf+38aRs273C/TN9q20VaWLz94Kl4V+FBw9rfC++gD3qN14Swei6+aPGQPFPqIX9dhN7VJ/+jlAHereQb0v6x+gYmv8jhO8BFEE1eeLlSYZbZKQQSv+r0eSIKb1ceEaIQPx/VqU9I8UVqDzSH9bpNJaYFivmhFZdJvEnBc35noyD08iu/6trW5pZwxVsxJ/lSTzn8K3usMEZ/GD/aXHSxwcnlp/erL7U+wohClU915qjVynEdlravVy00wbZ6OBoQXiBrxyFoK/yA9+4Ukv1/q6mfEdhF799xD88alu6cQLGKwHLe+9YoVfD0b46DYmIyFvmtKtRUsnPhWuE60y7j/Ido0chQND/caGA5W6x89qAS/52T+ETW6LFB6J2Y5SyyHw+y0XZyeXIedj47uLvVHUPzTFGsbZ/4oQ+r3hupVxSA9XG6MBoSRiYyvXEV5bHv7DhXN4SPoxRWqnBWFxmvqo8WpYwkOMxEZ84nfloamOuTEO0hyoz3Esub1c3Uo2/vWa1P/17cZoSm8yXwBdCf1ksQsCLVBIIjpWuzSMx68O8h07+fBoKvrj5A0eObXvDkt8hoSS3zFsg7417A8wvHvsFYw/w7v7Wrz7Q+jwLiMfz07difZ33RptDCByl/KvJbKFZ0Xk6zw5myFPxQE/svIxYO0Tm7WSme369BNSdb5uFyc/BFj7sVc5ZtXooq1bejWXglZx44uvC9sZRDJrlB+mVPgAuMC7r+ZWT77sTpzof2rep/WSaCwgG+u84xFIzsxK/wfgIo+dDsXvBqvl1J94TOMfICapRbQTF3wJWnhHRDpagcAbmbe4beTZ/f8oK/zyPWLcDWlSvqKuRs2uM9z/gXucj5klpNpcM9RCM5LE44otl5PShVdtIvm+nbtdHdCEpUgG/rIwLBa4xicyeVcwAelBIH11HJ9oFg/jyXNR9cs+8rqaXnH3l2
 iqcC4s/G
 pEby4ddhqIbdfxAC1MKTzZn98v5Mj0H6f0GZILjc7oj0eK13232EGilEIBC6mSuYCT9bldwagfCuRfvMvLFeNghuTTcO9LyEmWnEVM9SNYpf14ojyKtXMnT6AgfIiNTnWJwvolUIM0/V7mLFSVAYBCk/COJJyTrhzl9iLC0JUy+I4gi/e3tivSV7PMZG2WHTISUF4fZ9paJR+EweTfa7mkRcafRxJ9mgsUZmG+HWnLbFXwEN+Xru5Zx+d0O57kqkGuJ2Ypblh8PXmj47ef7JbqJNtcwalWlEczxxRT4byQqu1co1yzxhJIVR2zCReGTA05uf94Iae9CSDf/pTu4LiNkrRoavt7JqySbnSpMUAAE0mAHTcV9Cl+1jfXmkPFifZQkt4KzwVw4KaDr4lIk6GYJktah0xVhvy5v1bDSc46NknuvwWlfr1g0pOkLOHciwerhDh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 3:00=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> Almost all callers of the cluster scan helper require the: lock -> check
> usefulness/emptiness check -> allocate -> unlock routine. So merge them
> into the same helper to simplify the code.

Previously, when !cluster_is_usable(ci, order), we only called
swap_cluster_unlock(). Now we do more work in this path:


out:
        relocate_cluster(si, ci);
        swap_cluster_unlock(ci);
        if (si->flags & SWP_SOLIDSTATE) {
                this_cpu_write(percpu_swap_cluster.offset[order], next);
                this_cpu_write(percpu_swap_cluster.si[order], si);
        } else {
                si->global_cluster->next[order] =3D next;
        }
        return found;

I assume this is what you want to do as well, but can we add
some explanation here?

Also, it would be better to add a comment that
alloc_swap_scan_cluster() expects ci->lock to be held on
entry and releases ci->lock before returning.


>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/swapfile.c | 30 ++++++++----------------------
>  1 file changed, 8 insertions(+), 22 deletions(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 0d1b17c99221..68dbbbd0dd24 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -923,11 +923,14 @@ static unsigned int alloc_swap_scan_cluster(struct =
swap_info_struct *si,
>         bool need_reclaim, ret, usable;
>
>         lockdep_assert_held(&ci->lock);
> -       VM_WARN_ON(!cluster_is_usable(ci, order));
>
> -       if (end < nr_pages || ci->count + nr_pages > SWAPFILE_CLUSTER)
> +       if (!cluster_is_usable(ci, order) || end < nr_pages ||
> +           ci->count + nr_pages > SWAPFILE_CLUSTER)
>                 goto out;
>
> +       if (cluster_is_empty(ci))
> +               offset =3D cluster_offset(si, ci);
> +
>         for (end -=3D nr_pages; offset <=3D end; offset +=3D nr_pages) {
>                 need_reclaim =3D false;
>                 if (!cluster_scan_range(si, ci, offset, nr_pages, &need_r=
eclaim))
> @@ -1060,14 +1063,7 @@ static unsigned long cluster_alloc_swap_entry(stru=
ct swap_info_struct *si,
>                         goto new_cluster;
>
>                 ci =3D swap_cluster_lock(si, offset);
> -               /* Cluster could have been used by another order */
> -               if (cluster_is_usable(ci, order)) {
> -                       if (cluster_is_empty(ci))
> -                               offset =3D cluster_offset(si, ci);
> -                       found =3D alloc_swap_scan_cluster(si, ci, folio, =
offset);
> -               } else {
> -                       swap_cluster_unlock(ci);
> -               }
> +               found =3D alloc_swap_scan_cluster(si, ci, folio, offset);
>                 if (found)
>                         goto done;
>         }
> @@ -1332,14 +1328,7 @@ static bool swap_alloc_fast(struct folio *folio)
>                 return false;
>
>         ci =3D swap_cluster_lock(si, offset);
> -       if (cluster_is_usable(ci, order)) {
> -               if (cluster_is_empty(ci))
> -                       offset =3D cluster_offset(si, ci);
> -               alloc_swap_scan_cluster(si, ci, folio, offset);
> -       } else {
> -               swap_cluster_unlock(ci);
> -       }
> -
> +       alloc_swap_scan_cluster(si, ci, folio, offset);
>         put_swap_device(si);
>         return folio_test_swapcache(folio);
>  }
> @@ -1945,10 +1934,7 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
>                 pcp_offset =3D this_cpu_read(percpu_swap_cluster.offset[0=
]);
>                 if (pcp_si =3D=3D si && pcp_offset) {
>                         ci =3D swap_cluster_lock(si, pcp_offset);
> -                       if (cluster_is_usable(ci, 0))
> -                               offset =3D alloc_swap_scan_cluster(si, ci=
, NULL, pcp_offset);
> -                       else
> -                               swap_cluster_unlock(ci);
> +                       offset =3D alloc_swap_scan_cluster(si, ci, NULL, =
pcp_offset);
>                 }
>                 if (!offset)
>                         offset =3D cluster_alloc_swap_entry(si, NULL);
>
> --
> 2.52.0
>
>

Thanks
Barry

