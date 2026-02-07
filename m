Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40819EE6B71
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 01:48:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 722366B0089; Fri,  6 Feb 2026 20:48:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A5396B0092; Fri,  6 Feb 2026 20:48:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A7656B0093; Fri,  6 Feb 2026 20:48:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 491456B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 20:48:57 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 56A7DD5BB2
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 01:48:56 +0000 (UTC)
X-FDA: 84415977072.02.3C99C84
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf06.hostedemail.com (Postfix) with ESMTP id B4F8D18000B
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 01:48:54 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=l4kbaUZL;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770428934; a=rsa-sha256;
	cv=none;
	b=xeaxgqpifzNL4jRSk0ZVBbH+nJNmt9XtPZIj8EnBCwoxs/59ov1TsRbQX5R9CnkZxtTlxb
	HNgdr8/qprL+vv3wBWhj7SuRRMmXcJJ8oeoaz3HE25sdc9+/I5rhBXhMdVtiFIeoxY96sn
	zAF25keR0hKb6pQSpBc5+veiaMmymfc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=l4kbaUZL;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770428934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QN4/4OPtzn+BeYzhJZqjDMvLt+ze3+0173gmQET5pxA=;
	b=RLnuirRY/JCo40ThNOqUdxSd73b8bp9xHDs2SSzdAowXLpXbL24Z1oTstKj/aUnXQWZjy9
	wIsh1f8eoCkYLDKNuiazmN/EVSoYa50X19FGNPCYwhQFqAQTRd4OPLBT0YFRRN/myf3N1Q
	zEXFaw+TE8dkzw8/o79NFXJdqYRmqhY=
Date: Fri, 6 Feb 2026 17:48:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770428931;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QN4/4OPtzn+BeYzhJZqjDMvLt+ze3+0173gmQET5pxA=;
	b=l4kbaUZLViC/91cpxADrAlD7KSE2LUhQpWnfvQ3jaxoedcAFLDmd1V9pafJHCNgW1skNeg
	FyJFSA6OuUfO1iAeURB/eWN1geTznbfJ6r1qWIp40Y0G7oMowPK4dWKqAnMrqUMxy4sUhZ
	u2ERIgz/s5o9p19c+RCjRxm/wPnJVV4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev, 
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com, 
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, 
	lance.yang@linux.dev, bhe@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v4 28/31] mm: workingset: use lruvec_lru_size() to get
 the number of lru pages
Message-ID: <aYaZeM_ppD2NQmZI@linux.dev>
References: <cover.1770279888.git.zhengqi.arch@bytedance.com>
 <f3a8fe43c0d8572ad942354cf649c9f25ae762bc.1770279888.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3a8fe43c0d8572ad942354cf649c9f25ae762bc.1770279888.git.zhengqi.arch@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B4F8D18000B
X-Stat-Signature: runci5yc48woft9qkfk76xy95gp1cs4b
X-HE-Tag: 1770428934-557625
X-HE-Meta: U2FsdGVkX188Zk6IQD0AmFyqfWCbLOO1Sxjx5JQ9cM6pG5a31KqQ8mIddVKhInm8sTtAZUYtWDgiLRUOEd/P7NrgiIdoPDiK/k60eb+zqxWvdf9o7JtSi1vRPiNS7u50MPQcgQROJsHi0/aAImkaRniz0tgVDSBwyz/jAH+Dd5jrjouvI1PSd3YS8Lri8FGhGcKjRzweVhT6UbO/6Q6YtDQN11b3IkOdpfzRtGwaN/0q6X2ZcNL2LCHD6SSY/E5HnPo59UGau1MnHCA8zK9zkfMnZ0wfh10ZZOHvtTO5L4PAtCCRBk1Ed9EXaKBU/5Ep7pOPNDeKGlvviBcp0yhEITZj5MIC5XioIheoogI72AEINZHAEQafCbr2bX2xKItkfSeWXt+rrUru4BFW4zxM7EQoNo5WgBplENBzf6a0iAQsbRx/YLYlz+/iS4GFPVp1E1Lr22AmplK7dsKcXhDQfCZDA+XhJ+P9pFU3Nc8SFRmYFWJdrs1vVhdbcW+WNOJVaAin+6Cw4Csk7Ns3cnZwQdvAOVthOKwO7Ja511WMKER5xTyrsHCa5UdyBLG7uwZyxrltRsprT7fj/o+K6/xSCmJba7Qsre3dfeQZdjc/lYyBgWwWL2ie/bPPvDgSn0TDZh2zkIbo3gaz83Xqm5sP/xZMFDezL0y4D5YFxr5O/gDGOQpxT4HGFvjA80lbgG4Syr7YBbyZ0zpoI9Rjfm28+uDSZ3Y9SNQQxkl9M+0uXdOFLMrCXf/RePXIJbbeZm+edd85BVD3L2/mvct3hPKfFEL6zy1JmVniw+l5tQq5YE2BUliYH+GrHlmiojxn1euwqJSPKRUgKBYo3pOUaYBM4oYPNB0SHiJPRDaXyn8kGgP+QZHeCBx8osQ3Fi3EUz0pMgR6YmlLkf3XUA4iGh83y7xz0IORtdd4mtiM0gxpEhc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 05, 2026 at 05:01:47PM +0800, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> For cgroup v2, count_shadow_nodes() is the only place to read
> non-hierarchical stats (lruvec_stats->state_local). To avoid the need to
> consider cgroup v2 during subsequent non-hierarchical stats reparenting,
> use lruvec_lru_size() instead of lruvec_page_state_local() to get the
> number of lru pages.
> 
> For NR_SLAB_RECLAIMABLE_B and NR_SLAB_UNRECLAIMABLE_B cases, it appears
> that the statistics here have already been problematic for a while since
> slab pages have been reparented. So just ignore it for now.
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

