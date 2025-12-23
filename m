Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7E8CE6B26C
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 01:18:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 155256B0088; Mon, 22 Dec 2025 20:18:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 103456B0089; Mon, 22 Dec 2025 20:18:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00EF66B008A; Mon, 22 Dec 2025 20:18:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E415D6B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 20:18:57 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7E4A213AD70
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 01:18:57 +0000 (UTC)
X-FDA: 84248976714.17.58062BC
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf09.hostedemail.com (Postfix) with ESMTP id 16C94140003
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 01:18:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	spf=pass (imf09.hostedemail.com: domain of xiujianfeng@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=xiujianfeng@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766452735; a=rsa-sha256;
	cv=none;
	b=aXn/SW1h8lhUViS0DQURs15DhY+reLKHmdl2TyX3AKzPZaK/zkhx+QhiY5SfUFPAjtk4VH
	FgRyniXttceVEeSgg7xd7P1EkhWuVHCuKnPLklW++JY+/NY4mt5bs9pwlHD4NE265Hry2V
	cGvuDif+s4xYsqnkPPPI+G0hZM5zRuo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of xiujianfeng@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=xiujianfeng@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766452735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uWqM/EYQPm1TpMciEI7c1zKGyu5ESIesvijLAyxtsWY=;
	b=0qlvwuii+/uPBo0jXw+R9qqyoaPtwYcvqftdn0vyiMv7phbLZX5gwkN4NOzLh/pZWcFCWt
	QAFqpn8/OSuL60ntnoGZTSIV0T7FdC2dRdpDZkT/x/MRc2NEyXYZoWIYWha7QRvdp/+2EX
	T1Qh9eKXqeHxn/8j6DjcCeztQhkbs1M=
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dZxw66nyCzYQtLb
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 09:18:14 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 24FBE4057D
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 09:18:51 +0800 (CST)
Received: from [10.34.206.51] (unknown [10.34.206.51])
	by APP4 (Coremail) with SMTP id gCh0CgCHNvf67UlpUMaZBA--.34769S2;
	Tue, 23 Dec 2025 09:18:51 +0800 (CST)
Message-ID: <c6f29d34-35e9-4cd6-b91d-42b15e4aa41a@huaweicloud.com>
Date: Tue, 23 Dec 2025 09:18:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next] mm/hugetlb_cgroup: fix -Wformat-truncation warning
To: Andrew Morton <akpm@linux-foundation.org>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251222072359.3626182-1-xiujianfeng@huaweicloud.com>
 <20251222111530.c285692e5872035d6ee68264@linux-foundation.org>
From: Xiujianfeng <xiujianfeng@huaweicloud.com>
In-Reply-To: <20251222111530.c285692e5872035d6ee68264@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgCHNvf67UlpUMaZBA--.34769S2
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYb7kC6x804xWl14x267AKxVWUJVW8JwAF
	c2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII
	0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xv
	wVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4
	x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG
	64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r
	1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCF04k20xvY0x0EwIxGrwCF
	54CYxVCY1x0262kKe7AKxVWUAVWUtwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
	0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1l
	IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxV
	AFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j
	6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UWHq
	cUUUUU=
X-CM-SenderInfo: x0lxyxpdqiv03j6k3tpzhluzxrxghudrp/
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 16C94140003
X-Stat-Signature: d7yx4r9kk45x7mwscgmoiox95dmjk5b4
X-Rspam-User: 
X-HE-Tag: 1766452734-77648
X-HE-Meta: U2FsdGVkX19T2qD/dhBtbUrdXT/S0NXkAyJBGw5ptttjIilE2DyvrWtKhaaHQdzoukdZE6iGUOkhEPAXL0QjWXoyFKEqTn2erMXSUiRooRK7ZzxKaoQJrPIDdFR8/994LBuyY1PufAXAyZQQO6wZZWLRAmpJeNCR747xcdWlbyK7Dex1ktuGq1XFepdsN5N8ySkwZpF9tlYbj28lEaQH9e/tlGEuuFzOwEQvnPM9p/me1x0QkqSfu7UHaGg++7moFo4gZKippoPNuUGAKdbTFQRD3lRApGTL5pPXgrEz1FpWrePizlh0BYJhg6GY2m/ZaLu486GYh0BxQbIvm/qB9aKrUoC+BgE61w6ANpFAQUfcNGHGCgX9jui3PQdhrhQbkZSr6shUrvRoWwxH8PLs9K/+k3nbjk7OEwU52+rzs8+oc974a1YNlZnIhwIQIsJCrK8cxY9b7v56XKtRY+ZmmT1JROHDrA+yk4hZCvflMP82Gb28UDGybxFvLkSzn/CVWgA6iKJkrJjOeS4YZG3cUMELljUgHR1+fLzEOdwIMtnzSbWA6NVYqt2z7IogQVICn8HPsKOZclzjDKPKXmNwCe/3B7U3WKJOWZJGZY6Z2FuoLJO3KF8Q1KmXPItwRC6mSbhv7ipj45Ds8eN34NgpHDQkeQevxcTq40Sv8oWkbMq+yg7+pbYTzyUk+f9T3hSgKJTmP0L2gMzeiom6705bhRAfqwOWpUCs9unYghqhvNWFOPTxHKMtoPEPrxEY6lWblWyiPP8QmXOww0vMLgxi01SoWSO82zPs3jhqhAi/ukOr9j0LhivcggvgL6LNJ2js/3zgJAxBq7kljkFJhLrrL0S+OfzD8tRaxtH/Bf/SOcFIBzmzYhqiuJvJiZGUnkSCi74b1evcBWsn2G7YsBfXnZrNd5lCZbc5PAlwlsil5tX6Wiz0jYiDFosjYQO09UA+INTg8U5kPsGZQFcYFht
 H32vGe4c
 qN8arCZjyqUoB/40LjD7fAg9HSe5N+iqqY+s1g75mNxlhtNEFZc2lTOXhBYUz3nbk7Rg/pPwPyPbODnJHUYBF1ENWmrJ6Tkusx73aIXrlLcH+jEkdOogm68wLGmpOep127Yf+5y3q9RHVbAUKtE74rizrCmmAvCVE78JR6XnIucZOFjb1crxDW5uRH2S0kUXwF7bb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 12/23/2025 3:15 AM, Andrew Morton wrote:
> On Mon, 22 Dec 2025 07:23:59 +0000 Xiu Jianfeng <xiujianfeng@huaweicloud.com> wrote:
> 
>> A false-positive compile warnings with -Wformat-trucation was introduced
>> by commit 47179fe03588 ("mm/hugetlb_cgroup: prepare cftypes based
>> on template") on arch s390. Suppress it by replacing snprintf() with
>> scnprintf().
> 
> Thanks.
> 
> Let's quote that error message in the changelog and include the Fixes:.
Thanks, Andrew.


