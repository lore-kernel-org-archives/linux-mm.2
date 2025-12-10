Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07FEBD3B9B6
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 00:38:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F2566B0005; Tue,  9 Dec 2025 19:38:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A1716B0007; Tue,  9 Dec 2025 19:38:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26A9C6B0008; Tue,  9 Dec 2025 19:38:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 112566B0005
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 19:38:33 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8DA7B58630
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 00:38:32 +0000 (UTC)
X-FDA: 84201700464.25.FABF2ED
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf28.hostedemail.com (Postfix) with ESMTP id 27F77C0009
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 00:38:29 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=NSDvUYM1;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rHHBaVK2;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=NSDvUYM1;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rHHBaVK2;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf28.hostedemail.com: domain of hare@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=hare@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765327110; a=rsa-sha256;
	cv=none;
	b=4tCPafrXvMcewzUsxbbjJxOqotgdc7Tv46Lw7idIiIrqxsyFPRnpZFbH08N45sTht2WMTT
	YKmwN7knfttqr3f1uwmJEbjcUr6ld06ghLflEzNIdbDdao9YCvtmSbdGI+hsc2HhmT1DZE
	67ZfXGjqeiviiYAklxbBNv1dZp1XfF8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=NSDvUYM1;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rHHBaVK2;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=NSDvUYM1;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rHHBaVK2;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf28.hostedemail.com: domain of hare@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=hare@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765327110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sZNiUJuG3TeKZsNDlVrI19mlrKWSweIT9h/omtBTHB8=;
	b=A6ZqTiI+QAap2tXmINiXG0YIMoXWd2mkb6CimKOT9+diM6cZgy+jFVyHmQ2k//bp46HB7Q
	3PLAEQzdkolrgUL07BrdIt4X1IOn++JXhpllzB+i1rDfXXrvMyfIKdxOh/JtKu0iXjOmpG
	TWDPvSoFnABIFqIRGXfMOjrQxoXiMJs=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 974F7338B4;
	Wed, 10 Dec 2025 00:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1765327108; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sZNiUJuG3TeKZsNDlVrI19mlrKWSweIT9h/omtBTHB8=;
	b=NSDvUYM1HDtqM6oPFiwMjjuKWt4EqZKJymRYKTh7+EzbnTgM8NgnBjhnDhEjH2fAkho4i5
	Tt/7gFFhQ50Qp0DqvIcM0fGxIgnBLATl2OJmaTMwtq9K8BsLPKR6Y4f479SGw9c0fn8kBQ
	YFRJzly+foIx/GASnxveaEDorM0zhZk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1765327108;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sZNiUJuG3TeKZsNDlVrI19mlrKWSweIT9h/omtBTHB8=;
	b=rHHBaVK2YDKlGAiXwsxjk4Zl6UntY3f/wo8LTvZ6U52z2ltaHfrD/w/u4Xc6paFySFxx55
	e1GPfKAztuHd1UAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1765327108; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sZNiUJuG3TeKZsNDlVrI19mlrKWSweIT9h/omtBTHB8=;
	b=NSDvUYM1HDtqM6oPFiwMjjuKWt4EqZKJymRYKTh7+EzbnTgM8NgnBjhnDhEjH2fAkho4i5
	Tt/7gFFhQ50Qp0DqvIcM0fGxIgnBLATl2OJmaTMwtq9K8BsLPKR6Y4f479SGw9c0fn8kBQ
	YFRJzly+foIx/GASnxveaEDorM0zhZk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1765327108;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sZNiUJuG3TeKZsNDlVrI19mlrKWSweIT9h/omtBTHB8=;
	b=rHHBaVK2YDKlGAiXwsxjk4Zl6UntY3f/wo8LTvZ6U52z2ltaHfrD/w/u4Xc6paFySFxx55
	e1GPfKAztuHd1UAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C59DF3EA63;
	Wed, 10 Dec 2025 00:38:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +gEjEPjAOGl2dwAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 10 Dec 2025 00:38:16 +0000
Message-ID: <b23da846-ff6e-4b73-9691-beb14ceb0fa5@suse.de>
Date: Wed, 10 Dec 2025 01:38:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 1/3] filemap: set max order to be min order if THP is
 disabled
To: Pankaj Raghav <kernel@pankajraghav.com>,
 Pankaj Raghav <p.raghav@samsung.com>, Suren Baghdasaryan
 <surenb@google.com>, Mike Rapoport <rppt@kernel.org>,
 David Hildenbrand <david@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Michal Hocko <mhocko@suse.com>, Lance Yang <lance.yang@linux.dev>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Nico Pache <npache@redhat.com>, Zi Yan <ziy@nvidia.com>,
 Vlastimil Babka <vbabka@suse.cz>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 mcgrof@kernel.org, gost.dev@samsung.com, tytso@mit.edu
References: <20251206030858.1418814-1-p.raghav@samsung.com>
 <20251206030858.1418814-2-p.raghav@samsung.com>
 <d395cf62-2066-4965-87e6-823a7bbde775@suse.de>
 <3ced3736-81e8-4bc3-b5a3-50ac4af3536c@pankajraghav.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <3ced3736-81e8-4bc3-b5a3-50ac4af3536c@pankajraghav.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 27F77C0009
