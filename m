Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC3B0C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 17:33:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A82B86B00A6; Tue, 22 Sep 2026 13:33:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BB2E6B00A7; Tue, 22 Sep 2026 13:33:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8107D6B00A9; Tue, 22 Sep 2026 13:33:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 54DA46B00A6
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:33:03 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B99671405A1
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:33:02 +0000 (UTC)
X-FDA: 85242093804.16.C80099D
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf03.hostedemail.com (Postfix) with ESMTP id BE2A220003
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:33:00 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BCnnR1ca;
	spf=pass (imf03.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790098380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6wfVY0cj3I+ZyoFfhOD2M0rQu+6sC7TkY/5LoCxxQ7g=;
	b=efNJWjAANY+iPAfkzE6W3AugxEvasjoUdlOhNnN9MR/LIY6piOmQ9lvXzMjmVidiiIBRgy
	88oypMAMT6uRk/seWklYjw/JUG/RCmAqgz6zD+a0f5oeBRXS7w4W4icPSq9QPJ308lJkYk
	GDpdpXz38o5smoMKf5bWO8Ei/q3ardg=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790098380;
	b=NIMegXyoVZEDiYo+rNJlWgPkp0jTMVsPs7EPmjEL3i6qw9k54jNDvlh9Cik+deY86kNPrx
	k175TlnbtK4JXDEKyL/d7qfv0lRMjCiUiOcS3U3obYUqhgT4Oc1eXLYAG0+5WOQXpmlT3z
	p0PmJ6hP+MWFQP/MC5h/s6lOq3GvJso=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BCnnR1ca;
	spf=pass (imf03.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482f633ecdeso156639f8f.2
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 10:33:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790098379; cv=none;
        d=google.com; s=arc-20260327;
        b=M1ZKFWjWOzR5q0H/6v9BkWQrih4+2GUuMYyYT3hdPfysONPikgmRvkMiZORdbs0l9M
         F2NtjbpGck09amUIUtzfREdf1uW/YBpwGUfWGe5cCpXu1VRdeV8OBeBO7nqPRFBYH6Mb
         rkzmUMiSar9iW0INUp7sb9q01aWFfTWS1P/zWT8volPaQLeRyLwlK0C9AbSgKr6T+lHc
         AGqidZXp/l1h9da9Yc1X/ikW6SPd6H+JKATrrHjWNK8kXjhxbP8PWq7Ql0PZI2rAEBzD
         aDLWdAW8t99vpLmVPMdwYkE1MtlLB8LpKZCaoDI2u3c00ayS4m/bGxlukQ6OAwV1p0h5
         NAbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6wfVY0cj3I+ZyoFfhOD2M0rQu+6sC7TkY/5LoCxxQ7g=;
        fh=ZePrRYe6Ofn9HM1p6wwkbRVLHxdnoKuOkj8a41h3shA=;
        b=bokr6djJa8CsKYn87ARGBwg2Wn0Bba2o13mpr/k+facKT0uYiU/u1NA5R5wLxZX92C
         ny1EfD+xBFynwqY8rq7xhp9PEvHaB9fpUmX5n21bG70/dl8shc878wKflKUE2v574bWS
         AuOZxE8kxyucqL6UuMmxEDXoRvD87JI1Esg4p5FSXTVkFVQUWJm1UzWKbDCa96G3FCgo
         YCHDPkn06Mv5QV+B4ePEC9NnINf2DiZyjSqUc1EFpuK+tBDnGHUuHWtn0Il7o2T2YVUU
         6YlTzeWUHc0ZPvNZLzz69W0lYRuTDkmiaiFpNvhJKGKeSjXIVSbFRrSSOUYwkWav0Ggp
         /Zxg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790098379; x=1790703179; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6wfVY0cj3I+ZyoFfhOD2M0rQu+6sC7TkY/5LoCxxQ7g=;
        b=BCnnR1caG1NatbxbmnkiVubObdgDkKSLyZG6y6zqSRoQ8qrwc2wfz81NYVSXM1nYUR
         gvj/cEmxOj/pCiVUy7c1SiSsBYVsIUgkc35uL8oGYRX0smAFCQYmXP2eGpxNK47ZTs1o
         IYKNCIf6cZ4naeiDLYx36s4nGKzlpGYiKclXhNJlmpOqEauiuHtnHY8BWHjFhh1rUEBs
         MB+QqpfCT+zG+lUyNex4ikC/ogJlSXINilC2vr2C5ZNct7dP56s4ifQuJHYJEAeK1jsJ
         kkskeyZ9peXZKGL9soATJrsC7RU+HGVqcjjZdyOhVRSfwAbAeSEOc9U7RgM4+2eGnB9j
         /ObA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790098379; x=1790703179;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6wfVY0cj3I+ZyoFfhOD2M0rQu+6sC7TkY/5LoCxxQ7g=;
        b=qbbGw0ziPTz6ciyd/862wY9P0kcjXpSDduh6Ynmv7pK/i6KRtMNNEhGYSDZa8Bai5N
         XjOk5hDO/INlF25c9J9y6j7RY27ZTDacHOp2e5Sjs7GuEEcCqi1JPKvvEUEB1vuSh8B5
         d+xnoLU5wTL1nm4Rq6K8R5jKiOpTOywEL6HBzQpyHKwrnLA49juG+1WETZ16m52EO7ft
         5E/2lMFBbFx71TOeMLaOUGj/hXjZYyC1Za8EBWmkjCSkuB4iyKIlL/DtuJ+pVBF2HB4l
         l5AcoRuknH7x6gEzgZTMgCDhfAhcHYt21ea3Ga7ilH18zr2dtA0Zf/QCAUNLUlsZKwAv
         uQvA==
X-Forwarded-Encrypted: i=1; AKwUvBwXaGklx7JkPlaqSw4WvDGRhYdoEMUKEvzvUNagTCbH1U1i0N8NKncndV7/lglLgug4zqg4lb+8dA==@kvack.org
X-Gm-Message-State: AFuF++nRif/vajndMyQYvzuydHwMzgdKHBCHFkmnqJJ1WEKou1GOiXqA
	BiL+u4b9BIp4LhWAdjJEprAaHFYtvxrhV0NEJlquQh43kqpOhXehJfUvI1vBs+q3dfjMIBW/QUd
	UhgBm3pf2kWjIkg5yE6sHHt9AwGGgimw=
X-Gm-Gg: AYBFou2KghQJ8DeEwVzlke2GgmQyq3PWvwNXyOmJzMFdp7+COnK9BVF+ZvJIguqaAZe
	uFdA7jT6tKAbr5bsoiqps5m05fG+4kKCsSWk1y/GNsLy9HoHAVjEPInun8uIlATrj54Co4ZM7qv
	WT52poig+bEBoNHVELRUbcMaAWEpyV02z7tHQVdZ+It/C1MgNBm+cPg+lWNQutZqb3kOQCSmidI
	aWlpNTJT/W0fvwgQA03Jj7xdO2dLEKS8GcKbZ1Kqr1DAOYlKgQCaalnkgPdd/YG/oia2WR9TGAg
	6QdS2P7x5/M7+BxtqjIjedFaqNkqSaHCn1RFFVJLPiuvppSlaZx2fLC76030GXEwP8m9p31LUQd
	e6KGOtJq6vdk=
X-Received: by 2002:a5d:5d08:0:b0:485:ac35:5c5d with SMTP id
 ffacd0b85a97d-4886705d7f2mr561509f8f.15.1790098379271; Tue, 22 Sep 2026
 10:32:59 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora> <aqLi6cIjD2wJwk0B@cmpxchg.org> <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F> <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
 <aq8dja2-timYBwyB@gourry-fedora-PF4VCD3F> <CACePvbXudjxQ5vrrY4D1nOXKaFNQUn-tL+p3O0zfxtHXK99ojQ@mail.gmail.com>
 <e879ac65cb0940325736df7984c737edf1c6be94.camel@surriel.com>
 <CACePvbXThspPYD8DZkAeiJtYuMV79vGgC1SGhpMwhn4COWOtcg@mail.gmail.com>
 <785353ef79844e81a8cd97e87b00ef1f785b15e5.camel@surriel.com>
 <CACePvbXZ4i-DsmbQdNtBQb79y59uwZC9J8qHD2wTWpcYaet3LQ@mail.gmail.com>
 <83539be885f15bb567b30264f5f62e718f4a9fd0.camel@surriel.com>
 <CACePvbXZQERwLF_f2FYTHsv--kq_-Aw2vVVFF+z+ovdnsHy1bA@mail.gmail.com>
 <a75b2eac4297ca6b238dde6f9246d2c1807b935f.camel@surriel.com> <CACePvbW_-6M63_a7Cp+09dTmpHeMEdj9VDQZf8g8qoYKQD=wvw@mail.gmail.com>
In-Reply-To: <CACePvbW_-6M63_a7Cp+09dTmpHeMEdj9VDQZf8g8qoYKQD=wvw@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 22 Sep 2026 10:32:46 -0700
X-Gm-Features: AclHuK853Cv8o08iYHDa9EpXynqoJX_zkfnKle6O-lWkCRkEdpUZ-YCtbcciUuw
Message-ID: <CAKEwX=NrN7-u7gnGvWX3qfHaBQcN6FKsFP-4-k76F=sxM1LJqg@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Chris Li <chrisl@kernel.org>
Cc: Rik van Riel <riel@surriel.com>, Gregory Price <gourry@gourry.net>, 
	Johannes Weiner <hannes@cmpxchg.org>, Baoquan He <baoquan.he@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BE2A220003
X-Stat-Signature: ao17db88kozokcds81x8pe3fm1t46bzh
X-Rspam-User: 
X-HE-Tag: 1790098380-3180
X-HE-Meta: U2FsdGVkX1/FrsrS9Pq6BLg+B4GAovF6Vcz8xYW87hNRO9aP8n4+hrkG3ndzw46CPCAP1uy7UxsbGDP0iKy+Ytqkm2megqZ0QVfuUDrDTyndj+sKEY2r9oVqoydwAnpzDH83fl2pY0eylABnbBpKkY7HL3YMj0FLRKqUOgf/jynRYzBoEnOv51j4BDxhj6HXzVNXnv2dFXtkBjc+UgeCB3+ovIQr0YNeHUhuitMEM2YqVfy/nRj8p9MrBrLeT2h7Xklfq8hCbo3CAUAVjwwQkgHjdD0hRbH1S/Lr+AG67t24FDX9YomgvDxuRex5nvr4JXQbas0ug1I56f5F9e4CwhXEnwwwluNvOzu9DNgovtMud+inTGAPDwnnCQ0Ycj0AsQH5GFNVqLCisMXgffhPx+46t9ScgJ7Ut5RCbytLyv7UIkyva52cFAaafSEoE2WTiGwdG4bKBwtl5Ppx+5lAZ3VvUqCn/K+n1VORn/c4dcOm9vJT+VcY+Qu1JOzrSl7j6mBpB/YNdInvmH5oODsxLn02zuL96m0Sd13JZPhVIQEsrrvKw7OdiGucfuhegeVd6uvzuNluLtM2v7Gl68JV8A61yS2TunlWu2GjbMzCmd5rRiQO4G5JIiKS9r78uXppoTQWZtZj/Oz2aYC+hYN8yZFnfZUfAMwSdPOlnUkuK6lUTRgUM9YWNbDwMG4y2y0T+OSsCKVD+3c9YtcoyhPtg6mRCtfz9xQoeP5AujUVI0QfxNHqb3k1hNH/X9h+8UZ84942Ss0Kf1N7eegV/IBlhXmhslt63Rp8NnrUgC8vlKvhXhfYkR046NFviSA7aHf4dOUP/bfDDORmeUUAIyMjsmwpkojdIBue8bWl+dE98lkfGoq8LX3eUXAgtZtoEVaGiGZuojt1ESTCdDmbOpfve4Bah4sut6xQuJwriBLlsyjjk6boKmwnQUjTe88qlhs4W6ujEPbbjFvB9oLOG0X
 CjAP5YkF
 4ql94bZ2ttE9Hc3UBCO9JVZ5qy84xn0W6k6xrfiazuLJlVhlx3CzkgAQBEa975VoP9544KNpdI0feR+8cv2Fo9JL2vyRKCRkZyAZnT9oLQ18f1M6dz9OTxVUaoARwkjPjQ18J7lbsN/XGG+9q2GVQ/FCFIM9SQpYP1m63i/DbDZXvSr+0bmRUtkxXbelZ2DGeXm/pmzWrNH3e3dgssD4zot+/P2x7C5LTAtq3/nBgWjifXGNqRKc7BTS29s5KnmFr6UQ/i6tDdXvriqtrJytNp6bSm95Xb/lG3J4yq1C03YGBL4jdlteJdVrNHZJ+pDxXbWRsZtFF9pcSi5nMhBQt7h6PMpHPTHwSPAFPl9N553MGDqcGE0XQ1ktC8dlq1/eUyY5PrPAj4S3tjvz3awYp2kx5GYuDzpm5WeCNbbYrAk+Vb/ktNJUJ7Luo1ITbgh9ju2//6UIRElTkYJuUlvSIAT3yhq7F2SNXDHazvVnmaQZu1v7UbSPseDdbTEl5Ei182zJZ96rW6aRymTVY1Pk5xRceHTq2DP2aq5oJIiuKvx2kK7Zj8p0g880UPSrzweqYDZ+DRHQtQP9+/pgZJcvBNOQKqKgaEmmVVYnY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 8:23=E2=80=AFAM Chris Li <chrisl@kernel.org> wrote:
>
> On Tue, Sep 22, 2026 at 4:59=E2=80=AFAM Rik van Riel <riel@surriel.com> w=
rote:
>
> Yes, I can agree on what you observed. You are using anon + zswap on
> that app alone. That is not what I originally asked.
>
> My original request was for the whole system: what percentage of the
> total system RAM size has been swapped out to zswap.
>
> Because when you have 100% of zswap out, it will likely trigger
> different kernel code path on allocating memory. You might suffer
> global memory pressure you did not observe in the single app memory
> pressure case.

What does this 100% figure refer to? Pre- or post- compression size? I
legitimately cannot tell.

"Trigger different kernel code path on allocating memory" what do you
mean by this? This reads like you're referring to post-compression
size, where one cgroup eats up the RAM of the host, affecting other
tenants in that host. But putting a limit on the virtual device
capacity limits the PRE-compression footprint. It is a very
unpredictable way to prevent the effect you're referring to above,
because compression ratio is unpredictable ahead of time.

For post-compression size, I can make arguments on why we should not
also gate it, but regardless we already have zswap.max and the global
zswap pool limit.

