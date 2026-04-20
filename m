Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 917EEF36C51
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 07:56:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2D3F6B00EA; Mon, 20 Apr 2026 03:56:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDD9B6B00EB; Mon, 20 Apr 2026 03:56:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCC9A6B00EC; Mon, 20 Apr 2026 03:56:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AF7DD6B00EA
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 03:56:41 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3CFC45B93C
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 07:56:41 +0000 (UTC)
X-FDA: 84678177402.10.D1A3C46
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8E0BE180005
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 07:56:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=vS2bxilH;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776671799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xXWSFBSCtt1/CFq45jJqfZ4qaQqmuiM4XbV6wvtaWvg=;
	b=PnmiyKre9LnZml7B5sFusmz3QBpbzAlXSkaGhF5nVgfhYCocj/TTr8Wv9wHi+fc604QNGO
	6qirn7lHVHq20iKvmpnhtxV/QJ+EUCyZDjG+SIcJK19YnaKTdRVGL6CvX3aSBfCfIG67Rk
	Rt9EV0hWe49euSH1DAmNJbvWOkv9kJs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=vS2bxilH;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776671799; a=rsa-sha256;
	cv=none;
	b=bdjNGaqJ3mcXYP0+8ZTj0SULR9Wb6BHTm2WeQPGhlfEi6UFSC1jf9+mg1STouVcYrDYXkK
	16JVDzjbOUt2E7Bn6JFY0Acy7y1tDgQg+lD5Ppbp9cz44AXFj/cT2DAIcdBPVygwhOwK4G
	6GSEpkY45cxju/MLLK+c63BXDx/SbsM=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776671792; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=xXWSFBSCtt1/CFq45jJqfZ4qaQqmuiM4XbV6wvtaWvg=;
	b=vS2bxilHfRs8CcMm2Syfyu7i2hMjKfa7bxBUMHFv4m1DsTTpsafIw1WVJHYdT1I8a7wpTzN/0kGOXvSQq3eudSSqs+oRnQrV8r6Unc8/bfkDe7CFl5R36dVwRRsVRanbDgTdDYYNN8ghNWcccNlveTMVwwnV0grD3uf6okSPsl8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R281e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0X1J08mT_1776671790;
Received: from 30.74.144.127(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X1J08mT_1776671790 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 20 Apr 2026 15:56:31 +0800
Message-ID: <e1baac32-dcb9-4458-bc57-0ac3cea65fa7@linux.alibaba.com>
Date: Mon, 20 Apr 2026 15:56:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v3 11/12] selftests/mm: remove READ_ONLY_THP_FOR_FS in
 khugepaged
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
 <20260418024429.4055056-12-ziy@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260418024429.4055056-12-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8E0BE180005
X-Stat-Signature: mytm4pr1npfbqkk6c4sudip8phjynnn8
X-Rspam-User: 
X-HE-Tag: 1776671797-996848
X-HE-Meta: U2FsdGVkX1/fRsDDQ7SS7jMU16d6hJyf2iLK0EOb3z4nRSuOu1g94o8aoLmfIW8KQwQG++/No+q4jswa/YsX47HzEjQO6yurpx+ybT58DZ4GT/efTaUTMHfirK1QByPNalvgERBSE9oBX3Ksby9qSbsmzaf4xccHrtZ4jjha8qpIoI8Czg36m/tuoRHC/NWvwLHiJVDCHwL1lhmnAiqG16fYo+R29MmyeJnXVV0lSUph7zbasBo7ACgOgqp/KJ2NFqOmDIJ1RPuLu0P4Pk/foSWfCz3vhv32k+09OYVPl4nbQF/vF34UrRqvOg8rbYOVNwrSwv4lvy4hfrQy3SsChczFLIOemRAtDVi3zSnskSKlGQ7Zb5XZG3rgKrnsCFVBcwQYt0GZZ1Kx1eJVJRtByRyLwWFTJriSLk+tyHOiY56u/T1lupOp2ITvoSqzqtXFEN1cmv9jGLBVZdoiSkMISJWwhLesT8LVvDdrKN6PEUeikG7+9BxJODUvIOD7vUW1vWNABNaE4L0W/GzYcqf56Y3TJw0B5EwveGZAJembCzPWjT9yQGU85UqvS5ZQ6C8qcd+lPDjkB++Q/L77AYNgUxepT29ejA2Rys0ltW1JwHmSIc77xqZtvSoL1jUMY8+7hhvRh7CdKCzeHVx5rQCFw/BPTfdeedVe9X5EUAOoEhYGDJczuHEvqpQ2rbD5s7UWfNcNiZVJA3+lIHzH0An2lOsRV5F1aPJk9dZ0E+cACuncR3WAkj5qNYLh+w7nohk/kzHasmGDVoY6bMcLu1NVCvwpb8vnSyaKKEEHV0lZSlv4ceaxfLfqj9zFUyAJ8gaX2bjD3al2/F57QurDuRK/NhZcY4K/UHACYAnV5pjhvNIP/rGqor6S1vHyk594TGUfRPXBsYxiHNbWzsNTow2UGsZ3Rf4H0U9CW63uFbOmGVFqZXZF452Fkyy4b/s3/jkoSlCZDG/RFHvY6qTmr6d
 181RvOLg
 TIJKtXMOfgcQJjY8s33QvVnEEk0r/xil/5pbK8q6NN7LPrN4B2sgMNZrFZcAf/lEmXUzSdUB9p5J7wC7kHYBjsfoMZuW9uJA/SWR9dZ2EfZk+0VG32C9YRwBglM+4MSOSq1Vinapd7pDAOY5f+SelBEQEUjwRkhkUMtBybsibviy75mfPGiXsMu4bYEbjmG/aR/kTuBeuKBPBQE7BeQao57hLo8Pl4WPwUMzInxzPVNyIExFC3XYBxR8/qFdV2lN0iI+9Ar9gxw1oadryUmhAdsuT/0FZ7CoNy0UwEksj1v3LMxps1aF+iae3G7QqHevLTU2BL7+Gf2x7ZoA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/18/26 10:44 AM, Zi Yan wrote:
> Change the requirement to a file system with large folio support and the
> supported order needs to include PMD_ORDER.
> 
> Also add tests of opening a file with read write permission and populating
> folios with writes. Reuse the XFS image from split_huge_page_test.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>

