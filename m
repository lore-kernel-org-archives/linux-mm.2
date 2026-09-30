Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BBE0CA5FAC
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 11:33:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E6056B0088; Wed, 30 Sep 2026 07:33:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 597996B008A; Wed, 30 Sep 2026 07:33:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45F416B008C; Wed, 30 Sep 2026 07:33:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1B3256B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 07:33:11 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9E9FBC072A
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 11:33:10 +0000 (UTC)
X-FDA: 85270217340.27.B5D5883
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	by imf16.hostedemail.com (Postfix) with ESMTP id AE820180002
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 11:33:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=M2hIPpHd;
	spf=pass (imf16.hostedemail.com: domain of 3cvO8agkKCKkcJadWbJQdPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--tarunsahu.bounces.google.com designates 209.85.218.71 as permitted sender) smtp.mailfrom=3cvO8agkKCKkcJadWbJQdPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790767988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MpduhbNkFUuFWigrQQWVYqgTBA32JDerhEvTpfLDHMk=;
	b=cb8z5RX0DWposUPM+5ZDcCS90eFZSkA5Lr64ouIXgiodzhxqQdsk5OGBaImCaHi0Q8Lz+t
	iv865JWtPzUwGoDlH5rFZBqE136/Y6ww3mkRjLELId3sSEMs2QEedmqdNu8tGifBJcNVWg
	KWMx3QfTO9K74jHApyKrwBzS57VvNpw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=M2hIPpHd;
	spf=pass (imf16.hostedemail.com: domain of 3cvO8agkKCKkcJadWbJQdPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--tarunsahu.bounces.google.com designates 209.85.218.71 as permitted sender) smtp.mailfrom=3cvO8agkKCKkcJadWbJQdPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790767988;
	b=FKTLFsOWG8FZCo+aKbrF3/x6+omnB/LUibDwqJNwSTHyRI3cLZw0Ui6k6VR9rGZhk4pB0t
	ecEFAaIpHtlLyiRLQxh3qS8JEkXVAXy0CwPTDgzWeosNngxNbYSFa/i27DhOMI3CjHDBPs
	yriwOQnWiPVDyJd1ewXYndb39ySjmsw=
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c293a65b577so459953666b.2
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 04:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790767987; x=1791372787; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=MpduhbNkFUuFWigrQQWVYqgTBA32JDerhEvTpfLDHMk=;
        b=M2hIPpHd7Yy77pE9ubxG9ZrjLb2aklCJtkU1IpM/t2ixQLzpOnxPRwaxW80y3DLCNU
         y+dY2qtyUek4U3lRgQsIGAzxiT3vXn19c6Y+Eyv0iuZncWCZDRUheisIZy3FF/p1DV+4
         lT87p20VrRe+VSBLTNZr0Y8CZe3DqhAXvibvhMIoZTSHeFF9k4CRe9redODi/amj7zRX
         3CdOqAF0L71THVkPEVd/XUZ00GGF864sCYtEcSOjZCbudB2xQHPWy2L4ElTQBujWfljK
         pph5Jo1k1XsfZlIy5Nvd83uc88IxnlfO6Zo2peeX9Dog9b6aTAxbrzOCgP/9S7LTw1dC
         DqDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790767987; x=1791372787;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MpduhbNkFUuFWigrQQWVYqgTBA32JDerhEvTpfLDHMk=;
        b=bDqKBOhlkAuN9fysrj0e1kSzqRHo4mblWyKbHn+2pK6vi0kWzFRuvBHI6Kq0ZYK2ZW
         BTfL8aZF2vYYd5uSeQ1fytGYo37L/JWowFi8f9zrEoOT7QEM9VRm4e5Ve/bdKqKwLfGM
         tvenIUUTJyoYELnWYyScftRHjdT9V96P5SFdKdc07rNJUuBSYYcokDupOX+gX2c4wA6u
         ChxzFrni9E0F6PYmF6p8ThaNs7niQF3EcoygjJi/St6U5uk1IApJmH4NCdO+G8ICxRH8
         kucgafpzIc2Yz1VZ73ToPmY/gwpGy+ndmx+gzcqtMYKfJpTpKiGX3CXgmgOdXL0zLzW4
         QVtg==
