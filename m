Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F473C88E53
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 09:01:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 035626B0088; Sat, 12 Sep 2026 05:01:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F28D26B008C; Sat, 12 Sep 2026 05:01:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E17036B0092; Sat, 12 Sep 2026 05:01:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AFBDC6B0088
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 05:01:23 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9BC9716039B
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 09:01:22 +0000 (UTC)
X-FDA: 85204516404.03.1DB5742
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf05.hostedemail.com (Postfix) with ESMTP id AEC62100003
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 09:01:20 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mBs6geZL;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789203680;
	b=TlOnRam1uWnDeN1L0h8CHP23Gjj0GxEeGp3dKiu+uv4rBYnEgF3A3YZgz6AYzaGubztp1Y
	0fO1m/l5ehcx6cDw1U41xfya5ZTKvXabdUN3n+9oy6FnzGeU1qmMEj0Qkyx6FmzHizzpoK
	itXxVU4+EyhKInFnJo78JatRLGqyp08=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mBs6geZL;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789203680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Emo/VHVaZMhmQcduzPD7yxfTUOKr9C1DEbaLmLBuIaI=;
	b=r3/N24fQ7HAc9jKjJXCHUW+YFG5FF86JbSS5/RSySbeNhvqz+n8mbCNw7kFq9i1dedZkGW
	TxMTnF30R25Hg/DSwbzc4neAxBn7OF0IsuTOpD7iME6Bjs2on0oQCrAKDjtVjLttg4uh1k
	3JpbvSGWcUWMfvYyUIiK+wNMHuO2xig=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c25b661d37dso267957266b.0
        for <linux-mm@kvack.org>; Sat, 12 Sep 2026 02:01:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789203679; cv=none;
        d=google.com; s=arc-20260327;
        b=Lh54j3RDXwPM/USB9Egli/J9B988gcA1Y9QgJne9/jRl6FHkkNPLCd1w/CidBYQuCH
         29srAq/fPGNkTAbZmMx+gE8J8Ak5nEOzf0y7ABJGgffHYTCaZWzYhD6dlLFopgSKx0Ve
         uaD8KwuDTPqYosZNomqUu/sAVulkez+9woKsq2QkwGMR4bqESsgqsA34uviuYJIQxQfn
         /rV2l6vyaEXaMwZ0cc86JJf8CxdVRSgNuQ9BmQ17eWQ24mz/6vlzWxgNJIoZh9RFZ/mn
         0VUGKkZalpBkbqfyDAkRxeuIIrANua7XzTTe3m5o2HHsR4EWQIhNd28A/fYEr6wJfkO7
         jv/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Emo/VHVaZMhmQcduzPD7yxfTUOKr9C1DEbaLmLBuIaI=;
        fh=/ZDGEJLl6MqHoblMh9Tha+YcvYTJrZAFBo0Qflcm/JA=;
        b=VzV4gYVB9jm7vcAvS1ufROmtbzmVF1z0TQ3ybFP0saQhqSxlBbYi2dZ7L18z3W8bYW
         rJs9qRVfXZTCQ0/FSWZwxbd5vzrZ4NRphrf0izYCx+m8KR1C35QhgmT5NPnwKlkLCbVK
         T+rw7UTrWJK9QPUIjXXwwrrLSnneYxCFPgLUk7ndzSxekGqOhKz/+pO0R+Y3qdd74Vn8
         ravbStguU80HSIMYjHtZdExojTO0BRS4rvWG3kWCoTUFdjJwgjq0JvXuHk2zonizzcl+
         UtQvICxC06HQeXsnNRgZYMUWP838C8aaAv763ieG4jkL6s/jbizstET1shb8fRqqsqPt
         3ofw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789203679; x=1789808479; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Emo/VHVaZMhmQcduzPD7yxfTUOKr9C1DEbaLmLBuIaI=;
        b=mBs6geZLfUUKKKveX+R6fH0jCkhekGbzfN3gjCAbJ7nPvfrD4GzcliXWfsSPUkEWWx
         M16eScZwx/zqr8P2W5767nbY4YHMfW5LWV9Z4G/COkNOjM1Kh15lAGxplkEyDXhTosCC
         TFTi4ML5/KsPsfcoDZwu+oUAOyIMY9HRLKWIjnmtGb2PoiJqSAU1xqisDCcvx+D3ANAY
         gqmoHcW9cE5NkNVFy9P+bP5jiGjWs1rXJnMa9RARibsAn+wfgarEz9xlpChotHMs3tHJ
         SAy5rzRNFNa3cU+Jj696vGxmVn6b8N3feTsH1qH9Zdf33sDSZy7bxeRAQZVtPxIQQ+Lo
         /LVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789203679; x=1789808479;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Emo/VHVaZMhmQcduzPD7yxfTUOKr9C1DEbaLmLBuIaI=;
        b=jYJlR6HK4Td6eBMlc+rxxvXyGVSFjy1e6OfU6GQ4lvkw3/5jisyhu2i1wuZfL7Bd/V
         oOQXA0pHLdu0v1JBNtMPAnjt4ftLOWHSnjkaP8D4QGm180s02iERNsBV9pFLpyd+xChN
         WnNN0KCEZm+UUd6DCU/U3hDaZZten/fiGYxZ2t3ZKDnZzv03rLvsOGxseHEDD4KtLzba
         P56Uenl9rUbQTiMiFLox/NADbTTqJWhK/xl9mkzyUiP0JuFn3PLBXI+tVgOKXEdwq2hF
         zuc09JPs/dUrwq+tH3evgW/abp2QSnL9CP3VYKMR+NYAxqtvhFcDo2gaN3Y4/w9hmaU7
         RUGQ==
