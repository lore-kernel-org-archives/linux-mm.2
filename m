Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F281C982C4
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 14:30:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AB276B008C; Wed, 16 Sep 2026 10:30:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75B736B0092; Wed, 16 Sep 2026 10:30:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64AC46B0093; Wed, 16 Sep 2026 10:30:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4455F6B008C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:30:57 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E1094806E8
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 14:30:56 +0000 (UTC)
X-FDA: 85219862112.05.9DAB70D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0FE031A0007
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 14:30:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZMX7W14Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789569055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=amzHTUgi5PS6zBYPGEq5Q/X4VaQD9up3c6Cx/8cwhSw=;
	b=7QyQVwjPmatVGdOPAX7HPyBu3IH3JrfF+EC798kQbnnBqwN2xJ8s9kQKy3KcfWMg84Dr0h
	+u2kBf//TZs+5GSdKZyPwTxgO+GJ+LLvLvnJ+AgodkV5pwdkPKWPCUBl++rrWRtRZQA500
	IOMgHzC649hsEfjXrin2exzVzb8kvz8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789569055;
	b=NNAwVjYW6PfTht3Ef6wSRJN0t8IlwF3B5nXX72/y97D6eOKZh6Xkjd9XFk8UsZD/JJmQYI
	5eLk2nVCcBqraTKjw6ofugaHsfJuV21jMmwUVi2ni+/EyMBux0uxWjuQzdl6vSA1Q2E8P3
	EBjjvVV2rvENGVG1GDaRF3rI1wkOUkI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZMX7W14Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5A94F43D18;
	Wed, 16 Sep 2026 14:30:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C60901F000FF;
	Wed, 16 Sep 2026 14:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789569054;
	bh=amzHTUgi5PS6zBYPGEq5Q/X4VaQD9up3c6Cx/8cwhSw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZMX7W14YgRWUyiRnEHlGkiZId0AKfaLF82Jd8p3vI+UNoQcCzZns0j4mJFuEmXhKJ
	 JEftQXA3+bGpIDIIA9dSHnNfXwo2SSayTySqZ2eeuoejLJ4ESXl7O2OlwByjYb6am9
	 74nlyBEOzqJ84J/H9YYU72sOs7GCnyfXcLBVE9XBfqoIcxuaD7kl5gmxNb9ddjDJQW
	 Tp96iRDy2Wu2q8HCGIMlsfaOHKaOzIXztVtFUAYmJJzfpKWCDp3ua4mqyM8NSM0rT8
	 S+8ErRA82/1ect6mq6v2FWX2tCBCO0wVO0+hCH4yBeIIbt4dBmPJCYL8n9VnzfsddT
	 JlZLV62oBmNuA==
Message-ID: <67b63b36-82c9-45d4-8dd3-1bec2823a123@kernel.org>
Date: Wed, 16 Sep 2026 16:30:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/memory-failure: Support disabling soft offline for
 HugeTLB pages
To: Michal Hocko <mhocko@suse.com>
Cc: Kyle Meyer <kyle.meyer@hpe.com>, akpm@linux-foundation.org,
 corbet@lwn.net, linmiaohe@huawei.com, shuah@kernel.org, tony.luck@intel.com,
 jane.chu@oracle.com, jiaqiyan@google.com, Liam.Howlett@oracle.com,
 bp@alien8.de, hannes@cmpxchg.org, jack@suse.cz, joel.granados@kernel.org,
 laoar.shao@gmail.com, lorenzo.stoakes@oracle.com, mclapinski@google.com,
 nao.horiguchi@gmail.com, osalvador@suse.de, rafael.j.wysocki@intel.com,
 rppt@kernel.org, russ.anderson@hpe.com, shawn.fan@intel.com,
 surenb@google.com, vbabka@suse.cz, linux-acpi@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
References: <aqiIEkrc6aDBOqRg@hpe.com> <aqkCbgHmMGxI_GLG@tiehlicka>
 <aqmGd0GGUCkbZpkZ@hpe.com> <aqpYxAktjexhaMGc@tiehlicka>
 <ad36cd54-7319-4bb4-bf8f-9fcc7b009158@kernel.org>
 <aqqXbwglwYTyTuUG@tiehlicka>
 <36480c86-fc59-4387-91a4-cad839f502f2@kernel.org>
 <aqqdlndHq9vHeX8s@tiehlicka>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aqqdlndHq9vHeX8s@tiehlicka>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0FE031A0007
