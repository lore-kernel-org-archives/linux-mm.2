Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7E77C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 07:46:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C71EA6B0005; Mon, 13 Jul 2026 03:46:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C496A6B0088; Mon, 13 Jul 2026 03:46:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5F376B008A; Mon, 13 Jul 2026 03:46:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 983106B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 03:46:21 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2F25D40A53
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:46:21 +0000 (UTC)
X-FDA: 84982970562.23.9CD2576
Received: from m16.mail.126.com (m16.mail.126.com [220.197.31.6])
	by imf17.hostedemail.com (Postfix) with ESMTP id 45AF040002
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:46:17 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=126.com header.s=s110527 header.b=LcD0keLc;
	spf=pass (imf17.hostedemail.com: domain of zhongling0719@126.com designates 220.197.31.6 as permitted sender) smtp.mailfrom=zhongling0719@126.com;
	dmarc=pass (policy=none) header.from=126.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783928779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sd5LcECOeYnW6IdQZhIytTV2jUItt7eRmsgeJq00wgE=;
	b=uC0DYQRlV74xUK22DyOEe7b8BqaBgVXJMNtXP7D6IYB96vWSoEyGM8WY1xm4Sf8ae7/Vjf
	/uoXT6Ef2b+0gfsA42fXJv3eiOTS3id/FwdqjQzB+DEu1Mj6LtauOAKQD0IkJRmeMDHL5j
	9keNJ+P/ugNrDEGTRPx4Lk99WQWJmdY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=126.com header.s=s110527 header.b=LcD0keLc;
	spf=pass (imf17.hostedemail.com: domain of zhongling0719@126.com designates 220.197.31.6 as permitted sender) smtp.mailfrom=zhongling0719@126.com;
	dmarc=pass (policy=none) header.from=126.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783928779;
	b=cszdlPh4ss81Mf2wPARponwQw162ZKZ8ebZ3BeuTq0klYu9iJIg6LOdrixxegrBsMvKen3
	INxjOimHVajqDjg5q2/lSwaAn1R+je0dRAmhNPp9tJJuDKFbnMKabkj/7yiXSnPbCzyMLY
	UJL8cwuP7ZzxpRt6zdrt1dm0ezfsQkQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=Message-ID:Date:From:MIME-Version:To:Subject:
	Content-Type; bh=Sd5LcECOeYnW6IdQZhIytTV2jUItt7eRmsgeJq00wgE=;
	b=LcD0keLcGkuCSFSKkSe3S1DyFD1kPhyiC5M4UhRSw+F4FPpMtLyavUp5smoNu2
	EgPeY45mzfyUKA3u1KEdR8WySIsx/ueBAQEjaXBdlCCN/V9xeUDDKPvi7C59arDD
	3AfnMa3gSZi88Eav3uWbqQpRGm8l7QEO+AyA/zMWy8nlY=
