Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4803ED7BB1
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 10:40:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C4D36B008A; Tue, 14 Apr 2026 06:40:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59C7E6B0092; Tue, 14 Apr 2026 06:40:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B2A46B0093; Tue, 14 Apr 2026 06:40:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3D5536B008A
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 06:40:19 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E560F160550
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:40:18 +0000 (UTC)
X-FDA: 84656816916.15.50DA0DD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 18B2920008
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:40:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="J8NQ/KTD";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776163217; a=rsa-sha256;
	cv=none;
	b=rSsqd/Lsy2XVswLEKaUhUFYmXhaBhhT6brnzJ+hzMgaOtOMlCV1UIHEp1HFdYBmG6m2xQM
	XgbGYp5Ybqb7RFz8qMiTtvSgDEuRcDMGF7ZdtrbvmuAt1T9BRZZJzRWd92VMdnIWVvQU9M
	MmaVHi0Jpozn74fr2UPJxR8iTDAzF9E=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="J8NQ/KTD";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776163217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vxjMhuerY3oBvkIBtTy8Bsd47A2fMfanLmWrn9gqnBQ=;
	b=Jte5xqTOz+ilOZbOhdsZ9JQ5rassHwWGu0TgMrApy7F8PxqHne5M6Sp4ja+ilHA1KNX1WK
	7J5TPIT96gVt+HA6NuH3nVoEZxvd7DAjv3RhGQXuahvmN0RkHr1c+hlmwD9UL2HTyc5t22
	QCReY1C6shwv2lnONyLpvjm2MbmpquU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 109E043684;
	Tue, 14 Apr 2026 10:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06EACC2BCB6;
	Tue, 14 Apr 2026 10:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776163215;
	bh=uKJLbd7pobvSRa/otRYj8X+Wzu6HrAb79wzj4niEGrE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=J8NQ/KTD15PF30aYKZFqDJqw7jj3j0LYTvjQREa+tZC8LeENek7izk/BO4zMr2Gm5
	 7oltj6BgbyyikIKcEFSrg/u2Cd1iHwJpQjvCi9gQ3wri7wzHY3t+5sDYG7Lbhv1hJV
	 i7MUvcHrbrpjtHgP0sy303n5I4fLPAxeFTb9jeQaihype8YcB/zDllGv6hj/gytaTH
	 W9BY3tJoBTlqTMteefrigEcn2MHoN1MguBCAVNwanOiWYFD31RSxqm86gzmHEVuoiy
	 g+JQwp/Ik/NT78JpX6ZjIv60RMgQi5OeAD5h1EKCttVxsbmy4YBG7GPr2IE98tsLlH
	 O4xJD+2UynarA==
Message-ID: <47012a6e-f1ee-47c4-b614-3ca16bfc9e6f@kernel.org>
Date: Tue, 14 Apr 2026 12:40:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v2 03/12] mm/huge_memory: remove READ_ONLY_THP_FOR_FS
 from file_thp_enabled()
To: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-4-ziy@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260413192030.3275825-4-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: am6t3r78qh7eip4j76ushkzy1p4ydocr
X-Rspamd-Queue-Id: 18B2920008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1776163216-93404
X-HE-Meta: U2FsdGVkX19yXjNpY323rhcRCYExH+qyLElAIIOHAN8Kn+tZLROUt+A5NavUgYwfmpNyYKo0qskWnxfQA+/oPIE/wz+joi+bUuFaJ9PN3em3DYiHSRO4LA1uJm51B4AUCAhnvr6RnXHG4ZVdWd6WPjJGEsUwGyM2u7KYWaCGJyHUCxpgtDdPB5sIPx4l1KWBuQQtsXElE+FmyV5eH7Ooxtu8rdmnup+7mi/FhBiYLv3+/ObO+WSxblcviLDTCv5dC5/+SMeJehsSWyUfkaarO6blg5hNHnGn4IsvXMDCGo845a/JfVc5E0wRXwrb/hpDhjaspAMJT26e1+d65cUssOGTJpMzcsYzi4vtL2UjlGX/IBk+YzwIDx1UtOpHpU/xegcnvUldrbYchNdS4Bol/veZovE0Vr3niYlJ8ONtu+j+4/oZQzcGi+UZnejmT8/dJxQCtxxe2Mghy92yDNZpfR1yt8W0OSv4fbqxZ6OKWzWT8Pe28no1bqOe4ELuSKQabn2MzHudzxsiNqbocq1002nmy5hGax6paxHHzKwrbPopFPxj9rKHUg8J7xh/H4XRzhrY/VXEwNs4Jm4ELP9xrq4G5KAGamtucHQsViuN3IvfAXAqqGug0GVE0dfqzwPbhWaOxD5rqtDx9Ulz4F1o7I+tiF78nO1vYf9R36AAGIWwg+/jkzDaiiODB5M7htRK/nPaKZQi5NIlkgf0D3Ehz7me7fUcH45vRV0zhQZai9LNrI32u2r1v+SvG/9U9zK0fDjHz2jbf+X6TDgi6QVzB/6OoQHWVwrupiJavpArn5v64wHnC2apeCxF9vbRTwPfRQSyId5SeRpWlZgjw8ov9KsW7VlQODd8OMm0KJB/KwVTy8IXH69dt8Fhkbbl+pVS00G/Gndw1lC+pXsW+Q0oiHQZBxBdktoRIaAG6ePzpixjDEEZoTKe280Om/NmeaCvxVkFniEBKr23Hy87df4
 z95FVWzL
 lJvvzgvHbu5M9YvozxXsfIHS9Ho9PlH79W4nbMyL0JqxxRn86JZcTyOEi16dSROWXhL1jTQdIBrvJoErhevyxC/Nax4WsROkLYzYgW+T6CsKvZ6MhI5NesoxkY0KvCvLnAClenGawh2SguDn/iB7k19NjPcbSAPI2Cr+B5IKtx2WdwMpKn1VoMpmNYK4DEVj5cU9aPBlyECHYpNJcvh5JXuvOxe8/3pTcS+U28e8QblxnCF0x0GWLi4QtaazhsamUr7iQ7klq9qPxKsgs7bdZ1cqc/Q77r+FEc0E7iYokGYgU/feXo8zNiBgoFdYjr3uzZyCk4VG4LyA9GkA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/13/26 21:20, Zi Yan wrote:
> Replace it with a check on the max folio order of the file's address space
> mapping, making sure PMD_ORDER is supported.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>  mm/huge_memory.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 970e077019b7..a22bb2364bdc 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -86,9 +86,6 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
>  {
>  	struct inode *inode;
>  
> -	if (!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS))
> -		return false;
> -
>  	if (!vma->vm_file)
>  		return false;
>  
> @@ -97,6 +94,9 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
>  	if (IS_ANON_FILE(inode))
>  		return false;
>  
> +	if (mapping_max_folio_order(inode->i_mapping) < PMD_ORDER)
> +		return false;
> +
>  	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
>  }
>  

I assume this change itself should be sufficient and the SCAN_FAIL check
in patch #1 is not required?

-- 
Cheers,

David

