Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 788E5C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 16:34:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59DD16B010C; Mon, 29 Jun 2026 12:34:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54F606B010E; Mon, 29 Jun 2026 12:34:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48C3D6B010F; Mon, 29 Jun 2026 12:34:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 246116B010C
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:34:07 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A0EB78C52B
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:34:06 +0000 (UTC)
X-FDA: 84933497292.01.1206ED5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id DB05818000A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:34:04 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uvduFPxh;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782750845;
	b=IbZmwmqH8EcIL/uGOQwVHfj8LWto8hbCHw7KQ33OF6BDEeRNgFGxqT4kULnyV2Ojudpz8R
	UWR8CMbBWLbML65flxU3Pbie+xjM6prw/QqVHbSajizlnQsiO79wZ6RrCwHmi8v41MU8am
	E7UjQYDyPED4udS8BJGCM4qJmR5XG8Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782750845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rSWd/bQSzHe8Iq/VNf2zewGegErxrGJT7kEbZKW8vaI=;
	b=zR0dnwB7zFXDhXPCpBkNmTqob3AvRcYBabWQK/KbuLs/zZ/tP1rMp+mQinsep4s64gtBk6
	ThA01dMWMJli3/4pPEq7ipAGIoJSngqzwq5+kYXberOBJu+WqtwX7OemF875PrDpVBYpdf
	TdM6k616pSFMsVwWHMFGmOpc5mIn4ZE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uvduFPxh;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1982D601C8;
	Mon, 29 Jun 2026 16:34:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2707B1F000E9;
	Mon, 29 Jun 2026 16:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782750843;
	bh=rSWd/bQSzHe8Iq/VNf2zewGegErxrGJT7kEbZKW8vaI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=uvduFPxhRWXqREkwtY9s5rbK583t9aI3KTKK72sfnejBDFsjlclavo/yjshPxsc5k
	 0N75X4+6j3brru09lXqRqSjYHLcp14T4OWRMQCYJiP/lly2FMCprasmsMTFfxHJ+rW
	 RZjKL1P9SZ3/pj3Fdy+3c2rp8zt2x9OGJ0CItxDg=
Date: Mon, 29 Jun 2026 09:34:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Xuewen Wang
 <wangxuewen@kylinos.cn>, liam@infradead.org, vbabka@kernel.org,
 jannh@google.com, pfalcato@suse.de, chrisl@kernel.org, kasong@tencent.com,
 shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev,
 baohua@kernel.org, youngjun.park@lge.com, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm: annotate data-race in cpu_needs_drain()
Message-Id: <20260629093402.a4d14d4f95ccde7d4c804115@linux-foundation.org>
In-Reply-To: <akJHit8BV-hWRXYk@lucifer>
References: <20260626053700.2036899-1-wangxuewen@kylinos.cn>
	<04ea3e05-5b83-4c2d-8759-67c544a7b484@kernel.org>
	<akJHit8BV-hWRXYk@lucifer>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DB05818000A
X-Stat-Signature: u3nieiwur5kftibnbc17red4wmmgj5aw
X-HE-Tag: 1782750844-830851
X-HE-Meta: U2FsdGVkX1+Wu4Z094VEZ7xAmTybebVt0Ps0dq3pFgj0DftZgK1tTz2sscgMVy5Ooo4EMXxHAWCJyYaSpmDbWe6rc688XcY2rC9K/iH1NBybH1jXbdzhdFP91YZMD7y0lt47PFKTSwTsmz145YyjlzMhQ0DPWBbagkBdSnsSMnmCnXYLb8xAwPdLFSo4TddH5zYIMMWw9OBJpuQKDXTUfSdk2XvvcnSyD5TfzNsgrsBr8rJfh32ARjaqhH3OQzOLB+B5oM24Caj0yVmwb8pulQukJldWgi/5SQwdfV8s7/wvy86JxmG5efv32eVUfFzjlU2Kg5FAfgJntT6qRoXWkn7aef8BE/o35s0x/SGdvboVVz8i5d3mvRKBUw7mWfg8BplD0g7lN1VP3jMFIxUjPGfA/j6Ye9Ias76zGDjc5nVGfxjnTeIa9ZjK4P01GROBAVRt9aFBnH/LBP3aMncIJyxdxc7WXeB4tJ2fMDxPdQK2gurC5FQrFDaPLDAYguZK9FGycK1nUJjKygp86YykSwK/5gWIFLHoCq31CpToOQ61NaWXHK56v86587g8HLR/OUvoTnXpw+1Uu5XOlnqR9ksV/cbebVulYR3brKfJ5hv0hgc0PyS9X7ONBXf1oLgonUBPbhDLLWeOtkVJ+NkpHShHWcPtLYHwraIUDlncOPFOm+VrXba6d+a4CeVTTAY8KontaN5IYjCZd8ncUmb6JRRY/TNWO/HrGY80HlSFeez5xS2AnTIj2AmZyw0QBfyNB9HGInVNfqUwDnfjE8TlPwAdLO14GQi7Z3jo5Aajpp1YVqpZFayhiO7HzC0KJckQFZpgsof1z7Ae3Nm3A155v7guYcAtUu2xaq76WnW9fxPo5rE5iFZKNVzygCubznNgG3toMD8rpRJn8CTyTXbgk0pH9O5HXzuDiiCGR8SnrHfa3FipONhacx7wI1MNM+mcsmNvL/OVp37kvQVFRJI
 uhfbKScq
 K6xbaKzlggtNGGsWKCEl457aswH4pea25iWSKEOydOw7ZbzzF34av0goR+NG+1RzcRWrMynDgQip3Hi9LGxya7JF69h8b8ZkLPa6IFG3kjDh3N3LTcfIHW3l5INK5ndkhCdrThcSpkVBVnNGSf6ZwLBwcqXyVlJAYqNX7EaKwwNGgOLZcX1zqgnrIbNnSy1+Y7K4cARzMJEsL3M6VP7yET7mFrLXFaBzjYEW622M6GSqd8JVLkezJOTLd0RA6XhnpOn4DkEsnewNuNV55mDyMETOxTfGtO2xCCU+16osnPFn2etk3WeopGIgLOc6U3RaMPzNc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 29 Jun 2026 11:23:26 +0100 Lorenzo Stoakes <ljs@kernel.org> wrote:

