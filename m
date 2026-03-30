Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 368B81061B18
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 18:59:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93D096B0088; Mon, 30 Mar 2026 14:59:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8ED746B008C; Mon, 30 Mar 2026 14:59:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DC306B0096; Mon, 30 Mar 2026 14:59:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6C7756B0088
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:59:52 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2107E13BBE8
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 18:59:52 +0000 (UTC)
X-FDA: 84603643824.29.D74E306
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2EAD34000F
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 18:59:50 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aDlgCBvb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.54 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774897190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cFGS6w31Laz9Ddur1i7GLVmK/pVD2soBNffdP6C8TRo=;
	b=eLeJN7wNOf+qPAfm0tDuz9AIhEucysBH+wSQMFV9CwxVk8FNRcnzZ3SZhxqu3XmwYEw3Qe
	jBrxn4VU60K/aGSLX9dHsdKNa8Z2CH5D6qJEaL+8LVPG6d2GLGmzdVjlKFp4OtC14yLYqG
	ObPtP/HYLrkTK0DcBk5OOGcMKU0rNS0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774897190; a=rsa-sha256;
	cv=none;
	b=3p7lxDyrGOTcenIZNO7BwoMwGsZihm/UGnle6K+xfnoHi8puBoDZzoRUCiXNdTOwDRA2mu
	Fk0xENDpI8m58CJEaSPxjaFpADUIIXF6W8qF8O0O6FAIt03hBuVuPzT7KG1XRy+A/w9qmW
	DidUQIOZIvIpUjl37uO/wQCunlIS9EU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aDlgCBvb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.54 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-41c5a81d4b1so3986854fac.1
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:59:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774897189; x=1775501989; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cFGS6w31Laz9Ddur1i7GLVmK/pVD2soBNffdP6C8TRo=;
        b=aDlgCBvb8FQC5bc156y2Y8AMNRL3+d8tA/sx2INimxm3evfNQnQcL1ikyAg3Bii53U
         WxuP1nU1eKJkanbohCFw7s7jHyjul/n4L/OlMg2jKqW7UvXH+L50tV+d+jXGg4WB7FMB
         mOp72tBHKw8TdY2T/pkESO/5+kTxoBMwZtAAwgnE1/fOj/+7bBhIYfvaSV31WVFZw5aZ
         d+SifvWmwd8qt6S63ODIhqU1c4PhA43Qp15rStpjkFNEYmx8D/eM8tcSQ85gDus7yKuS
         Jog0nEKlPZxayb+b0NpTCfT49S7hFOS8uCRf+eZ2PsXVF9dq4O7iVxyCrLDw3RHWTsya
         1gwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774897189; x=1775501989;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cFGS6w31Laz9Ddur1i7GLVmK/pVD2soBNffdP6C8TRo=;
        b=Ikoyfb4LEs4bRfwOmuu2Yz5MAYsywvDa7+RqOc7b+im7d58uR2Ba4G8GsLpyu9NJ7x
         OHUH/HXLQHaKm9um+CRC2VzrfoLl0Rv7pCaR6r0Z9dLTm38KOF2wiQSQiCNhCD0La7NJ
         gGq0z9sWaX44x2QbYgPuQ1X8qC/JUhE4A1yowMqoHvrP5baWxu8Zwe4EbmpcAh07X2Q/
         Ytbi5burmDm0D8DITWvJ/qJYiT/AnfFHSO9NeMPso6Dd58paD4ATXIaFEoddFCRn+bmY
         FCmXmYuiRFw4z5cAR3IRJ3Pr4eJi8sifKg0OcBQcCrHQcyt5nZXazQo/3ACCwAQ9F3c5
         SCag==
X-Forwarded-Encrypted: i=1; AJvYcCX34njsm2RaBGtXQwKVXHDlAd5tR0ULPgmViXORbQwopPXD1NCCaYjf2fxYYJWEs18H6TYxPYRJew==@kvack.org
X-Gm-Message-State: AOJu0YxyTrQtJmoaB/ST4pb9BBOp3C9Dulaa/X7PYzWgwRgNLasqlmZH
	yridNqIaArDWgApIdCucx0w4KpsWWcn5CCeoNTmUF3AT++vRkBFIopzF
