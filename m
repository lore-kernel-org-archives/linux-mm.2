Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45B79CAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 07:41:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 926688E000A; Wed, 17 Sep 2025 03:41:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F7288E0001; Wed, 17 Sep 2025 03:41:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80CA98E000A; Wed, 17 Sep 2025 03:41:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 71B7E8E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 03:41:00 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0DE9011A16D
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 07:41:00 +0000 (UTC)
X-FDA: 83897945880.25.EE51824
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id A707FC0009
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 07:40:57 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VzMt3d0U;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758094857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8sUfnI24jFzcwd8XU/KgXpzRD8VbKCrbOhCqit8MucI=;
	b=55QLtmZMGs0+VS/iXkt5U5JOiPGFI81OGAnupM65qQIHFx1vNhYk0gphh4O6UWlhNU5I1Q
	39PlmD7+FfBrtBzlKURn6CfXDGAGwlb4cwZA/+BeNvhRaKsmoWRzQgjFcMu+kKC15WyF84
	59Oz7esLhbcTBHIhEDtIOUyUzhidyDQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VzMt3d0U;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758094857; a=rsa-sha256;
	cv=none;
	b=OrRqOKr0m4EpY8bKHlashC0Eqrql+mnH3TgJuwxJanGtcBY1WZ94W8EToKYJrsrltUMwUK
	xxq0WEp/1K/wxIa99Kbz9x4hgF2BT9xmXbGyIVp4n/UwAsAN090kS6dZVGXN5IRdK2ju8d
	z10SQhQs6AG/hSkwMfirDlU05Z118Uo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758094857;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8sUfnI24jFzcwd8XU/KgXpzRD8VbKCrbOhCqit8MucI=;
	b=VzMt3d0Uweyy9dcjibg/LkB43EfOiAvaKbI4cuAsNBRVA211zDPySOqfeB0Lm/MYJ2gi2T
	bKpHxt3lBby0rWqmnmBbhK0cTZAbMlBZlVNM8kysflKaDnQqwxDaz01310zanxyeEPHWcS
	Pljt6iZCcXr4MvB0u2fAiupx4fPQmLc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-657--uVQUleuMQWbWKVWtzy3OQ-1; Wed, 17 Sep 2025 03:40:55 -0400
X-MC-Unique: -uVQUleuMQWbWKVWtzy3OQ-1
X-Mimecast-MFC-AGG-ID: -uVQUleuMQWbWKVWtzy3OQ_1758094854
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45f2c41c819so21885725e9.2
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 00:40:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758094854; x=1758699654;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8sUfnI24jFzcwd8XU/KgXpzRD8VbKCrbOhCqit8MucI=;
        b=GUbJVuUMq736GGfVRgYuP1hpy1izeadvJoDivrx2q2D7N0WSvSi5HLI7SSu3CiFlg6
         FEKkkyUF1oFQyKj6ulkfVS7UKIUKoSjTsE57ciiAw5hSyNiMdTDUKSHEzvEl7O9UaW0E
         ib41j6/JjY+DE6N3FAd7Pa3C3rvky4Or9SpI4l3Pt4Oa75zR5svFy6Lb0HoxOayLQPbU
         DROZz+JAnNJc8ULa51LjKfDCOvGFyl5X1UvXzjLMrzmoZcZugizCfDSMHAJaDcvV81hp
         0yQcrYpScrO3R05UzKw4w5mHpEyJrCubhMBZ+jNIuWy+v5MGgv40rYIQ9J4YprJEhUtP
         ZUzA==
X-Forwarded-Encrypted: i=1; AJvYcCWA087w/pCLt3VT7eSxtpW5ZjBLewsxnx4R2QE28nzDCzixsUJInV6n1ZGvuur8kaxWB/jnl7gyjw==@kvack.org
X-Gm-Message-State: AOJu0YwWtaI6Gv8SmL749vmT//S7/8nYK4n9Z9KgQbjkuS4RMi3FmlmR
	ukO6UJr+sLSYnzQtDTEyE2KtKBeaSENCMCmtAKeXAbPAENfYBseXEx55OjGoMZxpfSnEFbvughS
	wowQuOrgVM97vSWx16LPEMUKNaqAFfirdilZ9GOd6xiVWoN95pBWN
