Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA0DAE67496
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 03:56:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EA5C6B0088; Sun, 21 Dec 2025 22:56:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C21B6B0089; Sun, 21 Dec 2025 22:56:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EEAE6B008A; Sun, 21 Dec 2025 22:56:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F10B16B0088
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 22:56:54 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 744CF60C88
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 03:56:54 +0000 (UTC)
X-FDA: 84245745948.28.5326D97
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf10.hostedemail.com (Postfix) with ESMTP id A1F9CC0004
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 03:56:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="xm/bVOme";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766375812; a=rsa-sha256;
	cv=none;
	b=onLnqYyf5uhWt3j7qLGYkwXgx4tA082GjNZiBayFIvblpxETN63f7C/XICkXK/e+a1N98X
	cwk5HY1Gxy75e08/aIv2TcpQYUyjaBVXliNqLlS1gf8uFyYwDw34dh7UGmZ1CW6sC+xfDJ
	7fZe+lFrqs4H9XZvQ7Umr7XjQNLu8Z4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="xm/bVOme";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766375812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hlV2Yr2sfGvqresY8S2eoKk7pM6GxAvG8vIiPkIJn+o=;
	b=rfcY/MO9N3Ozjxf+4TyU11zMIjEgoaDNnilL19xUjVm32MiVW/Q6kG1Xskw3C9I9JsxZr/
	j9+vmA9oLoNcmr7q69nTJJ+uCBhWHs3ws6HCR52RJtzVrzXbUM3HBn+xZ8qdLI1r+Tkv5W
	ripbwivB9PDHZNUhhNKCtelAR0i6VTc=
Message-ID: <81e91219-478f-4f23-8bde-b307130ddf67@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766375810;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hlV2Yr2sfGvqresY8S2eoKk7pM6GxAvG8vIiPkIJn+o=;
	b=xm/bVOmeP43/bzy2D21mp0seBwf+65r4f1RzLre+TL5t8rsBsOoIi7mbT7bk0mRyLIyeCU
	rzzqhSGGBYLV5msZfhXBdfVM/qPEyRxlc7REPjPHPcweD2pNJsnuMK5y83xiC9WdP/vmXv
	myMNW3MiMOIM1dgFQW5iOs8HA1VVs/M=
Date: Mon, 22 Dec 2025 11:56:32 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 26/28] mm: memcontrol: refactor memcg_reparent_objcgs()
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
 imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <8e4dff3139390fc0f18546a770d2b35c9c148b8b.1765956026.git.zhengqi.arch@bytedance.com>
 <aUQFiFIsvSez8AAP@cmpxchg.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aUQFiFIsvSez8AAP@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: A1F9CC0004
X-Rspamd-Server: rspam10
X-Stat-Signature: naycmm36fpjoz7qscmd3otfza86z4ain
X-HE-Tag: 1766375812-352402
X-HE-Meta: U2FsdGVkX1+4knBakkLr5lZwJ6paHMLn4zFV3rQorJCZG1M4tCzgruwyW2oXNL7OIN/z1PwAnfCrsOpXUVoT25sy965cwXUtSAN02pOiLailf+GJwYTV2RW8S6VLAHbdZNqREz8/HRwRLt1LWe7wEVrR2lXnT2p6fXevWBJlMZNKbhxZdeP7b9Z0afYHuoGawatN19DMYpOJr2M/H58qOA6TKerh9PuLliy5FsHMan6Y8Djc+q+YVvMRAjtCo/+qMbm9k5+2VbiBBsRMLYADbAFJKmZ0C+xFppHW56iwhwLnPWlrXAAuzKVMjVqG8f5bA1i9yOHlOdq3EBgaB9LVG7EqHbi8KKPQvQBs2RjmGcy1rFwrQzFYoB5FNw0XSgoFL1tB/j2B7csPwzWOGU+1nnNFIBDwxTRY0GNjrEUOIpVeapDM8M1f1Ufq/5nO2xti10iwLX0rbfGZxqhoW9GI8iBK6xUnCP+tO7KF0zHrzuebRi+LymEihCnny44R8LphKkFMEvldkPDKb1CLcjGfwfdBbZBiNiTisLu1khO6HNgjNAGwNqIRFhtieA0m/h8ltjtyXrCaQIMLObBUTXoTlkbR48MzrMjWLfVRFlhfS02H0J/yUvEGUwfEPP6Kw60ajyrPDE6R6zHfEapT0pyd/EaoXWDNotTuRktX9VZZxH0+i/Tmo5sIQRoBRkdtyaVjVDsAaQbd5fj/j9/7VijPfN8dcIkA46EHFLuePTF0HoBnrqeevMtLi0aCKNTQIOT1/d0qAktvgnNJCHpj2tG0mFDXEPOtHXnu0dW9D1TbMi38y/4+0gYr8+NIdmPh+KN5Gqtp9xyUecWhyH7CsG0oBJ0MhG39IaaPSAAZzL3d9TDTf8S2mrcErZl22AMLG7h3MnE+tCDmuC0tEUPzmLeSnzKC3vjAXQ1+xbUBthEobwKcxG269JKQR1prIXGk09oVLmMbprJO9My1koneOOr
 oMI3E7ij
 oVB51tbNiAVoxKYY2JGGIh1ldM4nj/CuYYEghcCuKVfPsfixXpAbXDzxTsLqD7deJOo4XdCML+044QIxq+FVjJVQCTzVI5pkILtApAqy700VbmGnAj32ArZJvDEk/KtR2v9GGm2gbrx5691P7DXFJzhIlPSXvraMQQ2PpJdZ1GbqSVXZdcCuRazaCXLW5h9yrptDt3WvsEMPw77HJdTnVikva2R2CX70d1L/iFq28WN5or/TIVNP8CLT6ymEG0i9BNQZKug/umZUqhe7Q7zc1KxTyIurXFn0WDQSwyOdwNGqAFpfwS7f313CxdovYHGavcUFp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/18/25 9:45 PM, Johannes Weiner wrote:
> On Wed, Dec 17, 2025 at 03:27:50PM +0800, Qi Zheng wrote:
>> +static void memcg_reparent_objcgs(struct mem_cgroup *src)
>> +{
>> +	struct obj_cgroup *objcg = rcu_dereference_protected(src->objcg, true);
>> +	struct mem_cgroup *dst = parent_mem_cgroup(src);
>> +
>> +	reparent_locks(src, dst);
>> +
>> +	__memcg_reparent_objcgs(src, dst);
> 
> Please have __memcg_reparent_objcgs() return the dead objcg for the
> percpu_ref_kill(), instead of doing the deref twice.

OK, will do.

> 
> And please use @child, @parent (or @memcg, @parent) throughout instead
> of @src and @dst.

OK.

> 
>> +
>> +	reparent_unlocks(src, dst);
>>   
>>   	percpu_ref_kill(&objcg->refcnt);
> 
> With that,
> 
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Thanks!



