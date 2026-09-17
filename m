Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D751C982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 10:18:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 473E86B0098; Thu, 17 Sep 2026 06:18:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 425D86B009B; Thu, 17 Sep 2026 06:18:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33BC76B009D; Thu, 17 Sep 2026 06:18:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0E6C16B0098
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:18:04 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 62BC5A02EE
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 10:18:03 +0000 (UTC)
X-FDA: 85222853646.08.472D3A2
Received: from mta0.migadu.com (out-144.mta0.migadu.com [91.218.175.144])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3DB81100004
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 10:18:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Lmbcvlxa;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.144 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789640281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X443I1m6NVZaZuXgr2Ck1DkA3WUgWOnaMbaSo3syV70=;
	b=3UNaiPmw1QXQKmVxfPg5enUF9nX58PMGzXBGg+L+lI5f2nHntrWVtXeCiTxdQUs3g8Vcc0
	cpOh39pzSYxHE0SoK0vueFiTTeCBwGseZmaLp4EdYfBKbreXd1H7tk0yPglrCi3PC8IBSU
	LvFpqkMqsNwMXgkmSTCPSV3xW6OhlcM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789640281;
	b=OijAxbl7tc4sn8s05HFYwJSZbTfyHH+5IwYuIHaeY30V72eWP8pGb59Wqqe0+xyeeW2ZHH
	J0giiMAf2a4CkIhJso7venKcI9D2495Tl5XJDtxADSnmq7e1uJIz6pRMHK7Y9mNEIveAOA
	qLzQRVAaGb0m/jY/sr6gHxQv8jPrX30=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Lmbcvlxa;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.144 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=DIFoReXqzCCEdyzOnHZyO/KDl68bNqQoPzIWJqoTfqE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789640279; v=1; x=1790245079;
 b=LmbcvlxaUExQL4VcOJKr+GUiLIlTdT/2R4qkbzkUCRVM0EDI80cHZqHr0brrZyH4Z4oP3n3h
 WiBzCSzR7l+OpFxsq+xU2tFy3I3YxjbClsuGx2Wm56B7XoNE52Owm1HpLY0qH2GUqMx7JblLwT/
 OE2HhM700apRuS4hHy0xm04Y=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 8f42acc8c86f58c5;
	Thu, 17 Sep 2026 10:17:59 +0000
X-Mizu-Trace-ID: 8f42acc8c86f58c5
X-Migadu-Flow: FLOW_OUT
Message-ID: <534d67fb-8b5c-455b-ab75-cfc5c73e677a@linux.dev>
Date: Thu, 17 Sep 2026 18:17:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: hongfu.li@linux.dev, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 Kees Cook <kees@kernel.org>, Colin Ian King <colin.i.king@gmail.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, Mina Almasry
 <almasrymina@google.com>, Mike Kravetz <mike.kravetz@oracle.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Hongfu Li <lihongfu@kylinos.cn>, stable@vger.kernel.org
Subject: Re: [PATCH 0/2] mm/hugetlb_cgroup: move the per-node usage along with
 the folio
To: Andrew Morton <akpm@linux-foundation.org>
References: <20260916-for-hugetlb-charge-v1-0-70fb708b2e4a@kylinos.cn>
 <20260916175302.be1e68f24b96b7c639cbd7f5@linux-foundation.org>
