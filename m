Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E7D4F55438
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 01:58:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E71086B0088; Tue, 24 Feb 2026 20:58:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1EE26B0089; Tue, 24 Feb 2026 20:58:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2B8D6B008A; Tue, 24 Feb 2026 20:58:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BBEEA6B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 20:58:46 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5C9BFC1BAB
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 01:58:46 +0000 (UTC)
X-FDA: 84481320252.02.1EBAEE1
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf22.hostedemail.com (Postfix) with ESMTP id 217B7C0008
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 01:58:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=t2qO04CN;
	spf=pass (imf22.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771984724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VeJ2O0BCo2zRU3gLWZ9ftz4rdNgg/fYFySx32YQqD44=;
	b=2m4XHfGOdV33X62T4KrSMarXE3bgcm8sITCdRCU6gjRdNHRkcBPe7lXfp+4Ag2rZj+C5i7
	IFwy5CRWb/kpRS+FvRB94/N3i0Ll+9S4LLb2bFkybnRNGJkK335C+yWac2fxuw+FwmziOb
	SUTjhoObmpYw3XWQJJfpENQcHOIOFd8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=t2qO04CN;
	spf=pass (imf22.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771984724; a=rsa-sha256;
	cv=none;
	b=oBY8H93DlLNoNWV+gz0Ohnbf99N6YIaueSYUNV02YIazedU4x03CP1Xny3AN1x+w6czJQg
	WrXo81uADUWsczdgz3+tsOO2KeixQFpsz2faimxlacGilYa5UHCcF+2+cQJMS1V8vaHOM5
	qHD2xoGo88Cd5Rv4qmrxBcSMmAp1DuY=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=VeJ2O0BCo2zRU3gLWZ9ftz4rdNgg/fYFySx32YQqD44=;
	b=t2qO04CNU5gpKQcCx06GBeGbLXlyCEH2bJQDjYG/7R4my6bS3EJmloDAmRTvbccBYrjsj6Qv4
	/uWld0n23lYwINN31oMWUYyt4t/HBmg3s7EwcXSsgXNcFGwXMvk0fYSBQqOkV8v/lmYnQO3zNmP
	xzwQ+85o/ZI5kmaXqA1SdvY=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4fLHgf6qtgzmV8C;
	Wed, 25 Feb 2026 09:53:50 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 8C95740562;
	Wed, 25 Feb 2026 09:58:38 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 25 Feb 2026 09:58:37 +0800
Message-ID: <4b219cd0-9391-4edb-83c0-b6a1c60d0790@huawei.com>
Date: Wed, 25 Feb 2026 09:58:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: mm: Regression with v7.0-rc1 on RISC-V
To: Zi Yan <ziy@nvidia.com>, Ron Economos <re@w6rz.net>, "David Hildenbrand
 (Arm)" <david@kernel.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-riscv@lists.infradead.org>, <jackmanb@google.com>,
	<jane.chu@oracle.com>, <hannes@cmpxchg.org>, <willy@infradead.org>,
	<muchun.song@linux.dev>, <osalvador@suse.de>, <sidhartha.kumar@oracle.com>,
	<vbabka@suse.cz>, <claudiu.beznea.uj@bp.renesas.com>, Mark Brown
	<broonie@kernel.org>, <akpm@linux-foundation.org>, <pjw@kernel.org>
References: <1b17c38f-30d3-4bb4-a7e1-e74b19ada885@w6rz.net>
 <13b8d60d-1209-4650-9fa5-982381c53512@kernel.org>
 <1966378802.577797.1771952827516@app.mailbox.org>
 <78D36EC1-2596-448A-A939-0A1AC7B3D1BC@nvidia.com>
 <1AB3E96B-F4CA-4B00-9078-2AC20A1A60DC@nvidia.com>
 <272A58BA-445F-46F9-8DAB-D82E43D7771A@nvidia.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <272A58BA-445F-46F9-8DAB-D82E43D7771A@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Queue-Id: 217B7C0008
X-Rspamd-Server: rspam02
X-Stat-Signature: x7oieioamump6zeo8dxqw9s69bwwndip
X-HE-Tag: 1771984722-253547
X-HE-Meta: U2FsdGVkX18dpuC4M9/ydSCTOe99R5c2IEXBJPO31myf/ETYZ9CnSA1DygnPMvqaDn4kaM173ZBenGoW8IREi24ypfBRDfnvYVDYD9Gc0AD99Y+AHI6rLO/Kg4wXK9KwpR9wlBT2nMHnG9LCsm9RvB0ca3wfah98OqLvcbYqnoDzVI7+Caf0N0y/DWgztAPxkyx6tjMWuTRCkLNnLiM5FRVTkHhv0wWwhk7/o9tg0/QksI2jLhnOOLQdTtjpJhK//laE0aYjyp2EvcR/DN1zbWhYfFHQp579bnikGneh/frAzms8Qp0dFxBv6UNTDAO2YVtRQZpn0kgx1/ukUBoGL7xLaD2OCxuYWRzF8voKNz8Nluaz2eq9OE+wdafsJVR7ywCywoUa28CYf4JfOcOwNHI/P8JZTQVM4cOPJlRHlS44T0W7euVUWlle/Sd5TsjIiHVW3AMFUJOUzuPOlo/YG42RrGVPDyWWO3JtIDDGpsGPDCuOxJRfAC9H1IwzoUzXgQzcMAiOomyH/INSCHUUJLiu2ZZB5xeSbnXRdXJtiPpwduzb0i3WacKkE9mSoshj2Qj1TFfU/+XpTuL3uWziwNrcqGu4JO1EO20lUsmZIoaUJIeM7MST5ttBagLsE7mV3YViRqr1t20JhburRji5zfypHBWfCgSeumBIXyQQ9xR1tEbc6QxMzit20tBZGuY9BFX07QIWcN7rcLH4+7mMjtc1hE+YXTnz4I16zmi0NziNqee/lj01qVRzN1QQvTAQ+ELMBD8EFujhxZonlzTWXbawgnygMrF9w1p87LAuWg0cpPX3M+sScSiKoueZgRHbwmdkNFX7wu+J/HtGrDXZB4Pb5RUgAmBexq4Z4j6rYw6Ofq69YjUOfCdyBdHD7sB9nXOuhLcaUOmq58R70XqTQ79VA8sqvHaqITGyG6ivlP0D1YJXc5kXJLMt8XVBKHFPx+MWUl1JCuGUk+oDvD4
 kYLOTfmv
 Ynw/ff1Nz7vTyl/Tuw/BKZh6IRCmoxXnDcpuwMLCL60x8d+Pz24OTrm7wW0oUvU0Dcv62v2mVP+9lA1NmbuQ7ip4o8fRRxN5B2Kyu3VonWX802qRwhpTBwScYrFs9Q5zQWmfP443PSzQ4YR3s+H8/AS6V4ea/tJm0+IF25thSkmNh8FiAs16hDec0fPvG66UiOU/cmc+wY3Y+jITWEjGoTPLd+zkVw26xTAZXT69CoZvA7IwBV685kGDuOwbAv+dg5qyw43/9fWih1IgHliA/9qO6SBvagdC4JHGdQ9hHWWOEEWMFyB5+UD+Zax0lH4kauQoHEweH61bc5Y2LSNniuXkhsPVtjmG/LgqaeGMh7/jBZ1RjpVJ96gNijh3f3Mt2ybcpBfdNd19IA3MLCDk01TAJRJKtjov0RjlZHDCF9ECuQT4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/2/25 1:29, Zi Yan wrote:
> On 24 Feb 2026, at 12:17, Zi Yan wrote:

...

>>>>
>>>> Thinking again without my computer at hand … isn‘t the call completely optimized out without CONFIG_DEBUG_VM?
>>>>
>>>>
>>>>
>>>> At least that’s what I remember.
>>>
>>> Right. Without CONFIG_DEBUG_VM=y, VM_WARN_ON(!put_page_testzero(pfn_to_page(pfn)))
>>> and is_check_pages_enabled(), which leads to free_page_is_bad()’s
>>> “page dumped because: nonzero _refcount”, are disabled.
>>>
>>> It seems to me that someone else bump the page refcount between
>>> VM_WARN_ON(!put_page_testzero(pfn_to_page(pfn))) and free_page_is_bad().
>>>
>>
>> Merging Ron’s reply from another thread[1]:
>>
>> “Something strange is going on. I enabled CONFIG_DEBUG_VM by itself and
>> the issue went away. Let me try CONFIG_DEBUG_PAGE_REF.”
>>
>> Looks like something is racy, since it is reproducible reliably.
>>
>> [1] https://lore.kernel.org/all/30dd1efc-9bd9-4664-999e-610d181600f9@w6rz.net/
> 
> VM_WARN_ON() is BUILD_BUG_ON_INVALID() when CONFIG_DEBUG_VM is off. Only
> the validity of the expression is checked and no code is generated.
> So that put_page_testzero() becomes a NOP.

Indeed...

> 
> Hi Ron,
> 
> Can you check if the patch below fix the issue without CONFIG_DEBUG_VM?
> 
> diff --git a/mm/cma.c b/mm/cma.c
> index 94b5da468a7d..96be62eb3713 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -1020,8 +1020,11 @@ bool cma_release(struct cma *cma, const struct page *pages,
>   		return false;
> 
>   	pfn = page_to_pfn(pages);
> -	for (i = 0; i < count; i++, pfn++)
> -		VM_WARN_ON(!put_page_testzero(pfn_to_page(pfn)));
> +	for (i = 0; i < count; i++, pfn++) {
> +		int __maybe_unused ret = put_page_testzero(pfn_to_page(pfn));
> +
> +		VM_WARN_ON(!ret);
> +	}

Maybe we only warn once by adding back the original check?

diff --git a/mm/cma.c b/mm/cma.c
index 94b5da468a7d..a73a22d34232 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -1014,14 +1014,17 @@ bool cma_release(struct cma *cma, const struct 
page *pages,
  {
         struct cma_memrange *cmr;
         unsigned long i, pfn;
+       int ret = 0;

         cmr = find_cma_memrange(cma, pages, count);
         if (!cmr)
                 return false;

         pfn = page_to_pfn(pages);
-       for (i = 0; i < count; i++, pfn++)
-               VM_WARN_ON(!put_page_testzero(pfn_to_page(pfn)));
+       for (i = 0; i < count; i++, pfn++) {
+               ret + = put_page_testzero(pfn_to_page(pfn));
+
+       WARN(ret != 0, "%lu pages are still in use!\n", ret);

         __cma_release_frozen(cma, cmr, pages, count);



> 
>   	__cma_release_frozen(cma, cmr, pages, count);
> 
> 
> 
> Best Regards,
> Yan, Zi
> 


