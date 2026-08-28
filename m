Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5D07C61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 09:24:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 549AA6B008C; Fri, 28 Aug 2026 05:24:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FA7F6B0092; Fri, 28 Aug 2026 05:24:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40F3C6B0095; Fri, 28 Aug 2026 05:24:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 26BE56B008C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 05:24:15 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 99F1814027D
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 09:24:14 +0000 (UTC)
X-FDA: 85150142028.18.BEC0974
Received: from mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf06.hostedemail.com (Postfix) with ESMTP id 094E8180006
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 09:24:10 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=E6y5rY+W;
	spf=pass (imf06.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787909052;
	b=WhHbFqeoIAd3y2mI4r0xAMC0Mn/sv/VsRy2FutWRvelieLxnThQM7u2EQIn+VuDXSey8z/
	KOQwIfKJqtn+B0oQn5N/S6weTKAyhYtojTXFLmHzTjgfTnUL4Lq3sad9q3ensaiDEOQDMk
	XaipulJleeHTqqdONdFmOG7dxNYRd9Q=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=E6y5rY+W;
	spf=pass (imf06.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787909052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FpBoYnFUwml1OaMSkWVczfp2o0wwzYNKbyWe1ArWEDA=;
	b=q9Fiy/fMj+ZSxfxP192CueNa7ut/YmVK2qZCt5o3pjbXgIz2wj+WGTQhDpmKjjF4poCnRa
	GKNtD1vpKqWR+/jQ8nmKnLvWPsUDJQDm+mWZPJ3OVJEuTanxmO4hngs7Cf+Ndzu60VPnMD
	UkUnzms5vctEyc7clW4G6AV51IpzZ1o=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Hvdo5v1MfFdr47iAeJk70f6z6nybiKkgDuXe2gZCqVA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787909049; v=1; x=1788513849;
 b=E6y5rY+WWnFt4kUNsykrypUpwn9/sqZ0F/A6d4d/LFh01biqtje0SGDU35ljZ5X8E4YJDbaF
 psvYfFztTxCRCEe64ivCU6cUJGRnPJ5JaEMqD8wzPh80ZAzb8hvbWMNzuuuTqL1Q5lveAhe0sx7
 +4q7Zq7u0yNSO6QLXpIvNF+E=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 8d8a9a2e6a4f7bb5;
	Fri, 28 Aug 2026 09:24:09 +0000
X-Mizu-Trace-ID: 8d8a9a2e6a4f7bb5
X-Migadu-Flow: FLOW_OUT
Message-ID: <a82f8070-cc85-47f2-baaf-70c499834a8e@linux.dev>
Date: Fri, 28 Aug 2026 17:23:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/vmalloc: fix vmap_purge_lock livelock under memory
 pressure
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Dev Jain <dev.jain@arm.com>, Andrew Morton <akpm@linux-foundation.org>,
 Ye Liu <liuye@kylinos.cn>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260824095020.1225189-1-ye.liu@linux.dev>
 <aoxE7rw6gru13DB5@milan> <0c34aab2-9b73-45c0-8fbe-e33895bc8eef@linux.dev>
 <ao3Tf193sQpS22c-@milan> <3b7abe37-4f6b-4af8-a78c-49ff5edff298@arm.com>
 <ao6heKKQLSYMj4tX@milan> <db2d4453-2bd7-4548-a920-fdc12730dce0@linux.dev>
 <ao8j2kOMbCUv5g9i@milan>
Content-Language: en-US
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <ao8j2kOMbCUv5g9i@milan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: hqqt4gcjfwmxeiwir8nu5wz5yszw3pzd
X-Rspamd-Queue-Id: 094E8180006
X-Rspamd-Server: rspam06
X-HE-Tag: 1787909050-567293
X-HE-Meta: U2FsdGVkX19FD1Q4guBTvxv1AkkdtVo12F4mHoZs64qlafFHTLpVDydt13SFUV/SbTZE/CvB76BQtmopVMd7uKGP+ev5CI0bT3ACdCkF74ZqWRkMBRjwSYnPAe3Z7eAYyXIZErrv1gt2mE2npqPnvwR8nngOGkpjuT3KG6nZ/YxNkcKeuqTu4laS9TmZcGAdXJpHQ7M7L81gCIL+bxevuEUlR+XMUC5ZFzNHFUlMzefufl5XvzRWFKCzIrOJZ83lRiywtMsuBiLbYgPEwsKxa7awbX2zAVZz6mG6CP7IaVcBX1JIx11hx+vvgN8owPEHNcbXIT5JAtgTddCzY/OAkYt075X7Bp4jEvJYfbsWq8n6tPLgChajq7S7s0j4U6hhqlB7Zx5V9tDIyJMgAwWPr4ndIG2EwvuTzZxWmHiWoFF4PZirj60lK3UnPCR8BWVb3fc1c1gWUT7xStNAfWGkNVHXwUFYfQgH6IvoQDQUp4p32t34eOvJh8fcc9Hcc4dUmOoEJ8Ehj3nncVdG+ZbxNJimpZzPFyAYyusoVdtUIUYCuGW9RQbWG4vIdP5zch2PLxpefErsvblkH26QxpyL9MUgmoPC1Zj/8Wk+gK+ewHCk4K0MjukhVcHnMqr2quklaD7r+OuOV1zNxolTzBgz8qv9QjekiQj0LB8bJtJ3oNgSWLyLMGrK2fHc6im5mcUUjbiOgBLO2X5bKI7iI2w7IhqKBzbR6OFeuA6Q8qQ87IxjJMHo6/ELukfGhgZXSnzBJ9aLhBGd/YylwStFmzyW/J8P89t5jkuJoN86SJ38rcrjTbqsC4wU+mluciEiP8G3qgIYicwsY9f4x/n1cKe26rCD9IcwbVThVINVF6RGU12D9uIzBRLx6saUOM91mg6ID6DSCSDo/hLHbsoyW2Vibc94K5cofFrs9YAiAb5TpxlQccn+o0/2/Bz5nK00JoHIKtKr3XgzvLjchR2Xw+f
 KnZ7YN+E
 6bwvUl3ebe984eCYP//Tj4u4F8YndeseSmYjAyc7p+36NcDXug/vtASYcJYIblmqsoK2jszuNjtMyR8mtef5C01AYn1wyAISAWc1UU9NB/DCqQCdFF6vUKVhAuvzQy0gqEg7EjqFbbXyKwhg9e9PEIJIIy/q/PBuJhbf6TsxjBAIhHWmKciAfXoXDLpFz6UyxRiX8nFZv7sk5Ihea7+9OCvkpqp4fGQ8iwYlc4q55b0afOblFvA0HO1aOJ7X6uTKbMuBvcvUIatqSz7qjnX98jhQV+CuSqlRP7R+CAP2oVbyPrns76XBNzefAEpzOC86zk+ZrEPDk9iaxCVBTlp9gWa0O+hoCYq+uIlnj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/8/27 01:35, Uladzislau Rezki 写道:                          
>>
> Yes, i think so. It would be good if you could test it with your
> workload which triggers reported kernel splat.
> 

The problem no longer occurred in the test environment after applying the patch. 
I have send v2, please review it.

-- 
Thanks,
Ye Liu


