Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CED1ACDE004
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 05:06:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21AF88E0003; Fri, 14 Nov 2025 00:06:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A4698E0002; Fri, 14 Nov 2025 00:06:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 092F78E0003; Fri, 14 Nov 2025 00:06:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E808B8E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 00:06:58 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 88835B7687
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 05:06:58 +0000 (UTC)
X-FDA: 84108028116.06.436C9CC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id BEB5B40008
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 05:06:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763096816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=19vvo+Ly+B9qwoYW/4szbxS+HvXjrNrffQhVB6iQ1As=;
	b=EZESLY148etDkxXrqzYBMjH0Zxc5krKsn+1l8jdy6lblai2G05YdVcfSHRC/Zryq1FqBij
	X8oAoMTzPLUbjHfuq4UUhpH0zQosIx5P1L4Gt92HezYsKAEK6ZCg5VTOcAAMuTS9BPOSrX
	sjLCt664trv/w4bFY2bjoTKRR6RXH9s=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763096816; a=rsa-sha256;
	cv=none;
	b=0CiuO5+S3zKJzZIbg4NpEVDWR7qo2QJg8/N/R3ya9VGH6u3UaR5RzUi5dAdA/JdiI9RmOD
	DIUy5vh89BrSlAc5e4xbYLAOVMFY+dgScxt++iDJEWudDehP0riRV+vTCirDG1fsJpV0Fx
	DLNh0n7yc1pWHYXEJ2JgAL8LOT7PPC4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1A88A106F;
	Thu, 13 Nov 2025 21:06:48 -0800 (PST)
Received: from [10.164.18.47] (unknown [10.164.18.47])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BC2F23F66E;
	Thu, 13 Nov 2025 21:06:51 -0800 (PST)
Message-ID: <1754f9f1-92b0-4467-8183-f6a3b55a97a2@arm.com>
Date: Fri, 14 Nov 2025 10:36:49 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2 3/3] mm/khugepaged: unify SCAN_PMD_NONE and
 SCAN_PMD_NULL into SCAN_NO_PTE_TABLE
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com
Cc: linux-mm@kvack.org
References: <20251114030028.7035-1-richard.weiyang@gmail.com>
 <20251114030028.7035-4-richard.weiyang@gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20251114030028.7035-4-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BEB5B40008
X-Stat-Signature: nja7snx4j13qxe54wgx1bgquubfjuci1
X-Rspam-User: 
X-HE-Tag: 1763096816-336601
X-HE-Meta: U2FsdGVkX1/GphHgcXuhZUm3sWD7oAl0Pwiz9rBO4ZjqEhdpNwr6njRChb0znI7cS1wBqsLWD90ch1YkFnkpiGmegE6K6ScEZElKBfnLKqmu6siNYtgc6XqPKz6plkR+G24n/CPerBx7A/+OXDc+AkHI4Qig937ebOY4PQ/Zvd1S410w1cKsbH/V3BjBuCjVPRy3mi8dsnKN/WJxovadRCcMW6iEG0Swyym1B5L0qbkUmfT5NcN6vds91DmO5rjEGTZb4BG68oJpfgBfNct0ZLICFsxcZL/a9Zu9C3lh1XY7lTHaD8VqeS9uGiJbVYEInHHqFgCWOOmu8aBAxD87HckXNM/Levae5dItMxS/qxPkJzQ70Bn+0JM+jtBoZxGhSbac/vXTDS9t4KBKITHFLkvFfDb3s5PeNJ7fDNeybTTc1+RY/ICLPwzqwn9pkO+RtI+n04KEJS6KObsjVdwziL+W02ssUw3h2QB0gTCWnh9rN1+t4dUCSBSwYCFhT1MQEKbnK13XXVAn6ScDacj+IuFCd7fnF2IfzkCb8hL70QnXuZEQusvge0kVsT7F9ueuKfKxi32iKjFm8JWRtL8iuRtwdDpiToDDV7o0APltE5iGD/OWmis+HwUg5Z0PyE0afF5zOZK+GCoGJfbNDj+O6UgnMygs+u5CDuhXyy9hPDPg/UKayfrpcKkUCwj8C0H/2ERveumZNGc993v+K3TUOv6NUzzLwk4HhnywZ3PL+gkEqHT+ZV178D/mZvDHjhAkvt/cV0z/VcJOOlW6KNdQn6GjTM2UwTsEehBhYEODBnhxU5v2Xc0BWhBt/ObYElG/nhoVA+hEM4CewZsgir7QuuUn9TT8xa46HlgmRWz9NCQqe8Z2ZlR5xEkYQvqecjbhBbrce1eKzNiiv4sk563Iaavv/EDzs4zkwFL8aqNe2EyUvOhlaRsJAYFOd/5X2cqHF5TVzDRIP0k2+kigCRe
 pl5H7gZe
 JLy2kupf7Xdj5MADaABjkCXa88Q8/8gGiO6lH7IzAoHNwCoVqC1fZ+ODf8a9qQIy/u346bG2uVltkT3F9ARSBD0PpL8ODdxOGkJAsAettpKbTQiQi2tEB8saf3ruEQWvY2LBIlEOugeHMAcPdldXF/QxxAKg4IJXDlD2gywKyjM/ChfJDysM7OlFTcgVKXwn4B04XH28uPqaY9nz1KVnm5WHJa9R2+1Txu4c3SSzW4AmDJ1A74bSvBkZML14aKX4SRYP35oD4eZ5tiRsUdWoJTSHtqQAStFD20q19+cw5aY3jGcxF40e6zTXyW20BvlvGZg07aq229RQK4B1ggUClI4AKE1IXuSlYTw+YCEf4g77MppbKjE02j0OFsQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 14/11/25 8:30 am, Wei Yang wrote:
> The current hugepage collapse scan results include two separate values,
> SCAN_PMD_NONE and SCAN_PMD_NULL, which are handled identically by
> the consuming code.
>
> To reduce confusion and improve long-term maintenance, this commit
> merges these two functionally equivalent states into a single, clearer
> identifier: SCAN_NO_PTE_TABLE
>
> Suggested-by: "David Hildenbrand (Red Hat)" <david@kernel.org>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> ---
>   

Reviewed-by: Dev Jain <dev.jain@arm.com>


