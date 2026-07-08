Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CAA7C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 18:36:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 193B16B0005; Wed,  8 Jul 2026 14:36:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 144F66B008A; Wed,  8 Jul 2026 14:36:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 032F66B008C; Wed,  8 Jul 2026 14:36:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BC66A6B0005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:36:42 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2934F168A03
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 18:36:42 +0000 (UTC)
X-FDA: 84966465444.20.0CFEDEF
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1B85BC0004
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 18:36:40 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=OSio62ao;
	spf=pass (imf22.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.175 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783535800;
	b=dFpb9Oi/zrEkc5FCRqZJ4xdelu5auMydY6SN7bMw14QQfRwu3FA65P9z4ChLSkYiV53kAV
	0cxGjXHiUphzt06lvfp+92yPM2OiXklfs867/RqDSjLmZncR/kJwnWhJm5Lx7ytAge7Qyf
	LfM8fIlKz7eJNZwM6G9ohKsWFQly0VM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=OSio62ao;
	spf=pass (imf22.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.175 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783535800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HQUQLqO2Mk8JcZRKdWc9LApUtZaqCBfghfuCA1j/MN0=;
	b=sDQlH/IX9A2dg2lwjiOkdY8HNFGt3czrnvaGA+8Aoiu3tTfFZ4rXok39snt21+vwGbgV+0
	5IykUpDPlQ5sxZLyLaMfxQpnjkB/Ff80IA5h/6c0RWwitAQCPpnbFmk1VA6Fnt5+IgL3YH
	1cSaI39NdQPubEO4znylSAeXNTOjVh0=
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-92e6a434cabso50940485a.1
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 11:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1783535799; x=1784140599; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HQUQLqO2Mk8JcZRKdWc9LApUtZaqCBfghfuCA1j/MN0=;
        b=OSio62ao+xxYQEZuv0qHK6msEHDeMwgyVY4MNB0r53QVHLJ3Asq2GqQ2aTuetoq//X
         D8ngvJv+ch2gbfOQKoiNnbzJobVwIYinFT1k5XpVTxiAYHy4taCaOmp+fdHbfYjhSXCo
         D0i71u2Zf4PXyynv4e6V1GeNloigLKcnjh5cyrYpkFSrzdeSDPR3ceZIE0CdqD8u+XBs
         B3iKgsMBI/ccbPZaeYMHqofHfPyRswfAeZ703RuU8IdM8YTyEna2bubeUANe9Af9Gvjf
         atXnyOX1Nr7Q6AIMu4YHHT1CrJmE/pGYjNQvGqbgg187B9edqaWkRu2y3xu9Pyr0noJ8
         w2vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783535799; x=1784140599;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HQUQLqO2Mk8JcZRKdWc9LApUtZaqCBfghfuCA1j/MN0=;
        b=fvLwuPNQ/6QlQ8N4G3ajQ+lc31Xv89YGy4epoCoTt6ON78yoSR9RAo/+K3E3rsHZcP
         zrrFwldKMmmng9Mjk4tAlCcyHiJNeaJkOU69LTxR0bpZ7sj3PGSH6nVafoMxBWOdbmmZ
         sIvj8CKLGoq5teW61EszAxi9uaDAEmpCouBMTKPxT7gGAxcrVxQAyp3QABv4Lw1SqnxI
         ePM6RChqlQ/JQvqHueE1ZJ+ERCDDKjinjb//scGTSsbxwN5KbG6I16Ig4Ekna+vizvEx
         OEmeGbZWJeC80dkhCSH7Tbn1qQKs5uMBxzBHDnGe23As+DRvnWlvCZQP4dJK2uFVBox/
         099A==
X-Forwarded-Encrypted: i=1; AHgh+RpID29u2ZkmfPSP9pW5i+0z9LWv+Rjg3h0kkZKoL9fkax170tJHghwy34EMoY9WarE6KF6xo5gdbQ==@kvack.org
X-Gm-Message-State: AOJu0YzcnxRTEoSjIX8X8HkM05GpKVYkw8EBhdFxQpGfGkfvBdARp//0
	KhvjFu0iSlcuAagT1Lin5ksouFZbmywb04qB7wzAoRgnnr/NvN+yqRHATQ59O01QbXQ=
X-Gm-Gg: AfdE7ckYWDbxMs0aJwssWSgjItkJDk0INRxY4YqH4TzIpZtnaWpoYLTI5P6MZh4fx8P
	Z0ZLgZ7IlHsbDDBDbDhdmHeOyy6aOMU+mEvC4XdcNU21IVQa1vgo+qpxAEGdhmVZreouiazT63j
	1gEwyzS0VDliVL6rcOhVUWI3IaF+HkgZV9ML4iY6FiXa8dXtPCKGVQA6QgHAu5/MpGIk5IDvbx5
	gZgkJ9E6rSeIrF1Efnomz1M1nuxvC5ih8lnifr4T+FkiWVDUE/Cvsy0nrCbdVtsp/dS0mwyUp1q
	RbzokEmpt6Z3TleToTeup3alOGJ45GvitGhXkJndLT133ulWhgtazJVOPinZ6r7k7ncBTAR3U/j
	z4px3dgq4LihMskBuH/NPtdpYyQrCrdBo/RVKEZKCzVg12MPXVqgq5HpJynAdufR9aFOTLdrjSt
	ERCdrUXSu3LPg=
X-Received: by 2002:a05:620a:4049:b0:90d:c28d:9666 with SMTP id af79cd13be357-92ecf5f5107mr379796585a.30.1783535799119;
        Wed, 08 Jul 2026 11:36:39 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e90b800fasm1446082185a.6.2026.07.08.11.36.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 11:36:38 -0700 (PDT)
Date: Wed, 8 Jul 2026 14:36:31 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michael Hicklen <michael.s.hicklen@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, tytso@mit.edu, vbabka@suse.cz
Subject: Re: kernel NULL pointer dereference in drain_obj_stock during ext4
 e4defrag
Message-ID: <ak6Yr-BHnRIr_LoE@cmpxchg.org>
References: <CALhAV-Bzbe5BtGsH=tdd9KBK+53w3Nwy8drWcAkAeq=UyoH4xA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALhAV-Bzbe5BtGsH=tdd9KBK+53w3Nwy8drWcAkAeq=UyoH4xA@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1B85BC0004
X-Stat-Signature: zwukz74pmdhrrozma5xw1no1ofzx8oo9
X-HE-Tag: 1783535799-513705
X-HE-Meta: U2FsdGVkX1939j4FklJKLC2Yeq8CMSMRzWgnFeOGQ04WlKyWAJB4LTaAsqHu4CTImCQXR4u8tKDA0Wk5HMRcmBRb4Zyb8RxoIxHwrxFRjp1R3Iawh4NCMd4vSWa/uuZH91mWNfo6qjgNuIJN0WiOq+Un6yy1DqO9xHaRQO70hR004kjj7ozhQkDb6uoHcjUMNbLdZLIgA67VvyUyQfXvszdwzf67h7+dykGNCUMU2W5gmv5RAYH+eLUauluGh2Zg8EPK/10ZrT2xo8M3uuMRp/MH/DLGxNQmtWnagqFHM3Yu+T2bw9hIjeN9BFYCtNv5wm/nmPTXewAXj09V0cH/B6TABS0BAzX66IJAYUHJQ3Q5znvTMgNgBdZnw1edEE20SvQlaStvaJd6DT6kXmGr07wzRlGwPr2jkPA5e8jpwCnPpeSKKGE1g9BvAlASTfiN1DLLuM2BETfya9el6nrbBB08xFSr7FdRnU0/bmL1wsPQqFu+yPSCBifMjb98uO2F+NnileKFRrYgrg5I1/P8Ap2SNwTRDN72mNlfsLm4vFy2fVHwn1q58iK6CJHkuHg6lFnS4MUcJ8Jm8VzjdQI6GKIXC1YlBxW1mZ95VFeUptWksIjaB+RmPg8R1WfQHZxNVLI2vGhWGVdWmsztZAikX8aUdV3AiF7uFzwfYpleI+3M3xAGWEngPfsK6c2t3Jm7RDVMer6gCn080cqlhnkHkZczSBWiHIurPpZQ56V/1kjFePKXnwm9KtCu54WMlwTW6vufRzPx6XqUaAoqYrpaP7UnmxPtV1qJGzmxxGHJTXRFY5iWkEf32AgFB5PXQHgYg4CLBt3Gf9x9nrh0HOzGDXf5lGckXYYZKcu65Zl4y2W5uWUhvAFQ2jitCKfMr7csxLJchXuSAMl9nK5XAMfZCxFrSLTUw9zTPer81n0dl6r2oQY+xWACsSyDl49Loxm9OXekJTtT3Bh4NsuWWJX
 yf3XjSPM
 RD7DpyXw2G2rbul8fmPJudNlgs5fYcOK4or8LVXPtfQiKqanS2cD3amW+eOHt4XwA39wgHj6lqSangxN2qVyU9FYmBaSGwmLyPX45lGIfexZypkCYDtyO0fTCn5Eu+oeCom587vlSllus4nSf1qR495FQSmZFapxn7qk6w9nLrKPOAQuPF9Zmw0TzmGKLhTwl2/s5RvZAiVJeZXMoiHm1pTJpizUIbI3siMVgzDpq/3e9gJGPGloIDmRmZYB32Z0fSFQrfmjy66QL1g+4RCSm4rvRQwAwFXK1kKn5r1q/77bNs8+7kswvnGTpzi9FlHyv9bu0CCP3cs1/+2/+r4dN9OAXEal/PzElCd4VI47ss9G6L0a4/Q+uOdb3dagoS9LRyico12lWhejpVRtQYikSBKO2dHVrR3hCmR8jUbsyD4BkeskOKRiuirBAHCTZzzbZEbdUEovgXwHqDFPt6k08xOXjUhqzvtIqzOvee9fKr5s0mkydUkyoijTVsyvRA0mv/wocL8Kw+9IcZm03jiDsveipAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Michael,

On Tue, Jul 07, 2026 at 06:51:14PM -0500, Michael Hicklen wrote:
> Kernel: 7.1.2-arch3-1
> Arch: x86_64
> Hardware: MSI MS-7C95 / PRO B550M-VC WIFI
> CPU: AMD (kvm_amd loaded)
> 
> Workload:
> 
> 4 concurrent e4defrag processes operating on 4 separate ext4
> filesystems on 4 separate HDDs.
> 
> The crash happens during memory reclaim while ext4_move_extents() is running.
> 
> First oops:
> 
> BUG: kernel NULL pointer dereference, address: 0000000000000676
> #PF: supervisor read access in kernel mode
> 
> RIP: drain_obj_stock+0x175/0x310

Thanks for the report. The trace and register state suggests that we
have the stock pointing to a dead objcg. Through this mess of
container_of(), you basically have to read the lines in reverse:

  drain_obj_stock()
    mod_objcg_mlstate(old = stock->cached_objcg, stock->cached_pgdat, ...)
      rcu_read_lock()
      memcg = obj_cgroup_memcg(old)          // objcg->memcg: stale value
      lruvec = mem_cgroup_lruvec(memcg, pgdat)  // memcg->nodeinfo[nid]: stale value
      mod_memcg_lruvec_state(lruvec, ...)
        pn = container_of(lruvec, ...)
        memcg = pn->memcg                     // freed pn, first 8 bytes now contain 6
        pn = memcg->nodeinfo[pgdat->node_id]  // <<< faults: 6 + 0x670 = 0x676

Michael, do you have the full dmesg available from this machine? The
oops you included already include taint flags for previous crashes and
warnings.

There is an interleaved Code: block (twice) that disassembles to what
looks like an obj_cgroup_get() encountering a percpu_count_ptr of 0,
which further suggests use-after-free of the objcg.

