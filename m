Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47AAC606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 09:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gNCYHgmi
Received: by kanga.kvack.org (Postfix)
	id 625C16B05C8; Mon, 23 Nov 2026 04:39:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FC526B05D4; Mon, 23 Nov 2026 04:39:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 538BF6B05D5; Mon, 23 Nov 2026 04:39:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 325EA6B05C8
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:39:05 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C8683A082B
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:39:04 +0000 (UTC)
X-FDA: 85465885008.10.788525B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3F7F24000D
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:39:03 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gNCYHgmi;
	spf=pass (imf04.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795426743;
	b=GsFWvVFhTtSsu3jmcJT067RDi6EHPWyonyHRJBKm+Dkr7sXnasEVFwbv8Tzk7v0n54tIGj
	KQWvCluiWilovZmimyNGnYREBE9jyALUIVx9LW3ThPBVW0E9Ytan5z5N3DSkoTF1rTTdXy
	SVjg8XXN2rZe5GD1CNK1Vfjlc6dOZg8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795426743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p4kT2PbsLUH/8zbjyftxImFQBIAZp/1opbC0UWneA9s=;
	b=oc0238XAoQdh7bjUXZxkv0AP7zPpWWeKu8Jg2r+97L2TRssjmdalvm8aBIFBLtoY+9hJDz
	jU6ukzK3/Ci8s5UtzpUGw8F7hkMibaNUOds9Z1rot07mh/DCkHECwP0DhReDzcLp2Pz3vh
	2H7g1q7rR9A7RuWkfZ7XpALlzLydxPQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gNCYHgmi;
	spf=pass (imf04.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6B12F41FB2;
	Mon, 23 Nov 2026 09:39:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B1D1F000CA;
	Mon, 23 Nov 2026 09:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795426742;
	bh=p4kT2PbsLUH/8zbjyftxImFQBIAZp/1opbC0UWneA9s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gNCYHgmi2kkGeS5qIT8UVErS88deSRWmUfkZjVx62d4DujkBhSOnGFA0Bf2o+kqCP
	 zmmidedoTTT49FdIx9vU4aB57Q//oPyEw/C05MzvWAV4wUR0S4U3E3qB/ChA7uluhX
	 7c5H6YlPpME7xCcI9moRx6EVxufyQ75niXtuMTyDBGWuDulvi2U2TnfWd3yr5Oq+HS
	 Sst4CRzXikx4aS1/SAQclKiLBxvkeF6aRjSW3Qkm7K5Tqu7X9U5CHn3/qkfH2rXpQy
	 KOPMEkf4eJLcrZx4l1RyYCk0uMhahOS3Q/xFeyR3bNUNov8dS5Hen/CTAFZuYooVRF
	 ZNsn7+QSvZZww==
Date: Mon, 23 Nov 2026 10:38:54 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Li Zhe <lizhe.67@bytedance.com>, Andrew Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	James Houghton <jthoughton@google.com>,
	Lance Yang <lance.yang@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 09/11] mm/cma: centralize CMA pageblock initialization
Message-ID: <awQJroxCj52AqPDH@localhost.localdomain>
References: <20261120100856.16929-1-songmuchun@bytedance.com>
 <20261120100856.16929-10-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120100856.16929-10-songmuchun@bytedance.com>
X-Rspam-User:
X-Rspamd-Queue-Id: 3F7F24000D
X-Stat-Signature: 4ndaepqrncm7n7ajw84r4q8567fg1cob
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795426743-717236
X-HE-Meta: U2FsdGVkX194zbBKxmwsz5B2W35XwbcyX06XP9K69fpNuWIxCcqeGs1bKn/RIjrgrtdveklAcELL/1OXSa/16iexqZnQq39WWIPbbdZRwR5/Q7UA+UggShGFRcfqhiz8fJoVkcU90RoaiIEbvG7dsRoMj8TzTHVBQj/YKE6wNdUfUuzDwKeVQANj0g2Em/IML4utv/KnFsIqkQsVAHPDb8KXoe0F3/G4Is4vrPAQgzbiM+y+F7LOny/XDk92/vXj9/mu/1PbWwkCiin+3p/4P+d2A21AxmoueYBaapeSz6yEICpza3MGCsTOoe9WwZFwtlN2TuvsXeXMMiOL4Vu7G2ksXk3xLRRWJskYKjB+E7iErcg/h+RrKf73X+eTaz43wx5aJh3JowBz7kWdDqw8BIamsZYWbQcsQ1EW58aluLbnKIUeVe1Iw1jo+PFP4brqJXDZOQlfsHoIdLtkVoeHcyltgEEo0UtNwtQwZjBmbBP2cqRdh7JNQq/c2Tfr0ti5wXf5kPr/cG0fZ30BVoySCNwi7nYYXepfkkUV97f7uRUgzdXU0UxPDGCz6HB/OPICA8/4BSHzUXCzT4Jjg/ig+/f4dYlBjez6rS3g3TgyE7DdZCSqcg2no82nLVjaNqCTq5utvVoUIhIg00MPuHVwbS3pT1zuJNTZbQbdmeLgPm+xZs7X2gJN2hruOSQ4JOPPeR/nXEenhLdClB8OXzRVhUvYZlWHT1lK+IwTHSEUDK3pIM3HKm01z4VnvQ5q+9M32eIZLPSNBNYaVy1ZN+MY0r+Sq/HkYbreBB6+SAEKMmWRH1W+LHI5z618ziD5HAdb8D576wyzXfdJeJ79XY/pV0Zh08aQrWxJK7xn60bSg5kqewU9ZO9ZCkyLaMDTN9NJrZLsLGiD4p17DO1a3JQx6YaoOBj6Lx9pNHYd3aUKWADzJP3RbA1g6vOU6KSuO3zbtV4INwJZLTtlieC19xV
 nLIQELxW
 IkhK1E7XOHEvBhwkkscTYD+XkvWsP/pcA0GjNnN0C+Rc/mLnsuPNX+S57zqAjwBqkDYCPXFxJyZfnLIJ8yzfNS/zf9EOckTFV+YDikNaUg38FlCNmuKDBWv5D/AYAi7qFZp3dHqeMSp7G7X46XEigqYcv64NEjRJGgdpC7u8+Lt9y8DgoVgnRZf2n1o2gkc+7hVJZmPyILclFeCWuGC4gRNYKCzMjAiJ4s4yLu49JafFiGQL3J24to1TDksnm+LTEkskcoprDV7SqsIr3obOP5Y7makTEWX8o+57uCtLKuVQAMQEwq9R7mqjjWcQ+qYhJjGgEJeXuZN5KlGs8Ysi6mpWAkdW+inhO9BFUcOj5KUCQSLfETW2R23XPjLAu8ezLo4TO4Bq6ihSHiHH6Xj+h/Jig0HM0uL7drOfSbPnHN3qQmcxbpsS6JW2sKJTZ4ijnjegaZoZdVSLtyqJvrLNQwQnSG645lr1mS2PKSZIeb3R7IBc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 06:08:54PM +0800, Muchun Song wrote:
> Early CMA reservations currently require callers to maintain CMA state.
> This exposes internal bookkeeping requirements and splits responsibility
> for the same area between CMA and its users.
> 
> Make CMA fully responsible for the state of early reservations. Pages
> already handed to a caller remain owned by that caller if activation
> fails, so keep their managed-page accounting intact regardless of whether
> CMA retains the rest of the area.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Acked-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

 

-- 
Oscar Salvador
SUSE Labs