From: Hongfu Li <hongfu.li@linux.dev>
In-Reply-To: <20260916175302.be1e68f24b96b7c639cbd7f5@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3DB81100004
X-Stat-Signature: ax5jmkfwxq4ah8fsbi9d4og6tojhtpz5
X-HE-Tag: 1789640281-316212
X-HE-Meta: U2FsdGVkX1/Z3hP6I+mfdhUIksfpf2UzebiTzLvtd0ysqVPLOhzyOUsv0y2cZcmRFLrmB1EMX/olWZA53Xi8NQB0m90W/fzXlrZu8hYJw0kMgydEgZpudRAUIoMd7hthnpAzJr9roWup7ZFRboGKITn3ehfqvTTt2tyhB7ZIml/4lQhPrNOK9zvC9arkLRNmPZQjFAxcBNi9YcXiIMw+6nthuEa8IBmsjrhuwpuwsNzjCA7R02KgznD1rx0pb06cDgfasJj6boNgj5sd0/Ijcv2l3aiADvG0D54uFmOK5WOJqA6lpOXQ/0M8A8S0/EiBsuhU61GdModLnOL3K0nfPFiq09NC4n41nDBFiXacYRf8HIyQbpTMw40ZDLnWxLAVLu3TM6gup++0il7tEkYcfzSEQ1kpAEo4haJrRk9XXm95eWm6jyKstrw0wATzreHY5bQREKcExYkrdQS9ORrvJA8hT8XMYXsqe/Beatpn7SUExSok0FiUVt/tC6Zcuf2C0UpgjtGoy3wdzRmgBQrqLWO0/SyO65sxbwhmrbWTKErSgu8cTXAyFiQlTJu5z+HcH2d+djpeZTiN1E82ebHaGMMzIgR9lLGLqW3uCcWXX8ZtKKMv/kpr36AzqJV/Ce9DOJVxkLUFKxvQ0gmLvtSvZePs6Vr3yaMDNQpPxkxbiJtOVWNYWdShDS9Q7ZN0OavKDD4eLzrPVGyqlgMNXTtBsmtPynZ6XSNTBJDcAOlLH59ZuW/BZhGk0JGd3Lqb/1mX5Mq6FJjAP1/1eQPTXjoqXMkXL4dp3mtI7oCimSpBEbwCfvttE4rwayF4x+dnnLMQ69mHROf6BggDQXbfH1L9Z/w5dKzctjYK49ATuUahJgpHxffNXGUJgyoGCHPuLgvtX7dL6d1zZH/d+gWecw2XOYOiN5fJJJtGl38wfD5bHtzZDeDXyLsndjpekceoz4kzdeqWvEmG7u7rBj7VscM
 jXOBIFZd
 cTorb73Alk7FahVpj8amMq9bihukQutmtAX1sGA+K0sKHYERPOhpf6BSQvrhM0Lm+eLRPgD5aV20UBWQGrwIVF4wydIH9Pr+Z6pf8TkxTBN+olEXx8FNth3i5HNnrLbSU3BC1BxfbgHbT8ndgIbS0kgtRW4NFc8qbRfJgG0seEgRuK9BDYDCMpytJOQSMhuohf6UeknVXc5jsUFjAc/XrTAyU50DCbiSdPFHg3Vp9iTshgZSwCHwimP7VnBPWUpkPftx3q2lvu9xbf3bnVGqIKNbURQeTvtUAyhir1Dqs1gVtX+F/AssEHKQL7EaI/weumPgx4LVKa583jujzGZNSHZjlwRFPEzdXz95xNqB+Xgll2uh/zlUDGM2OfIpntKm89low8BjSRUZytjsvr9+Cn4BTuQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 9/17/26 8:53 AM, Andrew Morton wrote:
> On Wed, 16 Sep 2026 16:30:26 +0800 Hongfu Li <hongfu.li@linux.dev> wrote:
>
>> The per-node usage reported by hugetlb.<size>.numa_stat is accounted
>> against folio_nid() in __hugetlb_cgroup_commit_charge() and
>> __hugetlb_cgroup_uncharge_folio(), so it is only correct while a folio
>> stays charged on the same node and in the same hugetlb_cgroup.
>>
>> Two paths move a folio which stays charged, and neither moves the usage
>> with it. hugetlb_cgroup_migrate() only moves the hugetlb_cgroup pointers
>> of a folio migrated to another node, and hugetlb_cgroup_move_parent()
>> only moves the page_counter charges and the hugetlb_cgroup pointer of
>> the folios of a dying cgroup. In both cases the node (or cgroup) which
>> was charged keeps a usage which never goes away, while the node
>> (or cgroup) which ends up uncharging the folio underflows as soon as
>> the folio is freed.
>>
>> Patch 1/2 moves the usage along with the folio on cross node migration,
>> patch 2/2 does the same for the folios a dying cgroup reparents.
> As I understand it, this series affects numa_stat output but has no
> actual runtime effects?

Yes, that's right. The per-node usage[] is only read by
hugetlb_cgroup_read_numa_stat(), so this series only fixes the values
reported in hugetlb.<size>.numa_stat. It has no effect on charging or
limit enforcement, which go through page_counter and are already
handled correctly by hugetlb_cgroup_migrate() and
hugetlb_cgroup_move_parent().

>
> Do you (and maintainers) think that we should fix this in earlier
> kernels?
>
> (I do - a lot of userspace infrastructure makes expensive decisions
> based on this sort of info).

I agree with you that this should go to stable.

Patch 1/2 and Patch 2/2 already carry Fixes: and Cc: stable tags.

-- 
Best regards,
Hongfu