> > >  		folio_batch_count(&fbatches->lru_lazyfree) ||
> > >  		folio_batch_count(&fbatches->lru_activate) ||
> > > -		need_mlock_drain(cpu) ||
> > > +		need_mlock_drain(cpu)) ||
> >
> > The indentation is a bit suboptimal now.
> >
> > Would read nicer as
> >
> > diff --git a/mm/swap.c b/mm/swap.c
> > index 588f50d8f1a8c..5958e6fdd3593 100644
> > --- a/mm/swap.c
> > +++ b/mm/swap.c
> > @@ -828,13 +828,13 @@ static bool cpu_needs_drain(unsigned int cpu)
> >         struct cpu_fbatches *fbatches = &per_cpu(cpu_fbatches, cpu);
> >
> >         /* Check these in order of likelihood that they're not zero */
> > -       return folio_batch_count(&fbatches->lru_add) ||
> > -               folio_batch_count(&fbatches->lru_move_tail) ||
> > -               folio_batch_count(&fbatches->lru_deactivate_file) ||
> > -               folio_batch_count(&fbatches->lru_deactivate) ||
> > -               folio_batch_count(&fbatches->lru_lazyfree) ||
> > -               folio_batch_count(&fbatches->lru_activate) ||
> > -               need_mlock_drain(cpu) ||
> > +       return data_race(folio_batch_count(&fbatches->lru_add) ||
> > +                        folio_batch_count(&fbatches->lru_move_tail) ||
> > +                        folio_batch_count(&fbatches->lru_deactivate_file) ||
> > +                        folio_batch_count(&fbatches->lru_deactivate) ||
> > +                        folio_batch_count(&fbatches->lru_lazyfree) ||
> > +                        folio_batch_count(&fbatches->lru_activate) ||
> > +                        need_mlock_drain(cpu)) ||
> >                 has_bh_in_lru(cpu, NULL);
> 
> Yeah that works for me.
> 
> Andrew - maybe easier if you fix that up? :)
> 

Sure.

--- a/mm/swap.c~mm-annotate-data-race-in-cpu_needs_drain-fix
+++ a/mm/swap.c
@@ -832,12 +832,12 @@ static bool cpu_needs_drain(unsigned int
 
 	/* Check these in order of likelihood that they're not zero */
 	return data_race(folio_batch_count(&fbatches->lru_add) ||
-		folio_batch_count(&fbatches->lru_move_tail) ||
-		folio_batch_count(&fbatches->lru_deactivate_file) ||
-		folio_batch_count(&fbatches->lru_deactivate) ||
-		folio_batch_count(&fbatches->lru_lazyfree) ||
-		folio_batch_count(&fbatches->lru_activate) ||
-		need_mlock_drain(cpu)) ||
+			 folio_batch_count(&fbatches->lru_move_tail) ||
+			 folio_batch_count(&fbatches->lru_deactivate_file) ||
+			 folio_batch_count(&fbatches->lru_deactivate) ||
+			 folio_batch_count(&fbatches->lru_lazyfree) ||
+			 folio_batch_count(&fbatches->lru_activate) ||
+			 need_mlock_drain(cpu)) ||
 		has_bh_in_lru(cpu, NULL);
 }
 

The removal of data_race() in need_mlock_drain() is a little worrisome
- perhaps any future callers would have needed it?

need_mlock_drain() has only a single caller.  How about I remove it and
open-code it within cpu_needs_drain()?