X-Gm-Gg: ATEYQzwdp00IF0iMwFtRu20uRli3j6haGJlQS49e83QTOtEnXg+wnpG3yFigwgFSIwJ
	LLRfTGjtAcHfgxSAfLMs//cIsTPuqNKN8KJ7cMuPVBLPSDam5rQzO7t8lUOReHUVbGMpcRzaYxo
	zC28bVjlzMLyNQtMab9rB5J5GaLFdzbSXwUCXvB6t2QukK/LCDAcoAo5OiHgW1ZfuyjbVGNWlJz
	ZjgTWbmnkHTCyy7U8cNnULdaFMgqfheSU4s8gBGdfuBPnq7g6/P6eg+/vbup0PqBGOD9c4R9kAT
	HHdEMzvwXidWLoUPv43n7vK+b/YEZuPlanrsAIQlKcv1nUlTuuOIzMMlHmM65ih10ygLXmfHZcC
	aqcvMLeLpCkQYDiyHJt+Cp3MxsEYs+/k5tq6v1hRGlzTGa6gcmKcKJJ9HRF56RDYNXpRgkVZCsb
	MyeBSlF6QlFh0JCV0P+1qCOw==
X-Received: by 2002:a05:6808:2f09:b0:467:f1e5:a294 with SMTP id 5614622812f47-46acdb4b61cmr444228b6e.4.1774897188917;
        Mon, 30 Mar 2026 11:59:48 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:73::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-46aa03656e2sm5180605b6e.11.2026.03.30.11.59.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 11:59:48 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH] mm/percpu, memcontrol: Per-memcg-lruvec percpu accounting
Date: Mon, 30 Mar 2026 11:59:45 -0700
Message-ID: <20260330185947.2427740-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <CAO9r8zOKaPocJYMKL=A=6=qpWgwCa=fMC8EZsSW+632M1q1sZg@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2EAD34000F
X-Stat-Signature: hyz5t7z7e5r4wza3s3g7wkh4m5mgqbgf
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774897189-899584
X-HE-Meta: U2FsdGVkX1/y3pVJlms5KdEIQ4DXrG3bH1J3/Q/QyJz2NNGvB0ykmulwqI5X9Wo3xOzfF6CpRrGAiWwi/6Ayo8QvZYm/+MALA9i/wUO6WXvQBL2X3YvmI5WxhlyO7bceSsV8p/9zTAidfFdLuwD9OizvtI92v/OqAZjxvGWb/wNHYivaQ+wj+IHjnROGaiXyN7LLIhtaMddfVHuY5LZ+xWmFFK+TB+MMTGtXyN90ncUEsd33dJai86tkGrmfSPa2qv8a8idJUPSdml0MJDCkdIsTCiA5LoF3HrTFOAGkDImmjl1npxrzjVCgmaMTQpBwPieD5c/ZhzGVd2fe4s61R+9tMkzJDhVkUCj+sI40q7umLC9OkjUyh3KwLx5YOIZUhcShi59FRIUb+c+e5Vz5cP7uWEhgNPn3TPNmLhiqiszqDbkXZRtLpp6rga36dhfFt9r/cKk+K5UVyF99c52I5ZrjovvfsuA6nDMpfEB6UedYF0r4ACxIUi4EIhkS/JXWA9IUB0v0xwPQfPGYBCulBtCpBYe0KhQRwZVQJVHjFx56U3mSyhXo7q2hSbCC8wHmHqxSx0lMqF32ZH0xM5i5jiCkEtzLqlPehw9K8IJNfG7C3gAPg42K/5AMD711tPA4146CAlHdShSEnZexUqwbhVQkgHLB/EODdiZwfw6g3zdbNVTb9JUWd46mYxlfloofciDYtup9kVGDQjdX7c3ZW0gXNciNZT5tpI1UVmirWJnHADIU/malVkR6H8jyT12dm4jj/4dVEIQtUA28UekIg3O7BXmCmX+GdnqnhLi3gFOajE5kXpsuvyAvOMxQ6riiN5HWopzrvsXz+2DMzIihl0jR+WHDBT0lZE/zLzxiD5+SLRxhsJIRjLNSVVgIlFQ7GNyp94+6iSOGK0BBVLftP/5nAICJPdIXtZY+qTOlemFEN/D+JHQOMwvv6x3h1t+OdOTh7am8fPPvto2xfeX
 XtSuZ8Fx
 53B0+OJnU2SLrDucYi0Z0/6I347MH9J6A0Z7xzjXlBR7daWJSjTyb4t8p2co67BOVKUUlk2/bLxjeaaQ7mFceYFvIGRlIABe3/cK2WRHU7a4yHgzOCT56cSj5PFnH9NzIoVijpr6JM3NAVMF47ORGJWhhV2D8FYQj2k2Rkn0j1B29u8d6N3Bs3dHACAEcNTf7wFhiCV6HxaXIKnnLiGqHrBP1AaE1dqK5y92xdQTHftEmRd4oduhOAxP6EvZE5Osv8vvT3IU6bo159Iju6ui6MHY7ZbrgOi5tHXdCuHFXHcOWLE8sPaCGpqLtWAjRUym+KFmeri/dsOkoidJk0vH++wi5iuwD1YJQGlwCFUNCAjMBkhiT4W8sKZvqzJhG49A2mFLy1qjos8sqTxJoHLBua7x1YMeBmSDPuq507ttXTKgzEm9RZKzb9Nr5YU/ED1uxm2DqsIRnfOiugJnWJwVJwtPS+BGLCtys3P0BeYqQgyfuUYu9blp8+RhyhQduoNHTdSM5Sd0tR05UwPfiOxQHZvTyGGxKu6ZWW8XF3e5SweSZJHujJomb5bpjGLrXmUGyqMdMtuNapgHnNlsj3q5R7RZmqNvS09j804I9FYqsrsWoIPpOK1ziEy78JPblyVg0M6fW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 30 Mar 2026 11:35:38 -0700 Yosry Ahmed <yosry@kernel.org> wrote:

