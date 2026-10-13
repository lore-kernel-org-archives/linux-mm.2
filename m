Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DFFDCC6B12
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:49:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 756776B0095; Tue, 13 Oct 2026 11:49:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72E9F6B0099; Tue, 13 Oct 2026 11:49:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66B686B00A3; Tue, 13 Oct 2026 11:49:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3EBB66B0095
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:49:09 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D54A4160D1D
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:49:08 +0000 (UTC)
X-FDA: 85318036776.25.2388E0D
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf28.hostedemail.com (Postfix) with ESMTP id 04CABC0007
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:49:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=KUe+JVIM;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791906547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mrNB/7UTIGYGYTZ/Zj3hAKbDyQ2eLb57xFz/cmZ4YH0=;
	b=LA6VQF9V61bl7kg7Gdqftc045p7TjfMFhC00nI/5g97F45p76PS8oUusVTOhjrIGldhCCi
	SJAx0p9uvYApHwwkEBtEr8hyjE5EEnaqHmaLrkjY1wtxcTxcIzlPV3aXM8DHhDFsBMi4An
	WcrvG0Uz4tq7clLyc3C/LNoGDubuOy4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791906547;
	b=LXQOeHr/zwyXFp/xoxiT0E1tWiyc05dpXrX7hu+t0j6X75No+MuxYnHkow5aJxOGEE3tWx
	lyv9jxtqubUNE1DPToGNCb+mZw7VjvOoPiIbi+CSIAGAXUjEPOV7RjYtWSINZ7dgiejmuu
	vJ99uyAY20zKEWflIUoqSVugaYBBf80=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=KUe+JVIM;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-93cc31c18ebso215867085a.0
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 08:49:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1791906546; x=1792511346; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mrNB/7UTIGYGYTZ/Zj3hAKbDyQ2eLb57xFz/cmZ4YH0=;
        b=KUe+JVIMloQSXAvv41qY01CzLjWskOrDuZTaP2pdFHc/ZpRBHAdBTQAwAFQ/8X0/nG
         mI95JgGIl0Y7uKWQ4yPlLHiU6uOs811QnUMyGcsLiamBRN65W2ZIpe4ZS/WWLMTerKvZ
         dRxO5QEfAW8sr7xlQU/k3uBt/p+e4pWAnypD6txitqbkDnDPZBsowisNj8yLelHSc4FW
         ubVK44gGR+Wy46worrOgSThCZgVaIeDKU7UbaAykrSmUAPoI7XJTVPE9DozlzY+X8oDB
         3ABy7Bev+b0g7vcPTsqde3Ls9IdFIc5r+PMrdT6l+4fycP1qMZ7j1pR4433d1bjpJ2BU
         H/4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791906546; x=1792511346;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mrNB/7UTIGYGYTZ/Zj3hAKbDyQ2eLb57xFz/cmZ4YH0=;
        b=IXnFFlM5xVU8pNv9OOjLypMp1aHvVFZIF5VwRHcT9wZGQ4IrDbhwueQJSZdgfyjxYU
         TtGCAIr/dQSBppM+FFLgKbMU/sulSQ5qU4TiiRUvvG+kTNbcOOsDm8vhHvYugvyrav5x
         uz5HPWnU/f8PW2E5L7MuDZnj1NmSvLQpLKFzhn39uDm+snl97yl1OU8jStRlSy+me+dP
         pzXdVtFtNYwwJy3zup81RuH1AgEfpwf9uMMA0JtIIAuEKvgiaWYi2dwqIftgfcb6HwZ5
         +xY4I+eIq7nJ8xVi23cW+Fe9nrllsjyAw7orZRNvSW9tGGUFo4hbOEC7GjgIgmHsKZoS
         wyyg==
X-Forwarded-Encrypted: i=1; AKwUvBzeVmdaOUFlZcspEHjfNmFZobMH3jkOUE/yVlBdIkwf+WBU1og4Kg4pjoqlELvTbf66/gnHtnMjAg==@kvack.org
X-Gm-Message-State: AFq9FYImVBcsOR+smNQKzyNVdET0SP2zUcTvZdnw6an7FoeZlcL93H9S
	JSFIxHmeIo2XTID8IRcntxWTSJ1oD3vuj608fiZ7AeWWJV7YICuR7r/eHWfMP4rPgHw=
