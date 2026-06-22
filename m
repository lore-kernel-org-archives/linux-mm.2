Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BC4DCD98F2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 13:00:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 048DD6B008A; Mon, 22 Jun 2026 09:00:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3BCE6B008C; Mon, 22 Jun 2026 09:00:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2ABD6B0092; Mon, 22 Jun 2026 09:00:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BC1A86B008A
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 09:00:46 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2678114017B
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 13:00:46 +0000 (UTC)
X-FDA: 84907558092.26.AAF0137
Received: from mail-qv1-f68.google.com (mail-qv1-f68.google.com [209.85.219.68])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0EB99140019
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 13:00:43 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AD309Z2p;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of coregee2000@gmail.com designates 209.85.219.68 as permitted sender) smtp.mailfrom=coregee2000@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782133244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/XBqbMNr66nfg94FNA4L5tcvQmnApC0ioReYsX0LRV0=;
	b=p55sWpmkZ8AE142KKqzWZ8Drvn4D0RfDouhDiHMlILCPZJF8CKi4AI3Bt+mjfbuIjpKhFu
	6PMml9J8mEtp/Bk+rOh89WWa9sEfZwcfoZpJQVNSBxtoqN+V4v8sQu2F/Yq6yW2Lu3RRN1
	V1Hu97OBGcBkpLHJjAGaZxdsuGPykTQ=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AD309Z2p;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of coregee2000@gmail.com designates 209.85.219.68 as permitted sender) smtp.mailfrom=coregee2000@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782133244;
	b=p5Kz9++5ucyCsGhC1aQgqZeZH10Lvu+MJgapKZ+9N2ad8rDvrtSihkj/dO4y3ZoxgyVqb3
	jdgqtf44/17EAUo2sQWhd1wE6d6DzSoLK+e5Xi4kniE8154TJsYcEXlWdyCJZ4hMCXS3MK
	SQMnwjY7KY4oR7u+dxUcLN8WoNlFEQU=
Received: by mail-qv1-f68.google.com with SMTP id 6a1803df08f44-8dc87f7d68bso51044796d6.3
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 06:00:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782133243; cv=none;
        d=google.com; s=arc-20240605;
        b=i0Ekg8SVW5iOSoWY5kw7kpU+8/xfaWmXD8yMx6+a/pFmIJE/ok8g94mnQ+ZMJ+HadU
         szKbCijc9XNAaY5aNQHFLqXh1IOzoLoXKxKWlCWy1S4/dsKVmeBgOyve9wBADz9xd6yf
         dqyjW0OM04Trr3gYkPzWgNCa1iKgdZ4z19hbKkJACp4P4fVjPlGMjWtH5aqGl96dyWQZ
         cdLWKuHjwUvs3bwB04hKGiSdRzsrbhw3X+/0c/A4LN4QUvQlOz+r4eIK7C/RjUZMY1is
         frisXbttlNRJqDCx++4nxvIqx2byrco8OVdkTr15VJ5JTXt1IPTqYwf2UNmYXHsCdh04
         7wZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/XBqbMNr66nfg94FNA4L5tcvQmnApC0ioReYsX0LRV0=;
        fh=I4hMfI/14kBvS/noF4k6NKZaSfMpbRNqJ3ovDxChhZE=;
        b=Rce2eUFPeksE1ktMkfqJRvaWuqblscHFSuf4JRGYJTiK65pLgzqdzlMgtyu0pNA0en
         7QX0i/4FQcACIVkTjITQKE769w4zorzHyMUJW43upasssd2IfAihvC6VlQ3ToJjt9YTi
         vO2wkUWo4n2w3umasMqKnvlJrwFy2S+DZKM2Zjh1n2jAk1HVdbyzlbQWnx+wMqR4WUlz
         THB7c1nJi13Zxq/dCAzqZONdG+G36BzRm/IyZTXcZFq/5P83i6cH5gtTWKUWdEnkA0k/
         Ey0KKOp4+jJvK2Z0xEzVqGZvST563nw3AkRAjz0BUGJam6oNhzd5kNNEOVk3giAK6VrU
         I36A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782133243; x=1782738043; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/XBqbMNr66nfg94FNA4L5tcvQmnApC0ioReYsX0LRV0=;
        b=AD309Z2pGZG5JORADo4/tzFhT5A29M0UoscuyJT+FaVoJ5ATYw8kmO6k7TKtCCWxNc
         qyN4L0LejorIbCQZE0P91wHpXsqjV7AFQ0/Ozd1ug+Jv1FyNV3/sZxK8DyCuGXVI3VOJ
         6LiRuTPj/Map1CCbYnB9IeKxDJY8H+d7NO8O8KvV2x8dTUVtBFKX8wpm5Fn7lfW9Vw47
         Pb7xALAakI9LfktrC9tsgCc57dw8dogBNWsimEYKlRP1qHQAM/FaWNDymwO0MnZUKut/
         YJAuaIXIkUwVog6nY0bidXMndMTLLIocMdCFEFQaakcpfbM5QAN6VHqNz4L2hjfAA7Wg
         P9mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782133243; x=1782738043;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/XBqbMNr66nfg94FNA4L5tcvQmnApC0ioReYsX0LRV0=;
        b=tP/+wOlKhnj1qP7C9e8GlvN9gem/J3TWmiaoao5RDkzUhGZmIELKyucDRVMSUIvEeu
         9b0w9LeUWhVvyM/9NSga0YNNiCdMjmTIgyc6Rzpm/dtBp9FTLjwyqSUrkVHrQjrL+WXf
         w9q6RRAPjbCgtMimQ8NaEueGtqCa2X4e0Ndr+sEjs1U/sAWWgBG+0l7HEvGa3kWc04G6
         oE2KA6Az+d2z0cEwwyxEJ1pGZ3VXBEI28bb3dB0VV2TA1o8It+8UQJ2AwrlV/SVAUhMi
         aPsrB/g7+j5Y4x6rBp3RrMB074yZlNbCwxJt0AQVSVj1raUBvRdT9Vo9EQQImynL9BcD
         ukpA==
