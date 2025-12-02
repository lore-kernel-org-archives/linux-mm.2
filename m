Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4120FCFD376
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 07:53:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5666A6B000A; Tue,  2 Dec 2025 02:53:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EF216B000D; Tue,  2 Dec 2025 02:53:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B6EF6B000E; Tue,  2 Dec 2025 02:53:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 259BA6B000A
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 02:53:21 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 033CF8A3DD
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 07:53:18 +0000 (UTC)
X-FDA: 84173765718.27.668DF28
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0D31D40003
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 07:53:15 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=XjdA8nlv;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764661997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V4loCZFItKzWub1Mw+gmTM0Qo7GDtzfcb9k6DM+79VY=;
	b=4NhFbMzHWYMJhe7tlAinRRwpgwSM99Qeft4cOSn/T3bvNu92+iGBjdCONbj/x0KgHV8P2F
	WGjkGVInd2+t3JKVqkD6ExbTqqL3JZVWO8ueNtKi2qeLjHy/TRvEvKHxUHQkDRuc2DOjZK
	5GHwI9B5mjaFVJaKFMMLOPqVNhmF7no=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764661997; a=rsa-sha256;
	cv=none;
	b=PpUMubdGQmlSdxxmlOppn/dO6pIcv5+jOo3k5uXhu9DnDRSVXlfEmuljuU4l2z0o+eERHT
	+2EvzsPFIxeJyOpKmBcBDcRnRYCUeU5zmnKyMlP/oFPFTT+/gab3SIYJ37N8ysA/9X1oGO
	P12wQn5TBxZNxZGCZRru9II3qtzmCRs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=XjdA8nlv;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1764661993; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=V4loCZFItKzWub1Mw+gmTM0Qo7GDtzfcb9k6DM+79VY=;
	b=XjdA8nlvG3m2Nf/tkkK+9qOlMhfVLAQncL2pMC9UIxWNq7ugzhQ2zcvAKBun3xu6blSjtCJtkMpaibkYIW94iPiJXdM5M/iWfVsHIjsotzd32IHf2FWplEdc+5y+l9PbA6WiMx6JqXv/s6uWZTCtO2pfbiVTQq2IGRJ15ymFhgQ=
Received: from 30.74.144.119(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WtveLei_1764661989 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 02 Dec 2025 15:53:11 +0800
Message-ID: <09821512-dbfe-4577-8b42-31df8328a998@linux.alibaba.com>
Date: Tue, 2 Dec 2025 15:53:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 mm-new 07/16] khugepaged: introduce
 collapse_max_ptes_none helper function
To: Nico Pache <npache@redhat.com>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org
Cc: david@redhat.com, ziy@nvidia.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com,
 corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
 baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
 wangkefeng.wang@huawei.com, usamaarif642@gmail.com, sunnanyong@huawei.com,
 vishal.moola@gmail.com, thomas.hellstrom@linux.intel.com,
 yang@os.amperecomputing.com, kas@kernel.org, aarcange@redhat.com,
 raquini@redhat.com, anshuman.khandual@arm.com, catalin.marinas@arm.com,
 tiwai@suse.de, will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz,
 cl@gentwo.org, jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
 lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org, jannh@google.com,
 pfalcato@suse.de
References: <20251201174627.23295-1-npache@redhat.com>
 <20251201174627.23295-8-npache@redhat.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20251201174627.23295-8-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 0D31D40003