X-Stat-Signature: urn8hfgzq1g51gp7acie8bd7ekt6kha9
X-Rspam-User: 
X-HE-Tag: 1765327109-451842
X-HE-Meta: U2FsdGVkX18JN0L611lB/r3Uj1a8EP+Es2xJzTWT63teXyDHOeax0yvmpfwGlKv12lInZACkjKe5Fhcv/uhd1Z1uzsYPuGoC25qxDCeUOApue3AfqziRHEXrurUmLDIdv4yc94sySvEBS+7+MJmWb/7HczIS3RwsBHvRAsLhpaVrxVrZWbeaxd55t849uZNOwh6KVuGgbS7+gYNiAb/QO8y90mrnTBUvuKRtr7XSi99+dM5VS44biXix0jqnIcac76eSmzF63WeUcQtIqn/h7wHHXHaBbs4U9olghrJtlFMKH4n0c5tEgH2GdM6BP8nH+LfeERsuCtqf5+Xxz6WitRJhQ+Ra6QMmdJsQSaMofNiuOjmuCdWzphL5Wysv8qdgYPEnULTdWPhFdhp9m2eKZwGG+oGy+LKKVJQvdlxt39kddRj/roUbK4fG3B0LyXzXxPi+QnF4q+AyWWqBZ4L0emHBMBk8RL4zYwn4u+vvg9HIu8nOjouZK9ZgIWlEVFJ1WxRmVnb2O05hVcCgI54qQlkfvf727QGxsNHk2eT+XX4hIDTE78XgH63G6S0DbSyKLf7+JqxofB75MUR7l0zDAzFk5QXjiy8iEUsYHnD1XhxaGBastQKsWEKRVXlZ/jtKn1ddDYHgCC2Cc+NipOg16yI+acwh/RBDaFewvtja50mNuYHpricqrgct+KgDmYJmv8PAWtxn4i8xyoFO1f20og501kdEZKz2wEcIbrnL3leVNTLZvvSSoLnL3x7oz5OsjaDvCq9OVJf7NdYECIVn8to+RBbp7KPQcYDYJ3iWYAChExjZUz7DSpHI6KheO8enL4QAJzIxCyfgLJglUYZKoOZkqBg6vqptPllZ5XybWhyvg8rMRZEWbU7JnOIyRHd5IPUkt+sf3O+xUZmjIYBy1Ed8Oym9jb6CiL1AWqKcR4DGseiPSz1M6lwcaFL9djxA3lyQVaQTjDnqD+DkV3n
 9YAuA+np
 hm68UXUH/Y7cbUKwnJ/gkjGxDVCAwOOVayIsOsEMU67I+gIL2x6ZpURo0rHHQl8/75zQFlzZl5IB1vXaKotIpHP6Kd8eHRdw9HrQfHj3EflQ2h7HTpSk7U0XtgeOp2CQuSGyMvLuIy1E//uqv8g2rH7wdBdNd89xgpvBXZJVhIoCRQM53qFUl0eq+aXoZeQrs7i5+c2mm2lt1T/Rak9zWKvoOKK2XcMtwqECf6v8nSi9jPt97wsOkbNL9Vci+HQkHUit+FBFU7axfwrKjKgFXKxJYZbfADB0Lcf8omltnuB9R28ABbRfsKWiE4pRQB3df61Rg9gbeeExiO4s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/9/25 17:33, Pankaj Raghav wrote:
> On 12/9/25 13:15, Hannes Reinecke wrote:
>> On 12/6/25 04:08, Pankaj Raghav wrote:
>>> Large folios in the page cache depend on the splitting infrastructure from
>>> THP. To remove the dependency between large folios and
>>> CONFIG_TRANSPARENT_HUGEPAGE, set the min order == max order if THP is
>>> disabled. This will make sure the splitting code will not be required
>>> when THP is disabled, therefore, removing the dependency between large
>>> folios and THP.
>>>
>> The description is actually misleading.
>> It's not that you remove the dependency from THP for large folios
>> _in general_ (the CONFIG_THP is retained in this patch).
>> Rather you remove the dependency for large folios _for the block layer_.
>> And that should be make explicit in the description, otherwise the
>> description and the patch doesn't match.
>>
> 
> Hmm, that is not what I am doing. This has nothing to do with the block layer directly.
> I mentioned this in the cover letter but I can reiterate it again.
> 
> Large folios depended on THP infrastructure when it was introduced. When we added added LBS support
> to the block layer, we introduced an indirect dependency on CONFIG_THP. When we disabled config_THP
> and had a block device logical block size > page size, we ran into a panic.
> 
> That was fixed here[1].
> 
Yes, and no. That patch limited the maximum blocksize without THP to 4k,
so effectively disabling LBS.

> If this patch is upstreamed, then we can disable THP but still have a LBS drive attached without any
> issues.
> 
But this is what I meant. We do _not_ disable the dependency on THP for
LBS, we just remove checks for the config option itself in the block 
layer code. The actual dependency on THP will remain as LBS will only
be supported if THP is enabled.

> Baolin added another CONFIG_THP block in ext4 [2]. With this support, we don't need to sprinkle THP
> where file backed large folios are used.
> 
> Happy to discuss this in LPC (if you are attending)!
> 
The very first presentation on the first day in the CXL track. Yes :-)
Let's discuss there; would love to figure out if we cannot remove the
actual dependency on THP, too.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

