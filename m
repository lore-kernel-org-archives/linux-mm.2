Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35E2FC61DE4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 05:21:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 390BB6B00AF; Tue,  1 Sep 2026 01:21:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 341ED6B00B0; Tue,  1 Sep 2026 01:21:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 231636B00B1; Tue,  1 Sep 2026 01:21:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F31DB6B00AF
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 01:21:05 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 85D641A0351
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:21:05 +0000 (UTC)
X-FDA: 85164044490.12.FB44B9B
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf17.hostedemail.com (Postfix) with ESMTP id 28BDD40006
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:21:01 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=huawei-partners.com header.s=dkim header.b=KPdsfQ37;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf17.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788240063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hEPG3P/x/ozu+lY/WnNZEs9objWoPkEaUik+WEJ687U=;
	b=T+W1hDYONRtDzcT6Xm75X3RI4ke80BQsWI90Bznljis+X2euTj+ie2j5yF5s0PyDZahBNq
	z9vexuUr9J4DucS3OCGEHA9nVN4wbGx6HRcE6O+FoUWLzapN9ENTEtDkQYqTmYDl+75GIL
	/wQbqiywDcUwCVrcbV3H9AclEoMzR3k=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=huawei-partners.com header.s=dkim header.b=KPdsfQ37;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf17.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788240063;
	b=tp4wcbl1W1eEU6BjZ4Yj2THo1vv2qU7m0JQnYzdZeoK5/HALe3U7VA5KcjzffI1iO6FtGM
	sX1yyCQwH+A4J41FgFy9qalK5YoNAEXz7g0iEHOvOKKd5lq4Ksg+MjGRn2PmOIkNGF+6UR
	r58GZgz+XwLcviCpjcHZuu9KbVy9/z0=
dkim-signature: v=1; a=rsa-sha256; d=huawei-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=hEPG3P/x/ozu+lY/WnNZEs9objWoPkEaUik+WEJ687U=;
	b=KPdsfQ37BIw1yCqTL5PIQaNbF5exr5rkTec1aVoNuzcPU3yQ+ea0WDzDhMS48cbUrfF+qGBOu
	yhNp0EbXLwZopwcmteg9kMpKjsnxzMgY0gm2oE9kGpGgXaHgKNpti5y6Q3mvzD1RC8Mgps2g3Og
	OxqYcw7lwXvkhP6CNvUXXHs=
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4hYvMB44C4zJ468Y;
	Tue,  1 Sep 2026 13:20:22 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id A095440571;
	Tue,  1 Sep 2026 13:20:51 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 1 Sep 2026 08:20:51 +0300
Message-ID: <893af75e-690b-48f0-9cc9-afe07c05565c@huawei-partners.com>
Date: Tue, 1 Sep 2026 08:20:50 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/3] Docs/mm/damon/design: Document hugepage_mem_bp
 target metric
To: SJ Park <sj@kernel.org>, Randy Dunlap <rdunlap@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett"
	<liam@infradead.org>, David Hildenbrand <david@kernel.org>, Jonathan Corbet
	<corbet@lwn.net>, Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko
	<mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, Shuah Khan
	<skhan@linuxfoundation.org>, Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, <damon@lists.linux.dev>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>
