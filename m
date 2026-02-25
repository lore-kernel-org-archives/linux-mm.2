Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15A3AFD45ED
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 20:14:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63C216B008A; Wed, 25 Feb 2026 15:14:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EC8F6B008C; Wed, 25 Feb 2026 15:14:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52FCE6B0092; Wed, 25 Feb 2026 15:14:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 419626B008A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 15:14:26 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D06A314073A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 20:14:25 +0000 (UTC)
X-FDA: 84484081290.27.BFC6A97
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0DDC440002
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 20:14:23 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Zclgkkzo;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772050464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t6DzpTFJIBfvdXmCcCDGOZtmv0z6aEF/BqPB0+KsIxY=;
	b=T4Pu/2k2uVVKYKMWAUgszFgTXOEkTzXF8pFWIR6f/OZwE5s/cdVWT3UAr0YkLX3m+5Ctei
	xcD/hz7IXTaTk3bIY6Dq7b7NW38z6E62uRckl+SlaU/tk5/YZuTkUmAd3E65TMocQ3Vsxk
	XqcOLKjGlr+G0WVwZQK4qfrsZ7GzLw0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Zclgkkzo;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772050464; a=rsa-sha256;
	cv=none;
	b=q1a6sSph+glcaeGuntVIHjN0SDDvLyfjLrCEvb2FFRS0hjSVwN9ctgrRBK4ts6ogLJ49AP
	TvT7hT6f2ygR2ijdp/Tl8/Z70Y7X0lJzVVomsOn0oNf3BV7UmcEOAuyq4PG66cLHR11R/o
	vqQtOeEQvzSLzquklhxS+noEjOav6lg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B3DB142B90;
	Wed, 25 Feb 2026 20:14:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2578C116D0;
	Wed, 25 Feb 2026 20:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772050462;
	bh=ZR89WZo19RbWI5s9dT12x74sNrjCq2xbeHPg2EjiXV4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Zclgkkzosw4SMxwoKAiGEH/ZbSH9lv41enOItAHjveMmmZUvHmQ8eDLlYUpQ8Dqay
	 bvcVj8hga4F1yCL5hHRS3huAelb+vI0W117kN4ZVuAI3nnfaA5MvJBqV5S+x3xJTQp
	 XPjNtQxc2PJjF8J9s365amibB7Wd3e6YgxdtlP50=
Date: Wed, 25 Feb 2026 12:14:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Steven
 Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Brendan Jackman
 <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan
 <ziy@nvidia.com>, Oscar Salvador <osalvador@suse.de>, Qi Zheng
 <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, Axel
 Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei
 Xu <weixugc@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
 kernel-team@meta.com, Benjamin Cheatham <benjamin.cheatham@amd.com>
Subject: Re: [PATCH v2 1/4] mm: introduce zone lock wrappers
Message-Id: <20260225121421.2eb75a94578af35780978851@linux-foundation.org>
In-Reply-To: <5bcc39cd3a227944d0fbe75ff86cdac92b38d4ca.1772030186.git.d@ilvokhin.com>
References: <cover.1772030186.git.d@ilvokhin.com>
	<5bcc39cd3a227944d0fbe75ff86cdac92b38d4ca.1772030186.git.d@ilvokhin.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0DDC440002
X-Stat-Signature: p1ssmu3d3yhec3mgr4d3d97tgsndf3rz
X-Rspam-User: 
X-HE-Tag: 1772050463-90518
X-HE-Meta: U2FsdGVkX185s6BBEKTrtTaDUruPSR5zinCqJRohAPqxuuy0aYqyDQGkW02sXY3eMX+aEWxh5Ph/aiC94kA+Uqo0vKEQ9pRFPB3fq5niCHYw9UEJv46TSouhxKbdQDQMdFCfj0e0lq4DIZIeRIR/gPFDeynaLdQGDiGxW58c71jSRdford7gKE+rBc0KytsHs6cZfT+fdeK6bcFtV7MvGlL0DJAIxxmtItb4zed8W5t18m1GzwPKiACFJ/GjTWn/Ds4NYdrInVp5CGG25CbK6UYHWfxostG3sCfzK6PUdBamPhorLp6uRSN3L3LYydcC7vYExyvULWYtJVoQTQV5RM4yZ61a+xvCUlimtV9gFX442B/himv0Rkn/DDst+n2wl/hBIWuxD2E5ZoF1Uc0zhSiAfRxO+iPczR003INIyQ5YZfPlJYI7nC694Gj88bj7zj8JykCawWHBgBJdtGjW3gJwhW6sh++AjzCvHy/oR3HdMCcwRikkljqxkmxQ2xLdyMLr9xIJAgrYY9gEsCXe3PyOaAt6rdbLuK61dKCnO2IwBLHGOivnxkWQR/wN5AEfEPUBYR6DPPkevwICs0t8Bq2GVIcd62JRznuv5lIsQya+Yk4Bilehxo9EHbR4GfG4Z5BgAMgh+/z0wcRZBrmxOYLhfWJYeBHiWmo3MQMgnTMqXacMAwgm2jN4GSDs197c+9ljUhO95bTECv1aTMx9WA4e3dlhGNAlxYVswSwqzc4QYu9s9+9iUX8gC5ZUYNZVt9xGpZ2F8QGOYK1kGbSo4915sHEvsZtdPoEiFNoTU8QM73ksHeIW5W/vx9Y2IcMzxhas+0LGlxkzV7vB6MUZdSNpnN1zSngeXHbIu5z+mn0GDX2JghMI7wPaCY9DxS+YMmk6WxXbMevZJzH1hVPyjEH17w1ViS2+8JqlvQVKFmv4k2f8H2rUGqzVsBEyf1QQj+c0lXXcsIM5s3z7PMQ
 mSV4ux3x
 ADyrNiUwAx0/3tcpAScXkY/RY+5Y6nbLeAuz3+FyYhYU9BnVA9tBT9ZfoE1qziLAsg6DtoCpJlslf16eh6ZyyfujL1Vn5Bo2FWlKAolPe9lfhWu5bJqPirgBJXXYOtrf+V0uULUOLVP7y5RCRK231mr4C9f+bFcyN6ydqHrUMlfDibUrhWcedcFLMyK4WvxB0Aj7Nk/gbSPhU8s7KFbxQVHQhy3x4NefpYFgUHXC0gIQJs2RK/Gjcd2PkAgY5heDQWnrOTxkD/pEIdvgTofpAJ2E/ltkkBmkN//qakFDAkEYRyB4GS6uq82DhjA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 25 Feb 2026 14:43:03 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:

> Add thin wrappers around zone lock acquire/release operations. This
> prepares the code for future tracepoint instrumentation without
> modifying individual call sites.
> 
> Centralizing zone lock operations behind wrappers allows future
> instrumentation or debugging hooks to be added without touching
> all users.
> 
> No functional change intended. The wrappers are introduced in
> preparation for subsequent patches and are not yet used.
> 
> ...
>
> +static inline void zone_lock_init(struct zone *zone)
> +{
> +	spin_lock_init(&zone->lock);
> +}

Please consider renaming zone.lock to something else (_lock would be
conventional) so that any present and future and out-of-tree
unconverted code won't compile.


