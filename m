Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A257FD8FDA
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 17:34:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55A7B6B018D; Thu, 26 Feb 2026 12:34:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5329C6B018E; Thu, 26 Feb 2026 12:34:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43E776B018F; Thu, 26 Feb 2026 12:34:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2D1836B018D
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 12:34:36 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D9592160284
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 17:34:35 +0000 (UTC)
X-FDA: 84487307310.10.079D079
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id C6A112000D
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 17:34:33 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lEz4PawU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772127273; a=rsa-sha256;
	cv=none;
	b=ktXC5izdxC6V4PAxNvhdilnW108I++yHMO2IAhNV/9yIGTD6dI+0GGG7HYpNe0Q8fbbMPB
	Ydk2SL0vTuPK4Oe+Nc2QWK9umtYlUv9IKTmZEQf0AKmh+qVBByeBI3LesOT3dWRQciZpRj
	kXIlhm2yRkMMziaCZ3tIZSrqZGc/imA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lEz4PawU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772127273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f/qGGIoPfXbCHQkn2P99vURgmqdfIEGkOwYRdpTeE60=;
	b=tOTzWBgreoTONIDZmxQLDyLV9zZMh5uLCK4Cd/GCdupO8d8XbgLM5zec9OkCWVMiWQam+p
	7VtVeP9bSWpjMRcMSVTs+u5HF6gw7YeEOL7xUxIAQAQOiZAOsqB8b6B3OLI5Hrk5dE0fey
	6QJxg1M0GZmZ3rcmOosOkrJ9YecKu5Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CF3E043755;
	Thu, 26 Feb 2026 17:34:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 853D4C116C6;
	Thu, 26 Feb 2026 17:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772127272;
	bh=7ckD0akXKp5yLmXPxmzZt9zqQrhBl/9sTG74HrNfedw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lEz4PawUesO+34+SHQ759Xpjio4FLMXg7qsEvPAXt0ZKKZO4I2kQ4PaZLARMQwY70
	 JBoK73NyWHncOGYZ3P5a+JchaTsq+1o+F2nmWq5n/qkXET0OEvENaTorD+3bKRxj4J
	 W2cCZ+JQ6QuDmIaBB7mjSZuybtAsvMYYfL6T3HKRnsFe3L4t97d+NhK22On8HhnKI2
	 xAZ9VnipVJ0oVMnjy5SoQpUwtB/d5YUqm5ZqCyzhCldmx6Tek7RbEu0WgT3nj7utjh
	 xgyFFPgywESchdOad4i81oO7pQWx6DpteJKQ9Bdk3l6dMrQjApdOtHkTbWO9tKVzf/
	 K7EUEwl/iLaBw==
Message-ID: <baca70a2-53cc-445b-a14e-ed926e615952@kernel.org>
Date: Thu, 26 Feb 2026 18:34:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] hv_balloon: Change default page reporting order
To: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>,
 akpm@linux-foundation.org, mst@redhat.com
Cc: vbabka@suse.cz, surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org, jasowang@redhat.com,
 xuanzhuo@linux.alibaba.com, eperezma@redhat.com,
 virtualization@lists.linux.dev, kys@microsoft.com, haiyangz@microsoft.com,
 wei.liu@kernel.org, decui@microsoft.com, longli@microsoft.com,
 linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260226070125.3732265-1-yuvraj.sakshith@oss.qualcomm.com>
 <20260226070125.3732265-3-yuvraj.sakshith@oss.qualcomm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260226070125.3732265-3-yuvraj.sakshith@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C6A112000D
