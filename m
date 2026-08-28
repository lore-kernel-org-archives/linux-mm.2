Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7373EC61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 06:11:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D2786B0092; Fri, 28 Aug 2026 02:11:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 583FA6B009D; Fri, 28 Aug 2026 02:11:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C0B66B009E; Fri, 28 Aug 2026 02:11:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2A43D6B0092
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 02:11:18 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B20CDA0271
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 06:11:17 +0000 (UTC)
X-FDA: 85149655794.25.E789DDF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id D0281A0002
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 06:11:15 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iDqrsBdB;
	spf=pass (imf25.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787897475;
	b=sNTZScXhh6GCpRdEF22u6BCYCP+N3CTQiOAMX7Y6Jh/U3EuNlp6y06047pf9An0aOnIIaJ
	9ZmOG24pvkU8Uk0vNF+Q1JFFKWoP6GfU0YpaNlxzdFggh2JI3l/a7viAjRIp26lU6+WMqS
	Irt6GVrURw3jm5bgQvzanhO9Kf68ofg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787897475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A9r0VEIfV2PAmfdMx+Y0pF6W4viyfiq1gRGNPOGP+No=;
	b=JZigP2zX7D6b16LkrCaazAVe+awDTLB5Q7kG18h84Wu5N2JVwPjhU04nra19IMjhxWPsRC
	qx+smRcvKFTmbJichxbHQWQbkCiUp0RvhMZz5lNPRjpcfIhwl+qY7aeC4+vxrlA5zQhdNT
	szRYQxXa7XqtugLPb4m9SmRDtOSKSMg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iDqrsBdB;
	spf=pass (imf25.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4C869447F7
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 06:11:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31BD11F0155A
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 06:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787897474;
	bh=A9r0VEIfV2PAmfdMx+Y0pF6W4viyfiq1gRGNPOGP+No=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=iDqrsBdBXSwIXMwcLsOJzVonEKU+OrI/lCOBtkkH++mi3bPjFXU75WaRb3gInaKns
	 oEyJSMbIViFWr8lejvSBKLh2x4FP3F+lA1eBq6o9Rgm01wz9X4FkHRdwaVLbqhjpRw
	 RiE1+L04RK3c8mROFLpfsN2OFFcSV0B8/4i4MQ+jbx/6f6UmnaHksIO4L47Dnp0KQR
	 y2lkwlGJ4307/gZW/twYsTLFJQyInChGCu3ibWeSyqRA2l6DgfoVhNGAlygZO8Tvcc
	 bX5UIEdCeMlnmhUbREKFS8myg0lVlmfh1lQScm3HXJzR3sb+PLlnhGYwe4SjV+qwaZ
	 OMAG/sJGbjt0A==
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-90cd1012479so11743746d6.1
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:11:14 -0700 (PDT)
X-Gm-Message-State: AFuF++m93TFN6aQ3HYU0r9/HluEKdpHkT6BROo5BXVY7P6czEWpDwGzP
	4T06616RNQkcSNzdNDGH74oXWy2dgdgEuCyHAAFSEGf2AMZCNBcFGYVVHR954tB0L7e4JzIrGOv
	W5a8j31pRCFE8QBhnM5I0YoRCUMyqr6w=
X-Received: by 2002:a05:6214:27ca:b0:90a:5779:d30a with SMTP id
 6a1803df08f44-90cd43a64cdmr114204226d6.6.1787897473470; Thu, 27 Aug 2026
 23:11:13 -0700 (PDT)
MIME-Version: 1.0
References: <20260824073806.629593-1-hebaoquan@kylinos.cn>
In-Reply-To: <20260824073806.629593-1-hebaoquan@kylinos.cn>
From: Barry Song <baohua@kernel.org>
Date: Fri, 28 Aug 2026 14:11:02 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yDgCt6C7tS5YR8Je0OEPoYFgXNbG-T5KLmF+EdBHA9=w@mail.gmail.com>
X-Gm-Features: AcwNN1WE7Bh8_L9t2XAHnqdqt352yaQMUZj2FkQbKJN7Mn9b476cBiHMqCmTyu0
Message-ID: <CAGsJ_4yDgCt6C7tS5YR8Je0OEPoYFgXNbG-T5KLmF+EdBHA9=w@mail.gmail.com>
Subject: Re: [PATCH 0/9] mm/mglru: suppress empty page table walks during aging
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, david@kernel.org, 
	rostedt@goodmis.org, mhiramat@kernel.org, kasong@tencent.com, 
	qi.zheng@linux.dev, shakeel.butt@linux.dev, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, baolin.wang@linux.alibaba.com, 
	hannes@cmpxchg.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D0281A0002
X-Stat-Signature: qwoq8msw8tjrqsidq1gojqao15xxrzwx
X-HE-Tag: 1787897475-202656
X-HE-Meta: U2FsdGVkX1/cRg1TjdXr30TNQfvRIZaRDUisjKsz41FhEIBG2h4Smb3t5HLvWZxjKrkVb78kqdWqHySl1wTb1/AwIVZRQXCFl8iciS5G0bsmK+p15wfAWGqHggmRzp3UJRquFSjxa79yejpfUX8QOoivd+RkjkSCgS4supSKHpewgKvznqAG0fhOsIbUfnFM0Nbx3a7Y7b14hKDytiHif5SCqoUf7n9nDHRxRmbXPvuDu5DPVFf1MQncNhgXJ44kigHvbWzjCi66SpX1eE50FfFYP8NEhsAOZKyCQVEOhxFKgVeu/huihRonVw3PCm5RYI9CsqJfgryXiwVBCD5hvkvi1L19aUAay4zPv0QJwk9q8hbOtNoFnw0Ao31oegdeFwYA7NEGV+V2XjafRaIYdau1MKDhBddM9Kux3NbQufgyaDltAPJmOLDXiiGfv0/93uYymF14lTZUy+lI4r/GiKeufaHNBxO+P+Y1dpzswFXfA4hmi+eLSGLdZB/kQ+uwK8WNAAF+vL9ugDcmp86ZHYFX+dxnQRg3JYtZd7+4P4nOK970hRRWAI4D9rZsY9Z9NEXZSLSXRzJvilv0Pfqyoa9v3aEqLcF5DrUHQlIVzPdUhlRVCyIk/sKHgRxgGYtnMzKWvPEnAl8DUCaRnPLFgFRsYuw03RTcjZ/Fx9SBlOGMUCoGoHWTthLOxKZ7+iB2lglPNlWyzr/7RkhWA6eOzUner3H1DSV3FUGUsaWM3tH0QPcFn7Ji5gg/czXDisnktR/8Y/uBNIus+DKfdTFiSQPrCUMgTSechUadPvo9MKb3gW53x7tqLilzM7tKdGc+70w1E+psvWcMxFCn/LcM2jOgJmqAEodqLDs3yydLUJCfzVP29APs5+vUbVBNt5KH8R57SzzUd5kLMdT5Hqw4x+WyCnoabQeRywUA0OkcG+xWlnKoe/9mhrlBys+/MDzlGg6Gqwc/FDGUaqQOkC0
 bAMuDCs4
 HUu30ry+cJipzQxXWeDVcVQgsesbuOCqZckebH5LXklSo6j6G1f3+nc2hFanUloU9gzL9LKOpcjCFkQXZwHA95Pxtfdrl7AKI2sfwXPMopFDlwRouVDNoxmVrkNWjsPzfyNFx48uZn6X4ME4eZuCS1JZibPLyTz0TafakoQE128mvkVQWGdWkxSa8CIfTa4l2d8eYIP6PDeyLq6lC7O+/jIco9lwDE5Zjyz476gWEJMEbsNtCOaWZbRlEv6VOgHLdlVP8BQNuIHiY/BstOs4QaN6L5F+BBfslYAzJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 3:38=E2=80=AFPM Baoquan He <hebaoquan@kylinos.cn> w=
rote:
>
> In the current MGLRU, lru_gen_use_mm() will mark an mm for all nodes at
> each context switch, so on each node aging will walk into each mm's page
> table independently. On a multi-NUMA node system, one process launched
> on one or a subset of nodes, its mm is walked by all other nodes's aging
> while finds on pages for their lruvec. This is pure waste (100% walks

I assume you mean =E2=80=9Cfinds no pages=E2=80=9D rather than =E2=80=9Cfin=
d on pages.=E2=80=9D

> are empty on those other nodes)
>
> This patch series suppresses these empty page table walks with two
> complementary mechanisms at different levels:
>
>   - empty_map (cross-node specifc). At mm granularity, one process's mm
>     whose walk found no pages for one node's lruvec is skipped on that
>     node between re-scan passes.
>
>   - PUD-level Bloom filter (general). One level up from the existing PMD
>     filters, it skips any 1GB PUD that had no young entries last
>     generation - namely whose 512 PMDs all failed PMD test. Cross-node
>     empty walks can prove its effect the best, but it also suppresses
>     purely code PUD inside local mms. So it reduces unnecessary walking
>     in any workload with cold areas.

I assume you mean =E2=80=9Cpurely cold PUD=E2=80=9D rather than =E2=80=9Cpu=
rely code PUD=E2=80=9D.

>
> The two complement each other: empty_map reduces the *number* of
> cross-node walks, the PUD-level filter reduces the *cost* of the walks
> that remain.

I wonder if the PUD-level filter alone would achieve your goal without
requiring the more complex `empty_map` code.

PUD is already a fairly large granularity, so even if we still do some
redundant work, I wonder if the overhead would be small enough to make
`empty_map` unnecessary?

Best Regards
Barry

