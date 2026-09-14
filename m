Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24C03C88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 13:19:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43A3F6B00A2; Mon, 14 Sep 2026 09:18:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EAC16B00A3; Mon, 14 Sep 2026 09:18:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DBF36B00A4; Mon, 14 Sep 2026 09:18:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 09FE26B00A2
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:18:59 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 60703A013E
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:18:58 +0000 (UTC)
X-FDA: 85212423156.19.ABCFDC7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 92F9840007
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:18:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q4OURtAM;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789391936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H4lgleji7/TmSk0WiBbJhXNt3/OfbliY0H4ZtIu5kjs=;
	b=vBUYjb8Hbj5ge0DhPAQbi5ta32McdGVmoAardLJ863WO52VlSir2ia673f8AN8gycjL1yh
	p6QA6goG12oHrBBpdnKp00IjXKiuUNOrqT1zc/yjKmVcTb2HDUSJz10JGE3IwNwuUFdQR1
	KQiuiY5PCZ0MEstZybhEOW2tjA877EA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789391936;
	b=cP3FYsfTMpDtJyZHAmAmWTihYxGUMc0U7aKwcGzP0LcRqjSYrybzTp7f2LS+l8E3fNGdm3
	cZL1JUNCt7z8C5CxzlRxasWh6IacueXNPAMj2MaBaIK41OWB4/Zz39NeFAx9IGD/a5tcDm
	2PR93RziiUtWi0TZ6735JM0rMVEah2Y=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q4OURtAM;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BDF9140308;
	Mon, 14 Sep 2026 13:18:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E45161F000FF;
	Mon, 14 Sep 2026 13:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789391935;
	bh=H4lgleji7/TmSk0WiBbJhXNt3/OfbliY0H4ZtIu5kjs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Q4OURtAMJ3WIuw4GPiestiZF4uXn0oGBo5lUmL6A1m4WHhQ1Xhd+ZeAREkD3IfzrT
	 6qeS5AkuSZUGIAA2i+1j0dsYCqR+WeGXHU/bihFSEAIh0e6+8L7gxlucpeD58ZvCQj
	 Vt7nLXPexITTAy8F3+TKcJYv4VlZ2dmrvSNuwhQ2SN7ijplxGeg6/xWidjY+FsE4sp
	 ztMsI91Rmx9NolHJ8YX/yK8GONQYoU1mFTDly3i6hWBrQ3uD2piOww1XuKIQMBsuYk
	 iUqRUbcSxiYivlvpMbR1E7j/XVRDomayankndy8+9AW8HG8h+F7O9WcGujWVtauiWP
	 aSfnL9+MDc9EA==
Message-ID: <8578fa96-14f0-4c3e-bd7f-a2a626f79f2c@kernel.org>
Date: Mon, 14 Sep 2026 15:18:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 09/16] erofs: use folio_attach/detach_private() instead
 of direct assignment
To: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
 Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <hongbohbli@tencent.com>,
 Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org
References: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
 <20260913-remove-pg_private-v4-9-848550f7574e@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260913-remove-pg_private-v4-9-848550f7574e@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: assdtdh6aymb4d5omhhfxeat18qiy66x
