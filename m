Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E8FCC61DB4
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 10:06:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 277F56B0088; Tue, 25 Aug 2026 06:05:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2016B6B009B; Tue, 25 Aug 2026 06:05:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F0B96B00AD; Tue, 25 Aug 2026 06:05:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E2AD46B0088
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 06:05:58 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6AB8C40194
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 10:05:58 +0000 (UTC)
X-FDA: 85139360796.24.EC9579F
Received: from mta1.migadu.com (out-52.mta1.migadu.com [95.215.58.52])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3D2F1A0003
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 10:05:56 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HdTWDrOn;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.52 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787652356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W+ooenuFCFn9DapzPnxm2qIQCw7BGGv6DgQIZsUH9DU=;
	b=RoKX2UolomVjVGdIy0GPfTma0lRDgik+5U2YJX4/I7/Ic4s3BplibQ1PYXfe7q/m4xYQ+o
	Gl9RGQc9dsyN8mQmONXclm+YTU+HUlr3LiPat/VoYNWC1hbwWvyY3XhiSvY4FHGZuMD/d4
	jAvAoqxooh09678FVFdKsuPSzgCgjSQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HdTWDrOn;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.52 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787652356;
	b=KIMXR6CQyLqLe1Dzu07+Me/AKiZH8Eo47DFcZt24BqZGHk90uxB/8/rqYea6pqUWm4/HVI
	yZPExyDOg6LrAd3iWswsG1qRMulkNvHg+ZStn1Ozhu281TERqGy5EFOjdxr4hJOsJNbXeu
	VscDVKO7uKGkbeR1Gx2v2eowss48rmw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=9oSCpY9pXoZEzwklBLr7SNX+iEk2oWh+j+ImIK+k3rg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787652354; v=1; x=1788257154;
 b=HdTWDrOnLVIc3ebVNuIpT9YS0PyolTcwnDEdLEo1q+FfcGcfPF8LhKAaROjZladt1/BX28ae
 A3B8vEOe9lAImo9ulVbwP4+/yvMk51JZypiVc5aaLYmkVj56k0x4o9OtvJ2myn1fa9ndRyv12ku
 aX/xvgD97ljQlOnMbiKA9sFA=
X-Envelope-To: linux-mm@kvack.org
Received: from [100.82.85.74] (101.71.133.200)
	by smtp.migadu.com with ESMTPS id 5db4b3f43ae3f8fb;
	Tue, 25 Aug 2026 10:05:44 +0000
X-Mizu-Trace-ID: 5db4b3f43ae3f8fb
X-Migadu-Flow: FLOW_OUT
Message-ID: <856cafbc-cead-4a63-b2d6-3a5e5740a4a1@linux.dev>
Date: Tue, 25 Aug 2026 18:05:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 02/17] mm/sparse-vmemmap: rename HVO order macros
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
 David Laight <david.laight.linux@gmail.com>,
 "Liam R . Howlett" <liam@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Muchun Song <muchun.song@linux.dev>
References: <20260825084608.47437-1-songmuchun@bytedance.com>
 <20260825084608.47437-3-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260825084608.47437-3-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3D2F1A0003
