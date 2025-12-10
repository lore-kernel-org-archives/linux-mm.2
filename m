Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB97AD3C525
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 03:07:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 168AC6B0005; Tue,  9 Dec 2025 22:07:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 119EA6B0007; Tue,  9 Dec 2025 22:07:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02E4E6B0008; Tue,  9 Dec 2025 22:07:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E9F6A6B0005
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 22:07:13 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A4893B3D3C
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 03:07:13 +0000 (UTC)
X-FDA: 84202075146.02.1A099DA
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf10.hostedemail.com (Postfix) with ESMTP id 14B23C0003
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 03:07:05 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765336031; a=rsa-sha256;
	cv=none;
	b=orxfe0ItjXtbGBGgzLbRcA5L0FFJgB1xVEtUcZHyGZtsKMajbKuzPlYByfWxopMvCfXd8w
	Asvsf0saKbapJJuG7mDI7lFGm9X+e1lifFjL51S/DryC6Wj9a+7ntgaxpx6AxSFxDnNaBP
	Hl4UaZw0PLRo/8e3rlM66xeQKugTB50=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765336031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SfdMZm+26MazEzG/SkEwjVHFa75SIN3DubXMhwNy7ko=;
	b=TJo8cmqPw1/SLP3dF33TQzePVoQaDDquoJkzQHL5dHQM3IiDs/WL9a/TMhO0cZpbShtlf5
	6DFkCVPGu2IVf2g9X9xiMBjPGQ4vBJ8mq4wL+YsPQ8x7Fx6yjquF9vr2fFmhv2WHhs9yBa
	pImg+5eSHn/KPCcvpPwaE5Nd2XJj1SU=
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dR0xK3KBwzYQtgF
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 11:06:45 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id DFD901A1385
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 11:06:59 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP4 (Coremail) with SMTP id gCh0CgC34J3Q4zhpH3jjBA--.16323S2;
	Wed, 10 Dec 2025 11:06:57 +0800 (CST)
Message-ID: <1189acd5-4908-4a51-a7bc-8b52a8489140@huaweicloud.com>
Date: Wed, 10 Dec 2025 11:06:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next 2/2] memcg: remove mem_cgroup_size()
To: kernel test robot <lkp@intel.com>, hannes@cmpxchg.org, mhocko@kernel.org,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 akpm@linux-foundation.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, david@kernel.org, zhengqi.arch@bytedance.com,
 lorenzo.stoakes@oracle.com
Cc: oe-kbuild-all@lists.linux.dev, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, lujialin4@huawei.com
References: <20251209130251.1988615-3-chenridong@huaweicloud.com>
 <202512100924.LqJqXM7P-lkp@intel.com>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <202512100924.LqJqXM7P-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgC34J3Q4zhpH3jjBA--.16323S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Kr17ZrWkCF13AryfuF1UGFg_yoW8XF48pa
	yruw4DtF4rWryfWa1kK3yjvayFqa1kXw13Wr98uw18Za429r1DAFyS9r43trWjgr97Kryf
	Zan8WF1ft3yUZaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 14B23C0003
X-Stat-Signature: gyc76sq91q4m7eoaazy37y1oeygr4uuf
X-Rspam-User: 
X-HE-Tag: 1765336025-340689
X-HE-Meta: U2FsdGVkX183n03WJvkGFWQtdSeHj3NSrzcO5LwJnIDOK5oWdOWKkO4VAM2lDytX3j2bcAtloFj0jQEvijOpcm1AXjgx67mGS1Iy05w6GTO87ACiKxJfef++Cv6wuIUoAlVRzQRhWdx8QckgjM+N+OK2nALqLUHbynyd3nXpFH8eE4i+5Aogg6AnLLrpecGveVzW/uEXRg5TwIPOJyFVN8hPMNJaKmTerDgnfMdxBKNMpgzQY2euqxGo8HrnWz3vPYw5miAjNPTi9J+MvcfrmMEKURspwRZvdRpH/lXKjplowWSwyehh+fD03aaso9QfpTF4F1RtTEOZRA7KjbbuzrGLgVcwNeSLPW6R3Oe4/xySWvvkSaz0b7Py5zY+MQPvbw1SdbPq0Gz/Nsb3YVZmmTOZ8sXoYFFNCkjYkVEcfNjSCg+xorcv02v1IbYsdwI4y2JV2H9AKL0aXJUgNEo0TF2sAditZx/XWVJxzUYpd+HRCowSg96W5zBDWN7KqYOScieHI0A6w8ANqFxUVYZmWJV4kEZJhqrXRuVu/8vHqShFetmXL4rMvr9tvvKL3TZ1n/5+d9xu9vtqoWmoin6KtCtjuu5G0FcomlTZzxrfOQVySmmm6/3HRAyUn5+dX2Vj2r/Y8RCfhHoXgk25CzTosBOprDa0Lvu9+ZIOKraRrg1ibzfWYf9EZJvmwlSB0sLq0bHklETkbp/quyyUFW+ufsi6Mikpt6Qmkq4nUMzsRWnCP08W8wIPzMgMsVD8wnIG3NDCEfz6sMDxSR+2RYZpEXaAgBJaM4kYQUHeMXdUWPGHlitCmrVUhigQ+33FTOTBpXRtTalBFFuCJDxIoNVJOzizCGhlzQMiLmNm0Y6RVFtOS4cAwCEi2G3y8qshcMq9yzrIAE6FRARm51FTVXweFSDrJYDxJoaUxzm1ocpcshH5v9NikmkfdDUho5U8ByhORQYWVwvxr53P5VpV1rh
 /uoYc+mJ
 LGDb5d7xVKOZUq28cQ1tzXLuFCPH4sZXjm1yt8vzdoXyNzBeV5jtX8yLYmtHle3bxuhTwfDxcj9rrMNCek+PVwXZFHIdIPy+hhYu/7ccGRExyL5w9DTKWY/O0HVS7/ulrW04KVGOwkfFZzw8UvLuhsNyD64Z5D6l85h9eyjc7p1zegrW7NCyE9QRgGDxeKZylJEB6c6/+VqFo37wBbuGmpsHl4WcPPQyhDLtuDGaU8oe5rvbUEzvmLzhB1o+GWYPVAABZmxMCyySAxmYsniXB3nHV8MWZJ9fywq7BMo6HdL1U3HreKvWT8L5rFd+wAwHi/BLY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/10 9:35, kernel test robot wrote:
> Hi Chen,
> 
> kernel test robot noticed the following build errors:
> 
> [auto build test ERROR on next-20251209]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Chen-Ridong/memcg-move-mem_cgroup_usage-memcontrol-v1-c/20251209-211854
> base:   next-20251209
> patch link:    https://lore.kernel.org/r/20251209130251.1988615-3-chenridong%40huaweicloud.com
> patch subject: [PATCH -next 2/2] memcg: remove mem_cgroup_size()
> config: i386-allnoconfig (https://download.01.org/0day-ci/archive/20251210/202512100924.LqJqXM7P-lkp@intel.com/config)
> compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251210/202512100924.LqJqXM7P-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202512100924.LqJqXM7P-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>    mm/vmscan.c: In function 'apply_proportional_protection':
>>> mm/vmscan.c:2488:63: error: invalid use of undefined type 'struct mem_cgroup'
>     2488 |                 unsigned long usage = page_counter_read(&memcg->memory);
>          |                                                               ^~
> 
> 
> vim +2488 mm/vmscan.c
> 

Oh, I missed CONFIG_MEMCG=n case, will fix it, thanks.

-- 
Best regards,
Ridong


