Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5FDC1061B1A
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 18:35:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F31356B008C; Mon, 30 Mar 2026 14:35:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE24B6B0095; Mon, 30 Mar 2026 14:35:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1F2B6B0096; Mon, 30 Mar 2026 14:35:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D011B6B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:35:54 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5C4E51408C3
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 18:35:54 +0000 (UTC)
X-FDA: 84603583428.14.8CF5A17
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7F91A8000B
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 18:35:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O94QhzLl;
	spf=pass (imf30.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O94QhzLl;
	spf=pass (imf30.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774895752; a=rsa-sha256;
	cv=none;
	b=Bqi4feytK8ua9aGTjGku/2q2y3Hntbb/V+Ef+epKVdwKSCQmPn/ocRDcF19zho0i5mFdXf
	n8hdv+JBoor+KSYBeZW9ID8H1nVy4aZBIhEx+zyc5PpP70iiLqmZkfGfETa/oqymIgYWFG
	TX61IX1n3mCBe/GtQ/JU8Yp7F7Et8Hw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774895752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ESqM96XkNcuOPEIpQKNFAlZgKh2C3ssPxIkldyFAy9Q=;
	b=4QcLG3i2QayJS3QcYTxa3Xc3VTP3kv5UEj0tm33F1Sd36RwEYtOg9QrrPB1EmXQVTpcXDz
	yA/oW19r5hCbZrb6H2BuONb6QJZ5GAAQMue4VIaQatEs4YhxVabDNDYCF29QtrP5G+nzgR
	8wr+ZkwtSCz5kdtlReuSjJWsJyBCwrY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 06F7A60132
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 18:35:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79472C2BCB6
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 18:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774895751;
	bh=ESqM96XkNcuOPEIpQKNFAlZgKh2C3ssPxIkldyFAy9Q=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=O94QhzLlNazi/AlIoMclKwT0f5THTKxeP8igZtqxnPUgj+uYi9DYtZ/OYvVtWBYYf
	 DX6BRDgaEv/p69Hw6H0Xm5vxxzr+Pif/QiFZ/h/efTGJ53tOUSuZRAkiRe9/R+jCwq
	 ULMcjgOWcY9ljN3Fcmclys5kOql0l2zpuPyuzXSyhUl7I5muBplHcJLzWYlPg9IKOI
	 +awyFsaXhvgUgggz9se/zOqgQvDqCpKVBVB8vQAGH6QlXvmgr2LDAvOVU22HX4ThEJ
	 nfLDDDeA0FbSBchF1kFCexacRXHuOJUjGzuvDdTXXPtuIBdGBXpHEVcVi1VkDeQXmd
	 9kMiPoYB8edBQ==
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b982518b73fso787838066b.1
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:35:51 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWLfunaO9zN/y8AEMWtgY05+BqW9vxAgrNPHgCneeuBuqtSqga5GzdmB1VFplajCyH/k6CKRjNGEQ==@kvack.org
X-Gm-Message-State: AOJu0YyRpxr5UugV18CAVNA801++hRwVHm1YoIIxL16RhCgAr6g2oVUa
	s8Lm3O7MHiswzi+TeW5Jy3+0DWD32biGg7yqdZRh8htLNX2jKAXSGsQYvczw9fFPVfBsEee/7PG
	qheT25iGRKdF40hlTZiILdb+FLdur9kM=
X-Received: by 2002:a17:907:2d9f:b0:b88:5158:d10e with SMTP id
 a640c23a62f3a-b9b503a35femr907996166b.21.1774895750115; Mon, 30 Mar 2026
 11:35:50 -0700 (PDT)
MIME-Version: 1.0
References: <acpmkY6_gWLdtJCB@tiehlicka> <20260330141010.3126996-1-joshua.hahnjy@gmail.com>
 <acqG2Mr5ekCn2HD0@tiehlicka>
In-Reply-To: <acqG2Mr5ekCn2HD0@tiehlicka>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 30 Mar 2026 11:35:38 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOKaPocJYMKL=A=6=qpWgwCa=fMC8EZsSW+632M1q1sZg@mail.gmail.com>
X-Gm-Features: AQROBzBaAzAm2Me2kzCfvKE8aHVz1Ho01z18mV6apSHtbDPcXk8PmR1kLhDbgJs
Message-ID: <CAO9r8zOKaPocJYMKL=A=6=qpWgwCa=fMC8EZsSW+632M1q1sZg@mail.gmail.com>
Subject: Re: [PATCH] mm/percpu, memcontrol: Per-memcg-lruvec percpu accounting
To: Michal Hocko <mhocko@suse.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7F91A8000B
X-Stat-Signature: 8eu673rw9gsz8k98b74seui8ia1ob19k
X-Rspam-User: 
X-HE-Tag: 1774895752-744853
X-HE-Meta: U2FsdGVkX19ExSdZElCdcQ0aOSv5CYjh8uvf3g4g/6QxJG3hDcc0wULClYDTp1nqPa+p9/iRrxVXA0layJ0FHRcw2zdd2fXIIu4DuF6O94LyMXlseUu05qN7cJ6QgVWqsSp0zDoS3HggVsF15gi5aPrOMH8BqWswyxZlHYEchwjEz0GnC98Ou0pHNp2C2WD9YAfct2RQlVofulK9Hjq0xY1e5uQYSYGPO0hAhoaFUFJu36ZlPUd3AY3qiDJYDE3o0Ev5tg67mW7zM5+jwzENkc7O+lTzg/QhZ0ohXc5AwaE935cagIqIMcA9h9/SWMZOY9gEbg8FUWQFYRNOy9LDxBM2VbPwywdwQWG2omsyr+pkwDHyXx4/w0yWAjmQRcXtFgRTMqbDgLM5Ya7ddnIHj8A+VPX8WlI4yTFdao79s9k1bKKIceWprb/yqdUBuD56V6jP/ZzMOXXCjY+m9bJaSFuokg26UrExoCkFaFET0spkZm8kPjSaQuul+kHDSCG83CIbPWvsGjOt5iZ0UcnRlRu3fR2M2BDZ/4FihcRLZ+KsB0rM0BQyi31XHvjtZom14emn/uTlS+Mnm9c1zMCl9yADMFbfghhwailOM6WIMMNJqlH7yDd++AB4vlx9ueJXDDK2Q4ACMtGF+TB0FlCKPfOwaPZjglmZNkBbVL6STGm3nhKoVnuuBOH2556FeCbxw1grWnTix3rsRnm4tAmbRoujukmuU2orXtD/L4rtGLaNKfCGvEQlMSyPZXmVkD5d5e5Awdg3f/5QN2AvHU2wHqy5qHMJtRR4LjKdlE3U9Mjgtk0EZEQEWt3JQqdnqquTiGmf02bxxuqdc7JxhNqlGxCxbTokbodSEbdxlJcxb9REFk/bfzvcqcMCUk6R8j6bXZL2IhJc2guQ1FAMjyoru9/Hxy7OiYKCEAUFZYmbUsUes90TQGA8vfCdiWxPTGwOa8JFp7dyBBokfo4D61I
 UFLRt6hS
 guA2ks3wZKJEU7v8zaod4UZPfTLoz7/v7FLqSPVpNFZYguGNPowmBeL4DuKRMGFUzz4FidtdZo66quByHnAPTaDNtLkiVIC34yMgEP91YtGZYQ1rFK3t3Ix7mpWayfzPzo7ZYBVuclae79vvxKFFO0g+AwmNwsESa+76oRLapRrd+2MnEsFVm+vtOlM4hBubkzcNjgoJzaVfxkiJnPNqz/RQkxzRZiHFBDzjaHDgZSBeXqAeDwvAbsPC4J7Q8BhAMYVY8mI3CHVkY/DUINDQPDQIX7jBJ0tEy9sqFPmrCf3jPo59OaqwjhTBQWBUQcQFsZc5SM9NoKBZq9k5dOQLN/e9EGJHibkruCFGMyNbm5A3NcM9LIYAab2ktQTeuqEPvBlB6s4s7ESNgmcHbo2rB16iFMLDFMnYRqMRV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 30, 2026 at 7:21=E2=80=AFAM Michal Hocko <mhocko@suse.com> wrot=
e:
>
> On Mon 30-03-26 07:10:10, Joshua Hahn wrote:
> > On Mon, 30 Mar 2026 14:03:29 +0200 Michal Hocko <mhocko@suse.com> wrote=
:
> >
> > > On Fri 27-03-26 12:19:35, Joshua Hahn wrote:
> > > > Convert MEMCG_PERCPU_B from a memcg_stat_item to a memcg_node_stat_=
item
> > > > to give visibility into per-node breakdowns for percpu allocations =
and
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
> > Percpu memory could probably be seen as "trivial" when it comes to figu=
ring
> > out what node it is on, but I'm hoping to make similar transitions to t=
he
> > rest of enum memcg_stat_item as well (you can see my work for the zswap
> > stats in [1]).
> >
> > When all of the memory is moved from being tracked per-memcg to per-lru=
vec,
> > then the final vision would be able to attribute node placement within
> > each memcg, which can help with diagnosing things like asymmetric node
> > pressure within a memcg, which is currently only partially accurate.
> >
> > Getting per-node breakdowns of percpu memory orthogonal to memcgs also
> > seems like a win to me. While unlikely, I think that we can benefit fro=
m
> > some amount of visibility into whether percpu allocations are happening
> > equally across all CPUs.
> >
> > What do you think? Thank you again, I hope you have a great day!
>
> I think that you should have started with this intended outcome first
> rather than slicing it in pieces. Why do we want to shift to per-node
> stats for other/all counters? What is the cost associated comparing to th=
e
> existing accounting (if any)? Please go into details on how do you plan
> to use the data before we commit into a lot of code churn.
>
> TBH I do not see any fundamental reasons why this would be impossible
> but I am not really sure this is worth the work and I also do not see
> potential subtle issues that we might stumble over when getting there.
> So I would appreciate if you could have a look into that deeper and
> provide us with evaluation on how do you want to achieve your end goal
> and what can we expect on the way. It is, of course, impossible to see
> all potential problems without starting implementing the thing but a
> high level evaluation would be really helpful.

You should probably also speak to extra memory overhead to move all
these stats from per-memcg to per-lruvec.