Received: from localhost.localdomain (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCkvCgDnz3+il1RqPwBgCA--.6711S2;
	Mon, 13 Jul 2026 15:45:39 +0800 (CST)
Message-ID: <6A549790.3000203@126.com>
Date: Mon, 13 Jul 2026 15:45:20 +0800
From: Hongling Zeng <zhongling0719@126.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Harry Yoo <harry@kernel.org>, Hongling Zeng <zenghongling@kylinos.cn>, 
 vbabka@kernel.org, akpm@linux-foundation.org, hao.li@linux.dev, 
 cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev, 
 vdavydov.dev@gmail.com, davej@fedoraproject.org
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm/slub: add comment explaining intentional kobject
 handling in sysfs_slab_add
References: <20260713070024.153552-1-zenghongling@kylinos.cn> <b42f2b3a-68c9-4e3c-b3b7-d940677b4609@kernel.org>
In-Reply-To: <b42f2b3a-68c9-4e3c-b3b7-d940677b4609@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PCkvCgDnz3+il1RqPwBgCA--.6711S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Ww43CF4UAr4fKr4rZFWkWFg_yoW8XrWfpr
	1xJa1UGFW8Cr4xGwsIya48W3s3uas3KF45Gr4Fgw4Yvr1fCr18tF4F9Fy7Za9YkF4xGa1F
	vF40yw1agryY9F7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j4Hq7UUUUU=
X-Originating-IP: [112.64.161.44]
X-CM-SenderInfo: x2kr0wpolqwiqxrzqiyswou0bp/xtbBoAO9jmpUl6OTDAAA3F
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 45AF040002
X-Stat-Signature: f8prukhgqazmpm4c4ryc8mkkaedss7kf
X-HE-Tag: 1783928777-331271
X-HE-Meta: U2FsdGVkX19SKD1tLyYUPr/3o5yO/d1TmwV/0wOMzbDHaqRtCBSneLQF/NLZ54S2rF16+B8ZshOMZA+gmgWSOrqn4aaQrMVHs9MI1OneJtIDyMOEQBI+HnY7E5zC6pu4erGRrGGOSxJ5o/8ButeELKmafGIKK2igBHuFc8gV6z8ElTZHCERYiOnZQ/uAptd0/5tkFbfO9+ywl5Aljn/9YsJ94PqFJuQ8wrSxh90+F4QUp9zg6zro3Puws2PQ5oYi7cDvErAAv9My5KB+9eco90V05QTgl7iNGyxCczBbgu5ZrjruCRCJUDnp3FulhsDo/1knYFgBx6SfaprV83wc0ngOpjTsfMbrVYdNFFtryTqav9iXXdAP1PY6Q2zLKdtVTaKa4YxhxEHNWjUzqXINA7Bwer6iABT56n03jrPpJL8xQaSA+02pDFKDZJOL/AUXUHpnATOOorFgxUI3sU5OB3gqipFM+pD+/bEg3yoDz+IwiHFuqSzOFwS8W2gmdb9QsaLEdFPhOBjUjrSQ/wVA0xPfYvANsdP/85yKROp7epMBtCEdVKB7Agv4LpzSM5do38+N8wLkTyPXeII1l1zVSyDDO1MqpluORb/PaMhedJJI7BRfisSa46olpx6IH3agiK3Z/J70eTY5O0DDufigheFmqBjiTnQM/iQAo/06msJVCtzL90hHDgWDEZ0I1pMgySDKgvjrvwBMeJUAPAcT+vTgqopHIUAXXcjBvNVOhfQfBPFeC9xHCyijNo7pn8EcL0DiRNKGHi767ne7M1jXaqXWf8++CvotTSNbfO2K0OsnLny4p6+N6/i4aojTStja5lGcg481eisSqCx9mdrlGYQhV8mJOfWDskY8B2eLSvyK97YXR8xR93jb/vycgd194QBcq8BL89MPH5BobpNxRVZD/+otl067vQGODd1WRM2cgcpcLuk5NvZJvhge21KwvaQLFUKIIVt3BWrzlQb
 JCxlcMSF
 8f9njiyFqsyq0p6vna6XnA0Nrx6TUelLYK6Oqzpqj2WFz1VMfJo8KrE9l7NGRkMCKYLfeynLJ3mmSAvmHJJ7Efut6JpnNF9L3hkGnQWiENKcTpqchU5VPRCRfP9RUII2r2vgYU33Gcxt0ujBiWljWtkLZAOMDm6BxxFH84vdwnwrbpDPllbA527S289pQgR5TgsuNzur8kHJJU5Rh5VVmIfYymvx8sWfZY4x7D1Vzih0bc0/kghNKXGo8vuC7G1v5cQ4nvgg++09eFUNoaYOXMFyisvn/JlbKH/p20CFf0lcIMqSHNtyHKQ3nKTePjWotiw/9Ttu7iM3yCLn2f1m6/9GR4yI8fWxJwmyeyyubtlpnvDIs4C4G/gWLui1MiJpVYRvkhDUAk3OtH4j8O35WMQ+TEfkOlAokvQCdUMDybpe5plyLpm0+1U+NdaPFOseh3LasAdeHADWUmxUNLf55WafzNZDGtO0F4u1O44cYJlpp7ep2hIdtuoivllzIxIk4pSj2ZFrKvypp3LfXBZlVCjM4K9ChyGb1Ra3MyWWzxNd6moULIfu0vNoyeirlwiwz+BdZT2uQA6SZuz/8ZVMQE753B1NOYD4hdukF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026年07月13日 15:26, Harry Yoo 写道:
> On 7/13/26 4:00 PM, Hongling Zeng wrote:
>> Add a comment to clarify why we don't call kobject_put() when
>> kobject_init_and_add() fails in sysfs_slab_add().
>>
>> Per commit 2420baa8e046 ("mm/slab: Allow cache creation to proceed
>> even if sysfs registration fails"), sysfs failures are treated as
>> non-fatal and the cache continues to be used. Calling kobject_put()
>> would trigger slab_kmem_cache_release() which frees the entire
>> cache structure, so we intentionally skip it.
>>
>> Suggested-by: Harry Yoo <harry@kernel.org>
>> Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
>> ---
>>
>>   Change in v1:
>>   -Correct the email
> Hmm, the email "Hyeonggon Kim <pictureone@kakao.com>" came out of
> nowhere. Could you please explain why this happened?
   My apologies for the confusion.

   I incorrectly retrieved your email from a signature search ：）
>> ---
>>   mm/slub.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/mm/slub.c b/mm/slub.c
>> index 9ec774dc7009..edc822d7d9ea 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -9690,6 +9690,11 @@ static int sysfs_slab_add(struct kmem_cache *s)
>>   
>>   	s->kobj.kset = kset;
>>   	err = kobject_init_and_add(&s->kobj, &slab_ktype, NULL, "%s", name);
>> +	/*
>> +	 * Intentionally skip kobject_put(). See commit 2420baa8e046
>> +	 * ("mm/slab: Allow cache creation to proceed even if sysfs
>> +	 * registration fails")
>> +	 */
>>   	if (err)
>>   		goto out;