X-Gm-Gg: AYBFou2MsUrEGBBIcRLpeAq9NhZkC/xKwFPBnSp0irYLXmczaMkTTg7xd81I4ZMNV4B
	Bgw7PJyF559ElWVG7fPs+Rw3Fh3kyO1yiubYCzaEGYgu4Rt/gzIkadAWJwCjjwLuwAtQ3T5ySWZ
	STLmivvo97nb4SuavGVNpGSOn1z2X98hWEJ2VhwyEgZDCfw4L+MCIG8VAhqhl30o5z1FSz03ZYL
	noCiK2z7KC1c8EPc4Q2u8KD4lgKGls34SI6kBiHBnTEAdHZVoeLWorp2MSIjPWso5QuKQkXmRDW
	IkqfyX/VryU19g2eRpxHuaq1m07olsG75nyZim1OezENoOYSGPGCM0H+QikHmxJf8D9c5EML7pN
	WrxSorvEs4KHLsoo763soGNbRZ+SeIg4NKCF6zh9tOCEVwsVxJTUUg18I5KrSwLWLSueetMG0Vl
	trN0mtl2ZRqog4Vyk7zmHOZz1+jO9/tx8rM61+iLWr3jJwS+n5o0aeqkukPkKVE6qobJrIw8Tag
	pGvEHT+nXIcsVBcrno97u8HSSB8WpRUaclHgGUiP+thzkqvdE8DX6U=
X-Received: by 2002:a05:620a:6081:b0:93e:5b69:fa8 with SMTP id af79cd13be357-93ebd2811a4mr1919769485a.66.1791906546018;
        Tue, 13 Oct 2026 08:49:06 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93ef50287a2sm265747485a.20.2026.10.13.08.49.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 08:49:05 -0700 (PDT)
Date: Tue, 13 Oct 2026 11:49:03 -0400
From: Gregory Price <gourry@gourry.net>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	eddyz87@gmail.com, memxor@gmail.com, mingo@redhat.com, peterz@infradead.org, 
	juri.lelli@redhat.com, vincent.guittot@linaro.org, akpm@linux-foundation.org, 
	david@kernel.org, tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, 
	shakeel.butt@linux.dev, roman.gushchin@linux.dev, yu.c.chen@intel.com, 
	zhao1.liu@intel.com, bpf@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/3] BPF-based per-cgroup NUMA balancing mode
 selection
