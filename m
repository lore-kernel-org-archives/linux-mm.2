Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 443A8C3DA7A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 19:11:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A2566B0088; Wed, 14 Oct 2026 15:11:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 553966B008A; Wed, 14 Oct 2026 15:11:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4427F6B008C; Wed, 14 Oct 2026 15:11:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1AA996B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:11:19 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A1ACF8073F
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 19:11:18 +0000 (UTC)
X-FDA: 85322175036.23.9BA4886
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf14.hostedemail.com (Postfix) with ESMTP id A949B10000E
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 19:11:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mz046Ck2;
	spf=pass (imf14.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792005076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Q0RE/342Z/vGnJRZ53rKL922YaGQQ/XyiajVgtWERI=;
	b=Sl4jeZTH54u7rmbZs4JrY3CAA2GLOOV7ShGCLkpesy7wzxydKTlO3f5f1yWREoqB74QXgE
	zyT+9F9/YoAkqncYUhwkPMMCgybh5jlrWBVuMNIgJg/lBtJsj2jtnxGYEN+3Vkux0/LCi+
	4XuyJsqGqilpyeORaYMJvDzsVP0ajMM=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792005076;
	b=qy1iubEr903IFi3N8wFyEwj0YU1vvMu3PxqYSFjU0zrcTuDkmnLuY4houd4i01o7SlBn8m
	fO/KPaj/OdA2IzjvFku6B/hlT2lLnHG8hajlfVg2N2Y/3rfNuP9D2yg7MIs8h0bg1Y5o89
	3DoxOe/7T5Nl0FEWFOaeyGfo0MWCd4I=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mz046Ck2;
	spf=pass (imf14.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-48870973bddso2698987f8f.1
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 12:11:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792005075; cv=none;
        d=google.com; s=arc-20260327;
        b=FtB3fFsYpNUvDKE18nBlIQGjUUWnrtA1Uu7JKeWf8LczlH3n4Fa+nY1+9jibnpbs7z
         oxpqNAgbz3/32TYP3Q0sklmAnsTkqS6VMgspO4XSPa8FdqgHuF+GDDRt9QqMhzqr1vs9
         L+CcIUGOVDerxweGm8CvQn9tv9DJqpcMCzuzD6y6cOIa4bmY90AAP3KHk3JYrDtkfTQ0
         x2KI/DOT48ERtxSQKHpJi4YBWA45vuixQ6lLdKYFfKpjZsDyGILFIlcXL+2+Qj9nzSou
         TTEX08EoTQ5xbQEv42avdSUh7UcY+uvQGsdQk4xuQUFjVeEvhAhU2KmNFGdbdoAH9I7u
         s+xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6Q0RE/342Z/vGnJRZ53rKL922YaGQQ/XyiajVgtWERI=;
        fh=6MTsTsxfzoqdVbNdn7KPCzGTrh8C7z7oRu8o8f+gYSE=;
        b=rxKwClQ+Pbc9V1nsNPWcJsxGQBYqKVRnkUJr6IAlzsVvfI7Akr3OeJCVvr3VcZiII+
         yNTU4yMBEfPmEHkF+ADztwhoB8zsmSpithdFDR+d7qbehfEo5YG+6IImz8yTopPN8lpM
         bKF5KS0VJns+M5OngChulGhmMu2q64cArhyf1+sZ+KV4uHsBPJZJu6HB7H5MgyJ1ZohS
         fmTgLTTsZLQMyNRb4lEv29cWdAoaBjauTfE1yMQyk0nWz3WDI3bRjCMhXVJlAFQFwS/y
         PRhGm9s0pMT44SbXJhUDv9O0goUglSdRjsd/FVo/JfJhUPBnXzHSgO93lRGaEJYjoeR5
         r5JA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792005075; x=1792609875; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6Q0RE/342Z/vGnJRZ53rKL922YaGQQ/XyiajVgtWERI=;
        b=mz046Ck2NpxK8NfCaZ/rdDYO9leyNzsejgc0m3Lak8tlAWbxvUmSJxku8199V5Ltad
         YKXEvnMtoojujc+HlQ5SncdyCSATKWiDrogFQjUwCrU4igQiICAypdcIBJ9ONOPn9Adw
         ROH7DTQpj8tI73M3QH3I71wjH2f9v2WBiOgppgzQCAz/uMtpXtHrKjiPv7xWICuH5f+S
         mXZ57iuLTXOHbPSJRCQjR16gxgQVKoF0MELQWyK/aLW9Z1YYIsNmanSoPnus7GnJgInj
         2YHMI1Sx/mZMPZW+5MHF5CEC4wIVbyDzF0Bb4nrICiDV1CFdMHBqYRN7gyr38ExKZh9h
         5aHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792005075; x=1792609875;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6Q0RE/342Z/vGnJRZ53rKL922YaGQQ/XyiajVgtWERI=;
        b=FU8LsB+5vO4vW2s9t1rNZ3erroRRbIZJgUchwrtmDK3CEnpeAqq3tsNhURzynjoqmx
         mNJVb/VgyA5d05Wffb6VAcyKE+7kRMI7jm2rSK5zh/+awHGHzWNAhQCvZbu2mWrL4B+m
         jzz2dOQBF4OyvS9D6+a+P43XLJZtod3IKVDzyhbJtei98yGpJxRpj5PwmFShz32+Pgfu
         mulmYLKl5sEpZTOUajHPrMbq+Og6OWTENefSmdhidArIUVW6FYGnLoWFnpV24izSaewL
         FBlzUWaZddkPLJKcJmFCCzpA6Yb3Bkk0aB4H4tEeXi3uj+lCvr3lp1P8gQtUJhhAioCs
         zf/g==
X-Forwarded-Encrypted: i=1; AKwUvByCIZZtn7jZKv+tmEq+GjWazE0t2RmhXFuUy6aoyCNSvCSqnrx3JwDsm56xLSQzetMWxLravDwGEA==@kvack.org
X-Gm-Message-State: AFq9FYJeVrG7ZCiigw2TR0ZVtgoS81/BRWMC1eKmVPetO5EWfnvPYfDH
	URfwMsOId/KOUxorN8NxPB0Gtk45mWWdtEj+ca/OdE+lrzM3iMXn68saeQ6Xb/ZYXZ8S9Tg1qAr
	t4p7nDFScg/itHjnvPKqMBzeuXrLKDZg=
X-Gm-Gg: AYBFou0PwG09sKdg/mJ0tHpK6iGsi314VMicLCWBjWCMI9KAfms2qfz7pPAFU4RrKB+
	3HC/GVHzPU8vUePvko89HnR0k/w93cYvOia/Xgqz0zH2ZPLaWWoO0vtpEwkO+kYam8ah+R2hSJC
	m5MtwUnB8Ybtb+M4KLveY5AxSqnD9qA5mpciuyVk7I4N+WpyBIsNGK1lfgYVwlqnu7Bn3G8F693
	ywxoe9vESCg8ULgeckhbwxXyY0HGhY8OH9JQpyTGUVStSc3T9jkIgZiFv602L/LEilBrYLHm7K6
	+yjyOE94K0bFsGc75EoYac87NQ1IHD7jQxlV/m4GFBsbhkCJrSTwsfmO7WbwS9xjRANVVDzdnzS
	MDayfZdJuQnZgvtmQha7I76vShWWFzKDSNvdkpFvHca3d9fVimeCpikMGRcjYebUi3TRq1OzTaH
	tLkoRDVg==
X-Received: by 2002:a5d:5e88:0:b0:48d:bafc:a3f6 with SMTP id
 ffacd0b85a97d-48dbafca4a1mr35041657f8f.0.1792005074870; Wed, 14 Oct 2026
 12:11:14 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org> <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org> <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora> <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
 <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org> <CACePvbVTnCOh51jvEpkDJ32idvCubgN1eHBps6vESjhVC8E_aQ@mail.gmail.com>
 <CAMgjq7D_=_4ZsCWJYywpZhPtg+YeH8o=ymRrV3sQ_58G6rs0sg@mail.gmail.com>
In-Reply-To: <CAMgjq7D_=_4ZsCWJYywpZhPtg+YeH8o=ymRrV3sQ_58G6rs0sg@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 14 Oct 2026 12:11:03 -0700
X-Gm-Features: AclHuK-O9xN2h7Y61BKOyhDB3rUul2Ti7sGXJ2Q2LlVEmPwqRXTcsAZ_F7aCTNI
Message-ID: <CAKEwX=MTapFb8ZjjoFNSyG-_ZKAsxqPY+x9st2s0b2iPL-d1Kw@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Kairui Song <ryncsn@gmail.com>
Cc: Chris Li <chrisl@kernel.org>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A949B10000E
X-Stat-Signature: bz81nnmbyxm8b7dnfp4u45rdmzda9oyn
X-HE-Tag: 1792005076-544836
X-HE-Meta: U2FsdGVkX19aaH+9djOOmWemnKck+V4M/8w2erEQi82jwVCtMn9lA1xUT9yPe5mYAOUa7i6UBnm+fP70Z3uFFL02cjH7iLpYWdnxgl1o3ZS5biQGtOwuxCHwUEM+SiuCgY4U2YWHRcNwsxs9RGPcLQM/AsquZcKJDBXFgSwDDwqNUMmFiEGQlDT+pNicmWZymfRkbKyQpLoEta/xeQofZm7VPBq+8p8T12AoasFgYBuVR0d9x4qxSzKrtZszki4oMKlKrmmyO1NCTRIXOK71LGb0hTWsJ4eD69COyEKMCPdBqBmJfcOaolwmQ/T8ppUG6Zag2Vhg/LZucAfTwCJUcAsWa20Rz+lO9De53jJQTqjk2gzN/6Yt+0t1+q7CVUFiNKAie3T/o+WUnMuPFe0v3yLg/gd6lpInKmpedZi6tNo6T/KqB7KI1U3FRA+rlYDkTlycQE6cgQx09XZtNkkcv/fiQcV4hnuVTvv1SKeqVbNfcMCFlOi6k9dwA2y3kSyxFP7ellOh9wydedfcf9P4BAvNorD325WDaeqeLzAkNzn/3m/WzbGE3mQaxrN5nCvvTSA0dzk+eikahPup7bJfmTPu6QdfS1JhkueqVlM/VHZNfpksL+FFJH/OVVX47DpxwDEBwrW5JM8I6gWCjTz31vjsxQId53J1mOYKIlXPbZoh7OUOfIp+0Z+5fV0X5WMWky2kxAjUk6T0MxkJEUBLaXdQ2Z1/dlFQLPaXG961hn+wKP4MFGRuHOgMKdSjjTjqlvyO6QGUYbCV8lQ3eGWYNHX75v3QQXxvnX14fK7JhoVHyuAGCJJ8a7f6ym6ebKdq6oMv+uYFyFEUv+RxKFA6uVFn1VhnhaPvt1KEh5AncpHlFRaK0qFjI3T5hN4x5JDWh02T17uSY5C/ELNU7n1eWHhDLKkvlbQVvsh4Cqm9aVrbZE1fXkieBtfZDh1YeNi3FzKfANc/6u9cH1DYY1c
 ZtIzMtCo
 dppxkxj9rId+qvvwWDIwgv+PsUUsVhhIfdUFOaAZBVbqA8peN+PIf+bCWhhK/BVM6/VgUTVWArAbLssMGk7XLC0f49JNGrCURqnmTj58nL/YtlaMPPOmf872clk+INDFKaYuzZHRoy4Mk0jy8AHwNtpURtzSIwU6sOotgKHwR66HgDAX8eJGg9JM0gImyqiTQzivDrcwkU4TAESxtK+ciroWeDDLMyoj2ZKRv5qAv2b/PRsed5oxt2wHYOqd17JfWCQJojzVbR+fWh2dAzZjKpmlx4BwE5+UthBY7FdI9erRpCoUB5//bCmBhWBd6tndMXT+Kz7/9bz93gYmFweWFvwaADbAfBiLDCd/B/vvvxOiZ1e6DH62hHAvtgPxjk0EJBhMUOXhHu1bGcQQsWsS9Z0EFSCu+Rn7jxAYJyLZYHTQZ4ViHRY1q0cgQQvL3SAmjH86LSw14/z42fN4e7xupnvhgubnEFgUdKf27bNLc3FJfwMtbP2+qPrker9DeQYggmT90r1zYvWGLXJzY2DkCEvnn87NSTuKqiJT0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 10:17=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wro=
te:
>
>
> 6. The one part that I think we can and should agree on it shat the
> implement approach: at this point I think VM_SPARSE is the right
> direction, Nhat is concerned about the testing on it, and I think we
> can have more data for that, and collabration is highly encouraged. I
> previously conducted many tests on everything posted from both sides,
> will try to post more on this too.

Let's see if I can help by doing the rebase :) We can use vswap as the base=
line.

And yeah, from a pure conceptual PoV, I'm ambivalent about VM_SPARSE.
I just think it needs more data, as it imposes design implications on
the rest of the implementation, whereas I already test vswap on a
couple of workloads, including real swap-heavy production workloads
with a mixed of swap and zswap users. Performance was good.

My question - and we can wait until the meeting to discuss - is why
are we insistence on dropping all of existing code to just switch to
VM_SPARSE? I would understand if it is indeed very difficult to switch
down the line, but I don't think it is, based on my past hacky
attempts to do it?

>
> That's a lot of problems already. I think we can discuss these points
> further in the meeting.

Thanks for the summary, Karui. From my end, these are my concerns:

1. Interface: I don't like interface without justification. It has
real userspace impact. Things like priority should not be exposed at
all.

And we should also avoid overloading swap interfaces with things other
interfaces are better suited to handle. For instance, while I
sympathize with your logical memory use cases, but I chatted with
Johannes, and he pointed out that the overcommitting interface is
better than swap for this purpose.

Idk - maybe expanding /proc/sys/vm/overcommit_memory?

2. Charging: personally I don't want virtual slots to charge to
physical swap space, but I won't speak for memcg maintainers. One
thing we can discuss is what kind of use case relies on the existing
charging behavior, and come up with alternative setups to handle these
use cases.

3. Make sure any solution supports setups with mixed backends (per-cpu
caching should also distinguish vswap v.s other swap solutions).

Once we have a better idea of the rough design, then we can talk about
implementations.

Things I think we can skip:

1. Writeback - this is a given now, I don't want to argue about it
anymore. Just include it please.

2. Swapoff - I don't think it should be a blocker in the first place.
Vswap does not expose that functionality to userspace, but exposing it
is trivial, because the machinery is identical to physical swapfile
swapoff. If you want it could be a small-ish follow up patch.

3. Memsw:  I think it's mostly a separate conversation. Vswap does not
block memsw. FWIW, right now I keep vswap charged to memsw in cgroupv1
because my understanding is that it's a logical counter, so it should
count a page regardless of the physical reality.

So if you expose memsw to cgroupv2, it will work as-is. The question
is whether memsw will exposed to v2 in the first place, and that's
orthogonal. Maybe the memcg folks can have a separate meeting to
discuss it?

