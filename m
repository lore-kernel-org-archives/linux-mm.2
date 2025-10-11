Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E52ACCD184
	for <linux-mm@archiver.kernel.org>; Sat, 11 Oct 2025 09:08:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9FFE8E003D; Sat, 11 Oct 2025 05:08:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A50DE8E0005; Sat, 11 Oct 2025 05:08:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93F948E003D; Sat, 11 Oct 2025 05:08:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7FC548E0005
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 05:08:03 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EC5D387C3D
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 09:08:02 +0000 (UTC)
X-FDA: 83985256404.30.24A246D
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf16.hostedemail.com (Postfix) with ESMTP id 62F7F180005
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 09:07:59 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=dXgfOpNZ;
	spf=pass (imf16.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760173681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9jpEyMrd3vnSjR1xZsepMLlxr22S8g5uYtrOEpK8mUw=;
	b=iim+xVM1cq2GbYw23hu8pHjJnD/BhxOtns66m9dsP+9oviajMjt1U3kTQjaVBlPnZHpnMY
	Fnj6u8PJuw25YYEMF23B9fWAfNcHC7Ugsq2hBkrvAtTAFpqJ91i9Q/tZ5hlNJ9COpkKbTN
	opsUnLjz/9OnjfjwmbEt8tLv2XXm2Rg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=dXgfOpNZ;
	spf=pass (imf16.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760173681; a=rsa-sha256;
	cv=none;
	b=6VsxYyzjYjiqZ/gR81h6et9en7tVE53MY4TsGLim5Q1kIDeBJn/Dq4Jfn8cYG3CnGkX2v6
	ku3uyT7Q58Xurvmr+4Ek80y/o5arRnKB/nKlNY6xMubklhpS5IsN6tswVVstNcHdm2ustM
	v3IKUYFfIQcd+peV/6PnXoN9K8RMPGc=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=9jpEyMrd3vnSjR1xZsepMLlxr22S8g5uYtrOEpK8mUw=;
	b=dXgfOpNZIKxIEYfectR6rgBEK/xShe6Oqk8o0P9ZQhY5AT4FV2gWS2vwPs9xIQ2R0nKmQujlq
	K37Ww7EE9AcBEwU3Zx88CXnZ3DF9I1rXF/TpyIUnnHLFBNCZGYt6sdM2rxVEybQdNTCZcYDlANo
	bKX7s35pF2/5G1Pvgglyi80=
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4ckHmq1wxHzpTKL;
	Sat, 11 Oct 2025 17:07:07 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id EEA0C1401F4;
	Sat, 11 Oct 2025 17:07:54 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 11 Oct 2025 17:07:40 +0800
Received: from [10.173.125.37] (10.173.125.37) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 11 Oct 2025 17:07:38 +0800
Subject: Re: [PATCH 2/2] mm/memory-failure: improve large block size folio
 handling.
To: Matthew Wilcox <willy@infradead.org>, Zi Yan <ziy@nvidia.com>
CC: <akpm@linux-foundation.org>, <mcgrof@kernel.org>,
	<nao.horiguchi@gmail.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
	<Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
	<ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <david@redhat.com>, <jane.chu@oracle.com>,
	<kernel@pankajraghav.com>,
	<syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com>,
	<syzkaller-bugs@googlegroups.com>
References: <20251010173906.3128789-1-ziy@nvidia.com>
 <20251010173906.3128789-3-ziy@nvidia.com>
 <934db898-5244-50b9-7ef7-b42f1e40ddca@huawei.com>
 <aOnkUxWPODofUnRy@casper.infradead.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <35d00740-0aa4-1d6d-87b8-ee973bcff792@huawei.com>
Date: Sat, 11 Oct 2025 17:07:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <aOnkUxWPODofUnRy@casper.infradead.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Queue-Id: 62F7F180005
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: qjajkxc4q5prsgae8zfii8yips7bcg9x
X-HE-Tag: 1760173679-465546
X-HE-Meta: U2FsdGVkX19AKPT7xH0p03HqxZtaFFY/civkvTayixwyBqicX68SdNwfgOqU+iAq+uBDwNDbikmp6/vHZAkejFe2dAZawI5zcjHXIwm48Ei9ErQ2RvpcflqOeru1dTngcrsSjOujwmuygqKEc4sCcDcZHNfGxoF8VXu+hU0LDD97C/G3FX0kLUb+GVmcmadR8SzK8Mq1VdhJX7d47wv+0aWB+EyoPyJqdYDVt0SFV00ccjVIOQ/wFLkx/Gc5hoJ4mi1++mz0Z+SeijFhgdFGAhC9kA79gJV30LoPw/QayqQvgB9x7kuDUMw9kTjV9tcjoe15n+CUw1pMrElFuo4/28S1VdgqSeWiFwVp/rDWwkvKSTi3GRlmIXSeF0J/q1A5cdgdW3Y7QsWI+yCqdxEVvyhe3PB1HUQJczn8o77J2NbktOThxCYdHqqcWUeD5cbyY4BGLKufK5tSRdespucKpHZVTrJvUFpcnRBo1GKdk9jhyNu9w2T3BqL06PqKEYNvHbQ1c+HDp4In9gUVX+6SfWr5L4QSPCt2eozZIF+RplJnIFiMjAFuBYws/iSUfec94c/+pBr495iSVVRQ7f8MEtg5nIbtSXFPKoC9wvzv+8Ssc+h5QR5mKZppiQ2WB7OXMlWI2e3zFz9Sdu0vhlGpYNxxxUC7VyiSlwSegHK9POEnJwITp8IMOjJsPNYoRXrUc9cMhqtauB0N3c51DZIazuJsGhlQtM8NfrkslT4ceqJXk29LOlMVljc9OTMsI6GocUdrIaOKfwxQOrTJQbBJSjh2jhSAZCxJOw/Qds/pHXIU/dHryg5dP17wZUQtidJN/VPBdRAA/AgQbZklJ4IzhgbEUNV2jljIkm/RiljwISn1JgXXL0bOoe/DHVGtzetcBv2EUQ8VX8KoYI7O3omUi4Yg2HDUN8eI+ERZIETR8CjEZWi/5XXbMpkWI2Z98KwJn5RH++rsLLa5Hahx0Az
 2BzGrwpI
 HGTwPvpD+5RQ/1ZvoKtIoCg5MPTa4b8p0Y3EFr0DTB2R3svk80LmHirtwrXOZLj8cNap/Da9rS9CVWUo3xRa/0Dbwui70zBHEk2v6ehlK3YIhBqEb/YAY06pdfFdOXuzeYZhMU6MEGxCZHoy9nbHXxgJ0t7kPfWRvUdHnph05VFneJZe40vYzl3dSL7ZXRHSHC2nJhHrQvjobPiNvJWzNV29LjIr1KEx6n4qwDoU+A95gSyy1JOimn0pWo53U5vMHKduLolhf0JIx821eBtPLj2LIZ1N3ZHiuChC48c/wRvdQowLJIZxzfVTrEbyAOVGKJNUwcTtLAtnE61eVSAh/R9pwhK8kyEHEqODyk+ueh98ZuJ+Kg95nSVTGEA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/10/11 13:00, Matthew Wilcox wrote:
> On Sat, Oct 11, 2025 at 12:12:12PM +0800, Miaohe Lin wrote:
>>>  		folio_set_has_hwpoisoned(folio);
>>> -		if (try_to_split_thp_page(p, false) < 0) {
>>> +		/*
>>> +		 * If the folio cannot be split to order-0, kill the process,
>>> +		 * but split the folio anyway to minimize the amount of unusable
>>> +		 * pages.
>>> +		 */
>>> +		if (try_to_split_thp_page(p, new_order, false) || new_order) {
>>> +			/* get folio again in case the original one is split */
>>> +			folio = page_folio(p);
>>
>> If original folio A is split and the after-split new folio is B (A != B), will the
>> refcnt of folio A held above be missing? I.e. get_hwpoison_page() held the extra refcnt
>> of folio A, but we put the refcnt of folio B below. Is this a problem or am I miss
>> something?
> 
> That's how split works.

I read the code and see how split works. Thanks for point this out.

> 
> Zi Yan, the kernel-doc for folio_split() could use some attention.

That would be really helpful.

Thanks.
.

> First, it's not kernel-doc; the comment opens with /* instead of /**.
> Second, it says:
> 
>  * After split, folio is left locked for caller.
> 
> which isn't actually true, right?  The folio which contains
> @split_at will be locked.  Also, it will contain the additional
> reference which was taken on @folio by the caller.
> 
> .
> 