X-Stat-Signature: wsrkhj35ewer6pith6iackhqpxfk6jbt
X-HE-Tag: 1789569054-339222
X-HE-Meta: U2FsdGVkX1+vC+izoWdKEiuuvhYMWb4Rklivr0ch8eQke9ypgyTSNArTYqh5b/MzTfS5s+EDJ9Xp81xV+LYBAZ0Vf/CQqTiCUrz8cDUaiEHZPHN5A6SQ5mnIA5TEqZA3/P3jcgKpfwCS4Dm1as0NaRaUi3hzZ57XgGNBuPDl3JBPHAOKMvhu4jB9uApaG1UI24L5vdZNw1Nqs6m0RO9GudxD/T77wjRtL2hSGqfio9Pl+tlpv2c74EVLcj2DAqfma00tc4SthZ3ylyPlPoHYBAI7GUE20lOCkGS3nbMCulgGESXmH+16UFTQADGeinBPO3LNJ/c9HjaQ1UusEq/HDcjNAurQHaet5YFJE1nm4vjviWHmXxIaXG7pkqQPSSlbEAgeQOnmR20UPxLyGUjCDtsvUWwUGgiwt2ikVb5XbCDwiO1mT3cvV61BhZi+8LgpLYuDPoeW9UfHBBxUBBDl4oHSCle+Evkk0uEBhQl99VZm6B1ZFU+Xgn2wn8XdfuDHks2i5A6U5vDjWUpGUM5ypX784SzLs7wfZCdqKifJQ9ADvUopB2cN+MvSGh/FiLwEUutLFUfyvInpsxINiaG2ugSLwaLNpLuEG2a5nXc6/X+iSA9zequIXD1wtFNp5uZ+2nHWf7u5MOCBNRiJlK0yrXq1lra86IfyT4p+fT/rI0M37yrodHOOKgTzHZQ11f9HP0aqHu4QLZblEqlkfD4WgL1exYIFg6gu4ecB3cZ0x7OmGVtpGo8D3tiPu+fGjiA8i3llQ2lXCl6lgujt9bLOAOgOjyodYEcN+O/9kClb5BBFXHeY7Q+GeBMF6kGrkNsALta8Ere4WJgnukamgDnUMspIZT4PfI0am53B/01ClXHyPmlBmPBFhCr+tDcUHhaiT8oVpu7VXVrMfS0GAafEJ/nXPIC6qLd5zsM93MrMV1uuPu9poP0VhNhKdaIALUVX7uqKy6Hv0kRfFWRJXFv
 ++crzld6
 J4yXmqJSSnq5EaRoKbeojSjxQU5/j3qocPnQS3PwY8xr+tq3IIM3mEftbJaRgAWJARtLiAwJzoxis+MA2mqbE1CnmngtwIjK1amUYSFzDWgCZCFLMXZcAdG/hYxt1sTXsU41YLAFrG0xFfknf1dBfNCxvSU1SC4vn7Z3RMSZSa5DemGWyB2mdFOvtwDBsACvjejM4p6IgxTvo23guKW8frheyOF0EyKmspfrfZQLSXyvNjYawSJHNcDu0C6eThBBaCfzEXe6IUTqqthV/YYSFkD0QD+QBrwqbSDqCsl9aJAPzvTt+XQuFKN4NLGFdKWyO13crsikaHG6YwiBGznrbIsWhhA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/16/26 15:45, Michal Hocko wrote:
> On Wed 16-09-26 15:28:01, David Hildenbrand wrote:
>> On 9/16/26 15:19, Michal Hocko wrote:
>>>
>>> Yes, no dispute on that. But we have HW poisoning for exactly that
>>> purpose, no?
>>
>> Well, that tells you that the page content is effectively gone and should be
>> tried to be recovered / migrated away. Unless I am messing up terminology here.
> 
> Maybe it is me messing up the terminology...
> But I guess we have established that whether soft offlining is being
> abused or not, excluding hugetlb through a configuration is just a wrong
> thing to do.

Yes, it's odd that you wouldn't want to evacuate hugetlb but everything else.

-- 
Cheers,

David

