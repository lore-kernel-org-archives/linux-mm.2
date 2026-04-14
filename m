Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F000F531FA
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 07:46:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81B716B0093; Tue, 14 Apr 2026 03:46:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F3CB6B0095; Tue, 14 Apr 2026 03:46:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7303B6B0096; Tue, 14 Apr 2026 03:46:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 67E6B6B0093
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 03:46:11 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3520C1B8053
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 07:46:11 +0000 (UTC)
X-FDA: 84656378142.24.A1F88AC
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf13.hostedemail.com (Postfix) with ESMTP id 862BA20011
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 07:46:07 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	spf=pass (imf13.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776152769; a=rsa-sha256;
	cv=none;
	b=JFy0FedR+LC/m++3JO9eM1glsrXRXS9gtREnUEubALJnvEfcC37xIJvtOeX4dYiHnJeEND
	+6Boe9pcJnM9N3efBz+Z+zxbfU6XjoawMDtce81eiPsQyb9msNIggFE/+naAOrxnGpjYXY
	WquDnr03knZKU63GDTFdcEodPFf67MQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776152769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TBWot+cd+nO5P/3zw9GBaiAWGRWN5gqR9eQw+QlvMDs=;
	b=s8eOv5TM+hwV9jnE2lPSzVauBpd/Yk+lrOhWnudghWiziFnIqdd6oP5W/LvTuWanV5gwz3
	7IASzd80cuHFt9JoeVKCIrEYdpk/SBmQh6+rKVl+6rY+wib2n13Xi+SVbqCnklbB2c0fq8
	5uZF0fhIkJNp2o4L+MBCfksQ8PEqVj8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fvxC15qHpzYQtGy
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 15:45:17 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id C52F14058F
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 15:46:01 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP3 (Coremail) with SMTP id _Ch0CgCHNL658N1prDBsAQ--.39021S2;
	Tue, 14 Apr 2026 15:46:01 +0800 (CST)
Message-ID: <f6d69f84-a3e5-4497-b385-27d9c494be6d@huaweicloud.com>
Date: Tue, 14 Apr 2026 15:46:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 12/14] mm/vmscan: remove sc->file_taken
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>,
 Leno Hou <lenohou@gmail.com>, Yafang Shao <laoar.shao@gmail.com>,
 Yu Zhao <yuzhao@google.com>, Zicheng Wang <wangzicheng@honor.com>,
 Kalesh Singh <kaleshsingh@google.com>, Suren Baghdasaryan
 <surenb@google.com>, Chris Li <chrisl@kernel.org>,
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org,
 Qi Zheng <qi.zheng@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>
References: <20260413-mglru-reclaim-v5-0-8eaeacbddc44@tencent.com>
 <20260413-mglru-reclaim-v5-12-8eaeacbddc44@tencent.com>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <20260413-mglru-reclaim-v5-12-8eaeacbddc44@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_Ch0CgCHNL658N1prDBsAQ--.39021S2
X-Coremail-Antispam: 1UD129KBjvdXoWrtryDCr4kJrWUur1rAFWfuFg_yoWkZrXE9a
	yvkr1v9ryDXrn7ta43ZayYkF1F9F1vyF1Du3ZxZr1rZFyUZrykWF97t3s5GryIgay3uFy7
	Cas3Zr4kK390vjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbxxYFVCjjxCrM7AC8VAFwI0_Xr0_Wr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AF
	wI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUxo
	7KDUUUU
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 862BA20011
X-Stat-Signature: 5dxrkoehz1375p9n1gxperitukzmw5in
X-HE-Tag: 1776152767-845424
X-HE-Meta: U2FsdGVkX1/cGVZp1YwNp/0UDpM2VZYo3LbCfflGcjhRIAL2ZbG838zaA9NZebkwc/MJ06omxNTsseDMDm8vBi75jY+IpPOpYTcJiG4FPv/O6vJ+HY28rl4ZQnXEyzQZEK0lX4sPMbKfYr7YTllW9Z3ql+psYkX9IOMAJeYPbjb4CwbeSl/fN3IwYJf+12+tHUbBPGH/O54CIGQfxeiQRN5fUx3UY0Lyhj2QafO6PFLPUM0JyMU3mHwkFtOLrIZxIVYx7kAaQO1pZ52udJge/ZiVZ91n17G7Le+7q8AtsJSi5+Qc6tLDxnAm/5pNAZqKproE0W8IYEgeZqDxxtJ5jCasBzmQPfuTPqTijELnMTtYEwr0jvraSQJhwWByhjpzMhz3iuJlpKjlfwM+Jx60Y5P2jhD5b0MVLVMRuqTvR/DKA4qVDf8uUK3heiTnaf00B9HliK26R962xt5FurC5pOA+5moz+6RkLviAZJBmsQZbqlpJSmPtKTqQe5VbY+/P4CXmNfrancuaOr5oD2QcxQ06z4F0HwAf3ZX95ZrRept3iCcujSHc6C6wSHWzBAUujYzosggJK9OFC8vUv7W7Gwz7phfsTDyboKjK390qnsYd50y7twJmcQn+jZ+yyuHHdquZGDe3dxplwYDGgYZBT60FisiqUbeurvBTkKkbCojH76WVAoaRaII5z9tTIhXlBFRvTkzkLOQH8t499d8+IED49oratHx2TdvKb2pDWuiB1kvj4x0XQIWh5ay70JExbBWNb/Mn0F8VKGt3fQ2jGkMQuFeD1QD7yu7k3wL7F8Ym7/l3zlkqnn2g4/CV71zVaN0I/VmoV07iBuiXROsx+npkZS/r3579hs9FJxmdB1/0FqATMbzWhDNzucwQIxvYorOGVlE4bB0iQ6fmqlQyk3SdwiognFroGQm1XrVdYIW0szzGtR92AM7pEgFr+Jq42B9H6KZVwZLG+p40uGH
 e5RhfZyW
 0xh1Bp39p9/PQuuhCCmHz32uqKm2peVB3sDsQdSWSzffRALf4tqKeiobSF4P2d8V/wNRW75ZwwBpw6Z9bjewD3r+ihuq/vHNpxgHAciZUreT7x53dQ5P1cgNYVUthPMyxvlSTneUPl9kOFU8cgUYHPwzBPagtIT9cP8HQtkdRBIgrOytRKjR/OVJN6yhMVy5ZvUOn60BYDfvEDvL1JeHWLaziBZGXEgR4U7vTgOl/V1luxcPSKCe82TFLIlyE/ryBEnxP8odaKXV/F7Q6xZHKLZfRF/D2TEYlfl/VZhWc5eHPnHI5dP+O6GQIMigSM2aVbndYp/oTNSgKA2A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/4/13 0:48, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> No one is using it now, just remove it.
> 
> Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/vmscan.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 3f6ba34fcd24..b0b66c03d4dc 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -173,7 +173,6 @@ struct scan_control {
>  		unsigned int congested;
>  		unsigned int writeback;
>  		unsigned int immediate;
> -		unsigned int file_taken;
>  		unsigned int taken;
>  	} nr;
>  
> @@ -2040,8 +2039,6 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
>  	sc->nr.writeback += stat.nr_writeback;
>  	sc->nr.immediate += stat.nr_immediate;
>  	sc->nr.taken += nr_taken;
> -	if (file)
> -		sc->nr.file_taken += nr_taken;
>  
>  	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
>  			nr_scanned, nr_reclaimed, &stat, sc->priority, file);
> 

Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>

-- 
Best regards,
Ridong