X-Forwarded-Encrypted: i=1; AKwUvBy88eAJ6x1Y42NO6kve6MdtmPmvYNYL9HJZ2ZtU8Bgyv86GIsGF0E6fD35qd1SU7huGa+qm1L/EOQ==@kvack.org
X-Gm-Message-State: AFuF++npwD5SriZ7UvaEr4lsbdvN92PZMPoh1vJwfRj7DOio/L5brH/p
	cF3ZP1L5ftognImuk4WcdS+fZiOydhfkGRweP9fXjU5kVM2vyxqDjRW9qW37n5r3gsa2upUzczs
	gLqqbf58JmycovN8jQpHzitUdsBtjT3Y=
X-Gm-Gg: AYBFou3hq+bDwsvfYvfkYDxzwfTErc+vJQMpdAfve+ZNsnxDFy+oPZLfCBgjQMRPUrP
	3Yv4PTvQVVutAUo5CSmER2VHP51r6JP7ZDLxb1nFU2u9MWfE28C0CiRAelEzrbWvRIg9xcBTUeo
	/+s7U5MNHLK4otjHAOBCyXY8VpqH2rFxVmcfw98xO5rtuC4EoMnx/b8AFVSKHJ7RZnqG7ApYmsD
	inW34eAPc6MCH0k0hBa19diQ6VLltlTiS1U0yibUjPp7or/g0ZQhA5w9X2IBeCkztWlJBY8NP4Y
	IRUvi7SaIdv6j72189KmAdOQHb9WCuJT6rB2gEur8Nh/fDqpjXVpNRTXt5J5Upv5WEoAx/UeARE
	9OsJKFFadQaya
X-Received: by 2002:a17:907:3f88:b0:c25:9102:ed with SMTP id
 a640c23a62f3a-c29665ff973mr349742666b.5.1789203678979; Sat, 12 Sep 2026
 02:01:18 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <CAMgjq7AHRzBsbmGOx0s=TQFBwcn=DEU1naR443sO6x+pJd6hAg@mail.gmail.com>
 <aqBT_35E-eSoN_zj@cmpxchg.org> <CAKEwX=N4aaq_oD2agTUNrUNXhaYGeQ9vxu+dywFvEFgWFi4uQg@mail.gmail.com>
