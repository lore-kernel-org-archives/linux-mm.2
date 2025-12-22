Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E652E67496
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 03:49:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5F0D6B008A; Sun, 21 Dec 2025 22:49:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B087E6B008C; Sun, 21 Dec 2025 22:49:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2F576B0092; Sun, 21 Dec 2025 22:49:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 934F06B008A
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 22:49:41 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 309D713BF9C
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 03:49:41 +0000 (UTC)
X-FDA: 84245727762.30.5F1982D
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6461D40002
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 03:49:39 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CubJn3AN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766375379; a=rsa-sha256;
	cv=none;
	b=Q8eUY2CnqoQoTP7bGpo58RelJ+m0aUP+wwYOIpzvzIoqIEZiiDArW8mPyDU6xzjJk5XY70
	re+QCvk4Rbvyx7NCav+0n7WrmYgLuBUPG1KDGjg3dDV8KJ5HgPWA7PnnaWnxWn499vD4QU
	fKX81Qx3oggV3KzIfQ6cCzilwe9b2CI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CubJn3AN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766375379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TWtO2zr1nSZbFFTYCOCRQr/+4k/J53t+G3n+jZ7uCYk=;
	b=QiSFlB3v5zx3ypGIRxyKsQMz6oVqot0iHWR+0SaKmKwMUtvaIPb5U+JPDIB/1hEXiu7HyL
	WKUOI7MzSZ1JS87rRdvqIfZBFuGp7BlqOMnbTWc2fWQ/YGk8DqNFtCX16A3IrGFWrN5vQa
	07rpwlR9PBAGa+bfJ8RjU7TvCh436B4=
Date: Sun, 21 Dec 2025 19:49:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766375377;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TWtO2zr1nSZbFFTYCOCRQr/+4k/J53t+G3n+jZ7uCYk=;
	b=CubJn3ANnS6RtnAXOMiFKILfrbjbKzo5g8zBWH1n9uvolk/8eBB55AkKcKKq59hn8ynGkG
	IguJvE3mlAc4K6URHr9stf72+kL03aeSVq2yeoMTSIoGGsY0gunvROZsBErbArNjOvbPP2
	eLZIS9vLy48ZSaGr/0S20xmoUHX88Gg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, david@kernel.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, corbet@lwn.net, hannes@cmpxchg.org, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, zhengqi.arch@bytedance.com, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	lujialin4@huawei.com, zhongjinji@honor.com
Subject: Re: [PATCH -next 3/5] mm/mglru: extend shrink_one for both lrugen
 and non-lrugen
Message-ID: <7oyimceude4iqtc6z6e2l2l2em236qa3s6r5daf4c64mzmafp5@s5ayqhbow7s4>
References: <20251209012557.1949239-1-chenridong@huaweicloud.com>
 <20251209012557.1949239-4-chenridong@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251209012557.1949239-4-chenridong@huaweicloud.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 6461D40002
X-Rspamd-Server: rspam10
X-Stat-Signature: mzrd3rp4hw3d9emm43h3ocij77ccsyff
X-HE-Tag: 1766375379-348002
X-HE-Meta: U2FsdGVkX18lMXcR3gfhdefN9+xJYXcMSObo6/hNUKupupvjfbWLS5+KpV+Od/HGKrYBgoIPrTC6UvB9d6xBJJBaPAFvIEkqVtSTzsvQPBwfXei1dfwPCyb6PDFRgcnFJeS6ggMjXNOxJxV7aF/a/zOj2Vzob2pHEjZIAASAurwKdwL8FdQBT9nVs4pRssPKX3uedTnT8F14X4t8o8/HpZ+CIW/Nm+eCKwz8Fiiyze+ZcEaZ3MG5Wru9sCelxSEGAlh4q5KYLaCgCf6o3T6f4LeHVTaPyVrDchyFxE7XWCBCGmRg2stGA/3otKdoZSr7SuaiAx+ffEiPFsdo5C3/HN2iSFPkijasOSiBQD6ccZvFOcpmbZnOJ/7RRRUJ6TslQyTih4GGOMSQG8SICgAGGPSbiTNxTUOR3HY+RMBm5HzBeJIW1yXr6QzLDOOIOwThOkcWkgtbdlDf6lQCgB4sdcT0d2tp4y8h0x0T/e4AOGMiQ8WPYIpNLsFcBrWiNDSXHzGqNY8TcbHbNhsXhH2zqKFXq16q2C2NM6PGwzJWhhn2YMxEb96I2aJJdoSzYrvEY6OxAmoO+FwZeSNe3ql6o7qtcHgKnz0HRLKiXfFPyv++kZoLkLmJKaEPOhGCrNyibu+Sd9A0m4904jnpIdtuE5yJE9SFP27jmtkgyxRfxCj5qwUkPiXp6zfc1oW1jvOgqaebXwm8uV9kgFRHh/J24c/qu98SWyvuRm6LW8BISy4tZnBu9LIMJnNP9ufNQKfa/9CncXIexouuz1OkZkE5kcMGpB19XHoBULUY0WK754iNNP+ua2uxCKup4lK3sOsDlkigrVeo/OSGhhb1GNns0Xwp3dZ66aLoqRpWJDSeJp208v8lbFJ589OZvQ515Rxib1g9gCoP2WoJ6+a9CBUqBU47zo71Er52W64lr7qydLBQMjshfdAhV3QyC2eAr6mwVW7fM0qrqyJf3KOKnfc
 jhzjWkaT
 6v/q2gyVzWnjjQmbTd5hBRnBJSqUN9h+YElsHt9se5++7sazEvRYcp2NhMWzlw6c8/C7FfjhnK83EouFk5aSQxpf1BclbO4PNvFfAL46KQgzXuhE62cJeGMCYUcEkhcA1Y2mAoSi57M9ShDtTUwSa9sckinLd+0y3M36uqNHNy4NUXuO3xCxUpFlrMb1jR0ytiv2D5+SyeOb6EszjppuelA5xduZq0l88WVb0u2hDmCP3GgeZ5N1oFEJHk9RpZooYk+vBa0GmMbA54ve3KhuLKBl+2A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 09, 2025 at 01:25:55AM +0000, Chen Ridong wrote:
> From: Chen Ridong <chenridong@huawei.com>
> 
> Currently, flush_reclaim_state is placed differently between
> shrink_node_memcgs and shrink_many. shrink_many (only used for gen-LRU)
> calls it after each lruvec is shrunk, while shrink_node_memcgs calls it
> only after all lruvecs have been shrunk.
> 
> This patch moves flush_reclaim_state into shrink_node_memcgs and calls it
> after each lruvec. This unifies the behavior and is reasonable because:
> 
> 1. flush_reclaim_state adds current->reclaim_state->reclaimed to
>    sc->nr_reclaimed.
> 2. For non-MGLRU root reclaim, this can help stop the iteration earlier
>    when nr_to_reclaim is reached.
> 3. For non-root reclaim, the effect is negligible since flush_reclaim_state
>    does nothing in that case.

Please decouple flush_reclaim_state() changes in a separate patch i.e.
making calls to flush_reclaim_state() similar for MGLRU and non-MGLRU.

For the remaining of the patch, I will respond on the other email chain.

