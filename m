Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B04BCD3445
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 17:01:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C2FA6B0202; Fri,  8 May 2026 13:01:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 874216B0203; Fri,  8 May 2026 13:01:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 762D96B0204; Fri,  8 May 2026 13:01:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 652036B0202
	for <linux-mm@kvack.org>; Fri,  8 May 2026 13:01:07 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 83EDE89A30
	for <linux-mm@kvack.org>; Fri,  8 May 2026 17:01:06 +0000 (UTC)
X-FDA: 84744867732.07.ECCF997
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf02.hostedemail.com (Postfix) with ESMTP id 508758000F
	for <linux-mm@kvack.org>; Fri,  8 May 2026 17:01:03 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ANaa7wyI;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf02.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778259664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lhN1OtWgx8SliynbSy2h0Vl5E4QHCmfcWr1S+SKN4Nk=;
	b=4ZslX9IAcmjY9XjrTtQLbhaa75PT3Yj82OEHo0THdYbn07bDherdAZP7Ew1bmnPYgmq2/A
	ufCyiG98c9SuHNkozuHy3w50TkelH09et908/DQ5S/vucTTZZr7ftufj6Lf+Qq2quulDpe
	qZiaHUx97gsKDwBORw5GsVZSN6br46M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778259664; a=rsa-sha256;
	cv=none;
	b=RXUndnEae31+B3JIItqDXughrtgJVRRciT4BPWMk4PJ67XHu1ECwkLYtZVwLkX20U07Kzz
	reDT21w0eNy2sjddxSXRIh7ncvdmF0bfC7Bsw0rePv659ZAH5csHRW4c/ALB3Nuk4jpceh
	y1nZ/oRg5mELirMeMyPq5zloiGSjFZY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ANaa7wyI;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf02.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778259664; x=1809795664;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CeMLwSJrpEuwTrQpukyqF+pZbz0VxmVlzSslUqnoQvQ=;
  b=ANaa7wyIeHMpW06qCkZTT0bVfO6S9EeAcr7NASqwK6snu2hvzQpXzG2D
   mPWIdtY2b+Q6MwhC1pVAqBRjrhBUGF4LliOGahWnhChYAc4VlUQkSVD+F
   4VZd7z+6nSMHeogJVvPYKG0F7rmAJlDKhkJRXrEToqsqAGr19357QqQ6w
   TMmMACBgL143YDHYa/A0PICUbKdr6Frz7AR3BlMXJCgJAbWJA4V5T8T68
   h0NvMNS2SZ2ZgPXFKyKnVkd7GQGO2wArVvrD42+mm1GVcmoaoZPAcUYp4
   i5gcofqBa6TD9KvO82c4WPVEFMrthKWEF/K5Gb8jVYPjrFAr5OR0fKqyq
   g==;
X-CSE-ConnectionGUID: P0acy0YkRciIobk1P6eKOg==
X-CSE-MsgGUID: VlcnIHaQTVCayLtPjZADwA==
X-IronPort-AV: E=McAfee;i="6800,10657,11780"; a="96658484"
X-IronPort-AV: E=Sophos;i="6.23,223,1770624000"; 
   d="scan'208";a="96658484"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2026 10:01:02 -0700
X-CSE-ConnectionGUID: 9wvpYjotSkWcvbjnT/g/bw==
X-CSE-MsgGUID: fP3gBoqATsyvtovPonpGZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,223,1770624000"; 
   d="scan'208";a="235830152"
Received: from dnelso2-mobl.amr.corp.intel.com (HELO [10.125.111.18]) ([10.125.111.18])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2026 10:01:02 -0700
Message-ID: <ebc08803-17ba-47e5-8297-c040240665ed@intel.com>
Date: Fri, 8 May 2026 10:01:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] mm: Make per-VMA locks available in all builds
To: Lorenzo Stoakes <ljs@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org,
 Shakeel Butt <shakeel.butt@linux.dev>, Suren Baghdasaryan
 <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>
References: <20260429181954.F50224AE@davehans-spike.ostc.intel.com>
 <af4QC2It_jgSgCGd@lucifer>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <af4QC2It_jgSgCGd@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 508758000F