References: <20260901004712.89669-1-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260901004712.89669-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Stat-Signature: rmehi6szi919zzo3mnk1qf8p17k5ouwx
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 28BDD40006
X-Rspam-User: 
X-HE-Tag: 1788240061-555938
X-HE-Meta: U2FsdGVkX1/XB0clhpED8kImWEEecKVsvdrGCZp7EgXPGJrgdZSYIZWooQ19o1JMRXi0x0JWlUNLl2zsgAjtGKusioA050PcQQdNMdES2m6yvLKg+dkeciXos5S1NPgmS3Kh4hsWtwfP4w4LPmN0X0EmbhYZVmfh/rPz99/seRlitqQbD2JCOiTnIDxclo3Rr/s5ujxSTKWU7tyuAuHSgv9J8/zeENyxt24yGD7EBpaTXuorpJMNmpelYlo1Tb3Lxvv3cX8uSptDZDMbuMF5okmN4M/hw4ipj8chnhPCbyzrkphg5wrzU0YrSjTlFdwBw7S+2uLZbu1tx5kJUiKdMXXgEsRdBzkwwKnH5usCjtaG3AA/lfx9PBZ5Q68wF2lYJWRSmquWDiHg8Eck5imQSSr1hA39I3v8fKClP1EUesjFZ+62CBTxgGYW81a6BnhWV5nI2c6Ao7Y86wZYl6mttyLlW8K5byVZLk6YGK+mrEFDjzPu60I+ueRKVSb186uTfY1NNKrgbWqH1fcShLxOUpALZa+VioBa2sH4//754CXnPDiQ3hUiOKOgmzB7aftlCk8RpxyWEYNgT3PmxH7EETmYpGBI+lh7S3nX4SmZgOfE2D7MAehei9ASYWBaRrFAMDApqSejnbA8Qzn5bNI9/63SDhjsVB7itRoU0RA9V5dh+5DKiICwXj6/lulq0pXgwShAWyjrkJG1lHIOXLWVMXaX17TbMFzDb/YgxG20B+V/C0j0qIx5pclKwWiO5y3yKFHxu1WdbqxIPpQp/0aonGbaPuv7uoZ2ZT1RQykDrfwCzH3natO/4zdHhSydpNh/N/OM+7oy+iJJT1+ql8658gVH8W/PAwPs63gEQnLFKq45icJ2dGHYOjNFZezLnPACL7NtPvkWMZPu43CPN5lE/yPMvQUKH9q+o8eFvcPI8XnxQufOqVRFhtIdl8b4k35YUESB7yK5D6o+beVakr9
 MzMIV16w
 fFNVdY7UG4ef7t+hyXle4m10Y9zy9XdqfqNpMQRhsQ6E0W+S1K/EcMd08y8wLet3//UqQzM6e/JzxH1x4BI2hiVn2Hg98htrpRREf2CgxrdbVcKPoCT5/vO/Z66iGXEPGTh5UImWByCpJoMZ+PcMfZJYTFQYVPjuSsSG5Y32E6VqaXmRvOan1KowtepZZn8jGTwF4QFLSitiVqd8e2lPr8bSqaCPl8XynkOo/L7C1Yr+Ue06da0VjKJNCMef9vs56mrAwXfrSCLFUIt/MQURTMuEPfiGlvLFQXB15MD6GwpGo73YDU+2f9ZSXOoPv+OrSdBHyl9mPZ2v56XLwOA34BDGDeLL+OcFAiQN2+nh+QeqrJGlvOOrbGSH1aRIsnv3o/+7xE8iJnxGX5Ijyqpid3cNOU5aBxoAMuJVSBCrSKw5eC5fppz2QaYJuwUemz2EOuk6wibHPCd2fFlBHEqCgbsBE2Mtk3GqRj2ZciMecHsrebCPfBg/qsRczVNzrucndwPMyMOGfa0iRdqKNZaWP09x1OA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/1/2026 3:47 AM, SJ Park wrote:
> On Mon, 31 Aug 2026 13:00:26 -0700 Randy Dunlap <rdunlap@infradead.org> wrote:
Hi,
> 
>>
>>
>> On 8/31/26 8:45 AM, Randy Dunlap wrote:
>>> Hi,
>>>
>>> On 8/31/26 7:47 AM, SJ Park wrote:
>>>> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>>>>
>>>> Document hugepage_mem_bp metric exposed by sysfs.
>>>>
>>>> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>>>> Reviewed-by: SJ Park <sj@kernel.org>
>>>> Signed-off-by: SJ Park <sj@kernel.org>
>>>> ---
>>>>  Documentation/mm/damon/design.rst | 2 ++
>>>>  1 file changed, 2 insertions(+)
>>>>
>>>> diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
>>>> index aed6cb1cf4831..a8c163475ef2b 100644
>>>> --- a/Documentation/mm/damon/design.rst
>>>> +++ b/Documentation/mm/damon/design.rst
>>>> @@ -713,6 +713,8 @@ mechanism tries to make ``current_value`` of ``target_metric`` be same to
>>>>    bp (1/10,000).
>>>>  - ``node_eligible_mem_bp``: Scheme target access pattern-eligible memory ratio
>>>>    of a node in bp (1/10,000).
>>>> +- ``hugepage_mem_bp``: Total huge page to total used memory ratio in bp
>>>> +  (1/10,000).
>>>>  
>>>>  ``nid`` is optionally required for ``node_mem_used_bp``, ``node_mem_free_bp``,
>>>>  ``node_memcg_used_bp``, ``node_memcg_free_bp`` and ``node_eligible_mem_bp`` to
>>>
>>> I've looked thru the entire design.rst file and cannot find anything telling
>>> me (or anyone) what "bp" means.  Explain??
>>
>> OK, I found it on the internet. I still think that it would be a
>> good idea to say "basis point" one time (the first time that it is used).
> 
> You are right, and I agree.  I will add that clarification before the next
> merge window.
> 
>>
>>
>> -- 
>> ~Randy
> 
> 
> Thanks,
> SJ

SJ, should I submit a new patch to fix design.rst?

-- 
Asier Gutierrez
Huawei


