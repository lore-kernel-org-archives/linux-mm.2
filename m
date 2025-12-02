Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0F99D11713
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 17:02:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24E0D6B0024; Tue,  2 Dec 2025 12:02:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 224F66B0027; Tue,  2 Dec 2025 12:02:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 162426B0028; Tue,  2 Dec 2025 12:02:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 07D4D6B0024
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 12:02:32 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 93699139FF1
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 17:02:31 +0000 (UTC)
X-FDA: 84175149702.23.0398FA5
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3243240026
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 17:02:29 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=ccbxzCiz;
	spf=pass (imf01.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.177 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764694949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H+OuyPHxCQDMrymswmmyDSF1luxCUexrH74veMbiNtA=;
	b=WPbeivxw4hvbtOMaUw9ZdxOfmrDs2nYSq8sfJw6XIjikyH0vczWPtAyxvGn7gBX8YSNpD3
	b9th25YeV6l88X6AbesJndlcvsu0oD7xyXIRxst2YLGbRtr9JXfWy/ruMe1DfehbIWNxMq
	WozKsDuiz480pzWE2u+nvF0gTtTXXXg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=ccbxzCiz;
	spf=pass (imf01.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.177 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764694949; a=rsa-sha256;
	cv=none;
	b=gB74nmiW/XNopx7P2kylf0RJXWqMf/UulyZLF39eFqq1aU5acyqUSncS5uCCOWun8q6CVM
	VHUZ978acS19s7/kIGZRhBYsV44LVS8WJEZKwHTNYDzSDJ+HrUcKTq1WWur8Nid2FZvZqz
	0yT95f0/S0OwK+4JEiflCh11VqMVnkU=
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-8b1f2fbaed7so512349485a.2
        for <linux-mm@kvack.org>; Tue, 02 Dec 2025 09:02:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1764694948; x=1765299748; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=H+OuyPHxCQDMrymswmmyDSF1luxCUexrH74veMbiNtA=;
        b=ccbxzCizJalYy0A9RNmyrTP+EoctdMmtZrFEM2Z2WkML0+OCj0f799cA8YQfQOus7u
         M3+Uu+LSheoXMPI+DZcxJa9H5/JbN01dVRpOEJjy4MPNr7NEDplVAqa3TO5M9J7Cwx7n
         k5mXG0wJAM7UPdYTKbnB5doczIBGu4cJlKW8hnFBu5f14MIG2EBBmECG/UuU+N/DAVwN
         +kQF/YljVBPE32pjGKjUmPbMPg8z6AMORpn2KQCFLBXetfKWKl5QnIJDxnr9BchdrMPt
         yfa1g5IBebxZCWLc1imdH1EqtlTfVMlSxnrmpeIGTKEV+NOQ3REzuwP6YJq9N82CJBIB
         XVeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764694948; x=1765299748;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H+OuyPHxCQDMrymswmmyDSF1luxCUexrH74veMbiNtA=;
        b=HgYvAqGJdHaHYAOgHHRccTgJpIbPhsVU6s+lQXaJLD2wvwmyA851HY3nb4isGoNnXW
         GneP7qd0nrYAtSYsNvfu7u6qxzbL9w2o83CxOa97SD8riL227GVtZ2IkXhwblc23bEUz
         s2AqkuMOVbhOadka+urqeUeXHdNzMni3zvI8zxrPcnN8rUn4vUx27I7/wApRdv8jNTsU
         AFCgaW8+tsKWlMRAY44e6wiuKSR052mt5MLXdCqjy2RtzvXW6oRhubxMJcH1mYg7oOxV
         Y8sxVOJt2KybyhtRovKwcs735AohdB42jPXN2B8b5pHsBq3QMtojW0zkL/iHxsurDIKe
         1aiw==
X-Gm-Message-State: AOJu0YxaXZ0DbH7QtuYO0FCRhYOmsU4L6O05DUh5shziLzuADH8uxT5f
	un1gkwWoaBWEyQ+xDf7zafMfyj+D8zcm5sfy1be42MwRpDnMc6IU/TEz2s+xE56MUK8=
X-Gm-Gg: ASbGncs+ooUgS8Z8h7Dzp1RHdVuGdgu+v3OMUgiJQbJlqURpeYwsg/hnWKF+b8Yqa+a
	pHFd9IVIBurGdz3eXUwEvkKDjAwg3V/AzKynvkqqpKkfiwhIT0J+D2cRGJjJqvxFah+n23Z1mNz
	Er2xqN9mqArw01Utbj57CCfVEiMIu2Lu0Q5rX2lhwfaMyklu+SHECHoteYqy2EaKL05e4fK2k5Y
	WKw90N+CpXZ1d7Sj+qulQu2Z3kr8ZUEWUmvZRZeXTAhV0Sx7/EaBBof9SLit1dVFmza93HU25JM
	1dNIQPrOSLe03Illm5NZsNmaOr+h/m2WSn1rBMVjPnO5RZtfnU6jmk7GH+PeIF1H797umyNrAYY
	bmosKN6yEGEnCVMlQr/8+gxfA/R2nM4gdnLVNVKJ9ESilaBe8SayfT9ASw/5BQPkq2Dv5bJuwEM
	4A6zeT22OhSQ==
X-Google-Smtp-Source: AGHT+IGCVAZCypxPe+el89uDov8jVesjd8N5Zeup/G2N11S9vRlXKFnljDCNMJXe65zPvUxUNdUX/g==
X-Received: by 2002:a05:620a:4509:b0:8b2:7679:4d2d with SMTP id af79cd13be357-8b5d2f29036mr4235885a.63.1764694947819;
        Tue, 02 Dec 2025 09:02:27 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b5299a69d1sm1105042185a.16.2025.12.02.09.02.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 09:02:26 -0800 (PST)
Date: Tue, 2 Dec 2025 12:02:22 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>, Rik van Riel <riel@surriel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	YoungJun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org,
	pratmal@google.com, sweettea@google.com, gthelen@google.com,
	weixugc@google.com
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
Message-ID: <20251202170222.GD430226@cmpxchg.org>
References: <20251125213126.GB135004@cmpxchg.org>
 <CACePvbXstKtQXE+0i-KRcq5LwrCr92a_FKy2KBmqaiwZEkFxng@mail.gmail.com>
 <7665130c511e3cd00f83e8b14de2b78e08830887.camel@surriel.com>
 <CACePvbWcYsm3WpQSkbiSKESpHOb+QybNTxtDL9mCvRd__Xj4Aw@mail.gmail.com>
 <7e44e8654eb0ed5e0f590b3d705b258772dadb57.camel@surriel.com>
 <CACePvbUSHYgit93ofjg6cMfb+CR9x6CZnMGh7Utb+zEzkOG75w@mail.gmail.com>
 <CAKEwX=MMgOb+7tDxPXDCcBxCEztvajDa0YfLBqgGuAr8GQ4s1A@mail.gmail.com>
 <CACePvbWV3STyCg0vYDXYg7asnxLTa4Jb5Fa59g7_QeTVxKV=ig@mail.gmail.com>
 <20251201164338.GA430226@cmpxchg.org>
 <CAMgjq7Ch+M21W0YH-edngSYVfb07-m-bVq=zTenF2PLcAPt4EA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7Ch+M21W0YH-edngSYVfb07-m-bVq=zTenF2PLcAPt4EA@mail.gmail.com>
X-Stat-Signature: r3zqsk1xbqj8eab9u5cj3oifddx3ampd
X-Rspam-User: 
X-Rspamd-Queue-Id: 3243240026
X-Rspamd-Server: rspam09
X-HE-Tag: 1764694949-630472
X-HE-Meta: U2FsdGVkX183nsoxpikYdkOSn37MvFQulJXwwVzh5D7RGKBwU7oTUFCCkbXhrHY4g0INX3g4NW1DkGF9LPCHZg0HuyvFS2AyU+HsdL4AmQnRtfn93oSRe4qH/DSpfJNgejVWAMRDSnoPoMHOXPbq0IbXafqMlPFexu38XKkSd4MD3OMs1UFGRJcNvCtf/2dDwiop9WB2+q4vx/CSqh/58UpK6uuc0XDZvCeaLK8KtZFs0aOXGz9P7P/lV1S8OfEh1fhP1vuMrCCKP3YAwME0ClkOg/f+VJGQ9JSLShgYBLMLY+TpIEmjlMICqe9dBbQwePqjJCIzWAHK4U5F9CAx29rsaf0ZYLEVlXIER9Gsdm9dAagqm6N7mlqmbof8Qw3QzCZHOUA59pUkzAESSeJNIeOOg54uiMkqBNHisB48QEMbRq8MDiO1nnVHQDo+rZGAZfHp7rqlrhVT+H5QO6FNAN5OhmOEKPzEtuZbLqBVQ9hf3venHzofF7P6sjrCpyjGMetBvtNqAKjIgDw8yp3CAwcwKJNYUblRoDNlud/m8kCYdszOso+vLhwaLe8kSzef0tK6Mjet1gLH/tz+9++BF4ryosUbj11LKswc3d518mCv7X4RKq5QYANBvNJEJlfAWU2gkPvF0E4UjnlJzdia6n18eEYcseUZkO27gAs9/n28Jcf4w6EbwwruZHGbltG1TbCnNWwM1PMV7yHRz0RJvqO4G+i1pqMbiRxKzDLa/eXB6IxYBg6g1C1J2u05B7oqDrvW3FX+vsiJMlJb08u7SNVYLWw1cPsxs47W5PKknyMAPCQaKIU20gqp3XtwBh1ga3KY0magbsJ51tVM0akrOHlfAxr5swib5N1wk6dFFOE+takXA3rXvVVEUonF1FUaKBPkxrd4Vix1LrAKL4YV6aqKKeiUluV0zwD5RKrP0KdiyuQekjVqjbfyBu7oOeK5v1uFoA5LoJmNi2YEtA/
 Ie7xigJb
 +FkSZ+bSLk3DmFq1HP8HEpXSoYcMUOLntLA74Wj2opmiR0e5G2U7FypwlWK/lq+khIg1siSTMb2N1K+3qdp+oeNiGkxiNWtR2KD3uQgiiKa6edW2jo3baIvjAyO1vSuMb7PfUFutIwYfOvh5zZ058EXFcVPGzNFERqAHLYv6Uhw/34bO/PvumnbfWBfxjmtFRzpWg3kdvM3WLV4lDbkwR+QvcmkKiLrJvQcfYyIokqNFTH+bTqc7jB7wW/e8ZKbT/yvt50Ez5xnQ9+0bI/jf8T0vDNB49tp+httmdJBcuBKtOYREYDoFhmjOMbD6U/tVH+FB4EYm0+VgCeRnAbZdgMz0y64JTkDJApe1N0rZQBsaDQDpWh0/oA/AFdvIF1SQDpHT+it2jcvTPwcjTUlh2g4ov3oAU+qjWC/6Lvo+LrOhLNtWGG6pRIBIi1w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 02, 2025 at 03:49:22AM +0800, Kairui Song wrote:
> From my perspective, Chris did co-developed, suggested, reviewed or
> authored many of the implementation details around the swap-table
> idea, and he implemented the swap cluster allocator in 6.11, which
> unlocked a bunch of follow-on optimizations.
> 
> I’ve been working on swap for a while as well and have rewritten and
> refactored large parts of the swap, swap allocator and swap cache
> (mm/swapfile.c, mm/swap_state.c, swap.h, swap_table.h). Maybe, yeah,
> I’m not a kernel vet with decades of patches yet, but I do think I'm
> familiar enough with swap. I think Chris' work, words or code, has
> been looking good in the end results.

I have absolute respect for your work. And if you say Chris was
instrumental to getting it done, I will take your word for it.

> It's hard to put a penthouse on a sandcastle, and maybe that's the
> reason makes it hard to describe or layout the further implementations
> of swap.

Sure, I can understand that. However, I think the conflict is not
necessarily about implementation strategy, it's about priorities.

We have a usecase. We have a functional implementation that satisfies
this usecase. It was sent as RFCs early on to gain consensus on the
direction and find the best tradeoffs wrt other usecases. These RFC
threads are the place to voice concerns and influence direction.

Both Chris and you have stated that further swap table work *may* also
enable this usecase. However, at this time, I think it's also fair to
say that it's more of an afterthought, and no concrete design or code
for how this would actually look like has been proposed. High-level
ideas have been floated, but as you can see from Nhat, Rik's, Yosry's
and my replies, they don't really meet the necessary requirements.

This is not some principled stance. The virtual swap patches are
difficult to develop, especially given the current rate of change of
the underlying swap codebase. If anybody working on vswap had seen a
plausible way to solve these issues through incremental swap table
improvements they would have jumped on it a long time ago.

It's more about priorities. Combining compression with disk swap is
extremely powerful, because it dramatically reduces the worst aspects
of both: it reduces the memory footprint of compression by shedding
the coldest data to disk; it reduces the IO latencies and flash wear
of disk swap through the writeback cache. In practice, this reduces
*average event rates of the entire reclaim/paging/IO stack*.

These are higher-order overhead savings that are difficult to beat
with first-order descriptor and lookup cost optimizations.

We obviously want to have both, but they are orthogonal goals. You can
see how it doesn't make sense for us to deprioritize the former for
the latter, or why Nhat says it's an apples to oranges comparison.

It also won't work for one party to say "we will fix this, give us
time". Everybody wants to advance the thing they primarily care about
with the least amount of detours. That's where we have to find
compromise. Either let people pursue what's most important to them, or
lay out an encompassing design to build consensus and organize effort.

And yes, let's please stay technical and on-topic in these
discussions. Let's acknowledge we have interests that overlap, and
interests that do not. Then find ways to service everybody's usecases.

Disagreements are part of the game. There is no need to get personal,
pull rank, or make accusations to dismiss somebody else's clearly
stated usecase, perspective, or objections.

The best way to avoid this is to make technical statements, and reply
with technical responses where those statements are made.