X-Stat-Signature: ydxdfmiwkg4r5t3zxdpob34y8ygsq1pa
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787652356-490116
X-HE-Meta: U2FsdGVkX19PxzN6wbqzbUn0e9h0W021L8wMugX7fdU3QfymsQZ1B1kfjVLMxWaqF80fzW+7fVsfkRbCotCS8b2UAWKc9I4E2f7wCiqY5WpXdRY78/iCjVi3vs79HEma9/jSR+jCn2zAJOnasdC18wshhpQnkwKJrcrBXtqpsWce3xBDUTPBftpgYBicfe/wv6K08FHjxjwFsOk94Yf4N8g5QpLakJRnc3kRJYR3E8IK0jf08QPP7QgbFQHJ5HUvL5jf0M2xWoquVvJsxUpIGDoKI3vJ7X/3X7sk8H8usCOQBtNR1k7dh5E4uwoCvZiIBO2XVvXnegs8pQ/CYF5E9EKvvI6tmvXARZRCfugorfkexwPi+IOYbNbpsAficmX2x9vd/VEv5X22fFp+S6QnrInrYX0mum9e6LxYXgicin73iXL+5yaiJiOhqKs5N/reI3FYSygdQjpPty2SFQszwCaS3Kym+VdPj4E+H9KUi2amqGUbnw61hpP4XKGauFaJHZkEyhlSOW7rKK3MyIkgnRurenqO8BaqfcWN/tV7zo5Y/Cvp+EKY9N3OvkuWoUAB8F8at75y3MQ5PRQrWjN1iNH+RQ+PNztMbscuN2e9uvDNHtT5D4fMoJFUe4BcQUAfSm2I0DOvluk16cQF0pFNSA78V1H6dPxvxAnxJ0Jw4vsjdX/ed8ho6Fd1cMvYA08JMy+v/waaF5v69jmFvy12q0I3S8tUrIHnjpdim2SbP5pvfC5IL+HX8NIX2fbfyo16CG7rS9xNqb9hP849k0F+UKpSjpaDbdEMQjKoD0PaqroSEXM6hIGoIPXTCSi8SirT7/jYzPlUnZav9hUt/PHyO2T4hdmWV5/3AfQ3k+FLqQWMmqDYwypWJoDaJBjcKyj2viU+NVN6OR9ocOd9D3MJqpKDmxJ3apUb8oUnCB0KK62Z1BAlycxl1h9VcSVb9gwXGKzE/x88bHmB5qKRJmp
 Cg8MAORp
 a6uTgcDWk1u2vZfy3t/UUHZ+0mXYkUeMTNa2A888+1wSVYxkdjhtCDkH0DINf1TlTaE0h+X6WfMcmfrBaKpp0hAiROtqZkYuFWC460QqhgRVUwrFpRHLyOd75RzjQ/Iv+xK+u//Nu8pCCZV7U+qou8BUi6X6kFSB676gCEIQP5dRNTZRdteTB5l2XIIqdxogofZ41Ckz3ewRxTyaKoTeU334/hSOSyPpzw+nr5iWHLgC2FRXgvTggawTYfEsPDzXFJNdZip/OTXZ9vZccfx+hHz4Hep4/GQKQTuyoM6kiLIJvSixyX/LeE/y8f6W7BBJyXmgewPN1r5GrkH0FAXvP2TGdGjqoiKVgrrbRTSR1eOzuYZr23lyaf7+imCoLHRkUzvRoI/BztXkZkINwNy3PA+xIVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/25/26 4:45 PM, Muchun Song wrote:
> The macros VMEMMAP_TAIL_MIN_ORDER and NR_VMEMMAP_TAILS describe the
> order range where HVO can be applied, but their names tie that range to
> the tail-page cache implementation.
> 
> Rename them with a VMEMMAP_OPTIMIZATION prefix and use the new names in
> the HVO paths. This makes the code describe the optimization requirements
> rather than the tail-page cache implementation detail.
> 
> No functional change intended.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
> v3:
> - Collect Acked-by from Mike Rapoport
> 
> v2:
> - Rename the macros with a VMEMMAP_OPTIMIZATION prefix (suggested by
>    Mike Rapoport)
> - Drop intermediate optimized-folio size macros (suggested by Mike
>    Rapoport)
> ---
>   include/linux/mmzone.h | 17 +++++++++--------
>   mm/hugetlb.c           |  4 ++--
>   mm/hugetlb_vmemmap.c   |  2 +-
>   mm/sparse-vmemmap.c    |  4 ++--
>   4 files changed, 14 insertions(+), 13 deletions(-)
> 

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi


