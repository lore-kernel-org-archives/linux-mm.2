Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F70CC9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 16:20:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E7CA6B008C; Thu, 24 Sep 2026 12:20:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BF506B0092; Thu, 24 Sep 2026 12:20:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0ADBB6B0093; Thu, 24 Sep 2026 12:20:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D63E76B008C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 12:20:37 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 601E4C0416
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 16:20:37 +0000 (UTC)
X-FDA: 85249168914.21.564CE79
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3B74D8000B
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 16:20:35 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mnC9YYtt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790266835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y4C/eEY5hpNw6IZ6GmmYyn13brOMotH1yARGM3FuI/E=;
	b=71dO2St6VOWSJ1b5LXLFP0hyBeaIH8MkGvsIZVvtNwPGEObZmuidkUgrAQizEgik6UVQE+
	Wen0UsWHxGtR4PbWsziemVa+OyTeXvqipasVjjzK7Fmk9Hpkwgea1q/jmOuoDffUnOi909
	L86zimrZW420N+hHdH6rvlOYNcJ/t2I=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mnC9YYtt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790266835;
	b=2Hdg72iLwumdjJE9HdcpTTBJvYbYglkyaWgkUtnRngb6zlM0LV22BQHH9d1v6jjctiysx6
	qfU8fq9dP2jHXiM0xCxklUJoT/YZSkE1TuowuuFBwlEjZjZL5KPk3z1nFDNmqpHwWlv2Jw
	6H+oEY4d7zy01SVURFec3Yi5SWwjRyo=
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-485984ebf5cso745f8f.0
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 09:20:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790266834; cv=none;
        d=google.com; s=arc-20260327;
        b=V7ri+JNwQQKSW6IG7vaj4ieSMcBLM5nqTNU2NX6g7f55VMJg4r6w0NJWmg0HoCH8qN
         DOsIIrY+PmbVDJ7++X8SJhj3iFH0JaeonHdUhWWCJLADJJftp/TQoIwDl6CE71WeT+FK
         ZpYE9YVxGmB70aUYzLMsMh+X1YxFjH49b0v3emQcDolgf8ZCIaHdhB015k4zMCUWeX6z
         1HeofoLUV7JEqmgzTfgYt8Dc7qX7vHJ7+CJM00/q5M90Gc7AI6jdrYbIbHU8UBVB6s6Y
         UmtgJyaxu3yLE7R9kUAz2ucf8FByLNYWuqrDjfIscroPmzFr58FY9MItDUyWUiymhJmo
         Mddg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Y4C/eEY5hpNw6IZ6GmmYyn13brOMotH1yARGM3FuI/E=;
        fh=/s8+RNf2U57stN4GBlZiI1O3an/SijF59UnxwfS434s=;
        b=SDw2xw8jiCmb3cJqBlqPN42m4E/05gy1Un8cYhJM/zaH5al63yzlfij68tumOyOt5r
         fjEfVeo8dNFUIT+BBbLlZM5pTcDCgsVOJf4g5YQoIdXGs75MDtdL5pXWpjuNETkGS8LH
         n/B1usYpgaYvC6gBc66tt9UWO/uV9N17Q9p0euIo61qXZ5NzOKgOqcpWG8OfCvsXiaWl
         ou64KILlhRCl4YQHQxD6rL9ua6qc6B0W/3/emQdmz3f7GmYL6U5jdLeisEXOutuGI12y
         wZu/xhT47JfHcyncGhqjXPcPD3fFu4AqFkBgYTf53+abrzrzZTMoA+y62Ln0sAlfpUKx
         7iuw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790266834; x=1790871634; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Y4C/eEY5hpNw6IZ6GmmYyn13brOMotH1yARGM3FuI/E=;
        b=mnC9YYttOIK1LsW4zDFnUTW4tm/pXzdvOAou1NTQOJOucAqKNbVuM+Tvg6BvSMyKTg
         NG+4x8RCNtTpu+5XhF4kB8oVJTWKiO+rUlr5YRRuPbr50wAK0oSBtp4MeGH7N6eJqz/a
         IkVO+Eh7EhJGmctqQeYow0U2bpOw0X0jHs5YZuy0IpwHtB2gdpMolVNdnm/FCNlsqt6B
         OQ6aAvOUwgj9sM1sDXEeAojMeNNIKHsr3JuK8DN6ym0fYNZUCV/39QsFFmhYyl4Z63tX
         0dsr/jerNahSkYPTjPX+H1scmwiJytlZkgGLxSiJxz7RMXVl159nNzZGVyQZCgS3ZJe4
         gHhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790266834; x=1790871634;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Y4C/eEY5hpNw6IZ6GmmYyn13brOMotH1yARGM3FuI/E=;
        b=c0vRS2d/PKBjGEcUwtpbaqdL5JYM5rOyf4qJkzYmKMSmVzXCum82WB1Q2rb0jvsET+
         yD+lX70gG3Byc40XUl5gy9aGvjAuBUw4QFV0bxQ2UrZHbXWZFwEJMkcBMx1QgJ4jaz4b
         U7362eU4/7zF7TOqnW9XAPn0V14WEonw/zNmAhEQHaFPcelHCgzb5mQx8kWxp00/Z4QP
         kin3hZ2YA5Z+Wlwj6UD8G0Uz63Bum2Vw2qA83Dk6UE/jXUCZ6KuFWlmRqC3jP4OTlEBe
         1LQhgW0YA6pG0HNMr3LG06I7+aGM6k3BT/s+DFIC9dVKFoUuVM7qoJ9GObitkDaaddmx
         6sQw==
