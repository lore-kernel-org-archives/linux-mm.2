Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 343F5FB5183
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 02:56:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BDEB6B0088; Mon,  6 Apr 2026 22:56:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96F1A6B0089; Mon,  6 Apr 2026 22:56:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 884D96B008A; Mon,  6 Apr 2026 22:56:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7AF056B0088
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 22:56:50 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3698B13B346
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 02:56:50 +0000 (UTC)
X-FDA: 84630247380.04.EE64E38
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf14.hostedemail.com (Postfix) with ESMTP id 33E7510000F
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 02:56:46 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=hpoMBAgb;
	spf=pass (imf14.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775530608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jDo6bFyo08dSfTXZAI9StL+3fyXHAaNYa9/ncq3oS4E=;
	b=oVFZ5aPJzg323UrB9+zC+mjk9Zjh3lXTYfJBb+ql6stmBZGzWkiR/lm5/biFpjVLtfZ9hN
	Uo8pXFqDP+3huxkn/OWiXVCJr3s6yIstVKLtXQhZg777kzfB70gOftO9OThwFvf5OhUfyZ
	+5N+G0e++FUMmtCLDikprXnLRWeY2w8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775530608; a=rsa-sha256;
	cv=none;
	b=Q0y5Jes/QGTJ33dCZXk76gSTF2dJ/0y651PXzzte+jPu3fYwpoYghjkDzUbLWqo/pgb3cI
	9aakkgZ+MvxTx0HsAvUSpQu7RfuZHJDja0cWdJ6G+YOPKOdKPXqCGdA8Pomh4dikABDYPS
	+pDPcjbTTvBX/GFPtfOeh+ohUQVLgwg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=hpoMBAgb;
	spf=pass (imf14.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=jDo6bFyo08dSfTXZAI9StL+3fyXHAaNYa9/ncq3oS4E=;
	b=hpoMBAgbzV/6RVSdbYqmy3rwQJL0KncgwW9CriNOaveUwpYL0YEkswknFuCP8TUavYdvk4Jo9
	FCSmxnfi/HbK9B8CMexEEO7N9pzqkE0d3L7Pp4fdDHNlCdvHDGpUz7POCGZNVxnTMy+0eGJRemr
	PkXrZGErpnFijZUpPiJ4KZw=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4fqW01467VzcZxk;
	Tue,  7 Apr 2026 10:50:25 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 9AE6640576;
	Tue,  7 Apr 2026 10:56:40 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 7 Apr 2026 10:56:40 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 7 Apr 2026 10:56:39 +0800
Subject: Re: [PATCH v2 1/3] mm/memory-failure: report MF_MSG_KERNEL for
 reserved pages
To: Breno Leitao <leitao@debian.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <kernel-team@meta.com>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
References: <20260331-ecc_panic-v2-0-9e40d0f64f7a@debian.org>
 <20260331-ecc_panic-v2-1-9e40d0f64f7a@debian.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <e074d5de-f494-4995-2521-32de4f2bd34f@huawei.com>
Date: Tue, 7 Apr 2026 10:56:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260331-ecc_panic-v2-1-9e40d0f64f7a@debian.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Queue-Id: 33E7510000F
X-Stat-Signature: jp3sagcigopf43rd8mty1p3bxcye97mt
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775530606-813819
X-HE-Meta: U2FsdGVkX1+aRtjHF5qGqdT1aO9UNhXiiXc6/DLZr2wiONlgiXs1pes6kFztyg5PsqCtBThJolaaP8QDjlG+IGejMjkrJ3OvHRfte84qYolvwJPPkR9AcRi43Gkjt9B/Gv33rVAqFyyPaWlWl3YHdOPVpr+TK090dXGvlmvmTNyI3rXuL+Gf1nCTv7yRFccxsOJYaDczDz8U/e5GIryU11Vqb9qOMJsIU9SSTz4YM7Zzpp8gnFWSVBit5yaY4L3pg4mLar7n+/I5Vjbyfr41LQBkECy9hJfeR0WYesgtayvJuG3BwQ8YnWoffPkGSQzu/RXy8xYg92OTP6YbulKlJacyQ2TWbbGGt4cQVA+WQmoL29NBIFXPuJwJfybeRzg7g/Cp8AF3nQg5/3ZaTpBngBNa/zXvRFGWhVdS1fuU95Kg3GAK3Ve3YSbYhEc2Kqgq6SKA94U+BRd6TNsVJpRQ9io3sOUtaqbRL6y1cqTYGbkI+MZdwGKWjQkrGFP0TI5IYinzUrZ74EibI4//QSxx5CBv6ta40MbTeS+pQ8fXRV151YQfPmNFW9yIYa57qm+4/BXVjIyLp/1ivX0dU2Qv0xLIR+GC9EJ1iv/eBSNNy/KnDlJg+CE51u7vcoE9DfHIi7ecRlzq4qH8EmnFuw/0lMMUGmSdiyxqsv8UrC467/zk92rbFZcl7ExEjCKxIWSSYU/fckzPbjk1qRL7HGLXRJ+kUF6sKw5M+L2k9yAJAGs30I70+fRd/rSBExhJgmxEWQsL9//kt8aDR8VXeX4AwfLV/tdy1XLa255UmU4uhqfszbPTGmPaViBHvyOMjc90CTss6xtSnwuor8nV4y9rCDYo8BwQVwitT7xM8yDyc50lCrvJsV/vZkW36BVRxbBZ22ktvbOcYOqLrH9QOz+h1/ZJTw5SPCxQDaBJd7I8gPbuHKzhsjqcCLvtSRZmv1iDN/mI9SyL5JHhX17tpcn
 beQlzNLC
 65EbZ27kOzFdpcyMCCDobAqf3TLVR+NGkp1QWVPeIRDwVtDcanydQL7NPX6cGmfB/hFnyLKp0btiY8qlq/5Kt6NSPA9YOlpmI1xJtiM021BHWDRUjKimI+ZxJItvXlry9TarJQBIH/hP5UiOFyNXptGbuibZOBkoSqfoOe9Dh3V0hbCTI7PeDbxgzQBTAEdc3m+iXWY6aMzZAcwO22nq8r/3cGHv8/F2fZwtk2ES2OTWNTjgnVCxjkrOSFa0DjQdMhMvPYJilyWdZC3sAPtQCfaT/EqI+Gqx3PEvTzOoR77taIOsCN4dZi+Nas+J5WkDJZV7L0x3B6bj64yw4wK+tKoojd9g7yxPFrRpMcQtr3/05uDhhR8ZOCFrhq284jeW/Cqi3xXvz1Zm/ixnSNI6WiU1d4ERvILB4TgkA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/3/31 19:00, Breno Leitao wrote:
> When get_hwpoison_page() returns a negative value, distinguish
> reserved pages from other failure cases by reporting MF_MSG_KERNEL
> instead of MF_MSG_GET_HWPOISON. Reserved pages belong to the kernel
> and should be classified accordingly for proper handling by the
> panic_on_unrecoverable_memory_failure mechanism.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  mm/memory-failure.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index ee42d4361309..6ff80e01b91a 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -2432,7 +2432,11 @@ int memory_failure(unsigned long pfn, int flags)
>  		}
>  		goto unlock_mutex;
>  	} else if (res < 0) {
> -		res = action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
> +		if (PageReserved(p))
> +			res = action_result(pfn, MF_MSG_KERNEL, MF_IGNORED);

Is it safe or common to check page flags without holding extra refcnt?

Thanks.
.

