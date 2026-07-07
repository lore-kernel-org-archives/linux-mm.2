Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26DECC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 10:13:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 099E96B009D; Tue,  7 Jul 2026 06:13:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 022D46B009E; Tue,  7 Jul 2026 06:13:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2E5C6B00A1; Tue,  7 Jul 2026 06:13:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B0A486B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:13:51 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 285A2A035B
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 10:13:51 +0000 (UTC)
X-FDA: 84961569462.20.10899D0
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3DC05180009
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 10:13:49 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bKZnnUQ1;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of richardycc@google.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=richardycc@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783419229;
	b=ISIgaxOakgf3oErBzfqqXVW3OECFpWO+1Q2pAvy1NdkyFSjLsDwFafPdBRby32+B1Mzzm8
	fiLRoa+qyCyJXFnXeA9obQwd3IuxwWIutIUdru84j3KO9O/70DyEHcSrOlgZc/wh0UNpBs
	DIc8u1gbnzstmM7ADkzt5s1MAkvrtss=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bKZnnUQ1;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of richardycc@google.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=richardycc@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783419229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dIiBAR9I++5qifrUGbXaNfcl0FnWexBb9Aph8XOMqWQ=;
	b=pRCnX2vZdnjMSzQ/ijG/7aL/EV/UGa1lgIR1rn5MTn45pgzRMCx3JwaAM0C5NwjBd5Ko98
	Pbj3hnpYn4SPIKPehDVFBczpwKTSSmDJNVWRXlHVDLeDwd5eByy6AvnQkB7N0Tj3ihEjLB
	HXgp+9sffnD+kJeEypWTDd/54r/zEeg=
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5aeb6bdeaeaso4254e87.0
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 03:13:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783419228; cv=none;
        d=google.com; s=arc-20260327;
        b=dnOT7W3Um9QUXKRhrIYI3qT07ngzIlOqy9p5rZA5Etu6n2bcytb2d4kIET878l6sNx
         +Yo7naO+SUlFeOJg1fIHsNYSe6Z3tMsfSV/yPl/ER0za7JMRe25s/80yYnijvPlzD6dM
         45sz4C9aWRkisTZa/1rjw835QIq4TWrvDMVPUKuMCcowyQakLkahA1wtPb/fqGU55P4Z
         SBT6AJFjPMh26rslJC6gtVBNh4sq5+e12n0gDx674wneS5pZHXTBbmi2323cKMf7/EXB
         4nsmTYephHMhnhwS9pnXCA5WLxoz1K4+xND9ZU7/z7h7oUN4IbaryOBHXsKOxBHqBiKP
         x3dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dIiBAR9I++5qifrUGbXaNfcl0FnWexBb9Aph8XOMqWQ=;
        fh=UNkInL952gv0ag68gcabbIoms+K1MrKq/iC9Rmz/FC4=;
        b=AWpM9zKkhbBn967QYP8XCX6OIYPzNALwWGUETghfJ3gOByEDBpVgDRD3b+FziKK/yG
         TM1qKbrrgT34DBpAA79RrdOc01HQZZDcxZ0JMbut6FlQTtKNLuZ9xd1jajEz29MJVqYc
         cn+yPvZj8aT6pXhKXsrXNrbtpwz9uHBfMhATOdVrl5NoqDAmVo5LQSF86Q05SEOORV+H
         Bb0qgx8d5eUtiJAAScNR8N0F3zg5cCkFhrKvl2P+DPIeABLSk97lWxilmrHpgnuj00r+
         2/mNPXisg0qmQZ/KxVFiUvobrBjTr6j0MdSy8QSPqjeEIW6iSCpEg5dB0pyZCjFGwuyN
         1MAw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783419228; x=1784024028; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dIiBAR9I++5qifrUGbXaNfcl0FnWexBb9Aph8XOMqWQ=;
        b=bKZnnUQ1CWE+TMJDQE4+qjUw1Cx91DEwof+ef3hZ+dNVEZNLX9q3f6xBQNhCMAd05L
         cTmOJcQazsESGupGRS9e0G7EsW3vXY+jSeSw9hfYzP43E2f0m4o0LnHlC7wfbzV54qTZ
         wB23RmOHGGC/9PRDguPYn0X5ETHRGSDWtWqgqJtJ4PNA6tgNJbu0UD4KPkkXvFOcvFiz
         hR/sXBHr/jXq113ArXmG5WpOEYD1lXveKfg/ZI4UpRXNqq/9reel8LubXnrKSH8ZQrmU
         9HPsvWHvuFPx+cvVitRpWQUTkDKMS/Rsrsd8Wk1FvOA54EeRC+WKukYtNVmEOLVp6Uyq
         8sOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783419228; x=1784024028;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dIiBAR9I++5qifrUGbXaNfcl0FnWexBb9Aph8XOMqWQ=;
        b=tSrmH6UfkBzzY9L0CYfkzLsQMaktM9jo4uUDut4S+hhz9xUFCFSfdJChWCOnTfEaKd
         8HT9QZVMUVubkNqC5UDitYDq8CerwQq2yeCBiSTu4g5E+bfTGw47WtwH3FCWj5T4Q/sk
         5GEyFiE3hu4TCJE4oyZjnYwFWCZwM79owFSJSK+fWOlYu8RyObt9eZSdiKHia6XOcYGl
         6DYLhRhyfwAhlZB4QSwaXk4cn8QSmiALIAJNiEJZrAV2eSVUxKyilAQrTVU6F61cf0Ue
         pDsqhsd7C6Upd+Wwls4QY0kL7YEp6Z9pNCzc/JxbIIO/PKNPsPZIip5aPHhG0E+DFexY
         mINw==
