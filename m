Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEFA5CA0EED
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 08:37:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17E2A8E000C; Tue, 19 Aug 2025 04:37:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12F098E0002; Tue, 19 Aug 2025 04:37:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01CC98E000C; Tue, 19 Aug 2025 04:37:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DC7168E0002
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 04:37:05 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 850A71A05B6
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 08:37:05 +0000 (UTC)
X-FDA: 83792852010.15.9C4DE64
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf07.hostedemail.com (Postfix) with ESMTP id BC06C40003
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 08:37:01 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Ee3Ss2q+;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf07.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755592623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hv85OKdbUVLLicGnLiBJxS9oGC/z4oA0d2NpFuy29Yc=;
	b=xntQthr4B9VCAFQ/rm9Y4LiD8ob8HdAusDGvYgrKbgEPa3UAcv3GaVW6vkmZxJeoIW3mr+
	3Q8LX0Df/2z2fZB2/5xB7MAeONL0QXBpmIkwCohFzMKt2uqxrx7HvIYxBTeCgqdpMx5XUc
	XmVRmQl82nzUPibF3cTfP/VB0TyKzbE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Ee3Ss2q+;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf07.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755592623; a=rsa-sha256;
	cv=none;
	b=mk9wDRMrVd2hNMFPewyhXE6x9kWFeTrf23zvfXnEmZkAGUuhSHGp1CyS23a2IjK8jWGuxG
	1mKvObn5JXzp36NTPAuGxXyTjIMfmeRLC1/drpebscDN/OMc6vs52ZUkJq+2RsExHJdhaU
	AnoOAmyZCoz82NF/YagZMtgsIcZZfdM=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1755592618; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=hv85OKdbUVLLicGnLiBJxS9oGC/z4oA0d2NpFuy29Yc=;
	b=Ee3Ss2q+sWa3I+ApMtS4vPsdmjXyu8I0vBcoxsNvppyzrByxJ0Mtpo/5kd9EZ9pZPIglboGdQpV/sWs+5fkwqC1x8DG21VI9CZFWmIIZLhJiWmH/JMWcoQGPXN/48gUQtRstcxDeGv0upipd/Mkj6nuqG5pbcKHqHQtZmxyvJ4A=
Received: from 30.74.144.109(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wm6eUSR_1755592616 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 19 Aug 2025 16:36:57 +0800
Message-ID: <f26426c0-3ce6-498c-9090-397e93b74d05@linux.alibaba.com>
Date: Tue, 19 Aug 2025 16:36:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] tmpfs: preserve SB_I_VERSION on remount
To: libaokun@huaweicloud.com, linux-mm@kvack.org
Cc: hughd@google.com, akpm@linux-foundation.org, jlayton@kernel.org,
 linux-kernel@vger.kernel.org, Baokun Li <libaokun1@huawei.com>
