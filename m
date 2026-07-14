Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F189C44507
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 19:59:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49B926B00EC; Tue, 14 Jul 2026 15:59:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44B7A6B00EE; Tue, 14 Jul 2026 15:59:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 363446B00EF; Tue, 14 Jul 2026 15:59:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 09D286B00EC
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:59:49 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 84CE2A040E
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 19:59:48 +0000 (UTC)
X-FDA: 84988447656.08.4302CF5
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6047380007
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 19:59:46 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Zy+ZtPAo;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784059186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IDSJzO5pJmxkBK1F3ZKqyU0APXt0C4YAh0U5SLJWhSc=;
	b=vBYgWRVkO/ootkHhhfG33s/7pbxqMSks33UYVD4wtt0B3h684TwFi1of7A0Er5sclzkgS6
	GI8/sSEiPEjS2LWmBu7FSqVLK4DMBILxpLaCnW0L9QQ5slyMxPnsENRf8hdaP1ZNZNZsbR
	qmTX2lleaLZD3yujIKz2YRQ9VMBJi1w=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Zy+ZtPAo;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784059186;
	b=O0R9SDL9U3lX6bKcp1xm0IG9wWzj3GoXbFopMXSeFY0HOUMfvRJebFlpTihjOpLBHl6tHl
	Xv6b0yvoMXQJcthV4pVhNBDVOi6E5zPGRRoS40/pS+jMY43/CetaJgZMkr7ccBt0MBXi5z
	DlygsOvT/0zXlAKBI3vrc7o2WmYfMkE=
Date: Tue, 14 Jul 2026 12:59:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784059184;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IDSJzO5pJmxkBK1F3ZKqyU0APXt0C4YAh0U5SLJWhSc=;
	b=Zy+ZtPAoEvh7n4JxV8gDM1sCVb4ngVGAqPqLN4Exmlew8U8V2P5GUpMzQ4ESE3ozLvRw48
	k9apBqcULygG1J53BQG/k496OfQvi9WDXlJBl1/Or+XlCWY/I3a1VA32qSyk09Hrp7i5Wg
	9SLUIbl6pRFyAQqKq9k96WFfvcLU34c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Stanislav Fort <stanislav.fort@aisle.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] mm: memcg-v1: account vmpressure event allocations
Message-ID: <alaVDim_cqqE9bFr@linux.dev>
References: <20260713085520.2953121-1-guopeng.zhang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713085520.2953121-1-guopeng.zhang@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6047380007
X-Stat-Signature: zoq7e3nky61ftoz336ay87jg5kjfgs97
X-HE-Tag: 1784059186-591484
X-HE-Meta: U2FsdGVkX1+ZpNik3rqpYlYcJomB21JBo6z6ULkux7wk1rTSy+eO9ab1PzAKO+ne3vTby+8vpcL9rCX6sRNkS4Dn6Bx4yGfBEJ1408zzZuckUnRpT+ZPeNTjo+psDq8dATl1WaIgYIRgxfzYtf14XYstljTuDyIZsI9fsPtdyjElTfE+fVNEndeILatONQCwWs8hxzgm3K9DoCJc1EdioeQiyXQ0sP0dC/FkNoV81CpD+rcPFuvQ8McsdS4h6AmOpzXzVJnk3g1Rt/geREzpDlNyu6nyln84HGbxMQ7Y1EDienmSqY/dI4PF+ZU1aEN+uZtJHjGeEz+/gQd9wxfg8w/Hgk5LAW7bymzU2oKV/PsrLCVzSNgV8je6trtyrWB9SkrGr6hk47uuNm1OJ64iUabf2gE6RyQJiR5I4BRjjdeHwHDnCRLxE87zsFtCTMw1l4LwGTBYDssS209U13/lj/0Leeb7VaYewdXs/WVplHrcDX7UQPapxiSu9HZXPxkAre3lVdYs3o2F5oGU8WPntUJyJ5BTrsfYwC9DH5yx9l+vPH7qQIg3gYTQgebpLk1mmZXo2GDalwVKvpA/67pvoy41YzoELhvpHnj3Rs7VVX/1w/mvlmO/09laW1kLA5W+zF5JCk1VPv2pgMbAXxQozGAYe9S8qajeE5/PlwPDGnbRtKRS7lUBDz4d9vx681dv+OE0eEw5hFcGejq2TlkQb3qFRe/roBiF2BGxgaxBTumtuFcbpQk9iFlN428LbJx/xb7X2tsQxiAtLl0et1yalxSfnLtXZPioSa/1l0abq+XwrgJ2rjHVjFhR5y2bk5TSN/sETNWqcDgQ3AVsS1a7jxynat3dK6kYgcDDBZIAOO94IrGdsncmg9GWyd4Gb4BL908Kr/VmdRUkVEmc8TtOviG8f3RxzeDlc4JHd5XeSrR87T8SoiTkfHHQBMvGKs2auo542E1V78GIett5IRm
 f+JrnI1h
 sweq6J4hjIQkrRj0C5tmx6DIgSkKBOdsOKrhd1VvNjYanNIJSCoXz2v6VhcvXGIJQmXpCEPYEj78eKdOqwe90HLHfFVu7dZrAmad5UWOVUq+qdjGvy7g8uY/DjuANgkmaeviMGXf5QvQwnpsKr8f14gao93oUcUxwS7tXcIDKIo2vyH5/D98WI0zB+WBLpSPCTYg1Xzoyc1UNsnO5ijU8Jc1WnqGZ7uys9rLxTZuMUZm+fqw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 04:55:20PM +0800, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> Commit 72797d218b43 ("mm/memcg: v1: account event registrations and drop
> world-writable cgroup.event_control") accounted cgroup v1 event
> registration allocations with GFP_KERNEL_ACCOUNT, but missed struct
> vmpressure_event.
> 
> Use GFP_KERNEL_ACCOUNT for this allocation as well.
> 
> Fixes: 72797d218b43 ("mm/memcg: v1: account event registrations and drop world-writable cgroup.event_control")
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