X-Gm-Gg: ASbGnctma9LMoy3WndC0nUZB9SQKZI0AvCIovRefTLBR/G3JSeSKsgg1k1DIfPCLEO9
	8Qn7MTN0NDF3b9xZw36CFQ5uivkrBuhnho0hcKr7JWwjU06ZGoJF+oJZVIiZrWbPhOQExFdXZfT
	J+wvVk4jjkPUZCGhBRAj/prXFM8I7XEcxxc6JDcWjOW3g8BmlJNe2iS0n6A1k5ehLNdTryqe2l2
	M3WbaZtCNS9UqUOcjHXZIATFhwRrAsSyH6O1iHkVP2bFt5UA1eaQqzSPPZczxd812G7IZ5XfFwM
	XvUjixQVG9FFstrnmJB8IS6RZ4yzBNYiqoZ40KWNPnfqJpA0Jb5Ienxi/UDm1REOL13cQx9aBHb
	KLoAhWo6EIuUkVjVAHqwKL6rfAH3ChfPXuXv1RPrc8tyDG42yjW6gv9LeeBvSiKwr
X-Received: by 2002:a05:600c:3b02:b0:45b:43cc:e557 with SMTP id 5b1f17b1804b1-462074c5382mr8713875e9.34.1758094854467;
        Wed, 17 Sep 2025 00:40:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE5wZM4SkH5EiKp1IscU1Dt+bW/Z0tUdh0H6cNhqcWGNGy5NEAEwmxp1KwF0uBi6Jw2iei8sw==
