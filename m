Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82EB5C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 07:50:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BEEB6B0005; Mon, 29 Jun 2026 03:50:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 347CB6B0088; Mon, 29 Jun 2026 03:50:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EB3C6B008A; Mon, 29 Jun 2026 03:50:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E900E6B0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 03:50:46 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6F50B1A0433
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 07:50:46 +0000 (UTC)
X-FDA: 84932178492.13.ED411BA
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf19.hostedemail.com (Postfix) with ESMTP id 17D4B1A0011
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 07:50:42 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf19.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782719443;
	b=K5fumDeQC/OqaVXh4Gzy4tiUkk+auFBV5g6yv2zdVtiBE6UX+Em6Dyn5plLC69URLZ0M9y
	Jnl5mll1VzI/Wj8VTadgv7E9dLkINzijw5LsprPwXK/jfQ8HMySEMyWGBPlL/wtGyiMb4Z
	MCHnKZEaktvhMgpj2qTptLYTvovQFnk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782719443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LSUdgpdqtlNB/WdwxcpWnLs0sjH/WBnCk8LHsKNDL0E=;
	b=cCBzF50LOZJLfXEwnZJxNZcTeuAm84SXBxbZM36smHWrSjmziM5oNWwbwk6GgY+wGsl3f/
	rPjV/EpjsJjl9SmmCU4A6wrStQICkRpoGbHIVu9Sxi5YbMVUD+T2sD2wGQr92T4W+vpjiN
	jeUyAYtLpByszgLDA4/uPkkSSv+iiJ0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf19.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4gpdjw2Dn4z58fdM;
	Mon, 29 Jun 2026 15:50:28 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl1.zte.com.cn with SMTP id 65T7o4VA056669;
	Mon, 29 Jun 2026 15:50:04 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Mon, 29 Jun 2026 15:50:07 +0800 (CST)
X-Zmail-TransId: 2afa6a4223af016-ff81d
X-Mailer: Zmail v1.0
Message-ID: <20260629155007041-i6ON_Yq8sJs3QymHqB9q@zte.com.cn>
In-Reply-To: <20260629033122.774318-1-tujinjiang@huawei.com>
References: 20260629033122.774318-1-tujinjiang@huawei.com
Date: Mon, 29 Jun 2026 15:50:07 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <tujinjiang@huawei.com>
Cc: <akpm@linux-foundation.org>, <ziy@nvidia.com>, <david@kernel.org>,
        <luizcap@redhat.com>, <willy@infradead.org>, <linmiaohe@huawei.com>,
        <svetly.todorov@memverge.com>, <chengming.zhou@linux.dev>,
        <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
        <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>,
        <tujinjiang@huawei.com>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2M10gZnMvcHJvYzogZml4IEtQRl9LU00gcmVwb3J0ZWQgZm9yIGFsbCBhbm9ueW1vdXMgcGFnZXM=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 65T7o4VA056669
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Mon, 29 Jun 2026 15:50:28 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A4223C4.000/4gpdjw2Dn4z58fdM
X-Stat-Signature: o5a8ndnamoj6im8auckmhuu3b4s9q3im
X-Rspamd-Queue-Id: 17D4B1A0011
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782719442-372712
X-HE-Meta: U2FsdGVkX1+jse2CMTolBA4yPW2cgopAnEYCOUF0uRPfQ8lb5MetHlU5K3nbSPekND9w+INVBHbke2KcWQJtUFA7S+U4hEqhodBbzlkEI8jNqvJf17gA4akMQSha3gRjBD+OjxnMSfnTH0CR2Sp5tkbMufErhyleypgPw2K0y+sabivL19JF///LD/j9Vf2rqTsbVbYHeQpjlUQkoyMk3qtXU9cUykr2O9YqEnATf7hQ+rItnVCLSFXhLvbsbSBjzqDlmDvYp+tnq+VQldyDYJawVYfzm3dHlfgEAZl3gSrihq6NaED5O2Q3iA2iybsty+Dk9Lv4CUXjbz4r27TgAI/afBy3Z/aR6mMLfu5oMviCIFde3oPjf2ZpQW7uw+14u7TafzugfT6H75nm5MgIAX+oS+gkQeDJFM//rLkNwtQoFsrKLmq9sbxHpmsknMHsUjFl7AkyAeX7pn0LClKli6yBrapk1LmnrskKST0xKcbOTP7QpAJ+2Q9FxZJuZDhN6k6lWNoX2eAiKuIVnbKLKk0mWEyP7WjnJpo+YPiWfI8APVCKo8n3IWdg7VkPgw5/vUDXCY7lATJIpZEkITSiUrhF6Km+QS5+k9if2/zn2mUTsk9WLCDaU+5rxtb38xC1sKut2w3ZJboCmfUJe3QVqEt0rGBGLeF3ioXB0uVhryNSBGte4N95LdXY5kuerTmqjf6fTJeBFpARQEP854USy50Y7494Fwx9Yb0GouS1Ww64+BiaViV8T72MM+v4repMZdafhrvPAtRI8TeBMh55KblWrizuZNmfsNzGMk2VSglEsD51KRkzPhagCpGE5W2WGFbQkAmFFWvvJcKucffZZaVWImFc+H+ytMUKRbwOcApsmsN1BKXCzzh6RS7ojHF4l3QEsVBkJPdNMo9DQSYb6Fyly1JSAU2eLeoeLZE+CzJOxTCOTlOMbP8QtIeYF8Y1WiPWTT2XUJw/cvppQRQ
 3NVZKpW1
 09li8r9c496VsOko+ZGr923vH7hQESVBOoVnckmDbNY1EjFolGliWuPwLyX5zL3yLv3oIQZ0bKegGGUjYR2eREhlXM7QnmbXz7C2UQRN22kQ7uC/v/luQOHI4wwg+7isahb2OJzHJVCxhRt+8CwDTmn2TvrsYKk6Fxa4paDG92spD3lm358S0ZgtttYeGo+ry66AmKCYAEi07S3tMjrYot9fVINnl16xAh7ipdaROWEkXgCT2euqg2OT1HAyNoseNAVqNdmNj5dW+Xo8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Changes in v3:                                                             
>  * fix typo.                                                               
>  * add CC stable                                                           
>  * collect Acked-by.
> 
> Changelog in v2:
>  * use FOLIO_MAPPING_KSM to match explictly instead of use FOLIO_MAPPING_ANON_KSM
> only.
> 
>  fs/proc/page.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/proc/page.c b/fs/proc/page.c
> index f9b2c2c906cd..7d9387143435 100644
> --- a/fs/proc/page.c
> +++ b/fs/proc/page.c
> @@ -173,7 +173,7 @@ u64 stable_page_flags(const struct page *page)
>          u |= 1 << KPF_MMAP;
>      if (is_anon) {
>          u |= 1 << KPF_ANON;
> -        if (mapping & FOLIO_MAPPING_KSM)
> +        if ((mapping & FOLIO_MAPPING_FLAGS) == FOLIO_MAPPING_KSM)
>              u |= 1 << KPF_KSM;
>      }
>  
> -- 
> 2.43.0

Reviewed-by: Xu Xin <xu.xin16@zte.com.cn>

