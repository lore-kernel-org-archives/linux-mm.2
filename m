Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7FDDCD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 02:23:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE0C06B00A0; Mon, 18 May 2026 22:23:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D91666B00A3; Mon, 18 May 2026 22:23:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA7166B00A4; Mon, 18 May 2026 22:23:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B35386B00A0
	for <linux-mm@kvack.org>; Mon, 18 May 2026 22:23:02 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 521201A0158
	for <linux-mm@kvack.org>; Tue, 19 May 2026 02:23:02 +0000 (UTC)
X-FDA: 84782571804.16.D3ACDA4
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id E395E1C0007
	for <linux-mm@kvack.org>; Tue, 19 May 2026 02:22:58 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=WV0BjNfm;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779157380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LIk/NWSgUYZOSk5yFuK7TNfkGqGRO+5XC4I2PR2ONr8=;
	b=xxM8bNxfZDyHA0LN0cjrbVLbAsXbnMBDjyslezUCLTO3nUKAy3VCDYHm4NK7GSyEnym7uG
	8hRzWaioKtPCPvNFO0J4+lJKe+p5gDqQECfuDwP2XVuxYv9/fF92ogsTBIj80n+bBT4ZS/
	jHoS7WcEGheq4NCHycxPkVsBKYoqi7s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779157380; a=rsa-sha256;
	cv=none;
	b=68eoNbeqhQ3w+gSA1PUp0CNFcAv+uv1lfIx+2frHsKMCWkfnj9dyS4eP4ATlwdnDzU+NdP
	PGiM3ZDoastwOQsFd/YGmi42XXK/kwu4WlEnXNbukOVaJDsR4HZn5sthNOmWW4/lduClka
	jYHXV8bkTUYCzctRV6e9hTTcN3k8rVA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=WV0BjNfm;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779157374; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=LIk/NWSgUYZOSk5yFuK7TNfkGqGRO+5XC4I2PR2ONr8=;
	b=WV0BjNfmRwsivwYpVl2NxA2J7DNU8feqGlUbgoEm0mB9MyVe0sLbtU4Y4F5lUbDu+ambrVWVoBf3r6sqfpgAXBjad8cHLsQGLLNTCR/qjfI7AXgoQLJDDgtT6p0LonvXUQZ+jqb1eGMCKPiXU8t6nzAHK1bFFvqbX8NZxqgFsXE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R861e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0X3Dv23q_1779157372;
Received: from 30.74.112.128(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X3Dv23q_1779157372 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 19 May 2026 10:22:53 +0800
Message-ID: <72d2721a-f52c-4330-bdb0-4f0615512956@linux.alibaba.com>
Date: Tue, 19 May 2026 10:22:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] mm: shmem: refactor thpsize_shmem_enabled_store()
 with sysfs_match_string()
To: ranxiaokai627@163.com, hughd@google.com, akpm@linux-foundation.org
Cc: leitao@debian.org, ljs@kernel.org, ziy@nvidia.com, liam@infradead.org,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, david@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, ran.xiaokai@zte.com.cn
References: <20260518123238.56344-1-ranxiaokai627@163.com>
 <20260518123238.56344-2-ranxiaokai627@163.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260518123238.56344-2-ranxiaokai627@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E395E1C0007
