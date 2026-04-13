Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29DD6F34C5E
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 15:33:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E5936B0098; Mon, 13 Apr 2026 11:33:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BC726B0099; Mon, 13 Apr 2026 11:33:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D2486B009B; Mon, 13 Apr 2026 11:33:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5B7E06B0098
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:33:37 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 02F27A5427
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:33:36 +0000 (UTC)
X-FDA: 84653927274.22.09554DC
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf23.hostedemail.com (Postfix) with ESMTP id 159D7140003
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:33:34 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="NC6fK/Gp";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=mjguzik@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776094415; a=rsa-sha256;
	cv=none;
	b=cye45spBE+4AGZ8OKqZZ3eCc3BsE2xa9Lzv87cgIX5OGHhLCb+3frHUjWgimieOnoGRZaO
	Qium12VpFEgMAbh2rrhrOz8vaNy0Ik2nXhoEJg4mNK38os/+Qz7rPdD75ej84IZnLxwT39
	4gbQW7bhyG0DJc22cx3j7V+OqM4KjF0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="NC6fK/Gp";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=mjguzik@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776094415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9ShgF/BpsS7cAVnwA77xlwKbX+t0sp7V8xBcXlbEXIY=;
	b=5ThbUNnnJddi6iGIcY3tk03yWULR0hb0jb1RG3jmMRPYFn6FDtUvf5vRbeNMGpMVS/CSrg
	dUwPlfdqiAjKlaa7hMGNHnKGwrkNqb+5ElrIhpVAMMTk8DPkh+DotyYQrMYKtSatNFrOny
	L8sLtUFn6qClWZJxx/ZsuTRjClqalUo=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4852a9c6309so43633715e9.0
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 08:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776094414; x=1776699214; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9ShgF/BpsS7cAVnwA77xlwKbX+t0sp7V8xBcXlbEXIY=;
        b=NC6fK/GpW5LcTW7wuO7UE/xT3OZ9590ZZ+COURctK/Xc6ZAgBhp/RQt/IXjgNhcRVN
         EATDj250Z1EAdLwdatz/UOiAGKelwmKzO52PbWp+thKQuG4GK8/fEmezYsT9yl//jVvL
         y24HBUx61fhI17Ie360IoBWJoP47q6IcGfzEX+XiRLe0aeGrOHs4K+9CHQa11V27vXuS
         XQ2yRZhCMj5LegNf0fBLihQ66fHAQzdgcuSunZ0HOdF+fPV1pZ+6GLlwYoedKlUz02sR
         fJPTqXj9onFGIGBSgoLAExhO0uv0F08K+4NlC9ZtA9oztcX+L6HNZkETnQOxZWnpovQ8
         lxDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776094414; x=1776699214;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9ShgF/BpsS7cAVnwA77xlwKbX+t0sp7V8xBcXlbEXIY=;
        b=dmVk87RgcLpGt1Fnm7IqCLtHctbavNoNKNLsEGSLWuTBCwiXQb9MbYiOax1o6c111e
         3sBr0fQFuKv041Lec3huIz1PvaqZQr6xDtZoys22fPU4YLOXbju2FePFltxM04LjXdXK
         CAk/LKC96fYPMTwr4D/7vweF5W8dXdf9lbRRBC00hKITxmQ9hT35uV1jdSt9NK+4xl9Q
         2/CjH1oAhqWzGpcv33O38wcWOIGCpFmnLM3tG022Ea2v2uBkcRSc2WmliYHup8z4IOM3
         BS64tWtk9uJPpjoiikLc2kF1jxshgtopMYIDRqNi0xkr6AwgcnxBUJxjg2ufOVfHnz1n
         5EzQ==
X-Forwarded-Encrypted: i=1; AFNElJ/44jvL5DD2NKuTKX5hS3BxyIpGslcUfRBQSfMAHDUiBnujjOqY/hxaXSlZF3N6LOP2LkSWF9mDjw==@kvack.org
X-Gm-Message-State: AOJu0YzL1YWhAsJiaWUFW6cyh2O/czn94vCo9gE4jHJ6AwPgPKOvJ8kb
	r9k2db1wqYk5u3ASXNY1w7nKS4BJ/28MWZXnA6NT0CZUFXPNNmeUaozz
