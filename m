Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93B85C982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 10:02:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F2CD6B00D7; Mon, 21 Sep 2026 06:02:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CBA26B00D9; Mon, 21 Sep 2026 06:02:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BAD16B00DB; Mon, 21 Sep 2026 06:02:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3FCD26B00D7
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:02:03 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7EADC140111
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:02:02 +0000 (UTC)
X-FDA: 85237328484.28.B37BA6C
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8D6691C000C
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:02:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ldpls4gg;
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789984920;
	b=LIi2amfBAxyLdwa4fvwywIRMh3O9vyjL9tBZZV+VJtsa/0AYuh46mL+RbIIxh9GCxAOO0t
	D5F7mNP1B9PKKHdkUTTpCFZYM15F5wF8NNx6g58sw3zW8jAjYLwk5qLdfbqWniEOSfjELi
	p+OH1gzrwC8962jECQCZLfoXrke/mKA=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ldpls4gg;
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789984920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rtgPtMT7frKhH4WMKdwbGRv258dVgwZlagcB0deq+D8=;
	b=o3+bhl33Ehae6MwmJxVPtF55xXCtU9lZbM96yzBBj8Etud/qbf0LOHaW8UhQbX8Aig5sGP
	oXqADbb8il455D7tsC1eo/tkbAiBeacYLnxAPba071SN0Y/aE65HoxrM3S4pslEgOdrEIB
	6aQsQODI1d7B1k7uxhI5P49g4vI4+SE=
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-cc147d86bebso2215812a12.0
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 03:02:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789984919; cv=none;
        d=google.com; s=arc-20260327;
        b=oExXfUdu+sNag6V4M69Jn6NQ37juwHo/u1P9ydOA5i19ulltNa1/a+Lq9hGTH2NinA
         r1mgYBTc66nVksb8MdAVv9Wk5KOnZIxWwPolOeAytPbNDSEXcSsVj8xn58zE4JHz06x5
         mcFKcFq3woNfzK2QfFllKiHT5wdKmZ0WsBpr6EJfPOgjU7kA/xVfR7IwSBRzqHi8FiqG
         OYecFTBUL4oKU+Df/kSShp2cvhwY1F74FF2jvjRSY6Hms98d+ogwCSsq3fPAd4W17e6H
         oK2g/N6mmtil6E8GNS3rpPce/V2DFhoqEnWGPtW6OijAOCGStamA7Ic/fN1B7JyfcQWu
         xOfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rtgPtMT7frKhH4WMKdwbGRv258dVgwZlagcB0deq+D8=;
        fh=Kjtg+wrh0z3GYqNNMKKx2uKw/YRwRfVZBN6894kOavI=;
        b=LVENPtGTD8f4edqgnD1p5ZPxCIOaDRp41JH7mF3b2lRa5N7KrerTBc48dOSOS1p/le
         OZTHvLTTJwdlfy6kK+Lcjdp0Y3RCx4QCmQr6TArGByASHfM3KQS0icrlpe1MkUIFwxxy
         SJ8hEQ0d1j87Pzfc87V7fsX4eX0HscjyGVnt0RDDQdj8qBVZTrdNp8eh4B7x5d8N2d8V
         UEoDycGcqr4+E9HeLmLlRJCs4fH1cCDJN1FWu4L9SbrfiNvOvPIxQTxSLaek3HkKQQhB
         jLUFIhkptwJPm1ImblKOG9qScnoe9oFyOMRXGE9mGLgVdiQVMlgyFGxcu+LytcfmdvDq
         pw8Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789984919; x=1790589719; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rtgPtMT7frKhH4WMKdwbGRv258dVgwZlagcB0deq+D8=;
        b=ldpls4ggNGoqi7iyyuKU6cRfZmWSCZBs6i9dfDIvX3xdI94LnLKocVOnMY5Gmvbn9v
         139QTZqXXXZKDy2uTrm9zHnwaABC/LO/2chB65K8+5E/cJxZz/EJpwkCfr1cXsAhfNE2
         dRQfszFa82NA/WeetkJLqVe0mO0PEw22eEbBLnnyPZGR/1jTvmziNoZCrsBBIMptH1GI
         ErnYXHMQR8b8UbFfAZMOvbAdGIk/HxiI5X3xg9xJ8YuD5O+o/mMmGNMfo90AaNJQxl7F
         87vQ2syA1z28gvJ89Uf3noaPYLHnfOaOWffHJ6ZAiuXSS5g3/N7nCQUtbtBapAE6wOmQ
         J8YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789984919; x=1790589719;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rtgPtMT7frKhH4WMKdwbGRv258dVgwZlagcB0deq+D8=;
        b=CwZC+CF2nL3YsKkm9TCOiZ0F/N3Qm/ktn+ZJhP3on0MnyAm1gQpApz4VB42kuQa9YW
         B6FXfaFb9DKomdRdEx1KIp85t9/t1mW29+d6EOtRHG9B+oziijgykuWR376Hs4pMVim/
         8X5RKZEnqVO4LA4eRhDGrnatWR/uzLK6iMcuLn0EBBBV3d0xI2aJ+ujlEjBN7s2Lrguh
         W3TMOdgtDv4MQpYVwB3asFhGtrOZidEYPjwGFyQIKr3dyPYtNNxnAtIUXHzjSyASURKL
         PLx/sjp936caIktpBqiBxQLKFl9NTATd82nRAX2u0MR3CtEpN/5m39ejVlMqMfAc98HD
         k+hg==
