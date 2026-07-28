Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F4A2C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 18:14:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 259B86B007B; Tue, 28 Jul 2026 14:14:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20AC16B0088; Tue, 28 Jul 2026 14:14:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1213E6B008A; Tue, 28 Jul 2026 14:14:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E4CD36B007B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 14:14:06 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 811511604B6
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 18:14:06 +0000 (UTC)
X-FDA: 85038984492.19.D60407F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0B624A0014
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 18:14:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uVlFin9N;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785262444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+ZFYgbMscTxKl2N5edqmiBv+0wqvhHMyXWYcOzOEkCA=;
	b=ZIO1amgvwTr7SXbeD+cCNQFtCEbRsMQNakwiZi0tRUxWbEzzI7Z1LJRbwL83Yo7rzEIx6v
	/gHZqmvERM/FHR9hLAFfB/Rk0XRIxtcnvPSOKGvCSNdZ+q/nlng0mscjvuIbGjqfALr7mx
	bFbxROjq4O3lnvcxONZSMU3GNlBpvac=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785262444;
	b=URDzFaey4KBFckCuDlCp30U8v/3moCYaEcq/I6ecMDK626m4/wVSmdelDVkpRF4xP5J/qI
	kRvsyjiBAWH0Q1ioVNjkrv1tXSAdYxVmKimoRSIIYYwOaasW4PWAJa2Y9fIMWjZmifke5k
	JBeA4Eg046dXd5/FE+2r9fdzReBmYSc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uVlFin9N;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CDAF743DF3;
	Tue, 28 Jul 2026 18:14:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA0521F000E9;
	Tue, 28 Jul 2026 18:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785262442;
	bh=+ZFYgbMscTxKl2N5edqmiBv+0wqvhHMyXWYcOzOEkCA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=uVlFin9NaQO02f/q+7PNGgLIJYBRJQIYi0gagBOuO70msmqMz4oEYkcjF2LNU9ONq
	 Oidv3w40921MVxKzwvm4VuP4XBPy0a2EIlJkwxR9qLJD050XcUQwG6sijn+2keRlux
	 B+kQJ01M4VXppv+f6itvk88eLOE9v7vnZ/ZsP/j0=
Date: Tue, 28 Jul 2026 11:14:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bharata B Rao <bharata@amd.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
 <Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
 <gourry@gourry.net>, <mgorman@techsingularity.net>, <mingo@redhat.com>,
 <peterz@infradead.org>, <raghavendra.kt@amd.com>, <riel@surriel.com>,
 <rientjes@google.com>, <sj@kernel.org>, <weixugc@google.com>,
 <willy@infradead.org>, <ying.huang@linux.alibaba.com>, <ziy@nvidia.com>,
 <dave@stgolabs.net>, <nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>,
 <yiannis@zptcorp.com>, <david@kernel.org>, <byungchul@sk.com>,
 <kinseyho@google.com>, <joshua.hahnjy@gmail.com>, <yuanchu@google.com>,
 <balbirs@nvidia.com>, <alok.rathore@samsung.com>, <shivankg@amd.com>,
 <donettom@linux.ibm.com>
Subject: Re: [PATCH v8 0/8] mm: Hot page tracking and promotion
 infrastructure
Message-Id: <20260728111401.b6d674baf8e56a27c55e0c52@linux-foundation.org>
In-Reply-To: <20260728054356.291998-1-bharata@amd.com>
References: <20260728054356.291998-1-bharata@amd.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0B624A0014
X-Stat-Signature: 6a5ptw11xahyqcmps716e54tumjfgqkt
X-Rspam-User: 
X-HE-Tag: 1785262443-535891
X-HE-Meta: U2FsdGVkX18Fzwge1VjKYdJEU1prE5TtIJYIPoJcZdbdpBjE2BJcMdJnwFjT+Elh88VJhQaAQI+aj0H273Xp76PfzAJVflDwyC01Sv14wSInHtK5DyvppYeOqOS9BPlX9BwlkfAOi/8vKKu4DGXS2hVjZAm8mG+JgktseWg4BD0M3kp0Olj5AFK7wSe5X13YEEFDM+k5JtCHEUoYZMIw7x8Jxo3HsqM/n2HLLElpXQugkgTkpNaYX5qR0/CXaeDowv4xG5JWsX8x+EojqAKONwHog/MR772u+3cwde+fvIM+ceSk4UmR9+9Q9yTZju/7fQNrA6s9JG/034PjVz5bLLJ+zZ0Re5T9lA/jP2VfUU1PEZ/L1XFLTf+1TEZdt8tNaUDn5kGjugOTnyCpqJTvXMOdjPgL0umgWwnvERyJn88FykiCDTNM4UVkvocXjytgAQ5Sqgoln813eOW45Nn4gDpvaatEWBIfPln4LwOG7Fov1R4GTpb3MsJeStsLlY5b0kwcgY/BNeE5tymwJlPMwI+cYxCE7pVYb4jm/X/Nd8j08aH4BBt+gR/KS8z0WPq7SVo/CuhdajScrLjBW7MZOifBpM9+qCxWKZyxSs8Z3aLhi0fXgfxm/oRlBGRr0UV114oZVroorWuz+ftYAatNOVZB28jPan1g65VL8chLFZE5AZUf0Wfa7j9j8vecWLv/J3wkz8l3o1Y+NHRILIdWD0ugq6HPHN3l9zJON1BaA3xilnzPjmd/rGMNxxeOnQKKs1xq541LLn/Ra4qemsGLjsmo/jkJSEisct7bALkDyHJ7dHNG3f2nrkvC/5cwSCMlZtaQL6ZTzlSCIElADewegOqJhv8krGKXMjktpeZylw5W20FqirpkeYZBJGeJzf1Xh16QJ2n4qEsLuiLHrC0EwUYoNIGdjklCuU3RE0bNZJlVGXbqwLpZRcPbWMscYISipc5U9FrvV1FwKecOnxv
 kzsaF3Wg
 aNez/3HqWeA/WUEtB8RYog/LU0I5y7WBRAjkMaZ+USjJ8WK5AxCPBULT57A/RwuyfUa7VimzQ8sI9ylYi9Ry/XpH5w1GLuHAEuXaVt5mql9Shpt6l0cAqiiLAKpjME29A2AY98rc6OUq1o51Iw5YWU1n5PXNUuFPAKUgIaRHwdM+eeLSNKY1EjZ8a0GqfwX977ekqcTpnnoYMCuUbX4spR2ABF/OMX9uGQj03CDZbEWwiVNgAZu2szQBr8qmhneYIGoftk3EpknTZuzHf1OEMVzSJWq1RZo4g1vCWieqrMVH9J0dTDC2gNV40eGFdNcbTKv/b+3NWqyDZHu5VES7VyinHfD1l06yzFa/NF7scmEW1xAMd9gjocwNJ9l+K+gL1ecAw0OdjOmCfQIxkVK0HL2/U59UC/rSXCw0Anh84GRa//nG6JxOBnV7KkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 28 Jul 2026 11:13:48 +0530 Bharata B Rao <bharata@amd.com> wrote:

> This patchset introduces pghot, a subsystem for hot page tracking and
> promotion.

Can DAMON be used to do this sort of thing adequately?

Thanks, I'll await review input on this.

AI review had much to say:
	https://sashiko.dev/#/patchset/20260728054356.291998-1-bharata@amd.com

