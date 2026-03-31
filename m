Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4355FF60D0
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 08:49:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 408F26B0095; Tue, 31 Mar 2026 04:49:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E0416B0096; Tue, 31 Mar 2026 04:49:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31DD56B0098; Tue, 31 Mar 2026 04:49:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2121B6B0095
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 04:49:33 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CE4DF13BD1D
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 08:49:32 +0000 (UTC)
X-FDA: 84605734584.17.12E9FB9
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8BACF14000E
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 08:49:29 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=KnhQvPBt;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774946970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZC6OiONE+MNTxDLMVZqfRM/eFX3r4XWu/MWb5nj2URs=;
	b=5jNcPYsArFvJSPA19rc01F05seSfcoFBFU5D0UDlX/xRvPokWvN4+P73RWdwHN/HWNRRzF
	m5CryOi6903BN4oeHCS820RUDYlZoH2pUCIk89JTgrXyp5saf8I0qqVje7Y1tdFPrqiqdg
	bueJqJiafeuCLufbnuivMGOGg5qfFF0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774946970; a=rsa-sha256;
	cv=none;
	b=xFHWVll0+9zKbewizr6M29KM0DRPdZyj6f+t9NxL3Djj3YSJmvvnfWUmTldz29J0tPcGKC
	+mo2JaX1iJEAy/cvSD5OHpLbKcYSxf/L8EIzDjzuQ0TtDC//8qr82otRnjBWDDYNTBil5T
	oFjwWSvoKezLK3iQWrWyeR81Mo5ouJk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=KnhQvPBt;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774946966; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ZC6OiONE+MNTxDLMVZqfRM/eFX3r4XWu/MWb5nj2URs=;
	b=KnhQvPBtEM24G4MyxyK3GWWc9FMz529gyharYOb/G7Pt2+Ta4ZAa5uEsGnhjJx/94PiDSXpMUmRKdMBUsYvYT2vcJSePZC55NXy75XLTcfvW+vnd+sfp1AOMyXp4QShfvibbhzshgAaPRVOnTPFnQm11fyYgwPv94xJedUDFlhY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=25;SR=0;TI=SMTPD_---0X03pAZZ_1774946964;
Received: from 30.74.144.129(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X03pAZZ_1774946964 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 31 Mar 2026 16:49:25 +0800
Message-ID: <f2d49bdc-1103-4804-88ce-fb9902fe2164@linux.alibaba.com>
Date: Tue, 31 Mar 2026 16:49:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/12] mm/vmscan: remove sc->file_taken
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>,
 Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>,
 Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>,
 Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>,
 Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>,
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org,
 Qi Zheng <qi.zheng@linux.dev>
References: <20260329-mglru-reclaim-v2-0-b53a3678513c@tencent.com>
 <20260329-mglru-reclaim-v2-10-b53a3678513c@tencent.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260329-mglru-reclaim-v2-10-b53a3678513c@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8BACF14000E
X-Stat-Signature: kq3ou1c9d8ssxdcmbook9k5qf7r538zt
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774946969-499577
X-HE-Meta: U2FsdGVkX18wXxqC+ZL1t813wDhAn1TiWBFfNL3AOLrzWhHvfSB/zSdmg2YUykC5VW003cu7dwkG61AgFG73LCxLlwou+ucvPnlsq3oOxsj6/s42nh3518Oe+68gZtHKRd6yX5VNs3vxj/e1kzWsylWBi8sf9bhFE/HbNPo/P+P/QaB7cwsE5Hy/0Vz4MF9Se6Xj7iAHZeh5BWeKgoPTwY9s4RrCkgGz+L30z2l4MbSOhms5GLYcuV8adTE2p5Qd9R2w/pudW3qQ3/UrhRwiizJgDEawSh8Pa2/XLltGYJMmGL+85Pv0jrIrXs2tRrKL8S+3KtIZYKddpAcp6hBONr/2aB1GBzp8YOM8ji6n1KVJ8BS+GxoI3qV0EEoskF42GFJc1eX+1FTbet3Z/byTfOtF1eLmD4RnsrngeFkF7EiMaRr41COKPwtXZdFlG9a0A/MBlvpFnXhjMtpoEALsXTomAr0whlF90M4jMVYt9bFLKg5pg3f2NlCnRjKGaU79sLTj3nHRM2Goy3mAbnY9uC/tPa3meQPqZk182cM/QaFT9ChThGjtm1wvfPu0y990L0A050RpHqXaqulSY3n1nbtsIVW+ZOBkSWttecpaiKQ7SR6u4Bu+1Fox6LNLJw1kpZZN+wKuUSC0m9P0KvwnyW1EM9fEvAvQe6SeR0vIGC2QjuZ2QRKAYFjqGNAPCC4Twu4Ir8ah1D6vXfF8bwqHLL4i7v6/EHGFrjQ+GAjTxBjj8KPUvBZRUO3VzE+up6HSh/3VNnE4HF+g9ANt4IKgmqxM30mop76dz30S0wifOovA33/b/rkxpcEYzgZI866RuwUZIgLkSk1I9X6QWpH6mH3Qr+74eTrJo7BAjA4aob6e0wSzoPwMtH0TIz4EpXBlnl2YxOguNdQBw4q9+gbV9uLEn8e8TgzWcJg4gHj1Yk0WH34bpxO1ZmpaDMIYFQp/MqMdCSDe5Ii8Y6vEQ3d
 Pds/kzAQ
 JtgD1uK9cWwxMtvQuIMXtPMtEsIQCMDEM7io8G1g2PzprlxTV1dTRxqOToNrTx8zbxmjJOBMJ3I4emk3qM8vo7RNjD6wvTVuzpNSb2D50KglB7RQ9G3gQhcTo2sJ/BzghJU0hkwffXN0PTYp8d78qiuVn1btd9ayhC/X7pvaUsWzJbQh6LYXfroQ60udJ5JhQ6pF4UByo0h9zsPrYJ/ZsWEZ/zKbloKVZ2p7PQPgSAKPoaKJzZAzfjk4VenIBgaFY+abTTpiY58eXfEBEGRyTgy1Z6F9lsCFSlMksUUmt9gpzeHC9XFUWcH+H6guM34RPoTp/ScIGHf32iPlgJNwxv9ciPqOKSlc+SzKB7WdbWwQR+pEdz8gyEggjevXvr99cWbVi8MhLxusyrMgEP1J/MT0htXezi1z5+viu2vMNs2taCkHsj8h5pVlhbq6FIoYCsAu4CQUosUquKcAShr+2y0CeixVy2kYa4p+I5SgNMV19VMIqDE9GdNLYkbjO/HCcONQ0fBLgVG7qyzXNrW0mD8kwpA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/29/26 3:52 AM, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> No one is using it now, just remove it.
> 
> Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

