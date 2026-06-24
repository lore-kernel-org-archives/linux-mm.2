Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 617B2CDB471
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 11:23:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CDEE6B0088; Wed, 24 Jun 2026 07:23:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AB4B6B008A; Wed, 24 Jun 2026 07:23:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E3146B008C; Wed, 24 Jun 2026 07:23:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 11F7F6B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 07:23:17 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 211061C58FD
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 11:23:15 +0000 (UTC)
X-FDA: 84914569950.01.2AEA644
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf20.hostedemail.com (Postfix) with ESMTP id C3AD71C0004
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 11:23:11 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=h-partners.com header.s=dkim header.b=p26qdZbB;
	spf=pass (imf20.hostedemail.com: domain of zengheng4@h-partners.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=zengheng4@h-partners.com;
	dmarc=fail reason="SPF not aligned (relaxed), DKIM not aligned (relaxed)" header.from=huawei.com (policy=quarantine)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782300193;
	b=qcDR82eDpH36etrUS89fmbrA2q971zAVxVZlPihbIg3Cij4fVIhIPCh6PphSGEYWgg4Kcz
	6dymaYfaGmu4+t7OpjQxqxmpjmbOQblf3dOYCKz8WVUMsU8zctgeE/DSGZppaa8FQE7EXl
	o0ZsCAV1lkNgYQr4H4gR9Hy7q8vPtw0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782300193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GasGCMkpqsIfVRcBaW6bgI7a5DEAvqZjljpM0MMljkg=;
	b=K0usbUNcjb/3R78l2CNkVxAE0Z6TZSz+zlRsi4ZDWMnzc60iGD48td3/sMwnR2HYSHuAHX
	VgrRLEe2gGSGfi13HcFEXWAAD28x81jxXUApJham6eCv859Go+PBphI1LUEaXToR3VZF7o
	YjgA4h6exQXfz5E125CWou9er7zMtPE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=h-partners.com header.s=dkim header.b=p26qdZbB;
	spf=pass (imf20.hostedemail.com: domain of zengheng4@h-partners.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=zengheng4@h-partners.com;
	dmarc=fail reason="SPF not aligned (relaxed), DKIM not aligned (relaxed)" header.from=huawei.com (policy=quarantine)
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=GasGCMkpqsIfVRcBaW6bgI7a5DEAvqZjljpM0MMljkg=;
	b=p26qdZbBK7+67oTpFgKBqJ3oBUDKLNh5aZ1m8FS9MTuXBCHiRdW81JTcl4N03FDRSm8g6TMcH
	qqnijijEnCSX9wv8ejoUIE5BnX0Yd70asQsWAJqnvaEfYcN3adfLOUjwhbGL0k3+cJI5k4+7fjK
	tQnoa4PYwpY9zT1Fp0AVKc4=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4glfT341j1zRhSH;
	Wed, 24 Jun 2026 19:13:59 +0800 (CST)
Received: from kwepemf100008.china.huawei.com (unknown [7.202.181.222])
	by mail.maildlp.com (Postfix) with ESMTPS id A29152012A;
	Wed, 24 Jun 2026 19:23:03 +0800 (CST)
Received: from [10.174.179.37] (10.174.179.37) by
 kwepemf100008.china.huawei.com (7.202.181.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Wed, 24 Jun 2026 19:23:02 +0800
Message-ID: <a9018e68-866a-c251-9e0a-67e31f4baec2@huawei.com>
Date: Wed, 24 Jun 2026 19:23:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [RFC PATCH 0/6] mm/damon: hardware-sampled access reports
Content-Language: en-US
To: SeongJae Park <sj@kernel.org>
CC: Ravi Jonnalagadda <ravis.opensrc@gmail.com>, <akinobu.mita@gmail.com>,
	<damon@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<akpm@linux-foundation.org>, <corbet@lwn.net>, <bijan311@gmail.com>,
	<ajayjoshi@micron.com>, <honggyu.kim@sk.com>, <yunjeong.mun@sk.com>
References: <20260624001425.77489-1-sj@kernel.org>
From: Zeng Heng <zengheng4@huawei.com>
In-Reply-To: <20260624001425.77489-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.37]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemf100008.china.huawei.com (7.202.181.222)
X-Rspamd-Queue-Id: C3AD71C0004
X-Stat-Signature: 68gxow3z9fcqorq8n5upskfyx589tw6h
X-Rspamd-Pre-Result: action=add header;
	module=dmarc;
	Action set by DMARC
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspam: Yes
X-HE-Tag: 1782300191-195145
X-HE-Meta: U2FsdGVkX18Rre+ImwSIC715OayXyVw55ds4WMulpO5mnbwvwmXmBKQu7lmZSayG15c6cn4QusHSJpozEFY6evYUCneFcfmtRRAzOQWkvegB/fbGVmqEC0FkwzDkjiVVMO58ejB9uM/7UWZDx2qPTYUbblG7GogLsYj48ifzhNRKRdARRfwmeljqRaLWlUo5K4xNZ+FgiY7BEk8hZavxqwkCzGp1b5Q4KrjqQMa1Biwjl8MyZYcUJhkXO4Gs9I11dLShtpr6qIeZlNBrAvey64sq9mmkVDNW4tbbqyc6CMYwQnsasayAoEuWiB39PNkjJgnY50Q15MxtTmynLBnwWspMTh2CsAS8LuQ3TQJPgfb4aP1mwSE3bepY8XoPTQY2pcIfq49+hLDSgYQGV4qvRSISMdsCaHYO8mK/a8EeMHmFjDH+76MWR+7U945d0pk/6vXD9r7hg5KaSGQslryF33n0JNOaKNkAIdsxQ3f9hO2MKtdHRVcj36FP8BYEXmUgUG4GaKKi2WoBNXP+I2oK+TTipE8oFZXrjgClFYrGml93E4Fx76269qh9ckj9KSBfQBH9kcOGGku9FzerY404PA0fjxxPf3O0VJvxRgZnelg8VfaPvzpMbK0nmwscWOjgJMFsXklRucyTaURW+t9Ml/Zl6AfIoCYKU8j02zG3cgDJdG1/mgdia/acnZJPN2srbaVQNmjo6u2ZPAO+JQzPAfiqh0WLs4GwVzdBkLT5GHLqWcj8Zf12VeNA2L1WNOGghw1FCBXbS/yKmSsve3Hh+cSAxN8dkc5pk7maYsz2bj6++LQvKyiDLiq8JkI2tb3nlBO+tRCvcaWXWYL3MKqJRGqiBOqzWtzx4BKuriZOVePDtdhecM1hnDWZuiDvllOWIDm79C0BZmPf+3Ws5VMzpGncCgrcepnEpq4q3wtIlsq6yMhXEaNTL15k06K7m+Qc04IrudhnVrHoUgWg67h
 flVGpE4Y
 l4GRrM9UpidgAR22UriJUQCtiRfVY+wbkl6VhfP4Ku8WtggiaSp49AfNXwdBbfAN9LwG3tvjWRBqgZdytwtA6cj91E4hl6NcNv3RazAxFvrPcMVyjN1rau6d+hzn92YkuDfdjvT8PG2nNPfqzW4DgUaRsGyNk3F2NUrHcQhr+ya6lVI/b/iBpbMJt7zu95CXh1xUAU4SwSNE3h7czBHtyVRwUQXoe3pCuwFw9Gjcr3W4WKGOaqeRjEP1OEEYEZ0wXtV8JpTrA3IVVlYNo0Zm0gjmDXAxqQ3xOic6lM32AKemL/MKSav7KOwUAJCKSlbFQCkvC3ALoRyslEU9JIJb2A2raEJ29DWMo5HRsPjyQnBgaNZyLTKx7paj7eUDY3s7ApYIFi3cEVz3STsId9n6I2UdKNTxEBOgDdS7BANl57GkW0vplKSSe8a59Is+uu6xk1G9MFOi7qPEH3MEkHdgfHmBSZJEs63wvHukzuGvNrksfDFpFPIeDE1PO/YmMnb7AgYeYbZnJA7YJUIQUkva/Q/8Yv9aCTg8C/DDXdT7gsOyzoSczBX/LAG9ADlbMwgPDiKl6oC2oLN3zD69WOyC2JKTuM2VkRhEqaQtKzuJClBGYEp2/TqFr99LBbSDWBaEh1logfWxhRYYlnaueRXDBmhFY0lkhARQhEzusmfLIuT3RJZMBI6vCYs9REojV9YaVz1hp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SeongJae,

On 2026/6/24 8:14, SeongJae Park wrote:
> Hello Zeng,
> 
> On Tue, 23 Jun 2026 22:08:03 +0800 Zeng Heng <zengheng4@huawei.com> wrote:
> 
>> Hi Ravi,
>>
>> On 2026/5/30 0:56, Ravi Jonnalagadda wrote:
>>> This series introduces a vendor and PMU-agnostic substrate inside DAMON
>>> that consumes hardware-sampled access reports through the standard
>>> perf-event interface.  Userspace selects the PMU through sysfs (raw
>>> type/config knobs), driving either Intel PEBS L3-miss sampling or AMD
>>> IBS Op sampling.
>>>
>>
>> [...]
>>
>>>
>>> Ravi Jonnalagadda (6):
>>>     mm/damon: add struct damon_perf_event{,_attr} and per-ctx perf_events
>>>       list
>>>     mm/damon/sysfs-sample: expose perf_events configuration via sysfs
>>>     mm/damon/sysfs: install perf_events on apply
>>>     mm/damon/core: per-CPU SPSC ring drain and damon_perf_event lifecycle
>>>     mm/damon/vaddr: implement perf-event access check
>>>     mm/damon: add damos_node_eligible_mem_bp tracepoint
>>>
>>>    include/linux/damon.h        |  80 +++++
>>>    include/trace/events/damon.h |  49 +++
>>>    mm/damon/core.c              | 403 ++++++++++++++++++++----
>>>    mm/damon/ops-common.h        |  39 +++
>>>    mm/damon/sysfs-common.h      |   6 +
>>>    mm/damon/sysfs-sample.c      | 579 +++++++++++++++++++++++++++++++++++
>>>    mm/damon/sysfs.c             |   3 +
>>>    mm/damon/vaddr.c             | 267 ++++++++++++++++
>>>    8 files changed, 1370 insertions(+), 56 deletions(-)
>>>
>>>
>>> base-commit: 4c8ad15abf15eb480d3ad85f902001e35465ef18
>>
>> I wasn't able to apply this patch series to the linux (and linux-next)
>> mainline branch, and also had trouble identifying the source of the base
>> commit.
>>
>> Would you mind sharing where this baseline is from?
> 
> TLDR: I pushed [1] a tree having this series applied on top of the baseline to
> GitHub.  Please feel free to use it.
> 
> I think the baseline was a commit on damon/next tree [2].  Because damon/next
> is continuously rebased, we cannot get the commit in a simple way.  Fortunately
> the commit is still available on my local tree.  So I applied this patch series
> on top of the commit and pushed [1] to a branch of DAMON kernel tree at GitHub.
> 
> Note that the branch is not guaranteed to exist there for long term.  But
> hopefully this series will be merged into the mainline before that.
> 
> [1] https://github.com/damonitor/linux/tree/ravi_hw_sampled_access_reports_rfc_v1
> [2] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees
> 
> 
> Thanks,
> SJ
> 

Thanks a lot for providing the branch on GitHub. I've pulled it and
confirmed it builds cleanly on my end.

Appreciate the help!


Best Regards,
Zeng Heng