X-Forwarded-Encrypted: i=1; AHgh+RrxjhFDRxeB61OfUaC50vQAIZMzM8/OGvCfVFeLBfku7oM/WmqwfOzjGeiBJFZttsIpPwpWJGgYZQ==@kvack.org
X-Gm-Message-State: AOJu0Yz4U9nQrLTOqmJ60wCJMVaN/oISHr1v9rfsaoRWjCgXpel3oQGn
	7HPEM9w/sBzdL5G7Wr3qtzG6CJO6nrbVV9WcqIxNxTmqxinCHngRzbB6KPBTAT1bhbi1nibcrW1
	yZyjXGqOlbBurD///BuAqJylaUNnLFqM=
X-Gm-Gg: AfdE7cm71XeLDfppNo1qqysgrKl4Z7++YSdBkD/sPQAceU9WKH19hclVKq3YTVSfU2M
	D3U36tfHg8pHHxGTT48UjPXCMGIxWtKIEBtWVGhOuxKyF8G/BI5ScsBBQaqmrszj1KwCtV41lLv
	YlNXhgrVTZxsgAippFu5PU8/ro0dR2cqE1BnqGvGTdBFGJZ0FDeRc+tePyiAdotj1MHTpZgNo0Y
	e2Aq/izDZELgC5xW5Ghz4uRTVL3+Jm7n12obpvZVJLKWEdPo/uibbiWQPz45lIorf0D6qliDQ==
X-Received: by 2002:a05:6214:1cc4:b0:8dd:ace4:6f17 with SMTP id
 6a1803df08f44-8de3bc0ade3mr239119376d6.10.1782133241777; Mon, 22 Jun 2026
 06:00:41 -0700 (PDT)
MIME-Version: 1.0
References: <CAHPqNmzgCY+sHOOG8YVrCFO-7oh6TBeL4SCHEcfVvH6J1SUVdg@mail.gmail.com>
 <airuQ36pKQ8x8CZk@linux.dev>
