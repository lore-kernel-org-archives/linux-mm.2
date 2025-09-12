Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF392CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 16:06:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D2AF8E000F; Fri, 12 Sep 2025 12:06:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AAA18E0002; Fri, 12 Sep 2025 12:06:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F01ED8E000F; Fri, 12 Sep 2025 12:06:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E2A278E0002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 12:06:20 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9B6BF140891
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 16:06:20 +0000 (UTC)
X-FDA: 83881075320.17.BEE0A73
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id E8950180010
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 16:06:17 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=f56cV9J+;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757693178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dxzwguxznvqE0mx+qo75gr4n5bBcbz0Oi4oqNYnLVvU=;
	b=sMdHfVV0I2snckKBW5L0SBYc8gTdioP/9LmUORrCFMQnHcJ7Rdmd9OZ4DX8TBfez/E1gby
	OQLO1CnCRhxnwHZHfsdOblJMHcKDL09iLmmk9RSmdqWUFj3R8tElPD+Acnsd7Z335xyMhu
	/R1VFqZitn89MF+Av6kQSH+7y7ky3Uk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757693178; a=rsa-sha256;
	cv=none;
	b=g5NAJSCSqqJpPg059UpqKZlUcm/ryW2ot0f6CYbgx3RCHoPF3tfroaCzYrfKpNUNqESS9j
	/NkfL4LwB5WuH5DhjIMHJlcg3ucaCY7KLxAiFoXbKoyBn0ad59dqRfoem8NZKo0SKGAKey
	pJL5J5hToWpYBQBPC/uQ1+VY2949B68=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=f56cV9J+;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757693177;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dxzwguxznvqE0mx+qo75gr4n5bBcbz0Oi4oqNYnLVvU=;
	b=f56cV9J+Bbma3nFgjyBWOHXaDohY1g2cBPP2WAsmFi9bk3aeCeTE8m7THQbp3u4ho0V44b
	GjK9i0pH70ogjWQaFWbhtv9vwUIsraVaGk4AQwOzjol+q/PwLpu5FUff2vAKuQcX/R9LQl
	gsHIuI/gH0quvW6xZjFjZrn/vDp+VHA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-62-AtqDrn9ZPxqO-atcddO5Ow-1; Fri, 12 Sep 2025 12:06:15 -0400
X-MC-Unique: AtqDrn9ZPxqO-atcddO5Ow-1
X-Mimecast-MFC-AGG-ID: AtqDrn9ZPxqO-atcddO5Ow_1757693174
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3e7696b36d9so475070f8f.0
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:06:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757693174; x=1758297974;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dxzwguxznvqE0mx+qo75gr4n5bBcbz0Oi4oqNYnLVvU=;
        b=TO9bgL3qCh6+eLJ32fR/yDAGPM6GjkQiuajljcIFlHnwfnefribZrYNEJqA2Q8C1Rk
         zdFYNPQaf0sTzQwY+g20hIaWjKgJ2rfBQgrTOAay7R5JB7TPZNAYE9PFpCCN326aH3TS
         oeyzMsDbkvdEP/RuZlQ2+IXjye1Q4iejQir8SxMBvfHHDXwwNlTppPRTAhejUegku0d9
         9qCQZOtwGhAZK5c+25aNUSgAFoORvjqpglyR8ZCZsxyD0GDEoHFJgTLsOcZWe0vgTKbJ
         dk5vaQukehmA0w4zfUBK9QFoNbTo4xFyFnd/kwQvDmiPpd4YtNGE36nAYU3mJxlNqoIG
         eS3w==
