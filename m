Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E6B5E9DE62
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 08:22:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 580F06B0005; Thu,  9 Apr 2026 04:22:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 531E36B0088; Thu,  9 Apr 2026 04:22:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 447606B008A; Thu,  9 Apr 2026 04:22:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 33F436B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 04:22:00 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D4AB8592E1
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 08:21:59 +0000 (UTC)
X-FDA: 84638324358.05.D5353C7
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf21.hostedemail.com (Postfix) with ESMTP id 46E9C1C0009
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 08:21:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="dim/9D+M";
	spf=pass (imf21.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775722918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ZlzV1lahyhPp5qrzpmqEvqVy8chzzw12TKhbe+CN4U=;
	b=QIMffVr4UP6GAX8ggklS9RnlF3Pq1JZN3iwOEdhcUyo9p2YgBlqAFJRdDk/q4r/bTJ1dnr
	iheOgpiv1QfgLPRS1i726z0VZoX6OpcVAQzsGhNAJ7mACK6jQS6D52fDh7f5PhgS0qqR+W
	yTUnNCOd3tv3MPhcjZWtsgRngysh7dc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="dim/9D+M";
	spf=pass (imf21.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775722918; a=rsa-sha256;
	cv=none;
	b=nNxIw9Uz5v8pwQ3NTogVIwn+2a/p1k6BSHrRgi3gnKZuocxfzn8LfEDDpkNupLjObIKXdA
	SA2sswrR6qRu0hXb0CaZ154TxFST++67g/oaBMkwy3HaYWYnwaORXwAtwhR9iohulTBudP
	r9MfhrLFUkfxm54aGUbt7p3nJaVW5oo=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=/ZlzV1lahyhPp5qrzpmqEvqVy8chzzw12TKhbe+CN4U=;
	b=dim/9D+M2GD9R4GhDwj+ZpwfpOH4fyiOOmIVuBzFLQZjzqAqqxGdOpBsR3yeu/e5JZCvEnx3+
	JtUWTg1cG2YUZsexEXFAPseukS5VzNAtBccmuouasTh96zwKbA1e4kod3akFNUmcfY9iKnx497E
	LnFegr1QictsYhTPjHvhkFo=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4frt6H6sjwz1cySK;
	Thu,  9 Apr 2026 16:15:35 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id CA48B4056C;
	Thu,  9 Apr 2026 16:21:49 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 9 Apr 2026 16:21:48 +0800
Message-ID: <f8eec130-efe5-4e08-b5b4-a9701ccc7056@huawei.com>
Date: Thu, 9 Apr 2026 16:21:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] fs: drop_caches: introduce per-node drop_caches
 interface
To: Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>
CC: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Christian Brauner <brauner@kernel.org>, Alexander Viro
	<viro@zeniv.linux.org.uk>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Vlastimil
 Babka <vbabka@kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>
References: <20260409063503.3475420-1-wangkefeng.wang@huawei.com>
 <addP4MKmA8zfSN1o@tiehlicka> <addRr9Vn_LNiXp11@lucifer>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <addRr9Vn_LNiXp11@lucifer>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 46E9C1C0009
X-Stat-Signature: u56kz8r4r1se1mh9tz1b8w7735eca9z3
X-Rspam-User: 
X-HE-Tag: 1775722915-175387
X-HE-Meta: U2FsdGVkX187+KfydQE4dNndHlHFIkdwmBcLKHrPuzq/I1/DlRVb9xXLOYMocSPAzDh3MbwzWtoc412Ki6hx+aICvZCbrowV9gxNxHIELQPGzyenQ/dA5MQKWrlbeIojMhi9tHt84W7UHPJgaRLI8SXfeCE0+lSf5It7/kNLqfbZTVIkYioHYt2w4weHCTclPz6FEhFXqrZ+FMGe/I4bNdXBlqTInwHnF00uSBsNM1rCgBDwhYn9OqEhrEYJTnLiIE92HtWQW5/Bk8wHu78COFt2MFRW3Eu0c2JQK9cy/tSpgjLecdGn6lisL80ay/iQ4usnoJ6pDvONDt5WjM+HtwnGcPBRb3D0uRvs5XiFcPkkBxKZelJJCunZsFZeEoI/V5m33ZcN+fEFWjKpEe6O7hrvQgsa7U0YG0/txTKJ8EEqEWGxwYYEQ2HYckJsHPSVqj1bNOoGIENJSvenPb1zNdAH7nIIET0k+bNhbw5jFneKgOFbPCemxqEB/aVmdGWG/oyOekoxfi2knewnSwDnbNTGqrKW5WWYc15OAwtseAKavF41Ks5pQNAHuoigOcOVjBMi4UB/cWXQmLaDDajdt3j8Uv/jjxR1bl5xQo1Xi9oI1DqrY0Gc2uae46td1LyvstEi0EE+LUa54SUkTqWlsjOZ6SkyIVUBoBmMpKgKOes7XAkG6k8Lbnp4NS6K3b4S276ffNb7SRGt3vKyWMN4zwpBpoGiEdROJb0PABcRDL/tuk3P03WGOIgVZKXT6X5ESa1l3NtXFCI8LrrkgCLDXo7O5n68HhkYNqYe3ifh8T4oAzeH59Bf/cKncwFkLAQZS8jQSbuZ782Xn5WiszfW3kLfpRCw/EksroiPyvCpVYevGXuY29NysUgkI2fLQ0DKQuNc/indbWWdmR1sFRuNbrjxuskVHHTE/k+qW9sXGC36LpCwZ+NN97KPxODabEDP6/NnykzvD8Q75KabLe9
 a8OMzLM6
 gTPodTJ+QxeBBMLje9ip62yWZxuQl/AYH77TOcgcSZhNXj0EQQGZgNPLIbVJgJJkR+dnobo7AdikpKzpGFFLWa13emIGlv7EfaPz7nJWykxsX9FNewt3O5l+Pwefp4oI3si/79nNQwyIGtestsMNmnsD3nKkiigSqJIjysnGeAccvdtpYFUVwF3LdRbCKZ3zG/i+wVz6L/996MOzUPcZGpHQ6PasEOEtI20YbWqIghoEf77clDrLmVbKidH6+CR1mxZhv8R4kA118faumld56HobEKzgFmRLqyoNf8Pi/FLDS7nQAiGREfn5A90mzFp2DI0z5O1dKLBMtCJx6dPhF4mHUrsfTYOfKeJIpHG7CrOGk238=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/9/2026 3:19 PM, Lorenzo Stoakes wrote:
> On Thu, Apr 09, 2026 at 09:06:08AM +0200, Michal Hocko wrote:
>> On Thu 09-04-26 14:35:03, Kefeng Wang wrote:
>>> Add a sysfs interface at /sys/devices/system/node/nodeX/drop_caches
>>> to allow dropping caches on a specific NUMA node.
>>>
>>> The existing global drop_caches mechanism (/proc/sys/vm/drop_caches)
>>> operates across all NUMA nodes indiscriminately, causing,
>>> - Unnecessary eviction of hot cache on some nodes
>>> - Performance degradation for applications with NUMA affinity
>>> - Long times spent on large systems with lots of memory
>>>
>>> By exposing a per-node interface, admistrator can,
>>> - Target specific nodes experiencing memory pressure
>>> - Preserve cache on unaffected nodes
>>> - Perform reclamation with finer granularity
>>
>> Quite honestly drop_caches is not the best interface to build any new
>> functionality on top of. It has backfired a lot in the past and we have
>> tried to make it extra clear that this should be used for debugging
>> purposes only. Extending it further sounds like a bad step.
> 
> Agreed, there is still _huge_ confusion out there as to what this is for.
> 
> (If I hear another person tell me this is a way to 'free up memory' I'll scream
> :)
> 
> Really I think it should be seen as a legacy thing for, as Michal says,
> debug purposes (it would have been a good idea to put this in debugfs tbh).
> 
> And adding something to sysfs as a permanent, maintained interface for this
> purpose seems problematic.
> 
> What is the use-case for this? Why are you dropping the caches? Presumably
> for debugging/perf measuring/etc. purposes? The cover letter is lacking
> that.

Our use case is as follows, for hot-pluggable nodes, for anon pages,
migrating them to other nodes, but for pagecaches, just evicting them
since pages could be refaulted. For mem-tiering, a large amount of cold
memory is stored in the low tier, we think that evicting pagecache is
better than migrating them back to high tier, also this avoid the risk
of accessing potentially faulty memory.


> 
> I wonder, if this is something we should move forward with, whether we
> might be better off putting it in debugfs as a result?
> 
>>
>>> One use cases is hot-pluggable NUMA nodes, during hot-remove, simply
>>> dropping pagecache is far more efficient than migrating large amounts
>>> of pages to other nodes, which also eliminating the risk of accessing
>>> potentially faulty memory.
>>
>> Does the per-node reclaim interface can help with this by
>> any means?
>>
>> --
>> Michal Hocko
>> SUSE Labs
> 
> Thanks, Lorenzo


