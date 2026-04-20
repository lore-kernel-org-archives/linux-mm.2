Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6512AF36C26
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 06:31:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFB7C6B00FC; Mon, 20 Apr 2026 02:31:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAA1E6B0102; Mon, 20 Apr 2026 02:31:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC0F96B0103; Mon, 20 Apr 2026 02:31:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A6CDE6B00FC
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 02:31:53 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3A8871A08B6
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 06:31:53 +0000 (UTC)
X-FDA: 84677963706.30.F306F54
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf02.hostedemail.com (Postfix) with ESMTP id D6C0380010
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 06:31:50 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=IWWcO3sS;
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776666711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fl4jBlNrsLzHQOt9Xuwu05ZRkyi97MaFfuf5gBZ/Gy4=;
	b=KmRLEQYaYO/vqbF/rDHLRNIQ0h4jg6l9PCWVwWkDXvb2ISTfnhhGx/anhAi20SX4cYJ3xJ
	isYMLqRJN7lNpk9bLb90a6c1uLT4EVIu8OJn+CxH4XstASHjvrzJgAMU/eiY3JVJhCpiKH
	eSHozWBLVwTDMY8oluQy7sV1ZZ2N4S0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776666711; a=rsa-sha256;
	cv=none;
	b=dHW7ByLUmHqP9KfKZCN5/dMBmCejnSpqpdYlESn3Q3ZYsrY94kgVLPgubr6JZ5hZT6diTp
	oZr9DWsxR2auEDJPzkmmng9+k1Tm0OT+Nv3U7GaE1UUio03oN/TOLQ8qgYsGk091yyKD6y
	t4GQ7YEUO+xczdu6xYh8IAQXcFheTOM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=IWWcO3sS;
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776666706; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Fl4jBlNrsLzHQOt9Xuwu05ZRkyi97MaFfuf5gBZ/Gy4=;
	b=IWWcO3sSpz2W4ZuAIhn5xNY+E8KCMnwuECTvnfe9/NE3Q3xKpYy3r+lfezD3AWLxM+Ex8SYqqVOP6bs52eXmrwW6gjrWEG6EeVtcNAqf4BRYjccdb+wTXHIygyA69o+IQUeLfkrzUyK+KZk54ywlzXHknRRo/+Uf6hWoM0vGtzI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R681e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0X1I6p8D_1776666704;
Received: from 30.74.144.127(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X1I6p8D_1776666704 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 20 Apr 2026 14:31:45 +0800
Message-ID: <6797d16b-5db9-4bbf-a7d9-314cd98ac95e@linux.alibaba.com>
Date: Mon, 20 Apr 2026 14:31:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v3 03/12] mm/huge_memory: remove READ_ONLY_THP_FOR_FS
 from file_thp_enabled()
To: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260418024429.4055056-1-ziy@nvidia.com>
 <20260418024429.4055056-4-ziy@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260418024429.4055056-4-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: okuki613n6hrqsc13963ckx6eh9rxru7
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D6C0380010
X-Rspam-User: 
X-HE-Tag: 1776666710-945320
X-HE-Meta: U2FsdGVkX19vPnfKoInG6EiqkEr6DtMVFuipX/KzDyUarw2RSrmDSfd8+ccwjcYVROJN54CeIUIQdg4/4fVbMwdbgqok5S/k+9OVDnYXlxOUkcYcWQhi6Kmz6I5i0c4ZJfT5OP4w7Sz25uTCtDWAPLV+LmQykZmTf7Rnd2w3iuJvXjbi1WF5GJ9yZtm3cMBjJiTuiYNHdxGtq1laQdiYOhW6Zu81uc3ZMFQXOY40sFA/4GPZ1kMywDhTpa6yCpezgVoxH+m7sVjpdwbvhJ+1qtJDdcFz27HHsqcnjUDFe2kP5aBUWvlOh49zQslMW8XQXN/VwKABa9YjP6YjYvM7XV3yOPwNDB7ZqWBwHIM5ISCLztBEBMMO0s4vKbBJRljGdftS/LKiosAfn46VYCxZi3SNZV0+SSUSegtRdf9NSsMoAzSsSmRm2n5fb8t7Pz7sT7SY6EKPpPsdoGD5HJ3Wrt4nhyAFVsfahlGVAiSx0ezYju8Nr3YdSAsWcuU1klMoYUILT/G8zWXjeZU24HObK0BIAujAcMbx7z/6dXiT0y3tzfkgVT35kzEeUSmiqCHgtrFFQvSwB/wWhDcRWKNxa8ndIRD8VN1ekmECfyANVbhnwhPabl2eXr/AJs5Ep4w7vnvlUXMRM6m6LLos7HtHJPJ4+/BL0LDpyZ68FfJzPom3omN5rIXJ2DWzUT6rzvu6Ta464at23eyIY6vkxI9PqwRLq/3GBWDZUIDAKlNjWB8J6hw4gElO2HkryWwbUcjvoBJqo6Cmo4ohFyUtI3hBCUWTwuT5XH1/3A6QjQ2+THccyyV2atk6JohXOfGs2JfX3F++PqXHkm44yXFFyEEDcQ4/jAXtxgvjdF/2f0rrioGOehkn3HbcemMp1ZCOHB8bhYTqbgXrQP7jxjGPHCX5H2aO0Qi2qy6/Z8kY0hG8x52MKHWY1if9tU8DSpZsg+/NWY61wp/Pd0U1UENueNf
 fSWb1rmU
 hZR4gTEJdScYUzqY7t6pYB4WHXJmjBwNAY5y0weHg3jXo/N74YOim8b9/EmYfjus+devpcwoh+HHPnu90xtLwxP2JxNma4m1QlR+LBX3cu0WUZmGJFhBxeJ5uPKxh5s9wesGz0Ls/zi/5RDj96f5oKti5/5QKmS3D43hG+FZUSzHJ8Eee3WneEO718l65jylLx5FJgA7u/PbvE+nVHr8YrlHXyGCetSvdtp7XJWMmSKa10kH/MhqRKQXl7hR+okxgpjT9EJidAaiyGoilO5WhCJtHP6OquE8yBQMtQoyEUiLgpLjM4irA6bRnnD+piJNfRD/MdDx9RDxcfzZFl9mWJ2sCGCgeRVorY38DV9Z/Jl3+p7rKmaFki5IOVg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/18/26 10:44 AM, Zi Yan wrote:
> Replace it with a check on the max folio order of the file's address space
> mapping, making sure PMD THP is supported. Also remove the read-only fd
> check, since collapse_file() now makes sure all to-be-collapsed folios are
> clean and the created PMD file THP can be handled by FSes properly.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