X-Forwarded-Encrypted: i=1; AKwUvBxQ+OL6JJN2TDeXv38JQaDe+kfcTxSqlKDFCoEsMZ+jEx0a3EoiGj63tkuRm262Nb0/8pyYSLodWg==@kvack.org
X-Gm-Message-State: AFuF++mRPTTX6ftKdtOvI2d+3tjPromS7DUAKcMxoyeMfgJ3V2vZgD2I
	b2AYN01FmjcPS9tJZs5lqn83bdg0MdZe65VyBcjKX0vHWXFazlfdDtllqHK2UGZbbqUpNniW0oG
	1OYVqY1LMisGsB8yn5B7NIqv1ZMsYhkw=
X-Gm-Gg: AYBFou3Oo3+zNfYaMtp8nFV85px+1inCcWKiRzszUcB7Cs2rexOTgmeMjjjdlfXS6N4
	OYwp5Kn+oY+OdNWMyL9YKuRWsLiUwULSVATXCtZplibtMrmYW6CVxoFqDwJzIY7905X4JM8v9Dv
	fQuPqATFdAcZ7Rq/ORSONmGtz19RXdAwZ4RhD7pRL36IeLht/Cw1UxoglN+g4quKoxzQPLIvcuZ
	kG2gv/jHQhS5xzo1MoZXk4lkmTBv6wC7wlm4durwZRWzGob6ii3Uvu0KtoG+xrcrgLv9K7yGuWD
	JzkuOp+6mjjH9HoHI3ABA1PIMgFQtAhOLd7KyRrEV+1US6ETLzlq2ltyQGpQWRI/DG1Eh3EBWEu
	+GjfIbTssISE=
X-Received: by 2002:a05:6a00:2d93:b0:857:73c3:4466 with SMTP id
 d2e1a72fcca58-87343ea8041mr17463837b3a.21.1789984919241; Mon, 21 Sep 2026
 03:01:59 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora> <aqLi6cIjD2wJwk0B@cmpxchg.org> <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F> <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
In-Reply-To: <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 21 Sep 2026 12:01:18 +0200
X-Gm-Features: AcwNN1W4zNuvHUUOGHULyeGe0PhiMgbBymHHBRLY42qLX54efbcuYBMEOcf7diI
Message-ID: <CAMgjq7CJBHkoZmg9oKNgGA8czL0djyBTCAkPz8ETm-tX=Qci4g@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Chris Li <chrisl@kernel.org>
Cc: Gregory Price <gourry@gourry.net>, Johannes Weiner <hannes@cmpxchg.org>, 
	Baoquan He <baoquan.he@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8D6691C000C
