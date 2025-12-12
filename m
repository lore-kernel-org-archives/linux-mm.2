Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82549D4415D
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 09:54:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD90B6B0005; Fri, 12 Dec 2025 04:54:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D627D6B0006; Fri, 12 Dec 2025 04:54:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C51816B0007; Fri, 12 Dec 2025 04:54:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A91D16B0005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 04:54:07 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 496D41404B9
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 09:54:07 +0000 (UTC)
X-FDA: 84210358134.13.51FA0F0
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf07.hostedemail.com (Postfix) with ESMTP id DE52840002
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 09:53:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	spf=pass (imf07.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765533245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3uEYHyZtI1NVRgs4zCmu9X2spIEBl5B+lli1RpKN/XQ=;
	b=TuN5d6kHffwmHeXvZ+swMw1lvfWh+Vss4rviUkf2fihxQ+RNRoqjvBmuSNpeiujCj2LpDu
	IDVof1loaqb51+UpYLXqxomrZEhRwuI56UF+ZLC0tp5fZZnYltyyFhXZWuaQcpzz9RQhWn
	tZiAHgZoUP7sWqPmxyK3DieOF68cpBM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765533245; a=rsa-sha256;
	cv=none;
	b=IfIdcx1lV75AA+DBPe+A1U7RRKc3mQUCusw0NowsCYkwQXJj4mhF7pYa4Y+THapgwemCXS
	6Q71/kg34e17TBBFBTqcfmLYarItMs5+D3mhplEmn+LSC5fxDcqOJNc+ZGTyt0OVir56gX
	h8OSRbjmpyS2wE8cgikocEAGCZf7kKQ=
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dSPt719vWzKHMgn
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 17:53:51 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 73DAE1A1732
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 17:53:52 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP2 (Coremail) with SMTP id Syh0CgBHJlAq5jtpR9fqBQ--.55492S2;
	Fri, 12 Dec 2025 17:53:48 +0800 (CST)
Message-ID: <5d9ae0e9-d1c3-46cb-9dee-f016359e90f8@huaweicloud.com>
Date: Fri, 12 Dec 2025 17:53:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next 3/5] mm/mglru: extend shrink_one for both lrugen and
 non-lrugen
To: kernel test robot <lkp@intel.com>, akpm@linux-foundation.org,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 david@kernel.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 corbet@lwn.net, hannes@cmpxchg.org, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, zhengqi.arch@bytedance.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, lujialin4@huawei.com, zhongjinji@honor.com
References: <20251209012557.1949239-4-chenridong@huaweicloud.com>
 <202512121027.03z9qd08-lkp@intel.com>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <202512121027.03z9qd08-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:Syh0CgBHJlAq5jtpR9fqBQ--.55492S2
X-Coremail-Antispam: 1UD129KBjvJXoW7ZFyftw4xXrWkGrW3CrW5Awb_yoW8uF1rpF
	WUGw4jvr15Xrs29ayvgF4DWFyjyrs3Gry3GF1kXr1UAay2vF9rGFyI9r4Yqryjg3ykKrWa
	yr97Wrn5t3WjvaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWr
	XwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU0
	s2-5UUUUU==
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DE52840002
X-Stat-Signature: gb3gg45hsnpqrb8sd6j5ufwhqwbji71a
X-Rspam-User: 
X-HE-Tag: 1765533238-165176
X-HE-Meta: U2FsdGVkX18SAPE+rc4FkJMeI1Dk/Gb9HqoswT2mmk/fvGOOT/EwjyJqkNLMUMyEZyoP7NI7ZtN6N3HDC3xw0ZPpXs/pI2TQmiyCqRJRk/3oy3Nkpz+vzH9zllBE3RmZQYHfSZ0hMf1a883zD5/ySaRqBtpDGKTSZZN+oZec/Nk0KWorfcpjz4FENIBp8OW9Cng5eyAxI3fXF6DyZdSGJZ39NBEqMoTFd9L3QyNGbErpxCotWw9Mmj/umBWEqjqLbdAyR/rKqLPlzDrCLt4npqwzQI0iLCdExVKNWfuNs6uAATyMfFbhcWJbGJujGSeBcH9o/8Jp/vg4hFcgdqUOUcJ2SyDNQJh6S/VJa105mPKNU1jFiq/UYMshy4L2ZJUmCHL9bv4TWW42YHe4n1VizYBgF7WmEqRZK+VwV8JhlSuz9kWXB1LF7kFmnpwSfnBOPfsAzXQwd1RXm8U+2pQiOLSXOG5Sv2joHTisXrJF9mh4TkElg2V3Q39nUshbxmo2O5BIHn4veTx5B8BQlMiH49yraYCNsZ2kCnihR56M+HuDqOyGChEIQ2Dm4e1EVTAVvFfxXmVxCVxPrmpGHjgkER7L4ZYFP8dsrH93nZxZQUUdq4JujRamO5IncH75FTDAxIw26y1lHt30po8QkH7wEMLOUb1AzYSeRf3qOl41K+9vonE3b8NuU6EzY7LFeZeU7hOur3zm0o3FG1r5aPILvVW0nltJGiK/N5mjDI+QZDyQX8skIJ1Qa2sipTzEgSpMOCxnQxn8+EMVCrg43aWH6nzKMWB1htFNG6dv1Z9KA6EPjANdzDm/dZXS9GQrjWvy+NbXfnw+4nNY/RVi6zDE2pD1B8X8X5GgXKERSWnAdc80CmenuaQGOQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/12 10:55, kernel test robot wrote:
> Hi Chen,
> 
> kernel test robot noticed the following build warnings:
> 
> [auto build test WARNING on akpm-mm/mm-everything]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Chen-Ridong/mm-mglru-use-mem_cgroup_iter-for-global-reclaim/20251209-094913
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
> patch link:    https://lore.kernel.org/r/20251209012557.1949239-4-chenridong%40huaweicloud.com
> patch subject: [PATCH -next 3/5] mm/mglru: extend shrink_one for both lrugen and non-lrugen
> config: x86_64-randconfig-004-20251212 (https://download.01.org/0day-ci/archive/20251212/202512121027.03z9qd08-lkp@intel.com/config)
> compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251212/202512121027.03z9qd08-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202512121027.03z9qd08-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
>>> mm/vmscan.o: warning: objtool: shrink_one+0xeb2: sibling call from callable instruction with modified stack frame
> 

This is the first time I've encountered this warning. While adding
`STACK_FRAME_NON_STANDARD(shrink_one)` resolves it, I noticed this approach isn't widely used in the
codebase. Is this the standard solution, or are there better alternatives?

I've tested that the warning persists even when `shrink_one` is simplified to only call `shrink_lruvec`:

```
static void shrink_one(struct lruvec *lruvec, struct scan_control *sc)
{
    shrink_lruvec(lruvec, sc);
}
```

How can we properly avoid this warning without using STACK_FRAME_NON_STANDARD?

-- 
Best regards,
Ridong


