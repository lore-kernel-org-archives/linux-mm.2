Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62239E7AD4B
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 02:01:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1EBF6B0088; Thu, 25 Dec 2025 21:01:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA2A16B0089; Thu, 25 Dec 2025 21:01:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A4B86B008A; Thu, 25 Dec 2025 21:01:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 897736B0088
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 21:01:16 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 130438B517
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 02:01:16 +0000 (UTC)
X-FDA: 84259969752.05.27A13F8
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8E6B2180002
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 02:01:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	spf=pass (imf16.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766714474; a=rsa-sha256;
	cv=none;
	b=oQHLWR7mgT2TtJ8G5hCjDMvyov4jaIZY/RXU9NtnSmK8wA6GPIW+iA4iB/MnuaPKECLtQK
	JORxeo9EfqWxaJ7lV++3kQaNVG8PQ+2TnItjoV2Ec9VesbdTrPmm9bcpEFG93Srote2t6U
	PMFo7AcXLjAg1sRUXY63gBrYLy1EHVI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766714474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c3apVSvPnG1+S3WvVx8S92DNntMU7OvrUHe8CJCMSoE=;
	b=CDjWi6CXs/hWPx7auTJWCQM8z9+RuBOsGDAIHfYF9d5ItnegU/nSedqma3WRICR5BIt6al
	cdWkKgoVCX0fs+Tp/wB85Wxf9HRzInyOyb/7Tr8lHN+LsN/MrCqL09WDJ6W6sxdN83MyI7
	zcRGPXev01tsAYwNHZV+dcMVhg/2Dck=
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dcpjN1YqhzYQtdl
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 10:00:24 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 79BC340573
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 10:01:05 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP4 (Coremail) with SMTP id gCh0CgC3ZfZg7E1paw8CBg--.52160S2;
	Fri, 26 Dec 2025 10:01:05 +0800 (CST)
Message-ID: <d9997fa4-65a8-40b2-b22f-91bff9962601@huaweicloud.com>
Date: Fri, 26 Dec 2025 10:01:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/28] buffer: prevent memory cgroup release in
 folio_alloc_buffers()
To: Shakeel Butt <shakeel.butt@linux.dev>, Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
 imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <bd87d13b99c159de77f23f61c932724a8b2d000b.1765956025.git.zhengqi.arch@bytedance.com>
 <63h3n6m5ek623nzq4pwkwkhu72jqjjastxgnsjuvrvwpevv57v@2ki32ihzx7lj>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <63h3n6m5ek623nzq4pwkwkhu72jqjjastxgnsjuvrvwpevv57v@2ki32ihzx7lj>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgC3ZfZg7E1paw8CBg--.52160S2
X-Coremail-Antispam: 1UD129KBjvdXoWrtr43Kr1xJr4fCFWDWFyUWrg_yoWDJrc_Ca
	y0yr17uw4kWFn7tws09r4agrWSgr4UWF9rWrs3J3yrZFyYyr1xWFn2ywn5Ka47Aa1furyY
	krn3tFsYkwnxZjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbxxYFVCjjxCrM7AC8VAFwI0_Xr0_Wr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AF
	wI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUIa
	0PDUUUU
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8E6B2180002
X-Stat-Signature: dotesdsrenbzpckhaof5erh8ox9xkufq
X-HE-Tag: 1766714471-106212
X-HE-Meta: U2FsdGVkX19/zczMQ8E/cPNwnA/TLg1labHQbb7Imv1HWWH0nz9hsQzM6DVGaXwNfyohCUu6Ju4amSEH1RPQHfzN8sQAMq8+aDH6V4ZJVjzPp8LQzd0+xquFR9cs6a4d0NUoMVNHSjyT6A3hO0VPaYW1VB30cgeXkmsyiTede0wkAmPQqc4EOZ6R52yJ5BoCF+p33v3a3dul0lCuG4yIBDzNizFRrHdUMFCgGgc9lbqRh6T4uZGDQPP3Eep3fzJRr++FLEStoE9jbs8MJ5Ry5xmoIZcbsclNZlfAEh2j8eg5/XaXJCzQ5XWAH0880Vn40GxIUDyM1GKSXWcJEvcne2Epy88+xsZaukPkYKmoiYVJLFJwjpatIRQmb0eHwagzbOND33MmCEWeo3pmnf2dAegF6QHngc3h4EXT7HsNmyq6dO93GfhDthzMmjykK5wxUt6VK2BE/6ZYIdldENZt5+LztQ9DtJFLny7AN0res4cWjDsEf/lNrXbOZhvYRaOTw7b7XUPuEwbqKz9VLCmcKNGOmLA/5Q5SGY1/EuQOvYzmc7YPAeep264MlUafw9haxdlJ/PNY4IWRAbiiI0gdeFyQaFCM4GQXnW1pL378erZxnFOf3JhdVrrbGcL9EVY8/1V9Vjgj05y9YU5OSS6DMFav9cr9F/3zPfEASt5/cxR9EYJ5yEeO64duDWlIGnhSLRio12HLuC9S8bIdEDviGfFEur1dzHuGjt1qHMLSI1jQ8G3MAt04nZ2xQSaBDNa9yq/5+A7ru/uq6kGf00wib4aMlJ04CPjJBLVFTHGYNWdz8aysVUnqjjrvMfmN+dOWi9fugAlhvXUbquaUfBQXil250mOumt2ifeYnkBl3Yzbhk8PGB0KiB19DPu6wedTRpqSocITt2rVnArNcdiUAR9RmQ3OMYAf++x/ae6OYWHBQO8wbYwV6oYoHNFrySCD9Mu/oiAci44ozQR/SuTo
 JaVW4dVN
 BmqDYZZheQEKKBX3TF505u1BsLu7UP/UMn+zlItv8rK1OBM0lHW97/5/X0PTAoOxV++on1z45WBTVPA016rsDobG4UH3OC1T4yICimhaUnmZ0AtmKAHNs35BuNsYIAdVLQZyuUdkIhOcokTiLY1TUyOiA4EWhhZw31EYuZzvDguUfSgVTktYWCZoymPIlCrDlM0K9+mqpIZC/s86o/TZL+RrdHn8ZhFmBLtnvfbBkeQqIdVRpkyZZdwSwi6mUNsywALS25p5KCbbNb3Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/19 10:14, Shakeel Butt wrote:
> On Wed, Dec 17, 2025 at 03:27:33PM +0800, Qi Zheng wrote:
>> From: Muchun Song <songmuchun@bytedance.com>
>>
>> In the near future, a folio will no longer pin its corresponding
>> memory cgroup. To ensure safety, it will only be appropriate to
>> hold the rcu read lock or acquire a reference to the memory cgroup
>> returned by folio_memcg(), thereby preventing it from being released.
>>
>> In the current patch, the function get_mem_cgroup_from_folio() is
>> employed to safeguard against the release of the memory cgroup.
>> This serves as a preparatory measure for the reparenting of the
>> LRU pages.
>>
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> 
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

Reviewed-by: Chen Ridong <chenridong@huawei.com>

-- 
Best regards,
Ridong