X-Forwarded-Encrypted: i=1; AJvYcCUg8pLjLsVXrSo83SUVJWwivTRIRTBL4TSvHDxMyhBmC2ng1QEIQSrBr/kA0JCHjOx4jC6HhDX4zg==@kvack.org
X-Gm-Message-State: AOJu0YyvjvgOPlPIwSFyHPDUg148Fv5HMfybGxeswPZndag4WaBod+/9
	pHWQT15XI6ZLJJjdLDiMWqcG6lhOPZEWUI/GvGwod9WNXFvyNzvnG9ZP8sEWJ8auoUPsBWw91x0
	4x03A0WrVWDsSWELPCLRLohF3x7hwmKDicQlVSM+UF2v6M1KbskIZ
X-Gm-Gg: ASbGncvpSSDj6uP5Hl2Q6OUhmdDIcthJuSl71W8NXlHGAa/lLH/bf7YpNWjzG6uqihD
	YAIfv2MpTSAbFEmv6mmupPkVrI6fw18zJJgxvopG7XVlrzS1RSItN0/dghvPv5yVvfop/iLbOdQ
	DG/foPqYwIxUs4nAacWrXliHHufIRU+EMd/2o+Oz26Glc0OnvDbZ1rzIHvCrFl/Ki5fCqe35EX5
	7F2A6sNEvanHeIyLcF6uVJ5D4Gmc+HPmnHNt99HymjIXQllEdT6P9aMJfSj/+UL972Lj1H7bxYJ
	KVV0GH8y74TbD2TWnYcKyFKhUxaVPdsMoe+a0lpOFwOL9VrwvUN5kSfCMtF6EGULlh3HeWkmt4h
	6CTQ5RVyjbFR/SjHEFXyYNA7MtBNEY14AsGr6KQo+2puPDG0dwT9YIRBDpyiCCZHrqog=
X-Received: by 2002:a5d:5887:0:b0:3e7:44c7:4bad with SMTP id ffacd0b85a97d-3e765a36ea1mr3660003f8f.31.1757693174162;
        Fri, 12 Sep 2025 09:06:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHhFpAvzAr4h6nHJq/W34QBFAPDcffgJvXu784z1DyQ2B8SVflxg8bLzme2d+Eci71k9K3ttg==
