Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A04D1CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 21:12:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A86E26B00B6; Mon, 11 May 2026 17:12:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F8E96B00B7; Mon, 11 May 2026 17:12:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B1476B00B9; Mon, 11 May 2026 17:12:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 74B366B00B6
	for <linux-mm@kvack.org>; Mon, 11 May 2026 17:12:54 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 22B0C120206
	for <linux-mm@kvack.org>; Mon, 11 May 2026 21:12:54 +0000 (UTC)
X-FDA: 84756388668.20.23AF0E5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 64F1D80008
	for <linux-mm@kvack.org>; Mon, 11 May 2026 21:12:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="RUll7hu/";
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778533972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wtyXmLtMGhcVKQ803T1rFtK5F6gCL1D8Ha739I5JSOk=;
	b=3qJOWbfFsPlxJdDwG8fbFea53M7HpcEnnUEDKq7JZpKibriXsh713bsItRG19tgFTlipcf
	D4XW/cJE95iCk1Q/l1U7SEn3AVc+l3OhRgfjwdDfrajOM/Uli/8ISov43bYTYnxdLYvHkk
	rpede28NC/CMo9EBv9tq1/Tpy9BWxO0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="RUll7hu/";
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778533972; a=rsa-sha256;
	cv=none;
	b=nQu1m9R2+TVPB5qFCqfTkEjgYOdls2BTJAwSc64g0jJP+vAx4yWVFhb4LJGv+J20zi+hzU
	hdtw1H54KGQJPue4QShmGFu/vtnE98/+AW/0MXc0AuYeQQ3NxP36gU7garN8kEbCb6afPx
	NytIAxNXOfyU5Y7fq95WxOifhco9nkE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 449F04079A;
	Mon, 11 May 2026 21:12:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5417FC2BCB0;
	Mon, 11 May 2026 21:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778533971;
	bh=NM9hT8Fsvi3n2nwRZxfAVFQAf1Vhq3vLs0fNanGuwkU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=RUll7hu/kdrsdt56J2K8L+DJt83t2yMVr1lZoc0E4pitUX/J4KfTZJD35PxJzib0c
	 kIkKF4Xe4uB2qoNVQP2RKU9sikQ+MwmKkF5VMPF14Wmojg7PF8evmZ9ly9qi0Bn7G2
	 gTo5iL2Pn2FKCLyxBouo+H6LtHuViXNhwgR7ehHw=
Date: Mon, 11 May 2026 14:12:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kairui Song <ryncsn@gmail.com>
Cc: kasong@tencent.com, linux-mm@kvack.org, David Hildenbrand
 <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, Hugh
 Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, Kemeng Shi
 <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
 <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Youngjun Park
 <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, Roman
 Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Qi Zheng <zhengqi.arch@bytedance.com>,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Yosry Ahmed
 <yosry@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Dev Jain
 <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Michal Hocko
 <mhocko@suse.com>, Michal Hocko <mhocko@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Axel Rasmussen <axelrasmussen@google.com>
Subject: Re: [PATCH v3 00/12] mm, swap: swap table phase IV: unify
 allocation and reduce static metadata
Message-Id: <20260511141249.eac1426fee41c9fe463e7e23@linux-foundation.org>
In-Reply-To: <CAMgjq7CJ8Are6m7X2UxUoJ=77c_oSpdG8-bzkmdRzwey2Cp1gQ@mail.gmail.com>
References: <20260421-swap-table-p4-v3-0-2f23759a76bc@tencent.com>
	<CAMgjq7CJ8Are6m7X2UxUoJ=77c_oSpdG8-bzkmdRzwey2Cp1gQ@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 64F1D80008
