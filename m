Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEE93D6CFD5
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 06:23:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DC336B03C9; Fri, 23 Jan 2026 01:23:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B3486B03CC; Fri, 23 Jan 2026 01:23:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 301596B03CD; Fri, 23 Jan 2026 01:23:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 188BB6B03C9
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 01:23:22 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D780B586E1
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:23:21 +0000 (UTC)
X-FDA: 84362236602.18.A237379
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8BDC8C0006
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:23:18 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=1DVL4SOT;
	spf=pass (imf10.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769149400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GdDjpMtJaMtxsfKMwwQ9MmZp9yI8mEkOk82DglbID1k=;
	b=WBhYCpbaysCvR4GhzRMEsRoVGFx3E8x+/yBKFFLAHgmzBn3pp4LKawULWs9W5Z1mQ4DL/y
	vZoTg5Q2A+EG/kLiNqa+WxPtxPerHzBnGr17F5mx0ThY87VDfoeRIQ+zMRh3DRS+BxBq6y
	xw/rpuHDJbKSJiJKxm72PqJ/OtCpUXg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=1DVL4SOT;
	spf=pass (imf10.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769149400; a=rsa-sha256;
	cv=none;
	b=oEE4Mm5rTeATE5bEsL9+5C/qEJjsHHtC7s8aSNdsBHEO+Zxv8m5pgYumHj1F25v6IJD5qY
	kh7RvEtc3IP44ZrxWPEL8yq4EgHnRPsQj3P10DpWpJ40A2K0QYStidA8KbzLz/n30ynQMf
	efcLau9skpR/MBgg5RfQkpJQyg9MV/0=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=GdDjpMtJaMtxsfKMwwQ9MmZp9yI8mEkOk82DglbID1k=;
	b=1DVL4SOTZysZoiqqOd2j1fbIMeAQFMQp7rfaipuCtqClyp2raTuipRBVMgyzg9f2x7/TdcgOa
	6yy8SAQ89dQ5Leju/sCP8gcZCgZ+BYw+YF/cp7WHFUz+TlVpHXwcgEPVnofmXf8gX/GzJZKybL2
	7H8ZdHgzqlQy+6xWhrDCdKE=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4dy7752rs5zcb1V;
	Fri, 23 Jan 2026 14:19:13 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 08B662016A;
	Fri, 23 Jan 2026 14:23:14 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 23 Jan 2026 14:23:13 +0800
Received: from [10.173.125.37] (10.173.125.37) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 23 Jan 2026 14:23:13 +0800
Subject: Re: [akpm-mm:mm-new 279/310] memory-failure.c:275:49: warning: format
 specifies type 'unsigned long' but the argument has type '__fsword_t' (aka
 'int')
To: Andrew Morton <akpm@linux-foundation.org>, kernel test robot
	<lkp@intel.com>
CC: <oe-kbuild-all@lists.linux.dev>, David Hildenbrand <david@kernel.org>,
	Linux Memory Management List <linux-mm@kvack.org>
References: <202601221142.mDWA1ucw-lkp@intel.com>
 <20260122093240.ef007fed49c166ae5ff256c1@linux-foundation.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <3116e4e5-c1cd-27e2-69b4-6bf0fc0347c6@huawei.com>
Date: Fri, 23 Jan 2026 14:23:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260122093240.ef007fed49c166ae5ff256c1@linux-foundation.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam12
X-Stat-Signature: w6k4cscu9wwc71oxtzpyz6nb4o7iui8i
X-Rspamd-Queue-Id: 8BDC8C0006
X-Rspam-User: 
X-HE-Tag: 1769149398-746228
X-HE-Meta: U2FsdGVkX19lnxvU5BQ4hXNK/knQ/uCtfsp7ZQdAT4mTBR+yvb9+ry6oqAoeVm0elBqdwHfMQ/1uU4hluThuEgfwctQcDu2glRnf2fjHLYCeA/DasQo9LV3WLRjpfuxI5hux4FRNKAp5m6sr2hHTDONuQhRa2WD4rf9/nUlfsmtNd5bAQRZdtIZNYtwYSxhtppri+3X7DAd3UDDnXlhXJg0GcJqOA63azKEWG/17NLr937wkFdTe+kMGerxiZVzFxZ3TXuJrL6ArFCY72sn4qYKHoi8hMq1iA5JEXlqa/TRWSiT0kNSWEUX4WV0rn2QD8XYX3EWMoK3p0vfwVdnyWyN47KO6+TsE94b9lHTORrAeB9p2vIGYeTQC6BRgvonfRlqkI8UQmmQBWc8825iEmL+g7krGlUw9NEbvBNZDrLu4JxVbQfXo/afQeuvGt/kdlBZyXTbXKPZ4lk5mQIUJ2aN0fD8vzDF8BhMDud5OpcHxF5L2t8/x+ge3tqpv0rSgI3exsPXi61ocI3QgxItXQkv51nlAA4fCjC5+/vSgYuPha3CbpTTwnpZ0sI3Kl3RaizYZ+4uZIUBivKCgtno3K/j8Bi6Zwf+FP6vYWReHPXEvye8d63qFaahvZZL56mStHLvDEpuUOQNlnx+ib3gaYf+fZIsaiHCALakpKS0SRKYik8SpAZvJZwkb6J2KMwG+bmb3nEVUU3j1APfYyLc3dpfSC+to5PaBBFIoGmWpIZIXkMVjP870tTilFdtM1dGcYozZlHd9mLipcM7y87FfmRLN7q7uRc4eYlirr3kfKvYUcaldq/kfJphIhVmPzOC7eJ1+vEAn4UMkcl19tssekrwXc5WPP2VhfAGYotwinKVbgtXmV4qW9u+Kxi7exT+dD8kbg+hBfcWLvRUuFRICj3Oc8e7YwywJi4nd8wj//+CgkfyzVl2cIEAVpi6ETX3QtBDr2FzOzvzS17ZdPoW
 IYMro5am
 YYkwU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/1/23 1:32, Andrew Morton wrote:
> On Thu, 22 Jan 2026 12:00:08 +0100 kernel test robot <lkp@intel.com> wrote:
> 
>> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
>> head:   dc4fe40a11269aead253fa0beb098b00417b8694
>> commit: ce9b369feafe8c65aa134b0c8791bf7f19e463e2 [279/310] selftests/mm: add memory failure clean pagecache test
>> config: i386-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20260122/202601221142.mDWA1ucw-lkp@intel.com/config)
>> compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
>> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260122/202601221142.mDWA1ucw-lkp@intel.com/reproduce)
>>
>> If you fix the issue in a separate patch/commit (i.e. not just a new version of
>> the same patch/commit), kindly add following tags
>> | Reported-by: kernel test robot <lkp@intel.com>
>> | Closes: https://lore.kernel.org/oe-kbuild-all/202601221142.mDWA1ucw-lkp@intel.com/
>>
>> All warnings (new ones prefixed by >>):
>>
>>>> memory-failure.c:275:49: warning: format specifies type 'unsigned long' but the argument has type '__fsword_t' (aka 'int') [-Wformat]
>>      275 |                 SKIP(return, "unsupported filesystem :%lx\n", fs_type);
>>          |                                                       ~~~     ^~~~~~~
>>          |                                                       %x
> 
> Thanks.
> 
> I don't think we can rely upon libc's __fsword_t being `int' in all
> situations for all time?
> 
> We could add the typecast but perhaps it's better to change
> get_fs_type() to return int?

Yes, changing get_fs_type() to return int looks good to me. Will do it in v3.

Thanks.
.

