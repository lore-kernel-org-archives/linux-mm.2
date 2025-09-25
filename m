Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61ABDCAC5A7
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 17:08:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7703F8E0007; Thu, 25 Sep 2025 13:08:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 748078E0001; Thu, 25 Sep 2025 13:08:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 684CD8E0007; Thu, 25 Sep 2025 13:08:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 593638E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 13:08:13 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F2C6E119E6B
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 17:08:12 +0000 (UTC)
X-FDA: 83928405624.14.C795FB9
Received: from sender4-op-o12.zoho.com (sender4-op-o12.zoho.com [136.143.188.12])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0F00C160015
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 17:08:10 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=yukuai.org.cn header.s=zmail header.b=l5sRIKuV;
	spf=pass (imf08.hostedemail.com: domain of hailan@yukuai.org.cn designates 136.143.188.12 as permitted sender) smtp.mailfrom=hailan@yukuai.org.cn;
	dmarc=permerror reason="Multiple policies defined in DNS" header.from=yukuai.org.cn (policy=permerror);
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758820091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xh7K/XJFQ6KkEtm/OLCF3JPZG7ct8pPnp/RtlikI1UA=;
	b=lJrRshqXRUNe4xlgqSDqC8r76e8J0VZAQXSjh+J88d6pyO+xOevF3QSyc0LfSeTyeVE0Lb
	5FVTJZsEmH3Etm5X94eyBLjPLnigAM7w1PJ+mRbWsG/6aIWYQ2AuAHsXnEsR0ystJ9Nbpq
	AsWO4adaSuWFkW1RSBH0xsaHu+xkypY=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=yukuai.org.cn header.s=zmail header.b=l5sRIKuV;
	spf=pass (imf08.hostedemail.com: domain of hailan@yukuai.org.cn designates 136.143.188.12 as permitted sender) smtp.mailfrom=hailan@yukuai.org.cn;
	dmarc=permerror reason="Multiple policies defined in DNS" header.from=yukuai.org.cn (policy=permerror);
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758820091; a=rsa-sha256;
	cv=pass;
	b=ZBPynKoujMkSZUUMzIXIzUal2MNAY6KFU9z09dlSVl0rrZKaJz8zDzLojCNzYZF+lvyJh3
	3DhO2WXqz1pn5tFpgCRP8bg1KjY18XRy1/AlPvf0wFjFKAUe8s7961C9eLUcY6SIvNLW00
	Wmx9j6W7ME6TuSYtppEPmD0G94LPN4A=
ARC-Seal: i=1; a=rsa-sha256; t=1758820071; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=PE5glDIsYYr7d4pKIscD4HkL/+QqyqDxWnAkaQe/NBQ5PEk0Djp/pd3gdknSw5LJ7o2I1kp+xCG4qBtGlCPxIMdBMI0PK4TBNhiG1pcgKOgwku9ffJcNb2KvWK6Aa2X6twhan+OCCTljOGpq389Al6Ckk5OkKHCmGPIMG4zskFs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1758820071; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=xh7K/XJFQ6KkEtm/OLCF3JPZG7ct8pPnp/RtlikI1UA=; 
	b=FySJUk52uxt/fWGi5Ma/0yIkUjR5kRBlSaenMNSNfu/UTj+/vcfS+ZVU70Su6VMHRFs8nikDn/hOBEPF8Ut6vfz0M4AK7mLb/Tp7LUYA5sTfNcASQoT3qg/ySZWL8fAmWxZ+ZpvPj1Ay9IusATNIk6LjIxvl9umRhTTWQjGHask=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=yukuai.org.cn;
	spf=pass  smtp.mailfrom=hailan@yukuai.org.cn;
	dmarc=pass header.from=<hailan@yukuai.org.cn>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1758820071;
	s=zmail; d=yukuai.org.cn; i=hailan@yukuai.org.cn;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=xh7K/XJFQ6KkEtm/OLCF3JPZG7ct8pPnp/RtlikI1UA=;
	b=l5sRIKuV6EnO3zuk5usTtk3gAlssOPDKZAWjYt6QRJ7KxG0XlH5PAxSXZ9LV4L8P
	K27KcsZ9I7CceXQPnIzcnspF6yfPE9rxBz/9as7VzwC+v/3j1BIDUEvB85CJyBaY2y6
	Bslw0a+cYcqbdLEgq9iiIBPlUFpxQLnO7XTs2tbo=
Received: by mx.zohomail.com with SMTPS id 1758820067677192.5730499183651;
	Thu, 25 Sep 2025 10:07:47 -0700 (PDT)
Message-ID: <01e7eccd-3529-4d12-8ad2-fd9e034a026d@yukuai.org.cn>
Date: Fri, 26 Sep 2025 01:07:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/10] blk-cgroup: use cgroup lock and rcu to protect
 iterating blkcg blkgs
To: Bart Van Assche <bvanassche@acm.org>, Yu Kuai <yukuai1@huaweicloud.com>,
 tj@kernel.org, ming.lei@redhat.com, nilay@linux.ibm.com, hch@lst.de,
 josef@toxicpanda.com, axboe@kernel.dk, akpm@linux-foundation.org,
 vgoyal@redhat.com
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, yukuai3@huawei.com,
 yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com
