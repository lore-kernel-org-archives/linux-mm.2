Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D892BC87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 01:49:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D1646B0088; Mon,  4 Aug 2025 21:49:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55B2D6B008C; Mon,  4 Aug 2025 21:49:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 449996B0099; Mon,  4 Aug 2025 21:49:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3182F6B0088
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 21:49:57 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B5CB2BCEEE
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 01:49:56 +0000 (UTC)
X-FDA: 83741022792.16.2E74DF9
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2E71E1A0007
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 01:49:53 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=sg+HJsZE;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754358595; a=rsa-sha256;
	cv=none;
	b=rpwi+VHrSNs2zbrC05l8CpFL5np9G5sX2TIhNAU5ZUrDBERd3gaAxlN3tEfUNcKt6ykfzC
	0EUqCugfeVx7f9muBzlY15t00CSltbQFVCVwZCijmFlP/KlFxX96jAQvezwU5xsPlSczDF
	4jvUdFfqgX58RF8/m9bTFT8t1M0zvXs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=sg+HJsZE;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754358595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rh+PmBHA1gbb8whqL0XrewPPTjKcvEmBiru3WFTQ8U0=;
	b=Tt88Ia4XkZKSrNximE6xrUA+0pBUdpSilsNcIN4vfrBfrgcBvGHaKqqpbl/blKaDqUkjyt
	fsOUY2MpWltomC3o6JhBXZyOjL8Dit954qgXlyjymhUaW4hNqDbeYkarAIv/HFlMAtb9TH
	0Jzn9v+wp4tqC80z81l8/OBS89afFac=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1754358591; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Rh+PmBHA1gbb8whqL0XrewPPTjKcvEmBiru3WFTQ8U0=;
	b=sg+HJsZEGDnljQqrHWN9dC74GL7rGx/Zhz0B9oBjeRvGNPC6iYtFOdW2BC4AGhBU0VZiHrP+ku8VUztYYAANQ3JyJG2Cpqys5WgZ1PanxdnhAskODH4PygN9hPg/FFemvF1e6bX69pH+wcJ26R/P/Fb1P4DL55yo8YfPnHlZ5Lg=
Received: from 30.74.144.114(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wl3-EKr_1754358588 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 05 Aug 2025 09:49:49 +0800
Message-ID: <ebbac3ee-df43-4a39-95b2-53f9cdd34e16@linux.alibaba.com>
Date: Tue, 5 Aug 2025 09:49:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/6] mm/huge_memory: respect MADV_COLLAPSE with
 PR_THP_DISABLE_EXCEPT_ADVISED
To: Usama Arif <usamaarif642@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, david@redhat.com,
 linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, corbet@lwn.net, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, baohua@kernel.org,
 shakeel.butt@linux.dev, riel@surriel.com, ziy@nvidia.com,
 laoar.shao@gmail.com, dev.jain@arm.com, npache@redhat.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
 vbabka@suse.cz, jannh@google.com, Arnd Bergmann <arnd@arndb.de>,
 sj@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kernel-team@meta.com
References: <20250804154317.1648084-1-usamaarif642@gmail.com>
 <20250804154317.1648084-4-usamaarif642@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20250804154317.1648084-4-usamaarif642@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2E71E1A0007
X-Stat-Signature: j786my8m6wgf668duwuzb6a4gjjnfhjo
X-HE-Tag: 1754358593-296655
X-HE-Meta: U2FsdGVkX18sF0zhLaAAQ3wT1dxBSFoP2UVFJ1T/PGCbk0Ne+3+LzvkCSG1vU9/GGDnbco0WReIK3ssb7vBJCd0XReKNIir9FSlhbBqlKdj9V53AephUlkGKOGwHAFogx5P/5b82D17cttoiuiIvA/Ned0Lakb5PbT6e7BTwVyDwthxxkSPu+QnSDE9IuXAWaBou/XH0VTJrDMkdq9o0JBswZxDTs7KuknOCKE9bp1A5BPa1LrknYPv7SO53Eh1VFwTh+CgcyVSx9b0xDys3UZy7ixJpDbOO2FTFJoA1p3BmgEC7YvY3jFIYhTpIEBG1vfb2IpLBRVWmGT2R1p+YPcocbSHAyoU/VcPWzUnRprxbsflGE5IFIDpbilF0M5xbz0Zg0B8VVS6bHYXEF6qcMw/tfxyMziC3xyGFcK48KySMRlUDmgel3vPysGMxidGkLopwR1DKy1h2ZS0tj2KRFN+E7R1Zjhg1wcH+uT1YHIGxiUr8B5NK1zPBTLRuiuU2b5KLytXLsYCiw98RkKfLWYyk1lWX8XGHlfGtDYSS4xg0M0Q+m/GNzgfhpoqtqAF2EvXGNLRtFWXpMJC6uWw2kcVNH1EGsVYeSHm4SJl77WUk0cmPA43k5MUsg7SGnhn3tCaBY5e/o3VohmuA5OWVPL4jCKozT1J/vzbUIVTWsWS436+6gJuRaIUXCyzd+0z65p2xOMgw96QHvhEXQPDRuXcqc29OVSysXvgcxET3O2PwCUwF4PSVh/qw8agKLs4K9BZ4uzouBg5z1ANWTOBg5XYC4cx62g5VUBKQNGQMTAqK/CMivY62B0EwzUq0H/OKtunRL0lLYtE4/RfCstLYD6boVLS5PkRY1yMhga2taX8H4leXy3S8jZGXnvTDsTZaj0Jt4IakEIsOyh6ucbdva2y9D0qjYoQbC2dZlqEai5gxLRBUEUE5vGCzAztE2D8C7W1ci0Q4NR5rG1Ie6r8
 naRyOjAL
 vrSRwAMqiNd8/QNv4ZHoT/zeZ4bhvf/tHKHCqH8638amW+b1lF7kBkkEg4w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/8/4 23:40, Usama Arif wrote:
> From: David Hildenbrand <david@redhat.com>
> 
> Let's allow for making MADV_COLLAPSE succeed on areas that neither have
> VM_HUGEPAGE nor VM_NOHUGEPAGE when we have THP disabled
> unless explicitly advised (PR_THP_DISABLE_EXCEPT_ADVISED).
> 
> MADV_COLLAPSE is a clear advice that we want to collapse.
> 
> Note that we still respect the VM_NOHUGEPAGE flag, just like
> MADV_COLLAPSE always does. So consequently, MADV_COLLAPSE is now only
> refused on VM_NOHUGEPAGE with PR_THP_DISABLE_EXCEPT_ADVISED,
> including for shmem.
> 
> Co-developed-by: Usama Arif <usamaarif642@gmail.com>
> Signed-off-by: Usama Arif <usamaarif642@gmail.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

