Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04CF9EA4FD8
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 15:27:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23E746B0089; Mon, 23 Feb 2026 10:27:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21FD86B008A; Mon, 23 Feb 2026 10:27:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F8676B008C; Mon, 23 Feb 2026 10:27:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ED22A6B0089
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 10:27:34 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 996A11A01F1
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:27:34 +0000 (UTC)
X-FDA: 84476100828.30.B39F126
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id E985C180004
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:27:32 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RhxvaE8n;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771860452; a=rsa-sha256;
	cv=none;
	b=nYa5FqZITHBWQUClFfvSM3v2D2NDXLTKRuc0KlNL+fA8ZjWdqw9JsKgaOx+cAc5jvGqk7o
	OXy0g7klazhDawRADx95HHsbh9cUnR2dlngn8Id9CjU56w3pQAkRBl5PXSkWEJYIuQwzLW
	CPZAj3QFMCRRHkpcn9rX3kNJjWRjnlg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RhxvaE8n;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771860452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6QAWYQ8UpQenLZ0aHy8uXkQiFgVTozlWWowgolKIqhg=;
	b=fydidcuD+G/eeDKXkbZcufC126I3lgj9Sx7BBrEx4HYGiPGy/N9MPbhNazlxwdRv9EDYhw
	2wqQh9HAbKaPB/KDXa09/Bk2D8rsRhtoz3mLnnglHjOITElhlRBsdMHvK+RauhEaVJfUi1
	FtH77tRk9iYwBIhPd0z6bm8hDCT63ko=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D9D2E60051;
	Mon, 23 Feb 2026 15:27:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5437C116C6;
	Mon, 23 Feb 2026 15:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771860451;
	bh=sNIFAxdhsfczXp0u6khA1iIW4G427nJP4aj8xANK8vo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RhxvaE8nn/UMV0eGCQCN6bn3AFU1O7cE1NrNBD8N6is7e063xjThYwogLjKdFJpZD
	 ebgIqwodFIJ+4KeMFIny2fwDvixKBYpFJsgYAQDliELDxoz9p+fhiwfUDbNhkB8waw
	 p8eG9KFgN95UWQsqVzDMKndJgRm5J1xgUKy1IlwS6q1YzHNZb9KJTOSc0uYgJPYNsI
	 8aW0w51Zw0KGVuipNQgBzopbnZuKVbxGgLCSsqb5fNQkktOVlsRD77I4/XyzyzEss/
	 qQr0MqF/zzAN2DuA2QWeqREmuBOhDFiqADJhUZua6bZDN5d1kKCZ6XX5SVA4N1gOTO
	 qYsSQ7b5JSZFg==
Message-ID: <61e2acbc-d3c7-424a-80da-3c34a593c9ad@kernel.org>
Date: Mon, 23 Feb 2026 16:27:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 00/11] Zero page->private when freeing pages
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Christoph Hellwig <hch@infradead.org>, Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 linux-erofs@lists.ozlabs.org, linux-block@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Jason Xing <kernelxing@tencent.com>, Yushan Zhou <katrinzhou@tencent.com>,
 "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Huang Rui <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
 K Prateek Nayak <kprateek.nayak@amd.com>, Davidlohr Bueso
 <dave@stgolabs.net>, Eric Sandeen <sandeen@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 =?UTF-8?Q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
 Todd Kjos <tkjos@android.com>, Carlos Llamas <cmllamas@google.com>,
 Alice Ryhl <aliceryhl@google.com>, Damien Le Moal <dlemoal@kernel.org>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
 Gao Xiang <xiang@kernel.org>, Yue Hu <zbestahu@gmail.com>,
 Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale
 <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>,
 Chunhai Guo <guochunhai@vivo.com>
References: <20260223032641.1859381-1-ziy@nvidia.com>
 <aZxaIEFZr2NvO2eQ@infradead.org>
 <cb8d6ee2-fd1d-436a-b934-aff87adf5dcb@amd.com>
 <5105764a-8313-45bd-8b91-8c0ea8cdf077@kernel.org>
 <da2f5f7c-0252-4085-a490-a505d0169bc4@amd.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <da2f5f7c-0252-4085-a490-a505d0169bc4@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E985C180004