X-Gm-Gg: AeBDieuT3oIUZrtyRT5LTQ3vN5BKMfsoVXfVIv+nbIGxX9tyc2Gq2WMgE3eoBqB9Tr7
	uoGxd2NdhEoVctf+o9d4sp/aAAjD1YPzex28S8gEIoX7p4PmzOstduLTI6ZVHWfDJHquUgW0TYG
	SI+KDHzrPzHuDFaTYyqlDHU2SCJW5TUnP9/02jT0ItOyL72VsTyDODpUbuCdlo+cVU6vXxGasCK
	k3o104Ofit+4dQ1EPAYvZkkDFgn+y+JzvTjIVU5Pv4ISdOV+T+v+w6gkHDT/BkQ6qUGKo4kf17N
	CuUrNrViGm41QKsKwVnLMAGC/nbygZGk2EBN7MRZVesVK+ppB4j2OPsmACjOkJJd6XtBcHFXtGl
	RMa11v55x3j/GuZFqaFNQlnz7YI2DT2Wcql3nVdu/obhlY1VjYwg7v7Kg2Y7PfXSaU/NOLNctZu
	KHAOAfcyMoW0oj3V0tbsEP47wZPbZxIpAgRNa2Nzhi/LX3WvBkXvTZeuMxL18wSu78HBRQCzA=
X-Received: by 2002:a05:600c:314b:b0:488:b241:2c5f with SMTP id 5b1f17b1804b1-488d687c076mr159606435e9.26.1776094413364;
        Mon, 13 Apr 2026 08:33:33 -0700 (PDT)
Received: from f (cst-prg-89-171.cust.vodafone.cz. [46.135.89.171])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488d684406bsm94248555e9.24.2026.04.13.08.33.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 08:33:31 -0700 (PDT)
Date: Mon, 13 Apr 2026 17:33:21 +0200
From: Mateusz Guzik <mjguzik@gmail.com>
To: Huang Shijie <huangsj@hygon.cn>
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org, muchun.song@linux.dev, 
	osalvador@suse.de, linux-trace-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-parisc@vger.kernel.org, nvdimm@lists.linux.dev, 
	zhongyuan@hygon.cn, fangbaoshun@hygon.cn, yingzhiwei@hygon.cn
