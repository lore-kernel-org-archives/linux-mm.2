Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E71BBCCD193
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 09:08:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EB608E001E; Wed, 15 Oct 2025 05:08:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49BD48E0002; Wed, 15 Oct 2025 05:08:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38B5A8E001E; Wed, 15 Oct 2025 05:08:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 253EC8E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 05:08:30 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CE6A147A71
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 09:08:29 +0000 (UTC)
X-FDA: 83999772738.18.3FF8C6C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4F717C000F
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 09:08:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XNeJaXHv;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760519307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4/qnPEWEdYt8yXr6RF4YLK70UvTplvNuCrjSISCrx+k=;
	b=ZYbq7Bjn7SzBDTVgMnMfSjPfvdRY+Z+/1fl16/t5gYS6E70owGd/mf8cbeWdBKjD2WVN5w
	cOL6HypyUgLqsJqk7RoNbie+76RAtJtKs0X8QS1xGBOabdKtxrso29sOM3sfbfOY8tCeWj
	5Y9EI+fgBXIcViQpXMUlbqyJcufLGPk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XNeJaXHv;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760519307; a=rsa-sha256;
	cv=none;
	b=Qh30+B6q1bOMM7flJIcMkY6faQ3kzv6TJLMJ+EqZRuu0pKOCxIMmuE4KpGERJKKE4czCuK
	1KN23cDgxCSdpKLFN013gNY8WLkO5+ovlJp1J8lTLEU69jefz8mPwc4JhHu8i6LmzetaSK
	0WBZAi8RDPpJHPws+UEqUyfrxwJjid0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760519306;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4/qnPEWEdYt8yXr6RF4YLK70UvTplvNuCrjSISCrx+k=;
	b=XNeJaXHvLC2MBKKZFjaKc81ZYNz2A/ojhs6E4ex/uDq6AhpgTU1FdOpsphZaq2P26GaTaS
	p7c0370FBqgVhmzH6iw9Jv3tFu7xy54cYAzdYlMMWrLb1XEB899FxJpXRKSYgRx5r1rGYX
	wrGIRqsAXIq+zxbXTx8QOLSo782FGUo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655-q_AvUj2MMMOkHPrm5ZY_-w-1; Wed, 15 Oct 2025 05:08:24 -0400
X-MC-Unique: q_AvUj2MMMOkHPrm5ZY_-w-1
X-Mimecast-MFC-AGG-ID: q_AvUj2MMMOkHPrm5ZY_-w_1760519304
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46e407c600eso47965765e9.3
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 02:08:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760519304; x=1761124104;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4/qnPEWEdYt8yXr6RF4YLK70UvTplvNuCrjSISCrx+k=;
        b=OFJlqCg7N8mmncKO9oVbqcqGs9wYm/3a9LJsmm8qhmqBNxuvIYptLALIGEryeR7Fc6
         qaRF79mw1g3MN2sHA43gld3HdXHwkQ83SvcZDHp7FP6o1v/6TBE4hPvvmlqHEIfKjIe9
         kS6UesJPYdIpaWkaF7YOALH8XRz2qC44DSJVELDmeTqymntB2XvFDfjO7zCbsJqohQhe
         XrqD/0+BymPWi9LAq9V7QIL3OrkLqU8SzY5G0S974HKuXImcbXtyQKnnK+RWbYWrdBGc
         fLEDSDB0uozyOE8ebaYk1vYWCrcbIiYY7Q0kDXT8mPC8RU8hQxbsVzeBv0uzUFJTjxds
         EtXw==
X-Forwarded-Encrypted: i=1; AJvYcCXGiyFzW9eRAEvHGwzt+z2fUxIslBGcyqzRyg7Sz3OUgGLvumC/NU/CAiViOK1vX9ZEaaki4kYPew==@kvack.org
X-Gm-Message-State: AOJu0YzgC5qwGLRaUJ05qY8VfefiHI9gdsDET41gZ5tkiHrg49wfD2Qn
	GBJ8AIQ2ae/9ETb6x+3doz4AT04IW/xBCmUFQ/8Q1TQpzGlu7Y/+ungzO7maOB8vuj4OG606XyL
	MIgl7f5yy/GFpIYH6DZpJ6607qUzYVX14sUvosQgMT/bh2H5tyQCW
X-Gm-Gg: ASbGnctBBwlVEponrAcYzPgFdovBY6NIeZntafKqv+6eIxsXMvm0PR1iXyaI7KMvTZe
	0LDAT1YAIlo1eTOOzvrq3FHV9KIeGfwQaTSDipLA+5TQC+pRQUb3QiajFcfS21t/kVKOBSLBVbR
	2fHcodYfgXZBDfyc+gKLiYhRkAlurabeuGaZ1LCnlOTYcvcG3THsug7hmuQLIXzGDi8RluM7H52
	tg8xMoYn/6FHynOu7sTUJ8qI1eGkrUnc6R6is6bBvA5tqmXRe/QfCOclCc2QxVvWZWfcwzrIhVn
	IYRuMjhwWwP5l7lKT+NHc5DO9OJ/umRYnx7dTkoyo0oB6nX23MkbwsGoMLu6GOg=
X-Received: by 2002:a05:600c:c083:b0:46f:b43a:aef0 with SMTP id 5b1f17b1804b1-46fb43aaf30mr104797655e9.41.1760519303751;
        Wed, 15 Oct 2025 02:08:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHborQb2H9lSN0eaTHrwL4MBFGg6wIu0HbZh/Za6m+vHkY97y/h3fvEJDNWqng4iT1IYdIJpg==
