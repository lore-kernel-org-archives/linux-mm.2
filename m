Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A957CCDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 08:20:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CB486B00A6; Fri, 26 Jun 2026 04:20:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A86D6B00A7; Fri, 26 Jun 2026 04:20:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E0456B00A8; Fri, 26 Jun 2026 04:20:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5A5D56B00A6
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 04:20:54 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D8A621A03B3
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 08:20:53 +0000 (UTC)
X-FDA: 84921367986.15.05E9DF5
Received: from mail-m82159.xmail.ntesmail.com (mail-m82159.xmail.ntesmail.com [156.224.82.159])
	by imf29.hostedemail.com (Postfix) with ESMTP id 84E86120004
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 08:20:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf29.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.159 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782462052;
	b=faqzYq0MSIpUTawOLACdap6lob+Js7oMRZguk/WDwaRaSwzyEq2G4fi/FE4MoAo8Puo/yd
	d+wgnHi/nY7hLTqwc6qQR/8VX3Dr/WZppf8VpK1Ma6/7voc2YfIDVBY3o9RXAik/sHfsv+
	ZzZbJUseMJN05l2mTxakFkFS6jfNdhU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782462052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e/L2KLjMCpTLW0CfuScQX2gognXOjZ7j/pK1RIKwVCY=;
	b=eT8Np8z6yipPApdQZ8eg7ajQ7KJU40Eauykp2MXe7AoL/d7z+//jSjgfZwTbBBQ0l9PXGX
	/Sk1N/yYVElH8+ldu/l5ozBnJ/5SHpgOq6kphMfoOOMaLWABEmZtiZQg8iq0zWx3HAXVGr
	ITPmWd4K1coK8ntGG+6X/HP51M491CA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf29.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.159 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
Received: from [192.168.0.59] (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1bef758d8;
	Fri, 26 Jun 2026 16:20:44 +0800 (GMT+08:00)
Message-ID: <4944753a-da93-4f7a-8f22-81bf41cd171a@easystack.cn>
Date: Fri, 26 Jun 2026 16:20:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 2/4] mm/page_owner: add NUMA node filter
To: Zi Yan <ziy@nvidia.com>, akpm@linux-foundation.org, vbabka@kernel.org
Cc: surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260625043101.338794-1-zhen.ni@easystack.cn>
 <20260625043101.338794-3-zhen.ni@easystack.cn>
 <DJICJHL8QY2F.2C6UR95O4RBIT@nvidia.com>
From: "zhen.ni" <zhen.ni@easystack.cn>
In-Reply-To: <DJICJHL8QY2F.2C6UR95O4RBIT@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9f030458870229kunm4cb2cc3bf23d9
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZGRkeVhlDGk0YSRlMGkJLTlYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Stat-Signature: u86drsnq853gy7hyb8rkun97kq89nax4
X-Rspamd-Queue-Id: 84E86120004
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782462050-39328
X-HE-Meta: U2FsdGVkX18RehKUbTNZKLJt8VRm3H8o30Rv7EchPazus/UiUiE1miWh2JX2twx5LBiZPN3vB4Cqc0SXzr93/k6Zy3d92FuB4GL4pNQkeFmJySOkd5CkGOSZyuqw5Mzc+Nwgz/6TM72khKs+a90Ff4oj2CQ1QkGIXczi1xbvYCkv5E5WiCuKEf2r0OLCychAIPXyWsiWTLbG7ILSVYP87x1Ofpt9vTIZTSmQSNEe70tVeyddZHak50YoVbaEzw9R6m0P2xx7FSkbqsznvYxO3WzjMEvJ9eoMIO3TAhuj685mv1Vke1Z4fm8SFM6y2HfwBE0AxsMRWHT/dpAhN+/gmUsW4i132DfhQXXSftEXs+jdF51I7+LVar9Xd5SVZ4sAYkQV/YHBO22ONpqUoMqrutXe3hw6ds3LkhmGzTeQgRoIqB+xUwDVYc8X6j2TWwlEvFP2etQxYnyW15ss2ji1ETO8j6k7oUlN6I57NPe3/6f7Nx+Zxp7k/Z57umAi9WI5h+CH3NpkDe3yKrgZIJVwml11GBq9SUf3P+Pz8GR82P+mWvxGA2KR8VR2Zd/4PdX7QBsHJDv8Pv0VbruN88cxUdXVdIbcwgyVK9UmOICo8lppWS3SR8wxVji47J9RpPuWG7UyAkjrXIreUqgOEQuN+wMmpC+y4kYE9HlbYCrSfCJjMxffdLDjyemk4bi4tLQ8cFif3JCGHaHZzFpqNsArVBYHz+zNgtr9ZNi2WIl3T090fLgrpLyPYlvmfeYLEU+QVfo0vim9RgPi+QCjDZtUnAIlpY3M4TF7TAjromvKKp7J8UT2VcVHNzsaYxZsLPnHP+KUebfIhJNUiiIPKYfFYxnofdNJHUb2NnqzaBWAjRbmmtzneaaS4UdRC3M6TeoFi1rwSi9+GTuzs+Fv+bnpISNV8Ud7fptzWiu2GxAaR4k0OpUNYKGTlIvTHnG23DLknqKrunF6ZRbHd7jUR6v
 ZX2Cw5aC
 ZHJHnlIuMkVDkpa39oKKXRquUklMRzK/GUk34in3Eqx31Polo303fz4eLjV68Rm2yIb9SfF1lfC0C5rnMh5AKGjrf0P9GNKrjf+V+gsMtoICAVC/9H6XGcVtURAXbf3iqzGq2GN7deUfUEhrpSasA4mZ8s1APJuizGhTwKF7MuPZizpkF4O8AKXKXGqb5szLbIhFgYXdJ7TJiBVtpDrAoLiHhdbQ2r0kwNuP+Kvhs4J7I6pKyhaP1TZOKJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/6/26 02:37, Zi Yan 写道:
>> +			nid = memdesc_nid(page_flags);
>> +			if (!node_isset(nid, state->nid_filter)) {
>> +				spin_unlock_irqrestore(&state->lock, flags);
>> +				goto ext_put_continue;
>> +			}
>> +		}
>> +		spin_unlock_irqrestore(&state->lock, flags);
>> +
>>   		/* Record the next PFN to read in the file offset */
>>   		*ppos = pfn + 1;
>>   
>> @@ -783,6 +807,7 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
>>   				&page_owner_tmp, handle, state);
>>   ext_put_continue:
>>   		page_ext_put(page_ext);
>> +		cond_resched();
> In the changelog above, cond_resched() is said to be removed in V10. Did
> you miss this? Or it is intended.
> 


Sorry. This is a changelog error in v10.

The v10 changelog wording is misleading. It should say:

     "Remove need_resched() check, call cond_resched() unconditionally"



> Otherwise, LGTM.
> 
> Acked-by: Zi Yan<ziy@nvidia.com>