Subject: Re: [PATCH 0/3] mm: split the file's i_mmap tree for NUMA
Message-ID: <76pfiwabdgsej6q2yxfh3efuqvsyg7mt7rvl5itzzjyhdrto5r@53viaxsackzv>
References: <20260413062042.804-1-huangsj@hygon.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260413062042.804-1-huangsj@hygon.cn>
X-Stat-Signature: pq99ti4j7jb5mihgespxn5ufxajj57kj
X-Rspamd-Queue-Id: 159D7140003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1776094414-189811
X-HE-Meta: U2FsdGVkX19euDmQho2Nbj9CEoJcCKu2eFb58GKot8ftnsNKZmh/w+7c0tRKckh7Zf78jJLlVP20M5n2Hsbv7QMgdUeEIikN3KD+Hd+aAmYqqcPz7OavMxmiDNVg1VktcP/dgQOrT/yD3S+IqSbQpVLhnjQsSfNu1gkzGTN5ge1Ot18x2F4Mf8MSX8+YDEAp7fYwGsN7So3YhjcPABqyvcAWWLNn2uslCMMloNpzlLizNIXLOCbLka6WOZ7zFe23L3noBYpY2iCfchCysZdAlM790wCYbLuYtuXV15Z+pp19w6d7McGE1nvYoh3+dI+1J503UCAwOGAv9zekbvZtO+7xaGxBmuYT4+cBq9/LZ2QPrfJSdL/N7aVfkmLoqlahPXbRig0sMWv/79aL/ZGazvAZUIc7RkaLfdQz8kbwAJuIb3QHI9pZJdRm5xdtPYeCfQGUvgKVzB0PiHNtWRX06m/5LstkEUxP9ByTjGaBK+D/cWhNiq+7MhsMIFFLqK68U5k+tHsMFnwnUQGY20iI1Huk7UaseFzobde6niPIm/GCYGuGqU7nInoNmJ1Q5rBoRCEAYnUtsjW8YrGaThTCgNaLnMHlC84L2YLxPWwpYZrQsJlWXI6UaPGqo86KcqwhF/iBWKnCd+jYMwnw4YrKwSMaEhJrghZ51TIDeUB5/12Y8z9iasROzwCys4Hd5IX7lZcg/+by++c9CqM9xLuXcmIqIEuzpsoGgSrlLOGD0o+8qxIYM54PsOfMlqJANnGIgU59M2HNWqih4SWSzL6DpRTPlLvt4BVdEXbJz2yO8LApCNq2UHHeJcWazwXgNLdlNHUD/kScXdai8WzgfHlcbLq6D6dqQrEX04SKuXtdBSctH+5InmQ6JbTsf4jUrfTCrHJVLevMuexuYVxbc67dUu5KWRyg52rcbpTxwpHJA2V7P/cBYBp+VN7CLWqVfEYLI+HCYHt95s3215vG8mU
 oqfdvfHV
 bXTrrTsAuMebrNU7qK9F0E/Bd4RkeyymhwBeuQo3+bCryfKlCr7OKqE+SChOlR/+OP/0NaEW7d5CuvJbKypjv3BppHzMhwEVceH6TyoxZ0FAaz70d8crH2rAG1VgnsleLMhGplkq+GkplFaXGl7Ll+F/7vwnCVMAe8J2qv1kmnbTt2C//gQ5PwjxUkiQGn+aJwLjdmAxmfZFh2tdzHBqz/JwXIoXemYLFtvM0OGm4+J4lIWoOGDbYlQK+5T5ZirtvAyTg73iGMEu81llYK/gbF5a72Lvz44u1bJym8MXYQygjRY5BG6F0/FBHHp0XABtd+hqSQJIohPLlDHHtzSAG375/xM8F2oXpWt2B1+OlQmpslj984yp4UmuS5LZ3Zv+RF+DDtUJ2E+jnaWZkI217ZM/Q/8EvwwQEXpnmbVMM1hGY/5N8aM34a69+BpTlQuqYlas6YUGOdt7e54w//bp2X2bfuA1wFkyb4G5O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 02:20:39PM +0800, Huang Shijie wrote:
>   In NUMA, there are maybe many NUMA nodes and many CPUs.
> For example, a Hygon's server has 12 NUMA nodes, and 384 CPUs.
> In the UnixBench tests, there is a test "execl" which tests
> the execve system call.
> 
>   When we test our server with "./Run -c 384 execl",
> the test result is not good enough. The i_mmap locks contended heavily on
> "libc.so" and "ld.so". For example, the i_mmap tree for "libc.so" can have 
> over 6000 VMAs, all the VMAs can be in different NUMA mode.
> The insert/remove operations do not run quickly enough.
> 
> patch 1 & patch 2 are try to hide the direct access of i_mmap.
> patch 3 splits the i_mmap into sibling trees, and we can get better 
> performance with this patch set:
>     we can get 77% performance improvement(10 times average)
> 

To my reading you kept the lock as-is and only distributed the protected
state.

While I don't doubt the improvement, I'm confident should you take a
look at the profile you are going to find this still does not scale with
rwsem being one of the problems (there are other global locks, some of
which have experimental patches for).

Apart from that this does nothing to help high core systems which are
all one node, which imo puts another question mark on this specific
proposal.

Of course one may question whether a RB tree is the right choice here,
it may be the lock-protected cost can go way down with merely a better
data structure.

Regardless of that, for actual scalability, there will be no way around
decentralazing locking around this and partitioning per some core count
(not just by numa awareness).

Decentralizing locking is definitely possible, but I have not looked
into specifics of how problematic it is. Best case scenario it will
merely with separate locks. Worst case scenario something needs a fully
stabilized state for traversal, in that case another rw lock can be
slapped around this, creating locking order read lock -> per-subset
write lock -- this will suffer scalability due to the read locking, but
it will still scale drastically better as apart from that there will be
no serialization. In this setting the problematic consumer will write
lock the new thing to stabilize the state.

So my non-maintainer opinion is that the patchset is not worth it as it
fails to address anything for significantly more common and already
affected setups.

Have you looked into splitting the lock?

