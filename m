Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D931EA4FC7
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 14:15:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37A046B0088; Mon, 23 Feb 2026 09:15:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 327696B008A; Mon, 23 Feb 2026 09:15:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 209196B008C; Mon, 23 Feb 2026 09:15:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0E4EB6B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 09:15:06 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C56E2B6380
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 14:15:05 +0000 (UTC)
X-FDA: 84475918170.09.EB452A0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0283140015
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 14:15:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lLBRzCGo;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771856104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dBncoYX+4WE3NuQre7Sy0cd4OIe5ZVxDQRulo50h7yI=;
	b=kwXqm9q5m5a9AdPknLIjAZhVHPdn/dNew/a4y2HVEhl89HFeizLYvDf3S7q238mOtTyDmW
	1rK+C01VXe+KLxgCkr2hd9MWlCFuxTXHf2TerDMtBzm/Jj/qEHoFr22Fd5SRQNLi8SCcjm
	eyq63BDCHmrt04yOj+Jug3kaBCp+JbE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771856104; a=rsa-sha256;
	cv=none;
	b=LjmF74FD+sxpm3HgFHIJULdvqkhT7YQtddjkyAzpdRLBgOTCPFqwnbNGF9Q+xQInJ9N1mX
	b3yB+ImqzfUA/HP2wcsUM32g01bbud90Vi3NJOC7HXIGE9SmVT4ETzJdifzM4ziCpdvz6X
	QJxqWFGXF9e/c8u6yIkWRUM6cHOVDnw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lLBRzCGo;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1467F600C4;
	Mon, 23 Feb 2026 14:15:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A05EC116C6;
	Mon, 23 Feb 2026 14:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771856102;
	bh=cegM+rd3V8p3uUtFz/8+ZfbKtzN5jDE+6Zwct258jo4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lLBRzCGosADz91G+m0U+M++rBhVB1sFW6A7qsoD9dN6XXO4+s05rc5r3BkVywjZ5w
	 LouVS6a8jmW1Gj25A/6t3W3wDXZHVYkbitm7KjtHu9x53QC8d5jybB2Icd91IbUaRZ
	 umKr2Kpnspd6uvw/1i/lrlCH8f2akdAADKn1LATlqbrPeC1NNpj3rqlPYd5MVtvvpo
	 3eSvIsPmG26g76HPLL0ubwowOC9ValMICw9XE+rm4z5SFGunW/7vqUvgjWwyOas66+
	 RA0uMZmzGKuVeostRLNPhCOqUOyNw1aOvZW+Sr1q9m53RRBCNF+1Q1eMPG92ItWQh5
	 EanKrkGsljLhg==
Message-ID: <5105764a-8313-45bd-8b91-8c0ea8cdf077@kernel.org>
Date: Mon, 23 Feb 2026 15:14:45 +0100
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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <cb8d6ee2-fd1d-436a-b934-aff87adf5dcb@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0283140015
X-Stat-Signature: oif8nz9akygro6oqsug75e7jshzhpy4z
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771856103-889344
X-HE-Meta: U2FsdGVkX19jp4eMm4YTWmIoTcitMGx1Q4SSiizm/kXN4Fsg7B8V1dbFMojSOiBhfi0VgTvhEVwv/R3palGICptl9F65x5HWBTIjNspE4SqIVUBVOjndZ8eXukM5TF9gjA9BREk8pvlTqa2Nal/UnO05ihmQJUWS4++uWGvTrmtAcdm5ivjNo/eGpojRRpUMIzCbQ9fel3yXMhLIF21j1ydFKzoqekuBUAQN9qDBXfcufw4sCSk8zo6u9z1sDA4ua+8dufUrnet5EWrbqWeyifTtWrzQqEpMU6xTOcyp6NIglF4lvoARaTGeSufMVmWQB57h6XGzcfisn4Mfo7O4qwKFFPv15ProRS/UWcj/c7ZXzfs++qo2MceQcbvEIC2rL2XNQFsdYMWIPrxC25Hk529cmlEzr0BpG739t2lTa+wFqKXGlB3HxE/7MSxURKCpiqVJ9aIRVkHgctl/6lF1H/yhHG3LffOGlYc5Hp6zaf7jPAzHOJvgHjIVTGLlHJoZSSW5lADc7M7Hk6jarD2kHsRWMRtRhEaWMOb+cM1bJTywINth7aMof66BCRBctXIKlDlx29R9mogus+0AywkIzKQHo0TEBVf7iFBz8qAE4eh3HDToAj0n0tHlcERSJojARlpbGN/kos6JKUzGDwhg+6G2xTh6lkd8eM5Tm2yPlawr+O7vY2TUdGJf+ovHAEjGvvzCBi4uvtoVU5enH0ThQttneJyyFyEcbpfq6nQyqWoaB/d+MMxuzyBfjio0awKbidhO7eYQbDIiH4H8f6gKTVQYSc0GSSugjqcghBUv1nKt09uASsBeXtjXog1qnkRQubqe6Nzvw1ePLdxSk1zgbc6CcfmQwa9A6v5YryB1ro0c6sDP4RgwK+Ama0tzr/4HzjzY+DyjIm8tsGriAL7imNVRMkK7rtKbBgrl5/5LT802oQZ/O1SmHaVAppa56kppC7FFoyDyRMXzlorxjTs
 YWiIOFDn
 xgVqzYq3ilVD5vz2Y9yoJOO+9T9EJTURu0Om7AcF4hxfRxyZmu7VNIYa2iqEKd+MnUS2EGVcebc7oLdDY+ktrybVpCamPU5sIF+TjTXKN+72xDOlu6ZzlW7pEXMIK52c626ac02+CeNfRkzag17gGgjjTUre99EeKhDMtrM3gsSOrw8PHTBXxlOkh5whf+6jHY4zlT3vyhj+eAxYkked/tppD5DOtv4bvth1kzy9QoJISFV9v9NVHib+l3C0rblmqq89y7BLSur+pOuHfWHECi4Bgag==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/23/26 15:06, Christian König wrote:
> On 2/23/26 14:46, Christoph Hellwig wrote:
>> On Sun, Feb 22, 2026 at 10:26:30PM -0500, Zi Yan wrote:
>>> Hi all,
>>>
>>> Based on a recent discussion with David Hildenbrand on page->private
>>> is not zero when a page is freed[1], this patchset is trying to fix all
>>> users do not zero ->private when freeing a page and add checks to make
>>> sure all freed pages have ->private set to zero. For compound pages,
>>> both head page and tail pages need to have ->private set to zero.
>>
>> Requiring the user to clear a field before freeing is just a way to
>> awkward interface.  Don't do that.
> 
> Completely agree. This is just asking for trouble.
> 
> The cache line(s) backing this struct page are most likely accessed anyway on free/alloc. So I don't see much extra overhead.

I think the question is more around handling non-head pages when freeing 
larger orders. But maybe the overhead of zeroing page->private it there 
as well in __free_pages_prepare() is tolerable.

I'll note, though, that we already require page->mapping and 
page->memcg_data of pages to be zeroed by the caller, so it's not 
completely crazy. (see page_expected_state)

-- 
Cheers,

David