> On Mon, Mar 30, 2026 at 7:21 AM Michal Hocko <mhocko@suse.com> wrote:
> >
> > On Mon 30-03-26 07:10:10, Joshua Hahn wrote:
> > > On Mon, 30 Mar 2026 14:03:29 +0200 Michal Hocko <mhocko@suse.com> wrote:
> > >
> > > > On Fri 27-03-26 12:19:35, Joshua Hahn wrote:
> > > > > Convert MEMCG_PERCPU_B from a memcg_stat_item to a memcg_node_stat_item
> > > > > to give visibility into per-node breakdowns for percpu allocations and
> > > > > turn it into NR_PERCPU_B.
> > > >
> > > > Why do we need/want this?
> > >
> > > Hello Michal,
> > >
> > > Thank you for reviewing my patch! I hope you are doing well.
> > >
> > > You're right, I could have done a better job of motivating the patch.
> > > My intent with this patch is to give some more visibility into where
> > > memory is physically, once you know which memcg it is in.
> >
> > Please keep in mind that WHY is very often much more important than HOW
> > in the patch so you should always start with the intention and
> > justification.
> >
> > > Percpu memory could probably be seen as "trivial" when it comes to figuring
> > > out what node it is on, but I'm hoping to make similar transitions to the
> > > rest of enum memcg_stat_item as well (you can see my work for the zswap
> > > stats in [1]).
> > >
> > > When all of the memory is moved from being tracked per-memcg to per-lruvec,
> > > then the final vision would be able to attribute node placement within
> > > each memcg, which can help with diagnosing things like asymmetric node
> > > pressure within a memcg, which is currently only partially accurate.
> > >
> > > Getting per-node breakdowns of percpu memory orthogonal to memcgs also
> > > seems like a win to me. While unlikely, I think that we can benefit from
> > > some amount of visibility into whether percpu allocations are happening
> > > equally across all CPUs.
> > >
> > > What do you think? Thank you again, I hope you have a great day!
> >
> > I think that you should have started with this intended outcome first
> > rather than slicing it in pieces. Why do we want to shift to per-node
> > stats for other/all counters? What is the cost associated comparing to the
> > existing accounting (if any)? Please go into details on how do you plan
> > to use the data before we commit into a lot of code churn.
> >
> > TBH I do not see any fundamental reasons why this would be impossible
> > but I am not really sure this is worth the work and I also do not see
> > potential subtle issues that we might stumble over when getting there.
> > So I would appreciate if you could have a look into that deeper and
> > provide us with evaluation on how do you want to achieve your end goal
> > and what can we expect on the way. It is, of course, impossible to see
> > all potential problems without starting implementing the thing but a
> > high level evaluation would be really helpful.
> 
> You should probably also speak to extra memory overhead to move all
> these stats from per-memcg to per-lruvec.

Hello Yosry,

Thank you for your feedback!

Here are the things that I cna see from my end:
- NR_PERCPU_B adds a byte per-node, per-cpu. I think this is manageable.
- lruvec_stats_percpu grows by 1 long in 2 arrays (state, state_prev) since
  NR_MEMCG_NODE_STAT_ITEMS grows by 1 from ~30. This is +16 bytes per
  cgroup x node x CPU. Even still, I'm not sure this is too concerning,
  on a host with 300 CPUs across 2 nodes with 100 cgroups (theoretical)
  we would see a 16 * 300 * 2 * 100 = 937 kB change, less than a mB (and
  I think this would be considered a big machine).

What do you think? Do these numbers look acceptable?

Thanks again for your insights, I hope you have a great day : -)
Joshua

