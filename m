Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0F23FF8864
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 07:30:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 294E46B008C; Wed, 29 Apr 2026 03:30:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26C0D6B0092; Wed, 29 Apr 2026 03:30:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A90D6B0093; Wed, 29 Apr 2026 03:30:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0ACBD6B008C
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 03:30:24 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 601B0A0782
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 07:30:20 +0000 (UTC)
X-FDA: 84710770200.23.4A92446
Received: from mail-m825.xmail.ntesmail.com (mail-m825.xmail.ntesmail.com [156.224.82.5])
	by imf10.hostedemail.com (Postfix) with ESMTP id 36136C0008
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 07:30:16 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.5 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777447818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ki+PBuRDqEdC/VaK3eaqHYc05mNrSgn8NMPGb2vGXMM=;
	b=x/lCo9SKmLsVaJXCohqcHWjMrXy28oAgCK0GLbFyyjtFz2lnmYpbmc3+Y+/zo00hGbFTpf
	Ievf9uhFIVB3wttITXtQuIj9w8s7t8Q6k9YHet2/UcDwadgBuFM2hXkQQBwD+OzxvkJskL
	lkPGXXk3kSUyO9yzswNzmkc+aNYx7mM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.5 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777447818; a=rsa-sha256;
	cv=none;
	b=76pfP5rcUGcOkjSrHfrjKfhjnPcGGDPYJ/oNHEesB1DjCOaEkbUrnDDkcgqpiUZs//N5fJ
	VdXluTwP4fm52rZLVa8qmr7ucrryYRi1JrEHgkOYNMGEbHC0Em/jX/ND1SfKT1RRf9YnE3
	Bevf7yHigItxnntWL5qZgOG0mvIBml0=
Received: from [192.168.0.18] (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 19888ca78;
	Wed, 29 Apr 2026 15:30:07 +0800 (GMT+08:00)
Message-ID: <7cd85225-6377-4062-840a-88358273c3a1@easystack.cn>
Date: Wed, 29 Apr 2026 15:30:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/4] mm/page_owner: add NUMA node filter with nodelist
 support
To: Andrew Morton <akpm@linux-foundation.org>
Cc: vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260428071112.1420380-1-zhen.ni@easystack.cn>
 <20260428071112.1420380-4-zhen.ni@easystack.cn>
 <20260428071640.53b6f37e3a0b2d0ce520622e@linux-foundation.org>
From: "zhen.ni" <zhen.ni@easystack.cn>
In-Reply-To: <20260428071640.53b6f37e3a0b2d0ce520622e@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9dd825295c0229kunm463d27401a9e26
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCHx1PVhpOQk1LTB5ITkgeT1YVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Stat-Signature: 9sfos9kujxx8uxgr56b5i3i3zwmkf9hp
X-Rspamd-Queue-Id: 36136C0008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777447816-350351
X-HE-Meta: U2FsdGVkX1+mMD/HoSCSMEAayuD1QqmXWyR3dGYLCQ/T0yOjSHBSdWP75rvuVtL3L9WfLsLUYLPIsWDUVLk2wBDwsbfyTQa1I11miXP3bIl3J6+3ISR/73TbCrA5uaz0/ppUWZyCuZ++8PfpVa0P0C6KsVf172vod2oJP89taPxbvik+Zh3HTD2WomS5Kl/CX1FjG4+AbcpO1rCBDeVMMX7lhKEn3+Dz3xPqBjEW6XbexxKZUwRQjkvExcEwgNFVN7OPArCTo/fKzLqm8c2jM6itm6O9UcCL49Q+mJOG05by1ohRor5UixefsPwKHcDPoWPIFYkm0g3ud2U7rfJ/h4/ONcx/UJW94AS/5uPfWKf5TOa8uId33sesCcOoDd08caLfYTuT/Y8s66dVa/WieK+SI+SKbb9y5GbUrNqHhL2lNcN/fyf2IWTte4lQ2kUNdf/0LXtWmNlLIrZmFQAFeceh2QpaTnYOVTY4qH/LkB0BYick2y/qNLdnqC7SOubtVRmHrnvFWWDl2P7N9TF7YikIYqYtaUidDd8UU6zysJrjSEobawBHSTjTdi0b8sgEhk3er+h9LIVGgBN00aNthA8UDhibSpoy6Pt6FA2MTYLskuwDHw9K3aLzrCnC9QTW6gqWPiRUdjRG9K9HaLmDpVhUn+qgP7u/Pol0cKW5Q8zK+dLqH1k8VSdG6EMpS/1k/tn1T7dN6519UDtrXqaq2gsOcMPHrIF8TJ9ejGljFrMxM3SLlsqTdlTfs9R7ucf2eL8gVTKI7YqMeP2+FlUggRmcQGNxuiX0tiG/9+LL1zXPDu8c8xCHSAGggqFxLqNvXh/POHvgF80f5zj+SqdP891Ge0dc0P9BT9or9ufijny45ZglRU7YEpx7hJ7bMbDEVR20X2QH1d+lLm3tqjs4io/3nJm1XlXCLgElNV395Qv8ZXDvnoDpBfduspmm7kUaSvKekW5iwfP5QQM1o1o
 8nEDW7YM
 hb8pjt2sG9S+SK/wXyyGy9lDcaZJwNBhh1IJySBDZW611vo1w2RiTb9IIWNp1Bgh1e6nmqv5FKP+Enonin2eV5feA+z1n2XP8+0f5yY8EQQ/c8cUYfD25maxuYBHTsZq0jTAfcVJfa2LwQ2nMZ2K++RlBML1h1sgOdNETrvNEDIiRk1PeEtODwUwMv2hJZ67Eez3YNd7jXpBOWGMhm3crDR8DTQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/4/28 22:16, Andrew Morton 写道:
> On Tue, 28 Apr 2026 15:11:11 +0800 Zhen Ni <zhen.ni@easystack.cn> wrote:
> 
>> Add NUMA node filtering functionality to page_owner to allow
>> filtering pages by specific NUMA node(s) using nodelist format.
>>
>> The filter allows users to focus on pages from specific NUMA nodes,
>> which is useful for NUMA-aware memory allocation analysis and debugging.
>>
>> Supported input formats:
>> - Single node: echo "2" > nid
>> - Multiple nodes: echo "0,2,3" > nid
>> - Node range: echo "0-3" > nid
>> - Mixed format: echo "0,2-4,7" > nid
>> - Disable filter: echo "-1" > nid
>>
>> ...
>>
>> +static ssize_t nid_filter_write(struct file *file,
>> +				 const char __user *buf,
>> +				 size_t count, loff_t *ppos)
>> +{
>> +	char *kbuf;
>> +	nodemask_t mask;
>> +	int ret;
>> +	int val;
>> +
>> +	/*
>> +	 * Limit input size to handle worst-case nodelist (all nodes).
>> +	 * Worst case per node: ",NNNNN" (comma + 5-digit node number) = 6 bytes.
>> +	 * Formula: 100 bytes overhead + 6 * MAX_NUMNODES
>> +	 */
>> +	if (count > (100 + 6 * MAX_NUMNODES))
>> +		return -EINVAL;
>> +
>> +	kbuf = kmalloc(count + 1, GFP_KERNEL);
>> +	if (!kbuf)
>> +		return -ENOMEM;
>> +
>> +	if (copy_from_user(kbuf, buf, count)) {
>> +		ret = -EFAULT;
>> +		goto out_free;
>> +	}
>> +	kbuf[count] = '\0';
> 
> strncpy_from_user() was not useful here?
> 

After checking similar usage in mm/ (e.g., mm/kmemleak.c),
I'll switch to strncpy_from_user().

The change is straightforward:

     long len;

     len = strncpy_from_user(kbuf, buf, count + 1);
     if (len < 0) {
         ret = -EFAULT;
         goto out_free;
     }
     kbuf[count] = '\0';

I'll make this change in the next version.
>> +	/* Support: "-1" to clear, or nodelist format like "0", "0,2", "0-3" */
>> +	if (kstrtoint(kbuf, 10, &val) == 0 && val == -1)
>> +		nodes_clear(mask);
>> +	else if (nodelist_parse(kbuf, mask)) {
>> +		ret = -EINVAL;
>> +		goto out_free;
>> +	}
>> +
>> +	owner_filter.nid_mask = mask;
>> +	ret = count;
>> +
>> +out_free:
>> +	kfree(kbuf);
>> +	return ret;
>> +}
> 
> 
> 
Best regards,
Zhen Ni

