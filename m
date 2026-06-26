Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E86D5CDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 02:09:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCDC56B00A6; Thu, 25 Jun 2026 22:09:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7F1F6B00A7; Thu, 25 Jun 2026 22:09:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A94DD6B00A8; Thu, 25 Jun 2026 22:09:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 81C316B00A6
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 22:09:10 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EB426C1A92
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 02:09:09 +0000 (UTC)
X-FDA: 84920431218.19.A110ABF
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8ABA7C0002
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 02:09:07 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf28.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782439748;
	b=YSOzIZTNxv7na7og773t8LH4xDIxs5KyfQCAYliYcfj70DOwjSHiJXW+gNQtKf82bo/q0n
	glctGTFXISfOXu9cL9k3ReUpMFcyYpRBsz0kk4mH2PZD6cSx5xDbyFGD/rzkMSF9T3DtJ1
	ojPkTpYeLB9L0y6povUcWNB918oGU7s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782439748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hnFT67NwC15YemOoHnvrF/QiXkTY5ssZlCnuSTgnkw0=;
	b=koZlZHVrYVR8Zni9dPZ+CaVm5kU3D+tLDXLCtoxvMIe4gajBLvUA3s/2CcbXC0r4ADDspY
	srynluevSljfy+Xw/JsNOJJii7eUCr6Cti1l8CRuEo9AYZYtGZO7aU7TdNWGreTbJar31+
	TQAkKbBcETFK2twv+oiIev8+rVaIt4A=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf28.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gmfHN2s5sz8Xrr9;
	Fri, 26 Jun 2026 10:09:04 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl1.zte.com.cn with SMTP id 65Q291n7062221;
	Fri, 26 Jun 2026 10:09:02 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Fri, 26 Jun 2026 10:09:02 +0800 (CST)
X-Zmail-TransId: 2afa6a3ddf3ef4a-cb033
X-Mailer: Zmail v1.0
Message-ID: <20260626100902993K04Lc3GM32AnCvCmzGequ@zte.com.cn>
In-Reply-To: <20260626013252.2846774-1-tujinjiang@huawei.com>
References: 20260626013252.2846774-1-tujinjiang@huawei.com
Date: Fri, 26 Jun 2026 10:09:02 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <tujinjiang@huawei.com>
Cc: <akpm@linux-foundation.org>, <ziy@nvidia.com>, <david@kernel.org>,
        <luizcap@redhat.com>, <willy@infradead.org>, <linmiaohe@huawei.com>,
        <svetly.todorov@memverge.com>, <chengming.zhou@linux.dev>,
        <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
        <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>,
        <tujinjiang@huawei.com>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2Ml0gZnMvcHJvYzogZml4IEtQRl9LU00gcmVwb3J0ZWQgZm9yIGFsbCBhbm9ueW1vdXMgcGFnZXM=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 65Q291n7062221
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Fri, 26 Jun 2026 10:09:04 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A3DDF40.000/4gmfHN2s5sz8Xrr9
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8ABA7C0002
X-Rspam-User: 
X-Stat-Signature: zwywdrd7bh8yq54yeifspa7sze7ig1kw
X-HE-Tag: 1782439747-54977
X-HE-Meta: U2FsdGVkX1+n7fyAlUOg0lqgh8Trw8WeTPrly25l2wioFKKpg06Iklv1AR3DnT1Zl81Q6MIA2mYApJURUwy+yojqSESRdPXeYdvg6YOdfZ9di7wwfxKuBFeMXTbwl85JuVJ9caDZxKmTd/VnAs26XWu+WmkD1WmnIyYXZPcYg58O+BtI8SycPCcnFVbZUOvnGuvFNcrHitWPcnWoTsFJSHNPceKkbpq6IUnjMnSwFeuvtWznevtqwPR/JF6Q4PxmVbhIWsv+neCMjAAfoGXr7pApaVH4b029EX5L1/DNzV1xCvd5Dw2q0rUAwNcjS7AyoMjKNV5HfV08SOSJn7FD/duMSWLv6yHeOmwLRNIZdsYZwmszTUIqVjcF3IuOL7TEMVk+DAqwoFhhTQIyuFoaC4HAXl+D8VIMKimngsJvibxk48SPFbCX228sm87+2w7ig9ok+NX+pmdhQFZacS8FQnjzCRZyw2GnLO0ilCuPGChAPOjFL12CNBxjG82WnJCcpWFm1LjbMH1FGDEPWZJyAWLHsVhDQnNm1lAryhrB+6IyXdBwrqBk7G71dowXzJ0N4bR11YLoJWekBqWW9mauQzJy6KORqYwyftJozvktrg2q43nBsZWBmJSm9OM0LJW9MW07vc9McrecjuEU4gZ8ZsI+aaZhrP+gGv9Ed10EiA2MlW92HTUBXAWneyCpMzvxxG5aL0mydyfhWOcNJaO0Z+fstvsb0AbnDGb44DuM0mQlJ8/pfBBRTcVBNAG3LuvVy+OeX3TJQWqNkreT9Z5NITJaB/g3WACoYCtJA7hXxylc1/xYKCT4TgcbF5G3+YLt2/ruxchrcIiXim4QgBhO/cS9V/juvoZx0iL5JuC6ZsDH0w7F4zWpRCkFfYYa6UGEojULaCM51M8k3vXPMOIt/R/1sQeNoKua/MppAYddwc/pSfR18vWXQDZKxd37WFD+Fwxjxtd10kVDXHUfnjD
 QUU6FbHv
 jCy8fZP9zta+duMc7I9IzY2fcRBxUQ0VGEP9J6LmPF29CXuYPH6yyBxkJjzk7uOc1f9io8YImI/HvRE0++vLi0p2iCRRp+7paSbZO7G7xX+/dQdg/u9887gNm/wsevo6rszqeMe+le1DiZa2q5UTZkbKkKh17gofSRsq2lQR/36JyWPFYX1SaqgOJl/OG8CWqIu2BhvLz+nvtZBS3ZzzV5IiA574Ch599gpH+NCkuuKf2MZY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Reading /proc/kpageflags for any anonymous page returns KPF_KSM set, even
> when KSM is not in use. As a result, tools misclassify all anonymous pages
> as KSM merged.
> 
> In stable_page_flags(), if the page is anonymous, then use (mapping &
> FOLIO_MAPPING_KSM) check to identify if the anonymous page is KSM page.
> However, FOLIO_MAPPING_KSM is FOLIO_MAPPING_ANON | FOLIO_MAPPING_ANON_KSM,
> (mapping & FOLIO_MAPPING_KSM) check returns true for all nonymous pages.

"returns true for all nonymous pages."

should %s/nonymous/anonymous ?

> 
> To fix it, use FOLIO_MAPPING_ANON_KSM instead.
> 
> Fixes: dee3d0bef2b0 ("proc: rewrite stable_page_flags()")
> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
> ---
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

