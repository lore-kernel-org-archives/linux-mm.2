Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B68DCCA470
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 01:56:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A5E88E0006; Sun,  5 Oct 2025 21:56:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52F1A8E0002; Sun,  5 Oct 2025 21:56:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41E658E0006; Sun,  5 Oct 2025 21:56:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2A53A8E0002
	for <linux-mm@kvack.org>; Sun,  5 Oct 2025 21:56:10 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A7854140420
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 01:56:09 +0000 (UTC)
X-FDA: 83966024058.22.A7C8D82
Received: from sender4-op-o12.zoho.com (sender4-op-o12.zoho.com [136.143.188.12])
	by imf05.hostedemail.com (Postfix) with ESMTP id AC05A100006
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 01:56:07 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=yukuai.org.cn header.s=zmail header.b=Q88TO4KN;
	spf=pass (imf05.hostedemail.com: domain of hailan@yukuai.org.cn designates 136.143.188.12 as permitted sender) smtp.mailfrom=hailan@yukuai.org.cn;
	dmarc=permerror reason="Multiple policies defined in DNS" header.from=yukuai.org.cn (policy=permerror);
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759715768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3FYkDME2ofzqETRfDXyqVTaDE3sgIA+Dr49WTIoXzWs=;
	b=2Q/m9oYd7ohhf4QeBYx68sQdx2Q2PT1QjYW8hSRgFRe39Pi6qY2eoSpLMaDQUb8h1XbBaG
	2VhTRaJaDxiP63A+bKroO982LH+q+Kr3bBBs0zg1qW20PUr6fQ3eSGvfwzqDRtEtHHIa2C
	iQF6St6XIBA08IsP8DMqTwwo3RJJjAk=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=yukuai.org.cn header.s=zmail header.b=Q88TO4KN;
	spf=pass (imf05.hostedemail.com: domain of hailan@yukuai.org.cn designates 136.143.188.12 as permitted sender) smtp.mailfrom=hailan@yukuai.org.cn;
	dmarc=permerror reason="Multiple policies defined in DNS" header.from=yukuai.org.cn (policy=permerror);
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759715768; a=rsa-sha256;
	cv=pass;
	b=kd5AFyRiJtFyZK9TxH8qBbFNGLf8gNvMc10pwDNEHQuVrNJcJlBwdC1ReVHgWtYGmxQEbL
	ACn65sT40InFRy2N1QYN3wF/ITC1m9dB2xTnFxqVDbjFpL6lMWlr70+vEw+8aR6LhQlwJN
	hHvrgbmCA39Td8Is4PUE9qJLpDkuNMk=
ARC-Seal: i=1; a=rsa-sha256; t=1759715753; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Ps9P7sGt3jM/G0pQ3sKHhIRZf6ZI1UPcYjAtC1BEvT2n9IvTa67uZBU5AyrXI6PTg15f4vqjhmbWtyIvPP9VvBP7IhI+yzi86XyneGxpo4oIhWFijFwYFVZFOgPuL8NjWyK2l6+hUm2wDT5CqVAEDE+89y+RtHzPsil419kuxHU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1759715753; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=3FYkDME2ofzqETRfDXyqVTaDE3sgIA+Dr49WTIoXzWs=; 
	b=RxP+Suk7//sB+Wwsseogzeqvdto5otHP5O6Was6IkpEXjEkqfhnIlPGOm6NkCcgmNbU5C2VUWjN9wzZko6Q8J91FBUOnsuksMzVFP8mfN+5LZK6G5QWTXGX+SUM1moWkLQ+zjX7DqzavJ0PoFx+p+27L8r77v9dYEUZfk6+kZDw=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=yukuai.org.cn;
	spf=pass  smtp.mailfrom=hailan@yukuai.org.cn;
	dmarc=pass header.from=<hailan@yukuai.org.cn>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1759715753;
	s=zmail; d=yukuai.org.cn; i=hailan@yukuai.org.cn;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=3FYkDME2ofzqETRfDXyqVTaDE3sgIA+Dr49WTIoXzWs=;
	b=Q88TO4KN/EuxHymJfTgTxilqoTOB8G4sTbVVD/ImBv+uTeow5/z1W5m/FDw2t6YB
	5vtdh7DJ3qE/p6qnkUzto8a62B9GD7aNRL+PbhLFjLOE7uZa/ks9P8ZR5NZKC3gi5VC
	yhRTbMYq/bxUzibE+yJwnqhl72VCrs9i1i/5HFAg=
Received: by mx.zohomail.com with SMTPS id 1759715749848263.4345026807009;
	Sun, 5 Oct 2025 18:55:49 -0700 (PDT)
Message-ID: <497b2eb9-a214-4887-ac89-bd2ddff3cb7d@yukuai.org.cn>
Date: Mon, 6 Oct 2025 09:55:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/10] blk-cgroup: remove radix_tree_preload()
To: Christoph Hellwig <hch@lst.de>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: tj@kernel.org, ming.lei@redhat.com, nilay@linux.ibm.com,
 josef@toxicpanda.com, axboe@kernel.dk, akpm@linux-foundation.org,
 vgoyal@redhat.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, yukuai3@huawei.com,
 yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com
References: <20250925081525.700639-1-yukuai1@huaweicloud.com>
 <20250925081525.700639-9-yukuai1@huaweicloud.com>
 <20251003073724.GA12933@lst.de>
From: Yu Kuai <hailan@yukuai.org.cn>
In-Reply-To: <20251003073724.GA12933@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AC05A100006
X-Stat-Signature: o56xhoz4ejb1asom3t1ekz48df3cak5s
X-HE-Tag: 1759715767-321789
X-HE-Meta: U2FsdGVkX18P/uyLRylnFTJ8LKj0i6JRRFib2suQNP272wGU6Q4EmtGGZmDPBPm8lXrXhHVKtB2O71qk4INlnfDi+IxwpMEoomDeuh4vGZY3m3BBGaMeoWp5My9h9Uo5vLPGJuLWAQaSHTw+6PMVAeQScMRt6vlRN/plLNud1zCU+RHpXmvbmtRrWv59Bh4+hAHPL+G/UL5BeNc1BcUgMDzLOlxP65m2ISg9pKKeq6DCgB7OzlMBFWUbO1sjkbo0SXqPvsJQjmosoBIe7n1tUcQ6kk61l66mOAjB0nLhw3U/o4L20Mgbeb5oSJiymEdNKIwGX/E3+oeLzxZjbqHjhozMdTon1f8bgu9sR7HDLs9Tc37VPdYw7fq70f2PECQJceE2FhHrRmw+a3lS0NmFqJvx63na+6wZ4BHwM+O+EGyxgfpptM+GnO6eEjsZgdCeG91WbH1NmWtCncjgDQtWqIX5SHodMe1DFmsSsQZnFvYkjd7N/KBEFbNEN5liMvcULTWX3yWp85eRYCTUECskLLmDxaiLSRuAmdjZ7HrMTlnGdsg51zILV7ABMgfUnTIXj/wIq7+bVO1V/SqKxt1r6ya5TqSkbG5eZ5w7sqRgqpREEI7OVkjk3pSjmEzAMtUPTePEHXVwaoiaFQjYd3EpewmHMLsx87FQCR+62b/gIMPtSPNztOfEquCCUrSdtDlphnmc7hmQAjhwruvZOZqumIQn1X3z8V2a7UqS4gTEYsJzIy6dfoqEw5/biNPGmD2Nad4jB+/SiUAlDn/TRPhaLnxFE3ZhrJvobud3Itsrq08HHPdbIQe3/1cbDHLpMzT3JTjd7z+fiVAHmWPa36ZcCzsEHimrsB02viR+RwcGWX1eLEvUwvVxpqMfZhYCis5bZS1NFBZaWqL9go6ob0Jh1RYVRBNR+D3iI9cZvf/vuz/5f14fyfzyUefjYyoql8v9WGfkMilGXm+GLPPPfnt
 +xlDBZvN
 kEeAh7AOmjvirloMHNSbmM8uFg5HuYinPq7CesiIobqGx/mF7/hx8YVSlWNOmkjBo3sKHTU2dLPAEiZ2P3E8IZwicy9i6IuCJLR1RktgXfzg64gV9kqLXCjokclozoX+/2itrSVIwqlpU2IGm7uWFXAzzF/HQAsNV36TeM2Idunr0EqmOOvaLgYi8tyRYbL3lhj2LSHiJZylKEIsIt0ytRSaahHtZdAfBlC0eu8aBIxi5eOZJKKkdhH7CLePeZbsgwWSs8ud7CjaJzqQ/cEuoMUc4sO9MAxmqEzLIo8Sr1bxpu5SrlxqKRDs9GGIgdNrG3wWLYKK+YM+olpxBZjodGhOHPRv31fH1NrdF21W+t+zMV5CmQN830+FJFfwBtwp6CNIBDAFR7x4stKYTVBZAQZ0rDlXT6UubquYX0HPETC+848mysC9x9wUF7aT2z/LUhD6KLB8c2UqqvlyxgzWlpGgJa3EuZqCAzFwwpPkk0OOTcoVJrn9H45DwjyObYdsgFdMvuIEZyKLGiL879XN1Aq3d8XG3nOBwH3kR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000278, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

在 2025/10/3 15:37, Christoph Hellwig 写道:
> On Thu, Sep 25, 2025 at 04:15:23PM +0800, Yu Kuai wrote:
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> Now that blkcg_mutex is used to protect blkgs, memory allocation no
>> longer need to be non-blocking, this is not needed.
> Btw, this might also be a good time to convert from the old radix tree
> to an xarray.
>
Sure, I can do that, perhaps after this set and cleanup blkg_conf_prep apis.

Thanks,
Kuai