X-Rspam-User: 
X-Stat-Signature: ax699yw8iox8sug7nnarnk4rcqwofgo8
X-HE-Tag: 1779157378-408807
X-HE-Meta: U2FsdGVkX19lrFdZKYZkl44BWSJMc9BGjcfLYSDgQbeGvc1yB4mURQmpSzizwVqM84V6tdFJlh1YMmGVHo15NlyiRO1AEAbXsgBPx4nK6R0pYXNo1xbYfocuRc/KIk2PdFQAOOuDWIaR2G0jnfT6S4BA9GDu04I/a2oTYwjSUc4uZpLiWKAMSawFcY+H4/ORx9QVd2Vo3+BvXD3sKlrEg7gb3CrqrjF7z55HY6J6xlkzIAvTR7CN9LdVfi+iHlYC1Qob2a6lh1t6DYeRLmACnLc+juCn+pWeL4AL56mHS3FhT1E37mC8FhuOKTY7YgoowLO/V2FFXL3fZ0+XFK3JjN/tObc4ltc251UCpoYqqFX7eJ+657Jc6aZBKrK3U5R89v3pN9EKTu+Xx00Pt5vOAkghDF8p3k3rgE70lgZ9w7SscfgUa84G48ChIuKjFmknA1iG2mlX6mFk0Ojcw4MLQRZUBG/6hG63Ntz9xDFoFzmh5R2WPGHK3eftFvMX0xGYjaG8yyEYko0K9z+twv5+fdGJwDojjcFLxVCNJt/lT8dBVPuwfcKKS1r7a1H6b2+q7Nk6gODdIFDGS8cNnVjsMM8xW6i+/Sb4pP1jvKjNNTF3iq/JvDGrm3leJqTBUzTxSYSb8prdga1QEiI79WZAu7h6a8+awzA8UwhDonukJovTDwK2Qqc0jEKmpGg279iPnS4gWPs1X14ANUJhTimNN0eb8q6vvm6sw54iu3oQ6EuLjoUtIj1YH/p+lIXAP6obe2kFtt411YSU7Rbhz6wKMmAYstwnPxMxBqD9t/VL3dL546xjLPp0G6CtqRD7wj81gN2QSiKMpaotrLRH4g+93ln445Z19MG218w1oxaiA3UO16MgyUtqDBIIlOOI8De7Eb86mUGaX1B4Wt2ktDxyv+I4a3ir+zDrkz2P0XB5kgJYoxsesdlGSkwEwPKtgke7PYGg/h3Z/1cdrkd8vfs
 SnumZGWp
 GsaUUNwHLpT0R3jdXFvz6K2Kzao5ydOMFifzUqhxyFPcnfyxeC0v8g/QYJ7N4HLooIpGh3r59C+G0w7Mv3uPgH41GFx4Yz4xCINmjyc0X+mqPGZhQG7Q6BxdEu1GYxS1k3nWcqdWNttT93znc1qbA+wUyRht4rYWcy7KM+e5JCjie+w+wC8oI3CtSh4UHjPFY9FBL78h9n3rgHiE38WRLkR3sm/ed7G2WsQ8VfQXGbvXK/5Da5A43Hh1Wx1bxLH/ESc2d26yFmG1VoFac3thOtffw4okvga6hVBo5gsG7VOVHiy+HCY9M1Jo4+d7LdOE5qnpy1+M8NzTLslg8whOie3ykcp7zAMUMr57wPcmCBskZ0JT+uN9HrwRFIbXsQTXFPNEAdRpGeCF/ysZA6FwpIjfKxUKBrF5IlrdbEPTdXrB1mZP0ATQYlIGBeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/18/26 8:32 PM, ranxiaokai627@163.com wrote:
> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> 
> Inspired by commit 82d9ff648c6c ("mm: huge_memory: refactor
> anon_enabled_store() with set_anon_enabled_mode()"), refactor
> thpsize_shmem_enabled_store() using sysfs_match_string().
> This eliminates the duplicated spin_lock/unlock(), set/clear_bit(),
> calls across all branches, reducing code duplication.
> 
> Behavioral change:
> Call start_stop_khugepaged() only when the mode actually changes.
> If unchanged, call set_recommended_min_free_kbytes() to preserve
> legacy watermark behavior. This avoids unnecessary khugepaged restarts.
> 
> Tested with selftests ./run_kselftest.sh -t mm:ksft_thp.sh,
> all test cases passed.
> 
> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> ---

Please keep my tags unless there are major logic changes. Thanks.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>

>   mm/shmem.c | 107 ++++++++++++++++++++++++++++++-----------------------
>   1 file changed, 60 insertions(+), 47 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 3b5dc21b323c..46d2cfc30823 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -5526,6 +5526,29 @@ static ssize_t shmem_enabled_store(struct kobject *kobj,
>   struct kobj_attribute shmem_enabled_attr = __ATTR_RW(shmem_enabled);
>   static DEFINE_SPINLOCK(huge_shmem_orders_lock);
>   
> +enum huge_shmem_enabled_mode {
> +	HUGE_SHMEM_ENABLED_ALWAYS = 0,
> +	HUGE_SHMEM_ENABLED_INHERIT,
> +	HUGE_SHMEM_ENABLED_WITHIN_SIZE,
> +	HUGE_SHMEM_ENABLED_ADVISE,
> +	HUGE_SHMEM_ENABLED_NEVER,
> +};
> +
> +static const char * const huge_shmem_enabled_mode_strings[] = {
> +	[HUGE_SHMEM_ENABLED_ALWAYS]      = "always",
> +	[HUGE_SHMEM_ENABLED_INHERIT]     = "inherit",
> +	[HUGE_SHMEM_ENABLED_WITHIN_SIZE] = "within_size",
> +	[HUGE_SHMEM_ENABLED_ADVISE]      = "advise",
> +	[HUGE_SHMEM_ENABLED_NEVER]       = "never",
> +};
> +
> +static unsigned long * const huge_shmem_orders_by_mode[] = {

Nit: the name feels a bit verbose, how about huge_shmem_enabled_orders? 
(Perhaps David or Lorenzo has a better suggestion:))