X-Rspam-User: 
X-Stat-Signature: 4qi58k4o3i9c49yay437wc4ygghi13q6
X-HE-Tag: 1789984920-236219
X-HE-Meta: U2FsdGVkX1/17sF+1HoBslGrwa0LaEyj4/YBWs2mA3gfJOceTqe+CEnizdHVYKXWvB+P6acNsDBSc+rioznWrIZ2CEPK/orIJau6MuXujBPkY5G6zxFir5+0pg0Ec9/briJJEnH3Fk1VlR21bjGfFJxbHgPOCzFcC1kABAKndiJZEOGbRrsGSlaKhyWDSCOSr7h6m1030u6NnXbYp6EKmrcMNEvx9OnN5+gjK4Rt7iOdGJE3oZ2dmH6QCx+tuDK0ZGofcU6tHa/kliEETIfy1LswHpKYKSuwcI6RWEJAczZDELbZkDFOvWWrxNqim5zYkMNRYmAeDUZppXVbhywRZKg//U0dwtSQMjN6mkl4zMV5HYJZr/uSflhsJ1qBd+FzW4Kfwsqdt5h/Q+rdoxnMCjCXFUSiVv2EbiuqO3iIBuGQGQxBce1SWAcvEEbYo3k2Q3IBNCsPEe5s1TMxcYSflCJQOZr7rYSaVGAax2pHL6mfJ5cFaGVKbfEsZ4C0luVq12TPZlf27CazyZvHAvXqO04k6r+7LNR3KkR4YNuaGNxx704vJ0mC72S4H/pOUzBWMdtamy4WH31wnzbvVowSd9x8QbwcluaCgevEGGOqY6HuEHNMT3FTaS4QCouFg5aqI1kU45TcVsK9GldtXcIQt5X0lLHipSE+b7uFczXk5aTMgi+y9R91ew4onxtQP+03U4Q3d/mOJGjvSNUn/Ijh0aKXskABeTduGjZ2+GXfIg7dZvNrHECOOQk7RyVtlDW12fu0BknLE4GiU+c/JBGmiBoesrCwTEeXly5YRnBWaGjrdAzKCcevMl0JWmsOFKcVv5iSa7aNFF5oZV6qcFqjDK3fiQIxCeWt7NHSjmtW4O/dowUmuW+z9ZhhJQe+n794FGWj0o68dvgp2HZFztL5ENQJ9d3vGKnX1bcVtl10YkdqyBmDw40xtr4xxzvh5HbYKKR1X1IXiicOJ1n4m6a
 7w/CvtX8
 i49GJk2Uc9Njk9UmtP1pWvjhAg7MAh4UCdGOHsF9OkP5sY+QXNXOrgEJPMca2EopIMMk35zqI5KRFwdiWhClGbq5+PnFrzJWT4biOrH3D8xjcWLEkuXHelhLcZEEn2L50NwRms+dsNPgHM35FF8IdofP3UXz8enthqgCgDEoYVtLFyBsV2UX7YZisxBcIlZNQkOG/brNGuSZSXRDH15+pwXnr/R5tw1kxgD2vRIHY9Y83H73+B4wX4n7BpHa+bThFiD8sJmjUJDh3ZCmxQe6I4pe9DRhI8PBony5Du+iJIv7ynItqMQvTsBfsQE9Dgi1BhaoTvV/bkfrVthTWBI1ht4S1TRMGhbBsS5mGa2z7hDFSekLdMWy+dmXf9LqSbdFQDHwSiBmxMwBoP2ca6e+N1L2YBFjcHCvJI4VOI+D1ImMrnTcKb5Gu84gjR6nV0Cwp9z3G62LIPb+K0qUab/dTitIM+l7ky1IuKofEJdxQP5hXO1Yocy3/9PGqVpmJiECJXPYYLBq/PoJ8qFSp+7/Pl749KPCD/tpJnyhBq4bplQsrmgdpUtDwPZjWZW+ZiaBAI/giHaAIVwxFVST0tGga+x1GGBDvuqICF8to
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 19, 2026 at 9:02=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote:
>
> On Sat, Sep 19, 2026 at 6:08=E2=80=AFAM Gregory Price <gourry@gourry.net>=
 wrote:
> >
> > On Sat, Sep 19, 2026 at 03:45:03AM -0500, Chris Li wrote:
> > >
> > > I found this new concept of "compression space" very confusing to me.
> > > Can you explain the swap behavior and problem using only normal memor=
y
> > > usage reduction and latency without introducing a new term or new
> > > metrics?
> > >
> > > The normal user doesn't even know what compression space is, let alon=
e
> > > what makes it transparent.
> > >
> >
> > Sure they do - it's the amount of memory consumed by compressed data,
> > including the metadata associated with it.
> >
> > converting Johannes statement to diagram:
> >
> > >> Compression space is not a separate resource. It's page tables,
> > >> backing pages, and swap descriptors. It's just MEMORY.
> >
> >                           Page Data (PD)
> >   [page tables][                uncompressed page                  ]
> >
> >
> >                         Compressed Data (CD)
> >   [      recovered space     ][pte][swap meta data][compressed page]
> >                               |                                    |
> >                               |---------compression space----------|
> >
> >
> >                         Memory Pre-Compression
> >  |[  PD  ][  PD  ][  PD  ][  PD  ][  PD  ][  PD  ][  PD  ][  PD  ]|
> >
> >
> >                         Memory Post-Compression
> >  |[CD][CD][CD][CD][CD][CD][CD][CD]-------- free space ------------|
> >    ^----------------------------^
> >          Compression Space
>
> Thanks for the explanation. So the compression space is just the
> actual data store backing the zswap/xswap/zram.
>
> > It's actually really confusing to represent this space as a traditional
> > swap device - built on the assumption of a pre-defined size limit - whe=
n
> > that size limit has already been defined (the memory itself).
>
> First of all, the traditional swap counter has a very well-defined
> meaning. It is the size of the memory that, when accessed, requires a
> page fault. A page fault adds significant latency to memory access

Yeah I agree on this. Swap just about makes resources not directly
accessible by the CPU act as RAM, whether that is storage on disk,
compressed memory, or a network resource, all accessed through a page
fault. I hope we won't make this fuzzy in the future by introducing
too many magics.

