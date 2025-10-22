Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C412BCCD1BB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 15:35:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 137DC8E0008; Wed, 22 Oct 2025 11:35:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E9548E0003; Wed, 22 Oct 2025 11:35:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F407E8E0008; Wed, 22 Oct 2025 11:35:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E5D4E8E0003
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 11:35:22 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B21661608A1
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 15:35:22 +0000 (UTC)
X-FDA: 84026149284.15.2DE79BE
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2B768C0015
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 15:35:18 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YziLEkxW;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of leon.hwang@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=leon.hwang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761147321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8iYpTFR7g26YCYkL8ooNPprAkKOl1jlVIj+zsrDxsYk=;
	b=lahXIBN78ZM5IyAw5wYkPNvuK0k9bLbZHs60KHzGYBHC+SqS/RFNjv9LWYYxCTGE7GrZRB
	GRRPACVjaxxiv9dVQ7Y7ggM3fpeDcUqQxbRfIUdP6AaBYRN1ZbngG5TWqlBZ5a0z+q3M/a
	QzaMQUiqC6pgEP3ke032HN+H2hDThy0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761147321; a=rsa-sha256;
	cv=none;
	b=egVkEi72vlq187fMQRorNmL5Tw4OJ97ASrjMrwSQi8YpElAz3S50RI/8+CA24zSEzLTklh
	6l+wpKKmj1KdtPxNpZzSFjTfVZZdS9xXZKmdJyYcjnSyQp9xGuJSb4JMNkTVn/fiL8vLcS
	tgMXlBJSi4XNCGarvmKUIph0zUIiphk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YziLEkxW;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of leon.hwang@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=leon.hwang@linux.dev
Message-ID: <f1e5a58b-f5a5-4acb-85ea-59a7f43c060f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761147317;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8iYpTFR7g26YCYkL8ooNPprAkKOl1jlVIj+zsrDxsYk=;
	b=YziLEkxWruWwReycddBdGYvvFQvSScqhH4PRwz5NsTxfUgA5M2Ik2/DOYJ2msrqta3lwRo
	VOUyIzGYF0ntgG0DnOQvf1j22qXsR+0dwVanf3QPMHHTnWVNtybgtQ1rDkb69NKNISvEfO
	hXFo+H36RfsB5BL5IWxNrSau7VJIxc0=
Date: Wed, 22 Oct 2025 23:35:05 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 6.1.y] selftests/mm: Move default_huge_page_size to
 vm_util.c
To: Greg KH <greg@kroah.com>
Cc: stable@vger.kernel.org, akpm@linux-foundation.org, david@redhat.com,
 lorenzo.stoakes@oracle.com, shuah@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Lance Yang <lance.yang@linux.dev>
References: <20251022055138.375042-1-leon.hwang@linux.dev>
 <2025102230-scoured-levitator-a530@gregkh>
 <ff0b2bd4-2bb0-4d0b-8a9e-4a712c419331@linux.dev>
 <2025102210-detection-blurred-8332@gregkh>
 <70f8c6a1-cbb5-4a62-99aa-69b2f06bece2@linux.dev>
 <2025102241-clubbed-smirk-8819@gregkh>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Leon Hwang <leon.hwang@linux.dev>
