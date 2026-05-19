Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA595CD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 01:32:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24A0C6B00B8; Mon, 18 May 2026 21:32:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FAE26B00B9; Mon, 18 May 2026 21:32:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 138716B00BA; Mon, 18 May 2026 21:32:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EF7AF6B00B8
	for <linux-mm@kvack.org>; Mon, 18 May 2026 21:32:09 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A7888C024F
	for <linux-mm@kvack.org>; Tue, 19 May 2026 01:32:09 +0000 (UTC)
X-FDA: 84782443578.21.958227A
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7896014000F
	for <linux-mm@kvack.org>; Tue, 19 May 2026 01:32:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=N6PM9O4s;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf26.hostedemail.com: domain of 18810879172@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=18810879172@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779154327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OWpYAhW0JXdOUvR+Dvbc7KSNWg+4ZO2XM2Dk3cbW2Lo=;
	b=mhzQ/WX9BXvbb64HQWW7p0d9WVhu19XJRn7jtH2VBRS9z2HFBYPKjBdhXmvsHiLL0GYs4R
	0dIXNwH2w6p0Q0eW8erSxeSTCniqM0lhWSAO/X7x6YXdWqkBR564OnGdxebnsMtJGwWHfw
	jeq+kslbw59w6l/5PXF1kIyEr5hrLVo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779154327; a=rsa-sha256;
	cv=none;
	b=WCCLQwzMmsu2dSTAKPhoSsk81fBQf0pfjHcq3XR85sJkoNhOikCqnoTLd7aqZCp6/keCI0
	8gfUTzBkSkN+TP/SlAcj39KsNBMOXcMQ4BpjNkD1zuAFFOsRAFJrsduDMoUtvYXcy3P8Zm
	aoMlm7aqJAEteG15VHgArqw7/FQZPRQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=N6PM9O4s;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf26.hostedemail.com: domain of 18810879172@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=18810879172@163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=OWpYAhW0JXdOUvR+Dvbc7KSNWg+4ZO2XM2Dk3cbW2Lo=;
	b=N6PM9O4sC+092kV1wZNsvPiwgdIfImNjBYh36JiHMs4nsH6DtqC4ZAIVIR5KV1
	BE7VWNc5LwmAZYRER6INFCzk4Tbcojf6NiXrzUYWAMKWUbb8q/VNhPaU4oaXUGaV
	utSFHlnapDT85NBjn/hmXfqkWhKJ1G+LirFcZd/fiQe2E=
Received: from [192.168.111.49] (unknown [])
	by gzga-smtp-mtada-g1-0 (Coremail) with SMTP id _____wD3n_+EvQtqIslhCA--.24207S2;
	Tue, 19 May 2026 09:31:50 +0800 (CST)
Message-ID: <5e8cba85-1dcb-42ab-9f2d-edbb6f0c92c0@163.com>
Date: Tue, 19 May 2026 09:31:48 +0800
MIME-Version: 1.0
User-Agent: =?UTF-8?B?TW96aWxsYSBUaHVuZGVyYmlyZCDmtYvor5XniYg=?=
Subject: Re: [PATCH v1] mm/shrinker: simplify shrinker_memcg_alloc() using
 guard()
To: Andrew Morton <akpm@linux-foundation.org>,
 kernel test robot <lkp@intel.com>
Cc: david@fromorbit.com, qi.zheng@linux.dev, roman.gushchin@linux.dev,
 muchun.song@linux.dev, oe-kbuild-all@lists.linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260512085546.368911-1-18810879172@163.com>
 <202605151100.lH0pRo2I-lkp@intel.com>
 <20260518173607.c250f771be2baf92fa471b2d@linux-foundation.org>
From: wangxuewen <18810879172@163.com>
In-Reply-To: <20260518173607.c250f771be2baf92fa471b2d@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3n_+EvQtqIslhCA--.24207S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7WrWxKr4xAr1ruF15GF48Zwb_yoW8KF4kpa
	15ua9xKr45Xr1rWa1xCFsFv3Z8Kw4kW3sxWrs5Gr13ZFWavF17urs29r4Yvr9F93WvkFyx
	JryYqry0y34jy3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zRr-B_UUUUU=
