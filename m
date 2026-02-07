Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 985C6EE0AF1
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 22:26:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DD426B008A; Sat,  7 Feb 2026 17:26:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07E1B6B0093; Sat,  7 Feb 2026 17:26:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFA126B0096; Sat,  7 Feb 2026 17:26:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E2B766B008A
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 17:26:56 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 92687140351
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 22:26:56 +0000 (UTC)
X-FDA: 84419096832.25.9E79276
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf16.hostedemail.com (Postfix) with ESMTP id CBB4E180005
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 22:26:54 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=M0BAedYd;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770503215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uatIfXnMXwohncvpb4GuJ6tvrwIsq7Gi4yhdTvLaFmc=;
	b=KbhJKDOGMtz9iRCe0OvB7FwYsG+W+Sgu1gCoXJzubDcFKCHicWO7FoQNvSpqXkH5JKM6z8
	CoLQttmp/uZz6TBuVMYnyK81i9OSPFV2DYXuA7JhpgNbdThMglFmv0VDcEaHA4bfu0rENk
	xGoxtXeUot1KqExF+gJBP/5g9Ufp9o8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770503215; a=rsa-sha256;
	cv=none;
	b=MGXesCHVNq/d52Xznhsmh+OYTioivIXAvzWM0eh8O/h0G+qvzEB9DppT4sZ5kHRtAcCne8
	y+ot8eVcsQ02a8brYHvjsuk33hVL71zRcgLl9blstNXNOKSCyK2ACu4LkLuVCPgbkmBFs7
	iXBu6l+9J7jaBX1/Rvd21unhwL6oOFE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=M0BAedYd;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
Date: Sat, 7 Feb 2026 14:26:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770503212;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uatIfXnMXwohncvpb4GuJ6tvrwIsq7Gi4yhdTvLaFmc=;
	b=M0BAedYdtDfGL4RevBAr7WRnh6IHPEJoJg8oen8Ycw//6EKX2dlwevhCAGbmJu/qFSVxHS
	/OyV6waSTQjew2u0iGNfNO8O8zZwvvbnTXiqrSvpU+UYiLD7s85gvAkSurw2o0eLKEsBzJ
	wju6l5bxKCCtM7+gzN3JiZA69WqnBpw=
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
	cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>, 
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v4 31/31] mm: lru: add VM_WARN_ON_ONCE_FOLIO to lru
 maintenance helpers
Message-ID: <aYe8DifzgL8C9uaI@linux.dev>
References: <cover.1770279888.git.zhengqi.arch@bytedance.com>
 <cf1678070fb6bab6ede8fe48f835fe913a0bb728.1770279888.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf1678070fb6bab6ede8fe48f835fe913a0bb728.1770279888.git.zhengqi.arch@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: CBB4E180005
X-Stat-Signature: sqrpezkiakkr9145p77ro74kqeg1ikwi
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770503214-84945
X-HE-Meta: U2FsdGVkX1+0qcxwMzPzVxYGfSuTf0Sv2jnfzO+NlNxdKsx2vgNp6Q5PhF/YHUYR7naY9R1ZlOfkWoKXLrPWlXMttNAIVqjRUJWauGiyEEnozFi4+rlA2oBEClpK/JqgAeuNQlat9/1flppmKP2wzO5xBzXrTUULVj6vvzXNNFj9zvFt35S+Yw9br2QBal1cJyKQrQzWVybfhm5O/Edbt5camdo093z39+8jPBK+9aD4jv3AgxWPJXwwNYZKWDOSeBXsJJvm+2iZlbqo4qUYn+rIbQogB5CB+hBDqSWM/t+fZQ/0nJ07osXPvXsVR5M9xFEQAnNL+cEF38hYU/C2RIIFzIh/ZRws0nBOP0fhzsAuAYWaQcpSNXQ7YIzM0eebfWfhyKSU0Jjk4kXp01XIaly895sB+XkvjLgTiWhXwTQ1LnOoFKJZlaaTEjRYDuZkxBZUmrysLweGaZ/8koxkRARFql9XEadGd0jp2yQzqNnTZH7ae/4FNUkBy58+ZbziVyK4dGTebliOCGpSM6Mqnque65WnODNf5XScGBsxMTLu8lkkPDJPTU3G8SIpIEtMAx1onKaOSQmOHoxjP+Vze5WbRcH9igC/rBK1c4RdgAx5BUJS0tK1b3K7u6Q83xNy1K39OEffk5Mu49GCHp8+aAiJO6uRbwX0mBx2y4xwgx+arIBOaImjeQzxG5Qe5V30nJ2Lpd9gzHDFv74TyibHAgbp+zhioRt2d1Pdjs5iFEcYu3RLHLsj8zyK86ODH6NOKG3irLzXJeSuobdqJ/SgElOTL7VJrjHJd9Nl8JubjfcXAXCoPIXrtn868D+0Q+kcanytWkGgekKbwUsS5RmCc9sNUS9gW0/+4Tjqh6d49Bw3hCskvXccj7BaKxYNosJVFTBu0MUkfbHr6qUnoXoulyduivwJ7kguQfPKxz+A+iJZj577IRSxZIazCVhmIakC2VLUo36kVnOqCau/wd5
 KsJmy/5K
 ryrQ4Ouzko1gnXa22CW/XLcEQJcH3li5bC1XwoO+U9H6YQGlr+4cEwQMCkVQrwx7/tgZ4AcCBIWwn67bXve/6beK22A9ALTDJg0Fb2BtG/L7mgB8mUXkxXMD2/+WLs/pN4MDNF3wWmeXRnVmRmlP4XLgrUl2a30063i+7SisGeeKqmtnFUPDLh6ZDmBJ/s8IY3gLPXFluR00o+FGsnUfbb0+QlP6NFrQ11PYzkq897LQWsn6hTBJ56TZvoOkmepVHbuV2AXKwIyvCPrUj/d4xJh0wky4sio0BsyZ3YGkhrO4A1vBjgdiYXhKcLMxSeI7DkzcKmw+LNiPBFtOKWrLQdly7VQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 05, 2026 at 05:01:50PM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> We must ensure the folio is deleted from or added to the correct lruvec
> list. So, add VM_WARN_ON_ONCE_FOLIO() to catch invalid users. The
> VM_BUG_ON_PAGE() in move_pages_to_lru() can be removed as
> add_page_to_lru_list() will perform the necessary check.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