X-Forwarded-Encrypted: i=1; AKwUvBwPKSF+zNtFa1oqmVwLQhVbBTDtxtutipSwgSjCSThxTDQb6pAsBpuPnv1yb+BTDi4MwzdcnHFRXg==@kvack.org
X-Gm-Message-State: AFuF++mTSWse6MN5BgnsYKnk2huitKZIZBVlXxLoXKIw6IjD64C99XX8
	q6YaP4dZgpsTTZ/AEE9fLkNNFC5v7PGkmj6nNqhVpji8xZbWdSr5SeW7LHnUvAwszA3EZx28efx
	8mVYs7IoyydmOcItR+g==
X-Received: from ejcfs31.prod.google.com ([2002:a17:907:601f:b0:c2d:46db:167a])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:3e1a:b0:c25:2d27:5652 with SMTP id a640c23a62f3a-c2e23cae407mr82433966b.11.1790767986551;
 Wed, 30 Sep 2026 04:33:06 -0700 (PDT)
Date: Wed, 30 Sep 2026 11:33:05 +0000
In-Reply-To: <20260926093200.5727C1F000FF@smtp.kernel.org>
Mime-Version: 1.0
References: <20260926092448.4090401-1-tarunsahu@google.com>
 <20260926092448.4090401-2-tarunsahu@google.com> <20260926093200.5727C1F000FF@smtp.kernel.org>
Message-ID: <9huzfqyrrn2m.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v3 2/2] memblock: use binary search to locate candidate regions
From: tarunsahu@google.com
To: sashiko-reviews@lists.linux.dev, dmatlack@google.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Mike Rapoport <rppt@kernel.org>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, 
	Pratyush Yadav <pratyush@kernel.org>, linux-kernel@vger.kernel.org, dev.jain@arm.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AE820180002
X-Rspam-User: 
X-Stat-Signature: 6nor3a4br6kdrqpxnsbitcebdf8rxkjd
X-HE-Tag: 1790767988-248700
X-HE-Meta: U2FsdGVkX1/Wh+6A93jOB6pkPtdWR5/fAKlYvK6JzAWfp8zciOVtEYDhYuN451e8h7gcfvsuRcnLaTHPnTHejGncbtLbKWN37F+FXZ3WlAmVsiAkdLOgq7pYxTAnvbFB9L3kDb63VssH8l2yY2YCNirD+gFggHX5DsR0z5FWnUjxJ6xRS0DXuA4vBO7TPHZX2C78A6eWmLeGMuFor5AdZT5nPQF+ecJRVveM0Ds/Y7rCaHp7ePyaNB3p+O7KTZ6uAPkDbhoC7nHAE0lOiCadtUey6f0fbwKTYAKd0ZelXxurdRJJ5H4TiYiKkJ9vz4dL7Boi0Mq6HDV4xjT9E4yUVMlf6xmrFIz5dEw+zX6Ebc/5DXnauWKCYk1ruioOfb8mxHi+WSU2INzn2WP6pp4yqMBmdNRpm2r91AGsfWJog3/OLot8ituFZr7p5TAKVPSAfpLRSYsOl0HLklpi6jkgVw++Ywo9Nh2diSrNz1bMRRYIaAQvTER+p2LJfHgSf8NcP+OL1hykNxktAmAgXPyNfkqR3dxfbjAeljr62alf88sOetCb1omdvB2doGx4GFLI4ed7XpfoUfeb30mAESWJS8/yVPFIIS88ALFYVo30WrGHfLAjv566jFgELqyOmbqr9g2Bss0hj/24lTnP/WyrVq2K2KAAJoqa65oZ5bEs+lA8wrAD8Mv8p2Ue1qVSbtvzmvPrRyY9IzeWtEYv9dkEOGegX/Tg0gnqQUAz62QMM9XyUdFf71QUhhPDvwZdp9SsG3P2EZPqzFmyVr0TFqgPAePuow99AvgFf6jY5L8X/aSkYPN/lnE+YkEUUvu/pJ1YXPl3N5dbztKJPIzbLQjpt7YpCoheHtaBwDMxoJkGH8shlFXLL9UOUvdxDfDSaqDWlGNX8MHtU+/MHQjBpYmyivzmRXW0IIyvHuld99Jv2SJuJH/4wKmb1P2dy/mTjv+/IVtLGnYpdjGrkM1auR4
 KNGY9y3P
 OgP8luJBFocTJ2Rwo4bVH0cVFR8H2ZjOBBNOBpayPOliCefXpL4IP14xgDKw/KBrMkkYgqm4f4576UMwbzfkwARDf23cw6P/XfC5o4V8LSGSp3ubyd01oYgX+IwYc+Xy4va8ChiBVC7qS2FhDg+Go3s+jpsBfxaQV4zk+midtdWeX6KJPaMIiBp+hd6LTEW+SpQUjWSZVH152chXUW3D93XfbehRP72+zmsRUBaH+uXXP/7YY1+iN5gLHv4oc3ZgsNtflG71qgaA1LmSLctm7gHcdwNK/Hu4TAMgWpQqVX9A33X05rFZqNZVE0RfKQQCISMLq9puyQFc9QryV/Urb7Sz6MdLJ/Xrq0JHszOspX024hqv7HxqrYcg7a3YkVp13KzM+2/oRRVH5cD1s6QjiPYl1uhgN4nQGoyleCa6qT7aJI1E0xQhWJjmkOjkO6qmfyX/AjO9zs4zShLlZmHS482No12roLPBwMtPTkUdd4aDQhBVLzSzab6GKHkYnUVJVQAuuGMwAIQmCCswUVI7zhfJsixmZ4K2h17jyG+nNhTC3ipybi4SWcLMO7WYivK9iIZ5o0LdAuOBSJa+zb+Wq4UaJwxqd14BDf3PODA7MhhHf+tqZfXrwAiqWJq8+fY4GmDTqOCxVDCQkxaAEG7rDTbru4w4rbJTP39xy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

