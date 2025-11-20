Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 193ECCF8848
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 11:56:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0241E6B000C; Thu, 20 Nov 2025 06:56:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F16AA6B0022; Thu, 20 Nov 2025 06:56:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E052A6B0023; Thu, 20 Nov 2025 06:56:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C44A06B000C
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 06:56:30 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D141113BC0A
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 11:56:25 +0000 (UTC)
X-FDA: 84130832730.27.22FCD61
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0E69A180009
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 11:56:18 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	spf=pass (imf06.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763639784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lApzEuvQnP6sGQHfDY2VfhcBrFxi8a4AnoOmbX99m8M=;
	b=4tirzYpuuCgsnfpVAy2Gk1orXa+ZGMzrQJLyXUFJG8zCaqzybC3n7gzIEetVRQMTD/eT3w
	7wxH7TLYIL80n97tC7q/0f8LZ3dF/eBvrUH0Ksvc4ZTRTqoTWboACk64lGp6U01qONepVQ
	pxv1zjyzoifHMQm3LXckrIuQfXkRCcE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763639784; a=rsa-sha256;
	cv=none;
	b=iJHfdbUeXvqITa0Nfi8wY7xEs89/BVPO/Q/DZWN3Id9c8qVDWAt9wPRaHEI7CiAhY1THEk
	4QrgyIeMKObCguIPMo6dF9X99HyMIRB4SToesp/2Ye2znJGuOdiFhm6mhBNCBJegX73nJY
	nuoPUrC4bHk8abetEyBqnJN8swUr6Uk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dBxct3wQ1zKHMZq
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 19:55:42 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 2C95B1A16A3
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 19:56:12 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP1 (Coremail) with SMTP id cCh0CgDHAkzaAR9p6oyMBQ--.55774S2;
	Thu, 20 Nov 2025 19:56:12 +0800 (CST)
Message-ID: <a7e55445-20ee-4133-8455-b6c5f7a45ff3@huaweicloud.com>
Date: Thu, 20 Nov 2025 19:56:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 25/26] mm: memcontrol: eliminate the problem of dying
 memory cgroup for LRU folios
To: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com,
 mhocko@suse.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, david@redhat.com, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, harry.yoo@oracle.com, imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
 <44fd54721dfa74941e65a82e03c23d9c0bff9feb.1761658311.git.zhengqi.arch@bytedance.com>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <44fd54721dfa74941e65a82e03c23d9c0bff9feb.1761658311.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgDHAkzaAR9p6oyMBQ--.55774S2
X-Coremail-Antispam: 1UD129KBjvdXoWrurW8Xw4DCr4xJr47XFWkZwb_yoWkGFbEy3
	Z8WasFgry3WrsxGw1kWrn8ZFsrKa12yr1rXF4UAFW7A3Z0qay2kr97Xr45ZrWfuF4rG3W8
	X34DWr4xWwnrtjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbxxYFVCjjxCrM7AC8VAFwI0_Xr0_Wr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x02
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
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0E69A180009
X-Stat-Signature: 91448jgd4hpe3ygkw85ny6tz33s56wdg
X-Rspam-User: 
X-HE-Tag: 1763639778-357335
X-HE-Meta: U2FsdGVkX19Ir3vgF5CJ9aMOd4I1ISfuVDsPkn5W+ZDBdKKycQ1kR6vBsP3QK2nJeBxxQV7oZ8azBIRtCeMlJQ17ojtwe+pVbCHmO6HvlQXaYQZSvPASbyLYcEQ2P9w7o5AjeIUYrJlQGmxs5kOlre0ksbp3Eq07gihtFfG0ar1GLmJQlktWR0h28ow6Ir5YiSZfwGgwC95zqh65fETQIwlZI06aPvtG8S5CKcKVj9iGcKPqNRPpp1sIk2qEj3AZ5TSA/mV6xk/lDIoxwPEp8eJ/K6Ikfigwx9FcbXTmbUZL8P66O92ejFLcXchynZyoqj5bNlLh3n3/fjTgHND4uqD/ZQCIY5CLATzurlwIb52ik2pLIY75i4cIaj6YXaW4fyPWjSfzp1jmTKDpvUButaIpdm96aFDIw+8t8CXSSSJLOsZXLDQRzSY7XHk12cYncZ+9n/2EyD8ixuG1kbov8jBSpB4oUKE1EaIGt1iEBEGJxmG0C20lwYpRxcM1gqIPGlM2eh50m2JFr4qrnfaI7MyTaldWlWoJB+GFuHmgCwKem84dFXJ7XOfnqRC1vLu0cPChUshRiBoaSYIMmKOyaAeXYpbXARl9uvU/49KJ54icac0mYOFH/ShvMfBwK8kQuI9562DH0aB60s8Y91Cx73QRivur0vL23JbThEiYQN7zQ+Md6bm3f/hBLFS+Gr4+2xjefRzHCvmk5rBklZt3jTiUkv5h8xHwGObFo2Khj3N4qSs7cAwhqqfX28QvdHM1eWIFuZEhDyiDWv2ZbYUT+4woBR5LvVY9BIBL7dER+QHEZR1ppA3INIPbsSeOPJhKWNveF5rnQfbyOw1bc8KKALx/p7vfIyAqfYkIx6Bn3exxs1uPqZHEzPdJCLlteZ9HURrqedWf4Q2Ix0EPSAP/H3SNAH7mAtzya35LzPlY2RAnJgClqNJt+xcB7HIOIYsP4swRSs9GyXJhDDe4Ikl
 PGPWYKWm
 W1DvUFpfkysOWBwAZXOZx8xX4SSOwZvf4n5Qjg/gx9ybzMNpZ/2Ai4GsTkw0VS6BvfDSy61dgK++pJkwlkzDLgPfl5h8ZlapmzrEyQUNEfE2rpIV4qHloJsR1ytvqfCPO4TCfTzAqL8TWVG953K6Ehvxqag==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/28 21:58, Qi Zheng wrote:
>  static void reparent_locks(struct mem_cgroup *src, struct mem_cgroup *dst)
>  {
> +	int nid, nest = 0;
> +
>  	spin_lock_irq(&objcg_lock);
> +	for_each_node(nid) {
> +		spin_lock_nested(&mem_cgroup_lruvec(src,
> +				 NODE_DATA(nid))->lru_lock, nest++);
> +		spin_lock_nested(&mem_cgroup_lruvec(dst,
> +				 NODE_DATA(nid))->lru_lock, nest++);
> +	}
>  }
>  
>  static void reparent_unlocks(struct mem_cgroup *src, struct mem_cgroup *dst)
>  {
> +	int nid;
> +
> +	for_each_node(nid) {
> +		spin_unlock(&mem_cgroup_lruvec(dst, NODE_DATA(nid))->lru_lock);
> +		spin_unlock(&mem_cgroup_lruvec(src, NODE_DATA(nid))->lru_lock);
> +	}
>  	spin_unlock_irq(&objcg_lock);
>  }
>  

The lock order follows S0→D0→S1→D1→…, and the correct unlock sequence should be Dn→Sn→…→D1→S0

However, the current unlock implementation uses D0→S0→D1→S1→…

I’m not certain whether this unlock order will cause any issues—could this lead to potential
problems like deadlocks or lock state inconsistencies?

-- 
Best regards,
Ridong


