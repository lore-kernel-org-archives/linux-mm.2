Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6AFED73E83
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 18:50:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08A6C6B0088; Thu, 29 Jan 2026 13:50:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 038506B0089; Thu, 29 Jan 2026 13:50:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E869C6B008A; Thu, 29 Jan 2026 13:50:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D2EA66B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 13:50:19 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 76368C153F
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 18:50:19 +0000 (UTC)
X-FDA: 84385891758.27.7AD8278
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id CD8C01C000D
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 18:50:17 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=zX5ukDmc;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769712617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A8h3CV0RSYZGyQcnni95HpkbAVa9SJQXSipav8BrWCU=;
	b=pCvaD05/zseSLvnYu7mgKOpqivsajBipI/7/z45l5wI6uZYrbtbxcF2q5zGJgmwFE1ZiRk
	1bJJ0rCRtX7PNvxdpmFsq3+gE4iwYdcfY2MzFPKjYvhdqzepZReRMXWUO4RHixMheJJZzM
	K0ruthr+pIe98CHb4kxsofv4WjGC/b0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=zX5ukDmc;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769712617; a=rsa-sha256;
	cv=none;
	b=Gnpey9m6/sFD/vQS4IKqR4BW7Zne6X/KiPsuaykv6ZcqQovexf77vyPscWpkpNFnAYuMEb
	0kRsQ9Bj3LO2OaN4nYCLxpXT4f18nXTu5NrmlGnBxaW6jE9ZTF/Ddbqe4ctlA1OZVwh82M
	gwlSlnTJIkQQf7Bll+MiGaxFczEK7j4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 000016012A;
	Thu, 29 Jan 2026 18:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EAFCC4CEF7;
	Thu, 29 Jan 2026 18:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769712616;
	bh=VGNvcdu64FETQBdDokUrI7e58s6eZHVWcch41TMEnK4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=zX5ukDmcle0ibR4bulwJp63KtfyUocBmZWuXRmY+mkh7P8Xq1ALo+4jZpXAIc2v5p
	 67pofPbXkUa3QvIBtCkHbHLi+Gxg+lfL69di78qTtzsN94cBHDV/4eTXTqsFX/FLwe
	 dn5yiGTFVTW+1cLwSi434LULu5YjuvTH5E1H1gXY=
Date: Thu, 29 Jan 2026 10:50:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@surriel.com>,
 Song Liu <songliubraving@fb.com>, Kiryl Shutsemau <kas@kernel.org>, Usama
 Arif <usamaarif642@gmail.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Meta kernel team
 <kernel-team@meta.com>, linux-mm@kvack.org, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: khugepaged: fix NR_FILE_PAGES accounting in
 collapse_file()
Message-Id: <20260129105015.0ed043764a4ad220334b7ae1@linux-foundation.org>
In-Reply-To: <20260129184054.910897-1-shakeel.butt@linux.dev>
References: <20260129184054.910897-1-shakeel.butt@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Stat-Signature: ac6j8r8akgezwguq41x6ds8tkcgeu1uq
X-Rspam-User: 
X-Rspamd-Queue-Id: CD8C01C000D
X-HE-Tag: 1769712617-157143
X-HE-Meta: U2FsdGVkX1+kOgvfhj+YowpYcwF3gp/71xItik02CZNJuFGidceqhOyaGCOWoocQ/A1a5Y0X00UqJ6y3j4DEv4/5fP5Wux1rv846iC3ztyt8SfFiMTg21QZMvKHIwCIF62yrt5wFQmHQ+vxhHV+6YkiLuGyqTTIAva9MYGcKcphQwp5zB/5pxkS7FiXIihlHzjxxtabNFhg523V55EDndz6uS41o8zLySdI3DgasrYc47WDdBobG5JmF4QJ7vfr78FOge5FWUeHjxxH/kk9Uis0/8Xu6jVjKZi4P4bAzavVhaXmeyh/WEXWjbUKyjy2raiI76PKbhz8wDJbdXhIgCp2ZocAvWzwV71BaHPQ56h1uWNbBm+dv2IE8WqZKwYsA6CL8anieD2sew4h58LRP5zTnPt4Jd5wpwOnIMuLfF10alsqdgfbtIs+i17w1scrvXGxttdd65TBOATaIuFTR6zC1G6kW9nacAgm4CTz/KWoaiLG193skn1wXxAbbCze8f1eaw8nmKtP+Mz0BAf4tGM8IMN5JA1tcokz2MnezQoRfKVrt8uU5eazV8m2fF4slSb66Xl61LTFaMSlNYQGKJCVQj5xyeLBjO/CTcOhRtwnrFxRTPi/zM2DFp8ZS8m4d47InNHIRPaN6djIxN6umk6z01juZMFB/EAyiwcDCHbW6w88NePHjpQb7V5YGJHlzgDOzvLSeK0aWxjMuZV9+NP7D/q+BvmISsWRLif1aOd14uNz3l67gn0GXAoNmnIUb3hzRQO6fbBQr2on0pT+Ny7X9E+6oeFuvJrTzi+myjlMbRNYEKWTZbImsy5JxH6ABWYuHMpObJvhat8TnNMF3B/R4eI7G3MbYkrGAw3wzVhkBo0llK06oMzHAqv3h0AploJDdBj0MIG6p8ffSXZ/TFt4zfvdTX3jEvQSZ4i6LsYZwCEiw4S8xIH89D00wN7xlyGaRHmjbfOsFpcIWTsb
 GQVt8SRV
 hVMuthMZ72pXoNpjRbnzaTqdrSQbtJXJHgUSquAx0Z7y74FX0xwBJ+sbaMUN5noVzzMrsYTQVlm6ZtlOO2W5xGBnf+sXOXXJ4NTAfv6hOf+q1SZDnbUXd7X3sBTtYypT/JLax3NiaeN6vY3HXFwh7wTWteLWYWqeuql4O0Wyol4ffWnmxtjOhpwOCyume7q74EtLiBGxtqSw1m2GYiBF8+qdTS4utQas/h0FD7rYLZqKUBbnIM4kLaoRW0Mgirsy/pHYJ4WfL2xm7vg3Mj+balPF8Zvk0vaLJmrZaGczMP5Ppyu8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 29 Jan 2026 10:40:54 -0800 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> In META's fleet, we are seeing high level cgroups with zero file memcg
> stat but their descendants have non-zero file stat. This should not be
> possible. On further inspection by looking at kernel data structures
> though drgn, it was revealed that the high level cgroups have negative
> file stat which was aggregated from their children.
> 
> Another interesting point was that this specific issue start happening
> more often as we started deploying thp-always more widely which
> indicates some correlation between file memory and THPs and indeed it
> was found that file memcg stat accounting is buggy in the collapse code
> path from the start.

So this has no known runtime effect apart from incorrect accounting?

> Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")

Should we cc:stable?



