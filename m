Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8882DFD3769
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 15:44:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D76E36B0089; Wed, 25 Feb 2026 10:44:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFA7B6B0092; Wed, 25 Feb 2026 10:44:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC5006B0095; Wed, 25 Feb 2026 10:44:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A955D6B0089
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 10:44:37 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 27563BA592
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 15:44:37 +0000 (UTC)
X-FDA: 84483401394.14.F09920B
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1E05F1C0004
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 15:44:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NmxfWJI2;
	spf=pass (imf18.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772034275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=JYMokGfjxIyugJzvHNVEK04XDDC0cpUvKjNgXaP6x3g=;
	b=YcYJbPD98Jvsc17l4U9NNIoBhKfB8TMItL5BXO7PU+LBcom+JBjcuCgv54ZGJidFTg6Fbp
	fWEcg89wwHdjtQIxrdwXzUTRvURHKPf1hgbOnwsKAGv/vNIEvtQfmDCV0g9cFRkBhRWDxK
	1PG65P9f2v1kbL/IISc1zRRV2Px/DAw=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NmxfWJI2;
	spf=pass (imf18.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772034275; a=rsa-sha256;
	cv=pass;
	b=PwLvSl6yDLDlsKBBiCY8VIgc3MH0c1GJV8dnZNTUpLI6qGX9jE8SUX2MYZ6JHeLVIL349D
	DG25ygVXt3hdRT2TciIZxALdtm2pSDCegGGMEOGSFjsTgAQRWHKt6csFu8e0faxP/a7VCz
	28EdUrFYl1H+ECYPbA7EacPu1FHCIIM=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b8842e5a2a1so970102166b.2
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:44:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772034274; cv=none;
        d=google.com; s=arc-20240605;
        b=V2nVrKUVylc8eLjrFjjToEX3mqPFza7GiJUlOejXAkb1XVyGmnZfP4mOoS7kJhleJG
         47dtaoWfh8WqCgNNloHsrD6ga69frsnCkFsu+LUbauRuNFZSUw1PPGrqseOxj1Focjy0
         bZYcS1uz4twSe8u/1zoIBEKGBgEfvDNka2FLjHAgfLXtgm20mrGpqX6HfM7r4oCx8E/b
         negLJ1WK7e1SYBpVCA8WEDcU10Fh/cyVSk5LMmzwDZiZIycPQy7h7jXVo+Fg2wbBJ1un
         U9UE4ox9tgNEeXi9bSZOm2e16MPI5p/vPNboJlgGy3+GIYwSTrlXNDgvmI52RSF09WUZ
         Qz1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:dkim-signature;
        bh=JYMokGfjxIyugJzvHNVEK04XDDC0cpUvKjNgXaP6x3g=;
        fh=AtEVF4eguTH8npBABuC2B3F/ANAn4hdROiKgEITwdDU=;
        b=X6i7zWzmUmoLLIropkbCcrBcJwtRiiqCaeIB5hoX+WvuYNoBPJ9D7GJ9pQmCAtswIu
         7DGKaW8U5EVyCpwWxv6UQ9W9Pr9q3JjZqDBLhDRjRirddyKV4eQjx8weDtgdxlR//lm4
         maQA8LllZEuBpGOshdPscLnBTSeJQOFXMfPnUaVB5ZwPGovIWrWqzD8AW2Iqjc/r2u6u
         G31xrp+BI4ZiYUhUEXRGn+/H9lwF7rP0ft1HJrq3rnAWSpKX+gN5u1XSciwG3MUHTLZe
         yBbroe2Qdxw5dE7wXlNJSS825jV1A3ToIPnbbJZ2Q+hiMqkoo2grbXQNn+dNtgVL8Bx4
         fvXw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772034274; x=1772639074; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JYMokGfjxIyugJzvHNVEK04XDDC0cpUvKjNgXaP6x3g=;
        b=NmxfWJI2wkUkLpbZALEuHlM9f8ZUqB3vYLRQFxNCWWhNdgtEMXQKnxjECYNGgvHP1/
         j2ROx8mqq7sxJL+wSspP1MoGT4XBvjNh6eEcn4lkpe0vNGZ/3vpPC3GwSEugWItV6Kt1
         lqztVSJAASIkfaQVuc0CADlyYVpiea244zCNSTpP87566jepaxl91b0mAy5C2+olLR+T
         isXVkP9z0f39lWRyNnvj4PdZBN5hlzD5A9gz1wtshiG8+KvgbzMz1KYkJgD0jf4UIgPI
         jN9FQb91kxHClkR9dOf5/XyDuK2qLo9ktF3+9FRvVRWOXDJe3KqXEWRYDtlhOdYbWD0m
         EoXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772034274; x=1772639074;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JYMokGfjxIyugJzvHNVEK04XDDC0cpUvKjNgXaP6x3g=;
        b=TysnjRboVNLpnjuj0Alsecm+JAfvYlNzZCLqW/RrefAh5JWPWckfn/xia9GwqCLLLP
         CjMv4MLbLlmWHbaBvlto6cyLXTsYlVO7r1mVmvyxM/w3KmZCM2V8gPNsuG/43NFaYjZJ
         S6wmWkk128trPezI2+3Ra5nM4Uya7FU9NZzOuHyJNuoqfaBKd/EtOqIann0gDCG0tObd
         U8xX0CCpbzFeW/lbuq75WHAlu15ekDg94OZq4jWe8QWTRfou4ne3CkW652nyaaLRs/FX
         HhrfQsoeHLxLAxNcb1GNyfhm1ue1yCiN+qkkfR6jRt/wTvefRhD6eNuwc5RqQE6ogLln
         GfRg==
X-Forwarded-Encrypted: i=1; AJvYcCUpdUh6uDt+dAsqjAc25G09nbNAmp5z/xAkcw70oytCEOfv05gPSLr91HVGl+Wx2Wja0yFkkfMiBQ==@kvack.org
X-Gm-Message-State: AOJu0YwKYD80IelhxY+Iv640de/TQWLqVXBQYo3a9LB/fwjf3/UovNP+
	fGWIhHcl7A9y/UOhiyXmyqs9yS4pPsO1/me3xXtYk/lMxaUToyUVPHdO7VLFkwtTEy/W4psi28N
	iApvMHsWW59u+ys7+eOtsQWc/reIStqooUhYA
X-Gm-Gg: ATEYQzyXr4fmG4eV1kSj6VQuozKvuH0seWW+85xsvohZPfeftC3PsyjakII7TEoswAu
	X61pub1KeLUIaqMP9GwhCoUzyBFaEF0pI9xt+BtSvozvFEA2roKsuN/kMrUjKch14xzfdovL5M/
	ovk3vzfTJJLdSqHNKyB9wWhFXs6bjwLU3QvmB8y5fFjWZ7oOC2t7CnSAN/WccLuud159dXtoEeJ
	cnm5IiIQ2HyBWXV8hFU+OpOHDvXrNIdrOzEx+V+zNVf32DO72+16OZzaKXYJhdE9MYTllAXCuxF
	JaTNGxcrk0sgnEyNNEGfy4N17+kUpePHIw==
X-Received: by 2002:a17:907:3e83:b0:b7f:f862:df26 with SMTP id
 a640c23a62f3a-b9081a0251bmr1059208666b.14.1772034273280; Wed, 25 Feb 2026
 07:44:33 -0800 (PST)
MIME-Version: 1.0
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Date: Wed, 25 Feb 2026 10:44:21 -0500
X-Gm-Features: AaiRm50LoCwVVLTKr6fVegDhRvGAiAQZ-nq2m-IWbycrGlYdl0TbvkvixqU5Qn0
Message-ID: <CAN+CAwNwpjRf9QhgAEhBQZD7r7sXCzLXqAKbNrPeMEq=7bX8Jg@mail.gmail.com>
Subject: [LSF/MM/BPF TOPIC] Making memcg limits tier-aware
To: lsf-pc@lists.linux-foundation.org
Cc: Gregory Price <gourry@gourry.net>, Johannes Weiner <hannes@cmpxchg.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Michal Hocko <mhocko@suse.com>, linux-mm <linux-mm@kvack.org>, 
	kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 1E05F1C0004
X-Rspamd-Server: rspam02
X-Stat-Signature: w5uzh6ye5qb74gtyh6jzgakab9nhqzmj
X-HE-Tag: 1772034274-964660
X-HE-Meta: U2FsdGVkX1/ZlVBKPM2t1aeyPP3rvuSx/t+OWf9lIqb8V70xV/ZT1iGaLuIUoGX6YEE7vDP3U4LvxYtf9Ixq7TOnsBz8yhCLXaSldHWVrlSjEa27p6lyb8aZ/BBiEp2rShYer2oUIA6h8FICf+dVUymCjsv9XlAJj+i2Zjt/mPkRqEqq9VvR3VRt9q+adB8DNNSMsviozOp21BWFCRM3c5xnfrXR1FWZODiea25qTeygeHvAaEt4zAddA/hnR0j8QRzLNcUcYvuFsypOFIiMpOcSkSFA4m3FWPUX6V0w5gnOpzb9Pe1fhuXeKhWeQX07y06XqQVDFC9VYI5XR5kszVWmwjIluCWmHga303pE0KUFF6Icvm8fFpFm8mJ4FYLZC7ALvAS/LeeoJFXxGch0XDUNYuDtac8cQJZMQVvcMIN+I/u7By7B6HxKxBMShbdzM7GL2H33FJWVOwPQVSwt/78tj/r3oNUImgS+fIzmvja9qAtDnM+eAYpK/xIGN9xXIxBk7gTUvYMUBVWhGt0UEp92c72qEs6DWtTcrYA3Qrvkvki8k7pRjSuwWYYEJkpuNbhNSkmIGLPcJVgWy8n5ocs670kE6/5G94cMOkYViFD0zsu+2adDl7gRsVpoF4bZE6VXhPDibUJsyu3mNqhwc7elCZTviAqzl4cPjAFW3LoLqTnwm6GpJWHHQn/BbnsDPPT+ks80Bmr5vggBzvODPEjSJXVdQ0kgGsCV0TOxv8ohPoaZ/TZT9ZRG0OLbQ7p+FNps7KKlrwbDnNCLOZ/tJAUBNIywaHY4B/Aiu79dS7AkSiVG+OhFjV6vKJ2ziPkXXUf2AxSk/YK/ke9SDtnUtaxijQoD5V6GmUEBjItYmvHWubr5Q5QxVRO1eGE0PwNZn+RgrH5B7ilD6JLT9+HZogM94g3Q84qiUKpKJ3rPGHvFxyOIXfPkw0r1tJwUIYwJj20jbcOkDAGj/FkOLjm
 I38A4ZWe
 wcbfhfPsx+i04ANMfe56W3StBzvcsNOyPFZRbO9G+RCYyFVKubgq4fnaU9BXRIa9pWwNK4b5R67oJ0Uxro9t4hGphmAdkPYas6uSvRyswhaj7d8bSM+hgprTQfVdsl9jSoUZMtvyjro0wTgvtx1RXDgVc430ApUgSnX8SIYGQUj3sqOpp3YBTUltVUegeUYre8BurqOtPbAPClQM0M7tExBpBJzalO3VSwOYrG/YSu50ayoAYYagMENSSveCmaitpCoOGcR/I3Z47itzrv3dYZ+CNeWpJQQ7BGi6nSqDUDO7T5vPJ5HN4f+mwuuiAo1Xut2ihW6ow/jn84XEPuV4gwev/i8qLzbh4pFeJnKzaMvDnEodxVIe7UufWBco7zU3QnleWS74O4V9ri6YXHk+uemzMvs5baSgUq0LD+ZQLOMcsbRvRWwLw8r9WjXs7WZrOzE1EF2MKjgSodiRPxEs2We/gmSIMhSW64QvtwdTdLwiy2Bk6ZFhk/pOaoKd4DBVaqsXCzNQ8TqKQxT1iAkrjyAjHSksdP37udCE1Qs1kCXsGE3I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Preface
=3D=3D=3D=3D=3D=3D=3D
I=E2=80=99ve sent out an RFC PATCH for this topic, which is available here =
[1].
The goal with separating the patch and the topic thread is so that
there can be a unified discussion thread even if the RFC moves
forwards in versions.

Introduction
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Memory cgroups provide an interface that allow multiple workloads on a
host to co-exist, and establish both weak and strong memory isolation
guarantees. For large servers and small embedded systems alike, memcgs
provide an effective way to provide a baseline quality of service for
protected workloads.

This works, because for the most part, all memory is equal (except for
zram / zswap). Restricting a cgroup's memory footprint restricts how
much it can hurt other workloads competing for memory. Likewise, setting
memory.low or memory.min limits can provide weak and strong guarantees
to the performance of a cgroup.

However, on systems with tiered memory (e.g. CXL / compressed memory),
the quality of service guarantees that memcg limits enforced become less
effective, as memcg has no awareness of the physical location of its
charged memory. In other words, a workload that is well-behaved within
its memcg limits may still be hurting the performance of other
well-behaving workloads on the system by hogging more than its
"fair share" of toptier memory.

Usecases
=3D=3D=3D=3D=3D=3D=3D=3D
In [2], I list out two real-life scenarios that can benefit:

VM hosting services must ensure fairness of hostwide resources and
guarantee a baseline performance. These machines benefit from maximizing
its baseline performance, rather than maximizing system throughput.

Hosts running isolated workloads with a guaranteed maximum tail latency
are also in a similar situation. They want each workload to process its
work (e.g. a query) in a fixed time window, and they would like to
maximize the system=E2=80=99s throughput at the same time.

In [3], Gregory Price notes a third usecase: hyperscalers deploying
hosts that run mixed workloads with different owners must also ensure
fairness across the workloads, as to not reward memory-aggressive
workloads while punishing the less aggressive workloads by pushing
them out to lowtiered memory.

Mechanism
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Memcg limits are made tier-aware by scaling effective memory.low/high
values to reflect the ratio of toptier:total memory available to the
cgroup. For instance, on a host where 75% of memory is toptier, a
cgroup=E2=80=99s effective memory.high is scaled to 75% of its value and
enforced at the toptier.

toptier_ratio =3D toptier_cap / total_cap
memory.toptier_{low, high} =3D memory.{low, high} * toptier_ratio

As an explicit example:
On a host with 3:1 toptier:lowtier, say 150G toptier, and 50G lowtier,
setting a cgroup's limits to:
memory.min:  15G
memory.low:  20G
memory.high: 40G
memory.max:  50G

Will be enforced at the toptier as:
memory.min:          15G
memory.toptier_low:  15G (20 * 150/200)
memory.toptier_high: 30G (40 * 150/200)
memory.max:          50G

This prevents the (previously possible) scenario where 3x50G containers
on the host above can hog all of toptier, while one container is
pushed out to lowtier.

Topics for Discussion
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
1. In this implementation, we restrict a cgroup=E2=80=99s ability to use mo=
re
   than its fair share of toptier memory, even when there is no
   competition. This extends the natural memcg limits, which don=E2=80=99t
   let memory.high/max limits go unenforced because the host has free
   memory. However, tier-aware and tier-agnostic memcg limits arguably
   serve different purposes.

   Concrete usecases for allowing a cgroup to use more toptier memory
   than its fair share (while staying within its memcg limits) include
   systems that keep their hosts underutilized, workloads with low
   baseline memory usage with transient spikes in usage, and hosts whose
   total workingset size never exceeds the size of toptier.

   The desired effect can be achieved through a protection-based system
   that relies on only memory.low to protect workloads, instead of
   punishing overconsumers. Whether a purely protection-based system can
   adequately protect its workloads is an open question, however.

   Should this difference be encapsulated in different =E2=80=9Cmodes=E2=80=
=9D for the
   user? Or, are existing mechanisms enough to support these usecases?
   (More context can be found in the Jan. 29 Linux Memory Hotness and
   Promotion meeting notes [4])

2. In this implementation, we extend the limits to memory.low/high.
   Are there usecases that may necessitate extending the limits to
   memory.min/max as well?

3. Are there usecases (and hardware) for systems with 3+ tiers, that
   need per-tier enforcement, not just toptier enforcement?

4. Are there usecases for users to set their own toptier limits, instead
   of relying simply on a tier-proportional limit?

5. Are there usecases for individual cgroups opting in, as opposed to
   enforcing this toggle on a system-wide level? What would it mean for
   a cgroup to be unrestricted in its toptier usage, while other
   cgroups are punished?


[1] https://lore.kernel.org/linux-mm/20260223223830.586018-1-joshua.hahnjy@=
gmail.com/
[2] https://lore.kernel.org/all/20260224161357.2622501-1-joshua.hahnjy@gmai=
l.com/
[3] https://lore.kernel.org/all/aZ3ysV-k1UisnPRG@gourry-fedora-PF4VCD3F/
[4] https://lore.kernel.org/linux-mm/c8bc2dce-d4ec-c16e-8df4-2624c48cfc06@g=
oogle.com/

