Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A234CD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 20:58:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA1D86B0005; Mon, 18 May 2026 16:58:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C47E76B0088; Mon, 18 May 2026 16:58:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B358A6B008C; Mon, 18 May 2026 16:58:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A2F296B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 16:58:21 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2129E1C0989
	for <linux-mm@kvack.org>; Mon, 18 May 2026 20:58:21 +0000 (UTC)
X-FDA: 84781753602.05.B518DC0
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1F0B91A0011
	for <linux-mm@kvack.org>; Mon, 18 May 2026 20:58:18 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Jo/I1iue";
	spf=pass (imf19.hostedemail.com: domain of jackmanb@google.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=jackmanb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779137899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DQw4Q7u9z6JH0ttDjJPGH3TaUM9vt5YijBwRcpdTRuQ=;
	b=OXaDXgor/cwPqbz9b2wj1IRQqADA1MOQlK/75q1nL4jmkmD9pJhilBM5k/RouqpxQapl/C
	kz4m5JpWyy2LIr8UeX4ePxe4UExVtjzYx6lT4HhnobikLyQSUObfJbJJ+FuIf2jpo0Fib0
	mk5BPc6qnBSLPlWH+GU74cjuBznIL+E=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Jo/I1iue";
	spf=pass (imf19.hostedemail.com: domain of jackmanb@google.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=jackmanb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779137899; a=rsa-sha256;
	cv=pass;
	b=grtJ+jgYPy50Ixt9x/52tYqBd97P1SFwuGEWskAr6oZjaEV+0bTEQ8yPWUuRVA+nP1YgcF
	F+beiI1UCvwVaNKTtQt64Hu7/5e89JOw69cU3BkrMb0f/HAVRLchNMhCNUdd4JwrmcAaXr
	YpyfN9UYXtTPRweUcOr+dQ51QaCMv6M=
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5a88a79eb3bso62e87.0
        for <linux-mm@kvack.org>; Mon, 18 May 2026 13:58:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779137897; cv=none;
        d=google.com; s=arc-20240605;
        b=IJiAPaquwLIMtiLbuvWset4Ow9uBftQbrEU6nyvl+gfaTXYKFLf1uUxPXISqllRB2K
         uElM+JxasWpZrLaz3dW8rsyQZRmcnZOsVr/YrGx+ncWs6wZ3IZe6xuVoY9GEdgltoJ90
         Fe1Dry5I+EwFw6gbLrfZ3AbXgdXiaT1Vtfg0viLOuUL9e6FV1+VkEXi+nX2hMDqe8iMF
         jOER1vdZvUXCL1amBJV2mRXAXHrJHmkSRyBA5yLGl6C85I9QDaae/Iumo1DNaiURammN
         2DQaBL0dvTXvazTK2rLuAsPSW4SbA5mF3J0MRz6yIPpikKdYAwokuf3qezbkjE00Vd5N
         mzOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=DQw4Q7u9z6JH0ttDjJPGH3TaUM9vt5YijBwRcpdTRuQ=;
        fh=1WPMoZklBN3BIXPkXMIRUfOUwg+NHiuytRs6XAFv5ds=;
        b=gB/jSVMg3xi2D8UthR9JsVHzfzeC99YXOjk+nsClR2N4qDk7/RrvuBtem7pStf1Rex
         Jzu+mskFHvJ7QXoaPOspIhuloBLiyAGnhbLCXlsuxnuOVAfIItjrE1rz8AODgdzhz9PE
         Dt8RXTaf25NV9CL/MC0U3WEFGR2loD+7DIdGZao/YplLf5lmArRnhgO5dvSxDrhaMvGS
         SX+hYX8264Oe+SmfpNEzWFxY+W9dOQZhD3U3FwaWaMeq5NYhudgUgJqGYqc+bMwK9nR1
         DISy7SWE5W9clCah4sxVceHxiJZpA1Snadcgk+WuPCTfhWPWtDWXnqjdLpOTbpa9nZnv
         E5xA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779137897; x=1779742697; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DQw4Q7u9z6JH0ttDjJPGH3TaUM9vt5YijBwRcpdTRuQ=;
        b=Jo/I1iueMXoKqrLEYfSSwUtZxHFvsLsZHYuegrW2znXk4QYU6qPxnHOh+hPd3y09WT
         UCCgkOLRNcPFXn8l7uYhMXplZOl/bVyA8pI6pd99UdD9UZY9Muc3LPskqlm1/Gu8PcBs
         XPjiIlaOMzHE0y9GbQuOfFnoEpyq//gzX7xlRAuBqry47vJajinMNaPxnIu6jaazC9MG
         oTrsGVIG6I5arszgQnynb65U+G7z78PYDW1gO1wg2ooVru15+L8odiMjTTawDuynHtI6
         GsE8+fvkssAa7e1CkqQ1IL3mCXCRs0Tict2xNuzVlVYkcnJSWxBlHjkPsqjwbHWuo5oo
         R8Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779137897; x=1779742697;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DQw4Q7u9z6JH0ttDjJPGH3TaUM9vt5YijBwRcpdTRuQ=;
        b=Un5dUG25yBS5knsXGPjqbKODlRficiLuur2ZA0sBnT8xv1olpACZK3y0Oj72k517My
         hzOhtKT6hggHJHvDr3B64mlntqLBrS8D5x7ZFOPPZAlpp7ETvbF8bavg7VEZ9E+xHhVE
         fNZSGusZnJyfuBPnIpnNXX2cBkOPa1qHJjyW7CyPwj+erK/oEFuzkKMw/0/hOP9165Fn
         asOr5wiDXhm7YlCn4SErH6mzmHnArC8/lm9/dZV810mkGYygqQuzLyuWddXMemCoWPcj
         vCTX9ykOU0xVis510Hr95VMNWV6ypb9v9pp/fTejvbwV8nC0ExhljvnsvQJq6rRSd1Ob
         cKfA==
X-Forwarded-Encrypted: i=1; AFNElJ8Kx1YXcbPW5LHW8i3KTle/MbgcGhWO4UC+W7ZeVnDhEKIU2htxehqKFC40YuN+jb3TW9JxL3VdVg==@kvack.org
X-Gm-Message-State: AOJu0YyipNyLy3b6uqhF8Jo/Gw3+ldtallHAE66l/2cTbyyv+ewAWVj2
	+f820e5ZKYcMDnEoDQ9dI3I+W42Y/U2RLubBzGesYClMc3cnzmt1rMi/UZL1J/rgpI3afD05drm
	U0X7rfGXk5bqAaj7JZxXXCMEMBDW3P5SoxFkTw+1T
X-Gm-Gg: Acq92OHZnLu02HOPcp4ot5/1WkaAHLXfpNMByTLGmp7sktkg8S3pMJSYq/IRm7wSFau
	g1nEturxSmIqh2KM6bn+D2qnmhCBkZQVPLn+p+5thqJdFvZ9f+HUoBptu2OFP5yLeo2iZHsHF1d
	Wh0JxAZr5uNnr8o4DtrgUagv2V2zXFNrwWhAOfJ1dq7MV64WkPiP78NlA4vJnA5DfuC8pEfcXTZ
	N05zN7BARc5SMZ5ssi5RE0GQ2/MON5Heo/weIXceHvLvlGMzleW2d7J037MZmZARUUovhCMrXnG
	0a3hjj6Not2hmpIUivTE87FMBzm56uhbrJ+1GhDPdqiudgegE2EegCVNe3s=
X-Received: by 2002:a05:6512:1411:b0:5a8:f956:2165 with SMTP id
 2adb3069b0e04-5aa19760399mr303483e87.3.1779137896870; Mon, 18 May 2026
 13:58:16 -0700 (PDT)
MIME-Version: 1.0
References: <20260513-page_alloc-unmapped-prep-v1-0-dacdf5402be8@google.com>
 <20260518111546.3baebae99dc3f2a4fd65e605@linux-foundation.org>
 <DIM2YAI5ORUU.2YLTV7PWKE516@google.com> <20260518134811.b2b78352779d7519e8123597@linux-foundation.org>
In-Reply-To: <20260518134811.b2b78352779d7519e8123597@linux-foundation.org>
From: Brendan Jackman <jackmanb@google.com>
Date: Mon, 18 May 2026 13:58:04 -0700
X-Gm-Features: AVHnY4LeFdfqzho9peVK4kr5pn7PGlIoXj7eLUcc0p7X1r3-MMiC-29QI5sc158
Message-ID: <CA+i-1C1THr6fH=wdTKEngbCSD_DMS5tGroN64BEf3L56DH2XWA@mail.gmail.com>
Subject: Re: [PATCH 0/4] mm: misc cleanups from __GFP_UNMAPPED series
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1F0B91A0011
X-Rspam-User: 
X-Stat-Signature: 5ncbmdta7qjke8q43tzjxfe4aeen7ewo
X-HE-Tag: 1779137898-843424
X-HE-Meta: U2FsdGVkX1+O/oDZ2XggcXtXEyD6kSOsN59foPSIlTwdXjW3rh9IZ2MwUxR5ChAk+DAPDQ/L1rB/NLJJpY1CK3zS5IEgn9pngWflVsJjctbW/zG+8/CLwy8nQ9NWMjjeynp9b2AR0b3Bn8B1LhrfFgmMUrnZZmtE/XEnpsKoncjgsYOmDBRIXqE/SWz4esr+QNfIJICZblh93U08leyS0+zWBvUgODPZ9f/OUq2dgo3ymz7ueXmB1eVqGHWO1DazjTjC5ShfshzrtUmbwQ/HbqCCi2IlgXXAI02IV8jqXNMTk6xR4f8Rh+aGrfaW0iatOQD9K43bTTjzetQdtfyI05m+oPei1vlrkLN+L3yKJZs09Q/qcHYDTAjXnb4UWw+BaHEi3Xz+ymsr7I48LzfkyJA9oSSl0qTTiPpQFD3QXz2CrsS7yJsZ9gtqHvvxzDWXVYMkELDnyWMkhWxtC2xwpgaGjo9yTT5W372tOdFsE7b+r/a44H98WfTi+ot8z/yJ/fmKPuZtdMv8w8YndBzlMVeOnDaUQT5VuNy4AwqJ69NjvHrdSM95aX1AJmclx9wJOZOQ0EnMCF5/x85njUmeSvZaqx20apvdEMqQIrCBn/7gzMNx3a5aDhULLfOQUI8d3CKLDAPit6nOCEmzNqaQ+qzJmPaXeMxr9hrXKJ/O/z/oQMPEqqY+AOLUH7tG3Y3GT1RjLoQa/tqMJIwMkAQMDmS17LxNgH0nvNtu7O6f+eaeJEbdQ4Q86jG7H1IzRe1yXlxSVrAhkYyGwjANn2oGkpOrW9Ii+Jwo+CCY1RWYUXe77K1iBZmAuwuGIJ8bKgkW+TxGEcc6o8mseFzuP6pSRKc9dCFrJfT0cBkcyK9TvhVXyCKXDF9JszJ4UwrBM/VT0P1OGPNeMxYhlOF/mfDNvxQ8nGBzoCMuxQR6fp6kXjucvWUw+cUsiEfDF894GQCtGEC7jzVbJEh1d2zbQd7
 HRe99/q2
 n7kNWz1B8IjrHr8ha4at6fTKuPVtogsQTNqGrjP10RYiEtjxOtjKYE+Kl5pcT4zkwLTS6Bh9RrYQm9ZpxXae1cVQ5pCjkfdLhm2GPbkfjKIrWe5K3EzKYdTn2vSimg5zkWDqh2SQt174Jx+fkS7Yoz/dkfdIWRzOHCZ+IEVz36bXyNG6V/MQd6JP/yUEtyzhIgjRMk9MZ/8YOPwaQy+/Pnisv2wLrhZJlnOyLICySzoZf/b5vkNwYfaPAcjFGAq46vHwTHimQLSGRksz+XLkk5oL6Oy9HSNBanJcV1Nzq8kfjKVD5TtLVJIHExhNG1xXarTlG6aOVe+Y/4yY4c1qkCal11Fv385b/Rya+yPyPWC6DQJYEE6njUmHRlgsk0nITr4rqbakNKJ3Z1ROgNjL8xPMBWkp0TmBVviUxJbXwUzKIwmHrCVh2JAGTBFib8t2OKZP5sOHGFWLXiWI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 18 May 2026 at 13:48, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Mon, 18 May 2026 20:20:50 +0000 Brendan Jackman <jackmanb@google.com> wrote:
>
> > On Mon May 18, 2026 at 6:15 PM UTC, Andrew Morton wrote:
> > > On Wed, 13 May 2026 12:35:12 +0000 Brendan Jackman <jackmanb@google.com> wrote:
> > >
> > >> In v2 of the __GFP_UNMAPPED series [0], we realised that some of the patches
> > >> could potentially be merged as independent cleanups.
> > >>
> > >> These are all independent of one another, if you think some are useful
> > >> cleanups and others are pointless churn, it should be fine to just pick
> > >> whatever subset you prefer.
> > >>
> > >> No functional change intended.
> > >
> > > Thanks, Brendan.  I added this to mm.git's mm-new branch for testing,
> > > along with a note that [4/4] may be getting an update arising from
> > > Vlastimil's feedback.
> >
> > Cool thanks, (also I got the "added to mm-new branch notification" and
> > realised why I missed it last time, broken mail filter).
> >
> > The 4/4 update is already up, in reply to the thread.
>
> Is that "mm/page_alloc: tidy up pindex helpers"?
>
> For some reason I didn't receive that email, directly or via any
> mailing list.  I do have the similar "mm/page_alloc: remove ifdefs from
> pindex helpers" from May 13.

Ooh, that's unfortunate... I used git-send-email directl to send that,
which is not how I work most of the time, so I suspect something went
wrong with that particular setup. Will keep an eye on that.

> Oh well, please check tomorrow's mm.git and send along whatever is
> needed?

Ack, thanks again.

