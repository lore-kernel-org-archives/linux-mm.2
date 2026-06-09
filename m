Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D715CD8CAA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 10:30:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C32B16B0088; Tue,  9 Jun 2026 06:30:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C09926B008A; Tue,  9 Jun 2026 06:30:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1FC06B008C; Tue,  9 Jun 2026 06:30:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A052B6B0088
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 06:30:39 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3733F1C1FAB
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:30:39 +0000 (UTC)
X-FDA: 84860005398.17.3023214
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 645D8140003
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:30:37 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UCfhvpTn;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781001037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=26KX2jHwHNm8eXprGG2y3XAY+vgE+LdH1rP58OyeAbQ=;
	b=KyAOEza13fvcJbqTtBf/h0rrij4qb1ZEdrG/dEv6ucGXgWKwIJhgOQeZH5ZCNCXPfm8hQP
	3Nm2a8Sgh5FcC0Lje42vbUOJWluK7Uk3j97Opy1HQt98+l7LLssa+wV5c22tJ3yPvNfHTi
	/mu19TYSDgbpwrECFZso0d6UUyZl2wo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781001037;
	b=3y5wT7spC8K88pnnOb+5E1rUKhMeNfkNrzIP/m466vsHVSK0mikn/jWOPaIBGmYW61dEhK
	EXtv7XZY9b2izUyzdmw8oezqifofTTYzGXVcL0liYdtUmfyIMRxkqUjcgAxn1vv/fGYCs5
	T40D9Ci5xNt7dDsFX3Evh87ZLQ9eeT4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UCfhvpTn;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 82DBC4435A;
	Tue,  9 Jun 2026 10:30:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9679A1F00893;
	Tue,  9 Jun 2026 10:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781001036;
	bh=26KX2jHwHNm8eXprGG2y3XAY+vgE+LdH1rP58OyeAbQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UCfhvpTnSWk2f3zzIKvXboL/IH9t3wMyYHffBWdoOBJh0lEGYxvv0zMa3e5khz7Le
	 d2hzbsG9Gfe7mwc1pb7bEG6rhE4CRvs+AvDc8vRZ8f+6eR+UD1iqDDFPCyj2Rjc984
	 SKmCJ/ytgoqedkPhHnbCN2nkcEMnwTu4x4rla/rMUt3ym7XOJHiPCHBTQxTug7sCBM
	 ziie8680XZupr1eKDWYgo684B7VPQWYc8gh4SyhYx12U6PuKuM2U44FY5l9sLJY4lv
	 qV7Rf59kBPiMcoBEXMkYMzkLqUf6YMl0Kuku8zoyGVjXBoa5dBfriyEV8TBJ6AB18Y
	 BOKSb6lbKn2nA==
Message-ID: <54b57630-f33d-4982-b8a3-b358b4cab30f@kernel.org>
Date: Tue, 9 Jun 2026 12:30:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] userfaultfd/pagemap: pre-existing fixes
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>,
 Mike Rapoport <rppt@kernel.org>
References: <20260529172331.356655-1-kas@kernel.org>
 <20260529173448.40a37785ecbecb6868fdd6a2@linux-foundation.org>
 <ah2S7MJ2VK6R-NSN@thinkstation>
 <04875b82-6671-4f43-aa59-190fd09c7108@kernel.org>
 <ah_xuV5PUKTfT5ua@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ah_xuV5PUKTfT5ua@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 645D8140003
X-Stat-Signature: shu6pkctxjorqpmqcek6qwdi7t7fu94k
X-HE-Tag: 1781001037-141452
X-HE-Meta: U2FsdGVkX18sHX9+7GSOvptZ4hmchyHM/Ms4t7WDFS0+Nfg4UBYM5TbatgBP/JYyE0qkbVTB0tdydrYJdnBvuXmjC7ldbKf71EgZ97lPsNvhOKzq2okDCYXzJ9O554RpLkLcDEobo6DsYvK05+OJlNHSSBYLjzPmCP77N5i2zeAreu+7qwsmek+J3fNmjIjdMdotNtYocBf+SmCmgBpQ9GZJLJTvW51qz9fzwsjKjZ+Kyd8VLRi8MUDKySsp/t3ksjvvsrO2K2Pk/lYZTXNg7h9vzrmvzZlqaudo+r4sGpKfRii5T7HtHn1fQ6tD5/MNYvV9w8XVm8y+Gb/pyMleS68uiujzbBhTSx4JVXE0jR2H7CdkxmciYaP8lIF93l2DtLP318zd1zCce+FOJ6FjphnxPu2TnVntMPP1k4uT7uy18CnWCOfrLZGhYWj4yJ9H5mYY6lKEuyuOLNoAxJA9aEtSi2UFyaWs7bObcvoqDxSRzgh7X4Snj7Cn5snZd93meLXMj7USIQd7fxo12RCwCsZKq144RUWqRCIuvRq4XhCOoEVuMdSaUtHf4MVHMW6RslOl5at/QD/xnZiIfv2Y7S4Ax0jwaDz9IjjaBQlcGRibKfpsH+ZdH/TYz0fqaxEhThYhPfL1DlCYdezQOc4oXt124vNJ4Dgy+jxzc4ucfMGMVHkO7HhIu8ahX6mftCbc88Ab5YogPdd+UV6bAv0OHgpGNmk4JRlGEDZHLfZ+bEFap6fZZsMHpVQTbNVlYCAm+cQ/Ab23eTs15/CtCnaRHtCSASzDbvXkDE19ftxC+SUiau3iVSGSkKc7m8E8MNy+hyVVpB67hemItHteuvKRGpld6Ad7Yb16PZeGZ5uBD4q40mWYQA0kzhu2NQAdLkME+nHLKISA6KXg5k6FXcy6pZO/wbMJnq57OobnPDJ4u28smlEJakxhh6eUpx1X4ZvO65LhKiAkzb2V/VMa9jA
 htELBJTl
 zjZbLfg9eEZIURJ7yKpSzLxKNQiV0c7X5AvwnhhknyKZejBCXaC+qnZM6gtFde/K0ZqrKqNldiwQWMmcVX2gTHgU1f8Fg6d1J9IhAn+gexkm+/HkSMOX3XnpRMUjIe7N890D/cDYR85yt+6mLHquVeqT77jNResyzuVeGXWcjtuwnQXEpgBtgwU8UrKqqlHL2i2pp7KKrfSUMVWSoCtHy16/Bdr0dasT3S25Ja9rQ3Zndt5iEaMePtTlnM9cIwn81u7Fo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/3/26 11:21, Kiryl Shutsemau wrote:
> On Mon, Jun 01, 2026 at 05:04:31PM +0200, David Hildenbrand (Arm) wrote:
>> On 6/1/26 16:17, Kiryl Shutsemau wrote:
>>>
>>> Seems to be passed now.
>>>
>>>
>>> Yeah... :/
>>>
>>> I will look at the new batch of pre-existing issues when I have spare
>>> cycles. I am not sure I have the bandwidth to find the bottom of this
>>> rabbit hole.
>>>
>>> What do you want me to with the main userfaultfd patchset? Sashiko
>>> failed to apply it because it is on top of the pre-existing fixes.
>>
>> I suspect it might have a minor conflict with another incoming fix from Lorenzo
>> as well.
>>
>> Probably put it into mm-unstable early after the next release? At least I think
>> it's not in mm-unstable yet and we are approaching the net release quickly ...
> 
> I guess I would need to patch man-pages that got applied. I put 7.2
> there...

We really should merge man page updates only after stuff is definitely in. :)

-- 
Cheers,

David