In-Reply-To: <CAKEwX=N4aaq_oD2agTUNrUNXhaYGeQ9vxu+dywFvEFgWFi4uQg@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 12 Sep 2026 17:00:42 +0800
X-Gm-Features: AcwNN1VTyrOeQmFG_efe2_ca4qa89c2Nr9YsCc4NghZiW0bnHUOivuHs2n-bDVs
Message-ID: <CAMgjq7AfNBUpMamcv29JFzpX=7ApNYVLtPjWT4Sm8cXjSLYL9g@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Nhat Pham <nphamcs@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Chris Li <chrisl@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AEC62100003
X-Stat-Signature: imuc3c1duh77ksjoef7t79uzc5zmpo41
X-Rspam-User: 
X-HE-Tag: 1789203680-543410
X-HE-Meta: U2FsdGVkX1/retcTW6AYQZV4oJQp7WDNUIWIfYEugIK9/Eue81DaXedn8/hquyXy7J9ywPYMVYklcN9Ci0MKxcnoBqEqn6hbCcsQEKhRU6eJGJ1EqWH9aQY7qQR8aoItp4H1XWcUux+zlLrwT0VuMTyTB1KS6dKMfDY4hdrQi5zu1RTPInNPMPUWY62YMQdOdBQIzfeP+aZC0odtQh90nRQec+276gRVeR40aTQrhItPn7Zt2kughQyLkzsQX7zSo08pLmYNqKb5Tdt7lFvOZzMfRJvB2QTUABbQL6uxSreMEQxQlRlTozkdvsEJXlrt2OJMBbh/pzIobdXEmvnaApb8J7M0B+xHHoNrn2owFc7ZPAryF24OE6Qatab51D5EOZSqmM/1irvRVHY3e6hIh5PyHwyEwlssZbKa8mZGEcMg57TifI1gi9Bu2fQ8MVRKWTibzz1KgaEpqGPig7VR80N0wHEVpUnQ46aUpCx0yPnNczfk4wEwTNlCir0jzNy9nxgJHbPf4kVxF2UtOZkdTDaosejxZ0r1ZvS9O/feLiKidA51ktVDH0jLlFC/0DcZ0OtaSIvXe0+OMTVYn/93UBXhBL7PwLMTfHqm41tsKhEgiAU3TmbaEdOMcht3xIVZyc05GLfop4jki+IbMw1yqbjL3FOgzfnVa4UJxN/6iQKqmlysRIYbIGUJEQ3CQhXy5x43jWQ4pvwlaVPXF6UlhA/fj9y3dA1WJO1Ano9vAbtwcI5cnXGlITtus5GK+tdsIpkJvt5/0O+i9YnxbaKSzhVnQCzB9V36u8Amkmgx8mdK0JI6huITT3kHgCBRe1morAE4TeEHqJ+sCvoSICuRYQRG89/Zx0dn9jHs1yfzrwlOSxBF+nvfJaU5uz5ygoZzaHjruQgIVAp4jT2LyRuX36A5tUZO0U1MrPXZKdCW234Gr0HHmQF/KUNZygN4SR5wnXY/NRHhWLZB4yNXfmn
 Dui7dpmq
 aQCUGex1yNf6BUqUPtMhfU0H5xohpSbaAUp6LFT/A5kECL+QjyaeNNNKvEFWH9BquloucvD3yF024g/gyfE8uUOKtJNvaFp0pj8jWens5WSLzbFXCFhh58qfUgFzOIQMstnwc8foNEr4neRtSq1goch3+GCzqRfqpaa3GL3D3ojvHpIdgBp8C0Y7FBiB3UFJiY1dbt0mJ4aWFeokFssGPLpOvN+56CPwM9FOfRvN6+0U2qjzD67eVS97tpD9h9ADaYtkBlcAIubKwccgxJdRM4dWjmckxUFeSUX57yZk2cAKBpHclawsF62fDSJ9DpEsaHAJZ8m+cbPo9UozriWt64uhoAOtecelhSmxszD+uJ6b0cUf720xmOdCj6uttQFx4YJkxaqY0xs4ENFFqhpuBl2jr6+0IXO7nRO/+L7J9gOzaVRa45mBiULew+hYmbZZnX8mPsYHj7h6WSq0KyZEApEQXu7ZdVZTFynLmz6H6tgGjqXRPFw83F3tmpEtpZUUP/yHKF8o5RXw6M+i9zsVputJDvbx/DFwJrelOdgSrTUb73rSA2MivHbORnten6Ra43MUC6sAtW1kaZ5gPzqlnNzoBprQqTYbq9fKz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 12:42=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrot=
e:
>
> On Tue, Sep 8, 2026 at 11:30=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.o=
rg> wrote:
> >
> > On Mon, Sep 07, 2026 at 01:51:31PM +0800, Kairui Song wrote:
> > > Where I've ended up is that unbounded growth is a real concern. On a
> > > host with no memcg limit (root cgroup, and most desktop and embedded
> > > setups), an unlimited pool means usage can keep growing, with no
> > > admin visible ceiling at all. I'm not attached to xswap's percent of =
RAM
> > > knob specifically, but I do think some kind of bound makes sense.
> >
> > Swap space is just process virtual address space, no?
> >
> > Swap entries already have one or more page table entries pointing to
> > them, which in turn are managed by trees of vm_area_structs. That
> > means rlimits apply, overcommit protection applies, and OOM killer
> > attribution works as well (oom_badness()).
>
> I tested this theory. I spinned up a process, and let it spam 0-filled
> memory + swap these pages out continually.
>
> As you predicted, oom-killer picked it up eventually. The host was
> (and is) intact otherwise :)

Good to know the kill path works. But I think the accounting side cuts the
other way? Won't that conversely underestimate the host's ability to
handle memory alloc? Not to mention a lot of application are
swap  space aware, some built in logics like e.g. with vm_enough_memory:

On a 1G machine with vswap enabled:
[    0.241906] vswap: created virtual swap device (2199023255040 pages)

a 2G sparse anonymous allocation fails:
[   46.044002] __vm_enough_memory: pid: 1129, comm: search_agent,
bytes: 2147483648 not enough memory for the allocation.

The default "Heuristic overcommit handling" policy is meant to handle
seriously wild allocation (as documented, and it's named as
OVERCOMMIT_GUESS).
totalram_pages() + total_swap_pages

Is the limit, the heuristic exists only to make "a seriously wild
allocation fail" (as documented). But on a vswap-only machine,
reasonable allocations fail. Common swap devices, zram, or xswap don't
have this problem. One could argue that the size there is just an
optimistic guess, the compression ratio is not controllable. But that
heuristic is a guess by design, and a plausible number serves it fine.
"Unlimited" seems break that.

One can switch to strict overcommit limit, but that is limited by a
user specified ratio or number; again, we need a concrete number. A
fuzzy "unlimited" seems odd.

