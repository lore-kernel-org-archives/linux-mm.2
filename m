Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5247D711C8
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 23:34:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50DF76B0088; Thu, 18 Dec 2025 18:34:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 492456B0089; Thu, 18 Dec 2025 18:34:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39DBE6B008A; Thu, 18 Dec 2025 18:34:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 250326B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 18:34:23 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B088AB89E4
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 23:34:22 +0000 (UTC)
X-FDA: 84234197964.24.4D8122D
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf22.hostedemail.com (Postfix) with ESMTP id C82F0C000B
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 23:34:20 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SsihqVBI;
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766100861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FksPB/81q1/fiq/yVCprH0gxfgwUBo6bbyxzq+WvCbg=;
	b=j9ZpVTGrR4UPsvx3DHn1GqpPHgFIZgX9QPuIc9jxm+ucVBj4Ipw2qgKsL0fy9uNF2QPo/H
	m4Rrhq8mPixoGSmpZg6PCeV/8Y3TUAyVRxmDwfQcI4L2VUMyk5Um3bD+iSoiZYIQezQLjB
	MkvEsm038Ax7nAiOd7VGtmFVIBlGHfg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SsihqVBI;
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766100861; a=rsa-sha256;
	cv=none;
	b=KHRUMBl7LpE9M4xTEXYa/nTMxODsistgp/D4flc/Y2Vk81szA/WmLFbTkt0FVdVW6jbUlj
	uOLPvGBMJgN8CM+AU8VQaL5C8jHoMR5QDtjEY3uXX5SRb95GtTXPWvDs5Uml2CWzG6YAFX
	rdo6cLMBK8sdVjfYS+PmkZLiPmUD2vE=
Date: Thu, 18 Dec 2025 15:34:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766100858;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FksPB/81q1/fiq/yVCprH0gxfgwUBo6bbyxzq+WvCbg=;
	b=SsihqVBIK7pZltgy7boa9xHlaoOpOOhjuXXjmAUIa/m5Ghdxm16C+Cc2a+gqS2GScrwDkk
	iHM2aB3K7g82Dl7lREYLFRpOwQ93lFelkZ5pRcvB9HeHMuIc7XuJwpl2bo5aXy1yWrHBaN
	hNlpioKEED2g5oW7+DHzXkK0Korhz1I=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, imran.f.khan@oracle.com, 
	kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org, 
	hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, lance.yang@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Muchun Song <songmuchun@bytedance.com>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Chen Ridong <chenridong@huawei.com>
Subject: Re: [PATCH v2 03/28] mm: rename unlock_page_lruvec_irq and its
 variants
Message-ID: <w5dudwxtraadmclm6exyjal6lheiw6qqraiq4yz2i3y7heoued@b5ikfcfwiwwy>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <a11ca717ddd52fd83e1fff9942fc49c9c5c5b78c.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a11ca717ddd52fd83e1fff9942fc49c9c5c5b78c.1765956025.git.zhengqi.arch@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Stat-Signature: 45htjoydibt4oz9tz6pt9tmrukmgbc43
X-Rspam-User: 
X-Rspamd-Queue-Id: C82F0C000B
X-HE-Tag: 1766100860-222184
X-HE-Meta: U2FsdGVkX1/tdv1yUBe9X/YzR89oMo8mXOwv8S4xf1BXc3f7j39PHfhKFd8qv8fHdajAWqJXhnH0eMRAg9roU9I5iw0k0jadrdEitvkhZmvyychFYBclnzO6QlNpnJ5hKbgdSglO/5NKg7atVryqC2PEqPb56rZxiloXyGMlON/JN26krg6nyavINaKNshLF2g/48y5tPXu8GMJeypQI37BdTor21PtE5+V9iJ6VzAadyEWYwb8aXQoJnalj5jAKRJxC0sg51vPjnKJAvLv6feXG98HLsf688x1AkWnYpINSINBF9wZsxfj0/nPOr79K1xjz9wWF+ggSv2XUqtSqwfPBLRg6McPxNHHWAdElRrFo9+SSnfd3cIIx/36Uk4eT/PD4KSJuERkYxS/pnFibryTarnBcO6EaJSmYuslKGPQVdMk+cUISFOkx781ZDhNDpUcLsZUbM25jmIv95Jx3covASkAKIegpC4G/ZHg0yxfM3U70s41qCuJr4xs9VxKexH38jvQjQN0u5cMblMArBRhns9LFVw7rYLFnmqFFUbPATN1tPq1nqKMeVIb9BUah/gxGJXlMzFpARNkFZWIIsc14RBvcIgCFpLYK9OgAHUQWiBZ5Qsyje6DYMy6IEqYXTCt0m7zKesTgpK/vZ8o/eSHClUXJagRIT89z8G2+aMMyfgu2br+t1ycKYCxD4bjTfHpc+m7mBsJgheiD7Pks2aNm8Ei9XDr5jCOiyObH4IvmuxMhHZr5hcVm0AWVMpJhW2619CiRUx9k65ebDo4aPztMCxrDNmTXESV4dXePMBTgJWI/py4xTi/h5Cfn8RQLZ1vdDeCmJA/9L5znLDGCj7q1oaESBK7aD+iACORJnZKBLDmME9pASfrVlZQslFNPzMZtoNZ1hRZITeVVnnr36goLP5Ppo5GlrSS489RUrrkZDZXFHE3Rb/wu5lfwckckn4nAy5pjJVY35l/An/J
 z3NK37CX
 R2WxbLly+TDSurx8y9oWK1BaxONh7pO2hWMYfJFOfNOIm71aMNLgF1msEx5OfVbNgVt3RFJDR+XDqf2DfY34XMfIDLj5exbKOgZ3iATWD0zDWZd+WcSLc97WgLqBHVCenyUkLF5lvJcaVUXTwmLXGYf5Armdj40oL3OhjfdXinDQjOeFi9+RVOr666Ljr9ot6uaFbvz4riPHHmQZQBP5G2Is+MCPGo4lNVBTrIAvHbMNrRzyr/aDAKDKjw98He67f273QtbXyKNeLDypTfiV+ed19F/xrRBIEiSWK11N76mCBsho/BLa3TmsqKTkGTU0jCR9eITLnWLHo3ZFvEgGASEJ4NZm2di88GWOdqTC9Y/MZYUIpnbwMGTJpAYvbqZU8pTUk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 03:27:27PM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> It is inappropriate to use folio_lruvec_lock() variants in conjunction
> with unlock_page_lruvec() variants, as this involves the inconsistent
> operation of locking a folio while unlocking a page. To rectify this, the
> functions unlock_page_lruvec{_irq, _irqrestore} are renamed to
> lruvec_unlock{_irq,_irqrestore}.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> Reviewed-by: Chen Ridong <chenridong@huawei.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

