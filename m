Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EF9DEA3F27
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 09:52:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD9296B0005; Wed, 11 Feb 2026 04:52:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A868F6B0089; Wed, 11 Feb 2026 04:52:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 989B56B008A; Wed, 11 Feb 2026 04:52:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 892B96B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 04:52:31 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 37FEA1B34A7
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 09:52:31 +0000 (UTC)
X-FDA: 84431710902.16.2964665
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 693A24000A
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 09:52:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D7y272Pw;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770803549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MznkiduodhFwqc6+s4tdAQKjuitI7SIA33mvKF2Zmj0=;
	b=tzzUuqSAJGHNZO60HWgS6SovTXB0jcOwIe6aMeCP8lmSx7P0zu9b0LMEMyl013An50BWef
	qe5/r+8rOoAiQkzz/1RXjzrPg2UY04zjEa6tNatKxLv2YVLKWMzRtzziSmklLeaHPhhPQs
	eu/QZYbfE0SAkiJGyNFBPebDFNeh91o=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D7y272Pw;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770803549; a=rsa-sha256;
	cv=none;
	b=6WHYjvZt1Pg4NU0Tb77b4U0E+ywDobUn1PQQ6PYZYy9HNVeC6JGoRONo9+sRWwcqwSVvxY
	LIEbPkMrb13joKt/mY/3260mpLMZK4w/1Wj9dHR1sAJAhEaIbWEp94x0gljGSQ0Si8OSAy
	Mv1MOTVLhgz+lOXSboQJSnB0qkrhMz4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5607540C1C;
	Wed, 11 Feb 2026 09:52:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F36C4CEF7;
	Wed, 11 Feb 2026 09:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770803548;
	bh=jZE7p6/Tv2joRtC8XY1WotTMk8EeJ2cN3zlOCKCCW/8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=D7y272Pw07UiclTv6Ke7GjHzbWPj31xJLtLZxihUrsfYCYOC+KEXlnBcepfQpmEEM
	 ibl72TcF8jxAjdy2n/KD5ZFvBOn4bqZn2Qb3SHmAAaoo8tLMDy5Yqj94OHtEsjR/5u
	 WJtqNIatEzBwsLk+IEn3/UG42hYwZ4TtCSWYMihVDmrKS4qNbo/yt8b5Hu13yipqd9
	 WoH+CuCxowHU4f+fkQv7b2ZwsGY6SFO4lYh01XpypD3yrLDjVpCGkwmZss2t2xzXIF
	 um2LslDR9HlTxT9rtNVcdAdGHM9l1ce9EmfTeAfiwzt+Dn+RYx0oSDvUgArXAGFDm4
	 R6KNvmWrWgOJQ==
Message-ID: <2359d7d3-61fa-4b29-9205-b9ad96839729@kernel.org>
Date: Wed, 11 Feb 2026 10:52:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 00/17] mm, kvm: allow uffd suppot in guest_memfd
To: Mike Rapoport <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
 Andrea Arcangeli <aarcange@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Hugh Dickins
 <hughd@google.com>, James Houghton <jthoughton@google.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
 Nikita Kalyazin <kalyazin@amazon.com>, Oscar Salvador <osalvador@suse.de>,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Shuah Khan <shuah@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20260127192936.1250096-1-rppt@kernel.org>
 <aYJg5lT9MG0BQFkG@x1.local> <0032ac8b-06ba-4f4b-ad66-f0195eea1c15@kernel.org>
 <aYwb2XgRiFayzBXS@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aYwb2XgRiFayzBXS@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 693A24000A
X-Stat-Signature: 7be87un4tji1h4z9ez67dekme3wiascq
X-Rspam-User: 
X-HE-Tag: 1770803549-385708
X-HE-Meta: U2FsdGVkX1/fS15zvyWZGhXU5IaSVfkbSpv/rMOCj2KPFHC8r1x9Ay0GXP1qUC2tex8JARASEkgv1Y8NPOU1d7ecj/dWEzXxLWPhz+cvYkXlSp5kTtmelE+qAvdRbztBve6oUK05lQeU1vv740obFFh/e8kaKIKZNvex9c3R+m2jLa6LNqprN8Qp2rGLsRGIDfAlRyE4+Dohw/zgYshwfdi2uFfhnCKYqOAEKu1QgspUpjC/vcdmVjUG1l25VhOSC2LsWIU8YJuhwytwVmqv1s2WCffX66aTbxAMS2CTx9GVb6lMZAP4l5Kh0qz1/cnjGbPG9SkW1zvWhbgs/TdD09KVsIlPg8LqyA1u6jcWzHX0a3423QN/iIajkKZi4fpB5RHgrG6KsUxghjbeLhROYjpW2QC4Glk/akDWE3uiEFkUoIrzjIzAea+WQTm+OvEBfF4lhpxlz50z3+HZY1Odhm78xu+u+Ao2UN3hcutVUNuf3ccymYI7t1G10JecJajrYBtQtSQ/gGovLiYDGb2bgNSlfNzIx/7uHOb+0ukGpZm6RX1RNjM024vZ1375JKDeeCqG525sdei5hlLChBgD43O5capwL7JEH2K83n8xl3gh2FHR3AxgODRbyzHvWGDI5ZYuaLMSb6uoZa9YyUvKr5BfuVqD94jD2zDkKAIp17ergAf23cG7l4N7fx8J+D7sTOkfwdMhr0jJBwA62JISODCkqMSBelWegG20cK/Q4dbMc0Hu1CCc1FPXbfXWS/idgl/u27wa2BsomJo9RzmxlsqfSmk3wmSdA4YJX/QkCEhRnKLuxCyuYmnDv8T5JBww3MPq1OKn/pHi1YkVs2Z+PfHvRBNZPF7t+aXNvrWq51rPcfFlg8xkNmPsVsoh70aY6tv91WDIshgUuhr+l00Uk7mXJAX53L7Aspl4ioh3dbN4dYyP7s+utt7YnERbAzR8cImUbEu8WZkPmk6mn5E
 ewi23nr7
 DyRZeLLALFbHC+18nDFS3wjzEYYB73k1yXNZIPAOcGB5Y0D/+uP4+awjuUfWcVfo+mNEA5t480STIHu0Czl3cr8V4tqGtgaLng8w/KPO3KoUAyPtg3RysQFGDsACgTqPgyL7ix2g5xDwMBagFqECND4a28sxA2m8e5otqVq86qAbZps03HSuum2H8xBV9dsLAHaOH7p+71JmFqcGLXm8nMWbwlHCYr+tJ6xw6NzfTANLq0tHkqj2h9lUbEKv1+/CC501mEzPfDO5nWddDWM+ymzsLhQmDJzoGmqZGu8QuXPFnPJSIzY/8mM/yiA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>>> -
>>>    	/* folio not in the pagecache, try to allocate */
>>>    	if (IS_ERR(folio))
>>>    		folio = __kvm_gmem_folio_alloc(inode, vmf->pgoff);
>>
>> That looks better in general. We should likely find a better/more consistent
>> name for fault_process_userfaultfd().
> 
> __do_userfault()? :)

Yes, that matches the naming scheme :)
-- 
Cheers,

David