References: <20250925081525.700639-1-yukuai1@huaweicloud.com>
 <20250925081525.700639-2-yukuai1@huaweicloud.com>
 <bc6fe04d-3245-40dd-aa30-c3a3acb670c2@acm.org>
From: Yu Kuai <hailan@yukuai.org.cn>
In-Reply-To: <bc6fe04d-3245-40dd-aa30-c3a3acb670c2@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspamd-Queue-Id: 0F00C160015
X-Stat-Signature: 731yipococ44qh1gq8marcrkarwh7ytc
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758820090-454823
X-HE-Meta: U2FsdGVkX19E3+duQ9l6qP9UBl8YpgtzMGSXnzf/J/aDz/Zr/D+cfSgmj9BIzdIKX636OW5kTXUtSlNqAsP6jn6f2naS62Ih4GqRQEUwgI10rApUwItUH4dB2NkmivWplSNru0LBSsLefTrMtllThEBPNj1DkGOolclvqk/hh3HQomddEtslwiZ1Ac0KmvuT1VAMwxepl/gMld7E5TBzDthFTA+O9iC1u/BNFfQzrpO7wLvZ2IjcgjjRRtl9x09mkCV7DUq3LheB9a25EnpwR1461TZEadXfljfLG+kBygXiruHla3QDHHTJ31AZjHi6KYoGlRI5nfS7YXj1O1AFQAb0RpBgqa0uUpHoFf6yJRKPIWXBimtb2Zaa+8ediaC4Ispbfl3Z8GCOujeCBvw8JtqhiJ5Az1/nT7o+aXlQdfxp8vmrLIEiFDxh5ja+juHPf2NRD5pRu0/HJ0crhIRpNaIi8dRuzfxStONlTBVMn7ZEU1SMRs+0Tcr03doMd19pefQ9qxQm0jv8S1RY2CcIxG8YMtfTQNOesvGwtXXmHUvyCQKY8Y0JdNhja6mLfg4bgxPNOl4dUj3hXjcOmuAJIqqECCGH91vo/+KPajqP+bTfDupDkL9pstbIZ9Nv4vxsPgX9RxD0WPHzsKNzxQOe0jvZCCHmEBY8TFvqTw+DIC4Ftx8orpaWscSFwLtvt7SqyvoYx0jIoNHzGIYCxvgDb+e3U6lHVO83F1u0sFfSoQ0dR1lnt1MhXRMVRszG3UK7bgGSSYbEjEh2t4U30deqiHlpZyutmPcwHXh8DuxxyhuYuN8/HtZnRw8MyvGZwYsLyrAQZ+FjpG5Rnx9hhww/G7Kt960M+xP1lEYAmyAHXoMtYI60ZzO35KJHFmqzdbSK7ALQJ3kVcG9xr6GX9/KHKH/gfFd3rnWz/IFOSVyLxlj5OoGZbh7YneB9nhfi2f/LVwRqF/u/HVyqwhO2a7C
 nYJKZdSz
 a7cLOwoeX6yLsBIQvUMTcIbvHeAg9/FzbpeQCcvhHsnDfohQ9pVfz7gx9seBPTYQNzjjB7zf9I/OLXqieh/zO1QhV/lNawfkNwnkkh8i+7KDLn27lHJzH5LYWq7i/evqPo0LWRlz/t1M6VPlgwZGYm5OhbszTFqP0zeYe6Yzfwx9biV7hO0K6Dy7FUheBy/3cRsI0zmssb2Qpbbkhpr+Yab7HC093jFxqD36h8ng8RDBCDtbL2ADnybi5asE2lIz3hrwNSvlGjaOcWE8mhjbLRMJ4ltAwKa50bExXqW6fXqfgDF/fFseCGVN7dOxdXs1BIwH+B/bDBpcX9lfxRXCq+AcSU6PVNjHihy+Lwrgu5AVLNaXx4PGR8ApsMsykMQW88cVLVu1Uk3ei5A3dbEq0gSp1BlCCDJXDd6bl2FzdJgbhpOPtUuzMOJ+SXILs0ucYtysimOw2hHmBKCVU06wUU5wt3w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000001, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

在 2025/9/25 23:57, Bart Van Assche 写道:
> On 9/25/25 1:15 AM, Yu Kuai wrote:
>> It's safe to iterate blkgs with cgroup lock or rcu lock held, prevent
>> nested queue_lock under rcu lock, and prepare to convert protecting
>> blkcg with blkcg_mutex instead of queuelock.
>
> Iterating blkgs without holding q->queue_lock is safe but accessing the
> blkg members without holding that lock is not safe since q->queue_lock
> is acquired by all code that modifies blkg members. Should perhaps a new
> spinlock be introduced to serialize blkg modifications?
>
No need for a new lock, I think blkcg->lock can do that.

Thanks,
Kuai

> Thanks,
>
> Bart.
>