References: <20250819061803.1496443-1-libaokun@huaweicloud.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20250819061803.1496443-1-libaokun@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BC06C40003
X-Stat-Signature: 1g3buafbgd67uakyh15ibh6j9s4zc78k
X-Rspam-User: 
X-HE-Tag: 1755592621-354773
X-HE-Meta: U2FsdGVkX1+cEjeszW2JzFSe7gQUoT1bmrHCsZV7oZgHBVMR0OYTxdkCU98lXQUOMcQ7e2PYdqCEEsh2HWHv//JiZp9fW+wTJ3aFwOGNlFIHcR+swYg6DQs+AfS+MA9lb1BVosvObQXJfastPVieIAbzuvepBPhL+CzGG49F3vbSRFzcEW6FLhRKQB7UwHp7QfUV10fLElI9P5DNrP099YL24iK5ELrgjS63KGhbiZi8J/YOJK5IGTJSeAn/c81gLNZvVL6bDvXeSGuEWY0N/9d+nrzRDTHQw6rfv8Cqdc2z++9Hz9OpDTxgSJgBF/fMfXdGo4D2Yn10LZc2fQ9Vriz9ctW1lb60v1eHSi85RFXmeYtw35ocUKfLkOIP1WbLkKvnEJKyGL9oH3HSctTk/lSP62NrrVNz65yS5QFJV8mHmUy0M6Wv2+4Ck/HKjUR7R94JghVNYepAOz9J0AkNU+blIe6zA31k7wTOsmLnHvvhalabzeJuFoYv55nQGdI73dW0k93RX9BueX1kqjt2RgoSogXDRMlDbuRbKZUEwppnAEx09J9X8zsj1rPh3/XMv27h1EG+67PksMaQmUNEnv/wcNi+4ijShBTK+C6oED/6MGQU0bJyjwyPdn8UVoczU0WlnLc8I5BlLTJIIHxq1vylG/oWzzWbaQRmwovur7rVpA/MmaMMKj/gRof+nauo9U5MLULxqOIl/BUroOa9547RDujRZrqcecN99ir+tXqxcxAxk9olLMIZBwe+i8ncjInPOO+JXu+YrBORLZ5gKBH7xlsDoKm5S+BABAUVZU82ZLwLu7U00usAlu5KNm44nyEL+sjxk3sAvoQ0JS9PkELYSfTjxeycK7xCzZafp3I3Mmxp0c+tPktcqwHg7dEaxpB2nixtDgdmJw66u3pUnFzwI6lNtP66y8i+M02ICZCfB+0M5ViB58/tUd1ZTGwP2pflGtcabYXnfybV70b
 zDTRgyNa
 Kfar/Rw6oyn2lq7+a2yzyykwJwpffxBnRP0GADQjY5OmOO8NkXhrHu0nsoU7UdHzk0DAhBbMoVtHazSzXedssqXXYVQHaPZ/J4SQV6yzO0d3/QLljeW/ABOnwWV8T8NnDnkBnakCcWy/VLZd2hZ0h3Qkuz1jId9Ag+PAptlacOBUAVdCwTSZXb+ZUlOkL8TXjJBaE1uZaMWoJS20qt8GRqAnQ5DAlNpFuQQEa+ndA5akctsyFrDdxFz9fYaxObjiyQex0dtEFFRsyoYZe0kdq7T/CG84KHF+rQsM7xppjz/R5b4SYKP9OhMTMjQWqUPrF1jacnbu0i2OjQEhv/CoaLbwQMtgN6MKzITl3NwTp901IL+DFoKqNGTeI3OG2DiHPT53mlbFb6VAhPA8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/8/19 14:18, libaokun@huaweicloud.com wrote:
> From: Baokun Li <libaokun1@huawei.com>
> 
> Now tmpfs enables i_version by default and tmpfs does not modify it. But
> SB_I_VERSION can also be modified via sb_flags, and reconfigure_super()
> always overwrites the existing flags with the latest ones. This means that
> if tmpfs is remounted without specifying iversion, the default i_version
> will be unexpectedly disabled.
> 
> To ensure iversion remains enabled, SB_I_VERSION is now always set for
> fc->sb_flags in shmem_init_fs_context(), instead of for sb->s_flags in
> shmem_fill_super().
> 
> Fixes: 36f05cab0a2c ("tmpfs: add support for an i_version counter")
> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> ---

Looks reasonable to me.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>

>   mm/shmem.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index e2c76a30802b..eebe12ff5bc6 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -5081,7 +5081,7 @@ static int shmem_fill_super(struct super_block *sb, struct fs_context *fc)
>   		sb->s_flags |= SB_NOUSER;
>   	}
>   	sb->s_export_op = &shmem_export_ops;
> -	sb->s_flags |= SB_NOSEC | SB_I_VERSION;
> +	sb->s_flags |= SB_NOSEC;
>   
>   #if IS_ENABLED(CONFIG_UNICODE)
>   	if (!ctx->encoding && ctx->strict_encoding) {
> @@ -5385,6 +5385,9 @@ int shmem_init_fs_context(struct fs_context *fc)
>   
>   	fc->fs_private = ctx;
>   	fc->ops = &shmem_fs_context_ops;
> +#ifdef CONFIG_TMPFS
> +	fc->sb_flags |= SB_I_VERSION;
> +#endif
>   	return 0;
>   }
>   


