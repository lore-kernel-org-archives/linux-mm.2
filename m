Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D3F1CCD1A5
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 07:44:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA08D8E0049; Fri, 24 Oct 2025 03:44:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D284C8E0042; Fri, 24 Oct 2025 03:44:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF1C68E0049; Fri, 24 Oct 2025 03:44:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A8B4D8E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 03:44:17 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 61108C0DDA
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 07:44:17 +0000 (UTC)
X-FDA: 84032219754.09.B71B395
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by imf06.hostedemail.com (Postfix) with ESMTP id 36364180006
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 07:44:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of linmiaohe@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761291855; a=rsa-sha256;
	cv=none;
	b=mjSOUey6yeON/Q2F+ya+ChdMgO11mvHKI598uyRtZSj1Nm9O01ylEE14GT8pa/0gZMYUBb
	eu+PXr1+MEbgXVpLjDFsipZaUHAuix8stgDLinUHH+P2x2+iSZhdT7scU2nV3KXMVTJfeA
	vzKweB9GvqRuqrg+UP2B0jwKlE7adbQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of linmiaohe@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761291855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rulU+unUCqrjU3BR5sVJyXLG2vkLgdcaRwHM1Jnddl8=;
	b=b2llEF/Xy8S/GUBMjwi7eE/5QPTjFY8fhzyi2spGuoW7/JahNMHhO4eG3VxKW9b+Ljc9Ot
	Et76rQysLpd2c688rSS4wkgwdmEvHrvz6hmguUP6e1v1L48fwz04KaMhHhBXu+jha1vpjT
	2jRBLXrAzfvr82NOWCSC273utFVNvy8=
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4ctFCf6wB6zTh71;
	Fri, 24 Oct 2025 15:39:26 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 02B23180B62;
	Fri, 24 Oct 2025 15:44:10 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 24 Oct 2025 15:44:09 +0800
Received: from [10.173.125.37] (10.173.125.37) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 24 Oct 2025 15:44:08 +0800
Subject: Re: [PATCH v4] mm/huge_memory: preserve PG_has_hwpoisoned if a folio
 is split to >0 order
To: Zi Yan <ziy@nvidia.com>
CC: <kernel@pankajraghav.com>, <akpm@linux-foundation.org>,
	<mcgrof@kernel.org>, <nao.horiguchi@gmail.com>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, "Matthew Wilcox
 (Oracle)" <willy@infradead.org>, Wei Yang <richard.weiyang@gmail.com>, "Yang
 Shi" <shy828301@gmail.com>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<stable@vger.kernel.org>, <david@redhat.com>, <jane.chu@oracle.com>