X-Received: by 2002:a05:600c:3b02:b0:45b:43cc:e557 with SMTP id 5b1f17b1804b1-462074c5382mr8713595e9.34.1758094854060;
        Wed, 17 Sep 2025 00:40:54 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f27:6d00:7b96:afc9:83d0:5bd? (p200300d82f276d007b96afc983d005bd.dip0.t-ipconnect.de. [2003:d8:2f27:6d00:7b96:afc9:83d0:5bd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ecdb0a2752sm4034782f8f.56.2025.09.17.00.40.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Sep 2025 00:40:53 -0700 (PDT)
Message-ID: <377db013-4850-4501-a810-552e2f821dd9@redhat.com>
Date: Wed, 17 Sep 2025 09:40:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/hugetlb: fix copy_hugetlb_page_range() to use
 ->pt_share_count
To: Jane Chu <jane.chu@oracle.com>, harry.yoo@oracle.com, osalvador@suse.de,
 liushixin2@huawei.com, muchun.song@linux.dev, akpm@linux-foundation.org,
 jannh@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250916004520.1604530-1-jane.chu@oracle.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250916004520.1604530-1-jane.chu@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: o6MozkxupJkQ_1K1bxRhUMMqnIf5j_lSIo53T7z479c_1758094854
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A707FC0009
X-Stat-Signature: qyue5raom4twm5d4in3nga8ywa6zpnat
X-HE-Tag: 1758094857-182957
X-HE-Meta: U2FsdGVkX19/u/8r1R7lVqTDXRE5NfSUJ1J3+SytoNHQCptn1LuPrtINU2aJJp0jgfoLPrq1gY4am6gJPsldaAXwbphn9lgeHNQkLmUyosT7eDSdtXLtpuwW25MR1XmzhyZ+a6DEt8OLGRuRoBsSt3+E9+xaMymh/ZF9fT1HR14qBKOtpCRqU3PveWn2eLAhoOvHB8+uW6OHMN6iZSij1ArRZ523DPRlvQ1jFbHzUeTOf56Z6HXFzqzPVxqrqvnrtGBKdo/Kk1Nh57krJP6dgvY0w0RbfmLMp07rQFIJV6IyXQF+OPTk1pysvYcEuPs6qe6Vy9XbAf1In1kXaYbLtcFCF+52QmRWTiexIkKJ2i3Q6OfWrE77vDCIj1WwI0bQdc2HsdVmMhlgUr6p7NgmlwODIv1lJ39Su/BTqohz9hQsTr+IizqNnma7bUESA7eyEP+TS1vl3JQiXqZrtyM8QtnZdllN77bb6k/kFsu3dexj31R+Q1ceL8sdE34taLOnleGLFyw/vpvta8L3Y44LuxbZG5lCv8WxY//rloXyGjNtvE5812yD2RshtvlE86swHDjQ6kLMuFTu17i3lOGLUhLEjGHsuPCjdgb2CcvIafGyHP+vohB8SiQcnMbfabkghw9GtxVP/cMbQahKm40dMN4KI32C5T4+xyals1BgogBQEp9PBrlJTZyzmnFBzj7CkK/F+9p7ZWwwYqPA1x2MSA3pUAf55M5ustK+D6SW9ElVBMz0yLm/NayOpa23VSH3m+6w9Wupy/+uFLf9yPTl4QYiPhE3OadWQTCaxwduFI0/Mquh/KErgJLfJf8sZ0swfkb+OR44+emq2iDTpZQmQgHfLrBdlGahfaMWfiSITSWpRhaJvVAI9aBvtKwpFrdafObjdvP974pzPp8aLyhD2IKZwH2jMPaSRjZCDDrh65UDdhCUVn5q7nsioghj0FZVtcMP4rCugqKQWx4jT4D
 FLBx29qi
 5w89zxZFzssGjk2J0H+f8xuydTRCzhhfF9OlIXCHsZhyUzlCOi/ECc2Uk6N+ivZ/1/z9qO92rA0ze505larnxEY7qMgVMWwYWZrNvm5ynMpy4bboORRg93vVGIIS+Hqf0Y4dCiGuwMsRQ7HvDKR6zSguBWFG9m+GBksKjETVwDXv0N7p/KBsc6oMOIlTkPqDsfxUZzA3FZoOeS1ZDPxwdoex4ZQqIGZIdMSZi2fk5KWR/xwsUQpXOD+Tdojygy8vRPLUm5vFXmc0bKH3VzInbtn7/Be6O2aS5tGdxDTayo15FyCls5OMrq6CyNfsURtR9tbTe2Vi2yomRUDYPnLEnjR39vmkrJMInqPfkIPMcBQ9itVaAl2AOc55GNpejxDj5KL0asUrogbP1ulAAgOXYzn/VCLHpS4X2qLEhiBdJNB/Kmv/h86HWVX0GzeFyDCjW53XQ0B0iCQubLXxg7XZMzA3ik8Q9KOzQU7OpGMHCIWLaBZBIqBeCG++c9zIKbaK7Jx5eiaU7/Xx29FA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16.09.25 02:45, Jane Chu wrote:
> commit 59d9094df3d79 ("mm: hugetlb: independent PMD page table shared count")
> introduced ->pt_share_count dedicated to hugetlb PMD share count tracking,
> but omitted fixing copy_hugetlb_page_range(), leaving the function relying on
> page_count() for tracking that no longer works.
> 
> When lazy page table copy for hugetlb is disabled, that is, revert
> commit bcd51a3c679d ("hugetlb: lazy page table copies in fork()")
> fork()'ing with hugetlb PMD sharing quickly lockup -
> 
> [  239.446559] watchdog: BUG: soft lockup - CPU#75 stuck for 27s!
> [  239.446611] RIP: 0010:native_queued_spin_lock_slowpath+0x7e/0x2e0
> [  239.446631] Call Trace:
> [  239.446633]  <TASK>
> [  239.446636]  _raw_spin_lock+0x3f/0x60
> [  239.446639]  copy_hugetlb_page_range+0x258/0xb50
> [  239.446645]  copy_page_range+0x22b/0x2c0
> [  239.446651]  dup_mmap+0x3e2/0x770
> [  239.446654]  dup_mm.constprop.0+0x5e/0x230
> [  239.446657]  copy_process+0xd17/0x1760
> [  239.446660]  kernel_clone+0xc0/0x3e0
> [  239.446661]  __do_sys_clone+0x65/0xa0
> [  239.446664]  do_syscall_64+0x82/0x930
> [  239.446668]  ? count_memcg_events+0xd2/0x190
> [  239.446671]  ? syscall_trace_enter+0x14e/0x1f0
> [  239.446676]  ? syscall_exit_work+0x118/0x150
> [  239.446677]  ? arch_exit_to_user_mode_prepare.constprop.0+0x9/0xb0
> [  239.446681]  ? clear_bhb_loop+0x30/0x80
> [  239.446684]  ? clear_bhb_loop+0x30/0x80
> [  239.446686]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> There are two options to resolve the potential latent issue:
>    1. warn against PMD sharing in copy_hugetlb_page_range(),
>    2. fix it.
> This patch opts for the second option.
> While at it, simplify the comment, the details are not actually relevant
> anymore.
> 
> Fixes: 59d9094df3d79 ("mm: hugetlb: independent PMD page table shared count")
> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> ---
>   include/linux/mm_types.h |  5 +++++
>   mm/hugetlb.c             | 15 +++++----------
>   2 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 08bc2442db93..a643fae8a349 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -631,6 +631,11 @@ static inline int ptdesc_pmd_pts_count(struct ptdesc *ptdesc)
>   {
>   	return atomic_read(&ptdesc->pt_share_count);
>   }
> +
> +static inline bool ptdesc_pmd_is_shared(struct ptdesc *ptdesc)
> +{
> +	return !!ptdesc_pmd_pts_count(ptdesc);

No need for the !!, the compiler will do that automatically.

LGTM

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


