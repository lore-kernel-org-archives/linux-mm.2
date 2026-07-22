Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBE9FC4452D
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 00:03:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8ED9C6B009F; Tue, 21 Jul 2026 20:03:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89EBF6B00A0; Tue, 21 Jul 2026 20:03:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 742A46B00A1; Tue, 21 Jul 2026 20:03:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 390D06B009F
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 20:03:20 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AB8B1C02EA
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 00:03:19 +0000 (UTC)
X-FDA: 85014462918.18.F1B5008
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf29.hostedemail.com (Postfix) with ESMTP id CC8B2120007
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 00:03:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=S8n65Agm;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784678597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1AYRyVQkaEmqtDUDkAJMb+MSAcyOE9oAfv0pdUavraw=;
	b=Jg+niAEOuwiGuqqa2oOWmCI3CN1nQGV+Q4t4NcyCwE+jpLYbsByUMSd8r0mHgJcRihe2ii
	7avr4t+zJPupzfVcC5c6foWcPgeL7UR4Sw+z7Tn/sSo9gpU0aTalxmt9f8uufXkPdevmTy
	nZ5y5fX7nbddppEWMAeKdk2CI+F3fdk=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=S8n65Agm;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784678597;
	b=Et78bmoorNdYuk7f9AedqKhVn8vNSIIyafaL5Eq5UkLtnJlFjDfL2nxJSrdBliZp6XvZNu
	6n7vXm/KcbK/8LJ44Qp2mdWdtGetsGumdNByCV4d0jL+p9jylD07rn9K8OyWGqIe/ohfWe
	xNpN5UC/LHCuGXwoaNAsvnt67Ds/Y+0=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-47f6609c657so1847591f8f.2
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 17:03:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784678596; cv=none;
        d=google.com; s=arc-20260327;
        b=N9qBxENT9lOVysNppWQwaE9WCA0J6LeFm5tKTIglFi8ZzJ4S4anEQRTMA+BBFUXWQO
         QUF88/95hOGfysP8dgauu+WCWJsg43apvuUdDh4GZ6DtGCOmjQ8HZaTamuw4D7mpeEtT
         FlOxK+oBf7z2fidH6OIakusuf98aKaI5LYq1zNNvsBHlKr4E26wc7NyKPrA4N7IphN+h
         glLT9oimCCHYgl27v3ztDRNat9lSh1q0AohmCM8B2+JsixTOkAQIhO9NBVw5cijywTV9
         3woLfF/pUwA4IFVVc/P5ohVaaRxabkewWnb7lWzF0/uEMsX2Ccsy6NzjoaUF3ARLsgdv
         3LjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1AYRyVQkaEmqtDUDkAJMb+MSAcyOE9oAfv0pdUavraw=;
        fh=57KQBv/PrShrlamtf7k/Dha2IN5BI61WY4AmyidxYiE=;
        b=KG46zjIMCmq9UNaMS5Re9FuFBGCrOxb5EHesMbAsDUHSPeJCWj/QX6OBXZ1e0DsGX+
         kXBFUySVllk8H2IOHi0FqVrPskyYGS7woSteQnc4yJodDarHgHvBn2nJF9ZDl5Terni8
         6JE18E7I9C7QkX/insBPkhOf6JYrmboLRnTEh+sGPoBP4Fmn0FtIUXtnSte6DcMN2bSE
         LBf9vKCJ3+7kzQtPXsRm9HCsGbge14crqT8BbySTlc/XdnEIF94qvcZ2Fd//of/FGw/C
         0ZqKVbcBOwZ5C8eAOL2XiWOoRfd5J1JbihXZLQtkWxqfY4NTONs/iySe4/IBTTUN2DRC
         pKsA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784678596; x=1785283396; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1AYRyVQkaEmqtDUDkAJMb+MSAcyOE9oAfv0pdUavraw=;
        b=S8n65Agmjl0osWPAAkftfaXwiqHFgNYwKkeHI0VhwSd2LQvlVeq6HZCyU3CPs5DzzI
         pW10H0GHf+iutzfl3/93SwHy7aG/P1sVsc63kvk4FH4YkkSnJ0G5q1xz6kMAA5dNZHg9
         KLnU501zNLhM10anXchUMdkV1qiRpb1wdd2nJPey+AbkyY2EnnOwOpg0rLs+EcDxCnTd
         iLVUFhmPUwPrzPG6sK8WxzJy81FIdHv6+BUNR2bhuu+aC7hLnoM6Dq0Fnc80xUL6PziT
         DqMCzvqP47K511npZ/fs+VgCj9rIPmiC4vVa87jkYZqVIokw4XI/LfP1gnfz+IjbV4Z7
         6s3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784678596; x=1785283396;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1AYRyVQkaEmqtDUDkAJMb+MSAcyOE9oAfv0pdUavraw=;
        b=HOoq76FmjdoyaXX8L4D+ahfH1juBRDC5YEAH5/Mz5XVcAbDLYUmTPVfwhGwO88Vkm5
         ZBON1E/kdA6/8csopeYyJwQwFv70w506qT5WJRRKKGkN8PtkeTzLApldBNsgFKJ6Ouex
         LWq1L565t94TgFrsec3Kvf1f0sEk2TjxKJznxxbuBJ7M+s+fT34AmKcup2svWYoDNNnU
         0EwjP4TJlrCD8etepgeOpH4ku6kATsf7vNWGVyeu4kJoM6/RDRgqemE4lHDIo3rfcYn2
         PcAQ/ZZ+37ADGV8a9QvmQyDLO7CJpY9fcNQ3P8ApOXXfsZReohfCHJjDUZCJIz61N+4V
         m3UA==
