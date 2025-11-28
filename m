Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F111CFD376
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 04:33:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D905B6B0008; Thu, 27 Nov 2025 23:33:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D68506B002B; Thu, 27 Nov 2025 23:33:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7E836B002C; Thu, 27 Nov 2025 23:33:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B67896B002B
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 23:33:36 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7392E5004D
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 04:33:36 +0000 (UTC)
X-FDA: 84158747232.23.498D14B
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5D20F180004
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 04:33:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=eS6v7srA;
	spf=none (imf06.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764304414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8/D7c/IBS5AN369HJE/aBfylHs+XbEjnoUErP6C44pU=;
	b=Vz9yNgtAtmG16LZ9RuHcV+YWRZQdZ2ViLYYZV4g1pTQ1G/Dq/WILR28uyiLWYcj3vIeKjc
	er0IBD7OFC0dBPaQt5yEKWXTrhvHRkqZJNOrpV5S91NuixAw6CQUUnLChBE3fGYr8weXkP
	1LD5w7Jt3p3wsJckeAFYNDTi7WvtL8U=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=eS6v7srA;
	spf=none (imf06.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764304414; a=rsa-sha256;
	cv=none;
	b=MWYxtgEtdnSFFR/pDBbnYkn49t1E6sHDQ++LC+aY2LcxgFcqC+dWpF/pbcFhWgcgr4BhnG
	Sr0F02zQ0/jWDxFM5HlEVq1J1J9pL34ZTrD54NrCrI8qy1Cu4erMslO0nvE5AWYmQlQDah
	2+L/jGgcnwepRwGK7p5DWEYd0Waac7M=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=8/D7c/IBS5AN369HJE/aBfylHs+XbEjnoUErP6C44pU=; b=eS6v7srAEOZJkaA6L01tABGSFE
	D0PnGQmvIn8FJ08Bety8blLg56JzgiQD2GBhGEy0MHJVV2dj50CsuKqzavtxTDIOgEy/uyBJneOtq
	RjPuxycmVjq/ki25SeMgR4fiL4tDHexfDm8CCZBhbbwBsYFqD+Mn3eqj+YKzmw+qxUj+CgyxzC3m4
	+0r/HeGunCTwZc3w/VvfaAVj6clSGCGdxbS72OWKLSlqW2DnsyIjqpktmVo5f+EXnzmorKzy/Z/Wu
	ZZLCjbSQeccwzVy8mThHbvbubK65iWK6lS7FvD3R32EjKMKAgcRTLPmtIQIrbKtxMXV7zBqdoc9pI
	RDFiXLAQ==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vOqAa-0000000HZKu-1qpd;
	Fri, 28 Nov 2025 04:33:20 +0000
Message-ID: <040e35ca-848c-49cb-bd0c-f91f4a8e2c5d@infradead.org>
Date: Thu, 27 Nov 2025 20:33:19 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] mm/lru_gen: add configuration option to select
 debugfs/procfs for lru_gen
To: Zicheng Wang <wangzicheng@honor.com>, akpm@linux-foundation.org,
 hannes@cmpxchg.org, david@redhat.com, axelrasmussen@google.com,
 yuanchu@google.com
Cc: mhocko@kernel.org, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
 lorenzo.stoakes@oracle.com, weixugc@google.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 corbet@lwn.net, linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20251128025315.3520689-1-wangzicheng@honor.com>
 <20251128025315.3520689-3-wangzicheng@honor.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20251128025315.3520689-3-wangzicheng@honor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5D20F180004
X-Rspamd-Server: rspam02
X-Stat-Signature: r9baicqdkry7kzqtxezr7cxdpx78hihk
X-Rspam-User: 
X-HE-Tag: 1764304414-447232
X-HE-Meta: U2FsdGVkX1+KYrF0pK6XdDc4XKu9Ui91ESNk/ulw6PvggDuYhc5L2io5rjRj5/1K4LUoMtMkgJxBFc6C0n288/W6/G2lawqONKkm7yZG/L4Hi/5oDqnio8UtU/GcSW1jdZPW0/usjO3XlgAbHX3O4xfR1QoFJXZuyrQNOxfwT7jqrKOj0tIVfcH888g2iq422iSwz79UWceu7EXxHaaSDevA0ahgBzMRoijQnzvYC5+vyaB14rAaTy/QRJgimtXVb6B+7si6bEq/Kx2wOGSpV6JMAtmGWfffKWAs6UDKRhEpbfZA54LU8kMIH7xi+VfwV8Gj474FD3BtSPPJ5+ZoB6g3F+o5ADWpAfzOHrfLvB2IfO6WfpH1hwpB2HXDUf5UVpk6hwkifZHq0tT1u8zZZXAVoSHMDUsH9WeZx5hvb+r9tv4ZRbPOEtVT606X7sBFOcaNo+6+KbcKEnlvRr7dzXhKFP9CXHgjG75kJITquU83kAx7HRbvmjOMyr8Y7QDvIdRu2qUg2iNVg2UpxzAqOso6d2eNgqtsjbqWAIx5NSogRuUX2vU8PhbQj6SBYwKJ1ZH8WLuK0ue7BZEkN8J9a9TeKHJd0jhq84AnXeUUnZtkT6ezkZFCNrc4RMifxYJ+8L9jLPhw0Dn4K2XScnVRe3ISoLlPMe9eyvjdx+PR1QodO8+UzwveGloMRXr+ArsV+bvhhPh1hQfdjDXETAhc9EX9epC0gfx1/ZDljRRsN86fdA5xuUue34gMhq2zoWdah6iOWhNmr0IAv+b92XNZqic2G+6r8V0fiRFisgwXZq2A0k7TDzVU+Yr11uoSaBsrCSO1nyU1HfR30BehgnuexKBo6bw+ODIYSu0C/EdWF1w+3k1ui0/b9Cql0MvOS6+oSUbnQYQtjAPCmu0YXVXKHqC1i22fRl5bsBxKPMUfcpLV4CHjqrHbe6UjTTeqsYQ1pVV5jet86ypaqzqT9VW
 wG8XhA8n
 UBzYfSPjHYtHaPybxYw8up2/sYyxmKCMyPd/6OSG4i5Vgy25gQKF4EtuWzP0OA7jD2xTV4unIM+bWLVVC0/SBv7WmWBBo/7g4P35tU+TKe2bqKv6xtonUkcoRojKZESsEPjTV4QBOWzLck5ngV7neI4gUFPeFNtKAny0DdvBESEWceKW9Vaj4+JP2Bir35kIp91wXIU7bD+wjcmGCrKsjCgoJ5mj+b8OsUsm/xDFFuMtKZ/i5fLzsiN/JIwbIO44i0kG/PRv4byvVW90PcWtTISHuXIPfjydCyMU+ad51uJoe3Uh5ea6/ovy1+G+Fl2raF/+R4Xw0Dx/dwayfpAU7EqM4HMlQICSwmZiHPcEk9E5uXSV23DFSBLFd0kuF+N6EznOrIYeCR1LA9LHi8BqbpR17uQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/27/25 6:53 PM, Zicheng Wang wrote:
> Signed-off-by: Zicheng Wang <wangzicheng@honor.com>
> ---
>  mm/Kconfig | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/mm/Kconfig b/mm/Kconfig
> index e443fe8cd..be7efa794 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -1325,6 +1325,16 @@ config LRU_GEN_STATS
>  config LRU_GEN_WALKS_MMU
>  	def_bool y
>  	depends on LRU_GEN && ARCH_HAS_HW_PTE_YOUNG
> +
> +config LRU_GEN_PROCFS_CTRL
> +	bool "Move lru_gen files from debugfs to procfs"
> +	depends on LRU_GEN && PROC_FS
> +	help
> +	  Move lru_gen management from debugfs to procfs (/proc/lru_gen).
> +	  This production-ready feature provides critical memory reclaim
> +	  prediction and control. It is no longer experimental.
> +	  The migration ensures availability in commercial products where
> +	  debugfs may be disabled.

A. missing patch description
B. The help message above sounds like a patch description.

If someone does not enable this kconfig option, what happens?
a. lru_gen files stay in debugfs
b. lru_gen files are not present
c. something else. If so, what?


-- 
~Randy