X-Rspam-User: 
X-Stat-Signature: i3juwx5nfagryhsge5wajyjh773x987j
X-HE-Tag: 1778533972-166606
X-HE-Meta: U2FsdGVkX1/CnprGFhkr1+LpkhYFEcSdqqpfoRNz5lbeAi/VYEv1fiBVbZ3wDp5j0lofwZfa3OyJXr68okZ0+DVvUzx1AQ1caEMwmbnXg3tLjHTheYIF0TgHgg+U1aDyOxGoWie4xYkG0fcZDX5l0G8JI/vqd2zFkYi+joeY8FRY/2i11bnnMIwE38Tx8cN74px5zAs8VvR+XEe+sZ4F7f3BYAQtAQKUBJmyfwi4yVoWhziIfJo5d/iOV2m9SrLsWJL/PfGlfyYQkoUrZ66eYBOGDJLpO99gTZciCGt0VMsFjS1iZ0LTLnKj9Z64nYWQHZWS4lmXLkWFMXFZ5JPY71a0fNjIM5q8aaIyT1THQ43Zv2pG+5FXZmVFNg389Y4c9e41Z0iAkJGCNB2NkHqvFeWJrBLQfwzJDfKVPWCMd2LG/VpOOYQv/+VcSlsYlXEhRQqXQw9BVkDh5zr5g8epJbN0AvcWBNJNQPNPsp3fqJpSyOrRzUPgz6ni+Q34t5g31lSV9p2lbqHzQrW960UJmGmUdoAkBaLwYyX6T8bNQMcSnNtPr5Bf6c6J7xJduGwk9Ndh6QM+zAdEbj/1cvy30kdkN9YM6jemxhfVhslQDyFI/H2VbBhttCyAvB0wm7rLbicYou6RNfIJc8gDXDoUqrF1fjWl6MdPuslYhvF9wKTZqKmDWO8ru5x/mJLTgWQEkF6pipReWEi4rxPF+Wq9VWTDD0Ayl0CqWxzc3rdDAojOzLQfNQRfa0vjVJ6wSalPcFYV7BEnHpDKwIgsaSa8Fp9WWa9lNMLUBPbFSMW1X+gCo4sVv1M+WoSIZYIE4yzTuXhynTHIvVNKTb6qhS0Uhc+NoIuOAphfYpwaBBctQpfkaINFWnQJgjLHxhOFFfxVm+XBWcaeeFveBtaMVIu6ELEmNvDUEa3h6RSNy5zL1s6fKtqEpORdVJ+3a1ugGpW5GyL6n3Wvot7J48HkqTS
 oG05y9NL
 7yihbc6waVW3mlztWC2Onr7FiZz6pxpobCkTOYvi5ZR9vjKmlIo/RvU6WCwyDdsOK0EC7au0qJnM6cBxXVBp1iVyCdtL9/pBdz3/Lx7WXDjbK8x9msiR6N0L2iRFgSPD7n85OVgpK2a2C7FnXrVF637Q2eBpZxm5dSZUnDYBFv0tcxRdFpAdFj1fEQZkcyHdg0jTvEUz9tMz5pIpRFFApqmY7gs+Fxu+A+3jBvsnXXzaKqEXQjOGIZ2ktbMM+5zqgrgymV88AuzyKYj7BohZgLnHiTZATYfqUilBzPmttqgk6Jd65lRGCDzWqNIWqMqruz7vLr/ypAVoE5RfWxyeYqb85AVBQVSuyr5j1Xjp5DzNldiM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 25 Apr 2026 02:11:47 +0800 Kairui Song <ryncsn@gmail.com> wrote:

> > base-commit: f1541b40cd422d7e22273be9b7e9edfc9ea4f0d7
> > change-id: 20260111-swap-table-p4-98ee92baa7c4
> >
> > Best regards,
> > --
> > Kairui Song <kasong@tencent.com>
> >
> >
> 
> I checked sashiko's review, it seems sashiko itself is bugged or
> something wrong, Most patched end up with:
> Tool error: Review tool timed out (active time exceeded)
> 
> The rest of the results are all false positives, maybe I can add a few
> more comments in the code or commit so it can understand the code
> better.
> 
> And checking V2's review:
> https://sashiko.dev/#/patchset/20260417-swap-table-p4-v2-0-17f5d1015428%40tencent.com
> 
> Which are mostly false positives and I've fixed the two real but
> trivial issues already. Things should be fine.

Sashiko review of v3:

	https://sashiko.dev/#/patchset/20260421-swap-table-p4-v3-0-2f23759a76bc@tencent.com

appears to be complete, so perhaps it went back and figured it out.

It claims to have several "critical" and "high" things, so please
recheck?

From your replies in this thread, I believe that we'll be seeing a v4
series?


