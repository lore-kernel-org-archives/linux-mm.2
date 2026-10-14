Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E75CCC6B2D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 20:50:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 663976B0092; Wed, 14 Oct 2026 16:50:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 614A56B0095; Wed, 14 Oct 2026 16:50:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 529536B0096; Wed, 14 Oct 2026 16:50:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3206D6B0092
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 16:50:50 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BCBA01A07C2
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 20:50:49 +0000 (UTC)
X-FDA: 85322425818.19.3AFD06B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id EC51B100007
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 20:50:47 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=iyiO+vuz;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792011048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rNJFLvF4P3aKAioyvIs7zgjS8vYuL/AIz3xW41h4cLI=;
	b=aiMV9BNW0pO9KAmoB3cxjnYGvxXhbQ8EZZFrybsdk1HfSKtByfXGrEr6Kn3k4s3Wq843jc
	IYLxi06qsYrwq3cEdyfnJaFxfnD4ze+A+g85WyXcuhX/t0Ot8DBQobCgRD08xJ/n8M8tgA
	fBT0FGa5eC6Gc4/q7IQVnaXbBPe9mrI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=iyiO+vuz;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792011048;
	b=4T7MsQieiqDGlU+SOq+KACWShapjc7Q2V4gObSPm3+GVrYNF3qeVP9i08XQmHwDfAknjmJ
	5CQwAWSlJ9mFeugMrAhrrGRpyDOng12DlbfaEsoHStZt/vvZtO2EADwZymzQEAXxXA+TsB
	0FL3fwDSP6TVWlcxbxOymy2IjatqiTM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1A3FD4052C;
	Wed, 14 Oct 2026 20:50:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A16E61F000C4;
	Wed, 14 Oct 2026 20:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792011047;
	bh=rNJFLvF4P3aKAioyvIs7zgjS8vYuL/AIz3xW41h4cLI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=iyiO+vuzRlgKW3K1+bkEDfNzcyr9AHOBWIzMxQ1JJ9NF+heBdAq0HOnL41UTjtTY8
	 FkidymqWCHajYKrqOO0SRueiqUsp3+mGTkOg1/h/g/92TfwnFYDheZUZRBpg0eMrdm
	 4FpCdLiozbcVSwj3Iwyeam4uS9XXt0v+SCn2uG6A=
Date: Wed, 14 Oct 2026 13:50:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Konstantin Khorenko <khorenko@virtuozzo.com>
Cc: Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, Roman
 Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v2 0/2] mm/shrinker: make per-memcg shrinker units
 cheaper
Message-Id: <20261014135046.7b13252ce99d918ffcdb1f49@linux-foundation.org>
In-Reply-To: <20261014-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v2-0-51af2aedbe6c@virtuozzo.com>
References: <20261014-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v2-0-51af2aedbe6c@virtuozzo.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EC51B100007
X-Rspam-User: 
X-Stat-Signature: phtt9ge3hizi8mzk3cojjhutrn64gato
X-HE-Tag: 1792011047-416727
X-HE-Meta: U2FsdGVkX18+ld8IPp5n7z2tclrzfXAehwZEw+zMxWlJJqSYtss8vKYXtUORuCpiOVf2P+zmPGClN3FrLZB867vgLzMffoDL7cyy0zjAQkB3TdYhw4oSBqBkNrQfLFrjAWSmOHPFeNKa1FjNf958dRJ5mZtG1T2tJTRzg0tcsA+Q+nenl+qjxSoh3sv7G43HrAWg83t9Ln4FQfTyH1VlVMweiBjrBhoRgho7styn6LeVpZ16EzRFRCkOA3Ea7N2D2Wg/2oeB6zvWH2KYBMDCjnegyBXaPEyCQaAv+JMNIGbPTsy589UmLUxKeC7tmNa7J7Du4wTVNg0AXEM77IGUCCg/RhN95WeI+XhnNvuFWIz3wMQYdOewr7U6+wSn58cqyfSmn6D9PW4NcztujOA2a1ns/IeGs2ZeWqB6rf0Qt5UL5PgsZGqg9i6BYvKE5m5yWs4A3/rx/nzig1L3LtTDMdiTli0UngLuOUbZebmoVFinsXgljy64scsIKJkFLrasvMjWBq+yLCDwJh9uESIKNSb4Xnk02YqIykH6OKZpBuAqBr1diD3w36O8Pkl1mF6lGCEc1n5JbhXfs2j3w8iZsD6bM6qsQT59V6+YGUw3zt511cULGmqZIfTOniSdIuZ5hz/TQNWzup5xbGcIhCGNYwxQn7C/D54+EL78r8+0GmOOu4QnTVD7Z/UYYx9Jb2zbv6ykyFXeLSeconSVyjzgLr2vQNSXmHQu8l/mJ+sFNpsXnHroSxnAOsO6C0CRWNQK6mpBwdrEvJk4HmyvWOf70/12FHzsjX86tuAQP7pAjYNHeEEmh8IWfEDJRCGl0IligG9kzrDi2/q81uq2i/cBfNxsgymB9/CJW054nsJlXmmEh/bAaSGKSB6mPAcu0AFT9qzhQ1/J237ZndxIJjavBgvWRvPYuZ4OVom05X2o22LkR7ZiU4KdMbVSMddUOvipKg40KylKWiAaALkreZK
 yRhJUy9R
 936MdDtwHS+cUQIxj7EGhgrRNHtE0esGy0K8xJlAN+Y4SFhJXmcAa8NgW20USps0WkTLcXl3a06tp+oQ5VRgbyMt+hVf1nqUCjePw8RHEzQ/aE1mDAypk6SXMcvFEXE/zaOQ24ytEJ+RzazaQNWljm+cUaM0ehSBgGDkvlwVR/pHMBAbyBYaJL4EPf3BK1rhHK5J5ufwiXC9paq3Flf/ZceBb8pyQJrURJczO4XuH8sTsrt526VV6fstsDQ0p42hs4AkP2zMG2Pc+RG806+P6R5pZ/dCEkAS9C93EroxyBNuuSQnWxa7sOb9h9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 14 Oct 2026 16:54:36 +0200 Konstantin Khorenko <khorenko@virtuozzo.com> wrote:

> Every memory cgroup allocates, per NUMA node, one shrinker_info_unit
> per 64 memcg-aware shrinker ids up to shrinker_nr_max, whether or not it
> ever charges an object to those shrinkers. Every superblock registers
> such a shrinker, so the cost is
> 
>   memory cgroups x NUMA nodes x shrinker_nr_max / 64 x 1 KiB
> 
> because the unit is 520 bytes and comes from kmalloc-1k.

So we could almost halve this just by using a dedicated kmem_cache?


