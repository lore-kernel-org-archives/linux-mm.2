Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19626C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 16:42:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2FFB6B0096; Wed,  9 Sep 2026 12:42:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E089C6B0098; Wed,  9 Sep 2026 12:42:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF6F86B0099; Wed,  9 Sep 2026 12:42:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A30CA6B0096
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:42:04 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EE922140272
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:42:03 +0000 (UTC)
X-FDA: 85194790926.16.3A879C5
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	by imf21.hostedemail.com (Postfix) with ESMTP id 033341C0007
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:42:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cpBRcd6q;
	spf=pass (imf21.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788972122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/PVQoRJaxnOVHklysY+eFPRn0PjfeKzNOqRGrKxgA1Q=;
	b=HURBe9HgVG3PPfMHPW/resIzJlvVwpsBJs1zFVelH4QnMDMiLE7kjnGDqIeAD51hS9ZOa3
	3yzEzXNDC/7QNysnYga/Wb5A0H76gQoBiblHgrv961P77ItqoCO7aUC0jR5qMX3O5IzsTu
	qwgiw2yuSb2JYrc/DD1yFS2wQJqKqT8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788972122;
	b=hyKvVN/PNwBMLWeDJsKWbOY6ipl+Eud+7iIZVeUAordoyTazcPEr7UH1KIRvcI11nso9wZ
	q3mmzoM2eDvJaVFanw2RNTbkyeA+mSYPYrbvUKNHy7EbwNYByq0QoRan3t2eo+lVGPZSQx
	Ve56FkbsEZMWYMi2bCtXt57zuRKNcC8=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cpBRcd6q;
	spf=pass (imf21.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-3a49d2b18d5so7098281fa.3
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 09:42:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788972120; cv=none;
        d=google.com; s=arc-20260327;
        b=HBOtFH1z+x0GW+RkrtNOMc2DqY0SlBW7HNG7s+v2d8pNeV3o93Mj9TtNwRj3AgVCpl
         6QmaGaSENahKvqYqY7MOiiOUFFWjzhfCkwNEsSswsxvEyHXI8/6aIJyCK9GA5ia0vMZi
         C35+RhEv4XD4DnefBY8DsN8DGcG3IS7P8BY0g/EVmnIhhiYMtsWKaOzE89ThJfgRsbpb
         rI7oLEJqqtB2+03wRX6HKW5S+oFoblCfJ2Ev9fIEyOVf8POpARl3Xr2/Fxv6uJinevTC
         bKf7pIFxeGJdyLD097i6ieCvp7htb75xhNkHVSAqY5ptyGJJYScyICd9i/N+lpkl06n6
         sIDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/PVQoRJaxnOVHklysY+eFPRn0PjfeKzNOqRGrKxgA1Q=;
        fh=t4cFv++MAgYfTBjslryQX9xeeXXSx7PCJkHDe8G1v40=;
        b=pD8gAbislN4mi7PGcMxX8Bo53RVM2qREDvLm6X3j8ZqVjzK32qIg1g3vFcZoMWLSpd
         POZGnIyVv4nOPCIbheL61jYltB8esmGdS95AKhhO/hTjoaVopEZe7D/WFw7oRHzcxSB3
         8SyxwDaFkRWyzvNx/gPf5WKcT7uKsfUl58E0WCdzI7OM8GzJKSpBbXrhPodR457pQ7ew
         LU1MNm8Sdn+hDWE/tGPhIOuRo5IKZbmVQ8pU+CE80p2GJrHBpIkTUAtvtJnHj0UaENJU
         53h8x6/JOYBiWe9tewBqU3cRjlygeT+WeQleKbw1/267zbrbBLyXZAQsUywI6c9fXWLS
         iJrQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788972120; x=1789576920; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/PVQoRJaxnOVHklysY+eFPRn0PjfeKzNOqRGrKxgA1Q=;
        b=cpBRcd6qORWSDXV7PGKXXfkVKQq8lrVbrQzXGpmwQn+bjOCG3Fl+6MJ/GzXsX3yJp1
         sr2mJSuZ5BxDLHuwGUzdrd7tlzCPqcUOHNgFAyNMlFC55gx+7WMVclR3we1bjwIEqXtZ
         23IBpJoZEz0U+ZpWzfSK4EkKlK/YHBhvbAZhXa0GWvV2/R/5W/+kapp1cIWHJ9fdRa1A
         urdfyZmwXVxvZ52DXAsY8Xd1QBkL6c7iftM92tH6TUMwMkpTQJYqIoUQAq4csxMbyhyp
         oX1YtdGkgMKBpeZvMEjStajome/+MsyrW0fp5IX/iwF33PK1xv49zpmJRlT9dJ3vXTwU
         5uyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788972120; x=1789576920;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/PVQoRJaxnOVHklysY+eFPRn0PjfeKzNOqRGrKxgA1Q=;
        b=eQyWjnP1Uv0L7ab4xWPoG06SP76HfHAzk+GuZ/9AH3OyChuh4g/6psF07iQPPctABR
         S9WD9WVecfB7DFxXvOf3kOKrwM2woiEBOCifjxjR/RMgtk8cF0hZNf/WYMNJLlC0Cul9
         h65KsQL3d96YAUZ80uehenJqlEjQYK/bBtXWdMUAtQ+himgn/2nS08if1TJSkZNOCi5j
         K2VCntIRqMjPbIboiSITK6B4vgtjbv2UJkLmsBbtkGzUm91EaqZoy96N2bH0zI1gwTnV
         TUF7zrjD1xRvsYBFZ5+YmU9A92NlHIYDpPghCrUC/W4UBLvS36hxE/YULqWsJvUeuVPi
         412w==
X-Forwarded-Encrypted: i=1; AKwUvBxSD3U7fl0AHqjOZ+9pL7FddP+GY52jw7emItSyx7Pi3NVPOo7EjAMdOaCof+dmmLApSdfk8TG35Q==@kvack.org
X-Gm-Message-State: AFuF++mtMg+Z41YHdSEkHcS/rReV+3Sd0LyKEeVbXL2L8BFzNrZYmoBV
	roSKN0Xz9HMOBYa6KjQmi5rDJhd+DonjoW8OVhsHiZ2MkZCCL98DcdfGq9cNfmHzEYrDhg5lX70
	f681GnU6kHlNTqYTxCyn+KdMmeof/I4o=
X-Gm-Gg: AYBFou2JKdqM4LE0ZcYDhDSqZuSrtTZJCk2FF3wdd55BxLwM5M3P7fkDvXIfHblfSLh
	m+XhmEhR48DjB7EgbdtMm6ZZGEoLrgNuJe+zfZGnQvY+DCTaL/b5vxMPBZbfrJ1mR7f+gTsVIpN
	+CxMFkWzBcL+c1kOl2/uXpn4xuDL1DqjkfatU/ztWkU+Ps+JgXEYw/FnXZNbwirdViIGBsv1xBm
	agMvCO1GGjnO/64MWhRZugYdI6u84oC9JSyD7uGOlxiNSwNS1dpKGelEKT/vj9+/yvHOqzrcAPb
	WJvAl/EUEERsVBCwoMp0gxlG5kf+kdtvkPJKMO4jy2evgAXEJ3ljCOP+2hL3oSzhCkjDPPCt7U3
	hGZLKSE+ftjc=
X-Received: by 2002:a05:651c:221f:b0:3a3:2585:3bc5 with SMTP id
 38308e7fff4ca-3a371a898d4mr40270231fa.3.1788972119897; Wed, 09 Sep 2026
 09:41:59 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <CAMgjq7AHRzBsbmGOx0s=TQFBwcn=DEU1naR443sO6x+pJd6hAg@mail.gmail.com> <aqBT_35E-eSoN_zj@cmpxchg.org>
In-Reply-To: <aqBT_35E-eSoN_zj@cmpxchg.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 9 Sep 2026 09:41:46 -0700
X-Gm-Features: AcwNN1VWXPWfi4oFELOf49OQVDIrkZtLFgj_RbpHarRwRGht_40BlAv3JxkMu4E
Message-ID: <CAKEwX=N4aaq_oD2agTUNrUNXhaYGeQ9vxu+dywFvEFgWFi4uQg@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <ryncsn@gmail.com>, Chris Li <chrisl@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 033341C0007
X-Stat-Signature: s63oi65iiw9f8h4yue8c9dmtwj9wdxzc
X-Rspam-User: 
X-HE-Tag: 1788972121-572200
X-HE-Meta: U2FsdGVkX1/W6ZFWxUQmLYQahBD5c2JvakMg4RAP9htqads6UMcj9gi+GZ1pW2GpqilmuEJO2RosZEWoKAYAvuCv7plxwZEhBbJ1FBSyjMLjTzkR3xhpuTFqphhbq4eITl+j9dAAQC10JyzurRj7r8lJsQQIBsWKMRS3OaKJkWCPJKbIw2Sj9md7agNOiWoAJfDZn6260iMIBTx+jm1zt6c6BzRm/banf4YI1dIexIsl4dKcIgApnxa5mwoxQc1lOAgSc2L5IE4xP74JUdnYybwxoscl+y6Cb5Wog0YUNipU9tcK/FNGenLuR1udDDCehCDGjyVxzBUTHUQHeXRQr8Z9kIMi3Dombe6yU6anQeQeMAOGT9A7gfN6y28T4zE+JKGoV8NiD/5LIdtaVeTi1a1E+iB60EyI/W2FOFCermSXxFzkJYETECDQUNxfykcuP4veaaG621L48SU3dDTePCcVu1I8vqTH02T/xj8Ntf8aeqrRPcir4T4+qKO+4CoQrxUQiP5E0fagG9cLtABXcKMoeVJj/QEhIi0Zv16fxu6SnZJTpuvevwgRuBAhfL0GjsdS3ZzOx0QtF0huXcGQli80Ag58UHoH5CbuJCizgR9yrWSKuO9tOZv2Lk0+W3WLUCdnhkn8Kqd1qlUfreYznw8FPIFu4Zm9tOhaUgB8mdccAXfe+htFWHs2gNReA+XOI+CG3hggOo5jDmx5OvxlvU8EqSf+ffgrs7/9toc/eyHA22Bv5wOvRccUJnRQYHIWveZTzCYypwTyO9c8s943z9gkeeBlo1fTSKXYcFmIEogfeX3usrI92rtQWFOZc7z6tZ2zJt7/3JwqllX8fVDhX2QIbECQi9d+kVuSqHFPYLvx/kQtewqSK0uAU4OBjn7+321/seFdXEf6Ua47vefdCQfejbZcLHwOLGpsoJkjjjlpFXx8giH5tlVbIOcHLbX1RAMmNF2rOv6AjrHqP5C
 CCdE3hsE
 3xXAbIa1HBG8JVB4fI2aGbG516rrsKDmdwmwaK0VpKRRRgFg1trm6cvu9ux4x2fymnD50BJfwuKs6gcB91wdrHIpAgiUUn/phz/QJ18sKPgIqwqrZ/iuFEr5cbNojAFWVgNhYlTPCqWds7Z1k75r1TITEq8OFWCzw3UaNs6GziPDjJCNKyw3zM9D4+wTzkxMdaojkf5zwZx7fzNugB0CUpJ0rcMW91RCkINtzl4wzufk3smGLpvq6O1ABxla92QBMaKnI/tL0Wo5a9opa7I5PEiFCCjuJCTVW0CusUA3IMEZIGKV5wGHO206I9z6NIHYDtMvBpznI+FdstefIrkamCe1ul8N8ArPxkTMUfvqj7CtS3Mu+pfPuZbwEA7m4j+aJfr4RF0X9VJwDRO1M4en5XsWG8hKnL3hutEKkU1NKr6hT+buG35Z++WL5KAabwbzRrnr7B8G16EYEw258YMCwIB32z1zi8nC6OqEXaFvLtpHCfyqRWgHCImanZqNVbA89XsFSrJxE+Mt8pCSKZgcLvjrrUI9/8YvgIoXPIyEKPkSeqSXwXEzcDbC4lau56L2EOQk/htsPjYlSvTk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 8, 2026 at 11:30=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.org=
> wrote:
>
> On Mon, Sep 07, 2026 at 01:51:31PM +0800, Kairui Song wrote:
> > Where I've ended up is that unbounded growth is a real concern. On a
> > host with no memcg limit (root cgroup, and most desktop and embedded
> > setups), an unlimited pool means usage can keep growing, with no
> > admin visible ceiling at all. I'm not attached to xswap's percent of RA=
M
> > knob specifically, but I do think some kind of bound makes sense.
>
> Swap space is just process virtual address space, no?
>
> Swap entries already have one or more page table entries pointing to
> them, which in turn are managed by trees of vm_area_structs. That
> means rlimits apply, overcommit protection applies, and OOM killer
> attribution works as well (oom_badness()).

I tested this theory. I spinned up a process, and let it spam 0-filled
memory + swap these pages out continually.

As you predicted, oom-killer picked it up eventually. The host was
(and is) intact otherwise :)

