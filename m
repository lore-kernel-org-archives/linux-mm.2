Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8752C44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 05:12:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 758626B0092; Tue, 14 Jul 2026 01:12:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72FC96B0096; Tue, 14 Jul 2026 01:12:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 644BB6B0099; Tue, 14 Jul 2026 01:12:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3FF036B0092
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:12:23 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B23A6C024B
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 05:12:22 +0000 (UTC)
X-FDA: 84986211324.25.65CD05D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id EE6011C0002
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 05:12:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=ufuW9pbH;
	spf=pass (imf20.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784005941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TMXzA4wrYATAkRbd0MtGWCT8lsBcidpH7evOMPd0N8M=;
	b=re+XxA47Lr3UD83ab/+R2AL0K4Qr/+VMYxtKVb9pk0tgIM67YQ9/P6ftOrNeqmKPHtNZht
	raRoBwU9ObPsEJJG6eYI0IVmHwbHRbkR4HHwNPiPy4AirZ0zzcxSTMjCoKukyeRTXC6E3+
	aD/lwTe09LCd4nk1RJU7bHHJ/UCj168=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=ufuW9pbH;
	spf=pass (imf20.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784005941;
	b=3o3yjvrlW8ypWqADabdVBPbycx+ISBCtZEP8Nmwjg1+Kw2c8aOxV+DmwafMAbbNlWNGO/L
	OjFYhRCWe9mVxetbadFvW9g7dbfoivmeLbg0MrmGLRfYKNperH1KIIZSm5DNp0eh1+PBm0
	muRQ94llp0HFY3XFJ3D5vmgxtOj8nvc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C520040483;
	Tue, 14 Jul 2026 05:12:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36DE51F000E9;
	Tue, 14 Jul 2026 05:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784005939;
	bh=TMXzA4wrYATAkRbd0MtGWCT8lsBcidpH7evOMPd0N8M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ufuW9pbH7t+BO068AtApQMfa4+R7cKxsBYRakma1PEbq7EB76XZ69ffufKfWQMuem
	 f85rZKZBc6EuYiVdHJSbXn1izuXBuR+2eXapNX2n9Og9RT1CeamIHN7/upL3odkuGa
	 MVa20/aJOfYrBOAFuzn5EHWR0Oi5pGxxGx0gd9zA=
Date: Tue, 14 Jul 2026 07:11:00 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Qi Xi <xiqi2@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>,
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, sunnanyong@huawei.com,
	wangkefeng.wang@huawei.com, stable@vger.kernel.org
Subject: Re: [PATCH stable/linux-6.6.y] mm/memory-failure: fix missing
 ->mf_stats count when hugetlb folio already poisoned
Message-ID: <2026071451-geologic-handprint-89d1@gregkh>
References: <20260706084118.1284271-1-xiqi2@huawei.com>
 <6a756801-f4a5-44a5-abfd-e9ae57432c56@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a756801-f4a5-44a5-abfd-e9ae57432c56@huawei.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EE6011C0002
X-Stat-Signature: 7bat4dtwwy5zh73erx4dw36oz1bn8x6m
X-HE-Tag: 1784005940-543883
X-HE-Meta: U2FsdGVkX18gWjZ36SeX8L/Oc7Z+Y/KJWOjGAzXchps2GGRT/0jNkjzuZ1dUWpV5vXtSGGZn3ZjCOZRRgGL4sa8r0fHzOy2TZM65+qxFAYrT8it2+p115IjHtlwRfXeMRtEaGNgW9RO7v2NeRNCEsf1ryrCHCYzB2P/kJDVlupKCwqP2rdJPGMbNw+BVGo6tIktgGshilUABN80m9u9btL3ZWsPZMKwVAQ8EKKR7FeV7Zr14D+mcb8S5fViLl0kIzS+wYU7nb9ebdrNEFyQfHEk47+IvTm+B5Wapd0eGvnJ7eIpRnXmMs4TobhVTAegoSeg1PNE4igmQ93TKkn+6rr2yN9qjMh4yV1VCIA3VJa+8FbSNgC7ldNVKfSSRCVdtJmaXATCR+2dNiBJTl0/b2ICi9L5BvrXGc4kRQjPFGWVUOdFU2UsYCsfL4MxEwnuYMOE0fFuUqKtcDXVhxJ9lJ2rXMKj4WmT0qhvO5eJvMt96fVzW0Ci17E5n5EIM4pzL2QqxveTPbylyMw95DoaC0sAuq0e2K7WaOXtBNtN2nFcr+I2A3FCqP/XazAxGK++s0NcqOpUsjYWe+1vYBs7bAzk7OYmbEtTQX35c+Twgib7+pNWyvv/LlFUIEe4OTSk+EEpUCc77m57dzDy9vJC6AyfBRfG10Q/31+YiQ6PH3kzRZt83GM9xRZPQR5n3KmmffmP48bGNB3hOX8vvtF+ddE0zWyUBxFBxXaPhr4tUd0H7p7tk0sfz1YLk6vm/KWvxvEeYl/6vbfLZV6g/oU2jsewcslh2jDDC1gJ4CdCsc0ioo+I+Omw9hAiWlFRXRLzGkS7nx8zkgLoKl69QakcZvyR6hfa3sn5jmZrHxDiZnXefgeTcSb9ddvlXSxFb/4l3o2LStE4vI1/Xe9WlVB7xREIV3G9NTgNytKwbalneJzKXjuLKw4Y1xlrVvS6kQAEM5SLhGVdovG0xf03/M4X
 xg9cS5/l
 20cd80f+MSc6ft+I15xhu2SvfWqZiMuU1gwBLQ7pk3Wqjwrhm0n94OUqS8UnXxlScpD5RjSgxW1LG/DjGSUNQ7StgxnsIz0dMJ+jUaU006ttgcm/MEixEfL/j2SrrnBbkm9UXTV5SqL77rBpf13i1Ico869BNJZpxgHyvFbLwX2ld6OvZt5gwu9h8DJYTicth94HQ3sT/hUeVyxJZlF9kwuWeHsFQkEw+lFVDKVLOaKea1Ark+ophK4SW3HTLmLselT3WC4yYJdjEWkqF3Vai/Ww3msfvU6KbVitom3Z0GktgWKuRc8CsBRK0xeHc7DfKWT/LDEGVEl+EXcNUIGr52q+aZNvy424VTmKeo0XuVs7+3unCZfqpIX3zt/YgS3U2/lPrRt+4pNRgsyxZroNbVvQMKOyVJ2efocEmJ1bQbf54/xiaUI7pXPH+WNaWgjKIk8uu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 09:45:03AM +0800, Qi Xi wrote:
> Add stable@ to Cc.

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>