X-Received: by 2002:a05:600c:c083:b0:46f:b43a:aef0 with SMTP id 5b1f17b1804b1-46fb43aaf30mr104797395e9.41.1760519303343;
        Wed, 15 Oct 2025 02:08:23 -0700 (PDT)
Received: from [10.32.64.156] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb489accbsm333754525e9.14.2025.10.15.02.08.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Oct 2025 02:08:22 -0700 (PDT)
Message-ID: <a72ebcaa-2cea-47c1-bd57-f88c8eb417f6@redhat.com>
Date: Wed, 15 Oct 2025 11:08:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/khugepaged: fix comment for default scan sleep
 duration
To: wang lian <lianux.mm@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
 Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251015064333.31274-1-lianux.mm@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251015064333.31274-1-lianux.mm@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Uo1NY9iFnibwIeDv6x91RAAO12JjapfTwiLx9wWuXpQ_1760519304
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4F717C000F
X-Rspamd-Server: rspam03
X-Stat-Signature: yfngqprs1f3uwxg9k5gp3ggak8ecwzif
X-HE-Tag: 1760519306-571437
X-HE-Meta: U2FsdGVkX1+d82W4T/pmPEqlwFT6xJA0DT2VBK/OJgykZYGVYv9JZpKeM10f93xIRQnBcBABhLqh2wkJ8tfuzSoV4U3Ar183K9406lXbgJd5CFnMgbSZUw1LHUzSgkdMd9o5H7MKmulVoaVcziwWro9TcO742DE4bbSMIVMpEYG9PZb9JrDKjq4Iz6A86LgSjfqjKL8Z5csghPGqPsy/D/p8NN7Wm1l6NCWYTTDg0jaNPhFmfyWOeLhMTo0JQ760mmECPsZk8k0YAf0nKXnsHdrwP6z3iCFsCcTML87g9EuMxtYYmgvsUJqZvWxV7723QHAGvJmo3zurFQd/wu3qVgMJ9lrBoIqCndz+ahpHIFOgR9BnZqPYqnFDtAuypQCcVlSp+GNHcheaoQw9fd0R6kseBdztJBiNL+uUqDqjA9TCM96wcoextFnSUbDl/jgWE8siEPAA/+4Qj0HlS3BM8F/zq5SHEC2CncPw8zpjBpae/8Bas4v0xYO/GhqGuPu1aIZlMBeOI2B1H111KS9JqmxZpmF7MILR+CKC+YxMIdok+nl+EOeKrll9OR9xM+JerXAjx0JMYxK0hsNadRNoHStW/teNzwyyjPZHllsMCkzFhrpUlWuewP6ES3ZdIJhtcgCJhOl1zvjFp3DehTe7poAsnGwlYJXCysjp4+AgSQxB0QsTrLI4vY0pHPr411KK90Lk+y5AihwdNmuV8wRgKSmmsYfiR8Z1wOzLSY8lbd2NEKEPzp3KJQOfWcrgTapvnZ4viFyGU8EFHan6d6WcYw2CqteKbilWeBw6mXzh7zYRCYd51ytGLQHlNgu7yzhkVrS7BG+2ST6LLaXrQNkMBFrj9V+UI14jSU/aveEJbTpgWs9i1nmaVF5gKOkZzMD4oRWeqAntLyuHGZg/o1QDsub8C0QmSf4jZD3QE2By91oIfjRtfufnIBsqmQrF0pFyyluX79l3j9AuSEBvuQH
 FV/DDBYJ
 E6o9DaNEG8jcjupjVMNxtXzAA+/VtA8/SsAIOtBhnV0qBPq9vsA3njNCUXJNEQPcqvBxdBQ/ycXVoWRmCcbx1kATtVAPQr5+2VOsspiiAZ6/53Ah8IgtodTvRbTOsO3Nv6weDsdYPSmBayhY2AKb3SgEdesueT5RQ8HprDRP598KaQyO9bnbz+z/pVapIopFCoGitKlVcDyDqchhXqb2K6+unNmvVVC4UsV4tjyduIloDnhcUgms8IhOmj60QG4N0zqFXMYo3UTPu24mKyvOY+sTA8f/mNPG3J8lQMGlDw4oS9pGb6CpLCUR5LGFVCBxLUM4U6PPMVkFov0MqDfLhbcUOqi8n6q5unceHQcA42mPCuY8JDIfVMNCTG6L3YXrmUTG5o0Zk6exd5eVK+5wymPQHVhSKkSYpo48Oy7fMd54CwOX660ts1jf1ypkk11QxyMd1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.10.25 08:43, wang lian wrote:
> The comment for khugepaged_scan_sleep_millisecs incorrectly states
> the default scan period is 30 seconds. The actual default value in the
> code is 10000ms (10 seconds).
> 
> This patch corrects the comment to match the code, preventing potential
> confusion. The incorrect comment has existed since the feature was
> first introduced.
> 
> Fixes: ba76149f47d8 ("thp: khugepaged")
> Signed-off-by: wang lian <lianux.mm@gmail.com>
> ---
>   mm/khugepaged.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index e947b96e1443..449f983b8891 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -67,7 +67,7 @@ enum scan_result {
>   static struct task_struct *khugepaged_thread __read_mostly;
>   static DEFINE_MUTEX(khugepaged_mutex);
>   
> -/* default scan 8*512 pte (or vmas) every 30 second */
> +/* default scan 8*512 pte (or vmas) every 10 second */

We should improve the 512 part while at it (e.g., on arm64 with 64k page 
size it's 2048, on s390x it's 256).

And s/pte/ptes/.

/* default scan 8*HPAGE_PMD_NR ptes (or vmas) every 10 second */

-- 
Cheers

David / dhildenb


