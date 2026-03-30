Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 892D91061B1C
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 19:02:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C75AF6B008C; Mon, 30 Mar 2026 15:02:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4D606B0095; Mon, 30 Mar 2026 15:02:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B63416B0096; Mon, 30 Mar 2026 15:02:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A2A176B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 15:02:53 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4039DE0C04
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 19:02:53 +0000 (UTC)
X-FDA: 84603651426.19.D032418
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9430480005
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 19:02:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SOC1y4Yd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774897370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jD/E7d7j6MkqANMDt/AqL9jdwppuHxpcNjpbIzxXLog=;
	b=CzSvqQ6T63X/fH9ax+S1HRew37VZRIneAmkKyJw5P8hF4jm6SHHupoSf2Pl+heOmISC3PG
	ZuCirARRfAAEjXND+duHnmkMxQ3tJDDDS6N78Y//Fu+fX/GN66GymcIMkJyKZbG9l6ebXK
	R8QbKc+ZHjhDEe0IGHX1x7PA5grDRUM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774897371; a=rsa-sha256;
	cv=none;
	b=3oAnMNOIrblroba1p8U1j1x+ltlvb6/uQ++B0tzdecgasuuiPxqe3qqDuwys1EP8FjSRrS
	SOmNkMgrjGMctRaoqRQd8Uv+uKofPeLxs7eg0SZK2Al+Ia6X158aoZ/ZKbm0/+vMHEmnmW
	/5JHvmusp7QrCM1V4SS4b9kKIsCFd9w=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SOC1y4Yd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A59624455A
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 19:02:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 819D9C2BCC4
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 19:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774897369;
	bh=V8UjiYxzfl/lZG1iwhIdVcgUjo7J2faQ/Wnx1HhOfRI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=SOC1y4YdF+TE8yz5hNlXQ4JYtHhx8XCf13Ewvl3BZpJHD4HFntapHnOun+DQ1YiU6
	 sRBl0hbkAjT6GAtlyFdkJJFbBPUMs0ZNO4G94SE7JQRcmzFdh7Nx3E3bHdTfE5NZRf
	 eKDVMk038Ga0vDeZjdqbhQ2aVJ06JSxxuXgrJD98DVaGxArBW9tx40bADmb9Xqzl63
	 HgX1XbA1e5oa9k5lcIEaEWS8uiE68t1s3i5BM+90h9MfNUy91SPs+yCUMU0WqJvGaw
	 L26RWxif6II6ufNLGtCKuoT0XuQ6IXOYK9YUZwhjueZi8UgjGqwJHRfZuSRqOud4kO
	 vRpBHAklN3S3Q==
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-66c3635d758so88613a12.3
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 12:02:49 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCX7knalo8xjK6GwflL+QEol2nbqXu32v3rYVgsTZFEstvrlxMfOOEoCU1y2eicAH5fopBpiGGAZmw==@kvack.org
X-Gm-Message-State: AOJu0Yzi0ywunEJXPHtxu7qOs1ptBxg08538tjqHoz9+qRI2UAPRapVA
	uZyKdP2B2gxmY4hunzVOLCohQmKyQnBOjrub/uaYLb2d2DQHnMnZhi4OVAnaFDb6ns7GOqA38ez
	eiHeHu76pJSR1mzHyEiAZOltRyxumQZc=
X-Received: by 2002:a17:907:cb13:b0:b96:e3db:9e04 with SMTP id
 a640c23a62f3a-b9b5094edf8mr570685066b.53.1774897368210; Mon, 30 Mar 2026
 12:02:48 -0700 (PDT)
MIME-Version: 1.0
References: <CAO9r8zOKaPocJYMKL=A=6=qpWgwCa=fMC8EZsSW+632M1q1sZg@mail.gmail.com>
 <20260330185947.2427740-1-joshua.hahnjy@gmail.com>
