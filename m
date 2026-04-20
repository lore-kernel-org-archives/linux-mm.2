Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC695F99C76
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 06:07:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 708EE6B0103; Mon, 20 Apr 2026 02:07:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BF946B0104; Mon, 20 Apr 2026 02:07:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CFBE6B0105; Mon, 20 Apr 2026 02:07:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4EC1D6B0103
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 02:07:29 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A5E47C2CCB
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 06:07:28 +0000 (UTC)
X-FDA: 84677902176.01.8623A6C
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf24.hostedemail.com (Postfix) with ESMTP id C2AAE180002
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 06:07:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=HqPblzVR;
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776665247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jlXoyWfT+08BHayF7RT9Vylznnk/5A39eUeopQdgDu4=;
	b=O12RdJIZmKg6y1pFbsDQM1o5hgr4UMtf2SplzlsfTEO05FA/DgCECEGmIYtJqLRWJ0TsVl
	zKMO+ZJHeWYuiSZWTmts0hbUH6uIXxhDAvaYQnKLLp3jiltyb7ziWUZIO+RabIMzDPMGPE
	jdBtcJdG0u6oq4FwqSR1Bo2opAiGjik=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776665247; a=rsa-sha256;
	cv=none;
	b=Wf5puBABB4zgMswhQh6uaIsadFKEqwhaIoB8U8+Nh1n5T6B58eh4db6Aw0+cI1E3pRgciJ
	P38Rp4aeEZLcsgzqQqC9HsrvXKucz1/Jh6Bis3s3BuZE34T4guLhtxmwAfOkgUQqHle3db
	87s2ct1QozuMg+uuqsWJ563xe9AOc5M=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=HqPblzVR;
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776665242; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=jlXoyWfT+08BHayF7RT9Vylznnk/5A39eUeopQdgDu4=;
	b=HqPblzVRDXGH79ExxwUwumxuWBlWXiNDtKpZssYv0EZQE5eiz6MtV+AfQcdg8t3AwU7Q75Z+xdY6XUdx+EKnV32eHo2vkWyOevzB6/mA9Q1goHjdSuUJRFQTraFydv9mBntoKVJRsvTBjz/5yna1TAtSuZVALhmcdzWKdUkT+rU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0X1I7RdU_1776665239;
Received: from 30.74.144.127(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X1I7RdU_1776665239 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 20 Apr 2026 14:07:20 +0800
Message-ID: <7fa885ca-d074-4e75-842a-6fe7e48cb298@linux.alibaba.com>
Date: Mon, 20 Apr 2026 14:07:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v3 01/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS
 check
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
 <20260418024429.4055056-2-ziy@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260418024429.4055056-2-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8wrsmxje3yypf34ugwohb4swgz74j4nc
X-Rspam-User: 
X-Rspamd-Queue-Id: C2AAE180002
X-Rspamd-Server: rspam05
X-HE-Tag: 1776665245-538810
X-HE-Meta: U2FsdGVkX186rkvMtOpEuryH63QeJmfTCXJDzeKKaBcio46ClNK+GsNObeiKWhHusxsibWmiq8bnriFqXtAn8fl9LVdlWmGcN+X26tU8+RTQfCjlCvBGbbR1E5PvCVebSFjlraRROJUEWt/FJnpfIhn5VkiWFEn4GflZGHM/OlLUn3F6UOU943XvEEG7P010BX0zHr2qRgJBrbcZ0felo1TJfcJyMKbHZSPEpRT2WzzRdLlAV0+X2xIgVNaH6chPWife86Gqj8EJw56XYsAoqFCffo3EqQsxA/N9F+/9Jtgmlxs7SwpC//jg1iQERCs8B8muHs1uACivXrCZBAZwuNvXGD4x2pIqnojkS9ypViGl7s3kmsBHbp72trje+t70ApAPvtQBepZxBxWPGlT3SFaXgMIUgsMGJEKMDZQUC+WTnbf9+fx6AJ8t+hhy8D+nXKx3ZjHPSk/RDt6X0RBE/CMxAhqDc5Err6Rn4ndU2LarDyaMrwTM3MU7IwUhFtWUrmzYXS3NCmjxhH55E+Snkx0XQfLVz4eZwfPPJ8Cqcocnm+aQSRfjky9iHjLnsqQFM1GkwADEUwjYHlAjnIF8XUgZqGnK6ZlrQX0Oiz8FueWOQ2L/3iWjKDqkCx+pfTaqT2UVz0L5frgWGMt/kwHaYG8qV0PsdwIfrZo3lFmfVBtS1f7xDhTzrVl2PeujAQ20WpNDD7hQoqbBWCYKVhcA2BgDWPptDdZAsI2OblvNMFvqJdpY2hU22o40r7rGEEmnd0JH07/dmF9nZ05AZLW/U4T1Gx1v9UbKpYBeD9g1XD+E4VoZVCrEFfEzNfz7sPgu7vwdNbsGZK6X3Q+lkXyVQYkFJw9XumQ/uJX8oleKO+JScjYmR93rZl8HohHUkybIPRPbv3KaPGsgOasQVENoUyHc93OjS3T7/o3nkNbbkbE+vixYB1h7rnCuLysDBRQqyUuLRdp6aYNibZKtJcm
 w+ssnJ2h
 qv6lHIPoRbT0oAtvHhZPE1nCSJRXqThKdNDntGsJ0vosjroYF8xam0ad83+d8Tju2EB1CxwHX98HS0Qg2Z84zS2CXJtte3XdPKE3sz383soa5rsqDzTG/h04Xeg0N/Lm+AZlIYtgXeZMCgT8ekqA8KebjlgwOWR95PD7PSSXd9FGBHGcA/UK1HXAV7FagwI+oW+39T1pCVp8BnE0LPAhALLHQ6pTfGAsTXBoESWpCsfa6WUKy497mLG8gg6tydyrPALTXe3ycao8+VchfkSRpQIe9c3aZTQ8dEGt+zDQ1KA1MdP+t3GZ6sarwIU6YfDmOHUhrB5Oy2GLMu0eQcjSwIV5+lwrtG5sUIUVDkQDYd7byBGRqtPZQx13D/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/18/26 10:44 AM, Zi Yan wrote:
> collapse_file() requires FSes supporting large folio with at least
> PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that.
> MADV_COLLAPSE ignores shmem huge config, so exclude the check for shmem.
> 
> While at it, replace VM_BUG_ON with VM_WARN_ON_ONCE.
> 
> Add a helper function mapping_pmd_thp_support() for FSes supporting large
> folio with at least PMD_ORDER.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

