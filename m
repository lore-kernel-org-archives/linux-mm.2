Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8273ECAC5A5
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 06:56:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA81D8E000A; Tue, 23 Sep 2025 02:56:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C57088E0001; Tue, 23 Sep 2025 02:56:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B93E68E000A; Tue, 23 Sep 2025 02:56:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ABCA58E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 02:56:34 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5BCDE13AA9B
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 06:56:34 +0000 (UTC)
X-FDA: 83919606708.24.ACD1BE4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id AECC4180008
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 06:56:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758610592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QXsfwqpXb4seowZgkqgsjd3l9TkQ1YFTavg5W4mtVQo=;
	b=A1EJvJpDor4jM1mVCZApAiGrKYa/YrHI99Tr0GdbAR2IJmGr2hO9VgSp94vWltNdmnRWkT
	L6i4RxbCxSHFl6VFiRNDOqGUjZ/BS/F+FG+6BJspEmo/zxlryhn5yd0dYvlIrU7OSnBUu4
	98ReyXNicqUwgLyaGkzka7Tt3RiKxZY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758610592; a=rsa-sha256;
	cv=none;
	b=qIhkv8YJ6HAHwJSPLCjeVVNOLV5yjuLam0yxDxulkzTVXc7VJYZSRlq+jL1pj7E/+FVuDy
	Yc/7GeP4W/6fyVdZjkRCs6WibHb5GEIGmAP7Yt0AVtfKacHvcD5NW2LtJyynO3XeAH9jDL
	kPu5Oxs9typibpgvJmZZ1FqSjQg1aGE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B6EF6497;
	Mon, 22 Sep 2025 23:56:23 -0700 (PDT)
Received: from [10.164.18.52] (MacBook-Pro.blr.arm.com [10.164.18.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0205B3F66E;
	Mon, 22 Sep 2025 23:56:29 -0700 (PDT)
Message-ID: <57ecacfc-dfbe-44f6-947b-39ab98aa07ef@arm.com>
Date: Tue, 23 Sep 2025 12:26:27 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] cramfs: Fix incorrect physical page address calculation
To: Alistair Popple <apopple@nvidia.com>, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, akpm@linux-foundation.org
Cc: Haiyue Wang <haiyuewa@163.com>, David Hildenbrand <david@redhat.com>,
 Nicolas Pitre <nico@fluxnic.net>
References: <20250923005333.3165032-1-apopple@nvidia.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20250923005333.3165032-1-apopple@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: AECC4180008
X-Stat-Signature: 9mn7hqkno4ybgsjd5cbj8g46zubywchs
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758610592-643312
X-HE-Meta: U2FsdGVkX1/xB4gdHLaOdDYCWi5VlLPBkT1tlWDmztZzSefBYOhrQMvMLCvppj5GrDcT6JHscW3vGI9sseyDnbMb6kblIqUe1BoLHvrGg4QTalISRNAnyCW9ckkctJ3EwJLpt7vGGWK2GFyrPoFfkmp+wU3JdKqy4LVqU6yuNap9ULZGOUDa6jd9P8pAMDdsccBj9tgCOHY2R+FQFay5xK+tPs19Lw4//pBJLd5CQfeT1TvXGhIldqtilgfn2Y0PbtN+d4HY1tNVgBZzw6JnCz77dmpmuZaxBlAVUE5OewtC1AxlYJMSr5l7U4/GAGUVO+GKfqg81Sjb9Dp26eY9mODNvb6DYBP6G7wSblPo4IpnY6AGUiUyXDujtf+SnGeVKSMD09/xSlPxYsf6xpWo7ULjY+0P+DY8+8W+39emUlnWwcvW/Y7yxek1jEtJwYhH/uJOrRQBw75vK62H8UqL3sSF4N7X/r/aIPM4sZ6Eu26WPLvouuvcayUVlM60DHpD7duwIvX2b4sFzwpo6fscfQYN2IJiaSdbdk0llTCjFasQIgjfHULJsy7SmjdqtDvCPLW3lB+RMLXtwPF1FNFeqK1rhbg8YI3Rzq7K3X4O3JbciIHfE5VQJpz/3h33/ndLGCUriWur91THtgBuU7W9mD53lA24GwXbqnPlmvQxqTo9p7DMmATkqBKKAPOUEvako0sCLmWYuJdnVG8oPnCsRW4+URI6JsixTZHw7ISEfG4j8/LXKk1kuqD7r0mbUQMynWK5mEsiJ6HLmuZKeAkQxE6KCAOFGn9mPbIg13vuU8ntpoj6OJHpwM1ecA1JCNH6HI9PWJd5blvYI4zr9xi9IJENyZvy8AvnkUK2tRCAhPelxHIgtn+gRwborNUMvABiwnHoAaKGgCJh5hh+KngV3iiDRf8/xGa1IBzcy8a/ypexXxmanrYF0GeYWuIEKNZ2/1ddEHigze/AkDr2QH/
 RJbB9Uu3
 9ZhufqHncFgOj9fiJHFXVPFEmguFeV/j4AcQvjltO6iizdzsh/NMCJhgS9A8GV8xUHamJUbKF/+NGeuahO7g33UEqX5wDUFGTPTqrZcBigMX0EIO7bhTYDJcbyHJPOYlW3UIGo5wZEe2xEF9OqjJ+UUvnl+FiMhldcSzcU9PuJXdhV/3ifG3JQ0mhMlIlRSbGtpz6tGhKAv+uv3szY5vtfegRKOXp0GM+h4Wa2ODD/gbRNNSuALyJ0WpfMVyKipEu+ZQrL4e68rfWP108Xlta31wPhnKUx8zh9kSpg3Lm2bcpIbbrLUAXSVB/IKotl9JAvnERoTl00mAGrsY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 23/09/25 6:23 am, Alistair Popple wrote:
> Commit 21aa65bf82a7 ("mm: remove callers of pfn_t functionality")
> incorrectly replaced the pfn with the physical address when calling
> vmf_insert_mixed(). Instead the phys_to_pfn_t() call should have been
> replaced with PHYS_PFN().
>
> Found by inspection after a similar issue was noted in fuse virtio_fs.
>
> Fixes: 21aa65bf82a7 ("mm: remove callers of pfn_t functionality")
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
>
> Cc: Haiyue Wang <haiyuewa@163.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Nicolas Pitre <nico@fluxnic.net>
> ---
>   
>   

Reviewed-by: Dev Jain <dev.jain@arm.com>


