Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 578A7CA0ED1
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 00:09:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF9EC8E0225; Fri, 15 Aug 2025 20:09:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D83FD8E020B; Fri, 15 Aug 2025 20:09:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C99518E0225; Fri, 15 Aug 2025 20:09:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B4FC08E020B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 20:09:08 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 36F38137F23
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 00:09:08 +0000 (UTC)
X-FDA: 83780685576.11.9FB33CC
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf11.hostedemail.com (Postfix) with ESMTP id 52EC340002
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 00:09:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=F6xjs7bF;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755302946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0r/mIKpY0PQV2sB8PsmrUnYDf1plRua+xy+T8mUH/bc=;
	b=vrIVaLfRwSr/PZQVCLn12YIvvlmg4GShFwymSXCQuxxU5iPe2Bru03Sw+Di44XTfcqO3NM
	wok43IE6UaicCcPOoXV4kvJ2AN6Uj1WykxcVeqQkGoBwFZVH+CgC0yOxPit+Og9xfSrlcc
	KkThTQtvbWDvHKfUp9RHXM5ApfAjnUI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755302946; a=rsa-sha256;
	cv=none;
	b=I/iPJ7QqXiBkKsjSGI/5V2G+TC3L8xML7eMHvUbIOwhwfiupFbgOp1004QUJN0cuh8pTON
	Xh0STh3hJMYs2UgzdCYnNddYdgMXTq8ym0NwoUJRP4YNAIfd4PMnSx/Q9/ruMMnhBlsUC1
	rWh6/bQNYJ9KUiziMAXZZmYaK09535o=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=F6xjs7bF;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Fri, 15 Aug 2025 17:08:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755302943;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0r/mIKpY0PQV2sB8PsmrUnYDf1plRua+xy+T8mUH/bc=;
	b=F6xjs7bFizjs+tCUS35yzfythJ7KOvZGjmhaAR8aU64T+aTDm4KtiDKmZevZsCWpOzL+wO
	/SDd2sUhQ6PtjCLrQb4T/W3A1Vd8fyFZM/UF47RO7MQUIQ2zOzdsAKAtUGosQbD5cWNrjn
	xuG1e7G9YQwvBw8VnSiCBbfsHTyouno=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Axel Rasmussen <axelrasmussen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: mark MGLRU as maintained
Message-ID: <22qegz4vktquv22nome6csd4vngvwcaeydoyg3ttqoal5vum27@knjvryszxbdm>
References: <20250815215914.3671925-1-axelrasmussen@google.com>
 <7a46f7jwlwgkbdjvbxjaalrrdamgtxkptmytllhkr2qv4ovbge@nbugfzavwh5w>
 <CAJHvVchYa-vUcQo92awyHE663n-iMsLK31o+1FKrMvdLMAuUOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJHvVchYa-vUcQo92awyHE663n-iMsLK31o+1FKrMvdLMAuUOg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 52EC340002
