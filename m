Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6F69E6B26C
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 01:16:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9BF26B0089; Mon, 22 Dec 2025 20:16:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6FDA6B008A; Mon, 22 Dec 2025 20:16:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9CDF6B008C; Mon, 22 Dec 2025 20:16:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9BD0C6B0089
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 20:16:21 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4D9241335C
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 01:16:21 +0000 (UTC)
X-FDA: 84248970162.24.E337B6E
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf27.hostedemail.com (Postfix) with ESMTP id C5E2D4000A
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 01:16:15 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	spf=pass (imf27.hostedemail.com: domain of xiujianfeng@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=xiujianfeng@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766452579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ae0JbzGrD2qQnqwFV9zyznMXRQGJUJxLv9ZxtR0HGk4=;
	b=an9D088ZNUI8/kJCrHqjjbxDSdJTumptxH7KESv3sx1ssXsyiybofnqyFPc6P15cb9Er6P
	eduJX04InSmN2+dT7WpHEWrEn6W8qfhuz15jiDRwbmiuvo5fsWWWHgB9VKr4gWzqpX8iSk
	kyi3PM9o1he/cENHAKFyI2Uv7WShUCQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of xiujianfeng@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=xiujianfeng@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766452579; a=rsa-sha256;
	cv=none;
	b=o/kuQygcTxKMQ1YVQ4zaPLhdlB3uW8kYdLoWS89wFPcRxA0vlptrP9N57OA1Kl0Ik9X/+8
	5givgKCsJlFFiClxKaUy8TzhrwmQaPGh+PV0sj5rlraSV6ob8jNTExJ7Ou09vspkpQN45r
	AaCO+Qm+Gdpd0AIxa7u4cgfysWH9gdw=
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dZxs316xbzYQtH8
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 09:15:35 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 50BD74056B
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 09:16:11 +0800 (CST)
Received: from [10.34.206.51] (unknown [10.34.206.51])
	by APP4 (Coremail) with SMTP id gCh0CgAn1fVW7UlpyIyZBA--.24819S2;
	Tue, 23 Dec 2025 09:16:07 +0800 (CST)
Message-ID: <b010db20-d044-4ecf-bb87-af580e4c0f07@huaweicloud.com>
Date: Tue, 23 Dec 2025 09:16:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: mm/hugetlb_cgroup.c:829:44: warning: '%s' directive output may be
 truncated writing up to 1623 bytes into a region of size between 32 and 63
To: kernel test robot <lkp@intel.com>, Xiu Jianfeng <xiujianfeng@huawei.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
References: <202512212332.9lFRbgdS-lkp@intel.com>
From: Xiujianfeng <xiujianfeng@huaweicloud.com>
In-Reply-To: <202512212332.9lFRbgdS-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgAn1fVW7UlpyIyZBA--.24819S2
X-Coremail-Antispam: 1UD129KBjvdXoWrKry5Zr4UZr17Xr13Jw4fKrg_yoWkZrgE9r
	13KrykCrWktFs09w4vgrnI9r9aka45tFyrKw18K3y3uwnxZw48uFZ3CF98uFn3t3WvgrZx
	C3ZxJ3sFqr1YkjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbwAYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
	14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07jjVbkUUUUU=
X-CM-SenderInfo: x0lxyxpdqiv03j6k3tpzhluzxrxghudrp/
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C5E2D4000A
X-Stat-Signature: wx83g5j4o6eu3rr3yf1pdnmcamx64mbi
X-Rspam-User: 
X-HE-Tag: 1766452575-640242
X-HE-Meta: U2FsdGVkX1+SzAO6kH/NVt0+eYwCvzRza/6s1YEmCH5jvrp0v2BR/xWW5N2ibV2faJp/51QBa/pcF9O7EAUjIpujTtlof+ox75KbwzCuzcFdNUqXFihtSn70503Mj7njvBUxvOtcJYb2f+6cZwZAMQV/MWLNQwhA5fjvM/qb9KcPbHiJ8iFScT8jx8hMyTsSVCPQmDcH2BDwaI9r2ZlyxHajQJQlrejjpi9jE3oFgC4Cz/vyg6mmBI85Bcs27lhODH1Xf4FY27kunKEvIgRoOI+hF9N8MHtH7lFdkIUKyV2PRzRNfcKRn8Ql9cfURIp6MiIWwh89pwZd5zq/oUjqxoORmSQ1sW0tRbQSDfca8uXGoCQ5tTOHa/JprsNEGDWlg4Du0yBaZrTq0hXlqQ/wfMOnHu2fZoOseKt2VM0gyq0AseOSNzWppvrDnoAU+O4/0IsMRIUYBr9r0nh4Y4dU97gz6SKbgWlmyPagXaTDPAgfyBANLOk0hlHUaHVocOraJXvn1poQFZj9tTRnhxRuP12z8wnnS0ERr295WdT06jy1fCCRRIviYVvOc9QVFy+7sERDWsPLRjNIIcRqFrvByycFwrr/Pr4vu+A+29t1fCSpCZfw5OHFwwzORjfJg9j1AfDOzU+3tXZsbC/bveoQQMz6xwQkUs9JZnx2NJ4WCiEKPmvUnTzwAxTtXKti0BnLp11TvRi/aacZNTqaBSFjJrJ5E9R+BpyjKkKTx3oNcTp0VzxVzIXb/9S/RVO9HJTINcEbkEU0p3bsASjrgsJvbYrNQSAobBRcM2FS5xHmeousHuLedVb4LAQlI4ItZaidbq3i6UVTgYnmVYY8V6nztx6v/jLRe7AXunXX1lURg8OlO7wSQjtxZedLB5Ku/xbn0TbLGGFCD94nMbPz//pVmYw3NwANvtz5lpBs8T01SMkfQtcxjAhn7QQlWXiqQgShxm68yTj8zJpNGIBHYtA
 LW4YPuMs
 T/CkIXVFhntjCFg9ADSZfPqucULXWQ45SSkcc1199zX+6typYMq/cyrCct4ODy6xnTl2bZc/7VGyBldwu1Od7pJEz8O2Ua5reel7YZgHWl8rZ9TKh0vl/Jex4QDIoywj6V3DE22L0H2vFYa5z4+SjGYOpL6MD4gyJiuMGP24dSKshayQSsA0IphhGpIcK0SwimoyM21LRMvz4FSQMnTOO9BOETPhgh8wCR+/XDD2bFC3WmUwjGj9NxcePxSRcWg+VtZBhs9mtQh2BEFAhxT5c1Yo2iXoVGei44cMWVKp4Mv0XJ4LMJMFFPM22bjGKdQWdOLuY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/21/2025 11:23 PM, kernel test robot wrote:
> Hi Xiu,
> 
> FYI, the error/warning still remains.
> 
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   9094662f6707d1d4b53d18baba459604e8bb0783
> commit: 47179fe03588caa13a9bae642b058901709ddc55 mm/hugetlb_cgroup: prepare cftypes based on template
> date:   1 year, 6 months ago
> config: s390-randconfig-001-20251220 (https://download.01.org/0day-ci/archive/20251221/202512212332.9lFRbgdS-lkp@intel.com/config)
> compiler: s390-linux-gcc (GCC) 10.5.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251221/202512212332.9lFRbgdS-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202512212332.9lFRbgdS-lkp@intel.com/

Thank you, the fix patch is on the way:

https://lore.kernel.org/all/20251222072359.3626182-1-xiujianfeng@huaweicloud.com/