X-Rspam-User: 
X-Rspamd-Queue-Id: 92F9840007
X-Rspamd-Server: rspam03
X-HE-Tag: 1789391936-777173
X-HE-Meta: U2FsdGVkX18DvLW1uVMIs7nL8Y/hhOjnPgGb2MEvSJDm1kmuOnVE7DQ1lRSsNbFKUB9A+c0AqWIo83V5V9KD1mOYBYeERdNYwkEj8vsnSfg8JzfhRQopnCzuvVSswS8gW93fSKMW0UNgJtl2xmeHaHwN/HD9c7miLRprAyh44zCxurxEQirvLMpwfvm7euKGzsEityZinoix1mDvlOl0elOW6nMvm3R/lE9YiTCmW64g5sQclOCMGAbqhyOB2uHGAxfGxQJzY8RfC4yxIDzTI1EOpdJsZbisY0mF5PriI80qlTCy8lA9XUqY7weW05iwXmF3Dmsqcqz6d0uohlBmvrASdtf/gD/8fPBxHfB21P7oBbXlg+KI5+N1KLKTeOBItxQns/cCqvj6LRzxod6hxjFII85DQ80T+U2W5eYEPVTjDHX5yeJCTuuSt7LrXDYdvvyHgHyfP/Tnhx2gfjQoDCYNwxu4d9OPbBJVzSOXzZaUOzl6VoOroQRIdw8Lp7GMrHAyaLVVjDoRM+WhuzI5MdT+9iqimqvl4IAHt2/0wTMHm6Oown6VetjmkQeNHmCeNosDOcLafzY4Z/FiDTx1EnRgbgrRf96Gl/sh9fXOjuOvG3PkMSCEZHeoJbMCiIZ0bFVfom4vOsQZh3Y715X68B7EJ9wdwBHaTgHEac3g9qm70bRyNpj96VIcx20kbtJuFZytwdwz1rqOQiCAYeamaL88SYDOjSReM3TBud84G2AEN8ekYANQMptaFdUTwRjkU0QRpYDu54QgUw2Cnxi+cWS1VG40mQ5AxXlZa2Kap7dJnAcoppKHSwt5lAUBzbQFXb3GphociIk7qpmLgJlWPBFBEBFG94gJ9DbQiwgN4IIiK4MSpzsdz6Fr67a4kxMdIDjqf5Ib+B+/b6btQx+FlGOOzRVDjTLrjb5P3VfqrK+gXUg70ek9uGQgVoBo+AZ+vZQgnGXPBh0hpXoLhUz
 16/T0kWO
 0S5jX/vTdTSqbUPVnV6PJVqXHkUjBWavob+1O1xE6y4WJf0XTU/M7eSNuRRdaXgDef2tJdH8acGCxMQnenPN4f4VhK6tWp8FAwSkR/wLKfgA4PIyfXB2gIiN+mizI0iey14nsA9Nacwwdr8qt2kyvmPT2B4fReIy9VAx5ifcZVPhxDCcWrjC7fI1QwAir567DJqC42oue6RUdwVR90fgRBbAFzkAvLhKr3MVp0AkLQtQvgKct0NiTHnnX3ybqvJrj2XQTZqS+C7ysxAp4XeaWdgyaUdDZDrw9YNmRcsjb7MsGKmZmUGdXjDQz2UsH0iB25Fq6Me6c/PurSPWL+gh6EjOd6Rfguw34fHz6GimEM3mbGHteAbHZwRK+mls6CSmiqe/UYajc7eoCVGYUGWPQWU98qAujSOIyaVc8ccNx0YIJEgvZRoLjfHrLMENX0onsqCyPUiFufmtCa3kCiuH1t+7rha4FUjOQKvmoRcfJUhpPa1Dg4GJAQQioQjNtkoFOb7mcmNQ23xE6DY8MGeYv0nsXDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/14/26 04:24, Zi Yan wrote:
> erofs_onlinefolio_init/split/end() use folio->private without setting
> PG_private or increasing folio refcount and it works. But after PG_private
> is replaced by checking folio->private in a future commit, it can break
> folio_expected_ref_count(), since the folio has private data without
> elevated refcount. Change them to use folio_attach/detach_private().
> Folios during this process are locked as they are in the process of
> readahead, so no parallel migration/folio split can happen.
> 
> Furthermore, because folio->private is used to store in-flight I/O counter
> and the counter reaches 0 when all I/O completes successfully without error
> or being dirty, ->private=0 causes folio_detach_private() to not drop the
> elevated folio refcount. Solve this issue by using bias=1 for the counter,
> so that ->private stays non NULL throughout every attach-to-detach process.
> Add a macro EROFS_ONLINEFOLIO_BIAS=1. While at it, fix the comment about
> ->private bit layout and add EROFS_ONLINEFOLIO_COUNT_MASK.
> 
> It prepares for a future commit that removes PG_private.
> 
> Assisted-by: LLM
> To: Gao Xiang <xiang@kernel.org>
> To: Chao Yu <chao@kernel.org>
> Cc: Yue Hu <zbestahu@gmail.com>
> Cc: Jeffle Xu <jefflexu@linux.alibaba.com>
> Cc: Sandeep Dhavale <dhavale@google.com>
> Cc: Hongbo Li <hongbohbli@tencent.com>
> Cc: Chunhai Guo <guochunhai@vivo.com>
> Cc: linux-erofs@lists.ozlabs.org
> Cc: linux-kernel@vger.kernel.org
> Reviewed-by: Gao Xiang <xiang@kernel.org>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

