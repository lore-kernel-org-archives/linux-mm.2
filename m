Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C0C6C88E65
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 10:39:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3B046B0095; Mon, 14 Sep 2026 06:39:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C11F26B0096; Mon, 14 Sep 2026 06:39:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B29F86B0098; Mon, 14 Sep 2026 06:39:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 821136B0095
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 06:39:26 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 70E7AA4664
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:39:25 +0000 (UTC)
X-FDA: 85212021090.25.FF8B37D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id B5D2D180004
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:39:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="l/GtTE5T";
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789382363;
	b=hrELUopbCjl+6wCc/60D2IJBLN8UZheDJMuRPRUgR6wqEmMBTRHZtS/tZSJmrLaZHECvZw
	kt/AIMhPDtw2BXQzGEutJUepAi9KjdkzCQEGZ3t/itqsYHuccV17m+iGVJDgJ+7JFpg/gg
	gK8FRgXf+FYKQ8D82dnfJTMMQpRX6kc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="l/GtTE5T";
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789382363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wLCM/cvnk+dY6aNG+ZUE2L90qoQkjGnZ8Rg9uE7GzzI=;
	b=X/yNTldjtNrjTQbWo8RNPt8P+swb9vlA8xDQRGy6dJEPIGb/X5yXTgCUaGWnN84ocGByL1
	mnzxPxTtXQ+p+H3imdcQx356l8hG/L1GRpkhDns4bSggkQni9/vyO92uyxnZ9Zx3/Gv+IM
	JBcBWDSKAAgp76xh0saMdedgmLli3Lk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 490C160142;
	Mon, 14 Sep 2026 10:39:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 574BB1F000FF;
	Mon, 14 Sep 2026 10:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789382363;
	bh=wLCM/cvnk+dY6aNG+ZUE2L90qoQkjGnZ8Rg9uE7GzzI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=l/GtTE5T2aIkDO5TX42egh2OPD62ZWF+DmU1aqxQo7fQyuGDycfFf2qp0irKOtE8S
	 8crPlpiCknzO3/UlAXKCPaPv65B7r9+UcNDqUXbrXgHR+UIt+985+G2FksapUptbHF
	 DGeBAIti9hnfV0APdE8JpSlbjr/XYk4ylarYTj54VQe7vkLRhkzYUwru41gzQWNkWr
	 W3rRuP3Z/uZ7r7FajdCk+m8uewINdf5rlI1fbY1cFdztQzAVzQLmsWDl6fg1Mpd8qx
	 4Wm1rdWn50YXdcN0zEg4mDs6ZnuDMeOX1B1Aw2UMZ5hV1zWu19WXGN6xZ6fCjfCbY+
	 H33WGZxXbjpSg==
Message-ID: <3709d936-2e3e-4849-962e-888b88a69265@kernel.org>
Date: Mon, 14 Sep 2026 12:39:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/8] mm/swap: add folio_swap_entry() and
 folio_page_swap_entry()
To: Tal Zussman <tz2294@columbia.edu>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Rik van Riel <riel@surriel.com>, Vlastimil Babka <vbabka@kernel.org>,
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
References: <20260908-folio_swap_entry-v2-0-ee6d01dfa5e1@columbia.edu>
 <20260908-folio_swap_entry-v2-1-ee6d01dfa5e1@columbia.edu>
 <2b0a6809-bd88-4133-a002-7a9acb2a973e@kernel.org>
 <20260913-folio_swap_entry-doc-fix-1@columbia.edu>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260913-folio_swap_entry-doc-fix-1@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B5D2D180004
X-Stat-Signature: 5zmej78c5je6rqrdtk1ybh6dfsj4wm4m
X-HE-Tag: 1789382363-932415
X-HE-Meta: U2FsdGVkX18aeP+sAegbgBKmQiUn3nVbAGEx9inv9n161bMP4gMdSa7TrqNm2Y29e008+vRKMbHYUOTpT3manLhxg/tOoNZqHoh10tdtmOWSh1uPCn0X8/Ly92E9OVKANrgrIqMg1OSqUAKFcVbgaJttW8FyKTRPZrvvJ2lCFuUBgiSVlj15cgqKdk9JHCH1snwGoK0YbU1Kf/VEApC3349d355O105/gNI7+4hHkVcq3NgTQnSkyli+D7USRW/ZM8LhJv1qVb9fr6CCuWYdqeME5DgyRDk4a8CRzFtlL7ksGp9tn0es1YbWHBHtM//y9PXawsEj0rtS21dYyOwrxjYerksA3CS5OsFezUqCkZ+Qq8isRkt9t26PJCZy2YlBrdWbMfyEfIPh0M4K3hqnwynfOYCfJ3WhGQ0Ub8dB8j8XCIUyf2Mb6RnpMsAJoFyhQMGxcoSbUZA73nhGTJ1/CCmXVppJNdPw+r+U7rbEjTHGhsjHYqiQHlew8Y8HwLW0bFtWE/maJhskYvLK6V8ayRRrqVSl3odf7z2wjOJ37FOyjQi6vd7NTsS2iFPQejH4WHGbV38v5DSEfkGbblWZHFubvFmeW/k3BDA14H3dxVnBt8OuAtM/BTc6lSGryDEAMlcza+NOgQqlhSwO58V1qIiu7g2yfHwawRlLN5zAPRgbOnAItwJNKvdnQ/YcDydY1TB8Mq6qjEp0kxx3TMw40ZnzuHhuvx0Q99yF9QQe+aBKzZRAwvvbwCgS4FzgBxCU4lfi+/FleMgKy1itLXGTYS3dvq6kSI6veh6h4AKEDjUpVs/xzx0qqERVJtw0QnEBdGvHWNPIcNQCS1YVirsv027dgw9L1St7EJ4Ms0ta/ZpZ7F0936EiR4Y5DCPDk3s1I/ByKnHvLonEdt6lQY2OMfW5fFfQ0bD9eZLs6hBA0c9iHbgvSeYjfYtvpIbDQg+svhxnoBX9ttP9Q9LfYxZ
 QbVO1O25
 +LwSALCkI7Jml68Nzs6l3+mlnw0t/4jJy2bLOuOoT9CrVvrEnM4f+yirgzbKpalT5lIWBxqx8EO/WPHe2wx5CWxkVcNXZzNAPyB3yuAPzwEl7Jfao26aLIE0hdO8xz8KltEQJ7HDDUcL+nyEuy5LU1y7UVZhEdWkgaZHkhgauY4PYEXPHCPqzlLfmjKvYZUC+Owx13zbejL4RlOBKmjwZRHPXr3g8Gdm1jcDGEpxe+l6U331FwGuI/QFUBVDsvzmOqAUBzWqnn8AFw8d+Dfm8/u4L9Am6LO593i6WL/ND1lGyzXukvJ0VMUD/1Cz2GE0YEvs86f4rED4/8Cs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/13/26 23:52, Tal Zussman wrote:
> Andrew, could you please apply this as a fix patch?
> 
> -- >8 --
> Subject: [PATCH] mm/swap: adjust the folio_swap_entry() kerneldoc summary
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
>  include/linux/swap.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 78974da6810e..43155e122b5c 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -273,7 +273,7 @@ struct swap_info_struct {
>  };
>  
>  /**
> - * folio_swap_entry - Return the swap entry for a page within a folio.
> + * folio_swap_entry - Return the swap entry at a page index within a folio.
>   * @folio: The folio.
>   * @idx: The index of the page within the folio.
>   *

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

