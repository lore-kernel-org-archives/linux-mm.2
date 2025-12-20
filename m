Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34BC2E668AA
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 01:23:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C0996B0088; Fri, 19 Dec 2025 20:23:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 743EB6B0089; Fri, 19 Dec 2025 20:23:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64F676B008A; Fri, 19 Dec 2025 20:23:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 566B96B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 20:23:20 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 10A3B140405
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 01:23:20 +0000 (UTC)
X-FDA: 84238101360.15.5CB9322
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9DC27A0009
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 01:23:16 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Z2DrjdHS;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766193798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vlUkmVhyJ1GNMYjC0GvszRdVCka/XpdgbTBxp5bLef8=;
	b=HroEnVF+BqaDNHXeV7t3TiiGIhx6Vxo5MtuVBMZHgcQWRkRdL0rAtLRULrD8JfOz8dT9Ad
	GaeTIPLEGHGUXdu+ZXsQkMXq3G22E63C+QJM5gejgRadKqYcFMPXfA3bb/WUY5yyOM6ShF
	D+JOJxGimSAQ0lrdFLzpEOK1SyxCrCM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Z2DrjdHS;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766193798; a=rsa-sha256;
	cv=none;
	b=FNGonS61dnkf8XgS9/nI9Xcj+C909Q2TqET+wgBjEzgsah6/l1jYv1FCq/7d/mFPhLo3C5
	MQxbahXN1Fp5Q/Y1s3teUvsR5V9aj9VMQAMpJioC3AfbBopgvbCtNZ2cqs39U9piKA0NQ8
	Q3ASJYeL1jpTsGnEOBeB4u+QQUUqmVQ=
Date: Fri, 19 Dec 2025 17:23:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766193794;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vlUkmVhyJ1GNMYjC0GvszRdVCka/XpdgbTBxp5bLef8=;
	b=Z2DrjdHSfFUyAN06z72DqPDM5Ft9xOPMQjKwwBVExyArdllnVPUKVNg6qIZTJh69jM/Wxl
	zQntOR5rXts0K+atDhcLRwju9Nb1A1ut/rBlArWr4HJWbiRt0Dnfm3RIW/AsH7DOtoErgP
	hjmSIPwS8dGdRG52EUzpPsLa10PFb9s=
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
	Muchun Song <songmuchun@bytedance.com>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 20/28] mm: zswap: prevent lruvec release in
 zswap_folio_swapin()
Message-ID: <ddofqzx6ek4o6igzpxmmmthwoc22pkag2mhjb6cobjfekzc2nz@ydtptfjxnyxn>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <bd929a89469bff4f1f77dbe6508b06e386b73595.1765956026.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd929a89469bff4f1f77dbe6508b06e386b73595.1765956026.git.zhengqi.arch@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9DC27A0009
X-Stat-Signature: dmtjebhacm5d38scb71mxbmtj5h5rh8g
X-HE-Tag: 1766193796-412036
X-HE-Meta: U2FsdGVkX1+lIZQsld8JnDugvjEwNa+oADtqBbR293IxKTl96oSkSM7GOqIcBuRwqbs46sZmiHdWkE3LrLWoQvJnOB+QKQqzPOLFIxZ6+x0rrSMKkQiLSr/xM6L3va+KdEyFOlKtjY46I7NhD6DsQ/5pJiEJFHPF+19c8RATotuwp+O0gVojplHwBclsUclRIoSErzG6kjEMPBCy1BIplnhoEp+hKokqXHuwS+bJmvxJNoF94/pGS+Wkq55dce+ty3kylHAcU+MUUltapwAIZkY9W53NV6nyNEOcgPGzlNFLdX862PckhwCBIT38jN0l2pW1t2Kf+QoAz1vDcrbB5dI0v7+uDmqFeXgoTFCT76NdcWzr4GggjRHFlmNPNAxAOvDcYj6fowDiJKHPNmP03ZDlN07wAD1w18FL0gn1i3qy8ygjAvgBG9HdFyCPl+QNS2B35Ak+EiFY04cFvDl1T5/bndEd0+gEIq0FnUGZEWw+nmiCS9Koyj8DbG5WJFKyeqWSv7CDRCn62LzD6BMyGr0tGJZHnECE1ORc0tSplXGptb2jNsY3ECvIO3305kQMo1cDx+EdWoucQLFacvIUetSEVSfNIUXnjc0JGhr+E2oqoBlDHfdcjRXUwoXJlW7OK/PxigPAIYX+Ga+xfYadQcX23Oz/cy7ulWDH4IRStwpkDsEsliGdjvwn3fJlzPYp3cd1Gc8lP3snrp7aprzvvGKrvwQldrQqXIJ5+J2VHpz3yGicLRGszzhstqd0ripKHRAYyV1eUnv8FHb6GSP1yEYomThe/xvo1Tnyiyb8BdU5JuJxI8QxA72ThsisO4EBIHYVkwctaAGvb63A0WA6fZU9AS0hesFURkaAHAHj5vAzdD8l1GsQVDk8gHvZS0NoqJEgdL4CWAOyRf4Zp753UIJ43JKAdfj4ukJbSEbVuDitDgEmwO/S3rTO/eXWmCWtbz3sZE8861fsHL4COLB
 jExNpvED
 yNfCqylVG8YbPBwjSBDH5l/M2tMZ8EUf4UDkXSoLQ63xAxWEaUTD3TFdDQsKvNcOyvHXFlMSI4ExnfXxNcQFCvmSOioyobm0NuV/j/bZCbh59RVOXLYIuKnwoi9oKayXE4f82JO281C2suMPe6Hdsgzb9QJscEVRL5xQD3MELkvd1n9wDxqsdnrXCJhboXireLhOoaGb0Oyz3UO7jesaYxzINiJwqWcRBmG564dWmzMuMZwOP6uoK+LBbIhQHmvucAR4DnWuBNVMTmop/3GoG5+BkzlymrMjOqSGPUM/JmwzVcFXYMZTSxwjL6n04Q1984tFKyE0jMbd95WY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 03:27:44PM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> In the near future, a folio will no longer pin its corresponding
> memory cgroup. So an lruvec returned by folio_lruvec() could be
> released without the rcu read lock or a reference to its memory
> cgroup.
> 
> In the current patch, the rcu read lock is employed to safeguard
> against the release of the lruvec in zswap_folio_swapin().
> 
> This serves as a preparatory measure for the reparenting of the
> LRU pages.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Nhat Pham <nphamcs@gmail.com>
> Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

