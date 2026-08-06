Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EE0CC55ABA
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 02:34:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A2096B0098; Wed,  5 Aug 2026 22:34:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3532C6B0099; Wed,  5 Aug 2026 22:34:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 269476B009B; Wed,  5 Aug 2026 22:34:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 95A516B0098
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 22:34:11 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A5B4D1A0633
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 02:34:10 +0000 (UTC)
X-FDA: 85069275060.07.5CA40C1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id C0924A0003
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 02:34:08 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jeC+sb1C;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785983648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VevLr3EA6F4Fwc2EFD/LVj+XK4P4TBa4wHMNWVCOmNI=;
	b=vg3gkKeYNJcAdxcoqdQvm4xfL1RA3ISrkWSX6HqcQSRvU671xvdmzr9ELPg01f0IuyjOnI
	bbX6S+Zj6X1PhC8LFwLec5oInGDjJ0DRViCGvGTH3gKBq+TJ75Vo18T/B87JaK0pA/HcHU
	3zO3He4woprbEySfc9cjQ0z8I7YHzUY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jeC+sb1C;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785983648;
	b=IspwwjaZjzJgQlX4CvYEFwgTi3LLm/C17tfbUlAwB0s2xGT4CqTSGGsOojfUus/W/6GDIX
	zTYPsgLfivjHFZ1r5YbwYznw/uChoBAp1uJGGPP2hH7c2sGrLWaaMiOX4TECcv1djOZ3Uf
	Dv1+gNz8cW6xv0g0mdkqOWskffkm8fw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 242F960AAC
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 02:34:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C35451F00AC4
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 02:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785983646;
	bh=VevLr3EA6F4Fwc2EFD/LVj+XK4P4TBa4wHMNWVCOmNI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=jeC+sb1CtMOF6VZZLBlHUhQRXg1IC8f5dckAhloyWWjHWJuA6kzaiFpeYEboPlKKo
	 lNgnw9yo5O3Z82YGZ70R7j5mi9kioGO4GjkavyVb9mw8Nn+56mhmhRJYcIegPwdgfg
	 xv2J9/akfTG3CbkMxqjMUhf08a2sLw0AZ6oReycEL6HWzcHFopiku1egx5Fj+S5D+f
	 VFmqf6AJilgYlcOiqRtEhGWkkjK0YeoTa5KZpb/r7BkgiDZ/7Huu6J64JFHEFmt+Pn
	 DdbKnwm+UNrog+EgJwvPVY7lzgWvQRRnkpkBXSBr2/RIuel0SSSZ2hj6h5bIQwVLcQ
	 QqemNopy4bAjA==
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-92e512a9a6bso85348185a.2
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 19:34:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrMYFB0BcQ6jqDNIrHDZKKPt1TrhIIQeQ9/iHNpKcipTrhkgiDyLGZ0J5hYY2f3yiFbOZ60qBQFTg==@kvack.org
X-Gm-Message-State: AOJu0Yz8I50lCHyTJVQkznaufK7sdjPIwdWo5xvqD42wzEtleL7LU4Th
	My+7BsVcAdNhc7q++BZid3DSrR/qhxF1ieTCSJCRSHldtYdNCgHT9d0Ne16PQfy2gNRYrKqvlpP
	ZaF9hKfL2xk71fl2p8ci2Ve18tueAQRc=
X-Received: by 2002:a05:620a:8089:b0:933:aa0:bb83 with SMTP id
 af79cd13be357-9364927587dmr1184739785a.34.1785983646152; Wed, 05 Aug 2026
 19:34:06 -0700 (PDT)