X-Stat-Signature: 9w3fqqr9k8dhdbmbwdpsg4sw7qki8xqq
X-Rspam-User: 
X-HE-Tag: 1755302946-595365
X-HE-Meta: U2FsdGVkX1+/1mUFyvIYhKY0scQsQx+iylnFTvLZQsvDVxDbXE2wRBLZb2q4wpi7vgNbvQ0d7ZkiXgHjtcRslmngn8b0lVxiY/s+8bJntonz7dCvjJlCvyG3lsoW6nQjaDXMiVJiMEQue/BfwM4vl4bh8rSUia8nA7h6hzh57QT252/1jGJuUFQdOZF+QM5+7cSX1H/zEy2kDcvHiIu/K1thlXyeduPr6CW7UXjfFC6zgpI4aGc2tsaRm1elk8R4bbTobHny7JcH/CQJa3eXmt53GTZQMeLLqR5OP3E74S6WCZS+uFmvrI2J6qp8L9tyXkwh0P0biaI9a32KX4nz+tjReBysNRqlxOZ5+diinLVhYSgIxtf31W2iseybGfXR5sCTncA9wqWG7jchdc1oo//ynYnyHoodMliLDM1tXEHJrwP0/pxiUSRVMKq4KOwZgVRJcAM0P3k1tBBiJEtvgBY43aWE6VT0/bnYhSWkzVQpo56y57tdIJWfjFf79Av4c81wVKPvLb5jbGPrq8WvFrjVEer3YeWZExQjKN9lYTG821yp1C5MsyYHhx2l/vYZDI8x65sBTOEh8GyXdBk7Vat4YpSb/KrtBS+02g5U8ndfhpM/1/z/rr+y+fbnVIZTufQILe6PXElJAOWxlbtvYF8kV6N5dJJdgwE4cmPC70ZWreP+2mzjjp5sHFyHgljI/7PY1tpAee1SlImPJA67JpM11cmhaWlPJ+ayFYFbUuBW1rg0x3y2MkiTKdMY4nLsNB5ayYmfK8mVMSFX/cC7j4vYhsSX9A3yGtOcr03xjpXBaEtCrLaY13naWmEtKt5uZQ4uPbOfBFBZYd5W43S+x6Y2CxOySnwS/09E4LMJS4eqc830cBx1GUckajpVmvP8WhP5F+Mi1BgleL6R2VRxh0UGD314PSlfQtILj5ga+r8FShgQOsv+Trr19bOp9BUC9GtHWIhqKXocGC5aonh
 eX6d9B2V
 GfSS12n0Vb9yVFXPgnfchRhj8nqVCfhODYQ05+d7UeXl0N5+L/z515gYHZbqfvOSv5Payec9xGg7+qBZOEuImanoCZcgNa+BIPUbZFjE1rhRHzmhv/dEMOowdB9GNfOPVjcCXnrPVZrGFBRyKGlLAvpXApOZfNCTB40xCU1n9CseaW3UheItQ0pPxwW4++NjmqUx90QoFbQWb6ayOYca2idM8W+rgWs0XIoaWjiNqBDoNSZRrRWq76HneKCLc96S80VwBM+RgJ12XvhkGdmGqryJrUmwydyggMOOBMTPC2CN84E5s1Tz1lyKVLw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 15, 2025 at 04:40:26PM -0700, Axel Rasmussen wrote:
> On Fri, Aug 15, 2025 at 4:13 PM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
> > On Fri, Aug 15, 2025 at 02:59:14PM -0700, Axel Rasmussen wrote:
> > > The three folks being added here are actively working on MGLRU within
> > > Google, so we can review patches for this feature and plan to contribute
> > > some improvements / extensions to it on an ongoing basis.
> > >
> > > With three of us we may have some hope filling Yu Zhao's shoes, since he
> > > has moved on to other projects these days.
> > >
> > > Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
> > > ---
> > >  MAINTAINERS | 17 +++++++++++++++++
> > >  1 file changed, 17 insertions(+)
> > >
> > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > index daf520a13bdf..8e987f2668cd 100644
> > > --- a/MAINTAINERS
> > > +++ b/MAINTAINERS
> > > @@ -16058,6 +16058,23 @@ F:   mm/mempolicy.c
> > >  F:   mm/migrate.c
> > >  F:   mm/migrate_device.c
> > >
> > > +MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)
> >
> > Why not just add yourselves (and the missing files) to the existing
> > reclaim section? Eventually we want a single reclaim solution, so why
> > not start with single reviewer section?
> 
> Sure, I can see the argument for that.
> 
> I suppose the case against would be, perhaps the folks already listed
> in the RECLAIM section don't want to additionally get e-mail for the
> extra files listed in this patch? (Perhaps mostly the MGLRU
> documentation, the rest of them aren't necessarily MGLRU specific.)
> 
> I don't have a strong preference either way, I think mostly I'd be
> interested to know Andrew's or the other reviewers' preference. Note
> Lorenzo suggested a separate MGLRU section here:
> https://lkml.org/lkml/2025/8/14/271
> 

I would not be too worried about folks getting emails for MGLRU. Anyways
whatever Andrew decides is fine with me.


