Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21AEECAC5AE
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 17:20:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E93A8E000B; Fri, 26 Sep 2025 13:20:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C11C8E0001; Fri, 26 Sep 2025 13:20:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FD448E000B; Fri, 26 Sep 2025 13:20:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4F2198E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 13:20:15 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E01B81603EF
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 17:20:14 +0000 (UTC)
X-FDA: 83932064748.27.768A899
Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0B7B940004
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 17:20:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=XBDNDX7k;
	spf=pass (imf12.hostedemail.com: domain of bvanassche@acm.org designates 199.89.3.6 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758907213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e5cciZIOlUEd14Nlh9r6UpPh7CEgs/6L/FSJjeP9WoA=;
	b=UR8Ku2BFeDZVlbXU4sAn7PabH/oF/qBh98HNO4lMM8nJ+tp8QajvJmivRTzNamEzpigWfv
	8MzLidBUjP/F0EXeJVkaJUy+nJQIVN8oqH1AdWkUezJYeFOKNWfQO4vrVPyDV7jYePjVQF
	QdT0CEpj+FHe86vFetYMsgnuFk4lOPA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=XBDNDX7k;
	spf=pass (imf12.hostedemail.com: domain of bvanassche@acm.org designates 199.89.3.6 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758907213; a=rsa-sha256;
	cv=none;
	b=5tIls6lhx9Gb4voC12jlCpFrQ4jWDkR6i2ozSsOzoTeUOSJBm8tuA4UdCeRRJURPQEpfvC
	ulnK4RMtvvlIYdOrDZSEQGx5xt5I9nki7NpH/KtlzyJrXWyN4Fw5n6NQinFxYiBJ4+kfzt
	yYKsC0PMN3sPaf4gTVLUBLKrFudLlp4=
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cYHQh1MRvzlgqy3;
	Fri, 26 Sep 2025 17:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1758907209; x=1761499210; bh=e5cciZIOlUEd14Nlh9r6UpPh
	7CEgs/6L/FSJjeP9WoA=; b=XBDNDX7klPhV2LR5Gj/vZnR8shvGvAnsUOjlCkes
	3lenIfMn+DwuRVIZO+Vbr/D1uJ4gOCAPt8k8ZyGBAbr/4xLQHY4DXNHjFRlN/2pG
	Ih6HAHDSWbsF3/pj74+qi3zH6Lg7//Esh9EOA4uqXzio29j1fLOKoPhgqywc7P0w
	sHY8VE/+rJ5hirGz2Thkh5kk4BHltVC7lqIKhJHoyl/MsBET/N6Y+95WmcBsfuk3
	+QdpPt4gMbce9m1iBQ+/x9yHOzExEf+BzmheZVt+M2pFj0DH4n7UFUT41Kqc3RlN
	foQEesFSXjuWNV6F42JvSc45kXjABX3SLM62dUcH17Sjfw==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id GuQ2MpjtDxTQ; Fri, 26 Sep 2025 17:20:09 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cYHQL0WV5zlgqVf;
	Fri, 26 Sep 2025 17:19:52 +0000 (UTC)
Message-ID: <66dcdcd1-df71-43b9-a468-2b4aaa8b6dc7@acm.org>
Date: Fri, 26 Sep 2025 10:19:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/10] blk-cgroup: use cgroup lock and rcu to protect
 iterating blkcg blkgs
To: Yu Kuai <yukuai1@huaweicloud.com>, Yu Kuai <hailan@yukuai.org.cn>,
 tj@kernel.org, ming.lei@redhat.com, nilay@linux.ibm.com, hch@lst.de,
 josef@toxicpanda.com, axboe@kernel.dk, akpm@linux-foundation.org,
 vgoyal@redhat.com
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, yi.zhang@huawei.com,
 yangerkun@huawei.com, johnny.chenyi@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250925081525.700639-1-yukuai1@huaweicloud.com>
 <20250925081525.700639-2-yukuai1@huaweicloud.com>
 <bc6fe04d-3245-40dd-aa30-c3a3acb670c2@acm.org>
 <01e7eccd-3529-4d12-8ad2-fd9e034a026d@yukuai.org.cn>
 <688275d5-fbb4-08b3-45e1-798ad8cf77fc@huaweicloud.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <688275d5-fbb4-08b3-45e1-798ad8cf77fc@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0B7B940004
X-Stat-Signature: zp5qh7tgbtfmsh98yry4mjycts6apeam
X-HE-Tag: 1758907212-941112
X-HE-Meta: U2FsdGVkX19pFAgzK908Y0rnh7j57hxO1iYZlyz0Ot1Oy23cgJjjn7mxlPElU+Z6kbDRyiL5Aniwm+NNTF3sCxZ0IjhTFGVbwbbPty919F45kqANxueZlIXJbBHATj0l8qfko9qnxGBZxHnhGSAQKrBB1sHqmF+6mERV5Gxdyu3y2Ppu8E/zlyFYIkX9BaFU+wH4W/2UFMd+gsucghZHyA2F+ig9YjdHXC/nSb+WBATdMPLRzbNFNpk1dllc5wtVR6M29Z3YWpom6wz42EDVtCYGQ2FHwrfRmBonvqo8D+WY3FywyqYV1xfUdmC8dITBHWEntIlV/fWjkkWmLKmxXTz/ukCYH3/nxO5cjPrVSpHtGPPMWcuJVso0raKzZILDshDqrGk3UPL0MddQH8ckPdoU38UHXkPbIjSjLgaLk81kI4YQaBqeLX1WJOYQ6o6fKOnvqXFfZhqhNVSi3QP2CJTb8My35XMmZxkJ/zvJynC1I4y8LqrgBEmpfLXHT9nr+Hsb9jH2g1rse0wOIYzJXt6GmNn6pd8cu3KML7FYrBL8bDaufezl9LEuhCEOiRsm5vy0sP+Bqu5z8GoErVFSYsTcEaz68Sf8Lj+DDatRiLuANnYOOp8wEUQk3v7GjXtHDon7cdjRPPYfSSCroNSR5seaU318TDZBz2V+RSSRLfzIp+QQNmKREJFLr6sdG3IJC/FKl+ciRzJQgtKqu0XNwULLamgYxj2RV8fAQnrCsGmuwhA6BJDRHRMRuTZ8IWhzqPZDRmm0D/fe2IWP6sUXvGeocrH2I7RnAXAJgCQ4IGKe2PE1M/zTSh4wNVQSEv+5/7TlmJyHrZkcBBUZnBffXJXFHl0JdfoTsQ67cn53aj2hqv2G1rGATAmn9TLbmkApNOiP7JfLoBCfUXxXXlLdel5xD2rFHENvVd0DdX76sbmrxnw61FwhCNgnsbd+izcOOvf8fN3VNU90qNYnPGX
 DR+sGdHX
 ioaM0T9kllBLXNaqr03loEE63dQjYgKjxYGlsmkYo3wCfqK8bUmgytfCXeAKkjLSOa0pgxU6SktN6OCPPh+XybFofleU97/U6naxCfefosVFyhwTAzK4jlzmXVgLFpDrbBJXFQfbQYA3N9QldVVNtKOgGAsUE731yqN8mUCyB4UQNhaqQMTVgRpqz4nzHeFqGmVjKE5o7MoxiX26/vLDWXp9y6YDaRqi8vTG6OTqJ1jaUCNbrHCHlsWfWMw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/25/25 5:57 PM, Yu Kuai wrote:
> =E5=9C=A8 2025/09/26 1:07, Yu Kuai =E5=86=99=E9=81=93:
>> =E5=9C=A8 2025/9/25 23:57, Bart Van Assche =E5=86=99=E9=81=93:
>>> On 9/25/25 1:15 AM, Yu Kuai wrote:
>>>> It's safe to iterate blkgs with cgroup lock or rcu lock held, preven=
t
>>>> nested queue_lock under rcu lock, and prepare to convert protecting
>>>> blkcg with blkcg_mutex instead of queuelock.
>>>
>>> Iterating blkgs without holding q->queue_lock is safe but accessing t=
he
>>> blkg members without holding that lock is not safe since q->queue_loc=
k
>>> is acquired by all code that modifies blkg members. Should perhaps a =
new
>>> spinlock be introduced to serialize blkg modifications?
>=20
> Actually, only blkcg_print_blkgs() is using rcu in this patch, and take
> a look at the callers, I don't see anyone have to hold queue_lock. Can
> you explain in detail which field from blkg is problematic in this
> patch?

I'm not a cgroup expert so I cannot answer the above question. But I
think it's clear that the description of this patch is not sufficient as
motivation for this patch. Removing the blkg->q->queue_lock lock and
unlock calls requires a detailed review of all blkcg_print_blkgs() and
blkcg_print_stat() callers. There is no evidence available in the patch
description that shows that such a review has happened.

Thanks,

Bart.

