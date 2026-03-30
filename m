Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 275FC1061B22
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 21:18:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63ECA6B008C; Mon, 30 Mar 2026 17:18:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EFDC6B0095; Mon, 30 Mar 2026 17:18:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E4586B0096; Mon, 30 Mar 2026 17:18:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3A1676B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 17:18:13 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C2FA71A086D
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 21:18:12 +0000 (UTC)
X-FDA: 84603992424.29.58C1CB8
Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	by imf22.hostedemail.com (Postfix) with ESMTP id D8300C0003
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 21:18:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NBbLnNhu;
	spf=pass (imf22.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.42 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774905490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YpynBP+G3ZnDHhHUsVCEALCguQRacTThLF+4zfYVNbU=;
	b=PN6IhR4RpaExHREwQYUIiVpvKgp52u6V/paTnL1PpOsj79OxyJWL+1nDl2+NJk1g+E9WCy
	kAjD3iZptGrb5Gb/Uav+p29dhj/K6W2ssbaRz2hwX/f6D74V8U1XwQqarcFItjUheJMdey
	1EsPqp07firdLpvg4axH4sMLZUEYIg4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NBbLnNhu;
	spf=pass (imf22.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.42 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774905490; a=rsa-sha256;
	cv=none;
	b=krOGjwa4+bOP7WZjqCCLJ4yU6SYWcPf2oDmGQLcjd4BLK42NTZ9xjoGnJaS0S+FGP6abTn
	Ja/82fiueZyW5REXvXp4i2r+s+JNCb0SL9w46GExLNpfKOem5xAsWCxAc8JtiufSNl2FQ3
	C50QrPS5BWh6XmDS4qHIQxevPdsnNeM=
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-409de4132b5so3109414fac.1
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774905490; x=1775510290; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YpynBP+G3ZnDHhHUsVCEALCguQRacTThLF+4zfYVNbU=;
        b=NBbLnNhu9Vbuf6e8x8kpoyfa7wdf2jOnfNWRJzY8zMta0Ul0z1JlqBHJLCJbCexfPC
         Qkqt+WoZ7mt466A9owmQQxHKNjan2tgpisur4y/+eDoVhb1lvR2jcNBpwA84/b8rliXK
         O/IduosZTFQXU/Y83oHM5G0DBtp4a4Fl+BXqYib903KPE9TCwu82FcLNI2Oo+3GmyQFw
         8pOQslaamdV9lyEx8ii9mvd0OUfMgVSI6zIP0ik0SpH5IFFxdVNuGnetMlDLSvNeJiI4
         /Dnd0MXJdLv/wKq7DK73oJ/P1ltbFACpfOF04DXwivXm/XRRsJ+gvbD625g/ulEd1FLQ
         eMlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774905490; x=1775510290;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YpynBP+G3ZnDHhHUsVCEALCguQRacTThLF+4zfYVNbU=;
        b=gmkD352yBXTgD1FWmGLfLC60Qyn/a2Q+BJ4xTjeAGqBn0yy8VUKXf2LSjmRxGOk622
         cHdvW4ffp9JQXx0pUZWEiuKgVBExltsz9xg9eUgQ8L8CBrhiWZudVV8B4J0wyFTJKoNi
         oQZapYGmKZoJ/DMSCmf9I/oV4pCut6l1Jz+kMgeYfOsSIgSjowjVUySpll05NaqWY9RN
         /3Gvz3N1DB7HuEMSZKdnhuxegUdgq0tP43KR43wV94LK/2RfQFElhR5p8/hp/a0tQfCG
         91wH6A1GU/brC+kuVfQBi8FQXbGWM4pa5u02cPgw4MSw4V4PdMNDY6cJqVjDvBJIOleS
         obmw==
X-Forwarded-Encrypted: i=1; AJvYcCXgjYrvXI/59KS9FklACpQcmfXn5rnXfuZLkdlhWNe44rcSM3bP9QplBQmgQjzmvgpJWhrLJffaYA==@kvack.org
X-Gm-Message-State: AOJu0YzQxvAPK5NfvxNGYABg6zp/YxY2podz274xgPdFQx9WfaHHssKc
	n7OTxNDjgXNlYZKnvrKkXZZKf/56+pnEorFIvv+/FDSOZsaEd9xae5lM
X-Gm-Gg: ATEYQzwHOXTuFmSz0cxDL0PMKqMJgEwCUWEaWCv7d0ErLaU0LH8l6sOPBn/bUeT6/YH
	mNe5gw4RNgjUkb3EjpwhWLBceSQaxnycLZ1rSfkb/es2W8WOps7t+O3NdoN25WvflV2m1j7DGtf
	Zj5F73nxU1n1yRMLAYb7gZ9hEH3oAdAKVBbrZPlpc2t+GESbtzW0IEd2LFH5KjbQdZbjrOSCs3c
	l4ayfRlcqrmpv/aBydP20k+eH+2CJwEmSvokKPBPOvrf0JDoZsCAcb89USv4VreYR3DYiUbFCK9
	EaJ5PcKA8vXQKLHhw10e3I1R8DgPr4VuNUCve+b/Mwg+TvA9VAmBe2k2WXbugSm4QDabsDfHTD/
	yv4R7FUP7DuRid2OnAZpbcXEBim7GSLXVxwxeVUOxRdQnYYtqCx+uWUKImxG2AqrjVQ8Lp1Vj9L
	RP0YVN+/VhuAINXGKM3z/0yw==
X-Received: by 2002:a05:6870:b30f:b0:41c:6512:8419 with SMTP id 586e51a60fabf-41cec27e409mr7957130fac.28.1774905489749;
        Mon, 30 Mar 2026 14:18:09 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:5f::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-41d048e1984sm5978777fac.4.2026.03.30.14.18.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 14:18:09 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
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
Date: Mon, 30 Mar 2026 14:18:07 -0700
Message-ID: <20260330211807.349539-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <acqG2Mr5ekCn2HD0@tiehlicka>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D8300C0003
X-Stat-Signature: eat7yfebi5stgntbfe75wyco8yaq5u17
X-Rspam-User: 
X-HE-Tag: 1774905490-572223
X-HE-Meta: U2FsdGVkX19a3SqsdwLBjIeOaMxw2VAMj7XcrjkagDfDm85mz35CQhul62MD/90UAUWkLphiBEpXdZAN3bUeEZ1Nxi8Ld8lzVICTRQ/DOM+w6VJP94STkbNnBl9m3PGLMfrDcjLkTNRLY4HunEelivoBtKv7kTYiQwo+b69863+rFL8SN33LhD95ByWGcTD/1oCQDaOb0C4bqdOSANWKLYHATxXSzJdxyWaJPQA8/4mE+ygGKwAR+vVtWzFYhasQH56OARd0lwYhki28fn69VLqIxt8i9EbFrBsEwLpjaGTN/XcdPFpLdLjmRqArKn+phGe+3ra6RHQrtgYd+/xrFCTjIdT4MQtNC/4Sp2D7Gx9SPtMyeWM0RQQq4DLD3DUTY7bJwINByIuW4R8ZiYK322/Rj+gRHVqHySKFL3NFe72sG4Jc0Xr8OIYetavKlyRjTYbBRrFPVYwLktB5LaAEEIpjj6ZmoRS9ZzlzzYWAqtjMGmQ6LbgsliyP+80wqSVArUOBGbyefpOnW5ZlDoIeQ4HxvzHl6P5LboXHLBmJQTpSGz/HllaBpBiT8kzYX4X4c3TrUhM3aj7Ok2JAMydFoQm1K2tEw3oLgf3CzsWBL5ZgygCJIHdygbainoBNSwEx9o5abfbgKd+ylmtKTKou2jHLyY/feK/3k0Bh63KnrpJSXpwKy6yJXvUbtQXCj5Fy7AosnT2gww3fEMBPmM/iu/09HLPaLlz9J+tiFyQtBO54++tjSZCyopPXAywgB7OWBBYJMO4mA7XHZYb6e2OkvFx35nathIBZW4JHKFdMcxDntlZ/+SawpG8e2BCAuHsEViXLPEay6PNuC5Ycz/Z/C4txjY4eqwz1hnJW0voLw0IW51BIelv3tSbCFYsCNAvf8zuA0sYbtVE5dYziMTxXPXtwpPnlzkmFYVIJSMfrvzcK7S++rq6Mz1HaOZjv5vZz18p/Z4Y32eA6F5iPuB9
 BEHT1Kk0
 igtlNDZcmh/za0cxVOhw7xFDhOTLqeDb6GSJcf7MEsRM2q2YdmCdXuzp7nGS3PytpbN8Umg6nJyu5u9b29lwuY7yn7vrG/3JMjcFeRdzjZem8cT080eVov1/AQBylpDYoXXb1MowkdXZwToxDFTm7xHLikkXoXgVKaVNiWK2gErMXm/8ZcKa9XQQNTKmRFN+czzgow7zbvEPO7ZYg+xpwV4WSIiEFL4iXYPyHnNmLSXmdqIGNWZyMlg1d3EZZIfNNJuR4d4paE0RilqWOSsFVJreg71hegHeAek1dwcdWDo34KF7DYozhj5CHiaqqqr4lhTcnkuJIybZDzQUU8QxfbQp0ouo+s3tVWZztK3m72q5Fm+3rztlWe3sTDRCAG0FpoGmtR7t+cTbp50Z7xIxpDlOdz/KaIkVtqLoIP13IWyRp43WlOdtwqfIXMAPwi8A/LZm8cR7BZN44pZG+UFtAyqY9yhcTZ4R8Y2jygkxDL4ZGnjIXe5dey+K0GUHvdlAqZGY+aEPX4atHTcaIu3OPKoUk9hQM0Euw8E0J5OSfL2wN9bLg4AtxAuq2g1x36l6XMXdIIZakJCYvM4NhnjSmKQ/8ZxtlIjld1fe7nFOqU4uBy7Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 30 Mar 2026 16:21:12 +0200 Michal Hocko <mhocko@suse.com> wrote:

> On Mon 30-03-26 07:10:10, Joshua Hahn wrote:
> > On Mon, 30 Mar 2026 14:03:29 +0200 Michal Hocko <mhocko@suse.com> wrote:
> > 
> > > On Fri 27-03-26 12:19:35, Joshua Hahn wrote:
> > > > Convert MEMCG_PERCPU_B from a memcg_stat_item to a memcg_node_stat_item
> > > > to give visibility into per-node breakdowns for percpu allocations and
> > > > turn it into NR_PERCPU_B.
> > > 
> > > Why do we need/want this?
> > 
> > Hello Michal,
> > 
> > Thank you for reviewing my patch! I hope you are doing well.
> > 
> > You're right, I could have done a better job of motivating the patch.
> > My intent with this patch is to give some more visibility into where
> > memory is physically, once you know which memcg it is in.
> 
> Please keep in mind that WHY is very often much more important than HOW
> in the patch so you should always start with the intention and
> justification.
> 
> > Percpu memory could probably be seen as "trivial" when it comes to figuring
> > out what node it is on, but I'm hoping to make similar transitions to the
> > rest of enum memcg_stat_item as well (you can see my work for the zswap
> > stats in [1]).
> > 
> > When all of the memory is moved from being tracked per-memcg to per-lruvec,
> > then the final vision would be able to attribute node placement within
> > each memcg, which can help with diagnosing things like asymmetric node
> > pressure within a memcg, which is currently only partially accurate.
> > 
> > Getting per-node breakdowns of percpu memory orthogonal to memcgs also
> > seems like a win to me. While unlikely, I think that we can benefit from
> > some amount of visibility into whether percpu allocations are happening
> > equally across all CPUs.
> > 
> > What do you think? Thank you again, I hope you have a great day!
> 
> I think that you should have started with this intended outcome first
> rather than slicing it in pieces. Why do we want to shift to per-node
> stats for other/all counters? What is the cost associated comparing to the
> existing accounting (if any)?

I went and ran a few tests, which seem to show rather negligible performance
differences (phew). I wrote a kernel module that does 100k percpu allocations
via __alloc_percpu_gfp with GFP_KERNEL | __GFP_ACCOUNT in a cgroup. I then
measured how long each allocation takes across two trials, one where I do
all 100k allocations and then free all of them at once, and another where I
interleave the allocs and frees. Everything below is ns / alloc, and the
+/- is the standard deviation across 20 trials.

+-------------+----------------+--------------+--------------+
|    Test     | linus-upstream |    patch     |     diff     |
+-------------+----------------+--------------+--------------+
| Batched     | 6586 +/- 51    | 6595 +/- 35  | +9 (0.13%)   |
| Interleaved | 1053 +/- 126   | 1085 +/- 113 | +32 (+0.85%) |
+-------------+----------------+--------------+--------------+

I'll include this, as well as the additional memory overhead that Yosry
suggested to include in a v2. I think we can get more accurate accounting
by distributing the obj_cgroup pointer size across the CPUs, so I've
gone ahead and made another iteration.

Thank you again for your insight, Michal!
Joshua

