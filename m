Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F5FDCD8CA8
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 01:53:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 711396B00D3; Tue,  9 Jun 2026 21:53:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E8DF6B00D5; Tue,  9 Jun 2026 21:53:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 626996B00D6; Tue,  9 Jun 2026 21:53:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 51B5B6B00D3
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 21:53:35 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1EA681C28D0
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 01:53:35 +0000 (UTC)
X-FDA: 84862331190.28.D75F4B3
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5A6F9140004
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 01:53:33 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="bbsvwp/d";
	spf=pass (imf23.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781056413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FrmWqzviIqBB3IDNdu15PDEAaOUICtqvo3B9Gs8vRaM=;
	b=VhLEzRMVqgQAsMUG3N6MXlb4T7mvFPoyE/pdaxyp5YHxo0oBLARg4NcjrWKJ3jU8oCSQFH
	tWlZGTDo6xegbw6XoZFTXc+QljPfh80Um1uTmzlzqp1dNFOGnvv2db5CFM0T1WEfG4OOw7
	07hKlm8i6YP+XoV7j0NgV1vt2KBeMYY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781056413;
	b=uAgjplCWb5hhnSs1s393iP8gTw3cTmVGBvzvCILCw4yw+X2mV9fBGqQ5mOMul4pQZ1Ylgf
	1XYt7bhYOUsHqQAgbQqc1mR3MHOf2lvhM69MXi5VdMrTfNh8i6jp/tCHP4AAP73YqZsdR6
	+dprwilXNf/T/asYkxrNASbCpbq/+L8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="bbsvwp/d";
	spf=pass (imf23.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <c7a83b2f-ee5e-4de1-807c-311db839b4d5@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781056410;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FrmWqzviIqBB3IDNdu15PDEAaOUICtqvo3B9Gs8vRaM=;
	b=bbsvwp/dxTTGFU3RSHnkuoHl/y+d0uyW4xm7CWNpqBW1pML/tXksWqhJhsHBKFqph+sFH1
	VUw2Jhbbk3xza8B43C6LX8sOiyplrt59k6ZZYcMcrt9rkM/VF+k1vNX9igbWdCfqr9KFh/
	KJAYQiN60SoRDXVMnxifP1B3OyY5p0c=
Date: Wed, 10 Jun 2026 09:52:52 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v4 4/6] alloc_tag: add accuracy based filtering to ioctl
To: Abhishek Bapat <abhishekbapat@google.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Kent Overstreet <kent.overstreet@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Sourav Panda <souravpanda@google.com>
References: <cover.1781042698.git.abhishekbapat@google.com>
 <7f3a4ddb3f132464f17716eaae657a6367d6dd05.1781042698.git.abhishekbapat@google.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <7f3a4ddb3f132464f17716eaae657a6367d6dd05.1781042698.git.abhishekbapat@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 5A6F9140004
X-Rspam-User: 
X-Stat-Signature: fkiut6pikjdjedq8mtc6w7i99fkk9rix
X-Rspamd-Server: rspam08
X-HE-Tag: 1781056413-444309
X-HE-Meta: U2FsdGVkX1+agD+xBxsYCnaEG8xgwbD0QoYx0xvb2gxjR45tYMjf+Cw0xa4mTNX5d2ZPLowCzqhxmS1EfVVaB7RSFFHD78jGYM7ahMTE3aiXLfqUUtpcoxiwVupIZKsnw7w6QzRPFgqUsiEMkmcZzMtWxYstVjWJ5r5UVCR9gqVxQzayYT10yK1tvrioK3+lg90WsCK6pDOzwtq9hOawKmuv6pgVD8mSWTsXrgGNtIJ2iuh0qJoVEbtOcMr47KYukGWpPdKl21s+LCIDk3Qq2VDDk1W9zO430u2fNRRBoi15DGxMW+pEWNQ5RbPpW0TUQHvR/d/SuQwelzJU80IqC18f9UoRQ/jy4C8BF4bwgLTuS3OMlvEd7Ikyh2jVg1j2HjJYLTx9rK/wruw6wws76KdaSn91Ma8QfrSPDCSGg/xfXbE+hbfJvEKOE/2oZTxwiTPdWZ4c46Ij2x+jrkBGUcL1ypH4tScizaP8MFIVdEPz/Dr/k6Ku7i426LP6WxItqVlkR/pkTJJJnWeB4ASheluIcBEd7RMIPADgYvCZs4syScQAutSBGFPHGdzfODXwByqpcVbez7vMYKZKvZ6OkhoGATRxMZcvgbmWvixhfsCozFgrnjFc1vYeNbRwrMZ7SJ6szWhzAAwqdlgZypV+L5jz9ms8GSykLE8aRH1yJ23mEV5l/ApQg9bOoCQuYIfNsDx9mBb16YumE5d402n0PX1n3W03Rcju3el1fSmwLm3pS0R38l9yDWpPdTfewpQguaZUJ5o8kqkH9LcOk8Bqsi2bi4MyG9x0IZRO+LoF5LYej3EXJV3Q8Mq2+UqdnoKee5yQ4Lkwa3KrOZ7vqSOtL0vz63a+8pAaKnWscaD7oihCdW7mObTQAjhQVuzXh9r4TMHvWf9qTvydPQG69MbGBmPw5q7cGeLPnjHv2iYnbyoJnuQbf+FsYOS2qs1hI14szS+BudbVXPtxLhflRje
 N/poAOcY
 RZNPc9QZquIVOCEWGtzLG7tGjsqQYualq6ea3q4Pb/I61VpwseiVUWX81rz+EG2I7Psf3ARNO4BZ33PV/ZBRL3Y7bwcQpOMwsugtJVX6tS3f4/2uK157yTUapedt0QsktSO/UduYErAvARPSL4yoaCjp8nRbe702ibgQnwmaPZHoePdOhoCJk87RR7NeG6Z40qqQGGh2EozlYphEhnsTNkYS7zMVqK9lgbWUIEA7arOFlr4zGnTC2F6JQNTWdACtOV4G48auU4tmF5y899AucjK39drRfV6BPCK6N9nM9nD9cZWK7spuToFQ3/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 2026/6/10 08:12, Abhishek Bapat wrote:
> Extend the allocinfo filtering mechanism to allow users to filter tags
> based on their accuracy.
>
> Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>


Acked-by: Hao Ge <hao.ge@linux.dev>


> ---
>   include/uapi/linux/alloc_tag.h | 4 ++++
>   lib/alloc_tag.c                | 8 ++++++++
>   2 files changed, 12 insertions(+)
>
> diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_tag.h
> index 7f5acbb44c14..6ea39c4869fe 100644
> --- a/include/uapi/linux/alloc_tag.h
> +++ b/include/uapi/linux/alloc_tag.h
> @@ -26,6 +26,8 @@ struct allocinfo_tag {
>   	char function[ALLOCINFO_STR_SIZE];
>   	char filename[ALLOCINFO_STR_SIZE];
>   	__u64 lineno;
> +	/* filter criteria only; see allocinfo_counter.accurate for actual accuracy */
> +	__u64 inaccurate;
>   };
>   
>   /* The alignment ensures 32-bit compatible interfaces are not broken */
> @@ -45,6 +47,7 @@ enum {
>   	ALLOCINFO_FILTER_FUNCTION,
>   	ALLOCINFO_FILTER_FILENAME,
>   	ALLOCINFO_FILTER_LINENO,
> +	ALLOCINFO_FILTER_INACCURATE,
>   	ALLOCINFO_FILTER_MIN_SIZE,
>   	ALLOCINFO_FILTER_MAX_SIZE,
>   	__ALLOCINFO_FILTER_LAST = ALLOCINFO_FILTER_MAX_SIZE
> @@ -54,6 +57,7 @@ enum {
>   #define ALLOCINFO_FILTER_MASK_FUNCTION		(1 << ALLOCINFO_FILTER_FUNCTION)
>   #define ALLOCINFO_FILTER_MASK_FILENAME		(1 << ALLOCINFO_FILTER_FILENAME)
>   #define ALLOCINFO_FILTER_MASK_LINENO		(1 << ALLOCINFO_FILTER_LINENO)
> +#define ALLOCINFO_FILTER_MASK_INACCURATE	(1 << ALLOCINFO_FILTER_INACCURATE)
>   #define ALLOCINFO_FILTER_MASK_MIN_SIZE		(1 << ALLOCINFO_FILTER_MIN_SIZE)
>   #define ALLOCINFO_FILTER_MASK_MAX_SIZE		(1 << ALLOCINFO_FILTER_MAX_SIZE)
>   
> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> index a936cf18611a..73fb3d0ab821 100644
> --- a/lib/alloc_tag.c
> +++ b/lib/alloc_tag.c
> @@ -249,6 +249,8 @@ static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter,
>   			   struct alloc_tag_counters *counters,
>   			   bool *fetched_counters)
>   {
> +	bool inaccurate;
> +
>   	if (!filter || !filter->mask)
>   		return true;
>   
> @@ -274,6 +276,12 @@ static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter,
>   	    ct->lineno != filter->fields.lineno)
>   		return false;
>   
> +	if (filter->mask & ALLOCINFO_FILTER_MASK_INACCURATE) {
> +		inaccurate = !!(ct->flags & CODETAG_FLAG_INACCURATE);
> +		if (inaccurate != !!(filter->fields.inaccurate))
> +			return false;
> +	}
> +
>   	if (filter->mask & (ALLOCINFO_FILTER_MASK_MIN_SIZE | ALLOCINFO_FILTER_MASK_MAX_SIZE)) {
>   		if (!*fetched_counters) {
>   			*counters = allocinfo_prefetch_counters(ct);