X-Originating-IP: [223.70.160.239]
X-CM-SenderInfo: rprymiyqyxmiixs6il2tof0z/xtbCzQnu5GoLvYnp9wAA3F
X-Rspam-User: 
X-Rspamd-Queue-Id: 7896014000F
X-Rspamd-Server: rspam04
X-Stat-Signature: wcksier5kx6ogp396pbuquz6sdnzmzze
X-HE-Tag: 1779154326-29373
X-HE-Meta: U2FsdGVkX19LDXw8aatOTjIAsMVVCwEleUM5X6ijurzW5OIDQWAHZsPOQfikYN46AoQyVZiFCngYxODCexOH2rL/A70yIBeoyDdSTEbkRV57bzMrVuRaE9WQPQbcAJff/2BTJFU5HcVat9gxxs7GXK8z047zN+zoGD24zqGj39TSSyWXlhxYX3qfL3FnzrlxS4Vv6vQ3S/RwwWwKbldaz1A/RukaWxEQbOCux30eTGUU/Z2KmihgAq2qAP+zM5TFY/eKUTT/Cm1uQ/1kZl79WqaYz1V5yF5H43XExH2FKCh5T64cp1ko0/QkpRgClo2V8sxtNaCTqHpqkh4BVtFN9sqzdrwljufJqsz1z2HoLglBKmFLMyHDnyn2KqsXaiYH/35SgObol/DnMI29Pqnw7gO+WsxzZn4cdNDiVwONNXIJ8725oIc5MUXUAHLhXy3Pp+8UcRU0jf2T4ErUYTvHKYNbyZT6NqV2HGQBld0Pi5YMKxRRQZSaGPxCDHFwT1GwPLwDrMUKAOaqnCCMV6dkN7jsedE5n7H3ZHzBbluCd4XrKNz6aIKGsGdyn7KBgcV1Yd41nTbsyRpTLGl8c0F6Ffsp2KiSa7NMruhXRims22TL+K2HDiSPFIv8H3JTnVBPWYFsoU1UkWA1mcGUEEOh9+V2ZSR+eHlHyLUvJefEcwqYnA0Zzr9Fl4K7E4TXePKzpHL4AN6xX/yrnUXu4eWq3H3acs770WlXTml0wpVUqeksd8HuGEcwDf12n6YmIbqyfgDT35r51c9lNjq5fpDWEPOwTBHWQ5a/xdIkMC9QzUFguj2NXT4x7EZ6EgQWGISxESM/k5hU8ipp/x4H7obxmVK+tBss7Ypur48fuQM5xsSJExR0Iug5BjyJA1ADUJO0g0HxcjvAs5Hp47opLKXt7uprm/yu9w8tVYe4ASH8NcAnEWyHORRtVhkPLExhShJqkR2KOur+zWDi/T90sLP
 Bol01ha7
 88/EOVPUkHbKYZEWTU/KaidIAepP2riT6d/SgN6fWOsx1OFufk0Y0+nbkNqoPGwQHVHC1EX1Lracu3Nnu0FAWTVCo6XSNkl7qa12kfWt2yoLvJfGfIu54LLyWGfNyLHLvFzxo/eKmng/4rYONEcGe4y2djN4Ev3Qw0o/MTIoA4pBOoUfPTaBhGrH0FCV95x1Pg4cFwJBkNmeC+G9NRXaJ09Kn0hA5CpFrN5YZgu0/JTO4kfEY1X+u5tMaSvFRm8+PIwXNtCH9wFD8kOPbR8mNSZHgtNPhGAq01FArv4U3vLbe+/4T2UewnpxRPwWhss++Tc36G7W0euUv+grmjyonpVfNpIa3R7Y4dmmkrR2trLte27UQATcYUgp6MdwneW7A9SrkdKZhTl2LxpSm8yvc1YOVBuNmmugw8MN+0xI57jJ3KLXUtcbrNxhN1RGjbf5K1738DrlMiZ+QpI0ZZoPvhoPugGHfQqPnDk+z9Mhd799DtWNsRdzZa3EfA4bTxxTbH+wW2ogGtlXWMxNBXJ7pAWQC53qxOfsA9ySwtCvyHmxVOOf2s/EE8a8gyHzDw+theePj/w6zwP6AJujIynNV0CrseUn11WEcHoXkWeAwjDJaAdA3VD9LFG1D8Te6SSnSEK5+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

Thanks for the notice.
I have already removed the unused ret variable in my v2 patch to fix 
this compiler warning.This problem only exists in the old v1 version, 
and the v2 patch has fully resolved it.

v2 patch link:
https://lore.kernel.org/all/20260513075214.2655710-1-18810879172@163.com/

And this revised v2 has been merged into mm-new branch already.

Thanks,
Xuewen Wang

在 2026/5/19 8:36, Andrew Morton 写道:
> On Fri, 15 May 2026 11:15:40 +0800 kernel test robot <lkp@intel.com> wrote:
> 
>> Hi wangxuewen,
>>
>> kernel test robot noticed the following build warnings:
>>
>> [auto build test WARNING on v7.1-rc3]
>> [also build test WARNING on linus/master next-20260508]
>> [cannot apply to akpm-mm/mm-everything]
>> [If your patch is applied to the wrong git tree, kindly drop us a note.
>> And when submitting patch, we suggest to use '--base' as documented in
>> https://git-scm.com/docs/git-format-patch#_base_tree_information]
>>
>> url:    https://github.com/intel-lab-lkp/linux/commits/wangxuewen/mm-shrinker-simplify-shrinker_memcg_alloc-using-guard/20260515-014803
>> base:   v7.1-rc3
>> patch link:    https://lore.kernel.org/r/20260512085546.368911-1-18810879172%40163.com
>> patch subject: [PATCH v1] mm/shrinker: simplify shrinker_memcg_alloc() using guard()
>> config: sh-allyesconfig (https://download.01.org/0day-ci/archive/20260515/202605151100.lH0pRo2I-lkp@intel.com/config)
>> compiler: sh4-linux-gcc (GCC) 15.2.0
>> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260515/202605151100.lH0pRo2I-lkp@intel.com/reproduce)
>>
>> If you fix the issue in a separate patch/commit (i.e. not just a new version of
>> the same patch/commit), kindly add following tags
>> | Reported-by: kernel test robot <lkp@intel.com>
>> | Closes: https://lore.kernel.org/oe-kbuild-all/202605151100.lH0pRo2I-lkp@intel.com/
>>
>> All warnings (new ones prefixed by >>):
>>
>>     mm/shrinker.c: In function 'shrinker_memcg_alloc':
>>>> mm/shrinker.c:218:17: warning: unused variable 'ret' [-Wunused-variable]
>>       218 |         int id, ret = -ENOMEM;
>>           |                 ^~~
> 
> Something went wrong here - that patch *removes* this definition of
> `ret'.
> 
> https://lore.kernel.org/20260513075214.2655710-1-18810879172@163.com


