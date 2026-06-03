Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1C41CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 18:43:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92A8B6B00B1; Wed,  3 Jun 2026 14:43:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 901626B00B3; Wed,  3 Jun 2026 14:43:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8174D6B00B5; Wed,  3 Jun 2026 14:43:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6C7056B00B1
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 14:43:37 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1063312043F
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 18:43:37 +0000 (UTC)
X-FDA: 84839474874.06.A8A55A6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1BA6C16000F
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 18:43:34 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="hcolFb/j";
	spf=pass (imf08.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780512215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hNMhTQc3uI5KUEB3GMgM5Dct8sn5Zh6rkUEqC1LLPWo=;
	b=UPZXAxPEsDJn/qR5JZk0WupS7Nx9EOslw/77mtLWjV9+u9IDgo996pybn7d2nFzXggLnrp
	oUWnxo5Q6R8klLNhr2f6WQpv1ulFAem1u9U+4Dr8D52F/TdlYlMCyRyGreRAkHZ7SNd2eG
	rVtF8e9/G5P2fdxtSZQvOoiUIzrpPS4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="hcolFb/j";
	spf=pass (imf08.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780512215;
	b=VL9wC29pUAWzgIgBsWk0E1jIp7uVK3dj0DPh0EQAiDqLMOcQAvT+UIr++p5waMoPHXTe/6
	I9coOkL25w/F5972S5yJcHu1TsMbf2WUfBOs2pWW/gvd5/+KkmeRLqn4YY2qgELSsWUGru
	nINqhBlOIFRNHjQPpR/moSfGmO0nVUw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3C0EA4441F
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 18:43:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 116741F0089D
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 18:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780512214;
	bh=hNMhTQc3uI5KUEB3GMgM5Dct8sn5Zh6rkUEqC1LLPWo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=hcolFb/jr17Z2lfua37EKO2xRcordkRgNDFxnaaHzUYTF30dMKZHlXT2KnbuFTTg2
	 zQcFTeoQAgxoWPLR7xEa2UpS57fkaYYA2ZAnw9p5v2aALlFBnH3DCsv3X7yYETpZYY
	 49yIJrhaykvA1YoEI4cnblF2ktgzqjswHl5sEshek9WZP9wBAhdhBupjc1CpbRyXC4
	 aNFiSJLTNq/MpMkBqYYrzmW6kd5an08kvoMQHlhNvD61cCe35Hy+jdTmpahLq5BjJ4
	 16lVka8A7Fg6zfpzMqUMJAYBMCHko1GPpcIoL5GXMX0fBbHKDDtaMEz3QN68pUTM4k
	 Uvd7OHB6huhYQ==
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-68d234218bcso1310293a12.2
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 11:43:33 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/3QO9bCjlitIhMKiLmIT4mmEWQXI9+VpsWGgQrRnQ+BPKhyxBPhdluoRVqYkUuKF5MzhTJZ7gZHQ==@kvack.org
X-Gm-Message-State: AOJu0Yz9yNGKe/nV+iFdPKR6AXrqrXCBDJZvnZtOs6xLIj3NUqyyHTFE
	ySI6EWbdF0OSZsQ9bPBp+2kO+2BofgkefPErzheYHDUdVH97NEx0b4M0xLKnagzZXxgDwChDNpR
	nUUVE/JsR10486CBcf91eBN3IQmtik7U=
X-Received: by 2002:a17:907:7203:b0:bed:a7d7:82c8 with SMTP id
 a640c23a62f3a-bf0af002cd9mr261639966b.37.1780512213033; Wed, 03 Jun 2026
 11:43:33 -0700 (PDT)
MIME-Version: 1.0
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
 <20260526114601.67041-3-jiahao.kernel@gmail.com> <aho-Z6wshceTAYd9@google.com>
 <ea2c1323-1440-e927-f14a-0eac54a245bf@gmail.com> <CAKEwX=PoBZ4ci30tKHQXs1o9=NDpPrtbe7RxxZTbnzVJf74ZYQ@mail.gmail.com>
 <CAO9r8zMBUMXy_bkeT8z+M=dXayU=6VGEw+-HmfDWR2fyJy=z+A@mail.gmail.com> <CAKEwX=NQUqqrM9vdYE2KhWEZx-YwPc7YPhfz7xaBrGVDf824bA@mail.gmail.com>
In-Reply-To: <CAKEwX=NQUqqrM9vdYE2KhWEZx-YwPc7YPhfz7xaBrGVDf824bA@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 3 Jun 2026 11:43:21 -0700
X-Gmail-Original-Message-ID: <CAO9r8zO0GjTeY2+j_AjfTQ8qYOmHezZAV44f=aPgrjJcdtO9rQ@mail.gmail.com>
X-Gm-Features: AVHnY4J_T8SUJQ7bZrxF3cMA-0m0a9pPaiFo49afplD4fl7V8MHhy2NRIiywKjM
Message-ID: <CAO9r8zO0GjTeY2+j_AjfTQ8qYOmHezZAV44f=aPgrjJcdtO9rQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] mm/zswap: Implement proactive writeback
To: Nhat Pham <nphamcs@gmail.com>
Cc: Hao Jia <jiahao.kernel@gmail.com>, akpm@linux-foundation.org, tj@kernel.org, 
	hannes@cmpxchg.org, shakeel.butt@linux.dev, mhocko@kernel.org, 
	mkoutny@suse.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1BA6C16000F
X-Stat-Signature: rgmfeaz6toep5wt5u8yzecoqzx9o5q8h
X-Rspam-User: 
X-HE-Tag: 1780512214-234805
X-HE-Meta: U2FsdGVkX184p12N1z3fQtyZZNUui8qXLkVTAKHiVyhJqB3JQUiUPDTtUVRbl2dCrv8kQz+WoUE785EQkzCLS1AkU/wenwkjPDu73sUzCbI4lN4IisjZzFLyJpagg4AJ/rZTDP1Kz5hFUPbX/5xE7gKbn8Ofs71fsfX3+5wb9Um9exejF8ya/MaFwo/FXZ5SG7maGJbfRFvezoyhm1JEd3EbBghWW4I15vLA/xzY7yUaYiGetPoP6x7/vS8v4DaJFlt2GnCH8HHNIOpHvLk3LMVUFqRxv3x67yhk0wBXob6g5kocqmh/BZZutuLkLdqHZ6SXETu7dz8F6UOM5ITZ63HHJWD/LNGMLu1lNCcXqMyeejo3pxycPTEDm2by7nzHCHYlEkY983f3XfbZFovs4B2XvnuDOupX0cU6lutJNqVF8+j5k1c4W1aQCkxtXkF7wv8uOy4UIS1QqSpakBXDab7O/Q9NiFiXZqmapYN8bCSPzWfjSriwDW4ni33gQXtU8EbUA6GRtocYUmsnSU+7Lw8XMQ+zqG39s4O8e4C87VrPbzGcMMmN0ZOrD1JfeqUPyjdvPO61n3sjThIu6dWBiYAs64K1D8UrXZwgXrj3s0epH0SokEKWGvlBkC8QMZ4z8RKdcHWJOjoB30DUafB/swk4zu11wDZt0aPrJaS1qbtY8AAUuCJp3Y4fDuRMUhtKOBYceCIbe+Lg9x8ItsRx7o/hV77+Fy6A434EYBEelbdGuj+zfDJ9JY2AhftdugMXiYT0i573ZZVgBvRErYuKdaDUgPdDAncaQ1hufhrkc2N8Agr1wst8YvHpDP+m0A7dO0WB8QjNMNp7l8j+WyzWbRJ78hzEEQ0B0A2fjsE1By9C+hiS9Tq2W+PDD2UwTSF4fMu4n4WEWK8eWWfMoi9iJonaIqjlohYFftB4lnsj0mPtQob0HbNZVyITwlpH67dVpjjTnIPSmuDr3DMrVc2
 FqfJSwqR
 0rMYt8JncjnvGDmcpsAGpTdyWjSlMxjzFAXZSuBUtjOgdYrbvV7zAXW7UILPMLgFVI+RPrjahKayQ0L7mShSe5w/aFJJOPFyX7CS4jlEkttIeZ7avXypjkVwRdma2YcOXEBDTyviLs04RNu/tfSOG7XZAWHPUaoVB/fvD/M61F9rB/tAeIpeA+9UZFIumOv9EZGYfUry2XTKdL/c7TJ1n97JoqWi4kL2aRTEFox6zemi/3+9xglR0CAYofZu04uZn0S5pNNgoWGlg7icySfqWnfo3gz1av8TnA2JHdDPGTXySCsQFJf2CEx8r7QBGQSqD/NRletwvXbbQvrVSLucgKkxXHUFpGJdwpRfq9eCu/MEVG4EbKxWGN8nZTZ995447qW3QH9Gkw9zCMY+l2S64qX9V+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 3, 2026 at 11:34=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Wed, Jun 3, 2026 at 11:26=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wr=
ote:
> >
> > > > > Is the main difference that we are scanning in batches here? I th=
ink we
> > > > > can have shrink_memcg() do that too. If anything, it might make t=
he
> > > > > shrinker more efficient. Over-reclaim is ofc a concern, and espec=
ially
> > > > > in the zswap_store() path as the overhead can be noticeable. Mayb=
e we
> > > > > can parameterize the batch size based on the code path.
> > > > >
> > > > > Nhat, what do you think?
> > > >
> > > > Nhat, since we now have the referenced-based second chance algorith=
m,
> > > > should we consider doing batch writeback for shrink_memcg() as well=
?
> > >
> > > I just take a look at shrink_memcg() and realized it's reclaiming one
> > > page at a time. Thanks for the reminder - I hated it.
> > >
> > > Please batchify it if it makes your life easier :) We don't reclaim
> > > "just one page/object" anywhere else in the reclaim path, Sure, it
> > > adds a bit of latency to zswap_store() if we reached cgroup limit, bu=
t
> > > IMHO if we hit zswap.max limit at zswap_store() time, that is already
> > > the slowest of slow path that you should have avoided with proactive
> > > reclaim/zswap shrinker in the first place. And, setting zswap.max doe=
s
> > > not make sense to me in the first place (I can write a whole essay
> > > about it).
> >
> > Should we batchify shrink_memcg() from the shrinker and background
> > writeback, but leave the synchronous zswap_store() path to reclaim one
> > page for this series at least to avoid potential regressions?
> >
> > I think this change specifically needs more intensive testing (vs the
> > other code paths).
>
> I'm fine with having shrink_memcg() takes a batch_size argument for now :=
)
>
> I suspect not a lot of people invokes the shrink_memcg() synchronous
> path in zswap store though. Setting zswap.max is hard (as it involves
> guessing compression ratio ahead of time) and induces quite a bit of
> overhead (obj_cgroup_may_zswap() does a force flush for every store if
> you set zswap.max to a value other than 0 and max).

Yeah I agree, but I just wanna make sure we don't completely kill
performance in case anyone is actually doing that.

Regarding the force flush, it's unfortunate that we need to rely on a
stat for internal limit checking. It might make sense to use page
counters here, which already support hierarchical charging and
whatnot. We'll need something similar to the objcg approach to charge
sub-pages (or maybe just reuse that somehow?).

