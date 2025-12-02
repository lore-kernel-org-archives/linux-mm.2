Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18AE1D116F6
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 11:54:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C7B76B0062; Tue,  2 Dec 2025 06:54:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 677DE6B007B; Tue,  2 Dec 2025 06:54:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 567446B0088; Tue,  2 Dec 2025 06:54:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 42FFD6B0062
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 06:54:56 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 69B2ABA73D
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 11:54:53 +0000 (UTC)
X-FDA: 84174374466.27.2424BEC
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf27.hostedemail.com (Postfix) with ESMTP id D1A104000E
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 11:54:47 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	spf=pass (imf27.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764676491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=El9ppqAoQFbOIGDZ2F1JVix5PUqcPSDY5Rl/XSJ2bDQ=;
	b=YrQ8RmgLvwH/V8ETn5IhJoo4CuMN7oHrp8ekh80YGju7JTsHQ1h8ntrp030igj9PWUQm1p
	0aknerKE7WVD8wx+up8QsBABRCjKd1AH8Auuey7I7x5EYlB72VcnTEGxFMIQVfnvcn5Wuv
	Q7t2e6sg9zHPIXiLOLMcdLv2NMqWqt8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764676491; a=rsa-sha256;
	cv=none;
	b=oECfSd0IxwUNkWu8yT7EOKnHJW7RSzrcsRMC3EUVCj8c3Q++CC0vtTn2KDqPM/G6StZpSx
	fKzkQ+Kb5Zqv5OhB+qD4W8bQvzAyzA/LgE4leL3iSpitp6jMrNUiZe2XZhyOqFBQteqvCL
	Z99qFhAzXsU84nR6318zhFoq2Wbzqck=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dLK1C4m0XzKHMWx
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 19:53:51 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 7C3E41A018C
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 19:54:39 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP3 (Coremail) with SMTP id _Ch0CgCXNb9+0y5ppmRYAQ--.16551S2;
	Tue, 02 Dec 2025 19:54:39 +0800 (CST)
Message-ID: <919c6fc0-afd5-49ea-ad83-aa643cc1b999@huaweicloud.com>
Date: Tue, 2 Dec 2025 19:54:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next] cgroup: switch to css_is_online() helper
To: Jan Kara <jack@suse.cz>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, hannes@cmpxchg.org,
 mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, tj@kernel.org, mkoutny@suse.com,
 akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 jackmanb@google.com, ziy@nvidia.com, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
 lujialin4@huawei.com, chenridong@huawei.com
References: <20251202025747.1658159-1-chenridong@huaweicloud.com>
 <dzp6jxmf5ggidkhmqabuttaotyrkxzf6ohiuzgcdn6oppkcmfc@vrjeeypoppwe>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <dzp6jxmf5ggidkhmqabuttaotyrkxzf6ohiuzgcdn6oppkcmfc@vrjeeypoppwe>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_Ch0CgCXNb9+0y5ppmRYAQ--.16551S2
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYV7kC6x804xWl14x267AKxVW5JVWrJwAF
	c2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII
	0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xv
	wVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4
	x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG
	64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r
	1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACI402YVCY1x02628vn2kI
	c2xKxwCF04k20xvY0x0EwIxGrwCF54CYxVCY1x0262kKe7AKxVW8ZVWrXwCFx2IqxVCFs4
	IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1r
	MI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJV
	WUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j
	6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYx
	BIdaVFxhVjvjDU0xZFpf9x07UZ18PUUUUU=
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D1A104000E
X-Stat-Signature: s8ox33wqeer4z4kahqynu6qd9qb65p41
X-HE-Tag: 1764676487-59203
X-HE-Meta: U2FsdGVkX199jvmimrovvWKdUpbGMLJQQli2sG/8NevdPkFHiu4T0lSkPphX6VYzPdNoERZsxAg5WoOVNUkRbmo991boVXlPdTa1xutKCmDokELNfpo5IugKevU29uzECxnQTbTHFYSs53yU5IzU6Nwr/kPidpUFWzewufqlaTA4mXtvBRRO7mJChu7u642ZcXEYAsIdFQmaczc+DhLdDzPcZisA9RGPQLyk69hjEXPkbaYyRsOPwoXYt3hwHv36Bx8OsLeUmukKzdZkxjkn9CF8BXpTPLxBoqzHchZx07p/LDR0yYjHafzx5t3FUubB+lrgKj3fEO/hq4yQhcH83x67B8PDBRfXXmhJ5RJFDd66sOGRNEPeySx4yHfqgBXUXv7E9henjiJDADwlK+iCiIG6zzKbKaPCOoruY/MbTf9mgCtnOmf9jqnaEjYF/KMd822c6IvQZp6agFJTw/HQp5gCcerEZk+HIPrF0gIs4yjIXUscwH7M80/jr+sqkrAzfOD/G04et1sgyZgtp3EhsM2mdUPYo+L9PilVrwLNvItn/VZjvVJckSfF82xOlXSwRapP0hyTYmdJnSQxX0WzTGct4Htsu1gBHxWo5/jraflRYa9n3avWhjGJsVog0iq/bmPd6xKpqQyK4Az+/5u5iX//o6R4PzIjXUd4cTWETUOMoicgznxCIBUsQ9s9cYxY8YhSkXXKYim9stgQkMbItefwbIIiv7w4TQjdsnsToIv6kOr0pzu6MwOQQ67NE929UMYuxOK8vcMcGO5vOz1nkfwdDR+mpmRB/Xkcea4K8sRES/8eY3Ty6pSZzpO12Pjm4a7G9wQ6ZY3cTkosgGbawEYebDK4W5xowmWT9IXf7iYhzDP8co5B0Xjo+JZqWCS9pliEiMUXc64RWZLOTf39nSXHkskZ+3MKXU5grlG806WN6xJexC2dWanDnPRDNAmZFGSWTZRT9Vy2GzlVtkc
 Rpv2TZEn
 lbcEpq+kqJ84MB5u/oC1E+4cdxGS4og7dtV7HGChOecZ02ceb6WSjSyrklErYTncaPKwOKZe98MJAe96umGzDF5+5yp+MTnqf6TwLpHn78OYVIf8hH9t6JzaIYjxQKIHJpUscqGESYoTbFPe00pKM2x3t7rN399fSedMsdJxzvSi3h+tVtgCp7NweOWF5LsQVcjQ3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/2 19:01, Jan Kara wrote:
> On Tue 02-12-25 02:57:47, Chen Ridong wrote:
>> From: Chen Ridong <chenridong@huawei.com>
>>
>> Use the new css_is_online() helper that has been introduced to check css
>> online state, instead of testing the CSS_ONLINE flag directly. This
>> improves readability and centralizes the state check logic.
>>
>> No functional changes intended.
>>
>> Signed-off-by: Chen Ridong <chenridong@huawei.com>
> 
> Looks good. Feel free to add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> 
> 								Honza
> 

Thank you.

-- 
Best regards,
Ridong