X-Rspamd-Server: rspam04
X-Stat-Signature: xapfthncexmoqr8djjx4y4jfbqgm7s7r
X-HE-Tag: 1778259663-426146
X-HE-Meta: U2FsdGVkX1+LU3l2mr/phg4zo/vcWEj3qbvkMGBBYjMbR0V2kBIhSf9xWBt1wKDE+/Gbdop3j0UIMnDZCy74ekx973E+xR6Fn7f1eXsnzD4Rec90MSDGrPzoQmVMIfj3OP59cp8bM2yhHRLIWxbTrFIiTx8paOXy2SSh3+QPhwQQLOapcAssRuNaHKQnhddPTAwhvz2XxKLylcBr9BFkR5caGQE+Wjd4mQTo01Wgh2TPAowAyGfFku1iOPuvwh4xoylV5IwHTu9+Ql0UCWSu+fVYqrEnYjuowR3KRKSzEokOn3Jtr4uXN945XozBeoYqkegpPyvk4kfStjMy4msdnubHTBto7SVUhKsr4bGPiHU7Tgaql/VnDBGOaZFWMy8TlFONpe1LaMJWzvwwX3+ypXn50c6nQ9AHwVn1LPS5mLraqpZLcQM28bfRamomh8Jd9E/Jj1C6lNJamrB7HWeuwovbS4iyVCBJeGRyDOv/Tpp6u/btthVIi1oKMrFU6Xgu09sy+c4ZpZDz4Fb/1Dx67i8j1YKR2JFL+8udXvrgiKFG/q+vpMmvh05MoYZco3zGap6MWKQqwm7hG4f8lRLScg+S8FSYBJ9iXVKP7ECYnNYQPlp56jkxe2B8yLAgb5+p1N05UeVhs6Bzam3aDJCWL6VgxcUyks8pyAvt2+6o1IJDVqteExdlqgKvrfH+nejfg0fJxNk6YZT6z2poiGrgvMbAVZV0QqMWzFarYo4jwCLZf6GJkDQU9X3z9z1m5x3Jxc4URdUwLM5Tkwh4TMqDcP3M18OD1ddpAamVjkR+JyHR8rPXhx5J3DXIf/70/sOCUfC7sxX2YUFK0lBmov0WXtzdoYKj0+4xCwU2Hc1e/8FiRCivZ6qm7XiQcFQ8dxlybfU5RKqe26V4nMp1ePmAS1eOYAbJ/mwmxazvhBzRPTIhQupHjt2HNxrZzwUxdwkd4kL8sifK8GYRXmoM3aO
 i6tl5SwK
 zwL3EDbDLOFuZU4Rdt/I8q7nzf0P7NP4sR2Rq/zurx/gWb35DlDc7t+SSEdjUbFRpG6YqZPItpYz3oB+y0HtZsG524NcTMKxZeYZJ0K05OJ/F7P8Z7l5rwNA9y4xGxQHt/FsnoouDWdPXFdxZp4redqOHcGGcoBIm0DNdkePRHJPbdpOwzl89D1cFrp6kApTjNp9Q6I08woFmHBI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/8/26 09:52, Lorenzo Stoakes wrote:
...
>>  * Can the helper avoid the goto, maybe by taking the VMA refcount
>>    while holding mmap_lock?
> 
> Surely that'd defeat the purpose of VMA locks though? you'd hold the mmap lock
> for less time but you're still contending vs. _any_ VMA write locks whilst
> trying to get a VMA read lock?
> 
> Unless it's on a slow path... hmm :)

Yup. It's in a slow path. the example helper I had here does:

retry:
	vma = lock_vma_under_rcu(mm, address);
	if (vma)
		return vma;
	mmap_read_lock(mm);
	vma = vma_lookup(mm, address);
	mmap_read_unlock(mm);	
	goto retry;

It avoids mmap_lock in the common, fast case. I was hoping to replace it
with something like:

	vma = lock_vma_under_rcu(mm, address);
	if (vma)
		return vma;
	mmap_read_lock(mm);
	vma = vma_lookup(mm, address);
	vma_start_read(vma->vm_mm, vma); // Is this safe?
	mmap_read_unlock(mm);	
	return vma;

Which still uses mmap_lock, but avoids the goto. I'm pretty sure the
first one doesn't have any locking problems. The second one, I need to
think about a _lot_ more.



