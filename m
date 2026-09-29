Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EC54CA5FAB
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 01:59:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 301A26B0088; Mon, 28 Sep 2026 21:59:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B2F06B008A; Mon, 28 Sep 2026 21:59:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C8816B008C; Mon, 28 Sep 2026 21:59:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 01CF26B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 21:59:10 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8081F160326
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 01:59:10 +0000 (UTC)
X-FDA: 85265142060.04.9CC69FB
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5A7F780005
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 01:59:06 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=bBqBU7YM;
	spf=pass (imf02.hostedemail.com: domain of xueshuai@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=xueshuai@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790647148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8JRCLmFuMQXFiZMU3Bmuz8WXdz3zgxjaZT2gg9tR8dw=;
	b=YCuw4TuoazPZaA475JpEWy4bLMtrZlDJ87qOCfcUsTBJm2UrqVmb2+L5EHbXs2D7ih7gdY
	llTrobKjaMCYAaccWeDRTnkn3wjGAbqf6y2u2GW+ZHEk2yKhnlB7YoQaCB8stGJoI184KU
	O3VEerJb0DchoURHjOkpmO+ENidYzfQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=bBqBU7YM;
	spf=pass (imf02.hostedemail.com: domain of xueshuai@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=xueshuai@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790647148;
	b=XNyqk+wOuZSdCiZCIeuM0ZP53KZT+R3uRS/rNG80BAt7wtKIcNpptCvwXiSZShZKt5F+gU
	M8UOIUYSzsB4nA7escDgx+bJualcg10m7nb13SM+XdnARPKki4z/p2HZQhNAnRgx4wD112
	ARUWPWfhgx3LUbTQ1rrr3s+H0P84Lh4=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1790647144; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=8JRCLmFuMQXFiZMU3Bmuz8WXdz3zgxjaZT2gg9tR8dw=;
	b=bBqBU7YMvj7H17jVPiMFkNqmU0Od9MkHL7G8lqB/23keeC6FXCka3DbPDtb6AG9k4Gzch5E+PO5kB0WKusisC2gPR+5Jbt3IJ8ChqQyEmBwrI3o1GVzcDmhVUWN1Ar6F7wpCWW+UXuKmSZFZ8hyQ1io5LGHisP3P4c3fC0SRZA0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R281e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=xueshuai@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0XBrSLRt_1790647141;
Received: from 30.28.50.44(mailfrom:xueshuai@linux.alibaba.com fp:SMTPD_---0XBrSLRt_1790647141 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 29 Sep 2026 09:59:03 +0800
Message-ID: <56179353-7e02-40bc-b443-80ab8e6b627d@linux.alibaba.com>
Date: Tue, 29 Sep 2026 09:59:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ACPI: APEI: accumulate the queued flag across error
 sections
To: Breno Leitao <leitao@debian.org>, "Rafael J. Wysocki"
 <rafael@kernel.org>, Tony Luck <tony.luck@intel.com>,
 Borislav Petkov <bp@alien8.de>, Hanjun Guo <guohanjun@huawei.com>,
 Mauro Carvalho Chehab <mchehab@kernel.org>, Len Brown <lenb@kernel.org>,
 James Morse <james.morse@arm.com>, Xiaofei Tan <tanxiaofei@huawei.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
 linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, kernel-team@meta.com, stable@vger.kernel.org
References: <20260925-ghes-queued-accumulate-v1-1-df50553957d4@debian.org>
From: Shuai Xue <xueshuai@linux.alibaba.com>
In-Reply-To: <20260925-ghes-queued-accumulate-v1-1-df50553957d4@debian.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5A7F780005
X-Stat-Signature: k9zf6i89rqn9czse34sujtqedsiyi8pi
X-HE-Tag: 1790647146-332838
X-HE-Meta: U2FsdGVkX18TAgtjqW+oeUSJh1ETqjBQlPgWWVabVeGi12O109h9/DebP/fdzzwFg1Znvqyi/YKlPdZk50nsUbfQKhoUsYJPFFKDmeg4V655WDnM68QEJjdh3zVcCFbayNEmPLbMkekGcJqJ2OoR7h98OCeDMgbKgavarBTxLtqvLjQG2r4UgGms4JuyQwLWmFgefQRF3aGWn1VrH2AACcXjIgbm1Jmb5ymlrlaL9UTi0bCqxBID4K4nT5U79BM5cUFtTswIyx++1f0k0C7RdyoUj5Y6lAE/hIaa/eYaIj7xvLMA7J8QlQJvUh9LruDxxP3ksM/zwHxlXV5EXr9MJQ0Z0b7tS9FLIQd0WDGJDKUsRwHZ0IL6SsIejiRaiJa8XVWzrDyw2kgKj08b2XcJw9z8of0FQmle7rQ8GSQ8Lf2c0xZosBqGiBPXOGuHdlCEYj7IbSmygB05YyB78YjT/LXyQDTCa7wh/5Drg+xLcnN/kLF7ZT/USqlU6c8AIctRHyZgBn1HlnHO/Pw9YKWBJu98rF2JLf0tX2cV4PvBtInP9zFSIVdQxsMLbCvIUq0OYAeSALxDdu53EVmy2ir5lwGVWu+d/L53epy86ZnpY90gSu1AjB+cDmGwmsgBYsvcQ/tl1Gl3bJ/CXYholDaL45TyWHl7a96g+vX3y80We37EQYXuQqYlRF5Sve/VTbFnzyYmocCvgLL2qiOjkRycxsImSqRCH96/UzgtXu9YzXyuz0LTtd9K/oXJzimdyZdvxbCr4iM0Vu6Aj22sGwhMnoaAxdnjJytD09U+mCgduu01tvH3G1fQ1qTWuSLdZ5NAVtGNwSOpBqDF2uLYgrDonrG4KSpko6SMyORKofS0GlAqFVXNOqGXHiRbakvKCneRzexC1DwnivyOfaPdDeB57HxdUDZes46crsEOPue6rezXUMxyY296w27byM2OcPJKDAUgkSQV64OhKFcn42n
 nGe946MU
 r7iDqm01uK0jNRS3snFTOObTfhR0lOE0TzO5s4k/TebICpsSf8rYIoYVpP1toweo7oBNKqnEG/NCiq8CCMBGRgkDc965TufIlekjpYs/9w4MPoxZ6VASvr7P0Z2S9gIPwlgIB8hEQbAwQLXVhmovhDq3EAEfi+oPI9XU0mlK7C3FwgmQM7P60s/zA4Dt3cFTS3YUwetZLt6alpYZnKnoV+ND/wfAZayWa5I2FXOui+4Tr3xy/s8QPCYRYjdifEdUZEAGAIvCUNfAD5dUvvI7YvjOknr+EJN3shTclVvJIPXhuKlcebb8GwERxOHuYfQ8dpIK0TJrwA5YPLfrBpfBkQylEDGztlGHze+ru
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/25/26 11:09 PM, Breno Leitao wrote:
> ghes_do_proc() walks every error section of a CPER record, and
> ghes_handle_arm_hw_error() walks every error-info entry of an ARM
> processor section.  Both assign to "queued" instead of OR-ing into it,
> so only the last iteration counts: a later section or entry that queues
> no memory-failure work clears the flag an earlier one set.
> 
> Instead of reassigning the variable at every time, just do an `OR`, so,
> if there was a single match, it will return "queued" as set.
> 
> The comment above the check says "If no memory failure
> work is queued", which is the semantics this patch implements. I.e, only
> SIGBUS if there are queue was not handled at all. If we want to SIGBUS
> if any event was not handled/queued at all, we will need something more
> sophisticated.
> 
> Fixes: 7f17b4a121d0 ("ACPI: APEI: Kick the memory_failure() queue for synchronous errors")
> Fixes: ccb5ecdc2dde ("ACPI: APEI: fix synchronous external aborts in user-mode")
> Cc: stable@vger.kernel.org
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>   drivers/acpi/apei/ghes.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> index fe10ab0e02f68..ec2d5ca51db02 100644
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -603,7 +603,7 @@ static bool ghes_handle_arm_hw_error(struct acpi_hest_generic_data *gdata,
>   		 * and don't filter out 'corrected' error here.
>   		 */
>   		if (is_cache && has_pa) {
> -			queued = ghes_do_memory_failure(err_info->physical_fault_addr, flags);
> +			queued |= ghes_do_memory_failure(err_info->physical_fault_addr, flags);
>   			p += err_info->length;
>   			continue;
>   		}
> @@ -951,11 +951,11 @@ static void ghes_do_proc(struct ghes *ghes,
>   			atomic_notifier_call_chain(&ghes_report_chain, sev, mem_err);
>   
>   			arch_apei_report_mem_error(sev, mem_err);
> -			queued = ghes_handle_memory_failure(gdata, sev, sync);
> +			queued |= ghes_handle_memory_failure(gdata, sev, sync);
>   		} else if (guid_equal(sec_type, &CPER_SEC_PCIE)) {
>   			ghes_handle_aer(gdata);
>   		} else if (guid_equal(sec_type, &CPER_SEC_PROC_ARM)) {
> -			queued = ghes_handle_arm_hw_error(gdata, sev, sync);
> +			queued |= ghes_handle_arm_hw_error(gdata, sev, sync);
>   		} else if (guid_equal(sec_type, &CPER_SEC_CXL_PROT_ERR)) {
>   			struct cxl_cper_sec_prot_err *prot_err = acpi_hest_get_payload(gdata);
>   
> 
> ---
> base-commit: 587858367581b9c55c3690f4e63382ad622719d4
> change-id: 20260925-ghes-queued-accumulate-591c8ac3b32d
> 
> Best regards,
> --
> Breno Leitao <leitao@debian.org>

Good catch, thanks for the fix.

Reviewed-by: Shuai Xue <xueshuai@linux.alibaba.com>

Thanks.

Shuai