References: <20251023030521.473097-1-ziy@nvidia.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <479c9b79-a8a3-6e14-9264-cda3e9851b43@huawei.com>
Date: Fri, 24 Oct 2025 15:44:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20251023030521.473097-1-ziy@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Stat-Signature: d81x9s1p5qnm15cbfunpmx5cgrogmm59
X-Rspamd-Queue-Id: 36364180006
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761291853-383210
X-HE-Meta: U2FsdGVkX1/zyB+b8CKF3psOm2/rtBYhs70+5Ln3YPXJRi6cW8fEWYMuf42CiuANA69vmDH2asL61ocs0eJTku5KRuR49kyxiFGtaf0aV9TLYlimRTmg2JfG54xt2fRLc2MBTc9wXzL4M4mZeYCmn7uJVLUKvhnTe/X2HgD5C4o/zdIu5Ty7LQMKclrT7B+IsYwhujvCUiVPRfoTPmMj3bTvlyhxuBRCjM6lrAlmFimuV96Gk4ZIA+MECYTRY7bDmtj2tu+Nw1jpAslriXNvWh3aN2dRsUXgOTyp9gVidgHpDh+69498C8g+cZ2H4g1ZH52mclYf+lgrC1van/OLsihcO1wpoadunv8Er8XlAAC7IIDP/4kAdK6YwVMt7RVQLbb9F9L160OHPr8xsv3+z8PYg+KjCVLvguvyIHA/ytTWnDrDnYJkyf7XcuNJFR38gLk2nk5I1zC7zX8kXnSfYiK8BNVS/ZXmgkUqJNLgzCpC06gKQ1dZlmtwNWrcRgt2MrLHkZTI/0I4977nbsOdZFKAg5d2kwwVRvBbt1GUScKuoGe0NssSfOmAI0DNbKRYTJ3a+xrTGpKfH2e6VP2fuZ1fHy5SFfTdsqAV9NMx2YmxaP4VQt1UbuhKCWvg6BiMRNYBNXzW/Zl2f3iJQR4AqLGYgJ5udQHOXGcQVlaTZWn3D9B8k6aKS568PJESdBN5iRaak60wbZc8lkdk0fykou4fvwGBw8GgNCQ6d2N4piIEBlfmp4Kg3QafCgMEVMhk/zJ6WHo38SWHsEDgsUoJimV3e8B4DW99N24NiMXRTI7oygIRcJwEKIDC+HVNeCxPJu3oGAYerh5xLOj/fFrhig67STwGcdkNQ8VTKJV+65yXZSQ3hW15iZyrTk6bDBCW4eYt5rN98r14s7OLGSg9drf72SlHZX5KLTnMtSudY3yN9eNw1J06U4v1xpKmd0AGyjvTLi025v8S0YrWDar
 bZG+eTJu
 mjl+SwIPi9RMp/CaQ74Sm59T1SG+X/YI25+/8vsc/u1rLbdp6l3H1r+4rdSQgiOsk1mpBohCcURO+F7YLRNQtXa5EhSxkNybkkYoitdTqOSHqQvugrOGxAQJJ7NkcmsYKh2yqgycPw5VrOoEN+GXrwiGZPVNPd7Jng9JQs+dbGCNoZc/jxQahHqr2mjXaQ3r+BcuMu+S9DoogipZx69Tqte6bNuxCFLPfdDyInQvkcRXYRf1n5Aj5NCQ57FJawLA0tLeSbD4SSGm8DfafY4zH4qkqwVReqZsbYLe/YwmJ3R9U0/rZ9VrfV99FkPp2xLrWSbECboE+ba+zaEhwmg4tPxjPTKHMz3ziL5xX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/10/23 11:05, Zi Yan wrote:
> folio split clears PG_has_hwpoisoned, but the flag should be preserved in
> after-split folios containing pages with PG_hwpoisoned flag if the folio is
> split to >0 order folios. Scan all pages in a to-be-split folio to
> determine which after-split folios need the flag.
> 
> An alternatives is to change PG_has_hwpoisoned to PG_maybe_hwpoisoned to
> avoid the scan and set it on all after-split folios, but resulting false
> positive has undesirable negative impact. To remove false positive, caller
> of folio_test_has_hwpoisoned() and folio_contain_hwpoisoned_page() needs to
> do the scan. That might be causing a hassle for current and future callers
> and more costly than doing the scan in the split code. More details are
> discussed in [1].
> 
> This issue can be exposed via:
> 1. splitting a has_hwpoisoned folio to >0 order from debugfs interface;
> 2. truncating part of a has_hwpoisoned folio in
>    truncate_inode_partial_folio().
> 
> And later accesses to a hwpoisoned page could be possible due to the
> missing has_hwpoisoned folio flag. This will lead to MCE errors.
> 
> Link: https://lore.kernel.org/all/CAHbLzkoOZm0PXxE9qwtF4gKR=cpRXrSrJ9V9Pm2DJexs985q4g@mail.gmail.com/ [1]
> Fixes: c010d47f107f ("mm: thp: split huge page to any lower order pages")
> Cc: stable@vger.kernel.org
> Signed-off-by: Zi Yan <ziy@nvidia.com>

Thanks for your patch. LGTM.

Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.