In-Reply-To: <2025102241-clubbed-smirk-8819@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 2B768C0015
X-Rspamd-Server: rspam02
X-Stat-Signature: jp4tf9k3hufa37x73tqi1b3ycjzfzjns
X-HE-Tag: 1761147318-702551
X-HE-Meta: U2FsdGVkX1/JAUBAeYb/TIqaIlIndKEa5FHe8pvzUMJJ7HAq9vp5YZ0iNFQyxyP4NjTO5eprfbqHIdqdgwaEIYuT1Du8s9mN2BwuZrXmAlZVWGpSaIF6kvTOf2FQiy5OeQYAv12VRNEsGqX6cnCnPQ1WsO93JNKJ/NxRAfgj316L1/+QFiUAEaK7Jah/bSbrklj7mvYtl37/TA7F98Z+CeJzVT7siGDQL7wbpjKaiK+OPZGl7PkdowOXex0Rih6F4PMkgIJzqAqO5dRbUr0OuRk0RWdHRlzz+mkjHSQO1V9Pk1lY0GV+a5HcUrUDazQ9ps2cOVlq5C80D6fH0K3nzARCtgKGzwgxy8IVMfTyNCSaEgARwriSFWL9LIBGumf4Sly6vWBLJEwdEFiHRZa6yGDIU/4WkBAINloeIHSgzcDzsClHEEWE7vbWg2ZEmB8pn0wcBsP3nvRcSjlNSduzSFwQ+zWNllCitT0Y2jfBL915NmZ1Jofa5ZqN+CS1DqJ/BhPiRU9/usI13QIMN2B/Ffi3xw/lOYEZY7aW1vUEeEsL8oYj3YwCboFqEkFfVZZYiLkV79cZbD16CWKr8Fm5Y/WHK0PVMLJQ7dbsSJGn6+r0OPkoiAsM75oSayMF7qzRnFqMZmLWLz5UvNeMJW1Bk9e1ruiwFupYLt72j4nFb2/NVuWN+XJMpv+8nY+ZQcutBCUtp5NyuhbfNSUyo3cbEv00rfgsS5jhSn3gdmzctus5lZSL2dyCSa6fBBCahliNRXBwoS13NwBvt5coo+ZInAQzmkeiPXgUklw+SqT90fuYHDdvNPIYeOnKtvCUZwzK8ZM5mvquzaAGQYTQ6IdyM6OaWXs95sh427R81xBB1kTVwTsYJxTBzfO1DMBM1w5c9YNTJvnkNYuclhyZ4x3/n3WKlkNtkigjO4PgljrejHWynFogXuni1Q1nNn3EgRL61//x8sz4X7PkmC4hHfh
 ots4+eCc
 4ADO3Yj/HlSGSDf+HE7YN48Fak8gUyMn7YhsgKr3bC+4rbmmmTgT9KB4pCMYfRAQMc1khUlO9L/QHma6blxI9Vl+Ytgw3xr4jZ5niSgnTFM9f1PKTXN/JEGzhq0nDh3lztIxQRCKxAV26TKN+9Htm2JgHd5VW7UK+lW5FHdUqfUNIGKAZV5axy5fH9D5tq4uozrjw9KhSQvnzo0grkKR65bYkzotcpY20JmoFcgDIwJSaJisQ5RHmN5bo2n4mLwhHMY52RQKcuhOeWjROIVlhfnzteA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/22 22:26, Greg KH wrote:
> On Wed, Oct 22, 2025 at 09:34:52PM +0800, Leon Hwang wrote:
>>
>>
>> On 2025/10/22 16:20, Greg KH wrote:

[...]

>>
>> Hi Greg,
>>
>> After checking with 'git blame map_hugetlb.c', the issue was introduced
>> by commit a584c7734a4d (“selftests: mm: fix map_hugetlb failure on 64K
>> page size systems”), which corresponds to upstream commit 91b80cc5b39f.
>> This change appears to have caused the build error in the 6.1.y tree.
>>
>> Comparing several stable trees shows the following:
>>
>> - 6.0.y: not backported*
>> - 6.1.y: backported
>> - 6.2.y: not backported*
>> - 6.3.y: not backported*
>> - 6.4.y: not backported*
>> - 6.5.y: not backported*
>> - 6.6.y: backported
>> - 6.7.y: backported
>>
>> Given this, it might be preferable to revert a584c7734a4d in 6.1.y for
>> consistency with the other stable trees (6.0.y, 6.2–6.5.y).
> 
> Ah, yeah, it looks like this commit was reverted from other stable
> releases, as it shows up in the following releases:
> 
> 	4.19.310 4.19.315 5.4.272 5.4.277 5.10.213 5.10.218 5.15.152 5.15.160 6.1.82 6.6.18 6.7.6
> 
> So a revert would be fine, want to submit it?
> 

Got it. I'll send a patch to revert it later.

Thanks,
Leon