X-Stat-Signature: y6mdwycynhm8ogkhyochf3rojpr4q7tq
X-HE-Tag: 1764661995-203668
X-HE-Meta: U2FsdGVkX18DT/BuWs3CmLRI7I9fI+zCJcT49f/slJlgjZy/6gu7brvyFijHDOFFUQzlwczhUMhdEWtcPBr/sy6Ose3wRlrrKH8BDqiU5LDzFRQ0dvSP0Ntlqm01zw17hMe9gnzXODeHdGYas5pxJEjV7Dm8xgSgfr0jYBnoi42YkOVDiRdbpiS20fEdCIrfUy3jj5qcVNvtGEUZZBCUZZh6eUVjQyszk0RKQdUOSh94cwoF5FmnKZTofsKV3qXQN1ob/rjHv7gyqXBgH+ynWwBbllMyyfO+FRVork3DnCt+6WzTvA23Y5LC89pZq7WbYIB1SNFle9R87kgHTmpRhuvAUItoJh/Oh/1tYIn6/5cKXPcyhu7VHWGtmarLvZX7m/WIaiCOY6F0VXQGHVQlAQh67J4fFF1Ij5NiFGJBEHztXP/Av11oeDYDlP+SA7A0bMzMD10R1x/oC4/veY45y3OQRHM4BTIjZhS6X++1lS5wTU74XlmiMVnM8WfS8n9mXWXyufK4kjdbz7OImbOpqTZdg17nTK0xT2MZBlXRHIKWjxy1g4FmhZGAbF7rVHfEotFLJm18wncjUx6VJ1g/UO+/Xwkut1zRoL2tesT6jglniyVFJKJTElZj3kYU6JsoWFmT/tctnsv5d2Ukim0lEpJBQgc5+bKqsPYYEfQdFSDG+cIZxMuph8EsBcRsLMQuIfADVP6Ndm5Ts9Koj75u6a5wCWphPzZkBrH4d/6d1MW06gCYkUSDoBHpPHdVFXCNCxg+sD/ohDDIAKZVg95VnLMZ6vFmpmZn9qx8tlw/N1EctKcNKNs0QxNDJx5EEKm1mLrMMFRXjItHr8nMhl6UO589QDar5K6iIUw36j4lu2TKhO7PIHTjFdlOmrHwaV810EHCAU3bMoZLQBz4EGzexv2IytWSVnvUtbqX4pLC88VPfvecO1bKssVgSDtyLjIXINvTlPmzFID0jCrYodb
 H2gyaFTB
 fYZyd56B9OCL5pfAh8AKFYrPBfY2jzMQk8PpzikVXiqyJgdyJUfN2EvaiAlKVMRDO0ua8Rc1yT1IGVDODnopFlWKW3abXtNcRIIzZc+DIRrOSzo+KJEbr3JdILr3JKHH1r/yTDTG0kthwmfZhFNyVa6bn/kJ9/bQz3/gGCUNSyWhCpRuSN7VDzOR+4YWImcvOC04hCrnediaQu5XLXaJV7fr9nIMz3dujvxQsCyh1VRkhomZmbbUIwrFgNd9RzkTWDTxBIdfCOeRFX5VdCQFrhmNuKPZnawu/ry3CuDYLP9Z2F8tRYJ2Rp3zEwzAl72D0af1PkfnqMopneV7v0whg0fF8caRS6lO4cfqirg+LPIPiaZ3LDARygECRLtLyVVn0Psk8D/6FGNUjs6SUN9fllwtH+Pr2dEZ7PuvGoZxPoSMaQmtge7AJEKuczHwfZkYWij4P
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/2 01:46, Nico Pache wrote:
> The current mechanism for determining mTHP collapse scales the
> khugepaged_max_ptes_none value based on the target order. This
> introduces an undesirable feedback loop, or "creep", when max_ptes_none
> is set to a value greater than HPAGE_PMD_NR / 2.
> 
> With this configuration, a successful collapse to order N will populate
> enough pages to satisfy the collapse condition on order N+1 on the next
> scan. This leads to unnecessary work and memory churn.
> 
> To fix this issue introduce a helper function that will limit mTHP
> collapse support to two max_ptes_none values, 0 and HPAGE_PMD_NR - 1.
> This effectively supports two modes:
> 
> - max_ptes_none=0: never introduce new none-pages for mTHP collapse.
> - max_ptes_none=511 (on 4k pagesz): Always collapse to the highest
>    available mTHP order.
> 
> This removes the possiblilty of "creep", while not modifying any uAPI
> expectations. A warning will be emitted if any non-supported
> max_ptes_none value is configured with mTHP enabled.
> 
> The limits can be ignored by passing full_scan=true, this is useful for
> madvise_collapse (which ignores limits), or in the case of
> collapse_scan_pmd(), allows the full PMD to be scanned when mTHP
> collapse is available.
> 
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>   mm/khugepaged.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 42 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 8dab49c53128..f425238d5d4f 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -463,6 +463,44 @@ void __khugepaged_enter(struct mm_struct *mm)
>   		wake_up_interruptible(&khugepaged_wait);
>   }
>   
> +/**
> + * collapse_max_ptes_none - Calculate maximum allowed empty PTEs for collapse
> + * @order: The folio order being collapsed to
> + * @full_scan: Whether this is a full scan (ignore limits)
> + *
> + * For madvise-triggered collapses (full_scan=true), all limits are bypassed
> + * and allow up to HPAGE_PMD_NR - 1 empty PTEs.
> + *
> + * For PMD-sized collapses (order == HPAGE_PMD_ORDER), use the configured
> + * khugepaged_max_ptes_none value.
> + *
> + * For mTHP collapses, we currently only support khugepaged_max_pte_none values
> + * of 0 or (HPAGE_PMD_NR - 1). Any other value will emit a warning and no mTHP
> + * collapse will be attempted
> + *
> + * Return: Maximum number of empty PTEs allowed for the collapse operation
> + */
> +static unsigned int collapse_max_ptes_none(unsigned int order, bool full_scan)
> +{
> +	/* ignore max_ptes_none limits */
> +	if (full_scan)
> +		return HPAGE_PMD_NR - 1;
> +
> +	if (!is_mthp_order(order))
> +		return khugepaged_max_ptes_none;
> +
> +	/* Zero/non-present collapse disabled. */
> +	if (!khugepaged_max_ptes_none)
> +		return 0;
> +
> +	if (khugepaged_max_ptes_none == HPAGE_PMD_NR - 1)
> +		return (1 << order) - 1;
> +
> +	pr_warn_once("mTHP collapse only supports max_ptes_none values of 0 or %d\n",
> +		      HPAGE_PMD_NR - 1);
> +	return -EINVAL;
> +}

Thanks. That aligns with what we talked about previously. So
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