X-Gm-Message-State: AOJu0YyJSpcf12bydzhA62xFlWmtjzU0o987Clb//DC4cINtyZCpdJq0
	6oEUoNIMTd53Hk/VdidK+WfD48XwXRTXlTXZAZ4h7l+/LUVIpzcE8jwFy8VFvQFyY9VUTkx0Y9W
	e6NBc64Pse6RSom7oJb1eA92vl8i+z08=
X-Gm-Gg: AR+sD11Dr2CrrK73FTVUwxV0SIiSodR85mdapwGw2w9RMGZdVetlLGUYUketGqVPoNc
	y9TOsavKHM6M+9IxrXr30uGCfeQ2OL8BJm/w+vJcymArVmsDCNp39fp15BinHTjz37PAdT8GUu7
	fLKTiVNOOEucdgN3SkfI3UYaf4+naSMqsyAXg8bFqpc94tpgfw+0RBl6m4u9VapCgyvwfMf1BFP
	IYAtVhP+172hjNX0nBXSV3vBiPlMsUH5bZFog+IyYmd5PSqqV6HD+hYK29iP22vVI28tXOfPqMn
	+llvZlYjcXe1ZyzxtqNlqr3q9VNt8sPYXUvWn0iQ3w==
X-Received: by 2002:a05:6000:2907:b0:47f:83b3:2d46 with SMTP id
 ffacd0b85a97d-47f83b32e51mr2886545f8f.3.1784678595910; Tue, 21 Jul 2026
 17:03:15 -0700 (PDT)
MIME-Version: 1.0
References: <20260502-mglru-fg-v1-0-913619b014d9@tencent.com>
In-Reply-To: <20260502-mglru-fg-v1-0-913619b014d9@tencent.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 21 Jul 2026 17:03:04 -0700
X-Gm-Features: AUfX_mxfaOeWBE5KITDSWBxPG5UQ-x6V2_LKzCwNESWWIKmtvkBJX9x02LAZMb8
Message-ID: <CAJnrk1b-5eQrPtug7i7n0h7=j0gaaGhihf3tbBZLfxz5fABUiw@mail.gmail.com>
Subject: Re: [PATCH RFC 00/32] mm/mglru: MGLRU-FG and refault distance support
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, SeongJae Park <sj@kernel.org>, 
	David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@huaweicloud.com>, Tal Zussman <tz2294@columbia.edu>, 
	Kairui Song <ryncsn@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: CC8B2120007
X-Rspamd-Server: rspam01
X-Stat-Signature: xea1ifbegghjckhgbrgjytximynneo9p
X-HE-Tag: 1784678597-121517
X-HE-Meta: U2FsdGVkX1+7kNk7T73ApQcQQMmfQfIrCq7OoGjJwFVaRbDuYb0r9zEqGnV0xeREMjz2vBeBYyIW8RM0wvpZZm457apJwnNitZV8qvZFv3cZwMWJ+c7rDWkheDef+3xo6HeDkI8Zp7ZY+fnhNr6AUsXdvkmzP8k06sjFxy9l5g6ejcj72E57dxTVOwePQRMy3HNzuH22skf+jAEktQdCHDNQqsir3dQEF6680Lny/Gl6Gqz7VKA9tS1ExF/VwX2nftgHGIRTM0xUb864ONuCwBu7RS8SA5OOjCix+Ahm7Q5seqsSbB/1Fdf0XGAXrK+oD63M8K6/6E9ogUmrTXhry/OfA/htR3f8yi176IWTVdrBCcgb7fGRufP0oxCtP+vWJ0FcEIRLNUtIPhO9jZiJ/zpzKXbNNBhnWVjwiY8L2sOzy+he1uLi/SmtUWc0t7m/w6Lys+Cb75tYHSlibt2OXsVpvqgtqSaYDFbc6Nl25alwDnibMPAA9ZQplCGQ9f/vCrjCNYmc6e4kht5u3MgL8QTGLJbVzyxbsjn/ao/OTQv81OgUKB/RhYRXKLXmQnpfFxIf8nKwymMAf4L8FaI1xZR/NgTsOipApK6Uh4f1hjoO3LjlN2uDVl7muMN/1sglFfpOmLcR5atvo2C1a003xdwc7XGqIxMXfN/ruDeJmQsVCIh8RN5ox1fA43Aj6E0JIA0u95L6XelfUTE17gFyFVURsgKY9YENSHqr4l44BuIlYevracKPwbruvwTeWvT8CaWxaeuw6ZchjswlQ+HjC63n9t3AuFs2Sa7NWQz96mnIvm4ms10LqrKAfY9C+sYXyPoRidqWXeFvrqhDeLRR3BgUoIhUlh2p+CgzwL6qWkxNPJ3gM400PNmaW1kvmo/H/YOVuDwkMBMbfXm8pudMZlVcXw15jYMQBWzHssQQLNlGhnuajAIMR6F/NnQZKy2Hf/Pknw0I1kLc45YPd1/
 zh64hglk
 g99n+DEMxt7Oby5sa2U/nTNHMFpAaPj8hwgUNc9iN0ISXKyToWFmfRAbTeZXV67ivTqeJQ4/FvJ1I3qnKVU/0ZwVx/jsVy7SHWzQCsHCerUyGFUV8GGtqTTm/oyHEmwWCg/rbUP9NyX0AdpSh6uwWHfE4q5wa+0SqmGpWM4Y28DKCMtKkAdmbCbONg7WmjBdxhm/FKJdU6i/athZV0b9fnYzV+qOFCJN0/zzs3GID2URVXycIs7M6/no630GzD79/AumPHGCgnbNxrSYVf0Buenf04XS0LremU4Fy/Jk9MKbqsfY3GooW3Uly1wm+ot1Ut/hiQJDdXofu+W4wGaZCwqJTl8XG+GWPsIDRNeoP9sw7LRU2YPSWskfE9hVRJPyIMlv9M0Xgu72siNohU/aszYYH/Ap0jS+Pq/KtY611btg55Ck=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 1, 2026 at 2:03=E2=80=AFPM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> This is an RFC following the idea proposed as LSFMMBPF topic [1] this
> year for demonstrating the design and improvements, sending it out so it
> can be discussed better before or after the event. It's stable and
> performing well, but obviously, it's too long for review, so I plan to
> send these out step by step if we are OK with the basic ideas here.

Hi Kairui,

Could you give an update on what your status and plans are for this
series? Are you still planning to send this out in independent chunks,
and if so, do you have a sense of the ordering you're thinking of?

> Worth noting that the design is still not finalized yet, the tier and
> refault calculation can still be better adjusted, and with more
> benchmarking and testing. This is rebased on top of the current
> mm-unstable as it is supposed to work on top of another series which is
> currently there [4].
>
> With this series, I'm seeing an obviously performance gain for tests
> like GET/SCAN with LevelDB (which is borrowed from Tal's paper [2])
> and MongoDB with TPCC [3] or YCSB [4]:
>
> GET/SCAN LevelDB [2]:
> Classical LRU: throughput_avg: 993.64 Ops/s

If I'm understanding it correctly (and please correct me here if not
:)), the changes in patch 22 ("mm/workingset: simplify and use a more
intuitive model") for calculating the refault distance would also
affect classical LRU - did you also see any differences in performance
for Classical LRU before vs. after?

> MGLRU before:  throughput_avg: 951.12 Ops/s
> MGLRU after:   throughput_avg: 1344.72 Ops/s (+41% faster)

The numbers look awesome! Do you know how much of that is attributed
to the MGLRU-FG changes vs the refault distance improvements?

>
> MongoDB YCSB workloadb (MGLRU):
> Before: 82127.65 ops/sec
> After:  95933.99 ops/sec (+16.8%)
>
> Build kernel test (MGLRU):
> Before: refault_file: 259681   refault_anon: 3006202  real: 1m49.005s
> After:  refault_file: 201472   refault_anon: 3048107  reaL: 1m49.050s
>
> FIO with zipf:
> Before: 73557.72 MB/s
> After:  74553.44 MB/s
>
> Also, mechanisms like PSI, smap, readahead, will all have better
> accuracy since this series unified the flag usage between classical
> LRU and MGLRU.
>
> This also reduces MGLRU's max flag usage by one, and hopefully provides
> a generic API for other components like DAMON to contribute to MGLRU's
> hotness tracking.
>
> Other tests like the MySQL are looking fine, no regression. Filesearch
> test in [2] also shows some improvement, not comparable to cache_ext, sin=
ce
> this still need to rely on things like the refault distance to establish =
a
> pattern before it takes any effect, but more generic.
>
> This series basically composed of three parts:
>
> 1) Make the MGLRU be frequency guided and rework MGLRU's flag format
>    to shrink the bit usage. The format rework and MGLRU-FG design is
>    strongly bound togther with 2) below.

Could you say more about what binds the flag format rework to the
frequency-guided changes? In my reading of it, the patches for the
flag reformat work (encoding refs as a single int with
PG_referenced/PG_workingset as the low bits), the addition of the new
generic LRU-refs API, converting all workingset / referenced flag
users to this new API, and then deleting the
PG_referenced/PG_workingset page flags seem all valuable and
non-controversial on their own. Would it be feasible to have this
first as its own standalone series, with the patches that change
reclaim behavior (MGLRU-FG, refault distance) separated out into
follow-on series?

Thanks,
Joanne