X-Received: by 2002:a5d:5887:0:b0:3e7:44c7:4bad with SMTP id ffacd0b85a97d-3e765a36ea1mr3659945f8f.31.1757693173667;
        Fri, 12 Sep 2025 09:06:13 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f20:da00:b70a:d502:3b51:1f2d? (p200300d82f20da00b70ad5023b511f2d.dip0.t-ipconnect.de. [2003:d8:2f20:da00:b70a:d502:3b51:1f2d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e760775842sm7308106f8f.7.2025.09.12.09.06.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 09:06:13 -0700 (PDT)
Message-ID: <e21cd2ba-9061-4c6c-9956-23db8be5e16c@redhat.com>
Date: Fri, 12 Sep 2025 18:06:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 10/15] mm, swap: wrap swap cache replacement with a
 helper
To: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>,
 Chris Li <chrisl@kernel.org>, Barry Song <baohua@kernel.org>,
 Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosryahmed@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
References: <20250910160833.3464-1-ryncsn@gmail.com>
 <20250910160833.3464-11-ryncsn@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250910160833.3464-11-ryncsn@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ug5gLv4zLX7ULqOk8IgvrIDaAQKwG5I4rKIjENt2lP0_1757693174
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: fcrbodzqhf4g5h8pij68mdwsiusqy11z
X-Rspamd-Queue-Id: E8950180010
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757693177-337548
X-HE-Meta: U2FsdGVkX19WGFkAwrKrJaTcuqV9z2vEvQ0ddMVPrabDMMCRWTBItDdf7QbJjUF+85uolDLaAH956XE6VTHOwMmquyHkLgfKbwjLMED9cc6SldFCMiuMbmg5q3HoEUFf5IHQe3nsDQpvi4gl5I7EIDIg98WWT46roh5BOKTeWU7FIJdaUqSTyDoBfhZ0FMPvmBSvzVnLUDE0y7e5rMr2bU6FnX4SZHi6/OEi7RUk10kMlwD8kdHAp62fq+llQLW5+kwPPMJDUb5yfRHeNMQt4D6hVc7n827peTLaCnJsSjBFnsr89GDEDZDJiGfjLb/PDxUCYsvhs2q3MqoDiOUuv2V6g2APQhLlGUsLYOg4XM3fGoHHbov2ewF6BOdL2vQOrTGOZHNKITp8Ksk0GcxhFdHG1RhDTfdu/YssHxyEe9mqx9eGDUc2TrRPnRPq4GE0oyvXps1QbpGptEU9gUVaiVYETa4S/H97tZX+NW4yejJHpFnCxs7h1sZ6yFsjP4g7JQOnN8P6oRbljEbsNvv0+GxZuJhkYWPSeHzr7bl/rf+29dFqi5/K6eINs52ImwvBfZQ7N/iC8DcDIUUUGYyHt/ugiTquiC8ONgXe1ZqmyQ1oAOFhU6/MQCwq2fFA0hKbYSZjywVJC1vdNctzKzTBASiM0fwfDul3QWHXu8sDvleCvV7KypoXrjqeYvcFRsgMc28Vp3b0tVnwZUHEvilMtkjhA/dL1etCr1kJaX3wfC19cG920ZZo9w4P9KktgkBVPDwayw07PyGxAEpb4K4hyJe/7D7f2efGqiYR51MvBvr6urZbN/rVpkZdDiScfzjWmCLYP5ZZpbQe0aXKEhoWRWOQWVZD/KKDQUfzD+h9s5X/2wtXMCLRdHMCs4i4Lzk+teov6bgj+BBznUcm0L+OMBXQ+BljrW9grBwc2gxJZYjYWpzRb8mAwB4QmDE/yMwD/A0ZlW/7EAsgbCC4opG
 X2qObNPY
 Y/9W7WV+0/gsOQ5qgYWgKBlCMH4ZFgnlQw1zl2sLiCuNtNwf7wE4TpKfsJgY/rJ1ZpiJKSmrZNQC40v2OgteCWoJkOWK5MmPoa8KD6FpBOm3AZzavLL3EG1gFsZEZSJ1TUSn0StwHld5lrgZ1TxQKNCl4fEYnIsqb2dSTusoCEcJqdD8G3CLGovI+Xbq1zPEjj379xqAOO87oRlmBQ0gyfgDZ1m9NSDeWaHYAlO05aUUw6OkfFSWCGde7MkOfshhuBPzSPHB4QOUSucj6a2G9QcVb2R7P3PxMgv6q4AvZ5huXuRTxD518jCIYYsVwoaI+WK66jvNbVj5Z9liVovrLTvRLx0IJtzA9uRol9n4uk1agSily4vnBQMpPhPOuxFdlu3ygiWAoPjJc9w28I8PA/9Bav579bzWgw7+AEp6weinX1wEN48x0MPKSgmi73GNxdqaLrP91jUGzUaE0pxVlIDF6Ug==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10.09.25 18:08, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> There are currently three swap cache users that are trying to replace an
> existing folio with a new one: huge memory splitting, migration, and
> shmem replacement. What they are doing is quite similar.
> 
> Introduce a common helper for this. In later commits, this can be easily
> switched to use the swap table by updating this helper.
> 
> The newly added helper also makes the swap cache API better defined, and
> make debugging easier by adding a few more debug checks.
> 
> Migration and shmem replace are meant to clone the folio, including
> content, swap entry value, and flags. And splitting will adjust each
> sub folio's swap entry according to order, which could be non-uniform in
> the future. So document it clearly that it's the caller's responsibility
> to set up the new folio's swap entries and flags before calling the helper.
> The helper will just follow the new folio's entry value.
> 
> This also prepares for replacing high-order folios in the swap cache.
> Currently, only splitting to order 0 is allowed for swap cache folios.
> Using the new helper, we can handle high-order folio splitting better.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


