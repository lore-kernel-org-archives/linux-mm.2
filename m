Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53F4AFAD3E7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 02:38:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB9446B0092; Wed, 22 Apr 2026 22:38:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B42B46B0093; Wed, 22 Apr 2026 22:38:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A32896B0095; Wed, 22 Apr 2026 22:38:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8DB1E6B0092
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 22:38:32 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1F516120268
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 02:38:32 +0000 (UTC)
X-FDA: 84688262064.16.4C89997
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2145618000A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 02:38:27 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="I/pgPLJU";
	spf=pass (imf16.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776911910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v1ZCldJUqPagrKZUWrG+NboOlQsoZ4g12/Dizpsb8AE=;
	b=Q4MRGWH0dgRe60eb8ffuf59k/Q0tTGRliatZGiyESeQvuPWO+JtSx6v/JHtIJNRGCIxRkj
	nFsbw8q/Vlenxk7m8JanGk1G7w4VAUiu1kKnPCVYtIPyDHAQmQZ7oo7JhQAk0KJfrjhkLG
	IlNsd3mC6om8IEgYmJZZ5lCDF+A4CYc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="I/pgPLJU";
	spf=pass (imf16.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776911910; a=rsa-sha256;
	cv=none;
	b=ExjF7M8D6ybGn2mGKlWRa0dmIOC36yCkjQ8mtWeiHOFao9pUA1nz+kmYV4EUjSjHR7D4QA
	lyWWU93ruLKpJ50ESEq6IY8pL5FQmWT7k+G1d+LLH28rqm2HElV7dT5CC0uHQB1+Ly4CxE
	kl5R0tDM6II/me66CquTRJyXpyBDkxA=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=v1ZCldJUqPagrKZUWrG+NboOlQsoZ4g12/Dizpsb8AE=;
	b=I/pgPLJUVDr8KWasTwuUZU4tGrFXkR6KokcAc5AwsCkwoFdu50RjLhjQUQYd1kbHjwGc2y4Rq
	dXEgsDz2ZVIhxJ6y/3fjmq7N9im8PCuGXvYsZRJgUqnK2NRymRTCJtvOA9kLIGeR6bbAxvTCkaq
	gbTZh14/YWX0MOoalvyiWH8=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4g1Kpx3ZntzcZyN;
	Thu, 23 Apr 2026 10:31:37 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id A9C9540576;
	Thu, 23 Apr 2026 10:38:21 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 23 Apr 2026 10:38:21 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 23 Apr 2026 10:38:20 +0800
Subject: Re: [PATCH v4 2/3] mm/memory-failure: add panic option for
 unrecoverable pages
To: Breno Leitao <leitao@debian.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <kernel-team@meta.com>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam
 R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
References: <20260415-ecc_panic-v4-0-2d0277f8f601@debian.org>
 <20260415-ecc_panic-v4-2-2d0277f8f601@debian.org>
 <6b505601-747a-0812-7544-63a8ab3cffce@huawei.com>
 <aejlg62nxcF_5g2v@gmail.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <c1517ad3-91d1-2ea1-efa7-0f29415d513d@huawei.com>
Date: Thu, 23 Apr 2026 10:38:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <aejlg62nxcF_5g2v@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2145618000A
X-Stat-Signature: 7msesw6x9ro3irpg5c7991mnrhphc64z
X-Rspam-User: 
X-HE-Tag: 1776911907-550405
X-HE-Meta: U2FsdGVkX1+5U7+h5liViwWi7viHlsksnvOWvPApXAXCrCPtO+iRz2dXfRGyot95RUgzvOWdHQAGLM55LkaMxwA6DBHFPKbNk6VhtTHW/XFnKATihRZ4qlyPPJuT3Ocz4NsImvTrbCLa7FULv3ci5mkp/OJ0LzOSOW9oh/0KwlPceghbwLM3xi3WDz6srQPlcfmqOLOFckqgXyGlf6Fo3Sg5GJPTK2ueQaDGjbDA6xZKa9nOv19MJCTnMTPSKLDz/S0N4p0+vPGUSKDWpjhP6cxoNzxGpITD7OZkk6j2mR/7qCv2/CmLTi6gHcmIEAVYsgLrvp+BR1mthbiho5E/0MQL/pSa5C9VqwoNypkXxzVLASIuYN3vTS5EuF8u0m9Tzm1ds5sBJR2F/5X+eQTvHvsTpGlxWm8DmeCh3MnTgdP8QRoKVioLFvhrAvSAupj38UljXygcYzaHeqLHiur3X1ITw31VLn9SM5gyu9Rp7o23yQoKtBti4ylka87nCEM+8H7Ee4P3AnIqUMEPfF49htEMdDXuCO4Q5u3buppz+wdRZdzYfQZDGRPdEbTSVk9jBjgWjue9l2s97jHutngB+8XND0hwTmt0SYJbU90tlXcinbAIlLDUMXs7zgENJY6ICmYI/TIItA92kq1OZvZ9gdtYM29FZg2lZ9ahx64uCfrxH289q5UxYJui3dvLCrI7Cvj7CWdVF+c0d5jlLxY52o+acRvl6BH4v+fZEm9l9wjIy3IytbZjyKQqzJgGijH4kgwjqdAZdKC3ECU1N0buBDTmSY0IJ3dvacBY1GtMpEdBpcCFL7bh4a3NxH2thXah6Q59YGH8KIubbkRcGdLio/hM5ir0lj5NdW9TjVi5R9NNeabrHnoo6re7256/0jUsj8aevzMSGNZL5Cn7dvjniWLc53We0TreP/plCXsdIAWo7NIN17IlixYRveB89dvlxYWYUDWwO4Ly6Fdlf6H
 dcqrFhEP
 HYUcv1OBINGyhWr0jFc7xhQmP5Sp8R9UMAuW2w6ojqQkJEglNrmxXZBWGFn/4O1W5aeaPVH/icEjqk3GTwiSi++XNP9SfJW1s38Bjdh+nE7Q5EXU5FFWYQcCe8vy7hqIh9dLFnwvnBJKgZpiKdsDH9ER5JYqUQ+VRXCjIEb1brZ+V/12F0Qo5lf2U/q0Gvp5OYeC4zI6WkQucDX0gKTynoS5+G/RcEoU7+rsqP7jjxeHP3VueDwvB+yYKYvjJGseDJZIX4oTrrR1tXuK95Ljd9rbItpj/TQBiXcNXRbdY6Owko4HtkwsZ7cU7O0rSntaDXlDpEkly56IOeWcVs3ZH7xEGTIBtmqKrrMF9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/4/22 23:21, Breno Leitao wrote:
> Hello Miaohe,
> 
> On Wed, Apr 22, 2026 at 11:36:11AM +0800, Miaohe Lin wrote:
>> On 2026/4/15 20:55, Breno Leitao wrote:
>>> Add a sysctl panic_on_unrecoverable_memory_failure that triggers a
>>> kernel panic when memory_failure() encounters pages that cannot be
>>> recovered. This provides a clean crash with useful debug information
>>> rather than allowing silent data corruption.
>>>
>>> The panic is triggered for three categories of unrecoverable failures,
>>> all requiring result == MF_IGNORED:
>>>
>>> - MF_MSG_KERNEL: reserved pages identified via PageReserved.
>>>
>>> - MF_MSG_KERNEL_HIGH_ORDER: pages with refcount 0 that are not in the
>>>   buddy allocator (e.g., tail pages of high-order kernel allocations).
>>>   A TOCTOU race between get_hwpoison_page() and is_free_buddy_page()
>>>   is possible when CONFIG_DEBUG_VM is disabled, since check_new_pages()
>>>   is gated by is_check_pages_enabled() and becomes a no-op. Panicking
>>>   is still correct: the physical memory has a hardware error regardless
>>>   of who allocated the page.
>>
>> What if the page is used by userspace? We can recover from later accessing.
>> Would panic here be overkill?
> 
> A userspace page should not reach the MF_MSG_KERNEL_HIGH_ORDER branch. The
> branch is gated on get_hwpoison_page() == 0, i.e., folio_try_get() observed
> _refcount == 0, and that condition rules out a live userspace mapping, no?

Sorry, I didn't express myself clearly. What I mean is, a buddy page currently
being allocated could reach the MF_MSG_KERNEL_HIGH_ORDER branch. This page might
be allocated to a userspace. In this case, we can recover from later accessing.
But with your patch, panic will be triggered instead.

> 
> are you suggesting I drop MF_MSG_KERNEL_HIGH_ORDER from here, or, document this
> will not hit userspace pages?

No, maybe we should rule out or document above rare case if I'm not miss something.

Thanks.
.

