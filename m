Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DED15C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 10:28:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C26266B009D; Tue,  7 Jul 2026 06:28:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD7BA6B009E; Tue,  7 Jul 2026 06:28:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC63C6B009F; Tue,  7 Jul 2026 06:28:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6E3EA6B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:28:54 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F06311C38A3
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 10:28:53 +0000 (UTC)
X-FDA: 84961607346.03.3EADFE9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 29B9214000E
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 10:28:52 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J9DPrGGt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783420132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SMVVynaiIcC64geRzUrVGlqDYtKGFWyxgpAdJAcSdBc=;
	b=w3+bqgOHtnuenOXtP3AU7cS9hn0e+fDlbZ5lwaxeIJtaurTyf358UQ+S6/lnlbifioKO/g
	bwLd0at4n7++y3+dAd1cTSX171rveufyAKVfLqI1xoXAo+AQFmZcLRZ/dWxDMdYf9uUb0H
	GzNmg4JaGWN/I+3jhRiUClzQhVjWf/M=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J9DPrGGt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783420132;
	b=IVfepASOaVPlQ3UoI93d4EG8wQS1xu6x6xVZrhTLI4auo9dWgvZXZNypRg2DN4kG6qlYvr
	f4qddBPbH0nkPkDYjowuUGcXhYS2yfajx6jkRyeE2el6nwdTGiknFCnZz81A5eNV6TczNe
	xC/lCuP7d2a3sUKaRZua2u0sAeYO7mw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 561F043A98;
	Tue,  7 Jul 2026 10:28:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EF4F1F000E9;
	Tue,  7 Jul 2026 10:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783420131;
	bh=SMVVynaiIcC64geRzUrVGlqDYtKGFWyxgpAdJAcSdBc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=J9DPrGGtlbSY0jMFPO0H35bwXuwnT5TejINnGOTJSJYtTkaazk3Bc+XgTcHakJ3sE
	 ETbp9erswHKO+yKxyu9NxKpxfMD2j28OFBbGItqhRbbrcSMP6dnBlLmxXo5QnXD/D5
	 xY8jmQVApbpd1uPtK/7agi/koTAqXU4yy0PRK1aAzKuy5CVPsmXDGwneDWwhVfoVze
	 SOT4/W50EjJmAqtksgEYGTNzqVBe//V0+ksZcYJqKdFoYnH1/8TdB9PFv0KMtMIs1X
	 yoWo8K3PuX8IcSW10U9YTZWVV5BsfJH70qgSH1nj7pE6mmSChNuiWpAHR9dSIHDHbo
	 KOP3ZcfD0Dh/A==
Message-ID: <b9a48d89-74f1-43d4-b7bb-be988b6855c9@kernel.org>
Date: Tue, 7 Jul 2026 12:28:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/6] mm/hugetlb: Dynamic, NUMA-aware HugePage Cache &
 Free Page Reporting
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Sourav Panda <souravpanda@google.com>, muchun.song@linux.dev,
 osalvador@suse.de, akpm@linux-foundation.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, mhklinux@outlook.com, fvdl@google.com, gthelen@google.com,
 mike.kravetz@oracle.com, pasha.tatashin@soleen.com, rientjes@google.com,
 riel@surriel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org
References: <20260707064235.1386552-1-souravpanda@google.com>
 <9624988a-366e-4884-9408-3f3b88c27290@kernel.org>
 <20260707062428-mutt-send-email-mst@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260707062428-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 29B9214000E