X-Forwarded-Encrypted: i=1; AKwUvBzpBC18xk+ctw2qGmvCkfeyfILnotyDdf0PERYSSxS21yGS8LEZvm6PAXct2NZZxPjt3LvbKFzVhQ==@kvack.org
X-Gm-Message-State: AFuF++kI9d2A61Re1r8/+lbSIEKBWYEBZqWnhxsOyA6PzI3ckAjdVCXQ
	6gMkp96yAYFNKmUDhmKNei3DMyLCg7ByrZ+LHL7u1GpjGVojvSazHsQWMzvuYSjhFuz1aNJ8PEW
	ks3kTDOitsQ5+uE6ijOvY8ynKGzZAktU=
X-Gm-Gg: AYBFou10J1cqfv1hiC+cWfhqjuqdTnhn8sSEzRhMk4Q2t2n0vLTgp9rFkBAotj7/TdO
	ofXqQS1/h8HDMW/9YzlnwtJzHdx41RWo1ZTIDMYXJoPwI7kBkNCJ63btRpbob0nXm7lXQybAD69
	0sJB82OADaeHLsUwnKuMkq1IotXVMCpWpIBcyw1qBDJqC4MVSNqwUJEDLj+foqApkemNmMApGR3
	AkY4Kbgtb0Sr2EP8ccllUM6b14s3hKxnF02mYq90xSl4uHXybWZAaSWVajwNQ2BpM3KrvfYuAL/
	rlI8XTUKA+XYzZCrTITOprtOh1iaS+/iuW8JgFFnC0oVovyU8Il20GpKZoJEdT2PVOtQjdNxDGZ
	ox07W2FKpeg==
X-Received: by 2002:a05:6000:26cd:b0:486:fe8d:298e with SMTP id
 ffacd0b85a97d-48872ad7729mr4973566f8f.53.1790266833368; Thu, 24 Sep 2026
 09:20:33 -0700 (PDT)
MIME-Version: 1.0
References: <20260918180241.3424851-1-nphamcs@gmail.com> <20260918180241.3424851-2-nphamcs@gmail.com>
 <CACePvbVaDNspMDSw_qAcapKAzXj3JGV-KMYmow7aePa0POHpSg@mail.gmail.com>