In-Reply-To: <airuQ36pKQ8x8CZk@linux.dev>
From: Longxing Li <coregee2000@gmail.com>
Date: Mon, 22 Jun 2026 21:00:38 +0800
X-Gm-Features: AVVi8CdwjZFcRa-oVlnafv4xlC1qYdc7VGGH_SFssuRNPccf47k7UE3k0Lmjy6A
Message-ID: <CAHPqNmwWp3p+PYb2HQsSmvDQ39OQ51byE30wYxVwaS1SOjQvhA@mail.gmail.com>
Subject: Re: [Kernel Bug] INFO: rcu detected stall in count_memcg_event_mm
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: syzkaller@googlegroups.com, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0EB99140019
X-Stat-Signature: hrw9o1omkmtcro65as4s9znd9rj44azw
X-Rspam-User: 
X-HE-Tag: 1782133243-395483
X-HE-Meta: U2FsdGVkX1+/qSkaHh2Til+yc2VsByceljCiTYhW79rUMVp5kawW1ECSLWjEPNsxBaxsmTcihTzjQeBbXW4oIonmMG+9fE1s6JtyJeR2tTVMWMRlfzYbTJKJ2zsx+/pLa1OmLf3e0KAoYw/zzLL3BzjKaJ4ibzxWI2WyEPCGYR8iIUqbm9UOK1/xqq76KetETC4oC/QCUlfB4Kc06dgBa5slCw7KiQMSTm+EF0aZWXVDjLRJjyyd+/hioZntjA4dh4ofFwlyzuH7NJz6fkZPp/bNouU3gakARwCBALRQqRm9+lovbOr/cbaZVFJax5CnKxFexZB+zyIrz7/qelMK3oyTu8bA9ZG/7kr6SRKURH472S0rr0JDaUNmhuSB6l9LzcVTMlw9QhIBEl3Plyntf2aBmhDCsg3CG5LGESpeL9SkfUhdGgRs9MScZcvoN1cFiiq9vCZQHg/5MmDusBV+uj2P39rNRV3ERxvGdOD4vAGH7eZYAfv9wds2BUhH4Giu6GGS3lNfTc37gz/uAxnYegXtmaSiH/gMsVfpMqpYJCLTQhigHb/W3gNQzwIDyChcVMTI5JTRKy3uDTCF3Zg5BJSX8afvwV0+4RlEYD+udeTt/aVbJOhGWJnvcVwTm4Xp/9I9jGj80HmMDc+8TYMfKuk9dTHhec5izcJ4cMfEff6tI/IGetyPTM0lFvM2j4z9DVofFsknNC/zepjNwJFlWtDYV7xjTTK8bDDPhRW9EyMM+SHUgR6X5TVwD1pYjhnTCuH59IDd7ph3b95QC/90PxP6r9Lgd9qAfBS85fWzxXz6I+16KWrcnDzxpJxieqdFESQzUsWCMqKJxAJLC7IKnlu8iT0yrZF//p6BwfGMLBWbsA4okFRM/LvKhXg91pVt5SIQU6LSQ5fhwPxyiX8SjJHKEqCq/eNraHSwTtN7OEB9GY+C+60u6afYfaCXeOsh0FK54E1WkPB84jXf83m
 FdFngfPp
 EdoGZ2+v6Th/ns401UraGadDTYbIJDUDMafJVCpKS/lp6JIvwsdxRRm2FxwIqpsbWwVmP6w6gI/CXYT8YN0N2tze+SIHCIBtZDIKIM2qskiIbgKy8C6RxbrGmsAfDJsSrvVWLTGkiqw1JLcpNeFx34J59lRbsnG6bzcqcQ2Xf+Sf7WdQwyaa1O6c2swLTCbjADLZINtR2hHAlJjU+HSM0pV+umTU4MgVTfu2X4a7bynl0kldZeF2jkLY+TXsSpaP61o1MzUltsNzrMchSE/Xt2hh0FJUJ4FV2CWFUt4yGm5qvh/8zK0nyfryuSSDqlTlbr/9A7O1/ellVmFhUEOgCARrpngcKL6ff4LWNl0sck5w8i0DDXTxor0mbrYL5stiT3H1/g55+f+85D9sNYGqCIDsRz4ETiHiwCNuwxX13GxXwJczlBXVfwNCKw2Bw9/ahQnoHwGuBbwOwG0qqyaf3imYsLDiiaHcplcKeP+QFQ7Du+VPxM78rWi6jNrFav3B+E6UJi4gdQXzmsNcCoEt4EtkUyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

  Hi Shakeel,

  Thank you for the reply.

  This seems like a CPU starvation scenario. The reproduction triggers
extreme CPU contention where rcu_preempt kthread cannot get sufficient
CPU time to complete grace periods.
  1. The stall occurs in count_memcg_event_mm / get_obj_cgroup_from_current
  2. Both paths correctly hold RCU read-side locks
  3. The deadlock is: page fault =E2=86=92 dentry allocation =E2=86=92 memc=
g kmem
tracking =E2=86=92 RCU lookup =E2=86=92 need RCU grace period =E2=86=92 rcu=
_preempt starved
  4. This may require extreme stress to reproduce, and can be random

 We will try to reproduce with the latest kernel and report back if we
find any specific deficiency.

  Best regards,
  Longxing Li

Shakeel Butt <shakeel.butt@linux.dev> =E4=BA=8E2026=E5=B9=B46=E6=9C=8812=E6=
=97=A5=E5=91=A8=E4=BA=94 01:21=E5=86=99=E9=81=93=EF=BC=9A
>
> Hi Longxing,
>
> Thanks for the report.
>
> On Tue, Jun 09, 2026 at 07:57:56PM +0800, Longxing Li wrote:
> > Dear Linux kernel developers and maintainers,
> >
> > We would like to report a new kernel bug found by our tool. INFO: rcu
> > detected stall in count_memcg_event_mm. Details are as follows.
> >
> > Kernel commit: v5.15.189
>
> This is an old kernel, can you reproduce with the latest kernel? Also at =
the
> high level this seems like CPU starvation. Can you also describe your sys=
tem and
> the workload/test which is trigerring this issue?
>

