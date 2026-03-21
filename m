Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF31E108B8FF
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 05:42:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18CFC6B0095; Sat, 21 Mar 2026 01:42:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13D136B0096; Sat, 21 Mar 2026 01:42:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07A936B0098; Sat, 21 Mar 2026 01:42:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EF4A16B0095
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 01:42:17 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A057C1404CB
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 05:42:17 +0000 (UTC)
X-FDA: 84568974714.18.11CDA4D
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2D6974000A
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 05:42:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Wg2nHqAp;
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774071736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cqHkOo1CkSmUfnkTgx/qLORyDrET35rQ2XYf7BvkVGM=;
	b=nYNK7LVIU7SwJP+TUT1y9lu+dpb0Jtl1ReQuf4aRHcbvvlWVQTb7/SnQLZ0ngSOH7G/ths
	fwmEveXQ7fUVQTvArG93rKAzhCfaBu5XxERkMpZ92su6wdyGeB76D0n2lXyA7apRJis/Eg
	ZgiHse9VuST8b3inEYg4lb0+yjqtPfw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774071736; a=rsa-sha256;
	cv=none;
	b=8EfE2jvpG5AZYItYlHNf9xs48SMl7YAGCwPV0apED0DR8vg25J3d71jnxZBLD0zndW6i17
	RNPY4ETexJ6As1OGj8faAxY+oxXEWhf3GtfP5eukULLqgFWhXSw7oAWTXC+7dQJg/HfgnK
	Mni17QVQQ0KIgryX339lwAipdqeHS7Q=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Wg2nHqAp;
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774071730; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=cqHkOo1CkSmUfnkTgx/qLORyDrET35rQ2XYf7BvkVGM=;
	b=Wg2nHqAp0BhXm4jVKwznTZ/xcWrjnsDJ0irO2oYClIgBk6wfbC8XatXHfYB7FNnlwJJNOJH4ycK8gGRsywcWJY0rgyd3pP3Zz0eDPj4BT2y0MZC6ztQzeaImYNsmzziCMe+93OAIHllWcu8YafJu1Iur6xu1vg9iWz+6vAZ9HeY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0X.O.-WQ_1774071728;
Received: from 30.42.98.36(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.O.-WQ_1774071728 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 21 Mar 2026 13:42:09 +0800
Message-ID: <035bd66a-da28-45ad-9ced-c17a2f4e6806@linux.alibaba.com>
Date: Sat, 21 Mar 2026 13:42:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/13] mm/huge_memory: use mm instead of tlb->mm
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kiryl Shutsemau <kas@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1774029655.git.ljs@kernel.org>
 <98104cde87e4b2aabeb16f236b8731591594457f.1774029655.git.ljs@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <98104cde87e4b2aabeb16f236b8731591594457f.1774029655.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hwazhq37ppt4pb61jfdsef96o5chbi4h
X-Rspam-User: 
X-Rspamd-Queue-Id: 2D6974000A
X-Rspamd-Server: rspam12
X-HE-Tag: 1774071734-401496
X-HE-Meta: U2FsdGVkX1+5wNRTpZSufFcv8CF8BU6FM3AjEI5c5ERe1kDka4o3ZjYhMMWxvL2ZVWLdtJ1dNic1NTr74TvWmAt8PFsYgpzCWTs9s1WmOUjUvnonf+jkwr8t+QTYXH9CaXAoYeObDLwSRpxmv9S2qnVOVOlGyRnchIZc/hRX2NnxFiqTIJmfJePdOHTGLlRgpnfCHLFeWI0lCMAtw7Q3zqLzu2vh7dy7DNemzKAZbB01OLf9/FnDAFEaRaU3nuk6b4TocW+U+2utQ8ERlq8dxMFr7ycyEv8vMvittHsq3rj5f7E/XMDnnHT0uWf1JrzZI371H3Snpi9qTI9+FAE6Le1uw38/x21OemDvuiipZmx3JRFRhXJfWsZTXNBq+9ozBRNPO49VKOEyT8nARMJb43qiHizb9PvyEh85p63LoigX9SmugLJm/t3zu15vtM6hwrkJd8ZYnoBdV+vYjYLb8NSLY795waj2yns/USnTXEEUrLraTHReiGREN6Szej/v15akWfLoT1LyPYD51d8zUsbzAM+AH6Sfgu0SSJoSX+0XE8xSVJXMC86k2N7K3yIVIem6WhuKayDhvYP/fwnzm9CTWFBoWD4RZHKIJjFCF2EZw6VkpcWAnVgYZOA7f/LMCWTqVtEsFqkqdt89TNBoDebalYZSHX86MNZCOXzLNjuCn0stVSHePUK4dJhXRCum9DJeZRUWH7aD8C+walPgzNJVOSx9LGK813i8O3uBo+Oz4J//DKPR8StiWozYTBoyN79GJVpY0RC1TsZHu93Kd3SW+PUirSeSBMuFvJIg351KkB2/gCRaxQ4UGHSwk0/NTzUkY+kuLYLdwtQe23XQYQcUV0S7mcaqC+IsSGq55Ld+V5tda0zNbQp1r/D8ly/10wfE0kWmFOnUn5M2p5UP4mCjJIzeWywr/lDLWlVaGpEh0QsEkW1zsw9qRuLioFZOx+T8ithu/wl41iRZN7+
 VX2mILnf
 NA/kMd6ycKrLpnDgb3CcHrOaXERmU6sowpdvI8oN4yUiViahAgcS69s5G7Mb2sTCYxKbguCHujh6fBOGM1YG7tamJDBAfkNlo5zLxroYHlENW1vLP0e0dA3Ngw31nO7l43f2RgEwvHZCZm4DFB1Oswe+MNKWLBVkO5RP1MpbkFSS6uzzGo1qbCUmo7fAQBFB4MtbNLtlrOqN5Gv+7clVnnw8jCSRyU4Jn3APfCRj4Hj6h5bjrKcNfhpGx6ICjl0otGEz3Q4aNPQlJvTTuNKs+cjzuv8ZGrpC2AT60LtPE51xftRCzRwpCSA0ndEaQ/lNfr/u2DEdaLxmPZhZna1WRsc7THdMi4CukR8qs5Zo+1LlPVLJILfuqwb6q45DKzq4fo2Booedssl2vzRx8ZMA8jU74Nr3fjuPUeSjhgy2HGUTfJLrzbip4P1AzIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/21/26 2:07 AM, Lorenzo Stoakes (Oracle) wrote:
> Reduce the repetition, and lay the ground for further refactorings by
> keeping this variable separate.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

