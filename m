Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CE09CA5FE0
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 23:02:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9709E6B0005; Sat, 17 Jan 2026 18:02:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9149E6B0089; Sat, 17 Jan 2026 18:02:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82A596B008A; Sat, 17 Jan 2026 18:02:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6DC696B0005
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 18:02:48 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 18DE51A02F2
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 23:02:48 +0000 (UTC)
X-FDA: 84342982416.16.688E4CB
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2677A14000C
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 23:02:45 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mr59Wu82;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768690966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q3Vg2S3dBZ9hH7KYqwxt53gMNelNXYK2M756w2nvXQ4=;
	b=6P42BiV5v92mYPwTZd6rjKoj3p7Us9O55iJY9dAGMx4rKVmsGWyO0nRtufg/7tRHQoKsGl
	JBKyAz4uGZf+ez+21r7EI5NAQuLCwNB8JpLB1Y3uBv3caBzYyGCCDwaz5wy+x459eMjFRB
	X7VcmK+7GlzUAyYsMcgrtPgJrjSUeKg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mr59Wu82;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768690966; a=rsa-sha256;
	cv=none;
	b=ek6OBesUoRLQ4+G/9e/U+NKlbXIuqlSoPeH1jKS1AWjWqVwI9Ksjr26xDevhJXtWWjjQrP
	Sf4zyai1Yd5z/MpxTgk6kEA6G8EdfrmIM+8YnMew6ZqMp3mmz3rmQOoA5mst2WW5V0Yuga
	MSilkK5k3SvGQhq8IXaPlSapm8WH4dA=
Date: Sat, 17 Jan 2026 15:02:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768690963;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Q3Vg2S3dBZ9hH7KYqwxt53gMNelNXYK2M756w2nvXQ4=;
	b=mr59Wu82VCEZ0rUrZcXonzhIOebmpeLhzBIWOnYBI0VPNaZGkggXCcdzn1c/E34x5QA53s
	ufLGbtqbTahT+xYGs0teNh2SUcW+HzN0S+veazgzh6IuP+02MNHWAFduZ65syQQ6oq/+GL
	godi9luHMLEUoI2rD8ULq51tm5TitFw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev, 
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com, 
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, 
	lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>, 
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v3 19/30] mm: workingset: prevent lruvec release in
 workingset_refault()
Message-ID: <cfmtkmnrnyzj5hdivkfxbxakdymjxyjrdeebkctx5kthptw4hd@e4wzydxznsl3>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
 <cf64f5c0563a3fba9994d45bda5027f00afbed3f.1768389889.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf64f5c0563a3fba9994d45bda5027f00afbed3f.1768389889.git.zhengqi.arch@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: s1kx7phynxkd83a1149szz1cy196h5rr
X-Rspamd-Queue-Id: 2677A14000C
X-Rspamd-Server: rspam04
X-HE-Tag: 1768690965-901048
X-HE-Meta: U2FsdGVkX19tmlQT8+qm2Hgo5eDtIxV94I8PQM76lNtWzN/XHKCKW1D3luE8UpjSuvPgC0dvgfbJ8NJwEwwqPDWFJ57Mqd2snlb/aMOEn5oTRIlHVisQ3IEBDmbMYpvAZvBcFNX8yc3/InRKft5h30r9XdqP0H5LhkYPtvfah9KcqarvTmBOQc/TiITuc5t+xYH/PbjSyVaXiw+Y4cHhRFteFnGH9j/JRo8pc+cVXq+V4OFNLpDInmZ9DJ29jz/aLBk2KIhbytW+wJyiFDOKmYGpme+/EEyawnLlpp67T/5O+XvezmSdlvkmWeA15hvnRLVTfli/3JPrC3th9t6TJBfkfwl/T0mbHXIGigMvao3aOoe1QQcxGw3+9YWMdkKmfkmuJ8oSL1q0f5CNa3K7k1Abj6RgnjlHOoOwG6Lrz8IwRJBNx4mG63SbbIiWAa7Zwtm9AuMypHK1go6PkHKxNKn8GH6YNbe5RFJi7inPQJucaFg0ltzwE0bdSNwQMM5uVfIfYOProWDMcJL+rbjMTI35YUj0wt3/epVrhUtsHAyEt9GMx7261XP/ZCrWF4wpad2vWdmY4XdQC143MKTfXAF6DOrlbiC1CtFyudjYiQa48L7rxg5ZAUFfty0GInskj8P0STXPdcrDlCsSzVcvifNCX+eIubX6idztyQqIthoP+jgZkyz2GXVeTnxxzqjCxEaIu1Y3cWTJK5xov+byuQtqIaH+rjYTA2ZBlUd6k9hFZlQFvRmPX4bVk3k7tHEs1JygWMa6lljtsQrGEtfm9uTr9lpM7QP6ld35vyWdoedSEk4Qh0BeTtSat9uYWZRIp9DNYcwNQ4GA++cyBs2oBrtHnies5VhdWvWVUM+m68J38rHHT48d9oABmj/SKvZXtDzcKYLn2VTj/A5HjVtTQZ9ffp6eoPqKje+gH/15zPtwBXx2isAuYKgsDE9E5NhF72efZ/7S+sjSWwg/8id
 kZCqzdKW
 gg54MoCHmr1NN1pynC0V4L+eeee8a4isWtAlXU5ldUNh1czdZIxm7+vl+lN5woWcIGqetIdiKnM/HVGyvKT+C/E/sKhoEy4QVouZJilo1LAdrWF4xT9cYK1U4rbP1RCziOFrwjXC8bdnwbHRoDcBIk4aRnSDxuHhMKmg7JuoszNnxH9EjfhpYXdCNkeDZSqxpsVQtVYDImzq+5hrVjqWoob+VkYE57l9kzzTFqzcd3iGaSWnJySHDQVIcaPvarDjToJwEaVsLFYux+UIN9QjCUORM2skfFp5GTBCJIAY7DFXj6X8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 07:32:46PM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> In the near future, a folio will no longer pin its corresponding
> memory cgroup. So an lruvec returned by folio_lruvec() could be
> released without the rcu read lock or a reference to its memory
> cgroup.
> 
> In the current patch, the rcu read lock is employed to safeguard
> against the release of the lruvec in workingset_refault().
> 
> This serves as a preparatory measure for the reparenting of the
> LRU pages.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