X-Forwarded-Encrypted: i=1; AHgh+RrUnfSaqruaimtYZUrrnDjXhGcOvzXV2GP39UDgV/BS5v6OUWcsPudk6Z69i7JkaMUcC2cbuMfwcg==@kvack.org
X-Gm-Message-State: AOJu0YztVjVopXsQy9tjLjn1kTL2OBm85Dao6/lmkhLYWXXoquAafQqK
	3cIAnQP86ogjkhh/hztfQBN8kdhiU5UpoyyIAmHKVm1yITEeoBgbx2crnkpwEIOL0kqqQTav+oz
	W9u+TKMLgE7s2Dh1a1lNsU4V/ya3mhSOPM/RsU8g=
X-Gm-Gg: AfdE7ckoI/beEkOttzjYrcYe80jOlCbp2BEXNOFZXAt1/QRcjG8JzNncTU2bvpziTUZ
	jd6yniXhYj6L39Jwf2UaXX/gdktJkIoS9HSiYVgLweGj98XFPDEEM6eQAKCVHMR+zCIh4UI9AI9
	PqJj3i58i2zkfUrEyjW81flHdYobAWTuTzAdmWED8iKz9q+B6/Jvs5W0XVJIDRg3Wke/WYH3ma6
	V1AMY1lKLccUz7MgB5VOC7KKxgzaiu8xIS/lFCkfVUav/bfQ3UzULbtM27RsXacwre68bI=
X-Received: by 2002:a05:6512:23a9:b0:5ae:b99d:7df8 with SMTP id
 2adb3069b0e04-5b00ad1c9fbmr139776e87.9.1783419227276; Tue, 07 Jul 2026
 03:13:47 -0700 (PDT)
MIME-Version: 1.0
References: <20260706081218.3438762-1-richardycc@google.com> <20260706163833.19b6c869407d51ba8e278f56@linux-foundation.org>
In-Reply-To: <20260706163833.19b6c869407d51ba8e278f56@linux-foundation.org>
From: Richard Chang <richardycc@google.com>
Date: Tue, 7 Jul 2026 18:13:35 +0800
X-Gm-Features: AVVi8CdxK0WqWyeEcicOwyReY531WgJ6a57xkiWR0RxCmKdwJsyNFveihOPMgik
Message-ID: <CALC_0q9GKMzLPb5XSxE8BcasSsjJJBbu3-euToLDE3yszuotdw@mail.gmail.com>
Subject: Re: [PATCH] mm: vmscan: abort proactive reclaim early when freezing
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, "T . J . Mercier" <tjmercier@google.com>, 
	Martin Liu <liumartin@google.com>, Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3DC05180009