sashiko-bot@kernel.org writes:

> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [Medium] mm: commit message falsely claims O(N log N) worst-case comple=
xity
> --
>
> commit ffd047af563941b5aabcd86a52d569f9b40c01ec
> Author: Tarun Sahu <tarunsahu@google.com>
>
> memblock: use binary search to locate candidate regions
>
> This commit introduces a binary search helper, memblock_bsearch_start(),
> to optimize finding candidate regions in memblock_add_range() and
> memblock_isolate_range(), aiming to reduce boot-time overhead during heav=
y
> memory fragmentation.
>
>> Under heavy memory fragmentation (such as KHO page preservation register=
ing
>> hundreds of thousands of disjoint folios), scanning from index 0 on ever=
y
>> insertion and isolation results in O(N^2) complexity, causing boot-time
>> memory retrieval to take several minutes (~268s for 393k pages).
>>
>> Using binary search reduces the worst-case complexity to O(N log N)
>> (and O(N) for sequential appends), cutting KHO memory retrieval time
>> from ~268s to ~50ms.
>
> [Severity: Medium]
> Is the claim of O(N log N) worst-case complexity mathematically accurate =
here?
>
> While the binary search reduces the time to locate the insertion index to
> O(log N), the regions are still stored in a contiguous array. If disjoint
> memory regions are inserted in an order that requires inserting into the
> middle of the array, the subsequent elements still need to be shifted.
>
> Looking at memblock_insert_region() which is called during insertion:
>
> static void __init_memblock memblock_insert_region(...)
> {
>         ...
>         memmove(rgn + 1, rgn, (type->cnt - idx) * sizeof(*rgn));
>         ...
> }
>
> Because this memory move operation guarantees the worst-case complexity o=
f a
> single insertion remains O(N), wouldn't inserting N disjoint regions in
> descending or scattered order still result in an O(N^2) worst-case time
> complexity overall?

Right. Here is the analysis below

KHO preserved regions is sorted in incremental order. So searching the cand=
idate
is O(1) and insertion cost is O(1). So for N insertion is O(N).

for random regions, worst case (invertedly sorted)
Total Cost:
     Sum(log(i) + i, i=3D0, i=3DN)
     OlogN! + O(N(N+1)/2) ~ O (N^2)

hence, sashiko is right, So how can we improve this:  we cannot.

Incoming regions can overlap and there can be already present
regions in memblock_reserved array that might overlap with incoming
regions. So, only possible solution is one-by-by insertion. So here,
finding the location for insertion using binary search is best we can
do with linear arrays.

As KHO is the only user of having large reserved regions which are
sorted, Patch fulfils its purpose. I will update the commit msg to
correctly populate the time complexities.

~Tarun

>
> The described KHO workload sequentially appends regions, which avoids the
> shifting overhead and achieves O(N) overall. Could the commit message be
> updated to clarify that this patch improves sequential insertion to O(N),
> but the worst-case for fragmented insertions remains O(N^2) due to the ar=
ray
> shifting?
>
> --=20
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260926092448.40=
90401-1-tarunsahu@google.com?part=3D2

