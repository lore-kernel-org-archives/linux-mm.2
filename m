Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28BB5606A326
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 16:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lbPC9u+W
Received: by kanga.kvack.org (Postfix)
	id 438846B00EF; Wed,  4 Nov 2026 11:07:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E9236B05B1; Wed,  4 Nov 2026 11:07:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D75B6B05B4; Wed,  4 Nov 2026 11:07:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0528B6B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:07:51 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 48CA8407BE
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:07:51 +0000 (UTC)
X-FDA: 85397917542.11.48F0838
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 57874C0008
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:07:49 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lbPC9u+W;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793808469;
	b=uQMqmC/4YRrglgteiKYOua0Nyeuyz5zTQMkgTqADUnHAmz2dPjKh+WfzfM2pLZGi7wdtX2
	uwy+6wLRITf9PkI9cybUsm3BfDh+ppOqc8V17uemUMkR5YQiBujqaFu0yCKadPWfhS8Sti
	Uc2qNLt/1EzjHjsRf2FMA7GLV0h0e/I=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lbPC9u+W;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793808469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=flMXNxiWEHoQiHXSBFrkZmNU7RGBVxxqF50tkqZe2B4=;
	b=VUJ/TotnvuVc8/83znfly9eY18zEeV5XPdA5/S5+sdkM+vyRgmRt99FEUwLexoOqZrNocS
	etT3Z+H058lszKKekK4ziWnVbpj4YxUIonGIoHYNiLYlU5ZA7xU2Ptbjd3HBSiTBQAqd4s
	M+bmECUX1zmVPlhrAIzASETqVavNnNs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2009D43F14;
	Wed,  4 Nov 2026 16:07:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D060B1F00919;
	Wed,  4 Nov 2026 16:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793808468;
	bh=flMXNxiWEHoQiHXSBFrkZmNU7RGBVxxqF50tkqZe2B4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lbPC9u+WqYTYnkkFYDRtOoONdVem35rdhn1WaS6YkI8WISarsntkV4jhI5q2fjK9+
	 zspoBxzyTUkVHUYhcWT+UZhrrzs06Ytq2pzC5iTmI2HNz1qFMVfT/9i4abcyJ65Tki
	 oEmwxGDSQC4cp9XWKAjS2WiCXIuTzH2lGkKajODaW77el/K7fQrd9jIp8mR2vqwPXV
	 w18nv7QajlOZt3UEKAZm5dlTzI5S6awAYFSiiZEX9loTMWocH5GahmjM3U+Wfo4DEP
	 YmlN9NpzVlydvVlh91CES/Dgm0Jom6aqg6OBuQ+IL2qClJ3+H5VDMcS4mmLRNU9zyZ
	 6gxO/iPPf1cvA==
Message-ID: <92e52f59-e096-4cb1-bce8-8081f489002c@kernel.org>
Date: Wed, 4 Nov 2026 17:07:34 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hugetlb: allow crashkernel to reuse hugetlb CMA memory
To: Kiryl Shutsemau <kas@kernel.org>, Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, baoquan.he@linux.dev,
 rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org,
 ruirui.yang@linux.dev, corbet@lwn.net, skhan@linuxfoundation.org,
 rdunlap@infradead.org, muchun.song@linux.dev, osalvador@suse.de,
 jbohac@suse.cz, sourabhjain@linux.ibm.com, ruanjinjie@huawei.com,
 leitao@debian.org, linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
 linux-doc@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, kernel-team@meta.com
References: <20261104142727.2894800-1-usama.arif@linux.dev>
 <autMHwldMudQOO3j@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <autMHwldMudQOO3j@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 57874C0008
X-Stat-Signature: 3is3tofnzkjfpgb6b1iosk1fc5f48ceb
X-Rspam-User: 
X-HE-Tag: 1793808469-752334
X-HE-Meta: U2FsdGVkX19BmAzMg+4Gty5Ane7/Kdp35TlVIXBaKhAxlLNsASV9Vy/cZxbJ1h8+6ILM29amtDi3iTts1g32ZAF+jZOOQPawN/ZO4dbqKy8JoN4e+I3oTNZnHoI8xlzM6Mzr9CrSj5ZDbD/u839SKk/HdI/GB49gQtdaQlfp64ppgM9vh1ej6dzPhgSypz20mPdgTOvGmbYWnh+HAtAdLMgH04eF368OaMDxUbxpIZ2jHsJUMyE5rzNAiFoEajcKWzx+xav1FJgtTVmuBUEfUEG3dW1DyHWFIKazGyVM7UajNX0gBreamNcdry0/yMB3U2q+GQh+fZZO1LD9iteUkrW8yvSEYBPIDEi01N9onlOLQErKmOxTzRTLrssbK6dVuk3RW0qlNMxr2s/7P/s9/ggDKbIjYRn2WbQFV1VrqPzn66NYvnIPkDVSAvW9De+w37GugywcBrWcFzz64AYZ5U0NKdSWu/e7zYn6YQ9iD8wNotUL+1pr8k4yGfekOLGUUSILP42zYatJ2bNVsZrzoLQG5dXQaqGFMivLNbQzp6iRg1RGR8Uaheuf6YYlc+Bkkn8hmp8QRSnmup+nlk+UfMoyahSkvWFQI30yV8c+/9ZuGvkFLtTI97h1JqYrzvmkub1Cpu6yZvLjkceMtpB2BsLzsNZ32TcwR6WkWgQp4QczyrFZPy+WJM+rR4+c3Gx8H8zSk11Ojo+2rAfCBBqGKkO7NpTH0bv8lEPc0CarWr2pmy999Z7PWJnmjEZTKDyfPY4AZEVFlFnzBoc3efk1DVpCQIKdJyBfCcjtiEZmyW2t/ujMifIqfe8XjxqEGnKTJL1Sd0g7IPA6vH4cTX6x2FBGQEGKPJi8KULkg23P/zy5q+H7NAxT8n18qRFFXJetyKdSdt8kUJW+vA840Bt1hZyjSRIb6r9JyGdZ+woC1WPHScO3JS2ZhCd6h5QhneaMUhKYamkdCrFK+cPbSOa
 5Iyms2zj
 alzyp2VZ/Cw5DxSgccE+WY1to12k3iPLoedveNBgyMGoCo5f9E0JWFG2hhLDp00jHKwmDpjZJAaNx/FlAICvHH8rThuxiwTq3L2ZxD8XWoDlNyhcbDI5gjR5TUnJHafkccWTVjZwg83RosN4gqpzQoGGUPQqbHPv0YocRyxsnmZ0ARhruQ1fT9o3TH9enYyR2sC2/ytnd0F9D4+3mmWMaqEZ+Snzkt5tG/MduIqSfo4pUwaVrrKi0JlAwrV02/EUGFv6p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/4/26 16:20, Kiryl Shutsemau wrote:
> On Wed, Nov 04, 2026 at 06:27:27AM -0800, Usama Arif wrote:
>> Use a separate suffix to make the exclusion of existing HugeTLB
>> allocations from the vmcore an explicit choice.
> 
> The crashkernel=size,cma documentation already says that pages allocated
> from the range are not in the vmcore and that it should not be used if
> dumping of userspace memory is intended. HugeTLB pages are userspace
> memory. I don't see what a new suffix makes explicit that ",cma" does
> not already.
> 
> Why not let crashkernel=size,cma take hugetlb CMA first and reserve a
> dedicated area only for what hugetlb CMA does not cover? With
> hugetlb_cma=6G crashkernel=2G,cma there would be no extra CMA at all.

Hiding that complexity from the user would indeed be nice.

-- 
Cheers,

David

