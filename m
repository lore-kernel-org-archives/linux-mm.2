Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF746C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 19:48:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9F3F6B009D; Tue,  7 Jul 2026 15:48:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B78BA6B009E; Tue,  7 Jul 2026 15:48:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8DA76B00B4; Tue,  7 Jul 2026 15:48:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7DDB66B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:48:29 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DD1CC40573
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:48:28 +0000 (UTC)
X-FDA: 84963017496.15.123B18E
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7E748C000A
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:48:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ts+EhNAt;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783453707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w6YdfinE5Y+gd0K7HnYdBuEHkj0MV+94snnoeWtOoto=;
	b=Ji/GWz0BRD/1kZbILaGMvnJyg3WgaiVahCox47/J8YeEXK4zjbdt4MlEiaQnm6EJFU+lK/
	WW1HSa9yHgsaIkvMABHRlmtvG93R/RzTGCCUbY9XE/5/MUTA+wU5ss211pCCvYwshypt8o
	E0mB2grEOx7YDqsgiLkqaT7tdG75Cr0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ts+EhNAt;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783453707;
	b=0yrHnL54B0eIRvOO+mdnSTpl0Y+SFtk8eOr4VThq+P9XBocxVemF3pMVQAXsa84kSN3kGy
	gEvIKoDFNymVF9lPAL6Vdwk16xfML0uosnmHVj3DJiSLwYCk846R1IZNbgV3zy9iDUtTf6
	v5trfKTcfyeN//wRdfmuDQ2ryWAdhtE=
Date: Tue, 7 Jul 2026 12:48:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783453703;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w6YdfinE5Y+gd0K7HnYdBuEHkj0MV+94snnoeWtOoto=;
	b=ts+EhNAtWEHYnnXybG3Wwt1iiidVRm+7gyatv3dOousgSi3tqLDNvwRcicdMGKxA337aKI
	1ckftnguaMosnMOhatU2126ySVCnWfLr1gHqAb3Bhq+j2SD9ICGaMp7Z6h9cGxAaOAAIp0
	Q1w+A3G4+M6mQFMNLaJznQHkn1MCCzQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Richard Chang <richardycc@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, "T . J . Mercier" <tjmercier@google.com>, 
	Martin Liu <liumartin@google.com>, Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: vmscan: abort proactive reclaim early when freezing
Message-ID: <ak1XzPxbwBF72d1m@linux.dev>
References: <20260706081218.3438762-1-richardycc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260706081218.3438762-1-richardycc@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7E748C000A
X-Stat-Signature: ohc1y3wahwz4115yncf4ti6zkb668izz
X-HE-Tag: 1783453706-82857
X-HE-Meta: U2FsdGVkX1/V05/ZXS8Eil/eh/VFJ8ameHvNwY/rfY8JdObSiEZo0Er7ZfJB6jePtVX6oNYTIYwQageR/MOxUb2bHHNpbDhMANtySKNrHq6Oh4C3waIlcyyDGEBIy+m43h2S3Rd6Mvbt3ziEfFzklagmkPeuliPAFNuLy3w9+hta2kvpAL9Ceq4+LusIk1XC5RA9TbgMgfVQ3mpyvgS7XKEcZ280rQpvvyhoR1YIHZacPZeWa1t5T1gvrTOLipyHRcvQ2UX4KS4pgbPEUHNRMNl3yPy1M5pVFTo4UWJeZ9SA/Ahy9Ni3FroznSxq8eh7sBI1Qm0wdbiFxIbUb17h2XS705aENhiOshmu1Z2rNo9HJtynHL4P69nJiN5Tx6No/2uoWL1vr031XhLtUtd/p8D0CVqcE4LSt9cNBy/eY0cah85kBEsyD5bQd7Q/eTXR4/JLX3Z366AsxEaHLlWNBwPKTQU++8MAD71Kt4eDiuGWi+f+LyFT3oMOwoF0X+OaOkZJ8G/CwAFjm2jvU2JAPprRjPS/O7s8OQQo5nYI4izIpmPJKA1F4AMrvSn78skkG5YXZGrtmcSQ/dOf0k7riaQcvIUbsP7N/6HtT23v1VMBWsNjsZ0ZsJnw9Nwk5jY0juRQm3KoyyfCmWYn5aVpt8fBIW2yIJaXxRez5iHO/8ExTlVoOOwQgejsVxRoZKPTgoCH7C+cKF7IstjwHnL2olUHcMwzTnxkCAIa4PfeUnPRMrPRLXsVVF4L68dv8q8iNDrPG5g2CLC8IcJIXMPO2KgbMS8DA3tCXzngT3lP6F+WmreRgDfedRuP8jGQScPFPWImok6WEfcij2csOfCCfkcchx25uj/yr62HeYo2XJzWrrHaZdRxe8FqUbu6Y1/I3k5IyaU1xdfTPjhxBEZNfx+oRwrMQDIzF3TU9SesZL1EfnJXP0bwD8XqpIWKVh8E1Yj7upkBwBPo6QLf4qC
 S8JYTJWW
 Tb7P3JUQAjwMPLXUj5OtoJe4W6jNZdYTNZ9P/dchSZp1FwAHSomS8mJ8I40WneDbUJrrBWaEriJoatv0vYJBtls0BQ/JslScmgR+P+Ks1z8J47qPdd8BFie1G96+k+djifYwy4seDyzIh1VY9IDPySCHiePCK/gDqMyIszwibtGYJqp22aVUL/zytdvohQQa23JEFY+4HoInMsxs5XD7i+YjEgNecjNdln1djF2Z3rGlbhW0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 06, 2026 at 08:12:18AM +0000, Richard Chang wrote:
> Proactive reclaim (via memory.reclaim or node reclaim) checks for pending
> signals in its outer loop in user_proactive_reclaim(). However, the inner
> reclaim loops—scanning cgroups in shrink_many() and evicting folios in
> try_to_shrink_lruvec() can run for a long time before returning to the
> outer loop, especially on systems with many cgroups or large memory sizes.
> 
> This latency in responding to signals can block the freezer (both cgroup
> freezer and system suspend), leading to freezer timeouts. This issue was
> specifically observed on Android when attempting to freeze background
> cgroups while proactive reclaim was active.
> 

Can you please explain how freezing operation was delayed due to proactive
reclaim? 


