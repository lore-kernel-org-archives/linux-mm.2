Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD3F4D7879C
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 16:19:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3944E6B00D1; Fri, 19 Dec 2025 11:19:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 342616B00D2; Fri, 19 Dec 2025 11:19:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26BFD6B00D3; Fri, 19 Dec 2025 11:19:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 10D776B00D1
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:19:09 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D448C1602FA
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 16:19:08 +0000 (UTC)
X-FDA: 84236729976.04.3C185C4
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0700C4000A
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 16:19:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=h-partners.com;
	spf=pass (imf11.hostedemail.com: domain of gladyshev.ilya1@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gladyshev.ilya1@h-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766161147; a=rsa-sha256;
	cv=none;
	b=UTQpyfraag2gum3NoW7SRLDIUrFu6TgHqYqdKX1Gispm4YQWgyYPdbPZjU2jcuJxPt8bzi
	fFoJ985fUr+I/2kifaUeMDmDCv7xJedDuIpVZfgmM51//TGdcbhKh+FxSJ9N6OB5U6Dq+v
	Qdt4XDBmSRiP/xh7jx9zoGWpPsktXqY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=h-partners.com;
	spf=pass (imf11.hostedemail.com: domain of gladyshev.ilya1@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gladyshev.ilya1@h-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766161147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SCOGkH/6j3QWcghM8uzQeZPaIiWRAWQlI3w6LEHKRyM=;
	b=kOusxKC+RWFT9KiBhY8abOEZT2myDy0IP+4Htk3OWqaRoHUMJkA7ZYWSS6vejGcxrQijT/
	Kfy4cQ4K/uWEPctE4wxLCiWnhFPtroaU5BBGXLEfQObuacYNq/NQ3veqsCMXnvPbH7QEJ0
	bsAil3ni3h8wFvYlLdsmAxNxAob8Scs=
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dXt4j3NmNzJ467y;
	Sat, 20 Dec 2025 00:18:29 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 4D02B40539;
	Sat, 20 Dec 2025 00:19:02 +0800 (CST)
Received: from [10.123.123.67] (10.123.123.67) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 19 Dec 2025 19:18:58 +0300
Message-ID: <9822c658-c2f0-4b1c-9eef-9ffa865e44f7@h-partners.com>
Date: Fri, 19 Dec 2025 19:18:53 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/2] mm: implement page refcount locking via dedicated
 bit
To: Kiryl Shutsemau <kirill@shutemov.name>
CC: <guohanjun@huawei.com>, <wangkefeng.wang@huawei.com>,
	<weiyongjun1@huawei.com>, <yusongping@huawei.com>, <leijitang@huawei.com>,
	<artem.kuzin@huawei.com>, <stepanov.anatoly@huawei.com>,
	<alexander.grubnikov@huawei.com>, <gorbunov.ivan@h-partners.com>,
	<akpm@linux-foundation.org>, <david@kernel.org>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <ziy@nvidia.com>,
	<harry.yoo@oracle.com>, <willy@infradead.org>, <yuzhao@google.com>,
	<baolin.wang@linux.alibaba.com>, <muchun.song@linux.dev>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
References: <cover.1766145604.git.gladyshev.ilya1@h-partners.com>
 <81e3c45f49bdac231e831ec7ba09ef42fbb77930.1766145604.git.gladyshev.ilya1@h-partners.com>
 <iv7m5rmuwssltl6yzwuop3ry5s4l653lykyvrmmy6qdbyyuoew@th5xuev3mwus>
Content-Language: en-US
From: Gladyshev Ilya <gladyshev.ilya1@h-partners.com>
In-Reply-To: <iv7m5rmuwssltl6yzwuop3ry5s4l653lykyvrmmy6qdbyyuoew@th5xuev3mwus>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.67]
X-ClientProxiedBy: lhrpeml100010.china.huawei.com (7.191.174.197) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspam-User: 
X-Rspamd-Queue-Id: 0700C4000A
X-Rspamd-Server: rspam10
X-Stat-Signature: t4iutz6jmtpu5yt5zebmqcx3q16neu5a
X-HE-Tag: 1766161145-991175
X-HE-Meta: U2FsdGVkX1+LGIZsDKPpkWlSSr8C8Er4zXd4OwgfrBEPVPjXqHYTl/crYYtvRTkDe8jVVIAS4V5drbKFDf+3ECnHHwmD1uFl6jKAp/xO8VIysatqKEdmxEsYdMDzsNJOjFMgVwp1WNT2MG8nX8n8oQA9pDPviQs0iNO5imTE0dAGbgbuVCa4yZ9V19Z9Z3snukj0yQG+P7E45PE1uTu4hICvQL29kxUt6tN+S88XeRDipl0pgTbqj5G63KBJ8LjJJWttiOp/IV98LnPCue4rk7kxPFfSTmpYO5O/zRa/q0H5jHXvysZ1Rf7jK2f7hT4r+ONXYm4iRZSE0KYSJEVNEBWHDXoWsFENEtHPIa2WSQtmq/JSZOi/sWD6sOoLtGgJWJCfigXiMRajZjcvCVanycgGYfdU5qQlHqAhz7wK0rpggY4jsKrKP6QEoDVBGKlS7rvIR/PJ3RmD3JIlGb7qHceM75H6R3F+4suDOyF4HJb2zNs2A4D76cQsxAkMegQ9b8gO/L6cVPks+3XeO5PMaVRQHLxOOKlyoJpJ11aFLNt/uq6ou2+pzKOllslzk2yzoePzm1djaxLLFSbnN6kMKLUsXk8aGDv0proM/PmGzXyWcQzeXJ/+g9ITXqcIHZWAZPfN6qYBTnMdAUceIGCuAMCON6PFNxGDoMGKYn6/+OMXbx22qlzqI7yzQ0cE7Lo9qKXCESg5WXQkguZLU90H4Ug6GHp+DqTv5S3c5eO1UnETwn4NNCu+/7x4XveKs24ZLlkQatjkcLJnLmbTZJiqRlzNaBggr3O8rIIJwNBuvl1yWIzRDhaZ6LgE/z/yeJ9TaWVCMU+FPxCobjnCsL/JQMUVZWpcT51BVUG+3UxGa5BS2zUoFBwiBEgP7P7TjkYfhqXWXjez1YiZpqi8KAs70T+WkwwaZOgZELCu0S0GNGGnZO2iffmnYhpafjeypb7xJ3cpWt28H45PnwdnqBh
 TBI1eiPQ
 yiPu/SZ2qNDfgPvwXc1VHJkRtAX0OvEFD/4pQpm8rO2WjJ63ik29Lnv4bSdiafPObUH2hQVuPRHvji6VCz1yoC7LDRyHFrdkFKMsZEoYPp4CvrHQiHSea0hk9rIml/9ZTzOeSL8AbXXZS7XYljrVw5ZwhLw7GerMHprU2an1uq7WbW84d9YFVRWoPxVl4yeFMuF1VK9YAOMHgrZWSb25KTidsSYFI1wjaU9+p
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/19/2025 5:50 PM, Kiryl Shutsemau wrote:
> On Fri, Dec 19, 2025 at 12:46:39PM +0000, Gladyshev Ilya wrote:
>> The current atomic-based page refcount implementation treats zero
>> counter as dead and requires a compare-and-swap loop in folio_try_get()
>> to prevent incrementing a dead refcount. This CAS loop acts as a
>> serialization point and can become a significant bottleneck during
>> high-frequency file read operations.
>>
>> This patch introduces FOLIO_LOCKED_BIT to distinguish between a
> 
> s/FOLIO_LOCKED_BIT/PAGEREF_LOCKED_BIT/
Ack, thanks

>> (temporary) zero refcount and a locked (dead/frozen) state. Because now
>> incrementing counter doesn't affect it's locked/unlocked state, it is
>> possible to use an optimistic atomic_fetch_add() in
>> page_ref_add_unless_zero() that operates independently of the locked bit.
>> The locked state is handled after the increment attempt, eliminating the
>> need for the CAS loop.
> 
> I don't think I follow.
> 
> Your trick with the PAGEREF_LOCKED_BIT helps with serialization against
> page_ref_freeze(), but I don't think it does anything to serialize
> against freeing the page under you.
> 
> Like, if the page in the process of freeing, page allocator sets its
> refcount to zero and your version of page_ref_add_unless_zero()
> successfully acquirees reference for the freed page.
> 
> How is it safe?

Page is freed only after a successful page_ref_dec_and_test() call, 
which will set LOCKED_BIT. This bit will persist until set_page_count(1) 
is called somewhere in the allocation path [alloc_pages()], and 
effectively block any "use after free" users.

