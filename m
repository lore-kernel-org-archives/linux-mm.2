Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1A14CD342F
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 03:22:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC98C6B0005; Tue,  5 May 2026 23:22:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D79C66B0088; Tue,  5 May 2026 23:22:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8F806B008A; Tue,  5 May 2026 23:22:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B86FA6B0005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 23:22:28 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4DD0D406C2
	for <linux-mm@kvack.org>; Wed,  6 May 2026 03:22:28 +0000 (UTC)
X-FDA: 84735547176.06.0A0DD72
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf08.hostedemail.com (Postfix) with ESMTP id 626DF16000B
	for <linux-mm@kvack.org>; Wed,  6 May 2026 03:22:26 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pao0HPMz;
	spf=pass (imf08.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778037746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=itj8eIG8sThAhvpCSo1Y/AOcXMvz1Dcruyd9jNf32kM=;
	b=FDx5XT/8WzDBCB8XwlNar6xOVD5Rj2/7rFTEDtnUx9Vfd8+zqEsoJHtKWqSRui2e7o5+Nf
	Cw1tZtd3F0WKigxHBfn+Pa1mFdHHsCLgkeJhU78TqWokx1XviWQMCkzzh40mBwG0O11JnA
	WEEqLIlbu2INwVDfCCL716Gv3ns01ww=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778037746; a=rsa-sha256;
	cv=none;
	b=QME0cdvI4VgOQ08BPnWtyeHflhYexq6kOS96OzDC/MaUGq8clJ6jHsuYoSB4E/eMJtArD+
	r3vqUVP76B+nBKwYRGXLLNxbun+wFRPaFzRzN6FGf12gBt+DKRZVnD2GOzCeY02gR0h0OL
	Zb3BmNubCWnl9W9t84B6+XfdB6XEiGg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pao0HPMz;
	spf=pass (imf08.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <997b99a7-7ad6-4ac8-802d-f663c8037315@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778037741;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=itj8eIG8sThAhvpCSo1Y/AOcXMvz1Dcruyd9jNf32kM=;
	b=pao0HPMzzDd0zlSVOOaBLwXBycBTmCV1UuL+VpfpU7Gz5wIqVbmmBfI0CxbieVgKIqqn6N
	P2MWBqG0J2lyxGSJRGL7OlULEbkXcvAlD4XM74Uw3mNjEAaiwYTN6Z1BQoPUceheYc0mNS
	tGqeIKmcrMHmuR2dUVngnyIkRKkwrJg=
Date: Wed, 6 May 2026 11:22:07 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] mm/memory_failure: use bool for hugetlb indicator in
 try_memory_failure_hugetlb
To: Miaohe Lin <linmiaohe@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <liuye@kylinos.cn>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260407020715.2269255-1-ye.liu@linux.dev>
 <20260407020715.2269255-2-ye.liu@linux.dev>
 <0eb4a198-e80b-127d-e729-3af6f63f6d5b@huawei.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <0eb4a198-e80b-127d-e729-3af6f63f6d5b@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 626DF16000B
X-Stat-Signature: spapmye8noxwnubbqxando6h9xncy6h7
X-Rspam-User: 
X-HE-Tag: 1778037746-183391
X-HE-Meta: U2FsdGVkX1+W8zCYVUtICrhc6KnawIwM/1atLUEHXISQjPQoRnnDZfO22OtADoNy0kEwVfVYAl+ErM1k6Rsjz1blgcvNcqc2UdU8HwmyNc64u6JtwJOKE7G+s1IVktQoVDkZaWsSt5uVXpfnY6u8p8q5gPRdWsgtkHfoSxeFqWXu/DjXmGNcNdlrX31vidxOUZbUmYQZwSIBmuajjz4jkslYqmlK814uEpkVzP2+hSJXCJSZ3qZgqPRnj6umMVWN6tSQCjxRbSXHuq7/JyExuoGF7iwjBMie/4zlRzOhrKyrV4ifRW1SwnZ7iTZ3LXg/9r1EzsAm8rSgIQpazrjfxuG16/Wc/B8k+tVZXzHbTbCgxe8Ue8jY+r8O+rq4aYthdqR1o1vY2lM/XxAmxoYJI0i7pUzurANqQiJriR90YTUW8ocqZhEFLE/XLEtk0IOmxs3sHmar86K0En/5Ys42s/DZrVSBIixSMWy6lGhRxsOIVqSsrJT7T2rtD7XIEyvXlTHUeNvXW13BngRJ+/oJ9APxxRP37ZDMZsMYNbAgvk3Q6DYMT48Mwjr+SSFlpXqs1pGwv1gjQJk/e6F2tjMhrFF4aqYapLXxmwla7lcVlrZFqagw+aTdBUrSNlSvuFGSw40lrAtqyFZr0vGKchDWQRztPjZVvKZRirf/1tNSEJPSxUMGUJhKF3CSdg5KfeSNjj4mp9tIRgMjNgsFebYF6ibW1fogdK2tpdqRCjFr/dqR/TXUXhWzhQ44C1wHKRQgMVdmkqoxSWOtt084DgdgqOxvhEweI/wwZSJVQ+BDRoh5td2EXHtjPZH+CeC0nNwS4uaGDsuEgP9c8Tg/cdJpo8WX8j65YkClVOSa/R3eGAZwn0hJDb2+ZeyMVqFpfwbXWols6FhNDls1kzhuvgSAjKYrVwxg6hRZgwBen9rMqZ9tjY06CyVwLbmow07YsmI7BUJqPNG6lr5cQQHZIIN
 m5EcbG8J
 6iWVhkW3KHSSw01TPbeNdtbPJ4DPUlxR4FMC08rytXeemRoYuyAArnqSQb9dC5WjimiBTeT6G6LhGW9qp2vH1MZJ1ssM7rrW1OcgYjwgYTrJFF39jDueSWGTrF6NmJmqCMSGY9ex0zy8Mh4K92cT7X/D5FL2oFaeGUZKA5GjV9EjWKFb9/eaiBWJjeGmWK6i33PkA9JIb4lv82PD97FitlcLWStG2GSpXRJZZtkMxP1rzdgIFvyOQjMmBgZDZFEc37p4CEf34uaHIa5HemdkUczy7qsG9qNOLkW7gP5H6ST7HqHhhfOhIfHpZHkSviib4RFjTSJOL/BOsHiiayw0RYDeurhO2exKsp/KmUoGHgO5reMyV4wVJ3hzqdg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Friendly ping.

在 2026/4/10 14:38, Miaohe Lin 写道:
> On 2026/4/7 10:07, Ye Liu wrote:
>> From: Ye Liu <liuye@kylinos.cn>
>>
>> The hugetlb indicator in try_memory_failure_hugetlb is a Boolean
>> flag, but was declared and assigned as int/0/1. Convert to `bool`
>> and `true`/`false` for clarity and type safety.
>>
>> - try_memory_failure_hugetlb(unsigned long pfn, int flags, bool *hugetlb)
>> - testcase path in memory_failure(): bool hugetlb = false
>> - clear semantic conversion in MF_HUGETLB_NON_HUGEPAGE
>> - preserve behavior (no functional change)
>>
>> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> 
> Acked-by: Miaohe Lin <linmiaohe@huawei.com>
> 
> Thanks.
> .

-- 
Thanks,
Ye Liu


