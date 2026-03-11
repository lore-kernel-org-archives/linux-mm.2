Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E85491125856
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 17:22:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18A776B0089; Wed, 11 Mar 2026 13:22:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 138DB6B008A; Wed, 11 Mar 2026 13:22:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 010686B008C; Wed, 11 Mar 2026 13:22:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E26B06B0089
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 13:22:16 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7309613A787
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 17:22:16 +0000 (UTC)
X-FDA: 84534450672.10.FC6CC34
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id A66844000C
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 17:22:14 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Dy76PaxH;
	spf=pass (imf01.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773249734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ODGrdIv+ZjAlvaofPPbJMPK5lyA498il7o831Rt1dLI=;
	b=cuav+lS4MxCvIg+GyNfAgCPIndBPtTn4oRW4oOPyCh+E7OYOP2nbmEn6uOyfyMr3S2RXWC
	kAq08rhXImnnIrKSacbgAuMclJT+HE2jzOsnWcPgvZe7pnIaW55L1574yTXCkl30ZBcOOa
	t+ZrCa0kbLL5JUCAOJqRDeaPLe+O5wI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773249734; a=rsa-sha256;
	cv=none;
	b=yFB1y+8cjj/cXrLFYHmu3eqZkKXADTyfegbSVCHwlouXYC7P0r+o30Bve74K9op444ymU1
	ZP8UnuHVXde+NkdSfbY7jsJ/O3tFXYCO3NUH2zyeDxcUqOhHdw4wfdQGRlZ7K9UAhUV8lC
	umLgFwqLA7/WGU+EX6TaW6yt/lzRPQU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Dy76PaxH;
	spf=pass (imf01.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9E45340B81;
	Wed, 11 Mar 2026 17:22:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1DF0C19424;
	Wed, 11 Mar 2026 17:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773249733;
	bh=Miq7+lC80ZgL5Yf3eBrK42td0FFVlYsHEdd1Nbdlllg=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=Dy76PaxHIrMoUsao+pkkgSxDgouEEKufXWOeSd4MCWdjjQ9Tuw9yVFON6zbiZiveg
	 C3HRl/drhOHw83iC2bqbK4+zxDC9B/Db3PMNg9EZj/thATTgWyE18gO4N/gvgANtu1
	 0bOKbFYTTlwl6WfYjjZIzCO2asbX84SfSWjnmGk0+DjEjYWQa3PlG/oCrt4WTv0atw
	 peCjRDEphzCz9XnMAwb2lJope/fGqguX0MxeoA4OXOaNpdcHGEgqNtMxsbC6eXdsUR
	 W+4zW1Pc2EEENU+QnQpPZ7WjlMh9l+F38pbXByPzmt6lprRBcEpNP4E+E1mDBjtSF8
	 8RPpdk/oBvt6A==
Message-ID: <8ab58ecb-1fc1-42a1-b67a-c3107de2ece4@kernel.org>
Date: Wed, 11 Mar 2026 18:22:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: Re: [PATCH 0/3] slab: support memoryless nodes with sheaves
Content-Language: en-US
To: Ming Lei <ming.lei@redhat.com>
Cc: Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260311-b4-slab-memoryless-barns-v1-0-70ab850be4ce@kernel.org>
 <abE6uqdzMUv8k0mU@fedora>
In-Reply-To: <abE6uqdzMUv8k0mU@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A66844000C
X-Stat-Signature: g8cfg8uh1mhicu6my4zhpwnzt9bfxpte
X-HE-Tag: 1773249734-13734
X-HE-Meta: U2FsdGVkX19D1M58mLNaZMQBbfZZ8geT7FMCjBPXTHyo1rFSNjD3dmzGAmZ8V92GYXBI11SGQjkRwnoZTjgh/yoIiFgAveyTjsC8ZLsAkWc9W2UqBUBPcIPizVA02ZCR5/6C6lxYJswZRv79pkv2Slq/jG8IM/CbbvImNfTycnXmrPh9jm6Gz0Qk7UaPotKVFA+NF+zIfXcRjVLgSDK0holuJZTVi4Krf6wRwIW7FMCqxRn153TQkvBr6Wz3MmIv3P2wT+sq3hTXyuEIfcDq7hvWU+FtHHyXAS/0PWsAjPUH+oIIjq7mBQsivKg5emLJXhM1g3plUp19r6V7qSfFEoZt0P6b6byvul01PHICgSnjMVSqdHoqw/3RiYQeYEcu4xd1fvz5GmDcYQpe6GuzJIoWzsbr45RVP1ENVLMv9eDYQrtyBHFe4WcHPz7gAN1iqGeHgjJV1ZBbVYUCE4ep4E3ve9V0s2slShJvnAxdB5nCP5/NzIOs7Anp7nqOIjqRIyBK2nk9yu0XRRKAitFYo19tcRoLJst8TNRqMtx46FumbXAKXxmQGlIsNMH6vQXmNy/cGtt0e5ercMDvk6ovdF1bV6ieRUxmyP7aXDwEYHkkjaXQYkEnVR6tKbp1/XyN8FYpgDz2aE40wHfx4s9MC4pv+/h1ZJuNIo47zrXtnrPhZdTSHwSIlXBijBc+i9qYQkdsZgo8s8ZcyPxG9oPfNsXKHH2PNYf+j/UwaMJOKfru9Cmc+POnO/QsqQX94gogoiB/l+sYXQzEkEIh3upjaYexCUadYMfdbo8CLIo9oR32oa51umhBjD/zcf8vqw4Pij0sOuxEjbsZNh0nGQ5ZVsMNIkZp6wXbXjj0nv5VYgCFe/tQyB9iZPqLJO9NjPKCi1xHbgz9DTHO3wfKIeRPary1veCmZMe76t7Cgi8sZyoJl6ISIvubBhHJn0MRa7GIX40SN8DTt+G5MgKLq9k
 +/sn6PVC
 Q2slldazmb+ex/G8Phn0yDM2VoMHeXp04Jm2bOwvt+0ylXwv1xJRKToAr8O5kcAqn/XsR/TfEYeEdpbNUPeaoW4GHr9qe+Si289Sdx+BA7KvgXS19EjbKChFRzYnWiglq9vE4T+27Itt/nabOcV77RS12+MssJUp08PeYnYi8dCzzKNBbqpWpbIUF56ADFV5zmFe8TMEO2qhs8Xo1de8ZPzhMTLexVsRemajV5OcNcUepZDnhFRy2BkgU9vU2f0mFg6d9ErvQ5aK1XVa5ubMSGDHE/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/11/26 10:49, Ming Lei wrote:
> On Wed, Mar 11, 2026 at 09:25:54AM +0100, Vlastimil Babka (SUSE) wrote:
>> This is the draft patch from [1] turned into a proper series with
>> incremental changes. It's based on v7.0-rc3. It's too intrusive for a
>> 7.0 hotfix, so we'll only be able to fix/reduce the regression in 7.1. I
>> hope it's acceptable given it's a non-standard configuration, 7.0 is not
>> a LTS, and it's a perf regression, not functionality.
>> 
>> Ming can you please retest this on top of v7.0-rc3, which already has
>> fb1091febd66 ("mm/slab: allow sheaf refill if blocking is not
>> allowed"). Separate data point for v7.0-rc3 could be also useful.
>> 
>> [1] https://lore.kernel.org/all/c6a01f7e-c6eb-454b-9b9e-734526dd659d@kernel.org/
>> 
>> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>> ---
>> Vlastimil Babka (SUSE) (3):
>>       slab: decouple pointer to barn from kmem_cache_node
>>       slab: create barns for online memoryless nodes
>>       slab: free remote objects to sheaves on memoryless nodes
> 
> Hi Vlastimil and Guys,
> 
> I re-run the test case used in https://lore.kernel.org/all/aZ0SbIqaIkwoW2mB@fedora/
> 
> - v6.19-rc5: 34M
> 
> - 815c8e35511d Merge branch 'slab/for-7.0/sheaves' into slab/for-next: 13M
> 
> - v7.0-rc3: 13M

Thanks, that's in line with your previous testing of "mm/slab: allow sheaf
refill if blocking is not allowed" making no difference here. At least we
just learned it helps other benchmarks :)

> - v7.0-rc3 + the three patches: 24M

OK. So now it might be really the total per-cpu caching capacity difference.

> # Test Machines
> 
> - AMD Zen4, dual sockets, 64 cores, 8 NUMA node(configure BIOS to use per-CCD numa, just 2 memory node)
> 
> - numactl -H:
> 
> https://lore.kernel.org/all/aZ7p9uF8H8u6RxrK@fedora/
> 
> # slab stat log
> 
> root@tomsrv:~/temp/mm/7.0-rc3/patched# (cd /sys/kernel/slab/bio-256/ && find . -type f -exec grep -aH . {} \;)
> ./remote_node_defrag_ratio:100
> ./total_objects:7344 N1=3417 N5=3927
> ./alloc_fastpath:476106437 C0=128 C1=26852005 C2=128 C3=27291181 C4=65 C5=35617011 C6=97 C7=34258221 C8=96 C9=28158690 C11=26433128 C12=128 C13=31715794 C15=28819773 C16=97 C17=26168947 C19=30768051 C20=128 C21=32964376 C23=34696825 C25=26471644 C26=130 C27=27844688 C28=97 C29=28480054 C31=29564950 C40=1 C42=2 C63=2
> ./cpu_slabs:0
> ./objects:7265 N1=3374 N5=3891
> ./sheaf_return_slow:0
> ./objects_partial:533 N1=212 N5=321
> ./sheaf_return_fast:0
> ./cpu_partial:0
> ./free_slowpath:295 C4=158 C6=136 C20=1
> ./barn_get_fail:270 C0=5 C1=16 C2=5 C3=6 C4=3 C5=21 C6=4 C7=14 C8=2 C9=7 C11=23 C12=3 C13=10 C15=19 C16=3 C17=4 C19=25 C20=5 C21=22 C23=6 C25=21 C26=5 C27=6 C28=1 C29=4 C31=27 C40=1 C42=1 C63=1
> ./sheaf_prefill_oversize:0
> ./skip_kfence:0
> ./min_partial:5
> ./order_fallback:0
> ./sheaf_capacity:28
> ./sheaf_flush:0
> ./free_rcu_sheaf:0
> ./sheaf_alloc:179 C0=9 C1=1 C2=4 C4=8 C5=1 C6=4 C7=65 C8=3 C10=10 C11=1 C12=2 C14=11 C15=1 C16=5 C18=8 C19=1 C20=8 C21=1 C22=5 C24=8 C25=1 C26=5 C28=5 C30=8 C31=1 C40=1 C42=1 C63=1
> ./sheaf_free:0
> ./sheaf_prefill_slow:0
> ./sheaf_prefill_fast:0
> ./poison:0
> ./red_zone:0
> ./free_slab:0
> ./slabs:144 N1=67 N5=77
> ./barn_get:17003547 C1=958985 C3=974680 C5=1272016 C7=1223494 C8=2 C9=1005661 C11=944018 C12=2 C13=1132697 C15=1029259 C16=1 C17=934602 C19=1098834 C21=1177278 C23=1239167 C25=945395 C27=994448 C28=3 C29=1017141 C31=1055864
> ./alloc_slowpath:0
> ./destroy_by_rcu:1
> ./free_rcu_sheaf_fail:0
> ./barn_put:17003623 C0=958995 C2=974679 C4=1272023 C6=1223496 C8=1005661 C10=944030 C12=1132701 C14=1029267 C16=934598 C18=1098848 C20=1177293 C22=1239162 C24=945405 C26=994447 C28=1017138 C30=1055880
> ./usersize:0
> ./sanity_checks:0
> ./barn_put_fail:0
> ./align:64
> ./alloc_node_mismatch:0
> ./alloc_slab:144 C0=2 C1=8 C2=3 C3=2 C4=1 C5=5 C6=1 C7=3 C8=2 C9=4 C11=14 C12=2 C13=7 C15=11 C16=2 C17=3 C19=20 C20=1 C21=5 C23=1 C25=13 C26=4 C27=5 C29=1 C31=21 C40=1 C42=1 C63=1
> ./free_remove_partial:0
> ./aliases:0
> ./store_user:0
> ./trace:0
> ./reclaim_account:0
> ./order:2
> ./sheaf_refill:7560 C0=140 C1=448 C2=140 C3=168 C4=84 C5=588 C6=112 C7=392 C8=56 C9=196 C11=644 C12=84 C13=280 C15=532 C16=84 C17=112 C19=700 C20=140 C21=616 C23=168 C25=588 C26=140 C27=168 C28=28 C29=112 C31=756 C40=28 C42=28 C63=28
> ./object_size:256
> ./free_fastpath:476102026 C0=26851883 C2=27291053 C4=35616664 C6=34257923 C8=28158529 C9=1 C10=26432875 C11=2 C12=31715665 C14=28819520 C16=26168783 C18=30767788 C20=32964224 C21=2 C22=34696578 C24=26471388 C26=27844558 C27=2 C28=28479894 C30=29564692 C31=2
> ./hwcache_align:1
> ./cmpxchg_double_fail:0
> ./objs_per_slab:51
> ./partial:12 N1=5 N5=7
> ./slabs_cpu_partial:0(0)
> ./free_add_partial:143 C0=3 C1=8 C2=2 C3=4 C4=11 C5=16 C6=13 C7=9 C9=3 C11=8 C12=1 C13=3 C15=8 C16=1 C17=1 C19=5 C20=5 C21=17 C23=5 C25=8 C26=1 C27=1 C28=1 C29=3 C31=6
> ./slab_size:320
> ./cache_dma:0
> 
> 
> Thanks,
> Ming
> 


