Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF2DDD11704
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 16:08:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E0CB6B0026; Tue,  2 Dec 2025 11:08:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B7B76B0027; Tue,  2 Dec 2025 11:08:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F4A36B0028; Tue,  2 Dec 2025 11:08:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 11CEA6B0026
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 11:08:33 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C136FC0148
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 16:08:32 +0000 (UTC)
X-FDA: 84175013664.01.8236A77
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0731714000B
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 16:08:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Y0RcuWOU;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764691711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AxYnZ3DcAYZN6exEXvCVyOz/bBfugXcxeWApesjtppI=;
	b=c6gIAPACtkknoVOu4cxhBw3iIVnMpum3xivdKIvbUlqn6k4eAuFEdwZj16mQnX6CRBm8c9
	Hruji3Db+SxxWIaIVRXABiSzHmtOS2eOmSm73EpRAnAj2v/c1CFrxqFr09Rn/d7gxHMGYn
	hjqsOT8eKdKcM8EtjgluTzgakL9VdX8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764691711; a=rsa-sha256;
	cv=none;
	b=bCA25DXBntMxLFJjsvvDe8r+VEamdcnUjSb7Fu4e/7pO+BdLA0NkFVuUmYBfYZCBcXWHYg
	f5F3x2NEHuAkjN64Gw5n+1byTYUtdSfgwB1sUTMGfvJgPvy5DbVR5xFKEujeR8rW5WQbN5
	E+5F/crxRtNJzHNtyI0jsI5cVlryfb8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Y0RcuWOU;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Tue, 2 Dec 2025 08:08:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764691707;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AxYnZ3DcAYZN6exEXvCVyOz/bBfugXcxeWApesjtppI=;
	b=Y0RcuWOU2Tiiv1djdr/LQ6eEENhEJga8bTu9p9hWPgTUYmQ/vOrK7vo4UtYotQYM2xjBv6
	uYRw5P3VSDZGKgz1+ETzvodZUGdK53XxzKOcOiU025/g1uEHf/ITL0caUJh15QUrBbLP0t
	0IUSq+EAbm3wHGt3guHwOnkFGRoOlIg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, tj@kernel.org, mkoutny@suse.com, akpm@linux-foundation.org, 
	vbabka@suse.cz, surenb@google.com, jackmanb@google.com, ziy@nvidia.com, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, lujialin4@huawei.com, chenridong@huawei.com
Subject: Re: [PATCH -next] cgroup: switch to css_is_online() helper
Message-ID: <ep2hqjcg4t5drnfms3cygtcuotqca5ftzw4zanepteyjlxexpx@6ad6mqxs7stb>
References: <20251202025747.1658159-1-chenridong@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251202025747.1658159-1-chenridong@huaweicloud.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 0731714000B
X-Stat-Signature: utsiccihoebi7qyt9w5byzuaouci9xd4
X-HE-Tag: 1764691710-481235
X-HE-Meta: U2FsdGVkX18lDrTq4RU5XRfY3ZRl1EqxEowWg3mJSG637hoQJHqNbYi3W/+bNK3OFQe6KJvCF414uum/+D2pM8GWQsQrUKSJbE6ovKyyltsMF2lF7At6UKEH/+/p8Y8SsWM/HY5Cdn5FXZK/t6KNvXoBaCVdx9bu3mGRtv1mMCxf4IC16n4KgUO3ANXfxHG9SjnUIPXuAEgPybJu4WGkvsYcidnaRoDGMcuwVBGqJdJTnkCzF50RN602xZ0PNvFzLS/UXISSJlKIJsHjPBL07hS1bKySwNDaOEU1tystJklplPRhYHFRqGuycArUP7qKHfBjGyEmtMsF+i4LMBHc2/gWgdW5gDcLtOyLiUlII07ED/hOc2TknW6vdBUT0Na9VXeT+6VbzHa0QKNTpSpe5NChDNk0+S1+aQHvpz447BWm25aA1iBpBehr57BXad9XjAWGEgrQty2+fOSRyO/5ar85guRAxybR+34Fg27ZruJLsxKp9y9BXYk5i1hKBKz5WNhw0Or3eo1wapz1WlO7koVUMGqoIVQywx5AUKm4cM0QcFIknvyqNchF1nNEcGHvxvPn9OjwGYi/FTbuvLsgU88Vh253vv1yHPE9eNdZDNw7prSITeJn+XxbiQx/IVaBR6JYOMXGhqbcadTNzU/i7+0Jo1hEjuErUTEOHbwLxg6KlhcUlpq2Y2//HypM6j7yDKJYdVMTF7SPn/7ftYXoe5jycslrgcEXxfc3Ex20HPZ52p5ipwjmnEA2QHnWA5Kmz9z/AfKYARmrZfZXNf9u4xVoFIX0El+bQZATfxbPq64FZ+TWNSOjgQFyrrwHMVa2Q/pGJyVqwZrRJDlqUWx42a7/Pt3nqVCApku2SO8SJ0Sza0Y5Sk5DkLIWF0Ffw7oQagyQxKc8rWzuA8VySztfzuax+l370DXz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 02, 2025 at 02:57:47AM +0000, Chen Ridong wrote:
> From: Chen Ridong <chenridong@huawei.com>
> 
> Use the new css_is_online() helper that has been introduced to check css
> online state, instead of testing the CSS_ONLINE flag directly. This
> improves readability and centralizes the state check logic.
> 
> No functional changes intended.
> 
> Signed-off-by: Chen Ridong <chenridong@huawei.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