In-Reply-To: <20260330185947.2427740-1-joshua.hahnjy@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 30 Mar 2026 12:02:35 -0700
X-Gmail-Original-Message-ID: <CAO9r8zM1My0cdMV4NomHL-zyconjjq6dP5iSqOyWm10Gnfe7fw@mail.gmail.com>
X-Gm-Features: AQROBzD5Q4JVONjgLXuHQnh-7_hxGvOUjkM2GvDUWYmix-4crTfbUhCwaZZfCG4
Message-ID: <CAO9r8zM1My0cdMV4NomHL-zyconjjq6dP5iSqOyWm10Gnfe7fw@mail.gmail.com>
Subject: Re: [PATCH] mm/percpu, memcontrol: Per-memcg-lruvec percpu accounting
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 9430480005
X-Stat-Signature: nwsshmkknbx8dhi3udk8pwaag7khuabs
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774897370-672782
X-HE-Meta: U2FsdGVkX1+gVXSihhtP0sze/EQzPwqSgu6zqggy1IIHtJTu96DVVAojvwEL4/vF7IutowIBi1HxafmuUdB3kRfn2WfsRlOJqNa/CyzQRXl4oiaHZMd2rXo9SgDC4KkKoQbf/Yb1XUqmtOAXMDWIrkYDvlYiDY6DnFVmPAITkVs3mCfEAXYuDAeHx5cjNuePA7Hds1sIi8gevI/PVlLNeU2KVZ2p1qx09ae6t0WWp/bM59T/k5NM8hrwlWpGyWjDcf0SBzi/f9qVigexF9L6g0oh+mEGTmiILzjyWJP+HtfHAeHl8m6+VQIpTpxP7+RdUKv2RQwCmWWb5FU9ubqvkZsyES/CDsUwd6MNcO9C2gcrocSPlBqfHM09bWOIGhk7GAHkqhjlAGl2oo4zyvXbhUlnQVoIr/BJCfG3wD5k6eAt5MkBfZFs4eHK8vhogFE0TZhENHk05eUhSx65ApfEvStirsuZ+zHKKWgDBycxOKfjjUUiPyl+wUnEbOvrYhEvocD7+1JIGAOOCi+SwKxEBXm1C5DQiOVyDPP/Q+AnRade/ZcraKBg66TgOU1FA6n4LNHFvtIdeWVmLbeHv2HbfOWHozWo0rB7AL8uKegXBs19Xpmw899sIILSy1A0c/UGa4lEDmxtGnDvlqLfrDLcLTp/X4DFE7LXOLuaxE7EKeP7uHJm+trKDithY+9VGLtcavj9CfY1qHvmbLtxnsvuhgmb4JLMvQZGMQmp95nKHJzcR8JH1LMi7D8tdjRsFVqTR2euO2qHZNosqU2ft029qJrVL8DgeXTFMMzQVqBOt4bKe13207AmbLpOLLzLwbZpxpq3+s9A9jtsS23aXKA7R398TmxGXVbvK+OYAb/AKHTBQ35lD/qQjY2ashJ/U8PXWW6RQjXac50m6BJapl/epUlPKjFBeSmPUyLxAUPvJf+GYULFAv1rHkDlVr+N7D6xxbGUiYl/H2c3Yd0u2ax
 lC4TGMhB
 vWx0uYTQVBAtyD7Alhx3sadT9RjaQ7h6exMjaxcL2Dw+u6Mdk2fSV06bYIol57fFX2MpVNIp+4AEjS5ylHM4+gNBAe8HApAedX55q4QoLvccaIjQIv9MFzPCd0FgTp7wpYgavwrD/xrHvRfMPo1AmpI+KbFudbjaSG60Gknrlv6CzAratVVcmXVSOcli3djCycd3MHMSEVC0t14m3VkLzgVdj1ulkva06h5W+8NZLH0gZoEz5oTyEoG4Vw4bpnwv5v+mGjU6prmQt5MRCH13bGJ4P1L+XWdq1GrglwTK/qYRAhwyfo/WHSPMk3/f8Lop6jws6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > You should probably also speak to extra memory overhead to move all
> > these stats from per-memcg to per-lruvec.
>
> Hello Yosry,
>
> Thank you for your feedback!
>
> Here are the things that I cna see from my end:
> - NR_PERCPU_B adds a byte per-node, per-cpu. I think this is manageable.
> - lruvec_stats_percpu grows by 1 long in 2 arrays (state, state_prev) since
>   NR_MEMCG_NODE_STAT_ITEMS grows by 1 from ~30. This is +16 bytes per
>   cgroup x node x CPU. Even still, I'm not sure this is too concerning,
>   on a host with 300 CPUs across 2 nodes with 100 cgroups (theoretical)
>   we would see a 16 * 300 * 2 * 100 = 937 kB change, less than a mB (and
>   I think this would be considered a big machine).
>
> What do you think? Do these numbers look acceptable?

Oh I wasn't trying to say whether this is acceptable or not, just that
this is a relevant context that should be included to help people see
the tradeoff clearly and make a decision.

>
> Thanks again for your insights, I hope you have a great day : -)
> Joshua
>

