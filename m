Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EF74CD8C8E
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 06:23:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D6176B0088; Mon,  8 Jun 2026 02:23:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 186586B008A; Mon,  8 Jun 2026 02:23:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09C2D6B008C; Mon,  8 Jun 2026 02:23:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EC8816B0088
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 02:23:36 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 27B0D164B5B
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 06:23:36 +0000 (UTC)
X-FDA: 84855754032.22.2C552DE
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf12.hostedemail.com (Postfix) with ESMTP id E28BB40006
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 06:23:33 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TwOlptSy;
	spf=pass (imf12.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780899814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iabxNAjlCFgMo3PCIWOb5E5kf8/DsNZHurW4YcWP6NA=;
	b=al60bYXIcm8teezy+r5Y4ydfZ0yE4ShQ+EmQXdn652+IDQ6hEnIkrNysVSuTTmyKzwkh51
	YJTDDjWOIULwDV2puu7njcCu1iXer1xw44EyuZ6jkaPuQJ1o2kU5f241YMKZq40MbPktTI
	qBKkKS/grgkjlFJBJ1WeBG92W4B7mB0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TwOlptSy;
	spf=pass (imf12.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780899814;
	b=2jzg414/bYjdpzjLpXpp/SOMNIbEphAnCWwWcPFqqCsgngQfcyH9y2Rm2rqjYTAqLpRazv
	46YxFtdu+gk7ILSsUqsVcpParKZl5nDd7uGmRF8TCxrJCdKP945CYQhDmsfIdH+2NeFdg4
	DraaHil9nOajYGtFY+68TxdmidMZjsQ=
Message-ID: <1ec17313-cd2b-4389-a05d-998757af30b3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780899811;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iabxNAjlCFgMo3PCIWOb5E5kf8/DsNZHurW4YcWP6NA=;
	b=TwOlptSyCuwlyz+cs+2cC+cgE72sF47EGRZ1CQFhbFsboWWqAliar9vg/zctPFBH40goI3
	pqo2JgW2wsFZ3JdI0nYrVLri78MR4YAUKvyfx355E0BxuSTEArINylbYjiNyYlMC30yPIB
	QmRLjQEpO4bLqWqNvSuBOINKk5DYo1c=
Date: Mon, 8 Jun 2026 14:22:59 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 4/6] alloc_tag: add accuracy based filtering to ioctl
To: Abhishek Bapat <abhishekbapat@google.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Sourav Panda <souravpanda@google.com>, Suren Baghdasaryan
 <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>,
 Kent Overstreet <kent.overstreet@linux.dev>
References: <cover.1780701922.git.abhishekbapat@google.com>
 <b608a6f7d71e3b728f766dbc6dfa1d1753ddcff5.1780701922.git.abhishekbapat@google.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <b608a6f7d71e3b728f766dbc6dfa1d1753ddcff5.1780701922.git.abhishekbapat@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E28BB40006
X-Stat-Signature: s3uubh9fsh9om4y94xab3ap3srutfaf6
X-Rspam-User: 
X-HE-Tag: 1780899813-591679
X-HE-Meta: U2FsdGVkX1+b8c5CffOAeMKodI/eaoj9oBnaFYKhj2uFPmXh2PtSdhq30wrr7IVAag5cfttmUo5mwbdNeTeV8i38P8V3NHdbiWwHc/8qM+oDU9Gb7J7nZaNZlROecniDkzUygzA0BpgXHXhUxaZpCTEi/qriUeSU8Ldjbb+Qt+Lv/Ke3A0AdDxNdhmg+9fArCkp6d0BvGus6R3OC/RZemZhxYEOL4L8pALJTHsPdnvfv6LZcwRNlJqLdKuEb+fH2eAoIrKXztRLSldzKvDBa/x9aI1eERNyDa+RU/HdAJKS7qgV/GXEwActUc+iRaPS91WPWoPLKrL2rxp2aJvB5qPRUolnOWM+ahSkssm49UibBg40e42Lcdpfi1B9tc21Aqd44kvfKOkeFlCWkEl89sblS0ogeNz7hTjDB+3kFASzbBhfRWbvO6rGjOpcSnQlYx2K5Nqmtnutx93o7uyes5lhyIuqSeFxUJB67rqHiTaTaEZ2JP+65U1JxgIa3XIyYt0RFtK32n4W6Ncv7bwfpZcgR9Z7xA59f4wTSFCfmSqej8SbSnCVQ/UtiUM3rraC2TUa2svqSKf00imywDvs/Y9rmHrcWJAYiflJTupL6q/DFcQLs+tFMM+0MGW/bfoTEainCdAVu+z63HaYRwPSYFcBk63K2YmuPaVrQLMcKnH1ZYuhLWc4tMGUkFqph/DuDWfEzXYug5sFvCG+oMB0RelyzevXMVWSpD02Vf01f5dvoEs5J/SDYjVuAVZFHCoy7qSzVqcnnPu8Bsjfqefdqm6qvUjwK54GTwhNZJeBVC458TCIhXvVD7WTl+EvvzbB8Szn//wUDtiv4QFQ2kaG316K/Nz3qVR/DOP/4ahPdMElu0QlN0XGLuh3BQ7oH9Rr0aKuwx7yjLmqCLOYfYWia391NzJdX9qJ7tDFIpqLEd5goLX5gB0Ei6CbY15WjGF0CLyJnQVb0s9db6uF2f8V
 ZRtjMoY8
 tc/6TujIy+fN+2diPeEoP3e5PEBRu2CCvxfaoYQXYpWkIspI1tg33DioTsx0GQUvEgKuzYl/R3eHGdKaZnIGgu27TgQW/uQ6k1gLWejqobboTe+b/pdG/bxMd+vMPtK8HufvE0l1Zd7kB3ih+6WZYtkeTe0atPNVa+y37DnIqV1a70goS318JYS8xHG2oBDXWsgDRthF1AEBYBQtosGyVbxMIwM4zDvg/LxjpPUre7YHST53zliikn77GvN48ny4b2otYpFRm8d0gjnWGURnOgp82b2B5WgRLs2TgG3XSvP1CqOW7G1i+SOJldTyKNUv0Djh9rlrT2V7+Z9o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Abhishek


On 2026/6/6 07:36, Abhishek Bapat wrote:
> Extend the allocinfo filtering mechanism to allow users to filter tags
> based on their accuracy.
>
> Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> ---
>   include/uapi/linux/alloc_tag.h | 3 +++
>   lib/alloc_tag.c                | 8 ++++++++
>   2 files changed, 11 insertions(+)
>
> diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_tag.h
> index 0e648192df4d..42445bdb11c5 100644
> --- a/include/uapi/linux/alloc_tag.h
> +++ b/include/uapi/linux/alloc_tag.h
> @@ -20,6 +20,7 @@ struct allocinfo_tag {
>   	char function[ALLOCINFO_STR_SIZE];
>   	char filename[ALLOCINFO_STR_SIZE];
>   	__u64 lineno;
> +	__u64 inaccurate;


I was wondering if it would make sense to define inaccurate as a flags field

(e.g. __u64 flags with ALLOCINFO_TAG_F_INACCURATE (1 <<0)),

so that only bit 0 is used today and the upper bits are reserved for 
future use,

aligning with current kernel codebase.

This design also allows for better extensibility if we need to

add new flags for any reason in the future.

We also need to add flag validity checks if we go this route.


Thanks

Best Regards

Hao


>   };
>   
>   /* The alignment ensures 32-bit compatible interfaces are not broken */
> @@ -39,6 +40,7 @@ enum {
>   	ALLOCINFO_FILTER_FUNCTION,
>   	ALLOCINFO_FILTER_FILENAME,
>   	ALLOCINFO_FILTER_LINENO,
> +	ALLOCINFO_FILTER_INACCURATE,
>   	ALLOCINFO_FILTER_MIN_SIZE,
>   	ALLOCINFO_FILTER_MAX_SIZE,
>   	__ALLOCINFO_FILTER_LAST = ALLOCINFO_FILTER_MAX_SIZE
> @@ -48,6 +50,7 @@ enum {
>   #define ALLOCINFO_FILTER_MASK_FUNCTION		(1 << ALLOCINFO_FILTER_FUNCTION)
>   #define ALLOCINFO_FILTER_MASK_FILENAME		(1 << ALLOCINFO_FILTER_FILENAME)
>   #define ALLOCINFO_FILTER_MASK_LINENO		(1 << ALLOCINFO_FILTER_LINENO)
> +#define ALLOCINFO_FILTER_MASK_INACCURATE	(1 << ALLOCINFO_FILTER_INACCURATE)
>   #define ALLOCINFO_FILTER_MASK_MIN_SIZE		(1 << ALLOCINFO_FILTER_MIN_SIZE)
>   #define ALLOCINFO_FILTER_MASK_MAX_SIZE		(1 << ALLOCINFO_FILTER_MAX_SIZE)
>   
> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> index ddc6946f56ab..cbcd12c4ef9c 100644
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
> @@ -275,6 +277,12 @@ static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter,
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