In-Reply-To: <CACePvbVaDNspMDSw_qAcapKAzXj3JGV-KMYmow7aePa0POHpSg@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 24 Sep 2026 09:20:22 -0700
X-Gm-Features: AclHuK-lGJJsKLxr6Qb-y2IvmlUpoUB7yhNg4AVw4NM-rENBoqlMKdnr9zU6afg
Message-ID: <CAKEwX=OP3Gb9sVOvch+p4j7quzgy-rUY=UTZau5ztMj7heJJoA@mail.gmail.com>
Subject: Re: [PATCH v5 01/11] mm, swap: add virtual swap device infrastructure
To: Chris Li <chrisl@kernel.org>
Cc: akpm@linux-foundation.org, kasong@tencent.com, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	yosry@kernel.org, david@kernel.org, muchun.song@linux.dev, 
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org, 
	youngjun.park@lge.com, chengming.zhou@linux.dev, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, riel@surriel.com, gourry@gourry.net, 
	haowenchao22@gmail.com, corbet@lwn.net, hughd@google.com, 
	baolin.wang@linux.alibaba.com, tj@kernel.org, mkoutny@suse.com, 
	skhan@linuxfoundation.org, kunwu.chan@linux.dev, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ngfshp7kr681mh1hhfffqbj8odwjpxa9
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3B74D8000B
X-HE-Tag: 1790266835-366152
X-HE-Meta: U2FsdGVkX1/SukSG8ILKegI4/ThPDNdjspIYsM59QH3VoLE7LEOy2UdlO4maXqFs2tIW3R7JjnyZkO5j6T0EXCAKpWb72ZPEdE+kPiQQaSiDS/e5TDICFvIccstFkx8eR9euFSyLXT0GMS9ASRoCvpATkP0lF2ohaSAAHDU7ughwhK2qhjxAteBDd1T4BkugvvOBVTBZDD2Hjb8aQF/2GX69GbYVw9FwuBuJgxJWCyvG1uHBLtOo2boEX5XiXZ0f8fTJykOc7f38VzOPMwrAmEUG53sFZq+HuybOmHoQq1Isu3gCnaTcgIhBhItlk6KTVD2mtYCpS4iocoA0a2Fe9elf7a66N3dnzK1iISTWlDI1KtEqTcy8K5jroH4IlcxVe8lMB7+RkptHqSjpA1mK/ME6cXh9aAWzvxCwXKr5bC8723PjEGc7PSxidIHF/lEkIPbQonQ/e2kpYjQcV3qi6JGidgk4c1joas8JOjzLqTUWVw5KoOzUryzWRTqEqNxOmOfh0juVTWKDBQhlzCDq7cgEHXlVikFD56FICBr6jZfdmfFumz77e//TJgZT7q56bP1cHpoGHFaoYB32PuIzj2FgM27JlTjdFT3sl9PKOyAtAkBz4oVY7wiun/lms5lAOSbrrsV+6LK6s+JeETitC1TLpETiN1XN8Xe/ZW39F84MwObAOBnCUna7E3r+KLy/QetB7h36K6/2QXQfEvcHVZagWSnTKAHmkftF9NumO9JoRwSYsEVevPC3+ga2Yz/EhGK66x7NhW0Y9aoCatQk6XbYPKlgqHjbhfpAaOKyMH0Qr6iv4SL/R2DhS3JRnzqWpYI/mJU7JkRHsl8u++cK4GOig4wl4LUQ4UNMiHzPp3lhQStDuTwei4sC0GAf+TG8jyhcdlHMUZ6vLD9UMGuTtUFLJYczbzmwJi7JopzVNoxsWG4hKqEs4TY5+Lu4mY0YBqO1ey4chDvLLKFC2u3
 ojDg5S7R
 7k78DEW9v8eOSxkwWHQSBLILF80b/dnFbH0+ex9uattmO4yYRasmosHXFCca7ng0Fd8HNO6E/25Vu48pha5B4oxBFwENGWCmQFixbh7mEmFMMs67RK5BhdFuLNDAiMvnS6bp11MPx8B5O2Pwv5tIV3o33JY4AUMpS4pSVVw9L/+3rnHAl+liitY3dUcE3/CTuL0slB/iNsga4RvGWXyN8oDScdfbhnrBhzB0c+LdexO3eTrCVALRMLP/1Jko7A3U82y1cC5i9J07F8OhFKrBT6fZDVnGtBwCAxQnW6q2mPQz7NlDG9nAzF1puORRoM07tBUAE+yFN80MDpZ4efqQNycIIuZSTxXBDewa79d3W1p+tqHyelESyXHxwxsV8pv3pkBecfURcMl1hK/DCXcDw77peATjzC45syPkI3+zsAaxZb6u5PrZVrpis2FIHrfPBowXv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 2:18=E2=80=AFAM Chris Li <chrisl@kernel.org> wrote:
>
>
> There are too many swap_is_vswap() in this series. It fragments the
> code path, making things harder to reason about. Esepcially around
> locks. I count 22 in this patch alone.
>
> I consider this the biggest drawback of this series. This
> fragmentation of the code path.

This will mirror my response at [1], but I'm responding here for the
record and for your convenience.

It is needed because vswap *is* a special device, with its own
requirements. If you don't special case-it, you'd get undesirable
behaviors.

Let's take Baoquan's patch series as an example.  It treats the xswap
device as just another swap device, without any special consideration
for it. Which creates several problem:

1. At allocation time, cgroups that disable zswap might get an xswap
slot, because you don't do any check that the device you allocating
the swap slots for is xswap. At swap_writeout() time, it is *stuck* -
we already do the unmapping step, so we cannot reclaim the page.

Ironically a physical swapfile backend could have bailed us out here,
but it's not in that patch series yet :)

Vswap both has swapfile backend, AND allows you to bypass it if the
cgroup disables zswap. Both involves a bit of swap_is_vswap() check,
but I think it's worth it :)

2. Per-CPU allocation caching: since all devices share the same cache,
xswap will invalidate the caching of other devices, and vice versa. It
would be fine if the these devices are interchangeable, but as noted
above, it's not, especially without physical swapfile as the backend
option. So you're forced to taken the slow path more often.

Vswap gets around this by adding its own per-cpu allocation caching,

So by being too lazy and not carefully distinguish the swap devices,
not only does xswap not work for the writeback use case, it cannot
even work in deployments where some workloads (cgroup) select zswap,
whereas others select disk swap. It can only work if you intend to
have a single class of device - either virtual/xswap or disk swap -
but not both.

Maybe instead of just grepping for swap_is_vswap() and throw your hand
at the complexity, read the code and try to understand why it's
necessary first, then propose simplifications if you have good ideas
in minds.

>
> This is questionable. A vswap device does not go through swap on.
>
> This changes the behavior where swap devices always go through swap on/of=
f.
>
> I wish the swap device went through swap on to be able to start swapping.
>
> Chris

What usecase would necessitate the need for swapon/swapoff interface?
Other than just trying to shoehorn it to an existing interface?

I've expressed why I dislike the interface in [1]. Other than the
sizing aspect, which we are already discussing in another thread,
priority also makes zero sense. You are literally exposing an
interface with only one correct answer - what's the point?

Justify your interface choice with real userspace use case, not just by
conforming to the status quo.

[1]: https://lore.kernel.org/all/CAKEwX=3DPEEkYiNRaVhCuM4E6mxB9huPKfkDa4m62=
VMTzedg1oYw@mail.gmail.com/