X-Rspam-User: 
X-Stat-Signature: 1m1dqitustejp7doutcp4sc63npxu8gr
X-Rspamd-Server: rspam03
X-HE-Tag: 1783419229-4389
X-HE-Meta: U2FsdGVkX1/yma1O+0+juGlJdh7RsBt3mASOC2CFisSlPLGWkBn5/uReznvn/ojqyftGB7UwQb1aeQ0UU1yV8S8eLm6dgz+Cw/UbjzE7y3b9nLJd4PfGYHK2v00oMZ/95IahZ4cXyudZO4bVAoN2AULacIQJnkJ1HSlRRFwohSOtLl7K61wGY2m9YWDQasf2aRRsXXvlosfdG+SZWxw2hFKydyIhbhWIcKBljtCySBB3ikbk1JTWEH+kkd91gDiwJFbMqSfQuTxeMulwlDVUhz3o/m5s4+n32TogTruxRFjCTLCoMDpOMUkg01gq8TdoLbmD7COA2P3bejIpuB+bA5+U/4yvnidYMZZWmOdA3xPcZfei4Iox7+ZAud/rTGjyBM4NcU0Z/U7lvRjR551uXuX4X4aXR8TtlSitRzFB4J6AtMR/vrvZXJ2t3fkdRN1IlRAPmzFTdS9f+pBDaiYDcEZot92MmKhtv0bLSidhNQ483rGFiJPBeE1jHgHNAikXjTjl+2oQRUUqHSOE+HFY631/5BWiMTO8jks/F+EN2LZOp4sVIUjqBG50raruw20v+D2yaWejjp7duQaCMakd2qHAE2byv0G7nbpe/L8RR3HnIj8AUiIVbrdsEalW42GkGAqywDSSLjB/m6Dn2iPd/g3XspJZ7tPTlXjgYKjvP12pl7xzfhzfY7bjg3Cj6Giirth5wIN/gvBcHh68TTLiSai1fzIiTqOfbHpKQqxoVOImG28lYfe3BkTWyUrw161MlYn3NAwoH5NJf1CIv0njzGMGpcgK5zOFotyMCjy4noEcaOkhmJCATaWCSOhJ92CPNjjAV+V5RAzkdCRMrN0MPduwoyaIhZUXMcu0VC+Zqr9lbQjz6uWuL+Cw/LMty0QMVsMV+k/aBN4qXnga+thlkqn3QPzdCrR974M6qSWZDu2zr4TKzr0pdpCnPfK/BZBkeSe9tWwK73b+X6J5Tke
 Bcw9k5m0
 ywGwOIwPqiibjrY4hYQ48WoqB9K8TXmHZdXICZBhAhSsyJ6hN9fzPpNtImbcx/twBPCBqIAdo0NEazbRyzjdSEffZbiTQAwf2SGpgmT+tyDmRc/VuRDgIdNfWWp+dUgdDKNSY3jqnscQXhMIdVALLPxOygCEe+1kmp0UsHQqeEkrOwR8ITlxWWl0mpqggraf3YcvQe2b2gSG6NCB0jXdYIDvAcoZyhBBxH1o5GuNOlqMvs8G8vSy1nHvLL5k2I85JeLhOEjfUbGxIrpy45Q4vicWpq7unxHgVZMLXPZr4HqRchnXIxxryVI0OVP86BHO+0Avl5gnjdb0C0qnZApkgtEcZkbfCy/H7uS8jElOoIQP55rffbA/j8ItxGb+Zva02Ri4h
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

I believe there are three ways to trigger proactive reclaim:
1. Cgroup Proactive Reclaim: memory_reclaim()  ->  user_proactive_reclaim()
2. Node Proactive Reclaim: reclaim_store()  ->  user_proactive_reclaim()
3. Debugfs lru_gen: lru_gen_seq_write() -> run_cmd()  ->  run_eviction()

Methods (1) and (2) are covered by this patch, while (3) already
includes a while (!signal_pending(current)) check in run_eviction().

Regarding the AI feedback on the Classic LRU path, that is a valid
point. Since we have only observed this issue with MGLRU, I suspect it
is because in Classic LRU, the scan target per iteration is strictly
bounded by get_scan_count(), which ensures it returns to the outer
loop (where signals are checked) much more frequently.

On Tue, Jul 7, 2026 at 7:38=E2=80=AFAM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
> On Mon,  6 Jul 2026 08:12:18 +0000 Richard Chang <richardycc@google.com> =
wrote:
>
> > Proactive reclaim (via memory.reclaim or node reclaim) checks for pendi=
ng
> > signals in its outer loop in user_proactive_reclaim(). However, the inn=
er
> > reclaim loops=E2=80=94scanning cgroups in shrink_many() and evicting fo=
lios in
> > try_to_shrink_lruvec() can run for a long time before returning to the
> > outer loop, especially on systems with many cgroups or large memory siz=
es.
> >
> > This latency in responding to signals can block the freezer (both cgrou=
p
> > freezer and system suspend), leading to freezer timeouts. This issue wa=
s
> > specifically observed on Android when attempting to freeze background
> > cgroups while proactive reclaim was active.
> >
> > Add a signal_pending() check to should_abort_scan() for proactive recla=
im
> > paths. Since should_abort_scan() is called within the inner scanning an=
d
> > eviction loops, this allows proactive reclaim to abort early and return=
 to
> > the outer loop, ensuring the task can enter the refrigerator in a timel=
y
> > manner.
> >
> > This check is limited to proactive reclaim (sc->proactive) to avoid
> > affecting reactive reclaim paths, and wrapped in unlikely() as it is a
> > slow path.
>
> There are a number of ways of getting into proactive reclaim.  Have you
> checked that all of them appropriately check and handle signal_pending()?
>
> AI review thinks that classic LRU might need the same fix:
>         https://sashiko.dev/#/patchset/20260706081218.3438762-1-richardyc=
c@google.com