X-Stat-Signature: icharj3bwaib77ciutbqch8sd3nak5p3
X-HE-Tag: 1771860452-798699
X-HE-Meta: U2FsdGVkX1//w8vZNx6SV9bumcS2HmrCQnECjpfgCXO9BHFbKpdSL19mZ+ZO7DCBm68o88fW4Ctqn+dWRt/f1oUUZJU5kzsSuMblQEgXkgChBRuOnbh8dJPi5CpKmF2QHEPQ9RaBrIS5TnJ9UinUcfI5/G0V9F9A69vj/d9OKLuk7mOHoUsOtnHTvto+3gCYhFt2F5kSNnUlhl5lpGaLCr+u2o+PtiumXhgw+2GSg6Sr047NQrxhlST33SrcnsjWqvHHh+YgJ3p4kb2wCWa42Me22PFwrmtlf00EdJoaSLELJT2k5e31zkipZHqqxea9NFyhAJY9dKDDiXLCWT8zGLLjq4aQJpX3ccr02ZE6vDPwKaiMS4sTsBHwcW+6awtruV4PktxNil54pBlDxbmTI076b70SIhyzuiSdjdc3a010rQ0GyMKS2ZIft5rhboY5iyYrLpbgcOeTGQTBj51YTW2F3qZPYTRppT7MSdq744eIoX0p46gMUrXZOYlxvUaKv6xrlSYa4gnMuwuj3LjigdjNdQowk+tGTW14CSZRkjEP+X45QlolzEEeVYiBnHLTYOxry431w47xQpWfv5JB4oB+uSvLRajuKlo19+q6BwWMrbfWJqWaDe/AJCuriMwtaCEknxNu0aMEMmxMDNRho6IwaJhQ9DKmDuE5F7zEHkoLJa6bRy4iM600Er+oDumo0NWJC21+/ZxriOzYFXHovPQbW2hIHj44H2wUbAFA1NlJG8EeIBxot4I37d5Msml6QyB2qAnGbdWBrHIXIju+SHb37O0OuMyVkwT1Qr9oU4SnGX8WVS9gJlOZFtQwJejDnPxm41YNUq/ky2DOz4qT+HBR+IoElOgWO5UOKcgKGlFGrykCYLRoKOsp6fo+jCRwfxrg0+Erah388P3/XqloL0d7cWSeAP40xSCugpTIQqueXG9HrPiWDPOW6gU69bGjkQckViV6Nh0EDYcYVtA
 VVPUUGMI
 kyz/wyE3EfaPvOODdkOBozGMHZGyumPxrvvf/IYH4nd15zmc5ss1BCzGyegggzxFksB6mvaqKkkHUqxUmDRg9Yfv3SSacNaiRW9fVI574KETYQ2Oh8BmPHmLj63mrgyCH48o6NKxJPkuGK9TV5inanDXrAXNBSIpv6RuA69wpI/HxfroQoyt2RhF2MIqcljkwXUp9XSZD3n0q+XXDR7MIfFfe6Uh/TFBs85moJtky5mv7MWzSAinImfLOEiHIY0/WyDrvl+2sADkndWD9/vRwBwlH6w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/23/26 16:22, Christian König wrote:
> On 2/23/26 15:14, David Hildenbrand (Arm) wrote:
>> On 2/23/26 15:06, Christian König wrote:
>>>
>>> Completely agree. This is just asking for trouble.
>>>
>>> The cache line(s) backing this struct page are most likely accessed anyway on free/alloc. So I don't see much extra overhead.
>>
>> I think the question is more around handling non-head pages when freeing larger orders. But maybe the overhead of zeroing page->private it there as well in __free_pages_prepare() is tolerable.
> 
> Good point, sounds like that is a bit more than I thought it would be.

Right. We already iterate over all "tail" pages in 
__free_pages_prepare() to clear page flags

	(page + i)->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;

Maybe zeroing page->private there is not too bad.

> 
>> I'll note, though, that we already require page->mapping and page->memcg_data of pages to be zeroed by the caller, so it's not completely crazy. (see page_expected_state)
> 
> Well that's not defensive at all, basically everybody which forgets to do that can cause hard to debug trouble. Maybe that practice should be reconsidered.

Right, we do have check_pages= to activate the page_expected_state() 
checks, where we will detect such problems.

(including the mapcount being -1 etc.)

-- 
Cheers,

David