X-Stat-Signature: zwtpugrqcq81w65pyraumwwfnte7wq84
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1772127273-815626
X-HE-Meta: U2FsdGVkX19rKuMZATk++O5Nu96m1cO92wgbbcaKzkFC5mVaDe9JN8RC9g6+W/AoQPZvTPDieEBe4tuLMiyAoDZNnZ9NgTaD2S+5wUUi3Ozji3uOeCuB1pvWqzge/qFdGNrhaYGhm5E4b++rT0SzfKpyQILmnJ5PQe6hBWtzBI0x9UZlQ4IvovI1wQ8JLH+2ACgpXO3KhZBEYkAhcetJaFsLZLsrI6OP/iew4xeKhCpaR6IGFk6FGCRobMl7GudpkvLlKs/DUFvgJlKghJT6uyl2o5Gy1UFB6nL1pmOh3655yT7qPtOc0Y1VtDZg2v4/mKF8deCgiyEdkWG06EzG5mtB1GuIrMuFmJdVUOgAGn5LNNneAO3XKUTvDzAb7OsBYttYxpW/a82gvPEXjiXz+HylZi4XFNDY7nE2XE6FCSYQm0+v0EF9PpM2k6GeOYriSzMcdM9CWcqvCEtPzQLDpeTmZn6G5pTdZWVK5ciD5xPG8tOMprEADMZluvPmpk1wAJ21uQ9wt3fCkiyMlCNYPKIWXSKkn47ki8SrQBup5nIm2UZu3aF07VdfdwdsjryWceHQ+eT4saPkySHXe45lRuCXL6kfZjazANP0DwhmbaKj8jdLDC80YG41l7lMYcn5PCH2RATkvtjPgewnOLdxvzAY8sysQETeSiIlm1oa4lo904s88+NhePSpAbdrQ7o0yMgU3DeejwWd6/EEab2ufSzlBHwpw8iKRd+16th+3ORHuZ12DzWaH/4ALGHWQ2XRmdmt7xrdD9R8K1IaphUD5IabV9uEsPChmQkPxwgzg2XFmkcKVpg0EhMWZ6oA+mIIT8ujg48rsWKcPOXOnWuDHpEgeUYCoT2TuEkx2i8bDrKYbrY5MnuJufuKySXaoa7Yp5OXbINJ/0uyImQtEbYGUdvmnT3peRgFb5bPsaWSAfMegY1UjJrsD8k7unK9E8fT09p0Ez8yHENwlU8THmM
 NTJBm5so
 dy3THDLpoaWdNHCFZ2VQPSGuiN826ZiaBeGHD7gg7bEDIUlRmFimZIoooS52ag50lY95fO7mtyula34gruIXaXIe/sJ0IEuxSq92uZ50e1w6WWoxaGmVoX4Gl24iAgb00cSbR7du973ZbXjOHAaIw0qOkahMRad9UjlLz19vkCTs72zYwH+8/ue1AZWJMR57CDAmc23uDUxIXfZjdiv5D33aQxUmuTAoVjat5PYzp0YlBe3tBWsF4caTx7QCGJZe2QNmrnb1vL41LyXJ3jLk4CbWZUEmT2KkcDcB8uVU/uOzxhk7KZe7eCZ8Fsomjd9Kd1ChOzzYMlD9W+GG8PA8aVBvl6UXIlmICTfI3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/26/26 08:01, Yuvraj Sakshith wrote:
> page_reporting_order used to fall back to default
> value (passed as parameter or MAX_PAGE_ORDER) if
> the driver wishes to not provide it.
> 
> The way the driver used to do this was by passing
> the order as zero.
> 
> Now that zero is a valid order that can be passed by
> a driver to page reporting, we use -1 to signal
> default value to be used.
> 
> Signed-off-by: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>
> ---
>  drivers/hv/hv_balloon.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
> index 2b4080e51..e33d6e3b2 100644
> --- a/drivers/hv/hv_balloon.c
> +++ b/drivers/hv/hv_balloon.c
> @@ -1663,7 +1663,7 @@ static void enable_page_reporting(void)
>  	 * We let the page_reporting_order parameter decide the order
>  	 * in the page_reporting code
>  	 */
> -	dm_device.pr_dev_info.order = 0;
> +	dm_device.pr_dev_info.order = -1;
>  	ret = page_reporting_register(&dm_device.pr_dev_info);
>  	if (ret < 0) {
>  		dm_device.pr_dev_info.report = NULL;

Logically, that patch must come before #1. And the patch description
should be rephrased to clarify that we want to change that behavior.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

