Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 586B9EE6B74
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 03:59:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 297C46B0089; Fri,  6 Feb 2026 22:59:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2455D6B0092; Fri,  6 Feb 2026 22:59:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13A036B0093; Fri,  6 Feb 2026 22:59:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 04F6E6B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 22:59:47 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5787C13A956
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 03:59:46 +0000 (UTC)
X-FDA: 84416306772.23.710B8A1
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4B710C000E
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 03:59:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JHAFMgOn;
	spf=pass (imf28.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770436784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pd+StOZsAu6fC+1g82N+eCSmEnozr9RvP50eoDaUH6U=;
	b=NAHvO0r7kQpgDq+NbRMt/PeWA568eH3xqZRarSg7yKtJD6M0myBeid+ZU5IBXfU04STDXs
	Y0IDkPSosvEla3v5iR/dz5H7uqKkp8UmBOvQn24JY5Lh6mKRQ3R6xHqW/j/64CMRsT+PB3
	XP6GpdyMggbOu1YPnzcJFDuYu27I4ZI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JHAFMgOn;
	spf=pass (imf28.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770436784; a=rsa-sha256;
	cv=none;
	b=sRvHpYMGm5X93KkYljLGfHoyRVLgL35klVDK2L7/XGXrl95BtQqFXj3NnvVcMFbFtXd/Nx
	+BzSWA9E+ZVEOFE9nirpOBPEQioyIlLfXZ9VV55nHd7iM5MnzlXCLYDGh4CC14rDXGg1Sa
	oT6aqs9EZJ6Nq6kOMx4PbXtZ5FdwWeM=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770436781;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pd+StOZsAu6fC+1g82N+eCSmEnozr9RvP50eoDaUH6U=;
	b=JHAFMgOnZKV2EYoeyz98TDhbPMZYZppyZzQG8N/YUBFHowmXjASI8MByzrIMZ9cC6NmW8U
	1QTFxs+4xVcnuge6hiA5OZ0w3PpXQ27xOJHQUGAN+WLjYXRDgJOFP3P7v8X8/++o5hsiye
	AKHtWqDoFLN06dcGGRsGYVWgDBDK7Rk=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCH v4 28/31] mm: workingset: use lruvec_lru_size() to get the
 number of lru pages
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <f3a8fe43c0d8572ad942354cf649c9f25ae762bc.1770279888.git.zhengqi.arch@bytedance.com>
Date: Sat, 7 Feb 2026 11:59:01 +0800
Cc: hannes@cmpxchg.org,
 hughd@google.com,
 mhocko@suse.com,
 roman.gushchin@linux.dev,
 shakeel.butt@linux.dev,
 david@kernel.org,
 lorenzo.stoakes@oracle.com,
 ziy@nvidia.com,
 harry.yoo@oracle.com,
 yosry.ahmed@linux.dev,
 imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com,
 axelrasmussen@google.com,
 yuanchu@google.com,
 weixugc@google.com,
 chenridong@huaweicloud.com,
 mkoutny@suse.com,
 akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com,
 apais@linux.microsoft.com,
 lance.yang@linux.dev,
 bhe@redhat.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
Content-Transfer-Encoding: 7bit
Message-Id: <15E46432-D329-40E7-927D-D999551DE865@linux.dev>
References: <cover.1770279888.git.zhengqi.arch@bytedance.com>
 <f3a8fe43c0d8572ad942354cf649c9f25ae762bc.1770279888.git.zhengqi.arch@bytedance.com>
To: Qi Zheng <qi.zheng@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4B710C000E
X-Stat-Signature: anchbwigibfynr35jd5snsk8q1r597nj
X-Rspam-User: 
X-HE-Tag: 1770436784-858510
X-HE-Meta: U2FsdGVkX19SVd91HRR8dbCCDVFY1VQx7VWwWMbm1AQ/RLUCxYYa8OK6e8sVCNPfGsB+z1y/XPnD27PMeKY4fV/pGggzcC9WBkv2z8r8ENZjoCP88sBVk2GFJsOahxZklxEq8WpKC1a7l9TWstAIJNno0Yrl96rOUVafTzuyIT9+I3mvdCq4+vXC3trtEubdC0g1XbmGiCckZHaxLXRDEEQtImr3zrIO+idxtRbGW1fD182ZgEsgVBcvE2MxDg8lKXfiROsOugMplnia0FB6sCJTjcA5OdFliPBGQl0RLaiYyJPRm7lNa4nc7ipw5feIah9LLnsuKAlWPWNeKHNPY7aGzlFuCaYsUB1zn/q13qbLlOiCfpiGeRXmfq+nZA5oC03JBWy226eMqXVgFo/h+GDeS6SOhdjEqs2oHav3qsejixTosddXlygD6PEW74soV3NdTwm+yKTLpaATxazk48gRpiU0lL2iBQsyKPcsLLMQxobaA2+unlyXI+x+MUZ3Q0zxrj84iqrMN4SCl2NvEMMDHQR1DtuCPNuvR7VMAUC+nBcyS9aLG3by/XeUdAQmtVRcT/0BcVIoGc/Emw4PG6iP8ts1/RUhPadp90pWwVBZ3ZeSRd4T16M9ShA4xWOP7FCHVogOOIag28Kp/Lk3yxdBXO0AHyIQLDU+z4d2SEfSCRDSAd5U3fxxXjPae6mJtdbZB0w52Qeeb9KEAgS2su53ebkDXj6/mdRrG47xCVhRlpEty/N8vHP/2NGLAdcwM22zem1rICs3KuDVjF/jNdJHOiWq77f6v+R1aN/i5Kk2oF0nYetJsZUJVaVpjTG2t+XnVRF39Aae9nom5ae/HB/GaPEnNZO2atsRH9qujshWhzBOOC7+imFkc++ZQqmajjOR9tPqHqF+Vd73VzQnOpsVM06HMveiI8qJkU4wDylYLikYHmmulgR3V4+Jor5Q0s5Mb2G2LiV1dNm3uTD
 cNSLXvQd
 lR1qw7JGWS90vJu7iX0B7zF7ZQj5iF3sq/dvN1Fs1JgpQWWZlqMVXZaAw4bda53vXsy17IEpfSaCazQfyso0Rc9a5GxJw03pq9I+/VMX+3NaMhqOpUEkxz21jVW9WxIp6VNMvd7IZysRTrJes4Ft2X3CtDjD+kNaoV75QckGl+YgMzJ2qOtlqtSV+9PYWoaRjSbP9kbdN3R8x0zpWJDTXWVOuOuS4MXwRaZCEzvL62zXXsJsHV+x8wsQMzpxQ0uHhWaFV9yt3TdtiEOsY6rVMVkLidYBfvaoQc5iU6QWDKPNOYEtF/fQtTdy0eNs1vjGxDrs9vnMiO00oXmF7/Zn7Mvw/FF4zLE3iuZcENvE83J/CUdnxXOtekAcvsA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Feb 5, 2026, at 17:01, Qi Zheng <qi.zheng@linux.dev> wrote:
> 
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

Acked-by: Muchun Song <muchun.song@linux.dev>