Message-ID: <as5RFhW1Ch8ta5nZ@gourry-fedora-PF4VCD3F>
References: <20261012120438.52849-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012120438.52849-1-laoar.shao@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 04CABC0007
X-Stat-Signature: 6kcxph9m8i1sqmzwzywtr96jbmp3s51x
X-HE-Tag: 1791906546-613517
X-HE-Meta: U2FsdGVkX1/6jRu+WdN7xUyoYJnUpnxS8htK0fQjpVhrkG3K+aj0mTwzdWLdXJMYkfWJHS92BQt0bTUo88I3XCd4B/Xcex5F+/fOuxwtAGfd17iBA6/yJCmX4g0IuH0umg28Idx62GFEV3tzJZzOl5h7V+XR4EzRzYW8kYXYP2ev0pVVHUgQUGcOiDX1Hm1YWjB8kLWHDpNay1k5oA3tOf7D/YDLG5gPFLW0c8uHaGk6P6nAyYd69G7Z6H4Ca8y9XpaY/52NFeAYpNH9zPnvKXV6ELXsFyxxOb+iRVUnXR0nqOxi5HcHw6vZ0fcI/msrFtZXldS3OIlQbM0G88YD6IcI4iUnhIyAII4InNMauuS6+SGAL8CK1WuIaoKf0FOTbEpKV1FgPc4WjuPcZImQABMREuEgDMU2LxHjVWO8L5wdV1OtsU/jWAhAJErIS0MZVlUTJDriaxGo0FKBTvzUeEQABvhuyHNcLnRFK2giFD/wjzwfUcvTi4yPzvhzWc9dAhTvLoKcrrVxRxTG+k5leDDfIP7x2tKRZzk3VKU7v10q7NnYi4LYvFwTJxD4Cwm4kRyT3ith9J4eOGudRV6THmjamEEs+9veFsa88ZVEQJb9JSJzU77jLN/tXGiT6/Nq4cVasZU+3vzkHYLqI0n7dxxZKAT2p4V3wJsNGSLp1bt9OkZ+4tROOGDKYnyoV0DBKNs18dF3IDHHJYjp6RgKbIldyQ2iGMGFJuhZX2atBNfU/R42fy3aU2dCH8FR7T0cO3JxcXFPwQKx9t07EmTTh6xg0Hg/ErZR3VoIaB9xtaQe+PXyQ1HrK0bsNx24MbrA4dpNmuKPrT485Vzm+dSH/78ttdtIH4z3Ww0qABcei1Dci9D1p5NfwtZN7BBCVy1MwzCzmDtR1U25m8daawvEfkVVcoBIwREMtoI7S+d1gfoMagyZvVJx8d5bBYa/z2vSV9/vWYHNxhtKZ4o8rhy
 pq6fyjj6
 XUcPEfOUuS/H2DBy8G+bkKd3ukSGrjnW8VzP7IecjSE5qfF/9tA9dMaUelXN0UdqXjVIXKCw8bAEreufDjwy+kyowoxSaF0X7VsR4n7pbPZXvaELZEmSjALS54fDJ68HDyL9Vq3fgUtXlEuyAXmhFWqO/u2B/9HDQRkMbmNMn/MFocHA/1o/EjuAlhNlDLLem6AHdlkuRnkFzUaLlWugbzRJgr3QAZFjWKhq+aqoYcingLTvLkdUkfDZ/wtNFedWu9d+K/YuPU6UhvlR+p0sskpDDZSCPrrsL6la09hwohfS6j85b4lFCKsUKJhWQ7xJezDmd6C1QBKgNMjJ27kpE2Rz79Cn9gMRQTMW1KcZJq6Vv4auOYK1QYJKYnSGXBgRfGfu/vSxX2ATDrAwBhCTArnQrmeBHEXDMm+J7+jVMYsnm6hmH7N4GSPCpF3RQMQ7alIZq+2KZU7nJeIZSZVfKfDjVvZvUspParxbxB4IzpKIN6qOE9DxeincIdZ2xK8bMGT5/9MSxmfUfZi5gAJ5Sc3x/KRn/xxr0BwLF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 08:04:35PM +0800, Yafang Shao wrote:
> The Problem
> ===========
> 
> In our large fleet of Kubernetes-managed servers, NUMA balancing has
> been historically disabled globally on each server. With the increasing
> deployment of multi-socket AMD EPYC servers, cross-NUMA access has
> become a critical performance issue, which made us reconsider.
>
> Enabling NUMA balancing globally is still not acceptable: it increases
> the overall system overhead and can introduce latency spikes for
> latency-sensitive workloads. What we need is to choose per workload
> whether NUMA balancing runs at all, and which mode it runs in. A
> latency-sensitive service may want the scheduler's NUMA statistics
> without tiering's promotion machinery, while a batch service wants its
> PMEM-resident memory promoted when hot without paying for
> scheduler-driven migration. No single global switch serves both.

Have you tested with recent fixes?  NUMA balancing has been broken for a
few years now (starvation issues causing VMAs to never be scanned,
east-west filters causing south->north promotions to be skipped, shmem
being entirely exempt, others).

https://lore.kernel.org/linux-mm/20260629163337.1264881-1-hannes@cmpxchg.org/
https://lore.kernel.org/linux-mm/20260930112206.205083-1-gourry@gourry.net/

I also concur with Tejun that ops seems like overkill for this feature,
this seems like something that can already be managed.

For example, why not add a new numa balancing mode bit that says
"enabled but only for explicitly opted in tasks" and then ignore the
global default mempolicy, e.g.:

  if (numab_mode & NUMA_BALANCING_OPT_IN &&
      mpol != default &&
      mpol.flags & MPOL_F_NUMA_BALANCING)
      /* do balancing */

~Gregory