X-Stat-Signature: 8udbkybkqnccica96i4fayzis86f9tfh
X-Rspam-User: 
X-HE-Tag: 1783420132-47965
X-HE-Meta: U2FsdGVkX19nnROg0rR4amymc0W4BGkuOuU40ARfklJRaS35gD9TRKPOIIjN9lqvhvzOpU5qduxixBYh37gxggSkqGBGEUvetfUaOL0sO5zCjAPKgOjLaabIAH+SLQvw4i8XQ1n0ghvgo9imldnPdjqkwmJ7vEsLzH/WfjhC2jYXTkXgSABXZl+LWfvtTn8eIBotfeEudV4onGplIt2uhl7OCZ75hsxmSPF6Q7Ji95z59nmRkoNFyXZ9N5MHar/iX8QDXa9WmeS+QaYNDNry6lH2f8dbWpVzXAxow9bs0QlHnGM6jCnJsGbnupWczg/iTDyWzJSp3CD5z2z60gTD/Rx6beGEtJ6Avauia2qsi0/QrcpEvXhsC/aVspfOlyDaYAXeiEOYwilHQUc5rCzzVYS6os+a0oz7KrJy5JIoWj4oPewW8k9Xf7xkT9MSdRtrPyEyZUDOrU/pQ6a3kopAQzqr2DasICtEkgAhThROcyOa4RqmevyTe24IAjdowmFchEcW5zdqs/fQoNY9IV0tUur6I1iZpqImKkgFCl5+o7v6ZL2eUQeuPDkle/qjXUWAQjV2fivYBVIVHcoZPQUfMv43tr+QI5l28Qf64L5A8ikYcdZV6fHxKkl2k0tVPwWErOqCgKca4ynQnKZ+WDPF2tMqXWsnK0Mdz2Qg2Ln3VV0E4T8qQUOjPFIZwiwp1Gji0mps7n2hbryIMm+EasZGgPJ67evSxx6E3X9A7y2oJTyAAyelJWmZlzmOUpO3R44RPH42CKrSQTl2hbekE6/4IRMnnLqr+eRMOBW0ib5DXFJ4v8UWbOSrfy91315ueFexYj/I8QTCszRNua3pX5lrK4o9BkRBl1uvlQl8EaosCsqF4m9OIJpjUMbFxdfNYXYv/bMiE31KDQY78PFG1fLBXacEAmIkv5tqMsRUZ2rsz9i8ZnIdM2+/tUaW7gMjUN2GXO+YsXosXkywPs2Eebu
 oaYOJWZz
 GrhNFyGBVcprIJDmxLizssOOiriad2uUXT1pxmMFRVWBNaSa5q2zVflEC9aIC5w5zqHf/47n0BYhj98dRyT7JXzcR6pC5SgpjOLh2bihbeuvTn1YbW/EhyLtq5R5eHYC3Ye/0EMPPPBhEwOoYqPpZ6GVpKoxRFYS9mygcqu5JF5xqAqxKdMzrFSkRi1HCGRnsy1EC9ehi1ebZLQoQiOiFPmoKU8kPFJmrRJXOyvtCjoZHKktOweLDeZtm3oW+Max7uzXb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/7/26 12:25, Michael S. Tsirkin wrote:
> On Tue, Jul 07, 2026 at 09:29:07AM +0200, David Hildenbrand (Arm) wrote:
>> On 7/7/26 08:42, Sourav Panda wrote:
>>> Overview
>>> This patch series introduces a dynamic, NUMA-aware HugePage Cache,
>>> backed by a kernel shrinker to safely return memory under pressure, and
>>> integrates it with Free Page Reporting (virtio-balloon) for HugeTLB,
>>> specifically targeting gigantic (1GB) hugepages. The goal is to solve
>>> the tradeoff between allocation latency and memory
>>> fungibility in virtualized and heterogeneous cloud environments.
>>
>> Hi,
>>
>> in general, we consider hugetlb nowadays to be mostly in feature freeze, as we
>> realized a while ago that adding more special casing on top of something too
>> special for all of MM is only going to hurt us more in the long run.
>>
>> We want to have less special casing and less special sauce, not more.
>>
>> Now, there is nothing wrong in making hugetlb be less special, by making it use
>> more of core infrastructure etc.
>>
>> But optimizing for surplus hugetlb pages by teaching hugetlb about new caches
>> and its custom free-page-reporting support rather looks like the wrong direction
>> for me?
>>
>> -- 
>> Cheers,
>>
>> David
> 
> 
> It is currently bypassing free-page-reporting completely.
> Making existing free lists not ignore free-page-reporting would
> maybe considered "making it be less special"?
> 

Depends. We don't really want an orthogonal implementation of something we have
in core-mm.

-- 
Cheers,

David