MIME-Version: 1.0
References: <20260805141146.127776-1-youngjun.park@lge.com> <20260805141146.127776-3-youngjun.park@lge.com>
In-Reply-To: <20260805141146.127776-3-youngjun.park@lge.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 6 Aug 2026 10:33:54 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xghMxAcJ212WtBD13gYiSLHJc-NRvNTtW99ZOEmdUnDQ@mail.gmail.com>
X-Gm-Features: AUfX_mzrR-7WpbXyYVRVA-q3kDOZiP5CYjjRzz5pprMd4QCS_XEJvM7UshLdoDw
Message-ID: <CAGsJ_4xghMxAcJ212WtBD13gYiSLHJc-NRvNTtW99ZOEmdUnDQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mm/swap: scan by cluster in find_next_to_unuse()
To: Youngjun Park <her0gyugyu@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C0924A0003
X-Stat-Signature: 33zt6ts89ad89aiqcjx37qqrq1o7rdmm
X-Rspam-User: 
X-HE-Tag: 1785983648-306771
X-HE-Meta: U2FsdGVkX1+pWL3dpwiHQF/MAs7kkEuBilOo84tGqrkZzttvMMmUGopEgkTTTrPRIJi09gL3viSAsHwlfaz7w3YSgR9KvZZUxOt1+EU/KZuYOeS2nHN5Jtx5GevaTv/D2X+YIHB9OUFV9ZsjlG9Jr/ge+y0upMzbNowFfc+2zvUwWJU6j2YkDKiiX5F2XPJunWPrE5C6Tn5aHnGy9yJSSyBxZddXNgnoEbvXmIwOtMoNUqiMlymE5zPb4tfZsRGUXHPFekn4F8LAl7TGVJLzBZMeogv8SR/8N7YOHWjn8jfAxuO63z8nwbH7dfv1HKOolW4C874tpAx5ZfSInSx2NNVkE/dWpuNI6v9UTYKuGZNfUCIR3kinYBnIjIYlVzOc6waRoESE5ibwOx6IB28I2yEJSYOaYfDvgUlEEfdOSoFunlMXZ1snXDDB0NxxMnpy4RJBGOndKuXf28gvUwkq39EfHSa3a9D4FRyVG7tSRkxkrcoSv7suJwG2sKGmuyQEDUlZOzMsAMdhsSWAKWijFKxuEg88OdY33Jw15ZbRR7IgLEN9emPK5DSWZlkxux6LufRWTIBiLCz+UUZFhT70fb5vKfu/buweP0p3EPRr4+ehi92SQFLMTSNQpA+fyYX+SRa4eeW66UwWnFy8Iljab16YzDD4iD1gJ3fDLLDfkKxAQtZTUFXfZiwcELwapIrsGm5Azb1FGSJ+BTnRjxF7AyR1cpD/dwjNPqPUy4mwVd5B/cI03inVr8M2aj38mkv1P9mNEzOIL/oB0gkoXiw1yb2lF3j16rM3KVdaiQXJd5/9tG82uBPk62F2H5DRU0K+Ws365TFDGXK+GNB4DxghIjHyo3+mA7WigNvL+0O+QpRJ585P6Huvd1xOAoWE0Ghyf2vX7eJUQFWPkAN8tT5BV+vnWqsftE545PBUdnCGaW9hkHDmQKJgk090uRqIXVj/3qb5ClWVKWv2d2DrUhd
 3IDn6V03
 epVtP5tEeldcghIV4aZVp6NtM/qslhVQhYm9J2rHOqfwj3YdpCm48D0QgEvGuRSXJ06eiUpLEeS2jwrEFv/WhOGmUnS7jJT7dJq3gsrwLNvx3aIkoTtR20/uzx/FeqVn79cx/pHl/RdCS5BYTaAG3G3/eurxi4qRQaAmP0rUY8qRtT1qdtAB8hGv32PchbHQ5gKB30AKSpYOi1F5KRArg9ffiRPmzWEQNfUHfg8RZVz/reZrIGXyoN9F20Oa4YBUV0Gi97LqTzfhzDbMEWw3mIRJIoYV8xzBHdk95XtneuPt7u78FjuHS3XRgKvbdbZ05LEGaPNmloK6BDYyNrcV/wasFGFjtP7+aWAeCXh8fNtSzbvuQ5/xNcDkQ2/bQNH1OiF707og7LYn0CbY0tCuwIPcfVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 5, 2026 at 10:12=E2=80=AFPM Youngjun Park <her0gyugyu@gmail.com=
> wrote:
>
> find_next_to_unuse() walks every offset from 0 to si->max, and swapoff
> restarts that walk on each retry, so the cost scales with the size of
> the device rather than with the few slots the shmem and mmlist passes
> could not free.  It has caused stalls before.
>
> The flat walk predates the swap table.  Slot state now lives in a per
> cluster table, and wait_for_allocation() stops all allocation before
> try_to_unuse() runs, so a cluster that holds no slot in use stays that
> way.  Skip such a cluster instead of reading all of its entries.
>
> Commit dc644a073769 ("mm: add three more cond_resched() in swapoff")
> answered those stalls with a cond_resched() every 256 offsets.  A walk
> bounded by one cluster no longer needs that counter.  The loop now runs
> at most SWAPFILE_CLUSTER times before it returns or reschedules, the
> same bound swap_reclaim_full_clusters() already scans between
> cond_resched() calls.
>
> The inner loop runs to the end of the cluster rather than to si->max.
> The swap table is always SWAPFILE_CLUSTER entries and swapon() masks
> [si->max, round_up(si->max, SWAPFILE_CLUSTER)) as bad, so the tail of a
> partial last cluster is rejected by swp_tb_is_bad() and never returned.
>
> ci->count is read without ci->lock, so READ_ONCE() marks the read for
> KCSAN.  Allocation is already stopped, so the count can only drop, and a
> slot stops being counted only after its folio has left the swap cache.
> An empty cluster therefore holds nothing for try_to_unuse() to act on.
>
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>

Reviewed-by: Barry Song <baohua@kernel.org>

[...]

> +       i =3D prev + 1;
> +       while (i < si->max) {
> +               ci =3D __swap_offset_to_cluster(si, i);
> +               ci_off =3D i % SWAPFILE_CLUSTER;
> +               end =3D i - ci_off + SWAPFILE_CLUSTER;
> +
> +               /*
> +                * An empty cluster has no slot in use, so skip it whole.
> +                * A slot is uncounted only after its folio left the swap
> +                * cache, so there is nothing here for try_to_unuse() to =
act on.
> +                * Count only drops here, so a READ_ONCE() without ci->lo=
ck is
> +                * enough, unlike in every other cluster_is_empty() calle=
r.
> +                */
> +               if (!READ_ONCE(ci->count)) {
> +                       i =3D end;
>                         cond_resched();
> -       }
> +                       continue;
> +               }
>
> -       if (i =3D=3D si->max)
> -               i =3D 0;
> +               for (; i < end; ci_off++, i++) {
> +                       swp_tb =3D swap_table_get(ci, ci_off);
> +                       if (!swp_tb_is_null(swp_tb) && !swp_tb_is_bad(swp=
_tb))
> +                               return i;

You have the following in the changelog:

" The inner loop runs to the end of the cluster rather than to si->max.
 The swap table is always SWAPFILE_CLUSTER entries and swapon() masks
 [si->max, round_up(si->max, SWAPFILE_CLUSTER)) as bad, so the tail of a
 partial last cluster is rejected by swp_tb_is_bad() and never returned."


But I wonder whether this explanation should be part of the code
comment instead. Otherwise, people may wonder why this is safe and
ask for the below:

end =3D min_t(unsigned long, i - ci_off + SWAPFILE_CLUSTER, si->max);

How expensive is the min() operation? If it is cheap enough, maybe
we should just do the min() unconditionally?

Thanks
Barry

