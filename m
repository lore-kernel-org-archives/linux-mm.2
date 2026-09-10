Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F1ACC79FB7
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 00:52:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FAC16B008C; Wed,  9 Sep 2026 20:52:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D32E6B0092; Wed,  9 Sep 2026 20:52:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20FB96B0093; Wed,  9 Sep 2026 20:52:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F305E6B008C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 20:52:01 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 69F4740357
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 00:52:01 +0000 (UTC)
X-FDA: 85196025642.15.202FE77
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8731A1C0002
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 00:51:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=OCDeLKE8;
	spf=pass (imf21.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789001519;
	b=A47HfZL0jjZAqk9qZ6CIlAVEqOM2i8hbxyu5tZMKxXWihuyGxYaEiYfdsMrWgRadDvgFgj
	3ZKKLkMVW3FqKGsaqGwSS3Gi4s33K/Xy4+S9JrF+KaMeOqfpd1dt6ttBhwpihPDq3Z/AC9
	xTxDVksaMO5vSASo5rwusXPRMKXHMtQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=OCDeLKE8;
	spf=pass (imf21.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789001519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AO8JmiwkDyOOjQQUcvZkGJAu8DjBBEEuc7ZAE11OeWs=;
	b=dPIo50HEIQvpovLy7LEVVqoeOC+oSoNMw48UxZKavzGJVktzOgCo/Hxqn3aQy4WhEb8JeJ
	RDwxQyV1/3XhNuLxtQoODmgx8cIhTLGyUhpeK3WotIGMxg0aW7N2WSLp/24NmYbEmX1S20
	SJWiHrMa5S/ng1VZFbx64AxtnUZ64gQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=AO8JmiwkDyOOjQQUcvZkGJAu8DjBBEEuc7ZAE11OeWs=;
	b=OCDeLKE8cU5YJytu6w1qv20p36KcBOqfKD8llXopOrF3Sr1zT+rdLO30/O1Zhs
	JZDrBTQ/EnhaMUk4VE9Rsf/qf/lJZzr1If4uHL3QPLc/zsosBD5IO78tc7xrOS7/
	DSWzbuJd8Sse2nWwnMXYhtROCl8cfiy3qDdyQSHx9JrOA=
Message-ID: <84bb8f53-54ff-4153-845f-e085ec649d36@163.com>
Date: Thu, 10 Sep 2026 08:51:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm/ksm: trylock the mmap lock in the unstable tree
 walk
To: "David Hildenbrand (Arm)" <david@kernel.org>, xu.xin16@zte.com.cn
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, chengming.zhou@linux.dev,
 linux-kernel@vger.kernel.org, xialonglong@kylinos.cn
References: <20260909110228828hKTCgUeuZkOujOBaVtUcL@zte.com.cn>
 <91cf8129-d705-4ebd-b420-129bab7ed261@kernel.org>
From: Longlong Xia <xialonglong2025@163.com>
In-Reply-To: <91cf8129-d705-4ebd-b420-129bab7ed261@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD337YT_6Fq2xv3Bg--.17001S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Jr4DKF1xuF4UJw4UCry8Zrb_yoWfKwc_AF
	1vv3Z7WrZrJr1ftr4ayw1ftrsaqa1vgFyfJF4YvFnIva4UG3WkZFWYq3s3XF1fWFWrWa98
	CrnFy3yxuas09jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUjWxRPUUUUU==
X-Originating-IP: [2600:3c15:e002:6267:9ce2:e233:64a4:205f]
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC3AQMBWqh-yREugAA3-
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8731A1C0002
X-Stat-Signature: ax5iu6yfyrmn4i98fridm7ytaz8txjed
X-Rspam-User: 
X-HE-Tag: 1789001518-170725
X-HE-Meta: U2FsdGVkX19FX3pZuUf8d8CCbsUTqSlJtT69zFlq1fFMdRPJ81zb+vkgVm/K07fv64bMe6y3K6Rw0ozNNYXL93h4W4ueizk7A3UCIwPCRv5/FWyKC+OG2PULOgoTuaInSd4oWlxNM+LLOj39QUK1KGghvsX6Xsm2vJW6w/tFK55BxAT4GUaX4+tIKgtvKVWWB7vt0cyJKeiB5bWgtBYLaP31zeH+bb2L+q3tn9ST4u2NU0GPTLr5yUeAZVDy/h+/uO7YcX3hX1JHGrT8eiHuS8IzadfS50NjArGwSeKOW8EEiRIoQS9sU+Ljj52kiqI9zT89bCsEHAMTZgAeE+ilxAjtd9nSoQNxWKKpode0LxMLXigqH8krfabD+L6CU4bO1EO88SqyhxuNsnUytHV2JdE4peD8uPBebqMojPSAguQvIRnUF83X6ZujeS5X2Q+PjEU2ZZe+elopZa/7ZxC6w2I4+5mx3FQ7KD88aztBgBKvGvm1fFp8YNTnQM7bq+H4kLRf08plIu8BaGyumI5kZvFcUZAXaQiQI/1f/ekNJS4VwCBDdkqI0G1SwGLZi4y/44gzPxK675z+6SZY86JcoR7UiRTsKaryoVnXosZYNjUW5x9aB0P9/tDtOoG+0h18Orux5CCxTppendkigqrBRDE32VorM0xJA9DNfHHhhfn7MTHeYZscleysJIKf1zoNdMTySsv13UvAVpRLl67wfvEIDjw5SgzHfvi1ODywQ/POMMFEoJUQHpw+5gIemR1QgU+EHZefWaxkGAy5WHbiH3H2MQx5NAaCCTSBrcxFj3U9YOqVWAgUFIYOIYi5uo8A7LYZjSyoRaZ/kSgjQsSmL05OAC1S31OVFSmm1cZOI3KvJMXItgkqcyfnKEPQK8YUqqzyeTfS+fqBbM4pjBlg2hbgwjg9h4tvVjK9jred29W02aiwQo6gi14Kc3r9C0IkMmavQwA1Qse9WKdwTOE
 4ruZHSBC
 N74mua9SqxNhrJI/Qm3cCZrwaWi1dugbVvvduQ4cRQYWm6Sgw9FA9NbiM/nwrSDnpgmiKn/QkVJk9Bg1SnWglp71lC/SyAr77h+UFJ+lUjYshvXSty9yB4RHn1QYuqn1ATbeNtfPc3rgFiVki5zpdU+iAoEKrfWNmP73fzzWCI/qNAFegQLex41EDKALRrCa+Ii51LmaxWAweHBQ2XxFrnD1fAjrB3ePOvZJgehpGzjX87r3CDPSqOy2Z53WOMlBW6ljvarPeIaBdUUAHi+ZuZhrBpWjy5tc88DBrwPqcVaprtV7EGr/5wOKUHNFWDQ99oUYiRv0vbBvyJD4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for the review.

在 2026/9/9 23:17, David Hildenbrand (Arm) 写道:
>>> index 49d48d1e0998..3cfb09a926ff 100644
>>> --- a/mm/ksm.c
>>> +++ b/mm/ksm.c
>>> @@ -820,7 +820,14 @@ static struct page *get_mergeable_page(struct ksm_rmap_item *rmap_item)
>>>   	struct folio_walk fw;
>>>   	struct folio *folio;
>>>   
>>> -	mmap_read_lock(mm);
>>> +	/*
>>> +	 * We trylock because we don't want ksmd to wait for an mm that is
>>> +	 * busy changing its memory layout: we prefer to skip this page and
>>> +	 * let the next full scan retry it, like the folio trylock in
>>> +	 * try_to_merge_one_page().
>>> +	 */
>>> +	if (!mmap_read_trylock(mm))
>>> +		return NULL;
>>>   	vma = find_mergeable_vma(mm, addr);
>>>   	if (!vma)
>>>   		goto out;
>>> -- 
>>> 2.43.0
>> Sorry, NACK
> Agreed. Likely the answer is to switch to per-vma locks here. All we do is a
> folio_walk_start() to look up a page, that's not too crazy :)

Thanks for the suggestions — I'll explore this further.


Thanks,

Longlong


