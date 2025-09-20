Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2D5ECAC59A
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 00:50:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 839728E0002; Fri, 19 Sep 2025 20:50:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EA688E0001; Fri, 19 Sep 2025 20:50:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FFB78E0002; Fri, 19 Sep 2025 20:50:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5F5EA8E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 20:50:00 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F34E687729
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 00:49:59 +0000 (UTC)
X-FDA: 83907796518.10.656AC40
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf03.hostedemail.com (Postfix) with ESMTP id D8FE420008
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 00:49:57 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=f1j61Dzj;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758329398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hEihim8vKtht5JHRfmYVIiOJByu0+5c7d4P7gZnX9z0=;
	b=QXxqmdIgLsqJP8EMs3I9GIANKnf+yGRPUkFMZbwKhAKJbrOrHxgJHWpYWSAKQWvZIT7NHJ
	RfKTOatXAyL1BeBFo6PL6p3neyKcsnI9XqwQOsKik0O0QbzvmP36MJFDlbDMbhLWyxS2VQ
	bnEU0KeS0C6abbZ9CBHw4u/M18DepDc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=f1j61Dzj;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758329398; a=rsa-sha256;
	cv=none;
	b=Tyz60TDFI8idQM2xpjVz7yEieh+JpAa+LYWo5BJMV1chVcWS9rIaoBx4abXZZ6LpgGhxMq
	vGQdYWBoTdjt11HRqLJQjuY+fCpDYPT0B0SeMu+6gKXcMDaxZa7lf3xKTJTJttwYHdHnj5
	qa+neJ1aKjfPHcczRiwVdgt2vpcv7bM=
Date: Fri, 19 Sep 2025 17:49:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758329394;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hEihim8vKtht5JHRfmYVIiOJByu0+5c7d4P7gZnX9z0=;
	b=f1j61DzjTjqsHJ1I+apAfiQAh+xjjjo7Ma1Z9O1gZoZy6hKt0YxvcGoBVQN8F0KjS1zUV+
	uQ//pI48JWJLaHz+4gPPOBmvMpxPEndCwFmhquFD7xkXk8sOCXBJjicbDXBId/zu/wToGR
	TpMnO96YyBFTp2XbJdr/fjdxnp8DwIk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@redhat.com, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, akpm@linux-foundation.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Muchun Song <songmuchun@bytedance.com>
Subject: Re: [PATCH 2/4] mm: thp: introduce folio_split_queue_lock and its
 variants
Message-ID: <v7xskholk2cdoofuv247lbk3l643jovxqheuq7hu32wj2ncz64@irs7qwsbaiqz>
References: <cover.1758253018.git.zhengqi.arch@bytedance.com>
 <eb072e71cc39a0ea915347f39f2af29d2e82897f.1758253018.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb072e71cc39a0ea915347f39f2af29d2e82897f.1758253018.git.zhengqi.arch@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: kps61sd7bug6k89dob8jj8mrjh9gx35w
X-Rspam-User: 
X-Rspamd-Queue-Id: D8FE420008
X-Rspamd-Server: rspam04
X-HE-Tag: 1758329397-220491
X-HE-Meta: U2FsdGVkX1+ov9/P5mT8ARmIHoBTm1jcJboeumVPNM46obZvyw84QPQDBEjCfkPsUuu3xgBrvNK2aIY6onQkmff6tROimxHE55FfhIdP7T1Jj2TKmPZ27MDGA8fllVWiKXWDcDeHIVfB9wxUk5JirMmCUmqZ9e6envQTGucQhT1dAr6hL1qieQpMG7Jhdr6dvEl3n6/n79SEOta5m7Ib7BX9mO7uGTAei4JHxdI8+eXDyey1psdlyMQzNYevlsrmr2rJth14Lqx5i0vv/RkzOGT6n2+ExZriECB5SRoHLBlranSPEpknCk3JJkUELXctFfRtc2stuz3kkt1ue54cr2rQYnGI+qCwmI5znOdRu4oknRMhypbFf2XldggjwV6ErwEbjLgOuuAvrdZI9fhH9YNnIT7VS/wy1ql/1hoK5x2j0JfJT7N12TeNRCVLSr5E1FdV5gjPTXfok/Fc5UyR4hlPY/n2J20VfEXY5eztqWHV2zKJK6TidCZ2hgZT690JhBOVXjci8smAryyieWnULoBv1Tza67VefvKSt+G3SRW9nnvUSSgfQZdV8u0O4Kfmd4q8fxkiPnGUTIzj58k6v/6nd+5llk4RosRW579cMD+rAoiBThqGHfXEaMYSVZqVJv8MN8rE4tjui0bfatm4fW8LllOEyHgGRCsz+25GxEpy964/mwZ3iw4O48zQ1QQGWlen8dSOK6BGFKgV3eYZhEv2bNy/Dh3pzMp/e5X9gInh8Y48UVON0YC5uV6GezoIekfFFnVHWDXI/x5QnRzFGngPQ63zav7JZ7Oxp1tHfLZCD69YAIBzBkeCX1P3gPwrEisxo5X+5NprrAd6WeX2kzGgxcob/rmwN9gwZZLk38bhtUV00/DJrgweqBPcXeqo1xCQwEeFahqi5sZ6jfVQGiJIoThaOq4IgQykQyYjAKijqACcUg1+a4nSeVVqu8QGbQx0CfwBjN/LZeYxk1n
 e5SKKebB
 oqj9Hox2AnP22b+bm/dayp3rMgyRJFy3BMqyGvHugV5/AIGLlgaVFr+yWDLi89oYgWHtSegR5NFyWmAKbyjr5nspfIygjf665UIqegNVV+4sv3dUj5OemPSL6P7lSGZ1PwIOu4d82GppokRb9rn4mG6br0y6sG2szZHSjppegxwNGqjmpFEnGABb+VxfZq4JBBMKHh9+ck5U4io1xIKe+Q84MrDrdpN7mOfFhPobqc3/fmnQ5bbkgouzINAga+w6hdeebej9JSvKJx+TqS3S1oakkqyCt85CR9nr0vOsS/Y+FBH+FAgEHr4mMu1JkqAArVct3xiLBtFRoBFKZVqOOet/kvQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 19, 2025 at 11:46:33AM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> In future memcg removal, the binding between a folio and a memcg may
> change, making the split lock within the memcg unstable when held.
> 
> A new approach is required to reparent the split queue to its parent. This
> patch starts introducing a unified way to acquire the split lock for
> future work.
> 
> It's a code-only refactoring with no functional changes.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

